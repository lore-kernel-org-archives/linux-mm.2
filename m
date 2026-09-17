Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885EDC982CD
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C166B009B; Thu, 17 Sep 2026 02:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C7D6B009D; Thu, 17 Sep 2026 02:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832D56B009E; Thu, 17 Sep 2026 02:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 536316B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:59:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5E448026D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:59:51 +0000 (UTC)
X-FDA: 85222354182.25.29BB638
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A72C10000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:59:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JE1Wx8to;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789628390;
	b=bppKVgAbz7GwJu/G462RmJavZlzCF42gQtuINvB8Q8BdPdJfMHCD9ft72UBx/RBAUdOy8u
	ptciiOzPZ4Lx+jMEL4rFp4XGg497iHDIRaC74JscrQS5lloZ/JYS84RnUnxHK2M9Q+W12L
	gQsAeWQGhi4kB12PKecY8A7zeeZPCzQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JE1Wx8to;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789628390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKGEnw/rGHEkMgptaV8n9ekSmooVW4BhmhAnYjj/TSI=;
	b=AnHishSDSWt8W2EByshqDexrT7PU2up/mnRMCpnnNYEBmch6pkdZ9Qzq26h//ZRi7iWz4T
	yYFYb5BBkNio5PsbrgFTN2NV2tHyMX9Qc8o+PhmqoCCDfFVdXU+DECswbAc4//ve05YA90
	T6hMseLlceqpReVIKv+AqdOdGMX/G04=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-531034aa31bso3523721cf.2
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789628389; x=1790233189; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AKGEnw/rGHEkMgptaV8n9ekSmooVW4BhmhAnYjj/TSI=;
        b=JE1Wx8tovuqlos6YVfi5lRazC2vIkCuGfn11KiQyxrVnHhGwzAX3fQISv7zLxSyZMI
         zMk6XW5zp3Wmntxt5KvR3HeHwUwipi3dyvjQ27jzKOyAVViqnhQtZElRtWhjfF+I13c6
         rTEybiKHy55VIkUu9y9chdQdCptjX/fdwD5EsQvWy5yJpo+C9WJiVYAe+n/DhsjxBbOC
         W9Vg0quM9yOBcjNCB08nMmVeNWFHpBGnjTnLpPRQiuVW+zb9g16PIHHoGq5qjJ8/MPk6
         QeRkibspOXiMMHRLmLGwmHj7tsxmPg4iTSNY6U9QIT21gyXW61KUl7Ci3+2cJgKnslx7
         5pAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789628389; x=1790233189;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AKGEnw/rGHEkMgptaV8n9ekSmooVW4BhmhAnYjj/TSI=;
        b=puB+9uJWFxOEmaAdu1PAAgH3ExL/WNGdI/xvnwFZtbRaUKjoNvU0pUv8VFgiEdiUpR
         NIl9VXhT916HP7i/DrYujsagwkeyIvjJxgxvnAlmmzP032mQriQRGG7wrSNnnvBJB1gq
         bQznKrve3y8DCb861TMZGphOPmgsWwNa3KuyFI4p7WOrMPFB59zY6FusrQ+e87LGKPfS
         +4MYgiD/B9KKVDn8v2nh67mMNxiq9kksUWniBrnNceYw+WDdFrhIWdPw2gzbCqRAJtrB
         qdfM11dQf3vpu05ctcKb9X5u3a1syxqS87lYiaO3FRsRVFB/ZVqax9TQWjprSp/z7OA0
         2z5w==
X-Gm-Message-State: AFuF++kcwcSakb8bYPnV8xi1+rSJXTNXwwEJ6efgtThblkvy6PmPx8T/
	G4o8GcmD09aXPXuFLqkthn5s4l3P5bkhAFEMNm6Zw2pvD5WyYz3VMLb9I6JwEc6rNnc=
X-Gm-Gg: AYBFou1qVlHNLdbqYVcVyXOGm7lH1ijeFRYas+U88XX/31/oRVmWW6ikBOLRlCnJhBH
	ZwtRBHmllFy3WAXq9h+AzHV45u9kOl3psvyouYh6g4o9yoFjfE2fD5jqnIgZe2g3aAwBzkqWRcf
	xUtj7GfEKs1OjkIkdyTXPyzHT4aRJZAFTSINIEIDa6S+bWadSgbvHk8muDXYJLJlpEgTyc9lIDa
	rovbRjCBaZT/4GvqwT+w2n92KXVdDECzeUeIL+4oclmQ9QqF2q7wKFQfxiD6gAufYMsYSuF91on
	VDDZ25CqaU9MCvDbJ31PdewRPZeMTdi9F5z1rJ3suYZ71s7VUJq3+r+CttK9TJ4P/bqB4Rr78WC
	xSu2Be/kO8NN9I0y+5QSh5UB12F7EwZeyrg/DARJ0+SZojhrG3hP/uoaqpcweBpuXrgmAiyC/07
	nDQbOQqgUIUYilh1rxaslGlevZZSUEylrVLfp9ndlVtxN5alBr/LYT9rMoAyoNoWw+9i3P7kaoV
	vm6f+4OBXCJHm66/KEIbPaTdJcas5+l0dupcatyndLS/Q85RD+vo88=
X-Received: by 2002:a05:622a:1388:b0:530:ea12:caad with SMTP id d75a77b69052e-5327f1622e2mr94436001cf.50.1789628389177;
        Wed, 16 Sep 2026 23:59:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5326200b8d1sm41492531cf.12.2026.09.16.23.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 23:59:48 -0700 (PDT)
Date: Thu, 17 Sep 2026 02:59:46 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	osalvador@suse.de, hannes@cmpxchg.org, raghavendra.kt@amd.com
Subject: Re: [PATCH v2 0/4] sched/numa: stop VMA scan filters from gating
 promotion
Message-ID: <aquOLzXGdLmyBaIT@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260916223525.65ae1628b1457a716efc298f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916223525.65ae1628b1457a716efc298f@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0A72C10000A
X-Stat-Signature: 7wudq3nf7uy5yuq63xmbjndi4wfw4uq5
X-HE-Tag: 1789628389-69770
X-HE-Meta: U2FsdGVkX1+xhqwqagAITD7fPE8dn//gJUexj5pqrAHwz2+IYosgZIZkOXZvTJaCT0/ftHSqUcJYU1bKWBOnCJNVJbAV3sm10GsXuPAA7ZUQY5MUyF8VWJdqCXSsM2+xfKi2i2qT9asFQ1PLti8Ac/WxyIahxZf2/F4z2MiSPHbbIN/MuPG2aGAvuLmJXj5hsEDsEhjCEFxBJGmlv+xqPuCo3OXBsPQXNHD6vYy03IatHV5TtQXqsdEv+CvDrxJcFP2Wvrjco+gbRkidjBuf4Xj28fwJ9oE221KuOHWcfO+IqD8RhrOeNfWio5n+eJbJ0Kan/6tFqsL27uafgHjiuXbf/DJpkfQvWpSLJT2hvwwEyTMSC4UVKmAmViDgyrRW6Cp8lvBUI75XaWb7ao7ZQGF8nMv2BSXKxwe7cgiXi5M33M9EdaMf3t+KIWjyiiaQpdrjc4uHYf0qmqf2EIno2TBZyyhCFQCcyyNokKotP7VIaBMj/owkI6zyavp3PiQWBn12DSXyRg/cFzOrClP43oL91ZzNfjYonSMxJzRD0TiwOBhG8jUE/yVAImSZD8TuKVtyrqJkl4kYIy85bqTefkyLhmC8plWM1lTt3QmVOYDRX/xyJu2UY8pLNNbPScenuqI+DRC3l19yFPywYupTz9zB45ZxAGE1cobO2LKTX56x6Tr3aiWXnadTnkL20mnrevs7NglX2cObcObG4srte1VsJ5nZ0dyLhYniAnah9GQuKKbCo+hPavLC0ldLUYxww8Z6vrWjFGLleT6D0PDs0nUyRRBgV9aS3TZ4xxsmDG3eTcGaBtBel+VCk/vbpL9ORZ7B3APuOWcITbJ/Ev91svrnF/xla6bCbc/0PhN9rq1+LwNFmM8ME6KWLOxt7GKcBVbWrda186b0eafQW60t6QwUEwrbRi40bDQ7rFD+KjG9335cEZ4jf5JeNFUpADZGupnuMmVCIuT8mYaVlUU
 C9qGEzf2
 JDX3drMKCX1yJjQSs47KGETQDfL+tUHkCm1xKnIJTyE8sOb1i//FN3/senPyi5quJ5bTO3rEOjas1qNhznpHwFW1YkTD3vGMGn21cjErGxyeqyQV4ibLHDdo4k5ylrNdC/MAAqX3+dqLGjN7Nqcl/bT/U9G1RowL71DtWlVZWGqFFCpiQ3eGb/vAuflq1Jo5B+s2rG9/qPxIvVF5YYNtowvWsWUEFGwfpTaFmw6KzKc+bTOEfcfhbdX1DVovFsHUJPmttW6oTIGQKBIyyQTO1cxC3Kkjvt11wTRjLg1sEnBf09r9DBXEeY5zhh7EfNnGSbEgJwYUHJmhJnvWAc1wLB4Ke8tVsfvBt6kr1xo5f8jBNgvMyKfAE7EbpIYnG3o5mUxYlzr0Gfoj0t9m5Ur8CthKmOA4tluaNjF7Fj6WWfgtnw8jNBIbKF2wReNbnkaoRjvhSm0RTkWjiFYCnPDb7NrptARA16aOoMIJTYCGWRegJIKnXXVpNSv8x0HuS/wCNLFH9Eq7BpNK/GxkmoxySQC7AoPxVP2C1n2Lh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 10:35:25PM -0700, Andrew Morton wrote:
> On Thu, 10 Sep 2026 20:18:22 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > 
> > Functional observation:
> >   A 20 GB hash table VMA that previously remained entirely on CXL was
> >   split evenly between DRAM and CXL after the changes - and tier
> >   residency tracked hotness.  This was previously affected by the
> >   stavation issue caused by the "unaccessed VMA" filter.
> 
> This seems very significant?
> 
> Why cc:stable and Fixes:?  Is this something which ran at these sorts
> of speeds before the offending commits?
> 

It's actually that the changes functionally broke numa balancing to the
point that it just became completely ineffective for very common use
cases.

We only didn't notice because another bug:
https://lore.kernel.org/all/20260629163337.1264881-1-hannes@cmpxchg.org/

hid almost all these issues from being apparent on large workloads
(which was differently horrendous - that bug made ~70-90% of some
 database workload memory ineligible for tiering)

Once the shmem fix went in, all the starvation and filtering issues
become more apparent when the bandwidth numbers stopped making sense
(see above).

Basically numa balancing has been broken since 2022/2023, and anyone
who has done any testing with it since then has been working off of
bad data (incomplete VMA coverage).

~Gregory

