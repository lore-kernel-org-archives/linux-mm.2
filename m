Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 323CBC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FDC6B0092; Fri, 10 Jul 2026 12:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CFAC6B0093; Fri, 10 Jul 2026 12:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8816B0095; Fri, 10 Jul 2026 12:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1A816B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:29:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78A8C8EEC3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:29:24 +0000 (UTC)
X-FDA: 84973402248.13.F528050
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id B4A6D20003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:29:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BuORz+dy;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783700962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJPgrDhZwki0j40wvoEjzWJeyVFQCADBAScmfxlYF/I=;
	b=wK+zrULF/NM4d5UedmMWnr6d0fJJbU03wJvu6eXKfM70hI9HuXAR0tiA47Ag/dEffDqnL0
	/0aZhc21kHmVsdD/1EeQu4mdzcYe6nIicyFv4u3oaU6pu+WMqY4ZuMksCj3KAg7pyV9WR6
	LLTe3RHN6TZkE6dBTKOaS3GDVgC5+ys=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BuORz+dy;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783700962;
	b=vs6L58zLUv8AZstFS+JXYgDzyPd99RbEV11KXAGc8mOUceBeL7q+4MZrsg3Yz8W9OXMld6
	BqlK73o62d2ghUjtOz/zQuNArUqxongRP2YXY1MF3y4b6p5A3qF3QPmtZilUg9Bdc5pGHg
	2x9yuOCPxQJMlEoegmuPDXH9RwCTEYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29F1560051;
	Fri, 10 Jul 2026 16:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589831F000E9;
	Fri, 10 Jul 2026 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783700961;
	bh=QJPgrDhZwki0j40wvoEjzWJeyVFQCADBAScmfxlYF/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BuORz+dyC9e9WpGlWSJ7Ibvjg9+U4Tyvuo84s92NYuFk3DfX8frbuT1+6xjO0/IN6
	 Yiai7inpmHKjK5QJjE/l1+EmDOffki+9+8CU5hMvkTU3I2dDc/786ACwr9E7W8GG6N
	 7F2dOWs+mUsvanGTzBn8kXZY94sQQ4NmtX0IA0NsIuVxFWeBi79lyV+Q/HFgUWd20y
	 dG4Q50d3xQ7bpSqkogYtUJ0PA5bBvFG8C2pWSxRlX9T9tVG9UT81CViabOtGg2bme1
	 yL2iZTrG/zbp8iWEbVGw7yM+w8DudjhFviGJS2icVCdnWbq0OaNlhVJvGM7+RGckJr
	 VHJUxH3rScJGQ==
Message-ID: <af70c1ae-1ed8-4fb3-b0e1-af24e3ce527a@kernel.org>
Date: Fri, 10 Jul 2026 18:29:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove wb_writeout_inc
To: Christoph Hellwig <hch@lst.de>, willy@infradead.org, jack@suse.cz
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260710051052.1839523-1-hch@lst.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260710051052.1839523-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4A6D20003
X-Stat-Signature: qr8r749nr15adm3mx8szo6fu8kqtx1uq
X-HE-Tag: 1783700962-93444
X-HE-Meta: U2FsdGVkX18+ulKpVXXjsWo6SnNnRJui1dEAvSMjF5RExwRcphSjGz2qtn6sxbNuk29d8J+u9wzAJdafY/oe25UlU7LEYwEr+PTeFTubPnGswPkLtZtOX5ih6th4J6dqa7SZhRj/ekT/3UiBMUOXeumqfvgt2RdSjjO8YCws0quy41Mfh951knxA8aoyTB2gqhI31NQKKWtUM9j5vPnA2VvVTeMglRuHOixi/K9bU/a6AN0BXKFjjDXldf+udga+4iMfbvIL6K47o8Wlu3m3u2n2VaS1YzEoCOqzvx0kfOVWDeavmZ/QPWdtrdqjzw00gSbOXg84VoYn0MoYM79k41FTpcPVHe/36B2WTDeiFUbfefrG9v754NW3nDO8gxAwK/InbJrhDBeMMgM/BS9tZ2p+SjnyyMZy559E+Y7Z+yfvka1TS44gcShWqGVBvUxhxmvP6OnYwug4xyJ/Jeqnwj2Cvcdk6zZ/cmXQS52+y+pfRvQLUux37TkigeEF9AhHEfd55PlmWeA9TCAFJ/0RnHadsujugNqkls8djpAcf0nzpqiZSyGzhALdnyBDwOIK8eudPs3QPtkObPJpM7bJEXLPxjT4gouSI6tjwuNCrh/GbQEMOefgOJmlojOq+Y8yjacME0oj1bG05Ofl/0uvab3HEjKrp0n8e+NOGqYTv9ckpeVP4idyU501s3hKbcq7s27XikCsecHPGRrIgXntMtaj2RQhBLj4rW5UodMdhz05rZFbhd/KLeDU+zICnNMjEuK9Z/6mvk3udyq5eDFU3ynojdapF35/WOTb3qBPDMiIGsaBobO6MQB1iYXpkkS+/TCePITef08xHErxB7gYqFj2HGdMFqE2MnaaG2tgST2dMrX8iW1Q5Rae1iFx9Z5p6tUyaCAmPvVWZjo1A0n+2Xkq0iAAJEkBfiaDNVC+JYbEcEfq5LDQPDFDv13IncU7CnSjHAb1Gq+n2eYr60X
 HHD4U8Zp
 cPPRTANg92O63YYuYGXuajxfOZKlV0XRDCClEJxAGivXqxaYWIo5JerGgcSr51OtsCnwtT69zmA2YVJ8Kf5fuiFc+0H9Ew8HZgRC3ApenZGQBKGUtlNese1a04EcxIhlMxUUFTuniOQfdWxCispCJeVc/3e79N6/u7Vj0gfvIvkuH4vyXEs+amj6qVte1JKAEwoXi1A6HPSbfYyk19mJeeamauXlZ5DnrYDvkp1ACBXaRNPVAqbAYhSXBAzrR5aML4vGmQSmBO2ToGO71//6kRuwwKVQKWsOMaADe5Ogk9jq8+oA9nkMsMIPUh6wONjrO4eN5kk8lr+W0sCZIRNPmmsVT55Jg8WUjm5VWH4vFV5iN/fGf217yuAKs703VoaRF48LI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 07:10, Christoph Hellwig wrote:
> Remove this entirely unused but exported function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

