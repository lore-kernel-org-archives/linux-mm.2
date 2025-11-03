Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90DECCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7EB38E0025; Mon,  3 Nov 2025 02:14:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E563F8E0015; Mon,  3 Nov 2025 02:14:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45058E0025; Mon,  3 Nov 2025 02:14:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF0D68E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:14:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E63512C021
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:14:58 +0000 (UTC)
X-FDA: 84068433876.08.6003B4A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id A5EFE40014
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:14:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="CtIdrG/k";
	spf=none (imf12.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762154096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIo7T0pEvXOjHk/2UjQ9D+bXEZ7esBCrIMEr5LaABD8=;
	b=WFSiPDJnDScx1lICS87eHde7/F/2TZlxqGtEq0sE/PU3JIUyumdhB32Nt4yQ/U3ou7cHxc
	flfaGauKINe4fiXpOasMnzfFnGXGn+Sx22XRa1yTLic5ZSNuBPndy6fRtncE1ulZozfpWY
	dc3s8i2uH2WKbszmzN34OdKlaUHtp9A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="CtIdrG/k";
	spf=none (imf12.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762154096; a=rsa-sha256;
	cv=none;
	b=4pKTwddGvsnTowA/EJVwPLnMtGAG1WqljOckTkkCd6B2VyvoXW9dq1GV77LqsR72BbrMxc
	G91CY4idGMavEVcB8Ikl6f23JHnNZprCU8AeomZtf30gw+ygEnJ2M8jm1ClnAndMR8Fr93
	6VxJK9igFCjlsjklDwYizj3uKl2dO+Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=GIo7T0pEvXOjHk/2UjQ9D+bXEZ7esBCrIMEr5LaABD8=; b=CtIdrG/kicwJtBeyrqdL71kzkf
	Ixd1Zw47cH9hrhJDvymaOZ9KJ99hCaHYMOU7xAfKCQaheuqdsGRNhyeB6Q2uHYg0gCFCw5Qe+oYO5
	t3LLyahOUUICMTsnQluvFZp1F2ECx3l6VvpK5E2B3Dm/ohe965p8lmiWZin8skdEKVOM9L4xGtPjC
	mWXQ3Djqyewcrqr2Rcfh19Xg3574FNAowTahco+GQdrp9SANs5Zs7wRZWmGYlVFep58w/w+x8ym9U
	dZ8ZxZqex66du2NlF8kjWgpoYohoswZcqsJcUTFKE6LPkV6eY9vCBEzEF/kBVqk0/gEg3Sy1vwbyA
	z5gjFCXQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFomB-00000009LEa-1CVW;
	Mon, 03 Nov 2025 07:14:51 +0000
Message-ID: <7fd1c990-d96e-49ba-9bbb-ebddebf684aa@infradead.org>
Date: Sun, 2 Nov 2025 23:14:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: treewide: Replace marc.info links with
 lore
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Alex Shi <alexs@kernel.org>, Yanteng Si <si.yanteng@linux.dev>,
 Dongliang Mu <dzm91@hust.edu.cn>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Arnd Bergmann <arnd@arndb.de>
References: <20251031043358.23709-1-bagasdotme@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251031043358.23709-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A5EFE40014
X-Stat-Signature: wcqdojd5bn4adqd8srjy6oaycge9xrty
X-Rspam-User: 
X-HE-Tag: 1762154095-723163
X-HE-Meta: U2FsdGVkX1/+CJRN4tkQGJv38c12CGJ1WPDngj1RQ06v/gyZ8/m71YToHvP4WSWOVt9yyVBPr0QpIMwz2M0dIe7D9WdQ4ON9Hsolm7p6CHyrp/5K/WGjsMtFYPtVntenNGv4gxZJavFioCJbf1M7vflcnhXqvhmRZ4AmtYHNups/iPUvPNORhzdYD+sY7XsvbVwTwcLJ0FCptU3h3XzYMOr2tJQaDNHrOSipG/VbNxWmEyDss7f0o/Ai80RLfxLJYU/dSkUWXz1RrT/xe3P9vH48pjr6NnTPQacTSrEaRn2RwNaEG4gaIRBP+oDaFWvtnX/BdIjyDkhSt6ppicjWj/++v7n3x8ADFhNqaQk124guTfBmTgWsQdKrcWj39+WOh5ArpqgVd8KVcV0DiVkZC3N0ZdVjDyWLmxb8Ago0m3xTgF3I8D3EXZTISN9ZQDIrp/3Yyq7ES/pgdU9WAYSDncQMiP9pwO35SJzcmQbTq/8uCaGyAyDHmlmTWL5PjvugQrXq9glKeO7/zqo64mz9CPelu0/4cpGWUUChYxDbiaVeWO6jaL2KU5vifa9Yy3FPJ5PVMgW4eJsjp8wN2fxXqBgQ6vgh+V+iAwzZEsDeBtPdYwbMRjLv/kzF5/+OUnIyb5yZmEt6HeKdd3ilSLnj6hXWdvjEADHFifn54ZfxjozpTCNzO5Q5HtTRAHVlvCwYKHHJZw1Wy6KioiM9Dn0Kc5Zu+TKQZ4FFwx66S/zdl5L9XfVCkXCPx6htYP4MkIU1yC4K99T4UVXXq2zBiu8dRuS8jedNEtHyAphIXTMXe0fCe4RD9a9eJ0JPS5km93hsTJ9AwlsqPPl1eGLPK+14gFi66bb7alD64N7aCR71n84fhNeHcWdWQilgTy6rR8334WNCNtGYNKtUAMC6qfwCg2y8BhhYvfj7I5iQPBbcrL9Okt0ulcPoPaoonkqB+iihhuql7NhiN1u6fOdU/BE
 u2NZ83zI
 yDgIOppW+KOdaQ2Ixh2btuR67rIeJFrV6Kqbt8HUzz3ex2RmlXxgWt6a4fJZ9jgYW9YRNyCuQg+vM1EpWIM/Wzm8lHjwS1qNzABDnjTBHRkgnO01XQHfxwZzBHQ6mIzMo8J3AMUUFbZ9B3lxiKOoonnwyfrvbvDwc33ZsE51veX49z8ha74D0Fv7d8zHLomEXwPIgFYWrUZEDG369/+FazdHlp6Zssp4lOS5WwrxSYi4ZjclZUTYRq6pSiK3ik6jl3I6pdimNYhSQgneWBKMQgF4ObFQHUtNJU3EZ0Waeep9seuNnl0mqD83ZoR3enKNaXtjAVZKpbRYKmzcPNJSqsKrVzD4lakhUenuJGR5cY81MsItclWfFJ8FjhTScVDSmU+flz+07ikriIXs7WYP12ISQ6Bl032thudSQ5sRCnORTwlTcS/gecfvrcka/h+NCMhZDaOOOseXU1y+WljkJFHfKjmhlDSF502C8dpI8F0c2hAhMJMssiftZ29md1Ob/zIJyijALOTVriBEMwNAM/ys1WU3t8E70yVF3rH0W1XVApNDMMeawt/g33CzfGWwzG+rX1iemRcz40EnbEOTogg0mbE5AbKUpEwBvk9mIg2mKTCCxIceLC9umy+TKPCKSC94vYJX5Jv0cQzpQnK3MXc4tR6dsMFKVMD+ImmEutHDcByoh69BjHxhe9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/30/25 9:33 PM, Bagas Sanjaya wrote:
> In the past, people would link to third-party mailing list archives
> (like marc.info) for any kernel-related discussions. Now that there
> is lore archive under kernel.org infrastructure, replace these marc
> links
> 
> Note that the only remaining marc link is "Re: Memory mapping on Cirrus
> EP9315" [1] since that thread is not available at lore [2].
> 
> [1]: https://marc.info/?l=linux-arm-kernel&m=110061245502000&w=2
> [2]: https://lore.kernel.org/linux-arm-kernel/?q=b%3A%22Re%3A+Memory+mapping+on+Cirrus+EP9315%22
> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/driver-api/usb/writing_musb_glue_layer.rst | 2 +-
>  Documentation/mm/active_mm.rst                           | 2 +-
>  Documentation/translations/zh_CN/mm/active_mm.rst        | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/driver-api/usb/writing_musb_glue_layer.rst b/Documentation/driver-api/usb/writing_musb_glue_layer.rst
> index 0bb96ecdf527b4..b748b9fb1965af 100644
> --- a/Documentation/driver-api/usb/writing_musb_glue_layer.rst
> +++ b/Documentation/driver-api/usb/writing_musb_glue_layer.rst
> @@ -709,7 +709,7 @@ Resources
>  
>  USB Home Page: https://www.usb.org
>  
> -linux-usb Mailing List Archives: https://marc.info/?l=linux-usb
> +linux-usb Mailing List Archives: https://lore.kernel.org/linux-usb
>  
>  USB On-the-Go Basics:
>  https://www.maximintegrated.com/app-notes/index.mvp/id/1822
> diff --git a/Documentation/mm/active_mm.rst b/Documentation/mm/active_mm.rst
> index d096fc091e2330..60d819d7d0435a 100644
> --- a/Documentation/mm/active_mm.rst
> +++ b/Documentation/mm/active_mm.rst
> @@ -92,4 +92,4 @@ helpers, which abstract this config option.
>   and register state is separate, the alpha PALcode joins the two, and you
>   need to switch both together).
>  
> - (From http://marc.info/?l=linux-kernel&m=93337278602211&w=2)
> + (From https://lore.kernel.org/lkml/Pine.LNX.4.10.9907301410280.752-100000@penguin.transmeta.com/)
> diff --git a/Documentation/translations/zh_CN/mm/active_mm.rst b/Documentation/translations/zh_CN/mm/active_mm.rst
> index b3352668c4c850..9496a0bb7d0705 100644
> --- a/Documentation/translations/zh_CN/mm/active_mm.rst
> +++ b/Documentation/translations/zh_CN/mm/active_mm.rst
> @@ -87,4 +87,4 @@ Active MM
>   最丑陋的之一--不像其他架构的MM和寄存器状态是分开的，alpha的PALcode将两者
>   连接起来，你需要同时切换两者）。
>  
> - (文档来源 http://marc.info/?l=linux-kernel&m=93337278602211&w=2)
> + (文档来源 https://lore.kernel.org/lkml/Pine.LNX.4.10.9907301410280.752-100000@penguin.transmeta.com/)
> 
> base-commit: e5e7ca66a7fc6b8073c30a048e1157b88d427980

-- 
~Randy

