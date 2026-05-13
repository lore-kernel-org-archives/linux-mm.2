Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B0FCD4F35
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC6D6B0005; Wed, 13 May 2026 06:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DDB6B008A; Wed, 13 May 2026 06:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473986B008C; Wed, 13 May 2026 06:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 364FE6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92F8F1C0701
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:10:29 +0000 (UTC)
X-FDA: 84761976978.17.22EFAB0
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9F56E80003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:10:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BzLdDQ8W;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf02.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778667027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C237zO30XqoiCTFHMRuW/KbUxX+S5OpkktaiCuxhayo=;
	b=Pdit3P21CmfADE/CySnm7Xdi6TuQIworFHNKMbgnK14PpOyvvgJW5sUOJ+oEc7n37mCZJc
	Pzu4A/C4kMR+erSS5ZxFtpjvC3c+XZsSCJdwroLaHJy6AqatuLpW4wtvUAh2UT6S95WL0p
	9n52m/E6vLcsXyKzW4uMfyLMiGlueWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778667027; a=rsa-sha256;
	cv=none;
	b=ofCaP7L9a8+y7oHN3ar03dLeIr5xzixlMaTgQwoSaascri690FfKUiYLJ0N9Dep8FtZiV5
	86nIt+vgkexgm7PIkaXhjJALP8b1cgNh5m21fP+b7NLVpAslL1ebMg3UG0QNH8FWzDvj0v
	O8EJYUhjD/mqiDiM4hNQk8IZ+QY10o4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BzLdDQ8W;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf02.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=C2
	37zO30XqoiCTFHMRuW/KbUxX+S5OpkktaiCuxhayo=; b=BzLdDQ8Ww36p7ZCLW1
	7cr3Jwl0lnbp8VzINsY/h4+KL8EjdQ+Je+AK+M+oFLcSZ5vm3M0Jv9LpccnNtqd+
	PfyTLQFlcmJqakTPQcO2ID4abtCV1/AfGOG7YrO1caTdmT1PrlCAZmNwPoAYfTea
	Rc2k2kZh4yxfYLRql5bgEPSuY=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3t5LkTQRqp+R4BA--.38633S2;
	Wed, 13 May 2026 18:09:40 +0800 (CST)
From: ranxiaokai627@163.com
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hughd@google.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: Re: [PATCH 1/2] mm: huge_memory: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Wed, 13 May 2026 10:09:39 +0000
Message-ID: <20260513100939.50981-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <agQ9FXDr_5ybD7AR@lucifer>
References: <agQ9FXDr_5ybD7AR@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3t5LkTQRqp+R4BA--.38633S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF48Cw1rZry3AFyfJr4UCFg_yoWDuwcEgw
	18twsrJw45Cr4kKw48CF12vr4UWrWvkFyDXa9Y9r4FyFWUJws7WanxKr1S9w4xJw4vyas8
	GFn09an09w15ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUbEfOUUUUUU==
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxgUodGoETeXAngAA3H
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F56E80003
X-Stat-Signature: 1kjqhnz1cbsup4gmbrjn84nh6miwczdq
X-Rspam-User: 
X-HE-Tag: 1778667026-188921
X-HE-Meta: U2FsdGVkX196/C2o8ZwmSzNiFCXO4NRpmKlwMDdluTd8p1VXv7PvZIIbc9VZp2ZxM8/C96joKDVlqTYju+pVTxAdxMqVyypEKBR1TbbqY9xaY3tO2j+iSPtKqzF6CJE0VAKGie3QldZI2Lb9KBwz6GbLohWLTRaIGi2CJ2k8ZrrHMbLwQkKoE72Q4Csi1Ct0pGgxxxOkAY8PMN7sxr63qEkY2nDBXi5T6CI+ZeRI9w4cb/kkmAp7h+oL6Y2oVZR8vZ6lFWv5cqtizAL1v5xRDU5Dkafwolf+i3eU4uBWMYcHiEkXqKJFIB3po28DfYaskfZkqIblAuskKbVPahS+Rux2hU6mudEHY3bqSWPIz/za0LzJRRTPUXbvz63jJMaesghaGBgYjtJM11Z4guLU1wkqg4o2z+an4o2i49P2cpSwNlY7y1OTWY3EP5Nhjxbx4cE/Pz8Ws3WI+w1sXomORp+YN8ofQCslosDqwBa0h+2JiYhIgOdhLsOEYyk0PVj0or0DJPF/+KTwu3QuHNUzhNPeT0igV6BLcFe4I8zuCFw9UprUthU2r1Ub5B4v8kZqSsB1y/MS80WbE+NGmBbSU/AJO+2loaP7pZ495zwUnC7eAImG9PRsJZF2jkmRbR8Wjg0KXSnQNkmr0flVOuTpu5F9bIe7PANNN5WS37hMNW7tLp9IStfZZNN79lPRXfxYZ7/MUhCZKYAn4mTC58D1AIND4dy8nKpftdZoXCI+3bDPm9/ht/0+ZE29FsNJUHr8QEefLVYDqFM1pWnBmNkPjobY9K/sWR1mT3nKMTVIeoeaPn9QCriORb12aIrjgLRCnVZXknHCik5nmfS4Iv8hZDopbTLdopSxB1pLH1DiN9MUNtPwmpciaT3rJwTB6srKC6Y4gPSkSSFeRBWcpjLG74lJgtJKkkcLcI32HihWDwHpTi68wXM6Cis+sSgk70ETg4rzyWOpTgDBJPe1EPf
 2ZZ6k1CU
 uJ7rcdCcDpR4aVKsVYJ2M+V4//O5q7tN2kPzoN6osdnmWwHtrrZwwi46zj9Ftutt4wWCL77Iovtp4w8+1lDne9fMT5Ilz4qgUnoVCbyy5eVYRbyvEhE/i5DItIZpV9Rq7alaWSpE2xZSddoEkOSfFDoogtnegQMX6Nz4vDcWike8OiyvGpGpaAqGJigd+doDA812pTji18WAzhWhe87/vJnPsYMiyerYI+MT5nR0Z08pB9Rz3RhwcZEPyobUM3WTq06xEkdmphgwC5w84mt3jneJofOofwFwqU2XnD56IIB2wyCNAlP48q9D52vSnrNFSTn80ePVMQGM/DbDZ9xGAYhuiFf/itsDps1N4+Rx0BgTRl9U8cxkjNuqnzKft6jihzklfsMKu6SXvwpFul1GQalSO7V44xjNACHxvpb+sxMurWKIWqUKjWsCSQEhlwew/ITg1JEA5NcwuLGKCQMsI+NB1H0k8W/XT8BjNYeP0G+KIaq/V8wwIyeae5jLk5C1FaDYiyb/3aN4fWi1X/S7Ux4RHSJTkZ0voDZTqRSI4FG0R0bV53InfZiIfYs45/EV6XAyrX3wFWzAol0qERNPDTYOJMOxRdONqASNG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +cc David also!
> 
> Unfortunately we put some hugetlb logic in mm/shmem.c too which makes
> get_maintainers.pl not do the right thing.
> 
> I wonder if we should add mm/shmem.c to the THP section _also_ just to cover
> this off?
> 
> On Wed, May 13, 2026 at 11:04:12AM +0800, Baolin Wang wrote:
> > CC Breno and Lorenzo
> 
> Ran - since you're going to need to do a respin anyway, please cc- Breno, David,
> myself and probably worth adding the THP people in general:
> 
> R:	Zi Yan <ziy@nvidia.com>
> R:	Baolin Wang <baolin.wang@linux.alibaba.com> (Baolin already cc'd of course :)
> R:	Liam R. Howlett <liam@infradead.org>
> R:	Nico Pache <npache@redhat.com>
> R:	Ryan Roberts <ryan.roberts@arm.com>
> R:	Dev Jain <dev.jain@arm.com>
> R:	Barry Song <baohua@kernel.org>
> R:	Lance Yang <lance.yang@linux.dev>
> 
> Thanks!

Hi Lorenzo,

I just sent out v2 and didn't notice your email in time.
Perhaps I should have waited longer to gather feedback from all reviewers.
I'll wait for the review comments on v2.
If a v3 is needed, I'll cc the THP people as suggested.

Thanks!


