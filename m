Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD5CECCD1AB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D286C8E003A; Tue, 21 Oct 2025 09:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62B58E002F; Tue, 21 Oct 2025 09:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78F38E003A; Tue, 21 Oct 2025 09:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A30968E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:00:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 657991A04CC
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:14 +0000 (UTC)
X-FDA: 84022129548.16.BAEE9B2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id AD6E9100009
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:00:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XNH737iv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051612; a=rsa-sha256;
	cv=none;
	b=J9Dzz55lGJETPFI5yv/nig3aa/7cSro51GDW9VbPWx+6drEpzhvCJN8WnXtlw0PEk3QYZb
	0UJr1JKWyOZbPPEdnSH3P1JOYdfVpuwkHEbetAT3waLEEG6FyoU1uMvBcZRZZ5INZSrzmI
	TJCmSKWzGSHpaIgEmiu4ugNws+4VDFk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XNH737iv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Pfle03AoZbMZzwKNT9cqn8RCz4Fl59OlkWq00/g7dM=;
	b=UCRlsU2eDwiBdArFTEOpScbnLTpkwKXYdzPkVcIndLr84fR2v71IjYRoBenCUCumH9NsPR
	t5aqUc+inF3LtyHvwQHmVXWPrffxSsvixEm9A+X/jVYhIHv6sO8UHbgmS0zoSExyYTkxtX
	OmX/bkaCI+KkM6mQjvlL6sPQtvtIlsY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Pfle03AoZbMZzwKNT9cqn8RCz4Fl59OlkWq00/g7dM=;
	b=XNH737ivJLyY279nXf6078U0LCKbbnePWbY5JXKXJAb0iHQIVrxbCp/xgD2zUF6jvNzpQD
	OkDYtkf1lj5pJTNyMN0cTByIBDgAPWroAS2c3D6jiwUpPn+pI6SKGuAc8B7FNk+lzYj1aM
	MU13+um8JMKPnDpFrxJM2EvtgzTppAc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622--zMT0JKCNoWI0lgj9ldiIQ-1; Tue, 21 Oct 2025 09:00:09 -0400
X-MC-Unique: -zMT0JKCNoWI0lgj9ldiIQ-1
X-Mimecast-MFC-AGG-ID: -zMT0JKCNoWI0lgj9ldiIQ_1761051609
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471193dacffso37644375e9.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:00:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051608; x=1761656408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Pfle03AoZbMZzwKNT9cqn8RCz4Fl59OlkWq00/g7dM=;
        b=pn3/2HKeGkJofifVFYa33OI++tp7/JZ6nre+Ubq1mQ28VJa4Jm5ebjuGNHVBDz9r2C
         ptVcmbMjskSd4meYaDCyDjMb58Mvxaj539im7f2UUM1bG3RQtw1M7fHe4fFfVIZSZ0+3
         aLvS9JCIa/O/WmsgiAV6Over7gEc3kCaJeDgaQw6HpmXI/eDMs9F/PEoq59MwtbCSSMR
         +8gEDmhVjyJ4tjqxFwBhhCzUqHJhoNvO9y7syq7Py95yGHZppWC9AbFCuINVRjLkVhRv
         YGeq6moe+k3Gc9FrQB/vba+Vs+6MLoCXz7U7tZf5K+vCZeID8+GMWRCL4Bl3vC8iPejf
         zbdg==
X-Gm-Message-State: AOJu0YyDAqC/JIJ1Dng+ezszluvY8ZheGjJ7lNc0Xk8prQATSXVoV8K0
	5Wu6JZ8czN5FUh4PxbH9O8l5L/PpJSu6ohS8r5QS0RDyRGWiLkLkine9dSGQITo57g77FfOMVEa
	B2NL5fqn4C9tL3vunIdABYLzJgKfEATCjPH4JgoBmB/SquszPUZoL
X-Gm-Gg: ASbGncucauqcKItaLfU9X3atMnoypSoOUpwS0T/93BLdNtTdtGvk+04zQENsXtVgmuu
	ZYkPghZ+VOVzIbWMGpTSNqcwHSTR+KekrpvYAhCRZ9j6mR244yDfveYoUjNeLuPcJqWA8PcgcUM
	4zH7rcwCLePPtuINhytfnE8HqSy+Qf1NsCH9jqPfV8KSK7UuTDq9jOVuF7p/ltL0iZ1ZiV9b7UX
	36Q6DVOK8cWXcLHSFU4+OY9eViXUpsK6ecI0IVgYWViuajaJlQGeH2Z56/qxnVKgTgTGzV45abh
	hE8ON/H1BmiaOdU4rfEfk36Tc4RmlxveVAqq/8pAWgLt87C7qx8VTTftf7wrMsaCr3PcCYICxFs
	svhOmsU2QpLdHD/Y2DplUTkCHhvY9MabPIV9lubSwUqyxWP/snWZmqmSTCN30
X-Received: by 2002:a05:600c:3544:b0:471:c72:c80b with SMTP id 5b1f17b1804b1-471178ad7b3mr117595925e9.18.1761051608630;
        Tue, 21 Oct 2025 06:00:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYkNMmF6KwTjIi+haTZNa/bZuoGNP9fBOncPRUCNa1fBr3A4oaQbG8grM5Ui4vLJ4xvDadAQ==
X-Received: by 2002:a05:600c:3544:b0:471:c72:c80b with SMTP id 5b1f17b1804b1-471178ad7b3mr117595585e9.18.1761051608200;
        Tue, 21 Oct 2025 06:00:08 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-471143663afsm278506055e9.0.2025.10.21.06.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 06:00:07 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 16/23] mm/balloon_compaction: mark remaining functions for having proper kerneldoc
Date: Tue, 21 Oct 2025 14:59:21 +0200
Message-ID: <20251021125929.377194-17-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4o1DBDYU93Dsedwgfssp4FjtON5upZ7nR17a4OdvTuE_1761051609
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD6E9100009
X-Stat-Signature: p19orpchfiq43csts58ugutcmbkrrza6
X-HE-Tag: 1761051611-303922
X-HE-Meta: U2FsdGVkX1/WjKUilud2THsAaXN8vSui6hAkrJBEsJDtkT10Zr54wts2LLHdoSRKDKgnXyDWZv3Hpkkpfk1rjg8C8sDzScs4X10hqrKOx5tVqPczNFL9N7AKE+Cqz92FTvHL+eWYsDYkB2R7/sK3c0mStDrvRFWPaYYSVtmIFkRdR9N7f6jR5n+mcmWda6brbFYSuU+wlYdvyRrirB9iaPOdSvZuQrhSIYy3TOHkE8aHCTps1qHsvvuVU7JndoA7BoIAKei16LRoCcRD+2F2JzM4sBRbKvjmmdqlyuMop+Fy8ZRComExzIZ0G7ni2epUgmB4YzVogWTlR3xXKzJqSu5nUpPUrXzSjmepvWdtCWJ10XNjBp+v678tvjnf+aoUlCIIDlRgrJHyc/VxXKRVib+7sVEBsNi9eREF3k7sm0Txpu+0VIfCs3S2Lbe06WkAqZI6Zqu92ej16lqh2r3GpLl4/i2ycieVJ0+DZ1voEMqGako9cCF36ypc5lqOYxd0km03e+kFcYUkZoeN+7+xKFEdKwP4EDuSVzqhuReCeBxap3rf8b8rxnkNzmtXef7eow/Sa4SQCpzncy4Be9d/STuw7t9qxSZyGH6J0r4ToCqtIOxbXb+9r0p7iqViFtkmP9gsRleNvivW+X6O8Yt6I45e9loFrMSdW+DPLXLeoyMdApIXXpUiv+N94Il2T9l3lMccULFYH6po8sARLG0MTrgYu1U90K3UkwiKdl3NL5EoIk/cDcRBTL0rcylpMKIgnEOJkLMeMXp6z91qWfYowT92B7NTlBAJ2yOJinXXpaWiLN9n39VjMv/FUy031P0ZEWTAXROTsYoRqybGWeBCZ+Li7sX4ju5oqscO0ehhwrJW26ALBg8fY3Sb70wJ9ZQ2IAiiupQ2wOoBPPQI/inil/al37m6kMhxG0mGYx1lBUvp4fqOI6OZbKhXVMYn3KIHgHvodYXR2VrBO9gTNIN
 2U7wSxgd
 4OZLxRpFg7vMoMwUVc6Vp9LobC0qnZXu5/AKwSpHaLVRYcuXU2gSEq99U0XTYYrG27B70fJDGPnIAXDPfTL4wZKBLyHNQlq19HnScaAwb53RYIrC9x4wNt6koVj1ISD8Na1rZnohzWTjG+QAT85MIKZ/FPOg/q/KluM60B7E3OM5fpClpEUokn36MAV023FnNEHdnNinVqX7zTn9Z1N5NkJvn2MFcUIY1SCtqOJEpQCg8WHgvJNWRQtGpuPEtHu4cHWiR+vnKT+qMDkq8LUld0bJzOrmsTztcLBFX4XEfMxN1caYHdY6uo6AK9sdG0sloXYr01ZhY47I+5O9HuiqfXD4XMCuo2SZIlizTyDjhKI+ygeuHU7q+Yy03K1McZW93TToqGnwrpH1MFZLwgOJQKZScHattVW4nK5ZdWIy0WTHEk+Jhnr4HPKDe3+ffV+QGD/9Q4lJyL+YKq9A/WwpAdZk5I56UJVoe6BOYvB3ayr8viPSedeAsR/IMCGK7gZC8dNw8u1Vm/yayTn/77iDhU4cinp6RgXszeowTi3LtiRdBwxVKbs7VozDsHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks like all we are missing for proper kerneldoc is another "*".

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/balloon_compaction.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index f6e0582bd7ffe..f41e4a179a431 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -22,7 +22,7 @@ static inline struct balloon_dev_info *balloon_page_device(struct page *page)
 	return (struct balloon_dev_info *)page_private(page);
 }
 
-/*
+/**
  * balloon_page_insert - insert a page into the balloon's page list and make
  *			 the page->private assignment accordingly.
  * @balloon : pointer to balloon device
@@ -42,7 +42,7 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
 	list_add(&page->lru, &balloon->pages);
 }
 
-/*
+/**
  * balloon_page_finalize - prepare a balloon page that was removed from the
  *			   balloon list for release to the page allocator
  * @page: page to be released to the page allocator
@@ -140,7 +140,7 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 }
 EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
 
-/*
+/**
  * balloon_page_alloc - allocates a new page for insertion into the balloon
  *			page list.
  *
@@ -163,7 +163,7 @@ struct page *balloon_page_alloc(void)
 }
 EXPORT_SYMBOL_GPL(balloon_page_alloc);
 
-/*
+/**
  * balloon_page_enqueue - inserts a new page into the balloon page list.
  *
  * @b_dev_info: balloon device descriptor where we will insert a new page
@@ -186,7 +186,7 @@ void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
 }
 EXPORT_SYMBOL_GPL(balloon_page_enqueue);
 
-/*
+/**
  * balloon_page_dequeue - removes a page from balloon's page list and returns
  *			  its address to allow the driver to release the page.
  * @b_dev_info: balloon device descriptor where we will grab a page from.
-- 
2.51.0


