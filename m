Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D557D606A320
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vjt5Nzor
Received: by kanga.kvack.org (Postfix)
	id 020BD6B05B1; Thu, 29 Oct 2026 09:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED366B05B3; Thu, 29 Oct 2026 09:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB6C6B05B6; Thu, 29 Oct 2026 09:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B588F6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:58:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 454481C0D0D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:58:39 +0000 (UTC)
X-FDA: 85375819158.18.5DE3891
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4D07AA0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:58:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Vjt5Nzor;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793282317;
	b=7l1WNmDKIcjgoBccPV22QVgxVYDWygBaPDqOn5Zo2UlVHq8I/AHQoTvI0sDMagkuv9slqy
	WWA3FCrYp99AexZ3E15SDc4NZnJaHTnivFN/ZuMoC5fmiFyKMzUN+RWQaTY36eCahR7CpR
	iI+3CO+brQNdPyLmM5k3nVMQXEHNiQM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Vjt5Nzor;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793282317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TKHPwAz92PdhTqProcfmSePBu6DLZeLwLhVUswgSLow=;
	b=rqyirNRIFR68g+0M6TxBcZPtYMvVYTMkKWNoBCB4mNUrUBsD0TOib/UXNRLy0Wt3s0iIa5
	L6tb5P6nGYYNByZBEW+hpKKT7Et+PedbOn06ERl+X2mv22FHwLywAq9C5PVBdSFno+pU4h
	q3o5kXkcTh8TwC/MBeEyGIg5Hq3Mpks=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c43373ae89aso340297066b.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:58:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793282316; cv=none;
        d=google.com; s=arc-20260327;
        b=oIhZ2EsG1DV476nspFW3bAMW6v/4Il4tqv52iDRkAGEdB0zlGZ8WiJsp9mAczN5jlh
         LAfYLgjm6YPbHfww/M5v78sucjnX9PDo/BieSLs5s65MYmL3ufCzX0imiWW/Vx/t9Sfs
         RHKTXBKYURoOGF1DV//jrtAxuLtdUff7/Ho8y3tm/dwCZ5/jFQg9tehbI7PQA1l6NpHE
         bt5JtEHBSYUnAjXcK5opG2l78uJozhUZ8fTXw+NmOpJcoRzuteqpS9EH79IjLH+iPau8
         tFpBpMny7DKkVfQvcw/jejK0kE5Y/olRf7BqwNtokxeo8vBjsnH4lMC3qckMQYX3A22w
         LXVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TKHPwAz92PdhTqProcfmSePBu6DLZeLwLhVUswgSLow=;
        fh=p9otZVfoBK2FUoC9VRBwEZoTPggAhj9fks9c3zOPGOY=;
        b=dLh0mJCohA39JEkPIwS5tsIYXppR2FTeksOK3rDF/X1KfvmaEjQokNzoMKX2Ch26RS
         4jByDFY2R6gU7FCFoDLxSmnBfB5tit0KNC8mQ+Rwyw4lR/rgNwahvlNXehDtXBzkKuZf
         MRbbZpWqvdtTTV5a5f080faS07U4sQ4V1IoxUgRnqJZIQ6Y/1M4jdjYfyIxlufvG4Grb
         oEnM13ZsJYPKfhvZLAsS0U5LrimyxinpEEAy/dcS9typE7FpV1cfY4sx54yTSdOPW3PJ
         UHjdvXVreToiifETMLx2B7OL1gKf4pr0NT8IOKZnNedBXEg4mx3dB69mG1V8aIcW0Gch
         VXaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793282316; x=1793887116; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TKHPwAz92PdhTqProcfmSePBu6DLZeLwLhVUswgSLow=;
        b=Vjt5NzorQ6L3HYrI2ZXL4a5h6BEy4JGrg08heUKdZaJ+mucJzo81yZORfWMDe8TlII
         8Ya57Nt9EuI+H/QIwOPFOEfBONBmwkG0LDBmy3pSE7pgZgIMXBDcBK+wuch2orrnmyPX
         vqQBy8ge3Guh/f8QsZsIThWCyBFwVGjy7BMsq26eOQl8HG1OX16/5JtY69tFL7cuFyEm
         h9MrsWb3F9LjoeCOu3wQIf7txSLW0Pv7jAq5UWUxKxY83AknbLdJss0TFQTaXmKnhrlc
         A7GtxQ+SCPsFe4bGvEwzL7er4fv56FyDAqf80/tojUd+No0sL1tRkxHpJWvYHZ1OxTj1
         QViw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793282316; x=1793887116;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TKHPwAz92PdhTqProcfmSePBu6DLZeLwLhVUswgSLow=;
        b=IpzkYCg8fhKzem8qJwEKApYTZvSE0iWIfdbJgGx68q7u3yt0nDUE1eOhoV/IZKZXy0
         W+N1unP4BtOG09BLAQw6/nHqjoJIHs6FdGFsKYeR9XJk9ZzuNJTn7+sQVULD0Ibl3cxA
         2hxdW57qhGPiK7TTDxwARMtuMa/k0saRDPfwR8V3V5gPqa1Cav1deRHmEI8ihfA87RNc
         7N1CZVpqnpZe13NZf33UlNf3ujuK0BpGzf889JQue3ZGkn/awXwjg7uKBsxDugDwhuB0
         9eTodTrA6QFp1A41KoP/AcjvHyD6D4TMsPx4oRSuvFfUEeCLaaLcmIBSWCvLl7AAtnEP
         M9Eg==
X-Forwarded-Encrypted: i=1; AKwUvByFY8caNLRsWfNYT7BsLUNQ8cS7BiePo2URShdUN25XybcZvWCYzOQANBt3HLOrgLJ6/exEg8gnaQ==@kvack.org
X-Gm-Message-State: AFq9FYIgR4Q0FCNUxvQeuGIt0J0SxF39o29OgN/1m2D2QrSyykKU9KLa
	imDdeNWGq6MxPUcJCUdXKcpPdJS1Jna4BdV4wLco0lvxogN21RBoes1lBYh0MBg1wNfrQ5w49TD
	QbAiEFoUcirWoMFnrluUOgDNSk6VwTso=
X-Gm-Gg: AYBFou2gAmleQUMZwuuWwMKNiyce+AK9GAyoDRY3dOE8YHDbGNLZVk7HJQbRfCFM9X6
	Cbp8mEgffBhk6XOmzRizH4QY3VOyAsUDj1puyDzFmX5QbUatrCWBMBRK4LWkPVJFjOSphEr9L9v
	h4pSZ6PSPTVaXhfNSh2chBtP7sS1WGMllSDdJgsuWt7lApambgBMWFV0daRlZPPRnvQ3GVgn8LP
	Tpc51nh7BgahtBQtiVU5r9r3EOmDVG7X/30f3w0phY0Ri/lN+uh208TKUNptUTeIORZNI6rHRPw
	O4w+as8m5oOJSoerMw0gAkLdtgE16MhQ3oCwlCGFC2LTTv3IGwLCFXSPKcTXi1u5X86/zAwZYtb
	hKGZ0b8Exiu5L/sSABvIBn8mgbbd1yQr1WtR0oXtvcJJkx6unPw2QrCmbjlsKHQ7je21REQ==
X-Received: by 2002:a17:907:d649:b0:c40:d762:feaf with SMTP id
 a640c23a62f3a-c49bdf380c3mr490800566b.21.1793282315466; Thu, 29 Oct 2026
 06:58:35 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026-swapoff-writeok-v1-1-4f4cd420aa33@columbia.edu>
In-Reply-To: <20261026-swapoff-writeok-v1-1-4f4cd420aa33@columbia.edu>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 29 Oct 2026 21:57:58 +0800
X-Gm-Features: AclHuK_WpVrYhoxFjt0fFzoVltcEmX0dIv3cEJlmPJMkDPc9YKVqxhVZUIteE9Q
Message-ID: <CAMgjq7AxShdVC6Ax+5USBSCb3c92MC3UVGLucxN47W_EmVcwDw@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: stop cluster list scans once swapoff clears SWP_WRITEOK
To: mt4022@columbia.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	tz2294@columbia.edu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i3pz8qqcbrs4qxwm7fmw74wdu199cstn
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4D07AA0006
X-Rspam-User: 
X-HE-Tag: 1793282317-437581
X-HE-Meta: U2FsdGVkX19TteXzXT8YR/XNz7zbFJYd+iUK2H81dHNKe36QZ4JR0cf+74OCJp3augwGoWA1CfO+WF4qt4JwqZyH5q2GovgxVZRdn8f7sc1kJcmfZCKhuNF4CABySo4oOpXlXk7i8rsUES+i4zeSYegAh3560hivu8OqIseUw03AYmljZkE7Dno3mqgYOLax62m0QtERw5bPI/SrrjOlwGWYVhHJgeZVwcm/SW9e6OhzMB3zCyiqinWBec0irh4tevW6EOKSoO/3uHPTYPneGn+6uYRY1Ode/NZjlf/KB72LcSoSP6izUp35gUqgbV+JQS7T48IVWSPbrbLQ7qvjHPlvYsh9Fa6kibM1ecC/PiXpbHD0Tj0cRuAJawN+qxXJdY7waPOwxiOr2SNG5jiJ7qPIRCssYuo3GmSSfO7RIDJIpBL6sL4N/ZMowuS/7OVI3DyXihSSdffyNSkxRfXWP4j2NGq0pxAmNyVT/uk9SIzKf4tgjKcRWC55oP1nvhFfQDTI3FIEOEi100HzmQgkEtYgbKBGosZJNUGSaDcbwJR6qHvH5VQQtEXuHHj6RFHt2fAk9O5EJuZqIjiABnVTlwnPSevIEIGN4HdMCWhnu9OzKMQBqcb41YGHddW5uTjXyTzjDRDdTwTWlWp+HN49N8MwPgaoEqvTt+ThOdVruo7Y/4gzM8tZHigRntIMRfOJJkMGlrDzNkAwKOpw/JT5t/ab9DyaLz79P0AUxLgNkMuwtm46YbfTgKQy8xSkUhwv+CKs7ODeCYzAx0Ab9d4bq+uEzEwDs51jyjLQBikvUL7WYwpWELEUyrCc1zjv304oElpIBJEVMnOJ5zKOWxlZwjwMNmEp+TF1eBz3ZYnQWwvXjJj92QmpbxEqcW+pOltVFLyp3wy7m33WDwrPVmyQsRHYbHfHUmDpgIeDyBPAO2653BHtir006m+4OyFjqweuPsuKCgsSEMlBtpvuznJ
 A7QWESeh
 QNFHlovvu5oLw84iaJcgeanL1Z+vBNL1/l3qi7DsMrWbh/9GFwk+JbsakrM5qnxqARpDJkLTv8TdUkt32dSa2RZDans7Nb25bs8lja8DLc2biW3+eDPWXQTVrZ9auLBdgHciTTDaCeo2pEeioFlxIQJU7VxprwoLvpnp+/XrW6mjgSb2+aEt6rc4pB7aHrjeRcH0JEe5Cd1OIRPcEIeCw/Tfhvp3Xk6dkq2d1iNkNtOUdODGTOqUMOwmtSCN/pRyyCOt3bhABXzlEfdIsW9ZwGVSmwn1d1q6DtB5H0LlVbjoPuVFHWyag7dgxNd9+qAL2HOv4ZV4a7iazIxRTMi7QtLzAxGSctvOvRs5v/01bLSkYUa9upN1TLRi8a8zhI+eVlOb8E4FRJCfqppIjXOePKWtIFYej0Lt7Buz7GuVzd94JBzxlDzrNeuDs1/4E77G633fC7aO5HP9mlpUWa4hk4CXxV35wxNNol9N3rd0WbcHALN6tAeh4hqFSi6C90yvmtxj0vcQmDtpvsBEQ+Lhx7Hfq7OPLmBrsaoiDsodbCcyztRq5noJy61YPD2gIL56E21S/Et0WAv1FW34h6pxmGMYt5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 11:21=E2=80=AFPM Mani Tofigh via B4 Relay
<devnull+mt4022.columbia.edu@kernel.org> wrote:
>
> From: Mani Tofigh <mt4022@columbia.edu>
>
> SWP_WRITEOK is cleared under si->lock when swapoff starts so that no
> new swap entries are allocated from the device, and try_to_unuse()
> then waits for writeback of the folios that still use the device.
>
> However, an order-0 allocation that chose the device can race with
> swapoff clearing the flag and then loop forever.  It takes a cluster
> from the fragment cluster list of a higher order with
> isolate_lock_cluster(), the allocation from that cluster fails because
> SWP_WRITEOK is clear, and relocate_cluster() puts the cluster back on
> the same list, so the loop keeps finding clusters on it.
>
> The looping task is in reclaim, and it may have set writeback on a
> folio whose write has been queued but not yet submitted.  swapoff then
> waits for that folio, while the reclaiming task, stuck in the loop,
> never reaches the point where it submits the write:
>
>   CPU0 (reclaim)                          CPU1 (swapoff)
>   --------------                          --------------
>   shrink_folio_list()
>     pageout(F)
>       /* F under writeback,
>          write not submitted */
>     folio_alloc_swap(G)  /* order 0 */
>       swap_alloc_slow()
>                                           del_from_avail_list(si, true)
>                                             si->flags &=3D ~SWP_WRITEOK
>                                           try_to_unuse()
>                                             folio_wait_writeback(F)
>         cluster_alloc_swap_entry()
>           isolate_lock_cluster()
>           /* allocation fails:
>              !SWP_WRITEOK */
>           relocate_cluster()
>           /* repeats forever */
>     swap_write_submit()
>     /* never reached */
>
> This results in a soft lockup on CPU0 and a swapoff that never returns.
>
> isolate_lock_cluster() used to check SWP_WRITEOK under si->lock until
> commit 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap
> table") removed that check.  Restore the check.  Since swapoff clears
> the flag under the same lock, isolate_lock_cluster() then returns NULL,
> which ends the scan; the swap slot allocation for G fails, and reclaim
> goes on to submit the write of F.
>
> Given that this is a race, its reproducibility is non-deterministic.
> We reproduce it by using a non-rotational swap device that is not
> synchronous, with 64K mTHP enabled, where one CPU repeatedly pages out
> two 64K folios and a 4K page with madvise(MADV_PAGEOUT), while other
> CPUs run swapoff and swapon on the same device.  In my tests it
> triggers within 20s in each run, and with the fix applied, it runs for
> 300s without any hang/kernel report.  This bug was found and
> reproduced deterministically using a deterministic hypervisor that is
> currently under development.
>
> Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap tabl=
e")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> Before commit dda8fb68b590 ("mm/swap: also use struct swap_iocb for
> block I/O"), reclaim submitted the swap write right away, so on 6.18
> to 7.2 the loop most likely ends once swapoff frees the slots instead
> of hanging.
>
> Reproducer: https://github.com/manitofigh/swapoff-repro/blob/main/swapoff=
.c
> ---
>  mm/swapfile.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 601979b97f95..2b03d14b5f52 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -627,6 +627,10 @@ static struct swap_cluster_info *isolate_lock_cluste=
r(
>         u8 flags =3D CLUSTER_FLAG_NONE;
>
>         spin_lock(&si->lock);
> +
> +       if (unlikely(!(si->flags & SWP_WRITEOK)))
> +               goto out;

Nice catch!

>         list_for_each_entry(ci, list, list) {
>                 if (!spin_trylock(&ci->lock))
>                         continue;
> @@ -642,6 +646,7 @@ static struct swap_cluster_info *isolate_lock_cluster=
(
>                 found =3D ci;
>                 break;
>         }
> +out:
>         spin_unlock(&si->lock);
>
>         /* Cluster's table is freed when and only when it's on the free l=
ist. */

Acked-by: Kairui Song <kasong@tencent.com>

