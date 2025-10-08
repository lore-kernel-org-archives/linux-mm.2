Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F0ABCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 21:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208808E0054; Wed,  8 Oct 2025 17:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA1D8E0002; Wed,  8 Oct 2025 17:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9CE8E0054; Wed,  8 Oct 2025 17:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4F278E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:26:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C5EA462A8
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:26:29 +0000 (UTC)
X-FDA: 83976230898.24.166BEFB
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id B0DDE1C0009
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:26:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=twLaDapX;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759958787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KS5HhFl7ylMIsKJS2hlhpESnHdT7YO5JDgRsm4JXdvs=;
	b=FaPj5IEVFd1DTbpJiA7VUF8eNZF7jUmfuMa8hVvrqOao0tpYrZ1QD0MP5pQEDy7srirh5n
	fgX4iPMpx8ugbCRgkXcQ5lPMH1EVwKGX70iru22t2SzdpKWsNJT3JfKyaSFb3RNmM5k7MU
	j9T0SptSEPYHOm5aU8R7WjYKyAQX6vA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759958787; a=rsa-sha256;
	cv=none;
	b=nl89u4rXotyCBmQYRpWFqTz8foYFdLQbSh+zmFUbNhjLxHsDwpKeD52adM7H+N/sarp8Ox
	pjq5IyaH9P2N6t/V7R2gbsV8zSiQrH23j/bwCzUqxqKEbyWCi1BBclzinZFdTS0GwHVlNZ
	90gEZcYuK018z00CZmPv1YkRMV3uUi4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=twLaDapX;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4df60ea79d1so2145551cf.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 14:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759958786; x=1760563586; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KS5HhFl7ylMIsKJS2hlhpESnHdT7YO5JDgRsm4JXdvs=;
        b=twLaDapXUm0O0hsyExR4NpqyfPdTn/FMlIauIynBIkHICeAF43dsMn7QARR0mTikRe
         uS6b9BS3aBaOmS0eip3CTE/NRA1eycsgEJeJItKJzURrAJAaUNfDTgH+WCMxWAEXPRlc
         9pPqiG+Bm+n30/Sddo5ZUONWsWsBDmyows6G8iSdBlAiIYLygX97EcQ1UY81sqhwZ0sr
         NPEHYSEMJTfyghjsZ8GrBcrTeh9E3UzddQFDQ3Ff/1nv17kUnlMlg/tylysla3gn8iEO
         aYiTU3Jc29x1IvnoSXw+ArBCqLgRsH0NF43HaHmVM1f9cJa51Dkob8cfA80hcpgzWvJg
         o1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759958786; x=1760563586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KS5HhFl7ylMIsKJS2hlhpESnHdT7YO5JDgRsm4JXdvs=;
        b=pJWIrHGsoLXBTQz6tLrmQmPBVTrcQF3JRMvsyMI4dAKRGb/R0nU1p1jfe7LJnmsiFv
         7IYvI5MK0dCnmIsvs/9sfxWtW9c98Aw4I7gSv2d6/wVf7FyNiREzwsnirdSSZa79lSDT
         etVs9RkB8yWzo6Qz4d1WfypL1Rqqd+Ua9pzmpokPAoORqc9Qw7dTGrKbhIZDQjOo6cpu
         KX3DErK+TdlgYK/3wa5hDG18bK7ctcl5rAaLgHz/Wz1rkLf5+mSP+dBiwrAnis2sStnI
         jid6cCrRbUOgDCjSxPPitx/M9j+e4adaFUSBJnN5tejyUjeO1ie3ZTFBQQEiMasnbIbM
         zHhQ==
X-Gm-Message-State: AOJu0YzkRkYBOt3+6yn2gyUH5bXlu1mrQSdS8h9DFPv5v47TUAiSMQas
	yhN/sneYlwjoOOuk6pMTJ3ObG3YxidP/VGDgw/pAA0K1gPxYZ7rTOT9dQHBkYwuiyjH8yzpKWuW
	KcbZ1
X-Gm-Gg: ASbGncuRmVrHxdxuu+XqVBpuDbSKxbjCAjxZwANd1yEF5C5pxIbQ4YlhhMhfuYzmQ/M
	+YCWrJom/Ch4bkj+e2x3cc/M/FRrm1cIp4aOKbVdDfgyYh02uEod6KCAq+EV/N3npp7fGWPlPH5
	4rIognhhzPJswQdPr7gRCYJJoT8Ap+GF90uNvxOlD3xPh6WRU81b760HidXLyfZ5CyRDWH6RK48
	DoTtQhGF4VFBr5NUIjnGHHZ2/gqfEWG2dhYWMNYY7yneqf1JrHaJAPmVfdFnn/rK/rDczLXrQTF
	aBNF8VljfM1CCydF1bRQ12sXGSIctm70vsAnHqo9SySqyr2zJkXZQgz1C9N6Kz9W/NGOk7kYG5B
	tyWZTjv24KKNK6T4dRWjGbAcqzjUTOLzk05BFYB27/7Vf7XZAHHOlzrkB//VQNSH8jXe0E9VDPG
	Ew1+VFuzqA4Cbs9VZ+IvW9Wi1q/QtiGcp5ItodPcP2Th16nQ==
X-Google-Smtp-Source: AGHT+IEv5J/8gxaNlPdAvSepjkXlsfuNzq/QXluXLDpnkk35yrK777gVOAb0vMYXxebIUGxPVCbFUQ==
X-Received: by 2002:ad4:5f45:0:b0:82d:f77f:28c3 with SMTP id 6a1803df08f44-87b21092a00mr77097716d6.30.1759958786556;
        Wed, 08 Oct 2025 14:26:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878b5dcaef2sm174415006d6.0.2025.10.08.14.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 14:26:26 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hugetlb: add __read_mostly to sysctl_hugetlb_shm_group
Date: Wed,  8 Oct 2025 17:26:14 -0400
Message-ID: <20251008212614.86495-2-gourry@gourry.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008212614.86495-1-gourry@gourry.net>
References: <20251008212614.86495-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: a6f3ffky8b6s7furyfr5mtupyo33kicy
X-Rspam-User: 
X-Rspamd-Queue-Id: B0DDE1C0009
X-HE-Tag: 1759958787-361716
X-HE-Meta: U2FsdGVkX1+HXqSlp/AwVnca96z4t+aIcvlLoQuR+UYst33XCC6ktuI4uh30qtWWgpDu0zB4/P0s3OOwz/zYbKzj0I3AgZFAGU7fEWcT+XidHXUKXgwSNiqPz5FHzCXgnPXSvrKICuNre4qePb3OG9oYNdEY+8XlOTOhq+rgiXmPAsbxKFzYtsib8OwLrVyDXNY7XZRz97vuoXfEuJ+sNYrfHVhipZVHqwwZ6nhDYyT4GDZuEmq6IbJ7LnTvCJJL+qJMdpWYz0cyw+yCZ7b9EB6Hj352mL6y3XKSJOVY1FX2A3rawy6ruyF6SWK76nAkgojUSgrPy7zU2kxjqfxPdW2JMTn1f9HkEiR1AXYihkKTt81zGOHbE+Vc1bzesxFyRtWq3KMrz9e/ZY4Sd4vpF84Xyxl3WHgMiwyPJ5vuwc++Fvze7Q7uri60mIq+4u1lRZ9dzEuBl6Eh37Shzxx3kkJzr3F9QhNc5ygnAVNOkwSYIhaoe760kCzPh92bOsqoZxbRkxQoMp5jMt92PSGRQ9yout0zmxc8sUxWnR4JpM3SoopTrz33UoaMkC0PqUN5vpdxuRwB0QMJbVwgJuYFlchb7XBCPEAAW1yidrPVmRMzg0hlhvYYLXlG5IOM4ZP9aALuPBzIllQsGx+bVqIFWUXYTFMr+nSQHmBlJ72feR3I7fFvHJDIiT0QbeH2IHwv6ANY5gM7FZt9LfsA2va787W4/fmjND2+65BbAd4lYeSCTHJZ2OUcoG83FQw/wYM1DCJLx88M91bvEpjheATL8ptdRjY6vMpMZyyjxLllmGr6CLBXlkwUI9wP7mE/569g9PjHv/rLlfGVVOGbo/1H3jZ50vdepcB3YtZ0Yd28aLZJwuEAPdeuHkoLiqVTGklRvz/oX6/fUAwhsyta/d1AYrvkI+XBQsi2CLBB2DoQJtHUJbOT9f0QFW7rAZW8cA2Va/Vtcdd7HrA3iR6ZWbl
 GoY7y/DB
 pUJ5PremzoGsgdYPZzh7gq1EVsLcb7gKlGdO7VB8+uPHnmptusdQoywxg66//b/+1ss+rTHgEXtIQhZWwaSYhD5svJeBY7G3oQ6AQ75wz+R7EVzdnvV76CU75bMlJhn6PfMfmOt8GyM/CdnfynaPyJz0mA1HSfldwD5/vn6K3xBC6QsZ6C2MYRhwt/48AX0xxShRgIXmJioor4xr2m3XQOY1R9YrPBKfI8CCGrgdrrWxAn5Mt+iu4lk6okLmOAcSCgpyUHTGj5IY8O16tOxKcY6WyGGuxTNGywkVBU7GZ1MCBiaQoJH4cFbaws4CPfry9j199MiN3RO7KCoiyJiwGf2uXuiQ2fmC1kfYwt+ghyt3u0iMWcvKp2/dkrQnRbgQX0Rt/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysctl bits are mostly-read values.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/hugetlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index b030850975ef..7ea667d4ad5e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -172,7 +172,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
 
 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
-extern int sysctl_hugetlb_shm_group;
+extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_bootmem_alloc(void);
-- 
2.51.0


