Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D48ACD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97AF76B00C9; Mon, 11 May 2026 06:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951D56B00CA; Mon, 11 May 2026 06:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890116B00CB; Mon, 11 May 2026 06:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF986B00C9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:23:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25CAA1206C6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:23:07 +0000 (UTC)
X-FDA: 84754751214.02.89F0291
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id AEACD4000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:23:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=K+fzA263;
	spf=pass (imf07.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778494984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyziTpDawUQZ1AMfG5vG1IZmo3cKN9STSmA1nTF6oJI=;
	b=fLuwtcCFGFNsK28EpLHc4tNAcc1dvCR5AYoFmxQ8cR0dgEDwLruxVF95yiJgnwGMBUGjfN
	MxLeFFLnL7V41cJ2vXjWvuVArEMtA+6OcvmIaf2yAQaQXX0mmmDqQnKrJGYWUbQOPE2jDp
	MOvO2HAIujkicqwO9IWsi5h/sTSeToE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=K+fzA263;
	spf=pass (imf07.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778494984; a=rsa-sha256;
	cv=none;
	b=ZtYDkYOZsKDEgjJoX6DhptQTPH3dQmyv+Bw0hzkgp6ZBtho0wrj/J8ys8u8tU6Zj3TMdyP
	26y80upkaNBYAPGGfLqRucE14syHQhJf0S1wnpjL8H1X2YELj9xQ6s42uVfZcp4ISA1Y5B
	DrkiU6S8siBtGzsJ7y8Va9hld2AI3ZM=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64B7D9Wl1991346;
	Mon, 11 May 2026 10:22:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LyziTp
	DawUQZ1AMfG5vG1IZmo3cKN9STSmA1nTF6oJI=; b=K+fzA263+QEvQph2uMRl7F
	ySJm+zKH/fKL2SbyG4cTdbCVDD+4qWmJRz7MK++Geuhlaq++1Y72/XdS6O0b9IVo
	sLHE3LBu1gc0KzUDNtNMPtWtpuRA4jK+V2fIld25zKFXKVIE5wB7hxwOfRmnJXSJ
	uq7QqsmpYWEHkDV18dfjC2L6+0Msa1CyK2U3wGCs2dIcMdRRdvAXZaJmcFUh62yW
	CAFtKNpv63nLZASWIeF1qWJItqFIwFYpPPlUUrA1D3HzYIlIVfRwux8ZBhgNfU8U
	aruqVMtt4BrtG3aLs6r97iq0GHl8eaLDyZq1I30B1XjYkvS+Y1ZfT4ptlcWaTbQw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e1tbhqf24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 10:22:48 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64BA9SK5025964;
	Mon, 11 May 2026 10:22:47 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e2fmvvvkx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 May 2026 10:22:47 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64BAMkDo26804810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 10:22:47 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DADC75805D;
	Mon, 11 May 2026 10:22:46 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A989B58068;
	Mon, 11 May 2026 10:22:42 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 May 2026 10:22:42 +0000 (GMT)
Message-ID: <3d66e75c-4039-40a8-a8d9-e8db62c13b16@linux.ibm.com>
Date: Mon, 11 May 2026 15:52:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: handle fork() failure in migration tests
To: Hu Song <husong@kylinos.cn>, akpm@linux-foundation.org, david@kernel.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260511093433.2372985-1-husong@kylinos.cn>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260511093433.2372985-1-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ZdQt8MVA c=1 sm=1 tr=0 ts=6a01adf8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=y8b2V3OV3dnl5RsapYEA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Nufk4kqobnzr1nYYrQ10GQO2dmESkzab
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDExMSBTYWx0ZWRfXwoTAcSb3B1Pf
 uMZU7xldHbYY82PDgptAUc5KjVUtnXyg7x3OixxRsOHV0ahERKEkQDG+skLSB8a6WuIUvGtHoMs
 0wBs0QCxsHWxoi8SskOEaFcoyAZ0EORS+t0FbR7lyUwbe6hVcFyPMdHapWC6Fk0rdXiW6moFZYD
 cc93MoJzCoPlGovuw5/aVpE9imAaJ50JMHjg+SOhiw8w9Fyx/+pnLmE2oYa4WaE51soZTY/WXDH
 WmqSmlLJfmRKA7D+CgbMCYdxgSBfTljooyOyEOeJXDjSP6Pe7ccGNciDdZLcxr0qXCTv6oWlRgW
 s0mIi3Us4Z0NKrJqgT4m//J1i+BG1g5sTNef9rwr+q3+Y6iPTq7FjoAi3pVkO7nvN9uuPIbOqew
 cvsxjGEaXqYxskBrAoFShBN9RQGRfhKConxZxBRCNUTsPDPwDX662ef8SGKmD2ICH+1FlPRwLpp
 khJhJdZ0J3yCMw0m6Mw==
X-Proofpoint-GUID: oLciyCfTsNXsZAGfTXt8saeO8uDDd909
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_03,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1011 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605110111
X-Rspam-User: 
X-Rspamd-Queue-Id: AEACD4000A
X-Rspamd-Server: rspam06
X-Stat-Signature: 5onck7fup5oerp4bgqbhidoobh71uod5
X-HE-Tag: 1778494984-611345
X-HE-Meta: U2FsdGVkX1+OOXNlygUoPYEurb2pfQPeXqPqSwARUONQIoRG9V/ptoUWxyuWVChkt7psBtkTR8pG3Ddhitx/Llyr5WDX7OLZfQ251VTqNjPJEQL9gXB8LUXapu3q5R6a8Ofw3mxXqLQlzC7xpG3lsIubcZEvOtjHuMLoUIZ37Ta7L5E6Htp+qr/4uVaZOeV03cmR2XMY7zmBsaeWUcbCN+hYk7GHCJetrEB+L9vq432BJOd4CZfOUXniD6aGXcUrbZcKMMfLb/z83KIHH3ZBpHiOOdjTtvXXG6opTbxG3K8PoHBjsEn3rsvQSeFJhODjiY9BktKwTplWzE4WVDusKKX/VQU00+ria3+iQ7HU9ugixnjVCmOhSZtJczm3s4OeyAFYPmOPEeORMd/GjGvm7LQUwq/6v5Dhi0J6GDnTV3ypIXAd8V1m6aZaGT+KiRRc4B7IUfTrd3HgEWON6KaO6eKjLpoOFscTGbRda5z5HmfHfqd4u4/NXfENZghYLk1TV0sndWC9gApywfNeYTdvnbx2eEAHXMM8akR6LzfGyf42cW6f5TNVCe6D+bi3zuzTQgRPFdYcInrHTj+M9vwICvEH+ALtBfSENIsJDsJdEQbZBwH/aRJwLK9EtiTnoJcV2lbPlMT0kLQdmSydH+lOPKz73fZoOQyC+ByhYgTqtGKldWtSYU5rLLdC/dzF8GTs61CMXUm69piM56xOu0lpvUzCCQKWhEn81xcjDohBn5nyqf2grR2vLM+VRWy1wwDVTsWvgrdFtwX0LSZ2Q11dl07ekAs4vem5iKRaOchgUbzkImynDrz+pziHk7Q857BAvr+7kSqoBVGXMbfx/XSe2BPtEk+IAO4nTfITh3J9fYStoyY8A70/C59uibOB3RE9CjNvODlydR10s+q9HmJqqOoSEnJthvk/26l2ghFc9PrbroYdGZu678KzNR+fI6FpOMyz9mMnnimgtY8G1Na
 RE58kc9B
 ptw2U0ehBN2d7S3I9TZSkOjstGiMf4lVbIjYZVbhVZFGVjRoRV9+bfHc4L6gtEnrR4iYhk31Mth+mWHqATYQU0LTR+Hoa2QUNsU6AnLdyHamHsx34MP2ZANahmrWVD1cPLQIn2a5sz60jGqZsmYBHavBQib5SefddkO3oqP+4grs82RI9994LDYDhHQrdXvgGf7SzaGG1kriJjrmcq/dVxIJ0qIjj/LbmvtUC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On 5/11/26 3:04 PM, Hu Song wrote:
> From: Song Hu <husong@kylinos.cn>
>
> When fork() fails and returns -1, the code falls into the else branch
> and stores -1 into self->pids[i]. Later, kill(-1, SIGTERM) is called
> which sends SIGTERM to every process the user has permission to signal,
> potentially killing the entire user session.
>
> Add an explicit check for fork() returning -1 (pid < 0). On failure,
> clean up any already-forked children before failing the test via
> ASSERT_GE(pid, 0). This fix is applied to all three fork() call sites
> in shared_anon, shared_anon_thp, and shared_anon_htlb tests.
>
> Signed-off-by: Hu Song <husong@kylinos.cn>

I am seeing the below issue in checkpatch.pl.

WARNING: From:/Signed-off-by: email name mismatch: 'From: Song Hu 
<husong@kylinos.cn>' != 'Signed-off-by: Hu Song <husong@kylinos.cn>'

-Donet

> ---
>   tools/testing/selftests/mm/migration.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 60e78bbfc0e3..f433e4f195ad 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -163,6 +163,11 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>   	memset(ptr, 0xde, TWOMEG);
>   	for (i = 0; i < self->nthreads - 1; i++) {
>   		pid = fork();
> +		if (pid < 0) {
> +			while (--i >= 0)
> +				kill(self->pids[i], SIGTERM);
> +			ASSERT_GE(pid, 0);
> +		}
>   		if (!pid) {
>   			prctl(PR_SET_PDEATHSIG, SIGHUP);
>   			/* Parent may have died before prctl so check now. */
> @@ -235,6 +240,11 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   	memset(ptr, 0xde, TWOMEG);
>   	for (i = 0; i < self->nthreads - 1; i++) {
>   		pid = fork();
> +		if (pid < 0) {
> +			while (--i >= 0)
> +				kill(self->pids[i], SIGTERM);
> +			ASSERT_GE(pid, 0);
> +		}
>   		if (!pid) {
>   			prctl(PR_SET_PDEATHSIG, SIGHUP);
>   			/* Parent may have died before prctl so check now. */
> @@ -295,6 +305,11 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   	memset(ptr, 0xde, TWOMEG);
>   	for (i = 0; i < self->nthreads - 1; i++) {
>   		pid = fork();
> +		if (pid < 0) {
> +			while (--i >= 0)
> +				kill(self->pids[i], SIGTERM);
> +			ASSERT_GE(pid, 0);
> +		}
>   		if (!pid) {
>   			prctl(PR_SET_PDEATHSIG, SIGHUP);
>   			/* Parent may have died before prctl so check now. */

