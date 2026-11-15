Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA12B606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 05:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQrW1hFA
Received: by kanga.kvack.org (Postfix)
	id C1B746B05B1; Sun, 15 Nov 2026 00:03:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF35A6B05B2; Sun, 15 Nov 2026 00:03:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32A56B05B3; Sun, 15 Nov 2026 00:03:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7056B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:03:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEE3E40542
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 05:03:07 +0000 (UTC)
X-FDA: 85436159214.14.EFBF3B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7D505120006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 05:03:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQrW1hFA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794718986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=azq6hlaktEMUDgLyNyRfk0hKL7yGmOVuQpf+tMmLcs8=;
	b=Z4p/veKRhXXNaq+5f49oeJ2aoI+hKQ0r99x/KKK/XdxDYYFR4u5ZtBr6nb1Ysc+LuEcWsU
	bledG7zga13U4EtUHMhFOK+k5zxKjNbq26lAXy/DpkwIejKYVq0qrVTVlFavHy4EARl9y/
	WlgtEYqiglmUM9KyVQ2GSD/kFoNizkg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQrW1hFA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794718986;
	b=Rhc79cpWKNFXxvjWmdtH214P+zuCKW79GZhXkyWcFytA1oRyFIoPmOBIMKGd2a5yrl50OS
	MK6nc7YhDUd0q0Jv6XwjAaODRn3x4r4fPamSFRY4dRqPebiK2Ozvt/Km69x8Kg0CNbBgR2
	qFcbFKY0f2aZzrHuYi7ZXeV/LiTQZLo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2042D60D36;
	Sun, 15 Nov 2026 05:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098C31F000C4;
	Sun, 15 Nov 2026 05:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794718984;
	bh=azq6hlaktEMUDgLyNyRfk0hKL7yGmOVuQpf+tMmLcs8=;
	h=From:To:Cc:Subject:Date;
	b=kQrW1hFA9eLROj+8e9HgGk1bBbcWq7RXQkuKPs9FiAK/S3BOBKoe776SyNhHchMa3
	 Sc57o9flKR5qM7CJFj5NoIM6e4nwb6krOaxMUGtTrFL6Pg9f3xAZ3HM+rs9nGYcoTZ
	 gRcGCAYfU+1NY99N6C7eoFjeaXymFovRdrhEoG5WX+DXlYPdQ801Fp/1UZJNQZ9p0n
	 o54/BgyH/7moBX2pEhuVL7ExS4gvOuyWguy6X96/BRARkEqooe/Hd13sU4UkQUfH6g
	 5/ZX/MDGeKzHeKspVqQe0jCODYSTB01Dzt/wNfeTS/WiNlr/lPWpkDqLxxGVLjG0UR
	 I+mqd2/+5wj0g==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] liveupdate: fixes for 7.4-rc3
Date: Sun, 15 Nov 2026 07:02:58 +0200
Message-ID: <20261115050300.1847760-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7D505120006
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: cmsnzdomauqzjd8ee7ns4ye16yji8tk4
X-HE-Tag: 1794718986-533379
X-HE-Meta: U2FsdGVkX1/7EQlBARu0yq8dpOw2Uf2AhnSQJ6izlpMHrvngTopge9lwkOAr3riYbEOLo0TuMpzTOeJhOl81M6Aoz69E4Cqt+FyDhroI9UA9efnEkXKpMp1FWKrrhQ00M5czUTk/2TeLShGgmypbMOO04MOQzZc4sPnfNzuhl8nlZaW17SOWpS6wM2WTKhD81za37IwqbZlL0iaFSISaZYZsPCRHahcaNiPprInk7pxKQ9+gzA6Ox+QqRvS85IwFiuBD9TjiqUxGGnsxaykEpOgqg4Kqu/wg3LbHbZ8GjmVVHvQk1NbyLBs0+qGQrSUwaxbY6iBc0DRR24c8Ks0e0O7Kex6Y7xRq5WxhKwYsCJkF82TM7hdmY84q3sjuToJ4GsIe+Isg/iFQeUsd7GR1FGir0aikLZnXBnybmUL5g5lkJM5bPSdsy/85iCFpZkxAYWj86kOa/SClX3AdK1qmRQ776UcKUQjWizKLwmx8SEhp4UqVQNJj/iw4nEqc3yEL4nWXRcQGK5KdQvnVZy9FsjSVdlUZgCDhRAscnB3PdPr74gg2bILfO8Sm+wnLgeI52QZZIxyDj61ZvMl4DM79ccNnj7r9T+agoxXofoMtkmrqJ/gM/p7hE+X2BgkuCv+mqkQzM5NEd9ALnMq6dc5glHGcBZr99GQ3Tia/QaeyR6G4reyCbQDo/KfGD2nkBS3p0abJ9sVXSMuCBxaIgGtbilankGDaZ+W1PNdpwelBJKqXXDqfiFx3bd73rnwZm51GGm/X51rbLvjTEfCXfydnRI9joWAzPyYiTRwnULgTIkKPy+Vb4oEVH0BhHBVMZaDbrpWIAypKXSAptJkl/y9TQKqSLMFDLVQPA6oznMROSgtB6capQX32/URBVSAkoe6iNCenSsMAaO0Ba4YTshgFq2jNUUmaxrFWsXskDuG6EY1iLsGmT9YkAPidZKjjvI0NeeCdzbLKEXyiKCPufCH
 mDbhRTYA
 9M5dISfehADsyDcX3+N3G4u6RyH3AOvYcSH8BQFB/uN1kwEjRl6wNeJfIGtVe09k+AvEA1JDnrstLtxYVwesbgGM9YqUxLzvp/IYZl3gEMr1Heo2To4TPDGF3Z16zHAzr9qENaIjIvhQoRPlOjmBDvc+tIXOAk8+rX4huzJF2C72TmVWp8uhnhyCSgzFiIjgQvDr15m2k7Nh68WfA89YS23JwW+U2lS5BXHHeh8b8hflL0BA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/fixes-2026-11-15

for you to fetch changes up to 58c5852ca96c58cdfdb9646870b217fc54d06a97:

  kho: check fdt_phys in is_kho_boot() (2026-11-08 11:20:19 -0500)

----------------------------------------------------------------
liveupdate: fixes for 7.4-rc3

* avoid address translation in is_kho_boot() before the linear map is
  initialized, fixing early boot BUG_ONs on arm64
* check for duplicate session names before growing the sessions
  preservations block set to avoid preserving an empty block that causes
  restoration to panic()

----------------------------------------------------------------
Christian Aurich Zanettini Martins (1):
      liveupdate: check for duplicate session before growing block set

Greg Thelen (1):
      kho: check fdt_phys in is_kho_boot()

 kernel/liveupdate/kexec_handover.c |  2 +-
 kernel/liveupdate/luo_session.c    | 21 +++++++++++----------
 2 files changed, 12 insertions(+), 11 deletions(-)

