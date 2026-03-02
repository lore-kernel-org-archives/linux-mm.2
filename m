Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0017DD58E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 07:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433CC6B0005; Mon,  2 Mar 2026 02:48:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7716B0089; Mon,  2 Mar 2026 02:48:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298B96B008A; Mon,  2 Mar 2026 02:48:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17C486B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 02:48:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BDC214098A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:48:30 +0000 (UTC)
X-FDA: 84500345580.27.26AA230
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 66BC81A000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:48:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=czPSRXcg;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772437708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5/dPDeqf8O12mzSNBxrhYpv7sAHzRZ210/WqXgjSWU=;
	b=4scYXSzDEycLjl8EU1SeYWalN70qyafTI80PjiWV1HSm+mBrdDnUlPT3vEVV3/OCPacxU/
	eODt0TAsjw9pGpL9l3D1/fb75zxJJepS3kA52tW/EJ/gwzsxNgNK0PgdqVcneSotEpV9Ze
	peB3SKlG3eny856YtpL0td1J6/T0ee4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=czPSRXcg;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772437708; a=rsa-sha256;
	cv=pass;
	b=jyoxP2WfhLT7FAKTohMU7nOLV/dlldrcrkf18tL9pDIeEiZCS6x7nvr+aDF2th2VD3Jm/7
	/923uA9OXdWbaqOxce8BhjT258qMB5Bm4AnXpAkbeCCEDUlO6f2qdEDpigjSxOWJg9Gkc8
	PDIH3VAwvSg8sigVkFWUFpPtui8Rk9c=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3870c2c7aafso6121881fa.3
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 23:48:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772437706; cv=none;
        d=google.com; s=arc-20240605;
        b=lY5/a7/LiZ7XNAkKR9ke0hxlt+CwTUT2I1ZEvDcpykV+/tMwo/VJ4NdOcjsJexridT
         PbWXPAIyat9oN9vTjsvj5mmtP3JI/oIGYsa1S0FIccmBYCFSOUjCSKZaDogKGR7Kwdvq
         WVy/YgpQG0FWP1qoPxRSKiBIpenHJkuJmvbtHXfncn61egRK3DsHg5b53IqG6GjssY/+
         5A4RJ6g7YZnZ03Z3Bp4NGkhS+xapI47p8lbtNH9GGcB39lGuLM5vENi7RKWJNDmTPO4J
         JXrA/5Y5GMMjc2KAkd4VRF+rOKwwwTrSzcPA8EXDcKew3oOAmiZ50JaKH1PgUVnFjWlY
         6jTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t5/dPDeqf8O12mzSNBxrhYpv7sAHzRZ210/WqXgjSWU=;
        fh=rtJyTT7PGV4xF4iiZo/6QFkR0Tr7ZwmPXZZFoBuVUO4=;
        b=PfHhY6quyaDNxWXSyfsudLQkGyKcZ6B49w8OOp/RwtWL5xykbdQY5i+oJXKIQluwxK
         QY7iPWKhfZWQLQmaqb6KBJDPjGa2ONzRV7PtMyKZ3uGjjWFHkB4p59DKZCjyzciWo8lE
         ApfGrvtDpnpNg2GZcUJK+9zffcARl+Xkij8O20QP3oqFPEDv73WtgKHUpE56tyaO2Mk5
         lF3VU6m8uLyUapS/GGJ9Ta2O+9S8xG9gP1NjPAu2r2Rl2z0Xa4IIb+UhVg5cbmSJUzDZ
         QBjckFImFZF5z3muY+N2tHGu5m+arWgvtc6j4rk7Cxs91G8Uzpbu1BgbDpkeqwUWDSw8
         l39w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772437706; x=1773042506; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5/dPDeqf8O12mzSNBxrhYpv7sAHzRZ210/WqXgjSWU=;
        b=czPSRXcg4P5l6JbQ2I8eu7YLIiQwhn8vVOIdFP8b0PqBWG7jH12yn9qK62znMSVo9M
         AvAwt7T+XhPWQ6IPdgTwyZ8t46TPcImfX3iVbqNkemWu7qxRbHTFd23czbDewCM86YbB
         hTZBZVpiwG9pKpOSWU84IDSDxp9b8wFFTIVX6Vh7wU2kVO+g1ChfX88Kll9MWzeyCRo3
         sJMNUCVzj5PUN12LfI08/6tzICyTZz2HS6JvFGJqZKlM0+uHKDEAd+Xf9SkvS/ja5RcU
         tx3bisT7AhX2beehEKzDji3yeGpNqJT8tBEm0b63dTCWBXK7IQDgwEf6etSA5KLh2pGC
         CoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772437706; x=1773042506;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t5/dPDeqf8O12mzSNBxrhYpv7sAHzRZ210/WqXgjSWU=;
        b=sFvmsUgr0BvOSYwUJOgKtSXCR0Hb3/bJoDeiDty/S+gzh4Ej2qzxH43GFh82Xb7RyQ
         FCLB4iILGatQ9JpDaJDVK+fvpvx5gwiBPqaj113t+46jDHSBpggkN89oRlJ63YlELrey
         DyiuOlfay87GPQOZ+6B1hgL4YxeADbIQhV1c+giiJF26CPeSIZTmuW/atnK0daLCBypb
         TfuTCe4NVjfUGxCr/UwGF+h+KYqZWWN2t/7BosBedh925cvuBjg2draNHgJKFZ7+/RAx
         A4InSmTSOmSbTj4sOr/RBfUa4sSdYFtPHdBlRB5FW7v78kMUQDni103lt5rMwpn87UxP
         UryA==
X-Forwarded-Encrypted: i=1; AJvYcCUOUSwyrUZCvYBi5pP0ZzLNReugurtcCfhzsv0Y8pe24Zv5h4Hkd3fNcrZ1waz+UmdaQZfeKRA3pA==@kvack.org
X-Gm-Message-State: AOJu0YzXIEs7ij5ZbEMHqGKoXyzMrb0ENIK6/IrZ/KPwL/bIuH5pA5vY
	4f9uVdUzCVy+kvuYB2wWdIkdCEbG4S1I9Y9iu/MfEC1QbHEpPb94gr/vBS1cps5jmEPNggerAMW
	gYbP/8WDpaTJXofk2opXVsNTVXVeWaJY=
X-Gm-Gg: ATEYQzz2BV0tbZ2ZOyghwqK95TF2k2X3Mxa0u5Eqb7RDlEn/51BDvBtgWwKfHmYyOmm
	smx0Qz2Fmd4XZHCcudeyaGYRLCoGXTnvVN4/L2o3OXhVA/DS2yysJSWhaMiKETXgRd3m+g1GKfM
	q6lL31XrAFAA9AKyqf/YBY38oX0ZcNeWmew85k0rwpbZYqv9F5rGfUXxP46UkJEpmgmM2euCQVc
	SAuVVw2g8sWirUPG25TbQSxzYmCCWmGCysEdvo0f8TyJq8orz9vailUfDeLJPeUFnq6IqifLnVN
	Nu24B4Ds
X-Received: by 2002:a2e:9a10:0:b0:389:fd1a:4413 with SMTP id
 38308e7fff4ca-389ff363165mr33030191fa.6.1772437706153; Sun, 01 Mar 2026
 23:48:26 -0800 (PST)
MIME-Version: 1.0
References: <20260227075250.1128175-1-zhaoyang.huang@unisoc.com> <aaPZWOJOS0cnbIix@gourry-fedora-PF4VCD3F>
In-Reply-To: <aaPZWOJOS0cnbIix@gourry-fedora-PF4VCD3F>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Mon, 2 Mar 2026 15:48:14 +0800
X-Gm-Features: AaiRm52l_Be9d5awPRKe0lXKJofsbjLcq56Nqt_j63yzMFPL5-_oFNG7hBWSX2w
Message-ID: <CAGWkznHDjAPLAg2b7E+-V3hKmXgKPCjgkMkJtQX2aNsKyy+ocQ@mail.gmail.com>
Subject: Re: [PATCH] mm: bail out when the PMD has been set in bloom filter
To: gourry@gourry.net
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 66BC81A000D
X-Stat-Signature: ongqhgin8tqre9ojpjbys1u9sk4q9an6
X-Rspam-User: 
X-HE-Tag: 1772437708-349962
X-HE-Meta: U2FsdGVkX18qTNZrj51a2zvgEpm2HRactIfs8+CSexZTEjQqajOpRbiAm67e9aS7wRR/J96TU4LQdGUy9V+pQPFXCYhIpLePZS9fLkvEr5nvu2jkWEJA3QivPJvSHUfP8wxSvm4n+CAIDVjIFaJ1FnkbZdhtBUTj/meoBH18kTHWo6nJi5oCyWtPsCMqHgQZu+LIyUr1b1+jkZ3Z+lWQUGLV+cCTwsqZET4qoHYy+WN+d9EpqF7c+KEfWgV/pw0H9x98rDz91tzuwzksVY3a0Rj5VqQOuh4UAMeda24eSSR+T/H39JrCfW1lHCNdzFBIj5HG4gqBU8WQm1WE/hBXdetKdrOfRaD+sp93PP+NmMw5BYoX+3FRiAZq+nAAVe582QZvcVptt8hO5jSCEnhUOcW84J4F2RwRa0ERRQ9YIC3iSYdrybdJ0YfZa96wy7vSsZSsLdh7HmRUP+xSTuHBxriJbPEQQWHh70yW9RwdMkiMzADiWgndE+kqSOLecuxGsPcxBOj64IlHrDU01XuvIsBIm3KEXCQixt7SeVGV5WR5md3qiJ35ZwE7cwJoKKWydj4ySJfDOozYsjarLlyrL9ab/F8ZQETu/dUwI3+SqQTRG4DKDHyWE2MVxACQlsi0lBmaECrp0e66S2fq1IDos2hkeW53FL4lCubtcbFN298rkm8WcuVohCMuEUIPbWhNNsb3kGlsz6WD+aJAg8yVgPpc+O3Hg4z3hpZ2qqRHUAW7AyZR9yEBPogmxem2hKgFXFdyyiiw3DPW5Z1q8s5xGLxPYBu4SVwlUiPw7SxNon+YfMTHgFrUqfKViQFyLZUncWvWt7Gk9cSDeRa0r7DdYVqYHoM6Kv0UCaB3WJVOeUDMilkoWg3tLKMH5U3IV3+uSxByXdbKeLpS08qX6aJhxZFwLyMRT6xeQ7XLkfZ7uVupivd5qOOFlsPgWfvCiDFsubefs3QCbVX1BdaVjqJ
 KvfnmDPN
 npg00F3wSoMBa0an4pMYESWnJIGLcoSTFJmqihn8BEJKdzVIzu+gBhXGGA7KOvjt3zUFPxwqpnCtVvMcgoQ0EQxCfGW7CXLe38OV9uKxvc8T/GdOQhFYz+keb4MoWYJbhHr9nPMoFu7+476EW8dUos4CSB1VPU52kHw1X62lfBMOYTdKziNEoxOonNHcQTNXd495NSy2FszgrCbGo1HVcjXJsmOGYj8fhqZ+nyyqJdLPQO9S4URCGl6fepWa2M5XAVHg2qezUU8L5k2n5rIqlxhuP+tD70vrOymaVFPppzfqYVxyKk44DMwBLjAlt5Xb3Fv+yiMXm5DbdfOFEJ7mxQruPiOIHelbFzchEYqol8BMn6fCb8qN/7xHox289CkL/+N0khe9YSxbAvNh2sKEusJ/Geq3PO5K2XMBK39q0v/NqFBNBpjt0E/Y7IsuH5uAkzaOK8bom7xuMwvrPqcxCUzwAyxKeL7q9K4FnXziwDKCxuFcwK0CQmwgAutDyOgRZhzOh6sWZkP8EyHafd2GT5jaZ35SkshvD3LW8VQpGkpEPeSw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 1, 2026 at 2:14=E2=80=AFPM Gregory Price <gourry@gourry.net> wr=
ote:
>
> On Fri, Feb 27, 2026 at 03:52:50PM +0800, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > There are two reasons to have the recorded PMD bail out from doing
> > the following iteration
> > 1. It is worth of doing such a trade off thing in terms of reclaiming
> > efficiency as test_bloom_filter only consume 20~30 instructions in mode=
rn
> > processors(25 instructions in ARM64).
> > 2. The PMD needs to accumulate young pages until aging happens while th=
e
> > new arrived folio reference checking under current max_seq refuse to do=
 so
> > which will affect carrying hot PMDs to new generation.
> >
>
> Can you explain what the intended *effect* of this patch is?
>
> Why does the PMD need to accumulate young pages?
Please allow me to be more clear by summarizing the bloom filter's
utilization below
1. rmap_walk has the suitable PMD set in filters[max_seq] while all
page's turn to be non-young states
     rmap_walk->lru_gen_look_around->update_bloom_filter(max_seq)
2. young pages gathering on the PMD if it is a hot VM area
3. newly arrived rmap_walk in the same PMD clears page's young which
is set in step 2
4. walk_mm test the PMD again during aging, which will bring the
suitable PMD to filters[max_seq+1]
    walk_mm->walk_pmd_range->test_bloom_fitler->update_bloom_filter(walk->s=
eq
+ 1)
> Why does this patch help that?
This patch has the rmap_walk check the PMD from the filter first to
prevent step 3 from happening until reset_bloom_filter happens
> How does this affect carrying hot PMDs to the new generation?
The hot PMD will keep the page's young flag until it is tested again in wal=
k_mm
>
> What concrete behavior did you see before this patch, and how does
> this patch change that behavior?
The debug log shows there are a certain amount of PMDs bypassed via
the newly inserted criteria which save instructions of walking the
ptes at least.
>
> What is the user-facing effects before / after this patch?
The regression test is on-going.
>
> Is this fixing a bug or a tweak to the MGLRU heuristics?
It is a tweak.
>
> ~Gregory
>
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> >  mm/vmscan.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 9d900be478ea..e50e98291d0d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4227,6 +4227,10 @@ bool lru_gen_look_around(struct page_vma_mapped_=
walk *pvmw)
> >       /* avoid taking the LRU lock under the PTL when possible */
> >       walk =3D current->reclaim_state ? current->reclaim_state->mm_walk=
 : NULL;
> >
> > +     /* may the pmd has been set in bloom filter */
> > +     if (test_bloom_filter(mm_state, max_seq, pvmw->pmd))
> > +             return true;
> > +
> >       start =3D max(addr & PMD_MASK, vma->vm_start);
> >       end =3D min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
> >
> > --
> > 2.25.1
> >

