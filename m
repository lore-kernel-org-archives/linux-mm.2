Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC0C60A2627
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UPIXW2RJ
Received: by kanga.kvack.org (Postfix)
	id 1AC256B07E3; Tue, 27 Oct 2026 11:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6EB6B07E5; Tue, 27 Oct 2026 11:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C726B07E6; Tue, 27 Oct 2026 11:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A91BD6B07E3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 309551C440E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:08 +0000 (UTC)
X-FDA: 85368834936.08.09CBAD0
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36CC118000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UPIXW2RJ;
	spf=pass (imf06.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XmHIaCziVnimE5Tmq06/pKlKxzGziqQCKkgGCcdE51k=;
	b=kdsKdDQgZAuytufec1WUtSCJf1N7K6VBbkivQuhk70kWJJx5WYc9PJPUurhHEqVvEAUaDi
	yO3mD0egZpQdUpYlWcYUeaT8rGg3dMj3LAkYdATH2CX2Vmaivnk8uvBU/CSb3ZIKpr7MYy
	sB2k6m2S6S9Cbf9Uiy/L1Cp22/qY9yI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UPIXW2RJ;
	spf=pass (imf06.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116026;
	b=aDFFl0TjGFkVmMOtofkUYpGU9nEJCGG/U833SPROfHrw/08eejtOFAoIPiZPzUbOXIIB1/
	cJNnWX5DCPOgmPGuuIHYx2iyMVEv/y34O8EMeQ7po3/QBgtMazeDWGsZdjGEFAk+kyx1WP
	R761navowmm58ZDx1E8sux3Csut8yO8=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e3b22e971so2074362f8f.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116025; x=1793720825; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XmHIaCziVnimE5Tmq06/pKlKxzGziqQCKkgGCcdE51k=;
        b=UPIXW2RJf5aiJWoYtVIEXugsizTCzX68659cYe/5Qb/paT899RU2YJkZZ2JkPoXzwm
         xTGwLxEVtIj30Y9EYNuagRg8AoSGJ55EvlGTLp2Znl8cvdKt1NCypg4qYhm/gfQG+zWk
         iBG12pHeAPDRoh2qa7IJMFFgaYlsqC69J6zWfmXnhASeI6SzsTXBVkU5/wO22+yu2h8b
         /OTBVxMYkN9L6hvq2mQapgOqOOTmSxKRhU9K15PfCGYic1XhgeSuLgCIA1Cuc9sazOPy
         WGJkWS5IPqEjoQPUoBlpzRb37JbhgMsgGkqdHIHzSAUp2RJNQeFerOp8z3biDPSLvQfZ
         imdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116025; x=1793720825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XmHIaCziVnimE5Tmq06/pKlKxzGziqQCKkgGCcdE51k=;
        b=x842/0jKYf3zs5ZDMp5NeTyjiyvaiGjoeSFpXz1/C+a2T6qeymRxoVu4b0iwDwZ27z
         MPVSEc5n0bFeXZ1db+tk8k8WniLklyVkN5j1jmxbvVt24bB1spggnRlNi5NIGXf1zl1d
         a5I0rCNrwRtVVlpz/RkCDJXq1mnTNndfwWUY+F9mztumKXTSwJV4TLtG0HjWqaK5trqS
         yZBOvzvgXAC+/On4eryUrQZZkUH0tFbBvCPkbuhPCDy/RRJTO5EZ83WzKJuwnJH0nDPL
         gmeLqM46z0ekx/d0Bo2vzSyb/qvPawpa/CiHk+xpSa8uQyZ1ol+QcN5I1LEpmlsGpoA/
         t+ng==
X-Forwarded-Encrypted: i=1; AKwUvBwHaVgNWNZMOmxHEOCLR7ZNcmOYOXeLvdKiI46RBFMQoc9TUb/KRe9vPvRFpsZXJzLybv9z2wCGCA==@kvack.org
X-Gm-Message-State: AFq9FYJtkMSIhgJyc4WGCQMu0hiQ7UTSvfLtOsxOiWGMn5fqXqu4DZ/x
	g1gU0VDTQFZAk7WQIHBJ24n3SJLREv87h61sHijVtSA+B/bDoBG61kLo
X-Gm-Gg: AYBFou3xuKLzPYJroA3Muj3uSSiKVpW6TBwmrMngB/rWsBWPHiJ3wZ6iOS7IvIa3RT8
	8pNbx7Tn/PDO0ossROzIH8fM8+LQyF0J+Qn3Ig2gS0v+dmTpC5HQuLU0ZN9DObxE1IrY5iDPoqN
	RB7EHu3TD4ulDDB4IA+svPYn50uKNJ+qNDeg92kvYu5wvvg9jEk/JjjzdWHsp2h26O5MB9QeRgq
	D77TdGjbqa5MfhQQ10ELb0VoUwLe6gJGvNOKfMf31Uv6DAkIVfEgDAOUNIlc97yaNMG2ncrERdY
	An+Nki5eueG2Wj2l0oscP/x+pQ05CfXUJUHUaRV3ATXIAwlAXiaSLWvskTjcTwI/kJb8vlB8oa6
	hVKFu+wb5obnzVhfdxAe1Qy4dRHbwu94O556m/LxVHsc2IMib1frwhN+rZj8+K7uRNc+eEusg6i
	O+UUXdbY2uNJLQdt1sGFRNGBXbbfd+QvdgNxgHQe27vWNg54rhdkgYE5aeqFYxITKDbBe54BrSv
	mdK/Ei3PvsFZlDZKceDtAs34V/A3GhrrpcXtXGue89drl0zqcH992SidYeAL4bHtYDSC4EW6oNz
	5np1rnPLlDEJCgoVttQMihzWVmPCyko39X5LzUcQdlJqj2wdWE5pqMl2A12fs+gZD2H3J/tW9LB
	kPaaBmhVnVolXgspG3si218wI4ngjiYcu+0ryKw==
X-Received: by 2002:a5d:5f48:0:b0:48e:4835:de5f with SMTP id ffacd0b85a97d-48e4835de71mr16505478f8f.47.1793116024472;
        Tue, 27 Oct 2026 08:47:04 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.47.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:47:04 -0700 (PDT)
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
Subject: [RFC PATCH 05/14] KVM: guest_memfd: Export PFN mode files
Date: Tue, 27 Oct 2026 15:46:40 +0000
Message-ID: <20261027154649.91571-6-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36CC118000B
X-Stat-Signature: o6rk6bnom58df3xo39q4uebgxubj9fwt
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793116026-254877
X-HE-Meta: U2FsdGVkX1+3Da+jBLBCNz0KGlXC2uR/vXlnDbcTM9AjrWITzsB5dli23nDXjOKgDpPdb3v0Ny3/yKRO7E08Ru9jjmJLRLseU12L7l7qoY0dmqJGmFiYW+HsFGFmf2faGYGxDH3ZFhTvRcNNgnvOuzPuDlQBFAzbjPVTr/P1PX4AxNcYUpfAtMizEqsl/PXSBRrTe6ER2EnMOR100zER7l4Bh8SMnt6FEtbT+nKmWvrMcp4aYAu48SIsUlqrE8Yy5S6milm1XuGOlt2Z6EgiwwGulMsq5hZUIaVBkY73gm1/FoHg0QTP15dAuR+ERDWmXYQWf3jC+IhLW2K6pD/xaEzyN8g+WUHWqL44y9T7nvb60fuJS7Y2OmjEe6fbm0XGMMJdpt1UFH39gnCbKD8E5hxrbUQhLmLd46LenHtcDvlamRZugGEq5C5IrqXfoYj4ssJhi7K9Khfz6qYQbGFHLsklUOspSEYX2R4I4PKiPqRBgY/UqvfQtbYYyJQacVD4jl8vDyLSVHf4I6fZUUqCuvweEIS0glkPh/KuLmEsJPoLpFLN+d7jV0CSNFPjMjYOianBnX3BYOe1VyKq80HFZ7CNa+PM8epkoZ703XNalPogBAi9fjASoeEoRS7vFLb/8LZrNFZBDM/FYfZ8JLmKKvIBlsxZiFpJ5AY3Ocq4aX7woJJgkUTotFNHzGNB9IRfZxlX0TKWdLSB2QeqgtHokw9w5WCeHjb6ivd05lqWdFItNQCqWct3/Otq0PhOAC6zgMODhisWzX3YkRVfzs1XqoGhetRXXx2rowBw3yCaIHDhPwTUXyMvpGKW1RaY7Sp62x9RIarxGz/ubFujsCiey+0wpMJXoTPZg25kU4TveMYA8tEQdVEReC/9FbKpSk3DCd/k9iSSXq7hDr2ebFB3sacohGPFaF5YNdZMubC7gHcnnflBFv4yZVWW8r9cyEy5OVibnSd0bOs+ryf5bH1
 lX7fayV4
 VQmCOqhv9XfI7uY6E1HlMBMwlJsG/2Xj8meecrxu98qrR3OXRn5o2ZaVXvcdu9U9lDr6dIq/wjz6j/eAP40kADTVpYmMNBNWIXOhV1LeEW7TeC+pa2nqGFWy2+IC3KfWC5Tlmm01aBazkUmJYzOVsnPLWhlVLVkAzMLNM7MCAsF+X1h2RuJMjJX9aLZcyWOpjX73mlq87GAAifWiGOjAp9ZBqCNMQBGfziBW4Qs8YqCxhUgYPBxAx3L42Y5clm+TLB6rycNpkvjgZLxviMtjRmKVpbHg2d0Nn9sTybM3zH8LcJXFL3JKIGAvvXoN9W76v08pjoplWIwpAeVkE7Hh0bhNS1AHeYn/g8Cup8MGKNeyr/qccVFp2XiG2jqQWO41ZfdcghWFNfYXswpD1AQ/5Sz9P6FimVUrkmfeojKRS16magYp/SSwSNDUqwEkUQa7JlCErHFY+YQxeASQ3BRnUjerb5N6hhc0IAVwH7MTSYA3iaP9aBecFKbjpX/7jI47h6XufIY10L0stv+AhkpBq0QyalfmT3QwTHnPVnOfE5Iq5fOhtCKTSjMnyEgfoHfhtUN1uQ1LkNBJw8jFRja+TTWzt2hFc/aVFoou7eovMaEcS3caF1nWWjEqgzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

PFN mode files cannot be attached yet, though a provider's frames are
the memory that most needs a device mapping that follows its revokes.

Allow them. A lookup asks the provider with lookup_pfn_range(), which
allocates nothing, then get_pfn() for the block and its attributes. A
revoke updates the exports before the frames are reclaimed. A punch hole
must remove the frames from the exports before the provider gets them
back, while the provider still backs them: lookups report the range as
holes until then, and the exports are updated again afterwards.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 include/linux/guest_memfd.h |  20 ++++---
 virt/kvm/guest_memfd.c      | 111 ++++++++++++++++++++++++++++++------
 2 files changed, 105 insertions(+), 26 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index ba3eebb1ed1a..937693ae9573 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -90,13 +90,13 @@ static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_
  * nor fault them.  It attaches to the file, looks up the frame behind each
  * shared page without taking a reference, and guest_memfd calls its update()
  * whenever what a lookup returns for a range may have changed: conversions,
- * punch holes and memory failure.  update() makes the consumer's mappings of
- * the range match what a lookup returns now: a frame, or a hole for a private
- * page or a page without a frame.  It may be called for pages that did not
- * change, and for ranges that do not follow the blocks that lookups report:
- * the consumer may then remap whole blocks, also outside the range, e.g. to
- * merge them into larger mappings.  A consumer that can fault may instead only
- * remove its mappings of the range.
+ * punch holes, memory failure and a provider's kvm_gmem_revoke().  update()
+ * makes the consumer's mappings of the range match what a lookup returns now:
+ * a frame, or a hole for a private page or a page without a frame.  It may be
+ * called for pages that did not change, and for ranges that do not follow the
+ * blocks that lookups report: the consumer may then remap whole blocks, also
+ * outside the range, e.g. to merge them into larger mappings.  A consumer that
+ * can fault may instead only remove its mappings of the range.
  *
  * Until update() returns, the frames it replaces stay valid, so a consumer
  * may switch each mapping to its new target in one step; once it returns,
@@ -111,8 +111,10 @@ static inline int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_
  * same time, also for overlapping ranges.  The consumer holds a lock across a
  * lookup and the mapping it installs, which update() also takes.  Lock order:
  *
- *   guest_memfd invalidate lock
- *     consumer lock
+ *   PFN mode provider lock (across kvm_gmem_revoke())
+ *     guest_memfd invalidate lock
+ *       consumer lock
+ *         provider leaf lock (get_pfn(), lookup_pfn_range())
  *
  * A consumer attaches and detaches outside its lock.  KVM may be a module
  * while the consumer is built in: consumers reach these with symbol_get().
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 65a951fa49c2..015f6657c386 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -40,6 +40,12 @@ struct gmem_inode {
 	const struct guest_memfd_provider_operations *provider_ops;
 	/* Subsystems that map the file, see include/linux/guest_memfd.h. */
 	struct list_head exports;
+	/*
+	 * A PFN mode punch hole in progress: lookups find holes in
+	 * [punch_start, punch_end) until the provider has the frames back.
+	 * Written under the invalidate lock, read without it.
+	 */
+	pgoff_t punch_start, punch_end;
 
 	u64 flags;
 	/*
@@ -515,15 +521,32 @@ static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 	kvm_gmem_invalidate_start(inode, start, end, filter);
 
 	if (kvm_gmem_is_pfn_mode(GMEM_I(inode))) {
+		struct gmem_inode *gi = GMEM_I(inode);
+
 		unmap_mapping_range(inode->i_mapping, offset, len, 0);
+		/*
+		 * A punch hole gives the frames back only after the reclaim:
+		 * until then, lookups find holes.  Afterwards, the exports map
+		 * what the provider backs the range with.
+		 */
+		if (put_pfn_range) {
+			WRITE_ONCE(gi->punch_start, start);
+			/* Pairs with the smp_rmb() in kvm_gmem_export_pfn(). */
+			smp_wmb();
+			WRITE_ONCE(gi->punch_end, end);
+		}
+		kvm_gmem_update_exports(inode, start, end);
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
 		if (pfn)
 			kvm_arch_gmem_reclaim(*pfn, nr_pages);
 		else
-			kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
+			kvm_gmem_pfn_reclaim(gi, start, end);
 #endif
-		if (put_pfn_range)
-			gmem_provider_put_pfn_range(GMEM_I(inode), start, nr_pages);
+		if (put_pfn_range) {
+			gmem_provider_put_pfn_range(gi, start, nr_pages);
+			WRITE_ONCE(gi->punch_end, 0);
+			kvm_gmem_update_exports(inode, start, end);
+		}
 	} else {
 		kvm_gmem_truncate(inode, start, end);
 	}
@@ -1258,8 +1281,7 @@ static struct file_operations kvm_gmem_fops = {
  * guest_memfd calls @e->ops->update() from now on, and holds a reference to
  * @file until kvm_gmem_export_detach().  May sleep.
  *
- * Return: 0, -ENODEV if @file is not a guest_memfd file, or -EOPNOTSUPP in
- * PFN mode.
+ * Return: 0, or -ENODEV if @file is not a guest_memfd file.
  */
 int kvm_gmem_export_attach(struct file *file, struct guest_memfd_export *e)
 {
@@ -1267,8 +1289,6 @@ int kvm_gmem_export_attach(struct file *file, struct guest_memfd_export *e)
 
 	if (file->f_op != &kvm_gmem_fops)
 		return -ENODEV;
-	if (kvm_gmem_is_pfn_mode(GMEM_I(inode)))
-		return -EOPNOTSUPP;
 
 	e->file = get_file(file);
 	filemap_invalidate_lock(inode->i_mapping);
@@ -1310,28 +1330,83 @@ static bool kvm_gmem_range_is_shared(struct inode *inode, pgoff_t index,
 	return true;
 }
 
+/*
+ * PFN mode: lookup_pfn_range() first, so that nothing is allocated, then
+ * get_pfn() for the order and attributes.
+ */
+static int kvm_gmem_export_pfn(struct gmem_inode *gi, pgoff_t index,
+			       unsigned long *pfn, int *max_order, u32 *attrs)
+{
+	pgoff_t punch_start, punch_end;
+	int order = *max_order, block;
+	unsigned long raw_pfn;
+	size_t nr_pages;
+	kvm_pfn_t frame;
+	int r;
+
+	/*
+	 * The end first: a new end comes with its start, and an old end of 0
+	 * makes the window empty.
+	 */
+	punch_end = READ_ONCE(gi->punch_end);
+	/* Pairs with the smp_wmb() in __kvm_gmem_revoke(). */
+	smp_rmb();
+	punch_start = READ_ONCE(gi->punch_start);
+	if (index >= punch_start && index < punch_end)
+		return -ENOENT;
+
+	r = gi->provider_ops->lookup_pfn_range(gi->provider, index, &raw_pfn,
+					       &nr_pages);
+	if (r)
+		return r;
+
+	r = gmem_provider_get_pfn(gi, index, &frame, &block, attrs);
+	if (r)
+		return r == -EFAULT ? -ENOENT : r;
+
+	order = min(order, block);
+	if (frame ^ index)
+		order = min_t(int, order, __ffs64(frame ^ index));
+	/* Nor may the block reach into a punch hole. */
+	while (order &&
+	       round_down(index, 1UL << order) < punch_end &&
+	       round_up(index + 1, 1UL << order) > punch_start)
+		order--;
+	*pfn = frame;
+	*max_order = order;
+	return 0;
+}
+
 /* What kvm_gmem_export_lookup_pfn() returns for a page inside the file. */
 static int __kvm_gmem_export_lookup(struct inode *inode, pgoff_t index,
 				    unsigned long *pfn, int *max_order,
 				    u32 *attrs)
 {
+	struct gmem_inode *gi = GMEM_I(inode);
 	struct folio *folio;
+	int r;
 
 	if (!kvm_gmem_range_is_shared(inode, index, 1))
 		return -ENOENT;
 
-	/* A folio that was never zeroed is a hole. */
-	folio = filemap_get_folio(inode->i_mapping, index);
-	if (IS_ERR(folio))
-		return -ENOENT;
-	if (folio_test_hwpoison(folio) || !folio_test_uptodate(folio)) {
+	if (kvm_gmem_is_pfn_mode(gi)) {
+		r = kvm_gmem_export_pfn(gi, index, pfn, max_order, attrs);
+		if (r)
+			return r;
+	} else {
+		/* A folio that was never zeroed is a hole. */
+		folio = filemap_get_folio(inode->i_mapping, index);
+		if (IS_ERR(folio))
+			return -ENOENT;
+		if (folio_test_hwpoison(folio) || !folio_test_uptodate(folio)) {
+			folio_put(folio);
+			return -ENOENT;
+		}
+		*pfn = folio_file_pfn(folio, index);
+		*max_order = 0;
+		*attrs = 0;
 		folio_put(folio);
-		return -ENOENT;
 	}
-	*pfn = folio_file_pfn(folio, index);
-	*max_order = 0;
-	*attrs = 0;
-	folio_put(folio);
 
 	/* Nor may the block hold a private page. */
 	while (*max_order &&
@@ -2042,6 +2117,8 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	gi->provider_ops = NULL;
 	INIT_LIST_HEAD(&gi->gmem_file_list);
 	INIT_LIST_HEAD(&gi->exports);
+	gi->punch_start = 0;
+	gi->punch_end = 0;
 	return &gi->vfs_inode;
 }
 
-- 
2.47.3


