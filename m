Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE592C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 16:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C896B0129; Wed, 23 Jul 2025 12:40:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE756B012C; Wed, 23 Jul 2025 12:40:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC406B012D; Wed, 23 Jul 2025 12:40:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7656B0129
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 12:40:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8E05160178
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:40:54 +0000 (UTC)
X-FDA: 83696093628.24.BD7A921
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0A8D110000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:40:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nzIBhGMb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753288853; a=rsa-sha256;
	cv=none;
	b=MOvuw2KXR7ECwkjNiMq5MtPB86GXlonpDsY3/haPm0wsbjOLM5qpTYiN3mLl7S08HB7o89
	saakrhq2MRIZ1V9E1pSoD2tNJjk9Nv/xfuf7v2EAH3aYdReRLwpyd5GX7Yq94divUaRB0z
	xTP6N5hHcewHCEn4/tWll3htfxNTxWU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nzIBhGMb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753288853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akq/KtACWEgcCFNpb0lFbw96lnJYIJLajFrKzE0Jbh0=;
	b=LN9VqVpEMMkGYmQmTaQ9sta6jZ5XF1SBCdXx/9YYhsSitBRkibHBKw8ABR811+qs9c4RBX
	qfPe9R40hFKgAgMPljCa7pkKst96GxB3qIb88voAVVy5Be/H7RGNlx2ucD1KohjBXiTj61
	OcukM10fVqs7c2I//R7caZ7exCDa/aQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 1A1DC5C4A9C;
	Wed, 23 Jul 2025 16:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D8EC4CEE7;
	Wed, 23 Jul 2025 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753288851;
	bh=Auza1QfgDYIIjPng+zcAw/jNQE78QKsRUuMw9J4B8to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzIBhGMbYljKtA7nMaS8S0cxqwmbDHpDOE3ADmJM6rqnN4HTHKkQkdAPDpM3L65tr
	 cEiHMeb+cT+Xhqd4JzpisYcd6DzIkSWVXJaXxkSynCRzcjO5T/9GDYKRGLG5AJSXQB
	 yXUp1SF+4tOBO+aqnWQ9k5IiVw5gsuh34KVe07NZGY9WGl2iPRuZmcGkF3neSK7rc/
	 ggrgyX7jS0tTQiphRlJSAhD+aWozWWovaupscFugTGfzPhVrOtj7PZxr8Gqb36nqo1
	 yDgULRzDrzOvE6jRQ/Of++FXiDsTmD8Xf/4KsVY1rOrY2AZVqiC/Z+yxagRXyMnARq
	 ycBW64+wI3Cqg==
From: SeongJae Park <sj@kernel.org>
To: Xuanye Liu <liuqiye2025@163.com>
Cc: SeongJae Park <sj@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm: Add process info to bad rss-counter warning
Date: Wed, 23 Jul 2025 09:40:49 -0700
Message-Id: <20250723164049.6490-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250723100901.1909683-1-liuqiye2025@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A8D110000D
X-Stat-Signature: fezxbats1kmkub36i9z4ezj7nnxsg58a
X-HE-Tag: 1753288852-690016
X-HE-Meta: U2FsdGVkX1+0eaw4ElRZDNDhfq6vPxayJHKIWor8kupYTZFarAtT3LEqOqMyOFz6+nhDq7Vjccxk1mkwJGxwfcVR5eWQRhvULmBAERqig2wi+79GDvHZHb7BjQvaCcAx0lbNiwiEdJI0+oUQSEUDD+LsBGryKK2qnnvpuOAcawSK9o20tsL7awdzO2hiRXu3skMHRT9BcLdsz8A6mDCFFSrnmz3Ce4JKjzLzCm/wRY1vHBVpbIrrz2d6lg17Z/h0YiaTHPuz0hRGTiBVRxRccnO4mNny0kHyZe69+apbfoI745f3dAyFQ0+XGjxy/GTYDgAYHtLoNsvXfWETWsv8uuu/m5TEEaR2rgCSOEiezfWjahgZ4tVS0941bYbplXOHwJ1C5je/HuZp0dBtgrip9BmlAR6FcdaMSSDUfTA7pHqFP7uDpphU+DJPfWxWapFOWogVoHrASoSufPShUoAj7lnClkh/9u6bqm3PP17x+FBYq9IsumoG+DbmOUJUnTtZA46a1Fvr2VvoefauCVWeAKooJInLZP/lihD+PswYmgQu46+ynpBEpp2coML/wQ94n1zDSuPMg45wNMl5wIdKVUmQniFj6mN0ette3f+cBIjSxCTQKvV0+JVdKgrYh2hyg+ueDcHw/jrAjeBn60KhnhWncFXJwtNcBiy4/lwV82YLd+5MWcX96DFcomqmIZultmFFh0wKqnTawXLIuTKlkpfBIE7FaHMQSa8PnTG5wu1MxPOmGlsVNB2TsUxDMkAq2EiB3BrUaKwvgl77d+oja16cmXO91vbX7iGdCztie/m6V9/IYoOZdxMexiWSLSZUezdR9cWGfATmV+2QlXqwM9UeOXHAAMjsC1rh5p2XmliL/FMnUR4s3qMXc7gPmDNf+brvoiiDsdCYIv5TnQK0fxn4pu1OsQ+fYtM7qA38zQjq6NU9sv4zPYyvDa3owG+ZEa7i5ctBF8tHpUEF5s+
 +airDiBl
 sVl0XFHWvCFZvhAUwKjw3p9X2/9kvK+npLFfyp1TmPree7X+r2+683ZGD3l8XwSlbQvpf/w1PoGNwCm+5F3MKPt+A7xSKJWvx85hMZF4Pm8y83CB2L3jOFfS2VPhOBWKlAPz8pX0bWnyrt1V4MhLwF7aU4YvoCNA7LutBgNRF7wN3xrb7FWs8totZdbXSMjL5cJIHMxUFzLynw+Yz2m/xeggc7N1V98M2Q1z2dbPwrY6XZMIvX1T40/zJTalui4QbGOp9M7ErWHv0L5AW3sMvm/J9+YjH27HxvmQ/MHexnTE/7IRJ38De+Sf/jOmRE0Azhqm/Uu2Ubkm8KMqkLBWh4A6FYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Jul 2025 18:09:00 +0800 Xuanye Liu <liuqiye2025@163.com> wrote:

> Enhance the debugging information in check_mm() by including the
> process name and PID when reporting bad rss-counter states. This
> helps identify which process is associated with the memory accounting
> issue.
> 
> Signed-off-by: Xuanye Liu <liuqiye2025@163.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

