Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D43606A337
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XAM5KWJj
Received: by kanga.kvack.org (Postfix)
	id 1DB306B05CD; Tue,  3 Nov 2026 03:39:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C486B05CE; Tue,  3 Nov 2026 03:39:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8AA6B05CF; Tue,  3 Nov 2026 03:39:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5B596B05CD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:39:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B83D80345
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:39:51 +0000 (UTC)
X-FDA: 85393159782.05.F933B40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EA0A5140007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:39:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAM5KWJj;
	spf=pass (imf23.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695190;
	b=tf00fV5lqdHgzLakLpXZWCr26lqWh4bpcY2dKX6xc4OYpRTj3TqIdYv8SamtmqYWBwD4X9
	QlxwjaVy4vmlai8Sf210IhN2xBMFlwas68VSAhQbROowBzwNXS+t4gqV87lXfheocrDJid
	0VBY/SZxdlm92FJugnwt09RSX3Bjetk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAM5KWJj;
	spf=pass (imf23.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lx72p1lVsfYHQLEawleuzl6MVpu20ohq4n3mluAj6XQ=;
	b=iGQtZg0V3r+dDjj42gAdYZh9B7T2tbWL/kzSfgejek8STyitxjwXdGmvpQ6Toe/iOLnUzG
	8JWHEY7c2jFJah4vi7Ch4UNPZ5JbS9lVZGRhPInnFARVb7tQPLu1Ftq14QxuKPPBiGvrAj
	ASMcmnx3OLJ3aUzH6de7uxhcQd7aW24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48D81438AB;
	Tue,  3 Nov 2026 08:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBDC1F00A18;
	Tue,  3 Nov 2026 08:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695189;
	bh=Lx72p1lVsfYHQLEawleuzl6MVpu20ohq4n3mluAj6XQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=XAM5KWJjPb2vmDAgw8Sg+o6J4pTPTe5jEBXNkxRuKxYRVd2v569X4RnKBrlvpgq/d
	 zlHcqXy6tRoq/WQkeRxoRVcbodhVf5RjdpeZlBx/L+Pc0il/q/ndacgNcyDuAUvcO2
	 DbbKEub6EN+7P+6FMMNduebEpGd7GAiY508KcHnymynUecCGM806ZUrnxl7F708RV/
	 YihSxxWaS7mR9PZgX0XTopnz2frH12+DrGlXzVt4fhwtOMfNNrg0gaCLL79gjbN+0C
	 lgKLLWy1c98qgnZPg5c25I5bByWjdK89Go6f/AclrezaHCjKU6VGpt7xCiujGKmXqA
	 GLzFpE6n4lftQ==
Content-Type: multipart/mixed; boundary="===============0296960252652514333=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <28b71b95a782f28f081233a18a48ab18cfb5483df6ec6980f8168cbecfd93543@mail.kernel.org>
In-Reply-To: <20261103075916.100050-9-jolsa@kernel.org>
References: <20261103075916.100050-9-jolsa@kernel.org>
Subject: Re: [PATCHv2 bpf-next 8/8] selftests/bpf: Test user memory kfunc errors
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,ljs@kernel.org,john.fastabend@gmail.com,nierro92@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue,  3 Nov 2026 08:39:48 +0000 (UTC)
X-Stat-Signature: 3u8cyd6h1i7pspxo8c97z5oz7g6aj5ix
X-Rspamd-Queue-Id: EA0A5140007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793695189-424457
X-HE-Meta: U2FsdGVkX1+uatbgW//Nkn2XzRIs9iMJaWHmouabZAqO/R3WScnNEGuccexmv2WOqNN72bCDaX9l6lipswyPN7Q4mYSMRgQsclGS4UUFOX+/178CyG5469t/psPj9zq4NMOZQyT3EDiju2Xs8td7sqQP2gazL6cYT1lex83d+7uEZ92HXBd5oc8Ao3/dsjC0t8Thscab5WRA2jOrk1JiblXHabZdq5rk/gA/egzb8vpxCdUnJfFRjsgfjYfGYClnuSyBv6hKg2O6SI7iH4Y6CC8g+Z1Y0t7j6WGgQIxZecTQ1jrE9niVlMnzIK+MYzCwTgZUGb36FG8CS91EZid1F2HaW16vf3uJW2h9dUM4nNA31bVdZJeNQ77QTJBsegEYs8hv7ojx3xS6cG+KUGeaLd4DuEBM83++HAbZTCelGR8p+egUOspwTXPlozpTtoG/aLs3Eybld0zVgCn/3cJgvRYnRwEXIaUFyR9pC7faCeGhfXh9UppgzL7RYtMdFdI9DfXT3OjCHkIXPmyJP+lzdtN/CCIifAmcn0MUMA+RA/5a6Kk/Q/FiyOHfuq//8YIalo6JsK3yJ5FJJzq44/eX0fG51NTA+2FAC542Dib6UdsAmoD4A4/q00l15EXUNot/4D0KQoJ+ZlAhF3gyMUXg2CDHrsnikuI5ngaqWbtx34ONGez0qfrq04dPXvNYPyPGqDIaDGV7k1qfPWwkTSY5tZsf6Zvb0J0NuHBYxRWa3VtKeN0wXVC80DZDOGiNbz/Qrsu2R8VJ+vgM1tb4Yp8xR3o5cnXDu2CR5XF+x4wh+JYHdCAqCZ4QbyY6E5oyu94x5BOCHTTss3cbYP+YJ1H2nDBNKZ4I8JQJZR+hK8U8cWyLXFWLaEA4MEA3ZGAUHWYyvHHHJ4FFXqC02g3TPKfEYIZbr2OgG+zmGb+/BepsOoqZALdwaiF2mMfPtJZxdXv2C2JZJ6dLOnWcjSwYZac
 b0nUCEow
 X+Y2JsOr6ZheYGKz9jWLc78DHfhrg9nxbGHWlTWvqkWVnb7YoNYwNoY2oP2oSmw/2MJxIsxMdQgXzOflEGD54/qRNBpghoDIHCk4gQvUKfmn0GRy8aWamyH16nu5MB43adVgNmt6bqDwrJ2flqwQYuWaVfHcuOtVrDct/IcPb0SQoOcsKYRERq2d6UnBq7rpmLYE23GyMWxF92b+Ly+tSybgHXICu+5gWtQZcJh0+Ro3U/sbnuORKWaTpfEMFr6EBQOlBCq16qwzo8vY0ULX9C+U7AAdrO5iL7H3//3O28DJyAua3leuCHqDfXBJVldU2r0YI7VKZr0RwN6ZNIp7fokF+u5dYgtiJY2cECRKmf4VA4b2HDH8TJwDkMVF9XDrXW6h9PYnoIBurCT1+Ce5ccdSlricomJiJOQ5bdJpSR2/1t4LIFU++tXkZV+GYhz8PNEIgzfP6D8Frw/PIazyJSJPowCoiAGWx5ZuVoJVU+WLFBPXnUa78wTA1sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0296960252652514333==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: Test user memory kfunc errors

TL;DR: Test nit only: the user_mem_kprobe() selftest looks redundant with
user_mem_nonsleepable(), since both have the same body and expected failure
and load as the same program type. One may be droppable.

> diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
> --- a/tools/testing/selftests/bpf/progs/user_mem.c
> +++ b/tools/testing/selftests/bpf/progs/user_mem.c

[ ... ]

> @@ -80,3 +80,32 @@ int user_mem_test(struct pt_regs *ctx)
> +SEC("?uprobe//proc/self/exe:user_mem_trigger")
> +__failure
> +__msg("program must be sleepable to call sleepable kfunc bpf_user_anon_mmap")
> +__msg("cannot be used in non-sleepable program")
> +int user_mem_nonsleepable(struct pt_regs *ctx)
> +{
> +	bpf_user_anon_mmap(4096, 1);
> +	return 0;
> +}
> +
> +SEC("?kprobe")
> +__failure
> +__msg("program must be sleepable to call sleepable kfunc bpf_user_anon_mmap")
> +__msg("cannot be used in non-sleepable program")
> +int user_mem_kprobe(struct pt_regs *ctx)
> +{
> +	bpf_user_anon_mmap(4096, 1);
> +	return 0;
> +}

This isn't a bug, but user_mem_kprobe() has the same body and the same
__failure and __msg() annotations as user_mem_nonsleepable() above it.

Since SEC("kprobe") and SEC("uprobe") both load as BPF_PROG_TYPE_KPROBE
and the attach target is not used at load time, does user_mem_kprobe()
test anything that user_mem_nonsleepable() does not, or could one of the
two be dropped?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/41602296728
--===============0296960252652514333==--

