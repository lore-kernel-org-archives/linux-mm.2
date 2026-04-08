Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43664FD5F98
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 08:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737CE6B0088; Wed,  8 Apr 2026 04:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E98D6B0089; Wed,  8 Apr 2026 04:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0D96B008A; Wed,  8 Apr 2026 04:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA2C6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:36:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9F241A088F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:36:42 +0000 (UTC)
X-FDA: 84634732644.03.8323A2D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 64728140003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:36:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eLQ5FHSQ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775637400; a=rsa-sha256;
	cv=none;
	b=OY821UKzdk/6qlfDsqdISM7CKPOJqe3piG7uK1+jIJhmcTucNAHUKFYgfJTlTs5eXhf2wM
	TLoibvmCORUGeJrNpPnsnTe7zX3hog0Y1spOTRvhB57MRnGpX9i948wWtbalY/woyLPBFT
	cWpvniqvpsy69OPvsW/t04yYPNo78ws=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eLQ5FHSQ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775637400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Loaw8PpmykJdGoBeOuulDHAtP1xQoV6l9r+7fw4smo0=;
	b=LNep/3CCtNnYu18kVzcRp4FMrnXj6rwkFXtytaYl/4ouDdyW/7TRaHAlLnfjHXLVwKgGk+
	WSmIXdA80bl7DCuScpvpwx02RHQUlXdu7HrZ4A/JHY6jVX3HU4HELk8VDL4Pd0Wtm6Wkob
	oE1xJIWVz1t0rgaOKTn1rB8/SYsoOnM=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6386HUIM2302913;
	Wed, 8 Apr 2026 08:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Loaw8P
	pmykJdGoBeOuulDHAtP1xQoV6l9r+7fw4smo0=; b=eLQ5FHSQ3+llXRINXTMiBe
	bwjAPlpSVdKsKItFWnus6pv4BdZudy0LbDWCTT8gEYvMb22lhBZo3OfzWe89SnuP
	KMlAJfaN/lVHg/pZx4cS8d6o6tuCpiwNCxsoLVlz8//SoJ/Eko8u79etHyKC3VAr
	qsf4CurZPXFCedwl6W5e/7LsgTlgjcXFJDjWTSRwXl7BgnviU/BwcjrO2GqAvnva
	sPXUyYcM7uTrJt2PNHF1IU+fVuAXi5/di5xUT9M6msYaoXuEDRPWjFJNXhpKbL02
	VUeYOgXkhwCRAZBdSRezMCg7CyU52iGDKk4KSRcVFPdYXgMGK+BDs6IlJRT3W5yw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2ff19g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 08:36:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63867pFK007892;
	Wed, 8 Apr 2026 08:36:30 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmg2en52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 08:36:30 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6388aToh56558050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 08:36:29 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F187058056;
	Wed,  8 Apr 2026 08:36:28 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F05D5803F;
	Wed,  8 Apr 2026 08:36:23 +0000 (GMT)
Received: from [9.124.213.224] (unknown [9.124.213.224])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 08:36:23 +0000 (GMT)
Message-ID: <5888f69f-c336-4151-a9ac-9b0b00f9c3bb@linux.ibm.com>
Date: Wed, 8 Apr 2026 14:06:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
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
Content-Language: en-IN
In-Reply-To: <8B26C697-4D0C-4E1E-A14E-D517CC9DA05A@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDA3NCBTYWx0ZWRfXyMsFxjH5ZAEx
 QURUCqdCb6tU0N/lsaLNSWf4CEOXaX8rjiUOY2f9hY/TmFyeM71HOTuOsiDJLMe4Jlcf+FnL3WY
 RJ2ZF17PIJbmV0augrWBKXXMM4SBmk8AoBJiBZHxIFGNwriB2NjiKlaUdjRd7LCMTKXGQuBFkps
 QrV3/fQWJJAbNsSI8ZQ1rcL+cuTt2/7WDxKTqCrK8TSqxWAHF3/zhktufRjs8j9eGxn00YrEMrT
 d172/Y+aYGMmaHm90SDQR7y4YQjWMrYFCwk3QtXbAduAmOH20BjhbuPtq9c/3Bdd8zkXm9eGPt5
 lVfSy4Hpdm0eBU1EhhVx0SKDjDa6mAsSfUqBg2NQiWqzF8LwHDONvpsjhyVrJSxqVfC7zCKuFTl
 +ZHylFYG6N8BYtXWfkrKILdKK0mVxuHX9ZNyDfwI0qTX+Qk+Y/fFIMhEAiDXnhe9U4HkF4GEh1B
 dRVT82tQogAQrPzJMGA==
X-Authority-Analysis: v=2.4 cv=FsY1OWrq c=1 sm=1 tr=0 ts=69d6138f cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=Ikd4Dj_1AAAA:8 a=39rta5gLTdMnewpgM9YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0LbYInRYda5hNxNYcRJELdpDcjEyUcy7
X-Proofpoint-GUID: 5A0vIPtpZv8knW7GWCJDMYoa_Kb2a2tu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_03,2026-04-07_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080074
X-Stat-Signature: ojoyp4r16hsf1x6dt7jab4xks4g5p3bc
X-Rspamd-Queue-Id: 64728140003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775637400-629767
X-HE-Meta: U2FsdGVkX198NL7IQohPo26wA8DysmvUXz3XYMCZqGPgKs3IDZ7HgSrACJ1ZPI6oSx+zlZfFiZIV+7fpdIUktbL3tQf2CelHqVN1wYGQC0Wm+8yJaCmDGantPHuItO8MBSamz5H3CJH5C/SDl/Z8dMJmnuI0NvfEw31ZkY6ie7yoa5+M2gah9imh3QmTt5DVPvKFz3Km2h+Fv6372/PmiDdofoOE/VSqN/RVadNab6di8DVjCP35xIuOT/pwgtX1G5lX3bl7LUz2kOqY3EXTeS1BO7rW/FWza83fR3F6iOhMln5zV5dI5AnbKKZ6GjpEXce8MtO/4p+KQ/BZqHdIKn/qqYy/wKK4hxqUxYJDb6jSJQJbhUXYlFiDcuX4qYozG+xTC9ZDbOeBIZJXVAClwgiJ52iT5fWhQYXzy9808Tpc7C3jZ4vJ5OO3GxBy/qhXlyFtHwCAi9bvehDLnXbEnxIEfre/nZu13HWs7uE6OIJFzAyr8Q9TNG3obp3w+UahW4YSu1nRtsYxorQ2dkiOe9zXhPKR0I5hxaGOmIeXAN90xcs08+8Da2b9mGqrsqX4OigqkyjaPUBuJHJXg/M8Z5A/QqoySVB87Ba3Ogl8SlqkAgeM9Qqfb15VbUQT7G7NASm5mGsbe5u1/xWqTvsaL7kAGhxNY+cSFMvmSXXGlV2iDIQBglPiJjW8ZceQfeDWum4WrT5aT1+Ox5w2zU7/GuHSiPhfbDVxOODR9LRARFiOyrrJy4XPIgJ+cdIRz58pdZyjkXy6uQrcmN1ZVX+oSfNCUXaBQcGZml2WmxrG5aId564W9lPqgO8rza65iQ0zafgsXYupt15NZdNIrLrBCzT9mF74QaHIygGttsy5SiTGNtw8iMlbWAqAZjfkQn5jvwExxa4CDH66jHLkHMoEtsZssDv/wGDtuKj31d/bH4WhSH008HCGBBqt/HzqAZrlGWxnjMwneIFhsmDR13o
 7w4oiUsf
 gajgnbD75XO5pO8XPU0VeCq6TEdl6t28YM69D1KucYlzFp+ykSLx11pCLZOCjsvTenHXi+qe6YF4pcBlcCxgxmGnFrXSJ97vVljef421UO9dSTtOaQSE1Yry+Y0Ava33uxhSoTEvU/LmwVardA68cGeIIIOm2ZGzOGFsatD7mAASl0n0ABYEoK1iIq4ObgFqXKGlUESYQerGsfO6ISxj6R8derYG7det1HfOzmZkQLs6NnVZpoNkXvXos6brXekPOrEkEYaBIwktM406KxSIz6QWfwM3XrvZoK9kGt0EP0i29OEOalOeKUQnW/IhIUM2PnVzHRquUNUWnUnIyWBb9MqulCGKAIhXV/BcmD48u16ZtkQFq8WHr9s/SRyilzzK11dOGiz2vu+f86OA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/04/26 20:21, Zi Yan wrote:
> On 6 Apr 2026, at 5:19, Sayali Patil wrote:
> 
>> run_vmtests.sh contains special handling to ensure the hwpoison_inject
>> module is available for the memory-failure tests. This logic was
>> implemented outside of run_test(), making the setup category-specific
>> but managed globally.
>>
>> Move the hwpoison_inject handling into run_test() and restrict it
>> to the memory-failure category so that:
>> 1. the module is checked and loaded only when memory-failure tests run,
>> 2. the test is skipped if the module or the debugfs interface
>> (/sys/kernel/debug/hwpoison/) is not available.
>> 3. the module is unloaded after the test if it was loaded by the script.
>>
>> This localizes category-specific setup and makes the test flow
>> consistent with other per-category preparations.
>>
>> While updating this logic, fix the module availability check.
>> The script previously used:
>>
>> 	modprobe -R hwpoison_inject
>>
>> The -R option prints the resolved module name to stdout, causing every
>> run to print:
>>
>> 	hwpoison_inject
>>
>> in the test output, even when no action is required, introducing
>> unnecessary noise.
>>
>> Replace this with:
>>
>> 	modprobe -n hwpoison_inject
>>
>> which verifies that the module is loadable without producing output,
>> keeping the selftest logs clean and consistent.
>>
>> Also, ensure that skipped tests do not override a previously recorded
>> failure. A skipped test currently sets exitcode to ksft_skip even if a
>> prior test has failed, which can mask failures in the final exit status.
>> Update the logic to only set exitcode to ksft_skip when no failure has
>> been recorded.
>>
>> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>> ---
>>   tools/testing/selftests/mm/run_vmtests.sh | 52 ++++++++++++++---------
>>   1 file changed, 33 insertions(+), 19 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>> index afdcfd0d7cef..17c9bd910c47 100755
>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>> @@ -235,6 +235,7 @@ pretty_name() {
>>   run_test() {
>>   	if test_selected ${CATEGORY}; then
>>   		local skip=0
>> +		local LOADED_MOD=0
> 
> Can you rename it to LOADED_MEMORY_FAILURE_MOD to clarify its use?
> Since now LOADED_MOD is visible for the entire run_test().

Thanks for the review!

I kept it as LOADED_MOD and specified it as a local variable 
intentionally. The idea was that, if any future tests are added that 
need to verify whether the module was loaded, they can reuse the same 
variable. For that reason, I did not make it specific to the memory 
failure test.

Please let me know if you think otherwise.

Regards,
Sayali
>>
>>   		# On memory constrainted systems some tests can fail to allocate hugepages.
>>   		# perform some cleanup before the test for a higher success rate.
>> @@ -250,6 +251,28 @@ run_test() {
>>   			fi
>>   		fi
>>
>> +		# Ensure hwpoison_inject is available for memory-failure tests
>> +		if [ "${CATEGORY}" = "memory-failure" ]; then
>> +			# Try to load hwpoison_inject if not present.
>> +			HWPOISON_DIR=/sys/kernel/debug/hwpoison/
>> +			if [ ! -d "$HWPOISON_DIR" ]; then
>> +				if ! modprobe -n hwpoison_inject > /dev/null 2>&1; then
>> +					echo "Module hwpoison_inject not found, skipping..." \
>> +						| tap_prefix
>> +					skip=1
>> +				else
>> +					modprobe hwpoison_inject > /dev/null 2>&1
>> +					LOADED_MOD=1
>> +					if [ ! -d "$HWPOISON_DIR" ]; then
>> +						echo "hwpoison debugfs interface not present" \
>> +							| tap_prefix
>> +						skip=1
>> +					fi
>> +				fi
>> +			fi
>> +
>> +		fi
>> +
>>   		local test=$(pretty_name "$*")
>>   		local title="running $*"
>>   		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
>> @@ -261,6 +284,12 @@ run_test() {
>>   		else
>>   			local ret=$ksft_skip
>>   		fi
>> +
>> +		# Unload hwpoison_inject if we loaded it
>> +		if [ -n "${LOADED_MOD}" ]; then
>> +			modprobe -r hwpoison_inject > /dev/null 2>&1
>> +		fi
>> +
>>   		count_total=$(( count_total + 1 ))
>>   		if [ $ret -eq 0 ]; then
>>   			count_pass=$(( count_pass + 1 ))
>> @@ -270,7 +299,9 @@ run_test() {
>>   			count_skip=$(( count_skip + 1 ))
>>   			echo "[SKIP]" | tap_prefix
>>   			echo "ok ${count_total} ${test} # SKIP" | tap_output
>> -			exitcode=$ksft_skip
>> +			if [ $exitcode -eq 0 ]; then
>> +				exitcode=$ksft_skip
>> +			fi
>>   		else
>>   			count_fail=$(( count_fail + 1 ))
>>   			echo "[FAIL]" | tap_prefix
>> @@ -529,24 +560,7 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
>>
>>   CATEGORY="rmap" run_test ./rmap
>>
>> -# Try to load hwpoison_inject if not present.
>> -HWPOISON_DIR=/sys/kernel/debug/hwpoison/
>> -if [ ! -d "$HWPOISON_DIR" ]; then
>> -	if ! modprobe -q -R hwpoison_inject; then
>> -		echo "Module hwpoison_inject not found, skipping..."
>> -	else
>> -		modprobe hwpoison_inject > /dev/null 2>&1
>> -		LOADED_MOD=1
>> -	fi
>> -fi
>> -
>> -if [ -d "$HWPOISON_DIR" ]; then
>> -	CATEGORY="memory-failure" run_test ./memory-failure
>> -fi
>> -
>> -if [ -n "${LOADED_MOD}" ]; then
>> -	modprobe -r hwpoison_inject > /dev/null 2>&1
>> -fi
>> +CATEGORY="memory-failure" run_test ./memory-failure
>>
>>   if [ "${HAVE_HUGEPAGES}" = 1 ]; then
>>   	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
>> -- 
> 
> Otherwise, LGTM.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> Best Regards,
> Yan, Zi


