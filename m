Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328B1606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=BFw4I0pF
Received: by kanga.kvack.org (Postfix)
	id 1E4D76B05CD; Sat, 14 Nov 2026 02:10:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1478D6B05CE; Sat, 14 Nov 2026 02:10:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F028C6B05CF; Sat, 14 Nov 2026 02:10:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6D3C6B05CD
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67F58A7CF3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:47 +0000 (UTC)
X-FDA: 85432852134.12.FC81426
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id A9AD6C0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BFw4I0pF;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640245;
	b=SBx6bmLlQ8p3UyzT9HsfZ5x1ruzfkYKGUxnP/XwLVre0+I41pplgegg4FRd6toEO0SnveJ
	k5YO6DbDFN8qR9folHjpxNW3idlDdLi8RffRVt/fh7tWGT0Oo0GFqH0qe0ZQLGHQv1Wd9R
	tMHnz8GfHu3A82WeE1TpV8jBGduj1dk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BFw4I0pF;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEak+iwgBd7H+tAUDcNraVIKxkIkqE3kGPmkcYQNtnc=;
	b=dfSnXgVR0lBg8ZMrS8ruqDJgVXXrFuKdAZUMWpjClqwBr308ig7NfmolzfdZVD3pMcIwxG
	m6ayQJBpM8ZfuOUaaYaet2rfIQ26AF0IKvT/6A4xdmjRSpvmXXfHEcdsiQBmGsP6ftCAgk
	+REdR4Rxcjwc1qPcTJHvTOdew19aCCs=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91ea5600c9cso37049906d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640245; x=1795245045; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YEak+iwgBd7H+tAUDcNraVIKxkIkqE3kGPmkcYQNtnc=;
        b=BFw4I0pFWZ2Z37rxQ6/wV+yDUkSbB1CnqfEYo4+1bPW8i7fUSuUFTsT/wUC+csWe2o
         8BnDpvjEhzDsoi0kxv5Xb4AjTRfB68eFgkdAAAklYOO6xVWi56tWFthkmUxKh9V2AOg5
         rsUMHjVEJOTvqUPCCnb0ipOgKMoPj5M9UkCzW48M1cnjPbSm1Ezi4OLe0PJWUBA0yTqs
         kqKHOPPLuqA+eF7nyTJRt0J1TXZSdpS6y4hYPld4kpIA3K6IOiwGd9631Ext8HSWhkMP
         PSn8uitOup/Bp1UjSMHWKi/TKXLIRKAG9FtH3Q3+FDmiI0m0BHEesSGCs63CilP721Lu
         qO5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640245; x=1795245045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YEak+iwgBd7H+tAUDcNraVIKxkIkqE3kGPmkcYQNtnc=;
        b=E01RA4k+WQfp5PzxylFw/+ML5f8alTTbiFvkAcgQ/pssPNIIJ9mQMSh3mmn4Bx+mOj
         CeU1bxjvAkQ/I+JAl3+GOwEyMVDHlanqeQ5aqmgi+X3iyvKImH4L/yiHnonyLXRFtgjS
         4KnmKU0lZrnOcJOJGDvU++x/pd9HLoL2RkjkHbX77duX9lUTydNCOHt3aH0Xj6tlc1eH
         R+jIQ0bqObf65iZUOeIcirSS9D9Sg+c5N1q550NsU8QWeJWFtCf9B0E+OZTl4XmPltLV
         FxMntM1BvgZ0IVyDiiIngZrHKVJbvBXAxYq+Fqc0w1IoE2722VtXC5Z71CFgXyyf028w
         w5Tw==
X-Gm-Message-State: APuU4Z8Wpzrv4TBgR3+a5JHiiqOEsu/muBCx58ezaAAQt2UuGepANSfq
	YcHC+Q57NMkupC0ohyjArZ97DoSBRO1seRr63dYF9O9H07hCNLbamc0vGLmIsTkIKocadF20B7D
	zK/O2
X-Gm-Gg: AYBFou3j/RTZMl8S3ixkEEWeehg3bOCaP/pkdeFPRJqKciyaLO7w+ps38X561Pg8A8y
	Nu9GD+VQ+rA8iK35WgSrPcsmWn0V2V6Q0pG0wD3Ahl04EPjhd/sJCgJpCkxFWmUjQ04mAgDsT3G
	7ES+WATlM4HubkQ8tubV3Jqt3OjdTsogaYgslaLVo3G1XFTvzrViyXY7EVQwE8hCLFdNbalC/sy
	MxFf/k8BAs2Gl1qU3Km/4DL194y3XAKDzpaYRYms8O58lW/61O5oYj6zsltdSsdDM8y0FItynwF
	/EkRVSyttG32S2xUKyUTo3jNgM25dN5tg9syetKbcwbi913TGfBw62Z8o+fppCftPRNE+2r6NBd
	v/vhjidBiWU8C3sBmnAguGvTVlerdJcOTEBkEjIfVIiLOVGnWm3hHUoH5bUMqOnhegMceVB/zIy
	wmsCYtZNLItllQXxDu/0QdGfwrJS8uUBdyjmpdkCswvmA3m6OOOBhDQtmaHqNcohvctEMo8LOwj
	Qlc5fgT8VPRvztUe+gJAwEbb0L1mwGMsEDnfmTGjyHnN9JhqOd3gceGJMcHRn5hetbbQW5KanRJ
	y7mWNVuzcshTmfQmoH07+ofhw0sCwgx7BUk5jeDuG/KP28tIqTQSdmfSQw4JHRPCwA7zxTz9d3y
	jtJfrLK8+8AgYVMY=
X-Received: by 2002:a05:6214:2f93:b0:91e:b7fd:8ce7 with SMTP id 6a1803df08f44-91f2425d524mr70448086d6.28.1794640244861;
        Fri, 13 Nov 2026 23:10:44 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:44 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 19/22] mm/migrate: restrict move_pages() destinations to common memory
Date: Sat, 14 Nov 2026 02:09:56 -0500
Message-ID: <20261114070959.3490008-20-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rao6ene83qf33by1qqzeftf7yx8s8eua
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A9AD6C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794640245-826847
X-HE-Meta: U2FsdGVkX1/oPyLVMVFyLCVxFGeARdSGN8tjIQJlYqX5L0VNYU8Ya8DxoQ764Fsa5S4GE5V1WbJFOHwgBEh9VvH2NPxoB1F8kxU6pJk+eJToRB2cE0J2Nk3t3gRvd26WNd1pMeHRMHg1V7RjG6X6kPYBRfeBuJ5VzoL+1zVcw6630e5EQxagPDt3Ytk90zkOP+oCgW7C6acBgYm9usSiCQBmWiQU8uWCB8c0N5MP4whMPRTckoMQrSyYdHQFk/EuZ4i+u1x32PUm8/aBc14LHFiV0AR0F7+6I2Rf/iLDOMt2qtc6UZUsLLdd20VDKt0TlPt6BZBqpgIi6sZG2Ro7BoB5LJ2zh2Vn3vqldwlcmLPJ8vOP4Sd5eX/7w+LGepWECc+lYvdmyXUZrCkz+HYusPHkqhmAdD0u9ltgPtpCxNgHKhQ4LLWAnYU+OMZb7YA0U6raUuj9YLeYfVal4VqjbU0RhlT7Dxge3rDGd/sumpeLSdKaOArbljcXolBggTvo4KBFy0nApyYo+3/uwLcyBgripHbEVWab8IcFOxEVF/uqk4icnAMOYrtQAVbb16Pq7cy7F5G2WlXPA2BOdtIfJX9BDNL/g4lW/2PNYG0W3nbSaq+VRP+hUfwofLrWg7m6KpezCZy6lT8GWbR/e1YEwef1zrUtVE+5gB66RO7G01ZeHZqGLaWpBYS8Y94g1tEWgp7niFW78qiSTlaZCGlINpoEm9dusXJpyV3Kgziu5afDxmAKRj9F6K7i4qEcehb6+bJbrNUTz1GMSCED2qqk0gD6wL6Ge5xUSxGspW2fatP7vSOyFO53jxLFSms28/hMc+IaXaSZ5iEYTkN50+PUJEbSWqcAydtN6CYOuUQvcXDjWizcvnWlPVLCIoCCJpGIxIFTH/jvfSqptD/gmsTIxTf8QZPIvaWRL1+SpLL1CaboOGv+mS0YH0Dhbdq6rhPw9CKb5VJ/kAfLYIacXhl
 6NP2AFNY
 gsTfr2TdoZEV7pKvACsFfbAy20R9rC/Xmy2hopmIkieP+YgDPmqaSzGoYxq5diDsbYaDRAEny9Vlk7mx9CLzWAtjqYjwB1t1UdHw5RQKRIuBQWTdPBT19pjhTjsMWkK475Cp9Jx0wXT3ad8gsciB3LDVsAIZ3GftI0WC+/D8K0soDIC8l3YwjlNHhhbpIoJExxfyVhbTAipCpG+8e/qtURMwV+9FkgeIljnL2JHE2ctg5MaU2TLH36bMBlmvIdYWFpjO7A9xhyzFB+q40bJfu515qZWLqslt0O3KDdJwqwm/2fswbuIHbSr8gOr4QDdJG+r+9cWKj/2n58NZ4yNZesnJaSd//xtW16dPWwuO+LCzNKBwPyrE8NJVLk/t9QDFiaGbTtS5Pj7ZZLYeLEaSneF8WAqn/LLgARf5UFe3ZiPMlLAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_pages(2) places user memory on a node the caller picks. As with
memory policies, the destination should be general purpose memory.

Reject a destination outside N_MEMORY_COMMON with -ENODEV, exactly
the same as a node without memory is rejected today.

All memory is common at this point, so behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 28a8d7734735b..fed910c9ba9ee 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2400,7 +2400,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 		err = -ENODEV;
 		if (node < 0 || node >= MAX_NUMNODES)
 			goto out_flush;
-		if (!node_state(node, N_MEMORY))
+		if (!node_state(node, N_MEMORY_COMMON))
 			goto out_flush;
 
 		err = -EACCES;
-- 
2.53.1-Meta


