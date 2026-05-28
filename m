Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525E9CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A1E6B0088; Thu, 28 May 2026 03:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A6E6B008A; Thu, 28 May 2026 03:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7615F6B008C; Thu, 28 May 2026 03:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64B0F6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:28:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03F66C1941
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:28:05 +0000 (UTC)
X-FDA: 84815999772.19.A7FB88D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4E4B914000F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:28:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eA7c4CQC;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779953284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=34mIzU/HK17mAF70IBteNDWQtmnNv3IMAkT2Gk+MBOU=;
	b=zYjlDoc+gj8vcYUWuRXM/ozrRkRTcQqQKa10bT4Oen+fYmM1YTV7JkcSjwMymVve5ZeC5h
	qD4CjREGADs6dYxmExdfWTsTVCJajuPnXWu0kmvE5qCvjq/v8JHGJLCcGFu0LO+Z7ZJ9fL
	mIz0kAmdd2Cku87u6i1AhBvbgrg8r6Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eA7c4CQC;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779953284; a=rsa-sha256;
	cv=none;
	b=YEAFtjEFQLXAeKBmpE/Bdrqmvy6Ah2qYBHWs/5kwGyfaVh5duiM7ttRM+R0wgyDTAerpUd
	tzuOLupMpfcOWIWm2JDEZW8PLg3hQbg+cmqV15D2oqLW6HNRNnoBDLWvveNr738EoOusdH
	70+vCRWGSkDZ0YB2hEJ+BP6lbSutp+Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67415440B7;
	Thu, 28 May 2026 07:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15A21F000E9;
	Thu, 28 May 2026 07:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779953283;
	bh=34mIzU/HK17mAF70IBteNDWQtmnNv3IMAkT2Gk+MBOU=;
	h=From:Subject:Date:To:Cc;
	b=eA7c4CQCCcbL+LFrSOiL7OpADj/sn38z/f+wwzPMWsajyyd+yM9nxlnsjO/Z6lDR5
	 2TCx8ETAIGXiIl9K+BMbs6PYBElYnMhW4jKzS9B+O4H2nGihd3ITgE6kk6f1KJPUL3
	 XZmprZBXUSBxcb4fPLF+7VFQqyp1kMxWWqX0qYtxg5NRRX4QnY1jQvjYBW+pwX2Jfx
	 1gXGmcpePwS9Ly2I9JDD0a20XUjhwJ4XzxOMdIZu5WvnAu+SPN7nNe9xab/aoSpvxa
	 /SJgx9bw59oaycFcEv/MT/kb59d/wjn6XG5wejS4S7L2y/yBGbs9Sz+5QGDc3+eXSq
	 3cvZF92pGTYXQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v3 0/2] lib/raid: replace __get_free_pages() call with
 kvmalloc()
Date: Thu, 28 May 2026 10:27:54 +0300
Message-Id: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHruF2oC/1WOwQ6CMBBEf4X0bLW0BdGT/2E8dMsWVkkxLRIN4
 d+leJHj7M6bmYlFDISRnbOJBRwpUu8XoXYZs63xDXKqF82kkKUopOAdAa+Mg5PMlVbiyBbnM6C
 j95pyvf10fMEd7ZDQ5AATkUMw3rbpBPpAnob0aSkOffisA8Y8JWy7xpwLbkEJXQA6WVeXBwaP3
 b4PDUtlo/yHyh8kE2SUE85KDbneQPM8fwGBDGQk+AAAAA==
X-Change-ID: 20260520-lib-8afb92134307
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, 
 Mike Rapoport <rppt@kernel.org>, Song Liu <song@kernel.org>, 
 Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4E4B914000F
X-Stat-Signature: b66cgjww36xokmeba4spss1kp3q9u6eu
X-HE-Tag: 1779953284-82142
X-HE-Meta: U2FsdGVkX1+MWd8BUl+ppMdnPzPIsSZO7qaL1A0MNuysM8orjrdh94mNSFptAwswQwMeH6JA1ESOLVBisqycEotCLQdKPJyzBosA7V6LM9drOaDkuftz/KAJfmTgjo/guS81mFICLDNLHGTRTZ6tcsbbDUXN0uz8j1lCO/DJad47jgXVNSB5ZsQmZIqbU86smfH1MO6ZSYi9mvNr3BOuAK7fpo4wSyUnWesHi03c3yeZNKmAZQXn0gCfJbzrKfeJmDXIn5YMW2jCzorHR7YE2facsq1Q4iEEJuipwUKd1zbwAAONDffNx/hWARW2uRKvJgF6L6zPdcml7SHx6lYuZ15b1gYa9/NJkytEyIUOUcNEyvOUrXKdpAQUqh4+bgqyY1nAD/PecaFzOlgF+mqzM3DTyIQOlEwvoHt9rualwMcRsNCEXUx1itpLa8XDaYg2yiR6eIsOWCWLjiAqtGUlL3WURYe+Hvjt83AFAQY567IKUqMkcpwcNJt3lNZ09ayPKmeiS6p/zlLECoVqU2dC9At1MRq9AGYmFe6qkx9nfrP3xoHzH6B2mWxGu9F9yr32Kz/KBMFplXQ+shmqcpEF3Trjzh0SlcmBPSs1aUhgDzmSZBUyh6W5hbr3pNRmZH2oq1gypawBtPFDXYGaZ/r0/gYq5Fa+kZ/NtNAWxfRnpKVcgqbVhh2ZTn3CMmwHsUzZs4dgKAETi1tWQztd5xPYA25qemPwf0EDhrj8mAjgn4j0RWiYth4aq2ZNQ0idWmBu3bTNzrEOqEhE6BR5WtlaIt+WFmaOr7gXVL/3F1gb1pVx6WMg0r10pdlpSAuov280nlXexdzBySg6EDjw3/+Jt6UcbvU+gtlRU+Uuakh5/LmqUGq0eXVsKfGaftsBNASegqMYgtgSk/Yjff7QyEl0a9Ckr/30byvkbeelW31fJxJ4Qk7CE4sfHXgCcKdA2Gj9DhTscIqC6oriy5kKptF
 icpmMMxK
 08L1O1WrtSq+4yrqIuVuJAe4TWN1MFuXgnTdJWhKXWNtqW9bbUsuXhz31NfSEYexB1vAjfDiYxwoekuvT6N7GbOmQ0FL3O4x0QvI7kH/P2h35RiBnFqyvXH04X7kFBkjAixIOv6BDpWD2tzqv24+2otriFrFfTrzKnRcnbjjJPIECfIJeu/MQeuCTIXkdYnEMib5ZaUs/3HMvqvPQ+WWzVVtTEN3UuZrxJe2JSU6QKidLGpD8RNpXWloZLDDcZp6Wl0cbJm/0RSoHGBkThnOSBtZEJExT4goKs+5mClOBVEe/pLxpDN5JfAeOHx06FOWxFzNArCHSkjS2TNiB7pfL8U5C33W3kDq/ckD1VQfK2QxTpwtVPIzdkzPBB50cql1Ha2A9x8schO2oxcr771DwjKGgwKjeIeD1TewQG1BU4HX5FvBHH54zErRwWVXA8gTN4XqQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (tiny) part of larger work of replacing page allocator calls
with k*malloc.

Nowadays the right way to say "I need a buffer" is kmalloc() rather than
ancient and ugly __get_free_pages().

---
v3 changes:
* restore kmalloc() per Christoph
* update changelog

v2: https://patch.msgid.link/20260526-lib-v2-0-ca3f0fc24b14@kernel.org
* replace kmalloc() with kvmalloc()

v1: https://patch.msgid.link/20260520-lib-v1-0-cb3045bef2d8@kernel.org

---
Mike Rapoport (Microsoft) (2):
      xor: use kmalloc() in calibrate_xor_blocks()
      raid6: use kmalloc() in raid6_select_algo()

 lib/raid/xor/xor-core.c | 5 +++--
 lib/raid6/algos.c       | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260520-lib-8afb92134307

Best regards,
--  
Sincerely yours,
Mike.


