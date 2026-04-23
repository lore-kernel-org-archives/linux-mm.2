Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A16DFDEE25
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 16:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5799B6B0088; Thu, 23 Apr 2026 12:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A9A6B008A; Thu, 23 Apr 2026 12:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440CC6B008C; Thu, 23 Apr 2026 12:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35F956B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:34:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE13F1B75E6
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:34:24 +0000 (UTC)
X-FDA: 84690368448.16.D2F218B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0CFE81C0013
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:34:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LY6y2g3W;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776962063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2GGr7b37dgXuZ6eZSjinbFXs16Kc8rvDg7RW8vVGEk=;
	b=ctygy1on+HPJHgm3B1rfBUOkN4Qlt5/6Zs0czSON9CQyDgwEYqlEiOBcTTDEboN1e1vN/O
	xYZ8lLlmdIf2FnJonqIg7eIXcJ0yd0lZC276T1Y2i8CZoye9i9H9vjygnTOlIHwwlsuce+
	Rgpi1ZmDS329sCs36+miQzsHAjNcf0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776962063; a=rsa-sha256;
	cv=none;
	b=HzV1Nj2AN/YklcUvv7hU+e+3sQvXCGLjHMcLydkd+wD3RV5PdtR6Bzml4qP8qweOdzdaSx
	8GftyVJzc7AIRbzl/+tH+K+IX05/ln5bHz8s62i1WdXhFJsd7ZwNPERof7AVN40ppTIWI7
	cWpANjPON6dIgTtsaRFLptP7ugn4tFc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LY6y2g3W;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F03FF444D7;
	Thu, 23 Apr 2026 16:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A45FC2BCB9;
	Thu, 23 Apr 2026 16:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776962061;
	bh=4GV1LwaL3R4CX1TrfKOJFk6xyY24OhR67CD4uj8q+bU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LY6y2g3WBxYtdzT+hfNtg/JvaPHW+XC90lR1gRan7/v/4IBBPjb1RWeIO/0W56iIG
	 QAn3WyDcQKDd4NgSzzsCrLc9bsjttE8KNwLDN/16GQNEMYy//oUR/mU+3ros/FSSFb
	 VpmxAVRPRogBwV83wNCwZEEgLXkx1KQL6GSJIE3Q=
Date: Thu, 23 Apr 2026 09:34:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Marco Elver <elver@google.com>, syzbot
 <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com>, jannh@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] KCSAN: data-race in mas_wr_store_entry /
 mtree_range_walk (2)
Message-Id: <20260423093420.038ce8c6ffb45279d0a809a0@linux-foundation.org>
In-Reply-To: <4ub4x275tpkop5jbx3l7p7zqeww32tb2yzhdgqqkvakri7dyih@bdxuedw5utlc>
References: <69e1f975.050a0220.1de265.0009.GAE@google.com>
	<twv35g3umuktagxixl7q4upjz6hxf2rkep2ophcwz2qzbschrf@dy7lcxu5wrly>
	<CANpmjNOG4mDJr+LSWWWJXru88yYrxG3wFBSiWzqUgn7Lm28bjg@mail.gmail.com>
	<4ub4x275tpkop5jbx3l7p7zqeww32tb2yzhdgqqkvakri7dyih@bdxuedw5utlc>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fjg4g7njcb7fftnktriwmhgd18hszqmf
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CFE81C0013
X-Rspamd-Server: rspam05
X-HE-Tag: 1776962062-143991
X-HE-Meta: U2FsdGVkX186RmiZgeMKhE4GPeCLrg86lXU4N0MEkPo8nEtubTjWA8R3q+dxJla7rUdPLKugBzkBXG+ybPY1/sU/cIVWsWhk/3OhhzEVFogy08V67b+kLzeFSG1lJvkMcwfnjyHbUKHvRqeNFuquKpajWugO6NGw2xJWSyv73WzQrxUCq6lKLECV7akQm64Mp9lmp7Lsp4CwRdDaJjx7F4+0GAFg4xtmvehEEUyxAua3Xos0FxXIAQwrXX6HK6dCXMvg1AZyFEkNloPNSfsBxo39SWlXI9pjAylS9c+VaAtAGkRgtFEmyOdjdlIPcDKoi4qQJdZ+VX6VXzcf/xZZZdwde76uYSdLSCXpfAo1r27u66t87uvJw4d3jejiDyikxh0OsWDpTBbQ39FwQauV//AmrQzV8+TXA3tAcPRolnpZiNQ7hlIA7FTon84knfKwbvuMyxCsx7Fdy+M7C2AMv3cnkdvid2cdlDHkoYQDdUTXRFNs873+HagNoiLJN4/bHWh/CgkLbaR5aUa88ZBcSL5J5PSd9xQcpITztTxPjYDZBu3E0LSbk1BmceDYhkLnRucETJMKw1/9XYBeJkSC8J7FKjD3qrPhhJJSmRhutoog0M4jwnVzUUBI80iDUeSquo8eEWuv9KAnDfnA/9VE/Y7zfX0ZcmaCuXSCxlKUtKW46gsdL8hi5GnOE0oiy0jrb6zIKFtJfOX5tEAN/qisQsOXvNvksaw4IQQ+b8InViKIHadCgzvgPSr719ayRt651+jzgAS1o0DTGXxLBXdfD8P2zQiE6Vuq44LXKWylf45iPV0iarP2DKLlOlvSboBUQyxnXRVWkUsCRzzbpe/b5vL03pVuFELu3YLuJnSLdJpg+9+nISJHEqtKvDdr8V6tL32FECp0YhrJ5Zp/gJp0bJ75PARW6+OdXW/+O1QWCvTNsgBfuaogW8oHcPUElSUlStR1Jwof779JtXjpdpf
 9+I4oUP3
 3VP4R922Fde4TPRgQRKxJYeUDX7MpXOyNohyrxkPOvAN6Lw0vM1lJauy+CIXb4H9o29gZCK885bzwg3ktj1dvwIHwqWh2MnbN25B4hVoRTovLECOd6iTtXrvphDnBfffdDFi0CVg7GJyvIm34ImWVfP7gfoKEBshNWSk6Yu5KtnurjlKLLD12OD72d3+pu8ZocYK+nSWdJA1/XFhHNvxoH62LMSAEcTbxeYpd4ZdD641xpkAKKFXgHeSsUgzHuszm4vX4lOdGS/kQInRnpUepCLyyNDRcshOA32A+8BFBDTmSGS6z/Xttc9HY/71glK6krONYhkHwlKMv/SsydYos4O8kHbgFIgeuyJI6F7vMzoI0i/7LVqzn9RI8XuQiMdMycoZc/vwOsIDjw1y8mF70KPenU+3FSoRwltg+gbtIbz8Rj5nl68PK2MZDI2UlgGS9BxBPjqKpwdmX9KU+WZgkmaayYbgl5XF3i29h9PBInyTMpta7u/EN2021kgwY9jp1SgEgjfYWgW4mKA3lQ0T6YdqMgy3r9KDwdEGaIZzzS7Elf2800ai2MI7LKj9ztkzZr/1IkET5HZw89HB/kSa6xpF19dqIO0p+GLJ8AyepUhFemsPdUp1AFD0WHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Apr 2026 15:29:00 -0400 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

>     Link: https://lkml.kernel.org/r/20230628073657.75314-5-zhangpeng.00@bytedance.com
>     Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
>     Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> So, you can see that the author of the initial code did look at race
> conditions.  I wanted to read the link for more information but that
> link isn't working right now (403 error).

lkml links are temporarily broken.

Replacing "lkml.kernekl.org/r" with "lore.kernel.org" fixes it.

https://lore.kernel.org/all/20230628073657.75314-5-zhangpeng.00@bytedance.com/

