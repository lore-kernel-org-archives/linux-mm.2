Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D065E7DEF8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF40A6B00B9; Mon,  2 Feb 2026 10:41:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2166B00BD; Mon,  2 Feb 2026 10:41:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4906B00BE; Mon,  2 Feb 2026 10:41:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88FDB6B00B9
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:41:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A87AB674B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:41:01 +0000 (UTC)
X-FDA: 84399929922.30.E6CC48F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9D3B7C000A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:40:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J0h05WV4;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770046859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wwvwumxkWk3oj0OUR910KFvR5XWC0VMqIFyR6jmeTY=;
	b=Mdr8UBB+HLnT8X1meeg3ERt9BUhHbJUfAiHuYMujWmgBSnZfWpsXrB9nuIuC2V7DqSeWe+
	AWND69jnsQ+BS44TsrMZNlK2OoMYnmqTPAJx4zBDXRbsWIyZRuYV6E+Twt7E+84NJ74YVw
	1UQPfy3/GaCfc2YJ/UTbCVCZhYByOVo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J0h05WV4;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770046859; a=rsa-sha256;
	cv=none;
	b=aA6pOk4Ma79deEW4PT+a0CgtA09yZ0IKQ4N4f7N6VIZFFjbvmsVXhNG5QSS7oNyKSqZ3EG
	MOuClxGcdN5agQMWdvTqPgfF44/sOu5VetluRDRJtXLyxbSP3/8n6Z8mvgo7VI+8+Tje9u
	uFa60xB6JPxf+oOch9RrI++VL/TC2Uk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 975AB43A4B;
	Mon,  2 Feb 2026 15:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C34C116C6;
	Mon,  2 Feb 2026 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770046858;
	bh=mPPd1cA4doYh2xX68yC3ZWX9GIRYOqIvn4ugLKypUBU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J0h05WV4xAlrf74pPzF9RypyH1Ox+0R/8hgXYOER8TNZe/Frcj5nVmdbtiftKURLi
	 Y0BgG+tnaAvHKa1ZMKK2Up8ByQJhru0RGr75emm8BBL9JDFGR/0mWYdHxPxFAoeeW8
	 yA04NOiJQAjnTjJfYbNQ3NzhPDNnK6S1BdQSyxTSa5ON25WUPwt5DdWYRDGoi6aflM
	 HGK907ojPQ+Yx3FfKRvJiyEL4Ti8Gnp14Z9JXzebnGT7euaY6fgTsHM7UPU6yJLOZw
	 3CxMtfhunXDCUMCAOCJ+9xGVZGjvP34bo2M0HltNobhxwYzwhzVb5JJJp5jxKc4IGJ
	 fkFoZr7Uly18g==
Message-ID: <f2014bf5-a4d7-489c-acf3-3a3339c030bd@kernel.org>
Date: Mon, 2 Feb 2026 16:40:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Question] Dead code in copy_pud_range() for copy_huge_pud()
 error check?
To: Ingyu Jang <ingyujang25@korea.ac.kr>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
References: <20260131172854.3370590-1-ingyujang25@korea.ac.kr>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260131172854.3370590-1-ingyujang25@korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: wfmkwghrh1gdn1aex3rixeshbgpwipzj
X-Rspamd-Queue-Id: 9D3B7C000A
X-Rspam-User: 
X-HE-Tag: 1770046859-679823
X-HE-Meta: U2FsdGVkX18TLkUYuDwfORYC+Q2M70phvrQ+t3TaFBGWydGP3whO9iewhjFiAb5DVLXLfX9WJswF5Rs9B58sGlem5lnZi9KSdA9q4PMFrxv7tyvsV23X7KFsMKrbCdEYUtI3RPUNrdhNsYrG4eUxc4+yObQMwFooC4J+5idAIeL7QevzzzO8yytdp9u/dlO620Yeh1A72x5Y/bVzWbEf5Z/tE7cjqMMO6pfyh8C2Kd/OMR5Vogpdj0TaeQR8QbeLk89O4B6bcZkzA4iaXgEcaTrqW6fq7KsLTQ76qfUMw8ibfQKurRXxQtudBhHa4GsoKnsMOa+aCQ/prR3T/4mwy0ckNQLaALGWxXCJ9KoNTwcFRKFugk5cKpgVwyKEnFNb7hQPCmjmTKUkIecdWr+Ip3/hWLo1jIQgD9QBip6xTBdDW/Mm4d88aH3nFwUsw55Eiy9m11WDtw7jhgpnCKmN4dswtAVL9ADBM4LvPv52abNZNSC86/kodr7IiQtablFSxG9KV7gba9PpCtyJHfaDUAJNbWmt3oE+mU/E7Ov5L6sXaguSsee3rVsYicr/k7Q89j2YP47E1ioxOMsGZKe22FRTd057UVnPFnPG/Q0sHpzp9zpzn8Yt01xkIb7EUoCRzUOjnCcpNzYM1WFDsuLe8zESPlt31dea9+8UEu93YWaXjXDlVcIrKozIPJmaJu3l6A9Ay7ntPjY78rK6UKhi0Qy7B2/iEyH7fbe+vhTCLEfvy/gd4kPq6Tej2u2wTo9UIQUz7knp8w3Q1t3GDx1N7n/53DQKj8nJ4RXQEeHazWh4QaUuXZVXSWCX5cBmPVtT0SVfILaQrfG+zFctlKQqcVhgLrnCwSZ8Ge+kg5UDSOoUXM1IBgLzfSOqVxXQBalhsunIR33V/MBFr24+GWofA7wScStiNVPBltyCa567F7LFoHl1rCikoNj+gAKGYz8l+DLoyoCMseYQUAxDKcO
 ai/NAYZw
 mXNkGkljkjSnmmw7XnVsGLH1Xk/Ia10tlOTbkmjntx5faPiiFYKAEAl0LlkxMzle9FFvbzM5w4Evukqfex5dwgPYNfVHKnVAPpry1Sfsf86yOAdMkWPnVJJV/rwYoyPswZmuCIrEBumX7NLki8oIFw+fVCCiqgfJ68eYY2EJbmGDXMq0fmMaCoP1SE/RwIptv/mdQJhAVcBJBt4uwpO8h1LlAwyPm/RKXyQQ7ko+E/SSfA7dETjizsEejMEYokrhVW88oVtcvwr3SlauJFvlQYdBBDe/sgY73iPBj6Hja3zqYVtLP6g8PuyMyyf/9xHsgqMA/TDGcg69lWGj9FXYUMbJvHrNQPD2ArXnL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/31/26 18:28, Ingyu Jang wrote:
> Hi,
> 
> I noticed that in mm/memory.c, the function copy_pud_range() checks
> if copy_huge_pud() returns -ENOMEM (at line 1421):
> 
>      err = copy_huge_pud(dst_mm, src_mm,
>                          dst_pud, src_pud, addr, src_vma);
>      if (err == -ENOMEM)
>          return -ENOMEM;
> 
> However, looking at copy_huge_pud() in mm/huge_memory.c (line 1966),
> it only returns two values:
>    - 0 on success (line 1994)
>    - -EAGAIN when !pud_trans_huge(pud) (line 1978)
> 

I think it cannot currently trigger, but likely would once we support 
PUD THP, see [1]. So best to leave it as is.


[1] https://lkml.kernel.org/r/20260202005451.774496-1-usamaarif642@gmail.com

-- 
Cheers

David

