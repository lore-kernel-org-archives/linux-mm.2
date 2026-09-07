Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2BC3C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E9CE6B008A; Mon,  7 Sep 2026 13:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A526B008C; Mon,  7 Sep 2026 13:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789306B0092; Mon,  7 Sep 2026 13:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9846B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:56:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC7531A01A8
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:56:28 +0000 (UTC)
X-FDA: 85187720856.01.668D64B
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id EEFDA1C0004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:56:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sJ+kHW30;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788803786;
	b=ccvF4ECebOM8sWzSd3tBMBXDAnZ1lW5mzOfnhOz7wrX43Bz9yCD/9WIbAAELu7FPJx5VWI
	N6thbC1EyMEARo0KiD24IWil2dHjFxRdbjPiE8GKxMgqaNLqDCEW1ycl8xGr1s7C5dVMYc
	BA9wJ1xkWtP/qv2OiDVNcudMdxJb9TE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sJ+kHW30;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788803786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/KPgRFuZ3mNSSPL8cJczIgbdA3OlCM2eaUn/vupPT4w=;
	b=4Wn6XgqgWYSGbm6zF47Enc1Scus+HzpJjsrwUGAYVv1cLeyZjtFdrutPl7QHEnhWJPD9Bi
	qxOuInjdOeXEhZWj2g3yuW+pWFm4bLEmo0Ij0VGUjQ1Kj1XrtdDMBTezMT58l7ukJVHqcS
	ae4v6BGjoXzt5LQNbkB76JXH+Vc+1kU=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1c52d920b8so468834166b.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 10:56:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788803785; cv=none;
        d=google.com; s=arc-20260327;
        b=Yqrbsvzt+PInnezDwybXfV03vqsCjXO2qN8znvEmDciZ6/6KUXypc7IvDzTpDVl+TV
         8Qnvcw0Iv/nYjZrc9Bzic8BB9/uYUgSPdUFIF/v+DfK8jlJCUWmqKl5Uket9BNI3twBe
         xXOzrsgxywQF+PxIpFlUff6o68hNSoHmKWiHoWshxrCYZJpgQpPr+SFf3+eInFqgmopB
         /R12qmjjmHmmoyKiUAHopP9zV06kSw8adE7J+HplSlvhZywquzM10UzS1N2/ItXwJpX6
         P+L0Xi4uvtBu6Cw+oc8j0QVPTsIYIUJnPBWHfVOy1y6/lezrbCBk8myGmvI0QLKFwj4+
         tdGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/KPgRFuZ3mNSSPL8cJczIgbdA3OlCM2eaUn/vupPT4w=;
        fh=gW5ivs51vbjATpS7fTtCbsRWfHNWurt1lFXO5nnQLVM=;
        b=VBVDIa8I36HtCcjv7AQdEHkwCO1FF+GO94dPIXJ6zFUxhRRxZjisfjhfAX/zitCMkN
         flxb3DhZPBL4sHagzufm2I0PnjWZxL+p2oo5eAatkf9KVrpXT/InM8OjFQP/7yJ5JRZN
         Pfd1KnvsD0Dku8Y2VtCRlpZHIs+QmnIaumqU/F2Oc64qu+34Ow6XWX5WR8xkaHOaXndr
         t/Bu0Fua+VmfhJlv6d69gDlkyvjYJi6G0cFsHuykVqzJPL7j9LjGOZkykiVWKaRr9+Wu
         KVjQOsKkXQpBGLVsxdcxduFoMb1QsCj1aUteEIZWuibigUBzSnVgB5YU1/9gm0Hvycv9
         V/og==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788803785; x=1789408585; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/KPgRFuZ3mNSSPL8cJczIgbdA3OlCM2eaUn/vupPT4w=;
        b=sJ+kHW30cbkikMNH3ms7bz5QE8K3tyCHeq643+swo2MPb2oUxsgsLgQKQHHxXr3tGd
         7Bmr+CVWRG5QY2JU7YIwZNGgwwaeBZsPpNC8RhN9a00O7TuMWPqp3OfwBBnRyrMy8zEY
         eUp1XbUSC0zEjYlzrVrLSy39fYt/fPy8LMX5c9cBaU8CJBMINrbUE0ueQ9q5L2oJoZId
         snxto5a7JD861CTEsk3XVjHUkMQnIShq3KGu0MPuBWTV1T6kmcZP5nniVo5geKMMBu9r
         l1ytdqkMlSEggSwVF8183y2wssRy1BFVJHmQNbm4hT0/KSmahCzIoDbEt+nTzDjKVLrF
         0ajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788803785; x=1789408585;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/KPgRFuZ3mNSSPL8cJczIgbdA3OlCM2eaUn/vupPT4w=;
        b=ZgXAUhfTTFqVAVxLj1s77xMrRYQOIxI0mB1oLTc+a1uoEKgQQunjJiYsdTExz/fn12
         8NvGF9pVazuk2ArvWvhxYFqRcTaZhOzn/WbL5aDGPa9hQErmW1eLZRXG5Kz+rnQY1G9b
         8yeYS5XDGb7FFMj95cbmr1Fs/OOAsfQ0Z4m2sZCLql9gQWmKmDVhfiokeC3aFxPph3eG
         NUyrOo7yhbeTdLnUiYUNAPD9gxS4g6np45Rsz2RfJdjFUd4ossXiWzUTuC8soP2p8lU3
         7R8CNQR5HfNQxMzzk/xp59nrFd0OzbRvZXQTP68LrYTjfJkNX2y81QIcI7ZKZBJvxMY2
         qp/Q==
X-Gm-Message-State: AFuF++mPkemaN2lnQzY/GXVgTOk2djB8GSdCw3xtPHtpGZI6kNJLWi3k
	UM4XziHhI+lIoKMSDRXdeJsiyU+m7xE5sVfozYBRt23RMDvndshq0vMZz3Ki6vCahuUwnxyLnBG
	XMZbCcJEUOoYfuY3tU6GgMZSzHO5tqVU=
X-Gm-Gg: AYBFou0uGiPOJMKx3yq8plN5xer7XGcon5WHv6u5wVI1mDw7RQHs7b6AKLnOZRSbR91
	XXY73OneFfnBLd/yZBhlrk5mS9rLkSPptLJqhkwnVArbEZj21LLkDLSBCtmIWPuXm57aMk8ek/l
	4WApCq7MA7BV08SgOK2wveLC/y/AmMLXY3D9RKWTZ4ZapRLYpE+72NenZiUR0Y0XJU9rpxoYroS
	/svu/XwhG+MUv/q73W9zVgoFICAxQ/LVvTw8+yAl5kl8DQ4JOPfGL1Xtzxa+eTWYV6Fw3qJTocW
	CEROUF0/XkTt94djedpyNu7vUuevV7CHri0QsfMd44adnCtPjIv1+TLFSQA4KdXPyrZ5iXkjk3j
	N4NMkNkP0lZkG
X-Received: by 2002:a17:907:7243:b0:c26:19de:9aec with SMTP id
 a640c23a62f3a-c2619dea86fmr702552866b.43.1788803785017; Mon, 07 Sep 2026
 10:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-9-9b43f5163238@tencent.com> <acdfa561-0690-4c78-bc50-92d308f4dca0@kernel.org>
 <apRHC9Hk9Ve1gO0o@KASONG-MC4> <6e85fde9-9314-4854-99fb-3582b13486fd@kernel.org>
In-Reply-To: <6e85fde9-9314-4854-99fb-3582b13486fd@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 8 Sep 2026 01:55:48 +0800
X-Gm-Features: AcwNN1XLFDfkd5CLWNE9FrQD_b7WIPlsnBT5hO0bC6nv4FVVuWbaObQoKl3tCII
Message-ID: <CAMgjq7AUeb0nrpt0A=EP1ZCX8SBeE5unYQ6LnhDz0BO8KiqaOg@mail.gmail.com>
Subject: Re: [PATCH v3 09/18] mm/huge_memory: move anon_vma and filemap
 management into split helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EEFDA1C0004
X-Stat-Signature: pchdpx6grkm743xurcoumy7kh4ue4i4r
X-Rspam-User: 
X-HE-Tag: 1788803786-680482
X-HE-Meta: U2FsdGVkX18i8TcNZRNb4P3y4Dftey6qjCI9KAxSZfrfq38a7G4dzIbo2omZ7oAXR1+hdZ/4WVCFNbPbYOt/gU1vdsT288b+RRq+6slSuUAoliXJncqe3uJpq1McXVWN/L5jWXrMQwR48qNQ4rxo9fUILwmrYeNB6rx5dki03nGouJ6/YCGl/3sWMwdUyetZxkb8XmiOZpW/fWQTBbik9QGue1c+vOmtJYJmX2GALrJ/m43oCmZ5AZw5JtGHRxHd2gVZHGXqqXsGa7qmKiKLT2zqmwruig0xV8rFDJ8smQQptxaZm7LzDdgHJIOxF20SinhXVa0a0diy4oMOJ20ZRFgdoMeTyrdZ6uFBiFwG7xBj+RgJF30y3Y0FKbwyNuopthJOJdFkgG8CqCQFssKCyLh3P/whmbMCvWptBWaG5NU6FSsI3okws25csvgVnUutlV72Jc3QwsGUlyyB4iR4RuSP0hvw/2Y0GDPQGV24q3JvOYrlLnyEFRoQrHMbm6OJMJ0DPuAqt/x76YdFN6EBvuQBAWxVLe+zEZXPOFl5m1fyspfK9DrsZ+vltGrr2rZtiGmfzfsvRWDjIi/Y4sB0tIfBvKPBBEYiKhdWCpjxsoXcAQPefTmIfAcvspA6BPJsTUmTLkL6XSMyUMaw37bO32o2JxQyqGijfVNlicr/bzeN/BuOWMfnth2IW2PlRJOlbDN34eFzF9MFu4MrJLFzDmdIpUk2tJanQHuufy88Jb0ZB5zg3CczSlPyRotWOwPGaqmezxZzN/N/jX/m0//ur+A8ro1j186nbJDYozfJxAclQQzjXTctxUUHf5C2lyaCtULn30Uj2wd7Z1SzHysek9NM+VL26CA9ywgqSzjggYfj8ybmHw4QmpgI3GiP3hgvUU8BFh1Rlppj7lGrxZ8Q0bWSLyQzeoDbp3b9vq3J9eOWV5qWMhBHIQdq0jpKX9U5P9XPT4qQw1aLu1vimmX
 iUwTfu3m
 9aamUfXgVWO2z1N9q9itiv9p3Xni+rKa3HwLTh5Zy8BFkfMfcNtwkU1MsKcn/3TVluqCNnTjZImrnJs9Tcpz1PJH7F9OCnWbyJW8eT7YgyDV20t5rjfXHR++DGyr4MANraJQBUUEV8eQJQ8vZ4hDHhqCzvs32affVsjAVOwjLT11p1EJI6vCRQgEqycKYzEqCbrAbDY3mLB9i+gnLQg2FhZxbw3RO7g/4d6H1d27v9kpivOvAmVMhhASRReALFjSEkiXFdD3947LJ0Ok+3i5NGyvZujWr22fxV2DU6o4xKD0irCH9ZcMUxpN7rUjPWsteJpzx+y66HyySy1rHPTJeNJuEUUMXA/CiTCIrAaCCy7vvc5t2rWdHjTom+Vy/7ng1DJ3Kl/P9Vjbl4dqotvA4OmZHTtUdrjziwgBX1YApFAeTvW2tVDMdacK757kSNPAYuXs59cmqayBF0KfN0Z1wCvs3Z5OTuJ4LM+rOpPHoIHAmW7M14KMB9w4W1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 8:36=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 8/30/26 17:23, Kairui Song wrote:
> > On Thu, Aug 27, 2026 at 06:36:18PM +0800, David Hildenbrand (Arm) wrote=
:
> >> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> Only anon split needs vma info, and only file split needs the filemap
> >>> handling. Move the related code into separate helpers so they are
> >>> genuinely more self-contained.
> >>
> >> This patch seems to do more than that, like relocating the
> >> folio_expected_ref_count check (and duplicating it, which is not so ni=
ce).
> >
> > We can keep it where it is right now, but this patch is moving the
> > anon_vma_lock_write and i_mmap_lock_read into the two anon / file
> > helpers seperately, so keeping the folio_expected_ref_count check
> > outside and before the helper call will cause a potential higher
> > false positive / negative rate of this check? Leads to unnecessary
> > call to unmap_folio.
> >
> > How about moving the folio_expected_ref_count check into
> > unmap_folio since the purpose of the ref check is to avoid
> > unnecessary unmap? No more duplication that way.
>
> I think the crucial part (for anon folios) is to also check after we unma=
pped.
>
> See __folio_migrate_mapping(), where we don't do the !folio_ref_freeze() =
in case
> we tun into the !mapping scenario.

If I understand you correctly, I think we are fine as is? The
folio_expected_ref_count() check here is just a racy check to avoid
the PMD split for a folio that cannot be split anyway, not a gate.

The gate is the folio_ref_freeze() immediately after unmap_folio() in
__folio_freeze_split_anon() (only a local_irq_disable() in between).
For an unmapped anon folio folio_expected_ref_count() is uses
folio_swapcache_ref_count(). It might be worth optimizing, but that
could be done later.

Or did you mean something else for the anon case?

I think I can send a v4, the patch should look cleaner after removing
the swap cache behavior change part. A few commits changed a bit, so
it might be worth some attention. Thanks for the review on V3.

