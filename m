Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577A3C87FCB
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 14:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70AF6B0088; Sun,  3 Aug 2025 10:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A215C6B0089; Sun,  3 Aug 2025 10:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937696B008A; Sun,  3 Aug 2025 10:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 831166B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 10:17:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A96A1152E9
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 14:17:51 +0000 (UTC)
X-FDA: 83735649942.06.729E2BA
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6B03E2000C
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 14:17:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fb5TUiPK;
	spf=pass (imf13.hostedemail.com: domain of alx@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754230669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRQyGlyD9RPkwlfYS17IcD734EWgBqc9GzDYpGNQVBY=;
	b=2aWSHqHPBIy7NOT8Si0YDCwyFHJjfVmmp31uIHsHI4gl+EnozGUpE4kxk/n6wMxALhqbff
	MIvDsLFJi2bXGSOzIoC9DS2m744c7mvlS9H1FOvwr+lCK2pG6xmjsRLahFxsAQBAAT6VkQ
	uhqxy/um8l+zvhW89zU/33xtapPW1vQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754230669; a=rsa-sha256;
	cv=none;
	b=iRjapcdPw1b+xA4PwFGE2knQGrQFin68LKRaex9lxljXLYhf7KZ6hq8odg5641Rbc5hjVs
	/hLBMn+QLRg98Uvzw7INndqKn8W7rpoM3HCkZBU8PZhjbS2P+WX9Vb+QGpU7cjIZ7oPGeC
	2yOGooYs2EsDkvQIYES5z1STSk58YC8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fb5TUiPK;
	spf=pass (imf13.hostedemail.com: domain of alx@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 97E54A5113F;
	Sun,  3 Aug 2025 14:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9FFC4CEEB;
	Sun,  3 Aug 2025 14:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754230667;
	bh=FbgQNoGCHeLVLQVUAZFP0ow2FoSrn4GCKNnKX4Sc35M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fb5TUiPKw60N/I/aG9k0oAaYyL7H5YJFfH2eaAT9UlGnDYdh65i7TuFV69owRmjmE
	 moNVeK29xw0rhqtWVgUc6epzImQFlFh4c6zoLkxTuIT5UYZmy6r+523mJBnEBlh9hA
	 zEYz2d76fDIl3Q+RlG6FABiLFtT0GqUi/8l6bPoClEH2vceJ1Pf6BOv3TKkFpri7bI
	 V6LtmEzsWMv8iVRXX5m57lVB3fDTLvaQy4pxu0VibxE5R+oPDvq9NKdwidgpaXLBHh
	 igQJXY6+IyZQNuVDAi+yxEsNDMDxW3NK3ta3NFxuJPD4irr0S5VBYtS5MgzHrAylIC
	 mtGSLZZqUMEww==
Date: Sun, 3 Aug 2025 16:17:39 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3 1/2] man/man2/mremap.2: describe multiple mapping move
Message-ID: <dizfk5jqwwzozotvkk6phb36blcpsve3yw53xrdjwqeut27djt@rftbd7lkgsjp>
References: <cover.1753795807.git.lorenzo.stoakes@oracle.com>
 <1fd0223a6f903ffdd8ba644d0b67820b1921671f.1753795807.git.lorenzo.stoakes@oracle.com>
 <ngytuoex4uvu5epsdqhvhypnhqidkr7cpwmmcxrml6kpftgusb@jo5ql6eko2ir>
 <0e3d0dd8-994f-4665-969c-6daf332c5b94@lucifer.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7kp2dlmi2ws6pkwy"
Content-Disposition: inline
In-Reply-To: <0e3d0dd8-994f-4665-969c-6daf332c5b94@lucifer.local>
X-Rspamd-Queue-Id: 6B03E2000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: r5i49joi7rkzexrgw5gyqf8ynxf8ib8f
X-HE-Tag: 1754230669-106968
X-HE-Meta: U2FsdGVkX18cP07MS/4k0wFGoUSytPRsOoVRacIzYPJGkueRXLvUrhxKDongnibb4JC4hePbWfgXqC/5tE8kS2PhrQfgDA2KBxrkYIz8pGWGXFart+JimvjCU382pzoV9aZ7IT31X9ytWX2m9jTsaq6nGj79miOPhR2OP0AgvYv4rp2Isa+4dKJ2cWID7K/4mDlHj/LBtBzCGAFbfGxCgpIKTuV4rzLB20eZTuuNYKTBvtYYy2L5hnDy+o+LXf7x1bdV7ZJfOiSjZ2WS/HQ3zHbQSAqVV1yGmJrk4iZQxmGinWOXuWWMC8N6bPX0q4eNGoGoTI3zpAj9NBjAVUXx+biclRLdULnT5pgOZnoOVjMsfm8B7Kyy13Ul4s5Cf5mElDnX2YGfmW0LYRpUPhROYt/4/kgK/aMB5RzjzKuEzqmYjWbpgBoeTrH3qDjyqIfd21vvjBotNCrlS8Hh4U+ZOSkH0877NselybfFwYW2OANRocgOSrAYfTOxCAL9GI5e0ayljjaGeLbdAVQFVoQAp3q4Ew3IgEOPwSjAvNk90C35e0dLsg1RcGknYzHi4ZpkGNB5QUXZb2Hz7N7v6aC0YOPNQufI8H5xxTDbhxlqMqQTS/hxMQPwZNCfom49TgaIWm4wjWO2/hLFoDjpa1HsNaGDHaON54hMi8ssm7ME+F0e4JXNmLSlwRNgGZbHyWtW3hJ4qWiY4/JgxKev8QxhRoHVrO3oO5OlQwbdRsJ7mWLv6zOD989aX35RyQy196OiSWGEyZhDT7X6hjlYG4pIyCMKKncvFE3Z497T+7OZCoLLLbRVtjvYmNoeoujHFOMvWfgowz9HXLGZMbIgsX0aOQZNy6oc7rUapMmGanNEQvG459humqIeuTlSmte+yNQ957t3t3m5QsSkPSO3gF3dcbhkw7VsETTcpTSHRRvg9yJWOBtXP/inRC5a3OpUdmTeoPQAfhXM/snFa/XaP7g
 whXt0glV
 L9iid2icyX5N85lGJe/g3WCIxx3xHvT6bmqRki5gUKAgzsIIBxFYa9zlWbG7RoR5/AWs9BIb82KAikZ2/yW4ngSNqw4W7Ulfb0UW8atQ0ev4Fqpc2VRLtb5H1SRozE7XFJ6cciZn4edr8k47BgEd0ZB+TOLCzlHZuOxqzjy4g0rLagRoU/nqGfqz3GAfSMCjIqutkyZb/gvA52ZwJDRZOdhPmYY9PlahJPdYJGwTivy9d2Gj1fUaOPO7deBvm7DjWajbQmjrNgJ21TJ0aYn7ublpZfud7Wv8++4QpiHDI9u9KeDmsWr1E9AvuL5sRFZTF47cZGmDoodZvLv9Mz3Ln08q2LvDybK8Zk2w1IjX7X26A3YF5PwWep/n7jcO7+Sch0xIAksAE5+F+JyRbwkiaMiNtyGs2e1EvsHh5hboClWXlJ//IeFKH9vBPlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--7kp2dlmi2ws6pkwy
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
Subject: Re: [PATCH v3 1/2] man/man2/mremap.2: describe multiple mapping move
References: <cover.1753795807.git.lorenzo.stoakes@oracle.com>
 <1fd0223a6f903ffdd8ba644d0b67820b1921671f.1753795807.git.lorenzo.stoakes@oracle.com>
 <ngytuoex4uvu5epsdqhvhypnhqidkr7cpwmmcxrml6kpftgusb@jo5ql6eko2ir>
 <0e3d0dd8-994f-4665-969c-6daf332c5b94@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <0e3d0dd8-994f-4665-969c-6daf332c5b94@lucifer.local>

Hi Lorenzo,

On Sun, Aug 03, 2025 at 12:15:15PM +0100, Lorenzo Stoakes wrote:
> On Sun, Aug 03, 2025 at 08:47:28AM +0200, Alejandro Colomar wrote:
> > Would it be possible to write a small C program that uses this new
> > feature?
>=20
> I could do, but it's an unusual use of mremap() and we don't currently ha=
ve
> example C code for the _general_ usage so I wonder if it might be somewhat
> misleading to have example code only for this?

I didn't mean for the manual page.  It was more for helping review the
changes.  If it's very small, it would be useful to include it in the
commit message.  What do you think?


Have a lovely day!
Alex

>=20
> Cheers, Lorenzo

--=20
<https://www.alejandro-colomar.es/>

--7kp2dlmi2ws6pkwy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmiPb4IACgkQ64mZXMKQ
wqm7ehAAq+62D9otkxXDciEZdNgfKcKYwXmnmx/aanrSC+e1o02i9wrRYgzlFzkA
w22NDz2V7FPZhnZ3bGnuk5wrygmPWprtOJ0ux8p4qfKKScaGdPCmGcZbYDpoeUoQ
pt8GOYPu2jDF4yAnfJOWtw3aU9tTvtju5UsZAdHIwbdRGMcbuxX6cZvre7pLKHN+
kXijWJsuPKq6EbR/wiTRLJuNznpUpFAO7Stp8CkDrFOsM6KSDzgnPcL4MqXAieiQ
ymgGsspvEyi0SBmaUlo9qlabHiyMqOtcGKSBuc0s9NicXoUJ4Gsq5F7dmGX0rDJn
NihsZZ1PCFM+cWuoVIlXTNM6Ka2JEE5u8U4gapGVZs/QTpjuUNqBY8xnIchtErXf
Dlj8RqzXCY5iZBpT53WkUZFx+DTD/hI4uHBe2bxtvO1ojZbIkczXYnEyiTngWm1p
V8Tk27YGd+Wu3fPg/xtmpuO+rs3evYWDr34JBa9LnJjzWB0mkGDlfG4gb+HTdecV
jNm97xJH37d+1a/dq7uniOQLxUb6f/RzbnEHUh0MqLcpYr7amjzDOPZpRJzYDugT
mHpf2NAG2srrUhYnNVfOvbt2Hj4EurnfNABFm4sPosO4+6m6+GXj5HrmYb58BF9F
ZnEl50IluTkiAa4dv/n4zr5p7a/FqnsF12PB4SZhMME8OlG3WMc=
=Mknw
-----END PGP SIGNATURE-----

--7kp2dlmi2ws6pkwy--

