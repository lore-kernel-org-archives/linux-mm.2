Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2992C606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=X0odV7QN
Received: by kanga.kvack.org (Postfix)
	id F37346B05C4; Mon, 26 Oct 2026 22:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0EDA6B05C5; Mon, 26 Oct 2026 22:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E249C6B05C6; Mon, 26 Oct 2026 22:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACFC16B05C4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:57:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0548F4091D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:05 +0000 (UTC)
X-FDA: 85366894410.14.8118E69
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf25.hostedemail.com (Postfix) with ESMTP id 39B2AA0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X0odV7QN;
	spf=pass (imf25.hostedemail.com: domain of 3_RLgag0KCAImgxkpnqwijnkpiqqing.eqonkpwz-oomxcem.qti@flex--kevinloughlin.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3_RLgag0KCAImgxkpnqwijnkpiqqing.eqonkpwz-oomxcem.qti@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069823;
	b=LXi6NFdmiLy9RnkwvnKqDFqLa3AS177fRpwWzSdnSrHG9HmANk32dEwYmeEBHj2lC6Ylsg
	V1Kgx8YyfbZOz3tZO51vGvJjJ999EQlS5egX1KJXh8HeLsATiiZDf/wKMvbmYtD+nKXcT1
	GilRtYNYHSuJWj0zukbCfrrywykLOZg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X0odV7QN;
	spf=pass (imf25.hostedemail.com: domain of 3_RLgag0KCAImgxkpnqwijnkpiqqing.eqonkpwz-oomxcem.qti@flex--kevinloughlin.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3_RLgag0KCAImgxkpnqwijnkpiqqing.eqonkpwz-oomxcem.qti@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dhD+kOKqUQOH4NXaqpvq7snu+OHZ+U62/aV76eABXw=;
	b=AZBrLnlXlD2Pi0XqOKkMapWJmsNwK3Rwj9ICYZowG8RQX40Q7pe+BQ88FlIpLQmkEP3aou
	K2Dj6qpKb9VpXyRrxYxO0Qr5tRuzY0Qf09gR3v96l0RMehrlNzDJbIfqBPe6bKekKFDU92
	Ko4hKh4FCVI2X8zWOtRGz7uMzWbLVkI=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ea2c058e67so6006819b6e.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069822; x=1793674622; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0dhD+kOKqUQOH4NXaqpvq7snu+OHZ+U62/aV76eABXw=;
        b=X0odV7QNFcDIxdl42lwIrSpGGNzgOK16V4/Q7w18jX2o44Mwlw7EYLzLIRpD4T0VT2
         kb3OpNrwwGXy02kWx9o/ffegHA8rMhZPhatpw2Ks5ALXHaGFUsEjQg+h4aLZX8TUlajG
         BbG315PoeQm7beT9M6qcxrMoeX94KoUW7Rhe0j1yZ4rI6n0anIO2NLjjkIewMktUAwlN
         ZOKaJObbsJLpxBHkMZXiJh/wILUovmdW8ma//g6u52z2omREgtrAMPifcgcpg7uP4AX4
         BWvRP9Zv0ZApx16G3dbURYe5lqviGow7oco66QsDhbYgSrSvLNlPgbMQWif2Kb0Bd5Uk
         uxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069822; x=1793674622;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0dhD+kOKqUQOH4NXaqpvq7snu+OHZ+U62/aV76eABXw=;
        b=ZUv+eZwlu5hV0cKF0nadj9hCkcB25n15kHRwpQqtXKkZXCFP7q7/hsbbmv2uQWbtG+
         KDH3BBRdDxHTK5mjl5r6bMy4fLIBlMWaAr6+WnSm1ErxWx9kni0sp+9DGOg+RG30OEMJ
         QyR40L3ufr1bEr29TLudSe2mSHCdRsT5+A4u2cQ7JhUBHjJvu0ykQj1m6mDOhrMrMZbT
         9BbpQbDbcsVwGExdOE4TuBq0p2jb02W0/y5byE7XdihtNsxl/UWPz6heJHM2k2Gq+WZv
         09Q2h/k02NJK1Z7n7+isly4jVVdtBlFatOab7bmKLSEhJDGFRoOjpcIorIe6wN4zJtXM
         wrNg==
X-Forwarded-Encrypted: i=1; AKwUvBxVcNGzOswKfLAVEqfHC47p2z35wr3erJdMDhZyMeh8aaHu0ZOo8aIexYCltvalykCviJqXnPx+5g==@kvack.org
X-Gm-Message-State: AFq9FYIfde/O5ALHke/q8JmOL26sVZwqXjrdGGMY7AI4QAu58qhsgOm6
	zuLGTc6ES5p+WJJbVpyjNKw5FKZtLF5uQCOmnsODhhpGYRg3xorr5HbJHtSywcd6VQaoMPnADCw
	C1PfLOz2hj3sIqIos1qupBX2J6ex/UNzZ2w==
X-Received: from jacnq31-n1.prod.google.com ([2002:a05:6638:e21f:10b0:61c:8e68:e95d])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c1c4:b0:4c7:7ce5:a32a with SMTP id 5614622812f47-55bfff7e470mr5562520b6e.4.1793069821819;
 Mon, 26 Oct 2026 19:57:01 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:16 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-14-kevinloughlin@google.com>
Subject: [PATCH 13/13] virtio_balloon: enforce ACCESS_PLATFORM in CoCo
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 39B2AA0005
X-Stat-Signature: 1r9sqeukr3d8pmcwcmpmfrbn1zrk44qu
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793069823-800606
X-HE-Meta: U2FsdGVkX1+G+laQamYaPi8LUHgTSxsEj8fIl+v63nPXL0AQSO+PtMU3CtSfKca2zd1tpdEgeJ6xMBpcVo3eWkpWxN1kDdaM92i1V2uIXJB9LIxTnDsJAd4ZdX/0nijjCB5x4dOjv42CVtZJ/IwlIFLpPodlt4GLcNOPwV5l42pagQLLoAkSSFsVeSrQAeAodeGh5iY60IaACXmWZK5NeVnGMBLcvY6StZPG3/GurzyWfZFOFlE0rIYLayzHEmk1NrX9/KISzIccSAnFjpO5SDLntoxCASmm4TBjQui+cCM4CigurCe4EZdxK48oQXOw1eVcyiOWsf2ShoMDQs0m9/XFK01fc3tYJGrhepjq4K/O9AC26kATnRZ2z2o/uh3M4d04YyyVx9E3px2SwMPg3PJikADkeXcLtt+drxnRIObb2IBVuLJDYkSKlTegp7LC4tJTcJP2hwGuPSVKsP7Q6QEkjZ1ssNt9NHDBY1U5XFzo4axRnmr9/N1rcl/FbV+754V32BAPgDC20LbwU/L6ADp7R7JgxDgDXJb4u9AHGhm5ZqlN5vSNBBZFkLCQLWj5T5AIt5nKQSWxuhKmVp8wuFB4Jrz7kOwwJY+qQeHFFfC1ztX1w4cZ7Njs0+8B0MIcr1P6OrzOXkxx+3MoD0PkwMO6zYv3IzG2PWVzfyEZW0Q1VK1mC4G4xNZP/sUu+f6JFGasTM1xOWqGPLsQyzK0Ejkqu6Du0bOKMDREhu52Sskjs+L+UjsP1FRq8SnnJEIpsNtQEw+ZoNWa14UCV7S+Wqox5OUrJfUVIqNNNH/zGZ6DXDrTweb/1MxRaqkjYur0w0YG4jU/ViKP4J9BKGE8vu8DDrcNybhll5MEeF21wuzOBMTku/QAlb6AxBSnzrASJ67IN2mHq1XDfwivz6u/0NBP19O2hluXsvqEWdr3dw0uMfBqlaTcGSyxzt7F7jMvW7E3Ub8/sBxWpFhVSWj
 kzxSTvhX
 OOJ37C0jFT0aigg/QH7t08NWiOkul+AwUJreg7ZmiTHhgmMhDOS0PYnBX3ZULc4M4+Ccq4SBw/GGlwhT9LcV7OSMjgLrOK+ZYQ3KJfiFF+5a93FNda+IMP55bvG3ZgRQ7HqEThlLPKOYlRRnZpKFxG23ggkv6omf1o17j764kBZpVuJ177Jz1g2zvEnWdR88iMbsAolFOYUUcsApxWDj+2laOXXbr0eaHTE9taRF7gHhxF9EUlebGz6bm9lJK9EJ4bySf8HtDUOBFBDwj7wz3HALqaQw0JH4Gmc6CtQUKldod+dqTzgx/WUkzLNRTZEtl7kxcnbdlC5L77f4u83+FkrIHNuLU8Vs1EVr5XMCU2LPi1nwFg4On17mMkSP1PJN7IRh5FJVOZUKqkm6S/Ij9om7ZmqoURrA3oSYJjgCIoR88rNFwrgWZOb/8/AfFdguQoVi0vBaH97uIBKJwlRbINhCUnhtnemb7tm39LmT3Pt2rX0oKwFhidlEDPp7/rRTfGrReB7his9f+X3EmEaRGcMD3RscIASAuKKXzklDZ2Df+u9BPP8DsMPF5sllTEzNvkPOilqUGDGGwMWO51XsrkKFflht8YtdLFYlMEKeCO4rHrp1WslcpOqnXsrKiqVDWg5pHB7UeWBXhQp50HAGsEy1FjlTijAku4nYc3gL8g1T2YQi6M6fTW9u5vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In confidential computing environments (CC_ATTR_GUEST_MEM_ENCRYPT),
virtio devices require VIRTIO_F_ACCESS_PLATFORM to negotiate restricted
memory access and DMA bounce buffering for virtqueue rings and
metadata buffers.

Currently, virtballoon_validate() unconditionally clears
VIRTIO_F_ACCESS_PLATFORM, causing virtio_features_ok() to reject probing
the balloon device (-ENODEV) when restricted memory access is active.

Preserve VIRTIO_F_ACCESS_PLATFORM in virtballoon_validate() when
CC_ATTR_GUEST_MEM_ENCRYPT is active, clear VIRTIO_BALLOON_F_FREE_PAGE_HINT
in CoCo since free_page_vq maps MAX_PAGE_ORDER blocks through standard DMA
ops without unaccepting them. Reject probing (-ENODEV) on CoCo
platforms where balloon page state transitions are unsupported.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_balloon.c | 36 ++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 217431e75751..ae011636c07f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1311,6 +1311,14 @@ static int virtballoon_restore(struct virtio_device *vdev)
 }
 #endif
 
+static bool virtballoon_cc_supported(void)
+{
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		return has_unaccepted_memory();
+
+	return cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT);
+}
+
 static int virtballoon_validate(struct virtio_device *vdev)
 {
 	/*
@@ -1318,7 +1326,17 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	 * initialized. If we cannot do that then we should disable
 	 * page reporting as it could potentially change the contents
 	 * of our free pages.
+	 *
+	 * In encrypted guests without unaccepted memory (e.g. SEV-ES), the
+	 * hypervisor cannot populate discarded pages with guest-encrypted
+	 * poison/zero values and the guest does not re-initialize reported
+	 * pages on return. Clear VIRTIO_BALLOON_F_PAGE_POISON so reporting
+	 * is disabled when init_on_free or page_poison is active.
 	 */
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
+	    !has_unaccepted_memory())
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
+
 	if (!want_init_on_free() && !page_poisoning_enabled_static())
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
@@ -1329,7 +1347,23 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	 * virtqueue_add during page reporting.
 	 */
 	__virtio_clear_bit(vdev, VIRTIO_RING_F_INDIRECT_DESC);
-	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
+
+	/*
+	 * The balloon bypasses the DMA API for page addresses and cannot
+	 * support a physical or virtual IOMMU on non-CoCo guests. In CoCo
+	 * guests, VIRTIO_F_ACCESS_PLATFORM is required for bounce-buffering
+	 * virtqueue rings and metadata. Disable free page hinting in CoCo
+	 * guests as free_page_vq maps MAX_PAGE_ORDER blocks through standard
+	 * DMA ops, and reject probing on CoCo platforms where balloon page
+	 * state transitions are not supported.
+	 */
+	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
+	} else {
+		if (!virtballoon_cc_supported())
+			return -ENODEV;
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT);
+	}
 	return 0;
 }
 
-- 
2.56.0.307.g5fe7bd680c-goog


