Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FDF8606A32E
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 07:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pKp+qtJ/
Received: by kanga.kvack.org (Postfix)
	id 451EC6B05B3; Sun,  1 Nov 2026 02:14:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC596B05B4; Sun,  1 Nov 2026 02:14:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CCF96B05B6; Sun,  1 Nov 2026 02:14:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9B06B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AA90A0933
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:14:35 +0000 (UTC)
X-FDA: 85385687310.22.11DD534
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id 64AF640002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:14:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pKp+qtJ/";
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793517273;
	b=q0yMcL7DbMRCcJlOimcNVPqApnDRqCi6ZXk23Ki+owauSGsfsqDm6NcYJrPKF9tPDY2bzK
	6nplD/MHhR1aRHq45dnz4BVd5MwkMoxXkUK9m7nTrYqCexsF27X9VPfU2VzDghq4czFrOY
	xUWt2GomQ3Uq1Gm+CmZ0/lFX9Gfp4xA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793517273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMKZpg15BN7ibax6GuM/EqpnZ+65bEpp5yD8qzjlvfQ=;
	b=uUleEDU+kjtT3gLUf1frx/WoHkAUmfqzKLt2iI9D+WDUs+uYu0B0G3W7gQ+JEWOHfRGmei
	g0rm21cT5GckyECScaDP7qtUtlCcH00n8Hkp1ScyqoQAp2so7qXHyTqHrb/yxXYK/t1laH
	7u7rO3K1NE1tyIXV22WdLCchEdeEfFk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pKp+qtJ/";
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f+gZnwn4jlugsItkgzJzya2zQVZHOUrl/EtEyxGLANI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793517272; v=1; x=1794122072;
 b=pKp+qtJ/xVn4uGzq4OPTyxXWgbIH6IJ5x4NWorZ29EN+NPsRGO7X8Kr49VEYb6EJZHl89CjL
 jtpuxYMMrEz30tkqMRCUzTR6YmmsJBXeodhtKNUyByfyw82UABHWY1Oz+GLFdGYyfL5NMveF1CW
 BnYCuOOwwmxD+5ZzFDuVOWJA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f110c669da18e7dc;
	Sun, 01 Nov 2026 07:14:31 +0000
X-Mizu-Trace-ID: f110c669da18e7dc
X-Migadu-Flow: FLOW_OUT
Message-ID: <2aebd191-5c20-4865-8f2b-8db326ef6ddc@linux.dev>
Date: Sun, 1 Nov 2026 15:14:26 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/12] mm: hugetlb_vmemmap: make vmemmap restoration
 folio-oriented
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-9-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-9-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: spk8zixkqqt7mq5gk3b7ck9s13476rgq
X-Rspamd-Queue-Id: 64AF640002
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793517273-335146
X-HE-Meta: U2FsdGVkX1983gUG1i3akmcIyXSYsVaL75eqXmmVqgOPBmHjFnKnfbkdws24wHvWDzQ3qkCp1Yp6IfDtNMd77QsrxkB4mnQF411yxccRFZD2RXIzt6L2HxkCZ8ez+ZpHKqPkHPS89xVKDwn1U5sB/DDaxTjBUfNilq/ZHJ0TT7HAOSEs491nmYqosR3T0nMQtftWkF7+MzrZtXZKs2DJ+W+1qfbZmYMajMno76OLLYTXYGhj+TVN1XEdi5JePopJw51Mf1ASGm8xzwdu2feHjiILyj4LxKcex2kcRTdjMCmmnej78LHyAtLPprqSy1fWlMBITjWxXr903RyVxJLc1VHF/y+PBMTKmCV4kiXQp/dgv1LRepZRddu4Kvey8ken0vUZOjo4a6BJWHjk92BSDg7o7acE02GLAodKlP0qI/4QHTO6tnkVBY2XJEPM358aa3vTCyXKGASOS7vNnmwae2GP239Zv2u5JBe/Ccr2ChssGmqiQDjNsxmDAAV1XVHO4tncsn2yUHoPz0nhnXRTU+0miGJXjCLIyGMtq0D7xCChRS/Vt9a1nPiOTqPxiEMTxpvpGoqte89N1zmZAqkWdhtWh5hzn+Hjg7E+SHlWjRyt8F9cL+GBNtl069vzvXLRKHxWnGmqMg0YZKetKYj+RJggOVKyKuBx71p5mLliaBz6mSx1iwRQsD3vVysvy7jklPncoKMBPgoRSYeirTyU44DgP1L52v7MHmO8LKSJzMuB+0bCb3Jdgr29ULsgmxT5Ce439EShvEBFPUFx8YUccPg5ivaVOfR1mFB2UYMOPq0YYkL7mXGg8knvld8NBylLRgC4uXPybff28YK3e8lwzzo0SA5FzCW8erZxQTwwLndrQqS7irKc1oFkpZVGdGb2iVPoBFH43MW4M/5N/OX7wzKnQ7NCIbKYP6bsUfSm+xsAKm12+QkO1iEze+pMjVGnhXP9FuEsvApFJNw4kUT
 R+nJsH1l
 yHOh6CmWJujChzrVY5iPgnx37e2VmJZ42ipJWpPDQMReH3e+NxMnFAtTXABD4BbwHgn7/IVwH1Fvysxypl84PIUEtV2i3KBQ2TUgc0J03vArLEJluQcffIGLov2mV1Uf2n49GwWFvvwvMJDUiCR7/Hw35MZ7n3FzNHuAtJ77H0Bvtyj9G2VDma/Jdu36vUCODeyZXhFsukTnGrO2EM3FDjR6gRlQFZOsulWfvVTQ7itZDmklaOH026JisE/6BLnRZH7SfioeILiBRcVTYNRMalaoosW6lQA6Yq3WfKhpFLHdk93wl+MRH+4QEOQaNdZgdbJGohlnhN+btbjh7vZ9nEngMmX6MEWv9dkNKB38nAtuC/IlKauxK2UKNWn04TKgbl7NAPFa7Sc4THRT2HYFytDY+MQiYRyn1zO1Wz3bX3uBdn/qHNzeGDkotAhAjPYNmaaxJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> Like optimization, vmemmap restoration operates on one folio at a time,
> but the current interface exposes a raw address range and requires the
> HugeTLB caller to prepare part of the operation.  This splits the common
> mechanism across layers and obscures its natural unit of work.
> 
> Make the folio the unit of vmemmap restoration and move the common
> mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
> eligibility and state in the caller and gives both directions of HVO
> consistent folio-level interfaces.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb_vmemmap.c | 37 +++++++++++++------------------------
>   1 file changed, 13 insertions(+), 24 deletions(-)

Nice cleanup.

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


