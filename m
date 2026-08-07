Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61986C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 14:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE506B0093; Fri,  7 Aug 2026 10:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5DE6B0095; Fri,  7 Aug 2026 10:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB8E6B0096; Fri,  7 Aug 2026 10:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 479256B0093
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:35:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF08E40418
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:35:43 +0000 (UTC)
X-FDA: 85074722166.13.8830701
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 03FB84000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:35:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cO4jAMG2;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786113342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiconhQnpjAKJhJrHS8zmboQaF7/KkpqRkwt9AKBFKM=;
	b=BJK1Mivjvf9QRfRxHChwHLu/ulDj37ZOoSqbGWRgInDgBiOAOI3XfXP5Bb4FNk9DTQ3fjJ
	UjyTYW5l+nZPbz92iBsqDq0vjTlsvHgmqDA1a7VJLVYgnNDzv0brX8LUp2Ypk+YZOEogHs
	qmwyFF5EEKSjZSAtlTcHO8qCyzc38yI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786113342;
	b=XEHaoIIHINeiqSOq03pUFe3ZzHMCPrb0XxclV56k9uLeN6HkUS0gGs/Kxe+tMJmToov9K7
	tNdS5gEL8S3dMkRNE+JsFaaqWM5EoloemW6lylxnFsp3bzZ5i7U/nRtikT/QZd3l/pFXPV
	t9jSVS/FgXf/Tv0poPzvvpL1iLxsSBE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cO4jAMG2;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 592C443CA3;
	Fri,  7 Aug 2026 14:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D57D1F000E9;
	Fri,  7 Aug 2026 14:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786113341;
	bh=SiconhQnpjAKJhJrHS8zmboQaF7/KkpqRkwt9AKBFKM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cO4jAMG2t8RFD2STp4VqH1DZPCjpAKkI8Gg14qCPV+zmAg7Lp4iQFqUtzZ6Rwx2xW
	 0M9ndGPpEqZn7pXzAMB8z05/Ut+FExhm+qvakakp8xYj7MKIc6Q9E8LjMJIR3vfwB2
	 UWQ3BuGGqR4exDAv8KYvtdEmcHYO4AFceSebdUDd0qTR92ymdz+ikdsbE6YzS9Lp0U
	 ObbuXYiuxwEQMSrnEAdsuIS/ottd01HD0dFnbegyGBuPbyDqoxPPiu4juip75w+ehu
	 CDgPk06nKRdLsWiylE/TGg6kJ/gNcoscPbmQ9nwTU0/1zhlk9WavdikrZc6sosLfzz
	 FVskXy/SI8KTg==
Message-ID: <43b5db93-1c1b-436e-a8fa-d89582e31894@kernel.org>
Date: Fri, 7 Aug 2026 16:35:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix read_file() return value check
To: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
References: <20260807013555.36525-1-hongfu.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260807013555.36525-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03FB84000A
X-Rspam-User: 
X-Stat-Signature: 3rziopub68uycc3itsria419e7whmneg
X-HE-Tag: 1786113341-346068
X-HE-Meta: U2FsdGVkX1+pSf1QJyUPL0Enc7etlV5hkt3XB3QR1yqH2LMxGQ13yRKxAN2qfRkDf8A8XUdX/bprU9o95GK3Sf3JPkUpPynDuJX+EvmLRFkOOxmz9TzlHZ2AvKF+Xdvn7ATh1xi8jyHwd88g43TS0Ehr7hmPyWZCnV9GELAShNd/7BFMYKlybidx3jBte1ehG001RL+GwfwO2jRl6bSGmdvoo4ORkGTfcKFpqTreon5m0XpPLJH2wGR5gDCZ066JNu8Ws0KCDrwf2Pfc2/S134Jb1bWqRsyJq4ZNJ8EIGpxfH/MZiSK6jpThCmjle6S5EtLtJyos8gqohTChnKzwkBUE2PBdnuRUIjd3wE/nljRDcMLZX0X+qt6/etBoceZRPlAcJiDsqg63QUGbWrR4vicqgYipI1qOyPhXVJCshgfddsxuVkX2uhRGq9uVFzGG7YvvD8bW7fMr1GrPvJFfo2akVGGTKVdiVGX2zsdugLXbkao5/n9xBbengkMwW9sq6CaLC6k5xMjENppKQhPfJyRSEj+pphmNTERiv7E7AIH8g1s23WzEybwZBL83pH/dQLjq2aWZVbweby94jPFuvuqjcV6mazu/aCPnYtHnun7w/QKY4CuhKC18u8trIt0ZTHb20pIzXRqU9uqS1uXiJ3ompC2shN+37ep5ZoDBscadZ2MqfR//dh7x8m2qcpaWqTdO/KWA01W23m3YOCFlDbUpetlY+uftKM/kIVi18g+hFTuVKz3uA1qu0ZCvCun9cS91qcv3ydU8Y2QTQZuwvjxQErQ8S3+R7b+dl0YDUQyTkXup2V0WZr9+X3agixqlUPSSbAa2LIpWFbb+i7dv0bN7wsQ0we5DYBoa69H7c/exItWOm54RTRPJYi5BuPasEsQ4n7VuUkZ59QwcmKbZ/9wZd/lzG9t/1MFMjBCJw0Wo41YdVwNOGYKrFomdiW+N2FgKc+ysTZz6iRYUwWa
 brvyfdab
 nEx76/p3/633fXCkjy0yOV964LSNdCzCEzB/5eLnvWdD5Lo8HQl1XBvjnGoaNalyPmLz4RSsGz7IxVCYH6h+1ogdoh1S4cdoY2R/utA76ex4NjMG7rMJMM2u6o8eK7ZTsPlOq6Efs0yeFdWgbVCPzr9xZZv1fUtX0dOrwH/VGN8EsP9UoPxXdypT8LxwNCI0ct6CPSTnuBhG88pvTygaYZ1fpgC8RTiyyXTncxQLSKx69u9MPBcNI8p/9d02wB5P8opVSTeYBc3g0m6TPcGDYwo5n23GYBUOMspJ4vuudHJNQaSVpD6PRF2avPlyKBGewpzl6sfPntbrrBLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 03:35, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> read_file() returns 0 on open/read failures and never returns negative
> values. Existing < 0 error checks never trigger, so read failures are
> silently ignored. Check for zero return to detect read_file() failures.
> 
> Also fix misleading error message in get_finfo(). The error string
> incorrectly references read_num when reading uevent files.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 4 ++--
>  tools/testing/selftests/mm/vm_util.c    | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 10e8dedcb087..506310d4b4d5 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -138,8 +138,8 @@ static void get_finfo(const char *dir)
>  		     major(path_stat.st_dev), minor(path_stat.st_dev))
>  	    >= sizeof(path))
>  		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
> -	if (read_file(path, buf, sizeof(buf)) < 0)
> -		ksft_exit_fail_perror("read_file(read_num)");
> +	if (!read_file(path, buf, sizeof(buf)))
> +		ksft_exit_fail_perror("read_file(uevent)");
>  	if (strstr(buf, "DEVTYPE=disk")) {
>  		/* Found it */
>  		if (snprintf(finfo.dev_queue_read_ahead_path,
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index ef1ea11981a7..2697d50d07f4 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -755,7 +755,7 @@ unsigned long read_num(const char *path)
>  {
>  	char buf[21];
>  
> -	if (read_file(path, buf, sizeof(buf)) < 0)
> +	if (!read_file(path, buf, sizeof(buf)))
>  		ksft_exit_fail_perror("read_file()");
>  
>  	return strtoul(buf, NULL, 10);


Yeah, that looks correct. Do we have Fixes: tags?

I think it was already wrong in read_num() in


commit e0c13f9761df8f97cf5e81495d12ecbc4075684a
Author: Kiryl Shutsemau <kas@kernel.org>
Date:   Wed Jun 3 16:00:06 2020 -0700

    khugepaged: add self test


where we had

+       ret = read_file(path, buf, sizeof(buf));
+       if (ret < 0) {
+               perror("read_file(read_num)");
+               exit(EXIT_FAILURE);
+       }


So likely

Fixes: e0c13f9761df ("khugepaged: add self test")

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

