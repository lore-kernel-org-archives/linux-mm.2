Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 809EA606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pYMC27P4
Received: by kanga.kvack.org (Postfix)
	id 075456B07EB; Tue, 27 Oct 2026 11:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17716B07EF; Tue, 27 Oct 2026 11:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9A156B07EB; Tue, 27 Oct 2026 11:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6EC86B07EB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3397C0A45
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:18 +0000 (UTC)
X-FDA: 85368835356.19.3E08171
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id CB4C1C000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pYMC27P4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZh4WI6iG7eVBAQLCE+rfkIurvL6oSlg1UPzN6ojlZg=;
	b=jGr0XJVAvtbg0w3avdQqis1AlT41NPESzwALPFFDQRGXfv5zXn+H++w1aR0Q6HM69fq780
	LWeVumgShzLwKO6QndXksxX1hAlZPGliz576FUDaO1ZSsiCTlBYxMkiC+BR3KJSAcGpqaJ
	f44aVzTKRP0ry9y429hLDNeLWh5Hvvk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pYMC27P4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116036;
	b=0WCjNTpQIRtCj8c9Q3rxdpr7xidjUC4OKC3d+mtWv7aYX5U89mbitsfaL4kE6CbHiROBNx
	fNFjH8V6X5ToQETSBJhRx39sjf/DPH4XEPjQ95T8Db46/lAV6q0AMc5+DwSfpGOh2rUC4z
	CpOMDYiw5idq/c0HmcaSPp8fIc/LMsQ=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48c4649b35bso4336871f8f.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116035; x=1793720835; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HZh4WI6iG7eVBAQLCE+rfkIurvL6oSlg1UPzN6ojlZg=;
        b=pYMC27P4AD2OyzsU6NoK/rcsyq0UnpDGMR55GulBZWe9eaPuJos5NtESNenAZFM2T+
         wdGO52JJ0IGNmnMufq+AdPZMMjkwrRglCBAb/mz3A/kwXNxvu8YVBj5Xud/KgFLBnU6g
         dWJt6cJbQKb4QvGVnGZg2T3uiTZJYLL6XD3zpph6bkwKO0UkGlPwtbP8e8wJhy+TayHv
         +18/G/ZtZQonXdZCWgpc6xsa+m7URaXjAEoL24Ud/gjVqWoSVT8PEWzzeSbksIUNhwHN
         PUoW26u0x+WWQkbLX17K3WxQnSokksGoWX6thgq6+jzaAMj7HmV9J7jEg1cJMoJ9hGud
         HV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116035; x=1793720835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HZh4WI6iG7eVBAQLCE+rfkIurvL6oSlg1UPzN6ojlZg=;
        b=LKCf8PcpJNSKn4JjdACcAhlduNarC6XVuXH2au2oZopu+DcvQtZHnx/9OzaMZMrtf0
         1CFgu64xZW2LkrU8xImyBbpEaHHMAPNWJ1H9cVYq84rmL0GVnz0wgvxJPusTi7rL44n6
         SS187esSgw6LqieJKNCkwVQ878yp+ZxQLjZ749dD5xcp28GwBu4evvPhRYXBwAbaFlIK
         djHrQ4nUfS55XpCGVK3TiLomkmNMgQ4MMPa1AWI0D+rvrolUwlmfMdcJXJSwPYj5g68s
         hk4/ZdQdi6mpOdWxaD7/y9qvrHQafiXlpDpXxbZYfhuUG6MALrG4kcz6UzEieHHx6gp5
         IUIQ==
X-Forwarded-Encrypted: i=1; AKwUvBy+AbPrmiWV++hfQQGrcRuajIFciTTpVUVRNgC/5be2PwvG8plwVgBDSoWdDGoCBlS2ZolkIol85w==@kvack.org
X-Gm-Message-State: AFq9FYL6hJ6dSW0tELFjqiVUZ/y9fYdsXGMf16dBJf1kkLy2Ay8H6iO2
	CiYcfbs84n4mtIQs9uBv312dt+lIWxC7XxRshNllPT20fKEOe53ZwjwT
X-Gm-Gg: AYBFou08ty8+xbntIPPYixrPfuycUxYbqrN1gP+ONuOfw1+AK97Le9gcVtJxTbv3rim
	a/NS3FhEnU+434bbxKC0G2u6+0EAcRBp9jlGQ47nB06NKzg8kB34Prr+xi7InKspWV6/fG+0LZQ
	vhFMa4OYXLQcGkl6yayWNSOKBDrh6S5Ik1fsq78nooJ/jV9D7vzXQCuAfVqb+DLPR8yqGQ60J+M
	Tu2pJNQwnWDBgQMcEZVxFy87tdxl6idbpQmd2RiUw/IWY5DfXyl0OB75qitZmfsqksMME/ZM+8B
	oPatETfQssrKNnAK9XflXv5emOwrc+1G3BwEq4oG6hw1tjdUrMZqtFk9ej1NmccTMTfFyQJ1aAA
	CltVhC2qIaWQQykSDgyxDw2F6/ST/daXZBWu5vN8hycSxvZG9j17F1kmSICbUCuqHQHNT2wJzV+
	s07vwWKSErvryL354zOJXIEn30g+8I8NrtptSugvJ6VQms+/Qm8Jr1pJkzQUhUP945a11UNOF30
	Z/1PmFcWUl/bgYBMVQeLoYBFHtzgjg/Bmv2KqL8rohWRwYMfNam/vM4rexebHDybKtLYlic/vfL
	5YQXCtP/7NL2wYKCWuFUzFuvKawKvL4wmiGCGdT4KANdjS1bou8u8Ae2AGCJl4vYGLFFjsX7knX
	2ahQFaau1sk8gqF0D
X-Received: by 2002:a05:6000:490d:b0:48e:5550:c64c with SMTP id ffacd0b85a97d-48e5550c68fmr8550797f8f.14.1793116035016;
        Tue, 27 Oct 2026 08:47:15 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.47.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:47:14 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Graf <graf@amazon.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Kardashevskiy <aik@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Connor Williamson <connordw@amazon.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Erdem Aktas <erdemaktas@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	James Houghton <jthoughton@google.com>,
	Jan Kara <jack@suse.cz>,
	Jianxiong Gao <jxgao@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Starks <John.Starks@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Oliver Upton <oupton@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	x86@kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: [RFC PATCH 09/14] iommufd: Map guest_memfd files
Date: Tue, 27 Oct 2026 15:46:44 +0000
Message-ID: <20261027154649.91571-10-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CB4C1C000D
X-Stat-Signature: 8c3aqidt7tsy7m3in5ioyaffiabt19d8
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793116036-376423
X-HE-Meta: U2FsdGVkX19W22eCAMopcC36n7s1IJKxfXfTBxZEtGU8RqSYKfgk0dY0xaeHkD73Efugkuk8jircfYwxrMnUIh7rvNh3FR+iJCQu3vjXA1PHZuRULd7L/vDKYihYMulDUbhGJg70OySCDzDL5eDLCEC5h+EywL9YkGYipoNqy9MuImp2MNUel+9fslcZKAg/83+yHHJVXBfZ+FhoRq/gizQtL8mDnFGr6DU6zSYdM4RMXaQqEYNrxtZbtd8hII6IxETtcBY5LswWORfguEpzxas1wpmNm+jjHicOx8ardmfah6VfcXuYM0jfBAgH+jM6iLRkw1C2tkSJlY7OTOE8WGk6YlxiyaW8dzOFO587xWTxfWQGJFeaWm5WK01XBEpFL27Skct3cHJYDmxAlM9QkDcz6B1ZH7vonhN3gHCGxc1+v4bdmX0L+ePsjyhTlu4iVRuuiIvxIk6Jj7/EgyhX5xlAtl7ZbMXDeRTxTQL89u65wYUDVthiM0moiKlDMU6ZigJc4UgiK7Zvwt68icpX3ZRZoM7yuDoDHh2VI1o0mDmsGGHbQzEtMLjP/tArqZ8qMCoGGQ8tXLNXUJ8MWHWiFarxEEt/bXlht08IXFQM/9tCx4d90b2qj8iZNv+bPQAP0btOq8+nYJoIbBCFnPGUY2JUiJol+HCDtcMTsgrHdqsJZ+dayWq9arRx2awT+QROMX3UZt9D0Mcal5Sikv4id5Bov1PS+jC0dE4FcL9LrKiZLH268Ovo9CyXJbF6ENn692Z+hdvBh7EVwyQmIdgPYxzpVUrz+ObLD/DM1JCOenDsm/ZSoEAORX2ac/anurb6kr5kyf0PsZA+cP9R3bel+CqUTZHYdc/KNV6eu+H2thXq0FXhCkkYuWuktSn85/JD3TEUqBhWoEyvjrs3Lb0Olaeu/CgVPuKjAXP31u0m4dOswCrPyc8dC1a/fgBnhL3OjGLydS//YuOhlpEEP7Y
 2rvflMeR
 y01rAHCkMdqzjJ/juJAAPfHF+biuEMLBJNhYe6GjR08PD1zNlrF9lmvuFu/+aXCLg6X9j1Rtw+OkgmRbrGPRlQtfQACngPWK3C9TusE3dZ0t4Mb8q1nvrtYGjYXHqHS6EwsevRC1W45QlraVgmLHAD767IAETm8H6naQU9ZyCuQjoXzh/2zLuupP0Iqw1yi8EBeCVZTBp2bgDXhr15zM89M29DnrI80olLwDDFjzEjhTmYZL1vbegSFyPrimPD0JaddtNmuWyDS6PkCynKeNGZadlZia9TVzuhAeHWokrVKG3Q0p1DhpMwraSg/bxXEixLeqoblI0jOEL3vPNdlTl6QDFBxPP5707d6GSXleq77ApwG03LdLZzJsrJAWAyxqxU4TMzLOLhsDZCGL/qlIpQZp3jv/QolXGiuOUD2Hw4jju4DM3TItV6YLWr1pdOevyqm58q0vdS2Y7Q0WvkC00pMxPWZ4hwFAedwNMLoZMhgZMOYSQNMcdWLOd0sC6FYEkWdhzPy1GbnrA2tUI/Y99Fk8suoQXYBTkewAsgccJ0jFglEXhO17Uj9RSiBL20hY4JOKMnaAp2O+FadTceUWwl9VzbgFtunPxqSQu/1nR2xVgw7S6ODpddmduUc+OzOxh8sbgJw8Nrd5b109dqHf1AVA05g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

A VMM that assigns a device to a guest backed by guest_memfd needs the
IOMMU mappings to follow the guest's shared memory. IOMMU_IOAS_MAP_FILE
pins what it maps, which guest_memfd does not allow.

Accept a guest_memfd in IOMMU_IOAS_MAP_FILE through guest_memfd's export
interface: its pages are not pinned, and each update() unmaps the range
and maps what a lookup returns now, read-only frames without write
permission. This is a demonstration: entries are PAGE_SIZE, a device
that touches the range during an update faults, and a range that fails
to map again stays unmapped, with a warning.

Dirty tracking, the no-IOMMU mode, kernel access, splitting an area and
a frame at address 0 are refused, since iommufd could not follow them.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/io_pagetable.c |  14 +-
 drivers/iommu/iommufd/io_pagetable.h |  30 ++-
 drivers/iommu/iommufd/pages.c        | 299 ++++++++++++++++++++++++++-
 include/uapi/linux/iommufd.h         |  11 +-
 4 files changed, 349 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 43d518e4ce58..62fa553cdffc 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -217,9 +217,13 @@ static int iopt_insert_area(struct io_pagetable *iopt, struct iopt_area *area,
 		return -EPERM;
 
 	area->iommu_prot = iommu_prot;
+	area->gmem = iopt_is_gmem(pages);
 	area->page_offset = start_byte % PAGE_SIZE;
 	if (area->page_offset & (iopt->iova_alignment - 1))
 		return -EINVAL;
+	/* guest_memfd frames are mapped whole, see iopt_gmem_map(). */
+	if (area->gmem && (area->page_offset || !PAGE_ALIGNED(length)))
+		return -EINVAL;
 
 	area->node.start = iova;
 	if (check_add_overflow(iova, length - 1, &area->node.last))
@@ -289,6 +293,9 @@ static int iopt_alloc_area_pages(struct io_pagetable *iopt,
 		case IOPT_ADDRESS_DMABUF:
 			start = elm->start_byte + elm->pages->dmabuf.start;
 			break;
+		case IOPT_ADDRESS_GMEM:
+			start = elm->start_byte + elm->pages->gmem.start;
+			break;
 		}
 		rc = iopt_alloc_iova(iopt, dst_iova, start, length);
 		if (rc)
@@ -515,8 +522,13 @@ int iopt_map_file_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 		if (!file)
 			return -EBADF;
 
-		pages = iopt_alloc_file_pages(file, start_byte, start, length,
+		/* -ENODEV: not a guest_memfd, so map it as a memfd. */
+		pages = iopt_alloc_gmem_pages(file, start, length,
 					      iommu_prot & IOMMU_WRITE);
+		if (PTR_ERR(pages) == -ENODEV)
+			pages = iopt_alloc_file_pages(file, start_byte, start,
+						      length,
+						      iommu_prot & IOMMU_WRITE);
 		fput(file);
 		if (IS_ERR(pages))
 			return PTR_ERR(pages);
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index 0dddfb5db5fd..11e16d22436a 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -6,6 +6,7 @@
 #define __IO_PAGETABLE_H
 
 #include <linux/dma-buf.h>
+#include <linux/guest_memfd.h>
 #include <linux/interval_tree.h>
 #include <linux/kref.h>
 #include <linux/mutex.h>
@@ -13,6 +14,8 @@
 
 #include "iommufd_private.h"
 
+struct mem_cgroup;
+
 struct iommu_domain;
 
 /*
@@ -48,6 +51,8 @@ struct iopt_area {
 	/* IOMMU_READ, IOMMU_WRITE, etc */
 	int iommu_prot;
 	bool prevent_access : 1;
+	/* The pages come from a guest_memfd and may have holes */
+	bool gmem : 1;
 	unsigned int num_accesses;
 	unsigned int num_locks;
 };
@@ -191,6 +196,7 @@ enum iopt_address_type {
 	IOPT_ADDRESS_USER = 0,
 	IOPT_ADDRESS_FILE,
 	IOPT_ADDRESS_DMABUF,
+	IOPT_ADDRESS_GMEM,
 };
 
 /* One (area, domain) mapping of revocable pages, on iopt_pages::tracker. */
@@ -207,6 +213,17 @@ struct iopt_pages_dmabuf {
 	unsigned long start;
 };
 
+struct iopt_pages_gmem {
+	struct guest_memfd_export export;
+	/* From symbol_get(): KVM may be a module */
+	typeof(kvm_gmem_export_lookup_pfn) *lookup_pfn;
+	typeof(kvm_gmem_export_detach) *detach;
+	/* Byte offset in the guest_memfd, always PAGE_SIZE aligned */
+	unsigned long start;
+	/* Charged for the page tables that a fill allocates */
+	struct mem_cgroup *memcg;
+};
+
 /*
  * This holds a pinned page list for multiple areas of IO address space. The
  * pages always originate from a linear chunk of userspace VA. Multiple
@@ -236,6 +253,8 @@ struct iopt_pages {
 		};
 		/* IOPT_ADDRESS_DMABUF */
 		struct iopt_pages_dmabuf dmabuf;
+		/* IOPT_ADDRESS_GMEM */
+		struct iopt_pages_gmem gmem;
 	};
 	bool writable:1;
 	u8 account_mode;
@@ -260,10 +279,15 @@ static inline bool iopt_is_dmabuf(struct iopt_pages *pages)
 	return pages->type == IOPT_ADDRESS_DMABUF;
 }
 
+static inline bool iopt_is_gmem(struct iopt_pages *pages)
+{
+	return pages->type == IOPT_ADDRESS_GMEM;
+}
+
 /* The owner of the pages can revoke them, so their domains are tracked. */
 static inline bool iopt_pages_tracked(struct iopt_pages *pages)
 {
-	return iopt_is_dmabuf(pages);
+	return iopt_is_dmabuf(pages) || iopt_is_gmem(pages);
 }
 
 static inline bool iopt_dmabuf_revoked(struct iopt_pages *pages)
@@ -285,6 +309,10 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
 					   unsigned long start_byte,
 					   unsigned long start,
 					   unsigned long length, bool writable);
+struct iopt_pages *iopt_alloc_gmem_pages(struct file *file,
+					 unsigned long start,
+					 unsigned long length,
+					 bool writable);
 void iopt_release_pages(struct kref *kref);
 static inline void iopt_put_pages(struct iopt_pages *pages)
 {
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index cf0f08c4e9a6..88354aa554cf 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -52,6 +52,7 @@
 #include <linux/iommu.h>
 #include <linux/iommufd.h>
 #include <linux/kthread.h>
+#include <linux/memcontrol.h>
 #include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
@@ -238,6 +239,40 @@ static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
 	WARN_ON(ret != size);
 }
 
+/*
+ * guest_memfd pages are mapped with PAGE_SIZE entries, and may have holes.
+ * iommu_unmap() stops at the first IOVA that is not mapped, which
+ * iommu_unmap_nofail() warns about, so find the runs that are mapped and
+ * unmap each one, without touching the holes.
+ * iopt_gmem_map() refuses frame 0, which iova_to_phys() reports for
+ * an IOVA that is not mapped.
+ */
+static void iopt_gmem_unmap(struct iopt_area *area,
+			    struct iommu_domain *domain,
+			    unsigned long start_index,
+			    unsigned long last_index)
+{
+	unsigned long iova = iopt_area_index_to_iova(area, start_index);
+	size_t left = (last_index - start_index + 1) * PAGE_SIZE;
+
+	/* A guest_memfd can be large: yield, once per page scanned. */
+	while (left) {
+		size_t len = 0;
+
+		while (len < left && iommu_iova_to_phys(domain, iova + len)) {
+			len += PAGE_SIZE;
+			cond_resched();
+		}
+		if (len)
+			iommu_unmap_nofail(domain, iova, len);
+		/* Step over the run and the hole page that ended it. */
+		len = min(len + PAGE_SIZE, left);
+		iova += len;
+		left -= len;
+		cond_resched();
+	}
+}
+
 static void iopt_area_unmap_domain_range(struct iopt_area *area,
 					 struct iommu_domain *domain,
 					 unsigned long start_index,
@@ -245,6 +280,11 @@ static void iopt_area_unmap_domain_range(struct iopt_area *area,
 {
 	unsigned long start_iova = iopt_area_index_to_iova(area, start_index);
 
+	if (area->gmem) {
+		iopt_gmem_unmap(area, domain, start_index, last_index);
+		return;
+	}
+
 	iommu_unmap_nofail(domain, start_iova,
 			   iopt_area_index_to_iova_last(area, last_index) -
 				   start_iova + 1);
@@ -1349,6 +1389,10 @@ static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
 	    WARN_ON(last_index < start_index))
 		return -EINVAL;
 
+	/* guest_memfd pages are read from guest_memfd, see iopt_gmem_map() */
+	if (WARN_ON(iopt_is_gmem(pages)))
+		return -EINVAL;
+
 	rc = pfn_reader_init(pfns, pages, start_index, last_index);
 	if (rc)
 		return rc;
@@ -1647,6 +1691,230 @@ void iopt_pages_untrack_all_domains(struct iopt_area *area,
 	}
 }
 
+static int iopt_gmem_prot(struct iopt_area *area, u32 attrs)
+{
+	int prot = area->iommu_prot;
+
+	if (attrs & GUEST_MEMFD_PFN_READONLY)
+		prot &= ~IOMMU_WRITE;
+	return prot;
+}
+
+/*
+ * Map what guest_memfd backs in [start_index, last_index] of the area into
+ * @domain, with PAGE_SIZE entries, so that updating part of a large block
+ * never has to cut a larger IOMMU page.  On failure, nothing in the range is
+ * mapped.
+ */
+static int iopt_gmem_map(struct iopt_area *area, struct iopt_pages *pages,
+			 struct iommu_domain *domain, unsigned long start_index,
+			 unsigned long last_index)
+{
+	struct guest_memfd_export *e = &pages->gmem.export;
+	unsigned long base = pages->gmem.start >> PAGE_SHIFT;
+	unsigned long index = start_index;
+	int rc = 0;
+
+	lockdep_assert_held(&pages->mutex);
+
+	/* A revoke would race a dirty bitmap read and lose its dirty bits. */
+	if (domain->dirty_ops)
+		return -EOPNOTSUPP;
+
+	/* The device of a no-IOMMU domain keeps the addresses after a revoke. */
+	if (IS_ENABLED(CONFIG_IOMMUFD_NOIOMMU) &&
+	    domain->owner == &iommufd_noiommu_ops)
+		return -EOPNOTSUPP;
+
+	while (index <= last_index) {
+		unsigned long pfn, iova, end, nr;
+		/* No larger than the rest of the range: holes cost per page. */
+		int order = min_t(int, PUD_ORDER, fls_long(last_index - index));
+		u32 attrs;
+		int prot;
+
+		cond_resched();
+
+		rc = pages->gmem.lookup_pfn(e, base + index, &pfn, &order,
+					    &attrs);
+		/* The aligned block of frames, or of holes, around index. */
+		end = ALIGN(base + index + 1, 1UL << order) - base;
+		nr = min(end, last_index + 1) - index;
+		if (rc == -ENOENT) {
+			index += nr;
+			continue;
+		}
+		/* Frame 0 would look unmapped to iopt_gmem_unmap(). */
+		if (!rc && !pfn)
+			rc = -EINVAL;
+		if (rc)
+			goto err_unmap;
+
+		iova = iopt_area_index_to_iova(area, index);
+		prot = iopt_gmem_prot(area, attrs);
+
+		/* A read-only frame in an area that is not readable: a hole. */
+		if (!(prot & (IOMMU_READ | IOMMU_WRITE))) {
+			index += nr;
+			continue;
+		}
+
+		rc = batch_iommu_map_small(domain, iova, PFN_PHYS(pfn),
+					   nr * PAGE_SIZE, prot);
+		if (rc)
+			goto err_unmap;
+		index += nr;
+	}
+	return 0;
+
+err_unmap:
+	if (index > start_index)
+		iopt_gmem_unmap(area, domain, start_index, index - 1);
+	return rc;
+}
+
+/* Map the whole area into every domain of its io_pagetable. */
+static int iopt_gmem_fill_domains(struct iopt_area *area,
+				  struct iopt_pages *pages)
+{
+	struct iommu_domain *domain, *undo;
+	unsigned long index, undo_index;
+	int rc;
+
+	xa_for_each(&area->iopt->domains, index, domain) {
+		rc = iopt_gmem_map(area, pages, domain, iopt_area_index(area),
+				   iopt_area_last_index(area));
+		if (rc)
+			goto err_unmap;
+	}
+	return 0;
+
+err_unmap:
+	xa_for_each(&area->iopt->domains, undo_index, undo) {
+		if (undo_index >= index)
+			break;
+		iopt_gmem_unmap(area, undo, iopt_area_index(area),
+				iopt_area_last_index(area));
+	}
+	return rc;
+}
+
+/*
+ * guest_memfd says that what [start, start + nr_pages) of the file holds may
+ * have changed: in every (area, domain) over part of it, unmap that part and
+ * map what guest_memfd backs now.  A device that accesses it in between, or
+ * after a failure to map, faults.
+ */
+static void iopt_gmem_update(struct guest_memfd_export *e, pgoff_t start,
+			     pgoff_t nr_pages)
+{
+	struct iopt_pages *pages =
+		container_of(e, struct iopt_pages, gmem.export);
+	pgoff_t base = pages->gmem.start >> PAGE_SHIFT;
+	struct iopt_pages_track *track;
+	struct mem_cgroup *old_memcg;
+	unsigned long first, last;
+
+	if (start + nr_pages <= base || start >= base + pages->npages)
+		return;
+	first = max(start, base) - base;
+	last = min(start + nr_pages, base + pages->npages) - base - 1;
+
+	guard(mutex)(&pages->mutex);
+	/* The page tables belong to whoever mapped the file, not to this task. */
+	old_memcg = set_active_memcg(pages->gmem.memcg);
+	list_for_each_entry(track, &pages->tracker, elm) {
+		struct iopt_area *area = track->area;
+		unsigned long s = max(first, iopt_area_index(area));
+		unsigned long l = min(last, iopt_area_last_index(area));
+
+		if (s > l)
+			continue;
+		iopt_gmem_unmap(area, track->domain, s, l);
+		if (iopt_gmem_map(area, pages, track->domain, s, l))
+			pr_warn_ratelimited("iommufd: guest_memfd pages left unmapped after an update\n");
+	}
+	set_active_memcg(old_memcg);
+}
+
+static const struct guest_memfd_export_ops iopt_gmem_export_ops = {
+	.update	= iopt_gmem_update,
+};
+
+/**
+ * iopt_alloc_gmem_pages() - Pages backed by a guest_memfd file
+ * @file: The file
+ * @start: Byte offset in the file
+ * @length: Number of bytes
+ * @writable: The pages may be mapped writable
+ *
+ * The pages are not pinned, and every domain that maps them follows
+ * guest_memfd's changes.
+ *
+ * Return: the pages, ERR_PTR(-ENODEV) if @file is not a guest_memfd file, or
+ * another ERR_PTR().
+ */
+struct iopt_pages *iopt_alloc_gmem_pages(struct file *file,
+					 unsigned long start,
+					 unsigned long length,
+					 bool writable)
+{
+	static struct lock_class_key pages_gmem_mutex_key;
+	int (*attach)(struct file *file, struct guest_memfd_export *e);
+	struct iopt_pages *pages;
+	unsigned long end;
+	int rc;
+
+	/* KVM may be a module, or not loaded: then this is no guest_memfd. */
+	attach = symbol_get(kvm_gmem_export_attach);
+	if (!attach)
+		return ERR_PTR(-ENODEV);
+
+	pages = iopt_alloc_pages(0, length, writable);
+	if (IS_ERR(pages))
+		goto out_put;
+
+	/*
+	 * Pinned pages take the mmap_lock under their mutex.  The mutex of
+	 * guest_memfd pages is taken under guest_memfd's invalidate lock, which
+	 * nests in the mmap_lock of a host fault, so give it its own class.
+	 */
+	lockdep_set_class(&pages->mutex, &pages_gmem_mutex_key);
+
+	/* guest_memfd pages are not pinned, so they are not accounted. */
+	pages->account_mode = IOPT_PAGES_ACCOUNT_NONE;
+	pages->type = IOPT_ADDRESS_GMEM;
+	pages->gmem.start = start;
+	pages->gmem.export.ops = &iopt_gmem_export_ops;
+
+	rc = attach(file, &pages->gmem.export);
+	if (rc) {
+		iopt_put_pages(pages);
+		pages = ERR_PTR(rc);
+		goto out_put;
+	}
+
+	if (check_add_overflow(start, length, &end) ||
+	    end > i_size_read(file_inode(file))) {
+		rc = -EINVAL;
+		goto err_detach;
+	}
+
+	/* The file holds the KVM module from here on. */
+	pages->gmem.lookup_pfn = symbol_get(kvm_gmem_export_lookup_pfn);
+	pages->gmem.detach = symbol_get(kvm_gmem_export_detach);
+	pages->gmem.memcg = get_mem_cgroup_from_mm(current->mm);
+	goto out_put;
+
+err_detach:
+	pages->gmem.detach = symbol_get(kvm_gmem_export_detach);
+	iopt_put_pages(pages);
+	pages = ERR_PTR(rc);
+out_put:
+	symbol_put(kvm_gmem_export_attach);
+	return pages;
+}
+
 void iopt_release_pages(struct kref *kref)
 {
 	struct iopt_pages *pages = container_of(kref, struct iopt_pages, kref);
@@ -1664,6 +1932,14 @@ void iopt_release_pages(struct kref *kref)
 		dma_resv_unlock(dmabuf->resv);
 		dma_buf_detach(dmabuf, pages->dmabuf.attach);
 		dma_buf_put(dmabuf);
+	} else if (iopt_is_gmem(pages)) {
+		if (pages->gmem.detach) {
+			pages->gmem.detach(&pages->gmem.export);
+			symbol_put(kvm_gmem_export_detach);
+		}
+		if (pages->gmem.lookup_pfn)
+			symbol_put(kvm_gmem_export_lookup_pfn);
+		mem_cgroup_put(pages->gmem.memcg);
 	} else if (pages->type == IOPT_ADDRESS_FILE) {
 		fput(pages->file);
 	}
@@ -1814,6 +2090,12 @@ static void iopt_area_unfill_partial_domain(struct iopt_area *area,
  */
 void iopt_area_unmap_domain(struct iopt_area *area, struct iommu_domain *domain)
 {
+	if (area->gmem) {
+		iopt_gmem_unmap(area, domain, iopt_area_index(area),
+				iopt_area_last_index(area));
+		return;
+	}
+
 	iommu_unmap_nofail(domain, iopt_area_iova(area),
 			   iopt_area_length(area));
 }
@@ -1857,6 +2139,11 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
 	if (iopt_dmabuf_revoked(area->pages))
 		return 0;
 
+	if (iopt_is_gmem(area->pages))
+		return iopt_gmem_map(area, area->pages, domain,
+				     iopt_area_index(area),
+				     iopt_area_last_index(area));
+
 	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
 			      iopt_area_last_index(area));
 	if (rc)
@@ -1922,7 +2209,11 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 			goto out_unlock;
 	}
 
-	if (!iopt_dmabuf_revoked(pages)) {
+	if (iopt_is_gmem(pages)) {
+		rc = iopt_gmem_fill_domains(area, pages);
+		if (rc)
+			goto out_untrack;
+	} else if (!iopt_dmabuf_revoked(pages)) {
 		rc = pfn_reader_first(&pfns, pages, iopt_area_index(area),
 				      iopt_area_last_index(area));
 		if (rc)
@@ -2361,7 +2652,7 @@ int iopt_pages_rw_access(struct iopt_pages *pages, unsigned long start_byte,
 	if ((flags & IOMMUFD_ACCESS_RW_WRITE) && !pages->writable)
 		return -EPERM;
 
-	if (iopt_is_dmabuf(pages))
+	if (iopt_is_dmabuf(pages) || iopt_is_gmem(pages))
 		return -EINVAL;
 
 	if (pages->type != IOPT_ADDRESS_USER)
@@ -2453,6 +2744,10 @@ int iopt_area_add_access(struct iopt_area *area, unsigned long start_index,
 	if (iopt_is_dmabuf(pages))
 		return -EINVAL;
 
+	/* guest_memfd frames may have no struct page, and are not pinned. */
+	if (iopt_is_gmem(pages))
+		return -EINVAL;
+
 	mutex_lock(&pages->mutex);
 	access = iopt_pages_get_exact_access(pages, start_index, last_index);
 	if (access) {
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 206fa667c782..db5f09c21d1f 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -252,7 +252,7 @@ struct iommu_ioas_noiommu_get_pa {
  * @size: sizeof(struct iommu_ioas_map_file)
  * @flags: same as for iommu_ioas_map
  * @ioas_id: same as for iommu_ioas_map
- * @fd: the memfd or supported dma-buf file to map
+ * @fd: the memfd, guest_memfd or supported dma-buf file to map
  * @start: byte offset from start of the file to map from
  * @length: same as for iommu_ioas_map
  * @iova: same as for iommu_ioas_map
@@ -263,6 +263,15 @@ struct iommu_ioas_noiommu_get_pa {
  * VFIO PCI dma-bufs exported through VFIO_DEVICE_FEATURE_DMA_BUF, and
  * other dma-bufs may be rejected. All other arguments and semantics match
  * those of IOMMU_IOAS_MAP.
+ *
+ * A guest_memfd is also accepted, with @start and @length page aligned. Its
+ * pages are not pinned: only its shared pages that have memory are mapped, a
+ * page as soon as it gets memory, and the mapping follows conversions, punch
+ * holes and its provider's changes. Read-only pages are mapped without write
+ * permission, or not at all without IOMMU_IOAS_MAP_READABLE. Such a mapping
+ * cannot be split by a partial unmap, accessed by the kernel, moved by
+ * IOMMU_IOAS_CHANGE_PROCESS, or used with dirty tracking or the no-IOMMU mode,
+ * and a page at physical address 0 cannot be mapped.
  */
 struct iommu_ioas_map_file {
 	__u32 size;
-- 
2.47.3


