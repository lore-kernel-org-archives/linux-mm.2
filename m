Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3FBCD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 01:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB04E6B0005; Thu, 11 Jun 2026 21:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60C76B0088; Thu, 11 Jun 2026 21:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F896B008C; Thu, 11 Jun 2026 21:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8576E6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:29:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BF4F1C3AB1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:29:22 +0000 (UTC)
X-FDA: 84869527764.27.698189B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 87831180006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:29:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=grxHbF0e;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781227760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0Ukr9E3YsTm9qpFFIq19VgZAopP2k8wxVggfBm4mvc=;
	b=ZwrQLtuanVJVoJ2ULX8A9cCydf1LGwKvaM7C3vtmKBaBRQNQQMsVPwf0ajnrTQb3IjIJTb
	BhCadB/iGb+Dj/ZHy/uw67bGanQrgjVrvkmTwgVc9wS5tGBIncWdE4uB4KS5yZQzYJOTXO
	LMBwlghtn0h6ZLLXCG0bKm6Gk/kuU3Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781227760;
	b=s9k+9Tx+TMf/UnJzq2gbu79nWJGcfDlE1tGSXgqRRvrHVtpF1dxByjD5bc1aVV+C1XOcpU
	Ag7DBPnhFFg9hKFv/KBT8H07BdGu6Leyk61jwo/gSo6DZ7trWclD0uo4olOTbPdjQPvA3E
	E37jv8MDFDEZO/N5y/Tv5w299MFezns=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=grxHbF0e;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06D69600AF;
	Fri, 12 Jun 2026 01:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234581F000E9;
	Fri, 12 Jun 2026 01:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781227759;
	bh=G0Ukr9E3YsTm9qpFFIq19VgZAopP2k8wxVggfBm4mvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grxHbF0eSRjcBvSvvQmbBkz3m8sdTwPRZG8B5goZX0ewQ2G2Q8wCybIAHRdV5WHs0
	 QvxraqcF7zbXJCLBtkqorc8UDpLcoyKG76J2qlFlubPc4yPEGn1M+62oP3lGXmF3ne
	 pd/4WKR04Cs2TgJtlb5teGqWpJhihYWhudzVSoo3skyVafgF6hT11chyO+SI4x1SxJ
	 CvFCOL+gTegi+2yON//+hsIqdc3VRFsyvCx7XsVZfK0ymSEmfqjEzqAzAjG7279T8G
	 zmbsUeSpR3ylJQ/Yk3dePGLnA1W167EopCngM3FIUM7TSPMIFWt3rnBI6Rcmiguu69
	 KB0XqoM/k6Ozg==
From: SeongJae Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
Date: Thu, 11 Jun 2026 18:29:10 -0700
Message-ID: <20260612012910.84424-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 87831180006
X-Rspam-User: 
X-Stat-Signature: gzc3h7qhiqe4336neitcjz8zrmm1xo5t
X-Rspamd-Server: rspam08
X-HE-Tag: 1781227760-846245
X-HE-Meta: U2FsdGVkX19vJRUl9OC6eQcj9w9P4j6+/2FgQRWnzi4TlnBnXuhdIOH5UYg6SqqH9J/L6Hlisk+ejdV/wmbu23ozzI+RJ26Dkg/WL11or2DQDfhC7e0i4CpS0Qkb3MbRhuo4CuD6Mc4imGVCcluC6WZeul2/Mm6DD3mLe4BrM95/frYglzhe4eV4EM88aPhh9hyMsRmErk2WxXiXkTu8bPxyHnGgTthRONQs7VAPn1GUnXNDH6iglkgUgK/Bxa5MesnYwBEGtvujzMuNKYih1Xx61CEl9ASoHLlGFU1XzggnNci+sKIeNSrJzWHBv+2n7Q6r1O6LGgxp1aa9FrggxBzeB7SrNO7KByqx7MZ5QcQON8Of9uWvd5bJguyea61f5hneBw7wjbQUC4dI/wOWByhXxHzIRDUOx/WCe9Xw5b6K2j+MB66n+VGIbtPcYF4EhbwMpCF77eGpzCsQQMopYpQPu9OA0Cn6N9RnQPo21o37ctvryzwU5GrXYFyIe+IW8F/cgaa50+/51VrSxutnim+wdv8VzTrsMMsC1hCD/4TMc4HzVUKO/n4qkBcXtAmBPOc8+TKYE53te5J7hNkDB5NxFfngYF08otiYtTh1JAXUTkZmGPuSpL4XyOBqNkMwyWWyI+g5b6J8E+B5EoATuVTNRAq5OGgzWAFRO5nJC4SQAhUX+h2YXY2Dk/8O05gziL1i+tHKUcvXDWWLZWjwlZW3GmKJGE25bB4XeWOXcXwDKmT24tVaU9HyYtGQcohqevB6oZW0jxh0xv7CTKETUrZ2mhICx9n0baNWL8EAv6gYZTMns9A9o0wBNPKkdbNqprNcwO79lxnQnM0L8ikeR2Y1v0H+uLm0nioyZJkm8TJTz5XPHWfsE5vrGKOb2lQTWxuBXU/WH+uTZk5VvFFofv2tGpa6FRmQ2ofg7dlX6FyGgdvVzgNYPiVMn0ieIe64RhiuhcOsODrfy9q+GAo
 AhARtW1s
 TEmcTuVADt7f5nLjnNyv2jsGTs6HW4vgfw8mwcYsrWg0X4rHjjSrOTZSXv2LxT9HPUAqgHJfxMsIcjjcqpCkQBkOAPvdo09qVV/473n/NUiNe8hHdo90PdYnS1DXbRqaF8D2RM8ab5Izfmuzb1ZqgZoDJjqKhFN1/znNM1x+L7J0nBiJJnKqoAInkrzg57/pVY0x/GI/msNNWMNSmunWZd0Wr4nexuXwXsHleDPaw3TzO7YnM7vICbyZb1vd6If1rjhg82fDup7Bh7sM/RscjvsI+4cM0djy64qut
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 12:01:55 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> The droppable test currently relies on creating memory pressure in a
> child process to trigger dropping the droppable pages.
> 
> That not only takes a long time on some machines (allocating and filling
> all that memory), on large machines this will not work as we hardcode the
> area size to 134217728 bytes.
> 
> ... further, we rely on timeouts to detect that memory was not dropped,
> which is really suboptimal.
> 
> Instead, let's just use MADV_PAGEOUT on a 2 MiB region. MADV_PAGEOUT works
> with droppable memory even without swap.
> 
> There is the low chance of MADV_PAGEOUT failing to drop a page because
> of speculative references. We'll wait 1s and retry 10 times to
> rule that unlikely case out as best as we can.
> 
> On a machine without swap:
> 
> 	$ ./droppable
> 	TAP version 13
> 	1..1
> 	ok 1 madvise(MADV_PAGEOUT) behavior
> 	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")

Because this is a fix for a test, I think not Cc-ing stable@ is ok.  Further,
arguably this is not a fix but an improvement?  No strong opinion, just
thinking loud.

> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  tools/testing/selftests/mm/droppable.c | 46 +++++++++++++++++++---------------
>  1 file changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/droppable.c b/tools/testing/selftests/mm/droppable.c
> index 30c8be37fcb9..57e1b6fc5569 100644
> --- a/tools/testing/selftests/mm/droppable.c
> +++ b/tools/testing/selftests/mm/droppable.c
> @@ -17,10 +17,10 @@
>  
>  int main(int argc, char *argv[])
>  {
> -	size_t alloc_size = 134217728;
> -	size_t page_size = getpagesize();
> +	const size_t alloc_size = 2 * 1024 * 1024;
> +	int retry_count = 10;
> +	bool dropped;
>  	void *alloc;
> -	pid_t child;
>  
>  	ksft_print_header();
>  	ksft_set_plan(1);
> @@ -35,26 +35,32 @@ int main(int argc, char *argv[])
>  		exit(KSFT_FAIL);
>  	}
>  	memset(alloc, 'A', alloc_size);
> -	for (size_t i = 0; i < alloc_size; i += page_size)
> -		assert(*(uint8_t *)(alloc + i));
> -
> -	child = fork();
> -	assert(child >= 0);
> -	if (!child) {
> -		for (;;)
> -			*(char *)malloc(page_size) = 'B';
> -	}
>  
> -	for (bool done = false; !done;) {
> -		for (size_t i = 0; i < alloc_size; i += page_size) {
> -			if (!*(uint8_t *)(alloc + i)) {
> -				done = true;
> -				break;
> +	while (retry_count--) {
> +		if (madvise(alloc, alloc_size, MADV_PAGEOUT)) {
> +			if (errno == EINVAL) {
> +				ksft_test_result_skip("madvise(MADV_PAGEOUT) not supported\n");
> +				exit(KSFT_SKIP);

This check is for a case that this test is running against an old kernel that
doesn't have MADV_PAGEOUT?

Assuming so, I was first thinking this check might not really needed, assuming
the test runner would pick the kselftest code from the running kernel's source
code.  But I recalled some people do get kselftest code from random place.  So
this check seems nice to me.

Just thinking loud.


Thanks,
SJ

[...]

