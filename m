Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121AAFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 12:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE706B0088; Thu, 30 Apr 2026 08:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572A16B008A; Thu, 30 Apr 2026 08:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485876B008C; Thu, 30 Apr 2026 08:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 382596B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:54:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C2C814023C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:53:48 +0000 (UTC)
X-FDA: 84715214136.14.3E187FF
Received: from cvsmtppost30.nm.naver.com (cvsmtppost30.nm.naver.com [114.111.35.114])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4F12240002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:53:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=o1yye4r6;
	dmarc=pass (policy=none) header.from=naver.com;
	spf=pass (imf27.hostedemail.com: domain of knw0507@naver.com designates 114.111.35.114 as permitted sender) smtp.mailfrom=knw0507@naver.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777553626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FkHLlUQFgSv8TzyefueBLdzmVyw6apzekzw85il9CmI=;
	b=6IA1DeIhxqFWNikwkafZbCb46hbee2mT8V3+Y3hdgo+ejRuTfeINn7fR+rVy3H7aQcER9A
	p/uLXscd2xRThkRQM30iaY3lLxO5biv8CEdGW9+qBfGPIicf9VPK4lvchateHVhVAbv7fR
	9Z7WKQZxu6BuK1tzC8uSrcoVpz4e3zE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777553626; a=rsa-sha256;
	cv=none;
	b=b6t9YvNel30MHyMEyGipmveRnz503L9xZIn8tHk+vJ8vo1igPzCKHJNBpkXsu2Cx54KsPO
	67ezr92am7akws2E1jax8t0bk9f/DqxPDVBdyN40fCA76A/srNQ/RNCn2agnE/L2CDn5/C
	3otp4LkakIcvtQ0sZj/iY6ywN+gvAMQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=o1yye4r6;
	dmarc=pass (policy=none) header.from=naver.com;
	spf=pass (imf27.hostedemail.com: domain of knw0507@naver.com designates 114.111.35.114 as permitted sender) smtp.mailfrom=knw0507@naver.com
X-Originating-IP: 211.241.110.121
Received: from cvsendbo015.nm ([10.112.22.33])
  by cvsmtppost30.nm.naver.com with ESMTP id TlUpt52GSqGfeaoCPEZKjg
  for <linux-mm@kvack.org>;
  Thu, 30 Apr 2026 12:53:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1777553621; bh=x7fz77AUp0fvNlRyefNDsTooR1pD3LHc8Uh0yxCJINk=;
	h=From:To:Subject:Date:Message-Id:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=o1yye4r6dzAkoyLm8Xv6i9qz4iAeeTaEVqLP6GXwOZg/+eXTnKVOYKfXYXaHoWCB/
	 hFk0rjxZtbbb4grIvz9Dw/dOUdELkMYw1XtQHVccOK5LziOsbcGMPGcQfhgsYUUvFS
	 1T6qWBHLEBkaqyS2iYTa2wOpADr0p/dg6pQ0x0IA6NXfdm3EgYZpSiQ393fvcmC3au
	 vo7bO57OXoBk0Co9whuZJyD+xZcykx8EJfSxfJx97qci4mBly7N1iGheL1hPkqih0n
	 ICEq5gvhNA9pjq7XBvFmG8ic755K1w1d2QIg1TMN+pNUIGVmrAe5E43KkL2lhuZEON
	 XRYtI4VhBmmZA==
X-Session-ID: EMVedqyGTkKlEEQxxYPLOw
X-Originating-IP: 211.241.110.121
X-Works-Send-Opt: BqnrjAJYjHmdKoUmKxJYaxglKBwYKBmm
X-Works-Smtp-Source: emnZFxbXFqJZ+HmwKoUw+6E=
Received: from localhost.localdomain ([211.241.110.121])
  by cvnsmtp004.nm.naver.com with ESMTP id EMVedqyGTkKlEEQxxYPLOw
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Thu, 30 Apr 2026 12:53:41 -0000
From: Nyunwoo Kim <knw0507@naver.com>
To: Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nyunwoo Kim <knw0507@naver.com>
Subject: [PATCH] mm/oom_kill: Insert newline for better readability
Date: Thu, 30 Apr 2026 21:53:21 +0900
Message-Id: <20260430125321.5679-1-knw0507@naver.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F12240002
X-Stat-Signature: d89ji1qnpk45atwx6przxpd6csanfsg1
X-Rspam-User: 
X-HE-Tag: 1777553624-324309
X-HE-Meta: U2FsdGVkX1+TcoQienKqIFqaI7RHpMYPG7OXJmq64NpSextnyyww3XR7td51YasQWCmgvzw3BW780jZtWTQmjc8n/cLXa5iCnPsn4b1vDh+HXqycK9MqLgg8ewFWY0zwKinRpO1P+Jk8ldAzFfx2zBeSN3yZH7bw40P9vMfGMmEHDaSM3SVpLUuq0eduBsOa54Jkh8lkGLjC/yu0b3+5WPFtqVWLUhlOWy6E9jCRDkJNKs3O8wEW+885VB8wonbYTpJEMgG1707QxKWEgysmPs2Z8kR65/QFBWZifGfQaeTV5ELLSCakfmV0el8SYKV8tl8yW9EhgTgM7gu4BoouqN0WungRLJZaFL6l3N25b9mryRdDyLPGpYdQvvPTtqMuwOVVtmm+2PMmyAZOjSy1sn1l376Hg2SjRDOLeXd/lHLvbB8R4IuBhed2sPPCSr9n9RQnmNdDb4OnIWiK6psG/IU0lfXarCattUUsBpRWIaznS+KXQQ38fgWK9e/mLmoeCN5Jhx0PI/StBRlVJ4X6KOUvpMj4c9qQO/ehgxm0VjBxsfonmektB2neRlDEbwI2035yDFpYDLtjy39g08W5tkrFgX7d6+wfv4zm5BVcqPvePf364ZNpTA5knApUgOdKmi/ZyvDqsvlEuY7sMRREpPdUZymlkYDvsOoQhg1zr7JQ3EQ2lapwWJzh9bVFuWOvK6hzt+vm+KlIqLGRnW1FEdVLAMJx2i5i2/LHJV2ZWJODRBgjiTarqeYdAmleFxdOwS8nDI0gDcVE0s4+nSW9LuTBAmoWn+VBckvkP/6TYD11ROoVyKfD2iWhXrgYukTZ0aShF3KjvSLAYmYbCoSGUha+x9vEMQ67dlFlGoppIOprewfeXGQPfgTulFCr5pnEKwYO9ch9L6hcZJoOdXhKRFArgrekE/uh2vjobym6Qx9EEf92IzxMbQpZ8Jy/nXoO7nJNuPz0ykuYZQNRk9f
 6AXzYynL
 T/9YmV8MhwnpKHpJQMQ3QJV/yMViOv1cmOr7MpnnCNCsMsPEbl0aEoiTp5JyX650sTmv1sFLd35DvTnjhLXpf/Vk8bQgUYKNEv/GIfR4NvZzA6YEzISZVnvoEW0j14nMOudDp3o6xknacdcNgaMvdhiM4ZaAemW0dzWqLEhMAjI9I5B0jr58OtABxvPSk0gztYgJnk05r8oSKA+X1o3HWGdI/LlVnNX2Biz9X37wBZDAp5bMYRYasYdKn6vGgrjWay0CzAIdTCt9R7w5eE1JqfkUivEwABDCWA2ZeLdL0Pt5c4BABwUQ63qRANaI58JU4FW+LGBEWeGueKkAO01jtxUtTOs61OsFD8VCrlSg8IecNmZMMt2w0/Pu7jQu43fk9uh/KO0Y1cI8QGhMleDF37Lo332ynxS3Z2okLh6OM0oFLjho1D+InjiFywOt6wp10VH0ydyvcVZiPE1y/x/9X0GizzgwaNeJbIODRSYWy+1YSerwJYlG/9KrJ0cMXbd4ET7GKmDPSGGUVAvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Insert a newline in check_panic_on_oom() for better readability.

Signed-off-by: Nyunwoo Kim <knw0507@naver.com>
---
This is my first patch and I am using it as practice to learn kernel
development. If this has wasted your time, I apologize; it was unintentional.
Thank you for your consideration.

 mm/oom_kill.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5c6c95c169ee..86a08deaa697 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1076,6 +1076,7 @@ static void check_panic_on_oom(struct oom_control *oc)
 {
 	if (likely(!sysctl_panic_on_oom))
 		return;
+
 	if (sysctl_panic_on_oom != 2) {
 		/*
 		 * panic_on_oom == 1 only affects CONSTRAINT_NONE, the kernel
@@ -1085,9 +1086,11 @@ static void check_panic_on_oom(struct oom_control *oc)
 		if (oc->constraint != CONSTRAINT_NONE)
 			return;
 	}
+
 	/* Do not panic for oom kills triggered by sysrq */
 	if (is_sysrq_oom(oc))
 		return;
+
 	dump_header(oc);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
-- 
2.25.1


