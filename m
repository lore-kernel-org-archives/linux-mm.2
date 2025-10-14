Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C53CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 10:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCFE8E00E0; Tue, 14 Oct 2025 06:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86CD68E000D; Tue, 14 Oct 2025 06:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C288E00E0; Tue, 14 Oct 2025 06:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60F4E8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:49:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 095C2887B3
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:49:37 +0000 (UTC)
X-FDA: 83996398794.14.0669971
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 551671C0003
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:49:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SkEofK5U;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760438975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l72lVU6du75JvK+9reLQWVCcrvoZ1EJITOrS1vD5KTI=;
	b=46ixbOWmu6ozKPQRQkeq2msiAO1KHLqNCn8s+qsv+L4FCq/itcoEl2gRTxd9VQanXCRQdJ
	SVbgD9b/ij6Pz0JPNGFZhe4PmEUZesmsLh9ofbz3xiNM/bPi7V9U1GKEzl0Yhe24iN25ZY
	xUdtn5csdGwNwE3rfyqsVVNUKUosZkI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760438975; a=rsa-sha256;
	cv=none;
	b=ZjX24/z4siTEw38QP1Rfz0Q5KP0HhzQ9KS8Jd0LOOf1eOowkDim8VutF2WQcimjnwAsDJ3
	ftAa9t2vBbGg0DdirYNSL5ZzEm/wqSiWgI08ZTK4pDc4fbqIFhnTAZgJgUOXBVnBrjujFo
	x3z2ZqcZay0WuTDpOkzVQhI4Cmnk9lo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SkEofK5U;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760438974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l72lVU6du75JvK+9reLQWVCcrvoZ1EJITOrS1vD5KTI=;
	b=SkEofK5U3xpm0aZkROvmwJfljgZXKMt4TE69NmWbMlAohgvfCqTT7qF9s36IS3n5IlBmdx
	VIMZNPi0+Ws5h8xeACq4eq1IbbyI498RxlBWlai3oUtfSsBLzBxMFsxR2cvv9PicoJCWrL
	QUjBSh/ohTbLvqb1wHggIZDdXeURn7Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-152-dJEVaODDNPu-uqFti9Cx2Q-1; Tue,
 14 Oct 2025 06:49:31 -0400
X-MC-Unique: dJEVaODDNPu-uqFti9Cx2Q-1
X-Mimecast-MFC-AGG-ID: dJEVaODDNPu-uqFti9Cx2Q_1760438970
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 594091800562;
	Tue, 14 Oct 2025 10:49:30 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28B9319560B8;
	Tue, 14 Oct 2025 10:49:28 +0000 (UTC)
Date: Tue, 14 Oct 2025 18:49:24 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: Update __vmalloc_node_noprof() documentation
Message-ID: <aO4qtMe8iMdcs0EV@MiWiFi-R3L-srv>
References: <20251013174222.90123-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013174222.90123-1-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam01
X-Stat-Signature: p71za5cghumdrgcrabjhzazeztyn5tr7
X-Rspam-User: 
X-Rspamd-Queue-Id: 551671C0003
X-HE-Tag: 1760438975-607569
X-HE-Meta: U2FsdGVkX19O1pjzOz9kBCIRDhHU9/QkgO05a+QiEv8oqHOdeFE43arwgirJjTY3tnrGDqLViRVFDiY08Rjn3ELAFcb59H9QLpcRaX7nFTWoo2rbj83qezU4GnkBQy0XzgACBSfbTB0wNNqrPdK/o9Z/CkBAmlxKgiTtAkdenYotReYdQ+jhQxMMGYdz5zrugFEJsZY3Nzf9tlG6oJ0IJsMZ6cwGAuxG6NVJrG7rlDd9xcFEyiuy/tu1VUoaPaZu75rOZGg+S745WtRyOCVz0l9EVy2ArMZ1DnOfR+F8rcFZ7/CeVW62LkxgYEjUBSF9Tg4OAcOVBzb0H6VuCczThcmUzp6A7h+6kmXbfF+PNKWoSfkOXoR6oLXtDfASeLjBf8aw3sc9M4MuXgqdgzfxzU4/5TUuKwl3YrumA6khDa+M+q/5rp9MyjHmKknAaSezndSdwvdwJ3XRfEE2PGEm1+Y/dLZrUWJkK2Cgjkv0d7JurTvgaOWMbgHbsZyVCWhQjrYC8Z+8z2qX3Y+KGnrwNHxw0RAsWsRXGVDJRlfjG+i8y7GPNzHlFheXDheClU1OtQEo5J8F9/qWzCKutX+UMGUgbVdaGdba/rS7t+RjXSomWU1nBCuAYDIIw7RD27szzv7sWWgyptmwYDLqhI4oh6GRzLA514ZMMCQ91rcu9QKkSGbWiOj+lXpVxyFenhtaMcz2xLXt5shcrGW98eFkUUfKbHDhpziaRWerAV/B3DpJk2/8Vn8zxBh/uG8YMGQLnMa6Tgrq0fn5v82qsFC+XdIsHv4XJJT5/ze5VnI9pn/yFg7ydPKMNvpshm+NPT/L5USgGiBIBWDRWEj1iHzf43ARhEr+PwM7eUsRV9rtHY7bN92erebU3xh3+IniRCygFuEMcpRiNjAqNe+WHpTYssmlBXnoaIxpARmm9zA4g9gNUho5ZX13THLnO1IX5YRvwu2Tli9wbX28+YmZGZ1
 2I2J0OT/
 YqPeRKRuFTD8MrGHE3nGNxRM2F8Pb5DdoAArOXuMdXwEkNazkcTC4lKGP0y1tP+mriF1SY2zdwNc1OpU0aCHrP3gdcoe1Sv0q/csphQW1xvmRdtibXe6bYGpNhRk1hK875nOgtdxr+CXA/elgunYMTuleFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 at 07:42pm, Uladzislau Rezki (Sony) wrote:
> The kernel-doc for the __vmalloc_node_noprof() incorrectly states
> that __GFP_NOFAIL reclaim modifier is not supported. In fact it has
> been supported since commit 9376130c390a ("mm/vmalloc: add support
> for __GFP_NOFAIL").
> 
> To avoid duplication and future drift, point this helper's doc to
> __vmalloc_node_range_noprof() for details and the full description.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 9a63c91c6150..c31fa69cc530 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4027,11 +4027,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>   * Allocate enough pages to cover @size from the page level allocator with
>   * @gfp_mask flags.  Map them into contiguous kernel virtual space.
>   *
> - * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
> - * and __GFP_NOFAIL are not supported
> - *
> - * Any use of gfp flags outside of GFP_KERNEL should be consulted
> - * with mm people.
> + * Semantics of @gfp_mask(including reclaim/retry modifiers such as
> + * __GFP_NOFAIL) are the same as in __vmalloc_node_range_noprof().
>   *
>   * Return: pointer to the allocated memory or %NULL on error
>   */
> -- 
> 2.47.3
> 


