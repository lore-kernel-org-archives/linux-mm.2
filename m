Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1297606A8AE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O/G0E/GO
Received: by kanga.kvack.org (Postfix)
	id 16DE56B05CE; Thu, 12 Nov 2026 03:42:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11EB76B05CF; Thu, 12 Nov 2026 03:42:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035266B05D1; Thu, 12 Nov 2026 03:42:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D18886B05CE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:42:19 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6857F160478
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:42:19 +0000 (UTC)
X-FDA: 85425825198.18.386C478
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id CDDABC0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:42:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/G0E/GO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794472937;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ial8iAsSa5eOrYsCj4SMZLA9EuKpEQEbZW4C+PxDTJA=;
	b=ycbssD4yBbAJr3XPptxMifhTpYZQk1oKDKML9dEEpwSfuwBfnvow3iU5MivrmRyue/t3b6
	Une+XTQ4gIZQU1CUC03Q0uszwtPuAI+tWgyRQgPBdeUSPPEHTtW7pcw2oBvu0is2vg+2uS
	8aRY4sYAdfLsY2u/Iqf9vmpf8s63/nw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/G0E/GO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794472937;
	b=1epOQ4lUor3fTCnPvHcijKr5RngeEDAqfRQHa+4LqqYZx72h5rktARPdvZGclyI+akPNRs
	pW2EarmM8mJHnyEjGYrp9qNrVzT5p7tuFUb7nCTNArUBKWtLlR1FqkUGQ21fGv+p5zULqQ
	7e8IS177TW7OvJzIe5yTDR8EcZuItTc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A8F641450;
	Thu, 12 Nov 2026 08:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7D31F00A05;
	Thu, 12 Nov 2026 08:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472937;
	bh=ial8iAsSa5eOrYsCj4SMZLA9EuKpEQEbZW4C+PxDTJA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O/G0E/GOhzhWvj3+aPjuf/R81zEodFSmOd/3hcJXfsGxzBO9PPKa9mlTwPJcax3iB
	 OdVCU1tSe9ntSNCMaNVqhAKbp00jbrwhPiLDlraF8pCZsdU08OTlvBi2e/a1g26EZb
	 959/ReDHNObr+I8FCl+MWYtz9BJ+FZIllaNxscVo9Z/V3p8sLQx+aaN9ITpw347yhS
	 qPSC7uFh8akjso25gvhq3e10LYYf3z4Vlcq2hPhORVs68vxkSyaGUhwfD+kbHW2fSO
	 rFnl+8q2KMWAH5ZzLblj2XKbL3h7faSTarrZrWPG1dLixZjTGLEgdnnvgpAVgTMt0u
	 Xn0VDYHJDiHBw==
Message-ID: <sashiko-outbox-210762@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/compaction: Mark concurrent compact_considered
 accesses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Jun" <zhujun2@cmss.chinamobile.com>, akpm@linux-foundation.org
Cc: vbabka@kernel.org, hannes@cmpxchg.org, ziy@nvidia.com, rostedt@goodmis.org, mhiramat@kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, syzbot+212c2d1f47994035cf7f@syzkaller.appspotmail.com
In-Reply-To: <20261111084205.80997-1-zhujun2@cmss.chinamobile.com>
References: <20261111084205.80997-1-zhujun2@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 08:42:16 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CDDABC0006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bih6333qoaoq87h14ogjbcq9e3caq7b7
X-HE-Tag: 1794472937-790951
X-HE-Meta: U2FsdGVkX1/gbla9Tw57FjRsQLIz5EBk0fIgEm0chkrUht00AT9dzRdUqdqgbTTY1GsCFfAHk0+O9TUOrpOQZtZMdv3MGrSv2oRg9u48FjjMMrO2V4RtOlNw9jwV90+2GsvJD4yJBCq2z3c/9LNMEnkxSwxeagjMucFPBfNcf6UEn0Lpu5TPAE+NbwO7XXjepiKcL/BMyDPA01/hmdSMevSyEsXBo/cW5WN5W/u5ypPNjUzXNMXPvIlLCmSz0kJsvDTW9aAeqEXHoIdcHE6AzX/UwC+rgYaZfpM8kbOflKU8VnyuZ2b6Y9BfnEm/0K1G826YZ/pVAKvgXzVQIZZamX9P9xXpksBHkLUkCvmSnS1mqm5QTsEILOAgld6pHjf4IpasHXbhUIY9qfV5dhDMO+YhazgfmmjTa0rznOQCccMChUid1haIT4dRt/ux8+cPnsL0Ld+YJWrkV79mm1tFNCOHvCNMKr8It2Tw+3HZZfgX+337DuK0At4C0FmNYO7FeQquAYd/ILN1X/BNLUl6OE6DaykILmsFHIYx+JAmmyhJuefbdPU4xARGECWpYxh2HHVLu//RI/dDn+GW+7kVwkWR+CiS8d0NqUVzh1oKtE4WjWv1PEiHdfdNmuB+Ay0mdbL/DsdC2IuGYEoDcy5d0CVX+bZQZGUyIvNtWR4ybZX8jWANc9rSQUM8lPA9Qm1a9ZNdQo3KamsQpdHY2cNRpu2MXpT+xsIDWnzcej1At0z14RNpvIBjzKh5QlVJtCJO2ciWIrhsPim6msFqlrHq1JiVJz82ocQOwBO69MkbwH15yqcwe4YMs61wRCtu+cKLpOKOojKri/oUKNDy0QiPBzQp/2jWACRSLD0CQV2zatio+y82z1C9GMCNaZbA5j2r5j/EXagpZ4JDNqOmu2bg8ayD5JyBhZp0FX1HIzH2X14njIjbiBGhI3oGlOvF/TMhfvF0ALo0ZsbCkvmRDe2
 oJXwlxbx
 HbZLzSXFKpsEm/Q/k7jQE7jx9CUwvu0IDXvlftPLix68m8XYwZDwVnNPbmTjdL5sGNu1EN8rRSpq0POoFiyOEeVBsnYuqVNUAZRq7+Rn4CfrRL/3NIZPF5Zq1Av9otORmip2s31EWPrSK7GfFrB6MArI0bF332ntgdp6s5YPV2PEVoVFmNLaHE1Sfgo8rOo16QdXh7agu1HTXF9UsiPtJEsu+nKvxg1LBFlQtgtnf2XFQt+QzEcraQH6jHy8BUlicVpmGmxcmjsONylLDrRGb3pBabcql9E+Y0JTgXBvnq0UtBA5GLHyFiR+KjsFmehcFp04gNQL4qc1vl8wn90AuKZwdG5rF7X8JFYYKBJm+uw+akEclXd/45JwisAFLZpmwMVALNE8w7cuZST4WGsHGRC4D7XtUZTIb5jkTcGDQWiXP6iVjdQ+Q16S6+h7as5QptfnA4VtoTFQ6IFAwftY2zCW4vEpr5xVfxZ66k+Np/ONW3oiQkO2OcPitCpFw9KK/FA0aLTEIhagAtqw/dsE7nBgjJSoynxDvVc9HRSpYCr9hrRUZLx39pOwe07pizWYNrxB9YavxzMnEXa1fEuuH1Kqop8dpJou7UaJcYtx5p3CKRm4YQipmvSdHu21c31L10lXmf8ccFZb1y5tJx+wy0G39SLNBtNovlh10xMbuekHJ+BIAqCa6GIyRIHsyBtzSEJea3pjSDUPxABq22bhHM4DTE6l8TjkSmu9KR98kOUSjMk6+yE787BmOSuzQx9ZIoaskrI6o2UKzhPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] mm: data race in compaction_deferred() [1]
--

commit 065fba640e4d4df80527a642f4adcbe5f31c8683
Author: Zhu Jun <zhujun2@cmss.chinamobile.com>

mm/compaction: Mark concurrent compact_considered accesses

This commit marks concurrent reads and writes to zone->compact_considered
with READ_ONCE() and WRITE_ONCE() to avoid KCSAN data race reports.

> diff --git a/mm/compaction.c b/mm/compaction.c
> index a049415512c67..2ac6af7c1ee59 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -126,7 +126,7 @@ static unsigned long release_free_list(struct list_he=
ad *freepages)
>   */
>  static void defer_compaction(struct zone *zone, int order)
>  {
> -	zone->compact_considered =3D 0;
> +	WRITE_ONCE(zone->compact_considered, 0);
>  	zone->compact_defer_shift++;
> =20
>  	if (order < zone->compact_order_failed)
> @@ -142,15 +142,16 @@ static void defer_compaction(struct zone *zone, int=
 order)
>  static bool compaction_deferred(struct zone *zone, int order)
>  {
>  	unsigned long defer_limit =3D 1UL << zone->compact_defer_shift;

[Severity: Medium]
This problem wasn't introduced by this patch, but should concurrent
accesses to zone->compact_defer_shift also be marked to avoid a data race
[1]?

Multiple CPUs performing page allocations under memory pressure call
defer_compaction(), compaction_deferred(), compaction_defer_reset(), and
compaction_restarting() concurrently without a common lock, reading and
updating zone->compact_defer_shift via plain C accesses.  This causes KCSAN
warnings and can corrupt compaction deferral limits.

[1] https://sashiko.dev/#/bug/linux-b61fd78e-8874-42f5-bbe1-bcd3914879cc

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111084205.8099=
7-1-zhujun2@cmss.chinamobile.com?part=3D1

