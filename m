Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88641FD8FDA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28706B017B; Thu, 26 Feb 2026 12:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9B46B017C; Thu, 26 Feb 2026 12:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE27F6B017D; Thu, 26 Feb 2026 12:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B88F36B017B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:04:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 725E8C18FA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:04:13 +0000 (UTC)
X-FDA: 84487230786.01.8FBD2F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 74A124001F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:04:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TWrY/0Yi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772125451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbbKTdeaXWaU9necbxDM8fJqYsXvjH4fcQC0yJ7hmDE=;
	b=xJWwyXihnzLFa4rIEk9ETtjRV5i0DL7jE0oTTzYholsCMljR1yBk+anF7ke+yu1p9Yr9v6
	ncb3BORlndIcjxJ+Sn/Dgk25E9q09Ex3Dg5nKER/vKy5zSua86IOrZTEvBC+W9uvKaxucR
	zGqOSadpIAacINX/7QosGEfI8/hENJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772125451; a=rsa-sha256;
	cv=none;
	b=x2ooVZaJdSF105SxZGZ8AQjiVhdULwsEnS6y51anJPt6O5yvaqpCkptOUHkpWWZL5aLG7W
	hN69lxW1/ptqzAsyX1kV96RpBQkMIRQHmwfkDdbaeiQFk4mj0QtJpQ31JUt5V4DebUBU6n
	c5712Y9EGz2mqFiQKkCFenaZZ60j7uo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TWrY/0Yi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D43E4344B;
	Thu, 26 Feb 2026 17:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDE9C116C6;
	Thu, 26 Feb 2026 17:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772125450;
	bh=FDgvIDg/FpsyLcXLEbnFl2mr65ZhDFGjem66PFzYFtU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TWrY/0Yi1wrIkj+Ia8H5X2wEDClTENL0qfEm1jAFrTuJb+i/k7eUa+cPxl+d3mwRg
	 kNKQhrLnR3yR1BXYU8IijcyFmwDfqrfWkez3R9/9dJ3ZigDoY+rAk9QmJIxMc3Levb
	 SHJ/Gxenirvmi0eQZDa4wJSXavgzsw9jFxuy4mvR4lwBJwx9X1FEpiZnzRGAVBZZjA
	 vZSKhP4/aAbp3PxhPnzodL6LqY4kN4Ft1LcdggEFi7yQWc8sJZoBh2Vbndn47H4niE
	 nfg+D00kPBF6IbiNqzQa6R/42kW+qQOydZQbd+vkAP0mVco05lVkYnHBD0nVaHTRqY
	 JRrXTTvBNQ+zg==
Message-ID: <bfebf3ca-8c2a-4dab-9885-d061c9b79487@kernel.org>
Date: Thu, 26 Feb 2026 18:04:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/page_table_check: Pass mm_struct to
 pxx_user_accessible_page()
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org
References: <cover.1771845678.git.agordeev@linux.ibm.com>
 <68c2f6df2955033cbf1ccbd2b5c2816e72ac345c.1771845678.git.agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <68c2f6df2955033cbf1ccbd2b5c2816e72ac345c.1771845678.git.agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 74A124001F
X-Stat-Signature: xe9w7pxp8ihx1py5bwewnpw1ptp6mcqb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772125451-914006
X-HE-Meta: U2FsdGVkX19Ayni4KWP2SZ6rA9q0dc+qGGSQUPVy1wBp8IteDYv74trb0+FYaJ7G5Uum7waWBdbMh9MTXp1ly955iOYmUeIG0b0PzHAJ+SMOAL0jlq7arSro1PLYuc2d5oVoMn1O/71nDqiLl0fMFCSD1uADPB9WITJsVerEUdQJEqYMYg1ImAnO2Lbfk2tjsjbRc696cgnRZ5i1tqXyuDwxJI2eayTBHFrY3HeNxFAbdJtez6plwI4CeGxn8ExsxPL3CDLTKiDIeu+L21HGh7ECdsHCQ1Shi91BK18pD4wiTSGDWU7pWo3Avylj99DhWb6BR8TJh+txByPeB2zx127iltC4cO2AXb4i27YPvY4IRbFsx5fR+OrZi0uu9G9fpYjOWI8Afm9OypAIzvhg6tAdez4tOGAoBzJwyH0ivJivz55J8ioVVtex7nEQuITpUb+w+BCwMjSpcqLEASsD0rFSQ/308Crhp67RWC2w6Er+v6aGXjVAYkr9fbRjb6eluy3UATo5xHi2BD6i2oGdsEb77Rtgx6vsVOPf7zOLu+4VS7KFwl8PfZQ3CsvYZNLIWucaDljo1cCxk68UIG+gwekeF2KEpwpThkrRRhaFqO/p9n8BN7pGqjKbLc7RejJ1mIEOkMpXO/b5gzrcLot4T2Fi+AVSWyWCLCfim3/6Gdcv+RZ5LnfxQTCOcClAx75OpI1qhmBXnqv5fVWPRpqfh/iBtVV+K6CbbD1oHNNcotOVMIGDhJQJkAGYeo0a3ql5QDaiA4hqt7HmZln7Cu97udQGjNsrbIGkKJlgKk9IIda1qDIw+zzz+NdXkf/2u0r8OtDbylvMN7tkGDUG9kjCrB7vfegm8RPfGiQNI3SUQHOLHbao+WNV4+BwiV1cFXpjR3BnCggh3aVQjD/UsmwC7Tr3o8B8Ch9KTVxBQC4/RbOqDQXqMpbk1V+Rd9jceypiJJG4Gc1+WE5JEReg0k4
 6uBLlFLj
 GeOkk1RT1jB7TtovEFLwFsAoHCNZ21mZ31I+DcehshGSsSCatVixKrvD63XXNfZpO2UnlY3afcQ4DSnbhQPtxx6w0elAdkn7iitk1nEBGIKaBLXD2MFkETuVMqzw/aIWBWx/P0E7XXKTzPzqdVuTiq0TPMYxZjhOraKYqwkHIZQRb3Y/FCT1Z4MB6HneSDKLWFonyuo3/258Pa5M9YTBXRUZ70+7OejkAO9JVlGqeYIT8NvDqhAcHd4ayQRHcZWNgU6EiCArZvewq7J62eK6xHy/pkFJK48Ji5M+jxB0rXHhKX4Swlvlm4G6RKR9C7oiJbFH7NevulsBImAQO+aQ9DFvDpZKHzwtLEYZq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 12:53, Alexander Gordeev wrote:
> From: Tobias Huschle <huschle@linux.ibm.com>
> 
> Unlike other architectures, s390 does not have means to
> distinguish kernel vs user page table entries - neither
> an entry itself, nor the address could be used for that.
> It is only the mm_struct that indicates whether an entry
> in question is mapped to a user space. So pass mm_struct
> to pxx_user_accessible_page() callbacks.
> 
> [agordeev@linux.ibm.com: rephrased commit message, removed braces]
> 
> Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Signed-off-by: Tobias Huschle <huschle@linux.ibm.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

