Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B65D60A261F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=elhci1b6
Received: by kanga.kvack.org (Postfix)
	id 523026B05BB; Thu, 12 Nov 2026 12:33:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB366B05BC; Thu, 12 Nov 2026 12:33:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411E96B05BD; Thu, 12 Nov 2026 12:33:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 174156B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:33:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8AAB31C3F21
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:33:03 +0000 (UTC)
X-FDA: 85427162646.20.1B42353
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id DF20840013
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:33:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=elhci1b6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of alx+linux-hardening@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx+linux-hardening@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794504782;
	b=tg1ukF8SRiGJJwSbBSmgehBbjoEmQzvERfdZ12X27kQExdb8NmnwZNEDmg1/xKEs6H8P5w
	nZTD0FTiNpFBaCiMzTP1c05w+eTL03UjqOVWKjnWTKYQ9uhYN7d9Ae+LvUOPbeWWuRhhGq
	d8WaqalJX88ZkbSFx0AJrF3r9rvGy5c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794504782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijLAFKTpy2rO1cmzfktYDhNmrdiTCs2qOQ9IyeBu0gU=;
	b=HxDCoy9Vzrye6G7/awza2QKhGXtiyfCyY7oxGjDe0qOJ2SPV71h66EKnWMYqxAIUUiWKWa
	DTDKsOEk4GQqDUPFmdsP2SwquH7M27Ynd+K3m+vxKGnv2ou25JPVcaE9Ufdd3HrAMjfNGZ
	IFwgP86FvAgPkiMNFkglt+ppy56AryA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=elhci1b6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of alx+linux-hardening@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx+linux-hardening@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51DA160D47;
	Thu, 12 Nov 2026 17:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE9A1F000C4;
	Thu, 12 Nov 2026 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794504781;
	bh=ijLAFKTpy2rO1cmzfktYDhNmrdiTCs2qOQ9IyeBu0gU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=elhci1b6GnKtBWt0nQTZvjUTh92Tkc0Atzo7j8Uh/tHub/ME65zeo1xQsu/jIpVp8
	 5IJ/EkDpmZ7RUIaOyASBzPSETZCCEWYV5ZcE6YlUymvq6CVKiBSoHYE2l4QOYdjen+
	 53LJsT1qg38aLYwSdA8k3QDgypHmRMmasM6uGKYCo06YUiVUQt8SK4b+DQF1kZ3Uha
	 tpHmLS6jsp1PvpcklB4To0trHT7m70w3vUlpaSWJvNSCRoNIypW1bho53PTEbdYrpg
	 C5FiY50vSOtCQKOBkAn0E5jzUUTLNPXpkEYW1MclJlLcpRSkKAs0s2GWQb6e7FNs+Y
	 pZQL8t+07nmAg==
Date: Thu, 12 Nov 2026 18:32:54 +0100
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Kees Cook <kees@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, driver-core@lists.linux.dev, linux-hardening@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for
 devm_kmalloc
Message-ID: <avX3Y08tF8Z0C4LH@devuan>
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-2-kees@kernel.org>
 <20261112004039.GA523044@killaraus.ideasonboard.com>
 <avWNCC3_Ff0knO6J@devuan>
 <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="o4pnicbxuhqys6k7"
Content-Disposition: inline
In-Reply-To: <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com>
X-Rspamd-Queue-Id: DF20840013
X-Rspamd-Server: rspam12
X-Stat-Signature: pwjyfd6sehmkujzrtcc3x6epi4ye5qwn
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794504781-523377
X-HE-Meta: U2FsdGVkX19lhXnwjFGy+Ign7KwzyZ2tu+HFBiGFPkYM99V6ng1yuvbvJZUt/5S0Ns/dSTfe1oUSwmMWv+aADoHt/f4S1PUsE3V8bzV2xi9h1+Vw65WzBjRh+qDqmzNiuzY3Pt5jTiLLL3gsqK41uuB3NiYMGzjmYtzHdW8EkAGjGsCmfWEclPd3EhF4ENrQAfD2EeKAb7TY1HvY0Lm7s1vUEgyGwyfC2G4d+Bws3GChFKyYq1S/5f9KQ9F2N/8T8JP/ICG6YxJ0oiACsu/SWry12vyj6WIMnfG00S/t77MUxrB+TK6Q7dh8AKal4uU+DZlKNznbzi8bPMfy0PUvuRoTwGTDN8T4YETxlp2kTQBUYpC69poHWuUmVTauR0NLH9TP7yMxA4E6b3cQZ6XGZrQY8HSKnbWP6oSprCkYYxWvsS4NZCCkWOtQgAGCy6FzIoWknJLyiBGOQCpPhJA2nbjTMFFsQaSMnQCYdcQymQwOwZ8QzEMixh/0ABcTXRZn5j0o8m0m0gzqft1sWJ1J8xru5iNIKV6rfFF8Qfei6KisL8r0CMALhbFF/ozk6QDi8Jt6/M7LDSG/qR0Ksci0K3DN9sT4n7QcS4zPog1SMEQ1q065g2LygWaGgGT6CjsX+/6f2GPBq2vZqF6tkMd7+SDBEOAmbt0lY9jKCN/RA2ZKXF6/XpMCjdTGBjMJx3m0w5yu3V51aEjyrBQg1YwCzUdwcV4eT7OK95BFlWlEjJDoCzjNmjjvzmZ9HWL76g3bl1HoltRcw2LZjniO9qv8luNIrYupGOzda3kCwiiGlNuaWFdZb/HAey/iUQh9/mpEpiOW3pPA5eW6ec3wP59cQ/l8zYp7FVm27Yx3teU7wVoTZMyM1XDPmY41W03c1YZTk+FV7IOCPIxHc2vsxuV25VykzzUyfiVEzUN7Dv37psilcGl2uuhEcWdXWgZmU2RRbIZykWc03dCHfyfBYXA
 lrgpA+zk
 aKRWx+4m1G8Ng5z/8yzO25gtIOul1wV5opjYCTux/438OSIRcwjwO7NGKtO6F33DqKEN9AB4byC6y7KmP6j7DNgTNO1AFDyYxfQE7x4FMJt9nqvU8stfDG8xegBc3ZbAc/DFdlDyQn7+HWMEh3B0YqxY1BNrVpnUvhvHogY/V0UZUdOLU8+SFY57Xv1zD/8MYJtaxLjxNhS/rXBfG9RG4tLUunHt1GztCqA3oon3wEHH7H8EfOBQ/meX7rzz6yIMueQwQc79RHplCGlRMb7H6LRUf0JXLqw6YeOS5oQRlJn5CU2NyqRTzci/Si29QeOyFWFROzjvDWfX1wZLHyu/yNEQp+o7Y6Qbks0mBVGVqh+BhAFFvj+E0FAJ5y8F+sWTd/IbgAcu0Ml7GS9wSljYb/bqqGo/Xj0+VBpb/iCwHjF3gWIuLm8YQ4jeoqIebIXu7vQWwKbqfnZDGiTJbhC6uO0tsyXcTsSJuzrL9H/gRE+R4b9BwGzHAsWBWRGe2p5IlroAUk2xvtHSADv8xJkOuUHGV0Faj8NXBKoTOi8gVjAgxQbYEnqrwYIfTR6V6IX66puX1Qk1ZdnxvAonniJ39htFjz9/FE+O5/hVZT+eF5aDFuk81c4yuFuai9IxDhKnux1izk1/Zgy2sjuf7eBhuct8cNG1V8aX0qPkOO//GwtrM9iRK22lhSAq7oIfXFjHX1stjM1jVQ+D+pK9oKgcyimSwZy9LTDhbqe6L7FxG/07nmhpmRDjxKq5bmsVhJT0I3ZmgwqluqpoFOba6vKVRi1Xj5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--o4pnicbxuhqys6k7
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Kees Cook <kees@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, driver-core@lists.linux.dev, linux-hardening@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for
 devm_kmalloc
Message-ID: <avX3Y08tF8Z0C4LH@devuan>
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-2-kees@kernel.org>
 <20261112004039.GA523044@killaraus.ideasonboard.com>
 <avWNCC3_Ff0knO6J@devuan>
 <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com>

Hi Linus,

> Date: 2026-11-12 08:34:13-0800
> From: Linus Torvalds <torvalds@linuxfoundation.org>
>
> On Thu, 12 Nov 2026 at 02:13, Alejandro Colomar
> <alx+linux-hardening@kernel.org> wrote:
> >
> > I suggest removing kmalloc_obj() entirely, and using kmalloc_objs()
> > always, with a second argument of 1 when we want a single object.  This
> > would remove the risk of that typo.
> >
> > I also suggest having default arguments without variadic macros.  The
> > way to do that is using empty arguments.  Linus complained that it hurts
> > his eyes, but it really makes these macros much safer.
>=20
> No to both. These are both "make the code worse to catch errors that
> the compiler should have been able to catch anyway".

I don't agree that the code is worse.  It's _different_, just like Rust
forces one to write different code in order to make certain bugs trivial
to reject.  But I don't think having to write malloc_objs(T, 1) is
objectively worse than malloc_obj(T).

But let's agree to disagree.

> If you *really* want to catch them, make "gfp_t" be a 'struct'. That
> way even compilers without things like the restricted types that
> sparse has will catch at least that one.

Yes, that's a third alternative, which Kees and I discussed some months
ago in Prague as a mitigation.

> I did that many many years (argh, decades - I'm old) ago to catch all
> the 'pte_t' etc issues when rewriting the MM layer, and it works very
> well.
>=20
> It's going to be somewhat painful, but ti might be worth it. People
> who only use GFP_xyz flags to pass them around wouldn't notice.

Indeed, I don't volunteer for writing this patch.  :)
But yeah, it would also work.


Have a lovely night!
Alex

--=20
<https://www.alejandro-colomar.es>

--o4pnicbxuhqys6k7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmr1+EYACgkQ64mZXMKQ
wqlMCw/8D8u1QGJxQwMLy0ohBNrNNSiwG+9uYTovzBcTZNUribjecgVSktGCQgCd
o+kAvS4NRBmheiua/UIF9dZ1UV7Vdn1tzPIV8EQj7/mRvQy88KKwrrZXy1DCUTuo
sNDTbAcOzuRnrTIBl1TkQvPo4zc6YbWeDh+v+ZMkelU8jU/lx5tj0XtC1LPgnI5w
vrkXOSgyCWO9OnljQL8A68U5u3vsSdbXt9wHXyOjmFUAo8Pfu8dvhT+gv7bKAJrt
PE9W4sMXLWaYMDjpbCSHS/4t6REVcSspzh7g9YkVXGXAKDkps5YQrJbH5eeGMG0k
6iTxucLbzRrNck24w662nPeGWwYA6b6pn0JW4riCZfxKHTpMBY/XdlrcOWT8RBn8
PQNSJH9/txKdRQghBIK4yCxhW+y1x1slic57adqPizBJAW6AdzVPlYVaTZOeKE4E
ppg+JQ77XLA2BTtd+ROkTJdDAycc9fwrhY5bnpAzEzQeuojymLW3bYQZ54jxTmXc
k5qFDyKnNKtvIVCNfelZtmExZpPBFozOr5BYZ2lo0xounJKyu+j2ynNUZeH45oxj
+ZQBvzb7NEPFMee/5zkcb9odWebSaZ468E10YYPH51AkNtFmoN2SOSyVpzmmbT/w
fShkHI5qPzCw/J+mGgtPOmMgQN8BvD/kZTsr+SFo1Y0GDEmNWnA=
=GL7T
-----END PGP SIGNATURE-----

--o4pnicbxuhqys6k7--

