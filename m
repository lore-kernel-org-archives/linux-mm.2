Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF3AFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391016B0005; Mon, 27 Apr 2026 05:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AB26B0088; Mon, 27 Apr 2026 05:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2206B008A; Mon, 27 Apr 2026 05:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 086316B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:17:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EFBD120781
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:17:36 +0000 (UTC)
X-FDA: 84703782912.25.9869CCE
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf21.hostedemail.com (Postfix) with ESMTP id A402B1C000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:17:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BBiq1pXq;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777281455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORHngxvyZgMWhS/hIL5qRYN26UMVGb5ngq+TKZyDg0M=;
	b=kJWMAEkOjMAObDO6045SdwDHyZchQ7Vq9ER/qHETX3JeGEze/Hdeo3zmAKjOJszD7mzGNd
	2tATkFK3zky+doMoqR/eIzn25unPPZ/3FXTPVC3sLlxsw50Be+pmPJDZ5jpQfCAZRXpv55
	jtR38MAPNVNvAKyL/B0bqHw7eeBLySg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BBiq1pXq;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777281455; a=rsa-sha256;
	cv=none;
	b=tXIHeqXH5rsSsc/LilJeg5lcAJwvzhiNXRG+SP5KAF21pwrzM5zus/P/gqBnMg8MakxnHk
	FD/wH3Oh3ch7NakWnIenAB2MetVMsHjM6N9FlNHavrhbnye+wAXCntxh/D1nEUML+cbXTz
	fEAuKfO0itwDCZn+YMr8Yd1nHbepEO4=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777281452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORHngxvyZgMWhS/hIL5qRYN26UMVGb5ngq+TKZyDg0M=;
	b=BBiq1pXqeKCV203ZvOj67Z/33UqGDuxwcoU8KXnRwokCLX0JGoGrycz9MVzJYt3sNvUY8w
	UItlOVhAetp7joyoDg60oTEh8L6qIGXkVzKLM50YvpODxYKTt9bRTIav1HhkIRprYXXVqa
	xoUBLaui1da4tTR732wtjHotyKLSyoY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 2/2] drivers/base/memory: fix memory block reference leak
 in poison accounting
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <7fe73023-1fd1-0c10-107e-5c0f47383453@huawei.com>
Date: Mon, 27 Apr 2026 17:16:34 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org,
 linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D07C436E-E6BF-4E6D-9431-48C496E350CE@linux.dev>
References: <20260426144447.817722-1-songmuchun@bytedance.com>
 <20260426144447.817722-2-songmuchun@bytedance.com>
 <7fe73023-1fd1-0c10-107e-5c0f47383453@huawei.com>
To: Miaohe Lin <linmiaohe@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kxz84q8ao6w7xqxte7od5mgk4nz77xqq
X-Rspamd-Queue-Id: A402B1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777281454-488916
X-HE-Meta: U2FsdGVkX1+nNdZ+u+C7Xncy7U04snJ9ItvjBVhsTpFExwHo0pgpLTHOnKRr7+DC2a4nG7tQO6iUDZA60f+CBohXRPB2sdGfbXX5DG/ljvU4zeitHWwzbn5owkItiY8Z7s9R5QRcYc0Nyge2xGX4ksBwE7kPF1RwFPkddsdfQrmcP9aNCPe3I0hsb7xr+6AkyjUwlJ0V4iUC1EDVc43PKEgZHl0rHlGx8vj9TilY007C+fZtGUxikJPMl6FZFi0iIizPCGrrJkfH8QlPmAfFLFwVHcVCIj9Qsi2eoTN5XVYvclEO/49TYh7jkk10haZL7fPyurMlOun5sqtmB1z/4SARtGRbBBDRM3BjwhEcChqE+MYDkoJZbz8pazKageMn3j6jShIR0xnhelKqBSAxH7P4a5XHbTy6WuWVlH5Nimv4yyqWdvYUEfKb6mjtfncg3ObEZExb8Ey0GBwRKRy9Sp5eQbuabtZTCO0CI7WtW9tI4Lwz8k0do5hscDgj0gZNk8Koj8bClQYdaT5Z7vgCgIvz8jEg3pa3tB35gQ6YaRwyL0gWSWZlW+GexSDzaUJivSH+JsNi3n8TgkfXHp4nUGdlwpkVDepG5FRaow7eCZFpACCTUcoLlctnpmJKN74DwbyDj3KaiEIy+5kc8fsVz1zJkzw06hE0iP5+rDKmMTXae6TzE3zCS2J/NmmCwzbYDlJ31nNpVUCRGR4s5gA9QE2DpzwM8k9dBhJYMiU9JryUfA4gwvI6jQuNDrJmivibK5W5EbMiGqiz3a8rkC0oGy8azbhtXhPKvERFIig+gnbuVBSq5DPhSPRT5JGCbuuix6P7DCOp8FP+hD1nO5WltmtOWhDjBD5w9lPfaEOIgpDpx84szY9JrGF+QEeyhOgwfbGkLcwgEkqMsqgCOm7aXkahrNtHKworF83eGoaH3vUjW7bctJ9Uu4G4BckXWu2xzViiO6soP3AS3YuvW3q
 t6YHY2d/
 Pmbb9ya1ZoH3bzlKAfNuh6rVv2t/Yt2JI7wzSDbSaBukBua6pggfyrIbTUoqW1ScULJ84SHBulknAu79nBJ3x2mpm2uOfS6gLXVoMfpiAf6QEsy84HcwSnKTCTYlTmBoxB/nZraZ9hUj2eDbksv3MG7MH1dk2eUwZLZpOfX1c8Npo8EV+EAaMZJEt2faxQmRyj9LlsuIvPlDTibfk0BSxNvacAltgOhvw9pqcDtobOHlyl4nzf9K7z6+cs1wnVFfIteS02qSIcEpVcuq7EnbGkVvuoFy20+4yBf2K6gFkiDZn5Iwuf8EcLdlSw4WTsVa8gmPq7s1M6Z2YKRDMj/5F1zCLIlIZBkFJSQRthtntBfa/l0EL+KjTSw84DHxl+rd5cV+1EYVpVQxWyMGXUpAv8sFSi8Q3h/qFpjkpDfxQaUklNDG/AhRXO3/Q4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 27, 2026, at 17:13, Miaohe Lin <linmiaohe@huawei.com> wrote:
>=20
> On 2026/4/26 22:44, Muchun Song wrote:
>> memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory
>> block via find_memory_block_by_id(), which acquires a reference to =
the
>> memory block device.
>>=20
>> Both helpers use the returned memory block without dropping that
>> reference, leaking the device reference on each successful lookup. =
Drop
>> the reference after updating nr_hwpoison.
>>=20
>> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block =
hwpoison counter")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> This patch looks good to me with one question below:
>=20
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.

>=20
>> ---
>> drivers/base/memory.c | 8 ++++++--
>> 1 file changed, 6 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>> index f806a683b767..6981b55d582a 100644
>> --- a/drivers/base/memory.c
>> +++ b/drivers/base/memory.c
>> @@ -1230,8 +1230,10 @@ void memblk_nr_poison_inc(unsigned long pfn)
>> const unsigned long block_id =3D pfn_to_block_id(pfn);
>> struct memory_block *mem =3D find_memory_block_by_id(block_id);
>>=20
>> - 	if (mem)
>> + 	if (mem) {
>> 		atomic_long_inc(&mem->nr_hwpoison);
>> + 		put_device(&mem->dev);
>=20
> Comment above find_memory_block_by_id says it's called under =
device_hotplug_lock.
>=20
> /*
> * A reference for the returned memory block device is acquired.
> *
> * Called under device_hotplug_lock.
> */
> struct memory_block *find_memory_block_by_id(unsigned long block_id)
>=20
> But device_hotplug_lock is missing here. Should we add it?

Yes. Otherwise mem can be freed concurrently. sashiko.dev reported
the issue as well.

Thanks.

=
https://sashiko.dev/#/patchset/20260426144447.817722-1-songmuchun%40byteda=
nce.com

>=20
> Thanks.
> .



