Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D9FEC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C656B085E; Mon, 17 Aug 2026 15:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014766B0861; Mon, 17 Aug 2026 15:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7D06B0864; Mon, 17 Aug 2026 15:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A87D76B085E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 269A41408E9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:51 +0000 (UTC)
X-FDA: 85111716102.10.71FA5E3
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 62030C0009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=TeHYh2Y1;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=N9mIp5zN;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994148;
	b=Sdi/yA6pxz2CoMaZGa9Zwy2EBCLQHORvg695tUuPT8fzonXxxGt4K43529dOt4DESF491X
	qgQP42H4E/eer7Gp0ny16ydXKT9pQHPk87PxPQTJQJGD0u+8JarStyvEpc8xN6RukrSFxB
	ahM27d3LYFmEcrD0DK2k5JoKVtH6884=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=TeHYh2Y1;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=N9mIp5zN;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aLyblFTyCRkRNvHlbjBlieXQYnfG93Mvps8LThXIpPg=;
	b=Zu7A6X/DqseCwobIETg3i3W9P38dUSX8ZQ4jzjyA96Jm4yhGV/Y1D5tGQtn0lVBypshG71
	AcLxcNvgJVH542jaDxd64J5BEDYcb3QpZirAYTYQ3ixPoYhvAUUXwii9JrUUaNhwRmc5FU
	pNOTF5xEINb6nOLmqAWuJjLoqzyb1n8=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HIZ38o3423577
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=aLyb
	lFTyCRkRNvHlbjBlieXQYnfG93Mvps8LThXIpPg=; b=TeHYh2Y1YenO8IvrhIYW
	C5kAs0PM6N+jzagTsty3cj6nEqEAxWKoa5R83VA9O7e03R8Gx4GiC/zcbcrDJwaL
	sZpNxHPoAtP4gmH+uogz+ArpuQVxTHrSgoVqVXNmjGKWUw4mfGaIGw6/4CdE0fep
	oy4ldJLO4FFVeyeTx7wnuDkGx3an7i8roVeB9JjozUPn9UmoSX8yoavIWv1OESV1
	PNwlvwyEOkYJdcO81iP57RewLN9BUk2kr0ELwr6HD6zZRNgLFy1Wx8j0+pLtBv3y
	FRkH7mbbp/ryM1sAo74kkUwJto4vpCd3fe1xD7vmB6MtqmXwPBs9ZtzSWKZO3TWU
	sQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4g3jecx6yw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:46 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8f08560ea44so36084326d6.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994146; x=1787598946; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aLyblFTyCRkRNvHlbjBlieXQYnfG93Mvps8LThXIpPg=;
        b=N9mIp5zNXAG3qMRc1NPOeNX8ILYEpaFaetMkv1tFsFzxyNf7s9ysUf3HSFj/CgpB7L
         nyN87NQ2ZKzVShEuw6PRMtZOKFg42yFURUuBTOsWKe8rhQUY0sh0GO7TDPtUbFxqEp+W
         Oj5D6n7WQiv8rqHMg+bU7/oCsav226BL4Xs3UFAgChBkiPSbU68ES0/CVFBnyn6+roVV
         0mfJMz13/V/6DdjsvomQpw/okJLD3NVoUGlB5oQaNIHPw8pEol3cKvmvbh5xyqApOiJh
         NKGr7fJ5yGc0xQhAyqQaA7Zyh8C2VJBfwg+L8HvEaCbS5ccG+o7A9n5ixSvEcighuIr2
         7ofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994146; x=1787598946;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aLyblFTyCRkRNvHlbjBlieXQYnfG93Mvps8LThXIpPg=;
        b=cRIQDwHg3iolCRBylqQlXO3lfUXF4mC9oy8DNrEOAugCj6gcsk4IeY45T9mia2s2KS
         cbGyyBZjjEgRhGkKDrd6iI6RiWZKxIt/M0VmQ+UvTexR1aNSsBfAUPs2ag50hosjP/+8
         C6GQnYpzas93ZN65zS2Sedh0ArY5Bp6hmOAX+tn3lO3BGzP7hoEeyRf10n6K5yBmVw3q
         QlG5OKziAFwzJtLCs91Zj/OqXpyUlbqeXLuIW2Q0B/UkAxYEOQYtI0uwAxM6A30Jfiwz
         kOvoB+dJgeWyoacd2y5H39+dfJYLRJGd4JFVFZ9x4dvbHN9PLnb6K6KYVsCt7x08LvyA
         uH0A==
X-Forwarded-Encrypted: i=1; AHgh+Rqdskj5UyiR5dIYpdYSdJWEQ6O88adPHakru/2QTqL9FNfJ6M18s5ok9Djtyy6QRO+E1cxPxtbs1g==@kvack.org
X-Gm-Message-State: AOJu0Yw6ifjGhlGygJDaZYgPQBdWtQxAarMkirRaXqAQiKBrBAshAnGl
	WzNo85+rIW0sIXzRg2Pl+W4gnFzgjP2uAE764GExne5TmeJidm1uwHNeFpmKEsAvcPeadMD1tPv
	9090l68afouSdAL5FuxO98l4vXX2rEgHyq156eWp0ede6vZcE
X-Gm-Gg: AR+sD11GgBVfnf0oiwJRDf7hqOE+NDwcMecvVIfayLl/3/cKyO9z0Bljg8gMNKGCQPJ
	X+3W4QrJAOFC3NwUjs6bqkAQttMeFEp4UV/VTHqf4b0F8v8JdwCf+H590suSL2HtmwVM/z20pCv
	m2PKTyJLNxJad5eXp06PwpwpAENylQQbTCgsPNsT9vAaw1IpaVUdSp17QOzPYUlPGCzjoctJjpz
	wlPJ5x1yS68bOw4h4ZwDPQZYkGwXMIWoQrcqtVoeFGGaPQmAC26JsUKSqgZ3mfpILrGo3RxP+2I
	Ya7jJlkjj0nT4pblJnMSfNE+CJ7osebFk0rD5ciRxIZrKCRMGB7nsM1rmo4HkV3594zpKPg7Hqu
	OEBJn7jqi
X-Received: by 2002:a05:620a:a09c:b0:92e:6637:db5 with SMTP id af79cd13be357-936d228696cmr2748625985a.16.1786994146071;
        Mon, 17 Aug 2026 12:15:46 -0700 (PDT)
X-Received: by 2002:a05:620a:a09c:b0:92e:6637:db5 with SMTP id af79cd13be357-936d228696cmr2748616985a.16.1786994145438;
        Mon, 17 Aug 2026 12:15:45 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:44 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 17 Aug 2026 14:55:25 -0400
Subject: [PATCH v4 09/10] ceph: remove ceph_fscrypt_pagecache_page() and
 ceph_fscrypt_page_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-remove-wait-on-page-writeback-v4-9-0e5e53d47eb0@columbia.edu>
References: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
In-Reply-To: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=1581;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=eEBEQRS44uRWq+68HnHuSJkJWcepL1mJ0SSpfrhNU80=;
 b=qAtAvRG7QqoV4dTYjah7e0qaLWVlsv2EL09mFwD3adW6JVHxsMbDyjXVpto/xGBQ34jOHpmaC
 Hx6ZlYJf6GyBa6k2yHOfl9r5H5xkqVxaG667fE0uyRk12c/9IGOtJnW
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: UXfiMjbGV3v1kyhdAh9-38QM4he4v7xx
X-Proofpoint-GUID: UXfiMjbGV3v1kyhdAh9-38QM4he4v7xx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX9LQGfsBULQJX
 Cy9Zzn3bg+Sybw/bMmiTrxdzj2q+zIXNwvLZa/7RnhjFwoOlWfKHYT76Sk934utnAoQxhTW/fgd
 /txRh5efz5RY2SjUg2/7KnZm96E5rHAFKtar9EanWNZJMil9/E1hwpKfUS9wJDzmuon0uNOX76Y
 F+CJ81YTzklXtcmJaE5/oMh9f+kbERAJm3VH+UqGbMKGsZ2zE4U0jUeECg4CE3Nz93ukH6+vE+2
 nfs/racAcFdRSM5aAMN+readXs7TJc7ihjGEDAHEJ/gQ6O0slUj38sDAKGV0cL9ODxSlOE5QXFB
 1RVRUrkJB2yYqrt/bmkcBAPyL5ySSFovXCY9FLdQv+nk4wL1clLsNCoxs953MBXVZAS5YYmCm1G
 K9cfsuhYvnLYENtJ7PPcvtVNFE2rmGRU/oA5V4vU0j+/Aq8iBD6JEA7BapTzH6+7Sy7DrkYZoGO
 YtGJESDaKMLr9L5SNCg==
X-Authority-Analysis: v=2.4 cv=XK0AjwhE c=1 sm=1 tr=0 ts=6a835de3 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=jfg2DRd2ap2c96lsYj8A:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfXwEKxrfjZWyBd
 hu9gi6p5xhoURNar1S1A5dPn+vWUZJghgUsa4H2pdTd0PbsEU8zx7l8+FEmP6kO9UWVFLGK/KtT
 I/85ghfml/v1H+Vj8nqr3b0euZHEC1I7vAQxHUH36W0gOwLxh78n
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=10 bulkscore=10 lowpriorityscore=10 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170147
X-Rspamd-Queue-Id: 62030C0009
X-Rspam-User: 
X-Stat-Signature: fw47w3fad41gzu6kdp1ztits7cccyoz6
X-Rspamd-Server: rspam06
X-HE-Tag: 1786994148-924061
X-HE-Meta: U2FsdGVkX1+IK45ZHenb6SU8QZfB77vCNydECRPotBB/XSE6VqYEYXA3thSpplZW+1h1R9tpyzIacMzfrVgZ59B58Y6D2BqGdzR1Mm+sztzkbo6pkN7ecdsO8uNvInezX8CiV7KcXIatbQi1+FIeIvHcbMIIiGFn37xKAnyPmGrfu3gMMYTrYP3jNj+eWuJ8wdJItX2HNAHWD5OePpYbnDnxhemeQQwkKzPBCVl04E9JgC/ftGzYYWSJkxgX9+BBNIPN831VF6xZ54kbcUdRm3T5YRBnSNy5GNjePhLjm/u2Of7fSoCZvkUGKeyuuJYPdqiaxY52eIV7g8S1PobGnfTvMfKLOaf0Eox/zezqq2v5jqbFoKxS7LMl2hO1iNmTFqB1wAed1S6krMzbU9juQeU8uFEeXS/lqpJJmRU13UPfR9D6awTHB6Hk4GGZ1Ab8hPpLmjzJ09yKuWUvNkNu4OvVWqwJs/hwU/xEl4iHbJEfBLXZeZRPGddHPbHkUYZ597UbsUWcWgBsSb4N1yWFvDwiZW0jYneaLq45nEDjJXnviE1PTRoY6KrEFXXgrXU0qk2Bat1ZJjtMpmTyHGF+4cdoTSbFGcqqjUk9+s84YUDoJmxAGMJBcekUeWaPbMowAdk8nKwLCfEC+Os2MZ5SoZjKGRLdFd83BWvim3lSOzQSiNvyONr0efNToB+WWDLg1Jn3edXCL3WhRq45beclhazV0+puIm+VONAsexANhCYiISUbOiyLx1axDFlUayZdE8oEY9CkJ1pmd249Jy52YDjZxXNCrkXPbvUFS9Su87o6H8qJOsiz5cNqwPV2SIWErNdk3+gS0+HTCh3NBWvl7cr3rX2fUmiMe0VMyvjC/nnaEZX+NRcUZx/8fF25GFlqz0AxIsd6isjqYateMqtl/lwAb8ThF4z3DM6x1p+Fxp7JvXXUs4C7wArBlYNlEc/WgmW2c1Ea/9Ihu1kBDgO
 saAB6fKv
 nmGPs66Cw21HN7yGUn7LFSSMxb3iDfSUrEejeKj7e5AkoGQoC7KAexu5ISQW2jTwKfUwRQ0CUz+SWNSDAzuQP6XBrQT0CXhTn+inr0TfZCPZESo91ml/MuPodciSBNb2lY6iDvqZ0aDEIjNgXMkOtbd0g29fAaXUA1s6zYrv4aLLXyidswmYUsj3pNLngEwvVqCbvnVuXA5+VHhyBHota8t+8ZAtURaEssEAqrIMPxilIVwr7o+1hNW8ukDa78myPVtPHjTuxskrx4PSGeo5fBoJUodqGTK1/7Hrzf1XY4z0R5p33i1QyWOw+Dj8lIJc5ToYy8q7u9jP/rBb1INvKiKxKLzttrzAGR6tCVBuad3kFywyGurE5meMgM7kS0AlTiniCnc3J1akpVviCQeTsf7Y5MjYCIpMKL/Yxk4cc1tN7xGrb7FBUjrASR2k4dbsnPo6qZcLQC+6y6Fu2opiPh+os5fcFQYva7rflj2XpTME7gPIO4PY//dCjoPB5j6lCaPODX6y0wUZNreZeLaEHJldS7GTwmHbuC05c5oUOpbzyjc7LUN24xTFG2hRxGl8YgYDlrYLUGh6B1QY2tuUY482C6WKpwYvTZHlqSCZVNoLS6Dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers have been converted to the folio equivalents, so remove
these unused helpers. This also removes a use of page_offset().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/crypto.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 948c8b5dca06..d199dc8410fe 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -157,11 +157,6 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
 int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
 			       int len);
 
-static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
-{
-	return fscrypt_is_bounce_page(page) ? fscrypt_pagecache_page(page) : page;
-}
-
 static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
 {
 	return fscrypt_is_bounce_folio(folio) ? fscrypt_pagecache_folio(folio) : folio;
@@ -263,22 +258,12 @@ static inline int ceph_fscrypt_encrypt_pages(struct inode *inode,
 	return 0;
 }
 
-static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
-{
-	return page;
-}
-
 static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
 {
 	return folio;
 }
 #endif /* CONFIG_FS_ENCRYPTION */
 
-static inline loff_t ceph_fscrypt_page_offset(struct page *page)
-{
-	return page_offset(ceph_fscrypt_pagecache_page(page));
-}
-
 static inline loff_t ceph_fscrypt_folio_offset(struct folio *folio)
 {
 	return folio_pos(ceph_fscrypt_pagecache_folio(folio));

-- 
2.39.5


