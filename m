Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 605ACEA3F2F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 09:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA8B6B0005; Tue, 10 Feb 2026 04:40:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8824F6B0088; Tue, 10 Feb 2026 04:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763E86B0089; Tue, 10 Feb 2026 04:40:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 629096B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:40:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E12DA8BA09
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:40:01 +0000 (UTC)
X-FDA: 84428050602.10.248B0E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2F56C20004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:40:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B7lWpTip;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770716400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsZoBatqJujkGSoy53OMu5mmb2wpVoZDtkrDbecmkzU=;
	b=TgSnUvH9bXgtcg6n2PfSNlj+R8bEqc12R0T24w2fvHRDlRieobB+xgINnM8dHt9lpTt6sY
	QKKpnfG5fqqIYrlDl51IPN8Y32KiwALcMJCyaAjnJP3MQYd+DujRVcRchvNfPGJdBCM7MJ
	xx4Hdh7G6d0JGbJ4Oam4CZDpTwReztI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B7lWpTip;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770716400; a=rsa-sha256;
	cv=none;
	b=1qvsrEZzrXHaTzBMq/MkVSGmKsyXGjhc+Zfm/kKeCMZnF94G51u/aqCSyjcur5m2u+RdZx
	wE60T/sTiRo0cn9nzCssIJiG0G6Ak0bRwdcZRX8XejVAov4gSmsSO4VAxDQcdET9TF3rEs
	U7+OTMAd8jGO5XXwriZazQ5O44pAVe0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 91B1660123;
	Tue, 10 Feb 2026 09:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5730BC116C6;
	Tue, 10 Feb 2026 09:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770716399;
	bh=Eccl98ukGWgNNJ3Ns+n3BAHpoXOLPuE1FhV9dtp8PE0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B7lWpTipz8Y9RgpbghBDeJ1gOQwvIaoHpCQoey7fC9NySgW6z8RDjmOKULKTduY60
	 4FBeV4bwR00MOG6RTRjI92ly147Jr8kaglgtPh5lH/zdd75gczl2DaoQGDRgulGWvs
	 lvTdNoyAk5ia7oIGVLba0Am5a64y7zWcGQ1MvyBA6DTj3yL7n6y3H2RdIXlLO17aQC
	 iEpHJUfKyLeIc5LUox9WlOsdCwP0eEsZlzvimRjXgAZXxqceiKpxEc+utSBXAEyi00
	 RTf2aWDbe//aC8LuGPUDluXqR+CISP9ydAaV6R20RMxVS7e/u6Awrn0V+SmWm+2+rD
	 kH8D2iiHOMhLg==
Message-ID: <76750d20-cdfe-41bb-a228-9b3f171675ec@kernel.org>
Date: Tue, 10 Feb 2026 10:39:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v7 11/16] mm/migrate_device: add THP splitting during migration
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251001065707.920170-12-balbirs@nvidia.com>
 <e73bdf49-0a6e-4e82-9727-3a241fa9722c@kernel.org>
 <13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x9jueb8oheqzc3ed9s5pg19iczpdgugg
X-Rspamd-Queue-Id: 2F56C20004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770716400-812982
X-HE-Meta: U2FsdGVkX18c1mZvLYHQe6xQ40bbdJyv0jSiFle/7H/lq4ocLcH43TGBGhL7nxqyTKDjFtybZBk/Aqq1s/bncY4dAtd64Pkfw+zFqHWlIIUD7e7psvJWx39m8e4UiBSu2IgvMXUbW/aEtpboUA9+3gE1Q9F00g8WqYexE3VUw8tZV7TR262NZVr8xDT/ISIEVHqTIWtgKbl0yE/ckbFQssVYNeVcQoX0yqj17ubE8fDK2IOL8HAFjxwI/hDHVhW5h63KJMOw7Bll2WLbUQi9zjJGr2I9Jmcj4PVGUeYmIpozVkolpLN4bJvyBuGoyEorAAUceoX7b3+H3JNsUy3ypO8FgFNw8HhqXWO3rnglEZf6smB44+smpX6OBR/0Na8pMfyZ6tn1eXAZXvxa3Rl1ha+d1BrTR7Gi4stbiyf/W5u9ZXWLBy2GC4f9zEakifHV7agncJ1KjYNY40u/Bg29C0MrkSjEe5t0pSix9EgDYJ1qXNc8ake1G8aKCY6vtPrsZUeLIemF7pZ3y9n43ySGo8Ft34qBfbNWmKnUKvD9Rfba/N98QvFJEN8yYmKNbxryvybNliGB2LPqNg9cxgPvwzg50JZocB1pt4o+ZSE7ErvxcjrolIqKZKLNeAmS6rh88RaoYDWXxKbCwftkVyVDVZ7ioLyWY8zhfdy31lJmCV775X+fptz/4KsrsvHK47d7GPH3GsIs5grxXo1wuJwOjFFv6/B1tK2KWgHeWv+nrXev6bLI8M7oQRPpHojCXLGPWFh3GYWJYxiKLUYs6GiLivXfa8bT8gx0hBF4gGdpawReleIJUP/VLFpYscWqt4Y0NiUY/5AbomsfUJ0weLQSOAK6ve3I0xzabBCjtTctP2AIFkzKJG6hO8WNq+6BMI1ab01suF1957PsqjpD/BwUrhKitQOepYBWC2JpP5AGt/R1J8bPOf6S9y3FmBA1moOIyRtmC2Pw3rwUy7nlkw2
 KE/U45r0
 /ScDUZCnjF1UpcGd0/RquaO/Kr0hUK/Hl5/1P7ZuWksN3igRejkUuTiqqUFwDamdRqk89YITo/7VZgZxT31CD4w8el0BA5T2ZdmXRx4fo5ZkVcZpHpKoYJtAp0Zv0ysbSEzhqaqTuLUzUrLT5Z2952nU5oXGiOCUPLjkFufAf0y1e/4PYineWxCKqd5msHXZ54cZ9MiyEUjShWaHrxWikLS7cFsy4xwR/DVn1QJXr2A9+2EkVnbWhKCHptO1B27AtLKz/0scRNF4i7Jkx50CgXxkHlnZ4fh3szQA5lZXGn93UIKkTGjqCMAymr9LSIpOsgbdNx60JK/elcqe+G+C75Y20qHNZjbXdyMLQ3Z/n9jqX0C2uvI/RDA/asW2ZD31I+4Xalg7IyGA3vXz8xJMytKvGuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 22:57, Balbir Singh wrote:
> On 2/10/26 03:00, David Hildenbrand (Arm) wrote:
>>
>>> index 8c95a658b3ec..022b0729f826 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3463,15 +3463,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>            new_folio->mapping = folio->mapping;
>>>            new_folio->index = folio->index + i;
>>>    -        /*
>>> -         * page->private should not be set in tail pages. Fix up and warn once
>>> -         * if private is unexpectedly set.
>>> -         */
>>> -        if (unlikely(new_folio->private)) {
>>> -            VM_WARN_ON_ONCE_PAGE(true, new_head);
>>> -            new_folio->private = NULL;
>>> -        }
>>> -
>>
>> Balbir, why did you drop this check?
>>

Thanks for your reply.

> 
> Are we running into this somewhere? This change clearly seems unrelated to the intent of the
> patch that made this change (by me). 

We stumbled over its surprise removal while discussing something related.

I thought you removed it because of some ZONE_DEVICE magic; the check 
has been proven helpful to catch bugs in the past.

We always document carefully what our patches do, and why; and avoid 
doing unrelated things in our patches where possible.

> I was seeing new_folio->private as NULL everywhere during
> my testing and so I removed the check, happy to bring this defensive test back.

I'll take care of re-adding it if is still useful after the other 
->private changes we are planning.

-- 
Cheers,

David

