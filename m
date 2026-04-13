Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4E0F531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794726B00C1; Mon, 13 Apr 2026 15:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7452A6B00C3; Mon, 13 Apr 2026 15:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661D06B00C4; Mon, 13 Apr 2026 15:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54E796B00C1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:22:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0D1F1602CC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:22:28 +0000 (UTC)
X-FDA: 84654503976.13.16D4C0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E6096A000D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:22:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mx8jW+db;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776108146; a=rsa-sha256;
	cv=none;
	b=pdJ70b2WDt5rg0s4RJ1BoDCXK0Ge9Xj1hkfAw9x8/4y+7+LCANAJ3tELlq0KtZ4ydsByK0
	/vk0rDFsZHhPij129z1ihGvlrEiYwtKaLXqqWxIN4qOVeGR77fq/8ViL4H9VSOwnPPa8Ho
	cgJgnMBze2VIfD9jWsVPVfpyxdi6vb8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mx8jW+db;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhBB4btn0OBzcPsjHf5JGc8tImkHe60xqgk6M/ItToU=;
	b=Qcel0koYNGD4ZlZNzVgpStCwyoMVciPXaiJx+YfT+OYpgCp//OveTD0UY7fFsNKeWuscht
	5p9SHHlDTQ74njGf7fOYYzOoMHSRllrw4guxsN5XoAiZV0rdf6BlCayIZaPeXOF6AWGDVo
	PSKYyqJZWyl/pY5XFu77qCzThRaQnBM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5182D6183B;
	Mon, 13 Apr 2026 19:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D428C2BCAF;
	Mon, 13 Apr 2026 19:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776108146;
	bh=6yt3xOr8y7pXd+uABsqgDirlTPZCXO50u6hKg963WuY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Mx8jW+db/w3gjd7l4chTJScvVhQ72tI2b62f2QcBEtBCtvu9rfJgxGi0mBdEpimnC
	 vJn3xXR5/Tqzl5DwtH6Ilpi53r0X8VQYJ89nheC11P/wcIPeGbSglT50sgYmZXAgYN
	 ZKMIR7gWEVqLHbIhHkezkfXkmpCwngsi7BFgPFdpBfZvCB/A3jrn/9BFJYJMB0sx5E
	 um3SGeUcF/gAVZJ8079z5w6BICVGzOD2QKcXWckfwG/+/LVSaIjBVbKc21lwws+Who
	 uJjAOyf0kOdlI497vNftc5RIeUeUOpUrczMcBruSI8LQXQ739wMrtPj3NPhkdYcmV5
	 3TpUzHIqY/gtA==
Message-ID: <f43dea73-80aa-4f6a-b6d1-135c58e160ae@kernel.org>
Date: Mon, 13 Apr 2026 21:22:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] f2fs: do not support mmap write for large folio
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260406154940.2407853-1-jaegeuk@kernel.org>
 <adSTUszGSlEK_IBv@infradead.org> <adWMAzmaHiYzSTzN@google.com>
 <adXhq-eEjJji1rcc@infradead.org>
 <2aee26dd-703b-47c4-9210-f70ffa6faf09@kernel.org>
 <adaZt8GYIw1tKjaV@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <adaZt8GYIw1tKjaV@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E6096A000D
X-Stat-Signature: e86uhjx46fyog4qxdbznizqug6z3589i
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776108146-100197
X-HE-Meta: U2FsdGVkX1+mquHOLt27FEgjcVgVUsyjIWkBJwOzQex+bJBeP9Q2D6qdM8iy1JziJYS1b2oszLkSOMIRiVR4ocoxF9cWwz33GhFfvagctLJoD6J7/l4E3FXX/hYogKof0eur7dJ8K1zHGr+B2k4UkxN1u0lDya1xPWhFRszYtclBrQs1UMSVx9Fq98k8S9uuPOsGpWpdzC7QmyIRIN2EuFW41QissmcMrswMwMnucM0g8+5udm2ae7Y0GzN70MeWoww+S324BPj49ks/lAYvFQ7UT7cxDS+rfQG+KKnMSH32vd5icYcTbRC8ZfxLHiUp/caLrTD52GqpDiWDz3UtuIbyCfR1IL5UgBO16ZpzpocUhW8177sYvZdNNuw5XoTN3m4udbBd+lexMQgOh9HW8kjJXAbjAv9Dekv+Yu9giAA5F/Yvbms1fug6BOWGC+boLj7AZbDbCwbe04tdpAlsAaCMHpwdTPn0huZz0OaruumZJtnPZuygnRwWav7RAEAQJsQZv1fjHw3dsUbn8Kx9TByaeyz85xodY3Pf28QcLwbr/WDuLh4sCTpB0pgk2E34D5QhA7a76cb+oxr2RMTXuiRFDDwRoUwztcnmi1LBoVCXJyz+Kog+vOi+2nV1klgYsUtTLbN4/PlWcLwqmK825lPqbtSeDvIGqN6FEVJ89oiwpZ5QZCM6hMKW5/FKtTxfJ1VRtb0L9CMoomYcl8lqkIgeZi1tGXNbINssVTW1MJOUyhX1YpPTMPbUyyjdXmtbBXKFwFsD6mHQxl11PgnQUZ2DrQ9IJ797WvTFXQW0LPmedPvehHKwF8PK3HShcVFtnSW/LmAXB/iX1CjthVZtY0FsrF6GcmVTsjuucy5yGEg/1ZZCFU31rNYgyy8NhiTph/FU+0/qBUIibXMvCl1bmHXtodliprH3W5DD5wEzpr8nGM7/4lCfgetC8wiOR+A3SiHB4/VDW2kL0yVxDwV
 XCVJLLex
 hG7pR6xqHfNIh7lPQkAOmWfJbRrqD3epxhCIc223RDmbRVGWlJh8o21eNglwmiFdbR9M/rx92tPD5iqLabNhKlKXVRd0v9zt+XPkQmeMePlGU7LSuPiQxtK2ulPTjWva7JKubNbXuGaG0vBMYKWVoDUK24TsCXKApdIuaAY2X+EdVVLCdNHuVcvP95c2gAS4lr/IZUtfjmrEeuj/12TNezTsdysV+sDlXkKRj3ahML+emCbs3cPOVOvAJii/S8+Gu4pbXrMXvyNP2h6GBuEMBUJBxpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 20:08, Jaegeuk Kim wrote:
> On 04/08, David Hildenbrand (Arm) wrote:
>> On 4/8/26 07:03, Christoph Hellwig wrote:
>>>
>>> In general spelling such basic out in the commit log, and even comments
>>> is really helpful.  I'm curious how this works, though - by the time
>>> you read a large folio you don't know if it will ever be written to.
>>
>> Why are only large folios supported for read?
>>
>> Where is that allocation logic and how can that path even be triggered?
>>
>> Also, usually we check for large folios by testing the actual folio, not
>> whether the mapping supports them?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v7.0-rc7&id=05e65c14ea59a401cec4284e9d612f9d5dc1b3f8
> 
> Currently I think it's simple to check the mapping in our case.

Thanks for the pointer.

So you are adding code for something that is impossible to be reached.

Reading the other discussions, I agree that this should be flagged
clearer as an assertion, and not a fix.

I'll let maintainers decide whether that is a assertion we should add :)

-- 
Cheers,

David

