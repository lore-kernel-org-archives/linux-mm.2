Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FF0CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F058E00B3; Fri, 24 Oct 2025 11:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836D18E0042; Fri, 24 Oct 2025 11:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79ACF8E00B3; Fri, 24 Oct 2025 11:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF708E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:12:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21DA54985B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:12:47 +0000 (UTC)
X-FDA: 84033349974.16.9A127EE
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2DB9C1C0002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:12:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761318765; a=rsa-sha256;
	cv=none;
	b=v1uZoGVkj7b6JAu9wLFwP+21XWqnCCB2RUe0+v7Ku3oWxHTYlXBCkl9sJqo1E7JkJT2WlC
	6CPiHdG+k7yad+RFSd3gy840pOx7ZOaWzGevgf8rJlaERkAht4tWYXfrNj9cLyCDpzJtFE
	b8yUcCg6FMA8egNHcJ+R6aUeIJAgYbg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761318765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i+ccLUlFUYhj92tCzyrNYXPU2QKCgamjHaO1CQKdmNc=;
	b=ZojTE5HzbqRzIgJIpKh5pIdirFfWwseGT3+c39vr91XtPDpbbEXOgmZab0RJgL7vNPO0/F
	Cdl161/FtTg/GEzjgv1S7jCxh3yqW7e5qFWl2LyHb81hBbyY2znu8a7aCY2TuZfZ9z39Yw
	o3lFhUwTji4E7IB8eSnR/GmyJHS4WKQ=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 50D9D227AAA; Fri, 24 Oct 2025 17:12:38 +0200 (CEST)
Date: Fri, 24 Oct 2025 17:12:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <20251024151237.GA1491@lst.de>
References: <20251017034611.651385-1-hch@lst.de> <20251017034611.651385-3-hch@lst.de> <fba8631d9159c9bd8df98e4cf33a6ffedecac050.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fba8631d9159c9bd8df98e4cf33a6ffedecac050.camel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: xys9h74s79hsmmnohyhqpec5yeowrpgb
X-Rspamd-Queue-Id: 2DB9C1C0002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761318764-360282
X-HE-Meta: U2FsdGVkX18D2pAqr5UD0oF05KvGdKyEYteng2fgoiMJ83ZlSLPn/xYsWnqwH8ZI/K0P6nFyu5y5+C4y5CDPPzElQra3MRwf9FK16zHbW44aPHeb32x4NOjKrH8purnX48xxTZhJT7WgfAGRtdp1endrg0PocIEq9qWjbgfGrnujwEnMVn0CxioKH2mrYKVvOv2+MpPIPCNg480qmqpGIcJu6O3U0FMXs0xXu613TmedWHfMDrRduEPhLXzJH16ygwlBGh8Ql2QvkdfRYRyTyPpL20Amn2kDfjtF03NtFU04G/oa2dRCsTauJGvKKUS1ZtSQ6LN0DjtrrRDzj+LaOZ9qpHDIfsIeAISBLH4opH5LLYwIlt5t4VUgPE84/zLYbl4MOzFFi4O//Ip4/evX7MX+TaAy05a5SeZ+r2ZaeU/6ikwrLm2TUrX8cZADO8upkLKFF72Zc36Z97/M5cCEurNUg4r5J5s8BuClDj0VgtAiF0pf82dvCLYWFnSa4GzAg0P/1RmNIK0NH8t1wmcfXJk89BxWA1iwV3LJ2RgdZsIH9PWG2AC0/skfheTpURHmNNx6UNs7cBHA+OxfdZZQ+pwF2cm6/ZLjzhTQZKtuKHzL65AhctSyThEjBcLlZsmgHsUbOSN1fHuMjr/6p5tGELhqrNhHkW0Xurp16zH2zf7LChIkr533+DkQXKKfVBWSL/UQGJc0sfb40xSFp1myIVvxkFlQh35so2Ui3Yn/Dyq078DDnq/NtQYZSnleuPAsAaGe9Wny4bk82TgRNOOeJev/PWgm9tRnkHO0kQVgxX5hqqNhnqCqKoph7RLF7zbjtUOvia0iEEWm6CFBWb4bHu2bBg872GXN2mkvYGaqdr1kW63YTjP4rclUzADx2m3Vp4UgiansGfaLI4ad4mMLx5bnb7NlQEK6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 08:03:34PM +0530, Nirjhar Roy (IBM) wrote:
> So this patch doesn't really explicitly set s_min_writeback_pages to a non-default/overridden value,
> right? That is being done in the next patch, isn't it?

Exactly.


