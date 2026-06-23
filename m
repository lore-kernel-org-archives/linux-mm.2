Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4408CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70096B008C; Tue, 23 Jun 2026 05:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20F36B0092; Tue, 23 Jun 2026 05:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90FD36B0093; Tue, 23 Jun 2026 05:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1A16B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:42:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0F90C1E62
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:42:46 +0000 (UTC)
X-FDA: 84910687932.27.E16C03D
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id EEF3B4000C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:42:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o9SCywv0;
	spf=pass (imf12.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782207765;
	b=QfrJiyHtXkW/9B3jvKjRZD5gn4Am7+lw4vcDNya8O+nzU3WHz42WEfUSFgB6MmzS5sFj3H
	CHLHxiHdWp0KCDbWl+aZulOcMPMF/VNl+HO5jPOB38/jpBRtV50QKaje5+qU1fP0hz3EBn
	VwHmclpBuiQA35hjIbN4rUVrNTIYS1M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782207765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3SJWx7Zgz0Pyhs4JZwrYmJyYWWMlxydwzpM41quzKVA=;
	b=2ZJj7pICgIFv4MnRPtXScb9cU5XT6MWcm1jDi7WDhyvm3qNBwXt2BSjncxgyIJ0YlxpWVQ
	Qxs2rFlHob5x1CxhLPtNRSOKkKNCkleN1+9zZc92fgZO6+79j1ReDvFZE4giDou1vIfVew
	oCMoGf15LWBelBGBv1ZknMNPykoMLvg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o9SCywv0;
	spf=pass (imf12.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so42386955e9.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782207763; x=1782812563; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SJWx7Zgz0Pyhs4JZwrYmJyYWWMlxydwzpM41quzKVA=;
        b=o9SCywv0u2LnuynAWeYPADFevajADRDCe2enNbcp0jRaxsEyxSGik6QEV7pPWJzMa1
         9mQ9tsmSoUgyrbFf3yhRYfp4pBfTq/Sz6Dl8oYYaYebFvWEsAVS0aDZ5p/8ST0XzFb0D
         4sfwASyNRGvZ5ePP25ruwRrzyY2ChFVynMcNg2lpWJfZ7nTxuGtfwSzNG2GbROjqvInt
         DDrx1EW7EaVMxIjCVM1ciGoxfrp8Xolo8IKsiOKlZ2Y788j0Cha4lM6Zx7mk4xIUbWcD
         bRw0N4jzXm2TNOXsKCRoAZc8wcBv5HGOOnLJJIHlhuuqT2+pHVVa9GVr3ByGerZKwjT3
         0bvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782207763; x=1782812563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3SJWx7Zgz0Pyhs4JZwrYmJyYWWMlxydwzpM41quzKVA=;
        b=frwUkofDxSjqS1YjWU9Hv1pwH+LSSQHhIJTOJvhcHgYlbzUTyKPM+6zcWoWnT+aiis
         FG0/NKSW7moRpF8OhQn+bMFLL4XoXnCZ3wGTjkohNcg//oN2S6Dfii0g/VOBuAfBCOV6
         S2gA2PD5Zeg7+vHHO57UFUY3Sm8eZvj1N8Qz/bWyW/ZndRUO6ZfSbwBxjztMYm2DgTbT
         U2JhdSw+oO03Boi4hFTUOQzSF/0RwL3jzvGwuhizjCYgGpQxXh3M1LG/XJtCndJlhgf5
         buKdZ0mxx1IYq4+SHLJk3esGzfpX88uWaJ1XbvDOVbhhPWVvfnM06nkDc+UXwPfCwrUK
         3ntw==
X-Forwarded-Encrypted: i=1; AFNElJ9/ibAKLCr8/yt6tU7hjLmeKY3Zgy1vBg3LFh357nVwSQK9jYLStdQn83TQCLXKFaOG/k2AIM5Q9Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2Z2CZSGMZwUjp5GUdFYBqRiJGtxwaHdnuBGhYxChEUDh7D1/Y
	YTzsUq8xwvaJjcZjILGIClOh36xb3B2l+dAvDadxsmEUiNl/RocMCu5iOv5uWDDC
X-Gm-Gg: AfdE7cmlWtJY8aMP0r75lvlL7b+No9+519o3Mc7vKZtLS4bzqqonifDKaW/5G2aQBjY
	0KsMSje2yVcSutkovFqjmVg2CxGqwDI3/i9HY/E/MsgIownvxpTPKFdhbJPfg3xTGvkT5g9EjIK
	Rqt0gh+2gmBAEQWyA6u8HTS4SbioFEk6Li7Mr0JW1wcX3WeQkQGq3svdG47dLtQofiKRG9iuoq0
	CKUWhZSPyfd8pmYOAnAwYBD5Us21BwbpcCp2DRTckxt2QOqegliYUuyEEiIQTjMsX6V0DDAlKsJ
	Lq5Curg8RHY6wJwUYUXHRCFKGw91d0B6JmZvog/QetxJ2rCArlhDwzgqsjsYJ7G6ROWKMhB0Tzq
	RLp2nbOpWEzVUbOzB6iPtRGq2xBc7f1wfZEL4FATvdRn6ztQOfoYgsN+NGVb+YlL1bsbyP1fynj
	g++XuAEqCU
X-Received: by 2002:a05:600c:8b8a:b0:492:2e48:81e6 with SMTP id 5b1f17b1804b1-4925b389b83mr30093645e9.4.1782207762970;
        Tue, 23 Jun 2026 02:42:42 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49249455302sm280248525e9.15.2026.06.23.02.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 02:42:42 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: avagin@gmail.com
Cc: akpm@linux-foundation.org,
	alexander@mihalicyn.com,
	axboe@kernel.dk,
	bernd@bsbernd.com,
	brauner@kernel.org,
	criu@lists.linux.dev,
	david@kernel.org,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	val@packett.cool,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Tue, 23 Jun 2026 12:42:11 +0300
Message-ID: <20260623094211.1080873-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANaxB-xVCP5HSUNwphFrKPdW0Qh1pA33A6npac60WArkZMFt7w@mail.gmail.com>
References: <CANaxB-xVCP5HSUNwphFrKPdW0Qh1pA33A6npac60WArkZMFt7w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EEF3B4000C
X-Stat-Signature: q7nm4kt9k6ibe5i6z3hp5pzyhjizemwh
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782207764-166939
X-HE-Meta: U2FsdGVkX19pDLVgNQNS20gdCZOx91wkDVSBddxOLfdScdSJ6fwnE5MUiqOa0GR6ra8TE7aSWiC2z6rJspadBH8cH6n4/Teb9G+W8pXX1K5W0lVfEBdFSa8UcOMJNSEsMn1NObSO69Y9u9TIvjwpAC0MGCrP4uPDmCrwxhmhQ9LDDYnt4EVIjPhC+NiS3USUB6SpYl5GxEvyBKnQI3RXMpPym+L2YX1gBRin92I8TIXtFrXtkWfluDP+TXByAjbrgbgsHdn6f2swZOsL3rYvG8q8UWYEltMlkpsw32LBtkssVwxYm5yL80NpSnDKYvbefQ7NMswYxyNG5SXq6FnKGcS3b/LDI7pZNWDSiCq1k9WDShczWOoWuoOzXUFvXsWJbrtZq4HliNxH19++b5d2Klreerikxc/LhQ18c8HkILzfEQEJ8oB8o1XMnzG8ZEtYl40robcDlECRGKaPh85YnDMimF19Xo9NsPk2RdpkkqcjZTjaZHD3ONNbW7YfpjKvsCi6Ev4C4Mk2xuJ3FY4dxYZDAe23DQoZrDPQ/2ERndzl5a65b01IgkIvIfUrAhKXjk1TKif3odp63JOLzcR2Z3UVI/9hfAYtCH64/le1G6OU4WYKJ6T4TGua2HPT7NuYBQ9W4sJnD2zXh2AkUnPFwunEjZalybmWdFBtV2qXMq8F5PW3BzEwRE01H3agPna5iY4NxEqFEShS3RZch97fM5rCn0viJyPx1CEBMUb3JIurwC3Go7gJW/aT9n6y/e2ew4lu4pOO1JkZUHl1529gwo6P2lMW9ujcF09aRDNcXpfmIPNrWl4FpDYcD/ND8jHpPt+pjBRcLILZTUc4Um6PRtUuM6uNg1RL0Fe2yPLfh3uMYgmWj7LxvfoNWD/yJeU7QvtVIveuhq5IX5We/yFwIUpFF49ngponDxOLVGcZ1JSAQt9B6WmASO03Z2+nf1V7ci9jzuThPb/NeXw2TiA
 fzAKDVm1
 FUzuMSqVbGsb6yN6J42vqQe52QSRjIoX1J2dmqUzlQ5aisXqiTyn3vdsXIIDcd9RAXnDPMjz1SL25oIXBVJkXmJpZkMUfDus0IRaHwKt07luJkOgC1MOrFHq+pZqXBojWl6OeF1aBGJtZMN08v9RrASH+CIOKEa26njF6rx9pu2Xd8RmeTmeI8waYoACGJWKENY4PorML+eOWz2+ZSgilacE2vqoWMnqCD9mEddw/azkofujz9NfvqRqTgRI5l+6JCGQcmATwNhzt5maCRFueJDeoEolcVzuVgi8Wi6K2K/sT+KPYGOBMhhkTHObJI/lxOXY7vceweFwuk4+4cZw7lWm0y1GARxN94UYrL+BlCCiiVIQJsgcAlYwYKcoJxYMWDZQBusa1S7xyclUrJ7Z9M3rQnYvQKlRDS1w/I7Tg0O0Cfe6/U5a8UTW+36KUuXrKpRf+4Kjyvj9k0aw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrei Vagin <avagin@gmail.com>:
> Actually, this change introduces a performance and functional
> regression for CRIU.
> 
> Here is a brief overview of how CRIU currently dumps memory pages:
> 
> CRIU injects a parasite code blob into the target process's address
> space. The parasite invokes vmsplice() with the SPLICE_F_GIFT flag to
> pin physical pages directly inside a pipe without copying them. The main
> CRIU process then takes over from outside the target context, calling
> splice() on the other end of the pipe to stream the data directly into
> checkpoint image files or a remote network socket.
> 
> I ran a simple test that creates an anonymous mapping and touches every
> page within it:
> Without this patch, CRIU takes 9 seconds to dump the test process.
> With this patch, It takes 18 seconds...
> 
> Plus, it obviously introduces some memory overhead.
> 
> If these changes are merged, we will need to completely rework the
> memory dumping mechanism in CRIU. Using vmsplice() in this proposed form
> no longer makes any sense for our architecture...

I just have read some docs for CRIU. I found this statement:

> #### Why `splice` is Better:
> *   **Consistency via COW**: The `SPLICE_F_GIFT` flag ensures that if the process modifies a "gifted" page after resuming, the kernel performs a **Copy-on-Write (COW)**. The pipe buffer > continues to hold the *original* version of the page as it existed at the moment of the `vmsplice()` call, ensuring a perfectly consistent snapshot of that page.

This is wrong (with released kernels). I confirmed this by testing this on my current kernel (6.12.90).

See the code in the end of this message.

If you actually rely on mentioned consistency, then, it seems, CRIU is broken.

So, in fact, my patch actually brings consistency to CRIU. :)

-- 
Askar Safin




#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <sys/wait.h>
#include <errno.h>

int
main (void)
{
    int p[2];
    if (pipe (p) != 0)
        abort ();
    char buf[1] = {'a'};
    struct iovec iov[] = {
        {
            .iov_base = buf,
            .iov_len = 1,
        }
    };
    // I pass "SPLICE_F_NONBLOCK | SPLICE_F_GIFT" here, because this is what criu passes
    if (vmsplice (p[1], iov, 1, SPLICE_F_NONBLOCK | SPLICE_F_GIFT) != 1)
        abort ();
    if (close (p[1]) != 0)
        abort ();
    buf[0] = 'b';
    char buf2[1];
    if (read (p[0], buf2, 1) != 1)
        abort ();
    printf ("[%c]\n", buf2[0]); // Prints "b" as opposed to "a" on Linux 6.12.90
    return 0;
}

