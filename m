Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC0CC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8555D6B00D0; Tue,  4 Aug 2026 09:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 805B66B00D2; Tue,  4 Aug 2026 09:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5876B00D5; Tue,  4 Aug 2026 09:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9426B00D0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:42:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDD0B1A0119
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:15:41 +0000 (UTC)
X-FDA: 85063331682.03.76A2259
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 406DF4000A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:15:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fpUyrcce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785842140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcsWgIMR7LcCcHyHDDAzBXTohXszChMU8dODqlMuHUA=;
	b=UjdUcrx7OWHCxNwhHVl36mti5QkKFMoZMvGDx1DVZxux/B7XHcCaQ0210eT6evRnCXfF+/
	buHyy4B4taReiDIJMerrnEkevPM22l4jRY/b9FMwug4HBK8g2kJaeQc1GGDmGHDjnox3WH
	8/jQdd2KutvkX3EJmG0wTeDRvqOk+1M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fpUyrcce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785842140;
	b=4oqsrGy6C977Tlg/jYZigvDpVvB062Ai84WChjuq2m3bPqcW8qHl/nPN01sN1d1ExMdCJ7
	LNGIO1yLroMq5LrHvZtNjSqNzm7jKrXwHFvoWbGxRPiAJwTPGNrtMfvJsu0LEhSeJlqFh1
	qFZe91Ph4/Bzc3by8ZUlzjNlLLYF3/o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2E0160A59;
	Tue,  4 Aug 2026 11:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C8E1F000E9;
	Tue,  4 Aug 2026 11:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785842139;
	bh=vcsWgIMR7LcCcHyHDDAzBXTohXszChMU8dODqlMuHUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fpUyrccezzAi7StCsPWHMjl/bBFU/mYE9zeoFCdP2TQ7/90JDdlTQjDnRMmrexzZI
	 088Yco0PlOY2OU4VtNP7eiG4V1Tc+eTRgl19QTmRd1cdFVcwQ97W7zE4flW3Ziob5b
	 nAh8+RA/G3Eb/GFKglpnfjHDuzLEDj3kl8AuBRd3uBoRG1XMRs2/ZnpC+Fhu4PEf17
	 00eb7DUZgV2WUc60Thg5Qp8zQZD1uMXSMqPJHo3GscOjmZ8G8BmJrgZTj0BbP416Ck
	 Kp/H935KeBNUWfzR2uD4BBKJ8OhB2AL2ag2P454OcLhQjWY14mNSf1Q9L90f/v4sC2
	 JydcHyThErBGA==
Message-ID: <9dc3b457-65aa-40ba-99a1-7c703facbd32@kernel.org>
Date: Tue, 4 Aug 2026 13:15:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: read memory information without popen
To: Warren Xiong <warren.xiong@ugreen.com>, akpm@linux-foundation.org,
 shuah@kernel.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1785720615-5826-1-git-send-email-warren.xiong@ugreen.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <1785720615-5826-1-git-send-email-warren.xiong@ugreen.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e1mxkdgpp7qehsfiwadzh69m9j8u9afi
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 406DF4000A
X-Rspam-User: 
X-HE-Tag: 1785842140-177899
X-HE-Meta: U2FsdGVkX19Fbu9Z12Oln2YBt95tANmXQXw7Nd+oKEAgSuWfeasOLlx3IOyOJWAdg0ntZuLbDCL/8pVGaZySy6KtGzp/pggAFV1F3iQlhgID4E2wNpDhBxOfteV/rCRqoY1jWD8S85kirczuRGpWxdbOmUyTjT6vA7MlJiMM5w5fOiPqLZka+q8RfNQ/HmRu+cR7L7MEXWiVvnMDmmUOQK14YcCVlDyNS58uxwdxkBmEeKa5lq+EHtc5Bn+tlLpvA3o8uuJ2nXz55IAOPW/W9OKSmHOW436dBwkKRK1Qppn40B/y7vCSY5J+U5fQ1zX96/bVQ4rZl7KZCS88zatu5AnVd9rxG7fQFlQwl47MokwS4RYYnjxIPw4e00YtE7zieyXSEH+UHxNHHwRGo3vTiXC5EcsFSuVtGdKu1wNtd7CmSXYGYCzdfBbss8HlpaIqdG7COsmcRTGcLq6yHKDx/5OzCiVkTunL0fgVjKyrSzKgQaLXYFb/kStqiiD7NyOYi2xgJJQtUl1yXRNKFyPBKFJehmD6pXmJ9NWxC7grlO9oXtqIQqPi2uG1SzZbMUrRjOGQe1gtUrsIgtC9I2RhgFgoeEI6tbb09tf4g3hCRv+PxpHn+a3Qi4vrRIZb6hX+/8Cq6T5liSMxyIkeTfqpnhqXCl4/4fnmqBFnlXMyf2S3fB373UBfxyu3+TQ4tqVH4jgnKGoxn50Q8YV00+Ap/Z8g4f+BTOqXh26JIrBlm8bhJf5E2K27A80d8Nps4YL2STVN4V/8V2lLmbKaWfQs2P54JgbPXCp/BUQFkXXZjBEb9q2i1GsKaJ6y9+p1SD5qQCVuwOtHYk2kJcSwfhYZjkvF3MwAyA/cRD44QwULzxmNxmAtufMOwFk2xjdVM5LdXMt2P3YsCwMwZlY3Lex+uqk5fQE7z72JFAA2748vazVKa8pN6Mgfk5IM7C8ulyZ5jc9Ec3ZXOKvmSufPS0b
 tbysB2wS
 ZSnucQ8fWpUW59PrGlM2JV85Eygdk6i59sZnpWrNkYjoiIqDgysC+jjUWHf/Y9C/+a0PcJ2K3uyaFETVgblh5zhew5LWyRlCS4Qz5qlxLyB2M1jUN609fh96sxUTvhxBE1OZQEsStryWAkQoGxBlCNbkJcHYIqrHSStdvVx7buidhzNMUEp338j8n0oEGTC0zHI49EI2F237jwLzdS2bQaMnu+i31nKAXtV3frYZtT+g5JDHJ3tgcbQOCm2aOlHZ+O+lLJzZQoGHJOQXU2RVD/N2qz5LFGioo2VOOAgoP2BBdzJBciGzNUbFFnpOy1ob89XfxWfvMbAE0Q2CR9ciA05GqfN1PrJbUGwqs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 03:30, Warren Xiong wrote:
> read_memory_info() invokes two shell pipelines to obtain MemFree and
> Hugepagesize from /proc/meminfo. It does not check whether popen()
> returns NULL before passing the result to fgets(), and it does not call
> pclose() when fgets() fails.
> 
> Open /proc/meminfo directly and obtain both values in a single pass.
> This removes the unchecked NULL path, closes the file on all paths, and
> avoids dependencies on external commands.
> 
> The compaction test continues to pass after this change.
> 
> Signed-off-by: Warren Xiong <warren.xiong@ugreen.com>
> ---
>  tools/testing/selftests/mm/compaction_test.c | 43 +++++++++++++++++-----------
>  1 file changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
> index 5b58258..0df2000 100644
> --- a/tools/testing/selftests/mm/compaction_test.c
> +++ b/tools/testing/selftests/mm/compaction_test.c
> @@ -7,6 +7,7 @@
>   * allocated.
>   */
>  
> +#include <stdbool.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <sys/mman.h>
> @@ -29,30 +30,40 @@ struct map_list {
>  
>  int read_memory_info(unsigned long *memfree, unsigned long *hugepagesize)
>  {

Looks much better indeed.

> -	char  buffer[256] = {0};
> -	char *cmd = "cat /proc/meminfo | grep -i memfree | grep -o '[0-9]*'";
> -	FILE *cmdfile = popen(cmd, "r");
> +	char buffer[256];
> +	bool memfree_found = false;
> +	bool hugepagesize_found = false;
> +	FILE *file;
> +	int ret = -1;
>  
> -	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
> -		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
> +	file = fopen("/proc/meminfo", "r");
> +	if (!file) {
> +		ksft_print_msg("Failed to open /proc/meminfo: %s\n",
> +			       strerror(errno));
>  		return -1;
>  	}
>  
> -	pclose(cmdfile);
> +	while (fgets(buffer, sizeof(buffer), file)) {
> +		if (sscanf(buffer, "MemFree: %lu kB", memfree) == 1)
> +			memfree_found = true;
> +		else if (sscanf(buffer, "Hugepagesize: %lu kB",
> +				hugepagesize) == 1)
> +			hugepagesize_found = true;
Instead of these bools you could just have a hit-count.

Like the following on top:

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 0df2000f4a2b1..30d4ace7155ae 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -7,7 +7,6 @@
  * allocated.
  */

-#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
@@ -31,8 +30,7 @@ struct map_list {
 int read_memory_info(unsigned long *memfree, unsigned long *hugepagesize)
 {
        char buffer[256];
-       bool memfree_found = false;
-       bool hugepagesize_found = false;
+       int found = 0;
        FILE *file;
        int ret = -1;

@@ -43,24 +41,19 @@ int read_memory_info(unsigned long *memfree, unsigned long *hugepagesize)
                return -1;
        }

-       while (fgets(buffer, sizeof(buffer), file)) {
-               if (sscanf(buffer, "MemFree: %lu kB", memfree) == 1)
-                       memfree_found = true;
-               else if (sscanf(buffer, "Hugepagesize: %lu kB",
-                               hugepagesize) == 1)
-                       hugepagesize_found = true;
-
-               if (memfree_found && hugepagesize_found) {
-                       ret = 0;
-                       break;
-               }
+       while (fgets(buffer, sizeof(buffer), file) && found != 2) {
+               if (sscanf(buffer, "MemFree: %lu kB", memfree) == 1 ||
+                   sscanf(buffer, "Hugepagesize: %lu kB", hugepagesize) == 1)
+                       found++;
        }

        if (ferror(file))
                ksft_print_msg("Failed to read /proc/meminfo: %s\n",
                               strerror(errno));
-       else if (ret)
+       else if (found != 2)
                ksft_print_msg("Failed to parse /proc/meminfo\n");
+       else
+               ret = 0;

        fclose(file);
        return ret;


-- 
Cheers,

David

