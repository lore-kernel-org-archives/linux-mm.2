Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 233E9C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E4B6B0096; Wed,  2 Sep 2026 15:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA366B0099; Wed,  2 Sep 2026 15:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490E96B009B; Wed,  2 Sep 2026 15:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14F3B6B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A0E6C0367
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:25 +0000 (UTC)
X-FDA: 85169808570.14.2FDC732
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id EC20080006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=FmkkumiG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=18DaiKai;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPhTKwWu0ZC070eRJGAvJA7RPQcJokjsS4EySLq6rA0=;
	b=eHaE7W+gaXdEByUTZOY1bzmz9wIFqnYWIXJPVUBLdAnjy28hmytYAmHssbbzFgayEOgy2j
	KLSd85SFrvdaqudGBgy9Re7yRClwaRZE0iuqrAX/uBfMcPq2EOFm4bBwEvtMQQQ4iq+xkr
	Mtf5M+5bWqGH7Bk8lROtHqUI0mJ+mCM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377303;
	b=mfIgQO4pz2izkul/bA2w5m1YCn8/1KPTmgegMJVk172ObKN6dORKyFHlHuAgMb8aBSKGKY
	SvUGzOwlsEg9JlBHE2gUU1vJoU0nifQGfz145xeCTJY7fPAWu0jjznVBgU9al5O571uPc/
	8aQ7kO7Vi8ZMXvm19Q2Zslo3vKaEddc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=FmkkumiG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=18DaiKai;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IkbZF519159
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=XPhT
	KwWu0ZC070eRJGAvJA7RPQcJokjsS4EySLq6rA0=; b=FmkkumiGvIPuvU0/9Qvj
	84xeTxIV1I02wmmXEXUfGdjLVSTnBDlnqF6ByVz85HH3FuFHtKxvn5ZJH0iHB0Hx
	giH0atIN6rUAssr3pOn2bvSD8+TLFgh/TtC2J7uR4BlfeugnCwytCZTyotKY8BMM
	Tp4PZECKpx32ClZa7uJ0bTucn8T1sK1IbkaNj0JPpt2WWf68R4eR24aICHB5H+cG
	h/PgeczlHgCmMxPU1eL6Cie44WepNfrtyFl2qxQcCx7PL83478svCyyqzhMtKYaN
	H7GFr4HsFSvzR4LMKhiOP9dUqAbEt31bNdV0cbCIPAYOAkoAJWvK4Xq+MKZpBorI
	WQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gescggbg2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:21 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52faa0dd18bso43194471cf.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377300; x=1788982100; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XPhTKwWu0ZC070eRJGAvJA7RPQcJokjsS4EySLq6rA0=;
        b=18DaiKaiym8+NGcjs8Rv/dNtcRZnyys+1OkLp5z3NIZw0VgNb4dOeT7K4N6QpmTV5F
         6F66Jy62547IcCiCQet63pRdsWEslc60FhPz5xqB1AH0pOainD5/eeQYMB8Jwxx0bAb9
         lLcNKtbWzAF1F5oQKAwEltGs9qqlaLrf/C5Q6lAwGlUxWD2GMOpcBihS/62sQdt+rVGt
         c5FPIFBmxVMclgGPzNFe+k8RpYGQbDLxoVSL9wRWhAGeoFUC9X0tV72hGoAHV74DihSb
         4waEkBTz30SQW/DvgQ/Mw/6YJaBE/SzyMvcBx35vM0FHZRrg3g/YD0ksiRkbYLQUhoUU
         LNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377300; x=1788982100;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XPhTKwWu0ZC070eRJGAvJA7RPQcJokjsS4EySLq6rA0=;
        b=W7TUntrAQFM3mGntvAq90ftw6xKVO3fBZNcvTsk/Ox2qrib5q80I3ivSoSVcG9dKAk
         SKQYHH6Sz/CalFWTcrGVWp5yXV+CYSD3izDnt3vydkxHQ/fwljPFMx3sAj4IgVYtiH+t
         tU6JYbLxm97WkXZ69hBRfgL9FObMMqo/8G03VtK0gexDnt6C8LhMyQiGSOfIG8NlpqH1
         +ORVEnG9jdES6YmK9E7MvZvEncgTNTQKMycldZrX0mFYY5cMj0eOIA2J+P/jIU5OxQid
         m/TSwQV9eeVxmpS03v3Sry4XKqFQ0ND0mnk2UJn5ICZAQinA7xBBvBUqNnag8bTg344+
         Pf+A==
X-Forwarded-Encrypted: i=1; AKwUvBxjg+imnAqZHmKIhZOMN/k6YpVzqhLgisVapQskvuZBlwqYJwlZrrFtGrA7jte/o5Z/pi805/rL/g==@kvack.org
X-Gm-Message-State: AFuF++kPfmWxZjnMPMZXmvOuklbnlQz63NOIvXJgNk0sOsWXxWmtmoHs
	wC60UKoh/qUQfqYFHoP3RJLSlDWixMyxKOk5DLwhRIrZ3hlolC8sfku5smEp4rHD3gJGPgCVYVx
	NHLD86Q7p/IkbiNzla0X3QSgKjQmzOxRr3IaIx6Du1qaQysG8
X-Gm-Gg: AYBFou2U/OGQBNl3Ka7YNAZ2CMjcr0BwcmjpEW5ExCYhqSJ7zkGhmJSi0i9h7PaqkvZ
	tKe65ip5cTUCWJuytO4GT96gXoyERVM3T0Ab82YhX1yQiMTW5au4JV52RcBcFNlXP5ZLepZ4g40
	addFbMnxx7/IrYkrTbTrfc2J6dW27eHRjeNMXE2QFJW+4Hzkohv6C2uvlTxSu8Bi+aeaMhAO89K
	fngwO4Hc9fXRfgsLLgKoO9Dmrx5pZ/TP2pmF4xOAOJf6n8y5c0k6dZaoPBYzlbRTkjBuwg6Hzlb
	RrGh9P5lf29Na1mKRZTe3wzItxZ3jgKTDrliAiKB4cgJZilqJfr5Vgtlz8N5121X/8XDRHyINxy
	8y5NKyI1DEJQ0h6FuYJ/o8D5dNs1smvk4+fZIUgpiU7sJdlQzf+EfFA==
X-Received: by 2002:a05:622a:1906:b0:52d:918b:92e1 with SMTP id d75a77b69052e-53036b93351mr82217271cf.5.1788377300545;
        Wed, 02 Sep 2026 12:28:20 -0700 (PDT)
X-Received: by 2002:a05:622a:1906:b0:52d:918b:92e1 with SMTP id d75a77b69052e-53036b93351mr82216511cf.5.1788377300021;
        Wed, 02 Sep 2026 12:28:20 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:19 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:48 -0400
Subject: [PATCH 02/11] mm: memcontrol: constify obj_cgroup_memcg() and
 friends
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-2-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=1873;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=32H1t1WqS50OuWNOahh2XKuh80JbjBLzpk9HxQSJAR8=;
 b=LYEgMgFYhn+Wku6NCeEdHf4ev23GptfScBM0FZS17DRElY3nFhOjx7LrmufmMei8aKlnIoLdP
 PVtuZrXpv0XAT4Snz1hQZnXyChRYU0Yp4h2nI9ex4KXJVsx49m+SSKe
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: r5QDwRqomcbb8c2ILdSEIHrQXL3Uiggg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXzmc01B13acyQ
 px+RG7Xm5mkDyORwyx9ZFXLZJJ57SQ49EDN4nmqUBlhGtXLDpTxArrZgE2vRQ/SLdNyCXQabXRj
 4b5TayAeDP0GnWALqxvUc/KSWTZY6sLRlSD2cMozOGBSPU/ItcXGMzdy0s0Ay9Rk14LDAJC8v0z
 34Kdriluu0zfM6p7LtCohnrj0NbndBj5zq/htRjwrRwSUz3bxXEW0BLngKC/vZS4vWmYvklVEmP
 1iw8edAMtg2mE0JynBRJGZDfHzcGSthMPMnsrl6WgyNTgojTXei4I2VivGV9wKOAFZ2+ImajeSA
 p3fMqYVIN+VvDkQWXlQKej+bSLYKxCuYKcKftbLCZN0U+mBPcU0nNCcJDpOf8BbWiGD1I3uS0G/
 Te6H5y0cSslBvx6E5jQPLGcYjdU6utISW35BLjETot/Ea/h2SalbOqlBhL4mkss2umaaAkiV6D8
 r3YPrEfxutmWb+VJ2wA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXzGPb53KvwCkW
 j2SQo0uE9wVRsmh+5PbXggu3quTeo+4mj7G/npjWINdXEJKhcCzcHKSW1l7QFc4koD1bcmqh4+y
 tzY6JzA0eLgq1xwvHm9knCDQnWp3Nz101DJzwSvTFjfCqCQ69wiQ
X-Proofpoint-ORIG-GUID: r5QDwRqomcbb8c2ILdSEIHrQXL3Uiggg
X-Authority-Analysis: v=2.4 cv=VbnH+lp9 c=1 sm=1 tr=0 ts=6a9878d5 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=HbpFEVrQSsppjrtFf58A:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=10 bulkscore=10 suspectscore=0 lowpriorityscore=10
 spamscore=0 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EC20080006
X-Stat-Signature: 458xinmpd3w1eypjakpwtr44mufsnaa8
X-HE-Tag: 1788377302-735026
X-HE-Meta: U2FsdGVkX18BBWSMNqmOR/8DLIPKRWqFXseyZEgfUTTVZ1fUCZwhnyJq5FPegniV8c//q0Q69xI4+9sLF5HjP707PMw59h0k+/EnQTTKyJwREJafuB61IHQY3fooQFwHQmR47nvdI3i/dOeuFu/deEvmW96pe86hq6ggirzCKU/dtyQnEbKIcQ/KjrcIuP2gRP0jo/JmuO5Dr6hjbgbuXEvOK3vPVhtNtagZjqS5wNoUrSSSd970QpgXUxzqbBJl/GENZ9oJjfvG7uGu3aPImDNgSAMPz7dBJszI4UJAeOndpYKaUuuE+uSpwAu75qxhD+UDgn2sIyyWDIY9gg8XPxOZPZTf9A6Uszm+rSIN66sc+lot5KqpXtKw1WhXYWbl7gWHP69IPncrA6XTXCfIEgYdaMBTPek/FJYvnNXwlgUPtwKUNqEAZ2kG11hzy78FJ/QOwKFKgOG1/S8svHo5UU1MCPKMLLaeg3filZTagzWGjGGdrtNGzxYzqcDuqgbiXZTKZCjqWbRxY10vDsTfyYsu6g4oUl5G4cz76iaol0DPKi6GwKg48Yy2+dg0bTOG+LRxcA1Fv19y5NtYBTmt1GYESSL4Oi2ok7CNUdxMZ6k3chFviaCvVGH342c6zrmUyaBw53brNWp0rOb1NehYSFus3xzmG9GOrRKcY1F1L6f5YaPxVBxqw+N83fW/6qriV31buQyw9P72jmdWgSOBAu/33m4SZFWbxfnKHvF2xgTWLJ6/PeQLXlOYt5sdjdrW7KQEF2MCC9DmqBDQbdoZB1berFi6ivmiiV1gi48sDJSPu0zmPiArVXPnQ6caCqURgiqIsO+iWaVOSRfufVsEzQqaNg+U14NAsVosIx4AKehIS+LiLGJdC8mMwNm7fnvqXsn2UgO1dU2l2bonrZl0760hAVrkaBydWthARbw9agQjDFxLEMRs1UDgKIgIaRIP8cyHuSAGouU3vIujhiC
 r2fSKMSz
 QIlbKGqa9MUOyW/HRvQ3TdrORzx212AWVl5pc0K04lhjaXp1JqumpSHTwuErr9iiiVt9lLjAGwcbi/h1bNKA6oqsj2QU1ITR3ggPadr2U0W0FQ1lDNUJyfMUxDVHHFIgXH0kDJEcN8Zp6mF/VzN5GK7DQG3XEq4PUQqQcoSVSZoGkuLDh4qnPbTpWG/795wFDTgcGhmSEy5LMvOkpdaco4rqlUGn41/HhTNgcTJJtwYRXvq9kSZjdnjdfuZuIg/kEP7s9AAh82QbMq4QCxXI2EVwNanC/6b5K3t5Lq0v4inc87RqqrkWhv0XzoTqcd03iwxRqaireeP8OJ7sDiNFvcTYvz4J8O2QEvxMITAjmQ/a+nHSKhX68g5JE0gCqPYrp6CIPcFSu5S48TzhVfG6R0/n4YJh6ma6wD0DOmq//6Bjjx/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

obj_cgroup_memcg() and get_mem_cgroup_from_objcg() only read from the
objcg. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 91ca94667d44..2b3b62e84ab2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -363,7 +363,7 @@ enum objext_flags {
  *
  * The caller must ensure that the returned memcg won't be released.
  */
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	lockdep_assert_once(rcu_read_lock_held() || lockdep_is_held(&cgroup_mutex));
 	return objcg ? READ_ONCE(objcg->memcg) : NULL;
@@ -472,7 +472,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return folio_memcg_check((const struct folio *)page);
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
 
@@ -1036,7 +1036,7 @@ void mem_cgroup_flush_workqueue(void);
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }
@@ -1065,7 +1065,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }

-- 
2.39.5


