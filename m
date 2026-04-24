Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EABCFF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28E86B009B; Fri, 24 Apr 2026 17:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0A96B009D; Fri, 24 Apr 2026 17:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978AF6B009E; Fri, 24 Apr 2026 17:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 815F36B009B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:13:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43CBE86649
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:57 +0000 (UTC)
X-FDA: 84694701714.04.D78551B
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6919B180004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y+PFNVKQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqDSoqQFeKS+EClGztfCqJhTgKB6YvX/XVfIE7se57w=;
	b=kQOvWUVx/flIsRDeIQqUuprIzCsIG/vLIrJfCkcccZ2PhOcDLZbvImtuiYZaPtUf+ZXUYr
	PE5bcJo5Qygl6MwE8wnc27Z4V2MvhNWic4iI6x9nD3i02grn7Srx+O1vVRKl1Q3BgMFF7i
	nTV804AssoV72B9pDdudJekT4uB97Fg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065235; a=rsa-sha256;
	cv=none;
	b=LJKsfumAfQxufW8G9n4s0OJz+x7+mlhk1/HNEYbw8YenPOdL9Wjnn+l2uHhbQeY35eTSVS
	ZdAmkyMtjftRvsYMSLtwZMkfNogP4Her6FHBODUZseshkn24pgMLpWkRQ8bYglBWvNFTlq
	kBE0NioDU8khsRxScBMA3UQan1eN8rY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y+PFNVKQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=elaidya225@gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43d03db7f87so5663582f8f.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777065234; x=1777670034; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqDSoqQFeKS+EClGztfCqJhTgKB6YvX/XVfIE7se57w=;
        b=Y+PFNVKQQ0pzJCTqZ4NkDDeHXgyZL/aP30NrS3A+DziZvUtWgYTNZuh0A1CPz3AXYD
         W+hb9IupaHGx8GimTesDjJJY8R3SWnFkEwTdaPJmIKG25S8ozkWObpi2O+Sst5P+Cm7M
         INW3NX2VR2ergd4ik9n6wU8VT8jXhavhfoJVRA/MdI/cEcGkIvA6AFf4K6Qx45crH3Sw
         9WAZQFgE3aTyR3De6vzcx9+EZ6viNGjTivkLMz0ybnIxGNWbi+AAiKHxQttlcJ04jF2K
         2yBHgqHvuNAf1FhbMhI125jb+Euilr2YKvKFLw6LM1OjU1omQd/Q9D9Ibv5X2YAbO2Uw
         rCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777065234; x=1777670034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KqDSoqQFeKS+EClGztfCqJhTgKB6YvX/XVfIE7se57w=;
        b=rob2OLwX5+eeZY//tRP2FEsAjr4Xf1lI/aAHuZc4nyn+BD2z8+tTauySIpu64VsC04
         NGJRafQ+a5FZPVKWAgk36G5MQykQUccaAgwBFn6CvjEr274MyqTtCin/dZyGy7vKblWR
         pQmKueIBTnT95mHt47vE7kCMeL4sYFr5ZLm8aKls9xCZm9MFfI4mrG2mI7qyPftQe4QO
         OYx5BcA6eC8MUUVUsakuK+oGmfJWVFfaAO3tVjfOGjLREv0dfO6cDN9CMypdvpMqdUVH
         BLTa60QkYgwFmDcaf/xmhGu/hORcqnx/j1D2wAnQeiiKHb1kTMF/z7+3A0z10FRjnkzs
         223w==
X-Gm-Message-State: AOJu0Yy8WfFuIUgjxDtIs2q2FHiq88YCYuJPdnEDmpl9ZgCOBEisRGlB
	8MsiR0R3vGr9ha5lYg5z7CqQb13c8yNuKxdbCEvr1yRXlaMDQxUG5u5r
X-Gm-Gg: AeBDietF7i/SCQUGY3jjieXX7pR0a9VMWpcxZ0zkZm/v5zXCBd0/GpRScUNzveNjUtW
	bwaUw4lIDfz2G8iYdVzPX0qG+pBayNInqrxVo2HaHjFNJY+sDNkGkKuDkAha+RcA4IQEOWHPwD+
	8ulXj3PmE1lZJEPEN4IwpqFTZbm+XlHjQXTIDdEw+0DPN6w7rChiIqocoGzUpKx0rxDCbE2Zi/1
	qrSvbkygoinbH171Ny0N9FqLe8HMdg+k08IZsWElErGlcS/SV6Ulm36m5Xog25nb5MiVIPZxZVd
	ZlvnUOxzHYFWOkLwSxrJGFLY2RqCaDYjPujtomE2SYW3kFSv3sJTcjytFZnvNq/+Vpl3CPDD5rZ
	OGd9bUyZiMkwLt32xLH5d1iN4konHYYPVWpCtWtZSbj/dZKc28tTjXwebdfluK576vfrHMtpeTC
	71GMLiceSgzvjl0crGde4kpSmf+MMr5w==
X-Received: by 2002:a05:6000:1ac9:b0:43d:6787:9934 with SMTP id ffacd0b85a97d-43fe3db39b2mr50423602f8f.9.1777065233899;
        Fri, 24 Apr 2026 14:13:53 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm63845677f8f.3.2026.04.24.14.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:13:53 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	avagin@gmail.com,
	Vlastimil Babka <vbabka@suse.cz>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH v1 8/9] mm: propagate VM_SOFTDIRTY on merge
Date: Sat, 25 Apr 2026 00:12:42 +0300
Message-ID: <20260424211315.1072123-9-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6919B180004
X-Stat-Signature: h77ecxjegwssp6z8u8tiowwqmunca6sh
X-Rspam-User: 
X-HE-Tag: 1777065235-153581
X-HE-Meta: U2FsdGVkX19Fox5e3u++GJb3Qh/I+r9BKrlV1SQ4pNH2B63i8wBP72G9sYHf5BBtdDwI9/BgcXUOsqsHfLn0QdLkY9qzLyUgD3rWC+j7NAw9j3iansxKCp3tAWvd4F6TAC9yirZKBMrCAunnAPFo0jktKMsxm4x6ze8IGUGy2S7QnifUivdSz/ruXD+1hLWclddaawIC1MbWFolVXJ/tAUQZqH4Ac8EkEKbuOgll+00eDjoqeZjo17ldmgNuFSwEtz+Fl8qFA1XK+4lIot6XdFavQUFo9BNWRJJ0YH8ERn3bOSrrqcky0hM4wSZz1d/4MUVGE3o2sXodVnO9gBRSNz+6IDIYPXk5PW3HZXT+e/rxNeTTs2KCLFhVht75CLrHK5Lygfe06utXbluWrA/zvFVCJtX2HIAA4hm/FXGrS9ESuRv5VY5Hl7cwtji7dPo/fLP6FJCwMKIufNr7zyIFCtmaOMoM4TJUsIk5/aNOMw9SjaCpLibyGKAClfNZixMRPTwejIoyg389NZq5AJS/bJaAfAnxK7fUgNr7wAm7KI7/GQTMACIVXosWnMMjaXbaBiZyAuXm/bUZH/BnNnOW+Sq6JmkxZwjl7eqS2RmOJwZnyA7WReVgaLIEpNty/OI/Wv0ssqn6lWHXoSDJ65B4b3UQH3iqhdDwzHMLE7rryEIqiFJ92f3U1c7to9/Ytx9Dw2N7aeeNXL0QHDm6O7aLVzZrijE65myRPs/CX6CeYJBl4Ymos1nnzaaQZR7zPKrkHU06SaRA+u5CKewtJKjUKkc73GhZS9zg0f9Njhr13+0+NaCcQWLlzrGxc+T7yc6FhJDearzfm4ZLvcV82ANiHUaIqOCN+3iNBdH+XO7ufhTbb2itJjBK9s8ayNuQ//3V41905s69cyA/Xsoh5EM3PqIAT9YTZWmeSXO5wG3Gk25trrGLSuu6xdAyGCxPzCs4JiRgxsgFQm1MSTjBhkp
 RZYF7aOX
 6yW71Yob63rISn3gVnCj4fuEcFM7gZLDCw2QabSVcTMVwpM5alG5Lla49K+wpSaIUC/KyghvffkrHZ7/Bjlgp0K/6nXGnTAvemKvXryiKiVmKFiC2+A+unXr0FDwbuSFiotCAQTXC4KyfQXe5RaEQ7MmyzVg3wK06ja5722bN//dNTjfWFVlOxWIMwHwNvELj8mmkLbywluZkMiA5Er1UOdD6h6pVUpBIYiuzSELjzV1NfnKkMhJu3HBpRegX6aG1RqH0ta9YiKPlljUea2JG6KBKVa4fCIN4XuS5ZIrv4+6Je8OCWT7+3UarahcGRUTy+tPUswFFJHxTfYvycji9I2Sf8tyO9dsSdeeXsd9DqMF8cmvzEbi0xtvzSXeQP6gEhuiWoym0+o5mMbm010R3rCYegvMbIRkLeDAYeOpLU3hdgTUgOdKpXPpxKTi2zCfDbG5Pd2KMVGQwwnzP+7zO9bkgA6WCFac2sCKPZKbJ74y76vToz6j/BinIGomo2d4Y52KBnGum8SUWjSaLS4GPPLkebvQJuGGtCtMwfQz+5HXdItGLx5lEdVSHDECrYMsGXX8SV88T8w2WZ9lwcHJH3ZE+7be8yfzfsvLtAxJXEFSajkwK5Cy9Ec/RnK2QrNvhlqM8qgxGFXcpBOPP8xcoO+2cPfTOlMRUXe49siz6eSk8zM8hCcLoUV5nnyClekzX7TpD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Patch series "make VM_SOFTDIRTY a sticky VMA flag", v2.

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.

Now we have the concept of making VMA flags 'sticky', that is that they
both don't prevent merge and, importantly, are propagated to merged VMAs,
this seems a sensible alternative to the existing special-casing of
VM_SOFTDIRTY.

We additionally add a self-test that demonstrates that this logic behaves
as expected.

This patch (of 2):

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.

This is because currently we simply ignore VM_SOFTDIRTY for the purposes
of merge, so one VMA may possess the flag and another not, and whichever
happens to be the target VMA will be the one upon which the merge is
performed which may or may not have VM_SOFTDIRTY set.

Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
which solves this issue.

Additionally update VMA userland tests to propagate changes.

[akpm@linux-foundation.org: update comments, per Lorenzo]
  Link: https://lkml.kernel.org/r/0019e0b8-ee1e-4359-b5ee-94225cbe5588@lucifer.local
Link: https://lkml.kernel.org/r/cover.1763399675.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Andrey Vagin <avagin@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 6707915e030a3258868355f989b80140c1a45bbe)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
---
 include/linux/mm.h               | 15 +++++++--------
 tools/testing/vma/vma_internal.h | 18 ++++++------------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2bad4bf67d0f..a68bced816fe 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -515,28 +515,27 @@ extern unsigned int kobjsize(const void *objp);
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
+ *
  * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
  *                  mapped page tables may contain metadata not described by the
  *                  VMA and thus any merged VMA may also contain this metadata,
  *                  and thus we must make this flag sticky.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
  *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
  *                'sticky'. If any sticky flags exist in either VMA, we simply
  *                set all of them on the merged VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 6ee803873e00..bff75a4c3c8c 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -122,28 +122,22 @@ extern unsigned long dac_mmap_min_addr;
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
- * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
- *                  mapped page tables may contain metadata not described by the
- *                  VMA and thus any merged VMA may also contain this metadata,
- *                  and thus we must make this flag sticky.
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
  *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
  *                'sticky'. If any sticky flags exist in either VMA, we simply
  *                set all of them on the merged VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
-- 
2.53.0


