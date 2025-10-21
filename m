Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F258CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E478E0034; Tue, 21 Oct 2025 09:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0918E002F; Tue, 21 Oct 2025 09:00:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250F48E0034; Tue, 21 Oct 2025 09:00:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F86A8E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:00:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C92F6C04C6
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:00 +0000 (UTC)
X-FDA: 84022128960.22.D170366
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id A74E840005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BF1ComNc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a58UIIapVgV9zdPpt63SgupeCmEgQ8fjnLkqSW0/g7g=;
	b=y+qeZlAW2MDiTJUMHFs+ZD2ScOPW4vRFauFr7tHRITheV8cEBcxECB98mNZZpHD6URvAJp
	FLM/7ot7mf7Zw7zGUu+H1HoaFfVhL3ZaZinS0iyx5XjcQxxIZ+Qd2DFB1RGOdAy/e1KXe5
	pvMl9jEUuSzaIidF/Y+k3AYB9exLHQ4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BF1ComNc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051598; a=rsa-sha256;
	cv=none;
	b=FPud0fJ4VeKvHFB1GtDmSxcho4emk1T8bIYXX1YuIcK/FSGcSv7VuKwupxYjIvMCKNPnwh
	9gUuOc6R3MOTZuSPPrxGHPn8QnozVf5jDka5t6EaA656mnGd+4f310z/7UgVRDfwi5zDoo
	dRef8KQLsZFWfFMpDrHPbD8wh1Ri3J0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a58UIIapVgV9zdPpt63SgupeCmEgQ8fjnLkqSW0/g7g=;
	b=BF1ComNcbnYMa+SCGmB34BLXFXqpg0uNWiN7i83kAcWnDrxSelQnv2OhHtToKL7o6OzSVf
	fNS2kqdbdFJDJy7Me3CUkYxa8X7JAvobgAUoeL0nnHHkmA2S+N8vKetq9P8Tb3uPwcwCJz
	GAFjvAMBf0/VFI2iICo9Ix95vSY0Agw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-3iA7p2CjPZi_nHIkauTYnw-1; Tue, 21 Oct 2025 08:59:57 -0400
X-MC-Unique: 3iA7p2CjPZi_nHIkauTYnw-1
X-Mimecast-MFC-AGG-ID: 3iA7p2CjPZi_nHIkauTYnw_1761051596
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee130237e1so2431508f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051596; x=1761656396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a58UIIapVgV9zdPpt63SgupeCmEgQ8fjnLkqSW0/g7g=;
        b=S++ep/MugIvXu/yJW1RX7EWxrZf8lhhGP/FWfOjgcM7+gr7pfdRN1v6avfiHb4rMfb
         b4K/vcFRvOr4wxryzAeOCYrDuhyBGpob7yEGECuB3MdahoWC32Ql115oOzf1QqJlwhhO
         Y89iTV/Kl+iP/brVdBnR1TnPUEfnic+1/dk99h4nsQsfLvZ2IRbCGSAu9XQ6YtgnFPlz
         kUIRe9x1N/XA4K1uIQMIBJBzLs7dC/J89/bVwj40jErXf5rLKz13JwNKfEwRcEW6wa2z
         r8kL6kZ46XOk3TDp3JGYXB0ZuBYmp47vUM4PLNREnf9itofRDNaPPADzRFduUfoxDKVT
         KAeg==
X-Gm-Message-State: AOJu0YxCR8/E2ZPG5vNGE+wx/lKVYz0MpCuluuNFZDQj5Q6pBI1Mj70B
	08fUdgmno2b50TMzQzJF9LYguV0Zpo70h4IDDBmHfzYTgf6Mii/trlU8CBhcL8dn2pXVb0xAg7t
	zarcfZ19ycC57QtImTDzl/LoLzhzRYYlyP4O7PBzXHf5rII3S/JfG
X-Gm-Gg: ASbGncvcAHgvm+jYH8TZMW2FpcOuXxU10I+dehnf0f7JR6kx1/8l2xjoJVf2DxQzGPL
	XIlesWjUj/5ZWm//T+L2UYHCCMOJZE5+y+L0D4AWPi3/mYaS7HUcnFn2XuSyb6srrA8UoNSOnT0
	ErHmhgNECpIDUuMsVtpgfu8KbXEq6tbIq+P5Pd+w4R0+Ch7sE5yp44F3xHPnAtJ3CiZC5c3ZCjI
	SOGPLcCoFGebbWP05UWU1PRkOIfOCNGfm70G7/NXXuqB+rDZi+LH2qgb3RqvRT0JonvXBWOOFK8
	7FidFQNGNALA4POs4OLFqH7p0QXLwn0oxTAag21TKP9MBIA9mxbcOetM2a4mOgmcpvvHn3vML1V
	sBs5Frq8SkV8ryAAE2zFTVpea8wm1Ss1ccr+y1qnjLBkXmCoA4dVj3JplM8Sg
X-Received: by 2002:a5d:5f48:0:b0:427:2e8:fe5e with SMTP id ffacd0b85a97d-42704d83898mr11742029f8f.13.1761051594880;
        Tue, 21 Oct 2025 05:59:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOL78NSzfD/K3cQTXDnH1hifM9lFea/fB9GzfGevY7RVlJ9OG6SsU/tMvE3AQ+AuHnf7dxjA==
X-Received: by 2002:a5d:5f48:0:b0:427:2e8:fe5e with SMTP id ffacd0b85a97d-42704d83898mr11741985f8f.13.1761051594394;
        Tue, 21 Oct 2025 05:59:54 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427f00ce56csm20023457f8f.50.2025.10.21.05.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:53 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 10/23] mm/balloon_compaction: drop fs.h include from balloon_compaction.h
Date: Tue, 21 Oct 2025 14:59:15 +0200
Message-ID: <20251021125929.377194-11-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UkzKQRymu2r-S3h5pmd4PFyPGhD24yfj4T17ogbj0Kw_1761051596
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: A74E840005
X-Rspamd-Server: rspam03
X-Stat-Signature: 8dko8pygt1m8yqozafyaxjqk3barmauo
X-HE-Tag: 1761051598-911559
X-HE-Meta: U2FsdGVkX1+yNd2PjOa+657aVoy1wMn+c3qZzdTXZyzd8k8pc6aKe7GYuRSIczsu+kpGkPWSQu6iSyuFGbTrNli+qQUpp8uslMJPBpmcjlLLVgsHNwHKQrezkkZtalKABigpifQK1ddcPGMkwBIHYrdu+cQs1r3uhey9VoTfS/9IYZKQ5AzZlVyv5V7ZFx1dx1jNPbCOCnWxlHQJEqyX1YfLdjm063iaYX6CJsUSP/ceLKq3WzsgTgVCNZPNOSerO8O1g6Zqbfhpohl80Yl6GaSjBEQt3sPfQiGC4zazb+RTAYmiVMWPEzGqezT9UT+ciNNXisK0scswzC8jIprtFpRpAezs+JwBKPtlwEY9Ku/2eYGf2MJ/AQDwpTAOJ9bnVditVFPgg+kncndBXNjNeR+6oiu+AJfObHF46QoKzwPQmqKIQ39mOJiMyEJADWFVU2DdJ1EASzhIsfhQr04jFS9cHvFVmzxMRNjXG10AXrH8Unwjhsx03MorJgAwN739i9ivEXxwHLseVyLvyM4Rg7/7OWCkf66Do29rzl2KDGAokIxES2rK5MlnXB7YT8sX4QkOEmb+FWejQYWF45PvKAEhvs73xgFUpjsjt6RFVxeCKfgN8AuiXtiY/bGTiL9yPQpFoIteqThFDBZjYEeDNiyG0lK5VI9btpqvPjz60IZpQ3gipAy4vpJpI+QRGkP812K54BHh0FIRD0pBo1Wzd3eOP0flv9LKygVJffMTb6StnnizFzoL12s6Oul6NlxPyxarVtyVz7nAgNSQONgXcIZVBvfHN1DQGJNsh8zOCb7pXTQfLkKnzOdosTbat8nF3VfSCw/TjtGpouXjq3Yh76vcBAEE6blOhVq93htBUT5akoCwkPM7nz/YORuPynhvlm/evJszwDnTY5uu01dai1Rn1SdlX1NwYAnW21mgbnFk5WHt2Ek0XCU1+6DaHZ1utq0VGsBwKnwjnsculaf
 0tAs8VXL
 cFgFxApRLWR1XRdViguiVjzXe9OBXAlzHy27FeTQkUeks2Lkp1qtqjhS8FpVBnuI/iyODbjm/8SrUUnPby8xMz8PNDjKfh/Fknf0eeO1VnT++HhGJFYOwZJMK2PdlzEs4dMQBkW/KEnCIFs1O/ubGfJkNKL7IDVNAa5GHvoCKFmCoc9DcSUyAbkQmuDcJ2rCr1EfWzTW6GxpO+/7iNu5+6Ra/mbe7fmzVZlD4xUiPwRMs7BnKTRNeOQjMc5suRj/0wX3Gzk9lRTpEMkWVhTNgMifhlP3BhXW8oIeYeLFx5xvsgjOihmQtOwRj2cUYB6e/1zzfUIYlEYhbA4haA2X//DukT2bOpk6VYtmc+1I7lJ8/ZxJJjrEf6cKtKcAhRYypeX2tTBvo+KsRSnJVPQT8lr3FoUh+L7kQR4O21QlUnvOAaSm7WnZu9WkJ3Xl99Vtm+BLWEzTt9QVLYNtPgd3x4jITqCWC/M9GTmTjCAiWQjm/EGCrvqMUFGOIfHcsxXUZSKOWQq0MI4Cujb7QXCTkQxNYOfgd//cqnpqYXP4KM3N0NRlD99iGYRtW8du1jjqbKwJdkvk1aolJLjjY5xTLjFGHFGAJRy2aNNwWjZhrcU4CS8h/y5xVGCd4H9Mh4a2z3BfY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since commit 68f2736a8583 ("mm: Convert all PageMovable users to
movable_operations") we no longer store an inode in balloon_dev_info,
so we can stop including "fs.h".

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/balloon_compaction.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 7db66c2c86cdc..1452ea0635245 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -42,7 +42,6 @@
 #include <linux/migrate.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
-#include <linux/fs.h>
 #include <linux/list.h>
 
 /*
-- 
2.51.0


