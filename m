Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48947CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A136B008C; Mon,  8 Jun 2026 07:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1316B0092; Mon,  8 Jun 2026 07:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7006B0096; Mon,  8 Jun 2026 07:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B56A6B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:40:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BA5FC344A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:40:28 +0000 (UTC)
X-FDA: 84856552536.09.A75A0A4
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B782120005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:40:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GJofU+e9;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of andrea.cervesato@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andrea.cervesato@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780918826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=gt817j5d2FZcQYx9aiRFtGll+41qpg8M37eW3rPlaLM=;
	b=Wri/kp36lRMJgSAVl8c6T8NaBvzKwk7vG346oqK3mqBCM1S1SkvMvKfEpTP91coySuXUh2
	t1CRLV47pr1oi9RXQ4sYnvjF0Z0OFmxlhpMB6DSyYl/FAQgnSjTXs7aVNLJR4lCsf3vt+z
	jNXj0s1KNdsMFeCQdssQE4ExstVx3bw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GJofU+e9;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of andrea.cervesato@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andrea.cervesato@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780918826;
	b=00iYhjIYQpKwfLJhjQHJeK7GI15w7EHedOgrJNgGO8PfNvNOh6RXy169c+UB2+4Kufru3o
	uAmfEpg0+nP8idAMBV+2DviSF2IZtd6K/EbvwHaA2WGfH/tweIz+Fg7bg5+BykWJHgblT3
	M9EezGkzAyFBXUq3Cc9I5yVn/E58hX8=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45f3cf907ceso1931988f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 04:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780918824; x=1781523624; darn=kvack.org;
        h=date:content-transfer-encoding:subject:in-reply-to:cc:to:from
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gt817j5d2FZcQYx9aiRFtGll+41qpg8M37eW3rPlaLM=;
        b=GJofU+e98g1C0hRjcsE+sDezmXibGf6xHu6edLtXBEOEeVSPeu2RZjuo9rCnNM0ioj
         GrdHXxII8hmC4dFPrKAGm7fpDszOlk+3XFG5T8cbJP+PBhHGjYfn5RDy61dA11GWaQZC
         S4K+mgzCDgeZCT2b8epV6kaOpX8oFvRaCwww9Af2pym3NfR4H9GaSvkXifgJB5FbjA/t
         h+K06APaeXhLJ/j0mhkntSRCqxVJaMGGAqQxZ90a85T35EiCAlXatQYZhaqhLESpRgQW
         oUbYg1iSUQd15uwNuwee1Y1c0cwTsr59ojOikPrztGz+hjIXBybKdFp5d9pxZUUlbkMu
         YzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780918824; x=1781523624;
        h=date:content-transfer-encoding:subject:in-reply-to:cc:to:from
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gt817j5d2FZcQYx9aiRFtGll+41qpg8M37eW3rPlaLM=;
        b=V9IcmQDM3jA9jg5+mN1OqUp58TcEfhV6fzwaJZkyVjT1DFNI8McFd8l3qKAZ3UFUxl
         U9KSDq5fx89fRNv4SU2HyW7wAAWF7iRhiQc+7FIV/S5e5TGOyT6ELthjfnrZchE3hmIG
         LloeBoFfyr+E8PwaHs24ICCpulELV2i0+xkupg6ME4HWRB7+Mv6Q6RvjVz7ttm+u3wnq
         lAtbk4ZfkffftithWS0ea3j8Z2Z+l0vqH+yUm4I7wvHN36tS/k6H/1cfJzvhuGq0i8YE
         drGVQfej7l89YxgVmqJQgNG9tVfLHdy+3YjZLiA5E4w0lKCmPDDFCh8qnA8rap4S9a+Z
         BcjA==
X-Forwarded-Encrypted: i=1; AFNElJ95whKOC3hrmXegW9Gav+A35VkCb9+wYDadZrF6JH5wjyuLMokrn9lbSimzyo+5+xdSy+gyeyOTCA==@kvack.org
X-Gm-Message-State: AOJu0Yx/3GsqHB5cBjQW1eGVFEOi4kBVcJ5gtHoZhxkMNBFUQbCmQmdn
	S8ons5U0SUCado53KnL37f16WwKtPYnOKsyL1eALyDK0oZ1EX6HfmkFfAiGiFvEVkXY=
X-Gm-Gg: Acq92OGrBDc3C0iqbaeT62fXFsn8dBPOgr9qjdsGYul6OsI4Ze/94OctQo4woFQCYY3
	hiJ/6A51jbajvK0bPSVisqNk+HMM66osCc+PthuFaFjIXl2rVU9HO/pFld0jDrDe0HQ3Hp/qSiP
	XOyKjnwcb0t+D5tNipx7PFBrRnTFO0WHOpUy9Q6NcB2bSNZSInlhFR2iWIRg1CUJbE+42CQWWpm
	z6v4A+YMQujxtNQvVUnOR6c3RLk0CpMq2JniQWWqo0QwIAv59iivoN8/yD0rvRK/PQT6UYMlbfv
	wfnQnr9US8s5w6gC4kyK4Mndy0rLoFYeqsUiURqL5yi8jV+/f4YxHNuvyaguhFKYs4Xa45luVkI
	Rn2yteBvo/0q0wtoMjpWA85ejSbM+6KzJHo4cuC4G30Y2PopyxCVEFo6vIHtf5SYYqUkiWHwKL6
	OFqWcJNrhj9z/gi/ZVSO8+Z6IhJWSVDaiJ/8a5wL6IvdNeTp4VfZtWNuixdwpM4ldeRv/CtTme1
	njgDUSP47MswKhm/ZFKVNN5JGxNjQOi5qATGQMsEcddOA==
X-Received: by 2002:a05:6000:46cd:b0:460:1492:4f0d with SMTP id ffacd0b85a97d-4603063c591mr15377117f8f.34.1780918824402;
        Mon, 08 Jun 2026 04:40:24 -0700 (PDT)
Received: from localhost.localdomain (p200300ef2f13eb00c11aebd17f9598f1.dip0.t-ipconnect.de. [2003:ef:2f13:eb00:c11a:ebd1:7f95:98f1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f2710sm40821903f8f.14.2026.06.08.04.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 04:40:24 -0700 (PDT)
Message-ID: <6a26aa28.283787d8.1f1282.ba36@mx.google.com>
From: "Andrea Cervesato" <andrea.cervesato@suse.com>
To: "Askar Safin" <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "The 8472" <kernel@infinite-source.de>, patches@lists.linux.dev, "David
 Howells" <dhowells@redhat.com>, linux-mm@kvack.org, "Collin Funk" <collin.funk1@gmail.com>, "Joanne
 Koong" <joannelkoong@gmail.com>, "Miklos Szeredi" <miklos@szeredi.hu>, "David
 Laight" <david.laight.linux@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Christoph
 Hellwig" <hch@infradead.org>, "Steven Rostedt" <rostedt@goodmis.org>, fuse-devel@lists.linux.dev, "David
 Hildenbrand" <david@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, ltp@lists.linux.it, "Jens
 Axboe" <axboe@kernel.dk>, "Stefan Metzmacher" <metze@samba.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Andy
 Lutomirski" <luto@amacapital.net>, linux-api@vger.kernel.org, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Willy
 Tarreau" <w@1wt.eu>
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
Subject: Re: [LTP] [PATCH 0/5] vmsplice: fix some problems in my previous
 vmsplice patchset
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 08 Jun 2026 11:40:22 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B782120005
X-Stat-Signature: 4ic18zb3op1ze1apries8pmwwxn6rqfu
X-HE-Tag: 1780918825-225294
X-HE-Meta: U2FsdGVkX1+prmD4EPKRiokTSu1NTBh7UOlaGYIxvPSuLKFLg24mZu6XKqgyh+Zvgo6QnkVvyMGgqu5AwX/4v7662SBRmcvfOJ7idZvCutj0nybEVmBVh5a5G7N1wwsjMqCoGPgD3tfnFENpJn4SCYM+xXYR+kjAx0zUYRf+a+ByRaBG9ml3FH5dpEKaDXXK7OfSqM3YJarQj5K6ZHNqdHsU0BpzincNMynkSnjvgzZAPflr0cLmPuqjrr0FI+uCor03+pWTNVX78Kv1oWaQbNxXPcczXszOFlO6VydiTLAvLLdKQRLVz2RoSQ4Q5sXDPbOgpSn+uSTFBV0ilTDd8USmMF7KwggE9m4Lbs4mhwOw0kbSo/TXNyAGv+wARWin4L5JGPVih2yskK6F6TqhNh8ZsZqBWwX0BGS/xzN+HViOfuSotd2s2vX7TlvhwLk19C/JMvMWbVSj9qb0XL3NQMeD17yMK2r/kZWqM1h5avhKLTFe5TkmAt+HMFJb77xUa0Jz4cg+C1vtu1EUNMdvOn8XsAM8eWAlH3QavIKCeFtMZQ5Myg3dalirVC3jsmxYEU2YrvfSfsqs7OOqQsIR8fNxxaxLEhajfB9TeKKZMV9NjEIiEVmu99Q2gd/nW5H+SNiwFjiWavcn66Z9UA0ppaw2xmc30SSr52pMUevm/gVrZ+OZitAOrjTyUam106j5uFtGvFinOeVo4E4VLOZzvFohCfIZqEs7Vr23WXig1j3fkb+yZNUdHCjEhqc6NpzoSVWHGbMsPpWaEvjn0kPQSK/JtrMWC9PHZSIYdXyilXx0m4TzKQDFPfyvdoNWya66yQzbS/NhfbSLjofWcdSHTwOxNwlXe+iOaKMz/eA9I2NbLDV2lCQVHDuBRNiCtvUJZZiUgwQhi/2zoOBNmeN4+Msk9X12c4v4gkesNfCA7ZiStlSZ+XVjLUP5pxp9wWMDRHrpA3YFjHQTz1BM3kN
 PindMm7A
 BkYjb5hubJhpyGMdSoNEuC/LYrYz9YnPijZWYf9rLm2ieDCGvB2PXv0OZZDGQDwAn3K1vlqpROndid5q1iNOlPnytIJRnQmANyd496+kKsZqB5hOJfwhr0MglR95CygZg/tmEuci9n/SN1woKY7B+1mJXflGYRAenwylaJ2OjDiWuTxk39FNXXrn8UuGScGaH1IKyAZCusO1yLDiGVU7pdVlpEGHAiijUx0YBLTJjFexjd78iTy8ls2LreladjwSlF0G7v/+8+3UBaXzEKGBnwlC0x6H3rl3Bd6DTnCxd1iK+ZhBrDKdW5TJhGWp5Fbj20yiUr1ixGjvURVm858zOb/dfZYnCT4wHHNwenpXkI4EDn+dbtqQxhy7zvW+W5lW2z17iTpuLOv0u0Qf4jF4PTe9RzSsPirVujIwpJSW8S8Hc/cvaaJ+bvMFV/laN1SNW0udfwPcYIRH+o6fLri8jjyt4YqNHaL75f/DfY90PIyqIFH2xp3sAaNaZc1nW6S1angXONvlW9QkVyv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Askar,

the patch-set doesn't apply:

error: fs/read_write.c: does not exist in index
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort=
".
hint: Disable this message with "git config set advice.mergeConflict false"
Applying: vmsplice: open-code do_writev and do_readv
Patch failed at 0001 vmsplice: open-code do_writev and do_readv

https://github.com/linux-test-project/ltp-agent/actions/runs/27129052434/jo=
b/80065058557#step:8:21

Please update it to a new version after rebasing with the upstream master
branch.

Regards,
--
Andrea Cervesato
SUSE QE Automation Engineer Linux
andrea.cervesato@suse.com

