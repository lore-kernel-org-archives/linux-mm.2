Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F65C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1D06B0093; Wed, 19 Aug 2026 05:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092D66B009E; Wed, 19 Aug 2026 05:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEA946B009F; Wed, 19 Aug 2026 05:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C58536B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:07:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF7AF1C051E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:59:20 +0000 (UTC)
X-FDA: 85117420080.25.C9EF1BB
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC12540003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:59:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SGpFuh68;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787129959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPBuvlSTVq/cy1aSyLelT0W4GC3jLLC5QYRU+QpaQtU=;
	b=qljXX4XxEOzrexyjDWC0vtZhIbV8g8qcaqrmuMLQYWeMlcrgUWKebVRxst807An6Ql+Lmu
	6E4MNJqmVqL3ilx2HX+bV9YlH0+9ZUJPvMYq1mqfwI4E+NM7uIr3bX71VMV/6V8ytU6CS8
	kCRSCTJBALMmfJheG5/DKK/ftIhK9vI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SGpFuh68;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787129959;
	b=xZshDu3Yqy45UPonTHuGAv1IfPVsBYs3rLXukzDWhKWtHt16Z9gm4nybfXJ+rB1EH7BZs1
	x0YMCLlcUTXNRvggZ5fX8nUuF3aNDalFjNmAOkcc9JG5Q+5O8oL3Z4ZsoKTfxLh7YT5e+H
	S2c4ZqtkiD5/9sXmMy6b5VQZbdmSjMQ=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49954b88fffso7643275e9.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787129957; x=1787734757; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nPBuvlSTVq/cy1aSyLelT0W4GC3jLLC5QYRU+QpaQtU=;
        b=SGpFuh68CkyDeuRJvVKgE+PoQrjSQeSuZczs0QuCvWoxW4Ixn74MiIRfrMzw4vFPbf
         VH28o1/XOnbXyCtNOC8AanSK+mihphL67SQW3/D1Fnb/g6yxt2xKjNRiJ0JTuop/8R6M
         aCTBS83jan+zAK7juwSvTr6JsQVilJVwmzPDBqbRedFt+38SFP4zm3GX8Vglsl8H4QSX
         ox0wbyacc27Bq3nBJQXczEICOd2w0x12Cw1rJZ75NlRPWGrK22W3efo50kkhtVOzSjVv
         fORHSmyV2lzPoPab7YqFiNfzLAvvSxK/3jqkbeToMJmDG4gF//4fU18Elp/Af0bQFKKl
         Hctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787129957; x=1787734757;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nPBuvlSTVq/cy1aSyLelT0W4GC3jLLC5QYRU+QpaQtU=;
        b=mXyQTYthmwR8Zhr1Gvi+htRShfojXTQ0qjZNMXVCg/LRZG8Egqp93v2ZbbJDw59tbI
         puzBz8KdKUevk8ycB9Igx+6VrDBsgdBGwIZJRtuVmT7N61ApISriBXNjXR3famFSHXIr
         KV3Ce9pn8AfR+TVPjdRD/CJUBI5C2vFVPgR2QAUtoZVOuhRljK64fo7okiQwtFLffvA4
         CeWgu6IEGgqtzYJtpXVMyc22+Qxc2xSQ/IBoJy3DzgMH0E1RwcBOGVXcuKWsAQsAE3SW
         W2A2vwCryR8v4pqmSyziQxomk8GgeaO8lspOsVANKMbrSH1rt6dpmZWEBevlEVb0I/Qi
         Dwmw==
X-Forwarded-Encrypted: i=1; AHgh+RorFXkdJ9D9GMIKjipYBrFhod2mfCNrt9huquUUuRH0WCYe08KlJYfXIvbBy0gbAYynnwotmuRSGg==@kvack.org
X-Gm-Message-State: AOJu0YxcBmVEk+ZzXkceKi72qns5qF9n8OseoCikoJ8N1Su2mFHea7Nm
	oUijISucaw+IE1yUBjFsTekbTAQb3MRXE+/SmobqGZHOIJRVQKH4bVW5pUGyqCFdk/M=
X-Gm-Gg: AR+sD128neKQxmUWGhDPUdRvvew/+VAzJxXmzT5HcGObVRQ7ARWYa0M/+aPtxoAUDYX
	VrYZBaVrEaDNhgVKU+9ZKTNdr29Jyrr/Lb+syXS0daJKbVrF/SYUIYQ3xKuq2qki7nJrh1exjbz
	5mnLKzJJzqp4lKmgPIp/YfNwK0zdg5uk7YKcE+H2a7S4emmluvJ2ZhcppN9kP+Bo6IbAscAcbzS
	bIQF664NsWlyOoYfuPROJlb7yUoX8GIBCzf9A2cL9gMyhTxDsualvJY4qaDrBvNXy3ScjVdFtsR
	eWwNg/MTbB6nzcpLHD7NmDkJoKCux53rgw/VNwx0bSGFSXBY5aEWgQx/v0yvltGc9c1LQlStSzv
	ZLUCKjUQwh05PSQlA7g0NCVC+w/n+nKEBStKHIKk/bO09Ltxp0dXyNTh4GRpk1Ti8S0KhxlU1Jl
	ubbSEHbV8zMRVXrlpZwTRhwFEM28NnRC8I2c06TpsvnZ7p0AU6EI6cfhaKUJTG3Dsw3zDmpmN9Q
	A==
X-Received: by 2002:a05:600c:37c6:b0:499:87f3:a2a3 with SMTP id 5b1f17b1804b1-499aa1c7bafmr55530255e9.15.1787129957417;
        Wed, 19 Aug 2026 01:59:17 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa1755b2sm45456595e9.11.2026.08.19.01.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 01:59:17 -0700 (PDT)
Date: Wed, 19 Aug 2026 10:59:15 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Leon Hwang <leon.hwang@linux.dev>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
Message-ID: <aoVwY4d2Un5Fny7e@tiehlicka>
References: <20260818135029.93288-1-leon.hwang@linux.dev>
 <3dadebb3-7e2a-459c-a5e8-b375faf89938@kernel.org>
 <20260818111756.6b0e347db3170bc22cc3c5af@linux-foundation.org>
 <2a523945-825c-45a5-a680-37e941e092d3@kernel.org>
 <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
 <35cca76a-4d3a-451a-b492-dd4423ac3e63@kernel.org>
 <aoVuRWz0VkKiJPzd@tiehlicka>
 <68cb43c6-6ed2-488f-916a-b22bb956adcf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68cb43c6-6ed2-488f-916a-b22bb956adcf@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC12540003
X-Stat-Signature: y5o6i7yx9hj3ecc58fc8cak1mn85ucpa
X-Rspam-User: 
X-HE-Tag: 1787129958-435881
X-HE-Meta: U2FsdGVkX1/JNwGGE3+f1jko76NEORYidLARAyyicQbyxaq6kUbvPFZeXUo5qU5ahnzjA9DZuZ2ZVoc3w4XMdhcYdR5ClzEAK08OKgfXGhdUg4tQoEMhAhJdkrNdruqaPcdsPgo+lNhRRhvrZpcjs/SGMMetd8J3UupIFP2/3vygp/zdDktGeX0ov1B8saUMutEWYMaM73OY+huNBahLMlzX0ytDlbJ2accJzqLPorJPBQAKmNr51rAVb8O/oaEor7p2Z+lrNvCQgKkkxtleQ3OtUCMPaCD4OdAGp+trb7T3TuYToHB3inFVJhb9IszbZAZy/xtudjXHhte2JnqVbKfgleRF/CxRgoZXaFZvRjDRLgYnWuRqVAPw5zCW0BKrzpNZ+cCABsG/tjYRlzbBKuNKnFuWnwje5Ca1MMkXpWLMWTypVNyuETdtWfCV6Rz+b590g9jvFuxNKl0/iktM+C5HLxRPHmWvBL/fvf4WSj20s5dhyPqiewHJaANbO86ml0SSgvaN2iAuf9HwhJgMhoS25eA9LderZW+vkR/xp0zSFwbhcOAm/ekg3gdcomTVpwBCnUVa6sVtaWSVpRoyBk2KYNddY7io8JZAa3N3ltoyyC0MgtcXU4NsusW2Zqg0aHw3HDGEcKm2rXdNbg1oa+pCtLK/RcO5FJnEI3Kncyu7Xm3Hbemx6XvDSa7Y8Banop5M1svzNYiPFtCZvVy+2kV5NICMDmO5Zvv+qJDsJ2uhGJpNcOP2xLR6hPu0eIMOS10lqhhSW0p6/8yjrC0OcNxCxihm97iS8TiXmzu7FSC5O2RbweMV22DEUrDJoId8Ttj4StwhXBBEzUBdXprXF4ZIsEv1Dfn0vUFsU4CJnTsgv+kUYoEmX3VA4OM4ZT6XbqXv7WQgtXSSzbLF5HQN1w6eiINLVTVsIxMSXAowqjSrOpYp3oqy0fxxav1rTi1/j4+mTd/hkgZV8AfKLAm
 KzTdddbz
 0xLRsfsSVoMhC363SsNdMu7UwAkLkpRTTqsAO83SdAFXeN5myZJCONcZQm4RdqgzK/p2o4LPkrUsJtf6u1Qk+Jc5E/qzjr2AqSc2jeLBBd/35Mu7Rs2vI+YKbxJJsDS5P0i7HzikhcdpdAAi2NJVplSWX1WBZZVhKkwbF4K7haDf9Si1OUNDapGm4EGA0AB4B/z8svSc8H1pqKQs8nIRI9HTTipg/XIloPUpMCumwXYakOeJWmRaAgivuc1O18xxlEtNbwIdPa0hSVgTJjsMPi0+tbf/PWcTTx7kiAKdPLjVLmBIP99rkKZWWC0nbU6KMhlJShOANbWiQI5IWYr3JwHvXQhZTaaG/YJiO6MmeF+uBdw35aqtkmw08FJKEogFTHzLVyWTawB0XhRwcAL75xbGZxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 19-08-26 10:54:11, David Hildenbrand wrote:
> On 8/19/26 10:50, Michal Hocko wrote:
> > On Wed 19-08-26 09:53:25, David Hildenbrand wrote:
> >> On 8/18/26 20:55, Andrew Morton wrote:
> >>>
> >>>
> >>> Not understanding.
> >>>
> >>> Maybe you refer to adding a patch to -stable but not to -linus?  That's
> >>> against the -stable rules
> >>> (Documentation/process/stable-kernel-rules.rst).
> >>
> >> It's tricky: if a problem only exists in stable (there is nothing to fix in
> >> Linus' tree), then a stable-only fix is acceptable.
> > 
> > The crucial quiestion is whether this is something that needs a code fix
> > or a configuration fix. Really fighting for low latencies with
> > PREEMPT_NONE is a kinda lost battle. You might want to play whack a
> > mole...
> 
> Yes, I read your comment on the other thread afterwards and I agree.
> 
> The whole reason we added cond_resched() all over the place over the years was
> to avoid splats from false detected hung tasks (e.g., 30s ...).
> 
> Not to optimize latency in the ms range.

Exactly, they aimed to provide reasonable upper boundary of
no-preemption with non-preemptive scheduling. And those are on decline
which is a reason to keep bar for adding new ones high and also
optimizing low latencies fundamentally makes no sense for those models.
So even more reason to not add them in these cases. This will just add
more future work when non-preemptive models are gone which will
eventually happen AFAIU.

-- 
Michal Hocko
SUSE Labs

