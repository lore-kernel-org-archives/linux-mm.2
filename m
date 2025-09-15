Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1A2CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 22:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98DAD8E0005; Mon, 15 Sep 2025 18:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93DEF8E0001; Mon, 15 Sep 2025 18:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805528E0005; Mon, 15 Sep 2025 18:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 689518E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:39:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12B5E1A078D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:39:14 +0000 (UTC)
X-FDA: 83892951828.11.C0082EF
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4CE2340006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:39:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=W8GTES4x;
	spf=pass (imf12.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757975952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Nh9YPajpzLkLNtov0lA1KMD/BkPyBkqgsXpZ3McHVM=;
	b=e+C3OttC6FAj8L1btJK8YDccNgnN2toVijTfbnDMJ8HhAEUPdEF24Ym+aTGwLYpjL6w/BN
	ohPBlMRrm9/g/A2SqAkVMQ1VdMFz2xk2mFOJg/NXXIXo1c6QNykST+kS3z5h9yB9LhKg3H
	9/Q7qieKDVW4woAJq/Dp79kJO+2ob1c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=W8GTES4x;
	spf=pass (imf12.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757975952; a=rsa-sha256;
	cv=none;
	b=DzBsL6rwbXl+jOCl8smFJqj9559YSw/99RBI3vPiMvo6Hx/2ZTlFh6VKpkSeCZRX6514Xd
	tXzGNHLAk93/LaQurHfK3JyC8CT4K8yzjcJ3CZunjkmVY5tQUpAZCTEd0JSPFvYgOCDF32
	DaS4rEDvecZomnLO244jIBFo4zK3KHA=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 74BCB40B03
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1757975950; bh=4Nh9YPajpzLkLNtov0lA1KMD/BkPyBkqgsXpZ3McHVM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=W8GTES4xWoBx2OrfPfrQJu3grT8gHU5iYD5t+TK2UoDH598lLADT30pTACZmhGNBK
	 GShI0VMfHp0OQIIYCBOI7lHYhdFP47VA+mjQ4j7Ew27oe5rWOqYyPW/cLmGaXcXghu
	 d9RUr918h66cM2CcVCTdv8NoqjzJSRPXs7zDy6rw0urFrrZioFw7yCNSvxqhUWlXp7
	 +Au/Ib+tYcIjZtYSC3URmsA1wWemVHTfoeW9cBs59RPuY84G712tfAsQYi4l72mi6/
	 jmGFOq2DNKOP1yGtIeDyVXECig2whGbJPtL0VHIHp1lx6ZL9cyhVewbCg7znloPx2J
	 Xp1QtPGoXjAJg==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 74BCB40B03;
	Mon, 15 Sep 2025 22:39:10 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Gabriele Paoloni <gpaoloni@redhat.com>, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, gregkh@linuxfoundation.org
Cc: linux-mm@kvack.org, safety-architecture@lists.elisa.tech,
 acarmina@redhat.com, kstewart@linuxfoundation.org, chuckwolber@gmail.com,
 Gabriele Paoloni <gpaoloni@redhat.com>
Subject: Re: [RFC v2 PATCH 2/3] /dev/mem: Add initial documentation of
 memory_open() and mem_fops
In-Reply-To: <20250910170000.6475-3-gpaoloni@redhat.com>
References: <20250910170000.6475-1-gpaoloni@redhat.com>
 <20250910170000.6475-3-gpaoloni@redhat.com>
Date: Mon, 15 Sep 2025 16:39:09 -0600
Message-ID: <874it3gx2q.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4CE2340006
X-Stat-Signature: khzoizc9h78mdmk77wkbt4xxmysy717y
X-HE-Tag: 1757975952-155796
X-HE-Meta: U2FsdGVkX1/y9vcrKyRZCnCNupoJKu5iVw524Tg824LHJ1frgUj1HTa0K6GfkyVDrY4YF5jwOoapOgpkbTB7dzRd1Hksq/9jZzLkKN/9EW3giN740dZaUo0iFT3nv7nIt/gIWucWs/xfLy9xjvn0rIG9QIFio/RXQ9MfB8um4yfiXze+RNrmxhO5Vj8u9rhtk2RzqVGYNwfzSI31SjCf46Wmz3mH1Qa8EZmx5+AZxBlN3tUzvvgWhxB0CyxG6gEn3nT2In8wDdQDhSPF8U+fyWxMqaK0PmE7JpbJugfikoycPyRd2DU4CUp0u5wVAFsdFxfAeicYyI0I4P4hwFtLRMXIBM6AMnMVEPP1zUgyTNs7uLn8ig9nH2/bpYCH1u4pP3X5+ANDQqT7GWMyC4/K6zWzVp4GqURBat0YcEkhx9diEi+QWlos+E/Xpf+ZCPht/ngzZIcmmZj7R1YgsrXLc/7eny+DhYou3n3IoE0hs88g4j1XNDi9oetZ59OKG+Njn6Ysf5rXThv08AbwdLDjz8MTxjRk/nRzS5ToMGGEFa90wJv45HB/UbMHLkSJUapFd/rCOJZLewLVdeHotI6M/jEefwhvo9+EoogHI2sf2ZejIyg0iPux4Cqo1eMtYTl2l6o43tWQrVSMehdv7fRnISq4SlViN4HHPy/cBtUF/wSMSLVl0hcjjqS1tXko/bL+dDIEjbsuxs//QJtB51VXJAjEa1EJJjBKhnO99BuIu4PMKftfbOPg9y3yBAN1XnWKEgq5iuWoCR6KxFUBbhznipdgiBDzLytdpN28EJv3LjNvupSN0nYVxV9G+zFPMe17K0Q0ZMRf0XvevBNtlonUnC3em2UsW96YiGNY8KJ/FZtaUVCoMFRLqrQxxEcdLrfrp1+wDDk9cT6gHdVu0PHvOeZKM9XE3g5yJ+9do2VhQqmonpPHz3nLSIW0RxeHt4xnhw1tEuDoioel6SbkPg6
 stfJ+xPm
 Bex33M+CKlyrVdb/zSAbrO1uayJo6x1O7OYz0D91GyDu3KKKZD7YLLbUG5cizZ3BFIYe1A0S947qx9/uYBSZ0weUZGBXKIQflNJAdSgoMnTAxSSvQd2bphKvebjqSi5izTFkD2AYRX8Qw3krTNEipxIOAB2Go7hldm8XDya6BnoNFky4dIRtQoT6YWhpJWl5LiZYC44E9q8SeN9fVMzYDFCV+cQJD2SkXRI4eWLNFyj7CodaWo4M0kdqiuk++gAxIr0GD2KjZgifsknNq7sKEJ0nmOk+nD3R6W8ui0mWtIrovLiYL8bKIb3KlKqSjkBBJsL2fB1RSh9ZTSiwu8ZMNfWFK23YcaODrLOWff2sCsv7H31o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gabriele Paoloni <gpaoloni@redhat.com> writes:

> This patch proposes initial kernel-doc documentation for memory_open()
> and most of the functions in the mem_fops structure.
> The format used for the specifications follows the guidelines
> defined in Documentation/doc-guide/code-specifications.rst

I'll repeat my obnoxious question from the first patch: what does that
buy for us?

> Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
> ---
>  drivers/char/mem.c | 231 +++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 225 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 48839958b0b1..e69c164e9465 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -75,9 +75,54 @@ static inline bool should_stop_iteration(void)
>  	return signal_pending(current);
>  }
>  
> -/*
> - * This funcion reads the *physical* memory. The f_pos points directly to the
> - * memory location.
> +/**
> + * read_mem - read from physical memory (/dev/mem).
> + * @file: struct file associated with /dev/mem.
> + * @buf: user-space buffer to copy data to.
> + * @count: number of bytes to read.
> + * @ppos: pointer to the current file position, representing the physical
> + *        address to read from.
> + *
> + * This function checks if the requested physical memory range is valid
> + * and accessible by the user, then it copies data to the input
> + * user-space buffer up to the requested number of bytes.
> + *
> + * Function's expectations:
> + *
> + * 1. This function shall check if the value pointed by ppos exceeds the
> + *    maximum addressable physical address;
> + *
> + * 2. This function shall check if the physical address range to be read
> + *    is valid (i.e. it falls within a memory block and if it can be mapped
> + *    to the kernel address space);
> + *
> + * 3. For each memory page falling in the requested physical range
> + *    [ppos, ppos + count - 1]:
> + *   3.1. this function shall check if user space access is allowed (if
> + *        config STRICT_DEVMEM is not set, access is always granted);
> + *
> + *   3.2. if access is allowed, the memory content from the page range falling
> + *        within the requested physical range shall be copied to the user space
> + *        buffer;
> + *
> + *   3.3. zeros shall be copied to the user space buffer (for the page range
> + *        falling within the requested physical range):
> + *     3.3.1. if access to the memory page is restricted or,
> + *     3.2.2. if the current page is page 0 on HW architectures where page 0 is
> + *            not mapped.
> + *
> + * 4. The file position '*ppos' shall be advanced by the number of bytes
> + *    successfully copied to user space (including zeros).

My kneejerk first reaction is: you are repeating the code of the
function in a different language.  If we are not convinced that the code
is correct, how can we be more confident that this set of specifications
is correct?  And again, what will consume this text?  How does going
through this effort get us to a better kernel?

Despite having been to a couple of your talks, I'm not fully
understanding how this comes together; people who haven't been to the
talks are not going to have an easier time getting the full picture.

Thanks,

jon

