Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7082C5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 03:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1886B0095; Tue, 18 Aug 2026 23:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71066B009B; Tue, 18 Aug 2026 23:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987216B0099; Tue, 18 Aug 2026 23:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73C2E6B008C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:08:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02A15403F4
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:08:30 +0000 (UTC)
X-FDA: 85116536022.11.A67678C
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4D7DE80002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:08:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fkhkitnF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787108909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rXzKtO8OrurlIHWuszvLdX1cu4RIAlIwbm6k6jmZ/EA=;
	b=24vnL8VtYCg69/MXURYiSvFPJs9NK1eQZFvEvkP3mcBpglll/eRSApYR/7vMrxWoH4QFPw
	6XRq/yyMduluCwR5+3kBfdTHGO+E6lHB+1IVK7Hz3gMryrcGwn5Z2Sxsaqp2ZKzoDhRGMN
	rygW8RMTCKmnv384XHpmbiP+LpXiO3o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fkhkitnF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787108909;
	b=8DV6kwtBuWC2Roz3ltjeFOe2unW5cJzeCf3xEMmLp1Vz9RLRIaBrO5nWNl9RW8gxSQzO0L
	2iFTUmJtQyfq6EknBTtVuUXTwHW2pQtE3y/AMxo7oC5HHqV9ON48Rmj4B/fdygXc2GpWlF
	vf+4igZNq3tT0+hQVnw66NJQWcccKgU=
Received: by mail-pj2-f10.google.com with SMTP id d9443c01a7336-2cf5e516e67so2424325ad.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 20:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787108908; x=1787713708; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:date:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rXzKtO8OrurlIHWuszvLdX1cu4RIAlIwbm6k6jmZ/EA=;
        b=fkhkitnFXKGmfSoX2wrWaVcIUge0GXH5FOVfPbSVEMrhgfB0FMe1w3cJcmpMDa2pgb
         rsRP40jWmJPr4lcd1PrAPndP46KK7Cn0lIRmO/ZDgD/OiHfrvz1s+5TTccl46Emot6La
         4Urm80wnd3AoF9ZE+kdeAexL8hArOww8UCpOuNzvtyGMws4yT8qpTz3T6Z7M7fPSmgL0
         g0jSFQB1iA0zIZdxjQi9yrBJRE7pwbyFXvq0PcOr39/k/5hzR2Cr9Rd+LGHCdDNymdAD
         /qk2A8s5rgQ6EmQzLYl4XLM2lbFjWBpCVhvErPpqQkHipIE7qvr2YXvR5JDM3lYNp1Hf
         9tZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787108908; x=1787713708;
        h=content-type:mime-version:message-id:subject:cc:to:date:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rXzKtO8OrurlIHWuszvLdX1cu4RIAlIwbm6k6jmZ/EA=;
        b=saSZfaBCWLTgNmMd+J3Urd7EsD1VLHIzAmaSDiAguZWw4cLcLCjFswByITdW32ygZG
         tHSz4U9tEIo6DiJoatYJX7duetyNBqwcO96PzuNsTX16LcyPL9hfQhSFlEBIKTOul8DB
         qUBdh731payX/JwK2AqfMHeaLyjncuIOQo244wcbrTSHCfxLpvSGtGbl+dfXST0GZLEz
         onMykBvsQrl0dybCNufu25GkqRi1lHl66DAvIG4iwniPpwWHjRbyrotbTLC/4ehWO8VE
         GkFTf+FHdDWI29H5HaYjv+WgAStUbiVZhJ9Vuz/EJdSFAu2pUsvHLzp4g09CDtN+Ud5L
         wvXQ==
X-Gm-Message-State: AOJu0YwWUfZMUQ2wN4pacCEkmr7kUiZxNNI1Aw/sMiJIjiYxwOWlP/Za
	Y1HsBntr8MWz2kqKo+IT8KEhl3JmvKMeCFvDfkn+jWlq9W63sPr7HSo7
X-Gm-Gg: AR+sD10Pr+R36qqwomuqlh7sp0B8A6hWLOEmbuofWmMa8vf+HUfUlLGi6OrXcpM13c9
	CvNDvrPR6KZStsv065M7LnpQcu0yAJZpnr6mjZoUNHZ0jGdwkLp0swm/iYASuUB6suaGSSCNbbt
	GTRA5t7N0aPuco8xNUdMoCG7K2vnJqj+TPuo8GK/2laqEWCPwwmsEv0i1JKIyrOXEyfsk/lpGHy
	SX4U0duIbcJ2eM/5U59ts8tsEGUSsO1gMqGpO7/xAiqhlrSyq2l2Y2Bf7BBVYvPvKt+557kZ+h9
	XCMouhGux9ZdNkz6j9pS0HvIrSeRLlvNSouG/ix3NqpJvcOARHUh/POH0xED/Jdq/QGv9Vao1mW
	xMbAyOxt3RusxtQG5lbmC5U18RJBEkt23IurdTswaBrqPHeW3AwrXnOwmAUFEQHjr9TGZ4WmYZ+
	47aRGvTrSdS0jJ+DQCOgrMWp+lbsRzpBRAUjzkAkDq4uZHZ0Ko5ORwo0Gq
X-Received: by 2002:a05:6a20:2d13:b0:3b2:a809:1000 with SMTP id adf61e73a8af0-3cd014aacfemr3505581637.3.1787108908068;
        Tue, 18 Aug 2026 20:08:28 -0700 (PDT)
Received: from 192.168.1.6 ([140.213.202.182])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327c2a92406sm127304eec.11.2026.08.18.20.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 20:08:27 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Wed, 19 Aug 2026 10:08:24 +0700 (WIB)
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
    Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
Message-ID: <e1e0b5f8-c3c6-0537-670b-4397f822f980@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D7DE80002
X-Rspamd-Server: rspam07
X-Stat-Signature: 9g5nj3kiahjunks8rhrddpdqes4izxs5
X-HE-Tag: 1787108909-633400
X-HE-Meta: U2FsdGVkX1+xKBqsQ/GsT1nzn3RgTwnA8R95pZB8VIUEwwXeP5O1gQaLPOHC8Ygb2g5wINRYmHEKnZs7b9HvVUm8xQIM6goBT9ixg+Aa45sJMTsbHfJ2WXKnvb6LTE3EhvmapkTDCOnmzfs3McKtF2+jQPXwAoJZ1chFfUELkhVA5M1KiplKh/Uhqsz9UbCwJZW57q0TdtjvIJ3gxnw3okzkyDcXzairkr/OeTlnlSB1ipMtawUkeirtjYN98tPuqwCVjY9/xFNPg4sPm8Elk00eiGDejDkCZiNz3VIuhb82qf2jlRH+s5nRhbqv9rRq1m4GbrmrAoy269keb0aK3othxZF5j+qCOOnNHLk+ybvI5TuHT+9Gj875Rw9peKrt/zitmBp3ccH8C0i0er23gwd2KRwPlDNPihnbFoCamKO9tFLNtJ/ifZRJxO8KFyZnsOuNWZC3nijSyp8ilGLV8ZEcCZpDqM4yb/RFAMzlit1NfA5FzxBt36yW8qpLqDhhK1yQXD94uM6e3glngECSBOV3sI+MkU5aX3L0vTbugdJiGZMKGrwvE/UgxwT3oZR8lPvDSFuA3aWfgzvRhyV65E0J53sE4CqMqRKpoRhetqOHm6lZQfebVFvhHNy1FkFIUskWdVkbtjRe0Dv/zM3f3s1Cl1NnW/wHcNrCv0x9n/8iRalDp25PjVV+yFYyrUJFl4XaiyVKOKWDEp6w9sQRLORgwCXZZuRd5YAZXi1Ga1T3eAosC/z7DpvbuIuLcq0xU2pHCguzNbvR7V+8xAJcbG7F96TlbDln3Z5I63fBH11/mhLq1JPmrGnvDEBen23l8TGSLPsUuv6y4UELEwEbB3T0jqXfu+s9dZZODH/WX3QKP+DKXHcO1olnxelfDmB+EMZbMDVV7s3mQKl4zli92U6xhhNIPv4VSyiTF76J4ZSDba9zi3QNudOGtNU80Mauy7xb3bb4ZhnxMAK33/U
 LXjDrkRG
 XdMSwXWAQ89gdtZuKhEmkFefB8MkzRx3M7bvR6fh2hGDbj1G9RrvRwIN0GvIlzaemJYvmRDZGtfZajX55FPxPx1yHM2bC+LJ3ZtFnFW6lDAPH3cXbtz6eLSRM9m53MJy78rZ76T4jHJ4xq3eZ4j2TKFouU0tt9drN8N/rHp80JC2cx05ln8wBMGXUZfy1D6+ZZkZnYSDkcUtzG1dxYb9e2zvPi3tkWyP/eJqEr/o8jLgIk+dBtDtUGCjluU3D4hBnv5NUh/o0lIHVBCM0sbS5reAmQv/0GUz/mz6BrOp9YMV6JBLB0/Ujd2VbgFURNDVzYpEzef7Z/o5Bjr7JtWR6v5ZuBLV7k+I5pD3qQwGAbIqnkULt/AawwaUgoM3HDFpZ/k5KvS9Dv+T+pSdW9jPCpVP2LaTu9VZutl0hUbcMAC8CgRsy3qkP/tnUX0+SPQNdgmmaIhnXTTUGJLGlRy2xNX+0ftPAvJFrZmlrBmXGSwpZHbCsmeyiJN+4DPHCxPPoXCvIcKaOKqJALmP9xdE5XK0wXJmD5sG23vfbjBP2FvLw6ruapVSdDruLOETj2KmRlCq4/2vmNWreK+7/PISNzuezdORMWeY4r3U5P7F8DyShrF9cYqHYst9ccMRfttJNnvs46stRjdRI0yE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


During move_pages() operation, when move_pages_ptes() returns EAGAIN,
the error code is not cleared even after we processed it. This leads
to a successful retry but then the same pages are retried again due to
the stale error code. This time move fails because pages are already
moved, loop is terminated and move_pages() reports a failure.
Clear the error code once we processes EAGAIN.

Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
Assisted-by: ChatGPT:GPT-5.6-Luna
Signed-off-by: Bryan Lim <foxieflakey@gmail.com>
---
Changes in v3:
- Updated to use proper sign off.

Changes in v2:
- Updated on description to be easier to understood
- Reset err before retrying, instead of fixing right at the move_pages_ptes
  branch.
- Added Assisted-by, received an answer few days ago from linux-newbies IRC
  that even I just used AI/LLM as "fast path" of git bisect. I still need
  to add it following
  https://docs.kernel.org/process/coding-assistants.html doc.

---
 mm/userfaultfd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index c3adedaaf7d5..ec5d511bd179 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2085,8 +2085,10 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 		}

 		if (err) {
-			if (err == -EAGAIN)
+			if (err == -EAGAIN) {
+				err = 0;
 				continue;
+			}
 			break;
 		}

-- 
2.55.0


