Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0488EFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E02C6B00C4; Sun, 26 Apr 2026 17:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7386B00C6; Sun, 26 Apr 2026 17:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6A86B00C7; Sun, 26 Apr 2026 17:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9C36B00C4
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E77812057E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:48 +0000 (UTC)
X-FDA: 84702047136.06.13A1CDC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id CECB0120003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QiyDtpd/";
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sf8WIccv4sYUoC01taSJ6nrrobzratXFM4dveYAPw/U=;
	b=e9LBTMEFiRhUR87kYk7lhj+u0qtjvndEi7GuN8sSTBTwjnHS3slKMbAevPkUnCCQKEqkNB
	Z9+5qQ21IKdYCuHhWmmj3gcc53muVIHeQbfnnUqDX4RRVHVevrO/yLV2xrxFdXylk9rfNt
	+I7+QBDh4MUFivufgN5G8r9hWga7xoY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240125; a=rsa-sha256;
	cv=none;
	b=azBUap3hGfQiIJRZO4rudWsqTQohSywk5FbWEdKpID1SNFq3dyHvjucd4MPfHvwO1+U4pr
	V4YFR4MQrmn7m/BSj4nIKT/YMs3mKxTXqckc+/cFKTun6oDLb0MR0oGenlMswTBPOpV7ep
	IummG+Fh/l0qhjZ1c+ZAk/b7BRxkcQg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QiyDtpd/";
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sf8WIccv4sYUoC01taSJ6nrrobzratXFM4dveYAPw/U=;
	b=QiyDtpd/lzCDcYBK0IJ3GQAGYZSTmtotUwgW1lSaxQ6atJrCqjQ2vJDfF6GKEwlEqpdkc0
	gqe7NYXxReEqBe7ql3FkphfhBkakSGn6Qi11PVA6LW/Ko3+Vco9+M3FT1nK/2wR6MlCRR4
	9KsFcG3XC2q1SQIt5kQGxeirhFb5vX0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-LJF8kU1LOwWz2Gf7xMnEyg-1; Sun, 26 Apr 2026 17:48:44 -0400
X-MC-Unique: LJF8kU1LOwWz2Gf7xMnEyg-1
X-Mimecast-MFC-AGG-ID: LJF8kU1LOwWz2Gf7xMnEyg_1777240123
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d7757463eso6129006f8f.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240123; x=1777844923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sf8WIccv4sYUoC01taSJ6nrrobzratXFM4dveYAPw/U=;
        b=D/yjbxiOzDBnN7qeXcaLASLB1TlfktEy+mMiK1L5/iChmgeV0kyfYojmjCXiUAwmrV
         qfLM20GmodDJ7S7qzbMXJweWsWlKnQr7P32AvaL8wQ8U+MKgxRKxVnGGPCs66S7y7Hjp
         qE93133+h6Kf9OCOGD1FN2qkBT64qtK9tAQBCQ4QmB9U+qFNhASrF5IX+b+OoQ4PDno9
         6sSHnk3ncGfwlaCqXAevseAGbDYhaIvE1g3Z0KAQqXHm991Hiwz0K9uo5y3AXgfIkM85
         P5sl07c2KM/reA9PiggrRPhZNSC6YitiscfI/m8SbKi/fKdzvAwUu5afeTjOE4cwAoJm
         iUYQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ZZsGKzZ8LqvcAL9X2zK3UfM+mwa53DxqxWGFf0R1LwU3vYiZZSC66D+btpfG6EDT31N29zQ4mtg==@kvack.org
X-Gm-Message-State: AOJu0YzWXGm2r1FzguPuO6jCDSxQuW8x1VSso4C+4p22RoaxtsAeFAlQ
	elDF8hFjkZP8YNjYlH5fa91I0XldLrjZp2CEMjejo0Pnnrinyl1zhS/dOGYHlo49rmS8UVpdm43
	vJc/Xji2gsWUp0Im5gNMUZVDW6z+PqJsZCY7z1IIOE9w8/BpnZRfN
X-Gm-Gg: AeBDievRHjNwSqCC34dp+f3FKja8YDdphzyejzqtpEbOgpc5+nT6q/9fTfPfmYLJyBq
	8hM8Tw4+K6urf1YNHRRcDdsu0SLC1XzFsYqNmyrzKObk6WAjHStq3I7eAw66QEPaiIEOnt9MlI3
	PKYzCvfPVBm4e/oC2KyCElQRrsvrTD3DOrdLPpXdKnKEJeQ4y71fDSfQicceXFHwjx+c5cqWD0K
	bt6XCjXkvxEueaz3hwBf3RzL8j5oIpABTt1TFg1bDAtKxHLrnKQyvylB5rhZbyXo7FDiJqd+iZf
	pD9T7L2nLzmnFConn30gDUH12aKiv++quRN8M7v+eIWo7xhtEtx17V5ECuggFaQ6ZYlh/wxuhQm
	qc7fGyHsGPrKJEJEv1Z3TQR2Eq+5SVxZGYgKV1BlRGzqZyk7Z/yKfJysq
X-Received: by 2002:a5d:6f13:0:b0:43e:a703:3675 with SMTP id ffacd0b85a97d-43fe40329ecmr53892351f8f.5.1777240122760;
        Sun, 26 Apr 2026 14:48:42 -0700 (PDT)
X-Received: by 2002:a5d:6f13:0:b0:43e:a703:3675 with SMTP id ffacd0b85a97d-43fe40329ecmr53892312f8f.5.1777240122338;
        Sun, 26 Apr 2026 14:48:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a341sm81502808f8f.24.2026.04.26.14.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:41 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Subject: [PATCH RFC v4 22/22] virtio_balloon: mark deflated pages as zeroed
Message-ID: <966969d970f95ee2a573e83ac26162e15f758261.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rFyXb7nHmKuw36x2dewlK8aLzxO2kQR7VjUQNeTrR10_1777240123
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CECB0120003
X-Rspam-User: 
X-Stat-Signature: 31xyn1mseomm71ktzyzkghybg3ugjhmh
X-HE-Tag: 1777240125-34605
X-HE-Meta: U2FsdGVkX1/fUK9jmV15WfjBBL+4Tf5e1OhKMny3O6mFiXeYmXZVntdApbf3Bcu9/sfPV60QPJWzWim7bMjumBIM859seHUbsX0w+77x5KNlxRMy6zqrID8EIh7eAiHUHCdRsbT3eHIlDZuvERXD411uasFST7n9usckaozhAUmbLo4hibUSj8ziEnnv1+GSRR4tRV4yPFUzPeujWRZSF3DP2W/653FRRcn9WrEiyYh1i6o2lWlnaKjaAgeAWIwRkvTF3r28MJm4PMr49H4Hs0OCtNdx/IFLme+xA1T0EtQo4kuk0MCvb7rG8/Piu/aQioY7NZOvC8D5ibzcL3xQkZnCart1l+DNtRDyGvgmzEhC5j9qkEC2VCedVeEm4Elkv8uY2i7iN8rveKpJtg7Q54dawn40oCG/4seCXEjKx6u1W+0fpdP/1EWYKmJMa8OOmmVKAuR4tY9pGo7FybXP7oqU2w72Cp+NwhxhU07pPfB/bakstPdT98gv1xoAqWuovWOFWnWCSoRvyGkDaECmFrySfMVT+gePx1e2ntF8YxZX7aoiU5ZkcooyBr5AjYNfVz1z5IUw89GaooqkxCMXv64tFvvgaseRF9MGmnn0YOXqaE5m/L9d09wL1/MfLWbJNzhsV5S3hZkU0cscHEk6/mIe0JeWb8n97TcIrffHfZzgS0Dy+bUTwrB/XqWy22xEKjosAALZEl1QkLcmbu8Hz+GbFZ+BnpvDQYbPCiKbgCphi18DsuLiSoqCQRrREsbwWoVu58PcY+QyyWFzDsV1wxPYxn+ShTZIBoY1kXkEvgAdxnW77OlOmNoZLgSMZXzAYj46C+5j5IEaFKAb8ml/K7987PkKNj3+Rdui3xobE9X7E7wYtZHAJZRvdu8z7dXf13gxjAUgEyVv0wGtAs2Xp5NgCRMA16D/V+g4WgnozC1kG2EuFkF6PVak9R/pQf94kSFCnCr1rtPqwa113bF
 lQhmRhDi
 jbvK6ZN/CteSbE4gZhwa2KOPUYlLp++oDVBjINyysJcU2hwynAWuorEfg0vA42rJV3h9zrWipoO7jp/naorc60cULxKxhAjrDuAxTyW1KTSnCRxXQ9KYtKMO2VVjhdlUKiV2XFAmmuJXn3Vkt+rNjoeobwzYMN1+qPbL9NYkL81ecrmfoV7+5dl/lmaubfzHK+qKWEs50zXsKH0PLvS2AWTxJS6o9HTwhnTTlbUquvdF0zB5hoOVpwOFWCcVttIhpo38bxX47PhtvMfBGV7mO8Co5DnYZ9E1v5Co7HmFH6tbK7PgGdhjhvFb8Ssz+1l2+cuz0wNdE+turR3pPwRwTghofK5V+CNoVW3bwvjbCKJERpPsw326aXoVzUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When host_zeroes_pages is set, the host has zeroed the balloon
pages on reclaim.  Use put_page_zeroed() during deflation so
the freed pages are marked as zeroed in the buddy allocator,
allowing the next allocation to skip redundant zeroing.

put_page_zeroed() is best-effort: if the balloon is the sole
holder (the common case), the zeroed hint reaches the buddy
allocator via free_frozen_pages_zeroed().  If someone else
holds a reference, the hint is silently lost.

Once balloon pages are converted to frozen pages (no refcount),
this can switch to free_frozen_pages_zeroed() directly.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 drivers/virtio/virtio_balloon.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 8c15530b51b3..cdc3c960397d 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -304,7 +304,10 @@ static void release_pages_balloon(struct virtio_balloon *vb,
 
 	list_for_each_entry_safe(page, next, pages, lru) {
 		list_del(&page->lru);
-		put_page(page); /* balloon reference */
+		if (host_zeroes_pages && !page_poisoning_enabled_static())
+			put_page_zeroed(page);
+		else
+			put_page(page); /* balloon reference */
 	}
 }
 
-- 
MST


