Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F268FC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9686B00A9; Tue,  8 Sep 2026 05:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32806B00AA; Tue,  8 Sep 2026 05:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6F96B00AB; Tue,  8 Sep 2026 05:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 963BF6B00A9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:12:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10CA8120446
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:12:51 +0000 (UTC)
X-FDA: 85190030142.17.7D09191
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8DC31120008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:12:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of johan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=johan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXUtrGqErAmBSxcAGqtzyGSPC03D3coR4YjaucbkEHU=;
	b=yqAOyE8F8S3EH7KH6R4vA4Z3YuPlq9ZhQzSMPw7MiU6QUue90Nhib3jy7zbkaKoQ6D9cD/
	ywrJoYqUEl5q//n2Q5UATXlO8ALl8CcvmJgjn4poNoxvxXRksCnBbJEQw87kyeKgBKCf4D
	0R6aYGn32ZKUkqXrKhZ9p+0+AB942wc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858769;
	b=JVnZs6SC4J0ZTXfgIc9hshyEFIKS1Y1h3bwW5hZqM/1kIPdPTlLgXd0AQoo1hSSlkV+L5m
	ezZ8O3JeHRI6HEojssw8QEiFTj/NPrcTIkmEQ5v7pioxZsX1ulMHlwUUfU1AbiNM/uZJO7
	8AnnUtBQEWirFG877nsvEkty/MGVo0E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of johan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=johan@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 085E360AA1;
	Tue,  8 Sep 2026 09:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89C01F00A3A;
	Tue,  8 Sep 2026 09:12:48 +0000 (UTC)
Received: from johan by xi.lan with local (Exim 4.99.4)
	(envelope-from <johan@kernel.org>)
	id 1x3rsU-00000001HWH-0VlQ;
	Tue, 08 Sep 2026 11:12:30 +0200
Date: Tue, 8 Sep 2026 11:12:30 +0200
From: Johan Hovold <johan@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Chas Williams <3chas3@gmail.com>, Duncan Sands <duncan.sands@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	accessrunner-general@lists.sourceforge.net,
	linux-atm-general@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] USB: replace page allocator calls with kmalloc()
Message-ID: <ap_Rfkrp73Ify53T@hovoldconsulting.com>
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830-usb-v1-0-aa349c302246@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8DC31120008
X-Stat-Signature: qc1bsnhqi4pw98odbuxofjm5ph71r8y5
X-HE-Tag: 1788858769-406099
X-HE-Meta: U2FsdGVkX19Ng5c00uG9EzE3itJO50DDX5hCFY+w1L/wFn/c4AxoK03tNfzqyB+NSC/OE3jDZzLoBNUf4r6/eMX7LEu94kVAOF3LYVQVMyO/ZCl1u6830cyjXKYuNG+Zig2aB/F5SGnMIyyrGn/qETMzIuLr/H0iHXI5hb0NK++cvjKPIaVdhsge3C+3lqtpQUBGZPjTlkyoLNHNxzv3WAW8xbzfAdZ18leE9oh5hLoDkCPkEGxlTtAftvWuzSLYy1ufQuMhwZMNKBNGBRa/M75ky0wM7IDXCHBFpXLjpxKEE2WyIdtpx90k1m6pVAHkJkPjJptM9D7WzJ8dxpoOeAAIUQqHyCz0bkk1sU+TVWwhaRMnRmuKDTQXLFhPYtpV1WGOvXAyITR38B/vmPs8VIreLA97g8oRgh9Cu+xcVpRHvWXrhkDP5dci9Yi+kJsAgm0bbcGUB1+2qOFzd/6Tv0IgyHHh6x8UqBgETFYXBoxzEXmgNalXlUUfBSiLF15H8QUSHfC6qE04XhzrWvKIRjjwy0Jp25oB6mzIPPUQb9iK1XNLkbFntWBtVI5Pwd1quWMOGtHly434Q42Zi0+SpRfB0T6iCtEiC2lBytxEF/0yMC673eHNIPdok7F2AOuoaFVGpIvg2sjA+6umuLDrWdYjNbv5SrVzY3gomUldFynuycWOhaMuftdcSyOBuyEsvTMabLPods6XwDFi0FkRzZM3QksrVG6igufQyqY3SBeDqJuByYTWyw2LNxk8DddTqjZC5j8q3uLEYjV7w90etXJl2qwf4WJUbmyTepqT8OFWRgaMPULnj5xBM6ZwBJZZZEVDfaOPPENbfa0/nTT/OEnbTrR37dCk/5ofya/CtU93JoAol0N6i7P4GGJIHal4+akBJv3mxP1VtTABpOkW2wdEkBeGW1WBpBjKEbqh3SlCYPhbLURyEFEJClDiFqJhrW3zhbHF8K8uhpLzSow
 Wl+NrCvx
 v0BhXfuREgAiiyY3VP9JBKAooxIT44EVVvmdZYHkH3kJ5AES1U5oKhNQm8tvJLIlSy9k968h6qHg2XCANMQ2RdEhkG1punh7t87NzDZbKKSp4qscGt7HGmX/1gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 11:10:36AM +0300, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.

> Mike Rapoport (Microsoft) (4):
>       USB: usbfs: replace __get_free_page() with kmalloc()
>       USB: cxacru: replace __get_free_page() with kmalloc()
>       USB: speedtch: replace __get_free_page() with kmalloc()

>       USB: serial: wwan: replace __get_free_page() with kmalloc()

I have applied the USB serial one now, thanks.

>  drivers/usb/atm/cxacru.c      | 16 ++++++++--------
>  drivers/usb/atm/speedtch.c    |  4 ++--
>  drivers/usb/core/devio.c      |  4 ++--
>  drivers/usb/serial/usb_wwan.c |  6 +++---
>  4 files changed, 15 insertions(+), 15 deletions(-)

Johan

