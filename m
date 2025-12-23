Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E685EE6FE26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 23:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F58C6B0005; Tue, 23 Dec 2025 18:43:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2D96B0089; Tue, 23 Dec 2025 18:43:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284D46B008A; Tue, 23 Dec 2025 18:43:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16E506B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:43:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9CBE138735
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:43:39 +0000 (UTC)
X-FDA: 84252365358.07.AE9109C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 727B2C000B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:43:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fsT8X6bp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vTjmXsHP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fsT8X6bp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vTjmXsHP;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766533417; a=rsa-sha256;
	cv=none;
	b=WrGjcpXRSnZhoBL02Fjx6kdUNv/Kf6RUzyGktgqM0sR5pgXJQccPEPbT/vehUHu96d0cit
	9ApCypYhUjM6sfw+QLCV9MkDdbfdFbbN6odbecEdIE9wj16sv4gfxpaJ5ygkux2ImwToFo
	DCnkxBEwXmTpoHcXwd80RuDGg3Z0JwI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fsT8X6bp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vTjmXsHP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fsT8X6bp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vTjmXsHP;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766533417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jF5owSlvt6znPGAqMwnTm3qXilUL+Wl/Z+u2/aluLhA=;
	b=MG+92WgkK8lGYn7cqTp8QsYnPuAjx3japNwrIomQNIbf+91EbzDDHP1ftSl5BSZUAnSWoV
	CKHZdCv1Ij4bXTOwhEzfDd4kI/N5T2O6urkIcsukAeAYW35ZwIUJ7k3dL85A+/bEqqYRv3
	t3mubnY83Qlv3UWDV0NIgHzVshRG7Qk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 984105BCC7;
	Tue, 23 Dec 2025 23:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766533415; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jF5owSlvt6znPGAqMwnTm3qXilUL+Wl/Z+u2/aluLhA=;
	b=fsT8X6bpzzppOtMJIHh2e70alJNzdiYL2RSvgyd7kFEZ/VlLYMNsiTxSPrk3R8Oj3ekQd9
	+2tYTrJH91OtLklDA8YynzBa6omufZ+Qn71gzq+Umy/vIVZVdiI3LQUfNGx7M2O8esDBxf
	xNPGtbNxGTLZcjphcKIq4GvjNAkFNn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766533415;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jF5owSlvt6znPGAqMwnTm3qXilUL+Wl/Z+u2/aluLhA=;
	b=vTjmXsHPLgKwNTqUGcYnbHnGvlPLd8CzINPDRBSOFeH6Y8O7+cSzqK8l+uIO8phH+mXHtZ
	C5ZscZAvnuM0H1Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766533415; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jF5owSlvt6znPGAqMwnTm3qXilUL+Wl/Z+u2/aluLhA=;
	b=fsT8X6bpzzppOtMJIHh2e70alJNzdiYL2RSvgyd7kFEZ/VlLYMNsiTxSPrk3R8Oj3ekQd9
	+2tYTrJH91OtLklDA8YynzBa6omufZ+Qn71gzq+Umy/vIVZVdiI3LQUfNGx7M2O8esDBxf
	xNPGtbNxGTLZcjphcKIq4GvjNAkFNn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766533415;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jF5owSlvt6znPGAqMwnTm3qXilUL+Wl/Z+u2/aluLhA=;
	b=vTjmXsHPLgKwNTqUGcYnbHnGvlPLd8CzINPDRBSOFeH6Y8O7+cSzqK8l+uIO8phH+mXHtZ
	C5ZscZAvnuM0H1Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC20C13A54;
	Tue, 23 Dec 2025 23:43:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b4p4JSYpS2lBXQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 23 Dec 2025 23:43:34 +0000
Date: Tue, 23 Dec 2025 23:43:32 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Barry Song <21cnbao@gmail.com>
Cc: syzbot <syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org, 
	bhe@redhat.com, chrisl@kernel.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in swap_writeout
Message-ID: <7ng6tntadu62ls32r54aetyevgbghta4oufyzxtq5ym6bprjai@hc2ozb2mbcyb>
References: <6949370f.050a0220.1b4e0c.0038.GAE@google.com>
 <CAGsJ_4w3FQXS4YvRjfjRQrzjjVT3Z7WtvQLJdy76k-yBZ2es6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4w3FQXS4YvRjfjRQrzjjVT3Z7WtvQLJdy76k-yBZ2es6A@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 727B2C000B
X-Stat-Signature: sf9wt8hnt33mrhwp676n4gh1ndtgt96h
X-Rspam-User: 
X-HE-Tag: 1766533417-275484
X-HE-Meta: U2FsdGVkX1/ct8LO4UEO9AgXX81gzDoOHfFGlZL7aL2UAofMItcEUYLJQ5IJjgaByHQ2XaeRkiBrE2d6R0RG+7Jb9rg0bvY6YM41gikkVeri1LRlyf9vPKA7gF6LjvJNs4lh/EI4xezvyXkob9vzVx2BKJP8Fm625QyRauX5rDhiMIfozs8EBZVn+Vx3X7Wilhj22wO+RGFRbCIPTxnfUzOJKFbgogY51k1heW7mae75QxslAZ0fq45xj0Z7WogG28KziBQCJmO0RG+NDDHxluzd/wemeVcF4SjzgzTyPtPbdEE1JICv5pb5nwGuhlDPco9LBkelS/zGVz1E1uzBytOb0XgKeLQmTkOA0xQ5k2JDxmh98QYNguHuREreS8ZavdTxX+7JrjCIcQSdsNGOqm2gM4I3gKgenm7tErnmsa7d37lJvBfV/CUmRkV/GfD/M3MNOEebUYHyONkpffB2cW+c94ZRb82ewQWPb61Lq/ndSW6Z0V1pnrpZlYWxT6+sp6Hxgx7+giLpa6DVOA0P5YaCTXR61guDOVomdhiXmQCD1mkTu9ydbZW2KCqFYjeXPsyAw8qIvMow9Y6Aoj/7zsVOuO5+lxll/SjJW1ZjjCsEQsDH5DKEHlvZm3zDgGLhB2WhpphhukU9a/QnILAAVCB4SiTG63qKCd+/dyZAiuJA5Sg3f2PaJEg5kmeoQfokI8Iw2C98pBTHW24otLzSUvB+1fTvUxteNSSoau0yNa915IQ3QAPAIy7lWOfkeF+Ra+K4wiBJcRrRO0QNGCgun5mryl9lyyC6TAOfFbdZM3ldl7/sY8nywGzioeuADSPzjJ2CYBSQEPpIWUMh1S/99JprjNyNW7gLHgTl3AAgFfUb6I/ZXcES7P2+S831JX8QenwSKPDu8tC+xIDmUVKhv+4SYIW6UCUapKkBZrHweqGngqoRik6Mhz3FHQ/xxT+esU6U0bDoZMPCqzKuEFL
 TldXj0vh
 7YBxtOr7KOsJEX+gsch+JvRBiw8rcdjcYuaG3aoiMNgMrVb/OrZkKyQXPVc/e+mzXfeYu0RQNam8UfXE6UV1J5sqMVChHjtkSnj3bYz1m4+7+3t4pMqQSlGKWIyYFT51Em45Yl4karXFQQvW4JkHlIssvVoOyGME5QjFNzYbqj3fFubPN0dVlH0iqDAXB3wBDBXP0hvf3JCrDOWl/wbXXCUeITQFbs+KabZSmmg0KtvOxmQoE4rUTkt6QlS2jhQsFRuW8Iwk5aSt6hMkZuIIIdIOOcZnqhcieVs28GilNoefWyvvJxKx2EgHQGGG0UHkRKgBt1PZonsp9GIcT7hUNFvtF8GOxNh4FCL1JccUe4HqYDMS4p994ZMnC6Fs8CAQ3or5pA1hccDVLPyFxv91rzc88uJxyECx3bLdwF2O+1y0cgT6pBql8o7pcaOJjWxfE0yFzdWK5X3mWuzi0qOzOc1ING+m5q85HqBWRYcHpNw49hXY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 11:46:44AM +1300, Barry Song wrote:
> >
> > Uninit was created at:
> >  __alloc_frozen_pages_noprof+0x421/0xab0 mm/page_alloc.c:5233
> >  alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
> >  folio_alloc_mpol_noprof+0x56/0x1d0 mm/mempolicy.c:2505
> >  shmem_alloc_folio mm/shmem.c:1890 [inline]
> >  shmem_alloc_and_add_folio+0xc56/0x1bd0 mm/shmem.c:1932
> >  shmem_get_folio_gfp+0xad3/0x1fc0 mm/shmem.c:2556
> >  shmem_get_folio mm/shmem.c:2662 [inline]
> >  shmem_symlink+0x562/0xad0 mm/shmem.c:4129
> >  vfs_symlink+0x42f/0x4c0 fs/namei.c:5514
> >  do_symlinkat+0x2ae/0xbb0 fs/namei.c:5541
> 
> +Hugh and Baolin.
> 
> This happens in the shmem symlink path, where newly allocated
> folios are not cleared for some reason. As a result,
> is_folio_zero_filled() ends up reading uninitialized data.
> 

I'm not Hugh nor Baolin, but I would guess that letting
is_folio_zero_filled() skip/disable KMSAN would also work. Since all we want
is to skip writeout if the folio is zero, whether it is incidentally zero, or not,
does not really matter, I think.

-- 
Pedro

