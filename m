Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51E42CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF7D8E0039; Thu, 21 Aug 2025 16:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB758E0037; Thu, 21 Aug 2025 16:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033E28E0039; Thu, 21 Aug 2025 16:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E10E78E0037
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0CE1140521
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:05 +0000 (UTC)
X-FDA: 83801850930.03.0085537
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 77F34160004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jDPfnpv3;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6VkvDa+3msZeC5nA9B9+aDln+Mg2ABReefULBX94/4=;
	b=NSOlGF9/eGYXItwAmxiXUm6YWeYevFw0Q6IMU4lby1Izxz4kWpjN6htg+n5v648ql2wlZs
	mpPXiaIptYfPuwYUeHTgHcCJJKT7TM3eu6LYJEJjR6Yl5C0BRSy6uR6L37jqL2I8TcxrFE
	l3vPpxgF5cWycp/4NhZuPvQ8vjXdQEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806883; a=rsa-sha256;
	cv=none;
	b=14/kezDgclHXcxK19qup43aBPf9iJyDBz+EQbMyxi2sElzP3pRQ87RWKw4i8CElYjgN403
	QhTKQgLt7H645j2NJvrrj3b130zyOZ0MhNRLVwbNfcVZD6yJ79Zw/+mdwxfzYMK9tPA2JS
	6bzJx1HDXww5GxRD1MTpKwx5bHfkASk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jDPfnpv3;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w6VkvDa+3msZeC5nA9B9+aDln+Mg2ABReefULBX94/4=;
	b=jDPfnpv3+N2oUxzL5Ms/5QeVqCMWtriLWVMs1G7Kk3oF7j6obMtvwE4/l4Rl3RVImRwBMJ
	tYlwCX+2//9mdOdWxx7BRMqQeSIGCfrjNDue+zl1985K4KJuXla1qfTmWwK0XOlsaknX3K
	estHeUaIsFKzD8WJkn1aT3SLSx0o5BE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-a-f_Pnu9MmKB552BRtH_bQ-1; Thu, 21 Aug 2025 16:08:01 -0400
X-MC-Unique: a-f_Pnu9MmKB552BRtH_bQ-1
X-Mimecast-MFC-AGG-ID: a-f_Pnu9MmKB552BRtH_bQ_1755806880
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a15fd6b45so10808185e9.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806880; x=1756411680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6VkvDa+3msZeC5nA9B9+aDln+Mg2ABReefULBX94/4=;
        b=iSw2x0CNHTDI5DDjyfXt9DPBXLbVFUBw52AEJKMXdL7H/WVnwoYGKx8vF8Pz6QN3QA
         N/r+HW0UiIDHzMIz9slbyPrF2SD6FF8Zm9sUyPFEaoceo0l7AbP3xmGjBhkFL0Y2Q9/Z
         HMI/R8noMUO3VKerdMhPEdOKTuPqfV1MKMVheIdu5D0eJd0tfJTX2eLG+xzVREpGAUSC
         rUAffFq9nFeWqMXhKlG9/bBSa4DeKGNbGaTSxMv6Ngfv167b9XFryjQQIeOOduRghrgU
         r8ZJ42k+RqFdwg51w64vaGyO+Bm70oqI2dTlAmu2qAgJzo+Y/IehzetYmq2ndZ+E2FWB
         s6Ew==
X-Forwarded-Encrypted: i=1; AJvYcCX4GLr//NKs7Ibf7LNGgXL4TvMrvyx3MJ0LAilip0OYH+4HFK2NDep0dxS3mKBDyMwZrTfZWCskuw==@kvack.org
X-Gm-Message-State: AOJu0Yz4zsj3ucsXfk6bQfX2GZB7iD97PnEaMMVdMwK57RG/ubSXAp4d
	fvGy7+b2qQYGEMUxP3v+PjNLFNXaBou7r85DU053XWQZcnjuT0yakKa6ByWqcIjmOQojAlCurQj
	jEP+wyzbffRKsVE9WwhuTNoZ1+TzDPAYF0LJuWxTbWXTdhZiuDYJt
X-Gm-Gg: ASbGnct2znVGCteumKblQwQTK9WfmuV1xLM5tPn/YGx/X9GblcRSZN7u4j42W4En1LK
	xpVBOJB08hfOAkVR+411vJ4rkReUNnpSUd/ct71zLF0Ajy28lw0byYItnwn5h9ePTtsl3rAXkxb
	TlyE9pab2f5PN8lyWRgXyvGh/6GrIyUF6wFUzZU9dHBQnqvLN8dTwdzI+hKOvyvFWypogDv2Znu
	nanyag60vY/Wrvgue885x721EFQYLuUZuHc0+6deH0zZ6WOvxae3rDvovSX8DMFkAVPJSuGsjdC
	eqZjXGWiXKQougoeNo2BylgzgMcDe9VotWY46U1x3juJQShGoxeOHhcEaj2sK3yv7erca9Z22tB
	yBj8wrZPG882fccwc/HFqRA==
X-Received: by 2002:a05:600c:1c87:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b51792539mr3328545e9.11.1755806880031;
        Thu, 21 Aug 2025 13:08:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9ciI0WdoI3CxhUtu7m/cESVsdReJmvmXFWCMaWsO+hhXySreox2GeOL2sJ8kVyLPwCYhbEA==
X-Received: by 2002:a05:600c:1c87:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b51792539mr3328365e9.11.1755806879543;
        Thu, 21 Aug 2025 13:07:59 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07778939bsm12219075f8f.46.2025.08.21.13.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:59 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH RFC 19/35] io_uring/zcrx: remove nth_page() usage within folio
Date: Thu, 21 Aug 2025 22:06:45 +0200
Message-ID: <20250821200701.1329277-20-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HwjqMDC2YchbILD5hEQ8rrN6qhM6krqTtg5uZkjEY_g_1755806880
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 77F34160004
X-Stat-Signature: pk6e78i5ei9fsi7y9owx9dzn96hadieo
X-Rspam-User: 
X-HE-Tag: 1755806883-298862
X-HE-Meta: U2FsdGVkX19Slm5kP7TTS/PlSA/osQU0Zzvf2ljAj6jEwVeXIliXydzc0VQ3oimQ6ce+xi1AcJXATcT2Vt+QXgutBNNmnqbVRgqHxYFxIXeIVT/5pAzF/0DjfWPudMgfAhtVbryGXwHQ3PrpsMB35ZcQa3RkD9lXanoj6TnMKRn8xFt3vB38eQN+M6nt1zXfYcAjupS3b7VHoBObSKyyH+VnS+7pfrrjBdhJDWOk6t4mpKDiMYw5l4MdW0KNFfmrKBmD6NdppAEBoV4YSVjj9Rv+ULBGeY36AMH+KJPm4mv9Aj9lPwGXj2EpjnE1M0GB0vRvhn4cGoG5xKHjRNkeVQqGM8Ls3rWwUMYQjOBU91LfBXGNEhVOXsF2x2H0iI53JWN9sCx16Vzg95WZZWQpZCaPLNOQUsvj8DXLgI3n3XMecmoUny9738EzgAMyRkLbI8VZT/jPL5vjIgmtk7V6Qpm0Jz2SkKWvAeWtcAxjkuaxvT3t/wGdDeqeYTUIkWs5vsb1ESQcw4QfOadIqXMLDGNFjeBwz9roOIB33d/rRJ4VTfflP0aiYwslIoc2pDBCtawGa8roJwrwfvVQkmKWWwFZVhEBTYd8sbGwqnSb33BjKkz8ApNtTG3Asb3GtQQBcuRalwBe/txJASiiFgB1zMsZarUW9QUPmJwZhRgkOO8y7C83hIC8SDdPBgVQN081NuLk8pU88t6gIh6Rxtcp/roBqTt3/TtpOUEAMqxX5Vh/x7SQbcRsfjT3i+wXGazdIuW9pVZy8rkKzgT77/sUkNamoNyrU+ldaDzxbEiWd45covZt4LlKc9d3KbJrBVHkft4D288ZcmCqD+YmnaQa5XUsNeS4TJGE0p+d/dotppaOX0qP4IxRtygw09zhc3hDKR+I6bbFxyX01JUSF5CvV8PCI1OZiLg7VER1zNqtd/8e1clxtNPqLtXMFwWJRLp+r9sRnuB0AEw+abD6Qkx
 ILOVsL0y
 TnyooVtLY7Qv7SS+LeZhnwXLve6TGQAWnVCL/WPJ9lV4FOm7exboLnMF4nNwfipRk/rqSkuArecx7E9FkW/nzlOh5C2TJa/8BtIq+6/i2ih9c5IVQUOFwxm75cv0fhk+lBWC8hZRUFTD4I4nUh5oysi1qnX6HTGVXJ53tg3UUut6vCh8OAkoXVvkp5eNpr/bd7r/b011nfSloILI1lye4i35VgkQP1wReAK8oktFpikmtfeUjdiiRL2wY0qwfxGzlEp41FWPh0ui/5rA8Ryk7hQ+GIubRoFGmVHWU9XQ/kq/eri2EEDwcx0fg/ign+sSxXRdx/Kd+JErdlJfUnuaAxOkSXg664BsiXZ9SOIfyPC9B85RLqgqbc96mytxa/Ze0ATASyuS8gKCAwZ7vYo0zLDNZyI2mHP4Rcaf5sXGb6eKEQml5PzMBUoAinTUPn1ipoIUj3i/Lxt4hjxxH2HaZ1fMWC5t3Ikt6c9+1YbmqR3oK9Dc8aBglv5YgBd7+uXC6VxyDdz2kHPvbUMfoYHqqQuAzLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Within a folio/compound page, nth_page() is no longer required.
Given that we call folio_test_partial_kmap()+kmap_local_page(), the code
would already be problematic if the src_pages would span multiple folios.

So let's just assume that all src pages belong to a single
folio/compound page and can be iterated ordinarily.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f29b2a4867516..107b2a1b31c1c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -966,7 +966,7 @@ static ssize_t io_copy_page(struct page *dst_page, struct page *src_page,
 		size_t n = len;
 
 		if (folio_test_partial_kmap(page_folio(src_page))) {
-			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_page += src_offset / PAGE_SIZE;
 			src_offset = offset_in_page(src_offset);
 			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
 			n = min(n, len);
-- 
2.50.1


