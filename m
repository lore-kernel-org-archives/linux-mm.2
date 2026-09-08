Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B164C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA996B009E; Tue,  8 Sep 2026 05:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892B16B009F; Tue,  8 Sep 2026 05:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8266B00A0; Tue,  8 Sep 2026 05:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE726B009E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:06:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B814D160469
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:06:06 +0000 (UTC)
X-FDA: 85190013132.07.2BC63F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 248C512000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:06:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JYrWkFPC;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858365;
	b=uxsQ8wAP9ZvpycumD6G6iZmetjuXZTwGnchIkSDbdUsVzJ3WH9OUCe9RTZm1bhuUG50O9e
	j/9HJFl+VqTs3hTosUODSYEvpI8IU0XlL7UFC2oizcup0LMm1fdn2n1ew88i6ojQAnuzJ9
	8NGR5B6DNLqac2ajNp4I0xLWKZV47sg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JYrWkFPC;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AX+7FxB8zQI4HWmkMOozVd16GP4ljWtJaR2TsbzyprU=;
	b=JvyJDwgyyv+rXQPw6ysT43L3NECxQZF4YhMyiHSSedXxwhvy8HpCNCHjd8sDnr4PjdfAsT
	pkzZiMi5FBL7ZjmqxjqIAN/fnkWZR0OOHCXqI2nJEuQQH1LQddBHxDImHW7PwIez/pzeTp
	cw42WiPYDHOjIVa11ef+xyULea/qE7I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E19E260A93;
	Tue,  8 Sep 2026 09:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AC41F00A3A;
	Tue,  8 Sep 2026 09:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858363;
	bh=AX+7FxB8zQI4HWmkMOozVd16GP4ljWtJaR2TsbzyprU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JYrWkFPCdWEPSJH4cIfkWL2PGgf2NCTn1HI3WLNDkla5VfmVA0JpBbh/4qpIUp0Yp
	 IoY+25twEkLH7elroyqUuVV6DcdnHrpszENRNnxwyt2GKnMgm/4Q03ASscrcZg40b3
	 Ubk4eFhBkGpjWX3xCKCZhlLiVqF3tv5u8mhpAGomSttsDDk8yWmsVONvfu8TAju6RV
	 6WPuJUjmZwzSTEeojQF2YPHYWtx5i6zNiQG2RCmElIQQqewGZwhxSmxLRlSmFgP8Gr
	 UmR5TzSeslYUV56Lerkf4IkwebNxuHeHzkWIjBrEEir8STlG9excW/k9Gpn57F+T0J
	 9UB3P/4TmP32Q==
Date: Tue, 8 Sep 2026 11:06:00 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Sowjanya Komatineni <skomatineni@nvidia.com>, Luca Ceresoli <luca.ceresoli@bootlin.com>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Russell King <linux@armlinux.org.uk>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>, 
	Saravana Kannan <saravanak@kernel.org>, Thierry Reding <thierry.reding@gmail.com>, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>, vdonnefort@google.com
Subject: Re: [PATCH v6 00/12] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <ap_MnVK8NYvEtYHS@orome>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <apquUWgrD9C2jWQ0@willie-the-truck>
 <ap_HzwVp-6aOKEbJ@orome>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="i6qijyjefsd32euh"
Content-Disposition: inline
In-Reply-To: <ap_HzwVp-6aOKEbJ@orome>
X-Rspam-User: 
X-Stat-Signature: ukb79e5axw8ryscap9wdq7amwdcsqxhq
X-Rspamd-Queue-Id: 248C512000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788858364-785082
X-HE-Meta: U2FsdGVkX1/4g65sM+83J+gvNAGJl+Ka3lFi5l5C0nVrg1s0uWSsFj2Ty17WUSWEpAVzJF41dVYCWK/kmxrS/Eqh4fA/3fYhforhRt4vjTFbkTi5UtS4+KtUf3styqwr/S3A8xbIXyIh/DN4YO8vm3jNexYG60W/hpZgcjQtN/5+MKNacwssLrB5ACH8xx+Q0FnAYOHLB9uB8FwXfWx5dKNsLrH2nwCYcwHq7WOP8WwsEbEFVkJx9kjwoUijydelMx/vZSKLipJhql5er2tQQnzQW8XYpW1/v00z4yC3CnbUxp4VcS1TGaAP9ylO7nXIbbX4SsBDVOLVLnFGd6EOqOkKTOK903BWvHN4wiY51GXcASUc6nrNB75R3H1zDFNmJFuWWjfXvReSDsItcO+onsSt8Yn+Ax5aAW7N7H12a8ziXq3evD0i7CS0n8HonZu/ZLfSv+RnAEtrAihvR6BRdLs0AV9FUQ3Jt1Yib6MXkennz5vrhPqBkfRonu8E1YTfwn3YW2vuln72cl+g2VFkuntdA+iMNCGmUPUs5Aj/0GPnJQzZ3+7ToUirnXHfzxKaqG+/TIsXb/J2YaRZpI/Mt/crKt3g+s/x5tZDwW+k0m/FzH7xDCxz+opFVHe5c0ooMlHvzIkyKJztkFpktPTIV61yQI7meyL30Uc3nxMewvasdcSIV4GT0hsSjzj62wvqWoRlM8iBPxbu0GlWb/p1zm5uRpwrcazIIrdZ/s4T5aZa9zar5whgUJAlhypPz599jVkiJuC/4ul592E9BFo2fBBweT2iL+/x3JAsviIuBlFhZSDX9A8fj1UMvh2jmLIdrPwA2IqGNlLA8KUe62FPnTBY76DnNfXogGd6/eu9/+9IJHTNB/CumPjqJfWNFLIV/caSdb+MYPOO9PRb2m8k4wTZzmWei/jA2S9hFzRpkG9p7uWg7H0g4LNNk4wplnUw+BrKPIbj7WsKDD5T6CM
 buMAlXZp
 GrPi+UMQp5fmIgArr6EHITQKPA/SC8q7tTfrC7s/Vevwl6+AQKTcaz5kZtZ5ZFLIxrh6+pEljp/3Hq3x20mTUP70LeI1ouu91U5iXEcs/nkxyc/u3sbFb+3pvCtP7fpEk9y/4VS+EF2H40TC8RWw78lD4dXSr8lBDd+agXnSWtOHHtdraUit41++vkV/Bitf6zkEeOeNw98jaW5bxNRtAApPZM8ve/jDbwBWldKvnyLfP+NNr8YwzpRoyAybx1RgJy71VPG6Zf5Ng95EMfra6J49VkIW5p2L11SKj86xwzXnIHVJBM7C8fl3qveep0XRoTULtFUofSf/xpjiaAwL/yhCfu4nXp+atSWIbY1NppaIr9fMzBsrbJ4f5h4zVX0+6vCrnNp3pjpTKFAAz8x3ja2cGfwTesbYhuG8vi2BSnf7F7qKpHPRtYKt6sG1Vw3WIS05Zlq9fX9o6B4dhHt9Sfig7BqgvWwZuhHCUlg2d5UIBx7tj+UyOcn2HZv0c6yXeq9JO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--i6qijyjefsd32euh
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v6 00/12] dma-buf: heaps: Add support for Tegra VPR
MIME-Version: 1.0

On Tue, Sep 08, 2026 at 10:39:17AM +0200, Thierry Reding wrote:
> On Fri, Sep 04, 2026 at 12:41:05PM +0100, Will Deacon wrote:
> > Hi Thierry,
> >=20
> > On Fri, Sep 04, 2026 at 12:44:51PM +0200, Thierry Reding wrote:
> > > This series adds support for the video protection region (VPR) used on
> > > Tegra SoC devices. It's a special region of memory that is protected
> > > from accesses by the CPU and used to store DRM protected content (both
> > > decrypted stream data as well as decoded video frames).
> > >=20
> > > Patches 1 through 3 add DT binding documentation for the VPR and add =
the
> > > VPR to the list of memory-region items for display, host1x and NVDEC.
> > >=20
> > > The set_direct_map_*_noflush() functions that will be used later in t=
his
> > > series are exported in patch 4 so that the drivers that use them can =
be
> > > built as a module.
> > >=20
> > > Patch 5 adds bitmap_allocate(), which is like bitmap_allocate_region()
> > > but works on sizes that are not a power of two.
> > >=20
> > > The of_node_to_nid() function is exported in patch 6 because it is us=
ed
> > > in a later patch adding a driver that can be built as a module.
> > >=20
> > > Patch 7 introduces new APIs needed by the Tegra VPR implementation th=
at
> > > allow memory to be allocated at a fixed offset within a CMA area. Teg=
ra
> > > VPR needs this in order to implement its own allocator on top of CMA =
to
> > > meet the strict hardware requirements. This replaces the dynamic CMA
> > > area creation patch from earlier versions.
> >=20
> > Did you get a chance to see how this could work with Vincent's series:
> >=20
> > https://lore.kernel.org/r/20260902104712.2399797-1-vdonnefort@google.com
> >=20
> > ? I think that should remove your reliance on can_set_direct_map() and
> > mean that you can retain block mappings for most of the linear mapping.
>=20
> I'm not sure if it would help all that much. Yes, if we mark the VPR
> region as LLMAP (or PTE_MAP, whichever it ends up being), it should make
> the checks for can_set_direct_map() redundant. However, from what I can
> tell, Vincent's series still forces page-granularity on these regions,
> so it won't retain block mappings at all for them.
>=20
> The block mappings can be retained for the non-VPR memory, so that's
> nice. It also reduces the amount of external prerequisites, but I had
> kind of hoped that we could go one step further and keep block mappings
> even for the VPR memory if the region happened to be a multiple of the
> block size.
>=20
> The recent addition of page count to the set_direct_map_*() functions
> helps reduce the amount of checks that need to be run, so maybe there's
> not too much to be gained from removing whole block mappings at once
> from the linear map.

I don't think everyone received Sashiko's review, so let me discuss this
here. Sashiko rightly pointed out that set_direct_map_invalid_noflush()
and set_direct_map_default_noflush() return 0 when can_set_direct_map()
fails and that code will then simply continue to work as if the pages
had been removed (or added back) even though they weren't.

    arch/arm64/mm/pageattr.c:set_direct_map_invalid_noflush() {
            ...
            if (!can_set_direct_map())
                    return 0;
            ...
    }

Looking into this a bit, it looks like this is maybe a remnant from the
early days when the check was simpler ("if (!rodata_full)", though I'm
not sure the 0 return value made sense even then), but it seems wrong
indeed for this to result in success when clearly the operation was
skipped.

None of the other architectures seem to have similar checks, except for
clear cases of no-ops (like the address being outside the linear
mapping, the number of pages being 0 or there not being any actual
changes). All of the three callers seem to be prepared to deal with
failure, so I think we should just make these fail instead of returning
0.

Any thought?

Thierry

--i6qijyjefsd32euh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqfz/UACgkQ3SOs138+
s6HbmA//a7qNERZAQ3yRWiydhrePbED3kRKv0HSv9N2gumrzKUdZsgRPZt9zq+tY
jlGfE+pLkVxKn9OrAHS+c8ueItFNHkjdZbkMB9lYG0Wpclm5gpU11iBiiZtrzOHz
WiEzKPtBJh4akwTJo0BLTQDqnf052vCmT1HW7/m51TmDBsYy531XuMqcF4V1cViJ
L1KdyPc66KlBivmtcC0Kh0lVSbmsyS+SWJcxOvg+kwY8t02f68EHrUV9UTRgCmr8
T5YO/ibccZVaey6WNDCqbdaQyUhHRzJNKuIrMGob5e49tDWOd4wB8Pa8CPMMgpUK
3QPmfzDWrjHUimwGKdzu8R5LAk+zzEaxQMAlcaf3iEejg7WVY0DvDFA5m0Rbee8O
BsryJINxaGuetAUqaF00N5UnCu5LreyjIiOFejWHY6BQM9oMlN0aBNnBMaozYOqF
gvn9ioMnbVs4hhjggmGf7MOoKA87DU8Sb8JoZuZDTO51DrCB2P8gThFJHPkj7lgB
hXjnzHdct/pO4qeaj6Y4FC63HBI58QoNMpmJGr7mZWeb5wWZQgj1Oobal1TbUZy1
2G7m21x2Zegi9MmRwyS0XfXdGChMdxCttK0/XFo74Md1rKurzUjH8W3N2HdXTRrD
DPvDE6pSnJSWnFNeDPebiamX72hoF000TpCe857/MUEH5n7Aamk=
=GOLb
-----END PGP SIGNATURE-----

--i6qijyjefsd32euh--

