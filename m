Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553D7C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 19:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574DE6B0088; Sat, 29 Aug 2026 15:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525946B0092; Sat, 29 Aug 2026 15:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413D56B0095; Sat, 29 Aug 2026 15:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 182E06B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7B78A1C69
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:23 +0000 (UTC)
X-FDA: 85155245406.17.7D8C9DD
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id EDFA3140003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=vRzWGp3P;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ChaCC0dl;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788030561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ToKXA2E5BfEmvaAKFfDpLFEMj5+An4ZLCsEMWKzYkac=;
	b=lAT5YJNYGH4VTK3bxDjNiYI29NMqL5Ocaj47o1aJyenCcyZkUYhzOdktNsfZ1v9CL5ANIu
	FPViOTWleJe89HeNuMNeEQ+pB9HoublicKrNFQxFGwS3/GXdVMz+mOylDteENzV0tf3bjA
	RcXzyMScBL7SP+WTkMT/EJjVE+k+0ZE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=vRzWGp3P;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ChaCC0dl;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788030561;
	b=fkVrMwQJsona4pLxcG7COlBS/tTJmr4xirUxJBX+JWw8kSBB1HhJ5ej9xooJ9tOwNMBaTi
	Bcn7ISTDzajVxv7JYUjDGXQKNKxREplrnEb00pz5XV+uqF8kN2yECyr/CBdC5mfFzT0e9s
	qnI+JM0lG3fagogl89yhR8+qcQ4mkvs=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TIZsYo2639629
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=ToKXA2E5BfEmvaAKFfDpLFEMj5
	+An4ZLCsEMWKzYkac=; b=vRzWGp3PShzsYmdleClg96dg/KzOFT8uR7VQb2CVTV
	iBzjoXDFXpecYoiM3f4Kn+5eRut2LAGp4akbqeekHylrwTPn8FAPPiVpds/s35nn
	ffjwKZ8RxYfDRsIWcZMIg+dTr0KGUzoYUaTUQzG7e02P+YDpbPZhSJ9EPjUMOG+p
	B8/eQCYOF8k0qF7JVkx6IXJf82fBX/Ygy+5E2MxfrGSjDXv6kXDVcahlCjk7ZqX1
	uWzpHDTxjuVCN+O7v6h2V23up3RNdSqfn2AqJwyyAZ2bLQA2ZOk43Myp4eUFoqgl
	4tDdj7ZH23y+bsEgjHOAjNNlwm53TLxbiUfF/synkw0g==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gbree35a0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:19 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52fc1e88189so30757061cf.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788030558; x=1788635358; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ToKXA2E5BfEmvaAKFfDpLFEMj5+An4ZLCsEMWKzYkac=;
        b=ChaCC0dlbZVTet+TM0sE3/YVy37aM6RMkZOxxIk4sERHTtm6ERWF+DW87VcGd33t7W
         H8dB+1jxs37r8bZkZOFwDW6Q7x7f4jvh3cPPJ9hc+oqrHOdlUtascaJuEEVoSXudXu7e
         cuMt/P+goidp3snJzJSTrR5PBWbjrP8BjTGUwlm4Bmi/Q7ERx+kF/tKldrt4hfX2YZXA
         Qus08Dbq8HQ5qvY/lvize20NrENZEuDNh9Qww8sVmsEsx+o3tYpxqtGZNq+sxjJWxo+t
         fEwRp1QokYBe7aafLegHW0Vojjcm8P/4xlZ/FHiZvH/k9VJnvdf73Y7CHTOqXTzLPqv0
         tFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788030558; x=1788635358;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ToKXA2E5BfEmvaAKFfDpLFEMj5+An4ZLCsEMWKzYkac=;
        b=jb4eVqG7GxMjbGzV4qYkxIhLqsjNO9UwyM3BWapBVc+I/YDbC+9nImNjpxVFCxzm4J
         DoGpS5JgKU/8LHC6ghnCN6JK5es2E1MiMJBJpJc0JJt8yjI/GGlLG4H9WX0lO15hO15b
         7bGbBunCJTuTFqnfPArtyT10+Abn/TuLRLV/yw7zt7Sg/LHf+/AViNt62fKxSKAHMnS6
         mxdu8r3mAxQWbkKcGB5l8M8Ha5N9IJi9PYcGY2gJSRSlKjpEA6x5Ec+64ToEABxv7ObH
         LO87u3mnVXQuGDfAnf+D31GT4mCZ4zRkr4mm0KpG5i6vIjgJnVLesnGhRxfVooGM5F6z
         1Mgg==
X-Gm-Message-State: AFuF++m+xbSAZMXj6bsYNi85B1KxnDJo0XUGcV1UF6ekCxdcu/LjKoQA
	vI/RKPEFzLM956hBKnVJu5A04CPLGP6HAz1R1NtYZj1zXo8QD86+3tyPPaTW+IR9N4zetBXQOVz
	+2MioEu61W0jTwPzeMaOsmgx/zewIw5OdF+TRR9mMk9iIC0w4
X-Gm-Gg: AR+sD11kBO85Uf+oY6ScwoO2uaz4KvD21fFe3BBDUZZMXQFktQA8CEXp3Zeer+W2Dh7
	IaQGTBK6T7QoqganO+IkU2O2tcIg86Q5z9QfVgsB9+n5qe3CXYbht98sy8DYyW+r1w9dqgcYlXr
	HNe2YmPwOytBI5Scz0epSN7dilgnMvWnm0uK+e/LCkpGvHuugBAajiSOYn3XAliLMPE3+SBPTjz
	uWVUFIDhqOxowTjenS9njR6Kkw97AmLl8rBxKjC4PrQt0A4EAL2e4plK7iBtb/BEWh0E1dQfOcq
	8I3KdDoCGXbeskuJUI4c6HEtsKCit0JjEyxwBPr8pQ+72V63bDj9vdIV+FDmrI0jJKXY5SMsCMR
	9pjBJ7fckZm2lgWpfHFMmBV4ld87W+gPVd23j/ZoXGw==
X-Received: by 2002:ac8:7e8f:0:b0:52e:3a38:8cb0 with SMTP id d75a77b69052e-52fb9425a08mr184800591cf.12.1788030558509;
        Sat, 29 Aug 2026 12:09:18 -0700 (PDT)
X-Received: by 2002:ac8:7e8f:0:b0:52e:3a38:8cb0 with SMTP id d75a77b69052e-52fb9425a08mr184799641cf.12.1788030557913;
        Sat, 29 Aug 2026 12:09:17 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b963c3c0asm239150095e9.10.2026.08.29.12.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 12:09:17 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 0/6] mm/page_io: folio conversion cleanups
Date: Sat, 29 Aug 2026 15:08:59 -0400
Message-Id: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEsuk2oC/32NQQ6CMBBFr0JmbU0pgsWV9zDEdMoAY4CSFoiGc
 HcB9y5f8v77CwTyTAFu0QKeZg7s+g3UKQLbmL4mweXGoKTKpJaZwIsYTE1PdqJyLbsg0lzLJL6
 ixDKFbTd4qvh9NB/Fj8OEL7LjHtqNhsPo/Oc4nePd+9efYyGF1HmOxiaoVXa3rp06ZHOmcoJiX
 dcvWp/rUccAAAA=
X-Change-ID: 20260806-b4-page_io-folios-5980317b0bd5
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788030553; l=1480;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=KIOBXzna4+qDQlzLsK6sgmn3CS6qBfm3FAav2JwyAnA=;
 b=v8QyEUdRlmmCcy2MaM7s5g5E0Cmmylq1uEuKjwpDA4FNHnw6IYH+wJNyL9wP+pTozzqmHjw/b
 Tf+ne970NPDBxMFoi2rAgD64fsy37AAC4BzCEqHlf1Ro9a3rrgqYv7T
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfXz3+r4cLxQ0IV
 qaI7zUcvnXjY224YOFdJFv9B4EkOf9ZicDVpJFs7aTVWnNtCHc4P0rM4455IaRm7UGIM6YBRMdz
 MjGLQ8+PWMl/4qpuVvMtenyzUtWb2ZLT8oOCxZ/qx8L85udo/EjZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX4I3ved/xKazz
 ZDNdo8ZC8KNUNxPW+rQgLOr5E4aM2GYHVMUnwP7i5wOIIE+W0ZFPBgKm6Pzlfb9bXQhj6aNsKwG
 592C8km7a3x25wBDRVDqcAnXxkIJfZygb3E5CDZVtG9F03kJ1GHupKw8v/UO686+ju6Zt0TVE77
 rchkeJLI1EjHTSpdOI7WDu4A1c6OxBo5lH8fTLndF7t96V6cTMM9DBvxWX3XFdd5e3/CbPWBrAo
 ylLujX05fgEIN744WSUabFEYuebpUFNAdayO1Yq2qau10/oDjBgVTYqAyLel7E6fY5QloAW+cZq
 A5xybcw9khbUt+yDpocDhWMwX7nb2UkQSytg7BLIu1+OwSQQCi2Ic6lOUaqpznqWOWflviLNpqT
 B+uio0UGxlrnXlTmv1KuHRxv4ZrLvlEbQGVPp1RdEQzfgtd9v8Mo4e8WjTCqUhgO1SJwI5cURri
 aPhPCXazADrHjZmE4PQ==
X-Proofpoint-ORIG-GUID: BRDFwlVnuF6MeyVLjofM0N1VW8iz_Twl
X-Proofpoint-GUID: BRDFwlVnuF6MeyVLjofM0N1VW8iz_Twl
X-Authority-Analysis: v=2.4 cv=JtHBas4C c=1 sm=1 tr=0 ts=6a932e5f cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=d2TyfQZRb0Dxy7BKGjAA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 bulkscore=10 clxscore=1015 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 priorityscore=1501 impostorscore=10 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290165
X-Stat-Signature: w6n5j3kbdxb3ttt8hnhe1oi5hk1djkrr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EDFA3140003
X-Rspam-User: 
X-HE-Tag: 1788030560-740880
X-HE-Meta: U2FsdGVkX1+B0vegUNJ3Gg5qU4qIyTNbJ8ujgyv2YPqFsQKThg5+T7oONsIoTCiNAN5sdVRH7xwRVzBcJH6QGQVc3Nszk57X+i3R2f0w6DrCPADY5TaV57oGEczeMr2BBULZejzjF2kvUCzVhhHioVS1O5Bc5+QBWzizN9h9pbC7wraeWZttr3YS4CZLGGE8t4xAGk54tAHsbNlibY1UevKcPsJDvfcOW5VRX/vYLVU3QaVxEUCzhoh3sE01DOLuz+sJ1+A3O5IORLktutySkJMS4hhS5CFOD2GvNVVg3BGBPdaFcPBKxAcMrW41FldDkQ5UUrScB1HosXcRKB3LEtBv9XFdhAYuHiayBG+SCUIDuFLofi2heo/rh3yLNVb9jW4Ds+RdJVtT33ZUF7mTp8AlE6niY+n8NGtIS/CFZluM+wsigbVkgIYYPQ+DkqMvjuiIbmQCg14LS1iKxX7DoX6lvcIM/Qp680N3XAGCZwLFEhw7sbNLxFgAnp+uXHU7H2vy5nQp15JuMNbNtrEMDHSYSlARrJwzv8wvFiuu1kiYkGOrbmfQak3fCiBD4nj+n8ovmcSfAilSujFLx9qLdS9s8TAHkuHt+tp9qfnCz0OrGKGhfKdEHLZrKoG3QFXOQJ2HvIOH3vGRv4/iyOw075QBrd+M+6n///jCIRAd7UeQ7fUPHJ/QOcMI6F4QppXzUuTPKFT5pJ8P1ufQc991pFKMdN2CJENvOjmCndFjCS5bFJp7qw7i+54YGFrTRUpxacJG/oKDG7cVXqnDXv/1YSZMKh3i6LESVsWVJX5d71ysdmRtmkjMP97biY9BuR1T/t5bmNQIRZWhwAz39h+VbflCUjZkR4J5ZaGibrf9YVt8OZWRXKKP0zB6uAAe3348sxbWzBseGyVfRlv343JB2JQ1rcJrkVFQyZfDU6X0FVysml7gCFCQW0nLCwuNkeggbfl+BW/VOUZ1n5bPD6e
 LAt8bDY+
 8oJLkwsBe2UbYb0sbY+nfjq/MZlA6xsMawX90IBxAJW3Bp3xYwnjAZHIT+/AU8vfoikibA+RAZyGjTXiaJyPEonAmDaX3xa5fkZN3pAvh9mhsS8YKAietRyxsibuzHLeoQzgW3xKvLOpE0pSQ/RwrwKmpSusd4bx59bq73Sg8qp6ynNArSc/D3ysZx+Bb8W0umd9UUexc5gbGmDSe50HOQLQzsZN6I8Ah5VN43F4pj9giG5rIMLmffBPndC4XfXyUlaRFiegEasuv5dUWLnxEqNGXOh966JS3rKXrYUybGOZUUmNI1Da7ZELjGUXc43+DIFEHlWwHCHwMoxzwbo1CaGBDnCC6ICzkBIlFgbBKWIJmW/FP8O3aLgfRDHCvY4W2qKHoLsWsXvrs3L2jkmAEel1ISyrjLNEtbEe38p9tkPls+PpcdgIMPMjVXMhi1vtPt7hi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the remaining struct page usage in mm/page_io.c to folios. This
removes one of the last callers of end_page_writeback(), along with the
last caller of ClearPageReclaim(). This allows us to remove the
PG_reclaim page accessors entirely. Clean up a few other stale
references to pages throughout while at it.

The rename of mm/page_io.c to mm/swap_io.c is deferred to a separate
series.

---
Changes in v2:
- Rebased onto latest mm-new
- Add tags (thanks Johannes, Matthew, David, Lorenzo!)
- Remove FOLIO_TEST_CLEAR_FLAG() for reclaim, per Matthew
- Link to v1: https://lore.kernel.org/r/20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu

---
Tal Zussman (6):
      mm/page_io: convert write completion handlers to folios
      mm: remove PageReclaim
      mm/page_io: use swap entries directly in zeromap helpers
      mm/page_io: rename bio_associate_blkg_from_page()
      mm/page_io: refer to folios in swap_writeout() comments
      mm/swap: rename __swap_writepage() to __swap_writeout()

 include/linux/page-flags.h |  3 +--
 mm/page_io.c               | 38 ++++++++++++++++++++------------------
 mm/swap.h                  |  2 +-
 mm/swapfile.c              |  2 +-
 mm/zswap.c                 |  2 +-
 5 files changed, 24 insertions(+), 23 deletions(-)
---
base-commit: d2aad7fdcda7ae8a726926f2d6de7fe9e8ee7563
change-id: 20260806-b4-page_io-folios-5980317b0bd5

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


