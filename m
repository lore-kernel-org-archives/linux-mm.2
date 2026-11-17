Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6CC606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WtlZQ+/O
Received: by kanga.kvack.org (Postfix)
	id 818CA6B05B4; Tue, 17 Nov 2026 14:13:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C88E6B05B5; Tue, 17 Nov 2026 14:13:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706D26B05B6; Tue, 17 Nov 2026 14:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3C96B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:13:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DC14805C0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:13:40 +0000 (UTC)
X-FDA: 85445560200.21.0A2300A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A1095100003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:13:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="WtlZQ+/O";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794942818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWNOL9oXi4FJBrMo2p57OMhawm6GSyZyZ5LAMYiUucQ=;
	b=O6/vbPlKs+UsgeRHltkV/vm/HbZKVevqFXNu+W5vbRAeEzUNkhKyeJt6Wh/3Qudfmh0cpr
	sO0PNRvefysCWxwTSDlWwK+j+QvthaEDDHsGiPiS3AdCMbBLI/OIEWlsmOEGkTxhUKGLPz
	PHwDX7JfoUTUJSpz5S3acTnKMlil+p0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794942818;
	b=x1deOxgBf5hr/swN6nLxqo607VP/zbuGdm+ZvxTmI3MuU5YHrSoELbCthVIXxZ5IPfD6k/
	B6bLBNhz9zrozOzZay+T1RbxJiFYAIxlJvZww/fPE5UuGsy0YRrSX1mEdfuYLwOF6tQUcl
	H0hQtBrt0Ih3VG9Z2PH1ZCWckDBX5Vs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="WtlZQ+/O";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11CD6611E8;
	Tue, 17 Nov 2026 19:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503391F000C7;
	Tue, 17 Nov 2026 19:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794942817;
	bh=DWNOL9oXi4FJBrMo2p57OMhawm6GSyZyZ5LAMYiUucQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WtlZQ+/OHjaHXLWloIGtS25tyanq+8IWJJe/8vkj9wMY/KQMGZfRw1c9kowZ2CTHf
	 lsEPr93LQloDvm4BMKAR+rjyb2EgO6oro0uuEJpiz6ObPWpl7+NDpHWdh8jMFx7CgL
	 E3AqCnhT3t0jkD02Hfb8B4kNtPtdpoHjAZ4Lc8Z8=
Date: Tue, 17 Nov 2026 11:13:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Luiz
 Capitulino <luizcap@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_ext: remove unused page_ext_iter_get()
Message-Id: <20261117111336.ee49c0d4722a042c071c68b0@linux-foundation.org>
In-Reply-To: <e745f91b-3312-47b9-965c-510bf0a0b7f7@kernel.org>
References: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
	<e745f91b-3312-47b9-965c-510bf0a0b7f7@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1095100003
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tdddawewihazzwsb7o9pjyrydx6e48ir
X-Rspam-User: 
X-HE-Tag: 1794942818-515839
X-HE-Meta: U2FsdGVkX1+Rvbvy7m1KLAmwA3H1CdiFNtRHhzRWZaFjm/9Zh5iKzH8g2QHOieMeHfqwz1O+cWkJu8WDttDqdmhcFytDRhQpzB5Q8UYEQP8slm/gT4lOe8w2Qpi2Y0j06kKDh0KYOTneDHLLSAOtd6B4HYLWhIxpice0mYkCSoayLNZQW2uI9pDFoDwjRy4thGHhDD9jOFkwmB2QcxHzsy4RJcgw+dp3moE2hJpu+U2JX+1efm/lKhXapges7MBV2W2C3U0MkTQgnobxzGu9UqSYljWRwX+OF/D81nZeieLUWzmFzh03mabiWDUXB0fJsd2LrY+LvMUXS6mC4fSh3gcx03LWKnCtFuxo6skLxE2XPfVQA9L7d1THJdbh9VDbyoiV8HqKShAkzpUjaD16UR+g+yXxl3LnniAEBjSv4H8tR6R4CGeOw7fO/GdeDqlHrB/dPNBwrw/rfJZBWOa0o+1jxA8CVOAJsoskF8RkY2w74GkPQs+IpxZkg07vSKlfRgGIuDozm81P0NQKXJDhNIwbNhBp0zKb1B3bmFv68ilG5fqS8k2brNAbdNRIOzDJ6DP4qNMuFMjUmeWPQtMvWQEt6PqUPbbi78dtqjxR+LRArwg4G1LmZvunUKs84vM/dvBxXAQSB07uxbYtWqNpJSgmrQrDKnjDlgMkch7ujMT95VmaXMww5k8/An3pARvzlf4hoeei5+TIiVKHHV6S62Z+Z7IWF0gc5mtE6GNY2BbkBy90Ub6fxHUcX/4KCqXHB698NhweN0lXvPU3CmqeXCb8H7ONHfPiu8NREWh89geLydFPpt6PUqTtOX1ChGZ8xY10j9IqBy4uuGb4SWnySfxff6L7ZORtisGZUAGvPK7TbcQUp+SHYUf1HB6iXdPFa1VH9WAiOq37NA2dkl13baiDNDA8hN0f8fxdd/nOcmsqVUnOcDLT2NEYOX2BtqmIaUxOySNpUztXWrudmX6
 mI5RK/rh
 cCVeixa0T5uX0yAHhLBviS7BDtiixUE25M12jqOF3eHibOPEqM8ibhGraCPT7IZSLwf85GCYu7dbEUkM805uxhADDB7fD8N6SRgt421Z43ZVUWHipmhGXJgv2JmEQN3Mot+ZUh/NLM9G4XDTSkMJIsRubWVXMkd5zKRYtZZtXQpVKFJUZ0PMPOewmks3ErkNOphH1+yFPrTHeGgNeh1T9U5ImT0dxrbUmLrFUzvxpH8Eg45DSRlPHRGcr6YASFuDqJRq9QjtnLGAnYd9F744mw3yUB6JckpjE/ZRxxv+LzQV3eMOc3FH0DhrpnP3MpTzY0vmS8MkLuBuk9xunxghgu06Icovf4IB9X3J0JESyLPprxuU4Rst6NZzGOBUbHSBxmR2htBzQOpJAVetpukrhshYZFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 19:50:09 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 11/17/26 17:26, Shivank Garg wrote:
> > It was added in commit 9039b9096ea2 ("mm: page_ext: add an iteration API
> > for page extensions") but has never had a caller.
> > 
> > Signed-off-by: Shivank Garg <shivankg@amd.com>
> 
> Added to page_alloc.git for-next, thanks!

Thanks.  Helps.

> Hm page_ext.h should be added to the PAGE ALLOCATOR section. Wonder if
> Andrew's patches adding various missing bits included that too.

Nope.  I'll add the below.

A few things under mm/ include page_ext.h so perhaps more mentions are
needed.

I'm presently carrying no patches which alter page_ext.h or page_ext.c



From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: add page_ext.h to MEMORY MANAGEMENT - PAGE ALLOCATOR
Date: Tue Nov 17 11:05:44 AM PST 2026

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~a
+++ a/MAINTAINERS
@@ -17779,6 +17779,7 @@ F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
 F:	include/linux/pageblock-flags.h
+F:	include/linux/page_ext.h
 F:	include/trace/events/compaction.h
 F:	include/trace/events/page_isolation.h
 F:	include/trace/events/page_ref.h
_


