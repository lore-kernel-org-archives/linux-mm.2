Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA91F9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA656B008A; Tue, 14 Apr 2026 10:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1C86B0092; Tue, 14 Apr 2026 10:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F7F6B0093; Tue, 14 Apr 2026 10:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BCC96B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C940113ADB4
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:02 +0000 (UTC)
X-FDA: 84657380724.23.75A0927
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DFD382000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ne7QX6p4;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176640; a=rsa-sha256;
	cv=none;
	b=QXieMKRzN6UbudDlrMBQ34sDwU/uXMzHn22L9bcZoICFaleKrRxFhAUxyrhiMutA2kezFs
	JC6ydNNYB0TP/s3Ba0lYOaQkwGRA4LcdlEvYkFbONNLFnZzyZS0qm7Shn4Vy6hinLo72fa
	GyMZzTS66afiea/xjx95jglR7wrT+qI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALjUV2Rynz/UryiDLcLNpijVJfq0KYq3HBY3Kx7gqDs=;
	b=uhjDjEdB2FHn8xxhLBPn3+RaVPjoUy042XQTKlmMnFAo5NUwfQd1DboMkCUqoxjxKg/E8D
	JjrASMHxrZTCjBzkIHYBrxV7EbkJ2Dn9bCMlvhY28clTMDOlUDjnw9HwCzCQc3LMAxUj53
	t3h5sd+HELyMuNoKaPO8X9Wzo34jqfk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ne7QX6p4;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6458C60125;
	Tue, 14 Apr 2026 14:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0404C4AF0B;
	Tue, 14 Apr 2026 14:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176640;
	bh=D3Xb8PeTvLmTI+UVvNhEzjipl2DCTEFkVuBJpSK3e5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ne7QX6p4nh9f/KVkal6ql22E5r/yWYe9JHa7nSlxz3j6Ic+3FzQVmlFp+3vAuTlat
	 v0HqOSM0yhyjH6x1IQIW9w1yjn1IpsgQgDA/ke4oZiY/c7jkPkLvQfTXTCThogjp9c
	 ZZ3+3pIh/vV6BvtlvbyB+osol2DpabaFs7qIIRZHHN4zTEmevQYfc0MyFMUA4qppiy
	 sdM/Otrt5Eojdb4TREddxEgauSm1zgx3ntLtbVEHXfIQD7M+Bz89OCnyxFO+NHEVs6
	 XhYHb8/aDtAjTsZdr3Zbwz6M8YnRJuertzI2MGpRZHLYHmlPILZh/g6rUS8mxGV2eT
	 Hh2UjFnmMz96Q==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id CED13F4006B;
	Tue, 14 Apr 2026 10:23:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 14 Apr 2026 10:23:58 -0400
X-ME-Sender: <xms:_k3eaYmXrNrN-qr501zOHDvLusSEZrkoDcPvW9apto0ahi-91bljqQ>
    <xme:_k3eaez40MANzPpm30026fJ4PDz3487xgWxj9TEKvvM2fmiAib5Dg9Ql1qdH-EGrQ
    bxyM_XfPNKMvU9VFC49vbAR3DFmTmm4LIkTabJS0zeWN7cNi8IF1qg>
X-ME-Received: <xmr:_k3eabtWHaxRcRP1t_HLdqSd-Q6r5vaa2gb_6yQl3oZxbQxQy1v0GkAOlV40tQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpedfmfhirhihlhcu
    ufhhuhhtshgvmhgruhculdfovghtrgdmfdcuoehkrghssehkvghrnhgvlhdrohhrgheqne
    cuggftrfgrthhtvghrnhephfdujeefvdegkefffedvkeehkeekueevfedtleehgeetlefg
    feevveeukefhtdetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqddu
    ieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghessh
    hhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegu
    rghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhu
    rhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtgho
    mhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:_k3eabsnhOdE9eKCW0R68cYIHgOaEaZxDTCFAzAVBLPx25eeefpF3A>
    <xmx:_k3eaRnhuTNrXVfuV_mLnq6M8pGgr3R6DMaF_omhSOYQchz-nxaw-w>
    <xmx:_k3eaRslP7TT9Rcx3n0gDnpay90f8thXQ4qARLyxXIiEqh_TLbKebw>
    <xmx:_k3eaQNXaUwZz4ioIGby9lE2uyqI55Lashhrx0c0ggrmizG6SCA2Yg>
    <xmx:_k3eaS0NztkyBvinGJLL4VbWZxe8tP2fhhjcyGW5Tm0TQzPqLjo0RaBw>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 10:23:58 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC, PATCH 01/12] userfaultfd: define UAPI constants for anonymous minor faults
Date: Tue, 14 Apr 2026 15:23:35 +0100
Message-ID: <20260414142354.1465950-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260414142354.1465950-1-kas@kernel.org>
References: <20260414142354.1465950-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFD382000E
X-Stat-Signature: 7jtg7qwxmfxjqc68drs7bxxwcbnkrows
X-HE-Tag: 1776176640-547121
X-HE-Meta: U2FsdGVkX19/wtgk2f4onUbbqHXamYad1gsQobaPlbNNyc1+mGUB8ENY9WBlr332n7dHnc3e2Rn5QIyOhWAJWa3SvoHxMvx3MwXdabQrmyIBoFdqRflJk9VZVPsmSHjDhJy+8kf8pEGYPRPgrlx3oAFgcWyKWNOk3hR+nRLnkFPe1El7yRAUWduy1uqz5nAhNUMDiSP+sRSASeAXwSD6uFCvZZfXqsKnL4Lq+EUcD4XH/kroqGjhBVzQ1Wmd7mAk2Mr++0xbF9+T5EAayVeARl0JgHLaYtsHhIQuvarXc/QRXKxykoERU7t0Z62OXgdl7jO3UR1fS42iSxIZUgU+mBMGFRnls5GZVS6Z+Ro+to9PtJBwNoxQP6pr6nBtITBFSJs9iZCr3MYLv/9AgHWNCjIhtUlBTNJifCCpvuNbsupRgCcXc1DnQT4jegBdgmsGb1OvZOhHHt80zv0LKppEa4MGawjF0yjyiEE9O886/2nE253QgV0IeabJA/y9CE82jHV8TuBNO6N9ADlwQCgCWmtZ7SXMv9aPlM97JWfc8KnLiBNybl0k3mn2u2gm02dBhbJD/9+2KakRCDUh7UhLQx1UXYaVYsAyPlw8Hmcpvp+1Y/fe+fsaep72P4oo2nod/7tm7p+/XCvriaEz31JT9wjJgC1l3cji/chp9OsL5TaYGKd0KzXfoEOaAUEHlKkrnu0eIFzup6siCTqHy6tnp9T8t7EarqQzb9lO3E8h73myXoomUl9RJfZo1P5EBqmXDAuMNj3iSC7MzkXgYNrFRhRp6EYx8y+iOf7c7nWyyuvlFl3fuzp3Vyq+mRIDggrnQXiJcmt7LThW2O3eFMZf6yT2jjZDFWOMfrW21r7CuBMG9whZkSg9ClEoql//q/c3mTDpIiD9uh+NiWh1Z/u3Ij+gtKi5nKQduaiVGLQe8Ud4LLqFLkdfwm/MhGLCen0ndihEjczWWAQ+tSdum5S
 8+VZGeq5
 Jcf9byJpdbmRWXDs7fodogz7ulQ+8JbC0+atXVN+f1McOat6KWJ4Nzyel1X+GPSvrKBASo7Jgc9KsEkdqFd5i3t/m8vhGfu35j/0IKhls0zzSMcD4KvJaaOxkgemYSM1Td0FwiCGRwVZiUkYqj7O04Md/heYqeJ0bTZoPGtk1+PjG8Ci9z4JfDZP3cmndX1mi58dq8Jit8VKOIKUVhED6OU+H/RiV4P3tKGJ5W0WW59iwjA+TMJcB22PDpEOJkHzc2Rjs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add UAPI definitions for userfaultfd working set tracking on anonymous
memory:

- UFFD_FEATURE_MINOR_ANON: minor fault support for anonymous memory
- UFFD_FEATURE_MINOR_ASYNC: auto-resolve minor faults without handler
- UFFDIO_DEACTIVATE: mark pages as deactivated (protnone or PTE zap)

Not yet added to UFFD_API_FEATURES or UFFD_API_RANGE_IOCTLS.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 include/uapi/linux/userfaultfd.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 2841e4ea8f2c..336d07e1b6de 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -79,6 +79,7 @@
 #define _UFFDIO_WRITEPROTECT		(0x06)
 #define _UFFDIO_CONTINUE		(0x07)
 #define _UFFDIO_POISON			(0x08)
+#define _UFFDIO_DEACTIVATE		(0x09)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -103,6 +104,8 @@
 				      struct uffdio_continue)
 #define UFFDIO_POISON		_IOWR(UFFDIO, _UFFDIO_POISON, \
 				      struct uffdio_poison)
+#define UFFDIO_DEACTIVATE	_IOR(UFFDIO, _UFFDIO_DEACTIVATE,	\
+				     struct uffdio_range)
 
 /* read() structure */
 struct uffd_msg {
@@ -230,6 +233,18 @@ struct uffdio_api {
 	 *
 	 * UFFD_FEATURE_MOVE indicates that the kernel supports moving an
 	 * existing page contents from userspace.
+	 *
+	 * UFFD_FEATURE_MINOR_ANON indicates that minor fault interception
+	 * is supported for anonymous private memory.  Pages are made
+	 * inaccessible via UFFDIO_DEACTIVATE (sets PROT_NONE while
+	 * preserving the page) and faults are delivered when the pages
+	 * are re-accessed.
+	 *
+	 * UFFD_FEATURE_MINOR_ASYNC indicates asynchronous minor fault
+	 * mode.  When set, faults on deactivated pages are auto-resolved
+	 * by the kernel (PTE permissions restored immediately) without
+	 * delivering a message to the userfaultfd handler.  Use
+	 * PAGEMAP_SCAN to find pages that were not re-accessed.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -248,6 +263,8 @@ struct uffdio_api {
 #define UFFD_FEATURE_POISON			(1<<14)
 #define UFFD_FEATURE_WP_ASYNC			(1<<15)
 #define UFFD_FEATURE_MOVE			(1<<16)
+#define UFFD_FEATURE_MINOR_ANON			(1<<17)
+#define UFFD_FEATURE_MINOR_ASYNC		(1<<18)
 	__u64 features;
 
 	__u64 ioctls;
-- 
2.51.2


