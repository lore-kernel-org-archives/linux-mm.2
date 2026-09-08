Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D0DC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D5B6B0092; Tue,  8 Sep 2026 09:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EEBE6B0093; Tue,  8 Sep 2026 09:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2043B6B0095; Tue,  8 Sep 2026 09:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 060296B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:41:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D645C06A4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:41:51 +0000 (UTC)
X-FDA: 85190708022.12.5CABF7B
Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD93A140002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:41:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=imQj+6UC;
	spf=pass (imf26.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788874909;
	b=Kg2FMSLqsw51jyksmV3EJn1Ilt2FNDTzsj6P+PCR3AhmfsMV2sMjesNWRXDAXmosk8Zrsl
	jE0cQ8JInHFkl5WnXv1QCbK5ituq2np9A6vCdUcMX33kH0aqNDKNqY9rvUG1u3blXBMSfD
	wYFN1avKJHsI9lu24chfCoEG9+kum6o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=imQj+6UC;
	spf=pass (imf26.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788874909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zec1p0QLFpbMyWF4K/2WLkOvQ0nybkowGydZ33JLIu4=;
	b=ckzMeD/NTJPsjnXMKG0PkwWm3SCzm5JPlgXXftVes0hSMJNA11D5ApgKUkIgbNwD3iMxhU
	VSx6Fik1zr0E6hGJMqUS6ExPhpGthJMmll5dyrFFFpfRNLEcxBmJhWOKVBAlv7/B2Ojjpb
	Vk9Z0IwOMC1Oi77KYWyaBMELB1vYosg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wDM/C2iLMlGhOWS8ms+YRDtFyqA9wYNdgpqeYFK2a1c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788874904; v=1; x=1789479704;
 b=imQj+6UCtFZv9b6uSvTlhUcnNhE2MJymZc3g7kWsUlAyTiPbdICqyCEK8caqUMPFY1iimQ7M
 GnGAOl6RaGcuFV/P9nVexyePxDCgO9cc3HlC6633z5jJZ3V7f+zIDjImbw1xXf06UgQtmLB53YX
 7bnpwgs/rRx1MoPCtNjBre0s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e4cf5d51cedb5d4e;
	Tue, 08 Sep 2026 13:41:44 +0000
X-Mizu-Trace-ID: e4cf5d51cedb5d4e
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH v2 0/3] selftests/mm: pagemap_ioctl test fixes and cleanups
Date: Tue,  8 Sep 2026 21:41:14 +0800
Message-ID: <20260908134117.84405-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD93A140002
X-Stat-Signature: ggxjbkwo7e3nfaw48kcwp6hii7a8bpc9
X-Rspam-User: 
X-HE-Tag: 1788874907-351712
X-HE-Meta: U2FsdGVkX1+skgr0quROwW/FxrKnE5VvuRgpMj55eyfH2g4YpTjp5JhSUl3dW4f4Rr5OlkbqNHDVAg+2ZcMvoU6XM7HyQWLhKtwJ9D7SWZxWJ7EEZGlq1bapGVVvefzLyiqyGG+R49d3RD+BmMCkk2mIpdTTPSmitXzPZAQqTBjpYpNtoU/SVKcZLzaWvpQm0lLXjVLt80WT0iSNFAzirSNVaja8I9sC5a/PGlGovBuOdNZSIJb/GOz45pp2XwWsl4yqMxlxudgdzZbVXA/mqn49DTexnvXX0dwj5PwVMo+boljy5fLnbSxSoCe0bnMpX1mmQ+WIR8k3Z3IFf9ReFkfXQAQNPvF5B1sR+wSKu0a/2pMWliZvTYLmWD8Sl9b/xrR3CCctusvsAfJ6qQXnUYj4vy0r8SB6cygvA/wQU7I7qGQSAD51KAs+r4sFkfUipZouKlBn4xrWOo/avFfKSxnCjv5Da+4FR/b9hcb0jyVIb2kNDyyTKgOztRM2r3Cg7E9NKJRms8zSp40ZpnGJdZr+kV8q4J7Rc/agxFe0C9W1u3NNNlXIcLHT64Tkdhyf/BYzOnEYpsqjvwa3aojeFSp5GGuB2HkTUJ8WJS0yumGobDuSCBIAzwlpLVWDjhKaaCfZ/M4y51YXad9uti5LjWdyzE6vGlM31unsHjWhXdzO/i7xGJq4yZRZS2kt8audqZsnJVrnA6BkMY1oI2ampWKC0qLO40LF9MCcxtgX4Tz0lYyMZ3gRyi8JzcldR3X3Oiq0VrTbCjSUdcgrbDn5bbiDoUygnvLLMZKiLtp1xi2z72l9ry60zaTN879NF1qLrSMTVdY1TjUwMugB/dBQtB2NmYyAtsfEFJsVIMw88dBu1FFiyzgSjmno8kVKVkCWS/jIBFW/rdPhgok/Q8RDWMb21JeMPnQU5Z3AmZtD9MbwDj5l0mNbB5uEz308m7fntfMoEMiRb5m+eCrocRA
 C8gpuLcx
 8X3ZepnGKkIrIXyRnD7pdqaRCGsHAyGt4s0x6dVoBZ/wpiOKB9E7Tx01GA7MX+ACyhspRDMgaha0tUEI9VqI0HTqKWeKXWKSCK07YimU9c+JX+/3c5uq6Lq7LWixQ1fbwkKnIx8rbCH7ELXXkuIrCFmkxLY2o8VLoXmaifvJ3usD+eusFhFGEAfUP0UzXl3oL42Tk8SMOW8wusPbMvX4COcuxXlyjOL8oKSOuCLxYU2UTcFazNT6pomZf0c71pXr/5aAirq+Bh9ZAHm98jL2XSt8T74BEWdsxzV0jXgIvzRUTnDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

This series fixes a size truncation bug in the pagemap_ioctl test that
breaks it on arm64 systems with 64K base pages, and applies two small
cleanups suggested during the review of the fix.

* From v1 [1]:
  - unify all size-related parameters and variables to size_t (David)
  - drop Gregory's R-b for patch #1 (as the content has changed too much)
    but thank you for that!
  - add patch #2 marking file-local symbols static (David)
  - add patch #3 initializing page sizes early (Andrew)

[1] https://lore.kernel.org/20260907135613.68692-1-zenghui.yu@linux.dev

Zenghui Yu (Huawei) (3):
  selftests/mm: fix size truncation in pagemap_ioctl test
  selftests/mm: mark file-local symbols of pagemap_ioctl.c static
  selftests/mm: init page sizes early in pagemap_ioctl test

 tools/testing/selftests/mm/pagemap_ioctl.c | 94 +++++++++++-----------
 1 file changed, 48 insertions(+), 46 deletions(-)

-- 
2.53.0


