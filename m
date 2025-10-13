Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FCC3CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 06:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A1A8E0007; Mon, 13 Oct 2025 02:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB258E0002; Mon, 13 Oct 2025 02:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F0F18E0007; Mon, 13 Oct 2025 02:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9378E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:45:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 234691A029A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:45:05 +0000 (UTC)
X-FDA: 83992153770.05.EF55DC5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1D41A2000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:45:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=g52eOs+T
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760337903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CK6xCOG1HC+zooaL67URetqqCyoarWjYFpW68lZJ0Jg=;
	b=hX1rc3B6fYlGAJi6+8n7wCwHI7CJA1dczLmRKbZRgHSyLYSOTbe+TVDU63f3PbG++dXxBY
	9R3CbB5Xhx4mIZQpTsQ02tGp6zv0rxq0MhoZ2n8sYywPobJIjiqvXsEJx4zN4j58yi5CNC
	iWVYVsscXfECzAj97aIeVFJrISd3z+4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=g52eOs+T;
	spf=none (imf13.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760337903; a=rsa-sha256;
	cv=none;
	b=qhaC/tc2jDB7wmOjkR+nKhyCo/E1gwf/yU1TN36ueVbzKZv6/EflN0pVAyD9QMbUUFyekN
	rDmg/S0kXSgEKlnyoKmzPtQhIPT+QE57x2F2qu+4ojm9+gIzeFD+8LyQAOHakSOOBPmOJq
	qLWSN/qjGY2kJLiMllZTOTYGgdiXlms=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CK6xCOG1HC+zooaL67URetqqCyoarWjYFpW68lZJ0Jg=; b=g52eOs+TJooN70t73Ap5LaWvb/
	tDW2aFYo1hCGOfJNG56k9V76XHyv8t9sdwaVxNXaIjgUWyTSWXRyihXJNsYgIhrSdF0r7F8n2mf48
	KyKVu9Xd29YJFNTqgMkLBFOt96lGLeP0TLf1DNGQ4Ke6fUUEMO8tGmt6uCiU154rphKsXG7zMIrTq
	y1ctylhYAgkk4jxJSpagC+OOngT90ufONdearUKda+EaFjmd7kAjf64XDCou3dQHP37VbApXtYZPw
	663yF/gmCorKESypTCX50kkSPDGtlr361yfhYYr9aLEmfBXX5g+9ocAZzLwu7a3yC1RUqEpEYApXC
	0krra5gw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8CIe-0000000CQN3-19Sa;
	Mon, 13 Oct 2025 06:44:52 +0000
Date: Sun, 12 Oct 2025 23:44:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com,
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com,
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk,
	brauner@kernel.org, hch@infradead.org, jack@suse.cz,
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, minchan@kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev,
	Minchan Kim <minchan@google.com>
Subject: Re: [PATCH 1/8] mm: implement cleancache
Message-ID: <aOyf5FxH8rXmCxLX@infradead.org>
References: <20251010011951.2136980-1-surenb@google.com>
 <20251010011951.2136980-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010011951.2136980-2-surenb@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 1D41A2000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: iorw7zw1tszjqdy7i4fxjxxuq8phbw6y
X-HE-Tag: 1760337902-342948
X-HE-Meta: U2FsdGVkX19kEw30w7p0u29f8/nSWNi8K/jm+d/n2N5Ir6Wnan9mUkKCbd2VTG3T/v+JM+BXx2m10DZVTQlkskvvJlPCEWPJcGkcBm6CPv3Zwmja/74kv/sFlnOh1b3Zyi81hpUDgB0y56mn4edohBEFzXg1TFrwD28D9zjv7J1loMSoSKVnZBQ+5iv6ksb2IWY8YXtKG/fbFMLNqvOSTFtgknHEzm7mynK6ITXuHExX1tpaWPEhM59qCWAA1la1Y/hNyQgLnJwUhs/1BT8EyUdY8g4q3TyxV3r74hgxj7SrS9+1kMoRjNeFDZHqf5l3usnXKkzfv7O9bcKAILRwG0uRkZj84IYbyzeHFyn1+vJrLnwKWgJ+L1gUHdrZOIWPMvKVHK0nMGLqvadFVIJ7+ZBjJTGIoRSkZvVEWJud+HjaADa5HRvsHY/3dQjBhPQDXUyT1UimBIL4jwFKT/rsEFuuNNxqGYGkDZD+lHJMh7EnpxPLfZcoE/uV8RRYRS0FnzB/pl2xeuUCSAo4JpBHrtgog3XxWiwia3nJbnkicoPlWluCwIA6/tZZZNfw5Uajskav4LMKGDg3QDYSfAAlwZqUTS3/QuAXYfsPAcvGtGW92mxSG/sXfiOq171sxxa8mFf+lbXV0DgF1h2aU8+M1oyesxN6naP9FmC7I2G6DRCmlDHIBDn2KWnrz2QtuH2RzOVCAK0tl9IlYK5TpC6PnQASICqwsFkDsRVLeTVW6tX4YQcJBVhRzewEbHhQDxdJLLcsmicQdMC8jAK7cjdvbrA3CZF3K8vnWILmXAbbGLJc3AatC2lGhlK3b8wFvMV0hKvH39wGCTrcThqP9HlfUbHLzl1BhskRxK0cBbIWM89PqVGZRHH0iorfYRXU8SG7ZJErK+uJ+ukA692SANBUTRfSHKASyx4VwYcTxwPDj/0C00zeS1z2UkkSqaA2kOkMglL4Bk7pHDyP2WcOiv9
 RqKOOOJW
 e4qHWxBN310+4bR8PT0xKiWoqOlJadLPqfl5u1cYpuMRATqJ2Eb3U9oOnJmoVcrfpLtpf+hIGRq7d+IAsaysYv6+sgzLo0xP2Jyx+vJTE97GHPQxoOFBYOBEGhzL89pwNKvPnUoRYFBuC+Q9Sq3pQTAMwOk8aqEXY9Rroz9ur9JKXZImHdqNVF8sLJWPHN2aYI2YmeTlThGvgpBljDPrrmGtBEHR8pFjdmKJgCnz79A1y+ogyd8epB4iubkrPlbi0ovMOYzsDw+LDb0qmGJ/5h/JvydCgZ9FKbBtax94pNPHwMGEw8XLfXzWfSppj+evt+YV4O8N7is1HnLKja/4EEjLzukVeRRQfjbAB/G9+GscrRjaAXOF0BISMTXXuDjOmS+B2xUG664yQtpE+UTGW7kmtXKMLmeheQNbfSMejCeOKIYU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please don't add abstractions just because you can.  Just call directly
into your gcma code instead of adding a costly abstraction with a single
user.  That'll also make it much eaiser to review what GCMA actually
does.


