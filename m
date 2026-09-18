Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D51FC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238646B0095; Fri, 18 Sep 2026 09:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E94A6B0096; Fri, 18 Sep 2026 09:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102B56B0099; Fri, 18 Sep 2026 09:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCC6E6B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:47:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4EE1A61DA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:47:27 +0000 (UTC)
X-FDA: 85227010134.12.C5D4AE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0AE3E4000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:47:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F9ZUhBUH;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739246;
	b=mbFb24YxzRLhI9HLzJ/uqsunJqVqr83LjptinDIp418d5tWLSO6cCvS1D5ZRX+QpvRoOe9
	MDe1uWAXqfD83y1y8LYpTPUQg+3qq6PkTCDILjvSwnQ/u8N7/Twr03He6CuqqSbO93AzqE
	ZMnsqWS4JEU4J3SJ8Fov59EIyJjyAQY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F9ZUhBUH;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDB8ZNrlloa4K4BhhwSa+v9ApPYQhDBrcYUmm+5KlB4=;
	b=jNJzj9w7L7Y5AQixNr0Q3X2SbmDkmRNGX3AEm2dbnUuz2gx5pWQlEoKWYxxLmVYHgmkRQ3
	qiWo88fwfmpBhRsUZU+2Nrws00wvMyJYHfc09T98MeBpyZhWsjFSsSW6BVlYVE34tofkjy
	b85f/ut7oAXLorpr5M3tECeK8CkY4eM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 376374344E;
	Fri, 18 Sep 2026 13:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F29A1F00898;
	Fri, 18 Sep 2026 13:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739245;
	bh=zDB8ZNrlloa4K4BhhwSa+v9ApPYQhDBrcYUmm+5KlB4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F9ZUhBUHGtWbiYQJVewlMYWp6udci2KIiFZLV4F7Cxb0UcEtK9ErRh/K0jtkgbpzi
	 8czAX5BPGeqlacdyzDKafNHDHbtZdPv/ngZU5UcI/ERMTB6iwzpB+mnt7/iD+PIK52
	 Aw0IVWIxLOeb6jZwmtaCrvYB9AGdTS1qEFBeekYfe8GxFz7IvfsHeJD6nVvO6hfsgK
	 MHj2AspFZHalCqpmD0C2+zmzFZEOyMbCRyR6x6awZa1lZNc+YvYIM3isj9p1OyGjzd
	 YqhPXY5IEKN/uyEGBcjf1b7m6sLMKamDtFfnF/AfWv1ncitJ5NNZbvfK4UBXQKGaJi
	 Nq3A15d1BYm5w==
Message-ID: <813a2644-fa9f-4ee7-8655-ca69ef0e8a98@kernel.org>
Date: Fri, 18 Sep 2026 15:47:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 11/15] filemap: Add hwpoison handling to filemap_read()
To: Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jane Chu
 <jane.chu@oracle.com>, linux-mm@kvack.org,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-12-willy@infradead.org>
 <an2e1j3C_4DA5KXK@pedro-suse.lan> <an3xv6Hae6g3aHCh@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <an3xv6Hae6g3aHCh@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0AE3E4000C
X-Stat-Signature: ke7y3tux6w1ayreye6ommxddyswxfnuc
X-Rspam-User: 
X-HE-Tag: 1789739245-320960
X-HE-Meta: U2FsdGVkX19sxwhsAfekHI+BrE8vW/Fq8FnxuvksKQAUAT+yr6pSvMl4Q0GKVSK/tZL1TYZnz1pQ8mpYAp12tXr/6IpnTUyktNQ0z3VAgMTrGVyo6Zi6VCSEPPeQvX3w6q6nXFbOnbXlJTCQwpcjaE4izdMUKy+hwFBrqsBdkmJKcPqkxehHorGN6rWgtItccDNjI2wKhq1bms0KserNPlfQPsSIJsoH9l0J8MimTkn5TehDobBc0hcNaxfuzLp4IDsidJfxIj1T5lLfy9k6n2ofW7XkN1zmYuK+A+lOQ147/gLkK4MeZHcNjT+ccDa2yN4UCPO4EY55GPyt7wK14S+zErv6ajo7SnGdtKFoL2rBuQ4hCmFLu7IzJ8N2eOLcWJ365ebefnHNUlodS0C6sbjNdBa0B4w3HFEK26YX9iD2VG4cgmLCliP1/oVRGc9M1S5uKzlzv3pGSdVzxWxUrJaeV7SN9x3MLZi95pmXpzEeHxzmW6cZfsy1HwRuFH8C7HGe83tJsLwaWjh/HGWfF2oyUOdzhZdlVm9RDcsxVK+MAdbRhnSaO8WCnqxAzgtSPVZeVAmDrBDUfUvJA6Ucr/Qjyjsam8/dgQMRX1t+fmOcWmCintNIvGM5qKwn0S6g+Jez7jOnJvrWLMcE91askNVMf96CHdE71aGx6gAutyV0rwxMxlnToWhT9ODFk6y8DX6x4LydvnKpcVREa3WhWYNoLEz8gJGzoHNSsB2NxuNMiYvez3p0SgQIIqu64YkNvHnoqp3jCZBohbj3w0eBz8QHtwMfoi1qzfNj/PvfHdHSZhElVNP8y6hBe8PgsAviBP/Zj7HUbEiat8BmNxP1a4rov6HIfOoWDkioM6cKosvAcTe1Wh0E49b+bmc3B/zgJuUmgeKen1c0TF8dGgqrRXcwGmNUJZKe+A8Tc/WQ/Eaeo2z9eJW90dgmtKmnd8uIoXoVYsZbO0cig3xrhGN
 gMso1zLM
 cuKi1aN6xOEkDlG3jQijSRfz6dmj+LS1s9OEkZoKDuWW+T3Yw5NPeBoGMHPwpIHB6Z9IJS509sdPCT5M4vwTy12nGGbte5rRTfsrc6Z6RRmaEC6xFMYPqqDQ8lf1XWRRzz4Cw4GKcFZyDoMnLP5uwAA9B718HttKoCb9aOmOAiQm3o4iNcHND/GhIq3BSk5+T9BUaheNfDFnVtg9IZiv5+hNxEdSlEGCJZNT+v+UoxF5Cl8RBlkZCbkb8hLO576Bl4odcMCOoyg91wk3+Pb+cMrSw0xvYT2bIFFaVz0LFoWjhx9wojYzxA0NtJcZBTEDVpAAcjgiVWC26EgEgYuhyeSyFC3mt9l5H1XQ1WL9Pv3YsY4x8//unPisQInXUYBFoGVVK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 18:33, Matthew Wilcox wrote:
> On Thu, Aug 13, 2026 at 11:55:44AM +0100, Pedro Falcato wrote:
>>> +static size_t adjust_range_hwpoison(const struct folio *folio, size_t offset,
>>> +		size_t bytes)
>>> +{
>>> +	const struct page *page = folio_page(folio, offset / PAGE_SIZE);
>>> +	size_t safe_bytes;
>> 						    offset >> PAGE_SHIFT would probably be more idiomatic
> 
> $ git grep '/ PAGE_SIZE' mm fs |wc -l
> 116
> $ git grep '>> PAGE_SHIFT' mm fs |wc -l
> 656
> 
> it seems relatively common.  Personally I find / easier to understand
> because I sometimes get confused between left and right shifts.  I
> don't think I've ever been confused between multiply and divide ;-)

Linus once explained why ">> PAGE_SHIFT" is preferable when the type of the
function might be signed, as the shift generates better code.

I personally find "offset / PAGE_SIZE" more intuitive, but I also have sympathy
for PHYS_PFN() to abstract the operation.

(SIZE_TO_PAGES would be a bit mouthful so I wouldn't ever dare suggesting to
introduce a new helper)

-- 
Cheers,

David

