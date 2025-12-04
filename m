Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 887DAD2168E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121126B0093; Thu,  4 Dec 2025 10:10:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9686B00C8; Thu,  4 Dec 2025 10:10:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A7F6B00C9; Thu,  4 Dec 2025 10:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E1BC86B0093
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:10:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A117A87FC7
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:10:16 +0000 (UTC)
X-FDA: 84182124432.30.520596A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 21DAA120012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:10:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fnlhDcbS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764861014; a=rsa-sha256;
	cv=none;
	b=uEZb1VuyhdnMcfj9aZLB5TusMSG3bCrW0eBwVdLJkA/EZxjQ/JebeL44v+sIpoFiosF5q2
	mpqz5nLY2K3U8JoKfrbllbvGFfPHyuyYLxzPFYdY9mRac3zyT9pOHlQVkNtZhVuPqxo1Ok
	utGa69JnVjO3x9MfdMqMYuH0tE1udHw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fnlhDcbS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764861014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shBKdGm4YTOEDFQeXrEUnQGLwKuFe6yb6HVy/vXuL+M=;
	b=4sS54IFgAM9Yv7TCUeWYqCMV3bJJR25pbQ3hE3rXG6UhbasAn84VBp2s+QZLoUbQl2Sc0W
	cls0s1209b558JOSUq2sSHMbxnxzzrFcEm/d4Rw6TjnPX3GbeFNOk2mskiWzqvaR1Qnto/
	5oZfB3coH3P6i8U5evaejd0Ef8xexYY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=shBKdGm4YTOEDFQeXrEUnQGLwKuFe6yb6HVy/vXuL+M=;
	b=fnlhDcbSe/rAhIIl0IpsD7M8X5mCmVf/+XnKgGoG15CWpkrX1j+pBwdYDGo2sV5PUoKN83
	oFOV3TOVR9iJgIFXN11NiJHR3whaX7E8IDUb4KeCvXy2+kjdyOIkUOuG6fQfSaBxQiwNcN
	otNdm4WDBx65ffNtwtOIYPRUj8TViQU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-4ew8HcUHP86uuDkxI4tKoA-1; Thu, 04 Dec 2025 10:10:11 -0500
X-MC-Unique: 4ew8HcUHP86uuDkxI4tKoA-1
X-Mimecast-MFC-AGG-ID: 4ew8HcUHP86uuDkxI4tKoA_1764861011
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b22d590227so128807085a.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:10:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861011; x=1765465811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=shBKdGm4YTOEDFQeXrEUnQGLwKuFe6yb6HVy/vXuL+M=;
        b=MRRPEOgu0RNom9zJ18QKmPN43xly6OBdLH+3Z6XJ+7j4pIHoBrEy8sbMoTXEFfVwnS
         LYwJ3JerOFizT8QKbE9KEA6GPceGefkrWSYUAuVQaLFrQlJD0nUqbQ7mG+ZNRtUMAsDu
         K6nbRG+GJfV/cPZ1ZjYykGA6LutEy756wQyRopm6nZFb2PLde2PEHu8SogSLatakE8R4
         U8mu7g3+/KbB/aurbYLtLUbs2E8x1Vi4ad3ZmkXu4slDsaUSX5YdN4TI4vjQ0jzLytIQ
         zf/CT4YmfdJ22THffVCHobznCSa1RHot88lBdNx/NLSHoTvt6a5dYlOcnhsmDTre5VXH
         MoTw==
X-Forwarded-Encrypted: i=1; AJvYcCUzZI94C7017WnTf7o6ZWadhwfuj7sV74wssG82HCTSiq8cJtxs8dtY/8MtJ9vuTXkiD3O8PukDNQ==@kvack.org
X-Gm-Message-State: AOJu0Yxjmo40rG8yj1C3e61SNW5p+P5Eb2GEUrSxKj7GPEVoT7lowqXy
	inXwoKpvqr/C1BojT+kNtUIjHtT+JJ3NQm77lyCjsF0Uv64uf+yfNG6/k1kmDZBg2nUmSVBljmj
	GVmeKVYe3diy1McJsird19SsRwUgKIN4XoF/taS3fTB45EHPN+pUx
X-Gm-Gg: ASbGnctjXN1m9mfql8/jL4cwIzYG9ypuBElWESl51B2JdKDHxnCshzrShUF9dxcTMtl
	A9YHlOkcC8AvmNe++mE42KBdFDJ3jsbZNQ+oXCB2ylVN638gqSBOCgbE5560zmOPfNiwSRLpWGC
	TEFkHASN9l1vefhfod4iuNrCaVPTuzo5st5LcIcIktCct+q+sVLXcoPCJkayuPWS9zQ0mTUJjql
	SraV19aYTLJRSwKjS6XzGMeFlsC4E3VUNJ3wzw7t7kK7dwm0xi4U1xb2RjpBp5zExP+LoqWn9VP
	XTTXOIGR1Z/ls6ZYhw+sW5rJ5PG+DKVZ4jurTp/T7+wPiouWv5076zRqZPMOjUdozQURZIhU25c
	+
X-Received: by 2002:a05:620a:408c:b0:89f:52d:8560 with SMTP id af79cd13be357-8b6181ed8b6mr519469585a.47.1764861010540;
        Thu, 04 Dec 2025 07:10:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUYHhbX8YMXNGXZOpMbNo0BJJ62y/raaT2i4rcEhXIK6eeuVSL9soO5R2l6I/8tLGphH/NCA==
X-Received: by 2002:a05:620a:408c:b0:89f:52d:8560 with SMTP id af79cd13be357-8b6181ed8b6mr519458985a.47.1764861009954;
        Thu, 04 Dec 2025 07:10:09 -0800 (PST)
Received: from x1.com ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b627a9fd23sm154263285a.46.2025.12.04.07.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:10:09 -0800 (PST)
From: Peter Xu <peterx@redhat.com>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Date: Thu,  4 Dec 2025 10:10:01 -0500
Message-ID: <20251204151003.171039-3-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
References: <20251204151003.171039-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SabKsAwNLCA19O-WVILqJC44CsDmh7GGWTFwnO4itQg_1764861011
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21DAA120012
X-Stat-Signature: d1qf4pxu577rnjydz8hc6h6cuthfstej
X-Rspam-User: 
X-HE-Tag: 1764861013-172237
X-HE-Meta: U2FsdGVkX1+ICQoDgSdARdP19nyuFUcJeHaG7vkXjIXp0MYZmA4tP/PSX4rBdwt+a3iTN6sAdEPLkY+omB698uWWvIL7ul8DxCQ/6jAgN22rIvU7l8nreA+kC+PRRRGWWNG6yp8OC6AfgPxdJj8GoORY8xeYj4lApPxKYLS10+xYvrl6iLEo4D1nJU+eLclUlfX/Lgi54Zr/hLGeMrQTu41iCMZNKLKVXkaR4FkiCFPrsLOuVrzhainOQF4KO6aJbcnE89dxz9P6yB3pvwEK9I+z2mki8WBx6zHaGimiaQh9bOLFAPN02ViB9pJB7sFn4JWGvY+gCeXjapNNVaMHm7Bez4QuFF/CB6AJx/5hytsdodMNtmhj4veEJLkCZ+Kd439pYUkgwOd+Lrbh5QVOaHp85hnTKFuob5PSNNdYG9QG4MvJhHhRARKq5AadW4/bWx1Y1Mi3R/8QyBsASgvCq84sl/g1OsTM7O3Fh79//HDqc2MpiuXfyIYhOZloHJdk5dhaHSDg018vEl5EthzVBecXhKNYY3FSff1ziQ90it/xWpoVEz/0kaEqcKMUrpn8EVDnI8N2TDlD69y70kylNaaQybeTztdLHlcD4W1pSzf0AZKweIXMs1Or14swSkHdmTFIHmI0536JvFrtYoYVtTmtc1Zn4ybEvwQg/R7teR+D1yhod7fH7Baj4QmrM+ph2CPZepBo8hIYQSEzKGXd9oPbSqlKuF+3GFhydngcb3bSVpXPY53TC3AMXjuqv5Lu1BXf3Y5LdSCYAS8cGl7wKRm6kYa98hdDz0MV86PT1MD35BIoBSYPaQv5i22Qh4htEFI+7To6+3ZHkJh5ND3/PSesoY9Iby3Wq65wSGRcBu0w+EORiLvVdEMRcraQgcltFnjEuB6mcPdS/QW8wnpjyXcW8F69iig9rmZBeHfBhJXRv1Wy5JdFhjo0KpwQk9dqJdW/r+72QfblBIosYVr
 Gn3pkMQJ
 Oru8cLK7wQJgXzyVbVf+6vqdNvRCs0vVrNWUSo5aLRT94MxpJA3zEiVlhjE26dEZX9pO5n5+/X5PrMShmdM9RBGu36dOm2THoZ8vjBPNLq6+umr6a/mmIMMTidKHjtdoNka9NI4Esr6jEqc8op6/uz+CoBWIuLOJ84ovpJSkowrFi+8WJojbphgKT4PyT+oXBQKzhRtLsv/20Sn0xkhXZ7/Ne7BLTqu9u6zkFgabd/SdklxO7D2uEjNGy68/tUoGNdLcvNq6xfGHvezSILHc8YsqEQnVsOeDiIsoHfe3R4Y7UodxSy+UY9/5OIliBtzzvjalnq98+alfo9W9CraJH3Qr79di94C0VXFmD8msj4S1d7w4edfNvSWIu3fyEhlVkg/vigHSs4wEcyOY2y0Q8CLWpz7YLN7cs6hld9KJ8IwnIrRgG7Ip+4dVJazDX3IizVxwPzUtcK57gd1xhfLdYk+yCy8GWW1be0RnaD+7ue5rZ4Winp7VpsXYPmnWx+MRh0hJ46zms0jQcZVipcqiyz5ZBHSljRfGs0sMK7MPmLXf0VXLsS0Py3aFYpnDbhZhKbLkYwkTOaEKbQQCMr8HHU8JuGyEpxA3XUu40
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add one new file operation, get_mapping_order().  It can be used by file
backends to report mapping order hints.

By default, Linux assumed we will map in PAGE_SIZE chunks.  With this hint,
the driver can report the possibility of mapping chunks that are larger
than PAGE_SIZE.  Then, the VA allocator will try to use that as alignment
when allocating the VA ranges.

This is useful because when chunks to be mapped are larger than PAGE_SIZE,
VA alignment matters and it needs to be aligned with the size of the chunk
to be mapped.

Said that, no matter what is the alignment used for the VA allocation, the
driver can still decide which size to map the chunks.  It is also not an
issue if it keeps mapping in PAGE_SIZE.

get_mapping_order() is defined to take three parameters.  Besides the 1st
parameter which will be the file object pointer, the 2nd + 3rd parameters
being the pgoff + size of the mmap() request.  Its retval is defined as the
order, which must be non-negative to enable the alignment.  When zero is
returned, it should behave like when the hint is not provided, IOW,
alignment will still be PAGE_SIZE.

When the order is too big, ignore the hint.  Normally drivers are trusted,
so it's more of an extra layer of safety measure.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/filesystems/vfs.rst |  4 +++
 include/linux/fs.h                |  1 +
 mm/mmap.c                         | 59 +++++++++++++++++++++++++++----
 3 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 4f13b01e42eb5..b707ddbebbf52 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1069,6 +1069,7 @@ This describes how the VFS can manipulate an open file.  As of kernel
 		int (*fasync) (int, struct file *, int);
 		int (*lock) (struct file *, int, struct file_lock *);
 		unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+		int (*get_mapping_order)(struct file *, unsigned long, size_t);
 		int (*check_flags)(int);
 		int (*flock) (struct file *, int, struct file_lock *);
 		ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
@@ -1165,6 +1166,9 @@ otherwise noted.
 ``get_unmapped_area``
 	called by the mmap(2) system call
 
+``get_mapping_order``
+	called by the mmap(2) system call to get mapping order hint
+
 ``check_flags``
 	called by the fcntl(2) system call for F_SETFL command
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd3b57cfadeeb..5ba373576bfe5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2287,6 +2287,7 @@ struct file_operations {
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+	int (*get_mapping_order)(struct file *file, unsigned long pgoff, size_t len);
 	int (*check_flags)(int);
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
diff --git a/mm/mmap.c b/mm/mmap.c
index 8fa397a18252e..be3dd0623f00c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -808,6 +808,33 @@ unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm, struct file *fi
 	return arch_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
 }
 
+static inline bool file_has_mmap_order_hint(struct file *file)
+{
+	return file && file->f_op && file->f_op->get_mapping_order;
+}
+
+static inline bool
+mmap_should_align(struct file *file, unsigned long addr, unsigned long len)
+{
+	/* When THP not enabled at all, skip */
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		return false;
+
+	/* Never try any alignment if the mmap() address hint is provided */
+	if (addr)
+		return false;
+
+	/* Anonymous THP could use some better alignment when len aligned */
+	if (!file)
+		return IS_ALIGNED(len, PMD_SIZE);
+
+	/*
+	 * It's a file mapping, no address hint provided by caller, try any
+	 * alignment if the file backend would provide a hint
+	 */
+	return file_has_mmap_order_hint(file);
+}
+
 unsigned long
 __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
@@ -815,8 +842,9 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 	unsigned long (*get_area)(struct file *, unsigned long,
 				  unsigned long, unsigned long, unsigned long)
 				  = NULL;
-
 	unsigned long error = arch_mmap_check(addr, len, flags);
+	unsigned long align;
+
 	if (error)
 		return error;
 
@@ -841,13 +869,30 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 
 	if (get_area) {
 		addr = get_area(file, addr, len, pgoff, flags);
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
-		   && !addr /* no hint */
-		   && IS_ALIGNED(len, PMD_SIZE)) {
-		/* Ensures that larger anonymous mappings are THP aligned. */
+	} else if (mmap_should_align(file, addr, len)) {
+		if (file_has_mmap_order_hint(file)) {
+			int order;
+			/*
+			 * Allow driver to opt-in on the order hint.
+			 *
+			 * Sanity check on the order returned. Treating
+			 * either negative or too big order to be invalid,
+			 * where alignment will be skipped.
+			 */
+			order = file->f_op->get_mapping_order(file, pgoff, len);
+			if (order < 0)
+				order = 0;
+			if (check_shl_overflow(PAGE_SIZE, order, &align))
+				/* No alignment applied */
+				align = PAGE_SIZE;
+		} else {
+			/* Default alignment for anonymous THPs */
+			align = PMD_SIZE;
+		}
+
 		addr = thp_get_unmapped_area_vmflags(file, addr, len,
-						     pgoff, flags, PMD_SIZE,
-						     vm_flags);
+						     pgoff, flags,
+						     align, vm_flags);
 	} else {
 		addr = mm_get_unmapped_area_vmflags(current->mm, file, addr, len,
 						    pgoff, flags, vm_flags);
-- 
2.50.1


