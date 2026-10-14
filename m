Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2A4DCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39C56B0098; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12846B0099; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01A16B009D; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79D566B0098
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:08:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10C9DC06D8
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:08:33 +0000 (UTC)
X-FDA: 85321865706.07.0CBE735
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7D4D21C000F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:08:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=LsXzq1cv;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=r2Ry87v0;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvjqWmYMUiWctt9uBifSZeGbTvHPcL4+6cXa4k8By7g=;
	b=xLZCUuSkayQSDoWob6jlpMMZnuDoZEQ/NCkxYtjXqzcVOdUK9NRkDbzSS3f93fn3CFlYfF
	on7HzK2MvhjJkDQnK+c0NZpWKozLBdt09DEilwj3VyDr1JZXdWzMR1/aV5vPM9D6FuLXpI
	AcuExY0RwBZvIMmXZPdyhdNz72k24Mw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997710;
	b=HMklmmUV6tNO9EjKtK86BP7HWiUtsOAeu2gQYKZoRD2Z+mpcYH88xN4BElRbCFRpTss0mR
	F2CUKkgyuq7UDKeYExadfGhul7BlZedCjDSbzmKujczh7rvmmTh0n8i3e0Y0U0z8MPw8AL
	uMpxltOKPUI8j4OwuG5sfC0ytfHQ5QM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=LsXzq1cv;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=r2Ry87v0;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EGYLax3574567
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=wvjq
	WmYMUiWctt9uBifSZeGbTvHPcL4+6cXa4k8By7g=; b=LsXzq1cvAORo8xB3WYL/
	M79uZ9MXS+5I2WdaA6VMhwqPsLyjj/cwfATCQIqVbZoSasTKw7AdYnwUsaWdGC6A
	hcMfTZBz7X0XuOmSvcLmG5/RwI3YpcZb3cLTc8MOkhHJTwYkfz1cA/AvCX6VlAwm
	vCtoQufw9pAfJ/Q8mfiynMRT8ZtUJ2JVrtIysCWCLbQetZgDQt6yxj6vuhyq8dhs
	0tWgnJ6NU3AXFiDN6+XyZc7tSoXQWIYoVnzXn3OP8Z8WSCTxmy75aCbKuKFtYYxq
	CoJd20bZvdrFHlgCYpXG4qE8AGjMAjl2o3N2+CcPpQemJnH5mfS3PDrvueNREq5g
	fA==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h9wgedn1y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:08:29 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91b8306ba68so12673166d6.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791997709; x=1792602509; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wvjqWmYMUiWctt9uBifSZeGbTvHPcL4+6cXa4k8By7g=;
        b=r2Ry87v0MsXhM4KQJ5S7tpx5muSHG2YlS5tLetsg63OJ9P1RLSaHrjg7gNNZ4OaMNo
         D2D3JxYqKHajuFVQ3ff+BKeucYxLVSzX9HIJCidkrFmzMKCutGc294NmFzhmmgCbHTrU
         icRiEcvY9sYEs90lKMA0RaNJWEkZ1X8sQebnxr2SzVUkQbPaQMhFp2aEjETia7dXbX3U
         Rxe1Py8x85OSVsSO2csw/xpwBAcXE14mYfXrAZIl0ceBUqZsY48njfTb3yCqaXHk9Xe/
         2LXtyGwmNV8tB3roKrDBoFwHUA3Fox3VnPXXxRNdUtAW8zv/VJK91zJzUD4VC55gqHgZ
         YLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997709; x=1792602509;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wvjqWmYMUiWctt9uBifSZeGbTvHPcL4+6cXa4k8By7g=;
        b=pNi+YyJTKCd6Nyu+Il0nA02egqoiZrFHciwIJkeL8kvkSZ2TtOVWFJKGEgxrA8mXkB
         ZuNVmBWrOXnBW4qeOwAh2AtRvMf2aMAyX+Zi+XHCjGk+oms4SiiZ2ImHXeCaZohkddZX
         GK1VPW2RGpCOdP7IzhfMQTFyt/6Uy8FTEA00uyPKpduTSGReMJ2g6meDhYneZY6RRHEH
         YKYOF2SGbPrN5EIyGJJbE4Suy/PBKqC/LKO4eRx5NXGAGtkI8VKMZbTXPLalN0fhEdwM
         BH4cidUnemtQkhwcapLGt7lgjGcTuWlzI9BOGh697JglH1K9O+LiOuAe7oy0gS+Eqb+K
         So+Q==
X-Forwarded-Encrypted: i=1; AKwUvBwujoS6llq+Rwh5kZLMgCPZrJn9OUMCeH98cUGt92wiRIHeys5MBIQ198DivbJBbLZaG3f4zlxCKQ==@kvack.org
X-Gm-Message-State: AFq9FYKQ9zWbD2xm5XBf9EoN3fRHUMiVjIPlvzyW1QaVhZY5kOkJxRab
	8gIRFMzZL8FDifcwp2EcPaeL+wQMnUJOApewrIKVmoj0oeJtCZZk9xnZTYwXBQyKfyDwAUmr5T4
	rm6Ihrb1qi2BM8mI5yLmXG1N6+4qP/sPbEEGy8mb2G9FCwyLb
X-Gm-Gg: AYBFou23yf0NRxzQt1AVCyWqOWzTU4GeL1+HYYW8d0YgLrTGZEa7CGBp6g3GirSf9wU
	R4sh3576P73jjgZValUItHVYwbaP2Sy2dZKQ51CVYh+311KYH69cd8eq1+yiGl+ANzV03cyOAJ1
	lN7BAGuR8ey3cH8H5BekLT4/KiJwm321LPktc7YFjEKfucLMoy5zKmltNNKrkO7B9YGAhczl5Ij
	rbTfEsWjyRCZDpJsn7COuNWnsawSkZsgylrWnJ0O3UsAkXnBe4PjhTg4WR9YiSZX3AWE2kPa3V/
	YInQTszcQ/hyE87HUm9rybY++QVasvFPBEC2BexgQ89d+6ulEJguE+AK5j0H6ORYhXEoXEm7vHt
	zTQ6GpMeXbLZkTLdF99kipg5rq0MiPdqYoI/Pwx4sZmNuig8=
X-Received: by 2002:a05:6214:2524:b0:917:aeec:a168 with SMTP id 6a1803df08f44-91b5532c8e9mr267544096d6.2.1791997708779;
        Wed, 14 Oct 2026 10:08:28 -0700 (PDT)
X-Received: by 2002:a05:6214:2524:b0:917:aeec:a168 with SMTP id 6a1803df08f44-91b5532c8e9mr267543326d6.2.1791997708075;
        Wed, 14 Oct 2026 10:08:28 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-148.net.columbia.edu. [128.59.176.148])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b9bda8643sm49190116d6.25.2026.10.14.10.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:08:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 14 Oct 2026 13:08:21 -0400
Subject: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791997705; l=1282;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=hwfXrW/EvomtAm4NrtmoVlI/5Xl6aGcl4UefFobW4W0=;
 b=TZ1ZoYpyxWx8/N/dvvOcZk3ivGbLWSEy1vFeU3AtXGJupMue7wcYcSNO3eJG9IivQ0ZJ2RAhb
 y1B7LNZP21rDHAEmJ+aoDG9vlhr0/yR4e7puZzOKm1fw5Xpuis+XXPB
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=fcY4WEQF c=1 sm=1 tr=0 ts=6acfb70d cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=dxtdfZqDOO0kCslK4e47hQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=ji2j2xl9BP2pTznAyDMA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfX6r2o8GceQ5IK
 6mr3FHYcpDKSWUphvEbEC8R+Zr25giEDW6gsfM0NXLPSTQVDzuesazH96ouFMQPu2xO65tycv61
 g/HHdixDvlpXNGh0sp3Km/XKItqPPRcP2dQM22NZTsP7Dau563Lc
X-Proofpoint-GUID: 6oJVRBGOIEovOnWIlY7VtqNNSo0SVNN2
X-Proofpoint-ORIG-GUID: 6oJVRBGOIEovOnWIlY7VtqNNSo0SVNN2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfXx/yrxSJw+EEJ
 CzmT/BkYHvihwloNeYJ9iUjzMU3ijqflylvqQ9765AIisqvjC+AJpf8GXBkO5COeObs/aNOmUxT
 cr37nMVuFH6AlBtr3RPeZVUNgwEBEuGdVWVDpJPb6NZu7X7/LlEiLem/cZB/ivr6yQN7KGgJQBU
 peqt11tZX1uL9IiwE1T3/Kvj7GpJYJIDboeLYJWR2vT+/iMEz7lyBHQzqqJJbI01NGnGBJD7mOR
 tIXkadRUsRGXbk+SGMIfbfZPclvP7RAn/PPOIQ2sp2GmAfV9lYkxYBhwebbcH46I0W2bS9RdxMv
 fKhOr2G7phJXDBJftsw4/FL+/NqoZ+95RaA2cNAw/7tQZ0CqDfOGoheBobMecO06lhHXvdH46PV
 qjiWTyD6QZMnf7sc0CRk74DhGBkJoiaQM2UDRxF5aFV5zM2lUPytYe7DvYbrP2MOUwJ0otRhVJg
 CXiUAUZCEVEZQ5Pwy/A==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11935
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=10 impostorscore=10 lowpriorityscore=10 adultscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140068
X-Rspamd-Queue-Id: 7D4D21C000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: aqq43p3mm3nsrsq8xndr6ka6k7j5uf71
X-HE-Tag: 1791997710-654551
X-HE-Meta: U2FsdGVkX19jQecKDN8GeJpkn48ZFqC9NDIiLERw96OLy6vWiWUwUQ5rR0skRLM5We82qNGhJNU0VZ7N38MjeTYQx951ZUInAahh+xQbZQBICGNN95pH+iJM73WjM58+BUJBnu2FWmzD81kRq8Bioz6b+xbrtOB49RZpZpj6EKAnQFV4bOD5svge3rFKSnbSG9xsv/3M+7IR4IuhlbRQx1j/TkZtdjQM5P5vKFhXbXPfP47Dj+K+C9oetwUmbPCVkDjt+2k8elL3kfQBgo2XjRMqI2nc/bM0aDNexhHnRJap+WVxZCtBN6XPIBET56d0y+Na7+5dzTVn2uljO1ZNaISXwCqX5/uHBjwo0Fl5R8PmXoIxmanboQ0YNyXwWrLdT0Iy2Ty4mMuSU+TbESv8eplzQztXQzYp6nwB740iJDHF3QDaVGafNKS6R3XerSIKeJkRljHdyt1iFQ+vu/HkOjDapgBDa8PEzH58QFtSh1jQ2XHxYAsxkk6dHxEyZ7M8jsisvG0dFOyHjT8ezuLu5KDl5rpmMUXiTHWdVdPIdueTWR0nJV6x1v/Ad4h9KqS8sN7JWXvxL7cf/V1AeEpciKuThA/UD01MmhUUF5HNfOlWh+ecfkR++omdrcfMaIIsLZCqUjt7nkATYyryLxvQQ2m9asTn8nyFkss8Wp6GdXtyNsaj28eX8dImE0o/7VFl7O6TthUzqhc14thQRo7ho1WO5HsTGFakxk/kI4jHFJgz6zxusO+Rot0ZRD1GXx78Eufp3p/nNwqH+LRWdN53ZxPVlXX9jNh1wBWrD/BGB70OGq7Vc4rpgphsqO6zZt/sMvqhxMmtrQvjNvqd08zjSx4fjfAlQMTLd8W9FeJWDJFyQIuvqzUtR3eD2OKh1uaXGWuc04+sFwVrC2PbedN9ostK9wsCcKpphaiY6SiFfa3X9bY6mabcw8itGULxytVBlkmTTwhhAWdoETTWtSE
 yfBUK9Wm
 XmNSjpmKk6Zjn4Md6oASGDIj0/B1tabuUmSYqnCuwqS12w5t35F1yaom8GdOib7vGlAdUxwTvyyCYYGueHIro9u9OGsOX+YedPhz5EGds4BvK3zN/raXW4lnGUilLjbqHlmJ2hk8Kl6gWjx1laPYYnh+Us9K5E+3ylXNnyr09ioWDvIyknfmaGd/0TgugIkgrG7nT2iZE2pAccYzamydMEU6koYNh4r7/m/ISCsofswGZtsNF7W0OVzdoyL9xAgbZEjYekE2dq36yVBromokCTw7ob897sEboRjjHae8g9lyuvQv72R+pjNa7DjJ43svuQ6f9ypcxwjkXsiz4IwgerriDj/f3ytIqvOQkTOMVLydJKr6EjROB8bmKKSyBoNgwBInbXLbs1iwrW4t6XVAVqOta7Ar8Qch/eM5OEGETNbopQuc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
Remove it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b65a2d0fca3a..33439e285d94 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -499,13 +499,6 @@ static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 	return obj_cgroup_memcg(objcg);
 }
 
-static inline struct mem_cgroup *page_memcg_check(const struct page *page)
-{
-	if (PageTail(page))
-		return NULL;
-	return folio_memcg_check((const struct folio *)page);
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
@@ -1089,11 +1082,6 @@ static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_check(const struct page *page)
-{
-	return NULL;
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	return NULL;

-- 
2.39.5


