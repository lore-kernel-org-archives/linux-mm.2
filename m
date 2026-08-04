Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0822C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8606B6B00FF; Tue,  4 Aug 2026 12:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811326B0101; Tue,  4 Aug 2026 12:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727686B0102; Tue,  4 Aug 2026 12:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51FAD6B00FF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:04:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0188160212
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:04:25 +0000 (UTC)
X-FDA: 85064059290.26.29DDA7D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id A6B60A0014
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:04:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bEnrVsf1;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785859464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPGFb2a9ru0laCvBoo6NIQpxhSh82ifg8Ri5BJ3BrHg=;
	b=6a7xXs+6R1qNoHQrv7JNVKe+fP9HC+swF91WdmG3xEBYS/6q+Xme4X8f0IxFMfKFlPbCWD
	LD8kQuCPIVSESV88zRI5qoPdeLxGdp9MqzY/0S4WAlHzvNCt+zAz4xWvm76godWRO07sBn
	2EAcpqMpu+539otAUKQadpI6pM4GuW4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785859464;
	b=pKpC0Mj4oIWgqDF29bp+3d8inyKKcakwWcfrrkzXkL/PjKQW2hQ+3olY9Dj3IX8KSYZrFJ
	6tfMP84jIe6jvi0vx73mNuuBnakKInR8QzmoKlxig5Bo1Z5lRf/mpiXKvuOrLnhdirkSsc
	8WLg2BWifUv8S9hxmcSwMJDnfjnIdoQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bEnrVsf1;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HPGFb2a9ru0laCvBoo6NIQpxhSh82ifg8Ri5BJ3BrHg=; b=bEnrVsf1XukxCxreZq9cQGE+LE
	Ludn6I9vlnB/S8i/onQ8Z5/SkgETu7b7vTu3bYKER3eXURLZ2xkpCKIJHURo1OopyZ0v3zjqoTvO7
	e5oleAWNXgWfg+Eetrfms2qwlAJOQ+pBa4u9s//NSJA3LuFxzSMEu3utdH7KCfuWCFvkiVs0O8rwB
	9cN8rVZtUipgZfE/oBB5ld7T42HbZFFgTWJSXT15IkMl8xsg6kOcbj5fNgY0P/2shxMamFnAZhcex
	O8AJgrSAx4603J0IWRP99BjIMPreQl7yJeIr+pq3+Tu/vPxKe//ooAhzAM+PO+iVrMikYsTOC4DB/
	gUDMi2gg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrHcm-00000004Dkw-0qDA;
	Tue, 04 Aug 2026 16:04:16 +0000
Date: Tue, 4 Aug 2026 17:04:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: jane.chu@oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 08/15] hugetlb: Use the has_hwpoisoned flag
Message-ID: <anINf2GGBz0vADPI@casper.infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-9-willy@infradead.org>
 <9b2cd903-7800-4c45-bc07-dca0ee40331d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2cd903-7800-4c45-bc07-dca0ee40331d@oracle.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A6B60A0014
X-Stat-Signature: 7uyw17uzg83wgwasqzruje6yoyiqtf3j
X-Rspam-User: 
X-HE-Tag: 1785859463-372227
X-HE-Meta: U2FsdGVkX1+V92cj/QXuk2F7XE1y2bcnRuTodhoml1F9SOsjjJ3X1BtplZ+jkLPCZEMPTbqhvGee2G2v21WVWqOjD7Dgh52boKhv7XOhtjKVaexlAnuxxKcefxSsn6qDzuM7yvJMJjcgBPmTztin+Gjcr4I7EjvXCXVwuON4WYXPjtr8h79jrZN3eqwsyJissUsNkS0dlsPyNucYqGSU7FA1Ny8wJWR3cakmVD6NSwUYp/wTyjSmd+9xMEuDt8OCIP5Qcte+T+tK3pzXTldZKmHER0RG6gGZTmHlxWagAy06Q0l9hKr+YDmI+NSUPGL+S6cMun6DP1PrFwkgKQ67JdznjORIB35unBk1+7nn/UDySS4CoEbkjD0C95mZXHFKUI/uzAT4kMOwuDWXdk2UqqeRPvNfFBZWdqJ8IXy5BEB1M4eWhcXOgNLX68knzFpyVqVOQin+ONeLVCntvUi8pRd1qplAdZrkDAPWNWnqluIOKnfii+kxx1YpHQLw/MFTTlAEjMx813SdwlMfQ7k8dtqb33ek8fEq2+9k2JEUXd/+Sid+C6fZsrSS1hzmgiSX9ym0NUvUnOoTvZZkPFXuNGM9sjMkShYmgPgOZdGp7BMEIaytqvvNqMykHOhB2n2/HZL71gCQPf6mPhdnPFlVTnENL/gOy6khU3pMPfQL30jKrQykgp/QOLN1I8MoPw0VTPCOduWr/8mgq0GWluZOJP/lbwxxmPQ45DSi85ATd2hWK/l+/Lfrv84wjOdPXWpuOB7k0w4L9qvGI3LaRiRaYTeBGqwWljflgUKrkmOQD6T6B5pV5WYE85E0YrYlzEfr9mSqLXpUyhMDzAY++9lLnDtsT2UYqYECu6eRmmc4SWiH9uunpOvMcXaUc7UL2btmYbictIr4Q6lGyZyE7AsaISPE6FHfFyseg98zoIreICfKS6fazvIpcwPRHifvpicQP9VwEyeG2ERi5m+q+KD
 7d8yBwQF
 e3h9iJfSOdritjfgOhmKzrqZ1unwYpDV8CQ/dSF3QHNCBOzpZbnzBiZFm4uwQf2Vm5s5vPoEW4hYIXBSpspIMTNqFMMCBOoiTj8xjkDN/hGU+SZsgEtOwzfpC0bguhp3qjQQFBfv9IhDL3hSj025CSPXI1vfv9pekwpl1umkUAkxLQRinhKvuzo1GDCV1+ozEHY3CkjBj7/pc9vgSWayQ0mzQ+i/4qqWxCJzQkvx8EQsMH8G+DqrSaa5+Ty5oBeCSNNjGNc6/IjRg9SZW5cWLGDCBB0b203uNSnbF+SXZHCay3aIrmyssCf6UJn+Bbm1eYV7seBF8P7XZMUZICo4oCxVMQAj9gWFQc2tMTrOF5Wu2PNGDcs2IlrU1xhcxRmhAdrECy3IAUSAG7C5v4959sRtBlV+atWTZR0Tz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:51:42PM -0700, jane.chu@oracle.com wrote:
> So, we now have two sets keeping track of folio level hugetlb hwpoison
> status: one with PG_has_hwpoison, another with (PGTY_hugetlb + bit23) in the
> .page_type field.  I don't see a better way though.

Yep, we end up marking the folio two different ways.  I don't love it
either, but I haven't come up with anything better.

> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> 
> thanks,
> -jane

