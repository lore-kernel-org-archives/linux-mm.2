Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15B05CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 14:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2B246B0088; Mon,  5 Oct 2026 10:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC686B008C; Mon,  5 Oct 2026 10:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1BE6B0092; Mon,  5 Oct 2026 10:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C44766B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:29:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 131A0802B2
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:23:35 +0000 (UTC)
X-FDA: 85288790790.02.6C297DB
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1D70F140008
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:23:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=edwoG1ZI;
	spf=pass (imf09.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791210211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtxSKsJ4qGQk3yWu0lOPutFCnBFJGvqMqZUqiGmUgtc=;
	b=2wciVnz3eYq7aK4ju3hOz6ePWiYeKJfL4ajugqkbgNAOGcOdmjCcAF336dmNYyk4cjFzCQ
	YDdpb+1A1jXZ8MASo4x5f7SRV4P9PZ1/1UsOSGKvodgBYmRAy9CNEOlsJty7fYZmsS272v
	KJIw5wO1vJqY3PmczCCY9wWn1iKwhr0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=edwoG1ZI;
	spf=pass (imf09.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791210211;
	b=2iIOZzHNMNfqu1e0aqV2KKRGmT2ERxRgDojKS55hCcW3jclzpPscyO1yLnG/JjD+0wvWaI
	UsgmbzxYyzw3i0yudg4EnKRgoY7Ayb45UnQii0niA4WjSdMqEkYKjB1mXFryJ6TtkqjS2h
	/vMazwaRhq/y1xyJ7HywQ3Te0B84ca0=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0AE0A40E0481;
	Mon,  5 Oct 2026 14:23:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id SfeJXfSwf0Mm; Mon,  5 Oct 2026 14:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1791210167; bh=VtxSKsJ4qGQk3yWu0lOPutFCnBFJGvqMqZUqiGmUgtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=edwoG1ZI14EIMdNF67HsrYiBouyMCpEIy3nCTt1PEHsrII7VArul7mdVaTmz1x9CR
	 YdsYOkDAkNx+pRmV4iNo7Ig5GlVFLEKpY0cii8033hQIvYPX7D6Na7Pu8p1ZMMN/A9
	 4piG+QUR6jU5DU0fPhQk5ZcnpRnux/4yAOEWEUMPhOInR3hFVvoBVuEdJDNpoIOkqc
	 p0APwJl1EiGtb8nDKugJqpiHrULK4lo1vcFiUI+zcp4+WUvWo7JjqtD5b4V6VSCCHM
	 p6oLWpG0EQcAkJFCvTi3lrWtHDnVYKa/8iitfr58mgirIxJZf9BzO5kQBxVBRPr1wS
	 h+xWch6cDdnpFTp0S8+PPgjihPufoLiNvMhzLtVQiK7NsK2vcU6Ns4MyZqKpkMEsNp
	 b5ijrkPOrFoTwYD4Pju+0hX1/vmPgbijJJK6AGsQwWRHXcM2wLtnveJRRsOyPRIkVW
	 0Upd+1IXHDK82rszWXX5+wVXRT9qyIbJTfKJgVtNNqf9dydiUdvIpc+2yqiTsspdYq
	 pO8yUmbZ/KazByJV+WiKJqge9S0pHNSxJ5ajuwEzuCMXmnd9qiCKyPrTTd/iKqopWx
	 nWB+OlmoX5pzGQdK+/q2L09ZXXseom19k45twk/kEmWIbFwmFSZpRezvAUKQf9R0zi
	 ngVZO6NsosL1VrqQwhxyMYXw=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F1A7140E02A8;
	Mon,  5 Oct 2026 14:22:19 +0000 (UTC)
Date: Mon, 5 Oct 2026 07:22:16 -0700
From: Borislav Petkov <bp@alien8.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
	Pedro Falcato <pfalcato@suse.de>, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
	mingo@redhat.com, x86@kernel.org, hpa@zytor.com, riel@surriel.com,
	linux-kernel@vger.kernel.org, qi.zheng@linux.dev,
	nadav.amit@gmail.com, thomas.lendacky@amd.com, kernel-team@meta.com,
	linux-mm@kvack.org, akpm@linux-foundation.org,
	brendan.jackman@linux.dev, jannh@google.com, mhklinux@outlook.com,
	Manali.Shukla@amd.com, mingo@kernel.org, stable@vger.kernel.org,
	toshi.kani@hpe.com, david@kernel.org, mikhail.v.gavrilov@gmail.com
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Message-ID: <20261005142216.GAasOymJHYnmn6wD5m@fat_crate.local>
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
 <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
 <ab077b6a-160f-41a2-a167-813f0560e30d@citrix.com>
 <38541ec6-d796-4f35-a700-75ab097b6df5@linux.dev>
 <7ad90e94-d04d-453a-ba22-9640a5024d8c@citrix.com>
 <6801221a-6307-407a-85fc-46906f95d22e@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6801221a-6307-407a-85fc-46906f95d22e@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1D70F140008
X-Rspam-User: 
X-Stat-Signature: 4y6hw8w4gkte6kcuhnhxbbmawohgk54b
X-HE-Tag: 1791210210-687316
X-HE-Meta: U2FsdGVkX18q69ugymmuy3lRk7LMDkjnsLF02boyrn1ZEYpOPM6YGSNRMNzTLqRBK3FHz6S50brBugcQq3JctortkITmCE4IixnzfLt7iC5OCIacmDRikB2RiLe7ZAYiI7mpRldLEii1yF0Xh3QF2dUQHFElVtOJV8FXDfcKPMJ4bBxfnFEzlJXdo+tX4wZoSk7YrA/iazak1UPPyFxeQTHSWNt22f4In2IqjuASQMnD3uN/FBgHlF+7oSS6ycV6WPC6lXNbbAe0jWngwyyOr5Cze0FzfFuomDgxBi1ErTgS3aRH5Znj1eq3Gn/SCxa+9bCvDWSYXdAu79jOe/VkNyWVT3/D1q9nFH2y6bVzRQCSq/QAalz9XgNXs5NqPrU4WC3AWyKLmLBDswhpmuiYYMzw0oUenYTb2KMlKC6+nkKr1lvihf2V/EspSHNKXk4641WsQQeyJ6y6UoRyIdRiyCj7DjsMixEI3bBkOpGEoFb1ncvYn2N6P0pPCg2AEEKRf2NnRopSUWcLW1H7vX9AS6P5rP9j6FQ6FTJtqc79mQDup0kgQah4s5OvUkklr4x31QvoyFVYlmMn5CLymDs+e+GpkvI/m0YuxSN+ZA7FKd10PtGRI6L5scpBhuwNSqA2dY/kfc9V+XW46Ou5r+S887NNkvOfkKoGg6KUUwt86yLnx1UZXmezbWI7yFpwoQCSA4Zlq35hDaa3Us8WUnek8yRJlJbKFs30m5wUOntza/RxH11UL9GQf9H9d/axncth2yQqz3vqNHTK09ddZ8AFlKOOId8HWZBJ5rXylNAQw4rlc4llgZWOOUz9tyRyCt138cvl02uzmLBzHg0baT58D/avggDzf4XLMAJm/8+HeR+1NKaRNE8MlS2+dgNejrPjwp0zWhXfS/5mLK9R1yt1Jqo8aNzCLM7lGObu3Um+fcd3iHTGlJhZiKXPfJg3nCayiz22wJWSJFzOblmWMMt
 PjU6y5hY
 n45nND925wwVUEPMQSTDi+9q1xyApngfEIO9u/xzM3lb6yxeWsYQb7ZT29bQSCdNDYcdapjWGki2SfSh1taQwIsjiD5H8RI4xI2stjwQaBbNI568eDOKmjdOhKGvtZKI0xhWlL5S2FAaM1gwzlYIuQKieJxqGi2Y7X+CdEvtW6+ToL7CTrDEufR7VJ7FDssyMqSRb2yEWJFKIkzXF7UkX8yHPaDs9vvDKqhELJmMmp3v5tXOLFLCbTQasKlFBbQpJlWmCukwgJsXasREsnWipGvv0RxgbZE6T6vtmRglkaHuZOxugXFWIPq7bdLFFfcSDZV1dEstXpGKEr3ovoAMNNXDSBGIs9yomq9vIlzOTEru/B7pqU/Yakc+ZkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 06:12:45PM +0800, Lance Yang wrote:
> Which CPU? None so far. As I said, I don't have a reproducer. I'm trying
> to make sense of what the manual says and what the code does ...

So you're sending a patch for which you have absolutely no justification? And
CCing it to stable too?

And that patch hasn't been tested to actually address anything?

Just a wild hunch?

I wouldn't do that in the future if I were you.

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

