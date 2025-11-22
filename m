Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B31CFC50C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 05:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9015A6B0012; Sat, 22 Nov 2025 00:18:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1706B0022; Sat, 22 Nov 2025 00:18:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0896B0024; Sat, 22 Nov 2025 00:18:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68C7D6B0022
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:18:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A323BB33C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 05:18:16 +0000 (UTC)
X-FDA: 84137086992.24.0654C57
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 02BE5160004
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 05:18:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DcFplpsW;
	spf=none (imf08.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763788695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c0gaRBfWvn8IGRhby2/UXuk4IKDiTlivJjHOE+H2YDs=;
	b=7pGgy+UUaFgQfwCJOaTjLgtGEpaMCE3qTwpzGuVMuz7BYFuzFTC/K5wBmE/nSAfmEKjFjq
	C9Pv+dURe0iiojiIQ+s7w+0dJ9OEbF4CuNFm2JC7z4aCV0ihF9h0FTdlOEDPNoEs/w6k+V
	U2oteHx2vGPaz2MpvBRyJMdhXz6h334=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763788695; a=rsa-sha256;
	cv=none;
	b=ekOsDMthCVGmZ/xB9drl8ZRjcxixK4ujWQMd0WgUAalGQgzpOL4nS3N8FIwfG5vyeOsjx1
	7MUIg+60dx98YOH96m7nXd+7V+X/8DkSNxH05HTzi3UF1mGZd2wSN0VgZKt5lfYewAGPee
	sexROU1fNk5ywQTHMixOuREhRhKOioA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DcFplpsW;
	spf=none (imf08.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=c0gaRBfWvn8IGRhby2/UXuk4IKDiTlivJjHOE+H2YDs=; b=DcFplpsWT5k4pYl9D1693qDcog
	qmhSlaUvFfSwk41c70YaZXY854MFLgRL6pV7U9NIziMzUGyNYq8Bta8WXPS9BX/dn4MMbeV/t525S
	vZpX7WNOmG9QTlvAl+3djNu6JePghgOBig/SDgT4h74RITKZTZ00GJRth+gfiZLYoLQr+TrXlil0s
	cJuUDOT7S0sS+cylMa595K5U3mNKhcHsGhvF0EG35nZZLST5WYsio9GBYxpD5IocpFGmZIkl2i3s2
	wkhn+xfZZgC0D8+ihsr3c9g7pgSuNEqniLFsLWQ8IEl723qyupMikVdo9xngVFHNkDrfNA8t4w0zu
	/mWmLYzQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMg0d-00000009HED-01iW;
	Sat, 22 Nov 2025 05:18:07 +0000
Message-ID: <af7b6cdc-c0a7-4896-ba6b-6bb933898d37@infradead.org>
Date: Fri, 21 Nov 2025 21:18:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 2/2] ras: mem: Add ACPI RAS2 memory driver
To: shiju.jose@huawei.com, rafael@kernel.org, bp@alien8.de,
 akpm@linux-foundation.org, rppt@kernel.org, dferguson@amperecomputing.com,
 linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
 leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org
Cc: jonathan.cameron@huawei.com, linuxarm@huawei.com, rientjes@google.com,
 jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
 naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
 somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
 duenwen@google.com, gthelen@google.com, wschwartz@amperecomputing.com,
 wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
 prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
 kangkang.shen@futurewei.com, wanghuiqiang@huawei.com
References: <20251121182825.237-1-shiju.jose@huawei.com>
 <20251121182825.237-3-shiju.jose@huawei.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251121182825.237-3-shiju.jose@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 02BE5160004
X-Stat-Signature: x86ffaxsa1855p7rnd8b41qhfyn61rix
X-Rspam-User: 
X-HE-Tag: 1763788693-519780
X-HE-Meta: U2FsdGVkX187SCXYS/SJtZSp62x5rONa50EUdEvUN7C18jUazpXYgteiMjWYmow0dT9MPspRK0R+JtoyrN9bECvKXdb6SwVlHY5xRD1CdRoPCfDmTCzKHcP3BO77EwvvLW0ulEyHrL8CcrxSR7zoo4CK2pF38EkH4SB1YhmkXcyv8M4+F76TNWYNen39wytqJ2piUailZqmrr8D9iH+PScmyVz+kajGRSLqAariWgYgJafPCqWrIss7STzsySAmVnQ789UW3VA7OUMDzMGhJdiP4me1oMjefu/EFsoPrf0TkmanXxso7wRWcicEXGQEkChEyhboanPNt1AlpUu/+eEZ8+SDwsIOVFQ6VaBJBFDoLhHEMauCr0vFRj+JXvThmIiA7MTiygy+zUjk2t1UzKpuou+6wRE3OwpBVSmtIGcPcG09ruHAw9o5pzHcyZyohXkX4GuREP19jRnN8qrm4rsVGtQRzcfglofQGTxBN7Q5JaYr3D/1lBt1PKD/iAwcBZZXMwYR4/Mm04j1mzjvY4evysB41JMpQcoPQxnKr3gIWDPXroWZd23vrZF8omvpt8uCxfBJZ9NlfbnEkzStHnzrAKqPAN7nIDoh20fdYz4OLTjcfTAOvjoLhFt2pc3dZ9/iISAV0VQYdN14EuN8rXpkEUmzmkA7ehhn90dtIm31Qw4Xx3PYh9ObpMfQPVyBQaj/XMndQN6A5T8fJF8tjkym5QAOHYiHuSCqTBPuz9Wrp653ueFZn+S5gPWT+4UylHJLY6KNxWMUT1w9LgiXl9vXf8kJqbwv7NeSAiBSwuem/TgErbzHlThAbNWkTjltyyEatCsvMEFVgSDKZ66cSbxiy8poEZzl+2F84prAVLDfhNJ9OKWr3U54soSTXn3n76wx4VB2w0AhlGBN49DUKZdec2VTS/Skv34ShRHpslUZVQmB3ARgV60SPIzoL9yUQd4CJTnF79iEhfI1E0zr
 q5bbt8Ew
 29/s2rDnqYyRw4rGfZ1WkOI7sDTX40DaoiFquWNgRqUhMSL/TfDo6x9I9MT/iB87pqtYJV95E2n3xkUDhT8dGcZr16Hyc8RcyhRUJquY67QTh5UwfXRI+WXNH5EbSnGPoaeAwb4F4nl8TE+yzJdeqLz1y3f4BTp5xbmwSCooOvP2m103n59d/c7drHgwX+y3dMA898d4lX16RmghzC8m6rRT0/Lr+26/IBCluoMAznu4QVm77+gp0orKeBzVjVDM4S65LwGRdH9WcDHuxQ07o64/7kkINj1xuhPJaP5SDvW9zqYpSp0oihHv2hvjmbb8R3OEV3l7GecYXDcNNl5AAU2PiF1h1y1zJYGvbg31En7oqQvEaeE+5v4dyBhbwVUUeAe/DWBbYT67xxSo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/21/25 10:28 AM, shiju.jose@huawei.com wrote:
> diff --git a/drivers/ras/Kconfig b/drivers/ras/Kconfig
> index fc4f4bb94a4c..7e7afd2b2ba7 100644
> --- a/drivers/ras/Kconfig
> +++ b/drivers/ras/Kconfig
> @@ -46,4 +46,16 @@ config RAS_FMPM
>  	  Memory will be retired during boot time and run time depending on
>  	  platform-specific policies.
>  
> +config MEM_ACPI_RAS2
> +	tristate "Memory ACPI RAS2 driver"
> +	depends on ACPI_RAS2
> +	depends on EDAC
> +	depends on EDAC_SCRUB
> +	help
> +	  The driver binds to the auxiliary device added by the ACPI RAS2
> +	  feature table parser. The driver uses a PCC channel subspace to
> +	  communicating with the ACPI-compliant platform and provides

	  communicate with

> +	  control of the HW-based memory scrubber parameters to the user
> +	  through the EDAC scrub interface.

-- 
~Randy


