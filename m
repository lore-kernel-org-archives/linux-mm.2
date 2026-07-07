Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8167C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776896B00A1; Tue,  7 Jul 2026 06:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DE76B00A2; Tue,  7 Jul 2026 06:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6644A6B00A3; Tue,  7 Jul 2026 06:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F57E6B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:34:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B30FB1C38B8
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:34:56 +0000 (UTC)
X-FDA: 84961622592.26.1BE7512
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id D8954100006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:34:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=u0QPMqTI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=wf+DLOqv;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783420495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUepwqSpsd3X623j785SSmasvMme6Isgo0g/WBHQGdk=;
	b=e/cT3tqpEAwn21j4wpFBDOLv/O5zDaq2xYoh+21D6IqK34kqi97ROOshkCA5jySpVaKCEa
	inI1UO4IfSZRsp6u/F12JDMTXbMHYimTkCMAqVnsm+/aeO7yfqykL0yPgqav54uSqh3AB3
	+PniF87jvOcnz8x6f6FPxRY2sKjaQLw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=u0QPMqTI;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=wf+DLOqv;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783420495;
	b=LPR0OxxwQCrdaOImEwtKbeTK9ieYuKrfJPWmvovAAd3D95DDL/7K0NpLsOr7PgifNEG1+5
	6E1dwVxp1njn7QYG9el5mCnxHet8HhP0NgdMvtSLIXDBFXMzTtLSlr2rOWyr3RVX+LFETZ
	PREOXCk20MmgCiKduat0wYxP/5LWPZI=
Date: Tue, 7 Jul 2026 12:34:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783420492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KUepwqSpsd3X623j785SSmasvMme6Isgo0g/WBHQGdk=;
	b=u0QPMqTIoolQHK+MWeg6Hrk1qDbvuyTiSAJV5QqXb9fIFpAwLV+/A6i3RY7y2Q5NOrNHPg
	WMCb4I48soFQQDP1uC+yYLwIE+q6bfqzEyUxvroJmO5zf5EQeuqY44UmPCqz0ktwJ5x8zb
	K/jR54x6T1+TkAKDPcpynJf63/x56iUcMSPQlxX+uoylxzMakYIx18Tel0PWacmjiFszd3
	bhaBj9f8SzF+PJycqTSCOsBYjfMxnJyZNkFusGcF5w9YjUvYsdt4XhmcejQFSoeHf6r9nC
	7kPpVdM9Rd1PD0EhWzc32TK/9x8m2VkZ1NTD+A6BTAL2llxbwwOtoTJ0lCv50w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783420492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KUepwqSpsd3X623j785SSmasvMme6Isgo0g/WBHQGdk=;
	b=wf+DLOqvEShc+UIpmPOFJHVZ1Hw8VyjhbipbDf8rX2KOzDJyaUndpQx2IJ8vRgUgaF+UCS
	kWzffhYNe0UiW6Aw==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Nathan Chancellor <nathan@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Douglas Anderson <dianders@chromium.org>, Gary Guo <gary@garyguo.net>, Anand Moon <linux.amoon@gmail.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
Message-ID: <20260707122827-2d6c18d3-8e02-4d9a-bb29-2ec46e759645@linutronix.de>
References: <20260703022507.187457-1-leon.hwang@linux.dev>
 <20260703114128-2a7a4723-0060-436b-99d9-7499bd90fa82@linutronix.de>
 <b6f5f3b2-bf62-4b77-9c74-debbed9a4738@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6f5f3b2-bf62-4b77-9c74-debbed9a4738@linux.dev>
X-Rspamd-Queue-Id: D8954100006
X-Stat-Signature: 9kgp9hwr4tiuhy3icjr85hcmfkfi77g5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783420494-904683
X-HE-Meta: U2FsdGVkX1+NYE1ZEigjC+/62FoStzUsvY0/7Y4pFpAGAH9B4KCIZ9rlQU7SSEx8S98c8DeqspnXfy0uCG2eFGu28iQ9Ufwm8a+G8+cSsBHX3IdZRpNfzBiOArLtfl7TFS4QFxyaiDZS/6kFL9R6H0H1CSC/eGBd/1FYkBGZLnZIzt+TQ+rKmcX3ru8DW8IrX1tXu5MsDgrIB/7l02u8bUrQcTcshsGQELsvrPFpd8i+b4SsJ2mWBqGIagjnh+IOMACkcZ/aTI71ylMRoBcxJ+QyzF5FN4offoTMKpTgSz2h/1q0PqBncicZhpXnnkHb1jE3eakyckOoz5Bmb93Fotk/GdituRu+NFHtjmTZvvfhYjj6CHyEWBahp0+XvRGeDZQTOnl083aGBidsQStFrsXfe4iBXq+BICy1x+cSFe0vgHRAIueiHUj45einNOmMkrj0s1v5jsrYkNCzR5hAfvuhhvjEgnvDfXiMw9LZ/+ho/SDwUd2AbIrbdpbu+SFdptmTSbMToJ4AlL5GZl2hSZbbeUb6hOaRGxfvITlzTURkPKUai318nyniWNok7S+gPjidaJhG7KnM9oEmyoqPA7cLEAtoHpXjkJkacdAGsdN/hdFtVMlQIX3CP3jc6tfxurfHsAacJOufd37F9B6vc9MFSKASOpTyHCfYzpgpumOukd7DydIyJes+fUfQjGlSzw06omFg0Er7rSQdw07hz+1uUQLLU6TYCnI5uMpXYMwiJXDzYxQw7LiSheuXoEEEX60/3/WYEi1YjwY9Fr8JBIyZOqczrD28KzgyvZzI6wNGysAhH00vja6D0Asi+owht7cQqFRRG9J+9jPhIQj1Mygkp4CD1+u3h91GVvWHz9kK85HJLNROrgsrlYzv5yR+WhUHzDO3Fqn7h8LgQc821PuMU7EgS3AEr+meAm6YZ4gfOx923AR2+NQNSFmUUvkrEuF12Nys13JeHTfQPfd
 mnwt9qGy
 Q8UGMY6pxA8t4TpGT7ZMmCL92R83gQ4STXWodOL03S7nlYC3Pho1npX0qrDVKjwiCeOEi7hXiTTrd4xu4qlDCTdrQWLok+yxfpQi3pLIvBK+RxKlmTXc9Y/OVIrrP5Zeb+aV0B08LHCIO0VhfzKEACELI4uuY4ZlS/63v2NAjtoCD2cn5RgCeg8Fpo2XQt8h8/qgzpLAcNFdoZnm93VWLghd9RXD0otz3cQSFELnGvK1nZZkONXqCAeEg5o4DjKELlPZPAHmLiIc/SeRf84SAyLO7Zh30wncnJSG8LOSf3G4oc++vRfbSduGDaHbv59FsjgOJD9En1zbv6qiIWh9+OYB4NduW6LeKMbCzwC36z/hH9OrM4AMLJRFMKHSj5tobOkHc/EDXX/tyQWEHsk46Zs7IAfT/PovzEPvNgE4W+rgWC5v1OQg9ys3xKq6FuCpZ5e1KE/9qW24Lt/IJxu59gX0ZwBIv9zrK6aK3jn+QBM9P4R1WpCzQLl8uueyL3nHnVig5+F8XJcCrx7BXIIMs7ZuUrZK9JtITur04ALHvSLWlIzicMhjvxIUXYnBgzgwb8botwOSwc3EQ10I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 11:09:55PM +0800, Leon Hwang wrote:
> On 2026/7/3 17:44, Thomas Weißschuh wrote:
> > On Fri, Jul 03, 2026 at 10:25:07AM +0800, Leon Hwang wrote:
> > (...)
> > 
> >>    The following architectures currently support this feature: x86-64, arm64,
> >> -  loongarch and s390.
> >> +  loongarch, riscv, and s390.
> > 
> > For per-architecture feature documentation we also have
> > Documentation/features/. Maybe move it there.
> 
> Better to replace with a reference to the feature doc?
> 
> +  Refer to :doc:`features/core/mseal_sys_mappings/arch-support` for the
> +  support status of each architecture.

It should automatically show up here:
https://www.kernel.org/doc/html/latest/admin-guide/features.html

See also Documentation/sphinx/kernel_feat.py

So I don't think an explicit link is necessary.
But the maintainers might disagree.
In my opinion the link should then go to the rendered table entry.


Thomas

