Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1FCCCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B328E0013; Thu,  6 Nov 2025 05:49:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442A08E0002; Thu,  6 Nov 2025 05:49:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37ECE8E0013; Thu,  6 Nov 2025 05:49:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 272518E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:49:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C922013B798
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:49:35 +0000 (UTC)
X-FDA: 84079861110.05.32872A2
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1449340003
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:49:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zx1czwTy;
	spf=pass (imf11.hostedemail.com: domain of ankitkhushwaha.linux@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=ankitkhushwaha.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762426174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gEdCoMYcdGEjbdHJV0gJG7pdiA99fRZM/09SLOS+hH8=;
	b=b2Wrr2iO6VUlnjJHOJohQ2HYZBYTBk+DNhM6tFpwIViagjbpM89vlOL/HiV+TxYZyAXd20
	VqPrxFx22p9ZbW3Yt9vetcVFGE6lDDpuONhAvBUidV3J6Je/6BIs4lp6ojIs73/3ev9Aik
	YvZVPycFyZrDPrgLCTsnbKq5PQ4jjCI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zx1czwTy;
	spf=pass (imf11.hostedemail.com: domain of ankitkhushwaha.linux@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=ankitkhushwaha.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762426174; a=rsa-sha256;
	cv=none;
	b=NYLCeTeVlfM/RqQfzdCtOB0cyuWiQ2UIMz5LlkgRNBpclNLy6kI274byf6q1vMCXwMBeYm
	9TGUZjtzmq3rZ2h69KK0/5/z6uGRcn92sa4eITdtTGnJk6iSSfqflLHexINj8Z/4jBxP4A
	ltfSzlPr/+8pltLZIs6RqV9sLJqr4so=
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso842269b3a.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 02:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762426173; x=1763030973; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gEdCoMYcdGEjbdHJV0gJG7pdiA99fRZM/09SLOS+hH8=;
        b=Zx1czwTyIsIS5azzseabSnLufRtq0Q5HzMDWoMw6ZqQURjH8YqZL0z7PPCP5JVxIC9
         Sf21bwmIpt5sieTl/+CYd4hZNWd6GkyxKRy+itwRHw2H0RntstPd2+/E/6Bj9KLtpgaE
         RSXjlW9hjQEV3dY0CQjM12pk/LKjdQkU6gmTwBs6b9KYAiLJvUu0I5dARlLUvnB8JeGz
         f7Dl6iqXOmBdddJi2NCJpss7lTeFp8XTeqa9Ii816IitxEtWblWOzaTCqNz7c94vUyQw
         kHINPmBuJrw2CEVpKnnXGf5hVJwgGPxdc6dcSTPrv9DVNmckvAPEZf3oTe1J1TVkz+vK
         Uymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762426173; x=1763030973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gEdCoMYcdGEjbdHJV0gJG7pdiA99fRZM/09SLOS+hH8=;
        b=UrbP+EqaJYV/wf6BbCn8irEEGMiHhfyLCezupSWsquzhrHnS4Hy9VyPO220zsrceZO
         /ub2TsBFZtdNgakxIB+926G5D64DIfW9zz7fvypjKu2yOtEwMdlD47SwMN5OmF6kdlCA
         YfUqaQodLD66coAeZJur8gQayDp5DR2H7SM6KuLPuvX/uwSy07ThAzSeaOKfowZRsXrB
         JOv15WOK6rCR6DVZvcZGdT5TO2bWACbkPeg6ZCoZWxGvlUlTSYUFN8uAl6/l9kMSprGH
         3guy7i97FwGddAB+tMQnCD14QTVOmnWmnQNcX+YU4j5KJj4F7NgHbQfras73RfotwdhV
         ymYA==
X-Forwarded-Encrypted: i=1; AJvYcCU9zZWJM5+22vMQ5lDzQR0SNfOCWCax2KGFAYFyEN2qAoPztjVvrfG9sikJDEIHWe+fyryB2/E1JQ==@kvack.org
X-Gm-Message-State: AOJu0YxsQiSrelEalHH0iT9uLGrXNmDJniKv2SRXj8hNtxa60ABuASUB
	I4kHwFB/SedUkXMZQOBoBFLEiB7UZyoOG08+XjUegVPNEHaE9XOD4byQ
X-Gm-Gg: ASbGnctyqLUwgVGnQgv1VzXv8X7iS/meCeARPrMRSw/Kph+xeJmGPR9tIgCId7JzZse
	clB6CqGCodGq3TNR75lvHLSEpxtTzugFVNi+pskRb3pVxUUr0Ox9QQeN4pknOKFAEWDyIPK2dDw
	7QswXCc6f5olMTavyj9GJSkuMJbW01nnq9Tv/6oD8XRizDHYlc7fQJY/nX0h0WRlt2nvVwBmj3T
	Ab249t1IZy6kO0jtDWL90ewisNCnYkzIKbZ7PyUHsdWXptOkDzDorpsjbqviNLf0NjPQVVoVLh2
	v15H6xa1SXVilk13cyrtAb4huPrD3RPhud9RnFZDjz4nMfkEUnI7ZtNLcKORgG2vlQ6xVL0blu/
	V0EX78BsXaJkh8PcNY0LBOWtlFASr/gCRdjSOVgVJZQuDK9bD8Y66Pwrk6VICgtojQ5u7uXsuOr
	V/V9w8gZNCdKgZbbLP4L4=
X-Google-Smtp-Source: AGHT+IEtViQepAYL7wHG7yVriIANhlLuj2N596fkhQw4o6rhnkDNFPyu2Q90vL6GWm/MKnzkOWTSPg==
X-Received: by 2002:a05:6a20:918b:b0:347:8414:da90 with SMTP id adf61e73a8af0-34f80c9ebb2mr8516805637.0.1762426172835;
        Thu, 06 Nov 2025 02:49:32 -0800 (PST)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8f8d7eedcsm2148457a12.2.2025.11.06.02.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 02:49:32 -0800 (PST)
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Subject: [PATCH] selftest/mm: fix pointer comparison in mremap_test
Date: Thu,  6 Nov 2025 16:19:17 +0530
Message-ID: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1449340003
X-Stat-Signature: eawjxu1qm3c8bj8nqic411wzadue9bbz
X-Rspam-User: 
X-HE-Tag: 1762426173-390165
X-HE-Meta: U2FsdGVkX1/cOLnWxXVN6mKKNoP7v0GXOGvOt4Z4NvTZHqpvoWiheY+qtm8xEfmlRloD7x/nYFzGcH/xp0hD7ErZD2d5sLN0HxBdX98Gj0iZ2AB4242Azdxd+rJBEuyzvm4wl8G1rIbBy3OFbGbRpwyen/49/Fz/n2M2xEkhSOqL2w9mdkWvPz2sbW+qgMrAoL9jjkO7WWIndRX5yhc9NqFLhSNsl6/fsYtdbznIKsyXrgo1EHJUcVLW4cgLVyk/zGIJV4ZQkSC1MJS6mgttzQiLT8LdIVkk0DhIOg/+do3fDmKDLm/qmYEQNixEhB9Q+nOUAvIwIWpzus7drL61NrppDJq6H91X9zIPbNjqKMgqdoAcMO3at6dgWpkehCZvURSv0BF5ftIOqqsCLWjkTARJcWhLkeJVhjUN7CHrxJkhFP7i5qG0z0rrmzLQllapxn/RZHc1FptM1sBP2rpT7TzBFn+wLOzPEB+Zj0YER6jptnsM/BXlRyqjphAbtCeDiFb1wU2FWYmBxh9tWcNMbORa784NAGGvBJYfhr2o6fPE+zCgV0uR0Oi8PwG2wlZ4uX0h0v5M5bfNy3FFmij7ykyPkyLK2gt+mLwWag3T0DNCf1rCodx6wN5n/nlsmwWg5h1aSqqK729bn8m7jAmzsQS49mGQNuY9rq8944BqeqN2IID32RBsghSdmzdz39Ze35pyLpgep+g44mjjSfsh4CbgZJNULq6/j1sZh13Hu+wfsGQ3fcLrDNxSgI7qfxFo+QDXtfSP+A+f87k92WxmfqMvoPuaRuUyYge6JqbBS9j63W/LVq7bJo5+5IyxCsbQ47uZRAeYTPv1gcj0+sX4WrfhgHuQqzd2zFkGw1MKnV6PIDiupWp8UNpG0O/7CUbyPTPV+SGew9kqaC31YYvaw9aCHp6CbMgOFpnS4FK0JtUnx0/MMElQc6nHDoZN6fYNnibTa/EUidmDWKIQ8PC
 U/IE4NWA
 Mhm085q7yea3MbeGmm0A10yqsFkpJFipzbLzGEIzkwRzOmP1z+pQ5GOG1NyogVCX9BRBed0/NdVs9ulXjqh0N0CsNHLjNoH8AWVWDAI6lsTNT3xpLGKjyvInvlcqkb8LZCopiTFqCWFScOHdqsOV0b+63H26sZTOx4RT7zdrkM3rJv/3rJnXTyfLHZjKtuC7epJcs7HPKq8wZ9/wXI9Xful19xFJUdFAc5AuRu4e9hHFoHy3nViGRA97FDcsn17iCDLgN/ChKbv5B9L4rIEbpsOg5qP3VqDWFG7UzFB/oWVuH2NrvvZkyNda7Z+qX7Q7+O49MrDmhBqmzsaI/mZ7TPB5pL3wz9lSja6FHQ0OvpkyCcErpe87gS+GrvG9vgZ888sGaXkeKgRUV8tRyaEOWqHeExCQF5eEOeRvOT0BsBfeFLJsxQBK5SjYvlKfrD26w8KUD1sV1pszt14UpsKrzCzlpuEaoCcQpnz14KiTPq8lw3CgA0TSfq9xdXckFDEdxInv9YW4NqqmNSc5FjHEaT5P7UtqKryvLIiVLUTwzrghWlF9wdMlFsdh2d80m7vtGXQPqsMcLu183NUDMplgwC3clhWjEsyEgXHgNnlofv9fil67iO6CdFqUVqIUeHsGjuF5s1VqTEA/SIaxR9cvEqbDS0n/WLkFULO3R1o9rpZqUowTMg5IvLZRjqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pointer arthemitic with 'void * addr' and 'unsigned long long dest_alignment'
triggers following warning:

mremap_test.c:1035:31: warning: pointer comparison always evaluates to
false [-Wtautological-compare]
 1035 |                 if (addr + c.dest_alignment < addr) {
      |                                             ^

typecasting 'addr' to 'unsigned long long' to fix pointer comparison.

Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
---
 tools/testing/selftests/mm/mremap_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index a95c0663a011..5ae0400176af 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -1032,7 +1032,7 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 	/* Don't destroy existing mappings unless expected to overlap */
 	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
 		/* Check for unsigned overflow */
-		if (addr + c.dest_alignment < addr) {
+		if ((unsigned long long) addr + c.dest_alignment < (unsigned long long) addr) {
 			ksft_print_msg("Couldn't find a valid region to remap to\n");
 			ret = -1;
 			goto clean_up_src;
--
2.51.0


