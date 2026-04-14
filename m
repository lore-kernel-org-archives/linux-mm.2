Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B7B5F9D0D2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F916B009D; Tue, 14 Apr 2026 10:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17606B009E; Tue, 14 Apr 2026 10:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D069E6B009F; Tue, 14 Apr 2026 10:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BFD716B009D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 692F0140533
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:15 +0000 (UTC)
X-FDA: 84657381270.06.464B69C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 421FE180004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=smzIiwzk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjuAb2sBTEecRgqJJVTbLy/JxfVLElQUqQ241D6figg=;
	b=C+ZT8AgjpGZrOCyLgQHW2N7UGwlJBVAFvNB2bKfKhA16iG9KlpuM2xkg4Sn3aiSZx/ouUM
	+P5y1gt3xSip1XjCZolh8RwbPijJjnjQkN9mhwyKukrwrfqOQCv95/JUFtT/h9xlo3u0n5
	BsmNZTsVne/CziSp2Xj+JG/ojQnwH1c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176653; a=rsa-sha256;
	cv=none;
	b=V537QZa3PuO4WNmEWqDRXutcZCR0G+wQMsxCN3yDjVxSCtcFxQSCbeR5zkgLk07s7OU4c0
	K5z3cAUhUYaCGWH5Gjs2BISL5KHfZy3jjxE846QAc+vLoFGM65J5D3G0lgDTkfL0n0joMb
	/QjtczI9bTCZq0xZSVDaDCBpiD+P/bc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=smzIiwzk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 654D1409A9;
	Tue, 14 Apr 2026 14:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE429C4AF0B;
	Tue, 14 Apr 2026 14:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176652;
	bh=bdNn47+Nx91eslEieZ286KWtw/tnSdy4Rxa/tQlVFSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smzIiwzkviWVR7lnj73JVWnCQ+zBpvJCTqLUI3rfAoHi80IfNutFZUb982WabLJdp
	 RV1EHtoV0XM8U5Lvh6R6BERnAHbxeaIWOyOTq1r1cgtn4s17TLEIXC4Czy1xUKl5/N
	 zmzLM2Ig+HUpqpMApLtLHsYyinprvvb5thjin3NmUf4IqX94OWT09zuu8KXP9bmTPB
	 0h3kNPAZ2HcYJCbuRfx63vGGdEnfLqOOYWavV5a2qtXHfA7mYS1UxHoDAbRR9ZLYLw
	 D0I5zhRWXTgJDj0qq2R7C5PShhH88aEmokXZzPaoA1H0sftf5qJ2BSXT5I4nA8ZBZJ
	 LNaGsT5Zhu3Ng==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id DF7A6F40068;
	Tue, 14 Apr 2026 10:24:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 14 Apr 2026 10:24:10 -0400
X-ME-Sender: <xms:Ck7eaVIlxL6gOMHnrotiu1Aq2wA_g2vVcrpAXkPVT6yYDcz0V3RS5w>
    <xme:Ck7eaYHthgumh1dkOCOzDnRilG70A9ktdRrDr3hP5Sd3rh2AUmzhloqbv9NAe3GQ1
    hqceh6DORm9RS_eebYzCXgUboVCRIXfsO7vxbuP_Fgh5d0aVhfLHvU>
X-ME-Received: <xmr:Ck7eaSxYsKTSd-N2Uvwi9HwB9SGKN-1eMU-nLf7guVhKn0slOdMJQm5IE5PF0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpedfmfhirhihlhcu
    ufhhuhhtshgvmhgruhculdfovghtrgdmfdcuoehkrghssehkvghrnhgvlhdrohhrgheqne
    cuggftrfgrthhtvghrnhephfdujeefvdegkefffedvkeehkeekueevfedtleehgeetlefg
    feevveeukefhtdetnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
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
X-ME-Proxy: <xmx:Ck7eadhKkyMSHzEZVrk8qVizVP-x_HMDg3Ml2GcB9nOmIqgN2x1tAw>
    <xmx:Ck7eaXLic-Q5TKN6jkpmkLTrh_zTVGW9-0YwrimJQp29TkHP6kjeAw>
    <xmx:Ck7eaQCus3xC9UxalN-U84MZRkTX50MHGVg9Pyo5DkPAYMTJQSEZWA>
    <xmx:Ck7eaYReISLLG7mEHLpRZRqQ5XjeqE4JrodK7dWh4MhDS6RYM6V6Fw>
    <xmx:Ck7eaRol0_iVa8IN7w3Vs3Gzyv1QZl9rkUikTVZnrTUcVY9I-PSC24Fs>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 10:24:10 -0400 (EDT)
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
Subject: [RFC, PATCH 08/12] userfaultfd: enable UFFD_FEATURE_MINOR_ANON
Date: Tue, 14 Apr 2026 15:23:42 +0100
Message-ID: <20260414142354.1465950-9-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260414142354.1465950-1-kas@kernel.org>
References: <20260414142354.1465950-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 421FE180004
X-Stat-Signature: 86obpcnjdrmpjo8e6codct686uj4bfeq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776176653-777851
X-HE-Meta: U2FsdGVkX18ZeXK7czwLBRIYoHteceMBKCXoZM9OfQrmMWBwVGJfbpPdMLSwDsRTyAZQSt/MLT5b2EXKoVHe6oq5bAKFgfeiKTIe+U3G0csHGVh9qvF0ec9NEim41xkQI0zvsG9y7cOgA2SGZXUJCIgZ/pNtgzaWW8bpbhEu4i0tx89rMselD9vFBsB5flM5EAx9P8Ukm8EgZ/RbjCeVp+HC0G7zVFzm8R13Pc7lyhCXv8qdqNteljV6eLRm9iOk0FU25nJQbrV8s2Of2lhClx61PX9wxRUAe+NhI3jPU8IJ6psB1Ba4GLiG+Ilbhly0LU78IFCbX78StQAYLx3JE2VadnWtywp+H0tni/g9/e7AZmbII7Ev/1dmWvWKksW7QYS+A2h+JlFdTv3lO4N0n40xrIk6pxuATC5SHRc2e+/UfIlLmouZD4P3jN5m5AcwLwcDf3/Qhih+AYcVxupBOz0lmHXsmQxvQTUlhj/n0fmY7Fex4G2zetFrd4Vuqx73ubPg4jDAV7PyeJKkW3CuMMC/joKPvleZVj/7KY4QviIitiRy1wt86G9MojzvOMagE0Tc0TIAWYldLHF2UDge1XtOSWARJQz0cxjkMnWXCzOf8sT1uDLnAwMKJoo4kXirJUydJGD7nWEUsbK//NTOm/qrGw9dyp+7DEoabsP7UtNk+apNuHvYoThISkTw/BsJE2md6qpKW9g+IFnWFHggh0MVAX7dGeRHxtHUPqRiC8WmURztzOyeq80RWpsAyJgZZi1imS4a9gdcNKhdWlHXb8lgNUN1j5Uj1pL88m/7uxM7W/K6YvtmjlFj/TdViMPVSXJFwo8cxjGqxNeIE7QBcUj2/cv6TC5iLp/zffP0tLkpGtywkERXxIfBOUGMPuBckuP6BBEnkHNQp5f8TbsqV1Ph/wsEQg2xdlK+5q7EsbcXlAGDByAF9WrcAZeLxGAJtPlh40KKBsvmb6p8Mk/
 AvRImRdk
 PBc5N53OYIxyJZQVElrMN0acUwjamvIzD0/10BZaKVt5Q8Wmt2iwyfuQ5Z/NP0SacdLqR4JbE13up1doMB2TwHlOj6g7jd8yxPZV/bk5HdZHZMmUAhCW9EHahnpppnAi9xpliekquRu6+blV2fe6FhWp7OPP7rea2b8yVqKa0O7m1TFsILNEKbC2sWPSWwax8i12ZJY7yy1dI+7jjugO0jS63lxwEuI9yOPb+rF+qRk3PlJGOXU+NBQvjV6neVQJyXCqQqWgyNZDrJcDrfDGItOxdS9NngZl/8yk4Fo4CzeSGdcfnJ1n4OxUwkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add UFFD_FEATURE_MINOR_ANON, UFFD_FEATURE_MINOR_ASYNC to
UFFD_API_FEATURES and UFFDIO_DEACTIVATE to UFFD_API_RANGE_IOCTLS.
The feature is now available to userspace.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 include/uapi/linux/userfaultfd.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 336d07e1b6de..775825da2596 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -42,7 +42,9 @@
 			   UFFD_FEATURE_WP_UNPOPULATED |	\
 			   UFFD_FEATURE_POISON |		\
 			   UFFD_FEATURE_WP_ASYNC |		\
-			   UFFD_FEATURE_MOVE)
+			   UFFD_FEATURE_MOVE |			\
+			   UFFD_FEATURE_MINOR_ANON |		\
+			   UFFD_FEATURE_MINOR_ASYNC)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -54,13 +56,15 @@
 	 (__u64)1 << _UFFDIO_MOVE |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
-	 (__u64)1 << _UFFDIO_POISON)
+	 (__u64)1 << _UFFDIO_POISON |		\
+	 (__u64)1 << _UFFDIO_DEACTIVATE)
 #define UFFD_API_RANGE_IOCTLS_BASIC		\
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
-	 (__u64)1 << _UFFDIO_POISON)
+	 (__u64)1 << _UFFDIO_POISON |		\
+	 (__u64)1 << _UFFDIO_DEACTIVATE)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
-- 
2.51.2


