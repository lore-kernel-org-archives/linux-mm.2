Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55FC7C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409BD6B009B; Mon, 20 Jul 2026 05:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA4C6B009D; Mon, 20 Jul 2026 05:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8296B009E; Mon, 20 Jul 2026 05:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2966B009B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:28:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88B97C0783
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:28:53 +0000 (UTC)
X-FDA: 85008630546.08.10F4080
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1BCA91C0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:28:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=lhrVe85S;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539731;
	b=fzPReCHySli4aKrmU8W8guAzY1lmhx4qpl0PbLamuwvtHCusUlYUkUDDrcCUaC23Lb6cGt
	pyDY5xVt/Pym65iqvo/leGYtFgshYqOqIpRlT/y6WmGF8h3fLyWmNCMPuuXB3W/KoEvNpW
	jYdJEW9hOYyFvD+poB4HyOW4CYBxmOw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=lhrVe85S;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUHwliFvt2Gn1hvyINNY2v9lEgIqckSiVz0mxRwlukg=;
	b=JTOWGj/7z+YGdQn5ag/fMuwOGLN5dbWIuqlH3D0yvC+TBvch3ypEPIDWrzgto8XEq1owcO
	DGEQsfk99oD1D9pZgyj2sWf6lv6Vdgb6dWhak/Ojo4/6jLKlObCQg+wJpLRG05EkUNyats
	METD73DyjZGrzkPF1zyX1jjUo9WT0eQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XUHwliFvt2Gn1hvyINNY2v9lEgIqckSiVz0mxRwlukg=;
	b=lhrVe85So4F1nplZW+dS/HTMHu+U35OXYXBpcPmRehHDm2a6Xzp3Cfh7CM2JvmaKbds49NOZW
	vxw/Tk4YSp+PzrC17MFdk3bHk2bwiptUEupYUTPHhWhmhWMptG7I5GrhnWqhju5sCKWuvc2O8gu
	Qg0b4pF8stRNZ0xNioPPvyU=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h3Zv71bMmzHnH55;
	Mon, 20 Jul 2026 17:28:19 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 2AF654058D;
	Mon, 20 Jul 2026 17:28:41 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Jul 2026 12:28:40 +0300
Message-ID: <a168a9f2-953b-4ecb-98ee-ec6b27f4d963@huawei-partners.com>
Date: Mon, 20 Jul 2026 12:28:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/3] mm/damon: introduce DAMOS_SPLIT action
To: Lian Wang <lianux.mm@gmail.com>, <damon@lists.linux.dev>,
	<linux-mm@kvack.org>
CC: <sj@kernel.org>, <akpm@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <npache@redhat.com>,
	<ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>, <ryan.roberts@arm.com>,
	<daichaobing@sangfor.com.cn>, <wangkefeng.wang@huawei.com>,
	<zengheng4@huawei.com>, <kasong@tencent.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <lianux.wang@processmission.com>,
	<kunwu.chan@linux.dev>
References: <20260720030327.80153-1-lianux.mm@gmail.com>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260720030327.80153-1-lianux.mm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1BCA91C0003
X-Stat-Signature: fkjyt44rm93y6oefwwoyot8scfywajz7
X-HE-Tag: 1784539729-143062
X-HE-Meta: U2FsdGVkX19yicAhs8FI7DJvKx1mUt9iePDeIqF+Y+qqW2mv9m/KvML+u1IFqNutNqg2lXdP8nMzav/AahF0/T62YvCB/OjFHjCCncK+Sr6vpjJ20OeMmPAd2UkcBkZFi3VRxwyoS6AdNoot9d8VryAAZvbXPivzddEmaq2HgIH3cvDQZ2/ynl+kK3p9jkzxustYkbpgnQQPmEyKtsQ+hY38Mun2vF2J2N7D3fWwlLKGLC51w9V86wAUmcOuY5lb6C+J+QPk1qVDMOi+G7CUO4nblH85eXSyLTwAq31hDAY/c9MG6p1pM0PDMrOd+81FxijlUwE0GNKcKjojvZY8x2GG8YsYp19DlQiUZLBzNxiLSey3n6gqvzim9CD1Dcg4SGwayVroSodRE6URMJRuFXojDWXCAOjJqHmekzmUoaAP5DfXb6xSbO07Bh2VWOUI7bMF9sSg/E7taPeyDP7CS7p+tYTvmq6kcRaJy3QOEtOxhviclRzXVFBHhCFU8Z1gmeQPcF3McvCmnVlgJbr7gJ64dNkD2y57CZHprboeS8GNJ5CXPnR/uRfe+hqOjm1mQT6kD+DGfVlBjDcZf0QfSjJAmmtOAVCd+5/zScWT6g9jk7BDugwPLM6NNQFvUnFNgjM5Mv4TZqGM42XB4zO1vmxyU/Y6fJz9s/+H0RTXvfcsWvH1s1Nr65sFYBxQX+7Qbh6dZFDQ+3e40CFcc+8P8RzJ3gYu4gK2D2QqRW8f1vldEfl/PWkOBJFZyoCZw4g9p3EtNwJUlQAAieu5t6KCeIVJlRFo352muU4QC/PfXiGLqM0kLX8HlNvs/6gNWQ5xeA8J6gdeQsVMK7e/Vci4EucJURqyIl+fCg9oIaCl7tfnCU76w8a4LmUr6WiyGAIgcGbXBor9P58TaHNiMtBSQ6TrUS4gpJJKLSDMwPSajg5ux3C4iR7+qRs2I3c+YPlbIwxgzGsDBhn9H4yiRr5
 ARLP4ZuB
 24/PNbFZTiFLSgEyynHlXFqNd9gTev7SBh/SHKbUUDDY4ouw+SB5dihXy5Fs7ImzJt66VuUMwNRyPY4ptvGDBRBfQky6F190ZGXSLsE52kzHeHYazEP6px5V5Ox/5Q+UTdus2UeEnc4BRKfxSmR8WiM0a+GNgDHAOgjkUXkddyUe9jpkPnzfEiDNhMGM/5Jp96Lf/L79TQp7SNM/iFOLLfUMXAxSt/IYWtHwWfuz/ChJps9RMoYGyg341/tTh3bd7SvMjiMmJZeP9CYWPBymVrZZMc8B9MdJ5lDpCvc3+dBCpwtzxV+gD0dXSYO5+U6ely1isTB9R6JtHSprPhj9qWGydWfdPCGjutsLZDaIJtYU6OZICie4/dVezFOdHD6tjMisVi8rVO50SUAXfMqMChxg47fmbZPCuCJo093XwYbT/COkKiyK2yi1tWCkI6ez9DUeXdldtObxJkSMOvc3FOKALBQdNHgauSZhIBOV0HNa4xHE3yV1VFO52Dp+kSQ5YBWkQgBOx+IZ8clHBSuKQfR3odkEh7GdCxVA9FDrFnZg0MXLfWq2CQLhLuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lian,

On 7/20/2026 6:03 AM, Lian Wang wrote:
> DAMOS_SPLIT splits large folios in a target region down to a
> configured target order, using the existing split_folio_to_order().
> No new core-mm code or exported symbols are introduced.
> 
> Based on mm-unstable at 61cccb8363fc ("mm/swap, PM: hibernate:
> atomically replace hibernation pin").
> 
> Different addresses within a PMD-mapped folio resolve to the same
> PMD Accessed bit.  Accesses to a small part of the folio can
> therefore coarsen DAMON's observed hot set relative to the actual
> working set.
> 
> DAMOS already provides promotion actions (HUGEPAGE, COLLAPSE) but
> has no corresponding demotion action.  DAMOS_SPLIT fills this gap.
> It is a mechanism, not a policy -- it does not decide which folios
> to split.  Selection is left to DAMON's existing access patterns,
> filters, and future probe/PMU signals.
You should mention why page split is be needed. The fact that page
collapsing exist doesn't necessarily mean that split should exist.

I agree that it is a nice feature, but it should be backed in the
cover letter.
> target_order selects the split target: 0 for order-0 base pages,
> or a supported smaller mTHP order.  Both anonymous and file-backed
> folios are supported.  The locking follows split_huge_pages_in_pid()
> in mm/huge_memory.c.
> 
> Tests
> =====
> 
> damos_split.py (VM + Kunpeng 920):
>   anon THP -> order-0 split: PASS
> 
> sangfor_exp.py (Kunpeng 920, tmpfs, 4096 MiB):
> 
>   - Created a 4 GiB PMD-mapped tmpfs workload.
>   - Applied DAMOS_SPLIT with target_order=0.
>   - ShmemPmdMapped dropped from 4194304 KiB to 0 in every round.
>   - Repeated for five rounds without functional failures.
> 
> The functional selftest (damos_split.py) is included in this series.
> Additional experiment scripts and raw results are available on
> request.  Performance characterization using masim [1] and KMB [2]
> is in progress.
> 
> [1] https://github.com/sjp38/masim
> [2] https://gitee.com/OpenCloudOS/kernel-multi-bench
> 
> Open questions
> ==============
> 
> - Selection policy: this series keeps folio selection outside the
>   action and relies on DAMOS access patterns, filters, and quotas.
>   Is this the appropriate layering for future probe-based signals?
> 
> - Hysteresis: khugepaged may re-collapse a just-split folio.
>   Should cooldown live in DAMON policy or khugepaged?
> 
> - File-backed folios: adjust target_order upward to filesystem
>   minimum, or keep current "fail and skip"?
> 
> Beyond the action API itself, feedback on real workloads that need
> proactive large-folio demotion is particularly welcome.  Follow-up
> work will evaluate candidate selection signals, including DAMON
> probes and hardware-assisted sampling, as well as target-order
> selection and split/collapse hysteresis.  Those policies are
> intentionally kept outside this series.
> Changes since v2 [3]
> ====================
> 
> - Split-only series (collapse deferred).
> - Dropped SPE feedback (mechanism/policy separation).
> - DAMOS_MTHP_SPLIT -> DAMOS_SPLIT.
> - order field in existing union (no struct size increase).
> - Added functional selftest (damos_split.py).
> - checkpatch: 0 errors, 0 warnings.
> 
> [3] https://lore.kernel.org/20260701123000.00000-1-lianux.mm@gmail.com/
Could you add v1 as well?
> 
> Lian Wang (Processmission) (3):
>   mm/damon: introduce DAMOS_SPLIT action
>   mm/damon/vaddr: implement DAMOS_SPLIT handler
>   selftests/damon: add functional test for DAMOS_SPLIT
> 
>  .../ABI/testing/sysfs-kernel-mm-damon         |  7 ++
>  Documentation/mm/damon/design.rst             |  5 +
>  include/linux/damon.h                         | 15 ++-
>  mm/damon/core.c                               |  2 +
>  mm/damon/sysfs-schemes.c                      | 48 +++++++
>  mm/damon/vaddr.c                              | 90 +++++++++++++
>  tools/testing/selftests/damon/Makefile        |  1 +
>  tools/testing/selftests/damon/_damon_sysfs.py |  9 +-
>  tools/testing/selftests/damon/damos_split.py  | 99 +++++++++++++++
>  tools/testing/selftests/damon/sysfs.py        | 11 +-
>  10 files changed, 279 insertions(+), 8 deletions(-)
> 

-- 
Asier Gutierrez
Huawei


