Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F95C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926126B00A6; Wed,  2 Sep 2026 15:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FDBA6B00AA; Wed,  2 Sep 2026 15:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC736B00AB; Wed,  2 Sep 2026 15:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADDD6B00A6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E02B640369
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:32 +0000 (UTC)
X-FDA: 85169808864.11.B1C8F9B
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4CA39C0008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=XHD8wSIc;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ZicShGdz;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377310;
	b=1WNscQnnZqhgCRATO8B/3YrqbBtUSvMGfUwjgPFstVl0W2NQbo86G4cdrurXzGjAGHL6Q/
	vYskyZ+7pV42HpBKMCR4VgLZtDAZ5WxPH0+ZMlux70dFCazSSMSa+vn/xrgFWLeKDWKkkG
	bp5TOt5jegjMxp2QU1c4QuFYvux+6mU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=XHD8wSIc;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ZicShGdz;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VAfiqCv4eQS4h3nZSDuv6RC9EOG5S+Brh1R9wZYHWs=;
	b=FV8ydWf9R5dlkjO303Ig0p0dZe2B7q4rNdBNDAkMDeqsoMIEW4//g1QbHaPmywmoOtwb54
	KcicE1gj2CDEf8npMEKgBz9wWcyVfCCZWyyECu+G/wHl50h2L3dOl39JUppAk1qPknsONJ
	GmCDAVzvE3XEaSf7NxqM2qVFA3veb7Y=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IYiSU538594
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0VAf
	iqCv4eQS4h3nZSDuv6RC9EOG5S+Brh1R9wZYHWs=; b=XHD8wSIcL8iM08UN/g/6
	dIoF8wDgXZJ4Dnlg9+79gn9pf70m/nnqjC/OHKQpxxHI1SHWwsYJzkxnZsmU4Mss
	CRV/C6DkaZvnXRTDQcrg60W9/361LGUz9RJJmiUSHsyRhaULNUBqFU3ljokdNG0S
	rtfVpeupCo8yKCtQmpamprXqf1M7BTku95awlwwBK52HE5YcfRJYJEFOrhDZbViT
	gwrUzT5lP4EbLyrk1jjQd/7xXfS8j/Mue6yCMDBSJCKutDeCi71fE0yvkrzFZWT0
	u9afCEMWmtwZzfaBuJdkV6XeiaPrPcZ41hxu7LsXU/J/SLxk79mfucz///VrjnWZ
	pg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gefkbmu2n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:28 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52d33c89a29so37708231cf.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377308; x=1788982108; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0VAfiqCv4eQS4h3nZSDuv6RC9EOG5S+Brh1R9wZYHWs=;
        b=ZicShGdz/MUDKqgyXUjZfoMkgkkCteiLvt0M92j0BkJOIPmpKz+NSZoCjJgJBuDvPx
         O9LuQ5OHn9GogPdJQqlGp8SeL6BDN97hQCQeC4XNseRuzheK9/Bj77yEQUxRt5QqCet7
         OcdFCgu21RDZ+cFbcaYGN2xZzlEe9RV60fW7xPJe1/AYUJ9k6f9qqIcsErahsk/RxVY/
         k3bsr1Kg19Uet1H8GCIj2Gle/b/hTiElcJ6rUInyBWv7gd7bvu5OyiwsmNf93jlFLCC6
         xAyschj3g2VXZ5QUWhV6yluMgl4FDZmRNeT+XgRRtGlBjKFlIZNqJLTKrOTAkln+dz4Y
         /ZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377308; x=1788982108;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0VAfiqCv4eQS4h3nZSDuv6RC9EOG5S+Brh1R9wZYHWs=;
        b=PEtqRxecT/YTbKLcZCfeQakrJbItw+PH68SU5mlgA56IxiUQ5QSL+msHGxfGotyikB
         8gjk+WaouCCmPjpwwAN4LZ0of5sC0kGuqJ0A+i488q8ziPEfBHOZebiLQd3VM07EJFYR
         /wIXxa9p83Ot99JmuzrdRFbUz1gyOn5IIPHHLj5+3kQHGSOGDNLGhl8O7jcoO25q/dIB
         9RbbRlPVY7ymp+BfzfsT04qbBiZt2W2ktfhIUsR02IUbv+2I5Ny01ZZjm/3ybPCS2ZVN
         VTQGlQFdPNkRsJrsBlRi7IQkLGMZ2eibuupuxPS3k5rkfxE5DpXUCjbhlljh9XLGmQ4j
         UOLw==
X-Forwarded-Encrypted: i=1; AKwUvByG0xO26gbnd4GhekbrcdAXIex4Cn/xrGEC6rvagru7M7D+LOXjkupfS5QQN544fenfNNzCd1bx6w==@kvack.org
X-Gm-Message-State: AFuF++mhpkok4ycJCBOSiIDxwV0skxDDXswzIeEVbAlosUYUBwUI661X
	XlBw22Udqy0tfJhoR0BAnKtU1dM1QLGev3owv2f6s8Fo5dB53y1Fn7DGfO4n/eXrh2X9KNZTESC
	B7fP3Xfnm+wCzBpftYn0MOvmpgjr6vqtVvnrfkD47nNZHGc6b
X-Gm-Gg: AYBFou2mc1NlcQzDLzf+gc9Q4UmRqaFE7dy0l0VbM4AstGMc2rsHxRMPwFkBG/iIwPP
	VVeWUWsk/UoYzisV0RwMcg6rVoji5daSPIb7L0x3wNNcnxeiHkpBkUAo7cY/DB1ZT25rr67qZFv
	5skSiuhgHGqVUYLHEC+4MGgsJWm0SGDwXdIKkBk3JWdvkLzOIM9IWHHymeKTHfoncV6qhEMOpS4
	+0f4Fs5gVv6aW+dPfy/oWR9im5POIIQ6WczkWZy7O2UFb5GoX6gN7SX1DkmGe8haWeAXPx0RUFh
	a7Gsx/TB9AGivyNWn1nPc9Rb5MlYxvNUk1WeAGrNa77xzeRRyYtIvBhphJhfBoSnjmR0tOzOaSK
	wvWd3we2s3VYaVUpn5sQAIlAH+tw99s19AIFQuEnMUXVm1OgZQMwNJw==
X-Received: by 2002:a05:6214:d0c:b0:90d:3c75:138e with SMTP id 6a1803df08f44-90ebab5f849mr91931096d6.17.1788377307485;
        Wed, 02 Sep 2026 12:28:27 -0700 (PDT)
X-Received: by 2002:a05:6214:d0c:b0:90d:3c75:138e with SMTP id 6a1803df08f44-90ebab5f849mr91930346d6.17.1788377307002;
        Wed, 02 Sep 2026 12:28:27 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:26 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:53 -0400
Subject: [PATCH 07/11] mm: memcontrol: constify the reclaim protection
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-7-e2c1da22246d@columbia.edu>
References: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
In-Reply-To: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=3509;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=YiGk7IcTyC0Eps0s3N/NbbC9x/40tMeZu+bwBaHwqiY=;
 b=+WNVrqutl1n0CQduNp4rYfXSeoz4yiffisjzUinopL3RaPXOQZV9JDwvQLXCYFHMgo2xokdY5
 lcqg5i9omW/CqrsaFK/UszHRH5fR0tR1CM3irMoIXnvbmUTPXB6vbRk
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: Y0AHbavIH9vAyXKR6FZ-VjkHA3yRD9Ju
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX9CJpWvMNNCXN
 EhnsiwKTF6x7orsrrlJmVNlblF86CHPYVkJrIha71r4Cpl+FJJv8ri5wlmvKU+BuMBnZZOgTPCm
 M57Xn6qZNBkK8/327aIDZPvHwgngHBBumfH9tKtbGB2EiaBrb1U9
X-Authority-Analysis: v=2.4 cv=aIzAb79m c=1 sm=1 tr=0 ts=6a9878dd cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=Qozanl9KyY-oOybludYA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXysZ3VBAdBKOX
 nayzaSA6Pmh7YcxGzNkBQSY+omgVMY2Esk43k8FeQAu60J3cu8lT3mRZXVVYcSOjl2rc13ApnEM
 j8kaL7QCU/rnU/U9OmoxDXcL6EAFoXe0UdLEVeK6kR1/hjNvNlNKWQxz6oEfGtaUHFuJUo5wnBM
 WjPaOZFHdJi26rHgdbyR9TqV+TBWqJxCxQTNJ4VEF8dwLzml8XoGwxIIzLdE5W57U5SN7j766fd
 vZqsBi5szoj7JU24oolOZ5URIi9VqVu45YG4bJf6EfP3Am+bgQHxQ/Ryz4J5YhIcM/M4vY+mxNQ
 ZgahgTl5XCSqJ/ukpTkPrX4jOlawXo91LUUWk3E2Fj6N4F6zrAvJIg0U9etShgkER1YprB4tAM7
 9YAuxNx5p8ycuRc4YJqoGVAd+GxDsbCr+frKRJlb9fNisFbnyt4oNSyzEc6lqCsd7VsYGWxn+AD
 iqWFO4NRLW8AJUhEoxA==
X-Proofpoint-ORIG-GUID: Y0AHbavIH9vAyXKR6FZ-VjkHA3yRD9Ju
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=10 adultscore=0 malwarescore=0
 bulkscore=10 clxscore=1015 impostorscore=10 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020172
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4CA39C0008
X-Stat-Signature: kgrbu3rfwpfxqb6z6w8cj5o5wfwp7zsb
X-Rspam-User: 
X-HE-Tag: 1788377310-500123
X-HE-Meta: U2FsdGVkX1+rMHgZBeN18X+pO4D4RVYuHNwV9LQImjQrH1zgMn93JDfvDbv5VvMhLQUqA8p+rSUNU1hRjWmRSDZY3gfx1fXN8kxw2oyw8i8cEeOYgou4zHyczI+D+gB+OiDYdyMRHoOC6S8Au9wgQGBTnvu0DRxXIku3GHi6rKfpXbGgIjXOgWXgC9uB7sQnjhrDly2sWmqyIMG9nIvj//WUEcOW8FTP/evL67xZo8iWkJBQaETSoYW7IoCJfOQ/rASWcyWakg3bNcXh6kamhLN1KjJEH1KQv5uCQbudM4vfbLbBv7IpbM/xBEiRvGMkgfWKnPL/E6UTbAqXsuJkyBdQxfHVuLG0OaQzY/T6Uz4LOTI2lZHnxavFz661fB7n5cdAI3AsiBvA0eaxFHayVl84O8B7XnMKxA0j+u61MDDBAHYODNY8hPkkjgF8gzEGsViLtyNK/jT5JFgZC0+CA1hJgcWTydzkfg+NVPDQMJc1kh5sO/i/fW8N+eHmlOXYkDTjBHzbsU3V/XNvp8A2tNJ046OP+SKCqHNXbTE8cH8uvV7rPPC7CTUCM/Y4/Zvs1UY2EQl8j5WUJm7QwL/81qaXiYQgv3AXIJapaaTzM1r4t62D1ohP7YL4upPwiFkO7mj8ty1WeHrUwUEcxlVjDQK5gQfONhBt4uJxHZFbevgDr6NhNS+9+a8xzAgtJEgNDOHdTh/PFEiNWaAvQnuPKNqU8q2MI8gXMfuDjxhNY7RHVB8sQT6zaIcuNxZVykzzG4Pk1y3Hqhwh0argT6K1660+MZe6hjVsAZ76LQL4eydUCLnjrJNuSwi2/HY2ziGOqCGk502m0rgPTuA60UWfNoYHERI/T2h0J+nEMBZEVDKR+mcIzapRPqyXwlqBRwxWPMxbdnvKyWhyvMSgu+9U+//ojVYQrJBu/hwQ5KV3SQt6CB/ziZwp+5hsEKZaIySR1lwKfRJUmkoO8oS/M08
 HA/9lcAQ
 PfLCiwCVwhGTJdW71AKRC9cO90mHIGfZ+Eo2mtShud7TSnUB9YumLZhK/lHHruZbCknwuvxn+y26e3SvFsNkTpAj2FWZH8hBkgkSa6qk79pNcF58/2IiV/5LffDfNN9OyYjSi/zqBlkfeFWOf2B/qnpjxrYInsw9sJ7Od0Z1PGjaN8K2zEvW2tykufdeudQ2BrLD+J9AEodzpBfCspGVNRIJGAXhk3HQVz+c1SZHrcbV0F5FkeGFGKrxszLwu71JZudMdaD/ICWbGXxf3JUHFewW71lsbC8QlHRXvKrlvXwlhCXsa2tnuVVkJKllRE230HxncroRFso9iXDuV3aaKRkkB2jYK+Mxp0JzWzOfBpc5y/7np37/DPjfmDBSelRApOvbl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_protection(), mem_cgroup_unprotected(),
mem_cgroup_below_low(), and mem_cgroup_below_min() only read the
protection state. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bda969b3e1d9..bd82628d0d72 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -537,8 +537,8 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -592,8 +592,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	/*
 	 * The root memcg doesn't account charges, and doesn't support
@@ -604,8 +604,8 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 		memcg == target;
 }
 
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -614,8 +614,8 @@ static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 		page_counter_read(&memcg->memory);
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -1110,8 +1110,8 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 {
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -1124,19 +1124,19 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 }
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	return true;
 }
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }

-- 
2.39.5


