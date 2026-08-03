Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1779EC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 17:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87BD6B007B; Mon,  3 Aug 2026 13:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39C36B008A; Mon,  3 Aug 2026 13:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27696B0093; Mon,  3 Aug 2026 13:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB8786B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:31:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4789B4079D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:31:56 +0000 (UTC)
X-FDA: 85060651032.11.D1420B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 69E0C140011
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:31:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G6LhpyNa;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785778314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kP/as4F13JIZLEq7A3z9xVybs0LHJUVnzLyJAncMekY=;
	b=4NQCdixzKDjg5sU6yRiRg3fCqGQdw5UdmN/B/eoxZ9byvomWUdpbuIVILiV/yP+U7Hei13
	tv5/EzhcAhetzPoCKhm/GO0Xzrjyqdbe+pK7wGwbRbQQwEVUmuA2jFf/iAS5yYXPpCKG3u
	U7auVgxj/ZCRqbFRDj2ZLDrfVzv5fnc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785778314;
	b=lUlgAtEy1pVIYHem2TloT7dguX46Q2a/5jYt4wgMgs8zUxMa79iRP9kGf+pSRcu3EqZK77
	eQwoPeEbEiWOQa3S9gWK35oeEvxv2WCu/lhSBQY6TyYyoDKvHT0i2uOQS9qRvRX+TxW3Cy
	H54K5XbSPiDjq6OPvokNVGR7+gechmw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G6LhpyNa;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E52C260A64
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B67E1F00AC4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785778313;
	bh=kP/as4F13JIZLEq7A3z9xVybs0LHJUVnzLyJAncMekY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G6LhpyNa1Vhjx5jvqEQrnshyjhLapNMnrCCk9UDAELk1mM2usl8xOnPKb2erTrypf
	 fKBzKmmjgC4iVC+MtyCY5Qj1qhDpIpMfuYD3uOx6EQLftQjF4//Cw1zvMgBCpK/HAy
	 Arj55ZvVpklCrnpkSGhGGQUApWcywzz95WP64h7Ry32gycTLGDsD+eLkHoFqD/zo77
	 zQex9keMt7n1Bs7Sv2I/0SDmg/3urwhmHHQKHsBv5wAZ2mGY1+Q1onwAvpNrjZmW2y
	 EOZKGmAE2GGSuU4xYwUC85eT6ZsujqpuBdavjIwR9uGot/4vyrkFLqgnogErVUFgtn
	 Ul7vCmfV2Rzgw==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a0ddef4e35so2150511a12.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 10:31:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrmaqlySUmVStUTLQ+meD1K97y+Ml/6791iMY4QHKAWYXpGIn9uVEQClcBTMYkjWyGK1Akx7JTBuw==@kvack.org
X-Gm-Message-State: AOJu0YxNfBttiD1gQE7apzY50VI1cwNUg4Y/GJAgr0ZYs+e995W9tSfi
	ntR6/eAWwSRQHtPpXS8+zvUVaVgHSNpC1AwZpHE4zmBJ3Bai3SL0DssZ3p+0gcOxFg1Sj+wncVf
	uPgFODvtMt581TRxlXrt+QpLeEG5EN5I=
X-Received: by 2002:a17:907:e1ce:10b0:c12:9e83:643 with SMTP id
 a640c23a62f3a-c1fe80ba536mr626054966b.10.1785778312482; Mon, 03 Aug 2026
 10:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260801041255.752039-1-wfelipe@google.com>
In-Reply-To: <20260801041255.752039-1-wfelipe@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 3 Aug 2026 10:31:39 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMRqS4JfqMPVc6GEDUFEVh0iGJ-aJ1Qkyc6HsZrX-5fqw@mail.gmail.com>
X-Gm-Features: AUfX_mxohrESAVBn6B2CetOPgdBGq9v0PbqUo2sqAAkMgwT_OKc2RepE-CGcklY
Message-ID: <CAO9r8zMRqS4JfqMPVc6GEDUFEVh0iGJ-aJ1Qkyc6HsZrX-5fqw@mail.gmail.com>
Subject: Re: [PATCH] selftests/cgroup: test_zswap: skip test_no_kmem_bypass if
 debugfs is unavailable
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4di4iqa69k9hnk66fgm4hdnziicmzqr4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 69E0C140011
X-HE-Tag: 1785778314-273239
X-HE-Meta: U2FsdGVkX19+Rvpf/DFjQ/VH/r/gPZ74wafOg1mBSOJr/QB55pfHk9nHhJXhwxo7KktkBqWXWEcLHbcy7AVERU9CGkibLTL8TxKAJHuvqLQXAYnqVYlXsTDN5XIMPOxuqGlENzguqHWaWZuJRY6S+4bE4FJB2+sxUsneFbXd8kHHkzfdTxh/5Q4IwC5fhYpqt3JtKkgjfr2VnhIiIWs0lB6Te27PoHtTaWTwOn+EIntaRpNaXV05qo+nUVa+ysBMyZRwyvPViSalEYMj0nwGp+qgeEvV31fBXBLvaFPjeMegDjgcBWETsC8bNtkNMGCAydEnzh+e3sehx+denLnIXWhWkkpSLmxJjAmfJTCX3+ibF3gD67yjIM2nv2DfEIYGfKLRTGYgsrmVfj1VHMXDvOtP098e1w4VxA+o6AHDPoD8kdhlVBlPXIgBOTYzKIcfFizdDt0jSLq08ghpNqVeqp2r36fg9CQ2IKzwCXxdE4FFDYtP+uu6+q3bDW4W4kjeAmWyXuFpnyKCjkHXOFc0Ak2wTEkz6k1jn+nBDviQbwFVAZPb9eO4Jm5BNIpAEiuBk0gtIzJgo+wcd+VGDZ6xKjjo88sDOPg9WUe13XzulvPkKDb7/n/wa3cTXIc4RVPZVMWa+zzVTg6fqgmy+o0jx/F4FXNdUSl1vTR5M9yw4gfsc5bJte58t1VBVEDhbrnGL62cVemDSYaiitFHqsJ6P1WPXGy0Rk689QyIuUC/QjdRcvRYDRjgVaXowjJCSLR5oDwwz5sYtbfjKfm7vZdzusbj87IhYjxZEu1UZQvNnuTsO3JViUawRTsCBB2bW+i79HF6wlnc5c8qfyMe00Q7/l3oHy6L4hpYpp4UoCC2qVBURh5TEzEmX0kohXPGqUItM83XJg6XF/ELWgzrLiTVn5gM/YWEHfpmTgncM8wFk3++el3TSJcl3afoFFvMH6gmrRe2KNaIsDUM96l73F3
 4MISy3+j
 iqqudIDMxGcSKmj+RWm7cvtH/useZVdFDawMOKq9cQ5nkkl53iyisjp2i+5VpKfdNYU+vgxakySYOCzMy/pXLOCtT03PgC4EEBNm1HWmRmCC70ta6cees0ZT4N4SJpvcJDJmwQ8+y9YTm4G1/rv4kID4KrsX71v5JENxepmOQoYT6vtfqCVeAs8Ecyv49vWR4EpQMu8kPC+uvnnKYgdbYFha1j0mysIbilUB/wv2X5a8xZFP0FiGqV2X7Dwzslk9o3Fq0xmnk3DG18zoKMoJgNj8JWFRNVgS3zH5Bptgj4aiK19fZ+tyW2yzLOYpK/GUqo0SXWQFUWAMO7yLilSc7NRqGIR914KOiHIty
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 9:13=E2=80=AFPM Wilson Felipe Pereira
<wfelipe@google.com> wrote:
>
> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
>
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
>
> Selftests should not fail when if debugfs is unavailable, and it

Nit: I think either "when" or "if" here :)

> should print a message when it is skipped.
>
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/=
selftests/cgroup/test_zswap.c
> index 49b36ee791606..c4f7b66f1b206 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -566,12 +566,19 @@ static int test_no_kmem_bypass(const char *root)
>         int child_status;
>         char *test_group =3D NULL;
>         pid_t child_pid;
> +       size_t stored_pages;
>
>         /* Read sys info and compute test values accordingly */
>         if (sysinfo(&sys_info) !=3D 0)
>                 return KSFT_FAIL;
> -       if (sys_info.totalram > 5000000000)
> +       if (sys_info.totalram > 5000000000) {
> +               ksft_print_msg("requires less than 5000000000 total ram\n=
");

The message is hard to parse, we should probably write 5G instead of
5000000000, and probably change 5000000000 to the actual number for
5G, 5368709120. I would write it as (5 << 30), MB(5 * 1024), or add
GB() to tools/testing/selftests/cgroup/lib/include/cgroup_util.h. It
might also help to print sys_info.totalram as well (in MB or GB).

Also, the comment above the function says 4G while this checks for 5G,
so maybe change this to 4G while at it (or update the comment).

>                 return KSFT_SKIP;
> +       }
> +       if (get_zswap_stored_pages(&stored_pages)) {
> +               ksft_print_msg("debugfs at /sys/kernel/debug is required\=
n");

IIUC get_zswap_stored_pages() can fail for other reasons, at least
theoretically, than debugfs not being mounted. Should we explicitly
check for the existence of sys/kernel/debug/zswap/stored_pages
instead?

> +               return KSFT_SKIP;
> +       }
>         values =3D mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT=
_READ |
>                         PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>         if (values =3D=3D MAP_FAILED)
> @@ -604,7 +611,6 @@ static int test_no_kmem_bypass(const char *root)
>         /* Try to wakeup kswapd and let it push child memory to zswap */
>         set_min_free_kb(min_free_kb_high);
>         for (int i =3D 0; i < 20; i++) {
> -               size_t stored_pages;
>                 char *trigger_allocation =3D malloc(trigger_allocation_si=
ze);
>
>                 if (!trigger_allocation)
> --
> 2.55.0.508.g3f0d502094-goog
>

