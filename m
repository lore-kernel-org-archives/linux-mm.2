Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8151E606A319
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mxhSBjJM
Received: by kanga.kvack.org (Postfix)
	id 8A5016B0375; Mon, 19 Oct 2026 16:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855E46B0376; Mon, 19 Oct 2026 16:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744076B0377; Mon, 19 Oct 2026 16:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48BCF6B0375
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:33:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4F27160894
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:33:49 +0000 (UTC)
X-FDA: 85340526978.06.8044557
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id CE96FC0005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:33:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mxhSBjJM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792442027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7T5iwCFDP7hg0heh3HDw1oJbqflVFC2TJRQE7Ow7l4=;
	b=dB0ZyXFTlD2ZBEKUzecRQw6IqL7ZTqasrT8nU8s5Qg4Xc5SnM5VSkA028i8aZApzULlaQ2
	oYBvQ2PQrESWx4DdAG8T6N65meEzAejbyzmWszH/BcWbZTSeukqVZmzDyoHA6bvQWQ++yA
	SYdd7sLLGOkfGe2FXE9Tey2j4sv2vtU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mxhSBjJM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792442027;
	b=SZNshTAKD/RA3NFEiPUakB1gXLJoyFGPSGl/XJKFl4k/8s84QcB60raDa/u23+nx5cI1sD
	+ufNhBs7jt0YmuGmbx4K1/mVNW5Li/XK0rVDoJiBnslE0YEOGCn13P/2y5KOKKBjcVvMIg
	/kQRgVDp3KfH7+XN4bZsW0qD0bymepk=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8a83d2706fdso17318247b3.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:33:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792442027; cv=none;
        d=google.com; s=arc-20260327;
        b=qxeF1K8gDcVo4pJE6eKk71hw9dwzX7a5NIDNfcPSjqsd4ai3cUk1NIhIhVbXRDRYiX
         93uP0lQoMpJFoUsw3wE/s8xsBVWeRth4U2DBu/zqT0wf45IYp3KVwwan30xF/qzPk7hu
         cbXv2X7uQxmaypMn83Y1WNIBstv7zYRIpoy+Mx09lqDbyJdimhUP2vWaUVA1NZVMl9kK
         vVQ7b8vqpwcphFFuS8G5jLSDA+kysl6hymZxIegAA/UaYij0Ahb4f9fj2gOweyqp3mfg
         96Qx+kvlf1zfpO5tmwYj1Miz1CrOaRNA5Gi625hAOA7Y2O4gF1Hrk1ykbzQS6TUimgxA
         xRhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y7T5iwCFDP7hg0heh3HDw1oJbqflVFC2TJRQE7Ow7l4=;
        fh=Sms4jNF70loqsMFFbmSpzBR3EPUhttcK9coPt2ZPKtA=;
        b=W4yX4SxvgOQF/89ZkF8AS1reMBassmdV+DrkW0Ee2WixzwOzCQThFO80NbC2x1gF2B
         WxmQLZO6/PP/AVfmH9xeqg3//3B9m+6eISkVzeYO9rr7ZdQAGgqsb9VI8vh/MU/qzB7M
         Qw+4TrgAMJDBHQNmn2E5dqjmOCXJIVtkUzj4rVd+BLi/XCj6yqhJuynlsVWIc3cMWFLS
         +lYKJHVoKnF20XYzTCJKhUTlJbZFwtT9gWV3Fw8PVRZ+cOfUm4MniF4mKwZ+w4t3DrKD
         v17EfzpT7JS7o+WaQZdeiLW3Z/tcR/DUTna5Mt1PjnJF81no2XDGEwr+pUGNwbsVU1UI
         bUBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792442027; x=1793046827; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y7T5iwCFDP7hg0heh3HDw1oJbqflVFC2TJRQE7Ow7l4=;
        b=mxhSBjJMFHhfpNjuaoDHExrVaPGc0ezjO5wgQhD3bBbqnOjFehqbR455auptFy0lvx
         IzkZYc3YJkjjMWs1duaEd6XC6v162u+rBsPpesHfc2GHsj0CnW1YZ5U3mzUALaRJ5aWt
         2cY0aoaVqPG96KBRluUA7YziFF1F6z36seDW7ycJehggDfQEOgHuGQMdwSS+57kXEwmU
         MmkD/wOoqDuLqHq5ugnUW8PHFFUGL/gT0QNNhvhaRdQ6pkly75N2FRcXw5MT9AmN3IGw
         acLqrKHS9Htlq99f6BmZZ0NoB1qaOckuOu2vVlGCFG1TtrubO53dwjcAKjzaFWFX0o0Y
         qy8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792442027; x=1793046827;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y7T5iwCFDP7hg0heh3HDw1oJbqflVFC2TJRQE7Ow7l4=;
        b=gPNI8uSE0zXyGAS40wfe77RikqC7Hv3FrRO1tXlHhFFbAe4COgobPcQrnMNW7+X3Zd
         f7LF1aHEKWfp7udA5vtUED0rVqhXWdY9vLkxkhJTMpkYJErWJcLrqruMiVfKNkeDy1Lo
         Y3IEqw2itvjWhJlSUTGpYGPcegEaC7sHeNfZjUUe1rcRLyZKmET2z8JNtuHvLJQc8F6j
         +Cb1Jo3mCcXa3vdv5jEass30oOaztB01kvNr7OHJ6vCbN2GsZ/Am/urxU5fUWd1afSx0
         J5vH4siJmFmoa/WIao+nVGtiwHa5wbqdKc4NPHeTRTnTrcXEKym04CwYvg0dP2ELTyNU
         MC8g==
X-Forwarded-Encrypted: i=1; AKwUvByebhHV1Sua/tZilHU+RCsTLJwgCvnelQ4lTZqbW2XUYIA41/IyouN7XS4it4fTkTUOui/pM8iSqQ==@kvack.org
X-Gm-Message-State: AFq9FYI73p/yFpJMMMH/fLoXIjHpdKmHPTUpHw/SgIWfW8Xja4lluPvn
	xz1UrWViFzBYZGpoSOpG3WFkWSWs0sA6D9+e4ESsnv30VfWFkomQQKE0P0bavTUHDzoZZxF7YUI
	lcJXYBMmo7cM3g9EN469dbJv8AbRnhbQ=
X-Gm-Gg: AYBFou10e+NC7iuBpTE6eyUW9ATGluLpAFBKMN+sm8z0brN6WA+sN1nxwkHJZHdbJfK
	kwgv8haPFswL1y8BJsvQckDlIxmJZWqDnj5h4HUCZOuTEN4mMDVaSfovIkDebVt3CydJgt3uk4c
	RAXsdzwzkEFlY0s7pXlfJq4JlaP4ImgyycFNpBZ3wQI9mlLiela/ZuuHUo+6up4YpRcwS8Te8Yf
	I74bKEAGUX2M+p9kfyJ9R9GG6F78kuTkWproMrfnNRjJVFCkb0/FBXJcmAH2JnvtJUHbZMvluVY
	96pq5ldTdep+17V41PrHAm5mwMmdAG+ZqYUx1pmc/lStmlXQn0m3zS3ctFEM0DVn+/qn/9SHwZ+
	8HqRkOd5MQv0x/etga8OQ5I9ikjEU90Csm8J4tSzbLEDU13b3UMwN5gKjxbXgXrllOLC5cfKiK0
	Sfm24Br6wVrz4kIx1hUnBVk+Y=
X-Received: by 2002:a05:690c:f91:b0:8b0:e680:615f with SMTP id
 00721157ae682-8b0f2072ae6mr28736617b3.9.1792442026685; Mon, 19 Oct 2026
 13:33:46 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
 <20261017050928.128582-2-sidchintamaneni@gmail.com> <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
In-Reply-To: <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Mon, 19 Oct 2026 13:33:35 -0700
X-Gm-Features: AclHuK_VFblb2-qRhJWRPlqaC_e3NKRbx_LiB-tHmq77IBIhW4V1ck4pMMbCmjE
Message-ID: <CAE5sdEhGFtGF6LC4xNkMwGj3vTxLOW=GNBXnk3-JmsgjntXx0Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref in get_lruvec()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CE96FC0005
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8dgud6qsyhncurh99iimq8zrnqsfr1po
X-HE-Tag: 1792442027-705612
X-HE-Meta: U2FsdGVkX1+0HlKAl2PW+O7aY1dbMr3jvL7/YAL+FV6mEWPrbjrIrHnp2gEL58eX3t7QbQJJiG7z9UsHaN1x7OfdMjn7HoU3kA/1BpSgtiLq1nBcIH71DMOEfA03UFVONZkh4B1lBnjygoD+sNzOOPmLcLnvhMylSyrLaYn60TGfgSVheNgt3tQi3URPm6pQDNFyC8t6obHft579mXmkpuZcbvxil0f37dbvApZea5IMfgStMStRM7WiLcDU6t1BaFkuLHOcijSx6wH2W5XJb9Tl02hn7ta02d8jxLV7RzhL7JicVBdrk/WOenxa4GEaOzNnS4chC//OOQamlDOfXGFVFm22c3VUDdX/0nZianYzGWpUI+ryFNsGrcaHIr5T/N3RxKz6/LGXWgKaSnIZjWXoDrvlvewaW0BQo7vX2g8VpC/qVPBkvReIXXV7wFmH6U/zSLGp1NvD8o5ER1fWdtEjdBMpJRczc0Du2ETJ/QgrfOGXRAOFSCGq40Lv9AfHGo80/0VHgb3EoZE21cWa52C5PVRtFv9o1Z9u9bjDZ5no1+zejIbfY/UOyzf1VUpSM+Izl1EmB6HSuvlnKfSUqZ9CBcNNAfNWGT4tJQWgWS4zT2bx0ls+yDsFxoyQLPttSlO4V809Ml5VySYpMXmvbW5i5aczPKgI9Y/xIfLEvb3eTjbhuv1SN2Gr+PMgGvGgIKKbmc+i2kyXsmLoBi2GteZurzSc6OeDmASwHybDA5XrB4xM9R/jRR1j1qKnJNZM1/kQ0HcGujHbMUByTRVquD2jnOaCcmmlodPtfJIDiwOCC6V1LzhKkAlwE+UAxFxsQA9eoE63Th316SgvdSdaFSZwE4p57pE1M8bE21R4+kOyUukkPyYhSCrJQU4ALgz+QUYegNPw1gutXo6dld+qDZgeyVtjmqNzzpwCc2WvhIWCP1hKoVnj4KqUKvyFhHHmGwZ3mPOuF6Qt8eNbeWC
 kUJrkAOw
 9jXdIN2jnzlmKwD/AAIWIEz6UNAU6xaw9zx+fnbofSMUc49v/QN8E9ERP9iScs0w9dAqZKdTDT+GnX2qBfTWWqC+2Gzs0+Cf7nenkylZMqs/eh9I5UN168pgrF15KaNMoq6LiVZ0BRQmbOonNfaZf2veE6XDPg5vfUgSAxdBFQU3P2kD/zKGUyYqhn3xcbgCPjwpVnz0ypg0qB/8R0RjaWWeq7d8OGScku0Jnm8jlkC8m4henRWhMll5xb9yPTqmje5rBfc6bNROddMwH1Q7yRegFBq0DrtLymaffhE3ndzuqcrB6tQ6XzMxX0sjImXZvZW/hKO2k4J4sV7KENxeaKBRbmifvDmrxKuAOmZek1pJsgEGi1f5br4tIGzcAQEdVIeP/5AahUT3dg6UnWPObWC+ZtkCH3/UyjXmt/2YZi6OCx3kQYTLpV0QC+0+QBjm7qE+5moIj9IY6l6cjJsox/+bkNQw7AvHSSjEi0Jf/ojNjBSspDur5oI4LzgADXMhVJ1Yh+4DL7Oq6NDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 18 Oct 2026 at 14:24, Barry Song <baohua@kernel.org> wrote:
>
> On Sat, Oct 17, 2026 at 1:09=E2=80=AFPM Siddharth Chintamaneni
> <sidchintamaneni@gmail.com> wrote:
> >
> > Andrew Morton reported that get_lruvec() has the same problem as
> > lru_gen_shrink_node(): when memcg is disabled on the command line
> > (cgroup_disable=3Dmemory), it returns &pgdat->__lruvec directly and so
> > bypasses the initialization of lruvec->pgdat. The MGLRU debugfs
> > interface calls get_lruvec(), then dereferences the pgdat pointer in
> > lru_gen_seq_show() and other paths, so these can hit the same NULL
> > dereference.
>
> So userspace must have booted, since otherwise we couldn't read
> debugfs. The reachable case is therefore a memory node with no
> LRU folios when debugfs is read? So this could happen on a multi-node
> system where folios are landed on other nodes but not on this node?
>

That is my high level understanding. I'll let Andrew to comment if I
am missing something,

> >
> > Fixes: ec1c86b25f4b ("mm: multi-gen LRU: groundwork")
> > Cc: stable@vger.kernel.org # 6.2+
> > Assisted-by: LLM
> > Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> > Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> > ---
> >  mm/vmscan.c | 15 ++-------------
> >  1 file changed, 2 insertions(+), 13 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 0c57e4f1eb15..99e9f07fa2e1 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2745,20 +2745,9 @@ static struct lruvec *get_lruvec(struct mem_cgro=
up *memcg, int nid)
> >  {
> >         struct pglist_data *pgdat =3D NODE_DATA(nid);
> >
> > -#ifdef CONFIG_MEMCG
> > -       if (memcg) {
> > -               struct lruvec *lruvec =3D &memcg->nodeinfo[nid]->lruvec=
;
> > -
> > -               /* see the comment in mem_cgroup_lruvec() */
> > -               if (!lruvec->pgdat)
> > -                       lruvec->pgdat =3D pgdat;
> > -
> > -               return lruvec;
> > -       }
> > -#endif
> > -       VM_WARN_ON_ONCE(!mem_cgroup_disabled());
> > +       VM_WARN_ON_ONCE(!memcg && !mem_cgroup_disabled());
> >
> > -       return &pgdat->__lruvec;
> > +       return mem_cgroup_lruvec(memcg, pgdat);
> >  }
>
> I've been struggling to understand why MGLRU needs its own
> get_lruvec() when mem_cgroup_lruvec() already exists.
> With your patch, it feels like we're one step closer to
> getting rid of MGLRU's own variant in the future.
>

I agree with that! I'm happy to send a follow-up cleanup patch to
remove get_lruvec if that makes sense. Not sure how it will affect
stable backports.

> >
> >  static int get_swappiness(struct lruvec *lruvec, struct scan_control *=
sc)
> > --
> > 2.45.4
>
> Best Regards
> Barry

