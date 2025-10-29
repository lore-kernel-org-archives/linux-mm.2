Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8B1CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC388E00E5; Wed, 29 Oct 2025 15:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C008E00B2; Wed, 29 Oct 2025 15:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41DCA8E00E5; Wed, 29 Oct 2025 15:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29A2B8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:56:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0A8012AF7A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:56:36 +0000 (UTC)
X-FDA: 84052209192.27.73547D9
Received: from bumble.maple.relay.mailchannels.net (bumble.maple.relay.mailchannels.net [23.83.214.25])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1A95A40004
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:56:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=GsLDk9BX;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.214.25 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761767794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iOVpfpUU/b66Q7BqV2Y7FdOoApZw5OhJbALf+kfwupU=;
	b=pKsveGMfp6swsI3tkUFl8L7aE3VJoNo6pfLX0ngfu55k8HCPZIwc1UGaDQYh/yDWGji4kV
	hIXSu/KOXY8EjfqGjMg7HzoLmktvqcXjCqTBXwReeNItd/BTZlWg2gITLxvBOD/pgi1XYP
	PPvoDI6j7YRINCOttdZ+TPZfDYBX+QY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761767794; a=rsa-sha256;
	cv=pass;
	b=YfTTueze/fDGye9wDfP11nW9Cu6aVJ2GeuFdPCM0Lyhw0cFdLda+C8CxTeQ4rjC/xasvZV
	Gms4IjJW/vU1uaQfK2C1iHJxBqvliNVUpN4d71MijlTV0gBuRXL/mWPW/4Qk72tlHL8f8J
	BogcelD/hekrH7BDnant1a0CL9h+gAk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=GsLDk9BX;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.214.25 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 16BE780181C;
	Wed, 29 Oct 2025 19:56:32 +0000 (UTC)
Received: from fr-int-smtpout17.hostinger.io (trex-green-4.trex.outbound.svc.cluster.local [100.123.213.201])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 155518018F0;
	Wed, 29 Oct 2025 19:56:29 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761767791; a=rsa-sha256;
	cv=none;
	b=hsSyeLyAZUaUqvhEKqGttZ7Um/HsYAE4yqF969AJkZqanc7BToc8amJ1MOkOYP3XNuyeRi
	rxFCtwMpVnFvk6S1tB1igzfqObrE7FUV+ocmnVTNzjSTY/RMw+rK1+gr52U3SZhdSYK4nO
	ZPMu9HC7lIBGoiV+9vrKHLICLAMaajYr2lP/OgKFnLFiqP4r7yDtFaFvcd37ZQbK4WdmSl
	TMmEUuzSKwtpMLBdN3VYBy7/WAMUgHWIkS4pvxXf3Yzcx6VLhwGGOIEoc4yUtSsbu0co8Z
	DXFjjGRVI1kcu+gHepEd7vnHTfFOMdJsF7q/1ueTS0ZakdBwebujs24Y6OS3ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761767791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=iOVpfpUU/b66Q7BqV2Y7FdOoApZw5OhJbALf+kfwupU=;
	b=W+12k5+UkM8ggnAhjEtIiEuFX2sUJRlzMOs/lalnz4dwulYdJblDUKuAlV7FZk9f54vPCw
	2LXsqlzKsg9UpnCia+wS1JuxmOBpf/K6Fh3qLGLsWe46Y/rDU3JmfO78rqVGjmyqaSUNHg
	8hfNRLbM8P8y1CloCbq3lltiGoZvFSxvagq5I0Pe1hc/pCzLel7RXmbTmdm1OMKh4OuZoF
	JKLZ3jbISpulcR9/ZhGXcqoe8dlBPDjqfO9WsjLvBfXdxQId586UAmoxUBj40OOViWiihv
	pCD+PB8DbjJ7/QPlaptRsOPdxVloQpbxU9XxBySWS7vctd65TvAwDmQ2IFHcXA==
ARC-Authentication-Results: i=1;
	rspamd-77bb85d8d5-gc7jm;
	auth=pass smtp.auth=hostingeremail smtp.mailfrom=linux@israelbatista.dev.br
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MailChannels-Auth-Id: hostingeremail
X-Bottle-Hook: 46cbbf2f0f33f695_1761767791681_4186826510
X-MC-Loop-Signature: 1761767791680:2911721417
X-MC-Ingress-Time: 1761767791680
Received: from fr-int-smtpout17.hostinger.io (fr-int-smtpout17.hostinger.io
 [148.222.54.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.213.201 (trex/7.1.3);
	Wed, 29 Oct 2025 19:56:31 +0000
Received: from fedora.tail0cc0bf.ts.net (unknown [IPv6:2804:d59:8970:3b00:5f26:e2da:68e6:2358])
	(Authenticated sender: contato@israelbatista.dev.br)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4cxdKk2Nyzz1yHN;
	Wed, 29 Oct 2025 19:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=israelbatista.dev.br;
	s=hostingermail-a; t=1761767788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iOVpfpUU/b66Q7BqV2Y7FdOoApZw5OhJbALf+kfwupU=;
	b=GsLDk9BXD0DAIKMCyZAXDIPKc5byJHUhByzbQMTeB4/lL/ysOOs31jMNDCT1YJeVfdTBww
	tFbKodL5ZOA1ixUNBBqkBqnN2OMnugNBJD/Msd4YbE9uUsS4Shbc+/ViRPR9ha7BifoRZx
	HOZ590hshoEErbbyDtQsW6TyyP0dufSALLV9JrBIWAv2PEvfqWV9iAzcerVlk1VQa90YoU
	H8ZpG0W+7gf6CNG6rVN5entYy5FQhuJtt1c4Td8v4JlFVQrjgMMuwo7FyioxVHFND9QPXD
	4T9TJrtD3hv20CSNuvhC9mFQB7Xg7T4nrppSWw69xbdZGs6z8DFF0DJXiFrOlA==
From: Israel Batista <linux@israelbatista.dev.br>
To: david@redhat.com,
	lorenzo.stoakes@oracle.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: osandov@osandov.com,
	linux-debuggers@vger.kernel.org
Subject: [PATCH v2 0/3] mm: Convert memory block states (MEM_*) macros to
Message-ID: <20251029195617.2210700-1-linux@israelbatista.dev.br>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Oct 2025 19:56:26 +0000 (UTC)
X-CM-Envelope: MS4xfNxB7is5iVJ4cDdISjM3VWYEsNwLgsLtk8I0VrOBFCLj1TyKUdfKYGYLaaQHqti+vLQksoTwYQrvC3kd/xW9BA8anZxFlE4hQLQbfeoQ+EAnxbJNqmlj FObSoFjqidIq+I4o1ziwqxLqSUb1G/V33dDH4YhIYK9Dnzx+RpQ8R4lgcdBkptqz/Vj4f1QKFai7fyW1kGv0Nqnr+474Plje5y0YrAHVt7+NL670+u3Kn+ig bCsLRc8CZVKO567CJFpAMyGzILjRPLf4D5FV1tU313RgypcshLnvLcZKRJy/G3/ZdlIQ0hjYU8R0zPNebdeQK/CemEOJtoodEr3sKf9c7QA52AILpx828xym 3wF9JNv98F6DVam4Qyl0YB8rnObjXpmz7SNdtT+3PairXzja18b7HJ+ed7R4hv3qmh9ejS+KqlBHBUrpxXMUy9j/sQ7Vlq2XUaHoeq/vqjvhdNd/vLI=
X-CM-Analysis: v=2.4 cv=Lflu6Sfi c=1 sm=1 tr=0 ts=6902716b a=WIeu/gG1zxr2CnNbFFeIHA==:617 a=xqWC_Br6kY4A:10 a=VwQbUJbxAAAA:8 a=GX0AQbHyn9vrm7BpF5cA:9 a=TWtOS45hTxhqQf3p7L_t:22
X-AuthUser: contato@israelbatista.dev.br
X-Rspamd-Server: rspam01
X-Stat-Signature: sa5b9geq1yygci8eicnia1xkams1pdy7
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A95A40004
X-HE-Tag: 1761767793-164050
X-HE-Meta: U2FsdGVkX1+nw8Cgc8WeWIdy/Fij4ynuYkd42V0l04TeDUWDTBIBAtBQ3x14VJxi0n9LgDRIJVYgoiSgh89J8rMhe6p/MxR7ZTkk1s9XAoR2mQU/gjQ92/lOymeivuXsV9sxPa7OUnGF8Als4Ym8jI4PSonsgZ4w6mcPzaQLIQhzLiwe11v0QdFjEV7kBkONVG+039Bgi309ZawO9H1vUYJn682WDgGTIr34U9Pgv3X6r8itTiX3zcCFOu2H1QQ48WjW8MrLsYgZHbLMIDGBhFAAN0qN3modWuaAwTSjG6SbmTWyomKlZwRlFcnxuf7TY33Yu7MzSYLnb+j2f5lblm7TPBtfgRokkNI5/zInLjuFPbTmmQqTcZcj5PsgjfZeKAQIvLZ1+3FeOdKMDF1pHEeSJwsMK1kZoDPltqSLzcoyYLKoPqqExkDgSN+iisLl79vjmguOIUMdz/cMFrRcSGIOr6MwuduukQXr/r2Yl5xJFm5JxtUzqpvCFqHWf8IHYx5+k5004b6K5YNt6aAhCW7WSML1iILvl1ygq24ES42v0dYF90v7+o2rBslZ3pJpzsfBM+DU2UE4bfNVNEMXWz/3jCCgj2UCfwEx4IcX3QjliFIHQdMoAWpPpzAzvMrmtfW/4n5zKpU65PohCqUzaJOiS00J5dWBP5H2CZdPjEefCB3AjGxz4MFqS/8hZWjATNulq4VaRs0KAILeTfYEobtre/zA7JrtDMpt6VIT9s4cqA2BvRY7DeCK1aKoU9EIcYFOvOwugX/gPS3vxGItPR3UOea4x6goiPrOXEUxenUemOqSuDtOqIYlOqq8Nj2SvB/p2lbD4se5uHzTU8zsAgY+HRGxPO6dReiUZZ2UXL7CkoBY0wmpR/EF+PyheITN6RZYLkWIAhtwb7fL3+MlUyRJCR7eB2wKSqoXso1S1/Ai8VZV+8N+KnTU+6FU/gpDHpuwkXyGo0Q442MCXh+
 rgodiowh
 LsTlMRbInJ/IB4U55hsAmE+W6x6u5cSIxvvy75ZbHlajL3umnO3IdNsluiRMHxQkJGSLuy1uKiAnVVeDuI4TJLz+/9XmYI9pRGOPqhj/o8j0XYzO9Z8GsrE54FbhYbxe3tXM5kO2ddzfODavf9AjWbwfKPIx3fztHEiwuVEUAFXDQiHPe6o188QXrGncBGHjvLT30R+I6wVJG9RlOzixqMsFhn6cRz+AcumlixxrPIxoMztiGfUiA9Dza0JmUWx49e6rOje1RtwW2Un7o1z8R27m4hXseOfv8kYIny5GG00dVv5BRJ78ejfC2yZNMA0Ju8xXJ9vYrTe5StpNGCK5ATzeLv2RfzXwJkAYjw1qdBiHzen5n6TEFFNXvBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MEM_* constants indicating the state of a memory block are
currently defined as macros, meaning their definitions will be omitted
from the debuginfo on most kernel builds. This makes it harder for
debuggers to correctly map the block state at runtime, which can be
quite useful when analysing errors related to memory hot plugging and
unplugging with tools such as drgn.

Converting the constants to an enum would ensure the correct information
is emitted by the compiler and available for the debugger, without needing
to hard-code them into the debugger and track their changes.

This patch series aims to replace the current macros with a newly
created enum named memory_block_state, while also taking advantage of
the compile time guarantees that we get when using enums.

The first patch does the conversion of the macros to an enum, while the
2nd and 3rd patches use this enum to clean up some type declarations and
make sure that only valid values are used.

---

Link: https://lore.kernel.org/linux-mm/20251026162156.12141-1-linux@israelbatista.dev.br/ [v1]

v1 -> v2
- Rename the enum to make it more descriptive.
- Let the enum auto-generate the values, as the (1<<X) pattern could be
  misleading and they're not exposed to userspace.
- Change the type signature from unsigned long to enum memory_block_state
  where suitable.

Thanks to everyone who took their time to review the first version.

This patch series applies to commit: f30d294530d9 (mm-new)

Israel Batista (3):
  mm: convert memory block states (MEM_*) macros to enum
  mm: change type of state in struct memory_block
  mm: change type of parameter for memory_notify

 drivers/base/memory.c  |  6 +++---
 include/linux/memory.h | 28 +++++++++++++++-------------
 2 files changed, 18 insertions(+), 16 deletions(-)

-- 
2.51.0


