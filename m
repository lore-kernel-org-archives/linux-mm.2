Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EE3C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255E96B0098; Mon,  7 Sep 2026 21:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEEC6B0099; Mon,  7 Sep 2026 21:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D15D6B009B; Mon,  7 Sep 2026 21:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6E1C6B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:29:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30301160317
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:19:40 +0000 (UTC)
X-FDA: 85188837720.03.10E7ABF
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6C1AB40006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:19:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ocFBS0ek;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788830378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4iTZNJwexeZeeHQj3UOdA9eylxa0Qsx4P1q2zIlRJc=;
	b=vLf6dGduZ68Rc0O0iYSknHrBFxnpSUW0wIFVse8P2ZgKSLNpG2pRox7Bo1eZOYViwjljje
	Urjy3sKhAjWqrkLxnxtGajdS1uho3Q0Loy1pwtOyLmGVNFb+mWUInR650RkIB0938giOYa
	f1rPQuhgZUY/FjleB691N9Y93gRRo00=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788830378;
	b=Bpe397jXO5n/jtmrGuNVOJJe78RNF1Ac58x9Q2cWt2HBC4UL0nA7Np2p4r9I6esaeJn/02
	Hm4p/GqZxeqFgp/MneNFAjZzrVT1mjB2TTkz/fNLFLny7onKBbbOABmPuCTJtXVxu9TxiM
	NakLn8+qR6pZc/fFBkalONL6BZwLNwI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ocFBS0ek;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-469d76ce704so3575555fac.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 18:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788830377; x=1789435177; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C4iTZNJwexeZeeHQj3UOdA9eylxa0Qsx4P1q2zIlRJc=;
        b=ocFBS0ek/BqVuoIR0i3goF8EzdLdajR/2J+hlGaIKOt1hV1JdcJRgmkrksSAv09LWI
         /b/Pqupqq+euYma/MFe3wIcX2Odk4ISOh2Vgd9NHUkMOdGZiCcaupJRlIXSK6SNm5n2g
         laJ7qJ1JPZRfYirOCUnH3Zb0BqRjarqjRHbncEi1Lt2w2UeqdQ0zaShw+dl9nzDdezd7
         0nslKEtx8e2CC5yV+uR5pSEttQPgJPI4OdO8gLxH5ukoLQCWZ7bE2it5W006M+jIuLS2
         u/haFWwQU5ICah7z0apk61AHikfur240nEmEyC4eZXLsVbpvbUxMOnqLMWa+xwPyTfOU
         9IVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830377; x=1789435177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C4iTZNJwexeZeeHQj3UOdA9eylxa0Qsx4P1q2zIlRJc=;
        b=C643+Vg+ydwnKdnKudL5TPsKfOYRzeZvMm0AqVJHrIPRkilWyJqkB8HsZn6FPO1bOr
         mrqDmsD5PjiDCedVzbpJxa/YUJXH0W75hljooEjlzWZr665Y42gkQaxAdxyU+FqLWkxe
         UzHZCOqYLYhCXt77wN4xOJALLmAzEW9d3ObM8yq6cVyBwXrVkoWLmFbyxaFpSWkd9Zvr
         +lp9GR2uHDsCPF1+xPUU1/zJB0AzTVKiEvZUqmpT06/BQT95YMPLu2Fk17HKtxUIqluh
         r27I2zOb2ZyK34sozEqQvmMnNXrxgwFYbcAFDEX8Clysdfns7KEVQhuzqpBY2Up4nGuE
         vWpg==
X-Forwarded-Encrypted: i=1; AKwUvBzul7fxu9bc6pg7U/RX6gZp+vbNHMtb18NxNRDWOwCzpX+//ShcnEwndsc888i5JjDS9nrnKkKy+Q==@kvack.org
X-Gm-Message-State: AFuF++nfTHIeEUsCzT0iRfPsxF2GH1ZH0ZRx9dyqwfdjs/syHsCUAQsg
	a7xPiNimlvgSduL5u9nhdYwbQ6XC6GC3BBlVzo5s2Jts9RayM7ESzExt
X-Gm-Gg: AYBFou20TAfF7dwo7M1yGvyn5/eAZ1Y43KHEqU93ZJ7OJ9D3BzFesimSbuWqe4rfz6X
	f/Vzdkj+GQP+BPDdooW3I2+YQ5mlks/x/J8kyu4W2zm//TI/8M96jXJ/cCHca0mkbj3tDdmtROC
	ouCuBylzYCrcVCWcBJMhPLlnD6OZPt9RVFCtmyOzOMDL3zkyB+iw4VySZ8zTt5AiqJGIjq+D5OT
	os9cC5bFBPcJ6/pTrPMrrfXiEd7Dj5yS0701FK+eBbL6aNqzVm9J9HhfVQ5tlldiG8Pz6B3xROi
	tB5Rf9kJOHgIS6Ax5O3hlbgb3IG5lYzIkS/0esN7OJdGBVoqz4uDdqkqJmTF6stCWiKFqEwzqCU
	LbSsHn7cexe2STgGkufy/2LgU7DBJolfn7q14KGI1hm0UYLBfO3U2BNTkl06OFxZ3zp3yT6XdoW
	mMaKOeYBcHOgmucO9/gJURvR7Rv8gOR+YMCAnu9rEzI78ETX6E9LnpVuNM7YcVsnjuBLrsPrcG7
	jT9VtOYHZR0/qFXeg==
X-Received: by 2002:a05:6820:168f:b0:6b7:83c5:fdef with SMTP id 006d021491bc7-6b783c66750mr12147449eaf.48.1788830376431;
        Mon, 07 Sep 2026 18:19:36 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b6dea11aeasm14793941eaf.14.2026.09.07.18.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:19:35 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 5/7] mm/page_counter: introduce an asynchronous drainer
Date: Mon,  7 Sep 2026 18:19:34 -0700
Message-ID: <20260908011934.1737458-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ap9HiQv7_9cyIe2e@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C1AB40006
X-Stat-Signature: jcuddh5cpz3pjoiw4e8keh7oijkxwd46
X-Rspam-User: 
X-HE-Tag: 1788830378-512221
X-HE-Meta: U2FsdGVkX18XgztyL1yT0o01RDrXVJCL5G+f5+eLAfSm7LMOgUpvA8pZ9fNJafRbSm70eBYref+xZiY9SfQgJXTDRAYBzVbiS+nRFApsyJnA1b5WRir6ZCsKqJNGJA/85EyKieAaJGQ9uqm9u+mK34xNG+IxUK0HIXJirscUMT/tAV0AaVoKiNjqqhabXlzYSnonTE1LzKFuHeGtG2aeLSdZSOyZoFEdVZtZKwb3/WsaziHrd0rEenGiwhFhO/Z5WJHru8YDfA5X6DsInUfMht8FuFBJHiVj7tFH++wH+0LSJl1RUTsQIqgPHyXVt3cVShu8q3J21po1wzFbv3lCeuFkSMsgE2y2oidgXed8HnPNHZGNsSxttsFvzBMwVwCZAKVILqNHF0z7x26b5VqHTyQCe8ZM+78qrnPH4e+yd4ONL9A/j8QMMUejeP4gpxtGdBo3VwKl/Ko3IOhDzakcqx8uMz/QZEuvLHP3UXVqHDnR3HM81SyQOfEKQiBkzsPMkplgwrSdbfzLPALPjhysyNmZahZQZH+TLr3AnQu0Dne9TL1ZsH+cNEPWi92Z8ige1bujBojFTKNNQ3XkhwuADAdCIpnlx0rOYC888ZbqIas4VVBXfJSA9GSbz1aa23yBFlpwgKh6XarDqrZskhhNI2deVvM3m7MSXO/7XeEItYgMJAxpJ+yT0cVLS9Napj7N46n4awplV9tcLwZej/qECXaFUz9rbMJ6Bc9GGXH5O6NGMP/jzNy3t5jmRiJ+1Y86EAmCWz53gQliU2O1Z7yKAzAfvPM7Acig/ahsO+TBbfz8Xm6LD8ngPUoogtOPrdyAk8ByEaes8onNpHcuFvMkSss+b9mEIvIPtMOR3ki5jmCg0HWKWkhs91xCy3PhHFlAIhBYYifCnQCEnXWcSIa37VhdwR2gABpZmRAF4Xo848VUA2lQChIDTFoBuIcq9oHsf+HGSKeuATP5N5K6ZLv
 XTvqGY6Q
 FQmxhVaWMQKM3E7l/5uHEVjTEohGeX+0yPG43duce6Hz8fJEY4chqF1xtXhZX/hz1GB17CrHpm5AOBBOHZq8w8AhA0V/HZqHIX7L4SBDtN0c6jewy9TdhJWkJ1V8d//m3/V7lVXKI9ZzPk+Kw5i9uUNXUxGHttGQ1SUixzPZnYnOzdpq28kKwe2umx45gUi92N11pkRwczENxX96z36+ubpS1N9r8v8/Ldkx0dFu9N8zHJMp7ceZswqp976cnL1Ns0iAAquunHFyI/pIf/gUfc0kyRmmYWpvV4Ss3dcgt6cYmwDBsqqxFWWaDLqtn9LOu+jND1qZ79FsmFK67GBc2cxatRRkTAjN6dQuLxZeSU4UkoedeknjCIEXvD9+BmKwzXSAYcsHAnV29DYX+p1oFCT455+Wkdc+GQ9AyPbHfjN5lkgL1yr8NZSXRS0NWb1F1RAlh/5vVHMWOQGfnjB+sOzSwGFfa1oXmVmRZNBbjAxC9usIsAs3zXZ/XS9HEtWZSulDW8e7eSJ3uJSgbm275IvoiJGXbYJx2r1N7V9EqS6snApoEe+S8p52vlHqzOhWHzI/i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 7 Sep 2026 16:25:31 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

Hi Shakeel,

Thanks for your review on the series!

> On Mon, Aug 31, 2026 at 09:37:49AM -0700, Joshua Hahn wrote:
> > The existing percpu memcg stock drainer schedules a stock drain worker
> > per-cpu, one for every CPU containing the target memcg's stock.
> 
> But you are introducing remote draining. Why do you need async drainer at all?
> Just always drain synchronously.

I was trying to match parity with the existing code as much as possible.
But I see now that this series is a bit complicated because I'm trying
to do two things at once and mixing up the page_counter migration
and the scalable draining together.

In the next version I'll keep parity and only migrate to page_counter
and in a follow-up I'll address the drainers separately.

Thanks again!
Joshua

