Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2722DCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 23:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441878E0008; Mon, 15 Sep 2025 19:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4191D8E0001; Mon, 15 Sep 2025 19:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355CC8E0008; Mon, 15 Sep 2025 19:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 213E18E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:36:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE6A05B3C3
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:36:18 +0000 (UTC)
X-FDA: 83893095636.26.87AF7F2
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf17.hostedemail.com (Postfix) with ESMTP id 20B934000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:36:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757979377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QpQf908lLcUQfw0p4kIscUTLMHDoGdt3ueWZcpfVWAY=;
	b=oTuNiCAdaofnxYn+VwNx8uFg8SiG5g6uFJFmKivtzcUQ4bIH38ZxFLpHn7Kqms5GcCegXd
	7IZCBEPWh/ggMx6jJS0AmipxiNXDwhIrU5uLO0NoOdlxq3JjSXCnLLrxPypfbOpjXWXHPh
	9BuU7zhCc5u/fTX0aog7CZeBSRK3TSE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757979377; a=rsa-sha256;
	cv=none;
	b=xsXwQ5S7Oq4c1gSIN9zd3CXGNUG+br+2oSvEtatNEp8FX62E+lTo8cHLed4PIICR1D72Fu
	MzV2lJwy14J2tEoYgxK58tcpI1ADPgMB1dBmfSwQmYxfPVub4TLztx0WLUqE9CLsx101rt
	KMH933uiNaNnzHVUqRoMuz/7bdP2OgU=
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0318A1DF9D0;
	Mon, 15 Sep 2025 23:36:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id EF8FB17;
	Mon, 15 Sep 2025 23:36:13 +0000 (UTC)
Date: Mon, 15 Sep 2025 19:37:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-mm@kvack.org, Kees Cook
 <keescook@chromium.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro
 <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] uaccess: Comment that copy to/from inatomic requires
 page fault disabled
Message-ID: <20250915193716.5357b448@gandalf.local.home>
In-Reply-To: <20250915164313.42644914@pumpkin>
References: <20250910161820.247f526a@gandalf.local.home>
	<20250915164313.42644914@pumpkin>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18RfPw8aj/71xqwlywpNWAQzZY4z6xKu1g=
X-HE-Meta: U2FsdGVkX1/YJoZe9UBIgt61WeL/CIOcWy6Mxx2xXHClEjWsLi1jqg4Aq9gRdcvoWEhOJCDVGhrgnU7WIkhfw18LhHSrRIiYcEt0RrYgyMSSkb1bVZDaJYUd0VuDosC13lXdUBdR2c+wfWNfB5/SsauHh7NS8SEHG2lhAIzY3UrWpXOe/STds4w/GTcfqYnGICB8CF6fRfuLSZNimdC86U0oIoJ9vkn4QjqCRThosI5eJKEwCe0lMypVk/ZUa+oMwzUhGL2IPHZGaBfSrrXzTCSUXH7ma7SPQBnPvvs8Cyt22XkWbx93d9/1WufLv3BfbhMzqsuFPgAD63ehS+qr+0HzqXVOVxzJ
X-HE-Tag-Orig: 1757979373-771640
X-Rspamd-Queue-Id: 20B934000C
X-Rspamd-Server: rspam05
X-Stat-Signature: 33i6gkzu83bfzdnbgkz68sni8e167bsf
X-Rspam-User: 
X-HE-Tag: 1757979376-648853
X-HE-Meta: U2FsdGVkX1/KnFUfbxZPGcLlakHIS9Ta1xBP0dKTnr7i/+LRcu+CwY4HiGXfz3xPogusUM3m2hXwJk+yujDxNBjKYijGSPwGeXJAHUTwFM1RFWSdP5mZF1fH5vQFitpoDK4XG3f1YHWpyNVSB9o4fTKAppwn/4cLD0nTTM89lZx48XNR4/rS/9RbJfMH1MbfMeWu358jEDgtdU+/9+NaAWyhAVxGpTe2Dc/xW+yCpoFKtWderuIcweKT/B+YBJJlzLegheDzzsdPlem5QbmPcrAMamh9ao0UIPg7bpfy4xXX4zMAiwdhN85Y63+M0fLQ2BLkaOSud10pGTkMO90YMuy0FooTMZ2Q2hYNDont0gqDWVwUUC1N6xvtnwJTb2z8T99YA8clh3cy7fsvRR4KU9Xbj31LA3sxsEnDlJnxfU9ue43nnyXkVEELk1lG3oZs1bLdISoVRxSxFhq2NL7aH6tK+ZbC7t30KYcBkPMv2DqD1nkovmvY76MSuP6yU9WFyl3xBWBrax50qEKlinLvJYVHkW9AUzkI2CMdAd5GztAYCMlk9DsRWZhIwo/LspiNLg9OzPgtbiV1wK83zEzntZ3Jy56oyE5d5IvvQ1DT48Bxxg/Kh0Z7LqsOfQx8a5dvPyjxoCSxIr2Ajc9feZqoeaVtcWfj3auFBCA1i2Wo1yqdoyEny+E1iYx5vexvARdt7Xq5ga9zC6cOnGHOl+JQb/OzFrhsNz9Ma72czp5s+J/IJB7rWmJnnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 16:43:13 +0100
David Laight <david.laight.linux@gmail.com> wrote:

> > @@ -124,7 +130,8 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
> >   * Copy data from kernel space to user space.  Caller must check
> >   * the specified block with access_ok() before calling this function.
> >   * The caller should also make sure he pins the user space address
> > - * so that we don't result in page fault and sleep.
> > + * or call page_fault_disable() so that we don't result in a page fault
> > + * and sleep.  
> 
> It is worse than that - it must avoid a COW fault as well.
> I suspect the comment should really be that these are not the functions you
> are looking for, you probably want the 'nofault' variants.
> 
> Even if the code thinks it has pinned the user buffer it has to be better
> to use the 'nofault' variant.
> 
> The only exception might be in code that already has page faults disabled.
> But even then it would have to be pretty performance critical for normal code.

OK, perhaps just change the comments to state that this is an internal
version and should be avoided unless you know what you are doing. Otherwise
use the _nofault() versions.

-- Steve

