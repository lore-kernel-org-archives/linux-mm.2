Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E951CCA471
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 01:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1168E0002; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51AB8E0008; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E548E0002; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AB0F8E0005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:07:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E5251A0895
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:07:00 +0000 (UTC)
X-FDA: 83947756200.10.64B8A58
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id A18CB120004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:06:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J6wZXow1;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759280818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=lyxKKIxSjFfJ0hOkn+CwCNpB7dIYPVWeQozqed8ho88=;
	b=rZGc5kC2wqmns31xmjtdXhByKl5r/kDRoLgzcsIj2ORYInwNuuVEpnkh7onePo8ZXj0iQZ
	3Mw9PleMxxTyn4xdwGGnQBJ6/BpKVIFsIk7BRj3x4EF1taJ8oF/3BcqR1tcMQzVvwbFzOF
	KDnkU/rLtnLqnkKjyYIlf9pKlOILbCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759280818; a=rsa-sha256;
	cv=none;
	b=v2yyc+5pjQozEsELC75Zj9Y17on+raOpccklLpah/AXn6uszmrjM9utQ9ZUkGtOHmn2QZA
	E7ID9J5l8GuFHLbJi1zG95MHnD7CkSQgPI6k1qccii4ev74GSTmkOLWwcbOW6zU6pmvwVX
	IuoUXG6UdhrzPL1mNtIAEQ4RFB60lQ8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J6wZXow1;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b4736e043f9so46028066b.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759280817; x=1759885617; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lyxKKIxSjFfJ0hOkn+CwCNpB7dIYPVWeQozqed8ho88=;
        b=J6wZXow1bHiACR14KOdk3pg1CTJrHvzrOK0lQaYMJDz/AP+sdcWAT5P1Xsuo4CqK0S
         8QkoD3+lixB8lrVmhHC97iYcHWPVfG6GI32sx8YMR/CuxN5XdClVJti80nilTjPvC+gW
         JD10jhwxL3jpaUevWdExGzITs6vcx4JGZ+mJAmLA5x/m9p4RCy+cCTrOnRfVWp92SZ2I
         73ULhRFqlJjnlxbuzZfBkzPsjdpv84AAS0s0uT9dl0vktIAhiN45p+73EcWsemQa6/OJ
         vGPGxEt3yYlFTr2z5Mu/6z6J0h0AWmUUV5EgDpZWF2Vy/7SMXElnUPzKbvUgkhrcwZ3g
         eA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759280817; x=1759885617;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lyxKKIxSjFfJ0hOkn+CwCNpB7dIYPVWeQozqed8ho88=;
        b=kKUHRyoSuAkzdqmEZu2afZfjN3gFyJKTXDvtZSUkLyoLKlNF6zellI7fi0w8BC3MPj
         lrHPpcrbApjVSO5CKF2cOMGSm0zUksa/g6DH5rHCa9yJLMZlI/Tqlp3QOoBkNQr4TZjP
         FjR5l1PwMEiUMwTuELOBPmd9HIvJAh2AXQXh+Iuwn9uxUS9/gsZmxCJnHzC/TTCIkLgM
         xJyth5sThk9uqdIxLD8w8i7LT/8JDA5JwHt6hyAGfBhWb5z/0WB0NgCMzPQBWeW/6Pwn
         PwBFuCsnHlQL+s/o0rr6VWUo6dW3KZhngA6+gPqKsq22YffSJ4t7ieJpz+bdML0EtoUZ
         dAPA==
X-Gm-Message-State: AOJu0Yw57ai7qYzrbnMxLhh7Y+B+ApUGM/sGb54GHgg7QKC5jtuqqheE
	GihCmbXhM18MpW0TRpWVvYFcoAkD9RXQ7kQrim3coEZCeH7dclB0QfhZ
X-Gm-Gg: ASbGncvXBpOtsMKzJQzlCfM/xJFYy4xZi8zpt7t6y6a8OSZcK0uVRPVvFie+8vvLWTE
	+YPcVY1/Ni+qygAWMtv1iWql3SmfJN193hAXjMMo6BIwlkSK9GZ3eJSHNnCrV2uPTtB3rAC876i
	L+W6UCDkCndAxNL+LW4oMbB7ZOX6x0v+v8eNRzAIGRqARpXrfqSjzCE1L2sR5oBbB/gQmoNN/W8
	HPA+94I6MgHP8L/7xPKC1wHfNJ5NoJYzv3ZAhwgFz2dKko8X0JUGoSExj6n/G/kByQrQwHutbhM
	5dNccOx81pKwTvM6o49IcFoMVKG2MgGjLpxBcJMn7jmQpQ8ejWfwyKg5aKcvR0JfUWxLU0/JZg8
	fzHZPeK3wHWJ8mFWlehI5ogojKaGgfpZL9hzqyiwO5mHYn4jyaw==
X-Google-Smtp-Source: AGHT+IEMEUPToDtu+za/wYrSbjujZ+QfkzGxwZP0ZZqlA7r0iyM2lI6rFTEFS2nqqrCyuzWRGPjlMQ==
X-Received: by 2002:a17:907:9624:b0:b3d:395:3234 with SMTP id a640c23a62f3a-b46e8d7468fmr201505166b.48.1759280817152;
        Tue, 30 Sep 2025 18:06:57 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3e4f3844dasm562042066b.45.2025.09.30.18.06.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Sep 2025 18:06:56 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	kirill@shutemov.name,
	raghavendra.kt@amd.com,
	Wei Yang <richard.weiyang@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [Patch mm-stable-fixup 2/2] mm/khugepaged: remove definition of struct khugepaged_mm_slot
Date: Wed,  1 Oct 2025 01:06:51 +0000
Message-Id: <20251001010651.10543-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251001010651.10543-1-richard.weiyang@gmail.com>
References: <20251001010651.10543-1-richard.weiyang@gmail.com>
X-Stat-Signature: 5959kkisr4giogf9qh8kmx5pxp6r9qmc
X-Rspam-User: 
X-Rspamd-Queue-Id: A18CB120004
X-Rspamd-Server: rspam10
X-HE-Tag: 1759280818-788637
X-HE-Meta: U2FsdGVkX1+3lDL9Gj/LY1GUtyr54UBMKYFuYNAYJHxUiwHk6QF6JonqERwHiR/+xGHkzhNM/Nfo4ZGAqoxrEJ6pqHBEEGAt1nRsdL/kXFXEWFA94Zvfqt1o33oHewQ1CQfcz4/7eRM08V57c3AHms2jfZC2uDqa5wPg+Md3TQw8d2LJXH7osx8yL8gB3kL9fipQDxWz74bHLKfVS1rIo1kgcZmvdJBeaRhYmjo72+WJfzk54yw1h6nTH+I74gnhB4X4RmkdUCeYv6cCQMU8VupUhykWL9/gLZvUaf4zDwSKuxsCuC+8Ya4/dH0rfwW5WUcHPsG5VjW+ati+mZ6WLNvEiYYacHqi2NhuMQDH3h+VkpyVfooJdtyE+y4dzaESw5aJHsNb50SoEKxOOFJn6R18isBDPHyw95JWsr04U58cFps0CI5HWHdwgfLDJ4ZA2T60EDNpXwNtZGPhJ04+VWrVp7goW1A/B7HwVFsOWYjt7IiWE4YgUwcKyuZ87E+RDCy8qtlejkDn/wUnn79wSwJBGm2hx0tUhjQwbUy4YV4HQEkjxoEwl+wm4A60zllwYS0ddVV7qaL6Z8OBglxQqdoNT1WtbshdFX7d2VW/vyto2PUe/d0nkOyAolEK/NR90L7PQbJt05DLb7ubaPljb6/Q3WMe2rHIS2FqjIXi5TclvOD8zB1RcaM0LgpAtDlZMpzAY3Wu6+Mu5OeoSeBg2Uh87H933GrZupmEdXeTOgsxkzO1On6au5C3IMN4ncj8sY775YCC78ugXOCUNXNmrjbkNE7TylH7IXWZRbUFa23jg5JcjGeH48B0SY/dWfuQf+uV+yNnk8LGYJih/fPr9PxkW//hKH3lKdDcGY+o0eBHQdsXozHAYD6EU5X3ymrkgnaX/Gxq+FG/5aDrbX3s/L8bKe196c01Omk8JgUcDfskmJN9VtNSK3kx9aSvz5hHNySU+TeYFZUPWiBQxmX
 NhQ98j7E
 EobNS9SCOBPBVGXKpoTkc4e+UZJfA3FI+Ip/G19TKbk4MKE4E8FqKAZk1sAbb9GvQxNx+3o2klW9nBHClxMt9od2Q1KveRD9M5jjpwvnVVcARTSYZatNOMBM/EAPQRpn/cKZ8hNyeMU9kzeoB2h1M2j+uPA2yxqs6MBD/XSc8UNIThTG8dY7o2MPGsmEvbQNZZvavQUCC0ZVM7ZOjGpQXS/Srt1n4aZ7/xTbtKmv94I4t1lBnQuchBT8sXPOgt113LvJtSKcTHFDJFxhZhWFJfeFFS17xVVERlAjcPHveqsGSxOwRQal84eLFzmjg0wNprZ6RUelKYZRwMItPzblmJGdCjTafVB4sTr41AA6ithtCTUulQwyOPBfadPPewmGamEgeHTdtz3UND4LMgshYOVmVfxKW10FoSwWDRgRgQ1TsMVPH/QHVaEKfWBp/EbljyR2S/WG/46aQ6c9+/urfwKf5oj4ELMLjTto43NsRs1KVYOZYCaiz/tvhEn1YrQNAcMHOGJXKYa91/X8s3LYuusV6oB1Ua1As3iTCt1GDyJP+x4DR46jGVb50bEnamgRJBTJRVS1508AsTsh3YPls2eWPLOv0ACFLaN3GHKJkBKSgPuxFnaHW7F29A8j9GvtnHiW52JzuAOw+REe1pyh8Fv0J6pAFE/kzVw6XqZE8vDelJrAfcecJcrywqx2sI+9FjIfYE7rvFC6urQb8+fp3m/ivChoP8hYAqZrjaiJHtzdiPiFrkBPR4HQ3s6cdBaYUxUOF2U/PNKqagebaG7c37U1HwWC6t9eTBnB/6eHKCTaX7OYmf4EETHLgSfIXvuoN0McC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current code calls mm_slot_entry() even when we don't have a valid slot,
which is not future proof. Currently, this is not a problem because
"slot" is the first member in struct khugepaged_mm_slot.

While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
is no need to define it.

Remove the definition of struct khugepaged_mm_slot, so there is not chance
to miss use mm_slot_entry().

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: SeongJae Park <sj@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/khugepaged.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7ab2d1a42df3..abe54f0043c7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -376,10 +376,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = kmem_cache_create("khugepaged_mm_slot",
-					  sizeof(struct mm_slot),
-					  __alignof__(struct mm_slot),
-					  0, NULL);
+	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
-- 
2.34.1


