Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27AF2EB28F8
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A076B0092; Fri,  6 Feb 2026 04:02:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818656B0093; Fri,  6 Feb 2026 04:02:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719F36B0096; Fri,  6 Feb 2026 04:02:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CADA6B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:02:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 054021407C5
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:02:54 +0000 (UTC)
X-FDA: 84413441910.02.3D93B25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1DA96C0011
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:02:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q1ubLa5l;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770368573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VxP1X4J3nFTdtOllsWa8XsYdXgacHF5twMkqXGv5UTY=;
	b=uuTB3I0l5J3AAsdg6gSECemiHLu6bA8D2fftXDb6Fc+BS1YebGy6KJwjtHFKguQfYp39pR
	sSXQpyPDWMVHbR3WXk3VgDxCNHOOBqXGMXUaOO9lFYUvLgSnAflmOal0fQR7SHe5z8JpZl
	lxg8LtjNxLWrndr+oml+xb/WBuL9EtM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q1ubLa5l;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770368573; a=rsa-sha256;
	cv=none;
	b=PR6lzAUws8tpxKOQzFYW07z85MON+hJ4WQ2HCsNKHdxfxHBrDRaLeoM0akpEKS+aLGH8Y8
	h/2sWgKP31gzi9vpWA6DVBKJU9EnCaSpBU95EONnFw+fAgCea5BlNQlqf0QOQTaY0givzr
	pmYOYiHoA6tfZILYJsEWOG0AFxERnVU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26CFB443C2;
	Fri,  6 Feb 2026 09:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9649CC116C6;
	Fri,  6 Feb 2026 09:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770368572;
	bh=hkFt2yH4MBr3yZ05qlX5GzMUkIFfehbRgX81ou3KaBU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q1ubLa5ljjzM9R80g5IM2NUqQJAAufrLy9Lc+SD9Xr1GdVYWVgjzYAmGZuRuxTgrq
	 1fSRP+UTlly/Cz4RVZ+6i9Xre+rTKN1l/ssJh+Aaa1Z3KqKB6F/HFBUF0Dglh8WWpg
	 Ymmz+Iu0WY8JftSAE4GKvGGZ3D88MdJBSK8MPOfXrUwKNdSjW0eR1AtLhi1lCWxH6W
	 j3oEVWjl02eIcgUnAt0SB5KrL8ebTO11DTyI5CedBhnF5qNPo3EgKVv32nRmYAx+NT
	 iOVkl1W5bG/FD/TIDLBPc4t6XExo5AfdTw00Ews+IzrbMYCXuc3jYZ0tw7nVExtg0u
	 mt57mpxM328tw==
Message-ID: <1a6d8295-e27b-4440-a367-af0432a7af4f@kernel.org>
Date: Fri, 6 Feb 2026 10:02:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: Dev Jain <dev.jain@arm.com>, Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
 <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1DA96C0011
X-Stat-Signature: i1a8byhqfa3wyk9gu61gh7x4es4wy5i4
X-Rspam-User: 
X-HE-Tag: 1770368572-163916
X-HE-Meta: U2FsdGVkX18aT+9gZFHxF5oYIxKzXXJlZ28MNKGt1Q2xTr7DSYvC47yxfWtWOENJ4B1wr4wXSndcpifv/BRnL5ZmsWtHooeqah8UMSUvGR3NJ/emwPMXoXCNA+6avCGZiWZAjj1khmEuammaoH4gZGFEAs1QvtYy7hd/NBAEuYiaOBktrni8Sy3pVqFhdFHR6brmvLJwnzznTVS9HwWShSnfLphSBgPC6lkph6fXXEvuPQ/+LtdTpp76oDVJaIKkSV7gbmIkO0m/emFz8+oNOHAYaNuI0Iw5rlXsi30aqgQaAoLJPjgfCzpjTx1tHrGTE9iIfed01nzP5yVwCZeIEjplTMv/ckzb5G2liUoxH8i8s8qQMeqvjL2rRZYwnFHfV8egWRwUfQMDXnkqLgpaVVvGqccQtg1N8SiLZi84cWHJo7W8v3o/1B6xp8VmoiHtmEk4YeiTSufRFRIkzucJ34IcVMFmo4zU3lEdCxnfETH6p3jhbrwm4liqKtem0YFTkfygGKCdtzRMOuVN28poX4m1LhV3goqgpDSbLqIXCS7xGq6cK4yfhSZwT3uylI9Y1fOp17MnK94a+/a/DFBx/uMB/nwF6YXb2WCnCngCxSTBVk4tO7vkf6ptBefuLkT41YfF6NIB5HIRoXgOFY4GNS/6ghQkqaTqCYVl7k3I9YzjTn/oyv3LYUO1Tl0bxvdjL8PoPBEbMufVWyWf3NGZ/6tv+kQzihCF8rbDR9LOH5DVKDv4i4CTwvSvdZZpLzDkQSkyNmwXSAh8rPcRVpBizE1Vo9F5h/Sv8/N9BoEjWD8ZECQMTsjdrQWJq2ZibfbDG72CD5dFd0CIyMbz6dFLNlOzHZNwmAnfQUdDvYCdnM04EnKw+E6hOgE86dIMvrebCK43mZNKFNxVJSy8qmjjU4KHR/8TBiSJ5mAKNK6TmakBGT8/iuMf/OquafFszLMyoM9o5Rn7cds7JqWjJpR
 W65mKn6U
 PI4fZGR5/D1H+w4dXaxNkZHIuHcCVG04KgT6TpbzH56x7GuVPaNDVPoDHQA6V0w7j6USL66y+VxQl2DWEEt4x84b/S9pW4Ks/u5d5il9YnbCXFPS4PR2guRAqAvHkKFKp1xuUmXFU1Dgb+LgicPF1NTukG1YqF8haFlSrHOJmE7wEL8LGSRKbVVdDVS0dG9mOEFhCszOKEl2hhIaswn7iXpAWrOZq59rvYWhXzT1XPk9dzEQdIoqiyBuORuAFHdqvyQWohibeTe8B1ZgyngufM3yrHg1Xx+eSUg0CffAESyEtDvAxyk7NroV8Ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 15:25, Dev Jain wrote:
> 
> On 05/02/26 5:41 pm, David Hildenbrand (arm) wrote:
>> On 2/5/26 07:08, Vernon Yang wrote:
>>> On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm)
>>> <david@kernel.org> wrote:
>>>
>>> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().
>>
>> Yes!
>>
>>>
>>>
>>> I'm also worried that the compiler can't optimize this since the body of
>>> the loop is complex, as with Dev's opinion [1].
>>
>> Why do we even have to optimize this? :)
>>
>> Premature ... ? :)
> 
> 
> I mean .... we don't, but the alternate is a one liner using max().

I'm fine with the max(), but it still seems like adding complexity to 
optimize something that is nowhere prove to really be a problem.

-- 
Cheers,

David

