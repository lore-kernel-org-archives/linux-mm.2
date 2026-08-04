Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1147EC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E6F6B00E5; Tue,  4 Aug 2026 14:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976F96B00E6; Tue,  4 Aug 2026 14:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83DC46B00E7; Tue,  4 Aug 2026 14:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A02D6B00E5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A35821C0475
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:45 +0000 (UTC)
X-FDA: 85064483490.07.A8406E3
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3DB5580008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=XZpc3OUE;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfuiAq9fRwaotC1CJREPqRYjNBrhvyD6iaPba22WJLg=;
	b=HqlCCNlsiEY3udWnZTwy51bS7n9XqkrQB/UEK9rQ2hsC4RHCSM3iBE3F+iUX42Tw6thC4S
	wOUToVCOOYBxLOiVqlIoeQ09w72JV1Xom9prcyGiJ836CRh8He1Mt2x2vx64kuzlyGmNuW
	RjmUKsdF5cAkoS4MQQU/8+h8T1zlznc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=XZpc3OUE;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869563;
	b=jHSIePxBXMAnP25euE3k9AAQBAUTSftTwSw5boobwCHDlv3W286Jh3l1/JGxQ3eHGP4OFH
	zSDJRQPoHRhmXm2LdwK8IGQZkxkSACTH4LdfRoh2fFIYkciOMKBuxRcnQVVaO6T5L5OXqV
	/MNuKJsGrqzhltbz1rqDsFMqztaulKA=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IYALa2213085
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Hfui
	Aq9fRwaotC1CJREPqRYjNBrhvyD6iaPba22WJLg=; b=XZpc3OUErFhDuYUKKUqZ
	NgyX4ZEu4US2rdX/qTNvhwRViyaUx1n5QBVsAxLukRBmCfbhPulRIl7pI8ZDFjaF
	K+vabneR/odcpWaGUDF6t8CFft8WaFIHJCl6b6Hb9O/LgrsKt2lD7RQqD0CrJLqi
	29pYTxRZqvs0ZZJu4YByWOtr9BqMmo3FjbIL/7WTQIXBcHz9ZixlSTyfn+p+tY5u
	672KBL7qpWA54lXDvJWLL13s2HDgKLWmET9XFH5k3zkCZTcEsd+FHAzNAAAjAdeR
	gPLlUl4louazwblLm7hX411RaqSamXuZedV75DfhQXmISFnjR8MZBWTXH3xweNSD
	JQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fukgqs6bw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:42 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c083f1818so1257201cf.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869562; x=1786474362;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HfuiAq9fRwaotC1CJREPqRYjNBrhvyD6iaPba22WJLg=;
        b=OHFlSc7CsyRjOTzz39a7ZF6VKbzzmPhwRHW4jGLjt821wh4NOmoR996ZLH8P3bYdrp
         V3/DmL85Pu1ZloaMN/qYg1U0HGkiRmfji2Cn8Gq+ruHrT/rTd+lrIaSw4wgcEl97GhHH
         uuQx4iI+SdfRKhVdnhRRVLZGxljUjC0zqEXXI1UIp0Ln1k+KAJp3au034KvYIqMAE4cY
         UEr0Foq+h9D6IMjd6reTPCvdInSB6JcJe/LsAdqRhwUqvc8oUkNk7b3EZQx2CDlm4Ww8
         Cqo10z/rT8AcwZmYSq8I+uy8cT3aMMoRSpWErXe35PPJUsHAiFFRQj4ILTDOLipgbD3Q
         vrDQ==
X-Forwarded-Encrypted: i=1; AHgh+RqvF4AruR8P6ixaEYxuybRYoaY94074IIrlr0e+Z5hcOYbT3GrscnfHIPONJ4BYDv4L8dJq3MilwQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/EI0j+vdX0z1FR2j4V63lo1TGuSBjj/Bm2LAJvWFXNd5Ob+1f
	HRhq4t2XPx5YF1CND1BHJ1C450ddLvZWu/e+BesONjSeJBMmjdGnjvPF/xuzfElTMTU2dgVqHJU
	PvRBWR9FVBO4dpbL3M72jc/sb+wXWJXIZfud+2jELmJBaxfWwKf9JHfpK
X-Gm-Gg: AR+sD10BWmWQdCcT/jquFEt0wIPPumFmC3NjvTBJL/Ra7oCEq6BtIAwwQcKzkeBWCvC
	YgMLUZSQVJwCGrAmnieUU/TbJfL8fplwFOAQpWRZ4NHYYw+X/4gRvQUr3/H1lpyzDBK6jtBfccy
	HvVM/GVutUzUq/PynUgVYSzkgrUSKZ8JxuwBbqiuT0T0zOiik2avuWPXcAzPwVQT62SwP0UhoDm
	/x/LBJzsRmsANRA+MaEwgsnapohw1jmUPqmBjJy9CiG96m/ViVsOA5P5gy7qEANujyqiY966eMj
	+Vxadxy3i/EXd4St6AJXQL3u4AiJwhLMrANnUCaswcyIpJTvCSWVxXtU0tL0HsT4tuzDP8vKMs8
	toqGIz1G+
X-Received: by 2002:a05:622a:2615:b0:51c:2022:cef5 with SMTP id d75a77b69052e-52ce61009f2mr13701571cf.26.1785869561759;
        Tue, 04 Aug 2026 11:52:41 -0700 (PDT)
X-Received: by 2002:a05:622a:2615:b0:51c:2022:cef5 with SMTP id d75a77b69052e-52ce61009f2mr13701091cf.26.1785869561259;
        Tue, 04 Aug 2026 11:52:41 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 04 Aug 2026 14:52:14 -0400
Subject: [PATCH v2 06/10] mm: remove thp_size() and thp_order()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-remove-wait-on-page-writeback-v2-6-81f0ab065284@columbia.edu>
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
In-Reply-To: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=1208;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=e5RnTghCgGxRcPefvNu8eHDy7gFWlXJacvM2LVI5FtM=;
 b=352CGDr9OG3l8KsRpsq9VMlqpPZh/MfaEoDT8M8ftVE1jeGcs1HXBprsWM41xxX90zxLaaPU/
 J3mqutft1KOBPqpbEFXWNVkoXdMQb6b5ZCY8fxhWijzmLWTs7ZOOQ/3
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX+QifMgGeW+Yx
 6Q6a3EPb9dRAT5CTp//vg3y4TqSnzK2W+xvFcBJRcyyhEvKMLYSnmFC0PP4SqpTPZU5t4wmpKkJ
 LLbjoB+4hu4KuN8anr9FAxFROrGfR2HjREADiqcpLufCJAKfbm9h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX+u0uYWyUGJHg
 9TjN0PPqFc6ag7MOO4mtq/Bf+tjJkIt82h122wy5wAqDybVzXzM/9YfH5HkHegXDafu44/vZP+E
 rNJIFr6RrX4jj9EHotnii7U57xltgKav2LamENR5FEsZnYzRoxvh+xAU9UFYUfIu6AinayMekLg
 An59/SGJRRdY1YZx/cKeXbSxHUZgTNGqRRXhE9dLHR9kz0lLWklbY9kJh/7RAx4k5FHdClc+J5V
 Ih5UtM3CWe88eAxmpNvZgzifZ8ORv6LrNx+Yp5xbujh4pFYRh78mJtkqLCk+7k5/blhdpo+uS5C
 pATvqQ7XdutmZICsAXvUDcjQBcmL3K1ByVM1qTu0esIOImrSlO1MpuPrDS69olUmKoRgAhIyUQw
 3NFTu7yDYVmtRk4IrOXJD4AKbWNBcykz2SWIYe4EMtC1cqQTrHepVSV8mLq8bHhXbFLN6Q1ZkWO
 JSDPOmnh8J4yMsvKRKQ==
X-Proofpoint-ORIG-GUID: 5zpwcn9ns_q5Ayem-mPvHrNf8p0rOsO3
X-Authority-Analysis: v=2.4 cv=X+Ri7mTe c=1 sm=1 tr=0 ts=6a7234fa cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=5wpFShScvf9Uq2YMFBAA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: 5zpwcn9ns_q5Ayem-mPvHrNf8p0rOsO3
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 impostorscore=10 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=10 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040152
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: xqastb61de8z1apindm8iwi9xgcdjz5s
X-Rspamd-Queue-Id: 3DB5580008
X-HE-Tag: 1785869563-781504
X-HE-Meta: U2FsdGVkX19Ld00Fe1x5hymbSbO96orUgW2/NKKtEuuB1rGx9zsZLMq3z5cGqDjX/3xEk9nZPA1l5G+r3jHiyjGCW02JR79JgxdGLG9/2nqHyfC67Soh7lVdqQHCdB9nLf7uR+kmm3RORKIGbmeXJtDy8CsB6wL5d2kaW5jMSWrSV9VougfhVdZTJDuF68iVT6x79eokP0haAfH9jMJaYRjqETpvJwOzhPncJRXd2YDG1M50teRTSPsXA/V+aBIX/qlNprUw+Wdd1klQC+oZIIktSbcEYp+ymi8eqAjkmPaVAjh2Esnu4eekhT9gg/ZW553QpWhnFqgCCzXRtBKzTcrSv4L/9K8eNsW+Q484OjdUbJgKzPpu6XCx0cWKLgzALdBYV4k6VlFbxEVCYXofbhheULo5ZGdIY9+2Z7GQXegF+qxPi+vm4oiV2Y1/OcXrhDl/EIo2CpAY3yWsEpfvTjyFsYvZd+d42WJWhyz6Fr6tvNOZfnJP1zm1pXEXKdOkJR1oWHw6zalqiMYnNxhB8mVl+Sw+IDnDYkI0wJjBIoVIgatm5BYbvEjnq+wmruwAOlMHVXCYf1YdhKJAT/EeZfmt7XLteMg9P8ACO9hZrnoAfjsUkuY7S2pPKskIKdnhf+WMyHQkSqEdS4EIPzAMcOogVJQXOCHOn2qJYeSs4HpQNituquGuzkOoLRrSC8t26EHPtFX6UYOSATVzN0bcHcBYPVkcYWhWmTXHbfL10djVo5hNGqeI+Vx/Y242/V3+y12GjWPhrAlYjXBTEkYGdhnViipatezodp2U/V78tOIv/DIPQNa/ji9Do2VGTXW1UFUvggrj+ebY2tOBL4MqsMuHihUNUJfHyMxpxtmjEogEgcajz/EKoTMpGiUQKHiYVTTLtkO6YOf5f8xl6dG9GSCaS1aV0oaJ94+6O/CZBKposAmuJVnmPjdUkVG8XbFMZxaFjc/CxJhsXS/n8f1
 iMNDG5xr
 EfrHPmosqOqGEajHvpQHvVJZLMJy7se2CIpOxGf4QTFS4cwP5s5PLIJE+2ssRmrtOBEjeXAdMWMqXQYtEPgCJBs6YkPSfkTqvpUJO/yF7dc2p9QRQdO6/wOAFuGss8H+/8hRBZdcMyqpO63Ar6vgYS7g441OvSgsnwcEeBc+QIBc16Qw/EPYevn8eZmOEpPrusutHeCGHWNWySX8JMrBQF3cH5hA2+Q+n36l7lbJ/7tHELhbHCSP8KD4iq96YOpEQUoiv30y7fZ/JlKyq2sdnnueHPee9kzIlT0he3G5yKUHRZRW3FU3cY8l9NEPjJyWU/hPVRw7RT/+pnIcI5/8NyUtC3bTJgDgvTrouStbLkCFFjlKwjgyquFl/gUibIS/mHAp3QznvqzzdKKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last callers of thp_size() have been converted to folio_size(), and
thp_order()'s only remaining user was thp_size() itself, so remove
both.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/mm.h | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..48e821454ca0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1966,27 +1966,6 @@ static inline unsigned int page_shift(struct page *page)
 	return PAGE_SHIFT + compound_order(page);
 }
 
-/**
- * thp_order - Order of a transparent huge page.
- * @page: Head page of a transparent huge page.
- */
-static inline unsigned int thp_order(struct page *page)
-{
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
-	return compound_order(page);
-}
-
-/**
- * thp_size - Size of a transparent huge page.
- * @page: Head page of a transparent huge page.
- *
- * Return: Number of bytes in this page.
- */
-static inline unsigned long thp_size(struct page *page)
-{
-	return PAGE_SIZE << thp_order(page);
-}
-
 #ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when

-- 
2.39.5


