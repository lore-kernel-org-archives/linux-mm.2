Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1917160A262A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gUY10+qd
Received: by kanga.kvack.org (Postfix)
	id D06C36B05B7; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C110B6B05BA; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3B86B05BB; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF296B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A7D5C0774
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:37:02 +0000 (UTC)
X-FDA: 85397839884.07.6B25518
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 65388A0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:37:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gUY10+qd;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793806620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91rtiUe/bcG4k5Xjc7nZyZOJQYuQ+APASrUv58d3YCo=;
	b=RVj50dQkxDKYnhbokowqp2A8VX9WCkIBn1snvwf8/H1CLYEUs89eCVJih2BgKW0AIrmRgJ
	UtMSDBXCvQJ589r0+0rgsVBHsmYpAT+vNZ6WL7BUJ3+KMPk39DsLrBKpCkJTR9gkxOTE+X
	EQZefqM8fIBPR3HGksPS2KIOIrxcDcY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793806620;
	b=uB/WFLG8y7kFZC1TciP5eln3FZrUMGZviuvIFsEtVoK8Kahi+h+mLJOQCkAURjfI0OjZxM
	hYI9PkECOBjubkN5rELld2StLYDZPCwlIvYJ4khqc5t5mfOC5hFeNWp2xeudScWfuMYeWt
	X6Ixrzk44UX08RoF83RRxsNUx2LMTv4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gUY10+qd;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BAAAF410AE;
	Wed,  4 Nov 2026 15:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6289B1F00A15;
	Wed,  4 Nov 2026 15:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793806619;
	bh=91rtiUe/bcG4k5Xjc7nZyZOJQYuQ+APASrUv58d3YCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUY10+qdYkwl/0fqE1gyFkd9MkTXLhSDeGkXS3rTMVGYtMcqkhwFqOhQkEP8+BiXL
	 7vnLQSQ9iaXsYwC+3khwbLtJi0psWgJkts2NFZsqy1+J6kL0K+CkuXwJMnQGw3YbeV
	 GW7h2LQQ/hcOVvMDBFep6u2HIqkk/OIUAjtfIXUuqf/LjKRGTqRYIAZCHkWttKOAgp
	 S6SyEAiw9+FmkXhw/mHZA1c6eaelOUKJilh/6c5f/fG54ndQzm00UxxsxyxFNRLVSd
	 5rslerFt/RQ2EUCSAm+mX42mfs9uisUrpbIzgwyMqgSGRUvDtKKviytekeht5FtCTB
	 Toz6SewxQ+v5w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/4] Docs/mm/damon/design: update for age_ms damos core filter type
Date: Wed,  4 Nov 2026 07:36:42 -0800
Message-ID: <20261104153645.82945-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104153645.82945-1-sj@kernel.org>
References: <20261104153645.82945-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ddykgxbp8mmphekzmsimiqxr4o3nuyy3
X-Rspamd-Queue-Id: 65388A0003
X-Rspam-User: 
X-HE-Tag: 1793806620-73254
X-HE-Meta: U2FsdGVkX19TodE8syjjoP+yvymXc/HGrol8QXs3nek56GStOwscB2e0gfwZ0sDLAZI11exmI1czkdzO53jJQvujMIjUksr0x8vWztWrTfSril/LzmhVE7nXPwKXZx2vkWAARnKMbc38MDvBHEzd0dhQSo21xxeCgqxbt4mfeyY4LOb8XQr2XziQ6qkieDLsgGlN1q1v4dFRwsMeU6kp5yNNcAlO1Znl2xP1K8ZbKW1nVgiOlIL/NyPppUjP1oMTXbCvjlQUMs01NtAYUqE2+ai5vgOwewvyCGz31Kyxqz6hXWmqappFpf+hV3KnZbmwt9ckbvCjEsP6rCYAgcDoP5ApFN5g5fnX2x2p4f7DGaUlq141ouBleGa7nlciteD8xSSNUVvee6Ub+hJhexGkO+PhmWSEUFbYN9Py+XwJ9gS+0W08RGUEP6p4fRwCjbHopWxIRCKhv3HxL7OiCD+FUnkneo19/dGth06dXCt6hbTFJ93aspq0lxr4aMqID4/puqtV39YiHaR86BR3+9N6g+CobDCZLoNdwCmZU0yYMe8VWPMcz9sYFwmEwj64vQHP8PBBWQ0457m5RMvJvh+vpTFB5rT1eNUc3fjIsPyzrLcRnUDbYVWuIsf7CTYS8JE0PMxGKKJ0Ldbhdh6PnsNHkVHefTx3go/dnR2GurUI2xChcCj823KIu+ZWwF9R2PV3YB9AlGedol46ZuW0fwZTQYYi22GnwoW75H+Kbuo7Ex6fKtUk0LRJP2KlCd8LYQdx12tbxNAsoEE1icRfUkU5HEuedNebiyFZr358qlZviDn1ZYKjewV4M4XZyr+v0YfQ+wNS05M/ZAcN1kKDbRl2P8Foy3B33adEddlbHUgNUcDSQqIApDZ1yPqG5O2/G/GwnEgU4pRiLiB6L3uFrVo6jCFZNv9GMik410gAhx9CLo1RI8jB5t/FRnE2OKwH1Gh97fgrXBzF77r/YtChD/e
 TLfIedlW
 p3RPPC5aaAwR5qh1hm0AqLjdTpUCVJ507G27UXZG0c2N3Jl5R8Xjmwh6U4HSo9aciCGx3SjWG8tkB1PZUmrta3rLd8Tkv3Ja7ha0i4pXzdPk+S7LrQ6XSFtBoAqMrBHBV45y+3fBgJzIdS+pfhZbMPtBfSdIVTlUXKtUf4xPmgVTJ5m+JMsZyFBgVsY50I3OvPwadTby8P8OqXEynhXPG++rFpVW09Fv5sWwi+YiNZv32ExCxl0JDp8BOHr5A8z1UZLK0uZs47nr5eJHrDet7SX39/2XysRdHR1ASdRExTHyQYrtAuAZMjeQsgpbURyRfXF/d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design document for the newly added age_ms DAMOS core
filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 0689fd48446dc..8440c4954090e 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -838,6 +838,9 @@ Below ``type`` of filters are currently supported.
     - probe_hits_wsum
         - Matches to monitoring regions having a given range of :ref:`probe
           hits weighted sum <damon_design_attrs_only_monitoring>` value.
+    - age_ms
+        - Matces to monitoring regions having a given range of :ref:`age
+          <damon_design_age_tracking>` value in milliseconds.
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that contain data that are not stored in files.
-- 
2.47.3

