Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB53E606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RKTQTRlC
Received: by kanga.kvack.org (Postfix)
	id 0FD216B05B0; Sat,  7 Nov 2026 05:38:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AF016B05B1; Sat,  7 Nov 2026 05:38:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF7D6B05B5; Sat,  7 Nov 2026 05:38:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2DC86B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:38:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41193120138
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:38:32 +0000 (UTC)
X-FDA: 85407974064.25.47D1C6A
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4FB4020008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:38:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RKTQTRlC;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794047910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJBC4ok9H49MwJnS/u10ilI8HXDWAq7hcG4/f6Td/m8=;
	b=t2pcgXC7wuCsxIPwRI/UnjB/oddDjkmEM8sIh7ly8iHts6gqYjVQLnIG0uY6rEP+R+EaLB
	m2obwTlHPmoZqRJnSOr10XHgHq5A/p2IwIQqALwNAcoiFox6H5fjWcq8q+gkkANn8+uRIs
	+sw6Bt5bL+77+722eE7e5pDzaE7Nc6U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794047910;
	b=eVkYMZ22n3ik17+pEzn3jCtA8Ked8lorWJPXt6HVZwwKBcNMR01O2hGX0liGqaAoWZRvdT
	Mw6V+q2BKyECOc13jEFYZU+yQtiExWAxuVl5xNmGZjNfzq9BT4XVZVMx7A3E/XkjpM7uF7
	+7ifxx7V7zTDxXx1wf/dZNIUR5w5D00=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RKTQTRlC;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c43373ae89aso217096366b.3
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 02:38:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794047909; cv=none;
        d=google.com; s=arc-20260327;
        b=nsTrzbUpdjJ7cqzbPbiQisME0O4MCVTjx6PwcjpUhkt1ZKNfWct9Nd8ELIAmoJwYjn
         3h0XzXdAydPo2Mm+j6kp7417EL5Y80j6UHxllFoaoVp7QAiWM7coGTLJnfjcG3GQgaKX
         2Bq28eOsFtzTGzTGOF+Cd/yTedROjtzrCpzaijtq7j4JIoUBkNsZhxhmq+V30ra9U5L8
         iZ5uigc5i5jHj7BBg0Q/sZnzJbYLDVrwRzMe6Bkn1yZSZ5j6sLrttG+R5eatttkxN483
         fqtL4Epj4hd/fjZDHskhw4azoigYmfiln+j4r2c3KsQOzeRvcCuE2RqAxYjkFTeV479a
         q0VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YJBC4ok9H49MwJnS/u10ilI8HXDWAq7hcG4/f6Td/m8=;
        fh=Veqh6iH5Iti+i7DDWP6nIP436e9nvv4J+ND+6ftqWEs=;
        b=UnFcAPC9ESR8RP5qEeWdorW/oIKyDvZEBbO1w47P/vUu7aTKmF7Ul5NOYvBVaPygQw
         pju+B132CEFERbl4ivkjfWMRkqiQOKRmqWmwYxFaVlr2mH9YgTprXOSJw58ihs0SumnX
         Y1QWFcZqsEuqWSJ1poDMSp1BfQpK7HLjbfNtLHh4nX89w7DfP74O9S8byCikm9KWbi0x
         bZgHesymMeiteQT6+dzXAPolnXBSfdwCwA8iRo67RVdm2yvIjSJskw0xPuAk7g1FHqLM
         HCNPNpxwiXjlSPNtEIz0vmZKryjTpPVyKKnUxRmIihkx1RKbx55rX6m/7nn62FpisFat
         /uFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794047909; x=1794652709; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YJBC4ok9H49MwJnS/u10ilI8HXDWAq7hcG4/f6Td/m8=;
        b=RKTQTRlCJapwMKXCqxi9H7UU0Kfqwsw/2Rv+is5yfJA+jA6IWrMFbzmH5ldJ5FXFXu
         MFfGlJZsq8wUyp6CtLBBwvI/yJmKMsI9heqUjBkO5vLND5+kz20I7qLDAshCZyJhiUQG
         JB9lZUTYRyQkD5dJ9k4fGUW95JzJoIKuuKJAlcmcwKPHz2Sxy/20+cbxlco9+JDUdWF3
         PvBIKUJ1F1pAP5MrydFfaRy5OKjfDve5fuIdFJkXK1h2trOo2gO79keQ5UEYtqSeELTj
         F+6e9Xggef4au2SdRYrYITr6IVFQWUaziciASV6FEDZeiCOYElzwu5tkL2EQ57WShdhV
         re8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794047909; x=1794652709;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YJBC4ok9H49MwJnS/u10ilI8HXDWAq7hcG4/f6Td/m8=;
        b=DubiaxvJgLof/P1taSvQRIp2bIoerIqZW6fjlCCbpiB/48adzHOHu1JBVmgQMCOXor
         uxl8M2RMaHOa19OD2qlta1lvsCsm2gjv2ShEGin1Nykfx+YpUOvakw8uDTzXxr7E9t6C
         hBX1ZXyQfzXnS4Rq6oyViRxWcn+M4BtCr7pfAMCbGZMxv7WPKVzcYlPJ3BMivAe1SBnn
         687U/ekE6Vi3iY7EAGO5JyuYJLl8+GxH3S9oKIcqFtj39y2KM1+tAxlC1Oses8enZTGu
         uW1+uIp5othbLTgU5gvd1DnU8gVNc26Fbkl3CfHdSLNM3+3rb5SOMVD1dpDbHABN8d+f
         5+zQ==
X-Forwarded-Encrypted: i=1; AKwUvBxJtlezVu3aAzoRl0RUbVzLsIS7B7fdbiA3npy+3UGD7iCnL9v7QVTGnZqhRVEh2ANy5TP3j/d9Iw==@kvack.org
X-Gm-Message-State: APuU4Z9GDn9OWzOchXiNfDpj++nym5H9tvjy6arzcszIZLggGowjvCT3
	54UlI9bIVBQ88MeSLbFHRaNKAi0mytewslTm4X+wpZ0TjWiAWr9cR2en3jfwdAHeLzCu0oZKcq6
	j8sR4C+W00Z+6CIYRGceIabzsthDVRF4=
X-Gm-Gg: AYBFou3t8AvJJdFf8AhWrQtpLt+mTHhAj7kgBTXrpDP9IlRqT7GLftlkBNSQj01b7s4
	GF2brMtZHuju8PMrkW9ljeekYQ1iDY9rJdps+ZZlWqwegeXQWcrgQnZOUTr7lnDGlguSp1qk2b1
	3kTNZBk5d0I3B6JERMlsATnLg7CfEV7l4V+v2XyvM13WujK+lrtNrwMx2UCra+euT4PZ1SNLQs5
	+oeMJAoJXcoESssXo7tjn9W9QP7JCJLOFNk7N68AVBggWRPIiUR7GFja0FYpwY+IcnlElsUw3Ok
	EqrrBdbkTaIXksIkzZUS3lfX8GmhicE69FaKyu+oRGEIB8Bt8bDkm/VyfNUhWPy+oA3ii5PQmqD
	XSMPKWSDMPsMmAiDYbwzNJRK+BwIjFkeMPab6DDbdEN1eFYaZ0rPu326QJ20/E+F0hRox
X-Received: by 2002:a17:907:c491:b0:c40:aa04:18d0 with SMTP id
 a640c23a62f3a-c4d34b8cef5mr420685066b.17.1794047908553; Sat, 07 Nov 2026
 02:38:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026084035.535989-1-hui.zhu@linux.dev> <CAMgjq7AJSU9jUBTHGcm05mtGBH4EMQ_ua9YNwuLOGVzhkdLKkA@mail.gmail.com>
 <CAGsJ_4zPZg6pCuhDtTpSkueS2EDSfWeYa23h7kC9hEU0iGB-+w@mail.gmail.com>
 <CAMgjq7DvmrwTu0vz7oHx7y7w1B9uA0AbS3YJ5CcrDVg9VwKqpw@mail.gmail.com>
 <CAMgjq7A6jJQ_Ncp0BCqjQJ8pJXrjr1PoOu0rdj0NJOivKp6e+A@mail.gmail.com>
 <CAGsJ_4zO5S5XFc6dd70wKEs_mzqu_QW2bGOPyhKo4w2cjZrWUQ@mail.gmail.com> <8e5956d5-ae03-40c0-b5a0-bd550f4c14b3@linux.dev>
In-Reply-To: <8e5956d5-ae03-40c0-b5a0-bd550f4c14b3@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 7 Nov 2026 18:37:51 +0800
X-Gm-Features: AclHuK9fmKDpAUrLOEJxid5m6a5W2E_OzsxHmICY5QYFvtDrW8vifxe4XbQxg70
Message-ID: <CAMgjq7BNe+EcyAGY_hz5DQg6oRs6x_rAM6MVoAM0LNEP4Jt8qg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4FB4020008
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ekb4mfczytauzmysr7436yzmji4itbzf
X-Rspam-User: 
X-HE-Tag: 1794047910-940895
X-HE-Meta: U2FsdGVkX1/h8G7R7ntibqsZxTbUjBnhNVxEho2TftNLlwSqVUSVbh51gTsrqMk/v6XIYmFekihZKuxECmAKuzQyarikZShCvGl2kK5f5e3j2TXElrXJTEahup0DrfmlnbpD+Ji4qb8yr5YmxqEnRQZc4mbk3oMytJEjSUJJ14ah7+QsbwV9+e09mAV8fgvqeAU81vnEQHZy0/HLZSRmYcBs9DFa8Lo7OZ1fFN+dLLhSh8cHFuc/wQmBTd6YlM7qHwJO22mr1d4T913a3fcJTcJktPvz+D9g/KmTVlEOn7+nRHkigItQC1dXjsaMX8iX1VfvystnHMLfU9jKqhnGwaHYMHSQr31K07SqIL3f0eEW/oMhpynMmCUmtoR+y3x0ku1Pria8JRdTjVObu0ytBOZMOx6JhzTW+IQH912I8n3SIQuXLUhgu1uz8r7RXWOwX3R4JNIPQVK7tkD6jZOBX6r5k4UyUZZhHyWPjIPbxE8OV1KKJW5p8Ca5M9p92Tup99qU/Z3liMuwnqrYSRdLnHmQwKAulWWp6k+6f/cQk4ztdUWv4pOlSScM05k6Ugq3HA8WTL6j7/bBEEYAl/Q0XomeQru6nWzhJvmS7xgkkKuAdaLdL0gCEXgx3+LSVeHhOgY5VknJY42eK4wkKkOauJ9GCJi5EktuVdc+sMg0lTQDLh4E7AZliicQnhHgSk2aNE0LFs9xcHy9AcwqESesggh6psnePAicgX0Ecl4hqgvX4MyBfWSxKWhRCiqzt6cHanoDhjlQKCfqxTTwqNbWVLytdCHYetDwCJlUZYMj3rwxvjym6Y68ijIGn0yEq3Fn9uQoKdRsT3YMiGhUX+IT8/OWbEHGoKKbgkO/T7JdJTrT/QxAfniNcPJQUdAvnE5w+lWEfPckJpSQeRJGqArAGRW8yt6PZ9NCoS7GUxDIuYBkuvZ300HX3GlLUXpLp16w4jDWpwEoNIl/eu295eE
 ew1xqIGi
 9z3wXeqcZ9UhgZOVuQE4a+t3KTO4KzaMb4GXqEAltcHL1esbBukobrVpMnLj/BXPzeA/MRpW2vLQJCGUzgs1SMiEpAGWq9V0iciOALpbSRGfjEwd4q3zbR7NADXBmRJOMwlL4tsq0zoMW9SWqV4VKlC5K+HsDbs/eXpj5pO0SQvcZ5PC9uD0/iEpvERwGrQzLIn3EYSJWW9lYbWtVD9KKav97n6ac7AOXWwDHJ3EXRPbBL4/xstaX2+D/ZK+2NSxDXPoW6n7IbNVNhG3ZWULc74cQoyRcs2/hQTYzuRjz1j6A2FmWAhKnTBEFQfwmUO0pjuxNzr+pZ03yPFbAEtIc+u0qSp+fsuMUn29wdBWB7F4SJ5+plowyswU3iavLaz/205aohtqVjNQyrPHU7A8HDMRTJiLSJerDofdj8ZZLQFEwSwxqNkLStYoJuiL7BduzPlCLUnIR106hMN6o1jqd/qR6p0W3mnfNS4US
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 4:38=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
> 2026/11/6 05:13, Barry Song:
> > On Sat, Oct 31, 2026 at 3:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > [...]
> >>>>>>   mm/folio.c | 6 ++----
> >>>>>>   1 file changed, 2 insertions(+), 4 deletions(-)
> >>>>>>
> >>>>>> diff --git a/mm/folio.c b/mm/folio.c
> >>>>>> index 35e242b48870..ea3adb6a89d7 100644
> >>>>>> --- a/mm/folio.c
> >>>>>> +++ b/mm/folio.c
> >>>>>> @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruv=
ec, struct folio *folio)
> >>>>>>              folio_test_swapcache(folio) || folio_test_unevictable=
(folio))
> >>>>>>                  return;
> >>>>>>
> >>>>>> +       lru_gen_clear_refs(folio);
> >>>>>>          lruvec_del_folio(lruvec, folio);
> >>>>>>          folio_clear_active(folio);
> >>>>>> -       if (lru_gen_enabled())
> >>>>>> -               lru_gen_clear_refs(folio);
> >>>>>> -       else
> >>>>>> -               folio_clear_referenced(folio);
> >>>>>> +       folio_clear_referenced(folio);
> >>>>> Why can't we just call folio_set_lru_refs(.., 0), and should we cle=
ar
> >>>>> PG_workingset? Keeping it helps PSI on refualt / redirty tracking (=
not
> >>>>> sure if meaningful but CLRU does this), clearing it makes eviction
> >>>>> better, but the eviction issue is MGLRU-only, CLRU keeps it.
> >>>> I recall that in v1 [1], Hui mentioned:
> >>>>
> >>>> "Use folio_clear_referenced() rather than
> >>>> folio_set_lru_refs(), which is not defined without
> >>>> CONFIG_LRU_GEN."
> >>>>
> >>> Or prehaps we can have a folio_clear_lru_refs() do in a unified way
> >>> for For both CLRU / MGLRU? (Just like folio_migrate_lru_refs).
> >> And it will be better if we can keep this operation off-list just like
> >> right now :), some later works could benefit from it.
> > lru_gen_clear_refs() is currently multifunctional. It clears
> > refs/workingset, but also returns true to skip
> > folio_batch_add_and_move() in both deactivate_file_folio()
> > and folio_deactivate().
> >
> > This actually looks a bit weird. However, following the current
> > logic, I've drafted a version that we can use as a starting point
> > for discussion:
> >
> > diff --git a/mm/folio.c b/mm/folio.c
> > index dc2c796a4ea7..bc17cd3b6b6c 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -444,12 +444,12 @@ static bool lru_gen_clear_refs(struct folio *foli=
o)
> >          int type =3D folio_is_file_lru(folio);
> >          unsigned long seq;
> >
> > -       if (gen < 0)
> > -               return true;
> > -
> >          folio_set_lru_refs(folio, 0);
> >          folio_clear_workingset(folio);
> >
> > +       if (gen < 0)
> > +               return true;
> > +
> >          rcu_read_lock();
> >          seq =3D READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> >          rcu_read_unlock();
> > @@ -465,6 +465,8 @@ static void lru_gen_inc_refs(struct folio *folio)
> >
> >   static bool lru_gen_clear_refs(struct folio *folio)
> >   {
> > +       folio_clear_referenced(folio);
> > +       folio_clear_workingset(folio);
> >          return false;
> >   }
> >
> > The another option is:
> >
> > diff --git a/mm/folio.c b/mm/folio.c
> > index dc2c796a4ea7..8d1fd788188c 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -438,6 +438,12 @@ static void lru_gen_inc_refs(struct folio *folio)
> >          } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_f=
lags));
> >   }
> >
> > +static inline void __lru_gen_clear_refs(struct folio *folio)
> > +{
> > +       folio_set_lru_refs(folio, 0);
> > +       folio_clear_workingset(folio);
> > +}
> > +
> >   static bool lru_gen_clear_refs(struct folio *folio)
> >   {
> >          int gen =3D folio_lru_gen(folio);
> > @@ -447,8 +453,7 @@ static bool lru_gen_clear_refs(struct folio *folio)
> >          if (gen < 0)
> >                  return true;
> >
> > -       folio_set_lru_refs(folio, 0);
> > -       folio_clear_workingset(folio);
> > +       __lru_gen_clear_refs(folio);
> >
> >          rcu_read_lock();
> >          seq =3D READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> > @@ -463,9 +468,10 @@ static void lru_gen_inc_refs(struct folio *folio)
> >   {
> >   }
> >
> > -static bool lru_gen_clear_refs(struct folio *folio)
> > +static inline void __lru_gen_clear_refs(struct folio *folio)
> >   {
> > -       return false;
> > +       folio_clear_referenced(folio);
> > +       folio_clear_workingset(folio);
> >   }
> >
> >   #endif /* CONFIG_LRU_GEN */
> > @@ -659,10 +665,7 @@ static void lru_lazyfree(struct lruvec *lruvec,
> > struct folio *folio)
> >
> >          lruvec_del_folio(lruvec, folio);
> >          folio_clear_active(folio);
> > -       if (lru_gen_enabled())
> > -               lru_gen_clear_refs(folio);
> > -       else
> > -               folio_clear_referenced(folio);
> > +       __lru_gen_clear_refs(folio);
> >          /*
> >           * Lazyfree folios are clean anonymous folios.  They have
> >           * the swapbacked flag cleared, to distinguish them from norma=
l
>
>
> Hi Barry, Kairui,
>
> >
> > I would personally prefer the latter. What do you think, Hui and Kairui=
?
>
> I prefer option B too: it keeps the flag clearing independent of the
> list state and leaves the two deactivate callers untouched.
>
> But I'd suggest splitting this in two:
>
> 1. Take v2 as the fix now. If that is acceptable, I will respin it
>     with Cc: stable added.

OK, that makes sense, agree that we can patch that regression first as
a clear backport indeed. Thanks!

