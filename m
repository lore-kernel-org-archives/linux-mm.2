Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB977CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 19:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8FD8E00E9; Tue, 14 Oct 2025 15:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E694A8E0090; Tue, 14 Oct 2025 15:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D580D8E00E9; Tue, 14 Oct 2025 15:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE62F8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:50:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A6195C44A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:50:29 +0000 (UTC)
X-FDA: 83997761778.13.543ED0C
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 908C31C0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:50:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Gj/5RGPe";
	spf=pass (imf20.hostedemail.com: domain of dalalitamar@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=dalalitamar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760471427; a=rsa-sha256;
	cv=none;
	b=xPz82SGBfBBGCJF2D19PqyZIqdUl9Y7+ICOuODcgS6LbIceWA3TmTyOgLWJHy/wRDFa5ty
	9NmlBwr2wCHG6aeeFJRnrvn76sNksX08lHtbN5uVDaIu2A1vDaSXexuesBvtj+6X2zSZ6K
	eUqHjZR4eDhQtcAHe1dpxqwurWWYxRI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Gj/5RGPe";
	spf=pass (imf20.hostedemail.com: domain of dalalitamar@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=dalalitamar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760471427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MkhCJA/dXOXcwZ7S2jDqDvDpKsjxlEMR9YOOSuHW/cQ=;
	b=Dr9IEBwAIFuxgB/xZWuguTH6+g6NCcK5qVcPur8IzfH+XDWETkBC2LoK/BlrsB9aObj/LI
	meQVaqJCdhr43W1W0e+NQGZ1sj2DY7Mg2tWujQ8lL8B0t63TXN3U3MsMn9ifkIqj/Tdt1l
	N0C9IbYMBuKWJGX6zHvVzOTHo70F38M=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e37d6c21eso32441135e9.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760471426; x=1761076226; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MkhCJA/dXOXcwZ7S2jDqDvDpKsjxlEMR9YOOSuHW/cQ=;
        b=Gj/5RGPet7du3d4swinUb0E2eilm5N1MlX58CWbcRHN7rOK7MW/8FxYmtlDet4HFYn
         B73TeK1+w8dcWnJTtgQaPVEQByaPl3ysif0Y6YjtWFykwFC/9qe3y4vTxmA7+5Kgi832
         Xwd7FOAIGqjRK7+4ve5ZncaLdlBmT/nN2U/8mhtmvXfZCkPvxHo4F4Tht0B07txzD+FK
         wb/AMU8SltdG2eMUtz+03jxZ6vW3nCvXiyNfnn+k9ASTV6HujNadIaK5bvsyDVsoOdAj
         KWP7mhhDmjPqksHJZXS7i6lRa0xiw71J4PeDfN101lPEDBo4DDG8RGzQF7teDh/8S+aW
         tHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760471426; x=1761076226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MkhCJA/dXOXcwZ7S2jDqDvDpKsjxlEMR9YOOSuHW/cQ=;
        b=X8W4/kM/N7YirS6MaNYFFhZqG7j5xM94nZtL6ruHmqEjVlyaVdScm9wXZtM3JYf73Q
         i8MslRbQCQJTL8JD+mBl+OXsfnLilUB3Rh2lgBxgmFHgxgQVe2pTrtvGz+r+zCpoDGmk
         t3JwjklTLtMfipH0txpcZbrolJ5UYNwh+q+9uiaKwN2PUCL40zzLLEW6bPbXd7Dug4db
         K20+BxC9W/hWh5b9heqk4xpvhjZN5wwKZmysN2mkllTbrcgOr3lMplGDg1nY+Jow6OuD
         YGYD3Zg3ggGciKF5+ZyOB1YGKv0rS4BEj1z3BmPCbLDuO63djv8xeJW7QUDEHCwhfCHm
         LOdw==
X-Gm-Message-State: AOJu0YyuhqdYdFrZxNeDqpLc+pa/dDCTbP1DtX7+8fhmr599it5PioZt
	rSIZg/GX5j2yGlc4mJ86Yw5ji135eSu1o+1nvzdBo/iCt6LIGsi2SanbBx1rIymDm1I=
X-Gm-Gg: ASbGncv3xZn+MZunADi7SO0yFQRmWkrDtCGEtmSGW/gjeYK76yFk9UkufVD/dN98flO
	qysZNxiw0uA5lvkXIiBx106gx8Jy14uUW8hDu1QKJa0NOvKARbPEwn2zOmUhgd79vRmAxCZtfQ1
	14zZF0tN5yXGZZx0pWJzBTz9H4JclUW0z4w3qO3uCD6P2xJFPZXAv8Ac8di+hPd6g8Xm9ZXF4u4
	LLN0Y/9nipaDSFDJZyRoqzQM2ZtcaPj45PM8IjWuv3xIP5oIBQaZyk+Dxc3d7G1atzfgGOS3CCE
	O164ob5g3CMkeOWdmuuys3PYQgwn07Zf5Uve3FCd+3um77eFzN2NeCHRV3vGQ7XR9LumdJERJPt
	gZzFkEAzA2NEynKx1q0nfR+rioixgWlPsNtwQBgy42RRoLW6nMqeEhC1ziPUf9C5h326/Kokx2K
	xZdnFXi9YnORXd0ZI/O7l3EnN3ZEWhRQ==
X-Google-Smtp-Source: AGHT+IHvY3jSRZiPAPUTjqLzv3in2vImFrsh3WPQgcjJugI6dCptqZos5H5Y/+xsV4lVpQrYH25Z3g==
X-Received: by 2002:a05:600c:1e86:b0:46e:6a6a:5cf7 with SMTP id 5b1f17b1804b1-46fa9aa0f6dmr179572755e9.12.1760471425371;
        Tue, 14 Oct 2025 12:50:25 -0700 (PDT)
Received: from localhost.localdomain (bzq-79-177-131-159.red.bezeqint.net. [79.177.131.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb49d03e2sm257969595e9.19.2025.10.14.12.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 12:50:23 -0700 (PDT)
From: Itamar-Dalal <dalalitamar@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	Itamar-Dalal <dalalitamar@gmail.com>
Subject: [PATCH] =?UTF-8?q?Add=20a=20new=20test=20'migrate.cow=5Fafter=5Ff?= =?UTF-8?q?ork'=20that=20verifies=20correct=20RMAP=20handling=20of=20Copy-?= =?UTF-8?q?On-Write=20pages=20after=20fork().=20Before=20a=20write,=20pare?= =?UTF-8?q?nt=20and=20child=20share=20the=20same=20PFN;=20after=20a=20writ?= =?UTF-8?q?e,=20the=20child=E2=80=99s=20PFN=20differs,=20confirming=20prop?= =?UTF-8?q?er=20COW=20duplication.?=
Date: Tue, 14 Oct 2025 22:49:44 +0300
Message-Id: <20251014194944.20341-1-dalalitamar@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: b6bqip8jchd1ab5hhcecz3dh3fskgxgf
X-Rspamd-Queue-Id: 908C31C0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1760471427-422837
X-HE-Meta: U2FsdGVkX18QK4MLjYaeQIVT89mFK7w6gey3sTkVcgv0Td47skkSe0wC8xRuaCwISN9uCK2JbZpN9w06Ljzi2h1wbNrT7H4lt0Tr1w1ka9PIiaKG7wNKgI4iX2tIRGfL56P9HqhZNXwrjci7jA/nAex8R3MiMXqeSByalWN4EWmM/iYkKdanAahvjyc8hCTCSCUB4rwjj/WaBFAuF0XedfFBuCczvEnIw244wHJUQmIpR13FQIIf7PopyElvIhJ4pTqJwdKrxpFdgEHOagkt9R9kcLMNzYOHDFCevuV9r+EKlfn3ejottA1R9asb3GqlEzzwjlyMlpeLM6EXDg0b4fyR6dXs6qhnnnz0W8XHRoC0TzCuKJm0tERtOhiYczGcyV83cG1OeNa59AfbbFoaD4QA1m9HtkQltZsRFKbgdPYBE0HY8Wx+uPl8rxqudjrB2gWzTsFlAWrIt2hFIj79W20rfepoQC01syaVxAiBEzcJInxrmvp0+UZaOzAdWeKq3T7dIl172FBLI1K6es/eAvCMPwsgJUIRYi18l+b+/kTDrJeCxV5tuG+PJNsY9G6Q8KJRkemtEQRvGv8YvtPCA1AXdpLQ7MpTacNEoz74Mge3VT9mMVLYYZRjDQctEh3t/oDOfcyHdLmrTnx9IZ9q1/CjKO5yqf5ijGz6Ms/vCTHino5v5Oi1IIm30dwmE/msVFT6aI9ITa5yV/nweHoFa4aG8phGV3eSy5xgsSMMELoEq8aZ3yC5crgUxByGV/0P3tjign/4oLPKJbKzFMwXysZyXxYYVYH5naLfU8T3nxZ3DStdrjs8nAtFcMaNXgNLcrP7VXAXKejTtuyd8Ho4/x0j7oF3SUVOjkEeDvQnVItQCXTdOJOMkD4TuSQs7ozZUq9qOOC1kqV43k3dh1UuXhvcU0SPq79Ye9sFpHiGBGY1SEQPhAZZkv/ltTriidIzNTU9ImgFd2yfN7WwVBJ
 5WRbP196
 bjx77Zmn3TaBFNE+/KklgnQ0cad9wEVulvGD8JfesvsB4bmwsGgjcW1j8rJFeF+RgQGpSXh/j+ur3uRVn/HGTUalehmcZ8Hpf9gzfb4zBWFoj6ipCAAjOdo+ncxbHjJk8X+ZqSr7gkxxkCtm+HFPJDIwmirFgSwUYs8LNLmRu05peXp4JNzkxvqMJPtgspItTs27+HB9YiSKTT5+RJl1tQ49P+vANX7BUpRFVTIKEUdF8tziZk/tQ7r9OJ6d7RDIrPSrkNgc68nV8ktra8MOOiYNmNijECwiFswD7s4GsWDO5hNDco7LRD0D3PTEYzlFZ5fAS2cIPqWvLtBYsDg1AOTwNAQZtdEk4rWeyfORlBuSRJ1vw3lw1ZA/CVsbuuEdtIW369mldsPsqWM4G2/7bAAcTk3AuOrEJkPPAMtV/8pCtOZt53owWy0LkNvzB2POMTSZcblgiimaONPlpn/8dR3l8wj11Ptq/nqV13UFlNQw4lzSbBFHohzWbGgq8pffQoaHES2QQg8npXb/ecKcxIkuXpkuTnRMDL6eFPgyE78zNPRfJtNg8eSnGZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Itamar-Dalal <dalalitamar@gmail.com>
---
 tools/testing/selftests/mm/rmap.c | 45 ++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
index 13f7bccfd0a9..2ba3361fecf0 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,47 @@ TEST_F(migrate, ksm)
 	propagate_children(_metadata, data);
 }
 
-TEST_HARNESS_MAIN
+TEST_F(migrate, cow_after_fork)
+{
+	struct global_data *data = &self->data;
+	int status;
+	pid_t pid;
+	unsigned long parent_pfn, child_pfn;
+	int pagemap_fd;
+	char *region;
+
+	/* Map private anonymous memory and fault it in */
+	region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
+		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(region, MAP_FAILED);
+	memset(region, 0xaa, data->mapsize);
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	ASSERT_NE(pagemap_fd, -1);
+	parent_pfn = pagemap_get_pfn(pagemap_fd, region);
+	close(pagemap_fd);
+
+	pid = fork();
+	ASSERT_NE(pid, -1);
+
+	if (pid == 0) {
+		/* Child: write to trigger COW */
+		region[0] = 0xbb;
+
+		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+		ASSERT_NE(pagemap_fd, -1);
+		child_pfn = pagemap_get_pfn(pagemap_fd, region);
+		close(pagemap_fd);
+
+		/* Expect PFN to differ after write (COW happened) */
+		if (child_pfn == parent_pfn)
+			_exit(FAIL_ON_CHECK);
+		_exit(0);
+	}
+
+	waitpid(pid, &status, 0);
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+	munmap(region, data->mapsize);
+}
+
+TEST_HARNESS_MAIN
\ No newline at end of file
-- 
2.34.1


