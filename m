Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA30CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8EE8E0021; Tue, 21 Oct 2025 11:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342958E0002; Tue, 21 Oct 2025 11:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20A5D8E0021; Tue, 21 Oct 2025 11:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF3C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:01:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCC691405C7
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:01:03 +0000 (UTC)
X-FDA: 84022434006.03.AAB9F56
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 67FC74001D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:01:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CTWVRKgd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761058861; a=rsa-sha256;
	cv=none;
	b=jvso6t3Lw8b0m0FUDrsfFirEqWMTIJEEgr65Jr7ryuQfZKjJZ/n+/+OHsV7dquyWNL2Wrn
	WBxju7ReHp+YL0WV1xIdJ68K9iguxQt5YfNZDlm3mGFFFi0jDmN11dnF5sT7RCDcHuqkDu
	Qw4pxjeNmjJaVdoMIrYKqgSbHlbcnO4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CTWVRKgd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRubUKoIKZa05nEVw7UJ7l9fUFkh873Slwn5354MkBU=;
	b=yAlsNAYRz46fBV4eIIr7L5i6jUK2zoR2C206rPzEDqDet/botl1VcN6FRH9j+QvSyr/R17
	XZSsJf/m7Ku3q+y4C0PgLRoRIsgE92/d2UGICjJtlSSAvxXOPeDXkaSe1bpQeq2Hgo8U+H
	GXTAkm+BKHHG5US7beWQJh8i9D3ZCrM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761058860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lRubUKoIKZa05nEVw7UJ7l9fUFkh873Slwn5354MkBU=;
	b=CTWVRKgdtlEUmEaXoaSO9zkAUZ3tEd8NzCAYy09BVjymoqXCglke1u+KXp9ry/TdQX+a7V
	A8r6evZE81V56oayjuN+YibKUCIt21AfOIjsrrAezrcF/tQbACIKHAjezgqJrIk622LZ+t
	ohQ7Rg/Fn4Y2wQuX23syoM2c6+GUT9A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-a5vc8--tNsqvWcA7wlETgQ-1; Tue, 21 Oct 2025 11:00:58 -0400
X-MC-Unique: a5vc8--tNsqvWcA7wlETgQ-1
X-Mimecast-MFC-AGG-ID: a5vc8--tNsqvWcA7wlETgQ_1761058857
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4284525aecbso2495058f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058857; x=1761663657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lRubUKoIKZa05nEVw7UJ7l9fUFkh873Slwn5354MkBU=;
        b=scNxwGE+IbIfV9QPdDOGvjgt3eFXMOyMCAfWeHnfm0ahBuo0bGLlqi/aIkYPrgNKMu
         /LnLRqxzLdjgO1DT5OQkgDn2RqorkzIcgVilBr1+LdCs2Q2/hOEXW+7y5zBa90up5kkk
         fN/FlsyRoALoNp3130eumvZVshSnrLheprXV1fBoKmbG5yeq+uc6aR3QDXFlh21Ioapw
         YUnTWWzfwF7O39UkAHb2HqrzhKwupq/65dic02x0hbiu2UIg3YcZhfN0rB37UcwwAXP/
         ThFGNeRm5qDH71IV+InZcUyl3jExvNGSFgq5ABXswUrFm2b0eOM1RvHl2fvzxYVxtEYL
         pE7g==
X-Gm-Message-State: AOJu0YxOjyXiR5pBb9E3YGPbMu9W69fxeiXnfZJysI3BDiXRd/B6+V/L
	PCb0Seo8tQ0bxK7idbQGATydWYoI8mPaTEH3CgKWNIDFZo+SDyXSjArloK+u0InBWWfcSpyYZ5U
	GtYgDdDRV7aezQMatv3rJGP/0hAuhn6BTxbmtSsxeWLWaoLABRGPz
X-Gm-Gg: ASbGncueRxZfYvdN3d+g0aNE/Z086b6lw7hqcw3HgmpyZD4+barNYFsLI7s0BYxNsMJ
	nKDYgaOeRxkhEzm5mRf/T6vjvlicvwMOIwTZoSFvuzW4OVGmPmk94dKyd5604edFSFMsvEzeQru
	0EvinGtQqJLgXDRKLuDid5MuC3bm0AlMWmkVtmdR+XMO8uy/U5uzgWbAcNB9FD1rYcGLXorVEkw
	rPIlP6mzN40lGeQRfvV5w5Ppvl+xf11VPjNwn6AOlwP2JhIcrxjnwYSKLvGN13uiZM48EofhILc
	XB7Jg7Q+G3IZjOBhJYfJyqfN/LQyY+wtwHlr0r9McAjSeU0HwF+meGh7G5M06v8HwjeH5tCbtpZ
	Oy8IlxErqG5W9qvWWo+px1Nh4IqGgv4fa0UpqIUAV/WPfaY7NR9ZWt4x3G4dD
X-Received: by 2002:a5d:5d05:0:b0:427:809:eff5 with SMTP id ffacd0b85a97d-4270809f252mr11795567f8f.53.1761058857352;
        Tue, 21 Oct 2025 08:00:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuNdQq7IEo7xmxPaMqWMcC8QeroaNoRnXCBpBegLE0FB0KNfhJhInOomIlaVikmeTIuzyODg==
X-Received: by 2002:a5d:5d05:0:b0:427:809:eff5 with SMTP id ffacd0b85a97d-4270809f252mr11795534f8f.53.1761058856848;
        Tue, 21 Oct 2025 08:00:56 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427f009a78csm20793541f8f.26.2025.10.21.08.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:00:56 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
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
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 23/23] MAINTAINERS: move memory balloon infrastructure to "MEMORY MANAGEMENT - BALLOON"
Date: Tue, 21 Oct 2025 17:00:40 +0200
Message-ID: <20251021150040.498160-7-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021150040.498160-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021150040.498160-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yaYQJrFvhwRkP8hm0x8Ndwi4K8b2GNftz866hn0etxo_1761058857
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 97ci5ctzu1qbpz1oid6oubpcn9hkifgz
X-Rspamd-Queue-Id: 67FC74001D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761058861-96403
X-HE-Meta: U2FsdGVkX1+34oKIgabcMim6vgvkUTE098kzBu+xS2QFQhpVrHrSnGKgeRbu3SwW50Tiii5jBpLNEFy6oyoyVOP9VZdXhtb/8hLyRrkNecwcLm6lg/l+91MZoZ3lXqL2J3UnkIyK6reCxCu5mkSRE0nO6Hkr7D1XEcIvHW/xH7nTwOnccUpHSR8p9ZeBu9V8Exoge1QBOmc2fNuu3rvNtFw2q14RZIBa7yLSlq3dBtXDIJNZ7mK1+3zLcGMFHxqTqlJVdgDSqWayHH+KWNAX0JYIvg3MerDFHeQixj4+r2v3jv1YgEisW9PCxpyDsADrOM9c5XF3eJKJcVbcb/ST9/Z6N/RqSQ1LAhro/yxu6x2nv9gwuRs95o5d7gsIwpYa2RPUsqro0HFZJyU3BQny0fOK70oqhY39Eac2xIfAdP17uRDJ/ByKKB9n6pnKrcj2mnTw6lHxrUdMmHHOlYOVc3Febeb1NeaKJaXt5AcfULW8n0InfB5HsRSmjIg86BS7TN3l+t9WZkQR3jD/iKunNGaUT/8sqH482G0ybd6G/J+oqLTUpblvpTuVrUlyqrcwTy5/9p2S2vIH9wl6/1m+UouGoXS6ZRrg27Ibe9o49ywUl2QoRTqXZaZQ3Hq48Iw9fUaW8beFCmvTCrW6dEs825rbKLA9MymytHzyHmBu6/GNvXp1cy7mk+W0CL8gGUDEm/bAtdL05eHETUoTpJ08/90Sw7ig55dF5Az5JolU8XncL6Q+nhn8wAFsaG1ZW89BtOVGHiQDdpLZNNLTn2G79k+iOchkV7BQ8NbVmrUfs5lsTljZmKYOvnF+Fjiu9ROhrjL4gflxsXvoQsA18wtxEU4UvvGdWz3LtVV8gRz0SNzcjit2YPcCViA2G33n6IJ+q+3DypmwNiaBWudtXGu4Jeadinbi83Ljn5V6w83UFAGGl6YDORT/dRrYPjMGI7wTQo9/kDjHB8QwCy3z18q
 0Bzd6y5t
 oANHvee9irhRh7g/9u6Mq85QX1R3UPXzIu0c/UTrkMRhb3MrOKyDY60zuk5X5M/W6CvbCioJe7AN0+iZNZr+FssPPtDY1mzUJ/+J9kB9Ggn2s8BJnIaP8CliTUGZCqB9GKfwbD25nImtW4vHx61HqFxqVArAvP4CUq/S+/puTeR9DbSK6OYnE8TCmive2d881DmfuVMrk5HE8A8e6BHdDheZVw+Sl+iRVVovIomjwbMLeazGEjoivqkrYoe2qGBI+RjMJ4kpds4IARKK1Pl5iC/zLpXhAFw+3G0X1w94QXej50nqBenQmVNcd4vZX5gdDLJhwlnx6VyXNib0LJb1I6Et1n41SYQ7D8rvzItNfx+lObouMgAGkIS6fEKZ/fe3AVwJyJ9V6BC+3fI/ts+4m8BYeB8nJ/1E2tFm/VZnquaPzSp6QJJpcK2IWBmCQTtTKFdFoofgT5YWKLfY1QO6lgeqImPsuG4oMlLH2GeC+P2B8FLbVxKYsibbDZqD5bsG7EikaaF4WPl3PAajfKeAgpbwZixe2ugPfGnMjvRgxFc9wFZ/fofheqoKX2R/RR2GeE5XxMkeSajqmp+xKn1zRiluoebFUOYSwu9JEq/qTsLnoe8SgnfHayGROVPR2CRTRawM1m0ARWG1dDGmkUihrlqqloZakrX3z5CM2w2EXp+122YbCnNj+Po639npgu3tbIJmrRkS4TEkvIpt0ElZE59Q6X3Zu6C9KZTnpGITG4txkufHGOckcrRvFvWqoaNDldsBXAzlu2t+ywrh+reOPkFHHSl1yPJLYr5WwlQR+cSKeLZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nowadays, there is nothing virtio-balloon special anymore about these
files, the basic infrastructure is used by multiple memory balloon
drivers.

For now we'll route it through Andrew's tree, maybe in some future it
makes sense to route this through a separate tree.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 MAINTAINERS | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 878e53d0f65ed..17fbf5c1ea2fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16225,6 +16225,16 @@ T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	mm/
 F:	tools/mm/
 
+MEMORY MANAGEMENT - BALLOON
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/balloon.h
+F:	mm/balloon.c
+
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@redhat.com>
@@ -27062,9 +27072,7 @@ M:	David Hildenbrand <david@redhat.com>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 F:	drivers/virtio/virtio_balloon.c
-F:	include/linux/balloon.h
 F:	include/uapi/linux/virtio_balloon.h
-F:	mm/balloon.c
 
 VIRTIO BLOCK AND SCSI DRIVERS
 M:	"Michael S. Tsirkin" <mst@redhat.com>
-- 
2.51.0


