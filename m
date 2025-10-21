Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7876CCCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 10:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47AA08E0021; Tue, 21 Oct 2025 06:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429448E001F; Tue, 21 Oct 2025 06:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2304F8E0021; Tue, 21 Oct 2025 06:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0377F8E001F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:06:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0084140368
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:06:17 +0000 (UTC)
X-FDA: 84021691194.12.D0154BB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C9EB180006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:06:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WVxJ295x;
	spf=pass (imf06.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761041175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcIk1u1LFpf3b4C6lDAgUzkv/HVOGHxfz0isd+tTMcE=;
	b=t+lAga+4iy9HQFPGTLtxDp3EXbr6sfU1oGRtpgv4lWMaGRvQHNp7v5zsIw/SMABW58RczG
	73QbhYZP40mUnoK4FvloyIkH4DVj6Oaj6PeXfjUNuyQs8x1t5pqKt0JRTXiUcWz74hdQqG
	cjCjmAZGsod4iPa6Ij7XdCLCFkFnaQ4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WVxJ295x;
	spf=pass (imf06.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761041175; a=rsa-sha256;
	cv=none;
	b=n9PMDod8yuS65Hi6PyOdfH0cO/fGseULqufDJCt35DqyiQXaPOus03TeDw2qgWw2GEx374
	51DiWmfdtZhodx8pVN2JMe1lcAECezApSmMElrccvAY8kKRZj9qO9H9nGc+RGINvYuIalj
	om6Sy6ap+aURqUkz2HAAGbZ4WOdVwBA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761041174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AcIk1u1LFpf3b4C6lDAgUzkv/HVOGHxfz0isd+tTMcE=;
	b=WVxJ295xYzM6dDgBG/Aik9ZbDGWWhHmFe1JoZwEj+0v/A+vrrc+MPG/GuZ7aIZd7UTPGQn
	wEk2dagAtfrM+Qw7hHgQrA8P+mzWEq4XzrlM7/7OBwuHgPMK9In3zEBH1VCNytkyvXbOWl
	gGXDAjojVr0gO1kBQjz3NaF2c5PTEj0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-qmrxsGxNOLK3zlIOrVRBIw-1; Tue, 21 Oct 2025 06:06:13 -0400
X-MC-Unique: qmrxsGxNOLK3zlIOrVRBIw-1
X-Mimecast-MFC-AGG-ID: qmrxsGxNOLK3zlIOrVRBIw_1761041172
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47106720618so33782065e9.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761041172; x=1761645972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AcIk1u1LFpf3b4C6lDAgUzkv/HVOGHxfz0isd+tTMcE=;
        b=KpxIy5fx4AXOxqNHz0qpDcbKFXq9VLKyl90uoKKTXLhGdLcKnNYFmm16MYqE5/8d3Z
         WkGE5xcYOX619p7jqpAV7XtZyUYRTO1XuhgYO6+dJzdY4Lfcs2JZPORkmiQ0D4+uOer8
         X7cSAfkQLuOPHfpK2LVxFLiNJbocIqmCuwyJO/MEIRjvazmFq+Xf5qHwXgcPsjq8+ayv
         3+WpcdQOC6YUes2yihCyGJVzKxX2Z/bk+hZFNp8QVKRkc5n3ov+vHOpjA4DWVB9D3oJh
         WKXYUVns18aJ/N/LxZUIr3JLxWLK2umTCFgE6S2taGcHJaU6UHu6qykamngteVXARLH+
         DYdw==
X-Gm-Message-State: AOJu0YwGIbkNz6mQ0NPunM4BddX3jHbJjlfkF3oySfJyOUu++Wo1yvSq
	VNSMWD574OUDfpPxCU88xoL8L60nQaQpRZ6hJ1LsCyZPNXGfncohX18d1Ar68+b4QeNdyN5lI+o
	kDDAy1DpZmgaQ/28svaSbUEHFi7aM8Ybf0ppMN4oEOMI5CWsAFrX7
X-Gm-Gg: ASbGncugp7/UiYpN5g4eHZ14Io0MzjoFq5u8HjcRI3xpAH3JKDbDypQq7sbtmdwimil
	bASXQojLq6KBLeKubdKtkNulbelGbTGkKmduafR58vF6bWrsPBq16d2H2/IpWlxJEdGWO7dmnXg
	lVKnlEEyH5TjnTzm3+ASxMuLIc6rMDwaV3wSTfw0XSHfoFHns8HthJx/7icTCxN38cLLTP3mAXe
	WgRFv+0ZLhYBcSUNdvKuO7QbHGNWqqL5E/5MieG5qsdKIz0k2An5h8qMUpMVjNuA+5pYFSmJZ1n
	T1STgNGnWdLhpiqz56P5A03eQASQ5SiL32ldXVgFz7caVqOr6FnWrofZhlc2MMs+YmIFpXTghwj
	q5svztXO1FhGrrmMuRXYHTruDuf3bZB6iOZ2/1LjUs430z2/n6raWATultxex
X-Received: by 2002:a05:600c:8214:b0:46e:2d8a:d1a1 with SMTP id 5b1f17b1804b1-4711787c09fmr119127935e9.10.1761041171940;
        Tue, 21 Oct 2025 03:06:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF73SD0i6hnV9Jjn1RH+PBFk3w9kuXlrYaFhYZPnbx3J0Nn0xcYgxIdbLFvh84woZnc9xYOlQ==
X-Received: by 2002:a05:600c:8214:b0:46e:2d8a:d1a1 with SMTP id 5b1f17b1804b1-4711787c09fmr119127665e9.10.1761041171514;
        Tue, 21 Oct 2025 03:06:11 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47496c2c9dasm13567195e9.4.2025.10.21.03.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 03:06:11 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	stable@vger.kernel.org
Subject: [PATCH v1 2/2] powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages
Date: Tue, 21 Oct 2025 12:06:06 +0200
Message-ID: <20251021100606.148294-3-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021100606.148294-1-david@redhat.com>
References: <20251021100606.148294-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wcaNphu8htyNOhhAet5yQkKTr3f63wAF0B4C0uEPxfk_1761041172
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C9EB180006
X-Stat-Signature: iu9p7husugndcs5do5sdsjzhzq1tqoke
X-Rspam-User: 
X-HE-Tag: 1761041175-149121
X-HE-Meta: U2FsdGVkX19IKuOZRoZJcALyC3HrgQf8fMnnFCK0XkF5C//9ly80Vnl9G4yK4ugHMwutJSy1TDkzA7OHHZSSFHwjT+0gzF3IdT2QUGLnBNf3xd0AhHUoBB8w7FACC8HvNlUWeQatwQ/1LiJ44qndJu/0kfdGE92Ly3yxFGK6MuXnYlKPtaSKDT6RxaJeCkQHDxtaGdd2dtzPe2B9ywXIhp/ryCGqSm/H48ECYJoO0VDJjRGLpUG7H3mGdgx27g4lDG6y8aWYhrjCmmUS9JNO0cQA0pVTZjJUGanEN4cIgss4Lz0meayBUpFV+PN2CUlT23YI5uocJ+0w63TR/U1xeA7hl4981AOfCkDCf2OEa1bCkKB37qGqXX+wqNjVWwJqpoAxzHhdZnO+N36pLd1HJD5szBV4dgnvlFnh1xLwoGkyY3BEIXw42W4g2EFMg94e5ALZFwWBvthG1RU57JR/sQ0umJOv+xTcQM5dYGdjr1px99pISD3Y1Y47vLcf/dpmXm31e1TbB+JSpeS/qoV4+9RDbR4fVT0AeObi006BwZxDIrvc8CpuYQLdfj4PVcCxqaj2sVgvoqVYvkYNzolpoZi6YXHVLQ4bt71IOleA6gaZZnDKQJy/gj2DuupXujXtKFLolBuS1vowi15tEnsoyB92eyfGcQLZRYckGL7JKXMfzXdwErxFsKHIdczkLyIEXNGMOHMmKcixWvm4u8MWpyDAh1LArWyWQhcT8Am//MOyvyluK5wMtn12QUvZJs7J2lE2FyZmV+QESnuGDOupryg/ZssBxl5NrbxxYKZLpb8fgFm57JG5huoNaJeeYaq8xwqlLq1NetKPh3VriCdKKRQaNFwpLN1EWR+RKdQmH0WGCBji0iRD9aXameC4Mq59TqES5KWxv2HU/oPmUKZtZPEX6I147TvtK79irQA6XuNNSPyV9OubY0a4IvpKif1yGTkLMXck7nUlK1mfows
 J/srZ9IL
 riQwTQtw/xutG6j1AND15lh8EyVo1jUcwJFPvYc2vTHqUrniuN3rBWalQ5jhzrcjgcW9NYx2cdd3msA+Qf059BZbTp8qbCkH6uTL1XgA1hVlfO/vTtUp21GL+SEuJGzO9IivrsfuXNHV9zNViTXl8/Ij/AkWlkUZQggWgHCYi51exAPlxQ0hIUeP934rPomzea/wH49YyuuEKBlXXDzjJwXRpDcGXfwmRy9dyeGaeQxc2WGpfBSYgVy3p958Gqm8EoVhhvlAd92PSod9d3zdISzUHAfMEuAKZH5uRJtTmqT4nX4CXbbjukgDtiyYoqMRYc0vPKfiX6Hl9AzSNZdI4MymlHjKTnWCocS9WZZIHfzT65G/LuUY07acNlgyY9EhIvjF5GH9AMvH0pTvpcwpTqxaeZy+71I8cIwkjWaotoQdMY/BuFq7qgrW2E932eVlVPzzWV+Q/BopthQhDioYkhDNtCYqzNIpBuIBEObdkgDQTZ7xZAYQVnxmJGVdgSulDzoA9wD5R17tdfcWvmGzj0WG2L2ocIh//Hh3WWStIz/eftDGiNlHhAXO8xCvX+Jr8GoPMd3WADGQVevE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's properly adjust BALLOON_MIGRATE like the other drivers.

Note that the INFLATE/DEFLATE events are triggered from the core when
enqueueing/dequeueing pages.

Not completely sure whether really is stable material, but the fix is
trivial so let's just CC stable.

This was found by code inspection.

Fixes: fe030c9b85e6 ("powerpc/pseries/cmm: Implement balloon compaction")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/platforms/pseries/cmm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 688f5fa1c7245..310dab4bc8679 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -532,6 +532,7 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 	balloon_page_insert(b_dev_info, newpage);
+	__count_vm_event(BALLOON_MIGRATE);
 	b_dev_info->isolated_pages--;
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 
-- 
2.51.0


