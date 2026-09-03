Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 460BDC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 05:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7EE6B00C5; Thu,  3 Sep 2026 01:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57EB6B00C7; Thu,  3 Sep 2026 01:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6ECF6B00C8; Thu,  3 Sep 2026 01:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 896156B00C5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:36:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 160EFA0474
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:36:06 +0000 (UTC)
X-FDA: 85171339932.22.C1A7918
Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0FE1B40006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:36:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mbe/UGMJ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788413764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcSsjwFC6qZg2aS8oY+lqt9SWth0Py0NkNsT3ZKbGGI=;
	b=KPdFYnnAnBPvqs6ysoE7LTkJSXgQJRb9CE+/tTKwKYFNBof5vZbYA0hHF6KQRJHycZmtwi
	MzBxYTkRty7h+ItX3aUT/R190biaNTD1PKQTpbuWLRZhH/oo6IdFYF+hKB9UreYx263DyU
	MZvkxAybzj/53xYmFUNSZmLGJo0vRPo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mbe/UGMJ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788413764;
	b=4wwzMhLxMBW+WyC+nXC29uxZtaiaUkBMhJmkwjds3RbxU8Wi+Syj5TVDRNAOfmnADV6jJu
	7IXNUY2w2Dj1ag/8qM/OORl6EDsSedwC7x3Pwq6hX3/j3edUoEORc8NuL1P+CfC3n7LAVI
	gsRg8fhNgl4/+kZOnODURBzaHrahbMo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pFx9cx0I838cE2nczWgH9ctLbDnOiEyF5R1ouuYP4NQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788413762; v=1; x=1789018562;
 b=mbe/UGMJyH1rOfM5Ld/5vxSk9loP41r8KSqZ9An9nyPJeO8fCLPWYanz+WJxMgt6PvZddoSi
 ku7uZp+Ho69Y4IkrmvIqMCxEV0vmjzhKpyJhCYNX2SnoLhE+7QiihBv9L+ucnepxsAy5VZ8TS62
 uv1V9KQYurYNPg+nKrygATbU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cee8c7a11c707db3;
	Thu, 03 Sep 2026 05:36:02 +0000
X-Mizu-Trace-ID: cee8c7a11c707db3
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 1/2] mm/page-flags: Define HWPoison test-and-change helpers unconditionally
Date: Thu,  3 Sep 2026 13:35:34 +0800
Message-ID: <20260903053535.17611-2-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260903053535.17611-1-kaitao.cheng@linux.dev>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6rdhxc9wtgwiox4wius9gn8wkxa4g9ec
X-Rspamd-Queue-Id: 0FE1B40006
X-HE-Tag: 1788413763-808923
X-HE-Meta: U2FsdGVkX19litDnjNAm8eli75aX71zSGy81frYbWTPmJxScdqTgti9RzKtEbEFSoaTWpgY6hALjLzNI/TTQU3wcSqjRt++yF7aFLg1V/W9l4ee3oZvc3Zf8EeARFYddmGXOgBEQh7kMs9xPZOM3OoH0mBG8mzPJt914e4myRXQemQx9X2v7KGHeNc/tkMd/drf60nBn9dNdye9ARyo7kfoXhOEDuX2YsIcRiHM+FKmMgiAc8RxmmD4YA8nd9/CCNoxQjO3GcaY+ajprjQ10FTkEDz+m+tW4pczuITpRMzejD5LnZvjbGMabWn+A5cJ2Gk3ahj2y+sFJ+/HVwrXkAZhqRaKOsxvQ/Mizw5p8eZuTvBsZzR4wUjTiEkWPAMApdKGyHFTaOU8PjEgZYwpD6MgNHea0sEPdwaRnqUJ2zoEoYo1C2l/vkWa8OwhwNKOwsOTGQg3BDgTGlYm9f2lOs7zxVwggUrc5bC0w9to564iHHuraqQZ+OfFP6EYfxeqh536+z0JmnDCEWjc9La5WGsJtVIFnnczHJ1h/jY13U/3Pkm3m+eM1rnWqbCUmFkIYJqqUTH9ekW5DbEGn1sw7Xo4rkQ5zmhXVk+hoygRnXPXio14eWOj2h33LL6FSPsDVohBU84cGp1T/F0ZKBbWCehn9jEOgblHpvuKXyVcBz7oexLx+O0XW9vlQnSJUdfnW2fQB2j/9vvbdQkddDR8SfG0GnmjnBFAOtJ8S0IngUL7R2dZx82EJibxWzCSAHSHx33gcX5ojseWGzPtONLfbiTwE2VoOzwuRRmuuwP1wwbw6HHtPmjw8SsihpfHK92juI5TUzntU6JuuW9nMA+YBVXVEGmFsExupbMVo+lQo9Qgx3JQSuaS0oOaZ//KsRycvpYdSN0FFUkctjCSY5xG717Aqej5sxpttv3dGrRH3LRCvhxcUuwWq98gt1HAtWaOUSfOYzqPi4HcNB5Wj/pm
 +MoClP4a
 9dD+G8hD2lte7lGe+5U4w23K49DvPxR0eA1q8ucBwOoFwzLpFv5OGvzR1HD6dbpelRl+u4khnOg8YJdeezDBs9zddrig0xxKFfAncgwTnQVZm/riB80edcVu9/kOGccB7ZO3XVZ52TLAHWuoElWmAHuqoEXz2fOyBEsoqhkR3WT23d7HRgs9ufuKnkWhoyRZWiAx7gUhYfyMj5ZcYtxz5+mYy6PCLw7WPOT6B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Page flag helpers for configuration-dependent flags provide false or no-op
variants so that their users can be independent of the configuration.

The HWPoison helpers do not fully follow this pattern. When
CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
regular, test-and-set, and test-and-clear operations. When it is disabled,
only PAGEFLAG_FALSE() is instantiated, leaving TestSetPageHWPoison() and
TestClearPageHWPoison() undefined.

Use TESTSCFLAG_FALSE() to provide the missing accessors when memory failure
handling is disabled. Both accessors return false, which is consistent with
HWPoison state being unavailable, and makes the accessor interface
consistent across configurations.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 include/linux/page-flags.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7a863572adce..a2315ab1dd3a 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -656,6 +656,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison, hwpoison)
+TESTSCFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
 #endif
 
-- 
2.50.1 (Apple Git-155)


