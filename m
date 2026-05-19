Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC4FECD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF0FF6B009D; Tue, 19 May 2026 11:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9396B009E; Tue, 19 May 2026 11:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968AB6B009F; Tue, 19 May 2026 11:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 848CE6B009D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38103A056B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:26 +0000 (UTC)
X-FDA: 84784525812.30.B8D14F3
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 52CA1A000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S8D9pYY9;
	spf=pass (imf15.hostedemail.com: domain of 3Pn8MaggKCMUl2om+rt4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Pn8MaggKCMUl2om+rt4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BqpbKAWZ7q/0CP68ZcgDWV1seLRY3kHiP/caX3fZn0=;
	b=gPReqoauovFS6Qs7g8t2N32lHIf/zbTDY7S/uTT61ZhQeVY+xmciQ5MHo8XtaegzGljGBJ
	pTCiS5rOAliVJvatS7Ag/3L2g5j5nCpq0lmvE+IxZUPwdNaggprxv3XKPHAPiyJAZnBYMZ
	0mBRgltI3wEEVjGY3Qauau3PyGP+m2o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S8D9pYY9;
	spf=pass (imf15.hostedemail.com: domain of 3Pn8MaggKCMUl2om+rt4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Pn8MaggKCMUl2om+rt4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203904; a=rsa-sha256;
	cv=none;
	b=4hwtl83I/QoqvAxJIeGtTOYtUBpGXiQ26rEC/fb28YlxYIBInvVhqaZvyAhuS7y2Zb+s/Y
	XCh3FPqprQjrhW0WU1ZcecVRTGotIU8pVKAu0YrfndKPBVbaWXdGcVx6hMfhI9k3fopX5W
	bBw1urJVx2nAOkh6fIUaYgfBS7y2O0Q=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fe40b61a3so27396715e9.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203903; x=1779808703; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1BqpbKAWZ7q/0CP68ZcgDWV1seLRY3kHiP/caX3fZn0=;
        b=S8D9pYY9hxVOyOMPPfD0VIKy3s9nrUgLLBabOdS+cPSxJIty/7PHxXCZfVwVeGpQ+d
         3IIRFNlVOPeLfe8X7heikAsEUqENHZ4CmNZ5Uh7Q8KeYba29/fyLJ5b3vdOKqxfGCLlg
         ASVgIVKWw0l5gQqM5vqPK2zX7kAvmG0WEtpJZWFEMRGG5Qax13ZzOeNNS9x/zE0ikXIa
         PANpbRZPFjkqdTp2c6xK4cFeNA745DqIdxKzQvZq5DWuJK3ZYqrbj4uGnCHDS52LRJlx
         Ftgfc/Hm2D0g4Fx/zvvJRkDXUtyeNYu/iKXdJHgyV6BPgWXM36aQNkENWHfQLH2eXqjy
         z2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203903; x=1779808703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1BqpbKAWZ7q/0CP68ZcgDWV1seLRY3kHiP/caX3fZn0=;
        b=CCUCjST1+sCWbp7bOdJTkEG42O7ovl8i3OJwEH0t5AkV6isyhNi/N/peZnRzHqq0Sm
         LENAjMrm4dxOvOKmBbv2/8SzwMizpByNMGmXbnmwdfccFw83Oa+QGeB+J13eXqtxo3oa
         KquSy4tLrMVhyDazvtD3iVgHhg34UbSoQ4Q/Gwj4Eq3u7duaUGNpjpwYipXXrUUjuQr4
         dX4wXf3Y0duqc0AQGzsnU+De4azF8QRFSf95uNOUck4Up4UYqYlhClCSSjMv9FR2lN/A
         DikpnyncS4RbdSNUnA2wqZ8Nz9qEPTgJsJI90T2zoeFs2Dn5ki3YGHIRKfcohJ1YDcbz
         wUyg==
X-Forwarded-Encrypted: i=1; AFNElJ8QTcDpT9pXez/Hzg1LvfoJ3AXUvXWOpnsa9M2iUqI4/1cPLpdDGNuVWZFxx/dmrm+qbtassRcfVA==@kvack.org
X-Gm-Message-State: AOJu0Yx6AupgPvIliE36AA4WjtnF0KUqK4WCtet/X1dVPYEu1lXd//b1
	/JMKf9Hc8kK/Jn3L2x4unLulNGkvy6rcpwS8YTbQJmLRUgTeDg4AEkn7hKAWIjKjD/lJoUOQLw=
	=
X-Received: from wmlz4.prod.google.com ([2002:a05:600c:2204:b0:48f:f301:5115])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:34c7:b0:48a:54fd:54ea
 with SMTP id 5b1f17b1804b1-48fe60ecd93mr316640905e9.12.1779203902737; Tue, 19
 May 2026 08:18:22 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:22 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1021; i=ardb@kernel.org;
 h=from:subject; bh=Ku3pRDk9G9j/NzX3V+jyzDs6V1KXE9BKuYBtWjFzJCA=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7uSdmn8Xi1/JLnzWebNMa9qxsDn1W/8/E5t3/2356
 9nLJq5821HKwiDGxSArpsgiMPvvu52nJ0rVOs+ShZnDygQyhIGLUwAm0jeVkeF+J9sCHsZM9s+P
 1wYpNRk982/e72CvdncSS6EzizDTPX2G/yXHhFfdUP9v++DE/9cvj37ZIBhl2cD+iFf1/KEVwWU yrUwA
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-20-ardb+git@google.com>
Subject: [PATCH v5 05/13] arm64: mm: Remove bogus stop condition from
 map_mem() loop
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fdud9tzezpand1bf736qguxzbeisbhrq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 52CA1A000A
X-Rspam-User: 
X-HE-Tag: 1779203904-615932
X-HE-Meta: U2FsdGVkX1+CUHNad48vMauolpF8tWs1DxjtQjTXyfKaan+HUe2u8Rt9d7Gr9N7rbe9Pz5NzHE5Qa8BSnr2pm/WL7QLkYCqkXUIImBT7qYh4bl2k3Wy1jFY/yQX/OPMG8+n1DdfqPREF0/Wq8oBK8AnlY2pS6lokE1w80uFGvHPlrOaJT1qYGmJEe/Z7+sxpdl3okhOpuZ4LX+7TUndxlHtpkfNuZWaB0vzt4YTVzed8+b9EEboGzjBj5gbdhKOMhBlKdBrAgNEIQgt6uF/56bW4nZ7uWADl3QABWNoEoRHg2q55udrAzvpVu5nt6ZgkEo+Muw3LqiSf4sj5bXGwoBTGvPFSxNWHOc7hGoccOt7dYS0HmaavM1ZgB6XgYayObjUt1S14vv5dPsPs8Uo0UKRi34O5KcBcwJynSg+qK/hUEvHhdrBnDpZs9ur9ABsjaW/mszDCGaGCSSwPtZ8ZiDiscVyW1AhppTrdk80D2ojCQFMI/n9+OottmK9GWSVy+PXLF5ws4VmHRy/nZo2QEZlb2yT5LbdKluNugZoKGs2tAN7o22pcF2V7zkpma5bEF9TO1xsM5ec5WoExnBihQPfsdcYzzJ859oBolhzaUABNvwRsmkvzvN48qP6khLP6svw5ctcTpBuVuy74Z+zvaa2jccdIvM5kFUse5JwAljlAjQmiBsxCEkdeGBiVM2UH0kgCraV35oOLLjERq5zh19biyabOc3PJM7H3aKkw2M3ssuyaI6kaqEMLmLFahebAMnmK8Bbk5rTauii7eccf1Qypune5PTE/qVOTxPSiFU4z9FNOQLbRXkh/8is+AIdS1Tbc4x2p5WlbEPNEypZQSoLtP8B7oup/7yySj/6vylOfnFnmWT+u/ep4X0vOqlwT+NxFre73XQK22Hdghp+pqR+F9VtPIlI2N6piAwxyOOYadaDtdR0nNZGrqQ5UBb3TQDL510I2CPTxkLMduKo
 5ug5VnTv
 OvMeXG8Ll96hS5E+BaeEbthezgr1JYioG9BUYW2kopEp0HmCROQNWfnhmseY+XEMaYSamVzoLjXtFfEK8n75h4vHPkCYBAKf+7EDWpzup1Vgm7e8tLVNzvTNHhpZgQnFlDaRDndCjunjGNl8t4wKTw11A98uzhT1uj6x7QyhdryalzkdW8ZusmjZQPz1G7NZ8bbT44tMoZKrznKI4R2TS4NrPqJmALa0wUiLIW3Whx+0s0zZ3Ka1ayItwFaZrh8AyWvgd/8Y9zjpQBGMT94/7JI5j54QeuTzyG4MgeyKBkgLZBBSVeiyxJNvvVJ1sxs398zpwQUPmdI2E3/kYVshVkCS7H1u8J53kRLQUYo5X+Cz+V1OU7ZSJNVJ1g5ah2/WQsr6a2niEutrBiNNQrXc8ufoJqJNtd5bIXaNW76vCeg66qHok1b1SxALLYQqNPAlPPKBQjsNlKCj3LEm6k/OjMbGMyipvv0tQPYEaMoRntP7l02hR3gP4EwCqY+sW/VUhyS+fVyJcUswsuRJCw/F/9sMFcsjAy5MiwIwc+vpVlqAIWxyotvAElaqt/tlF15fZmfvnZ88jEiZOOoYvUrjRP0tjhH8I/UxmX1vXaPognCaaPbHLbxA6wA+pSQih+ASccg+uqoa8h4XCfS9RtLM7rTgv/wVH1Ui7xiejIwGAfoG39r8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The memblock API guarantees that start is not greater than or equal to
end, so there is no need to test it. And if it were, it is doubtful that
breaking out of the loop would be a reasonable course of action here
(rather than attempting to map the remaining regions)

So let's drop this check.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 4c6ef0d35714..cd841a392b44 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1177,8 +1177,6 @@ static void __init map_mem(pgd_t *pgdp)
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
-		if (start >= end)
-			break;
 		/*
 		 * The linear map must allow allocation tags reading/writing
 		 * if MTE is present. Otherwise, it has the same attributes as
-- 
2.54.0.563.g4f69b47b94-goog


