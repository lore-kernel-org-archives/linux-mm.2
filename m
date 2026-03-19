Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 877B0109192F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1500D6B04B1; Thu, 19 Mar 2026 19:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0416F6B04B3; Thu, 19 Mar 2026 19:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E715D6B04B4; Thu, 19 Mar 2026 19:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0EAC6B04B1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:31:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BF0A1607A0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:02 +0000 (UTC)
X-FDA: 84564410364.13.15C1FC0
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id AD181180010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uEoWWdA7;
	spf=pass (imf16.hostedemail.com: domain of 3M4e8aQYKCIg8Autmzs00sxq.o0yxuz69-yyw7mow.03s@flex--wyihan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3M4e8aQYKCIg8Autmzs00sxq.o0yxuz69-yyw7mow.03s@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovB857WaY8E/qhB9OVlkciDwSTU3lGKfzkX9KK2x9wk=;
	b=Yl30gEgNo8+0rSnuevd/i16mGzHwe/ILuxlr2POmeEkRohg5DO041a5hoNV6Vjc36LYkDj
	+M/o/YOfcFzwkKB+aRpaB+9ihFEyQEfHgZpQoyOCWKBAiDvFJg6VnUex5qs/DSxyoPpi3N
	1mrNk1ssdS3wCDn7BhDH6R3Nl2CVH6k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uEoWWdA7;
	spf=pass (imf16.hostedemail.com: domain of 3M4e8aQYKCIg8Autmzs00sxq.o0yxuz69-yyw7mow.03s@flex--wyihan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3M4e8aQYKCIg8Autmzs00sxq.o0yxuz69-yyw7mow.03s@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963060; a=rsa-sha256;
	cv=none;
	b=bo3BmeHTcCHqZYZj0jVx6x3ZSIdu8n4QLMPQB3r6dE7fvSTDD0AtfQWEM/Fgq7/IU2EdVM
	pTitpB9PrEIfMlJlHvqvF1lA7tBwtPiCBhTATFRiq/apItM5IJ/7Pz7TUMmEBhnsJUpiWH
	NhvRqjD4URNO2sf5s2wtmDvfKSvklzo=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35678f99c6eso64458a91.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773963059; x=1774567859; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ovB857WaY8E/qhB9OVlkciDwSTU3lGKfzkX9KK2x9wk=;
        b=uEoWWdA7PIPQdSVsye+L2IUrEqtL9V//yB3Ua5R9k95ENnoF6ua4O6blgbtV48jTL0
         3qAVQEgHz6Os7r2Jo75W+bYQiR0LULH9T+v4kicJgNjY6utSN7YgpmSxJHiG1Tm74xzA
         ste0pffR/+2Fm79mmQibXWPnvbqyAOx+F12WNgdAPrjmyS1AKSFfCX9qal1UABz+ScJ5
         35GawtxpB1npP1xMB8V0R7TixgYYB/1YkvBfWSKD5SGiW2GJTebhsDihZ07vVzr4MqOu
         5CQiR8n6b1df1pPtv/u0tTEZlCFTCSGpfZcJrx54DCDDX2qm/7GKMTgNXwug04mk5jDv
         U+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773963059; x=1774567859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ovB857WaY8E/qhB9OVlkciDwSTU3lGKfzkX9KK2x9wk=;
        b=G46+8O6VZ31AR/qs3MNIUWMWBX/YLbY4t2i+eR2u7QLf23h8RhIvDFIRZNHMheB0mS
         4ODVHmQwnNFfZv217CdTxhmYR8mUrIzuOBvBbk6bHTUb8nS7cWts3QvCOfeqQdZs4fsp
         8QjpxXvAqGriyLVMDgf+jrlNhX5BPbjbQrLqs1Lay4CxCxnfrZx64pkCDYX/YcuRhDdR
         uJbknkENoj+4791gmGi3YtXN9RtQor28ZoGvv88N9QDo+DWw+jFN221MlqEQIeAZ0f2p
         faA/lHbCcaaeBwONamgWkFnOu3ih18pn127vHB4dzuSc9Gq8LbwEuMh76eTXiLFbeAaI
         M7XA==
X-Forwarded-Encrypted: i=1; AJvYcCWQ9mWU8bHgwu9dk5P6MLzQgo1sNa8sK4PiozfAnUXrpzlcGadazbSB7RisYhJJ/vNMAsackVRvrA==@kvack.org
X-Gm-Message-State: AOJu0YxU2O+rqp445MC9NQFK84MCWwFPGtlTdPEQrsaN2AMRiPN0hPhd
	hq0e5QdckZhdysW3jA/tv9sI2Vxdxn1a+YkW6DEw8cMrL/e40rsTRqEQj/Ft0HMnRpzeH+GcrcA
	kGTfYrA==
X-Received: from pfbha19.prod.google.com ([2002:a05:6a00:8513:b0:82a:5ddb:b051])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a2c:b0:398:8f38:441a
 with SMTP id adf61e73a8af0-39bce778777mr953630637.0.1773963059297; Thu, 19
 Mar 2026 16:30:59 -0700 (PDT)
Date: Thu, 19 Mar 2026 23:30:30 +0000
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
Mime-Version: 1.0
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773963053; l=1597;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=4nBmEq8PTxZ6noHdf3XYrTEMDbspLx8WC3hJcQV/KoI=; b=vxpkmKNhTZAlitbCxGvzVvglenrXGw3kA9VLn/NaSu26fMFzma1N7B2oDY+7WGhTEHrWyRZfI
 Xc+uBjA/xs8Cf3TsOP1JQPD7CsnWMD8SRzBy9zxDOlQIv328bdjw/Ai
X-Mailer: b4 0.14.3
Message-ID: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-3-92c596402a7a@google.com>
Subject: [PATCH RFC v2 3/7] mm: shmem: Update shmem handler to the MF_DELAYED definition
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: AD181180010
X-Rspamd-Server: rspam07
X-Stat-Signature: sfmyrtkobbmz3edu3o8yh4k6kb4mgdxq
X-Rspam-User: 
X-HE-Tag: 1773963060-759740
X-HE-Meta: U2FsdGVkX18usuA2DG/nD8VPA2TeHs9C07XRmVml8Z+A9CRJnVJdV++jA6od9gtLn8TQPU3ofy8zCAkS86uZRD44UqF2eYz6scnRZdS+h2UHKQyMthmTDdT0ctX604t92k+blBp/KToM/tNE2vapq1FfFFYNxUuR0SfLXeYt/QLx0EtnXGRAXqwxAPATAdS7zZME3DERNUPAVKx80l6Fr+FO0kYtdMvwPu20pWQRit0/a0hmvCld0UQBPmj9TL6NcJpvVeFnPo+I67DoptqASsjXLmRMIC7AzUvG46XaN0LLTKq2AltL8eQaLbJaiZAignhM/DIOoBhvEAswQSSRcGeVrpN44VITEVbmXxmx1ytIYeIU5j6r4wX3e7quccmT/3nmRxomN8MNaMKa4yjIhSBTtuZdWw3UjyE65vysxpEkDXf7FtTqQzQzbH9I6OUufSRtqYnx12bY+ivUAiNOL0ut56gV2WauTSfG7kW0MJI/+6lu18JmQiuDEqw4DlaLqHCwQWb+IznmtXOgV2mRSCSNEDDuB9w1GpqxtmthdLUoXY3G+bwtxpQvs5cn3U3iJklbu6bwfyVEEZ+SWsYmNv73ZZinSmwnUxTQyocMPNxhsBTULy7eFzISQHCapd5p3fgCcVokBg78vZE8Cw9Rj0N8cMS1GvFxw/HpbDv7hVHDPXCi5Ix+Xv8Z54uxCimFsaWbiH1IHTcuPOzaZSgSEj8ZjHQ3/yN7kgEIBFwEUGfuXFjCbxQMY1hzSJqZo94xSkQ4LwvqLDLS2hjRpblatg6MIfDP3IgFV4plNKGpe2p2GcrH/t4Oe6Ur8H8+c/ugwyLchpsGGfIO7K9heC92tiBrPduuyQEYtG4HUj+bWP4t53QnuszrIFGMrCQgL9xeQC4sCFsAzl+fnXWL7C4E5JdtY77pS24bcWK/2Ivoavl8MDpAgHJDI7gskz0PMcv3rGAYS6NKPqtEn1vv3kD
 v9+atulK
 29Ch7PrjKWi3zpg+8HlWXVeY5EX4cvx9nxLBBTG8nnZBN8sN4P1+5Qd+MwER3qsYDztKg37bYF32MYhIj78ynW5NAfKduEGpJ5zWcemGJsCmypO2eNz+S4CR8Fwx6CDXl2MyPCSgWqHc4SxT6nYqBFcBP9psVOCl/GVrpZwpD8W98+8Asp3ICjuyZ1f/H/oSZo+ddQj24pVF0JOA9Ldm+8DrNFUso0eX0koewgmmeKkhPqlwORgQQKCdlJ46VLSdeh0MullRC8TrFo8H6fQE6CWoqbEnxd8fk4i8aRvYCFGIVGX/ADbDeY/j13abvIF4RC0oilC/uKl+NQw8tkUVQZl8y3pCwYLVS8RASRmuJBRgF80nqISEUcdIKJx8d7+nl/ZNRwh/VLiN+oW0qkOugTIzY1wr7HUtv218O6S81y9laznz/riavPVvwEGFI7CGX81H0LDUadZjf40C/uMBDQeO5C2cQ3xjUfTLQgMqvkwpUIeCQ6f5m9BPm1kniAaj8DVfQv77EnH98HiuWp0JHF+HFb6IpicJhSOArRQlb+8jQlQup+20VyCZPNfNHrysXyBLts7o92Q3mR3E+wBdG3SVDeAB0MFQZMAf+qB4xLP38+pBYMQ2DhbqJB9nxkDSHa2WjQ92MmEmgNEd7ltl5IQsYd5KLYjpttPvYH0iTlhf07DLpzdZjYLV8G78JbwEP+y9vXBfjorlkJZFqcDe8RaM7CYtNq03bi0zdaBc93STdQRPw/ZN+fznjrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To align with the definition of MF_DELAYED, update
shmem_error_remove_folio() to return MF_DELAYED.

shmem handles memory failures but defers the actual file truncation. The
function's return value should therefore be MF_DELAYED to accurately
reflect the state.

Currently, this logical error does not cause a bug, because:

- For shmem folios, folio->private is not set.
- As a result, filemap_release_folio() is a no-op and returns true.
- This, in turn, causes truncate_error_folio() to incorrectly return
  MF_RECOVERED.
- The caller then treats MF_RECOVERED as a success condition, masking the
  issue.

The previous patch relays MF_DELAYED to the caller of
truncate_error_folio() before any logging, so returning MF_DELAYED from
shmem_error_remove_folio() will retain the original behavior of not
adding any logs.

The return value of truncate_error_folio() is consumed in action_result(),
which treats MF_DELAYED the same way as MF_RECOVERED, hence action_result()
also returns the same thing after this change.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b40f3cd48961..fd8f90540361 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5207,7 +5207,7 @@ static void __init shmem_destroy_inodecache(void)
 static int shmem_error_remove_folio(struct address_space *mapping,
 				   struct folio *folio)
 {
-	return 0;
+	return MF_DELAYED;
 }
 
 static const struct address_space_operations shmem_aops = {

-- 
2.53.0.959.g497ff81fa9-goog


