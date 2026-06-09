Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA7D7CD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 03:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC5D6B008A; Mon,  8 Jun 2026 23:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D796B008C; Mon,  8 Jun 2026 23:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5106B0092; Mon,  8 Jun 2026 23:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB4726B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 23:41:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72318A03BD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:41:27 +0000 (UTC)
X-FDA: 84858974214.12.1C7B9EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C81ED140008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:41:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LY854tlU;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780976485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyQXosIVlm1d2ieq06VqSov3tK1/uj2RCw2AMDVsioc=;
	b=FGFgL5jzPn7zgoCAMSI5EHlYOLS2gPbkG4UAtgVnvRFHrBUuomf5ELgpJp+dnAYa8jjg4Q
	Sg5tT2u7KUac/P1U/Fx4Qo+SBuSk3bVSrSR8GjtOXfzB5HSmwxo5ZmaDe5uD/NRbeE0i82
	icTdnR9BuppCVGrgoT3+FCcTdJdUpHk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LY854tlU;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780976485;
	b=zyHf541pJnrZ4R6ovaAFdXOf1DJOZKybQ0Hdh301eGqe1wNO0Pzq2oibiMs6wuAjOZwa84
	zGEWL1S9+Un0QobpNf5j3aXxjAXWA1dJ9Fr6t15joN0fszYXOi1eZLUn/yYkx+ucKBEFZ0
	nRLvED2+afO868MRiDmRPDIMNKSEQHY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C329601FD;
	Tue,  9 Jun 2026 03:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3984E1F00893;
	Tue,  9 Jun 2026 03:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780976484;
	bh=qyQXosIVlm1d2ieq06VqSov3tK1/uj2RCw2AMDVsioc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LY854tlUWARShj8og/Lt4O7B/KQkrffzr1mcnOnwau0bA8SQwHE4m+rhQJdSqRjow
	 G5dB0CcwUxxKaV+FXI6P8cs3TfXU+lQDWtXs/HZdQiT01DBMNh62p8LWOXfTq4KcPk
	 l2QR25t/3we7HjtMxgAlEKB7XznXfbVLt1ZnV3YFBCJVPWleyQcAiT76iivgcU1Vni
	 q8cJZPEOCNEExzTiKWef9IQU0gzYhCtj6V3YCyZ1K616IFPm8wkkQ5N6ODiaeCh+ij
	 GzDALhlxx/TZFy1ugnHb/2lD/8u9JhfRJLYEXBxqYCrT6HZ70AZx6ZO/yDAYdLa7wE
	 4rdjsd4msd/hw==
Message-ID: <5d8abe93-edd1-4b18-9ea4-7731dc831223@kernel.org>
Date: Tue, 9 Jun 2026 12:41:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260601095706.106551-1-hao.li@linux.dev>
 <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org> <ah-naIiz09TTBpXo@fedora>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <ah-naIiz09TTBpXo@fedora>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------icvouGHUGgkSuPMt58PwY0t3"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C81ED140008
X-Stat-Signature: qjcsn1es7nu67o73dq1roxm1a446ycai
X-Rspam-User: 
X-HE-Tag: 1780976485-400459
X-HE-Meta: U2FsdGVkX1/LBJS44qZLPpnqFXqSiihFUfkuUtZSJj83AbVmTnK5kED0dBL7pl/iwu2Ngd2yxXURDKSqMikFACIJ2iSZe/eqF1/Uf0QJehxoU2htb4kKLYuvXz7ZPpGnoU739p8Iuqg+3aL0ouGXfYzMW5yGTuOvROrZJjbNVergE9U4M1sIdZtutoXpx6Y4LhTnutXk6BNxeBapcZBxpd9RJgG4njBISNHpEJhPQlRo1u+jjt2GYoKoeUEWaYsQBOmVjlmKiaWnYetvwp1+HqfyHAZPnawYh4ABBHzyRD8eNPNJka9G1JG39JNzL8VS/O80WeeI0LPQxDPODwQ9jyAx3a01pmvZ6uxEvK2JEEOvtokGfyN6Aph+8dgBYZt3SLKQdM4vjXePXi14vn5tHjNkkF6CXYPjYBEgxTzZLTVfq4bBZZ6+hm9YWTPdiLoDEttDyTlKF6zc4cT0KhLLoOe0mp+8xhC3Gmky0h3F8HcWZUfQurEEvUQ/g7NgC3LG3EPdYLGtu7nTMJhU30CmfGiE9XmqvSUCywR7JTlYBw4FMyaAlDdh/tS7JRcftYfHuARDjQiOtf53EAmnWEKvdvRYT+flDLwzLtP5U+8UVohLaynOc8bWqNw0YFBt6RmRgrywT9PQnm4mpdWx1f+MX0SoLTY/1QlXOcEgM1ctOzRBjno42vil8cp5JuLBQdcWVjB0XjEvmgWCV117HrXgdEjPshrhxNDwB415eZt2AqJvxj6CV5SBUVJi12WdIMy03f4BVBMP1T74NkchijYZ7lVW9oHuVx3OTLEncDmGmsILqxgHrYZiXSG5zafw1Kc6pIX47aZcV9iptDhJX/ccS4G8xnxkv8pZb1vi0Mv7y4UO1zqCOJsydKs6Oak9P7TM+2Ql35rAjqCXL3KLbBUJUldbbHeW7Rck7JNnywVIIWaw0e47C7GN4jSUCm2IWDWx9BjInOVJSazl28q4Gnd
 malJhoid
 3n2BkyvwgHCIB0ncHWj9tD0MYJxMEqYW+kjyTXeZLumaHeZmWwrDa4xtz1BfABpV0roPCzlwjB/fmy9vck1xaThu2A3Ebq5lp5q4uRrs2f04fEX7EuNs3YfGOZn6i3DP4yW6A2l3NkjxhHL+PMhuxkIP03OOzAYDNZjW26/eL8PHypVZh8ACqlJ1Ja3tzOlvpROW61soeqMOd2+Isj2cUnjJY7Kl/cXBYpMsEDy4JeH0t0LAbfdFurffwJGzvGeWN5H1Yp8Jiz4g8yZBU6HPt9RrXmCw+DauhbpkB49SxJNEf0GA/o0IVrCicYCcrVzxswtsSh1bnBNBO7/ZiV1Meq6W2CwG8JDNMkzmuTmQkgtYCUkoBj58K6hr7fTcEZcFJjA/L7gQyiK9gqMl3lsExNbE/2ZAvZgtyFAri8yIl8BOX/PWr+shUGno5b+sCov7pHSGiaUL7DfIo+Qw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------icvouGHUGgkSuPMt58PwY0t3
Content-Type: multipart/mixed; boundary="------------LsToChgsNI00hjF1rIQcAz1L";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <5d8abe93-edd1-4b18-9ea4-7731dc831223@kernel.org>
Subject: Re: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
References: <20260601095706.106551-1-hao.li@linux.dev>
 <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org> <ah-naIiz09TTBpXo@fedora>
In-Reply-To: <ah-naIiz09TTBpXo@fedora>

--------------LsToChgsNI00hjF1rIQcAz1L
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/3/26 1:26 PM, Hao Li wrote:
> On Mon, Jun 01, 2026 at 08:28:16PM +0900, Harry Yoo wrote:
>> On 6/1/26 6:56 PM, Hao Li wrote:
>>> Sheaf structs are exchanged through node-local barns. Since barn stru=
cts
>>> are already allocated from their local NUMA node, this patch aims to
>>> allocate sheaf structs from their local memory nodes as well.
>>>
>>> To achieve this, the obvious choice would be using cpu_to_mem().
>>> However, init_percpu_sheaves() and bootstrap_cache_sheaves() iterate
>>> through possible CPUs, whereas cpu_to_mem() is only initialized for
>>> online CPUs. Therefore, we cannot use cpu_to_mem() and instead need t=
o
>>> use local_memory_node(cpu_to_node(cpu)), similar to what
>>> __build_all_zonelists() does.
>>>
>>> The primary goal of this patch is to improve NUMA node locality.
>>> Although the actual performance impact is minor, it still yields a ~1=
%
>>> improvement on a 192-core, 8-NUMA-node system when testing with the
>>> will-it-scale mmap test case.
>>
>> Oh, nice :)
>>
>> I have a question though...
>>
>> I wonder if would be better to handle this by e.g.) not returning empt=
y
>> sheaves back to barn and freeing them if the node id doesn't match and=

>> it's not a memoryless node.
>>
>> init_percpu_sheaves() and bootstrap_cache_sheaves() are not the only
>> places that can allocate sheaves from remote nodes; sheaves allocation=

>> could fall back to other nodes and then SLUB could keep reusing those
>> sheaves from remote nodes even after memory is reclaimed.
>=20
> This is a good catch. In addition to the fallback mechanism, task migra=
tion
> between CPUs in __pcs_replace_empty_main() and __pcs_replace_full_main(=
) can
> also mix up sheaf structs across different barns. So yeah, changing all=
ocation
> locality is not a silver bullet.
>=20
>> If this works well, we probably don't need to handle it in
>> init_percpu_sheaves() and bootstrap_cache_sheaves() at all as they wil=
l
>> eventually be freed, while covering the other case too?
>=20
> freeing the empty sheaf if the NUMA node mismatches instead of putting =
it back
> into the barn is indeed a good idea. I like it. But unfortunately, my t=
esting
> didn't show a clear performance improvement, though there was no notice=
able
> degradation either. :-(

Hmm... the idea still makes sense to me, but yeah, it's not late to fix
it when we have data to back up.

> I also did some more testing on my patch too. Under CONFIG_PREEMPT_LAZY=
, the
> improvement is only about 0.5% (sometimes 1%). And when switching to
> CONFIG_PREEMPT, the patch doesn't seem to yield statistically significa=
nt
> benefits, likely because sheaves get mixed during task migration.
>
> So, perhaps the performance gain just isn't worth the extra complexity.=
 It's a
> bit frustrating, but maybe we should just abandon this direction and ke=
ep
> things as they are... :(

Ouch. Don't let it get you down, it's completely normal for experiments
not to go as planned.... ;)

> Thanks for the feedback anyway!

No problem!

--=20
Cheers,
Harry / Hyeonggon

--------------LsToChgsNI00hjF1rIQcAz1L--

--------------icvouGHUGgkSuPMt58PwY0t3
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaieLXgAKCRCGXBN6rc5S
1qrpAP4gLfwO21CzsCViBt4GtnDpBmQbtO9g3lhYDimYxD6SHAD8Dm3/YTjrRZNF
LYUGhDRyGBnaix6vUOKP11K78F4DLg4=
=Bx/E
-----END PGP SIGNATURE-----

--------------icvouGHUGgkSuPMt58PwY0t3--

