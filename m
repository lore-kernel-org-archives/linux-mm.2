Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A32C44501
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7962E6B0093; Wed, 15 Jul 2026 22:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747366B0095; Wed, 15 Jul 2026 22:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C706B0096; Wed, 15 Jul 2026 22:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 404EE6B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:16:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE6F3A04F4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:16:10 +0000 (UTC)
X-FDA: 84993024900.22.FD9EBF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5B0B0A000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:16:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APzQsnpc;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784168169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+HFJyTCa3EVVXEcNuT1tILVYIilN6OkBTWg8sgH++M=;
	b=gcXS9IhXbDOZteJiAsMB9KQYd/MHgdFd63qbMUYNfvXZ5mtIprKzF2WGmysdzTR9UoJRYu
	Fhvr16OfaFTx2cWfDdfEy5IL9xHv30Zv4vtx+gUOwDd5xFXol/G8QIrrVsQEF5uU0SNV4h
	rMOryY0mFkpeaPZ/yyW7NrWYwSKEgP0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APzQsnpc;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784168169;
	b=YeI8FXw+d0c2ZAmLRrCppIkm5SMg4YNhuCsjAPRXNlO5nvLH0A7zswFg1vF2cUruKF1+ls
	18k2Drg2fKz36Zxx2y3twZN3jKYQSEd8Am9d4tIV5jM9Xr6BL7xZ3juJS8vaD2cck9jEWt
	22Rm1co0fhYdc0gRhRO2ZDWPLJAndOU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA96060054;
	Thu, 16 Jul 2026 02:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B85E1F000E9;
	Thu, 16 Jul 2026 02:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784168168;
	bh=B+HFJyTCa3EVVXEcNuT1tILVYIilN6OkBTWg8sgH++M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=APzQsnpc/h0TBf+axgiDQYvBy+wydioxquGex71GmFHrrUzUss9Jqe4R0nBNBFD57
	 IkCliixQ1AD0aHHxSi+oA8DYzXAoN8ZWonS0MKSDG5to2hI71SIAAv4rx85z8QO7fI
	 s4cbWijxgYqZJf0Z/cCzL0d3sHt8Ym/7IJNKBh/5uvcxtSGfX+2tT5UUfwpkyyDcia
	 DlQ6/CV9FPocX5l9sQieAvWX3wYAv7zy8g+gxoiu/uHrH/HaO+bjT1wdXClhMgjP76
	 pk9W36b3NDKzT4dqiFZrWCMKAEQAlcTrNv/vQfu2o9FSSG234j+mquLdOvVz0/YO0a
	 3JnOmwcx4/Gpw==
Message-ID: <aad6935c-b0b2-4442-8f1c-706aa4a77966@kernel.org>
Date: Thu, 16 Jul 2026 11:16:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/page_alloc: don't spin_trylock() when disallowed
 in free_one_page()
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 sashiko-bot@kernel.org
References: <20260715-alloc-nolock-fixes-v1-0-fadc49952dda@google.com>
 <20260715-alloc-nolock-fixes-v1-2-fadc49952dda@google.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260715-alloc-nolock-fixes-v1-2-fadc49952dda@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wz9HOl6nPDiKXr07fOYppyiX"
X-Stat-Signature: pdhubarm3impckonoiu5eyci1u4yadeh
X-Rspamd-Queue-Id: 5B0B0A000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784168169-257865
X-HE-Meta: U2FsdGVkX18e9wuN40T5XnLFPb2XFlyIW9i7rrvIraXa6ZjcIWPgqscuhJoi/4Wjdi6tdztn0MgD9tivh890EIj/SN/G5DGq7NrEq/CS/BErvc5SgCVKvgnTNrQEC95p+GX9aTiAwoFl98XElLYf3toZgNjG6h7e6o6T9+D/Vw8vk73ReFM9pLDopmH9JnxtH5kkcAZ0VRTsDfwFrYyqjIytHsXmiRnUVwrUIyT8yL67zKIo3Dh8Hy5S3gJjEfBCSHXBI1ywXjlxsOPt6NWZfO3SlGNEx1q2btxtmVnS62PIKOWRGW59Y21RRR/o6BzgIcqQ3EFNLeKnmI3OrgcUI3RSPkX49lcBJ/fu28XZDAE5aALrX8xV/cGW3Ka3EdRsggp52nveowXB85GhDkkitCo8xSYXJbDotZarsJm9RQG8Z/VK+G25zqulZgTlgA3X7/FxBAzDVfIJDO+0mQ0ON/k1vrRBbKDsCttLZjMI8fW7PSOrFTY/jemuGCDQK9YCBnUO0YMraKrTs2VNNKyAP+xz7NcJKaC0AKhPpBiNhCHJpWMzd3WVCBn3bmEcO+sqwupR0Z3Vnc1GlHEjz7lbWtruZeaJ5SdPAvf/Xj0T/w8w/BPpA9M4cobDEkyhwstdObNkluV7uSZ5g9SKe58Gi3T1NgCzchTK0ttSOcbVxw6QeCTuiaUZk9cpWfLtsmbdwWoWE15cA12wWq4H0G+GGvqe1JhvykqYPywDf3cktNgYAJr0WuEP9cGvQVN8Xi0jKP+ZVl1BKnb5mFOu/AuIR/uKGYsJ+Tl84QJdq/XtHTbGqVq46PWMa1Ekj5MRffeZEsf9Df/Ew5Jz7ZnTYSbFQLtujNaYNB3sq1PUydIp2BxMvo1HEZvQnSrf6GQd2d9Qr6Ybf2smJUFWp1bEG2jEpq0e0HfJJRLI5b0RAX/L/f5jVN/TjH5IvKbDDTGCqVXzs+dMEPXXUGNS9LlZTh5
 uK3SyPZk
 +mMdNnwKmCoVdOgxkZJ14B5+ze1vZKlNltp0HJ8uK8UaNFiDAVZX3PJnNi0PFHJVWF/SKG7wws0qxk4MPGJ4a0B2AGgq9dhXRWKWM2tTiBhz40GoiDEuLONeCTDWmLniI+9gV7yMUivAo73wKGVEqqnvXPp7/Kig+fO12MjU1D4LBStpP6yPOStZhK0LWM5l0oSEp3onl0ONUJ/E3rCoS/Hwcqy90nktX+T3Mg/G31fHanfdwn0GaIvJzdfeVeNS97saSTZd1VP8nfJ5YaphdskH7B4pbDCGYvn6HLyzZOECB7HS3ix0LbxzUzBSgrf35NzFLo2pLPL8EDpuMMJEebSgB1l3fGOQk6VtLz37MCwsq7muAb/bXssdapFcS4H86i2z3xhWsaHAp+D97oaQC8SHnFPL4IhC0amx4Uid5FBbrInaCDYmTgFBkPaDI5lghcEpv6u3PYaVzCMAG60FSzAD5M+6IO4lejFJTWb6XXvpxEBv/ux/VGgOQ23LXHyQvOe7VFuTVVIYvtIvY8pmXtqq2lVEtETBSaQtUIue1jK6HqTAYMo85Hkck8D5SBSWnWg6vzEYMOZ17kWbwZEIC5Zu1Ke+uaMhg8Sz/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wz9HOl6nPDiKXr07fOYppyiX
Content-Type: multipart/mixed; boundary="------------dH64BqDFOVjTDMP3JqgnEybF";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 sashiko-bot@kernel.org
Message-ID: <aad6935c-b0b2-4442-8f1c-706aa4a77966@kernel.org>
Subject: Re: [PATCH 2/2] mm/page_alloc: don't spin_trylock() when disallowed
 in free_one_page()
References: <20260715-alloc-nolock-fixes-v1-0-fadc49952dda@google.com>
 <20260715-alloc-nolock-fixes-v1-2-fadc49952dda@google.com>
In-Reply-To: <20260715-alloc-nolock-fixes-v1-2-fadc49952dda@google.com>

--------------dH64BqDFOVjTDMP3JqgnEybF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/15/26 6:03 PM, Brendan Jackman wrote:
> __free_frozen_pages() checks can_spin_trylock() before entering into th=
e
> main free_frozen_page_commit()/free_one_page() path, but before this it=

> can get to free_one_page() via the !pcp_allowed_order() and
> MIGRATE_ISOLATE paths.
>=20
> The !pcp_allowed_order() path depends on usage by callers so might not
> be possible in practice. The MIGRATE_ISOLATE path probably means kernel=

> crashes and privilege escalation if anyone ever did memory hotplug and
> BPF tracing on a PREEMPT_RT or !SMP build.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")
> Reported-by: sashiko-bot@kernel.org
> Link: https://sashiko.dev/#/patchset/20260710-spin-trylock-followup-v1-=
0-affb5fe5ed00%40google.com?part=3D2
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

Looks good to me, so:
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------dH64BqDFOVjTDMP3JqgnEybF--

--------------wz9HOl6nPDiKXr07fOYppyiX
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalg+4gAKCRCGXBN6rc5S
1hTBAPsGl6Hne7o/jv65k9wae2cQ0p9eX3JNE4A50yekAYolMQEAgBTot7X6zAo6
KUsEjPVelda4zLtByH+fmyjeXZxYdgI=
=vued
-----END PGP SIGNATURE-----

--------------wz9HOl6nPDiKXr07fOYppyiX--

