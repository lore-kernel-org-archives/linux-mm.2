Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED587606A33C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kLNZ1CIW
Received: by kanga.kvack.org (Postfix)
	id 736926B05B5; Thu, 29 Oct 2026 06:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1076B05B6; Thu, 29 Oct 2026 06:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5617B6B05B7; Thu, 29 Oct 2026 06:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 315D76B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:18:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C695A7CEA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:18:51 +0000 (UTC)
X-FDA: 85375265262.26.9F45238
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id F3C4B80012
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:18:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLNZ1CIW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793269130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMyNi9h8uZB0CnN21h3FMGgHT3Z+cop+m15S7SnkkEE=;
	b=awsC67xZJEAXymgeod6rm4+MEmtCHRaX4yiZ57Z6tgfJ7bZmeWwvlazPVnURqy3CDX9uVQ
	oR6aX6IGxRZxEkesCcpqrdfCshQJOVpyd111SWtHjlD3hZP4/DJvfv4wqnBL1Y01tw/no6
	7Z53yUyNDdxZlCSoX/+T+jjF6/FbyJg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLNZ1CIW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793269130;
	b=qVkJWaOYm/9glKZ3sgeYtTIySsXtHQ9Q7tLDA4NgXmLthdkukrNXMW0yaUOQtJZ9lFxXTY
	Xf6wKETnJl2xJBfRlbEqTNUrple7pmBvqOQADWytUTXsa8iX8Yq7exdL6mIqQDieMLOSWd
	CZUCAxSPXh2Ve0TMziIq8IY2WxGe2mY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C5B040F2C;
	Thu, 29 Oct 2026 10:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800F61F01829;
	Thu, 29 Oct 2026 10:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793269129;
	bh=TMyNi9h8uZB0CnN21h3FMGgHT3Z+cop+m15S7SnkkEE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kLNZ1CIW2YxK0uST8iiMQenMa7zmpUsZAyb4dVyOsejE+jvn/l9vgOMmNecd2xd48
	 jLuQs/kZGYQg+ozRL0n6IhurzDdCEhRo34ZyLlqHTCgjl56zP1w8mAoLGwaHEUlos7
	 XtKu82hBX81C7OX3yfRMEihSQnbDEBI2nDB5BE+JjQhabRsawia8vcrJ8sEz9TwHaa
	 dtUbAzMsCJdShBOyvNoLtEIOdw2tn8qslCCM+VFfnQBLkn2doBYK8ZhpkAck2GUgT2
	 U9roVrXu+3qvHtQcvut7xEHw4hDV12vHibzvr+Li4hyvn13zMM43+TVQEF3TCOgmVg
	 rK6RMcRR8tWpA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 29 Oct 2026 12:18:38 +0200
Subject: [PATCH 2/2] mm/cma: accept memory of CMA areas reserved at a fixed
 address
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-cma-multi-v1-2-2cbced8b5cb7@kernel.org>
References: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
In-Reply-To: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: F3C4B80012
X-Rspam-User: 
X-Stat-Signature: 1qa9yr7br5dgqt61j3ug7h4b1xm97hs6
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793269129-295633
X-HE-Meta: U2FsdGVkX1/4U8vxmzcdAe8eVkWu+HNY8yTALYGX2mVRBRkiEWfXy60aKfjCKPKMaV4so5O34oNXqfv8uFd2nhCLeh59wUJai6ds2OzXaOHEwF+w/EWnPWV2/UbYw4QoJXPLmjz+uFRa707cICizvhwhJ17+xlIZDFaAwKbBndKL1wpGCUNNSJqQvxsAKytPOtP22a7b3+KBu2pe+9mp7np43p8fBQBoZ5+ujOnWtFDjOkIkLNLNs1t4Mrb5g4h60vzaYQPWoZ1wFn1KjJc/F1LCSOcMo3e8CFADtPPraEIt2nKkvdD+R41AEAJ+Oqk8FGSgvMavEBioww+Pu/V2FnbLeGQpkP1HJlZQAio/b9u1HznbpW/hzYEWuuFJXeb02BTigCs4xR+xeZEBuX688OkxcizgR+M6AbdfSM/HVrwBrimcg19P4hJEe0vyj5Y+Cz8zl4kI89Pe9XyaT5SkrLdjygug2dSjo9CDIAxRCVQGFgTTOnYY/rIOC9u1LuTWNzlXhY3AnP0MqbGVYDoqujs2UjnElp1OydbzzglCtten6nWgT1lxAa6rhOTMK/g2+TBJbNkRihAlGoY/8yryHgunDmZmZL6YsS/9HpouAVD7nXkPrRBiVQihawiVbcocR+VDfnNTWKZ6dVwE+JKqyxhaAywVffNw/tbHSqUDCK6kH1nmA3BT8GN61NyBNcAts5+dpf7G9HRnJnB1Lk7VQ7+qMwwqpT5Wmo2ezKUCXcLPmamq7VUPzRdo7RM2zkkipc6t9XtAnIXyFdwc84Px1eOsh7VMsqTlu/JH7S/0RpPuUc89QAFSyOBipqnZI7jGMXV3oI4TS7dE1Q1H7TwL6yjIi9PhN5kUmFY9XPoCoZ/jL6Mew12vmW5LgDsat4iNz6s8uKISmZQpy50SsWDjUInrIMeMardY5VXUu6IynOhBmq7q7wqtvuGOShiZnS2kjN/qvM05wMJgIkXGL7W
 UvMUYrgr
 2S/QkqkwSdfn/82yOobgTaa3B3NkkQ7QbivvSwiXRNfJ45M8ghOmNrfWLCLydBDYX3QpCA2VAfqdjEpQkG6bcCyDlQy9JyxqGO8rSPvcHlIw5CxQqB4sNXJZ/V+9EjaYCSdtCIEZnD9i66bWts2LGd8EA/H8a4nsjefslsvJz0UqV3UrYdCIvSbS0CncWJemR0cbH3EoXQXdBVnemSkXYscIwPyn8xV0Fo0TuzbbcPJ9wv/5DwYqLONAGvKSf7/29frOCJDP55Zu1SY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CMA areas allocated from memblock have their memory accepted by
memblock_alloc_range_nid(), but areas reserved at a fixed address with
memblock_reserve() are not.

If a fixed CMA area is requested by the cma=<size>@<base> command line
parameter, it may be in regular RAM and on TDX and SEV-SNP guests it
must be accepted.

Accept the memory of fixed CMA areas as well, so that all CMA areas are
accepted regardless of how they were reserved.

Fixes: 75d090fd167a ("x86/tdx: Add unaccepted memory support")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 0035efb1130a5..f61d52796f4ef 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -381,6 +381,8 @@ static int __init cma_fixed_reserve(phys_addr_t base, phys_addr_t size)
 		return -EBUSY;
 	}
 
+	accept_memory(base, size);
+
 	return 0;
 }
 

-- 
2.53.0


