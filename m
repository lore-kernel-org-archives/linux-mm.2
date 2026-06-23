Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C6DCDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4176B0088; Mon, 22 Jun 2026 20:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883EB6B008A; Mon, 22 Jun 2026 20:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772406B008C; Mon, 22 Jun 2026 20:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 466A96B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:40:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6EF78D29D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:40:23 +0000 (UTC)
X-FDA: 84909321126.18.99D2E8D
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id E0A6F40003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:40:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OReJsq1O;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782175221;
	b=x4Zia8GSUaCCkRTL0/ocFCOE6domSkVVWYT3MLxHVUXiLQRxMP5VfAJBJ9rMWu7ACij9PI
	p7qn0yKB3ZLBjCNd2UX2s/Ua6et0lM1NyQ4LIAA4hAgIN1H8HgkcS75qYMf5PmGayAUZyc
	C0hkHMjHlIhC0aaNDIL8g/Wjhoh7uV0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782175221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2f1vIQGRwaVINXfqVMqUzfca2k+PegWVGEvoxiBw6w=;
	b=jddB2LrqKFkFsrCbfO/18pl1PeYv23MWuhhtrvC7WcCiwG0heJqQWJ4uqC0mUg3DeEj013
	IFi379ssrFShwDFkWg5gVf+XY0YRhC5q21JnQTEf9Da+u4tCwo/FHpufuTvtafigTEFlwS
	B9A1Yo9rND5UHXzfKkIixXD30ofKL+Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OReJsq1O;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6a0e075cfafso1452729eaf.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782175221; x=1782780021; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n2f1vIQGRwaVINXfqVMqUzfca2k+PegWVGEvoxiBw6w=;
        b=OReJsq1OiXd8APU7eo3cd8iYzS+H1v2Ppmn140qaFSSStLpARsoUgH6p8T7oPORCmA
         J8EH8DAcSLPvSrLluhrLy0yPuHDI3wIvlq6vh/0qvWtSKD0ZmlpbaKZ5XdGtmvo5k3Xz
         NbEE7pKON7L8DkA8N4G9CIzlAzKea4hOdebM3eWqKBX0YrLmnNp/dKE1R4G3+eJtB48u
         wCVdxWVL1/kshkJFABaclH+x02yzJ79rQYmVTbUPkWIyDlVIVtqzm0EoQeVR6IZRY0pP
         GVikBI9ouyIRdFYktNiF3lDgVzowHzmqN/E5QBJfCe0GMJyGMUd5PZjiaZWZtP5rWewa
         buUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782175221; x=1782780021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n2f1vIQGRwaVINXfqVMqUzfca2k+PegWVGEvoxiBw6w=;
        b=BAPlvr/GoZssaBioBOtugrlMNlOTK12HywMZlDUgFwmWfFUoJMMDcRRg1GJlae+qYb
         /gZDoPg5FPeTRlrWB68EjH4mAutKnf+R9az8bMAqA6MiB17lDh9Mv9HuQm3jHO+vLvCX
         jWu2VEK0R4oeUQ1eqFIph4ZkvfP3p11y77s8Yv0yBU8IuJcSPW2qdSvRpb3IpvXpA15Y
         YbyPTnNIjXbBpeS+mn/at4uO8HMh1rcBf6eXFkg++7Dajz7g2CAd/pKsI2KQxrMNcQAd
         q+YwB8X5/lNBciZi/ickppyBBEDCrWYWHwkeSU3Wk46nQJRL9GswnGrQeq3rR7M+XE1M
         zy3A==
X-Forwarded-Encrypted: i=1; AFNElJ/f4KOumF6T/6Adaka9SdeR6RgQOev9MV6R+keUP5ww+36EEgIyfkxuRxajShvfe2h8FOponFNK0Q==@kvack.org
X-Gm-Message-State: AOJu0Yy3MonpEyqSv8/Hcn4XyUMf89v+tUaJ1YdrTHASxY5VRQ8rb2C5
	GqypJJsDMpSHtOmjiOTPmIeAlkQzimSRXIkXybCg+jEAFkLtiqSu4GmF
X-Gm-Gg: AfdE7cm43QTKl5zjsVj18Ex+a0g7X9jkzVtlW3V8f8+UEPmZDeaIBFz0eRpDWKsB2AW
	obDohdwcY7ms/cYp8eQl4C5oCiPev7rfyuWVzRJdirhwLoedULHYYk9S8LDA8igsP/fbNx9iUqt
	XbrcylETtnym2t4MjuqpnhV+pqyF8Z9RweCWC905jFhaMtjaRb58ukKPHnq0qCxG7px9skhOXK0
	9Fy0v4E2TFbupzbesMzjpccADdYWmXsom2mTztYLxitfCmb3GIYgadHqEHsB5z+CFEXxqlXJzk2
	hj9sxAXKoYbjzuYdJpo0gTziqQUpT9NwhuZtJYEK4z3K57Dx53I3uneezq3nzi54FBZsJDWbuyN
	Mamk/d91lKcFB4vVZs2vFFd1bQ2g8ML6TQxTIEIBldlhnK3l8ZycFidhV1oQ4odHa8ZfDck5WlH
	QRsyzYmdB7xi5lBhoiVlWK9uGqHfXoy3R2o76gNwxxHTG3poujbtX4Dg==
X-Received: by 2002:a05:6820:16ab:b0:694:a1d1:f363 with SMTP id 006d021491bc7-6a114b59217mr673249eaf.15.1782175220586;
        Mon, 22 Jun 2026 17:40:20 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472f0475e3sm7140080fac.16.2026.06.22.17.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 17:40:20 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
Date: Mon, 22 Jun 2026 17:40:17 -0700
Message-ID: <20260623004018.1864121-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ajnIasdb6j6yDUdy@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4ez815xz4jnsoyfgkk1rmjniw36wdyit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E0A6F40003
X-HE-Tag: 1782175221-210315
X-HE-Meta: U2FsdGVkX18f9CGbCOZ9dFaoWEFkDIEcN5LSIa04QWKYkYREsScKkmXnT3wYv5Q3AJ2748Ka91d74zBUX5gjB4RrFzZkRpO4gOk7T452kH6lenTX1eggAbchKDJ+9aumvp6Jh9sGXyLJRX7QZIS9JKEcWWMGdTO0TOGjEXYbgr5dAHucKhfJZPbbAJtuDkfovKkH4NN3H1HS7zMZ2X6CXjCvROcekoUK3i8c6+Ck7ZQQXuFPJdFPYcV8dBJtmZwwbp8BBsBPu1Hcf24mkWHNdtNAyrduQf62PUbOCVwM22chrPxFcc0RfAXNeLV6Ak2fJGjQBhzi3QfQcyiY8+ndEJUO+sybKDhKMEk7amB/Rc0kJXk83H6DmOJ5ubEXSsyDN46pvj7/1+cqzZSZoGmH975t8miQANeL7RYMdP6xj3ejQoMl9YvaoCkKKWT7j7ku6IH5Cg82f4Ozzj2TXgx2jbw9OQCdNIIDZblDG/KFzkY34aioNFCA+AqDC8KIuTJhHT7LAPg8IHWVJMRwOWpZ+FUyvgf22+CAHF6Ql/nhnhAHNYODrmXOgUWkFUfgEJyd6EjhbcS3yOE2GlGZY7FHg3KIet3sodnV3jN3pLJ8ygun/1/ES8OrPCyaAlwPGzXxgfm6Fis1IR8LTp8qJWHL+fNlrqY7ljqnnyDzla3Gn+pnVnGLs33UNX2jD7WwoBqxbUmZWmWUAyl2dCe4uEMK5rzA/Ho9GZVH63fW45yu2ZCxNMfv3FFHRrtRLI8JDbVvVyN7SS80nBFn33wD56U2rlFiXTxqak8Fb1z2JZtxu26vGZA2me5WEtotHUmjIGXAYiR0L+IHJra2+hmBb4K4xLKDpwH/iLKyHz70WzHpe+Ptk34jsFVnYZflD1zZzGwqTNc0PRYB2Xh5kIWh7cZ0iFK81aYG5o8CzZsF5yPuaB2Zd12zxkPZSg4exvpIB+vM3q6zp4Xk2Or2ir+ujLq
 r1WlmAFv
 lHnMD2pVe1JdoJaQtEtWqLtbRVO9rRGoPNmeKzyA8EaHb8IGHWz1BnLm1eS32xqITKZE9ZCNgrn3d5SLWqKQd4i3MT8jJAJsXFcieYw3rbCPM40E7FrEuE4rebnhaZQR0T/vyFYcWUs/Mxqy6XDxAaQ6QVlkvWYEbIX7+3rB8o0vklMzO1cI/UZDWLOe0Yz4zc34u/p6juAMGPYC/LyKtouqap+8N5fkKX9ArbhC06QzzYUJvR2gIR3Em2dBUbcuFBWsrzzApy9FKwtVRUl3UpErH2LyqYPF1Ff52CmR6+dzF6xSyt9xQRDZEye3AL6aMTue2gBnav8zThqd278Z573nhMpk3gWKRBx+h26yegpcf6mgh/Lho7xEP9uS4mls4OwdfYfMkOqitmYLFWmK6WWaq3N/2nzCLL5MRheGbF82Zor7tu79jnDJZ+yuH/xYoQKK8tjE7SWYBFH32G/Lx+mb5LMoWA7uAq+oPkbW3lCSUrZLEA74ik4Wb4sksuGLPN3crBy1sTPOXw2q83f9QLbKsT7HTXDivyRcy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026 23:46:31 +0000 Yosry Ahmed <yosry@kernel.org> wrote:

> > > > If that is the case, I think auto-scaling makes sense but can be a bit
> > > > tricky, since there is no universal tiered ratio; each workload will
> > > > have different tiers it can swap to, so they will all have to calculate
> > > > their own ratios. Tiered memory limits escapes this difficulty since we
> > > > assume all memory can be placed on all tiers, so we have a system-wide
> > > > ratio : -)
> > > 
> > > Hmm I don't follow. It's also possible (maybe not initially) that a
> > > memcg cannot use specific memory tiers, right? I am not sure what the
> > > difference is.
> > 
> > You're right, I was speaking more to the current state of memory tiers.
> > The majority of the feedack I received was that we already have too
> > many memcg knobs, so I just opted to make tiered memcg limits a
> > cgroup mount, with no ability for individual memcgs to tune their
> > limits or opt-in/out.
> 
> Right, I think this is similar to the approach taken here. We have a
> single interface for per-tier limits. The main difference is that we're
> allowing 0/max values to disable/enable different swap tiers per-memcg,
> as there's a use case for that.
> 
> Seems like for memory tiering there's no use case for that yet.

Yes, I would agree with that.

> > What do you think Yosry? Would it make sense for us to be able to 
> > tune these values? Personally I think it makes sense but just wanted to
> > make the basic features merged before I went to push for making those
> > knobs tunable.
> 
> Right now we're not proposing to allow tuning swap tier limits either,
> just enable or disable a tier. My main question is about the default
> values.
> 
> IIUC, for memory tiering, if you set memory.max, then the limits for
> tiers are auto-scaled. I think it makes sense to do the same for swap
> tiers for cosnsitency. Or am I wrong about the memory tiering limits
> behavior?

No, you're right about that. Sorry for steering the thread to my 
series ; -)

To get back to the question of how the auto-tuning should work, the
main question is to which ratio we scale the swap limits to.
Do we set the swap limits proportional to how much swap is present
in the system, or how much swap is available to the cgroup?

So if we have 3 swap tiers A, B, C, with 50G, 30G, and 20G capacity
respectively, how much should a cgroup with swap.max = 10G have if
it is limited to tiers A and B?

This is what I was getting at earlier when I said we have to calculate
different ratios for different cgroups, based on what tiers they have
access to.

Sorry if that doesn't make sense, please let me know how I can
elaborate!

