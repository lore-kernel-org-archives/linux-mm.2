Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63DC7CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C903F6B0359; Mon,  1 Jun 2026 08:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68A86B035B; Mon,  1 Jun 2026 08:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E746B035C; Mon,  1 Jun 2026 08:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A77FE6B0359
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:08:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BB539079A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:08:52 +0000 (UTC)
X-FDA: 84831222504.10.0CE3930
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B16B980008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:08:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=etuz+XML;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLN2nxCenCFriMHbgZyJm69uVh8thx2Q/wX1arVTgj4=;
	b=ysxfayQVzwAoN5251yVOuJ9i9lsnzbq4A8ZuyrPev8g8NSThn7doB0jZhXOLx5rogAzP7w
	6+kl3yL4NMFcuLgr9zS/tZVx5HOn6noPhYmA1g5WSDmJg8/KGDFPNvaAP0aEiKWo6Ytsgp
	I3YV5rebD+hj5/dcd+cB9TcAuEumX9M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=etuz+XML;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780315730; a=rsa-sha256;
	cv=none;
	b=gqNO3TYND4Bm3hqQR2vJ7+IPTELtNHfDH/ZzuEeCw8bIHY5Z9QycnqhF7ST4DCrlzP4YvH
	QfqpsxVCE1GHiVMVBDSMvdmI2C87zgPndHFrS3IrUOohYUgB2HxIVApqBAKwHZv51YmW4/
	zKjhB9zsFcvzO6cY1XipHKVeOvPiOaI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D6A4435C0;
	Mon,  1 Jun 2026 12:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D831F00893;
	Mon,  1 Jun 2026 12:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315729;
	bh=kLN2nxCenCFriMHbgZyJm69uVh8thx2Q/wX1arVTgj4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=etuz+XML6WCHoCiD6XZWDdtBmSvYoflYOOwpy3l0IcSrWBqMMsconlpV2HkKJ2/Du
	 v+/3YyNCA2PIRV+OGXcws3jTDOkhMyoDKYW0nRNyv8RYufZEpwplNpN9lXifvBMOkK
	 SkOldw71OnXelPchHVQWVcYH/O4Tqt58tPSpPDQ5dgH4cFocz1Dqtdk13+O8UHszdD
	 QW1BRMUl1adBZ1kzAH3ZySXT4BfdxDLXpooMf/zqabNi14LAptzE3wcy6PH7aSE+VE
	 NhxpmTPXnNe7o09HePI0qteYo5tk5km3nviSGcTJic/L5YV4nrgZ/70+oxWwPalpRt
	 zSZTfOrsAB+Fg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v4 01/13] liveupdate: change file_set->count type to u64
 for type safety
In-Reply-To: <20260530221938.115978-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 30 May 2026 22:19:26 +0000")
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
	<20260530221938.115978-2-pasha.tatashin@soleen.com>
Date: Mon, 01 Jun 2026 14:08:46 +0200
Message-ID: <2vxz8q8yh38x.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: qqcyq878kmzpasf3bjnadgbrfy7piajk
X-Rspamd-Queue-Id: B16B980008
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780315730-606069
X-HE-Meta: U2FsdGVkX1+4QaC5RNDif8Tb73RyRdyYM3/oj8nvBXffT3bD5T02IF44/o1dbyOFe5PQdxeSukMX1tJRwihf2yc/3tAK++AREde/Yo7WOfgKRhNrWfDQluUh0Rd7DXd1wTu+ul5nrhP2Fd2jrCobHcfhvSl/kkAazK1ne3/xYeEnS9S8mii81c1eT0ZYW3Ehq/rnC2sxLhDypMdnK+QO4Xktf/1vXNE8hR4jOKxRXKbgfgdhDmGhvATOiKTT431oISRkWZGPlFn9VYTUFnlMEsU7UgMWB6b1X19yJLZ2IJJf7Kc/YgQjAwDz/ut4yCAHFDw4LDswXbbHsWT0A03DqlfoIitOuLMNenx9F5d9zRNf6Ls9esL0S6EbIz8Bt7vSGowuThIR+ty+k7e1glD6AvYxW7RbAmbEqdwV1CHNIxPweT03Qt9Od7DvLRjTxk1oz0aOYQXxBwa1bEFkhwVcp5Gvas3SnqmMooNxXe7h57UJKNmwyFEOgALs96Uz+n4J2GEMlfHXColIWihRPAvHikYwTtmH7IHQHJNihW1a+lXawcaiAM0dHP311szJYFQGU8IIIOPH/PYTfo8lCu83YdDOsVxPT+qz/ycNzbZNHw89wLJoTAjHpJB//AVm0rrid63i3NPWRaGNkrcdwPwVj5+ntUWVc7G7RbvXzoVFICA6qC8tgt5HuWatohzGJTM6AtrdWoz5LEcih4i17DJu0Wg0w6zwTIvOFdjJAtqVndMn+Kh8lKY2PwnJaJpC7w+vGNssjZICnYypQM6gOhfN5c8J/dfZAHTfVsvWAtzrCuF1W2mmnyRIERsMBGSz2mmaupoOXKWOxXLrPOyh9btzL5sJMNuqGJAWQrX6gQzA2XdWyCRCJYUEyNwuW4FJ08UgQyKBILgCfjMfHwNrQj7ZMRz9iVHNH98m0CRBcfD+6SwcELvjkC4C64vuH4XJlE2aLCV+0w+K37XcCQAO21+
 oZJSAUN+
 OMEgsMjomqOoDOIoJ20amfN9ioaR11ZERhNDPM00Qr3T/0gMlsr8C09DgU9WoadYU++eSSMMqEOB4yYrXChO25KCRuyGDEtJonqmJZIQqz5/6Rq1T7ENc2mJHkiDobnjSyfcIO4ztvsvJR21+Q8k+Z0klw4VKnsDqcBQeto39f/FciF2vTTThGFuoiMy7PoOoaxSqDFILGyLukVELdSa9F8ORtV+0wyXGVN9TF3XPMMUmkt5XaCkV+F2wcRMMNxuuXhwoxc/cBRG/KvfGuRbFYGSdatTASTQ/MRe4N/0HI+4oZek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30 2026, Pasha Tatashin wrote:

> This improves type safety and aligns the in-memory file_set->count with
> the serialized count type. It avoids potential truncation or sign
> conversion mismatch issues.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

