Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79D0CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 22:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E926F6B0005; Mon, 25 May 2026 18:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A456B008A; Mon, 25 May 2026 18:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57EE6B008C; Mon, 25 May 2026 18:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7CC16B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:13:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56C7E1401F0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:13:51 +0000 (UTC)
X-FDA: 84807345462.24.6222DF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6B69340002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:13:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+h5hI7J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779747229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enswyy3cuDgTYlPYByzJYx1OEKhfB6YFJXEwGFHgR3k=;
	b=dFulYuT9RLumOAqrGsH127Om/wKJWsDOE1cFOLiMm6Oi/oj8GHymLUZm5EHo0boAXfaLdg
	JTxdrT+LKqvICgXjthB/nuxzKuoCG8reGu9Rm8zlMiT5lCT1sVZpnPrx45r2bUpGtp7Ffe
	r8W02ZR7wEsdUZeVec9hyZT5YyZAN1I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+h5hI7J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779747229; a=rsa-sha256;
	cv=none;
	b=Ra3ExAK83cZOoWrLk9J8NFc6PuxX3xhzeeshLyy69X1TimIwGfQGmtpYnJtuF9WlTkUnzg
	Uis8Be6Lf0tJJuKY/CbZwhyTSh1Zktz88FqpMB3AScWy5JJxFhZPZGXsmUCobzH5rFB+rw
	+dy94CFplvgw+OduvMmAT0EiGOs1AJc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C344442AF
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCEE1F000E9
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779747228;
	bh=enswyy3cuDgTYlPYByzJYx1OEKhfB6YFJXEwGFHgR3k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i+h5hI7JX+xxA4fQZysyMI2o+q3hwRK2W7KWcSGu6j7Vz7e/mnU7eSj5KlPTqcTD+
	 tmTyvSkqy5UsQz6GMQGKPfCu0ubnBQzIwzS4DwDDmNG3pwtn3Cu+BHRb17RpR09+Sj
	 kpYxXC7E9SysToNmE5I2nmLJeqZQI5/VF48WOi5N610slQ0ldo9qn+YZW9Bj06YJx1
	 hZud41d1pA5JuoaoJ5nI3JvlsqL3QYteLI8fKjrHxZWydLkD0FisIW53VcJgu36fve
	 e0xjFsPEY5ppRqFbqia4WBRGqNhlOVmAnwJ8eb9qwBwj9JKcjOCSbK9pA7AuCEeOKX
	 jYjCisy6YaHWw==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9102e90bcbeso1045521485a.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 15:13:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ83i1X9QOvO2X3Y5pK3o4i+0xhzJvWAPu9TQKaVkXUpmn8NAj8ruo9XXFieiforP557eqbxbTzv2A==@kvack.org
X-Gm-Message-State: AOJu0YxTASx2eTizBzZcohWMDOvavzc1cQPmd0olYbG2Fa2DHqJRaKyk
	E26fwl6xABwdGICIDOUXfNcBPHiZwbkNE8J7X4hkNHlE6VmRkbzHgWo4PK6EijxgtSz2xFymoxa
	ZXAUMRmxOt22heMZh+6a2rsRGW3O8B4k=
X-Received: by 2002:a05:620a:7018:b0:914:e3dd:17e8 with SMTP id
 af79cd13be357-914e3dd2a21mr677247385a.8.1779747227722; Mon, 25 May 2026
 15:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260525123205.51874-1-baohua@kernel.org> <CAMgjq7CZt+EFoVqSti93QpKUNJ4VySxm5TAOgkMmpkS+73QyZA@mail.gmail.com>
In-Reply-To: <CAMgjq7CZt+EFoVqSti93QpKUNJ4VySxm5TAOgkMmpkS+73QyZA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 26 May 2026 06:13:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xqGHHvudmmdqgHfn7L7MehVZDZynjOG_JSUdLEp3pXqA@mail.gmail.com>
X-Gm-Features: AVHnY4Lby6-oCEXS9uzaR6Ir6tiyGbowknNdtS0PJau1UkWWflLcSrp063LqjOA
Message-ID: <CAGsJ_4xqGHHvudmmdqgHfn7L7MehVZDZynjOG_JSUdLEp3pXqA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: use folio_mark_accessed to replace folio_set_active
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Pedro Falcato <pfalcato@suse.de>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	wangzicheng <wangzicheng@honor.com>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, Matthew Wilcox <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, 
	Kalesh Singh <kaleshsingh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hx46emtq8yguuogy9xe7xksidxbyzuxr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6B69340002
X-Rspam-User: 
X-HE-Tag: 1779747229-973391
X-HE-Meta: U2FsdGVkX1/+4rZ1p5OZ9IXMa/5Q3KrWbvVqipvOmu4WV3LJuQhFEV4jJ3cADE0mxNcQtJg34UjzX85ZvqQ9T20K7bIRPhp2zN8LZ3EjCjDPB/9WBe0Aqw6uBzl8tOuNnoIspFIgaTmjaFOBcN4/x6mH97YpjQGSR50HlOQbQkf8Vvtl+DXqigD4rwV/4bHQYKNdfq8D7zn1TKIiTURAwxLUBCpRIPZAY39qzTA0tVJqfQml2xe3Vf3+kJCCVck6sg7HANVZbjKXblaiLMy/ZXbmY+QsX/ZpT7ZTEj76YI0qDa0e284TmKvTSCxdKm7EC3k86T5myekj3v8NrJrj5NUheciA2a3sDSjYJBIqGRNck8c1AwzgRiYrHBRSrN7ThWavi6KnIdNNWcxM22PQya7+zhLzA0zQ6AV/1sNhHeMdak88OZdZK6mvXTbB+/YRGB1wRIQCi+RBg07MsDXY1eop+GmvO0nY66C1mdHSH0Q4pVOPRjmSklQ7BsEOrf5hm/M8M+ospFIh2YRBCL96m0L5AIx9O1B0YmWlmCqQW/ng5FOehzPpZa3TnMzyhhfS7jLa3E5ZvlLTkIOWLSdHR3pl2RM6yqBNtTt4kFAIxqDRbKmt12/2g/4ab0PleEGChbuxeYKZyBUSZ86ci5Y4+ianqf2s0EU6MISFw54twj7p39xMHZ3zAUxmVRecqVIZBfGqx6DtbFyX0BPjQooPIL/fdNlGjwUrsaAGZnVQKDH0RP1hMNftMeKDnfUmpplXtL/u4PF2rdfAf7JELa+kbal7OflzdavwjQO4SRQzP7Ob2vkguvP92vzwDFKPuWPTGXwyyvHPNGC9PDYXOBv4RzjXarJ+uZ9Qw0FRTbDZ9oRoQbvQPlfwk39j5YVQmDOkbEdNeEJF4j9FYC0Ds459DDmRNerp3/CsEyyqZspSgoP2YboC3sfKMLRjX4aNUxSVisq5Z2aaFqu/gm0Toz+
 VDRhtHES
 e8fqwDSavrC7ZEoCSWfe4NHgRQvXfvHmjC4hIhpL/tGf8ixv4x50gzIXNNkqCt2eSGcIxYXpIlc2TwNK4i8lFJCmlxBjcNgn9rxYAw2cy+laCcMJI0/o3fFyu1XVQ2UDdhggITVySrospJkQGKRBiLRCbzriqE5J72qCU5z3YAmvU3n96lj/cbc23sOAnjG4jXV3yjAKCENBwCgi+YjDeZ+e/NtPwzsaNdM4luutjHKDRZMRnWhUKHypyOJ+4bdc1443/d8SPshebDWr6NeTK9WUS8e1zZc/qkjPXnmzMpCOI2F6VuwIYDZwnnbDQHrTb6XB0hQm11kukqmuV8hOAIB839GzhdGuP3/qGeGqlhOiGYCAQ2cb4q7OJCpgpKlDZc3+PKE9fQ0HtyQQGY5B5ajnvv30PSmefmeu0KQByOyCr7vmMJepedOIodAHBARt2Iqh6/uik2yPEkeWptdvI0KVKonuGcA8Yp6AhYatIIeRBmxFCvPVFGLcTbfbwBbFnRWFMW2f0RCVz/eCQnifJ7A+R2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 1:58=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, May 25, 2026 at 8:32=E2=80=AFPM Barry Song (Xiaomi) <baohua@kerne=
l.org> wrote:
> >
> > MGLRU gives high priority to folios mapped in page tables. As a result,
> > folio_set_active() is invoked for all folios read during page faults. I=
n
> > practice, however, readahead can bring in many folios that are never
> > accessed via page tables.
> >
> > A previous attempt by Lei Liu proposed introducing a separate LRU for
> > readahead[1] to make readahead pages easier to reclaim, but that approa=
ch
> > is likely over-engineered.
> >
> > Before commit 4d5d14a01e2c ("mm/mglru: rework workingset protection"),
> > folios with PG_active were always placed in the youngest generation,
> > leading to over-protection and increased refaults. After that commit,
> > PG_active folios are placed in the second youngest generation, which is
> > still too optimistic given the presence of readahead. In contrast, the
> > classic active/inactive scheme is more conservative.
> >
> > This patch switches to using folio_mark_accessed(). If
> > folio_check_references() later detects referenced PTEs, the folio
> > will be promoted based on the reference flag set by
> > folio_mark_accessed(). We should also adjust
> > WORKINGSET_ACTIVATE and lru_gen_folio_seq(); for example, we should
> > not unconditionally protect anon folios accordingly.
> >
> > The following uses a simple model to demonstrate why the current code i=
s
> > not ideal. It runs fio-3.42 in a memcg, reading a file in a strided
> > pattern=E2=80=944KB every 64KB=E2=80=94to simulate prefaulted pages tha=
t may not be
> > accessed.
>
> Thanks so much for the update! This looks much better than V1 RFC.
>
> > Without the patch, we observed 12883855 file refaults and a very low
> > bandwidth of 58.5 MiB/s, because prefaulted but unused pages occupy hot
> > positions, continuously pushing out the real working set and causing
> > incorrect reclaim. With the patch, we observed 0 refaults and bandwidth
> > increased to 5078 MiB/s.
> >
> > Running the same test on x86:
> > w/o patch:
> > File Refault Delta is 3240029
> > READ: bw=3D13.2MiB/s io=3D1183MiB
> >
> > w/ patch:
> > File Refault Delta is 0
> > READ: bw=3D7708MiB/s io=3D676GiB
>
> Really nice result here.
>
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index a171070e15f0..c637e679a450 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -242,12 +242,11 @@ static inline unsigned long lru_gen_folio_seq(con=
st struct lruvec *lruvec,
> >                 gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> >         else if (reclaiming)
> >                 gen =3D MAX_NR_GENS;
> > -       else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(fo=
lio)) ||
> > -                (folio_test_reclaim(folio) &&
> > -                 (folio_test_dirty(folio) || folio_test_writeback(foli=
o))))
> > +       else if (folio_test_reclaim(folio) &&
> > +                 (folio_test_dirty(folio) || folio_test_writeback(foli=
o)))
>
> This change is more than just "use folio_mark_accessed to replace
> folio_set_active", you are changing the pattern for all anon folios
> here? But I think we are mostly working with file folios here
> especially in the first test you posted?
>
> I do like your new if condition though, but maybe it's not the right
> time, or better add some words about it, how anon are handled now.

Right. For anon folios, the generation is currently hardcoded to
MIN_NR_GENS, so skipping folio_set_active will not help anon pages.
It is hardcoded regardless of the current anon folio state.
This change actually aligns anon behavior with file folios. Otherwise,
skipping folio_set_active() would have no effect on anon folios.

Maybe I can change the subject to " mm/mglru: avoid over-promoting
PF folios" and add some words in v3.

>
> >                 gen =3D MIN_NR_GENS;
> >         else
> > -               gen =3D MAX_NR_GENS - folio_test_workingset(folio);
> > +               gen =3D MAX_NR_GENS - folio_test_workingset(folio) || f=
olio_test_referenced(folio);
>
> Nice, this aligns exactly with what I want here :), see lru_gen_folio_seq=
:
> https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-6-913619b014d9@tenc=
ent.com/
>
> But I think you got the precedence wrong? Did you mean:
> (MAX_NR_GENS - folio_test_workingset(folio)) || folio_test_referenced(fol=
io)
>
> Or?
> MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(foli=
o))

I mean this one. Sorry for the confusion. will fix it in v3.

>
> >
> >         return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrug=
en->min_seq[type]));
> >  }
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 5cc44f0de987..f320f93d60df 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -511,8 +511,12 @@ void folio_add_lru(struct folio *folio)
> >
> >         /* see the comment in lru_gen_folio_seq() */
> >         if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> > -           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> > -               folio_set_active(folio);
> > +           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
> > +               if (folio_test_workingset(folio))
> > +                       folio_set_active(folio);
>
> What if we also move this set_active to mm/workingset.c? I think that
> the only place where a folio with PG_workingset can get here?

I agree that folio_set_active() is duplicated between
mm/workingset.c and here. Actually, I should have removed
folio_set_active(folio) from mm/workingset.c to centralize the
active/referenced state handling in folio_add_lru(). But somehow I
forgot to do that before sending the patch.

Maybe we should just centralize it for now; that seems better. We
can reconsider it later together with your larger follow-up work.

>
> > +               else if (!folio_test_referenced(folio))
> > +                       folio_mark_accessed(folio);
> > +       }
>
> Same here? Also this folio_mark_accessed only means
> folio_set_referenced here, which matches the folio_test_referenced
> check you just added in lru_gen_folio_seq right?

Right. With folio_test_referenced(), we place folios into the second
oldest generation. Otherwise, putting them into the oldest generation
seems too aggressive for scanning. But putting them into the active
generation also seems too aggressive for promotion.

>
> >
> >         folio_batch_add_and_move(folio, lru_add);
> >  }
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index e452cb043d46..48355f10542b 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -848,7 +848,8 @@ static bool lru_gen_set_refs(struct folio *folio)
> >                 return false;
> >         }
> >
> > -       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingse=
t));
> > +       if (folio_test_active(folio))
> > +               set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_w=
orkingset));
>
> This looks a bit strange, PG_active is always unset for on LRU folios
> for MGLRU right?
>
> There is even a comment for that:
> "PG_active is always cleared while a folio is on one of lrugen->folios[]"

There still seem to be some cases where this flag remains set after
I added the printk.

@@ -848,8 +848,10 @@ static bool lru_gen_set_refs(struct folio *folio)
                return false;
        }

-       if (folio_test_active(folio))
+       if (folio_test_active(folio)) {
+               pr_err("%s folio:%lx\n", __func__, folio);
                set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS,
BIT(PG_workingset));
+       }
        return true;
 }

[   78.928932] vmscan: lru_gen_set_refs folio:fffff645c58d99c0
[   81.198056] vmscan: lru_gen_set_refs folio:fffff645c791a200
[   94.071659] vmscan: lru_gen_set_refs folio:fffff645c773c8c0
[   94.116162] vmscan: lru_gen_set_refs folio:fffff645c4f02300
[  110.215317] vmscan: lru_gen_set_refs folio:fffff645c7c8ea40
[  118.679921] vmscan: lru_gen_set_refs folio:fffff645c5727840
[  135.709167] vmscan: lru_gen_set_refs folio:fffff645c51d2ac0
[  139.118206] vmscan: lru_gen_set_refs folio:fffff645c7749fc0

But you are generally right. Those active flags are probably set after foli=
os
are added to the LRU.

>
> And lru_gen_set_refs is mostly for on-LRU folios or isolated ones,
> either would have this flag. So PG_workingset seems broken by this
> point, rmap walk no longer get PG_workingset set, which removes the
> "promote on 2nd access" mechanism entirely?

Yes. I was trying to preserve the =E2=80=9Cpromote on second access=E2=80=
=9D
behavior, so I used the =E2=80=9Cactive=E2=80=9D flag. But it is somewhat
misused.

Before this patch:
1st scan sets the referenced flag;
2nd scan promotes based on seeing the referenced flag set by the first acce=
ss.

Now the flow is:
1st scan already observes the referenced flag;
2nd scan tries to rely on the active flag. However, as you pointed
out, the active flag
is cleared after being set, so it can=E2=80=99t reliably serve this purpose=
.

Maybe I can add a ref and only set workingset when both PG_referenced and
that ref are present.

@@ -848,8 +848,11 @@ static bool lru_gen_set_refs(struct folio *folio)
                return false;
        }

-       if (folio_test_active(folio))
+       /* Promote on second access */
+       if (folio_lru_refs(folio) > 1)
                set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS,
BIT(PG_workingset));
+       else
+               folio_mark_accessed(folio);
        return true;
 }

It=E2=80=99s a bit ugly, but I can=E2=80=99t find another flag for it. Do y=
ou have a
better idea?

>
> >         return true;
> >  }
> >  #else
> > diff --git a/mm/workingset.c b/mm/workingset.c
> > index 07e6836d0502..2f0c08aa8623 100644
> > --- a/mm/workingset.c
> > +++ b/mm/workingset.c
> > @@ -319,11 +319,11 @@ static void lru_gen_refault(struct folio *folio, =
void *shadow)
> >
> >         atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
> >
> > -       /* see folio_add_lru() where folio_set_active() will be called =
*/
> > -       if (lru_gen_in_fault())
> > -               mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + typ=
e, delta);
> > -
> >         if (workingset) {
> > +               if (lru_gen_in_fault()) {
> > +                       folio_set_active(folio);
> > +                       mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BA=
SE + type, delta);
> > +               }
>
> Overall I agree with this directly that file folios shouldn't get over
> protected. It will be even better if we actually activate the folio
> using things like refault distance... Which can be done later.
>
> BTW, this would break reactivation if we age periodically. That is
> less of a problem compared to overprotection, I think.
>
> And do you think we can keep a folio_set_active if folio_test_anon =3D=3D
> true in swap.c? Proactive activation relies on the assumption that
> applications never expect an jitter for ordinary memory access, which
> holds true for anon folios, but file folios don't follow that idea.

I=E2=80=99m not entirely sure, but I see that removing folio_set_active()
could also help reduce anon refaults. Also, having two separate
branches for file and anon seems to make the code a bit ugly.

>
> And I'm not trying to seize the topic but my previous experiment using
> refault distance-based reactivation resulted in a 500% performance
> gain for some databases with no other regressions observed:
> https://lwn.net/Articles/945266/

Yep, that is really great!

I'd be happy to review and work on your refault
distance-based reactivation when I have some time.

>
> So for this patch I think it's on the right track, we can definitely
> merge some follow up of this patch first, and then refine the pattern
> step by step toward refault distance, MGLRU-FG or both plus others.
> That will take a long time, so let's fix the low-hanging fruit first.
>
> Really looking forward to a few more updates from this patch :) !

Thanks very much for your review.

Best Regards
Barry

