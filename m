Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC684C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79FF6B00A9; Tue, 30 Jun 2026 06:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52836B00AE; Tue, 30 Jun 2026 06:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67756B00BF; Tue, 30 Jun 2026 06:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90D676B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:59:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 196161C33B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:30 +0000 (UTC)
X-FDA: 84936282900.18.708173D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 761CCC0004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9bL17tg;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782817168;
	b=qog6T6hM58VtnD0Wd964ioqhuWY85hVBeJ8Uqf4xbSlmSZUYItmhmHtPKkPtcAupO04Pxe
	vkzIreEKEk/9fKVFi/s46ef2DGMWwdTQt+8PHEVfBEOYQMJQuvS60/5sJB7/aWJJg2JSmN
	9VnkTbl44tIof0FD6wLgnGn0E87sYlw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782817168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/60oaCW2BQae8L1Ed3jr0q0Fd1+merS/wb25bNKYVmA=;
	b=Y6AU8vpGAVH/wOJD4RD9cA8TmOu47X5uSROCG813hj+177sF3O7dC2SsnqEKShFZGCHWZI
	ZasY+bgfkT0/+k+BHpkCZv0WyOf+RcC4sWGuPPZjYRKzg7pEopfezPV11vv+8so7JnIXgu
	yQfyJXgPBBtbjBZzsEphpl0PBpwDesc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9bL17tg;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 053D1600C3;
	Tue, 30 Jun 2026 10:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4A31F000E9;
	Tue, 30 Jun 2026 10:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817167;
	bh=/60oaCW2BQae8L1Ed3jr0q0Fd1+merS/wb25bNKYVmA=;
	h=From:Subject:Date:To:Cc;
	b=b9bL17tgX9g/0VWgldenTIgpoi2fQRFDuEHc7FExVmS+6DkVl65hZBJImOgYFJX+b
	 YJO18n/S4id56u9kjbmBjTHiscZwwq3pQL7DcehaGvyp5PmPxTvIPjMD1ZUtGMp/Hk
	 tS8+tmTA+wc0TXD6U9QAorrRL7GRWN72GGJ0ziqgp91Sa2+l38toe7uxR6Y3gy5AW+
	 WQVZ9yPo7tiHLFokWgMD0t2Sb1Etya7v78Q+6IFfOdPfQDcQc+IhRChSZ9lvmpCmz7
	 10Llg8Ddec0qLa+tZnjZlnkUMGYQgmjcbTGtBt3K54SCLkjnwhH3RPIpJTs0ET4Pp3
	 2Kv+U1cljNjKw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH net-next 0/8] drivers/net: replace __get_free_pages() with
 kmalloc()
Date: Tue, 30 Jun 2026 13:59:19 +0300
Message-Id: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIehQ2oC/yWMQQ7CMAwEv1L5TERahVTiK4hD7DrUHAKyS1Wp6
 t9J4Li7s7ODsQobXLsdlFcxeZUa+lMHNKfyYCdTzTD4IfrYR4fBTSorq7nCi8s05guO7FMgqKe
 3cpbtJ7xBAwpvC9z/i33wybQ0X2MxGTvUVGhuFYazkQkcxxdv1FOalgAAAA==
X-Change-ID: 20260616-b4-drivers-net-fc7f5b7e0a4c
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Edward Cree <ecree.xilinx@gmail.com>, 
 Francesco Dolcini <francesco@dolcini.it>, 
 Manish Chopra <manishc@marvell.com>, Mike Rapoport <rppt@kernel.org>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Sudarsana Kalluru <skalluru@marvell.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, b43-dev@lists.infradead.org, 
 intel-wired-lan@lists.osuosl.org, libertas-dev@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-net-drivers@amd.com, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: eaghts9itxda4axf6xyj8d49ff68i8fn
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 761CCC0004
X-HE-Tag: 1782817168-267236
X-HE-Meta: U2FsdGVkX18y2syVu1fkQbfpPgDNnb0uLUZkvgW/nM3K3IwE/Px3SBPj/G7Y0LbNv9Y8XR1f2q8uIlCH9bVUjWgpNP11bfqXkvAwnR6UF/Yp8a2P5Itsnb7GRN3hOdlC6gmkV4Vt7wGTdwXeck8Ni7MOS5f/Xo70T1RDRZe7cvj8/0R/1i4LGDfokIQdc8h4LBg0/5wn1ZU0U9FslERUUFIeU8CZBcTOWTSjq63do8uJ6TgQl+1dL5mUGiLsGwmWHUakYo2iq9d8jmNTVw2jUgNE8LAR9AGaWpd32/tn+JkaS9TjZa6If37SDn9HmMz+Px9FeD348fgv4l54U9v0mEapTWWzIqza5RJPmyQ9Yi96R1fgQB0tIIkrZJUNXlYAQ2MiLm9YH0L6d2+9cWTJxUfc25p3BvUEF5KLgkKCcflU2GAukV+eC51JUJ4I9Vbjtd3ztYtUjTjaBK9IZMc5KLvHo7w6Bii3J+gI1fB/MYd6QbZGL0Z6LphGeqzdZCoJieTt8kaMs0sUFlPOhrqKZwFbo2i8z65PdR0QuhUm2PaVWRY6TMlpF+vg5HQEtQ3ky/mVMPDl9ngf9W0UPA2GJuOjub1Duh+qHsyJfrOx2yfDVrQJsfkKrsVEp9zU4wWLM3KMG/HQ3Fz+qfLNcrvAGZhidRlhjqCYTDT185n1nk358W+XyPKqTeUkwZ46HaXbBJXkmY2rBUF3QSkdBSEHuynjmPC4tbxN3mv/o7xIJryHjdkznH+g8dZqZmonmlpcZM7v2R//xy+kqkXWYJjlz6KkJJtBGXGiTL87tgXmg9YDPMPVb4lh493lgMg6yai7ae4aKezmmDyzwH3taMww/GLoBx/gT5/nUUcYWaESRMBpb3nbi1SRqEbOuTr+eCFR57Vtm7/uxmY5xTSEuHUFatxvdjevc4t1o+ZxuxNBKTuFH1g9G+Q7zl2lr/CzpzddpyvjYvpQ01MFpyNAEto
 q0CSe0n6
 Zqkt2Ykb4N7dLfEl4WBlP7ENNR47Bnz1M1OKVb9yTzXyS0nqgXvvg95cJchaMI8weFNGw0NwdP1mJlOMy096fvLqsZtpvK1Tp+ZtZHGfVOTbGvzCO5S4ilY9znoYvqmvBkh8ARLbHiIqU04K60colFwoXbbn4PdMYYMA502hqMvMukqutg/Ej94iYhIXSQD1cAznZkVCi/vptlsBlGbAtY6R8MJ+eN0apcd47JMYGekU7JvkgUQVFm1e4QGFTg1kGnMZghydkjp9VAC6+D5SmnFol0Hk+PmfViIWeH+EMMymS+c0+ZoZS79iPf+F9HRH2MyEJe8is8v0fp2KgP4DLmUKCb+I6Tl5Jhayw+M1FA7IWfnUJBREwCuJ3y2U+vxt1VfpK+ADIwgWsCtZOvh1OU46jCW4QvszSPY144iOzOMj/uIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/drivers-net

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

---
Mike Rapoport (Microsoft) (8):
      b43, b43legacy: debugfs: use kmalloc() to allocate formatting buffers
      bnx2x: use kzalloc() to allocate mac filtering list
      ice: use kzalloc() to allocate staging buffer for reading from GNSS
      libertas: debugfs: use kzalloc() to allocate formatting buffers
      mwifiex: debugfs: use kzalloc() to allocate formatting buffers
      sfc/siena: use kmalloc() to allocate logging buffer
      sfc: use kmalloc() to allocate logging buffer
      wlcore: allocate aggregation and firmware log buffers with kzalloc()

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  6 +--
 drivers/net/ethernet/intel/ice/ice_gnss.c         |  5 +-
 drivers/net/ethernet/sfc/mcdi.c                   |  7 +--
 drivers/net/ethernet/sfc/siena/mcdi.c             |  7 +--
 drivers/net/wireless/broadcom/b43/debugfs.c       | 12 ++---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 11 ++--
 drivers/net/wireless/marvell/libertas/debugfs.c   | 39 ++++++--------
 drivers/net/wireless/marvell/mwifiex/debugfs.c    | 62 ++++++++++-------------
 drivers/net/wireless/ti/wlcore/main.c             | 14 +++--
 9 files changed, 73 insertions(+), 90 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260616-b4-drivers-net-fc7f5b7e0a4c

Best regards,
--  
Sincerely yours,
Mike.


