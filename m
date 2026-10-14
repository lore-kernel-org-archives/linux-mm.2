Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C45CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8563C6B0088; Wed, 14 Oct 2026 16:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806DD6B008A; Wed, 14 Oct 2026 16:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5A76B0092; Wed, 14 Oct 2026 16:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 423916B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:46:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAB2C1607F0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:46:41 +0000 (UTC)
X-FDA: 85322415402.12.296A6E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id ED1141A0002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:46:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c6DEXWQf;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792010800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BOFXdtlLJRQYMv76Rgndlsjsm+9tUOiWDlM1kttoyjI=;
	b=NG01UFdv+qOBLC7QB6uMhNgJSFCX4oLurOqB6MXnVd1J7im5rlLKTZdzgFo9HtVHpsBMkh
	0Cg9bw2tdXPyzbelcx6wpQMBEkhLvraM1QkKohIxHfeC0zYDfh58Dhg3ScPjiPnTY7dMYM
	X5eF57fswYuqoXhkKSYQgi3P/tlqpW4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c6DEXWQf;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792010800;
	b=nQBJxQKwANEQ7n2NdK3cx4z3M5jqgikEacCJviJWQ/uqvaJR2ZKaKqmQJh7XjYMliRH1sV
	/bsKh2BCBUpbW9NESgiVVAvDAZuQ3Hhb7awHQVxuprvAPXuwga9NKlsApOf1fneuL+BaqZ
	FxTx5EtcRz8i6Bu2P/489NjeDBL0qcM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68BD560230
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD181F000C9
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792010799;
	bh=BOFXdtlLJRQYMv76Rgndlsjsm+9tUOiWDlM1kttoyjI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=c6DEXWQfVGokGZ9CK9fvFUarx2vlpofDu5HZHLOpqf6xCyYjLf0uqQkloauiJw8dE
	 gW6Rbsel1roRQZeatWFTIDafi5MoF0MKr3blHEzWknrPMekFnPlKdSpRQZzZ3KVKFR
	 i2eLbJRcJKZKczi9f+QirwOLqGh5Uiy3swk5aj/fIJphLd+NghwNa6wxO1hJ/hGHV6
	 JJJxnYZTCtIs47pPG3JJOdG6PQyt1FofSUddaX6PvClGABAqvm07sp6Et+LOIKTqvF
	 Mx10GgqzqLlEaLYCM7P4L5IkaurRxP4TP8/QV+ztAhIVSPViMOt71WPYCyJwfDAxDB
	 1K1/gpsHCfenQ==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93cb9e9405fso47684285a.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:46:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxD5Wv1pH5J/DlkJ3i6Vhbh4ZIDE+hcrRPyOvMzkdzHLh1m2L1GnQ90N//5niVnAViMVZOPtgTMYg==@kvack.org
X-Gm-Message-State: AFq9FYK2jbbJE8bOWQLruOiXGJR6ezkFDxs1/qYE2O0uuXEl89AD6zsk
	pOC5fPjVOxu/QRQ1GBdMdXUVmuzKbQL0CLFfGc3p0GdDVD0RCnPiaBUtuTncef7cbF0evF5Sl70
	sOHMUDw42M32AtRobzW+SvH0jibVZETU=
X-Received: by 2002:a05:620a:370c:b0:93e:7944:b874 with SMTP id
 af79cd13be357-93ebd244676mr2716481385a.33.1792010798449; Wed, 14 Oct 2026
 13:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <20261013035201.2809924-11-senozhatsky@chromium.org> <20261014153603.1365617-1-zhangbo56@xiaomi.com>
In-Reply-To: <20261014153603.1365617-1-zhangbo56@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 15 Oct 2026 04:46:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wuPCPR0DnbrLp7ebdO=Oih6K_yP4XxwETKQ+3U+THVjg@mail.gmail.com>
X-Gm-Features: AclHuK96raYTD1_AYOBRwPY6SYxU3fp-WrN3O5LVPixrw0o-dNEHuRIoMVnayBo
Message-ID: <CAGsJ_4wuPCPR0DnbrLp7ebdO=Oih6K_yP4XxwETKQ+3U+THVjg@mail.gmail.com>
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, bgeffon@google.com, 
	minchan@kernel.org, richardycc@google.com, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED1141A0002
X-Rspam-User: 
X-Stat-Signature: ycefe7pcuhid5tdna5utowha3nxsret1
X-HE-Tag: 1792010799-702840
X-HE-Meta: U2FsdGVkX1+7XqPMpoDXGbl2Q46+pBlm+GqyH6tVbrtcuuqoswrFCTyApmmKcrgVlBj3e5XLjTsLWeJX2eaW+fwQJbpyGP8OUmIHFqELWMqFvVYDlKW/bFQXy0lkp5gXe2hL5FfLW/bcQv8iYv40mkKxwGadjDW5itsfhIP8LYnCKJACF9tygEYpB0PHgrjdzKYwzL4iPgpaeeoGpxueID9yWi2vU/AV6ALkcPAbkPInwf4QUka4z88ea4g51qCqX/sj0zrKg6MLgRMCx2kZijmFItIuDBVebuT2O565aNbgEOZerDR/AdniUdqWbe9J76tjK6iZRpYJgvFWCCKE8Npx36e2PJrL1IAJBLccjmRnXJQFLdcH5cTReY7Z+1v4Tco11G9Tb42wnC0qfTx0izGi4/6vMfU4Uaf/lvXI8DweuU/YvSxKTqchZ3JnD382rn4pdJ58/FQGiOUq1iR2mu/bRonEIfXPn+mV/lPEwzo1SeOdZ0JL6VsQplpvjgtWPqrCKNKNpr3i9DmKQDXrWllJKgGHXQDPy2sSE4Y0/0iUhl/S+boxw3ZC5CGk8hLoh/pKXZGOBcg9tKxaL8kalMkUV77UP+ciMCRtgzMWjuVavK6N4G10mcZq+llRO/12Pq2vahnux6pHyHbng8/YgRV5MzuHOzfvSMg62x99DVAuO9HD/vpMcCxaf/1PmPmcaCpEGq4Vhri6ziG4/9h3T4tcxzXY0ZT2KMdfQTOBeU0B5Jiuz6P5n3Cyvp/FWW9ZJGCnlAz5zWhKbfnBnGzTc+R4VSRKS5VlrRZ2WdXomTRAeKxK8RmIsrlCuVsXY5lfLvq1QUUWMTiYCCs9w8Q1G5MGoa5PLNN81aedc2pwn+Bu+eqktrsNUlzs9ZwrSqEDonhxkkCBcbPGuHAHRr0amffl5Tc7WXrEZup36jSm1Dtuy2iQpihnh7nCtTVdrsxmfoxjay9GMNraa05b2mK
 JR9WLSng
 7vPZ+CyD+ds8YKu2lmmFoLCEzBCv7txihJVgc3O+8FpXiCnIEoCqmHt9ujNiE+ezA8Vy6rugJSHQJyHGEPtzjq/v7uLJPtNgeBNk4igyX23w3R5tEXO6h9F4K2HzG1e58Uq4SB499unGz0LAo8lQ0wDax8cte2l1QP3NuXI2ecaQgg2U+dQ9K0jB63HAsWZjNMq40z7eMdjKbIymikWxrwKITSzu3WoFTdmUnhBQBOmiEpG60wE90X8E5uttJJJtXIMBmr2FzeKUDEWH6H0OpTdo4VujVqvIVIGc09Ly3h2fj9bdQ0s2H3Rd8f396GlRU4XU9E7A8iIUhh9Sh/P5erESXja11ykqziK1qDpz7dRE4MjSXXo/v/EV4FnQa6gpi+0Qo1aYH9RylgmaSzRBCZIQQnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 11:36=E2=80=AFPM Bo Zhang <zhangbo0325@gmail.com> w=
rote:
>
> Following up on the RFC thread [1]: Sergey pointed me at this series as
> the reworked version of the by-direction split I had tested, so I applied
> patches 9 and 10 and re-ran the same A/B. Big improvement.
>
> [1] https://lore.kernel.org/lkml/20261012123328.1138059-1-zhangbo56@xiaom=
i.com
>
> Setup as before: real Android device (MemTotal ~7.7GB, zram ~8GB), cycle
> 20 apps through fg/bg to force swap-out/in, 8 rounds, reboot before each.
> Same trylock instrumentation on the stream locks across all builds. For
> patch 10, "read contended" =3D dpin_contended + dexcl_contended. Decompre=
ss
> ("read") is the swap-in path, which is what matters for us.
>
> I use decompress acquire count (swapped-in pages) as the comparability an=
chor
> instead of swap volume, which stays within ~20% across builds.
>
>                       baseline   preempt-disable   9 + 10
>   read contended      24,749     406               1,959
>   read wait_ns total  239.8 s    3.78 s            ~12 s
>   read wait_ns max    757 ms     51.7 ms           72-96 ms
>   read acquire        3,948,150  4,305,078         3,510,610
>
> Decompression on 9+10 splits into:
>   shared (stateless backend, single-page): 76.7% -> down_read never
>       blocked (dpin_contended =3D 0)
>   exclusive (cross-page object): 23.3% -> excl_lock, ~1,959 contended
>
> - 9+10: read contention -92%, total wait ~-95%, worst case 757ms -> ~90ms=
.
>   The rwsem does the heavy lifting: ~77% of swap-in decompressions now ru=
n
>   concurrently with zero pin contention - exactly the reader-vs-reader
>   queuing we were hitting. Clear win over the two-mutex split.

Nice to see such a significant improvement from Sergey's patchset!

> - Residual contention is all on the exclusive path, mostly cross-page
>   objects (which need the ->local_copy bounce), not a specific backend -
>   lzo-rle single-page objects all go shared.
> - preempt-disable still shows the lowest read contention (406). It covers
>   the other half of the root cause (holder preempted/migrated while
>   holding the stream), so the two are complementary rather than
>   competing: 9+10 removes reader-vs-reader queuing structurally, and the
>   ~90ms tail that remains on 9+10 is the preempt/migrate effect.

is it due to the case that sg_is_last() is false, local_copy is needed?

bool zcomp_shared_decomp(struct zcomp *comp, struct scatterlist *sg)
{
        /*
         * Shared decompression is only safe when the backend has no
         * mutable per-stream decompression context and the object is
         * contained within a single page (no ->local_copy bounce needed).
         */
        return !comp->ops->create_dctx && sg_is_last(sg);
}

Also, with either deflate or zstd, create_dctx() will
always be present. So, what algorithm are we actually testing?
What happens if we switch to zstd?

Best Regards
Barry

