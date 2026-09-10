Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 433D4C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472AA6B0095; Thu, 10 Sep 2026 06:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4228F6B0096; Thu, 10 Sep 2026 06:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311786B0098; Thu, 10 Sep 2026 06:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 095766B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:06:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 910C2A04D2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:06:25 +0000 (UTC)
X-FDA: 85197422730.11.F250D1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B7C71C0005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:06:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahs5XVOE;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034783;
	b=hyq9+i2mZ0ADDrIlWNvwPEMu992JYJXnCiJoz0FZVXQdB3jvWHKRtJSvX8t8OzEccm7Fo8
	PIkJot6s9yBE2ZFYgu29N+lE07gwiltEEGHWZ8Tuzk5vkpWjStcwsNdkuE3vu1874dJQ+r
	8byGWNuGnAP758moAz/DR9emjSLhvU0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahs5XVOE;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2R4POrVaFZfBJpe2LHKJm8IR+bpnnr27W/5UBFn18I=;
	b=5yyersaIBKMCX2bSX2SuBTNhTZb0DWToA52fivqSiuBX9ghK0ebHU3KbDuoj1FVz1l/ne6
	tAG7dgfeVVA3HY5rXKCZy6woFYnXXVbvoneo+VR+bqzRrfo1uGvLPdBUaiZXMb+SH/2ZAL
	5UCYYxFRd70DXBnE4Pnavv6Dh5uXVME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CF8940F8A;
	Thu, 10 Sep 2026 10:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EBF1F000FF;
	Thu, 10 Sep 2026 10:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789034781;
	bh=r2R4POrVaFZfBJpe2LHKJm8IR+bpnnr27W/5UBFn18I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ahs5XVOEXP0b8QXCo8p21pDywAa2MZx9irZbCY3Ffn+ZVpxm3+TCFZQAQ+l5cjIAp
	 DkgSIFEH1yP5SsDZxK2SzKVoTtZ8W9bRF0LRN5xST3+/9/OTsht1kV+c7vZfhiL9dO
	 r98m4KnvJ1knih6llePAtjuHBJl9ZDFKzSmQIemjuupJKwdSR0xCsCu5Ii1OIa+unT
	 QfzQDsl0nKnPOGz75Lu37DlDXOBY+MNUkw+d6SmM6K4cdueYlLuBIui/x3nz/dB4vz
	 yemKwiobHiNyFc629PPq6vS5cxnvc2XGTkC091X//uhhQrp4Rp748m86ZOTNwD6Erc
	 P+ConinppiWzQ==
Message-ID: <d2f4e7fd-b077-4150-8b2f-e81435d04408@kernel.org>
Date: Thu, 10 Sep 2026 12:06:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] mm/memory: improve insert_pages() error handling
To: Avi Weiss <thnkslprpt@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1788022178.git.thnkslprpt@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1788022178.git.thnkslprpt@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B7C71C0005
X-Stat-Signature: jpji16q17ams9ca5gtjq3toswtm5pp4f
X-Rspam-User: 
X-HE-Tag: 1789034783-658996
X-HE-Meta: U2FsdGVkX19d8n6l1QAIEUN9zYxBMONyxx84swGnaicjPUd0yPpcGrXDHBWaOrzBixq7KccbAiiXT4557kh800ZJpewrnEnjjb3AUz1X1UgKFZ6gHH5qqid/CcAPwdC6MLiOc6zqYchj9lankn5HgIgWXH9xK7ILYvDHd0LhyPw52H8eE6ik37asLZFIYxY7QQUC+slvap4NOdOC7QO0NvveYJebBZ1OwSdKv4LSY34PkYYAHdkZ4VbA3OjSd4S75cmjpT+NEQ25hIhyu+udZupKSyvN+ymTtcRdWrhW1bYJWt4n5jdHBHkakryeHIQwlKoKaUEu6xs710PyeoM9cMQamhdc79+fTVhKzyYQ3wR6FcyYsDNBAn99hD0FY7J5emHIf89XONMdUbpz0RuWGEctaJHdWfejpvz1k6+nn3rgHhi61PAQxWt8GeQhZfEM+SpKQr5/KXUtVmvd9kNhkG8rgsYnx4n7Yi+UczTaIN4ERqKRz74xo5aAuIJ78OCxyfXgyLzt2hr1rqKa1X5iooCi8Re/g1O1v83qwWiXKsfGhVBNky8TGcZT+AjUKM2Tu0AStn12gFBwkl5js2cWmoTSamFsQHiOelzCgFTjY0IgpJUkaGLJGuVPtd3IbXsfjXodyCX2L70rdtpH1e88NmmoyDwwRIg+nargJliAP8rok1YQbBAagDeOGqBX0PX+S4wK+NYiGcFVZ+HEKKRbT4lzQFwKjooNfhEL38CoP1ySbXmWtfsO+yn4sTDm1Njor8RCzypJ9l9y7QHGtxhoSOGxsjxzAzLBmoWODcbKKkfpXOqW+7PeZXtp7DVZXH5kgb5Rp0IqsK/votXMHP2lVg6uYuTa1L5/rRHX08isOLMRXFG9sw7GM8Da6rC6vMnJNLjb5k64vKRVPs+HiGyQU47B73UcatJYmsPUl9CcDyBQawygJk1SYgkgV/W4Xqa61cn2SPjGBVBo6ysarCl
 tDVltAuo
 XPK+0JmtxS6/YDjYYMOSh1eRCU13dRx0cab+MBwmp3r9WfIXUr1cdzuWFF9G7HBD0we9+ZYMR4y871JoGJCUBKBrrttMDA6yqgXdIXgAUS61i6b0ZFany9EnIuRbahzN+zCxQb+3p1x5xxG075mTFcu2YWeqM5eSh3PtPhyvreC1dpYt61jpFg+vE9vLxLXHG0mgF2tQFtZ7qFoNRqoQHAdheAM3g+vcApyz6rZgaIJTtv5HCjVxz1V+ezSrUNG+hQ8cSZ5Cy2JhFr1etTef+qUVfZK16yGwFxQWszOeekzVCzlRY59rBAt+m9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/26 19:11, Avi Weiss wrote:
> Improve insert_pages() error handling.
> 
> The first patch simplifies error handling by initializing the error
> status to zero and assigning error codes at their respective failure
> sites.
> 
> The second patch returns -ENOMEM when walk_to_pmd() fails. A NULL
> return from walk_to_pmd() indicates failure to allocate an upper
> page-table level, so -ENOMEM is more appropriate than -EFAULT and is
> consistent with the subsequent pte_alloc() failure.
> 
> Changes in v3:
> 
> * drop the walk_to_pmd() rename following review
> * use the mm/memory: prefix consistently across the series
> * carry review tags from v2
> * rebase onto current mm-new

Double-checked, LGTM.
-- 
Cheers,

David

