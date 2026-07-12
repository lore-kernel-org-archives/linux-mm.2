Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242CCC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 11:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD6C6B0005; Sun, 12 Jul 2026 07:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8DC66B0088; Sun, 12 Jul 2026 07:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C819B6B008A; Sun, 12 Jul 2026 07:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA8976B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:47:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 103E0169DA9
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:47:15 +0000 (UTC)
X-FDA: 84979948830.22.442D119
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 45B25140003
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:47:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RZn/E58U";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783856833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKGRp99JuN0YlUnEBAi7RbagTek3+0cXmUA6oiaBAmw=;
	b=7oV9BBI3vPHyry4M9f+Sfw0qUgAOSmipKD2hGqBm1YbazAxQ/cC2xxwXc2+kOucFi7dXbT
	RAL6RzBQERcTjSAEa8yZayIRSQTOKkBUY7SYkNQ5OC8UKC8U50qDsxBK5pFNpIzX0DsP8R
	gJj2l+9IMo0lPnWx94zAKQSqZ3dqg9g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RZn/E58U";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783856833;
	b=xYZkh7agEGBMuJZhBn9E5krXM3rG6K4qMZCKdcdj6vNJzv1SM1FQuvEzPSwtRauB1WaFVa
	hTx9V92O/Kcdh3OIdpfycWp6SoyFkTmdrHi7tcCoTEhVfq5qjjR4fxJwDRM2vdwNzTiEDY
	8pkzVaF3k8Rcc46Y+wKxcyj/hjueCRk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30F2C40756;
	Sun, 12 Jul 2026 11:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342161F000E9;
	Sun, 12 Jul 2026 11:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783856832;
	bh=eKGRp99JuN0YlUnEBAi7RbagTek3+0cXmUA6oiaBAmw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RZn/E58UhlD/oZinnPytk5XP+7r14jNAjD2+0d8Sl6NYp0V7lw8FqP2JfYAP0T+Bo
	 zcTenYNzCgr+pB15hbh4qe3eKW+g4xW+Yxx7+uJ8wt87wOTBPkGb6OEeA+ATQMUW6m
	 d0EL07LaqRbvK19TsxPzhaR1obObU4Vw9lBszR5DoNTmcvsIdLJjc6NmGc1xfs65Rc
	 0brii0Dzd2/WiVP+znkM5fCmdamhG6D+m+hhk4riuygatVXw+VnxF0br7N1a3r5vwA
	 Z9G+nOoqTX2UWeQv5uawx/idWpCcy6zavx7fa95zi41atMABTHQyP/UFCiUCWtviv6
	 qqw3xGIpry4/w==
Message-ID: <998e71ca-05bc-46a3-853b-2eabc169d909@kernel.org>
Date: Sun, 12 Jul 2026 13:47:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm/rmap: add anon folio unmap dispatcher
To: Andrew Morton <akpm@linux-foundation.org>, Dev Jain <dev.jain@arm.com>
Cc: ljs@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-6-dev.jain@arm.com>
 <00467fbf-0360-47be-94bc-d1456323e5a1@kernel.org>
 <42300e6c-523b-4f58-98f7-672ce9173fe2@arm.com>
 <20260710173519.d7659f9705afa37ad62e7bbb@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260710173519.d7659f9705afa37ad62e7bbb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45B25140003
X-Stat-Signature: 38bskoc8kjwidx5xk98rgst9w3jj8x1t
X-HE-Tag: 1783856833-190935
X-HE-Meta: U2FsdGVkX18zM7B1y0Hg3F31w2/ifa3SJs8cvXXZPIv9JqNN86JSxDkcw3xJ9gtz8aADJd99KyXzc5fAAssfYmhuq7NmmMTfHeyxXYsaO6K3PXRKJN6zP33i1PmAuSeRW8O+4l/qMoz7DBovqsAs6Djh/Uof653vwbssX/M34OU/8F2+cb/vNz3Ai+33IsEJLQUdAx2MgwPJJhamn5dTzyQKveODTzYe5TGTuBeABi9xHfDK+aloHwMyWQqJv4Es3rJAmG0/1qJTeF8VBOUuZaMhdYiIUxnJ9sdXj9aKlHqgplaZqZpHZsSPtivHAJWyzfRsW5up/aXdCIRsgIFtBYYpn2x0abmWrd8OX+oVNHkOTtZO7Fb6vvshl+VroeEQyuozc9HgQvn4tUA8cIVWO8loy7LV10SDmZbJyXZyChOW9v7WIxanHT0FlTfFO+m4DlJ0qmjEeqr7PXLGcV+ZziWZZgUiqXDqn2eiHZOnD1nsz6vx26yUja2n4g+HwjXYSz8l+ruNuUDBScoAjQPfKhoEWQmi4/5+m9XuNNzePkztD10s6yDrz21++mPa4vaHZlJUbLPFsxrHNiPY8/CfnfkSmtcGgh4d+Yin+zPQixsQ7Uvd+OVHjc2k4wrc8pfqRPh8BCETIGYjwJ4HepeccBM8vkGU39szmjOgP3fZQJkOexg+Bjt8Ih1sJUkMNV0SmOj37xSIrEWGLsiH1MCdpqYrfYANoOKErEe7+OZ3fNzy74b7tHj4JXRDr+R4jiMDgjLUwqCBri8ky615UkYzuGnGbo/2bJyAEET+2P9RoqETzjJuwathBLFwelKns6uBrHDTcs25sIWi9E/TsZ8oS4Fsb3XCFzu8Nl3jXJ5rsB3hiHyemgQ4pkqKViMEABUamERSV4ubpp6zUsnrMq31wGTiL8GdqipFpTXqgS09Yj0uXLk/rkla5rXXeEtwWSD1K3IPc0QC6Jz8do7zKbU
 IGwshUM4
 J1bR+SRsY2RqtfwZnWNM3ThsNPyNPIIbNp/oqN4FBaaKjiljx6qRRUXDLvCNnXRhX5THjzn1ENJbOPcjgpeo8K+0HVxfnebEHgmKk+AF3+1J+Cl42SG4jAx//7Pfp+RngnHEnRDWO8KpqKVIPeumH5OcUjNNEQ9JwL7DOcQl590bLzi2qfNAzNtHmoK47A2G1Kgmo+XFxLE9U2YE4rY6GdQ5t4JZZdGW4hC+X7akAoR4OttequIDByV4Pska3NlCRTTr1OavDfG6fc5FGvHR0pusMcAk+Qr55sRGWOQ56DBswSbRNh/xzZuOKSlu97wybNH7r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/11/26 02:35, Andrew Morton wrote:
> On Fri, 10 Jul 2026 18:43:14 +0530 Dev Jain <dev.jain@arm.com> wrote:
> 
>> Andrew, could you you squash this diff:
> 
> I think I'll await v3, please.  I'm getting a big reject in rmap.c and
> methinks we're all a bit firehosed at present.
> 
> Are we all agreed that we'll be "batching anonymous large folio
> unmapping to optimize it"?  If not, is this series pointful?
> 

Yea and yes form my side,

-- 
Cheers,

David

