Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59AE3C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 20:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B57C6B0092; Wed, 19 Aug 2026 16:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565EB6B0095; Wed, 19 Aug 2026 16:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4550C6B0098; Wed, 19 Aug 2026 16:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20E2D6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:11:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FF31A25D7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:11:19 +0000 (UTC)
X-FDA: 85119113478.13.904A861
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id EE1E78000F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:11:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n9IGv8TD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787170278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZhL2T4YYI++E1tVweFLTBeajK7qZ+c0uQKy8sqptpw=;
	b=pS1xzwrjibM6H+FEXaHnt12IaKG0IZxBb/R30259XrMowK+Dkb+9m90BwFDzTg1VRXbZBN
	1Tw+eJ4YbsVHY7ahQjrwx+8pLRP28RVV35qK+541XSTUF/6YtAAF9sZhSCWdbBTktIqBdX
	OtxYoLdHX3L7AR9VR5FBToVhlekSTZY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n9IGv8TD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787170278;
	b=zvyA0dTc8aNxjpEuA0J5ll5c1Ne11uc6BT7BbFI7MLGs3/8env5wHz+20l8uhw5Gop8qGR
	BnblviKdrp5TXgYjemTXg4tQTvTI0dPBba+Pxj2nAINEDsldp5QgargjGaVGfgNjoE8HCg
	LvKv/rMHDaBCD9sszQrd/55C8u34UR0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C07BE61878;
	Wed, 19 Aug 2026 20:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C891F000E9;
	Wed, 19 Aug 2026 20:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787170276;
	bh=ZZhL2T4YYI++E1tVweFLTBeajK7qZ+c0uQKy8sqptpw=;
	h=Date:Subject:From:To:References:In-Reply-To;
	b=n9IGv8TDEquvik8XmKdwEBGYFzuVFC/qlCVDKejMNQxRcz+P4KqrTcB05tbVV+K79
	 ca0h1WgWzPBRWe+rV5EEVtI0G1ySLVzB7TYsRuuB29iPtbvMCSGsZGyFlqHFv5mxkl
	 1r6atirDreIwPec/V8btSstDB10BgLobvzESZwXPh/8cTXvCYfnU4QBLIEc8uR14Oy
	 Qb875XPMIq4c+oZxum7lpbEC2BG0iiTsTdAxgYarhPr2cgwu4+T07aI8PcDVOJdozm
	 2nVrnVJ6n8r0eaAubFIdZK8XIIAtK/XNhjFSR6AUrChJygwNwTTfDReagliSQhmvQP
	 KWao6bKG3xKPw==
Message-ID: <cc0bc18e-1e16-4d73-afdc-b950914b08da@kernel.org>
Date: Wed, 19 Aug 2026 22:11:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-08-19
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
References: <54d375aa-8362-4e1c-8f76-bae1eb9f4f76@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <54d375aa-8362-4e1c-8f76-bae1eb9f4f76@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7f31arur88af413zxp98hcy1eh3bne7i
X-Rspamd-Queue-Id: EE1E78000F
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787170277-280444
X-HE-Meta: U2FsdGVkX1/6LIGC0kPEGwk8Oknhb3HP8LkLOVxdG3tnwVGt+f131XnPA7d7d0YmhQ6xLSLIL9Odu916z6TjBJRiH3DlHOheQy99kCgCQT0b6D0qsjtegMTPdOvpce58t+0K/LLQxRGO41sei/HNslU3jcYZbAqFzQrsuLrYNIE317xQZfk70TVcD9BZCyULzlViEjp38S+Vu9QWHdYt8KI3X6XSuxSNsBg/QCrkC+53gdfDquy9zP33UK5c3nWkJzfuDcKRwNgds5rtaQ/5UqmXNw2kMn1qCUrF3dcHu4wk2aMdjeqFdYEp+1seEzjpUBOdaHsxxnBHBoMdbWYxQ5ifLCJVW3JTUcbSLjnuc+BenDHt4hBeLUDKmz5lJMyCakgvi7nPvfMwWdppucGYbGD0tTN44yypfnnNeG9pBaQtyCQ7T5t9NNhKl+wH3fyt2LLl2o69GydgtssHeEt/Gl/Iirrb9f1kvONGbh7YQL4yZeRBsjEetQNrAMGijvB/GdC4IO74UdfiVO34X/pdEC/XQCIcMDPM9LZLt/NJfT7NMDHPtY3sQ3E0rjz9vIuIO4JIleIDlTouhYq2LEjQ4ZlrM8i/O7XcO3pi8eqA3fWSpmqk1D+nlAfJFr1kgMv97noxFfePnNU0XasZjyeAKZqX7r3FRakA3mSSXzHQwwrNI95BTCjmkOHqhP9WcQlyj296uShto9afQuRPrBxPAzmwJL2UBumhp47CUezD8RT/Xn0R2AK5OKgk4tbfzESOL/k7o5typrGN8w4op1l8QZJmE0TEvi9XKbGETuG/W3kPGT/FriHNgPfCvH68QOG77QYhYnQb1x5oZq2lk1fFb6TMJauw+eiHqJh7z9WLNxsSM7MdfU0trxcG8dubsidtxYAdCKxOpDvKJ/MaDV6Oo51x2K7b0vgARpA6fEyKbZV+0nEWkNranWPnCsouX1RyEjdBh64iBL3eJKOWC4t
 bTbOQY/N
 alAsKwbFdMFa0x0j4Hw2gOCubr2py7MPlFgtrGNKjb7I8u5J5XE2xBZ6qDOfJHutmaCPAvtOs+LitTLhxBVhKRa5qwCyY07qrKNxdhu49DaplbPHDoVWNEMOkzswaSLdAgV8eNoh8iwpSsO69h+Jkg1VN2KDdI+D9ouYG82oVg5vCIwkMP3wvZSDRm8hwA+FnYQpvUF9hQ0H6KGdgpp+rWJfbxGuOhR+lbcDl03Z07yb8hGi9V2JX4B2x+9QVqsbzxUxY8iXcGKjoiS4EPbwITMyTtE6SisD2uOBCUhuAfgsSrdwewjniAZKLRFfcoj5owS8NT9nYJzrnwDHIrfFu2AzuVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/26 18:23, David Hildenbrand (Arm) wrote:
> Hi,
> 
> Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
> 2026-08-19 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

Clarification (thanks David W.): tomorrow is 2026-08-20

-- 
Cheers,

David

