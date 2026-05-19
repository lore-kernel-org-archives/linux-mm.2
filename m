Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08F0CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 03:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA34F6B0005; Mon, 18 May 2026 23:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D544F6B0088; Mon, 18 May 2026 23:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69F46B008C; Mon, 18 May 2026 23:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5FC06B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:26:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 578EEC03FE
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:26:56 +0000 (UTC)
X-FDA: 84782732832.27.72A65F6
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id E9121C0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:26:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779161214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcH9dyUZAgBpxTeHCfzwYtxybVF6510+0D9SV3UX2cA=;
	b=WqMvJx4BAI/ov0ki9Fw3AEKsk8eJRDHhoXeGZgsuHb3Ud9g8xC5kfl/YlorhkpN2Eu1/xI
	jNwJFITF+s7fW7bY8liuFtQyQTUpBMyhuaoQhuPc9ArVl3JWn49gTOZ8R6u9daznYieFlo
	3YHOEmioowBRL2NnTkNpNG0AvUMeUAc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779161214; a=rsa-sha256;
	cv=none;
	b=FDIIqGiRyRXnoIhZP5BcqgbwhtufMQtJC6Qf/sZUI6h9RqDrZDJYLu29K5ZjcA1nk3mJp6
	m4qeMXo/JEnGoPfRSfnEMdZAeebrXHGycBscpsH27bx/EPk2hwJzMomynOol6cNwsbO73y
	RSNATlS1T4ux5zI4Kt985SRr2nG6qbw=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gKKpf2pLzz5B11N;
	Tue, 19 May 2026 11:26:50 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 64J3QbYr089014;
	Tue, 19 May 2026 11:26:37 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 19 May 2026 11:26:39 +0800 (CST)
X-Zmail-TransId: 2af96a0bd86f35b-76c54
X-Mailer: Zmail v1.0
Message-ID: <20260519112639059-0_pavH4H9-HrJ04sR3zc@zte.com.cn>
In-Reply-To: <cf3eb256-777a-4cc5-b60d-4a784a676f05@kernel.org>
References: 20260518211033478skXlc-f9a1R-UguMeRZ9G@zte.com.cn,cf3eb256-777a-4cc5-b60d-4a784a676f05@kernel.org
Date: Tue, 19 May 2026 11:26:39 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <ljs@kernel.org>, <akpm@linux-foundation.org>, <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NCA1LzVdIGtzbTogYWRkIG1yZW1hcCBzZWxmdGVzdHMgZm9yIGtzbV9ybWFwX3dhbGs=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64J3QbYr089014
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Tue, 19 May 2026 11:26:50 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0BD87A.000/4gKKpf2pLzz5B11N
X-Stat-Signature: 1di5xyy4twdq5proucmyjcm9db894hr3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E9121C0005
X-Rspam-User: 
X-HE-Tag: 1779161213-358863
X-HE-Meta: U2FsdGVkX1+FgI8NjzP05VlNnLdHddN5IjHwH9vSDZn1mmhy3ZLRHqBuRbqEeYveutQgBVSKLqDnAD80eLPmiRXvQXhvMr8X8CsZ6Wx183YWt68sy4lYoh+DOqmRSnedapvAxxzMzYrzAmMBN8EsTIXcbjWVFs0JSz+8h6SUciD87LDYjoXU7Y/zdm+YmaRadOaKXGLb/3eUaUgCkgsHohLLTFPZmNnGl/FHhiiOM7JutD6aiz5L30HTjgt8PHk9wzypZ2FW6chIf41DYGGwoTOubw9vkcLpl0sHuCULDtrbrIEu6CBqWN4wXDBO1B6R4pzKyshdGZLILR11a6aZwwsQEddhDZoPDCGTLfRrPWlZPqbpkpfUwB4vYXjtGn5wQBLcmINC8WMH3b9DW0nWRS/mbbRlyYaTmU73PxJL2WNsO1ITkHRFzGmQkWSNvpV+SYJ3ONOzIrOPOT96ubINzdKKEWYlbygpNLkbaEMaUO6MegcBsfC+ULA1x1o+RHaLQH3l4lO6LnlJB1d5zQfXEYkx8VQoBRBOVd0HsmjyHWpVZo3t+MI6mNFqtEPhF1dEyUtTaQ0nSLU2SUCp8ASQainHdnZDlljdUMj/FkbB3/46GcYxDLD4lgWmeuQHwhaoGZYZWGXJx+qvrYi3UP+Fz9zMCR9YDmp7G09WvaM3YNWm0x+TDQG2LjoZMWHOv15Mh1qQOxy5tc9eHmgYLY+p2TXReWQDXXQSNm36sAnY9d0/2mlejIUizVZRSp4+F4OD4dQsjYeIIfBERgy8oBTwOjdsqyZBcelKM7+OBNYXE51X0D17ymqcpX7SMUMJdOlEos/B5LAFhBgbXw7Rw3slShfvWsWzLVbm3TumC88ruEEwkQw8PMmTH3HDApBJNrnCA0ciyy0U9Vp4v80ReR+6Giw42zN7lTr51b0LtV3H0ByeNZz+ChE1sk04G02g0wwMo4JiPEyXBBqe9csChNm
 EmMwnYNE
 549M0tyYcG2lZQH3TiF3ohuTjujH9WlcAuhDSBFeLEAZbRUHiTlCQgKDmAIU9I0jdz+H2XcJ6u3pe7JzK2WmvlcOGHXSH9bYIAh7MAy7QMPL2V/GonrLzUVBUg1DrvoMNitMO77KlNgELn9SwyGwh3LNzIfojK75qoeznDxVLic+cQ1/Cja2l1T5ldL2HLKd83eZ1GWWPLfxCRooe+cGWpqCKacv/ZsEjC4hSRIV5otB6/LV+48hGxXsmoD3E6Nz5YXfE7YAu+jx3twtEZ/i4DNpk0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >>> This test runs in multi-threads, So there are not only one page from this thread but
> >>> also many other pages which are mergeable in all other threads.
> >>
> >> At least the test did not reveal the problem in patch #3 :)
> >>
> >> Can't we just use a single VMA (e.g., 32 pages), fill it with pages of the same
> >> content, let it merge, then mremap half of it, and then migrate a page etc?
> >>
> > 
> > Yes, a single VMA with multiple pages works perfectly and is simpler.
> > 
> > But I'm wondering: should we still support a multi‑process version (Only one work process
> > do mremap and migrate, while other processes just do check(PFN) ?
> > 
> > 
> > What's your opinion? I can drop the multi‑process part if you think it's unnecessary.
> 
> I assume a single process should do, right?

Agreed. I'll simplify to single process only. Thanks.

