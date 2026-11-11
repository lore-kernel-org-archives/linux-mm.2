Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4168560A2606
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=d9Av/BHV
Received: by kanga.kvack.org (Postfix)
	id 63F4C6B05D5; Wed, 11 Nov 2026 04:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF306B05D6; Wed, 11 Nov 2026 04:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 505B66B05D7; Wed, 11 Nov 2026 04:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7796B05D5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:37:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF34580259
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:37:13 +0000 (UTC)
X-FDA: 85422334746.27.D2FE160
Received: from mta1.migadu.com (out-231.mta1.migadu.com [95.215.58.231])
	by imf06.hostedemail.com (Postfix) with ESMTP id A0C1A180006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:37:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d9Av/BHV";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.231 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fU9XfcyXyDYY96b4oLkbxP2QCB6xnQM84ny0U+EIIak=;
	b=G2rwRHQiSmi3WFxlmAuuJnxL6rLD4N+FhnGkJKWSh194V4imrAsn8SFKwqZRPZXHy44Dvd
	c6tH3Yy1td5d6cntpxFKl0WfoBRb1Q5pK/nPj5Mw5MRCcGLjCkPaJxYmBj2DkNoMAH4e77
	MGKWRl6UsJSNiaiYHMmUkq/wkI1hM7s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d9Av/BHV";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.231 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389832;
	b=e45+i17I43XozUmI8UDU8lYru9/oQOsExyf1iiU8fOMDzYhhfTcRSlyZK+KfAcLoiGbvBd
	pQ9PU1da8sEcN0W1aLeFSYKn7T16y1Mvne7oL/uEr7wpemwv9oJzoqTW5WNgMQu72EuLcQ
	7WxuuySDIPM8CigVdA2wigTaBDIO7Z0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6wp3khVZFr9nCgPoeJN5KkCAJtgzTDUmCQsA5IU4RCg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794389828; v=1; x=1794994628;
 b=d9Av/BHVMSaBOhJ9tQ4D+vWpZKoty1v3C0dRUpHbHptA8MVuGOCheqnA74/ZXe9jFnZ38cIg
 A/EmWY7naiTBS9B3vdzrolqw5pIS3BBYlxKgp3eFFpQpjBHMGvn6lVZ0O3zmyPDI9LOHH3HQs1C
 jafFTp+ux8W7ZGoQ5nHPLHd4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3265524654880463;
	Wed, 11 Nov 2026 09:37:07 +0000
X-Mizu-Trace-ID: 3265524654880463
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	link@vivo.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	tujinjiang@huawei.com,
	xiao.wang@vivo.com,
	xu.xin@linux.dev
Subject: Re: [PATCH 2/4] ksm: skip rmap_item allocation for non-zero pages under only_merge_zero_pages
Date: Wed, 11 Nov 2026 17:36:57 +0800
Message-Id: <20261111093657.123292-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <5445434f-078f-47d8-9851-dcc3712d18f1@kernel.org>
References: <5445434f-078f-47d8-9851-dcc3712d18f1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A0C1A180006
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: szezyh98cxcgqopgr8gd5dqdwrzmefcp
X-HE-Tag: 1794389831-565678
X-HE-Meta: U2FsdGVkX1/64WzZvJ9gyDhUBwqwD1d6okeGQYnqUTMIQWNba2jEh7U+N9WOpEXTbROmgG9Re6ZkmgMKru37MxglWo86X85W9chlzb1w+CFNHaEA13SNSOXBRC5X+pJJiWItlQg4VqmHopGzgpFBCCctDLnLx3k4/hd48nwVh4NjkZSvhTaiqyNU7xLwEvkcyG9lE5eskL09aM7sVEIe8V/qAKj9oirYk3arvmfiDnERTFch9PymkUlvJuNwUj+bDzaGHyGbY0tCpQK1PFsQh+2hLFM+hNJZ3MAkcKpI7p7w1ldOBCT8QLH6B0ZOHd5Yj3howiu1p9FTac41XZ6PhPySRMyuK7afxpKi14kZOBoQUD+dRO4eLgiTtLokRY5wOxNjsRIIkBXqxk/kSbfuNvpdK6BbLVlwHHChESynpPjpTfJE9TdZ13jTY/XE5yZD967Z98l0A7pRgQXGxxrCbtmHkFZqSR5ieyynZD2S4/HL1Annn2e6u3yENfqpw8iGndRubnxsCPaYAhPK3jlquaOvfAwZkJTALaAD2ps0KhsrbX5ivCcUgKfdKykB/HhVJzjEC+PBjv0xJ8hh0Xr4VFdzEI8AJHX7qTqjxgmgiX8TH1RvC9OMVWofKXexaxo+1FA9zMZ1jahrph3prXIQCZbcMgO4TATSofpm+8Zq5Wrm4S4RoD82lEecQ9EatWkoSe07hcFxh7CEAFMw+QkazLUTNTq55PF5EffheKnbIPkzXPpupRGYk9iy+NLiUMCnHQJusKckLXdG/Hw8f5aHS0dADrZlR0SGuhS93cTqOSxCDlM8bkyRRMdx7cqR7Yy9v79n7ZY6t1uLo5jTTbAvRKqXj3eNsg3sQpPNmGLkKEvH27PDHWhZry9m6R4dj7LY27hU6tIwx//VTH5N7e20+mkx7OYv2Ni0o5dd61cIBmF1wfU63dNZ4eoSTHjuWtvWEgI1y+1PjVYkSELUPaf
 o/dNXfDu
 dru43dYDy9UT51Xljoe+iJloNZwHKeoUTKWS5y92deiXcuOtIoQ26Ebh7tltomi+h/oyEWLx8x5orqMoUqQj0OyR3XlVaouiD1UqfFraN983nfJIX/6cpO6K9FzjEPQGqxe2/yZ1OmWFOyWjV0R1zDjOy33ugz74Mp0+nK0bcFzbdoXo9ec9T8nTkAynbaVydrbN4xz5zud85ZE/ecY9uBg/d11gfnH6bZfT/6v94e9bcU/sgp2hROg39BkEwUFO0zF0pKkXrztq48yQMAXSKqcZ0Dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> I think we should get rid of any rmap items when merging the shared zeropage
> only. That might require more changes to the ksm code, but it really doesn't
> make any sense to have rmap items.
> 
> Maybe we just want a separate KSM infrastrcture that only focuses on
> deduplciating shared zeropages in KSM: get a page, see if it is zero-filled. If
> so, try deduplciating with the shared zeropage. Done.
> 
> Mangling this into the existing infrastructure might look easier but it just
> adds things like additional zero-page comparisons and (as Lorenzo points out)
> makes the code harder to understand + maintain.

Makes sense, I agree.

I actually thought about doing it this way at first, but went with the
current approach since it looked simpler back then. Without needing any
rmap_item tracking for zero pages, we can avoid rewriting scan_get_next_rmap_item()
with more complexities.

Splitting them up has two obvious wins:

1. ksm_do_scan() becomes much easier to read:

   if (only_merge_zero_pages) {
           scan_get_empty_page();
           try_to_merge_with_zero_pages();
   } else {
           /* existing logic */
   }

2. We can even add better filtering in scan_get_empty_page() to speed up
   empty page scanning, without making scan_get_next_rmap_item() even messier.

That's a very constructive suggestion. I'll rework v3 this way.

Thanks,
Xu

