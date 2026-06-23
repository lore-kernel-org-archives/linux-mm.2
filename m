Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F97BCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113606B0093; Tue, 23 Jun 2026 04:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4E16B0095; Tue, 23 Jun 2026 04:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5236B0096; Tue, 23 Jun 2026 04:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B88726B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:19:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3170640422
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:19:10 +0000 (UTC)
X-FDA: 84910477260.21.B8EDCF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 841BD40002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:19:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KeN6hTky;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782202748;
	b=UBldsHex2/4iCN17xuz9EBD0jhVrJ28QokoeSeD8v8JKP7jUpRumvwOQSF0qEZJxfjrDGW
	HwiFtZLi1Zb/3mrLBiTKrKKkCkWROeLsXiAuMmh6VpHwPFrf8EObdpSK/ceKYtSXiMv9Gx
	fC1zLA8de3CsUVSRGgZPSNbOB/HVewU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782202748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUQHwxZu+8soINl8NscGOL62ssMYJX5NpGP960zta1M=;
	b=Rf/GFKPSgxonFpdMfx43XhYz/XkyC2X4m3mrVRCwNMnHVDwi6y0uHMw1wPAoAnqDZlm8NP
	Elf+7hpUpOa9NasFHiloKzAWdc6fMAg9sJkgKBhe50XT1/SXP02QIscwBHs7WMqD7UQF2f
	IFVp/akmFNE62qfAriJ3yto8sKEGlrY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KeN6hTky;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 088A56001D;
	Tue, 23 Jun 2026 08:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7531F000E9;
	Tue, 23 Jun 2026 08:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782202747;
	bh=BUQHwxZu+8soINl8NscGOL62ssMYJX5NpGP960zta1M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KeN6hTkyM+SruNEXlShOJVdxLmoZbsIgiTn8Yn7+h3UjKVk0/9FStM1Vpunci5w3X
	 EaOJlKpAGTWG+RXcKsdwm370+f4fN035xpD1oBbst/+WvzefcQKfVmoBop6ID/QfP3
	 RMTQgJjmmU159/ZSRHmZYcws6UnBMwBhoPC8VtvQb7PcltMb9Qcn/yCnxBYPQ3QIoQ
	 EUWe+GWE/RIn4ayn/vbIizg4s508nqTrSE2EqtX72U3onnXAf21nrLw3s6PL7DJ1GU
	 0dbUWUAxhDM0kDjya31PpOhWUu2JDcgPu4yqipGO7Xos2A+p2am1hXVzmwLdzKc7z9
	 SImpfQZY+ITgw==
Message-ID: <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
Date: Tue, 23 Jun 2026 17:18:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260623024237.45990-1-qi.zheng@linux.dev>
 <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
 <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ULHFF9fXbXcUf502veQMDaYL"
X-Rspam-User: 
X-Stat-Signature: zia7pnctxunkb3i63ocrb67fa4toskxo
X-Rspamd-Queue-Id: 841BD40002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782202748-719836
X-HE-Meta: U2FsdGVkX1+10B04x8TOS+89A29QHro+CeVzO2ZK8VzuBM2q0hFEIf484n8pCOm6emZc3V0GE6nFyorbV1H9whqGpe1re355XD3zJnbACnKFDzsOlTB4MgfY0McPvY/4QCqHffWQU0g9kmj9zITSrc0Os/Xxfj7oc3k7EaGkjPrHVN19k/xX0XONp+cgxQMUqUYeoL+KV/+gJ69QOlfMVJ3pr2W22ABIRjNzXZKIXK2yXxvORyBJdSPebjVrXBWtOMX/Wx3bZqnW+xf4ZURszyNFDIfKU4cNZeL9xyE9E/RcJLAmbzR4kpYKVAMu4LXXbPxf+2enUQx4gSNCZyFUDacWGqi9fD2ZnKejo5cXH5ReftamImT0PjZuKcstPI/+BCfim0haDbD5WQxmcNv/QPhnBxIDS29FbTJxiCm+EzAm8Z4AVSRSefJaDAwm3YxFqCisapXxGVscq8IQLsF2Ghzppg4bDYbK8+poo2mE55ubEIMmy90Zt6SAMy813u9ojb4EwQdIwe3Bsrmqj0cBj3Jw+saQSNM7QsYsoyF8EVIhsgROMB1gAx9HFcabsEnbseu2ZDMeXgbkxE9eDndw2tbXxqTzQRN7QhVvwAsRD4ZpOXwjf+VxuDJPFMMmQD1W0nJCRbuLuZl8Q4kGb0feVsbgYaMNCFXa/BTvZTe9KeaLZixE/EL+SS4ZD8hQKMpDJKufbKviO5QuDJ7F2Ic3DkezqiAh0hh63zME4izYwGI+RytXy+zbSiliF9KyN1hFCSrhRKvUQwCqAiEWd5+/jiKqS5570AZtK2I7XcvJFsFQTVcYh5IXVf3CvUW1WKQUBlVrtkYjLCpYqu0S0uIpx/k1Pnd38zWy89y4QjrpSRvc6HYpnFeR6K6uO3MqWVZINpZdQZ+aUBUdXsVEVnON3SWAJYuL99nRy6xg8/v0G7wzpvNSwfIQx9yZx85MF2TnjT5aoW8azzZLEfWA/Qv
 +BkrTGRg
 74TVGr8aZVYSfuBytF092gszffqBG9wXDKNDtaCY5LO8gla8bcNE3zXwUtnKBE/1Qk0YCUx3VkefEL7RUFuI4aHOCItwddtRmEkK5GM6K8w64c8CiNYLsqspGqHlXzy0pn36h54QNvcdbhBWy/dqPPRc1EJ+38TaY/bJCRvwTVz8mohM0G5c5Pmi8jo14RJQ+QHdj61Tw2I22nb7TiLZb2z+LgrGgdC8r9+zdT3D4fcUtHCX0XK2MDDWtWt0Skgx1lEgLiJrTCReKeMqAWLH0+79Kc6feWq6XyQvPtSwuW89NWkcjb/6fdxIgEcozJacPOEHQe/y41eYLZJgV7j3fbx+zipuP9ddl3wbZ/dWZ9iczgsqq52pegq6Ht1gO887URQ74xufYaeURaaLsL88TITjRGzqMCon5IKPWpPQgv0GYt+6601pU2g9P07VdqXOL8bdb1qLAGKmKzHGYbcV3KE9SNQqwMzUmzka6q8I/g0wng9iZU1Uv0g4vvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ULHFF9fXbXcUf502veQMDaYL
Content-Type: multipart/mixed; boundary="------------xv4AXOs7gLhZWtRvpHP1aUpZ";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Message-ID: <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
References: <20260623024237.45990-1-qi.zheng@linux.dev>
 <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
 <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
In-Reply-To: <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>

--------------xv4AXOs7gLhZWtRvpHP1aUpZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/23/26 4:16 PM, Qi Zheng wrote:
> Hi Harry,

Hi Qi!

> On 6/23/26 2:17 PM, Harry Yoo wrote:
>> On 6/23/26 11:42 AM, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> The mglru page table walker batches per-generation size deltas in
>>> walk->nr_pages while walking page tables without holding the lruvec
>>> lock.
>>> The reset_batch_size() later folds those deltas into walk->lruvec und=
er
>>> the lruvec lock.
>>
>> Ouch.
>>
>> IIRC the user-visible impact of underestimated nr_pages in MGLRU
>> was premature OOMs because MGLRU does not try to reclaim memory when
>> nr_pages reaches zero, but there are still more pages.
>>
>> Perhaps worth mentioning in the changelog?
>=20
> Maybe this should be placed before "To fix it...".

Thanks!

>>> The page table walker can run concurrently with the memcg reparenting=

>>> path
>>> as follows:
>>>
>>> CPU0                           CPU1
>>> =3D=3D=3D=3D                           =3D=3D=3D=3D
>>>
>>> walk_mm
>>> --> walk_page_range
>>>      --> update_batch_size
>>>          --> walk->nr_pages +=3D delta
>>>
>>>                                mem_cgroup_css_offline
>>>                                --> memcg_reparent_objcgs
>>>                                    --> lock lruvec
>>>                                        lru_gen_reparent_memcg
>>>                                        --> reparent child folios to
>>> parent
>>>                                        unlock lruvec
>>>
>>>      lock lruvec
>>>      reset_batch_size
>>>      --> child lrugen->nr_pages +=3D delta
>>
>> The problem here is that, while grabbing a reference to memcg
>> (via mem_cgroup_iter(), for example) makes sure that the memcg is not
>> freed, it does not prevent offlining happening, and reset_batch_size()=

>> doesn't check whether the lruvec has been reparented, or the lruvec
>> is going to be reparented.
>>
>>> This will trigger the following warning in lru_gen_exit_memcg():
>>>
>>>     VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>                    sizeof(lruvec->lrugen.nr_pages)));
>>>
>>> To fix it, add lrugen->reparented to remember the new owner of a
>>> reparented lruvec, and make reset_batch_size() charge pending deltas =
to
>>> that owner.
>>
>> Could you please explain why it is unavoidable to introduce the new
>> field and why checking whether the cgroup is dying (and charging delta=
s
>> to non-dying parent) doesn't work?
>=20
> Peiyang tried doing this [1], but it doesn't work because
> ss->css_offline() is called before clearing the CSS_ONLINE flag.

Right.

> I also considered using mem_cgroup_tryget_online(), but that only preve=
nt
> the memcg from being freed. It's doesn't prevent the offlining.

Right.

I think checking CSS_DYING under RCU and grabbing the lruvec
of the first non-dying memcg should work (this pattern is already
used where we use RCU to guarantee memcgs are not freed).

If we do not observe CSS_DYING flag, it is safe to charge deltas
to the lruvec because RCU guarantees that reparenting cannot happen
under us.

If we do observe CSS_DYING, we can walk up the hierarchy and charge
deltas to the first non-dying memcg.

This requires introducing an API to grab the first non-dying
lruvec lock like folio_lruvec_lock_irq(), but it can be called only
when the caller has a reference to make sure it doens't go away.
(I wonder if there are other places that requires similar semantics)

or am I missing something?

> So in the end, I chose the approach used in this patch. Simply adding
> a new field to mglru to track its reparenting status seems to be the
> most straightforward and effective approach.

I think it would work, but we need some explanation on why this
requires special handling compared to other stuff (e.g., reparenting
of split queues).

> Thanks,
> Qi

Thanks for working on this, Qi!

> [1]. https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-
> a53a-1e28cc894f0b@smail.nju.edu.cn
>=20
>>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-
>>> efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folio=
s")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> Reviewed-by: Barry Song <baohua@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------xv4AXOs7gLhZWtRvpHP1aUpZ--

--------------ULHFF9fXbXcUf502veQMDaYL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajpBcwAKCRCGXBN6rc5S
1paQAP9NwREVzNQHOLbOsFTerap+KpfzuPi6heE+TjYcUtrZbwEA5Pv5vU0w3cic
1ozfD0QNcLIqt8z+hZEeYGE73LDpwgg=
=2TeK
-----END PGP SIGNATURE-----

--------------ULHFF9fXbXcUf502veQMDaYL--

