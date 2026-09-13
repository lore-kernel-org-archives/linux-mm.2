Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C316C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 21:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6BC6B0088; Sun, 13 Sep 2026 17:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68506B008C; Sun, 13 Sep 2026 17:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9031A6B0092; Sun, 13 Sep 2026 17:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 496BD6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:54:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0A5F160BFB
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 21:54:13 +0000 (UTC)
X-FDA: 85210092786.12.09D1B6A
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0644620003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 21:54:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=a707JlvK;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=y06WPO1W;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789336451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRoVtCxPXlE2WTj7/cuKQLp9U1WSy4uS8DQXyNSJ1GI=;
	b=zXPlNtGU1UdhW6pNFoWSy99HYgeZAS4TXSZPlQW8HH9LY7wRC4afl78kAtp3vocATk7E/O
	DSfwZGOU+ln1UY75aQnjEyljfqHqP8p3bObpruhOvYuqIsrXdSKYUKGfjsi2QIitj48EA4
	V9kQfKoG/y0w0m7pO14QDrbWhne4GEA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789336451;
	b=fMU9a08kVSi94BdXbFAT+8cHP+OGLrXrbghH3svj+Mbslx8vifgXkmUm4hAw/CucKBw1Ow
	PrGGxSwnA9x28ANLu4JUY5oX/y2l5lMUxS1VwvNLkqjFEqI8r6VV8K9X//kcW07zrlNKBC
	ej/Ick1yp0pMMde99c/+QgD3wq3tDlg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=a707JlvK;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=y06WPO1W;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKvJg6599690
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=fRoV
	tCxPXlE2WTj7/cuKQLp9U1WSy4uS8DQXyNSJ1GI=; b=a707JlvKtuC6saMFXszo
	48RTvnQk78GeFs5uHDcT6SKuA7eDW6+BrVTEhXs3jwE8cnNkDDD2dAWusohAzO3g
	HlznYoK2KnQND9jw4Taf1Pu8L5w/OZ7FP7tA9OXIDq363SIXMe0YGXkTzGg2nP/o
	SpeidmZI56MZiDB+5A0i0qzhEyjZ/AezDp1zgezSUBtVPC+zb8K26Delw4+zyxSi
	8a+aYiorEI9/lr7viJuNv23x1bUrvMToi6Gp546Kh9pYXNwC77vvO0qWR2yM46n1
	Ell5m+zd6BNAs2dmgp0+pMHiQbDoy5T8z2vJsVoGNU3MNp1BbZl+CkSkZJEoHi3M
	wQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp3ah86cb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:54:09 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-939062ecda9so415128385a.1
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 14:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789336448; x=1789941248; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:cc:to
         :references:in-reply-to:message-id:subject:date:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fRoVtCxPXlE2WTj7/cuKQLp9U1WSy4uS8DQXyNSJ1GI=;
        b=y06WPO1W8ZuoPZaKosbFe94e8KkqjhnuE3pLRpEEtxQOyHi/Bl/uzMDicKMFSpLjez
         q061v1NDXgRyjCg0ftmp+rUMyb0EAhR2Qw/6IUcpZpRvvidZQIkk+bLndUGptN1YhwfF
         z9PxzAbRpz/68nzASLuSq6Fg7ztY26woZmt20afLi8Gf1moi2VecOwgKsHB7xw5pAxmG
         NJV6N37pDB41wlW76xgzjs6hA5/Ml9grWuDuLxr4HZQPH5OJgIO5rsY+evhXE2ElGDpg
         DKZvDU3X4ZDFHwbLdrzvjfH1vt7a5a9MBSgO74FRkADbPco02vmHL0Rsn6fedg2aWQVg
         4v7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789336448; x=1789941248;
        h=content-transfer-encoding:content-type:mime-version:cc:to
         :references:in-reply-to:message-id:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fRoVtCxPXlE2WTj7/cuKQLp9U1WSy4uS8DQXyNSJ1GI=;
        b=R51R1tiCdqoWIIcACMvwyekWyiozIcfZbys31A+g4P9uoX0RRrX6oEeqQ6MNDbah91
         +w0JhdqoLgtQfw6J6C7R8qBARbVUBUSBpXZiGADUsANKbgdLG/DVO2KdsTASaOqf1k5+
         XZu+J6DSXEKG3r5GtgVBkZFcUPMOAQWr4MQWK1rBHR0zR0hZrL2GrDbyt23jxv7Bsh1l
         RaYTlBJ5k/h8JqgJ1HWtupOTMSYf0TacF44NP1VqxTVjl9pZK4iFz8iwvuz4kPf2dwDM
         Iq6U0ctciXLb+A696MJYKqxXCO1ZDmhk1fbxUmRGUbUEP3g/QAtBgji6Hk1RJO4U5rRz
         5m+g==
X-Gm-Message-State: AFuF++m3lCFu1KqPI+fZxLSvHk6+m9WDQ4h9JVl4kOekc1F4OTnnDBD2
	tRi23bUvJK3zBuyWdZojrtwbFTkL57ri0XbKdE+2e+/IzG4SyJgZNMSqjF0KmhJKITwxzvipk/C
	UP0R6u/zQLleXjUTVe9lobkg7+e4Wz1VDdd9Ny0iNuZaMz2Iu
X-Gm-Gg: AYBFou2cKzrAtSpzH8hsEdUtRK+YRVPUWDzT5VzAzM4vRuy7+LtUfzvcqIcdAMOnFrt
	LP9Qrh6mNhzW1Qw2eZt5pNGrXWUJmBabHtvfWQmugI7jB4XTFIhyI4fE+lqyGD0WFdC1N0wCiwv
	jCb4DzJaGZcIXmnJi95u/X64irxgd+YCHTTsh8q7gYC73fvzyPb+updu/VI6lbaVV2G6bd1zROZ
	3H26BQNcUeht7q/XRz0gSJzWw1iXAD934O2FvVzbHgkerbKvB/zNJhPqJ40T+z7+YthdJjo8tjz
	n66qyCXGfDSUCR6OjSpQhn//Wr/futQEaT6qjQ4T8WFk1sJ4NBW7YG8UqccyBZW+OT/Jz8dDlPM
	DiyQPKacux2TXeL+qSxEb7P2VpYt89EC+A/hl+RegEj0q8tP18FGRCQ==
X-Received: by 2002:a05:620a:2a04:b0:937:372a:b97 with SMTP id af79cd13be357-93a297fc791mr2911985a.17.1789336448494;
        Sun, 13 Sep 2026 14:54:08 -0700 (PDT)
X-Received: by 2002:a05:620a:2a04:b0:937:372a:b97 with SMTP id af79cd13be357-93a297fc791mr2907585a.17.1789336447954;
        Sun, 13 Sep 2026 14:54:07 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939ecc38105sm762619485a.4.2026.09.13.14.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:54:07 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:52:28 -0400
Subject: Re: [PATCH v2 1/8] mm/swap: add folio_swap_entry() and
 folio_page_swap_entry()
Message-ID: <20260913-folio_swap_entry-doc-fix-1@columbia.edu>
In-Reply-To: <2b0a6809-bd88-4133-a002-7a9acb2a973e@kernel.org>
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-1-ee6d01dfa5e1@columbia.edu>
 <2b0a6809-bd88-4133-a002-7a9acb2a973e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tal Zussman <tz2294@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMxMiBTYWx0ZWRfX6tBqzF/AEP05
 RXxpCQStsiVSi/OdcqIdxc22XQs7k9SFc+H/7QEqw4kyBgOr+7r+Lis7Wgw66pgxI0Wd5bczDhF
 1PiMX4hcJyXVQJAT5RSjq/sc+BRh1MIBND3ue4mH9dJ4hXNNFEnE
X-Authority-Analysis: v=2.4 cv=Z4x5j3RA c=1 sm=1 tr=0 ts=6aa71b81 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=02raouAbq-PgjEkgBGoA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: 3SxplUn6H2wHzufZgNl_ctJQGr1LQt-h
X-Proofpoint-GUID: 3SxplUn6H2wHzufZgNl_ctJQGr1LQt-h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMxMiBTYWx0ZWRfX5y2NbOBdOXzF
 lkDj69VB+NfQRg9C8tWOAGbdhrMvtk0LWfMOMBBMf1MJ5BQSFcD30zxKNTIDafbbkzhxyczx+Ov
 SBDcvOLgGwTeXaGsTsFawYnpj9xQ0TfQiX0P5ilie5mKLPu1TX/kqL6NjZQOBA/Qq0ZS7KLBwgu
 +EzvYjwUNAIrC1A4Y421VwtvCvGPF78NS6FrPxq0d44bxp1NyUbdhs4hB8gJnW7GUIJyhyS4Ygd
 tjnzuNcuSGa1KFSZN8PU/6Af5NtNI2ZVAvmDldb2soo/GHUElYqLpP5OgAeHaiUhJNlntuhbCm3
 cmzWQy0L/+M9iTIn5334xErc5N+2ftadJteKMzY57St6iKSellir1lFgT5RrCkGwYb53wUfI+dw
 I3W21Rmw/LXomNpsY2nW2VTdb99OEsGwAKIO2XfvEDTM5Bh4SW5ZIkkgF8upW3KxU2lB3VLOX7x
 skyDPX8YIPQNjrEHugQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1015 spamscore=0 suspectscore=0 adultscore=0
 impostorscore=10 bulkscore=10 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130312
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0644620003
X-Stat-Signature: y99a5nyoyyukt71c4s3iyit7t4kzrn3n
X-Rspam-User: 
X-HE-Tag: 1789336450-261057
X-HE-Meta: U2FsdGVkX18zH+SYMMpCCji7mqFX6SfSWWe/VsTACVX1S9TkLcxcV1tVoGjxt5rwBmeTaEG0rFgEgfI/YOr/S7A3BzrgtBoslWL+8bu64n3C7+4p0hKaqj2R+ySoKHI576LV4im4KrFMmmpMboHI6Fvw9Cgopu7ZckAKuxLvWFpopPCw6j0FEMXqyO6YJxwBEkJUjVTQr1aPrEiiz//uCCzOXa5b/CYavSROZSKyhgRBHfkmVnmITmyoQzf7JJR9zsrz/eoE8nOCQegZaoB/MICCZdMneECNcI31Mz7HM98Ob3Kx+7RHUmfBDQb6N5vNk+KvtEnFAUdXq3qMUIjWrw6kn1KZCrMDZJ6ku9t8fL3fO6bQqPgbjC2Qg7yc3oYtrZ0CyL3ZHNngBXexnB6t3Q/kfsX3sNl6fh6c/3qS0GXX+fznRYEDX9tq47M/DMZO2UXdpFnJi5tzaAruUpoFZ8hUXv8AiIy1VKYjHtziDEclWTXczn83PnKxw7A88I5kPXVOsLUbmSllA7TJmWp/bw/5TTBJSANlIk85F2Ehf7R2HB32hY/Mu+QQJqlDCcUdOfAkBRXOp/Yt/WjeJgrkzf50dNdtOEplOpNS2S438+sLbO4KKVhweNHbT65/mpml0WULrIv91NsxHXMpDvou7ee76E1I8i/oDjKE+lGbU2Pma2eHITI+YDXhZtU0j1vRCFZiba/fcRZdU1Lf6vnvWvCvF2/ThlalT3j/xX3tPOQ+xCz5mp5ow3tBaxg6kRsXfpxm+8UrTmz4Bbu0RsZlks0AedI7webbQnxBTWyXDM91OopRBDM5ndsN508UbXjncLjAfj8LaNE/r8Fmlbuvo+SOyB3ibJ+W00VV0XTjYC6NFODukS9x4fdZ7y7IVtL1hN95teYDAlYdS8AgwNsf3dUA/sbfNpMJU9J6vOj17Bt8oRk6fkGrigu8he2oRmYo9+EehABgiPK0TygOj7w
 c5t8AjM2
 F1Xk6zEYMLp27iWqUIFFhYyeXVB/uqShiffalKKkPzeS1b0MPOHjkgwQRuHSvLsUccg31DShD9v0rDQAVsmANNBWQHMX9wovgJSoUS1dSWWTqIFNAdD8FagNjSuhrdI1Qcnd39TaxAyhgk8LilU04AGhLoPBVI4vbDOmXT/umPRF4NCEVg6iHehsYCwDhx/0N+68wgPpyrA5xE5AkWKqflXDUOGbeSUpTTSCnWLqfUx1dZ5GNiOSDpyXIDBV4RuaqhmWxEjYMlUrsZKJkKqTIUupxgoecDVBQysGbyjDlF6Id5JvVbTHveZdgymNkU4wRDYSL6Owejb8gVDwC98YZfIlm5FEr0jP/ZeyKsAUtbNh298J2Xl0UnTANzdVLbu+L574btOsCQogDyMNckLfLEIuUSqYR3DwjL3Wkggjryqs1SazrUQJ2Fnrrw0zTpV7zsESVInuSktcHjAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew, could you please apply this as a fix patch?

-- >8 --
Subject: [PATCH] mm/swap: adjust the folio_swap_entry() kerneldoc summary

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/swap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 78974da6810e..43155e122b5c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -273,7 +273,7 @@ struct swap_info_struct {
 };
 
 /**
- * folio_swap_entry - Return the swap entry for a page within a folio.
+ * folio_swap_entry - Return the swap entry at a page index within a folio.
  * @folio: The folio.
  * @idx: The index of the page within the folio.
  *
-- 
2.39.5



