Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F4B9C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF9F6B0279; Tue, 18 Aug 2026 09:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0EA6B0460; Tue, 18 Aug 2026 09:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3900B6B048B; Tue, 18 Aug 2026 09:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 122AE6B0279
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:34:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A95191601A3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:34:15 +0000 (UTC)
X-FDA: 85114484070.27.01A9DE6
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id F2DD01A0005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:34:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dt8xX4YQ;
	spf=pass (imf19.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787060054;
	b=tNd85Jr7pTDhZDN9/2byx0dPFv470heXYyzUSLW9pkCoMwiD7QHKMR6qQ1rxBASbtZZezK
	YTBHmq/yC01aMGq2lMCDyZCwk3VA50OaXeUaJLOHgVD6p+TKw6hJwy+7fh/qBRPLl4j8Pz
	09bGcC94tfnBiUpQla4EVav2Yz4N1tg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dt8xX4YQ;
	spf=pass (imf19.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787060054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uDJI06X+swFMyKE3VwabpX0LpGG6OnS2z+jrHL8keO0=;
	b=1RoUT0QfbXhktE3ir78Uz+BkHINl8d2Y5stC8nes1ip6ieAP0Q5MAsEUshR2Y7Xu6Eqaf5
	AwEeDRHwrRx+N6kyWD8ULauCS/R0c/E+mFyMMlVIskYkCs/ZF1T3on7FfOoU++prczz5QH
	2mwVe05ELTdNH1QO15pN6dNcgK62iPY=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cee9b74ee1so34458815ad.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787060053; x=1787664853; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uDJI06X+swFMyKE3VwabpX0LpGG6OnS2z+jrHL8keO0=;
        b=dt8xX4YQpoo8/H1KdYue2FBlEz5kymjI+deygpR92n9LRtYjlrmJb4L+RBI9HMOJz6
         MNqqcGk8g3QXiA0xxjFh46pInmE02vFeuIMdPHIR94540FyMdMmieWUEJe2Y2WQnR0YS
         6peoDL07/DH3N4Xvlrw6ZqzgltvAmqh37kTmgMSp5xfF2MI3ZfxXgFT4qIOcnAhoZrMV
         psZXoMYolf/AkjZY/Jcjf0w5pYWkQ0Q+M8m/MjPYPr3UEUhdiv6LhO1Dt3/cbkQR30cA
         nEfJVBy4cURQOIWUeSk/LZ81+LqgfDtT9DC4lwA2nrOEu/zfUxf77wsxyUl0PiY2y8pV
         6QBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787060053; x=1787664853;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uDJI06X+swFMyKE3VwabpX0LpGG6OnS2z+jrHL8keO0=;
        b=qUpO3vv5K36TXCpXCng+e9j4Hein6TGNwyah/OwuGiN9r8zcrOT+fP25xGLHW4Fz3R
         SICXzmQVqMEYQNPIkYlL642oW0vZ0sT0Nc9jNZws3bCBhIIz/rFxKE5DTgyvffV+FMgf
         rMGbdzQtFlFmDfqY3gCp71gtnBQSWaAZ3JvfnwmYrmMap27syKi8AxW2ZNhM0UY2fDLt
         A0hKTYjn/KP+tUFTDuvOxf7RqQyF7CD5uIn9xCcIOrUfDWOFVAi7TVA9/Tq29+VexavE
         ETXyjzmfD32/ptE8ZkDWJP7aMzO70BQpu9aqeMxdYJ6b33xVQotd+5NfAd01OXV+LaVy
         eCZw==
X-Forwarded-Encrypted: i=1; AHgh+Rp03Uf8bNpe/q2gYDaEDmRwwJI1HyPz3CyHTSBkVcNLCdEEcH+QeyAZKF8sWa9/oF2ePjIww33FxA==@kvack.org
X-Gm-Message-State: AOJu0YzB6qTpS/WQt6kgrjdmeMfr3MsGrUdnz7Aw70hNsURG9WdLi0Jr
	I386WJXKaygmTx9uZpTD1FTIQIZPLi/Kzy4J7JPkRRzslqC9xBKFMYrayEddkX0PYaQ=
X-Gm-Gg: AR+sD12Q8WthhmKAn114YHMFA5tUCRnIdlfI7KqRhQs+Agl8LOJG6ewxum6k9QD3Cmd
	Qs69dGESnfbUsBYyrFZjpFsTnhm64+qJ+1lAtY8a2UWyB51pEmuyj6zLfAJnHKZrZ+LRg/beRQ2
	Z8/LVn1p1ZoY0ts6/GIn65RfnKduU14PVzxXsZVNAZmwLN7/rtfcjTQa5tGcGzkAumrNOSk1uwQ
	92Fy/38qPlKw0jif93S56Dnr+O89p/qCj5umC3ZGzcOPy/Z1EOLEG6vsJykVe9fAMvOaBoiABbR
	ewahz3L5ME0M+KmUgmbbV75Rdc1tZiK8OEnRWuAtm8KBsCPj27xs0untjm2pSU9NDK0dFUd39LG
	Cy7CT0QgdLykgKr3cYXqhv8kmbTNUwjmSFt+iK80LuAmu49FNdqHM85uYAXYLyIRmOTGmPck7vk
	RNsOORb3J8TC5steg3K5DEUlquyfPhCUq7K2wlW6jaeeq2u/lA5bz65JgnuelYMO0PiA==
X-Received: by 2002:a17:903:984:b0:2cf:47c4:3d1a with SMTP id d9443c01a7336-2d3b0cdb21amr413664155ad.3.1787060052742;
        Tue, 18 Aug 2026 06:34:12 -0700 (PDT)
Received: from Anshuman ([123.63.59.156])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-326793ca665sm19202557eec.8.2026.08.18.06.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 06:34:12 -0700 (PDT)
From: Anshuman <anshumantewari123@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Anshuman <anshumantewari123@gmail.com>
Subject: [PATCH] selftests/mm: fix unchecked ftruncate return value in soft-dirty test
Date: Tue, 18 Aug 2026 19:02:06 +0530
Message-ID: <20260818133206.39503-1-anshumantewari123@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F2DD01A0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xu7quq84h8ttx3x9x4w8aq8c4xb4yuks
X-HE-Tag: 1787060053-728292
X-HE-Meta: U2FsdGVkX18xxUOt1+4gW7FqJbszVbivORgsXsIeOa6eiYt3x176Ay7DgvIyQoqG4bsWeOCLctDO+MVuX7QAPu7Vu+w72N357WiaFC/7zGQDtDbeEb3sdFazAQPxpRSjgtteR4thqalxbPkZh4nsyZm3Ov8OVLQG2Q4618DZqXIrB4KI9IeWIJqT6iuZ67gwMH7PUuze/VzKlsUcasKvoTDoNvxfCOqya5piQYcNKsUPYVBu34EqUY9P4b1PDGgiTY3QuEcPXcMFGcZhmxmDabjBgkFdnMrFGiDG+xfqMxFyySiUInvFwFcVY16u3ccLdzKQzX+4lp8NyJw/+cN7CUFVLCX76i5vfbhOUNYBD7j9La98EX4dUNgywk/JGEif/5rnpz/YL/OgXJkct9DGtMrvt7dnCo17UVz2M1Vf4wJTCBodMnoMhfvcLXofCPGzjmqd4wnsPOXqpPzZUQiX6tnT2sFOEyRqCSy/DkoXWMtyDwIasgHJdtQKEibhl4XHgnp1o7mLkyhQecIO3Twhv3Knvm2afMIbpv3Ucprka8d7VlLI1LYzi5yv3hMRGsWzKIzRu5jZnpfYAzPa3f/LJJmJWK7xuwOhiqpFNO5NHX0lrwtZHdlGUj2lfDtn+9luBrus7YWmpfHCO/k4WCVhy2fFSGJ38Y+wcmvCjXArqDLLaSCYU81zCb4DvPhIdB8GBJ0D2S9XGupctafcc2TarBzMai/WYRcxG6CADHcssBeHSmTU/AUVQGTpKcAp+oTIS/KaKQe3nGXjWoBf/iD/i4e/NjY/NlXizs88zi3cZIpfLMp17703LCOX5QDRq9c5A89YLDa7lfNueduQ0MWUd8D+UpIOf9NFj2GWzLedjWJFGP0CoZ2FYpdE18Q7dBvVHLr+/PUnb7SACR8r2Owue4NiKOtD6KqA6mWiOkfAlMBovGCuBTr8RA2P+pg17KIQsuyBuqwm6L29UFh0U6y
 4OV1nR3k
 /gPUxan7LMQDLPPC818yzkbHq9lm7b0f4KKpW2eEFDnmWeAtwdwX0mK+StTcwFikwpG4kOfNgERC6tVEHZuPw8lU++xlZ6EW2w8lif36Ugc1pA26Fwyn6Cn4bBbmGSEDcnsRMPbh1107TkGVKA/mvvsXPiNX9BGmns7NjijTGhd1/ybg2osqe/l4rJp0hgnw9UuH7Hk+Doj5oS0o+g580jDrEyALKSiPeg3p3ZIwTFdhtPJeV2jkoJyOhJf+eVT3/Jnxk/SR/AvVVfkt/rTFYHg/BoHriBseLopC0kgZUuB7FSLo7Yj5pVANpdgdfbX6uVywxv3s5kPXFYDbJOo4wGVY+x66a2YEvj4HupMflSzTLClHVChj5V+zS+hHVoGIxwkyivoWyYRXPGZlXg5TOXmbPpjoEW/S4v+3OIDPAVxlEBXZStbM+m8rbRbf4o1oRuqUV3Jj39CiLoRCJuZ+uxR1Y6uX56+7NH0LPN5m9VcipODUqMuX3wPZNY+GKVlQuKmGqTIJqlW9y/H9qKRzXLvzsQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_mprotect() calls ftruncate() to resize the backing file
before mmap()'ing it, but never checks the return value. If
ftruncate() fails, the file may remain shorter than the requested
mapping size. The subsequent mmap() with MAP_SHARED can still
succeed in this case, but the very next line writes directly into
the mapped memory (*map = 1), which can trigger SIGBUS if the
mapping extends beyond the actual file size.

Check the return value and fail cleanly with ksft_exit_fail_msg() if
ftruncate() fails, matching the error-handling style already used
for the mmap() call immediately below it.

Signed-off-by: Anshuman <anshumantewari123@gmail.com>
---
 tools/testing/selftests/mm/soft-dirty.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index fb1864a68..a52ef79dd 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -152,7 +152,8 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
 			return;
 		}
 		unlink(fname);
-		ftruncate(test_fd, pagesize);
+		if (ftruncate(test_fd, pagesize) != 0)
+			ksft_exit_fail_msg("ftruncate failed\n");
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_SHARED, test_fd, 0);
 		if (map == MAP_FAILED)
-- 
2.55.0


