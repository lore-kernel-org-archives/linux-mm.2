Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75AC1FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEABA6B008A; Tue, 28 Apr 2026 07:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B666B008C; Tue, 28 Apr 2026 07:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8556B0092; Tue, 28 Apr 2026 07:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB4DC6B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:41:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAC9E1605B0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:41:33 +0000 (UTC)
X-FDA: 84707774466.09.DD0B62E
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA0BFC000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:41:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pIiJUNLJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777376492; a=rsa-sha256;
	cv=none;
	b=e6je3NaTQMpmNa1PrMl4iXTiqBFLKgXw1v2NB4tzOPb8nFKAsPEo9iyo9XvY39UrRrC5gx
	cVr8M61+M5pCVf2L0N/A4rjuDEYzsKzyDjNWCUmA0pV0A/20WQzb3ujK1YQt9/k6NrHYPG
	1tfhchR+XEMPSEL2f4xAe852oHRJLwc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pIiJUNLJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777376492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+jsPUH7mQJKr/e5qJEXXKbdhvPY2r4JP9jCX0gwSLc=;
	b=uEp3gXCFjQW9pzW1IP77wPnvSEkEbyIe5QT/97ROKoB7Yq2WDXW0iEy9evNw8Glgs6+ADN
	tUN4lSaTYyzDut7s3MoNReUIZJRF5hv4QFsw6goyi/o9+0AmSSZvn/BwtI91QplHGYpVUb
	l7kB+qNYQJ6F4wYr5VoQJ0RQ+zTYyhw=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777376488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+jsPUH7mQJKr/e5qJEXXKbdhvPY2r4JP9jCX0gwSLc=;
	b=pIiJUNLJDEg7a0nDy6IgBzhGm0xeJEU9Vnp7iBGKxUjiNh3wLGqmNRZNR6JzTF9lEBzYlW
	7OlAm+Ts6deGD4YSdzZydMQcIJZYzQSUtiJ9757k9Ilptebf/aeTvVYdf8ACq+2WOx+VrC
	mSrB0OIv8hMwIGH3ut84TzpITKIPYy0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <fae6e568-fbdd-e697-8ea4-b12c73750ec9@huawei.com>
Date: Tue, 28 Apr 2026 19:40:43 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Dan Williams <djbw@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org,
 linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <68DFF29C-B3CC-4950-8A8E-7D42350939CA@linux.dev>
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
 <20260428085219.1316047-4-songmuchun@bytedance.com>
 <fae6e568-fbdd-e697-8ea4-b12c73750ec9@huawei.com>
To: Miaohe Lin <linmiaohe@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zfcg7ui1mtngnoxoqdr3tn7xcy4yoc6b
X-Rspam-User: 
X-Rspamd-Queue-Id: AA0BFC000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1777376491-753286
X-HE-Meta: U2FsdGVkX195piV2EXPVz727D93nWiXoVqQDynnqAa2xOIYeJBeFlTy1U+9vCHN3fj7fHwHpPSiPw/l4GeMY624aWZ2XEVTnvP2EAzZ+lytXYHzZ24VsX82W6rFuwzfXSqkNU4BVQslpxLAIxCylLFa9JLXiiBJa1nr/mGoGEbWCPsBlOpbl/CZ3UXhLSakQf8ponpPb3f6fjh1YIaUtp3STlGYIBdUjMW3/x4rMowzXQ0Jqh2bmwnQLlPjeqaqv7tOvVly4dbx+ntaITWIMVuq+VAMWgsLaUxC4H/XTj0b2k6Cd+3y450/YvzI9U6DANmLxCJYJNvjf0rKLfalgMVRpMwM7gpvKown85vnhTOApKCeT+0ONzCZxYa1BMaoo7DRDU39E8jnhYgZ90H+vlGPFmxgvtBhLRb/L/pfIkrPbggMLXMGUEEnheKaEfWGzigWPaqZXJ5Dd6X0W/A8TxzavYk3BxwhNx03nH0+1+56xZ43JjzzhT6hd6rg+QZHwW+4VbLfP8TaHlDBeaoIThUrmtcGP8MaU+aEWL+EIMZ2EZVvc6OCgB2+M1OTmuoWaF3m31RaYQyJqh0jE47TWRb6zgMm5TdERu1YYGfEQyauzBLDhlMIAJekZX1zMsA8DQjGslKBfeg6DTdlZgnDz/yFplJZnWGkoWAhfmdeg0fhR73XTDycpdeGH5VGq9I8O7AQwR9+uIT1OHyDxvYsABKtBFrLYWK8RdIkw+T2YyN203m/PTLClLXxOPMd2CLRltez7LYBVDoWbNzlEI3TDNsOZiqM3FiloKGTOzRYJtV763/3tZSse1Ib+7rtPkQmeoMAwXxw73jSVMyB+n1Djm/sYHNEEInUCdpwsxZEn5KfSqnkph/8bTi8MPflI7LmRSJmVtnuQrANEcnqgSg4bKXmrMO5zh2Ov7BnUTsun/rWh6UWHeA1yZx2MwV4xoPdBb2F5Y4mHKW1x5hUEZeB
 r0ty/vkN
 mKR0pCZHDw3rPhK1v655Hy5OsRwKwMQwgwaD2YGT9Vvy3LrbzXgI90xlk8XLzMWC9CopXXAU6FFa0RUI4AO/3s4jFY3AJqvBabQwNXmQZkfW0G/UfeQmai6NoTy5ZN1YTT/dJQBcZRUYAEYXs/LPdbRq28pfzNswjXa/o5o4EToCeqHQ08aCLK1Z7gMaWHR+MHIvgAsJeFrWEpg6G2Z7j3IyvFWMgz8/QlHOX/hp8j9VrQdEQtZYzz/S4CIek7DMHpOHvdTsJF7ife+SR2+m14JKpUA/3T0eyFF5+da879Oqj9raHDINvWry33Hl0ztXIb61iWuZXxBqWkcB8+DXrk9Bym2SzkkDxOyaWlM5jHMgqF6sMObwTpJ4Vh2pPZw59hVLG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 19:37, Miaohe Lin <linmiaohe@huawei.com> wrote:
>=20
> On 2026/4/28 16:52, Muchun Song wrote:
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
> Thanks for update.
>=20
>> ---
>> drivers/base/memory.c | 10 ++++++++--
>> 1 file changed, 8 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>> index 6981b55d582a..f76aee29e9a5 100644
>> --- a/drivers/base/memory.c
>> +++ b/drivers/base/memory.c
>> @@ -1228,23 +1228,29 @@ int walk_dynamic_memory_groups(int nid, =
walk_memory_groups_func_t func,
>> void memblk_nr_poison_inc(unsigned long pfn)
>> {
>> 	const unsigned long block_id =3D pfn_to_block_id(pfn);
>> - 	struct memory_block *mem =3D find_memory_block_by_id(block_id);
>> + 	struct memory_block *mem;
>>=20
>> + 	lock_device_hotplug();
>=20
> memblk_nr_poison_inc() and memblk_nr_poison_sub() are both called from =
memory_failure() context.
> I'm afraid if memory_failure() is triggered while lock_device_hotplug =
is held, it will lead to
> deadlock. Or am I miss something?

I am curious is there any place where memory_failure() is called with =
holding lock_device_hotplug?

Thanks.

>=20
> Thanks.
> .



