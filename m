Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F516FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6079D6B0088; Tue, 28 Apr 2026 09:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DFC76B008A; Tue, 28 Apr 2026 09:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D3D6B008C; Tue, 28 Apr 2026 09:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC896B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:32:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF86FA016B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:32:22 +0000 (UTC)
X-FDA: 84708053724.04.6AC4B53
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id E4F3D180004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:32:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H8qspGt4;
	spf=pass (imf24.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777383141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3byBSOEgzWp/7f2Lr/jllR3/Q+AIHH06pprc3xCjkns=;
	b=bJS1ZJC/j1cj4288/wAnqYjBYod4VJ4ustW3G6AYpcPfwwrqD+aroKq/cLTRU7dJq9iCRP
	Ph+/L0bpiJQfbKSPQ3r96fwJPUzdCCKL9TKsqTWlaK0WWwSaDtDUIvyIgoxokFw+i9zi6B
	XbZl29ggp2TELOK4A3iPrx11S+bmn0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777383141; a=rsa-sha256;
	cv=none;
	b=XeAfmrLwyWKFhccem1pixGYhwlJcQYCu4uFDDRnKjLeA6+7xPBTYt7t+Q8I555YHW7gpP3
	7mKiH3DBUNeNmitUMbj1KF2hgU4Lv2lnORA5cqZTGitSZRflhMV1rE9JAAeBD/EspGM8lQ
	VtNEd0m/5UcR4e13lRzL9NY5Ea4OngU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H8qspGt4;
	spf=pass (imf24.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82fa8d6425bso4434527b3a.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777383140; x=1777987940; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3byBSOEgzWp/7f2Lr/jllR3/Q+AIHH06pprc3xCjkns=;
        b=H8qspGt4XhAz9t/cWTk7mok4XcJA4qCTf0rFLhtte5Jk/6Vga4JXYzvunH9Gu4I2Ya
         EPl6GbJZEDwb+KbZQOl/fewcCeAuzeF+xI0R5PzJsdWS8CenLSL255Cqk9Cd7J1ftMVE
         Tvoj/qG4DYsEDmWnfEAVYGi+v/ZA1Pr42hKwMAQXpLEUxukf3FuKxjrVbRVmsWuu+Aa1
         uIGjNSvcNBSki0qeUCTQU8al6XY7RE/Z519c486+/vwjhBMBIeo8AItwHBz4+KN8xwm7
         rwqLuLQRkC5xHbv/yLsdVH+leIgMj7MzkcrWCdsnksDleU6tVuOTaqZsz0YvNW7iqJLB
         TJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777383140; x=1777987940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3byBSOEgzWp/7f2Lr/jllR3/Q+AIHH06pprc3xCjkns=;
        b=RAzPVp/eqJ7fExjRM5xFmYIMoJTw3OxckNksaukvHIV/uzjdsztQQscGKUQmmcTErH
         lpYno7T++nZlD7FXSDknMW7UMaql+5Z4nIjh3CTdR7QDDBAqkmtSmfZXbBIa6JCmVRlA
         gQ0WcLA07NOh056VkUqv+opt++XQjihP9aTaOsz3sRO6GoyDG23sAc9WdyO3Qi9ThhO1
         HVW8Kb3DkdFoUB861rbwHfnAjDpUsqQXWcbZlNaK3wUzk/dukTC8BM15Ld9LyVD7/kfa
         cUie+L0QVJSKVgWo9YJhViy3xyeuroOrzRZn5J5c6UX+6LRV1lJG4p50rpLzbh9JkcRh
         A9zg==
X-Gm-Message-State: AOJu0Yz/lAfX7y0y8F6omHWzFHCPY+DUj3akgWMiWlRD9lrsq9AZxnku
	uYbaU2bHNirRTws2Ez9Xy71Cg1/Psu2BXb4VQq6oJ1avC0JcVRghnCOM
X-Gm-Gg: AeBDievTYoMb5P6d0QcjKf/lHAxo0R4exQZTnCBsrWhDkrATIRKwL6bIncohoXE10ca
	pNZgFf6p3x7pHSiG/SHZFoxTgDCJB4o5zW2b0XhCIInYirPdcAbYonsRJyJrp+s+URq/hOTwhbD
	wxEQ+iNntHJfgr1sri9EPkblPEsVuypbb4aS6BCKtizkglbjQumweeR1X10k/Ieb+sUqB4HQ4cm
	zDKb0esbE+9RzxG9V0ydopMfEInZvhZGUQZZCbJHilKVvqvf2evmBg0jOTSf9YQRSKfzfQG2MtD
	ikWSCrPBaA55iuH7k/FGojyPZLvz1hmFA+M28eKjx/dUKQdbOHcy87L67Fqc3mAI1duMq1Yp32v
	DSWMqqdi05EbK6R6GtxNnzAYXQjMSQUSBVKXah2IRzuLL9VFiO7AqNQ9KthmndDAdG5v+xTNGx3
	4Nmn2JnWfLRS5arM7BWTIOS5sthQJvhBkf0H9jDlGC
X-Received: by 2002:a05:6a00:1802:b0:82f:bd8:70eb with SMTP id d2e1a72fcca58-834ddb5b988mr3067266b3a.21.1777383139525;
        Tue, 28 Apr 2026 06:32:19 -0700 (PDT)
Received: from vini ([2401:4900:8fca:e7b6:f223:6319:a79e:7616])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834dae2027bsm2914609b3a.16.2026.04.28.06.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 06:32:19 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH v4] selftests/mm: khugepaged: initialize file contents via mmap
Date: Tue, 28 Apr 2026 19:01:38 +0530
Message-ID: <20260428133138.88802-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E4F3D180004
X-Stat-Signature: m7311xykjawn1hupcfatxoeyhba7siku
X-Rspam-User: 
X-HE-Tag: 1777383140-171466
X-HE-Meta: U2FsdGVkX1/+SEzTswX/c2u1BNo0gELSL0rXkbpxzk4CgzQ0XqxrnVfDfoohpPlWcTlUPoeLI+NB+BLLQSySZUo/41mvy6jjRltLMcciid0MKmx/1S7AxiFI1pRV9ZFSSaVIZyhKIX6lJMzXrMw6QXMMk7p3PxBdPwoHq4PGE37VL+LhMXA7NG36Ok10aNrML3S5Ss0m4+VBwb9GvmJuXiEVhfwWIg2AdXea46og664Qh394Yl4jNA5kUev+sf+1ZJtQqB/2Kl6hf0wGa1ufV4xXL3UGEaiqd45g7AIFTbTyEygWcN5Ydd3PVX0Jg1cNxU4CkoeoTjZu1WHl8MyLs8s8rEF0dxhPkTKe3It+SaHGfZ9b+43RJH2/cweIUvnA/9ZXdO6ADuiDL+qhrqAgLfv1ahUguPcGWUIpXdo7/F48GrL1nErgxNdHIViduWDWKzH56YElDwEeZ1WaulX8fYhMykuNX51Ptx67QiMO9Un9TVyB1nVqKAa2pUC2WfPZvJxYSLPy396d22P1oXv2HB/VP2dIJBW7DYAqzRNf5nMN2VcxnQ2GpWHfgm7hugYh1YLkl3Od5VFLsQw0GpxnzlEGT8096z4+b9xxYlCcuxMbaKrSomE0qEmhmiS4P2+t4NoaBNka4LWW6X+Rseh+O09f7GymZ2OT7TYZzw1dmYH0xt+PekUpulxH0B7IVN0n7ndnYXctBMCgYg6SeZz1IlAfWdAQCoqdCou0I1xQxV7Txr4AdoU0NWI9ywSIB1zGPiqnho3UB5Uh/OVvDxgAipGyvoMqvFVXTc+2CqcFAhAa46KM8oD7LWZXs78mdS9QAl7yPuM3tZXrmpWhDeK+zwhpxAs3c+/lk+TCuql1/xVVPsaHY2weriZMza05cHcDdBg3LFbZyyl0BC380/+afhLasVo1O97JNpYfI9X0sdLnPmNGSjcwH3mGl7piZNl1Jdtd2O3lJcCrWuuobK5
 NptZwdaO
 FdytEQky8+oSgZ7DIEFI08uHViy0wMXOUjnEQQI2pjQmKh31361oyYSTKZo1Ort8Gw3RZjrKsZ60iIdnke1bDW+5awPVQWvP6oCuqjfL6PW3c9KP4tkFxsoe3Vt9JSJyoZvtT0qxmPPH6zXgLi/W6hwp18DtuP+Dx6mV6j5agwaIq1lXr/LT5+y4iz0kbwfpz9Fl+K/OuAEgqIVckIffSYym2b1L7v2MKwUe9bVV4FYH4nUGKQnJsH00CgXV6DRtt0kD68v9Zjt/ARIHsc60jga1MLEIe090CHxImrxGwtR+DO9DKhMhHL6TRXsXQmnxMnDcSIn1k1F84Hezz3DeSaqeVbkuqACAEi77Wrk1tvXuY4PnW7MwNEhppZVYBkCtIvZmXMp7iAQptvNTSIjZNrocaXFm1pGUgqsluXObMuVB8Pz0OpUaNUE0cPJh21IDI+7MW76IvqJxxd6vNN/yV3NtmAsTIN2PBUXN6HiCpY/ljf+cOeRARbSSBDZZ6BUzX33oG43Dm7/ba26ZQD6zbYAvK9M4sKlxfRIqWJ7NRR1pOBF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

file_setup_area() currently allocates anonymous memory, fills it,
and writes it into the backing file used for collapse testing.

Instead of copying data through write(), resize the file with
ftruncate(), map it directly with MAP_SHARED, and initialize the
mapped area in place.

This simplifies the setup path and avoids the need for explicit
partial write handling.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>

v3 -> v4:
  - Restore unrelated blank line removal
  - Restore original close()/munmap() ordering
---
 tools/testing/selftests/mm/khugepaged.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..6e929a484a1b 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -381,9 +381,19 @@ static void *file_setup_area(int nr_hpages)
 	}
 
 	size = nr_hpages * hpage_pmd_size;
-	p = alloc_mapping(nr_hpages);
+	if (ftruncate(fd, size)) {
+		perror("ftruncate()");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
+		MAP_SHARED, fd, 0);
+	if (p == MAP_FAILED || p != BASE_ADDR) {
+		perror("mmap()");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
 	fill_memory(p, 0, size);
-	write(fd, p, size);
 	close(fd);
 	munmap(p, size);
 	success("OK");
-- 
2.54.0


