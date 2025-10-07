Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 394D4CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 04:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DFAF8E000E; Tue,  7 Oct 2025 00:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6A78E000C; Tue,  7 Oct 2025 00:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3B48E000E; Tue,  7 Oct 2025 00:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC278E000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 00:39:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF4B9C02D5
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:39:34 +0000 (UTC)
X-FDA: 83970064668.24.8202F00
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 228FC40009
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:39:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759811973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3YgRxS8xN9h48Sj22b4E/flZ8suTVjJbkVISDNr88aM=;
	b=tna0AitiX5G9FxV4MuxBtQ5g8YYAtK0m5x5WuZa0uGczWgjoaK8t8yyAIoQqrjeykMmnzH
	XOkDIWIiO1Dt47PJ0eRp1EebTIqI23b/21vwVhkD+egzzBDaOKhlelLMH2aL00Vvj5vX5L
	9EwSZweyBX6diubLCUnNYW0z1ERapNY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759811973; a=rsa-sha256;
	cv=none;
	b=7DX3CYAq6cE0sFyUPIC16ExiM2g7VRFCbOXHVzrJz4caUWZLTTib1J4zXk/lWCjjJ6Aphf
	mrAbulpw8wLejB1NY3mohWigSHxgV4iyYJWB6UMhRKnDooeMfbbVpgwWbagDK7jo/YrOBo
	mdpB8L8s35rJye8s4yrOU3JHqO9TX7k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B1FE14BF;
	Mon,  6 Oct 2025 21:39:24 -0700 (PDT)
Received: from [10.163.65.24] (unknown [10.163.65.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8FF63F59E;
	Mon,  6 Oct 2025 21:39:26 -0700 (PDT)
Message-ID: <0d1bcfdc-031f-4841-b0f3-15ae1d1ffb8e@arm.com>
Date: Tue, 7 Oct 2025 10:09:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 2/3] mm/khugepaged: use VM_WARN_ON_FOLIO instead
 of VM_BUG_ON_FOLIO for non-anon folios
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251006144338.96519-1-lance.yang@linux.dev>
 <20251006144338.96519-3-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251006144338.96519-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gtj89kaps8kgxc4xgwuiizfnuyxaufbo
X-Rspamd-Queue-Id: 228FC40009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759811972-497108
X-HE-Meta: U2FsdGVkX1+rr9R2qCZ4vybV2SHV9VWiLiqy+PFMwpaUN4zPv73WPON7CX2nlXOc4g6nolcoTSP5ePH3F/MwEAL0rRA7U+OAZ+RmCg02FK6Kh/Jb66uM/Y6LkL4vVoXsbUSk1daE0VSUSlYgBi02ydXmdLXjhIdfLvtR+syGfLVpfRIJz9dEf1l7I3MdcS2blvkE4kT/0qzTXSOpJV7uF5bHgNlVrMi/NaXbYYSWhxFsT0NXxxaDRxb3ix9svZyycrgSwCIdYOVe3neLR7vv7+S3Da6AFc6ZUsaHlt6Dn6QyadWVk7WNh5X9UK3a1VpP2KQeWnsvnN/0k1DgYtK9PdPFO1xG3wwHXAS+jKLXVm+KY9pfJNX8JsVfoOGZSo4RBMQDds3ogUmM1xgSCOB9yz3GUPNtl49NvXVXzfJt1S6hX04m4f2cYbCgDSUmiVqrRy/Uhk5kVP4JsdC2OEGyMW0orDK3TNIn4fnz93fNGrCPxVU9WlIrGVIF6xdSd2GZI9Vqat9gwpQZqOcEe2Tr/+mAojSWyBA9cMqqMLZC2JcF0jZuCMs80MCgGC2KrXFB/gcZvaob2fjM8TRXLIaQ32iERPUZHuA45z9S1UfthsVnXJpzEkl8PRXGxVYMR4aiIQTt+jjMhAwhdLO+ngNNR3+f+xdPy42+1LWq7HhqcHB2izP86Hy2PEef3YaHMUIu0APd754tfxIfqkDsNiYqNlKcky0rGTorz0eVIfyciuSa/J9/tWA76J+en85QRKTk0c2U8dnsi8kvbXHeN/IXeqot3y6MZWh8uPQ/L5nyZA5F/A3girX7ateTQjyRmu+UXXnNOiie8lJOkjQeQqLp4gjXrHKe4DA3Dnq+mU4ZQVCOf48OgA0fEA//D9gY+3Cx5GScD+kM8iGIjkLPz+c30uSH12KDylk3NevJTgQoBdywKkXst04dVbCkdtmy90IckxdB3rdOfrhqy4PkpGR
 jPgLeAqS
 1Qzmj1881/3GHypbfpsgLfhc+UUsXEv2wthE7Sq+rtoN8LglE+ToN3YgZqLO1ots2qUm0KqmGXe3MQUA1p6F8EAIk6Ag4eCePmV1IZne7tpsURq0ezb1EqW78Fb1pu+NoWG3ilNxgnry8Ni4gzcw+yNe6UJQxlMiJsl5pkzymayzt9g605PhZGQs512+S47uuaDXSVqiGw9GVUYPeRan6v+Q/rCdo5RCqQUqDZroju+6UGV+Cpuzt72l6S1Oxy/4s3hoLT//U3g8SChmnqevmIDkB6Bs/d9xgjBtTXU+UilBpnqG7xG5i9ocDddX1t2loP+EBh09D3BUdfx7FqqQ7YcWNAVm/q1uUbv+I2loZDn8SsNNHTq5LCJnd7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/10/25 8:13 pm, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> As Zi pointed out, we should avoid crashing the kernel for conditions
> that can be handled gracefully. Encountering a non-anonymous folio in an
> anonymous VMA is a bug, but a warning is sufficient.
>
> This patch changes the VM_BUG_ON_FOLIO(!folio_test_anon(folio)) to a
> VM_WARN_ON_FOLIO() in both __collapse_huge_page_isolate() and
> hpage_collapse_scan_pmd(), and then aborts the scan with SCAN_PAGE_ANON.
>
> Making more of the scanning logic common between hpage_collapse_scan_pmd()
> and __collapse_huge_page_isolate(), as suggested by Dev.
>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


