Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD19AF94CB5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972A26B0089; Tue, 21 Apr 2026 18:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9227F6B008A; Tue, 21 Apr 2026 18:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F0F6B008C; Tue, 21 Apr 2026 18:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FFA66B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14D7A5E998
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:25 +0000 (UTC)
X-FDA: 84683934930.25.3341179
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id BF74D180003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BnEaIBwH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dn5xupL5V4qF15edJs01tgV6QOrsZ1JWzK8CN9u8yrs=;
	b=gSycUN0G37wNNd+f5FpCU2xQIcC6vEdgMstuob998/9f4soGaUVgb9gyfNOxoqzHDwCelg
	OJRuvjDRsmO5ACQEdGdl1ZMdUr8B5eaM5SfVv2AgS7dCcTnUQi4G7C3TNuba6HgYZdmpZS
	MmV5TCviefNuWd2BiGk2iObxeZon3w4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BnEaIBwH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808882; a=rsa-sha256;
	cv=none;
	b=mAbmnT6iW4B36NCeyG9V+paMkebGKzScNSzoBgbKpJh/OUb5uur8GuhOjAhIr9FJrSiZNc
	5DwLTiJuofwEVYWYgr1R/M3g7TMHlbCy5zIwmcWMjsgHb44jo/mOhLxX+rgt3UAgNXoLrR
	kiKgMS0CjLj5GZ7g6cY3JJiXJsmQANM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dn5xupL5V4qF15edJs01tgV6QOrsZ1JWzK8CN9u8yrs=;
	b=BnEaIBwHg0DmQBiMMo7rNi07jDmfjgA0gwy4Ztu2XQpKt5LfGFeZnDiQ+9bOTr4NLgMaAm
	ydxmDAjmlkdMPW7HH2o4ubcy8WYHQE5IeydINVsH19Uh6pAggBSUEzbNtJWK5NMe3dr927
	eMaBj81dtRReCTRwpYxxbQ0fXQh0p4I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-wpki9E58Np-x-McFOlGD9g-1; Tue, 21 Apr 2026 18:01:20 -0400
X-MC-Unique: wpki9E58Np-x-McFOlGD9g-1
X-Mimecast-MFC-AGG-ID: wpki9E58Np-x-McFOlGD9g_1776808880
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso53362675e9.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808879; x=1777413679;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dn5xupL5V4qF15edJs01tgV6QOrsZ1JWzK8CN9u8yrs=;
        b=U3bV0LcDm0hkPyEky5hDbicQNw+TXjaaEFMQJM/1GG78WvQVl+Gp8tnjCsk5xCM+Ip
         aI1iugWCjzoVVFp1Oy4U2EHxvduZ3i4JEj/JKYuPk59WO8bkb4P64kPBmmy5v5GHRqXI
         LGnWFTCMZLxyJT7gBVIb6i64GLP2jyzghWIpnWcBo6PpXZkWolMBwGAklkZN46cMuJme
         XXPts5GwNSAo7hO6QxOtAb1C6HDbwMoBuJTQShuAkdOU4sUndaoJ8RqFDlkCPjnkomBE
         A1jiQcyA3nlrrRmbxS6P+8VS7gnaj3NiL4TeZLTOK7vIAFrILgXQTJ2faGw0E0dHK+IY
         DIuA==
X-Forwarded-Encrypted: i=1; AFNElJ/UrsWo6lEK0gDDpQpjS85txByiE6Iu/04O7FOmd+c2XdUm+q32zZ9h1nYdmK3H5sGHJ2+Pw0e+Mg==@kvack.org
X-Gm-Message-State: AOJu0YwZWVnlGN3DWjb6ZsTToMOBKl49PEAkzHQDhgYcm1X13hMivs+y
	FpYLaUab1rXVFzYhizn1IcWk4picAG2TE0wdieB8cJSRjUOlodUwzUMJdUSHJCfVORbcFYjPf8E
	k+BdguG1xgkKXYZRE+z/WUEWf/4BO8SNBIPm6G6cc6Sx9NXOx2Ynb
X-Gm-Gg: AeBDievaMBcPWPCyE99cQW9Zn3XYpBaanHIJ1kwwW/6yzZPB/FFk1X/UBmvfKAH/qvJ
	Xod92GMYXH0JCZ8hSm/IK5yJ+NARsqaub4VMDsJzRX4GYRnveOr+UY2zW/rnfYDjU0kLGF4rd99
	G7TBGe1cETdRdV+qD3P9NPfUf0F8cuKUMnBVNE2I7DKXWIJKDJWZlsgmU66pDf64nMKTvSN23eb
	+qWMMGKOEe6EIoqijLSKH2DMWkRdzPy9BF0dOubMwS1kqXy/UVGg89jmCvcIJAe+zR5Jw7/sCqs
	a2XH8NW4dn+W+iBfDWe31Vnk0T1ql1OPbu8fhGp5XT0k9mxfPvUrrm9Ovm+eqDqOlZeyFeUTq/w
	qGkZigoAAotHQVGr5rejsyOUDTIgOl0NlWSedDaJfZ4RRJgVAw2O7bw==
X-Received: by 2002:a05:600c:1e09:b0:48a:592c:e655 with SMTP id 5b1f17b1804b1-48a592ce7c2mr22291625e9.17.1776808879625;
        Tue, 21 Apr 2026 15:01:19 -0700 (PDT)
X-Received: by 2002:a05:600c:1e09:b0:48a:592c:e655 with SMTP id 5b1f17b1804b1-48a592ce7c2mr22291235e9.17.1776808879144;
        Tue, 21 Apr 2026 15:01:19 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891df9e50asm153245945e9.0.2026.04.21.15.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:18 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:16 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v3 02/19] mm: add folio_zero_user stub for configs
 without THP/HUGETLBFS
Message-ID: <2c8e630afa8b68232d648c08eec4b2fc7d933dc1.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pk-G2je0K52DsQihnDMY9AO18daDC-xY9xatv9FZpQw_1776808880
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF74D180003
X-Stat-Signature: j9e9o1jutf59cb47dgjpjbe1oqpxwiri
X-HE-Tag: 1776808882-820141
X-HE-Meta: U2FsdGVkX19S8vyBj6SydniWT+Oq5L3BJE86wyqwty92M4bl/riIWGYHcA0r+zjw6XqKjIVAzHiqIBZbB6YehzURLpw2uUWMjHmDmwOfgCahuSKL3vOmEBD+Ol4xx/L2Sn5PxzfOWAUmPApRZ6sLIqw9UmQMxWsTUYr5ZyYt6WGrX3hqdqLE7IaJ2nV9ZPvVAgfnEXu2h82Kk/FGj6LKSRazl3vIeVfM1H2rGhicB+pXqBxZWddylrqBtt7RMxQYAVouJIb7crGIn9c7977H4kJ0r3izSdl4KnIsfXXXgG3HWk9BTUXj3Wfx2jkN0449NSBVCGCjxCjcD+Qut2c1H0r/csu6nF8pqdYcfn8HagzrQGDwWJyliH7FOSZBfDNyplsBOoxatWTErNJGigfvMivkJNYt5kNJgR1WfbVjjI2paYypfbkyg9soayuWZn+STVVoAhDosmQMD1pz1jZJ5ak2xEASqQyYtbCzo5ppos/bofskXxKzEUhjCJZnNmWmboH7m9mrss675IhS3CJ0ezPO9OZNOMYU+JvGgmwyIWfiRPicgvPoFlfvHrCwBE5WI40AVBhkGdLrWwrVe2JUovLZVyweIz1FMLy/30L8/kC3Y55exb0rb/TVH8uHUEOGE9/96n3tjpqR8Hm+U7U+qeKehk3LEMNBHJGI72ZG1/zymnbjblpTjNYYHbYDdRcbZlCudbS+/q7Aegkr5xmmNxEfYxk9iOSFocKpeUGGraAUzUcP19es9dTG1vvPLNtuUNoEfOHdlYA97/p/2sON6iFpbH3AGAxjfFGuP6nCg0ybxIZprNRqTi/EvvPk3DNe4ivHPG7OKc/rWYupYQtkRhxWNeC1HU5uOJnB3FrNf65eqCj5CurERKYDqEQQFc3t2912RyBxVfF0kEdubeZD1TqsxvqdGSbJTM+INhPcb1DJDACZHUQU5TbF1KeRjEEADOrkpUS1ea+PqeB1Z4k
 uUjtky9Z
 cFdRW+J2OvR4CGTdeTFnxbPA0cSsgsVLAK8M6ss8zVinPc8tT22Y4UYfonMDP0m9ItFi82x41+vIloTCd9gpRc6UFlU7wxnyLtCdvueSTKIUp2VuI7o7jUSkvIX3HA3wH1d46zvdU4PQS4u9iBpxa3rXf1duZawGfBy9jVJfixBCL9zqpw2x/PCCruLQEW7rbMREivUAs/khVObKsfjk47FFtnBiE/IP4xRxJk1q4uTPycYT4WeI+t6kNVpNfF4IUHlCPa0+dKURIYfmhOvFITurx+7Km/ATNDmHmjzHg+trzoY3zapR5eUY718Od7JIakQJhCI3yGrvNPVf09Iv35RPALc/Fb6VY65NsRTaJwBKtSYNjJ+zzJIcvWxdKkpcaWv7Xjan+zFcLOyCHhAaPuzXKUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_zero_user() is defined in mm/memory.c under
CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS.  A subsequent patch
will call it from post_alloc_hook() for all user page zeroing, so
configs without THP or HUGETLBFS will need a stub.

Add a macro in the #else branch that falls back to
clear_user_highpages(), which handles cache aliasing correctly on
VIPT architectures and is always available via highmem.h.

Without THP/HUGETLBFS, only order-0 user pages are allocated, so
the locality optimization in the real folio_zero_user() (zero near
the faulting address last) is not needed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/mm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..541d36e5e420 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4718,6 +4718,9 @@ static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
 				   (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
 }
 
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE && !CONFIG_HUGETLBFS */
+#define folio_zero_user(folio, addr_hint) \
+	clear_user_highpages(&(folio)->page, (addr_hint), folio_nr_pages(folio))
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if MAX_NUMNODES > 1
-- 
MST


