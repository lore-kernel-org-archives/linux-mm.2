Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E7460A2601
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fA45Vmsc
Received: by kanga.kvack.org (Postfix)
	id 265FB6B05B7; Wed, 18 Nov 2026 09:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E136B05BA; Wed, 18 Nov 2026 09:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D2B6B05BC; Wed, 18 Nov 2026 09:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E833E6B05B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:26:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F0E91A0782
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:26:55 +0000 (UTC)
X-FDA: 85448466390.12.5307EAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C1F1720002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:26:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fA45Vmsc;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012013;
	b=PZ3mS265xD8CWIyJ+NjDO0gG/sB2iArdD1fbOVctelB+EqJYmKCooBcv5a1+h0oF0ze1+3
	Mb330NfBEqS1F1RsINADUAM8VAJp9mLW699eXqEOAsvTsFs5ek2LJVUscVvqwlubbaDRzU
	EIerQu+4L4gs6TI5hWxaMv3zyD1sbGk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fA45Vmsc;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012013;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42Du/9Ppt3MIAyDMgxuniR6PfE1elDvXnexgc5qD1rc=;
	b=B68V+Su5wc6hvoEmEMcCk5VufM8E7iM7OcgzDFUg/+PWE1sVt/nV8H8i0jwYeDfS19u3ZY
	jkzltH4NJTahU+3odOWkLHqu7lh7At1/ttNg1xcTLZRAUA/pCByZbtWt1WNkjnikmuSqt4
	6HJ2z7CdS9gVlC2H8VKdbhzHtvLpFZE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E760D434BE;
	Wed, 18 Nov 2026 14:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C091F000C4;
	Wed, 18 Nov 2026 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012012;
	bh=42Du/9Ppt3MIAyDMgxuniR6PfE1elDvXnexgc5qD1rc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fA45VmscMO/x4MAsjIzdmrBY2gXMSu69zAWARGHriOfvGOFgIfr7hXE1bYHGg1iuq
	 5tKSqPRDQObogoztdlkf0iBlWXn4AOpZvJkW2SZg2IZRchUFNr6AFl5SHcRqlu2l0U
	 R4K6cj4Et8AzDVQ253BpQNWFeJkDiKr0zhrNw5ziafPb4ny+zFA15iJsBmv34Gmqxo
	 osrppBcZijwqik4PkNVhL8TFtmggRqf2yncUBm5M003B1LTVWDUcWWTWyAa28kuYit
	 4SzWmCFu+dLdxZ4GAdsphXPbMaG3LckToNot5UJJZ8WVBkVDuJnzjWzTlgTiP+rn4l
	 epsqx58P8wxQA==
Message-ID: <sashiko-outbox-221201@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Gregory
 Price" <gourry@gourry.net>, "Andrew Morton" <akpm@linux-foundation.org>, "Arnd
 Bergmann" <arnd@arndb.de>
Cc: larips <larips950@gmail.com>, "Zi Yan" <ziy@nvidia.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Jackie Liu" <liuyun01@kylinos.cn>, linux-mm@kvack.org
In-Reply-To: <20261117142628.3931151-1-arnd@kernel.org>
References: <20261117142628.3931151-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:26:51 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C1F1720002
X-Stat-Signature: 7t7wf8fmmxx14do4uzys5zxpm783hnn5
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795012013-34969
X-HE-Meta: U2FsdGVkX18Hbis20L0BZRUxZkwZYaD3sf/OKLyQvzdsQi3PlxQEB5/EpIKAVG/6kFh9PqpCld5d3G91phfd9LivIAd9yJaPjsz0XCdtxtmKP41wyyqSC/ZdCfcmb3cYCHrHdJgwX+9SttADVlUmB7hZgypnB+L32h6XJ5SdcRCGCzjiKcCU0/1z5NWTSyuQDfJ0SUQhi6+Zg4cg3NZWG9NdaOrJA2wZTNh82V1cLVCWuzppjIXFeZxhgEOD27oll7C8iBjwghfYjXrQfyo9OQaEycb+VMu/WkhILhZrjvw3Q7dWKTYm269T096ecnkMCwPC29+EW/e/7TF6N2BxIeT1VMcs8/gu4E4YIcBGDTYUpFsxEpglm/CDJwXLV1eT5J8QNLDHMb6IPWJ34+sH3eI7HONMDspy4WbwGdphrgyIugjsyMu01EO8n3AgQsODlGjEbpCVNLcTIjBW+Wd+w+iWMAzikbviSQU9BpfQt0BQvVIkNzeWwHu19HmEJ6WCRuHYRwQbu74nNYY9IgOFsO1AmIWUVeUjrFT6vCPeKkDjYtUikZGRNSRbpzPBPNjemqH4rZkAFOW1n8b3B17U6GIJDT6LE5MekhtOHqnHegQ2VFTbLBjXV7O5LU37HVRQPpSQM92YVwk8I478Q569tWBKp6qFN8DZEyZsfmy6jBK8r1PmpUyWT44ETRkxib7HbfakD3Va9rUQWLmZy1+WKveSVlQZwGTvW1drbPJzhgnajAigEUjNw8Ax1+xNOHhEBu652XBVsfHD+2duZ9dXsGH7kLWr5SetVDHxZqDY1MdQtOMScMH3NBBu32n0bam2gXilol8PC7Wg8iV+O9QDX8eLOsCGhSw7zDwVOfZm3Cu2NE6zHE8oqJ6TVRInGnGA+JZniefR/yovC1oEOuL4i2kSwSC9v5Nhzp0PCPFxGv8xPnfAobpimW7G+nxKOMLJDjhk88ugNahN5YJndBJ
 QnSprqtp
 rrRlq3+KzvyDiYVpIBs++VOCOTc5NIyq2CMc8VGemy7476vtFpGTLmjhu8jCvKDcMqNzYGf1p0YBs1Yb7awxjxfJwm/UTMg+S/SbtVJXF6uOy8RracPs3VfUCT6VNbTAbBrR+gfbko8ad+keZkPxrM4s/Cu/6NrfKbQ0mMAejEUHPBg+n19YerfflD06Jvindfo9yzcRrGyYa5Gj+XyZJv4lGP/7Hai1cjOB9lNXvi6z6ArTBWHxRC/1+i1vcCH7RM5WkviqG347wgtAyVcWiDomy5lIPX7atIZrfERDZdKBMcIa974wh3KjWIe3a0Iwm4EinNDYknnJg6Nr/ZvrS1jGgJlCKH8R4SiO7cQTJTh5VGOFU4xLMShoyB81cTXldHV7mBm3fa4Dp5vzoJPXxjTzKY/ZbpqvWeLuKExr4lrZeO/v8zlHI4P+qqP44kF5Slx8+cOav3QRQZe0RY9JyAKIQWY3M6dgdzZx0O9RkDbFwsr+yVLDgtRIRnoidStpwIt6tyvAUdzYoE6ANGMsCtXmBZiczS4p8lTrE8XcdfzuLyPBGAnkb1wFangTomHYIwMTn2JbfSuBXF9U4hLaDgkclnIkt49bmwWy8e0mFG2OBKBuZMapiDapdxxWdzLgVMJvKdZMiQOdGR9R97V9h1eYtVzzqjXdRG2CDMLtgnjCrKFdrFkr57pCRXTVJ4/ZA4SHbpXgMcquOlyDjEJpOnFjduF64ywKzIjAuPizMzkkNKhyUR335uduqA5l0nqv1CDqVdHl7GyfJwqyEBXafYoyx1ZbHoCKFXqOWWcQ9U7Za0XpQVCU4xt3nuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] mm/mempolicy: unwritten 4-byte gap in copy_nodes_to_user() for
  compat
- [High] mm/mempolicy: userspace buffer overflow in copy_nodes_to_user()
--

commit 15cbc49ca2cc79737596e7f00e2ef7f9966ffbe5
Author: Arnd Bergmann <arnd@arndb.de>

mm/mempolicy: fix copy_nodes_to_user() for odd inputs

This commit updates copy_nodes_to_user() to align maxnode directly to
BITS_PER_LONG or BITS_PER_COMPAT_LONG instead of aligning maxnode - 1 to
64.

Link: https://lore.kernel.org/all/20261117101910.1820066-1-gourry@gourry.ne=
t/

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index fb627b37afcbb..32b984cb9babf 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1720,12 +1720,12 @@ static int get_nodes(nodemask_t *nodes, const uns=
igned long __user *nmask,
>  static int copy_nodes_to_user(unsigned long __user *mask, unsigned long =
maxnode,
>  			      nodemask_t *nodes)
>  {
> -	unsigned long copy =3D ALIGN(maxnode-1, 64) / 8;
> +	unsigned long copy =3D ALIGN(maxnode, BITS_PER_LONG) / 8;

[Severity: High]
Can removing the - 1 from maxnode cause copy_nodes_to_user() to overflow
the caller's userspace nodemask buffer by one unsigned long?

get_nodes() still decrements maxnode on entry, and existing callers
(including libnuma and in-tree KVM selftests) allocate N words and pass
maxnode =3D N * BITS_PER_LONG + 1:

tools/testing/selftests/kvm/include/numaif.h:kvm_get_numa_memory_nodes() {
#define MAXNODE_FOR_MASK(mask) (BITS_PER_TYPE(mask) + 1)
...
	r =3D get_mempolicy(NULL, nodemask, MAXNODE_FOR_MASK(*nodemask), 0,
			  MPOL_F_MEMS_ALLOWED);
}

With ALIGN(maxnode, BITS_PER_LONG) / 8, passing maxnode =3D 65 for an
8-byte unsigned long nodemask computes copy =3D 16 bytes and writes 8 bytes
past the end of the caller's buffer.  Notice that the compat stack leak
in e130242dc351 ("mm: simplify compat numa syscalls") happened because
compat_put_bitmap() was passed the undecremented maxnode rather than
maxnode - 1 when copy <=3D nbytes.

>  	unsigned int nbytes =3D BITS_TO_LONGS(nr_node_ids) * sizeof(long);
>  	bool compat =3D in_compat_syscall();
> =20
>  	if (compat)
> -		nbytes =3D BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
> +		copy =3D ALIGN(maxnode, BITS_PER_COMPAT_LONG) / 8;

[Severity: High]
Does dropping the compat calculation for nbytes leave a 4-byte gap in
mask that is neither written by compat_put_bitmap() nor zeroed by
clear_user()?

On a 64-bit kernel with 1 <=3D nr_node_ids <=3D 32, nbytes is 8 bytes.  When
a compat caller passes a larger buffer (copy > nbytes, such as
maxnode =3D 1024), clear_user() zeroes starting at mask + 8 and clamps
maxnode to nr_node_ids, while compat_put_bitmap() rounds nr_node_ids up
to BITS_PER_COMPAT_LONG and writes only 4 bytes at mask, leaving bytes
4..7 of the userspace buffer untouched.  Additionally, when a compat
caller passes 33 <=3D maxnode <=3D 64 on such a system, copy is 8 and copy >
nbytes is false, so maxnode is no longer clamped to nr_node_ids.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117142628.3931=
151-1-arnd@kernel.org?part=3D1

