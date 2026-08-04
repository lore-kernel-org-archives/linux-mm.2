Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC61C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0C46B00DD; Tue,  4 Aug 2026 10:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88DE6B00E0; Tue,  4 Aug 2026 10:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1446B00E6; Tue,  4 Aug 2026 10:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96C696B00DD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:32:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59494A0136
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:43 +0000 (UTC)
X-FDA: 85063457766.21.3568CAD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8FAE910000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XE9S42x0;
	spf=pass (imf14.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785845141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnnVy48ydCXauSW+w5ZraHIy4YMvaYkPwdBxROmLWeM=;
	b=Mggp8fcf9+O+Umq1wOjOXnx1DzEAQZxOowqicxNRwh3GyZmdt7/xN+GYypDT31qlcV8/JS
	Mce0yPqiGMa3uG+G0aMOd/QnYG4kNwZmtimvcw996SU8jMGyCbdW5Xp6BOm0yFcShvbKBF
	HI4411vLz9xH+/dKetu8m6GT/Jf/5Ao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785845141;
	b=BvQFq/cWPXhL146umqNa2M+IRg4A6hd2lm/z/G6i/ixY1O5ayyaIvaAK+lT9LI2IRLJYmb
	1xdkgKhYGb8THrq5CMAAw0DUNX1/M5L9xUc2OaB0N9AIJjyJigkAC1Y6+ZaouO0lG7u+Dx
	9DAJ5qhjsA3JXaNpya6Ki1g74anIoag=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XE9S42x0;
	spf=pass (imf14.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785845140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VnnVy48ydCXauSW+w5ZraHIy4YMvaYkPwdBxROmLWeM=;
	b=XE9S42x06ZTsevzjLgayCOkpJTy0ApQkOUItzo5EktVVJqG3LBQtkVf936jzUQBfTa74ed
	zmh9ClLICNxb1+TvuG/kdB7O+vClwYlKpG7qj5EY4rpfxvTdPGaecAF2kCZyTyH3e6x/di
	QTwc3xGPsmP8mE3qur2ke9lCYDmoUn0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-Oc51kA1aNomhBlHMKPmlKw-1; Tue, 04 Aug 2026 08:05:36 -0400
X-MC-Unique: Oc51kA1aNomhBlHMKPmlKw-1
X-Mimecast-MFC-AGG-ID: Oc51kA1aNomhBlHMKPmlKw_1785845135
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4955843c6cdso29383405e9.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 05:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785845135; x=1786449935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VnnVy48ydCXauSW+w5ZraHIy4YMvaYkPwdBxROmLWeM=;
        b=K8EuoLQMPFTePO3xWpZSUBWPR+/cR6puuHccR8RPltu56VOFiqZAAHYMjwVUjL+Ksx
         m/ifF+UXYn5dYDezCKICnBMK3s8CfScP886It/n6SzmeldNFzzIaCQWkS+8w67E1p4Rp
         owOFxQxQaiA7vjoqIiw0tJ5qnyV6HIlLpH3YeDGvU26EZxMhe57cGKm5FqNE8Bs2f78V
         GvuAU1yTV6NUIoeI9X/KF6Juf+Id6ii4LsgNt+Oq1V/1djRw342La/gERt+22Ae35a7t
         RuP+vgefhQVJV5rKYWnbSZ1NcwIgk+5cCMz3Ds4sgOQv02sJDikGh5PBaQ4ZX7bRBbPS
         qVRQ==
X-Forwarded-Encrypted: i=1; AHgh+RoMS7WERgO0uMOcf9IvQkbK4+EUOnQkzCLXeQssGLmQv8HoKATxKFH9eUlIuW9heB5xViQ0boEzLg==@kvack.org
X-Gm-Message-State: AOJu0Yxz94vK57MUsG9Xf1YtBmQFbOwfclzN2OAeEtKohwPQI9eKiXvq
	U4C8fOf8vEVKMrFf356JdUI2xuolB+mg9bAHs49aoN58tmdLomaNX8hUBWXLmfB6RZ6cBAdnxt6
	GRfAFmh+Oh7Fr5F+BDsSKSiX5fiTa/0E2DtJVpKR2cg4qgsJv44hW
X-Gm-Gg: AR+sD13SBAl2u9nADLebSia/OtuGsUkBroWUKp243CXE11TtsCQv38mLA7pdwMZI0eb
	//rpplqhSumzRzcIg4p346dMPlumfAFJByycU44g7oyytBfzq72aLi7ASjykkSe6oiNM54hFpDG
	TW1b12R/y4r3Xie7niyjsOBLdXuDnQTDzkT3763eSL2Sar+cVnKW9o2BmAAzTNIVTuXfdJQiOz2
	RiLLGXzZUrwSb9cloCdgnkyujVMGiqdvh2p79MiCHJy77TWI0DB8eja8n+f/YhHnFSl+W5fOPVY
	NXYTPcnIwYHqutJQqIfLUoOePiPib/Zba6ESMOqgqLaQZaPyinemzIp0rBTJ21BwR3+WLdXkVEx
	DD3ys8sH2NAT38LFXe4/CzXrJJGOGD9igCaD8jAJVrHy5F2ZN/bfgLHa3yJQuZZtUNVjJHkTcnR
	i6IWA=
X-Received: by 2002:a05:600c:3507:b0:496:cb48:5eb8 with SMTP id 5b1f17b1804b1-4980c6747fdmr217894825e9.15.1785845135174;
        Tue, 04 Aug 2026 05:05:35 -0700 (PDT)
X-Received: by 2002:a05:600c:3507:b0:496:cb48:5eb8 with SMTP id 5b1f17b1804b1-4980c6747fdmr217893395e9.15.1785845134667;
        Tue, 04 Aug 2026 05:05:34 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49949f66168sm92311515e9.0.2026.08.04.05.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 05:05:34 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Alex Williamson <alex@shazbot.org>,
	bcm-kernel-feedback-list@broadcom.com,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Christian Koenig <christian.koenig@amd.com>,
	David Hildenbrand <david@kernel.org>,
	dri-devel@lists.freedesktop.org,
	Fei Li <fei1.li@intel.com>,
	Huang Rui <ray.huang@amd.com>,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>,
	Peter Xu <peterx@redhat.com>,
	Sergio Lopez <slp@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/6] mm: export vmf_insert_pfn_prot_mkwrite(), change variants to inline
Date: Tue,  4 Aug 2026 14:05:23 +0200
Message-ID: <20260804120529.1730187-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804120529.1730187-1-pbonzini@redhat.com>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -kaEG78GgEYIwgjJSC7xg-XCHMXKwBhQk0Ztr2ANaao_1785845135
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: 5gxuo8ob64g4jz8ert1xcag4fgjsptrh
X-Rspamd-Queue-Id: 8FAE910000E
X-HE-Tag: 1785845140-886703
X-HE-Meta: U2FsdGVkX195pE3GHUTFdwaoxyRR1KvFiNu2F3VvWGxFnOUxed6HppCzRNCIv782CyIIktNI2LBJhTc+oOAsqGR8TNNmGHUDFFuHLeAiPyy4RkHHG7+/2WgilcqtUKaB7LAVEQGSm9CvO3Ytt4D0ti8adRyKKWvUbk+sV76k+prCsDOKVJ0kWkT035gkimfEmp/pTfpGzh9QEuauYuE5EbVdbFBB70qbT5tcc3cki5g1HYv4eWsGzLnHcZn84Uv2sznauDhVa/pjf3RkCPJ9yOiLI3AMQUeubW8PcB7HIJZNGGXfk1ULrXgONKJMhhpdhllLGjG7f1KihAYuu/1ZLbYOSkKe6wldQr9HRZPUQFDz+2HZXUQI9y7fzqw5/FS7r+xGv4cFpKWfae9scUfsbz0R61gU/NxmKs/6qb7uCzyfNyrXnc5k4qZowC+/hvzrlejfsNyWWLVxXmrtt6iPbo650V8IQUBoSUdnIWc/zUNB1JDgd7ndej98J57SoxYszjRD4eDQ03mUqjE7COP5ETNqnAVBEa3n1ydk5vbdWzK5ua1htDbFmIlzqT1J/E5gM9/vQsOwmOrAKpTmuz4+a2JVTFm5VQ+HkPXFMmmmpUifMU9ea+JgGkzwFkE1TcG/21ql58/6rsxPXmdCyPYE7dOh6IbmevEkII+8XVNNwn8QrsRxq/kZPe5eyqfT82BdmtZqT0bOWCVhQPvArvs2IOP1XdU4g+A3XXP1qIk6srFf1A6d6y1duFsSJ6eyFXN6LuVBwtbno7UnvgUHUcsdaOD2P92Bwl1guakneunTxaueWjiejo3W/pmcHq4jR21Cccs/+yZdl+DkPctNOlFQ7cP240om9ySMVRh2VtH5dJ02NIoWl0QSBARFYvc3Lax48XIPArHmnKMZeGt7/8Pnqy2FFLjyzveLJIXumHwtG9NsDzVR9Vq21w7kEK10noQ1wezP69Ldgo7udW+GCOK
 D6+BAcjE
 w/Jt8nCLbsDI77K9uXTv4oUuKeP9GZEOdFubjm2+RQxmRgqPdv6uOpGkZujXPaB6KOjDKh/tU8I2cgCxJvjY6nYAClY9wcC2QBNadE9mTKrH3/3uaV6YG2lUIgUh0SxG8Y/CJyTIbePvGk+ZoWPyUO2PH4pKiWaj1lmcYo6SB1tlvDVwf0pjVe4P2qhqin/wEV0tgTB859cGZS+tv0ch1WAkx/y1bzfkKQVIYjIgzwAgDEmV5wdmmTPtY8UcKHGz2RBwEZ6xZTPHclSUfYcmU7JxAOwFGiaqY/r8AZvBPNmoj7UYXqG1DadRp8UKQ23r9DT9bg+cetY6iYUXm3jGpHnymV/8VjdRgh/2fUsQGphMf2Crz3SEO9U0ouhYH/TwQHEFMFn2IjeTw6oc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Right now, users of .pfn_mkwrite() have no way to create a PTE
that has gone through maybe_mkwrite().  Because vma_set_page_prot()
will have cleared the writable PTE bit, users of fixup_user_fault()
will see a read-only PTE and have no clue that the page needs
a *second* fault to reach its final status.

Handling this in fixup_user_fault() is problematic: the information
about the presence of *_mkwrite is only recorded in vma->vm_page_prot,
which is an opaque pgprot_t, therefore only follow_pfnmap_start()
knows how to retrieve it.

There are actually some preexisting functions that suggest how this
is supposed to be handled, namely vmf_insert_page_mkwrite() and
vmf_insert_pfn_pmd().  Fixing the drivers requires similar variants
of vm_insert_pfn(), namely vmf_insert_pfn_mkwrite() for the common
case where vma->vm_page_prot is okay, and vmf_insert_pfn_prot_mkwrite()
when really all parameters are needed.  This makes it possible
to fix drivers that use .pfn_mkwrite together with
vmf_insert_pfn() and vmf_insert_pfn_prot().

Since vmf_insert_pfn_prot_mkwrite() is the most general variant
and all the others are just special cases, turn them into inline
functions in the header.

Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/mm.h | 81 +++++++++++++++++++++++++++++++++++++++++---
 mm/huge_memory.c   |  2 +-
 mm/memory.c        | 84 ++++++++++++++++++++--------------------------
 3 files changed, 114 insertions(+), 53 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..01184a4bdd6f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4544,16 +4544,89 @@ int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
 			bool write);
-vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn);
-vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn, pgprot_t pgprot);
+vm_fault_t vmf_insert_pfn_prot_mkwrite(struct vm_area_struct *vma, unsigned long addr,
+			unsigned long pfn, pgprot_t pgprot, bool mkwrite);
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
+
+/**
+ * vmf_insert_pfn_prot - insert single pfn into user vma with specified pgprot
+ * @vma: user vma to map to
+ * @addr: target user address of this page
+ * @pfn: source kernel pfn
+ * @pgprot: pgprot flags for the inserted page
+ *
+ * This is exactly like vmf_insert_pfn(), except that it allows drivers
+ * to override pgprot on a per-page basis.  For more information,
+ * see vmf_insert_pfn_prot_mkwrite().
+ *
+ * This only makes sense for IO mappings, and it makes no sense for
+ * COW mappings.  In general, using multiple vmas is preferable;
+ * vmf_insert_pfn_prot should only be used if using multiple VMAs is
+ * impractical.
+ *
+ * Context: Process context.  May allocate using %GFP_KERNEL.
+ * Return: vm_fault_t value.
+ */
+static inline vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma,
+			unsigned long addr, unsigned long pfn, pgprot_t pgprot)
+{
+	return vmf_insert_pfn_prot_mkwrite(vma, addr, pfn, pgprot, false);
+}
+
+/**
+ * vmf_insert_pfn_mkwrite - insert single pfn into user vma, possibly writable
+ * @vma: user vma to map to
+ * @addr: target user address of this page
+ * @pfn: source kernel pfn
+ * @write: whether the PTE should be installed writable
+ *
+ * Like vmf_insert_pfn(), except that @write allows installing a writable
+ * PTE even when @vma is under write notification.  For more information,
+ * see vmf_insert_pfn_prot_mkwrite().
+ *
+ * Note that neither .pfn_mkwrite() nor .page_mkwrite() is invoked, so the
+ * caller must itself do whatever they would have done if @write is true.
+ *
+ * Context: Process context.  May allocate using %GFP_KERNEL.
+ * Return: vm_fault_t value.
+ */
+static inline vm_fault_t vmf_insert_pfn_mkwrite(struct vm_area_struct *vma,
+			unsigned long addr, unsigned long pfn, bool write)
+{
+	return vmf_insert_pfn_prot_mkwrite(vma, addr, pfn, vma->vm_page_prot, write);
+}
+
+/**
+ * vmf_insert_pfn - insert single pfn into user vma
+ * @vma: user vma to map to
+ * @addr: target user address of this page
+ * @pfn: source kernel pfn
+ *
+ * Similar to vm_insert_page, this allows drivers to insert individual pages
+ * they've allocated into a user vma. Same comments apply.
+ *
+ * This function should only be called from a vm_ops->fault handler, and
+ * in that case the handler should return the result of this function.
+ *
+ * vma cannot be a COW mapping.
+ *
+ * As this is called only for pages that do not currently exist, we
+ * do not need to flush old virtual caches or the TLB.
+ *
+ * Context: Process context.  May allocate using %GFP_KERNEL.
+ * Return: vm_fault_t value.
+ */
+static inline vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma,
+			unsigned long addr, unsigned long pfn)
+{
+	return vmf_insert_pfn_mkwrite(vma, addr, pfn, false);
+}
+
 static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
 				unsigned long addr, struct page *page)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b5d1e9d4463d..2f4dcaa819b7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1615,7 +1615,7 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
  * @pfn: pfn to insert
  * @write: whether it's a write fault
  *
- * Insert a pmd size pfn. See vmf_insert_pfn() for additional info.
+ * Insert a pmd size pfn. See vmf_insert_pfn_mkwrite() for additional info.
  *
  * Return: vm_fault_t value.
  */
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..b5555217b121 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2719,40 +2719,55 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 }
 
 /**
- * vmf_insert_pfn_prot - insert single pfn into user vma with specified pgprot
+ * vmf_insert_pfn_prot_mkwrite - insert single pfn into user vma with specified pgprot
  * @vma: user vma to map to
  * @addr: target user address of this page
  * @pfn: source kernel pfn
  * @pgprot: pgprot flags for the inserted page
+ * @mkwrite: whether to make the page writable.
  *
- * This is exactly like vmf_insert_pfn(), except that it allows drivers
- * to override pgprot on a per-page basis.
+ * This is the function underlying all the others in the vmf_insert_pfn()
+ * family.  It is the most flexible, as it allows drivers to override pgprot
+ * on a per-page basis, as well as to insert the pfn as if it already had
+ * a write fault.  vmf_insert_pfn() is usually sufficient, however.
+ *
+ * These functions should only be called from a vm_ops->fault handler, and
+ * in that case the handler should return the result of these functions.
  *
  * This only makes sense for IO mappings, and it makes no sense for
- * COW mappings.  In general, using multiple vmas is preferable;
- * vmf_insert_pfn_prot should only be used if using multiple VMAs is
- * impractical.
+ * COW mappings.
  *
- * pgprot typically only differs from @vma->vm_page_prot when drivers set
- * caching- and encryption bits different than those of @vma->vm_page_prot,
- * because the caching- or encryption mode may not be known at mmap() time.
+ * For vmf_insert_pfn_prot_mkwrite() and vmf_insert_pfn_mkwrite(), the
+ * @mkwrite argument allows installing a writable PTE even when @vma is
+ * under write notification, i.e. when it has a .pfn_mkwrite() callback.
+ * In this case, vma_set_page_prot() has cleared the write bit from
+ * @vma->vm_page_prot.  This lets the fault() callback install a writable
+ * PTE in response to write faults; note that .pfn_mkwrite() is not called,
+ * and therefore the caller has to do by itself whatever the callback would
+ * have done.
  *
- * This is ok as long as @vma->vm_page_prot is not used by the core vm
+ * For vmf_insert_pfn_prot_mkwrite() and vmf_insert_pfn_prot(),
+ * pgprot can differ from @vma->vm_page_prot.  This typically happens only
+ * for caching and encryption bits, which may not be known at mmap() time;
+ * it is ok as long as @vma->vm_page_prot is not used by the core vm
  * to set caching and encryption bits for those vmas (except for COW pages).
- * This is ensured by core vm only modifying these page table entries using
- * functions that don't touch caching- or encryption bits, using pte_modify()
- * if needed. (See for example mprotect()).
+ * This is ensured in two ways:
  *
- * Also when new page-table entries are created, this is only done using the
- * fault() callback, and never using the value of vma->vm_page_prot,
- * except for page-table entries that point to anonymous pages as the result
- * of COW.
+ * - core vm only modifies these page table entries using functions that don't
+ *   touch caching- or encryption bits, using pte_modify() if needed. (See
+ *   for example mprotect()).
+ *
+ * - when new page-table entries are created, this is only done using the
+ *   fault() callback, and never using the value of vma->vm_page_prot,
+ *   except for page-table entries that point to anonymous pages as the result
+ *   of COW.
  *
  * Context: Process context.  May allocate using %GFP_KERNEL.
  * Return: vm_fault_t value.
  */
-vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn, pgprot_t pgprot)
+vm_fault_t vmf_insert_pfn_prot_mkwrite(struct vm_area_struct *vma,
+			unsigned long addr, unsigned long pfn, pgprot_t pgprot,
+			bool mkwrite)
 {
 	/*
 	 * Technically, architectures with pte_special can avoid all these
@@ -2774,36 +2789,9 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	return insert_pfn(vma, addr, pfn, pgprot, false);
+	return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
 }
-EXPORT_SYMBOL(vmf_insert_pfn_prot);
-
-/**
- * vmf_insert_pfn - insert single pfn into user vma
- * @vma: user vma to map to
- * @addr: target user address of this page
- * @pfn: source kernel pfn
- *
- * Similar to vm_insert_page, this allows drivers to insert individual pages
- * they've allocated into a user vma. Same comments apply.
- *
- * This function should only be called from a vm_ops->fault handler, and
- * in that case the handler should return the result of this function.
- *
- * vma cannot be a COW mapping.
- *
- * As this is called only for pages that do not currently exist, we
- * do not need to flush old virtual caches or the TLB.
- *
- * Context: Process context.  May allocate using %GFP_KERNEL.
- * Return: vm_fault_t value.
- */
-vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn)
-{
-	return vmf_insert_pfn_prot(vma, addr, pfn, vma->vm_page_prot);
-}
-EXPORT_SYMBOL(vmf_insert_pfn);
+EXPORT_SYMBOL(vmf_insert_pfn_prot_mkwrite);
 
 static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
 			bool mkwrite)
-- 
2.55.0


