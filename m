Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736E1F364A2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4536B0005; Thu,  9 Apr 2026 12:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCBF96B0089; Thu,  9 Apr 2026 12:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE1386B008A; Thu,  9 Apr 2026 12:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA4B06B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:49:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BDA8140418
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:49:23 +0000 (UTC)
X-FDA: 84639603006.23.4D61D7E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id D14DEC000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:49:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="PMFB/VR1";
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775753361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skeijJYAw0fiK+XGH88wl8oZ8yiStugPyY7G6KP4bYo=;
	b=RRK2zcZCNjSN11xCu/HauT7SI/BGgdOAfms70NYZFwGLp1KYiyNviFspZN9LfcTuUoWfDg
	Z3FnFhbfKIsc7rjk+GDaKPJqKg3Ir+2d2SuI1PHgJqUo2WjBfyCOFCUcsO/VLUuwU4mdPf
	gBZGraRbS1XBSOKT10ttf8frIlwDwHw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="PMFB/VR1";
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775753361; a=rsa-sha256;
	cv=none;
	b=Z3aloXFI6nR04wUNr4N+7Rht0cPjMTvN3SF6LQjfR+s9DD9pGwDXjqANehQ5FA0nMfwKei
	pE5Z6HRA0wFdmYCn+CzIW43mELZET1BiFoKgTJT/4KC2GVFt8x+29K7tdoWLHT7/ji215X
	o/nmyO9VhOhRR1QOt1cGjnN6E+Rvw7M=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639AeONS2302396;
	Thu, 9 Apr 2026 16:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=skeijJ
	YAw0fiK+XGH88wl8oZ8yiStugPyY7G6KP4bYo=; b=PMFB/VR1NXWf8l0QKJrRcB
	PHjR84wRDpsPwS1adRf/bF0JB+gkpC4Z4AXSJN+J5ZTSjlGI38MVL9tCj9OENoSR
	bJI5EtM+A+3Bmvlu5yKGBoy2YRQgTGtNXu54wM/7581yDZE6EQWW7DoGvCqgZbBy
	ZXDPbQuJX1KRD9BaD6ish3ZIg3KZpo6xHwaxWCK/B8ZJX23Zr9J+fSBZp+tb6L2S
	gJ0OzwJhNi6mAF2iLhcTfMrnumMtQmwTbhU7lhltC6o1y2oDcVuip268j6xoIHAc
	aeq8ynWzyyz9VJ5IySBSgMxzWG4hdQ0SRiBbXf0n99Grms+mCMdCtzm4ENevcnHA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2fp2ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 16:49:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 639Cnqf7018946;
	Thu, 9 Apr 2026 16:49:07 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9mf5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 16:49:07 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 639Gn7TF30605878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 16:49:07 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45DB958052;
	Thu,  9 Apr 2026 16:49:07 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7C5B58050;
	Thu,  9 Apr 2026 16:49:01 +0000 (GMT)
Received: from [9.124.212.138] (unknown [9.124.212.138])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 16:49:01 +0000 (GMT)
Message-ID: <d90cd4aa-e0d9-43d2-926e-2154df924f97@linux.ibm.com>
Date: Thu, 9 Apr 2026 22:18:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/15] selftests/mm: move hwpoison setup into
 run_test() and silence modprobe output for memory-failure category
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
 <8ef8640092004d143fe80e6fc32ea8d30a9080de.1775466330.git.sayalip@linux.ibm.com>
 <8B26C697-4D0C-4E1E-A14E-D517CC9DA05A@nvidia.com>
 <5888f69f-c336-4151-a9ac-9b0b00f9c3bb@linux.ibm.com>
 <B686276F-89E5-4192-8973-3B787FC8AC86@nvidia.com>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <B686276F-89E5-4192-8973-3B787FC8AC86@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE1NCBTYWx0ZWRfXwvUI0Gwo1mcg
 wa1oc4VivmfI6eqIsrx8m3q64N5D+QkE5qQAGXfOivbbn3ZQEqXfSmSlVy/K0Dps8xXoZaVMnCB
 r5diJrPEAJbjIykV3ww3Eci0OcTESE3gTBHkmZAtxpF1wLrmCma1oB+WP6EDaOnI4oLY5Yfec59
 kDQX1zfgi6bNccGxjRPs+kf5SglhOOehYCksJ7c1gPID6TvNffvYx+Ul+qHbSVvGrtRigilR3qr
 piV9Bn1/LA/6Qvq/k99gi4NmG1Ak0U7LFnmHAZWVq/fFci4NHE3xtA8dOjqKA+EbSi6lTGmA6q2
 g0y1+3k19oD+2rD4ovMYdGMm+IUYJe5kV66/kasDHEDStwCDNH4XpoGXa9MU4XGQvCH0GEFSTnY
 qUlYgRvbvrZkuiTAaOX8TXhPSEOTDMp4+bHx+kgHvR3ExfQi7rvwMltrOwHHymce0EZe9ATuePU
 tMWn/SL0eq3LJN0Ujqw==
X-Authority-Analysis: v=2.4 cv=FsY1OWrq c=1 sm=1 tr=0 ts=69d7d885 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=WTjc7Mk9pcOPGDH6nUsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: xQKqax6dvX8APGiCVYRA2NgekkI8SNQd
X-Proofpoint-GUID: ERlRxTJ0wNXRKaZ2H8ZfNUREZ1Be82IX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090154
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D14DEC000D
X-Stat-Signature: fxsnipibesns8jq6aw84ypdfjkiqbdic
X-Rspam-User: 
X-HE-Tag: 1775753360-674437
X-HE-Meta: U2FsdGVkX18swPd+XhHvyspzc6A74WFTHmVWSWlOebrpk4Hgl3dh7ZX6UAwO5r357JbKi7xUT9jBVwNq5P16wjbyLIjjhkpBmiS4u3XsUdcZ1x6Tp1P5ffxHFG+/Xdr2tXq/BUoNdwOnoKt/fE8G5eQAyXK0Swdrmi4xKQENIY7npxr3TS/zBOuQ/rAwC0nwf5eiKn8nx/e8T42XRLBNZuwYNqCD5wTgDR+rA9rL9QThVBnWSDjDOd2+mFbkEGmdNhDgYgN6QaISPtfNL7nZGSpesQEnAPEVe+aMzJs4MKd285hRQtLTHHRJ3cxqX0Zi8mMqrYCkEdtkwdUtzYkUbSAj6I3Kngirvy6mx7MI2spQi3zALh3iO/Sukng7x3HNfjZ+XGpcPb6wwxIX2nvBrOsq9qqMCn4rLM2gGUY/hZIpF6fBcB+2mlF0q4DIwk6t0swpo0kcMvaCe/zQkPb8WfXEyQKYpiHlytX7lWb6RBn1GCC7k4M8o18Jd+5Dtdm/0VCO+vTSBZ2LenEywm+/9jWeHjvIcaaXWDxerO6TRQ2iPIfMBQqFWYK+B1lYed582Uhs42mEZ/46+E634Q/u3c+/Q47W2sRIOa/0faUumVmYhtcBAIlnECuN5xt9akyH/tc9gq+dv3KdXccbjU1B4yVnkcJlZ23flMgaZskX3uVja8Jen1EGzw2gxErSy/wLPpccwsd9iEVPrO5jBhcte10BHHzZa/2G9q7m1HLQesaJIsPXRMqT3XdavE4Dq0oFSf2eRxXRJZsKe5E5+ub2JRJhp8IE01gvd4hv1Ve3Y7142YXbIDLMIQEIBlMZ2Pg/yY+VPEuKhasUEyfqNwboUWE/OkOZKnl4G7D9bpTy3QT72PhPMwKmJWJzE010yrQ5TUr/KT+PkaAwLNlf4YQ0aZwBmh6uFNns3aevM/pAnkQsyxi+rUJZdrFZFUrjOUfsTJsUB1xGgmnepfyulEq
 5jBtSfpx
 5OfO854sR1N8vsT2WUJI19drfqnMrXQ9gNSL1dzuvc4pAtSBAQZxwx1c7oHL3IGr9xoAMoK6K5jGFu63A2P2dHUqTy+qDUxxo6YUZHP+JXkxovmoYc6nSsuT4X0Kc8fbLajKI4NSVjRqMdWOBwNtjjG9EZSct8JeBmRafc7E0CsunaTLreV/ID9M7QN5dG0n8n+fXtBGzO+JJCbNAW31hjpQSOX1xUiZm9F+RJ0eiS8Fe18/SLrAWwCTiNjYS93ue26hbnueDNWgSaMVlHq6lbAAG06yF4NhcUHeXjn/4GiP2fSUXcVKAhYFc5HgAfVQJqoFe2otmjbpo9ewtUiGE1V8oiCD6IxhEQB9fRMyrM0N0EhYal8gqgjkIFl7diGr0+/oqDdiY9OFPX9XyAIjqi3qwPqsKoXm19ZzOX7GJVh/7CstOdDnVSiDdwJqA+PRUCDl6wbodEibHywY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 21:10, Zi Yan wrote:
> On 8 Apr 2026, at 4:36, Sayali Patil wrote:
> 
>> On 07/04/26 20:21, Zi Yan wrote:
>>> On 6 Apr 2026, at 5:19, Sayali Patil wrote:
>>>
>>>> run_vmtests.sh contains special handling to ensure the hwpoison_inject
>>>> module is available for the memory-failure tests. This logic was
>>>> implemented outside of run_test(), making the setup category-specific
>>>> but managed globally.
>>>>
>>>> Move the hwpoison_inject handling into run_test() and restrict it
>>>> to the memory-failure category so that:
>>>> 1. the module is checked and loaded only when memory-failure tests run,
>>>> 2. the test is skipped if the module or the debugfs interface
>>>> (/sys/kernel/debug/hwpoison/) is not available.
>>>> 3. the module is unloaded after the test if it was loaded by the script.
>>>>
>>>> This localizes category-specific setup and makes the test flow
>>>> consistent with other per-category preparations.
>>>>
>>>> While updating this logic, fix the module availability check.
>>>> The script previously used:
>>>>
>>>> 	modprobe -R hwpoison_inject
>>>>
>>>> The -R option prints the resolved module name to stdout, causing every
>>>> run to print:
>>>>
>>>> 	hwpoison_inject
>>>>
>>>> in the test output, even when no action is required, introducing
>>>> unnecessary noise.
>>>>
>>>> Replace this with:
>>>>
>>>> 	modprobe -n hwpoison_inject
>>>>
>>>> which verifies that the module is loadable without producing output,
>>>> keeping the selftest logs clean and consistent.
>>>>
>>>> Also, ensure that skipped tests do not override a previously recorded
>>>> failure. A skipped test currently sets exitcode to ksft_skip even if a
>>>> prior test has failed, which can mask failures in the final exit status.
>>>> Update the logic to only set exitcode to ksft_skip when no failure has
>>>> been recorded.
>>>>
>>>> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
>>>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>>>> ---
>>>>    tools/testing/selftests/mm/run_vmtests.sh | 52 ++++++++++++++---------
>>>>    1 file changed, 33 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>>>> index afdcfd0d7cef..17c9bd910c47 100755
>>>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>>>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>>>> @@ -235,6 +235,7 @@ pretty_name() {
>>>>    run_test() {
>>>>    	if test_selected ${CATEGORY}; then
>>>>    		local skip=0
>>>> +		local LOADED_MOD=0
>>>
>>> Can you rename it to LOADED_MEMORY_FAILURE_MOD to clarify its use?
>>> Since now LOADED_MOD is visible for the entire run_test().
>>
>> Thanks for the review!
>>
>> I kept it as LOADED_MOD and specified it as a local variable intentionally. The idea was that, if any future tests are added that need to verify whether the module was loaded, they can reuse the same variable. For that reason, I did not make it specific to the memory failure test.
> 
> You mean future tests that use hwpoison_inject module? Or any future tests
> that load a module? For the former, you can use LOADED_HWPOISON_INJECT_MOD;
> for the latter, I am not sure how a single LOADED_MOD would work for
> different modules and that probably would need new code for that case.
> 
> My point is that since LOADED_MOD is now in the scope of run_test(), it is
> unclear which test uses it without reading the entire run_test(). Giving a
> specific name improves readability.
> 
> 
> Best Regards,
> Yan, Zi
> 
Sure, will rename LOADED_MOD to LOADED_HWPOISON_INJECT_MOD in the next 
version.

Thanks,
Sayali

