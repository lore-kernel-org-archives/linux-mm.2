Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE34EC88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05866B0092; Tue, 15 Sep 2026 05:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD496B0093; Tue, 15 Sep 2026 05:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4BB6B0095; Tue, 15 Sep 2026 05:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAA7C6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:01:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3EE9C40380
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:01:53 +0000 (UTC)
X-FDA: 85215404106.04.CC1AEF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 98FBB18000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:01:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHs+4okT;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789462911;
	b=jeTYt8w1gm+A5IZrLa4zsRhnHziuxR8kwwG6l+4xyc+wOmnSd0y+M8cddTVTASBxKtrTH9
	vimyi212KCYmEBLDCUjX6u/FdDu14zYJWpW/YuBi0VujUAle9yRByS6vL+QHMfNvIflpz9
	0U/ViY5i3o4+KDw4ICkr8338ASSxt2w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHs+4okT;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789462911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exObQpVPCz+CYWwPcxHV0eYvHDRpab6T8xfQK+9Wolc=;
	b=HXcQndnSmD6jsQuzpnsEwoeqqk5teJfTLh9D4TZ7Zjuzrlm2mj4otS4pGDIP8IKIfIAMgt
	5KBKY+F/woYr9GFrqDmMv0UnQZ+PqkyZPuWWWr+PdiFPnp7nz9D7wmnGH4rdx3UbqCDX2C
	T+OYvo4RDsh/2/tcYMP46BKEztdLfIg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B524B444F5;
	Tue, 15 Sep 2026 09:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9451F000FF;
	Tue, 15 Sep 2026 09:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789462910;
	bh=exObQpVPCz+CYWwPcxHV0eYvHDRpab6T8xfQK+9Wolc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=nHs+4okTqlsr/veDUcsDRkgqzRvHrYeS7z7WOEYv6LKZ95EUEM94YPMgS1m0ollGq
	 L/MVyePpk1zV7RUrhyprB6BD9MRmWIwwveGibN/SRM7NkrTwB0Gj6vvi9K9gUlSiVl
	 01HSYpmuNTkOfc59KnL7VLMY+yhdyVAnZY3z1eVVXDx53cwmVrcSQa8lQIbf5AjXpC
	 uJdCXMtrzGomyFTX+XBpQep2ViZ6+S7zEY22ToVOT7sY8CKYD6C1t2N9wSvzGCQXv5
	 /eMOFnLzyYNGhbu7davJym+Gen/NsgU3MhX12j+u2d9BZ+dFbIHTzqIqbJ6sS9OB2S
	 cRPp1mOD8tCkQ==
Content-Type: multipart/mixed; boundary="===============3167789660122054062=="
MIME-Version: 1.0
Message-Id: <9e4c6c05feaa894234b5941f694c04db8da58169ab1165ff1a6579ce63dff8f2@mail.kernel.org>
In-Reply-To: <20260915080255.48929-6-tasos.papagiannnis@gmail.com>
References: <20260915080255.48929-6-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v7 5/5] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,david@kernel.org,akpm@linux-foundation.org,andrii@kernel.org,ast@kernel.org,brauner@kernel.org,daniel@iogearbox.net,eddyz87@gmail.com,kpsingh@kernel.org,ljs@kernel.org,matt@bobrowski.net,memxor@gmail.com,song@kernel.org,sun.jian.kdev@gmail.com,utilityemal77@gmail.com,viro@zeniv.linux.org.uk,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue, 15 Sep 2026 09:01:49 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 98FBB18000D
X-Rspam-User: 
X-Stat-Signature: 9rthr83gdhciqa1nmx41ihwrqh14q7jw
X-HE-Tag: 1789462911-937140
X-HE-Meta: U2FsdGVkX199knEsYFkNVR31MdhFSIhJcbYzkF1pvyMev0KqiCX/JVLv+mOqEc7wobDTCo3D8maSYTwRyjS/N0hO++1bdzdSrAZZwjW+Sq6N5l79GKuteti6XpXkdJV6yd20goT5aTf8+pcxDevF8NW9hMyz4akoo0OCGmeeIT8MZORKPaBB3hLmxtS0pnEpXU8BEa+UuSA73LHH3aqsUu1ThEM2M2Wtncc0sahmshb2x47VJcfACNXk+Q1eUUAHQ2ULAs5f85oLhSLlIM2HJxJkfmtInLQam2sbv4GLuPH+3KKYBbe39BVocmru63mV8tp/dUmDn6Pq5HQroT/j65nNyKblsjeda1FVuwZDGskpTIIJ3ebWdAllWpFXgpGBkCO/IZ43Zd28/+6DGACFC0vegvrcf6LOuWmO0nL2xfRqB5C9I2E0qosKpqQX7ddZzfe8HakDBeEphLUiijKP2e72nWLonrfjobra4p3wxSQSmfYmydpDNuO/5ZQomVVcKlNmpt7nWFvM38YcH1ptmRQv2BC5ul5EdhR7Hvx2W795ok3P0yRfRTviclSdMbtm+Rvmr1OiALNPcqnMQRd9CNmYKAQtywl2ti1QECNfuBc+8+rhAqTM9+wtuMoP1Ixa37KrVlA3BiqK4bovmYL8UcEiUTdG4z16Nlr5AcuG5PpHBCqwEjd5YYJiMulKZEkWiTw8SbkEww8233aJ0i8ojUIWb46kQGH4azuoRLZDfOZcz8OQFv7lTwTsNbjXK6iv+45/Uz95JmzP8a/WyaxgaZrfHBckBqlZOGD5mR/RxA8rBGvXph+lh4dUNDM0hUHzWJ2dvVopjDp3MMTWJYavahav7pgLu2/D0o5udEpY7EiUJXHyTEGy4TEuxa/+bM3tefbOyrdkOnkXUYIGwbBaVKGifDgtlLV52Gn6v/LzYfdwttfnT+n2R9X+zixzQ0Xh3zltFdZTXnLQ23C0VPe
 UJWafkG5
 7duNdvwD4H1t++sQ+uFUwTJp7YfEE44ft4O+TSezoBtRHMYMrnmzCqDA9x8iVJbv9Bfb6y8ic5WcM5CvAWSYCghbC3UxArLFq/EbQHyP5zhwU439iQPEOC0XavfKj9kbl247yh/CBN6keHnuMlkCG9PfZkv8Gdm77g+EM0GcoyoBIdtkeOEQPm0or2CNr/lq1zDH8+scBcgGxPaJlJf15HRT6zTf3I+KterrLccbuX9o6pLahh1ud3gk09k2kFMVIj5Bd+J3OtLBws+eT1xR0ArdQ63Reti7krOIdqx2oOUFGq60kHRrnhQPen3bMAV7zX5PLOqKZYvN5dUqx6jlt9lA6aRvu30cTu//bXRyIQ4PZYwEOeAaBqKgRRHj62XzCYnKYwECTg5hFVtJik5wqGP+uMFrxg9FSyawWgt5Cj7GGg4RuPvg8goLC6+/+xS1Fh3eZUrrBQ73qI8Ai0OpZj5/ktMrsP9LZUYo6WRoZRN9pOa/3HXvqxD7LPZBoLXLwliO/Vv0/QGrwuE9VQW8EmtOgn/sGBfHckG52
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3167789660122054062==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> new file mode 100644
> index 0000000000000..07ca96d9db45f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> @@ -0,0 +1,122 @@

[ ... ]

> +static const char expected_arg0[] = "first";
> +static const char expected_arg1[] = "second-argument";
> +static const char expected_env0[] = "SOME_ENV=a";
> +static const char expected_env1[] = "OTHER_ENV=something";

[ ... ]

> +	char arg0[32] = {};
> +	char arg1[32] = {};
> +	char env0[32] = {};
> +	char env1[32] = {};
> +	u64 offset = 0;

[ ... ]

> +	/* arg0 is at bprm->p */
> +	str_arg0_ret = bpf_copy_from_user_mm_str(arg0, sizeof(arg0),
> +						 (void *)(bprm->p + offset),
> +						 mm, BPF_F_PAD_ZEROS);
> +	if (str_arg0_ret != sizeof(expected_arg0))
> +		return 0;
> +	offset += str_arg0_ret;
> +
> +	/* arg1 is at bprm->p + sizeof(arg0) */
> +	str_arg1_ret = bpf_copy_from_user_mm_str(arg1, sizeof(arg1),
> +						 (void *)(bprm->p + offset),
> +						 mm, BPF_F_PAD_ZEROS);

Do the offset comments describe the right quantities? Looking at the
buffer declarations, arg0 is a 32-byte array (char arg0[32]) while
expected_arg0 is a 6-byte string ("first"). The comment says arg1 is at
bprm->p + sizeof(arg0), which would be +32, but the code advances offset
by str_arg0_ret, which is sizeof(expected_arg0) = 6:

  offset += str_arg0_ret;  /* str_arg0_ret is 6, not 32 */

The same pattern continues for the env0 and env1 comments - they name the
destination buffers (32 bytes each) rather than the expected strings (11
and 20 bytes). Should these reference the expected_* arrays instead?

> +	if (str_arg1_ret != sizeof(expected_arg1))
> +		return 0;
> +	offset += str_arg1_ret;
> +
> +	/* env0 is at bprm->p + sizeof(arg0) + sizeof(arg1) */
> +	str_env0_ret = bpf_copy_from_user_mm_str(env0, sizeof(env0),
> +						 (void *)(bprm->p + offset),
> +						 mm, BPF_F_PAD_ZEROS);
> +	if (str_env0_ret != sizeof(expected_env0))
> +		return 0;
> +	offset += str_env0_ret;
> +
> +	/* env1 is at bprm->p + sizeof(arg0) + sizeof(arg1) + sizeof(env0) */
> +	str_env1_ret = bpf_copy_from_user_mm_str(env1, sizeof(env1),
> +						 (void *)(bprm->p + offset),
> +						 mm, BPF_F_PAD_ZEROS);


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34946192265
--===============3167789660122054062==--

