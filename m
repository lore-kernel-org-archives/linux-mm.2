Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3685606A339
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nM+tnc/f
Received: by kanga.kvack.org (Postfix)
	id 0B1626B05B8; Mon, 23 Nov 2026 11:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061C36B05B9; Mon, 23 Nov 2026 11:49:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D1F6B05BA; Mon, 23 Nov 2026 11:49:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD6936B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:49:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C316B4098A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:49:38 +0000 (UTC)
X-FDA: 85466970036.15.E65D87B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0AAD5C0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:49:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nM+tnc/f";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795452577;
	b=mOmyQLVyftRfWx5OBFb45aTRj7qRaxAsvCu3Gg8MxPO4+h1dIK5xhNLN6COXAmjVY+FXgI
	0YwPecJf4J463O4OlRpYDvPEHLdYqxv+lDEq9JtjMqDMu3OCVoprLhQeynpDxFYeRCbG2N
	W7qpnu6TVZi0WLpIRWcYa1BXDqDs1+g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795452577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCuAaCr6jzaRuI8obgyWyzu2xTHrj4+Ag4DYtGsL9PY=;
	b=ylLypRUad2GdbpZIEY9zuI7b+ydp3vpkOxwnzo3BBZHityBsBNTAbsv7PbmkgWucZ3W65g
	AR+Q5fto3UYLexIYBCk9KcC2V721bS5AkssAR85jbG7RZuAHSgbq+sJ1SY4r0BdSQrW+l+
	OD4u5nHVbc6fPgRuA7tybSqjpGoVKBM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nM+tnc/f";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A89A462399;
	Mon, 23 Nov 2026 16:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412381F000EF;
	Mon, 23 Nov 2026 16:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795452575;
	bh=YCuAaCr6jzaRuI8obgyWyzu2xTHrj4+Ag4DYtGsL9PY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nM+tnc/fHIRs9y+KjV7vr5gk3kHBo8bnP17v6GUQgagSxaqT+B+1uqLncybnbNlVV
	 d+Th6Iiz145NRZBrac2BjmUUgnypFhYE3w6Vc1q+3r6P76AQWTKzlPS6BpwskR66G9
	 uL3vDIO/at5gv/6kEH1ha6tj1frHX+WGX/+fe1lDJ1wK1ZrOlTo+IPige9fOrmngcL
	 Beq2BGzgmLJsME7agvgi8UsDwWcwzho+9IG3MreLtk+eMFdxnLeVBTYOcIJ/JNJ9OI
	 cTlffh01hfSNWiK5PMon8X5ceRhrRAQerejs6IS6rOACR/bt/RiyewStW5DT6mmtyr
	 ciXMVzTA6VmLw==
Message-ID: <16d172a9-bf5c-4a69-93d1-b48cd53b67b2@kernel.org>
Date: Mon, 23 Nov 2026 17:49:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] selftests/mm: verify ksm_zero_pages is not
 inherited on fork
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 donettom@linux.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20261123034136.209410-1-xu.xin@linux.dev>
 <20261123034548.237302-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123034548.237302-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 0AAD5C0005
X-Stat-Signature: m8nopy3doze4suf67oxobd4ez7ji9job
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795452576-349109
X-HE-Meta: U2FsdGVkX1/vC7haXbdphGN9n72O2pDUwzkSASrTZP1Qe07JDa62diUjwRq9qXdZNun1bjTraxo2siQgsF88NDnNL378BOHtFr+lM6UCdb0AWTKvS8Tsx6PAFpIuT9Aj28kRbQw6t91Z9ctZ685KI6vZHwAqLTqRLerDlKDP5kJyu8g9Ev2oynf5Jrn2izlsR8bjbf/XbCPKTsnTYYliDGFCK/Ea9mrZ2iWwrxpMFb/pzjWqMR6FTmOfGEw2bkcF4C+NKoEFU+hBD/xGwkS5+yY8U5DMzReMYFBycNlv/p9DceCxB1pHaCrVhkpEVUP2vCr1vDGy2Q4c5+imJ5gW8NnkqvfsrksbiwkFo2R7B48T8TzngUeY8/02k03LqBA/5N5KX48TXNqAkPmWH/tUFZ7f7hwCj9ZbuMysg8THUhRnHGun+X65sP4cj333XJQNC85Ylt3vbqw3XyiJBz4MllOqIjY6qCMv53HElZfWVAAFnvdkjJpVd9H1nPHHdH2/iS/VnRq1XawAt80iVYDt2t0tRi8+AE0iWIoOmNMccvOhLsgmgz32ua9bDCwCHYUZfAbsoFU1GpAOsrRFYIo6rmjfO8fCNJ4FYVdCbz2CTOktiSsjqHeFHkZHy/cKKv6ykU0q5JIXB3AyQFR9iJONJqAXK6hZgykWobVfSwB22sfGf1J4wEjQiYgCcao6lgiN5xOEZg0+SZMC0biFEco96+XaNzMxepHlCKSF1Pd9J1Q+/XOSZJ4qcnhn7frtsW8n4V+nxeQ/eH1cgqrJ5k9qdjt2/Y6Yvo37ZHng/pYwYb+CFOTMp7as0i897ngNo9KBqQv6SNXDmGljQZj9sgL7QiJ84KSnbhj67YCgEqvgncjV++k9p1R9NX//VD1f6iyJ61A3D9qSkp5HkBsdGpwF08c0xYDaCgRIoz+lDUleS1bM5jFAMMiUss2Dw014YKvB3KQpSnKk5WwVsnPYOt1
 nVqZjTv4
 7uUc24xoLOpZMq4oALbfGx8kIIgsMHnW2Mgyoxcpz7pbVQF1WWCxgyt/sUaZPlsTUk9/o4HXWY3/NgAKlNDcCaVtCdQ1r2wuIjdE6MYI+X4zzjT+U58NIc6VRV1nMZ+xRmsbz7PZg3N/Fw8XvI6ZmCmnED40gd+Ui7IxEhTJ96D2PRHJs2jXscRsHXRye/qlPflrY1HZ4Af/cEVSAOtUwE+1ZspimS+PsbgABxZDN1JxbCem8Ezuu3PxRgWoIeF/SWd+P7AjJcDDU7eHLA/qrpGwYSiaauFCnsuyTQpQGLqgiuKUyO7o6viDLPWxtUvzVapcGJuZP/0C5sviMMMHkNjJb3Fa9ZogK6XxNIkZxZogsCBxyqRlXIQF7WTGSxglYqm+Oc6NRPtMVoxV+e7mXcKsVZkTKri0rImenHQveBRi8TIFNCyjuG8dsn47vyvtHqA6HIsqdENZWU1VV2+48qOWE4a2HiYIVizppzFBU0F3Q/kW/QwFTsFjJrVy4/xmvFxw0UMd+U+8/nkqJcnjS2vnCbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 04:45, Xu Xin (vivo) wrote:
> Extend test_fork_ksm_merging_page_count() to enable use_zero_pages and
> merge zero pages alongside non-zero pages before fork(), verifying that>
neither ksm_merging_pages nor ksm_zero_pages is inherited by the child.
> 
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> ---
>  .../selftests/mm/ksm_functional_tests.c       | 44 +++++++++++++++----
>  1 file changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index b871d5656688..0e128c579d5c 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -655,45 +655,71 @@ static void test_prot_none(void)
>  	munmap(map, size);
>  }
>  
> -static void test_fork_ksm_merging_page_count(void)
> +static void test_fork_ksm_statistic_count(void)

"statistic_count" sounds odd. did you mean "statistics" or "counters". Below you
use "stats".

>  {
>  	const unsigned int size = 2 * MiB;
> +	long merging_pages, zero_pages;
>  	char *map;
> +	char *zero_map;

Can combine with previous line.

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
> +		ksft_test_result_skip("read KSM stats failed\n");

"reading"

> +		goto unmap_zero;
> +	}
> +
> +	if (!merging_pages || !zero_pages) {
> +		ksft_test_result_fail("KSM failed to merge pages before fork\n");
> +		goto unmap_zero;
> +	}
> +
>  	if (ksm_pause() < 0) {
>  		ksft_test_result_fail("Stop ksmd from running failed\n");
> -		goto unmap;
> +		goto unmap_zero;
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
> -		goto unmap;
> +		goto unmap_zero;
>  	}
>  
>  	if (waitpid(child_pid, &status, 0) < 0) {
>  		ksft_test_result_fail("waitpid() failed\n");
> -		goto unmap;
> +		goto unmap_zero;
>  	}
>  
>  	status = WEXITSTATUS(status);
>  	if (status) {
>  		ksft_test_result_fail("ksm_merging_page in child: %d\n", status);
> -		goto unmap;
> +		goto unmap_zero;
>  	}
>  
> -	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
> -
> +	ksft_test_result_pass("ksm_merging_pages and ksm_zero_pages are reset after fork\n");
> +unmap_zero:
> +	munmap(zero_map, size);
>  unmap:
>  	ksm_stop();
>  	munmap(map, size);

This ordering is odd.

Why stop in between?

Also, I suggest using a single label, like:

char *zero_map = MAP_FAILED, *map = MAP_FAILED;

...

if (zero_map != MAP_FAILED)
	munmap(zero_map, size);
if (map != MAP_FAILED)
	munmap(map, size);

-- 
Cheers,

David

