Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF96CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AFB56B0092; Tue,  2 Jun 2026 17:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1606E6B0093; Tue,  2 Jun 2026 17:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000416B0095; Tue,  2 Jun 2026 17:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E475D6B0092
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:56:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D57DA0185
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:10 +0000 (UTC)
X-FDA: 84836331300.03.C887D2F
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id BDE35C000E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rESkDtpf;
	spf=pass (imf10.hostedemail.com: domain of 3d1EfagYKCO4moYXQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--wyihan.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3d1EfagYKCO4moYXQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780437368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZN9q1aHIL9jEfZ2MGsblaqq1tdWrGmvs3WWbS54Ns4=;
	b=CZi3vE0w2jlAdF02TgREPibjbseinlnuQG4UjZhDg0/wS16S36MkT3AinWok6ex8zi98Bg
	+JD74o3AMwQwBPeBhHQ00eoSwaX42p7vZqKKytday7xm2glVpUwjQnIbj9Jutj0bjBDi8o
	tuI0ZyL3NR3/MrMeL4WMTQBFs/IoAUU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rESkDtpf;
	spf=pass (imf10.hostedemail.com: domain of 3d1EfagYKCO4moYXQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--wyihan.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3d1EfagYKCO4moYXQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780437368;
	b=YzhEOreHKGRYGdXKSOwFRWPq4BMki0RdXwctX6r1ah3MPqJ4HlAjE+gTNuAdcTkBLd3HEw
	Td6KjhkuBW4T0jkQ1VprysW0r6lchQl7Qixm/qd2SNi8XUkf1grLxGAGXqfgH2YM6cy9Pq
	931p6OlG1eDLRkhvVRd8a63XxKOYhC8=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c85a2f19558so2038749a12.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780437368; x=1781042168; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rZN9q1aHIL9jEfZ2MGsblaqq1tdWrGmvs3WWbS54Ns4=;
        b=rESkDtpfTDk4YHKtacXK6w3bdiyLA30x6J2jbmYwFkW8RWhNyLhtvgmgWAMbCugACr
         l4JGyBMpIK9fEWU0HEdkd8t+7xDZjpocfImklIA8n+ZhEv4H2DiUYJ5IrisVp7rGKfhU
         iHzDMN559dnmJlPkPgswe2XmHj1ysw5cV4ctfsJM+0KWFWwEGavA18KVeOH6G8ig9zwX
         bLAm1kXuHFtV5rUKLeI975z5i1iy56DoM9EZoVR0zTZ18lXxTcgfz7Kl62MsOWUsA/9c
         sbZycjjp/E0PXLN703XbX2Yb/A64I+Yw6soWjGfSQ3ACW4Hm/YjmqW6QxWSAUzLXe2K4
         wwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780437368; x=1781042168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZN9q1aHIL9jEfZ2MGsblaqq1tdWrGmvs3WWbS54Ns4=;
        b=Gub7udKzDekO6f/CPiRxEvtAnnoErAq0/x0L8y6WJCxkX4HMnOCbAorEs5u5IWoglT
         EHCScWTwKGZF8DPw1z/P7kJk+5vr3p0ejsrj9A9YRGc0g5Ix4IkjAjGWw/ebuI1s0f77
         epQ39NfohVGed6xPgJjk8sT7tSAaPz3cQ+my18GK1EixZrKn91HhSuDLDq5XyU685P8N
         vNfY+sGZF3MoDITQ5dJTXulcwk47gqOH/5q/CUlk8WMvqYn4R+5YHTmRSQZnX0Y9ERWj
         ORaes4inToqckii3sTDWfwDBTEvcCPdoinDv1+4FWoEmE+bh8D/G2xrGNG/R43Vi1oKJ
         24Vw==
X-Forwarded-Encrypted: i=1; AFNElJ+kWI6pruHCCLscQdjEmc3KlICeCwkIW71WY1ATUuS3e8PQA16uKTn+rcUoyWrmQBWqyQeD73+xNQ==@kvack.org
X-Gm-Message-State: AOJu0Yxhwgifr7dZ4LgCGMn63ILWn51o5U3515pt0qRmLfAlFHExByO0
	WNr6avs/HBy7SrbigCUGeLux6MwyCCWmhvO++zF0ea+SWwm84hAm/6D5m9wOXp8gMVMa6FuwzU3
	YADZicA==
X-Received: from pgip16.prod.google.com ([2002:a63:c150:0:b0:c85:735b:ca4a])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:86:b0:3b3:241f:66c6
 with SMTP id adf61e73a8af0-3b49798aa66mr679970637.26.1780437367409; Tue, 02
 Jun 2026 14:56:07 -0700 (PDT)
Date: Tue, 02 Jun 2026 21:55:43 +0000
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
Mime-Version: 1.0
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780437363; l=1598;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=lKnN7DFJZ1CI7P/ecQkLCNO048bsr9CmYWTgdYN3YTE=; b=rBFtlvQ/7oSruMlAmmH25URviunGUIx5ao2QShrhRD8hR/bXLQAXAsiiyW2j5GrH1cgJI/Yfg
 qeemVXBKeqQAGqv0RcyXpSDAWZQbBi9Qjq/DWMSLzr8eBsxskS4WHVg
X-Mailer: b4 0.14.3
Message-ID: <20260602-memory-failure-mf-delayed-fix-v4-3-a5bc7db5a9b2@google.com>
Subject: [PATCH v4 3/7] mm: shmem: Update shmem handler to the MF_DELAYED definition
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BDE35C000E
X-Stat-Signature: 3h6wbs9q83ukqeim7sqwaf6py9zytg4c
X-Rspam-User: 
X-HE-Tag: 1780437368-516190
X-HE-Meta: U2FsdGVkX19bMIhXhRUKOFNBbZPhLPJZsJ+/gkEBbHyZ4dyfF/EwhqSPPgsulgWIKgoMz7eCsaHHFUaAzYfIHPct9j0QNXgCVcGYtGX+sBKh/LNSbUt0LO692eG2VGKOLS8GHoe5vsU28HihSlyzJQIi+S+P1PP3NK/GH4pTNNszHgWRw0zODC62xPsziQAlugawedrD6h80HwFdnEwMuYwNjLGktGID3KAsSn8fsCxA4d4ilqShSyT+ffHzgSCZSypXRwKCfk3vA9ulEAujwnu08YCYnUWEAtYNm4rUp2VhC/yin4wuX/YYFEzFSu0Ddbp30kNmjdSp/gth/qRdA7dyrkfroUN+uqXr8UUb2BvAcF9Oqu/rudzqSKri8ojWHHSVR0hRXFMwHd9O59XFN6YylEfVDk7cgXKViSA+J29sTUSOBrTjcEg3Bc0J37PKs3baTdju6S2LMjXpg8XpH/RkL5UNvmJKo7g2Qu47DBrLCZBwTFxIHwoNBB73mPshLU1uJbrKvW0cDaUUU3gnRRkxAQKc7uNs6lxxe91/dByzNwfbNEAPi/SVjwQxQk2Ah878Eg6bPXc/cyCZ+RiXYTbd65m20qmTMPeEk27OIrCxLVQgQXjC+2SHkEzzrhjB9I8FQu4yislja7rZLpTi2QwFJ09D1SrxSumz4Rbdcz/GyO6tSoLZ7BYn8v7oQB96WQOCtmoJlvdMcjo/hUQ5BPoyWUhOssWyDhErth2ju+pVmhaNMqQIo9yfiOuXA9pHtXdKol7bbB4OS9rkGwhzMsRXDJb/DkxoWXD9vi6EN5l5f9fO4brEfdyIN8BNUNEc0OXQyNayXk/+e0Alc8M2yhDEnocnKjUqzM803mQhMJDmQSmv9eXZumQF40EB5F6XqyKhJEWI/gsIK/K1odGoQSrUCDV19OaQyEXOE3yDUlwoyPmiHirIm7u1DPmA96GW7C7w6h6qgb56BPYLDKk
 VFEiTebv
 SoXABtp9JD7UkgHJJe4e7RRr/4lxlum5fJbyX4tf8egUNo3SoGqwqWa7d1zQooQmIIkq/8FUEaqRqkFMyP92Noj10leIx6yFflq324dlrbomxUk0zWiElIJeerpgZpo4ZuYbnSPy5GoZcxXwCpGNlcSPnbsA8Z1TF7AekpDUoV+tkLumgcPkzP9hFcF5sjxuGiZlaWhdlHD8HXqG3By8Z2PpqpHRZ3BLC9Jk3vbM1fIuaHC5WmJTBmAOrtXGGxow4xisTJcv97/DL56xD2AmMk+ItPC/MogH45wM9pLW7KIHxIcsWQEZb4kl98ztUMaE2Kiidl8QYC3H5ugQSjuAACh4lMYqI6/pED+fy8d+hRLL9CoXSOIW4EDO9fXs2yU/WF+CqQZXwKKGzIEB3JyeueK1AWjVL8XCstGDy9Zy7O2WpqSG2WuXa8ga0ah6I/lOYWefS0+AjFlJeazcYP9I7NUpZxC4ApjrjqywuY6drUyGsVlmTtmStpNqN8pFggiPv9hv85hJ74eMt+7+277gSGEpEasGP68l2BHarGGwAB7rmbw9on+8Co8rYtmxU7c8Sps98D3zTs9xsEFf8OWBwKpqe7AtvKG/snKaTtObRZ4LghgCH2W2+IsjtfulHxcXFTzQc3rYFDRiHuN3RSqXGBFmwUAwwlHoRW2ct
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
2.54.0.1013.g208068f2d8-goog


