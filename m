Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A84BDC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B21E6B009F; Mon, 27 Jul 2026 08:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663516B00A2; Mon, 27 Jul 2026 08:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C2F6B00A3; Mon, 27 Jul 2026 08:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 297706B009F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:50:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FE3D80704
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:50:48 +0000 (UTC)
X-FDA: 85034540976.17.F0D02F8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2D09D1C000F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:50:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HRxwfKPd;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFTvlvdE1tur0qQLevTMeY2tgQ94L5fm1/zyYj+rle4=;
	b=SNuFGk2DVVWtZWtVBR1bfamEIk+cHQQvWU4HY/JE2mdSseUjv/+2qfluBmK+7k2v/4gHot
	A1ufwFQPMVMgTUVR0yVRFGc/Cds4LEWsabSK8WZF/OcGkj6gm9MVl6evcEReZ2btBvB7Xv
	gysam2afkiYCJVZGh7AC6UScdA8vOBU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HRxwfKPd;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156646;
	b=NupIhTtA6nfoM6wlcVxT9Cn00LuG0EuF7NaH+faV7iaY5gVmWcxwXnkbuiLpvS4P3roams
	ikyJKLITytFIqRfFvcg+PgX1Tt9heYx54xeJITwnDf4+dHYgg8XRC7oSV+yxKpiY77ECSv
	QJqrDx+Ppke0TVT9cwyrTwkWRZizcuU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06793143D;
	Mon, 27 Jul 2026 05:50:41 -0700 (PDT)
Received: from [10.163.132.91] (unknown [10.163.132.91])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EF6F3F86F;
	Mon, 27 Jul 2026 05:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785156645; bh=8eH1R+SpVl0IPcdFmLZ7TX0yGZlPLI8BikiFdobOMJc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HRxwfKPdLUrcpcN/Vns7B9se38vhkvpnbgaM/qVNMKNELIr8o3Vb5alAbfvV6kFm0
	 AE3O+Np2GVMA1Uwd5U8JOeph3EwXL1yhDOcKjykSBvwkHtQrbaNJZrXQVaX7DaOEgs
	 NMinrvsMJSWOXOkXd1WLho9F2detIAfWN3BYzUMk=
Message-ID: <bccce409-e105-4a7a-b962-35905dc1ff38@arm.com>
Date: Mon, 27 Jul 2026 18:20:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 usama.arif@linux.dev, hughd@google.com, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <alHNjbiWFYXSPZtY@casper.infradead.org>
 <5ee8783e-4deb-48fc-a4c4-96b02d79a6cb@arm.com>
 <e0421ba6-82a5-4c88-b5db-23231c265142@kernel.org>
 <alTN0i6XgnI_eDoh@ashevche-desk.local>
 <alTbSRXXqNFPl59U@casper.infradead.org>
 <alUM69tP-Zayp1Jk@ashevche-desk.local>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <alUM69tP-Zayp1Jk@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D09D1C000F
X-Rspamd-Server: rspam01
X-Stat-Signature: jwrgxdas7mp3uc498g3roxrzuiqha3dq
X-HE-Tag: 1785156646-738838
X-HE-Meta: U2FsdGVkX1+whX+dNs0aF+oPuOteBlxl1El+BoPBaWReWXkUVnrnm/6L06c0+j9S4YFVTmYikBgA781wOD8/MrV+jMfv0mZu+GWbBilTK40FMxMngqH/4JMYAxaRICNq9ksLFP7FOaxyD9CL3HGWBTjDWEB/Rsp9k7gq7Xm0QYEfLv+zTD/DaSLSG/bjjyFKn1nNB2xGAYVJ0gQu/C8Qnia088LPDu2cVRXn+/YQxpBlH2WZVdBFvsCzp9SXO3pr4nOcIzY/JYfela7Z7zbnTjh2FULePm7Y7Yn4huEXPePk6ZBtvWbYiyJBUv7NzQPcP7tdJmJjO9i+nEzlHCUzIiBdWkWHL+kRtQZZIpJdtZ4HXlotMINzwizlkCsgz5fmy2mRvyJ639B3RWSR8D+qnMlHaICjyiTxubjLz9Pj1FjQQSQjxOuNmYnRN1lWoy5h0G18FCehwpz0L2LQhh1cd7LCeIt7ds7ku45lbbKkazs1TN/Ed/UXAx+FZqHJU6zXKyW48e3Q2qkmxq8ukfPJ2nuLsRRzZnySPp5t+vcbyxc3G7fOM5Ned1r0iL9mtQ1stdsxC16K7H0OuiQvaqAPzn5xCr7taczDCo/lsGKDBSjHkgVL/cPS2A5s/Vn3UetOld974tEH86Y/6FWLjShSpiitza2FdWJqllxzR82vz/rXG4RIZ3yjqAWDwodVTKWO1g+bj0TIPZttnuBep0DEvlOw0Rh2OQrtM7qzxfrZnTA8mfoBaF93bT2kHFBQUINaauhdl51Hu7UD3xO9kwgVo7EOwNck0ZvfNDpFh3x+VAeZPqvm/NydNxzmTHOYoLciRZszaDDjdlz2UlO/iWSJe2jS3pCX886SjpbUekmb6mcN3onS55qX5AsGriK8v6D5dLYP0AoHJvnW/rXUv2EZkXOcSP808Ic/aTmgDD6HWftU7yCTFlPuGxsLIYoEMA8ZXOf4z4ioWtaVidIMA+0
 87t+ztn1
 e3LMwBV0D0FXPEf+mSkQD+VWghG2Y4NnezGAk1Lk03hWavVMtrSpCIoXnv0AdWC2bljxtAD5wRN0XMbk39v1hOgD8j+1pAu1cNN982l9Q4yz2rj+U9Nr05Odcq3xx++7xvtPgjwlssyJfmBukmeRwhEDtTJ05aLo5J+BM3mTNu49qvJwR3swgFrPMB8tdF6p7I3BMLsM/3wZY5ZYB8ZRpbykQ4K6rXzbJprCkEfT7/AkITaV66Mbcr0PYWjMBdTQ5JHOzIia3jmm+JXOCf3VnDuctmom6tA4krJRKjGyuhWCUKsNflPaCovkGefqqoj5g0yCW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/07/26 9:36 PM, Andy Shevchenko wrote:
> On Mon, Jul 13, 2026 at 01:34:17PM +0100, Matthew Wilcox wrote:
>> On Mon, Jul 13, 2026 at 02:36:50PM +0300, Andy Shevchenko wrote:
>>> FWIW, we have hex_dump_to_buffer() for that already.
>>
>> ... which doesn't eliminate the problem of allocating buffers in the
>> caller.
> 
> Right, for this we need to integrate hex_dump_to_buffer() into %ph.

Would not that create more complexity which might not really
be required here for simple pgtable entry print solution that
would probably have very limited number of callers anyway. Is
not that reason - we did not go for the original printk format
proposed earlier.

https://lore.kernel.org/all/20260610043545.3725735-1-anshuman.khandual@arm.com/

IMHO this should be left unchanged. Later if there are more
users for such prints, those printk formats should again be
evaluated.

- Anshuman

