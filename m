Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C9DAE7C71B
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 12:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C566B0093; Sun,  1 Feb 2026 07:27:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6A66B0095; Sun,  1 Feb 2026 07:27:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0526B0096; Sun,  1 Feb 2026 07:27:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9015D6B0093
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 07:27:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FE76C29D6
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:27:03 +0000 (UTC)
X-FDA: 84395812326.21.F78BD9F
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7368480002
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:27:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B71BNnXB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769948821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLkYdcrr/V75vjPKPAtmOhxaUd8xlxxQ6DkPLWqUmvU=;
	b=wxT2Aj5VB+rS0RZ2JLAJxb9086cRJQYus+GBBvUeq8TTgQqgyRqx3iUAPggL4GKoer2AMe
	d482C6/SZLs8NvMqtFTTfY4g9Dor73i/Z9zrG1z+PWCyP2yKJpAW1NdruyxcXe9D3gYMSi
	btpiPMzjYtCYc0hWnh86COTobbTKCOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769948821; a=rsa-sha256;
	cv=none;
	b=ld1UoVswdbiABTXa3zGKMsaUIpGLy5AbXDuaHgNlXl6gHdZqF56Kz/e5qogiHgfQBv/b5H
	CJvOF4we1t3hNXq85m6jvzhwvdvvLT6bvSJES/R939MraXHdp6vbJzD56qpBXSGwzfP8hj
	3/rOZaiQ1UHQ9RZe82TGXN6OjhImrdc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B71BNnXB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a7d98c1879so22446635ad.3
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 04:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769948820; x=1770553620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLkYdcrr/V75vjPKPAtmOhxaUd8xlxxQ6DkPLWqUmvU=;
        b=B71BNnXBMaPWLlxwdZ5n0KhzQf+Kb/+i3VjAwuBurFI19PClLpP4FF8I7hnmU8ORTW
         uoD5XxEM5CNoL9YsrkvgDf9GsXctaZSMbsPj6Tn5rK3+wg5hNM34Lk+nT2l6kxH6awr7
         yqjIkILF4jGOH3Ru3FYHOvqPkhPfbYe7jBWZMCweqwapsy6fW4jpGLP4A/Ls1D3yaGoy
         U0GldO8VToWy/Nz/6rXbYP1CXjTCJ8i9jagdIPPYLUXz6ZXQjbsdDDjKeybThoXnEtwC
         cQ0nwpGE58rbUQL4qk+o3u9g9Wpa4BwltwHGLvK8n3r9uInev800ma0LzcNLUXCHTxPD
         P8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769948820; x=1770553620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nLkYdcrr/V75vjPKPAtmOhxaUd8xlxxQ6DkPLWqUmvU=;
        b=iSQaHaKzrDpRsPR+nPhTfiXj7ZRDTL8zx8DdzMuNgHkdp7cGrRkIBx+HkdmP7dQukd
         a6Tbapmiwpti9a+VJub1qCBC5X7hginoCdFkxmxGNgG8W31UNrJn7akkXuS6Dr5F1xFv
         Jpi8e2hKZ7i31WOmrcWulKA3BsaNc7A9fgwB/XjED+bieJrZdgroBFRS61vN5JnrRxtD
         8BIUjJXiWAjR16CbPVg4lG+N9pI5wq+R1xcC8tWnAt0vxLdg35gnlqS1dUvn3cjXrz1X
         0InG3EIxGf1021i744MSNKhYvty0LoRbIuZxYdsBVs9/s4BobqiA3Pns0Qe9+NyyRm33
         6XFg==
X-Forwarded-Encrypted: i=1; AJvYcCUMqiXV0/OzPODSdI251uOrTESgDnn7+0KNd0dhqTU135CHCKAij0ke6BcktzcLqW6+Lzx1q0HcWQ==@kvack.org
X-Gm-Message-State: AOJu0YwqiHGNr3Gc4rGUI+TotcG7WTOUFtvvPpOrVSssAwKGo9ZGKAFD
	JO8EGLPVQh3GIXIqaj17/FyJeAGEZJIVScWjpyg0uSY3WMBCd6RrN7BU
X-Gm-Gg: AZuq6aKWLTDg00VsfxW5Jf9Tp1WQOUJRdNuITSeLKXnPm2UdIt22ENbcd1i8Z8ADgOM
	GETGjo0QnBR5LX0X1m4lDcmVL2aqD1VF/KicAQfJuSjBhOdENBMA7X5A4p9azs7+oMmmcNXrCW5
	4ofB9MJ+76e9vsc6U3mIRpMYBNOfULskYZVPjS/xrhqRvOgS35c5nxr4X+ckHovDKl7pMHb5QNm
	e/QFzb43e6WJMnVtPRsoynjrmkIpFDq5LVTVAuhGEyS1V8mYnh5YTsiUwxHqEK6ONRI2XP48t/a
	vrfABzSaTTp4rDwmNGaFC9A8ykeTUapt9rlOoBR0yItYqQoOCh7F1WxRFyvaBPV+olGo+4vaxNG
	rQliKWJYU5SJHNJtgQd84dY1fbuW4VXj+4Fi4iXrPeEkzFSJvRjkwTjUWiJ9xWb2vnrF7bISDVZ
	d1Kh35yFjbM9QlSAjTGi3jKkp1
X-Received: by 2002:a17:903:2442:b0:2a7:9da7:d21d with SMTP id d9443c01a7336-2a8d9a75759mr89932075ad.56.1769948820242;
        Sun, 01 Feb 2026 04:27:00 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b6e5ac4sm116941185ad.86.2026.02.01.04.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 04:26:59 -0800 (PST)
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
Subject: [PATCH mm-new v6 5/5] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
Date: Sun,  1 Feb 2026 20:25:54 +0800
Message-ID: <20260201122554.1470071-6-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260201122554.1470071-1-vernon2gm@gmail.com>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7368480002
X-Stat-Signature: ndqbjf7nimi7u4ckm5ff6e53k1i7qssj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769948821-863603
X-HE-Meta: U2FsdGVkX193jCYEErpTq4pOtKHfWHpvoQd7JzqDn3gqyEvcqQxtHwnMexn2PvAakGxaHu7oK5KW7xtEvqpIwsYxWug5rO4U0Qy9Xi95bDudYKTG1jlfMkmAUB8M28Uo23e8angqi1XLXbjfMNy9sbLHKzS6TAqTznfFAAJaD8DadYvz4kvNxFZ+8QAJNiWk4J+uQKC2V9YG+9eqRWht7tQQczqSFoBwofqqzsxCNrT3PAO/baH44HHI81F5q8/2hMxJzdFHfUaIfoczSpYKEJTWiMz2e0gMhC9VtMnTPEOqeFoWvKbX0oYOVoNuO5zefdjECTOxvdGwRoILOoajqtrI52GfJiYkswG5v5j3Hk4bHAmhroj9MLECQt2SMpKoEx8TQvbO7yJYrLT+qpVgvC4AB8gRC+kMPfdz3j045l3keBmIvIeNOFNKD70K+CQ1O/bonD4uzl76ci5tcZvCNrksEd2qZrNVJfDykxQLpXXWwxrFCvoY3D2/GE9/dZhEu90yykXYOrTVRyeYr39BGz4vUzwHN6dckmWOMY6sY0ZTEX3xDxTvPCbVDI6btedhJTm9v/3DklkPuVlUWg3jajlkz7HvONi38xyBQm45zihJxUrw7Jrunq97906phJww3kHlulQeIknv16WdxXDJGcU3VujdV/xj+j+GqNTn/kNq54rCvJL73aFtjA0mHnz7qE3J1nq/swUFIow3GRgCJ75nYBIgKsf/T0Nmv0ac6xyWUEhGrdvXROIE5y/9BTCcWHqFkDeW/ZlQMX9c1Zoh+nS+TRn1A43H4PO5bRPK79eTYZv202JV3h4wkDvzPY92m71afaUK7iX7phGybONPJ0O06ygQKzGDHiI5c/dTHCuzJquV6BzQumdjUFP+1hMCZtClQ7msyk9T6rkkjfcqtExTop5y0Tz+AhgnloUuOy628g1BpUL6UONFw/LI25nqS8yOfOAi8hLaAYU7R5K
 oH4lMtu9
 TGCUf2XfrJPvvo6RAVBHT+NywYwOhWHDkHHl0VStHRojuhQjl41B9jiEcVQ1EZMO2aaSY9e/FzYt8avd3WPqZeH5v5t9IIoBlXy0SHRKdYcicxlA7+AnQWqjdQIbIaPSRU8Y7Bx9Or5AGxrIkPhSmt+u9U1lBN2EXwhnbGuk35riafqC2754IOZMMs00mmfXKhtqL9p3WunVhlugUMexf3ZQeDhZOkltCJE296ICr52u8FvsYOG1UC7XxdGk5c1S9fa2k0Vg0hDCiT/FC8NCdk6NWTlkxzPmLWQXZohiJHN185Cgg3bx+itLCcEzjPZCEcUE5D1UG/DFyK4NOU6nRsRYTj83D4icdXW1/0uk/w9kHb+u8GaDUqidKGw1NI+01vynEaJReEORxsPB5uBr6ZvAxFnAIm3Dvv7wDJg10UqK41aEh+LQFxFlv9Tw9m5yratQxvLa0hhT1mz/+0tMx8Cr/+ZLizKsFNj8NwVrc4zAO85udGFHgqhcowFNoD//rxpuR0WglZdw1+v1Q3cMElAhhw94+x8h5wCeJec1+MbIdmSaRB9ba2ZZds/uGjsIghwZaN9uYZxcCm0ozzihnxDsIrw/KelqROyl813lSE/jHp6Of4crFauj3cJEczWa8gbF9/Mn4MihM2mUyu6vmCtgVDOQcm2zanDuC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
reduce redundant operation.

Without this patch, entering khugepaged_scan_mm_slot() next time, we
will set khugepaged_scan.mm_slot to the next mm_slot.

With this patch, we will directly set khugepaged_scan.mm_slot to the
next mm_slot.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b4def001ccd0..94cd064f79a5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2549,9 +2549,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
-	 * if we scanned all vmas of this mm.
+	 * if we scanned all vmas of this mm, or THP got disabled.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
-- 
2.51.0


