Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B88010F6FD6
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 16:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74846B0005; Wed,  1 Apr 2026 12:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26046B0088; Wed,  1 Apr 2026 12:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9140D6B0089; Wed,  1 Apr 2026 12:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 753066B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:05:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3713816098F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:05:47 +0000 (UTC)
X-FDA: 84610462734.29.C1FBD43
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 98A461C000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:05:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=m8bvimfo;
	spf=pass (imf20.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775059544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DS41ytpRnWbYo6AReClMhBSZ/2PMMtxIe4+jyO36Jy8=;
	b=SJpZ9uQYOIA54cB0nYhOi1uXwRyMZJNvI68vQGHdyOFbvpjKdydWLNJwn31O1dl8w5iqmp
	D8niuh2ULoQ2ja6UeQYBO3A+1wOxIAOOyYbuGmoDWtGphp7U4NkqDhMB/zHH19aOZdaSau
	vaFgOn3gUA5n+epXf81XXv0xrgeaq8U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775059544; a=rsa-sha256;
	cv=none;
	b=Z6PD7+qPPWSrwIERTbCl1bIjihU1VupjJxNrFC7pgMGA8KBWHrv719liT/PXDlrcV4liJD
	qwxV1Dnjxjm25PEkrFxReV1anEzkUzWNUVJLaQDuriGKVq3yBOHaLvlqv5/tf/t4jTaM2b
	pRRUjf9aXBzNEG0c4tiH3z2vVKw9H+g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=m8bvimfo;
	spf=pass (imf20.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631DhxMi361878;
	Wed, 1 Apr 2026 16:05:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=DS41ytpRnWbYo6AReClMhBSZ/2PMMt
	xIe4+jyO36Jy8=; b=m8bvimfo7sQ7K+OFSaJF+fwyFLGJFa3QPjPgbq2rC6ADa5
	E3zitbZ9xaIydBNiDNYbW0INvHaSckqQhTIfcoLFtvTcRUFCv5Avx5cCeV1LIB0l
	Nq5jcYWgZQ04m5DJ55lWJgOo5JUbmUypq8/wBexPkuRdBKiLqIFqfMtAYH4NE4UV
	FlTP8ujgRDSQRib+7glYBE4xeVOmjLQl+sUsZkincDF3MPr7SxTeTLIqNpNq3rkK
	NeT/DGU9+91/BklpL1tQNVHQiEH2rj8853hlh3PZZCzVF/T6HzQ2vZQ4pxvW7Mob
	yi3xJQyEjmIS0n5EyhModM55fB+55D602kLSvtSQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d64dgreas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 16:05:37 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 631FdtHT013936;
	Wed, 1 Apr 2026 16:05:37 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d6ttkp8b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 16:05:37 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 631G5ai933423888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Apr 2026 16:05:36 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3662258061;
	Wed,  1 Apr 2026 16:05:36 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 22EBE58056;
	Wed,  1 Apr 2026 16:05:31 +0000 (GMT)
Received: from [9.39.18.42] (unknown [9.39.18.42])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Apr 2026 16:05:30 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------Z1mtNmbpFyIZY1A5sUbCG03n"
Message-ID: <df407504-0e24-4c0d-85f5-3ef2deb86a50@linux.ibm.com>
Date: Wed, 1 Apr 2026 21:35:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/13] selftests/mm: restore default nr_hugepages value
 during cleanup in charge_reserved_hugetlb.sh
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <2ba0f8d8a00fd049e8ed4b97e9ce8ee6b58a2892.1774591179.git.sayalip@linux.ibm.com>
 <2f5da9dd-812e-4645-8340-de8c6beec584@linux.ibm.com>
Content-Language: en-IN
In-Reply-To: <2f5da9dd-812e-4645-8340-de8c6beec584@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDE0OCBTYWx0ZWRfX1E+RdoVFV/MG
 MGtpgYTdtAoWaxRvQzG69ZMhwUvom3yvWDAGhabg2aJVhjFWxLA6T3NQx7NQvCWE5EyonevaoOx
 l57i9I5vAIjRHQj6V6wFIkab70BpwHqttIH71h2+YnK/0gUcA05rpeEl/QCJPeJGe0ees/6+ElX
 BJhtZ1Y7psneX6tZXG/KaQmQdbsvZvvjhc85vyvN35ZZKLrK6zd6R6SdnlfDM6mpzgxjUWNTxxi
 IF6Ch75QqhItgkulhJCTzVDcX5FGwu2NNTOjqPv5IEwp+75ndwHPc/G1oCN8NGTM8zj+gEJ2d68
 ftktOEGsmQUtQIu/Bb7cYvlMiLbP2Id2HJ6MgFaAydnoWtcPwq7xRJIDkJS8TEBQkUEqQCMbUVg
 AYZT7Ui2TADS6k7USyqewzDiblCGeRsZT/SjQWsvicEaQOC1xP0fXW6xXZSwTq2/g6RUkTZAdPl
 MEQVfxxFBI+JtTmKSeQ==
X-Authority-Analysis: v=2.4 cv=QKZlhwLL c=1 sm=1 tr=0 ts=69cd4252 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=r77TgQKjGQsHNAKrUKIA:9 a=Ikd4Dj_1AAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=oXnG4xuSCdGAOdH6UXUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=Npm3-rHHuYopk5QS1gAA:9 a=sTxRpBpiy98KL1WkT8X2XIWo+SM=:19
 a=OnTCA0UXLqtbvC45:21 a=_W_S_7VecoQA:10 a=lqcHg5cX4UMA:10
X-Proofpoint-GUID: QbFgDZ6yCipgXBCMc5U6gz-Wzy_ElmVQ
X-Proofpoint-ORIG-GUID: QXtvmoxprzUNYoGnGF5H3qs55tu-XvjE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_04,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604010148
X-Rspamd-Queue-Id: 98A461C000F
X-Stat-Signature: w4sn9e9ys93aq4jnyoo3oxony7yjzquh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775059544-205691
X-HE-Meta: U2FsdGVkX19QVC3GFcDOO4yvhMrHw5s7Cac/lROtJSZEx3E2hTtLzNEerjXsSAELKstekBUHPTs2Y1dWIkImwRhXtHUJYMg7xgtI64fMSaDRllt9O1M2RJKZxzGIdq0+phn7TyqjXnmlfx2rHs/VmTcvK8PauwucUVnkuAnj8mrahiBE0ZPG9aOjJE7ckyYPfwp9AYFwiyeammVcmOS0ROegudtooYR2FKfFN9GNpJxF6STGuqwNcxMmS27NBaxO1YRLsWWvmFQGX84eKr1mfpiQ0Yut6XG4pdEs2NHv2e37uQ328jBuyJ2dlJC5IuOpV0W1TI3P6l1vV9rXfLi5xULSldXpwHn0e2m4QOFP0dLEGoTAcZxIiL3do2T0v7rdWC96GJ1/fQ4UDxbk1JWvfcIPD22dA+NMVDyJ0STVdwKF4aZteZfKDJKk1YAAaQAy/sbZKbBFGcUdeWqfyjuQP3HlOexlzfkS4Zh4gnnHIhC1pA9i7uvSpKeVPfGESE9qTvDQGMQgar+o+NR2nx78peDW+VYyjzo+qYzjCj64PeCbu/d8wgFCpouggtNit/8aYMULps3Tt/ycTYxskTlmcXQ08I7Efg9/2xiqYYd1OvGD6BItqz1uUvnIW6LM+f5gl+K3XS+QY2qeZNxu3Ppk4UTPxvA6XZxiMha/QhZY/F62c2W9MJsKwA9PqyJxyYqKhTWBSOFlWndjbWHuGPOT/kP9vGTcrd8mn0ZeU5MNxr/NceHNzI+kWgFlrX3FuNk+wjHHTyrOIZg5JVSxSao089GerUweE6U61SUVjjxENf1qPch1Y28cnMFcAXGsZ/wZyUmBfW0goPhi/HdFt0pQNnq6AzVj2m/3FDewvKaEGhuKD3TIGMrDUr7kSKhpoWLXvZFG8zlSchyAva5xbF7/r5ShVP0A/Acbfyo6chQd8Gp3/SIAiUIAKSsIT696bIfpAN9hIK7zRknUa66YSWc
 MW/N9Qb7
 p6BJF8TwOP0uWohhVoSvH4OPuYoUssOAxklUosdxz5XLJwmd+u0ODF200PIaQ6bzZ9G0CgiRuR424l1xjD8tsM7GU2Oq8Gh3taZ1l4NONBIn2szj/cQm5c+e8cKNz8yGWxwy0p+aKRV91ALAHSPQ+/8jQW/a3wpKyl4ux1lkcIEBAV4NngNc5BEkYfphVNBFfxClMyiKXwVR9fwuewbGseFkSjn7+u9EVibKLmqPG/Da6bXQ1XYp3bwPd4bsuxZene+mDBKnlDe7rg70+I65XYTNfJTsiazAHq5kNQeaHznmwFp/SBLmEARcl65aGbpDUTTQAGvys4Vuf4vbdBmE1qKAZpo7p6OLvxaVJWQrksWey+cUwi1bqOBs4MIoIPXpqM7YKewePo3yCINCqESOQITS7AExOJ8dL26DTlNMmc+fT4waDAL2lO8/FoNUUjvDGiJ5hwIrnLVuo30yETuWJ8EQIytglADY+8pgWw41W8+yCYoV4+tHCxjLNkv4I/aHE36TCr9j1Po2/61stoN6HFNhksQ2O0YK6wmlCTrVMspYxMI0cnZSoWq91zDGiDTheztTBm9bzMLClC9dc1nayQH3Hg0a3mBaCnJ2gAJb+HLEZieKjjIiy/XTwOFJsCyjNQf+cf3eCz6Jeoj5TU+kV89iyGJykyLyruR3jZxu2SdtLILWvnAF101ZCouA0V4UqtdyW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------Z1mtNmbpFyIZY1A5sUbCG03n
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 01/04/26 20:22, Sayali Patil wrote:
> On 27/03/26 12: 45, Sayali Patil wrote: During cleanup, the value of 
> /proc/sys/vm/nr_hugepages is currently being set to 0. At the end of 
> the test, if all tests pass, the original nr_hugepages value is 
> restored. However, if any test fails, it
> ZjQcmQR
> ZjQcmQRYFpfptBannerEnd
> On 27/03/26 12:45, Sayali Patil wrote:
>> During cleanup, the value of /proc/sys/vm/nr_hugepages is currently being
>> set to 0.  At the end of the test, if all tests pass, the original
>> nr_hugepages value is restored.  However, if any test fails, it remains
>> set to 0.
>> With this patch, we ensure that the original nr_hugepages value is
>> restored during cleanup, regardless of whether the test passes or fails.
>>
>> Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
>> Reviewed-by: Zi Yan<ziy@nvidia.com>
>> Reviewed-by: David Hildenbrand (Arm)<david@kernel.org>
>> Tested-by: Venkat Rao Bagalkote<venkat88@linux.ibm.com>
>> Signed-off-by: Sayali Patil<sayalip@linux.ibm.com>
>> ---
>>   tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
>> index 447769657634..c9fe68b6fcf9 100755
>> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
>> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
>> @@ -65,7 +65,7 @@ function cleanup() {
>>     if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
>>       rmdir $cgroup_path/hugetlb_cgroup_test2
>>     fi
>> -  echo 0 >/proc/sys/vm/nr_hugepages
>> +  echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
>>     echo CLEANUP DONE
>>   }
>>   
Previous reply was not formatted properly so sending it again.

AI review question
> Does this cause excessive memory allocation churn during test execution?
> Since cleanup() is invoked before and after every test iteration, restoring
> the original nr_hugepages here (which could be thousands of pages) and then
> immediately setting it back to 10 in the next test case forces the kernel
> to repeatedly allocate and free many hugepages for every single test case.
> Also, does this reliably restore nr_hugepages on test failures?
> The test script runs with "set -e" active. If a test fails while the
> background write_to_hugetlbfs process is still running, commands earlier
> in cleanup() like "rmdir /mnt/huge" can fail with EBUSY because the
> directory is still a mounted filesystem.
> Due to "set -e", this failure causes the script to immediately exit,
> completely bypassing this restore command at the end of cleanup().
> Would it be better to restore the original value once at the very end.
>   

Yes, it is better to use an EXIT trap here to avoid unnecessary allocation
churn and to ensure the original value is reliably restored on all exit
paths.

A similar change can also be applied to |hugetlb_reparenting_test.sh|. The
test modifies |nr_hugepages| during execution and restores it from
|cleanup()|, while also reconfiguring it again in |setup()|, which is
invoked multiple times across the test flow. This can lead to repeated
allocation and freeing of hugepages.

I will prepare a patch for both tests and include it in v4.

Thanks,
Sayali



--------------Z1mtNmbpFyIZY1A5sUbCG03n
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 01/04/26 20:22, Sayali Patil wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:2f5da9dd-812e-4645-8340-de8c6beec584@linux.ibm.com">
      <!-- BaNnErBlUrFlE-BoDy-start -->
      <!-- Preheader Text : BEGIN -->
      <meta http-equiv="content-type" content="text/html; charset=UTF-8">
      <div
style="display:none !important;display:none;visibility:hidden;mso-hide:all;font-size:1px;color:#ffffff;line-height:1px;max-height:0px;opacity:0;overflow:hidden;">
        On 27/03/26 12: 45, Sayali Patil wrote: During cleanup, the
        value of /proc/sys/vm/nr_hugepages is currently being set to 0.
        At the end of the test, if all tests pass, the original
        nr_hugepages value is restored. However, if any test fails, it</div>
      <!-- Preheader Text : END -->
      <!-- Email Banner : BEGIN -->
      <div
style="display:none !important;display:none;visibility:hidden;mso-hide:all;font-size:1px;color:#ffffff;line-height:1px;max-height:0px;opacity:0;overflow:hidden;">ZjQcmQR</div>
      <div
style="display:none !important;display:none;visibility:hidden;mso-hide:all;font-size:1px;color:#ffffff;line-height:1px;max-height:0px;opacity:0;overflow:hidden;">ZjQcmQRYFpfptBannerEnd</div>
      <!-- Email Banner : END -->
      <!-- BaNnErBlUrFlE-BoDy-end -->
      <!-- BaNnErBlUrFlE-HeAdEr-start -->
      <style>#pfptBanner6bb4zwh { all: revert !important; display: block !important;
    visibility: visible !important; opacity: 1 !important;
    background-color: #d0d8dc !important;
    max-width: none !important; max-height: none !important }.pfptPrimaryButton6bb4zwh:hover, .pfptPrimaryButton6bb4zwh:focus {
    background-color: #b4c1c7 !important; }.pfptPrimaryButton6bb4zwh:active {
    background-color: #90a4ae !important; }html:root, html:root>body { all: revert !important; display: block !important;
    visibility: visible !important; opacity: 1 !important; }</style>
      <div class="moz-cite-prefix">On 27/03/26 12:45, Sayali Patil
        wrote:<br>
      </div>
      <blockquote type="cite"
cite="mid:2ba0f8d8a00fd049e8ed4b97e9ce8ee6b58a2892.1774591179.git.sayalip@linux.ibm.com">
        <pre wrap="" class="moz-quote-pre">During cleanup, the value of /proc/sys/vm/nr_hugepages is currently being
set to 0.  At the end of the test, if all tests pass, the original
nr_hugepages value is restored.  However, if any test fails, it remains
set to 0.
With this patch, we ensure that the original nr_hugepages value is
restored during cleanup, regardless of whether the test passes or fails.

Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
Reviewed-by: Zi Yan <a class="moz-txt-link-rfc2396E"
        href="mailto:ziy@nvidia.com" moz-do-not-send="true">&lt;ziy@nvidia.com&gt;</a>
Reviewed-by: David Hildenbrand (Arm) <a class="moz-txt-link-rfc2396E"
        href="mailto:david@kernel.org" moz-do-not-send="true">&lt;david@kernel.org&gt;</a>
Tested-by: Venkat Rao Bagalkote <a class="moz-txt-link-rfc2396E"
        href="mailto:venkat88@linux.ibm.com" moz-do-not-send="true">&lt;venkat88@linux.ibm.com&gt;</a>
Signed-off-by: Sayali Patil <a class="moz-txt-link-rfc2396E"
        href="mailto:sayalip@linux.ibm.com" moz-do-not-send="true">&lt;sayalip@linux.ibm.com&gt;</a>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index 447769657634..c9fe68b6fcf9 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -65,7 +65,7 @@ function cleanup() {
   if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
     rmdir $cgroup_path/hugetlb_cgroup_test2
   fi
-  echo 0 &gt;/proc/sys/vm/nr_hugepages
+  echo "$nr_hugepgs" &gt; /proc/sys/vm/nr_hugepages
   echo CLEANUP DONE
 }
 </pre>
      </blockquote>
    </blockquote>
    <font face="monospace">Previous reply was not formatted properly so
      sending it again.<br>
      <br>
      AI review question
    </font>
    <blockquote type="cite"
cite="mid:2ba0f8d8a00fd049e8ed4b97e9ce8ee6b58a2892.1774591179.git.sayalip@linux.ibm.com">
      <pre wrap="" class="moz-quote-pre">Does this cause excessive memory allocation churn during test execution?
Since cleanup() is invoked before and after every test iteration, restoring
the original nr_hugepages here (which could be thousands of pages) and then
immediately setting it back to 10 in the next test case forces the kernel
to repeatedly allocate and free many hugepages for every single test case.
Also, does this reliably restore nr_hugepages on test failures?
The test script runs with "set -e" active. If a test fails while the
background write_to_hugetlbfs process is still running, commands earlier
in cleanup() like "rmdir /mnt/huge" can fail with EBUSY because the
directory is still a mounted filesystem.
Due to "set -e", this failure causes the script to immediately exit,
completely bypassing this restore command at the end of cleanup().
Would it be better to restore the original value once at the very end.
 
</pre>
    </blockquote>
    <p data-start="0" data-end="153"><font face="monospace">Yes, it is
        better to use an EXIT trap here to avoid unnecessary allocation<br>
        churn and to ensure the original value is reliably restored on
        all exit<br>
        paths.</font></p>
    <p data-start="155" data-end="474"><font face="monospace">A similar
        change can also be applied to <code data-start="195"
          data-end="224">hugetlb_reparenting_test.sh</code>. The<br>
        test modifies <code data-start="244" data-end="258"
          data-is-only-node="">nr_hugepages</code> during execution and
        restores it from<br>
      </font> <code data-start="297" data-end="308">cleanup()</code><font
        face="monospace">, while also reconfiguring it again in <code
          data-start="347" data-end="356">setup()</code>, which is<br>
        invoked multiple times across the test flow. This can lead to
        repeated<br>
        allocation and freeing of hugepages.</font></p>
    <p data-start="476" data-end="535"><font face="monospace">I will
        prepare a patch for both tests and include it in v4.</font></p>
    <p data-start="537" data-end="553" data-is-last-node=""
      data-is-only-node=""><font face="monospace">Thanks,<br
          data-start="544" data-end="547">
        Sayali</font></p>
    <br>
    <br>
  </body>
</html>

--------------Z1mtNmbpFyIZY1A5sUbCG03n--


