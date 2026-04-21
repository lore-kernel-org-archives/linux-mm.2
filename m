Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA38F327AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361616B0088; Tue, 21 Apr 2026 02:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312306B0089; Tue, 21 Apr 2026 02:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2279E6B0095; Tue, 21 Apr 2026 02:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 121056B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:55:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A20B81A0C7C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:55:22 +0000 (UTC)
X-FDA: 84681651684.30.5AB5457
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id A10A640008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:55:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pk7L4Wn0;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776754521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxUMcETQuixlF3rMQVkit9JIIkPJRX+G/qfMeu7OkdM=;
	b=oA89kUMe2dYte42PC15vgjmPIgjWrH3/T8beGzr78wbFrgo/tXpvWO3bJqgt0CcntpsYoC
	MQcuW78VpbYcTpwtZWL/pDPwYe6vrWfgckqtMKQ7dKHyK4QP5/V2uSaG7TiduOrlvx+DLz
	v2uAdaFemmANsNVEY2ldGBJP34Sx1tI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pk7L4Wn0;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776754521; a=rsa-sha256;
	cv=none;
	b=DucTB8MnYaZJiAmrovXIogT7tbXczAgwksA0bkMfIyV9ppe2th+4uRKUAqp9N45u8ZFtaL
	Wx7NroIIrwLxNIBEqzWh6obw3RmKQqMz5De20HtD3V/LzYF4EiQGGwfxiTWsSiyinksL6K
	axnBwmo3NhOkNueeVOOJA47BqQLFCiE=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776754518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NxUMcETQuixlF3rMQVkit9JIIkPJRX+G/qfMeu7OkdM=;
	b=pk7L4Wn0WxtolMrucH5sGuAJaeIzkBSFPNvgmYguRp0KXfsGDOalpq6EmsLz1HMn16rkdY
	l0JFXPxWXTYv9tEqYaXY7XCrs0hWc13c9n6czix2oXutSiup0LJg5lsBelcDL3AKWYgmYK
	+n+6x5MrhJgRcfdkMcXYW1/1Aw1QdpI=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v3 4/4] mm/mm_init: Fix pageblock migratetype for
 ZONE_DEVICE compound pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aeb50jwoCBvgEnec@localhost.localdomain>
Date: Tue, 21 Apr 2026 14:54:35 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9343F329-BCD4-4D64-94CB-A94F0E9E4400@linux.dev>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
 <20260421022044.1217503-5-songmuchun@bytedance.com>
 <aeb50jwoCBvgEnec@localhost.localdomain>
To: Oscar Salvador <osalvador@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: phj7da86x8jxecobys974bzyz99qwccw
X-Rspamd-Queue-Id: A10A640008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776754520-941213
X-HE-Meta: U2FsdGVkX19b+ID6PwlB3nwpcOwaZSe+HTdDYmdOVd2+RLNDv1ROBuaOG5iFRJgfsHyrZIdRtkpFZ0Hoa8d4XOnBE1046V/zoMp1OCXFyb6ajlQ8uZuyDxIM2Z4i5P5RUpI5wNGmlcBEPAEHhT8MBKM233karVSYpUy7kTlixcC/TpeqNBnTOolyUqxgxLqpdXEypITdzaCYYogjehQoQ6MIwEg9iEEyHXMpEb6jKcrPyOU3HtB5dVawn2fCMYbeSbHJ6C51HenpHiUr0EtkyLtJ2MlZy1Bx8XiavX6xj0MhkkXgbB2R9ruHgt85kvZ9WW3Rnfc3hkJDiz9z7hxvr78LTQYlmn5w4K/+ES3Jj8kttpl/F8sBnM19iZsbEPwnPL8tH30aRyAYX+xGEpBEoeq7yQm3SVDRjOSmJUH32cvMpgN19663TlSdBAPSjs3Xj3fv0YDYVWGFelE5oiSCEZTmfKczyz7zSEOBk3r9SJS8zxJsFVC8EBkfbHUz0VV5qGIpRgVTSbeOW2krN58WermZ6mHP4XCabGJOtPdHgyTirpMgYxupwEH2ohc8YwjJwgjgFHoX/aUve6gPow6SZbEX/qH7FIZ6H95xmzDS6rRG9w3qj1jlLFAFvKuu+7zjHM+EuCnKS7h/ZLne41spwhwTUUoUOloB2O2D/4nRwsAkLh0K8rWa8tjLzcbwZZJKYo5mpWsC0cEOmb77yEZjmdLsZ9M5gceWoAhTOhJv4jU2PM6x1B9H1ISqepayZZyrkKz7u5l9URXpVJcquZFPql6nzHOxVMbeSQBZeOvDRD0p855SjqOENdMIOUBLmYSr8x+OJHZ1B4thWNkG9u+1e36bnuYLc4+EhDWlZczDy6wNDK2Wu57uXiA1pIEXJfGH5wDPQ03YlRufA6EKpX7cD2IFrJrfdp1uepzl2D0v6Tg7tXKzxQIhheDGA72PdS2eHhuK4Aq0k5EUD29s/E6
 EXcVNeRw
 uUpJTUQizQxW5ZBlt/mUwsh2aVRaOK1CSzJlerwZO0AxoKTH5joquzFCOyMYN3SXC9s1p+UUiulbVHAXQ8ELdSlC8ocDnwX4kHvnDeFeNFWX4e+ITHkZ7JkGUfZl0xp+qC/KNsxtF2vaj8mpvrYPibziA5DHA59GrPOcE1AjOpY1JAhZRPN/4+0ti7o66yUyIhfXJZe7yxiAXz0TdIaTU3SdEmAD4v9vrKrja8wQNu1E152RH1aDyB/53TiSUk1LuZj255vhreObZ7MdU8Hwp6XTOA8LjBa3oUFO7w7ixryhXQsb9oNs7m/AMV/VcSy9/WzgthQz4cMPWd8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 21, 2026, at 12:15, Oscar Salvador <osalvador@suse.de> wrote:
>=20
> On Tue, Apr 21, 2026 at 10:20:44AM +0800, Muchun Song wrote:
>> The memmap_init_zone_device() function only initializes the =
migratetype
>> of the first pageblock of a compound page. If the compound page size
>> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
>> subsequent pageblocks in the compound page remain uninitialized.
>>=20
>> Move the migratetype initialization out of __init_zone_device_page()
>> and into a separate pageblock_migratetype_init_range() function. This
>> iterates over the entire PFN range of the memory, ensuring that all
>> pageblocks are correctly initialized.
>>=20
>> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for =
compound pages")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>=20
> Would not the call to __init_zone_device_page() from
> memmap_init_compound() take care of the subsequent pageblocks?
>=20

No, it won't handle them automatically, as the page count from
compound_nr_pages doesn't cover the following pageblocks.

Thanks.
Muchun

>=20
> --=20
> Oscar Salvador
> SUSE Labs



