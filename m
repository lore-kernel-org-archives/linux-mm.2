Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E18CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576738E002D; Wed, 17 Sep 2025 10:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FD08E0003; Wed, 17 Sep 2025 10:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7F38E002D; Wed, 17 Sep 2025 10:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 292ED8E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:47:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A60D7BA2E4
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:47:47 +0000 (UTC)
X-FDA: 83899021374.15.138C8BE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 39C0140007
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:47:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dJXTivof;
	spf=pass (imf12.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758120465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJYwbn+JB+KKVE5/cX4R9ljnf1PsqZ6DpnlLpYSK3eA=;
	b=yw/GwE5U0/rxdvum7AxMOHw2Nj1rfzPfF+PffePWGi8kFQm1+Y7hlwdo/dLZylVF2E4V1X
	jY4eASkLuLYLQ2NN8v+pqimRs2RTwqivt7d3CB86SFtDwQLoOr7nWO7XgcMG/BAHrX+UvX
	N6n0HXMCf/86Thk5IjAmSOpBZGrjYKc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758120465; a=rsa-sha256;
	cv=none;
	b=63JsksVCA/DUAi0r3G5QPXQojwl2tstDA80uJnNrJNYnH5ZsCrMKI71IhQYnmCXrAv9SNy
	nBNfazhzqhWdWu7DQqFYNFY/sZ8U2n3k5Dmku6ATLpZ+3wzt+uOsX7TxJxN76Do7oJhV6n
	aKzbo65OSxvmhXT8NogMb0A373na8QY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dJXTivof;
	spf=pass (imf12.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HADA5j023751;
	Wed, 17 Sep 2025 14:47:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gJYwbn
	+JB+KKVE5/cX4R9ljnf1PsqZ6DpnlLpYSK3eA=; b=dJXTivoffiEEdWfvyhoc5k
	QPMV/z06Ey4Zi7CHIhiHMyYEVxh9tKSeVIH0eCYooYWjtG1Ze0cz9nmNpih4jDmJ
	/72XAeUgj6OT5nD/wbwmXnQ+M+4Snepr1amQwcrU5AKrusg/47ec+Zq+r90S3fkH
	rKiyKT6BII8N2sRIbT+dWw1wEVK6rXyJrbRGBPWHE0NcIg9L4KrRtHzUzz8g8dtc
	ydA5ZtPzN6PHUErb2WwWqO6wULeZnHNwQyzXdPPB9ZyVeBvSKhhL+IU4AuNhN03c
	pC8+3eVTLM8EFk7EwTlNvM+5X2w4S92kA0GK+8uk05hC6GdVBsgg9vz/XJ0PQuXQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qm53p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:47:43 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58HEl1nQ026672;
	Wed, 17 Sep 2025 14:47:43 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qm53n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:47:43 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HBpKTm009395;
	Wed, 17 Sep 2025 14:47:42 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn3hert-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:47:42 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HElfog24969772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 14:47:42 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8F415803F;
	Wed, 17 Sep 2025 14:47:41 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CC4958055;
	Wed, 17 Sep 2025 14:47:38 +0000 (GMT)
Received: from [9.109.215.183] (unknown [9.109.215.183])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 14:47:38 +0000 (GMT)
Message-ID: <0cf5dea0-715d-4fcf-ad58-0272d4d07809@linux.ibm.com>
Date: Wed, 17 Sep 2025 20:17:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm: Added fork test to verify global
 ksm_zero_pages counter behavior
To: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
References: <cover.1757946863.git.donettom@linux.ibm.com>
 <5910cb6bfc7c43b169b679a0108667a56d7ebdb8.1757946863.git.donettom@linux.ibm.com>
 <d4988c21-1e1a-4de2-a1c0-7d78525d2939@redhat.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <d4988c21-1e1a-4de2-a1c0-7d78525d2939@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n7F2pwreaJvYF0tTjQ2BZ-UQKrY16ZiE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX40KdjdTBNrQd
 CxRNETreSrTs+H04h5ufVzKZm+s4tHWES/z3ZV4sw7V7Rg2A0gZBfJxoiA7FhZRnjufMwn/HijR
 xDfvpKMlEnWtHDpbo/bQHEmix9CxfZ2Js/LkrPsevyqN2UvzVIGTfM+CAHdPsU/95n/Eb+vufif
 fQQpUVrO2gtu1fVQDPoEGLFSxOq0IEWsVio/PTEdVRCFCfSvb1Ph7EhEAA3MS0IIlqUrEa2IVmM
 Bg1RyHmMhVyk6sjyqio+RYAFdID2H6HJl8QxZ1qlB7cNnqFOUL0+G94khPzrbZBFu36/Nhu2Ys/
 dRS1dIAwnu+hbN9qxeKrMlh8WUgAHjJsy05aNe8R4vehiSA0EFJj6WRWgDjIfXrFpelbd4KZIiT
 nSF4iYWT
X-Authority-Analysis: v=2.4 cv=R8oDGcRX c=1 sm=1 tr=0 ts=68caca0f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=gr7qHWn7gAzsIUFteVUA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 8sZQPMa3ZC5XGB_QgTGU3L2F2POeyE2O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204
X-Rspamd-Queue-Id: 39C0140007
X-Stat-Signature: zhft6ot31zwf684zjqrambao573jcrod
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758120465-423366
X-HE-Meta: U2FsdGVkX1/p4yto1m+hwAoWNirgk1lu53kcr1KJqD6Mn86IN5ML3e7TMhPav2SUdzotfn8ls/oBxgjEIQVGXNn4UbZCjiU+fIF+1DGdTakMxjtBamdfMwMueynynANNAZ6ljo9eqWHz/u0JIlMchi04VimMms2AlQqJcbNVqxGW1uqvoYjrClb54BbdDUvoj0P5Po30dd777dtQAp3gu9Vbz8T3ovlpUOYMOTWUb2Oz/h16rYKS2CNM2/JMxyxwRu30MbTpe7ZMzyc7J6Tew7r8ryVU+DcmBXKeNruh0H1u/ljuFhYbpHnWrvqZIoV9Oh9N55QV+PzgUUtGiVKubeCP/f3GsEIM2YxSVQ8FB/p4nQiTwMfH7OazyVk5k4IsKMFJIsl3U5svDH9U/2FThO2TEfBsxodiWnh0CL5lygJ4ePaLlaImMVJbENxipLmgueY4v91LoJNAJKcvrViVsM1toI32AADkr8LcnxMOQQciru61wTctx4UBFv5jw2nfg15KcKCgIZixwnkCi6bjiGZEYxG08jL+Aw6FOT/KEM8nf7H/Zj36aCOYQTV0OEFAnDVmFinirZ3YbiOiC8XVoOVNZFrWflyDo6yyC6DEbtChxXuQLwDxZ0yKncIm56snh78iUg8EsRLqZS1e/FkFq6dTXUMWEO4NIj9rVpNKsEzcrNFGI+7mWNM/NBxfgW1/MxIsYNW2rltnHLohDLVXHAzAbZyFt8bKjfdU0XWSeCKX/Ke9mTBu+hBYZum0S1BtxA8YsJ+zwxivWxk/PYVcQD3PO0EPiGKxivxOXFa43981z14B3KW0mgtJJyIoT9WA2ACOYCW/yGAr8MYpPIcAF+FIca8OMjLBYM0tTa9P3OkNUlWJ5RY+9Ajx3IYhkRC5I9qFsaMfwBqYOXC7aJOAuVB8UxrRNY8YTqhw4v2lhpaQ5F1TpcuFtg7jBo5pNjVLAjwClqgM8/ZN9TlZKZw
 CytXDSn1
 VBWfgzhYCoyvn7rS7w26y+VortuItNC+ESFKHdNnTIzFizavNrVgslAqYONEh++QQAAYdHqCOAWJhYsCNxObrF9IWzw3/+uecwtPVc4O2zbImn9gNWvjLT7h9HoPXmiprSxXR4e5PifMhsFg/ayQhjIpppiL0aTeF3sgWHuFO72ndE3TRDiWApzETHE/lIAZjB2+90IoTlf7yxGG/x9BJM+DAlPiYO6hCczjsR8dhUPFNGaZpc3EsPw986fuCqYAX+tJNPb3wgzdhbRRbce7TMQ3zAJm8Zxy74TeihBopYCc7xmjWcr7TbYtpGYZfbNLjOd8i8MeBfi/nbGO7qn+jwUp4QhJKJXqGFIasetXqsJOQb6OT9a7W3bkrhk4shYBuEjFolEF7rr4DYgyngsX2ecImJxjg8jsCH8EeMIjWr1F5XXsUS9bPrL0OVoIx8WChE5NkglEzkeZbzxlUiusQQA79UHC+1Vp6oa1u/FX0ATUCUyzleg1JeHrryHKaU2fp6UTcZKQWdvPgEbo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/17/25 6:49 PM, David Hildenbrand wrote:
> On 15.09.25 17:03, Donet Tom wrote:
>> Added a selftest to verify the behavior of the global KSM zero-page
>> counter during fork. When a process forks, the per-process zero-page
>> counter is inherited by the child, and the global counter should be
>> updated with this inherited value. This test ensures that the global
>> counter is correctly updated after fork.
>>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>>   .../selftests/mm/ksm_functional_tests.c       | 74 ++++++++++++++++++-
>>   1 file changed, 73 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c 
>> b/tools/testing/selftests/mm/ksm_functional_tests.c
>> index 645cefba2126..f23597ac8066 100644
>> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
>> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
>> @@ -602,6 +602,77 @@ static void test_prot_none(void)
>>       munmap(map, size);
>>   }
>>   +long ksm_get_global_ksm_zero_pages(void)
>> +{
>> +    int global_ksm_zero_pages_fd;
>> +    char buf[10];
>> +    ssize_t ret;
>> +
>> +    global_ksm_zero_pages_fd = 
>> open("/sys/kernel/mm/ksm/ksm_zero_pages",
>> +                                O_RDONLY);
>> +    if (global_ksm_zero_pages_fd < 0)
>> +        return -errno;
>> +
>> +    ret = pread(global_ksm_zero_pages_fd, buf, sizeof(buf) - 1, 0);
>> +    close(global_ksm_zero_pages_fd);
>> +    if (ret <= 0)
>> +        return -errno;
>> +    buf[ret] = 0;
>> +
>> +    return strtol(buf, NULL, 10);
>> +}
>> +
>> +static void test_fork_global_ksm_zero_pages_count(void)
>> +{
>> +    const unsigned int size = 2 * MiB;
>> +    char *map;
>> +    pid_t child_pid;
>> +    int status;
>> +    long g_zpages_before = 0, g_zpages_after = 0;
>> +
>> +    ksft_print_msg("[RUN] %s\n", __func__);
>> +
>> +    /* Unmerge all pages before test */
>> +    if (ksm_stop() < 0) {
>> +        ksft_test_result_fail("KSM unmerging failed\n");
>> +        return;
>> +    }
>> +    /* Get the global zero page count before test */
>
> That only works when "use_zero_pages" is enabled, no?
>
>> +    g_zpages_before = ksm_get_global_ksm_zero_pages();
>> +    /* Let KSM deduplicate zero pages. */
>> +    map = mmap_and_merge_range(0x00, size, PROT_READ | PROT_WRITE, 
>> KSM_MERGE_MADVISE);
>> +    if (map == MAP_FAILED)
>> +        return;
>> +
>> +    child_pid = fork();
>> +    if (!child_pid) {
>> +        exit(ksm_stop());
>> +    } else if (child_pid < 0) {
>> +        ksft_test_result_fail("fork() failed\n");
>> +        return;
>
> Cleanup missing as for patch #2.
>
>> +    }
>> +    if (waitpid(child_pid, &status, 0) < 0) {
>> +        ksft_test_result_fail("waitpid() failed\n");
>> +        return;
>> +    }
>> +    status = WEXITSTATUS(status);
>> +    if (status < 0) {
>> +        ksft_test_result_fail("KSM unmerging failed in child\n");
>> +        return;
>> +    }
>> +
>> +    /* Verify global zero-page count remains unchanged */
>> +    g_zpages_after = ksm_get_global_ksm_zero_pages();
>> +    if (g_zpages_before != g_zpages_after) {
>> +        ksft_test_result_fail("Incorrect global ksm zero page count 
>> after fork\n");
>> +        return;
>> +    }
>> +
>> +    ksft_test_result_pass("Global ksm zero page count is correct 
>> after fork\n");
>> +    ksm_stop();
>>
>
> What stops KSM from merging pages in other processes by accident 
> concurrently and giving false failures?
>
> Likely you would want to stop ksm before the fork.


Yes, you are right. I will fix this and send a v3.




