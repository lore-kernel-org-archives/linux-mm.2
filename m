Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4700D606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 04:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J1nZj3N5
Received: by kanga.kvack.org (Postfix)
	id 45D526B00EF; Fri, 13 Nov 2026 23:01:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DCB6B05B0; Fri, 13 Nov 2026 23:01:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323896B05B1; Fri, 13 Nov 2026 23:01:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 082676B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:01:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4A141A0340
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 04:01:45 +0000 (UTC)
X-FDA: 85432375770.02.21B07D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 27B091C0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 04:01:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J1nZj3N5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794628904;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMk2aTrcQ36bWNPpXZ6QgSfRYzQ/N2GKaOXD8sn5J0Y=;
	b=bEmKnSCQ/b6R+zjsaDGyFCvtSE+hHC2iUzENHW9LdUf41aIZShOihlcXTu7IQ15JGkldMD
	MsvJRffIbicXAHxljLV3PR7chKuA0U3AC1xOv078eRgCty5nMraUNpxhew1tsnVONcoziz
	rvY1RdyXUcinuPWqBSIxqUE0aQCwAmI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794628904;
	b=4C5l0JaH5Eexrntt5sLN73X161hq2MoTh+RHmQUU9wMvzF77kbjqvvcj/96FbzrdHUYi38
	TugURJxvNUtyns3aK7IF0tfsb6m6YtKXVmhZIz1oVaK0yYBkXmB2qAnx6knPSWdHgxyL4P
	J5heJSzlQa9LxycqZpJRHASCFfyZmDo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J1nZj3N5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BA93621FE;
	Sat, 14 Nov 2026 04:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B081C1F000C4;
	Sat, 14 Nov 2026 04:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794628903;
	bh=jMk2aTrcQ36bWNPpXZ6QgSfRYzQ/N2GKaOXD8sn5J0Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J1nZj3N5st+4gvipYiC8c253jGRyFsB3bFVlnQ4Rzlma8hOVjIgJmjrGlAGRZsGQm
	 Rw5TKWuPbSWsTMppCQb1UoffE40g4jdCSicCwZmLSu8LtFrjj9xQL34k09qfgwtbhI
	 NxUIGxyc68rmW3T1/YorBx9+gG7ljx82xdlxiqzM6jzf3AhbEZwq2ypeFVDzmuufmn
	 s8Ccj8LoCKmTofcCupr1/1E/3dRvbV1PGGjRItHzYu3xrlLkONOkfN3wHxYQ7LICNB
	 y9QJfI4CR5oEnR6jXPaJtVOrWK5Rc2LtGh5DnbCJC2Th05Ufjner7JyTI5f4Nxsl2x
	 J01uW+cEc4Uxg==
Message-ID: <sashiko-outbox-214133@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] selftests/mm: allocate nr_pages based on pmd size for
 uffd pmd_move tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "John J. Coleman" <jocolema@redhat.com>, linux-mm@kvack.org
Cc: zenghui.yu@linux.dev, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, ljs@kernel.org, mhocko@suse.com, peterx@redhat.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, audra@redhat.com
In-Reply-To: <20261113040045.1439391-1-jocolema@redhat.com>
References: <20261113040045.1439391-1-jocolema@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 04:01:42 +0000
X-Stat-Signature: srjajyfb1177gs4iurazw3wgxxzrr8b8
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27B091C0006
X-HE-Tag: 1794628904-157468
X-HE-Meta: U2FsdGVkX1+zoccjQ3DQPB1rM3tYONijkvA2SjOe9kQ3eICjKHlZFAJBGsQNZZGCzdT80BAS/SMKkbmeK1iJiUHE2uMClvv6aq7o8Imx454eiN7KfGve9Aiou76QIJSKC2MxF7hHEMkpAangtRNB2PKVmmaiINDfYj650XYfdI7kEp7Up8GbOt8m38FFqW9qbJKGI3XIuWUuUX/srn/tFSXL2476mKrFD1PysgMXTa+acoxRToR5fQ8TmYJHoHe+ZNLBposs8YhhVraIzX6E4uDDQRSHKQAUrUwOz8RJfO5jHK2qWO0afxNOLT5U1yEj8UONL5pYSqVuE7/EkbqlDuZKveuw60SmptUTlwr3WiLF+efSXtZjcCzeKBULYex4eAyW+HjNggnNU6oUl1Z60DuMjWcwgqjr9u0ch2HanZhrl+14xwr/49CtHHxSj+daFNtgb15Em+cJARwaxAZJiAIo1S9+A86P3oSLnSkEgQ6C9F0jj8Za14hkZJkKrvZV01Ps2UkXrEFcxMiFMUrDPjeVSY9pnf2RGEHQ4SAnA+X6UlPYGgijaX20AL8evR2NpWr2KSwPsyZK4ystZ52OjqhyzL+LaklvtIWusarBoyExncMA3eSHbY6bXKOmwWoYLNwgOahmyDMg/F6wDkkR9YIjfCCRl80Pvaddc8bkuyVLB7nWFTjsaDD6YbLq93SQ9ZasX70caFly5pNrTwm/7DlFvqS3I2sZl/QEjsKuh7xB6ZNtaSfDwf1czyLrve6hxLqNJFIfhuQAasRLMT0LnaEBR3Tv3+kvApF2psHqXvToRVPZNYazlSdKatgXRRFk7Vx2oyFUwPZUcM7RIDluz1SmU6GbFqy9UDGkX7ZF33rNrIvkr/Obi1Rj9kym8m72P80k1uC1iH8zvwPmqWRx5r1d+75uOXbqg0ZsIeImVbIv7qEQhhAHkwkB7VPN+PcGqxkIWQMrsZWPNiCoNT1
 rDiX1FC7
 JSCigy0C6lb909LWx9nRxI4+YBqppBmRP2b8TAroGJSUMPiK9tN6cpYYzez3CqAMsZcSQKV9OYY2bgs8SKK4c0UCsggmC+cgiccG9pb584csPPdCnmJquewQs4KX6rLR1gvvOmePIA2XHgE7FXyjS4qweYXG0hn1xqu2AfD8PhGlugjZqGxcnDV3WiI4Bi7jMgDICp2iEZ1m83zuBcaSaHSJcDe8aOhXY6q4zb6HVo1NT1esegDWA41KbBUTMjDV4gpRVWTfK69scG5WNi9u1AKTjh5VIJjBnrZGWrCghAUDIGxEyMEc0V7b+i0l6gxig7W3/fD14r8+ZZfMVP5RDMmSGlIm+9SVkVHBxHrKI5mQcMu4qDnF6i8TMi1MsMRv6+2bt3WcSrD6XiJZGJRyZSjXx7tUjDyoqrO4ZPlbfas5qNCVrjsiFlYV7A4PKf1VjoCX/NincGRlgLV4mffyFSECwQVtFuHprNib+7xyf0jezcRvAwJoNKRsOCctjSCZTAQLJXpgWTyiCyQZRocUrHCU1WDLLfm2byIWalCMN/cJuexSs4bdEfI9jDHNd0esIvzlzeafMwSJzrdOprnbQ2bI5WG0XZdX+I33a12o6QVhD5ZouOF3C4SFxY9M2ss9XKXTPelEkcskRH2BaZSUwaJ5BvkUy6+z96D0L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] selftests/mm: build failure from calling removed
  read_pmd_pagesize()
--

commit baaff8c2bca44f86cbdf0bcae24ee9317be43974
Author: John J. Coleman <jocolema@redhat.com>

selftests/mm: allocate nr_pages based on pmd size for uffd pmd_move tests

This commit adds a pre_alloc callback for the move-pmd uffd unit tests to
size nr_pages to twice the PMD page size divided by the base page size.

Link: https://lore.kernel.org/all/20261103202049.499206-1-jocolema@redhat.c=
om

> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing=
/selftests/mm/uffd-unit-tests.c
> index 9641f4730a355..9668dccc11599 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -2484,6 +2484,20 @@ static void uffd_mmap_changing_test(uffd_global_te=
st_opts_t *gopts, uffd_test_ar
>  	uffd_test_pass();
>  }
> =20
> +static int set_pmd_pagesize_nr_pages(uffd_global_test_opts_t *gopts, con=
st char **errmsg)
> +{
> +	uint64_t pmd_pagesize =3D read_pmd_pagesize();

[Severity: Medium]
Should this call pmd_psize() instead of read_pmd_pagesize()?  Commit
3fe017016527 ("kselftest: mm: rename read_pmd_pagesize() to pmd_psize()")
renamed this helper, so calling read_pmd_pagesize() breaks the build of
uffd-unit-tests.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113040045.1439=
391-1-jocolema@redhat.com?part=3D1

