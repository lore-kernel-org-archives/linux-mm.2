Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66786606BA72
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 17:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Cf/fFIUN
Received: by kanga.kvack.org (Postfix)
	id 780C06B00EF; Mon,  2 Nov 2026 12:27:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731FB6B05B1; Mon,  2 Nov 2026 12:27:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8956B05B2; Mon,  2 Nov 2026 12:27:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2D56B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:27:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8E7D4010C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:27:15 +0000 (UTC)
X-FDA: 85390860030.05.E07AB4B
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE81120013
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:27:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Cf/fFIUN";
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793640433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKhnWPcmdK/vHA3FEHI8MrqzJldnHSNLvozGU1Xht1Y=;
	b=iWGNAihVcSn0X4PvpdNrLi2JN/p/TcGjexx24MG/tYkKA1/V6WBTHkuHoURCVRLiSMzUUa
	Y3qDxILUj61ZeaxBzOYXVzCviPqOqJNoS/O1LFibatpjWjlezBe3sv3qs+/C9W4XYV7Xwe
	OcRh1CUiVN6lhYid7Y5jX0rYrPgftR4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793640433;
	b=dVSJCgG7Ic7Rd6s6BvvasWIp+lvthKYaTsS7M4bT81/BHPhjKnahD/OCvBhDVhbQMBsP34
	HxU2ty8OxPnrNzGSotUV5glproGxgkPuq+R8ePSXxLOy0IcqnFfg4rDMDda/MS04j15Ppo
	kzzafC7YzJsov7L/gXVyLkbi5xJk1Cc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Cf/fFIUN";
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b4883643ccso1056950a12.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 09:27:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793640432; cv=none;
        d=google.com; s=arc-20260327;
        b=SrCmkaf08BPOJTWPp6eeCTeoT/oecVPFhE8mUKwqHVVeTRaQOeIZQ1K4j3Tam3dxLY
         Kori34YCcoWr4PogCYghCTXb4/P7p7uWA6a9xXS+WWDcicqTxDkvNz6hf/cwLXOYS3tf
         LyZ3Mn8k/8WSLMF4P2kKJ0qj+ueJzG+Ll9rbcH961cPzCRimH1tytmVY/rdEJNS/MEL2
         UMgiyVH9yMcZo+5R6GZ1nTIyJscw/5u7snMK3ICk3oPP7W5B9qIdOLr4sSEQi42xp9LL
         45rDF1w5sXlGgnhBPOtefkuzLeQgBHfYKg8fJlcnoXM+zIIhWvTIRAgSV4RxcdLrUqow
         Ai3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OKhnWPcmdK/vHA3FEHI8MrqzJldnHSNLvozGU1Xht1Y=;
        fh=0vCb2abCKfF1uOn9MTQqrDRLu73kmwPbllxC1LoiAGM=;
        b=oM7BB4IkYJwJb4DxV8r9jMUrdn9r05R+zgBpdBTAGy9jMQ9hULdTLChclh9KoWNMyS
         yoissWUBPWM3q0O/5RPOJhzEExD9ZdZuyyyfGWbOEDGXYUYaCJoGuFuZ+kl6x7EKzzo6
         7wqeDXfoyEK9NA3S8M/mNviPHXAy1uHsgxWitYo496cwQioMn509nqtLorlFCPnnnHqe
         3IGc6bfOC3ujZZOqBAGiXqkPq+a0DSbpYGth1sG8CgPOZyPzT2oM6SCnYE1E4qNLpzBk
         dtykva9e7bnc8CylAiF1GfDm0/HCzE7wo+196B/Mv3ouuTn93wuSxTEeCFH0kfxDC+ey
         VOFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793640432; x=1794245232; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OKhnWPcmdK/vHA3FEHI8MrqzJldnHSNLvozGU1Xht1Y=;
        b=Cf/fFIUNqmFsy35IY1izsFNuqECRRSJ5FMIv2KIB0GnArc1fY9oS7hpNTj0mZmvABT
         UuAfIMieh+cjlFP202iAmRVK5Oo8z1z2tQGxWYOIK1txQZoHEvQIwbVvRZN/LtCmX0jM
         sACND74o09w61835DykxaiPxmFAwgUSy/3J5mPrZ7KPwvqTj/N3S6nCb5O24l67+YZtp
         HkM1pFewPJF/mv1Z4dru26jx8W9fsMOKT7ILs5U/HA4Cj9wC9CT54wNLAZc0fsY0k9a9
         2P2v/OlQsh15NM4Y1ck/kws5qVhXE1JCq/UuNJPtNPBoUDUcFsQ62IxeK+OyE8AK+5zu
         HGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793640432; x=1794245232;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OKhnWPcmdK/vHA3FEHI8MrqzJldnHSNLvozGU1Xht1Y=;
        b=ERtTnI2zAAFdGw1TTZD/ecrhugyYg9Lk1HTgHsIwle+M780QQvM7hy1n8tMmwcR3lk
         34QBK8S49RmxCEpChKmi/cATpKIfUQyfAy3G55oO9B5JHVYrJA8UymkKhE8BCLHSjJvR
         0CkiAMqOx2py1GseVuAMsy+1cA4tpm6mK7ylZAQT5+X+2pFG440n3L2DMp9JZ26sqrW0
         XNP7AL5GYCT1EIM7DFxzqWsD2i7cNegWlP5aDH4qtpMxpqJ8NThgL8aAnk+rceGrqTLJ
         CTMYpSC7wxDHQoN6QAIid1mWDnC8jjwO1yAqUM4unXhKHukoXuf3lcDJxo1rnUVF8o8S
         Lsvg==
X-Forwarded-Encrypted: i=1; AKwUvBwOUb6/+YpylExFZUMXBC9X6EiTY7SWWGLdMzB7Nqh+hSGngNuHunC6iD8O/D+AHjmkFE1KUY6tcA==@kvack.org
X-Gm-Message-State: AFq9FYJoESKJpQ+l6qAn5LVwmvAgps6wxiTYtaybivro0aMbc9T9dkr0
	pAFjh5ifJyUGOV9mBodXqpgITJSJrmSlyf7+hJcd/6H54RJHmCsThUJz+972KHDmxXMLWMxx54q
	aF3oqWSDAvbzzznXlniZopektsr1EhPA=
X-Gm-Gg: AYBFou0vSngGSE18dIjmbbfWdCexF1FKvJxSckYEIfbUNtk0Qs0k9ArsQzWTVZYCzkV
	//+jOrbz4TK/weE6HZbjFR+WPVUufMMWTAclT2q/4hZlZL1uU35aW+NWPagl4oaZYKS+RJIl58n
	F1UXEIyVliKb7YS3p8LykHxlzxLkznzfRDMLfeYdtmMDOIGUjRLxsKZ68e0e9PQuYIfxICKvmua
	GaUGcAb7naeHzfQwFPyQZITesL52fPk/i2LsT+Pz0z3hC3Msb2rzlXpX34LPA62tbIoA9kKDL5T
	lHZ5VAfk6vB7AGKYiC4AwRy8NL7sIXe12oMWM14a9wqX5s67dkVoJRUGPLNIAB6QC6t0UC8TeaV
	M5KHVMT0Elcgk/DD6BBdzyVDfZYEHeYLfUixXCZqVyXchXToZulzX2bPRwo8ccNPa6YfDoz1dMZ
	VYtAn+NU+sfdd8O1A=
X-Received: by 2002:a17:907:96ac:b0:c49:b8ec:a9e3 with SMTP id
 a640c23a62f3a-c4ca7abe67amr1025275866b.43.1793640431886; Mon, 02 Nov 2026
 09:27:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
 <20261030-swap-fixes-v1-2-73f73a59f2fc@tencent.com> <auOz00OGB_8dgniC@cmpxchg.org>
 <CAMgjq7BYgXLheXDyc=p2mNgxdP3+92v2WHGiXiweDrsiYQ0u2g@mail.gmail.com>
 <auSWtJzFQ7KdElKL@cmpxchg.org> <CAMgjq7AJ0uajpVM+Kva5=_EXtmaawYR8TJQ6RdhrP7+NUZDx=w@mail.gmail.com>
 <aujA7X0IPvtRTmFG@cmpxchg.org>
In-Reply-To: <aujA7X0IPvtRTmFG@cmpxchg.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 3 Nov 2026 01:26:35 +0800
X-Gm-Features: AclHuK9XVquaypx5VfISqYnLO_GBcG43AfTae6Oi2KBrUZzp07UCi6QeSfvyFpc
Message-ID: <CAMgjq7DZYKXGw1McsDT345HS4BNqa46xte_dTJia6EMv2Dy6jg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/swap: account synchronous swap reads as memory stall
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@lst.de>, 
	Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Usama Arif <usamaarif642@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 4d96kqsg69dk3xnwo3m4x83cmfw1ofxp
X-Rspamd-Queue-Id: CE81120013
X-Rspam-User: 
X-HE-Tag: 1793640433-721599
X-HE-Meta: U2FsdGVkX19XC7tfwHjVbSOolEWP9g75SKXr2KaHm0i/uShzgn6ACGSEzxMbkXlgz4FUbD6pYduhJRjj632R/DyJLgV9v5cqfkvw+j+RV7YCeQ40UnoO39rCq0v3pyfzwbfLyOf0tGF9dc4CTx12nphsYhay/OpxDdmwXzr3kkMJHU9IUlvuD6p/UwVELI60fxkoAPbliwG0cKoeemQTZibKKUWEf2Y3+bjEQ9MZ+SLvpo98n+ocQyTwAeCfVbfTNoKWIS71tz1EVPp/Vx8grkNSjsX6owah0PV4HpR/EZJc2xknadeTV+wOg7U/is6QfYz65gAMjjncSGLj0WVs8DhLelesYAJ0Jh/5RdAelj/xcdM2mKQY/X3vFu+K6p7Z21J3HmrvDTN8CgsqUuNvjTtuZVAcbOezTJQUFYbek+/F0z7r2ZtV0zqud6qK3CUp5IIdFR2K10ceQ3YRKdrs+/e6RE0vgreOCZ66ZEan+NDZcu38xHM3uVOiyVQ7DagMKpfKq9IgJFLGnM8GM8xh7ayB2VlKwEzKSl/BSVirOiJgN0fx3tUa+QA4NiKr0Hgn4KY16V283msvRYR88C/XzR2KKRh6LNiXXKKLc6afAxOWxpJzfzNbDZ4gvF4RGNuioofcDkqYSzKvHf+Tyu+DfWUupWwGHmJaPcqz9GE4iCXLniqaquC9rNQUxkbPcjynofoB+QUKZhpeaTfdNsCMKudNy6GuNmvZQ8SjFLmN52BB2u6f6mDARSDSf93fkTdl2juhsCNFR9VRhjle2R9IzwLqzGtieyDaX5rf5oBMXQzy00P6MN/pbG1rtrBsYXTG2PqXid+U5Ku6rGZNHr0OL/ls4QP5+oPB5Eltdi/gZcGbpaTjZF+062ywcA4VtqUFNMTW1zoWopWPb1FSEFsd0U7MrR46GzoulDY8+rzMfk9xH4UQleoneKB/qJBOfEhLNNNwODafsY16KN5jSen
 6L1Z8eYI
 K7ZU4CGbLztr8PmyB9Su0yMhZyhZjOQly6s1hr71shyuKrijKfWPG4/fXfnmmZlZH5euHTuc4BSycTwVsJWCataZtJy2hHnufGZaGwNK/AKRW5bJV0rNDopzbpvyVlQDBrziX9ajXwhFtpP5spXe0vU/Xy/AbXWhWP9786EaHfFMahopLkROK6G5oTIFdTvtbPurJXFLK/ER/xMFn38UIRj1c7vjI5757jNXbWMgBTnXIZ2l8dbX6jODKsB1pds1Q968wRPcC5kapPBuxd9y+RtVXq5VoU2lv5+2mIuCXlVurFCyi3C6Oq+3SxxFe1NWw0YZrL79dbgEFeJAsEkoXccwMrsBUo1s6nyhGgsO5eyI9kYuobRRCKHBhvKcA+5jvdwGhGq4PMuVFAEzgW0i70HGneKLX9IASciqxJIUHSpWW6KaFZCBTkd/C809NuQGZr4lV11gBIObQTB8MaLnxDvrO6Wy34beyfVsOcIIJReJvbnbqcYfxIDuJQK57LhPkkHzjFH/KWP5YVfHWc/4sxy4owZK9R4fHgKSvr7x/0oAvkhp1FR4Xk28YENWxNg6G/DXPxIL59UtFrNMm4Yclg8cpAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 12:57=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Sat, Oct 31, 2026 at 04:00:22AM +0800, Kairui Song wrote:
> > On Fri, Oct 30, 2026 at 9:08=E2=80=AFPM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > Hm, I think the only option to avoid this would be to split the batch
> > > and flush more frequently, which I'm not sure is worth it. The batch
> > > size is only 32 folios...
> > >
> > > diff --git a/mm/page_io.c b/mm/page_io.c
> > > index 22e5ac1d298f..806cfe633a95 100644
> > > --- a/mm/page_io.c
> > > +++ b/mm/page_io.c
> > > @@ -207,6 +207,8 @@ static bool swap_can_merge(struct swap_io_ctx *ct=
x, struct folio *folio,
> > >
> > >         if (ctx->sis !=3D sis)
> > >                 return false;
> > > +       if (rw =3D=3D READ && ctx->workingset !=3D folio_test_working=
set(folio))
> > > +               return false;
> > >         return sis->ops->can_merge(folio, prev_folio, prev_folio_size=
, rw);
> > >  }
> >
> > We are in a dilemma with this change: if it fires frequently it breaks
> > batching but improves PSI accuracy.  If it doesn't fire frequently, it
> > has no negative effect on batching and performance, and it isn't helpin=
g
> > with PSI accuracy either :/
> >
> > But after a second thought, maybe we can live with it by having both th=
is
> > posted patch merged as it is and appending your suggested fix: the two
> > kinds of devices end up differently.
> >
> > For sync devices the batch is now always one folio, so there is nothing
> > fancy, everything is accurate.  Readahead batching for them only happen=
s
> > on the MADV and swapoff walks, so the cost is limited.
> >
> > For async, the window covers submission.  That cost grows only mildly
> > with the folios in the bio, block layer and dispatch work, unlike a
> > synchronous read.  And the previous per folio accounting was not
> > exact either: in a single threaded task, the throttle or cost of
> > a non-workingset readahead folio pays is also holding up the workingset
> > folio's refault, since the task cannot start the next submission until
> > that one returns.  Same story for delayacct.
>
> That sounds reasonable to me. Zero benefit to batching on these
> devices, so no point in taking the fuzz factor that comes with it.
>
> > And we are missing the completion wait either way: if a fault finds the
> > folio in the swap cache with its read still in flight, it blocks in
> > folio_lock_or_retry() in do_swap_page(), which no window covers.
>
> It's there, if you drill down to folio_wait_bit_common():
>
>         if (bit_nr =3D=3D PG_locked &&
>             !folio_test_uptodate(folio) && folio_test_workingset(folio)) =
{
>                 delayacct_thrashing_start(&in_thrashing);
>                 psi_memstall_enter(&pflags);
>                 thrashing =3D true;
>         }

Thanks for the info! Good to know.

> > So perhaps we can live with it for now by having your suggested fix
> > on top of this posted patch? Some comments could be helpful here and
> > maybe some further improvement is needed.
>
> Yes, I think that plan works.
>
> Want me to send a proper patch with changelog on top of Josef's?

I've tested the following code on top of V1, and it worked well; it
seems there is no need to move some functions or am I missing anything?
How about I keep your authorship and just send V2 including this ? :)
Any other suggestions are welcomed!

diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 57ac6c703f68..4d9ddd754712 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -17,6 +17,17 @@ struct swap_iocb {
 struct swap_io_ctx {
     struct swap_iocb    *sio;
     struct swap_info_struct    *sis;
+
+    /*
+     * Pressure accounting window: opened by the addition of first
+     * folio in a batch, closed by submittion of the batch.
+     * Values below tracks per-task state, so the task that opened
+     * the batch must be the one to close it.
+     */
+    bool            workingset;
+    bool            in_delayacct;
+    bool            in_thrashing;
+    unsigned long        in_memstall;
 };

 /*
diff --git a/mm/page_io.c b/mm/page_io.c
index 83ed0246ebfc..7d45e5acb951 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -470,31 +470,45 @@ void swap_read_folio(struct swap_io_ctx *ctx,
struct folio *folio)
     struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap);
     bool synchronous =3D sis->flags & SWP_SYNCHRONOUS_IO;
     bool workingset =3D folio_test_workingset(folio);
-    unsigned long pflags;
-    bool in_thrashing;

     VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
     VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
     VM_BUG_ON_FOLIO(folio_test_uptodate(folio), folio);

+    /*
+     * A batch this folio can't join has to be submitted before the
+     * pressure window, so that each batch is billed for its own read,
+     * especially before the possible lookup and decompression below
+     * rather than making the batch wait for them.
+     */
+    if (ctx->sio && !swap_can_merge(ctx, folio, READ))
+        swap_read_submit(ctx);
+
     /*
      * Count submission time as memory stall and delay. When the device
      * is congested, or the submitting cgroup IO-throttled, submission
-     * can be a significant part of overall IO time.
+     * can be a significant part of overall IO time. Reads are batched and
+     * submitted later, so both windows stay open on @ctx, and are closed
+     * by swap_read_submit() after the submission, also when the batch
+     * ends up with no folio queued.
      */
-    if (workingset) {
-        delayacct_thrashing_start(&in_thrashing);
-        psi_memstall_enter(&pflags);
+    if (!ctx->in_delayacct) {
+        delayacct_swapin_start();
+        ctx->in_delayacct =3D true;
+    }
+    if (workingset && !ctx->workingset) {
+        delayacct_thrashing_start(&ctx->in_thrashing);
+        psi_memstall_enter(&ctx->in_memstall);
+        ctx->workingset =3D true;
     }
-    delayacct_swapin_start();

     if (swap_read_folio_zeromap(folio)) {
         folio_unlock(folio);
-        goto finish;
+        return;
     }

     if (zswap_load(folio) !=3D -ENOENT)
-        goto finish;
+        return;

     /* We have to read from slower devices. Increase zswap protection. */
     zswap_folio_swapin(folio);
@@ -506,13 +520,6 @@ void swap_read_folio(struct swap_io_ctx *ctx,
struct folio *folio)
      */
     if (synchronous)
         swap_read_submit(ctx);
-
-finish:
-    if (workingset) {
-        delayacct_thrashing_end(&in_thrashing);
-        psi_memstall_leave(&pflags);
-    }
-    delayacct_swapin_end();
 }

 static void swap_write_end(struct swap_iocb *sio, bool failed)
@@ -725,10 +732,19 @@ void swap_write_submit(struct swap_io_ctx *ctx)

 void swap_read_submit(struct swap_io_ctx *ctx)
 {
-    if (!ctx->sio)
-        return;
-    count_vm_events(NRSWPIN, 1);
-    ctx->sis->ops->submit_read(ctx);
-    ctx->sio =3D NULL;
-    ctx->sis =3D NULL;
+    if (ctx->sio) {
+        count_vm_events(NRSWPIN, 1);
+        ctx->sis->ops->submit_read(ctx);
+        ctx->sio =3D NULL;
+        ctx->sis =3D NULL;
+    }
+    if (ctx->workingset) {
+        delayacct_thrashing_end(&ctx->in_thrashing);
+        psi_memstall_leave(&ctx->in_memstall);
+        ctx->workingset =3D false;
+    }
+    if (ctx->in_delayacct) {
+        delayacct_swapin_end();
+        ctx->in_delayacct =3D false;
+    }
 }

