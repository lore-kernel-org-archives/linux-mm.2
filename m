Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB455CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0CB6B009B; Mon, 11 May 2026 04:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A976B009E; Mon, 11 May 2026 04:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2396C6B009F; Mon, 11 May 2026 04:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1307B6B009B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:23:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE52312064C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:23:31 +0000 (UTC)
X-FDA: 84754449822.27.BD2CA71
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4F5721C0010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:23:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fQ2foHCG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Jm7EIPk4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fQ2foHCG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Jm7EIPk4;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRQjp7sPViaTctCeDrIMEselJR4Dw8HZnJqZhrPm0bQ=;
	b=wl5N7t7WjIW03/wAhA0abYfiLNu3MefMGIErkDIjdnEJp64cFGuW72ZMUlFXjNw3hgjbus
	eoRAFsqBgdK8+hRknmI/WdzCcBz1hTSb7C4e/KKNBOYVV5xEL4w5QbSjaqAplAzC0kh8VL
	uqcZj5g/Jm+Y/m4fxIuPdVhQKRri5CU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487809; a=rsa-sha256;
	cv=none;
	b=CrzJTbgzrxyHiKVnw7a73CBanb3f1/j0nba8cJcy0lW0tXCg2HtpLtcQdGu+i0zjf1/kKf
	ywc0usSwjYcDYJ1Zuish33d3BFOCqbmdJ1A3C76P4LAwaFXSt+Fnf/f/SlGkLWLGAK86Z3
	aBrpH/hFD1vD/E+mfkGX7PhAroQZ5bI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fQ2foHCG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Jm7EIPk4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fQ2foHCG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Jm7EIPk4;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6791D6167E;
	Mon, 11 May 2026 08:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778487807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MRQjp7sPViaTctCeDrIMEselJR4Dw8HZnJqZhrPm0bQ=;
	b=fQ2foHCGFTbe3BpspVt3hu5Bo0g9A24Q1YZ3wDujpr8s+axPbQn23BpIpPKFHDczWinsdA
	ghpNr6dJP0SCT5UvM+kxlBIsuDQCqiQWELgjHi7y7MkKjapSWJLDvHcuu88ehnmPSylRW0
	hItMY5+9aeQyNiU62fHxzdfipnefBDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778487807;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MRQjp7sPViaTctCeDrIMEselJR4Dw8HZnJqZhrPm0bQ=;
	b=Jm7EIPk4ZGoCj6yh4H0nQguyZgDHqmMnUyZN4xbEenK9GM/K/ZGhyW1SI0qzd0hM8OCdeK
	sTUiM7rVgyk4rMAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778487807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MRQjp7sPViaTctCeDrIMEselJR4Dw8HZnJqZhrPm0bQ=;
	b=fQ2foHCGFTbe3BpspVt3hu5Bo0g9A24Q1YZ3wDujpr8s+axPbQn23BpIpPKFHDczWinsdA
	ghpNr6dJP0SCT5UvM+kxlBIsuDQCqiQWELgjHi7y7MkKjapSWJLDvHcuu88ehnmPSylRW0
	hItMY5+9aeQyNiU62fHxzdfipnefBDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778487807;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MRQjp7sPViaTctCeDrIMEselJR4Dw8HZnJqZhrPm0bQ=;
	b=Jm7EIPk4ZGoCj6yh4H0nQguyZgDHqmMnUyZN4xbEenK9GM/K/ZGhyW1SI0qzd0hM8OCdeK
	sTUiM7rVgyk4rMAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 17DE3593A3;
	Mon, 11 May 2026 08:23:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I1EtA/+RAWqKagAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 11 May 2026 08:23:27 +0000
Date: Mon, 11 May 2026 10:23:21 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: muchun.song@linux.dev, david@kernel.org, akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/hugetlb_cma: restrict hugetlb_cma parameter to
 gigantic-page alignment
Message-ID: <agGR-YfOK0hh1YEX@localhost.localdomain>
References: <20260503084225.415980-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260503084225.415980-1-ekffu200098@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F5721C0010
X-Stat-Signature: 7dun5dm683gi9cgamiofxr6csjf8ohuf
X-Rspam-User: 
X-HE-Tag: 1778487809-592780
X-HE-Meta: U2FsdGVkX1+ctOmvrwwhB0KeYzS9DFmwEqyF25MdYH1DsUltUekUklehBMcfxVtedi2xgzDzHkz63SFAT9G54cc6Eu2E2C7RyrEpTNwH9jOdTD6TZJpCRDrhwEUbbT79QnGcGnj+LN5zXvze/0o86H+msxJ3lPaefXBaOPDUxw6TrX2qMXc6R1z+MOAB8rGtFnAyPXyiBQhn3YXgRtrDhVqkLtGsDI7vzw2mgkczCssE4ER/1L3s5jXx/UqfeY/2wOZHfMqHaN1w+n4N54Diw3ixBU40X+yukOUdI1zBKLkSI/tQtqZLLNOssJqf46e0s8xXQ232un/V8Yl7WGcQBK6hVpKQIeHtQYhMBy0G/YH4193KetjM6o8UT8F3DA9m2OhmWzX0LChUDY2f0umv636djBnYW97S2Jz40LVVxKs7+GbfGh6vFyLygoDEMSIb5QKhklydI/vSYIOzt7XmY2q3gRa0XP4qd4GpmZXyC2AkHHdQ18C/Kk0gJHu5a8ysRvA7edzD6od+X/1kKQdj+YgXDtyuF+rXZsPSLoLUywBrcu/qRL6F9GiCRjqQGAJcqd22n/mfz2Wn+HnySBJbmobq6XWDEr+YrMlic/wYvBs59hVZHrzly/c9hXupHau63w5lLGAp9iyaks3OxWGpPKEajUF6XGhGHGENcNpkGo+bKb1So4j1RnZb7MwrDnlmo1AoDOWB+PJlYazbTkypYbNP5qZ5+mXFFuILbMgQ6Mu+hAyeGuWuZLkdXJ2/BZUz9oGKI4/uDn2CqPOxmtfGtrkTcU2zOtu76vU82ImrTrS2i+DqYzMSHGWUJvD8WiLZWrPP6kXXYXzDxzw9+Q14O5b7R6ojIIII6xHYw93Vq3T/encnP3+wNzhL7Y4VZDiM1P60GySzPooKRxs/Ae1iMIKT63hjT4nZ/kXlj0c18wbX53dKwx/+xOX9T0WTOkEadVSIOiPu91MDPVoUSyx
 4BAaB4oT
 CsEWcXbYU4DZS1u88QmdkxQrjD/wNpC1bapQ4Hgs57CiBVfQ8hGNUiNojqwlfe2Px9PA57fRvoblsnIdqFEAZHxVxZhKuv3RhOAuHTd4jWB2stj/C+vn4Fq1f3Qskr+ZWXKGob5+aTTGjQu7GqrFiwf5dJ4vytzwkfAoUBsd0KdlxuQpY4iu95cnGiW6oM2VafLrRxAj1oDRQsBdO8HrdKVLqtwCTu5bz6ZK5DsjYwfUL4BqsZpMEVc3yrimcVOi74l826JekmYYq6/EIVyCW/7DbRvtjlHOXk8+gSF2VAM0lUij5BOZ0CZVcQjJLLrFLsuJJUyB5kRf+7mQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03, 2026 at 05:42:25PM +0900, Sang-Heon Jeon wrote:
> Existing hugetlb_cma parameter handling logic rejects sizes smaller than
> one gigantic page, but rounds up larger sizes that are not a multiple
> of it. The two behaviors are inconsistent and neither is documented.
> 
> To remove existing inconsistent and undefined behavior, restrict
> hugetlb_cma parameter to only accept multiples of the gigantic page size.
> 
> After this restriction, the redundant round_up() in the allocation loop
> can be removed.
> 
> The new restriction is also documented in kernel-parameters.txt.
> 
> Also, including other minor changes for readability improvement with no
> functional change.
> 
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

