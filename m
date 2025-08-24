Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01254CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 06:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9856B00A5; Sun, 24 Aug 2025 02:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AAE6B00A6; Sun, 24 Aug 2025 02:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A1D6B00A7; Sun, 24 Aug 2025 02:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 846FC6B00A5
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 02:45:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D19A31DE348
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 06:45:20 +0000 (UTC)
X-FDA: 83810714400.20.8E1D02B
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id D820CA0005
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 06:45:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Bvgr/7BO";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756017919; a=rsa-sha256;
	cv=none;
	b=fclFt/SRYHJPZOUoBTriw166+GtRVD6NlRGmsW/7CpfY5azkPExapyzAprN//c8ZCnt0hi
	f9Qst5O3CnpM3MnLmvWasdGB8GnM9Y0Vm90nu8YfDb5uF1sVhRVMTrYoikLwl2PEXkjDgs
	KmQ0TdzTK26GJpaetN4ArmVc6cIjz6k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Bvgr/7BO";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756017919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHPGeya9AYVT2dtG8NYVwirW5wGAQIjffRF28CeDOJ0=;
	b=xAGJ+lXXjAro/A/zPE3viRakAmVShzmwuHU8lYjUpkrZcmDxlHPQmdr4WlGyJrLMnyA059
	585fnU89nLEdhlApxbHSwGxqu03iQM76ctHLEifp/zl7ilf+GF+FEWGbRMD4/vGXUxexZi
	ArtMP6RtTdr/SAABrQABZcaPvZTGFM8=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-618076f9545so5042a12.1
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 23:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756017917; x=1756622717; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IHPGeya9AYVT2dtG8NYVwirW5wGAQIjffRF28CeDOJ0=;
        b=Bvgr/7BOY/fqvt7PtBcrcmvoTMUvndBHZbrDIWlQEMDZLQCn2ys3q1YYw7aHo9a6vF
         eFulFL+6z4IuVvpzaV8dq8NuWJXR+JFRx8cGGmlsdGe9OsiJwPcSAM6VElCODrsjftGI
         7kY5sTEMYUbl6Fk9mA4Tx8ak3fUV5Zze+5qbax4sBmXc8naHisvir+X2sNuC/pLwkX2n
         6EJKvpEc1Ldb26j1HUodLhwYlqPu6cqqf6Y8h62S/pTLo8lRaZRR5ob/kjJtUrmYftVt
         XfLvZzZdeNKkgswy2be5dZ0KgZkGCdHs4Bv0r4OTJJC0jWH9BjhK75Mn2ZDaiJS5FH/3
         nBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756017917; x=1756622717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IHPGeya9AYVT2dtG8NYVwirW5wGAQIjffRF28CeDOJ0=;
        b=NjLP0n0vzV/dthOwntZfXvp55I+5KIDBoMlysObq1FNUSjAF+bUjo7yFtcYTqjO6ul
         B6v5JBdCnQSG9xPUnTUHByuiCkCrf7it3LQTI377ZLa5U+5ez6B2N5qnmGCrYNXviRHv
         J1LDhxFG6UcySzpX5WLLXQm6TQXUj93mkZniqYZ+t2XOOx+/868WERAwdXTBqi9V9cLo
         gteBeehpaMBtcosKFStZGXn1zrP0uBrrEoZvSSRlVPJeDwfuuB+e6dDIgmuIVjvlm55V
         oHA7V3o5EPIDCxa/E4OgODsjNxVUQGYbCy2mBTgpxiqpc+vsZUvHNM1OVbLKqhwyrlov
         gOWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMIiBLDhtk99FiG6W1TD5uBUsap8ZLTUehVfqNeqX2IrXEA+PTaGue68s+Urq00JNS1lWnBg2xsQ==@kvack.org
X-Gm-Message-State: AOJu0YxitHDa35CGOF/fBgKezhfE9kiif8oiynDbThAMgnfSEF46ui2A
	8twnoNlTAQkA72q8mvvLmMaSBnlJaDcLiN0tvA8kJH7pWSzy4tJRLH8DW4Pt0YhSfxB89w7zJre
	XxumdOLTWbIi4oXkurV3uJBJx+fjFoPeVA5ampRxT
X-Gm-Gg: ASbGncuGmb276g3qEqxpFaQdETAeK1uJsLLbbgsCLmNrxjnvngKWWYkbGyMRT8PZHB8
	oSXPfHNcrPLwPySu1ftw4Mn4RpairAR4WOv5yRWhdLZeWO7MKsGKHi5A97bdP9IcQ0FSCJmsfcM
	8u0RD9e9NbIOrVKUB11PGi7MQT6GiNZ+y5GvJRDs8g7onU+letSZwtIQQjNe0Jgv+MPejFj2Pym
	zvtiJzy+JQ7X76RQf3dYZv9KhvQKd4tYoLk2VBKRvGQOFM=
X-Google-Smtp-Source: AGHT+IGZlZyU1kr5NXFGP7MaqKFLiWA6g6rEs5ntJymCQzs9YJFCKhJG40wdBtKxd587lL8fhh/XGyjRZX28d1LbXus=
X-Received: by 2002:a05:6402:27d4:b0:61a:c827:f84 with SMTP id
 4fb4d7f45d1cf-61c38db9c28mr64351a12.7.1756017916943; Sat, 23 Aug 2025
 23:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <CA+EESO7j4dY3KjBWybTG6uQmXJ8kyhBrid3rTk5XAP7poZOhYQ@mail.gmail.com> <aKqjWqn8lrITKI7P@hyeyoo>
In-Reply-To: <aKqjWqn8lrITKI7P@hyeyoo>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Sat, 23 Aug 2025 23:45:03 -0700
X-Gm-Features: Ac12FXwBQFPzIWu-CuhS4k4sD34BSAjJ_EWFH1stI-Mt6FmgMU5PRf6X-yr3Jdc
Message-ID: <CA+EESO6PFJ9A0kbRWd-ARBLmQ9pwNOF=GBuAzMCOyFvps4euGA@mail.gmail.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Barry Song <21cnbao@gmail.com>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D820CA0005
X-Stat-Signature: pnj5mmzktpe6ppswzuk989yxpxrh8kdn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756017918-258611
X-HE-Meta: U2FsdGVkX1+/Ok87/WKosHdbC5jgxXeKLwIOZcyoJY0pS2+YwMo+PUjJzQDMZN3PqyabqhUuGdE7tNhRs7PSMl68f3IQW0ZsaLEI5vitaGUFArd3R1nUnw8Qx0Shzmg1CFwLNutJ+aFVXeHpeBdWcAKSFBV1aOqaiqjJOpf/YD0lHeJobGJqo7MfxcjAVwrJDEMQFHyR38TW/RJkpFw0PPnh3JlLHjW0x6ZZnVIjS5S7reoXcjOB2yYZliDDf4vIFeGCFdrAMO7riKi1lr3tZq47uAgnIeZ71XSnmaPo/5lJxJEFW0PGcO5jBDAw/2TxcfVbCRzkhvJx0lWRsYKC0RoQ1N5OGvtQG8TraliXOAS6lCgGmhTQRbd4yV/bypZC+/rJjwTasxalKY4+W8WxkXy4Pr9R1LEmiMLUo7pSrGuYoQZxRrmsD6cm3W8Bg10jmfpVwBsLdkVkUzSUTL4PaD1NA78fYSFBNLCn0NP5EquPPpq5fNvLU0TbEbq5dg0DtwPSkFy6KLp9KmjAl12kqyqpg0Ourz56PTGbaxc8FM81HRxzfoN/iKjbMTE1OwbqbjTDEx3yLcaUOImbhSOXTNinajTUXXBzfUWq4jaGexvJw05fAvLiWeMi9gthRBMliixThB1yHYknHB1fwn7w+hjwOZJZQSbCauqdeNXwPUixMNti+mC5Yb2T+3Ue1loqXro1Id6lCWXjc8cPiIHy4q8dK49xUmLvUeGQ+n76JM13aGOOnYu+VCgHYqxDfGR1kuv3Ph9xEt/DIKAvlgBY1MfPB46GxusD1CF0OKFGYfOeXvV8hqgHJfyzSSEP9Ry05aFQqxT2uc4242fz18Jz3y3EAYlatyN/5Lf6hGkwekhHQ0lGmtb7Rsa2qeKehX3hmpk0iIvWsKJf9bVqpUptiKBXKcDxUDBbokud4ZgAzGbQNN5e3Fmh6tjC4Q9j8OT5eqSQ8eabp7M2nmAqiCp
 HWgiKBo7
 0X+nLi35qDllww64IWCpSMruzOD9Vzd1gxFjS30JkpwEeqFS5MfJkpBS+Qfm8ATGItWne3WB2ivzhdwWo3nqESVpkDkgCDmzL53UXsVKU76G0Rj95Am6y4dK1HGjVSmyCVnLjKJLAmMjFSwH9f1lujoqrOFLUTxaRPVcVFmGVBLf0WRrEahMxNQRqXbGcYUqSYtz5eNOKDeh/lvgO2MTvunqVZPvftE4fPtUu+LrQ43SddSo1PTcTFHw0407tA9d9E9ZNLiEdgh9rQ/nivWwyXnkCLZHeSNQByBDUllCfA/weV7NyP4PiJo4v3EgRYyzrBq1F3eqI+PXZu64=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 10:31=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> w=
rote:
>
> On Sat, Aug 23, 2025 at 09:18:11PM -0700, Lokesh Gidra wrote:
> > On Fri, Aug 22, 2025 at 10:29=E2=80=AFAM Lokesh Gidra <lokeshgidra@goog=
le.com> wrote:
> > >
> > > Hi all,
> > >
> > > Currently, some callers of rmap_walk() conditionally avoid try-lockin=
g
> > > non-ksm anon folios. This necessitates serialization through anon_vma
> > > write-lock elsewhere when folio->mapping and/or folio->index (fields
> > > involved in rmap_walk()) are to be updated. This hurts scalability du=
e
> > > to coarse granularity of the lock. For instance, when multiple thread=
s
> > > invoke userfaultfd=E2=80=99s MOVE ioctl simultaneously to move distin=
ct pages
> > > from the same src VMA, they all contend for the corresponding
> > > anon_vma=E2=80=99s lock. Field traces for arm64 android devices revea=
l over
> > > 30ms of uninterruptible sleep in the main UI thread, leading to janky
> > > user interactions.
> > >
> > > Among all rmap_walk() callers that don=E2=80=99t lock anon folios,
> > > folio_referenced() is the most critical (others are
> > > page_idle_clear_pte_refs(), damon_folio_young(), and
> > > damon_folio_mkold()). The relevant code in folio_referenced() is:
> > >
> > > if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio)))=
 {
> > >         we_locked =3D folio_trylock(folio);
> > >         if (!we_locked)
> > >                 return 1;
> > > }
> > >
> > > It=E2=80=99s unclear why locking anon_vma exclusively (when updating
> > > folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> > > with folio locked. It=E2=80=99s in the reclaim path, so should not be=
 a
> > > critical path that necessitates some special treatment, unless I=E2=
=80=99m
> > > missing something.
> > >
> > > Therefore, I propose simplifying the locking mechanism by ensuring th=
e
> > > folio is locked before calling rmap_walk(). This helps avoid locking
> > > anon_vma when updating folio->mapping, which, for instance, will help
> > > eliminate the uninterruptible sleep observed in the field traces
> > > mentioned earlier. Furthermore, it enables us to simplify the code in
> > > folio_lock_anon_vma_read() by removing the re-check to ensure that th=
e
> > > field hasn=E2=80=99t changed under us.
> > Hi Harry,
> >
> > Your comment [1] in the other thread was quite useful and also needed
> > to be responded to. So bringing it here for continuing discussion.
>
> Hi Lokesh,
>
> Here I'm quoting my previous comment for discussion. I should have done i=
t
> earlier but you know, it was Friday night in Korea :)

No problem at all. :)
>
> My previous comment was:
>   Simply acquiring the folio lock instead of anon_vma lock isn't enough
>   1) because the kernel can't stablize anon_vma without anon_vma lock
>   (an anon_vma cannot be freed while someone's holding anon_vma lock,
>   see anon_vma_free()).
>
>   2) without anon_vma lock the kernel can't reliably unmap folios because
>   they can be mapped to other processes (by fork()) while the kernel is
>   iterating list of VMAs that can possibly map the folio. fork() doens't
>   and shouldn't acquire folio lock.
>
>   3) Holding anon_vma lock also prevents anon_vma_chains from
>      being freed while holding the lock.
>
>   [Are there more things to worry about that I missed?
>    Please add them if so]
>
>   Any idea to relax locking requirements while addressing these
>   requirements?
>
>   If some users don't care about missing some PTE A bits due to race
>   against fork() (perhaps folio_referenced()?), a crazy idea might be to
>   RCU-protect anon_vma_chains (but then we need to check if the VMA is
>   still alive) and use refcount to stablize anon_vmas?
>
> > It seems from your comment that you misunderstood my proposal. I am
> > not suggesting replacing anon_vma lock with folio lock during rmap
> > walk. Clearly, it is essential for all the reasons that you
> > enumerated. My proposal is to lock anon folios during rmap_walk(),
> > like file and KSM folios.
>
> Still not sure if I follow your proposal. Let's clarify a little bit.
>
> As anon_vma lock is reader-writer semaphore, maybe you're saying
> 1) readers should acquire both folio lock and anon_vma lock, and
>
> > This helps in improving scalability (and also simplifying code in
> > folio_lock_anon_vma_read()) as then we can serialize on folio lock
> > instead of anon_vma lock when moving the folio to a different root
> > anon_vma in folio_move_anon_rmap() [2].
>
> 2) some of existing writers (e.g., move_pages_pte() in mm/userfaultfd.c)
>    simply update folio->index and folio->mapping, and they should be able
>    to run in parallel if they're not updating the same folio,
>    by taking folio lock and avoiding anon_vma lock?

Yes, that's exactly what I am hoping to achieve.
>
> I see a comment in move_pages_pte():
> /*
>  * folio_referenced walks the anon_vma chain
>  * without the folio lock. Serialize against it with
>  * the anon_vma lock, the folio lock is not enough.
>  */
>
> > [1] https://lore.kernel.org/all/aKhIL3OguViS9myH@hyeyoo
> > [2] https://lore.kernel.org/all/e5d41fbe-a91b-9491-7b93-733f67e75a54@re=
dhat.com
> > > > > Thanks,
> > > Lokesh
>
> --
> Cheers,
> Harry / Hyeonggon

