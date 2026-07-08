Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7475FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 21:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C276B0088; Wed,  8 Jul 2026 17:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD566B008A; Wed,  8 Jul 2026 17:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215FD6B008C; Wed,  8 Jul 2026 17:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC4B26B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:35:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6689B1202EE
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:35:55 +0000 (UTC)
X-FDA: 84966917070.09.91B4E0C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2F65610000D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:35:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1YurD4Bp;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783546554;
	b=gWWY0kLC+BcWwcNSL/eDqFtyWEbbR9vpsIr/HXMpcoTDOjDmFTBW/ql1a4xBIxtTCVApUd
	uexztEEy5VcTz9hWaQwKI2YKgl6/UPiDQnSFfDgxoJo8eprI/pccIL72nZykHWhCC2iuZe
	kNP8Q/qvT8r/RixYzMON8smJcDJlx38=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1YurD4Bp;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783546554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=v5GQi58UpKN/xjPR77HNmT/9H9qJkRbf6vrytCHrfhY=;
	b=ARkPTNRZMagGDqKYSejlQc6NqeVYlYNR8zZqK7OMq2CcsR3wjmVAbyMuf3XXoZHLnUje1u
	RcrxgNE/lu5UC23RtELJHlPONrjmYJuH4uEsDy4JtTwZ7MgQVlNVoHpM/Ym/y1lEEgFp+t
	R46//mb5SsQ61pwqmJLUpmv4hCvKENA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=v5GQi58UpKN/xjPR77HNmT/9H9qJkRbf6vrytCHrfhY=; b=1YurD4BphaNx7EJvKravGeZ5f3
	STQE+OxHlj4n5qi4TV9obhX9YI2u++s8edlTugW83CTAFB0W/FMf6D9likbdfWwxEReUSj1vN5aaK
	if3Xn/kz7QVu/cxxRPEddlRzdjt2ya1Jh00ONYsz3qZjyaietR18jRY/i8xx8KuO/OMbnpnurk+GG
	MXnLGnZk7z3b+C+wz9r+mW1/npZeWajHTUfPu4tanNSILdY1Uzb2ZFU29noQCXmzoFWjzLQoKFYhV
	P3ol4yQaZbxCzmfB29c5vD3kj+yYSBBYKYgzfnbo1gBtIChepwgwXLv5gtx6Qa4F9kplY+eRIb38S
	HwmKTjEw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whZvp-00000000SCc-0q1x;
	Wed, 08 Jul 2026 21:35:49 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Zhen Ni <zhen.ni@easystack.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/page_owner: avoid docs build warning
Date: Wed,  8 Jul 2026 14:35:48 -0700
Message-ID: <20260708213548.469155-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2F65610000D
X-Rspam-User: 
X-Stat-Signature: 3fr3sgdyofgutwbic1nskcd96oakzjic
X-Rspamd-Server: rspam03
X-HE-Tag: 1783546553-298035
X-HE-Meta: U2FsdGVkX1+9YYhiPbZXp8UKW3oVZOveFGnkEaIrltoXUIg+8QgSYbAQJwz7iUBQ7f5UzScPfUr6RXC1D1JjEjF2jtOnuD1owsbihkZoi8g9vBGZbDFAPHROYbqei+cN6pX6hMhsceYw1xU6CAaPRscbVFiqsON01bLwfD6yKAb64djK1rR2ID5OJrvOYuv6jOUU/eLKNfvNn23W2KJFN1ubF9g1YhObL9sPovkPTLzEEKfvQpCb/CjysILGdwDE4tlACp2yexgs1qA7dTKQ1e+JqNkxG7Gf4GNnYE6ZBVgCu+IkY99qceuT09HOeAK08JYWb5ZSF+WdAFzmlbMYqYRKlqwHy9wowaIJ4O6GZzFni89LXYkJKWr+2IFPl1CcA5KPutt0G68d32TTXTZkohxOPlWG8IgpSRlhHfAT3nMBlX+ZCFmO3vnWUgeSFIxc3mqMErNESahHiNmLfa3o8tcdmLim2xQ7uWoqv8A6YNMB7hy6c6RLvglj3oxjt5hEzBFlqeNgKAgwgXrQYr7/nkRM1dSuZZ0IZ1oJfXKp1usKKRuVpTUJpOx/0rVWjpyNpc3dqGoNwoxM9g+47g9Nrb5RCfP0rbw0tn9KfVhASNf+4lkpgxbYx2qWAXzmzoA1Wk+Mrb8433mZLIJqcZ1J9qZqGKHiP0yzzqEiWWcYXVARxp5oLV/BbkR6fWB0cHCD4dobB+6lIX/26V0aVq+I1Z+Wfrnet4vGRaeDy0sLxmDDcsYS8+s8RyOCYLS1RVRI/C9ykwiDJI8Ii/mcew2J5zie/2hIFIPiqwrDGC6lGhFjn+8C/5NmnlREhCdaSQUFDR+M1Ks25w9wUiogfXcS+bwQGZvGz/fs2ie0ENJkFwPXILlwogcx5Xnq4C2NSttQ25YUaGpsw3WJn1DRzyuE6PTMkLjWpYWDNYuFOkV4ZcyWY5BTQ6bDLGdI5DNu6OW1a7jWwJ+rB3kqLc2spGs
 VAL7jV5G
 hInd/aptx8A0jNumEMYZAUq7YbxDm/XQzjvrvaWmeQyExMb/S4tsrOEWdp7f83FWcOy4XMTKY9Kc9fQHZRnp3qrHe1O2VMlZwWruEgUCQLGGc91jYgL1k3qnQNcZYBxBgTZ7tkRlC+UISKWvv7zNSkH0ps9Onl2gAWAfLQHYaI6sab+7XdOA7iJvcIU/qKgMybasf+FV5IP0iA78ajqZ7xKsdxzpnNKhXmYL/yFkwIf1NNM/c1bSSgjTY3EDNbil/wzr4YgcGmvHo1Qlstgt4NV0Vlz+kn6PcI2Y+jVTUz5JoRdSKx8FtQ9gMOYoqVgI6xvpUzLQPLg9vicsPYejwoJ00IpsxlERG9ZIWNeVkd8HEtHG+DaFsbeLT53Iftip3VvZpxzvidvx7Bmr2ApKhNQYzh3vmitfLaqslO7oXwdeWaKmE2RBXgBuhJFnG4TqAjnM+VeMFWGAjFvhTKY7UOpTQ9zAWyWvrfn1mBUxEkKEVXGqG/zFBJg0eRKz66/d2uNVM/9XKCGEtz+7EQJYH9kM3U3XqaEHv5p3aKw8GpueJm5cuK5kLvzvQBLhorL739JOX+TvMR9rhDZ+lNC0o1wPKA7nnXgoDY3ZK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix literal block and indentation to prevent a docs build warning:

Documentation/mm/page_owner.rst:70: WARNING: Literal block expected; none found. [docutils]

Fixes: c34eea8cecca ("mm/page_owner: document page_owner filter")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
OK, there may be a better way but I didn't find it.

Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: linux-mm@kvack.org

 Documentation/mm/page_owner.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-next-20260706.orig/Documentation/mm/page_owner.rst
+++ linux-next-20260706/Documentation/mm/page_owner.rst
@@ -65,14 +65,15 @@ un-tracking state.
 Usage
 =====
 
-1) Build user-space helpers::
+1) Build user-space helpers:
+::
 
-To filter page_owner output:
+   To filter page_owner output:
 
 	cd tools/mm
 	make page_owner_filter
 
-To sort and analyze page_owner output:
+   To sort and analyze page_owner output:
 
 	cd tools/mm
 	make page_owner_sort

