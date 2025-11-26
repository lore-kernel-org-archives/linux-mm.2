Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D77D10F56
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90A26B0008; Wed, 26 Nov 2025 09:11:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41106B000D; Wed, 26 Nov 2025 09:11:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DBF6B000E; Wed, 26 Nov 2025 09:11:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8937E6B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:11:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 055CF89ABD
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:11:17 +0000 (UTC)
X-FDA: 84152945394.09.DAF533B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id A87A580023
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:11:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qqFkRoFF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sErewIAZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qqFkRoFF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sErewIAZ;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764166275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZolWcKpYKNTSI5G4tfaEenm8+nHT8Wl8rOnJEhk1Tw=;
	b=UqENnRsM7t0/MABBFsu1fgPuleiloirGbOLQ+rndxbHx5ek1tAgp4h5n5yYZc+KDDnkcDH
	fBGENFPr0j9bF25ht3c0gp2ZLjWoajxPyjZTwShB7giOhfwQyMy/8s/ursQv6J8wJ7R2NR
	pCI8vFjmCa+kUCx+zLD97i5S2OChExw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764166275; a=rsa-sha256;
	cv=none;
	b=yHeXMvnNQI8HdkUgfScEjz/pKbtXPYwp7pKxSGN4g/97E3xaoGMvXZzitThiA61KKBd/f3
	hWkgr85gnHeTSDQIgC4zM15Mj8JDCgZ7c0Fzy6frPk5+3qnGMVfGednq9zGhIk2QyYcZLM
	dvevh4xqUkQJirqZxnnhw5Z0/EKLus0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qqFkRoFF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sErewIAZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qqFkRoFF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sErewIAZ;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 920AC5BD21;
	Wed, 26 Nov 2025 14:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764166272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZolWcKpYKNTSI5G4tfaEenm8+nHT8Wl8rOnJEhk1Tw=;
	b=qqFkRoFFsSvcseTsYz6Q/4Xml0ft3+yUvusQxiVhrp1Asg+Ein8vW7gJLQw/+IubILQZoA
	zspwESEo+gGARpX/6Pmof1rpzaMbDM6VguLTnBG7w3Oh40tWa/JxPMyqGiF0XhoaWmPXAQ
	vMOuVmJzIpQbdaoYdMxex40tDUWJZfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764166272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZolWcKpYKNTSI5G4tfaEenm8+nHT8Wl8rOnJEhk1Tw=;
	b=sErewIAZKJQvA6kmx83SXz//3pDc6qpPZeHFZihrGIANR7hS9DCMiP+OrGwRRECsMmwB+k
	DWFjJsooLhVr8iBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764166272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZolWcKpYKNTSI5G4tfaEenm8+nHT8Wl8rOnJEhk1Tw=;
	b=qqFkRoFFsSvcseTsYz6Q/4Xml0ft3+yUvusQxiVhrp1Asg+Ein8vW7gJLQw/+IubILQZoA
	zspwESEo+gGARpX/6Pmof1rpzaMbDM6VguLTnBG7w3Oh40tWa/JxPMyqGiF0XhoaWmPXAQ
	vMOuVmJzIpQbdaoYdMxex40tDUWJZfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764166272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZolWcKpYKNTSI5G4tfaEenm8+nHT8Wl8rOnJEhk1Tw=;
	b=sErewIAZKJQvA6kmx83SXz//3pDc6qpPZeHFZihrGIANR7hS9DCMiP+OrGwRRECsMmwB+k
	DWFjJsooLhVr8iBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1B953EA63;
	Wed, 26 Nov 2025 14:11:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FulIOH8KJ2m+LQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 26 Nov 2025 14:11:11 +0000
Date: Wed, 26 Nov 2025 15:11:06 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev,
	vivek.kasireddy@intel.com, joshua.hahnjy@gmail.com, jgg@nvidia.com,
	nicolinc@nvidia.com, nathanc@nvidia.com, mochs@nvidia.com
Subject: Re: [PATCH v3] mm/hugetlb: Fix incorrect error return from
 hugetlb_reserve_pages()
Message-ID: <aScKenEARH_rOzW2@localhost.localdomain>
References: <20251125171350.86441-1-skolothumtho@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125171350.86441-1-skolothumtho@nvidia.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A87A580023
X-Stat-Signature: xkch7orsmf4hc9iqnq6g9mb67h5t9nkz
X-HE-Tag: 1764166274-563175
X-HE-Meta: U2FsdGVkX1+N4E44o6goNyJS+nOULxKkw2xmcESJPz0Jbkk77ewyABgTPuA9Vg1gKcUh5+B8+H6jwLWVlU3TTZiYyRLggS6eaFEJphFWvHHIfWKwGgpwAV4Cgd9vSggW7DXOuM8t7pSZ3LOzrrUzmQ+GI7fN87QJ6iVJLlX8bq0MZkT87OIQXdZJt9j13Pt6tsqCCB4q8rSvhGCmWNPjfqoymIEyQPC90z/3p9T9ePzePWBAzJnJ5IuZgT8gE80etEmSXjpjhteP9TT7w7sxnfZFEF85pH5mRutnlp27IoV22WDClNrgQbb7ARar2NLYaBiEp6RcxJIMO3scey3zI2kWs5QjEJEmiVjHMs/ASaq8+aGAGWD85b5baGF6omihMMTehzzLYQ/1wcD5yhC7GTsAIr/aPSz8sc8RtObvojiK8KEhq/U/8b/ABeDKoC672rjWxMXoVtsyBMpwMfXylHD18OZ+eJB/jU/Bt11Ep3blqbZ5RVwjTyGGAluLEwhB2KJ4psqr8P1TvNIT29JVGjpL2z2W632NYpeI4+tMcZLuIjEl2TXNxTmeLBcaI4HcvSpl4B+COp1vQ/YhNOoXd3OxfJ5uA3uvWdNI00Q2ASsSC5F1Ag4sZrcqnRMTbePLivghdF/WdifVcuzBdlfGULipNGPc0RUmnldC+1wotiKqi+io0t+z8miSv/JXgXIql09mRn7F42uTMIWSg9PF7BmeE43okGatvH3zcEk1Lvxv/nj13pjYM7iZ+uOoCyuikMF+jJznDCx9BsUNSZbkM66RN15jvBaBOh39JqvOPD46tcIBliUUjeg3z/FJhus12HmnNjwEhDeIRHt8KxdcLS1fvv68mnLnOTlz6iK7UtoeU1AEAFssExQNysAnVUqg6I+Wen8JprhpJ5drjZ3vMmYN5Y9TkF/m/ZIpEjje8nmTCGXGO6JBCtgs+dslkEjplYEQ5mzmIb4dSXhe85I
 cUhOOPib
 GCkg6uw76ecnHbYWiJSik9SWe+WPG/6dQ0tBBoyRGjZrmMHyS8O/eAYK7eI81iMK8oPvFPF0BeDfczP3jX6V4wmZxL5f+NtL1yLAzh0LP739covNRYZzvJq//zaVgdgoSsV/ZINPtOddszZM8yA1zWnlal2JoAEwGNVQR6gIeJmM7LYg1rtv7/qm5pWbkT1YtEpVsWZNgUw90RR6ZHQSyJrDkn88dCzQPP5yLP+2k8Whjo7xxFRdNQHTqKIYWbVesD0R4kULm7GMHulNaFZcYjDEVN3VX0dhqJykpvmShfEEFloWVlrbt7ezr9Wa9kQr62jy/vtUCAo8XYkHXxeJYG095I0vX9oeSDpG70IoXTh4uUY6w+azIuwfXK9EM9ThXZMDNV0Cv2GXqjk9oaIOHvh6xGoi+Nvc39c/LXwChLZKaRbU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 05:13:50PM +0000, Shameer Kolothum wrote:
> The function hugetlb_reserve_pages() returns the number of pages added
> to the reservation map on success and a negative error code on failure
> (e.g. -EINVAL, -ENOMEM). However, in some error paths, it may return -1
> directly.
> 
> For example, a failure at:
> 
>     if (hugetlb_acct_memory(h, gbl_reserve) < 0)
>         goto out_put_pages;
> 
> results in returning -1 (since add = -1), which may be misinterpreted
> in userspace as -EPERM.
> 
> Fix this by explicitly capturing and propagating the return values from
> helper functions, and using -EINVAL for all other failure cases.
> 
> Fixes: 986f5f2b4be3 ("mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated")
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

