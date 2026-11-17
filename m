Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C9560A380C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFcJrDjg
Received: by kanga.kvack.org (Postfix)
	id AF1476B00EF; Tue, 17 Nov 2026 08:07:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9496B05B0; Tue, 17 Nov 2026 08:07:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DEB26B05B1; Tue, 17 Nov 2026 08:07:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6A26B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08D661A0435
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:03 +0000 (UTC)
X-FDA: 85444636326.26.19C531F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 69DF340008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFcJrDjg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1pVjlFKLqrkizC9FmJoCvgI9LyQi88+dBoMO0i3338w=;
	b=3TgQObw6rU4Gpza3m61uWgYBhmpNzL5OsmhkyURUaq8jxH/HtU2Zx3QqTBJqmpATtmcriy
	5iGKahJF/MUqSNIhUzGpumNP6xwP9aPdunXJVrypxmQ9c/+bkxddCz2u1aHHe0ikruToIs
	D9/G3mZplTOzPndwCvv5miJkeGHiShw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFcJrDjg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920821;
	b=ghCBCu77i87kkcgIQl1NyCA1tE9kCacs7AGaJBCQ4mnkvsWvHL8GMGEW2vVYou1+LmY6kw
	ULL8YqeJJqUahIw8DWvCKLTmkjyTETH/Y1NsLP4s3zuEE66jlNWaZQMvPJJ2UKnkgaYfH0
	eKxh5n2kgM+WLSNFTgf6/tKgym8suAU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C98C4634BE;
	Tue, 17 Nov 2026 13:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2D21F000C4;
	Tue, 17 Nov 2026 13:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920820;
	bh=1pVjlFKLqrkizC9FmJoCvgI9LyQi88+dBoMO0i3338w=;
	h=From:Subject:Date:To:Cc;
	b=HFcJrDjgU5KIKe8VUxdGSrgtpeFOrq2E4A5i5M1vM3jWpYK//HFX0YELRLGduYiYs
	 R36DFGAsEIfPAf8wRD1Gi0kFcRf27LgMNogbjZaa/mY/kf4XRTFCux4O5H//2ffwbC
	 956UoH31u0lYKQqCK0V7kZFvBycOKZ7WxytlxlIxV38MkdcntgbVMavEeoEekpq8Bu
	 tzKnm92DUwib0fIztSd4MNztORti8B492mwdPp4rLn2teFl5H8FPr9sqDtNJnOPyAK
	 0dqLXjJoLydhIJuf4yhcljWDb5IeUplvtkOeGxjlaQXQqAEN++Jf8EvOYwGX+cp6ln
	 MgpgGDeUQSg6A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 00/14] s390/sclp: replace page allocator calls with
 k[mz]alloc()
Date: Tue, 17 Nov 2026 15:06:52 +0200
Message-Id: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WOQRKCMAxFr8J0bbWFoVhX3sNh0ZYIVWyZBBkZh
 rtLcenyJT/vZ2EE6IHYJVsYwuTJx7BBfsiY60xogftmY5aLXAktKk6FFpxcP3AE08xclGCtkWB
 K0Gy7GhDu/rMbb/WP6W0f4MakSQlrCLhFE1yXRhF968PpZWgETPvO0xhx3l+aZPLs7VKK81/7J
 LngBVROC7BKVer6BAzQHyO2rF7X9QvegnOG4QAAAA==
X-Change-ID: 20260907-s390-sclp-ready-05ebba1ea5e9
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 69DF340008
X-Stat-Signature: 3zpue3rpbe3skxeiak7xeattxko6kwmg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794920821-267034
X-HE-Meta: U2FsdGVkX18XpkpNJVOt1RJAMXWIoDiK3pdpD5zgWpp43zR4w7u9sXUOoGF+yfXvLp/NxhfJviN9ryqXUfv5y2S6+n2x8rap/0lBFzSxF11O5CbrfUINgHedPmpDEDigmivSdu//AZWQfJ2khYaSidBCw9Bsu+HAf6CwQ3SfkOe86/Yz4muouJkh2/RTZ5kY/eGx20mHzFi9FtikbJutz3RLgqRFLI1OEgqb1lIzIB5dOSYx8I0GdgsS0e8xBGDuO9O6NCfRAQj4sDt4G9at4rXE8JuIN7sHIFf+yCO+4rMHVlSMToO8BzRUDY5Z//tGcqKIezJWCHIsp9ntLDMnc2v9V2gRZi12IQNOQ6FVVxesD6HThczOY5WEfiIJQ5DSAsSbR7A810pIlsNTMx8ixf/K6zcxHpVw2XXrzeWFkEVYlm6F8Cjjym2tMw+GVvHrKuQzQzH+nSIr1WMKg2CNs/vMDegtCExWZJPFHMkni040LVOU1j5gjXxRV0xTg7hkWazzKHWfHdFGdhmQGgtG7exlmapv2TTBj7H/Kfr22YCmjQZ30D/SaswIVFCceuqkgLBYDC2GCCwUix5gaJ0nDMOMUcK1+K2EnoVF9Q90tV2MK75o6c9XgBQQtCIss0e2YsmU7NvvU9CgqBTuSNCL8D1NU/kBUsea1oIM03XAuWX97Ds01MdKQfZQRudVvZn6iqd1CQJhpB5cLa4Dc9WHdsNmsNhWikiUZm9MNp3bbtmlSCyJZ4z1i2j36b6wKehCKraUdWwTHO/wUQdpFxa1d04wdOcp/i6Uw+Z50aINQtp6nkuu+i2APkPy6Fj1I4ssXaQIU+UdlDFaBHsfx6ZqhUJWDpz1b3QK+M5lKYX5+mQ7FQU14uqX4Fsmj8oPsFY9qQThoK4Q/eKzzRsGtVrxxxwTMgA1Um8Tj0pGBR0KiAJ6w/L5Tc8zOOrX0KIJ9TsgO5IiVr1C4P7QqJP2UKJ
 f019FaJq
 0mXF6PAn5pkHHbuZwOliaDolCoHeyNXqtcyfw/tctv83CBhxlYRHUigyCV4Xb59g2GBmf9FnSRZir0Kt9jzU36Kbmt4sjyKA40HKiNsEvKwDAqMkoXq/AUfdvcSTRmJr/4+cr00F2Y+HQv7Z4LhWQ1MJHSMem9kFHvCJq4eHxPx9TOCN/JzZX5B3ymVFC+mZupSLcDgTQOjgPX4nLjx9Coe8lO+HqFGcUGA/Jv0enElAq2Ni85rHo/JSLfayAlurF7D9kMPezQw7rl/slPoARV/tDr2kBFWDgeP1sI+/dGGxrwE21Y2m21firxiVk4QcmBE2+Dd8+SFtjS0WSHU232sQ9+lPEiiNNY8I9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This the next episode of conversion of page allocator calls to kmalloc
family :)

This series covers SCLP buffer allocations.

= tl;dr cover letter copied from the previous posts:

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

The patches are deliberately kept small, so that every conversion can be
reviewed, and if needed reverted, on its own.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/s390-sclp

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

---
Changes in v2:
- sclp_cmd: allocate a power of two size for the CPU info SCCB and drop
  the misleading paragraph from the commit message (Heiko, Alexander)
- sclp_ftp: use struct sysinfo_2_2_2 pointer to get rid of casts
  (Heiko, Alexander, sashiko)
- add Reviewed-by tags
- Link to v1: https://patch.msgid.link/20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org

---
Mike Rapoport (Microsoft) (14):
      s390/sclp_vt220: Replace get_zeroed_page() with kzalloc()
      s390/sclp_config: Replace get_zeroed_page() with kzalloc()
      s390/sclp_pci: Replace get_zeroed_page() with kzalloc()
      s390/sclp_ctl: Replace get_zeroed_page() with kzalloc()
      s390/sclp_con: Replace get_zeroed_page() with kzalloc()
      s390/sclp_tty: Replace get_zeroed_page() with kzalloc()
      s390/sclp: Replace __get_free_page() with kmalloc()
      s390/sclp_sdias: Replace __get_free_page() with kmalloc()
      s390/sclp_sd: Replace __get_free_page() with kmalloc()
      s390/sclp_cmd: Replace page allocator calls with kzalloc()
      s390/sclp_cpi: Replace get_zeroed_page() with kzalloc()
      s390/sclp_ftp: Replace get_zeroed_page() with kzalloc()
      s390/sclp_mem: Replace page allocator calls with k[mz]alloc()
      s390/sclp_ap: Replace get_zeroed_page() with kzalloc()

 drivers/s390/char/sclp.c         |  9 +++++----
 drivers/s390/char/sclp_ap.c      |  4 ++--
 drivers/s390/char/sclp_cmd.c     | 13 +++++++------
 drivers/s390/char/sclp_con.c     |  5 +++--
 drivers/s390/char/sclp_config.c  |  4 ++--
 drivers/s390/char/sclp_cpi_sys.c |  4 ++--
 drivers/s390/char/sclp_ctl.c     |  5 +++--
 drivers/s390/char/sclp_ftp.c     | 14 ++++++--------
 drivers/s390/char/sclp_mem.c     | 12 ++++++------
 drivers/s390/char/sclp_pci.c     |  8 ++++----
 drivers/s390/char/sclp_sd.c      | 20 ++++++++++----------
 drivers/s390/char/sclp_sdias.c   |  5 +++--
 drivers/s390/char/sclp_tty.c     |  5 +++--
 drivers/s390/char/sclp_vt220.c   |  4 ++--
 14 files changed, 58 insertions(+), 54 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260907-s390-sclp-ready-05ebba1ea5e9

--
Sincerely yours,
Mike.


