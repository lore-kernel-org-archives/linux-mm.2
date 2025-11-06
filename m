Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40A4CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDABF8E000F; Thu,  6 Nov 2025 05:05:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B818E0002; Thu,  6 Nov 2025 05:05:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79CF8E000F; Thu,  6 Nov 2025 05:05:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C21178E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:05:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95305C0586
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:05:22 +0000 (UTC)
X-FDA: 84079749684.03.688BE04
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id DB63C1C000B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:05:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CqIjs2IQ;
	spf=pass (imf20.hostedemail.com: domain of dileepsankhla.ds@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=dileepsankhla.ds@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762423521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Z9SBcCPeaeM8jmEuFyY3d76OUpSiPVaODHhAyJ2j1XY=;
	b=yfhJWssiUabuIgTk12cazUABpATpCDqFH0Mmeyr5on4hZojdCuhYqG8oeL+1bOPLCtCz2O
	jClsd+U3z5zMJ+6+GAEp28aZ6se2QKnxgvZfHEoTcirkuszzTym6cTXieU3zmOlLdAEQIZ
	q/+B7uODERkQjZIRdBQGcx6V150z5wA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CqIjs2IQ;
	spf=pass (imf20.hostedemail.com: domain of dileepsankhla.ds@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=dileepsankhla.ds@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762423521; a=rsa-sha256;
	cv=none;
	b=mPVhJWfYjfNTf+/C14l62IPtxeL6BZEDQ6PRVr2AzwWj6vpR5ZCuPsMVA2ILzai8eN224V
	Gx7XZXjYqCOzqq5MwSclhaJq0G59kIqxu7TQcM6N0lO5EQUf315FLh3UMXOKjUpnEWU54H
	CBJqdMgAKHkvZSQcJwku7FZFEfGlBxw=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so1409669a12.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 02:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762423519; x=1763028319; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z9SBcCPeaeM8jmEuFyY3d76OUpSiPVaODHhAyJ2j1XY=;
        b=CqIjs2IQWQ84ZNVYxZa2dG5nJUcBpNP3xnE9E3ffs9C02wABlU8RtLcXjn3FPm+4sy
         xieDi16+KpsS19dUhU43GnaIQE/lSseFe0uAlDgehNN3oArXePt/ijS5rglh5BWSLi5z
         sj+4ht20WV4XkftZL9xQSRMR+lnBr+MQfUSv8mFoKwQg3EPhpxqgbe001IsnIGMxTY/Z
         8SJ4Jz9n8vbnC7mljhb3agiJvZIUV5UaM3eaaXIUBu/tMptIqJ+SCJdK9tcn01Ny5pXK
         skKH/xFSHMX7pRvyQ1eLtMcHOo7xRGaIy45VV68B52Ts98KnjxgnmYCsDx5bOXG59cuE
         VjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762423519; x=1763028319;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z9SBcCPeaeM8jmEuFyY3d76OUpSiPVaODHhAyJ2j1XY=;
        b=ckanOxkYc4kP4Tre8pkZmLCyHwVUjNtupLRHtJ7RxPbIev18b7gz1nhwi3dcH+hMFx
         WZHfh7NCKZRkk7MjqVc13JFT0crbVkJtKTQbkHmfpqnqFgostJsqWbvLQnnadgWWBKDN
         5okMEU26343H6PlqRyBGjNrGeh11Rt4NyXDCbriG5Vw+7cP+bg2h2Go31c/EsuVa4uNp
         3FKmzfU6LBn50gUACCu3sX9BvIqvriaFKanCdZi/JVITxdxquis4SfTJip//p9qqSUks
         rUs2ek9clKFhllqrHsQPCa1jGn3D9Yz1UesQ5T4NguEzU5HEPiUTuhp6MnF+IxGDzODw
         lJww==
X-Gm-Message-State: AOJu0YxnCL+5U+1ASnG0l6qcbUKaYccx8jBVjDIwZRep/TcsFgxPgMDr
	LlSA05LhtY4qGO3O9pOwqd8wtCXPhFBfekzqQoVioE51arBdMbiP6d5fanpIt+8ONyPQILLtIIo
	eO5VPL+la+m5MORQNm0KEe7LI2hKTZ3xZAcYOoss=
X-Gm-Gg: ASbGncuE0mAEKoQ4dFnRrmBI92q1AAyqOZwnJl4wkM1Zd3K8PjnQtUGbJovCXLmMaVi
	kOVlUGVVeKgAaey6u9Gehdbx/jgoRFbqNOFS8qLNx1bT6Zo58MJRHjpXQNWxNMFZ1P9e6Bsi22J
	GbpblIIzDCbP8BEIlgpaNt1KkkyJ0DkHWpKKS4r6p7blqRfBD/u6bZ8RHDYBdd+f13uSnNIX74I
	Kj6/5NkHCV6RMrrs7KacwmMoRcAXOUUxLkgdw/TTCpBRo2Zg4jDxrBk6EzVUHyO5zTIm8ndLvSw
	jDqPiNgRdroSMVDH9jApg2IfZg==
X-Google-Smtp-Source: AGHT+IGe+sITW7EViPAVEP0paiHz+gRzBRFhkCWl5QvuF4/OUXBi+vRvX2YBLwHzJntVrW4DzB00Ptw1LCFAE4hHslc=
X-Received: by 2002:a05:6402:3553:b0:641:2cf3:ec3e with SMTP id
 4fb4d7f45d1cf-6412cf3eeedmr511684a12.11.1762423518683; Thu, 06 Nov 2025
 02:05:18 -0800 (PST)
MIME-Version: 1.0
From: Dileep Sankhla <dileepsankhla.ds@gmail.com>
Date: Thu, 6 Nov 2025 15:41:52 +0530
X-Gm-Features: AWmQ_bnIbwi2CybsHNWHjzZRoRFY2_e7hTFYFWfFID5l6rYIL9fGocbZD84KG-k
Message-ID: <CAHxc4bug3HOPd1i2coqyJz_gRNGyeCpqiYo0UWV-w6cAAtD5KQ@mail.gmail.com>
Subject: on solving syzkaller bug in __filemap_add_folio function
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DB63C1C000B
X-Stat-Signature: m55e7gkxahy5ef9y7aob735kgf7wfqd6
X-Rspam-User: 
X-HE-Tag: 1762423520-822116
X-HE-Meta: U2FsdGVkX1/Nc4DsJQ9HMjo0BEWAGKjJyO/akRCllFe7Rj3HOY3+faOkq52yM/qjx5vyWnbZX9t2bCj5FUxGaPFAEs3y94nU3VvMlAoI0Qmyqob7rvJtpBVN9EDrvdALQJL4bj6FlxncyVofKnUklPz/neEABUqI1NeIU20GrDzqSltUPcs7WvCmjOiorN+D9+9yeN5hEyP7W9BVNys4z7uNfgqKjQyTRNxOZJG+XLFXmx58fpt/5uQyoKJUsntrewjuNHjA9oQLsJJbxziwCHMWNXHrMzeXgFNyze9ERejmQAaf3IkkRxF9Vii8H1h4p/4FFikhWEkiH2yeqPmXOlF3Ffw4bhMaYuIBUpKGHNdDwSKGzn+nRh0KRa6BHEtOA/Ybp3iEDSbRNe31FtTNk86zRRuiXWAXC3JVco25F55othnCQrI72MqPqHcwF5CY6N4DUchebaIiLJf+mZQcHqGXOrTtjQEGlGHDGWoEZPammyV4uf559KEj1JJXJYm0zuZZLqO8ew/N7ci/2RjngVliIDFoPcRBlXz3pjrW9dvMplR1ye2Tixs98MHaTOId2VUIN4VlehrZQNWmYL6hvbODAZ81VEX4ykwSKRQaC8jNQmwNYrAZU5eJEcg9Ju9NNsAd+lV6/kiG5nzpnvYN8o6OzTDiFoGp+vpwlmqHx1IUFdbBI0YbOZERnzS2Zs8Si3dwebjihL6+xEhW0qoD+JqSL3/qo1D6rndMHRuxaI9O3jqJQy9fC0AV8PiXdLBDl1wKynEBcuxxg51MVPwmzzZUt4TcFyHwJag4dg78vVCVEHJzcBZRGfAXThs0zYcMibKqXkP1JFaH3VLiTyZoTs+QcC9eoEnggOImSe8gWrpzuAsy/RX6N7UU0BwJh88iNPmE9f2jU1oV/7eJ5fMhNhzY8C7aqvVK/U2wPd8aCrWIl0MwRC/CPMvZn9nB6gVhsDjhkxbqBJ2V4V4JjD4
 OUYLCc3n
 XJf3+53GzYbm0vZo62LZTku6aOmQ93711DZDFxsJREjtIBWlN1nMTn6BsZV+p0/yjq2cHdSB8pqEUS3LBl09C3AVJ5FeqGv4ooVlwPxS/ELnvT4aA2b3IOp1BGTQOVu5FViviG8rZEfrPNOq06jKrv4u6OP0Pj8CURJ2hBS+dsMJv7Apyb4bul9snbe4ZWQuM7IbL+BHMvNa/yXDF5ii7azkJfyfagn1gfhMbb85/NoV59ibVad4diD3dQfr3j1myJlLHOvQ2spGToxXglV3Ib8W2XuRopZRL6JDCG2tNut0gNfolaqHvdor41nzWxndaE/Aekzghus6Sm4MfTYmDGO+7YznzQvh95GbEe5RlYQ7O19v+aNDCFeiG2vMU8L8ti9L9lRthCRZy7e6ANmz4YpWvwhqWQq82i60Vylk6vCgFeqGmnzoRyEf+oIMBWET6YsQ4AJYcidLTQSBQWeCqrH3HIPkwP3Ht4jm6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello everyone,

I am solving my first kernel bug. As far as I understood, the
syzkaller bug I am solving (please see [0] below) is about a crash
during synchronous readahead when the folio order of the allocated
folio is less than the mapping's minimum folio order. On debugging, I
found out that the folio order was greater than or equal to the
minimum order when the readahead was initiated, but the minimum order
somehow changed (increased) while the readahead was in progress.
Actually the set_blocksize() function (inside file block/bdev.c) is
setting the new value for minimum order. This function was called as
the result of handling ioctl() system call invoked from the C
reproducer.

Both readahead and changing minimum order are done under
mapping->invalidate_lock (readahead acquires it in read mode and
set_blocksize() acquires it in write mode). In my patch [2] tested
against the upstream commit [1] taken from the syzkaller crashes,
during readahead, I am acquiring the lock first before initializing
the min_order variable with mapping's minimum folio order. This solves
the original syzkaller bug but another crash [3] occurs after running
the C repro for a while. Actually this crash occurs in
__readahead_folio() function (file include/linux/pagemap.h):

BUG_ON(ractl->_batch_count > ractl->_nr_pages);

The condition is being true during runtime. From what I understood, it
is impossible to have the current batch greater than the number of
pages in a readahead request. This means we are somehow altering the
current readahead request improperly somewhere in the code. How to go
about this bug?

P.S. The same crash was reported as another syzkaller bug [4] (kernel
BUG in mpage_readahead), however, its call trace is different.

Best Regards,
Dileep

Links:
[0]: https://syzkaller.appspot.com/bug?extid=4d3cc33ef7a77041efa6
[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9dd1835ecda5b96ac88c166f4a87386f3e727bd9
[2]: https://syzkaller.appspot.com/text?tag=Patch&x=103ee342580000
[3]: https://syzkaller.appspot.com/x/report.txt?x=14cdc114580000
[4]: https://syzkaller.appspot.com/bug?extid=fdba5cca73fee92c69d6

