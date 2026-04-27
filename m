Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E60ACFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424B16B0005; Mon, 27 Apr 2026 04:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5C26B0088; Mon, 27 Apr 2026 04:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB486B008A; Mon, 27 Apr 2026 04:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CFC76B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:20:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9AA211A07FF
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:20:22 +0000 (UTC)
X-FDA: 84703638684.15.CD3A6DD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7410D10000A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:20:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bd2Ak1O5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eGTxzdUV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bd2Ak1O5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eGTxzdUV;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777278020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljIeewl2nC1nnYEuQwBPmFfRDhKOEw6j4iTKgznGDUU=;
	b=rG9NZ8d5anwOP5pDCgQaL79ZJRc99InjfCjkjR6Mq9n8Y3XxcPSzrnmXq81TD6mzBAHs4o
	6xrQcLRsTbFqh9tTXB+O2KkABYj4SoZsP+fT/Rfn5DHPIaMEdrdCcL9bhQ0McjkWIrNweC
	BjCTSwC8lpg4d69xXhmOT0EUZmL5FlQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777278020; a=rsa-sha256;
	cv=none;
	b=oSwhYU7hlGklG8UeEVH4uiHmMQ2qYciNbHwMvEszqANMZ1K7TQu3oB5XDgwQXQg22Xdt8G
	DsPEsFVDV8/wVK0ShIkRMd9PAhv5Uyzu/U9BczC4T1lLIgYoejqzfIb7tHJquNdbhN5CMe
	4+lHMzqD4FT1BpUq1dnEHYJ/iaKMw3M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bd2Ak1O5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eGTxzdUV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bd2Ak1O5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eGTxzdUV;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 915C85BCDE;
	Mon, 27 Apr 2026 08:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777278018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ljIeewl2nC1nnYEuQwBPmFfRDhKOEw6j4iTKgznGDUU=;
	b=bd2Ak1O5pQGiXleCQLrZrHmE/cAADASssgVObxAsTl57G1v5FUCifG+vTbWnkizcn2ggdd
	3V+nujjnc5zETp/H31ik9zpC3zr9BtgZy7LKdifn1YLXx50Wy4+IXuTsFy++AYbkUopuqq
	p8+5NJKnoFcYQzkjvkbxe8xBmgD1cyM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777278018;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ljIeewl2nC1nnYEuQwBPmFfRDhKOEw6j4iTKgznGDUU=;
	b=eGTxzdUVp06BxYI1kWWuZ6KM+W+Jz1veM16dymMdyX/Veb2VVlS7ug5VSXQud8Ac8MTu5S
	IDJYYPkWdSoYzRBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777278018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ljIeewl2nC1nnYEuQwBPmFfRDhKOEw6j4iTKgznGDUU=;
	b=bd2Ak1O5pQGiXleCQLrZrHmE/cAADASssgVObxAsTl57G1v5FUCifG+vTbWnkizcn2ggdd
	3V+nujjnc5zETp/H31ik9zpC3zr9BtgZy7LKdifn1YLXx50Wy4+IXuTsFy++AYbkUopuqq
	p8+5NJKnoFcYQzkjvkbxe8xBmgD1cyM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777278018;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ljIeewl2nC1nnYEuQwBPmFfRDhKOEw6j4iTKgznGDUU=;
	b=eGTxzdUVp06BxYI1kWWuZ6KM+W+Jz1veM16dymMdyX/Veb2VVlS7ug5VSXQud8Ac8MTu5S
	IDJYYPkWdSoYzRBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12448593B0;
	Mon, 27 Apr 2026 08:20:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Em5WAkIc72n/DwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 27 Apr 2026 08:20:18 +0000
Date: Mon, 27 Apr 2026 10:20:16 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kaitao cheng <kaitao.cheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chengkaitao <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm: Convert vmemmap_p?d_populate() to static functions
Message-ID: <ae8cQJWIZbcvBGAP@localhost.localdomain>
References: <20260423101441.7089-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423101441.7089-1-kaitao.cheng@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7410D10000A
X-Rspam-User: 
X-Stat-Signature: 6gpnthf9kb4rdizgpfsejsb7dedpub4s
X-HE-Tag: 1777278020-148951
X-HE-Meta: U2FsdGVkX18aZ4re8yv4v9X5RKb7CiWHuZLLGLgGMFA1CIRp0cXTZ8wCYH0M16Bz4IfcFfRw5pXcQit1T7z8DW+GfrkFgQ7hJHkKVfFig5mnSUTVB08FsFeXEXAf63u3IzGIbM5JCkhZKQyJkKQvp7KPIR5NcvY1BcDxWligR/05RIdxvpCQKCep9p+RKG+q9bc0HsBmhYG16GsKNYi9X4B+ilfgvrikfZV0qTbd8eGmoDHqvwCcsaXb8feWN+DzKf40Fnv+hh0sg5wzFRIY027A4UGmGIEzMWBd+9XPXkW9MSOsEAkXqbpQW/9Nka+sUvFw1wKv40jCHpV/lzetdyRI1CG16q1I0AtNsh4a/cM5ID298CiyDBcy8VS/0Yr+Y14QnYKYQZoQqc6XW1v4qhYRdvXsoHTF4WlMnzTI592mDQiIq9a688jGs95Yf/1GW7GtDzItNmDIYZdJJ1dUHOxmffFR06IGd78zscA/PhXJeBr1GpJc5R4lewsIrZEthzhExeU1pYF1ThrSCSHgu2HKzoxvpStHg1Cc1x0pp7vK5HS4vWl8rtmBnR8Bdt7rnTv63WBrbCA98dMhW1C0QKQMwp2O7mmVSgbYpBSAoirZbJqycKY4X7oUhgfV/2WB9YII+0mEVDVc4zh5cNc4CK/2d5bUavvewqHuegjov44WXoZKbV1rJ8++vasgVt6RAKZ7pTczKbnySq/hONR995nYWJO6vgoTTCKAsTX57m3OQeg+qz/Kn01wClL+zu8cSUZ3ZJYl8GxXUn1rYqXKSjScQEFRuafxHu3ncpSWLmcrhdCT4WF/oxbM7wHqcK1b7v5TiUwQ3uGPY9VDLAlehF+XR6cUg6SCYI+nlVFM/kOqsGNXSquNEbJhrRX73BDWedaX8qoEUNf0pPnUTuJ7ciWo3knrV6WTDuWxfb+lFHnqN3GWg603Z+3qRLsgSVdX1MLc5ufjkeNnXHwEU79
 ywzGHaqC
 aERqc93BRnsqxeR6SonBrVAw5JdfJk+/uM/bV3DEjqKLwPW2lZUUQyzevBOwQAKsQr5hGX0KWcJ9k+HOLVe045jKBoQynUJKoNNxt7wGyyYkBbu3/HzezVtQ8mM16pIpgIKQ40R14uuWRdv4IqVYknqlZQiJioE4PC6G8+9n5ZKNx2kRSmdtpu2zcqK2mrxYyTngM/bKgSRMLdod95hCxRvsOjgzbRUs/jUEYD0551vWDDKwgtY619uTE38Ee65aOvOyIL9jIQkMyfROTrnKmqH1c5e3eYV+oCqwpOuK4r92HGoFmFqzTMQbiYLxMOBYIghk6xCwiDAxN8yj8KVw6IujC9D1mdwjiEZPYIZe6VS8tFL2kolkpV3JOsGWPKOQ7tAv0vIGdlcrhUziw1OAT622FprapEnpsBLZ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 06:14:41PM +0800, Kaitao cheng wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> Since the vmemmap_p?d_populate functions are unused outside the mm
> subsystem, we can remove their external declarations and convert
> them to static functions.
> 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> Acked-by: David Hildenbrand (arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

