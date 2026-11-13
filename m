Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CAF4606A882
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oVeBMlt7
Received: by kanga.kvack.org (Postfix)
	id 85B646B05B9; Fri, 13 Nov 2026 13:51:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833416B05BC; Fri, 13 Nov 2026 13:51:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748E26B05C3; Fri, 13 Nov 2026 13:51:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 416856B05B9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:51:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C799AA01B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:51:13 +0000 (UTC)
X-FDA: 85430988426.30.5881172
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id CA0BE100008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:51:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oVeBMlt7;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794595871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PG96/Jcs6VqZrpoFOO7d4fr+8hgP9c+7Ydjha4gz5aA=;
	b=M4hvmeNm7VGdBEebkxB6awxrmiHvddnQHoNwdy5P2cF0x/cBWIdSYaMcIL68HcYoVju9E6
	nv3z+IUHTvOi2OSxMYWb0oY/tCCOcxq/6yWf1pcSQiYh0TeT5rtKVcdLTCifBRvTQTCTsm
	Gu5Jl1vPul3rYjz5vhJ1BodbZCbhBvY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794595871;
	b=KrYHNVgdn7YaP7PGeHc5WD40rZPxjhhCsr+CKMLHMD9kHs1v9St/KZzoxmWSYo6dmYAc7N
	T9mSw2hGgA7WxBCCvbVvHf6TJg2bUAH+VXxAxNIDqm/BiL8YWhqyTG3XtDKyG5C9ldIDkD
	j+9cmQLNOqjp7k0+jZVHNhCFcpC/hCo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oVeBMlt7;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb55cda775so6324095e9.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:51:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794595870; cv=none;
        d=google.com; s=arc-20260327;
        b=EHngR2Q9O02E6OY4fP1xyzmphbREKq2d0hPYBsISTtX7pL4VBerdK46fZezE+zp43v
         v48HHPcTr04Lubduqr+s3THlKZMMO4lqbqqgIwJzunleUIMlcRQomxiVXU2CRSI0hvLR
         VLkfWCYCAbaPc0zWATKhYHgT3dLecydOn4SMMqC0JIkOENstJlPKFP8xTH4jldBKKj1D
         I+pMe7injlGZZQAEaJau97h+0fdEpc0GQFuJxdnZgX5JDRVdzj34HtkmMvDiFA3LzY54
         ZJ8M2GDDg+3J0FE+dvoDvzvEb/JUJy8o1uHYexUqq6UfYZBURN6ldxywyvfUzEjj1/Pq
         VFaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PG96/Jcs6VqZrpoFOO7d4fr+8hgP9c+7Ydjha4gz5aA=;
        fh=n8JEN98AtXB0PQCaS8oobw9qcUuKhreVOklw+8GoFOs=;
        b=CW1chTZDo9C2K7KESVWHcd7kdqw35Es3QzPGDRPIULqOouAtpiec3Pxc0ZprBwvCd7
         osZqI2LJ/QV6LsIwLLDikOKOMjgH2K8ei+tivZUtOZHV1JBNIhvBCThbUBVB0jtznqUo
         wIjNI0X2Ykfw7KHPorfR3kS4M4K7Egt58g6GdcMHTdU1Dy34tlvSkoaOOMhkg6wXhwIA
         EJzXgmJchMzebiKZFp46Q6Hjmdv0hJ1tM1GYpX9PISUqfsBNFk4SGjXfHk/vJIU2SjI8
         878x4MjNFxzmOtHQ1SfW+PQal0VKJ7GK+mcdGoZw2hPpnpOScoHljr5z6CsEi3DxWzBU
         IErw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794595870; x=1795200670; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PG96/Jcs6VqZrpoFOO7d4fr+8hgP9c+7Ydjha4gz5aA=;
        b=oVeBMlt7c7sHvWC3wUyJRxHFrSW4Ay+o1iVYQgAfleL5vhU6scbUsxBhEVQKlt2P5i
         QD/wFYs3IFHj2ubC6Xh0bWjxv19Mu8QdVs82iXEQpSTiX/koiWApWit1tqe/i44CGpXv
         HOJLdo6vTdzPb/umhwVDupHyZA/Yct+TpEzxWYxYmKtv32A+C8pZlNwQDfxxuNgM9jqR
         ywLMTx7tnZTQHmz9J7jkPo3T+uVulSa1VYY4xoJ8NHHaf2tpWjEAfIfjsPvJYdNUfAtN
         ajZQOg8BWoViQW89tPVs+ZLtWW09M72LaP50S5R3nMHf5LtOmQDW9h7NP+Vk6S7yKAxV
         bXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794595870; x=1795200670;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PG96/Jcs6VqZrpoFOO7d4fr+8hgP9c+7Ydjha4gz5aA=;
        b=tDu8uLQouwkCQLnMSl5mXbMpH1inO62UiSbKMDaWxSVUDXM0UdFuaFmkSXL+KUBa4L
         XiIjxtaG++ldvP16jk6OziBsE0rKiDeXu+acI3OobDNcjGlgE4ISpHKKtlkk4WqHbVln
         eSj7doMQ7y5CTtl9XIkb5YJuK9WPgyZFn7IDdfmmc6/cAStiH7QNl/tfNfk5QTyXalCt
         01vTZO5VZNkPBOj/ZEk436noQgJXO1ueQCqkjuZFJErj28YwDV0ix/AAZhMFe9h3TYTq
         k8mkWReO6E1rAuJtyVaKdDbLhqBdNDqg1A/5axNkGOgYvX6NxYBjva5gyhw54vM0hskb
         tu0Q==
X-Forwarded-Encrypted: i=1; AL+hErEDhjME06XYyKN025V4qS/6Mx1plz3Zitzptyn9NCSDFKiiTsLKk3/Xy/UmW8Ih/Dt5w48LIM7PwQ==@kvack.org
X-Gm-Message-State: APuU4Z+dyoFZ8w2H03eSaPhM5VM0Zw1BOdHwa+bDaSU1OL1OUfXCLOL/
	ZfZ8lXF+u+rxgfeyRuVxgO+wmsuaiu2NYmMswdFOvdKaIQw15l7grTRkI9u+E/yFru4nXEbfD6l
	lLPW13IfC5dPcQPvdt8XymL6L6xn64Wo=
X-Gm-Gg: AYBFou0uw56ioBoGJTMlsUsnz2n+0oYXUuvSmMm5FTqUzMmgFT4UUOxzgFpm7HTwSEg
	RGIT1F2nCKjYhI72vttVhAMlFRDWNFmjxZAnFc38nnLozXPdHTJ8AnFPWoDb8LQCBAsKcRlRwq+
	CRrcQk6DeOpCdVfE3udv101fJVT7QAh7mGEbAb5kxCfwFwzHR92c7W2OZvZvVHaq9lppYCu+Y9T
	R5MyYIJMiVCWhMy9i9rEznJrlVs0+8ZsYT3Bpd16tS6QOQ3TON338SITu0fE+v9JqWZlVZdHn1t
	Hd9pfdbMiPG2yNXuR6S9tzg4xXElfTU28ubuK2i/xnHEvzVmHDuoeqnsRh516ehxjz8gGP4z7yk
	VLVDRjJX6pgAV4yC230Ds2ee3PbWUTXmFo/Ysl56IE2uQenlpDt4h2c4gRSkXRiGJ/V9p2v3vK+
	PobjQirH43ySDUeT+Q2CU=
X-Received: by 2002:a05:600c:a596:b0:4b5:d95c:2380 with SMTP id
 5b1f17b1804b1-4bb55a86fb2mr37797165e9.11.1794595870121; Fri, 13 Nov 2026
 10:51:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <CAO9r8zPqJncFKQbF3tGe1d4sg-4dLQ3dQRGze_vab26wWrXTqA@mail.gmail.com>
 <179438454803.6.16655549133383619919.zswap-rstat-counters@gmail.com>
In-Reply-To: <179438454803.6.16655549133383619919.zswap-rstat-counters@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 13 Nov 2026 10:50:58 -0800
X-Gm-Features: AclHuK8qDdaLN3_3l5l7WveJFIgdzXS_I6AwWx-xXQnBC1wCSuS09VZUPCEPOi8
Message-ID: <CAJnrk1YzYswBKv5F3=FF_o_4Pywgw0ifLq0tXYSWO7TARnFRJQ@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Chengfeng Lin <lin2530632123@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5t3eedwx5mbfoqmf5rczqakibn518bjc
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA0BE100008
X-HE-Tag: 1794595871-952502
X-HE-Meta: U2FsdGVkX19WXppb3E3qTPwFBTb1aNgvOxP+hGdfP5OZtkzbq6ZqH4qW0zDuEKJ1aus0ODWgcYce/HTLTMiwN0S6xDGq01tW0+hY0NRPs9erVBcdl5RLOQUaUmyOdJkoZRgKo37XWUQZMZgSY8vDJWfxit753D2J5yCt3O44+EyjXiQSKM+3b3ZxdjcmYZYm01HmZ4ZiSY1mq+3kqb2dEqPkfkPHAMEyQcilXe4Sxe/bzHN055VNCnxDt+nyJo39ptgqA3cnYaQcJVl5mWUH9hYU9idKjduwLHVG+hkOX3SlYdmjl8qyd0Fvk50qQD+5fTq4+2tIDx4YQqw/0G4T2Eo3gKxJXAbd4J+g2sqcOTyUiZF44kyx96WVDRbj9OK+nEub5H3hNPFp1hlPINONxORIJlwqgpD+lsZt2cgVwZ7i2XXpY+Kd6oCoH+8salqpK3IzLY/U81OT2RLnFvzy6qJsY0h4MlWXxcCT05p9u6jONVn45uhP6DCt42zz9vUIozEHsdKdpzjBNh7mOu+Fbg2kNBuX6GvR62VW8WJdv4MhEp9wrAUijJHk++iVJ3ReT8XvhWhY1oPXBVB/q+qtlUdc1UnB+TCnmQLeEjfhcx429rgAJtAH5pNLHNv2SKX3qjCgCNGLnVqkpgUArBGQSvLP3+HUCiE4+Vqmv6KmXLesKWVqIXkvQx2+jD9iwEaTyktWCLnJIMXcnHtPFXJ0L3N07OgV4Y33CfcxTK9PbtEI+CpcukVBeU/j2o6ABG89RrAuijGUx/uE1JffnHWwCBTrtzGtSEqPnnSQ7Fe20AJ98MTNoJ93Ijxzc4N3o65nuRd+ZCyWuB7xJ61fF02hdHqxjuesWsdinkE7ZZ2+Id3C+YgT/tbka8SDmsCUJcq0X0rZnaGQ2Ck4E+9P8fO0SXVcRCbdFz1gW/1PftW/2TmHmEXVtTXq5F6aAghDtSA6rpcAJtaH0FZeOjR8JFG
 /Z9YyPDD
 IQp5poBrCLnguWrjPoYmgh9IoXz/gTJDHGwnCV6Mgx8EauK0ztNUk3oh9MgaO2TruXMIIcTVFkwRDWSNtRKqVpQOAGCUxEgqJWRTbsderQMV1phNMjBVh4DKl8YWimJ9IE5qbKVGwiIWkertBvF1CpcY7NBc9703JcwpXd6UzAPMsfZ9pnOOamyJuie+M+fQRrVW8e9ZtFwJd2+fVeMvRvVuT6B5z1x+4ndwal+G4yvisnGrEq9kJQK3b3LwHB+meJ7TkMEQX//KsjXeKVCOtfQXVNYg0RTaX1tzg5yajm87tQBIRpfhKgR0O0XoGrGI0iu3o5XjLyxlXwSPZVQOyOlSeAHlkBAECDAlE6jRkyz4xYQ/X0HDK3oQvk9alAIREwXYznLIJmlhovTgmdAtfcsQFLA8ZEMZIqvm6Os/R0qSx89YRW2a67821teIFwzKQLPXFkkXrcwGSREI0BG7A/I3mSmd4S4s1zV7ozIClpwwGudc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:12=E2=80=AFAM Chengfeng Lin <lin2530632123@gmail=
.com> wrote:
>
> Hi Joanne, Yosry, and all,
>
> With existing rstat updates retained, hierarchical per-CPU counters reduc=
ed
> single-worker PAGEOUT CPU by 44.69% and whole-program CPU by 21.78% in th=
is
> bare-metal test.
>
> One worker uses MADV_PAGEOUT on 32 MiB of compressible anonymous memory i=
n
> a private cgroup, with THP disabled and memory.zswap.max=3D64 MiB. The li=
mit
> is not reached. The host is an i7-12700KF with 20 online logical CPUs,
> full preemption, LZO and zsmalloc. Unlimited controls change only the
> zswap limit to max.
>
> A matched parent/commit/parent test of 0efc297a3c49
> ("cgroup/rstat: avoid disabling irqs for O(num_cpu)") showed:
>
>   CPU time, ms / 32 MiB         Parent A   Commit    Parent B
>   PAGEOUT                       17.180     24.464    17.316
>   Whole test program            46.215     53.419    46.235
>
> PAGEOUT increased by 7.216 ms (41.84%) and whole-program CPU by 7.193 ms
> (15.56%). Both versions stored 8192 pages and performed 8192 limit-check
> flushes: a finite zswap limit forces a stats flush before each store.
>
> To limit interrupt-disabled time, the commit
> releases and reacquires the rstat lock after processing each possible CPU=
,
> with cond_resched() in between and cpu_relax() if it does not reschedule.
> Previously this was conditional on rescheduling or lock contention.
> Per-page flushing repeats these extra operations.
>
> On MM baseline 2967f3ccdb5f, I adapted Joanne's hierarchical per-CPU opti=
on
> [1]. The limit pre-check uses dedicated counters, retaining MEMCG_ZSWAP_B
> rstat updates and the IRQ-latency protection. Extra updates are included:
>
>   CPU time, ms / 32 MiB         Base A     Counter   Base B
>   PAGEOUT                       23.903     13.113    23.514
>   Whole test program            49.247     38.569    49.363
>
> PAGEOUT CPU fell by 10.595 ms (44.69%) and whole-program CPU by 10.737 ms
> (21.78%). Stores were unchanged; forced flushes fell from 8192 to zero.
> These two comparisons use different baselines.
>
> Both comparisons used fresh A/B/A boots, two warmups and nine clean
> samples per condition per boot. PAGEOUT return drift was 0.80%/-1.63%,
> with maximum within-boot CV of 2.82%/3.55%. PAGEOUT measures worker CPU;
> whole-program CPU includes preparation, re-access, verification
> and cleanup, but not external cgroup setup or host-wide background work.
>
> A single-worker unlimited control changed PAGEOUT/whole-program CPU by
> +0.41%/+0.86%, with PAGEOUT CV up to 4.74%; there was no clear difference=
.
>
> A supplementary A/B/A test compared the MM baseline with the counter
> derivative, with eight workers pinned to different P cores, each processi=
ng
> 32 MiB (256 MiB total). Their shared cgroup had memory.max=3D2 GiB and
> memory.swap.max=3D1 GiB.
> The zswap limit remained 64 MiB; compressed usage was about 18.75 MiB,
> below the limit. Counter-kernel means follow, with baseline-relative chan=
ges:
>
>   Eight-worker metric, per 256 MiB   Finite limit          Unlimited
>   Summed PAGEOUT CPU                199.238 ms (-84.04%)  196.272 ms (+1.=
17%)
>   Summed re-access/verify CPU        215.365 ms ( -1.36%)  214.950 ms (+0=
.09%)
>   Whole-program CPU                 663.404 ms (-61.39%)  660.535 ms (+0.=
24%)
>   Whole-program elapsed time         94.618 ms (-58.26%)   95.183 ms (+0.=
99%)
>
> Both kernels stored 65,536 pages. Finite-limit forced flushes fell from
> 65,536 to zero; unlimited controls performed none. Counter-kernel PAGEOUT
> CVs were 4.51%/4.91%, with baseline return drift of +5.10%/+0.97%.
> All nine finite-limit counter samples were below both baseline groups,
> but baseline drift limits the precision of the gain estimate.
> The small unlimited increase does not
> establish a regression. Re-access and elapsed-time CVs were at most 2.81%=
.
>
> Elapsed time includes preparation and cleanup; it is not summed CPU time.
> The re-access metric includes reading and verifying the data; zswap
> decompression was not timed separately.
>
> Both kernels passed bounded leaf/ancestor-limit, dynamic-limit,
> cross-CPU-freeing and cgroup-offlining checks. Deep cgroup hierarchies, C=
PU
> hotplug, and 32-bit systems were not tested.
>
> I hope these results help assess the benefit and update cost of dedicated
> counters while retaining the existing statistics. The reproducer sources =
and
> the measured counter patch are attached.
>
> [1] https://github.com/joannekoong/linux/commit/9092e0057f038ffca43ae3f35=
faf58c33b1d7c9b
>

Hi Chengfeng,

Thank you for benchmarking this and sharing your results. Would you
mind using your setup to test how this compares to the hierarchical
per-CPU option?:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..d2b0db311a7d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6324,8 +6324,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
                        break;
                }

-               /* Force flush to get accurate stats for charging */
-               __mem_cgroup_flush_stats(memcg, true);
+               mem_cgroup_flush_stats(memcg);
                pages =3D memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZ=
E;
                if (pages < max)
                        continue;

I ran a quick test on this back in August and saw these results:
"Quick benchmarks at depth=3D4 with zswap.max set at every level, 20
workers on 80 cpus:  rstat forced =3D ~7,600 stores/s, rstat unforced =3D
~300k stores/s, and hierarchical per-cpu counters =3D ~440k stores/s.
The hierarchical per-cpu counters outperforms rstat unforced on the
stores given that it removes the flush, but we already see massive
improvements from using rstat unforced over rstat forced". I'm curious
if you see the same results on your more-well-thought-out benchmarking
setup.

I don't think the flush needs to be forced here for zswap. The
kerneldoc for obj_cgroup_may_zswap() describes it as an "optimistic
pre-check" and I think it currently already functions as an estimate
rather than an exact state of truth. imo, it'd be preferable to go
with non-forced flushing than hierarchical per-cpu counters, as it
incurs zero additional overhead on updates and is code-wise simpler.
For fixing the writeback problem, we're planning to go with this as
well instead of hierarchical per-CPU counters [2].

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/CAJnrk1YO5E6ETxn9RmM-LWRQSRxwF9iE=
akAPz6veMPjaKMAEOQ@mail.gmail.com/
[2] https://lore.kernel.org/linux-fsdevel/CAJnrk1b5asARJ_g176DsoNCvf+iFqzPb=
OtVveeuPxTPZDmnuKw@mail.gmail.com/

