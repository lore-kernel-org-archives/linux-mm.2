Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C41CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 14:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93DAC6B00B6; Mon, 18 Aug 2025 10:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915256B00B7; Mon, 18 Aug 2025 10:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 804666B00BA; Mon, 18 Aug 2025 10:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5736B00B6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:33:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C041BC327
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:33:29 +0000 (UTC)
X-FDA: 83790121338.19.00143FB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5FE3914000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:33:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=to41R6vP
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755527607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bKVcHPa7Hp1PTCyMkRD0bE4Beico8C6cJy9TiNStRM=;
	b=XLAoWVqUdIF0KCZ2+QbmO2k7dGQ9+aEJ7n2oln8MEdJQgaXHO/W3thH60RkHccNXaridLt
	VWOoSvlgjF3aKl7884UX7W5Gudi3umVdj0iARWQ+Flb9psDjO1zYuJbfR6j7Hn0q4eG5Mr
	1FoarzrsDQlPNs/VCP2YUyvMhwM7Rxo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=to41R6vP;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755527607; a=rsa-sha256;
	cv=none;
	b=0qJXU30AL7d4pMqyOtbrpuekYCaoadYrzMxgEaNTSr5ftirTwJZeqTKw2/F6OpPkEx2wJJ
	MntVM16aFXAgtZsy1I1RGfUunCc/P/8LvQEvdbGsp6L3vCZpaPeLprG0gxA5FPfnJ3WSqL
	XlRAIiWEY1GQLr+NzhG/IT9CvO0rrA4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2bKVcHPa7Hp1PTCyMkRD0bE4Beico8C6cJy9TiNStRM=; b=to41R6vPu8mdKrYFkBL7cPSNki
	vzB/LdkfJFVSqYtC7IMA1RwL3x41IPTFlgzF660xD0zuTm40xBvqKdCiGvihRs/KoX8fyh7wqBUtH
	TJDtiQyHGmg9PaKVaUKjjoA3tErS30kY3XYeNRxqQ/rw3JvyjBBUdcxwr/f3IWzgZU/G9ig+HiEB7
	nyMoGRQfIb+wIyGBnnuUIbn1pr/LoBtvTgyZXGmWzc0WLG4t15xgmgkGut23hE8/nsHZHjuy7BBKh
	Xg2sinQ96xAL2RcBHFfEzuYgnSbp0OIfUDik+N+XCYhDPIhRqNzrMjdeeVsPAiSmjLDGY05w3sEpw
	1HYlmL2g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uo0vJ-00000007EYT-2i59;
	Mon, 18 Aug 2025 14:33:21 +0000
Date: Mon, 18 Aug 2025 15:33:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH 1/3] mpage: terminate read-ahead on read error
Message-ID: <aKM5sUFuOevaG4_i@casper.infradead.org>
References: <20250812072225.181798-1-chizhiling@163.com>
 <20250817194125.921dd351332677e516cc3b53@linux-foundation.org>
 <9b3116ba-0f68-44bb-9ec9-36871fe6096e@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b3116ba-0f68-44bb-9ec9-36871fe6096e@163.com>
X-Stat-Signature: 6df9488so4y39jjmn798izde6k3bbrg7
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FE3914000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755527607-215523
X-HE-Meta: U2FsdGVkX1+pkMy2TQN1kbfGCzjgf7gOcrAmsQYV3gcRpIP4w/HZXSyIR0Uo0PFe1CYQO7OgQeYm4mOqBuL1UA3UMk0WpaVT4vCUb+fN3mGsjO9lspiYSSH7wHWKyRLenRLsYhOK1EoAGqi4dOAwho2Kv9i+5lrVsYby7t7Q7Mms95WfZEB0JiaRzMmV4e6fQmVeRSPFa/UhTcKY70xoC0J3u/ix1W/yBOxjdiNeEEJKQSghj6+Tyom7X1RVQNDyNRtkBi3a5uj1ZKD+mZ4/P/PuyqT4uzlo5yNnLROGkgZSjjXIx1G82c661lNRAnInGcLzrW4QxwFykeFvHSdGRlbJOV2L7D+MKklchRtO9PnHx/4+XRRXqJdGWFpgPGRtLhWxeyDuv6ScDIB1gvzrzEBxTweo1RO5JWe9ueqaYBKvMSYcxLsz3+GrizOYd6mH9yeAKB8C8z9yKEnZ0Vc2yXAbPzmShZZkQYhCLd6WipPtTticd9K5wmNr8/KTGhZJfLfHxlMxFlLw5Q/pr50oaEwQhinUofUFtRlmGN8Q1+wSGN+ZI6L12uJReJ/qWyutD8G0eOug86K/8WMv17pYaH8S89UoKaN9rSp7YCgO26DTUkhC3oBSDNBQt3tA/rr1k2IeM7ej8s/0TYLR9lXCt95qa5U3JmBgujJSu9duB98DWY6E04AaeFjQCDyW+YCYeSNSNDWLjeQcRU8uDPu5W0K/xJ9SISRZ4fPIXxI6JDTuTkMIq9HE6Got3F5rtUo7MfScgTd33s1OHMXCVxWoZ6HSWYc8GcfW/oq8jORYddmWJZfYzfDO46K0HnHy3Rj5bCLnjSORzo7FAmoo3HiHEe6RLgpCPVUyKBZ740qgurXu/aHlZqaq/A/wQyxSQHPWc+QBh+7FFkwPfm/WqGX+4aJnoOCl/t/BCOO0cIf19CipEoJ/3m+GmRsR8bL9FtQScpQq0LaFNQNnQyOAlKI
 SGmnxbAK
 RfQ6lMVsw0KbWcLqs/SqdfRelaGnqO1SC1SJERoSeCvVSACov8Z2OlEyS4wS7huHtjiSCCJFT3EvtX5+QzHdIv5vrEEnktTLTYqgZPm6hKOGMtjd3z2jQBnze4fIpGR7fKgpD6bJYI9e0lQfgnxZ076V/9KNdAABUj4ihncFzg5QFTKpTciCcvT72IA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 06:04:23PM +0800, Chi Zhiling wrote:
> > Also, boy this is old code.  Basically akpm code from pre-git times.
> > It was quite innovative back then, but everybody who understood it has
> > since moved on,  got senile or probably died.  Oh well.
> 
> Actually, I think this patch is safe, but I'm not sure if we should fix this
> issue. After all, this code has existed for a long time, and it's quite rare
> to unplug the device during a copy operation :)

Converting exfat to use iomap would be a valuable piece of work ...

