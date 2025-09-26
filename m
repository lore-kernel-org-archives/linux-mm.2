Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3120CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 21:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622A18E0013; Fri, 26 Sep 2025 17:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AC0A8E0001; Fri, 26 Sep 2025 17:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C588E0013; Fri, 26 Sep 2025 17:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32EF98E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:17:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C63CC0643
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:17:06 +0000 (UTC)
X-FDA: 83932661652.25.71D9A4B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id D0F7840006
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:17:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KhEXZkyl;
	spf=pass (imf07.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758921423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FqvR9YQdn+VFm/f2VVsLMnfIc9MZ41bG1PMJxJgeG0M=;
	b=QBtKcGmHfbJYINF5EUuIWad733FBxiSSLy/5BlkGZhZbr8UYHH2C+a0UHRLNkefxc7t+xP
	l0mnDOt9m/AdGsnMomXBy2QJ0ftGs+MKT4xBJW8Ekk+har9TZy3B4v2L8hiiX+RFVuabnS
	LasE9viiNFw4XhuSTmljwURh9LYC36E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KhEXZkyl;
	spf=pass (imf07.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758921423; a=rsa-sha256;
	cv=none;
	b=RcAqCjXPL5qwWaDp4kepmXmpKPBUrIijv78U3PMk3aK6PsY33uFChUnhepIk+VhzFX0aZu
	XVQIFJR3Lwi0TjrepjN/h9rDtTdMZeiB2hCN+76/M7TffTXNnrnB+PUUDsCviWVkRaDmXv
	Ec7bwzm8VlgWw0/o8PXARfEuo8teWI0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758921423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FqvR9YQdn+VFm/f2VVsLMnfIc9MZ41bG1PMJxJgeG0M=;
	b=KhEXZkyl2obz64Et4pTYBXCUVxmE+0LziuDbMtRvYN8Wv/3Du3+N2ax/lps0g/HzHqE4dU
	asc9BEDGyHO5kdVtc49WtJF/ZCKliKFH41guYBtqaaletiMAmV07HkvbUqefGaDyneQgDp
	yLvvYLnIz86ryfkGnAsVAa1C0b0VnRM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-AFSUETs8MfWu2IlaRjgGKg-1; Fri, 26 Sep 2025 17:17:01 -0400
X-MC-Unique: AFSUETs8MfWu2IlaRjgGKg-1
X-Mimecast-MFC-AGG-ID: AFSUETs8MfWu2IlaRjgGKg_1758921421
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-85dd8633b1bso469029785a.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758921421; x=1759526221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FqvR9YQdn+VFm/f2VVsLMnfIc9MZ41bG1PMJxJgeG0M=;
        b=jYjbKI1rNnH0rkg0SwPU5lfz/Xecaytkc7XLpcTxE8o4rGejS1a9iQfzWndB1UbzaM
         4EJJUVCExEiu08zqNK5HTzGtUrMj25gNqMXVfRbdz+pR1QywLQ20RDaGM5vtdpZk0YV/
         0v1GItfe0cPkUgqk0fPX+2x6hoIBWMIAL5WLjI6NT88ijVJ0olWU+OMRMQibSOuwuZxt
         qwsOlyy3zupCW8PQSedUpWhk9SS4WuZ0hnGSf6AHpYyAxfA15vsETuECOhidP6F5P+P9
         aLahq2C2A9QF82IeRIkZCMfflz6cGO86aWcenWqblemJ/O7lOE2uknYTbZX7ZlXDZsj1
         uv4Q==
X-Gm-Message-State: AOJu0YxTX7lFloIgUCy4fT8PGafSTpktTCUuiSMxWflJLRbALBjByL/0
	/DMS4R3PLc553D1ua3BNZ42hUgA0l+YQI+Orwx29mnu8KiCX7IaJn3Gl/O3An6OjLs+mu/FGap0
	qe3/r4i4Rc136sLcDe8oiUWdgjexTK6GQ5rzkZa8H6Bk1Rc9ATcJnrUHb3/GAXDAfH8ETjbbgbT
	Z3Z+DtoLiLJ0PskeR4vKwY9ZkVmtphv6SVuw==
X-Gm-Gg: ASbGncsog5mS5Iiyft4IAVzJ8JoukcJ2NXgGAOQba+3o3iwuawbQ+hJ+qMxal/MX6Rg
	q5QxNEr/Z4ZUQP6eRY1+7XcnzTNyKEstupm/gGS74gHrNUz6XBcGTxqTOR+DV8yWntIuGJohC9o
	yW39wuI9IDWdA0x98JY1+c9SGlSY/Q8ROrvtdYUIOMdykxQZpsGHNxjb4JMXSWZZOJz8AbNA+TA
	llLwE4nBA9h5zVoQRrpZg22T7dFggW73zs5S807hC8AGzosVbNZkuY3mE1OLx7V2eo6QQDjhvjQ
	3L1qyw6vtGRv/b6UEEYakWUVuaoquw==
X-Received: by 2002:a05:620a:3f97:b0:828:b2ab:a50e with SMTP id af79cd13be357-86462eacc0bmr141588085a.31.1758921420931;
        Fri, 26 Sep 2025 14:17:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgGSOUpzMqnLYfIUEw5sRaIdJx67JoUnQ561pUdKycpRK3QjpqhNcQ0PgHJkIkBHHGJBGvTw==
X-Received: by 2002:a05:620a:3f97:b0:828:b2ab:a50e with SMTP id af79cd13be357-86462eacc0bmr141581285a.31.1758921420264;
        Fri, 26 Sep 2025 14:17:00 -0700 (PDT)
Received: from x1.com ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-86042e32249sm210604785a.44.2025.09.26.14.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 14:16:59 -0700 (PDT)
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
Subject: [PATCH v3 3/4] mm/hugetlb: Support vm_uffd_ops API
Date: Fri, 26 Sep 2025 17:16:49 -0400
Message-ID: <20250926211650.525109-4-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250926211650.525109-1-peterx@redhat.com>
References: <20250926211650.525109-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yL5ahMDCTisiG0QEqw2adpFQleL7i4bnlNWmyQuswVU_1758921421
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: D0F7840006
X-Rspamd-Server: rspam05
X-Stat-Signature: o9hjfguknen17wsw761qcy4r6rytbfmu
X-Rspam-User: 
X-HE-Tag: 1758921423-354062
X-HE-Meta: U2FsdGVkX1+JrVvU/ilwRXwuBaYBEzEo31TqiiZkXVPRbDuRcsU2iqd+Cz5PKzFs/WDTFa02vrKmX2d4qGSk1lD9LfPkveLUJKIuwn882iOaJ0xlViNSIaetpcwqgr4588dy32o6cWQ3RDe16asBd1MdaVTIyFSMG3LeB90jENEedH7ADoV5HgzX6KDNoGeFhadY0KUnu5lJNLVx88atHioOEVmZsLH4XfXnVO0EKn7hThFheVNSHVGvwGsX0nNeJtv6zWOeu9uyavq37/hRbk1tiKYRL7x4mMIOO3fRHuqwMgNueGtkcJXqrrDN/ZocjtxUDypq4NDw6cjk8mubAnu9h7fvqH+UK5rTkNasqIbo3wRHG6BoLdcLBhTRK0DlE9KbgZ4uLZRQVOTnpToRiMKbId3kiXR91VXF6jn72udJj8uT+GSdw8mK2Xrlg4onlUxdZO+jspb1qvrbXM11ENLfIHp7Qu49Z6/9PMpbUqicRUDivsH5eQL5YySKTQTPdCDxblEpbaDLWIADtiI/7Nk4FdQNRvvr676UiY7kctHVaRSgTYc5kjNtqPUOzzupHFYIwQIsJ1qOWUu4+Hlo39YIVjxqnR+O8nHDkNjJUgjutS8TrKN2j8GFH+sZcq7DkgXoKwBgmD61I5eohFyo7DZktRPLcBwp7CyCB61dSH8HId3EP1REOJLg+9JfkVB2ZFpiQ0hYOf8QwVBbMbqctZAPjrppNmfpcBZ88vO1RqPTiKoV5jTbgwCqHEZkaUCjjfxtIWwMJNpipqU3vLcKkgNM+jnUBx/Eq62ckITKfPwQdscgFfwNVCge5lSn8IJG4AlXpXY0zlxJz4vmsKqGxcll21t0V8+7C/yh63/F2qGiD9ig2Lj1HLdIQhhyQeXPlzfuOBrkIwIQBCNfFFRa/HmBcdWfcnob5++KqYQnnsbckkRgjw3+VzBmvf/J7ee/1NN36CH30+z8eroRR3w
 u4YPxBR4
 Oai4S5a+rIOCSnSl2AZTiqlsPjy8sBTL7wStom/1aU3eg9KVZFvNSpRAfiqZ0AHOI86jyuBpA9pmAWqZZntl3QQYIx8Ko/ifrLc7eFEY3iBoqMNNWmO7s+J5on4co+eLAwY4jzzj01QQMEvzD3b0uPIbUDq8NY9cJoW2Wsh3PFAFZ2Joe63gP7eRkHY8vHX6gbd4uZnVTUcKHLOn6E/2VyjB1hk0cEIO7FuH6WcrImSpNxUypz6HYXh+ZbIwRKk2VTjzj9omoPpJn5TjkFRBUDr4o7zQB68t2hCqjuU//gFn47zuXqtwxCS82gFbam4d3/Q2juAHmPnr7B6YcM6Qi9WJO4OByn5C7chy4I4xfzpfgqb2sYAjt+jdU2jnWzDKRrtq6C663rwMCrXTM5OV2Ys1NqANQ/c2kQp4JxDVipPCJpFiAIxLOV8lA37LWTJoIf1xhEQYECx07ywG3fPrPvhgU8rIibDdaonRpdivbE/fYvv71TwREVjt/waxTXJ5kIJaYayXL5DgLmO/xVV8nPktvlAxhEVlGRZDvGCRd2Ryoo7O8LUE3eVYNUxCC8YC11v9dsZpNK7Mg/sThwi3Qb+c7mEY8O2dMQ3UkpVk0pNjZ5snwXKieb/vl92xZIs7SoBm8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for the new vm_uffd_ops API for hugetlb.  Note that this only
introduces the support, the API is not yet used by core mm.

Due to legacy reasons, it's still not trivial to move hugetlb completely to
the API (like shmem).  But it will still use uffd_features and uffd_ioctls
properly on the API because that's pretty general.

Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Acked-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/hugetlb.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cb5c4e79e0b8f..b6eb92828ee15 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5492,6 +5492,22 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
 	return 0;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static const struct vm_uffd_ops hugetlb_uffd_ops = {
+	.uffd_features	=	__VM_UFFD_FLAGS,
+	/* _UFFDIO_ZEROPAGE not supported */
+	.uffd_ioctls	=	BIT(_UFFDIO_COPY) |
+				BIT(_UFFDIO_WRITEPROTECT) |
+				BIT(_UFFDIO_CONTINUE) |
+				BIT(_UFFDIO_POISON),
+	/*
+	 * Hugetlbfs still has its own hard-coded handler in userfaultfd,
+	 * due to limitations similar to vm_operations_struct.fault().
+	 * TODO: generalize it to use the API functions.
+	 */
+};
+#endif
+
 /*
  * When a new function is introduced to vm_operations_struct and added
  * to hugetlb_vm_ops, please consider adding the function to shm_vm_ops.
@@ -5505,6 +5521,9 @@ const struct vm_operations_struct hugetlb_vm_ops = {
 	.close = hugetlb_vm_op_close,
 	.may_split = hugetlb_vm_op_split,
 	.pagesize = hugetlb_vm_op_pagesize,
+#ifdef CONFIG_USERFAULTFD
+	.userfaultfd_ops = &hugetlb_uffd_ops,
+#endif
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
-- 
2.50.1


