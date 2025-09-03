Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4509DCA1015
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2EE48E0012; Wed,  3 Sep 2025 14:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCF48E0001; Wed,  3 Sep 2025 14:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A62E8E0012; Wed,  3 Sep 2025 14:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB008E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:59:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50755BB4D7
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:50 +0000 (UTC)
X-FDA: 83848853340.06.83977BC
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7AA691C0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kb4i52u7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925988; a=rsa-sha256;
	cv=none;
	b=FSg+R5eY4pyXqo7N24Stk+8ZQUcFnWpBrOyP08/8glgJTfAZrXc7YtlNzyBiRqUB1X7XJP
	3JTaF0y+pmiYHHqcJHue9V4UOQJYcfbXPXVbZaXqeNLOgQCTR8TrGVH+aDtGkfFBl5VCUV
	aso6ZWlwNXvuSnEBZ7+Z+yjkvq0EyR8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kb4i52u7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xP13CUGWmP4Epf7561SmRsYIMeFmCIW416h7MJfMP4=;
	b=DWLFu11Yuz86CtrKJEghwOP06oEDnpFt6XAWXVEgNsS+FFO5vcojseeDbbHAEVGP368tNA
	XoVQ4mpVz/+9DNE2+R8XGcmgu9Hioxo7EuTtJiBIK2A13QK/NHC+IIpOGsS2vUnFvSe9K7
	s9VuCu+m+c46IkKAaeaRw3WWyf5iNXc=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24cbd9d9f09so2648745ad.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756925987; x=1757530787; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xP13CUGWmP4Epf7561SmRsYIMeFmCIW416h7MJfMP4=;
        b=kb4i52u7MzxJ3+ViOhBd3IFc38j3MQoqZPrtBx+dWDUfW9ar/JiokA/FgH0CWpb77B
         s1EQ1YsC1VTU3T+WcCXZELIYHqlHRHxIVytrNCLrF6O3hiiNY+qaQF4S/3vKscYyVys4
         0WpFNK3+kvo9C1u40DOfmsBILZ9rsSe+8Mt3auMJEMe6IYwcZLsIGSm/9TAdfAn05fMz
         ZdlyTY8A/8PIrRTaFtLB93K6sFLuhmpvaJ5PYeecG5gLQ4mgHTj+sNAZmv0JhyFEUeI8
         x/G237wNQ6NL9rkzUM2d7g66TJAYSA67th7MrR3TGBsAvc4zkx30ERV8i1R7NcunaeFH
         RfQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756925987; x=1757530787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4xP13CUGWmP4Epf7561SmRsYIMeFmCIW416h7MJfMP4=;
        b=a+ovr/Vzh3CZHdYHH38bbimuD467U08tyAtgzuMsh+8ww40meTeAyNMq8NHHe8eQW1
         uoK67kHPx07ZobgIeHS9FI6Qs3YE1BI+4ckwk2eNsPZO6bLpJM/8XOJf2/vL/EZ2DIv6
         py0FkvJZPtdjAW6VheWynSEk/lJOX/zgNgYowiWvSadnsUHs5JQuOwcyeI1oYKfiIq7D
         7fiHd3rxwkvfdIbdNhF13FiKIYAoOO/jXNriARhna+jIuhhvYFW4n0tDDZQ3jO5fOVW9
         7Pc7AAWWbObkqgzRudcYcY/dBnONageVXM3M7o6+WItRg/jUAn84ietY+1dxI+Wt3oII
         oRxA==
X-Gm-Message-State: AOJu0YzGNkmkhEZrp9ia2hRNzGy4QnSZ6xeKB/yeM+760BrJWUiKTPjg
	EYlkhPkqR5cJ0DgkBSF+EXzfgBcUnJb5V5x4lhLsCmNT6tn4Re7hVDFKv163kA==
X-Gm-Gg: ASbGnctZiW+80EXsrk+9KUNCe4OqT7tzsV0phHpFNOHSC10L5VZ0qNArE5eZRJsHlVQ
	GP0BxF2Zqhcrh7jOTJp1rqaMoCT5F+MrE5UniO/JU9w9NLxW8Ss4nP70t6Ahg7I4n4RrN41Wd5B
	DXFNZ0Yvz3xoT0cr+Szd3Rti/vJ9HrESmYAoFMf4iW8VtK5J9aKqfgk93JpnRKiyYmIIg+6jeGE
	oCF/qudZWFA099lY/lqTgfIbTP3BfzDNPXZfLlflr1HOK/TACmE2+BKVlkXQYyBUlypBFCDirwY
	NH9jDGMg+BUN5nuWj/QVUnSRt1wAPe0VZYMRZ3hiyjXIR7NmAN0fLgbwNHAwNndM4m5z+xRrsE0
	cIBgB+UqS1AjiDZPlq1UXqWm7zvMWfRoUeobtyle1raOBQY3iIQALbXQfkcZ9ofCp
X-Google-Smtp-Source: AGHT+IGWl2NVhEd4Mf3PXgbO9PNmoIZrvx3puV/+d96WnhVgMh+tacbQQZaHLdVwJGJAzq5ejH+5QQ==
X-Received: by 2002:a17:902:e5d0:b0:24b:1766:cc70 with SMTP id d9443c01a7336-24b1766d2d6mr89341175ad.39.1756925986861;
        Wed, 03 Sep 2025 11:59:46 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-249065ab343sm169403475ad.126.2025.09.03.11.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 11:59:46 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	virtualization@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v3 7/7] virtio_balloon: Stop calling page_address() in free_pages()
Date: Wed,  3 Sep 2025 11:59:21 -0700
Message-ID: <20250903185921.1785167-8-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903185921.1785167-1-vishal.moola@gmail.com>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7AA691C0003
X-Stat-Signature: 3fb9m9uad3es5mrf3ir19hgdaybhuow3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756925988-602745
X-HE-Meta: U2FsdGVkX1/Yv+wq6q5XvL1gIWrhyvz2cUouvWBHhfbMZIvVMPiYSX/aWJPMrUbzL1TFPekGhue4gtcTE/Ya4jCKVy0pTAMWhjam3kSaXgo7D+alScVLI1lhRjV7406rU1g1iRcA35Vkw9IouwdfD26r5QR2AMzrlBllp6woK8ystqJwW7Y6cIRwu2pb0Y1gXFlKxO48Q/RVhbadh5IGMOrbx3IP2FWc9k/TFyfgxwSQFP2m9i3jOQ1AKz7666f6LJSuiEOq/JPAV/f55iU7Yvr/2OIh3/VXyD6kbnHjm7bgVKcUb8PGalMPvWvhyo1hnIWC7++/ajEzl2lCcxPjGvtCSdZPzdih2DpelP8G1doR8euI3VR8W3RBLdayrCJhmgSpBd97BkoiBm1pvcN3T6Q88jSM/732iWwil1YqZ7U6zdtGepR0KEvwW+ttLhPitgef0gxQL3n8ysIZaia1GMKk7voYa8zHgZKzSQnPyvGdLQlH9UceCO3YC4isgU5PNb7gCzIasrYVDUEy0cZcrU8+ASZI+m8Xh2COQfj17u3fiaBnq3FwhmrgqmW/pXes3gj4lVqjIGEQzdmJhCwLAS9mno+4rrAkFBf7XZiSz3Sb71ioPClUVd637ZouClPIDIHJWrz4ArDsoaVq7NiQTycVCL9IpD15jwLqPjRAtqz5yJMg0SduGalFlxc41jLgb1uCGNJJ5JrhH/S6CxxdBwtZ45P2x8htJXmeaOpSt5YZxghuF3ZThN3JN57V6ACA1eajiBQMf55m2ph7TArKRRUySihh83rkj307hCRjzux0mBvsnsxPmpJzc6WH5M1w5JkLCZzDKcRuUQ9h+JNTbFEo/KT3bbOop3FVOtfaX5NlJWel2xq8JBQVmPP+5p+zV3RuiodLxQ+V+6OuAGegCcoTPkHbisYNmg98Mcp9cVsDXSjWp6Nf8AN7/DrSnMNRmz9nk11nNTPuhZj67za
 glut8ls3
 5pR+nnqX3qf3GHIFtEI8BMjFU2Ch/6Bx9Z9/7gJjKaLnvIbZv/3TVsAdhXqHTVeI3qOlGxjmOupNL8393OSad4ZhbYs2jfYbTDSKBKb9C0aNue72w4Pxolu1vNW3EZQXQG3voq6QdWJSUMV8tx0wNzmYWjpQH7f15U3eSAdEnNEwp9S0b288m5H3Tsvca4+zFyU8OIVc2hah3V3ntYzHzdEyDFHLtTvEtWPufx+J0jPFiwM5Xf3YiBa7VYU2lmZDpoRihDldEN8Zw8eyifEHidnQMNtCXKEAhsoY5lrBmBisSrgdjI4Wl7VZ/45IMcwqEtLkcyDnIwjtHJ107t0d6AehaxwGKTlzaeQCMAamQtWOfKxXOpbxQITUP2CqqFZpUhmEYQgkidOgvI4Jnzfvk9yxl6RA+qgxS02seMsw3w37DQqY0ovkaPVcoxZ5zfMu758DDPjzoI+05UUbg4W5u3crVRoKOcnN9cAvEL5yAB+DV0Twj8tYba3vgel3zrYuhYg6cbC2yS37Ls+Cl6YHQUTEUmVDgp0E455ix83x7vsioSF8KfsR557wOrQ==
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
 drivers/virtio/virtio_balloon.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index eae65136cdfb..7f3fd72678eb 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -488,8 +488,7 @@ static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
 		page = balloon_page_pop(&vb->free_page_list);
 		if (!page)
 			break;
-		free_pages((unsigned long)page_address(page),
-			   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
 	}
 	vb->num_free_page_blocks -= num_returned;
 	spin_unlock_irq(&vb->free_page_list_lock);
@@ -719,8 +718,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
 	if (vq->num_free > 1) {
 		err = virtqueue_add_inbuf(vq, &sg, 1, p, GFP_KERNEL);
 		if (unlikely(err)) {
-			free_pages((unsigned long)p,
-				   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+			__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
 			return err;
 		}
 		virtqueue_kick(vq);
@@ -733,7 +731,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
 		 * The vq has no available entry to add this page block, so
 		 * just free it.
 		 */
-		free_pages((unsigned long)p, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
 	}
 
 	return 0;
-- 
2.51.0


