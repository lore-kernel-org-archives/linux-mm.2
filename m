Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53137C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 12:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF996B0167; Tue,  1 Sep 2026 08:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0559A6B0168; Tue,  1 Sep 2026 08:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E899C6B0169; Tue,  1 Sep 2026 08:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3CA56B0167
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:59:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41CC8C03F3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:59:34 +0000 (UTC)
X-FDA: 85165199868.28.F0125E4
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id C8712C0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:59:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=JaMguPbw;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=0FGmIS2d;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788267571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WZmHAi6QqDEwX5KYkSzxenVKPjdYPs1k6x2NVtDC4o=;
	b=aZ0vHGBglilPXgNNn0PXoYyN0pSXpW/kpOcK/elg9gABme8VnOzQ1ip9lOf911pQjjPpwQ
	3sXBbobuWugGGbGDlVorVSkN0mlBA9WuI/slbnJnFqVhT/ygMVForlaejz9nB+ekMLPD5F
	YLb8Mr9WCuQ99FrM+a2B9/BmbExUWpk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=JaMguPbw;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=0FGmIS2d;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788267571;
	b=u590bmzyHRvxhlG9pUHrnNNtpW8fV+c2SbAvDBv3S94yUdb3cI1+pnKqjU6v04AnAjF6MY
	aAy3Zj2B7pF3RiI4xcqUybC/g6QeGZBYRi3Mmn0coPQc4drny9B/vuj2VzONUiM1cEOAaL
	D9W8+OUClK9ALOK4z8npejVMe2GED6M=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681CggmO1107110
	for <linux-mm@kvack.org>; Tue, 1 Sep 2026 08:59:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7WZm
	HAi6QqDEwX5KYkSzxenVKPjdYPs1k6x2NVtDC4o=; b=JaMguPbwMV1th5bp6TMT
	vuhB0KqmvDZ9dm5bVcT+26M7s1Pg/rcbUNJJhBsF5DcmdSGONwZ6dFJzEL41RS/e
	NWTngHjphi5Qg4LXe+ZoNfRjoeTNVnFESz7WnMNUNHp5zMovxAHWfcv6SuYaP9tK
	AKV/2L1Btpw3eNer9DagkVWgKOD048GI5SUJ5Pyl7V9i6G7QfPegjlLTIgZdCqjc
	tb/FS0YhnA/+mAcC15tp7wCF2L+Kt5judT2Y6aoi0bNI5oaUXdz3ABBNL4NGwV3c
	WK1qNpriJlF2AUUSJM5vA8R4TMZFHvHyeXPOyMnfaHv2U/TUk6XIB/ueos+vgxOx
	fw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gdxxyr2ud-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:59:30 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51bfe3fa93bso74438071cf.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 05:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788267570; x=1788872370; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7WZmHAi6QqDEwX5KYkSzxenVKPjdYPs1k6x2NVtDC4o=;
        b=0FGmIS2dSonxSKsDAFNobCXXjQidi9FHSy71yPrBqUpGNc0WLZPURJ3c8S0uqXeQuy
         CtBjunUwhvYZi84yqbllx5R5g+sI6E3rQSfWOzR9ilU8ydxNQldz/61EwOEilbh0GqNH
         Wb01IfFeDad1dyt8UGP4Lg71JoT7ZHOIx/Re3GddrTi2jNH7fJd/osRjH3uCqsYO8Llz
         ua/UcsAjMi+Y9X0Qxz2IKZBoffjvR+6bCm87gHcmn8EY2minDL+4FJbke+mOZWBXeWrN
         0GOUmGNxgoYMMf4UMJ4xkRj/FVc6GiU8F+evvVNy5IWc3bQ6YFgtYy8T7G0khUJGrPOo
         aCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788267570; x=1788872370;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7WZmHAi6QqDEwX5KYkSzxenVKPjdYPs1k6x2NVtDC4o=;
        b=ACN/QWlqfq8BKub0lVBIaF1PJ/YBVEFUQpPPcGHTtKkga0M46fCaRKnDuATnBWnZzr
         gTc1KC+uDs/Cdsva0hiR2pA/Z7yOYQ+SiF0X4VsIu/3prxh8aiwMFXTv4nuNK6WoaMaq
         zuBSQR3f3EmwOiN5++pkeDexdJ+PP/C3IMHIFUsYVx9mtUp0iBAi7ZxS0jocSm19oDyc
         hiJKSkclsGpOKYhBq665bDcMOeCdatUHyELnD2lRgQR9czkKJcOAZEORga0M4Wac8Nfi
         igOfDU+NADThmDG5NFchtD+dDd4iU6nSgYHDQfrnscYEIbDhBaCtSz3dtQ0sI75AgsVt
         de6A==
X-Gm-Message-State: AFuF++lNuuc5OzWvO1KdZNHNZJSr7qEqvPboD4uA/OKb+XEkFX+OW0Mz
	kA9PNQ6lfQo/l3mNlw2b8w+91WLF7d1KJwcCRvfHGYPqJEg2Fc0ABrj3GNu6YlZ4U8ZKccHk0r4
	QWKq8Aa/J+oJWBjWv0m9nHRSW6XDhNhcMW1LJWjbPo3YLjeyD
X-Gm-Gg: AR+sD11UadluX0GPUKAex/PZWZfAIdsp1lmXhDsLkG9cor7paaShkKS/kOlHRD0/Q3V
	S8Q+guHP6gWzHN1XBJK/vQx3SxJoG8O1RK/3ObZz67GLlOqlVm0lbqegF3SEJz/eUQ9MpbfRZ3p
	GTr0SHzktljs62StHJ4FI7augaHRzW64CzRYRxFxKSY/We8mZu+toRW6qQvIFnn9v0Cc9vEZf8J
	Skf+t1fy49ziRcuXHus0DFAL3Usx0XfYdkymnGg9WvuLVMesYW+qp39yuq4mXmi1xI2dKIYMYj3
	O9nlrR3CepEFkyV+iupdAobIG+iN9rjI/dNps5khcFlE85/aZgHOhvvEbvJv5D34WyeUb7EMer4
	uznMWo7OHOI6VZnuPx+aKg2yM0cFxoT1cC6WvkNGk8GFxssaCsns=
X-Received: by 2002:a05:622a:260f:b0:52d:f12c:59ba with SMTP id d75a77b69052e-53021d43dfbmr104265941cf.33.1788267570285;
        Tue, 01 Sep 2026 05:59:30 -0700 (PDT)
X-Received: by 2002:a05:622a:260f:b0:52d:f12c:59ba with SMTP id d75a77b69052e-53021d43dfbmr104264311cf.33.1788267568677;
        Tue, 01 Sep 2026 05:59:28 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52fbe830222sm96194331cf.20.2026.09.01.05.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 05:59:28 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 01 Sep 2026 08:59:20 -0400
Subject: [PATCH 2/2] mm: remove unused totalram_pages_inc() and
 totalram_pages_dec()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-mm-remove-unused-helpers-v1-2-f092d086f7dc@columbia.edu>
References: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
In-Reply-To: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788267565; l=1028;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=sL+jb7+lqh12+chLIhZYYQGjMOmxWpBF3iD107xUVHU=;
 b=xsOLRMv+pMGfbkOAUjgN8bpn4nfoA0liC93toFzefiHg1Tkzckd38swBwwetPdujEEXSOsQf5
 TROxiPprUILBzVu1edVu3JpWx2kw6hcVN3DU+Ikgig9jewCJJMe/ypD
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDExNSBTYWx0ZWRfX9bZoLNbE1mbs
 OrPC9Fj87YRuL5gjLpDcl5K55WGWGAmHXFd/yt1tTUmHrnrbdyHEjpLglyWNq9T+xCwexZDAyeX
 KT3XO+001hxqBKNIe4p+ZpYS/J/HZH6JgFABhB9HF7W0TZzpPgLgKhwwEGT/Pz3V2agQ7G3mX83
 OOaX0NxDEh/KCOyyy1jK/kHw1SCGu3cOVVJ6RaRiQJDfSl7qAcFkoyv9UoRkAdbXvcZJXX+p0gv
 0kM8IKEt3W0/6eF57CsRJDDHGB9Kofuw2J34U3xDndZL9ozBKS5rv9k4wkwtp7Nlt20HOwSNrEj
 r5uJn1oios6UrJFHjDoFI7jNAHucl87aiqwQMo69dYSkr4NjwOAiuA7WJYCj91GNNpQZfOESUph
 Ztegj3bdp9jccSNGGoqWfdGFNu7kI9Og3U+0LkeKVJCNWAum5k3CQwgrp86R4m1CDWpbXjV218k
 U5WOR4ddTGR1kBj7jTA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDExNSBTYWx0ZWRfX8uPPpEssBlWS
 Y1LKUuAZjlfprMIo6dv+MfCvPDeFLpxES22q5kfBSWEt+ZHL3aMr8kvL2YAzLJOaItRenNJKjW3
 veAz3POobgrV4lkJuQ9xI+SrGCgk0mEjmvl2CJnkhfGzF8Xc+ARF
X-Proofpoint-ORIG-GUID: y7Xte8C8l0t__Gi23DIZ9Ea3_wHCOAim
X-Proofpoint-GUID: y7Xte8C8l0t__Gi23DIZ9Ea3_wHCOAim
X-Authority-Analysis: v=2.4 cv=fOgJG5ae c=1 sm=1 tr=0 ts=6a96cc32 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=89-YPgm_5HLP6wdRpfQA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11892
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 impostorscore=10 clxscore=1015 bulkscore=10 lowpriorityscore=10 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010115
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8712C0007
X-Stat-Signature: 5ytatefixk36wecbueht5qqcyb9oiwsr
X-Rspam-User: 
X-HE-Tag: 1788267571-475662
X-HE-Meta: U2FsdGVkX1+N/dmeEyMJysgi2ehlw+Vmdd6Ywdv+9pHpg4YJ4iCWihN1LlHQdWlIGvasmxUO+IQtNVq4HwfBoVoFJAbJgjmDJpq5Z4uYj41uUBDsdctK7J60Ra8EBUa3g6DLm2vefARFOpmNy0Kag1ADKzF6wFjIvQiq1NnuXXle0eOsTycmh0D6gNBNSRDHK4cOoN6VKeT6MqaqzLc81r+0gge4c2JRXjRw21atyqlHdgdzhZPggZIkk7HGWCC8Fxd1DcQNrTdHy1iDyTDzbLODqTVlBqW+tMHiww7/KBAK0lKQDlSUxIoURPP2DUeRnZ0zeDjAXhq3ztMZT07SMsJgBHBhce7x7leuNHahgrMene6Kmt88cnSWar6kQsxdz6YKFAdpBbipCF0oJHZOj6B9H0YrmuEVTT8xcO1zteYycURMkjZDXMob2nKJUb75iXS0OLLnvePZUogRE5F+ciE2zMzqnynuNoxfkYFAsjniGBmXstIt+urK4rbdoozKwMc++cZ33jN94An2kPhxHjUF1IMfLD0WRcuYJHUTwzsS372C6LTUbS6OkKizH3VEn+p4iN2D5tOoi1OmBmGboxZsdoiycKBL3QDsBDxJlCtbLfKpOxlXNQE36msxTdxpE2SC3/viPZMm77rvXtKD7PR0SsveVfn5I4AWSt0POUYZWAu+SQY/+hgznr9bCsSUrGn192MGQwyOHFIFOGtmkozayq1KqnY4VCrAwvb/qfNyTzYYFBzR1EcZe2oVSnKirT33st6yQ2S2cN0e1kRb/RoQ8OcQuxyu/pKLSNVd/wtlUlhtgMcT4yJ9jf98tkYvZjTlTlcmaFljBSSTvR/C5kdV7Ut/CcSCqvVQydNq6XX5bRM++qKci7mpa++KXjn0Ws9NInzPoDBgRKSi73a1WPwNgEBSuPf5RGiwj8eYDFnvReuSk0Hi2x6rP3Gl9fooU0zL1T7WLKR8zvLdCiI
 4Xao5Oqj
 IqR1BHSVd079evXTfZ+6Oul5jh3h35LzRSUwUvuNrqlKuzrJHokH3/GZEQSQNyBTpiHMWkDf5CVvpLhwPZ9etjbAOvmh7OwxHVw6o1q5DVxOptcTcB778/cUmD5zq0PrctnztT9b1r6JtVAbwrJx2Zq8Xu1hqF/8oQzF140utNGJSh9m0W9KPcTV6bzLBWixtLydo96nzRkHx/iEnj5TQ+y3P8t67qrk67dmwXPJAAkRp0r+EyXSSqnrxkBYjUSK7kM9qjE41UKgwTevlb94KxG9lKnyVezrVe416RTFLeEkUb4GUePWWp/KBgvQjakFiZXiCt01XDnU61w/5GnZff8ddkklx4Dt/XGJsi11OvCmywOwW7AGzOJzHbSceMv0Q8HA3QgPKP6hCyLyvO/in0clVmsXAH2JftJv5Df1cf+3O25E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

totalram_pages_inc() and totalram_pages_dec() have had no callers since
commit 7fbc5e26123e ("memblock: extract page freeing from
free_reserved_area() into a helper") and commit 287b89773d81
("powerpc/pseries/cmm: Use adjust_managed_page_count() insted of
totalram_pages_*"), respectively. Remove them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/mm.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e3736c42c4db..c105a3758915 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -57,16 +57,6 @@ static inline unsigned long totalram_pages(void)
 	return (unsigned long)atomic_long_read(&_totalram_pages);
 }
 
-static inline void totalram_pages_inc(void)
-{
-	atomic_long_inc(&_totalram_pages);
-}
-
-static inline void totalram_pages_dec(void)
-{
-	atomic_long_dec(&_totalram_pages);
-}
-
 static inline void totalram_pages_add(long count)
 {
 	atomic_long_add(count, &_totalram_pages);

-- 
2.39.5


