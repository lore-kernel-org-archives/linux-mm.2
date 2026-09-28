Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2028C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 073126B00A4; Mon, 28 Sep 2026 04:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023556B00A5; Mon, 28 Sep 2026 04:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7AC76B00A6; Mon, 28 Sep 2026 04:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6D206B00A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:59:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F9F2160147
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:59:07 +0000 (UTC)
X-FDA: 85262571534.11.7B8E7A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 88E4018000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:59:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Km6Zv/DU";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0tEMEZABMUMybhQ6JMQ4iuwXaDpmcIr5Zo58vu3ZdY=;
	b=XJUqy6liKHO8kett2oTeuy9oSp+n90NEl49bB7/HU2z9bL0Ur+/4K5P/mRgrY1K84Ppk8e
	lXgNzy4oGTjQTzued48clZwmRCmOfCQU95QT5aZFUPn3YWYZKxU8RgfYGwVhSFkHwg1diJ
	TJ5ul8YcQILXv5QpPRYkwkxZ08yPtd4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Km6Zv/DU";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585945;
	b=fnNZyDNDGbp9/8wfov6feo2HG4fZ0Qa4nm6AI2tXqMUXZtnlzQILCdVO4DCxFPlqvfswCb
	oTVgdMWHhPqtaJxvCn4aUtVNdFRuj7AoUXCvH7Y/OKk1C2yzU/rMcyPQtZeDxdNz3U0Np8
	VTXkPkYk/23UcLoa5t/9V3UYATtHEdo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E132040421;
	Mon, 28 Sep 2026 08:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4AA1F000FF;
	Mon, 28 Sep 2026 08:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585944;
	bh=w0tEMEZABMUMybhQ6JMQ4iuwXaDpmcIr5Zo58vu3ZdY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Km6Zv/DUH6aAZxFRxoenVGwlabuEa1T5ncTqhrPo7HROhIDbZxwUE1JiNRG5L+M+S
	 6OFqQN32BFeW4HMpGoFPtF4g2SKVJ9wd2bdd/2+U/LDBNWXC74ybkJHwbju+zm0dtD
	 YBTbagaezSQjgbZBiuvRrFr64Fl4FfpvD8ZLaPdj5znk4cODIDTA8zmYtXunt0y93n
	 F2h+FttzqIkSPkSs9LU3vJTk2OKibGUb/U8tZmKz2rmZiAfE3hIQ6NXuDNz+4P+WU8
	 6g9uPo+ln95qPZgSMiG8hiixwinAPeXGIjYd/9MphMfU6b3qH9mF/H8/rhXIsyJdEt
	 8+ACzM+uAbNFQ==
Message-ID: <e9d81053-440c-4a69-a6e0-6d0722989383@kernel.org>
Date: Mon, 28 Sep 2026 10:58:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] hibernate: handle potential errors in
 hibernate_{map,unmap}_page()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
 Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
 <20260926-hibernation-v2-3-235f69f3ab2a@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260926-hibernation-v2-3-235f69f3ab2a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88E4018000B
X-Rspam-User: 
X-Stat-Signature: oqd5yjaeyp9w7r6odpggh7q517b8o9nj
X-HE-Tag: 1790585945-936373
X-HE-Meta: U2FsdGVkX18gifzTZQEL991SJI0bduPPY9z8ebzwijZjBZEiAgwUgr1w5Uw2gxPI9L+nX6Oq+ucJ0st1wqflrDp7mA/DkgkOQ4vdvD5r7K7fZAOHl9uDoxXnt3+A3C57IOU+DpCK8MR96CU9Otjzy9t5ilw7qTUTobEFS4W0x3mIweH7ktKo1Q5dlNda+JkxaKjdp4TqNqRiPbQ3bEcAYoGuC0wEZlwBsFAcQMc29ThTohLf1PW1DS43HNIFxOTynHnoBn6c3uxOIYN48fjz92FxnjLSPTMZPMEA8uvMKKkkHepCl6dYJJfxXAzBWxbAS7aPT60hkx7OqcICe1Z+CijXTltdqtyCv5IB7H1gvGLDt3Ub2JP3Td1M3i8G06iKs7QVcR7111qEyQ1VlKNlS7y9uKflFZwB+GcM9HAZQRrcf0EUWLxMS2+uosYRphk/koJHOeC4QwEgLlHh4MrWZ5LCBsdD5PAdi3hj6aHXKLvC+t02k3pbsNfFbkZD2FEOVlCRvGLRN6ErxgIQtiVtJ77F5DFCa67Gav3BuXBBuv1YCSQwok1i8PSjiF/qfV0h/5Cd7UC9/rqTYls9qpm8KgujAlxJsj8YF6LMUI8Cc+Gjp6QDWdpX3nScYmctD7otxcTf0iNoi645+I3Gar1spqmlDcwDCexjQCt4v3ciJkK81y5UUDCkbjWo3dJyaiu2aTUDkP//iMueebEKVAccwiPNRSKaggtGwpCHKnLBBGzGFX3sQx/S7985yOw6Xk7eAs4iPhXhK5MtE5BX57fpqQ0OcAmGWeVs9am0Ag9P3shrLudXbvbk3H89/1zRIDNcfIh19HUUBCUsWUHECPGzQy20u2QapWUTo5VPzLotQcH2UQfZRdeULVfRR2X0cuvTm25dEdh47OZZIAgvKHuP8O1eEUmFCB8DuH4Rb2dmC08iQg6PU3I/4/TPUm7go1vKKXF/BQbdJfM6Tl4CAl+
 OLq6lktQ
 95KMN5YAbjoo/AVrPKOFmcKhqM9OJUPKY8FjfnIPGBP7m1bqLCKZQchoaXwmrZa9dmwcbJfpQM99rLCpUcL2G/OQX6GRXemL9jIeOHyZ0IgVgJafIM//cjBkSkVuc9sgEdXk6ZIwc229z/0GO8M2dE+6JzZwRG+2Xcu2c1sLWdFFk83Fwjbz0PrO6Nmwi/vlyMxc/Bj6BFdgwodyYKFcjMZPbEVn0fPqRs8EVY5hjWup4ll8fo5glaGcrKmd79v2hEtvIACf2g8qaFTGjk12PhY0+FflNvGum6A6MfE8IG3uhhEPcahddKUaKHTE5xQed/dxZAAk8NlNHEvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/26 11:26, Mike Rapoport (Microsoft) wrote:
> When safe_copy_page() had to map/unmap pages only because of
> debug_pagealloc() there could be no errors in the kernel page table
> updates.
> 
> However, with the increasing desire to remove pages from the direct map
> this assumption becomes a real stretch.
> 
> Properly handle errors in hibernate_map_page() and hibernate_unmap_page()
> and propagate that error along the page copying path.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

