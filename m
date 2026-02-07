Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42BAFEE6B76
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A548E6B0098; Sat,  7 Feb 2026 03:16:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D41F6B0099; Sat,  7 Feb 2026 03:16:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2A76B009F; Sat,  7 Feb 2026 03:16:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8008F6B0098
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:16:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34A2116040B
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:16:40 +0000 (UTC)
X-FDA: 84416954160.03.4204F7C
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 58BD4160007
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:16:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eG84yY7z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770452198; a=rsa-sha256;
	cv=none;
	b=JOny66eS7ZBSNWAmy7aDpfluF12K8/oAOITG6TkoWyz3sGiVtbjdP60HPVbIf81iuwurOW
	ZUKhBG07emvuH7ttfR6LbpYk16xB5AoIWk7c5lN1aBIuo0VPpr+EpLiEduYS6e2/fmiiQ9
	c6eGgFW5UJMv9LJ+up+UbLrjHm75/Kw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eG84yY7z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770452198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfAfOKttZZZtCqQp8K1Dj0tvri2/xt7pdNxOOLU+9Pg=;
	b=vceVyU3HhrCcGqjvg26Lg+gAgrOLY+p9I2pGA4uXVqf4jSBMoLP5tCO70haLDCrmWyV3kR
	ZGZPkSHGh8kdIJrv66LhOORn/s4AbP+7RoegsjdQI3TOe11nzUQslbJd9cJQVqUHRhiFFw
	0E9nSeuR7ZX5bo4d0nJVP+Ppxr3mS5k=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so1175836a12.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770452197; x=1771056997; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vfAfOKttZZZtCqQp8K1Dj0tvri2/xt7pdNxOOLU+9Pg=;
        b=eG84yY7zX6Lh8UrH7RSJi/gK93iIDIfKzIEr4gGVLP7TYljrJNvxD1dGZx9FF+bVYI
         nt/02lHD07vs6AqEjivMbuIcqOPapH0vdDGRQa6IGiGDur3ZeY/B6ngWpXAV1aEnHT+E
         y9+pF+isBXsQbLJhFbxdXLwmAJJHYZ3GXCYTkdEibm6ZJ7UjTRL8JC9ze8jIoUqwMhpg
         E7RHhC1uv1aPDYgaEn3rJMtK6ME+y77nV44k7rXUBQ13n4IXMoV3G0/m46rfk+yq9crP
         h76UfRe4CAWEmhy35/vhAJ3EH6/Yauk9TnYZxkVKQ4lOL9j2i3SgEPgBOHVTVLimAIxM
         WIog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770452197; x=1771056997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vfAfOKttZZZtCqQp8K1Dj0tvri2/xt7pdNxOOLU+9Pg=;
        b=UpzffkN2ViajNvZZh2LgNU39gaFBLEFpKZMOhwy9gkXzC8OABa6EX/FDCXvxd2MbAI
         oWtgK18xr5OxxCEZ6yvimn0FcGH/lO1xzea31ftazh472ODAyTnhWlZC3d4ioL9TKPx+
         Ric11O+rfZDY5Hz+vg+loa1U9n6qSTPb+V1nKa9cODbY1TOHa9V8vbFiIWgSSB6ZnXEA
         j0/jceaGlN9ifX9HyTL7RIY+DkrzHo54kVgj0UsC8jF2TVa4ZVqufCifIzRjXhdSIzK3
         5L25Z3eO77I9cyHnS5NZwWbpHuMuSac4/74naoRkvE2qforskiqzzfif1RV6YB/phg5O
         YrHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMjBwpSJtJzI53g77dGiQagEZfS8bixrbjrzPIkyUlZStpjI7QWm0gHr+vWNM7GxinKQdMGqQmOQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/jhAy5DPotgUCUswzS2mB7k+ruTBL1bxfUflH/C0ozCBK6O3P
	AJd8v4HyRujDQEwnUAZs2jwppGq4RifuQgMATsyfGgjMWaawCZLSoUnP
X-Gm-Gg: AZuq6aLhTNBUoaDMHyJNY94IIov34bFaRdXm+MR7KTVwoCEDhzyuXunjc03ZFVqkm8j
	NFMPj5U0FciuBKzaGO1WjHpEUFNya6eA0NhpF0ty48r6lycixYl7KHNGbcpsNhi4UX4WW0uac3o
	0HfKhcGZDDpHDy4EnXw4A1reC3bpZh5Y7oWoB0+2M+yz3dVkV6gZDrsNl+rMGMCoIN5aeliyxCC
	3sZnqPSXGd8hBNkGbgCdjOXb9HnSdCJJpyUVoqH4hizzeQNXfpBTM3L/98UPEiAFRUHuc9XSkWp
	QSS9MGj18uOBWbfLGeW9Hr4QaYRTTrXwi8dr30N2blLBdaCKzmGNu+L+mfWo6hVkQWXmMGntlAA
	uqQeHREkEoELjFlrZx2dg5fx+zEqZ901DL3n3m2x+AQ5cmVQPkgAiRHDF0gd2HvuP9qRb5NuUtm
	2m8JIy8oavKPVffYsF2F10RII=
X-Received: by 2002:a05:6a20:e20d:b0:38b:d93f:b45a with SMTP id adf61e73a8af0-393ad376b08mr5111954637.58.1770452197241;
        Sat, 07 Feb 2026 00:16:37 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c5955a7sm8028189a91.17.2026.02.07.00.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:16:36 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v7 1/5] mm: khugepaged: add trace_mm_khugepaged_scan event
Date: Sat,  7 Feb 2026 16:16:09 +0800
Message-ID: <20260207081613.588598-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207081613.588598-1-vernon2gm@gmail.com>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 58BD4160007
X-Stat-Signature: brtk3w7on14etdxdpnxfnkiha4dzit8k
X-HE-Tag: 1770452198-927467
X-HE-Meta: U2FsdGVkX1+GWzYSp2Wyoy3FP2mJVSrAOovRAL/FZNKg9/Lh6zSW92a9S9caNs+5kMioyrHjbWfjAOnpxYrRbNGern9L5EeCOe8JjR92rFsD/FiKNcjvxyq+BPGXqY9KJk7yzgPo8Wv/Nk0+olpB+rSiw5bGIe+HbzdU4fzRbzNpXJCY6b37ayi1oZJgRR43WhzWmPgvBTEeYstAu6RgneFhXxgxmCazinZFO6NUO5tfA0OEbV+4WTzhCHvjAPQZaNE/NRWmyI8bwoUduCVGWEd5ZZ3zkthOTsRHLCs008oF+wRZqCNsAPe/qTQYHJ4+UKEeUoWM7p8ksl7vTR49BLofuc+cEa1bKPczZHB7iU4FcW9Zy7G9nMEU/kspU1e7jWvpwlnDd4w49Udpoxq/OU+SfZMNesUvO5yr8K93IqXU/8avdtz3ILCdj+dREDB+XddL5bTqCW08rQSNxGKEaEnQtZfsPsq9LidqtFsH8GhwMqe7jktzLsRCD/TgNo9VIG9QmBoQALVQSK/+q9xkI8ISl6JJiDRevi9WIpyPpVVzTFzxozRlCXniPxOUw8OykWp0rREhyRhh2F+BnxX0NSdPiFyA+Jxe9hBQLwpu5R0PEcfBPyNj6rCXIo+MwH896ZF3jtoxz3L0/XHIaYMaHczfd9NoB6QgbWbLo5/vYUBApAfIUxmluKgd8Le0xEJYJmbPv4Yiq27pBXkb9V1kGQ0y4O21X0ZMmaF6Vr+hKq2vcYVE35X5Io5mnjP22dZ0vIXZEvDmId8iirkIBqCPE8tuMZfw2hQdixw+VR+DwVn4CPi394u7qxJzgb8dmujRKbPi5Coy2qiqWaJQwSpNjleSTsGnGrCaOgTokFKbh9dyM7nHZqbCUtyJhq3pZyIuOgDtUR4KRUxPpMJte8939fgUj4Db/N7HD+glPUq7WquzMIOvb1CkUeAcOlS0GuPAzyvW6UbGMQviXvgqZtN
 gepjv3sb
 pply1/0yqYDNMJBbUz/FepN9tX9FYPFXmG1jsClKo31Z2X8n7HagLAJakadTRKfWgzciHsYOkKilxXzYx4WU+WDQmZclKZVnwIe5SviEXnU/R2x2oRK0cDapOMa3JKXQ4QIm+a5gZ0S2zVLLAUGQTE8WUu8oCRFtXkXOlGxesds2yFSdy4qMxqB5n0WiQSbLHHR9uye465wamn8cT/oO9C5j4KruD7hs3zWU4MDPkaOpDieU4zr1Zp05EZQyMKPobaIsFavAPbDbMAHUyH3yOZuey6BH3jAH6ia9996D6M5JjLEwUQKs8qSO3s8iA+fNOrklJf6FYdpwTQWiVXtYYc9bCSqtxZEyfTLioikjMCAiQ1vY4MqvD63gComYrnCqkoAAtQFBOHBsGfHouqLaAko6kCGPTSQqJKdFYfWHhRNhNDShSsNiEHcG87zMID2gjJDro2GZtM7vLDvmjZl88n96fQRmtaZUNqDRUPcIDlbeO8NvCXUWgaCVtB5Go0cbUzdGrcFNElwL6mxwHwsYeaF/Pu7Cyuhzp1a6E/dWS3f5keEaQvVbQxiWG4qP/br5KSZ8uuD94dYT6m36mvZJhb67DQMZwQvRwH9Xk8/A9IwBqE8U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Add mm_khugepaged_scan event to track the total time for full scan
and the total number of pages scanned of khugepaged.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 include/trace/events/huge_memory.h | 25 +++++++++++++++++++++++++
 mm/khugepaged.c                    |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4e41bff31888..384e29f6bef0 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -237,5 +237,30 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_khugepaged_scan,
+
+	TP_PROTO(struct mm_struct *mm, unsigned int progress,
+		 bool full_scan_finished),
+
+	TP_ARGS(mm, progress, full_scan_finished),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned int, progress)
+		__field(bool, full_scan_finished)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->progress = progress;
+		__entry->full_scan_finished = full_scan_finished;
+	),
+
+	TP_printk("mm=%p, progress=%u, full_scan_finished=%d",
+		__entry->mm,
+		__entry->progress,
+		__entry->full_scan_finished)
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa1e57fd2c46..4049234e1c8b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2536,6 +2536,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		collect_mm_slot(slot);
 	}
 
+	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
+
 	return progress;
 }
 
-- 
2.51.0


