Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B2FFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 995C06B008A; Tue, 28 Apr 2026 05:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D5D6B008C; Tue, 28 Apr 2026 05:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB516B0092; Tue, 28 Apr 2026 05:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79B846B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:21:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2018D1404FA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:21:54 +0000 (UTC)
X-FDA: 84707422548.17.DEA2579
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id 33C8D40003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:21:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dS30g3px;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777368112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwdhCIsDzsUndt0fN1DFv5y4ol6vuXneCPXfkJ3rv3I=;
	b=V6d7CaMbiNrf0RiqQpTmxahTejpmbjvdku5Cj3u6OYNH3PFtZweWugKQ35uy3y1rcXp+PN
	o3kVFUNOk+hXZcTHkb8HFqgs5xu7cAz9IWTnjuHu/EqC3hxJEwP/7KW+lMEZ3dS4KZupAj
	9/Wk3SCW6xAZUy3QhRQIRC7bexoSiMA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dS30g3px;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777368112; a=rsa-sha256;
	cv=none;
	b=RPjhjdXqHmrIIS1bZR5ZOUhq+RoLe/O6/QT3cOba2i6T53zUxs/MobzuTksgDmxKbdaMnC
	f2ycICrEyoyD6AWt4taZrErTd0i1pQ1/ihd8gOPY4h4cmxo5Kng+T6g//kTa6VzhMP+vm4
	v8/DsXrcBlvYBGjgvBiR0aPPAWyBx3A=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777368109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xwdhCIsDzsUndt0fN1DFv5y4ol6vuXneCPXfkJ3rv3I=;
	b=dS30g3pxAQECsLqXNpTYtDUDVrkf1D942/Jb0Vg+uqVnWtfcZuAOdOetuJNWaRlhiJjxeT
	yPn5bmMw9t8ruJcZInnv10V6Xuyxxc/Ga1bqL/WvpQFwaQHu0K3/FWqLj9xeQTwQ+kfrzz
	67U5Ezas6Tq69R+VfxEi2iqI1qoZ3gY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <afB7Go7JqhIpjU5J@localhost.localdomain>
Date: Tue, 28 Apr 2026 17:21:00 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Dan Williams <djbw@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org,
 linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4542EE05-E18A-486F-ADF7-E72F71D9A327@linux.dev>
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
 <20260428085219.1316047-4-songmuchun@bytedance.com>
 <afB7Go7JqhIpjU5J@localhost.localdomain>
To: Oscar Salvador <osalvador@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 33C8D40003
X-Rspam-User: 
X-Stat-Signature: 3eudt9s99rnzt3njjfa4xqj8n4egfjkx
X-HE-Tag: 1777368111-374499
X-HE-Meta: U2FsdGVkX1+8MIw/3MaCHGcYx3EzCMmP+iwpxB4o/qifK/uLWKATViyOTjtJEqghbcISt4umMs1Sd2A0zFDEJKIIY/F1WIDLbLdvJZLq4BMxffRz81YUD0QEpnHFBeTBmKyIa8ecHaOigO5p3mcYS7oFd1smNbSWzWaZoPIPdDNHBjKJevppIszamApFjOXViNghEd99alNvqcDavTLzftrWyEoFgQ6/oNv+vj0xmd8SSZYJE31pEZBtxTLC72jDlNerFsDmt/ExsnmN37HvGujQCDHQNiB4QQ50+qvHEg9ufsoksjZiBVn7t7+y59klDXHVEAVmsLrrYeQXi7uIcHy4fvaloqoD+eurU/3kuF+uP3UvqiT6cmsQxVSYe5bM212bORu0y/Z6CV5kkdqEHQsY2ZwOgiWdcQ9qlFef6xUmz9Bhddh0iZEsdN9scfzn/YNYl/84avYlO+Cz5OxmYateYZtA/ieWXaA8bk/UXpL06dXNEgw6/gjrcbfIwDKStjtkl3V+b2bZUCRJ/ebLr45XrqylYKX+dUbNXiSMw6kDn/aio29U8BE5+nyiD9eUqF7TyIBm6n6F6PZL027kj8hLK56ciPEAUQ9vhKAf6YDgEUNe0LrjDsZW8IA9tWHTlHz325MEFEouGiazbLCbmephKL+2XBg9iENq94KfUsjdPcR2D3Zrin4TTBIOuE0JHRw7AqxXPa0rCXqTk/2mxw7OFIRduDEVWHhFAksfFhALwjexei0QOx8/0arwF8kB3Dtuves/AVdFIAPT0YQsFHhI4iCMU+Y+VpTg78uEnPVfeO4Lo2oLs8nuXqubZdzHEJEDRkp9WFffLdGIEd3YqHinUnwLr/RB6aF1LjpK7hAwyM4dMP0SGdNIXjK5r+YqD5mLEqNt4VW0oRvpr00LH7DOkESUK+CBxlhvmRJaMCQo+w7j9k0iT6jzGORCTwv8P0u6oqTdl1uKemJrgyc
 dQp3/LhC
 V/i+H+jmKbfAgv/M7F04utEIrJRcWRiIpc+da7fStB0Rx6xELPhLrTO6R8X9ZLuARbYPlygoIifK4Y6PF+HEU+Py+BvNYrLlMzLvu2XvvN470lULRLkegKMZ2gdzK1rIvcFBSBwi0EVgHG5ipbm2J3Cl2IMXlzuTXX9RK3tOwHJ+EQbZ71P6V1H/AE6XCH3PjkkZ6R/nZJ6jy4mSJotiZAntiOmvrcVXosicMVEkvR38G/aOS64Wgq2bsh+QxkmB/dXRvZG+dk7tis3BZtwzqploxPTo8ccxvStDAoyRqSodlc18Cdqxees5wpLMNXmN/EwgHZyTmttannZxMcuYnLQnAaUlBYeZvBExC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 17:17, Oscar Salvador <osalvador@suse.de> wrote:
>=20
> On Tue, Apr 28, 2026 at 04:52:19PM +0800, Muchun Song wrote:
>> memblk_nr_poison_inc() and memblk_nr_poison_sub() call
>> find_memory_block_by_id(), which requires device_hotplug_lock to
>> serialize the xarray lookup against memory block removal.
>>=20
>> Take device_hotplug_lock around the lookup and nr_hwpoison update so
>> the memory block cannot disappear between xa_load() and get_device().
>>=20
>> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block =
hwpoison counter")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> It might have made sense to join both patches? Anyway:

Either way works for me. I=E2=80=99ve been following the 'one thing per
patch' principle. If I still need to update v3, I can merge them;
otherwise, I=E2=80=99d prefer to keep it as is. I'm a little lazy. :)

>=20
> Acked-by: Oscar Salvador <osalvador@suse.de>

Thanks.

>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs


