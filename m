Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79A5FEEF35
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 13:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591D06B0099; Tue,  7 Apr 2026 09:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569746B00A0; Tue,  7 Apr 2026 09:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7336B00A1; Tue,  7 Apr 2026 09:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7E36B0099
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:10:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D347FE2526
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:10:53 +0000 (UTC)
X-FDA: 84631794786.05.03D1F29
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf07.hostedemail.com (Postfix) with ESMTP id EA87B40015
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:10:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=AP9yz0zX;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775567452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpD+Khx1oqJyZimWBbKtEZ26IJw/Q2XHeaRqUitzsBw=;
	b=kMn+OHuTlL+7TH/GY1Z53sHB/6pv5XaUNKXoe5OhwGZpjzUzbzIrHBKVNtMy2b0ybv0OLi
	kx5+e+/vXG0wHwL6opruv3ui5Qs9wyOl8mRP7B4XlrJv0pNioAPtgdSjIF1yRkP/iR+39C
	KEgDAYNkfvseUE+PQgmkZvEnLEHuR+c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775567452; a=rsa-sha256;
	cv=none;
	b=55xpbHOwXrox6ltaEk8+zlBc1kKzyOPn38kSBfRJ1aVE5fXAGkk87ywULbVVLA3ZG2FwlR
	FV7BzF4cVTIVlkR3WPycaC5MZ0HKZZkQr9YrVg7To5Yg1DSCgk19gjvbhBFHLuLNUFhxI1
	+BoX9g93jqlh6WXsx/xjgNdF9qrq21M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=AP9yz0zX;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id D0E3CBE6B0;
	Tue, 07 Apr 2026 13:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775567450;
	bh=KpD+Khx1oqJyZimWBbKtEZ26IJw/Q2XHeaRqUitzsBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AP9yz0zXGu2KK0QDufayJqpqDuM71EYdHKlEW6damrf5BwzmPBa97Kw46ITbFTgtN
	 F45IKIgGzyLvE77qoWJiIxTll3ffbvynEFRFqNLTFK1t7mQld67YVNsSGjoOebJGBe
	 WEhDJEdzLuNr8ZAUMz/Z9poZCTDWNbyeGF95y78E=
Date: Tue, 7 Apr 2026 13:10:48 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 0/5] locking: contended_release tracepoint
 instrumentation
Message-ID: <adUCWOUR052gM5xd@shell.ilvokhin.com>
References: <cover.1774536681.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1774536681.git.d@ilvokhin.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: jcibd338rugo5ygp6nesxkbnxjpcg77s
X-Rspamd-Queue-Id: EA87B40015
X-Rspam-User: 
X-HE-Tag: 1775567451-288628
X-HE-Meta: U2FsdGVkX188EvfNKH44nA+INEX4alq/JSIYHogvpmP/3sYz/thioRaYqpNRxw6xtSwuOjKK4Ce72GQeKBy7EuIOS4BusUMlzHqKH7tpokXTWZu9ob3AwT7MJtxu2gP+GkpOEIjybt3ENelUKiPss7LRZZ3Aaz78K4XqI9O+iHCeSvDbEwRy6QzDSjSfwLCw5HCFBC+d7LXMAzK05Oe6lKwiAihDIrC3lnKWvFqeOjFelHjRmkLM5h8ezIJP9/zLR09cuWdsYke7UQaLkWKfiFXbSgiLtSWYbLghHDfFTM4LCEPmlJC3jlLta9di1JfR5s+YVNWBXE5UEFammLKd235MqUEgDsSW8RhIBMNWkz0kxDF79OOckCgHHHFhxXC0CQLXo+l5QJ8UkTZDHZQ5CbxQcD9mMhdom6lVHvsoTBnmFnUwk1diYirg5/H/YcqcBf9RXxLVnHC5ICx2bnoxsB0LMlmLWTFQkdA7om3gQCEs6G7qi5/TcntBDj7Dtazj1SRlPVyuLxlq47O1En8nI9DE6u8Cr2ZZyGK9UOHRbyHScovwB9wnC8J03duibsSEUMvSwhsYv/Y5V6y0UkybSeLiz9ZH5YP5I07Mz3Ic+Bc0qhVoW+7eYIYUasLWmOk0bOx3jOzVbkDzhiJb8WFClchPwT/sKYRJwyOpLgilxh/FEDPc5QABur7jn1R9pgv7ILRFkto4yPRDMlbE84W1o1YOvFbnTfxUq3W8z1xsZxPo0flVXCMKBddRiDIRLEeYSk7VmGA2MnhdQCDhty84lQ4QcHIkFr49dE1FQ2hsAlfYZvdfybHLhLsegXYMMEujt6o679Nk8gBzI6Yf0gbgI45ZTvzC7OR9o6N/ayWIB7Ep3frtwVpVJYkE5QTvZEDCuWoQAP97rPZl4urMQeklgfTo7WkbFQCrYmpdjSlGkufdYfc8oV/WKnwRHlGFIpBxPFke8+6jkhhdyy5vyAV
 YmoB21Re
 eScNJulNnACJfkkMb693B4dBWydrk6phd6xUdk69aj9qkn1qPX8Bloz0NIrYhIJKlF8QQhi/ipTI/22Lh5bl+sWl/FhLiSGcXTn9TDSazJftzaRc/rseHpS3eRhZxaAt13L3c+WL7OL6quXjgUEAUhyMAuZVhEraWnxeKpjLrlH/2k3Ne0PDheiO9rEiEgUPwhCXuvG7jtwqKbY5heCAAVVA8ht6yE0XId1VVbRqkdvu8uaSedlsrWHhytFpy8MyGHFaFzIhQy1wfHS6jq8ATyw0UDt/dNbCAUbfD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Just a gentle ping on this series.

I'd appreciate any feedback. The spinning locks part (patch 5)
would particularly benefit from review.

Peter, Steven, any thoughts on that part would be greatly appreciated.

