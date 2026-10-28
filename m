Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72103606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 12:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JILlLiKn
Received: by kanga.kvack.org (Postfix)
	id 89E8C6B05B1; Wed, 28 Oct 2026 08:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875D26B05B7; Wed, 28 Oct 2026 08:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2B76B05B8; Wed, 28 Oct 2026 08:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCD86B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:22:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D568AC0C3B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:22:29 +0000 (UTC)
X-FDA: 85371948018.18.18E1ADD
Received: from out199-16.us.a.mail.aliyun.com (out199-16.us.a.mail.aliyun.com [47.90.199.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id 435A640009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:22:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JILlLiKn;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 47.90.199.16 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793190148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8G8RmtjEXPIN0vCT7dpFz9ADq2mZ2AcFkZ2Qb2//wo=;
	b=8J2TzA6w7jfR3aju/Tofb6TAAdU+FtCJaYfpoefKXNZCYcbg5i2VF4U/TBi/JMR+kEv6Hz
	3grkc71itGAtxePQNZRjN333T5NuDmgQ7vl6StE3y1zzPMuBsD14uUxcLKyhmFEhluHRjI
	Kz1GEHKx18h/X0bkrNP+3bILtLThjq4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JILlLiKn;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 47.90.199.16 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793190148;
	b=dlN0jpqpu8e6AWURyGxXPGcR3XnwwdtwS5jfNkMpjq+luRUQjadFoHHcPYerRfm6h7ef/t
	nm1A/LpX8uMu6N/18RhmfvmwIcmFWlq/rFktUIodLQpsp8pfNtkPmZ8tPh6iGLtB+WMGaA
	xVobXBDY4qLXpfNo+H46q7tSV2mXikM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793190133; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=W8G8RmtjEXPIN0vCT7dpFz9ADq2mZ2AcFkZ2Qb2//wo=;
	b=JILlLiKnPOXsXnsiot4czkjiyExG+P0ZfOYu9WAFqfnXdRz4Pq4IYVQD1H4oGhLYsQWsorBIA05ygHUzJo5UMtDSK9+DexURITlSzW9NAGF4pIywhpZYyOObi9nxx5DN2t6ldkrdcfhCNzpuzHMaG0r3I7Lq/TtQr3K6dU++RXM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XDgoACg_1793190125;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDgoACg_1793190125 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 20:22:12 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	"Kaitao Cheng" <kaitao.cheng@linux.dev>,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: Re: [PATCH v2 0/2] mm: don't migrate folios containing hwpoisoned pages
Date: Wed, 28 Oct 2026 20:22:05 +0800
Message-ID: <20261028122205.3914169-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <c8468755-4f75-4502-8d41-5cb9245a356a@kernel.org>
References: <20261026025552.1427901-1-xiangzao@linux.alibaba.com> <18602383-2326-4e54-8dec-bb695ae8878e@kernel.org> <20261027120854.1213156-1-xiangzao@linux.alibaba.com> <c8468755-4f75-4502-8d41-5cb9245a356a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 435A640009
X-Rspam-User: 
X-Stat-Signature: u1g1nzyr4y8isnrgxgnfb8osnxnki9on
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793190145-260543
X-HE-Meta: U2FsdGVkX198hN1uPjI0FZqsIi3m3Fp9OCp/vQ9LELEAtnftJB/LupHYR6/oW7zPD0Th5v2KjDsHborJn9TldPPLiGyBrVGi7MeqjVdfREjPz8s81WVQoJgyR8ZCSYM5oeTNjSkLyn1FlDHmo13QgmsNxdoNyaXZg+MVyWR9EaMT+ARPP2/F1W0YqAJAd6G27cef0AWO7W9QH640xQucsx40nk02dCXsLg6MY+Wd01HtaI/VHjRClxi3ScHSMZQ6Y3wQl0GKpPEa8eEN775Ak4ubEtIWhJq2WoEGw0UMTjIAHM7kCOA/gGb5g5nyv6M8PGjKzkW3IQpBqFfVuE6IOg5gADlZ0ZqNFgOoet2AyrI6sL6JhS77v+9KE2kbc1WLmdBiMNvcEyYyUBa89chwnDMhDB1uFqzirWa8MZd1GwajLnLAJVTW7ZNl/4Klx64tyNR1m16o39E05mSUuhgls+B9pZfz3UmHMdW/NaPvUSRefzY3Os1hq44HWxxy3HJcCz4RqKsgebUk/2NWkYDkj5Cd9PrB4//ijmGQBzIueiuD4LVOLzjaye9UkQoR50wc5oaVGiS3zS1vo/hJGA4T2+jtLVjROuvVgStOYjPcbNQjdTGJlS+C00sewCkMkkjITUYs+0vjrLEo1ibRrptArDL4vRGNbdMYLKIOpnPDbxHMkIiCcbFtFlEhvieAEaNt5bDs5r3Rvzvl24Beb5YhckKaWioz/toqf2cEh+f4P3DGzwW0c1nyGuepwoj/u7nomW09yWX0DKPmCEzoppGV+HwkGkgDrlbBe2nR6KpldUBYi8kGlgkDEe3eulLcYhO1mfDVo4eEa7riO2VT8RkCEet69UJOuxDscsyzWk61GGm4eQK1QQHuiW9cwYNc0XLFtOC6U3x4ShmQmPDwJgBn+i9CKvWfxb9rQ9bTHqV6CrUfwkPWc5xR3WfoZrokpZUyvLZkqBincaukSsJJcDR
 hmdhEvfN
 7ueDVPZJ8p8nFeITF1D2q87o1vecS1Nv4omHInh6bPX1Kxq+C9RXxBNvzK9Jpqu0h/0qzJNLtR4jsHqP67AJEomwPPlgLcQNo8krFIlqaM+SNROMlZ7oXos8Av83cpFft2X9xCyOnS9QAc4EwV1KrFHlf3YZ6/t8yVSk6kEYVerqTZv0UOk3dvvfrNWqkEbuXZoZW6YU8Tu7ooRuYMi79d5l+WwgoZ84n4d2LAw5zOcFu24tkvfk4/O/5sjZjwnLfzE5BlLPuMTgEKh/sR3pV+zw9RSVrdH1aiK4+zZTF95LbjDGi5fuK+1pAzMDFAZ4UXtLBh0rW2KJRaXTyBzKuXdmdEGyiUwJ6Y8IgebxGpv03fe1CVcIQsqrPWAVbW+vepKumQ1f41IsDL/2UuWoJqiy5p2L2XEiz3UpTg+YgI8ihqHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 09:02, David Hildenbrand wrote:
> Why is that a problem?
>
> Why do you care?

The flagged state is not debug-only.  A real error on an isolated
folio leaves PG_hwpoison set.  The data is still readable.  A THP
that cannot split is left on the LRU flagged, by design.  A copy
then propagates the poison silently: no marker, no hwpoison PTE,
no SIGBUS.

Thinking about it again, the copy layer is indeed the better
place.  So how about this: drop patch 2, and put the flag check in
the copy implementations instead.  The fallback patch already checks
is_page_hwpoison() before and after the copy on the !copy_mc archs.
The same checks in the copy_mc implementations would cover x86_64
and PPC64.  folio_mc_copy() then propagates the refusal to the
migration core.  Patch 1, the compaction skip, stands alone.  Does
that work for you?

-- 
Yuanhe

