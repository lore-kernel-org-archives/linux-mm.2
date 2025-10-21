Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A831ACCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA148E0016; Tue, 21 Oct 2025 05:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1B68E0002; Tue, 21 Oct 2025 05:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09058E0016; Tue, 21 Oct 2025 05:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEC0F8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:21:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C32711A020
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:21:25 +0000 (UTC)
X-FDA: 84021578130.22.33F03A9
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 04F39180007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:21:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Lm7ZDnRm;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761038483; a=rsa-sha256;
	cv=none;
	b=wlz5N3Hz1w1xkgAw9PYJRrtIMEAjT4CKX4km/9DBuTM2YPy2UlaZm1e/R8pocNSxcbbrmz
	ZwluG8qkpOOMMJWdulDeWrMM4+fKqL2AdwrbA6xxuqP77Q5Xp6LQJb+jGPcwVwLcmqxNfU
	tHsVS3bOW93ztPO2i78tDNmqwXKPx+U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Lm7ZDnRm;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761038483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s437rTzYUnWFi33s/IAzTngxdxGHleg4CrKG5h21jWU=;
	b=nLb6jCRe7IK2SFI03HtEtFlhPjlWGc0zxoitGBuD8/7xr5vpUFqAdpwLtSvzyWIoow4/G/
	P9/IjBbHdtWROTOYKSO8q2nk9rg1eRD5i8ePn5uHAnFJuRdA1fpIZfP9oMoLvGQeOzl7Vf
	NwrobNsKj8D3pAryowtblD1Z/VtW7lE=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7Tll7015154;
	Tue, 21 Oct 2025 09:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=s437rT
	zYUnWFi33s/IAzTngxdxGHleg4CrKG5h21jWU=; b=Lm7ZDnRmEm8Asih1h3HfR9
	GlYeecRoFSzxB+kD2w8Gmo3FsZEW7tbB9mBHGeWY1ShXrkl91lQzhxHU67vI0C+7
	VhrUfLTVoJqrV/RYAH4xEEEkvDOirIBy8wY/ApffZQRtsZi/eDsqixytmW7fNztK
	R7AOjlO56+UbfpP67ubVIznpayfyjexyiPXrPJdzBw0yxxb7L6EbrkmvrWPzHXJj
	PBRVe72iF4XjCkvJ+vgk2i6/vt0LogFIKgcJOImUBWwiKpGqIkuBPIqZlKXL4fL5
	7IWIUW8wVKNKNsNHsFwQX/0nb87vEO9PnuwqJYLLTY8XORxySnsmc4zV/1y0FqZQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31rx5dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 09:21:19 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59L95vJl018148;
	Tue, 21 Oct 2025 09:21:19 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31rx5dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 09:21:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59L9KIZ7002281;
	Tue, 21 Oct 2025 09:21:18 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqej9sv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 09:21:18 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59L9LH5E21234242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:21:17 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8128C58066;
	Tue, 21 Oct 2025 09:21:17 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B1F358061;
	Tue, 21 Oct 2025 09:21:13 +0000 (GMT)
Received: from [9.39.24.41] (unknown [9.39.24.41])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Oct 2025 09:21:13 +0000 (GMT)
Message-ID: <8a8ba27c-f924-4feb-a63b-565f385dd60f@linux.ibm.com>
Date: Tue, 21 Oct 2025 14:51:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: Fix indentation in fold_diff function.
To: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jinnasujing@gmail.com
References: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VKfjcMz3bHcS-Ai5IZ4jR_yl8h3-KwmI
X-Proofpoint-GUID: PMGkBWgGzlnpISJrr7OazhVD0nUf9Q_T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXzKYg+W7wkVe+
 ZXaeyILcadj83zh2g2OBfsHgPQuD4l9rCifJRWlFP5XRXKRRPmwSLQja0zoOec6gqz3Y14f1DdG
 GwVufDdEtMlVvp+Ty5wObJa8uA9pAykulIvwmPdySsd1fcr+DLC3qreb+IXMqsIukyhdqsxoSrF
 h4Qe/yxEZViGd19UrrWTcHzWdDpZsnMkqK2lA9LjVP+Le0xThRPBRLVL4ZNp1HLt5Uic4KvYC3E
 cbb56slDMtkykNepEH1ouYYNNhhSFlnnBGyNLvhvwrlD0k0QdXr4y4g9G0/94UPsitzZiBZkcDd
 Z125HvGQs30hj1N10t++oXRYNn2a0xExjKgcPHjq4+j4eau6bOQLdhfwCjfLohXjPlBm8H2zXi0
 DQNwg8GKfAYDmykJtGuYmjTOjNmLMA==
X-Authority-Analysis: v=2.4 cv=IJYPywvG c=1 sm=1 tr=0 ts=68f7508f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=DyMV3BnNAAAA:8 a=VnNF1IyMAAAA:8 a=2ecftfDPbqYspBDr8a8A:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04F39180007
X-Stat-Signature: jfj3inzasp8h694geif36q1b7xrnhjtm
X-HE-Tag: 1761038482-551854
X-HE-Meta: U2FsdGVkX1/GxMHxV1EbTZyffjNlYUiqCr/wiaRBrKCNaLnNQ0Ol66EL9HaePcUW2TnVwTxTZVsfrslO3/Kfl3tEEt1UHeK5SgLGrM9iXwsjA0Tk2vF4KGAoXorqokhOGVhTOHjNtFpIgm5Ng2uCYjebUh7eWO9Dfk0iDIfX7rff39RZ9+v59uJ9kEF9NQC9BQEtd8LpR7yHWq+hGQy94Fy/EnYeTR7V4INdfgpg0U+ls3pupqb6bE/ZMBi2SPEgGYsRVwug9omBhsQYGIZ/DoNHMDxaKx6Mh9JNw4qiXtpGVEEWZf4I/jfSWay87ixXOzzcPUGtrfyLEaZKfhT/jTW4DG5rZLm4xWgryIhAQQIhW+f0LEdk7nFhok5o/orbu9s6/XEhvjCsxGHhknlgf95sNnixu6b3I/fr8wCvMK35TiTsmvzGLi377a95nRerMNX/S99qLaMXoc6Dbu2QSrsitYAmgUed8GsMLnKy6Xhb3Zvr2HpxK4fyHkdR2cwm7+3vtzTPerI7zgIZ1uOPzHGIPfGLhKFWC2USv1blppQKP32vwZN3UobhgQekO0L2tst00rioOMTWTQppRx+k4suMLprJk/fYRr7tzuNXsqGLLyYiY2bk3Sf4h1eSghoTT3QIq6p+q47IUUv4M3AX8njXbk8T4OViEb4J2zhamS3gxhcPf5BYke9Qg/GoHKFMAsHRVPqJvD0NjttT87J3jEP01YnganbB7xIhGlaaEMoeauGz94CXSxfzwVQHiJ1pV5v6FfRI7aMpxzbxfJezYEjGFDD3ANKEoSCs1auj9x+Izsu1PXtIprp/WDrwHn9NDtgb7qoAfzIzsf/B9gmWdRKCraHcyTx/gzFfOnNm6tYjO//Yf5F+pTc1rPmhXstepaECVF2qdb9lO00g8qVMnHxGezRVkvsfEfEOVDZnc/Oz0JqRUNf6jdgzX3Jk43tiRqmPcPi4ffDj5TMRhKU
 hT5jMkaO
 x9Ag1dNqDbBgdUKUjUxy5lhT3r6el7IdN35+NLHbwhcwraEW14P6VNEzKN/u7HaPQ7KCWGTx3flHui5qnOtCua+G9nsv6O0GlTU8L5f5VrWuvcclSJbJs/XTXG0840Odbg30QPIOG/fJlImnMp0f/G4dgJGf7KcI8r5Whd4ZXDt6l2UK7h+By9je1KbhtBkgWFlVrdGwo8xIizN6hPlHAREbLGMcyPNulSQN3wLkMNUdRbzIHNAUKGUPf7eSEIACIXXzr5Br/PbaOk+F1swrdrQYe1tqy8X+aYhQuLS9k/xW2QhX2knh9PEU8Ep5gaS1Gi/1ZX2Z8ns/RvcPPdHDo1HyCN4QCjMj3lVTuuvinvBFlAdgCclv7ubkO8p1Ry6DuLPsg2Q3xlLQGwFe3x2BB+cVZPqeaiLDm1uoy5WMmTK4WE75ij/eUL55HytEMk3GNiSA5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/21/25 1:07 PM, Jing Su wrote:
> Adjust misaligned braces in the fold_diff function to improve
> code readability and maintain consistent coding style.
>
> Signed-off-by: Jing Su <jingsusu@didiglobal.com>


LGTM

Reviewed-by: Donet Tom <donettom@linux.ibm.com>

> ---
>   mm/vmstat.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index bb09c032eecf..63860c3d22e6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -782,13 +782,13 @@ static int fold_diff(int *zone_diff, int *node_diff)
>   		if (zone_diff[i]) {
>   			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
>   			changes++;
> -	}
> +		}
>   
>   	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
>   		if (node_diff[i]) {
>   			atomic_long_add(node_diff[i], &vm_node_stat[i]);
>   			changes++;
> -	}
> +		}
>   	return changes;
>   }
>   

