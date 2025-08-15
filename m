Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81A5CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 18:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 353E08E020A; Fri, 15 Aug 2025 14:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32BF28E0001; Fri, 15 Aug 2025 14:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FF48E020A; Fri, 15 Aug 2025 14:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AFDB8E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 14:43:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C057E1A026B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:43:35 +0000 (UTC)
X-FDA: 83779865190.16.E88C9E1
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1EE4BA000C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:43:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WSGj1qdF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755283414; a=rsa-sha256;
	cv=none;
	b=LAU5YEGQ0cLDEQA+k8h44GXxdtaVCivjSruS2anI3apd8ZpGI7pYB6Y8LPhJdgR3T9Hook
	qsgQqGhwAkgzOOI6sjnpgv33N4EPdO2t768ucNZYr/m21KqsO7rPOorfpgMZ1hZgE6TFaf
	o0Si3gRWoa3qNL8D7xFV/5YC5CqAIts=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WSGj1qdF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755283414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=flsyiKxUh1QJGZG+IWRoapG2HI3Ae9rWebBZjAboWqM=;
	b=m7FFmCYpaOf2Y1Fmh5CJMWglugpHG4PzLOFzMhCRpy9MX29+xH070P02/xZt56x5n08178
	qH2q6H1XMm0t4kCECqcKK0SiJYH3ZShPH8+AWdr6qf/nBXv467A++LnQxyHkHUeIEYS5sb
	0vNYA9J5p3fl+trkPa6pXof9B8SO89I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755283410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=flsyiKxUh1QJGZG+IWRoapG2HI3Ae9rWebBZjAboWqM=;
	b=WSGj1qdFdt6XMJ6aEMN+XRFSirVkjZ3TePNBUTpTk1X3ow7p1z9BkNDRMKp3S4EHbe2rlE
	rABR15iV8X82IXKQk9qAr6nY/OCtU7lAeknrUW/3kesrgcYfogey+Krmz8NV586/3JAfw3
	rDXX7YtWEWHO11VuFAlHbbJb5ijF/Ic=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Matthew Wilcox <willy@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Regression caused by commit 4687fdbb805a ("mm/filemap: Support
 VM_HUGEPAGE for file mappings")
Date: Fri, 15 Aug 2025 11:43:25 -0700
Message-ID: <87plcw8lyq.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EE4BA000C
X-Stat-Signature: 9qmsfriyn9u1egfsj36hyc6xj7goo83q
X-HE-Tag: 1755283413-694653
X-HE-Meta: U2FsdGVkX18eabfKyEl5oXh76vY35bo/SWwRquSK87+mOXZC2t2d0/qQBBixadRKDxHVt9fgjWYE6EJe+43zza73pcPypSjvXjaesQYoQRmFiQGbXhANS1rfix+sXy7XxRcGX/HdyzmDg/PFVYx4bBPYQErzpQVnU+ZF75p7E7FSa+FXQ+9/Hdfiemogm8EwZkpv9tRRqrvQqEZwcY7Ve8QoA5cLZ+HyiglFOAtpMSsEoKMFgYSlnljsmmYH9qloAK1TJxAyVs3U3kp8Mg3qQSISsSQgBhEglaNjE/N5hOtjELcjFrW3omCAozMAD6XZ7BAX5UprSxnmlsYIxHKcAlxs7sisg7MPjlTAU5OopGyeSClfe7GDvHQlajgolRK7CoN3SEn2HAscsQ2CfBrcokgHCv0qnbXQT/7RcAKfoEDw+VJrJoJU+dhHWadK99yPXKaiXvoO9L4PwU01HJ4UlvMLBxU7wr+EtTq9FU10LhKlNyFeYYz1H8L5SbbrzikaJJ+KyZjd9RwO9WUrejbV+wPr1oI/bBxqofu+o0OsLW7wSziKARozE6vAGQBWxfvt8yKdKRyE+/RfOaHDtu0H2Q26q5uq1I1mVENE5coB9LeevKqVUEV2wWqAawGn0pOWswDkJps2mvJGVA4WQi99pNwE8WcaGTdAEfOmwzKPRt4BcZ6PmnJPOQEe+EFDaisYrGD5KNQ9p8YCfNtUPIqviPmHoMMg//eOHF6V2IN9KgSS+69mnlgBcQgl2OTVIeY3Qkm8uCzG9qHAHFrrhC8dXMLjiwgRhuRiXEidls0S7kS0yTzv9W9DKKhjRNTlZGd9UsqzNewIJ0XuQ3rvlyJc0IWxIR8iOZp+vDAGFMN5iriYpFA8J35cs9fxsd3QgGETJMTVdeOngzE9gFzzKNG73fG2WB/FKgyqb905YgRADI1VAeNE/7jMKTd8kY23xXugvZYR6NCJct5taarMjKg
 QENpRSax
 3Zs6Af9KfK+l3zZME/NV0bs8u7QJfSWgX4Ya/A+yoxoDaNZOUHp2u+3ClwBOHAOYrD+FCTKOKZb0k+BDaydOfUK2SqkgVeAinl+hXiPnrCJ1fr44n8n7uqStQQT637KwzVPWCMpD6/ehYKy8rYt3pTna9SnmH1QDOkK23U1ajG6qvEMZAS56HBvIYjoxpD2uZmT7uR/93dUGOkjg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

The commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file
mappings") causes a regression in our production for containers
which are running short on memory. In some cases they are getting
stuck for hours in a vicious reclaim cycle. Reverting this commit
fixes the problem.

As I understand, the intention of the commit is to allocate large folios
whenever possible, and the idea is to ignore device-specific readahead
settings and the mmap_miss logic to achieve that, which makes total
sense.

However under a heavy memory pressure there must be a mechanism to
revert to order-0 folios, otherwise the memory pressure is inevitable
increased. Maybe mmap_miss heuristics should still be applied? Any other
ideas how to fix it?

Also, a side question: I wonder if it makes sense to allocate 1-2
PMD-sized folios if mapping_large_folio_support() is not there?

Thanks!

