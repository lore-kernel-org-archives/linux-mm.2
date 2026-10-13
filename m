Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD8BCC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0116B0088; Tue, 13 Oct 2026 11:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A80F6B008A; Tue, 13 Oct 2026 11:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5B56B008C; Tue, 13 Oct 2026 11:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E63FF6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:03:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 665B21A0D22
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:03:17 +0000 (UTC)
X-FDA: 85317921234.09.9D31892
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf11.hostedemail.com (Postfix) with ESMTP id 95D8740005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:03:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=PP6KBkiG;
	spf=pass (imf11.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791903795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pi9LSYarjLX+3vvzjZhtTrpY5MChzmnUBJGMA66TyCA=;
	b=HvBAZn3L0jafx6k2ag3HnwCKmpS6rbA1vibJMO92/Wo7aTK2Rb1DSJlNi6o9ZkLPQsBjLp
	rutI3DVLXlGvtUPf/Kgf7FDmHUMfRB7Rhgc/+lv9s9m16TV8ANz7UVCN/o9TG3MOhD7lRs
	q22poiFzMcdiCKFYtfuzhyQBvte4L1g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791903795;
	b=mI4u7cL1e3auVLXt/YMYOiircZ5J2RrY5T6a4gqdtiwaDmyqmI7u896+oauiGZXcDpHAwK
	QpnpvFOSmBCzU5N1VyBL5slN1btW0viSvGS+N6OlAki0JuFFfMVJjWeinydigbnMM+9ctQ
	JIEBMB2MKWPs3wDZG/9oMo7CoXrOKrU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=PP6KBkiG;
	spf=pass (imf11.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
Message-ID: <662b749c05634b6990d072cb87a442687b41be33.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1791903793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pi9LSYarjLX+3vvzjZhtTrpY5MChzmnUBJGMA66TyCA=;
	b=PP6KBkiGllBsDBfJ+qINnKOAPEz9uCFYbkchSzqWQ1pm7bapeEDpUXBktj2ihx3XYoXRo/
	H6+F/uKmotuqTl8IebEPWJ8JpZNpQPSUILLcfX3Q7Qa39rg67bjFFkSosaPB1VqJQvSHp7
	t5cVmwJV01QNkHIqswer6KpwLlfqLAU=
Subject: Re: [PATCH] fs/proc/task_mmu: fix lost maps entries above 2^63
From: Stian Halseth <stian@itx.no>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	 <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes
 <ljs@kernel.org>,  Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Andreas Larsson
 <andreas@gaisler.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Tue, 13 Oct 2026 17:03:12 +0200
In-Reply-To: <e300f046-dcae-4539-bf89-92eb8c575e25@kernel.org>
References: <20261011162019.922436-1-stian@itx.no>
	 <e300f046-dcae-4539-bf89-92eb8c575e25@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uXyPDiAoKUAB3fHHAbUw"
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 95D8740005
X-Rspam-User: 
X-Stat-Signature: xac6us1pso4y1mjpug3jgi5tsrxg3psm
X-HE-Tag: 1791903795-254847
X-HE-Meta: U2FsdGVkX1+wY9gDEWO7fX0YO7BHAFzkdwM9z95U0Mwy45/M9OnYJvyrArzjNn7oh7Ge8T8zZAZw6xU3wxHy7kKVL0X6/0kP3svnCaKp931OrzA99Qbitgp1h9ZqYiK9GMz0fZDFhaHDq6SQMm4gOdCAApKAW04Tvd0UIOobOjuCa8nvNwx/KhFMyRIUmcW5LwcDx8KHNPVUjCSONdfUWYO6mC1yoVdxFppBMRgv2TS6/EFGilnUaXHOTJa9WsCVJeob4FxNYFYYmI+BGdL6mfUzmHX30HYRrr7BtjXimlVtZqbcG3a1ny1imbUEVAM+glP4A4/DNBHyrN8AOAYQtBSxA6ZJefQF/rM8nlileeVCalrlCf9wb6DRGCVAv3xf2Gp463DJJ1CthkDI6RabkMR+V1o/z112khEl31VYMeOAl6oRouUPuBGKcSXUW4kXGJDlDoyvvcHPc+zen1leY2Z3JQZqtnfDYK7BV18Zm7ehehR1AQHPjZHd4ZmZ0KOFahI4ZeqKgluj62tjd8jsl9YNCBxo5D6WL7CJJtwMgMyXWcSBHCq9OTW4jU7uul/r4we/OCjqlD9Drp9xQx0mBjEUGt1f2vt0DgsYVYlG6CvnP100STEQqjLyT7od/5NDszqWd/vFeCsJ+Po4D/46voSi9NzPwG+W71pUZj9avCuYq8tCjuzJl+aQZyB7JGePMcQQfLXYCOnTk8D4xn4taZyvKm5av/vEmW8Ubro89AAtXUw/3fv0oOt/eEWwWe6wuRmt5yMXG8LjqogIbKshY8HzrXS6ySfwF1xwaCWk33D64jmH0D0gObWP6sq1Vc4TmkYSvcug0ihq49US82e2bklu7/IXjHsJKPzx2Ub1RVLRmhzS1/HGSXH54sJ9Hg/0FaaWxwVSbXOr2Ir92mFRz7Mpcevx11qfUTUQe+EjlcDXPlRISCqS8bIFlH1p7kOtxzVVRtIkMMvAuCouxp6
 T0YHyM3B
 BOZS45DXlg1g0zENjONZJizSE/6fe46H7oJ0bJy1xilJ8Xc68UZpXumbhFT/AI2WNZlY2agH91Xs8oXH6eRGBvntgxwJDDrUTPFb9qZU85LjLrxppuY5feYGQaABgxLaVlsl623HhuWkAGpbeH7aV7E3J+9gEJo5oG6ggRTGNNv4k1vniKfFXKSAjeFpVOXwFDUveUzyuOQteokEi1WQ2vluITlSmsSrmT5+AOMzeBY3Kj1DBPrzYOgCddOjkx+N9iRwHZQjg4JZdNEeU+UGEg/afO3G4+kKlkbv6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-uXyPDiAoKUAB3fHHAbUw
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-10-13 at 16:40 +0200, David Hildenbrand (Arm) wrote:
>=20
> Would it be cleaner to reject any special values, that is,
> SENTINEL_VMA_END and
> SENTINEL_VMA_GATE?
>=20
> That would match the comment and the previous code idea: exclude only
> 0 and
> sentinels.
>=20
> Could consider a simple addr_is_sentinel() helper.
>=20
Agreed, that reads better. SENTINEL_VMA_END never gets this far, since
m_start() returns early for it, so it is no functional change.=A0

I'll send a v2 now, and maybe Suren can have a look directly at that
version.

Thanks,
Stian


--=-uXyPDiAoKUAB3fHHAbUw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCas5IMAAKCRDoeAEuJe36
VsL8AP9E+0k4mprykfqrvUdh7fvR+jw8P0kF49qCLBaCfiRY3AEA33afxSogFsKp
woQkB2y6j4zmffrBo1NCiMSYSU3b3QQ=
=sVmV
-----END PGP SIGNATURE-----

--=-uXyPDiAoKUAB3fHHAbUw--

