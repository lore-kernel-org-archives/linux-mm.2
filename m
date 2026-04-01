Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A30CE10F6FB5
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9F016B0005; Wed,  1 Apr 2026 10:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50306B0088; Wed,  1 Apr 2026 10:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17186B008A; Wed,  1 Apr 2026 10:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADA46B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:53:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49F5E1A0704
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:53:07 +0000 (UTC)
X-FDA: 84610279614.18.E476374
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id DAA131C0007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:53:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="KPS1Zq/3";
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775055185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mU5QVu1EHsg2q/n977oobe+AMZflaJO1Rx59stgMgho=;
	b=IQFXUkTQKsgv9fJfq95Mn1Y8OPLNZ35jDHeo1jvkeIrn5CRi6j2/5rbQR2do4CnQKG1sZy
	8ovnsQPAhqx70+W3PPJs50McVkwX+tSsSnPul0HJwpz59uv28i2uw2VhSRcAnkprvFfLgG
	zA7fP6DqER9JASiuXanAgBT+Y5ovmTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775055185; a=rsa-sha256;
	cv=none;
	b=Wdzof0O72lqogNIX3jpM7A60pLYJMjTAVkIEvWccmt5drOBvz7+7DXqKdrne1+J1vfpSHx
	LFfzHi7j+PYqTV+LTu/HBh4XNKJ7YV19VpW6LPqHiJH3miKxgeCz1JW752fIJ1RAjM/b6h
	fm3jcxJ2GAc0HKw/xysAFHmLnzx01ds=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="KPS1Zq/3";
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631CK1CX213344;
	Wed, 1 Apr 2026 14:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=mU5QVu1EHsg2q/n977oobe+AMZflaJ
	O1Rx59stgMgho=; b=KPS1Zq/39JS1771SONkjCp+fgGD4jrscKXjDteCbggCTic
	rep84bBkD5RWnR8vSsQc1gYKQjHwfOH9sNXtuuUTEbajjkzk63XiZ6eYd0166iDk
	oXWOVh08O6XjjLInGP0q+F/beeicXFC/rlR4eQYA6T42ux5clc0P9RnDpLeSX84i
	KeFMRSQFRefMcayMLC/j/Y6O/796fnZ5d2pjBjmAFOL929j+pbIuoBquTV9DuQ+x
	CWWUNpo+tKj3Yy0AlWFJ+4NnWvvijjiKb7WTyT1CWgA7Mo1hv1U9nIwiuKVSxsNE
	M5VmORsAgeG1TQC2lfInK4a78UvzvOwoRWWSiuYg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66ms7x68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 14:52:58 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 631CVBtE030947;
	Wed, 1 Apr 2026 14:52:57 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6uhjwwgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 14:52:57 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 631EqulN64815386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Apr 2026 14:52:56 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD75D58061;
	Wed,  1 Apr 2026 14:52:56 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6FDE58057;
	Wed,  1 Apr 2026 14:52:51 +0000 (GMT)
Received: from [9.39.18.42] (unknown [9.39.18.42])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Apr 2026 14:52:51 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------dNjMfuJP0K3YtjyprlSlepNv"
Message-ID: <2f5da9dd-812e-4645-8340-de8c6beec584@linux.ibm.com>
Date: Wed, 1 Apr 2026 20:22:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/13] selftests/mm: restore default nr_hugepages value
 during cleanup in charge_reserved_hugetlb.sh
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
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <2ba0f8d8a00fd049e8ed4b97e9ce8ee6b58a2892.1774591179.git.sayalip@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=J6enLQnS c=1 sm=1 tr=0 ts=69cd314a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=r77TgQKjGQsHNAKrUKIA:9 a=Ikd4Dj_1AAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=DsmMYOnS3WCRA5PgjzcA:9 a=QEXdDO2ut3YA:10
 a=Npm3-rHHuYopk5QS1gAA:9 a=hdD9j4zQEDQSeOzc:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDEzOCBTYWx0ZWRfXw3Wze+pj89wa
 T0vOjsJyg+a5wyi5syyyJvELUlNMvt1J30RLpDZUPyO42mzI4svIBPiKfR6Et1aQzkEEyCCBGpk
 eC1B5jHfYtLwsAiStzzXD4WG0dAmRoA5gRKy/7EkqJtFEPKlvk694cTFJDBMTFbeW6azhYAuDVb
 hvZIcJ+Me9FRyqEgLCQWjuDNjcka5NFnmiIKoD0ZstKjoeAufUtbYtWoX4saKyD5f4wZ8/ht9rV
 PzZH1cR696lwYIMBjPDyd945x3Bzm1pn0Qt6dUfcSPlRug4DFvyB5uJgrHck1zT3C9iP+fqi5QA
 X2oW3/r9PE3O63bDW0qZCAe3v1HqOpHOK3sUiSSHeqm5qOUJznzlbxqtR4uK3W2UceWXB/JGiEh
 bZeqabj5xM8KS/vmzsn3hTS/qqfEl3DLDcZ0QkQOPmz9DsUOYit6cJAmmAq6/fJECXyZ5qpp+vx
 +GerPXxJ8gf/M/7czjw==
X-Proofpoint-GUID: GESm7jRs_ey03Sr-d5jD0fDZ7-G9noAK
X-Proofpoint-ORIG-GUID: aX4UaqkiSG9zzk_jQhxsXTTpMPpKoP5I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_04,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 adultscore=0 priorityscore=1501 bulkscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604010138
X-Rspamd-Queue-Id: DAA131C0007
X-Stat-Signature: 8dg5fycfeuwa5aw744bryep5i7x1cu66
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775055184-283850
X-HE-Meta: U2FsdGVkX1+J+fH/EwO3RKhZfCRfbt5Tt7ZpdiPzpZFfjO1NxQ8toZLg2klUue5jh8t/ZjUm31K32sujq574mPNxljMoWYWsx/Ya/3GYggnQsEpSRkovEpBN7NeaeO4RNH0+knsstjxu1NUG1xBVMoCFqUXt4vhKJDsclja64xIkrmgTDOQ0y355tPOySoMjBLMP2+NV/LhFSkyvH+DuuR3jo6ZFm4L4yKoyfIuM/autDXQpFDbaSsdB0zeHDq5jbr3ts9bMgOILdD5VTiXjAyjD2wAxbuco8uGEcHkCWH/k+iaEqTzO9Q30B9oeBZL3JPRqvF0d4QAiEcbI7aGKcDagoq++gggl2soWg03eQUUL6pieTgg7RBGe+BmTK7tHy18yPu3aLF6x/f2h58uZ3aO/PRCKVtreFYyxb3MAzaYRtLASJd1f7m/2q2TaoY2eB/oMvPjlE5gqnZQzFpnu+oHdD/wcHG1l8DPygG9Ag8wFncca0jlXUNLm0s8yJrnrcfpR9q+Syy9cikoztbqXYfQfDbSnYPKUt1VceBAzylDvL55QUbs6il6Ev0eUqprkQHXf2styqfwNYBzv5sltUrXxzbQprDQMBIOEV6qQaHdGR9HhfIix7WSLqwcHRG7/C1gZAXCD/kccsVxGKYV2UbB6nFpSF7BIrS8d11bONKzozCNaYynLZmt7tPIxGJB0miUuuYe4O6FeYCaYLKrx131oTnBqvGXV1FYPSSwLoNtMhYuxVXOj5QTHlkKaegn0jMfZZVKAmMSNU7+jutLTO2KQFYgmgjr5HStiTKc7UBSVx3I08dLR2MDCJWiI96kk+KSAHIZU5Vd0bkxCbzZKns5dGibX+h6C4jsT8SKktd+pYpMJUm0vHeYI/5/IgOhM2RhPTVb4QyJ0P761fxR0av8LqChgom2XAEHkwM+D4vonAOsKheB9j+E5298KiG1cuOoXyazDkNbLeaHXO8i
 0/Dwso2B
 ZYRtMw9KncgAoSuwfelqoe9jIGrJfyrWv7GkZUnz06LeptiTBq+gcIgHBQ7CP23760aqkCGo/8FqXuo6PPWSV6Bck4PY+1J9D94hQYw+wK0Jg/PbeqzH0weOyKJyRDrIke6Z9Xa1KLEBC9fn/LcRUSzeo1dP9BMKi+RLYQwWknTXdyycs5z3x2ntdART61KiwYAoj4MTkNdQFLV6IanuQBZ/KR/XxNOHvMyWin474nbj0dyZZXdWj1on4xKjA5TmA18ieiSzaaoaxNArYjHbuacNWNdokBE7C06dzJ0Tqt8E1WWVSRezUqTGIO4J4frw7FjHH4MyBVtKvvEc1GrovJJJ/hIPlJgzKb7hmnEs/zr4QqjxqcU41ZFd2HpMOs/Ys0GV5b2ZoQZrqkozbBnjKn1KRKo+tFg6vmNKdf63NHfmTU9hotzoPyDARIR4kMGOaYj7s62A/ozVAsAatNl34TzJy0DBl1/rH+7jwLPhKWCBbw4OP3Frnk54x06Jzn/koTewWnyzMB6oB0VJqGtTn4e0w3gDFQakf1eWWYoBRRR/HxpcC3qm7Ua+XHj5VNbt9wrLwkOK2vG2OgxIx9hE5npisrTcCtxb5b5vvL1eCI4HCgz82Tgc+uXqu0q+olqbfh9Cye+tsGlHpkU/DO5sG+Ivw6AWK8jBSEsAG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------dNjMfuJP0K3YtjyprlSlepNv
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 27/03/26 12:45, Sayali Patil wrote:
> During cleanup, the value of /proc/sys/vm/nr_hugepages is currently being
> set to 0.  At the end of the test, if all tests pass, the original
> nr_hugepages value is restored.  However, if any test fails, it remains
> set to 0.
> With this patch, we ensure that the original nr_hugepages value is
> restored during cleanup, regardless of whether the test passes or fails.
>
> Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
> Reviewed-by: Zi Yan<ziy@nvidia.com>
> Reviewed-by: David Hildenbrand (Arm)<david@kernel.org>
> Tested-by: Venkat Rao Bagalkote<venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil<sayalip@linux.ibm.com>
> ---
>   tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> index 447769657634..c9fe68b6fcf9 100755
> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> @@ -65,7 +65,7 @@ function cleanup() {
>     if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
>       rmdir $cgroup_path/hugetlb_cgroup_test2
>     fi
> -  echo 0 >/proc/sys/vm/nr_hugepages
> +  echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
>     echo CLEANUP DONE
>   }
>   
AI review question:

Does this cause excessive memory allocation churn during test execution?
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
Would it be better to restore the original value once at the very end
of the script using an EXIT trap instead?

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

--------------dNjMfuJP0K3YtjyprlSlepNv
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 27/03/26 12:45, Sayali Patil wrote:<br>
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
Reviewed-by: Zi Yan <a class="moz-txt-link-rfc2396E" href="mailto:ziy@nvidia.com">&lt;ziy@nvidia.com&gt;</a>
Reviewed-by: David Hildenbrand (Arm) <a class="moz-txt-link-rfc2396E" href="mailto:david@kernel.org">&lt;david@kernel.org&gt;</a>
Tested-by: Venkat Rao Bagalkote <a class="moz-txt-link-rfc2396E" href="mailto:venkat88@linux.ibm.com">&lt;venkat88@linux.ibm.com&gt;</a>
Signed-off-by: Sayali Patil <a class="moz-txt-link-rfc2396E" href="mailto:sayalip@linux.ibm.com">&lt;sayalip@linux.ibm.com&gt;</a>
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
    <font face="monospace">AI review question:<br>
      <br>
    </font>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Does this cause excessive memory allocation churn during test execution?</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"></div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Since cleanup() is invoked before and after every test iteration, restoring</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">the original nr_hugepages here (which could be thousands of pages) and then</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">immediately setting it back to 10 in the next test case forces the kernel</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">to repeatedly allocate and free many hugepages for every single test case.</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"></div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Also, does this reliably restore nr_hugepages on test failures?</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"></div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">The test script runs with "set -e" active. If a test fails while the</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">background write_to_hugetlbfs process is still running, commands earlier</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">in cleanup() like "rmdir /mnt/huge" can fail with EBUSY because the</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">directory is still a mounted filesystem.</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"></div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Due to "set -e", this failure causes the script to immediately exit,</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">completely bypassing this restore command at the end of cleanup().</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"></div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Would it be better to restore the original value once at the very end</div>
    <div class="diff-line ai-comment"
style="box-sizing: border-box; display: block; padding: 0px 4px 0px 12px; min-height: 1.3em; background-color: rgb(255, 255, 255); border-left: 2.8px solid rgb(40, 53, 147); font-weight: 500; color: rgb(36, 41, 47); font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, monospace; font-size: 12px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">of the script using an EXIT trap instead?</div>
    <br>
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
      </font>
      <code data-start="297" data-end="308">cleanup()</code><font
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
    <span style="white-space: pre-wrap">
</span>
  </body>
</html>

--------------dNjMfuJP0K3YtjyprlSlepNv--


