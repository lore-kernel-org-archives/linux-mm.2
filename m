Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F399BC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 08:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD426B0088; Mon, 20 Jul 2026 04:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D849A6B008A; Mon, 20 Jul 2026 04:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2286B008C; Mon, 20 Jul 2026 04:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7C156B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:49:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06698A0E88
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:49:51 +0000 (UTC)
X-FDA: 85008532182.05.8DDDD9E
Received: from smtp-42aa.mail.infomaniak.ch (smtp-42aa.mail.infomaniak.ch [84.16.66.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id CE00B180003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:49:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=4ezaj5jQ;
	spf=pass (imf16.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 84.16.66.170 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me;
	dmarc=pass (policy=reject) header.from=ik.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784537389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0fo9bu9ZfFIZs/fyJH7OKdj212Tc7OSNbJXo+DCE4I=;
	b=VF8Y85cVWac3co6RpIelUZqNyHKA5VyPlRal/7QRXLCKKQM3hw70JWlUycF2aJjxVR3qdA
	aIVzd1ucc8et4pM4jwEKNdN5oqAV/bdNHTKHIw3+/tVh0o6RTiYpd1ROQ8KYp97J8L3r9+
	hXF1td77YUrZzGjWPecTqXAkM/IfXyM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=4ezaj5jQ;
	spf=pass (imf16.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 84.16.66.170 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me;
	dmarc=pass (policy=reject) header.from=ik.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784537389;
	b=b/DVhVeDBuYEn2rj65glNPJA/MwyFHIkL/G0PF/2ATG1V/eBDwtbBk9CVjYvvZWqcwzlPm
	HSp++NFopCzWyAZXkWNIR8aDij30gs3FkWftgPSL3JICV1w6ux49z09qJ6hSJtEtwEejPx
	z/IxRTm8g4mmGYipDwciW47MDkPlSEI=
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h3Z2f4dmYz1Yh;
	Mon, 20 Jul 2026 10:49:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ik.me; s=20200325;
	t=1784537386; bh=H0fo9bu9ZfFIZs/fyJH7OKdj212Tc7OSNbJXo+DCE4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=4ezaj5jQe0yzY1mq+uwMlTHoV22A4ThV8aPwaPgz4P5r5W+EmXanu/5dGv+ZAx40r
	 N7BWk/iU38ejeg1ymoizzOaBDOmkEov21K8G9FaSOvk6vLVSSPON9jGYzhslcuVAMe
	 UvrsHTGlLqJsCDOtxuWYqG58dsjvKsazF6C/FpL0=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4h3Z2b60XLzQvv;
	Mon, 20 Jul 2026 10:49:43 +0200 (CEST)
Date: Mon, 20 Jul 2026 10:49:42 +0200
From: Nadia Chambers <nadia.yvette.chambers@ik.me>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org, 
	linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <al3YIwkfheZKUFYE@ik.me>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <al0xogLqubAZh6SD@ik.me>
 <4d4fbb2b-dfef-4228-9e9f-f967aec4dfd7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4d4fbb2b-dfef-4228-9e9f-f967aec4dfd7@kernel.org>
Feedback-ID: :3e9ae705af0626a:ham:b89b32586f6d122
X-Infomaniak-Routing: alpha
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE00B180003
X-Stat-Signature: jhgpmhzhhbnonn4jcj98psig5optbwbs
X-HE-Tag: 1784537388-730868
X-HE-Meta: U2FsdGVkX18U4w1YH4bxvx2oiiXOtN84PY/sicl8/z9SkaRHgrcONs9dii+CoH6DOLWEHq23WcfKtxhb5yAWxBtaeCDmD9nD1QI3V1G0H6VpxNzUXq56o4ePCKnOIclu2BtmfQEmd3YNpBRiQoWN68hbZRn1hxtwpUbopmdeVunrYsrhRCsc3Hl8nmGi0FajILNPH21+JSVQOgbKta1BuUHeBk+IGoih0edKqFZduMSdYOLda6WdRYWLtb4G1a4pOD+jx0UlcjfMrpdzrq9UN3rNLv3KNIdqDqt8fmbMxLXOi6T8DmK0KQTxJFnbHo0p80R6wkKWA6d2ncS4i2yT3ymTZwo17bGjajJ98H7KbTXHk7vIMmNCE8hA9owbLbwqPwT+Veyq6l9Z7j03On8zre02yDIEL6J0wlAzTQrmUN3fbFhahuZXsfi/v6nGc0fgmXH8cUhekhmtwPSRCGZnpr8TAb54wDRsdrwi7fiTKahwKF5H/uuHaug48sKJzzHLtLAhbWgIdNQVDwba2mKfrPhjSUhPNh2M6ZILUS40oHzrV85050IlLZDJbfkg3zGVZsSX7rIqOu//jXKh5WSR7XUP0xmtMZPwXYW7FsaYZpJfKzd4WpWkFFqmjGwfugonsJXKtpJKQtG9xfILx0wiQPeJsD7DDaoju5yLX57mFPhij/ZVz3y0UvZjxdGTEj8g1A3SZDqZclqg+OwcHkh7zbJkp7BfTMNdu3vnYT2REQ8X4muzLeIkP72SPS0v0Gcpvs0qxlipFFlpiaeDzhm9sHax5+kCiS8/zye7HvOjwvY2q1bfzQsGd807CfNvueXTa5XMaC/EvqBTyGs3GktfPaAAgynBzmUu+5b7KmZaDsDBo8SqNg61AvbbGDwTU0zfz3j2PsTZGx8ZAqxGy8t7GWITQEn/jbwzFNsornoOaPRFRR0OU/fxxmbECEeLBLwoTMD1jRfQy0Om90k41+t
 ncbU67sc
 pGZ1Hdq1I75D3YsY9LvLrrsxTkpiudwq+XCPPNm1dDq+B+GObOYkTsl4NL0pgioXJcSCYC4baAeQ8cIwLNrNdDCznbh8zp0gPAKdRh14us0+TyNqBDyuuAEvjkInqbjA3yiCc+UQ1E8HhGExL7pjkgV2N+k+lj+1HBAJuW4g3d2fNdC5X1+sCkH35GFCSn4SRxW2jR6aa0TT6d0UfxSjHPXZC5lzWFgU76tHKIZSOJjGijUkO8gCcS8XX1FyB1KZr620gG2ZwBc39JRDfMURMQQy9ci1rNBZfGhel
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/19/26 23:24, Nadia Chambers wrote:
>> While it had to be written, it was a straightforward extension of
>> converting ->vm_pgoff to being in MMUPAGE_SIZE (Kiryl's PTE_SIZE) units,
>> recovering offsets into pages usw. Nothing seemed terribly hard to
>> understand about it. Really, the code as it stands rarely approaches
>> what it's doing in such a way that it broadly surveys the layout of vmas
>> and pages and be conscious of whether pages spanned vmas or multiple
>> vmas were representing maps of of fragments of pages, so I'm not
>> convinced there's anything particularly unique to be afraid of here.

Am Mo 20 Jul 2026 um 09:02:21 +0100, David Hildenbrand (Arm) schrieb:
> Just to be clear: I don't want this.

Understood. Maybe it was a different and good experience for me and I
got my hopes up too far that it might go anywhere from the recent
efforts in similar directions. But I can work on whatever people
actually want me to instead.


-- nyc

