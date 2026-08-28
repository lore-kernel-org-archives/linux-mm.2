Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F5DC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64ED6B0088; Fri, 28 Aug 2026 05:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C3E6B008A; Fri, 28 Aug 2026 05:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B166B008C; Fri, 28 Aug 2026 05:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4A56B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:56:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3FDA80286
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:56:11 +0000 (UTC)
X-FDA: 85150222542.14.E11200A
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11ADBC0004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:56:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L915cXzy;
	spf=pass (imf28.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787910970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXhc6GUfnqTLNzw9wGDoz+Flj8b1JzYpQruHE4OUFPI=;
	b=nW1MB7UBx+iwQZocKC8MJPlJC2HiJ5NC5BjmnsD66ESsQSwFZuMAhokDM0hsbFWCCEfKWu
	T8dYhhDiJcNyKByL27ItsY6IyQ0Q7sF7zxgpZA4mcFEdMFbiyhUmnuEfP6uN0mov6A59XI
	4PMOaW+G/bLfFoE8zrXyTZzHYpc0b7s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787910970;
	b=R1H3SvQ7fL50GjzRyG3PLcbn2AgN6/ha526qOeupAGqDy4vGwvthZnDQgAPwBYgyIaLvHc
	7f0jSAZ065KOSFBhtL73Zw20rxFGipTxPY4JIbkLJi+0hAXTL3Q5/2cjv+6uxufjCOTwWq
	dm55bQy1yt2P2oEiX4aS21/acSTnLlE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L915cXzy;
	spf=pass (imf28.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso6724665e9.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:56:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787910968; cv=none;
        d=google.com; s=arc-20260327;
        b=Yw2BwXhTxHCMM2+drUArKiIlqrL8PTQGClaC0IBd1oy81Qifh6aT9kGKXAXkkKovAk
         rTzRAQGAlHmJjX7ZxJeNz9CGc51rjbnDkXLhgukuDISK/FbB4NblfEilHH1P7Kgq4qzU
         JPTDbXX6gFEI8OnxdHiM/rLjjUkPA63UNE0ZFbfv6XqVj0L//YXDTzHhDe2UCUrEzgJI
         /jNNXzqMB6J5AI30CVwyhS1oYTl2IqeESaeZb8q5NSWWI59My50BYDrDxeFZhxvZ4Bib
         wubMEOMBcYB8TVNHl6fXZ2kbiFzSoXF3r9OPVQCIoE3ZbozvGUD1cPXpICxwh0O0cnXp
         CvXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lXhc6GUfnqTLNzw9wGDoz+Flj8b1JzYpQruHE4OUFPI=;
        fh=ilhBVCTvOILbpzQXNffsD/HW7DPYj9FUUUam8KUhsVw=;
        b=ZgIKlI8gbHldWkn2XfF2gahzJlTWmJZllbj7WSn66pmtI6B61Xl/1VPtkbwP0NpOti
         ofXE+pYy3IZ689OTWudxN+rsmyY8Nok40AmTmwH9R3WLrrngc1VlyHJT+jWYntOv2Vbo
         1mPwV5MctHBEeh82FRJV4tnwgeYGBTirRC4Ch3R6L4+DTobos7xPpmpXy/TaLVa1jEcL
         UWBerobkRak+oATWroAmQ6QM9dwV+/A3Qqiqp38wzYOj5WxedhDwtfiyz0M9ewGgq8LN
         /4zTOzf7dsi4LCfpCQyhst0Kx7+EDLOdbQld1a19eLVTPeNphBr0yemfmHj6/TtmPNuF
         72oQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787910968; x=1788515768; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lXhc6GUfnqTLNzw9wGDoz+Flj8b1JzYpQruHE4OUFPI=;
        b=L915cXzyYOJ+hbP+J/QJstgb3L12ri2ugkbymuORqTq9MWgIERBe6fQWIWf3Gli+Ry
         Q8c6kFy3Auf5eMT/td45lEPeB9+pC1l+i4sqpIXYjPAgfRE633XmXrPXyX9cqFxJ/9pX
         vXu3E+g7kH1gAtUjUt5hi5R1TC3aOMEYEywPUojd2gYcbLo8Q5SNdOAOX+YEizuatdng
         QZtfP3D35yQrpdUm0M2PjWye7qQW8WPGBYNiKSv5HNerKh/2HnUxUD3r6J2eTG2GtHI3
         9fs9GwvqVedEM7KGhhJJe4dcE5ZZc02ab0QVj6LZX7KEn0VOSgswZHF3X39zI63k+dqC
         Mmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787910968; x=1788515768;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lXhc6GUfnqTLNzw9wGDoz+Flj8b1JzYpQruHE4OUFPI=;
        b=FRyj95iQWoWfkfGSzvRyWMbGO0gZrNBppHk+PJUUIVkk0RRUreVfknC82wnN528lxG
         Sxh5I61lemQ3NCBficKVvH3pIomLiKKPq5vWMhxiC1vXryj2+txbIx8AcuES9+LlgrGY
         bbtVc5CZ+t1isqmc9hjKQACYhNrirwzDixGu/IwdHX8OIvWnGQTX+w7lRwDvuTV29OxW
         LFs6IUkHK9I4+xXaelh/KK8uDWvOiekftnj3zmeabckSJT/akwk1a/OA9S5qmRq6yfEO
         FxX05V5ODBMx91zaZB7vaqGDJvE/R3io7gxoWDWXW6fsDFKTji1v72HJkzKrBCA9VL/S
         rp8Q==
X-Forwarded-Encrypted: i=1; AHgh+RrwK3c7RsOnn12UQrXQDstGtJM9roFPrBtAEoY+Sc6As++kdPBIThzDMkoonqtboKPlpp+9ePJBxg==@kvack.org
X-Gm-Message-State: AFuF++mSswAZnS/+nXkekjtxNhP4+5lKCPpeQ0CmtZ4SzDhgRZGZO7R6
	rrDbG+mizDtPqqhhm66DrnC7/VKcrC2CRSouzc50hD+rC6lzfd7RFb2kqW69PRly9oa2oGtIeL9
	wym4kKwcW8iTZn1295zTmlGFpbroQKno=
X-Gm-Gg: AR+sD11YTqvfQAJoVFSpr0C56OcVPws93FOIQcGpIF7hhC0MKatzCyqfLKOpUe01zHS
	3QM5Xsqw88gofZjkfiNC+GZakhRkSiRScqOhXEUWA/6tKxn+0MNR6jELALvzrJ5LCpVp5yxJNca
	eKh4eD1B1r9k+xMz3hpTx2pzVtGLojcNTELjMR/bl9vKPlQLVTzyxNHXmEIXujYNfKG0NILjg6j
	eXp7J2WVFZIy7156j7BjO/TX0jvaGEO4zIoPEYEVBOnR+si2qosEk41WSlUfVbmRtrt2KoEjiyd
	E4IGeCinh1oo1waFWFRT46ti0CScLkV8pNIz+VvclCC5+kWfnkpOWy5RzhtaG9Yz0wD+b3frVYE
	QaQ==
X-Received: by 2002:a05:600c:4443:b0:499:b3f0:ff05 with SMTP id
 5b1f17b1804b1-49b91c56f41mr63926635e9.13.1787910967695; Fri, 28 Aug 2026
 02:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
 <20260826151520.202465-1-kunwu.chan@linux.dev> <ao8F2ZO2GGvxIgcQ@gremlin>
In-Reply-To: <ao8F2ZO2GGvxIgcQ@gremlin>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 28 Aug 2026 17:55:55 +0800
X-Gm-Features: AcwNN1XLLuUW5ug1ksrH3NHF46jSKOiwPOPgx_Pcen4_qbW40l2Xxpb-yeltmF0
Message-ID: <CAN_Opa_mAyku745gobtT39mM--KKqCkw9kvfU2Oq0c_k+RV9uQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Li Xinhai <lixinhai.lxh@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+f12658786a4153df5113@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 11ADBC0004
X-Stat-Signature: 7sf5xdm9x7s3cnqf7agcbz8srrz5936s
X-HE-Tag: 1787910969-390706
X-HE-Meta: U2FsdGVkX1+2Wi30DyZmRN3dlFw3CVO0Gcw/NHGzPnNxTSh8koeTqdaNtIpe522rl5QrF32cRU2M+So1A7pVvLAt4zSN7c1Ln4suBHb2xyEMtVGo5w2g8rMzoz0F8txQ1S2AqnyyOkWoLDQWUP3Lse1iUObdP3Nk2TN5pWNQVwsCzhOYEeSLvB4PHXbyTzXxKye8R5v2EmHKUCL8VvkNkyraHdI+dq+bjkrus6M2PbG+qfnuluc2hD7fPJKohf3JroS4Yq+nxgWPWBOeErqUSrrKxM2qlKv/bGPi3mzhFVAQaA+zy8Vz82sxLksZNSlEvFNCLIs20uNfStDDkGbo1rjdjwYYp34G2VNILPffhJ1T8d1hPk2U+MyPtHw9bG0uUZqzwwVoBaMbOTA7hHHbq83WB2XT02/E4jn61XRays8rPxDxuQU8HI5XIZMUaMcV9THMY3L971uQbhlddMurXtkBWYlrWAgBi8C2zE9UHJKREiOitOb5bHCQy9ltlVirErfVLNZO481wOoYy3O4aczaKhY0l6BNpl9odLZi9RI2ggpiPwjqoLc87PJ/advpTPnxk4ID2hwwWbQX7ZMJb92OrYlwkb5sVQHQ1XOCpyc/50TkjZN6/gEYQman5CkQnoCZCkCBA4KWFAfXxYsF6rjfvYDhds6xgGDZs7wLNZwbJlQ0+mOwg4Bcc0/LItYG4mTjPZtA0U8XS5VjG97GAVB4HULYfYi9trJm7P8RFIHQNa9tErvOFT8Yijl53V72G8PbHFDTuqyezBBVY7P6VEhmyh0uVQidwacyUQPRjqnBX/sU1uX+f3HIvSvFfjBv8KaREObiGtsLdehqmUB1y3uYnHlKW0l/7uXBXEhSFzb1b+gSPr9Nt26hBOELpsLXXiOm8wkv0Ld1CHJE/g8xYwGYFU1KN33WF97lXKjqAn+nkYDkHVI6KVgV4ZKOMRqr6gHFs0b34WkdhCl/uul7
 qwgt5DYv
 JX1QQq0nPLn9jTN5sbt2E7o5WWdjJ4I0hROklS+zxXTq60dZABET5dmOI7q8qc+GyAHgkn7x3gptg0lJyKQU+396Xdf+ioMTVsGbOGpedpCTPtNO6kfgTxx6Ex4SEU6D8kpBsguMq7QFmDcxMf+jCCYatrTtgLMzINWdjDs6m9/+s+3QLsKTmEQwuOaYQrait9r6BkTjzCMudxZTG9i6jQE+dD9PHWkVW5U9V4PnQSgOJm9pbqWuKuWDfib6vVUe8eXxF0fiMtSf7P9/odPBNFq/XEFpiKf6NrvOY9sN/9wSn1/u5xMgq3jqauT7KrACbaz9dutRm+PiS21e1FegNkqLCeiqi012oMCHrqa2d6yoNOmvFIv34BX6ebwvf+hrXcFoFlIPCAsu3xYL0fZQdDuZB/RF+ekcQwLwYkd3vEBYSbvJAiR5bPrHbYSykkKx7flP81TPsI66Pd/YHLFRjqVTqnRfcsq+SU83TJLXQ1CWtgqkDTnxDuhWScz/Fp1DZgroIKftzFVlmJCioPb1ExnmnIfr/MRn05IDHagLJ0iBnCsIhVJiaRKQv5p4vraD6+3tnGvy2lRWrBpzUAReqAVMVicySGNE9DG/Q4fCnf/m+3KLG7iPMYK2GARnhVXni7Lw8CEGo/kgxwi0iELcN0pzWU0vqd8qGCF1qS7ona9c+zpNk62mXLhRWFNtu92/CPHXuUOIg3tcWjJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 11:28=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Wed, Aug 26, 2026 at 11:15:18PM +0800, Kunwu Chan wrote:
> > On Tue, 25 Aug 2026 08:55:26 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.=
org> wrote:
> >
> > > Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can r=
eset
> > > a faulted VMA into an unfaulted one.
> > >
> > > It does so after the page tables have been moved to the copied VMA wi=
th
> > > MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfa=
ulted
> > > as the page tables it had are no longer present.
> > >
> > > However, in doing so, it violates the invariant that the anonymous pa=
ge
> > > offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.
> > >
> > > This is because a VMA may have been faulted in, mremap()'d (causing a=
 delta
> > > between its page offset and vma->vm_start >> PAGE_SHIFT), and then
> > > mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.
> > >
> > > This condition is a violation of a fundamental assumption in mm, but =
now
> > > also triggers an assert in assert_sane_pgoff() which explicitly check=
s for
> > > this condition.
> > >
> > > Correct it by resetting the VMA's page offset at the point of complet=
ing
> > > the MREMAP_DONTUNMAP operation.
> > >
> > > Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
> > > Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE=
@google.com/
> > > Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with M=
REMAP_DONTUNMAP success")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > >  mm/mremap.c | 22 +++++++++++++++++-----
> > >  1 file changed, 17 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/mm/mremap.c b/mm/mremap.c
> > > index e8df5cdb0ac9..2b4b523a86b8 100644
> > > --- a/mm/mremap.c
> > > +++ b/mm/mremap.c
> > > @@ -1331,18 +1331,30 @@ static void dontunmap_complete(struct vma_rem=
ap_struct *vrm,
> > >  {
> > >     unsigned long start =3D vrm->addr;
> > >     unsigned long end =3D vrm->addr + vrm->old_len;
> > > -   unsigned long old_start =3D vrm->vma->vm_start;
> > > -   unsigned long old_end =3D vrm->vma->vm_end;
> > > +   struct vm_area_struct *vma =3D vrm->vma;
> > > +   unsigned long old_start =3D vma->vm_start;
> > > +   unsigned long old_end =3D vma->vm_end;
> > >
> > >     /* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
> > > -   vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
> > > +   vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
> > >
> > >     /*
> > >      * anon_vma links of the old vma is no longer needed after its pa=
ge
> > >      * table has been moved.
> > >      */
> > > -   if (new_vma !=3D vrm->vma && start =3D=3D old_start && end =3D=3D=
 old_end)
> > > -           unlink_anon_vmas(vrm->vma);
> > > +   if (new_vma !=3D vma && start =3D=3D old_start && end =3D=3D old_=
end) {
> > > +           const pgoff_t pgoff_unfaulted =3D vma->vm_start >> PAGE_S=
HIFT;
> > > +
> > > +           unlink_anon_vmas(vma);
> > > +           /*
> > > +            * The VMA is now unfaulted and it is an invariant that
> > > +            * unfaulted anonymous VMAs have page offset equal to
> > > +            * vma->vm_start >> PAGE_SHIFT.
> > > +            */
> > > +           vma_set_anon_pgoff(vma, pgoff_unfaulted);
> > > +           if (vma_is_anonymous(vma) && !vma->vm_file)
> > > +                   vma_set_pgoff(vma, pgoff_unfaulted);
> >
> >
> > Hi Lorenzo,
> >
> > I think the fix makes sense. One thing I wanted to make sure
> > I understand correctly is the distinction between anon_pgoff
> > and vm_pgoff here.
> > Is the intention that anon_pgoff should be reset when the
> > VMA becomes unfaulted, while vm_pgoff should only be reset
> > for a truly anonymous VMA, since it may retain file-offset
> > semantics for VMAs with a vm_file?
>
> Yes.
>
> This is to account for both MAP_PRIVATE file-backed and pure anon. But to
> keep everything consistent (+ simple) we always update anon pgoff for
> everything.
>
Thanks, Lorenzo. That makes sense.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

> >
> > Thanks,
> > KunWu
> >
> > > +   }
> > >
> > >     /* Because we won't unmap we don't need to touch locked_vm. */
> > >  }
> > >
> > > ---
> > > base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
> > > change-id: 20260824-fix-mremap-dontunmap-pgoff-a687134e995e
> > >
> > > Best regards,
> > > --
> > > Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > >
> > >
> >
>
> --
> Cheers, Lorenzo

