Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC7610F995C
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1020E6B0092; Wed,  8 Apr 2026 13:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049A26B0093; Wed,  8 Apr 2026 13:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47026B0095; Wed,  8 Apr 2026 13:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5E866B0092
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:26:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D7E9E01E5
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:19 +0000 (UTC)
X-FDA: 84636067278.22.F64425C
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8ABFD140011
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NWZ5qand;
	spf=pass (imf23.hostedemail.com: domain of 3uI_WaQYKCIc79tslyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--wyihan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3uI_WaQYKCIc79tslyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXBGnJ08RM3Dn6KYmVg3dZVgKAKRqoAR1kz7qqbY2VI=;
	b=gy/f2xFDIqFTto5Nvzztq0O9BPnWaVaold82TfXsU0FEgybF0vT4I49KFC4JVVbFYMFSf/
	Vf5h90Lo/9uSNpTeBG+lcbRSJsbP4Pq+un0xBstW6ki6XvW88dts/VHQIH3al7J8Wh2f4a
	E3mBMU2bQD/vEB4jJWUAsxOM4sMFy2k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NWZ5qand;
	spf=pass (imf23.hostedemail.com: domain of 3uI_WaQYKCIc79tslyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--wyihan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3uI_WaQYKCIc79tslyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669177; a=rsa-sha256;
	cv=none;
	b=gHOeV0zE2ieUi6VlBIKxAShYpVt6d2Pjm4H7JEXuBIiQp/x9V53dW3lroHUj69G1h/rbsR
	eiUE6v25fmYu0UDLfGb7yv/Fj3h0heuAx4KaQDOJxUVpYSa290zFXe+XyuF7EC+mZfpTPT
	YHfTzI//bgE4BRy3YY5nirF6QDsQ8HY=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b0c30b51bfso1904415ad.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 10:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775669176; x=1776273976; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cXBGnJ08RM3Dn6KYmVg3dZVgKAKRqoAR1kz7qqbY2VI=;
        b=NWZ5qand78St0bTmM0NMNeXO8E4E4rvjK1RfoRnjaYdrpWvRtRnEGR7bqO2XOyP0Sh
         SPfnSvQ7sVHiYVIO/uYxZr3NYXJxE5O9QN4YZXn8tXQFKE4O0wNkl1MZaRp02Opj9bIf
         80veLHCuxyshAQ1a0aRB7acQE07/TQRd44FSIb4vMqi1klzt8NSFJsV4BhWk7i321pgI
         KzzrtOwBIlaXMnekxXy5YDd9/It1q6FlmNNjLZZa7uCEu6GHQjyz8r1X9Uj7Ow7VEi4T
         ujubW9Yv7guuZv/MFzCBX8tuszh6+bWfpdAQXTnj74rwYBw/nwTarRO6BM5a257n0rHV
         w00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775669176; x=1776273976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cXBGnJ08RM3Dn6KYmVg3dZVgKAKRqoAR1kz7qqbY2VI=;
        b=kZCR8H82hReC5QOCKiBsJqnsd1fZXuHsawu87AVHkjTP9KDVzjgRQvyE+fMqWbW28H
         vUuYw1auWJMO8tnYwMqRRVguXFQRap77tCFJh56uw1KOuQyFtdAhSVXWA35Tz7EXcXVS
         /XRRft9al5xml7DS6ysH0aOxTaKu6FferJeeCDcslhbJA1BEFfcjLz4EXgpYseBtzLTT
         dipzI9okwLMYqJe0rJXxfYYIBdMeUwGa0Df8bjf3jW8mwGbr8a7fA3E/JA/cEYwDhiqo
         ZTXiViuyHAbtm5JFv0oGPqjdbjxqW47K3QoyzVVuXPlwXxjYwXrF+cB9SVtPicNSdtGL
         bbmg==
X-Forwarded-Encrypted: i=1; AJvYcCWrQvpHnGHqZLO2rblT/RiIXpTd3SQDy8vP76i5YX8hGsxTyN0lrqP8yhqjDwf9a3wkLpfSNu6jAA==@kvack.org
X-Gm-Message-State: AOJu0YxSp47Hqt+DEQ+am6fBa0ZNxx28iUikJGDVEq+Ko1LjvUVFu0H5
	UM62YEjIWBVlLQQ/B/UsdO2ZuXuaoEHJBIaRTokuUZn9ufnJeF7v/rOMVVGkyyErgncTOMhetWa
	odv474g==
X-Received: from pllo16.prod.google.com ([2002:a17:902:7790:b0:2b2:4331:5552])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3803:b0:2b2:4f43:b48c
 with SMTP id d9443c01a7336-2b2c7267313mr3087985ad.14.1775669176229; Wed, 08
 Apr 2026 10:26:16 -0700 (PDT)
Date: Wed, 08 Apr 2026 17:24:45 +0000
In-Reply-To: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
Mime-Version: 1.0
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775669168; l=1543;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=J3QZtuvE1lZ2QUWb/3XDrQaTozqcK1lsZfxrtY+rULk=; b=ohyQXWxRZGPECeCqTFjtef8YZ+umakzibuW5apwDb2InHSLTkMGXhbBkBw+FaeA7lKNULxCbB
 XrJMn2cS9cmBHmXTKCX/+Omh2q/h6zyDLPCi7ZuJE70grdI7shFL2Gm
X-Mailer: b4 0.14.3
Message-ID: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-4-718f45eb7c75@google.com>
Subject: [PATCH RFC v3 4/7] mm: memory_failure: Generalize extra_pins handling
 to all MF_DELAYED cases
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 8ABFD140011
X-Stat-Signature: j71qpiuhy1x8cg37fkwerx18ao1sbqzd
X-Rspamd-Server: rspam06
X-HE-Tag: 1775669177-134383
X-HE-Meta: U2FsdGVkX18X3y2oBogdJvuZAo4GsUrej4VkQE3MBGHD9+7aLs6i19KcS7WVluVuUgQ8wgpudv1eQxh/FZDGyvChIXhSvRhcpBH3ORu972Ea5dI1kEA8zwxCtSWMjFTbwwRp8XLQq8g7dBoEHId89KOWU4NkeBU21J3qyYd8i3F/xMY0DcSLqswlPMuJw/yJEG9Dr8v+wFqr32qf95Mv+6Pb95DxCC9Y8mj8s7xs6yvdmxs1CT9/sVaXkw5fi0f5Im1rcTo/bvVINojJWWmd+z52KY6gyCCTSJXXrYvzbKVy/AJRavcwbnUSr9ILmWd6gOsULP5LoRrmnpN6M49gZB/O2rdSpxYvdHHv+0VsJgw+2ALnXwFIQ+V5bpugeTuGidrhYxqTSo3v2AtBxOqejCDaikhiP3wM6k0X7+lvjyR0wilTBCvcNozYq0FIn8zaxXkANMK8KWmusBpqYuwDI/RH77YNOwkqQbmm0lMEAaNj+z4mtG651vEK7CcdqIdlNo7TGCnaDKUUCXFElQd2KpL84eZrULHN6V2EboDZN9U8zYqBw5Vz+2UgnpZadJjS00hHvvmxkXqtXq0SS/L2skh1N+VRcglIgoAucwEPx7XdcXbpDUM7sJUC14pH2jMWQ7AzaS0xhWcNitc7Joa6PpAnmqWm19Jk8HcoLVa485mkfUnjqk6bRW7kb/UOi4qnsTqh3WyF6fjafKEW47bcAQCuubK3EfuSy8VduLTFlPysqSFBQ/ggsmrQ91nvXaD7JZ9ERMZ/nXiaDYdoihjn2o/Tl5gCwok2vfbN0ZfvMNIkEzuLJtDA2krin4NT3CLw+x1Kfo+MGH/QVh51RHl98YPa/kNWXxrfC8yfYAdmEfJxa9eIGBdakP2e0dW9cnejoCcg2k58RtxksmqzjqGE8P8ZjDhrMvEDNe3040R+MANLlE3tIv/lyURxl0G77ePdTD/ebQHumLB05I7lpHU
 qZSVseJs
 J2ag+td/XWVPRhrz8riHE17gyy4bOlf3NbjqXwcwMbP6C8g0mahGDRbVa4WWSH5VTxVGZ0arJbFTXV3HFxhSWnB8C0GOMSndr6x7YywOCz56sTtuxENirwT9mO0C3kpw9B5zyv5V5ohOcdWHJ9M0D5xsdFchFZEoC32Ch2oRFaOO3T5ew4ZIbGS69XdbL1hgD8U+vO32wwtk+hQ3pyHmcTuImP9zWucfiyKSM3Oa1q5dwZWo36LRDBX/h/8CXCmmzUkXpTS6r/PbjLoVQYksFLs4+L+MrDbRVTKGqutzdjP8NBFab9930BMPfiWBLL5jDsY37PmCjhE+bvgvJ/N1OUNGA9SkzbDDFkeFd06PLIL5hZ7W8CwU5sLTw7ukGj+Te32kwmiDvV+/7KvlZuzVg5vIFZs/8v3shYSNFcAYaLPA0ADOjHI0wvNkodNumVw/ksbKjkN8Z68GmTx2UlqkrjrkoF/Ny8oxHbQsyYEap/Pc74M8Mmd/FP6p4A+V1nZdTZ4QUuJJmcBCmI9B98/XUwRKyS4THzp57xl7UGZVEZUI35GPu+gPhtu3WPtJYi0N6yNgZdVLrq0IKDT1Qu1dhUgJn9WHBDBNmV7kIny+ct9egI4tsa/GfqJyUk8h5MF56SxCBnq4Bu34SGrbOk1aHKD+RS8G2EIbeWSwaeJRqH7zUrAYVCC0GC60QWLH74o41H2EXAdwu6IfdPqd+lHqdkpj71X9/F56LziGfFa1AuqA0zMN1J70r6RUT7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generalize extra_pins handling to all MF_DELAYED cases not only
shmem_mapping.

If MF_DELAYED is returned, the filemap continues to hold refcounts on the
folio. Hence, take that into account when checking for extra refcounts.

As clarified in an earlier patch, a return value of MF_DELAYED implies that
the page still has elevated refcounts. Hence, set extra_pins to true if the
return value is MF_DELAYED. This is aligned with the implementation in
me_swapcache_dirty(), where, if a folio is still in the swap cache, ret is
set to MF_DELAYED and extra_pins is set to true.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fd9ed2cd761d..d6628ad114a5 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1052,18 +1052,14 @@ static int me_pagecache_clean(struct page_state *ps, struct page *p)
 		goto out;
 	}
 
-	/*
-	 * The shmem page is kept in page cache instead of truncating
-	 * so is expected to have an extra refcount after error-handling.
-	 */
-	extra_pins = shmem_mapping(mapping);
-
 	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_folio(folio, page_to_pfn(p), mapping);
+
+	extra_pins = ret == MF_DELAYED;
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 

-- 
2.53.0.1213.gd9a14994de-goog


