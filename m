Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C831DD5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB3A6B0005; Tue, 16 Dec 2025 01:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F026B0089; Tue, 16 Dec 2025 01:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D7F6B008A; Tue, 16 Dec 2025 01:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE2F6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:02:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC71460373
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:02:47 +0000 (UTC)
X-FDA: 84224290374.07.2649702
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id D00DC100013
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:02:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ppfnkKY7;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765864966; a=rsa-sha256;
	cv=none;
	b=n0OCxAKqNEWdhfYj+vwM3ZkMCHEcXJ47s0Uuqu93iP3kMpXGRrY1ewu84ZY9Nmm98hORy8
	CBZ9IHj5J85JnuvbX9ecrrYkeZ7mqgxy4F1YFOhSQ9W/nqHFCOqhVxKTHoVsL+5hGimK6e
	ewlFQd7nu+fzXykRzrjPsLRnj+388pg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ppfnkKY7;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765864966;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGOzFJ500PVcaV+dapTFWlqwnBWmCrsv5S7CUpeyCVo=;
	b=XNkykrGjMYKcXOAOFNJDnoGcFf71FWhGLqgVPrwDdcYmvLhNljcSKTpelPEXYHvp1MBJyq
	poAZ2YA+3KVVgV3Y/PW2YLSLrZ6STnkjbiubJnJQcE3wYstdSJovdQ0RBo/H4CGxz4nL2q
	FHwCfnlIp9Dd9qXYzGBLc1A/5EPta7Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bGOzFJ500PVcaV+dapTFWlqwnBWmCrsv5S7CUpeyCVo=; b=ppfnkKY7+lW/TrUdYUcUZz/VBf
	mVHSjplGyr5b7kvrsfYcAa6FHRAoKduG90Sq0d+lfpJ8OQc8fJNWW727UgUrQufhcw6qqWCXzrDoI
	y+dL73y+NuEsCXyUIILRYOjZUHomjVK4BADfM5aHQF9h46Cv2eejD8vuOSB4GSzQfJRF8DQxz0BjQ
	ITHRnZo85JRS/es/qs8IhOhw/PlC0Ju8UpE2d0KC67aVVDHxWPkVFyHZKcXS9Rg6tLhyUA4zTiiJu
	XJJHAQl6CGxNmbRa+mIRb2HdWF+weGJtIZKr4YobrFWIGdvHRKU7Upc3x0/BoJCTUBt0tWptYSb3y
	4CnUxzWQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVO9B-000000010Pq-0AiR;
	Tue, 16 Dec 2025 06:02:57 +0000
Date: Tue, 16 Dec 2025 06:02:57 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Chuck Lever <chuck.lever@oracle.com>,
	Hugh Dickins <hughd@google.com>
Subject: [git pull] shmem rename fixes
Message-ID: <20251216060257.GP1712166@ZenIV>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
 <20251212050225.GD1712166@ZenIV>
 <20251212053452.GE1712166@ZenIV>
 <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
 <20251212063026.GF1712166@ZenIV>
 <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
 <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com>
 <20251213072241.GH1712166@ZenIV>
 <20251214032734.GL1712166@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251214032734.GL1712166@ZenIV>
X-Rspamd-Queue-Id: D00DC100013
X-Stat-Signature: 64g9yipikebwfjat7q4d4p7hphytdad6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765864965-7900
X-HE-Meta: U2FsdGVkX18mwgSEHIDcp5UiSSioiKYRA4vE0LgFZ/Bh1fINsQIWlxd8llEhPONBAojHezIGAw4Rro4VkKH5kDb06tfexzY9yrzPGT4/oaEiC8wA88ecI8TxhS0Adrz/DQa4mUrt2GDFXC9DIa4boAxVSTlK/AMNm5AQD9vw6y3Yy785Tev+u74FP/Sz2hH1dVZGZpPpnyPphWbWztA225Fdq1sHuvLnoEl9J7qa+CGmmlD3VNasiocyncUNZgaZQzd0bLZFFDkTED6mG+tTmP18/8Mts0RsjfPybb8BqVKxPjuaMy8VcQeduUeMcM/H5Ts3qz02KJg9cxZ0jEaFaM1DKh1LfbAwnx7pN0oOUgh3RZrJBMDaB3e86dA4ZJpQKXg6BhY8NrRXPoCrpXntzsjmhclcBP9TyVDZUJe4FH2fYnU2ruVkccOcr7pYhjC3GKyYwEpuP5unufRGcTEfQILEToNKXRJ72UiCVI/3XFWGlr/YS0/ZN3EProd8j0R/lnzO8RSkRYKQcb4viPa3uCm8rzw7uRp31udulxdJZcCerRPf8l6lOKIwc6QqJ4/VbMIG5RhK5RXuI4Vzd0qAyuCfp5UKFo97OlNYwcjgNEwrSJ7LTZCcycpNXvnlec82mfcy7/q2/52I/7cQtBp+vBSg8mlxPSJW8zNBOQ+CbJBUbWWJJroKBbJAAK6ePWve68uNIMXCOgLXJSLMN0MosYP8yV/tXGPbN0945Dvz0K8m7EtpOZl6Iv162EYGsJo+zGkn7pyRHwekqAgmgaT0RU0emeZBwsfeL2feTm63ImA6n27h05XuyoXf7ovrIHUGxL9inznIguWlT+i5AIRtaHmjiwWQlxC5tUzW3EIgujIt+MisLKC57vvakmQDqgePqRZ21JF8ua+yCv/Gxzpw63gvKKhvvksOlfDKoklzMKODYnv7l0AOjuqoeEq+VEtAA6y5mJIdEy+ZUw5uzzA
 WOv9slRZ
 KbPIb6ElwC91XrJ+hzvTIraSoTfbjFXk81CGAmTfIYSLQSrTz8XI+tML1xA3KXHFb0xXESfb+5xdFsebRITJMdT6rm78XVkimBtMg3N8kGe4/Eja2noD8R+j4MAtJZSFRkFeS9XmLTXNBJ+bvQwAPV4GjXpHyobFqP7fRZxGO//N8LfqzTZ5Rsti7/9GHz4R78O4p8yUnQLXjSvstGPiT5BFXS+edcmfhyNTqDu+mAoFeXgzO5wz/Kk47abJ+s+HtZvW0dO/jfs9JyMd/F4Ix1XxTEIxqxjzxczQ9dTACToa7jrqDCJnVW6p//Wlpj3CORNjQL2ewF+hPahFDZ6dRLMUsxxJEngsPgqwEdarnB7Xxs4fiI9PkVgbtqYMTXwEcP9xlLbKW68VMZ1yWeBxRTW0X0GGhhkgA62oCZv1BJTEfE/qzgePjyhc8L/cAPQVgP9Esxd8j5P6wCJqPsEN6V5FcOWmd1+tQ7TZ5khlSNs1nGVHAzCHrrmU8NLS/w3JFe/iG4VAmfwrnUgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following changes since commit 0048fbb4011ec55c32d3148b2cda56433f273375:

  Merge tag 'locking-futex-2025-12-10' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2025-12-10 17:21:30 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git tags/pull-fixes

for you to fetch changes up to e1b4c6a58304fd490124cc2b454d80edc786665c:

  shmem: fix recovery on rename failures (2025-12-16 00:57:29 -0500)

----------------------------------------------------------------
a couple of shmem rename fixes - recent regression from tree-in-dcache
series and older breakage from stable directory offsets stuff.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

----------------------------------------------------------------
Al Viro (2):
      shmem_whiteout(): fix regression from tree-in-dcache series
      shmem: fix recovery on rename failures

 fs/libfs.c         | 50 +++++++++++++++++++++-----------------------------
 include/linux/fs.h |  2 +-
 mm/shmem.c         | 32 ++++++++++++++------------------
 3 files changed, 36 insertions(+), 48 deletions(-)

