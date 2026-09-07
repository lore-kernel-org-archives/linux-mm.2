Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5170C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C724E6B0099; Mon,  7 Sep 2026 11:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23D86B009B; Mon,  7 Sep 2026 11:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3EF6B009D; Mon,  7 Sep 2026 11:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DFD66B0099
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:35:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EC8D401B4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:35:49 +0000 (UTC)
X-FDA: 85187366418.05.B0DE3EB
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4855A14000F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:35:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UfENsGV3;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788795347;
	b=xqVVm8MX47DJ09Ej473Q2UTqnHOt47zVQlDBLMi+Q6LTBTB1JU4VfLiLAJEiqDY+0zdS9g
	XnLSJ92wrmjI48R0vOJXjgSnQ/vxvyuH46lNxjMPQqgYQ7zm14HNLWF4mZqkvjkDqxaOa4
	1qGGKoB3oZGuA8ZFK6maeNxaPT+pjp0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UfENsGV3;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788795347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5TMs5/9XbMr5XgelOeQD9eKb6gYqPC5LkWTp0niqi4=;
	b=OWD1NMEcVz/PIdcAyDBpENwoR3ikIUQ+00QBwhAVifIokZ8PwchOoYwWn+km4q06h0yrwZ
	kIl9MRrkIDi1n9N7tRG9n9BkHiH9vw0z8hENuakKne617IsFJJc4I0ufbKlPnS7RHviL1t
	kW5UEYj4HaEypr8mdjrUY2hP0dfRcfQ=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-9103f5b813aso27519896d6.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 08:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788795346; x=1789400146; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W5TMs5/9XbMr5XgelOeQD9eKb6gYqPC5LkWTp0niqi4=;
        b=UfENsGV3qscW3BzVFlA0WYIaoF7M4V05Iv33FFvhXBmT2ANoaoX33OAbR8pSKICmNT
         FjboMEEkD7kffd84P9uSrv9F6d1DYscs3pxxMvymk0sjlIyonuSIHgZc1Qb2Asqwqy0S
         1GmUKrsSS9ORM5U4Mr1ih6/UqVRabk3MXS9z9asUibKbdA99Z1LtXjHccNBZIu2G0hd4
         LVxYc16+6EvanLGsTblJVQkAJt/f/zzXku8zyG2d79zGgsaosmUliqdxJN4vArWSfyiP
         7mR5Fx2bLmEDqd8G22eHY/9ZMKRRM7tKDwGeCNAl95PS7rND++KA/QBYoCC0lXZolKMD
         WXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788795346; x=1789400146;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W5TMs5/9XbMr5XgelOeQD9eKb6gYqPC5LkWTp0niqi4=;
        b=AGLnWyFouzEk3aV1Kap9MGD9Xnhs/IkN8kibD3khURD9t6GqhPQbmu4WDqBTy6+KJ6
         jOiRxYsBfrYmD+SMJOXJVvpCEJCBjEb3jmNRBxLrYVfH/aLQV61O5EamCSYS+jdGumiw
         ae5EItPgb9VSdiCFGDgqOV9Rn+m45FynupYCbfZb4ipJuOHBmHukINLyY64+jbGB7rDu
         K4mIhqxihT1CK4Uohz41TNkJY0QH0qJXJ2hsiuro3bjKtuj9zCGc+z1037/ufyZcvvma
         ICUXXdNxtJNT4dCIG98mT+KVDrF7fr8vUgug5aEsOLffA+2QJUjf7vSRCPqx/SXWdudQ
         LrAg==
X-Gm-Message-State: AFuF++keRIMHwNIwxgLoW7PFFvUd48mTPpDcWEUJGCzuOb5oM1TXH+4G
	EOH8d/BzEy8UJ5hXO8LUliJ14XR9gg3b3PgpchR9MDUQKacVtIePzqBQe1P3P78Zc8/OF6n2EVf
	F/YyX
X-Gm-Gg: AYBFou2bztsQPC4A5RV6KHKgJ32bMcTCMXqVsG6+bu7GEj8WQEp6knhP81hUsV14haQ
	M3lmM3npjVqalU+Jauzt6nDW0rJD7vaXIqMSjgApQvNcMOp3a0RdZvzRGN2yNqZCELSZ5YnG23A
	V2oi+dGNVInbA4zy6IGyExb+TJ9VCMtSIA4BsSWaJeOMPERf3fMX7RR0LA+xK24Y3FkES95bJWw
	2wwo9erruK+nz4MQUFpijwQVQcmMLQ7StRgOQeTujXAx8QGOD4nJFWVXj53VDLoOmA41FhVoHLd
	3hpsTayLarsCVaS4Aia+K7RLJj7FcxWZJ7bssh4QAXlJXpM5nyaj8TaEHSHnVA3zPbvcYv3nVNV
	EWTbueVo2HHreIU+JFDkxKh6ajIG3XZ48+MABaF921bN8O5Dq7OFTAH8XL9cB4xBIBWfQngrbSP
	m697fxxBpMzpMXBHnobJRwl2ojXq0YHK6F8by/7dLLSMHZV2jcLVg06OM4FrogccU/ckoXeFMSo
	OrUkVNk2He16pFY9M7VrIcv11iJ+pY/ayyTDNOw8jG8
X-Received: by 2002:a05:620a:1a06:b0:939:fa7:8df8 with SMTP id af79cd13be357-939803acf3cmr2336507085a.11.1788795346286;
        Mon, 07 Sep 2026 08:35:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9399cf10c7dsm485350085a.15.2026.09.07.08.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:35:45 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:35:43 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, raghavendra.kt@amd.com, shy828301@gmail.com, 
	baolin.wang@linux.alibaba.com, osalvador@suse.de
Subject: Re: [PATCH 2/2] sched/numa: scan read-only file mappings in tiering
 mode
Message-ID: <ap7ZXrxI05xyuNn3@gourry-fedora-PF4VCD3F>
References: <20260904182006.1562449-1-gourry@gourry.net>
 <20260904182006.1562449-3-gourry@gourry.net>
 <apsX_E8GBzfp6lui@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apsX_E8GBzfp6lui@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Stat-Signature: i5d6eigy9k9rbk3tciid9r4wx6q95jfu
X-Rspamd-Queue-Id: 4855A14000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1788795347-665066
X-HE-Meta: U2FsdGVkX1+bCcu6a2wZ41eeH54AO4Crg3lqkl2hnC/ARY47drtmERO6apD0u2p7WYfEKt7hdkYty4vC7xr4DKuoHJbevL8hopBktB2gfkg0o03tx5zmVeo5FShBWruHGv4+f923D12rkapbZrrwbCgw3DJ8sBooF5LXpcDOqbfUh8jwh1DpjIZGcvD0q5Wkl++YKZloo7VewLPOSAIvj7tP3mMsXBusxiFHUD1PbT396OQPCF/SvtVH7xpCnWKwDvQjlwmSBlM9uEYAHhqEAprcFF2IQdr5JRA0Tv5ObP9WKw0orz+433tAV8HCJkzhGtttZHeIkuxJEKpTDTalIOQayHfOH1HRQKHV47M32sGdjBuF2Qm2JcWLPdwr08LzWWbEfCR7vjStBUniyIhTmOtXbwID0csqR1B+3wdc6MVY1q1d/6jKsVgxe9zS3FQdNtgHEjfDRDaNPJGwe9KOqTKv9AYydaUvHw8nPReNvmouGEQnWnfbPZVrsKgbSua44UNfkUEs4biacJ+BTaGgXkOeWk+suMlWmGFMOCcDLhdg7ts48HUojr9ztFfIHg1wo/5bB2EDNnKpFSWiKzHbQaHR6qhv8Z6aaZFwf5jylBdOi1Q2YtNv+O3DUhVj+mHsXkRN6/YSqic2EdCX0hHqnfQ7NYLeZGPCpKf24uQ4OoDbJ3qbpXAvyPpJZlEKBpO+ha9u/F1DWKsnFrrr5Pl7Wf4mlpqwKmlLMJcELGrNxKaRFv9OAmf1DvMBb6SPTQO4BRTc29BQym832PAILkWuszhAePmXcbNUCeryUgeTh+W8j1A4HIebaNYIgRjD8c/jhzx0120AcqyU/pI5THUXPnkdmBLGnSvrJH1jc/e45R2YBrnInGYQxEXWoVBneQDuGiaOlQdhfrwKFZeEU12BldCaaOGCPc428ornFMBe48bgNBIgZsGMyaozpr3Y9h+l9NscBDbEV4uIxKlTCjg
 rFrvAilM
 IoFzfK8Vr1gxVLaQYk8QBL7yYyywpQfG/oy4OWUbrbcjcQDSz0Iu45XRDpXsB0GFQ8p1PrhmLCUT5SsiZLLooyKgoH1JO127+lyf8LwGt+zG0yY6kPd8mqT/qghwzd0sNKhAOROe5fw4H6r9toiuZXJRURocUtCc3r11Ygpf/cvPvL8ulLI/0FvSqmJN8bh49hiZwuoPGYMQi7C/QlDUrbt+8vfJvXIdtWGsrPg88qzBSZaEBagieiCbFmHJEtkz/qELMIOkStJrZ9vyc/T5QSx0wqu2ePZnN9iIS/sYUsbrS9PE2ZOBDQIzU4IemBPFBnYtiP+GlbkyWBKlhxb2wA8nFZokxqoS50LFhPLlbKqJXR/LvrgmaoWdvr/RjX4MfKFs+7ywkNEK8Zww7fxMfzOb7KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 03:31:19PM -0400, Gregory Price wrote:
> On Fri, Sep 04, 2026 at 02:20:06PM -0400, Gregory Price wrote:
> > @@ -4302,7 +4316,7 @@ static void task_numa_work(struct callback_head *work)
> >  		 * VMA can cause others to become "permanently unaccessed" if a scan
> >  		 * cycle is consumed entirely by the large VMA.
> >  		 */
> > -		vma->numab_state->slow_only = false;
> > +		vma->numab_state->slow_only = ro_file;
> >  		if (!vma_pids_forced && !vma_is_accessed(mm, vma)) {
> >  			if (!(sysctl_numa_balancing_mode &
> >  			      NUMA_BALANCING_MEMORY_TIERING)) {
> 
> Sashiko thinks this causes unneeded rescanning, but I don't think it
> does. The cursor prevents it from restarting, and when we loop back
> around reset_ptenuma_scan() bumps the sequence.
> 
> It also had concerns about concurrent scanners and ptl lock contention,
> but mm->numa_next_scan only admits one per scan period.
> 
> Either way on a rewalk the scan hits pte_protnone() and moves on.
> 

On a second look, there are a few issues bundled in with this, and the
change required to handle the concurrent scan + mode=3 (_NORMAL |
_TIERING) requires a bit more complex of a change to fully resolve.

Will push a v2 after some additional testing - but that said the
existing tests still stand.  As-is, any mode with _TIERING set is very
broken at the moment because of the filtering mechanisms.

~Gregory

