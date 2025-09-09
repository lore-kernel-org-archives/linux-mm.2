Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6F7CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6C558E001A; Tue,  9 Sep 2025 16:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7888E0019; Tue,  9 Sep 2025 16:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD5A8E001A; Tue,  9 Sep 2025 16:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84E218E0019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:14:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28AC31DF132
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:14:57 +0000 (UTC)
X-FDA: 83870815434.15.458B0C2
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4F3081C0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:14:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QhSt1wd8;
	spf=pass (imf18.hostedemail.com: domain of briannorris@chromium.org designates 209.85.214.169 as permitted sender) smtp.mailfrom=briannorris@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QQ1ukxZBrHz0fiIU3WpENCsazmLFih83mtFDbzGAzqs=;
	b=GDQU89vuMZreE2a+mM5Xy3VYDKInSIJj9Vo80e2c/Su5VvibgiGtsJ1elWeLTrsGKNNTbh
	JGs+nVF6TNWbNxb5FrYbktntrXlvkPDwundCFqdlzdNh/bPEKZq9UkNnygFLcVG+lNU7p3
	kQ+RhhGX1ET9KHfQYTaFvrDOiLwqhBA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QhSt1wd8;
	spf=pass (imf18.hostedemail.com: domain of briannorris@chromium.org designates 209.85.214.169 as permitted sender) smtp.mailfrom=briannorris@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448895; a=rsa-sha256;
	cv=none;
	b=yKUkUZZnLQZHCPTZfW/PvgV29l4lFTL2pCK0N82C9MJbSjD5somwJPBBgdWVgr3jCgp9Ol
	yy5Plhwvz6PMFuE4SUKnalfIJ/gC1vRb81J2GsJphUMdGOWLtkDu4r6qxfj9SXa3WGpSdp
	OC4D1PSdONyphJvOUyaudloDyTSOMX4=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-25634c5ebdeso28958575ad.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 13:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1757448894; x=1758053694; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QQ1ukxZBrHz0fiIU3WpENCsazmLFih83mtFDbzGAzqs=;
        b=QhSt1wd82256MvCmqeterdgI8DxIDnIACos1/iBPaf+BC9LQnvM+72VXvrb2X65W2r
         /IntIGopgRTmUtCmSOLn5uCJiPsgI+vHL1CGFl1zTOyLhyjAKBvB/R/LLDRjzvrGVBw/
         L675fh7O/LRS7t6tumVZ8VYFeY7uDns3hp2pw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757448894; x=1758053694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QQ1ukxZBrHz0fiIU3WpENCsazmLFih83mtFDbzGAzqs=;
        b=A6Prj7gcZH4P8Ie5v5gAEEfmkFXth62472hdk1xrVLutBkflnzyZVkbVpVDYTTTwxe
         kVU535rGFPgDR3Y6U6jqpY/uzKqVddqh/RnRQQW4MTzmeel7NNls2b2cd2gyZ5M0Cm/V
         yj0SPBohla5WdrJ6XFwVAkgnp3Oo3hdF+WDeg1bsFSrBfiQhNApYjohBlGbPPzARfyHw
         x3G2IqzRwmZamgBFIODkxrKnJCkSBZ7/urJjovlVjauV6FPxeGd21uXOd7UM7dGu6HYa
         vdtovWrMCzTqIoVACzconYkDf3AT5RWY8wuC3PoVUdc2N2IRYGIBjcx0ULrn9NsgCVoq
         02mA==
X-Forwarded-Encrypted: i=1; AJvYcCUC4DYNyIJm0eZGWR597CxcQlucS+zI7Ofdw8tsmWLn9VTCeIp+AqX47dOuDtN4WJSYDPF78w9p6w==@kvack.org
X-Gm-Message-State: AOJu0YxadFowRObQBrzxAH2h5IyfZaTidE9WcbOr0UrSSZZDUWWinqp4
	KGISBwM0UX7VPnOQmtvlxj3DNL/AyB0iKCtX7n5/QmIE5MQBA0yG7hZ589aDoOtsRQ==
X-Gm-Gg: ASbGncumYaXQoN87cmN1mtMUWzcmAarWNREJlbROlwacN3sTil7nxTlBBhqlTz6MlUX
	nf0xwlxo13YMeqborLhKyfYh0CYcD7STyOb504imBIAh4zve4lkQZnBfwrx2t1A/OIcMRx+Wh6a
	dYpw5ZNfP0TrVf4gLAWx+2Ev7JI+WHkJaCL4/r2pTLHFpKHkXGbUhX58EKK727yJaTIFZQ0/czy
	FotL2c0KOah7ptZXO1plvTy2wjePh1Byjq0tqlw+C3ye4igu1lutjjyAnrzAyO0MheTxJka91n/
	j1H0zKzR1aNZ8Y7C+uW/vN67wfgjxsP7bnEF282Miwg3ZaOmloEO9hN0OhoEumtEZvDUv+NbwgR
	dGV37d3yepN4srC4FoWymhdwY7ObEawLfAy47cYmPMd/1JhKX0qgGgwluuR9n
X-Google-Smtp-Source: AGHT+IFEleK9CYT5OprURH4ClV01NhslkBf07R1vis/dfiqBOF2RSxBhZBCjvJDlnuv1Znedibnn6g==
X-Received: by 2002:a17:902:e78b:b0:246:bcf4:c82d with SMTP id d9443c01a7336-2517285be28mr152752915ad.52.1757448893884;
        Tue, 09 Sep 2025 13:14:53 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e14:7:e1f7:9c44:893a:3857])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-25a27422eb0sm6162145ad.22.2025.09.09.13.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 13:14:53 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mm: vm_event_item: Explicit #include for THREAD_SIZE
Date: Tue,  9 Sep 2025 13:13:57 -0700
Message-ID: <20250909201419.827638-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F3081C0007
X-Stat-Signature: 8dppbn76sx7i1ghxbtmzjbz7yoyxtpip
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757448895-662196
X-HE-Meta: U2FsdGVkX19MFQdGFsZiIjryA/OW4KoCL+tdAeBuUOZW9xlc/o2zvQ9E85W9I8h7UyLc5bkalsz1AJ2y3BzT3Vm85aVFH70wZ22mAKwTbj+xl633Y8IINAK1P3MZP0hHKhruukW4VflqXclmGzTHkaibJ/MaAOcdd3MGCe6npi1Ym58rJ0IwCzgZtS7axfk/NRKX/RcW/duy9vhz/JEXiCkydvdXhQcn/h/H6ZuKJv5wCXTN+KDGMrsWe4wVf1+pKgo2+CuRz7vGMKEi+Sxd7AQfVn6/9xQflhhzrKYRUryqa/5Cc6R+vbG5rkO0VW/NZeYtmrk9j2J4wSClvbztdcdi5dEsw2qs2c2yDInlRFiLiYMlJtYIRa1WmT65iTECRmZGGzeOjlGyYSsHL1PzxVgUlewyv8f2a+RL5rOr28jebg5xetSjbM9LF6Zy7WI/ZF6Zr9RIIck/CKBGI0UBnKPP9YZZt88fbN2QHXiWMazJFG8tTRzSwoHqdPTkpujNtR6dDffCwXYLz1XL36l/T7s1QeZBdD6GFMvdAA3G/igGaoss3QNoor9uEtsTt3w69+gNbx07EjWFdXInBsGWZ9IIUzwyj8MDT6JfGdwLxPme05TaO/dlESi/We9ir4BjXRwCzYBePxo8f/MJ4LBVsQj/wuP/+L9FGQRtLi1mIaGamKf10FTrey3X0s/6MueOwQWT3LGAe143Tx4dj7puqUk+96KrvZGctDNLBIAG7wRutibZXHOoN5j2U+KiKchgZdsHMrWOGd0T2TUUSyzHv8P8lMZhCKdpQQ0baCAogxQFWtwEbyUK42xyGSIgPnxz77DB9SnewBzCazDhCuo685CFlG/Ypwgx1utaZRAm52+JzaVSGYRiP25n5FQlB0d7kUNefcIMn9hfSTF7eZSUTcNcq8/yWe/rf0s0wHtdEjV8NikrdyYndRScmMfOuVyv0raUtBQCRscFEJ/G+Ot
 S+vNhfeE
 RoNvug13kNISz9a8WYk1pkdzd1uXlv6UeqnS3X3dMmQ3WnKg6flXvTUlBsQFVVSGLzWgsJKhpm6gt/p2iswQrPZqpuPa+pvCsBFbC2/NewYknlEwMioblswKLK4ax/sSX3BI8vpnGdlalCQpGNOdlf4P5Q3lnRAXNMq9F+7q78ljlcEYzWrRqfyCCrq2yMx37GapUKrv+xkA55akEXTN4OMYu7CyZVLNJn7hUkcqWdNMhvaKYFiEo28BodoAhX4zSZ/EcRNnhVywu3Ekoka3DQxv3K1ZXSF7CPeHB/zHIZ4yxAjr56yaJ+N+fYF0Mhw0E27BjQYoM7hiSgdQGTTIeN/PLR1qGf9brtExLYtEA1sKr4oMrOqu4KIGBq0hffktk+m9Hdlk7bWwv958=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This header uses THREAD_SIZE, which is provided by the thread_info.h
header but is not included in this header. Depending on the #include
ordering in other files, this can produce preprocessor errors.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---

 include/linux/vm_event_item.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 9e15a088ba38..92f80b4d69a6 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -2,6 +2,8 @@
 #ifndef VM_EVENT_ITEM_H_INCLUDED
 #define VM_EVENT_ITEM_H_INCLUDED
 
+#include <linux/thread_info.h>
+
 #ifdef CONFIG_ZONE_DMA
 #define DMA_ZONE(xx) xx##_DMA,
 #else
-- 
2.51.0.384.g4c02a37b29-goog


