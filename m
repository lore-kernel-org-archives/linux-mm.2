Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16DF6082BD5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=AeMnsfH/;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=MJbHSkdK
Received: by kanga.kvack.org (Postfix)
	id DEAEE6B05B9; Thu,  5 Nov 2026 07:03:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1DD6B05BC; Thu,  5 Nov 2026 07:03:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8296B05BD; Thu,  5 Nov 2026 07:03:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAE166B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:03:29 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DF871C4357
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:03:29 +0000 (UTC)
X-FDA: 85400930538.17.FB0F46A
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3BE421C000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:03:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="AeMnsfH/";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=MJbHSkdK;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SnGqaF1m3+TcUoIUe8s1ktdd86fUI1Q/MOw+vA4nSY4=;
	b=Huz815WQTEryPgaSnr7RT9yEfZVOButC6je0eWIm28KKoznruF4PvPwSsqLQz33NmOqiiO
	AE4+UJM2B4UtW05FhptwQWvdomTELr/8cLnv/DIQke3vQ6N8vOm6+hNCNR+nKLFFbZMMkP
	rDlEcWE+nfSmixFS61SUN+NBjjG2yY8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880207;
	b=CR7MsIVjNDNRKR01kR1bOCIDeYtk1zStJzB1JVRahNIt1ix3gzdslEvRlcSDI/ZNk7cCbH
	W26NofpgayIEjjBzFdV23COUvXTmaog3WtUNjpLCFx5E/bVQ3SKRTAnqUQL1LbQxamknh3
	HDN1zqPFvUSVCQNBVN0dg0gO/1O6of0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="AeMnsfH/";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=MJbHSkdK;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 90E8CEC0611
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:03:26 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Thu, 05 Nov 2026 07:03:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1793880206; x=1793966606; bh=SnGqaF1m3+
	TcUoIUe8s1ktdd86fUI1Q/MOw+vA4nSY4=; b=AeMnsfH/5BMoyHL+Y4AAW0mnbZ
	Rt07AvuF+GG023uKzgW0I52pMsB2NrK2gn6ke8YrUWeXgDXKh54l2A1x68YQ58eZ
	uIegmwk5EFiaNyUu7q4A06WBeYVD07ZizdsPb6R/VuZBl/y7DDq8JBIQhtyxohi7
	9WwZFDUTSm6IQ8N6P+S2bQPymOouZBG4uWqFObHyCzZuqdFfHDnjEIAQ8HOx7+Q6
	9uixf4VOlfX4QWouTlLodngNGNsm06YJZ67MKRQ2P7vB9CBi/TRdk6htn460FL9B
	xz7RoIfS4GyPv0kpFE7hamAAfGg4Vgd9m5QZYub7Hjc0wmcWTbYt8eEFhadQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793880206; x=1793966606; bh=SnGqaF1m3+TcUoIUe8s1ktdd86fUI1Q/MOw
	+vA4nSY4=; b=MJbHSkdKfJRklbEdYDZNJSST9DKPjuhUfbfPB6z4JIiTXwlrA/Y
	nslxVGucnPsuYalga5szB+C5gID0QcRcdEHwJ9GewL5HccgHKWdLl8k/e9v8Xm/D
	tqObLszJv8vU6jO8CnLwT2YSTdl/IgZ1++lH2R4rKlOwbWG76x069+b6ZCTbCkFu
	/0+uyg/SaKdL6tAoLU3lg8Quy7XM0UZAY9Famp0Ijlr9SiSUJaYIDCUYt70I9yXA
	leX6bZyh0/QB6+GW8o9jFVVdUFGRm63e6/A6M10PBiwLrbm8+Haxu0UF36Buj68A
	3laycBGvz/SF90tJwy4XzIxtOVCoy3z3XIg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793880206; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:IY9wWSltLJH68DpMFJiYcyW0cHSRviZABIBq6re/B9ZoqPa
	0BQjgfao76JJl28SJcOALSVBttgLs6SKXCKdN/xM0xHdh/vMCoFDN3y0A9QX2W4e
	kDej/AJhPtwxhYaWLTzJVicDKO13bDCgq6L4/Kk78GxDaHdYpsTEYZ/F7LC8iZTt
	z3FsN03OVJUvBqKvBv5v6LnDdMt5ZecMktqxhMSKxBYtxeKq48Kmd11Tm6VKP7OS
	KXQMUaNYxEoL4NrHphPdneG/hTvnmjAXT7ipN5XiizVIO2i7eVfZFzi/yO+DW4Cj
	PfvTvWclSSK+EmyG5E6uKlKzeyyLE3QT/UWnnsA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:XI+rQWrzB4QmqCdlGOqtcUQo+pDdM93YcH03LgDilhs=:PbeghzKZd5F4FNVd5WY7yMjVzeJL5Zr7Shft7iWg58k=;
X-ME-Sender: <xms:jXDsatgLbPS1GAvpfedVT73RSp_Dq3SRlNteoTClHQt4VMOyak92aw>
    <xme:jXDsavYRRbbztS7PgI8-pXFQQSKQ4OijoPz26sJ2gsw8Otjk_fcfjlPEJibwEOgiN
    sDj8K3K9WMFV8m5HS0GVyhlnfk2o87rNH66g8I8ekJ2NI0efl4SvNw>
X-ME-Received: <xmr:jXDsapGeNWETG8-WnhjvG-W-YvWxKL67iDYalHddbMRR__Ogcl9tqfGHqy8>
X-ME-Proxy-Cause: dmFkZTEG2q+iUQ7hlytx20LnP+Hs1c68SNVEZZBwR+/lDeS96dUa25vm89TwO3Uk7oTvWw
    a+Er0Bz/jzSjyW92/P+/jrFJRS4b/gVCoYwZmiAYNCT0aJA7Hd7wl8p2R03tyw1lzv3FU2
    H0PYH4FQ19BPMrR0uXSpoK0sj0wBGfn3kKPFFhzXlvD2hufDW7PVKFznXwdwbcInpT38UG
    rx8fq+JvcHpvJLajIkA9aqus5DzG95Y76S64A0X4tnIHh66o9j7J0p3SQrmuhU8SuMX8G0
    qkA6P4dLPb8Hx/NoOwbLI4IHHmndPEFhG8Rwv6ThGqKDEyzwU7wruNBA9vc5k0CuNEdEda
    PGu7Osiw6JBmr8UKTjuW/cjHPUX401xWhTxEY2pZPzbq0k4uGQXPXDhH9TlUrNpNzjwaXU
    A71MzzGCOCua4pj4gYbb7NhaL4BI+TzyFau8yTS41RgnexOiO8D6Gu3O6kHLINfmSZT6/H
    cvu9l3tZDeZpHHAo1EZCafmtlTpgFjwxpvgfrJTiI6cGnEc774SfrMnr+0SliqAA+f7bBg
    YS6vrjpkcYQuYtSlBPDOKGiVY1e2325it6igDshZxsvQa1gXbEDt0V2Ltctz1KOzj5OfLn
    E8VzMEbojWGuXfPqAHj1MOXGdLTYsPiFep4dmYBFhPndur05dg18IL3RW40w
X-ME-Proxy: <xmx:jXDsal9MwR0syf-ZWwPHiWHQyqZK9UKL3oeZh8g9M0CL1X0nMVVZWQ>
    <xmx:jXDsamUqG1zB4JIvkK56hBckAEzSvYXLz77xkuJFe0-S_Xfre233mQ>
    <xmx:jXDsapYw5O7usH1mY6tGMxGKYz_Um2zULrlcivzgISWiTMBgOL5jfw>
    <xmx:jXDsajUKpXbiBn0gbURPIQlQr_wNqHe9YM2ykoG5GZ14BpWouRHfrA>
    <xmx:jnDsajlBG3OHGa0_wTaAm1ZM8KH-F76nm8Pp5UrehdjqVBdzF9TXKfeF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 07:03:25 -0500 (EST)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>,
	Rohan McLure <rmclure@linux.ibm.com>,
	Tejun Heo <tj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] x86/mm: Remove the zapped-entry checks
Date: Thu,  5 Nov 2026 12:03:21 +0000
Message-ID: <20261105120322.3319301-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: uyx1gus1p7mnpn3u9dc9jatxpa1d88bk
X-Rspamd-Queue-Id: 3BE421C000B
X-Rspam-User: 
X-HE-Tag: 1793880207-756375
X-HE-Meta: U2FsdGVkX1+yzVntnyBcp1FjVt8H3w2leJ5AjehuEm7Eh8NJyoOY2OzmLRFd++euQrkRNJtJz96+clD8kAQTs1jXXr6Vsv0GTAmLpXRzQPXRrLI/iOUwXQjmOPv4TjllU3ZO4ZlBGQQDl5OO2D3LiiZzgMjOgMnkDlXPr3YiozS52avcwN0wJHJC9kQtFe76dslNULxsFfVALztp/Nrp/hgUSia0Q1rvu79rUgCHLgVILIaaQGre6riRqq/4oyx8etnUcJQZPv3YgTFM72KnxF3ARakTE4zAwaYql2MPuj3up+98v2UmlVTRQUxWacTUhUn8cdnEQ6r7WB3pyPvEBJ+D8uj+tcFEJmdM0ZLiyiKhvtEynpNLuxmkZn67Q7cpb7oGaEXu8GA5Yg51+7CgF9muvFBv6hw0cVmO0bAAKODg97k9S5Ul6a4bY0jyVf0/yrxYnuPil6W9IC8A++kCVdM60n8lS90DKfLjPAORsb8jYxucaFgW5kF+IU3JydrRUBypok/a/3V8nBFIvFW7rQYN9Wzs/v2kz7snfm5vOkyk1Q32LEmvHF0+Z/23embTIL2WAVvcT7I3WfXkZmJ3m7hQ6pMV1GrwYkUk9AXvxe29PuNUihhnga0C77BSdVPW+yHmnbDf/03Qbg8v97IUutXw3qa0hjKhkD3LhxdSyhxU98kXMeLe5dlkNo9MSUE4maZLp2QESOvNNyxyH6S9lksoECnzKclv9L9nXSx1egym16DdCRQ7gO7Tkkr8PuFkE3NVRPAVV/bbW9Bqb74UJuqcBoIctU3vdjXNiG89WhEH8H92kdSC7COodF/ljKrqWHb2WZ5gl3fLdOQIKlI8YdnMtemWJOtdp1DwFYQRUZbLcvrS8iqCQonIIfH3cgVP0cCkCinAv2M9N4glnZZKtAm28Ah5RxUN2b1MirA4P8Y335bWT9eeJxWfILDe3oJ9FEEDtNH8V4rfWVvO2Gm
 DuvaESVM
 bNuo9Th6qg5CoMDJN7TfoA1h9Abyy/BWPK7PYeZWWNs9/3eP4s3TzuauRc8NWz5N0KK0lrtenqLP8p+bmmr28l5QpC2rp1Ias1uXs/U/AscAYgYg9eoPxiYOYQIDRyPd3tIG0Ppi99YSIMype0iCTMY8j36btVh8GiW3mDgDOEGyEkw4jV/i6bNBzPZQPq2gkBaZudjI+f/UZDKW2EPlOYSGDxHTK48FhAk6SAz2J2XXHg6F6M7jdOgDPiOlpYnd/ftqlnJN3Orpbe6Cp5HRnqa9NF/8eyWQrXBhc1U8DrSe5kDbp7Y0m3uoRG3dEHXXvDs52cBOx/2NVDTkkSEQE1D7qC/Gb9jD+mMTQ6bSQu+R+TwsDGbRz/iNjXxzUcrgb5SeM2MFV2fgMB5KdJevx3vxe/+h1nHVvo3DfOaLtGM8Wm5tRQxssfvGDf9ptxIJB61DuAFI+64zqtt/+9ccEy5ddir6z5sNCoY0hzT+kdEKb+w6KZjKmHVM8q538mT4CRFobzPYmaiIduCE8aPOXH0GBd1FpC8n3uwxVbda0sJx057BEf4KwaQX6RwSIM+cMdpRDZ2RUv1uFvBglrFUPD6b4u8NgitP1x5Bqm1m+XT1zDtjoi3/SF5HsvN9/kMHLO8DxnUSsFt7BlbbzP0FeCnCTfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Zapping a range calls arch_check_zapped_pte() for every batch of PTEs,
which is every page for small folios, and arch_check_zapped_pmd() or
arch_check_zapped_pud() for every huge leaf. Only x86 implements them, as
out-of-line functions that warn about a shadow stack entry (Write=0,
Dirty=1) in a VMA without VM_SHADOW_STACK.

The warning is a VM_WARN_ON_ONCE(), so without CONFIG_DEBUG_VM the
functions are empty, but the calls remain. With the SRSO "Safe RET"
mitigation the return of every such call mispredicts.

The x86 helpers already keep such entries out of other VMAs.
pte_wrprotect(), pte_mkdirty(), pte_modify() and their PMD versions go
through SavedDirty, and only pte_mkwrite() and pmd_mkwrite() on a
VM_SHADOW_STACK VMA create the combination.

Remove the checks, their callers and pud_shstk(), which has no other
user.

In a KVM guest on Zen 4 with Safe RET, zapping 4K pages takes one branch
miss per page fewer. MADV_DONTNEED of 1 GiB gets 6% faster on anonymous
memory and 8% on shmem, munmap() 5%. THP is unchanged. Without Safe RET
the difference is within noise.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
v2:
 - Remove the checks instead of building them only with CONFIG_DEBUG_VM
   (Dave Hansen).
 - Drop the Fixes: tag (Rick Edgecombe).
 - Note that without Safe RET the difference is within noise (Rick
   Edgecombe).
 - Drop Jose's Reviewed-by: the patch is new.

v1: https://lore.kernel.org/all/20261102144001.342837-1-kas@kernel.org/

 arch/x86/include/asm/pgtable.h | 16 ----------------
 arch/x86/mm/pgtable.c          | 26 --------------------------
 include/linux/pgtable.h        | 20 --------------------
 mm/huge_memory.c               |  2 --
 mm/memory.c                    |  3 ---
 5 files changed, 67 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 000fc6c1ca37..613c22c7838a 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -199,13 +199,6 @@ static inline int pud_young(pud_t pud)
 	return pud_flags(pud) & _PAGE_ACCESSED;
 }
 
-static inline bool pud_shstk(pud_t pud)
-{
-	return cpu_feature_enabled(X86_FEATURE_SHSTK) &&
-	       (pud_flags(pud) & (_PAGE_RW | _PAGE_DIRTY | _PAGE_PSE)) ==
-	       (_PAGE_DIRTY | _PAGE_PSE);
-}
-
 static inline int pte_write(pte_t pte)
 {
 	/*
@@ -1666,15 +1659,6 @@ static inline bool arch_has_pfn_modify_check(void)
 	return boot_cpu_has_bug(X86_BUG_L1TF);
 }
 
-#define arch_check_zapped_pte arch_check_zapped_pte
-void arch_check_zapped_pte(struct vm_area_struct *vma, pte_t pte);
-
-#define arch_check_zapped_pmd arch_check_zapped_pmd
-void arch_check_zapped_pmd(struct vm_area_struct *vma, pmd_t pmd);
-
-#define arch_check_zapped_pud arch_check_zapped_pud
-void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud);
-
 #ifdef CONFIG_XEN_PV
 #define arch_has_hw_nonleaf_pmd_young arch_has_hw_nonleaf_pmd_young
 static inline bool arch_has_hw_nonleaf_pmd_young(void)
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 4a105f283cfb..58e5012b56b0 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -797,29 +797,3 @@ pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 
 	return pmd_clear_saveddirty(pmd);
 }
-
-void arch_check_zapped_pte(struct vm_area_struct *vma, pte_t pte)
-{
-	/*
-	 * Hardware before shadow stack can (rarely) set Dirty=1
-	 * on a Write=0 PTE. So the below condition
-	 * only indicates a software bug when shadow stack is
-	 * supported by the HW. This checking is covered in
-	 * pte_shstk().
-	 */
-	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) &&
-			pte_shstk(pte));
-}
-
-void arch_check_zapped_pmd(struct vm_area_struct *vma, pmd_t pmd)
-{
-	/* See note in arch_check_zapped_pte() */
-	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) &&
-			pmd_shstk(pmd));
-}
-
-void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
-{
-	/* See note in arch_check_zapped_pte() */
-	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) && pud_shstk(pud));
-}
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..fc32289af58a 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -621,26 +621,6 @@ static inline unsigned int exec_folio_order(void)
 }
 #endif
 
-#ifndef arch_check_zapped_pte
-static inline void arch_check_zapped_pte(struct vm_area_struct *vma,
-					 pte_t pte)
-{
-}
-#endif
-
-#ifndef arch_check_zapped_pmd
-static inline void arch_check_zapped_pmd(struct vm_area_struct *vma,
-					 pmd_t pmd)
-{
-}
-#endif
-
-#ifndef arch_check_zapped_pud
-static inline void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
-{
-}
-#endif
-
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..6e49fa841911 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2558,7 +2558,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	 */
 	orig_pmd = pmdp_huge_get_and_clear_full(vma, addr, pmd,
 						tlb->fullmm);
-	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 
 	is_present = pmd_present(orig_pmd);
@@ -3045,7 +3044,6 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		return 0;
 
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
-	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
 	if (!vma_is_mm_managed(vma)) {
 		spin_unlock(ptl);
diff --git a/mm/memory.c b/mm/memory.c
index 0fb676dd2bd6..25d630033642 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1755,8 +1755,6 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 		clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
 		rss[MM_ANONPAGES] -= nr;
 	}
-	/* Checking a single PTE in a batch is sufficient. */
-	arch_check_zapped_pte(vma, ptent);
 	tlb_remove_tlb_entries(tlb, pte, nr, addr);
 	if (unlikely(userfaultfd_pte_wp(vma, ptent)))
 		*any_skipped = zap_install_uffd_wp_if_needed(vma, addr, pte,
@@ -1795,7 +1793,6 @@ static inline int zap_present_ptes(struct mmu_gather *tlb,
 	if (!page) {
 		/* We don't need up-to-date accessed/dirty bits. */
 		ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
-		arch_check_zapped_pte(vma, ptent);
 		tlb_remove_tlb_entry(tlb, pte, addr);
 		if (userfaultfd_pte_wp(vma, ptent))
 			*any_skipped = zap_install_uffd_wp_if_needed(vma, addr,
-- 
2.54.0


