Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD2DC98328
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 09:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8F56B0088; Fri, 25 Sep 2026 05:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2732E6B008A; Fri, 25 Sep 2026 05:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13CA06B008C; Fri, 25 Sep 2026 05:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E89B96B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:51:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 572671205E2
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:51:30 +0000 (UTC)
X-FDA: 85251817140.26.EADF42A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A057640002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:51:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MII10lLe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790329888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+D5INLgXRmSCP8dX1DI2YP9WCAPf2XRP1YftFg3Z8w=;
	b=BOFNAMBZzLSmamBn/bqlEmjuSliCPV1SV4GLUg+ZuyQeOu1X6xGElOy0x073/aS8SS0+AJ
	EOVi7sLQvQJ/6Ru+x07wlIfQL4hznnRozaEJnUmurC0oI3hB8+slw1uRzEG1UP6Jm3JvLa
	CWY5OdGGcMI8CJyY6Cv8pkshsiLDOOc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MII10lLe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790329888;
	b=1dlMZ+u5Sagt0djo5qofy4YJ7qE8Qyw+0gNi1SMFXe2oDUFZjWogklAPHWREDSu1I+NWP3
	dtNllOl26MSVE3qYzLa8dZqnHtSKyg2kBiPysAyk0RSZ61ITP7bNPYF7Q+6tWPfq3NYvv4
	08Vdam8cwOtF70Kr7nV/IP5n4K+rUmw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95E4A42D94;
	Fri, 25 Sep 2026 09:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4231F000FF;
	Fri, 25 Sep 2026 09:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790329887;
	bh=K+D5INLgXRmSCP8dX1DI2YP9WCAPf2XRP1YftFg3Z8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MII10lLeWnl76mMmwR6zRYIBDQPFBBLpplp/A1G72hA8hNqWE/KFpBvE8lGBHSGxv
	 p9xWx5JxHALI59tElqwE3PrmzeOAa8ZHbK4hPsP3Du0TnHtQPUwpIro2YQSPqzgBJZ
	 7PvFyIpf3XbqI/j+XMABy2Fi1IgkNGPDfbDN5dYMVe0k8LpcCzyBwfdSyK7U6RlH/9
	 Om4KSie2kQZ9qi6kqA85+W/Yyy+a+8dZYBsv/J0k3ZNZXPS6BhmzbC6uZCFRaMNlQn
	 CkBzQjZjD4OYsjB4VDOsDtyJ2ln6dA5wzbsCBCrlVqWHY8r2CShJqIUl8EviQxpJfq
	 mHmvIzwF2GKGA==
From: SJ Park <sj@kernel.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: SJ Park <sj@kernel.org>,
	Bharata B Rao <bharata@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	jic23@kernel.org,
	dave.hansen@intel.com,
	gourry@gourry.net,
	mgorman@techsingularity.net,
	mingo@redhat.com,
	peterz@infradead.org,
	raghavendra.kt@amd.com,
	riel@surriel.com,
	rientjes@google.com,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	nifan.cxl@gmail.com,
	xuezhengchu@huawei.com,
	yiannis@zptcorp.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	byungchul@sk.com,
	kinseyho@google.com,
	joshua.hahnjy@gmail.com,
	yuanchu@google.com,
	balbirs@nvidia.com,
	alok.rathore@samsung.com,
	shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Date: Fri, 25 Sep 2026 02:50:38 -0700
Message-ID: <20260925095039.48831-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260925021226.52kpnmvfylw73dz4@offworld>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yzex6twama8qwizdy5rsu1kdneewf51q
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A057640002
X-HE-Tag: 1790329888-461774
X-HE-Meta: U2FsdGVkX18gHpsZvyRB2VgYExl7KR196bSaYakQgbE3vR+HCWoGNoPtv4OlasAzzgsoWwH3YQ/PazZ6Sgg+RFqVNujNnijiGSTGrxhj4XqEq7fpdaSC2sKyPZ1knK1UP8CKxkkCzSogF8cwkchkqFUKhYM9hMIkd554zLLkLLnxvA4+iiXbHd4CcZHCPQaeLPxl/WoBWh1qJZjsKlNgDTrMqA9yZ3nViGHI6B5lfArnO4mDMAthvBX7dbEZNji6SKWWlX+l0+ibvKK60ZDD7xKqw3oYSWQib+qLEAU/kLeEjCeWeWaNOqJD3pz9TlDzZ5O8f6V2hHrYBqW6VSLqVffIKeUQFUPwZ2VeAXATzlEjQ14gdKzl/G3+FMHbAmhlVR/YYBw7sm12uIJBYeWuTLVZ/jR7H3AOpSbFoVrYsSYsYgILOiObP/GHlM/mb6U57Yg8dC65kSajgn2Chz7HHnTsQvPuDiuXX1FQjd1xVVpW4Cm6gtA8yJIAfvOKoPsXikMAXUqmzSUrjG7TENiOToy1jElY1o9gnei1GezT9HF4VMlvaabL5SA2+BhBF/CiJynu4LYbCD/6RMkzizykXuQIHl57+7tPsSH6SrOf0f3b/GTkCEVSoDdpdHwGyOjZgbqy4mi3HDLbHwcrWt1YPxQKjq8eJBUgYSRJ35hIR2Htg6z08mdqIl8u5Eu7050KTvGw9KEehL3Ig+tGACROYaDaz4atyt4gsh7kl5oQ+2pOIfoITp58j+lJ5YtaQ86L3xc65fN84lbfQFc6EMnpmWgRKBEpexr4eU1G5fXP0c2nYaiIIb1JnT39Kcn5nnVJHMFDK03hr/4KDgwWOv9QbVFz2MopvIFOW9GRCy+SY54yWaNNQBVetJnFfyckwGgvxBmVmfxdiHRHBPuWydH5YmOdREubFQD4LxsrYF5BkSrsjG3qRLBeYDiyIpZOYI65bdIzBPXXsSVQmPZ0Kct
 AZSihS2w
 qmBv/K86tGulDikJi1CVEffxIBxV5Z/w6JVv9R4ZYMuNQHCR8uC2hiow2RTzunehihBNsrLKSWyk/W8Qrtgiq//kPNmCa699iFaCZtE19JjBywO9QfulE3m5KE0qYR5P3CEqW5YsAudw7vIC8+rPBfhxL5hXLk3Da4X8G9IpmZJfWvPTrvsanIATsnmZt8zRiCTmZpKPIZdDjijVRumm3kUvbfqG09oKgAbJlLo+Qhw1lw5HgBqPSbvpF7PKt9VxPlw5EObakYYyMC8AjIwQ9TnfB1z0553sbw4V2sS0Ombryxh87ZdJcCtPWoX+lol0bhLCQNQgI12rLkktNM4CARrPgUATL02l/tVrMFPRdYUxETqVuIyKAgkRkTZVAkD0bJgilRUBFTwVpGHqbGmiDy/VfOcLCspJRiHod0hIEy6CeOiUp+Fy/dOATXCNfrf9iq3EHDbH0ltmf0i8fx+GlJBJ09g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Davidlohr,

On Thu, 24 Sep 2026 19:12:26 -0700 Davidlohr Bueso <dave@stgolabs.net> wrote:
[...]
> So perhaps any mm interface for this stuff should just not be designed
> around sampling, and instead proper hardware sources?

Makes sense to me.  I proposed [1] damos_add_folios() in LSFMMBPF'25 for a
reason that is similar to your points in my humble view.  To quote from the
slide [2],

    +/**
    + * damos_add_folios - Add a list of folios as highest priority target for given
    + *                    damos.
    + * @scheme:    DAMOS scheme for the specific access-aware operation.
    + * @folios:    List of folios to apply the access-aware operation.
    + *
    + * If a kernel component finds folios that eligible for a specific memory
    + * management operation (e.g., CXL-promotion or demotion), execution of the
    + * operation can be requested to be done by DAMOS using this function.  The
    + * execution of the operation will be asynchronously done by DAMOS worker
    + * thread.  DAMOS features for resource control (DAMOS quotas) will also be
    + * applied.
    + */
    +void damos_add_folios(struct damos *scheme, struct list_head *folios)

> A lot of the complexity in pghot can be removed without this imo (per-pfn
> metadata, accumulate+decay phase). Of course we still have the problem
> to evaluate the cost of replacing a chunk from the top tier(s) with the
> what the low tier is reporting has "hot". And this is particularly true
> with chmu with limited full system memory visibility (as opposed to IBS,
> for example). I don't really have a good answer for this, other than the
> user could use proactive reclaim along with the per-device tunables
> (ie unit sizes and thresholds for chmu) to configure things realistically
> for their use cases - prob. easier said than done.

As the above quote says, the API caller can still use DAMOS features for fine
controls such as quotas, filtrers and quota auto-tuning.  We could add more
optimized features for the API callers.  My rough idea was that such
operation-focused features could help serving this kind of additional
requirements.

We didn' find a real request for damos_add_folios() so far, though.  And hence
no progress has made for that since LSFMMBPF'25, and I have no plan to work on
it for now.

[1] https://lwn.net/Articles/1016525/
[2] https://github.com/damonitor/talks/blob/master/2025/lsfmmbpf/damon_requirements_lsfmmbpf_2025.pdf


Thanks,
SJ

[...]

