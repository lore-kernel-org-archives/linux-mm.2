Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA16606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jEGgnV3t
Received: by kanga.kvack.org (Postfix)
	id 562336B05B2; Thu,  5 Nov 2026 16:14:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512CC6B05B3; Thu,  5 Nov 2026 16:14:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4016F6B05B4; Thu,  5 Nov 2026 16:14:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D36C6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:14:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97727C0C10
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:14:08 +0000 (UTC)
X-FDA: 85402318176.22.A5E6361
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B521B1C0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:14:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jEGgnV3t;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793913246;
	b=HnsaHsGN9cIc4YBbRAP7vbDqU7/gLOrRtMcYsfgF6el+k1c6iX5HtQtzs4YE7bmp3vK/lj
	6jsdBj0fPgfORgkAQRi4+NTjSDsHB3vnv0+0BJ+XVsTeDNYZdpPdQIEutYDJwdEVJ3nlbT
	NNR6dL7wLdAk3e2tkbtQZo7fZk2+8Z8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jEGgnV3t;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793913246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+Jf9HlpMjkJ/6ix4ew1upvfuwcFL6cNOjjo/sfG/Rw=;
	b=NbpF3F/s5HiWI0ssc+8jMzc3a0KQanMVViDswri0VGt3u8EWeuGXDZU/EJvGfuvRdg/ryQ
	ZG74sstWANZlT4/iH/x+yAnjlCDQxO19DVB6rz3zXAYJrKGYKWLRvxuuWz93dR66PdU4+M
	sYs4o75P+jhK/Wx67jkMv0sO2fUYm5k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 340FE605F9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01841F008A7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793913245;
	bh=y+Jf9HlpMjkJ/6ix4ew1upvfuwcFL6cNOjjo/sfG/Rw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jEGgnV3t5PzKSQ8TikIytSkfbH6GjCYtswDDlXqn5J0Otuddr7NPu3NDUrWlHYb9F
	 wP4bwTNiIUIV6uZ1swyYXldSCut1FcqDSozHOwFtHh2aFovXvDNDvkNi+VT72fUt2e
	 OMAPOnQ9eRAsM4rd0sNy6FRT8ObKgqBqMZH9YDMtXv4oli3JL9FZMM97NY8MDYBHou
	 xZuhRenhEr2fSyPRQiSWonqnZiEqoBdQ4toaiI2LkXL4CWmSK0JleysKh6bbtX6caE
	 RV/zjdP1GpnM19U0Wp2mawSZEZpZNmsxc8LMBqitH1pWRwzYvUapib0VUL9lnIgtbD
	 VEvsbaJoBgwCA==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93e7ad9f78dso281441085a.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 13:14:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx3F9kJmLw9QU7CSvIfl5PEQH1hsAFVmzOD0rvEK/YUICdMQPMHEHAaGmKnI2Y/PKoC8J0rqab50A==@kvack.org
X-Gm-Message-State: APuU4Z/Z+Xx0+O6t+8OCVfbTwSFkXf8AsPwdyZp/WY9EenPKLL1KOCgd
	n7yDxkRnMDeML1cfxWXD3VENgubvfq9TAbE2e9A6aokRBHSS63ABwYZnFESTTJymNHYSp1TAEd8
	oWhbFZBfe6phsgSFBucEKb+rRj6oZHLE=
X-Received: by 2002:a05:620a:4385:b0:93f:2ae1:ea06 with SMTP id
 af79cd13be357-945f34ac2f8mr61467985a.44.1793913245103; Thu, 05 Nov 2026
 13:14:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026084035.535989-1-hui.zhu@linux.dev> <CAMgjq7AJSU9jUBTHGcm05mtGBH4EMQ_ua9YNwuLOGVzhkdLKkA@mail.gmail.com>
 <CAGsJ_4zPZg6pCuhDtTpSkueS2EDSfWeYa23h7kC9hEU0iGB-+w@mail.gmail.com>
 <CAMgjq7DvmrwTu0vz7oHx7y7w1B9uA0AbS3YJ5CcrDVg9VwKqpw@mail.gmail.com> <CAMgjq7A6jJQ_Ncp0BCqjQJ8pJXrjr1PoOu0rdj0NJOivKp6e+A@mail.gmail.com>
In-Reply-To: <CAMgjq7A6jJQ_Ncp0BCqjQJ8pJXrjr1PoOu0rdj0NJOivKp6e+A@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 6 Nov 2026 05:13:54 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zO5S5XFc6dd70wKEs_mzqu_QW2bGOPyhKo4w2cjZrWUQ@mail.gmail.com>
X-Gm-Features: AclHuK_B_VZ3qcNpr2dPS2dUlAbGVZX7TPvdgSf43uHODhJbux5jfw9zMDTWt5Y
Message-ID: <CAGsJ_4zO5S5XFc6dd70wKEs_mzqu_QW2bGOPyhKo4w2cjZrWUQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Kairui Song <ryncsn@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: coqdw983zp8b6b7j6zh4f7ou7chdwpf1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B521B1C0008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793913246-138018
X-HE-Meta: U2FsdGVkX1+C3U6forInEbm6VL8oPcWKb+2JBSmgMBTThgJWqEK1wYnH/wqx9Y3XwmPiObDwfQUFe9V1EQe5AJ26OR0Kbmkcso1vfBos7ZIgJ+8xkmbkkDLdswX8rPbFQ/jF+ykxuZIudjx+bZF90wUrmNDKu9rSOr1uzjsayuudgiea19yD6H7P/suHmPRZINRXQK6sc2Z56ebayCchxlTJ19bLBgp2olGrDaGXx00gSrzvj5Ef2GPqe/Fi1W6fekQAkCl6GU2mXd9ESb9bpnZ1+rl1MvK4OSlBKMs8TOYZBLAh2GHmNAomPhDBOvemYsF8KmnN8DavOoNIP2YvoIcOMtL9YJjp9TTLevh4GdewwQ6aq8QrRGiDOx7W4V2Z3vZQIyWIF8UB3GPZAY8gotDwH4eoQ3Ss6lobLdN62Z4xfQYptwSY7bu0DiKDwfIpkXt15PxykY746wDtABAJUsQmOC/Ee/4CSVGF4xpwVL8jgKg4/OzjYyUjbzRyUrbeqlPxySlPXOE+GmT9K3u7jIfn54N+LpPwKbwnzLv+JK5+Fu1cIvfRrEWf71OYL+XAMGQQ9dQLsHLMqvoC83wtkR7zx9FgALcLiIOLxE6b7Eaj6fjcJ9kcaASxd2Q6ZAW98m852/cY16cvquAr09NAHfSSSS7rHScfTi4MLELO9spodX2Redb67hP2jyzRSkcMCMIJMj1SyQUmU0qnu1EJ8Bgp/NGRzmaKAEQJurAtbjq5BiENGTksCqEnRC49sID+M2pQ6J9cWo+pjTSc08vpnqod2JvclIyS0imdtcTx5AI41v8/tVPHLz8FZJTsIh3r3AzV34kEAkPTia/dMc8DK1e5esmL8fw1qrW4dD/dJWQzZP4HamX+DNF++DAIKkNl5n78aj85LUmw6eB3G63AEo0/vcD6h/EXH5TlJoqZm1HAcWHIn9AlZL7eGN0BBCmKuHcXKoaO06e/rsVJhjO
 soMrHYg+
 X9Rva8zkyI7FmhtF7F59x6oBZVvpxU1LXGAqHOzyTExbtHXBfpcQwqcXbZ8RCNRBgj6RFyVGm4nsh+rJsX7cSrvr8+CFAzcGfNCSf7gPsaqUxbYfyRF449ciIfPtugkZBS81o01a7fxkygoHWGMAgzXnJ78o76d4ah6rAJP95v5fNjt1ykKwiaZzVMmHJJ56HyyqI6e1JGdeT2KaH0p9zpxNA71hE09p+UTi/tELcowidhH8GED1nAqb9GN4j3TICSkIE+DRMmYk4M3LV8SQowiRgcuvME9cfkJrUkl9foAidF8becIwcX41KNZeI929UJqoviPJSsSmz2lYUgn63IN2SQ0to+TrFQAxg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 3:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
[...]
> > > > >
> > > > >  mm/folio.c | 6 ++----
> > > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/mm/folio.c b/mm/folio.c
> > > > > index 35e242b48870..ea3adb6a89d7 100644
> > > > > --- a/mm/folio.c
> > > > > +++ b/mm/folio.c
> > > > > @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lru=
vec, struct folio *folio)
> > > > >             folio_test_swapcache(folio) || folio_test_unevictable=
(folio))
> > > > >                 return;
> > > > >
> > > > > +       lru_gen_clear_refs(folio);
> > > > >         lruvec_del_folio(lruvec, folio);
> > > > >         folio_clear_active(folio);
> > > > > -       if (lru_gen_enabled())
> > > > > -               lru_gen_clear_refs(folio);
> > > > > -       else
> > > > > -               folio_clear_referenced(folio);
> > > > > +       folio_clear_referenced(folio);
> > > >
> > > > Why can't we just call folio_set_lru_refs(.., 0), and should we cle=
ar
> > > > PG_workingset? Keeping it helps PSI on refualt / redirty tracking (=
not
> > > > sure if meaningful but CLRU does this), clearing it makes eviction
> > > > better, but the eviction issue is MGLRU-only, CLRU keeps it.
> > >
> > > I recall that in v1 [1], Hui mentioned:
> > >
> > > "Use folio_clear_referenced() rather than
> > > folio_set_lru_refs(), which is not defined without
> > > CONFIG_LRU_GEN."
> > >
> >
> > Or prehaps we can have a folio_clear_lru_refs() do in a unified way
> > for For both CLRU / MGLRU? (Just like folio_migrate_lru_refs).
>
> And it will be better if we can keep this operation off-list just like
> right now :), some later works could benefit from it.

lru_gen_clear_refs() is currently multifunctional. It clears
refs/workingset, but also returns true to skip
folio_batch_add_and_move() in both deactivate_file_folio()
and folio_deactivate().

This actually looks a bit weird. However, following the current
logic, I've drafted a version that we can use as a starting point
for discussion:

diff --git a/mm/folio.c b/mm/folio.c
index dc2c796a4ea7..bc17cd3b6b6c 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -444,12 +444,12 @@ static bool lru_gen_clear_refs(struct folio *folio)
        int type =3D folio_is_file_lru(folio);
        unsigned long seq;

-       if (gen < 0)
-               return true;
-
        folio_set_lru_refs(folio, 0);
        folio_clear_workingset(folio);

+       if (gen < 0)
+               return true;
+
        rcu_read_lock();
        seq =3D READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
        rcu_read_unlock();
@@ -465,6 +465,8 @@ static void lru_gen_inc_refs(struct folio *folio)

 static bool lru_gen_clear_refs(struct folio *folio)
 {
+       folio_clear_referenced(folio);
+       folio_clear_workingset(folio);
        return false;
 }

The another option is:

diff --git a/mm/folio.c b/mm/folio.c
index dc2c796a4ea7..8d1fd788188c 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -438,6 +438,12 @@ static void lru_gen_inc_refs(struct folio *folio)
        } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags)=
);
 }

+static inline void __lru_gen_clear_refs(struct folio *folio)
+{
+       folio_set_lru_refs(folio, 0);
+       folio_clear_workingset(folio);
+}
+
 static bool lru_gen_clear_refs(struct folio *folio)
 {
        int gen =3D folio_lru_gen(folio);
@@ -447,8 +453,7 @@ static bool lru_gen_clear_refs(struct folio *folio)
        if (gen < 0)
                return true;

-       folio_set_lru_refs(folio, 0);
-       folio_clear_workingset(folio);
+       __lru_gen_clear_refs(folio);

        rcu_read_lock();
        seq =3D READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
@@ -463,9 +468,10 @@ static void lru_gen_inc_refs(struct folio *folio)
 {
 }

-static bool lru_gen_clear_refs(struct folio *folio)
+static inline void __lru_gen_clear_refs(struct folio *folio)
 {
-       return false;
+       folio_clear_referenced(folio);
+       folio_clear_workingset(folio);
 }

 #endif /* CONFIG_LRU_GEN */
@@ -659,10 +665,7 @@ static void lru_lazyfree(struct lruvec *lruvec,
struct folio *folio)

        lruvec_del_folio(lruvec, folio);
        folio_clear_active(folio);
-       if (lru_gen_enabled())
-               lru_gen_clear_refs(folio);
-       else
-               folio_clear_referenced(folio);
+       __lru_gen_clear_refs(folio);
        /*
         * Lazyfree folios are clean anonymous folios.  They have
         * the swapbacked flag cleared, to distinguish them from normal


I would personally prefer the latter. What do you think, Hui and Kairui?

Best,
Barry

