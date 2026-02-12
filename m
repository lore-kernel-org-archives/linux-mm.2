Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A3DEE36AC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E286B0088; Thu, 12 Feb 2026 12:10:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1B56B0089; Thu, 12 Feb 2026 12:10:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F42C6B008A; Thu, 12 Feb 2026 12:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4856B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:10:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C538714020D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:10:34 +0000 (UTC)
X-FDA: 84436443588.24.BC06A46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3221BA0007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:10:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vD5hjra0;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770916233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egDP+GNUqpk7QyEQK7XNmj1Lhup3j1XGac1JCewfJvU=;
	b=z3BX3P3ESLOyvBUseANpOEinTjOq9UBk7gj40xk9TIElLnwrIcsmlJrogZN34dV3I70FgC
	CK/D7w90P3PwkV+5oFgCuOHEkoaOiG833vFtMOYuJvBgob11ViTBJJF1Hlc3zQht9PUqRn
	lNaXPqVyvTw4b568CEjQZzmEfvWEjh4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vD5hjra0;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770916233; a=rsa-sha256;
	cv=none;
	b=4H70W3XSMEVlUsBO6pfXtQKqG7G+lvmA9QcsJUoCYOr6g9gAQ7DyekGX/QOwuqvxw6tDy3
	pveGB1R8A6W8QTNRq7UNzZmcPaF5UEriBvJiuqLu8XhCcW/Fu7DNykpvrL7/iOwU1UU187
	7LIWWQBufrT4nY8LTsq257wGgsbJOL8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AFEE40AF6;
	Thu, 12 Feb 2026 17:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AC2C4CEF7;
	Thu, 12 Feb 2026 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770916232;
	bh=egDP+GNUqpk7QyEQK7XNmj1Lhup3j1XGac1JCewfJvU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=vD5hjra0cEokyYJeRb6OgWF5Tl6n8RNf6aCRwAet21PsUJd7RvhrZAYg6aPTW5F/4
	 LTE7ARMFtocT5pIviwiD6MRb0o/LJutXUi6NGBZxIGMWGj36KAyfcC5B1przUeH2d+
	 G7grr+ynu250ondqKo6zCC2ZCwCCPawq5SqI+8WoqiX8U72l2bUCVsIlTON79/VwnS
	 +vsluxuNW9iZV5ea/6II2XPeN2X17Impf/zcDfI26rj4E6D2Um04ODB7vHRQQ7l2Up
	 MC+JtJSlRt+K7P+3XkPfWChRvzI/06u1Cv2qptutGP+11gUXVlhp85MPFafRgSlgpM
	 gAEP616YFutpg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will
 Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Mark
 Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
In-Reply-To: <aY4CuCtBfkWZne0d@tardis.local>
References: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
 <W3U8SrC8rs4Ivq5fjTvV2BD2K5BO4RxRg8tyWuntERIaS_RqDgtfBq5y0zcnazWgNJyT5ECvutnzV9d2UPDzOw==@protonmail.internalid>
 <aY4CuCtBfkWZne0d@tardis.local>
Date: Thu, 12 Feb 2026 18:10:13 +0100
Message-ID: <87ikc1ubuy.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 3221BA0007
X-Rspamd-Server: rspam07
X-Stat-Signature: bu58bs7en3nmxbk7yzt4cdobgz4eifqg
X-HE-Tag: 1770916233-509036
X-HE-Meta: U2FsdGVkX19YhBx7OXvsUNtuUQWofSA3LePa7N/0hCUXdaLGSLaeh+5E9MQODoGHV0frSFvrZHIWdxzoJ8JmYoNnmyftwGyP1CPkrgSZiUQhu8uwx8VBRvPunOSVSEZYbUKtxGnRY7ctmE7WKMEXL9dh3eY82MfigkKub1pRLr2JA/9cBhBuDXgD+CelIbsCBK3yLp1nnwQ1+C9XYRMmO32EMS4TuCInyr9Yl2grYF0qXmTQQHGlj1A72Zk3Vc773YLmcb8WviDb5rrtM4jp6QCYz8qwX86rJEeuvdqUqna0pEg69hT6JYzQ22Rfd3T7/S6YLiAg3sDeh4Vw6NZOqL0AblZRZdE2QrPBIQIOiXUbtM9ybBk6csLtxCXdbEySqrzM4uBQ1/U3KDn9h7vnUHXwZfQ1QBcC2ZacPOt9KDjudfEDVBKOsTVcjB8S5sjeJMXyKNSdvK4k6g9blyWnHko+Sa5vT9SVuOZP/vULCEqtnnwgapJnaAijLjXi7doqRhdR2kdiQtij5IqQe2cVdj2YE3jqHwAaY24z4hlYjSeMy2wtIoI8LCrbu3BZL2/GJjhYuJWGEAugEOAgky9yyxTr5IQ7CHsPsyZB2eZSGcsoXhKGxYKHYAJbPFduUR3HczFmteT8dUPzHD9j3yTQ+PxyJ/WledSc1Rd9CKWjbG+wCueXJxDWgcbPCZEga/CIKnI1t8RpEnAp9yoS5hi6Nlhb1vUaDXpnvLS8E0NLBEcSG4xB1AwVlq/mUVAiT7jlBUsnMpyybZdOAHrB4Wuy2yCPONQfwgw3csrJUtTFJJ8hRypOZ+AGsxw9LQ/spVH3RXtAcyJw2c7QvshjB4IpePMI3wqWwcHcQfEke+o02sOyeKtPEK6sVYoEkARwGIv/rgREo+ftN/RDSviPW5bjDJnbOfyUWxjyUBkzBn3rEuTm1WCb0S35QvAyN0OyFINrqPm3qRHqXioglU7dcP+
 52thcTh9
 d5SSynSnVUHlU58wmSylGl6GO7SQfVAcSg1h/1SEYUjfhwhkaaEJ8HeeVWDScvtCAYcU7R1+hM50k8eHeda4U+pskBaXTPoBikRF9SSojBfeuD2g4Mnx0kjXjtoOmhLwqDwhGepAZoLzylpSwYB9MIV6flm9YgmRf00oj0v/ByiqHvpS7Rd0CZKKOpQJQ0udYk3H8XNwoIfT4l9J4MgEQs3iO+7jMEexad8VZPrH97Q+bwZPSzd7gpzJOf2zDRVmPPdedwkijZvvCPQlnhmdt2RoC0ci+INOVQJBk+Lua7oBN1BA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Boqun Feng" <boqun@kernel.org> writes:

> On Thu, Feb 12, 2026 at 03:51:24PM +0100, Andreas Hindborg wrote:
>> When copying data from buffers that are mapped to user space, it is
>> impossible to guarantee absence of concurrent memory operations on those
>> buffers. Copying data to/from `Page` from/to these buffers would be
>> undefined behavior if no special considerations are made.
>>
>> Add methods on `Page` to read and write the contents using byte-wise atomic
>> operations.
>>
>
> Thank you, but in this patch we still have "the given IO memory" and use
> memcpy_{from,to}io() as the implementation, is that intended?

No that is a mistake. Please pretend it is regular `memcpy`. I'll send
v3 soon.

Best regards,
Andreas Hindborg



