Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32FDDF357DB
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6876B0095; Wed, 25 Feb 2026 02:20:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5C16B0096; Wed, 25 Feb 2026 02:20:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E386B0098; Wed, 25 Feb 2026 02:20:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15A156B0095
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC7241A030D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:52 +0000 (UTC)
X-FDA: 84482131944.10.7045355
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 09DE94000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=odnQkjLL;
	spf=pass (imf11.hostedemail.com: domain of 30aKeaQsKCOQGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=30aKeaQsKCOQGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772004051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OzVXGrSvNTobLr90pUtUa2BKuGgT0v7RjuQ020m/80=;
	b=BLtYrqQUdRiQPnai1yYbwcM5EUpDG1RJ7XCbdnXVFwKMB72ZDKrm8TMUNvbll5C69IhswG
	lqmF2n1sPSVVMbgIDbQAAlXeLfAjxfZqB6oxLh5Hq2TbWKyFtqgRdkt1HTDqxYsxFodZv8
	vwX7RcQFxFSGskS8/p/ah6ZCt/KXSFo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=odnQkjLL;
	spf=pass (imf11.hostedemail.com: domain of 30aKeaQsKCOQGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=30aKeaQsKCOQGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772004051; a=rsa-sha256;
	cv=none;
	b=S/dsb5ZL1xSzzK89juRB7dWD78pyN7Muj6sYQiUQMANsGw1mP72nr/6he3wX5dCvMuVcts
	q+vTl3Df+5lUWAb+R1f7P303Q4rAlAuvvR/VV2t0ldFigLhr1zJoroh/hsatNlaNUGv6ce
	+cnZP1o1xJsnco9QV1DBBF8uB16d0As=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35449510446so6417918a91.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772004050; x=1772608850; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/OzVXGrSvNTobLr90pUtUa2BKuGgT0v7RjuQ020m/80=;
        b=odnQkjLLnmXoWyW0sJ358VZ2AsdtuV+3IGSljwlFnF4cZB5cska6JPEBLwXnsQYaQ4
         wD9QOOREa0DckYZGUJRoeSd5GJ9lHkdbLCb4gdWdrcCqjQpDvYsdx2oAFxw1Wc+rOZqu
         yHt9GYBQrE0k8y/xPr8yyLPA9UDsu3qov2zYaJg99vz9OwnTOO7V1eV323uzwJY2VM11
         7yb4iaRfRzlcbKEa+M9DeJbFEg6MZFdxjVokuJSx2ili81Xjd7fm2Z7EVpqJwyXrDPMC
         xnxhpMJhbvyTjn1HLUSO8JNyKS7raegYn4ni65geX2V9mNwsKXiG6smuZ17QhHJjwDxZ
         00pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772004050; x=1772608850;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/OzVXGrSvNTobLr90pUtUa2BKuGgT0v7RjuQ020m/80=;
        b=Sc4SrD6w089jTIEy/uIC4wmU8PnVTbW0571wmsR4eWzShvDVQbPcRVIkJIgj4o3oU7
         94PRNnNLH6hWA8irjQHbIStUTJkmFBZkruE9psC0Qz8G5giDL2+FcxBYbCbEq5IgPE6G
         mPK2LKollN4wl9pDhr/b1mvclGGcRsPtYselZPLnr7idGECGvVCko8OdS0SleOYVFpph
         J5HRtd9NmoM6kYmxHcRXXkPKAchFU4FHDy+7ASQZ6Tx/s+wok8ApvRJOICQ8vex3njHh
         bpxvGNa1A/ntYvAHBmyDoiwEc15sknl9SSYBhY/Eomsc6REgZfSs4ee9XT0afDutt02Y
         93Dw==
X-Forwarded-Encrypted: i=1; AJvYcCWuNt1PJS2M30Dn509yHvZoI+bu6wwTwi/A0g4PU/qLqszHLhvLl0I60prmfuZaJhtd5NgfxzeH0Q==@kvack.org
X-Gm-Message-State: AOJu0YyE4HXqNF17RsANXO0vvp10Ey4ELDscX5hqlkVYMplQPgX8ap41
	2P+QrSMeCmFYNM5ihjOOyLjPnx/nJpFBIkr12BjEbGHo8S1MQwDsbttxg+aDG9e9IAvnzmKsmco
	AHCF0to0MtcVIRkcjkMSNVGTtWQ==
X-Received: from pgar14.prod.google.com ([2002:a05:6a02:2e8e:b0:c6e:4387:496a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3297:b0:35f:27d:2ded with SMTP id adf61e73a8af0-39545ea8a07mr12406592637.25.1772004049471;
 Tue, 24 Feb 2026 23:20:49 -0800 (PST)
Date: Wed, 25 Feb 2026 07:20:38 +0000
In-Reply-To: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
Mime-Version: 1.0
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772004043; l=3726;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+MHXSU/V11E98W6bAwMdpmIpdBoJLEJvOCREqpfDnG0=; b=KKEMJylkZyQJS+IxTxG9HS0TUG+xGT7E9m0Nde3MM1Szh24vjYNbYhe+Zg9jWgMOtoQmg2xvM
 IBdn2AEimOhD80lhpH2xrQdgnNMxZuX0jFXVYJErsuwoepz+kV933x6
X-Mailer: b4 0.14.3
Message-ID: <20260225-gmem-st-blocks-v2-3-87d7098119a9@google.com>
Subject: [PATCH RFC v2 3/6] fs: Add .unaccount_folio callback
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 09DE94000D
X-Stat-Signature: pmchsuw5ki54mnzsxeehpwg36999d76m
X-Rspam-User: 
X-HE-Tag: 1772004050-50770
X-HE-Meta: U2FsdGVkX18tWK22sfKmpbGNi5j/N1ztlJNkU7snUo8blQWC3WsyTuDr5tzG8rr2QgWIEaBCBbMbL/mFqSxchEr2mqo0FOVkbqBCDDxPU2Pgds4RThZAhjpeiBD0cq+xszmb1K3lKg206TgnV7Z08fZgFv2zlqwhNHu9rMHsVxCYaO9dKSbBqQriZKzYvapx0t3OQaeU0YA5NT3sXQwShDBOoXDWWRt3tScVCjYD2xeqaDPWuWVKov4wP31AmCcDvOZdfYZwKuRz+yX8xxzOdUcUk6dAHyxUoIRkyXmnrjCjRL7zdnpYdlHoDtl2ti5EbkDnyzON4Uwb54oM4umPqJuwR5OY/DxrN4nMdxy+KAbJ1ADNLZyZsHMvFz2afFTmPOOOxVz8YLfa98jzGMJjha4C7x8dB3RdrSsgh88KtWr3ZUCPbEawovnqXECfE02w8ea6E79FARuv2JOQ4LlBS2hHIkQXUZvWDcgAbg/g8OhIv6JxyZJF8g8u3cNrhiFriddvNWWZl3BI/EqgNQ0ze+rVSB7VcSn2UulzYPh3a93t83J7n6LchZTZbn+MCjWeO/0dcG0oMj58ebkrDXSKCV4mnGWlG2nPI6IiAVYUTbUEGQ5+gMnAMhCGiZhblgd7Q4GPxPsPnKeWrgjyhNFZQ3OMvKEmXjBwxVQiiAnUwE1y1HkkoO3ynssFYtkQFn9OX/Q75yUDxnjUktGsRS6bKFmu5pCPKfaTjEH2wX3QOWfIjPKs9TemyFjX/wXW/NJfsug9C6dS4mmCa7yJSIdIHpma81YOzcfAOBCIGAAW/F7JOjdmDeI1/fzhLDNODprB90EifPROiX8eaS96qJtRYxLpQTqWyod0oYJvk8qC08fk1aV5nHs3bpPdC4HeYHlmNwv/CsI+1UX25Se+c7chmACZB9Qv62zU8PYG8Qr0LOIErfVV+tiwEcDphOSIrv7XYwO+LshpMcBR6UUUCpr
 FspEn4GC
 5u7P1+uUN7rDQmfhuhmxIJ8m4c9x97d39eWKeOpENMIzEZXMS9443JdExI4mAQBY61rBQS4XChOeDVzHSDBvuoqbiu5bdeA0eezX/e4Zf0xxSPdIehWxGRNoV7oUDotIxfCK7KniOxqypyKLWiEVd5WiIRJwWqd7aX/wbpK11onkU8AQSlfdOG16rTxi/75tTsslCySy/HvCsqCX3gGyjXr83FhH35oth0lzZW2/n6JKB6KYxuUeyPbCh9qC++Jpxuphjen8QLZHkDC40/ADI8j8DNKMvi2uv9IBlxAeIkF1erWESNwT4WJK98FD5ktgD34V7Sdc4eFWV2D4Nivsr/tBnn5KL1nI2MCXXypH3EVjQRcdAUmS1pLTSduof3PSUBDmZxcR/TeciPbgEl899jWNdTfO3hyfuKuwcyu8VmTId/KuqSlirTcQBaha5LRP6iAovQzW4ORWjaKwr4lrXjWV0kVSHhp6VcACGDSptdZUcEIweBTcGRMNpVK94tCC/MQ/e5gXozDnYITCukeDvOe9BNsZJdVb41NdT6NqonPty9BpU7h7u03E2iL/9AVqvazvnfy5a34UPDyJNcIQKr+fk958tGwhbPfJF4lmyw/SLZ9NF5AISK0JSzoJdtYLRNUnHZNAr+jygKre3k+yU1EGW8LRqkzjC82gFhAECVbJtq7LdRkRGNcw6xF4lPKjSf3K7gaNzwfYOBY36dCjMYR87cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add .unaccount_folio callback to allow filesystems to do accounting-related
updates to the inode or struct address_space mapping, when the folio is
about to be removed from the filemap/page_cache.

.free_folio cannot be used since .free_folio cannot assume that struct
address_space mapping still exists.

From the name, .invalidate_folio and .release_folio seem suitable, but
those are meant only to handle freeing of a folio's private
data. .release_folio is also not called in the truncation path.

An alternative would be to add a more general callback and call that from
filemap_remove_folio() and delete_from_page_cache_batch(). .unaccount_folio
was chosen as it is more specific to the how guest_memfd will be using this
callback in later patches. Also, .unaccount_folio only needs a single call
site.

This further refactoring was considered:

if (mapping->a_ops->unaccount_folio &&
    mapping->a_ops->unaccount_folio(folio))
	... do generic page_cache unaccounting ...

but that was abandoned since a hugetlb folio may not have an associated
mapping.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/filesystems/vfs.rst | 8 ++++++++
 include/linux/fs.h                | 1 +
 mm/filemap.c                      | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 670ba66b60e49..5ed5c43d5768b 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -809,6 +809,7 @@ cache in your filesystem.  The following members are defined:
 		sector_t (*bmap)(struct address_space *, sector_t);
 		void (*invalidate_folio) (struct folio *, size_t start, size_t len);
 		bool (*release_folio)(struct folio *, gfp_t);
+		void (*unaccount_folio)(struct folio *folio);
 		void (*free_folio)(struct folio *);
 		ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
 		int (*migrate_folio)(struct mapping *, struct folio *dst,
@@ -967,6 +968,13 @@ cache in your filesystem.  The following members are defined:
 	its release_folio will need to ensure this.  Possibly it can
 	clear the uptodate flag if it cannot free private data yet.
 
+``unaccount_folio``
+       unaccount_folio is called under inode lock and struct
+       address_space's xa_lock, just before the folio is removed from
+       the page cache in order to allow updating any kind of
+       accounting on the inode or address_space mapping while the
+       address_space mapping still exists.
+
 ``free_folio``
 	free_folio is called once the folio is no longer visible in the
 	page cache in order to allow the cleanup of any private data.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a01621fa636a6..c71f327032142 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -422,6 +422,7 @@ struct address_space_operations {
 	sector_t (*bmap)(struct address_space *, sector_t);
 	void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
 	bool (*release_folio)(struct folio *, gfp_t);
+	void (*unaccount_folio)(struct folio *folio);
 	void (*free_folio)(struct folio *folio);
 	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
 	/*
diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a7..ff957929e6087 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -176,6 +176,9 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 		}
 	}
 
+	if (unlikely(mapping->a_ops->unaccount_folio))
+		mapping->a_ops->unaccount_folio(folio);
+
 	/* hugetlb folios do not participate in page cache accounting. */
 	if (folio_test_hugetlb(folio))
 		return;

-- 
2.53.0.414.gf7e9f6c205-goog


