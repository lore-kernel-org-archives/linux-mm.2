Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE75EF34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48356B008A; Mon, 13 Apr 2026 12:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20986B0092; Mon, 13 Apr 2026 12:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0EE76B0093; Mon, 13 Apr 2026 12:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B89E86B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:48:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71B08139CA9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:48:33 +0000 (UTC)
X-FDA: 84654116106.23.4482A13
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2403A16000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:48:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1Rjtkm9F;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u5HQaj0R;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1Rjtkm9F;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u5HQaj0R;
	spf=pass (imf08.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776098911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhYl+zfnnZblysGfhddsW421+r8fb0OK3WMKk04BntY=;
	b=E2qRbfN6++9peA/GwaZKhns08g8ckCbjVr9wZ8lyj6gBkeVVMAT3sgm9menmOQAhjzhtsR
	T+M2wZrBTbdJP9g1w7cpnYjEPWl9rB2zGFbkYVzFOlr/oFQ7XN7U+FcEV6Y+vUB0ByZT2b
	bQAZB+MeL5hYNw9aQkNgxCMXHW1MWJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776098911; a=rsa-sha256;
	cv=none;
	b=DZhHkVGlDpDmF/SU3zDaUHyZqXONTFk/VOrP8UW/G93Vg9WzFptpO6PDq6eNj7h+yHmfxv
	khuMEUOpgmpa5GbZGyR2NShwU6jK9DWXgSf7hnNVyAI1zqjSqpYt/ltkaUrCdrDWqY7sSc
	frd6Pb7yMFzeMdH2D2+2y5NiZ0Bjk0Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1Rjtkm9F;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u5HQaj0R;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1Rjtkm9F;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u5HQaj0R;
	spf=pass (imf08.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B3245BDE2;
	Mon, 13 Apr 2026 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776098909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PhYl+zfnnZblysGfhddsW421+r8fb0OK3WMKk04BntY=;
	b=1Rjtkm9FXnIHCxpko/RYPz5JVKCmrWLdupLpXS13XwEJqEWA1UE61vtbcBaSrq4ieEj9Jn
	OTJCTnuMMVvAeS6sZdWy/GjqowNp0WtMfbWJo0B3aAWqXUfwp2ac31rCzh2RUGhFPhbPDw
	I2CclffFbMFIzhlq+tZsK732Y6QGerg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776098909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PhYl+zfnnZblysGfhddsW421+r8fb0OK3WMKk04BntY=;
	b=u5HQaj0RVm3E4HSPIRVwvA21DrOaQzc+Z2W1gfCI+C19+ZFXmRvdShkKxe+YzO2GyZVVmm
	AmgforSERSNw16DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776098909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PhYl+zfnnZblysGfhddsW421+r8fb0OK3WMKk04BntY=;
	b=1Rjtkm9FXnIHCxpko/RYPz5JVKCmrWLdupLpXS13XwEJqEWA1UE61vtbcBaSrq4ieEj9Jn
	OTJCTnuMMVvAeS6sZdWy/GjqowNp0WtMfbWJo0B3aAWqXUfwp2ac31rCzh2RUGhFPhbPDw
	I2CclffFbMFIzhlq+tZsK732Y6QGerg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776098909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PhYl+zfnnZblysGfhddsW421+r8fb0OK3WMKk04BntY=;
	b=u5HQaj0RVm3E4HSPIRVwvA21DrOaQzc+Z2W1gfCI+C19+ZFXmRvdShkKxe+YzO2GyZVVmm
	AmgforSERSNw16DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 845EB4AFAD;
	Mon, 13 Apr 2026 16:48:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E79zHVwe3WlGCwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Apr 2026 16:48:28 +0000
Date: Mon, 13 Apr 2026 18:48:23 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
	hughd@google.com, baolin.wang@linux.alibaba.com, peterx@redhat.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] hugetlb: remove the hugetlb_linear_page_index()
 helper
Message-ID: <ad0eV3hZtE51bTA9@localhost.localdomain>
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-3-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409234158.837786-3-jane.chu@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2403A16000F
X-Stat-Signature: u4jhmdncajfxd37xmkypo4yphaqq1ue1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776098910-62503
X-HE-Meta: U2FsdGVkX1+k+owe7MwLj+wQkwLneBJcRLbmz8clRgRUoNq/lvc48I1PYRKe/lWHY/rcTAu/p6bUS+tzvCILiz5f0W47UJjiUKU1YNZ7BnpMxIO0fW1FzosVkmzKpAktLTzAnybEtp7cbxThVYekDE1H0Vsd6+NZ6yC9uZI7Ct6ojtp0OU+pYBHHXGrZk7MEG2oMKIaPZBuT8DJ1txmbUWA2zUP5qo/Q4jNvJDF36KqXoMxcau22XbhXj6w8A0ILV7duOUBRVn62qSmXZHM4lewb+ePSVQGkyz0zQTJxp3Tj5mvuphq2o5+iCu1dV5LHAG1uGwXWY13MHKscqafqSn01yRQDgaYmhIblfYIS1Ajkv6Mog2wmnR6F5ck51ih9srLKA/VOIgOI4AnFyLiqO3gt1fuvFd1tl5HtZH7Bem/zNUbLp/04UOoTltgwmLcyODkgm4KvxFyBpVmxIHZcZLHF8A3f04xv/UNSWvyq22EPuHptbVU1bqH73xxI81TVTI0Q+kqDgD+tlp+LDRuO2YYTzXv+X9WqM6oH0asQFSpK2P/Y2yzvHdd1Y3Ef7bgeSf481URCd/I2TiDBoCy+dYkgfHW4kcXydIDCF2D4wEYvK7ZV0F9zB7Y9566ZMchhRMJpuh4a3nSrqRzCzocmJw7CCM1Hw33N9MGbirkaRI7zyM6dW1314nCFJSoyTgMPvFsM7nckruuprISTFU3ogTKqPLtBeiufPGMQrWklYNi4BaO+ClzhKkyWHeHyoZnxg7GO5gdGMKjQ29pNVWj8ZiiGqxaX+cT+6XUxjpUKOXgDr9dQLhPRwbJLiwS8wmDKQI3ljcYsBf8QCTHs59YrBl3JKAaWlB/lFGg9/LanUZufBhT/cuquIyZ5YS+qxWbfccHn8Ta+qxFbh37JXxVttHAHkcUiJQky+IY1CFp6DfPsYLOufQsvb6ClKlXsx2OYi8G9vUmtdWouTwA3J8w
 QdCPixbD
 rTVCKfMRCwxT4EXcvku3gdvaoD+eKAwjTDuvtLN9S9ZR/EDyyf0+xPzKTgK/JOD7Gd2nNrCoUIteJZ1jciQk50xS6bMCLnCJwuGktdkpZsi7qN8qebjXexwesM9uXPRCJmXvEjcbzLb2SPR9pedJjbV+KIvEhUHoPVZgEBAReIHqpz8LSmXo1hGm5czlbG9wWFesi5zOMPR96pPoBXL4IX5mC4qxZBZ8ATRxyZ63nYNeJeKE5Wu2p6Avami9KRkFXhJLjvsqKlANhaK+sxHIQYxqF1mUBGg8GJMBSVrBTOoJoHTOwFuVXRzTa8t5YkHk3D02tZRBsRFGemQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 05:41:53PM -0600, Jane Chu wrote:
> hugetlb_linear_page_index() is just linear_page_index() converted from
> base-page units to hugetlb page units.
> 
> Open-code that conversion at its remaining call site in
> mfill_atomic_hugetlb() and drop the helper.
> 
> No functional change intended.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

