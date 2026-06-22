Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9467FCDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 07:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6F96B0088; Mon, 22 Jun 2026 03:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ADFE6B008A; Mon, 22 Jun 2026 03:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176526B008C; Mon, 22 Jun 2026 03:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5DF26B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:27:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42A9FC25B8
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:27:35 +0000 (UTC)
X-FDA: 84906718470.13.967A383
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9969440003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:27:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ffjPSvkF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782113253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgN6RTq8zSwqE1eU3ABQ5JBArgsCushzNFmwojjYw0o=;
	b=7TJNZs300zqeAJ/4XYprQxjk6i1Et5i6TfwJEeE7gPlLh7uTuBKWPpDOj9XnM7Kc6ZkNuc
	MkX6tx7mW1E/VAJuz7sLKd8scdeYIcUQ9b1Kw5MhH4+dtgqo0zB9x5ypp7nWcX68KOWecv
	3ALEldwc6qWou9xbY2sIImBaBuEy1bM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782113253;
	b=Am50+ecVrnHJvrzX/IStBadgScQyqjbkCbP8fpouiTAIgMaZFHsXUtmtQXLF3Cxi0XAXM8
	YyAxYRWEYPZRkMsp1VrUHPWit3YyK+6vzF9ozdc3VRrz6KMKILz9mXSLT2D15GIiF0/wOV
	Z0JQnC/9/gm7DdMaLDlLnTXKfUEJSXc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ffjPSvkF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 185C26001A;
	Mon, 22 Jun 2026 07:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D106D1F000E9;
	Mon, 22 Jun 2026 07:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782113252;
	bh=NgN6RTq8zSwqE1eU3ABQ5JBArgsCushzNFmwojjYw0o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ffjPSvkFdi24lwbke4pqySkkNhbx53lhZRNYTy6cItpMIPSVcvaOJoDDfixXu4BfR
	 FvM1PuTonPm/MHvnjEpiAwqWMxOjhoeD7f9BSro40la05U3wCyjB4o9YtW01t7oivy
	 +9jBa0SW6FXFHccD1l1y+3nWNg4+M84OyU8aq6U0U/oexu9LxA/MtkSNTZ5MVkiYPd
	 dFDnOT8DTocd98jbVL6d5OkNdNozHruVMKC47BMzz4J3uT5T5Yt7XbAsPttNFWzuGf
	 OBbZOgiGwlMxXbDgR5o/44qzAjWz4gTBChpAE4D55r1rdZp0iF6d1VEa2806GLGncq
	 S6IZvGQj4HUkw==
Message-ID: <3121288e-fa1f-42e1-95cb-0dd7e491213b@kernel.org>
Date: Mon, 22 Jun 2026 16:27:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Docs/mm: fix documentation warning for GFP parameter in
 kmalloc_obj, kmalloc_objs and kmalloc_flex
To: Jakov Novak <jakovnovak30@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 linux-kernel-mentees@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>
References: <20260619113622.11712-1-jakovnovak30@gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260619113622.11712-1-jakovnovak30@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ziDE6CTIcIY9ynMXidyxEyNP"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9969440003
X-Rspam-User: 
X-Stat-Signature: e6kcbs5rt99xe1xh8c89wmxf1zroxoo5
X-HE-Tag: 1782113253-945534
X-HE-Meta: U2FsdGVkX1+3Eh8LlnoL1+OlpEgfLbO5aRhv4eaNF/ZFFwNew9Yjv9WWBFYlEgnnthrXmPOWXyQ4KPOFBg0HFWC6i7KDD4UPCAO+WYq4OslqR/kAjZnKXRvpOknESYiHyXeWKoubxb03vuFvg6MYtCa0fmetstFJcjLuhKKRPSktrjt7LPEJR+TegWeff6De4kSmLoIyals9XZSqtglUxpSIapuvrxJPKrC7soimUihwGqFR6WHAmeajGiDta7qVnvz9cZ26Is0WujCGQ6HllLX8TA5aZvGckFHIEHFMetkvuNxsSO/STrfhqW8U9N6INquSEQuidBU/sOzW4gLfAdX0uj+ndZRmXGYg466f5NIFGt+79wZykYaR3dL7Axge8MKpwAhpmqvvLFMgNZ7QXCCKR0njZNuJhekrWQZG10EkFPwh9Tc+ADXdeIxtbujEyC8mfntP4ZriNfLvfcKShwbBWvQk/sLA/jL5ayTMvd0h78bMsy52mDRkipj+TuaJ0CyBcXbPkM0pzQ2AoHcE2I/waSWl0WiSlX5uawzQADtXheA7EQi2wIXCQvf/Mm4t0K59LQC3Akrq4msfkENvqlvlYzWy57dZgHf/laK6dtbKV2p1JaGoYUES8l0RTRyYEsx49/bIOnN3VkVlDWfZJSjnGLW7NSN8iQ2F5PUuEQHfkXsNchiMa2zzJGBr0QTGUM9lcUOzQNJE7DxKDVOhNpFMpThJojQnhxftS287Id+dtCc0fSnKIr++M3C2G1aullxOZD9sct62/gXTp9nhVjKdTrAtDYUXUixgdjDB+VyRx2q+BRL9taKUJ2Zmq8ILqPQvP0g+PttZlvr+ofHlUMsvb8mdiYajb9RY/HFpBRqhKRUl+E0sN3RsSHydWO6gVi0OxeWqp7dhjrBeTJwEsUlPFFk3qIFVb55tTZMuDdcG6+ID1kVBtjsYTu6yMLpqaFGaMKvRn4hWroJS7nz
 wjGjeZWV
 SG9Gx6A36TmE3DF5Hg7NotcByBfXIIXX5RAqJhHZermRWhZay7MNlQEU90gQq1O9fhlfzNAfL05O2ahG4Okp9H0A2QBpZkXz8he78EheYP5LMemBtl+O8WICD0/IkqiDb7bRJ6WiivDSuLRRehBrWxvlOn50ZWFsSpJU150sNImCzOXB5/IsPUPZhPX50i8ZHWDdIuUj4bxGWtJCZWXOJERbLpxXlKJaypH5ieQpJJBz3gvfkYAGQtkEkT+bjCMCIxgVCqjkA3CBdq1VLgknLgErp5yT/BJSiEDj+rMy6KSdAGtGXyXC2kZsqYvagCs6POtXISeepFlwkI+bhHStNBi3/w8do9xlxmsC0Zs2utYHR1nOQvq+19EW8ra8ChMCYDIR12iywbeMHe+ZTQoH5J3c39HIjOgGJ+r/nIf2dSSMbFwv7P/h1tjrauvJIOXL3uDX7vmlCeBMyt1xyG064+uNycWfDluYu/Nbfn99mseqEkR+XEh0/4DOjbNjnBwKP1RuG2i2iOCXMAaIEAYTu2EUzP5qXuL4EP2FcDPiYfIUbZT/P8XymsP7JR1kQlGfRWg0T7lscd/MosoDi6u7fZBSl50o/PMdyzWli
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ziDE6CTIcIY9ynMXidyxEyNP
Content-Type: multipart/mixed; boundary="------------uWzkArt3zftxILELT3ooxlUi";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Jakov Novak <jakovnovak30@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 linux-kernel-mentees@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3121288e-fa1f-42e1-95cb-0dd7e491213b@kernel.org>
Subject: Re: [PATCH] Docs/mm: fix documentation warning for GFP parameter in
 kmalloc_obj, kmalloc_objs and kmalloc_flex
References: <20260619113622.11712-1-jakovnovak30@gmail.com>
In-Reply-To: <20260619113622.11712-1-jakovnovak30@gmail.com>

--------------uWzkArt3zftxILELT3ooxlUi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/19/26 8:36 PM, Jakov Novak wrote:
> Compiling the documentation currently gives the errors:
>=20
> WARNING: ./include/linux/slab.h:1100 Excess function parameter 'GFP' de=
scription in 'kmalloc_obj'
> WARNING: ./include/linux/slab.h:1112 Excess function parameter 'GFP' de=
scription in 'kmalloc_objs'
> WARNING: ./include/linux/slab.h:1127 Excess function parameter 'GFP' de=
scription in 'kmalloc_flex'
> WARNING: ./include/linux/slab.h:1100 Excess function parameter 'GFP' de=
scription in 'kmalloc_obj'
> WARNING: ./include/linux/slab.h:1112 Excess function parameter 'GFP' de=
scription in 'kmalloc_objs'
> WARNING: ./include/linux/slab.h:1127 Excess function parameter 'GFP' de=
scription in 'kmalloc_flex'
>=20
> This effectively omits the GFP parameter from the current kernel
> documentation. This patch marks the "..." parameter with the previous
> description of the GFP parameter along with an "optional" tag in
> parantheses.
>=20
> Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>

Hi Jakov, thanks for the patch!

For your information, Randy Dunlap already fixed this issue [1] and it
is queued to slab/for-next [2].

[1]
https://lore.kernel.org/all/20260617163125.2716279-1-rdunlap@infradead.or=
g/
[2]
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/commit/?h=
=3Dslab/for-next&id=3D7b5f5865fb11e60edd03c5e063e2d228b7062317

> ---
>  include/linux/slab.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index d4a873a16289..ee952784a150 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -1093,7 +1093,7 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags=
, int node);
>  /**
>   * kmalloc_obj - Allocate a single instance of the given type
>   * @VAR_OR_TYPE: Variable or type to allocate.
> - * @GFP: GFP flags for the allocation.
> + * @...: GFP flags for the allocation (optional).
>   *
>   * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or N=
ULL
>   * on failure.
> @@ -1105,7 +1105,7 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags=
, int node);
>   * kmalloc_objs - Allocate an array of the given type
>   * @VAR_OR_TYPE: Variable or type to allocate an array of.
>   * @COUNT: How many elements in the array.
> - * @GFP: GFP flags for the allocation.
> + * @...: GFP flags for the allocation (optional).
>   *
>   * Returns: newly allocated pointer to array of @VAR_OR_TYPE on succes=
s,
>   * or NULL on failure.
> @@ -1118,7 +1118,7 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags=
, int node);
>   * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
>   * @FAM: The name of the flexible array member of the structure.
>   * @COUNT: How many flexible array member elements are desired.
> - * @GFP: GFP flags for the allocation.
> + * @...: GFP flags for the allocation (optional).
>   *
>   * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL o=
n
>   * failure. If @FAM has been annotated with __counted_by(), the alloca=
tion

--=20
Cheers,
Harry / Hyeonggon


--------------uWzkArt3zftxILELT3ooxlUi--

--------------ziDE6CTIcIY9ynMXidyxEyNP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajjj4AAKCRCGXBN6rc5S
1i28AP9kZ/R5pJglLW7vQ3k/JRuXXtw1sVO8AuErHMquPp6JHAEA89I0Mn4aL1z3
2/mnej3IuOHwj/PvVf8Y2GEoesHeCAI=
=T/7b
-----END PGP SIGNATURE-----

--------------ziDE6CTIcIY9ynMXidyxEyNP--

