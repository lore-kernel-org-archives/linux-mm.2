Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48B52CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99FD18E0040; Wed, 15 Oct 2025 10:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9299D8E000A; Wed, 15 Oct 2025 10:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818968E0040; Wed, 15 Oct 2025 10:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 69E698E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:18:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32864C0155
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:55 +0000 (UTC)
X-FDA: 84000555030.06.9284197
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 43B18A000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VD9+tPkG;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHmEXjchUo7p5MNeEkw3mVcK0Ae4ArUpPhVglZardsE=;
	b=CUaQW4kliYHbIforty67jxcSlnbAWa4S+xkWCL0kwagqn6v4+8p0bSs+/ra1r1NHpxCwHA
	3x43hicyfXJcYozUx11nYWWOFoX0PtGY3cHXQ56/0sBUPhOVeGo32GjlBGTJ1PJ+L/QZgA
	cmdzjSjf3P39R2mAn5Il4D2wNGrGt8A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VD9+tPkG;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537933; a=rsa-sha256;
	cv=none;
	b=QRjYpiSSLjIwFMOSfSWkgNm28AnjJ4bI/yxrxLJ1MIRCiE8kSMOcjNLpFRUsg/bxqq4Xbk
	2TOlO/LO3Fuk4Z3SH7PK3ElYxfMc0uhYobhIzllczDpdU9gZUKx6yGwvMYWSeIt8Lh12z6
	J3C/mdhaKcIZ+Brpg3u0PKpi+J+40EU=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b58445361e8so876910a12.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760537932; x=1761142732; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHmEXjchUo7p5MNeEkw3mVcK0Ae4ArUpPhVglZardsE=;
        b=VD9+tPkG+qxNC337kYLsBBxR8uqszoDyJ9oRmffclZfdEv2w4Nd6jFl3pCYYr4LZyI
         4XuhKRxcqqXX9b0i4385hAEKbOnoeNPnUGvvvn3V13DN9F7yqDyT3kHijePshxZzP2+z
         gNn44WZBJKljFDmD9hwANx/hRQDFhYMr8Fy2UXm8Pcw/uzZKZZCcRFsKyinwOsDqmWJX
         DBZOf19V+E8Q/61hjhLWo7c9ETHoVApi2nAqEYW7uJmGzG6sDws2LLZ2lfyd7DQ0U84Q
         khOxHQOSoFSiBnKbpIVPXCQueHowMSClpDeHhKtisf/nEhd6YrMg8HeQhoohi/MLS+Ci
         9Ogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537932; x=1761142732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SHmEXjchUo7p5MNeEkw3mVcK0Ae4ArUpPhVglZardsE=;
        b=ExKVmUbXNZKFwQ24OaVTInUU6SI3q+XkjczReuv5E0dWxgYUfIQVlnT+pvcuhAqc0v
         0RRAAp+9ZTyicSzn4jCpJG4Z2lp1UH+uEg9AE7qPKfBtfcmggvCmm/sY4g0DTt6gYxQK
         d5XL9WTtArI8wvG9fulirS+4QDJAp3QT8qxccJ/zXLcG7fyJbUO4ksJ/IeJ+fMx3AyYP
         ydehHiWV6pNcfJYy7G+MgGgQTLNkgWrQJ18ZIuGrgkReXxjeuxAS2GhB6VfCxSDZvPIN
         gc9R7PhEpSS+pR1+3qZsQyZBvdnPuI9yjVeIdAD6L025EXlKwsG17mjCijypZTQWiuKZ
         khCA==
X-Forwarded-Encrypted: i=1; AJvYcCU/h60ho+BtZLTFiz2ClPfaaAr3Yvi8wRC2Ywv4//iCaIAEP3I1BY/jF/dUTj6oxBYcshGxoNqgqQ==@kvack.org
X-Gm-Message-State: AOJu0YzPwTgAgNoyveBcGD2Pgyp67fLYXEBfVuSqmRHZ0pdIc2us/B+M
	JUkAQ7ZC/JwjBC3GTJGG+YBm+x/4slg1XhlnKIXsLxuEWR0zluKYC7Eu
X-Gm-Gg: ASbGnctns+wAv4Jwm/ZU3PlrX8BCR7w08KKWUYRsaVc8JJWZcjfunGaoJWo4BloCWQw
	4Hs0LcwBZnP0nKSP8gDnquCxhge6OIeAgGIK+stUpZPGTg/GMyzGXxS0Gy8cEckroDY1LnC6upT
	vvf9G6L59lY7FYxkYcflZuc/0q8P9O0hpgSsHlTZFcRTxm4jFpi/Z1oUE8G7VPh9YStw/qNPjg8
	N8+XdCD14adiXO/cqnF5833RsYb+/4E1bCbsT+yC3/T0f7lv0IDryGmN8Nk936UwoVrCn1oqu0u
	AsImWMv5kO4yDOLt/vl1uuleqaAPZK044yqmIGCIc/V+vaLLW4yFaEhzsU3e452hnDKUHAMcvSE
	3bYbXyxlVdHJtyOuG/m0oscPYuFe6O7lP3x2U+ckf4DyhjYST+Ixh6DjM5oynOXDnRDrX26bFd5
	y2q8cK9w==
X-Google-Smtp-Source: AGHT+IGPkoQEyym4vrrdjP+BNzpJr8ZiqPYTLWrM9emXz1prPZyu27GMgJiwVA1OnHpVqgCC5eI05A==
X-Received: by 2002:a17:902:cece:b0:27d:6cb6:f7c2 with SMTP id d9443c01a7336-29091b162f4mr3433615ad.17.1760537931868;
        Wed, 15 Oct 2025 07:18:51 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1b80:80c6:cd21:3ff9:2bca:36d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f32d6fsm199561445ad.96.2025.10.15.07.18.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 07:18:50 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v10 mm-new 9/9] Documentation: add BPF-based THP policy management
Date: Wed, 15 Oct 2025 22:17:16 +0800
Message-Id: <20251015141716.887-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251015141716.887-1-laoar.shao@gmail.com>
References: <20251015141716.887-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43B18A000A
X-Stat-Signature: wxdfqjw3a9qsy46dimardhdaqb3jqtzc
X-Rspam-User: 
X-HE-Tag: 1760537933-681390
X-HE-Meta: U2FsdGVkX1/SluBxTOQZp9gpipVc6fNkYOMqXbVmQwuIkPAccOdl+y29x6iQhzomjNdzd2ZVUFp7o1civZhdyx6ZCTsMnfgEx9Q6ZNK+S5xfdVyznWMspfFK+vwWpw0fKkNEd4QT3a+ufLs1R3VtvOpOk/tCh8j2TaeN+JC9RSps9ZlmtI+dSR8/w6hxc4ffWfpKl0mob/t9mdpQZpcF0hCQMIHDn+aCkEZUGUWlkTFRb3TSor8p7MF5mUar8oAOraJebXuYen7hg+YwBNtTqvyCQ/QvMBx75iPkMdbY2Wzev8fg1yIP6fPbej+4fRqVKpIO08sgDXwdU0GPxTk9RCAjz+PikTzYYQxQut1Qt3foajuGQhx212kV2FAdHIT4MeniBVBrxsiCKxFAJsBhs6aJs+wnENfaP/53dezGp7ZGTAIJSX1BF27WqnP75Sy/0t1UuCOWFm6EHTA71/Zb0iLzaGYQFa3mV4+zCsszjxSqsWf9Mc8ss176i75eI/MxyJlgDB4VK/XWt/N5bzCF4B3K2wa57kZYtCiwbRc9qRs+HkgyDoyle8QVn8aVHVrlTTOEkzlRU18lJBIZq7U4ldVIBuv/zBqhkXE3JjWz2mffKdB2wxEVOJs/iy+QbQ9JqHu9+m8rvzHtLXvUOxVkAd6l8e/ncU6PA/bLrqSgNNBmCz0x4UFN7juuTF2jPxzpQfwoQtAj03pidUFaZ1d0ikdVeSPL66EU/43HUwDyHfHNwawjj6ZaNdKLrI7cE2VbaqIJsKOJCbJ6FY9lPn3qtTDW3wO/xHx5sZCRr0ln33YgESs1Auan54XONygiKOtHIsFRRWKShup+n6BXR3EdUBCniRk/cYE3mgofAk/LFot/6tpVetEdXndvHfAJENlYt58szj++ZoHKHbawMXJp6QH2TQoXDOO5oJwILdgy6Y5GIFh75Wms7Vf2EvGEIqxDftVRJB8T4r6booopu81
 AEfVxiI4
 r3o/KHe4CSEIBHCOGn/xxRydAlP4wbOxJAblMQmIUz6ZuHqHOpbLQ+qgUPLgYypNriNGcl/MkvTlNZJm/GuqN0Q2mwR83t6IBQ1HBBqtHbijjONf5CADXmMt7KO2AaFJHlui/LiBy8g0IjCXTfdlxB9oZ7p65Wit/qlnUXE3SU8CavwI51vShiLuCiAKwog/N7wLaxyTIXY7nc8aN8pZkix+uL4wxvH4CiA7E1/R7xvqzMYVaCABtA1n9NYxiGTpBfCbOjsI6GKNFhDXCzkG2ZkFzIUN7I4DEENNqkg6oWKOfZ6YmaZtmP+gualer0PG0RExOKkwXqUTSx+k20B1vwowgq/+WwM6eXC0odJ1t3wHUhCmFhxnKdcrOCyGHZj8YLYgjrTr/+TgZ8WlHSd7f8AjUYq9WaoSbY2wzrcuVp7N9Q+k1Aig7WZKQOgR+0vp+3LybfKlK3OjUSrO9MOAibma/i0G0s7MMhsvHmpZCGFqFEr6iG2sdHs4zTld7gAITFS88sXHCyZmfsmw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the documentation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 1654211cc6cf..f6991c674329 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -738,3 +738,42 @@ support enabled just fine as always. No difference can be noted in
 hugetlbfs other than there will be less overall fragmentation. All
 usual features belonging to hugetlbfs are preserved and
 unaffected. libhugetlbfs will also work fine as usual.
+
+BPF THP
+=======
+
+Overview
+--------
+
+When the system is configured with "always" or "madvise" THP mode, a BPF program
+can be used to adjust THP allocation policies dynamically. This enables
+fine-grained control over THP decisions based on various factors including
+workload identity, allocation context, and system memory pressure.
+
+Program Interface
+-----------------
+
+This feature implements a struct_ops BPF program with the following interface::
+
+  int thp_get_order(struct vm_area_struct *vma,
+                    enum tva_type type,
+                    unsigned long orders);
+
+Parameters::
+
+  @vma: vm_area_struct associated with the THP allocation
+  @type: TVA type for current @vma
+  @orders: Bitmask of available THP orders for this allocation
+
+Return value::
+
+  The suggested THP order for allocation from the BPF program. Must be
+  a valid, available order.
+
+Implementation Notes
+--------------------
+
+This is currently an experimental feature. CONFIG_BPF_THP (EXPERIMENTAL) must be
+enabled to use it. Only one BPF program can be attached at a time, but the
+program can be updated dynamically to adjust policies without requiring affected
+tasks to be restarted.
-- 
2.47.3


