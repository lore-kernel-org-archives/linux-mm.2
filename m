Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12943CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8D58E0018; Mon, 13 Oct 2025 04:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668AF8E0002; Mon, 13 Oct 2025 04:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558508E0018; Mon, 13 Oct 2025 04:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 411148E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:08:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC1F2C02CF
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:08:49 +0000 (UTC)
X-FDA: 83992364778.15.6A97073
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id A8DEA4000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:08:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RHG+2uN6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3MYv7UFI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eeDubVNZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="v/0r/G/a";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342928; a=rsa-sha256;
	cv=none;
	b=R+dk6CJnIZegrUc4eOi927UroZx2kyw7W0qCN9aCGkXGtb0hZqZe46oq5dJDygIv2uC52z
	J9TEhx+DnbvP3tEYAyLLwTAsl5MSdDNfmsw/nC5UelYBdPUis90jzNgwwzd5il6gaUYRj1
	Wht6xVA0bwawuLyYTDAEPwupb4pYjQ8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RHG+2uN6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3MYv7UFI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eeDubVNZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="v/0r/G/a";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlNkhyop+IEN4Hkc4oUyCWqeDkbc6AZN0KzU4dkgeLA=;
	b=TbPgy+MNLiydQVHDrkO/iJh0+DZqzI/GCYp++lc0Qv9C/4X6ks9Ta8MnUnm6jgIERMFAQT
	HPs4OVH5lU5YLHL5m0tfNHPjwACoCoftBxDAG54IcrAd0yvEznXS0cBimHo0zhsJs1curR
	BN871CcJoyt096Ert7zfxE33ubJGB2A=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B74BE211FE;
	Mon, 13 Oct 2025 08:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dlNkhyop+IEN4Hkc4oUyCWqeDkbc6AZN0KzU4dkgeLA=;
	b=RHG+2uN67HN79LYFdavTGm2bpJbicwUnlTXQcZIRlv+fV286C0B/LMkXEEvZWIQTHJPrUp
	ZXNxGPJ4/8xc1VVSGdTSmzD4mFmuEq3OGJZH9wnxgHBc/nTeIGR2KOta1dqFJgHyoVlpXq
	l33xUWXj8LRf1W74XZYMUmpZHto/JLI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342926;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dlNkhyop+IEN4Hkc4oUyCWqeDkbc6AZN0KzU4dkgeLA=;
	b=3MYv7UFIEqRa46ApyLaQAFs/MDjNNyuNycxrJPOc7jq7hJBnfSYjc6L0j2PPjKtntWJuz4
	my2GcNY6qGQuhjBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dlNkhyop+IEN4Hkc4oUyCWqeDkbc6AZN0KzU4dkgeLA=;
	b=eeDubVNZbtpRzOsTkWcy/VN3T6wI9a+XwvWaWP5DYIWtFv83CF+LRJ7QHXCqQcZ18K1esA
	Y4T3npR2pN1t+uAbNnHNwk2UERiI47OcpaWvCHgnrMekijd/J07PpGOsxLzsT9MGnLs8dR
	XFqZ1KgfI2EwDLX7P/T985Uj3DMvX1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342923;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dlNkhyop+IEN4Hkc4oUyCWqeDkbc6AZN0KzU4dkgeLA=;
	b=v/0r/G/aCjZ94Q0X4QvB8jehsvLLQG5rR+r9EwpZjyMsKp1Gxi4LSw7a0AVwOyJ1dtRED3
	32BGYy3Fyx+WL5DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 579BF13874;
	Mon, 13 Oct 2025 08:08:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id N+qyEouz7Gg9GwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Oct 2025 08:08:43 +0000
Date: Mon, 13 Oct 2025 10:08:41 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, david@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hugetlb: add __read_mostly to
 sysctl_hugetlb_shm_group
Message-ID: <aOyzibjnM89KxnXi@localhost.localdomain>
References: <20251008212614.86495-1-gourry@gourry.net>
 <20251008212614.86495-2-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008212614.86495-2-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A8DEA4000A
X-Stat-Signature: 34cb47fi8tmft8sgh3jzghw7y8dbrpco
X-HE-Tag: 1760342927-782458
X-HE-Meta: U2FsdGVkX193hgwPafS17/NJ6IA9mSb4qidJ0BgL4qlCOZj+8t+wQtlIgTBFgoWP6zq6D8VswwoeqjbGJ4JJdAxYh4cp/204Yf9t8O/qAlfCS24TPrmHCr9TEE6dcEhtKDn902HS0sMTDTbXSI24ShmCk1xl6hfR9ulNz76GzRYefWevfngL+y6eeiwuxHpv0eVAEGvWOHezErf3FEWfB//bEeehYzGdpgyVxRAA2UdpuNxJ/zcFsdUL1qJavefx1YQEZYkUva+JB8TPHzaT0TI1yUOMCpkep80O6xrrrm3BOx+fqJyS774iQ/E6F11VTPIXgvPtG2dFQ7pBUZxzKOjW+QKHC4ViBz8XrVnM8WHf/a9MYoY9pP1POfqSrafVZ/JlUr4HDUUoy26AjxNL7q7Gm3VJUWH0IImAX3zbIjin5lQv3+dA0sA9WjlKDu6+Sa9VLfeSff8w4E5EKZX2kHqjCicsA31SHHxHR8gy8VArZZLovG66RMw7YAN/Q1JiHQknEJjoXxA4r/4at7FiuPCiORSQtp8Sz7bPMJexcCr2f9H4/0fCJGmoENWs58kyHbedTQPYQbbKk33rUNNBQ4DfYhBxItPsZrn8i3gnHUlNRpTSgu4Ld9ad0ebTskv7ZTL7n7PeF7dSxJW39IYjeUI+30NwBfmYkuTZxer3o0aS9E//stpS+7dj856V/WpokAFrzFaGeTtlK94nrf8Kg1n7i/9ICZ+udsQlBHMdmq46KWWzYG5hLasUPchBCMYEcmR7YU6U1mzx9FSLp+7+Y1x8YY+TFt9SaMvM9rA5dSbRxAlI1oSBBWwNispejKREkEbcq/GtJEruKQoLynwjeqqZpymJrPVeniAhnV0kj4+Jm0d5Ql7V0tCXmY3nCRUIRCdh4cwGCY3AwGntasvxuDsciLzKqDlBfVPmnXE14gje7uJ3puuBN3r8yKjNuFXaTO4UTCpyKgPPRXbvXhn
 eLJQUWoV
 YN6VRwnKWCUnyL8N3Qwu4iTU5451Yy6WF/wNzq634HtyXuI+x77wfxpDW/WF+j4Hbl04cq0dhWep4Ar5ZbVVvVGdZJWbwlA1Yvi4NEZjWMl3gDlRcZivzTA9dTxUAvVd9WGWN3VUWJUXpdOjyAP5motVnMwV/dqIclBFwJvx8OdIeLjvs4Lii+p46oeQaf3S0qQf5rFvTD9lCLGGSoAevW8LJ8Y8mZPiVbxlbyHgFqjq0RMGYnKmUggqz0BkDOxoQ6S0b/c4o+buW73cp9GrW+2lhxNf6zZjj7lobudqqXQR9Mgje8Nf4OOt7QlHxK+IH3fpNEtORf1K5i4AkUMb8zxVO9jk15NaxU+pE3ZNjQY9GwZCkWWefd5YCLpwicQ0UPqXUeyMPdS+k0KrJbr2/GUK6mrri6xS17GTOqBFyJcdvlIo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 05:26:14PM -0400, Gregory Price wrote:
> sysctl bits are mostly-read values.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

