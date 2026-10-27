Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241DC607351F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MWpWNuuj
Received: by kanga.kvack.org (Postfix)
	id D949F6B07F0; Tue, 27 Oct 2026 11:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43786B07F3; Tue, 27 Oct 2026 11:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD4B6B07F4; Tue, 27 Oct 2026 11:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8997B6B07F0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D24C80A46
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:26 +0000 (UTC)
X-FDA: 85368835692.20.1545220
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2EB0FC0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MWpWNuuj;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0HiXSaw8ZLiMKT3XuSDklH+uJG7cgDM9jgjpZ0euyso=;
	b=u9L09Y6InGOnWrKmeb1qhNb5IC6ab28cAioWgA2eEd9ogHgTU3b3jX6SJRWWYkf7RgfrpR
	Tw+ZBVyau6YwQ1R1q7Eg4Ak+t9kCQIM45VWuRNEVPep65WbRnDTc7pkmyn1v1+yXC2Va3t
	aNCBCuhGYUL+et8JBWPEg2fTzoqhkK0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MWpWNuuj;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116044;
	b=f7C8Hoe4FI2TLxQR3ZP2fw3LETkfAt9FfNlXOpGGfncKtTXuoTPxLtRg7HNSDkVTEwr1vS
	FL28jokknHdTC14lOtxQW+NOLezdHPC05Rxmsg3O5p11JJfJnDsTPh9P+IgdNPV+UsStUN
	ZthokqZkLlK6OIZnm0ybORNcAtZLZ3o=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso2828605f8f.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116043; x=1793720843; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0HiXSaw8ZLiMKT3XuSDklH+uJG7cgDM9jgjpZ0euyso=;
        b=MWpWNuuj2E2b+/7/3mq3rpTMqF/hp56CdDKoTmtdXAGJZuHA/0LH8AxBwBUY2NWTEN
         EZSTpYjmagOLw/BL4sZmau231irAWT1p/KRNm/DlARXx93QUkSuqB5r1MiWbdgVU4LC/
         v8/CPztrkI+j8w1Ayxd3d5JPvJ8AGy1o+KVn1FYzbJTKBcnEBe2XL/rvXiHyWuQ1Tjn8
         jNebRmhQ4OkwZzM+JB/B0zcbFW4eIBEmbV+QPbB5aLpmihRH1mosstpKycm53307WEvW
         ZUyycfopslzCKCQSSEGUR1dyRsPLGmxlUa0fCJ0HlBtyR+jFBMO67EDBlokElqeGVP6U
         hHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116043; x=1793720843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0HiXSaw8ZLiMKT3XuSDklH+uJG7cgDM9jgjpZ0euyso=;
        b=YJHl+yBWt3Wqk2GG2OLYdCcQcYYp/42lC81qp58OKTIwNMF1etB0UiGKNcbWzjnUo7
         XhbWzKV346dFWp53tsx5zTCTEqqNRRy1KXg0gOBST9ggIi21+ACxz5jHZZ8zDeS1cHEF
         u4Y7HgsKnykTaQmmWxhvS27xUQ0U0aLfMhgmzlWqi65+eRGUn+FZ7Jv2SHQUC8SMfjgH
         GPO2nJcHrEDUnAGx9E8XyMqT0vSePVBWjk6XO9q5MRSJogb8BG2otwLn2j4VUokJ+SsX
         wwCjJDH1tX8vvj7FqUujV5od1peNVD+uvONe7JlN9veDIyvWguft+x2hnr+jnhEV3HSo
         FxlA==
X-Forwarded-Encrypted: i=1; AKwUvBxnou4gcWOLroDZD9zmRHnoRZ91FARIKXZWgj9vdcZ0AHaPtoy488wzIcLH9KesRALTDZgAV8uvIA==@kvack.org
X-Gm-Message-State: AFq9FYJeJoKNg2lL4HqbeBQTYZ5jZak5qVpPGly+3HAg73Q93qVFLgQQ
	bEpT+0O4hQ+EjVY7M6XabtwnYjIi+uWuC9Qz4Um+PJ8pnIzyDDpYy2wJ
X-Gm-Gg: AYBFou2l1bi5itjGIASdcWxwGvaflUoaobRQIRAu5P27zdsKuTy9n7BOo7zEjoeVSzx
	0LGeehkLLKvehPVIP7xA1G0ZKKo3iB3LB8fy4p976JFybemdPVUyCBgDynYNC7x+uHJ1xi6hAZ5
	F82q7NBnY8weGDTBiqkjEAj8GaUokw/2qn5tDYsDXyqswaFtaulF4bZXSIN0WLcdMp3ocHAnP4R
	L0uVPyPuxU8xzFe7KUlPupKU2JqhBmzahVrtnimiP66tsQO0HX0a1bUDxCb4WQria78SwyjlhO6
	bvtt/v9rvhj+O7QjnvsqlZ79YfIZEhFOo0wQqOaVfim1w+0zicWg/nocAhp14d69zR8euh/KdnU
	qIO1B4X+g5DmSMy6y64o0FvBzi6IYJ26TLaiWdmbi+hRrCT9Y1Xyd8RFxm2AYp+FSbM7LwWkD5K
	fYK0azbG95X21ruHr3RXDnqJzCqu7KXCDUUxxYWhAYhPPQjnS6KltLBXLMeLkUppdxkaJepc9a1
	bXXwie94O/v4RqOWwGpCsuW76IiBYLCdJMGWdS2j8JEV/PiPGhny/aXDS3LRz7sAQfREUQf1utH
	xdkHkfalC1dRKtuLNSaeJ/ZtD8AuSJAy4RlcWhl5M0/CzsluMM/VGJvRvzt07lBFQFsoawWy4FY
	1jZqGQbhV+iF2ZO+U
X-Received: by 2002:adf:e00e:0:10b0:487:40d:af29 with SMTP id ffacd0b85a97d-48e3eb975c0mr15293194f8f.36.1793116042581;
        Tue, 27 Oct 2026 08:47:22 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.47.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:47:22 -0700 (PDT)
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
Subject: [RFC PATCH 12/14] samples/kvm: Add read-only pages and large blocks to the sample provider
Date: Tue, 27 Oct 2026 15:46:47 +0000
Message-ID: <20261027154649.91571-13-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2EB0FC0006
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: eniqmy4skwax75ckfh953mcdpom9wn6z
X-HE-Tag: 1793116043-60342
X-HE-Meta: U2FsdGVkX18xWLwnDF71BOga5IkXkv/8h5b7mprL51udacxuGEJKVub0o0Zvzkd62wvgOY7q0LYEBrWvd0ae/25bjOo6IYv0VcyuaXT5TDciulLr213uzCeS1jWwPVJoCb0D4pSP/WphHiNFrUvtRRLSxMf8L77bSTJkL2AA/ZBo38g7A1wI5Y5genLM0QO91uqw7UPS/Mb9/DIgXicu+TNwC7tC0e6HsFoauaUSGWElJMaxII76coha/gPYNh7Wp5Vu4ChWomVTAvwaPXclSvmBVlljXwqtHkcE5NJ1opJXMIHumjS5kqrolFf/YMuerqDAbYZa6N9ev2BRZo2MNw6YXldFjiYzlSQMD5z0X2usSXe6HHuyDJHlyTHrHeyglma0H8g6DXblKjtm5j6mH/m1wcYBFPXZxkyAxvgPkJoDtjO8vrDZp7pQLR3eJI6KpPI0UPZTICyDuU+08qjz1jaCT9t8RpJ1MtQC265jhzYCzt3ePvKrxWsqksn0mCVzIQMqHIAh7HSWr3CkYNcxRr33PfPVbKpRAsQdef+1cvCHf5tSW1c7P6b/ILKreoGzKpt083nICjD8H4CDs8CcW/+JcOexx/SOJEjqPjcxL7I4Sjs4aILb/phgmYQuV+w73tx7M95ZxEovXclehTKhet1sg37kjigpyTlKtVAvGR5uHPPCui8eMNdB8PSryahneQ1+bg0HEAG8KVwtcYHv9LdROLngh1b4oGaVWurSdLX638yEU2oThc3YuwC2xiDNZWhb2P3g/ajvWhjZKnMAKeQVLnuawVV1JmZD+O4+L9Z91IrYZMAybMDfYaoVWx3TOH29b9XLuDuTBzqXu2XaC2PVjCjJXFekRMPgW7shEnhio2apWud15S3lYAVM0WnmFfxpzmx6H+YaA8C6ONmpZBpA6lX6IgbAQhObuXjUytJmB9Idc5ExdK7O/OXFvDz0hq1Gxu90ddJF0cCvz/A
 J8UTagg0
 KE1EwAUatjuGtAVbvcNPgW2JDT3ftT6SAUMPMep46E/4EOTq0hndvsAuuyATeG/9jN16WKPiTPNDJIzqQHcL6C68CLyJ4nk+F1bvoUyxakDaRVvkESMfPngScpcjiLE7/nrD1F/hieyirMkHKzTg8b3LDn7FLtnM45vTYOTwIe1gOcq3UNsSQbBELXwz9ioMUvXxPoHp1Tfi6eAkMIcjA6Sp9NZb8RJ6+8JbOYPCIEK81WwCmyXKu42xEyjHjZDKsHtWG8NFKUm9hFRecCN8ZxNlLesQC5FIpvNwXI8sXgUo9cVW3BBzGzoJUTRSDkZNpCa+e6nDZb6B2hIAjuVhTh0K0cD8uiQF+CmX3H9CWkqicQ22KWFmeiS30DRgY61dJO7Z3cOO+6ySTYuu9F8e2Q9XmGPnkUREYOQfSKOOsNt5qG15PdWEjLGatm4NMeXo3/3W/ailIl7hwsYvaKQfsjj3k+1WDm6fyvv9y7RzJNZpndpDNEfdl7M4qEyZ4tLirS/5yuLfg+FU86C0UmtiIp8mg8W30TL++9SdrFGaJfp6HBops2TzvGa95Sp1OyDur5UNKWK2FNrFC4MQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

The sample provider reports every page as writable and of order 0, and
does nothing when a page comes back, so tests cannot exercise read-only
frames, large mappings, or a device mapping that follows a page made
present again.

Add MPS_SET_READONLY, report the largest aligned block of pages in the
same state, and call kvm_gmem_restore() when pages become present or
writable again; making pages read only revokes them.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 samples/kvm/mem_provider_sample.c | 89 +++++++++++++++++++++++++++----
 samples/kvm/mem_provider_sample.h |  9 ++++
 2 files changed, 87 insertions(+), 11 deletions(-)

diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index f30654a60dd8..670e36207e59 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -6,7 +6,8 @@
  *
  * The control device /dev/mem_provider_sample creates provider files.
  * Each file allocates its own contiguous memory from alloc_contig_pages().
- * Pages can be dynamically marked present or absent.
+ * Pages can be dynamically marked present or absent, and read only (for
+ * tests).
  * See mem_provider_sample.h.
  *
  * Confidential VMs are not supported.
@@ -39,6 +40,7 @@ struct mps_info {
 	struct page *cma_pages;		/* from alloc_contig_pages() */
 
 	unsigned long *absent;		/* taken away by MPS_SET_PRESENT */
+	unsigned long *readonly;	/* set by MPS_SET_READONLY */
 
 	struct inode *gmem_inode;
 };
@@ -83,6 +85,9 @@ static void mps_set_present(struct mps_info *info, unsigned long start,
 	mutex_lock(&info->lock);
 	if (present) {
 		bitmap_clear(info->absent, start, end - start);
+		/* Tell the users of guest_memfd that cannot fault. */
+		if (info->gmem_inode)
+			kvm_gmem_restore(info->gmem_inode, start, end - start);
 	} else {
 		bitmap_set(info->absent, start, end - start);
 		if (info->gmem_inode) {
@@ -95,6 +100,31 @@ static void mps_set_present(struct mps_info *info, unsigned long start,
 	mutex_unlock(&info->lock);
 }
 
+/*
+ * Change what get_pfn() reports for [start, end).  Making it read only takes
+ * write access away, so revoke it: the users of the guest_memfd map it again
+ * read only.  Making it writable takes nothing away, so only tell the users
+ * that cannot fault.  The pages keep their contents.
+ */
+static void mps_set_readonly(struct mps_info *info, unsigned long start,
+			     unsigned long end, bool value)
+{
+	unsigned long pfn = info->base_pfn + start;
+
+	mutex_lock(&info->lock);
+	if (value) {
+		bitmap_set(info->readonly, start, end - start);
+		if (info->gmem_inode)
+			kvm_gmem_revoke(info->gmem_inode, start, end - start,
+					&pfn);
+	} else {
+		bitmap_clear(info->readonly, start, end - start);
+		if (info->gmem_inode)
+			kvm_gmem_restore(info->gmem_inode, start, end - start);
+	}
+	mutex_unlock(&info->lock);
+}
+
 static long mps_get_stats(struct mps_info *info, void __user *uarg)
 {
 	struct mps_stats st = {};
@@ -114,11 +144,13 @@ static int mps_file_release(struct inode *inode, struct file *file)
 	if (info->cma_pages)
 		free_contig_range(info->base_pfn, info->npages);
 	bitmap_free(info->absent);
+	bitmap_free(info->readonly);
 	kfree(info);
 	return 0;
 }
 
-static long mps_file_set_present(struct mps_info *info, void __user *uarg)
+static long mps_file_set_range(struct mps_info *info, void __user *uarg,
+			       unsigned int cmd)
 {
 	struct mps_set_present sp;
 	unsigned long start, end;
@@ -129,9 +161,13 @@ static long mps_file_set_present(struct mps_info *info, void __user *uarg)
 	if (sp.value > 1 || sp.pad)
 		return -EINVAL;
 	ret = mps_range(info, sp.offset, sp.len, &start, &end);
-	if (!ret)
+	if (ret)
+		return ret;
+	if (cmd == MPS_SET_PRESENT)
 		mps_set_present(info, start, end, sp.value);
-	return ret;
+	else
+		mps_set_readonly(info, start, end, sp.value);
+	return 0;
 }
 
 static long mps_file_ioctl(struct file *file, unsigned int cmd,
@@ -144,7 +180,8 @@ static long mps_file_ioctl(struct file *file, unsigned int cmd,
 	case MPS_GET_STATS:
 		return mps_get_stats(info, uarg);
 	case MPS_SET_PRESENT:
-		return mps_file_set_present(info, uarg);
+	case MPS_SET_READONLY:
+		return mps_file_set_range(info, uarg, cmd);
 	default:
 		return -ENOTTY;
 	}
@@ -178,11 +215,28 @@ static void mps_gmem_release(void *provider)
 	fput(resource_file);
 }
 
+/* Is every bit of @bitmap in [first, first + n) equal to @value? */
+static bool mps_bits_are(unsigned long *bitmap, unsigned long first,
+			 unsigned long n, bool value)
+{
+	unsigned long end = first + n;
+
+	return (value ? find_next_zero_bit(bitmap, end, first) :
+			find_next_bit(bitmap, end, first)) >= end;
+}
+
+/*
+ * The frame behind @index, and the largest aligned block around it that is
+ * present and has the same attributes: the file's frames are contiguous.
+ * Lockless: a change is followed by kvm_gmem_revoke() or kvm_gmem_restore().
+ */
 static int mps_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
 			    int *max_order, u32 *attrs)
 {
 	struct file *resource_file = provider;
 	struct mps_info *info = resource_file->private_data;
+	bool ro;
+	int order;
 
 	if (index >= info->npages)
 		return -EINVAL;
@@ -190,10 +244,22 @@ static int mps_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
 	if (test_bit(index, info->absent))
 		return -EFAULT;
 
+	ro = test_bit(index, info->readonly);
 	*pfn = info->base_pfn + index;
-	if (max_order)
-		*max_order = 0;
-
+	*attrs = ro ? GUEST_MEMFD_PFN_READONLY : 0;
+
+	if (!max_order)
+		return 0;
+	for (order = PUD_ORDER; order; order--) {
+		unsigned long first = ALIGN_DOWN(index, 1UL << order);
+		unsigned long n = 1UL << order;
+
+		if (first + n <= info->npages &&
+		    mps_bits_are(info->absent, first, n, false) &&
+		    mps_bits_are(info->readonly, first, n, ro))
+			break;
+	}
+	*max_order = order;
 	return 0;
 }
 
@@ -255,9 +321,10 @@ static long mps_ctl_new_file(void __user *uarg)
 		return -ENOMEM;
 
 	info->absent = bitmap_zalloc(npages, GFP_KERNEL);
-	if (!info->absent) {
+	info->readonly = bitmap_zalloc(npages, GFP_KERNEL);
+	if (!info->absent || !info->readonly) {
 		ret = -ENOMEM;
-		goto err_free_info;
+		goto err_free_absent;
 	}
 
 	pages = alloc_contig_pages(npages, GFP_KERNEL | __GFP_ZERO,
@@ -293,7 +360,7 @@ static long mps_ctl_new_file(void __user *uarg)
 	free_contig_range(page_to_pfn(pages), npages);
 err_free_absent:
 	bitmap_free(info->absent);
-err_free_info:
+	bitmap_free(info->readonly);
 	kfree(info);
 	return ret;
 }
diff --git a/samples/kvm/mem_provider_sample.h b/samples/kvm/mem_provider_sample.h
index b9f10286cb30..57f494dc46fa 100644
--- a/samples/kvm/mem_provider_sample.h
+++ b/samples/kvm/mem_provider_sample.h
@@ -51,4 +51,13 @@ struct mps_set_present {
 #define MPS_SET_PRESENT \
 	_IOW(MPS_IOCTL_BASE, 12, struct mps_set_present)
 
+/*
+ * ioctl on a provider fd, with the same argument as MPS_SET_PRESENT: report
+ * [@offset, @offset + @len) as read only (GUEST_MEMFD_PFN_READONLY, @value 1)
+ * or writable again (@value 0).  Every mapping follows.  For tests: the
+ * sample does not really share the pages.
+ */
+#define MPS_SET_READONLY \
+	_IOW(MPS_IOCTL_BASE, 13, struct mps_set_present)
+
 #endif /* _SAMPLES_KVM_MEM_PROVIDER_SAMPLE_H */
-- 
2.47.3


