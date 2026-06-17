Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6A1CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E856B0088; Wed, 17 Jun 2026 05:41:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776EE6B008A; Wed, 17 Jun 2026 05:41:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4056B008C; Wed, 17 Jun 2026 05:41:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4506B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:41:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B99A81A03A9
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:41:37 +0000 (UTC)
X-FDA: 84888912234.17.00CEA34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1E070180009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:41:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLoQt4z7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781689296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EhVnlaeWy51i332FkkRSnATGu/gcTTZDhA4Pju0BgpY=;
	b=7YPj67KPIl2ZHM9JdkU2wBNh3hv5FiHVa4Wd0/W2Zm9m7YpA68dwEI76Bw6IlZO4xFywEH
	7O+RowGXdnH15hpzI+aSMxlDKvSoa2vvYIgc0Yp91Vb8Z6KG/RX69dr+17d3NlBqcbuiyA
	jHR50SqJW6rAkpbxTFzrHbbfvvrigF8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLoQt4z7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781689296;
	b=lqj2p+nBbGNNZL4INfiSOV2v3EZ1ulL58HDHreSXUdixRSNM/ti63pOMuk/VHWtMr8nzL7
	yoG0LgEVSsEfZC2TejAVS49X5JMhq1YTFq9/se81iZpxT1fTOJTX3tnXA4A+WcInfxrXpy
	ajLtYGTbsHY1AOtq7y1UBpdHEC7KbAQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4224B42D97;
	Wed, 17 Jun 2026 09:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD4F1F000E9;
	Wed, 17 Jun 2026 09:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781689295;
	bh=EhVnlaeWy51i332FkkRSnATGu/gcTTZDhA4Pju0BgpY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PLoQt4z72cDxJHgYQ0yqHHgNPRO+zqtWA+o3dYvlIDiHzKxz8ciYXxJ8fKjyVbfns
	 VVS5cMC3hM5cLM02sTcXPTAwQMWL+zgUG7oxDsT6v9sVZFs53d+Exl/pibM5+96jZ/
	 bP4cR5Mr6uD1diNymHyW6Mc//IvG5OSRVOUrc02J5S6hiYp1shvGLVjtGCVnMixMyl
	 6l8E3ZuIaBM0LIOF5E9xIt1G8KOCTS0kA1rDFHcUCWzC1cB6AwHapfg4aRd8JIypld
	 nUlLpC/VxojHdhDtyORQb/Hy86jQsUxCFATqCkYAj/mxD1+TRFujIFpK6PPGIRFKS+
	 N4GNUb6sNBzVQ==
Message-ID: <1d316e8a-ef76-4648-8b89-387abcc5aa9b@kernel.org>
Date: Wed, 17 Jun 2026 18:41:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/15] mm/slab: allow __GFP_NOMEMALLOC and __GFP_NOWARN
 for kmalloc_nolock()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-12-ce1146d140fb@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-12-ce1146d140fb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------peA90eEEkmps0M3XHjD0gcDF"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E070180009
X-Stat-Signature: nfinywckkgfchr99oi51ygdx153z4gd1
X-Rspam-User: 
X-HE-Tag: 1781689295-324811
X-HE-Meta: U2FsdGVkX1/G3zXQKEfMx0fttMMitBPeF1sscbPfn0VTUdSduCNxPF4h4+FiONtFXoUaSUyl53A5h36vjVvhyLswkglnSR2KREOb14x4gBczpZMSDLzKjYcLaHogXSq7FGqrrtX/itj4DRgyW0ZnplUafCtfXS4uRJDAH7Op21teklr7XFc41s8Tk6iM7rlfoYbz39nc2JM4MPR6Dda+zyjqjs6RDLwEPI4H+AQ62UxzqNnyx2+PqcVGbx8kthZ0/dz54YFqRKHrPDSbn7sa3CHWdFa/djmBujVUvt0zHwUM/E1ZDl1yz0wkN/K6fCO29LPhW3/rLZhfM0cLJRCyKCQ9hk47GAkfr47uOmLzYvncpqq0531Nbqkyi7rf2HHWJX8P0MRhVPCzlDjMIcR2k2cOy7/OL8VwBiuqhMH2+qBRzC7CabTOqw9mozVsKK4G/i+3HaDH4zvwtA759MEABsCun5GsfMqNh7uNbAJz8bxbfv9H3xLMxJRuEwK7mAK1WlqHQl+DiYta1Cc1C6tesWVjsC0cSjn7K3l7J8od/geKzsS/s3bdWHYAE0FckOprt3hZEgZ7tvtfeG+PNvG0UoNnKpaCBu2z/77BScpJOy5XZo2NIzsbgewjVWP1dCmiO87EXqxyaG6pO8RfuKorVtDVRk0MkIfg5p3Z8nlnt35WCZBADoQmfrCmEYCLDe3Lersz24eH5ZHq2K1b83DN6eteE9bbTviEmz2uKEJDUDXDjnNHeFPU6R7TXoOarn5V1h5Lt3J83W1GHBU9JoCdTGKYHFYnIizUl9bagrfZW1pH3ja/47hcJqbzwh2pxrAUn9REZgXVvRlmbv4z7RvxkLv0rI8qVSAVKDCL8z/Hq+8cDyuTJUlil04QVaSjCKLroK4jL8uLzTvcE8300oXm3w/TRpaWBWjTNeZYNBcjB4NJE7c+23lFHjfSyBduP0KBmQ36USJbiY/b7KeZt0w
 h2mT/Ehs
 tXQwde+gqpnC1Pnb+9gcR1NL/IwYbYXgvaYeUT9tIe6n2d56oOfAeWpWbPKZF1EfEGBlSkkzJRU+K0flJy9qgfJLAPWPlRC22yWVej0UM5TMUU67IEU/77jW5KOjxRUu7xqOJ1HSFYocfAb1rgYv36ucQEKY8lpdeaTmhl7QKRzKPOCbL8vH2eG0JM7JNxAwREWc7DKN1CK8hYc6LwB+cTopXZuEJvqsrMXLb/jPItAeJDUWMdSOW8IcQCVvx97miT2GQsFmJUBqvmnM6CW76MYEkpw6aNtQOywWp/6jSSwyj1qvjsqCWqL3uj1owCS50+tkvUKBpMfMuYEdz0lXGMfGrJUOSgpHZMd5kWTIEncivh6KcRXFdHe2/RfePp2meDTDZekKaMugN4Q0LnhfS4IbjH/n2rmow6sK+uPSaGhcDVYXVgXz9kRVBh1fHPnT7fzILOVwGmMicFZYbvgF49YRGeOUdJdlRb+lkxs1j8H67gmwBjbN5h35UE6PK+0rW7YtToYLrq6yIelCskP2+CoIyIf5UCWqHgcdqdfZPHAzXIgsW9ztTZ6iDjyB4DE2FdlDl6BgJVdZ+wNQycCpxTfFf0RTYQtPKd+RAYYqI23CZQwcSglMv9q5jUZjwGhgMBcFn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------peA90eEEkmps0M3XHjD0gcDF
Content-Type: multipart/mixed; boundary="------------q0l0JaIkWSVOLvsG2IexwP2d";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <1d316e8a-ef76-4648-8b89-387abcc5aa9b@kernel.org>
Subject: Re: [PATCH v3 12/15] mm/slab: allow __GFP_NOMEMALLOC and __GFP_NOWARN
 for kmalloc_nolock()
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-12-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-12-ce1146d140fb@kernel.org>

--------------q0l0JaIkWSVOLvsG2IexwP2d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> The two flags are added internally so there's no point for warning if
> they are passed by the caller as well, so allow them. This will allow
> simplifying obj_ext allocation under kmalloc_nolock().
>=20
> Also it's not necessary to have the extra alloc_gfp variable for adding=

> the two flags. The original gfp_flags parameter is not used anywhere
> except for the warning. So remove alloc_gfp and directly modify and use=

> gfp_flags everywhere.
>=20
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-13-7190909d=
b118@kernel.org
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------q0l0JaIkWSVOLvsG2IexwP2d--

--------------peA90eEEkmps0M3XHjD0gcDF
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajJrxgAKCRCGXBN6rc5S
1hGmAP4or0hJp7BdgqqdydN0Yg1bEOvqzn/BMhkyTo9925/d5gD+Pt2WkRSPEHY8
2zHVmYiz9qd1DYIFZfHEq97ffG2dWgQ=
=TNIQ
-----END PGP SIGNATURE-----

--------------peA90eEEkmps0M3XHjD0gcDF--

