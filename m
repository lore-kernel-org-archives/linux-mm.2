Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 766FDCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4DB6B00B4; Fri, 22 May 2026 09:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0A06B00B5; Fri, 22 May 2026 09:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33226B00B6; Fri, 22 May 2026 09:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 805586B00B4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:39:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43B374060B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:52 +0000 (UTC)
X-FDA: 84795163824.13.FB30228
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf16.hostedemail.com (Postfix) with ESMTP id 46ADD180003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=U7nJUZJu;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="A Kh48fv";
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pL89n2WuXfQRwVMPDSbpel7fBSoLeuOmeqskv4u0v0=;
	b=xbGaXpJrMcxs62ibIA0sMY6jDjuRoXbgY4ytvtCiuoYqrwSiO8jNLQOvlAHaXNytp/anEr
	0ObwHJAX2irLRKkBWJ7ffzs4IpXqtG0IEN7s5fJkK0IZOgUVV/gCvExOUYVSI4CqslYqkW
	iWKFojSfO8fFmAHi6+vS24+tSntwVmg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=U7nJUZJu;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="A Kh48fv";
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457190; a=rsa-sha256;
	cv=none;
	b=Ihh9PZTwiwId0PcUhPv3Nbd+gfBr7bJyQLC/25hLR5WYjJ1SiltrCVWEIqiRfNKOpVAvKD
	bIX4lrz5TzqmpbtItlKCtsrtakL9xZgqKT+IYExlrSSgtrtvMSnU9gjgtwnYqDL0SA294/
	2u8G6LAptPxpC0jrR9keIRDTeYsIDig=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 18B1A7A00D4;
	Fri, 22 May 2026 09:39:49 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 22 May 2026 09:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779457188; x=1779543588; bh=2pL89n2WuXfQRwVMPDSbpel7fBSoLeuO
	meqskv4u0v0=; b=U7nJUZJuJqz/O7UKPTC9Eap1k93+riBKOHu38cdJAKhMkBNB
	JPPHSvsUMEqjKFFp3qIqolAgLVnxqdk9ikzkNmTqzK4jAFe6vgxBPqs172ALSG0x
	KN9DzoawY0qUTyEn8eWYzszsv6xY0DKn/mpRie1vol0rcIRYV20e47wvegOHUenu
	Rzj9hj8BTGhdADgkxokR66l6LPJauChqvWb9mI3/feJ4oreD43lyLXTvbM933I5c
	SOx7q4nJFq5+zB/Kxlgn7Pf4Ro0LhIPWs6wY48AV4Jtz0TeY1urDLJ4G2ktEBHuM
	vCQ5jXQZ77EXcQV/FfNucvE3AkrhRyFY83UbQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779457188; x=
	1779543588; bh=2pL89n2WuXfQRwVMPDSbpel7fBSoLeuOmeqskv4u0v0=; b=A
	Kh48fvPt9dFZ8psL3NRyYeynfU6SqZUxuuhw9cv9es6NZCSj0hS+vxs/cIMVV1Dn
	CAPfsQ2xkOVWQJnU0EkEt+6aQFPOkLKc2iKNLiNLUVq8F/tPQES3desbglwi4+/s
	IDeKfSh23Bu8kFJjfiHpuGUvUSdtO/6/rO5pErRVRjjt3s422mQRLHu/2+UiiPor
	RW9D8TnBRbqf28y+b1PZc5Lim/trts9a/+OPlX+rfg2RqqZwG7ZWtv0XUZZYxziw
	JedeUceExYVZwYfE6W7NawSvmlGPzcXRPl1M7Rk4kUSjIlehy7c8PT7L9Us28tgl
	Kh7W2NXIWI/2yq1gzek6Q==
X-ME-Sender: <xms:pFwQaqX8rV39GWFRv_TK8In2eCDe2Pw4at-TzbsucMA8FYDz4TUdpg>
    <xme:pFwQanqH3Rmk0zJeG6imOKKtYRTYWF1NWwfIorqB0Vh77dHes9Ew2Len8iPiYbVIB
    -W7SRuyWQ5BLm1-dA2Hj3RX-ZefQGPDbvG18GGUvy5CeESERnexzw>
X-ME-Received: <xmr:pFwQahUgCvKpjfvN_dfrFR8Yl_1KZj9v0nOGEgIOFb7j4t8rlXPp4l-pvMIkuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfgggtgfesthekre
    dtredtjeenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkihhrihhllhes
    shhhuhhtvghmohhvrdhnrghmvgeqnecuggftrfgrthhtvghrnhepteefveejgeffleefff
    egiedtieegiedugeekudehtedvjeetvdegieeikefffeevnecuvehluhhsthgvrhfuihii
    vgepvdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopedviedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvggu
    hhgrthdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehljhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghho
    ohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthht
    ohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:pFwQavDMWEP-aXDNt1-eXaDAWrwF1O143M9cY5atsY65cUpBEZ8NxA>
    <xmx:pFwQatWdf6DJoyV75aXZ9yJhP_UsAYn39lmo7pTTSynqy775FUioMw>
    <xmx:pFwQal8qxJ6c0gIihggJwGPKbml2N8YH_CRml4bL5plV2pW6JCz56g>
    <xmx:pFwQarm873Mmf7G4pExbl1lrDxLAzlhJxxrbd6ocNHim3y_DkFxi5g>
    <xmx:pFwQaqIdnzzaronRpltwq_tOIJWUnK7KAaldxs0MjexPk2DJVGKueZDl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 09:39:48 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	linux-man@vger.kernel.org,
	alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v3 14/16] Documentation/userfaultfd: document RWP working set tracking
Date: Fri, 22 May 2026 14:38:55 +0100
Message-ID: <20260522133857.552279-15-kirill@shutemov.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522133857.552279-1-kirill@shutemov.name>
References: <20260522133857.552279-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46ADD180003
X-Stat-Signature: 3iqzffyo6oz6368curfajic6hyaxww9q
X-HE-Tag: 1779457190-323801
X-HE-Meta: U2FsdGVkX1+ckmAn/6YSlxR6Uidlu+RPtDpQsipRA6aTTsuPy+tkcAugZ+lKRtf5s26iNe/KvYCsNpf6YpfGY4KT0O1OzZWSNFyxGu4ECkppG42+74tGtdH2rF559ilOPjQwxRlIIfgQdI9el14jTiibN1cEiuF/7QT8731oLJaoaXr3nqiT0OGyzGi3GftMQI6ApFokKledgis/e8t3ujGOuMEhox9MTAyrG2MNt1ksO0Spmyp9Xx3aOvJEPAx2cvqpdwd4WX6MgLGM7R02Uw8W27OpZPXcvLADiU7vtcnx0IVoKSMMFCtsXhI8qIsKEPFKI6fkTrvUKZ0qB68+XNjAA5o68qLNsLb0cqp3zGu+v5+YfZQnuAEu/1205Kd3bX5CLKdxy9YH7Zzqd5b08QWvz4tusHivOzJQ95C8109F289dt563CgmQkr/f1ArwHKtS72jHs9ekj7nWoxGQ8JhJf19g9X+4Nntr4cAwljdm0qSHnKot0nfNr+Jlk+7v9Pylsrc4UQGJS2uEs3QkocMIuz77QA9K75SLOn1o0DEswCwx6gTs0BfbK2Wfn6oyIJU7whLHzK4xULkrp2V6RlVPIV/mVgikWubOSph8lkKWtooNUkTzE1hW990Z41FpYo/XIdsNhPzhxdmS/Ej4/nK8TMCS7sY5ERTWHF3o5IIi7xXx0lzWmfHo8854TTDf55JwDrqW23eTB8QXLzo/Td/Q6S0U6xZzgtECpSv3lSOkWRJ/VbC1iUhFsu66QteztTL/xbm68yWn8i7WA2bH7+hLVgRBWlkMuzF8Gs6CaYSFP4j2iKGnitmo97u88Y1TABZ+7wz4gj3Chz6Ec+rRlFVNoRb8f6fvRVLYvzd61u40zi0uQGA9/Yjh4tpcCDZCiSpyQgzf0rUk7ihX5YjsyPJmuOSgGYIieQ4vDjN5sUOfW8sbHXff9F+uFy1sSasJeTZUBtOzO1QIcyuRGnL
 0CAvZtDy
 UU5/TTaJ9A1khtIM1R9Z4h6p5akwxjjWbMOvv1GulVIoK/thvTh9ZE7eFS/fne/ijP5dntGa1cjHxY1uhTHFiaPMHsfHWseLLkUoig49tYUyP2HDfIFYkqD0ljURzVDY+EnERBKwLOo7YlcaEBiDuVGkSkluZH3PB7FMVCoqUncgnb6gikayWoGdJiKTlIsdDG/cWP8nPqWLvVEoOssfQn5WHkEzk7bWmjCBT3tgHlHtjCZlV47jpPTWUWpYpsFGFiPB8On0XTIni+TLFu9M3lcCsEndlSYeU7hKwI2SgQVTQbgMt6nSeimmx7jd+UHitr5/2aEesQ3bz8t7jTtyiNX/mC1JFuhrx6jmOwlsQYAe335s3ajdRnJfZnTnPINQNCkV8GfQMXNZQ8iH2sSX70f8PIYKw/mr5NBJVi1OFh6ZeQnIEBtYbhV4WF5G8yRMWRh/sAu3K5fe/6tZLcrB+H4GjBE0twCGQWOoVq+o64XVn5w0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Add an admin-guide section covering UFFDIO_REGISTER_MODE_RWP:

  - sync and async fault models;
  - UFFDIO_RWPROTECT semantics;
  - UFFD_FEATURE_RWP_ASYNC;
  - UFFDIO_SET_MODE runtime mode flips.

It also covers typical VMM working-set-tracking workflow from detection
loop through sync-mode eviction and back to async.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 Documentation/admin-guide/mm/userfaultfd.rst | 226 ++++++++++++++++++-
 1 file changed, 220 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index 1e533639fd50..cb5d0e0c9fff 100644
--- a/Documentation/admin-guide/mm/userfaultfd.rst
+++ b/Documentation/admin-guide/mm/userfaultfd.rst
@@ -275,16 +275,16 @@ tracking and it can be different in a few ways:
   - Dirty information will not get lost if the pte was zapped due to
     various reasons (e.g. during split of a shmem transparent huge page).
 
-  - Due to a reverted meaning of soft-dirty (page clean when uffd-wp bit
-    set; dirty when uffd-wp bit cleared), it has different semantics on
-    some of the memory operations.  For example: ``MADV_DONTNEED`` on
+  - Due to a reverted meaning of soft-dirty (page clean when the uffd bit
+    is set; dirty when the uffd bit is cleared), it has different semantics
+    on some of the memory operations.  For example: ``MADV_DONTNEED`` on
     anonymous (or ``MADV_REMOVE`` on a file mapping) will be treated as
-    dirtying of memory by dropping uffd-wp bit during the procedure.
+    dirtying of memory by dropping the uffd bit during the procedure.
 
 The user app can collect the "written/dirty" status by looking up the
-uffd-wp bit for the pages being interested in /proc/pagemap.
+uffd bit for the pages being interested in /proc/pagemap.
 
-The page will not be under track of uffd-wp async mode until the page is
+The page will not be under track of userfaultfd-wp async mode until the page is
 explicitly write-protected by ``ioctl(UFFDIO_WRITEPROTECT)`` with the mode
 flag ``UFFDIO_WRITEPROTECT_MODE_WP`` set.  Trying to resolve a page fault
 that was tracked by async mode userfaultfd-wp is invalid.
@@ -307,6 +307,220 @@ transparent to the guest, we want that same address range to act as if it was
 still poisoned, even though it's on a new physical host which ostensibly
 doesn't have a memory error in the exact same spot.
 
+Read-Write Protection
+---------------------
+
+``UFFDIO_REGISTER_MODE_RWP`` enables read-write protection tracking on a
+memory range. It is similar to (but faster than) ``mprotect(PROT_NONE)``
+combined with a signal handler; unlike ``mprotect(PROT_NONE)``, RWP only
+traps accesses to *present* PTEs, so accesses to unpopulated addresses in a
+protected range fall through to the normal missing-page path. It uses the
+PROT_NONE hinting mechanism (same as NUMA balancing) to make pages
+inaccessible while keeping them resident in memory. Works on anonymous,
+shmem, and hugetlbfs memory.
+
+RWP is designed for VM memory managers that need to track the working set
+of guest memory for cold page eviction to tiered or remote storage.
+
+**Setup:**
+
+1. Open a userfaultfd and enable ``UFFD_FEATURE_RWP`` via ``UFFDIO_API``.
+   Optionally request ``UFFD_FEATURE_RWP_ASYNC`` as well — it requires
+   ``UFFD_FEATURE_RWP`` to be set in the same ``UFFDIO_API`` call.
+
+2. Register the guest memory range with ``UFFDIO_REGISTER_MODE_RWP``
+   (and ``UFFDIO_REGISTER_MODE_MISSING`` if evicted pages will need to be
+   fetched back from storage).
+
+**Feature availability:**
+
+RWP is built on top of two kernel primitives: a spare PTE bit owned by
+userfaultfd (``CONFIG_HAVE_ARCH_USERFAULTFD_WP``) and architecture support
+for present-but-inaccessible PTEs (``CONFIG_ARCH_HAS_PTE_PROTNONE``). When both
+are available on a 64-bit kernel, the build selects
+``CONFIG_USERFAULTFD_RWP=y`` and the ``VM_UFFD_RWP`` VMA flag becomes
+available.
+
+``UFFD_FEATURE_RWP`` and ``UFFD_FEATURE_RWP_ASYNC`` are masked out of the
+features returned by ``UFFDIO_API`` when the running kernel or architecture
+cannot support them — for example 32-bit kernels (where ``VM_UFFD_RWP`` is
+unavailable), kernels built without ``CONFIG_USERFAULTFD_RWP``, and
+architectures whose ptes cannot carry the uffd bit at runtime (e.g. riscv
+without the ``SVRSW60T59B`` extension). ``UFFDIO_API`` does not fail;
+unsupported bits are simply absent from ``uffdio_api.features`` on return.
+Callers should inspect the returned ``features`` after ``UFFDIO_API`` and
+fall back to another tracking method when RWP is unavailable.
+
+**Protecting and Unprotecting:**
+
+Use ``UFFDIO_RWPROTECT`` to protect or unprotect a range, mirroring the
+``UFFDIO_WRITEPROTECT`` interface::
+
+    struct uffdio_rwprotect rwp = {
+        .range = { .start = addr, .len = len },
+        .mode = UFFDIO_RWPROTECT_MODE_RWP,  /* protect */
+    };
+    ioctl(uffd, UFFDIO_RWPROTECT, &rwp);
+
+Setting ``UFFDIO_RWPROTECT_MODE_RWP`` sets PROT_NONE on present PTEs in the
+range. Pages stay resident and their physical frames are preserved — only
+access permissions are removed.
+
+Clearing ``UFFDIO_RWPROTECT_MODE_RWP`` restores normal VMA permissions and
+wakes any faulting threads (unless ``UFFDIO_RWPROTECT_MODE_DONTWAKE`` is set).
+
+**Scope of protection:**
+
+RWP protection is a property of *present* PTEs. ``UFFDIO_RWPROTECT`` only
+affects entries that are already populated. Unpopulated addresses within
+the range remain unpopulated; when first accessed they fault through the
+normal missing path (``do_anonymous_page()``, ``do_swap_page()``,
+``finish_fault()``) and the resulting PTE is not RWP-protected. To observe
+the population itself, co-register the range with
+``UFFDIO_REGISTER_MODE_MISSING``.
+
+Protection is preserved across page reclaim: a page swapped out while
+RWP-protected carries the marker on its swap entry, and swap-in restores
+the PROT_NONE state so the first access after swap-in still faults. The
+same applies to pages temporarily replaced by migration entries.
+
+Operations that drop the PTE entirely — ``MADV_DONTNEED`` on anonymous
+memory, hole-punch on shmem, truncation of a file mapping — also drop the
+RWP marker: the next access re-populates the range without protection.
+Unlike WP (which persists via ``PTE_MARKER_UFFD_WP``), there is no
+persistent RWP marker today. The user needs to re-arm the range with
+``UFFDIO_RWPROTECT`` after any operation that explicitly frees PTEs.
+
+**Fault Handling:**
+
+When a protected page is accessed:
+
+- **Sync mode** (default): The faulting thread blocks and a
+  ``UFFD_PAGEFAULT_FLAG_RWP`` message is delivered to the userfaultfd
+  handler. The handler resolves the fault with ``UFFDIO_RWPROTECT``
+  (clearing ``MODE_RWP``), which restores the PTE permissions and wakes
+  the faulting thread.
+
+- **Async mode** (``UFFD_FEATURE_RWP_ASYNC``): The kernel automatically
+  restores PTE permissions and the thread continues without blocking. No
+  message is delivered to the handler.
+
+**Runtime Mode Switching:**
+
+``UFFDIO_SET_MODE`` toggles ``UFFD_FEATURE_RWP_ASYNC`` at runtime, allowing
+the VMM to switch between lightweight async detection and safe sync
+eviction without re-registering. The toggle takes ``mmap_write_lock()`` to
+ensure all in-flight faults complete before the mode change takes effect.
+
+**Cold Page Detection with PAGEMAP_SCAN:**
+
+RWP-protected PTEs carry the uffd PTE bit; the fault-resolution path
+clears it. ``PAGEMAP_SCAN`` reports ``PAGE_IS_ACCESSED`` once the bit is
+clear on a ``VM_UFFD_RWP`` VMA, so inverting it efficiently reports the
+still-protected (cold) pages::
+
+    struct pm_scan_arg arg = {
+        .size = sizeof(arg),
+        .start = guest_mem_start,
+        .end = guest_mem_end,
+        .vec = (uint64_t)regions,
+        .vec_len = regions_len,
+        .category_mask = PAGE_IS_ACCESSED,
+        .category_inverted = PAGE_IS_ACCESSED,
+        .return_mask = PAGE_IS_ACCESSED,
+    };
+    long n = ioctl(pagemap_fd, PAGEMAP_SCAN, &arg);
+
+The returned ``page_region`` array contains contiguous cold ranges that can
+then be evicted.
+
+**Cleanup:**
+
+When the userfaultfd is closed or the range is unregistered, all PROT_NONE
+PTEs are automatically restored to their normal VMA permissions. This
+prevents pages from becoming permanently inaccessible.
+
+**VMM Working Set Tracking Workflow:**
+
+A typical VMM lifecycle for cold page eviction to tiered storage. Two
+mappings of the same shmem (or hugetlbfs) file are used: ``guest_mem`` is
+the RWP-registered mapping that vCPUs access through, and ``io_mem`` is a
+private mapping for VMM-side I/O. Reading ``io_mem`` does not go through
+the RWP-protected PTEs of ``guest_mem``, so the VMM's own ``pwrite()``
+never traps on its own ::
+
+    /* One-time setup */
+    fd = memfd_create("guest", MFD_CLOEXEC);
+    ftruncate(fd, guest_size);
+    guest_mem = mmap(NULL, guest_size, PROT_READ | PROT_WRITE,
+                     MAP_SHARED, fd, 0);  /* vCPU view, RWP-registered */
+    io_mem    = mmap(NULL, guest_size, PROT_READ | PROT_WRITE,
+                     MAP_SHARED, fd, 0);  /* VMM I/O view, unprotected */
+
+    uffd = userfaultfd(O_CLOEXEC | O_NONBLOCK);
+    ioctl(uffd, UFFDIO_API, &(struct uffdio_api){
+        .api = UFFD_API,
+        .features = UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+    });
+    ioctl(uffd, UFFDIO_REGISTER, &(struct uffdio_register){
+        .range = { guest_mem, guest_size },
+        .mode = UFFDIO_REGISTER_MODE_RWP |
+                UFFDIO_REGISTER_MODE_MISSING,
+    });
+
+    /* Tracking loop */
+    while (vm_running) {
+        /* 1. Detection phase (async — no vCPU stalls) */
+        ioctl(uffd, UFFDIO_RWPROTECT, &(struct uffdio_rwprotect){
+            .range = full_range,
+            .mode = UFFDIO_RWPROTECT_MODE_RWP });
+        sleep(tracking_interval);
+
+        /* 2. Find cold pages (uffd bit still set) */
+        ioctl(pagemap_fd, PAGEMAP_SCAN, &(struct pm_scan_arg){
+            .category_mask = PAGE_IS_ACCESSED,
+            .category_inverted = PAGE_IS_ACCESSED,
+            .return_mask = PAGE_IS_ACCESSED,
+            ...
+        });
+
+        /* 3. Switch to sync for safe eviction */
+        ioctl(uffd, UFFDIO_SET_MODE,
+              &(struct uffdio_set_mode){
+                  .disable = UFFD_FEATURE_RWP_ASYNC });
+
+        /* 4. Evict cold pages (vCPU faults block on guest_mem) */
+        for each cold range:
+            /* Read from io_mem -- bypasses RWP, no fault. */
+            pwrite(storage_fd, io_mem + cold_offset, len, offset);
+            /* Drop the page from the shared file. */
+            fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+                      cold_offset, len);
+            /*
+             * Wake any vCPU blocked on the RWP fault for this range:
+             * fallocate() does not iterate ctx->fault_pending_wqh.
+             */
+            ioctl(uffd, UFFDIO_WAKE, &(struct uffdio_range){
+                .start = (uintptr_t)guest_mem + cold_offset,
+                .len = len });
+
+        /* 5. Resume async tracking */
+        ioctl(uffd, UFFDIO_SET_MODE,
+              &(struct uffdio_set_mode){
+                  .enable = UFFD_FEATURE_RWP_ASYNC });
+    }
+
+During step 4, a vCPU that accesses ``guest_mem + cold_offset`` blocks
+with a ``UFFD_PAGEFAULT_FLAG_RWP`` fault while the eviction is in
+progress. After ``fallocate()`` punches the page out and ``UFFDIO_WAKE``
+fires, the vCPU retries the access, faults as ``MISSING``, and the
+handler resolves it with ``UFFDIO_COPY`` from storage.
+
+This workflow targets shmem and hugetlbfs (both support a private
+``io_mem`` mapping over the same fd). Anonymous-memory backings need a
+different inner-loop strategy because the VMM has no way to read the
+page without going through the RWP-protected mapping.
+
 QEMU/KVM
 ========
 
-- 
2.51.2


