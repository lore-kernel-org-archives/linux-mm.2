Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC3BFF4947
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 05:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717036B0096; Mon, 30 Mar 2026 01:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EE216B0098; Mon, 30 Mar 2026 01:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604406B0099; Mon, 30 Mar 2026 01:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCF96B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:57:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9202E01E3
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:57:22 +0000 (UTC)
X-FDA: 84601671924.01.4A52C7B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7FAE640007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:57:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LFdIgEce;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774850240; a=rsa-sha256;
	cv=none;
	b=0cny5uyHX/mpAqfpFUqazZY/eAyDT3DxWCjqun6UueuKve9QDboulJNs9Vk2eP/Q6+95r8
	CvsdVz86Moa4xUXeqqpxEL+XEKw5gPbi8/KnjTy84xmKCZAbqVNX9mvTjXYUih8XCJjIAR
	SyAzIDuBEGGnwgbYbe0iDKKOhq4BEFU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LFdIgEce;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774850240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xeJJXIfrLkHR3C5pzaUyEWDuxutTC5pW5evJ9l3HuI0=;
	b=OJC7dyieiZsajE9qwvgxN/OSScCs1LLcY/FtThazzL6HNg4jaCQsq+29K3F9e4G7m9+K/C
	8hV5Ont1cOOSJ4nNzhRacTpqvDi8iD1qt3GYFw+h/78i3H/mM2iqB+tr86Ehi9T909eAJU
	jknYvi1Vit0BWSaYHToiSR0MH0keVOQ=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62TLiIHL137090;
	Mon, 30 Mar 2026 05:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=xeJJXIfrLkHR3C5pzaUyEWDuxutTC5
	pW5evJ9l3HuI0=; b=LFdIgEce/YfOB+X0EqaB2jxKOqdTDKnINV3ymhpwM6qAnz
	PWjQjzwgDecQRW6JFDsMVfqVXlHdywfxr4iTQK4y3mLmkX+RWImP0j5EeQdSrHp2
	1MgpHLgOoE/p2UbyT6xVcMt4xVxA/oPDrDxo0Eg7zHhM6MD/U/dqHRRDWXktrNoB
	TpS5ioLiqAllHA6IQLmfUeDyBfKFWUdoxqr/r20pi5jOQ8uZiIXtOSr7wVsSasNr
	nX2a0UNfdbXWG5bvFWrUtePFWTxrg9Hsj+xX7nadG8HCDG2k1pxDskvqGVLGKrhX
	1OzUdDoXZVOA+G/PlJhiCvcbySSWZnXnUh8y+Y4Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d64dgda0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Mar 2026 05:57:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62U4hXTS021713;
	Mon, 30 Mar 2026 05:57:11 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6sasbqrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Mar 2026 05:57:11 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62U5vAp054591854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Mar 2026 05:57:10 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F857580A7;
	Mon, 30 Mar 2026 05:57:10 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5BCD580AC;
	Mon, 30 Mar 2026 05:57:05 +0000 (GMT)
Received: from [9.123.3.209] (unknown [9.123.3.209])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Mar 2026 05:57:05 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------WLzWyX47kZc0PpxqJwf7k4m1"
Message-ID: <09104413-483f-4852-9d7e-71e0f86a1754@linux.ibm.com>
Date: Mon, 30 Mar 2026 11:27:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sayali Patil <sayalip@linux.ibm.com>
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
Content-Language: en-IN
In-Reply-To: <20260327111104.b8bc18be45172639f5b9226f@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDA0MiBTYWx0ZWRfX8jQPwSJStGH4
 zKDesmLODJNW5LXsDSGSvbSKz8/Dy32LpGk+n5jcJkvDU9TiJZRFhWT+4+SjoMdvCvwXy320n44
 bgrEY8TdrHRmveNrTFz1XIGpt1JWkuNihcdQLw7VqMQqrpwOL0VnzuMt15kYLQjXHgd14moX/Es
 YihWFoK4r6PD62mWiuuBQBJY8FJA73DwQjniqunIHa5UUCpj4nD6xVC7G+udE088/MMrPIl1so8
 GyXHVEtcHzzCe7uUFwvAQ+8eV6GUaUxLWQCDPDzMa626957ComnlH2KpSipycZe/tZmCqSgG8ia
 bJ0wGQ9gshcroQ10h9ysZuD2opeOgNNPyGNVQKes61uRbkw+44P/5uFWX0Ziy6xORuQ8TKoVkOe
 IQnWQobgH6UiqgqMxEMNWd8BPy+L7tTgITIcbGfHkV9HPDsA0fC3ntQ2tX3WE/EFEBlLln/Mpga
 hergXQNUVtPgZnW7ZPw==
X-Authority-Analysis: v=2.4 cv=QKZlhwLL c=1 sm=1 tr=0 ts=69ca10b8 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=r77TgQKjGQsHNAKrUKIA:9 a=c92rfblmAAAA:8
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=25nMSo9LTxhe5thYVjkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=Z4Rwk6OoAAAA:8 a=SSmOFEACAAAA:8
 a=YkT_I4k1DFQejzkCfg4A:9 a=yJWDuJPA6PX7OY5Y:21 a=_W_S_7VecoQA:10
 a=GvGzcOZaWPEFPQC_NcjD:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-GUID: 5ZC4zZYTZUSb-8ANpVYNmVpr-cbR06Me
X-Proofpoint-ORIG-GUID: tYreYMc3o2jFVpbs_uqT6Iw3DZ7UyoT4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603300042
X-Stat-Signature: wecytick4ekcrbd7odrng6jn1guxqnf8
X-Rspamd-Queue-Id: 7FAE640007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774850240-646384
X-HE-Meta: U2FsdGVkX1/PZPIpXBK2vDgiaaxbOC9+MrgP5LHWaViKvnJ6lRvI+Zcta79x7gjafFP1EeiLxFMdzYaWZlm9f5HpQ1rXNyH0bKrWKm/NyNJ30Ga+6FBtUKC5ZnX9bOqV2gA1bb/28J4O1rKmcLoDSEcGYGfosf6kNvaolohTJ4phDHqVuKUmC+hawe9CZmpREcLdXsoXw8mH4bb8G57I2hNujbQ6Buts1tG2MzwHDUw8W33/Xl5qxls5L4uwzB4aun9GEK9ehpZg7tCYoVWMW4FSYHLBs1uSfjEINktKYzky/H9LnPryxFnu3a+ETUyL/cdoZrkQuE4DEFYtMPQcD9gjrXUuwarRrupp65apEfcr9qvQ+/nld9Zr3TArf+UOg6lh+Y7SjErEqlMPqNvUJQka3SIqf/kMLjWigrsWlL9ULk+GxeaNuyMYRFlzWJ1sFfaNxNPK3Zs2OhWCxxhvRkD/aVQIS3wYqVVXsyF42vcehOBHv/PSJ3vxRgeIoHAZ4egJocdjduc+n96slZnAiBcKye+rpMwGdjRM4OryJxYf1FpwLuDwDJqxBOhDXlTYL0fMGQMdBVjRr0TJaOYtmqN7baO/wfjBkxUAFjpwzeY5LLLYvZpXq+u9nvsNB7i9K60XnmGQdKQSU8xuVWcYO8hbkEOan/wZlAv+pschE3Vh/MrNEK2Px6sQhEvsOHjbcsRQDLBi6CjNZD9PI+1ZyS5PN1bwaVkno6286kM3Q7+Fa0afiEjEGRqFML29JO4JDVjRY/cdJGCRLaIwy5siuvykdqshUyB7DL17OYeYg42A1aHx5nfij+Oyz5VNi9rUgK9/BrzoKHxrdcrH3es3ZIyC7jSJ7+OvhkoIPZrRUER8QutVcdXJr4R01Q7ni0/XGPgeSNDv1cfwUwHwZ90qo+H69fJfU84EJmHF9m/AFd86QulclwNd+56eFJGoWycQs8Y0HuIot8EEVUk4IRb
 7XUtnU3z
 GsEA28h1TV+yHWMWpuNPFzKN8IETugAz82DrSndnNbCZ+oLsJax/y9xNJFPfa2QijoopcLeoN4kuihM5sdQ9duLrr1ymbTAQE0CFBmaFA2YO3UuhNhiYk25dJfyKa3x8Av6bU6rvSOyuF+jE/edCVWWNtU+hL8oLktITYAxJ6pJKKwIjJOS8Fa1vhNHYABsxdAZoP8Xf7B7SHRWSYl+OYc5XW6d3el+SNeOyRK2Uq4xraVLhZxCn80VemAQZYmb+869ursX6cpriDJsOLG4NYIUjJymnR0f9MXiFF8mmIKrPCQqWWwb7A1NlDfPu3IwvZgiZEM018fob95HHWMygjbD0Lz3jlWwWa0uMMwjfnx5zd6AIX4QeWzd6QOz2yqNPU2Ym4m9cl3rIlpz7PO8HtPncRtTd0wGqO/YSi98x5r4uEafkMNTuTeDsoMMVeR84L12gkHqZL8IOBejRECkstgBgYWfpmfJNQxxiPiteQd0D2pvVcu+RC2mSxggnPPPXdp2gRvABcbYJbhyw2gMha3rb6FJti1ZfkbnCxkIxyk1k10q2NpLCY4Hg4zSHp8zcQ2i0cvADDVnATo00rEHTbip+vy0N/pOYgAabvV6Qi5mCnDXYrGKngFQliH8si/5QWedFXk5eCHwKFHxvzykJv67yiDFzRKmc9MzPndnXmT70BEm+qDfz0uBVto0PKq7qhIrWrtLw3dnNLlLhMj7Zp4UCuUXFm3KfkdAdloHiahJMDjqluLm95v4XDWKuHKqtlI0Ua0YcUOwYwwxmKPxlMqOBDmEK+mpPvFBkDo6oMDgTBCME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------WLzWyX47kZc0PpxqJwf7k4m1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 27/03/26 23:41, Andrew Morton wrote:
> AI review asks many questions:
> https://sashiko.dev/#/patchset/cover.1774591179.git.sayalip@linux.ibm.com
Thanks, Let me check them.
>
> I never knew about that bash line continuation thing.
>
> hp2:/home/akpm> cat t.sh
>
> foo=\
> 	bar
> 	
> echo $foo
> hp2:/home/akpm> bash t.sh
> t.sh: line 3: bar: command not found
>
> Huh.  But it presumably passed your testing so confused.
>
>
> I don't want to risk breaking selftests so I'll set v3 aside until
> you're confident we should proceed.
>
> Thanks.

This line continuation pattern has been used in selftests for quite some 
time. For example, a similar usage exists in 
|charge_reserved_hugetlb.sh|, introduced here:
https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u
<https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u>

  echo "$reservation_limit" > \
     $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file

In this case, it was primarily used to keep line length within 100 
characters. I’ve tested the script  and it behaved as expected.

Thanks,
Sayali

--------------WLzWyX47kZc0PpxqJwf7k4m1
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
    <div class="moz-cite-prefix">On 27/03/26 23:41, Andrew Morton wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:20260327111104.b8bc18be45172639f5b9226f@linux-foundation.org">
      <pre class="moz-quote-pre" wrap="">AI review asks many questions:
<a class="moz-txt-link-freetext"
href="https://sashiko.dev/#/patchset/cover.1774591179.git.sayalip@linux.ibm.com"
      moz-do-not-send="true">https://sashiko.dev/#/patchset/cover.1774591179.git.sayalip@linux.ibm.com</a>
</pre>
    </blockquote>
    <font face="monospace">Thanks, Let me check them.</font>
    <blockquote type="cite"
cite="mid:20260327111104.b8bc18be45172639f5b9226f@linux-foundation.org">
      <pre class="moz-quote-pre" wrap="">

I never knew about that bash line continuation thing.

hp2:/home/akpm&gt; cat t.sh

foo=\
	bar
	
echo $foo
hp2:/home/akpm&gt; bash t.sh
t.sh: line 3: bar: command not found

Huh.  But it presumably passed your testing so confused.


I don't want to risk breaking selftests so I'll set v3 aside until
you're confident we should proceed.

Thanks.
</pre>
    </blockquote>
    <br>
    <p data-start="115" data-end="358"><font face="monospace">This line
        continuation pattern has been used in selftests for quite some
        time. For example, a similar usage exists in <code
          data-start="233" data-end="261">charge_reserved_hugetlb.sh</code>,
        introduced here:<br>
      </font> <font face="monospace"><a data-start="280" data-end="358"
          rel="noopener" target="_new" class="decorated-link"
href="https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u">https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u<span
            aria-hidden="true"
            class="ms-0.5 inline-block align-middle leading-none"><svg
              xmlns="http://www.w3.org/2000/svg" width="20" height="20"
              aria-hidden="true" data-rtl-flip=""
class="block h-[0.75em] w-[0.75em] stroke-current stroke-[0.75]"><use
                fill="currentColor"></use></svg><br>
          </span></a></font></p>
    <font face="monospace"> echo "$reservation_limit" &gt; \<br>
          $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file<br>
      <br>
    </font>
    <p data-start="360" data-end="644" data-is-last-node=""
      data-is-only-node=""><font face="monospace">In this case, it was
        primarily used to keep line length within 100 characters. I’ve
        tested the script  and it behaved as expected.<br>
        <br>
        Thanks,<br>
        Sayali</font></p>
  </body>
</html>

--------------WLzWyX47kZc0PpxqJwf7k4m1--


