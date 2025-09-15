Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E5BCAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88E948E0008; Mon, 15 Sep 2025 16:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8671C8E0001; Mon, 15 Sep 2025 16:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72DA98E0008; Mon, 15 Sep 2025 16:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 618438E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:09:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A6D21601EA
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:09:27 +0000 (UTC)
X-FDA: 83892574374.22.76A81FD
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4A16B180007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:09:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m5mKfXNw;
	spf=pass (imf06.hostedemail.com: domain of 3dHLIaAYKCMc574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3dHLIaAYKCMc574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757966965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ibj1DZeI6DujSHcNfRa4mHa6id37sgMiM15loCqZ4m8=;
	b=LfM03cQZvVk5eQYMpK7ueknULwArMp37xrmUqcqA8F+oVMeQRuidm72ayWum72JuWoaIht
	7oJxlazxNUxY8WJCPECZcpBgLqFCpzrx0gtYTkKGDiEg6HKFoQ1DaL4QbmwbR4RQFiQUvJ
	kRUa0Rwj7uUyJzW0oF28+pN2mjuwAl4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m5mKfXNw;
	spf=pass (imf06.hostedemail.com: domain of 3dHLIaAYKCMc574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3dHLIaAYKCMc574r0ot11tyr.p1zyv07A-zzx8npx.14t@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757966965; a=rsa-sha256;
	cv=none;
	b=fuxFhxEsqjXXLhPHOfFeeVS0fgih6VvsvEPHAE04GgRfr11N3vvRxzokZKl39Jwi+JWH7L
	20tlyve0vApIn0TLDrg0rzc75XdvsUDusUUMsO7tmac5vWwEXcPm8NcqfDQr3rzphq1ZTr
	eBJmfb8j1n2HxiRXnxFHOldmWOj3x3E=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32e120e0e48so2287858a91.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757966964; x=1758571764; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ibj1DZeI6DujSHcNfRa4mHa6id37sgMiM15loCqZ4m8=;
        b=m5mKfXNw+Nd58FtAAv9aCKcUDxEQjENvZUz/DL3kW5lsxhscwsJVe5PqtkwzTxEqQi
         +PW42AtTSCXKezKEQwHAYlqoc92vaRu2IqGl3M85CNSBRwIWrkR8XyfYQ5vl2B21elQk
         T5mZByLRTvqA9oirwi4D9PhV7RbD/foYd6GGULFJZM6B0x6Z2MPYAR2SpuMnt0nZ33ae
         L7p4tfSc1GkZu71R8sTCkeHVVoDPEgrjaC2sdND8MFSYmtrlW7F4kZmpvBe5nc3jxYqs
         UVSDXb3/JsTetQLeFKVKsF49Ywrei0XF1++p3GHvzEKov+NmkuvnyFhZdL+ajN+ufsS3
         f4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757966964; x=1758571764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ibj1DZeI6DujSHcNfRa4mHa6id37sgMiM15loCqZ4m8=;
        b=QlU7Mez7mcK030q2yvznV8q2QJWViC9JUpTOhJlQZNvJ8yYagkrt/vBWy6c6+dMyfl
         ADbRE5it2o0oHZARvpMa33IjYY45D+brRX92G1ZnYxtLSfhdIqAupAmaXsJ9yjfndVsU
         n2Fu971b3g3ZqPTqP7NZdeLQYyLDEFpFZwveSXyYsxzqeoTzsVMUfRpwVFvRgv4bc9Al
         i96Dpulc6lc19LTbQymYS8BbBq9rOSBT8HeaY2F0C28rW23BO7kCAFehUT8PhRf/Fybd
         h2uAvhgHkBjmGu5kF4KTqzO657SmO0nUwXoA9e+OHDDBYEHHKO7ABzvybpLI6uulW0Yh
         yXCA==
X-Forwarded-Encrypted: i=1; AJvYcCU46OBPWn/X6MHmb7RhQwHxXUvOU93PY3Cprc5gJKHiDaORmnf+NAQ0rUSl05eiQ/wQtpQWGSJbVQ==@kvack.org
X-Gm-Message-State: AOJu0YycgCKR5cuvPYPOCOl1osJZVgp5iX8ZnYs0Ztj/uSETrSLVHX6H
	fEdFKx1lhyUQGz1Y9UuYusi70O6YkteM2k0lpvhmUj18DmzYYvx10ioMBY4oFjD7ZZOg4A2nhXu
	Q+Ibh0w==
X-Google-Smtp-Source: AGHT+IE9+G8Ng/84dVBNdtIEgBnECFOfJf1D0wcN0DZsNSGryUzvVxVuPH4z3IvZrC3hI4ZRRiLJKETXuFA=
X-Received: from pjhu61.prod.google.com ([2002:a17:90a:51c3:b0:32e:18f2:7a47])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5786:b0:329:e2b1:def3
 with SMTP id 98e67ed59e1d1-32de4ec338bmr15775459a91.10.1757966964082; Mon, 15
 Sep 2025 13:09:24 -0700 (PDT)
Date: Mon, 15 Sep 2025 13:09:17 -0700
In-Reply-To: <20250915200918.3855580-1-surenb@google.com>
Mime-Version: 1.0
References: <20250915200918.3855580-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915200918.3855580-2-surenb@google.com>
Subject: [PATCH 1/2] slab: prevent warnings when slab obj_exts vector
 allocation fails
From: Suren Baghdasaryan <surenb@google.com>
To: vbabka@suse.cz
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, harry.yoo@oracle.com, shakeel.butt@linux.dev, 
	alexei.starovoitov@gmail.com, usamaarif642@gmail.com, 00107082@163.com, 
	souravpanda@google.com, kent.overstreet@linux.dev, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A16B180007
X-Stat-Signature: ppmj38uw7mwaoht6dgfwcnswghqsqpit
X-HE-Tag: 1757966965-986589
X-HE-Meta: U2FsdGVkX193dTscmm9PFZ+WJPe5Jo8flipjPgV+hDnf1jJ9rmVxwgxG+RuP0NLyErdD8m2YuwTEG5uj9YXwYvq4izrm4zx+kKnRFIgq76yg7A8WWSUwvA4tjoG2zUK6x8c8yCJxv7p8f3KwiHETH7kKls+86vCJZs8S8v5RgYaEhrIAzFDREByQn1bNoMzopHz0t1j6cfSK+OeKtUT01GLj30QXiEPUCRLWgqt25CxLaVAN89gc1i4MIe8SaqpFS1vf9C5m9eVlBu8vVdow5/8NZ3afI35PJnooYyqjrB1j+PWPaljGdXObO19wqu9uWhfBHmLensFIvHUgBEEXGXfJNZ3cYYa7z84UPiwiJmP0Eu2EGhi49Xw784ynlHWb8e2nGbLEjUWY/N0zwRo1tu6WwtqLGqm6OyM3nSxWVH6DN2VWFjbm/azCagvLx4MiIojwNVbUiVA1d5w+HBfxPFRL+idMRbaY/aWRos2h8uaAEgo0FQBQJZei4kjZtpbKptOVksNhGJf62c7VmOXiltEA/ctS3zviGEvM6RIxSj4tx3wSO4C2SsDZ6P2BYyg3KQvH95jiJh1qWvuwhSJRX70a6KIXwoCYfOFnMck2yUzDcbsUI3T99ycLQV9Mvo8Wt7igTSvZPKsKwktdbvnYQUdc70wk4637+kpbtGwSbMNEiMBN9I+L/ltHxEIBF4ZJOQhx6lM4NWdEab2bItw67ItWtYMxsVhzQt6azddO04stCZTanwSJQoc0hkm8rlDYR3q2bGuCu/Ss6msgU1r7wQ21UDuz1QscpNtbOtixGAUAXGLV54Qa5TEeNjZzZt+930d4v/v0u7EBoehwouUeCLQwkeRIkedyo5UYD/1wu/QRj5SJmE/9xXG6iv+ArrutQ4/8AQv6Fee0nMvqIC/KVx5it+6s+E0M8nso2uYa2A86oQosNwOgwEW11wVjb0oHFXCH2t588fsMZSgehmP
 o3DTgsaD
 +11lDRDtIyUUxlbeMJZ2VggLb1GeCKbtZqNhNAYsBk0qpUxzNZ73ugOLF8JJDK+jekVxu7Gc9OuBkNnQ6qZ7kMspZnNHM8O1V1Ch7Zbd13wkI6mCHngP7kJXa2dTdAVA7JwY9w1R7MT99xprDGOMD91qT7I7PFWX1X5BDf/lT2FhG5nDTdcbeeWKTAVyFg8xU79dIS1/rXFOqudAcrFDPM0L+Fy01hNGnobPZkH5fDb+p4//HXQEMXW0QzMyZ33d9WzOnS5ITUPUm2SLRQG6FR0k8qd1eumwi46BowhO15cHBplfXSvgvdPV0UkwT7rBcdJXZg5BemrP760AVmYbYhyqZf++FAub3Epuz+i3syiK1YSp8+0swUTj+o8dRKqnjKVYxJq1QwA/iBNm2+zY4oiY0V//eZxnjiB3WdkPzfJVzF0d1O8hSlwASvFXTw6n3PIWYozxVp4qCsi/0i/dqCc5fAHicZPX7X5XWrd91kNq40/TvJaiUaJzOw/W5Q8nbADFF2LgGpT+P0wH12g08X739oSQn6clFuj94zSVuKm+b08FOkg+rmsdwpkd+Oe9VezltUQaYd+uATlMLbNp9uVXaoYPWHs1KAVMdMt7cLXZHQe97SzQJLtjK+Wm0Sdexi6HN1Djfh72S3WrjZR+9HJGHd3QhCuCvdSUcLWYIqiCPiACIG9HkRXZJDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When object extension vector allocation fails, we set slab->obj_exts to
OBJEXTS_ALLOC_FAIL to indicate the failure. Later, once the vector is
successfully allocated, we will use this flag to mark codetag references
stored in that vector as empty to avoid codetag warnings.

slab_obj_exts() used to retrieve the slab->obj_exts vector pointer checks
slab->obj_exts for being either NULL or a pointer with MEMCG_DATA_OBJEXTS
bit set. However it does not handle the case when slab->obj_exts equals
OBJEXTS_ALLOC_FAIL. Add the missing condition to avoid extra warning.

Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
Reported-by: Shakeel Butt <shakeel.butt@linux.dev>
Closes: https://lore.kernel.org/all/jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org # v6.10+
---
 mm/slab.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index c41a512dd07c..b930193fd94e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -526,8 +526,12 @@ static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
 	unsigned long obj_exts = READ_ONCE(slab->obj_exts);
 
 #ifdef CONFIG_MEMCG
-	VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS),
-							slab_page(slab));
+	/*
+	 * obj_exts should be either NULL, a valid pointer with
+	 * MEMCG_DATA_OBJEXTS bit set or be equal to OBJEXTS_ALLOC_FAIL.
+	 */
+	VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS) &&
+		       obj_exts != OBJEXTS_ALLOC_FAIL, slab_page(slab));
 	VM_BUG_ON_PAGE(obj_exts & MEMCG_DATA_KMEM, slab_page(slab));
 #endif
 	return (struct slabobj_ext *)(obj_exts & ~OBJEXTS_FLAGS_MASK);
-- 
2.51.0.384.g4c02a37b29-goog


