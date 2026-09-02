Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEC3C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F2156B0092; Wed,  2 Sep 2026 15:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA926B0095; Wed,  2 Sep 2026 15:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8EB6B0096; Wed,  2 Sep 2026 15:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4956B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9ED4640345
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:23 +0000 (UTC)
X-FDA: 85169808486.21.F30AACD
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8F88FA0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=niXq4kAh;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=BEC8v76N;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XIT4QoZ71Osmkeg+FUd1lgbaZ4qc1T8WZBa2s5ZV9iA=;
	b=D5Q01LgZcsubryhuF4ieMUX6VFqjosFPOsxWKg2ANmyaz82FCNztEgYw9OrmAj+yqqXZ6u
	NDMdfC8Ru2bOJBr7It8ZCWL+201fXHaFIq31CIPlyRMAvtt1CvKsxYRFSzBoPnQyJeLS9D
	UvEfzSJtHtaX7vSHL2zXlCfc8PdR4fs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=niXq4kAh;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=BEC8v76N;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377301;
	b=2q0Yq4uZqH5NTmacRebshtiPryEZxOyBB5x7M7nx4ZblNfd5ffptvJ6Zbir/JF4We4UPaG
	gJpRKTkVU50LnGqLYjduwYUs+kGEzkSd5/WvTOXUFlZ9+wY8svTizoD4URIXBE6J/18KBT
	dqXbdlpF0ePgmWlCqhy3QFzfjyG4EyA=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IkSg8518983
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=XIT4QoZ71Osmkeg+FUd1lgbaZ4
	qc1T8WZBa2s5ZV9iA=; b=niXq4kAh4v7hiV/l+BZL0JNK9e+f+jGhoZVubGdaQ5
	9E/m53+u1+9nAzknOr+b2/5r9RozqOe/z719xeaGcNpFyRSc4fSZd/S4wsYf7d7n
	JdgOpT92vu2DnDyzwLdkmYTkgcI5tz+aDh3oS0bbR/4D/gIxCmQy8rAJBHVczWD8
	sEL9wXkCRQALtIu08cqgRrUT3rTTIz7ujZROEEI7oxV6SO51rODXtnNNFvI4xs9b
	a9MJ4j08HaijuZCyOzaOkaKJHRGqeFxKNQFAPaADLqXRvibzA2NT1Lh8uzT9hQL7
	cqrCU8YcAR/0/reH4kX1mx+ef2mGAfX+BGxHRChycY2A==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gescggbff-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:18 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5283df62d68so25262071cf.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377297; x=1788982097; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XIT4QoZ71Osmkeg+FUd1lgbaZ4qc1T8WZBa2s5ZV9iA=;
        b=BEC8v76NJRzrFxu3gAnGea20bDUFo4Z5zzUYC4HkQokkS6g7/qKwHeWrzwf2pFdEZB
         i74SRiw2EDQl4HK67Gc3sIkCvlDBV9eq8YrD6AoFlWLHb/E54PI/pJccXAKS1/jQLr52
         20dw5KWwJ9X4rFPAMo5Wf3E/0RR20cuL9P20E1CoigQfxtzjLcXIW0NEOnrY4q1RN9oS
         LoWYtNsln3HR4W6edd14Vgv6ZvwX4D16hWawJZ0MaCrQlzzonEZE4shkbyxGAynSQbEg
         9goXfhJeCPQ8cr8oJcP7Y4e0oVq/CsVdN3kNSpK/q3mC1f9MNFW0xG9STZ1+AiX5eJEq
         UQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377297; x=1788982097;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XIT4QoZ71Osmkeg+FUd1lgbaZ4qc1T8WZBa2s5ZV9iA=;
        b=cyq3NaviruiRjqlpSG0gunpT3+t/Eeu1ji8zbIqq+9KpyO/MXVjs6YJ6vy8QkPEyfY
         NFfXWKyKaosR5BqQ6bXsphiXAQ9gPqGcBBHYd6yC76QMMNWC4VSPQx5Fue+5F0dA5ZJp
         CoR1DAW7v2RhBgraZey+3zZ8RhiJw/nfbjjZHKjL3zFVaG+xsZylbBJw8vRS8bqJAxIi
         keoN6f71hPQr6PTdAA9nZZaL4NlD8KYlkkQrCssKG5aOK+NkC6npMJ/Qz7RWKRYS7ady
         tCkTtIowTLmtWn7qvwdxSKvIziKtm58DjATHaahI1GnhmeDjVjcxBDr9PO5zjxfN5aj5
         mfjQ==
X-Forwarded-Encrypted: i=1; AKwUvBxFRYGevVvcBbQrtgIGigGOuBOmaeGzGdWB69zOqaZG1/v9FH4RCZmGnwJHdzkgAl6bjrORLWJgKQ==@kvack.org
X-Gm-Message-State: AFuF++mhlpScbJHqCIikIoeRfUSE8XnFcz8SdiokfUeFulKsg1+8LEB3
	xxKSnGicu8kjhSCf9bn1+IiMBdN6uNEISjP7yM5DaTJZazTQXZrr+cLwv3+to6jgH+MsIbS3LGZ
	8BIP2P/s05Q3AtcnqFx51wvDkt1mhGbyu5rSTI00FXzvJ454a
X-Gm-Gg: AYBFou1kAnnD4qG9MhWx9CLhJGdBfMuEfV93cjC10dyJ0oHzI8ztoz3QHAcjud+pWZo
	3/0MVnVnM+rUnuFFckuUkHBTUWg7VJmee2fmrPmWC0RAUoHbw2L4Nj+h4gYkpqw6ej/Qsf5mxZe
	ekbkLtfltovhSufY0jPXgQv97ve7R4fW3xMPkwqpDcTbjiXREyYez8cvYMbLFgN4S7J/D6QB+r/
	r+sGj396JAbC7xVh5rzKPgc4ZcE6DUJdzL053IXbw9g3KHiD2GjfzVznI/q55eWJLbzVT1AQfqx
	L785Z/9uMDrIpbO68fCZb8ycOIMJMvfbdGnoRGwHB2oRVfYj8l38nAZPulLmZ4RBHKqrW46HFDA
	02KTnur9JcFr/jKf6GcXTp6eSDxAjo7RrvD0tS469O2HwKurbH2g2Gw==
X-Received: by 2002:a05:622a:259b:b0:530:42e5:f3a6 with SMTP id d75a77b69052e-53042e5f678mr19138101cf.41.1788377296977;
        Wed, 02 Sep 2026 12:28:16 -0700 (PDT)
X-Received: by 2002:a05:622a:259b:b0:530:42e5:f3a6 with SMTP id d75a77b69052e-53042e5f678mr19137421cf.41.1788377296525;
        Wed, 02 Sep 2026 12:28:16 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:16 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 00/11] mm: memcontrol: constify the read side of the memcg
 API
Date: Wed, 02 Sep 2026 15:27:46 -0400
Message-Id: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALJ4mGoC/yXMTQ5AMBBA4avIrDUpqZ+4iohQgxFa6SAScXfF8
 lu8dwGjI2QoggscHsRkjUcUBqDHxgwoqPOGWMapzGUmejuTrRdc9CC0NbwJ1aQZKtmpPGnBd6v
 Dns7vWVa/eW8n1Ns7gvt+ADk2adB1AAAA
X-Change-ID: 20260807-folio_memcg-const-4a67e40d485b
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=1753;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=yUEHEeReCZ4YDwLuJjsFeMZaNLX0OqqIMp+1QYovZ20=;
 b=2daVjnF7Z44mYyYEgCKwKIDVPS3KI363eBjdVBOQmy8mvuZWK9eeEd/RLIccXxkUpN6jD5buI
 mEW0E1ifqpfDJ8ZVGf2ruhaosGULcxIBFz8zgH6A4uepudoqU4gl1p9
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: ChSqzSa60diDQcp8IMhYaQUFeHZ39Yy_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX1UODbYxwPxMa
 DC2itAvWimRmqDOM5Xu8TH7iXYVUg0PJ6fzNHe58a8ic3bFkJ8l1q2CV54BkrA5WSiTJZrVO8tF
 9aAZBhMvv+ofUtS2nC0c/zlviYvYrWHHD17SsSlO9aw6oNwFsjj04zlkuxpTriiHQd2LyAPBShU
 ZU3zMoKETyQLPSjqIeRqvCHShT5qkNljCHdzNZXLEZ/6CiFTkqALe6KKknN8CUzAUQAgj6g34vP
 yI3hHYpB+0iXTJvwNYjSuipidNbdpew9BW5MyEiwNXn8ZQpzr2DtZPFCmsJHGH0HWLP+yruJ1Zc
 y/quv8dVckYMTjxKaKo8iSWySqWUxXtbF3mgD9lw+KQ+1R94pe3T3rQODD9qqUOpebfeP4Jqt1R
 XEYp+RVf3rX+CAjHxQQN4CcXdVGt3M11gWf0CWRFir2ox6l+rxoBDL8CkYxzr82TCxukLmUZiD+
 Xpj5DWK45ViJQKYWD5w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX1BeCw3e/HGoi
 wtjHs25ZyNikAW1x0wJatI/Rt5GjGLwGfXIseI5ImVwuRBNf+JV7YQui8RoTlDU/t5jV4zfV8Vc
 YqIWtI+UcmDhbstkw1Jd41VJZ1HCLF3FK01lAb8xuEf27qXw5Fzr
X-Proofpoint-ORIG-GUID: ChSqzSa60diDQcp8IMhYaQUFeHZ39Yy_
X-Authority-Analysis: v=2.4 cv=VbnH+lp9 c=1 sm=1 tr=0 ts=6a9878d2 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=LIvFlyDzFMSjF_C-DhYA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=10 bulkscore=10 suspectscore=0 lowpriorityscore=10
 spamscore=0 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172
X-Stat-Signature: p7jjiyg4etiba7aj8nbbcag6rsxqph45
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F88FA0003
X-Rspam-User: 
X-HE-Tag: 1788377300-787340
X-HE-Meta: U2FsdGVkX19tMuqThKyEClaL7PAkCgRpegiJdy6jcpinAJ3e96aEyCrFNHWpHhye1ShSG+ANzf9hhk11bP7bmDZSfVsp26eKC0S9YZw8hdIeHKVqI1aEXHbnPJoCiszURB2z+d77ZNXTjCvmcXDad/a+tYs0XwcNblMu8fMyimCHYpt8GD64J5yyLRrtbgV/df5za/K8oYpxxRmu3JNNMEJYLnU49V7K6znk5wgoNmNMoZ4qLVx6k9vY2k5sMv7N4xJYEyPS4GX2N4s0zeNVoD91MVoDNMG88kafnG9e4SJDuCP3mrxvNuloTRlfvRWmSVG/DB+m4Tvxm7tjyWqhyrhZWqrQTHWEsjxnq/hu7ulmRhJgJ/b5ToCo4h2+ex8bw4ce2b3l/PNDIEDkfuhH7U/Qa4mPpK5fS0Mh3m544AqHAhZlG7FYbtjbZPPm39TaSWzJDDEKYpuxsgDC7/CrO9uv4SkWTS2n+7kvyZlviJp0hbR71OBu+VxdwfiQPVTYbZ3HnrqQuk8OB1u8ri5jHqnq8vBSSG5wgTVZXfd7tupFYJPsK8q9qn7RxxON3EnHyGujf1ilHgNMwPVmdZkVrJ96sm0V7h6hPomp+qXDTKuynWE5TrEjJQZt5QBfWvDf3V63slc58YMgaQHOTLWqSIwYMjPvQrCOELIgdCjjwGbdUm6RllTz7eGKAkYsBSeznsqplS9Qcx+YgRlilL/K82cUTYUwj4NpYTGFv0XA000exKVix3JsVoVjsypAL+TEejVp3ev6OELN9JBXMkAL1DCPOMOxllQ4TICo1FLDWjNvZCly7sjyUyD+uWSYDj6bM7/qOYtgDdnTEXg7MacM+JDomR/ND2anmnl9vBot9dv8ecycZwvO7+AL9BtUAOJvwPJq871FV5gmtc6RECx5CYq4XZH2UUvEh8MpJoYwYsGhzFSlSgPYxT6DU7USkb/sXS5BIIBozWi3xF1CTqO
 yF4C1K+Q
 jDa750I3y6lvwXhjeVPzYGXPWLWCM54Yr3mexAoYdtHac0LjbE4tfe70HgwhDq3yQfUncxQftJgeBeHi2c7Sias7KumGu58IRrzS0RYbp6IRTcAcQIOZ8dlBFiUgwFpejkl9eTViV8HRAjCvjyXKjB+tUoY41QjpLHnPKfYe/MZGySjt65shBt8KP6vA2taOJgRcTNGGjHJSwLPx8LTN8PYrJZw4SH5cR8dAOOyZmUpqsGbjDKdBjnrPawbFuFUpkc04QgPA9omR3Dtf+LIFb6BUSkx25uNCFTdo7FqLoD5jpdLi+h35LgY0P8uRYM1skJ0kRYhZsWoymuAWKEpQuaL5fAemMvKaKXyWhj9edDEpsCpxoyRr4eT/dxTqbGxxuItcVqQbxHkM48aEvTMpCYmoIT+MuwUc1vPe6Zsgi8Q+TRdoq/xtECrF4Qq4to8eltJs3Sleog9kufT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memcg accessors, lruvec helpers, and stat readers only read from
the memcg, folio, or lruvec they are given, but take non-const
pointers. Constify them, along with a couple other helper functions in
mm/page_counter.c along the way. 

This started as a follow-up to [1] that quickly grew in proportions :)

[1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/

---
Tal Zussman (11):
      mm: memcontrol: take a const folio in folio_memcg() and friends
      mm: memcontrol: constify obj_cgroup_memcg() and friends
      mm: memcontrol: constify the lruvec helpers
      mm/page_io: take a const folio in bio_associate_blkg_from_folio()
      mm: memcontrol: constify the mem_cgroup accessors
      mm: page_counter: constify page_counter_read() and page_counter_margin()
      mm: memcontrol: constify the reclaim protection helpers
      mm: memcontrol: constify the memcg and lruvec stat readers
      mm: memcontrol: constify the swap accounting helpers
      mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
      mm: memcontrol: constify the zswap and socket pressure helpers

 include/linux/memcontrol.h   | 196 ++++++++++++++++++++++---------------------
 include/linux/mmzone.h       |   2 +-
 include/linux/page_counter.h |   4 +-
 include/linux/swap.h         |  12 +--
 mm/memcontrol.c              |  37 ++++----
 mm/page_counter.c            |   2 +-
 mm/page_io.c                 |  14 ++--
 mm/swap.h                    |   2 +-
 8 files changed, 138 insertions(+), 131 deletions(-)
---
base-commit: 178b3d97bf1f15f598ea7cc615a40c115e528e1c
change-id: 20260807-folio_memcg-const-4a67e40d485b

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


