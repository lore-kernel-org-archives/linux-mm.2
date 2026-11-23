Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8570D606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eUIJxoyw
Received: by kanga.kvack.org (Postfix)
	id 980F26B05B0; Mon, 23 Nov 2026 11:43:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931A36B05B3; Mon, 23 Nov 2026 11:43:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820926B05B4; Mon, 23 Nov 2026 11:43:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3766B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:43:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5FDC16090A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:43:58 +0000 (UTC)
X-FDA: 85466955756.07.D4EB860
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1E19012000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:43:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eUIJxoyw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795452237;
	b=Syq54Jcco+19rDJ0uZyCij62FtkxVPABGvYRlYMH0kDhqEgVr3cxIxRZnmrW/TlFmVax9S
	TZ4WfuN4pg9YWOw2/xW0RhNqNM/cqlPeuIf/81TKBVff/J3/0xmkfdNCG/6nVyytRkgnHu
	7h8wrjiZQf7+ibLqcQTcKD5XgxtBaDw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795452237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rs+CcN71c0Fi1/KME24fU/+FqAEJoRqbsSd1mHJLo5s=;
	b=czxj/TE7AFVfxjxe+lV2KCzCUldKcfYEOE7RLawwhnrW4HCicME9OIxKzQbXxts7mM88tL
	B2NrEls4HyTjdTCA6WtCDAM82x+1lt6yzSetbNR3d9k4WzalI1DU0lC8YbcStrT93fv86J
	Xu4LGklss9TsktlMGh6SJNNszHt6HCc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eUIJxoyw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 487BB40275;
	Mon, 23 Nov 2026 16:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184B11F000D0;
	Mon, 23 Nov 2026 16:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795452236;
	bh=Rs+CcN71c0Fi1/KME24fU/+FqAEJoRqbsSd1mHJLo5s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eUIJxoywufebTbJfzuPZAEBRRY74GRd1ScI2vtPbTncPWSZ6v5NL0meYpV84J0aSL
	 EoQmp7bLEyLIr6yEDDVn+ySZ3daJiu7s4mGkeoGF1XF3YTZ/kuEoBRoGUH6YKEVq+p
	 wgYPVt9yuBDFwbAUalV9l7yifFlNEOOAcOOiUQ2nWKoNBZC0in9aBrSKqLdq6J94iu
	 +pYQZIZ2YWO/6FOaGn4nIci1NxbLY/RL6j8LOIxOt7sCh0YglUVA+GzVHaVE/0H10X
	 SeNCwVDQ7Uk4k5mbl4Cb4IvQVt2psJ5yjJRz2TUH9mBUn8LoWKpsHv0bqaTbmcxK8L
	 Zzr4NldKiCy9Q==
Message-ID: <ccd35073-e77a-4864-ada0-4b43329e8ff4@kernel.org>
Date: Mon, 23 Nov 2026 17:43:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] selftests/mm: fix false-positive and racy KSM fork
 test
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 donettom@linux.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20261123034136.209410-1-xu.xin@linux.dev>
 <20261123034517.236914-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123034517.236914-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: cpbxc4ss87w4zmyfmjssh3h7xco1ozph
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1E19012000A
X-Rspam-User:
X-HE-Tag: 1795452236-377247
X-HE-Meta: U2FsdGVkX1/LZW9WxUqeEcY/ZqvEcVA9j5B+icW2oZHXMYSinu3QEFNO28D1jbFvs4GumVjM2NUN/25U02qvcKwuyB0vNyPQlii//mDwXczSJ4lJkI0tnPMr8gBHVuqTgoJgPCJutAM85VeM1iYtyR1PY/wkdh1+RvUgnEWQgG/KDoAs1tG5lF/UQFdLVU4EKt96cqJVUb6UAe2DZUloGqtLlodNde2o1F2034UyVtcV6vuVHGrobGKVRel3mRxNe/H8Sh0mJXjU4wKtHAZbH+qLanZc7o3vTBxxsturnZqslO0AgE1j/T9Yqyb7ZkEIGnMZTO3TQlFZ6LQy6Lee2D+3eZpPheHOl65Sw/RbXT9XQoGkeI/laTOEgFjysGidwBqmDVZoeNTxgdduBbFp++jBxnJOPeHKDvinNJtYE48IlQQZzJTk3sg+m1lbG7j1Mx30l/Bu/ZuGr61fL+Sga9AX4c4c5JKzORkddyvPmtEQREIWxa77oF5IvvU/s2SlL6Mh7FtQh/lmVHS3dYgBtQvTGNItSBDbPPpFCcN02Nehx6zNwquUOEyPVreNkqye5qZcdoTdptOBoo8maDHfp+eAhIs340wCRlihMoxd4PwlCP43IQHdS2sWzN8Wt0jm4TOha9fAyWDfB/Mt6y1/+Q7qErW9ffu2TwAF+xIQwagGjyGo54sNvb5Dk1CzQkol7h9Sk3xxdmcGuejZZHIbOvW9ey6T8t7fqUO2ZqPNzghH7b6/qZzuBXVd9BNaCTZGXOs7NcJOJFhRCG+aBUmLqMLzMKhk/D1ErMuX3Xs/Kqc6e/327apcTjcW/1kwdCG7KCM4hU8YxkwPT6SXw39dxeQvnt7eKf7d2wucOpPb7S6fdK1g7e3VbkKoqPR1vu7uwgrA1MznsK2qtsCGXAjnRgdhJKjj0TOUt73P5+WSY52iNXVMGBPX9j/Tvw8JvOv+hv7qv2dfpUXKpCV+XXq
 1NdlW2dH
 w+McTjydNvb3hoxBbTVPjmoHnJaJQvXYHQyWfrnVdo4psswgnUPXjgrsqmfnobQedBxA101058hEjMcew5uE1WO2v2HSMdItET+s45pful5O1XwZeqqkUIsWoEino49StKRPv0MGt7a2yK/oIBvD6zXORs2aLlyy172JLZPUt2ndNzWx6QDzyGRsEMAiqiyjs3c+td42r6lvSWd98JWJkbu6gAF/LD7MceNUmc2VCT++s5w8+AyTzYz/Jn9MAIlB9mzlaI6UPOX6OsufE89UDyfXbUJl7RIOWWestq7mSIT0pltZIuvITF9DH8AeNo2CJ8ErBI6OsclQbI8D408d4hJX0IXSy51ZiQ1oFYu18b592koNOHrvn5WpVDioFjbUlvxZBspT0IDt+PS8mF3y5hDewTJkzJRfwkz6p5Fep7dXoRYPkakeCKkH1hcqZbr2QKFXDenYhuCHf6d5Eb3ho7FfTuBLZM9A+jhqJ71bLFrNv938qVm1LpxvJGJ8BLp9vy464
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 04:45, Xu Xin (vivo) wrote:
> Currently, test_fork_ksm_merging_page_count() passes wrongly even if
> fork() fails to reset mm->ksm_merging_pages, because the child process
> calls init_global_file_handles() -> ksm_stop(), which unmerges all KSM
> pages across the system before reading its counters.
> 
> Fix three issues in test_fork_ksm_merging_page_count():
> 
> - Drop init_global_file_handles() in the child process so it does not
>   call ksm_stop() and mutate global KSM sysfs state (unmerging all KSM
>   pages across the system) before reading its counters.

Right, that's not required just to access proc_self_ksm_merging_pages_fd.

> 
> - Use '!!' in exit(!!ksm_get_self_merging_pages()) to avoid 8-bit exit
>   status truncation (e.g., 512 pages on 4 KiB systems truncating to 0).

Ack.

> 
> - Introduce ksm_pause() to pause ksmd (write "0" to /sys/kernel/mm/ksm/run)
>   before fork(), preventing ksmd from scanning the child and incrementing
>   its counter before it is read.
> 
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> ---
>  .../testing/selftests/mm/ksm_functional_tests.c  |  8 ++++++--
>  tools/testing/selftests/mm/vm_util.c             | 16 ++++++++++++++++
>  tools/testing/selftests/mm/vm_util.h             |  1 +
>  3 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index 135191f99962..b871d5656688 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -668,10 +668,14 @@ static void test_fork_ksm_merging_page_count(void)
>  	if (map == MAP_FAILED)
>  		return;
>  
> +	if (ksm_pause() < 0) {
> +		ksft_test_result_fail("Stop ksmd from running failed\n");
> +		goto unmap;
> +	}
> +
>  	child_pid = fork();
>  	if (!child_pid) {
> -		init_global_file_handles();
> -		exit(ksm_get_self_merging_pages());
> +		exit(!!ksm_get_self_merging_pages());
>  	} else if (child_pid < 0) {
>  		ksft_test_result_fail("fork() failed\n");
>  		goto unmap;
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index f26f9e4bfdbe..e638475543e6 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -1080,6 +1080,22 @@ int ksm_stop(void)
>  	return ret == 1 ? 0 : -EIO;
>  }
>  
> +int ksm_pause(void)
> +{
> +	int ksm_fd;
> +	ssize_t ret;
> +
> +	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
> +	if (ksm_fd < 0)
> +		return -errno;
> +
> +	ret = write(ksm_fd, "0", 1);
> +	close(ksm_fd);
> +	if (ret < 0)
> +		return -errno;

Could close() fail and set a different errno? Unlikely I guess, so this is
probably sufficient as is.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

