Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 933C0FD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12F56B00ED; Fri, 27 Feb 2026 15:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD346B00EE; Fri, 27 Feb 2026 15:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9596B00EF; Fri, 27 Feb 2026 15:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C911F6B00ED
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:12:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92E76BBB39
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:12:29 +0000 (UTC)
X-FDA: 84491334018.01.3D583C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DA4E440002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:12:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XV3R41u2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/m3MqIEX6AkMye3eSum2W1oL4VvXYBIQlIkGRZjJ28=;
	b=yhLnUXoX9n9EVuJmUWiE7pn03Aw2O71OWGQURk+F2dEOx4dkLI+UkRAknN7BpMjmWCTCBF
	l3NlQcdaYWQ8uknIZcAByTllqM0FtSqBQHQY34aU2p9J25ihzjczOoo5XE+GK+jinDwEfR
	omdL3udMiUDD4aBiE3V/59rmYwfMaL4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772223148; a=rsa-sha256;
	cv=none;
	b=M0w9Rim+JIyOOSKVl5WfknaV5GrJ0HsIfQCykM4zE+Vsip6n/IhV3PpJTfJq3DXpYjp1/p
	sMuLUDCo0aohb6pJZDLwClTzFCwmwgGMz7vklilfJ+Wo/Tvx0UDlsd45PTkLYn62JvVieB
	y6ckagYizCNFMp07cp3EFc9H8AvoP3U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XV3R41u2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EAAFE41843;
	Fri, 27 Feb 2026 20:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047EBC116C6;
	Fri, 27 Feb 2026 20:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772223146;
	bh=aB5tiNSbiWIs8J38wzKTGn9gBoLw1Ed2QFc8m6G1lhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XV3R41u27yOs3AucAXItd/ZxAZjAbvL9zkvtgql+u+4ijDgzXZEbk77WEppDG6XbQ
	 RaRDFQEIdi93XVV3MnYwhO+PQuYzL6HPudiNqhTkElOIxON9zpQ28ddXnRauD5K7xI
	 pPAPZLRWc+u8ZveolZp8sk3xfxpltOLQDdxGrANzjZcI65k2mZV2C7NoEkTTWxEEvR
	 CAFqu7YxseHBUNNfvGMccb+W5iBgk9khfRU0vAq0qlcZ/q5lDlnaLNcSa+FLgrhULj
	 YjzvWS5u0pea0U3pcj1C2Qe1JsARvSTKUCz1+bSDPl3+jOtxbrGUap4h/9n2umCd7p
	 tlC/aFeo6fWmw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v1 12/16] mm: rename zap_vma_pages() to zap_vma()
Date: Fri, 27 Feb 2026 21:08:43 +0100
Message-ID: <20260227200848.114019-13-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6xupu65xoyzwjibqrjpebqz584qufpsh
X-Rspamd-Queue-Id: DA4E440002
X-Rspamd-Server: rspam03
X-HE-Tag: 1772223147-257245
X-HE-Meta: U2FsdGVkX18jfICe1kL2a6ECxn1lN+5T9/bGHM9X9Aj2mYVY5DhBuBwYskfaM/GlGnqxCEZo1ZvftaBM3lyeL390s8gtBhKfo2TeFlmZImzLN5K5sE5unzu5pjFMngCe9yr5JWc9UrY4niKF13E/iZAoaoViUOkX9K31iQZ/KbfkRqaJ5guWzvltHT4CmbkbGrhuyB+By1lCQrlXsW+1THBp0BO5n73FRvNUJQKvryvzpuclmzBPm2gxWlzCutEoAL/STJflo9LM9O1Xf1NFQK0XYn+YEv2z/bhoDpF/T1ogUVpjnLVkJUMuNLhTOEtnBChFBptDy86Imz5KkM0igHiekrh394LLcM5XL8GSjF03niWHVruGFDTq9AP0+uIxRBu30NOPZsIQBIqF8U2h2bfCQkJQG0JEO/1+RqmTi1Roj5xNQypb/AbUkS1pkos3a8oFN+B+/otSMgBAHOHeSIsv2Z9WQ3+b+3udHyriZz/7QQ7vTgLk7cjcuJ/8oU+xyvIPV4+MJ50fHmNfOCjj2qiOj0HZtmeDwwFV+gVPlYLCWEkuHCfJSA4+fjO1dLqZ2QcgCeTNfcHtp7hyDoMPMJX5vfbWIilE3386urre1cf7ATbOYPbhkJublwemeOKf1ihdy+g33Cm3YFUeoVJiDGrNtWMJhNuJvdyEQpuGz73mad3TYIzGtJ2XtWOLsP9ehBjwAdISmadlmrOH6f/Ysh8esZ2SQJ4aUTcVEpt0wARzXJw8Na/NnPAiP8t4F29wg9GOb0PsG3ZGz2Efnb3mXLvIklmhINiIetW+egUOFUQ1zYZirE98n7bJDqbUCclIHTcj7ePhaciU9yIwNLiJwDd/WyUIFW39dcRcqFmML/uZnJ5sBnaWMoOgYG/xlXELeBv8wEMRPmvr0IwJjhzvYGgqnVVkVGkHZGAJWvtJ1z8UShIqlfAygSE12WwQ93QPu+H7YucdsYtERwbGEkb
 w/plIRJH
 /LD3FA8UNJD3DWVvexyGj32CKbM72CVIl5PpHSs3mMfGmGDxbaK4B9uyai6dOvl1JW9JBiyLKV6g38gTcVSXvT8CODE52NOVkoof9IP26ynDXGzbq4g3kBK61C1yWUzOnhxFTZpbD3MnUQ9BuyMw1gGQkjsKaqt2ctzUFDWAgchkc/pf5CcoZGHgG6HhW2CSUDd8xZsqKtW3SFQVV/96rCCtk8x1249R01xIv1sVd+nx+cbHT0JtNH30LZh9NmQOPN1B953joIDM/3RDMDYySWIYTnA8C/z1VO1eVaIZWW8cTSAGNnnoClHTIIo2nJLSNWGvN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's rename it to an even simpler name. While at it, add some
simplistic kernel doc.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/powerpc/platforms/book3s/vas-api.c | 2 +-
 arch/powerpc/platforms/pseries/vas.c    | 2 +-
 include/linux/mm.h                      | 6 +++++-
 lib/vdso/datastore.c                    | 2 +-
 mm/page-writeback.c                     | 2 +-
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
index ea4ffa63f043..e96d79db69fe 100644
--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -414,7 +414,7 @@ static vm_fault_t vas_mmap_fault(struct vm_fault *vmf)
 	/*
 	 * When the LPAR lost credits due to core removal or during
 	 * migration, invalidate the existing mapping for the current
-	 * paste addresses and set windows in-active (zap_vma_pages in
+	 * paste addresses and set windows in-active (zap_vma() in
 	 * reconfig_close_windows()).
 	 * New mapping will be done later after migration or new credits
 	 * available. So continue to receive faults if the user space
diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index ceb0a8788c0a..fa05f04364fe 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -807,7 +807,7 @@ static int reconfig_close_windows(struct vas_caps *vcap, int excess_creds,
 		 * is done before the original mmap() and after the ioctl.
 		 */
 		if (vma)
-			zap_vma_pages(vma);
+			zap_vma(vma);
 
 		mutex_unlock(&task_ref->mmap_mutex);
 		mmap_write_unlock(task_ref->mm);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4710f7c7495a..4bd1500b9630 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2837,7 +2837,11 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
 void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 			   unsigned long size);
-static inline void zap_vma_pages(struct vm_area_struct *vma)
+/**
+ * zap_vma - zap all page table entries in a vma
+ * @vma: The vma to zap.
+ */
+static inline void zap_vma(struct vm_area_struct *vma)
 {
 	zap_page_range_single(vma, vma->vm_start, vma->vm_end - vma->vm_start);
 }
diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index a565c30c71a0..222c143aebf7 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -121,7 +121,7 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
 		if (vma_is_special_mapping(vma, &vdso_vvar_mapping))
-			zap_vma_pages(vma);
+			zap_vma(vma);
 	}
 	mmap_read_unlock(mm);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 601a5e048d12..29f7567e5a71 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2645,7 +2645,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
  * while this function is in progress, although it may have been truncated
  * before this function is called.  Most callers have the folio locked.
  * A few have the folio blocked from truncation through other means (e.g.
- * zap_vma_pages() has it mapped and is holding the page table lock).
+ * zap_vma() has it mapped and is holding the page table lock).
  * When called from mark_buffer_dirty(), the filesystem should hold a
  * reference to the buffer_head that is being marked dirty, which causes
  * try_to_free_buffers() to fail.
-- 
2.43.0


