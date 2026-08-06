Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE47C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 00:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1BE6B007B; Wed,  5 Aug 2026 20:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682E16B0088; Wed,  5 Aug 2026 20:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599416B008A; Wed,  5 Aug 2026 20:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2BB86B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 20:34:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DED1B140609
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 00:34:09 +0000 (UTC)
X-FDA: 85068972618.12.8A9C5B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6D86740002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 00:34:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AA1KLCQ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785976448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vFBSpNps5ahNANzjK00DJStkD9Rlq2k2GdWcPT+1zyc=;
	b=2ajFAdGmqEs6MjtlgJ/A3gy3u3unGiHfqKWN5EIDNQAlVB0ueDk0/UQLzbZSrAy28t6NsJ
	TE7mLwMdKuj8wMCoL7/aMHDewFHjTmI8DuFdYBEjsLpPOcvRpEexb+JtY1R9I4sGD+JWG5
	laM+NZ+fm5LH5EvSjPGY8K4cvILiHsg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AA1KLCQ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785976448;
	b=7znJTie/SS4g9mNuOoQGQZXHsg9pEM17URsbdjBcTQDOFdkQn4E/AUtSg7gFOQ2uBRGtK/
	WdbOlKnwH+0nwxC9KYCJA7RYeBh6gwIJ3Mnq1QA2idmprUAF6TyD08RKxLZjIkYwdVtQ6H
	7E8LLo2to1S+og/SqD/HD75sJalsvNA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9899060A63
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 00:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A571F000E9;
	Thu,  6 Aug 2026 00:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785976447;
	bh=vFBSpNps5ahNANzjK00DJStkD9Rlq2k2GdWcPT+1zyc=;
	h=From:To:Cc:Subject:Date;
	b=AA1KLCQ23cCUYOU9WN2LYr37LxbZyCKSDq06ew4AE4j+oMm2mse8DzqZvUHchvEAn
	 2OC0RVXWEteVFYqL4CouoOroazX2SVltqppx6DsVo304CCyqmJz9yyxs0XYji2RjT/
	 q+NTFp+vOIQR7ppt4PiemNlbpVa9/9tA7piXVLAUYcAzjfLJS8p4CBIeH3W/9hWudH
	 wLTZwq6mR4Y/g0P/qSGpfgs96KoHjJObraFiX0DNiq6DYg6sbIvNm7AJOiER1mJtlM
	 4YnTlHZZsxRZd3JPbQHLUQgiaTZ5/RLBSo1f18C63iuZpvIeCHF9Hs1UW1laKOoCLX
	 5tdQI8AdjqSSA==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [CFP] DAMON Nanoconference (aka BoF) at LPC'26
Date: Wed,  5 Aug 2026 17:33:57 -0700
Message-ID: <20260806003357.92659-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6D86740002
X-Stat-Signature: jjyoaybuj6h5n7mmuoqg8ikregs1dn1b
X-Rspam-User: 
X-HE-Tag: 1785976448-925871
X-HE-Meta: U2FsdGVkX19yCtGVqxFgfvO+I8pIgGOvsyFLd/y+EFORhvUW8Zvz9wRiPVBM2AZB8OTco8kHYOIp5nvAVsS/Uow3oWJtTsL/2/hL8nV8w1/zIlV5WIYzxA70bQQ4Eb618DZbaRP4aXuaq2jmgC8NY1qoqKlAqY+j2Hkk/5n0x/UvZippl9j7w2ttnhL9FOehibkPAAMnwcmPld8EHl9Ce2ov5eeLDHpPo36Xp2QfIJ4I/QZMUyEoRUQU1aOBG449/3U6Rk3PvMTJdPhWmXtnrdKLi1H5go31FjOuSwg4cUkPsEaxrs5FkPopDS1bQlD7Wt5aha2sCS7JgT3KK7vIoklhYWD08jO92s/JNgDfu2iNH1JO0iZUf4y6vI4dGfaJNzL3aliAqTFe1ymqhB3silrnBhLr5g7jRG1TEHd208SbYoqJ87u1VZ4+Mms6XicNeE2wWcHX85s2JhUb4BtpUWMHagkGKA3wMH5lYIkSdChs/N9/lxHJNRGQaK8OMWxfmVcLYrGHfu6ngDUWaJkjUcwR5P2Tzv0xPJpsjKpaa+rHsIArZKtvlu567Tzaw8YGfTTvQmzRzhMtZcn1Oihzgf44QqUntER/mz30M1keegoU8aVqOkONgqjWmFrF8vhjMO68eECbEE/PCveVF/lO+CwnJa1cPDquuL4wNx6q+rdjc4FlNA3+hZTLtpe+FYhyHAuWwL6R/YZU1+WRPiGsUgZsIrjb4nVwTh/qomMCqOF0f3z7HU73eY8GZkev+iEB48I+F7bxJlo/ZsyAAL7EQQIKrdAAbB//JUiFHvEx1HCrLcSwLgGd9TizAGahKe97HWUZbG46d3/Wg3ZhnceGvfdoUMCyJZeUTtc0Y38VKV5NnBaBVugHbmHmGiR4Jrlernvjdvq/9s6BngjqBhLA1/8DLlR1sNW6fEEsfys6AstdW0Hk9yGlAzrtXM7cGci65SInMCzPE/n0uSLRWkJ
 DADCLG1M
 UrP2Txz2GTc9TkawZ0LYxDL5jUpXBnxGa23AybhffXP3Cf3FmjswmyWKdLN4FAA/3BGDnaYfGHR06kD8ZmE+cyCnutKRStFYzSxaaCbEfNiWmEa6Nf5vrAyN2s6AesSvvxFkvPbqjwdhliZZUX9E8E7VJ6mJF+C5KZAzZpcoiy42eFdxW3ATMl771gWst0VylEPaCr4FHQOWjsN5IOq75pSGwY618IZpcdW6Il3yG40ssHd9zaAojIZjpUsRiII3SYSzfR6CUtLOI2FNUebpn3gfeu80gi+3FMNcDzJEeq2rsM2P4JkDJHVULlg7Zl7x4uUT1uyBVPYS+ONwPXJ6NZ4qsOu+Mchaf7n5A+heVQr2Q3NxYj/vDitmMX9grHU/wrUht
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello community,


We will have a DAMON BoF session [1] at LPC'26.  Because it is a BoF, I want to
make it as casual as possible with many voices.  Hence inviting you.  You could
think this as yet another version of our bi-weekly Beer/Coffee/Tea chat meeting
series [2], or the first Nano-sized DAMON conference.

If you have any topics about DAMON that you want to present and discuss in the
session, please send an email to me.

Example of topics include but not limited to:

- Your DAMON work that is recently landed, in progress/plan
- Your DAMON usage and success/failure stories

Depending on the topic and number of proposals, I will try to give each topic
5-15 minutes.


[1] https://lpc.events/event/20/contributions/2453/
[2] https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing


Thanks,
SJ

