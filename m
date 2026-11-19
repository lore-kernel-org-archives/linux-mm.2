Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4FC6606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=J6uKK6GG
Received: by kanga.kvack.org (Postfix)
	id B111A6B05EB; Thu, 19 Nov 2026 07:02:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE88F6B05F1; Thu, 19 Nov 2026 07:02:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8396B062A; Thu, 19 Nov 2026 07:02:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3886B05EB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:02:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3D5D1C451D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:02:55 +0000 (UTC)
X-FDA: 85451732310.28.874FBA8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 807E9160011
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:02:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J6uKK6GG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089773;
	b=g1PLhi/2npHJ33Qr5XkW/1mEnWOvaoJQ19FwM3PHBRkqkZ49V1b5l9U5/e5xTRCSssWTYE
	E07y+IV77Z1eebvP43Rc6KRi0g7Asg9t0+XFmzbjH+AIm0mAq9iUNVJu2ly8YEcuW/GZ8g
	/RoyAOO5e+tMj3s5p54x34MU5/n4Dc8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7t7J49HOFuAWT+vhD+UjJuGaxZiXmraSo4eTZkGtO3s=;
	b=ijM4WV2piKjE+1KgvRNO6hID9xRhok8/JSHyfRFyhOP+tBUbxGwfpoiV8Yr3J7NS2Wy/0B
	oZkVioWqKRVjwhoQj65hKF10CwV9uoVJDweMF8qtIBQQGIYDUVOTLrV8GISejwyNuZ3s5y
	rQNueFN4DMMX/IULK0f6Vo/EAjQT/Qo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J6uKK6GG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795089772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7t7J49HOFuAWT+vhD+UjJuGaxZiXmraSo4eTZkGtO3s=;
	b=J6uKK6GGcw9qcsX+gY8LjhE0UFMO0XdD6x6zIvGYt4n9heWObm8I1jAdLjdaKkKizAX/59
	iNnk8AR5JE3Kf/EU1D9iqctfU+upVz1YfCZpuQTiPJTg7QZUQs86x2YrDDNs1Y/8TsQG+V
	u/57i+eQtDL1+eRy1tEcrht1f4/lzz0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-xJ_mqAXWO-yCLaK-eG8XhQ-1; Thu, 19 Nov 2026 07:02:48 -0500
X-MC-Unique: xJ_mqAXWO-yCLaK-eG8XhQ-1
X-Mimecast-MFC-AGG-ID: xJ_mqAXWO-yCLaK-eG8XhQ_1795089767
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4ba078f26f4so10272795e9.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:02:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795089767; x=1795694567;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7t7J49HOFuAWT+vhD+UjJuGaxZiXmraSo4eTZkGtO3s=;
        b=lMy4BRgQhFztH52CackgveZ20elWdT0sqm9MbP+r/o0xRbhi1Zi9dQTI7LeKQtv84c
         End18zJ9GTLAMubwf5H8yYjawlTbX54gU+zkn/bJRUoiGZwql/OYI+uttTCcsXFigcck
         ARtREmlUu7WCXZHoQchFQ7abA4y9Y+3lamNhzD/K7SR9uIZbHsKWlh7m0PeuB50TsO77
         5B+jTgcSJMlsp8b0VN0WB4VqRu180rRTVZevR24woUmEX73pn6yFPvIC1DN5SHzWLAQ9
         1FEmLJQdUlkazEc/P1F4LncLFExpQpGxqykbYLU1QHO8MLDfXnvZbmkK56spjD9aB2FN
         jIDg==
X-Forwarded-Encrypted: i=1; AL+hErH8uAQwuLXuwG7D7m/sI6xIGQ4TMfMWm1olYKAVgs/wjL2M0prAP01gmo8lwDAfkH8jltinJ+CuYQ==@kvack.org
X-Gm-Message-State: APuU4Z9r2bc0QLR/KlMXTuN0iwM8KYefriIfB8+CsEBGJZ3dk3pIyqQs
	D3+mD7HVzP9hDT0VBUghFqzRCj5Zs/ZveC7O/vIkOsPT0kwRnfUhti/3O+JG+K0MDTj5hR27xg4
	h020PiortqnP3KhElmulGBV3FnWI4Ow1lZNinJSTZ3A3ZWk1teGXG
X-Gm-Gg: AYBFou2ApUSlICEaVMZlScunkpjMdFfdlZwQHnxyALXDj4BUtvBbwZRmN9fHWgJl9vB
	6jwEsPvMwUghC6Bk0l81Bu7y8jYfHkyfXWVIFx7PM2mFeaZyGlrc+q5GgyMqzyGdHEvdJZ60APf
	yTSQsmTE9KsS2iuQtZ+EsJ+FY0jwr89tFQFDmjcZotI2DobccGZyI/h4pAzdaoeVa+3dyPv2L5/
	Xv96l6V+Nr0bM6j/Xr58d/174tsYflWaf8ZMoySfjXlvBc+e//Iv5YvAbAkczf9hv4JqBWjLD1i
	rXWw8nTEJMM5LCYEgDgNOCy+etbRRG347FdxMXToZty3CRh9KZqv93XBse4//OaiMUADsnknunc
	NroIKdNovw8QMTT9ogLcASy1a09fgSX+qVnA9MpfVZMc=
X-Received: by 2002:a05:600d:4:b0:4bb:818d:8d8f with SMTP id 5b1f17b1804b1-4bb818d8df2mr59688075e9.23.1795089766798;
        Thu, 19 Nov 2026 04:02:46 -0800 (PST)
X-Received: by 2002:a05:600d:4:b0:4bb:818d:8d8f with SMTP id 5b1f17b1804b1-4bb818d8df2mr59687405e9.23.1795089766192;
        Thu, 19 Nov 2026 04:02:46 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1520:4400:d78d:7b2d:2f5d:e08f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8535741esm50675225e9.11.2026.11.19.04.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 04:02:44 -0800 (PST)
Date: Thu, 19 Nov 2026 07:02:40 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, virtualization@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH v11 3/7] mm: skip zeroing in vma_alloc_anon_folio_pmd for
 pre-zeroed pages
Message-ID: <37575b5efa8e04527f390eafada7fda928744130.1795089715.git.mst@redhat.com>
References: <cover.1795089715.git.mst@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1795089715.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hEd_aZM6XrOeqyH3Vqa_gLg5QHHX-HNeVc_OYhXao7E_1795089767
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: gwqn7acp5cda1p38fbz3xcbiqiuc94hn
X-Rspam-User:
X-Rspamd-Queue-Id: 807E9160011
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795089773-782412
X-HE-Meta: U2FsdGVkX1+JyQLTNDd+yYCNxnn4p5qlYG2czOdYZQlp8aImReRbq89yjYCPiG5HMJYAHtkCrlcv/mSFc7YBiynWuUglOqv32FAwoju/ia8R4agrw2HT08TgVBpBm1jRXPS5+A1D7PhjhpTPE6d5RBSdmKp9UM/vXQbTny63mSwBfKAP8F38f/ufYK7ALT6C3fs7CHca8/iiC1zR6oLMh0uTHwmD9XKqM25ufsXfXTF1STpng+z82mZwt6mToRcmSJvnrRJenDOp+wt1Jbc0lMyAfm9OhHG/34Da9n3xWaVbCJs2lRhsvNuHmY33KFBYkoxzoA1UEVypZrP1SUNDcA0AfSQhvWMIT3W5PAdLoyFlOrbWgDXIyMp2rC8iPmPiQy9t3WBNgE815j2CBWYuHkKRakwCNwo+7zJD/oogMLNejYbxNp2tbLhFJsrbLYYfGUu5Ke4gMsoFePI4yRz/m/OxufbaAZYxQQhSWe+59WWkVt4Es8kxsrRBHqFPMRXnUL0hJIE46QSx46JPaY9JQcfk+tzOZwCKQGrrPx+9ng9R4CLALwmt7Er6OGzoeqmANXr8lqKaRThn1IbrIwReQJ6O8yGBNPe382O3FyyuX4tvweSCu6EVJ6PnF0B5fVxpKmMV0t7tQwF9Q6AqveCRtEwkdJycZjBQ84n5wiZWQTxYULZr/0lHVoqIQo7EYtXBQgQQqDBLr/MWKktSIiP2ioqeIMITP6y7uwlJeqzFLZIMUNuiw/ClyO8y067G9YN9MaBSCoW+JoyDwqDopQpUVxOTKTWTfwv3oJghVB/cQSpiCl1FQpQ38IjL5IVRWhaJXLkw5FhwpDmH/gagB4s+CU2RWWncErmYPULVF3u5r0Uk8hRK0tkHvkUQL6ySSVkg3KWUTx8Fq5jq/6thuwTYfwkilKGkUWQix/jXGaIeEJrl30APG1pQrOqYcewolS4Nncgot3XCJSd23QUDXD+
 vMI02XFJ
 iEROWC4FrOj2REfOlWcgLMl8M3qcJ7ZvyaRvLXBBMeLfbkdhDMBZ7FvnM/SBrHOyUrAILB5v2RZA6s8AGRMzpO0uI1UxVnx4FoYwcAN+BglGbSHznWPTB7k2LoeQxK/SQqs3z6OIcT+mxtDZ7f5JqLb4qcpXk6lZuiT7J/7tugYL28Iz8bwxcDUG1MrrXBQhhP1ZdWzEZBTi6NyilcZyJWaYBeuvSe0/pdjF7Ay474ofhXCCfHXV+j6HWfT2cR5pFOuRzS0zZ1GcD1jdDnkAYm3KDjn+WJbCcvtjIOk8pKk2gJcnfvXUfkLyJXDDSr5LDHZiC7RJxFUFVFagL5tee/GXe/BTpSYRiCIMC9oo6YU3qlsU4NoXy1XuLpC+xIjzkCsO1kjiI50C3Up0c79Yhz5XzYk5rURF7lhdY1/E7+Rwaw6viGqkXt8EQ0Fxno9/mAT8ZNJFsXRr9kGgMShNm2cTUAyDjfd/YTi2SGqdOUInoAJ77B03VM3kZQ9fsBhaeZW9VAUE5N9ZAqoX80DuvfKOkeJg5WxeUfzWvqZoYm4Xob9s3aoYv/wcTTic9cutqMXAG2A4MQISmGBSzcWMQjXygQVW4xE37iiKN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize newly allocated anonymous PMD folios through folio_init_user(),
to skip initialization of PG_zeroed pages.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
---
 mm/huge_memory.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index eb913acb03b74..80bd9b54eff2a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1375,17 +1375,10 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
-		folio_zero_user(folio, addr);
+	folio_init_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
-	 * folio_zero_user writes become visible before the set_pmd_at()
+	 * folio initialization becomes visible before the set_pmd_at()
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-- 
MST


