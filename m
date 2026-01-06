Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB840CEFD04
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 20:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7D36B008A; Tue,  6 Jan 2026 15:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FC46B0092; Tue,  6 Jan 2026 15:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ABC96B0093; Tue,  6 Jan 2026 15:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAE426B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:25:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A71EF1A0B16
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:25:54 +0000 (UTC)
X-FDA: 84302670228.17.AFE3FDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9177A0009
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:25:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4M2Vt8t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767731153; a=rsa-sha256;
	cv=none;
	b=8JKikm9A6DX5/POSwRjoYBJEK7N2+N2Q+Ml4fcgLxLy9KT4ktk9bWIanMZOGDXhOAsZZKf
	QGSFTTl5oCrzvHTHGIQo8Du8irjR1jiIpxhwaYkm90sWMkVF/9vVMjbRkDZm74/WQJgzYJ
	ESfdKTbkRiBvCBlsTnFMBwr9VfydjgI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4M2Vt8t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767731152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7CidjyvlQ3XvRSfIm4BPU3Bh0ewhGMAihn/trVkpVcE=;
	b=2+HbrhC3wzitWyh0J5TyBRtiqDrIjXE7qR912hFSfeRDKj4bODdZALyH75Jd6Ll5ARR2zu
	RMWyRzIPgg0h1HFYiyPrMqhgzmWhHrOmcO1kWturED+ru4BQAJCgsLJusb4L6asw5h7WXF
	gcrzkvq9NHHOW7ONKUcp4EQ9gT2oSUY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6513460008;
	Tue,  6 Jan 2026 20:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365B2C19425;
	Tue,  6 Jan 2026 20:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767731152;
	bh=Dz+Lc1Wqi1e27Q3BsINgvQycs+Ztxr7fWqxyK9DreGc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i4M2Vt8t+iXsimUBfFryQzKxDVUNh+X16Be+6zz0OBm5BDgOAKAi4d51E209oq8nU
	 d7G5EDG1XuXhm2KISFZ/cMIcWvj2jQde8slkqDeP7FLUYE/WrjiTdJcA4yHPG+YakN
	 1j78ThWty65cASFAHDHYYqKEE5Eek4FWldmeh8eQnz/Sr5DA3SUdXPJcurhtF/g0Jv
	 k3LZ8nK37nAWnNqPX8onoehwkI8AmlGgnYbupWg0EhCJOlDadGb15LV1+80Myi8sTR
	 I/mcAd/4yRfHAfHJI89pFfDv79lvL26aosiycfdBM6zYt7ENbG8u6TKqBBbua4M4xS
	 McQQTzNCq1YmQ==
Message-ID: <e5d0eb99-bd1d-4350-a6f5-367a870b2d5c@kernel.org>
Date: Tue, 6 Jan 2026 21:25:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <20251222145807.11351-3-tianyou.li@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251222145807.11351-3-tianyou.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E9177A0009
X-Rspamd-Server: rspam03
X-Stat-Signature: 75efejwx1ynzw4amttdonn1y54ubejtp
X-Rspam-User: 
X-HE-Tag: 1767731152-357408
X-HE-Meta: U2FsdGVkX1+VCNlnwddZujT7tlbYXIl2ubCR2xuy/vcTRXgzQ1J1KWIh706gpiF3uFnGE0nKJCftKk0puhp9R99US7gYRB/Qz8Ej/ldkW3xdBDI800A13qmHKSNCTR5XwquTrHWKDo71HOwd4MQfdQvhxU19NYGOcJephmKQNdUsS8TVOdDIrqGZbHFqlJBRSdtV3VWDtliOtDLbAgN5JghtW+4rg/CssrcpsZ/YV2Jn5b3hBDjhl+lnzHo8waGSxaRFa2flOo6VBt4k0cSRQbemz87wT4Bae8e7ERtxnUgnYIt+gC3eHKZWca/YUZWpbDNyVcenpRpmNd6Y6ieWPJhL6rEq99PqFY5idj/rUXe0VUV2JaGFDKnQc4jBM1Mbl32OiF3P1AZIJyFYNzVYIykGG0DMjJ16ifo+r/C8/MzmsptC7ZpLN+TKk8tHTBE0VeCuPHD4XF/H23vdBjP5hurqzqWv2/upmo62CnVwJ4LfRvHpbCn3u3Pp5tMQohb4tTf2cYyzVkrtmE8xeE4AYi45Er4nRLVV5mE2kM9sWTD0Jp7RPpiLuZFNvFzwnPLEsr6oyF3ug/aAdS+bOzoAUvJkIVq34kWkEnb9mnkYFH++NYARwXXyonIdoDAz/b7Q8SwqookKQVVWkQsFzPhCd/VbKJ4vaxJrcueLc2+Uwop1y4EEziGLPIEgRF8w+RiReaGiXweO/sXk77zvgSzHGvMr4sF8bcS78hanx+4M7O4zUcmeD1heey7kiM/HCjHMEpmxIoDBGWga6TIcoVe9sqzHU//6fNrFD00I4VgEbMFyF0dO0nNxRDCQY3YKTzGbdMWnfDbKZH2/IGcbbgrlsMzKlWOd0b+1SiV5cBl+2rEjWnF3HxosbbUh0IS+Cp37fa88D3vlNcAK4DJ0h78i+uFUg4p6ctDGeQY2CooqLUUbPshyheIa7vPk0tWRvHDG8+E7b5ZaITb2AV2bwhQ
 j28VHKDV
 SPH9ecxZKNf1aXxE/zIpQkltNceUR34xq3EV2sT3OrldAEDEOztFwC6smsz8GkT+8wQWYpKaRf8x1iesDq/ZRf7PsYv9O2u34hoZ28/uHWMtVndUPW2XZJmUCQptYCvge3qey9nJ7poP9737vLnCRjMxMx4dz043FnCP5cwDhfwF9g1Nu+rVBjb5vCi/zP1CDugxY1A9Veq4D1luCjyXpUkPEEHqCJjhlIjPfgKgkZCGqYbrtyVF4KdbwrD4MiJPK27e8AnQfdUyt7iTRxkpVvp6eSH00joam4Gmxyfl/Qzc7mT3KR6btoykiI5sW/zuLrv1RJn/JvFi5YVs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


One more thing, the fact that the clear_zone_contiguous() happens in 
move_pfn_range_to_zone() is a bit suboptimal.

Maybe we need a comment here like

/*
  * Calculate the new zone contig state before move_pfn_range_to_zone()
  * sets the zone temporarily to non-contiguous.
  */

Or something like that.

Alternatively, we have to rework the code a bit that this dependency is 
a bit clearer.

> +	new_contiguous_state = zone_contig_state_after_growing(zone, pfn, nr_pages);
>   
>   	/* associate pfn range with the zone */
>   	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
> @@ -1204,7 +1273,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>   	}
>   
>   	online_pages_range(pfn, nr_pages);
> -	set_zone_contiguous(zone);
> +	set_zone_contiguous(zone, new_contiguous_state);
>   	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);

-- 
Cheers

David

