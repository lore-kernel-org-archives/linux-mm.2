Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB29606A329
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AJs76/vW
Received: by kanga.kvack.org (Postfix)
	id 508456B07F5; Tue, 27 Oct 2026 11:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8986B07F7; Tue, 27 Oct 2026 11:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37FEF6B07F8; Tue, 27 Oct 2026 11:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 042076B07F5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 575FF40A03
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:28 +0000 (UTC)
X-FDA: 85368835776.20.6B00A76
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8707940005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="AJs76/vW";
	spf=pass (imf04.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2ojhVyA7G70YSFxIWDEXLUjmLV19PosvKcY5O6DkLk=;
	b=DV7icvA/vFCeuoNrvs7xaI/kN/IKJAh6hdee8RjOf8oApBfHvfoVcShjz/JiujrVjBIQco
	YAjkAnMpztapEpQsRGeVgZPIr03G9V24CUUgB4ZCxkwKWE/S8FvJxx6kuuMBRTM+B+cLzR
	CV9IS0w1KnWIep2Y2tUFSkI4l1tN44s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="AJs76/vW";
	spf=pass (imf04.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116046;
	b=4xERiMkDnsnzMY7G6x+yTixZgsrerIAjZRhCcVB4XLt7sBKxVfVv5l+UVOIdwK3CHM3igx
	Dcx6pvgDp8adjiTqQAV93zoK/iZ93kVKNMXmORBay/fs80SaNVPJJyDvyJCn6fCYi7UZIg
	8slxQjho20xdbNI0cv19Sos7pR6L3fA=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso3847435f8f.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116045; x=1793720845; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d2ojhVyA7G70YSFxIWDEXLUjmLV19PosvKcY5O6DkLk=;
        b=AJs76/vW0zBAXpT+zaGqOsuq1J9+3RZ7vA2G4nrC9eylXVKr4MU/NIrO0CoJl3NRf6
         gGtDa6U/It1KtAW1q1q0hyj0M9e654oTVwl/BdYSoOSR6amLMEcclIfHUUPLGpvFvSw0
         w6uCgyRhpaoVrzjQBH92zkKmU7Z65y7ZNk6wsPWEGlX8YD4aDj777Riifqs4Z0Zr9Xgf
         KbJK4us7TXMF+vJPPhQfmhhS4ohjkqmut8ri1SanK1jJN22Oh3CX6Cj6o0fp47zbrmD/
         7MFX0ZXREEsPoWwZ5W5eNdSqX58DntVbhyVEFdfugs2NEs03la7kWxa8VOGgzPf6IOlO
         FetQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116045; x=1793720845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d2ojhVyA7G70YSFxIWDEXLUjmLV19PosvKcY5O6DkLk=;
        b=1XwKHlPpkDTuvpFw5wk0qBT8PvuzB/s902gQBcjCOg6AkKnhWL031mfaihMyLHXmA5
         ILMz8e9o2ERR8XLhUH1r1+IV4pZJtObql55gUvaKVtXD9JGOsPydDlqD0tzuGWOo+6Iv
         QeBBASj4xM4adYwEW61h8EH0ut17bqfhNW4M7kKDzGnlM5nvUl55jkzEKG2KtLiGEQpm
         MiP2Im2KTGKsNUmFcjtAdiFb/1g54PU/RPHeewwugo4d83tQfxRSB5VeLbMQ73TZknab
         LmQg1h74VZcObGEV2r8SqMcoDtXz72Ws4gxLRDtjQwg6pOZcVvjsAgvl0WxSncPt1dgu
         ri5Q==
X-Forwarded-Encrypted: i=1; AKwUvBxldm/XRQBeghpQCPSyfNh6AGRGxuZG0ciiu6zkaG9qCAtmVGm8HwupIWG8tEppFEAnfvanurZp6w==@kvack.org
X-Gm-Message-State: AFq9FYINVnXBcJlZcKAlF/1JiVpn8w7SycBbD0cAJBU4MwtfqXvQ5ShP
	WDE5y+EnCiHHdGj35781Y1QkwSmZ/ne4Klg4DIqJ11waLlEbfgb/V9l+
X-Gm-Gg: AYBFou2k+XZH06vxeDRlp8Ae5YDaIk2r1Sis51KW8FL6X7bIiiL4qspyQX3Ep1B9hz2
	O26zvbH+cYyLCp4To480xDTFbqbRB18j8w19qj2OdG9UxuoWEVY+MAjhRRArsc3Zl9cYuaPqPrh
	DmOi3NUxSUO7/TpKGCiuV0cmb/m/aB1dkeFUnC7KyyXvQfJbefACfGfgV0ougYK7kIJNiKSlJlm
	pR3o7Em6HSMaY8WJ5OOZ5oCwxN3voVk0xDv16UJ+ZVbRVC+sdXQzs/SexeX1enJDPXLjv5bTJCO
	uhMk06PoigZbrI2J81ReHSEALEKG9y7wEfUqYOqz/FdI2gaZfbcSWFtmvRpVUrF7kvBQ8oAHL5/
	kq557/tH3aEPjjmtaHrc8X/shxR2LNdoJ8W/Q7VfwMbjv6sbXk8qN9Zh8tr2gfGjIlG2Y+fvtBQ
	fu4R4tsAtqh9eFl/Nxi3QoujrGfgMYJWvIRYbZ1rMHat0tOUHYGstpHcSTUESK0TowokLdAt37G
	u/zVKJacUB9E6SRr9PysSY5zRw0c4mPD7p8hoGXO03IeqyHcpwOTxLC+sqGfP6MegRG/tetMVZR
	HeGvJPtviyHwWWhfnx8IsLQNL8LtARlFps/nEFzUVjkbT2hvHagj+wztoOACwJppbj0zH4e56bc
	ojW93rPWquguzVQqObjEHLtmRfun4VCOOdeE+0cH0o6IcwfxgD6FFDqVCG9iI9lVFHQ==
X-Received: by 2002:adf:f284:0:b0:48e:2980:d396 with SMTP id ffacd0b85a97d-48e3eb8d6a5mr16586892f8f.37.1793116044977;
        Tue, 27 Oct 2026 08:47:24 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.47.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:47:24 -0700 (PDT)
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
Subject: [RFC PATCH 13/14] samples/kvm: Back absent pages on demand in the sample provider
Date: Tue, 27 Oct 2026 15:46:48 +0000
Message-ID: <20261027154649.91571-14-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8707940005
X-Stat-Signature: fj9imohyrgsc5dgjwxx15gazca5azotm
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793116046-273858
X-HE-Meta: U2FsdGVkX18drs9AoPtncvqRmWsWbrPouSMrqrWSVJXsMOTusxMWNvALiqmfAFF6zyKcy/g8IAFAnKCZWLZivIWx3iRyoJso03YcMYbGPKdBzwW1E6VckolLnyJ/RTICCeKBWriWVvJ2K2jwJyG3zLi756LI617sObz+VwnSNqS98zw62JZ9OeM5wuEKmwqMagRj3qhrKiTCqJXhYsF26l+Soqu9qJAG2SU/ydOUMjK+/qpNJxCYQx8Ku+Jmn2TKC58h4pCypCb1hxCaKcBW57k24kzVt9WFtBtvstL+grGQPP0LK5jG2dkpbrRRX0fVjb2U/Cky8lTBCcOWVE2OFuvFJ4cpX6+IwbAMSxVezfGEc9NJwu6AqYJfETVi1LRlWLDszeLeT/iLke161SUor405H0SU1T4T8qgvsyS2/ZnysVWms6KPBv5I76wxrktkV3sog/13R/stPPB+DjbjwfAl0mBWMSBXMV148tCoHWDjNSQNkiFE583Vxs6LQSMeP8X0tCbBcWv1lom3NwG4E1SGsOshrPOlWDzh08VRsFIqKs5bbYfSSfD6bnshAaYVMglbh3lb2KvS3XBFXa/3VxRB8xlsDf620AavEQhW3XMjdhHwRdeyq9I9sD8xTwEaJqdHD8kcDv26ZSI1Ez57YvFkQRydyXjWKk4So1KpjHvKjaD4I3PZKEtJ+Q4dw1ltulI5n85l+bm+I6Z2/0RhoHotX8lBNL6RrVQgLp+kQGCWw/Q+ZtqOT9YJJVBMVxX9KCtOnDgicCZTjjJw6gwvIbp7561Fq6zcTq0gzMRF5T+xU2oZCsxEZn4sv+Mcf0BbAvmlTJoWDMb3o+hv/UwYZXOUCQUiM+h/s1oRl4CK2UWl4V5M92eDIRrsg7afop4XHnEwcm2/SLC1RVzSHFv5KboehTW5AsdF45dXZmscuRHJeuqNWtY5ba1USi4gU0Y+0wlSAI1LmS1OFlz8UnZ
 +snlu7NZ
 HNPlEH+Z6eRMqav8nQvGvKiysmxVx9yHuT4pYF+qMylsfne5zlIFo9TCJKI24dyoO1FgJMAASUT1+J3RyZ/J3gjPb0MIW51mAYU0Tvcu/41EHgzum8mcTN1rZa5qLEoFtyeGmDZk2eQ1MzUm1lxrbmwefgPou0rYSS+JoH9TIiRl7CKcphfQ3RyfvMrCS7TYJtYbs5YafWsYw9yos8vIQ5L91R6xBxEi4g7JOoxiWHT9qonDv9v9MYdFice2fCgm7fE2pexOEoiYcp+cbLfFKE5Bvf3VqxPUthYaYEPuBxKbGNmkBQIsuIdudoDyzNSm2eFxZtYU04z230xUWV2Vt4NCrASxg0YKSKdDt8ZDM8LSI+AXPKu5v/K4K/XBvNMAT0QdUzCuE/ZfbIvagN2aT1p0F0SlDiBTY+Mjo1U0yqdf7VIVOv7dTv8ol94KNA5BJp3nvXyB3SYCPbZSfaKpicU7c1XcWfs4gS3dWWBhoPIfAQfIPEnCbGUfq/D/nIpFoD92Vwyw1tyTFVk5fomvs38PRoL11qmUEcUrBoMxBFcq/qVR8y5zeFBqEQohBePCRmegYpTJntJywg/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

The sample provider fails get_pfn() for an absent page and keeps its
frames on a punch hole, so tests cannot exercise a provider that backs
a hole when it is asked for a frame, one that backs more than the page
asked for, or one that frees the frames that a punch hole gives back.

Add MPS_NEW_FILE_FILL: get_pfn() then backs an absent page with the
whole 2 MiB block around it, and put_pfn_range() makes the pages absent
again.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 samples/kvm/mem_provider_sample.c | 29 ++++++++++++++++++++++++-----
 samples/kvm/mem_provider_sample.h |  9 ++++++++-
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 670e36207e59..41e0ce5b6bc6 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -41,6 +41,7 @@ struct mps_info {
 
 	unsigned long *absent;		/* taken away by MPS_SET_PRESENT */
 	unsigned long *readonly;	/* set by MPS_SET_READONLY */
+	bool fill;			/* MPS_NEW_FILE_FILL */
 
 	struct inode *gmem_inode;
 };
@@ -62,8 +63,15 @@ static void mps_gmem_put_pfn_range(void *provider, pgoff_t index,
 				   size_t nr_pages)
 {
 	struct file *resource_file = provider;
+	struct mps_info *info = resource_file->private_data;
+	size_t i;
 
-	mps_zero_range(resource_file->private_data, index, nr_pages);
+	mps_zero_range(info, index, nr_pages);
+	if (!info->fill || index >= info->npages)
+		return;
+	/* Lockless, like get_pfn(): guest_memfd holds its invalidate lock. */
+	for (i = index; i < min_t(size_t, index + nr_pages, info->npages); i++)
+		set_bit(i, info->absent);
 }
 
 /* Byte range [offset, offset + len) of @info as page indices. */
@@ -228,7 +236,9 @@ static bool mps_bits_are(unsigned long *bitmap, unsigned long first,
 /*
  * The frame behind @index, and the largest aligned block around it that is
  * present and has the same attributes: the file's frames are contiguous.
- * Lockless: a change is followed by kvm_gmem_revoke() or kvm_gmem_restore().
+ * Lockless: a change is followed by kvm_gmem_revoke() or kvm_gmem_restore(),
+ * except a fill, which only gives frames to holes; guest_memfd tells its users
+ * about the block.
  */
 static int mps_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
 			    int *max_order, u32 *attrs)
@@ -241,8 +251,16 @@ static int mps_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
 	if (index >= info->npages)
 		return -EINVAL;
 
-	if (test_bit(index, info->absent))
-		return -EFAULT;
+	if (test_bit(index, info->absent)) {
+		unsigned long first = ALIGN_DOWN(index, PTRS_PER_PMD);
+		unsigned long i;
+
+		if (!info->fill)
+			return -EFAULT;
+		/* Absent pages are zeroed already. */
+		for (i = first; i < min(first + PTRS_PER_PMD, info->npages); i++)
+			clear_bit(i, info->absent);
+	}
 
 	ro = test_bit(index, info->readonly);
 	*pfn = info->base_pfn + index;
@@ -307,7 +325,7 @@ static long mps_ctl_new_file(void __user *uarg)
 
 	if (copy_from_user(&nf, uarg, sizeof(nf)))
 		return -EFAULT;
-	if (nf.flags || nf.pad)
+	if ((nf.flags & ~MPS_NEW_FILE_FILL) || nf.pad)
 		return -EINVAL;
 	if (!nf.size || !PAGE_ALIGNED(nf.size))
 		return -EINVAL;
@@ -337,6 +355,7 @@ static long mps_ctl_new_file(void __user *uarg)
 	info->cma_pages = pages;
 	info->base_pfn = page_to_pfn(pages);
 	info->npages = npages;
+	info->fill = nf.flags & MPS_NEW_FILE_FILL;
 	mutex_init(&info->lock);
 
 	fd = get_unused_fd_flags(O_CLOEXEC);
diff --git a/samples/kvm/mem_provider_sample.h b/samples/kvm/mem_provider_sample.h
index 57f494dc46fa..45ec9605b593 100644
--- a/samples/kvm/mem_provider_sample.h
+++ b/samples/kvm/mem_provider_sample.h
@@ -19,11 +19,18 @@
  * Returns the provider fd.
  */
 struct mps_new_file {
-	__u32 flags;	/* Reserved, must be 0 */
+	__u32 flags;	/* MPS_NEW_FILE_* */
 	__u32 pad;
 	__u64 size;	/* bytes, page aligned */
 };
 
+/*
+ * get_pfn() backs an absent page, with every page of the 2 MiB block around
+ * it, instead of failing, and put_pfn_range() takes the pages back: a
+ * provider that allocates on demand and frees on a punch hole, for tests.
+ */
+#define MPS_NEW_FILE_FILL	(1U << 0)
+
 #define MPS_NEW_FILE \
 	_IOW(MPS_IOCTL_BASE, 5, struct mps_new_file)
 
-- 
2.47.3


