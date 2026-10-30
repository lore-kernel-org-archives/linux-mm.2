Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FD0606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 11:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zS7DcJlt
Received: by kanga.kvack.org (Postfix)
	id D5EF66B05B8; Fri, 30 Oct 2026 07:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE21A6B05BA; Fri, 30 Oct 2026 07:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B830C6B05BB; Fri, 30 Oct 2026 07:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FAA46B05B8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:17:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E362A0673
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:17:32 +0000 (UTC)
X-FDA: 85379041944.08.2973999
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9F63A1C000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:17:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zS7DcJlt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793359050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsvpoCq67ikFM43Za6bLeWpM8Cql/+fjWhbCUzkmcmg=;
	b=UQK6Zkkh//OGzIZhNrfDgazQmCp0xmH2k0yaRH7AF3HxPmM3dDxtsqEsRsKEv/1FzYF9xf
	Iji2Z5z5TcRUzznFX3OQyxJlvozL0V5PtsAdxXpHZvA81p+xm+x8Jpd4R2rgy73kj6ly0X
	iBksgrV0DkNlO2rJJBPtB0LoKCfjPtw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zS7DcJlt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793359050;
	b=0X56aRvAcREUABCzZBt5bgkkwgTKRiWbqS74qFsUvkVnfS9OE60MZAJYAxPLGJhjefCZa+
	50bF1X92k4QPNcwjN0TdlAFxENLpVuuq6v0bilkSJFJypNJkAqh5mptRc85j7EkFUnYGc2
	bdCTQ+PIE+nK/ssAC+FJOkdZ5sRYtLk=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4caf490606so43330766b.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793359049; cv=none;
        d=google.com; s=arc-20260327;
        b=j1NqBYW0PIrq4at+A/hi0S+DGP46SPoEcSbPDmGRkFfl1rDPTLa1cXGYuy3qsGo+W8
         cJdA7vxFgsFkZsAfdF6QMjXGoe/whRhhR24MUdtkd3sncmQouJABy1jciScNfIMtx47J
         oS3uvzVOBgtwUUZXHVnyRMHMkOtV6QXdA0la2uYnFh3BQgkXlkXCHmUZd41Er5/LDfgd
         KkWaJ/Wqo+CNlYKW6xbww58xZDWjdPj+5ICiDgyeq68j3CfJaEHGNl1beF/LzyYQF30a
         leIBcBwYI6BGXxDfQ1WguaXl7rfPucvSNrokYmqNiWBPhJQEv4tcfpR9PI9GLfeRnLR5
         ADpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nsvpoCq67ikFM43Za6bLeWpM8Cql/+fjWhbCUzkmcmg=;
        fh=vtQSii13lEE6aN3TzzcEhV6Uhpfw+Ho0XXBBbxCLyRY=;
        b=qOp0M3v3IANxEncparHIusOJSkwyVeWSKfsDi6OQME5/T7QlytnfX2mm8Z/yuuYWRR
         YwRGLNd78Ccn17R1HLG8+w3ps1oGi585mq5iuMgql4aWZixCqOrcIDIFksE/2paMYjaq
         UAy69Vsd5dqUAy7+NgtXFQ+mDziUuDmBrObCeGIM/8TpITLX2w1mpOVLN39xcgTsNeQM
         1P76DjfNi+OV9KhOREWu/js2N152yGXoc2uAQ6fohC5XIvSphyeh6RT1Fm0ciBjyDA5Q
         ffKK5mYoAu5QC5MdiwQ9ogGdm7rzRQVbSFi8zVlozv4sEaWg89CCJXwjeLCCckvW1jrE
         GuzA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793359049; x=1793963849; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nsvpoCq67ikFM43Za6bLeWpM8Cql/+fjWhbCUzkmcmg=;
        b=zS7DcJltRinQDXUoe7I5sfVu86PjqCfMZwHUktQ9VJpv9x9WwMUGOFZFByl+A+iJOr
         68x7oZHUm9rldbx7yOuGrsE99Ew99GM3ncjAB8gNq00G6gx3zKJy1pq2W5ZP2fK9K+F/
         1+U8x5/Mz2gOjrNi4VthvTK2cwQD/pHRH9lGsS9R3WY9Nr/aAeW10b1cw8pDi5tzKDpL
         NNaDI3lqwUsAi6lLuWb7rYo6UqaJYwFZRG/hXekmshiySu2RO8L7gDnH2JbxlH+t9l14
         wLlwKMqO77v9xJmqWzDSS9DrkemeIPT0bgMBy3msH5BbAJMA95zkPP36V0PsnoFf6JOJ
         yvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793359049; x=1793963849;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nsvpoCq67ikFM43Za6bLeWpM8Cql/+fjWhbCUzkmcmg=;
        b=dbqkiC8lBlDeuUY+o43BgevQh9XzdCHA3+Ir33iXdzOJSYtKrNU1nNzgSXMblI0TNB
         fNsWKR7NdS65PCs22KNbgo9kaOL7oN6gUPXWbWtLTyrXTU3X/mMViuqdyCQvpoTa5d/O
         Ud9wuD7GgCof+Go/EC/YsbeJg4ESdWOEOcm4BsuhBDpAscjcCrTL6IitQ+sbo5GSoGcl
         Sw2AIaxfGV0CALQawZF9ESN535G4eLZPN0/+Zvt6rql1xQ5IfYsWi10pV5axuXLfp4ni
         +DrPhV6Bg2cv3Jmpi+n0GITDZc90x8dNsIdgAt5shGCAwN+XtO4MfDAl/nwi6lErb73b
         GhCw==
X-Forwarded-Encrypted: i=1; AKwUvBz8Eup1l75M7iOwMmfOlU9t/wpHPcPUU3QB6JXAqZGgLU8t05yNWUCXzz4RMivixTWHJBxagdOyGw==@kvack.org
X-Gm-Message-State: AFq9FYJo/BTvR1lOvQpeZBHu3firMaAsLQn5964qM7kVjMjfCBFQVhFj
	tdJeUHo7g9FNNo/t2peg7mUdFJeta3cYMRL6zUi+ZZv+33blQI9XUOyAxITqr4qVnIUM7/wxC3S
	guROLJ4N0mAEQ5C6+VNdL57JmHAwhcG2mq0wzc5Y=
X-Gm-Gg: AYBFou2m/W0g7NFOHG0VEnecK8k9dYVX2bFecjFcOtLIhUaamv2ieL3reNqhWLkmmKK
	L/2RImn+zlwg6xrAXsg7OeXq0FSL4e0o2TJ92TxvY3tvnj76l2ShA8C33oc7JkIFKNbMOcQnMWL
	XyEls91g1+g24uJRtmvwWAMFcc4iv7e9MOKayx9/5pRzh+NjyS0k+VwtHxgr4GmRnpQIx/dRoLB
	N/a2aRm1EqhUflQl5LIJzUjwc/C7wS9R68SCwk1P1ydrLg4g/N9MJeeadI1wnF4t3sLTIvo1E34
	oIWcBImzx4AvjT71JOCSsSYyZDyfgWxhOhRSxp9IFmSX/gk3+ZfIZobRtUvdyhOC/lYxADDxi8E
	U7eVH640uz2scBNhHVce6wghaBpmK6T8JvIRZDGH+qqub9fjhgvKaV5bQh1NBhvZ44PuOWA==
X-Received: by 2002:a17:907:94c2:b0:c25:4f7c:8ec5 with SMTP id
 a640c23a62f3a-c4ca7a84587mr190103666b.23.1793359048873; Fri, 30 Oct 2026
 04:17:28 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
 <20261030-swap-fixes-v1-2-73f73a59f2fc@tencent.com> <auOz00OGB_8dgniC@cmpxchg.org>
In-Reply-To: <auOz00OGB_8dgniC@cmpxchg.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 30 Oct 2026 19:16:51 +0800
X-Gm-Features: AclHuK_QtoyukUCJkCFO0WEKLkvtcn1cotvwCTndLO53R98gepDq_gXzXwzOz4k
Message-ID: <CAMgjq7BYgXLheXDyc=p2mNgxdP3+92v2WHGiXiweDrsiYQ0u2g@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/swap: account synchronous swap reads as memory stall
To: Johannes Weiner <hannes@cmpxchg.org>, Christoph Hellwig <hch@lst.de>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F63A1C000D
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: uhkex6awzxow6sabhw9grfhw14n74ojk
X-HE-Tag: 1793359050-993840
X-HE-Meta: U2FsdGVkX19nr27FS2KWM180aNdKQSZ4eO7D9SRjfO0UdooXo8G6Lqcv9ohda0ed/gg0pFfaNTU1q3JXcRrSgl3Z/+q1TOhzNtX15CDlpJj0sX98BBEB41q7FIk5yiDCHU77WHfQvGqiwEDiDmBk8uMCut8qsZlhV2iJo0oohFRvTB1hjSFVjThfHy2ph/JIgcRGsX+/ZMxkYhlx4oVBuodVbaSCBpEH/4C7po38lmKlqRYOXcSXbugiZAvZMnBveRruWs85biH6lQiEoLVjH1x+mlcbkTfGzhDGecCQfGLLfF8KkCF71xiiw8/Yqq8sfF42Cp4iTl/jfwUnyjNUuyFWeVPZCDbDoDzNbRNYaHEExZP1jE5BBYKDE2Z2Fr32iBVOZ+EmRZTExk0+TEeVhMxVj3NIlO/rl61HtPl4hEgyO7Yt2f8YF0saoNcYYtKU7Gs+9af6+DS/0yPtoDwP+2wMksPxhPccf30P39JsZyn9gbGYyCA4GuvkhhsI2PVbAorSSbs57aJQamJtyLDDNjADAumK/tyWRcWULVQgv8t/OQXpOqsxp/4c1ZJoz4ZAm+7xx9DJMLRfzko5SJgY8TGps9SwRMRhxWfKHJeKW4D+X8XXTDYQe2Zqk7w4MyCZf6oo/KTV4GHeDJnxqv3qMWCfdviaeHf8Jkh2k5mpW3bMHAHmaSGdHoEAbz+Q7ScXDUzOaJ0/BUc2peoMKWeSmaZjZ5V1j0mEZsrHq5HGEtdWzdMMDBY4AA/s/V+itKfGqY3//U0P2hYnX7OWXkP8m8jIEH9W287DOWRiMWBINCJviPGBKnoRJdUxozaOWjCQTVoSmI9X/orutiv1ROuQyP6K3Gk994TSese71QGgyg1fQrLW14IcGr9L/B9LpOBzLCTzkiYI8h85vF/WqqTwqQr+LwF4djjWDw509c503UXHb58o0y8K7Oi8gsWOiF1UeYXVAT3LqS8zYuFRvsH
 7pgVB66F
 pbeXu+32bgBRryyMZZHG13yvqUaUTi2LgkEyylMXc5OOv5jOFpl2T8Ngc+OjLPpaRcoVgKZA9zbITym151t3XjILy73bctPxfwtwYRMvQsqQTos19gsZIEjP5AB1wNdE/XWLHeClm5+lZix2CvHNlzB9YHRkPNwJSwnv1kK32R4N3Fbf+Q6W9HVDhyMD2lIg5B11uUf2x2D6qN/1NTSka6DxhBbO1J/M9yihVwLEb6cBB3Gt7GBwtCp+eON/4kW7osY2KohQE++741C46yp4B3biOwbVpZ496W/gTfJ/6N0yam3qPDl+53xcHM7/Su9g4hZ8xlAi9pKY8CQr2o1/uPwGXGy7B2INXQNzSA75luTXRW9IiVSKpZCi3xRVKsAvfC9rPfHqNaoT7N7T4KoSJjkRqzCqbg+AzAL9k247pmW4Db5ZlKgFz7GDe1+CiPhoXj9G9n96d55V7Kp/kD1+bR1KRIfHnyxx43nmLp3Y+0EGaj70pNV8NZfYaBc60vxPlUDnc0UP0+i153Vt8Xl2fz7cc2+GdKNjt1jWZs3pxGIdgHz+0Kua9MRJSVBl+blbwQIoAYmNxRYyeFpO/ZH4YvE6r05a/JzjdtNE2cnCqNP3G8WOlldJfIzE3A2+jKZ5WQwAgVejULyUkZaKKoo/KL1ukvLdgzrK+uMCeHn0TfXYVu4UGWzz4k+8+t0t2FxsZvU96
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 5:00=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Fri, Oct 30, 2026 at 02:31:42AM +0800, Kairui Song via B4 Relay wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > Swap-ins from SWP_SYNCHRONOUS_IO devices such as zram are no longer
> > counted in PSI memory pressure or in the swapin and thrashing delays of
> > delay accounting.  Refaults of the workingset from zram, the main input
> > to userspace OOM handlers like lmkd and systemd-oomd on zram systems,
> > become invisible in /proc/pressure/memory.
> >
> > swap_read_folio() opens the accounting window with
> > psi_memstall_enter() and delayacct_swapin_start() and, per its comment,
> > means to count the submission time.  For synchronous devices the
> > submission is the entire read: swap_bdev_submit_read() does
> > submit_bio_wait() and completes the folio.  Since reads are batched in
> > a swap_iocb, swap_read_folio() only queues the folio with
> > swap_add_folio(), and the bio is submitted later by swap_read_submit()
> > in the caller, e.g. swapin_sync(), after the window has been closed.
> > By then the folio is uptodate and unlocked, so the fault does not wait
> > on the folio lock either and the read time is not counted anywhere.
> >
> > Found by code inspection; not reproduced.
> >
> > Fix by submitting synchronous reads from within swap_read_folio(), as
> > was done before the batching, rather than from the caller.  This gives
> > up batching of readahead for synchronous devices, which do their I/O
> > inline anyway, in exchange for keeping the accounting simple and in one
> > place.
> >
> > Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O"=
)
> > Assisted-by: LLM
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Hm, this isn't a complete fix to the problem described. IO throttling
> happens at submission time, so there can be significant delays on
> async devices too that are no longer tracked since the culprit change.

Yeah you are right! Thanks for the heads up, not only a sync isssue
indeed, async devices are affected too :(, throttled swap fault also
went unaccounted.

> How about keeping the accounting window open across the batch? Opens
> on first read, closes on submission. A batch with at least one
> workingset folio is "contaminated" and the whole sequence and
> submission becomes a stall. Would need to pull the !can_merge flush
> out of the batch-add function to get the accounting window right but
> that seems reasonable.

Won't this cause an amplified PSI reading if only one folio in a batch
is workingset? Maybe not a big issue though.

>
> Something like this:
>
> diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
> index 57ac6c703f68..6e45c9204482 100644
> --- a/include/linux/swap_ops.h
> +++ b/include/linux/swap_ops.h
> @@ -17,6 +17,10 @@ struct swap_iocb {
>  struct swap_io_ctx {
>         struct swap_iocb        *sio;
>         struct swap_info_struct *sis;
> +       bool                    in_batch;
> +       bool                    workingset;
> +       bool                    in_thrashing;
> +       unsigned long           in_memstall;
>  };
>
>  /*
> diff --git a/mm/page_io.c b/mm/page_io.c
> index c6824fcd483e..22e5ac1d298f 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -197,6 +197,19 @@ static void swap_zeromap_folio_clear(struct folio *f=
olio)
>         swap_cluster_unlock(ci);
>  }
>
> +static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
> +               int rw)
> +{
> +       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
> +       struct bio_vec *last_bv =3D &ctx->sio->bvecs[ctx->sio->nr_bvecs -=
 1];
> +       struct folio *prev_folio =3D bvec_folio(last_bv);
> +       size_t prev_folio_size =3D folio_size(prev_folio);
> +
> +       if (ctx->sis !=3D sis)
> +               return false;
> +       return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw=
);
> +}
> +
>  /*
>   * We may have stale swap cache pages in memory: notice
>   * them here and get rid of the unnecessary final write.
> @@ -218,6 +231,13 @@ int swap_writeout(struct swap_io_ctx *ctx, struct fo=
lio *folio)
>                 goto out_unlock;
>         }
>
> +       /*
> +        * Don't hold up a batch this folio can't join for the zero
> +        * check and possible compression. Submit it now.
> +        */
> +       if (ctx->sio && !swap_can_merge(ctx, folio, WRITE))
> +               swap_write_submit(ctx);
> +
>         /*
>          * Use the swap table zero mark to avoid doing IO for zero-filled
>          * folios. The zero mark is protected by the cluster lock, which =
is
> @@ -322,32 +342,15 @@ int sio_pool_init(void)
>         return 0;
>  }
>
> -static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
> -               int rw)
> -{
> -       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
> -       struct bio_vec *last_bv =3D &ctx->sio->bvecs[ctx->sio->nr_bvecs -=
 1];
> -       struct folio *prev_folio =3D bvec_folio(last_bv);
> -       size_t prev_folio_size =3D folio_size(prev_folio);
> -
> -       if (ctx->sis !=3D sis)
> -               return false;
> -       return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw=
);
> -}
> -
> +/*
> + * Callers submit a pending batch that @folio can't join before adding
> + * it, see swap_writeout() and swap_read_folio().
> + */
>  static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio,=
 int rw)
>  {
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         struct swap_iocb *sio =3D ctx->sio;
>
> -       if (sio && !swap_can_merge(ctx, folio, rw)) {
> -               if (rw =3D=3D WRITE)
> -                       swap_write_submit(ctx);
> -               else
> -                       swap_read_submit(ctx);
> -               sio =3D ctx->sio;
> -       }
> -
>         if (!sio) {
>                 ctx->sis =3D sis;
>                 ctx->sio =3D sio =3D mempool_alloc(sio_pool, GFP_NOIO);
> @@ -460,42 +463,45 @@ void swap_read_folio(struct swap_io_ctx *ctx, struc=
t folio *folio)
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         bool synchronous =3D sis->flags & SWP_SYNCHRONOUS_IO;
>         bool workingset =3D folio_test_workingset(folio);
> -       unsigned long pflags;
> -       bool in_thrashing;
>
>         VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, fol=
io);
>         VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>         VM_BUG_ON_FOLIO(folio_test_uptodate(folio), folio);
>
> +       /*
> +        * Don't hold up a batch this folio can't join for its lookup
> +        * and possible decompression. Submit it now.
> +        */
> +       if (ctx->sio && !swap_can_merge(ctx, folio, READ))
> +               swap_read_submit(ctx);
> +
>         /*
>          * Count submission time as memory stall and delay. When the devi=
ce
>          * is congested, or the submitting cgroup IO-throttled, submissio=
n
> -        * can be a significant part of overall IO time.
> +        * can be a significant part of overall IO time. Reads are batche=
d
> +        * and submitted later, so the windows close in swap_read_submit(=
).
>          */
> -       if (workingset) {
> -               delayacct_thrashing_start(&in_thrashing);
> -               psi_memstall_enter(&pflags);
> +       if (!ctx->in_batch) {
> +               delayacct_swapin_start();
> +               ctx->in_batch =3D true;
> +       }
> +       if (workingset && !ctx->workingset) {
> +               delayacct_thrashing_start(&ctx->in_thrashing);
> +               psi_memstall_enter(&ctx->in_memstall);
> +               ctx->workingset =3D true;
>         }
> -       delayacct_swapin_start();
>
>         if (swap_read_folio_zeromap(folio)) {
>                 folio_unlock(folio);
> -               goto finish;
> +               return;
>         }
>
>         if (zswap_load(folio) !=3D -ENOENT)
> -               goto finish;
> +               return;
>
>         /* We have to read from slower devices. Increase zswap protection=
. */
>         zswap_folio_swapin(folio);
>         swap_add_folio(ctx, folio, READ);
> -
> -finish:
> -       if (workingset) {
> -               delayacct_thrashing_end(&in_thrashing);
> -               psi_memstall_leave(&pflags);
> -       }
> -       delayacct_swapin_end();
>  }
>
>  static void swap_write_end(struct swap_iocb *sio, bool failed)
> @@ -709,9 +715,19 @@ void swap_write_submit(struct swap_io_ctx *ctx)
>  void swap_read_submit(struct swap_io_ctx *ctx)
>  {
>         if (!ctx->sio)
> -               return;
> +               goto out;
>         count_vm_events(NRSWPIN, 1);
>         ctx->sis->ops->submit_read(ctx);
>         ctx->sio =3D NULL;
>         ctx->sis =3D NULL;
> +out:
> +       if (ctx->workingset) {
> +               delayacct_thrashing_end(&ctx->in_thrashing);
> +               psi_memstall_leave(&ctx->in_memstall);
> +               ctx->workingset =3D false;
> +       }
> +       if (ctx->in_batch) {
> +               delayacct_swapin_end();
> +               ctx->in_batch =3D false;
> +       }
>  }

Nice suggestion, and I forgot to Cc Christoph on this though,
worth getting more attention.

