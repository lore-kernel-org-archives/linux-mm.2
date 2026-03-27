Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48A510BA42F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3AF6B009B; Fri, 27 Mar 2026 02:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37B2F6B009D; Fri, 27 Mar 2026 02:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9086B009E; Fri, 27 Mar 2026 02:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D99B6B009B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:03:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C072D140FEE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:03:53 +0000 (UTC)
X-FDA: 84590801946.12.1FE6C7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0B0B340014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:03:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lx6yiDrV;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774591432; a=rsa-sha256;
	cv=none;
	b=QY+il6oPl+fVQaP6XYktyjRBEL70jF7RszTapnSY9pUmqlzyqIgaI2W4iuoa6C3wB2KPif
	zTRH+z17EZdAviD2GxSxaqA+uS1g2ndsV/wxl52dhghFICaKS8eEjnKZm6lVBK4XdwaF/z
	iECzlspDSHPgjATAF+LuIrbWCcaa3LM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lx6yiDrV;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774591432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqVxmQrOAsD5LZYw7jicTvpMPXCRspRG4atk3SEmTBU=;
	b=To+gPvMu8/5dzQyhqz3dWQdc9TqfH+7HQ8qt+/2yY001mh/Zf54UUD2IcJwi7spDFA7Y3z
	DFvBWw6Y3pys47DlHS1TSV/SF01nyFK5M2DjMy+9SSGQgPuT6mqZ1zJCdZFeAqDhRPRYyG
	6UbQ681W3a2et0BlxcoEtRjoFq7IUdg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BC5B442C7;
	Fri, 27 Mar 2026 06:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E31C19423;
	Fri, 27 Mar 2026 06:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774591430;
	bh=dIJgpW3rgNNkTB5QrRD+G5rTSR8uZZDY8VpAkWA7Li4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lx6yiDrV8sD2/KIpF7evwAgIzinKOstx6sQXxuKbm8EsgqO4aWCaVBBIzUbRtchFQ
	 d/fW9dt5XmoaoFDD986TadMhjdCQoJAACrVFbgEX/mcMCw5sj8LBi44NhGs0VzNhrN
	 kuw0XlIB3CKBg00bN2IKT9jdYon6yFveuep4wGCw=
Date: Thu, 26 Mar 2026 23:03:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v6 4/6] selftests/mm/vm_util: robust write_file()
Message-Id: <20260326230349.dcd0b30030c7d460e8b0f319@linux-foundation.org>
In-Reply-To: <20260324013316.2590422-5-chuhu@redhat.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
	<20260324013316.2590422-5-chuhu@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dpjsnxpkh9ebfey4dijih3y4c88s1jj4
X-Rspamd-Queue-Id: 0B0B340014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774591431-337576
X-HE-Meta: U2FsdGVkX1/Pkj5W9PkY2zSQoqD3MFNECXF1Zq5QIxwij7xV90qFQxt6+ksNhIFiR8YAv+/G52Fw93gh9I/ZTL5Oe8+M1VuoMbd8Mv0FOprvyhNpqM2wL7BoEjL72HmUc3MewNppnCrlN2TJbiLMkT+ibqLERVZcJUOvmTZYFUclwN0iSTiRW0lTQoowPS+qrzrU5f2clXGO+8Z3797ntGgx9JdGNOszj2Pfr5ydxyZROPCY0TOJr+2hqZTZKYmWNtvPe/zsmxPphYVtCTZYrPsb5DX6mUtYF7FItjLZPQfDfWAEHTn4u/6S7smIrKkHlFl5Dq0N9PZMrgW+GAG9kkvxHqR5pdLDzhECHf929639qe0W6hv7ATibzSGP+dC28TGdyBqLsrKB/+1BP0mnzEhiYVpaA3mrOzfqoH8OTqmD+emE0phn2zNH285TLgGwkUECLSGOK8ErJRMD8ptVCHIZmYMHzdeON0GF21KjdPwvaETcyLqoaRSQwYKUAjxJZczP0+/IzBnf3wfVN40GevwN/jqdtWb8ZO6lt33pQhg4olLXaLU/UBkHrhSCT6snANDSAv2V8BTtwMEwqmrnkv8F48qZtIrM0JFgBs1DWabLlzaIlIECdYLVJEx7SqM8l9Dz1OCQi4T74Z6MSHh56iii7C7vCvlsewSAxCTnJCPA5GtZZkeKfeNz/j/Dt/9Lfc0XZPKrfmnS0WmePY43t188iWwV7dMKOPKQhXie/VaSEtKDg922e0K0Jyh8QoAi80/jUcZ3eaH2HaRHDBmdZuIGu2P8BLOwy19bVBabGthFtHD2qrlf5nnFVuXRUUXX0E7N8OwljmzJfmYa4JCO+DLv9ofDGB3pBcDHmeOFbP8lkYtP5KHW0Am9GDE+eybGys+yM6b98+CCQPLqlBntR6WdxZ9v8JJvPTl5wWeEtnKd+1FQpEIYpakYVfRz7YIAWhoBG33gCe+80kJaQU9
 Dy7d9KZL
 T/yPmx6YaV5yo2Ywe8mqxLl70oIowRG+m/RDKpUNOb8Qw/WrQCr+OTcY9XmJWJq5Ydx78hLKACnoIHVhkxblpQK8Zvl01Jxxr8D0LAbuCp0dm2plisgteFe9dFWvw5Rp6I/DVZlCquuK1DCc7z10I0SB567TjkNQ/9VuRmzQmXGvbmllW0wOkhpddv5eBFwqCBZGAoU6Rafp58kLnqyBgwBlQ5pbNZ4BNX7+p0ck2dggcKD+PTGnH6qsSxmFnRXOIaGi2FGeQKnudHaRwiZ98HZkaFCKR2yriCFoQEXKwqXdowUPgnT+ikxNP33tkri7Iv3oZZl5X+IGWipBqaIU6udVjcEcAtyYDKcFxv3EgPYSPzV6jYZJdDZ3GGmk2NazwD4Zk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 09:33:14 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> Add two more checks for buflen and numwritten. The buflen should be at
> least one, otherwise the 'buflen - 1' could underflow and cause trouble.
> The numwritten should be equal to 'buflen - 1'. The test will exit if
> any of these conditions aren't met.
> 
> Additionally, add more print information when a write failure occurs or
> a truncated write happens, providing clearer diagnostics.

This one has no review and AI review did identify a kinda-bug.  Maybe
nobody calls write_file() with buflen==1, but still worth addressing I
think.

https://sashiko.dev/#/patchset/20260324013316.2590422-1-chuhu%40redhat.com

Chunyu, could you please take a look?

Thanks.

