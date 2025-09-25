Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0C3CAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 20:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF648E0005; Thu, 25 Sep 2025 16:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6E28E0001; Thu, 25 Sep 2025 16:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC5E8E0005; Thu, 25 Sep 2025 16:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DBB08E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:28:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB02A86F92
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:28:22 +0000 (UTC)
X-FDA: 83928910044.16.7EF0BB3
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id DAE501C0004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:28:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cpbPBkts;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758832100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVmWJqFwwC9UwpxqsqqkVVx9IUzg005YrMy6SZ7c5p8=;
	b=Ep79G9BzWXWtK4rv/FESHnj6JTXjC+f8HIpfzjx6WXn+pEhjrqBs11vzUKRzM4M87wSZ4I
	lLFFJQRvZC/l+/7MBy929NLrD8+717l7TPxkCHQfz8mqu2ySGPjMaZsj9kqUUk1amEKTfl
	wFO5Wu+h9zRvdzXgZXHRDWXykSvU4Pc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758832100; a=rsa-sha256;
	cv=none;
	b=hyabtC2JFFMikl9RQAe66l5bdcDA262MzvbOwEC2Rnz2h+fCya82yEOJKBfc1CEEy8SgW/
	RKHLs39TYxuVCQO1xUc9ZSZaSqP4T9EKxtwtuX+uu2HDguGDvuqFvGqFwbCocZIMe9MAex
	VnAm0P43uO9og2k8r+hB2DpjkAiMrQY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cpbPBkts;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-71d71bcac45so13680047b3.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758832100; x=1759436900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVmWJqFwwC9UwpxqsqqkVVx9IUzg005YrMy6SZ7c5p8=;
        b=cpbPBktsBBGZjAZ/33SrqYC+yZdgTUTaQV939E1mRm7VFfuBmN+0P2bv6VsUha1Sm4
         qkGDawFAUkw6WGIJkc6HTU7F7Hi5szvyx5xgyMd4R3SMGlQQeFUY7dF9xCdlAwPp8w5a
         Sn06iCAcjxV5lveydt9DdEBGpK/lERp4Rs7AEITiJfRySn9PBRhPXWK1w+9weM0iDLrg
         C49PtcpU29A8zqdyXTOXymgde0caxSvwRT/ARUm4CZp3aj0uFDuNmY/dfXnbIzOmOOnB
         VKCiWKFm0ovTZaCIfl6L36iIGD7ZrrEUsblVSCARg0Iy15d99irygTUD2FcIS+UbaHOl
         /YKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758832100; x=1759436900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tVmWJqFwwC9UwpxqsqqkVVx9IUzg005YrMy6SZ7c5p8=;
        b=CSDm07YMCkMC398Z09L5J6zPEXkRiyQeq487iF/Eo+cfRDzbCnZb/OrCL9VgEHOSdE
         5YssYMJ+vgAzzHdtYLvpvZCsoPBbyVMRluKljXZBzraLX+Ya/rmkDhXQqMkDrAhDnCsh
         R7DeYgclY7oW9yIOsf8etdDore7y97QS1tve6q+nAGeG4aaWw7oTRQjhILsveHj/7ToE
         Xs+m7FUbGKQ0cR4aeFUHvxaiQ4Agjr+c2eZvbUQKMbvnnUZ/tZJJgXsnpFcAVpS2tYX5
         31AdmHONflYHNK1FmUemK+gK0Yls0fSxjobZFxNrwhtJLgw7uYMV3/3um53MhjO6ngNo
         +Zuw==
X-Forwarded-Encrypted: i=1; AJvYcCVrFa258Xui/pyITk5GnqwtnFTKLqA9bD9clZenxW5fNO9y42ZtqwvvmTfNG2WDCqguEbVJpdIFEA==@kvack.org
X-Gm-Message-State: AOJu0YzoDxhyc5i2e9V9ZQWcTtPyCMkNo62TzimUFuRR3yf5IhY48pBA
	LeQr4FvqAZJzupmUPy2PGsdtNIwH2RhOMrHegW6QlylsN6k87cKNyxZK
X-Gm-Gg: ASbGncui4favtoPn6/vbiU3fEf8u1AHXJuglp1gxyjNJZYb1tF8uS23YQAgU0taxJYT
	1rTwwg0CjaWDCB3LgLs3vw7djcmMRs+v+PZlciye7AM7KxH5L2iIJJ3T78Wl9Zex0w9RdxG1uXq
	+NIicYTkPLHi/iKlrtVTJFGo0sZH5Vpfa4d2G42WjF2XJNQhkQxZyJ0d+AzbZcqsGgi57jdK17a
	9Tr9urFGG2JcNZhZ1drOAqmTBo9OFpYnvs46L28tIuQppYCxHnChk0YvQb55Doy1pfsFoeHS/zM
	mufoPHMqXEd2JlokmWk+vYK4Xa+ampxhHkOHrUKtPNKFSgeFQz9f49rRFaTAMxe+AlYT6SyjVi9
	QLSBoSkQy0UlljL9WkT4Ucwvvh11mHVbdAG44vNzh01uCLDPV45U4Hw==
X-Google-Smtp-Source: AGHT+IGpvS9NECCBBaVDmxAL/wsGDeZWDGx2zhrz3DD3pXcGgle4QeL0zP/OkJY10O9P4DBKPWx/bg==
X-Received: by 2002:a05:690e:4303:b0:633:a260:14a1 with SMTP id 956f58d0204a3-6361a735958mr2736330d50.18.1758832099499;
        Thu, 25 Sep 2025 13:28:19 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:70::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-76884f52fdbsm4344417b3.6.2025.09.25.13.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 13:28:19 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH 1/3] mm/page_owner: add option 'print_handle' for 'show_stacks'
Date: Thu, 25 Sep 2025 13:28:16 -0700
Message-ID: <20250925202817.795114-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924174023.261125-2-mfo@igalia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kwqxpr9exj56zyp8ye1d6b41tjk4mjf8
X-Rspamd-Queue-Id: DAE501C0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758832100-251110
X-HE-Meta: U2FsdGVkX19yOG8XGC8lkyRxa0+fAHMJ1wrtegyO8LaBKrdcFhcONjWs9JuZczbLSX3ZJ7jvROQ2C1NA4iYa6Pg/QaWDRzr7dvCgVFduZpUFtzdF9lCH+/P/ESt5yvuH3/PfDUfrRa8bECZDb/eU2Nc85mqLMfECRNr5idMJrIF0PakTw2ks1Zc6FYQZQ97ypYoBaUqnSyVlsL5bO7/6c5TqZatUWfWJLAWa3uqloZoXUSjg6ia/MmskX8GYXQjhWCmItgr0/9lw39B70f+SdDAJvadK5yNxv6IrmkkZy9nnYtVCm6ShKnmvm3CF7CBso9AUrDkOWgvy0adg3OE4Dq1JYwJy8hOtmqEwt9CckIvSIW/f1FfwX5nuKtgOo6N7oaOAN+FQW782+30EM7mlO2+WBxnTYBe7sw58rN4hXHDyEcWMKmFYSYomkGr+vrr6DBeG41ALaJG9HyJisXJi/k8AoibbtLXX+onisrjQrbj1AUJxtkIBKJspsTSXnNCpmT1/+JSDp9ht0FmPt4PFSacsYE4SRitC+qundOLkGKgaXOP8qaRKDuzkvbu1uHNmG5yW+Jpq5OTWQqn6xOTunTzgkBVQUbtDQHBNFhaPYIFtinvxnhHThkiAESyX4C6zdM2oPBUjf8QcpU32+1/AZrd2doPz/mNXNlXILnJ3p/o4uHBhtRX1YTBM6z++AauNW/ycoovio64qjhjkM441EbcpSEDYamcp4YuYCZGfTXK5imTd6RFbaPz7GmAlNJrcIkTzvlbUVYtUE02g8dJ3sCAjzw17OfMfhJbr9L7zSQm5x65xZf+phL6Fuj1y16NtUmNIWiyGWeKQVW/egPAc2M62rsnb9RF+981/35ej+JS2fyeC/nQQyyIQRicQqZRxM1J30vauZZF+qU0Qfb5uv+R2eg1xAAR635flQMUQ8/cBITTdI/SzRqofLgi4ByWjTJ/i7UQ3udv/QwDXt2X
 /cWSE41K
 J4cJEztTqQJIHAocjbYVYpoVtbZC5ZCTOSxDgGllCy/gGAquJAbA5p4DRxYLdzfF3sd/71WARk4gUZPBieb79sMwFi401wCdIVrLd7tIb2w5VpScXD5poMsmjC8HwsrzebEoU2BtFUXgoSkX4RHzbHQprUOKCTBR/YstTASimpW4CU+C8Hk0A7RHhaq55yE7ravoqcbZJWAaq068J+mQPrfktCS9HuwG0ZJB3R7tQRV5a+H+5TVsdUAEBNtST2QJNWSDquUtkXNQiZEzMmevTkGfajQfnUIWCeksqrBMHqoby5/lFJLKRoacZx6nViLA0bmVyUl7tmBwMnQ2P86hubZP3+iE6Gnk2n03kPnDaF6G0eOFY2M2oVzBB4BgzT37dhsKlHqIls7bugf91xVQNt+GAU/+TfFrOTAnwugjlsDfDvWdycO6WMmMkZg1K0juvkFI3lHjNc/n7q16QCD7cdpPRHNcdDSyBVJR3enoXmQn6ZTwEUFlBeT1ip2JgkzUrcip0Ti9lKUAf3j6nx/cfAMnYbYvdr7UciIceTof4Ppg0fAkXB+Idj+OXyf8onB6ziUuHh6DVFQ78y/qpxHz1VINIPVbeNiJEmv8jmhtlR5I1MMygPPCz1uJPxduUawhL9LeDXzmUYETkfkc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sep 2025 14:40:21 -0300 Mauricio Faria de Oliveira <mfo@igalia.com> wrote:

> For monitoring the memory usage per stack trace, it is more efficient to
> use the handle number as unique identifier of a stack trace than to, for
> example, read/hash all stack traces to uniquely identify them everytime.
> 
> The handle number is a unique identifier for stack traces in stackdepot.
> 
> This patch adds the option 'print_handle' to print the handle number of
> stack traces in 'show_stacks'.

> @@ -887,6 +887,7 @@ static void *stack_next(struct seq_file *m, void *v, loff_t *ppos)
>  }
>  
>  static unsigned long page_owner_pages_threshold;
> +static bool page_owner_print_handle;

Hi Mauricio,

Quick nit -- If I understand your cover letter correctly, you want
page_owner_print_handle to be false by default, should we initialize this
to false?

Have a great day!
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)

