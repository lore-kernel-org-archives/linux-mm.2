Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8700FCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D658E0015; Wed,  8 Oct 2025 08:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14198E0002; Wed,  8 Oct 2025 08:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29848E0015; Wed,  8 Oct 2025 08:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF9C98E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:47:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71A1E59577
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:47:25 +0000 (UTC)
X-FDA: 83974922850.05.0548FD8
Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [178.154.239.148])
	by imf04.hostedemail.com (Postfix) with ESMTP id 769DB40007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:47:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=oueu940+;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.148 as permitted sender) smtp.mailfrom=work@onurozkan.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759927643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bkq8bxjoQBPBAeuIV+Iopt/vH8cY8Lqh9crfFUygyEc=;
	b=AAQ5RdSpPYOoA+agnBxqNppIIu/E8mZNCNkHLbFe6niiOsPqhAdGpQHXMoyLYEU89A9Rgu
	QxLb/5ZY1HaDFJWozBNAfs8fgYFXHdbrSLtf85RkmBvH11E39bItfprIUH7amjyIVVXkZz
	wLj9g66nj72s51DiaXX61y9VZyspS+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759927643; a=rsa-sha256;
	cv=none;
	b=0g6kQXfUfzwWWRubjioajFiE0dkCu8JGWXMGcJ0LYKJ8ECfqguZKNW/ZU+hzi5c0F/XC0k
	WOB8DLZmtpNLOvNAtPVuTpCkfittTe+dw2kvLT+xzDYK5xOj/pHHXgShKkkNZHdjo78fyE
	6kxRYNpkUgfWDdumuXf2KptUwXzNK7Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=oueu940+;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.148 as permitted sender) smtp.mailfrom=work@onurozkan.dev
Received: from mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net [IPv6:2a02:6b8:c1b:3715:0:640:1185:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id 63A8EC00DB;
	Wed, 08 Oct 2025 15:47:21 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id LklD46OLveA0-JB9jbiOL;
	Wed, 08 Oct 2025 15:47:20 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=mail; t=1759927640;
	bh=bkq8bxjoQBPBAeuIV+Iopt/vH8cY8Lqh9crfFUygyEc=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=oueu940+xx8CrpE1N/VvyUC7r5OLbi3YFswozl9PaSVeEPclX2tH70L+qHv1MZVR1
	 2r7DlbvFfG+aNC0j7OEyq7xHiihbg+Sf+rkqrxYA8Dv4n/X3Y3raDzshe8YpIOhLYY
	 7DdL0RmbyzaASALMqeLOySMIKJ8557TCVBMeKj8A=
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: rust-for-linux@vger.kernel.org
Cc: ojeda@kernel.org,
	alex.gaynor@gmail.com,
	boqun.feng@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	linux-kernel@vger.kernel.org,
	acourbot@nvidia.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	corbet@lwn.net,
	lyude@redhat.com,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: [PATCH v2 0/4] rust: xarray: abstract xa_alloc and xa_alloc_cyclic
Date: Wed,  8 Oct 2025 15:46:15 +0300
Message-ID: <20251008124619.3160-1-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 769DB40007
X-Rspamd-Server: rspam02
X-Stat-Signature: pgt9r469xpm4tij6osj4x11c8cmwf3uh
X-HE-Tag: 1759927643-127004
X-HE-Meta: U2FsdGVkX1/Fs8nLRLhzOXz3lvxvBmZ+yi8Pxfvxr3COwu33HV7hA8RgB/4SLqfj2cUToJbpO57DO9i+HDK4O65KulEWnFmORD91RZHb1HFo40OoHDSwMYDhAyj0UMBIoeglGfg4kXXAaLxIZZ+iD84XkdBUISAxfrIES1lF5aFw2pexUSeCibWkizq4mRyMHNI2hb074t2PTNXtYRMvmKbp17kObZG+2aeecsu8MwrFMwcGrUPNs6K1XMbFaHTEhrV0qRj24KHQoqSxZbuVFiKh1cZLbInpq39Y9hfJpqcL1wpBeIE3glNXExRROOda3P74garVTlOmLQH1VIowQXlsl/CPxHoi2JmwDwBfDO5fGbajFRPR8eE72e9MmxQ5zHceaot2DhM7bV9CfdoJNyy+SlgieH0QFmDzNTa86KLsU6tPqqsZ+qMiZgJ1Ma1nuoCWrHIP2+118XHJzs/S47fOE/0ckq47OYIl1BjnYM2BxkjxQoQwGu17Cg0AoGerr76t+0PnK8yFe5meiberIS03Vt/FENixct7I5rUztbo+GfAyVqHCroM1qGZYG39jMxbPoTt8FZtXa8oQ8gzTdyRyF2Gh+I+pBzHkPSyKA9VPkQBHi4sIfnOMtlB2/RlCae5NFhZqOUbdpucBtCFyLZMYTEGyrkLpPe0CRxNdsAsEIDreyH64I3lorTbQj4lvpBSt7b/uBIzT7fWBmiYSD8k2iHUDLYJIGPbQOr1uqN3vIoZxqkTmvwG7yxM55HroJzGZPcm26gS4fR6f4VoZsPbHtPcXFLcN5PQ0WQWNrRaWcRWX0rOIR6HbPpW3bvb8Pt0lIsGlkkgU7sAl60rZAagzv75BFkbV2GUHG8NSrbb070hHdBZ/RVmMdGmG10CZr6RQs6I1lZ/81PG2KUmAhjjn0EorcZezl1MRz/KrIbNm4jaQLLf31y4ziAG75SlGPfaTmZfRnmH5xQ7N8c7
 KB8gsrd7
 yvQvsl4f/bcSiBvdHh7D+AJ/nKJhby29skdZRffDe2PbwW/GrBaVKgyg7hTTsLLVPV+z+iSd12w2180AONnrIgmJlVzo1TdsYF+UU2Bn3GQgUt67H/T9xx2q5OLKKce2JDgOjP84oupi5z+16COWtPJA7aj5tj4wZcNfmM1LADTEOFIyE9phXPZJN4/uitkteNF5/1uZW8Gs4jAF/bBY0jw0NQ4+tmvrzst0cIffbaihMbYdIJyZiPbUTaHmgraOEX6HbPvmPDUwjcdr6kdSMkG1doi4QouwVV4lJ8cl+6/K3G+n41EegPXPjsNmZ7O/XWR1N5d5Jbru/f5c4DXiS3nmojBGNAqnfQuKLqfcP9Q822473tkS4CPxY/jht0LUe8q6INFIVu4u7X3i8P0niybYXkSqgy/wfS+5QxOU7I8+Ys9xaLfr1KetiiCHdeTxU6UZZKcy52f+hwLvnl9f17MJhwB8dUyPL22EXQHBscotyCkjYIdmk/hkIjnoajgB/QbsYHkaKaE9HzhqZRclOorz7782n3Tz6n8gsXJkz+QDaTLlZ4sWUlFM1dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Second version of xa_alloc and xa_alloc_cyclic abstraction
patch series. See the initial version at [1].

[1]: https://lore.kernel.org/all/DDCV43KW9OGL.27I8HP4TSTQ6N@kernel.org/T/#u

This series will also be sent to linux-mm@kvack.org which was not done in
the previous submission.

Changes in v2:
  - Moved the pointer check into the constructor function.
  - Minor updates on the function doc-comments.
  - Minor updates on xa_alloc and xa_alloc_cyclic commit descriptions.
  - Replaced bindings::xa_limit with Range<u32> on xa_alloc_cyclic and
    xa_alloc.
  - Updated how alloc_cyclic handles the next pointer (it no longer
    requires a mutable reference)

Onur Özkan (4):
  rust: xarray: move pointer check into `XArray::new`
  rust: xarray: abstract `xa_alloc`
  rust: xarray: abstract `xa_alloc_cyclic`
  remove completed task from nova-core task list

 Documentation/gpu/nova/core/todo.rst |   8 ---
 rust/kernel/xarray.rs                | 101 +++++++++++++++++++++++++--
 2 files changed, 96 insertions(+), 13 deletions(-)

--
2.51.0


