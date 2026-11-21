Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF32D606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 07:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2zjd5lz
Received: by kanga.kvack.org (Postfix)
	id 80AC66B05B0; Sat, 21 Nov 2026 02:45:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CD26B05B2; Sat, 21 Nov 2026 02:45:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688F46B05B0; Sat, 21 Nov 2026 02:45:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 414256B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 02:45:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37BC81A0377
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:45:36 +0000 (UTC)
X-FDA: 85458341472.05.DE6BCC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9368680004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:45:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2zjd5lz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795247134;
	b=d+sIUXhr3UXZXDSOlMDoKnLo68ClYSmEkv2uxg19LTfzQyaM+97G8IcfvQOmcJuhw6X2vO
	xUZex5dkHoBmQ6o0vmR6X5LKdLbaY/QqM23REe1P5L3skRMpJohmQQRNLDA4Ml8KAEN8DH
	OOWPmJjNSoYHZ7z5q7WJelT/llVz2ik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795247134;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWT6EOaZJkGf1HPX4V9lRUEg8cUvv4X1pw3eaSYG/wU=;
	b=7RdoP6DC5sSRVh4a1ZMWIm+RvPlatYPLtZ+xMtEvLDuQKrkHCnO5GV31pKf9u4826cExIE
	IhqpIFXOKmNBoQoBVq+6qP/XerxxZvKfgvbBKr464yGKEBKXss6/ZyocHcPjJQL8bhwryF
	UhKAOtTPVCA1/BdCItcheZnoOsTVdAQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2zjd5lz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0855A602D4;
	Sat, 21 Nov 2026 07:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CFE1F000C0;
	Sat, 21 Nov 2026 07:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795247133;
	bh=VWT6EOaZJkGf1HPX4V9lRUEg8cUvv4X1pw3eaSYG/wU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T2zjd5lzizPuC5XLM4B2D8unXuxWcsyabBcY/VDIjkwspMfVayFSwOxspAEhG9gPe
	 Gv8wUd3/6LXnSqbCQX88kLFjesG1u6A8Alnope61TqiG7doecovB7snbbfJiIYwUip
	 3/SfJ3t464YAUGy2sIedY3RSQZJTBDde79hteTv7fwsR+OiDLlp17tmcf4QNSodCgL
	 D+0mtqoFbOkSayuXMbn+emrqZb+vR0pZw9m0uNU3ZB3p8FyhLtrIODJ491QJIdRlLU
	 xE9yKxJ89WByDKKVT6egGqZnquwsEwYEvhZaxaokCCr0pwED4ADQYIMQlQ2AM7BAVn
	 5IBfIMaFld1wA==
Message-ID: <sashiko-outbox-226796@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] selftests/mm: verify ksm_zero_pages is not
 inherited on fork
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?WHUgWGluICh2aXZvKQ==?= <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, david@kernel.org, donettom@linux.ibm.com, linux-mm@kvack.org
In-Reply-To: <20261120074459.41517-1-xu.xin@linux.dev>
References: <20261120074230.40269-1-xu.xin@linux.dev>
 <20261120074459.41517-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 07:45:33 +0000
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9368680004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: a3xojtzkt7wrzic4oeuimcojott3ojqf
X-HE-Tag: 1795247134-265342
X-HE-Meta: U2FsdGVkX1+NHHf4J0SqsR5cGprWX3uYqsGbyE0AAUBLli0PZRZ5rYTUWAcJY6NKw3GkQNiRtLzKjMda8xJ6e3xZnHwmix/dqivpIY6a2zPDG0WNtawi77vUADKWrxDH1U66SzAsvmf1fHszJICXgfw06cMSbyivWJDg7IOHjV/1QR62bRMtOT1+C6d3Bew3qnxwy9Th3g1gSZWNIUtK+kotKqmz86lPrl7O8hyYY9HSl1qdZ3J6pb9+1FQuFFrZurrCPX/TYx7jcvqikGi/8NX58RmNSxV1vtjl90Kp9NBm8IjfIgx8qQY3pTq8uUNNM3Nahq6MOFlpbnBZx55LUGLlSZvINudlIB3ybwezExbz/IFJkbGCQFqoupPfPL2/gzoNEi7z9EgcrorQbpQg91nyaKf/OKHr040IX0Ch9CH4X54RLWe+2yQg9zZVAT+RJ1Ubicvc+QC3XdbEqG/Md32lnvXmWUP56mMMVWD1lkY6yizZ80J2fi4VkDtdRqTQ8CtPDQv3EooKLccteKZAKBblYBfTzM2LyiVnUhViw1BmtiN1oOVZ6Yenp4DF7UMAFQGbwV0UbnF9rmN47Li0ir1P6hyco3wS0eyuVkgKG7kfUIvKU37PPbZ5EAOaWJm++u7h4M6JExHx6m1V5rY5KnKjz2YV/yfVW7QsT76DS/8+gnAPNzo+WUjlYOOaWLVH6XPYZ49hnsDkS/yKQYm45qX7XjmY8og9L0AumTnUue0QZ2n7bhJ/0eSk+j8oseApS80Ug0gCrGKxEdzmrCyCNWAzYLJ20WDaBZ+8cTWhr7bmPyLa/H/wSiCQ02DaXGnqkjZWrRQOiypRK2FNXJkfp0CJYNiX1ddUsrIajrASx49lFGsdECrHwRTGPyH1nPpg+NMAWHkxE6za2fzx8NhElwzYJ0JWfkWI/K1ix/+GX1lLJXA+lAX8sdQVHn3zGvSLJJ3Bpy30v//9arB55a5
 ApMWRDB7
 NRzS27jltb8FxB+APuZLg+9HfOZK6c+1P2kvujxMzjMScXz7b3lC+C6ZUJkGD5gLS7QtZFBck3OFwZSTklP8bXS7FX/RK1nTOijyXvXsxmf+U1TFnXps5TDMfw2TYHNXuhctND0PAonlX+ybL0QMh2ZpGZ6wd7jeEKKDLWzN6EfS9knzA2aZqlMzXJkaW53Sda3vUQF9YaaOUJX26NDYL70hxD3Qppk3ufcl0WPtrfKnoSJI9f3metW0QMPNlwzV9+fQgfingvhYD2TOVOd9G6WsYftbrQH/b6UiFrkSKqspmFs3JsVXbkkkRvz80NqAhIbogPN/P0WXPpu2f+eQRYk94LTsAJ2GvuooNJ48Q4miJLpdSotulGAJAwt4kCKX017UxqzNsOgGrkV29CN7brEOIzRQiaF2UKoHLM79T+SMV8Hg6OhHTl8Solfdre/CaGHlZ7txohcXE+GArQcwwxyFFn8zTHA9UZmokAUpkAarlaZvSjGh53g4Hb/WZWNQ+tZZ8h8ZAsp65fWyUGUBkjBwFKGaWCu9GfsMABmmObLIj8XUQQ4FlDFEup79xuOL2PZ2JquRgMGTpeeyLD88sVVyhDBelMlcsZdkzARyApqbvQDHz2pskUiRXZtgUOPfQnHEj0B8UjgVmYlVHycHfQZ+qcd/DydwlJi42+vGZ+U0LozCa/tdTOKs1igjxqvXujjZ7bcFOfa6XMT3+guaUB+BsoBI7eqr/KsO3U0CKWjGjmTL3d5hj6Ewvt2lj6jlk5huMCNMtpXjuLEKVev+rKoiD1H0iKkTP7959SyiXWcFTCfBfsVcmUjH1eRdh5HvWtsmv7HzI7WG30cIZ+Q2HyMTARciQAt9tTRMHuZ4dtpF38NHXJ3mvsKYhqg==
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
- [Low] selftests/mm: unchecked negative error returns in
  test_fork_ksm_statistic_count()
--

commit a4b057316a412b00cfd864404acbc77cd671159c
Author: Xu Xin (vivo) <xu.xin@linux.dev>

selftests/mm: verify ksm_zero_pages is not inherited on fork

This commit renames test_fork_ksm_merging_page_count() to
test_fork_ksm_statistic_count() and extends it to verify that neither
ksm_merging_pages nor ksm_zero_pages is inherited across fork().

> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/te=
sting/selftests/mm/ksm_functional_tests.c
> index c20982b0aff0e..321f8abc85f91 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -655,40 +655,57 @@ static void test_prot_none(void)
>  	munmap(map, size);
>  }
> =20
> -static void test_fork_ksm_merging_page_count(void)
> +static void test_fork_ksm_statistic_count(void)
>  {
>  	const unsigned int size =3D 2 * MiB;
>  	char *map;
> +	char *zero_map;
>  	pid_t child_pid;
>  	int status;
> =20
>  	ksft_print_msg("[RUN] %s\n", __func__);
> =20
> +	if (ksm_use_zero_pages() < 0) {
> +		ksft_test_result_skip("write \"/sys/kernel/mm/ksm/use_zero_pages\" fai=
led\n");
> +		return;
> +	}
> +
>  	map =3D mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, KSM_ME=
RGE_MADVISE);
>  	if (map =3D=3D MAP_FAILED)
>  		return;
> =20
> +	zero_map =3D mmap_and_merge_range(0x00, size, PROT_READ | PROT_WRITE, K=
SM_MERGE_MADVISE);
> +	if (zero_map =3D=3D MAP_FAILED)
> +		goto unmap;
> +
> +	if (!ksm_get_self_merging_pages() || !ksm_get_self_zero_pages()) {
> +		ksft_test_result_fail("KSM failed to merge pages before fork\n");
> +		goto unmap_zero;
> +	}
> +
>  	child_pid =3D fork();
>  	if (!child_pid) {
> -		exit(ksm_get_self_merging_pages());
> +		exit(!!(ksm_get_self_merging_pages() + ksm_get_self_zero_pages()));

[Severity: Low]
Can negative error returns from ksm_get_self_zero_pages() or
ksm_get_self_merging_pages() bypass the pre-fork check and corrupt the
child status check?

Both helpers return a negative error code on open() or pread() failure
(for example when /proc/self/ksm_stat is unavailable, which
test_unmerge_zero_pages() checks for with ksm_get_self_zero_pages() < 0
to skip the test).  Because a negative value is non-zero, testing with !
treats the error as a valid positive page count before fork(), and
summing the two signed values in the child either causes the test to fail
instead of skipping or allows a negative error return to cancel out an
equal positive page count.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120074230.4026=
9-1-xu.xin@linux.dev?part=3D3

