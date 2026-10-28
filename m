Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3B9360A5BDF
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jV+vAVY5
Received: by kanga.kvack.org (Postfix)
	id D24866B05B1; Wed, 28 Oct 2026 14:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4FA6B05B2; Wed, 28 Oct 2026 14:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBD26B05B3; Wed, 28 Oct 2026 14:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 978F66B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:13:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B72FF1A01E6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:13:01 +0000 (UTC)
X-FDA: 85372831362.08.BC3E4FA
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id C2B4240005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:12:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jV+vAVY5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=kevinloughlin@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793211179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARyFxRSvqAD+wB2pvv1XS401e8GE7i3ocZP4rplHOIw=;
	b=7lI9Hm4YrgKoZxzse1uRB9VD+1GJafzojBgiVyF2gqZ1do6qOmEb92R8J5to8TfPfP1W9r
	5ts/oxS5ALhOMMvG3PxG7RNLkt4kGF5HjUK8gBXFjhH9M1RHsH53iyYpHayT15TBbCiLKU
	kcW3EK+h86IVp5obH9RAjaJrD2lPgr8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jV+vAVY5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=kevinloughlin@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793211179;
	b=38Y+OWOMgcLRhTDL2TsbDbMiS6Su6JQ8NwI7DNyoxjxZnulLVwUz1qqJToij4Y5w5HkD7l
	kxAOSzkSZW+f6oDbK1TbOtLnnM/+604OAUF+Z4HGNxgEJlfRwODURsOyagaM1VjPmat6Me
	VyOy7YHZ0P+fwJ5MYqLYdtL0BPoemfo=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b10ac6ab7bso12136527b3.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793211179; cv=none;
        d=google.com; s=arc-20260327;
        b=SzarBORxCsh2267+l1yAabgvwGNZdOJ/V5ilHJJbWdlJlDKPiZ1DngqDe2jA0msHYt
         M7+LDtHjIfkAW7bl+WRU0Ush6jzjqOA54NR7ArFSDCYaZ1fngCiHoihmq/yrc/MgnxMe
         OGbJBjgQU4yFgdYqk5rzySSzG0rsF5AQrqRme23jZk81WmmVXvxC6C39aZvpYIK+0WtK
         g7Ci9XXsFl1GCvGamPXJ6OfW01tR82DmvU6y8cuQPwrynXrrHognADPR4or+1n9QWgoy
         fFaArXBR7jjnsh4G0v48VdNYy3ZeB4216QfQ4V4Q3fbkcVQxaPR8Ng5PzYLdwSuDrNSX
         oKgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ARyFxRSvqAD+wB2pvv1XS401e8GE7i3ocZP4rplHOIw=;
        fh=vRMpxD1NxKI3k9pxlmWA9oBhJ/VRi3/2bIh3gqW2D3g=;
        b=rzASfPRRhwpazzArvGuvwvw0jCj1cadmUJ6uxcC8bO85Mj2QITmdfooIQ5fANEgPa6
         1z+lmlav5pYtsfeZI6K6Blq7JSeJlzPMofTUDj4Fz/RFAv25psmKUBwSusgvydgpWmzY
         yhHH5c5VgkRQb+R6hEMgWQrIAM099sJOhoZkVzeS9EyX48lXL08xGscFm6hyOEqu9AXZ
         iCBm22HR4WXGhFSQ6bHwr/tX2ej7R3joFzZSwHzt19+LvcviFpwCIx3090LQ4951yzP4
         yWFN5sOFluQI6s2w+LlaS3ly1DnkCkXHYbDMbdgP9Fc3hfSnmt+yqUuWFAPwW//l9exP
         Tl8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793211179; x=1793815979; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ARyFxRSvqAD+wB2pvv1XS401e8GE7i3ocZP4rplHOIw=;
        b=jV+vAVY5ZPe9zeARtanadgBuBqLscREcNEKTTmpGUeL40ChTYytKUPt0l0cPNc/p6C
         /Ss0rMK6simE+6Qh1ZOXRloL516yF6Z3iFCCf7DYdp/6BiHkJ7DDIdy9bN6DKZgTY5dX
         qDT4Z709G8Vy9DS27V9bpUqsnb0YHPAeRJo0L0BOyLDi1CMdB187NNoAHs57ck+52Jzn
         L9Gajw78Zaq3nk6OnMP1xA9dWdpd/N5FTLOPGwHxrkBaOgsMrYspu9gYfRFsmpSLpAMK
         pbZEVaA8WGXIoSTyaMTaYkOP8KebdgdxtQMEWY9z8Xk2fh4wJV4j74bwCNUrRHmWCQER
         PGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793211179; x=1793815979;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ARyFxRSvqAD+wB2pvv1XS401e8GE7i3ocZP4rplHOIw=;
        b=r7U50TuVwz/2pTc9sohEenrs2JsOYMQm2bv+v5N6wotSRv/PLaTC2EF2JnRyQpX5Lq
         8+4DO98VPZttOKKQFYefoKCi4oiKuaIpak8FVOKTXOrmxnD4Yhz4lMXsHW2z2yqFhhkv
         Gk2CwlBGO9iGQI28c5hki0jJ7T3zM7/4BwzqQmogGs15gSx5KjD4NPF/vZwIdSoLLPWD
         ab8pRZ5wVz+7hjeQXja43/PJ6ziPyJ73XGufOAfV78XDpDJ7oBk1a8JkzovSevH7FP3i
         bRGf1nhpSwFL9LOO25bnDhb33MMbyEvtXYRg4JBnYkMbJjiGrACP9o145vRO62VPOrDp
         ntmg==
X-Forwarded-Encrypted: i=1; AKwUvBzuUmkKiOFyLHFJZRwxos/GNUfzpms7OgIpSj0J8LJP5yLoRL0Q1ae7XG0+4RvSwDe4owsxFBLDEQ==@kvack.org
X-Gm-Message-State: AFq9FYJdMi6gfLyhjs/mDFLsU146cJ9Yh2yQUJovdqVe+Q8b9NVpJswP
	yLqfaAC4v+Ah17wsnNQDetFRIlaa2IZG2/pxdi4u26p8QTfSKcVCse5MoPFW0S329jzt1BAYXQ8
	H136evaEmiYm77KDdTnYS+bVOcpd3XirbLSK9Zqpy
X-Gm-Gg: AYBFou14sI9ERfxhIynmtdvYayw7/eoiZGm0xQzEK2lg4MSw86D0Vglocd0bd09jhKk
	HkofHjWy9pDddyjWd+6LWrITYG+vYNy7eJtZCQWXUB+bZryEwsWeDBn07zECHDrFVItSlXtPOxe
	lI5X65UQLz+++H8RQ79AGg9yo7X87UdAnrvnOgYYQm1zyLp7T92ZwpPxjfUtV9IjPF3r3tdnJw7
	qiKE82jb3CnjZWEqjuqoPDWBBUzwlDgpNU6knoiqwOKphKPQNaUP/9+5UVCItH7pKNr5ti8k7wq
	CB6IxVemPWQC+wzj84xwYHo3+9hG7oqPzc6zqj58S4ohYKELg+Zw4dq/qPja52lXLLdp5tfraPx
	eiLhqsGELKpp2s50b0LtZoS5ZC62RItG5u5yvo6qL0LZtQUuPy701n82SufgfQ//Iyak=
X-Received: by 2002:a05:690c:f86:b0:8ab:436f:6e7b with SMTP id
 00721157ae682-8b1b5e93e9amr21228787b3.63.1793211178194; Wed, 28 Oct 2026
 11:12:58 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com> <279a92da-772c-422b-8047-ad37dbae211f@kernel.org>
In-Reply-To: <279a92da-772c-422b-8047-ad37dbae211f@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 11:12:47 -0700
X-Gm-Features: AclHuK87kmeri51i0i8SscXVJiPFVq3oTJZMZ4FP6A_jqbPgcyRklPs7gnicX7s
Message-ID: <CAGdbjmJ8qk7FCbGU85u9+db5_RtcrK2y_7TfNH+iuz+OJxebow@mail.gmail.com>
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>, virtualization@lists.linux.dev, 
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sidharth Telang <sidtelang@google.com>, 
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Jacky Li <jackyli@google.com>, 
	Steve Rutherford <srutherford@google.com>, David Skidmore <davidskidmore@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2B4240005
X-Stat-Signature: mabwpkw54bnexh7rqyuah4x7isjtpqte
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793211179-458250
X-HE-Meta: U2FsdGVkX1/NQca4b3xW7GyTpozghCjUPFvLuVYRHfVutSEXvvLWVzhk7xqCmvy+8hme0nY5R9UfptR1rtmIVCjydG5sMxcmArPNowSTxOIQ43RObAOWt7god03TaqJAoMir/1pJkZQLylnRdVFqyWYrVxQ65LE7z+PIbn1KaAYZlh6Yu4lqSnO0HXx0OrrooAvbFTuBBnkh20IkQ1WJLdDBEpfr3hlpGxtyKWZNrlQKzL5u04TuuZaDb61pQZFCcOBx1uRbHCUyfdQPkEhPGRxxplz7lw1sg6msqknK3gj5PXaUcToUeQHRhC1cpoe03MSKoFr9P8yALQ3wsg5BA6sQwdEMvc9dmpEA697zw3Ozp1mHtGmsx/ZH7D9bOeAyn0kuZad4eN1wM7yZnfmYWDiOGnCL2n6LOv9UL2XgYw+Tn9dpc0H6Gq+sZJqU0EuAhibia6bXgfq2/uKbL75K7TqjKdmp/gJ8mA5OZwyCsAJMmsHWpnPWRMOsdNcN4Nz/sNZN6numYBOitsrGxyOHlX2e6/jYyzGN3O8+3YtkFshf+PhtuVxWcKzXKN+7R6TD4v/eGKTVL387HG51/tMzFnLdhMPgeMk2n9vhYoVT599kMYWRmQf9ZGVYVRJMRGM2i57PXz8DOYp9n7gJHPLTkoFI7jl7BiyBTcN0GufvGUjEayU6r0lVaz7Tzq7ZbxkUWcgLUJ7+7u6y5D74CQgaZmZ3H4IMryHNRNeko9V8RH4jKixnpkky/kCkcgcuArZ/sYFcUrVlUNWnGBjENSUfmBrqkxc91+18ifQ9UJWSeUPxHp/Ce2tDWpMl8zhuitpHIuF1ccn+55WMiJJ64tRd1RyqRRsr/VwoMrW7RoVPdaAqBksIjqOBSh27gS438SYYzE12aKE0zkYZLZlib9otINKveRMnu7GQCJHjKxTnHz4vJuFAoR7bvLoCbVWNKDD2QrnXjZrtvhpUwZIqE26
 jodVTVcq
 aXTvfE/CVZrI6/YWfShGF7kAiU/Xr/ixzvHyedsMpRKKNBCi9qvZiCkxa2uszyV1xeMfzubnW4aJH3S+uw6HKXOgJQgKNnA2GKsfQ78GpYtwkP1JdZYPiO4oAXKRM9MNdPoauCLaUyWaF+J7P3lanFPsiHMbS3ZqSz1bTlxEPZ9R9L14hJcEv1VJabSMwC8omoGfdJQAEGkPX/mMDq2pcMS2n8g6V0qLoj5d+ZJ8H+UWXwMh9RNM+w95v/U2tLLJoYTMMKwb1CTh5ybJkQKzMkE1ND3AUdtxzTi8cFw0hk+kjSCQ4FJ98N1iAMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 2:01=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/27/26 03:56, Kevin Loughlin wrote:
> >
> [...]
>
> >  mm/page_alloc.c                               | 248 ++++++++++++-----
>
> This diff stat should give you a good indication why this series is not a=
cceptable.

Got it. I will keep that in mind going forward, especially if I end up
attempting a v2 that simplifies things.

On that note, I believe the majority of the bloat in mm/page_alloc.c
comes from...
1. supporting the legacy inflate/deflate option
2. introducing support for various page sizes to be unaccepted

(1) I can get rid of by dropping the inflate/deflate option, which I
think makes sense given free page reporting should be sufficient to
enable dynamic guest downsizing in cooperative scenarios.

(2) becomes simpler in part just by doing (1). For further
simplification, we could potentially restrict free page reporting for
CoCo guests to the current 4 MB MAX_PAGE_ORDER instead of supporting
any order 2 MB and up. There's a trade-off here for reporting
effectiveness under fragmentation, but perhaps support for 4 MB only
(and its relative simplicity) could be acceptable? Especially since we
would then maintain the invariant that all pages on the unaccepted
list are MAX_PAGE_ORDER?

If I can sufficiently simplify the changes (especially in mm/), do you
potentially see a path forward purely for the free page reporting
aspect of this (dropping inflate/deflate)?

Thank you for taking the time to review, David!

