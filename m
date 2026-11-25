Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4F060A2600
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iN8YpcPF
Received: by kanga.kvack.org (Postfix)
	id BB55E6B09A7; Wed, 25 Nov 2026 05:34:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66EA6B09A9; Wed, 25 Nov 2026 05:34:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55916B09AA; Wed, 25 Nov 2026 05:34:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 715166B09A7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:34:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 186A11C499E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:34:33 +0000 (UTC)
X-FDA: 85473282426.09.8FD042D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 481EBC0008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:34:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iN8YpcPF;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795602871;
	b=kGlbwwlxxbgUIt80AOyu+P64AyuxSladJ4yxmIi5PLQtjyq7ds+geBt6EYDax9dYxvgFca
	PSgRFitqrY9gfGKrBE1GWElEdj5gJgV7rZI5/aOnYE4DetIl/sDGyofJV4LerkGngFmy6a
	N3Knf9zYczrot0Y++qj5z1CQOdPxUII=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795602871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdhya22vdyYIHSX3+fZBmoDZgCjZPvVDp6y5gPGmsak=;
	b=c0AqwQnyfr6nFCpzdY7HuOO59oou/sK/Ehxs9+bhg8SPCa/x+1ZbudhvvUrIEXn0ptgW8I
	hBq2ahh1LeS19rr2etrwsCVvIEbcmdCoKSyBfK2KOCbWaqBAqlZeN6hHmrosFcNNdu/WzH
	WMI0eVdqZmBOZeeYeqh2mdBvYeqEKfc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iN8YpcPF;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53A1F45D23;
	Wed, 25 Nov 2026 10:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267CF1F000ED;
	Wed, 25 Nov 2026 10:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795602870;
	bh=tdhya22vdyYIHSX3+fZBmoDZgCjZPvVDp6y5gPGmsak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iN8YpcPFgLq3Ri2n1gAGC2nZHiJrncVd6M197DiLdAr6J3kBkQHzdePhkrTwL80Km
	 v+aUnoO+CihNtpRc5OksZRDrS8ItGPFovfQAkctmKtJ2zdm8POxTPYt6lp635YOprP
	 i/CaMLVJCeIEjJyAXEIY7+T14JN9zgkvUn9sxo7g9RsaYmYQpAKo8gRoAwkr231egk
	 PS2shCOzZF4qHeID18481dK7TIoRJH52+2LxCOOdQp96IjFubsXBZfDK9+b9WcgakK
	 tC3pWrNE6ua3I/xS0lNteS6g+/LkZlbSFZq3dPJieIYPCaSaA9z43r370Z5ENQbvBf
	 z5pa6SJvPV7Jg==
Message-ID: <4d9417a1-eb75-4507-be86-a544437e3abd@kernel.org>
Date: Wed, 25 Nov 2026 11:34:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] selftests/mm: verify ksm_zero_pages is not
 inherited on fork
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 donettom@linux.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20261124130143.128411-1-xu.xin@linux.dev>
 <20261124130343.131760-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124130343.131760-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: affxouz1c7sdqpcpfdrj3qyyuy34jg6q
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 481EBC0008
X-HE-Tag: 1795602871-882606
X-HE-Meta: U2FsdGVkX1/Yge1WJM5uv3VBHQGoC9lzVnsHQGKbHEwDDma47Htv7ivEs78AW49g+7xucN5nkDSrSbwXXqeWWE3ELxEF+2UpGxhdOSwnu/XXfHSU7gkHuTHunXq2lcNMctJhElQ/WYe+rsMxy9+RdEt6AgPv7FF6Q0vr0cuwMxa0o2DfbXmR5CFbNOVyQjii5qVS9YX3SjHe4SkNK7HSqhJQu/ol8pWRDjU6lfZgivjwzGxwMIQ7IXiwTbq8wpRf1BwZZlyEQQkOPYcVY+5Y95tg7IalKdzi+SdhfiBR1Eepw4B8hAyBpXYaSdSW0lZ9AWavv/sssNCLNIsYbjjQ8WVwiut4qclpMFsWqXYMggF/9oy/a9udsKL4GKEOAfSw2ZOdClemUHzuIOF/8G0CLhPvzu79HrPZ6wzusIItFkrdYEYnxFW/MTGA6L+738DxUayJYp95rmSMlNmRjpN4n4SF1aVauKVwYts0RV2C707aKbZ78+02K4iS7SwcJ/OYoBBPDvENAz+dB9LzrszSd6IC8qqqXeUEfRYGy1zyhGYREoOAp4iUllqeqnxWCOe7FfJX+Swz/gS2ub/TyW7bQKBpy+GsLPxdoZ71j5I6gOK25BcqBrZysEGXqA4RV5UXg5YBjOtAB3vFyU87eIvZofhFFgXgKbwLw7wHeoK6SWaiHiCcTMsVvATQO85dY13VM+4GAiPGP1sD7dxaZxPUW4d4wotIfh9zqjzwfAn78Lo3YA3Ii4zSz2iwZGTgzCEgiNxza2uaNZ/e9A0Bs32h06v+OiHhLGP84m1D5Uns44sL5QpyWt6zcQC3jbmxq0eahnTaRMivSdzI977MDj6XdRJKnZpmibJbdldQumRn3KCappcMuf+f25HfQL5JbAY5DHb1oAAJsIwpXYxY1teMe5HA7xhlmtg40m3TomTXb0LXs8tY8kwCB+hgll6TMuu6hHWNrIS5A0YXugJv1bx
 wzCACcBp
 xtHoym098GAGNqlA1zg5sOuDLZbCcekEsttb1gRR0NpNY1V1Cq2Lw1BKnY0E6qfE35XLjEV7OmWDaeNEnLy1wplVS4e1vy37Bo6q1P8U3oIyTU4dcJw9IVvxzKlOPDlMqvvl9FxOI8xBv8Ob2+aRQcC94x1DgpXtfVfbLJjZh3AxxU806zcghgJ85Q4nu3OXT31EqYlklcDakcPkckZLrhP6wsJLO8MR0g3BqsYsMwvxWeA2vXSgdxXKJTcgUnFBh92UPmi8pmxhQHzuWrXMRqrZw5KVvAhBc9cS94wKtaa/FVgNtQ4ZVBM6V+Byg6lTSHFWyRpJojTzD/5MwD5QTPLTBaSLOISAOzsO8uyga5Be4BmJJ7GYpgbKo0HGHnyxyHSTMcaWQqgnTQ0o462H+vGiRzLcVYaLOxyd7LX3NVoUrLfMJHGV8W28VBGpc/gUd7r3iKvSovTBogqS4nW06At0xuCFA+ByTW/KniHSzAY6Hfjf1GQlsG/D1Zsyxb4QmS8OyF8cgXXAy+QQfCIkpP+eQQnyTGB9/S/Z8oNsQcgilzq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 14:03, Xu Xin (vivo) wrote:
> Extend test_fork_ksm_merging_page_count() to enable use_zero_pages and
> merge zero pages alongside non-zero pages before fork(), verifying that
> neither ksm_merging_pages nor ksm_zero_pages is inherited by the child.
> 
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> ---
> Changes in v4:
> - Rename test_fork_ksm_statistic_count() to test_fork_ksm_counters() (David)
> - Unify cleanup into a single label and munmap before ksm_stop() (David)
> - Fix phrasing in log messages ("Reading KSM counters failed", etc.)
> 
>  .../selftests/mm/ksm_functional_tests.c       | 44 +++++++++++++++----
>  1 file changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index b871d5656688..7aadce09e6c7 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -655,27 +655,51 @@ static void test_prot_none(void)
>  	munmap(map, size);
>  }
>  
> -static void test_fork_ksm_merging_page_count(void)
> +static void test_fork_ksm_counters(void)
>  {
> +	char *zero_map = MAP_FAILED, *map = MAP_FAILED;
>  	const unsigned int size = 2 * MiB;
> -	char *map;
> +	long merging_pages, zero_pages;
>  	pid_t child_pid;
>  	int status;
>  
>  	ksft_print_msg("[RUN] %s\n", __func__);
>  
> +	if (ksm_use_zero_pages() < 0) {
> +		ksft_test_result_skip("Enabling use_zero_pages failed\n");
> +		return;
> +	}
> +
>  	map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
>  	if (map == MAP_FAILED)
>  		return;
>  
> +	zero_map = mmap_and_merge_range(0x00, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
> +	if (zero_map == MAP_FAILED)
> +		goto unmap;
> +
> +	merging_pages = ksm_get_self_merging_pages();
> +	zero_pages = ksm_get_self_zero_pages();
> +	if (merging_pages < 0 || zero_pages < 0) {
> +		ksft_test_result_skip("Reading KSM counters failed\n");
> +		goto unmap;
> +	}
> +
> +	if (!merging_pages || !zero_pages) {
> +		ksft_test_result_fail("KSM failed to merge pages before fork\n");
> +		goto unmap;
> +	}
> +
>  	if (ksm_pause() < 0) {
> -		ksft_test_result_fail("Stop ksmd from running failed\n");
> +		ksft_test_result_fail("Stopping ksmd from running failed\n");
>  		goto unmap;
>  	}
>  
>  	child_pid = fork();
>  	if (!child_pid) {
> -		exit(!!ksm_get_self_merging_pages());
> +		merging_pages = ksm_get_self_merging_pages();
> +		zero_pages = ksm_get_self_zero_pages();
> +		exit(merging_pages != 0 || zero_pages != 0);
>  	} else if (child_pid < 0) {
>  		ksft_test_result_fail("fork() failed\n");
>  		goto unmap;
> @@ -688,15 +712,17 @@ static void test_fork_ksm_merging_page_count(void)
>  
>  	status = WEXITSTATUS(status);
>  	if (status) {
> -		ksft_test_result_fail("ksm_merging_page in child: %d\n", status);
> +		ksft_test_result_fail("KSM counters are not zero in child\n");
>  		goto unmap;
>  	}
>  
> -	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
> -
> +	ksft_test_result_pass("ksm_merging_pages and ksm_zero_pages are reset after fork\n");
>  unmap:
> +	if (zero_map != MAP_FAILED)
> +		munmap(zero_map, size);
> +	if (map != MAP_FAILED)
> +		munmap(map, size);

For that to work you have to initialize both to MAP_FAILED above.

With that

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

