Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B14AC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7C96B0092; Wed,  5 Aug 2026 10:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CEEB6B0093; Wed,  5 Aug 2026 10:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A3E6B0095; Wed,  5 Aug 2026 10:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26AFD6B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:42:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF5611204A1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:42:34 +0000 (UTC)
X-FDA: 85067481828.23.1AFEDE0
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id F152340010
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:42:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NL6frJdF;
	spf=pass (imf11.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785940952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ld+XQ0JcCd/3+XlB4VjbGbKYAZ1iedXZLkBJ6yeGTpE=;
	b=jZmQ/WGcqSm4AmSbobeoKAURw/JWRXC7UpDfFmVxneGfxU3+FbWRwe3H/jW1GZr1vWXqgE
	4nZXxFmB18fYb+fMTXx/xo6KITP00eNKLYfAa3Vee++Acky8pqlT2ByOp4bTGnPRr3pisy
	Z7yVOgWYl8Try0+utm8b0KGM62ObFOI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NL6frJdF;
	spf=pass (imf11.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785940952;
	b=ym/6HCIznWic+8c/e7k6ZCb3cQXCxk2WCUwuTuvOrZHNK0cXoz9Sr2ZcD3nC6DYpB21K2+
	RzSDyLxfO5UEvl85d5OoRK+yl8TAjZrbOt9nAmBj665fxUtHRP6RAAdXN9ol9IQMIvi+V6
	y2LSyKf1NlHrTlmNZ1kqGDVvQNSmse8=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47f71156e1aso522206f8f.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785940951; x=1786545751; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ld+XQ0JcCd/3+XlB4VjbGbKYAZ1iedXZLkBJ6yeGTpE=;
        b=NL6frJdFmazr6CQuM/tLmiC9AdxWBoIyLRbvC7Xq3OlJiMa8Shcm0tFqi5TlRLMImC
         SIslThrkBPC5F3zkaMJUkSvpd3ke0yb8FKcDgy4Yfqc6qT4wxskESVH+/AxDJhcFkuDS
         K64M1b/bL4sejsD0mi1hiSJItVV1I5C9PmGNg8AItofUiEgDz075NNwsl+UfC4wfyfYr
         TaiEK0rg5tBs56LFir7AcbgKpDV9P3buYMDF2FM9shhXf/w/SzukqiDNWKpUaRXQxKQW
         Kv0lSRObpbl0SDtp6LAZegSKHe0QTeYPZrxM+GRLyMzDWnAYKPB75qcApFck8LOw7z9B
         kivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785940951; x=1786545751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ld+XQ0JcCd/3+XlB4VjbGbKYAZ1iedXZLkBJ6yeGTpE=;
        b=YAOkAiXPNvqwu/kuURtXHSGUas1XFLu8/q5UnMGB55rAp/fEjl7+xE+2RV+JjlrGbH
         dIeqQEg371LK8Mci5+1JeAM6brYFFCwuZ65s5aNbRROzw6pAgPhbcvCNePEbm0BOSd+g
         Uwr0i4MXuvegKHI42NjnK6CXNz30PbweJC3z/hS1Htj9nLOHHsUoENe8BlY6GaShGlKc
         BX8KRqUB4p7emkSNxCNmYVrI4VSKF4Mgof5O8ZTpjxW9MrnxbGqjc53KHqJ5GkHwnn/R
         qRx7ZCsWTRC/EMJ5sPCIuL/g5bdj/i72UJjdN+izXc2uqbmXyMahntsF7tp92BfA93zf
         evHw==
X-Forwarded-Encrypted: i=1; AHgh+RrMMlV6iLHR/KH5l3k5rhf5U96wA3ZA42l/eXmVpnPz9xVX1/GvkZSwth/n3Ayai4ey8zYMNhFnnQ==@kvack.org
X-Gm-Message-State: AOJu0YxNb6rHue0kVxrOU0cyHRqkyGUAY3Gd0dxVR3b/0k8buHW/MeNl
	qPFXYiEDuhnJKipkAXGnOOn0o0c19BrI7qhPcj2cn7YFI1cexzuxmx6V
X-Gm-Gg: AR+sD130vMC+SNjr5SJoe08pY70cpjnmlgOXq8mspA0ewFUJKbcjkARAqtcPc+cvwXb
	x+Co/Bfcb8dy3Cmb9VQxdX/dosQSMn5DYJJU+liBOXrpYzks72PIqvrnlerUktisIYRmHy7uWKH
	pP/Uy4NSbweXO/DlHbr6atT2UwBOZKSOG94wikFynGA5y6LVvTN3IksSEJ+v5eWj1mu21+Q+aO0
	SwMBWR9kuQ6ToD14fiWz5/bNBn6lp/4bLTnyeaoZsN0OZwEB3UOVt8mq0yD8KIsKmi9y/FMFH0g
	i6o/uVxXpNmzi7JMJJFmT3NQ32z3Gdm0u+2BsJBBXnmNzQUK9r/KKSv6Helrx4KdG1DMglACCc8
	pajD3mm9TklhxjpPFZmO8ejTRK8B5mLcte/2Y9yRjrdxrR84J8PyJjVVMbWXcBsa+9bxqOea9zR
	gZAxBFwz8RxLmmKEDcmjU8Mh5x8ymOyXH9Y9kPDEHB13yggPXb3yg4xQh0F7NfnbyHoEkH9fQcb
	AwumNdDF9lD
X-Received: by 2002:a05:6000:2489:b0:47f:59ef:bbb2 with SMTP id ffacd0b85a97d-47fec634cecmr11644817f8f.17.1785940951438;
        Wed, 05 Aug 2026 07:42:31 -0700 (PDT)
Received: from LAPTOP-AVI.taile24b5.ts.net ([2a00:a040:1b7:4f41:6df7:ffe8:d01:255d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232333sm10094289f8f.18.2026.08.05.07.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:42:31 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Arjun Roy <arjunroy@google.com>,
	Eric Dumazet <edumazet@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH v2 3/3] mm: return -ENOMEM for page-table allocation failure in insert_pages()
Date: Wed,  5 Aug 2026 17:42:19 +0300
Message-ID: <a486e90cca91f443552b70ab2a18510bcc5dd8b6.1785847364.git.thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785847364.git.thnkslprpt@gmail.com>
References: <cover.1785847364.git.thnkslprpt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rweun8aejk7scba4rfar7uo8cyg7g8nj
X-Rspamd-Queue-Id: F152340010
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785940952-826360
X-HE-Meta: U2FsdGVkX18ycsTf2LB0gCXHF31GE5/jcEO8qOLPt8yLrtWvoc3bRIaDQ2IS0rLPifPE42PO7NOmxa70mp6P4nhFi7TejefH8v+OaeL5khc0EI7nyeaFeWudgxvf0xHUD29EqkkgjaASexKiPK1OFjWSTDV+G4MpNeuo956Kk/B/XCJnPQeJLCRruZVEq9si18hHL98+ZQQSuT+SAuxw5gX6972my94qi2rqUNrOFsb1MTpNCuJuGEOuob9T/Rz3o2/OIe+y94IDGX0s+XKYv76Cu2Xe1FdTO72jO9Tq9hOfAegf3wo5kehZ4qyUx3GytJRtpNTnC2MsmcpPK4z8oJ+iXayRCjeA5uzH3wom/CZCGUhmaNMjTrKcH9lliuDZkk50/po0Ej/kpiZqRu+5SZgBuPNtyKw+XnQCU/BmDXW5Hi/rGPKlQuNbX3vZMHVTzrRzlttovcs8yx+UgiZCJeNYAxdZaLE5Yn1rXKzSGduzUFjwxA9V+EwcjhaRe5qV7sFi+7lVozabXPxCOss6JHngtl1ILw1lxfGJ4Gfbke6fJ0uLIvDXuRPxWnxjXcTF4HanANBrPFpB5LCMvL6YdMC0+LlTLyZszGSE3ZT+/fS3m2vyadsjyCjL+YVJWIoqQPkil8SVrf6VGF3Xwqk4R6f2NojjqfaDZIInD9NxQIvdq0+0YPrvo4xlGcEW3tdOwCYSNPcuY+1I/EtK/HrotnfcrRy1sZVymr2uxbxO3AG6rtBwFoSzHiMcbY1nYS3tv5a9S9ogZu5OFwGWil9qZMKgedpJx0D2b8Q1UQcuOo2f3hhs8jLXvS/NZMDbH6+/LBGBnKx1k/RHzeiyhi9QVsWjwaS3L4xAizKLz3kIq1tvQ9qq4abjt9WCUJTTCTN7fLtHcSbcICGPzC0/K8C8/eFszDkL37IiRTSVX9+SdIfeczw5R5pMC36vELHig78rvgk7/YV2vt9JIP8lcTq
 8M07qd9E
 sxQB9itrQ74VvoCrSoT0MIFY/w/i7+fsrQS79vhx/quhud0dlP2bJaoH0YlryWHlRcF7Pmru902FwMhGdA9ljUBEqZgRz8yoBAWXwJME/93TNCklK2TIYOJ8o4D4UnupK8nzThIFe9QuJrwY2kP1SrUnaxQRPFw4vs6GoTZ6xAs7yjaY446kw0EHnEIpu5rGFZvbPJGiIUif1CdqJTIvHRtr+X/STVZjbfvqTuoOMqNBfbWgFRQetEiQHvfQjME53KjuCdRccmw1mRHI5ALS6wGQntksYLhydTxIo9rXg2RkjpaVh7oAuBwnVFr1kM/OHEMD3gCE8Rpk0+bmvqEal+4k1DDkE3Co1xK2L8wNkaW+3ZDwFS8QG0IFLHZ8yXOHhnEtmXy1lmYOcY8S2he9kL3YslUlEsfmnfC19yDJKIawKnV1+SnzumhDX2vr9t57kGvGZDrG5rDyzhIeLUMAomROIBNF9DgqoKH0SJxVEqMj/enUwulVrJcA4tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

populate_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
pmd_alloc() fails. These are page-table allocation failures, but
insert_pages() currently reports them as -EFAULT.

Return -ENOMEM instead, consistent with the subsequent pte_alloc()
failure and with the single-page insert_page() path, which reports
failure of the same page-table allocation chain as -ENOMEM.

Address and range validation failures in vm_insert_pages() continue to
return -EFAULT. Keep the later -EFAULT return for
pte_offset_map_lock(), which is not an allocation failure.

Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 11bb4fb98761..16093479d341 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2438,7 +2438,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 more:
 	pmd = populate_to_pmd(mm, addr);
 	if (!pmd) {
-		err = -EFAULT;
+		err = -ENOMEM;
 		goto out;
 	}
 
-- 
2.43.0


