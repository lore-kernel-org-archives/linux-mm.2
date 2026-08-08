Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D74D9C55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 16:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848B96B00C6; Sat,  8 Aug 2026 12:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB116B00C7; Sat,  8 Aug 2026 12:53:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70FA76B00C8; Sat,  8 Aug 2026 12:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1A26B00C6
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 12:53:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 996CF140408
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 16:53:51 +0000 (UTC)
X-FDA: 85078699062.25.0C3CABD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id BF7ABA0008
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 16:53:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TOCoY9zj;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786208029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ax9y1xfFH3chaxJ3oaEZM1cwYboqVTK0vjI4kxFoY/w=;
	b=fVyQLGVUGQBwgMdMFRO3cmK3iM8Lq743Q0i4rUqOAHOqA/r6rkztxuMMEkvy1BK0D4AhBz
	EUlwz+swCvRK5Y/CisGyuQ2opsPCam7y65Hm7xZQ+OEt3hMTItcHJS6O4QeYlLzSCNktD2
	A6yIpyek0jsoCFoX3JLXS1XQYkzgke4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TOCoY9zj;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786208029;
	b=p31mdeUgd/p07bOdyyvcbs9tygxOAIJVHQ21vqenYg5a4BFAik7IHqFnKb5lN43QvZH2Bl
	w20aXy/W79X+Qj9LPy6tsP9VfDFz/xz0F04IwvqJkvYXC6iildXwmxFdup/QdFJtpbSsRr
	yxOjhAPhkpBdSOmJAJibiNCs4x5bVIU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5101402C2;
	Sat,  8 Aug 2026 16:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CA01F000E9;
	Sat,  8 Aug 2026 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786208028;
	bh=Ax9y1xfFH3chaxJ3oaEZM1cwYboqVTK0vjI4kxFoY/w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TOCoY9zjFfXkLgyDmi66obQzYFxAcWbQFoGdPmRWiDqW3K9Uod304Z0AuSwCz8zFY
	 jnBfK+vzR6CYIXRaqDtfqt0uWSB39jpA7C5a8+WGZN30dnWG1pdY0ghByl6GVRJYBr
	 LUP+dzlKMd7iWUtO02S92Hn+UPZKtAGOKQFwflx4=
Date: Sat, 8 Aug 2026 09:53:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Su <sh_def@163.com>
Cc: andreyknvl@gmail.com, dvyukov@google.com, glider@google.com,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, qiang1.zhang@intel.com, ryabinin.a.a@gmail.com,
 stable@vger.kernel.org, vincenzo.frascino@arm.com
Subject: Re: [PATCH v2] kasan: fix cache shrink race with CPU hotplug
Message-Id: <20260808095347.d9335a79ea6513d613784d48@linux-foundation.org>
In-Reply-To: <20260808093803.3138988-3-sh_def@163.com>
References: <20260808003921.fdb0df9ee4417b38f15e8c68@linux-foundation.org>
	<20260808093803.3138988-3-sh_def@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BF7ABA0008
X-Stat-Signature: mzze84mpiq5sf6m6no89rciqz935jo9r
X-Rspam-User: 
X-HE-Tag: 1786208029-863724
X-HE-Meta: U2FsdGVkX19PK9Siu/k2iG9Mam6+odaGYaajBuR6e2LM7LqBtbb62vrnv0YziXUMndc7DjllneVyR3NNGvpbaqEyTHtBet4rd6GLGYivKZ9TgUIVGRsaoz4Fa+YvxZzsqG8S1QTv7tJAT5fVO4wAMZrugoq5oIokVWBHu1gF1wU9he+FUnYyvxi+2YnAKaLESd4FbLQSNEeLgTuKfCgcG1klpjAAGqy6iyk0X4744NTgVDx61lqgUWy3nHvODp8BdJtIuxYWK2QUsl3RelR0aw2o884VeTtEWvfgx5NQgUYbwswixzl4D7f5xl+dq7Dpr5/7LS701OpFMGgoX+TIcbErJOE9srEGQMwalM0yR3Y7MWZDeXxGrOLhrlQophaXERIYlSSPS9SZ49zo+XLcHAdS+kPyrae5ZgCl9kaAb9ZjsLyFyMihNDS7M0xT3VO0eEW3Cs1PByPcAtKHFVR/LHB2FUfYREKvzvildRvIg6YgX9nX9O4zI/goRbAmp0CVhQwraKxZduAOmROIqXJvmkefBXE7BDiI/wmMYakBYBkxsEDc/tbYIVIf33QL9l8ODrNmxMS85x1rYOjKoL/wwfj78hJeXCWiUtglhVFBAdITxtJTGrTyySjvkiVnHGAObNisPVzBsLcnthLyItZdwOBf58dc3/cB6DlyxB0DzXhSZZO97BeT3q0omlmnbExCxfvZ8aiYcffjU4zBroxLfoMVS4VZfwTJAU2ugCgUKoXlSUbd+Z0cL0mPMvr/Ua6CI99tBIk+JSjOaY+iWCZxMzki/z8dGB+VcoXd7WuZ4cBQ4r/xMyieYADwvq+0kWWOTfDZf9UqeoR2WN0ORPac4+Zndq8pR1m1hT/WGBwmOrMdpwyhMOOjKhmK3NdhR6U/YY2aeqSIFMsk4VFsceYrK63wFllZdzf1ixgfNSLqBtg6P/TgdS5/nGXdB07zUrWk9/8iltcM1Jb96Yc6gbx
 QxnenpNg
 SdEXnnMcycWq7Kw/AcqIxgikbnOaj1o9Hgjb8oBR3rIklGK3wQx0KGOt1GpVyRI7TwzB9ttahJdsPtojc7FWKfKATAae0/Q3s1axssxDQHv4z9sKKD1JeCgDBWqDMLCY7NHXVmb5onCRBqoeuTsJcgEqbq3/FeQG0zPaqI3VYPFRNpokSpqPmesu5HXiYlZyXnBCXkHlcVktPvEVw+jgc2K4BzVBlS8DqTXH1upxsxaww8jt4iUDaF6rl6F19a0SsC9dESacW8DM8IlHWeM4fUea5G57tMDx9jS1Si0ajAmo8r1CvghniK9gMcviKOkj7Zh0d1ZwwKU8KqQfWSKOnUH00YfpF1mDEsMSSABHJdmqCNzNLsYsG2uwW2x1KInJyfq5tDY70bFOg/J1CqXQS13BF8DOo3MXsr/qd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  8 Aug 2026 17:38:05 +0800 Hui Su <sh_def@163.com> wrote:

> Thanks Andrew,
> 
> On Sat, Aug 08, 2026 at 12:39:21AM -0700, Andrew Morton wrote:
> > AI review suggests that there's a pre-existing quarantine_size
> > accounting flaw later in this function:
> >
> > 	https://sashiko.dev/#/patchset/20260808031459.3032812-1-sh_def@163.com
> >
> > If true, I'm surprised this hasn't yet been reported.
> 
> I'll take a closer look at this. If it turns out to be a real issue,
> I'll send a separate patch since it's pre-existing and unrelated to the
> hotplug race fix.
> 
> > Also, I'd like to see a need_resched() wrapping that expensive
> >
> > 		/* Scanning whole quarantine can take a while. */
> > 		raw_spin_unlock_irqrestore(&quarantine_lock, flags);
> > 		cond_resched();
> > 		raw_spin_lock_irqsave(&quarantine_lock, flags);
> 
> Good point, that makes sense. Would you prefer that I fold this into a
> v3 of this patch, or send it as a separate follow-up patch?

Separate patches, please.  One patch per concept.

