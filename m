Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7B71091931
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAF376B04A9; Thu, 19 Mar 2026 19:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86DF6B04AE; Thu, 19 Mar 2026 19:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D386B04AF; Thu, 19 Mar 2026 19:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A590A6B04A9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:30:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6CA6714051B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:30:59 +0000 (UTC)
X-FDA: 84564410238.07.5B1CC0D
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8BE81A0013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:30:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mdnWNY8G;
	spf=pass (imf25.hostedemail.com: domain of 3MIe8aQYKCIU57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3MIe8aQYKCIU57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCHbx83iK3r3PTq425PBvHDhuCzYUl5sN2W6Ton0yI0=;
	b=KWhHYS35fc+GBTqSRz9MiJ3JonLxOr9s1OrlKyBWXlsnWgNDaUltB3DpNoCdDfuRhWtWWL
	bpcObyyi2w9J/6+Nrr6eRM/qQ8RuwHX6VAcaG869UAYQbw330HnoB06HdDmwOxei9EfAP0
	T0BwVxINZ2cRZP9kUV3oGuVwkhwjcVU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mdnWNY8G;
	spf=pass (imf25.hostedemail.com: domain of 3MIe8aQYKCIU57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3MIe8aQYKCIU57rqjwpxxpun.lxvurw36-vvt4jlt.x0p@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963057; a=rsa-sha256;
	cv=none;
	b=mF27EtxLgAN1laqQh96c5TVoqmRs2DWndjdFhw2gR4drlP4cIkFIgGYShJ8tAmWcGaGNQo
	CEvDzd2YkQYUvqvwsuIAlba4fxAw3oeWIUs8oCW4B83NUaGYq0dR0/cMbd7/ZuCYBHePyu
	lD5McLJslMgV8ETGqJnwqOrenXTmOr8=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3568090851aso1108409a91.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773963056; x=1774567856; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sCHbx83iK3r3PTq425PBvHDhuCzYUl5sN2W6Ton0yI0=;
        b=mdnWNY8Gfu7LF0NMwnLIL/wQnzSyUuSmFEf+VAs6awQTzTjmHyn4p4Hdl3CQArJ3yq
         DQon3gWC7IgefWA/RUQ3YVLPV0+XBXxVU9uNEGDcFZnZlxjpon7HcvV9wshrBNUBmw8O
         BbbSYBSlLJl88Muny5obs2GLxaDZJyzI6ku5ISbkapShwVV1uyOxi1odoeQSRmkjVjEh
         GXmzQmuhQFYkbXiwyoggko38X1rhqidJUW86QbKP0s0x3zMHTlVy1HY/3xnuv8/zIUnr
         YeAup1W6n2W902TzFn2RafVg1zByxhIMoalu2wZdcmSVvq1xQtgWaeZd3RqRzoPQ8QXU
         6IRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773963056; x=1774567856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sCHbx83iK3r3PTq425PBvHDhuCzYUl5sN2W6Ton0yI0=;
        b=pw+moNuUafMdd07QK3VHHUUwOboTkJDjaB24/RklMf5B8RZrNVPx/bEeeAcjIID/Lx
         u1NJzFPsDnii5zY5UlbSo0PtxAp+egdl/s74FZjKKrK9BMrXld160fU7E4naHAq+YhZI
         xkfaSWoRlhQ55G62fpWy+SfIzUpjPPhFJnKGw2QpwG6svbcJyaUOmR/esAunTwfJWc1+
         Q2k1deL5lwNUYlgIbywms7g8UkJwposi3MHBb7trVu92XumBluiD7gj3bCUMD7/DTXwF
         ONNeBQDjMjaYYvfF8Pzrb84BKdgOvoIGMYAjfADnSs6Ab/LbMxKoxaCh1LiLbhvm9zrO
         8u/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVK5zZN36rLxxyRrajTIHpYeuX2d4afEvKte2yzV3k1itOo65XV39PWa5kNiXXBZfyQNeTED4w6QA==@kvack.org
X-Gm-Message-State: AOJu0Yx1G5dpiBeAY3bQMb+pIeoNBqbOySFkcZ7Gi1Buf1W3jPxZmDri
	WhuCeMuUc6ca6dfuFKMEkt3cA/bI1JYme3sRXCWOFv7xITeU7f4gnqE7FG24yKbLedFHL4RWEE0
	OPmbNcw==
X-Received: from pjvi6.prod.google.com ([2002:a17:90a:dc06:b0:35b:9c1e:a503])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e44:b0:359:9158:7459
 with SMTP id 98e67ed59e1d1-35bd297b148mr776486a91.0.1773963056138; Thu, 19
 Mar 2026 16:30:56 -0700 (PDT)
Date: Thu, 19 Mar 2026 23:30:28 +0000
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
Mime-Version: 1.0
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773963053; l=1352;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=wOqfNAc1NvD9OIIK2IFuT9hSXcRKmOriHgtHRjPE5Bg=; b=YPNL8jxwq4kWmS/RsAYB4N4wCDzvDeNXcDvt36H56rqlisScdhaT3wHvfkS9+Dbew0Z0kkT6f
 pQOjgJ05T0TC8Im8YK9ko5dIngtrrkkjKMNkE/VDDjMrdxjo70z5Djw
X-Mailer: b4 0.14.3
Message-ID: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-1-92c596402a7a@google.com>
Subject: [PATCH RFC v2 1/7] mm: memory_failure: Clarify the MF_DELAYED definition
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
X-Rspamd-Queue-Id: 8BE81A0013
X-Rspamd-Server: rspam07
X-Stat-Signature: fy697x9x5srw987knf9rxe7jijakqwsa
X-Rspam-User: 
X-HE-Tag: 1773963057-999967
X-HE-Meta: U2FsdGVkX1/w21dh9gpzMcawOh1mW1JO2Qb8GOR8zIbrWMSZ3vTq/g0vqxdJmBaeE72xmV5+GCgw0j1s4gKWVTCGLWg1lHSkQ9IbZDQz8Ix7MV3AFPZXywK1hB4gSpREO0kupDBNEDzhodhBH9TmVveysYqvL3ezVycyENife/e0lCXTFDAryQMupA7IKFyLiWmk3pTjEFk7gU2fPmSZFZbxyIbCEvXfy3qh0+LyeWadTKOKtjefOXjaMkAFXUV3gHXdCRv9BCdN5JQsuMTg4PnnDJ8vNwpDk676EAcyxrEXgn8RoVdsLcRSFtRzmWKXKCu947I8LWbc/HYvpQ0oEVxN4mUY6W4XVcuv++p23PqfY4ENrzKajkCIf+LPujy/scn1nXwgrMi1kIxjX3be/xb7SxKhZ6UlMqBeh4BW1bh2wGEVWoQCPILZgW2k5Ie7MflvvOtLZSXjcpfYWKSbs0JanflSj7aeg5fXRxYB2iXscpTOMEC2sM6Z7XR3gm//bCgcxSI3a9V53ecDf9gNyRifY/EgMsWtWvZiKI0dQTjKhaJR5f/a8NYH/9MCUdbem+tPTkzphy+dcbBBok/FMPaCHTb2mnjmg93QpZD3+b3mmlUtWflQuxW2QqSdO64yKL9Mkm4AHSfibVbfPgrSIHC3lRo0J/i4vg7nswvJZS/S7ypiJAcG7qbFOf6X/HGYD+GQ8+zfW+mcoGhKCO1cvDRiIU3woeQ2nRMkCNcl1sDJ3wVYh7DGoPvSFx54rHXMPJtWiJPZYo1xYRswZT74Fa7VnC86g8Ort5wLSssIoDlMxBjMizulxvzD4++9Tt00hQMFyIl/Kgm3LVasc8UrcY5wJI9/YjN+VhL8r7KjxVaPSHFB8irsb1D4xN37d1GLtpN269WTbBjAMF91zuPCirwRgZLjzVHlyOlAEDJq3fGYSWf89+Aw5kD6gtkw4r/4e9lrb9teygLXE3fKucR
 /EfS1gVV
 0AstPGqzb9BUnAC6uvuZsUVnUJVvADubz72SdoB0k7lNMvpteFHrp2UMwFNk4MdPc9DWPvBOUHQjsOjkSuCtNEXUmrB/NW6Gf7k75wvaH1VRj+Nh0WhlIZMZejFBrKBhpb44s+tb/Zd7fVNzQ/Xlr+Wlj/m9TT5tbdgTUVwj4lhRoC1W21AKRTwnI6kZH1VFvxni2CTnI396TPzAbRNad+WWX3+hAUuCF88xEIvJiVoggfysHd3/KAK6B2cJE3Ss5L1UyvtMGQyJTdmKa7tgymRmO/bieIfEpMkIhmWfCFkFBRhKoXG0vadb4uFap6i7hSgheAYA9hVaW8LxZ2iLP9C7fCcvExmqj+4n7r0R3cF9JYp6WRT24sCyPqkSphzNJVXCrZeNnrL0+S9jwsjSOd8KqROBS6DN3bMFJwFON5VwEBsHz8kXzI/VmS1QkTuD/Ag980TX59v+VQ2HAtKrRtjsM+eETmQKuMp9vpvUjW9JzuNJSAHCW0YRVIYYB9GAZfZmGfEfrndrKk+cbRNCKus5h1xMDkKbkB6SSQta60v5pnl8TJc6d36mpqaAYFENivqv8hSKvkjaAly6IlCY3psPiNw4/3z7YN6HnARMFL83zKOmiAS3zz7M53cW+PIflGZKin19sENlIqalvq2Pbh13hIyDUz8T4yKZi3AvnXrbH0ZJnprAO0nlgtQKkm6DjLWf6uP+bVBB11xLcENG/IaYl06feCVoly2xYE6wDsqbzE99nt0ubhdeNRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch clarifies the definition of MF_DELAYED to represent cases
where a folio's removal is initiated but not immediately completed
(e.g., due to remaining metadata references).

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..4f143334d5a1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -862,9 +862,10 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
  * by the m-f() handler immediately.
  *
  * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.
- * The page is unmapped, and is removed from the LRU or file mapping.
- * An attempt to access the page again will trigger page fault and the
- * PF handler will kill the process.
+ * It means the page was partially isolated (e.g. removed from file mapping
+ * or the LRU) but full cleanup is deferred (e.g. the metadata for the
+ * memory, as in struct page/folio, is still referenced). Any further
+ * access to the page will result in the process being killed.
  *
  * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
  * The page has been completely isolated, that is, unmapped, taken out of

-- 
2.53.0.959.g497ff81fa9-goog


