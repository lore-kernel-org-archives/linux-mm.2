Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE23C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0784F6B01AB; Thu, 13 Aug 2026 03:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050236B01F1; Thu, 13 Aug 2026 03:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82EC6B01F2; Thu, 13 Aug 2026 03:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBE286B01AB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:20:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E1AD120537
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:20:32 +0000 (UTC)
X-FDA: 85095398304.09.3D8059A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7EF7D140008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:20:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDe8Ye5p;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786605630;
	b=m+yxgj7E3r43Fmvg0aUduKZ6LUBWtrTazXy4nj9/o5BJNY2PbI7Gl4USy4OYIhefdOcKCH
	6eJncp++vbS8yQRTVj9WVozdIPYkFN3zx12Fu+/YbmilFMFw8nfmj/AZ2RJ3jGj2sbe3Jb
	l6Kersari9AIt3b9hG9+MBAqL6yWJAY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDe8Ye5p;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786605630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGcEV6pl+wnhkUoYbI+HCVP62Cpluvw9xH8Mb9lAEKg=;
	b=iw3B9j7I9TVRwhrAtvlhPz+BRHyLZWByAKLt/3Kb1COTQQIWJiZLOFNxmmqozLWHjImejC
	2cha6PZui0lJ370xy7mBY7K6NtII7wnvK+zBM6xWcmOy1Wptmx4Mwm4+hI6UEV2IVE9kqU
	qsfNImbrsvv6jUZl77hx02L9PsviTcY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03A42600AD;
	Thu, 13 Aug 2026 07:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7711F000E9;
	Thu, 13 Aug 2026 07:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786605629;
	bh=KGcEV6pl+wnhkUoYbI+HCVP62Cpluvw9xH8Mb9lAEKg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PDe8Ye5pdrqK4Y0egAlcQN5IBirS79gYFFNr+GTbXIBDN4KKCJbtoJLxXfppWShGH
	 AVSRxpeE7gCCc72o72x7X8+sZfDBjMagyx++40zbXbwHvCr8ZHrnAHhWZGSy0GezHk
	 FKVaijt6X1rPBEA1aSj2nVyMD9WPvDrgDP8FT1jFgjbwsQxS2IRVm3zlSZYRD0fNTm
	 2vDKsO5idXcA8cMiYOvTSpAoMQNKSmXSYQ297N5Py39CuS3ykVpYsa8/skKgY6G80T
	 ARzyilT5g6dA5UltVrXyEikLX+6LibN7HwbNzC/p+IpfNPqgY7MY5eh2hbvKFZr+HL
	 yhfpLwxBz/FqA==
Message-ID: <7ddcbd0c-1689-43ae-bfb8-93894d2c9cc4@kernel.org>
Date: Thu, 13 Aug 2026 09:20:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/15] mm: Rename folio_contain_hwpoison_page() to
 folio_has_hwpoison_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
 linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-4-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805210557.1118966-4-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7EF7D140008
X-Stat-Signature: ny4pabs33ebctjedo631mwsi3bfh6jru
X-HE-Tag: 1786605630-168563
X-HE-Meta: U2FsdGVkX194DODGqvbDNA1JvBsdZOhqhm6mFiaURyEaZA7EeawoprIHJLTj5o6UEZaM6Mzesg7OLRdaXBCFPCnBR2GBqRqn9pPETQQGtBqCvukBAJaCbBDWfD/RK8fzm1iaPhJd+muD18jfVyPnhTHng4FevLuZSZP37kX80aqQqim+Jd14ObpiUY0i6bQZ19sBUUCvPETosK7l28ZgS8Dpvxgw+Kc88VBVwPLwiMdTwDrwJxL4/PgF+0H2jEsVCgmuH3ib9Fh+FpIDoq8r+g52Dbug2MHeawLHgTQVdbHmgaZQxB5SJXL/Ip7EqgvKleh+jD7XnRB0YFWCyupwnuP3/gTSlDPV69KmM3GaGQhFluICCwW7eRijRzBgF2UAdgpQcn+7gsR35fARsU1S8lCuu5gXILsCs03V/3wpmrY+LcsceceQbvtF3poo/WbBFTrj5hwh/hISJev9euUVXFEX5A0xPop0KrTdV4NcMTL16Qtm14GfO3o8CpSX6umuPKUSSp1g+LTXaGnVGHOYgILy2FJjgeUYw+VDKRHjaShLxUJKx2TWn/ks7nx0KoSMxS6mLkdPdtqUkdh7OkT3DXp1L51MUr3g0GveTkVZzHiENeULNHzlhEqbo0XnvKtIocYJd9oGF8krEEEtJ0rdKf6gpzm8Rgp6MQ8bP1rdyOc+3LB+xKpSf1GeHr4J3KKiF+g+YhFKYhzRGSQjRH5HTW6Q6pwJZmcAKtyF891PyL3OtddvdDKlJr4LHBRlAyrMiT8Fjk/SiRdJy1jFj7ivjVL7IYJcZx0620f8hKsoKbV5JlBtmNH+1tKRG+zMkwG1Lepx+19ioiD7u5fvfvbLEnbuRk3Urp4nPN53oCTl2qzCwds/R87OSOqi29PeJOgdY3v8ehuBme13wE9L+U41XZzN8xpTnVplMmzXaIbqcpH6fjhppyI6K/RoOTFzg0YSSX3ITth6j5CDDoUaQpJ
 TGCn2Mub
 R3ZfUX5jI/LiT9O3q9zSGkPEM/KQLvraohsr04cyAfOM/dNn27LZYQRvuSAsxpwo1YHzog+mBY6NeiCQyDyt2/o9zfJvLlPrCwKK1kQaYlX2/Tlmf6K3PK0uB5a9DsarA/KScEcda9nm2+8Acc/7mv16EqS2gZnYezopsdLm+YM3X+c955Bzc/93q8p9XXVz+OwqqFjLXyVY4kG8nO2wYPGPOHi9ugxhwAyeKWXkT68jpk8ZMShBK7sdP4+EgDCSNSfbdoWLEmRbpGYnEppMM34/xBKSyQzu+PIUBmVkilglJwfoAPBcTxWqsJbh3Ip5fOtA9yi4ZekGDtkAHULtL8DfvptLucgkiFm0TXdXUCV/JiHwwDZPA8tHIQYeG0VcoWFEPODbHjeeBZ4O6wmClnzasNrz+lafTpk2yeq6QuJoOolt5lAnh9M4StuOilWIc4qOFvXpY2pWexy4HUBIYW9UkFaQl5VDlfLagP7U8IfWxcY0fQLrKG4R5tMS8VnxDVC9FlLKyuqBsSTvbjauD4xYd3U5SGki9U0kSidPN8VMsUQUPZ01kJilsSH25SgKJG68B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
> This is a better name for this predicate.  Also make the argument const
> to allow other callers to be made const.  No functional change.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

