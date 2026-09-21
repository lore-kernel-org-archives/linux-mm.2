Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686D2C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47A576B00D5; Mon, 21 Sep 2026 06:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42B186B00E3; Mon, 21 Sep 2026 06:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342076B00E4; Mon, 21 Sep 2026 06:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 025926B00D5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:26:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EC2CA2A04
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:26:32 +0000 (UTC)
X-FDA: 85237390224.30.D323386
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 768C810000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:26:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RaUbCJOk;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTyZyJijpdRj0X6CZpg9ECIQcR7z9LYrkbviRiCY0G4=;
	b=P4ZS3mke9IkSeQuEPOSoHuUPKEr0bmP+hXxthM3tzNoFwN0xIlsB4YP2T3kgDTRHPFJW4x
	a+4csIdsEq5qk8V2OI90rIZnDG0CK+NMXeWksptnqMcgQv/JMyYpRe5ZfKLQAQQUh3afnX
	5EycluYVOZuE8sOIg6YTLbdxS1DkAto=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986390;
	b=t+hjuaF8TCDRkq/HXUsZBrKq5tDs6Z71gFZz6YE+TJo+13DJBtecUtIWaO77o5hFJmyaXW
	vxiL+297dNMM5909wKBvlWEf6eqxE7uKXd5r4t+icKd8SkyGA9WJDLPxbDi5+/oqyE9e6T
	+OWRSnGcBKA/QXbDOd5jtf4TncmWhFw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RaUbCJOk;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77B8E42ACA;
	Mon, 21 Sep 2026 10:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DE91F000FF;
	Mon, 21 Sep 2026 10:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789986389;
	bh=nTyZyJijpdRj0X6CZpg9ECIQcR7z9LYrkbviRiCY0G4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RaUbCJOkKLo4tajvGYl2aCqTQCY3jQWxoBsKIHV2ITHnHSBXC2/woloaFdCGmW1Mj
	 dcqnBR/najbVBm0Qg+R1N7LTD78OeguoK+oRClpNLcd+DIrl2iwnxlSklyjNAgyFw7
	 gyuQC7+WGA1FINXKOPRe7Z+J+rDNKexGnH/P62NTzygOtx0pF6lSf4Ou+0XADS1yuW
	 CzTKi2rbMtTAQA7A64cF8mH/lnqIafIc2ZW/90Kuap8DxOePcQ3xYLkNQwwpt2acel
	 HcpCSO93IhzDUtVvz4c0RiHvmXgVOTXNL8A8fSFTEdugmmj+Q6Zejcq7dDwz70vPJ9
	 PmNoxsSt8U59g==
Message-ID: <b51234d8-467b-47c4-9d94-82e589643859@kernel.org>
Date: Mon, 21 Sep 2026 12:26:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm/gup_test: Track long-term pins per open file
To: Richard Cheng <icheng@nvidia.com>, akpm@linux-foundation.org
Cc: jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-kselftest@vger.kernel.org, kobak@nvidia.com,
 kaihengf@nvidia.com, newtonl@nvidia.com, kristinc@nvidia.com
References: <20260921094243.64698-1-icheng@nvidia.com>
 <20260921094243.64698-2-icheng@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260921094243.64698-2-icheng@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fwjp991hx4x4hma1rtdmqfd85o8tmiqh
X-Rspamd-Queue-Id: 768C810000B
X-HE-Tag: 1789986390-914060
X-HE-Meta: U2FsdGVkX1+3vudBNQHXoBY2k63zCk4x98LVxMqLTns8u8oi58Wr3dmti6zxf2LtacXCDSkh1k8o7ibXcmNpTrTYrwD+3PTj2xKSS6XfXWZeNDADY/IFtfTKWG5vF3Gl0mcMi4uix0XUGJl69hLL2J8ycuC6HwpU+uzfAibu5ihq+8Uk9r+nO4twXjIgqZ7ZxanxezCQPls1PJnH+XkqncWcIuuuk2zLiSdK8MrFwu9d+m/D/3bjMycHrYwgvXtByRZXWNAFzF8vllTCK8Gwsr0kQ5bP6a8uZ1UduxayTLUcIuYgXhX+J23CWKRFHXeaDO5xXSbENnrRiIKwLUxHEgKpn/fOJg3U3O/Q0nwzJtsHiydNlPNJTcwkaIB9ZDrXoyYQamCLAUiiUImxnNHlECzMwR7ehKmRxhH6FBBX28Ac5LpaHZlgCKRAchapbNVGYjDuXnXmE9ECmNufbmDmc6+6R724SRRbXWRN9oMEy9cW7ZSulryDqd6rAMM95LjglsuT1qva0nkbAZuSNfoxQL+xU0D1I2/XLFRJEs2VGkSr5RtfRiZ5QEu3C3kSGp+/SH/P8nZThzPR9juasRtYcdz/VWPGDF8BQLy/h+F3DtZ9wTe8QShaG10rqasmiasF8LAdDWhuXY8Ez4csUerHIswQoK66XVP1smYkHTjkzEbJhquk54LAcPIeOS7I3RFM5YfrEhs4l87EeokXCP0FkC0kPyaNuIthPoYxmLRkIFTM70JrDBYhn9waocd8zHpnuo58mRSuGJZzTfkwr2G/Z1IVSAc9WsLZrmbWbjgttB73zUbNOfEFENj/wqUhjnw/ke4nm1cIN9Nmp9pvlu5LT2dm97UOFO3WOdUScTz8vLfsug/UAgeefI0AROFu4z2sFJh1xfmEQxy6AW6GhN3PevyOpHQLvAmHWfZcgFapIsa3dBpr6mks/YdSYGNJBM8MamkC4XLjwOnrphgUAUs
 diUfH8W4
 eG+MuxQU1KeI/3qhS7PlpDhkICKo8FGnHcfk+656XOFTGj57giz0/qOiFxl5JJ8QU/0FACREF5ho0WeOGAezTW+b/EtWEX7gr8ukJNYjqhJaW9KWpG4GdxMIscbFBxyOAuISVSU9oNX9Q55Uzb014aD/+gOyZJZtY+uugcl/IcGeHIvC6odyWQGA3hxFMu54gXY+sEsE3yTg5eJS7aJpZuxaxR2tnWxyMdmiAO7Y/238Mv/BJTD3g2eFsaXZ91y9bThYCyUqnrDoZQsX2Ova+LorWOmDsuI+GsRL90QychYppAgJG41bdO9pVYmIMVgQeIT37goHaCZW86lCfpTa5TryLgw6i2ATJNDOY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 11:42, Richard Cheng wrote:
> Long-term pin state is currently global, allowing one gup_test file
> descriptor to block, stop, or release pins owned by another client.
> 
> Allocate the pin state for each open file and store it in
> file->private_data. Serialize START, READ, and STOP with the per-open
> mutex, and release only the pages owned by that file.
> 
> Descriptors duplicated through dup() or fork() continue sharing state
> because they reference the same struct file. Keep the ioctl ABI and
> same-file duplicate START behavior unchanged.
> 
> Reviewed-by: Koba Ko <kobak@nvidia.com>
> Signed-off-by: Richard Cheng <icheng@nvidia.com>

commit 534b19bbb67717eea2272573bc0ff7ba4ba109c1
Author: David Hildenbrand (Arm) <david@kernel.org>
Date:   Mon Aug 10 13:31:14 2026 +0200

    mm/gup_test: keep longterm pin state per file

    The pin longterm test currently stores its data globally, shared among
    multiple concurrent users of the interface (multiple open file descriptors
    -> multiple "struct file"'s).  That makes the gup_test interface
    problematic to use concurrently: two users, such as concurrent selftest
    runs, can interfere with the same longterm pin state.

    While this has not been observed as a problem so far in practice, let's
    just handle it cleanly.  There could be a way to trigger selftest failures
    by e.g., running the cow.c and gup_longerm.c selftests concurrently, but
    we usually run them sequentially.  Let's add a "Fixes" tag to be safe, but
    not need to CC stable.

Which is already upstream.

-- 
Cheers,

David

