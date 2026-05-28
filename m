Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A10C9CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 02:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5A56B0088; Wed, 27 May 2026 22:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86DB6B008A; Wed, 27 May 2026 22:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00A36B008C; Wed, 27 May 2026 22:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB0AA6B0088
	for <linux-mm@kvack.org>; Wed, 27 May 2026 22:48:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C53DA0766
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:48:59 +0000 (UTC)
X-FDA: 84815296398.28.2FEBFA8
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6F4D3120009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:48:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z8+W/GV3";
	spf=pass (imf29.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779936537; a=rsa-sha256;
	cv=none;
	b=s8ptQWSInn4pv0giP+FFKHBOUrQlP6xF60Ske7iuHzKVO8B9KK7A4+tI44mzdfYyObRvIf
	+Lilofn1NQCJ8HnODAm+zp25WHBeqXcThtQnP1j1/NvqphvHUmVJjaVp/Q+H4qOUoCxCrH
	wC/nURO6+dSLy/atMghn7xUG5DZ1G10=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z8+W/GV3";
	spf=pass (imf29.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779936537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdZHIVC8VqdiF0LxnTx3Ka4A/RjNztw5bpRG2RMXPPI=;
	b=VN+Yj+0Q3Xgn28CGZMKS/I1QbKvKB7tMN7OnOoswQfvWnSV2WzSFyXwVNbZOqQGTMzonch
	N6d143M0k/ab6S2OfSAL+89XatJDCRM3zovRtYhZUijMeVXZrG8EFgDmTn166grQLuHAVb
	3sMU13Cw13pRzg53e//eRiN6eV5gYck=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c8173b2af32so9468297a12.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 19:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779936536; x=1780541336; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UdZHIVC8VqdiF0LxnTx3Ka4A/RjNztw5bpRG2RMXPPI=;
        b=Z8+W/GV3bSrH1tfiVB3u0Gfl/Ens+L85GHddtOKoRW7DjJxXLO3GPFK7y8fvunt/92
         Q4gf3iRWTFTy65aAXtVVYBKeklMdzhnyfG2UXMcDGYcPR+6No1KdFaBfflJPM+e9o6D/
         mL9DNqm2gDERe3e3+tvtGWp6aCTLhw97cBWLMr2N2oaDFnxi+GL4qz9U4eMiQjUc2bKw
         fvPYLM6hV9BuLxTFQtz8Ho7dAaZXgsB8cFxiplzn+rMRH5pSUWkoda2X4jnvZ+1XXJW7
         mG1Kcna3DqeR9hNqdw1KaU4P1P4UDug816H4pCUj2W6EvhoLZ/3Q6JhLeM1OYXHWE9W8
         3e/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779936536; x=1780541336;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UdZHIVC8VqdiF0LxnTx3Ka4A/RjNztw5bpRG2RMXPPI=;
        b=UjAuJ/4exwXYf9j/dh7RRHv5LjsAMN7LWMYRKbPib1OmR/MGA2YAnFrmDtP8K+FWqs
         x0lZVxRe9svZySuvxVgE6AjNL0oEWh1ckvlaFo7HaOx9WZo/hNNv+nejHZzLBS07vAbo
         8Z+CphRrXsiVC31/rzRP/HNSM+A+lCUP9UJ+6zpO5PE3xaEIiqmGhuaYkWOq3W3+jVIz
         sNOS3XgpiS8WqTJG3YQ2u8SE1KuCU4BOOumTCs66/IgCENdOPKCf+Ez2DEVxn8r6G33h
         5bvKQDm37Bd7pKIyaok49GyH37YJsbJBTR1HkIW8jGI+qYsjMeMnhOcvccjUssYtnhI/
         X+Ww==
X-Forwarded-Encrypted: i=1; AFNElJ+aIEIUEwqW9Nnjga5UYDS9mzqlSE79m10NbjMw02JJ9UaWFZ3pJhalRDnoKdtOAizQKeXKNb2qzw==@kvack.org
X-Gm-Message-State: AOJu0Yw+Q/dE2u7MedPkIKRLdggAvY43kOb3QUeWTgL5oP+J4khasyTf
	fWvAxEckLEFGrflmz67Ru62lTRIUw+rKnIYSMSUe6JBAz9gOirFfCGcX
X-Gm-Gg: Acq92OGDbu6FXSteDXorSyLwWiwnDMj7CbhN/wivO9Nf5KtzUwq0OaKqd+0RaV/aDdy
	4Jya7uIymVnAEszd7IeFwTCinuzHTedQYfhE3nJwYj/P6zu/FVQBUIdtzxRGIgLlIKyOpw77sd4
	SD9AqQlkjdmNak/olOYhkO+HqtHHvkO7XiQe4mvdpqjWpo3driXmjO5SkwkdfFFYATNJDI3/HCx
	ntSeunZl4Z0NcTJAAyaxiHUIWMN1xTazY80gnNiiRVR0/k6pirwitpO7hLq9RTYBKL429Ge+Z3Q
	JE8zZxcXahDu4159ri6Vh7dPK7u3Y61+tV5b4X8A++pfJztK5OTVbqqGY5WvXf+L7MoYUdtIWzu
	l7YfZYtxkmBpWsCsFgYxcqnRlRA/ABzNnBV62ltIDOeSdCErtmZ44DqhTvlOZXBf0XsAbmu5str
	qVqSUD3IuTFpZZsp9GLtaG39dg/Bb1oKD5TQ==
X-Received: by 2002:a05:6a00:238b:b0:835:5aa3:2dab with SMTP id d2e1a72fcca58-8415f1236aemr26567785b3a.6.1779936536313;
        Wed, 27 May 2026 19:48:56 -0700 (PDT)
Received: from [127.0.0.1] ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841f3cbcddbsm366877b3a.4.2026.05.27.19.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 19:48:56 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
Date: Thu, 28 May 2026 10:48:44 +0800
Subject: [PATCH v3 1/2] zram: fix use-after-free in
 zram_bvec_write_partial()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-zram-v3-1-cab86eef8764@gmail.com>
References: <20260528-zram-v3-0-cab86eef8764@gmail.com>
In-Reply-To: <20260528-zram-v3-0-cab86eef8764@gmail.com>
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Yisheng Xie <xieyisheng1@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Cunlong Li <shenxiaogll@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779936530; l=1542;
 i=shenxiaogll@gmail.com; s=20260517; h=from:subject:message-id;
 bh=4ILmcE2UVRvUA5w/bCMsuoZ6029LYusklIg66JvviMc=;
 b=KynYLGaGfZewjfo8RGU3mhyIy/vlwWxgy9oFeOCxoXHK2kYgK2sfLrwnBPEM449prqRHxV4Ff
 gobRxeZpMNpCc9MhH6mBms/BlpM1EFCtEHdF4CNUFQvLFVvO0SNxIr4
X-Developer-Key: i=shenxiaogll@gmail.com; a=ed25519;
 pk=SKFifnqPdsvsjuhUiq+Y9vtCdhyZ/LrRcfYn8eRq6AE=
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F4D3120009
X-Stat-Signature: zptx1qsgai9pkhrbwci664gy4baor9kz
X-HE-Tag: 1779936537-57184
X-HE-Meta: U2FsdGVkX196VSuxvLlovEPdniqwWLE/hVCrb04eR+kfXeYWN2Og21qQ3PNqCq3TFtnOPrJV2K+zUzPganDP2Bkg6Ch8uQaJar223LoViUzM9frx0u9x6PdyXR+d8cIjxsmNNkTbWaLPH5WaGJTt1lqavmOjRhIYxOMe/sfq1f72mNvqAI1E01YZIDQ9WZsDQR35O6RoK8eUSpyZbb7NpKzkTWFYF/7Irwr1sinLr7CUWPMk/AjzChVoA8Nu19pT4zKRjSO6NV5EodO5cjK9IgcACyp7/7iO5k6fpIzmeLoT3exZqDAuSr7aGmVROIFeYkoWT47DCyXUIn26+azVH/ARxvNQ7gCrAkVmvrf64FjRhnDjsRSk0gpOmQIi3MX9WBgrwgV/QV+NOU6xn+lJN1nmVTnUPsAXNk9/HXN+jRk73z0mz7LLjbbAhFavi6ld9a2YaS+JuQ9RI2x3MFLjBfmJmlpTICJgomwp+pMIBcKYFygegb3Nk7oZWqqdjnRkapDZKr9ahhAD7qnwGJnJcF30FCh7oymz9jutZTkuRqPMwHKrwk0JNFkGJHBBde7f33t1+oLtGnDS6M4gzaJsNwf6tVNwg1HA5nNlAwucjTSYNH5Nw9H6ZasMAg6sN7nGyZtsQX1Bn4prnR1N1z+8z6VkRQc/0FmK0ZH5JYLWlNJ9WwFMGf++prussERHcqwUXxx17AGAtqrmlyGdFe18GVWXTykAkcxi5Grn+xyfgQxcic8+nkKDUywu1qAxrZcdqp78kYfd46STeUIfI9qd0sjWSJKKwfN1McpHXqqWvaQlsrM8VDyqcW3G8LZ/PLe/iE/LBYyHGPQ99/3gKGU0wED88pnVAn4Tn176UKyG7hr0dqjqWJmLNk8kXQL9NkC7OuW9r8SwKwffspDMoxINwuWtwvtMfCEP2syRPF54AGbaSGEhXu+nP8eLVmlKFxOA0FLqpnsEwRCL/J0u5Fs
 C/zFyi33
 ZiowNTiJuAfQs5kni/dQVr34otBqofquQ6LhR06Z1vgklKrLIW0UEFk5tkX5WFxy/uZ9X/K/CRqLsD10aCH3B7p4MupEdOuQkf1O+Kl+tqC0OuJqEUPj6mT5KXHyIuJ44hNzmhlHrnj1JITJUcf2YzsC1NtjWHEKr0bBiLzqISpbVPHSde2BCgZCXatCfmCU16/Mj39qQ71j3TyMc8uiOwEDJ5TQy0ebGIzSBbzSpAreM2jtrMSqe3jc4x/wBQ3vvq1XVfMGpto0PJnhTS+69XPHXdFzTnEfNM4buSp+GvgzrlEXOxWNFKfOZz1L1XWTF0NiNw7pWY+QoKEmSKvulD1BiAlrW+FsogIq+TMWFTCRg4x/BToVmD1rhVERPnlkiWxLpaJhUtrl97Ct746LnNPiyO5V5JbvrPMUpTgsHGZdl4OC/Mg0axrzngsguSWiQvlpi7NyB/x7UnMNH9ThRvJajNfOT63X/nK/F1llueg8yfas0J1PQST7AE73aRg39sQuLYCQp/wBpIeTIyN4S1QvJ7brxFvwm9GB+P2PLb9IeIXAwVIR/Mx/zlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zram_read_page() picks the sync or async backing device read path
based on whether the parent bio is NULL.  zram_bvec_write_partial()
passes its parent bio down, so for ZRAM_WB slots the read is
dispatched asynchronously and zram_read_page() returns 0 while the
bio is still in flight.  The caller then runs memcpy_from_bvec(),
zram_write_page() and __free_page() on the buffer, leaving the
async read to write into a freed page.

zram_bvec_read_partial() was switched to NULL in commit 4e3c87b9421d
("zram: fix synchronous reads") for the same reason; the
write_partial counterpart was missed.

Fixes: 8e654f8fbff5 ("zram: read page from backing device")
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
---
 drivers/block/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index aebc710f0d6a..b23a8bbb687c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2333,7 +2333,7 @@ static int zram_bvec_write_partial(struct zram *zram, struct bio_vec *bvec,
 	if (!page)
 		return -ENOMEM;
 
-	ret = zram_read_page(zram, page, index, bio);
+	ret = zram_read_page(zram, page, index, NULL);
 	if (!ret) {
 		memcpy_from_bvec(page_address(page) + offset, bvec);
 		ret = zram_write_page(zram, page, index);

-- 
2.30.2


