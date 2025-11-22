Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C72CCF64B1
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 04:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450F06B0010; Fri, 21 Nov 2025 23:51:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401326B0011; Fri, 21 Nov 2025 23:51:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EFA06B0012; Fri, 21 Nov 2025 23:51:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19E8A6B0010
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:51:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 632C41607C0
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 04:51:39 +0000 (UTC)
X-FDA: 84137019918.28.0752773
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf24.hostedemail.com (Postfix) with ESMTP id A0B15180007
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 04:51:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763787097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lb5XVyTevFRmZ3WNn7e33CY5XsENhkQmd79+UQ0qfZk=;
	b=moaeZbk63KzEBm36BZTkiiElxlNlGnjfCl5UxU6Jurz5Jxvr39xySyHItwXX+n2rQyIPXL
	OqzdVXe22usz47yRhFAp03EcjzTF48xzoqvhAoAPRqIGLxMePOIe75xwjNUNvzoR/p2vEg
	7ycc4coJOzEkqC+VqTm0C2mKqW2/KzM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763787097; a=rsa-sha256;
	cv=none;
	b=OmjJXNFFfpSA8MQF41W2/0Hp4OZpA3irf+pZ+pZz9PVxJL+/J5JRXL/emVuQJom6B1Rtac
	oUBhuVhxf46KNHJGpR27TKSP5469w7PeedmHHW7OW4ueWLCjOSPne8AhSajDr+hkfpm/wz
	MPLjQY3PILjsMEaMi7tGF2jFo5P7fe8=
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5B841607B4;
	Sat, 22 Nov 2025 04:51:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf14.hostedemail.com (Postfix) with ESMTPA id C6BA130;
	Sat, 22 Nov 2025 04:51:20 +0000 (UTC)
Message-ID: <f1d2bb84df85237f23ebf6e0f3dfecfd72d615b6.camel@perches.com>
Subject: Re: [PATCH v5 3/4] checkpatch: Suggest kmalloc_obj family for
 sizeof allocations
From: Joe Perches <joe@perches.com>
To: Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>, Dwaipayan Ray
 <dwaipayanray1@gmail.com>,  Lukas Bulwahn <lukas.bulwahn@gmail.com>, Randy
 Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,  Przemek
 Kitszel <przemyslaw.kitszel@intel.com>, "Gustavo A. R. Silva"
 <gustavoars@kernel.org>, Linus Torvalds	 <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,  Christoph Lameter	 <cl@linux.com>,
 Marco Elver <elver@google.com>, Vegard Nossum	 <vegard.nossum@oracle.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes	 <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton	
 <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Bill Wendling <morbo@google.com>, Justin
 Stitt	 <justinstitt@google.com>, Jann Horn <jannh@google.com>, Greg
 Kroah-Hartman	 <gregkh@linuxfoundation.org>, Sasha Levin
 <sashal@kernel.org>, 	linux-mm@kvack.org, Nathan Chancellor
 <nathan@kernel.org>, Peter Zijlstra	 <peterz@infradead.org>, Nick
 Desaulniers <nick.desaulniers+lkml@gmail.com>,  Jonathan Corbet	
 <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>, Yafang Shao	
 <laoar.shao@gmail.com>, Tony Ambardar <tony.ambardar@gmail.com>, Alexander
 Lobakin <aleksander.lobakin@intel.com>, Jan Hendrik Farr <kernel@jfarr.cc>,
 Alexander Potapenko	 <glider@google.com>, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
 llvm@lists.linux.dev
Date: Fri, 21 Nov 2025 20:51:19 -0800
In-Reply-To: <20251122014304.3417954-3-kees@kernel.org>
References: <20251122014258.do.018-kees@kernel.org>
	 <20251122014304.3417954-3-kees@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+Sr1JQ+437w6kkX38ORxtyNSi2FQhscRU=
X-HE-Meta: U2FsdGVkX1+M0hbju6B4R0TNwI2E2iep66FeX6Que0tNsb+p8wMZ25hWgq/0Vg70NWm4auf2lfTvdpVhLVnfB1hBlf5wFSevwBSyC6wNObgGWMSG0iH9DzDUrYTNDo1mwj53A3UlpMDs/Z2ciaydLxUjMSIkc3wYa0yAFskiGr3Tq2v2v12WwDKOLviXDa9mthgm8+7cSFMGd5Waqo5a6wL6Mgv1Le1Mknb+2EzvfPlMA8grKHD5zYIb6mFlNhPbNWs5Ml0iBRYXn8u6C5HyT5LVyPiZlIL+x5IRaAH/Pm0+Q/OzWQjOGYlSjR+teOoC
X-Rspamd-Queue-Id: A0B15180007
X-Stat-Signature: y1e6wye49h55e9yihtz99bqq8wccka44
X-Rspamd-Server: rspam02
X-HE-Tag-Orig: 1763787080-150056
X-Rspam-User: 
X-HE-Tag: 1763787097-316547
X-HE-Meta: U2FsdGVkX1+HNBfmNEpINqm0s17Ll2pw1uCOdoZCwKJdVztU9tlD2+ukD8bYWV32BSIexsCeGp21l0UDBgdcIg7wAc4KeWRtvYioOk1Zt58iYNY4gtnlyWMsxwox9l7kHAL+H89sIWKDxfckMillHMrNEmcFQNxzFGGN5f4UzgTH+7ibu34QAmWxAtWw1S6gk7xGvSohOTRYCBjKRST5omciw7JbsYZFWSnAm/1HqZl2jFJxDs5369ib9ao5ldfyhp/m4OveYfxVMvw06tE1iUcoGaHQpgKcgptlJdZHJKQVfOEe+XlytNZ2qIUi+OwhLquPDH21gArVY1H643H0gvx1KVLWJcdvY+2qid2UGBCd+V2FACsyo5QknJsBDQnfNGWsKwoRZXWpexxqDmg4rb8IseJAvtqmfMCZKIoorEXSWPLjFuNXmLVR2vb8f5B70xGh6TOzohs7OsW5BQf2ThsNnEZR3GgblmOIxviWAm8LmhN7QnrPp3mgTg+GmCk6VluF8JIlvYvXWYi+JbPaZVu8c1k+LCE3hpqYVnZMK4/41M5nVygsNAANvwoMqythsl0Ec0A5YDnGiA/JfJu1Aqx8iDtrpPmomNsucLBLoogFNVu3Q0uFsItE5mnSNxgN0Mk35FK9YBsj3SKPdgaEBqvLLIyFKkQW889ub097kyOcnnkxuf3CfdHrZjbM2NMSh1vqqkCDISDLNfJuALns66QCDxoC32ifNQeiN1877Cw4bhLIzkPrNNuLV0lJpes2G/0F567Gwz5mQxOlDTufEsKB+74FSDLUsslQcFQcxjOQPUxgSNEKLC0tVlif2M090i2alOE/LmoYbqz5TZQjERPZXtvOZDmljMIX/jiYVFlU+PTJckKGUSEaFEFqY0GQdKS+1hxOoI6+IkwRAGwviJ6XBpfy3PmndfKKvXDA4WsUkGHagv9bowqv6mdpa6o1yz7HaxtceNtHCHCA9iX
 jVtESHEF
 2Ehl37RahGk4cRGiGvRC/itdoTa6WAHdD5eHhv9OousxoCoYA1AGLVktmwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-11-21 at 17:42 -0800, Kees Cook wrote:
> To support shifting away from sized allocation towards typed
> allocations, suggest the kmalloc_obj family of macros when a sizeof() is
> present in the argument lists.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -7258,17 +7258,42 @@ sub process {
>  			    "Prefer $3(sizeof(*$1)...) over $3($4...)\n" . $herecurr);
>  		}
> =20
> -# check for (kv|k)[mz]alloc with multiplies that could be kmalloc_array/=
kvmalloc_array/kvcalloc/kcalloc
> +# check for (kv|k)[mz]alloc that could be kmalloc_obj/kvmalloc_obj/kzall=
oc_obj/kvzalloc_obj

There are _way_ too many of these existing uses to suggest this change
in existing files so please add '&& !$file' to these tests

> +		if ($perl_version_ok &&
> +		    defined $stat &&
> +		    $stat =3D~ /^\+\s*($Lval)\s*\=3D\s*(?:$balanced_parens)?\s*((?:kv|=
k)[mz]alloc)\s*\(\s*($FuncArg)\s*,/) {
> +			my $oldfunc =3D $3;
> +			my $a1 =3D $4;
> +			my $newfunc =3D "kmalloc_obj";
> +			$newfunc =3D "kvmalloc_obj" if ($oldfunc eq "kvmalloc");
> +			$newfunc =3D "kvzalloc_obj" if ($oldfunc eq "kvzalloc");
> +			$newfunc =3D "kzalloc_obj" if ($oldfunc eq "kzalloc");
> +
> +			if ($a1 =3D~ s/^sizeof\s*\S\(?([^\)]*)\)?$/$1/) {
> +				my $cnt =3D statement_rawlines($stat);
> +				my $herectx =3D get_stat_here($linenr, $cnt, $here);
> +
> +				if (WARN("ALLOC_WITH_SIZEOF",
> +					 "Prefer $newfunc over $oldfunc with sizeof\n" . $herectx) &&
> +				    $cnt =3D=3D 1 &&
> +				    $fix) {
> +					$fixed[$fixlinenr] =3D~ s/\b($Lval)\s*\=3D\s*(?:$balanced_parens)?\=
s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*,/$1 =3D $newfunc($a1,/;
> +				}
> +			}
> +		}
> +
> +
> +# check for (kv|k)[mz]alloc with multiplies that could be kmalloc_objs/k=
vmalloc_objs/kzalloc_objs/kvzalloc_objs
>  		if ($perl_version_ok &&
>  		    defined $stat &&
>  		    $stat =3D~ /^\+\s*($Lval)\s*\=3D\s*(?:$balanced_parens)?\s*((?:kv|=
k)[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
>  			my $oldfunc =3D $3;
>  			my $a1 =3D $4;
>  			my $a2 =3D $10;
> -			my $newfunc =3D "kmalloc_array";
> -			$newfunc =3D "kvmalloc_array" if ($oldfunc eq "kvmalloc");
> -			$newfunc =3D "kvcalloc" if ($oldfunc eq "kvzalloc");
> -			$newfunc =3D "kcalloc" if ($oldfunc eq "kzalloc");
> +			my $newfunc =3D "kmalloc_objs";
> +			$newfunc =3D "kvmalloc_objs" if ($oldfunc eq "kvmalloc");
> +			$newfunc =3D "kvzalloc_objs" if ($oldfunc eq "kvzalloc");
> +			$newfunc =3D "kzalloc_objs" if ($oldfunc eq "kzalloc");
>  			my $r1 =3D $a1;
>  			my $r2 =3D $a2;
>  			if ($a1 =3D~ /^sizeof\s*\S/) {
> @@ -7284,7 +7309,9 @@ sub process {
>  					 "Prefer $newfunc over $oldfunc with multiply\n" . $herectx) &&
>  				    $cnt =3D=3D 1 &&
>  				    $fix) {
> -					$fixed[$fixlinenr] =3D~ s/\b($Lval)\s*\=3D\s*(?:$balanced_parens)?\=
s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' =3D ' . "$=
newfunc(" . trim($r1) . ', ' . trim($r2)/e;
> +					my $sized =3D trim($r2);
> +					$sized =3D~ s/^sizeof\s*\S\(?([^\)]*)\)?$/$1/;
> +					$fixed[$fixlinenr] =3D~ s/\b($Lval)\s*\=3D\s*(?:$balanced_parens)?\=
s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' =3D ' . "$=
newfunc(" . $sized . ', ' . trim($r1)/e;
>  				}
>  			}
>  		}

