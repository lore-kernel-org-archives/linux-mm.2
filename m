Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F96C606A336
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=WS6Idl9z
Received: by kanga.kvack.org (Postfix)
	id 6B6616B05B9; Fri, 13 Nov 2026 15:44:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68CE96B05BA; Fri, 13 Nov 2026 15:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C7E6B05BB; Fri, 13 Nov 2026 15:44:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28D106B05B9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:44:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B32C68018F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:44:14 +0000 (UTC)
X-FDA: 85431273228.14.FDF443E
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id D79C0180005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:44:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WS6Idl9z;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794602653;
	b=D+qzZsYZ0g8frgEUEFT4Hn8lPOmyc9yLncLJhfV04/WgpLfbdDxK9DE5vg7nDqPIe+wqvO
	HbTrWmuXX0NmCSwZVYderSz+vK7TBgFwNSwGQJDcZ1cJrgnRhCCFuW2nCxtlm5qEI1XeB5
	loweXWx/p1QaR7/dBCt2fp4jSfI8ejM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WS6Idl9z;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794602653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhL/M8HEMn0PgEwzPCvcTjQTkSJqxruxvyvf5fU6t/s=;
	b=YB6P4u4YA0jz0DBumsqZfu6gNNry+zXYL5XpWA9rKNh+JR6AWGP6UPfJGYV0EX7NHU9JcF
	oF2/5M4RRZbbCRqLQRoUzHCACNxY8fIzO5EnYfNNrBFu1AmvZvAcm/Kns5NhG3nNiPC7CW
	ZL0wL4eJkvOIJROiYuPLvdvMbw2UQsI=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91e8a05ec5aso29559386d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794602652; x=1795207452; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NhL/M8HEMn0PgEwzPCvcTjQTkSJqxruxvyvf5fU6t/s=;
        b=WS6Idl9zZ5yr1trHPXseB/MYdDR58GxaVSzgY3E3sa16t0u5kxmQSA7heHVMKJmxXT
         /Z7Me4en6e0DmattoZX4aHgnkZJXOwxe/E+vnNwhWJzdj1zUwtxAugrL6x7Ptyxzg7HJ
         vNMBEl5qjcyrD/pMG4qma7LLRlCvZP7t5ercTGUBfa10sloZ/FbupRSZvoHzjvNsbXnH
         pj0Au2ayXAH7gqlHdF1fj8aLYw8Hfd9DWJjLVuMnOtHYZYZy39e7kT9j0MBQuEszjYwT
         g2sk2gU84hssCkotTKtR+lWrfFIZyWwAs+7eqrrNCrefYrwuqaByFdyjgMoLJGInEoLx
         LStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794602652; x=1795207452;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NhL/M8HEMn0PgEwzPCvcTjQTkSJqxruxvyvf5fU6t/s=;
        b=kM2HaAZJGL0rqi+nFGSRlGcud7j4ImPTxynvHOU6Qx1bY/vYSl9TJGz5Xpwa5rDvGW
         /J219K4S4f/+I92VTb0ufiHN+MgntHPKOW2+RtET/vN3oSOOATCq1NNXcgmOY0OJGSXf
         d3nFCf4i2BJZNLtXfj0hCWDakPTx2VW0y7yZXLoJ28YGUjAJr9Gori3QgsVSHj2AT5vL
         6ENA75cV6qKUu2vYKcc92REyrboRecPtjNa/Vy+Lr76DKCGDTilBJunbsMyYZGgOqIi/
         xeuiWrUnEc6gtT69wbFmSiHhKgFe8er0nBz9icJfau8Dc2dkDOS7uddg4TYKX4EF42EZ
         SykQ==
X-Gm-Message-State: APuU4Z9sVn8zOl3FNU2Eykhy3nOiphGllx6LCY9ncmvQHbMJnAdc8pwi
	pQAV6lrt5WPR8oNny4iZoqrjlPDuh5AJUzAWBmxFfJjVlx+Nmr9gzzVzIc+p+mt6lRg=
X-Gm-Gg: AYBFou0rHt1iF6bdtzQgT+vyadIjFFHaFBEmCkkZHo1qdwQROTdFDHdmHrYUU+xCWAt
	idwwRwFrw6I/aCRizJBFoY4BB7vPfOrEzZ0mbPaI1IA5yJIVRPC88GKTvXZIAu+fjbYGmENLLr7
	gwPk+hxejGGF+T4T0lvLO40j36DNGy2JeBX2/Kf/hQl1SBMQ2a7HeP3Q1t9Ba8L5A0LTTRIjfXD
	JuM4OqhBIGi6yHHZmp0JD5gUCcup5Rmf102eBjcFnzd3SfToldfsm1UbIKggVi7UZ0TiNHL4kpk
	hoLS4rjrQun/CjScQmSgy4a/0fWyTCHIw4TBfIoaCNzXXI0KGBy15fvAhEfqCp1gYeLTeqrAILz
	aGkQPCi7fASE5GBOg2ZVqFytXDMYyCtqOvFFwDrHMUI04Z0acwLfI4giEQbN11QpG8P7Rk/+1sK
	b1KH6rttG3TxVbi+O9d4YaRZsLsgXJU+Nn+u42zMW8qXXL0ub2UnUHn6PHl4+6Gcxa9tKKvwpSj
	QIIhKx2MRFiDrc/QEj/WjVR3fYzpa1O8hiaBlsUt0LedUC00wSVW7DLwwMs+Tz2LT9Nz3Zm9LPK
	0eS9NchjIcKk2wx/zdqYJOgZMFZeeVyxxVzbp3HEAB77zRyzHUY+1/FrA7f+njWMsYqjEwX3slD
	Y7nKjhjw=
X-Received: by 2002:a05:6214:450e:b0:91e:b670:f9f5 with SMTP id 6a1803df08f44-91f2401477fmr56726586d6.3.1794602652059;
        Fri, 13 Nov 2026 12:44:12 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db49c5sm28150796d6.41.2026.11.13.12.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 12:44:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 5/7] sched/numa: scan PID-inactive VMAs for
 promotion
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
 mhocko@suse.com, peterz@infradead.org, juri.lelli@redhat.com, 
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
 bsegall@google.com, mgorman@techsingularity.net, mingo@kernel.org, 
 vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, 
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
 usama.arif@linux.dev, kas@kernel.org, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, 
 byungchul@sk.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
 hannes@cmpxchg.org, osalvador@suse.de, raghavendra.kt@amd.com, 
 stable@vger.kernel.org
In-Reply-To: <179434297609.2530531.2349001562856798404.b4-reply@b4>
References: <20261110150446.2452975-1-gourry@gourry.net>
 <20261110150446.2452975-6-gourry@gourry.net>
 <179434297609.2530531.2349001562856798404.b4-reply@b4>
Date: Fri, 13 Nov 2026 15:44:10 -0500
Message-Id: <179460265050.482102.15374067770225444971.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D79C0180005
X-Stat-Signature: 19rbaieyg86puqn6mf937mi7e13qot6u
X-Rspam-User: 
X-HE-Tag: 1794602652-718244
X-HE-Meta: U2FsdGVkX1+rawXqUjzOI9Dg2X3izXFrGvwRpZ6SVh/BV8KnRDQa09N1PMqhAh3kkXNtAS3WEEeK9kR8MLTSz9IqyawBbwhYjFNqzR79qPyr5qJ3g79hqFLiT4Huh6k3+gIPJ/abp7QND4MXWFsV0aoVu8mpwetvUvvXBTU92dTFWC2ZSRT9ecphjrdKSNbKlThkMlc7cCI81W3kmLCric+mGzENXMTzKh3Fymz+t0GxTL9tzyaYnDYsxFTlK/ycCiHLav+/bXTPWHW61PXTZBQbdxhC2Et3ukKrFE98op23SqpvDKa8UoFQ7QWrMCvULaQ9xqCL14x7OxFEm2pkiP16YqNDt9OG+jP2ZidrhupppqMdD8XqIYDZ2tgJjiD8+qUaMP1Vv+evjsuU8NDaGPAzl/iQ4rn8661ympznG1wK2d9CvSl+whe5j23+a0TYPwdLILKxcY4b0invxCFuHU4Ff9hU+09wKOGK9dRalkn4yEvXid8uPqnBFX498bm0nFUInPCNHRpVFxHLL/R6j3WaIBBiK8+dVCzb6ftok1F+sbOPs3qNe7iFAdc0++X86ldOnMTxgYJrBIvz0YznP244fauUCLc7lS52NlBoDLTohOVj2lneuWA2QMSJ6IwoO0LwDYP78wjMz8wFKHREZVh++XdB4FpHgstmLz7A32Ws4zIeQJnUR84w6Ab/5bBF5WqYPnqfoNRhlS5PmAhTMhSME1Nhf0+nkgtLqqHYqaygnIZZkMIqwGLDnE/V0WE3goU+JpHXsc1WUyyZFDfPivZ6aXgj47+5f6wXDLCuCRl6awd3rEqmv7AHKxUW8hOYZqYwVZ3ye7zy5Y4yWz57gig3B8tdSt0K2XfafLLTsKMqegHiQguA5yA8rDqRqBoNzGNsh8MJvp2ohn6ldvCFzKFRE1C5zGBfeebWP0V6/Fen4FYiwwqbVOmYGnJCSARyYxcyI6QisJCMyi97QLW
 BVuCzIhX
 5ZFwU8Lm6suIzFCCMHcbde3hwK+9bR9vKdeA5ia6Ho8Mlt7M9EXvV4YpbuROGzfZe+EELStT5iLJ9wRvra7yRTTPJ0SjkmPEJxUtQqERHled2j9yc7sMrUP9yRPXWH9oVhEfM9tJIity8DWpeVTKBjk6BlvKJYR2s4lmFCqW3zIuiDW7E4lxaSK3VC9oxLvYCEF8fse44AmVLz2qpCpeEjUDUNxEQYYdkzGdqlHkW7rAwnQqplF4nISTW5HkBwxT62H+dY0EI4uQ/kmhbx8QIH3/pNVzxZI2yPq9JC7PX3RzdYI6tGwh0DuNOPEduclXozNJEFyG4ZjYljxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-10 15:36 -0500, Gregory Price (Meta) wrote:
> On 2026-11-10 10:04 -0500, Gregory Price (Meta) wrote:
> ... snip ...
> 
> Sashiko report feedback
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4249,7 +4249,7 @@ static bool vma_needs_placement_scan(struct vm_area_struct *vma)
> >  	 * threads can help scan this vma, force a vma scan.
> >  	 */
> >  	if (READ_ONCE(mm->numa_scan_seq) >
> > -	   (vma->numab_state->prev_scan_seq + get_nr_threads(current)))
> > +	   (vma->numab_state->prev_placement_scan_seq + get_nr_threads(current)))
> >  		return true;
> ... snip ...
> > +		if (placement_scan)
> > +			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq;
> 
> Sashiko took issue with these skips, but its reported impact is
> overstated.  It tries to point out a pre-existing condition:
> 
>   prev_scan_seq skips an update on a rare corner condition, but
>   now the same skip applies to prev_placement_scan_seq.
> 
> In modes 1 (placement) and 2 (tiering), the behavior is exactly the
> same as it was.
> 
> In mode 3 (placement + tiering) the result is that the starvation
> counter isn't reset - but everything still works anyway because the
> VMA is still being scanned.
> 
> I can follow up with *another* commit, but it's really low impact.
> Not sure it's worth the churn.
> 

I will refresh this next week and just address it in another commit.

-- 
~Gregory


