Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 770F3FD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69526B0088; Wed, 25 Feb 2026 22:15:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF936B0089; Wed, 25 Feb 2026 22:15:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C170A6B008A; Wed, 25 Feb 2026 22:15:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE7FC6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:15:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73E0D8C43A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:15:34 +0000 (UTC)
X-FDA: 84485142588.21.77658FB
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 816F340008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:15:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=RN0jfPgB;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.173 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772075732; a=rsa-sha256;
	cv=none;
	b=nKKNDL3RJLRjD5v9ezsDrXth9FfbIbKObjKOw8WPcFrEgD/XdDCvNgr/8Uyx9ywR4THZDs
	QcpAlhtPpakMUaMvSlOt5CVPTPIYfwf3/s1QZE+qBXWu/Kh8nf4wOa2Is4YhT4DmOE6Mef
	K8NDrex/uhenIlkXs7xO5GvJv+QHtWc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=RN0jfPgB;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.173 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772075732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myOpzKKufRrzTXzkKkTioHHnRh1Fxba9oHbsZ8bSehI=;
	b=p4Kt2WYkiMRKvRd1PDhSytjByzIYT0qbs2KNAg5zTgp0lmBEHgt4tP4lVRG8/vIRsnMsD6
	gawHJSIpkFNG7FzMcxdSAK14rjZmqyc0WMV2jU2Bi+QeJOLY92ClulQVTw34hvLJj2pNdT
	snFDxn5g36xaTSmDLew/YiTLlqZ0W5s=
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4638fe85a7eso160798b6e.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772075731; x=1772680531; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=myOpzKKufRrzTXzkKkTioHHnRh1Fxba9oHbsZ8bSehI=;
        b=RN0jfPgBsUYOsSjXTrgbcjtVgE8xgbZ5BblKXPTN6MrKSTM+tzdW0n/qRMqkvoG8tt
         2p0HNe6T11dHEQHc8UIId7mb8FOLwQZ8sp+AI6bhfl7HAe7SmhZr2hHxg3NcrhIP8Cw/
         vN7oW1OuBpeOZIOLZ37Cea6bRs6CP3AUUqJzxn3095zj+l93m75BBI3GZGnKziaLcenL
         I0eG3JOaTrApGUReNkywmWoK/xxtvOLQfqmkKodcyGRw1gdm7Q2uQRh4AoCf7g5eKEGU
         WFCMoIebbbasWbxVFKHAu+UgNz/O/DzWyJ1NpC+8ZU0oIxW3K7GdUd8qjvWUuH81Mutr
         /2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772075731; x=1772680531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=myOpzKKufRrzTXzkKkTioHHnRh1Fxba9oHbsZ8bSehI=;
        b=Crl62vQV8CvhpXAq1lv6mZ36zDj4OvCdGY+zIRKwfEj2G/dVtTvq0jlVWylY0EeRnX
         mu4y1zlZwo1vBJZ2ye14lDzJyYOOrZ7qgJQBale3mpAozq6SZEj11sNUZY/lBr5og61O
         G5AtBJstyQAUSDWRlrtDZYdsFxEB4VmOQj6WvxCFV9UUvBHWmQPZVv0e/TeH/lMCrFTA
         7bg4UVg6LPUj5wf+ILnVdjS4A9r0pjnJItRCoZAgXeV2XzGXzq2mX7CAepm0XzcTOlao
         24qQyNVOKp4x86Zf2Oc6kDZEW7RPQSPSeDMF9sr+SG/WD/saFZhSz6FWgeoc/y2HRkiy
         Zw0g==
X-Forwarded-Encrypted: i=1; AJvYcCXd8weV6NoSmV0NotZaqSutNIwH95Jpc7Uxy6bMSFm2TxLeLh0bacG4w7f8E5v7KXHucmac2AeqIQ==@kvack.org
X-Gm-Message-State: AOJu0YzYORv5qWq30RTT9k3LODKF0SJQnZn8bCO4vLWHfvgwL7HmoIsc
	hE2lES86/rfHo6EjKXw88Ja6S4aUTvpX7PPsLBIT5Wtx4/V9UD6URNWOWy2GtbwqpaI=
X-Gm-Gg: ATEYQzz7ioe7Wbksr/Fq35d7/eU/9RzKzOA8dr1EuJXJLWeIKpfdbKC0G9j/7dYqb/F
	AiBfDUDZiVqzcQvED35F9QxbhYz/5iVTFqJfLWsDLbdAXlZGe1OzajfD4X4qDXn9KwwsC/njkaU
	PrkIEeIki4cCS2Du1HK0Ljeh/YwWGvJ76IA7Vb6rOmGBABy3/zpXB+99361Lshn6kPs7LQweQ6Y
	rmStUBQExxAJDW6wZ5t56Sd8Y2x7SaYTIapRl3l/Puft2OFoLeJisj2A1B6YRATxVPlaXWEu81T
	LS4r92HXa9pyFPvcK6U9eUkYrC0nYAogCBHQHBDZBCEB52UBH7d8EGgRz/g1v9zrYnObb83jnKe
	OduLxBOAGD8m8CD3gib3zXDrrZGk09QGM0/6WacbNkK27ZUo5j80Eyb8LB2soFzxsUKfn+R84Os
	TmeWyqGT7SgSq9sziIcZ4IXY8TncXfpzx3OFY1bpzb0stCBy4od/laWJsZPMjex85hbsnCFi/Ls
	//1OnIb9Q==
X-Received: by 2002:a05:6808:320b:b0:462:d9a2:84e1 with SMTP id 5614622812f47-464463ef61fmr8794809b6e.60.1772075731397;
        Wed, 25 Feb 2026 19:15:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cf9b240sm786090fac.8.2026.02.25.19.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 19:15:30 -0800 (PST)
Message-ID: <44e3e9ea-350b-4357-ba50-726e506feab5@kernel.dk>
Date: Wed, 25 Feb 2026 20:15:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 1/2] filemap: defer dropbehind invalidation from
 IRQ context
To: Matthew Wilcox <willy@infradead.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Bob Copeland <me@bobcopeland.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-karma-devel@lists.sourceforge.net, linux-mm@kvack.org,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
 <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
 <aZ-2G_6lDZePLSyx@casper.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aZ-2G_6lDZePLSyx@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cjfarmu37itsumiuhuqpme33b8zrkp1s
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 816F340008
X-HE-Tag: 1772075732-644925
X-HE-Meta: U2FsdGVkX18YsPWd+IjCBgjk9WJJqFfSOuJDMT2ghMfkIFtf6m40aiRvC+wTmhrs00j0VD1NCmVvuQSGuWTj0YHar31DswUjN1tilUTpXEahE9b+arEye8+qV0JwdSOObmHfeQOh3ciM8hkKNde8iTGM7LgEk0qjkx6IWyQxjpwzs66UO1xssHMV9YdJVV/3gYRERh03yeKqQC0M1aRAiix0fSvCSGmCevNwjzP8mJvkOu0oejSTWPSX6fxju0GaTWXeI81NFKjznfQLT2bMGDFFLXcQ8974vxCLIgoMqLSzkIUdJsp0HEGLOHhQ36+yZfn5TsgHYco0PbNp62pEu1uJE9hWP+l2z2SFtwKA7zmJGO7BIg4Odj6zmJeGLSywgNY755YfJdW3ZRomxBe298KcCIwF7wWcJUBSjL9rrD7c+enM3+ZDv0AdbfgvBA3D4jRBnBi8gMtNALP1XKfjdzmzOgnhHWTDIsz2Q9vmO7hHuHh/+yDYa86sAlKnKe0IE0dwD9QPlf54SsK4y16R7bFvVGQTYJKzrvuJU1xjcmoZWwF9tqRpR6GXWCiGxpopRH75KwgT+/U2PsiyC3Wa6XLaut/sZcNjQR/vmSMKQMw7eT9UpLHcvubkjWcOJB0kjdwpELSu8KqlLP/6pNgcr3mh7n38Ctls+vWxJoSV84Bu11knb4PkKUlbV3b5qqFmjT/pd2cGR1PgBV9Wd6QRmkTPJb5UwL5A1b2+kpeEU8xzOKte9HsluUHallMM5Re7sD4pc9T4jMvL+H/XJJNt4LPcbT8WUjlJukl+8okO6+cIGGlKSoMMh3gEPwDgGdfmD+DQqC+9XGFu772YPGBQo4Twbx4W5qn8sl0FIKh8si9e1c9dtJTaCRP58h0uZUt9RtHz/bnvNLwbbKMLl2W75rQmONY4PLPY3TJ4+F5dnCYKfZ48TlvTW6JyXmBndi/BmBK6Z1DGxP8tkpamnvG
 4D38ObNh
 3vM4OZq38n4CkjOgxlwcBhcQo3CpL+PYupC0F2Y/R10Kub5HmcP8mW2IIn8My7ozreSDWsXNWNfbxS/ziiZuXIspdltR0Ib/Wbj3sk/zQ2sFu3v4Gp3jhHK1jQgA2XEqzgajtz9W0mOekXmita2lIZItxsBYE1UujPrr/v1NS51Q+9cu3sZiDQTjjntbtTsctVahSvWukjpgkA+bE0+fjgea6yrAg+77O5bjZ6le7j30XsnYCM8CU6rL4HiMTFLv/u1EXQ70H9Ar1MdgxqS2FiKROzxGZTfjMaUfM7h7PDPx4ZLk03vn4ODQ/QEQrpT8AKXNMRNFThbdUAHVnKEzDn4VTcJj3EbbrxvPKrcQ+i5tILG3QrX/78sxVMYcVytAoOtLbTgSuWsIht50Qk7PLfSthjccDyHD98fq9DJWaXq5+3he9mYUu+Wz+kJkXxXyY0Z4xqBJGAz5sGRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 7:55 PM, Matthew Wilcox wrote:
> On Wed, Feb 25, 2026 at 03:52:41PM -0700, Jens Axboe wrote:
>> How well does this scale? I did a patch basically the same as this, but
>> not using a folio batch though. But the main sticking point was
>> dropbehind_lock contention, to the point where I left it alone and
>> thought "ok maybe we just do this when we're done with the awful
>> buffer_head stuff". What happens if you have N threads doing IO at the
>> same time to N block devices? I suspect it'll look absolutely terrible,
>> as each thread will be banging on that dropbehind_lock.
>>
>> One solution could potentially be to use per-cpu lists for this. If you
>> have N threads working on separate block devices, they will tend to be
>> sticky to their CPU anyway.
> 
> Back in 2021, I had Vishal look at switching the page cache from using
> hardirq-disabling locks to softirq-disabling locks [1].  Some of the
> feedback (which doesn't seem to be entirely findable on the lists ...)
> was that we'd be better off punting writeback completion from interrupt
> context to task context and going from spin_lock_irq() to spin_lock()
> rather than going to spin_lock_bh().
> 
> I recently saw something (possibly XFS?) promoting this idea again.
> And now there's this.  Perhaps the time has come to process all
> write-completions in task context, rather than everyone coming up with
> their own workqueues to solve their little piece of the problem?

Perhaps, even though the punting tends to suck... One idea I toyed with
but had to abandon due to fs freezeing was letting callers that process
completions in task context anyway just do the necessary work at that
time. There's literally nothing worse than having part of a completion
happen in IRQ, then punt parts of that to a worker, and need to wait for
the worker to finish whatever it needs to do - only to then wake the
target task. We can trivially do this in io_uring, as the actual
completion is posted from the task itself anyway. We just need to have
the task do the bottom half of the completion as well, rather than some
unrelated kthread worker.

I'd be worried a generic solution would be the worst of all worlds, as
it prevents optimizations that happen in eg iomap and other spots, where
only completions that absolutely need to happen in task context get
punted. There's a big difference between handling a completion inline vs
needing a round-trip to some worker to do it.

-- 
Jens Axboe

