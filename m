Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D4EFB5E90
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 00:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FCF6B03C7; Mon, 16 Mar 2026 20:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2396B03C8; Mon, 16 Mar 2026 20:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7C56B03C9; Mon, 16 Mar 2026 20:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44F076B03C7
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:32:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A44011403D7
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:32:17 +0000 (UTC)
X-FDA: 84553678314.12.7919FF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 38BAEC0010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:32:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WzhKXsyn;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773707536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXKxuj/Ma/nsFbb++vm1857Nj6vB3v9h+rGrq4cwWZg=;
	b=JxAs1y19bSDrq+A5qJUvZEGyL6FO54v4HOAlZubo1gyemRCc902S22Ub/Aa4RWTBNWNg6v
	DJqaFJM/qlEDFQCjBE4r4GfLxHnUWjfUjeXCx1/yY2A2I17dCL8fQSSkI+huSim5ByS80h
	iy+RDhbbpG9ALhGqpVyrN7lnLLZAO+E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WzhKXsyn;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773707536; a=rsa-sha256;
	cv=none;
	b=kg4bTCkICPMkUl3fuk6xfksZOquN03tZ/24qyrzfnkjAtdhCFEtZB1Ccz8TNrHWcXPA6+1
	3Xa8ZzkI0qq4+IPFjspYQz1PlIsZmE615untrli+ZnH/OLIq5UsoJCCMIMBiNnfS3rd2f9
	PMmDwh7kR02Ha3uqV/KvrwVLyR1fP+s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 713A060103;
	Tue, 17 Mar 2026 00:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CFAC19421;
	Tue, 17 Mar 2026 00:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773707535;
	bh=SxztNyjsBWFQa6rSjGITiRSfE6ka6QEjlqxvt3CSyEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzhKXsyn1mncyjXxEA3xKr3mJtet7x5eO/3Q1n1ufQQ5KMSCpzjlIe++T4iQ9+lN0
	 lT2c8CUJq/5Ip4nkn64NRQBoCRe6CNs9+4epjtSt+VCtOQYPEQ03XmlvQY9rVIhpjU
	 5+FDmvPkcQWbLijhEfOx6JmmAxx84SWlML1MzNNnTKaXaIsCkqwHyKHxrupQ4Dkl/r
	 jYS2GrVsAsS8W8Mu7CLG1M8YP4VqRhNaHiuupLC9hSHsAv44m4UbZ+gO1RnJZRAv6p
	 nzyqRKBqpgWuf1gZKWlvYPoOEA01VJ1+XGsjqAhK3vnBWrVBukfE0b5g3cSp0+mQ5d
	 xcENaeB0rhncQ==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Mon, 16 Mar 2026 17:32:05 -0700
Message-ID: <20260317003206.89342-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316183805.2090297-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 38BAEC0010
X-Rspamd-Server: rspam08
X-Stat-Signature: zh5kyyy5wpfxx1qcaw74ubgp6apkfi8h
X-HE-Tag: 1773707536-886605
X-HE-Meta: U2FsdGVkX19mRBF5PMxeOg8V8HpE4fQ6Irn9cD2Y72iIYavRc8NWktnVC+4bbCOFnSeT5YyBK+FQXVmT5ybAW7Dfy4EQo9moqx6pO78u6HPy9llB4TL5JGOKxLULoyFIGM5pNKWeyJcQyzIt5z7sfKmwtn/BUr5gs/DlysPJJj5Kz0VXBN0qK+1qZCAgpNM70C9yGCV7T3Ddpbdov7lHHRH+Zomxz2teRDLnVH/N8MfhFQo3MErb+4suntfKSEm+gTJp+lI59gBK9R5iqc1DeIzb9qG5x1vQLEel1IskXGwafZgYLbPJGWqFRlc/bTl5vOScORKQSxyurbWrY1uutTSa7awy2f5vg79nA84sD4SSC/hYrFuDCHtDqPo0W1akChHvU3+PUZ1v50LV0NsMpGn5OAvYzdknzcmgX9sGE8Q83KyfX/qZN1vAXCPwIEmhPWORkydT7Gjy8Jy7tZLueg4hKbBySvg2e7IMORJWH2W0L7u6frLS+8e9MQOSOpitfPH5Ty1SpLZcDVtpNe4/7tKkzCHV7rnb01GDwKrU6yW3DFghslHtiGdJQayYoHxo5U5f8RGk/C16LwgAyKJ9zn0TkVBOZISx0Y8StF3kByqwWcEaVEkyo2GdlMLnJ014RqYBVt6Sg9TpOIq6yx7O/J5x+MwbqDMOHAbQFkb9jeBsLtDSIsypiJhuV5YFa+lQxqusjvy6xsiFMF14p1o+QxdkAnAKYpr+mZXSpgZin6wdqxhdUw1Lyc0xsF1wrTyJniP3nMF++rmujcJeSd9PnWYJFT06TbLS8WIDrniwBmSK6atWVjc9R6nNAKYzKPfi3GJl6P1fm8aJ9jf6fWgTwEuDUH924Ui/hki3Ut+Tg/lQhh5xip47S7UtZTUMAMfnYRekB7DZe30MvOoUfIRH08u97rKCpd1Mka2QRoSQBQ7Xh+1KDxvQQFUTZ3YpPSgYQmUBfko9gAOGQTH9odd
 2DKErek6
 XhOTF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,

On Mon, 16 Mar 2026 18:38:05 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch set introces a new action: DAMOS_COLLAPSE.
> 
> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
> working, since it relies on hugepage_madvise to add a new slot. This
> slot should be picked up by khugepaged and eventually collapse (or
> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
> enabled, khugepaged will not be working, and therefore no collapse
> will happen.
> 
> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
> the address range synchronously.
> 
> This new action may be required to support autotuning with hugepage as
> a goal.

Above all makes sense.  Thank you for posting this patch.

Do you have some test results that you can also share together?  It would be
nice if it can demonstrate the benefit of DAMOS_COLLAPSE over DAMOS_HUGEPAGE.

> 
> [1] https://lore.kernel.org/lkml/20260314165156.86647-1-sj@kernel.org/

Seems the above link is just added by a mistake?  If not, please clarify.

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> ---
>  Documentation/mm/damon/design.rst | 4 ++++
>  include/linux/damon.h             | 1 +
>  mm/damon/sysfs-schemes.c          | 4 ++++
>  mm/damon/vaddr.c                  | 3 +++
>  4 files changed, 12 insertions(+)
[...]
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 3a441fbca170..6720dc70c487 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -140,6 +140,7 @@ enum damos_action {
>  	DAMOS_PAGEOUT,
>  	DAMOS_HUGEPAGE,
>  	DAMOS_NOHUGEPAGE,
> +	DAMOS_COLLAPSE,
>  	DAMOS_LRU_PRIO,
>  	DAMOS_LRU_DEPRIO,
>  	DAMOS_MIGRATE_HOT,

sashiko.dev adds [1] below comments.  Let me also add my comments in line.

: This isn't a bug, but should a kernel-doc entry for @DAMOS_COLLAPSE be added
: to the comment block above this enum?

Makes sense.  'make htmldocs' may complain otherwise.  Asier, could you please
add the kernel-doc comment for DAMOS_COLLAPSE in the next spin?

: 
: Also, does inserting DAMOS_COLLAPSE here shift the integer values of the
: subsequent enum entries like DAMOS_STAT?
: 
: The DAMON sysfs selftest script (tools/testing/selftests/damon/sysfs.py) uses
: a hardcoded dictionary action_val to map string names to their integer enum
: values.
: 
: If the enum values shift, the test's assertion:
: 
: assert_true(dump['action'] == action_val[scheme.action])
: 
: might fail when checking the struct memory via drgn. Could the python test
: dictionary be updated to reflect the new values, or could the new action be
: added at the end of the enum list?

There is no test that uses DAMOS actions that defined after DAMOS_NOHUGEPAGE,
so no real test will break.  But this is a good point.  It would be better to
update the hard-coded value together.  Asier, could you also update the
'action_val' dict of assert_scheme_committed() function in
tools/testing/selftets/damon/sysfs.py for the updated enum value in the next
version?

[1] https://sashiko.dev/#/patchset/20260316183805.2090297-1-gutierrez.asier@huawei-partners.com


Thanks,
SJ

[...]

