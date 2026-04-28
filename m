Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7F96FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318E56B0093; Tue, 28 Apr 2026 09:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0C96B0095; Tue, 28 Apr 2026 09:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D6B6B0096; Tue, 28 Apr 2026 09:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 15DA66B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:52:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E7DE160158
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:52:44 +0000 (UTC)
X-FDA: 84708105090.23.4A93DF4
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 10FA4100002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:52:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PLvWtj2K;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777384363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fSaI5CrYdlz9JeGFiodMZfSS16RBwlLh/md29GdDRjs=;
	b=WEntotU0ZdSRosKL+KT9C6WKTbxORGRHkbJpmKvkU8ysLp0s5GWYf/V1Cyew7b36fOmsLE
	s3qKa3sSr4u61mppwgMMk5NC/Tc4767lUvl7Ss+kjPJsfHGcQkdhY2IE0Ouc3zgm4yeOf9
	qcws00/11HteohE7Ki78JiHgJVjGkNE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PLvWtj2K;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777384363; a=rsa-sha256;
	cv=none;
	b=cxGdKv5XYbcZ3+B/OrUg25qNVqTXL0p3+1ZSNqsPRSBoOq7B3awKREr73V3oecYO9kkoHp
	HWYL14zNBqE19WtPbRNd9kl8Gq4O9e6D5LDKglaGtcpEXasNg0FgcC6AJcjwKUR60G+bBa
	aVP+6VP6Sp5gMqZNSZSuwZSnqghP3NE=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777384360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fSaI5CrYdlz9JeGFiodMZfSS16RBwlLh/md29GdDRjs=;
	b=PLvWtj2Ke2MahB3td0bSGKYKjTzfkG+IvdHc1FUgCX5pZrEliuin0HPmkbSev4lLE1xuZ5
	91c8CAMRZ0kVk2DQQYcrCZ6+kVutWaRLe9qP695l/CbKNZBaIi7FtiDooLIuzfl5nTt5wO
	JurL+V4bVaPPf1q+1buipgPYlsOsd5E=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison accounting lookup
Message-Id: <94F5B89A-008A-4EDB-920F-31B4895C2699@linux.dev>
Date: Tue, 28 Apr 2026 21:52:23 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Ying Huang <huang.ying.caritas@gmail.com>, Dan Williams <djbw@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Rafael J Wysocki <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
To: Miaohe Lin <linmiaohe@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gjymxp6srrxd3wtkwh8eqddjkt8jjriq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 10FA4100002
X-Rspam-User: 
X-HE-Tag: 1777384362-932084
X-HE-Meta: U2FsdGVkX19Xmh/Zr8kFdoD5yQW+fqLGkBUQxFf/Vc88xlN5z1O/JLI/xdb0J69aTxdF79SB+7IH8PiIR69MCkGwoLOH1CC9pGbv2iWdhF5Youj2vsNjJDtvnRhQzjzkPFUXky6XSLUfY7G+ulGvrqt5PxbaqLj7RKXdiQdxOFrn2CLz+VUhMoU14h5Dlc52EU2W5/eGX4GoudcPx1adkt3Z7o5h6vHU/VboowINfznjEorpvu60qubyI/KQsbo0s20IWfOKuTEJirU+wQilI4p/ZTQosNu3Fv7rbEpeJKAz090fzQowQWBaoQkHL5y3DYBi02d7VqkRsyGSgRhS/9OOJSEiPT1IjSxXqpIgOYUE9TQC1KKlfV8nx9nXjtHvZzWiOBKIle8BG5aCvSqOxbQ8oDFcaEfFZXOvCi6I+28b5U8yZGSi9HzrW+VHY4JI5br6XZ9ymnKPg04KqBFopHqc4PByhTJsF79ykwgiRFHrRvdnpSOgMt7tY1YgjWP5GX+LpQzfzwZLFFQgfDv/Qhovg5z08nTs9HskA8OVXbipnebqixY3i3sxhrw+khdiMew51wm/ev8W4BQvlvG8BQQBy/N6zV/hRPt9ANFTl8tiQeCcMbC6m1/GBqjmBbRSh/2AARru2WWXDdOOb02wHePq5AW2TdYyQc8I4S3+L41c5Hv9zvBzET6RaTM8zN7/bsM6Yl++21u8tstvr7c56ygnQEGI03FD2dpJjZzGCDb1CWMBq2DJx5jmoam6oYJwQk65pVgiu7CpLr+tgEdqinlK+w/LY5MeuljoMq7H6X818p3JAG8vCsKitah1zvDdJCi10ppEHzGrhnh14wRSpxl5gCI18gbm7Y1TMDL0gKlcV/bzaVnt7m6l2wpvaJcfPNvgugaWUdQFD/ay1lI3+YFD+HL9e/iRm2d68jmn5J78u4dlxhFB9aHkNwFD0bD7SOtV+D7YTUq5vpZM0fC
 BLkuOQ3Z
 91TkYUWfhk+UEl2Ea8u3RBVAWW1b6OaBmBZYnRAtiqDZzn+5TTX5XRkzYeHrJTAmEuPhSiH89l7P+KW58wd6EbuUG+FrMLimodMDOJn7lMvxs8RMhHtjKrTq5DhuKKbHYSnaen41cX0t70zzkBi6WiGWBUiIY7dj+uear8vaJsMic0TGsFoe5Q1iLdJeqT88AOeTQxehD9UG0g2OPpDamo/0nUH8tbql+GPLOHKupZFNljt4IPTxTj+6r0zYXERcjP9+IIkWYZjiqG7bbnMpniTZjko6onr8QkIFR9jgTJjb3WYcbjQAZK9VMl9cito3SGiPe5UpSfdGLjk4cpFcf0GeUbcQLVCQDV8ciJqpCdm9NLeaB/tsbSOoBxmoiCwDRAHF9n8d4odG+71bPXVnlkO5HFCVEMhOf2tMs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=EF=BB=BF


> On Apr 28, 2026, at 20:34, Miaohe Lin <linmiaohe@huawei.com> wrote:
> =EF=BB=BFOn 2026/4/28 19:40, Muchun Song wrote:
>>=20
>>=20
>>> On Apr 28, 2026, at 19:37, Miaohe Lin <linmiaohe@huawei.com> wrote:
>>> On 2026/4/28 16:52, Muchun Song wrote:
>>>> memblk_nr_poison_inc() and memblk_nr_poison_sub() call
>>>> find_memory_block_by_id(), which requires device_hotplug_lock to
>>>> serialize the xarray lookup against memory block removal.
>>>> Take device_hotplug_lock around the lookup and nr_hwpoison update so
>>>> the memory block cannot disappear between xa_load() and get_device().
>>>> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison c=
ounter")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Thanks for update.
>>>> ---
>>>> drivers/base/memory.c | 10 ++++++++--
>>>> 1 file changed, 8 insertions(+), 2 deletions(-)
>>>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>>>> index 6981b55d582a..f76aee29e9a5 100644
>>>> --- a/drivers/base/memory.c
>>>> +++ b/drivers/base/memory.c
>>>> @@ -1228,23 +1228,29 @@ int walk_dynamic_memory_groups(int nid, walk_me=
mory_groups_func_t func,
>>>> void memblk_nr_poison_inc(unsigned long pfn)
>>>> {
>>>>    const unsigned long block_id =3D pfn_to_block_id(pfn);
>>>> -    struct memory_block *mem =3D find_memory_block_by_id(block_id);
>>>> +    struct memory_block *mem;
>>>> +    lock_device_hotplug();
>>> memblk_nr_poison_inc() and memblk_nr_poison_sub() are both called from m=
emory_failure() context.
>>> I'm afraid if memory_failure() is triggered while lock_device_hotplug is=
 held, it will lead to
>>> deadlock. Or am I miss something?
>>=20
>> I am curious is there any place where memory_failure() is called with hol=
ding lock_device_hotplug?
>=20
> Sorry for dumb scenario, I was a bit too presumptuous. But there might be a=
nother possible deadlock:
>=20
> remove_memory
>  lock_device_hotplug <-- first called here
>  try_remove_memory
>    remove_memory_block_devices
>      num_poisoned_pages_sub

Passing pfn =3D -1 here.

>        memblk_nr_poison_sub
>          lock_device_hotplug <-- deadlock here

No. Can=E2=80=99t reach here. No deadlock.

Thanks.

>=20
> Hope I'm not mistaken again. :)
>=20
> Thank.
> .

