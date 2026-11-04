Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E32FB606A33D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OhLrjBcm
Received: by kanga.kvack.org (Postfix)
	id F25AC6B05B6; Wed,  4 Nov 2026 11:40:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6086B05BB; Wed,  4 Nov 2026 11:40:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3356B05BC; Wed,  4 Nov 2026 11:40:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B50BA6B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:40:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AB56140790
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:40:43 +0000 (UTC)
X-FDA: 85398000366.16.F7C9332
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8E07220003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:40:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OhLrjBcm;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSbCnlnfPQbg6fvgnw5ikKngjsmXzoffUrEdFG3lAfU=;
	b=CWeI1HoVaers/VeEAMDTD1mX7uPf+Tla6aQgWMEAK9aoWiVaUh70H2iHs781tEQJn32XEU
	GxHhITIcDyCPYVuzc+vP87Q9zAvMMb0N+upk+JW8/DAJet0QYKs/PHXXojPcQZbiCjydZV
	TQtZqHpOswVVCs76sMBMoT2RnEgLh4U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793810441;
	b=GkjRoGgVUNmiP9YAV3lUOkKdojPvjb5T5TysJvUidoXrPH1xztk5YyOtgO8WlqruiSjJ17
	++CU5c29lCvNWSuXZnrd1z19iws4tOwN2W62vRySjTUpJj+7q3rkbtg//7Cr3Fk1F9pMiL
	w5f8AUqBbRSLC7ARu9oYaSXRv1SFT1c=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OhLrjBcm;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-490d59c3edaso229323f8f.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 08:40:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793810440; cv=none;
        d=google.com; s=arc-20260327;
        b=mUoLbhCznhW1JgevyzoTTka8m7eYWk1W2ogAyNsK0xUjFW1CVJkM2Wj94Uz4WEMe8B
         8WUtGbuie8PyjYKHU/q9yJqMhjeCOrIY2jrDa8jcmJgnK2sHInq7aSzV7uo2L8ePQ8SP
         85y6iZ12W7E/FCrU/MVkbxnSFBnQCVXDKNLGG4QEge0HNgReDTG3LVf5V4V7y1BgKaQZ
         I2OcqkSZzm/Z4cxBww0C8BqMlVy/9X0Mo9bg+XROPtrJugG2Xm6XCvEQyJCSGValpbch
         wJEuNTrE6WKWVf64y37kz5j0TmRzwHZ8XsriO1JACng/wQKz4anmGz/mXQBI9fb00Ldz
         iuzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GSbCnlnfPQbg6fvgnw5ikKngjsmXzoffUrEdFG3lAfU=;
        fh=KzM5OLLOx16Xlm3RuNqoRIhIfIaVM7kEZmYhn/AhuU8=;
        b=W7aiJEBS4WTG8gpeJatb1f8hNOCyvAYgjBTH5c6GegV/pEsUEjsG9UAwEaNh/UYz1U
         oq9LGZBSVa52z42hcAHDZwxPjU/9Lx7JTGwG9B6rMX3lKdDaokuh6lG4w0a4mjag9p8C
         5321OPVVClEWdwdciWD4b3mp84zvP1Ab8+9fk/72AiL1G+gQYZ2WOYp1Aa5JDLJfB+IR
         a7AqiME72KTJYPfSX4WspNbefTL3rnD+e376BHcPftOJL0BZENyOwpHdnJrFDqJ94Q9N
         l4bynPvQkVFIUp9N3CmG9Sqj19m3XhWnhjdZggSAq95vElU0GN8HDkSSHVKZqtT0NE0m
         XcKw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793810440; x=1794415240; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GSbCnlnfPQbg6fvgnw5ikKngjsmXzoffUrEdFG3lAfU=;
        b=OhLrjBcmUclQOJGnctt45qxS41p+tZGlyg219TinqHz95SRSHp+QyuPdSGcpjZIIiL
         JovuX9cFghHYhtj3I5A0maODTy0s/xmoDI8pQ92IAhkyYOttMdo+ko5DS1M6WIAE8lg9
         vfDbVwOrETzE0sMZtzn15EHFoIsGZOf+nnmKv3K8DDTsB81nCcawqQFUi6ijhahXU+4q
         0Ir1tW3BUY8qCufQEowEsoRtH1lhNNTFBUZ3QQbR0y1G1/e/4XR+L7UTvOMnuXy3CaeL
         x0kabhF4E5NIp1qd7VNALME+6xcOVdJkJIEqR8UrCCNfhfRji5CfjWv0WBL4JWE/k0rC
         S8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793810440; x=1794415240;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GSbCnlnfPQbg6fvgnw5ikKngjsmXzoffUrEdFG3lAfU=;
        b=V/Mki2HjFBiNpK3xLN8EiXWzym+JzC52rGn0Hm+wgQeXulKKCOwdM82tSjc7WwE1p1
         MnN9rIDKcMypn9mPw3UEZtJpAisq3Le/2KQjR6F4NXO2Cdc3dppsV2X4Uv3CAY1KxqTG
         RzFR2cXVcjbvwcTTIBysm99kVJvXP2zLpKHOEsKi0HHuRHuplJ3g7EZYTro4tRVDPkcg
         ZUlb6TW/gj/x5EjuQ+T/0H7ZqNhA0KM+0cgfcpY6A5wnof6WDjEpgUbUx6y0sjyx6/av
         n5E5ijSBA0xR0Gmmi952/RgeICTTD5p5aDzTFkELEGd5riZK1IB7oF3RruKN1vMY656Y
         gXSA==
X-Gm-Message-State: APuU4Z8MujRH4lQwRRFHgUVjrDFkh/7MF+4Vq0VKowAx525S0AUcocVl
	Sevf4LVMCn9NQYGJ8KC7r172FvlO5IcKS4CcfO9DYrqC0vt0kWBF7ND7Nf8mbYOf75lLqlnRhDM
	eD2YgXWpBNW0rqb1EcZVex+mcSIF8+WE=
X-Gm-Gg: AYBFou1hN7lmiOIyCG8IWU/NA+9YB2fohS1BLw1ZVijZfU7C/5K5MkUf7S+qOMZQkto
	Nuw1/D6frXXi2WyMvrx4i6Mm+Q2ZTpskq2HFzALu8Vc8jdIoCOe3Wv361d6DdOTWYNWMYvB/gHJ
	xYLQoEUbbJL8b6Rjq+pfrmxHyYSiTH5lprWAPrr1/TIE/wo4yh+qO+rJVa6ILjQJ9LC4Wsgl78j
	r04WDkP30R2rOvNjatSNMhwDND0ib/6qgbvBVep/QmiHUKiA91/uwAPcFaI06BpUELHP7bh6XxE
	vrfeYnBfJ8CVhfjyNIXf1P2JWnLpNVPS/+4745CjviUBA2+Wmg4cJJUT53qJp+gBE2Ya7n3y2hO
	JB97O+vDQCZ8WtoHKHWARJm/zOnHT5UkzrYHSx7vNzB+iTWgJiLuQhtZCwtoPUTKw8q109xbFmJ
	6StMeFmmUGeqlVpuuLMOElHivRCixYMyY4lEAt3VEvyV9QGlmCIK3t
X-Received: by 2002:a05:6000:1882:b0:490:5521:f24f with SMTP id
 ffacd0b85a97d-49115c97ab4mr52629f8f.3.1793810439792; Wed, 04 Nov 2026
 08:40:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com> <20261104-swap-hibernation-slots-v4-2-0ba9393609e1@tencent.com>
In-Reply-To: <20261104-swap-hibernation-slots-v4-2-0ba9393609e1@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 4 Nov 2026 09:40:28 -0700
X-Gm-Features: AclHuK9j3pTBHBwintO8gANsTMYNMbLvY4P_0RrfW9iaGSWA-lhEMfxVl_a3gVs
Message-ID: <CAKEwX=OuBQg4QV34BTsgA7nhOjovHFzZPVf-o+oWzAaxQh8f-w@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm, swap: give hibernation swap slots their own
 swap table entry type
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Jianyue Wu <wujianyue000@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qs6epu13wxoybp6a81gog9ajiqx8iiyb
X-Rspamd-Queue-Id: 8E07220003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793810442-996221
X-HE-Meta: U2FsdGVkX19lAXvVlw+cQSNWCTI70Vb3HLHbxII/3I6GWglz/zSU+XS/Kg1Iy8BP1SUO2L2oCIK+8YlrJVQdkBShodptq+eNvmuNov7uLnhfA+RFEJpVKQYi4WCXbPx7zCx7AeGVF2ogyh1DrYxrGbuiGDeENTp/WcV4W9ZrRmGozr/QZNqxOYTjiMNbDR9mStZdKeaDTXj36AbMQ2+JMZyJiIIOUCQ5BkKUnmTibrETQOE+JwGfHB+pBlXi8VDMKA1oVqUf2VQeldkwyaxmDl23CEeMIB1MKqj6+2Dl6/f2NgkmzUccLvpnADZ4BdmhoO1wWbuJ66PUinSxXWi4Tg0/0OLCGNrNtCmdLg65KahbcoG4QhjCAjV35FURmT+Nnkj5Zk1duuMtGo2f4+n7RwDyHjTWw1PdCZnI6mDkQyxNZ2t+GjVRH87Sd1h0bGtlC54Cq/dDQksDSbg+V4we9YQF8f2HMZvfRV6RWStaBp2ciBnOuN4o40GRW21C9vRvimTcWYZoL8T50fiGFfhRgjLt1ZcDiMkQWT9DrVXAmS2OXoUACX0/5Kex/+kn6/f3uk4NBDbPIw/X/r13I7U16vqifbXj+1NJJ6d19oL4nHqYVPLzYL+Tguu6zkIwjNmK86rN4+Z09fXZNtSq0PCLyhkNITWHAayhKpQPdZwDhNry3vN48suVb3YHGGIH8s594G8nVTzj4gbT7MJBYjF2fabvYF7SbGb5prU+plHKtevKNRZ+PCu3Rc+5HyTAD19j90gsfV7jD5scrwupSQi20WvdXym6Etq0djpKixnwyHzNXR1Q5Pr1x0Nr1LxoG+PeA/6VlBoQnyjQVE/On4dwp9iE8fOlzPsfNA3L0r4eJ2mErafzOvAhJB4Tocqcfuz6fXVkErszHT6exUkxtzDZe36HIJJDO3b1kidc2v4UVvAcSezD5RDCimY7gQHsSRbinsZtA31Z9Yd1swukgi9
 RSD2d9Wn
 +sxXTT7XEGWViPx5cr2IHAJv546Ao7A2wO+iHB91Lx+BsnW96pkVcz0O1YwZwp7BiPGkSEnGsOOH1DxJSAHezBgOagXnRtr430wvROMtMLPR2hxyypwRUJoOiUzh4pIMWxXxlNFjHuu4Azuj6EiR8fccLVtOQrCd9ASQSrJb1sRDJqWqu03+NFM7NDTZ3RBdKCQYW4TSuOhfrEBqmZzfksfmZtNLh/BS/ipY4NMwY6bC1KUXvzmr2bWGyjdwxO6pOiCRq+nCMKdlFKNyQhmKTz31PWwfRimOJ0N4D/Bnwq2QA27Y+aFzI9pHEqZV5tyWjk1j4PQsQpxcQQ1Qc56dtRBELYS9ucrSlMuNjwMv4h7R0IHQN6xpZrxYQguhTYTY/itRaa86XfgwAntx2Gau59Qw1ep60AzIXO6iZe8hbSuMoPW2bMpBQ3iorY8F5ArQoCSTPQ3tXklHvG1hCi8f2CWssNPwtN6Ye0mgb5LkWuuiP+sMcRAfMuoUjJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 9:25=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Youngjun Park <youngjun.park@lge.com>
>
> swap_alloc_hibernation_slot() stores a fake shadow in the slot it hands
> out.  An anon slot swapped out with no workingset shadow looks exactly th=
e
> same, so nothing in mm can tell the two apart.
>
> Give hibernation slots their own type.  Bit 4 and every bit above it are
> set, except the count field, which stays 0.  Bits 0 to 3 are taken by the
> shadow, PFN, pointer and bad marks, so bit 4 is the first free one.  The
> type holds no data, so the value alone says what it is.
>
> The entry has no swap count.  Hibernation only allocates and frees a slot=
,
> so a count would never change.  swap_free_hibernation_slot() frees the sl=
ot
> directly, there is no count to put first.
>
> The slot is no longer a shadow, so the previous patch keeps it out of the
> swap cache.  The count field stays 0 as well, so code that reads the coun=
t
> without checking the type sees an unused slot instead of one at
> SWP_TB_COUNT_MAX, and a wrong put is caught by the existing underflow
> check.
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Link: https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> [kasong@tencent.com: renamed the layout entry to HIB and reworded its doc=
]

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

