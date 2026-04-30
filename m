Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E45CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07D76B0088; Thu, 30 Apr 2026 04:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C917C6B008C; Thu, 30 Apr 2026 04:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7826B0092; Thu, 30 Apr 2026 04:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AC2D96B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:00:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52C68120588
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:00:48 +0000 (UTC)
X-FDA: 84714475776.29.90AD841
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44D69120003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:00:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cqGR0kT8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777536046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4A6wwPd/ZSj0TC/HEHCOyDVduWypr9xbHHX7OGSc38=;
	b=1vH1/SSezlfnUSicP4IsDsg9if/xiHEPiM7bbh/Pluk8TX9jUL5RaJEYe66hsk+vEUSopG
	02NVzSxAlXXdayLm1Nn0D+xd0t22MaS4HAsVeIe0uk/5zN7No6uO5d9CtWQnW+Bb5MHOi6
	ZRKZi2TLjTaArvqU3NEP/FPRl+hZlYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777536046; a=rsa-sha256;
	cv=none;
	b=vlWpWhloUlVnEApkW0VhAvN8w8cDfCYUtCHmQ1mvR39XV5q5jzs9yU2pEqj1jH4tMsntrk
	8/7qgmRct4FDYelK7LlFF7Uqwau7rfeJBVyeYNGLAIxaalqRcUYhC8bpDphqjNVbFZ3fUu
	PcZkXzM2jUP5SxfxQGEkrF3i1CyVhZ4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cqGR0kT8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777536043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4A6wwPd/ZSj0TC/HEHCOyDVduWypr9xbHHX7OGSc38=;
	b=cqGR0kT8YoGyTPyfnvPFCbwserdf1FLjN/yQXTPkocffUQHDm3U+VUtUUu2fiuMlqEYSSv
	cnVkEmse2/Cj/svvt+OdUgzyZ8kaVKh+Cohi2PlJ2Dx3BSPWqgqDwaYBpaHZCBSQn4JO8m
	Miq9YpF5ZyjrSAJTnBUrQRHoscQNybo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <b67ff3f9-8661-45cc-b408-6a7b611d31c1@kernel.org>
Date: Thu, 30 Apr 2026 15:59:33 +0800
Cc: Usama Arif <usama.arif@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Muchun Song <songmuchun@bytedance.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Dan Williams <djbw@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org,
 linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Rafael J Wysocki <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2C5188E-76BF-444C-BF2D-8BDC1410BC61@linux.dev>
References: <20260429101134.1358607-1-usama.arif@linux.dev>
 <b67ff3f9-8661-45cc-b408-6a7b611d31c1@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 44D69120003
X-Stat-Signature: iapnw84w14wqo4q1k9ckstzzaku676bx
X-Rspam-User: 
X-HE-Tag: 1777536046-452551
X-HE-Meta: U2FsdGVkX19FMLi3EcHYsZX4P3BcR0YZWCLSM3QqSyc7eU6tQHL8cteBBVoqI4qFauxdEYzhYnyzekdbWBf8h0SrGD/8nph6AuMbTiyneMTmrYqtCTFz49IAhF8qU+8GXIOvG09sgI+pQATkNcrz6PqzVVvfr6kUZdj9ZB1jG70XpbxJmwtl3fJoUxba4TtII10Xm+8Dei/xSvb9ejCCk5r2ElJtajDh2KsrXFN67daMMWsiJBPo4yrGw41yLrPY8y3KKk35Wn3Q3UCpe8kT1G/AhLXlF5/mBqWQCRXstqfTqCACi5AVoDQyu9bixeCwMsH/50n1JqbEDdf8nfKrBKXqgmZk1B49qsVSrnwMbXlwnX1ZUSGNYeUyvckudOrKkJR6k1Cf/+7wnfw2gvXwqAODsUViZ+aRLIU14XvNfM6vRH3mp+6icCp3cRzPoniXQS2EAxPp85gW+4+3cIAIy4ebHe+O2JyEzWQXJh9ZUuOvsPLqZoFzJ5AxYLBMHBK9J+1AI7XYrGmObo59BYoalYYevY1j/T6IWMvaeTqHHPOnifLVb7XmSJ/ahm0SyrPzIbMeK0gdYZ6rJKilX6IPKAbz8jKyApDpRETol65jBqHipzRb/Ie+99oRC67DgGw+ljGZWG/fVii7GpSKK2OuCovLq+iTBDzguejAPCA7VsbV76NsxYABSLIV6qWy7o8+jAMs43/HJyuuIlbdqyXisaV3QgEOwaxY2TRDQH/EKgnBIpzuei0SmqDHqPl6gnAmh3aDjFGy1G3mAOX9k6C6qceWnfF6aaGPi3ATx6awnnuzBhXRdv4GsyuNlf+nFXHfMoMNOGA2v1WS7txdMXj9pFTbGRi3o9ZjjHy6fKfZD79spplh70ULzpBh+I0LYZgUFIRrVoNjuFBiSToBQ6ZbcOtz12VSXIFrhTytMUmCmsQlk4HZhE16flPN79Wef7PG6Tgt2bBfoK3lIWHRk5t
 fZaZVFW4
 AKpPztbVaZyEpSzYuj+YsRY4PwSO84EKvsdrJRx1zlU6X0qc9J9JMwA2pm0OJBf6S1zgROmKXjOo1RHpR+NtD0VHRfgWJKg4GKJAniwbtgxksoXcVGLY1Uu6r7fZZ7+cUVVjuW6e9RtR1IcGVCL3qxNwLYkodsETTFGC+rU9+Xdrg5/CBUt5JHEJFxjf7ecT4YThAm94ZjHlSTMvYZ9u4Mr8LuIzXTxgU6gsfjl3ujHCkHUC2vgFkl3rgygk1IpvzDaS6EH1nYIP19UFAB8YGCmaK4y0eZZLAoHqTU1BZlbxg2UOjF3pDqSfXMBaAeWFXk/yBcKqoozGoH+BZ56+ozW5IVCTWfQ6uHEzojfxS+vgUKaBni8Nmcq87lbmz7/FEzWdaOEEaoHHh1H7vgvGbetGvAIiwrYra5XqF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 29, 2026, at 18:44, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/29/26 12:11, Usama Arif wrote:
>> On Wed, 29 Apr 2026 12:18:08 +0800 Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>>=20
>>>=20
>>>>=20
>>>>=20
>>>> lock_device_hotplug is a mutex lock, and we already take other =
mutex locks while
>>>> holding lock_folio in other paths, so I am not sure I see what =
should be special
>>>> in this case.
>>>=20
>>> Hi Oscar and Miaohe,
>>>=20
>>> I saw sashiko's report [1] related to folio lock and =
lock_device_hotplug.
>>> Seems it is possible. You can correct me if I am wrong.
>>>=20
>>> [1] =
https://sashiko.dev/#/patchset/20260428085219.1316047-1-songmuchun%40byted=
ance.com
>>>=20
>>> We could fix this by calling action_result() without holding folio =
lock.
>>> What do you think?
>>>=20
>>=20
>> Hello Muchun,
>>=20
>> You could end up in memblk_nr_poison_sub() while holding hugetlb_lock =
spin lock
>> from get_huge_page_for_hwpoison(), right?
>>=20
>> Lockdep would flag this as sleeping while atomic when acquiring mutex =
I think.
>=20
> Another thought would be, that we always call the inc/sub from memory =
failure
> code while we hold a folio reference and the page is not poisoned yet.
>=20
> That way, memory offlining cannot continue and the memory block cannot =
go away.
>=20
> So we'd let out page reference keep the memory block alive.

It seems unnecessary to hold lock_device_hotplug if the user already =
holds a
refcount on the page. I'd like to drop this patch.

Thanks.

>=20
> --=20
> Cheers,
>=20
> David



