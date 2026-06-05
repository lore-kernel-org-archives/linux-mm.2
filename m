Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71EF7CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 05:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3856B0088; Fri,  5 Jun 2026 01:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7CFF6B008A; Fri,  5 Jun 2026 01:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44B56B008C; Fri,  5 Jun 2026 01:45:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A07486B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:45:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70831A0370
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:45:42 +0000 (UTC)
X-FDA: 84844772124.23.F7D99A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CC2A4C0007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:45:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uu+kycIx;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780638340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhVtNpIY3P5HlHg06DPqLtn0RckcLp4C6pdGau2Sqv0=;
	b=8o/MGsPMF8fKrbl0kLg1uYB7DbznbxRZUm0xJrTZMMdKAE1XlZcO9qXkNehZimC3L0lE42
	sHmW8fRHN929P0tUdQ1xJgo5Nrwez6Ou4SplLNgzMKCYP3FC3SKVBBhs5yWv49gjv+ZSEb
	tUpOyRLGY3Fmf6jNDg3oiIJ0nAFCP7g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uu+kycIx;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780638340;
	b=ZMqsFxHpM36sZC18e6j+y9wDC3BO4RzH/38VEOgQsZSb9sjxe7qS5SBqmc9BNABrcCOhSY
	Os5luTqRiueGjsq0+yJE/bXrStNx7XJDGe81HRD4GtF8PwOR+WHDC+3Oqy7+1IsMQQvLGA
	QF1/UE88858ukpdemnuW8ZsSLQUfP2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30EB860052;
	Fri,  5 Jun 2026 05:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593121F00893;
	Fri,  5 Jun 2026 05:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780638339;
	bh=mhVtNpIY3P5HlHg06DPqLtn0RckcLp4C6pdGau2Sqv0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Uu+kycIxx/OwP3X+MW0bxkvQU4ddOXwn3XvJ7ehtVT3TKsoeCOSObRuucLETHpt5k
	 pdlTazcWxqM/rvf0VsEj6F9iXGfWD79yvmqOWbXXD3qK4rHo1aBhHk/Lg6KqoOSwJS
	 /KH227tJUhDSUda5T4B9vGDT09V7SFVSXF6uSX+HDBmBkd9Av5QPF+sDmUZaXgFMM/
	 6cKhDwlHOBYRPdbkwf8VLc8FFqlK8PMTNpWTshOJ/dBtdWtERGC0abLZ9Fx6NGIXM3
	 ilTMDOT3piuhx356QjyJfh3GekndYg4p4r+HuBlK6LBYMRAddiO76Flw4lnODF5BLy
	 KovD8fMcDvSmQ==
Message-ID: <0198cf7c-ba09-47e9-abc3-dd230c1183dc@kernel.org>
Date: Fri, 5 Jun 2026 14:45:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] net: skb: isolate skb data area allocations into a
 separate bucket
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>,
 Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-3-pfalcato@suse.de>
 <6d70757a-a849-4828-89e7-f3d51bf8c9f8@kernel.org>
 <aiHIQ4ZxnMSifhmi@pedro-suse>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <aiHIQ4ZxnMSifhmi@pedro-suse>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------997bZ7rcMfhtcga6qMSb40eN"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CC2A4C0007
X-Stat-Signature: jdnoaw4tnu6nd8x3j93woue3ftcend8y
X-Rspam-User: 
X-HE-Tag: 1780638340-815114
X-HE-Meta: U2FsdGVkX1+9h8aTCOgrFGe95tcpuMyQjhtbdt+UGZJ1boTohNxvJEKS7gfXzVmrTBzhjc+7NWiv+rnNSiiqqemt42sDQBnE6E6mSA4ybLUpogBmcvhKIOaE9jcEVvM8njnRIJ+jKsv9nfgiTtSSR2NfVGEI7sXcVI7cjvu3rkjpaDO3xXfFsKEQ3GqaiFnzNuZk/i+yTNuU2C5M1qmhZvhvNCC5PEthI/1cTKzBx6mmsnRNAQwx1AluDHuPKuj4EgSL/Uce4KE3ZQjsUHZ1pgs7qJa3UfkbI7FbmBROecjAEBu0/TvWKUycyCJKuWH4PFEGHIk2epKv3E3L16qRBMsDTrie/RNIUxVLssPtUENkFHZNVMJ308wABjnJVSDRMi73FuKNTgPgxCM4gOM075dNl6B/KknxyIQkZzhYAIyVhmzfOUY6RjcvdB4pwaM5krAf7AQglOBf6bV6XKVxfHCbLI6K/um+ejaigsMscY9/A2dMtbHV5SJwv4n0tB6ldLXWzNEcBQPrbXzCM14qcb/88owYUXkLNqQz+0bEP3FN51pm8GTkiqjI3cRJ6n6DnsDipKtboU2ANI7mb/SdXT0Ciec3gxpDmiTqMAVfY47GUEJ6dToUO9VHDzs9Du8V06gUY/a7tYc2w7NFdJMUn8mlwHsLJnSFo7Mg+0hEqIOc/er2EKCxrGXuboqmnwekJhWEBNGzxPrOQ24zx38h22O51j5/T/GBWeKg44O/yOxo0ofpPRyaX1j3wv6kD2Gzakq1jCfOnvu6osAwbK+dcOFWCz8QmwOVrezFjz6U0Dhbojun+rELney4OrAF6di0J3Ny5XHwBdg0PZ+/A64yz0K03NRQoEtFLlUe5KeJaR63U4CEP/tXXfH3bT8xv+xavMT+TnN+AH+qry5pJZDiRvOquoaoW0ZR8b6VebHXONpuNap+FbsnMVySzD3mQ5EZ4aPqDfDwr7h0ptg1Kas
 3qQ35Ekv
 pP2esTDQxBQIsgc+RUOoEP90NoSyLdzB2nwmA2sI9SldqYCFJ6As+cM5/LY5jkqW4U6coGmjak9V/nd+HNBJnJfHy85Kyr4MhwNK4KoitlZQU8BzsOOQ4N9OHUacWDPkk0zkptMr5rUXeIik+VwEj55vtsw4SbifDJjLO5c0SSFDfe4TRTpgINo/ghadrzZRW8+L8HxcomrJmMg1mqT5BLjZWkC516r6Y+lzVYTcJm3v+7Tg85nU2ymCqPsN+Gq5VmYsSSTggvi/Yupe06NxyR+SZhPsBhjenby+FCGuHTO8z7nGO8EiBNUjy6IrFND1GwQC0PshJrpptQnURIMImfWHSYAQ6lYwrKLb+7XpxvZ809B+R0VO3JhEYtLcCeKaEk2r9zZmzuzihIb1vbU5/THLqMb1K98bwXufYui20b4m806zlt+Gb/4HhloeRo4wBxvV4vUDCI0LT8L2CJowuxE38md2QvXmHjpNQuJrM++bnh8yfqRrx+FN41LYVbQW33k5H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------997bZ7rcMfhtcga6qMSb40eN
Content-Type: multipart/mixed; boundary="------------n0FZEuI5Zztetg5lfgI5QZI8";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>,
 Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
Message-ID: <0198cf7c-ba09-47e9-abc3-dd230c1183dc@kernel.org>
Subject: Re: [PATCH 2/2] net: skb: isolate skb data area allocations into a
 separate bucket
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-3-pfalcato@suse.de>
 <6d70757a-a849-4828-89e7-f3d51bf8c9f8@kernel.org>
 <aiHIQ4ZxnMSifhmi@pedro-suse>
In-Reply-To: <aiHIQ4ZxnMSifhmi@pedro-suse>

--------------n0FZEuI5Zztetg5lfgI5QZI8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/5/26 4:12 AM, Pedro Falcato wrote:
> On Thu, Jun 04, 2026 at 02:30:34PM +0900, Harry Yoo wrote:
>>
>>
>> On 6/3/26 3:31 AM, Pedro Falcato wrote:
>>> SKB data area allocations (as done from alloc_skb()) use kmalloc().
>>> These allocations can be variably sized and their contents can be mor=
e
>>> or less controlled from userspace, which makes them useful for attack=
ers
>>> that want to overwrite a use-after-free'd object from the same kmallo=
c slab
>>> (which often just requires the sizes to roughly match into the same k=
malloc
>>> bucket). [0] is an easy example of an exploit that uses netlink skb
>>> allocation to target another similarly-sized accidentally freed objec=
t.
>>>
>>> While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, thes=
e are
>>> probabilistic. Use the existing kmem buckets API to further isolate t=
hese
>>> allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=3Dy.
>>>
>>> Link: https://github.com/google/security-research/blob/master/pocs/li=
nux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>>> ---
>>>  net/core/skbuff.c | 5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>> index 44a7f8401468..1f6c6b531ece 100644
>>> --- a/net/core/skbuff.c
>>> +++ b/net/core/skbuff.c
>>> @@ -594,6 +594,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, =
gfp_t flags, int node)
>>>  	return kmalloc_node_track_caller(obj_size, flags, node);
>>>  }
>>> =20
>>> +static kmem_buckets *skb_data_buckets __ro_after_init;
>>> +
>>>  /*
>>>   * kmalloc_reserve is a wrapper around kmalloc_node_track_caller tha=
t tells
>>>   * the caller if emergency pfmemalloc reserves are being used. If it=
 is and
>>> @@ -632,7 +634,7 @@ static void *kmalloc_reserve(unsigned int *size, =
gfp_t flags, int node,
>>>  	 * Try a regular allocation, when that fails and we're not entitled=

>>>  	 * to the reserves, fail.
>>>  	 */
>>> -	obj =3D kmalloc_node_track_caller(obj_size,
>>> +	obj =3D kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_=
size,
>>>  					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
>>>  					node);
>>>  	if (likely(obj))
>>
>> What about kmalloc_pfmemalloc()?
>=20
> Good point, that looks free as well.
>=20
> Sidenote: isolating kmem_cache_alloc for possibly-aliasing caches could=
 also
> be useful. skb allocation has net_hotdata.skb_small_head_cache. It does=
n't merge
> with anything for $raisins (odd size, plus I don't think usercopy cache=
s are
> getting merged?) but it feels too... accidental?

Right, we never merge caches with useroffset/usersize.

Hmm...

/* SKB_SMALL_HEAD_CACHE_SIZE is the size used for the skbuff_small_head
 * kmem_cache. The non-power-of-2 padding is kept for historical reasons =
and
 * to avoid potential collisions with generic kmalloc bucket sizes.
 */
#define SKB_SMALL_HEAD_CACHE_SIZE					\
	(is_power_of_2(SKB_SMALL_HEAD_SIZE) ?			\
		(SKB_SMALL_HEAD_SIZE + L1_CACHE_BYTES) :	\
		SKB_SMALL_HEAD_SIZE)


What are "historical reasons" other than avoiding collisions with
kmalloc caches?

> Maybe passing something like SLAB_NO_MERGE and making the size
> standard-looking would be nice. I have a size of 704 bytes per object, =
and
> this probably causes some weird wastage for each slab.

Yes, unless the "historical reasons" do not make it infeasible to do that=
=2E

And I wonder if net/core/skbuff.c intends to always prevent merging, or
only with hardening configs like SLAB_BUCKETS.

--=20
Cheers,
Harry / Hyeonggon


--------------n0FZEuI5Zztetg5lfgI5QZI8--

--------------997bZ7rcMfhtcga6qMSb40eN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaiJieAAKCRCGXBN6rc5S
1vqiAQCwzNxsZCILMai81ko92snBjCKgniuSar5HpR5PyzdzLQEAgghVBLPZo6us
vlmp+GMB8t+jxEqUqiKgV0KKMxhigg0=
=p8Ku
-----END PGP SIGNATURE-----

--------------997bZ7rcMfhtcga6qMSb40eN--

