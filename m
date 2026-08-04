Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 250C1C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE63C6B0110; Tue,  4 Aug 2026 10:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC54B6B0111; Tue,  4 Aug 2026 10:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3806B0111; Tue,  4 Aug 2026 10:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E17B6B010E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:47:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A90C120148
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:21:43 +0000 (UTC)
X-FDA: 85063498086.30.239EF08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 68D021C000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:21:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NktLoOFf;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785846101;
	b=CEcglhLymw5IICqdhPeMAK8abOqOCpmWd0qo8XAwDYbrmXJWtQ2CG5+UMrU+/58LLrS00P
	qQDHyVM4vYLLxcj/HbootUCLkaifXQXB63X6ViuTUjd8hwJFUNBba0oDPLDTWl2j48ej+q
	O2ZBp/bEejy848ovXh/jUQJ2fa1LvJ0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NktLoOFf;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785846101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efM8AzxF8bqG1DJUbVqdvBnISyKCHBsMBtlf3nlIbeI=;
	b=Lt1DsL3oBTZ519Pjckaaa6Mn/fO3FQZOjVlRBNrZys1WRfwvYFLIXU9NyMinXgBPFiP69w
	0h0FnW64ZZJieNfHqH/BY4ov10rcs9HseLhnMTRgyTS6g4yym9iRxIoN9u3oZArHt2sM3i
	edht/cEqJ8TE1rTsxaxkTtCLyIMmEfg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E007260A59;
	Tue,  4 Aug 2026 12:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02071F00A3A;
	Tue,  4 Aug 2026 12:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785846100;
	bh=efM8AzxF8bqG1DJUbVqdvBnISyKCHBsMBtlf3nlIbeI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NktLoOFfZHRqade73gsXm7Fzc5b4FzLM4PGUbDUVlnpQDQaw8N/f5k913OBECAMbI
	 +HrQpHcH7kDUKErVLUGaVf8BOsenwxAhTCnJ80Zi5Y7vJ6KHLTaXYeUYtg7wj5C5QO
	 GCXA1aFt9zsiU7VML2j8AYS+RfVV1MGt1/1WdSDJlK4LpEcPWMi/wERqDgID67QlVy
	 L8Hfby7sAl47LHuEj/hmDV/a7JU6j+aAxepgJJyJy5TTrSIGSke3tTYNcRIXOLYAnJ
	 gL/KHnJ1olazm74vu3gaqMYB77bCAyXV3Ykv8NmW1cOye60bJmQTydS7rzQmMC6BYV
	 s/W9MW/K/Rx1A==
Message-ID: <6193876b-adcf-4cc5-9101-67454a359053@kernel.org>
Date: Tue, 4 Aug 2026 14:21:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: read memory information without popen
To: Warren Xiong <warren.xiong@ugreen.com>, akpm@linux-foundation.org,
 shuah@kernel.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1785720615-5826-1-git-send-email-warren.xiong@ugreen.com>
 <1785845818-3131-1-git-send-email-warren.xiong@ugreen.com>
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
In-Reply-To: <1785845818-3131-1-git-send-email-warren.xiong@ugreen.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68D021C000E
X-Stat-Signature: 44x3wm74arpx4wbsn1sq5mdmp11xyhii
X-Rspam-User: 
X-HE-Tag: 1785846101-20606
X-HE-Meta: U2FsdGVkX1+INrWdwG5AMQ4DsF+CuVOAkniyfuFTZb1JIvV/gQVqWch01bTPGPAB0k0FtdROUHUvJa6Q7p0iJCCDCiiOwmVS8TT/rIA+8tXPD7NETaM0AhlZVKqEa9F0j40wJqhnFp6SD/isCNaU8T3IUHl2mWnQ/jXnlpm0OGSVOjqsZ7Tjc0JhpsR0GtmgNc2GcqmkWKqdXDd9GR0uwv3L4eDVee5uhNbmEE2K8tQHCekJWyD9v8RiychRp9atpl8vDQ/vmn2gRVNYyaTu59YstHZzloJmp0Gd+Qby5uphTeCkl51fTYkq+nJezFNQfN/6CDfwglN/90Lq9Tr0/iwwUAJf72MZRb51jsEBvNk4FStzatvWXXvJ9v5/ze1nxegEOfbxjJIMSYli/RXfhYfEGkOoyxIi8BzlK2Fd/7yXl2D+Y30YJ9ET0V5lkqljvahCtzFti8h0L4PQMC0zygpKRdS1LVMB01Ri1HAocYBKk+/qmk08gdpuoZYTovWWIXq1hMhIdM/eht5RnGt6dO61stQbz2LcBFlccACsz/O2UmVbQFmv4t/d4UVldUCGY/HrXbzAJSXCQuj918uhVoVEQbcFJcHufUgNLG8HgXSjlzcFo/yOHeVxjvS9Sm5nTzNm5zgZXAJwe+aHx0ZFnaUhXrbllDddnccUiXayuJpFCqc6Ce5glomD7SLTx3LSB4dbL0emhVyBgqTJE9F4AxDGVngh0pCSIV9KAZ1HvBkm4BDrRqdCwUmXnDkouKo8OOhzujKMTkU0z+XtcsHiCQKN/FUnz1GU6HDDq4mDJ8CFmV0GPh/yUPfwnxDpFY2fdWpHcljTiF5Aj5JC/IXkKPxinNLBho7OblBliTq0OsdNpvYviYu3K2AmFbxjl4Tu95rZ601XLZ4fRKau5Rj7NTSolP5Ct2VuFf846A3bcTa+Ka7Gjg7d+vmYoQLJjbh01faXYKblDqdMGn3ln8U
 TrM0+n9u
 NYVGKSxjsHwmx2nNcD3HdXBLvU3b3emrI07azSeTOoJwoRwEzMjvEnMEJG55meEmWPQwc8XPFzWhQQi/wmMyAT6v5S92+bMbAM0umHzls/bYXq2LnVAZl4Cwg0G6EQXIv8DODwohE4dslJRMwOrQbJwCFl5vfItb+bo06wMHBNKhO+4wbB8jcruVpPCOFwD/sGPhO+aJJECp60/ILEKAx5WMVFKkPpPJ5xYKR+b5n8MVSOZaMZ7qD1an//5n2B0TjDKLwR9E27ttJ/1/HOeoZcHnL6FLkMKd9O1VGhH9T3ibntwm2qaa6izdxfFYyigYWw0T5BI5FIr//NgxPvks8kZWmUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 14:16, Warren Xiong wrote:
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
> Changes in v2:
> - Replace the two boolean flags with a hit counter, as suggested by
>   David Hildenbrand.
> 
> v1: https://lore.kernel.org/1785720615-5826-1-git-send-email-warren.xiong@ugreen.com/
> 
>  tools/testing/selftests/mm/compaction_test.c | 38 +++++++++++++++-------------
>  1 file changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
> index 5b58258..30d4ace 100644
> --- a/tools/testing/selftests/mm/compaction_test.c
> +++ b/tools/testing/selftests/mm/compaction_test.c
> @@ -29,30 +29,34 @@ struct map_list {
>  
>  int read_memory_info(unsigned long *memfree, unsigned long *hugepagesize)
>  {
> -	char  buffer[256] = {0};
> -	char *cmd = "cat /proc/meminfo | grep -i memfree | grep -o '[0-9]*'";
> -	FILE *cmdfile = popen(cmd, "r");
> +	char buffer[256];
> +	int found = 0;
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
> -
> -	*memfree = atoll(buffer);
> -	cmd = "cat /proc/meminfo | grep -i hugepagesize | grep -o '[0-9]*'";
> -	cmdfile = popen(cmd, "r");
> -
> -	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
> -		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
> -		return -1;
> +	while (fgets(buffer, sizeof(buffer), file) && found != 2) {
> +		if (sscanf(buffer, "MemFree: %lu kB", memfree) == 1 ||
> +		    sscanf(buffer, "Hugepagesize: %lu kB", hugepagesize) == 1)
> +			found++;

Just as information: when proposing that I was assuming that we would never ever
have two times the same entry in /proc/meminfo, which i think we can reasonably
assume.

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

