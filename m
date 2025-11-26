Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD2E1D10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF4E6B0032; Wed, 26 Nov 2025 11:08:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6C46B008C; Wed, 26 Nov 2025 11:08:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0BB6B0092; Wed, 26 Nov 2025 11:08:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA0876B0032
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:08:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0BF2BA9FF
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:08:53 +0000 (UTC)
X-FDA: 84153241746.02.0403E38
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71889A0019
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:08:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iFmA98K8;
	spf=pass (imf25.hostedemail.com: domain of ankitkhushwaha.linux@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=ankitkhushwaha.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764173331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0w85V/n6/PltUzl9FbkvTGvY3LknN/8DxQ32r6IxQUM=;
	b=F0RZuqYGTBLIkZ64wO7aJM5nGVJ4pvW41PJl2dyoRP3TuHWvRzSxVgqyDeQQaedInxRiuW
	FBcktge51gChde71LSGaJxPOb0zA86jOWr16xkOzwEf1DzIh/22kpuHjWYP+gYnZpxkE+X
	BdWEFFZscEqDULolFiEyTYCWnhmP1Ic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764173331; a=rsa-sha256;
	cv=none;
	b=McFtnMFsa+aZa7kSBeMtRM+DOUr8zXkpYlN4DDtSi/HsD+ZFWbK4Wvf+wOrKf+KTORYSAL
	oUESpxPGUavjOic9BizjdfH/72MKAR+rbl54VF98ikypeowhG5YJuiCBaZirznYt4FNlSN
	akcoLxaJgzY5faPR7Ta/K1xZO61aCto=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iFmA98K8;
	spf=pass (imf25.hostedemail.com: domain of ankitkhushwaha.linux@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=ankitkhushwaha.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so6582007b3a.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764173330; x=1764778130; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0w85V/n6/PltUzl9FbkvTGvY3LknN/8DxQ32r6IxQUM=;
        b=iFmA98K8sDUyg0jbwm+iEJHQNzs+7PoXNzZMRrGz8C9aLxT/RZMSyzf9FYAPKSOsy4
         ajYBVc5i4+E8WnTfgLfBG/ZveU1P8wgQ536W7jCUjawOj72PngkA/DpASzctEPFjOygG
         CTwbIj8GN2HOqGgZk+xOcN+cXj/EGVSZHhYbjDIfJV/8TZleCq5SZbdeDwDNR1HsP/RU
         7NOMifp3ztoMbdQ85oMI4bAS08vaB9OtlrJ3T+x21ccj87sXOwVZ/ceSK9ZpvvfmYB3c
         ckJ6hhxyUp447NbxNsaTwPUCtlXN8fqWYKhMYm9ULfCnT7I8K85gbqyMzw0bIskWcl1+
         UD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764173330; x=1764778130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0w85V/n6/PltUzl9FbkvTGvY3LknN/8DxQ32r6IxQUM=;
        b=f7xOcIytkrfNvt+5HJJCGeqQc8wTj1J/jHw0THnOChuEgZyO36OU+8ivGR2RI0Fl1W
         4jX3tg5Y4NDDsP3u6aYCF4TxGZKmoOFm1etSVE/WoOqjSQ5wXry/cNLOU9sCXnZ/+y79
         qJ3f2Y0p/u9WcLjx1a4rIw9TKs75HuW3MKf0s2bVQoF9anbUxf7HcVva6J1/2yJVdB6G
         kKm9sgQmsVQATh2wIr/yfBI6rakYim8tZdu2Qr7/6yd+OnGVkW9sLtHMvwZwCTDqciqE
         rhD1C5hlh9measZr5T+nYM2FO4d8bBNdFbZ+WU83UI2iL4DDigygt4ItYYRCiUspuI5O
         /0Cw==
X-Forwarded-Encrypted: i=1; AJvYcCXm/dhFk1ap5/d01RU+EEAoWpvxflSd6QorWw0WbZNBHf3z08fy0X0ocyDzTn87ooi+JjXxW8tvVA==@kvack.org
X-Gm-Message-State: AOJu0YyGPXcEFbFeIfWZyFGG3B3vpgZk7wagmQrRu7d/35/ma/bHxLwY
	7f/91vSPHPl4cRYH0H8m+PRThW/JIqp6tIzJf38cwMw65LUigtB4VwlI
X-Gm-Gg: ASbGnctd3iXh0dinEl4JCI57XGzyPvs4czZez+nsaX0IRYngWVgOn0d8BX6Ir78vLcZ
	3HZpQzgwcUR5a2hlaBG3/N1j1Wo8sbXxSB9L3U7OBddTwKqCEts9YzEHRalqatqKpw1T7mNq7Sp
	EKm3uE09ggl9ydDdgwLuFnFjwdKlcdTi2UjI0bpJUw5J9wPv/sHvEZ3/u6BWA+oJjPz8w1LY7ks
	peBnQGVRdWcSOF0F7iKbheDYhYup+O8GpM4KgF6wB1AP8WLjNMYOpNI8jfGbGskuQhD+GImyPAr
	guMaaAJ5qF9FGSn2upGN7VIqOEmp468hM/AvkVQ6rfsJNwFRO3iAMGtAJHSLueEvQreoyV/+ytA
	7B6JLQo33mksnQw5F/GgBfTlBas7o69dcGcNDp1xFGS3rJ961imo8oB/0iv/uIoOAoz0jhLOlDa
	RuzdR09QKxQ6K/GeF6YwmxuIfvgltzAQ==
X-Google-Smtp-Source: AGHT+IEebVkUKBP+U1i9Oqi7Ort6BI2gg0wHmeA+Y9t88Utsg2k3h8rxgk1fLNRybEyKRORRW5br6g==
X-Received: by 2002:a05:6a00:2d88:b0:7b9:ef46:ec70 with SMTP id d2e1a72fcca58-7c58e50c16emr18224646b3a.23.1764173330206;
        Wed, 26 Nov 2025 08:08:50 -0800 (PST)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f0243b3csm21831681b3a.36.2025.11.26.08.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 08:08:49 -0800 (PST)
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Cc: Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Subject: [PATCH] selftests/mm/uffd: initialize char variable to Null
Date: Wed, 26 Nov 2025 21:38:30 +0530
Message-ID: <20251126160830.52124-1-ankitkhushwaha.linux@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71889A0019
X-Stat-Signature: 3go35sqhzeo96jk1zdjgno53ujstz9ny
X-Rspam-User: 
X-HE-Tag: 1764173331-56972
X-HE-Meta: U2FsdGVkX1+f6lHK9CHStRZZysXRvcnir8H9zmy/Ka2edLX70MuLPYpRN0jI3+cjdKCC2JkPeB9QH3nLf5HB97zo9y6PTjceLyEOzNhLlMs+/MyJcuBbtQEJOCpYj0x2s6Zh9sVpgU168xE8pXL0N0c8H64BOWJqgg0kGTvj0mJhhDX02rPAK0dbzIfzLsX/TFi5sekYgAkPTyIeFncFFyHR7y4FKKcY5rhGxgCPV2DzfFwHf3lfNPmgLGxkKUFMkgF4444+edWqRPkNhCTaZGg/hj4GTwFw+7EcRBdMYRbekq42wpRQKTsnK5jwyJgN+MZCFemJN5hnegaLzXl2rcq2Jabn2EAP1AyAm+N5Kgo+d6psV1DTk2d6asagU6QQW25BMsqOoUEkLddBYqVpG+muizTLuEu1dy5qRi1x/CvoxcO4fVV8eeNvnsKUpkD8obQXv6SVoHYGZSqqrT/Eect5FzCTkZQryu1tGy41CCFz6iSqLn4RXw4/uz6P8iqQyphNLUGo4daNVWtZ0vLP4kHAFgdcOWo5vTvNsTKU/3+9s8o3e6WzJGZ9GZOThvNa5Tb2Xh6pBpFxBnztjoBDVlfkBZmmkuyL6B01T3uCh8TtajEhuyvzMaWpmwG4FeAkyhbFG3reHYi5XeajjhTfEzDRG6Cjl6xC5JNXpVj2jnxFgazFBAAo0VVgvJHLMQIfo7/oBBk6r7TTwRowNfWwykbyCqoVDHqlqoYzB7bl0EaXPjfIhnBzmiyDfp5ZH9HNWHGBbfe61mP20o5zCa7RtfFzWzYfvh8LaFkU5M7wymJJ4Y3t1GRL5mqOdOuXkxuSeUQXGeC4/CRzhZVkb4zHZfBffv5rJd208ZMLO9FSp9B1aH9i2s3C9gvAZu0PKcytsc9YB4vuOtTNEReU7lGBH9cKkhhpUO2k2YE71AKCz1IGMeLkJYvNawoPFoRmd5/pIcTVfuB6bbehCBxjgXl
 c3xGKbhz
 2rHLSF42eJLm6hYqhLtVlBhQHh2odSJEdclZHd7NguNWqTl1/uBF10TsYxOieV0Gv4e81FvK6sW0dQI6a8yX7L8wVWQ6R+C6xdP9alwdSnfq5ttMaFZlwo8nnYowtIYDX3rcc7XSDdv6Iytgp5xlj4zhoX6wCkEdR0KMgkBu13n1iZnDc2JtdGAmcZj269yppLQLTLPoVXygm5dirtJ3BwMOcqZEd7thWHBkNtg4jZ3J9SCfQ98cq//oG4btoR+xV+8vDUiZjRMyaV4Ly8aGqKQtLBLbEmg90LHxjdLceP+bpLhprXcFOGSXH/Wettw0xznApH8WcTlhvM6esSFh36sbXj1w0hqvbCrFxjgIwp/M1pwlWuHje8/XoIBM27uhWtA15d9AKQu9LzGWZZVsws47YEHW8nkcqn2X4oi2PXbdv0XVDGH+g/ETyQBRungXlduxY+wLMopClCBLQr2vzGFNlDPWO4MJy4no3z3Rivt6Deg0i3ELM/J7y3demueKEcfSyh/HR36uPbavfk+eQTHxhydPY9290HM6upUF5/i/V2vFZ0m/KcykPzsynj7NtYwhbAuPNAvO5vB8yc3nMuL/xXORegX83/3uADnm81LAi1w0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In "uffd-stress.c" & "uffd-unit-tests.c". address of char variable having
garbage value (uninitialized) is passed to 'write' syscall triggers
warning.

	uffd-stress.c:246:39: warning: variable 'c' is uninitialized when
	passed  as a const pointer argument here
	[-Wuninitialized-const-pointer]

	uffd-unit-tests.c:581:31: warning: variable 'c' is uninitialized
	when passed as a const pointer argument here
	[-Wuninitialized-const-pointer]

so the fix is to assign char variable to '\0' to prevent writing of
garbage value.

Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
---
this warning is raised with clang version 21.1.5 (Fedora 21.1.5-1.fc43).
---
 tools/testing/selftests/mm/uffd-stress.c     | 2 +-
 tools/testing/selftests/mm/uffd-unit-tests.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index b51c89e1cd1a..700fbaa18d44 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -241,7 +241,7 @@ static int stress(struct uffd_args *args)
 			return 1;

 	for (cpu = 0; cpu < gopts->nr_parallel; cpu++) {
-		char c;
+		char c = '\0';
 		if (bounces & BOUNCE_POLL) {
 			if (write(gopts->pipefd[cpu*2+1], &c, 1) != 1)
 				err("pipefd write error");
diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index f917b4c4c943..f4807242c5b2 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -543,7 +543,7 @@ static void uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
 {
 	unsigned long p;
 	pthread_t uffd_mon;
-	char c;
+	char c = '\0';
 	struct uffd_args args = { 0 };
 	args.gopts = gopts;

@@ -759,7 +759,7 @@ static void uffd_sigbus_test_common(uffd_global_test_opts_t *gopts, bool wp)
 	pthread_t uffd_mon;
 	pid_t pid;
 	int err;
-	char c;
+	char c = '\0';
 	struct uffd_args args = { 0 };
 	args.gopts = gopts;

@@ -819,7 +819,7 @@ static void uffd_events_test_common(uffd_global_test_opts_t *gopts, bool wp)
 	pthread_t uffd_mon;
 	pid_t pid;
 	int err;
-	char c;
+	char c = '\0';
 	struct uffd_args args = { 0 };
 	args.gopts = gopts;

@@ -1125,7 +1125,7 @@ uffd_move_test_common(uffd_global_test_opts_t *gopts,
 {
 	unsigned long nr;
 	pthread_t uffd_mon;
-	char c;
+	char c = '\0';
 	unsigned long long count;
 	struct uffd_args args = { 0 };
 	char *orig_area_src = NULL, *orig_area_dst = NULL;
--
2.52.0


