Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F86606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 20:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LEc9Jm0l
Received: by kanga.kvack.org (Postfix)
	id EB8C66B00EF; Fri, 30 Oct 2026 16:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E615C6B05B1; Fri, 30 Oct 2026 16:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4FEC6B05B4; Fri, 30 Oct 2026 16:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB92D6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:01:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C167407F9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:01:04 +0000 (UTC)
X-FDA: 85380361248.22.61B7685
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3A80BC000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:01:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LEc9Jm0l;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793390462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVlJlElGd+QbrdLvZ5B/9aQalJg+BMx232eUurqCSmQ=;
	b=FUEExQNUXTKAMPyJytJ7AzrtOzLFHOz/1gGk7OiOWh53sZqIIOUW/qVbUCxhvOnOc7YDYW
	Rc3domMM6bG+BmTrkuphwxcGL+bbnKPhlsE3TycLHPm2bBYUJlchll/fwqvXv8KbpSxW+h
	GNH59G38F8gUGW0m3XBHFc8zduWu0xc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793390462;
	b=XB8TxcW0p/7xBQFON0XUAI/r5cYNx72vXaTyRMY6cB5u1O9EBAWWgtItYNMM7E0CrsTpUX
	S4CK286qULgYnpgMqzgA+65vIwfskKbw1zHuwwkPIhKJtrJpbEAYLCIbyf/sYDyOL5fQQO
	ITZJ5dtfppjH8GJzkSnEW+u3bJa+c6I=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LEc9Jm0l;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b3dd83e779so1917810a12.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:01:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793390460; cv=none;
        d=google.com; s=arc-20260327;
        b=rgRSjkuZa0oKBOHSMWmiUGd8utUZi6SaGfA7l6fEX79mM4vKzwyL2+tgX/Uk+p6jd9
         At53BxD4gddzAu98uMTef9T13gSDZhmF/3CFw6purNbcgfPzpdQnIEATkX/bvRIhJLdA
         oxHOcd4iSL7gDo1CGbZFxIkdwS/8IcSh2N0mar9fJP43WbpsdiBpzEfYgbqmTbG+WZyZ
         Xf7nU914ITLOBLDwhwRZtHr+SRsLQBpSzxdadVEHQOEyqbGxMZDACsS2tasZqi2FfMvF
         Civ9NVlHIB/Q7qYf2Kzv/LyMQZ/5WQd+oZ48PbgLsfBUpQ9hGGU45NZaI9uXXysVvOFn
         yXSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HVlJlElGd+QbrdLvZ5B/9aQalJg+BMx232eUurqCSmQ=;
        fh=aDT0Vz/geIC3TdJ5qkidvnlSmSFH38Bi1JnbPqr/XLY=;
        b=hHpAomF5ODCB7wqmAt6lHZxp7koL+G5huPelFqzLs1op01UZg9zxcei7CydVp+Td6s
         2WNQakuvD8iGAOdfpxgRUl70sy8/3+GGokmkgk0AuzwmPuEUvDqBsi5nupr8SSOUSrl2
         W4BnbGN/+HaVvMkCusd7DyPyiR9whdQYOk3MBZhPmInlMDw6lwARuN6VjCSx8bxJleO3
         ZLRxR1jKcLz8vAv4WrCht48/jcg3XS2CLVxZSJDqHgoXG/x5+E7KJxu8DzpUaxjCox45
         6PUzL7tubn6q2QjDIxhOdfIgiUtCFEsVBEJjbyL86prdZBXe8npQaWulvAhGShsEo4el
         rIoQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793390460; x=1793995260; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HVlJlElGd+QbrdLvZ5B/9aQalJg+BMx232eUurqCSmQ=;
        b=LEc9Jm0ls+DgUqe15CPDMPV8LyPC+pIsixOKaHba51r4tpoIlNNx7goVgzHyC2pNwW
         B1LJPhJmTw1/5/VLpSzBxsskjGDCG+7xLCaZriC5C/ZL8r9W+aFg8GRQ0NfkAIVbNW05
         nbsWtTxr6ZvhOeeil3Qbe+OkBo2YXFDYN0cGWfFGWgh6Es1qSU/6l1zOb73fdbrDkbaV
         JpvsZRCh14qpI1SiQ12CaRzRo2kyKB68RqTZEsf32vE4FU8RMGAJn6Gx20b0S3sSvH2T
         sG2yfdu8l/8OH1p5Erxvp8wJkINBlKxGwnIuDe+fwS8kxwNHLuDeNXq8ZiPxl/6AWeuz
         BSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793390460; x=1793995260;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HVlJlElGd+QbrdLvZ5B/9aQalJg+BMx232eUurqCSmQ=;
        b=EeOKf0wykp9e1luq8rqRTGwXRCiUPooN0PQ2eKgVs4qPGpiskcC9DVz5N6YVITqSLV
         8Lq7nF0EY22jAzQYBDCdarpEF2D6lzEZrecdq8ZWVhxFPmE6RptABqqTsVHPy97Bujum
         iw2SSgq/CWdRvk71nZs9gcc/SKsseSuW8t0Zjw2Lcfi5ax6i/1FnuetSwa1H9S6pLQ87
         IvqhZuO8O66iiYA4AXzoPuNRpXzupH9srePNXz2dhstJwDbfmKrMtZslqXSUiHYrQpgj
         8I9X0mUxqspBwmtPA37eDzlffveYvh8bLTQZ5nppSm0/vWv7tuvJnj2901jVIQsT2v2O
         yi8w==
X-Forwarded-Encrypted: i=1; AKwUvBxC6upUs62wnh0M2CaZPA+IYaOctWmUI5JXnMzttiDR6bDbo8/9uwhda+AmljT0UVDtOHTT9HpQ/g==@kvack.org
X-Gm-Message-State: AFq9FYKBNkjG3d/4U91bDldEJguqEMJ62CTn1nlOp3Z0DCsLkV3Y14iy
	634imSn68tf7QUU+HeGbjdWjHN+x9Ox3ikrp9CNVhydIZoaAZlkVM2OeWofrzhIKyu7rPF2WzCI
	jELed4BobCD30OqoICYKzhqcm8BNp5dw=
X-Gm-Gg: AYBFou02djmR+zwqi/PBSYYq6fHZpH0BXT92Qi9aK/FkvDGWW9lnb1Df7GShBLCF6lf
	5lUC6S3tD9uXeHpU7BLKBNnlkJopClMJG7RxqhUVDqH2noUZeDQ19dieODGmKPnwBK57Bcrfge5
	1d49yTxu3mNOCwRO/3PDX8xW1oDEmzYAosErgawQFTwP+QtXJtP7kHJwRqGkchkwMrZfdos9Kjx
	jMbIg9FouR+g3Ab6/Iq2gVKjZuyjhtKPpY7rmUbIp9MeeJcZt/WSor6hrrZi5mcRekxba8CBYdd
	MRV3e0363x1EGyzwtYXvASZ0VKHPBXnLz4qWg29+e6fAaUPsoYIsloP/tFnTjwOAlBMlQoR2Hw9
	8vJCW0C0GQlcRtbjFpNJBQDF1OlttBtgZT6Z5jfhBdTKCaHJGQNhxJxQ4fWhR1gmL0XP82Q==
X-Received: by 2002:a17:907:1b29:b0:c41:26b8:c49d with SMTP id
 a640c23a62f3a-c4ca7ab18d6mr304192666b.38.1793390460290; Fri, 30 Oct 2026
 13:01:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
 <20261030-swap-fixes-v1-2-73f73a59f2fc@tencent.com> <auOz00OGB_8dgniC@cmpxchg.org>
 <CAMgjq7BYgXLheXDyc=p2mNgxdP3+92v2WHGiXiweDrsiYQ0u2g@mail.gmail.com> <auSWtJzFQ7KdElKL@cmpxchg.org>
In-Reply-To: <auSWtJzFQ7KdElKL@cmpxchg.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 31 Oct 2026 04:00:22 +0800
X-Gm-Features: AclHuK8q5xaCpZfiOdmN3WawlaMgw0pNWtgjLHNKgZXSWivCrJGS89rQKrGnLYw
Message-ID: <CAMgjq7AJ0uajpVM+Kva5=_EXtmaawYR8TJQ6RdhrP7+NUZDx=w@mail.gmail.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3A80BC000C
X-Stat-Signature: 4mcdmohowsihy81soi3b9t4mksw8g9w6
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793390462-96500
X-HE-Meta: U2FsdGVkX18keBVlPvGAYP8JrRBeYK6JSnhvcjnwz2SzuDtdmo1DD5OrJFEha+PtbWIYCTJW7GLUYzX1a0mhwbMkZOcdV3oLUP30aN5Mm3JiGHPiVN9BSLvhc787aG3Hz0fTP3KIJTT6hEKnAKm9ZwJZZSKjTuX5+NOHN1SMuwnF1IrwhsHnWfGkTNFKQlrcwbx7nkglWG+qtC1XszYELZVeHKR9zhqUP5avJrnG/iSwhndyH41uEVvFxLcc7A2vyEcc55JE1k1QtqD50DZ0yE62ooDYWkwhL5N7EJNyVW54qOr6ZEYHMUrwhYnfxUVRjnkXvBJ8nvwX88Us3aGIVipLADk91bfrpnZSd1fHI7w50Te1cAEUybMsvgG3WrTv+1Thp2oB1OmmhXPzs7AzL50Jg7Tzc+Rv8tmc3j/qe/fpM+zs4EaGzqOa2RxgLnQOGFpqTRGInKjqG1q9f93bhInXZGOKYOE0qGmaeKi6OvQQPq5aib0OFwiJDihzvNKciXORHKSGOnWVuUFjE4HVdX6a0U8pXQrDzfN0zyQ/V2KgczwmLW9fNmoWv2O+srpf6VSMPnbuPd2SUDBUl+drdlZVjTrllMkOmLYVCSCwbfF19qVeCTe7bu4rVnjhnJsgeEoYgstddNycjHYf/3/GANY6lzFWz/+x8y+DnS3EmhNStpYcp9G49LdNyU1w7M14zyVRIbPupBPnY9IakGGvnFaSPSL0cDHYTfZ0v0pmnxIwPYzWERoi+YALul7YPVxWArkvZuAOfxnA5UtaKjRm60j0dcc6qg8DJCDIwp36A+uEh0iF7c7LYhglvzTDpnade/VoAWHLnodQ3JyqTFbmP+a/nyse1mXoHi3owaMju1jYhDO6xcxk+itbqHuqHxEy3bJ6oGjfq4l2l1L9V9WOk2S+Ol1kcjphu7Qdc5Iu9IMKSP3iUiSRTK94d7YIfglu0dU4u1BltvbNTMuSzwW
 JMq95m61
 TWWTkyMYLes0V9VzgEEmZA5Pp+3cBifqXsxmXbJ8VtaRBupKLmDp2VaDG3XYklZxobqbsdubnSBUz/yP6XXikis07bqmVmouWFFbe1iC8hpflh32gE9Pb4c55FWhmRADOXM9bfWhlSjbO8CULdxD1g2tL9yKOlCZvm7zZoG5hcG+kMfEY3GNKi5fMnn65i9U1rieFVzEcE8r4aONoz9o9G6ToEmuYJwLPDaoZUMCCSI7tRbzD0Z62fgnSc8gmAnCVdD52vzQzjzIhMFaK8SDJxQCuBvsRK45mhfb+g5uYDv3ow8akOe+a/zR3Wrpf+zvPACI/Wlsb7xVwgxR7o5KQo/6YzidY2iyivjKDMW9XiViw0E8wzWiUISQx7bOQaM+w2DzjKhp+QR3snu3HjZv7L5Hko3RAGW2+JaR5YK5jmaY4Xgd2UrRh93NmCCsmEA+H3iftEgHVA8SDC9nUmj6TOicPGqU42Fb/2fN4RtYCCA2FdkUGIeU9MOCdu/PCDnhS2PmnTGINh0lcVcp9tR8X1olFWt52CXHbyQuo8j7SAuTOJ+8sm2jUOpUXQ3WSjDeBzwZli1oP/S0byWtrHKRRXzUHdfP+460E+En1Bn10sfSsKdCrkVbfr7eT1aVnToXBv9wF85+AiMPrIiey8mwkWlYW/dL48Puw9odi1Eizh5JVQO5n0jr/ODEdtPAesU2DKzsF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 9:08=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Fri, Oct 30, 2026 at 07:16:51PM +0800, Kairui Song wrote:
> > On Fri, Oct 30, 2026 at 5:00=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > On Fri, Oct 30, 2026 at 02:31:42AM +0800, Kairui Song via B4 Relay wr=
ote:
> > > > From: Josef Bacik <josef@toxicpanda.com>
> > > >
> > > > Swap-ins from SWP_SYNCHRONOUS_IO devices such as zram are no longer
> > > > counted in PSI memory pressure or in the swapin and thrashing delay=
s of
> > > > delay accounting.  Refaults of the workingset from zram, the main i=
nput
> > > > to userspace OOM handlers like lmkd and systemd-oomd on zram system=
s,
> > > > become invisible in /proc/pressure/memory.
> > > >
> > > > swap_read_folio() opens the accounting window with
> > > > psi_memstall_enter() and delayacct_swapin_start() and, per its comm=
ent,
> > > > means to count the submission time.  For synchronous devices the
> > > > submission is the entire read: swap_bdev_submit_read() does
> > > > submit_bio_wait() and completes the folio.  Since reads are batched=
 in
> > > > a swap_iocb, swap_read_folio() only queues the folio with
> > > > swap_add_folio(), and the bio is submitted later by swap_read_submi=
t()
> > > > in the caller, e.g. swapin_sync(), after the window has been closed=
.
> > > > By then the folio is uptodate and unlocked, so the fault does not w=
ait
> > > > on the folio lock either and the read time is not counted anywhere.
> > > >
> > > > Found by code inspection; not reproduced.
> > > >
> > > > Fix by submitting synchronous reads from within swap_read_folio(), =
as
> > > > was done before the batching, rather than from the caller.  This gi=
ves
> > > > up batching of readahead for synchronous devices, which do their I/=
O
> > > > inline anyway, in exchange for keeping the accounting simple and in=
 one
> > > > place.
> > > >
> > > > Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block =
I/O")
> > > > Assisted-by: LLM
> > > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > > > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > >
> > > Hm, this isn't a complete fix to the problem described. IO throttling
> > > happens at submission time, so there can be significant delays on
> > > async devices too that are no longer tracked since the culprit change=
.
> >
> > Yeah you are right! Thanks for the heads up, not only a sync isssue
> > indeed, async devices are affected too :(, throttled swap fault also
> > went unaccounted.
> >
> > > How about keeping the accounting window open across the batch? Opens
> > > on first read, closes on submission. A batch with at least one
> > > workingset folio is "contaminated" and the whole sequence and
> > > submission becomes a stall. Would need to pull the !can_merge flush
> > > out of the batch-add function to get the accounting window right but
> > > that seems reasonable.
> >
> > Won't this cause an amplified PSI reading if only one folio in a batch
> > is workingset? Maybe not a big issue though.
>
> Hm, I think the only option to avoid this would be to split the batch
> and flush more frequently, which I'm not sure is worth it. The batch
> size is only 32 folios...
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 22e5ac1d298f..806cfe633a95 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -207,6 +207,8 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, s=
truct folio *folio,
>
>         if (ctx->sis !=3D sis)
>                 return false;
> +       if (rw =3D=3D READ && ctx->workingset !=3D folio_test_workingset(=
folio))
> +               return false;
>         return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw=
);
>  }

We are in a dilemma with this change: if it fires frequently it breaks
batching but improves PSI accuracy.  If it doesn't fire frequently, it
has no negative effect on batching and performance, and it isn't helping
with PSI accuracy either :/

But after a second thought, maybe we can live with it by having both this
posted patch merged as it is and appending your suggested fix: the two
kinds of devices end up differently.

For sync devices the batch is now always one folio, so there is nothing
fancy, everything is accurate.  Readahead batching for them only happens
on the MADV and swapoff walks, so the cost is limited.

For async, the window covers submission.  That cost grows only mildly
with the folios in the bio, block layer and dispatch work, unlike a
synchronous read.  And the previous per folio accounting was not
exact either: in a single threaded task, the throttle or cost of
a non-workingset readahead folio pays is also holding up the workingset
folio's refault, since the task cannot start the next submission until
that one returns.  Same story for delayacct.

And we are missing the completion wait either way: if a fault finds the
folio in the swap cache with its read still in flight, it blocks in
folio_lock_or_retry() in do_swap_page(), which no window covers.

So perhaps we can live with it for now by having your suggested fix
on top of this posted patch? Some comments could be helpful here and
maybe some further improvement is needed.

