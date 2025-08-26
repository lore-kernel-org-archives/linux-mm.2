Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B542CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A932F8E00FD; Tue, 26 Aug 2025 15:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45378E00FB; Tue, 26 Aug 2025 15:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934378E00FD; Tue, 26 Aug 2025 15:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 817E98E00FB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:34:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CD69B8147
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:02 +0000 (UTC)
X-FDA: 83819909124.10.A166E48
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3CD0380010
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nSXCYaRI;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756236840; a=rsa-sha256;
	cv=none;
	b=WFjRzrOriH/LecxILh7WKPyjApeRx2A3USVUnSy7InQH1yL4r7ysn/w9umsNdm249jMVyI
	BnX3+MIvT3JD5fFvQjS0OnFIu/yZRgtctOTXhq96/pHfabYkvyVCaaJeBLjH2QNicZrGlk
	usPP1zj4ZBH6KlxJ8hRwbGcRWaqfXl8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nSXCYaRI;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756236840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3RZecD6lOIXMEN4BMHwXQ5RekIY8XyyevlTW2TRt7g=;
	b=XWvw5soOSDOHnXt+JpDVFF4RR9DNfBXXfFIDLq8DuDJaP5qGwsdoz6ZvzyrQ/Yc/bwedwE
	jxO5VTvRB4+a23Zm70tC1cYid5KuG5wzuwGjSa0v7NuFFgPSKN138tmJiz3La/vJG70zeg
	cKm6iv6dpdMPdLCKhTYV3HJ1hMGAq3M=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-770522b34d1so209518b3a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756236839; x=1756841639; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3RZecD6lOIXMEN4BMHwXQ5RekIY8XyyevlTW2TRt7g=;
        b=nSXCYaRImX1Ss0yrI199Qz3udkLsBYTO7h+tF9dVY2Bi1HGfGWxOOSMUxDFtX9QJP3
         44jSG1noj+DV5QtYtiQCznbTwdhx4w6NPVY2MCjA5Q+7UFU1GbDPESt6kgetjbLCdV2N
         HhbfTFuwGettmTSbZmPCt/Kjaz2e+APXgVb+ske9++0msx6Jc8jAyxZWRGMeXdyW4qNS
         9pgv71WPGHe4DAJVr1ngTY/9iXV6Px7ZyUqT1h1nh3W53lSQzOWONslLp4mRoz0zTotu
         BsfBLgw+styOJoCA92o7VVFQkWGx/ghJ3AIceP8MahYdi7ZiNJmDb11Mqbhu3LDPQAUZ
         ra2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756236839; x=1756841639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3RZecD6lOIXMEN4BMHwXQ5RekIY8XyyevlTW2TRt7g=;
        b=VTRMq9iMBmwwtCBjyRSbSJE6DzHHSiHL1dIBp/Bkxf0QYl/UiFvXRj9YJKgZofYBGP
         QiVwWeouocFX12b9Qeuns3hbonQez04p5w1lY3X37SLAvE548BLBBzol/29Ogk3rLHjf
         +Fe2p13h3z8e2E0KqL4/6cdiYrg6nsZIfA+mitmdoA9pO7kdIpiuWHj1JBGSDTTgiOQw
         OZ5cqiwiQIoeDuuiKBtDrLxBwRV+FN3jVAtiDgUSb61dheeRg3RtFG6ou0R0t1+z2B7X
         cQWEr+vCVv9vHRoQkYvEJjQM8SlFLM57za3lLpFSxGpp8YMngIna6zOs9c0CSow7GO8t
         er0Q==
X-Gm-Message-State: AOJu0Yzg5rg1WnN1JNBwooxa1nYr4k/a/MsEJcofOg3g7dHAgptQ9Vud
	fVegOmu1iCcC58rCUtSgFXmA0Y77wzd8Z1LB/RqujpmmyEShv7ces5ofo9Dryg==
X-Gm-Gg: ASbGncvFmwJrzGRg0NQ7Cr4O20MD2Xwl2O4qJGC3eau4a2FZBb0wvjaQQSGUQjFd4tK
	qFuXDcKCzRIXmcI7uM7hOA+KW/NW1EkmNiGsUMo6rF0aKZY/cI/pxWs6kyYlLR1jBmScOSpjZZH
	+Uu+5iygCoPL3wXPMaGEGRrSt6u/t8rF9b5WdAlxVaevQWW41C0cAgoAa0u9WZqGKbjmEv7ioMW
	IQhXlnPVQWQoVVHrAwYL2j7e9WIP74qOgKv1O7lYsFvPqwEosdB1fr+3uF7u0AycIYPfnRk3qkf
	tPznxodluTfDBJ5+tyXxZmpXjMfQfyo9sXRVBvtBkvcPQnlot9ToGAupHdGMsBvmRVd8mGQqdDS
	Kb3H5Xlb9WG7c0r9WZ7RxQyQAgsW96LS8sJGKbnhg4mvnwtZUgCNBDw==
X-Google-Smtp-Source: AGHT+IHlNUyW55X01A0f5EEFBXuViJGDeQdu3GLU6vSJt5YhnhB0dXsh/ZnXWPC1g92p9Hw5k0RjEw==
X-Received: by 2002:a05:6a21:6d93:b0:243:27d2:61cd with SMTP id adf61e73a8af0-2438fad28f4mr3498164637.27.1756236838595;
        Tue, 26 Aug 2025 12:33:58 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7705647e03esm8054053b3a.59.2025.08.26.12.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 12:33:57 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 3/7] x86: Stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 12:32:54 -0700
Message-ID: <20250826193258.902608-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826193258.902608-1-vishal.moola@gmail.com>
References: <20250826193258.902608-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3CD0380010
X-Stat-Signature: c7yozj4y49sfpz953jqiy8yob4airdxt
X-Rspam-User: 
X-HE-Tag: 1756236840-555783
X-HE-Meta: U2FsdGVkX1+u1FQAkoptn1f9gVBzdWlbTrjs226kDQag9FDmzTCeLTBouuH2omoeHCpYjx9PnyeSId4XN4ld638aUlA4TwoSDx/emtwpVsIoMMyiycaJHBv695J5vNUYma/ECqv9jXoJLkMaEHEDs3RThy6zaYvKIH76d19Zy02P71QHpEQ+Nchb24iU2W4Oy2AirHLUFZfi2POr6Y92rFJMZSumql0sSJ0Q06gOuJ7wO/zPqCbUuRRyByXLEww5FKjBJd67kwwhFzPUw6xBazgi+4I57lFBN0OJvoR5ilLGUy2QQvZQnWjjvqYYolQu+h3WrZBkQZcHWB5py1Hj0GLkqjaNDgsIWbIwyftb/tAwV47AzS6KFMtyso4kkEPyGH1s2Ka2rGZSVKrwhyuKGCbcHHlVFTfBZezAlepeFJM3KFWpdPShRVMx7ObU+LDh6fU+6h22xYAAyvHU9n/gF/s5vGSPtSrCgsnOOR4G+73UM7JsZrljjGAH7qPJiMTF/SLhxNIPR15SEXS4JEWW0tUoA12S9znh3NKOyjwxhL/9mBgteL7S0PxB3rFd4CqQIKuB8OKtrK67NR79BzuylABwmoX3+AqX8lJjQi4ZHKMJKAY75E8tCeesdzTb7oXeWcmIAp/DISkmbYQ4HiIUWzOQqDASGUy9t7x1wFrxKbLHb7kie1Rm4hKaWifC9/megx7QDrur6lDJTDMbGcTlmmHQojo2X5HJgDoQnGJb0eMTEqlQ1tN03L4dGGeaIbaP1luVhjt2lG67TmNRzhm0wRDbhGbWRhudHfLI6VKvs5MPY1CZBVMZRBf0VhRjJiqlQu6UuyDksoiLrdekekSVw5sqRuc/fYv5uikvlIsWJCP81KaHjf1FveiCqhxrK8rGfuaw6f6NJebQJ0qB354U1501Vt3URG0Kbbwp0R8IqrG1HKPC0eETDJymGzhVixPyMLxTscREllldVV8nkTh
 7i1qmGSX
 sGpRSJphj6Gw3+a+OFbWJ1W8m8KZcyBIoWTFcZ3rDN9qCnIf+LdAG9aMjc32aRcufwam+MQSfkvz+oF/beOrkuY2KxCHilRnMEn4VAQoMRrmzm5QonyC4Vut48CtT5GjFp7AJAEmevxe+eSXLZu9tWJjf6hdsoZahs3EMLUpVfHjrdWNT62svk1/liJkohg0+n6a90axDkJnr0TExeB+2kBQX4hqQhxt6iywOyF3A5nztLNh5AEprn4UZfrG7pFQP8fmdWnos8RJUdiWLOlD77VuQ071GLBR8W71PdFDyCbpmShfQc2g4XXPGpJ98CB3DY1ePIcoOevmIph2MS6G5pdM5hGJy1pEJh53rkJUYTGZ4AvfHOFpH6OmVrV+MCZ0x1atYPrqrG+xIloCD3zpXAn4sQh3Gtnohz3EiNhUvXsPAIjdvoMQPQxkV07kBpuBPSD0topO2VqIseCB/sdoBArkYxle3p3OPW2+900DtHFL/ecoyD8M0b5qMxjYmrjxw3YbmCxA67X6/RFkFFWTv/4wX0KZDueE1pHvVijqrHbO9reCYttsZym1jVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() should be used when we only have a virtual address. We
should call __free_pages() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/init_64.c          | 2 +-
 arch/x86/platform/efi/memmap.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b9426fce5f3e..0e4270e20fad 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		free_pages((unsigned long)page_address(page), order);
+		__free_pages(page, order);
 	}
 }
 
diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
index 061b8ecc71a1..023697c88910 100644
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -42,7 +42,7 @@ void __init __efi_memmap_free(u64 phys, unsigned long size, unsigned long flags)
 		struct page *p = pfn_to_page(PHYS_PFN(phys));
 		unsigned int order = get_order(size);
 
-		free_pages((unsigned long) page_address(p), order);
+		__free_pages(p, order);
 	}
 }
 
-- 
2.51.0


