Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A83FC5904
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A65F6B0088; Thu, 26 Feb 2026 02:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0781F6B0089; Thu, 26 Feb 2026 02:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9106B008A; Thu, 26 Feb 2026 02:01:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6F446B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:01:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 667EF8CA03
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:24 +0000 (UTC)
X-FDA: 84485711688.15.898858D
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5F7461A000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VirvJ93y;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6lBogwJ3mVDAbt42E7wKK1U8C1lmC6fA754zzsVMhg=;
	b=x3ldbIMK76HJ3AN8jxJN9LeVdUlEKmq0gHwnp4W3I+H8DlO7IfnlG+MsI/e64oOEaWEjli
	jj1z8MiN7Hbp1L9SVXdj6XkCogq7xwKK3P/aCjyor+4qKxLhFyPQXv1XlJ5QDAjATGOQ2J
	6TCBEvG5r0RjG/fJf2eju2dhAe1VFuQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VirvJ93y;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772089282; a=rsa-sha256;
	cv=pass;
	b=2saI1vj5GsFiglQ84yTVRT1HfOv0EncadewhDqGlLkC72yKtss0CeAtCcVSG2V9BLkt6oH
	EE1FMpoBbAWAcEBS4cVLbtJXN+t2W0iVRXGDh6NmSkEkBAxob6rr7zT1Tev+RKJ4T/rSgy
	ItMvrx8URBw/3bnOBPTN96K8cN0Wjqc=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-899cbb1bea0so561736d6.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:01:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772089281; cv=none;
        d=google.com; s=arc-20240605;
        b=lZczx39YVVWFMLKgMiQ88TpKLE1J8ZPMP/aIsmXDr9ja5wgS6iE4fekTygJUZROqRt
         B8+rJSfqS0yH93fSxZJ0j2XWVN6pNx1JO0ghCWLlFeQM3Ebs91DgHU8KoD3190sluGhG
         yDX1mGTUpekd4PskoePPO+FEHt1VzfGjIM6dC49NW+GuHvqLXWpL7MhMi+w6f5kY0FBJ
         0WEenVZTelQmJKDVnlSfMzAQP+jFf1GrtoVdftUjZ7uyNZr6jDCsSDWih15dZ+D0e2gq
         yF++t1fWy0u9VUsveqyEKLKymSIxlCrkGKVa+oyO3Un3DwjyieEPggaFLT0SAH3Ynjhe
         G26w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v6lBogwJ3mVDAbt42E7wKK1U8C1lmC6fA754zzsVMhg=;
        fh=ZtwBbgMLntBuRlUZZVYno500ZJ3T0ExZXl0vuQzRTao=;
        b=gvkMBTKFUHaLXDPQRZ9/qGBsksJAPiezncTo+dxpn5M+yJurV4yawfndM4+s0L0llC
         JjBjYAIUW3yDHrKl54ptbgcVIzuB3cjVUN3FjYMUsVwWLGDkmK8druXvDD5gomcYnliO
         kkRODnNSA3VEwhBNZF326E2Dkq765YB28ojx+ZnlMQMyrVwepMKG49VGg67F7Cdm08hp
         MIZkfuqS6sFYyjScAiGWdmNifi9zJMCgCBJ6DBhvCmZFNAvE6BMpz6arvo60gYgBucHl
         ypZsvKjCdTcojIszFH+EYzlndykDYrG0oUlsrSIepf9zny4dqhiIweQXAyRCggRfSvj8
         l/Sg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772089281; x=1772694081; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6lBogwJ3mVDAbt42E7wKK1U8C1lmC6fA754zzsVMhg=;
        b=VirvJ93yj8KzjyqqZRrIxZXnduPq7htvZ7JGdgo3qZ5h6c1zCLIbhCiv1SkPOJrrl6
         7IVxoMauHfInGtHAAtmN8VY3ZPEHB503d9pUU4CxO7vnwg9IS3ekxGwM+/mDyfuXyGdJ
         +FnFmWNDo6qsrxlp7a+Q/oTqhG49y3mvy23EiiCzp/0JH7Z+LtikfEE4GU5JLFdqDYYc
         VXq3stVM3AbRqn3i76vcPyOBDc6EFpmE7fScD9dikmkNIq1MiWrBhXD577XP/zNQPp/Y
         dqX3qFqvo5c0bkL3F3JfnV9u0KLXl04DMCd5S75aCYKiso2Corfbx0zHM17NZFs4BIqD
         rh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089281; x=1772694081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v6lBogwJ3mVDAbt42E7wKK1U8C1lmC6fA754zzsVMhg=;
        b=wFrJHoufpT5fd1xL/F4O4j127QnSuoDjxQMGV8nCXT9kaY8MhqT9emFR4W7Lf+u+Ln
         eBJ/ZRwBERn8OgEAzM3ZiPcVqG+pnCTrPncxSPq7A8IO3+8+buV8cJqc0R+6utC5Zf21
         RX4L3dAXxNgYQwlwbVIOJpxSyUgjB1sjppunykpexlNdqXcBbj98r5rnlBu9CPMIEUvl
         54zQtjyhjqIsw2hH9IqVFwV9M82TBLRcE+L9OaKtNZl6sbPWTkwiFKhVHltjq+24kQlZ
         Vud6Rlrz8JufcUqoP6JRYDiHMkRukOQYIRR99KZP2FzTt6vxPsV4cYiCBXS7X6dyChv2
         bUvA==
X-Forwarded-Encrypted: i=1; AJvYcCXVno3XsZrsdvEixKw8gGMA1ArUxDP80Q8vAeiWZE5D5viumb/pUtXypLh0aklM00vehnmu4yG9Aw==@kvack.org
X-Gm-Message-State: AOJu0YwxDdNamxJl9Oa5IqUEByv8laeASDWT4WGR0AjoPPRTJfiAth2T
	f3kJH2F1hF2gIRUp7LbTji6KQwFOxgJEVKCO8AGR7sI1h57GOBxvFxMLSzkBuSUHvG3NhwH7Z97
	Vc9t/LV3DJZP/AZe74D6OoGH4IadaliY=
X-Gm-Gg: ATEYQzxuWTFWtokJ4Ld6dYkXapBqa2SNCZEnAOIn2zhgeusZGueqivcx/2cibGVMtEs
	GUkZM0+v7ACeSbDbwzdUeyxU3UjbhwbnTOlWoJuL0/s+SZSiVCxCgDUFPpdWvhc/c6sV/aBkEOW
	H4GJAT0iihDpNP7pbZtx1LfTe0qJ1kPvvhsAQFYVTXpt4LELvOc4/eWDrClThwWDnhmvoJg9Y4P
	jFu8dbB/jidxOcorOmZ+4VJJ98bH96MSbYkLN1NUXjyilSugU0or5bPvxfZ+ix0deembrK8YDDW
	E5P73w==
X-Received: by 2002:a05:6214:27c4:b0:896:f50e:b6c1 with SMTP id
 6a1803df08f44-89979f3473fmr261336216d6.51.1772089280997; Wed, 25 Feb 2026
 23:01:20 -0800 (PST)
MIME-Version: 1.0
References: <20260224110934.881360-1-dev.jain@arm.com> <763ffcc5-8640-4b48-8ace-051ff0ccbdaf@lucifer.local>
 <61161337-0d0b-4597-aad6-b5a1aa1ad41f@lucifer.local> <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
In-Reply-To: <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 26 Feb 2026 15:01:09 +0800
X-Gm-Features: AaiRm50bDmB5Hm6WPrghAw-r-boCkHSTkEVu9-vkNOmpt21TJHXgINxavkgrTtU
Message-ID: <CAGsJ_4x=n9BPHN9Eg9KYY40T68wWuNJUN1x8dokJqFXSKu3KyQ@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>, 
	akpm@linux-foundation.org, riel@surriel.com, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, harry.yoo@oracle.com, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable <stable@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F7461A000E
X-Stat-Signature: baaojzketsyc4mm5tbubwiktbkdu6o8h
X-Rspam-User: 
X-HE-Tag: 1772089282-888787
X-HE-Meta: U2FsdGVkX18s0XXKNsLVbuLbZ4zmjaNEj/BqWTX6xegGA/AvprowVZ2rDUMh1nk1zDTDl5q4XTkoM7aPQqOUH6Wz6xgp7lr4hsFFVvxCUOpt/uyX6WNwxAhroJ+SQuUpvuEi+MTV9Sqiic0ngIrJ06txZwthNZ9SX+IT5zrITACCWY4hJBa/TDuV1nRabwF/gnS+K2yAcWoN6o0ZoHBUIaLTB293qgu1BhFUKzcwaUg19LHHBdTupJ9nDKnDt7YgZEJOq8SVaHT5yrahCI7d9FpJr3zQ2NunJoAD5nUdoyQnwjFKEZsEguWMr2my7RHbTloj+fr+rsY+fP/CTShFj7DPJZJ4qeP21+CnF3foC0LgC4ejCSCj0jgU4ySIez/GG2UxoOYCHOMT1JeHylpA+cIRcg3GEP9aDCUCPlMezY7tI75VWQTFpb8zjDMuOpxh6nXl/pN9P1Ytyszf/M0sguu4yh+4OeW+5vr3tGbWCWQxfM9oL6FzTbAJtiPirMvaPpbAK7kCu5H/iR0SNnYrEA+fwn7WgYwJYlzYcbRAvEyCrInfatOV3rtqancTTaLO1XvPMISdIrxRnOUDtMm5qniJdHv+PPS9b8flujmWTBNc/B0qzPNBeXWOvoECjjcrM2Pyxg8ltaSSnMngofyF1MDulm/85eHq2l4iGMEXT7+HVY2A4ydfXexnwlZJpB04kGlLiIYW6YItxenQow2LHSgmMo3JFYHtOYpZLWtNLbd2kVlUrw4vhhL/pxolNO5hUn6nWdZaIckvBEJsEXS2cVMr3i7tJwr3Kzunt91uEp5YW/lx2sV5TOM0+fgrF9ycfA55yvhHXLAhKiqaM6AZnsAkjULAqTJka9UHCldYYc9uenHsCGlhmXK48NH0xnSYOJTnmnfksdiNmjj3yHcEUg64JR5+BfOnQA+yjrkxtG6sgQCtPCakmqcvIcGHEgnbT1c5Sg7tlHkHCDpwfb2
 bo6MqPk3
 N25xtgUij5GlFyz2e4yhckIZowCMfVtbRXFWk4UFsoWL+6AwzyO1kOQ2K8ByVszLGnjQzyh8eEFl7VOv0Crten4xStuHATo0LIHBP4ciy4xLpP4A5QgPKwdySiFAFCM9S1eB9OY28yoSOK+ncfO3Y+wuPBmxSMsrbKX19Z5DF4rh9uojFPaCwikxye3+DDQYqXSLKwU5DG46TO3V5MfbU5FTeH2e8bcXqKMGRw54hjcPjiKyUa+k41cdxt6eKwibxQXKYAOX4LCIDtALQHl/y6QGl80xfbWpu2FsPQUVKLd3zXNFyKJciHF3tSDMiolfl+cuAIUj81PgKiZXEl1Hu9Sw8xU/Cx/aGpRzzggvpheroKeZtKX3UZUnnCriefNPbjX8ARlghMgvv7kXaqv0gMn4m3K2cDPtBSPLWb8LdwaRhKjgH2sLUrwpdMUfetZw4jiRg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 12:01=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/24/26 12:43, Lorenzo Stoakes wrote:
> > On Tue, Feb 24, 2026 at 11:31:24AM +0000, Lorenzo Stoakes wrote:
> >> Thanks Dev.
> >>
> >> Andrew - why was commit 354dffd29575 ("mm: support batched unmap for l=
azyfree
> >> large folios during reclamation") merged?
> >>
> >> It had enormous amounts of review commentary at
> >> https://lore.kernel.org/all/146b4cb1-aa1e-4519-9e03-f98cfb1135d2@redha=
t.com/ and
> >> no tags, this should be a signal to wait for a respin _at least_, and =
really if
> >> late in cycle suggests it should wait a cycle.
> >>
> >> I've said going forward I'm going to check THP series for tags and if =
not
> >> present NAK if they hit mm-stable, I guess I'll extend that to rmap al=
so.
> >
> > Sorry I misread the original mail rushing through this is old... so thi=
s is less
> > pressing than I thought (for some reason I thought it was merged last c=
ycle...!)
> > but it's a good example of how stuff can go unnoticed for a while.
> >
> > In that case maybe a revert is a bit much and we just want the simplest=
 possible
> > fix for backporting.

Apologies for the mess I caused, and thanks to Dev for catching this bug.

>
> Dev volunteered to un-messify some of the stuff here. In particular, to
> extend batching to all cases, not just some hand-selected ones.
>
> Support for file folios is on the way.
>
> >
> > But is the proposed 'just assume wrprotect' sensible? David?
>
> In general, I think so. If PTEs were writable, they certainly have
> PAE set. The write-fault handler can fully recover from that (as PAE is
> set). If it's ever a performance problem (doubt), we can revisit.
>
> I'm wondering whether we should just perform the wrprotect earlier:
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 0f00570d1b9e..19b875ee3fad 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2150,6 +2150,16 @@ static bool try_to_unmap_one(struct folio *folio, =
struct vm_area_struct *vma,
>
>                         /* Nuke the page table entry. */
>                         pteval =3D get_and_clear_ptes(mm, address, pvmw.p=
te, nr_pages);
> +
> +                       /*
> +                        * Our batch might include writable and read-only
> +                        * PTEs. When we have to restore the mapping, jus=
t
> +                        * assume read-only to not accidentally upgrade
> +                        * write permissions for PTEs that must not be
> +                        * writable.
> +                        */
> +                       pteval =3D pte_wrprotect(pteval);
> +
>                         /*
>                          * We clear the PTE but do not flush so potential=
ly
>                          * a remote CPU could still be writing to the fol=
io
>
>
> Given that nobody asks for writability (pte_write()) later.
>
> Or does someone care?
>
> Staring at set_tlb_ubc_flush_pending()->pte_accessible() I am
> not 100% sure. Could pte_wrprotect() turn a PTE inaccessible on some
> architecture (write-only)? I don't think so.
>
>
> We have the following options:
>
> 1) pte_wrprotect(): fake that all was read-only.
>
> Either we do it like Dev suggests, or we do it as above early.
>
> The downside is that any code that might later want to know "was
> this possibly writable" would get that information. Well, it wouldn't
> get that information reliably *today* already (and that sounds a bit shak=
y).
>
> 2) Tell batching logic to honor pte_write()
>
> Sounds suboptimal for some cases that really don't care in the future.

I'm still curious what the downside would be to applying the
simple fix instead of introducing more "hacks". As I assume,
cases where a folio has both writable and non-writable PTEs
are not common?

diff --git a/mm/rmap.c b/mm/rmap.c
index bff8f222004e..48ad3435593a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1955,7 +1955,7 @@ static inline unsigned int
folio_unmap_pte_batch(struct folio *folio,
        if (userfaultfd_wp(vma))
                return 1;

-       return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
+       return folio_pte_batch_flags(folio, NULL, pvmw->pte, &pte,
max_nr, FPB_RESPECT_WRITE);
 }

>
> 3) Tell batching logic to tell us if any pte was writable: FPB_MERGE_WRIT=
E
>
> ... then we know for sure whether any PTE was writable and we could
>
> (a) Pass it as we did before around to all checks, like pte_accessible().
>
> (b) Have an explicit restore PTE where we play save.
>
>
> I raised to Dev in private that softdirty handling is also shaky, as we
> batch over that. Meaning that we could lose or gain softdirty PTE bits in
> a batch.
>
> For lazyfree and file folios it doesn't really matter I guess. But it wil=
l
> matter once we unlock it for all anon folios.
>
>
> 1) sounds simplest, 3) sounds cleanest long-term.

Thanks
Barry

