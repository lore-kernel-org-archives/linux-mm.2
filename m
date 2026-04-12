Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF12FE93807
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 22:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88E56B0095; Sun, 12 Apr 2026 18:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E8D6B0096; Sun, 12 Apr 2026 18:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D751F6B0098; Sun, 12 Apr 2026 18:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7E686B0095
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:51:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60E2F8C863
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:00 +0000 (UTC)
X-FDA: 84651400680.13.622C659
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25BB0C000C
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:50:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IABUpWQw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776034258; a=rsa-sha256;
	cv=none;
	b=QJSbiAR+EPwNedZeDXuFKbfxrAwLGLRcsKJkNMPnpq9gDs4xqPNAfcVbYyiYcewmFV64Hr
	/fZSKQ1Q8pWVrHnUypb49VFop9sqyYXMIR21mtQjHlQLXmOh5YMT4xtUs3oEM79LF/WC1C
	9TJBvRJAOhwklNn8vW0wW/19jtgVfn0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IABUpWQw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776034258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFX8n0nPntDWisBxedrwOsXfOmZ1OSsMtUQjLyBO7ck=;
	b=f27pKJ4dWrV8MJkTgwcXFWSsW2XVkVvn90nRIbguXXuQz3LDG7ueo3L44VTP4omwL7AJ3r
	bpcLd5bz5xMFqhsZmm9iaVVRUO6Mawjht3dIDpvYrd9nUAgOnUEVm4s0PO/kIVQFSobmgE
	ORmabbqYvSD1SkFu+yTwGAoTw6vJ1+g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776034257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KFX8n0nPntDWisBxedrwOsXfOmZ1OSsMtUQjLyBO7ck=;
	b=IABUpWQw/lGVFgTh0ebihC5sWxM1hZ+twgt5Cz+J2OtGQQIKb/Edo+XsjX1cHX2V7tlfoy
	vCzqvBo94zIXKOFRuw0cPsqrYhdWaHMpIdRUNWwdkjLGkw99yIfG8cHZ2V3lYhu7ncF5DH
	Bd3xiIYDt2JLb/M3j8zd3RXAfkB/a5o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-Xl3tizHPOLGo83HtRE8FcQ-1; Sun, 12 Apr 2026 18:50:56 -0400
X-MC-Unique: Xl3tizHPOLGo83HtRE8FcQ-1
X-Mimecast-MFC-AGG-ID: Xl3tizHPOLGo83HtRE8FcQ_1776034255
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488e3fd89e5so4980405e9.1
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:50:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776034255; x=1776639055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KFX8n0nPntDWisBxedrwOsXfOmZ1OSsMtUQjLyBO7ck=;
        b=mCc5+FpE584or82MtbEojGWQcGacurO/KZelBCzZ+fPAqfRRQiL9JO/I2Y4b/3ezF9
         Ph2S8ZvXKlLdWYUC3gIkkTi22roWGJ9zNr3hqIG8svTpb90xq3eXvg1+olViDfpVYijW
         p3CAifooxSrGQKmsuk8NIvUCeO8yEDZam+PMFT6txDy5+Vx9anPT974VtJZ5bqugHkDH
         R6N9hhgxG2toHhVN0EiCX3K58MraxbKp/EYqj0LPfqOYYyn+oVNStf9buY5EkplNV+qk
         vtPz8PCDK7IvJZdmRQfu0BJSoktW8s6I46WjnehxARBrV8C1Tc6GoxQstaYk2E4wfFSm
         gWvg==
X-Forwarded-Encrypted: i=1; AFNElJ+rDB9G3kobWZFYX10I3Iy5mLQzrIt8ApBSUHKhMONLIxH6+iEN+frZfI038fzfyTlurSvfvEdHkw==@kvack.org
X-Gm-Message-State: AOJu0YyOLfHR+FvnPMKqz6oBaUfTfSuAYGSiptLkjVA+fMTWzPih0MSh
	++0bkTUxVnRH8xFn1zeEi41419UzCajOXh5yF5QodcizU5HPRge368J1qQfkdTk51/yCRjPHPW3
	UkjCq9Wm+Gr429SaPuzjmacVsUIXPXjDNljImeQoXMInanwrQrUFl
X-Gm-Gg: AeBDieuk6E0WLfgwHMgOjyk2S1I0PxP5NcxUSr4eVxNPOEoGS2GAqF9guVgD00oAf4K
	S4WccJ9cZdhU3duJJi5AW2BnWTuR7kwQauI5hH4AMWnMG/uRW1Mb+3gRJZbHKo14mK0slBeGypk
	OcVI+OcURCQnjIzpzrASpYqMWdyw303qQR+BDzrdDZ3hpmyVVTipmWEOwnmd5VTsmKSV9cer/xc
	Ovw6sy5EbJS64B6UxZVOI4UrUqwZVdKTNknb3NFVF8Y77E7ILP/o5joG4lNm4VVChPHtgCdUmiF
	Q8/h+Lav0+hObDA8UVcK409AU3/zl3/ixtH7xFxGcq7Kn1o8G2GLlCiu0oolLE3jY5KPbeM9ZHq
	lpURY7nKwrq9TvUEsssf9pH5vQLecO7q9YU5RaCncO5Y=
X-Received: by 2002:a5d:6e5e:0:b0:43c:f5d0:4f6a with SMTP id ffacd0b85a97d-43d595cd582mr15728272f8f.21.1776034254656;
        Sun, 12 Apr 2026 15:50:54 -0700 (PDT)
X-Received: by 2002:a5d:6e5e:0:b0:43c:f5d0:4f6a with SMTP id ffacd0b85a97d-43d595cd582mr15728249f8f.21.1776034254149;
        Sun, 12 Apr 2026 15:50:54 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63dec27fsm27061714f8f.11.2026.04.12.15.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 15:50:52 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:50:50 -0400
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
Subject: [PATCH RFC 4/9] mm: skip zeroing in vma_alloc_zeroed_movable_folio
 for pre-zeroed pages
Message-ID: <027a31beac698f90e76aa68ba6a6101ba60246d0.1776033771.git.mst@redhat.com>
References: <cover.1776033471.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776033471.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oHaWrfr8Vd-Q7AHV7t07cL53RnKRlhMG5rEnr9R32j4_1776034255
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: pqmnpz7zkdqu6bkn6kdzzmaoimkf389f
X-Rspamd-Queue-Id: 25BB0C000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776034257-900910
X-HE-Meta: U2FsdGVkX195q4tda5yMlNziz97Tp3FhZ7kHaxFNqPMJdlJx0P8uUMSlqbY4RhF7ADl7WkIMLip/ah68tsgRpcUXrVvv7gcGsnTnWL5LLyeioMHwlg8i6q4YvJD68vjrztovh1ZuyEARF1oOBkhElC2Oh+SNNaywVhdyohbedcnzUTDqoDtX3VgslETsfl9944gGSxi4JbROQ+6gVGIPr6lwoanUdRKcsw5ZoHgrJAYqXLqOO78CYBkwmQH8z9NgWDPASFRmQxz5clpkGxRv+OKQhIqJou4/JXO7vIN6rEtoirUTNK/8xmcPTn2xWz0TDDry1aRC65kYdN5VOl1QoMhy9NiAXolnOxPMBi8TvrfVTvDRfXXitzIBaJsgJmxumozqYqnTW3hwC6ygRRvdmrBVPZz0uYjuYLmpdMGERqtf5mkOg7GvnZCnZNw0u7+bbFSOAoNlAYIGULMg5SM5Us0ELapTutXjCoIBX8PiT1naXY7WTR7UfKrVYd3UOhp7fSzBR2xmhj26rpxGwVeVRnn8z4PZlxOO/Ig7iZy9i3g2fBUq13AsLa4ualtuvh+lZUBTZa2HyG8yfIQ4l2DWFvN1/djZ3GZZqY0FHurkjWRcKa8aONK/S5zA3paQS7IWxRu/tx87OU8qiacts/Xasi7Iv+w54fURKoiukfAzzcEWWuZy311PcV8omMoSwOH+9+Q3X3B71wS+CPMIxiUcwcZmnqzusfSWcOIlbWricqnfKQPUWSFqnYz2NMyDifB17payNNE2plu2mles8LYd/VnJWgDVWxleAR8qVKpMSCpBR5CaXSxcK2VqKVoSiwOafsyaomFXLG4Ad7gmrLF0eFgkDgsyBZBtUCR4aR+g+gujRQ2yFhkkYOhIF1ptDrtH8o8DtVusZyJ5aBgrW1eeiKmG1yd3vm4tfuVKTS58kqzGo/Xcvf367Vx9HOHUsT7I5ijs7bSOmLEFF0KTKBp
 4UuAypDs
 bbFL5t4SGj9Kr36M2x9A/44BLJCKiHg6ZXhvfoBvAY6uALgdpcmz8biVxqe7GxFOfIh+ijd5jD++3+E7EV9BaHEXqF/yeUbt6i7bf5GMQmsOdps7PG9IZ8lB8wo5MuwoOc8wPYelVuJ8BRa8UxveWIp8Y2sZ8v8AQEH780oorGOEpETkfZZ2MbAWivEnGgG6sS2fRAvWxf3YhkxwPaCkhcPjWhRhN1C3zHfmwx8YigO3/zjcketHzeEf+uzvQdnlaJxxVBiaowUzW9sPoLd2p5dm7bGxOHMBjGQ3y6nz8VBkGnHPabb+h9oZ6gYtW/XNQ9k92eySQc7kS3h2KNsRakZxdL8/K1lfrWBaWWDbgvb2b5sVCTOJoCRMHAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use __GFP_PREZEROED and folio_test_clear_prezeroed() to skip
clear_user_highpage() when the page is already zeroed.

On x86, vma_alloc_zeroed_movable_folio is overridden by a macro
that uses __GFP_ZERO directly, so this change has no effect there.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/highmem.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..b649e7e315f4 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -322,8 +322,10 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 {
 	struct folio *folio;
 
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
-	if (folio && user_alloc_needs_zeroing())
+	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_PREZEROED,
+			       0, vma, vaddr);
+	if (folio && user_alloc_needs_zeroing() &&
+	    !folio_test_clear_prezeroed(folio))
 		clear_user_highpage(&folio->page, vaddr);
 
 	return folio;
-- 
MST


