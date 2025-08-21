Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9317ACA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5998E0035; Thu, 21 Aug 2025 16:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80168E0036; Thu, 21 Aug 2025 16:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE788E0035; Thu, 21 Aug 2025 16:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69A9C8E0035
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 367EF14054B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:57 +0000 (UTC)
X-FDA: 83801850594.23.99AB64C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 01513140003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gw13t9nD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806875; a=rsa-sha256;
	cv=none;
	b=EdDMbiJFA/4qgnFNoqGdom7rEYSQPf9Y9ca5NtKVD7rVUEbO8WR66GUtRLuhPKCuUSBx0a
	uSd2QvkTABVJFLEK7f2n/a5aqD/AtxHmCv6HYENQFJJEKy2reUdTyX8r8k/r8s4B/ZoLMC
	8b7fQOs6t781FLSaV1PjTlItJHYlYB4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gw13t9nD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCvnB/7xI7T/4p4mwWx/D4+W6s//h9G2+oSyfbDOFZs=;
	b=rvlffl5+R1an79xQFp/o59N5BDsk6tgrDP1HQ8UlqFKtf0jb+c/ZwBAFLbJn6mH3+RHXWC
	vOQCaoqZet412ImBjjpJWqXOR3H6OnpdBVYvzauTUx3gQzm3yMitXfEv+bfa7q/eEcY616
	JNO6usv5xnXM/Bf7iP5sJ/DwuqOgF2A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QCvnB/7xI7T/4p4mwWx/D4+W6s//h9G2+oSyfbDOFZs=;
	b=gw13t9nDpGG3U2GGHMcx/2sRRR9KRkg1799gYSbpZQy4XI+pCFyIp7adDzu0khQO8BlEpD
	lsze6by2yDpulNWR+PJFam3a3xB1nScMtY6y+/YUHGdU/1aG7lVsqZTdUdI9gZXt0cQ3+e
	lab+ur2ji94m2LOBF2zm59gUmk9HE54=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-0jfjvKT2MauTv6UIVuyEPg-1; Thu, 21 Aug 2025 16:07:53 -0400
X-MC-Unique: 0jfjvKT2MauTv6UIVuyEPg-1
X-Mimecast-MFC-AGG-ID: 0jfjvKT2MauTv6UIVuyEPg_1755806872
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b05b15eso10519575e9.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806872; x=1756411672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QCvnB/7xI7T/4p4mwWx/D4+W6s//h9G2+oSyfbDOFZs=;
        b=usdsBhaYFTFoFQ0R3k6QKuetdQltDBPD5XPzX2lwCRLI5d5GlvCjof9dug5rlWghOl
         AfkqaXBkMUy3EfFCa3qLDeIpGFmx0URX5hiaD3OTOPpaAOu81WuLgGJ9NGEdotJbjXhE
         DLnPOPQKTnevPHgjEbpNuqA0FYavxGCI2CRJlGTJIYNz0l6Uh9fSJ22sRZaxiHUIc9yW
         DiIXSICPyf5wZESWiflKKwRWID2CUNUjlCB5XqYOa6dtbF0UFXvNIDQn7EYZGpDDx56X
         Y7Byh3mnMZr3HKN2qndKoE6ekDhKcujSQJ9Ev4o9jGfTWGLYR888ziN1yRM7+8nS5zbJ
         w3NA==
X-Forwarded-Encrypted: i=1; AJvYcCXpapv0L2leQKojLhRpKZohyCn65Ph9B3vu/bmm2dlDuXdsTJVNGSCdNbnZErdSTEce1fXDTxpyfg==@kvack.org
X-Gm-Message-State: AOJu0YxEvBaewVK9Crniqu2FTgo5NuecJeQdmc65Uf9hdLEHB3AGdCow
	f9HxjbviIIbX86B8cvaJgJwJmjzuoTFTIzNf69iK6WeDhhxdZc9zdqFGRF3dYQBkTb4ABxEfuQp
	MhEq2ns/H/MQvcRJmiMn/P7s0GtCIVxGe+tbvpADq0PlIir/6cQHq
X-Gm-Gg: ASbGnctsfYy1eboOFhB5uTwyXrGVSv/wLUQ/bEK6xgxGJhLn7a/0sNEy9z/DZp7Hmt1
	dlqPzsEkO1Fl5V5fRnhqOEFjvRqQoDHGqLl9xrEKvYgW01ZBOB2FmbBUMBoeUwrN+BaQ734mjad
	FqkE7EoOOz36QRqBao1WYuf53LUg1ZG04HP9AGmSMAqYCqItI414Wq2OidKFz5hOpQ3k1tMlo+v
	4/6xF84PiBYgT67J/IHYzE1/EplpQbgFLBxvgWvyhcBkZhQCL3rt4BA2MK9/Sirj+/78h/tWQUA
	U74oWvlez6uJ4TnJn38b8giYTwhTkOuMoxpG0xAUBINefMNO5nEtuD78t1kueOCOTQj6x6XcgRA
	iT/YI7e+pyHhNYx+TF7Jotg==
X-Received: by 2002:a05:600c:1d07:b0:459:e025:8c40 with SMTP id 5b1f17b1804b1-45b5179e897mr2279065e9.10.1755806871606;
        Thu, 21 Aug 2025 13:07:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQe1GSIQC6LfutgynQLrqB1o4Jo0GTrBjlhxRWjM7nqTD8l8oEo1HOcPxtIuVQVn3tsHm8QA==
X-Received: by 2002:a05:600c:1d07:b0:459:e025:8c40 with SMTP id 5b1f17b1804b1-45b5179e897mr2278575e9.10.1755806871147;
        Thu, 21 Aug 2025 13:07:51 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b4e1d77e0sm22159155e9.0.2025.08.21.13.07.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:50 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 16/35] mm/pagewalk: drop nth_page() usage within folio in folio_walk_start()
Date: Thu, 21 Aug 2025 22:06:42 +0200
Message-ID: <20250821200701.1329277-17-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -vx2wsSo0tErWqAFEfUw3vMId2vve86PST_4Kl81xWw_1755806872
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 01513140003
X-Stat-Signature: a95n7zbtiep4ziej9zmhhwou7gbq63ha
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755806874-254977
X-HE-Meta: U2FsdGVkX18ixGiQ4XaDUo0Xb/15wZtrZuFOCfDTUgVl4yZ7+HXACT9crsSRhAgMbggOGrugzlH+FM2z7YAVQRkuCa0vdQ7Te0DEnW9YuKF/FymAK++4NgcmFUuafRj9i1Lj3/IccZX3qqC0idQ9Te/Kk2mCkyUFpXyvlmZHc+cryAogLkgrZUND92zoK0dTHfrWheL1P9xF5IFTprKytLR9gLlmYrP4AGUf/VlZZvpoHYeCbBnyDe/nJqvKvX8+3SK2uB88pFP1i+Bvr4y+d4FkAuSHxe6T87KgzKMKI6zUa1bENqQq0yo7r0muylG2tqRwabeuUDOkZPJKLtcv/6SD/vm81M8cB/heBNfcFmJBAnhmnYkzGRto8WlFsiYXttaKANZtafx+zEQDxVZTcwvnwbg/wADwDlYuBXJdQgLzsHLKuo3I7Tez3L3mPuGloxkB46R8n9I8F6bPzMzvF3CmG5fRDfWUgBkS/ccxi30fr8awE8ZFwh3FzXy5VEITMvosFLy6qdsu0mf0V8vP4SR2R7XcaDRV6VqEQnB0IEXUh9IAr1ZAYTCfZfs37Cs5xtufpfXtOYc/KiIRNLYkiv5kN7n8nFIJCaTyY8Vf6Y2Fzee+ZbNJL6O5R3rOOO1tA0hFKUoI6O770jnt4OiRnLnT7cxlJ5dCQwFHWIPgOxrSm/O5r6K0tBURmx2dgoMTIeNxACRp/zIaBX9qmbUbuUtk9ZM6OzQmXd/+AhqkQo/aeoWe0a9ya/yDO+xc3KYm2rL+wp8meQdN0B7EmItOrNhp4C9GZM8QZffROlEWggaAk2dFTvPXw9I+JoiE26SW1BIdNsAcnOhWrNCKHaeGSOrbmgbEnHbjFhMM4ncSnv33jZjk6Si/BA2xuXlTJw0HPUnqvjeNXNDt/RN0RqLbJ1LZARq0mFnuRIq40t6HW/6dpOXx9Hg54WygOllEJQlyJ3q2KNOD2NVNiR/A1It
 /INc24Ni
 r11Qk+LmEIlTH2pAOYrt62EkjK015XuEXyWcuz/Qc5QlHj9MyXEtlfp9CiLfBHZAVd1Gaymi6Jo7934L/ai/cuanvfReDdcgdjxBvhpSc1KfesCwzQSGfzZESn/iByLxg1Q4dm8LBHi4jpsffu2dfm7QVf5QK6+Ean8BIA9xfW4AhUXR0iBrNPFaJ4dqB+OPyj4rb9Bx65qofqF3WPE1zqNF68sKNkCvYM3MPM9kPB2XhS8du5HcPpx9P6HeidIEtS+hiDaBywXQlqg3MGP6pyo1lNsf8OEKfRQDQ9WgOW14GWVvRj5uEejioNLCJV6YBG9ExZRa8XeYaW15V3ME/hx/k0zfG9bm5sy6MxWiTQ21UITt18Q1mqdA05FPgwHdwZqITS+m7h8XdQ1OivRbr4hY6avMtI+j2XsR3R6hM2tpE/4mu9zuREYmFQs0s/zcaY6e7jKR8LgIbyVgbwPOr9sI+SzWIr5WxFLI8GUBZerawcvU4GzGHAMYCTcKKlHJ7d/dGphwlBHP7Yc+99K21rzV92Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() within a folio, so let's just
drop the nth_page() in folio_walk_start().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/pagewalk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index c6753d370ff4e..9e4225e5fcf5c 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -1004,7 +1004,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 found:
 	if (expose_page)
 		/* Note: Offset from the mapped page, not the folio start. */
-		fw->page = nth_page(page, (addr & (entry_size - 1)) >> PAGE_SHIFT);
+		fw->page = page + ((addr & (entry_size - 1)) >> PAGE_SHIFT);
 	else
 		fw->page = NULL;
 	fw->ptl = ptl;
-- 
2.50.1


