Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E40C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 02:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9632F6B009E; Sun,  5 Jul 2026 22:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913146B009F; Sun,  5 Jul 2026 22:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC0E6B00A0; Sun,  5 Jul 2026 22:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44BF96B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:51:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9789FA026D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:51:28 +0000 (UTC)
X-FDA: 84956825856.22.10C505D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CA54B40005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:51:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/IYSxhd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783306286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mwv5psBFonUnPcaVrRzWoLiOwCo4Fa1oDMIpZW78pFs=;
	b=RDoZpX6RDFLKfJttZhUyeHoHvld+48adBe/fd9aVNBrPAy4PBmyvw/QyMHruTavV+oFYHq
	95MG1tp8Koe9z1nNIssQVCiOQdamL0OLjgCGyveKVmCV0DxO+1nbX1lep7w/e/H1+YJelb
	z85QlLam/zO21hIblTRB1yBmX8WNTxg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/IYSxhd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783306286;
	b=z7NJikc3zrHknkFS6u4yCqOMG/4iRd7E22skk2i3XFdEpIQG7uSO9vyt+Eix4meEM+T67/
	oZLOj85JackQJsKIB2MKb5SpTw3AQn11pp01xUxVf9dUMxArPH3g8v/uEo5y1nZV3cVZ5v
	7t7f1Jxmx53gbOYDLFxJsDXo6z1INjs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA24F40380;
	Mon,  6 Jul 2026 02:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6671F000E9;
	Mon,  6 Jul 2026 02:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783306285;
	bh=Mwv5psBFonUnPcaVrRzWoLiOwCo4Fa1oDMIpZW78pFs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W/IYSxhd7T9rI+2RqBN3gFYAXrd8lEB5tRTHqdPKm0UPnsqN4b5UsZ03afzNRsZ4E
	 Ut5P4SSVTLCw9W1e4G/2S4wpwmilXLONTxI1+PMsSYrVzXQ0obAb6m/5wG9R4wHgB9
	 swfcqH1UwabrUIuOMA2/PgSN2mxK3Sy0HozwAJh/tPpwhrKaTtz/f7lu415XN6dfrS
	 +4YsBDK/XNI5tReqjyyWdpYt9NpC0sIg4hCBkCg7/JN/pBrz9ij74idTq12X1SVnJW
	 YgzcBfLWkCv5KQy0W+KJefGR7kF/EefIpD+1Zha7ErGbSiOxp2fIroB8sKn8DHa02k
	 DhE7xTtruxr6w==
Message-ID: <026e7be6-fa97-46b0-8daf-57fb890db0b4@kernel.org>
Date: Mon, 6 Jul 2026 11:51:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: fix lost local objects when bulk remote free
 batch fills
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn,
 cai.qu@zte.com.cn
References: <20260705213758375Xf8iZzfLz92U9SASpvqTJ@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260705213758375Xf8iZzfLz92U9SASpvqTJ@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------U3q03QC08IG6dyOa4TvhWlP0"
X-Stat-Signature: xcak6rzah5jmsqdtbx6gys1cjwsp9pjn
X-Rspamd-Queue-Id: CA54B40005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783306286-340541
X-HE-Meta: U2FsdGVkX18bfXV0CC6khxH2Z/v26yO2KJCZS+2lEBxC7MevfXf69do/IbvZC/8DV7c3XbwtVXvyCuXQZSq5+dIb7r+DynXA4BYzTG+4bDDp9iqTcVGejrKgoNGRyPIU7OLwApmwwFF7vZQkfFdLIyAHdRKEokk47fJ+CbgcfBAiLvSLGuYpHb0F6HbO8b6LUwG7l1doE+bJkvT+JP+qUB8OlyGZFqkvdh75mHGtWEhWgmwaKypEKcwp0R7W308yMpJFc28tWwpuNnPOFQwCCFN5Y30k4eTMpmmZP1qm6DMGZOW5lGi0HPPI7RIYowPb9g+Q4H7p3zgawxMY90cLi//TWLoalnAijkHnSPy2sneGpkNIqAuZMR5Ynox5t43VHeIcklpsQk22j9HhXnGXsaQ8dR2CTORT9/9aOwnAKFU3f6kj+xQDjIVpGanpA2TuKk0QqwTImvmpTw9pVeEjxlJD178MfefAbnCpJWtYpSEReGOyxlJPgTgU3uOO99gCLCbS8Gb68AaOsguDP5jlc4k867LadDnpSiX+O7Sy9xWrLm0CgCT2kWhVKaBJfp+cqWdp80Hl2AdHaIBS591cZpHdcCKAmkot6KfG9ZIyRM4G7lU1scKxCTPBDfTWFHtAue3iuIcElOR0nb70GWnU5My3k5AS47Z/fiAQrN7B5f71MdAZA01ZZtR941l+pku8CFxOcoyGgCPilODs8uhNm+nnPRK9ZTV6FhJ01CdpVPewbOUz8LOM01Ohw5K/61sOIHJ8U2mAN7zr7gO11C/8gRWyURVj1A5i3Bx50e1nYNvhh8JhL4F9WJw/6+L1KBzPmwC4v5fzPvssgjpW79VXInJa++PELzBKDKZ6WRzhf0nAKVHg2+62vjQ5+AEWXTsUMOPE/krnkgfYBVoa/RFrstoe3xHFCiUBOIRdI4Xt7yXcKa6LlRw35lHQSExueOC2tcNi0F9Sm1JMNsYmCLE
 E/KFVfH0
 +Q+/FH3qtbCzbFgW3H1nsXJHMsK9O1VDE9rs4IURMMPu7PD/v2IwuM64uAzl5zo53mgx6ja0jGzd3va9mXLr7yEDAyyqJBOkBVIluSZL9B7QkqNmkfEHi9uq4v7ALQ8QgYfMw/VtORdnvnp63/P2Oir+Zv3gwrcRaw1eek5VoZZufD+D+vC13mjFWzUzbHUo9zTJt7BPiVKMoW/QKzmTc87jam+qT6/Ui8bFDzEy/BaIbsLOlAXKYmcWmcLH0nayphLm03rJ00FZPXtEopN8TcUIIrm169v6G8o/O0FEQ2j/iwHa9qh1BrN0vOelokfNEiRqxkPGiiDXMgCJz8hKoLVpG//hLB0qVrYC3kH6TC0aBA3fZZADxWq82nWqq5M7ZwxfoHjkJ08aeskVJVo619nWX6HtMhU1QbUB1xN2l18pH37YplEhf3fGUNIdjvpqanzEoxLKfptBKTCUiv0RclrHUq6BZSXRXrfZumH9YXS5JuB7b5BkBEJVrvYGfwvOEnVwh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------U3q03QC08IG6dyOa4TvhWlP0
Content-Type: multipart/mixed; boundary="------------if0In2NWBbK2DDupQtZkI3Sc";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn,
 cai.qu@zte.com.cn
Message-ID: <026e7be6-fa97-46b0-8daf-57fb890db0b4@kernel.org>
Subject: Re: [PATCH] mm/slub: fix lost local objects when bulk remote free
 batch fills
References: <20260705213758375Xf8iZzfLz92U9SASpvqTJ@zte.com.cn>
In-Reply-To: <20260705213758375Xf8iZzfLz92U9SASpvqTJ@zte.com.cn>

--------------if0In2NWBbK2DDupQtZkI3Sc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/5/26 10:37 PM, hu.shengming@zte.com.cn wrote:
> Harry wrote:
>> Hi Shengming,
>=20
> Hi Harry,
>=20
>> On 7/4/26 5:04 PM, hu.shengming@zte.com.cn wrote:
>>> From: Shengming Hu <hu.shengming@zte.com.cn>
>>>
>>> In free_to_pcs_bulk(), when remote_objects[] fills to PCS_BATCH_MAX,
>>> the code jumps to flush_remote to free the batch. If all remote entri=
es
>>> have already been compacted out of p[] via tail swaps while local obj=
ects
>>> remain, the flush_remote path returns early since `i < size` no longe=
r
>>> holds. The leftover local objects are then neither cached in the shea=
f=20
>>> nor returned to the slab freelist, causing a memory leak.
>>
>> Ouch.
>>
>> Interestingly, we fixed a similar memory leak in free_to_pcs_bulk()
>> during the v6.18 cycle; commit cbcff934fa7d ("mm/slub: fix memory leak=

>> in free_to_pcs_bulk()").
>>
>> Hmm, I feel is a signal that the control flow is quite complicated and=

>> worth revisiting if we could simplify the logic there. I'm not saying =
we
>> should do that to fix the bug, just mentioning.
>=20
> Yes, this is also a memory leak. I agree that the control flow in
> free_to_pcs_bulk() is fairly subtle, especially considering the previou=
s
> leak fix.
>=20
> My intention with this patch is only to remove this problematic path wi=
th
> a localized change.

That's fair!

>>> For illustration:
>>>  size =3D 64, local objects at p[0..31], remote objects at p[32..63]
>>>  After scanning all remotes: i =3D 32, size =3D 32
>>>  p[0..31] local objects are dropped.
>>
>> I can see that could indeed happen.
>> Interesting. How has it been undiscovered until today?
>>
>> Well, for this to trigger, at least PCS_BATCH_MAX (hardcoded to 32)
>> objects in the sheaf should be from remote nodes.
>>
>> Looking at kmem_cache_free_bulk() users:
>> - maple_node has sheaf_capacity =3D 32
>> - skbuff_head_cache has sheaf_capacity =3D 28
>> - panthor and msm drivers have sheaf_capacity =3D 4
>>
>> The capacity is (at least for now) purely based on the object size
>> (with user-requested capacity as a minimum)
>>
>> Only maple_node cache (out of four users) has
>> sheaf_capacity >=3D PCS_BATCH_MAX.
>>
>> However, for this to trigger in maple_node cache, ALL objects in the
>> sheaf should have been from remote nodes. And that means there is no
>> local object to leak :)
>>
>> So, although the logic has a leak, you cannot trigger this in reality =
yet.
>>
>=20
> Thanks for the detailed analysis!
>=20
> Yes, this was found by code review rather than from a runtime report, a=
nd
> I can not verified it with an actual triggering workload.
>
> I agree that it does not seem triggerable with the current users. This =
fix
> is mainly intended to make the code robust against possible future user=
s or
> changes to PCS_BATCH_MAX  :)

Could we have these explanations/analysis above
in the commit message please? :)

But yeah, we should fix this.

When fixing a bug usually I prefer to go through the process...

 1) Confirm the bug exists by reproducing it, and
 2) Confirm that the patch indeed fixes the bug

But this one is impossible to reproduce, uh.

In this case I think it's better not to Cc stable (which is already the
case). In case there is an error in the analysis, it's still
straightforward to backport later.

I will double check if the patch is indeed correct.

Thanks!

>>> Replace the goto-based flush with an in-place free of full remote bat=
ches
>>> during the scan, then resume processing the compacted array. All loca=
l
>>> objects now go through the normal fast path, and the tail path only
>>> handles any leftover partial remote batch. The redundant next_remote_=
batch
>>> jump label is removed as well.
>>>
>>> Fixes: <989b09b73978>("slab: skip percpu sheaves for remote object fr=
eeing")
>>> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn

--=20
Cheers,
Harry / Hyeonggon

--------------if0In2NWBbK2DDupQtZkI3Sc--

--------------U3q03QC08IG6dyOa4TvhWlP0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaksYJgAKCRCGXBN6rc5S
1nJYAP9eUH42mRBvFMc2sjpzyF/rofU3NznL1cqfHcLa5cwHYwEA2HoYoFUx16xW
s5YEOYtAbepNT0P0LwjK8+2H/xCN/Ao=
=Ue8S
-----END PGP SIGNATURE-----

--------------U3q03QC08IG6dyOa4TvhWlP0--

