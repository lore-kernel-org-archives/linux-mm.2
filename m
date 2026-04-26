Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA1A0FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08216B008C; Sun, 26 Apr 2026 17:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8706B0092; Sun, 26 Apr 2026 17:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7866B0095; Sun, 26 Apr 2026 17:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 994D96B008C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:43:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A1261605F7
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:43:39 +0000 (UTC)
X-FDA: 84702034158.23.BA3D714
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44722120003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:43:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZY1N0BqB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777239817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUdLgQOCVlyixTrdH7a4UDIcauv75NFTtaENVvxSOB0=;
	b=WUA35kTyM8P67xuyfxXJLFF840xS0wqAHQIGp4FjspEKgo72wqPgAaUhVS4yYwrKTg+uiK
	4PJbjdck6S+8/Hq3KrfKGX93fOMAxnvaFNA2/a6ocyhCUzD6fIV6yHn7qQYEiu6WENAzOL
	sgxwFglfPT7vzgh8y7SHvVE1VtnkBto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777239817; a=rsa-sha256;
	cv=none;
	b=i98yURA92dhzuoCa6LJdnsDCcDM9cg+Pd5FVxboFSb/FCMW5pYBafvIPWrBaEWPjLJMq3l
	7/CpOI39mgjeyINQIxdQzy6r8OUoCsa6wY+/zJiRmagU2syUjR9wvBXHZNo1IuxA3IrejM
	7qk+8lfBaSlmV3WxpRbzQEgb1R8bHe4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZY1N0BqB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso79491655e9.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777239815; x=1777844615; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FUdLgQOCVlyixTrdH7a4UDIcauv75NFTtaENVvxSOB0=;
        b=ZY1N0BqB3+661Xr8vbjnsdH/vC2IkmtUY7qQ516bE9onuy9qy4m5cwPzPCDiRqNNrY
         Th9DEHLwzLOtpNXFUEpBQlrt0SQXO22Xeq0jMjgKUFTyoxkcFp7Erxs01nOzTbWX7Q5x
         VkAX6qfj9EPOys9W+gS/Bh/07s4bsSMLQsXnFOYJ28amNScHB4zowHbjQmaNORI4r7bi
         aAkJ1JBdbKNcC6F3jldUyGVIwqnsFQcuQoqnLuIgLlc2cgN5RLSOfOIfZp2eKa1Dqmeb
         zCmWs2icmIKtiCMujtg1U6cH5emgHqiXJ/2u8K9bHHljoJe40OjH7pP6M9FsIRQ6ZiDp
         Bu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777239815; x=1777844615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FUdLgQOCVlyixTrdH7a4UDIcauv75NFTtaENVvxSOB0=;
        b=gwB+UYSmh+f3tfFK9AnStVS+Ga/TpDNOS5tTJ/VVxAWpxs0i8FuF77CUUy/j2LRZGu
         7ImQe149Djqk3ozdSsonI3nRnRidAilCxHtkYXKg1uQ0Mt2yrrX6bpR8Jo1o0aeEcgsM
         mrcxbwHuf++tdjae3IdAIRWOejruL6pGwIsBemW3xbOmPig40hG5Y53PAqQGWZO5fCJk
         XT3DHxsnoxuKPznQBZ4WH1G7Jx+zKsvoVIAoDtjuaHqVTkBJ0ujN0lOcDF+nN3vuun8o
         Q+a8MC1Q9LHzmtFxOZuyNXNivqz60SjMqSAnJkpRy5vZR5wkiu1pu4Uf477uwA9kVKuL
         Ezvw==
X-Forwarded-Encrypted: i=1; AFNElJ9UluYJqj3Usg+5ShMGKFMFTO1CkgtwRikQWNvP63ROp2V3FWh2fjglgGaz+E5UosiKmZn238vVMQ==@kvack.org
X-Gm-Message-State: AOJu0YyCSJvGLqEO/auJJvqtXE376OzKaCZGFS3KJKDI9QDdJz99rF+f
	OVSoJPll7nIH6uXFkG/Uei/PpTJgfNFTuzclDXa++VipUTG0ee4aTQB3RDBnLAKZ
X-Gm-Gg: AeBDieufj0xAYVk8FNPrV26vc73s3KOeeRihiNoV3LnhyX8zvXb9FeQC9ktnlA/io2b
	+pavgTQQEcdjKHoE5rpsjHxF+UUOmmEorzvJGnhPcR+YYX3eVcyXRP6lIPna0DA4GZ1RhLw3jxu
	3K13v/l8JYKsH6r4nO3tvq6KzbcNUGe+x6lYVcWE4nBTHMxJGyP4QVDpZFdslTbMMg1x9S7pdGN
	qJu9o4cOpflRaSB8lD4U1VxnV7w+BR4lxYHHfCBCduFJkNMXW+aKSPmNCqZ0xJumXLpYzMbVP74
	GBTCBsnDwR1KKzs3q8cCOVo4jl6lQ84ucU5qm2HXtQyoRvlCUXv8jo3IZY/3nhpxa/GeWCLMFYn
	EFiSQNBI0y+zuoe5ueY7Qh3EFxRuPRODiGmLezdy/t7hTeCRwqXvq9ClmeIGUptDetW6y8NS8Vr
	POZvFQ+BBX7TlLFuKv8hjGsfoB1ZkviUYmuzNB90DHpJFOdDEOhJXDnrhlwA0I64Dy1593bh4LB
	VE=
X-Received: by 2002:a05:600c:c085:b0:488:c530:48a0 with SMTP id 5b1f17b1804b1-488fb784843mr454167245e9.24.1777239815396;
        Sun, 26 Apr 2026 14:43:35 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a52583fe7sm423356605e9.13.2026.04.26.14.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:43:35 -0700 (PDT)
Date: Sun, 26 Apr 2026 22:43:33 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Min-Hsun Chang <chmh0624@gmail.com>, arnd@arndb.de, msalter@redhat.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: replace ________addr with
 __UNIQUE_ID(addr)
Message-ID: <20260426224333.5916c960@pumpkin>
In-Reply-To: <20260426110932.786047b4338843e0a91abaa9@linux-foundation.org>
References: <20260307092119.20733-1-chmh0624@gmail.com>
	<20260322144032.7353997c@pumpkin>
	<20260425135737.e79c4b546d22b5ebfd96c0b5@linux-foundation.org>
	<20260425230134.5449498a@pumpkin>
	<20260425151240.2a46e3a8640fde3902461d41@linux-foundation.org>
	<20260426114938.4dff28c8@pumpkin>
	<20260426040925.b25cb2a32680bfe884431abf@linux-foundation.org>
	<20260426183420.2216d187@pumpkin>
	<20260426110932.786047b4338843e0a91abaa9@linux-foundation.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 44722120003
X-Rspamd-Server: rspam04
X-Stat-Signature: p6zhnc636p8yy9twunp9r8ngxhd6jw9w
X-HE-Tag: 1777239816-559665
X-HE-Meta: U2FsdGVkX18kMMfYIAwTP9z+Pdmhu+KrA1H/WCAuKF/pLAf6WMijhzMM0gjmO/xp+E9pbbdJtLD5ieetvyNXAHAIrVMM8KHbt7rHkk9L8hMtMUp8loBM/8BodTlayjq/X4HtQwZ10D+Ss4/rF7MBzXnOoGFcHiHrD5V9ApraDjDt2XJg4Pagrjb6h8lPmk8gzeWDXA9/yPnjkUbLwnIX/KsHYVO0erThf/O8phoQnVkMrh65hZqlRPBes3MA5R1ES5zz8JuvhF/Hwf1S7eZ2WuzzFZEduG3bN3YghVgXvwaShD5va0ZeFUZH4Flk2ADSwPIzdgUEtIbDO3UdOBqPDh/LoS887EFUqR9hUQjN8j/axKqDbePBaSrVPrD7aSDY+3mgE9PkX4pA6FsHg4ZF4QDfNEB31uOBpOjTTqgnZLkDHdiYK8sL9Jw1ihYZ0y1tX0o0XGauXXLiC0nXqCeBqx10VhjgWlIByS9dHdN7OFUWpXfH/PgSL7s9hBALWlmUdUredjPynoJ/N0Mn6A/iLzSaw0gXOTllfbrBNPpFFYCm9w4Mf/Ds6qLgnxQsmkqKVY06v3RJfvSK7b7UeYxW0Q21TZ/9lrlp4c2VdhOM778L5XRgjkGdyiIDFZ6jKray7DI5lMfzLZKrci9236VodLbldxmCeg/rvMEu6cJAYcq0D8qWX1P6CxIvj23zsd7sIDO/58ZpkM0jtSj1WS6pt4jLb6561RyzCFoG8BcPUdQOMhu/XuhBkTS0sxNn4yYFECdnxxVZQqr6VKla3KtCwSI9oBL0K0W97akmd0lsbvIPdHpQK9X/nt5kU9Lzj9eVu6jpRt1h0o7fdznQ+RO8w0xqrTRClMyBpiyKGG8eftJGzaqCT4dwPgXW7EWm5q2Hlb7/azBEoMl5O6jGj6WEi4xLoYiElMg8cY6QsLafTVIoXNrMVa5ExAztmxUhpuwQNnWmQpOBoczFzpzstUJ
 JCfU1dYU
 iYpLSQm9xJDdbVfdL36cbKDJ1lRPjWN5VPP6lU7NDpHd+oWmSgNSBod2kmRFLZwYZ1Y4DkN88CTRGKLZspYvunxUcHVMIus5mi6bh5AS7xuKg7qfYiC9FKtSnxLi29vtESnbVte/aUHe+9oPWgVM/4s72WQ7u/MwUgcQUmJte1UcLyBMRQUBgd/+1R3FsXzKZsZlGn/f5ooZ7NcMaC+rRzqvxA8H0jZTCLu28P+ljGpadgjQhEEBqYlxpdIJoFrHAsMRAkEr80j09pr+A2f4XP/N8UWzplY7kt/t/jmMeTXiSk0S41hmrnO8/hf90Pacs/5nk0r7rSnYBP/b5QXEe/TVnuLE/wCypO6bLB20RUEOCtyqjs+r2YBEqZeKmCyILITWg7wOFe+82dsJXHMU/iK/wGSYYfwDrB70Gbh3et5C2G/0taQt/vysBgE8HbitQEGkvKg/XsiG/nDsozYhWduNGkjwUF7eWh2ojeeNOTWi4JtlIjPEldntmlSjn5+EwOzmBHtXsELeYIugpDUxw0/E2jottIF28TBUZm/uQErzF6ysc/XmZnSCcXfrxgq5/edHPMyDwzv9I6DbdwuiFpKMk9E/RTqHevkKT7w2dhR653TnZm230z/EH0t7MIUXU+SeQLEsA60FSqBIPgBLxOCD9l/TENHTOi9qBwUO5nAhLeVr9PCQjmbBt4ABrJDbJhIKupyIpj10eSWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 11:09:32 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 26 Apr 2026 18:34:20 +0100 David Laight <david.laight.linux@gmail.com> wrote:
> 
> > > > True - don't look at what strlcpy() can generate.
> > > > The inline code should just get the constants from the compiler and
> > > > then call the appropriate function.    
> > > 
> > > I can't actually find an in-kernel strlcpy()?  
> > 
> > That is because I meant strscpy() :-)
> > 
> > In particular https://elixir.bootlin.com/linux/v7.0/source/include/linux/fortify-string.h#L275
> > Particularly once it gets as far as calling strnlen().  
> 
> Oh geeze, why did we do that.  This is the kernel - string functions
> aren't fastpath!  Someone please move all that gunk into lib/string.c!

It might be worth selecting memcpy() for fixed length copies that fit.
Especially since that can get inlined to something smaller than the call.

> We'll still need some macro if we are to retain the (imo silly)
> omit-arg3-if-its-an-array trick.  

Try: strscpy(tgt, src, len, spare_argument)
I'm pretty sure it compiles fine.

	David

