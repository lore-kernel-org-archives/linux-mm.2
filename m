Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC0C606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ol2ycFyR
Received: by kanga.kvack.org (Postfix)
	id DD5FF6B05B2; Tue,  3 Nov 2026 14:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F366B05B4; Tue,  3 Nov 2026 14:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37006B05B6; Tue,  3 Nov 2026 14:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 903FC6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:28:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 002901604DC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:28:50 +0000 (UTC)
X-FDA: 85394795262.24.0F0FC06
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 081E0180004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:28:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ol2ycFyR;
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793734129;
	b=5O7LsLShGeLWtfB3fjeN+vz5IS2+ETPpbKjsDxeVAwbjscQnt8HwjXJXlsgRo8YLYWgoIH
	tw1bU1rG2BrMj4E91FN7LoaToE8FmFCjB5JEHxhSFZrNnNiVm8pvczjh7Pq7aco9THGV2G
	5FywXToR1Z6YyNv29IQBe/Am7Bq20Uo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ol2ycFyR;
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793734129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8nOrLjD6nwiDigTpfoc51j1sg2vY57/yO5mUWHgXYs=;
	b=RwtHKzY41u4yE7S7RYB0bzr3NOR3Y7655Abz6cX1EaksxJj58EgAjeBr66M4HO8XYLe98N
	N1uKMyUxz3XApYO/uIpXTHPc+f/HAOtAhETsKsv1b8gSWLg2jkvl9cVQZkiIYXjNiCW59+
	dqQvgpnoeSdEImAgK1ZIxzw1i7mM7CY=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48e1d0e5dafso653564f8f.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:28:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793734127; cv=none;
        d=google.com; s=arc-20260327;
        b=rEUfy2XO4BvEEFSiywHdWUmh5AxOhS2wgdwz3y9TinxGZExThnuwiaa5fWloZLsqra
         zUvVFI2KjWGrOrAu3blH0c5LIKF/zIgmm1W1CHf77bnN4RSIn/wmWYcecgLB/nrFfEY+
         1CwaG7hxugXKAwnJKurG/yKYTk3EkvzQyqGxVFJcWPAciX8koMj5ge8Ql7rYiIsCZgW2
         TWuiU8BSYzM28UoUHEO+mkbFeufgZx40p/5xk60fkp4uMc75gzKEJ1p6IUCH4p+Z5J2t
         ZaR/yScTlnPnfejSu1NhzKlun89Dx9Ec67Z7oun0y1X6iomd6USINknxywck4f5mbBiS
         u/2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t8nOrLjD6nwiDigTpfoc51j1sg2vY57/yO5mUWHgXYs=;
        fh=mP6tVO4tZwcRloRxr86mHyH8AbPsGj2TYtkZb6M2NIs=;
        b=ltg9MS8CbDP+UsjBo78XABpjcdbb/SXSMDJkjt6R5CTs/c99dvQKab80lSda2K6ops
         dw8bV8F2dFojeOMOlcNy+RBEgzimmgep6WjIMXIYdGgRn0O+xoH+kq/+pxFa2cKE6ePC
         cYfLZyfj3FMUu5I5THctGBJr5XJZUlPbqynvMSDvbfhpWZYM5aNkIGk+Dmz3TBzK05Hd
         XuGCZb1qyOw8Wl8UUiumDPxCc47gCJrLNSiMWDcz1L/QbILa9UZIWy6ZxQuqQKS0vzD4
         tmQ8FjvdyZrIcA3DDK5XbBSxoGhwJeoKRxKnXY6fBAzTtdo5IpsaXBE51K7kbDXwel9H
         5NtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793734127; x=1794338927; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t8nOrLjD6nwiDigTpfoc51j1sg2vY57/yO5mUWHgXYs=;
        b=Ol2ycFyR++w3hmWBHKCuazWtHl/XQk4NpakmX7DRXgInCfyTkbjTQuhPRPOLa4OXJO
         Z751GgJ1IVxm3193bs1M0QIzyJQLX7OzTE1qlcy/GqAqQ1MtnM/ZZga/uY1p6xOT5kXM
         09VTmjZERmJTA33BYcwqCBHaaPTh8o+1aYVpsFjnKoL91xd1myIVkUU1G/4zCM1LPm7+
         xiEaDkZyVbHpDogXh1sHntMB3lCaCaVoXNJyMlkty8iHbqRfvfnoLHh1inPPw2gnyN9U
         j7AlLeKUIHXZ5Jt12AV96Whxygy5DiG656irgbUCgwALO/oGxm31QXxRKxfP7xfSQv4v
         kD9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793734127; x=1794338927;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t8nOrLjD6nwiDigTpfoc51j1sg2vY57/yO5mUWHgXYs=;
        b=oKazCiG4RSIO999iOt1PTRUxps54sbTp0I8FZ9yiHY6JLS85VE2jbysuTKNWUPVIjo
         ECObtwNilMBnLFCmM5Chlm2Fat4Mh7AiPmbJXCsuemqo18VD15bamLT8xuKMhg0QDlm9
         MPL5E26p2F2a66v3QM0YASFWpO4qQLmmJfcaV2Pru5weDO5jdfRp0HqE7Us1lMdjTweU
         HezGxGsIIqOIpIwS0CCm+LDL5eZ2j34yE8lE+yPI+MW4KoB7yk8LU5aoQ8IIhc/NZbly
         G+bSoBOT727yVnZKMEZT2Yk5o0wbr5FCfA0X4fmMVnAQCpUnj+MHNzxPRZ9lcz3gm8qr
         rZuA==
X-Forwarded-Encrypted: i=1; AKwUvBzMVa+lvg3IwcTabLmk4WbPHZ/8TcqrzMBsySzH/A3HDSlCjpeX+gxhw7uvD1awQ1ql0pIFq5z9rg==@kvack.org
X-Gm-Message-State: APuU4Z+PY+bvL9kZZSnU/VfvHl7BAJmOxRPxKKnQmAswGUk97n1a56GY
	oTYKmACoWUhD4EUDz79WAnNl22wLPB0/GzuVDJVCV3YMR/MTq8AvcvlbWa35/d2oo3KggqmaBN+
	W/EYRSPc66BDLlGaj7ebmWotC3MQBMBc=
X-Gm-Gg: AYBFou3jqADcJPJWDoq/wJDkJuSW8+2aADICUUmaF+iYsY7fM39f97x16C2gMN6GTA/
	rXtr82rKQT123PtJV+bkpnx7t0VLRLPZOdC9/0nUv36hBUgddaj3bipEwb4ElqYtAg8QgxT+LF4
	/n5QrYGc5jhlG7k7NlNbzwRusVKyXrz3LERoFgUtFHpFUmOkCrI1lr4EvD+q6SRS1SC56r1sBCn
	4HaUBMsfIIoD1QJF6yh6EGqjfBwrX6Nyvn1Agr6Rl4MlfwbvpRVfnB51RtINMbbfrcjDosd0Gq+
	qn9/f3Y7jDuFYYwNOkINSekXcXfwZZtMJb0GFhBBbeDHHwr8/gtDWRpQx30HU9qNARtYhEdYBL0
	xtKNSc13FtDuIq2AmYNetVAFgaStvhxBwbI45aUSf4uQ86ZQV0CgTVTGU0TEc5qFydAdJ6znoWA
	FvGRgg/48vr7a7NwhU0Dfipx0c0ujIfmCKUwHdcIw=
X-Received: by 2002:a05:6000:3101:b0:48f:bbb5:61c2 with SMTP id
 ffacd0b85a97d-48fbbb563a3mr5372701f8f.4.1793734127208; Tue, 03 Nov 2026
 11:28:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
 <20261102225030.2743129-3-joannelkoong@gmail.com> <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
 <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com> <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com>
In-Reply-To: <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 3 Nov 2026 11:28:35 -0800
X-Gm-Features: AclHuK_fv28I1LSA-uaRqmIKjly-WVjyuC4Z8VHCIcHxkEADag6Zx2F__lXwrn4
Message-ID: <CAJnrk1ZAz2ro0-8CC7n8mEjpuRQ64=v0rABtygaw5e2Aohq3=w@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the
 node counters
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nkog6nfcrwjii4fzrrgq8ocp1dxr1m4c
X-Rspamd-Queue-Id: 081E0180004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793734128-859910
X-HE-Meta: U2FsdGVkX19aX/IAS6rynDmFGJRgNuD1ZFTceDN9aVoxkQRzPiZ5XvHgjejL3jqICD3w7wmbjDAJK5ef7yg3xQOdC+i8nRaBDojVTQutX5RmDRivlo+gZMJdyhh6Dq77vyvuniL88Usb1DW4NCM7OE7SL3mwubABusP4DyoO0bESLU87V+wE7aWKwyJhIESggKyYdDm4JqKEjaWJNTihXXa8ZZ3bYAXHkuGqNf3fPeIJF3yrMCtFRiKWIflgMhcCpqqHRZWyR17OiSqkMs/2lqkjQ54++WM5uFd7AUObUfy5KFhuSCvsiBkJ6hHipa1wrXL4UiJBDKVoigAGDfvuSLXMsPgGzGY9Y5NSSpxRWJufKgvWf8+th9S5D1iB3fzK/RFQorkRDwOovFULDtHC9qAWq88ogXq4XBkHOnC+j54D2OcYntRn6+qIqkt6zpY9YzM5iRGehWC+TO9ce4eenCAaBp7K+yv6BCshiddrNoLJCIizRG248FZyXe/fwbFDInJ+KYnujZ0tYM9OV3Wv8vWt6Tzy299eazXbCDpGnUxWLh+8k9Rwda5xhWQ6WfC8fepS4agetKrVscNRoFYOGD5DGwN3AyNVVufBEHYC7DbburunmUQXysmt3+ESrvejaMclVEg7ZdSSgRS9fBy6WF0acMJpd3nv0hwB1gLxqn96Z4skZQLXcDSn3fCG6Uj/7OzP0IaUmrunAN/qOGNMcUCrh56iumxh1bfkstAAgtxBWFK3SlN1sDdIFU4bvixofNIPtiSh17uWqENjQxYGBQuMf3nmOLTe6xXxwy+8hnsbeVwCSb+Bj1wDoIEhU2vdKWRrC+F2WnG6Bvwbub9EUK06pQMtvh3ZN3bJqVby5q4fcbmXEPNQ1cf/tKABtIy4Fvrvpz4D4uCMJJg4jhJKIAsvt2n9KP0KrtmBL+X+paX2aT9UDnZFRYN9ytrbY/M+urH7vqDWQlmMKU5vKuQ
 UbSve7iN
 E8EcTWhTVCjHvQppXDF2yc1GsBEszS2enH9LDHHh8Q8CYIidNmSc+uyrcEAiyGfheKcHdeILhTrb+I9g1xNYPpK30lWcO499eDhK6QTqh7Ah6quQmTkPN1SrCWF3Y2Ycq6MPoUjhWADyQFFCOWz6gZ83MhRqKVb7IhRdKOf9pHwjkpvRqXNHazWYvXNB9e3/Brjy/IGbt5muqzkXqL6hb7YvugYuqw2kAyGWtcc4A2HykzhEcn5lFYpqgW39r3c4cuhJisMet38yTHLGDF6tVd7A21tNqvtq26rf9JPzlVZd7PQSNs7E6YuPjgCihm9INkJy9UYOeVFimvgoV1A8Zg9RXtjvxDUJUvmHgkso+uUCRd6aDRtSHHMca31YxQ0U7nZMZpEG+G/ThtQ1/J0TODYyJStkQpJU1Q0NU0l0ry2UsJh9n05sqS4+wI5LDKHp8Hj4d6lI07CP/ZuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 5:00=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Mon, Nov 2, 2026 at 4:34=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > On Mon, Nov 2, 2026 at 3:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index ac6c43ea8c5a..938843346571 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const st=
ruct lruvec *lruvec,
> > > >         return x;
> > > >  }
> > > >
> > > > +static bool lruvec_is_root(const struct lruvec *lruvec)
> > > > +{
> > > > +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lruvec_=
memcg(lruvec));
> > > > +}
> > > > +
> > > > +/**
> > > > + * lruvec_lru_page_state - read an LRU stat of an lruvec
> > > > + * @lruvec: the LRU vector to read from
> > > > + * @idx: the node_stat_item to read
> > > > + *
> > > > + * Like lruvec_page_state(), but for the root memcg the node count=
er is read
> > > > + * instead. For stats that only track memory charged to a memcg (L=
RU sizes,
> > > > + * workingset, rotation and reclaim writeback counts), the root me=
mcg's
> > > > + * hierarchical value equals the node counter. The root memcg can =
just read the
> > > > + * node counter directly instead of going through rstat, which req=
uires
> > > > + * flushing. Flushing the root memcg flushes every cgroup in the s=
ystem.
> > > > + *
> > > > + * Use lruvec_page_state() for other stats (eg slab).
> > > > + */
> > > > +unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
> > > > +                                   enum node_stat_item idx)
> > > > +{
> > > > +       if (lruvec_is_root(lruvec))
> > > > +               return node_page_state(lruvec_pgdat(lruvec), idx);
> > > > +
> > > > +       return lruvec_page_state(lruvec, idx);
> > > > +}
> > > > +
> > > > +/**
> > > > + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for d=
elta sampling
> > > > + * @lruvec: the LRU vector to read from
> > > > + * @idx: the node_stat_item to read
> > > > + *
> > > > + * See lruvec_page_state_monotonic() and lruvec_lru_page_state().
> > > > + */
> > > > +unsigned long lruvec_lru_page_state_monotonic(const struct lruvec =
*lruvec,
> > > > +                                             enum node_stat_item i=
dx)
> > > > +{
> > > > +       if (lruvec_is_root(lruvec))
> > > > +               return node_page_state_monotonic(lruvec_pgdat(lruve=
c), idx);
> > > > +
> > > > +       return lruvec_page_state_monotonic(lruvec, idx);
> > > > +}
> > >
> > > Why not do this directly in lruvec_page_state() and
> > > lruvec_page_state_monotonic()? They already fallback to node stats if
> > > memcg is disabled, why not do the same for the root? Are there cases
> > > where the node stats are not the right thing to do?
> >
> > Hi Yosry,
> >
> > Thanks for taking a look at this series! I don't think we're able to
> > do this directly in lruvec_page_state()/lruvec_page_state_monotonic()
> > because I think there's still some places where the node stat and the
> > root memcg stat are not guaranteed to be equal.
> >
> > The stat I was looking at last week was slab's NR_SLAB_RECLAIMABLE_B
> > and NR_SLAB_UNRECLAIMABLE_B where for those, the node counter value
> > can contain memory/stats that wasn't actually charged to any memcg,
> > which I think means for these cases, the node counter values can be
> > larger than what reading the root memcg rstat value would give. The
> > functions I was looking at were account_slab() and
> > memcg_slab_post_alloc_hook() where the logic adds every new slab page
> > to the node counter but the memcg stats only get updated if specific
> > criteria are met (eg the cache had SLAB_ACCOUNT set or the allocation
> > had the __GFP_ACCOUNT gfp flag set and the allocation was not from a
> > root memcg).
>
> If it's only the slab stats, it probably makes sense to special case
> those instead of the rest of the readers, right? It would be nice if
> the default behavior is reading the node stats that doesn't require a
> flush.

If we were to special case it, it would need to exclude more than a
couple, I think. I asked a LLM and it says NR_KERNEL_STACK_KB,
NR_PAGETABLE, NR_SECONDARY_PAGETABLE, NR_VMALLOC, NR_HUGETLB,
WORKINGSET_NODERECLAIM would also need to be excluded. We could add
this special casing in, but we would need to make sure any new stat
that gets added in the future that belongs on the exclusion list gets
put on it. If it's missed, the failure would be silent whereas with a
separate helper, callers have to explicitly opt in. I'm happy to go
either way though, so if there's one way you prefer, I'm happy to do
that for v2.

Thanks,
Joanne

