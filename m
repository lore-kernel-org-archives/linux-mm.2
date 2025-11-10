Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F16CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1058E000B; Mon, 10 Nov 2025 12:07:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8498E0003; Mon, 10 Nov 2025 12:07:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5D38E000B; Mon, 10 Nov 2025 12:07:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE2A58E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:07:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FDDD569A2
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:07:50 +0000 (UTC)
X-FDA: 84095329500.09.4CD9986
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 53D48A0014
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:07:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762794468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cFHa/2DW/5HTFE3/epI2JOFiwK8BPR9C/yyW9hwl83k=;
	b=XdSYJP/po/COchQpfpFSQu3cVi9c0RipmngGbpApEVvQsUsQ7mJYpj4tUcM98zQ/9Az9BP
	EYJW1ynElDlcfYWyqN/NR34sm28IY6W7Q51xU/QvCEHg5i8f0mg+eDiR6FKslCCDnJt8Mo
	ZL1PMxuvBvTNlYMekXBdHKeU9Sq7gWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762794468; a=rsa-sha256;
	cv=none;
	b=oalH/nX6wTJfv+lCUsSldmhz9giRV1QBbiaqS112rtu53KXYbmQFOHI1iiBXOifmW6scUK
	/avJaiJx6w2HKcJ0DFcBOFkrXrRwWUDyRr3tP8pVg4PyYZhLXaF6bwrtDYlI6/zTn5a7IL
	1wl7ONq2YEUwuE6R50/EOtzA6aQAeTE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D6522B;
	Mon, 10 Nov 2025 09:07:39 -0800 (PST)
Received: from [10.57.39.147] (unknown [10.57.39.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 305613F66E;
	Mon, 10 Nov 2025 09:07:44 -0800 (PST)
Message-ID: <5fdb6952-ebfd-4a12-b372-04229763579b@arm.com>
Date: Mon, 10 Nov 2025 18:07:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: Remove unnecessary __GFP_HIGHMEM in
 __p*d_alloc_one_*()
To: Huacai Chen <chenhuacai@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Vishal Moola <vishal.moola@gmail.com>,
 Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251109021817.346181-1-chenhuacai@loongson.cn>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20251109021817.346181-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 53D48A0014
X-Stat-Signature: meh96psm4gi9b65wm1itdc8gnfnc6sy9
X-HE-Tag: 1762794468-708605
X-HE-Meta: U2FsdGVkX1954lcc4TpvHJ0eyRqY/npHPMq3qt0lB/dVQAf9DAQE3kAZCuzM16I2mLH8AF2yEWwZtAm0IlWwxScMGnlCLDNWsQc12k9Cqn2K693Iju3unMqgorZgVkl4OJ2EzTp5gaQJzrYrRNz4N/juxtH5ZrlUQ0Hb/CFaVEBl+RRvQggUSqkMchQ+qmXw4CWka6nLoa5G3hERuAnarBrTafgvL2VP6aqINgZqfEX5XNrr0KkL6Bg1YnEEs9yXW6LbNnCbGiGXtz8pP1YHSzeWRkJ0NdScDl7acGZH/i6SY+y0PTbc5KdM/nD9rYospmo7rKITcL2O42f22yELJjVG/O+cQBcpRHHyR09qIzD+T6CDPv7X2Wro9jZ9xbswFP2wwVHR6bTWs+KFxZW5qCWtN/HYPQ+WiZlfvgxe+aZbhJnjk8Lzxq7r7w0u8K0Sa4IUnMeliVAcuAkfzZ+X2DKIBuRT39Z70/ZjQqr82asieL6Vl6F1bom3dWLFktfasZ2xr0xmcASRTULcCuNBcsueQvGUDkyDm4iYGX5wvbe1Wd2LHWgmfl0V4nUlwWa3w3ph/CnDMuwfxE7DYGkvh8CRFiKNKzXdK5WE+KKzX6C/FvqI6H9rSNYnqFz+LlJpKjKhpf6evK5kkWS3b0SrURCbeHNmuR8mvW3LeztQRPUak9pikTqQ3xf2W9O8Mzz1K7UWXVV/lraysCx8C0upnq3UsJFv1FtUYWYRJ34D/qJ29d6V8Rq5Qg39ig6A4H0B/TGOF8TocOiausIipD+iWFdc8H+cUg5lB/7Rb+IWpDnreiGkjWSwR3rddHBJiF8ZBf/qbE4KTd1Chs+YPQBlXYhO6duFqFOyXv0hjmBJ3NQhLl4s7YO3fsb5vTpHDoHRQSKvlpAMSACOHmF6zk6edrIqXBHlpy2x9XS2WJm7FuuUDE3A0P9bbnNPeuuS5cJHZhRe0OoapcdmJrlQAtk
 EV+V//OF
 5/RHfs/1pjzyFH5B9wdNHPrCRcKDo2JLYI6RUskv5JSFG5kTA4tjq5o2SXUX0uBl21A1kg29QTLWAIQoZN7M43mEB9Hh/9VwlLxN+1SmX6HriyHwxo7J+TVC0mUR7ffJT42IHulm9KXsL+Th3bA41f7oCEGpB8/34fsUa1A3mNC8hAu9GUFkm7sNAMCKBfiaiY/bTZrdkOL31iWnum1GSJoebZ2OYcvZ735xH+0tHKI7+UCi+SUD5e6Ya6HXBmCnw8J2sk3Iw8LriG4kgyF2pAJs9l1bID3hnQCb/2aAbO6od51Jie1f529VC3jFHODrBwV48
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/11/2025 02:18, Huacai Chen wrote:
> __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> as follows:
>
>  #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
>  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
>
> There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM

Nit: "needn't clear" (or simply "don't need to")

> explicitly.
>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

- Kevin

