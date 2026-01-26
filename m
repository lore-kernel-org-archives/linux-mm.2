Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3923AD74EF7
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272606B0088; Mon, 26 Jan 2026 04:30:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6036B0089; Mon, 26 Jan 2026 04:30:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3D46B008A; Mon, 26 Jan 2026 04:30:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EFF7E6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:30:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A78459A6E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:30:27 +0000 (UTC)
X-FDA: 84373594494.14.CF34149
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4423100003
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:30:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=MjPNuEKr;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769419826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzEMWEqOl039GOThvYgf7iZOtrTNz/yDt/lYinfv6wU=;
	b=chyM4T3R2X1Ryv3RWlXwkDivVSW2bwq1o6EfJlHAsJ//XG+NWqQ9wqXTMtd+mPLcecZSvL
	BHx/MPu98cl+x/6/ANxco9WSV+quXiUEESVIdLMQsDEi9mwJMD7X/8u22W20GY2YkRSj5d
	sPLKdew6KE/9jE9T19vHYIC5qztKQBc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=MjPNuEKr;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769419826; a=rsa-sha256;
	cv=none;
	b=1lSksHT7tNdXEO6Jnjb635c93Eaq6TcN4b88LfIVC/IgtXHfyN8o6W7SR50WLtuPQnNf//
	1uxacMy7x8qgHu06u2VRgJ9i9343kvmsypVrfqEFbG4IJZkdQPAdgUNGfr1NiKBN6E9Oy2
	SUWSlry/eltnxnaN0m/lv2iM5wmU8xI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E63043907;
	Mon, 26 Jan 2026 09:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5A2C116C6;
	Mon, 26 Jan 2026 09:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769419824;
	bh=tPDTH/y75T67JFjuIWvMnrDHNL7T+b3GWP+6DE5AMmk=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=MjPNuEKr3A4Hh5VIPhoiaA7JHMRRadBXQM5MCSbzj5KhL5Vt2D5vZdk26P+N8Uq5a
	 3xapmE78VcENeQdCYAkAZ5W+g5Sj3Q7qdluC60S200Q1/pQi4ajLIib1H39qJzi1SM
	 zZBF+dqICgUOLo4FM26KOVV63lbDQAX3Dgjnhr7Y+IvroK71HIX12dS1RQon4g/yF1
	 SB9exwUM2HJEYGjF4KGSv/o7AfIzeayiuXJalezv8cAvfzu9gEaRbO8zkEM3q5mN0c
	 ACsqtNyYmwTuNGSS3rD4AUkU9n5fojcajCTxxHalLmHT/lZ5LnBUR1m4O5ETw+3gvF
	 Dte7tqpHGVf3A==
Content-Type: multipart/mixed; boundary="===============4570348085458857697=="
MIME-Version: 1.0
Message-Id: <522167db42c30a5a277f7f3cf0042aae0835cf95606d04b9a251ddd2b3a66f93@mail.kernel.org>
In-Reply-To: <d7dfd68ed07fa445d616c3e21217bccafc951ae1.1769417588.git.zhuhui@kylinos.cn>
References: <d7dfd68ed07fa445d616c3e21217bccafc951ae1.1769417588.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v4 11/12] selftests/bpf: Add test for memcg_bpf_ops hierarchies
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com,
	jolsa@kernel.org, shuah@kernel.org, peterz@infradead.org,
	ojeda@kernel.org, nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, inwardvessel@gmail.com, willemb@google.com,
	kerneljasonxing@gmail.com, paul.chaignon@gmail.com,
	a.s.protopopov@gmail.com, ameryhung@gmail.com,
	chenridong@huaweicloud.com, lance.yang@linux.dev,
	jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
	netdev@vger.kernel.org, linu@kvack.org, x-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 26 Jan 2026 09:30:23 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Stat-Signature: jyjnjuyz1zz4bdo9yjisynxzyrajh4fq
X-Rspamd-Queue-Id: C4423100003
X-Rspam-User: 
X-HE-Tag: 1769419825-343278
X-HE-Meta: U2FsdGVkX1/hHMhxbklC2GPu9Ax3o8CpiYiM7H4f4jMr6nzF558v4gnMjz76S8QZx/0pBy/dZ3lT3Ieno8XoDQv0Uujtt/FbCx5WuHIde0tJRFetD20wzev+qnIF86hcSPEHUSJPUGy8QsqqiGZtT/evH8lWjoH1OdNclUBoszuhsHzuuKbiZfSOIaCvpwntdaQ3vAnFG5zn0PawCin/Xb6rUQ0pUpvLcyLTYz+O8MAYY8w+HvOmniQGSLwF1T2tZPqbGuZ/crEr9DqasJl13gT56j/KAz8rAwEKGnesuM0MLRR1/v7VZWIKO9LQyYxEnwx+Nns2P872jCuJcocquSgd8jQeVNIlJgcc6Zc96B6RuNN/I54nONPXBDLTGSEEeIa7yL+Gfrzkbcg2CtpNEXH8Uzxk4c5hw23C8ED5CJqWAq1PvZR0JvaI+SI3Zto2EXka39d25ikTx4t6YtGx2TzK9J1jZcBCFqZ7b4hmtrosqFk9PDwceqViWwfSdvImN3bB6KSaC7O0WejOvmKdWyU48FDw1v1OgXJKoXj3u7u9gr0AVsjFqEctLLjDovfLpA9HMQ80oPlpcySAb3W1yufLZX8E0kxR8YtNwFbcZ7/Cuk46EloIJalU+AhvdKKOBluNS49dmiWYAGl95gk5+Ubpiyfm0UAsG1IWSc1gtsi4kzo93AQpajyCmoHRTWXlFfunIFRdVhx7ya7Wcqs7kR5+nd9CyZtH0HTOUibInfiq5ff9hb2/JSDDlUfhzioE0XsLp/9fOXBHxHQnTI04e/S0Sxap/MjqR1XgSnpksnJ0BwFshES9fVGlSOIV+a5RsHjSIItkd8e5EoTTwfw/Ioy1YY9iK2hE5VjccVupyeLNYXODSrPMg2Q9UlkDn5WFV55pBA8JQRiXq0kg8vzlEMip2mE9W7BJFuyFILJ2zYDWAlWI3WZdkfGv79owD6FcfWeR4LWde5h0qt5DNBr
 E5w4F4tw
 +lSlzf6w2VNjIhf/BafbvngUCF8+Re2ZoCtRLdqMVT4E5rkbdf6vqEXdPiYJbIdr43Omz+eWA8gv3GKU4qz5o0K8L56dsTXJnzOV4aKr06Y0oCkRXn9AVZOS0gJYHaqtzWSnY3HIda/RJDAJHahpPqq31k7PJFzF3OHgNgw2stiaabz042mJw4Oz07uQfOTy9k8uM/iQ99iGGSoPlLLeKrAzTPnt4C2uXHb5L2/162JpsUcmFhoTbMmKKZ1OBWz0i3XqcoWlJLTCnNMAQHQDF+ARo6aMy0CuDcvi1RLbAese+lsPd4ccRrt2oi1en2jPzdYdyfIxtgVBC+Hx3bJEo4+i+SCQtDbUamZonQFjVLGTk7+NNeHs/e6nlN7SGyqMLChSdIBuZFnoFJ4vjfd3ui7T1v/O51/fxpdMsz2Y01msoZzu+IZWv7rNCjce/SWtNX56wJSd2Y8z+1x+dCvJ9vrzpLKkr5fPrK/ymx1iom2xVuPbpbjoUDq5FLnzNz6+pxIbJRQUZvpCzgIyQNuwc6m4U+WI56ZM6ZgcPyaFy2sRA7ROeYyHo6Sl01dNiUkdzxagvvBTDAOmd5a+cUe1RU4KiKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4570348085458857697==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> index a019ba2387bc..08ac97752ac9 100644
> --- a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> @@ -539,3 +539,73 @@ void test_memcg_ops_below_min_over_high(void)

[ ... ]

> +void test_memcg_ops_hierarchies(void)
> +{
> +	int ret, first = -1, second = -1, third = -1;
> +	struct memcg_ops *skel;
                          ^^^^

Should skel be initialized to NULL here? The other tests in this file
(test_memcg_ops_over_high, test_memcg_ops_below_low_over_high, and
test_memcg_ops_below_min_over_high) all initialize their skeleton pointers
to NULL.

If any of the early checks fail (e.g. setup_cgroup_environment() or
create_and_get_cgroup()), the code jumps to cleanup where memcg_ops__detach()
is called. The skeleton __detach() function dereferences its argument without
checking for NULL, which would cause a crash with an uninitialized pointer.

> +	struct bpf_map *map;
> +	struct bpf_link *link1 = NULL, *link2 = NULL, *link3 = NULL;
> +	DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);
> +
> +	ret = setup_cgroup_environment();
> +	if (!ASSERT_OK(ret, "setup_cgroup_environment"))
> +		goto cleanup;

[ ... ]

> +cleanup:
> +	bpf_link__destroy(link1);
> +	bpf_link__destroy(link2);
> +	bpf_link__destroy(link3);
> +	memcg_ops__detach(skel);
                         ^^^^

This dereferences skel without checking if it was ever assigned.

> +	close(first);
> +	close(second);
> +	close(third);
> +	cleanup_cgroup_environment();
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21352241149

--===============4570348085458857697==--

