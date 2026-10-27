Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53CB606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jbvjWfW8
Received: by kanga.kvack.org (Postfix)
	id B58DC6B08FE; Tue, 27 Oct 2026 17:51:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08F96B08FF; Tue, 27 Oct 2026 17:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7376B0900; Tue, 27 Oct 2026 17:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77A826B08FE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:51:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6304A120B66
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:51:32 +0000 (UTC)
X-FDA: 85369753224.30.1159314
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9634C40003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:51:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jbvjWfW8;
	spf=pass (imf17.hostedemail.com: domain of 34RzhagYKCPwoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=34RzhagYKCPwoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793137890;
	b=RoJMs/N+l98nqucm0g/zz+DiTGod4juCnnvWRkoxsLhAf3DcIlNQVJlO7bk3aLub6dayC+
	3rBuwtKE6SbewiC3YBNP4O3Bcx6ZFdT8s0W6F9gATFMA93fdeVEYoCLMJv829dUC1g/9wS
	Yr6xqFsO9dVHr0uZj3L1P2Q4cCepph4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jbvjWfW8;
	spf=pass (imf17.hostedemail.com: domain of 34RzhagYKCPwoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=34RzhagYKCPwoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793137890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQ1LM8ogBkRpQQvgUr178MX4xpVMn2H7cOKcQ5l+MrA=;
	b=zyoWc81asvKL1Xeu/CPhIc08JvAM/FvJXEzz5J8B5bZYyDUGtwGRnp0ezvHFBrktD4HSxg
	GZhiar94+8AadV097L1B1ARJ1VG7LkApjFFSk8ORv7FwNKgTbOxxmsME+4R62iPLRewoGP
	qzV7K92+gTtKxDPB3FAzN8dQ+S1O09g=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e8ad8c5f80so3554335ad.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793137889; x=1793742689; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pQ1LM8ogBkRpQQvgUr178MX4xpVMn2H7cOKcQ5l+MrA=;
        b=jbvjWfW8ZPTAcGZ3B3+tjBIV2WEiA8C2aNKr47CaYv3UxJdG62wNdDulh80+NX6ry0
         u1iiX0BaGUEhZHVStudnJv8oieUcg1QxsM1jZ/JLDz55Ih3PxpXqo8Vko49vcJv6bs4V
         /nzI1ea2V3op1HxU2MTbHBtAZdSNJnU/WMvrMsBpApS6WqguYN9vlmL/H9fFCTYEZE97
         lSPwI2zupskp5Ei8pUBCE+Z+BMiCPAC44JU+dt3gt6z7mTuMRslDLyHN3yqEgqTqT6SM
         yszO2oIo8HMmUfQ0gT9P/6V97xvQR+6ZSa5oFvleyA/vycT162VWvaBKwOrBB1+f7Ihs
         Kz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793137889; x=1793742689;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pQ1LM8ogBkRpQQvgUr178MX4xpVMn2H7cOKcQ5l+MrA=;
        b=zdvPVuf/QxqANWs0/+VCaakBsAaDLQZtqfVSnp5uSVtYLjIJD8y9/ljkQASjM5I4Gx
         daIfVK/v5qm/4pFG9335UuRjsyls7cpU/rSr0ipRdcqgNollfq2UC43TaixByH06jpXM
         gZd++Osgp9iS87CVics6plP1DGBRFaJF4hebqcgzUpQuKljDn33mKzznm6SNaSWrsxWp
         bYAjrjLkJx9MfZNLycdVfJRXhKh4SxPDj0wDhEGEBA87Z8empGEVdJEK1DtrQrop+ah3
         i/v8VbtsKN77XepV2rgwsKtY9tkWkrtcAFQsS925me1zsy2DAjQiUtOUdBeK6p5Eoqnc
         AYDw==
X-Forwarded-Encrypted: i=1; AKwUvBxJHVNHv4+khr0HZogH/IGcyCFdy9ZRA4mFOy6scwolMy5RZ6No/+mDJFT69gum3Fridj/Ct9f+2Q==@kvack.org
X-Gm-Message-State: AFq9FYLkgeTO4v35VLdh1sYB3g3A6dnSjWlcuESCQyOeH6dknVut1lYD
	Ek/KMz6jqFEUIwOTOxo1j7qCsJN5s1FGYeH35ldAUoh2qehWCLH/fvItXr5X9JMJFd3K4Fce8R9
	6cy2h9w==
X-Received: from plld11.prod.google.com ([2002:a17:902:728b:b0:2e9:5b68:4b7d])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:94d:b0:2e9:4b9f:b81f
 with SMTP id d9443c01a7336-2eb003cdd41mr6036045ad.31.1793137889165; Tue, 27
 Oct 2026 14:51:29 -0700 (PDT)
Date: Tue, 27 Oct 2026 21:51:28 +0000
In-Reply-To: <CAG_fn=U=Rf8y49JGYjJ4qT96=MwD5v6SLwVqeiOhR+Z7R2ZKRw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261009214639.2878857-1-kuniyu@google.com> <20261009214639.2878857-2-kuniyu@google.com>
 <CAG_fn=U=Rf8y49JGYjJ4qT96=MwD5v6SLwVqeiOhR+Z7R2ZKRw@mail.gmail.com>
Message-ID: <auEcseqdxGGelMM3@google.com>
Subject: Re: [PATCH 1/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9634C40003
X-Stat-Signature: zjjsnwbqwuj8spokjkys7f7s59xmpw9r
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793137890-410655
X-HE-Meta: U2FsdGVkX19CXYgzvOR3GdJQ6PwOdIqI/ksB1JmCDC5aJqFm36Xqrk2EYa9V3ITNfSbka6F666xvQ9Tv1N71ameeiwq2r3f4gbbZppXevUfAJn5LeyB5GzLEBxp/iKPpSgPBTSGMs0wF0XixSHOj11NmQA+KFngVYsLs1CwowEJq3OFgv6tswwfnKFKW7k5QZaam4U0WZ7ciEgK6jM1e4hyehY/hVAblu6D0xydn8T7PE99wg2ytKWWyQKjcd8KbEJ/mvELlMkygY8KvZhCQ+ayTLi/d9+6LPsAbtl1D7HHq6R56K4LwBU7xGTC/CANoERxASaHhhYWmWsVlv6qlZRySXoC4xrqQpdF1z+jMh78/o1zD2cK+IPxMxLY7UdjkUBfYHUgxAQdfWwmds3bzznr8gzwZ0ySjsLnb8TaUF/vg4czeb5HOoeab0YlTIrGB3xJfI49dTKelB+bFRBgtj3gwzZ7kfhSRuFOxlFxsj2RVFRn3Vy6lrv8XzDbM+4EZhIVg9f8J8QRJqks88Uw716aUMmtbYK85ugNntEXN9WB0Y5E5gFwBkGs9RFREbDw4G9k6owakDWZKVirIkkyrFMhvknFK+s7ktR6Y1tc6RaPuY6gz6Yfw99yPglQxo2wn7Quh5RU+uwh6xhmVfkOk8MHoVro0LwuYDwesgAmXvIe3A+rcZM0HUwPzY1VgB+V8xhm46fyaKGrilTsbyjh5a6XpVvCEhVCEi69XwELs+PpGzA+8Dmioj4BkakP/JiRnX4Hmd655IdDY1PiE07Fft9u7fpppCxVQU8UwKS7Biz9jcgM1ngjVh+azDYnaJYnQ5WyVfH+53+22DlDyjPXeWCtDtUztqKWGHJ7fdEfFU3458gPb0RV474ZRjIfGoLe1kkGKTPufwwvfWyCbXq7TltifAfaLNd10Z7j0y+hej2Fdoksb7KxgtXLWaR1GsJr1DX4eQvMecaA/isPhIO8
 uHgKry8Q
 jxWjpuPLrskUxI7GYJl/LWCNp+qapkrLNgFFC7wwOJwwId/6dmyHGcJSs3MjGuj9Egkb+I9xgNO2DNdCLHr7+XyBIw9/NmAuPsO3nLNcioPCWfjHg3jolcXCO6sbsdc5QfuM3Q0jabXPZKn1w9FHWCCn/yXDRre8511Z/LLvaBpvGQ2IeDXt0Kn2qwhATACWRqs6HL+o/JqTIZSDyKHDJBWnyJx8OE07sE5NzfSSlbnxvr0WMuVDOC2J44N1kWv/LWmWSxhgShEh3FlbvBrHfc9HNZVy3hnP2vrFb9ukMcUA/JYU5FhKyzc6xYTwKHcCVBPPGvaI4HJZIakSf1Fr1GVnNzGqUEXqBO9GhrtFsWhHJROrjsGVFM5yuZ/8XULvYmy4i1yyvR8lIWz948yNYzKTCWpbNgJS9OSwQlOSW2hB+SqqRzgaH92Fl6O6SNCQxce5IKgHdrhr/iKSAn/G6ESLK6w7lrYdqYLOYKTmQ3NZzPomDOXwBmGbG42m71JgxNv3EnMnmRzp1Zo5OGaogsbBWlATH/Vs4f6IrnsjjPYlUQ75JG14V2hXeps9UTpCntClVsj2V1SLDyk2T4wY/jxixp2Har1hj4ABBpW8wzqnBCvwf7lZAZvOb9b70fEciNDWa/hCdfMcWGaYh3Y9k7jgy80kbg3QUTCSu2HlNMDHZl/JU8Cbl/NuKfVxKXDLWXq1fGpneIr95rzt37MQXDS0BLLl9ZbfoM9oN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 13:48:03 +0100, Alexander Potapenko wrote:
> On Fri, Oct 9, 2026 at 11:46=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.=
com> wrote:
>=20
> > The bit is marked along with recording the stack trace when
> > deferring slab frees in kfree_rcu_sheaf() and checked in
> > check_slab_allocation() so that any double-free pattern above
> > can be detected immediately.
> >
> > Link: https://lore.kernel.org/all/6ac959ee.70ed5d86.2ac85.007d.GAE@goog=
le.com/ #[0]
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Tested-by: Alexander Potapenko <glider@google.com>
>=20
> Do we need a Fixes: tag?

Will add

Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() oper=
ations")

>=20
>=20
>=20
>=20
> >   */
> >  static __always_inline bool kasan_slab_pre_free(struct kmem_cache *s,
> > -                                               void *object)
> > +                                               void *object,
> > +                                               bool after_rcu_delay)
>=20
> Please update the doc comment as well.

Will do.


>=20
>=20
> >         poison_slab_object(slab->slab_cache, ptr, false);
> > diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> > index 2b8e73f5f6a7..07636ffe1626 100644
> > --- a/mm/kasan/generic.c
> > +++ b/mm/kasan/generic.c
> > @@ -536,7 +536,7 @@ size_t kasan_metadata_size(struct kmem_cache *cache=
, bool in_object)
> >   * This function avoids dynamic memory allocations and thus can be cal=
led from
> >   * contexts that do not allow allocating memory.
> >   */
>=20
> Please update the comment for this function.

Will do.


>=20
>=20
> > +void kasan_record_aux_stack(void *addr)
> > +{
> > +       __kasan_record_aux_stack(addr, false);
> > +}
> > +
>=20
> I think there's an important distinction between
> kasan_record_aux_stack() and kasan_record_aux_stack_rcu(): namely, it
> affects how this object is handled later.
> Let's somehow reflect this in a comment ("records the aux stack and
> arms the check") and perhaps rename it to something like
> kasan_mark_rcu_free_pending()?

Sure, will rename to it and add comments.


>=20
> Otherwise the series looks good, I'll be happy to stamp it once you
> fix the comments.
>=20

Thank you !

