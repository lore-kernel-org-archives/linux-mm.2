Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9496C606AB45
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xf3BTFbN
Received: by kanga.kvack.org (Postfix)
	id 7EE976B05F8; Mon, 16 Nov 2026 06:13:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6006B05F9; Mon, 16 Nov 2026 06:13:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5D16B061C; Mon, 16 Nov 2026 06:13:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 403B06B05F8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:13:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDE208092C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:13:10 +0000 (UTC)
X-FDA: 85440720540.19.B859FF5
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 01DFB40010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:13:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xf3BTFbN;
	spf=pass (imf27.hostedemail.com: domain of danjwade95@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=danjwade95@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827589;
	b=CesiS/2bQ5vYewrSv3xlpVpdKCDmJUIppcHbPW3D5b+NZpzJd88yKMF119euBxwJ+Talla
	HtZkDZLmLNUaOu3g0hhCLffEvBR6D+sSGlxPzo/2wRJ6FcTE5akcVWKyALx1qhlodc4VJ8
	TehL6oTK+QZmWk7JcCZ0Y52hdHu910k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xf3BTFbN;
	spf=pass (imf27.hostedemail.com: domain of danjwade95@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=danjwade95@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rROGYk1aEiWG91xI09CLyS+cm7Q+TGC8+ehzSxVtxO4=;
	b=K12wEj/K/buDJQI6hzeFAD5WrTRgQax6DqnszXGyGa4Qdgo5ZLZJ1mbnYTsNt8yBJ88heA
	VmoZ4boaglKtqXE9qhS3MnSJMxutixxaSC3CkCPNDPQHAyXMsFS/HrF82EAsa/zbndUJfC
	NB7pbuVpt9cPLlu9Oo2qAK4YmlqI2z0=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b1535be329so2443584a91.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827588; x=1795432388; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rROGYk1aEiWG91xI09CLyS+cm7Q+TGC8+ehzSxVtxO4=;
        b=xf3BTFbNdMiNQlg46wbc5bAvSgRyWxuCZ+c2kVEoYnZbScMwDzRSRC7OheMjzx4VQM
         Y/BvGdNbwLhF2yGb6CKLPKYOkuV3YRb8wWiicZiUoopA2yKB+PTsHdwC7KOOPF102PyC
         3D3fCQE/M3QuxAl/iKELU1YTk80rQBFk7jue7n8oFT8xRHq2LpL3vJuUE0Xy+dfSMk3Q
         T9Syph9epuMHSrGwrgXGdOIm+6vRgZ2lchqg6zKhITFAa6A/ElZ3KxUMmAubRwja0t05
         VThLSivA3dz8nQuqVbfNEqTTQo+s/Z7Vm/cY+tDDXaQwe1bcxaJbw4YT7YRrR2nWxRaF
         GNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827588; x=1795432388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rROGYk1aEiWG91xI09CLyS+cm7Q+TGC8+ehzSxVtxO4=;
        b=Ez6Fc9cepxh761EBV1iXHc6jZPn+jjhDoxSHTGyb/T8amaxVhYIUc5+hl9LJ5C+4sC
         iKiGWizVKOLi4aMLJ1AHApRFF99GApD0uAIB9PERiR7koStwymz4X5vy22hT6hUFATPj
         HK//RrFQrK0nKgxVYJvJQb/bQAMXQRaju/XW/JEIsDxtb+7mPDuw1ZwaGI3qQVWnshs0
         pT/wZTIbMbtFWS5qN+tN4DK1w0MFC5Z1QDW6uSSsGtZQ/tDTvhKT4iB7DqxUx6kGKvuR
         FA6iuaf+ean8jJ788BS5lYLad686JfJy5Z6jmL4cXuwWDAZ1X6QbtQKO0KKn9XOPtktT
         2ZwA==
X-Forwarded-Encrypted: i=1; AL+hErGnJujQw99kX+CvfKRrK1w2Cv8s63NKz/zlZxmP2NKQTcDeT19SNi68rlNTqsCVOUCApFVsvjMy7A==@kvack.org
X-Gm-Message-State: APuU4Z889/hfFR+PEJjBNW+hzMridOzDWo5G7ffPiAkjrM7iRLIcMDhk
	7WCkrDqqIuwktQIDfPjPmkq16xm52w1ovyPCzcRQAsTDFEIznyfW4Y/o
X-Gm-Gg: AZFdTZdOJ0UmQy/uJoK8nh29SktNm4yNALxfveULbz61JFQJneRYYBWuSbIzRm5ktn3
	K0mkvKvg12XdDvY+K6suj4EKXqMdywk1TKxXVPUCd8oCabE5ovvYpo8f5LpwSR0iXq3SIhKF+Bu
	mr+Q7t6uXyVthyZUN+LB3sZQt0csBlGaF5JYcwKX+g1G5QfltoscgpzikunO2QnYZdre9tzYWsg
	ZIkWAN+dcKFPRWMUCFSsingUS30ct1bjAFBxlsqs/Y9HFmDOizHVNqCEEfPvA2Q0WGyAedhIlGD
	9ikSjLGPbEDSEfpOmVLFjA3Rs2uwIoRwttSF7AjofCAF22OkhBtLJYdDe4N++Dy4/7OU3WfVO4H
	1Tse484IpXJ4z6ky9Kn5zp6Wx7PSWTg9WRoDPrLkJYFxTexvB/3WXY3VqN9m76R3Ai84lUEOMzJ
	R+MhaksuqDkhefrHWKBES0VHcVCGhx7BT/3MquJ5jzKmCyr3ru5qVzQQISuT1waYWX0nvkOpTvw
	WDXU3BUbq11KSOsxdcgV7tvkHqj51TVur/14WkhhvEq8MCzTAYAK2jl2yVcRM/BDSseE6ogK9Y0
	Ii76P00M9GVOEohAxankqumzIYyewLegTcEBzpeBGXVa7/UIlpn4/SOuzFwXsKddoXmG8SejXhF
	uY/vbGeYWvgjHSDDjJ8eR1sLtovwrFDjaoyGCym91Kam2nEXCCWK5eD541ELzMMyvzTc+1DdfE5
	zMLLP4M1K6vU6DUliwh4S5tHmHQRwUQwREwg9fvT4jmGHh2FefD7wnjelI/dYNUvZUZBvBroqeJ
	n2sYP3FQF1QmWxFMF4o56s2VVXcxP9qrjCSXMz85d8HPpDFsSpI1AacqU+XRGDsPg==
X-Received: by 2002:a17:90b:37d0:b0:3ad:b8c8:4a84 with SMTP id 98e67ed59e1d1-3b1b0a0d978mr10900837a91.26.1794827587617;
        Mon, 16 Nov 2026 03:13:07 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d0f497sm21525599a91.8.2026.11.16.03.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:13:07 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memory: mark unshare copies dirty to fix MADV_FREE data loss
Date: Mon, 16 Nov 2026 21:42:45 +1030
Message-Id: <20261116111245.28871-1-danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nshu7cjfn1pyhf9gbrtzucqndi4p9ywj
X-Rspamd-Queue-Id: 01DFB40010
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794827588-255648
X-HE-Meta: U2FsdGVkX1+3LaIkNX2pBZTKIF2Q4tvT3h3eXmzDNU9ObAa2Ij6vhv1Lp9HyOkCTodJoOLyFG0TOLH5DdlqhHH1vS3v07iKcBT/41/pG8vCguU6oUQBExlIHtOioLeBE1rwcCIG4U+qdwidio3uY2ntSzwD70LTvrA5x7r1lY5lCZyJineU2VLonQEu05cGPxVZej6uP8f4QSqAIKFjYIuAa+iGFfQPOgY0h8C2E/g/hbpiGBHnLmTo4KhgiB18wAGiU/rLhCe9l/N7awticNZNiGPDzWuDUbLlIubcPxY501i8wXULqwPApNDXlrIbY0Key42MHwIzlnuxGAue4VYNfecJXZ9lNKI3G69PVA4k28WpmrK7HcrGHOVzlhkg0pEK6JQqn7+v0VyAFdN5kR4LLtXwiXkc2zY1llZoxkPEiz6jqWdrSQxNIx4mKYkM/B3Df7V+XoKmLoNv3VVLw1tuUWH3C0RSBP59KEBlhkh2rNi2TG4dgPb8lPuxihaO/fXDmoQShAlhmop8MNGl8txCW/pfquaf1Y8BFueXT/87iH9PUdFvXa1uY4je6RcYHeaTVWTulzr+iqP2C7SyRWIGmfOOiE12eK+Y4LBtoxnJDZu3RP3noakVlL2fbbAu9buyjSK05Yf7FNJIEHAh+h7capi/6Ksqm3z3ovaXOJ9f/hHOgzzbmPDBlBP2a99ZEL48GvmmWCAr76cmyEsI13Gw/XRb7do0TIZbrZJge75zDFHHKq6GsMyAuNhtEvpP4zoiKIW+Hput0SQnvgYzyPLD+dwxexRM3aw5Z/BMgi2hLcdfV5645FTxWyXYOGPw0O/RD+lTR7bFELNoEt2+FO59q5imY9yh47myl4VlfK5Q/sJ2VBIWmjDjLXRP9wm0lvKC5lU5GX2RTmdRhxcsTTfxVFYQuYqXaqdTMJL6IbBAdxs6zyQeez2TGJufcI4+UfILqP5vHjE2cGGHxuRE
 QIiLWdVh
 j8p4KW3YXDb5lagUaKM82e6z9YmDh4VBsi/vf5FYKtbL3YKXe01X/Sk/h598VSkaPPLaNBkv6KTtNSYQGY6hAIMnMmJgqzYjjmJzMjyiZtSh0vCjM5NLlSVor+FV1w84h0FCvLK2M2p+rMzVTcO3e2Ld4WMoUig4DVIELRM2aUPpowOSBLf3aGM3vo140e36jNDh9xbprbO5RrP34Z+vT376wZmCaMSWnyXH03iFGh8N020PmgaQqBp6hRn8rgmihX+3TDWzImx+zzSogxRj4DcCgFQn48/X95nnwvg6+ITkVk5bewHIAjGjeCqAeO5lKzcYQ/dFDElTVovlRB0Lw9lG5NZ4WkDmit56TtM08KWuxLE8FXNYXMVrsjkejZ+Zi7j4WXAHEMP8qaDzu7yaBmQAk7wJRFCGXjszE0Tj8lpfMOzzqip70EuT4IE/QMoXoNFxRk1pIDUzS6Hl+Hbq6rFQ0WSmhYbV9qWKsW6LMmvpJ1qY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_FREE in one process can make reclaim free an anonymous page that
another process still maps and never gave up, which then reads zeroes.
It happens with a page copied by an unshare fault and shared by a later
fork().

MADV_FREE and lazyfree reclaim rely on an unwritten rule: an anonymous
folio whose content a mapping still needs has a dirty PTE in that
mapping, PG_dirty set, or a swap cache entry. madvise_free_pte_range()
only checks for other mappers on a folio that is already dirty or in the
swap cache. Any other folio it covers is marked lazyfree once the
caller's PTEs are clean, even when other processes map it, and
try_to_unmap_one() then drops those clean PTEs and frees the folio.

The copy wp_page_copy() makes for FAULT_FLAG_UNSHARE breaks the rule:
pte_mkdirty() is applied only for write faults, so the copy has a clean
PTE, no PG_dirty and no swap cache entry. Unshare faults come from R/O
pins on non-exclusive anonymous pages, for example process_vm_readv() on
a page shared with a child, or KSM unmerging one. If the process forks
after the pin is gone, MADV_FREE in either process frees the page under
the other.

Mark the copy dirty with folio_set_dirty(), as ksm_might_need_to_copy()
does for its copy. pte_mkdirty() is not suitable: on x86 it also sets the
soft-dirty bit, which this path carries over from the old PTE.

Side effect: smaps and numa_maps now count an unshare copy as
Private_Dirty or Shared_Dirty rather than _Clean. The PTE is unchanged.

Fixes: c89357e27f20 ("mm: support GUP-triggered unsharing of anonymous pages")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
Tested on mainline b3dfbde62cf1; mm/memory.c and mm/madvise.c are identical
in v7.4-rc3. x86-64, KASAN and PROVE_LOCKING, 2 vCPUs under KVM, no swap,
as uid 65534, with only this patch applied.

The test gives an unshare copy to a child, has the parent MADV_FREE it and
a control page it alone maps, then waits for reclaim.
- without: "test page in the child (unshare copy): present 0, 4096 of 4096
  bytes wrong"; an ordinary shared page freed the same way stays intact.
- with: the child's page is intact, the control page still discarded.
Same two results on v6.12.117, there with folio_set_dirty() placed earlier
in the same function. No KASAN or lockdep report in any run.

Two other ways to reach the same state are known and unchanged here:
khugepaged collapse to a sub-PMD folio in a non-writable VMA (covered by
"mm/khugepaged: mark a collapsed mTHP dirty"), and a swap-cache-skipping
read fault in the stable trees that still skip it. Checking for other
mappers in madvise_free_pte_range() covers all three and passed the same
tests, but changes MADV_FREE for every shared clean page.

 mm/memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index ec3d9d99ccee..49f6dc92c020 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4130,6 +4130,14 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		entry = folio_mk_pte(new_folio, vma->vm_page_prot);
 		entry = pte_sw_mkyoung(entry);
 		if (unlikely(unshare)) {
+			/*
+			 * The PTE stays clean, and pte_mkdirty() would also
+			 * set soft-dirty, which is carried over below. Mark
+			 * the folio dirty instead: MADV_FREE and lazyfree
+			 * reclaim may drop a clean anon folio that has no
+			 * swap entry, even one others still map.
+			 */
+			folio_set_dirty(new_folio);
 			if (pte_soft_dirty(vmf->orig_pte))
 				entry = pte_mksoft_dirty(entry);
 			if (pte_uffd(vmf->orig_pte)) {

