Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC64C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50678E0024; Mon, 11 Aug 2025 05:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01408E000A; Mon, 11 Aug 2025 05:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EB68E0024; Mon, 11 Aug 2025 05:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4FBE8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:21:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF5881DD981
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:21:00 +0000 (UTC)
X-FDA: 83763932280.02.F1ECC3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1E27080009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:20:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oksEQOqM;
	spf=pass (imf30.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754904059; a=rsa-sha256;
	cv=none;
	b=bqTKj/m5kYlVN0jGR6ZuyC9HMv85PljQ+vpzcM5gVG+Fjyke//MaZUQCLFltDnFrgZh918
	iXZ58tXnsn+gMBDqbrCR1iH6hOxGziHCf7TB+tKjWRgGzc4dGzUylGPOAXjVtxuTYkl+i3
	5GJ4lnMtNj1hR2+6VuQ2U6vpMIxQgEc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oksEQOqM;
	spf=pass (imf30.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754904059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzkyks50EWUz2MZ1OFoqF3BpHb/X7mvPXbtH2QPEdk4=;
	b=fb6IgLhQw5BiuWm+w0qXOXdA5GjXhD4EoLPts67Gkxm94ChbExRYVTN1G2lBaiM7f8+FgJ
	hhYbtKuKqy0bJcYILdDJRevN4sFVEmunLV08Jkb1nd1yOvB2jH+VCo0trGVzZBr7FyjTem
	rYdFcPTzc5MhuFZDTo6+iL9prR1HimE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EC5E4570F;
	Mon, 11 Aug 2025 09:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953FCC4CEF7;
	Mon, 11 Aug 2025 09:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754904058;
	bh=zVWx4ZTneBogMsOlcaZR03vsIq0ezyb2I7LWj7kgLSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oksEQOqMUdyBxuwfuLKe37pFoOb6VRj3GDQarDMsJbDnBbc/9AwEbBuijT6yE5gjX
	 Aza7iUY+J8HW+ykZdsXkx1WgmVMRM3m3dIm1IJ+Qj+zZy79pMGLdum9EgqQFdkI/bP
	 XJLAcgxv74KTK+drCslPeAHb0IhVk41s1KqERWrzDoKJpExThxKw0qaYhINetJr5NG
	 Rp3xwx0tmN4m+mPzFMQUnIf4y0XLSttdNCMRAPFeU+023/YRULigbX1alYCc2T1wQ5
	 /KEYWWQk3a8mJiTdEm3cGp9HtqffW7Qa143N0XfozT1jl+1/PvvhfodGx58uFRZgOy
	 zDYZZPN6DXr7Q==
Date: Mon, 11 Aug 2025 11:20:48 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 2/2] man/man2/mremap.2: describe previously
 undocumented shrink behaviour
Message-ID: <ac37lpfte2my6wlrk7omoeaul5spekd4pjzhutlmzanxtshneu@dsxs65meb74r>
References: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
 <c7ba8ba09b1c0b015134c54824788ef4aa47fd46.1754414738.git.lorenzo.stoakes@oracle.com>
 <iolucvrp6is43yjulbluchhw5wy6urq2gtwmcelg5atwuv63se@ovzuthfrup26>
 <0b0928a3-03b0-4a36-817b-b75c1f5c78f9@lucifer.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lgj4tlj4klqgw6oe"
Content-Disposition: inline
In-Reply-To: <0b0928a3-03b0-4a36-817b-b75c1f5c78f9@lucifer.local>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E27080009
X-Stat-Signature: keb7doc3148zd4e8fjzg75nj11rm89cp
X-HE-Tag: 1754904058-557174
X-HE-Meta: U2FsdGVkX18Cm3OpXLuxkE9hpt6+mglX70AuOEDKxMNKzPYKWawsA8rGpv5j4pZCl3aAmvece2jfG4eEqkh4tDqNhK2S/OF6yu/RLWDA81zDGFM1zuL+fo3ZJgHgrEGNLHDeBZFrAHhm5c5AyNRbtZGnkJv9thMbfElD3kD9fNR5uJeyyUsHQTP9IAdvWkngGa8W8X2BDt2Pgk5pjwOFdS8cKa9LJIQn8RZ+yPtsAm6LFHDSEkHy83d+tN8q0Sd8wMJp5CFI5y2Uw8U/xAU3aXT3MaBxeyQ2KgLk3RJ7CFQYoQRb+oOAvlimN9Hd1jZQ/9VCVuoy3kCdfEXjWQLKbKnUI/jcxxd74JW/pj86U87qOeT99FD6UvP0iNOSJi4PhMB8v2VKUFKoIo4OnMQDR+JNu/9cdEy807tUmX0t/m2A1+rcay53qq9NVcC11uXJs7vS7nbAO3DGQMRuwHOmzGTXoPqNA4YZZl78AH3sKKlKjrA7ekULs2bEVQIU+8FnVfCtIGunmlbnTJsClWHtb77EpNJAP4zttMiHXIIL4i5CD7N5sxP40HA2TU66RuCUAN9mLCwF66D9ilE6pOE8kv/tTvyCeHBtkuSd5oCMU+oEz5VRX3sYBKRu1421deO4bY6mcB2gyLqD/VEjLPHXLYwDVHyffe2CvYIetjCFTBiWTgxvkZT85LMjzZaZeOnAPEi4NKDtX/sDOjYbnrafX9eE4THq6A28tWlRIpDd5pTt9SAajlFe2OZwf5QvQ7NcVnGjfNDGKZ09OiSCxJtspGzObC6zZGmOZgpPttAIwfVNgO3R2wm9y/YYahMstGq7ZGCOdP254nxEB3iTuof/n8kX5H4D7s/NmGEV46Q6DnaoyRF7Vrgj+AyEI73b5tcdv0XGOOHoyx8OfCxgyekOwQA/x5Ua416Fkr3j3xNavA2wiWyPteiYTNFRjlIo3VyAZ3z8Hu9y75E3TFCJL80
 IgoMtySE
 vFoanM6VYjzREGFZXiT99BaRO2pG+CbNqnw+2basNFfguHzJrENUDQmzbBzIj0M05kdb/1z6whG/ihAASIFzqT0ukxzggdaNin+7tweIO+rW/6/ZYSGob+JS73Ikr/gj7dK3+9jLCdK4BZpZMEOe8Z92A6E2r1UPH4yVkqfb4wQ3jz7MNpWxAzeNEwXXtCYZYna/SzrFTnbznON/+21NnTaXm1o3tZDB3XMG3+/KhuddxdbBl2VTn2E8ZQnjmnPG9JSKki7fLsiOj9WDS3ONr9t02yvcxVGaLUvgNT/RIjPaqYi5MPIQyB2BXm9V5Hv2mJGMe0BQFzM+RFy2DVLiwctN/H/PAfFRS40GbcJeMHHHhGoNUp4RAzmOE2oP+Cy4a2L5ZWVWy06cT1bZlhSgOrLzgp1S9BzgZFEak
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--lgj4tlj4klqgw6oe
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 2/2] man/man2/mremap.2: describe previously
 undocumented shrink behaviour
References: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
 <c7ba8ba09b1c0b015134c54824788ef4aa47fd46.1754414738.git.lorenzo.stoakes@oracle.com>
 <iolucvrp6is43yjulbluchhw5wy6urq2gtwmcelg5atwuv63se@ovzuthfrup26>
 <0b0928a3-03b0-4a36-817b-b75c1f5c78f9@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <0b0928a3-03b0-4a36-817b-b75c1f5c78f9@lucifer.local>

On Mon, Aug 11, 2025 at 06:31:25AM +0100, Lorenzo Stoakes wrote:
> > Since this is documenting old behavior, could we have this patch before
> > the patch documenting new behavior?  Or do you prefer it in this order?
>=20
> I think it's fine in this order, it's more convenient for me as it'd be a=
 pain
> to re-order otherwise, and we've waited ~20 years (or longer?) to documen=
t this
> so a delay in ordering is probably fine :P
>=20
> Cheers, Lorenzo

Okay, that's fine.  Thanks!


Cheers,
Alex

--=20
<https://www.alejandro-colomar.es/>

--lgj4tlj4klqgw6oe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmiZte8ACgkQ64mZXMKQ
wqkvnw/+IdbsJsVOUcmRIygS4HeChREWaNfeJQO7+UgsDPRw4CHPhxXhQyBGepCG
fY6zcpBYX69RhF/1zNj9hDHSY7a4YlXQIVC4qs+AaAucT9IOzTH2hyykYU7O/gfu
ltdePdwvQ7qs7PSkKgmwbOYEUODi0WmZrTJT4Jt8OW9C2sPGZ01IWE+7DsZYITIv
awdWYSPkeSe0oeGAsQ33ZyP/kN/jRt+pHFbPE5dcbCxBkOFOCq8z5RcXtebrgq+T
HBYO4J+OMjwkGqNMTY5DIry731B19BwvmI03NbcMApuMuEx6kK8HtDRfO3000hs3
kRtR+glT+9RvfgzKcz/gadkFfVlhk/rMzFjQGCRD0FjSAlgbvIzPujM80Lgljk9Y
FGQ///2DeH+Mf2vk9+WweEj+ciTFCPeok2i6rnNofTjq+cbaijpEny+c4ra4mJeH
+AwxzrWdNjhxUZnr50B/WTT61bXBTVIHQuSnyHGbq/zSU8zuJiY2q7FFprgMnLq1
pMWdkf1/cladI86zQH3d5QeX8BQN0MazjTNSV+FRECLrJJOSeLn1a5ip5nY+nJs4
0U9WVtJhQ5MZcwNfPVEZp8aNqO2hTxS7OUYBjmiEWdLD+CKYmFJi8ygDy931sk7Y
PEFHGbRwkh3vnLgGk/mTFFuCGbxEbTfC2a1lN+7xbdEuiYb2iRI=
=0pEu
-----END PGP SIGNATURE-----

--lgj4tlj4klqgw6oe--

