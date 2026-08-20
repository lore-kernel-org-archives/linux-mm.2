Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC939C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 06:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7436B0095; Thu, 20 Aug 2026 02:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E317E6B0098; Thu, 20 Aug 2026 02:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9036B009B; Thu, 20 Aug 2026 02:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A73C56B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:02:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3794E402C5
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:02:02 +0000 (UTC)
X-FDA: 85120602084.02.2367D33
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0057D1A0006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:01:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787205720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i+g6fW3j6hq4eea4VW+GoTVSm3SplCQIqIMSDV3krC4=;
	b=BpCgQubZZ5141YOB7ft3kM2dIxK9Mjir/jDb2Rp7zG6bePROixf3Xp/irP7MqsSekHT5MZ
	j02kFxvTvw4LKLm4ulSwhLZpw1LR6/CCD7whmXESfDh+qqpkM4N4i2PHgnu523BYvzwpjj
	I7yFvYs6Wu5MW3jiO/olxorr2a06S2I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787205720;
	b=mRhKW8Sq7JvANRZa+7bhC8IXwjxVQxfkaKli7Dcva3bPtAbgReye4nggfna+HM6u6kMEhJ
	RQKQE+UraIx/fyakuN8oDNQ9qd0MHLReTY6ynvGCaylLtdrmBmvW74UhrfRRhBvXQv+Vji
	6kovFDr9GhVRR+iULjvChUXnFH8hBo4=
X-UUID: 9f46d1de9c5c11f19a56ed5b684f684d-20260820
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NAME, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED
	DN_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:3c416136-d582-41b2-8861-65b0b7d07bf6,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:3c416136-d582-41b2-8861-65b0b7d07bf6,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:7d505ecffc03ec866331e12b37300df3,BulkI
	D:2608180044547525HKYB,BulkQuantity:1,SF:17|19|38|64|66|78|80|81|82|83|102
	|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9f46d1de9c5c11f19a56ed5b684f684d-20260820
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1706420389; Thu, 20 Aug 2026 14:01:44 +0800
Message-ID: <a6d9ce4b-3880-48af-8fa6-dfa7129c0464@kylinos.cn>
Date: Thu, 20 Aug 2026 14:01:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, linux-mm@kvack.org, shuah@kernel.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] selftests/mm: emit TAP header and use TAP skip in
 mremap_test
To: Usama Anjum <usama.anjum@arm.com>, akpm@linux-foundation.org,
 rppt@kernel.org, sarthak.sharma@arm.com
References: <20260815080716.3596514-1-husong@kylinos.cn>
 <20260815080716.3596514-3-husong@kylinos.cn>
 <1787017182354310.22.seg@mailgw.kylinos.cn>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <1787017182354310.22.seg@mailgw.kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8xyad8qr5nnojhiz6hhcznom59tane8w
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0057D1A0006
X-HE-Tag: 1787205717-746973
X-HE-Meta: U2FsdGVkX18cT7fo0W3Ww7QYp1vfLblY8WjkGVe3VWiY5fSRCousGtLSdUfs3WCG7ojA7MBy8DlVXBb8RtEftX9YgslsNA7JPnxIuETHuki8l8jr/TyOFbWyu3bjd+mdS6+SERWmW0V4rACO+XxmLkvyi12ZdBUDTuoovHbzCynRFubvoAp1JJWitJgiBDD5AsWgKNZkZrEd1UnBwEotIur4xw7Ut7DyctBpeTYavVKZY9rhUib8HajPaoNmLO2R5y001+EwZvjoqBJ6BKVuZFFfneYLSOIJRQKpkMVN7r4mLUas2V+seXh6NALzD3A/k5rlEg+gNobwtALlC5SSFoG8sMkTBiUAcbYxXn3xzz03a0QijXanh/qbDTi+52fDebAG7ZQOHWqXhv1yrX3yzZVicwJl9bEQv+dGiTMYQ70R/u3Oqe+AshmDkBsK+cE+ZwRl3a2eWoTxkKNdjos8jhBhjb1WNcFHjIHtsXPaqgd6f9R8YCshS2mH2rSDMhutWw+s4cpDbT+0pZ2c5to+iwmLko5AxX6hQUiUec+wTwkY8gumhBQoI4zjt16f0HwtxtQHIoMPJ84ecIRyc2on+wRSuNasKBDCiJD7TLqQu63JWu8QPSys24h5pxLDvYZcOfF/wAUGeBW3l6DtAtunReu4d9YojPRTE0MHEAN2Iep//hFYi8DMZ/vK7cAzIXiSH8quWCHUwQsuKGfk8Yn1uK+qMdNAdU54e8uNtfkCdruWQXQc9bk8uOIuM2CZrcvqeJa+eLfx+migqOYiCIuwrFVu1OnJHb2IVuTadApWDutzdFXNrvtAikCxBZeNSSdPBEIyxK/Kxin2atp/PWk8Q8RJ1i8y8jH4KPC9vAZtX1oWuFZcnV9SNeLSWV0IgzEIs+/nCZfBIbuPi68z3dSQZH/vSfRSqvbl5pZ1rMgcfLBfCpXB8Ilv5zQ8a1VBvgpGr83rDFBa61TsFFGCsi2
 8CoXXZQm
 lkTvBpobsyhCSXajZGMCMIrTjdfREnwUap6Y6eUVyPfYER59NOplT281iSmpQddFyAnOsjHn0e2xunVSBmAfiLDqGftt2idrET45kzxj/g4sGxNBfNAiHs7L+KAUp7zqx4v3aDpUFUkEBzaJ87/d48kdS4YUKpNv+JY0AJarnXQAsKCuRLYoL76IzceuIDM2xMLgr8R/YkDp51JNFePJ3HvaGkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Usama

在 2026/8/17 23:44, Usama Anjum 写道:
> On 15/08/2026 9:07 am, Song Hu wrote:
>> mremap_test calls ksft_set_plan() without ksft_print_header(), and its
>> get_mmap_min_addr() skip path uses a bare exit(KSFT_SKIP) that prints no
>> TAP line, so its output is not valid KTAP.  Add the header and switch
>> the skip to ksft_exit_skip().
>>
>> Also fix two more KTAP compliance issues spotted in review:
>>
>> - get_mmap_min_addr() calls strerror(errno) after fclose(), which may
>>   clobber errno; save errno before fclose() instead.
>>
>> - Some ksft_*() messages embed "\n\t", so the text after each embedded
>>   newline is printed without the "# " prefix.  Split those into separate
>>   messages.
>>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
>>  tools/testing/selftests/mm/mremap_test.c | 41 +++++++++++++-----------
>>  1 file changed, 23 insertions(+), 18 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
>> index 131d9d6db867..28f151daabe4 100644
>> --- a/tools/testing/selftests/mm/mremap_test.c
>> +++ b/tools/testing/selftests/mm/mremap_test.c
>> @@ -111,18 +111,17 @@ static unsigned long long get_mmap_min_addr(void)
>>  		return addr;
>>  
>>  	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
>> -	if (fp == NULL) {
>> -		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
>> -			strerror(errno));
>> -		exit(KSFT_SKIP);
>> -	}
>> +	if (!fp)
>> +		ksft_exit_skip("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
>> +			       strerror(errno));
> 
> The skip conditions are usually at the start of the test before we set
> the total number planned tests. If skip like this happens later, it
> still counts as failure. I found the following corresponding output
> with this patch:
> 
> TAP version 13
> # Test configs:
> # threshold_mb=4
> # pattern_seed=1786980558
> 1..26
> ok 1 # SKIP Failed to read /proc/sys/vm/mmap_min_addr: Success
> # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> # Planned tests != run tests (26 != 1)
> # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
> MREMAP_FORCED_SKIP_RC=4
> ### MREMAP FORCED READ-SKIP END
> 

Right, get_mmap_min_addr() is first reached from deep inside
run_mremap_test_case(), long after the plan is set.  v3 caches
mmap_min_addr in main(), right after ksft_print_header() and before
ksft_set_plan(), so the skip paths now run before the plan.  Reproducing
your scenario by injecting a read failure on the sysctl (LD_PRELOAD
fopen shim handing the test /dev/null for it):

	TAP version 13
	1..0 # SKIP Failed to read /proc/sys/vm/mmap_min_addr: Success

Thanks,
Song

>>  
>>  	n_matched = fscanf(fp, "%llu", &addr);
>>  	if (n_matched != 1) {
>> -		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
>> -			strerror(errno));
>> +		int err = errno;
>> +
>>  		fclose(fp);
>> -		exit(KSFT_SKIP);
>> +		ksft_exit_skip("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
>> +			       strerror(err));
>>  	}
>>  
>>  	fclose(fp);
>> @@ -1164,10 +1163,11 @@ static void run_mremap_test_case(struct test test_case, int *failures,
>>  					    rand_addr);
>>  
>>  	if (remap_time < 0) {
>> -		if (test_case.expect_failure)
>> -			ksft_test_result_xfail("%s\n\tExpected mremap failure\n",
>> -					      test_case.name);
>> -		else {
>> +		if (test_case.expect_failure) {
>> +			ksft_print_msg("%s: expected mremap failure\n",
>> +				       test_case.name);
>> +			ksft_test_result_xfail("%s\n", test_case.name);
>> +		} else {
>>  			ksft_test_result_fail("%s\n", test_case.name);
>>  			*failures += 1;
>>  		}
>> @@ -1177,11 +1177,13 @@ static void run_mremap_test_case(struct test test_case, int *failures,
>>  		 * was faulted in.
>>  		 */
>>  		if (threshold_mb == VALIDATION_NO_THRESHOLD ||
>> -		    test_case.config.region_size <= threshold_mb * _1MB)
>> -			ksft_test_result_pass("%s\n\tmremap time: %12lldns\n",
>> -					      test_case.name, remap_time);
>> -		else
>> +		    test_case.config.region_size <= threshold_mb * _1MB) {
>> +			ksft_print_msg("%s: mremap time: %12lldns\n",
>> +				       test_case.name, remap_time);
>>  			ksft_test_result_pass("%s\n", test_case.name);
>> +		} else {
>> +			ksft_test_result_pass("%s\n", test_case.name);
>> +		}
>>  	}
>>  }
>>  
>> @@ -1250,13 +1252,16 @@ int main(int argc, char **argv)
>>  	time_t t;
>>  	FILE *maps_fp;
>>  
>> +	ksft_print_header();
>> +
>>  	pattern_seed = (unsigned int) time(&t);
>>  
>>  	if (parse_args(argc, argv, &threshold_mb, &pattern_seed) < 0)
>>  		exit(EXIT_FAILURE);
>>  
>> -	ksft_print_msg("Test configs:\n\tthreshold_mb=%u\n\tpattern_seed=%u\n\n",
>> -		       threshold_mb, pattern_seed);
>> +	ksft_print_msg("Test configs:\n");
>> +	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
>> +	ksft_print_msg("pattern_seed=%u\n", pattern_seed);
>>  
>>  	/*
>>  	 * set preallocated random array according to test configs; see the
> 
> Thanks,
> Usama


