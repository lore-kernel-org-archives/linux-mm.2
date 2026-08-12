Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8D4C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742496B0120; Wed, 12 Aug 2026 08:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC386B0123; Wed, 12 Aug 2026 08:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609906B0124; Wed, 12 Aug 2026 08:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 455066B0120
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4AAC4039D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:57 +0000 (UTC)
X-FDA: 85092521514.27.030393B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2F13A100005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nkl+pLqJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yXDvA+BC1z5uaBcOf5IKbQODG+1aW8vyjmoSLm/JXc=;
	b=JyBB5OJfWDgvmctkoulw5WNk/DDdLTwcT9ZSCjV3okkrTuqO1kJzBy24NGbJdkepcpwYIw
	ywf8cVngcOE+bXkqGq7+3QdkulOAglmHDejgcQyqFW3bvx0jF+eagX49L7O2wEQyS3Xidd
	zYpjyjqoupz/0/402LeGwt88/TmdAjk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nkl+pLqJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537136;
	b=4kFAqInbHQV/izPzZs7h/eMntVZl7gmbZFyDHvbrKpEvX556DcwMXJS1HM1HdjfZ625zBq
	2zIowmKq76VaBgz8Dzg0Ce9zQqc7S9J7XTLXZrHzT4ZRVXn343cxhk/CJKXXH9mXm4e17r
	aixVtr6cq27oA3pStpAdT0xd5vPQsIc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 847434037A;
	Wed, 12 Aug 2026 12:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2FC1F00A3F;
	Wed, 12 Aug 2026 12:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537135;
	bh=9yXDvA+BC1z5uaBcOf5IKbQODG+1aW8vyjmoSLm/JXc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=nkl+pLqJ/gG/BgchBtj15AuCWYHmx0/s4+kjMLBSIS58gmI2lta+jTX+/2SC44IOP
	 A46OIfxyPaAM6mQRAEQXnvQlrIqZWmmYkD56CoMDWvEDE7wsbDgzhw15r9UsTDy3bw
	 hbD8CQRFknMHKHRUZC7uvt3B32RNPh7iuTj986xgDyrLlbNyUisvLELo5UQ4rcaFvf
	 1iFWs7fi+EhjYAG1QZZ70Hx5Yq4oSWa9SpQi2TB6F8K0Qfz2V16oLzGCYAH3DzFZlu
	 pfu7aL8362F5JqOBNd3hjsz6OvJmP0as4mKV+AIhDj4CNa1BaXXdj2kJDezrlQgPoH
	 NIWt8pWPrFjpw==
Content-Type: multipart/mixed; boundary="===============0942110370436710155=="
MIME-Version: 1.0
Message-Id: <16d139f5b77313ab4f14b656d2d885ad96641f699019b86d7f0ee59a0b6cd0b4@mail.kernel.org>
In-Reply-To: <20260812111140.7762-4-tasos.papagiannnis@gmail.com>
References: <20260812111140.7762-4-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Test linux_binprm user memory kfuncs
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 12 Aug 2026 12:18:54 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F13A100005
X-Rspamd-Server: rspam07
X-Stat-Signature: d8yn7trtramktb8o7si9imacebddf81b
X-HE-Tag: 1786537136-154004
X-HE-Meta: U2FsdGVkX19LrWJrDhUMZZxvNwoxoGpzssxsVIOkLHKgSxUH10Czh/9U517CG4v0DY1bgHYR3IaehrZhJRa4g2LPxyU8nNSNJ/vlortKRd32mQb66RjNd1n85jyJttKokFvigQKk4KcYw27+/ZcfYcOeABzJRnF04TIsjwfeEo8YHOWiDnyM1eOS2mUcnh/kOeuaCWNk1Z6fDIa56rJ8Zx+UekVYfs1zcUuQ4TmVduYeNHA7LipDgmyv8AukKK0AlVRUh0IMHZRCCDSfi4yvLkHc0zNHZuSZ69sWKHAAUDGFxxwNMH/GuBo2VW6Gjs7LiTL01krBHJZvR0qyw0w8l7OFNiPF+UEJi4SyzkUZHISOGkbNN31iBnYFQTdeQAU4BuvsYAhIzu+iAx/mGkROKTbD1wHGbdZkA7kPoh5p2Hx401xUlQhjIl2fo684T5C/Bt2/XevT+yvO0FO80Q94tT2WLYFi7x9nTrHreCA1QYmSuqsRV7tnrLKcA35v36AH9X3A6N/M40+TE1oNLauH2HG1Qx83yDkYn6e2iBDzOLN7kn+zFWt8o+kLJrwMsItET4X2vXrt2aCTiTn+SCIBqna16vEMEbRY+J6l669gtQI2330g//r1/OsZytSVmVhTtLKbxVdSG3RQuiXrU2VGgO/pkDuyJf8TGYNYMwTk1LzaQ7FfpXUDX9w6/2FSR71FdF6IowZRmuqO/Fu+GBgMHKTOUyB62COuS2zUGXyJ6PZN/rw6bXB/ICPY+VVlpebH7GdXW/e5FmplIFMkeD5UwdofGlvxicyzsAAn5fkOUdzNRyKRkVI/Ll9iydd5obHodxvY4t+b6Kka9ep/WjIuYSmOwWjNn26tyBsIBip0+/eI7KaDuHCv6I6qGvQPylNQSMZ9Mb+8wXr5Y/GcFoKOA8TehLnznJZ23d+r4H4wjNc1Rhwi9ywpCMprOGmRGAvYIDNhi3eiUGjsq1pRYeU
 +mTktlh8
 f3mf0QxJAyVK2XLtXs3QGU6vK6SYxqKVn/W4S56GjnSTVrv/FovtKrbZZRUNrDs9K6+Jv+PRnONNiQO0OQA59QAB1x4Z2OS5gSLaxbmFJ6Dk6c7gGcKeJuHHonUNc2p3dGiKi/Q7VIYG+0+6YpJgmVcxRMX40YskH4eqi7nhLHjwiDdJeNb7DcrEmGXhzF8SwObUcOMGL/PLfPDxukU7x0UiAkOm3viDrTpFA4K2VIWknZ3WOrex+2nDht4J0nAG9c0R1kWBaDDzFlX/rvU61MMCqbvWhv5rWTvkTN36h4AFzwvRO8XWJY5jJNLQbzX43MzfzFGD6HlmuwMBSe5w4wl4hvsRydueNnZjdi5yDCkwOK308Cz0hG94Cco85EtTt6bt5KXJsxu0/fW3OcW4mXp3XTXXtSjR6FkN97xuNq8xuaNArDQhbdau+IiSbLsgMd4OC+Nk5DzYr82JB4chefQc+A7iFbOH1ZhMN8UpFM+imq3qcwMwglEq52asd5I6LpMfUENyfqd48yTHapa0viJjsWDSIAi1BZ/i3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0942110370436710155==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
> new file mode 100644
> index 000000000000..3d5080a3975e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c

[ ... ]

> +	if (!child) {
> +		char *const argv[] = { "first", "second-argument", NULL };
> +
> +		skel->bss->monitored_pid = getpid();
> +		execv("/bin/true", argv);
> +		_exit(errno);
> +	}

[ ... ]

> +	ASSERT_EQ(skel->bss->str_arg0_ret, 6, "str_arg0_ret");
> +	ASSERT_EQ(skel->bss->str_arg1_ret, 16, "str_arg1_ret");

This isn't a bug, but could these be written as sizeof("first") and
sizeof("second-argument") so the expected lengths track the argv[] strings
defined above? The literals 6 and 16 mean anyone changing an argument
string has to update three places.

> diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> new file mode 100644
> index 000000000000..679363811edc
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c

[ ... ]

> +	invalid_flags_ret = bpf_copy_from_user_bprm(args, sizeof(args),
> +						    (void *)bprm->p, bprm, 1);
> +
> +	copy_ret = bpf_copy_from_user_bprm(args, sizeof(args),
> +					   (void *)bprm->p, bprm, 0);
> +	if (copy_ret)
> +		return 0;
> +
> +	args_match = !__builtin_memcmp(args, expected_args, sizeof(expected_args));
> +
> +	str_arg0_ret = bpf_copy_from_user_bprm_str(arg0, sizeof(arg0),
> +						   (void *)bprm->p, bprm,
> +						BPF_F_PAD_ZEROS);

This isn't a bug, but would an obviously out-of-range value like ~0ULL
read better than the literal 1 for the invalid-flags probe, given that
BPF_F_PAD_ZEROS is also 1? A reader has to look up the flag's value to
see the two uses are unrelated.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31592551940
--===============0942110370436710155==--

