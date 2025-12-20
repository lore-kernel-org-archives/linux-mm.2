Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA9DE668BC
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 18:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE096B0088; Sat, 20 Dec 2025 13:58:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6960A6B0089; Sat, 20 Dec 2025 13:58:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4146B008A; Sat, 20 Dec 2025 13:58:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46C4B6B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 13:58:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA5158B121
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 18:58:15 +0000 (UTC)
X-FDA: 84240759750.07.89430F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2170780006
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 18:58:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="08/+s6Qc";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766257094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tr/IOM3p1pmqX7U/AQRmqIDJoiFSHxqGNOCFo88q19E=;
	b=fF3/iMPo/Z0HEyt5H7h6Zlt4hAGjirKOhbzU3Jn8J3MAkDyq3onc9VazuVI4zlOXj1CZtK
	aFGGdR6t9II9h2M5BhPLMFpAH9OxjZkEP0nF6HzNG4kcIHxPtkykVBhQO/a1WXU67ZMKWj
	Wi+oAB1jcSMmOivHFfxk/ZvhLKLoBQ4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="08/+s6Qc";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766257094; a=rsa-sha256;
	cv=none;
	b=rE6HbehyqpYlKN841Rl/Pg20Y4WYjWeNp8L+MLWGJ90i6/4jdJVWV6w50fQ1Kx/RNlPvya
	PcuEG2g3j5YZOeOVE6LX+JLclnRGTkGmCxxPZIcStHiW0GVEcHTXtUTwaL89a9yWy/R2V+
	R7z9OcPvK0FANcW1z0RLu8ADhFXVpNE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E583E436F1;
	Sat, 20 Dec 2025 18:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1B0C4CEF5;
	Sat, 20 Dec 2025 18:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766257092;
	bh=hNYk6WvWY18rpSMRepWtGWSsWj/pCn+KqXDaxv4oSAU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=08/+s6Qcq4HVi/H4W3MD2fJtmg7A9T0b0dpAdF6cTj998kxZ05Wn5oTdiktIwlApz
	 0EchykW636s6Lpq0OHCtMt0h4Wp27k4JHqqKiipg8mEBrTJZ4AeuriGkskTQYloVrd
	 Mo7nYwxl7wCG5hi5yvisMSx9xRVdadUMOkYeiQ0s=
Date: Sat, 20 Dec 2025 10:58:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, Waiman Long
 <longman@redhat.com>
Subject: Re: [PATCH 1/3] selftests/mm/write_to_hugetlbfs: parse -s with
 strtoull and use size_t
Message-Id: <20251220105811.3516167661cd696f464cc3b0@linux-foundation.org>
In-Reply-To: <20251220111645.2246009-2-liwang@redhat.com>
References: <20251220111645.2246009-1-liwang@redhat.com>
	<20251220111645.2246009-2-liwang@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2170780006
X-Stat-Signature: sgtmng5id94t4nyezro9bzqoznsj57zk
X-HE-Tag: 1766257093-827944
X-HE-Meta: U2FsdGVkX1/wdyHuorNhHKBwYS9QYKivArVU/8vdQ1HaX9zzQVVdzbshdV5A0yegEUfyXDJsdgPT8+vghUeE1h4/ZVxYU11TfJJ+1TqnznP5xHRzzIbyaIEmvTLpIzwJ3ZABFdaXGQ95/scRxS1IMK4S2nx5R6CuBfKt/s2Pj9kJCI7u73/YqttxPhU4N64Wi9V8Pc3gB2ty9Sp6hRwgZT46R6IJTHjchzEvHJeHgGatEuxl/vTdsQjcQEm3c55+R5U/1Zt8e3Rz8taxirzcI5tyTw8IRTI90guQGVO9rpfkxo5JKKgKozgDInMwh4f8F8EwxXegk7ueeWPYqX/Ia5zN0deuHQN7R4JmmB+aqxk1GmQDvNHsaz2KfUBudA27ELFAcKfrXxcNfEKpVbIQV/ho2MyzOrYZ8O+OTHI5K829JOuTUmqWS1GYU+7KfcWuWWvi7DfXm4SMhCslCO/GKgpX0uWBOPym/xGcNhQ/1vQ3vw7UGWDHGaHCbv/eO0gdKz+F29B7DJxoEGvwU5Gr0WK3Eqle/IpyYrdQWGQHCQq84xqlNzdTeQlVxDzitbUXuAOWj/mk1ky5c2vjXJE2IjbC2HLWBnbUVA77qEQUr0g5FevUM0SezOhkxM+rPpk4M/cpxHKofhfIqUZCFbdx3QHVegHAFW7IG/EwnN9TOjTly3psPxVhHAgAPDf/DYZlZMLL/Tws6qEs73Ss/IF/ovcIUXV8yGiLGGdbmGbanDzv62hS+WMpCOAP/hcos1klJR3V/NCzWfGx7yImqwxAYYfNgm7IZEGV56rBObs9rYrtJOD/cT3iYpDLMx5R0fO8ehSXqyPqU7ls3mO3Q601GTEEelHO3Z2CRjhul+Czwm4owhLlXfDr3CndVwKefhYEcGZYNzmmAtThq/F645ktN6URh95mvbH2gMOFmmny0XQkmaTuzryvwjGxySaNCKZ92KcoYA1dOOr0YyA2jV8
 VcbnUwXy
 mss5D8TNFzQiienneo2xlt83mf66PBYZXDdW0Rmtv/VNInpOkUy733CCWka+ox5KTxzhEvUqH6gMyD68KkeOBkLC5srJZJs1wxzWzhyN9eml5iHpN5V92o/xJuGKq4/0Qx/e4/jZ0Vya+DrVPzdadKLBETfkrLx+cmPVAzDXaAHQ0Xdfhl1Hrn6i3FCC1M9iDB6hgbTNhVx0CWr1/XdRnNV4YoszDXC400Y9LH7fg6zZWqGY0J5gB9HUlrRW79wNCshMr+BeX9EXObFyVU7+BhmslIX2EOAFEy78dpoS1VuHPA/Cj1klTYpajW/oFUZfuIk2n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Dec 2025 19:16:43 +0800 Li Wang <liwang@redhat.com> wrote:

> write_to_hugetlbfs currently parses the -s size argument with atoi()
> into an int. This silently accepts malformed input, cannot report overflow,
> and can truncate large sizes.
> 
> --- Error log ---
>  # uname -r
>  6.12.0-xxx.el10.aarch64+64k
> 
>  # ls /sys/kernel/mm/hugepages/hugepages-*
>  hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/
> 
>  #./charge_reserved_hugetlb.sh -cgroup-v2
>  # -----------------------------------------
>  ...
>  # nr hugepages = 10
>  # writing cgroup limit: 5368709120
>  # writing reseravation limit: 5368709120

Can we fix that typo while we're in there?  "reservation".

>  ...
>  # Writing to this path: /mnt/huge/test
>  # Writing this size: -1610612736        <--------
> 
> Switch size to size_t and parse -s using strtoull() with proper validation.
> Also print the size using %zu.
> 
> This makes the test utility more robust and avoids undefined/incorrect
> behavior with large or invalid -s values.
> 
> ...
>
> --- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
> +++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
> @@ -68,7 +68,7 @@ int main(int argc, char **argv)
>  	int key = 0;
>  	int *ptr = NULL;
>  	int c = 0;
> -	int size = 0;
> +	size_t size = 0;
>  	char path[256] = "";
>  	enum method method = MAX_METHOD;
>  	int want_sleep = 0, private = 0;
> @@ -86,7 +86,20 @@ int main(int argc, char **argv)
>  	while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
>  		switch (c) {
>  		case 's':
> -			size = atoi(optarg);
> +			errno = 0;
> +			char *end = NULL;
> +			unsigned long long tmp = strtoull(optarg, &end, 10);

Coding-style nits: we do accept c99-style definitions nowadays but I do
think our eyes prefer the less surprising "definitions come before
code" style.  So the above could be

			char *end = NULL;
			unsigned long long tmp = strtoull(optarg, &end, 10);

			errno = 0;

Also, `errno' belongs to libc.  It seems wrong to be altering it from
within our client code.

> +			if (errno || end == optarg || *end != '\0') {
> +				errno = EINVAL;
> +				perror("Invalid -s size");
> +				exit_usage();
> +			}
> +			if (tmp == 0) {
> +				errno = EINVAL;
> +				perror("size not found");
> +				exit_usage();
> +			}
> +			size = (size_t)tmp;
>  			break;

I'm not really clear on what problems we're trying to solve here, but
this all seems like a lot of fuss.  Can we just do

	if (sscanf(optarg, "%zu", &size) != 1)

?

>  		case 'p':
>  			strncpy(path, optarg, sizeof(path) - 1);
> @@ -131,7 +144,7 @@ int main(int argc, char **argv)
>  	}
>  
>  	if (size != 0) {
> -		printf("Writing this size: %d\n", size);
> +		printf("Writing this size: %zu\n", size);
>  	} else {
>  		errno = EINVAL;
>  		perror("size not found");


