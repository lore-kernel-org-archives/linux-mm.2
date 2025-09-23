Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99804CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 09:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE758E0017; Tue, 23 Sep 2025 05:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E078E0001; Tue, 23 Sep 2025 05:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D218E0017; Tue, 23 Sep 2025 05:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B1B938E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:16:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3527E140425
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:16:59 +0000 (UTC)
X-FDA: 83919960558.19.36ACCCD
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9F7FF4000A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:16:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aEr8z3MQ;
	spf=pass (imf17.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758619016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vRIzRAWis1O+Krw5uc9gzQHxpU0thSXw3zEc2VjfIw=;
	b=ebT1ZCHmwLSzXh8rnEjTFaUxb9QugtTUag03euohvUSQT8Bb7U11nedRxa84mrkzkacPqj
	pltKKuBVzY0c/x1PV/6g4qklRzckAuNV4K5KdkoYSACLJoym/g+MP/RiYLw7f60riCKr4H
	XFIh57/2tzhMqrPZFxAqdF8vxUFQDiY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aEr8z3MQ;
	spf=pass (imf17.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758619016; a=rsa-sha256;
	cv=none;
	b=pS39wLV8aJk0E9XMlj/HcwskVlTW5xlcOouJN2B4FdYpYW8Ky0DmSgts+OlFWz4WJjj63I
	NC3mrDSIYiqFE7fRUOxpwIn5cfO1fF8SiQX9woOHERW++JY0VHnXw9yj0ExpE0Ub5sAcZd
	Fiam52N4+zx6NcJ1/TU0Tn6DRZ4vFvk=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b4f9d61e7deso3613173a12.2
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758619015; x=1759223815; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1vRIzRAWis1O+Krw5uc9gzQHxpU0thSXw3zEc2VjfIw=;
        b=aEr8z3MQtSlIToegCREqSNBFltPG4imdjYJhYXiorLvJEPIdDdcg0GWRDnI3sWfJYH
         OoJSgbYXBVDeXPQBztYC0sLzw+o7SfdxhnfRYJ2pmFtUnck34JaC02njHsCeO4Cps/lV
         uXP52q3PUH0cc3U5k9QS2KaNJTFLeGTYJmTN1IjMh/2lbe/+YdGAkRY1cAVtVMUgfSL/
         +rCHMX06n9vJCrQTXjwsNZeH0fx2AQ13joOFE6Fj3nUezLddIGl14Ds9TW3vd/4oVrCz
         eVNPhP5e4XQ8lz7D5n0hq13ZpEC39twsSVzaePtJ356XH44HLwBRxFwWLZdhddZag1Y9
         JksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758619015; x=1759223815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1vRIzRAWis1O+Krw5uc9gzQHxpU0thSXw3zEc2VjfIw=;
        b=bhSK+Y/Wg9oBqst3IT2dr8+nltA5C6kpD/WtUqQULMNGEpzwQnwId6CMUKa61fuxHY
         +EbehTZrUpfmq510h41rwlReJMCJ6r1cBff1Kcpwb3Q7yskKwHl+YMetkLgGXqCoo/hg
         mwmnwDWaZa2UjVG5M7e+dUBNzmCMaawR2/ASl4rsFeD2o3AlEjWQM2dkF8E1YrIWmXJq
         ztJGsjEK1kxHfv/nivqw9EJMIHsre9GW/3e5gBRjbxH+hv2wXs8B6EaXfQMpH4E1nBUf
         tQPpUyLh73OHzZ05aJYGk8UjGZ90z8zDQNi1FC+40iAHpBSmqoRlhUWRmPF5zhY2ENSd
         5cdg==
X-Gm-Message-State: AOJu0YwFFAMG2LbwTmcGfvhsMhf/rUEhjpPEq5n2gl4IbSoCIV6wkqap
	oVCo/HBAovS1HkqtPE7jR9tMv24wW9GVi0zXm4cEaT1DvPP2Jozwuti0FW2oB6HhHks=
X-Gm-Gg: ASbGncvpfLzFBTKhELHecVZHMOeuoTiTae2lVwzr2MXZtpNowR6fSVLlvsz+Nv159rM
	12/TMvlS0KcLUeBX2n7MvXgPfBvyzWSkejDp5Bqy02UAJ9wiMDQbNnmgs3wnd/cjweNvfNKsZl4
	Sp8eWHRcyxZy2vyhn3ckNeIfOOOwzg1V3iPNQ9ci5/nQEh4bJQLCwSL99Alyvf4+kEqoJqTW683
	ACuFmLUvKlLS/U6KYPv0W7wobcBE2r2BZ/qtZeGKBJqjgjmqgjsw9FsDYMxRyWk0kMm5vV0mp3W
	U+g6iZNJyz/5/Di2qVMRl3QVhv9ioioBUWYrTA0ND5fDrBj8sz/wYRaM/syb7V8QS9/E1Cqril5
	8FrwGS2Z1QKTs7vlG5Kk+2dSM3UupYp6Qf7z8MSDg9uC/MExy9h/JJ0O6uonhl5P2/UMB7G4=
X-Google-Smtp-Source: AGHT+IHwALepKfuy3l2UtqVt0g85ATZ63XzujHyf6JpHaHemjaQ8df2V5+fXQ28C3kJ2VnPBxstLCQ==
X-Received: by 2002:a17:90b:1b4b:b0:330:4a1d:223c with SMTP id 98e67ed59e1d1-332a9515d33mr2709085a91.15.1758619015333;
        Tue, 23 Sep 2025 02:16:55 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed26a9993sm18724713a91.11.2025.09.23.02.16.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 23 Sep 2025 02:16:54 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 1/4] mm: thp: replace folio_memcg() with folio_memcg_charged()
Date: Tue, 23 Sep 2025 17:16:22 +0800
Message-ID: <0ac716fb7fea89ada92ad544f88ca546e43d1f29.1758618527.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1758618527.git.zhengqi.arch@bytedance.com>
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F7FF4000A
X-Stat-Signature: kzkcx65xwsq7ijbgxcwp78j66uoono8i
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758619016-654726
X-HE-Meta: U2FsdGVkX18AbQh7Psbo8R3+oVPKLtdXr9qW2feV3GxXu2DJ5gB69YdOPMacNf8dGlI51joLTcEC0Aac9iVjp3aL6IuGei1BX9t5cOV2TddGgmo4q+eQLCiILgL69dUwI8w3KLRH+gO1f2WIJqUqNg9yyaap9kONikvcKskb9skg5SmU/BpNa2G0ZdGdZ9z/3Xj1BswvUM4ofGzaqb2jMpDLsa7qyhswhy8QW6VXpnDjSxGx/o3tgIKtvRBAID/a1/Hz3fYbtnUBmLkVgkFFdMNbFeXLvoVjd+zX9iRwaRQgJIA1K6n/MhfUU9NFPOFrITFFTo1O8d9P3Y4U09KQ862d2mWiG41MWX8rwIuWZX1AtgnXUKXzMhGucknsfmszdd1vsfgayIzsvZYO4peEZa53xE76l8u+JJzqEApoFgg4koq7r95EY6i3ifO7RHd1dtpWt1/jIiieQXU0plOj9fJysVJWihbmQ64jZV/mbdttz6l310Mms6oNV/fQ6XW9HqJsLnIHlFpL4fIh1dTxBycB0mtr6xTOQzWmEyQuMBT/fEcErIMai3Jlziy8X2LeKeQtNsvG4/1U4agqcvfc6fSeR7Mue5ET4p6kklmX/lLqUemK7dFt2+lHnbbEUdEPExLt6N+1cTbQ2Ob1VZpnaKeHzfHFWWecNWjrLPOVZp3CfuSz8VNBGQlUa3SbevMugFPuVJsIEvBvuU90HenyNZt1Sb+GuAt6//3Sdk8bzm5xAxGj7sbawjnzl+ysSs2lsCypbJjgHtLNH3G0kRQ/BCQYvph/mmQOGGYG8YjmNyCIhPjKfVkeOnMO5M994PHHGXC//8cBVlS4UfKwm5y/m2a4irN4b/xJNNZLOzft3HHZf+meVEpdYIbEF9XNXqHQWP8yLaHjTVq7J+e5yUEFHPqsWvWBbSRnKFpXEA6gsn5wVsajdsJW8QVtH1IlOPs8jOGvV8jbT3RVxhQVfhh
 8ovX7wb8
 PbDjzYHMVga377JiUhwGCaohHgYlbNMCwrfqiYGHCtSNJQrOAQBNIYFpgM3v8M+Xa1y5gGdgwRDyzrBIjjLXDvH6qtISXHShNZDlizghfTT9u69+zl4D5Ge2ExXRX/eZerJoiq9K9cxUpFSGHsYo7IzjmWvnNrNRJ7pGQ64dPcnAkmjPlu0azcDXqhCI19fD8EQli9zHqkAv3zdQcX4wdmtpMdb8gqiGGYNyI+ytlGbNY0CyyiYrl2neooViM+cOYWcq2yIdkzL5ibgwTDvtLDJhroG50Na5i6xFMHMrzizKQLC7bxPw/f9kK+rqDHqiJWUHL0YH8XHR52/4RmbzOKFEljhjyyg9xhQdCpKp043gWzHmE9i2otCvBUBKN5TAvAXWtFx5NquFOeugb3bkfyWxSaVhVpvcK/dy86rSfJiiFr1rPTEOHq8hTH8g+8F4HnMqpCdEaikGsa0MubLV64FcsMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

folio_memcg_charged() is intended for use when the user is unconcerned
about the returned memcg pointer. It is more efficient than folio_memcg().
Therefore, replace folio_memcg() with folio_memcg_charged().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5acca24bbabbe..582628ddf3f33 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4014,7 +4014,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	bool unqueued = false;
 
 	WARN_ON_ONCE(folio_ref_count(folio));
-	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg(folio));
+	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
 	ds_queue = get_deferred_split_queue(folio);
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-- 
2.20.1


