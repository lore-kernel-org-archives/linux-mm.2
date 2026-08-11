Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8AEDC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4B56B009E; Tue, 11 Aug 2026 13:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84E86B009F; Tue, 11 Aug 2026 13:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C056B00AB; Tue, 11 Aug 2026 13:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A28776B009E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:25:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34EC940179
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:25:29 +0000 (UTC)
X-FDA: 85089665178.21.0BD3764
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id D57CD8000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:25:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=HZJn2qbX;
	spf=pass (imf30.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786469127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+BWV05XO4xsqcbnbkoKMlIwrmfz8Tu32HRZx+hIv1c=;
	b=mBKMBmYWoujW5u/gG+8S5ORoXVghEuN9Qg2FpE4AW6QIyMmg7jt5cmIBbIrMA5WZ2Xms0a
	EiNd5VisvAamYvYPlgKD599FG1zXoBdfdW3FHWBEc8W4sKIOflnGaAuPGBATtcKYV5h1nS
	zzxw5FUO4FMIsjkS0bZCvjAl7grJ+9s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=HZJn2qbX;
	spf=pass (imf30.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786469127;
	b=oBmG/Ojx8sniK2LoywKRjmzk/JNKHcbFE34gbE4t+tVatgltTBUYLbAdR9WLANv48oVrrh
	VEM5LcSobCWSwtQrqnUZ3IxmSsnMSsfoU8WEyPQSHoTaFneW7wDXhzXRr6GwR0sRHHbfzJ
	yNY/C1m9QV7CcPCxHlLf6/AUHMO2vUA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=L+BWV05XO4xsqcbnbkoKMlIwrmfz8Tu32HRZx+hIv1c=; b=HZJn2qbXUgzXXaZEP+9ipj9RAj
	YLYbtlaS8m+3BUwE2mbVH0SojkklOwS4V3j1bOZMvGXSQh8U42EbS3jKyyR+puJmzICy3x85QrFey
	+roexCs5I/qjib7vVLNsLeRI7+1TatSLh/1umZImbSusRSorqAOp3D53E45Xm9wRNfsqiXiuNGUyY
	CTTuQZpgwVWeTCrSsXfB2I3uaM2cyOB+B0tEODRGz176uETl9X7eUAg2138AZyVEEqRDaG0wJlSLS
	z3mFs0IneNZFyGffSHgOf9edw2SRJyoAKui/Ii97qbFvxY12IyC+fVPfzhUOe1F6I2l7u5uxx+cx4
	9qxd9/Xg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtqE9-0000000Edny-0p20;
	Tue, 11 Aug 2026 17:25:25 +0000
Message-ID: <e7911812-9b99-4f94-be6b-597bf202ffeb@infradead.org>
Date: Tue, 11 Aug 2026 10:25:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: Tree for Aug 11 (include/linux/mm.h)
To: Mark Brown <broonie@kernel.org>,
 Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <antIrd2ds2OiEsl5@sirena.org.uk>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <antIrd2ds2OiEsl5@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oscdnfs8yu9qb818nzdsdkxu9nzjt37b
X-Rspamd-Queue-Id: D57CD8000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786469126-377782
X-HE-Meta: U2FsdGVkX18hSt3t8C2T59SpiY7wckLURm+CaA8LZCDy9nRM9iqjn+MTYggePW/tPw5FffKZEuGKzhwoPVz3SxyRunb49I1axFFnFrszVTE0o7nomCiA9Kr8BgxHGyxkj3qjijkMcx5xUAj/JW5Pz5qDs8wuxzwyGGXf+Sh09aWjMCmYr1DmMUK7pXpC4m+UO1VmeRzqqYqXDRJS+bF+vz4oUyDat0iEakxP513naepIcwcKxrU2GRN6xIPL0bauCTceHWdXTEGr3+CBawdmukL8QfQpS8/i3kG7BVO1Fbgv7z/+9rbANcdm0UHV+ir2xYasQNg5k24sdSpCUXQJr4TnJJYDcAmJJjOxKro5IzChZDUwaHxqBLe647FkpoTPXGi95BrbycayMR4uWGyNGbH+WXXDumCJeEy+J/krosr55I2+Ts18WY3gbc4HTD4AcphGzYxjWWQB+kcB4yLtefRIMyyEQaKsJL5Il9y3TTPeta1eFJR5UEkGR2i9bfQJwi2CYPvShlIAQpcGl+F3mmMX4mVOrtrlfRazhuAUwS73+hV6hhFUT2kBUe6AQwjCaFeQ2qoO8oLelyUn9rxbqKhRbJ+ez1kW9pVK/LVm1nRcc3pVKKEdd/EFp+0PFmWYRffM4/rK9oq05KgFVqSIdsBxYFJ0oQ9dTsOcoq4L3mmO0BPiZMfdKzP39+e8Zistkz8WWEUU0rqQUN8BGtVI5Je0Hce1sxR3zKIuFKOwEt/Vx42TRGvdZMTBhGdWIuklbXZ41zD135zrfxlvx5n/zpqg+SRA4rGGzB9D+av7HqZSb9/Zb0P1yT0FskBqhhJ/13VMCZZxoDt9TDjZIlz0jNO+YAfzSaXwfR7XOpZNKAx5aZoCshW8dHHhFrnF1E98g0unZRY8lN8f3qH9+LLM8rJ0ZejiBaWnNVZNb+IV1TO6Q864rsqDDNsXHS0irLUNR7pGlUgwWKTmza/JDJI
 ZWFLbl6v
 h7jxPMXskidpskJX6vDuk0lHz9Br2wWYp5LucxuD0a96Oe+jKB7QNZZTHZ177Us1kYvmYwe7qOM+VXZgzDuoluY5e8w50mUf9/exWrxcfR1k9ev9zI/yNhVNw8kiZOC7AGSap7C7FxRLxrOcMO9FT+ytPJAkNbn5OkWLQ3HnMrLmbn3E4z6gHD0sVAqY9o5rT23ALzgTfPKww0B6HqxeV0zv56yir6WDE3HiZEHpLqQPWyIdSba4oHV9CXr2FyAqwzepP1yocwOZ2Xewq7wzUDNaj57T4E4dwIdBt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/26 9:07 AM, Mark Brown wrote:
> Hi all,
> 
> Changes since 20260810:
> 

New 'make htmldocs' warnings:

WARNING: include/linux/mm.h:2326 function parameter 'vma' not described in 'vma_is_cow_mapping'
WARNING: include/linux/mm.h:2326 Excess function parameter 'desc' description in 'vma_is_cow_mapping'


-- 
~Randy


