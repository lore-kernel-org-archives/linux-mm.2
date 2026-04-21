Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44177F94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC716B00B4; Tue, 21 Apr 2026 18:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83DC6B00B6; Tue, 21 Apr 2026 18:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972F16B00B7; Tue, 21 Apr 2026 18:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84D1C6B00B4
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:02:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B2F21B96F4
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:23 +0000 (UTC)
X-FDA: 84683937366.25.68D55F0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id EDC6A80006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zqiczn97;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzL0/LIharUBH04VP2SJLM2VLBD1UEvntqvv4vY+Hyg=;
	b=bpiFcMhJOPBT+64KMH9RkMLidvJXlPAHmSI/hbhWoW5YAg4/aS2jN/MXiJZj/JLElmLSPS
	0CsD8w5GjGsx3ikP8gw8xgoKPcVwCqhfCXlKgrByIjv/+a22RXvDfKoARHT+oojoYXNesz
	tsOQ42O5UC0vHuMA91Ofk5Px/FQKBCg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808941; a=rsa-sha256;
	cv=none;
	b=t3KZCLvQGRo0piZWch65VXyCVr2C3rsYKxUzxO8U4C/PvvAaKDhuqh73vmVspU0w2JCn4/
	jFaSFV7U0U6e3VK/6j9EsKaPqiWXhFw2eVptoDcO7/o43xZnPiPPR0GMKJ0ykqU0OqzY22
	ilzWkaq43/9SNgm7XdhpzL/ScYRfMWM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zqiczn97;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WzL0/LIharUBH04VP2SJLM2VLBD1UEvntqvv4vY+Hyg=;
	b=Zqiczn971++LrWtiCmygieeZ/SUPSlLXlPpJFuP4Uu8yO2Ed6+TeLdxe4dRMAIMaA6MawU
	q8NRef4ZRzbV3p5Pv96N4XT8HUy96YtAdXUKYkQ7Iwbe7o0nKPgSgKUHfep+zLaz0g0end
	ffxvbg7U6Op3FX9ggqWuzpeg5Vxl4Qc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-i0D4gOKAPuq0Y07iG9xanQ-1; Tue, 21 Apr 2026 18:02:19 -0400
X-MC-Unique: i0D4gOKAPuq0Y07iG9xanQ-1
X-Mimecast-MFC-AGG-ID: i0D4gOKAPuq0Y07iG9xanQ_1776808938
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48a589c7879so4423395e9.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808938; x=1777413738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WzL0/LIharUBH04VP2SJLM2VLBD1UEvntqvv4vY+Hyg=;
        b=HliBbW5iQ2e+OWRDGxE+pbRh/Gb2oSbAMfrEaU71jQj+JaDvOuQ18qh7TFJbRgOpGv
         SNSUzgF0jzcicd9VAZI5Dt2/VKBTiWqTdkG14+PJP93yZ92zoVufCE/prF9bcztA1GVY
         VYjjWKtmxgJ3lWq7u6zRmnxRIXNX7cxeFTvOp3xt4uTHyDodBsrfRV2x+iIs3COwJjFl
         UNRNLuV7CtDYTFFKgpGPDf0pMOWSSyw/hcIO6qpHbtzcncAn0xVWWn2hDF52kdpCf424
         pirZksRDKlfmVuIFgRPq+8m4A5n0pKeljweFXBMrr+Y7TQzM7R53IpOOCiUEj0SQbDGN
         nY9w==
X-Forwarded-Encrypted: i=1; AFNElJ8eGa8VAqFx7lpHkSzJzYZwo1IjaL0ds65XsYxiucQo08r9X5LqI8XdZqnjsbavORBY29nWLvslvw==@kvack.org
X-Gm-Message-State: AOJu0YweubDQ2yvm0n6DGor1yjAifAvUnAHjUgzbml1cUaR3xSYUKvRl
	oklBO9e2knzzkPFHZfAMyBkOd9rEF7afB++ql5Zwk6hbmBGTkZUC39f2LQzCEfrXjuxKpm8YvG6
	Z0Vd6PGxhKpHhLVlblg+vCpp1NqTXEhbq58K7TRaTeTNifwDW+Lh9
X-Gm-Gg: AeBDieu4+cmmUWduQ89X2ww2EKvvxz0UZ3w3YqOzRQUgVRckSk8oJLqeRvzJhm5r9/L
	T08asW91V5bzhvyFTijsZiCDkuZ1BKA7uyY4gYYVmhjnvKam9ojC57h2YXBtss8VP2bjA5NL7S3
	89aCiUbxz7PbgUp1CR2mFhhPJF81AKV9Rhpg2Xw8agezEje+NsslP/REIjWKiHlnZBh54J7IzQb
	fF2Kjvp89lXgp0rctZpG0udWYA90Wa1NHQkkaIdPIYeyPEYybD8+qji6/dCjqm4dhmiwt8PECro
	gNexGGr3zxbVMVuaHG4P7BUOQKN3exzBHfp2IldiZSrOzZ2H9GfY8/tSEv7GNFVdNUzPTvdx8k9
	KabKSq8u92lXrnr8JHGZSNP/EZ5UAABibzBWyVn9pS/m9athaIcjjsw==
X-Received: by 2002:a05:600c:b96:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-48a53390f6cmr90666045e9.9.1776808937648;
        Tue, 21 Apr 2026 15:02:17 -0700 (PDT)
X-Received: by 2002:a05:600c:b96:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-48a53390f6cmr90665755e9.9.1776808937145;
        Tue, 21 Apr 2026 15:02:17 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0b4c85sm383193925e9.0.2026.04.21.15.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:02:16 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:02:14 -0400
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
Subject: [PATCH RFC v3 19/19] virtio_balloon: mark deflated pages as zeroed
Message-ID: <e1c6c87f459904ca5cec26ef167ee6cbedd6ae70.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F1TPg-tzkms0DarPLLY7omSOSHeFDwfZss5ry7a7qpw_1776808938
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 93ku7whozhm9gjxmnbyhbmfnz6ujywwk
X-Rspam-User: 
X-Rspamd-Queue-Id: EDC6A80006
X-Rspamd-Server: rspam05
X-HE-Tag: 1776808940-640931
X-HE-Meta: U2FsdGVkX1+uOcMD+zbX5y5c/x9KsW86GLrO5ZpL324iIeO7Nm4+u+NULuiuX3nTFOTzeMUfcriP2cZ6pS1xQVU48z+ALRquKFzKV0CUno/X9gHmHrbNN4P7wvtK/Tj2bXWmfFmT6Ul70yr2lT6Lv43OOOvgTkFJaBNU0tVDMDM26XXbyzy0Yz2M6y1DE2FSpyUmt9iBR+Za9PxV5y7wjZsAC2Hd3BzouoHFwVdxhTsSPOo9CNAz4EL5B8Cw6lPHRdGPs1nsl0Ao22INSulvGbvqxIBB1o9wNRc5Pmp7KINJ7y35hAm19IM8QGOakiTeBHQyWtgZk8nu+co6SCHXVIILk9jOAI4BWrYTT0d1KgmBRs2owvfuzdMWLziRnvl8ln2Tyok68pjjGmFrO5+6g2g0Y6ljfrt8LSPh7WdJ5/gzM0uhk8TJxKGEodwdlC2h53OwqsD08N34Rv7DUuEVmyf6TkQRI7X05ym4IHqWzWWAFzkSM5aWmNQrjI6i2SCJLbiMQFnn4pyS3/VsQKLTxTiby0QzUsaEeOLlMteWIaNmxA7E7hM5nht1KWYUF/0SGtjg/ym0199cmSNABE9nHpMDZ6REylhjvAoy+TyxmM/QE8hgVILT2zUlqGhBhN1+OgGM3epWO4aJq/suUkQvlU6VbM70d1drzJR3lvcm52Tri33cNjUXBvuMpox7K7Fv4mt6+N481qqnX8rHJDr4HxVZvTdIoAony5a+ALk6h/BhveH45Cjh29PfX235ETRCwsvZwASFM7odt9380XuwY0OHxAHcvLqjgVBICvp5mpuqiSKrif4lVeeCVGYh7Q/JylH8/V3PB6vpBdJfZHh3Vc0EL9NVPBk+wFZXVU7NZwfiJUpQ6fx0gLPqfrGfSy0w+dJI5VFZcLilRph1MjdkMVhblu7YUcK30/uhzJgadOkN3OXRjA48cEGB+zMHQJrmad3z6njrr3VV97+5vhi
 ZpXLO7wi
 c4b/98TZC9YOMhV7YuElnVQ9SigJLU87/ZaQ819zhrlbu+MCswurc75lFX/8Qx1g3/A0KFhYGhtROm4WhAQ9+flCjIvQRaRpptLNXtHO83bN21QI1WrOPM0xQOjnzKQ33iroJQcDkTDgK3QJF1i6NrInLMw2Rhmkze3OKjMdXwLAh563z0y2Kp+vORkeEzrfsT8haoFCxKS+J27wfYkxE8rekEvUOLpWIvBUzx5RiSnsLvxfhjZr/8/zoaC85V2XAknkpbjaMvBdjemfwcZzaTzBk1s9Oil6rLEnhp1mDXSEmz/+ENknqsBXou930IpG47GhtqOCyZTEirdAGUjGtfGXE8bLdsiWSV4lzZKU94AMbMm2I7+AB43IOwA==
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
index 165b123caa64..3058d48fc8de 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -299,7 +299,10 @@ static void release_pages_balloon(struct virtio_balloon *vb,
 
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


