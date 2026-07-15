Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B458CC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753896B009F; Wed, 15 Jul 2026 10:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7047F6B00A0; Wed, 15 Jul 2026 10:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF2E6B00A3; Wed, 15 Jul 2026 10:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E68A6B009F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:42:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92563140118
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:42:39 +0000 (UTC)
X-FDA: 84991277238.02.5261B19
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf09.hostedemail.com (Postfix) with ESMTP id BC07B140009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:42:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=zoyBLhW8;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=oLTF8C6b;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784126557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O4fAs88PU8PfSDLqf7jj03THLume/iu33/P+wiz3f2I=;
	b=oaXo5Fn9cXSx5UySPTyJ2zEt1Hr4PIPJQnsMsSsfkwF/8p2z79TfxzTT3gbJ0/PTFeEE9B
	Or2/RoOfdARR2IQFC46DKvRC++WKFDHiN5KT935topf5rRecSw71sQo4PHcxU6ipAVEMdL
	hAMgMnK7SX1YXkrBZ3K6Eql98+t34So=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=zoyBLhW8;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=oLTF8C6b;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784126557;
	b=CwuS9uVWyE/cfmVyT3Vwf/cQWda97um7QmfwhWx1jW2Gd9QBf9c274qiR6IW8QPLU0VJLH
	00xmesqL9yRHZ5acfG7EfvMhiQZlcGy3PeITQ6wi28/oHTg6tngos7sm2VMwORQMqeL96l
	gcgynal69gP/GemjC9VcwmoECa1OpDk=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 855837A0086;
	Wed, 15 Jul 2026 10:42:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 15 Jul 2026 10:42:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1784126556; x=1784212956; bh=O4fAs88PU8
	PfSDLqf7jj03THLume/iu33/P+wiz3f2I=; b=zoyBLhW8Dyb63VF18W2n5sJeVh
	2DkBdw62n9c7peMRioObqRsMJU+binOkxO4ATRTwwvJVw5HlQSGeYzRA52iUOQR8
	lLZZlN2vGT/8ipr2gR8CsUAHa+V53sIu/6H5pommo/yfCYLe7uApOfz4Js7KLlQh
	ermSCm0NnmWm6tRbt3Xc3MU5yd2uPLLGu0rNyOnYxPhgvSSYXN+x5Jox9YN4P7B2
	YTLkyBQM9S1m1P1RbPdRtSgIvOBg1+e3+G1+OZf0+fH3EaZNcAO9ARDtCBaJ+OUw
	KRPC/ppPaW4T49TV7T82TIgT0ZBSu0M5Hva/3wVDhW1RBzkppiFz8TVRq/6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784126556; x=1784212956; bh=O4fAs88PU8PfSDLqf7jj03THLume/iu33/P
	+wiz3f2I=; b=oLTF8C6bdjQWAfFZq5MjRbcBj9Q62IwxoUS9hdu6dk7fFXISb4i
	G4iYf25B8xBYVBYk9TIUOWTHiqZ72QGdCM2eBFN/I9mRaQtAuVK1wy5cEIpcH/iQ
	ixrnKvDEAhHJ/ajGzgaMdy3t5czVdLK+91KrPvpsEN0NqzZB83mHOp4hVz5RWWWh
	btxJBqPxQXDkGLYaIQRAZVseyN9o37c+ws0tbsb9GE6UZwgT7T49E+GVPF+MbkHM
	zYH86qb6UrQZh2dpUnuyEm6c+Te9i0+N4XC/PLtaduiBq3Iac7ckyiVYEEwCxwcc
	Jz1JHnb2v3L1wjqGbbyx3kah1nwbL284vnQ==
X-ME-Sender: <xms:XJxXajmxfaRO-iqmHoYzg9lFDhU-5Gl9Yxt50tAsvQGE1dhDlmEYyg>
    <xme:XJxXaiv6TKEpB-JrY1NnSvEkUGf-mWGKH4Z34CLQfzl3lVRN6o5HDDeN77Xg5Gue_
    FqBlcYraZQaZh7TV3QmXhWm0lEEqTrv-f32JLckdi6xAJ0pDRxRJt4n>
X-ME-Received: <xmr:XJxXalINQckga0XBIco3o1De2T63ZqD-FKkkkwHQU6dPLUXdRbs5wzJOiASasA>
X-ME-Proxy-Cause: dmFkZTEG1jEV0FcsqtAU48Y3TLxFVDgAUFXicFOqtxZWeQi2NNrOkI/0gy+tQRavLR9UFO
    00xLocveBGJCh8tsP0C0qGuOeiDfcfpgGVloAAwET/E3i817oggIs66tBP/lKoY49rvJKm
    iF5Opm3WbNBDLwR3ZymnFRYNzURG+ejz8yI+XnG8zGyH7SQf89KyMoJN1j/EMv5UGsfED2
    13EXmDiswQfIlvflUVH2dr5ATUu7WR6leXGCw2aVd64eSyDTEGWT4vsmLRaoe6y5PWOPfz
    ZYnw4YoYqOhkJgBryC2cXYoZ5QveER5whbamXQnbUQQQL9jkfAJPw0Ag+P75n4TGjCJAD2
    DGjA61sdAIufyWsv8Hu4W/mNNyjAY9oODIe/mLrq1KjReVi1y4w1dntGazIhBl0DcPre9F
    2jfEUSdJHkyBHn2GOC7O0Pp98I6vFRIvJOgZs+iIuavEK1QHTFXniOC7WbZwgmd5lQvinG
    DuSHavyv+3u4uRLwKODRINgvOSDBeNpmI0EUPfU+y93qElAgQkx9iukyVT8wKitbtX+9E4
    xrJ1QV0xNDHvTxUS5jwqQWLDPRLsDlhUhPNpj3CE4dWhupKZN6A+JsnAyaoJhPeacBQt5L
    eVsW0oeqz45uB60b+AsSMkRyfKxN5Zf+BwWoMEf4FIRVR2tLmek9nTet5CfQ
X-ME-Proxy: <xmx:XJxXavhBtdll9C2IFgRq_8XwOc2zAQKJ_0xU4fn41HiWLMMcr_vKDQ>
    <xmx:XJxXapuffedjRT2JcnVC0seRXAVsmzpc7UHfjvzv9EvOkrskAa37VQ>
    <xmx:XJxXapjNIbvQxwM6iAq9IhcnCb80x62lgpwcMHC6iw9Rgyg0yxkZcw>
    <xmx:XJxXakc7BW4Nyp5gOi5w1OC-AygmGyb3Xj4vgWRZXiN9LnVL3tVz8Q>
    <xmx:XJxXas7qJyYIYaYEP3ScfB6UaH9852M7eRCPdkxqqkLzfeqY8B2CyH8L>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Jul 2026 10:42:35 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org
Cc: usama.anjum@arm.com,
	peterx@redhat.com,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	david@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	zenghui.yu@linux.dev,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 0/2] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
Date: Wed, 15 Jul 2026 15:42:32 +0100
Message-ID: <20260715144234.442721-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bx3tw4x43jzutk6mqr4sba3duaaznnkm
X-Rspamd-Queue-Id: BC07B140009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784126557-874750
X-HE-Meta: U2FsdGVkX1/Gd92BNwS4y52NS6nLiHK484cXVs1G0FoZaJ6/Dn3IB5gSrNNK2xJoq9njnLO88P4+LreQxUbX+kigtN3WSfeZup24u43G/KKJcTpEJv2oMiO/L0BA1GxAW/ZNtol4SOTRuZvZsI28bGtWc43rBnjkelzuJ/XtnGDO5qDSrOg7LL2z0flGuJB2PGsEPd5HHYYzpM00eFtHFnZiHR0qzPwALqpVSWChwTh+8Ys2y6yLy2lnpsIQdvRn/UHor1Aea/bFFLTu2P30FGdrLf13ln4s/N11cltxHoYiq8AxSsQyoGKBWeLP63WxR1EOff8TLIMSKWtQJk1nWzNbrYDYgwM4MHEoSCS6Ui0dclFEcGzTVZ01NWaOq1F+htd5CkWccbvToXeeY/P4WKIAIFd1U4oWKX9AEu99eZvz0YktqLGpp562WflSBoSbY3ltLwxqof8JhG1vLhGc2jWMZ9ry376HDO6Gri6wlZuvZBA7GXq6zl4HML2T/jKMKHdPjEiVVUDZqsp6o0e3qe2KlGSQB82aOHPJPgVfYsgGUZhVANvOQsCR7Or1yRUbnK7EPe7Xza/DaZwHU2ZYY2krQgrZMqrXkMTZKRKBQ3sYxeqBVIoh+H5WD1qUCEYiiSvMbWL1vghFFDdNIyvB4v35ZJ2TFgiCec6YZ8Eo8eE64FSZRkfKebFv7yrzQNyvZB7VpXllXV1j7DiqnWBC7/uLSxO38DY5RyzisFQ6NhJQ5ATkA/7thPm6ZoL2aTaxVUhUGfvCVTqp9VE2GfaiFbtsKpEJUqKc89Hgb3LxSsP9eVpnpKcvya8L6+P2+DN4/g0V8tLCmnDeo/IBeeRHXOSlzDNS/89A0Ef9MAAavtc+ytRxwtWsAOyQMs84eZUq/MEk2MNsE+RxsKo0gQFggDeOnsxjGsXl0ImZbAMf/t4rE/QahIMDs2BkaL7JLtfTEnezclTjPLg24omHRzx
 FFLqVM1/
 YalgDZB6zPrYuKiPAqP7HMckfUAfc0nMwzNX3VaKTICk6JkSgQVtUvPXwqWAlz5tKWRo8mS25klurA2YUn4L9o7YD/DYOHXmqsp6KNvvN+TruH2qTfk+690KdrIiz95KND0EVQavgeL9PYFUIPJ4eW/vFhvGjF8D+mdCv7P54EFug5JhyCZoMJMOiNLaCWBLg8dmXMkLFzxHpKz1M+Mgzp+tKODwSMlcPkyqRsnxQwkPe95s5+oRjP2zuOZZFgVEbwKHpPHeuQFKd6iOlXWwBkLjMmo9XzI4WlW8dNqD7vQv4N3m3qIcV/nEosNfavbmbkF84GuNhU3e+JT5ZROCjJxaraUXh5BLtQOYPTv6Gz0crPO45iCUg+eaOWi00oL4r9b/bbu9XoJYdfxuE1GZAk+Jq62Do8b0M6Nf+CoDblIKTVeYkvmtbYXrSfmWDVCF5/hZr11IHw2yBCO4N8nENidKLUoXz8BA/9o6z7oq55tHHGg3P5wnnGq0Cgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Patch 1 fixes PAGEMAP_SCAN reporting a PMD hole in a uffd-wp VMA as
not-written (Cc stable). Patch 2 adds the selftest, split out so it is
not backported.

Changes since v4 [1], addressing David's review:
  - Split the selftest into a separate patch (2/2); only the fix (1/2)
    is Cc stable.
  - Rework the commit message and shorten the code comment.
  - Rework the test: mirror unpopulated_scan_test(), skip-and-continue
    on setup failure, rename to unpopulated_thp_scan_test().

[1] https://lore.kernel.org/all/20260713091710.206548-1-kirill@shutemov.name/

Kiryl Shutsemau (Meta) (2):
  fs/proc/task_mmu: fix PAGEMAP_SCAN written state for PMD holes
  selftests/mm: add PAGEMAP_SCAN test for THP PMD holes

 fs/proc/task_mmu.c                         | 20 ++++++-
 tools/testing/selftests/mm/pagemap_ioctl.c | 66 +++++++++++++++++++++-
 2 files changed, 83 insertions(+), 3 deletions(-)


base-commit: 9795ad96d277c4af049fe30de1cebd4e39d7bcbe
-- 
2.54.0


