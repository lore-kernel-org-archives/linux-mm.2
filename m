Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD567E93807
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 22:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538BA6B0096; Sun, 12 Apr 2026 18:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510386B0098; Sun, 12 Apr 2026 18:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426EA6B0099; Sun, 12 Apr 2026 18:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 308EA6B0096
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:51:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B93218CE74
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:03 +0000 (UTC)
X-FDA: 84651400806.24.67E2856
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88FDE40003
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HvMhdOti;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776034261; a=rsa-sha256;
	cv=none;
	b=bDJg5R8bXAX+zVL7vQkfn6Xq85vs20HAo3733vPXK9737PIbWVcsrLLgqyemcoVUdEkGYV
	WwBWMNo00dd03/+k7kF/EPMiiSh/jznS15ruwNQXvVuQ5/Yppx8cKTxJCyYuuX9ggB4QyU
	IRA8PFjnEHFu9qTwjI/zc9htvNm9oig=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HvMhdOti;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776034261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZObZy/vetFZ/0CGX/0sKWeCj7TXTkOR8AcV2oS2lySk=;
	b=3wEfw4l8NQUNq1FCZqjpRYhuML2DfTMRKa3OYajefNl9gpCFdYtOV6IpejfM0SI8LRJZ95
	2zOt3JarR0Z7bFE2fmwdbZVtnqHVI+LR75CHCKLj3wiJgo1jAlv/e62QWvYcCYLkvfcRK2
	8pDvravQqMHSrWKdQr7o5fRTfSyiWPQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776034260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZObZy/vetFZ/0CGX/0sKWeCj7TXTkOR8AcV2oS2lySk=;
	b=HvMhdOtibyxBwhAWHaNAFk3A6aBGnH/GzAku+k13qfIPXWWrFxxd6xPEQXzlOcmTQPyyQb
	BV8TRHzxYkSwWzdbf/hCNVXOJxfCWPlx2t0f54LexKCFugm9clGyG1aWKAvD676rfWjA66
	NOYkxl2XlWx1zlBZ4kecp6ADBn5E9/o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-LAK4itmyMbSuQwZXmwpB4A-1; Sun, 12 Apr 2026 18:50:59 -0400
X-MC-Unique: LAK4itmyMbSuQwZXmwpB4A-1
X-Mimecast-MFC-AGG-ID: LAK4itmyMbSuQwZXmwpB4A_1776034258
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43d6d0abbeeso826907f8f.3
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776034258; x=1776639058;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZObZy/vetFZ/0CGX/0sKWeCj7TXTkOR8AcV2oS2lySk=;
        b=RE0xliTttpEs2VSV0XhAOU2fSF4SSriG0S8cDtwT2mEQbZ/k8d9saXj/QAviSklFOV
         lTybfBoxfmW7AhGyitaB0g5gldt8iFt+xbs0khfmJBFiSywM9ppogLREQvpiXe8gZua9
         Q7zC2/kHnTFFtC+hjsiOfBwW6uNt9g3VlvFaeXJEdNDghr/JP0uSV1WZbhYeTNzJMbhI
         cyy7JSrf/T4EKsEBX/ZWP4RoocD+sxb72ea0T8x0BR3DK6rMGYqSTAARCRx0lS4Nlb70
         w+FKPH4sburD557EO/Wghzg8D5n4rmWAjYJQDFq3Ly6W6EXlVVKtksgm3abXO/stTQFt
         TjwA==
X-Forwarded-Encrypted: i=1; AFNElJ/IndUtebOMsmQBuTFKQy9afQY9O1RYOS4hw6wxYSNZ5aI4xL8dwh4w3yV5p0rQ7ueUApG/lHnX4w==@kvack.org
X-Gm-Message-State: AOJu0YxGM3Qj/uYQcQkee7sYgSZe68LmZ//OFUgGB4KgdxlRWMkfWsyE
	V+lqZud5zRFzPR5vCm/dIHGyq3u2BpKLPDxTtgVMSctZugLPWP2ibFcp7hf6VQybT36gDMhe5xY
	tTNFHlQWVEELDSoYmfXrknGdrJTwI0ZC0VDxvau07adJNro1FLK7Y
X-Gm-Gg: AeBDiesBr1gXOcM1kVoD0iqm000SHYq871aFZvq1zxRMCErc82qZprzLAzHHOMyS+Q1
	uGgnfOacdY/pQUaq7CYI+8MZ4IbK1UrQquAEjasmmVlSTwT8acyFpbR5Lfnk4tmOtg0sm5DLXBc
	F2hB//4hdOtIFlU1ln4lpbva9keuazAZus50z0kRk3m7BGc4RODM34y3hCpbx+H1F8OrTbH1hL0
	7HpT5kNpxvOcmCtV+ztXUKiwJ1TB7m7mTcRVqt/RRIwzm1bgnt4PE/xvsoNzfo782fkIV4N8whr
	91oDBwep85LDkPVvvn41MEk39vVCGhfzDRzpJqtPWawQWiimzvaPQ06aiyVC2fQpMuaVQQSW+tz
	3VlleiM1d0QytyGsbIvmlzzv51zRGX4SU8MnF7a/WxPQ=
X-Received: by 2002:a05:6000:250f:b0:43d:1c7a:8b5b with SMTP id ffacd0b85a97d-43d642d1d00mr16517155f8f.40.1776034258040;
        Sun, 12 Apr 2026 15:50:58 -0700 (PDT)
X-Received: by 2002:a05:6000:250f:b0:43d:1c7a:8b5b with SMTP id ffacd0b85a97d-43d642d1d00mr16517133f8f.40.1776034257540;
        Sun, 12 Apr 2026 15:50:57 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d7400708dsm9145343f8f.25.2026.04.12.15.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 15:50:56 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:50:54 -0400
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC 5/9] mm: skip zeroing in alloc_anon_folio for pre-zeroed
 pages
Message-ID: <56ae30d7f080b089e4fdc93c4d6e2353a9e0123a.1776033771.git.mst@redhat.com>
References: <cover.1776033471.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776033471.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a-jZxyGHiCSuznza2X1KbjzVWByZmcBpoPtmAfxCDSU_1776034258
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 88FDE40003
X-Stat-Signature: 5a1fptekfd16qhwdpbo77ys9uiorbb5s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776034261-897490
X-HE-Meta: U2FsdGVkX18Yo89l9hGCwZ/cjLaCVn7wRxkzRozaU0nf9BEeY6JAV+6I8jpvEbnurWvG4NVZJXdvE01DjUceVurDDagE+XL2EgwNAXJiaCp+47OnHNw0sgkOJLpUDgmE6KuETMuhG/QMNU1STqDAdm77nUxrc2RsZZcBXelvX15R/iLsomo2DZJ3ECqSKlW66Glz8HSPFxI9XkkssimjJSkAyjPIyWIbigIDlYyfMdxRs77mQ87DCwCw99u5qV5donBfLM2YOjAXPl6ngWvYTbkeeGqC8/Umxh2zmcqL1iFizk0l6tbuZngsBFA4ssxEjNuhjzE2NpSMN7TUZ6IJhnHlpA5X4fYrk9yoQCJBVBkOxOI6ahD5g2os0p6egN6vZwaxyLo/I+YVHjn/cg8wj9KsJzBiz9y6zo/qBkGTLGIb27yLxmY1LB46UGrfbcJo78HT+P1PXJ/4Al40y4MSx88gSrENz7baVgX3zHAzIs0YDosVN5Ro1deqg7csDqaaXSLss3hHpZwy/A/S/hJdfWLkj+UQq2JaoWu0SwvY+QnK658UzDEQMyWHF3ljSZX59JWqRFRmVAk5Q3jhNF+vF4RzDDEjHOamOMLAwXU/N6aiHdFayW1v1DPTDa+3aOJr81s5JsT3IL/w6/5q2BgGdr2VtJIc0tTZ8aYaJwSAbqRuPUMD1UOKuLSkFnXpqvGwB4QIpXH4ser+/CkT/KdYMqHAOvgYw7xen3s8+O1//DIdsxcFrieXS1O/yvoTbSK58M0SraX1Ba+HqG+FwmuC/8Z/f/I2douDPGEmn7g4Yqb+X0gG00wOSvthcuwtLJ193PZpRCQPIl38p+1ZGjRvAQKO9e0MsEnTVzyyVTfWlCB2fcFTGX/5pz6u1bebxWqlsHCaeL8DfhzCwiJapIZNfvrmqJKBAtQAvZ7opoPQp1SDs/dl9ZljC710dk04QbWMfrpBZJpei4DTp9R97fk
 WDa/s7KG
 qi8SXD2w+J7QM9LMVdEq23+IY+XqtQOrJNShlal386uj1a9YlQVSD4+aygw69oW8l2RLOF7FezBh10APB2eBYnYSzCkLXkqMlv83eF+LifRbrt5tk1A3dbj7FCXRr3W5fmuTNzdAPanwOIIiuvh+JVkm4o1GZzfZu6zga+zH+YoOU3JF/Nu7QCKrBy8j4OekcIlzHu95FccSXtmeyRqwJhmyF57ZqyqntT7uQft4x7LiSvp+imFiSBFsyKtz98bbUyBlEoVhABp3WpJmZV52Wv2eGOAQBVbuEhEvw+ak/uZLfSnNNf9BGRZueI0t895gcmUoUoaZnjzpVUKV/BeLFkHUzxG5pBX7t6LauFNVWuWJKyLSC23UnRBzHvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use __GFP_PREZEROED and folio_test_clear_prezeroed() to skip
folio_zero_user() in the mTHP anonymous page allocation path
when the page is already zeroed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 07778814b4a8..2f61321a81fd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5176,7 +5176,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma);
+	gfp = vma_thp_gfp_mask(vma) | __GFP_PREZEROED;
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vma, addr);
@@ -5194,7 +5194,8 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 			 * that the page corresponding to the faulting address
 			 * will be hot in the cache after zeroing.
 			 */
-			if (user_alloc_needs_zeroing())
+			if (user_alloc_needs_zeroing() &&
+			    !folio_test_clear_prezeroed(folio))
 				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
-- 
MST


