Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3391A606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 20:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Ydg5g5V5
Received: by kanga.kvack.org (Postfix)
	id 5580E6B0555; Tue, 20 Oct 2026 16:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509676B0556; Tue, 20 Oct 2026 16:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9A76B0557; Tue, 20 Oct 2026 16:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16F0F6B0555
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:19:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1294EA02FB
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:19:53 +0000 (UTC)
X-FDA: 85344120666.09.48910FF
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 29C7D1C000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:19:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ydg5g5V5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792527591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRhdzsXjkPnZHHLr+3Q8i+R2BJY5HtmbkjLcsOK9Zzw=;
	b=SBRk23QrgDuSaqw4jSM0dwqhaTJTaidQyIBfdVURGl6YO3ZSOkCd5wUUjYc+jVeX7oWWFS
	Ss0s4OkM6HPiYnAF262co9z47Ycg35rtayajyANtcE+Kzwkr8RX1osXzRr9xG9zynwFcEE
	6wR4QoWeQSHrXeKSGKBxNvs3xedgDI8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ydg5g5V5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792527591;
	b=0kkO/IVNFNp9g7U1mEumJ9ZA+VeOAIaALp/mL2e9fTN+OLVisdMgQ5FLNA2RMjsnIdeccM
	0g9CGtTXJA7ygf6RT4xYKAFoRL7VAXNAgLwG99rVJhHfDQTIkdtXcefcRMqN+7Zr9xOcXJ
	SorY/7ktCLMguysbiN/cN/SdE8EjX1I=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1df146015so53825e9.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:19:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792527590; cv=none;
        d=google.com; s=arc-20260327;
        b=NjujIZxgtWE/wOrejC3jrFvHauVpfu9cReCD923lhYl+7BMTyEqut9i/mYXQye6tum
         AsAlBsRUNvfFQmsEBAi75/DIw7FllfbmE7/h7ShY+BFJgFGQ3gQmUppuBMyw/9x+RdUT
         ltfc72oOoKGMQThnz843Ty4gPOP6bhRw29lMvOy5sKZmZTw6avte3NXVkqwpD9DeV4It
         I59YKjGXH7huybYIcCBMJCv+ec6miHTN/c3gNLfvmQov9dRTkMDH6/jmRw923yF4Lg79
         Zq/IyWltHRmZ+j1Qw7Sw/PWVJ783TJ7uS8T7LAw7WigDidasv2F77kGDGH96LsipMIvd
         3u4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MRhdzsXjkPnZHHLr+3Q8i+R2BJY5HtmbkjLcsOK9Zzw=;
        fh=PDaDjfhrl3na4hty+HzD5eRnh++fz4U8CvSGVWd8D9Y=;
        b=ZmmQ/8BwIRAJWL4kESNh3ooJi+CUiUTN+oeerXNu5mdvT5VK9jb6J5RMzTpPywPYT7
         9JGFCBhAeJDhUJPr2IdfkC6T0g1elkUYD9Y1OyAB9K5prJJXipbYj3OKS57+q19tuMUo
         Sslb47l5Pl7h6DZng+Bolw1yH0OAGnSEEqT3bTVpfUuJKMo1YU4jblYVbzsgXbitKoyd
         NMApzw2wlwGQl8fmIPJnTSsnUgzDPaHk6IlTjsFHDSGFXO2p07DU4WeWgn8TYn3Z/PfE
         mnniIM3pgcsO3zBUrbCCfyvDTkBRWKEc+POu0SUfwMEa8fUEXXlOuo/tSavv5bKCTTaG
         Iapg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792527589; x=1793132389; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MRhdzsXjkPnZHHLr+3Q8i+R2BJY5HtmbkjLcsOK9Zzw=;
        b=Ydg5g5V5qj8YBp6DHhmQSomdzys5yi5INuS3WO0Yl41PFJeRdsMuvtZof7zooUCKnV
         2DjVNdrwvmglPVUCpIpFxMGImypBhWOp51C81ClEbv9ij6qrDKahYBpyvh69xbgRJWZC
         zpINbt0Lugeuf0TTxFmGEzSgMh3SimjWsPdhlGXNLBYuiLNvlAAToit72vaKbQrECE7T
         bhyXYnr4w1Edp9ZRdfTEj5CVOOMvfOeHaTiNLS74FF79JA2KATnxls1SH62H//1gdr9A
         LGNuTJgX2M/Izx0djv4jzo1S+o1V3gt6b3+d/oh4qCd6ygEdkJ0V6iitEHNEmv67nfWd
         dqUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792527590; x=1793132390;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MRhdzsXjkPnZHHLr+3Q8i+R2BJY5HtmbkjLcsOK9Zzw=;
        b=XJSAHr9MeJ+KGen4OEtobtzltKkjEys6p9a8ILjYtJbsd3aiv4S/5kMWzfapmQFtj0
         J+/CrCEdAlx3rujClnbN6zlpnkNZQQMnQmyxTt1kZpR4jaKX40m4hLK1g+lzcapGCHGa
         4d1wmYn4I9XPvKUQfYGOxF8mYj8+KKxbLi6LfOmbf4Yj92SCYQmycQCzimhz0OP3uVU8
         PQPcW7qxh39T7NlCx70k4TqAz2KYqKKCZKEmjvrU0NnM8JgW0vDoz/Iv6Q/VxFRWuvbu
         3XZ6Py2Yq2Br2UYr/TBqLeIwkdNf7zKaxvNEnkHeQRhsWTDLUWWdJjwrmhWtW8yup8Tl
         tKdA==
X-Forwarded-Encrypted: i=1; AKwUvByxmR5U2FyqCjN4cBeBl8HRcetWEcBHmUUOBz9XbP1mumMPPzEZ1Ndj/XVA1Kk8Wb6iqCuEnN2giQ==@kvack.org
X-Gm-Message-State: AFq9FYKNduAxgdWEqtw3cdfyM8ahbv2BQDdfUIdD+kpnHaxRJAcjrEjr
	VwD4hUpQEulm7i8XxUkiBcScP1VMfYBCh5VDsfZ5UpHMCmndNFFT76TzELswy2JlRb3ax6ZZV3X
	QnOZmS2s57ESICG5cKyDgjo758T3kUls=
X-Gm-Gg: AYBFou3lVGhNYhQH3BzdWlm/hFQxc2Q+e/3ZTdXVketfb7pvkpgDDT5n18+dRwVMUN0
	fB30gBEDmiuE9UgNImpML/C6EaRhm2AefoWZ2DheB6buCZxQeLZxsZyodnVRAZ+5RvPblLE3krE
	qMFh1v1cpi1dqwmEzsLfvKKAnNVMuxbUaHbqw34apqXuMurDuQo4QVN9wdhtUZnLyCGjRnbXruN
	zHJJviV54L5jbsYZ2nMXFXc5s+XE0h01UvOzEm+fU3m+F7cIkerSm33RmkrxP0E6XDEukOFugYk
	xBMkAy7Lr7TE6g9xlZ2wqiDbZneKgaW/4cYi4SKY8ZMriMj1+z7VBaAjK9t5C0qG/mmOlMVMZxS
	qdNSPDTfyDLvhBCekOUETRbt933mfnIdLG7NXkiOgNDmq1ynshOHAa5EjumZLtSXJvpFeHmw=
X-Received: by 2002:a05:600c:83c5:b0:4a1:faa1:3813 with SMTP id
 5b1f17b1804b1-4a1faa1386cmr33962685e9.27.1792527589379; Tue, 20 Oct 2026
 13:19:49 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019160615.2348500-1-nphamcs@gmail.com> <CAMgjq7AEg6XEUJPaM3mMBQAeS_KiDv8_za4w-R2WaZ=ZGenvuw@mail.gmail.com>
In-Reply-To: <CAMgjq7AEg6XEUJPaM3mMBQAeS_KiDv8_za4w-R2WaZ=ZGenvuw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 20 Oct 2026 13:19:38 -0700
X-Gm-Features: AclHuK9xKTOFZ19xiMZBkY3q582rEW0wqbjhnZMOWfykMSCUkqYNJyTrgcZkxG8
Message-ID: <CAKEwX=O=PL3DEaEDe=F-=zhQ=VW3_UtcqesdX9fH_cr6orb2wQ@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: revalidate populated clusters before scanning
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 29C7D1C000B
X-Stat-Signature: jupd11kgwzwwanmfobkofjh314sakgsd
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792527590-534671
X-HE-Meta: U2FsdGVkX1/W/luSW/tUBaXYcbrJ1UXt3LVpzl8dKYvUmFRXbzPA+PzUlXptzr3+WdvG0cMCEmrRWVUjAbR3zCkGJYqB7VzbUt07uCBq/lEBdCuNQCX3PgWIGtX+oeZdYBXTfDkSpkVQbpXtxsEQTS9uE1BCbZ6k5CE2OjGK4hCh6OmdtmhtTcsAuBbik8p35TuwvmKsc8ErZwkzk8XhevPSKZLH+r3t8C/atOCd2qP/anvLu1ljCdhg20lwKcA+UBogU8DXiiMHToxqDpBiscgcjPLWRAQo0PMwsIiojxdKgDI3xICf56D1EIsNRggLRhUnQAbiMjeOthcU94kXC0srgcAEA4FrcCgRTDQJYlm+cQWG3CF6rjBYNG0flww2HCrOwVGySv16oZkcMvif33v99UmCAhnGovTMmZMgiJxeSHZ7AA+4XmafbNyxx2AXvDHccGdCPsHUqK8jtaIdco1Kn5lnjdLZ6TlInEsxqyP5ZiOK6c4zC1TCkMqcRQ3dbU2uAHlN1ByQDldy+WTDaAuOX/s/UaISVvP4HklsCXGohDpkojk5kVm6yQkCRYpvDpC7InxN3izZc6ITx5ff4R/e/fQu32ltgOaVoo7CRKbAkNndvo2Us70T7Ez+fUK0BUavH+Si9B9+CLcmDt0RQY6F3iQVEUhCm/UcP+WdnHVzuow0RgkQifV7cWBI6upkXoV+LGkmU2jFfy1IMfN6Ul2nyg49cGvXECL3bK9okXxLPvgyUsFnLs9hBGn3dSmRrDNLU5IvBxuqyonWFDriilQJwViAa7hnmXn/Wyk+N0/KLcRTsm4e4ACM147MBRnb/gAffEI4zj3xWsgtFGDMtHmJt3eJNsPvgEJ3JnRdHFxRs6AaKRE9jUWlgrfQrP1tkU3+GnnJr7o9hOwDfFm39tcWeQrhcb1f4aK2OmT1325SHUo0jxF4/KgvQXnFmnOj4gcWNxd3Azy7revB0dQ
 A7YmpTlB
 EhgnMa+isQDL4BKxI2wChEd7HCgzpw05WRLZPYKzW+VVmRD5rJCAseWqmuMsyjoZ8HwG+XQXL9YuPYwaFblz5s50bqqzTP4NHNGKxvqhhfoQxlTgUjLBLVQFt4CLAy4wpsfAQZdupEJr2nPXCVAlZgJ2c+b6WlHoqhCEOJwDSUvVMhXoR81jpEmu5uFqG4PAULamVK57VJJrFed/9uSQ9ZvNxTtMM3tXHmqJBjGMHgigNenQw2+TqVLdzXTAJnYTVsir8ACokZaxOKCfgE4XS+Rc1S8fkwWPflk+ZKKO9wGu2F+USpeHkLjh53CuT1qlPlUEN2v4oxl9TntOR0a9U0ZlJPOsQ/wL3hbT1pv0al0uATqoopJwwgv9sSJyN5xc/bBnNCWx5gV6vOrKiuTd6cCn8nYxoTgzV5r1vcV8ZEO7aEY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 10:58=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Tue, Oct 20, 2026 at 1:41=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > swap_cluster_populate() can publish a cluster's table with the cluster
> > lock dropped. A cached allocator can use and empty it before the
> > populating allocator reacquires the lock. The resumed scan can then
> > dereference a NULL table.
> >
> > For example, CPU1 can retain a cached cluster offset on an SSD with
> > per-page discard disabled:
> >
> >     CPU0                          CPU1
> >     ----                          ----
> >     swap_cluster_populate()
> >       swap_cluster_alloc_table() fails
> >       spin_unlock(&ci->lock)
> >       local_unlock(&percpu_swap_cluster.lock)
> >       swap_cluster_alloc_table()
> >         rcu_assign_pointer(ci->table, table)
>
> Nice catch!
>
> I think the real problem is that it turns out calling
> swap_cluster_alloc_table() without holding ci lock is bad idea... I
> think this patch still leaves some other call site too?

Do we have another callsite? There's a callsite in setup code, but I
assume that's safe...?

But at this point, who knows any more. The caching only stores a
swapfile struct, and an offset. I wonder if there is a potential race
between swapoff-then-re-swapon and cached allocation? That'd be pretty
wild.


>
> We may instead add a "bool locked" to swap_cluster_alloc_table, and
> let it lock the ci first before it does any assign (not the alloc) if
> the allocation context is not locked. That is, keep the
> sleep-allocated tables private until swap_cluster_populate()
> reacquires local/global/ci, then install them under ci->lock,
> something like pre-cdd77f84d966, always assign it atomically.

Hmm so a bitlock?

Lemme think about it a bit.

>
> That should also cover the problem reported by Kemeng a few weeks
> earlier too, and prevent further misuse. My Bad on that change :P

No worries. Lifetime is hard :)

