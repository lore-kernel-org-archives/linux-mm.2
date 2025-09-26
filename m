Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88AEDCAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 21:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19668E0010; Fri, 26 Sep 2025 17:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA5D8E0001; Fri, 26 Sep 2025 17:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7B98E0010; Fri, 26 Sep 2025 17:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B85A8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:17:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 407411407F4
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:17:02 +0000 (UTC)
X-FDA: 83932661484.04.5C10A24
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 003F8A0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:16:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e8HuGfHe;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758921420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5yeOKo+xy2g0cnjvr8gakW6SdH6gdiBhq2xrS+i8Dw=;
	b=Xd9lcXtHgzQc+Ee+Rpu2YgnKGUd6z4HUHE0P8MYs6vxXlzSB5EdLvDN5GD4azqllRHvRTF
	om16PeOCWFKUjevJHeIbfJJDs/Q6dkfi2D/h/1Fd2vorRmEUGolxYXXEbDGKYA5XsDy/MT
	aqg2b8sr+7RYJqOGNg0wrneIZ4oZphY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e8HuGfHe;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758921420; a=rsa-sha256;
	cv=none;
	b=JevYoxb9g1uXZnT2peOYNV+hHntHVUw2Es3NsrL6FwkM5VbaUDxo/AOJpcUydYwXQrq9Jf
	dpEnXgN6DO7EZqfVCqCEsA0Bumi4X+uo3m4qKTRlv/z238KqlYppnml6+qEfm8z0uUnahs
	/aaEP/AyVbDfZCq6y3K3gUFbEZNeWLI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758921419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d5yeOKo+xy2g0cnjvr8gakW6SdH6gdiBhq2xrS+i8Dw=;
	b=e8HuGfHekWwPCHLRLWWzi7MzxDP5FOhXSl/03EqkbaMQZQyebrpWhWWOK/7BJ61RXd63vY
	MWSsIZS1k9fV1c6q6JQSE8IpLQAIRRqYULOmBWKdDAlt3mpln2J6ErwCu3eIjpcDiDZKeG
	hKLOxsWlFghuEPlKL6qb4zKk5s60+TU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-Cb2ej2qoN32HjUsdjIQc_A-1; Fri, 26 Sep 2025 17:16:57 -0400
X-MC-Unique: Cb2ej2qoN32HjUsdjIQc_A-1
X-Mimecast-MFC-AGG-ID: Cb2ej2qoN32HjUsdjIQc_A_1758921417
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4d9ec6e592bso51903491cf.2
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758921417; x=1759526217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d5yeOKo+xy2g0cnjvr8gakW6SdH6gdiBhq2xrS+i8Dw=;
        b=o5siznmaFoHuHerAxatmsgUMqbtXviMYvKdNHCc/sjl2CvWnXjDEaN5hrZ9k7HG9Ag
         Eci8NDKh8JHRO95v4+XSq3ANdQBtIE6lD6a0CO9q4mavEagZWaPVlXZkuxV1KYp/ccKt
         RQLKm10F2GEJrXbqTF9x+yxzR3yQtQrUSY4aOJSVGXI99chMUZ+mBaMpT0UeWIlhmosf
         xepCn77A0tn19nk2jSjwvam0cXakLoglweSrlzq0luCj9/X2SG8VfWCOrzhy/kEZYnmW
         XlXRSOoowsjMCkKp/skmE8/3uOaoq+GtnP7rTRjA+/jT38KcYKO2XsiOFJABvE/abqjV
         /d6g==
X-Gm-Message-State: AOJu0Yx8lvyCU6evqoR9G5fyP3LRQ/VqbCSjv4N+uLo7h7zDg6neHx6A
	tonQMOrELjJm2oNAOOcSOyB/j/ZATO+UcMGL368fDb+cZxtYfSvuwpgfPqLUUtsNTwe/fFVgkLc
	HCVCP3IjDJ9fZ3j1FckLZTieHf9kQcGIJw9PsK0Z0pwmJOTJsPyBumuDumH9nfnPc2rQ7sEu8/D
	5xG+bGpBwNODeeRCoQLnI9NXehp1BrX4c6tA==
X-Gm-Gg: ASbGncs+8rreU6OX0op5aItfoqOpr7SZYZ2+AjDfyGIcCY0NN4k6y+5bV4YC1bhhgCY
	Z9Wie5jaqBj6/Trj58dpqn+DD/N6JoWN1JOQ+LojSqc5CR5YRDfH8FaojTMXHQCzwLnWrGiBPzu
	FctoGwrqop0wpem/7KkpK9v6MTxd+UvH+VW6pt+VUt9LH2R0WfveA1cgnNi4Td6qDmoC/vHbjgD
	5cFoQp6kBIcds+gECgvYceWrFQLFMWpFPSCBHhbVsLZV9x6r7+AMX7D1FTLQjIpboxYMvdpcwy0
	mzIejNcEobi7KclzvzLxScrzQLpxkA==
X-Received: by 2002:a05:622a:5c1a:b0:4ca:10bd:baef with SMTP id d75a77b69052e-4da488a0db8mr127806021cf.27.1758921416876;
        Fri, 26 Sep 2025 14:16:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBcMQvy1EznIKbV08RyV+Az/cmOQuuNvDrJwaaM3Rmt+xpQZNuQS8EHNMhqLjuus0FkmUnnw==
X-Received: by 2002:a05:622a:5c1a:b0:4ca:10bd:baef with SMTP id d75a77b69052e-4da488a0db8mr127805241cf.27.1758921416109;
        Fri, 26 Sep 2025 14:16:56 -0700 (PDT)
Received: from x1.com ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-86042e32249sm210604785a.44.2025.09.26.14.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 14:16:55 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	peterx@redhat.com,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Date: Fri, 26 Sep 2025 17:16:47 -0400
Message-ID: <20250926211650.525109-2-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250926211650.525109-1-peterx@redhat.com>
References: <20250926211650.525109-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5tD-onAkJMIgW663d9GavVcUqxfk573M3bj-KPCKYOc_1758921417
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 003F8A0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gjmjjnfq49a78yaw3rdczqp4jqwdpirf
X-HE-Tag: 1758921419-758450
X-HE-Meta: U2FsdGVkX1+PVXzrn8NuScXQGuVlIxfN20Zic1ERZOX8k5WPQhTMrE4FH4hg6yL6dXfZLU5Uq7cxo7hXwAe417ZYU2dn0v9U1gdytljTJ8GL/gHDVE7RA80qelRZ57p1L54g/L+4coYMT9bHRoxdncuxE/YQQBdAQDF2TTv98SQUeps+wQfbskJTgUgzFf3Qenpw0vlD2pIbamdHiCY6T/x3G+RydE/ETF5JAR2L6WBPqSORl8KNai2EkSkboeEVS5sCRuHcsziujsaZdpJ2/L+xp7IEq2T+8vO82rKE6Hu94vzWK7ZRWMl9D2Ee7wKmraiJU5HD/mcnj204qJsHgb87NzZzDjYKxpaIdgTTrn3+3JZHqGPp0E3IlnyaX6kyoEQkBptpojn/Gn8Ia6FAcTCQ6yE37zJI2iWwai7yTGy3/BWX/Z1MnZ6T5NC/GSYO+AEERXSLlyRxmDTRkLxIBZTgSBOxZKNYS8F+oVfPGZ4Jm1PfHz1DdoQ7EBCBfETxJFGgtMNqWtSEjOoVaYDbU+HvSU1HUyWCb2S02peIFLGk+Z9MwVLs/FaOCwobwh9fUXO1wvvlEnydcILMlbUq9YiyJV4KdD86s6oGibhR66yLc1at+NSzMTHKXp4OVXwy2pN8zGxREtl8ouigAywU/2ZRLRTQxyERutPcAePcPVWcOwqOC+qok3sj2x9jLaR9+kzT7ol2c+xgzJN24KblieKpJCXrykXRm4Zy52rRSWf3ED/446QycV7Zb6WCfZfhKnCk3PqeZjHzSOtKTyiO1cwrG8m08IWQkWho7D+PGJq0U4kWkZRRnySdIAIWZQzQhFSuiRoQDMK7/JgV8TCz3PSeHV3VKpy+TVcebhhRiq+4/UbmtdSv9BZ+uFul6oL9sfMfKCehxMUWieLEeZ/xSTC0SyywVtdXv3GGk55MbvjpzWhBgMLZ6OiMtUeznJXjmX6NUjE5iXVEVlrxwdw
 ONGGHr5z
 y65GFAah2XYmoo+rOaI5J6S1AqujHtHwUrl2IM6vm1ARNg0POEeVtqTGqak88VIgz7/mp71UZEIu8FcP80lCNOA/itTTtsJHT/u8T0uygb4OYssvrxC1PrfgqjXiOfzLLDkxXY4lWHedXv8+0wNOWcxGDgM17upJpLAQvd3SzrKIdkd1kJ00IcS0Qx9lnIQBjKdme2CpM41ROitUyonkypTnjtLArOY2KInhFTA+0e5Q4mD0ReSGPSLtI1T9aGHCHYMF+Dz+fj5qWOTfs+TPvuBNr9yDPTCm30gwLvjZSgkFmeQFcSG1z8ckfkm72ArP5djpgnUIGChZWXSRpym7ujFSYTOTMtSNUmJmb1L3ogAyrU+fdWNfA+ab/YMEg3OHj45TAj0y6XW6WN3l0gqWf5vMFqX6yN+xdVN2Gu5PjfSiVI3kOu+EQhDQmSGKwNIPSfog7MZHJkmSTe+A6qaH6NTm1YOZkmO8iCsVOYoPNGbugjZV6dWMYkWZEvS+PncGZSbM7LzYcUgN9/0RsyJDCTpUu318Q/hp8IwXMsed1qTODGBpWcya8So06wH8PsHFjraOYJV2D82aA+ATOmkB2hqhCqhcgfeU1N89j1qYAv19fscO+lwJS5SlPF82Nw4KgrNBR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, most of the userfaultfd features are implemented directly in the
core mm.  It will invoke VMA specific functions whenever necessary.  So far
it is fine because it almost only interacts with shmem and hugetlbfs.

Introduce a generic userfaultfd API extension for vm_operations_struct,
so that any code that implements vm_operations_struct (including kernel
modules that can be compiled separately from the kernel core) can support
userfaults without modifying the core files.

With this API applied, if a module wants to support userfaultfd, the
module should only need to properly define vm_uffd_ops and hook it to
vm_operations_struct, instead of changing anything in core mm.

This API will not work for anonymous memory. Handling of userfault
operations for anonymous memory remains unchanged in core mm.

Due to a security concern while reviewing older versions of this series
[1], uffd_copy() will be temprorarily removed.  IOW, so far MISSING-capable
memory types can only be hard-coded and implemented in mm/.  It would also
affect UFFDIO_COPY and UFFDIO_ZEROPAGE.  Other functions should still be
able to be provided from vm_uffd_ops.

Introduces the API only so that existing userfaultfd users can be moved
over without breaking them.

[1] https://lore.kernel.org/all/20250627154655.2085903-1-peterx@redhat.com/

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/mm.h            |  9 +++++++++
 include/linux/userfaultfd_k.h | 37 +++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6b6c6980f46c2..8afb93387e2c6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -620,6 +620,8 @@ struct vm_fault {
 					 */
 };
 
+struct vm_uffd_ops;
+
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
@@ -705,6 +707,13 @@ struct vm_operations_struct {
 	struct page *(*find_normal_page)(struct vm_area_struct *vma,
 					 unsigned long addr);
 #endif /* CONFIG_FIND_NORMAL_PAGE */
+#ifdef CONFIG_USERFAULTFD
+	/*
+	 * Userfaultfd related ops.  Modules need to define this to support
+	 * userfaultfd.
+	 */
+	const struct vm_uffd_ops *userfaultfd_ops;
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c0e716aec26aa..b1949d8611238 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -92,6 +92,43 @@ enum mfill_atomic_mode {
 	NR_MFILL_ATOMIC_MODES,
 };
 
+/* VMA userfaultfd operations */
+struct vm_uffd_ops {
+	/**
+	 * @uffd_features: features supported in bitmask.
+	 *
+	 * When the ops is defined, the driver must set non-zero features
+	 * to be a subset (or all) of: VM_UFFD_MISSING|WP|MINOR.
+	 *
+	 * NOTE: VM_UFFD_MISSING is still only supported under mm/ so far.
+	 */
+	unsigned long uffd_features;
+	/**
+	 * @uffd_ioctls: ioctls supported in bitmask.
+	 *
+	 * Userfaultfd ioctls supported by the module.  Below will always
+	 * be supported by default whenever a module provides vm_uffd_ops:
+	 *
+	 *   _UFFDIO_API, _UFFDIO_REGISTER, _UFFDIO_UNREGISTER, _UFFDIO_WAKE
+	 *
+	 * The module needs to provide all the rest optionally supported
+	 * ioctls.  For example, when VM_UFFD_MINOR is supported,
+	 * _UFFDIO_CONTINUE must be supported as an ioctl.
+	 */
+	unsigned long uffd_ioctls;
+	/**
+	 * uffd_get_folio: Handler to resolve UFFDIO_CONTINUE request.
+	 *
+	 * @inode: the inode for folio lookup
+	 * @pgoff: the pgoff of the folio
+	 * @folio: returned folio pointer
+	 *
+	 * Return: zero if succeeded, negative for errors.
+	 */
+	int (*uffd_get_folio)(struct inode *inode, pgoff_t pgoff,
+			      struct folio **folio);
+};
+
 #define MFILL_ATOMIC_MODE_BITS (const_ilog2(NR_MFILL_ATOMIC_MODES - 1) + 1)
 #define MFILL_ATOMIC_BIT(nr) BIT(MFILL_ATOMIC_MODE_BITS + (nr))
 #define MFILL_ATOMIC_FLAG(nr) ((__force uffd_flags_t) MFILL_ATOMIC_BIT(nr))
-- 
2.50.1


