Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1294210D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E84E6B009F; Mon, 30 Mar 2026 07:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C02F6B00A0; Mon, 30 Mar 2026 07:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5D06B00A1; Mon, 30 Mar 2026 07:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF426B009F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:45:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F144FC29EE
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:45:47 +0000 (UTC)
X-FDA: 84602549934.17.D6C44C9
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0F141100008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:45:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kqKMYz7V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnDbxuScG9Rm/YGh2qPYK61S3SeIJ/p/OHYJTOIzac4=;
	b=sJ13qyYtM4GFBOHCkWKkj4r3EUR+aPTy0+cxQvBbHzw4frJW5Gaj0lz90L6vulHZy66z6E
	ZM9iplNdZpEmkLYSfYzUf+i8JZ995/+aTk7KEIXPcqiYo91iVthiUa5MN0JbUBJfI1KeU8
	dLcpHXoiVN/i9gT69Lb7+d6KCBDJjnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871146; a=rsa-sha256;
	cv=none;
	b=RpOQdKHNFeawqCHy/zxYJ00fhrFvxmn3a3mmfa5ZvvltgDVGcwf9Zt8Zer0+gBRAUGzzIs
	wB/rEMEP5HaRjWKdHGexdq9dd9rlR/yue9gN3go6XBcC3n/9pHdZteQWbIe6cWSNFcoifn
	akMBsKUdGEw5vW1yVCA9/XjxW07sOgM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kqKMYz7V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=realwujing@gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12a747e7b2fso2019281c88.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774871145; x=1775475945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MnDbxuScG9Rm/YGh2qPYK61S3SeIJ/p/OHYJTOIzac4=;
        b=kqKMYz7V6NJKl2SEPiimaXRD23QU+O82VXHPHgIY3aEk53Y1zWZVbqfAfS1G1+y2Hy
         +nyn2ldxwA5b5WUERmcBllOw65dyNzD2m3CmS7Mw2TprFj6gyoDj1zIm/owy0qUzOfGn
         FEtee9RWLSCCGhsMRO7YhTt5YymHfgqu2IyYK1SRJpjG8SciiEbi7WTOKybo2rItyGY3
         xWcupwWhZrD3OmeFDU9qQHQYXlBvlWBdsu3ttiwt0Th7As/FKStJqygySnpvLyCPlmgH
         G0L8N+PQcC8wn4+V7vyNGfDFc1rLm/8aXaMogLyph62jBQLnOfj9O9jg2pm+qwunp4xw
         fwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871145; x=1775475945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MnDbxuScG9Rm/YGh2qPYK61S3SeIJ/p/OHYJTOIzac4=;
        b=N/gclUlVuon44S5dTbz9MT2KncnRD4oT6diS/ds8tRZZFNQw3bGbJOkJyOJVq1bEj5
         VJeQFrceP4s7+aZM51lJ5tLJwrBGz0VrAT09l/VsHOxDsAqokTt5vfAf2anhN0p3i4XQ
         UjytAOC4tHftPj8Rf+a+v8MmcIyW3kvnqIwUYpz4KGphhgVU7P16Ndwnjyv7tCoxatqp
         6YyArBgDul6jFkzNXgLKfzR6fXP/5rVjgP/jsjp6qX/m97Ab685afVzR7UJG4jONPHex
         p4hm2K0w3ucl5wB6QtMp3oNy95ZgXtYhRet4VpHSwS62ui+JyK6ynRFBt+QzPSXK4kKe
         qQ2A==
X-Forwarded-Encrypted: i=1; AJvYcCXJvEB8iLzs18myAJooo1aANO+hMxmmNMS+zIhv9kN+zhmFLeO10/ceXngWSFmsbqTBBGHo855JMw==@kvack.org
X-Gm-Message-State: AOJu0YxmRi20WpTwlTAVPd47Im1Y8ujq5jLFrv8YVHY9HmCCtMMRyq1w
	JTmfB2TdtXRopGqQgFUl8deX8//zSuDy9ZzIGqdiVP3GZb0KitfmRp8n
X-Gm-Gg: ATEYQzw1dJS5Bqvqo4Np/PeGp/gnkoitVxsj7yefL+AQIkCawYOsrMRkfmMmWUhPLqw
	64K8KCswBdcd1afCLck/gbVZ3oxA67hIONmO6+x9IIu4hYzG4700GT4GTKmnxAw6YwRMakUTkla
	nkCzyU3FtkjmPuI396noM+gyQYCD+D4FjMMr+Dd2hUplIjFiWOIPqng+P/QocLHaoCqd1nwu6SD
	RBUuFN1Ju7zDPOWuBNXzEGqa72G0pGoC9YZQ9W3/uzwEF9Wm4W2aVTRbGyKOawQO+Mv6a7gV4C7
	w+MUJHFniEr0FzbljBHB7nylgM99+8vHIOYRUFEaMVy0Jp2koclCOAgNZy7KcewA9Ktq91Ms1av
	6VMKW7YdWAMHrrjgfN0k2bMwjnCZEGAHgB0kiVdsyuCDt/jljyuN+rUEIZ1Pgc9svDYuPoM4cNa
	UfHvcxRwNY/ZUDOPaalIaWcUYOF8WdqtwZB+4=
X-Received: by 2002:a05:7022:b91:b0:128:e0dc:6428 with SMTP id a92af1059eb24-12ab2897c4emr6271373c88.17.1774871144768;
        Mon, 30 Mar 2026 04:45:44 -0700 (PDT)
Received: from localhost.localdomain ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ab97e7a57sm9176288c88.6.2026.03.30.04.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:45:44 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
To: peterz@infradead.org
Cc: longman@redhat.com,
	cgroups@vger.kernel.org,
	akpm@linux-foundation.org,
	anna-maria@linutronix.de,
	boqun.feng@gmail.com,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	frederic@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jiangshanlai@gmail.com,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mathieu.desnoyers@efficios.com,
	mgorman@suse.de,
	mhocko@suse.com,
	mingo@kernel.org,
	mingo@redhat.com,
	neeraj.upadhyay@kernel.org,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	rcu@vger.kernel.org,
	realwujing@gmail.com,
	rostedt@goodmis.org,
	shuah@kernel.org,
	surenb@google.com,
	tglx@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	vbabka@suse.cz,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	ziy@nvidia.com
Subject: Re: [PATCH 06/15] sched/core: Dynamically update scheduler domain housekeeping mask
Date: Mon, 30 Mar 2026 19:45:16 +0800
Message-ID: <20260330114516.103451-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325140053.GC3738786@noisy.programming.kicks-ass.net>
References: <20260325140053.GC3738786@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F141100008
X-Stat-Signature: f96gf8gj1ks1ux7aa5sucw16ud3simdw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774871145-891084
X-HE-Meta: U2FsdGVkX18CccrE4R9GMIhHMM7ZIhS37W2FMoCht5/7a8Pk8+E7w2AFEamsdvA//PJCovec4CDUy9Zy7UQm8taLoUvLCrK7sjPgeM8dHd2ljUJ0XbUUdQachwiJgwhPRkDgb6gs93yTAFBBJBWjT8ohRE1Q6ERu2IJ3NhvDo3XIpUQpUMPAsmobbFaaeFX1MeI/C6r+2f073QyoNnUFgr3Z4gbrfVqFaJznfkpYSgBhCKOST/G1MkPuLoGJJGREjihZY+Mdz5e7/a8xmyCVvfAmla738kk89Z8tK2keHB/8UYFYT8o2PcfmlyJvRnmUKh3qK0XtXkCi6lN3Wc6mCuUDjzCYoQ3b5D6ntX9o1uvOprSALhZNl1Z2Gpx2EwetJdyS0gRUrHAtpsTLUwzO3gJM5fCEYuQBTiwXjYcP9D9t3WtI0UIowPNRxjBA4ZPUWCEXe8ZA5GPE1oc9lbtRWqveydjAnz0M7JJ0FxvG/JHi4gdLSfo54zzz9TPenicgLB/HPBkccfMl2RFP7bKu49Wox/8viRG0QV9O7AqQhoLJiU78B0zFKjPfSpDxnyqDbRPboApAOei2/XjUdiOupRH0wig8jtt/zQ7LtchZ1YWcS04WJs9yd2V4z9/jl1sEquNG8+zMVSUGgU97wT8JAs/l+PX92lNFSRYRgRK3Ph0RqvnTOydFtg0p8vnq7bRNwFyI4nhP5wEf0Vynf2CpKX2p4u5j+stiWlz+ICWRZcYLEUz+4qwfQhSM7KZMkEYa9gJHZgDeZAYef/Eh/lv36HvwpuqDuzn3LH+mW/AHbpqjt61DzekFl4aFcBUPghgK7I/y5Y0rq4IRG02rTxaVWN+o4aCMu/6BEFIChOtVV5ZegoJqaJQ+xDAsZoNRIWp8gU50zgYC94W3B9klj0ClbyKOXA5HF1DPX62jM4GMKnSndSgBetFHYD3B7wZgJgdV3yp6QDLM9dHIBaKjhpx
 I5Ty2yZ/
 sz9KEKLsh6UJPayVg6lugrocHw12YI1Mwdsmw6TpT1CHOkVY982g3B0FG/8Fj2ba7jB2HPaSLpjbR6fGlpdh9nu9rmDoo9VrUfkv95i/epiLNX7wt8bsNS0RlXYfpfWqNC9mzkB3uuFUFNjt2RVW78SCaFCuOMLEem68g7NzltmaJBCXgBXog72q8jM0RuvrkMSVnQVe/sRDBBWBw2OQIEEM0EigCvyz2Sbq4zVZH1as374VxIRDlTcMpgEn219CvhCI5Syp3YHAJjElZ6G1u5kGptYqscNtFtnOOo2drna0wmhj92/KU6UA0O/4wlRw55Oseqnk9Zj18NoHI6v22miGc2JWxkcAae+AoGenjUDiCkK6ZZBOKue9v1J5VW6zFwZdhACQwH2wQy6oNm2JlosJgyv/DCxxTl/8eTNwgDlS1kRwoSaX2wQxC/weBg5KuYovE2zNamCdR+TKmCsO3N0V5zeWAE354UNOmyBWJ2EINYfPcKVviubNSWhgn0u9eaWsP9NBZERhyf7QpzV9VR+ugmUFe8w062nFf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 03:00:53PM +0100, Peter Zijlstra wrote:
> Sched domain boundaries are not static, they are easily changed by 
> cpuset partition (v1 and v2 both support this).

You're absolutely right. My description was imprecise. The goal of this 
patch was to ensure that the housekeeping mask for scheduler domains 
follows the partition boundaries dynamically as they are resized.

In V13, I will explicitly integrate the housekeeping update logic 
directly with `cpuset.cpus.partition` transitions. This way, any change 
to the isolation level of a partition will automatically update 
the kernel-internal housekeeping state, avoiding any parallel management 
logic.

