Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5BD4C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0F86B00A6; Thu,  3 Sep 2026 02:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E889D6B00A7; Thu,  3 Sep 2026 02:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F486B00A9; Thu,  3 Sep 2026 02:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B77AE6B00A6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:34:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DF53140428
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:34:48 +0000 (UTC)
X-FDA: 85171487856.11.6D463FD
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5BE841C0005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:34:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Ak5OpSKK;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=jOt4ICMi;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf18.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788417286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lOsGkjx8FvghBalpLXZpmIViiZLM5WeBkF7MIb6oEc=;
	b=IFLdE19IQR2OCygXIlPsxlVJW8pChCwiYzMxy2i2UyYN5V5nuUckIoeCbtfZTQ9Mx3rNCm
	7hR2m8FLg1VsuTt/oqtnvpjh9mlN9rWRlQ/EOq87rDYdou806k1FmC+ix5kCL6P2DM189x
	0JSt92XHplUpuAwJ/qBNq6qJ4SsuVE4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Ak5OpSKK;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=jOt4ICMi;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf18.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788417286;
	b=1b4QaE+9hVgkyyugumfEIqoOZ9jpk8kci553b/hmuiraf/RM5JhCmZcyO44FiacvD6+ZA0
	yDJHQGxzfTOyhfTKY8oxBPhSow9eOp24L2haZvUDnixn4guB0Ypg+vGQ7Bn1LI5+aCh8nv
	SKiZyld4x9yNmToQGEHdgovh5lyIGHc=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4hb8w44WmqzMlFs;
	Thu, 03 Sep 2026 08:34:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788417284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lOsGkjx8FvghBalpLXZpmIViiZLM5WeBkF7MIb6oEc=;
	b=Ak5OpSKK5k4V1tz/HiFQOESNJgKKNRs1RV3HbkrzegXSxfWzf9nI+kXAxpD06yhuDOPp+c
	KgpJx1leZiokokw33U2+3DJ314vD+casvlLn7MCBgDM0F09f2NviLRhzQwOXaECWbZyv5X
	i4eW7fD+LBHoXqNlm/+YZbp60ZwVw9o01yKyB7CowR6UNOMztnKAKLl1PC9yuJCPV4o4oy
	Iy2/OJ7z17ZF5fB7HrTrqC3NOqdXCA+ePeteUQlZtdkwp25P3DTqVEbzn80V02gmWioe/+
	6glw+VK5jicbBHz1yS6bmw9QBGfAYUMkLfrsTR+8A3+3WCA5TQxyouhG8+mLxQ==
From: Manuel Ebner <manuelebnerli@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788417282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lOsGkjx8FvghBalpLXZpmIViiZLM5WeBkF7MIb6oEc=;
	b=jOt4ICMirwM/HK6EfjtqHzS5IPGeFOgVxnGSKH/rx3Lcn2JmeLCwMwEDFGxenHGKbqMI2m
	xy6Zd23CvZ5wGv/CjiCLPlIwfyHdT7P0YGXlvT1fL9s260gkKDaP9b40OUixTZUBT/td4o
	SH41vlwElopM0yIqB4KZz0uCHs5Z/i81pagzGHZCxwDiZmaz/W+1yuyUtI3Hf8TikhO1u+
	Kl4RPFGaYiSnv3F2UUDx6ZQEt2dlx9mewGlCDpOw5Ai7c0dz2iFomeNMLfnSxXvqXVvXe1
	qVw/olbqN/PXqrjie3dak7dyXYGlvCuooiyRTX3mhvnWLG4cDbzvLaNgdzGUVg==
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: admin-guide: Fix bracket
Date: Thu,  3 Sep 2026 08:32:56 +0200
Message-ID: <20260903063257.711435-2-manuelebnerli@mailbox.org>
In-Reply-To: <2e2333a9-dc4b-49e5-a09a-47fa502e0e22@infradead.org>
References: <2e2333a9-dc4b-49e5-a09a-47fa502e0e22@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: psbz6ihqd7dinhaz4m4x9gy5s6f1pb5q
X-MBO-RS-ID: 9171e99d099856e7f34
X-Stat-Signature: b9g4m71wnm1wmr9smhcx9yezgnfq9x1k
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5BE841C0005
X-Rspam-User: 
X-HE-Tag: 1788417286-797558
X-HE-Meta: U2FsdGVkX1+zQDA9HciUTFArNy+TD9fRzFk2blm95RIhcgyiNCfesqSsyEw3+szEZZ52FaPP29JcWu0jkzw04lvl296kfGZ7E3dMVrO4hi1vVsf1mmPpMWYaVTsEMEe2nbx4cHnTdAWPV5LrR12FZlV5G5VC5vMYcHA8puDAtjogZxkMj7cw4ocp3cF19b9R88QqTnnukauwIYTw2Hg1Bl8mm50oqQx8qRwK68dkjYJPFpk2tkExczu7AYAIElaSM0L+zTcCGcYhI1/BXddFyvfxwI3KIcwPdqPVztfNjDa8ezW3EHTdQ1YsIQjeecnzivBxBziM9ItA/k4IPIkLrvsveeJSMHCYhwSPxoYfV//soc1oqwbxdVfU7MyvoTRJk8k5Q+latY5EwIN08sN95uSuxu+SIw6nU1HJU7ZkiovJB4I0bYbuNWURWd7/h+gOBhEYbBhiQipoZpPDkRL7urtNzPsPh2uIwbFZMLQ3L/sCDtrhKbvkMxKTxJ2yc8vuYzuWgowCgJuIuW1c2Rqdnaxf2T8yLTJ+uOUtAEjJz73Ev1dgR9mktiGVbDmfTDsnYnEnLY4q5dCkit6if01xRcfZiTDnwyXRzD0uGWfqVXXw4BYsMbrFX7+dYZjhVyy8iNKMMZ/CnU1OrvjljFhRD3bXKX/v4gwQvCHEK7Zc7BBNrWld2tQ6vovBAV+awfbon9F4fc5HpA074Y8Ybo37hVixjvZ47wj737QX1NMS9H1VSTIdgC/mgMNo3yuTgoDyiThHUIP6fFlTSXFLgqus8C8am6RlZJhcRz6E9zXOOTQNNMzcz3OiUjZG6U2Cb9EgoXH1FFKGZ3DVLt+Eok+yI92JnyCc3yGweaVtruhZrkXrdG7sy7ScBDm7wUez4SHXWZ6YfnOXtzAeMP0En/K3OI0/cbPhIGX653oPNAbNHnBcvvvx2zPPq2Qkin5HEtRuMrK5B8WBfYx7r6ivSqj
 O/k3CiLi
 AI8/hoL4w+gEsI8/5Q6Xl4yQXvBQAP6Dt61ovDMWGIB40vrNdr03TcR7bbdBhzjdrTBqpIe6EgKJhOsU710XcXjnVmBGK9/YzQa4NzT9MgZkk5wJE8BC+PFSQ0c/DKhQhUwvp+yRB5ftbQeUr2yIaL+EpWSrElwlMwcLRpQipTUwdNUvTBLGZK98VQiirkwunaBCNpK+SFzP3dXhAPJSZ1xoXYpPTe09iHIJIiwh3e39Oe6G6F2StPjdjAYeMXcBt1ajw6Kr1oDvg0eK+hZWG72cXPU6YC7CRHmvldrx64JkQahVxUND0PFIcbMrXTfrNpdGqPqWcr3oYPJPcc2WgESK2kQYukIbH7focNEP8LPEVDZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add missing ')' and remove ';'.

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 5b318d17a..5f4a056e4 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -438,7 +438,7 @@ zone[i]'s protection[j] is calculated by following expression::
     = (total sums of managed_pages from zone[i+1] to zone[j] on the node)
       / lowmem_reserve_ratio[i];
   (i = j):
-     (should not be protected. = 0;
+     (should not be protected. = 0)
   (i > j):
      (not necessary, but looks 0)
 
-- 
2.54.0


