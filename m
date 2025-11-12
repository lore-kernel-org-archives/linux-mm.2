Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 118B1CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 14:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660CB8E0014; Wed, 12 Nov 2025 09:05:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6114A8E0011; Wed, 12 Nov 2025 09:05:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5289E8E0014; Wed, 12 Nov 2025 09:05:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 414C58E0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:05:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECB8C1A0516
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:05:38 +0000 (UTC)
X-FDA: 84102127956.12.19CD2FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 39F1FA0010
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:05:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hrRDv9jC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762956337; a=rsa-sha256;
	cv=none;
	b=Z2HrNDvF4BbfjC8AGab6uSPxTxnRke5r3KDhaxPNsmCQ342ef9TZMmLu6w1TY8aKufFut2
	nEuDv0b9ttbEF19EoawrvrFGbwP79GrsHL3blAfPZKVQt5pI+Xo1wa6Z60SRZQtHfvgGgp
	oflmjAS78PZvzYRuIDdxaFx87fH7taM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hrRDv9jC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762956337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hFDhHTHrxy0cgiG5HnFsXDvcqOeqjkJgrPu6mtieRx4=;
	b=YlTecDWa7+NWRKgbX78tTSUizq/3h/MtjRrLdrgap0so2hrHzrZ+ORP0kXOl8E33oLlybg
	9D0VE1UwfkL59AguODCz1nD7WmbLX3Eh2jYXSmBfMGdckC04hTEPFJxh8Wq/61nZV5iXHH
	ecCcXjFwnc6dM8y8JMqVJdU8PCGGZ2o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2559343406;
	Wed, 12 Nov 2025 14:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6CBC4CEF1;
	Wed, 12 Nov 2025 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762956336;
	bh=cUexB+134c732hJDU7RXbkQN6iajQ/WyAnGW4R12ZXg=;
	h=Date:From:Subject:To:From;
	b=hrRDv9jCTOoJlwxoL4NDlu662YQEFOrlV0LgPt+cfBK4nNT015L81G+FYPr9AsBWW
	 75km48IEnebOCCfr7LXswgbI1yl08Xvlo26aUN6NTkz/Z3PTyotffrrxxcbD5tMbaF
	 NVvrnh82Bu+LvEk14O7j80N/LTyKMS8XCyA+ndLzoEqfM6bEAXvqYjHp4dTbEWYW40
	 9JLK/YrmAc777Bt+hb73OKY9JZeFtwkWXN9g6o84qUAayjG/040L0uv0ZFG2CB5T8P
	 gF3stb1lFCjjxuMcP5ovyuGH1kL6eY00pmz95WRvyN8khVUx2kRgjN0BuK24e0r3rO
	 IkrwUsnGDJrNw==
Message-ID: <43cc83ae-2272-4bd6-b702-418a366a7da7@kernel.org>
Date: Wed, 12 Nov 2025 15:05:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-11-13
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 39F1FA0010
X-Stat-Signature: bjzbererhatnboupcj8skxtis5kngccz
X-HE-Tag: 1762956336-886715
X-HE-Meta: U2FsdGVkX18l7CfONvErQvWML28+eD+Z3iALsxES0vycaWd/8kz7eeMQiHo2N3JvEXX7363y63uN81r1GrQcTAudqmCoEwT9ARlNVc6MqZiAIn8MEAG0R0w+NBo5m0S/lmDmyongGl9IezOhedT0sq9kUP8CV3SOiQXcH51puHsJKjWP7/g1nt1ky6yuuOLFJUONm9wSGbne2OvZ9XyWc8M4vxWPhrvDQnEw7ZX8uVPNn5FPm37dJbgOa0bIhEIRc1Lk13oGvs2asozgjrMZINkVgVuEmC5vPhlSEDxUuEExQsxx2Im+O/DMwV70jXCO+uRuxWlkhiJsbM0cqM/2OjjWiQneaxx/ggCftNVn+ezQa7vyza1PXYKbQFEIbQu6450Y+QXJAGNbUtz4oZyG+/BvCKZ7JaB8P59C1ldGl+a19MVrE4wMwQZBXm9fDUN5qJK1TbMyvou+AYbTGI1ZJwIx3hw/rXob4xvCkUylJxz38xfDdWMBgGgtuX+COan0dqV9BVB0aMphvhAksv0nBBKzER+Qq0yoIkgpQ64ZJyirww4wAX0g1gcG6MYYpY4hB9zn/5A7AAdhz2Npttg6l06Fb5Df+mhopfREIX0Kmhm8OameGZZkdiT9VyvE6hw+G7Q3FHJtQYWt+buuQ7Ld+Ep5/9y0WOzdPRG9VhMaSAKCRXIWCbp13gyjjWa7ZZg3hrQD2HIEUGBRjzBpYxbjPcxxVb2txo42hjA3Yeud7FwCYc2k7uQqK+4NMddkCW1nOT7n1AizlxNJhVPKc8ZQG2bC7Mehj2p9hmb7W2SL17loQh5kBMSznGEr0ESf4MsxLB3i438e/nenl9WumC3NsjikJxWQUZKZtl6IDg18EQZx7NTRiyaXRCR9gNOix575Oe5etTJHOFW+5OzwY1KT/6Mgmd0AVNPble5BWE+qPrTRPe4Vy2H260O4qXoXABIlVV7LPU2RvSKA6zdkEyg
 YGfYS1lP
 ofF6ZX4dIGMH4PgPh7qug98Y5XNn2nJrXyGIX2Uk0QeYYs4m/W6azuh45owsGeVWcw/MJQUWheQtd1Fc357BII2K05voneosym47/F+xC1F0pL1+V6XfGldiiRkTw2FigvyuHLIqj5dXnG9+/Je6CAlJMkdkAQB0Z3bTmGXwZ7v6SAgXErF5gkMRhG3RPkkKevOfUEkRC5QieYc+Nx8rtZCdEyjs7r33Q/Vj6Nw/lJW6zY5OlRSo4xJQKwUv1j6ixLAp+mBBqUXmslmBF1ez9bPHqdeMlRuXNc1mwKLPIvPLTQi5uF3I9EMmeoyeprhp//ppiKcQloUs+JIWWEZ4A7ITC1cMYrhP/Jo1W5YwnayxcS8k8wwNDD5nIFCvDeNS+q3uAa9WQFVkf3BY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000014, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-11-13 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

In this meeting, we'll have Ackerley continue giving us an overview of
work-in-progress HugeTLB support and likely we will talk about 
interaction between directmap removal and ASI patches.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1] 
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers

David


