Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A564CC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC11C6B0099; Fri, 28 Aug 2026 10:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A997F6B009B; Fri, 28 Aug 2026 10:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AED66B009D; Fri, 28 Aug 2026 10:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 750FE6B0099
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:35:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0238FA3D36
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:35:52 +0000 (UTC)
X-FDA: 85150927386.09.05C5634
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 970A2140005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:35:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="j/13ETx4";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787927751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ckaGVw74rY49wuwKahOscpW27wYJycDGKErZJGjW1ng=;
	b=heWJ0XLM3IXaDKwlq8bsZr2zHUI/X4ty+HUkLzUrEDYfvybeikeG909aMbRna2nuDLlkJ0
	lQRPusgifTNKHsFwa591j8R9knhulxdo8/HFLC/onssBqcRmR6d0sUkymlnXwPY6rbW/qA
	qC+yp3bUvWQKyAkCzw2f3rhXXSWn3/8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="j/13ETx4";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787927751;
	b=t143t4RxaIHfN01yqp0UksGUF/KiPDiTberNIy/7EDqu1XbQpM2+eTgPWEUel+8GyJwR0T
	WQ48+JQxsHuPNXY6lOdSxEZ89zMHqtXVfdOndRMSOdJbmgJZQP48Cs5Z+WdxJ6Z3LnwLV5
	LKBzbF5rJ0/G/SPhmkZfBCUwksC/RLo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ckaGVw74rY49wuwKahOscpW27wYJycDGKErZJGjW1ng=; b=j/13ETx4G/dFNQw+O8eobyyQgc
	vb65HchRPDcYLjcyC/fkNRFPF7qas14vbb7S1GpoV2I2Af6KgW93+TAewKnJQ9jPgtqk2OZ4eDYpF
	0eGT9oIxEXXxMOGJnz+Zvxpz77VhnwgFGBfGc5FM67FuzGeN+I5Mafj28D5LTj5F8G/dZkV4yJK4+
	g/PyiaahSQ3iyujx49bRLJZiZUJ+yXgaIlR0W2Rw3AYelbw6TU3UACtgxtALW4lUBvYYMD2rKLFE7
	q1zfp3Kbtkb7ki2dRGweNoxO9hxDIgG19FTnmrcPYemQ1XaAxnkT1xTxBpc0pWM6eJJY7vgg4Z1ww
	by1BAlOw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wzxgE-00000008KRq-2kIR;
	Fri, 28 Aug 2026 14:35:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id AC76130030F; Fri, 28 Aug 2026 16:35:40 +0200 (CEST)
Date: Fri, 28 Aug 2026 16:35:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Stevens <stevensd@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev,
	jstultz@google.com
Subject: Re: [RFC 00/10] Reclaimable kernel stacks
Message-ID: <20260828143540.GV776954@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260828124758.GP687043@noisy.programming.kicks-ass.net>
 <20260828103328.633bbfbc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828103328.633bbfbc@gandalf.local.home>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: eg6xwra1pgofpsjo1ht9h9kmd98udtnu
X-Rspamd-Queue-Id: 970A2140005
X-HE-Tag: 1787927750-731219
X-HE-Meta: U2FsdGVkX1/wS6WLVY2C3z3y3ocCGgD7JH9oXj41jqaOYEsyG+uETqY+uQMUZdHcezmHMSmR65FeiTTz6rDhPKn+yib5BDh0RA9V2np4QrYk/yUDfm6GOXsdxg+h06WAL9YT7Eok5dgJqTWS/29RdcuUkiK+6VRHYMQAog4ZHRXd7D8Q7iq8qQRKoRIG2RIk25Pdolbu1VicmibCorfd+/TU6yMae9evIFUNFC9tKaEiEQR7c6n8Kdjgo4h9dRmFgAZcbs6iSi1V4PokGXKExKV52RLnKq80X3ObgvI3IMxQH2GDUhYX28IrfbSCbhu7Os53XZE5L7uhOdDnCnTl+eJl7a6eloouskDrf23IA71JpVGH5Awa5PNK2HhgvhK+A2fmhWdX2jXE9JehRgmr9NXS12jl6XBORkosKoBX2c6lz/AkScN4iKfTxl6LtuZ1Kjdoa/yLb77o6B9gIVS+bSRFMrf6ow9cnm5jV1+uvC724v4Mb6q8x153Gh63kAf7Ts60ImNHUK297j8dlCrQq6n2rTMhR++Q0w1tSc4bItJsXPxDaTfDpjpiqo97dW1yZxZac2MUozhBEG+TQHmM38P1AWoh+hWGM3ey5ulmVuC6udytb9FFUgpaNz/W88xEAerHE2PegBWjGCnz4Y7Iax5unq2cjlncegByDzJnV7QAWzRx6Qvb/jZsRA5SZx64roVTHov+WZH4e2vC7zI9LD2qwqC6wtkdwZuZieGqVgad33yZVasjsG98NDA5PR2l22+EVsbgIKOs3bU2/liEwDRuBM69ddPvh3w93cJBNvN/9Qui5JmUjMe4znZb8vrAn6w00BQSfklasn1TE7zLGSTDIjBHpBMJEZ8PzW/GAMK9HIc73AlVk+TyDxnB+y8xvkgkJ4NzcYER2Exzx6NBt5ysUnov2jChXAVO+dEBjrKYyN78JdcHVSRM7FSynDsyR+fmh0QEnsnQXq1sNzh
 MxfeFFwx
 WipA7tROnxUOHRj7OTxwq7cPb52Eg4zspp826STQs1G6VeG1AcV4gu+vEgmxdHBkU69cIm0MCIyxh2G0Q5WA4pdFCz7C01KS3tY3ZfVVnJTdLPEssJybZUZaiOG+/E6OABShpAvQg1SbNRZJhJELH/5l91Ju8IV7+BqI6E4dKOazhpqlo0ljsfMyBboQ2NgsrvqMI3ZUwUREXmPbs9AKREl+SBAatU4YjOUWtFSHUjZBS72raMFD/7vTESY+1FqOCQ0lmX77GaX1vYfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 10:33:28AM -0400, Steven Rostedt wrote:
> On Fri, 28 Aug 2026 14:47:58 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > On Android, system processes typically have 2000-3000 threads. App
> > > processes add 1000s more threads on top of this.  
> > 
> > WTF ?!? Why does that all spawn *that* many threads? Perhaps work on
> > reducing that some?
> 
> I guess you never ran Java ;-)

Of course not; why would you want to do something that silly ;-)

