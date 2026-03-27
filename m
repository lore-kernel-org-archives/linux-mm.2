Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E6B10ED65C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 11:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0D76B0095; Fri, 27 Mar 2026 07:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92686B0096; Fri, 27 Mar 2026 07:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE346B0098; Fri, 27 Mar 2026 07:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4086B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:15:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 417251B9789
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:15:26 +0000 (UTC)
X-FDA: 84591587052.19.6C34BB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 99985140006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:15:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DvJAYh7j;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774610124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7djG6P2tm4I3MZ3kUwor6OV+5m6kTdnBQ74DdYTxV4=;
	b=JDfjfo/8bboSQk8Z151u3Ke4hL+/rYEggL10uFxSYDxTZBy+K68e+BJLXS1KxzU9X5J1YW
	W37HeN7SdPd2UozcNhiU9PHFTuvsgQYwPWiFmpWNt+GLEAB7SMsTRIcAsKlC0yZ2D4p+8E
	xZvbYN/N8oWcnilRbMGBfMWu2TNMffQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DvJAYh7j;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774610124; a=rsa-sha256;
	cv=none;
	b=affhsTi0MsoiRER8diCmW22+rHKTEReEndyPKtlu1Q8X38imuSundS6G7D4ii1GhM55w8g
	JDZKPYsQwx3+y0V1EV8wu7IDTE0bmHxpntl69ehIjhwHNB7gXO4Uz0gkii9RcPDgIbWNC3
	dcgDEMowOUTOE9+M/SbbZdLg0FDKjxY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFF2E61878;
	Fri, 27 Mar 2026 11:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAE2C19423;
	Fri, 27 Mar 2026 11:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774610123;
	bh=/7djG6P2tm4I3MZ3kUwor6OV+5m6kTdnBQ74DdYTxV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DvJAYh7jU6rXzb4YVe/K5X4s419/RuEnx7cCu1w1k7C4j52CibNRtOYmTchNamPoC
	 FvvXj90UvIP3VUoVKN1xC1OXHY9x2YirPEVwOSDtVvecix0GVLGIciM0DM/NNj1PhN
	 AETz5/aec57lc2DgjzYjoUyk4TwDJ/GBZvlMgqa/ZrRItiZtw+AQKEJ5EbqPl/ko82
	 yBhnC+jkwdjMJY94QuM+0EdEuDPJJ370Y5B2b7RJMoOfCcyvhrhH5Ti8UthBFFKFxG
	 m/xPVnSg7eflyxZbWrUYghSq5k8FQSH2LNfil5LZ/VqabdzA6x2bq5/KYBWNKiMHsI
	 nME8Ol1Hka5rw==
Date: Fri, 27 Mar 2026 11:15:18 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: akpm@linux-foundation.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Audra Mitchell <audra@redhat.com>, linux-kselftest@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-ID: <7794ccf9-3a18-46f1-aca6-a61eab77bd70@lucifer.local>
References: <20260218184210.206466-1-audra@redhat.com>
 <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org>
 <abludfGu4upPcyRI@fedora>
 <f635585f-7488-4bfe-8566-1c19f493c6a3@kernel.org>
 <815b2fc9-cee7-4bfa-8036-4b93d1b47b4e@lucifer.local>
 <237317fd-d2e6-4e9c-840d-fc60b7d8883f@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <237317fd-d2e6-4e9c-840d-fc60b7d8883f@lucifer.local>
X-Rspam-User: 
X-Stat-Signature: huzzcmf1cotki5pg5z98334xfftquieq
X-Rspamd-Queue-Id: 99985140006
X-Rspamd-Server: rspam09
X-HE-Tag: 1774610124-915182
X-HE-Meta: U2FsdGVkX18fPDLJqegrMXxP+V30vwZJOrlBaAmnGjEheylSVIeVSskNjXuq1ngH17dlCBNDmsEvPxT4GiMzhkq5HsCpZBfoR9LegyNb3mP7x+DkQ1VWZ1Po7tAY0iUtM0qxkaMdiMO4s9xYSMmGzyQwIuaUW8c4I7uS/9+7fZaruQxsl+4YdoUbXDYYM2e/B5FlHiXvZCzJXiR/4mkNAZ7QBg0fh2Zh3pe1JVhrVCfUxndd7YrpLsj7cb4YKMZIlIzXPEb4ZeVFXCI13O/f3wbA8wuDGga3QCYdPs8z6xh2JfLeu65UTiqpayGNmhTh6yzH+yR1mS0warXOmS0KRuMcTx+QgsauJCDjaEIIvmqMWC+XadBdqh4JOe3OfU5N898lZiLU6qDXBr0Dsgj0nyEixrKFW0H06MnaV2oQ5jqQFuZdhpaqP0o9i4E49UHBmTyuV5A7Idz6uNJTDepFudRO1W1yDghly8W7+jmKNrwgt1H6pPMB0Wgc5idCzM4ZO+P5Kc43eGNIwYmwqDF7cgibgAhuzDQDgmfTSwuKBQKYLhkQYo9k+cg3WQ8Pvi8NtAQvRP7+xwu+pE8XtR/9OIuZa5EeXPFmEQdScMK+M6eRf+SMqaRRS/iY/gWzsJ+MT6jPIUC7zgIakzAc/yZZxARYBAoJRNNOM8JgxVmXMfptmggih+Nd9232SHfREhvCf9zwlmJrGxVTuKgDS3mocPZ35NkHfV04nY+lIttzOa+B+20J7yihEIiLeWKADRvpNezDILgloeHbPf3f9RG34X1NRQZMvHkwSeiNVT8HIA28EJ7TSoqlr254GtgZd5lbeFGbvi49CZfOy+QBQ0rXaWEn/mjFrTlUM9djrsL/b479QUrVhbztK6PbEPSbw1k42Yzif/9FFV9t6Cqbs0qUF9WPSbDlGuamegDr08z4YEj7jg5Xz5oUav8/wvCsrQuhl/9ITENQHjGPjsfHVop
 XT8+SZuI
 kQ70fwK0u9eOGx8GwwdrDtQQpDKOBnTeIn1VdfIaIIswiHYYj5YROrZPrtyCqXvQj5RKN3Ylwiq8hZ/zml0rMG3nAaPSsb8KeZBRbAQaRDsMANzIW+BaZkrdYmBGHaF47SR5H0co9YfTXWTnrUtLnpk+YgAag3cCT7N4jiS12I2EpGeSbKeFtjizuRUZPVGwqfbQP4LJ1MO8nSjhXcLU83G3CDX9bGkBst0yb1XHtGeYLBSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 10:58:30AM +0000, Lorenzo Stoakes (Oracle) wrote:
> BTW, even _at_ the fix-patch commit hash (28edd9c5a25c) the test builds fail.

Ugh sorry wrong commit :) should be 9652b82ca9632.

