Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 252D8CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0436B03F3; Mon,  1 Jun 2026 10:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860F36B03F5; Mon,  1 Jun 2026 10:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79D476B03F6; Mon,  1 Jun 2026 10:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 686516B03F3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:57:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 273DB1C0739
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:57:33 +0000 (UTC)
X-FDA: 84831647586.04.7594C37
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E9D518000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:57:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mUNCUaKs;
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780325850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+C0fp6umJRU33kVMhlbvMKXHYQs58njskwsCD37+g8=;
	b=4hOX4UO7RUZ75KXeb1/2dGk1JdCXR4I7ByZmZEH/b9uYTNAeur06odPHeJIpCqVn4GpNg8
	zsbdTHn4QUmUa+GM34LyWipKdNxIbj+8V71yjRTuDox8aKyAdAdzmdc/mRkp7Sh9TreP9W
	JGhVd25yOcD6nGjLdnh3dmLew6iaRSA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780325850;
	b=jhHGNVqAZE602k+og4FfKFl66EzNtrBGMYboRni5jadcHgpRVxk73cRtqNiGh9USOrjaSr
	pOkFyMo+wWlnho1w9cJEn9JJGXPMFHaXqisvrjK+Snmpou2dM0e6LKiRGK5Qff2vpoCUFG
	bKJohVoDi01cL/peyB4Od1XV7MEIv7o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mUNCUaKs;
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=V+C0fp6umJRU33kVMhlbvMKXHYQs58njskwsCD37+g8=;
	b=mUNCUaKsEO186WSEPg0WHIjTPeVuRtl56H1eHuwC+4GoLSqg45rzetb6RCzivz
	CcVqym+/qpjZyq+DEDC3jBf1+EBpS+tW8dydtzHKdTS2On6FUndfWUy1VuOzhOWi
	od3JPn2xDYqpcKrosAuBXTd1rOMsa9Xpvo/dgl6Jm5uMs=
Received: from [192.168.5.171] (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCnVF69nR1qOU9UAw--.57248S2;
	Mon, 01 Jun 2026 22:57:02 +0800 (CST)
Message-ID: <e009b7d7-9008-4705-9255-c05a8386252e@163.com>
Date: Mon, 1 Jun 2026 22:57:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/shmem: introduce copy_zero_to_iter() for large
 zeroing
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-4-chizhiling@163.com>
 <ah2HfH3jJZDiNAQc@casper.infradead.org>
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <ah2HfH3jJZDiNAQc@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wCnVF69nR1qOU9UAw--.57248S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArW8WF18CF4rKF4DGF48Zwb_yoW8Ar1kpF
	WxKFnxCws7Ja9Fgr4xZF4v9r1Fv3Z5KFW8GFy8Wr45ArnIqr90kry7KryakFn3ArWxC3y0
	vF4jv3s8Aa1Yy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRvJPiUUUUU=
X-Originating-IP: [58.20.13.92]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3B54Fmodnb5EoQAA3d
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E9D518000F
X-Stat-Signature: psggb4hb3mn5uedx4515ccqmybizj7sf
X-HE-Tag: 1780325848-45883
X-HE-Meta: U2FsdGVkX19amAbDPx6GUnn7bMO+O+UBKZgU6rRDuXC+gNX32tiTs/YRbS5SdKJwpAmfQnp9A9cCZOo4AouOrg43GdGja9HKaIUywwziU91ZTKLKJh88424mGltMsYKOOKi2SoySW74pqjgO37rjszP1HGQokFeq8f6EYK/QvubmTHxl9IOlgu1JtdH1dt/r7aOhvORLqVLbTWTU4pMFYnPFoK7yp80cUrCMOjS/MZkvVGhD/9/SUHeli7cXtLwEOQ6qYSRHcqQ/7OCRpS8gx3wT2k7QPhTwS/n3+4O5l0FQownc9iXiSPwZT/bZI3yxbr1KQvUe+Uu5ld9SxOwA0PHYCeYG+HcfMLVvTI3bKPZNwVJcryKFb1bp6iGgkTUAJqEOWZ9FWMf00KQ58GosTXFr9hwDeH7KbSDFlToIOa+fvI9DZKGA1Y7vpNJImAMisWjiSfpbTYxUBX1r4KEU3ABGxF89+WqeJOZ1eO/S/T5uCFGplJwji3C6mM21zmrxKCqTKUO0ktqsQfq1PWpR2DcAgJXXm+VgWPpL+tVIntMQj49tqlkLwXvo/zH2KgkfJfGRlxL6hsM2SxyuITSfKZv+pgNmJJwSBcHraNyzYHLSWI5eDpxfkB/12hBXjrHFG7LfcJItXmwz2+lALj5IiSYxg9VlE9LCWaU7LK9Wms/6b6jeCVeb/FWWwHVE6HSNoYeYDEsQ8gm/3A7QkNXPue0zviPxF2HzIKOhLdpwNS8PYsgpUFIHotfhT2jNrmeRB7RrJerNiAHuC8eBs9qrqIDJpsurxalm74WRQyzzT/4pBlfUADzTAEhXOJTtzRGjy3FtXGYc4y6y8Mj3fEH2tvq4r17yai460tLOXk3BbhxlB6l1uxth91uuf1ikMS7Fl/FkDiTsVSwb9JIxRpcVzaTccV01LpUDUrsF1C0u7OZlEsxQwLOv3lfzJPCDDGIxo5patEb4SxggrvIRCB8
 PW7UumZB
 zQIMLXTcXYWWgClBNejdSSnh2AcnOFoq2G8W0psAfABDTu75bV+apV52/m3dBz9zi28P+cU3hxaUYP0CqfANzaMngOzA50Gj30wKsxmBYVwvnKRbEu3JzJLyZxWNUJoHKc2jVF8wagaeA0r1FKWA6pY0uMP/fYXrEfqtCoSrLpg5+QJ9doYSjfw8Wz45oj7f6qXaxKHikR2EUX5UFpmakZlphWKNkmSmQPupNJjE7CFZ2g0fPjrR2uBLbW6zJnJXhuTt29wxzCIqhjZOyGjKRkMVaOi7NwziXQtsbx8DjTegoSic/O24SJLp1TOme6+eExp2I+IrBLxBAZtzxK+Wuuca2344gL/KR4IaxbsozVJQ1NkCYP1e9ZMZG30GCZfdxxlShRIo46uhj8Czu6Elkk/GRjcwYRwo3qPM8x/QmHiczMZxI9rysKOj67g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 9:22 PM, Matthew Wilcox wrote:
> On Mon, Jun 01, 2026 at 01:57:02PM +0800, Chi Zhiling wrote:
>> Currently, holes larger than PAGE_SIZE cannot be handled because
>> ZERO_PAGE is limited to a single page. Add copy_zero_to_iter() as a
>> wrapper to support copying larger zero ranges to the iterator.
> 
> I think Hugh put this optimisation in the wrong place, and you're
> perpetuating that ;-)
> 
> So perhaps we can start by moving this optimisation to lib/iov_iter.c?
> And then you can redo your optimisation on top of that.

Sure, it's good to see this optimization moved into another place :)

In that case, I'll assume iov_iter_zero() is already well optimized and 
drop copy_page_to_iter() in v3.

By the way, I assume the benefit of this optimization depends on the CPU 
architecture, right? If so, I wonder whether lib/iov_iter.c is the most 
appropriate place for it.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..112cae9f9e4f 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3427,19 +3427,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   			else
>   				ret = copy_page_to_iter(page, offset, nr, to);
>   			folio_put(folio);
> -		} else if (user_backed_iter(to)) {
> -			/*
> -			 * Copy to user tends to be so well optimized, but
> -			 * clear_user() not so much, that it is noticeably
> -			 * faster to copy the zero page instead of clearing.
> -			 */
> -			ret = copy_page_to_iter(ZERO_PAGE(0), offset, nr, to);
>   		} else {
> -			/*
> -			 * But submitting the same page twice in a row to
> -			 * splice() - or others? - can result in confusion:
> -			 * so don't attempt that optimization on pipes etc.
> -			 */
>   			ret = iov_iter_zero(nr, to);
>   		}

I'll include this change to v3.

Thanks,


