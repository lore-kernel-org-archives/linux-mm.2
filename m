Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C68F3380F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C896B008C; Tue, 17 Mar 2026 04:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED576B0092; Tue, 17 Mar 2026 04:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DBF76B0093; Tue, 17 Mar 2026 04:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 476D76B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:28:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDB6E13B2B3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:28:06 +0000 (UTC)
X-FDA: 84554877372.22.00870F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0CF7720007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:28:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=refhG2sJ;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773736085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6Cq51ZcvU6GX565GyL+uxjoUVud3ApDOI6/vQ7+A98=;
	b=6EvvGvPeccecf/B7qvTz9AEjjgjm01aA5rZrVX/MvwD5NSUsCv/d0eYNLg3HZMne6x6u9P
	SdiZpMMJ9sGm0Y0t7P1YQsJyqJMJ7/iSL5zoiL6+7Dy0wUz0Gi9ZKpsdFCqtvuJ1FccDh5
	e4/8D35ihZfJV9p8Hm+70yliSlC6xe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773736085; a=rsa-sha256;
	cv=none;
	b=FIyxL/sXpAkQZChA419cJgJdoRoso/yreGH/UI+JX4XneR3RvqaudDXzP2iD7B0+ZNQ6pG
	tsa1RAYIArhx69gdr05BswBkz4ITsNVy2v8JOPkMOYLPYI/9uhubAD0SQyMpYcqv9Rg2Ms
	+XVpxfFTTD3fECbTWmdzmviC7Xl59vY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=refhG2sJ;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4670B414FF;
	Tue, 17 Mar 2026 08:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02901C2BCAF;
	Tue, 17 Mar 2026 08:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773736084;
	bh=s0mX9OKppXx1MLSUtDAxDsL4gxQjgUId5GHLf/L4xgY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=refhG2sJmhwyQ8hGpRC+QL1PYk1IlsUWSLDzCbKXhBNy3vu9wXDg2OMVRA0idpXAi
	 VY1102lBfwFuRL0DVDD/JzAR5AtBJh/1g1aPrlcRiZFF+RhjlGt6ea4xVTN02yttqL
	 ySZwGu/UDFHhj1wp1Bxp0+Vd4JK3JnIKlGvA7KUL3Ooeig/IiKZthfRjqUPgeO9dxG
	 6uRr5JHC1mtM/v3HG3P2LBkYL//Q0GuSDFU/ao9tO2/BFMM4n2P6PRmP+KDOWbUetL
	 KVpv12l0GK1Mp8z0t0za/6thV/yw9NLzN9gwI9Ad6NZiVqJt5MG3WzbWvebj8jCz8X
	 AoKy3tdmbdy4g==
Message-ID: <ed50e523-8834-4a35-8e54-06f3db89e7ee@kernel.org>
Date: Tue, 17 Mar 2026 09:27:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: filemap: fix nr_pages calculation overflow in
 filemap_map_pages()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 willy@infradead.org
Cc: lorenzo.stoakes@oracle.com, kas@kernel.org, p.raghav@samsung.com,
 mcgrof@kernel.org, dhowells@redhat.com, djwong@kernel.org, hare@suse.de,
 da.gomez@samsung.com, dchinner@redhat.com, brauner@kernel.org,
 xiangzao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <066dd2e947ccc1c304b54e847fbe628dccea1d7c.1773370126.git.baolin.wang@linux.alibaba.com>
 <a5625929-736b-4ddc-a8e3-30e3aa54df12@kernel.org>
 <23953888-15d6-4cef-af8c-be15ed6d6e20@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <23953888-15d6-4cef-af8c-be15ed6d6e20@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0CF7720007
X-Stat-Signature: jo6ji5y8kyicb9o5fjkcsfthfxfrub8x
X-Rspam-User: 
X-HE-Tag: 1773736084-784678
X-HE-Meta: U2FsdGVkX18ISZg4NAQ8xbVH+M7A3ZJk0h/kEkZyTZh9VqOvpTPcpBAGGaOqAk/MOdGjBex6kk8J9MRTu+IP8WNdZgMwbmNb87crzOYBUsIkvnmi+QTYAQiIVQLWNAAif42SB0MZHD4Zld4tutxZyDpLIiavnVPGufL4Fzuq1MRvGBuwzZbsVEO6oSEfld/sEESZrdOeNa59Bfea7+MKu1Ok8ncB53LLrhFmAoCT1Wf94kQf9VpcQC76o2vqBP1cfBncOCEBA/ei+yZsaqYrSf6oVk2W2zBeKNX9mz3iCt01iEdxvvbMq3RdeKe2PR9NDrKtV095AZ1hZmV67o1wlWJw0Id/nrtgamjzCWD8a2XpwaYDvpk2y98QJe6mtb1DRGFnISU+4/lMvfFe8SakoWTckNsL7mDBOZC0aPiInye0El3uBnlfV32ctj0HQ7+/huD3qWUR5ao23t/6YJD6YsVrxLtI5yBd8Du8LajcwkKmIwmdsisGl548mRCZMTQsJEN8cw1oLQromg9F6ESBfmx8wDrWI4U554u8qjZVVQpHz8ZG7ajcM7nez1WXdvHzaNueV2KdALhF2NKLUFiI4OsMDlkuqQXVN/+yyQ77cof9eZs3w/hLThMpqMg97w4P5cjDmWS4tLOZAy0e543fPguVTcjUqq9NMPqBHGkTb5LjeL7k+qXz1QNsmz+nL/Ak2mRL5itxbmfM+MZGQ2sP/S1qO3iMm6AMM5DZ2pDoVfe19MyusfsckeJry6FsRfo0ip7CPYGdBVcBofkElSLzSk69jO3ssEi0ySdqLlnQp70jNc7He5ja6lle0mwGBkboUv6rE4T2qaECxTpPTV1jhNaD4HTbP8DHj7xzcA5WY+zgqEiqfBy/J1wP3L7yNKVW5gjbelM7t8KRB22ZsBxbwPAUG5sWzagLSAHjGbC3x9ER8cRILKvYIxObJ66I3PX33PGdenLS+JF5MXPyCsB
 ZH9DQVyc
 vk0uAqLhB37mHd4hbjD6dNncuVLWHErwQwQ+cjZw8BMeg4zDeWiicI7Gsws7BXx5hel9F6P1o/0roDuOvPcDYYDYbVtAdIHTCjj1i+IkaDKngbgkAQSYPhrdOyqZF/2Wy8qpghd83LcV7tdQZcgLzhtjuceOjR56ngXi8HjRdP2JUHLx5hJxGsQcPTA/We2k4/llDUCrQVS43c0+sJBuVG5p68yvU4NqtFxpI4YRrrrjysmGtehsrVa8IvblgQXv0jztm0faufnWkgXRSuT669WFmM8fwQ/NMs/nLpHgQ7ck9Av1mnyWlz8InQ7r8UIS8rFsswCPLBbFzrRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> LGTM. I do wonder if we want to add a comment above the file_end,
>> stating that this really must happen before the next_uptodate_folio()
>> to handle concurrent truncation.
> 
> Ack. How about adding the following comments?
> 
> "
> Recalculate end_pgoff based on file_end before calling
> next_uptodate_folio() to avoid races with concurrent truncation.
> "

Works for me, thanks!

-- 
Cheers,

David

