Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5473FCD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BEE66B0005; Fri, 12 Jun 2026 03:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F776B0088; Fri, 12 Jun 2026 03:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E3D6B008C; Fri, 12 Jun 2026 03:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00E4E6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:58:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DD881A076F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:58:31 +0000 (UTC)
X-FDA: 84870508422.01.056A8DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 04243100002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:58:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YtiyHqub;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781251110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWFHiurMTHuYqHLktC6SCqnT++u/8QxqggEqlCoSYYA=;
	b=Mtw1DObN6CF0e756FH/JzoOejOs34nk+4EnBo5jgOzNuCiBG+lonNyKNTd/ePSOheX3vmp
	d7WcNc2dEeOXfVH9sLg3v8lF+TZSTCuNngrR+q0Q/becAOea3rEuKgu00BL6dsE0SCINp9
	PipiY0KXMMJbfHgtK6ZODGVCkHYhiPs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YtiyHqub;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781251110;
	b=ddW5ALv2C7ZDY94eI85b7abH2A3q1VXTV7gZTGapl3uT4gcYEqmRr/7hJUV9Xdy71IVtbg
	Lv/Xtn4ZWE7guUtSiXMsugriei9IMlGjSllyMQZZIC0TrqAUOMIR0O5VxF/AvvC03+/jmJ
	M++MQHFjMtUf54tg+Zy+iMpfAnJN5yk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C9824171E;
	Fri, 12 Jun 2026 07:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2F71F000E9;
	Fri, 12 Jun 2026 07:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781251109;
	bh=hWFHiurMTHuYqHLktC6SCqnT++u/8QxqggEqlCoSYYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YtiyHqub1j1tf7e3p1QglJ+3DU3OjVCX4eFuAdDWGmLkPxq590WOqLCq60Y172ipQ
	 cGPSiw8ZPOwDBs/un0i7EDEy2vPldO/p6Q9gj6b1asnOrKV9nV1AtzJsGMMVdbKKtc
	 yurOZcj7lEayinzZlrLVSML2Hj6sh7PPvM6wj5+3wwtpzc84cKV7ojPtOfSQy5HUqn
	 /Ql1oYlggGpNEXvvGcYp1GJsjyAAvvx60jMgPNZc5R8sVxl7E5z5Iv2V6E9drjhTp8
	 yYsh/+Q92xs8Mqty4l0K17JgYr7jcmtCAyJq7rBcaVsHV5uV/vyvTSIww5WWthRpkU
	 Sv5MGgh/roXSQ==
Date: Fri, 12 Jun 2026 08:58:19 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Anthony Yznaga <anthony.yznaga@oracle.com>, 
	Mark Brown <broonie@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
Message-ID: <aiu39cOX1w9ICe_U@lucifer>
References: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: kk7r1njh5gdsox6iffxjjooygt7k3xob
X-Rspamd-Queue-Id: 04243100002
X-HE-Tag: 1781251109-748210
X-HE-Meta: U2FsdGVkX19R2SfmMvmfO5al6seenLxoUvs7pi+botyfH5Yy6CuC8iKuZqH7HnOb5KwVV7k3z4CLhfI20mY5lNRaroYkfMlVkHlNiNagSSnnD41/r6wRe3UvgBUwDxEMpTPRI/567h2FrfovWxGg4bxXztbhl+Gmb68DrMPd9NbOKMXznKXf3wfIIwYTdPR0jdol5wgTuRfBKOi6uIX4aOzrskc1+4mofFJTDALAVwRn6DKu5GmnG/3EdCE3AE2tmQ7bbbmOwkL5sQGGpABCdp/pde/iBfGeB+obFn5RT2NYMosQSPuftt7h+yFDNVtmSDI4E9xMiGJyYSKehquSXRfMTfyaGcSopTRY3zUj+oUYCujYjt17aCMGVRIrLo1gP3QZY2FDklaXaXFEdbm9BZg4SWCatwKO/KUrlpoGpjOpzppghzJ7RHH/oQukmgi5QOez4q/46og+CrJCY1GZ+W0o4/mzSmw2pwrh6uisH3d3nfF1eiexQTyiod6VQHbblWsCe/rcPPp8f5X7y0IpEiqFR07wEscKK142ETkNik7ZFDQwNRXiAKiu3EHF5j5HHqFZTa1Nuw/DHiBUC23uBCxWPiwG6cvTbH3b13CIVCkQ30Vv7O1qjuypbtDHt49AHsYijQCpjVxIfLsTY4UrEMT8QO76IlkvwKmcO59OpfW1Q7UXPa6VSUGYlMbUmWErbft9V2GtYh/RHSRe3aA4CWoAM6ZQH2djN+248tEoY8Ayv04qUn49sNm/6iQ1H7vMRfPBD6VMKSsGtpNxwcSJRbvVUcykwgdfZEbQ+nkhbN69kiFTp78jL1FNAIn4s31IuGK9ik9X6FHj4HBmG/a4ShhsE7Z3pCqD1M9pViN2XMzy9Z4xzGxyFQ9Co9hfpNZ21yg5RlXUBYOSSt0PfQG1m6w0bRT6cYcNedDvW+HxGudsTcdtI3J+QOxp/7BqlR/jYkPZcvP1BT+Ub6OxX7c
 Swbn027A
 NC6oLfcnl7s+ohWVjkHwO8JiNuVtQP+AIWhqs7n5eLr60K7RfIiNtqvmLA32cTX1kCEZxM5Al6Xs+Vqc0J3cDwINAM8Q+fdYl6JuwjN2ZfasTJNeL4DLW+wo7xO6TIHJWPgAh2LGlb7SATqXhPDRxAUHyhvCLz40BCuD33L55Wy6D98iJ8Q5VmVUGjnbFmfepssoD1LBy459SdaPxSPXm3TGSz4NAsC1f4NWufoVCoGUjemsXoIzNbtIUuuxm3yvkgoSHcYotnIWkcWlC85eeXE8zE0t+42+pVaex1nPUny8HF+nvk6iX26vVPUXSVAeYLY1+xkfzUUfmo4Ee0JX9reIGJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 12:01:55PM +0200, David Hildenbrand (Arm) wrote:
> The droppable test currently relies on creating memory pressure in a
> child process to trigger dropping the droppable pages.

Good lord.

>
> That not only takes a long time on some machines (allocating and filling
> all that memory), on large machines this will not work as we hardcode the
> area size to 134217728 bytes.

:)

>
> ... further, we rely on timeouts to detect that memory was not dropped,
> which is really suboptimal.

:))

>
> Instead, let's just use MADV_PAGEOUT on a 2 MiB region. MADV_PAGEOUT works
> with droppable memory even without swap.

Good idea.

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

On my box, before:

$ time ./droppable
TAP version 13
1..1
ok 1 MAP_DROPPABLE: PASS
./droppable  5.89s user 0.01s system 99% cpu 5.921 total

After:

$ time ./droppable
TAP version 13
1..1
ok 1 madvise(MADV_PAGEOUT) behavior
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
./droppable  0.00s user 0.00s system 87% cpu 0.001 total

That's um. That's quite a difference.

It's good that we're doing something about slower tests :)

>
> Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Big improvement, thanks :)

Feel free to add:

Tested-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

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

I guess regardless of page size this suffices as an arbitrary range over which
to check things work.

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
>  			}
> +			ksft_test_result_fail("madvise(MADV_PAGEOUT) error: %s\n", strerror(errno));
> +			exit(KSFT_FAIL);
>  		}
> +
> +		dropped = memchr(alloc, 'A', alloc_size) == NULL;
> +
> +		/*
> +		 * Speculative reference can temporarily prevent some
> +		 * pages from getting dropped. So sleep and retry.
> +		 *
> +		 * If a page is not droppable for 10s, something
> +		 * is seriously messed up and we want to fail.
> +		 */
> +		if (dropped)
> +			break;
> +		sleep(1);
>  	}
> -	kill(child, SIGTERM);
>
> -	ksft_test_result_pass("MAP_DROPPABLE: PASS\n");
> -	exit(KSFT_PASS);
> +	ksft_test_result(dropped, "madvise(MADV_PAGEOUT) behavior\n");
> +
> +	ksft_finished();
>  }
>
> ---
>
> base-commit: d401506a8ee8ac6bc4a7767c17da036e9434a4a3
>
> change-id: 20260611-droppable_test-3737bd791dfb
>
> --
>
> Cheers,
>
> David
>

Thanks, Lorenzo

