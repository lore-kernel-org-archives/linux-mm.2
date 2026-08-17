Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85DCCC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 04:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62BC66B0908; Mon, 17 Aug 2026 00:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602E76B0909; Mon, 17 Aug 2026 00:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541BD6B090A; Mon, 17 Aug 2026 00:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 331AF6B0908
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:40:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC64614069C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:40:48 +0000 (UTC)
X-FDA: 85109510976.07.1146722
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf31.hostedemail.com (Postfix) with ESMTP id B38F320002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:40:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dMK9o+Jr;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786941647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sig0AIK+CTyDREqz+/6gNORlYF2lEzPEEGGXx1ld/m4=;
	b=lCbnvk/v4Z0xjf+q4TMC9txtDTj6WRIO2h/jatpYoyauEMgtGX7ty2Fbt4ezVA6CmuTTZf
	PkmWcyAGd46I+AMnmx0LzT7y7dJewu7PWWwNRS1517r4HI7EJmiXPbBA4Sd3slJyYLePel
	0/lkCrL/etfaEF1NSTF33NRuiXniWyo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dMK9o+Jr;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786941647;
	b=cZ/YN8HyQ8JBD/wTjiVxg1N4OmnhhVzNmUEa8LDw6otVDHblT1M6geC7TmPPgANa7z14Wq
	swi3Os0IsbBm6YUvw3MLZc8kvsSHLjOTqqY6mEoYnMOdQGbEJdj7wQz9fCUIOfYlxA+T0C
	kS6w4osFew4NTZReSRM7OsXOq+RapVo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Sig0AIK+CTyDREqz+/6gNORlYF2lEzPEEGGXx1ld/m4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786941645; v=1; x=1787546445;
 b=dMK9o+JrgYkBBQFORz/x1H6fIOlz7GAJeyZcXqQZPE+mue6SBqtpD8+BXmpwfl4xU21c5WwF
 TOozHPmNRBzpBSUEh4mEViOPOurcnLpFH8EZvHgdJkjoR2+xiujETf7MB3K3CZDmOxNeFNf2peA
 0LWHLkElAWzOYaSxeAcuap20=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 2bebd8705dd01731;
	Mon, 17 Aug 2026 04:40:45 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: nico.pache@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 6/7] mm/khugepaged: unmap pte before releasing vma write lock
Date: Mon, 17 Aug 2026 12:40:34 +0800
Message-Id: <20260817044034.85870-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B38F320002
X-Stat-Signature: qw797k6s4d7sc3hzt1pudktdoox5xosf
X-Rspam-User: 
X-HE-Tag: 1786941646-981999
X-HE-Meta: U2FsdGVkX1+uTAjZjx+pSK2xvCl7Tdq6queqxSeu8Zqkd44BO2+aN6F3tY2XpwQixcNoJFp9naXp0XzzmyitTDwA4jdJWkbJZeUI28N7+EbKskXDTM7dssybGhMy5A+jWGi7ZLWyCE8nJLABhs+qf8LkXRzZCbaMoynOIzxgvigl5ATTfu9T9camTPTjAuqzEMbrkl6qLuZ8JGb+vPOqrC9D2gNFbs+m/+UURv1FDEG1iJ57r4KhIoCykiUvnfuQqOjWzd3w5dgVscb4D/8hWL9mfYuNQb2qHNwEp6lHWkbL/TCy3UQf6ja65ns89MQw8fbiZ8YT4hwvwLKUEweUgNqNpu/stfYcTbT1BnAUxr2M+y0Z7BzDc6kEOyntK33urhYWArYxc/Fa8x2Sp8zwWLbtXDbnY+LLo0j/DzzANr+jXIGYqdcuce9swoSgFCJKXKw+1s9DZQY0jv2QMcnymUTW9VUknZxs3npigKb078scH1rLTXsqkpiQiRoiR/HzdfouK2naTUimyzptAQTG2ltLzFPhnsGfVGrl1u5leIZMUY2OQ5Z7M6NzSp75S2q5127VvK3APMq4dUAhtUJkcqVU9H8hcw/xoLw+OEOeQd6X8FDchkNEDQEqaPPsZLmmXWz8V1D4Am/30FIahyhBGnkAPTLw4CLDf93kNJr7hZwegPTSyQy3XpYFMdjVCNxmOxIdWe6B6DxxacRCXUnneDDalAtDfnPNJR/KKUikeNe+Ljeld4KZLMCnhdrDpj2RyaRk5qLmAn6I9Lm4WPnshrhdk9DFHb2vdWnvugY4GFhcldPohxVW0oxlqOHTA9aNP6420rn2MPUKsmAP7faMX1sG/bPz2zlpXYQyQcAuUM8ded2z4khHP1u2/6lnG1cjtz+as4euiPx9RnUh63LHt5nzIhSuJnFe6pbo6tu7Wu/z1VRzbfYqv3VGRGD0JKggUeGGP2kaafDglCotvwC
 opout1cn
 HBBQwTrGLXXKzqD3vkXAMo46FXCXepE7qOBlx5hMDlc6nMI2Yeht1gWTDu6SQR0WT87xTTfQVbJ8NBCRpyJiUwdnMgY9vMritiZUfjzWRxBZjxHuyo8tSZ97Gs5AZ9ZBB0MRAodYbw06YRska4oNP7N61PRLPVlODJjC+Lnmd8c9JlD+61qDcqH8PODU3wO/qe+tFyQK1DDEK9FtB0fIKUf69+ZfI0gMl9XO5tum/INBwcz+7yxD/ZoHTboQ/WnnOIN233ODAH95ZOOWb/huynuVVOkUWsYieqEYWE8lQhektfnkgfibbsja7R3u1+sknOF1k06vp4wnyooZ4RCdsaXoTDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 11, 2026 at 06:48:38AM -0600, Nico Pache (Red Hat) wrote:
>We are currently dropping the anon_vma write lock before unmapping the
>PTE. Although this is safe, due to us still holding the mmap_write_lock,
>its safer and less confusing to switch the order of these two operations.
>
>Suggested-by: David Hildenbrand <david@kernel.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

