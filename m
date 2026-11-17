Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8AC606A334
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=BEJ1Gyie
Received: by kanga.kvack.org (Postfix)
	id A1FB16B05B1; Tue, 17 Nov 2026 07:17:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D00A6B05CB; Tue, 17 Nov 2026 07:17:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90DBE6B05CC; Tue, 17 Nov 2026 07:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6293D6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:17:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E401BA7F24
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:17:25 +0000 (UTC)
X-FDA: 85444511250.11.15676E8
Received: from out203-205-221-191.mail.qq.com (out203-205-221-191.mail.qq.com [203.205.221.191])
	by imf19.hostedemail.com (Postfix) with ESMTP id EC0FB1A0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:17:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=BEJ1Gyie;
	spf=pass (imf19.hostedemail.com: domain of 1045704958@qq.com designates 203.205.221.191 as permitted sender) smtp.mailfrom=1045704958@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AXXxMPEgt9eEKJpgwYhNgOqc1sWnNe7LivV80ncHudk=;
	b=ogEOT1WHGciIkM6TbJOGOL1N0hSy7tb1G3SRj2qGcSnokBFLIpJmLiKldbuQlzxEjXMWph
	IgkKAw5/yb3N8eSyn8CIGHzgQqoP7CrEJKMg3g3Xchc5YFyLJgwXGJLyqX1e8e5NS1/ct/
	alabpRP7lNHJnxebt5UQBbY7e1MUP4g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917844;
	b=ZGTGHs75mS82ZqTUqSoETyF00jM2/FcixhVztLGBAlymlqVbvss7tMmLA3xTZTgK14T+JR
	+Yd3WxO5UaSuVqTdA8/AL+oQzKHs/Gz7twsEnaMHJMg2EUdbrN43eiRAesZU34qYraR/Zr
	4EIuS4AXqU2mzppXUhhIg3S2dImRd90=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=BEJ1Gyie;
	spf=pass (imf19.hostedemail.com: domain of 1045704958@qq.com designates 203.205.221.191 as permitted sender) smtp.mailfrom=1045704958@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794917839; bh=AXXxMPEgt9eEKJpgwYhNgOqc1sWnNe7LivV80ncHudk=;
	h=From:To:Cc:Subject:Date;
	b=BEJ1Gyieg1w+Ffqka4yDC1j4x+ap2Fe7avg0rYAIIEGN3ZdM/xAXjm2WDNXiukfwt
	 iqdhdaG9ywvkL5FAQWd2VlniDn/VH1iNAWpmQYQdE1WprQhik2RmetyrDsCw+dOUd2
	 R9X28WQ/gPi2ghHHuruW7rUkJXD991p7DEtAxNg0=
Received: from DESKTOP-6LNKCJL.localdomain ([114.245.39.251])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 44B0D697; Tue, 17 Nov 2026 20:17:11 +0800
X-QQ-mid: xmsmtpt1794917831tpiumovc5
Message-ID: <tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com>
X-QQ-XMAILINFO: NnYhxYSyuBnLvq4fxmrGrK5xu0mwsez5ZuhTDd2o4ZBNgLhhOOzPQ5wyJ55GxV
	 A8vIc3TP23UGZcbrhJTNUNir9aPWa5PDRCyqycClygB3gvob2AObLneoeSYaTdTNhOKMTl+8Yn0y
	 4JWrmJvMIt/JashDPWeHRJ9fwNh78wJqCqB4thDn2Dh4302Fv7EDGe6BFk9QBv637p5fl3UA+i9+
	 NS2EtaovVYmJi2MwYnXQJMJeM7mpFSXwsQe9/ZKddA7jyqtl2vCio0cRQouos7BLQ7ErcldPzNdh
	 +6UI+WFMVjrfWiv0DlP5YuqyBqa7Iu2BkjKoCQx3JVAWd0kIz02ceovlxu/Gy++kt3CmWxqHqCc5
	 wglQYM2R+zFpyQ12NYh5xqu5uqeypWku/+zSfSpIzv24L6mIH0rCYwqhtwYfUOz4BRppoLdQT5iN
	 jcHqvf4rGDyKsyOLxzgOjAxliXv58+yoF6W14KMbGXWTCeHP2n7e15FHm15MttiIlhDzVnYRxs3w
	 GO4bNtI0ev/jtKqPr2kkzu2HY+lOi03P0Tns9IKAUc96iB0Q3P5dpHEXqXp7QG7nMMOJErUECUUw
	 +4d0UeF3YG9/JLfGzZaYGhc4woSoc3rDYxw+tPObJsBPjuWRcIzW/r2DXOYXjKvrt7Qz0lE7PpcA
	 ivTs9nRruDDq9vyqXpsOoTg7yzxpo2S353+WM3PdsPsf2dkeqZJbhzZa1X/oBFzPgIDRS4NCwmd5
	 U1rWGkjPFaBY4gelj6Y1DltOWxOYn+OtzPVkOY+fxV9AYVXu/BqrEOSnQfxq6FeLCIVYa+NBghke
	 x6V7MfenCXbvvEERXFntMPHdGYy4i8IRk9L+n+bOkWx5rdi2NTQmTPaEBUjHgLuS85ppzrS1x76I
	 UZynA/2FONdyKSLmOjMHrDH0w7HdDbNHpG7+Mgj0GXfXyQKf1MsJdbCX6GQlPx2ZQgyMKRvyaEel
	 qfh8f1keNjLG3R0ufduobkf9M8jBjOMiVk/Js89mhexr1/Lu47+ZQSzIjCKcKgln/kVF0Ve3DrAG
	 SYoWZSox0WBLypJHlbXBKNruCPncvXAIi5FdgsYWg+3jujI4DOsl3UodFZ5twQZUhSa621x0sGPj
	 f68vQpo2h8hd72LSoJXwcEY6V0MQ==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Jingyi Sun <1045704958@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>
Cc: Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] mm: uffd-wp marker on a DAX file mapping: SIGBUS on write, endless refaults on read
Date: Tue, 17 Nov 2026 20:17:11 +0800
X-OQ-MSGID: <20261117121711.1088-1-1045704958@qq.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 49sjadsi3zf6x5wtkhzgeaqechh1rba7
X-Rspam-User: 
X-Rspamd-Queue-Id: EC0FB1A0003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794917842-208342
X-HE-Meta: U2FsdGVkX1/zAnRteMQzXu8d/dnZI3liBNN7Y49IiZV4UTjnXVs5X5AfjxApnh79NWAQjQNb67KL/6f5JIjdddjOoJeETIjSG67XDAvMb5olJt3suO+ONqa496cr2FHrRENrHFqen3Ev+STvg/yBQTiY45xCU0SbEjq1bUy/RMmhznDgDyGDbUaaqO628Apdh+XggNzKaRDWb23xBXI48eqbYavM/NRyj+1xLZ841gTH0CMfQsizwZivyAo5e8x3JdY/hl0Y/nr1J+utu7/zfagMbi64hTR/Jyo6TKn09zNuhsS15TNsMBzTD18lF2+ZlbgIFURCS12gVK91XuBAiXZhl4flXma5H2VuzsNBbsdECGNb71LFJtsP9BA2PX9ccphrlq3CyqfJD9LsTFbTIggKF14zbviSaaW/2fBTA7YoiBXCZEbcKkHhOHV4Gmy0J3LVy+JdDvW/oInvDFDcv2sA7MNtqhag1W+kMHdc2Qhu8R1s7lmPnUkDfTrQvRo/BH2PjyAJ+6zsQD5Oxfwhl3frS4rvtiSMVxfFk4nAV+RMXOahrYZQkAGwH0dnRWB1TR2muA+GideLjhYIO4ebPYLQ3mX+BoD724Ztcru0hYPe7febh0ods0PfRGXAbo9MU91dApyPyGZOrdWjC8fVoaz2TtJCw+SWt8Vm1KMJGTJsZoU2UwlQOvbyAdaeQXr3XzG80ztIcVkMlLnKKQElm3YbB9i2HeZrjs8AgpXqSLK2Bn3v/m2lm1QrQWeAeauThusFCA34CrIunuKQouNPQroDoxdVtR6GSBvGs2RV2gHDHscbKWg4x6vI9trhJMYpnxNbeb2QmL88F8MA4STgNU/zBQXa/ObWMm2Q1VQjuVSiZhMV67b+NJtmDbcU9Bm4WEj3HiQUjQhS8T+QMRsiSzXcv1+dxTLdHjWUrGe2hpQAKcv3A5lvVTpS7ZMXZ0APmE572RjuweUcqSW8lQd
 T4nGeAz4
 ET4Tumhvj6kqLOz18EgC3DVB7s9etOXNNM2zdJwGpcWrrBjAEkGYsSu5eIdwKeftoSlBvFjIFAMsfo6MLERwBAhB9WjCjv5L9G+JFxWGRcncvl/LUBoGgbYe6tSUqEzK6OgCMUGajJiBZ6s0/xjBi87lZ76I33LlFPcCiGI4fcTwt8EIHveU9jyR+U+yqQVHNbdRvv3vGqC67tdV8QWU3isKx+kGAS77T8v9/1U0Gr8KuSfPDoh81xLQNSTKTlUkKZIh5T1RiAtDXwZvlHAOEyus81DhHgCOPNw9v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On a DAX-mounted file, a uffd-wp PTE marker installed with
UFFD_FEATURE_WP_ASYNC is treated as an already-mapped page when the
page is later faulted in, which makes writes fail with SIGBUS and
reads refault forever.

Path (v7.3-rc2, unchanged in v7.4-rc3 and mm-unstable):

  handle_pte_marker()
    pte_marker_handle_uffd_wp()
      do_pte_missing()
        ext4_dax_huge_fault() -> dax_iomap_fault() -> dax_fault_iter()
          vmf_insert_page_mkwrite()
            insert_page_into_pte_locked()

insert_page_into_pte_locked() only checks !pte_none(pteval) to decide
that something is already mapped. The uffd-wp marker is non-present
but not none, so:

 - write fault (mkwrite == true): pte_pfn() is called on the marker,
   which does not hold a PFN; the comparison with page_to_pfn(page)
   fails, WARN_ON_ONCE(!is_zero_pfn(...)) fires and -EFAULT is
   returned, so the task gets SIGBUS;
 - read fault (mkwrite == false): -EBUSY is returned, which becomes
   VM_FAULT_NOPAGE, the marker is never replaced and the task refaults
   on the same address forever (about 3.5 million faults in 20s in our
   test). The task stays killable.

vma_can_userfault() allows any memory type when only WP is requested
together with UFFD_FEATURE_WP_ASYNC, so DAX VMAs can get these markers.
Programs using async uffd-wp for dirty tracking (e.g. with
PAGEMAP_SCAN) on DAX files are therefore killed or stuck.

Reproducer (x86_64 in QEMU, v7.3-rc2, memmap=256M!512M as /dev/pmem0,
ext4 mounted with -o dax=always):

 1. create and fsync a file on the DAX mount (some pages written, one
    page left as a hole by ftruncate);
 2. mmap() it MAP_SHARED, PROT_READ|PROT_WRITE, without touching the
    pages;
 3. userfaultfd with UFFD_FEATURE_WP_ASYNC, UFFDIO_REGISTER with
    UFFDIO_REGISTER_MODE_WP over the mapping, then UFFDIO_WRITEPROTECT
    (MODE_WP) over the whole range; /proc/self/pagemap now shows
    uffd-wp=1, present=0 for the pages;
 4. write to a page: WARNING at mm/memory.c:2495 and SIGBUS (3/3 runs,
    both for an allocated block and for the hole);
    read from a page: the task never returns from the fault (3/3).

Controls behave normally on the same kernel: the same steps on DAX
without userfaultfd, and with userfaultfd on shmem instead of DAX.

As an attribution experiment only, treating a non-present PTE as none
in insert_page_into_pte_locked() makes both symptoms go away, but that
drops the write-protect state, so it is not a proposed fix. A proper
fix probably either installs the page while keeping the uffd-wp bit
(pte_mkuffd_wp()) when replacing a uffd-wp marker in the DAX insert
paths, or refuses uffd-wp on DAX VMAs in vma_can_userfault(). The
same !pte_none() pattern exists in insert_pfn() and in the PMD-level
insert path; those were not tested.

A similar present check was proposed in "mm: compare pfns only if the
entry is present when inserting pfns/pages" (RFC, June 2025), which
described the pte_pfn() on a non-present entry as not expected to cause
harm in practice; that hunk is not in mainline. The reproducer above
shows a user-visible effect. Note that returning -EBUSY for a
non-present entry alone would only turn the SIGBUS into the same
endless refault as in the read case.

Link: https://lore.kernel.org/all/20250617154345.2494405-4-david@redhat.com/

The issue was found with a research static analyzer for
cross-architecture dependency bugs (it flags calls to helpers such as
pte_pfn() that are only defined for present entries) and confirmed
with the QEMU reproducer above. I can share the full reproducer
program.

Thanks,
Jingyi Sun


