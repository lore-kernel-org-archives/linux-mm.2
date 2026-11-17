Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71842606A883
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=GQpcuAv9
Received: by kanga.kvack.org (Postfix)
	id 9A2EB6B05B8; Tue, 17 Nov 2026 04:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97B326B05B9; Tue, 17 Nov 2026 04:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A946B05BA; Tue, 17 Nov 2026 04:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 645316B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:29:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08C1A1A0389
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:29:29 +0000 (UTC)
X-FDA: 85444088058.04.EE04025
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2310E160005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:29:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GQpcuAv9;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794907767;
	b=HMZ1l+DHBDWbNj3oNrfkFd98ouPbYGvTtfmdDgsNxi7Moi8C19PqnnIvceg6QGCXvIEccl
	tnQzzdH3a43XcZGdHlNH1HT0pHz62WSYzl4mZsZ2LpgqPDZvPt1cFq04/qyOrC5bi8A+BH
	JLLlfhhm/+kCCslDzDbxKZpJOBFKG5E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GQpcuAv9;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794907767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEocy8Dp0tBhMjAcDxR6vmj47rY/webAelS6aeHWYi4=;
	b=dTxj9lDUyRXECsbaY9xx2FlGpmNuKzNAcMsaIO09LpHAt6foiQJaH2miGVkDS/a+5AWggA
	NGahwC0UCvk7csW5b126Bl7sn3h0M9kUTahCb1mLVUzjCwEtzYhs7ULySZmmEZsW3gzn9V
	ChLvcHa8vcQdGu43DQOPaGodSCbAGg0=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-949657a20d7so288774385a.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794907766; x=1795512566; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CEocy8Dp0tBhMjAcDxR6vmj47rY/webAelS6aeHWYi4=;
        b=GQpcuAv9axkHUGiiZSYrAnaNqdawU3mVUm6vC9nPHY1FBDkOa+OvZWMi6UOS1tss2G
         fPHNuQHoHxlXYpomzsbXDvQjIXg2fYHVoSQLDZhU5RxjeTxqpwR6GyFX/MUf82ZdYvs5
         2RVDdu+Sf2L+0UwksLJU0f5fClsC2BbsraQcX0GpcMTYJk2HvaCIRFDDCRvJPQ/gDusX
         dxkpjZQ6QAtaZ8X2EUBnaUlrko7FlgtoALYTU5ZAx2mXLkb1JyWRqopKOL4ocVL3BwS2
         FsHSEpJVU7wCCsGzlhnGGmw8EMeWPN6Pne8d2o0uwJ7wJZzN+s9NgJu+5i2dyPjCFTg5
         k73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794907766; x=1795512566;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CEocy8Dp0tBhMjAcDxR6vmj47rY/webAelS6aeHWYi4=;
        b=x1b8LCPpcxvDNCQIaIISglGmxL9rXZjdipGspo5thKDixEf0FPANfu3LsW/0yHjHFr
         aaN3ytGWs1zyquMD9qJWNL93dh05Cz07auV1RL1UbdFHQTKq1XE2P/9MJJ9gtG4+PXxr
         01kll27vAiZSqzvKe1Yg2w/cjM1mUQ/C31GRKx86fcv3MqHNMPDgjdcbnEKSy66XLsk3
         IkCKE17MzQufUb+XG+S3WwDZseUomRDewpKtwrc3hQU9D5iKpD8mEXIuOAPusdLTqhEK
         +eoW24P8dvazq3VS5OqC6ctpmaqIQgHnA/QgilyumOLeAwj8rZuhRi8ZSjV4Vd0zQmna
         crLQ==
X-Forwarded-Encrypted: i=1; AL+hErEpRt3uOrvzIg1aJAL472dHfqTEyH05ESwDGx7nd2KE5TKeHKOpPte/jDR5dtPx+sC8pIS/y3wHFA==@kvack.org
X-Gm-Message-State: APuU4Z/HbzBa1gVuUN57xvBStzc/qXKdm5p7acCNnciA/khIEL7062mC
	YADH7ltIhGOuRtZOFLICFn1qqithBFnDslfkkdhtHC69/24t01iB7eYr0cbLrPRjiBI=
X-Gm-Gg: AYBFou3/Pmf/YZtSX2wTa+/NUvlIzcKoKcxdvyJaQtUq7TS9ydg2z53/7xlXZPUtATY
	q1D2aHpIhwLwH80ZkLDO/0zDim6QS3a1E973ijlRgtg1dLgTjR0PgUhPdF5w6u4TJ1cKOIA397Q
	kZNcjLkLiF+JgOvXzHUff7MX7zT8o1JB/nqSH3Op0W92nfkVKkdzSD2Pl3StBr65blDQguRxqPs
	hYAXQQpsAg39rmC0uZ8GpmjAKYv5gxbSEqUHERXZiyFi7Zkk2Ds9vRMaM0Vs322UQ8+mEs7LUZ+
	Rawx6BLgdKENIxpPOfsZMGeNAYHTffWvl6DQPHE0nMD59LbDHKUQ5VbiKzMKghvYo1iPkBwHJjo
	Nn+iMkHPVJ2nezDZ7Ixf9q11Qt7DZjpMQwX55jQGj0sfEJqdUN5B19D4jZLMXyUiezQf23KVk2J
	XQCt2tHmSlJjQeIEJuhLtkGMvATp/Yymhp0GoW/gsQeKCqabr5Uuutd2MJ3qAYvHP32PPgHB0rh
	J8X4j+qLK0xfrkMciWTmqyQtKSPRdfDvgbOPQI2kMT/7Vm+L0SaC8WHvB08ZK2T4b/ajm5bA90o
	NEOrwzZEW2H0mR3NqsEV2tQrrmatpbuoe2QLP4e7W61XFC/0QUeajKuyYfdbmu8GkQMS3uDtijg
	7loBda7o=
X-Received: by 2002:a05:620a:1b9c:b0:949:3302:1d9f with SMTP id af79cd13be357-9494bb92d8fmr2018520785a.78.1794907766395;
        Tue, 17 Nov 2026 01:29:26 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c836079sm1045873785a.18.2026.11.17.01.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 01:29:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 3/3] mm/vmscan: consolidate promo vs. high watermark
 checks
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <20261116232346.788145-4-joshua.hahnjy@gmail.com>
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
 <20261116232346.788145-4-joshua.hahnjy@gmail.com>
Date: Tue, 17 Nov 2026 04:29:24 -0500
Message-Id: <179490776479.482102.15273104703914268640.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: som4opx1putnjb6ihr9aakoob6ie1g5c
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2310E160005
X-HE-Tag: 1794907766-486335
X-HE-Meta: U2FsdGVkX19THiVCMcLfwAYFIhsr9NjkljSPC7pX27HbYl0EidDYY/5nVq4RtPG1+cAVjwy1UnXIi5h5b6pqyQjaGolfX5n5t9MnqDRbYobwjFYC0oZCjD0MzfbekwYhWGBGgeKdfVw3TZjIED8VX2pcokeBCoDojd+uwU09oDLrLtuLozg/KoziHRFgPP0zpY372VBM8yPEEdd0Y3JQ9zp2j05mnQc3sA/N8ezUfuYCUxbvypGWyojtQb0Y2yFKee5tk6pnPuq+jDHjRlqx1ce36TrKCukWTdCEQSsDdh1S6mKhx1DOhUj0VpC4aOOIVWpEuuxdglpKZcdlqbfmFN5JsxU5ooHR+jbgF+8Yr0QtXvFAWEQpXAL1PLlu4bTQRYpi7fCQwjMctfiwaWeCaPBHmBpQ4UrzYqGQ467BrBa4etdbbdP50t1mlTWhYdIjvCM2TWlo9Z8YQllV5y+y4O0k6m5VmECLxznCfoFQz3AsrJRcJkotmwr0eZlJ5jziPMdro1aS1BAkSjT/PX5Xa6vmT5Wl5yiC3QD9gvcsVjPkkKqP+gvgtgiPZSOqEgoErGLWvjz1g0khhAC3e5nLmBGiwYddyVKIz82z4cuw9Wqz5HSZ7GnAekBctCNeOxD/pRa+BmOUvMY67MiAkCONAnuwHbyErnSzAn/bkBBaVYVEdtzz5fLg5q02XPUcrD1+WgeH+u2f3lfIoOi0IgFgwTPhKJ0AoeplkNJh8vIdgMOIOxTWml3BSbkOjsxwz8m+ENsZQHtOT3TL9Ma/iu01+M3SihmP+RycAlmmn64guAM+hBk6+VJC2ELxjZ+eEIQp4/PW47MH9f02PwDlh9L/p9zfOhSGdN9jFmXu5rywU6LNPFpYLuGXFfAEPMkQICHGKKFpuqaKx7Wg388M+7O+2DKr84Pchb2/+sp/f/6Mmj2WVqsaEP6+LH4TYeu3jHI42IpceQi8xwAL7ce4QeO
 A2AWBbal
 VoL6K00tdyoUG/Ll2mtRcE2h/Um2BajYSjWH/jSLfA0UhTIgC2V1cSqZDyfjZ/PeUq30h7qr2JYndVxehIF7wHS32/j0JzxlmIzWrm5C7zOsY3xcSCYHeoclZYmdWYHHUAKoAmUNVj4NXCCcX9oCNtPhRobJ5/StkesO0/IZHSv6zJy5TS+YJOBze4YJ10K+XYp883LMuXlwAycuMiqMA51VQpFashmpx1vWBxXN+6mCCG1+wCZS2p1dv9ClnzNDWS69gyUvqLCvR8Vqtyjh6Sgn4AxkCzapM7pWknjhBpirwYZSKgGVUGYq/mfr3XmLZv726IuZyJ0RJT9Kdg8bfDnefUfdwBQonnBFmtRcJHIUGrAkVMFPY5Ps7HT8Jg6vfAMvEY/mvixTMCwbFk7nSBAaJ6W7gFfF8wFgcXryyBa42YWmD85OseFInB/ATHBJlcvZ7HwTmh3Qgo4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-16 15:23 -0800, Joshua Hahn wrote:
> There are three sites which all check the watermark that kswapd reclaims
> zones up to, which is the promo watermark when NUMA balancing memory
> tiering is enabled, and the high watermark otherwise.
> 
> Consolidate the pattern into a helper function. While at it, remove the
> include for <linux/sched/sysctl.h> in mm/page_alloc.c now that the
> dependency on sysctl_numa_balancing_mode has been abstracted into
> vmscan code.
> 
> No functional changes intended.
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


