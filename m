Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97164C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 23:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C056B008C; Wed, 23 Sep 2026 19:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674476B0095; Wed, 23 Sep 2026 19:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0046B0096; Wed, 23 Sep 2026 19:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 299D56B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:14:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF07BA3E7D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:14:48 +0000 (UTC)
X-FDA: 85246583856.26.D0616CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0F551A0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:14:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GwCaB5PB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790205287;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PunvAU+DlMDl9/ZMTsQFtHIX6hxmtTujipDeh0Nhe6g=;
	b=FNHb7QXRqru+GltuaTp60d8bwa+oDDfNZF35yWNyE+PqovzeNUja3UYSwy9/csowzsCnea
	1YMmxyrKj4q4bOOLzO79BHGv/V2QNctdIy2CRiK071Ckza4JcF8y+y3mmizcwIS9TGQT0z
	Wufa0yM7t7F3iemDGfIu8QtFCd5F6To=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GwCaB5PB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790205287;
	b=G2aUq4QnhWjh1g9db+mKuvYjEMbggJbX5Y7cFgCL9gWransf9CNRwnK/GvjeCo3j7+H5qz
	u5uxhlQp2Vurek/Sd4QbvnUkaDuODxiciCOnu2+IxT76GtCtK/T5IG6JV+Dv898+Eb4kI1
	/m9QHBIsiEqneijFnD/jI/mZsT8HqHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3784E43D1C;
	Wed, 23 Sep 2026 23:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6007E1F000FF;
	Wed, 23 Sep 2026 23:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790205286;
	bh=PunvAU+DlMDl9/ZMTsQFtHIX6hxmtTujipDeh0Nhe6g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GwCaB5PBF3E1FC7ficVZunVcVFP0VTS4+2Bga9Zh/QWOyuH+hyzsTGLPyEMk96WMf
	 +kc/oK1keREe/0gQBuzQyoZq3CDbecwLRM8O5ySUTnSGYs3dHQt/PCXL+l3pnWCzBq
	 8v5YXQQoz+eqdXYFpCyp8o1nU7W1tw2hhUZEdsZJx03gNAcoNu+/pHkyJUyiL7aMBM
	 G0y2Nxbed1B9b5RMeUi6BRWNr3yCLvxgYDZr4S9Xu2xYatq12zK0sn/yBPtbjplq5S
	 /jp8m9DH1r6h8OKTYOgvj3UBZI5WVdk9hcvn/8OeJLddtZZzBqRBs9kQ3fI0ky1imT
	 UdSPO5heLxLVw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6/6] selftests/liveupdate: add tmpfs kexec test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "David Matlack" <dmatlack@google.com>, "Hugh
 Dickins" <hughd@google.com>, "Samiullah Khawaja" <skhawaja@google.com>, "David
 Hildenbrand" <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Pratyush
 Yadav" <pratyush@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20260923224408.3745689-7-pratyush@kernel.org>
References: <20260923224408.3745689-1-pratyush@kernel.org>
 <20260923224408.3745689-7-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 23:14:44 +0000
Message-Id: <20260923231445.6007E1F000FF@smtp.kernel.org>
X-Stat-Signature: ad53bsjxbq3ihizzuwsatbu8fccj18m9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0F551A0006
X-HE-Tag: 1790205286-156370
X-HE-Meta: U2FsdGVkX1857SEOFbg6xrsNUOiF5j2rj8iNzn9daO6GRYgKx97cV/wtEC4EroQfEIjX4y4sbSoWYwSAhXT1bdK6sqBVAqLAPwa2NjlakSWGQ8nsEl6nnIY6BL1B6iWDOKClaBkx/bCQBsJl/FbXFgSuVdAtaaWdJWSLKGeYAOdv9zNQRzkK7P5aNTeiFNJKQt7ODuLHHt2qcGApXleRZdPOaFIWy2XKRCiBqeSt1cy9X/9zIKxEujt+4Kapm+tVZufDCxM/4yARggA0J4yikJMPAqcxAdgXKzVUocQ1QqeTCbEHjqfes4XaT6FjBsMz2szk1Z2QNswWDhvj67EuOlAU5AmjwYK9yAebLs1JRE3OyahQUZUrNS0NZB2L8QVim9b+6bd7T4LPERcerlagXIL5npONnea/F2Nqs9DFvjosd5POGd8i5fDHgZh7iMZfT1zsj5SX14M+yh7it4IbPeLUUHmmmDcmCsakn2YXO5W10h7+jeke/pK28q6ZkavCt8jBeDq1tr2md0Yi3TJEe4eUMw62HSLkbmgeVqHetYdyBTMc0F4Gbd6APIJWgJXS3q9QDWtvVqmMHkwo3DurmGQqej3I9tx2GcIgBvk8ixgSkLkhAKWsEI5vR2kPXcgAwnwPVSfCANPVPsDfUKHrKV320WIePpZ/r8N8UqRiRxRpMtwIdLHXuKTX6Ki5Ldpl/ptipR8dDATbA8772vPAKrAGVEWYRNwZOF+emxiMa92fjc1A8BbY8yDGV0UfuFnzvP8YwGNv+ps8w15a6XZyesCr83saFYXttOirVTEsnjAYITrvkanVnl7YkIZnMXkPViWWJEbjqNaKNUQtmAhf6X3bFi65NfTW6wibmUTK1EoXvYN+FCJQbMjHwIiE19BDXBXMRui0NF8kiigxsEWGRRxUHMMag7/aCPW42UHlsdOt5sEBlA00DC/CtsoLMqQ0pLWlSRQU5mH3FCWaPhk
 T+a1NM4k
 S5bRD0utghWH5Vn3u4iNYB7KWdMRlwnAqrK90qhGKVsuJQzdyGrin1QuR8GAPLWWnwF1B6bFcW+PGlTkFJuQRw3jpyB4M7adihRaZdPne4Uu7xx7Nba+U+ONQsuDeLev3bZhRUG2YIo4c4LvvsQ8eaRBm5SRl2TcgOl40Y2XkGU+0hFFtbv5sYx3KxegvijlCcvKboDmhbjUsB1GVEi9amLBFC/RHrOQrqGKkrmFJaaX/FDiIzEJoQc2KnvSt+mIOc8a6fAScU4ic5J1y0B70nlaApD1JDB3ov8rg+6P8JNswL5einsKEcpmiI777cUrUgeyxn0tmirG9+IvaDPSIyl4+yYPbDETiipfpgwU8S+MzK80TeQix6RzJoGe4rhnzdC9YBKkD7Q9k0jx2hP/BkvZbrToO9ZrOVY8QjFGDiD1Jfyw4/ClitjpMmBIzymR+epnx2ddcva4owpBANPeoSwfE/Vx4HZiFCAJg2fj+hP5dRDZc42Xqw/36aeuROk4I8/0E8b93bpHHGRA+jrSsAMv2tVnTPdndAAixF2ZXx7ISyxxx/cxXYjZYoA6ythprKzvslOaPMgIebRFrO4kmbbX4fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/liveupdate: luo_kexec_tmpfs fails on persistent rootfs
--

commit 656981de91db4b31da49ddcf77d65f446841090b
Author: Pratyush Yadav (Google) <pratyush@kernel.org>

selftests/liveupdate: add tmpfs kexec test

This commit adds a two-stage kexec test for tmpfs preservation. The first
stage creates a tmpfs mount, creates a file, and preserves both. The second
stage retrieves both and verifies the contents.

> diff --git a/tools/testing/selftests/liveupdate/luo_kexec_tmpfs.c b/tools=
/testing/selftests/liveupdate/luo_kexec_tmpfs.c
> new file mode 100644
> index 0000000000000..608a6eddbd7ba
> --- /dev/null
> +++ b/tools/testing/selftests/liveupdate/luo_kexec_tmpfs.c
[ ... ]
> +/* Stage 1: Executed before the kexec reboot. */
> +static void run_stage_1(int luo_fd)
> +{
[ ... ]
> +	ksft_print_msg("[STAGE 1] Mounting tmpfs at %s...\n", TMPFS_DIR);
> +	if (mkdir(TMPFS_DIR, 0755) < 0)
> +		fail_exit("mkdir %s", TMPFS_DIR);

[Severity: Medium]
Will this fail on test re-runs if the directory is left behind from a prior
run?

> +	if (mount("tmpfs", TMPFS_DIR, "tmpfs", 0, NULL) < 0)
> +		fail_exit("mount tmpfs at %s", TMPFS_DIR);
[ ... ]
> +/* Stage 2: Executed after the kexec reboot. */
> +static void run_stage_2(int luo_fd, int state_session_fd)
> +{
[ ... ]
> +	ksft_print_msg("[STAGE 2] Attaching the restored mount at %s...\n",
> +		       TMPFS_DIR);
> +	if (mkdir(TMPFS_DIR, 0755) < 0)
> +		fail_exit("mkdir %s", TMPFS_DIR);

[Severity: Medium]
Will this unconditionally fail with EEXIST in run_stage_2() if the underlyi=
ng
root filesystem is persistent across kexec?

> +	if (move_mount_empty_from(mnt_fd, TMPFS_DIR) < 0)
> +		fail_exit("move_mount of the restored mount to %s", TMPFS_DIR);
> +	close(mnt_fd);
[ ... ]
> +	ksft_print_msg("[STAGE 2] Test data verified successfully.\n");
> +	if (luo_session_finish(session_fd) < 0)
> +		fail_exit("luo_session_finish for test session");
> +	close(session_fd);
> +
> +	if (luo_session_finish(state_session_fd) < 0)
> +		fail_exit("luo_session_finish for state session");
> +	close(state_session_fd);
> +
> +	ksft_print_msg("\n--- TMPFS KEXEC TEST PASSED ---\n");
> +}

[Severity: Medium]
Does the test exit successfully here without calling umount() or rmdir() to
clean up the environment? If so, does it leak the /tmpfs directory and its
mount on the host system?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923224408.3745=
689-1-pratyush@kernel.org?part=3D6

