Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4051CC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 22:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF646B0088; Tue, 13 Oct 2026 18:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6602F6B008A; Tue, 13 Oct 2026 18:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576196B008C; Tue, 13 Oct 2026 18:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 239A26B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:12:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CA63A02B6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:12:45 +0000 (UTC)
X-FDA: 85319003490.06.1A004EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA35620005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:12:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aME28oZG;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791929563;
	b=0yoprO2m7r2Sy5foDJSCvjTviyMDp3WLKqgVnOqw4ZD/T1/rfEVdvW/ue3+zye6izVhbSx
	dWLjEYbtAhE+k7R51+vixvSNE6Oot28A54j0mgwDj2R0UnymfJBQf4bn067TWqXeGXEOg1
	LPukjMCHKXcWvzCvKxgZAVZtqGGkLtY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aME28oZG;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791929563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IWTZDsa935wj21bGB8vBONkihK5G/3DpXxeoZPCgiQ=;
	b=sgCaVPI/ik/xK50h36G6gLDx4TzfTAhlJ95cQm7AhqojXEbA5CHxcPkyl9vZHbHR5wBoXA
	suGB5kPLzgt7l5DcH/GxKuBvCegAHXQKylNS9OY3CqKJV9gfZe2ME1UWAsrq+TLRX5BPwv
	P1S0+o2i/3+KXAcTpNsR955AOHfsVAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24A79416E8;
	Tue, 13 Oct 2026 22:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12551F000FF;
	Tue, 13 Oct 2026 22:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791929562;
	bh=4IWTZDsa935wj21bGB8vBONkihK5G/3DpXxeoZPCgiQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aME28oZGAgzYgLlb5N4BWBzXkODcJumjTJWJClMakkjxh4PuNcEGo+/y1pM9SeUrr
	 LSYYATmt3K9iTX+RJ9RY0jB2LTx6fp1HXFl/AX/HYdyNC4U1mWl1uxwOmHXSfifmgM
	 yih1bCuSr11rL5OGCdWDkD15YFbyAoJG68EfL84w=
Date: Tue, 13 Oct 2026 15:12:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Muchun Song <muchun.song@linux.dev>, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 183/193] arch/riscv/mm/init.c:1544:2:
 error: implicit declaration of function 'free_pgtable_page'; did you mean
 'pmd_pgtable_page'?
Message-Id: <20261013151241.c8982a44c32d93a8ec010fee@linux-foundation.org>
In-Reply-To: <202610131439.F2KDdzRA-lkp@intel.com>
References: <202610131439.F2KDdzRA-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA35620005
X-Rspam-User: 
X-Stat-Signature: uttboohsb5exgnkheo8xuh747uzcc9ck
X-HE-Tag: 1791929563-297587
X-HE-Meta: U2FsdGVkX19+sV6eOhD3owEsbi/tYrJ4HZqLJI4DK0Qfms8im8DOycvKtip3Nm7jQMnvmZJGBvkG7aROe/RyKDbMlV8NeN9r8giCQokm88y9Kr0F1TIqnKbUtBK06MPFsH/iyibg7rAPwu0oTZcVEX75/iun1LsW6tMEJ5QqLngjp7rtfpHGBAMhOfU6PUexR4OX//uaoZYkOM41dT7jQcp7sSurn3DeXBe/ujTFj/39Uo+RTjNTir7yNrrTnvsYhhI3sRrINQA9H7twZArTJr+glJYmBnQ8bXW4hiy+N6FXeWHcivR8yPNDffqBAYfm1JyTvwzjREpArwOqtDVsc6XnDTMpqVGR/fOKI3+ATZ0S7dA9g9UCiTHkrgQ8BE/qIjoOtFuUndkWY8qBuAeytuOkuUT4xpTMmUlmBhq+jFSHVobBRwkf/qsPxdpa+sdti+9UIfqzoxSM+qioLOD9pcpEkv4Ob+7m96sqZq2tGS4nip1Axfp1Y0HAyW7MwkWdEcodb6XMju8UTR/8amq27R0Z5cHPEz4vGqMBjg3lXSdnFqfJWKsYihAqkUNPS8xuXR1UCOIBhjJqZJQ3Bc1eiiBZNx86xrZjD2oFTRzYVtX5sdfk0t6tunbr/EmO4pca8s2C3C/V4n+q/iJW8+Nzs2Amcg6qzxvY5JGcvAEcg7rwMEpOoaDtW9+XBXU0xXvoWGhGQHl2NOIID2u3bmgQBNu1jVGYD/h4urqMuu/Lj7qy1OplDlLTGgNtjwkk6CNSyt8VE+I1L/qFTkqTnswLoO7X9A+MdqBcLAk8kw+c0OrPnMR1tic79qvfZby5oqhLoLDR964KCARnc0Pfdevt1ONBDZGPVki26aYIiXAJcHZh6VSa6yFvFVjslK4AotI6NIZpt++uXHp8YmY53I6AFMJ/HaQSggX0dkY+9nhw6/dVM9wL7HDxrwnzk/ABPG5kehFt1ZRBKfcU5QhBqc7
 zKX7dLvk
 xHh6Jr9gwN98IwkN+ZVo9F7YHem7/BRZeusAvadqhgMCb3wy2JFHgeniVJTpVOeL9PYcXobpg4AQ6DWuaUPXnnWbWh++NekZH5u1fzoHos1zS8+jB/2Cln43GR45GuvJEpYveUhWxy3m5pkyt28sEOrbn6eNlQmYcm741D0PtbLFHNKbE2S0XqNiJuh830eaqni2mV0TYkNcb+HZzHEO5iA8co146pLRoB0A/N9SRY48oac5cZGDQt8PJZsX5zpzXerXnsbFMGSnSfkcT1dOyLR44qCp5jabdKjuiTCtT61Qf2j5weiByLwOH/v9CeZD7BDNJpd2VF2db6nVOybkuZzrazEFj74BYpJmjY4lud0Ckr/P7eTYfm3th4oSyew3n702ndEg18QHdjpKC/I6ogIjlbULeiWuJONtPMmypmn/xPMZWTQGgwUCIBNELALyqey9j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 14:18:21 +0200 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   7186f1bd21b9094cc063c10f8492fd135522d3cb
> commit: cf6402c085736133c835e1f815f79e7e1faf97a0 [183/193] riscv/mm: fix missing destructor for hotplug PUD tables
> config: riscv-randconfig-r2109-20261013 (https://download.01.org/0day-ci/archive/20261013/202610131439.F2KDdzRA-lkp@intel.com/config)
> compiler: riscv64-linux-gcc (GCC) 10.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261013/202610131439.F2KDdzRA-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610131439.F2KDdzRA-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    arch/riscv/mm/init.c: In function 'free_pud_table':
> >> arch/riscv/mm/init.c:1544:2: error: implicit declaration of function 'free_pgtable_page'; did you mean 'pmd_pgtable_page'? [-Werror=implicit-function-declaration]
>     1544 |  free_pgtable_page(page);
>          |  ^~~~~~~~~~~~~~~~~
>          |  pmd_pgtable_page
>    cc1: some warnings being treated as errors

OK, thanks, that patch is dependent on "riscv/mm: fix hotplug
page-table destructor handling", which I've disabled to simplify
merging with riscv.

I'll temporarily disable "riscv/mm: fix missing destructor for hotplug
PUD tables" as well.

