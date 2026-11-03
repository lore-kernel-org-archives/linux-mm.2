Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CB5606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BhSuZQGo
Received: by kanga.kvack.org (Postfix)
	id 990A16B00EF; Tue,  3 Nov 2026 07:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941126B05B1; Tue,  3 Nov 2026 07:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809246B05B2; Tue,  3 Nov 2026 07:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBFE6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:20:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E51161C2753
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:20:09 +0000 (UTC)
X-FDA: 85393714938.03.6F5080C
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 18AF220002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:20:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BhSuZQGo;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793708408;
	b=NrIqRtpimsSwKmigq/gUZ0HKimHAEwsb5UQJwFXTVh0R0KnkcTZHU59havr1SO1/97dcNq
	lDQb5Jo9wweSiWlShC6J53xDOeToJoq1PjjNBNoyJd+D0MrK8220CT3Nh3fjJW8x2I5i5e
	xVEZzCW/Yl1VCdad3MmBu6x/TFOXT+0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BhSuZQGo;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793708408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3CD88GfA2FxXgHDjjooA1xyO//Rj+QTFMj4P2VOKKgE=;
	b=zMlNz6pW0J6cNx8AOF/UIcjZF/kxT+APdvXSsHB9sKAaoxgo67KYfZ3W630SfFwY5X5H7u
	BuiGkNZF6XG7xUqqKDmqxO/JuPaEj98BLf2tEqhnbOhfaghyb5OZjQ9YKG6Pd845+4meKB
	eUQPlSVgyFrsMGHRb7VJOC4dSy+80E8=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1a2761c69fbso6928390c88.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 04:20:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793708407; cv=none;
        d=google.com; s=arc-20260327;
        b=bcLIESliCPy4ZCrlX+MG7M3ltFnkkoszTwYHVD7jbJIYFa1g42AdwKl3qxgiNrIMAL
         W9mv+K9SClpdLpQPuwp7MAyqIH8ra4r9naIxYhwO617BLiMAOXVYbcB1sTesGcjb5rCZ
         ha6NxpwVgXJ5lcqdTUtVA7LrjiC5zeBEXN2hoo0onMCzhi5QYS+2mRUnn44E0J4geyUn
         MKWLMP9PcTPyTRR/p0EvTkboMvMD5GqYFys7Yo7HBFFyqtyH919xLWVP96PskEgIidFd
         Sdc3FmAkZm41qNnoMp1JvSr2+0wwMgpcDl1JCybBIsZdFhec9TIm3UkvvPx6bc7ZHKw0
         +OFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3CD88GfA2FxXgHDjjooA1xyO//Rj+QTFMj4P2VOKKgE=;
        fh=KdOblE5+EEK/pe2tYEnG+oMDkFw7Ls/j6+ISDtQElfg=;
        b=gS3ghrON7HSa62IwFr02j7Kui6DruyZ4IKwiY+iVIwUPeOhW8aTArZk6+GM8/HL8Gv
         Mz0NINkhj0rojE435dvwAeAW1IcUlve0ykGHVbtVK15miihI00H9zsZphk4NieZTQOb1
         blEcgFfKL/KnqDlEqv+DUPfCFXtuP7w+mkbYYhcu+ohYynTT0YToSYFrFkK75H//mFb9
         VwJoEMp//cUSpfesEOS1rjlAaxU9UZrGuhMv8Tfq5o/+9xPmV+9zoua+Ux4osrS+/J8k
         wQEyXWUV6M9bZe2jOtVRpnSPATfQNVrVTPij4aJTkQlLYYWiyjrK2qsHZeY8bgVNvCJm
         oEbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793708407; x=1794313207; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3CD88GfA2FxXgHDjjooA1xyO//Rj+QTFMj4P2VOKKgE=;
        b=BhSuZQGonfJJv7CpE0gqc1Nt9ijfeUojmqmGAN6lHoMl4xpANs0BFdcc/bLpbbSUXO
         yw2NdlaruSLEQdRe9BxPs2qFWNbj2NMc1c1pZKSLHzp833Sm9poZ7C8dJXaUsGv8+Npr
         uXi4pPQm6Wp65AVMlPeYHjp3tvF3rFruWePlETSENyqqaolu7fDq6jxRoC79jAO083LJ
         eHtcdlkrlL5/bWvZpJ5pOlwpKO7d+nAdpIx6UyHPLy8Q6oEOS2jUj+LRhFnRui5SLjYX
         XxA7oDHvOF6oifDvZFZDkPU31ch3jZ4n7w+G8nV80JDrPo+c1MuW/cxJyCuw2/UdF3li
         IXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793708407; x=1794313207;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3CD88GfA2FxXgHDjjooA1xyO//Rj+QTFMj4P2VOKKgE=;
        b=DXSJr5E2fDrO0Tq3ZwNb2r36seprHBnFlLonvqL0scLj/WjOhwx2Npz4OPvAf3Tb1K
         b52dt0GFfgizOJrycsUDlzyjaMCH/HXLGpF0ZwV6xA1eeyovuWq2v13fRD2M8Mxoy8sl
         54B/0frkQVvN+p3+9pXeqLobzKVIBgR4rE9dnwPhvWWS2rBS10BtMpaL5Ku3XLbdqT91
         Vw3cpwDV85LHVaFUnElfG/A448aLqiWdBpRdMs7EY8bjK55/xz7e0zQ4o6hscBrAXodH
         Ar6dpRUzITEnoa+eBx/1ZITqaXcLw9LbOmoAfwzOFDIlOTsgQETfcSZNuESBcjRAud7T
         khOg==
X-Forwarded-Encrypted: i=1; AKwUvByE+01pRfOR7wTAApvGFTxj+KEkM5naN6INOGRsI2acHOfu3A3x6xtRcdqfAnS8lO2IyCq+1ZoHjA==@kvack.org
X-Gm-Message-State: APuU4Z9NomEIqF6ZIPMm7VkB25AvmkdCMUCz+3myoyJzwJ14LUNLjpoU
	S9iiYLNn31vqTkXa74q42rT+0oPEBLoszejrqgZEK2QTe/g3OGvz6Agg/Kfh4y0RMMZc5i1C4LC
	nUd+rOpwUWueozZ8TiKpz5S5IqheMy0prvTQgIciv
X-Gm-Gg: AYBFou1kH4AL4lLnTEeeyCVozcGs2KuFD6fSjbXJQs9337dLoln4QaQDH4Fd00RF9pT
	TXLK3yYfVcDX8oIxLq7H+VlJOOqJCVFrskKfQkDSw770EaB5EsAjle/DRUsOYMEpYAtVv7VYLBQ
	gaIb7/FfW93J6Z61CezglhAaDc58awDPYO2RZEsGuZ0t4GdXvwuwJQyugepzYrEGDjs/obluvAv
	AaeUtDGSRvd67IDZKTTKe8sn+yAtNmgzPFZlEFo4H2zecQkPNJUESa+USuRLQVIgYdqXB/ZkXPV
	xOs79s6HTFdoFaI0xb4vVIJ43SJMQlFruRphCJcfSuFwJERG+gFuY3rpaIAW1RevCf+ZsnC9O6T
	WcYlmIK6RQzTDxK55DqA6NEK1ZRmpA6Tb0LIIvmG79Ln7eexCs90BIPvagrXDe4X+wA==
X-Received: by 2002:a05:7022:eb55:10b0:168:3243:c90c with SMTP id
 a92af1059eb24-1ac59dd356cmr20818361c88.15.1793708405984; Tue, 03 Nov 2026
 04:20:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103-stackdepot-full-warn-v1-1-41f1fc651b64@debian.org>
In-Reply-To: <20261103-stackdepot-full-warn-v1-1-41f1fc651b64@debian.org>
From: Marco Elver <elver@google.com>
Date: Tue, 3 Nov 2026 13:19:29 +0100
X-Gm-Features: AclHuK9s-1nuK7edLIAKwVSP9sH1OemeE-hzzY1kqIDXOO8vAkwzu4SL6CH2ltk
Message-ID: <CANpmjNMfNm4HwDFV=WdfR4AS0affDzEn3Lx0=A38xx9igJb0hQ@mail.gmail.com>
Subject: Re: [PATCH] stackdepot: don't WARN when the depot runs out of pools
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Potapenko <glider@google.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	John Ogness <john.ogness@linutronix.de>, Petr Mladek <pmladek@suse.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18AF220002
X-Stat-Signature: cwqd9treua49shyfcfporfudeoke4brb
X-Rspam-User: 
X-HE-Tag: 1793708407-239596
X-HE-Meta: U2FsdGVkX1824HnbKHbRIOXNQMl++pTrT82P/EQXx2vscEFhnrc73njYcFFLsRfNoli7NmLVoDxEXZd3/rKukOOHq4I6Ut3+M24uT6dKTtV43jo98WWEe0SFmaTotultlsnwtCpq5/UjplqkbHrjgb42G2500SKIReYGW2YQ+0T9Vdj2OH0zmMrMunPI1C4k95/s4jBw32OqUXbEPaWj/i6UyU3JRmYtW+84qoIMHfChIuPmWlMLx21qlijf8A6ygcPtacWsJ76/eRsg3HygbZ7juivDck4Vj6c4dgMwqZ7hi3EeDtUyC/ah3rNXXlFOt1reBfHGxk7LSTWNd1IGX5S6/WRJLUZmD5R6mi36YHcdGfRA1qssnI/Sn380qnmLbrU8v0XzGRb7dwXgE1za1arqXnHpKbp9/WzKGxLFNYsscvguivr2FFKXS+da8kukZFrUorFVZQF1+B19C5I5sl7BKACUqKcjBYYsSSI/4yVDXHNQRkFiYy52Fc5cfJlEVlHWtn+2bnewU5qIhKmkXE9WMeZPL1fn4rTniPxKsvqtx55W1BSVZ03bgMwiBlby8z1ttGXOCVVeaQdqN5eaQAMue8byyPKHinQAYdzJElt/RxFQ9uz2XI5my4cJtlKX6aRRH3wmLh4VP0FWfoh+yQjVEMunqk/GtPA19RWXrfg9ZDyQJr5VmF7CjPrQuoB7RTAqLPgzdDszr1jz6ZL0dwg2tsqNbvW2RUkotb5wB9ebQClc2wSpeiJF+CXzHacKTwSH+W+l6rvQzyy+4YRK9hQnaTPn0PBtNT4MHG0l1ZS02tfngws+HnenUVCxXdfhp9cJ1qHZSwMmw8YPhzn1iMJNRPSR427HlSAYsXgvWflLv3hqHo1gKoC/M3N2kBMfVnla1HFw9yaFtT10uRsNH/pCC+ugG+56N9Z3hXG4HhiWYqU/EJZxOAYqTsOLVDcGJ3gYVkzh/oNodB340/K
 wIOH8hiK
 HpdoQna5jyNb/Ef4ACqgUPm0R09D4tLW0b7IxFUd8PyP2vRo4Z8rKi/QctndDaWDGf5sTWuGrcBJOUs5yeFZ2vaenyRmPMj0euL5avgNNIJZkyKtH2jH1xcgc9yUOJK+Inr6OQRbdPxMVLoXaDE/RWTWsrnl361W4nBoH2MRbLZvcnZL/KgUiLqhS9Ejd9sTzyS8wbdhnPMDLG3lafNbQY10voTPhVsFUa1UFxZ03hS3jTDhs+/Eo7Ey9PHPxGYRA9FYPzbyHG+emMKEJVWtLWHKJ3mqmuS1Lw3MjumltVGDJkP+N7fkwvrD3iLtZh8Y9e0Yad2FajURWEGGVdAlq5xblZeBq7D47hIKt5Aqd2HFnQM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 3 Nov 2026 at 12:01, Breno Leitao <leitao@debian.org> wrote:
>
> depot_init_pool() emits WARN_ONCE() when the depot runs out of pools.
> It runs with the raw pool_lock held and IRQs disabled, and
> stack_depot_save_flags() wraps that section in printk_deferred_enter()
> so that it does not print to the consoles with the lock held.
>
> That deferral only applies to legacy consoles. ON nbcon WARN() puts the
> CPU in emergency mode, and in emergency mode printk() flushes all
> pending records to the nbcon consoles from the calling context. With
> a slow serial console (pl011 is an nbcon console) and a backlog of
> messages, that flush can outlast the hard lockup threshold, all of it
> with pool_lock held and IRQs disabled, while every other CPU that needs
> to save a new stack trace spins on pool_lock.
>
> This was hit on an arm64 host running a KASAN and kmemleak enabled
> linux-next kernel under stress-ng:
>
>    Stack depot reached limit capacity
>    WARNING: lib/stackdepot.c:302 at stack_depot_save_flags+0x6b0/0x6b8, CPU#56: stress-ng-dev/3466160
>    smp: csd: Detected non-responsive CSD lock (#1) on CPU#66, waiting 5000000030 ns for CPU#19 do_nothing+0x0/0x18(0x0).
>    smp: csd: Detected non-responsive CSD lock (#2) on CPU#4, waiting 5000000030 ns for CPU#61 ipi_mb+0x0/0x18(0x0).
>    watchdog: CPU53: Watchdog detected hard LOCKUP on cpu 54
>    Kernel panic - not syncing: Hard LOCKUP
>
> The rest of the WARN splat never made it to the log: CPU 56 was still
> flushing the console backlog from the "WARNING:" line when the hard
> lockup detector fired.
>
> Running out of depot space is an expected condition under heavy debug
> load, not a kernel bug, so report it with pr_warn_once() instead.
>
> At normal priority the nbcon consoles are printed by the printer
> threads, and the legacy consoles honour printk_deferred.
>
> This also keeps a full depot from crashing machines running with
> panic_on_warn.
>
> Fixes: cd11016e5f52 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Marco Elver <elver@google.com>

> ---
>  lib/stackdepot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index 90c52f2e0d3f42..dea6338f73c1cd 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -299,7 +299,7 @@ static bool depot_init_pool(void **prealloc)
>                 /* Bail out if we reached the pool limit. */
>                 WARN_ON_ONCE(pools_num > stack_max_pools); /* should never happen */
>                 WARN_ON_ONCE(!new_pool); /* to avoid unnecessary pre-allocation */
> -               WARN_ONCE(1, "Stack depot reached limit capacity");
> +               pr_warn_once("Stack depot reached limit capacity\n");
>                 return false;
>         }
>
>
> ---
> base-commit: 2637bdec0535a2044cd830eba9a79363651d9043
> change-id: 20261103-stackdepot-full-warn-b29a9d89f1a5
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>

