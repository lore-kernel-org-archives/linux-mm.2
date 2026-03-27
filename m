Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 288C710BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDE86B00CD; Fri, 27 Mar 2026 03:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4E56B00CF; Fri, 27 Mar 2026 03:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB896B00D0; Fri, 27 Mar 2026 03:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2806B00CD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:17:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25866BE3BD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:32 +0000 (UTC)
X-FDA: 84590987544.16.CBEBADF
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id B7115180004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=U01kl0Hn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3nsIkBM1wG/MkAMYmdbck8ds+Cs5SpVHNbEVNKZh0hg=;
	b=UnCssB5JzibdB8YYBqzNcn77ADwQpBlYxuRmBWod5xbWRuuv6cL4R/mDMN/PMoyCC6UxAw
	jY3tmssHyZ+6SofdpRCREznNC3Avlttz2+OYw6PO3hrMA0jCoevtAGCxkKYU3Tx52Y//4S
	QGsFUXbKg9Ofu6rMfAwfl5V8TxKm2w4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595849; a=rsa-sha256;
	cv=none;
	b=mC/6LyxbFmSYTCESpNbmbvYQ+51l8WMp3fmFg8egjl6NpCGDnxqljHMiiQPGuUzI6gHXL5
	v2uAyvWf94VE84WOJEdqgmFAPMAVCmpTUdxipZtws7SqHcrPvCaZiMoChTUjLsjAuOGPnD
	QRl/4DzMzPfD/3g0/wQn5YvPnuXkbj4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=U01kl0Hn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62QFxoxW755965;
	Fri, 27 Mar 2026 07:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=3nsIkBM1wG/MkAMYm
	dbck8ds+Cs5SpVHNbEVNKZh0hg=; b=U01kl0HnbWbWEn3cLzZHZ+gl5ReyZgHoc
	Gf6Kv7otufWMVDcKB0Uv6sc8wPbEviH823VCUUbsD9zpzYgM6bSisgglr534uf9a
	qrS8NKAl18PKWRsqDApfgxveil2LO6ODYy0Kk7t0dR0IfOW41E37LBM1RWEQ+nnl
	1r5qF4AfHvT/+iFQGhWFOifT8khAam0b88Z0MZO0k0C9kmBqtAjUtr3bqbYULfK/
	Azk0qDQ3l04MBVpjnBWLjhARp/vNdeOhOrLzHcpBfpZL77Alt2FnOQfq+O4IfmLI
	ifcIveyu9HztyEzIPOqzm38yIOQc5pLmZ+CUVLpCvhUU1FPKhWQ8Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kty8x9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R68v5w005976;
	Fri, 27 Mar 2026 07:17:23 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d261yxkwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:22 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7HIq248628078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:18 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A563520065;
	Fri, 27 Mar 2026 07:17:18 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E08FF20043;
	Fri, 27 Mar 2026 07:17:14 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:14 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH v3 01/13] selftests/mm: restore default nr_hugepages value during cleanup in charge_reserved_hugetlb.sh
Date: Fri, 27 Mar 2026 12:45:55 +0530
Message-ID: <2ba0f8d8a00fd049e8ed4b97e9ce8ee6b58a2892.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=IqITsb/g c=1 sm=1 tr=0 ts=69c62f04 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=sNPh1B-_HOrnTu1bGgIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfX5VJrdN7KDwEf
 x4LlXgWb3g2ro7KXdy8Aa74PP144Vn/m2ts6CcSt/0YWvfbO/BgJeb/lOU7AHM2zu+4fm2QO9ij
 zTQdnZLiLIg5Rfxt1a3BPHuuARV1fR1qvK7Jv7eyjLk40Ii//30IPCK04rv0YzncsIDfKmzo19Y
 5/HTVRImMymJ4jVRJuD/6gcZgX4pvNW8RlHFCC8He1e1q4wwv689EyNBGYJpGBIc5WRUOB2TPf/
 BOyPNBfn9ajcGaModU1d4t6HNRuzu2ItTXjy5GEPltVkbRwZkk7+Rzm9i3K+1FdaSoRR2U0o8gX
 kYbhKJinImAKDDIctAF8ujt8arbg8qC1Bvk35bmds775roKQ6foRiWUhGl6m03ZWG7Ha+gD0+WY
 /r+JeaptpJfBqom2DaN5uCt2yAt3u/ZB42+E/nNWZ5lTS1mHCq+Q895ayCAHsuR9wOywyqlDc3V
 aMgpwaBoYgZdR+agzyA==
X-Proofpoint-GUID: uG984jRJZLhBh8Uf2gfHgtD0VraFWQ2w
X-Proofpoint-ORIG-GUID: FPePvQfa7CAXk7r1VaI15sYSOzHNYwOL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270053
X-Rspamd-Queue-Id: B7115180004
X-Stat-Signature: ap6dzrq18tsyebpz9kbse9dxw331wf3z
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774595849-845256
X-HE-Meta: U2FsdGVkX1+QE4Ic4zsHzAIrQaM1GUtJoUQH8IPIXc3X5lEcPjdWmg9u8jzVsf4kAWD/Yqvx55MWfB0v3rOnhKJKobrKX5WevLj0so2lYH/HpbDtNTzWJ5UvSrv8NmzLM7+7JOQ7CXEcZSK1TZ1rl3HYJUWqFx9LzX90xe7SXoGvTVRZLfu8C8Dqb1SyGjgZcg+4ZMvhOpaGAPpXTc7EHzTLolMB+WbhSyXDB0MP/gB9cjeTBVYh5b5jhpmb5R7XQPoxZQuFR1zpkLLhtEG85AjsbZGtHEATWJt4qqadH6l8U0Zy/DXF4AFxKFq1LmQVnaOz2Adp85jBuMnNZbQn7G9EyQB+GwGFcxbJDg7xI+2BPe5HYK83jcwgIBwj+w5NA0LnN81Dz9j5p7CrjXCBQUVayHVH1LjNBmJMeO7u+GgawKJv3qu6BT68oAP6Ao1xjVn8X6BzyQ3UlawMUtXlqapDBpWH+FuwhF+xCM6awvz+RUJ8wO8zTjdTIyZOrM329STW57mRrQ3wZotucq/ieaYAmLBX+cPBSQ38jmCcCE/ugh4Nk/9lD2Bp29TnT62iwKP7l0837JK15banqMTggjR+POUxVbBmzGot9eoC7CQDRLWQByZNVgvfnF8+SzSN8k+wTLaySnGI6WsSapqSSQ4cChOcXtPmU96NlUCdDEz/tuQnzvj2+pl6APmFnQZiYtnNvWWDQ9A/VNYBsLI3yT102tX4XcyrkfN2V2khqodMKsWjkI1FP+WADoQ/q31JpK52Qz8cQY/9PGeVdutRMd11DXLXogd1mfo6acsNLSWSM9V+t1PQK8zakj7K4tRZbtIhOiP6rDAE2Yx5Xes6292d6TTkucZ1bp3kL4vG2j+hRFfB+TK4DGcZSrYnwwQt5oy7LaSJVdRsrPUWiEv0SS+BXR6o3SlCnAOVNiwdj0Wpz14Hz1VnqqapCSIzi9Zj/Fj6RPGkC8i2MCkFnvy
 kU29ap09
 C/NwcPjm9vst2JwOXXQ4rOWlylgg/ZBydchshb3KFj421oclKhZnpDGqK9R5e8Q/eBw157FaO5kkdCwU6YfmBd9N7dyJ6ucvPCS/+qX1RcLQudDIp6XFuPMbDAdZ5vYkmJwHnx64QPI/4a8VlbkFmxFT9ze0HOXVt03kQJP6gmFIkrZqJco6RpNxgSh5vu8JSG2MXCKea1QtPVwrbYFwDYzkjZqhNse0/YY2zXdhHmOgvVn9K0C5T0aO770cBdSCDJ10AIoj4OT21Gr3Tk03SGihYgJ331NV78yN0lI1m6Stl0ISqnEerxcTPGhc3XiMfK1kaSs9M/H6L/dp+7AJHTICPhfX2mnuqm30HQIeihVgwk20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During cleanup, the value of /proc/sys/vm/nr_hugepages is currently being
set to 0.  At the end of the test, if all tests pass, the original
nr_hugepages value is restored.  However, if any test fails, it remains
set to 0.
With this patch, we ensure that the original nr_hugepages value is
restored during cleanup, regardless of whether the test passes or fails.

Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
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
-  echo 0 >/proc/sys/vm/nr_hugepages
+  echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
   echo CLEANUP DONE
 }
 
-- 
2.52.0


