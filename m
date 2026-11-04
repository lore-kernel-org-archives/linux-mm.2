Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517C3606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QKHC+3/l
Received: by kanga.kvack.org (Postfix)
	id 3C91F6B05B2; Wed,  4 Nov 2026 13:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A346B05B3; Wed,  4 Nov 2026 13:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2697D6B05B4; Wed,  4 Nov 2026 13:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0055F6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:38:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F192160825
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:38:03 +0000 (UTC)
X-FDA: 85398296046.20.43A8D1A
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id B4DB21C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:38:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="QKHC+3/l";
	spf=pass (imf21.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793817481;
	b=RPUjUUsfq5d09E2HXXprT1peIHS3QbLciPl30Oq76YSFkrn4zjqyJ4ae4m1F0DXAnGj9pG
	EQE+6kp9jkda9CBNJDGOKfP8sHTq4lM2AVGzst7rhBYp4w0YAD4ogUN3fqFothc4hpoIcS
	BHd4LcQKFUUf1jfDEKxZSTY9HedfDKw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="QKHC+3/l";
	spf=pass (imf21.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793817481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Urpo8x211lQPcFBlpfaS0wiedhLBS0U38wxvyjMr8A=;
	b=U+iXt24p/pvLHxb22R+mwiVB7uHpHl5gfMjSKzwgKE4XmWhqLHiPijM6LIP6TNShlrU+Ae
	S+WxoPYMwp2LjJ4Ao0uLFhKvoGwyBlJanbLTU+CYzz9+scySp0Slvl8zOCLRJn8AKoRPEm
	fCwRXAzLLxk+WPl535xrca2EpbmRGFU=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a05effaf8dso672545b3a.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:38:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793817480; cv=none;
        d=google.com; s=arc-20260327;
        b=KMULo08hZAhjysT9f9f4P59RKpD9HW02jvcfK5AHUwrZx4OSOtsraFYg3S0pOM4bXU
         wWr0Cl9gSBJYLhCh8bRzQ56ByksQ44A4hRkn8AjDqctr1xTAdBCZcmvltscj0tLEHIfE
         xp5cTmoHtk7QGn5BfV4rh+RPUQvQnHDdmX87JiFHiurakgfvKTKMvXBwga4eEnSi5Eih
         TaYfn2UjLMbX+GSvBu++QCrVvmj+Nxn0XmAXQ/VXOP+LoSXfDSk8k44v+TgK4OW/cvCJ
         tAoynpCag4B7eb9/C0GLIyRzTMrIp/Z/Tq6BpZ8KsXf1MljacjLiw+Ar9oXa4BATbkf0
         8YgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=6Urpo8x211lQPcFBlpfaS0wiedhLBS0U38wxvyjMr8A=;
        fh=YxaQX7GTjfBsN7A2Jl+A9yP6mmGOQanoqU6QROKhVaA=;
        b=Qcs7rLBqi2HkM9ZJoUcmMVDdxYRJvds2TLzT3TAOsewN6Kfemu3AN/QtNyqjt1Rus8
         58s5h37uR/sLWaBP0hjrSxytwFDgFoBLcuO1KauDJTJMJw6XJClK6KWcqZj37sRb2AOp
         xvg4zuyNjSedl3jwPN64DWjIRDhoccq7qzDVodAqX/50pkZEinQza0PyctTFyKj7eIbl
         haIEN2MYGPnnq0qnkAFXpBoGaePC5ufEFWItlMuRiQPGZEs8s2MDsgg0+PtKKu/LK/b/
         TlRrYc6G3I3GH0qUXe+rqMQ4Tcjma0gkQf98nSgUXvuGL0F2N2y5WbGMrvN97jyFfmK0
         6mPg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817480; x=1794422280; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6Urpo8x211lQPcFBlpfaS0wiedhLBS0U38wxvyjMr8A=;
        b=QKHC+3/ldRDXRQGjMPo8uHypG/5eL9IfOE+4OacPUYh4LVCKfGFX9DdbDCk+M5IJKQ
         fGJlR9TLYo6JkvUjv9eHbDmMGxN2u2SJSBMf+Na9kXCcbSvJ6nTB9N8et3CdkKU52fVQ
         lflmDWxSzO2wzSP3RoC+2a7LoQsC0OAN+Xaa3h1/jgKVAcZYBxDG2ezHA+De6+v/7nBj
         sDEP7MT5vB2iizkfrWJuKau1GBcpX4yyYLvYW0J8DtuAMOKhyQTOL2QOFNBBwTZMMf3T
         G2ER822NTPiLx/aIOWkywmblGcQY1hO3VzYSXxEVxCLMSviDnq8NYO2g1AeGVwmMcTEe
         8L3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817480; x=1794422280;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6Urpo8x211lQPcFBlpfaS0wiedhLBS0U38wxvyjMr8A=;
        b=WXCfhXA3fN3ca2ekfjG+DQrrYgWwZzaQ6ZupamGDsv4500jqI+74pcd35NDb8wU20m
         1IcnYWducWgFJGKV5GdCDPj/SbMwc44Dx16vyGol/tS8rUWtAlMxePdFexGKV+SLXZOa
         WQ3TEB1qJ4KlrVolwiZfE32jrhQQ0U38poVgrJcjLAlDdxxeTqACHfvnrid9YAFx4rUz
         l+q0eNsH2EqJXyNcvMWqiv3ZTzbuiM0D8ZahDctFesfD7w2reTmpLVZdG5sf9Gs4Cfrt
         dEEC+Q2IJQg0mxFPtlTjondIIRne8tmGVJj/h9drdDCHrWaSeFvTriAUb3AymH3M3a9x
         Nizg==
X-Gm-Message-State: APuU4Z/Yxmf2djyJolFEaV23c8HrGtEt0KahT2jXHe89r2Hr9Uws5FQR
	211YSMFxY1kTLTjOEBOewvHZ+hd+jEVZ/a9QKDduQXf8Kf2M9c/wVTO8aW81G30F9nBFJMlaZIM
	CxHpOXqcg3qx7cnSLvZuAQ3RVZLQrZApLSAsJ
X-Gm-Gg: AYBFou2U2WEMiSK1euG5L6gIf7NrkQ0RYrPiM6bJxqsGL8QbjCJmroFtlHX4GDARYjW
	SAJAB+J4qOk9Ie+M8CZrT3f1Xlns/wg4EDPZwcSwcl5yDdb9fItDzaut4OSw7RCZ2ZwXWgw1DH9
	JNfjpe4tu/0xPf8oy8T5GZ679dmyAByuGeA1KRbK+HMoRNuKilDf41S/ilzhxyaeC5qsR6GvIzk
	7xT5p2EixKzp8BOT/ZrS4XdfamAdKzlff6wSqyI207gk8E1M4Sr+8EyXy6GLAR4KbyK203BPhl0
	pvXmOqVKF1MUdLRjyh06dRXvnDcJbQELTqj2HWRH2Pt87i/C/HaQCuLoCKy+UBUNC2Wj7qBq1dg
	5ct1ln4RK7EarlfEk9jUBD+UxNB/5TkGFtv29a6tg81YT1ekLaQVXm5HHmzzV+0nUUuVP9m8Zfb
	xl3TiOi/lUQFZAdA==
X-Received: by 2002:a05:6a20:2d10:b0:3dd:a197:ede6 with SMTP id
 adf61e73a8af0-3e928dad9acmr15255522637.53.1793817480466; Wed, 04 Nov 2026
 10:38:00 -0800 (PST)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 18:38:00 +0000
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 18:38:00 +0000
From: 2-D Godoy <2dgodoy01227@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 4 Nov 2026 18:38:00 +0000
X-Gm-Features: AclHuK9foKZNERROdd0nEAjbsS6qJdBe7wzaP1YtkufcB5bE_vW3shs-pG7olUQ
Message-ID: <CAL1HEBD2mF4YygMQx1U9m74uyfBGbffdF3-mJ_WNPwQCnBGpgw@mail.gmail.com>
Subject: [PATCH 1/3] tools/mm: terminate the record buffer before matching the timestamp
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B4DB21C0004
X-Stat-Signature: 3bpqbid4eeaef69rqqbedsopoau868wo
X-Rspam-User: 
X-HE-Tag: 1793817481-497626
X-HE-Meta: U2FsdGVkX1+K+/cfztbnN/AmxISSMEMjZFge/3V2CYH1k+hndoA1yckj9OXc3WIHMnKtNnWx8o3wL7dH/TcnM674daysSucpvACTEY1YinzFkw88v5ydZhfdv7oEVkm7ayfMaI/Qc6eQLzrhPIBcBe54v0ClQ0Owwl084eNGS6d3PtXD9Lrxmzv/v02oNEaRhbOjEs7MhqkmNYrdBdyPzgmBzY+u5JrnaUpHDHsGoNLxPggrzICBFSuOebmDHI9HWwAs2S12EDqhFyol+ujFpTzjkzEGUSSMS7V3Z1jKSMzFgohC6Q1jqXME14xTZFKWPG1RxDM2qKQEhMnmPXCj0imitk9g/pgxWfggJZWLkGtbTpRkhb8uO7rtePd34pgiZsdV3jlOVjaOPF0lfX09um+LCQpK4SKp6DaNMxu40RkK8/aVUGwheNnrC0fX35VjTimCyoGHHizKcmg5MysVbqFXgQQ15JG1l/J93eWI74vbz2al5rqVs5/9+sUMEUJjxSEDTf3LmFbSi29k+mm4/O6H7aid91HEt71+LxCYEOj1kvTeTusjcBzazzR7C1ilJRz/6xAurkdxLzVFdSB/jF5ZV52Pyo4OM8bCS5NYkSV1tF+0RLST3F+gsWgdomHVpixt0+aUJXSwzc2T3T6Nec2bFikyDzECroaPOjnODGa431DMYB1h8zyrhw/FAbeKMBLcUuhaGeODiYtJEXq9dOY8GTAM3irMuOg05F65Zoo+4T2VOiry2SXm7RgPhyNKiKC3+sUDIQyC5AGe7zzCEzpgYr962OVDAfrs9yoYDfunHh9Nl+5rUQKoanvkqyrZtS/u+Qr5mKPFF01UKYh42acgTkZcNMQarWL1qhd9PIOGqet3FAh438SrUUHTlWnQnbDYjRJxyZlfOxsNGfZ9dmDDua/l7vXP9bGkZW7NBPppCgnnZOT/9gGHhTCcjQ3s2lpI9EDhmPiBAm8eA2g
 +b2+GyH0
 ZMD05IzpNL+eOoD2z0bUsaftCFl6nnloV5t6wXcQB/ZknaVvixrSr/Q2/5z0NNpbl9cDZlpz2i9bAj/rhP8+fAXrHXHVBzMCCGItKzEKLqHiu40JvTs3S9bQW/euBrOfW4+ouud+BUgALflH1xoHUlmSXa8+qxug8FZpwo/IcPn8tWF03e2K7JzzTf1nRLFu6ptesqo2cFS290C+bYYvVwzny8q1gclipaCwj8xGU9sOhiE23xW2bG2bo/xOy8fbjLXcR6ROAVkCTOvz3HF3cbAwZPLFoGf+5/SjqGqCqm+uydgwSS+KJYYgiO/xipNLVzxsGtZwzJzQkRLui9tJb60/TyEb2YLAkTOvFCpAn+pc8QXbFiAlvZ5j93ryhnpNu74tBYKqUCEgZ6nDPme/UL+dt7WgdEUjc/BxeCyNf3E7AcngoPinU4iojNIIufdQSJ2skK1FnUrN8DY7QDFzmTeHBiasL8vOA/ASyp32IQVmfzms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

add_list() copies the record into a heap buffer of len + 1 bytes and then
calls remove_pattern() on that copy, which runs regexec() over it.  The
terminator is only written after the pattern is removed, so regexec()
walks past the end of the allocation whenever the byte just past the copy
is not zero.

Sorting any page_owner dump is enough to hit it:

  =================================================================
  ERROR: AddressSanitizer: heap-buffer-overflow
  READ of size 163 at 0x60f0000002c2 thread T0
      #0 __interceptor_regexec
      #1 remove_pattern tools/mm/page_owner_sort.c:248
      #2 add_list tools/mm/page_owner_sort.c:593

Terminate the copy right after memcpy() and keep the terminator after the
pattern was removed.

Signed-off-by: Henrique Godoy <henrique.godoy@cloudwalk.io>
---
 tools/mm/page_owner_sort.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 6c2ac5d..58d4a54 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -589,6 +589,7 @@ static bool add_list(char *buf, int len, char *ext_buf)
 		return false;
 	}
 	memcpy(list[list_size].txt, buf, len);
+	list[list_size].txt[len] = 0;
 	if (sc.cmps[0] != compare_ts) {
 		len = remove_pattern(&ts_nsec_pattern, list[list_size].txt, len);
 	}
-- 
2.39.5

