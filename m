Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA5D606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=b14BuBd4
Received: by kanga.kvack.org (Postfix)
	id B938C6B05DB; Tue, 27 Oct 2026 10:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B479D6B05DE; Tue, 27 Oct 2026 10:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59816B05DF; Tue, 27 Oct 2026 10:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 853B86B05DB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:02:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB313A0A80
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:02:37 +0000 (UTC)
X-FDA: 85368571554.08.F4FDC05
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 95CE720002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:02:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b14BuBd4;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1o9096nWf9ghL1mNo+bNKs9Dd0gIk9ZEkL7EBJmA/hI=;
	b=LhnaoXzjmrKFvtzzEL9a/p3RhkNjy85TXVB7+jW5DH+aLpVjevSjxfixNNEHGoJlI3T4/Q
	2ILcQWnPYGtCyrk+A3FYWmuITo4yZmG772QlxbhK2CKK5vZmfpKYqPHXunYjJk6fy29yEu
	8v7V7aOsKWAnyfOQ4Mw3R+AUrBJNhhE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b14BuBd4;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109755;
	b=UoX6vWkWJ/NCNKNIYrLbIdpZWZ1973dAQ2VnD2mV2vzrWxNjiLUnPywH2YGz3fOPBhbxxN
	nQ1Oa+q/jJ1lCfBL8LOToY+DTr5/VVQCOBC0WwRlCAQD9sKJBSWLHbvSmca4ouMEpxpEWJ
	sWbUyCCIW643FFMGZEStGZQQIHaTmlk=
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5eb14d0837fso2821483e0c.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793109754; x=1793714554; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1o9096nWf9ghL1mNo+bNKs9Dd0gIk9ZEkL7EBJmA/hI=;
        b=b14BuBd4S19gHzoPh/W1WO6A3yGT0fWbIDdRv0JuQ5B442nSrZKe3B/ohrS8G8/wAs
         mda+8t8rTp2xy4QUakFn0smfwRxB2Gs3M3m9oSuGShqfZNYycd85KdC5UnudxTSosTuI
         b3ZMKJtXojqDVew1xyWUTer0J2r1lVczq8hqlnWLr/UaYCkU8xgwQJteDhBuDLQFqdzO
         tQySWX63+blzJlNYjpP3jCHqiCJBxGvuCVsOfCsyjwzsrc7m9q/nA5Spcj16HIRt7Fkz
         roSeCtqc9FufRGP6ONhayEdMwqm8y60zlw1b0Byd5RLjv16csysIA0o1th3ze6vsgJFZ
         HSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109754; x=1793714554;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1o9096nWf9ghL1mNo+bNKs9Dd0gIk9ZEkL7EBJmA/hI=;
        b=LYn1auIapf4XBD+HhqhrGw9SMrjATFL8+6sO/sLruHW3O8FhFM1AyhxEjoMKOWfMiO
         RN1I8KBSXfnMH0kR0qC7ja+9IxGcaRg3hK0Ebpz9ozdvV9m9R5sWsSaYP/rbpKMsxW5v
         cN9M64OI5PhbUKcb9IxeyH8Sf1d224WurFPO1GL0eeKgoG6jbD2VBQkFExOHq1Cv3Rkr
         HTs8R3Y5C8ReFD5wx0YCv/iaA2Nx/pgyr/GG5qt6ceONpQsuQpfsl2TGVDfo366bcwIt
         5Xi4BfC5q8l0CG1DtLjAy4TA4WJCwda9O5x6bsBCn3TXIqOVmtfQGrFiq3+iaCwMqD7R
         ph6w==
X-Forwarded-Encrypted: i=1; AKwUvBzE/Pn/8Xd+OHQsuxxIaf20t6LNMm0UreiPjHARx1eN9LCZgIzx1oisgvrlCgTxtNhJStN4pspqYw==@kvack.org
X-Gm-Message-State: AFq9FYL5ADuxKid9hX38vhSOVAXa3w62IvPsoIHVQVLK9g/a8Llrm4HJ
	YL96wXRse+qdjpf/Q3f78iSkfPTU7tyNAg60VmW8saWbMEhEWpJAOYRa3Pj/RyODKLM=
X-Gm-Gg: AYBFou2ZFrZInyfu6I6Mvvf4/dWh1QO7FpWwiXJlfbg6lTFFW5Il9v9m0Tm7gle7n/W
	JnvvoVNPhXQWfooATwu/gsLvOyyVjWGegzo1CAJSByYo5ESYMH4pUTrPzJ/11RM4Y9F8DpU3JcT
	/dSjdN8tqP554ZrEmIPAXE9dCgHYLVbYqWgzvlDwhb9mTh7iMHRgalTIAi3GEwWRD1SK6qgenO9
	/dQqRyORduxPfKddtmrEV4022KnUMr1AWob+Ox09aPGvNwPtLK55Te8Howp2i3T6YMF55TBmP39
	0GZgf4+EKUaovS191vmtdv2qLutlqRc+bs01i/xu5sD9q8r1KTdzjJirnIgacQroi9wX+nY5hzf
	QC7cHwU5r2jyMJkS9DWhvGRKmuTlfguziEhP/sVwU7CsnKrPmNGQmIYgVjCixejS6EL2Tl6KMyp
	Km6l9giA0+O/wHhy+L24MLtOX9NuRoJ4LNSLjZcuXDnyF8bf4sq+hcsAQKmNYJf5fcrEMXnVNHB
	H82FB6cekYHHGq1LsDWDOZU+lNtdSCfmvx5Iaph6Bb0jX6T+uN65hII1nnSkBoLQTgUEeA662RQ
	KJLkdpZX9chA/dQDdE/WldaifvT0IRJwgEyfbfSGI43L+F3wX9Ik6XLqvbfdoEGn9F+DepnceMN
	s
X-Received: by 2002:a05:6122:3c4c:b0:5ea:e197:702e with SMTP id 71dfb90a1353d-5ec23326373mr4106967e0c.20.1793109747918;
        Tue, 27 Oct 2026 07:02:27 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47bda586sm103188516d6.8.2026.10.27.07.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 07:02:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/mempolicy: recompute automatic interleave weights
 on memory hotplug
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, honggyu.kim@sk.com, 
 stable@vger.kernel.org
In-Reply-To: <13a3b600-8a87-478e-adcc-2425c75f98c6@kernel.org>
References: <20261024170415.4121901-1-gourry@gourry.net>
 <e3a1ae72-9370-4c3c-8935-6a410a74377b@kernel.org>
 <at91WFlW96PH-a8A@gourry-fedora-PF4VCD3F>
 <13a3b600-8a87-478e-adcc-2425c75f98c6@kernel.org>
Date: Tue, 27 Oct 2026 10:02:25 -0400
Message-Id: <179310974571.2232644.3181896214940432050.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 95CE720002
X-Stat-Signature: 93wnpj3derf6apuih9d938yea3ncsqdr
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793109755-962411
X-HE-Meta: U2FsdGVkX19iNDIvUIYf395tHGNvoYl3oHkAsniY+WJ+NWEwSaIATXQ533Z8FwO/oN6OgkwJK7yxPlBAOekKdpLwheZBdD2xG/r64SCtiv6I5SJKgX7IMCB9fQiGIFnRQNF2PjQPg6+gJqh54JM2+erWSrZKPTmnIP06qljAkFs08LNm6Tb3eLLGtpufq4Gmgw9T1MeI1BcqDDdgM0QM0x1z32ANJjqYkXnBWZac+ZoU6dLprUTBWTvt/ne8Gx3UKG7a+otS0CoO7LyN9YaJSzJ0rFOBTiY+Jn/5rweIrVHLEtcCwuL5KREPZEdP52iLy2sJTs6ReRYcSLKqo8yc4ndyIM+Pszx12eI7CTQ5bfv5vWE2jHEazftHOQEE02ZkWgLkAaZ+iR/7aKEAEaPCiBBABSHh06nCuzOBZn/nLMDQwhC/xVLHMT/0crYlO8mc1TN5lmJIqr1ISMZCHZPkiRKaziFVSpF91pcH/Bqx2KAMrZcvmtqta+Xyyjx9jtkR4QL5GQAhcUxofF0BVQNGDUQVrD/25zFi5i25r9MUzWm235KkNAT0XEGa1DNUWsrZpkI8CLTIQd5BwgiC2i1Y9niwLqthFoaRjKDGEMCHlqvCQkbaBp2WCKElpaJWr3hgHYIOGW68iKPS571q+r89CbALmq2AhL+C8AGXsQ+R6L3+z9bs/pIqqzkMvLZ3XAX5Q+v+PzsSx+8F8DYLt6xBtemrciVBmyTCUT47jH+Qw1YbDO5qCXuI1Up3YKYggqlasPXbGoZbAxLNI3tFqCFfqu4AJcu7bm5faimcyFKtplRF9wMJ1Jb4UHA4XSFeZnRLX1Ah0qeLuBcP/BVegXgSOD87XAf47tZIByJeTFzHJF7ClsrQGzVm9Msk8wGO7ICeyUksVEfTX+kQcrh+zq8H2LgljoR305gmjtUFO8lRrupOcvgdG7sRmXGd8UfAHnf4gQTeHLQ7sXwyn6ST9p8
 6CUz8w9V
 Wp87xTjJNjuoHHBtSpJSuzH36UVvfV50A8ROMBtVTOxB9HMXOALHgZCeVa57SxyeneaUAAkPy6uecKHTVHmk8l8hxJOg80GlbVr2KWUNGEUuVEQxN2gafWkLN2+HSX6qSWdFjwz0FWANFtIjEsBD4GhfFUJBCdB2gr6Cd67mKLVzJ+L9cOBFFJN3vg9oRHFeDba1C72E3gg2O41r9Nld61DVJ9XBiBDmV8km2KIxBZ1Lm1YWHElrAFvRQn0WX8ZDmI0IOAnAgfT5BpIRENnxMccjPA9GORLjj7kHbuvQVyZceF832NLz6jJ6ITFyDQXhrHO1AlrwwuMg8Xw0FBUjRE39f28toIKr1j1/p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 14:04 +0100, David Hildenbrand (Arm) wrote:
> >>> +	/*
> >>> +	 * HMAT and CXL report a node's bandwidth only when it first gains
> >>> +	 * memory, so recompute the weights whenever N_MEMORY changes.
> >>> +	 */
> >>> +	wi_state_refresh();
> >>
> >> If the function fails, should we at least pr_warn_once() ?
> >>
> > 
> > The only failure state is -ENOMEM, wasn't sure that was worth warning
> > on.  I actually debated whether to just make this a void function.
> > 
> > I don't have a strong feeling here, but happy to add a warn if you
> > prefer it.
> 
> I'd assume we'd at least want to tell the world somehow that something is now
> imprecise?
> 
> Or is not updating that harmless?
> 

It's a potential performance regression, but if we just -ENOMEM'd a
kernel buffer to hold the weights, there's bigger issues.

I'll add a warn.

-- 
~Gregory


