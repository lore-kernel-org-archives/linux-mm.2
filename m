Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C7E10F6FC2
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117186B0005; Wed,  1 Apr 2026 11:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE6A6B0088; Wed,  1 Apr 2026 11:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004616B008A; Wed,  1 Apr 2026 11:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E85C76B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:03:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A72FD160931
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:03:46 +0000 (UTC)
X-FDA: 84610306452.25.1463CBF
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0AB87100014
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:03:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ivmOjzWI;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775055824; a=rsa-sha256;
	cv=none;
	b=S7VqZ6K1qvN/2xLBOEzwr525ZhBv4tSO591JyaALNQnSnk2d73k1/wDr/6w9OqsRvBMdTd
	Te64OFCcTCezE4kBs+fv38Aq2om6r4Hls5pcrPWgarg7+i0LnxzYFoNLXmKxZxk9PHom+a
	Ekiy7baMq7DRNibVpx4GfPalVr0Aagk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ivmOjzWI;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775055824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lp+WZwKNTdLWUL5MPMrTQAFDSd+QMnFxI3GLoXW7Rt4=;
	b=mOTELa/2iW3uUN0mIzdMr3NcyI7SO7Lc001qbDazCTrDwKJZ2SSLZf5XN8t1KbHkCl1FR/
	C7GWbnsfDvoccLniXxdsAk5ghMjQp5quaYN0gVpdUWBRd03Nh1MoYBNLCID16dh+PemsSk
	zicgKfx/jJ7GDbca8HPegHO5rYrhedE=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631B7PoW4078893;
	Wed, 1 Apr 2026 15:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Lp+WZwKNTdLWUL5MPMrTQAFDSd+QMn
	FxI3GLoXW7Rt4=; b=ivmOjzWIX8uKMGbeCrbhJYfPzOChvOOAl4vEzrVTBx9SLQ
	xYcwtazeyaT5K9+DAJ9pYANDBKR3PF2377VosXp6M3hvH2YREL0f97tsXq6Aiigc
	dbU7cXqdIkHYUTa8MZkWdF/bWzytAFXVabsRY1dgUPz17+g894YQBEZ5FQba6Myr
	1lJ+aGbRUUqLoT3HNTX4dJzbrXrJIHgUc7aOk8AysRPzrkef+65ZjCNucuGTcYkz
	fHqVif8wv+cqA7PkDg5EgnC4tNRSK2KE6m1eq18nCyRlU50Gj3vaAt2rHDo2QgCH
	KtgUfb+uEEIJnk0lOQ9UleDCAnPzusg9UhVJBMBA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66q38rgq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 15:03:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 631BVl4e022271;
	Wed, 1 Apr 2026 15:03:36 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d6tan63pe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Apr 2026 15:03:36 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 631F3ZV52425522
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Apr 2026 15:03:35 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D2025805A;
	Wed,  1 Apr 2026 15:03:35 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3E1F5803F;
	Wed,  1 Apr 2026 15:03:30 +0000 (GMT)
Received: from [9.39.18.42] (unknown [9.39.18.42])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Apr 2026 15:03:30 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------3sJX2ZZ0XFyjrKdD8YKP0DKK"
Message-ID: <11894810-936d-4aaf-8da2-3d4c7d63539f@linux.ibm.com>
Date: Wed, 1 Apr 2026 20:33:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/13] selftests/mm: fix failures and robustness
 improvements
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>,
        David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko
 <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <20260327111104.b8bc18be45172639f5b9226f@linux-foundation.org>
 <09104413-483f-4852-9d7e-71e0f86a1754@linux.ibm.com>
 <20260330151125.d0b6cbb24b273bc963b05116@linux-foundation.org>
Content-Language: en-IN
From: Sayali Patil <sayalip@linux.ibm.com>
In-Reply-To: <20260330151125.d0b6cbb24b273bc963b05116@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 3N8hLgxSaV4QtTLA9GZwmXXIJhm7xRCj
X-Authority-Analysis: v=2.4 cv=frzRpV4f c=1 sm=1 tr=0 ts=69cd33c9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=r77TgQKjGQsHNAKrUKIA:9 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=Z4Rwk6OoAAAA:8 a=VnNF1IyMAAAA:8 a=pf5tUXZLyOQuM5szLbAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=SeepoTXLabEWifCr17AA:9
 a=z-NCl0v7Ebc-fO9a:21 a=_W_S_7VecoQA:10 a=lqcHg5cX4UMA:10
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-ORIG-GUID: _P86d-Y9Ja9gg5huHQHoQU6R4dWc24Ho
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDEzOCBTYWx0ZWRfX3iFGYRfos+lR
 uuHdpU6/hRD+Ta940C1LcEi0m8BWZjzcAfZJHEnF2aQqDDZ0Jd2w4aqImBM2qHmIqhs5d26sU6e
 bJWlGymDX+4JqduQ1N1SQbitKjdx6g5wFqmtFscMoMbeF+slo1LuFgd6UfhWmaKdLHJmBxvIxQJ
 /5AbvZ8LYbIaoHZQrc2iY788VUb2TBXjnMGShhliz4dZh9D57iTqvZvgeETeyo/Ggnza4fmCFx4
 P9Ja96DzrRI+bOn2fuR3wM4ZEa5yypVZNlS/MMQgdOG0q9dOmFWPXAcCWOgDc+8fG2baDGUaDHN
 Iw3mb4giEdb4eLpy6lMnbkngF8BHokXEuFmCB0YurPGdaqU5/Qzsv0QcpzH+N/YvMU2Plu9P9Cc
 SUetln2qCdGe5CDIRf64ZIXGUCeHnjXv/MW6Y7UWwuPVjFxaaRIDr1j/Ax/Jgy0A8pG5GDItr6d
 4h00IGbG7HykSwYCrjg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_04,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604010138
X-Stat-Signature: 3n4hkwnbj5p15bayghyghwhjefi9dk73
X-Rspamd-Queue-Id: 0AB87100014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775055823-774875
X-HE-Meta: U2FsdGVkX1/o8vGhGTgAjwyNwi4ufCKeOsmviA4VneKyFEOjS09ZH8ch41qsqjVYiDm5Mziymk+Z1BiYDydwTbLDSJ8/mWav6zYEmV/5HdRJ3MALQSBj2lrY4DGjqpcUqAVwbeW/0HmK4jHmYSlD8zXr6BiFc3ggPK2bRuCbr7pFc2BPBxhdqGvCgSW3flfKI7EUrASG6ST9xKYZS+nZOdXjOaq9JxzekYCwHftn5XH0gSLHGG9K+UvSo45YAacOfiE6xyajHLMnkHp7+dHSTT6jNTbt+Zqb9Gty/Ky5NBvqzTheOu1WiskKNK90W0mZYujSrdFlY/gjDgSwtXvM69nqCB+aHKTL0m3LrmYL5huScCl9j0n/98tWoMuzuU5agFOEELfIYjJmoaVBxpc0mJPp4TPoRyH5uEirKKmGG9H0CDa6stWX126Ee+qlLix61vHRe3jbDzCG0IIS3LwUn5/1kf/s8Bp3NPG83egczNVLWTBqv45KR9dfaQkzmnJ1kA/1GBlXBzduC1OedISRTOMNpfAhIkarEAlGlmEJhSB5Lof6OGwmZYWj0BGtLowHF/EOWDlkHabKkku3o4vrTl1aoMJngL0EQddp4CbgFD9OCBwEjJwbMdKqtQ3OYDEfBAqsqA5rS2Cnk814JdRoHAT7i2ncb3ekOUJuNKPOAWN+Sl81uT4C7wlajhOum2wBMzhI8e7OmzXRgcqd3eNqtf1S7Ib0iqcxmznmb+GCHqJzhrJ4nL4l0I8GEU8vWEicqX8WTo0hjPSdfINE56oolr9dUrBhHIk/VoA2dnk1tR8sGc+jK9Jysy30x+Hq03KjYIogUG5ojKr+zB/IyOHOnTIBnGuN0aLE78iuBmHh/NLwEa8fVb1BhnTTgGTw+F4DdaE81H53VZy3iyE6/mgRKGdTc+LHOJg/kA2q4u5N8EEzZjcf/SDkLp/+5n8X2Pr1bm2/fn3+stYTTs6RUsG
 RwiFxSIg
 VB5hxzEjZDeBUKUxAce+7KwTQWV2KGkBhv7OraIz1ZT+3YbHOE5+CzkgrWfM75mouBzoCAL46VPI5EOmXCnh8cpNBvB2+pTqHi0B3YERpijy/Yk494+EpI1DLZ3MQH1iYcclWiOzxUyUo42eWu+/rfU+Npik6avJSWK0HvU4A0u5WwKKg4JGC236CfHmKIvjhvGZjxDaOzV4Am30NipT3waR63BfKsP6/JLDF+5/E3v7xN/Hrur5AHSJpCdUjXDI/qdj3xOdXCfJI/PSIoW+zw3cBbRap5sGjH4BKTGbMCkz0gT47eoIk9C+cDMispXMtSrEFihUi5vUQmzEgTWox7rRv2RwnC4Jqsy5swsCosebm449YvVnVVijuRXFPQ4RSjzRJdoiTmfDqmAWvSwtIg0xeuY427XiUIPbHT2pYP+5qRk3w6F3vukjVLWIdTmyPb/ut0wtZiPcQ65mCPuRQRZhuhYiUAiM9cOfGIliusJCGDdBYGoHRKPsvnznPK54N44v6IEBk8bIWUKJXnUvlVoLPHhwsGmPMleKmaYrH9rrZMTffUf5wC8/fUTiwlESf9JEaYnpA7S8o+cyDz9rVPasRKzk5zX3ybkiO+lC5N+JVSceCjmqg34fHYiKuAcx/Zh1SgOnrGJXTIjoCBOMkyQsP5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------3sJX2ZZ0XFyjrKdD8YKP0DKK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 31/03/26 03:41, Andrew Morton wrote:
> On Mon, 30 Mar 2026 11:27:04 +0530 Sayali Patil<sayalip@linux.ibm.com> wrote:
>
>>> I don't want to risk breaking selftests so I'll set v3 aside until
>>> you're confident we should proceed.
>>>
>>> Thanks.
>> This line continuation pattern has been used in selftests for quite some
>> time. For example, a similar usage exists in
>> |charge_reserved_hugetlb.sh|, introduced here:
>> https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u
>> <https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u>
>>
>>    echo "$reservation_limit" > \
>>       $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
>>
>> In this case, it was primarily used to keep line length within 100
>> characters. I’ve tested the script  and it behaved as expected.
> Great, thanks for checking.
>
> Series is nicely reviewed and an earlier version spent time in mm.git.
> And the bar tends to be lower for selftests.  So I *could* break my rule
> (https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org)
> but would prefer not.  What do others think?
>
> Did Venkat's report
> (https://lkml.kernel.org/r/cf815c21-138e-44c8-986d-d8496503ee32@linux.ibm.com)
> get addressed?  I'm not seeing that in the v2->v3 changelogging.
>
Hi Andrew,
I am making changes as per AI review comments and will include them in v4.
The comments were helpful and should improve the overall quality of the 
series.
Also venkat's report has been addressed in v3 in "selftest/mm: fix 
cgroup task placement and drop memory.current checksin 
hugetlb_reparenting_test.sh" patch.

Thanks,
Sayali
--------------3sJX2ZZ0XFyjrKdD8YKP0DKK
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
    <div class="moz-cite-prefix">On 31/03/26 03:41, Andrew Morton wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:20260330151125.d0b6cbb24b273bc963b05116@linux-foundation.org">
      <pre wrap="" class="moz-quote-pre">On Mon, 30 Mar 2026 11:27:04 +0530 Sayali Patil <a class="moz-txt-link-rfc2396E" href="mailto:sayalip@linux.ibm.com">&lt;sayalip@linux.ibm.com&gt;</a> wrote:

</pre>
      <blockquote type="cite">
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">I don't want to risk breaking selftests so I'll set v3 aside until
you're confident we should proceed.

Thanks.
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
This line continuation pattern has been used in selftests for quite some 
time. For example, a similar usage exists in 
|charge_reserved_hugetlb.sh|, introduced here:
<a class="moz-txt-link-freetext" href="https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u">https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u</a>
<a class="moz-txt-link-rfc2396E" href="https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u">&lt;https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u&gt;</a>

  echo "$reservation_limit" &gt; \
     $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file

In this case, it was primarily used to keep line length within 100 
characters. I’ve tested the script  and it behaved as expected.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Great, thanks for checking.

Series is nicely reviewed and an earlier version spent time in mm.git. 
And the bar tends to be lower for selftests.  So I *could* break my rule
(<a class="moz-txt-link-freetext" href="https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org">https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org</a>)
but would prefer not.  What do others think?

Did Venkat's report
(<a class="moz-txt-link-freetext" href="https://lkml.kernel.org/r/cf815c21-138e-44c8-986d-d8496503ee32@linux.ibm.com">https://lkml.kernel.org/r/cf815c21-138e-44c8-986d-d8496503ee32@linux.ibm.com</a>)
get addressed?  I'm not seeing that in the v2-&gt;v3 changelogging.

</pre>
    </blockquote>
    <font face="monospace">Hi Andrew,<br>
      I am making changes as per AI review comments and will include
      them in v4.<br>
      The comments were helpful and should improve the overall quality
      of the series.<br>
      Also venkat's report has been addressed in v3 <span
      style="white-space: pre-wrap">in "selftest/mm: fix cgroup task placement and drop memory.current checks</span><span
      style="white-space: pre-wrap"> in hugetlb_reparenting_test.sh" patch.</span><br>
      <br>
      Thanks,<br>
      Sayali</font>
  </body>
</html>

--------------3sJX2ZZ0XFyjrKdD8YKP0DKK--


