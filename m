Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1346606A335
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 02:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yqbhy777
Received: by kanga.kvack.org (Postfix)
	id 9CADB6B063B; Wed, 18 Nov 2026 21:34:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97B796B063C; Wed, 18 Nov 2026 21:34:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844926B063D; Wed, 18 Nov 2026 21:34:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 023176B063B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:34:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFD65A094C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:34:30 +0000 (UTC)
X-FDA: 85450299900.17.212838D
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id D329020002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:34:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yqbhy777;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795055669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uM0JN8VUfPH6oC5vWX2xf2IB4+IT358j1Ch/z79GA5E=;
	b=Lq39vLaaSF/dLi90zlXVEHu7H8dsBtOwJsaSWfYd+wJVzGa6taw9V50ulZWbp8TY7EFFOh
	Ff6o3f+ZbTq6+Ing0aeLYbBBT+becIXahujXdh/gk2kiQ5SGMP4TdboZKTNiVhfLyPF2SH
	dhZPPmilxR5iLTafqTHq3XYWUjaXX9o=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yqbhy777;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795055669;
	b=J1+hcSqupmv2tkd18DhDY0R5eOxulkATR6CvZSUAVY7K2idaBczCpw5g0lkkMrc1KThtgV
	R6ZQ8F4ZzdeGzTEgJ7mDxYfND8IKwbl+efGFKW1xVM1cbAsf73HvK77praLSS2Pt+L0K5+
	LnL22q9++mElKXv2sGB0JcJ7/BgN2rE=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4d581da0aaso210587366b.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:34:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795055667; cv=none;
        d=google.com; s=arc-20260327;
        b=cNI5B/Z9dIBYlCV/vvO9yNp6PxXsytgAjKE3GqPTfwh8irsw70SZD+rXfvhi15q534
         /Vkfx5KdE2hIIw0LGNlUVDlgZrz55JStr0ja5ZKGFalhnyfNQbr2O7ZRSnbNYXqTMI0v
         vPY1wQ5u/n27lqk0l/AUm+VOONu6AUg/Id7Q0YyjcuTx0t9652x/F909dqHmeCSRIL4i
         zyhY0tS4DD0tDRw/YEtB7fsTcpWaa8SgRR5DCJldpqRF4Q0/S0M0+HfHFkxR/0rdsjD2
         ZKIsAdz1qGUC/j3n3HbHhhzwzKQBfQ3tPkoPvISRLIOX8pS+fuzeS+p8siIJBPduwLE7
         iczQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uM0JN8VUfPH6oC5vWX2xf2IB4+IT358j1Ch/z79GA5E=;
        fh=SuGro3LuLsk6byufPAfAAQQSIx1YKDKO0TNpiyde+AE=;
        b=VApD+ah3zl2p5/a+stGgJpcEQGOTRLxV881SC6IPO/WjT1P7CxJaKH2r+XrXNYp/3n
         XRSvZ7nwWjxRflXSmrnhuW/KNw3SJY7yj6wshL18zs83ZINAyek3wV4q6LjDA1EXk8BW
         koHhcNmU9HGdi2zf0cL2bjgJPxgOVltN1t+K6Hya7/UC7J0ZpCL7enGOvfJ0UFQ7tU7I
         3dLKGB9vfVlRXqniLB18yq2gkxRzZMDSVif+/32r7sqJWnV9XepKZNlXuVYJiez5GeT5
         TDY2h5FGvW7ZSjU1c7o/KC4Z/rfYSphG/t2XI+MIQeXow+4LdcCvg0eBWSgZZopn74t8
         gyHw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795055667; x=1795660467; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uM0JN8VUfPH6oC5vWX2xf2IB4+IT358j1Ch/z79GA5E=;
        b=yqbhy777ffViy0BpcaaS0GO/KSTbkbasYL2ceY3aIAr12HnNjXrfvShayJPZs5w9uc
         ND4BNYnGZViB8A+LhJs7EX+8vB0oxTgv1gzVSF3qE5xXYluw9ptuwJi716x7FheJlQ+h
         74CqSBJvzLasxSgw0cLt1QS6z8yNbaOSfWEN/+Yj2Ueq/bJCDud6eOZyDczM57D9EJrW
         Iy0OHArwfTwX87UFxAL4HilHFvJvZ4WX4SB7TSGpkRPiaqlugr+FoL+YiflvmD0czg7+
         xPs1A/C725VRWFZk1g5Sws3UEqLunQQ2f6EL+lgf1N4k3iUl3zeVuSDw5pL3vJlVbsCQ
         RtFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795055667; x=1795660467;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uM0JN8VUfPH6oC5vWX2xf2IB4+IT358j1Ch/z79GA5E=;
        b=BYwc7I4gvQmaSc0pgQcIQtZb8boPhlSj7LNCJ8Q3bV1STJAWESsu2N+vlt3S1pqhi7
         XH9vNouQWxDrHoQBzsP4QB6IPnEnSGEftl6bwlQzaXx97WKHX48CN98C89+vdHgaNvTY
         e5x0xiVSFVj9Eju1TuLwkfe5c5gbYf35LZxb9xnPV/q1RKj+X3vd90V/d2Aktmr54LVC
         PAP1DEFyUe5wN/ymnUtlyPISHKvdDrPdwpH3GF+TnWxacKx61CrAr7U48+n/8SchDzmk
         MDnn7JIpvC6t5Pdi2us8RzHbcPL0akgyqBJ95tJyiQ9yTt2/zcfm1/IYAYWRhw434INa
         EA3A==
X-Gm-Message-State: APuU4Z9NtBy/huHmw81Yga6GKzsdscySDOhszimn4zokGJ1Gr2REfU5R
	dYoCbZY7zQ5Q1egZMpAqEFu0/JDZBqCrD9hiDQlJx7H7mxkagPT3iuVF74YLBrC1k4PrMnwEhrX
	4brQ8NEWPM5CVHpzGx8xamYZumyrmbZU=
X-Gm-Gg: AYBFou18gdYzGk1lfrs1oYl1WpHP2FVC3myOg/trO3S7x/HtvrQ7Ji3mp/rzuj9dyYG
	ic8RNtq1SbhCMWT3b4LbcuBEIpA00kLIwdE+qJD1FV0OJZ/L8rmE0pFx4XyCGIJOyomrHV/m4GR
	ecw2RC1nkxBiQhh3kj4ymYQFnF9TFag3bkLh6p+PVoEAnt1KfNtS69LdVV1LE2ouahu9u3MM6D0
	bJ0NQnBowraap3AZtkOpa6A4JySwzypCREe41+qV8Fjsqb7fnusTVHhnVb/4wOkvmYiB9XkaZfw
	BGCQW+88N4I87DHo8d14aaaBazIe3dij3Lx7I0eMyx0qY5cNiDWT291CamAfxiBFg91yPtS9SOp
	C6uGtdcVnd28ILckBcBKNfNSE2PC+ahH4mEwvhOjFcTojHy7KrXkK65whRuQ5xuMi/tbppw==
X-Received: by 2002:a17:906:8358:b0:c51:282b:5489 with SMTP id
 a640c23a62f3a-c51282b56e9mr57464466b.3.1795055667022; Wed, 18 Nov 2026
 18:34:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-15-9eee2fe97a2d@tencent.com> <sashiko-outbox-221996@kernel.org>
In-Reply-To: <sashiko-outbox-221996@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 19 Nov 2026 10:33:50 +0800
X-Gm-Features: AclHuK9Yac_j-zeuFnMHQ2zFU_qaUoG-2sXXeJATZdyMK3cX3pLJ77pbVaVCnZE
Message-ID: <CAMgjq7DctjL5Mo3q7qmVTRTi0JNqYxfEynDE6z1qqp6MH+RnFg@mail.gmail.com>
Subject: Re: [PATCH v5 15/17] mm/mglru: folio LRU refs based active/inactive
 number accounting
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, damon@lists.linux.dev, tj@kernel.org, mkoutny@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D329020002
X-Stat-Signature: uqwzgsu8z6daztmtneao5gyrjr9ojxzj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795055668-311296
X-HE-Meta: U2FsdGVkX18BbgLm10c2XSvteVn/4HxZIp4on2t6vSM7GNMyqsRp2GSBq+yFuKNx840cQUtKYkjH+RkajlOdwDRY8VYkNEWxfaGgoafCGoT0nRH+kM9wpKCCbbZ9S8UV6IZds2eouZbrazRNPVpJGFjrlLeDl2C6jOKdWt5d0DsJCSfbuAAX61mvcNhA1o4jHA8u5U24DEALYlJM0YxMWCXrNrnBZErILdhkUYElxiWh9mBTtIwbuQiXPHpk4+KJCJZC8nfXHiO4ufkSHP/C0/bIXSILLRKYiVtoVb50kNeuIautvRHtdkk213KdTiApCOtr/Fssu0aM1o0GUmdh5Fv+u+oBsywNqlfHXS3EOUrRncHMTspOQb2EZOLqH6le4Ttki4JnhnCPoIJFFj6K7UQ45p7e0Hstn+zWbWfNe2SVx4Hoyd9OwAPuuVCZXqGkJSzfwqlgWCYZS8NcplexANS3BZ3nto6yX0Bwijbkj7J45vL6POc8Uc5YN3fpW+08T/zwPDRjbPz3H5kEzUJYdCB0b3ENqauJVEDWFoPMwtW8ppsf+8vC0CTi7pX1g42hhGgAHgINehekZjOPzQBazRila3ZLZYIqM20/dRFLDA7WfqCuGD+IfOxM9OXXS2C2SDVTeXdTixYNSV/KUL4fwusY/PQ+NEyn+JTJ6oPZYFvrDl2Os+xxh6YdpCtBMtoNZyU280oLpBuXJb+nNfgn8p4thdDfJspVykNn5sJcU3P3JCgSvGcnBgs7i8CKKUruOfVbwQmqLTroE0mdG7QQsO/0Rnde2+Pp4ypOwf1OGf6bQhl/PwtlqLZobeEfEj5KHCTnlksfoK7gx1IqBrqz/rH27NLmi50cALEijbK6iczos1AqD0Ew/6S5HBU31GCAFDv6jx5fM5mc/e9CAhzxyblJ0mJnT3+6FwsKYDGIjKyy+ffLEXmvS2GQLNh5x/GOOi5I3EO9N2j+fuHfMfh
 cz5dhZrQ
 zhhrXzUrMcZTSpbwTBWNKJboq5gwJkT9DQ3larfXCCnturfRK9TGoKxi8eJ9GxWIQQyA7NhWw3957ifVm+RBl6sMeD3Xv51NeX+Bvt9y/PLXedEQLwT3yO0tLYUYxN2a4hhgYcfskQ68zVi29ZwW5S+q3kq2r943uEiv0zLezYu+3H03Qknnbl3uEaMheFOuejUTEdGsIdl46SID7GHya0af7cvwmUMEtcceCPxxXO/AqvFt7RMtN1myUVyUDd09Czs/ciORIdNBbuwC1l5o/srj5oLeknqGyr5921Wyzq1aLZrDWcHAT3mcqjKv55N7qyvgw8Aq1cFfkatj0Vh+RDLHhlPqRschQTzboGYz9KIdQdHTcbrnmatAhI+P0wz8h/o7WhknDKCR/tMsOd8/XcNNmvDr2WhYJm1ibftf3AlGqCSjRlXXAZyG21QJiAEI1C0yfisrdXXifLp1LDrL+FjSV939tIlN/9KWk87S8UGnBjF7uWC/S4vHEM1cJ9+379p4ri0An62x1zWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:29=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/mglru: raw folio_clear_referenced() in lru_deactivate()
>   paths

This is the only issue from sashiko this time, and looks trivial,
which is a good sign.

> --
>
> commit b8ed2e873fb1f3b844c7ba1fec4ae00c0c04fb88
> Author: Kairui Song <kasong@tencent.com>
>
> mm/mglru: folio LRU refs based active/inactive number accounting
>
> This commit switches MGLRU active/inactive LRU size accounting from
> generation-window tracking to per-folio reference count thresholds
> (LRU_REFS_ACTIVATED).
>
> > diff --git a/mm/folio.c b/mm/folio.c
> > index 06c9cde834f76..3b5ae5b516504 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
>
> [ ... ]
>
> > @@ -552,10 +523,12 @@ static void lru_lazyfree(struct lruvec *lruvec, s=
truct folio *folio)
> >           folio_test_swapcache(folio) || folio_test_unevictable(folio))
> >               return;
> >
> > -     lru_gen_clear_refs(folio);
> >       lruvec_del_folio(lruvec, folio);
> >       folio_clear_active(folio);
> > -     folio_clear_referenced(folio);
> > +     if (lru_gen_enabled())
> > +             __folio_set_lru_refs(folio, 0);
> > +     else
> > +             folio_clear_referenced(folio);
>
> [Severity: Medium]
> Should lru_deactivate_file() and lru_deactivate() also call
> __folio_set_lru_refs(folio, 0) when lru_gen_enabled() is true, like
> lru_lazyfree() does here?

It's very trivial, the folio passed to lru_deactivate_file should
already have their refs cleaned befoing arriving the folio batch.
There is a tiny time window they could get referenced again, in that
case, keeping the new ref or dropping the new refs both make sense.

Oh and since the folio is offlist, it won't cause any statistical or
counter issues either.

So it's not really a problem, it's fine either way.

