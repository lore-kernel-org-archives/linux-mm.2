Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B474E9B250
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3776B0092; Tue, 24 Feb 2026 06:42:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA706B0095; Tue, 24 Feb 2026 06:42:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6C16B0098; Tue, 24 Feb 2026 06:42:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6B96B0092
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:42:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BAB716051E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:42:17 +0000 (UTC)
X-FDA: 84479161914.21.AE025BC
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0A1672000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:42:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771933335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=26gYGuAJYcAAlquvigL/6xJxFpG3LvAlHHfkNcRKEJk=;
	b=T4h71N5sTeMopUs8+SWwnVKvuAn3sHrZaB+JIqy94uLapX3on6NI9QtSfS0gu1rRTiheVE
	JQx07WSiQnZlLbOGZSKPG0ETeoGEjJBl7sxAs6tG1mJpXXsqkENuFHqQJPN7kLyzV/UvGg
	DF2am39BzdZnrxkJNmPbBEuPRmDDWCg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771933335; a=rsa-sha256;
	cv=none;
	b=7UgWMRyosZ1fPjNeDEmkS40785Qn8xFGWQjYa6qczYNQu99rNS+9I2b4n97LJN2hnIFzBL
	YEu1WrIQ7Q7UW2jI/XiquFOmlwwUFmCKv6FriGM6nM+ve/h/yZ5MQ/CsA8mqe6hapMGLn6
	ZO11+yUNvRQGOZdquL+sqNwwoDFkUU4=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 24 Feb 2026 20:42:06 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 24 Feb 2026 20:42:06 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Carsten Grohmann <mail@carstengrohmann.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	linux-kernel@vger.kernel.org,
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>,
	taejoon.song@lge.com,
	"hyungjun.cho@lge.com Carsten Grohmann" <carstengrohmann@gmx.de>,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mm, swap: speed up hibernation allocation and
 writeout
Message-ID: <aZ2Ojp5aSREwIaFB@yjaykim-PowerEdge-T330>
References: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
 <20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com>
 <aZ1X1OwbAUq1k+C6@yjaykim-PowerEdge-T330>
 <CAMgjq7BeA4cr5DSjpdaTVRRmcb_Pq+68yGZiiDg21fNPfGUQNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7BeA4cr5DSjpdaTVRRmcb_Pq+68yGZiiDg21fNPfGUQNg@mail.gmail.com>
X-Stat-Signature: xurak5rbnjt1xur3imtnapmhrcr38mjc
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A1672000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1771933331-796313
X-HE-Meta: U2FsdGVkX1/qNeS6Sa89Me3hrZwkBd2+An5fv1H+svbNaGQBh4MW8OLrmk86ddJD5TzP9uGvCp/xxRe963XBct8cFyG/bLij1vD53clVSTUs2M7vLgVpOtmEKYo6Itorn01PM6h2oyo9gIKY7l45FFWERfsuXOKi1Y99ANZ5RAJ4YlNKtHC/DwvTmuH+VM0mIy/DyUuejw3UV0w90Qppjlcnk5WSjwJVJSAgqmRoL5dPs9BOTIS1dzkhQ44cgDTqJvJoBT0Wg6PQxDP4sdzlCBtSOEf7ytUhpcBLcuRhlon65f956QDlTOEinLo9GeJZ7ldiBSs4hdyeYAnf4nJuPjEnO966QIIxBKxDt0+Hlg1VmoCZzzfEGdyvrWNwpbdlqsav0w3NKTIy8GyyRrg/y+EHq/LfHgZYKpy8rHOmAAKPfvvVSxMAD4QmX3hHw8tjsiElfkse3SYd+E9HiV55VqwafRngHGMyCvuXX/tUUjTzJjVXSQ+fhcf8iFv8Z7Sm/k++SkyAY0Z2g3PPX5pODIj+HE+7II/r9uin28oM1vheX9ScwnkTlNQ/eUSOT8aIlzCDvJzIEp9J2qW0HnRh563hh9zD/aWQtGHEYGi89bGYD9PApP3XPZKX+DVJhJftNPC6fpDEqzSfUg+4ewxNxeaGuAG00Ra5W6qInLPhiBEa0VOaI7cp9LUGfIsiX07zGbE0TEVqWZMx954eO8IsKwirJaH1YUc88gOTC8/XuU4W6sRZaisZTCaReAKUbY/l9mQ6z71Bpp78YkDiiDzRjs0ANxHMXeBOppeb94736rrNTtYqD8EiZHHIPcHaxfUfyUIjizGhATnUASz0N6Cd7FKuOqmvpA7LBDarMdkJaEAENooMVS4UlnYdByNHLNPK1mJVaZd1jBgBr0GsDCbCZHmChHBnfXQB6fAF49fFMZLcCRYoAL3E/9rnU9LK/eSG9Cn0K5/QghMNlOLqMo9
 I2fiuNBq
 iMxi11st58z0Vji99VNdCEJ0j2VlbpoVSxP19Uy8Dz4bW2B9hWdetFjolFdEoGpztXn1IRdLH1cROXXHXAoxD9vOmtHJ1VCuA698v9q/KUgtNuDEcrtSPj7B/+m+UmFzRgAmTWiXvvWJryzQt/w3LMrUIaVm1ADFqklhw3E3BtowAO00nC91kY2VQ0BD6OS2iDJU8DMmzTAa2c+eMlelxxPr8AAUVUI0ElJF6jOsCxizEH5UJG6BghWrYxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the quick feedback :)

> Yes, that's definitely doable, but requires the hibernation side
> to change how it uses the API, which could be a long term
> workitem.

I can't claim to know the hibernation code inside out either,
but I think the picture would come together if we grab the
reference at find_first_swap / swap_type_of and just set the
put at the right place.

Let me look into this a bit more and bring it up if it turns
out to be worthwhile.

> I think you got this part wrong here. We need the lock because
> it will call this_cpu_xxx operations later. And GFP_KERNEL
> doesn't assume a lock locked context. Instead it needs to
> release the lock for a sleep alloc if the ATOMIC alloc fails,
> and that could happen here.

Ah right, sorry for the confusing wording. What I meant was
exactly what you described — the locks need to be released for
the GFP_KERNEL allocation, and the current code assumes the
local lock is always held at that point.

> But I agree we can definitely simplify this with some
> abstraction or wrapper.

What comes to mind right away is hoisting the alloc table
routine and distinguishing the path via the folio param. I'll
think about how to make it a clean design and propose a patch
if it makes sense :)

> I'm not sure how much code change it will involve and is it
> worth it.
>
> Hibernation is supposed to stop every process, so concurrent
> memory

I was thinking it might be possible with the ioctl-based
uswsusp path, but as you said, it probably wouldn't give us
a meaningful benefit.

> Definitely! I have a patch that introduced a hibernation /
> exclusive type in the swap table. Remember the is_countable
> macro you commented about previously? That's reserved for this.
> For hibernation type, it's not countable (exclusive to
> hibernation, maybe I need a better name though) so readahead or
> any accidental IO will always skip it. By then this ugly
> try_to_reclaim will be gone.

Nice!

> > Thanks for your work!
>
> And thanks for your review :)

Thanks 
Youngjun Park

