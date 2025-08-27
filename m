Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF9BDCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 12:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450C96B00BE; Wed, 27 Aug 2025 08:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401F06B00C0; Wed, 27 Aug 2025 08:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33ED66B00C1; Wed, 27 Aug 2025 08:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 21FFB6B00BE
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:57:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFB901DE4C3
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:57:26 +0000 (UTC)
X-FDA: 83822538492.02.CA6AFC5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 97DFD1C0012
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:57:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Zqq8jlrz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZwMjA8g;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Zqq8jlrz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZwMjA8g;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756299444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAD7QJFjzDq1GdtAMg84jhFNCEBk4Gc6C3N9ret1YsY=;
	b=mexbtPJzmHvD1dAoqVamQ9c6h6hSCap8jWFoX3BO6+alyudIrcZ2JVNGA9f2D/Z+wCfl7b
	yv4rqqGA7UJIs8jZmQA7GGY8MiMrL+yKxrN+60yoQEuylrvpfub8QEqUlF9RBKl9akx4Y/
	YywNs8ROXY6RwezNZ/Ki9BWbYCITZuc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Zqq8jlrz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZwMjA8g;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Zqq8jlrz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XZwMjA8g;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756299444; a=rsa-sha256;
	cv=none;
	b=aX2SeNE1Z4V8ctDZ4Jqdxubi+0n8JPBgKJuHMq89V3lQFtOII4Vg6S+txnOYLSGTUhDV1f
	EtZ9HiT6C8oiK4q0ZV+WC9nji3FtAEsuqp5PJWjZJl3UXzvdP4qrrqhp75KBLMKuj0JnNz
	WZSJ7c6Ep55pe8YUDvsRu37JvBhbV8Y=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4152E201DA;
	Wed, 27 Aug 2025 12:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756299443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qAD7QJFjzDq1GdtAMg84jhFNCEBk4Gc6C3N9ret1YsY=;
	b=Zqq8jlrzHa+lfboUerUcQpfjmp2RjaEY7e/37gHTIotLvZDbIyP6jfD9dofMYwbjAS/o5y
	esS4S4uS6+i1eB8AB7NuejCXv/xzg7abM1P01zMiji3PwXBz3FZTZm1kAlbMM9s17XlsYE
	mGMGMD+BrZBLf9UECrl9bJ4at7vnW64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756299443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qAD7QJFjzDq1GdtAMg84jhFNCEBk4Gc6C3N9ret1YsY=;
	b=XZwMjA8gacDvHqNchC6esmuSdoJneq4rdBDpd3E6wxY73fKqBxZKvBg8+7TXXTEGXFUL5l
	oYk/dk3DZxwvjECg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756299443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qAD7QJFjzDq1GdtAMg84jhFNCEBk4Gc6C3N9ret1YsY=;
	b=Zqq8jlrzHa+lfboUerUcQpfjmp2RjaEY7e/37gHTIotLvZDbIyP6jfD9dofMYwbjAS/o5y
	esS4S4uS6+i1eB8AB7NuejCXv/xzg7abM1P01zMiji3PwXBz3FZTZm1kAlbMM9s17XlsYE
	mGMGMD+BrZBLf9UECrl9bJ4at7vnW64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756299443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qAD7QJFjzDq1GdtAMg84jhFNCEBk4Gc6C3N9ret1YsY=;
	b=XZwMjA8gacDvHqNchC6esmuSdoJneq4rdBDpd3E6wxY73fKqBxZKvBg8+7TXXTEGXFUL5l
	oYk/dk3DZxwvjECg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F47B13867;
	Wed, 27 Aug 2025 12:57:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XCHCI7IAr2gMXAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 27 Aug 2025 12:57:22 +0000
Date: Wed, 27 Aug 2025 13:57:26 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] tools: testing: Support EXTRA_CFLAGS in shared.mk
Message-ID: <6dd6xhsz44j647oon37oavwazd6lte2htv6tu6ecksnrwebpdd@gtdisqzbvfqi>
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-3-5d3a94ae670f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827-b4-vma-no-atomic-h-v1-3-5d3a94ae670f@google.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 97DFD1C0012
X-Stat-Signature: 83mgsttkpx9m6bzkmyk7t39m97uow3ku
X-Rspam-User: 
X-HE-Tag: 1756299444-182914
X-HE-Meta: U2FsdGVkX18DtbIfPYTzJpTyjOf2U24Qq02mm7fhuWYH2OoJ/xlduF2SBvL9Ku3R4aeTAxK+T/mM8iCAgFUwGK3p1dEYNTAMQ3oCIpURVRx9h9oT3VZfVHBiuZF1GBS1wJmAqsDJXh3u1k4/I9v8kEfLquyXEaDX1hOjRGY4w5gyTKX/mMvgm5ryjcw7DHDLbCAuhekI1IXChpSxT9QCAcf24tfOXzAlUzELLS2kjhoTsAQZRaxYp9eXAX1Ao2m5VySLGDofRZhVvgHV0Wbs39AXQTd2q60XOnFe4QgKWMWgbxeeQtdvKc9I4K1eSkzHkL1dYlWQnj0+2ONThfgPtnXyU68h6vtVjNLcrCLKb4xk08OysOYsTf+PKZVBw8dN1Be2DmgMDNQcr/WMAqSm7xZAr3iloGD4QX27QJqWRg47BM8WjyZhnGjnqT6Vzlb+LdDC5zuDkZp9mlaYN3YPtfinOk6G8dkzbyQphzC0Ew2MAlkl4EAFZxCq1JRQAHAaoUfJizotjffGw1vimLBzJIpTHXNOhhVwvMW6GOxFwAfLcspWwNhL8qNYLo+r9fgJsjjVsfMjuSYTblbzgh25/BJWj4DcNbaMPOrZjcbsheqmtuvTFzzrWnVJHCEB4Bs7BnZoN/Q/TfvIFCzyLjVOeMVLaSubbTQSp7RFNoilwGjkuEw2Rk22pO8+p7u8MuY6B2CsOmQQfv/rqIvdXGRxDhpHbg1nMkGyh0jcmYcA1nsRL5P96Y37KC7SMJXTAEuj5V1Tnn2uDg9dLMYykeRqwfId/g96gcDefZGhlUa0VlhARPHQWVvk5Mmd5NTQ6ulWJ3294Z4Blt/qNqUDT/HCEvtZKCulzKhtrqEMsq4lUFmhV+MCWfpJdlShozoPfB2P+zxFaPBqH30V5cha+324JPbGJ9kB9LJ8dIBvJONn/zdA5+PR7h06KoKsw0TAzsScgmF6vt/tultrbOmxmf8
 +f3Nn+ls
 ZiHiu2ZxHco+RpG1Ifdk5QoAv3RTYi9jNtHs2iJjrOOYUc7jI7JvWVyf+IlL9ConW18m/AIFvPl2oDzEVtZAH2hY4bDXqMrOScj53NjCU5hC7UHZmROPMi13zBkpcsZamA61VoSAJnmBsxVRWsitdxgT5mXax6iC/yyfc9T5TpvGgRxD/Ip8zoSDbWJ9fs3Gnrhr4g/JV1m/ME5ExMU3epH1k8dH4JWBNSs2WcgK4ceNM4JfMMpNJZADg+L6e4zpil3giaI2qAmSJNg08DmA+5K5ACy5usb6yw3jZE5evf8ovMvxRYKpV7Y1DtrijOh2gpX1uvwQwEuyVtsnBCoK1mPehnA+BV9+voQ6x+bQdR32fCI4zD6MGfK/pIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:04:43AM +0000, Brendan Jackman wrote:
> This allows the user to set cflags when building tests that use this
> shared build infrastructure.
> 
> For example, it enables building with -Werror so that patch-check
> scripts will fail:
> 
> 	make -C tools/testing/vma -j EXTRA_CFLAGS=-Werror
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

