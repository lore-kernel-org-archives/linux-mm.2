Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3C2B606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YB7zfq8i
Received: by kanga.kvack.org (Postfix)
	id A40936B05B4; Wed, 11 Nov 2026 19:22:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1B76B05B3; Wed, 11 Nov 2026 19:22:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3D86B05B4; Wed, 11 Nov 2026 19:22:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 511F56B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:22:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B53981A026E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:22:46 +0000 (UTC)
X-FDA: 85424566332.22.F95EF4F
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id BDB7140002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:22:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YB7zfq8i;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794442964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gFvsNqBDXUT4BnAgicfRx6qITAPLA5lFq/xnuZcz3Q=;
	b=uqxWxKxIqmm+kKBg7m4bzIVlBMBUqge+e/EbUEcCC0guAgpNoVdzLVdm0z5IngvTLribpF
	Znp1eXcN9De4lUISfg79an/CYPjGMcCGEum9kJhqex6AB8pAasazIzKCCZjVP1/FuSJLiG
	dviURDCmG+6P2/bBmQwwZsoO39XLYjo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794442964;
	b=Ikh1ESG02JAZU6Z/7pdomkiRWuJ3wYvVE9plDeYTIrlvzvxHWu3oY6j9CEJ4rc39bqH/9g
	vMGmLGZIXegMbgFIxAXR+aTqQNWeNlCreNl5uMd7lFItF+3IY+Cw/bs/4/zWCv8UuYcisS
	L/NX+58IDXs3lAiNirXv6KEEhPp/TD4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YB7zfq8i;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-54492d8a988so55101cf.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:22:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794442964; cv=none;
        d=google.com; s=arc-20260327;
        b=EY5IRCLLMrzQK74NxPLq8JOkDPWklvirYcvqW/+qQ8k6F1METKOc36ZA/ikq96RH0l
         Xn15/lGuVlA+OMfpVCfGK5QH6iXDgHWFkh8aux+RgaqDDVZ2KK9sgHCW1araL3/vjibN
         jAhULaLmEcCqW4fOcq4TjdJsDE5NyHbYe4JvEyLAjo+5JcCpK14YXlbY5zBVaGi7EJwZ
         sEvELb63lYrCZ5M1u0kHOEnXcqU+dGV3nMjEHtIgXrlmxzAsTD6JeKaaia7Oeg6/ovm5
         xVNnv8ce3V78xQ2UOCIc1uTq/QYGi/0J/0w1srx/hwpEHJ6htU8ZO0UyHiG/w1tPl0iE
         ERww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7gFvsNqBDXUT4BnAgicfRx6qITAPLA5lFq/xnuZcz3Q=;
        fh=V6RCIkRSI9+upmaBRKdbhBhncFbnWjpA4wNtdn/I9YY=;
        b=KWT93zp2Avr4p/zaIvj8gTvJ/sLw1M6Z12vXUnzRXMHItLfsvW33r3sixrcVHrqf0E
         ZnLHPnh1CTV/2PY+vYr374wijlMbxNtpcUvc490bMqSLYVzeJad38IzFDk/lltqmoGu+
         /fsPpxrRCapW+tkbG3M6KlaIXZFr69vV2jw9Wz4XhGB2BqI+jnkaBle4ICptauoBB606
         3Y2IorSra4fBoIOrlyMB+f99n3Ss2+Nl7KQeTatzwkZcuYrd7xzH1XxDlD+q0fkYAux2
         Ldf+cGFdCrBBpbJR/dDvBISCU/oQ/bO0k7g1vZjmbCczJsduV6Yb0cI5Jak6w6SLghSU
         E+/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794442964; x=1795047764; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7gFvsNqBDXUT4BnAgicfRx6qITAPLA5lFq/xnuZcz3Q=;
        b=YB7zfq8iyOfQfIVj8Sl34fhj/bGXDbXBAIYb3Mzd8aQ3ffvGhHzYwb3vrGFojSTG5z
         x3lfqMfjovOfqdHiDg9zRVDDxUSD7dnq0FgOS6oVevycnsdY4bJUbAvJlHeAE46c6qpH
         zVAWOBgPa6TJP9fLFAJHFY2wr4W1uLonnsFiZlUyZqQmyRTPHxso5P8H6kubiSV9qyYq
         76tbiGfVDUrGT2PIh1a2FW0gzAwNbzIB7zydDWMMhQMNIk2BNk/hl+dNZLT+6gpLkDtu
         hk9AZnYwelvdIQb7hSfsgUIsackPuohU8jfqmzD5iXgVuvqQW2VhysNgju6PrUDMKXtq
         UTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794442964; x=1795047764;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7gFvsNqBDXUT4BnAgicfRx6qITAPLA5lFq/xnuZcz3Q=;
        b=scjYmKvAkvkFQbf7g5tPnJ2b5Qn29Z5Mu3nFULtKXzT6bPB9ZIdBN5bFMnpgIx44RB
         g3SNGgqP1Wvf7gH/sU/u+ueKsOgJZFyJVJfOw6igQ7qs/o6QecClGWkrkCp0Zwdl1jkC
         73oJhV3b9Qv+K79ZnIuYcBrDsP+g8uD/otSrGddetVJXFVzeAGJSjUpHAH2Tr5Uq7zXC
         haBkQp20yTWqAAnWss4j6UyDug816uo36xfHhnQAvpR6C5WijIPW8nZbmZij3x/MFT3N
         cWW8Pea4Sfn03lIzbU5D+NkbPc6IVwC8uuf3AvCSyDKwcgBAwpUpJivhbPFkB/QhDX9K
         EknA==
X-Forwarded-Encrypted: i=1; AL+hErFYfCffVc6QEdLBa0/O3Ym614Sv8epK74+0v31470RNibuI9kkQsShXQ2mA3M1lGCD9NMsKulm/HA==@kvack.org
X-Gm-Message-State: APuU4Z//XS5t8pKwwt6WOuXcaSO0IDc3WXFDYxaxb8eP2i5HBABt8qm/
	TQfdCdA9YkoZUU90x8Hatra8P3Dl9wwSKbHmZJ1Zf2JBOJZ1bH10rVmprI4G2ztYzDxhcZP02A5
	s3wuVij2ZV+gfY9hSgWO2UN30uD+Lv4rj2ciJtWVK
X-Gm-Gg: AYBFou3F+d7w1yDY1ALuEexBlEgeRo9toUSIILcxLbZy1Knpug1NgGkarvIZf5WlCDT
	EXUsbIW282is1fq19/Fq4TKOTGTHlz3WlqYm7eiAvZlRYM9xX1weGfCQvxdttpgFuDsfigde7I8
	81tYL8JHkandxxFo6kSlhbaM27aThDoxkwfCTHoZBf/XiqvRx2xfI79DB7CBnRdpV/RuPmwmlPe
	yZKU/6kofhWT59ezSBrd/kVr9ru7lT9O6TG9NPk+uL+G/uXI/evfjUKnEMsZan0UBYhUK4l5pIe
	him5XVryGlzjW7X2+BOf7QDVONXGBYwpEm/9YvJrPvbAMEl77MfLfWiEHDyZlJN4vh0owehEz1i
	23RiYDAzEMvb7CnTHpF1b5FDQCwJQWg5VVyIDCmFWpGuUY50/kzmybdWu9DLwuB4jTGeIHDrbIv
	b1M1tV2RVqThYzl2/7cMj7maOocA==
X-Received: by 2002:a05:622a:a15:b0:52f:9ed4:8d76 with SMTP id
 d75a77b69052e-55990ed99a3mr5033851cf.14.1794442963091; Wed, 11 Nov 2026
 16:22:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110112546.261415-1-hao.ge@linux.dev> <20261110112546.261415-6-hao.ge@linux.dev>
In-Reply-To: <20261110112546.261415-6-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 12 Nov 2026 00:22:32 +0000
X-Gm-Features: AclHuK_CzL4RP99FDahiZaf4bltPjfDSR925sbwaiHf5mOE6wBtoi0bQgJsZ6U4
Message-ID: <CAJuCfpHWe6gB7rYvTrW=ufqPtFtquGW_u2v1yV_9uuXtnn-KbA@mail.gmail.com>
Subject: Re: [PATCH v4 5/9] mm/vmalloc: BUG_ON() on an unaligned range in __vunmap_range_noflush()
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BDB7140002
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: sqbwjzhz8ccsgswwzifnsfxtmarn6w5m
X-Rspam-User: 
X-HE-Tag: 1794442964-329353
X-HE-Meta: U2FsdGVkX180nW20wn4jqMPHHZzp63IaZWaiQAgXD3mUqCin53onU8jM+cvKrjBqHusp+GYpStw+E13P9eDjlTt0Gt29JpSKt77T1wKp3P1aO9HYQw6v1899N+8Qz9Y4m7/zj4O2DYyBwcmneAK0qMurj5Pu1R86vzJ8oUAwV01OVWhaNPEptfhFFeePYVFo7/Qs9SywP9b8OminZXZDAKXlafVBn8gN3O/Lx298z91jY5YkPxU37db7xjMJxZ4d33BlacgAm01yIBW74F4RFq2qOC9bLZ7sneeKTrdhj9xPDRU1CIONOtB6ldbhXGysraYgpy21E78sZzxOcpzMYoJg7rFFb//ra+e/scGV9z4WZs5rrFbi2vgWsL5iXm+JNFdMMyT+x39z8XXK3nlVuLwqtSUZ7XXVlVU9qlSihT7MYwqwMea4IPtTERNLF50JS8uMxfCkPAV/zSRkrB+iF7O6pTkujye8o7uzWB2RT/NeQ72IIq5IeQ3abVJfCMmtk9e0fVFkRj/eNTUZeMW/ThECePgltDfYUXrOsP5VfyDs+2FmQ2g3DiyhlsL6B+yHRkzhOzLH1a4ELpSNFRy525pc2a3qgNIkIDNcQ5YxKhTKtYr6+T26+4k8yNTn6oczjsavNDpX5fH+n6VPALSLO6Y9HJCV02s4jZ73gpHZTPa4PWFSAcn8gGoWvb2mJvXRtvL9ZrvIZ9apxGBpba1e6ETHQrPKKfbjMCrjLM2UO4kqO/zHYSPwmVRKvZE4Bn9E9QflrTBvgQ3fcbR7UObRPXXtATHhzYpz80VNz4SF5aeKUZfqzlreARV93wJAwuQ+Ns6l9qSdDcUWX+gR5zTPSgJLtjupqWuk5g7+cX9vhvH0EGjEaqjNLys3ric9Rq5vVoNP+IgdjgybM7Z5nHJaqylJUuDiwX4AODUUx4SI28oZdbGtUKaiLx53MeqM5i4o18PO0zYQ/dN8npRARvs
 MitfLTvu
 JDuDbm4f+MOF4ULYXG6Vou3neIvzejCvIM14EZr3AZ0y4ZQx9wi2QPDZ0455D9VIMh55bSIU61znvRqqY1xkaM8tvCmhNoUNGJQ57V7EeYlNXXce/it1jgxBNvWnQ25hXY/K4ROYSjn01HDF23OaLLikkra9tIJzt+Y3GroJEDKnmNge6HqoLXm9MZL/PyfF7mYBKKQyyhtyASUOA/thqixv8gcyqxa4m7wY+qRy/wuv6a4YtkaO2l0eeNIFw5w9gO5bhKzE8Ge5qgqkdAKSz4FFchhH9TGNhYSK3pF9YtOw+45b4YhEdpPGevVDOTCjiSt6EKvqaP8jX8PXw/W6v6GxaPs4BpbxXkRq+YNfXRfD9jM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:25=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> The PTE loop of the unmap path stops only at addr =3D=3D end.  With an
> unaligned end addr never lands on end, so the loop walks past the
> range and keeps clearing.  With an unaligned start the loop begins
> in the page containing start, which extends below the range.  Either
> way the unmap clears the mappings adjacent to the range, and that is
> nearly impossible to debug afterwards.
>
> vmap only installs page-aligned, page-granular mappings, so an
> unaligned unmap request is never a legitimate teardown, and there is
> no way to tell which pages the caller meant.  Check addr and end at
> the entry of __vunmap_range_noflush() and bug out before any PTE is
> cleared.
>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 86fbb1d2b27a..0565cbfe325c 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -518,6 +518,8 @@ void __vunmap_range_noflush(unsigned long start, unsi=
gned long end)
>         pgtbl_mod_mask mask =3D 0;
>
>         BUG_ON(addr >=3D end);
> +       BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));

Again, not pretty but I don't see a better way that does not involve
adding early exit checks to all its users.

> +
>         pgd =3D pgd_offset_k(addr);
>         do {
>                 next =3D pgd_addr_end(addr, end);
> --
> 2.25.1
>

