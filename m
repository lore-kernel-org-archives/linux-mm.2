Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62042FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF046B0005; Mon, 27 Apr 2026 04:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D66E6B0088; Mon, 27 Apr 2026 04:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ECFB6B0092; Mon, 27 Apr 2026 04:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CCA16B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:03:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 410E91B91A9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:03:27 +0000 (UTC)
X-FDA: 84703596054.25.EF5936E
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id 72BC1C0011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:03:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R9TE17hN;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777277005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F67ZdaDpjQQ9ZQiBFJStgZjfeCxvByxk+MVNwDskpX0=;
	b=V2Q8fjRezMjB4KenJJW9jCTZC8zHE5DtM3Jy5hkrU8mWATne8lT+lPGbLJu3pwp75D2Eqn
	j7wSUUI+6ZN04LR2+rVJHb1SjDRLKKZS+EKjzHs5KJgbbheVRZqvbYCP+Bx9lCrLDt/lVo
	hrqh6F4OT3rDUt3vIXD/YWgE4p/rCSg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R9TE17hN;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777277005; a=rsa-sha256;
	cv=none;
	b=iXegRCXc5rogu3mvkXj0uSjLKtT4q6o2d+mKiK8E8oO5G0r4xqvHGh5X2tT8q4IMZDTazL
	pKdDeOgbyJolGYUQZPc/EsKJOSGUhceQNC/eBostj+X3lXuHpzWs2HeF3gtZAjdJskELCJ
	mfkuy1gMXsb/bSrNV/V2MSK0sRwnp38=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777277003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F67ZdaDpjQQ9ZQiBFJStgZjfeCxvByxk+MVNwDskpX0=;
	b=R9TE17hNB3dUDAgpXvp0H2Kc6X2wK1PO3oZsQe0mGQJ1v8l9nixxv+AcfB+GHGRRfmkltS
	UplpfiTNaZMlFiMihyhzhij0rvpjIS4kecGyyczoKq9dreI2THiOh/+zXHbX8lC1fm27ur
	Dgl6SLpGQOKusEhAzJO72dmGcSymILw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 1/2] mm/memory_hotplug: fix memory block reference leak on
 remove
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ae8U73RyTE2a6bdp@localhost.localdomain>
Date: Mon, 27 Apr 2026 16:02:17 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org,
 linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7887915D-E598-42B3-9AFE-BFFBACE8DE2D@linux.dev>
References: <20260426144447.817722-1-songmuchun@bytedance.com>
 <ae8U73RyTE2a6bdp@localhost.localdomain>
To: Oscar Salvador <osalvador@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 72BC1C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: yuhd661thygswyw31nhoa7b5o1ssnobg
X-HE-Tag: 1777277005-587200
X-HE-Meta: U2FsdGVkX1+JKhTABrCfj85j6mZqtn4UHZvzEYeLHDDqY/LEdWg9u529wvu95PC5bqcc2NlSSY4Mb1QEZW4nEWZXlLeqdLJFi3n0zpYretbA7L+ti/sB6AbzB5Y7vAigekOdIgFwSe0IevLfeSzubpgUgSngcpTJumafuVr4iBbVeBBXREuN8RT9rDGoxisTOKWmtS9f3S1SOet3u5A8IBLehL2nH2P4iCmsKCT+vJve1xw+AoT7PfaBy52Qg8/IYL+RDZhalDa68I2eRx6BHS0B57zuAZNP2Qhe5jA+z/HgCicoYoH/hlIsO70cSp7Z/H973Nvtuo62FySTekDFSZoGhMrEwcGtac8RcJpJkRR43Cgig+gWxjSduNv2G4cVCqZlmd0e/3sOYrKuPqlyhfiHFgYrz+HQMQaEQcWR+VLG05OsAu5rPNFMqCp+nlTmYEUfGUakButMvRb3aXc6IlWQ9R95BHqTFTUIZdqw0n5Yp6dn0yLfjR65efFao/0y2JjTks5MQ/LW4B5zsWdmo8LzTSUB1rw9VRIll7bmlR2FVJy4bLgphKnFA8RgmKvuK5Td6qaQXWtOcz9GJgBTa+T+8pZgdqHOJFaVeX73oLpqo9oGTTvwG0053dmc6jxkLKBy1mSRjZKtmFiQ0QLJePYVCsF2xLZA7Zrh6ud6Y2oT3sDPjnzZyqdGFqswpJQatti1rKkgZZILedaVKVHacSxK6FCxtbyDYNLJmfJNF1QXjcLzDjv5JT+scdLFBJgRZNrCX1NHuYiUoYpCsoshxIKWrfrbEiVHWyNdroIOajgwTYKoLb6U7O5vldKK9upuWT+WSIYhnw/WgwKJJNCuS7EMDuq1nlkbtyqDXeaLkir2Rs/4V9pSXQbu/ZWf5cQt8uFCGhL+8O0LBEe6xhddh32cTndF09i8rZBZpfy3gJVi9+E7zucoPpS96YlMUz9huaJ+QKhrHc+CieRAc0d
 DGu013ut
 mh7OD2wOQfYWabBVHv7pfXR7Q61MyyxHFm6XuIE+aYDLxlVJK4Y870jq4UxZJe7lkiXfLkI0XsRcGQ6hhkOdk4ojUHOOiTtI2RHVb5yFEwgk7PaadeTwY+E811MoFHCvvTdwYbkOdWuVwGK68bq5xY2bVlESofHeu9mNpZDWNPwDxkRA23KvnHofN2oFWjCiX0CcAiFwHxziVXFuuGGmb+Xjk1vHBQe+tHQVp70MykACYKFvGn91sRuMqp3fzbPauFOmwanKLPdpZ4jFtlaY5N1D1eiGy0HTCSkyS9c2uN3naE81W+8dQ04DlhI84zg1s0irdlU9OPeywSKiMVfdey94asTZqDLJeZJzFqqtdW8KwkiDtZ5ZAnvfbkjJrFr9xDXW+Sz7uv3CFYaqzhJ1plinbYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 27, 2026, at 15:49, Oscar Salvador <osalvador@suse.de> wrote:
>=20
> On Sun, Apr 26, 2026 at 10:44:46PM +0800, Muchun Song wrote:
>> remove_memory_blocks_and_altmaps() looks up each memory block with
>> find_memory_block(), which acquires a reference to the memory block
>> device.
>>=20
>> That reference is never dropped on this path, resulting in a leaked
>> device reference when removing memory blocks and their altmaps. Drop
>> the reference after retrieving mem->altmap and clearing mem->altmap,
>> before removing the memory block device.
>>=20
>> Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory =
requests across memblocks")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> The change looks good but some comments below:
>=20
> Acked-by: Oscar Salvador <osalvador@suse.de>

Thanks.

>=20
> The outcome of leaking the reference is that the final call to =
put_device()
> in device_unregister() leaves the memory block device linked in the
> system under /sys/ ? (besides not deleting the struct I guess)

I think so.

>=20
>> ---
>> mm/memory_hotplug.c | 1 +
>> 1 file changed, 1 insertion(+)
>>=20
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 2a943ec57c85..4426abb05655 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1422,6 +1422,7 @@ static void =
remove_memory_blocks_and_altmaps(u64 start, u64 size)
>>=20
>> 	altmap =3D mem->altmap;
>> 	mem->altmap =3D NULL;
>> +	put_device(&mem->dev);
>=20
> 1) Six months from now we might not remember why we need to call
>   put_device() here.
>=20
>   I would put a comment like remove_memory_block has:
>=20
>   "/* drop the ref. we got via find_memory_block() */" or something =
like
>   that.

Make sense.

>=20
> 2) I kind of dislike having an internal put_device() lingering here in
>   memory-hotplug code, it feels like it does not really belong here.
>   Ideally we should have a high-level function in =
drivers/base/memory.c
>   that calls put_device itself.
>   Something like "put_memblock_dev", dunno, names are hard.
>=20

I share your perspective. The current naming of find_memory_block_by_id
is ambiguous as it fails to signal the internal 'get' operation. To =
improve
clarity and reduce errors, it should be renamed to =
memory_block_get_by_id.
Pairing this with a new memory_block_put function to wrap put_device
would ensure a more robust and intuitive API.

Thanks.

>=20
> --=20
> Oscar Salvador
> SUSE Labs



