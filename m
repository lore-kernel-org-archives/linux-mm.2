Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7003F588C4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22D76B008C; Mon, 20 Apr 2026 08:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3446B0092; Mon, 20 Apr 2026 08:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89C86B0093; Mon, 20 Apr 2026 08:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A46486B008C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53E18C3120
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:41 +0000 (UTC)
X-FDA: 84678918282.14.38903D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1683FC000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="E/cMEC/E";
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IETrtHkv4WyAsn+xKXnLATQqoj86uMIE60X1mP6bLOg=;
	b=Hy08Oj2R37UqyU9WqMJXkSRO9gRSEd6GHDFgmwdoVU3ZZdoc3a1do5g5Y75syJBxyVJl4i
	CiUrxXYR3KDdV1BX7TqYyLqFTtDtDQ8YGusNhsdB6Kuq3q5cuDh5KaZY3pW1g965hwniw7
	CUNpMbzKznkBpDEs2QFokxjGDrO82Oc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="E/cMEC/E";
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689439; a=rsa-sha256;
	cv=none;
	b=fcHgSEW0Yj4T6CstFMEt2jWlzvzAxac/BBWrQhWjFPO896lmlfn9aDasrPA5zki+XUeQZL
	tI1vgNtW4pUdjaBQGmFMg86u1bmwp+DqoQmwNm9h8p6a6/1/EmXmkMRVt1lLY/MJtJuvcl
	qw0qNKNi8ptEPTL/JKaLME2zOz4qyYY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IETrtHkv4WyAsn+xKXnLATQqoj86uMIE60X1mP6bLOg=;
	b=E/cMEC/EaznxUSe+vb3VGfVKWXPdXrDdaHUjjSpOSWZ1lLQMwZWSSt44/Jl0mLmy1roKPc
	Iu4ZiQOtH4MQ5T4pMlm0UO0wooiKhpA4CGwUisVhqla7pXuTHLCfDvrcb8YUtnZMmD7dk0
	/EnW5QLy6IYslNqcZM3LCUmWZeOkb3E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-V-Gq0lVuMVeqE9j3qOs0RQ-1; Mon, 20 Apr 2026 08:50:37 -0400
X-MC-Unique: V-Gq0lVuMVeqE9j3qOs0RQ-1
X-Mimecast-MFC-AGG-ID: V-Gq0lVuMVeqE9j3qOs0RQ_1776689436
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43d7e5b98ebso2622293f8f.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689436; x=1777294236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IETrtHkv4WyAsn+xKXnLATQqoj86uMIE60X1mP6bLOg=;
        b=aaUS8SqqsmicC9fmJf2HLNg5FqPzm5VibFrlgSWRGjAwvIpbeHC3lKIDxxBWcGGgTf
         p4TPLA2abDGyXECzCMQgfUwPj3jdJ4wjRfSGeNmTeR87B10ft2/zmzqcRre/AGfoP+N3
         BztUbBnmwDVEmLYw1mZBf+aEGFClG/GIGMXJTOatYjtlSDL30l1o+0wxUwukO/KnqqIG
         GjLuJ7MFrGh9Y3JGutdWg8SH779C44XiiPePhDC7HFpB707AfDh38gmpkGf3AiWUd/S0
         8zP5tKH2LrPbnKIMKagBPYhpFDHa5OBXkJDlwESCcdRumbO7Jo8l1cQaahOdeJUEfGgq
         1r5A==
X-Forwarded-Encrypted: i=1; AFNElJ9kV7bcra1r129D8c08KyvabjzVifmgbMalw7QqK4WgUkbhqzfF7Iq1OvqfCE+rrVXK5GO/gasvGw==@kvack.org
X-Gm-Message-State: AOJu0Ywr8ir8Q5VtiClwiwJFHH7BrTliA/Klyt5vxh4oK/fq0NJJDELw
	hZFjAKM/8Gn/cHpNw3adUiGNNkuKZb8b59rnGZn06egdg5dlJ4WGx6Pv8/2HVlQ8IkfwqDkN4PW
	73f8FZ/oaVWXwBf6av49J6pN7Stc6PVFD4g/dH3/R84A2tPwOFxlo
X-Gm-Gg: AeBDieva150V5uNAPJbvaAgWc6OnS1jOo6ctyfXxXLOOQW80JL1Z1D1F0AATFnSG63e
	nZcje3ONbqjS2QEBic10nOKi0qbHRLAVeULOckIiScN6aqELqUJufVPTjSzwd24aQGjjmqrYCEA
	2Ozs6Y27WsjPhlf9TLXevRTBHMnEva9MnQG9YxvmZ0ga5UPg0VQAL67eV4/cZqGaUgqMHlZF0wC
	i3RvLLl+HaLWQBbExawKJ6v8iVQLx0Ue6tuOu+vOLHuSWBS86OIBi4CjS3lMNXtrmBwmr+dCKPT
	YLutNJJUrB+7dq554YOaueqokM/Wff8bAMxw/Vd/mpMA6wzBc7YHLg0zLhGk1DG766t8C4c64aG
	vuaybXocJ6cNDU1odQygujQD6STWkvDbJ+zgiaNOZjcAE78E+qmZdLQ==
X-Received: by 2002:a05:6000:2308:b0:43d:76d8:5794 with SMTP id ffacd0b85a97d-43fe3e14f8dmr22172802f8f.36.1776689435749;
        Mon, 20 Apr 2026 05:50:35 -0700 (PDT)
X-Received: by 2002:a05:6000:2308:b0:43d:76d8:5794 with SMTP id ffacd0b85a97d-43fe3e14f8dmr22172730f8f.36.1776689435207;
        Mon, 20 Apr 2026 05:50:35 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e59f97sm32291619f8f.37.2026.04.20.05.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:34 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v2 05/18] mm: page_alloc: preserve PG_zeroed in
 try_to_claim_block
Message-ID: <0be843ccdd029d61887f199123cce216dcbbdead.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D_D7kApreFwny-15VRS_EvH5PUWczZqpFaxXamZdLRc_1776689436
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: rapif35x7ftxwox7bzqdp6enewg9kdm1
X-Rspamd-Queue-Id: 1683FC000F
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776689438-197506
X-HE-Meta: U2FsdGVkX1+cjfa/R0klmYgamlPsWDR80Zy07fHTIdzLdeFLerxXnVF0KKSaVJ5GToE6g0De0D5AWzK6mbVdcvlpeLVWbzWGzQuSdeLJ8x/9802JR2VWIIPa4quY4zjtQ9NeRI67C3jLiUmRNKr6n7kYQ+340hdgcnPpHKvQd0xygqheTD0pg4i16JrwgdVAt16F9r05zX9B5+RxwjkxdhqY2yYn1gBVQZYX7qAGjdC2soxnLQ5BvXIBoDXKYbIP/orjmo0VotT8S36Ugz5hMNNcy+h59h4AwXbqkUfVuGfX6HCo6a2bMi0FsAu32cjrSkX/lMXeLiKjXAZ5vVY0mUeajEbHpnDyk1YFL4Lyr08Y4eABCG6JdC+d6svyXC6Y6HHtpUpqdM/v9uCKkPmDipbRTLZeagl9pa4nEZEpUM5Jx2LHrX0c0u3OWmSPsK3mLroBzKX7iAdIxk76ykIUty5yrkYxHCmL/8PNvEP7tHDi3+UYWvVpKLreINCsXM92fUZsbaPlKIio0+IBx33lXS0fhcWBvDlju5i6n33msjiGOFKZPxOPB4EZV5XOwsPmObvxfB1os7MkmJ5BsIQRwSVGfBrHql7cfw+QBSO9uFVb+KnXCLlOI5SX/BwAvqjgD1vLIzKsg9RjYr3P7b2V+gBK+jKbExNP3JkEVyiRJA8RFEqC96dpXqBE3gZpfAlHWp1yS98q/UHlPI3F9IJw8nG7cPnnhqLwCRufxLjceNV/uZN7UtWoLTjJ3ontsRy5rwgmW++w8gUQ531KyU1lXcDkKO/AHRQykKTjiZmoujxsSQrE9VNSbrqnPTxmCcQGHKoDwQBzWPyZU1O2xUUWSu6JGsWEL6sYD+weYep8OS1TXOAD8YqUXFJ9oFWi7ko2l9ByVGY2Jylu31zOyflPW66AgxxxyRMEba5fh/TY2yH/XEwY7Cu8ND6vHC0miQj70a9B7iWX29nQ+0lJepW
 U0J8AU20
 MYKfuLKfYftrYAP48QnoNcmiAiT4q3isSKxT7T6+UvntyQKYvUoiBv3qcA/btmcCtBh2ZlP2e8+WDei6WQud10PQZmULXYUv90DB3Mr08NDtQu3kzLqap/GvmEL8+7rxfF9vE9nhKCUT5y5KCibqXCXTUoT+9gSUfIjX3AN02J7s30g0RlLb9bdjC/Q3Norq5DxV4qdyICkni3luVkEEtcgzeeXWxvsJolWVzVj7GfIGLxsr7pl1MvXKAoScZihYwQg3GttwXLKHkICF7jOdK/3SnnNHTcuZgM1uwwvwo16D2IbUM4I2yYHtDqR05os3LTNpBnerSjUudJHJoUz7+udTXlBMrHVupImCKfwXOteSoE53ELgX3n6G9M0Z9ZXhb2l29Ex+HzEKXjIn20BHIDetHMOv4psFV6oNS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_claim_block() calls expand() with false for both reported
and zeroed, losing the zeroed state for claimed pageblocks.

Capture reported and zeroed state before del_page_from_free_list()
clears PageReported, and pass them to expand() for sub-page
propagation.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6adc894748c8..b0971a1eaa73 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2345,11 +2345,13 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
+		bool was_reported = page_reported(page);
+		bool was_zeroed = PageZeroed(page);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
 		nr_added = expand(zone, page, order, current_order, start_type,
-				  false, false);
+				  was_reported, was_zeroed);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


