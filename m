Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD573C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AF46B00A6; Mon, 31 Aug 2026 11:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15456B00A7; Mon, 31 Aug 2026 11:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03B46B00A9; Mon, 31 Aug 2026 11:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 993136B00A6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:13:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CFE4A01A8
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:13:11 +0000 (UTC)
X-FDA: 85161907782.19.AE0352E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8454A4000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:13:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kfs1qMws;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788189189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T23vz1XT5Dhk0iK4FxPkhvidc2Wl0CtXoyVQvUdnPKA=;
	b=kkQ1RXNKgJD5j8nTNDDgWqm6VABzNN6YX81/BSLEuQ86qP6xJqrXPsFVTFebmPrCchQAjJ
	8jdWS63C5aJQOlUOaskZO23KfvDf7+tg4v0Qs5/OXKpZH1QzJmKH98OCDs1uMdqGfocvEn
	VL4NuoJydiFzzcxmCD33hgWLg7CR5PE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kfs1qMws;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788189189;
	b=4imyhOmyADhXDGMCIUDLotwwUipo7Zp3/nWM+tQvzijZmdCSfyDTXN57jww77+j6O4YNTm
	KbmLS5GBm0n9ggNGYMti7TD8ZVAZgJCdL7pQcb9X/GQ835EOilJJOJOoso0cIGwVaRPeuW
	g6gNqEHfulPzfJuGKC/TUv/n4EUHZ+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2D0A6013A;
	Mon, 31 Aug 2026 15:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B2E1F000E9;
	Mon, 31 Aug 2026 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788189188;
	bh=T23vz1XT5Dhk0iK4FxPkhvidc2Wl0CtXoyVQvUdnPKA=;
	h=From:Subject:Date:To:Cc;
	b=kfs1qMwsLbtxXIAi1KGhQoNZG33C6c9TWByVTS07fOYis4z7BIKWGXDDDHEh+cUAX
	 YL3aZ0unG5LmqOpsnYberOk42sT3d/YZaz1DgwVs+MHXC1K+LgxIsyUyX+CRfWUk6M
	 XnVnImvs7Ir9K0/y4KJ4FWxrTFQ3zjYAJCRByE52hVdMX9nV2+DR6BvOrzLS4WK6af
	 CCkLx525kbk3WsL2ZyI2n/3YldiU46+eyyxXZxKxGCIGuM3NHj7CA8VMy/1mZ4wAW/
	 QpaVkAzZsVdMnjhhxn+LVgFhOx5xWwh88AbBLkPceaiuBZnzwyRwYnUs8r+5OcnERo
	 LGGAzqzBztAXQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/2] docs/core-api: memory-allocation: add k[mz]alloc_obj()
 and clarify kmalloc
Date: Mon, 31 Aug 2026 18:13:00 +0300
Message-Id: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ6CMBBFr0JmbSMgIeJVDIu2M5YxtDUzYEwId
 7fo8v389zZQEiaFW7WB0JuVcyrQnCrwk02BDGNhaOu2r6+XxmD2aiJFO8/Zm7AykkHfoRs6RDv
 0UMyX0IM/v+p9/LOu7kl+OVLHw1kl48QmPx1TFg6cztHqQgL7/gV7A87mlwAAAA==
X-Change-ID: 20260831-docs-memalloc-guide-dc4db94dda96
To: Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: 6uxt6pt9g4jug6pygzsesow6ancfgtb9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8454A4000B
X-Rspam-User: 
X-HE-Tag: 1788189189-858212
X-HE-Meta: U2FsdGVkX19E+12gjsNDEsnHOtJ46vHQ0yeXIgkyeJlaXmA5YewA7i/KZ6TywrQT22D15DARL6Un+NnGUk450I9ZlYTZFWC+hwfZAY62mDmUfuX8fyImTN3NosvPZ3qkqKcUKbLv47HZUbzNQV/faFs0RMET7rNZuID1BT6nd08Hbeoq12Jvnd0aBO4PhuDAjkcaoV89Zn6GpY1PBGXDW6AYaswkooYueQ2KOhKnd1zepu/sPX5cLR276h2CWQ+h7BVqgpOKcqjAdVNevAxs/PU+T3Qns3u5w31hAGdGHM5ESEs5UvdaEJ/fq9Iplt4FAmBNE22+BxjhsJECIfbfeP24pwWCQiuetZJVVhYIwPhtOSiGo+OJpZLgT0GfTYaONVcuH+Lsrw3iKaNEzFq7s8wxeiu4JbDPN+ya2MFX+NL+mA5wNc2HVwGO8i6DnQStYQ/CihHO7AXDnr59tm3oWy0ckYDnpo2S9K6yWxgYI1qD4QQlxnR8Dw0SRU5uNkkedAnV2YlU2Ns3E/eBYeoJAnrUei8awbcvSEa8+Xwqq9XtBC5PlpogMl7RXhBimoP2qTPLdIXjm3NHVQXjFFHSepWl35vFweSBWLWzNI7W0bVBoAI57N5qM9tR8Q5viEyR/uaqWFQWuKAXZUAH+l20y93LmC0vKEzb0FXl0NERpSfAHTt4Hh9Gl2PU99zaFHEObK8ai+Yjkg7bKmPkeHuNA+WwCa9KvwwDEdmLBn38F5ujI/eYdHLuoxZ0UMDEdnCQS36rbGxUKoMz/97IxggyCRkG3y0fxNAJWoH18zv1a1jWkBOEe8TsShMT1sbv8jQtZ98w8UWUQpo4GcQW4XBlsPeoq2JUZBunw2MB13M4UXLnl9ccUqvJHySj6iAN1jmr1s01/VeZhHFo1ap8GlmoRfHGwQP9BUYNpxcbEhq2gho2+3mZiukh4FiSdP8r7JA13DLE57LBsC5ECNp7UkR
 xi3YObbu
 sPXpfrMzXWYRKYGJEHFRziLTmxk0LEg0T4499cPRIOuoABmTssIKP9uoif67mjJfIZ3wAWnZ37N8cqbEt4Y40xhAXpWaN9TrhK7aFCNnWodWxoZP9uEWqKFdkp/TCt6IVmac05+yYXTkkc1XGvpzFtK1nOad3RMQzPiBp1JfOD8LRLj+2vbCnDA8sFyccLbwh1EEA7j7jGbzuFcDZxZTu8vGzKD/eVrF1+WEg+ENPLFbNndj/7a19Rg+P+pQcI9Chl/JTtOfZ+0bUn8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update hte memory-allocation guide to describe k[mz]alloc_obj() and
clarify description of kmalloc() size limitations.

And when I realized that get_maintainers.pl does not list any of mm
people for that patch I added the MAINTAINERS update as well :)

---
Mike Rapoport (Microsoft) (2):
      docs/core-api: memory-allocation: add k[mz]alloc_obj() and clarify kmalloc
      MAINTAINERS: add memory related docs in core-mm/ to MM - MISC section

 Documentation/core-api/memory-allocation.rst | 30 +++++++++++++++++++++-------
 MAINTAINERS                                  |  2 ++
 2 files changed, 25 insertions(+), 7 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260831-docs-memalloc-guide-dc4db94dda96

--
Sincerely yours,
Mike.


