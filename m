Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB244CD8CAC
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0572B6B008A; Tue,  9 Jun 2026 04:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006D56B008C; Tue,  9 Jun 2026 04:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38126B0092; Tue,  9 Jun 2026 04:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D28636B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:01:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A258E1C108C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:01:36 +0000 (UTC)
X-FDA: 84859629792.15.053394B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id AADF6120007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:01:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JWo+yfSx;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780992094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQ06Etm+YPOaYNkd40yM4x2+DIDAyFonYWszZpCtWQU=;
	b=70hHdqDSMCqg6TympxBjopaVgzpkPobddAhSDcAWQO3hnrfS1VNOXFyTFM2Vm0JjyMnZ7/
	Z10Yq98CD+pTga8lvQIa9AxA+9+BjnFyEn8oC4CrhE1i/t6a3oTxyvvTQd8dvfl7JKoZUi
	BPa3wTfkBwmg/RKZrc4k/CTI3XB5HTM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780992094;
	b=Pf5C8bnF6Q69AL96gpclCWkEaFiWXy309MxjCZYfLJFCi3Z+4TPCnuX67XXSyPe06fcHRd
	jMJWL3Y9xT541cnvuIeh0qyfmZqGJgCeQ5zlTcdDavVKUuOMVp459HqyWJJ48eP6ckQz1D
	PzYtVW7GS7OzncwAFJmiW5EYGziN6JA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JWo+yfSx;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C5E5601DC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA61A1F00898
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780992093;
	bh=OQ06Etm+YPOaYNkd40yM4x2+DIDAyFonYWszZpCtWQU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JWo+yfSx6SAkUNPb4NqCkgY101al+GmtUanxrykEDH4Wf/SsSltp6jqc59XE2Z2ul
	 aOJZDUqADnioGS9gf9L1vk4enJnfGZDCGaLBIw0RgrSqFOfOwtfRRiC8w6f0vlQvWK
	 v8O1psI9SKMkFlwrVfbVjCK3H79BQALVIKd+RrYH2cQK1gEq4mUEaw/WaSskA3Bm1V
	 n/xYXRKuTt4PKZUadUo6RolWjAyrWuUM/GtaWfeA366G9xzl+TAQJWrHqsMffUo8pE
	 RPqCLWOX3EJtDuhb7ys6y5e5aLjpz8i6jiElyf+JTMQ5nU8/JZ4JLp/w7Se9+sPUlp
	 hwcmcS5TtYIsA==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-915c36e32abso215150985a.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 01:01:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+ywiMzHl+93P6OXOzI25o1eYJBt+ll7KsSk/gtieSHvNbLNbZ3/JzuZ1SY6sOYDt2pMU/+zb+mqA==@kvack.org
X-Gm-Message-State: AOJu0YyRz3N5V4Sc0IDNWAWdZ1miglyzpc5GFnOSM7hRj+GJJakKNJyu
	AM5q7kevCtp8Cmwmqpuz2H2RxkKfU45yJR8F02b0hKJVDxR+/w+bPc+J4DvKSbh06loCAxlaiW8
	6ZjO20/qPRWKTP14qXkD+GuZcVGt+a2Q=
X-Received: by 2002:a05:620a:4714:b0:915:c365:ffb1 with SMTP id
 af79cd13be357-915c3660bf7mr1840306385a.57.1780992093203; Tue, 09 Jun 2026
 01:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260608143242.2869392-1-usama.arif@linux.dev>
In-Reply-To: <20260608143242.2869392-1-usama.arif@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 9 Jun 2026 16:01:21 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xOcTTkpVnno9RgTAkj5-62dLASUa9YnJYSLOEiU1ULww@mail.gmail.com>
X-Gm-Features: AVVi8Cf8PQIszF_-60IV7HqFpB5FkM-rsrLwWwUWaxqGhlZvccQEfYIcXEcGa1Y
Message-ID: <CAGsJ_4xOcTTkpVnno9RgTAkj5-62dLASUa9YnJYSLOEiU1ULww@mail.gmail.com>
Subject: Re: [PATCH] mm/swap_state: remove unnecessary lru_add_drain() from readahead
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@surriel.com, david@kernel.org, 
	baoquan.he@linux.dev, chrisl@kernel.org, kasong@tencent.com, 
	linux-mm@kvack.org, hannes@cmpxchg.org, shakeel.butt@linux.dev, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AADF6120007
X-Rspam-User: 
X-Stat-Signature: f7b3bdo559rpbbsoe16kmc85sqb3geze
X-Rspamd-Server: rspam08
X-HE-Tag: 1780992094-320375
X-HE-Meta: U2FsdGVkX1/O5rRSTfWfKEboPqyQd9HjsFsamKOK1igvwIHp5F+Ldk714zU2UH32Kr5HYNL4V2Xd/y2emPLYTryKc7aFc1KtWjZBr9fZNlEfI4nQsHGEPVRPV2NMj8y4KtRehCQY8N8FL0KRFoKv9JkUTDqCJ8J2IH8L1zLwRdI2EumhYyDt4QWccTdXf1/osQmOVXIIDnT2xI4kkglGbnU3YGicfNuf9NJ7hFtiPyDyqk0Ymti2x5LuzOUXk8yZb6lAE1UNv1MBzZfDaPrhwsj6Z3ffCp0neCxwrMva0Dp7m1XNGKl+7XBJeWgft5UELyRfXKRp+3DYvV6mURKyDWnCwBWsR3VLlsNXKfATTlFit19b92tht9WFBHK0Q0+qJhwTM9OGmWyHbjPGBrBnR/MsgIve5xHK/vzrK29uOFtvR1sTHMWi5NkQtGJ/a3oV5q8L0u1yxjLUOPPX50qNbxqv/xfDAMUGFqHdufgLnWjUQmzi3KUFTZdeWGvM+Y5LjXYDVHNVazFNaozzMS+3I3CBLtqdfiJCAa5V+yfbw4jFDxMLFso8qth0b9KoDArN5rlj8lffz7KEok99yMGVFoSrDWcAeVcwPfhCZuWaYaO1kqSkMtIjVAHT6p9QpxTCNlFX/JspQ0QkmuMdm4sOlI5DwMIx+TO2WNLeKXkEW/mf7Z29f3g2vYk2WWdl3VSa1R7zSMMMYiNrwUPkyznL7R/SN3YDLaxQO8Br6wr53F3DMTzwH3lHYTrH+BnmFNBdoVq9CLsfdKV1Hb5/FJu7r2vOF2qqS/jbZuFy8g3rz2gvIaF72xmLlCF4ZShFtfWxokqxizKizuPEYDCjrcQbJoO4AOqUH+nempfWBYKBgrg5msxJJzeS3Og7PB4NBBTSIffUln3/dafAeR/8S5XeuAY6aUPCWUWmHU1Lr1cBMQ8UPQ44dlPHg9Tta32oej3w2WB2MzdFnGQ2aKQiWoh
 5um9aFHZ
 Sg2vjWzdI3SSpjShkWpECCJC3wrKnm5fYzbAt4u+ScPYq9Ax2S+fWpRjhhpG5rbn6QEdcy8lY5RqsgMwpxuA+MZ1bhR3sSZachw52a+Z4+K8U5M139FQvUGRmLn+Hqb8tXl5//54BQpSjVhaiTIx/8lO6InxnNOexjR7lpu/uSMBm4TW1ElajPB8JeF2wuwQj7RmR/IC2FZ4/dYQoEJ27SDIOBjzdzzF3bwnkU7iWA5sTGT5OBTwvesyEcrsL+ttC+KxvoN1d67Dx2eDmFz2M0YKDgvH5rwCg+NjgKxXQXvsablghMe+Dd8AAQ+V9WJjAAbOjKsoFkOACL+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 10:33=E2=80=AFPM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> swap_cluster_readahead() and swap_vma_readahead() end the readahead
> loop with an explicit lru_add_drain() call. That drain is a leftover
> from 2.6.12 era code and serves no functional purpose for the callers:
>
> - do_swap_page() ignores LRU residency for the readahead folios;
>   it only needs the target folio it called swapin_readahead() for,
>   and if the write-fault path needs the target folio on the LRU to count
>   references accurately, it runs its own lru_add_drain() at the
>   wp_can_reuse_anon_folio() and do_swap_page() sites.

right. as i can see the below in do_swap_page():

        /*
         * If we want to map a page that's in the swapcache writable, we
         * have to detect via the refcount if we're really the exclusive
         * owner. Try removing the extra reference from the local LRU
         * caches if required.
         */
        if ((vmf->flags & FAULT_FLAG_WRITE) &&
            !folio_test_ksm(folio) && !folio_test_lru(folio))
                lru_add_drain();

and the below in wp_can_reuse_anon_folio():

        if (!folio_test_lru(folio))
                /*
                 * We cannot easily detect+handle references from
                 * remote LRU caches or references to LRU folios.
                 */
                lru_add_drain();

>
> - shmem_swapin_cluster() immediately locks the  returned folio, waits
>   for writeback, then operates on it - LRU residency of either the target
>   or the readahead folios is irrelevant.
>
> - try_to_unuse() likewise locks the folio and calls unuse_pte() without
>   depending on LRU presence.
>
> Folios newly added to the swap cache by the readahead loop sit in
> the per-CPU LRU folio_batch and will be drained naturally as the
> batch fills (FOLIO_BATCH_SIZE),by the next reclaim/compaction
> lru_add_drain_all() and so on.  The unconditional drain only
> synchronously flushes a partial batch and forces contention on
> lruvec_lock.
>
> On a 176-CPU production host running a memory-pressured workload, this
> path was observed to call folio_batch_move_lru() from
> swap_cluster_readahead() ~28K/min, a very large source of LRU lock
> traffic.
>

Do we see a workload improvement? If yes, can we put the data?

Thanks
Barry

