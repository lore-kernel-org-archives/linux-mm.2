Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49EBA606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HcEnKnTV
Received: by kanga.kvack.org (Postfix)
	id 619796B00EF; Sat, 21 Nov 2026 22:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9B66B05B0; Sat, 21 Nov 2026 22:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4921A6B05B1; Sat, 21 Nov 2026 22:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 158C26B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:58:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 18B16805FE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:58:41 +0000 (UTC)
X-FDA: 85461398442.26.7E5E60C
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 17CE1C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:58:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HcEnKnTV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795319919;
	b=6qkYotzcPImz/9LuSKJPUmbZNJSC1GfADJ+eSffNqsaKU6c9g5zdE8WWzS+EeOJFJl0gia
	vR9ampcyIitpcly/uHfUFTkNK6nLB61/oFio+RQnf6rlu8gwgECjsSxdZRWepdzOqC2ePT
	JbN2jlgxH0oNInqUTlTW3kwxrhBuw4I=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795319919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6lDo04XbaVHnGHBXBgBBEvTruBmRJrwphZdUWl/Gp8=;
	b=J0094m1YH4B1MKwrxb+DzT73U3FUosuKNQel2t1dXXUr+f1AOynVTp8vZaxj6IGxLieZUY
	sR3i3QrFrKHVwZEf+zioBa1rxre1Wkq7SDLjhml9wfRSqYNLw3UincRS9BBDbEU+pfllQT
	eyzRZvkiLpH3SM9f0vBmQbErma0iZyA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HcEnKnTV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-55c7445cf85so154441cf.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:58:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795319918; cv=none;
        d=google.com; s=arc-20260327;
        b=D5ZTBAc+hWoA9q3N4dzshhTHngKvZIvon5J0EllIvYsBxut6DDse6Ma+DOkxHOCB0E
         5FFkp8dJXpR4t9dJQaXn2dEtwa6n7CS1D5kPypoxmqkS8eduGincsvoQE7HIOThblu10
         URJ7wD3juD0LVxONCehMj/RZKzk8ILkupL1Im0GA1pM7DDYOOiH+eZT9EDXZSuojTDop
         u9BLpzn/WBTutaIAVEAl0opUgvJTq1GD6IyMbns46f5pYJggCH6mYzFSD40VZpuoAQcw
         wZea2Jg6cLFGrHk4I4yL3Qc/BX/vVKruAJjYo+ynTSYmXJwYVE6tsQabYEvNACxNKZt4
         UTpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U6lDo04XbaVHnGHBXBgBBEvTruBmRJrwphZdUWl/Gp8=;
        fh=0TaYezVYk9hgsNatGpe2nqlrQHodECDJ8tIUqtVX77c=;
        b=HyRLPKv1Ff/lVpTCDQcnBJVO4tKZyOVDMeY3zJagK/eY7JYXSJkVw3Lyk9f+RyAPQn
         scbsLnWIRSZ+cokqqt9eT4aIQpfW6SDekdZ422OxahHRoL/dFBMtECEaDp1fWbJqqExq
         SIVOWQtwOBQwqpPoaLOmyVoT+R1MFSDfCNMTSTv+eZx146Wk+UgdWu8vkXy0gOhfLMzl
         EUt0R0sAz9QDCYxeeaODT+OWPyw3hTBJprrX8QWTJuelkDoAS+iQPBYz2t2rdRnbXakR
         gMg24oDirVD35eLtbhsPhIX2jPS+TBmlLTFmAd8xZA+QKRQU/fBDPdXIhPyRcUKADu+S
         vOPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795319918; x=1795924718; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U6lDo04XbaVHnGHBXBgBBEvTruBmRJrwphZdUWl/Gp8=;
        b=HcEnKnTVnq4f16eY6XD5qKGmda9GJY0jTgNxRke6+mm6rqDutgZT0dx+1mVowb+2L3
         EBd27pwAlcYPeJ3Nf8J6x6TWH+I8r0WBKxKgA54C9jxNiFZTAQ7gvP9+FSmiLxeJbDMo
         3P5oZ1yj1HQQEbw63fXPhPR7cmRnSquWW7Fd1v5lVwIWNuU9ELKXfMY/QIMm3nX/SUp2
         AAYkCb3LHtuVqaPbV6iRx6fTGvcCwyiLezC6KtdjavLeHswJ462HNCHkOno/SHSUaE/i
         8fG3ZClx6Dk/kDxm5D8dFSWlNmFKEfAGWcdWLLIKBIF3jA8nV2ZLRLTwraaOrJZ4/TKU
         ASiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795319918; x=1795924718;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U6lDo04XbaVHnGHBXBgBBEvTruBmRJrwphZdUWl/Gp8=;
        b=nZF+Evf6galLYegeTmcHgo6NVdemh7ondumxIPUZTDxLnBfDQGBfVWntOSTahWqM6E
         qJpGXAcZjEW4lqWMOYn886dEd0HMgBCu9bW2EI7Xk1EHaae+iaxnwfg9b7oJktm5IJQq
         JC/J5TB5ITidA07h6WV91vg/DOt7DQlG1j/tG2/5OJh2nE+3EKHVoYHsO64Jdpl0lbkk
         861tJj0s7S4H9TGJT35jH0/b5Tu6twHyB0A/H73R87pVzJWNwGXydZ+MMRcITGf3uvmZ
         ppG17ZsxuBNMaPUyGBvIw3wYG+yVrQsX6s7OVqn/xZhrlfpfpzv+o0K6GFhQa3wd1gKq
         T5aA==
X-Forwarded-Encrypted: i=1; AL+hErEeSg5ts4e75y9Wte1t1XS0DN50VRulPUVKXWfdnAfRe07zB+13lhc367p8XIATOlbhI+iHRc8KMw==@kvack.org
X-Gm-Message-State: APuU4Z9eHlZFY0CIC1KepsrkDdvBPDEZ9lJEyn/6DiIawPHe6xsKyUCK
	QX6SkzICLwdWkayJOtVERPDl0/s5d3xg52ZsNgL4kAbSKv2nkxMMHJ1b7dnQUEe/Ilu7Ygbcyq7
	l2BCx/wfWaH5Fw/eNdMqB8ZrAyV+/6urs/6+K6Rdz
X-Gm-Gg: AZFdTZdp2MiyecbPRSSuyxxSAl7WXSXCbPeCetWa15EVxW49LQaft5fusSlx6X5kUU5
	oYr29zLRu6ENWzCoknNsdOwmIqaYXqVFSpa9YXl/4NvvCvU1jEOLQUcdInvgt+agFSThshGl8Oz
	X9en8s6aFgQyvfgozAXfIGe4+hb4dkGv2AJ2g9lXDpACuDXIRLdN3fikXr+9uFsw9aNSeLDmyQ+
	Q1RFg/BxrbUY4t0b//aRyj6lFqRM+tMroq5gDvbSXAudJGx8RxuSBsMBA9fKEPGW5JVRkpi3+3l
	t/Z2Ugv0gnTzezaVaDQMntG1AbeSImLHHvDSxfZau3NslhYQ7uymJA7PPrNY7j+sgbO/9lMDBTH
	dDHfT3N0BbClBrUtTA9+jVRFKi+fdQhpBeS2sdvI8fmXfDLiazu1H1c0BC+LjODDgKSzfFXA=
X-Received: by 2002:a05:622a:4010:b0:532:9220:a9ae with SMTP id
 d75a77b69052e-55d8818abdbmr18248231cf.6.1795319917430; Sat, 21 Nov 2026
 19:58:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-8-hao.ge@linux.dev>
In-Reply-To: <20261116071325.263682-8-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 19:58:26 -0800
X-Gm-Features: Aa3M54oUVu1y1QdsMhiWrEo5U1kKt_0hi7a4znXOHdNoNhlvmsvMEXTR-bBBo9A
Message-ID: <CAJuCfpFvA5oqop2tovy33fKydx7n8Sm=X-hE0sJxpcR1gg5hMA@mail.gmail.com>
Subject: Re: [PATCH v5 07/11] mm/vmalloc: undo what __vmap_pages_range_noflush()
 mapped on failure
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17CE1C0005
X-Stat-Signature: 9bib7ofnpmysgxywzu6dycqjk4zxxr1g
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795319918-387856
X-HE-Meta: U2FsdGVkX1+fq2RAfycjeae7OY3Snwf96AmOK6EZ3GlHQlsJAqolIUKe0b7kBfFqPRk0i1vtRDoz+A6ozJ+l9jAtbwp2q089A+UlOxQz2PXlEX4b4/ymcxlva6Eihiu5HHK+hptm06PXrNgr2XcLwbp2sG32OAe0x7FvdUI9r4DXQ1VAXkOwlXoyGwslHQUXhyywz7NXAGKlxkYjSOUNy5YZtT86EtWyDpsy2mgd4DnVeF9YqHM0aWN+8XuVVH82BHwFP0qVLzuync0QEW59JxCz8JFst0Qmf14bc2673fbstMxEv9KWkiIoo6+amjpAX0qJgOZT9hFi6ibmGMl/8MzFG8TVc5pDTohRh/Ba4QxudLhbG2NGdzaJswwI9jIR9LeE6+OCmY4ViCtp+DrI49LF7F/RwtgRhr9Kvtu9QCVajcMimuScKq4ecqLB9szaq30SjUViJgWGN2e383M4lyai4O1Z/7C2r/5CHZ+hdFjvW416xo6gitwj5NawX8wbbeD3cceI+tqUzbMNfzTnk3B96LUTd3duIyXsgLKP8n/GOBRP+cqBkOKsngjnbT+V6+N4LZgspIJyLCYQP54AO7Ar5dhxN0OmgWYUCxQZ2dH316TZ3Gljl7beL5lcSpQJx/H/sagkhbCxHa7F16W9BWMBBhVkPby3OqxkeKr71GaIuIbvcEyuWwsh3LCrOE3mJmz7yluxE+FubvK0YXRaJo0xJFZXlYMOcWQ8fPJzUDi4xAGn8XIyi3l4CxdXWTsKSd48vwI4uQGyaG4nIKB1kkJA5ot2y2HRoI3ANWMyseDbpWJvHBTlteN71Dr5jABFeWE8xbRd9S6wdoteVW4m79LTXVzuWXPgVqn5HDkzM+Vc3GFe9wjxxolm2rmGK1c04asIZw1gudDaDwBe8Yf0/WQPMrY+6nxN4w2CKgVJ/6nPY2Rlfnh6vVJbtRqMgiIfZqPC0YGVmD4y5KSg80m
 DmpmI7Pw
 +bQfEMwHtcMjYJoRiEA0o07StsI9M7Mdkt8j77Q+ged3RI+E2ye7vQeNDHNG9JEAoJm8UnqnCsZ+EdtGmbMlwuCOlWxhiclmYUJp7xuhBAFUMQxr4XGrT8VsWBwf9w/N1mzlHqSRgQc9posVH8oT9DinaKyRvnJT9vjQL6bSKdrs2vsRFL7SbKNJD/Q4qaZfqlzfTzCTV7UQt9eQ5fBC7PqpFr1/vr1H/rKfw0jXJpW32DYoRJHXUDcKA6c9iFAyOm35MvZSysEpS37vyKGENDUzMbtaQ7L9OMQvjrYxjsvzA3+1cYjNNjewdzs41FWApKPikfpCLszR96aK8XLwxmSmuvMKUJjwpBTnDe8WxqutjmUbCprClYAZxUKLB1JWRdK8yGTvdjYGi4bK8h8YBdSzAgFkFRE/4ajHob51a03EUxN6+o7CTkVhCBOyoxtHC7lhV8wo8MV9ellP8lwcbvEoBuzJOdoK3qXm4EFdG4JRxtYi0dceC6h6kyE7X3zCbwJTBpGldp3yLnNt8ClyWVljZzy0esJzu4Qdrs0VbHxImrDmut3NcebEvXI9YAigGD30ULwGi/DjW58IrCJ33RalxWz4NJ+R8RO2c+dwT59CDEtjl9crCi8/LlkLDm7PZKsfW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 11:14=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> __vmap_pages_range_noflush() maps a struct page array and may fail
> half way. The ptes installed so far stay behind, so a retry of the
> same range, the __GFP_NOFAIL loop in __vmalloc_area_node() or the
> module tags populate, trips the WARN_ON(!pte_none()) in
> vmap_pages_pte_range() and fails with -EBUSY.
>
> vmap_pages_range_noflush_walk() now reports how many pages it
> installed through its running index into the pages array, and
> __vmap_pages_range_noflush() undoes [addr, addr + mapped_pages *
> PAGE_SIZE) on failure. vmap_pages_pte_range() fails with -EBUSY
> instead of installing over a pte that is already set, so the ptes
> below that point are all ours, while a pte above it can only have
> been put there by somebody else, for example when the caller's range
> overlaps an existing mapping. Going further would clear ptes that
> are not ours.
>
> This path can run with a non-blocking gfp mask, the undo passes
> gfpflags_allow_blocking() as can_resched.
>
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Suggested-by: Uladzislau Rezki <urezki@gmail.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/kmsan/hooks.c  |  4 ++--
>  mm/kmsan/shadow.c |  4 ++--
>  mm/vmalloc.c      | 36 +++++++++++++++++++++++++++++-------
>  mm/vmalloc.h      |  3 ++-
>  4 files changed, 35 insertions(+), 12 deletions(-)
>
> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> index 69008b085658..d830a4e649f1 100644
> --- a/mm/kmsan/hooks.c
> +++ b/mm/kmsan/hooks.c
> @@ -208,7 +208,7 @@ int kmsan_ioremap_page_range(unsigned long start, uns=
igned long end,
>                 mapped =3D __vmap_pages_range_noflush(
>                         vmalloc_shadow(start + off),
>                         vmalloc_shadow(start + off + PAGE_SIZE), prot, &s=
hadow,
> -                       PAGE_SHIFT);
> +                       PAGE_SHIFT, gfp_mask);
>                 if (mapped) {
>                         err =3D mapped;
>                         goto ret;
> @@ -218,7 +218,7 @@ int kmsan_ioremap_page_range(unsigned long start, uns=
igned long end,
>                 mapped =3D __vmap_pages_range_noflush(
>                         vmalloc_origin(start + off),
>                         vmalloc_origin(start + off + PAGE_SIZE), prot, &o=
rigin,
> -                       PAGE_SHIFT);
> +                       PAGE_SHIFT, gfp_mask);
>                 if (mapped) {
>                         err =3D mapped;
>                         goto ret;
> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> index 212449db34a1..452760a333e4 100644
> --- a/mm/kmsan/shadow.c
> +++ b/mm/kmsan/shadow.c
> @@ -247,7 +247,7 @@ int kmsan_vmap_pages_range_noflush(unsigned long star=
t, unsigned long end,
>         origin_end =3D vmalloc_meta((void *)end, KMSAN_META_ORIGIN);
>         kmsan_enter_runtime();
>         mapped =3D __vmap_pages_range_noflush(shadow_start, shadow_end, p=
rot,
> -                                           s_pages, page_shift);
> +                                           s_pages, page_shift, gfp_mask=
);
>         kmsan_leave_runtime();
>         if (mapped) {
>                 err =3D mapped;
> @@ -255,7 +255,7 @@ int kmsan_vmap_pages_range_noflush(unsigned long star=
t, unsigned long end,
>         }
>         kmsan_enter_runtime();
>         mapped =3D __vmap_pages_range_noflush(origin_start, origin_end, p=
rot,
> -                                           o_pages, page_shift);
> +                                           o_pages, page_shift, gfp_mask=
);
>         kmsan_leave_runtime();
>         if (mapped) {
>                 /* Undo the shadow mapping set up above. */
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5c1eacc2a0ac..4f3c320a4849 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -725,7 +725,8 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned =
long addr,
>   * may have contiguous chunks, as hinted by @shift.
>   */
>  static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned lo=
ng end,
> -               pgprot_t prot, struct page **pages, unsigned int shift)
> +               pgprot_t prot, struct page **pages, unsigned int shift,
> +               unsigned int *mapped_pages)
>  {
>         unsigned long start =3D addr;
>         pgd_t *pgd;
> @@ -748,6 +749,7 @@ static int vmap_pages_range_noflush_walk(unsigned lon=
g addr, unsigned long end,
>         if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>                 arch_sync_kernel_mappings(start, end);
>
> +       *mapped_pages =3D nr;
>         return err;
>  }
>
> @@ -758,18 +760,36 @@ static int vmap_pages_range_noflush_walk(unsigned l=
ong addr, unsigned long end,
>   * The caller is responsible for calling flush_cache_vmap() after this
>   * function returns successfully and before the addresses are accessed.
>   *
> + * On failure the PTEs installed by this call are torn down before
> + * returning, so a retry sees a clean range; PTEs that were already
> + * there when the walk failed are left alone. When @gfp_mask cannot
> + * block, the teardown skips cond_resched(), it may run in atomic
> + * context.
> + *
>   * This is an internal function only. Do not use outside mm/.
>   */
>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> -               pgprot_t prot, struct page **pages, unsigned int page_shi=
ft)
> +               pgprot_t prot, struct page **pages, unsigned int page_shi=
ft,
> +               gfp_t gfp_mask)
>  {
> +       int err;
> +       unsigned int mapped_pages =3D 0;
> +
>         if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>                 return -EINVAL;
>
>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
>                 page_shift =3D PAGE_SHIFT;
>
> -       return vmap_pages_range_noflush_walk(addr, end, prot, pages, page=
_shift);
> +       err =3D vmap_pages_range_noflush_walk(addr, end, prot, pages, pag=
e_shift,
> +                                           &mapped_pages);
> +
> +       /* Undo the PTEs installed before the failure. */
> +       if (err && mapped_pages)
> +               __vunmap_range_noflush(addr, addr + (mapped_pages * PAGE_=
SIZE),
> +                                      gfpflags_allow_blocking(gfp_mask))=
;
> +
> +       return err;
>  }
>
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> @@ -781,7 +801,8 @@ int vmap_pages_range_noflush(unsigned long addr, unsi=
gned long end,
>
>         if (ret)
>                 return ret;
> -       return __vmap_pages_range_noflush(addr, end, prot, pages, page_sh=
ift);
> +       return __vmap_pages_range_noflush(addr, end, prot, pages, page_sh=
ift,
> +                                         gfp_mask);
>  }
>
>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
> @@ -3715,7 +3736,7 @@ static int vmap_pages_range_batched(unsigned long a=
ddr, unsigned long end,
>                 pgprot_t prot, struct page **pages)
>  {
>         const unsigned int nr_pages =3D (end - addr) >> PAGE_SHIFT;
> -       unsigned int prev_shift =3D 0, batch_idx =3D 0;
> +       unsigned int prev_shift =3D 0, batch_idx =3D 0, nr_mapped;
>         unsigned long batch_start =3D addr, batch_end =3D addr;
>         int err;
>
> @@ -3734,7 +3755,8 @@ static int vmap_pages_range_batched(unsigned long a=
ddr, unsigned long end,
>
>                 if (shift !=3D prev_shift) {
>                         err =3D vmap_pages_range_noflush_walk(batch_start=
, batch_end,
> -                                       prot, pages + batch_idx, prev_shi=
ft);
> +                                       prot, pages + batch_idx, prev_shi=
ft,
> +                                       &nr_mapped);
>                         if (err)
>                                 goto out;
>                         prev_shift =3D shift;
> @@ -3756,7 +3778,7 @@ static int vmap_pages_range_batched(unsigned long a=
ddr, unsigned long end,
>         /* Remaining */
>         if (batch_start < end)
>                 err =3D vmap_pages_range_noflush_walk(batch_start, end, p=
rot,
> -                               pages + batch_idx, prev_shift);
> +                               pages + batch_idx, prev_shift, &nr_mapped=
);
>
>  out:
>         if (!err)

So, you are recording nr_mapped but not undoing
vmap_pages_range_batched() partial mappings yet. You do that in patch
#9. It's weird to fix one place but leave the other one until later. I
would suggest merging patches 7 and 9 to have a complete fix.

> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
> index 4ec114a75f04..9ea28845f713 100644
> --- a/mm/vmalloc.h
> +++ b/mm/vmalloc.h
> @@ -40,7 +40,8 @@ void clear_vm_uninitialized_flag(struct vm_struct *vm);
>
>  int __must_check __vmap_pages_range_noflush(unsigned long addr,
>                 unsigned long end, pgprot_t prot,
> -               struct page **pages, unsigned int page_shift);
> +               struct page **pages, unsigned int page_shift,
> +               gfp_t gfp_mask);
>
>  void vunmap_range_noflush(unsigned long start, unsigned long end);
>
> --
> 2.25.1
>

