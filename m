Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28269E88D73
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 01:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381EE6B0005; Fri,  3 Apr 2026 21:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333696B0089; Fri,  3 Apr 2026 21:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248916B008A; Fri,  3 Apr 2026 21:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15BF86B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:42:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3B428BE53
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:42:17 +0000 (UTC)
X-FDA: 84619173114.14.A84CFDC
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id F010840011
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:42:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YyV9bMh3;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775266936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYjD008uL45StMHqrlooOIeCYoBnE9PF9EGqwf09wio=;
	b=pCQToWhZD/ZeDYsNORWaz9CFL3+PPPJ9T9NeakSwtDMcbOGT2TIwd7ZFkcEjQEyqvUihFD
	5ELjRDTqO/6cVdoWo8SlM9E861XggX/X0kOWz7rbFnfj4hBZjaIjWTWlvB1J3G3Oym+7RZ
	HXabhKk2eeYZGN5jtlaNfCo9SrKOEJ8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YyV9bMh3;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775266936; a=rsa-sha256;
	cv=none;
	b=LOhSr4Pli9T9zD+F1Ak/t8diga9xWcXhL9m+l98qTHFVvnhrW6LG1uphNd7GaRLjTNqOT/
	9eaxLSVYgiJbR74wtk8s3WLRGlDI60Z5DnSWqAl7U+AU8l8ha5aE71JtjRzC8fEQSvP+Mk
	2dQXJAUkueVAKQrViPe6MXdXQeysU8Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Type:References:In-Reply-To:Date:Cc:To:From:
	Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dYjD008uL45StMHqrlooOIeCYoBnE9PF9EGqwf09wio=; b=YyV9bMh3yUvgXsBWT3wVQGlvn3
	Bm67bQUPDrQFkjAxNV/LZvF47hKwmb2mu2tviUiIjoF+9fGH9+B9xXB9/PZKXHbPmZGgacO/XhXW0
	IHFCUKc+Uzua0euEAmyJVPKOlP7o91Ko8YVdMASaeiCLZ+o+0P8tbq3qV5LGef4Ye7QtKipKEVprf
	jN2sunLo/2k6tI5QDPDpC4XcU6U2q2Ql3p6XrijeQmsg1y0TjPa+ySm0H5xiTJHUvebdnAZnvdV5b
	FOj4DD8jWbPO4mkDCyPvUsAqZBtq1uAlq/8jE2O9UB2/Rl8dngQAvlda5kiyT1DumbebMw+hqgPWq
	D1Tp6yqA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1w8q1Y-000000000bq-3o6A;
	Fri, 03 Apr 2026 21:42:08 -0400
Message-ID: <984aee1a7af2ea4b576a0114a367402537d3deca.camel@surriel.com>
Subject: Re: [RFC 2/2] mm: page_alloc: per-cpu pageblock buddy allocator
From: Rik van Riel <riel@surriel.com>
To: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett"	 <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org
Date: Fri, 03 Apr 2026 21:42:08 -0400
In-Reply-To: <20260403194526.477775-3-hannes@cmpxchg.org>
References: <20260403194526.477775-1-hannes@cmpxchg.org>
	 <20260403194526.477775-3-hannes@cmpxchg.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: multipart/alternative; boundary="=-G84DnAen4wjH2efzQkyl"
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: F010840011
X-Stat-Signature: t7bcnxxhexgkokwpc1ypb31uj3jw5o5e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775266935-305062
X-HE-Meta: U2FsdGVkX1+UI7YumRyC0PRHYO4DRCTkoPJKwpr6oTBbLNKnaRJen5An4YF050bLGgrNeqKMJy82X9ThbVO/sLPubnLJMssA8U1hl0res1xs1siAXkVgSsy/kOLH2RHg3rvjhXQHa7uPyqiB1ZunHNM3goLdcEWjXiKMNiHrFuQswFjlHWQV3X7ngCI3jPWo4H3UKtly+K60kPCmhrRtAw/XE53pp8dfOaiRDe6rTHs/WJVS9+1sKhFWIYD135GXhBix814nKWubt26oOmp1O3TXtAn2cvbSfufOj5uaIZl9nf6TWDti0+TuqvnKbrPeKavqhhIfGc+V59t/tKbPg2spSy+BkToKA+1RKWm9klabgnXi7104/RLyAXm/NUE9CmoSEQDDn6rRi7paXoAqKtOaW+KFpuqrtUROFcQangZ1heSq7jmLxgHudJPCHcuZLt9KNtpQVNncGTD6XL0TiPn1t0UM29lbGDhjjsVUnAU8YvHeAGdiCa8M/lw4cTxI27p5SPutJzcpoSsxBz7EUOe6V8efUyMoz8ddot9Z0mNM+LJVe7Fd4grCA6A7Lc6g6Hx4NRZfg1juJ1aznkqmDOt779F2I6vOci9vVW2wxayAPhi7ELYwwhjbJay42Hy7afQVf9n/bmifXGADm8RdlSNDPsYKLnVO14h/tuuIs1ub2pzf3wMl7UNHNoxIqCuX/sI45uS/0hlMp9dP5GFMNfK02RNc2M9NhRFbT2HrtuMsEPKDu8Dzhd117hPD7zUERjk9sFuJDcMikpcCgdJI2SGy/FjECB6hehItqizPJcqVjdnSFUdTrK/ajhCcyhepOSnlW5eP2ue6fK5vmtZhVURpMy304dfNqm4XHNOvuxrJ7aZg3eRFzJovs5+Z7DHCLgKxnWlga34av3DtSU2pcg2I80/GuKwZ0tyFEA466P745vlVKlXYALpiTgsUPv8epN+DTAcJ9XDrPXsLZ3t
 UQfxS5hg
 jkMz+ggYf1qdPaiigCjQi/c2BGK91m80C+nbVP19GKeNMG0MhDJYzE3/UY6sAjWONTr5J3RqoSqErU0ZWeP3ug5aepTiCpgd+B3JyNDs7AaWnQ6QKNfIMXl8Jm1GtrCvKUwY1g1JOcWDPXQzJ4CsP5KxnNyOAdTZp1KeWkZHMLTWm79oFUCRC1IkGQSEE1Rp5xmyfg07Qf5L1+Qor1V0YpEiVMnUT6uwgCgrALDSQC5TnMtFmJmw/GAFDILJo1W5lt8zY73kLJAbreK1Srg2wHGYneRUsHvuyQivkR7m9xXwbInOyaLzXQNYfb9e3c0t9zNM22mH79whB0NTMKwasBvaZfp7gBx53BYSkVM8Apxkxac6XJ35pGXoTqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--=-G84DnAen4wjH2efzQkyl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-04-03 at 15:40 -0400, Johannes Weiner wrote:
>=20
> @@ -755,6 +752,9 @@ struct per_cpu_pages {
> =C2=A0#endif
> =C2=A0 short free_count; /* consecutive free count */
> =C2=A0
> + /* Pageblocks owned by this CPU, for fragment recovery */
> + struct list_head owned_blocks;
> +
> =C2=A0 /* Lists of pages, one per migrate type stored on the pcp-lists */
> =C2=A0 struct list_head lists[NR_PCP_LISTS];
> =C2=A0} ____cacheline_aligned_in_smp;
>=20

> + /*
> + * Phase 0: Recover fragments from owned blocks.
> + *
> + * The owned_blocks list tracks blocks that have fragments
> + * sitting in zone buddy (put there by drains). Pull matching
> + * fragments back to PCP with PagePCPBuddy so they participate
> + * in merging, instead of claiming fresh blocks and spreading
> + * fragmentation further.
> + *
> + * Only recover blocks matching the requested migratetype.
> + * After recovery, remove the block from the list -- the drain
> + * path re-adds it if new fragments arrive.
> + */
> + list_for_each_entry_safe(pbd, tmp, &pcp->owned_blocks, cpu_node) {
> + unsigned long base_pfn, pfn;
> + int block_mt;
> +
> + base_pfn =3D pbd->block_pfn;
> + block_mt =3D pbd_migratetype(pbd);
> + if (block_mt !=3D migratetype)
> + continue;

GIven that you just skip over blocks of the wrong migratetype,
I wonder if it makes sense to have a different list head for each
migratetype in the per_cpu_pages struct.

Not that I should be saying anything that would slow down
the merging of these patches, since making the buddy allocator
more of a slow path is pretty much a prerequisite for the 1GB
allocation stuff I'm working on :)


--=20
All Rights Reversed.

--=-G84DnAen4wjH2efzQkyl
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head><style>pre,code,address {
  margin: 0px;
}
h1,h2,h3,h4,h5,h6 {
  margin-top: 0.2em;
  margin-bottom: 0.2em;
}
ol,ul {
  margin-top: 0em;
  margin-bottom: 0em;
}
blockquote {
  margin-top: 0em;
  margin-bottom: 0em;
}
</style></head><body><div>On Fri, 2026-04-03 at 15:40 -0400, Johannes Weine=
r wrote:</div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-=
left:2px #729fcf solid;padding-left:1ex"><div><br></div><div>@@ -755,6 +752=
,9 @@ struct per_cpu_pages {</div><div>&nbsp;#endif</div><div>&nbsp;	short =
free_count;	/* consecutive free count */</div><div>&nbsp;</div><div>+	/* Pa=
geblocks owned by this CPU, for fragment recovery */</div><div>+	struct lis=
t_head owned_blocks;</div><div>+</div><div>&nbsp;	/* Lists of pages, one pe=
r migrate type stored on the pcp-lists */</div><div>&nbsp;	struct list_head=
 lists[NR_PCP_LISTS];</div><div>&nbsp;} ____cacheline_aligned_in_smp;</div>=
<div><br></div></blockquote><div><br></div><blockquote type=3D"cite" style=
=3D"margin:0 0 0 .8ex; border-left:2px #729fcf solid;padding-left:1ex"><div=
>+	/*</div><div>+	 * Phase 0: Recover fragments from owned blocks.</div><di=
v>+	 *</div><div>+	 * The owned_blocks list tracks blocks that have fragmen=
ts</div><div>+	 * sitting in zone buddy (put there by drains). Pull matchin=
g</div><div>+	 * fragments back to PCP with PagePCPBuddy so they participat=
e</div><div>+	 * in merging, instead of claiming fresh blocks and spreading=
</div><div>+	 * fragmentation further.</div><div>+	 *</div><div>+	 * Only r=
ecover blocks matching the requested migratetype.</div><div>+	 * After reco=
very, remove the block from the list -- the drain</div><div>+	 * path re-ad=
ds it if new fragments arrive.</div><div>+	 */</div><div>+	list_for_each_en=
try_safe(pbd, tmp, &amp;pcp-&gt;owned_blocks, cpu_node) {</div><div>+		unsi=
gned long base_pfn, pfn;</div><div>+		int block_mt;</div><div>+</div><div>+=
		base_pfn =3D pbd-&gt;block_pfn;</div><div>+		block_mt =3D pbd_migratetype=
(pbd);</div><div>+		if (block_mt !=3D migratetype)</div><div>+			continue;<=
/div></blockquote><div><br></div><div>GIven that you just skip over blocks =
of the wrong migratetype,</div><div>I wonder if it makes sense to have a di=
fferent list head for each</div><div>migratetype in the per_cpu_pages struc=
t.</div><div><br></div><div>Not that I should be saying anything that would=
 slow down</div><div>the merging of these patches, since making the buddy a=
llocator</div><div>more of a slow path is pretty much a prerequisite for th=
e 1GB</div><div>allocation stuff I'm working on :)</div><div><br></div><div=
><br></div><div><span><pre>-- <br></pre><pre>All Rights Reversed.
</pre></span></div></body></html>

--=-G84DnAen4wjH2efzQkyl--

