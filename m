Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C73F606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OFzOCWMK
Received: by kanga.kvack.org (Postfix)
	id 40A246B05B5; Wed, 11 Nov 2026 17:00:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0FB6B05B6; Wed, 11 Nov 2026 17:00:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F896B05B7; Wed, 11 Nov 2026 17:00:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB5E6B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:00:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 836BB120428
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:00:12 +0000 (UTC)
X-FDA: 85424207064.07.FD3C169
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AEA198000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:00:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFzOCWMK;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794434410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0OVdX8T4PZFsw4ZwfqMzWpXCj72B541hV845/DfqAEM=;
	b=mWRHh1Bw/9MuuoVig0f5rzFo6ZsQjG5P3VKxfwGJqp7JCAHC+GixPsqB2LEOYHhuIVLibd
	g0dssTBt9giQEH8ofOZF3pbxwIR52TqgrZqaUMrulJ0vxvzDKpVTJG/ksU5aAAF56LB1Rb
	GkxokzV//6i07amMTddou0yeh2xHPTU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFzOCWMK;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794434410;
	b=JNifh5JBS2f9Gous+/0nrM7ZV5oYhdHpRqQ5DQn/y8u0EoAFn5t8WgbP44TDJhXrY8ilHj
	LafVX3v8Xh9pHQvJeo3SI0bMRJxcDA46DY9IqqgEBqKW4V5yZ/VvUHZdpIip2KIOtdEawk
	YBMsutSeG0+4rG7knz5Qwm91XLESDAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3738163A66;
	Wed, 11 Nov 2026 22:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4881F00A05;
	Wed, 11 Nov 2026 22:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434409;
	bh=0OVdX8T4PZFsw4ZwfqMzWpXCj72B541hV845/DfqAEM=;
	h=From:Subject:Date:To:Cc;
	b=OFzOCWMKtLuxtENYeZ7QoRpXvdv8f9TcbIZTC0tztvZy3Zr9poC6dnlnbqhO7GyPP
	 C2T60v2kuEnzg0/1Wqy7Z//u8yowRRmO3jp0NVzHv9tTgcjn4C0PS3dCSTriPX7COE
	 A1O5F20dGpWSv4yJSILFo4OEam9B5HjeEmNgXFA43VAQWXX+BnKuqmlNTW98pXIpdT
	 0LtsqjcUSAKeWDgGElsVwNVo0ZYssvYq+1SndIjOYu6FAlCnyMbDgxtPnZNTXuSXFm
	 Y8QE+HYVnHGAOCwmkIckeqyhAcJz3y/R30bdIaY9NbxCTW32+VI1SRdQ/PzOLFql9e
	 Du8DxugwdrnAw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/3] mm: fix PTE table overruns with folded PMDs
Date: Wed, 11 Nov 2026 22:59:58 +0100
Message-Id: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAF7l9GoC/yXMSwqDMBSF4a3IHRuoEix1K0VCHiftFZuGJIog7
 r1pe2bf4PwHZSRGprE5KGHjzO9Q0bUN2acODwh21dRf+qGrE7FAFW0WKLvoV4RTCE4MN2Os9lJ
 6XKl+Y4Ln/de9T3/n1cyw5Ruj8/wA3sDMhHkAAAA=
X-Change-ID: 20261111-pte_table_clamped_end-69bbcaf44fe7
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Peter Xu <peterx@redhat.com>, Lokesh Gidra <lokeshgidra@google.com>, 
 Barry Song <baohua@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1006; i=david@kernel.org;
 h=from:subject:message-id; bh=4doLGZ+k/LEIRTS620iPxby3DjELTASeXofs3KT3y4U=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+PE2xFPCOMDjgLCXKLXR4H0+eto568Ya7O21jGWMKt
 nKe8wnpKGVhEONgkBVTZAkKvm/w8uW62mo3PmaYOaxMIEMYuDgFYCKHRRn+110rN70bEOEktOiD
 pdS2dSl2P1PfuVZvdSs42HRw0RXrW4wMS30PaU8v2JMx54+sQaPMd7f8nn0SDFWCqqYOoUKKQXt
 4AA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: z1he7yxyhuhxojcrxa3fey4yunzjag5b
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AEA198000D
X-HE-Tag: 1794434410-164884
X-HE-Meta: U2FsdGVkX18Oc2v34z6zWucKw8v8s/iNBvri/7CIEaey2NQZM/2geazfZfLqsYqHS3VbJjWDPF20casyHwfnQTt+DDHoaRiFZk71H6waSvJfPeX+L39fSI+nGwLSFgHpJE40I+tKA+okyLjhjdPuI3RiLK4lQqK5L661w6trORQaeX03JCQ3Uo5/A2Dvc7LUACy89rX8MUnYcehr9LxvJYCvgaCzRH8i3owvMukuN6uu+/2j+QQxGys1Nl0gu1/V9TgAVHfHzpiY3wPERunPjagvPevAJDqAfLuc8lDN0J0zo+LCeTuzJAjBYpu957/1jOBnlM1fAzOkiAx9V0nOFO6tzrU9Lf3g2I1HtG1puZhMFJh/1cqwgzeL6opIfgg4rEFB4PmdP0TmSdExSEaSZ7vGEYoNtn8l5vzZtgAST/Bw6DQGBibm5XjWJGYK0Ba0DCpL7M2V7qbGH367xLZPri9sludWAM8K7trtI8rS17bPMjfaGDS0IZ4IRx8EEK4lJf3mlbteeX18Fv61CaCaptUvi78ugSmin8aOZDMmiFgeV11OyPlhFbDddbsKq1G0ee5WzI7cpj5Ye8E58Ge+MMjT44rd047Ws4HK1s4oHp93JH2PvyI0TqidUbQEy0p0L0k2BEg2ImconZqTiIFXg4649yLKtzD0nohF+PunLa+02HtMquLRnc4vPDDMEOpWx4GHvvOytVGuV5uhgK62uOBgrotMevGCkDzf8eszv++rZWL2d0eNLwLgc3ZYKT3WHVWPmwHu6KjbCy25GQcM+PYkTAkWkc/gLmaAtPK5DAbPXs14Ru7clT7eQKO9ifrtWquogjhFRQ44Zb02aJ5SH2ab7YABeyd+or7hF9TypXP6kpvcKdVYlBzCH0kthfDF293MCy2kIJrbCm2ZPSs2svwRc1ANjEsFJ+iPOXodhUlyBJZOgqxLATTLxwIIh/onxhmkBNNcQM5EXlvIKsK
 wOGTmPTj
 EkrF0Trm+rJ7y1sE5WFuZIe4JTNb39/GJ5F5Q4dE4f+4xCs+12iHsBR3cqbdWRDAZxLAvKREmpdbhgoLgfM7sHxTj3ZgnqJcmYOAPhdb7QAfzssDkuSgDb1DS0Jztax749yrWNLb4h6rbCI/vjt6c7LXPhMVCoBOR6DqYjBmh8wAJ0/Ri+BbqxkPL2ebTtphxhSNUFftkYUJ3Eg+shUGZPTK9NXj8WDUgmsEL3kn/JSXC5H4nGb3gI3s6Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix 3 pmd_addr_end() abusers that can result in PTE table overruns with
folded PMDs. Let's factor out a helper from a place where we
recently stumbled over something related, and use it to fix these 3
cases.

I'd call these more urgent because they can corrupt memory, although
folded PMDs are uncommon.

I'm planning on picking all 3 up.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (3):
      mm/userfaultfd: fix PTE table overruns in UFFDIO_MOVE
      mm/rmap: fix PTE table overruns during batched unmap
      mm/rmap: fix PTE table overruns during batched reference checks

 include/linux/pgtable.h | 24 ++++++++++++++++++++++++
 mm/memory.c             |  7 +------
 mm/rmap.c               |  4 ++--
 mm/userfaultfd.c        |  4 ++--
 4 files changed, 29 insertions(+), 10 deletions(-)

---

base-commit: d369ba5a46c65c54b94c94713ca1fb4ad6a87ebf

change-id: 20261111-pte_table_clamped_end-69bbcaf44fe7

--

Cheers,

David


