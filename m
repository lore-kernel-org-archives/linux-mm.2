Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A2F5CD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 00:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E4F6B04D8; Mon,  1 Jun 2026 20:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54EDE6B04D9; Mon,  1 Jun 2026 20:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464326B04DA; Mon,  1 Jun 2026 20:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 355CA6B04D8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:05:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D128F162A87
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:05:05 +0000 (UTC)
X-FDA: 84833027370.22.2054F00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 240282000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:05:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jbAoYU1j;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780358704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkfeLI+37zLW0sMlnQTmo8K2Ux0zvzJarLoyrF4Hw+M=;
	b=00ya/5AAs6+Zy5ZYGSPBAZV3b85aQvc/7yJFTzUD9B75SfHoD1ZvFt7UDujlFJe/WIxV7C
	5EY70IGJy+F0QSB6lU/skh8XZeldTXdBvgz/2TD5yibvgb8b+2NKk0DcEvvCLAedE6Dg40
	KHT6SvGHqTo6Y3TXwNrmoXHniA0/DGc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jbAoYU1j;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780358704;
	b=AxY+bzVNEJ6gGvCS+sAsygdAhmvue3yB14wD1LhGQGnz1vhnVtcQMdN6dpVdQaXvaSgllH
	zBt23KcnI60XSfYxq7UqatHav8s8yFSV4V5y//uqvNHsU946WAJLdMvR7OHv5hGByCXy3z
	AuKh8pycy8MVnq/Rm7hoCIHRDEBq3Ac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EBED40240;
	Tue,  2 Jun 2026 00:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2FE1F00893;
	Tue,  2 Jun 2026 00:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780358702;
	bh=VkfeLI+37zLW0sMlnQTmo8K2Ux0zvzJarLoyrF4Hw+M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jbAoYU1jMIllEKyXViMDWhrfLeiinTuhaCfnLb2Wal0c6n2SyKfW766R+dbmhfWwA
	 Z9e8v+f+fyRopf9W9/SB4GA5Qs0CPcJovDAcGuAT+E3xl8nYo4SMZ9Cb4WrEhO3v1v
	 IpQibb9QEb2/FV1jY1XlvgciDuGAmNss4+CtNZUE=
Date: Mon, 1 Jun 2026 17:05:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Hyunchul Lee
 <hyc.lee@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH 3/3] mm: Remove __folio_index
Message-Id: <20260601170502.a3328023425ca85409c77957@linux-foundation.org>
In-Reply-To: <20260601192626.150804-4-willy@infradead.org>
References: <20260601192626.150804-1-willy@infradead.org>
	<20260601192626.150804-4-willy@infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 240282000D
X-Stat-Signature: o9chsmhj3gfziec3nsf3zfdhhrmbrqhk
X-Rspam-User: 
X-HE-Tag: 1780358703-184327
X-HE-Meta: U2FsdGVkX18NGgEwUQ8Iayp3EUFWL/BCCAplDams+0aKzet9OFMjOXylGtGauaob8DhjdSGcxba54qPcIZIsYEmkrEAOWUDpSB2NL0FLeufUlwekTXqtcdI/wxVHGMRVUJ0Wo/uGRduCXmrUTKXS8cOt0qpQTk3tRIwAgYmioI60MFBcsTuIfVqoNTmH/0igSkItzsK5mUlkdWWD4D8VY9WtWp8tP6CDMYmalzjig0pwUz0Qw4S3/R2Dh2yV6Lo64NSzvn2r8DcmzloCf/c5y8T9wVD5Ipsb+RXB32xndlocSuGXMOmVWAa8mAn9/5cfsl3SyVPB9eOlY8Cpg4MNQCyUpQR1jVEunQNcmqhnMTpoc3wlIYYMLRVoTTfooXiJbcRHKGJygAjk0RfNH5zGe+JvZCLAxGRUgZy3q3MqDRNTUnPM2D/eF+ZtzkBGIpy2Shxa6OlmAfPQYPTfMpQea7/maHSdUuhFumOEgI/Ftc4cp4KeN9/+twwPO8tY13XxqEs0ZITlsWYSS/ouOnrvLYV1TDA7c5jSNfPJR+UbTgxYjxTomg9Jj4dX7X6gYacMTRfYJrk9++voNGkZ+vpU5jYlpTuQpz6JJGkw/Hflvx7/6m5YXjnYjuwBs+kewJYVi/85af9aI6Xo315SyeRxxv0RutALKP1Lw72tcV/gk/pIVl6UTY24tVcEb2sU8Xsbtg30cWNmv7YvSAYffd3AO65lph95sDw9+1vVXQ0kTbm/fc2fdhHYSgykhiyDwphqDYsJdhCQl4+H2p0Ahazo1CsMlidqV1v+h4JDgMtqc5pMaxLtJYtlJTjKrBt9YOUU9qy9+n7PxrNBEfjeo7FoexTHc/PgLGPekMKQVybdxQbLg7q8cb0N95eM0aT8EeI4MEC2hTJf0zbFvcZ5eNFZvxsFR2zv3lr82g3l5oysDO/cToSs2g7i4ekLbKNFhbepexODRIAFou8BDFiSslI
 me4lNMLn
 S7YbefLp/8gfzpbCoOFS7BDfQYy2emASw0K3sOyv+ZlentR/yxR9ycHMbjJ6CAbwhL8vVleoMIR8aJkqA3O3gNzLv5FVysQmWeHrpx1QzmGuXnutRmCnsIKbUr+SbwTsRLMKg46477GdPjlboPyC6saBl6wchs14sC/vbHpuxG974hJ3cx63NY1p2hPmC7stCk2lTxb5mlj9//cCDfsOgctEzkMWkA0oBPgLLDGdX2H+5AdT0w5WdcRhd+ps7qo73y3+wimoA8UQdoOu8XY41UakcHTOZtNrtXYUlZz9vf6HD0ntwx/HuUD1xlm144cNufKO7k+gxfdzGRdxc5Jss3pCR5c4+V56Ak1L8Nw2JL6jrLcDsEY6nDR6/WohMxK2jIBPHcAlbeGDQK4atQuiUEvwFCbmz6/Yn2YkvANsf+U5jggd8GpogQcknM497Zy7vqPrdupIHz6ql+71ekFz/LOWROVFTQwbmr6eYOdWdxKmFOgE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 20:26:22 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> People have been abusing the existence of __folio_index.

Patchset is rather amusing.  Perhaps you should have called it
__folio_index_dont_use_this_or_ill_shoot_you.

>  Since that was
> too subtle for them, use a bigger hammer to make it unusable.  That also
> makes it unusable for the FOLIO_MATCH, TABLE_MATCH and ZPDESC_MATCH
> macros, but that's OK, since we don't care what fields these fields alias.
> 
> ...
>
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -101,10 +101,9 @@ struct page {
>  				struct llist_node pcp_llist;
>  			};
>  			struct address_space *mapping;
> -			union {
> -				pgoff_t __folio_index;		/* Our offset within mapping. */
> -				unsigned long share;	/* share count for fsdax */
> -			};

`share' went away?  What's up with that?  Unused?

> +#define DO_NOT_USE(x)	x ## __LINE__
> +			unsigned long DO_NOT_USE(_pad);
> +#undef DO_NOT_USE

Sashiko says this doesn't do what you intended.

Sashiko also might have found a few existing issues in ntfs which the
maintainers may choose to examine:
	https://sashiko.dev/#/patchset/20260601192626.150804-1-willy@infradead.org



