Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41680C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3015C6B008A; Thu,  6 Aug 2026 09:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AF66B0092; Thu,  6 Aug 2026 09:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152916B0093; Thu,  6 Aug 2026 09:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC7B66B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:21:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82CDA160787
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:21:01 +0000 (UTC)
X-FDA: 85070905122.05.3D7CC47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B12DD14000D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:20:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hAv/gKVT";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786022459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9M22hpR37Fywe1zZz1y9yAYVc4M0MHck+1iq8vIWd3Y=;
	b=NodkqL8Z2vWl8TB//13GO/PJEGXPZ9EZ/vqYaOdg17RH1RAKgtE253FbombMX5t49QswjA
	kDxeluFU88wIcgLhld25ZHamWtuiVKZAZd05LfcvEq3cFvx73QFU/AWdyuE3KgiGFlH07s
	I0fFgfCMSBj5mKo02H9q3/qDlox3AEg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786022459;
	b=cICltCnip+ZCvRLg+FAsWQvS6iUqHC/mQUkKm7xBojDIHhKquHQ+SDuqt6uPtmsV/FTKMV
	kGja4PEQYU1WdLwixy9KOB1g7GJSY3yv4zGeAB4miML6NDfigaqjY1zSIxdIM3RAbv2rMQ
	7kmrWRrmzZ98Q6OKeZfeINVohG4j1ds=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hAv/gKVT";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9053941468;
	Thu,  6 Aug 2026 13:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3E01F00A3A;
	Thu,  6 Aug 2026 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786022458;
	bh=9M22hpR37Fywe1zZz1y9yAYVc4M0MHck+1iq8vIWd3Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hAv/gKVTNnWOwNy0eCGclNrpJrUejSmX/wq5ebyMntr2wjyTpm5EUABDroL8KrD41
	 p6/V1ny8qs3CeeMRlvgOFd5/btgg2ICqTVgg8NvHRe6cQwnMw/74Ww6uG1AxOa68XW
	 mfw/FK5BTxZCdpeMvXONqZ3mT6ELG/HbiVhMVh5JfgLSF740EtEs0eEKdMsc90UKd+
	 HcM5kYWuGmYeEqWBDPik6P76THWeMTlfV1MLZFaGhUTVorjPkH0fOiFdIcm9DawxVH
	 XZlCZyRYyCZzpjwrAi6QX47WdGy5fZRaXw/P2psZK2LXBsjaIN+ww1zP3lXMFrZssq
	 NjA4IxsryEcrw==
Message-ID: <cb1c0af3-e0ba-45bd-b51b-b0b224e9a6eb@kernel.org>
Date: Thu, 6 Aug 2026 15:20:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm/huge_memory: skip zone device folios in
 madvise_free_huge_pmd()
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: damon@lists.linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, sj@kernel.org, akpm@linux-foundation.org,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, vbabka@kernel.org, jannh@google.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 stable@vger.kernel.org
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-3-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260728194714.3713735-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: mykr7fb35ix3nejo9g7kjfo3h7u8hjko
X-Rspamd-Queue-Id: B12DD14000D
X-HE-Tag: 1786022459-90685
X-HE-Meta: U2FsdGVkX18erIkSThwI3QL/SEP71s4Pc3FxYeZX+iTQCTVFcNvM1EZVFSsIuXV/LykQlX3NWNozdw1OSrgRS7MYaE8cqXysE7jTHCgdGIxtYC0n2BZyhP1WRfPxz+JjVu+aqcOiCd9A1AH7XbY0K9M4/yoL7so0tc7+j0XRXup/Va5Un7tzDckRqgbSerSSty17w05AxgcjkKKCtskwygg5fCtdpbOzclOsbtbjw/ZYdtTC4/9Efge/OIF09dGpInW8VqfRDBoalgas6eCrlxUKHx7ML59wsj5qYRNIKb2N3dYnyIFPHbKdYLMU2eUeurutIJnNLKDU8e3qpOSVrn0dKve46BJDXszvQfChw9/QSHWY2poCZI4tEEKREfBHKuHYYuxtNytkvaM4j4LNijHgOeJLxpO/P3QU0KOAoBGuyHSokTipd1HohAuZbe5hZYHNvp/ob67bfIlaEDxxzyIKWZ9dsgZBbgTT/YstYCSvXIVCO6bZ47S8fsBY8akXC+bS1jbxxT4In30UdaOVsf7kMO3O/QwCKjZHWkIHktM8Ijj9bmREcG6aUg+d7VytSymoY6zsxe6c/xWBv8D5gng9L3yK8sSxrBfKEUfzcrZUvPWBgHVvgXyS8pnBqaC2ZybuW/b4mmoPk6ejzG+DV5FO51yP4ucN0p9OIi2wEnJDnMzvPbXsMJDvDEUyLboZV5WkIFxDRi52NIdFm04EHg2pUgrFv0yc4lMGAbefGno8ZekyMaIJ8On7o8k40H6lx6swgZs5wl03QONYxKRM5U1sVgqJzrf+ZHuEJx4jgtZ/loezwHW4P862iYKPMyrjz45acPcSs7ZntEkIbWVGVohDfeInMMnfDilYSU7eJlsvmjsdKGJ2Ymli4MMpA5ezk3Mx0ti5q/RMdnZvt2HWGNFaEmeF/IqmA7/XCL38LiYgZt0LJGAMbYvK2auCc5PesJLDJ9n4HagF72M03Pg
 xUOs14Xg
 YeJGTSKEID1hVyGOoYEpZaMjtw9Xlxw2Jl+9WxV3FhZPW8uapDtMI2sSTcxom9/1QBleT2h25bxCEGtDpawF6oxkJpPokRgUvPmgV+3msMMH1iXn+0itHDrCuy4HBg5edScs3WHf4GuldpDrFSWYkT9P/vtRJzTkE4Ir+B0GGSex7HYduALbz+qaFFNMZo4OVJP6pxFMQT2FWKIAvP/UKggcFpJ19JAmpZjip9z5+LajC+krvRNGNwZ+AvpnyzTJQcFhoOimDOvLqQ0fKI7PXoEaueqaWBZ1O1vF5ev3hozTgbjvw1K7JdwOFn9Rg7F7U/s/mQ5UZvUqwDYexXj96ObUMh5z+hqJ29hfI/QXxGaJw7blUkfETfc8USz2N9BhLsr7LOrGDNHVCgkgDAEi5n+gLjiUlVlAJdnWvAooSoz5bod4q64PLAFRvrGbf75O4bdXexL1iq58gYlWSoEx4vg5E0BFZEBKr4qIYI2XWCWkCMAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 21:47, Gregory Price wrote:
> madvise_free_huge_pmd() resolves the folio backing a PMD via pmd_folio()
> and marks it lazyfree without checking for zone device memory.
> 
> The surrounding guards do not cover every zone device case:
>  - MADV_FREE only operates on anonymous VMAs (DAX mappings are excluded)
> 
>  - !pmd_present() branch rejects device-private and migration entries
> 
>  - present zone device PMD (device coherent THP) is not filtered.
>    Unlike vm_normal_page_pmd(), it performs no special/pfnmap check,
>    and would be marked lazyfree here.
> 
> Bail out when the folio is a zone device folio.
> 
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

