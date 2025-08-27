Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2F58CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 12:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317E18E014E; Wed, 27 Aug 2025 08:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EFA98E0147; Wed, 27 Aug 2025 08:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205968E014E; Wed, 27 Aug 2025 08:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 100FC8E0147
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:56:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67AB8843C1
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:56:50 +0000 (UTC)
X-FDA: 83822536980.06.226F7CC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2538D2000F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:56:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UsQ+LUKR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=673aaeOv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UsQ+LUKR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=673aaeOv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756299408; a=rsa-sha256;
	cv=none;
	b=a/rk80tdKChMJ69LCluBEFbBCvoJkd+xMSDCpSSF9mE66p4BhYtH7m1qLQP1ef5MYisdF8
	r/pDe76xnHbOFXNXtQpKFlLSp2hBimVM2wW48a3WMC+kdNWrH0TLoUqEwbKjg2uecxw4D1
	4PbUpvr87lQWgYa+Y0QP5grKuiKcS2E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UsQ+LUKR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=673aaeOv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UsQ+LUKR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=673aaeOv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756299408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aq7wpdiF4pl/TGxZNEC5pqur7Xst8wsCEhYLoncfMXw=;
	b=zq+6ElezsOUtiZq6RLD8z9KkFZfRNOcURSwyeb4QC1WbLj2aWTikjSB8PiS+IEwz+wKanv
	/UKWh6CVSUCyhbdzYB2Z/RZj5FcJxNSYylNiSIEV8PnfGBH/8LCkxgGb4eeP303GlE5fAX
	P2b72z2XwsGhT8AtwJwEF163O2Yw8rs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 648FB201DA;
	Wed, 27 Aug 2025 12:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756299406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aq7wpdiF4pl/TGxZNEC5pqur7Xst8wsCEhYLoncfMXw=;
	b=UsQ+LUKRKwyy8Ys3/+6fym05z9/crxCzboVbu0XIo3r5sywbl9OViz552Fp6zjKhgzroSC
	JHTlJEnBiqi0uzdcyIGpUwlTKsD0ZRzR7rNwkBhHEOl3HBN3/DXnIeydNJJbykt/H+vC6e
	lq3APQxK7Cmb4l6OLPDoZ9tUzhD8GOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756299406;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aq7wpdiF4pl/TGxZNEC5pqur7Xst8wsCEhYLoncfMXw=;
	b=673aaeOv/+DLVfJCzQAvWk1+3jdWxqGW7VJUe3XwsPT+qbQ1p8UwvtR2LEa3SxVtQxSVYA
	PjjxpTu7HqZWu/AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756299406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aq7wpdiF4pl/TGxZNEC5pqur7Xst8wsCEhYLoncfMXw=;
	b=UsQ+LUKRKwyy8Ys3/+6fym05z9/crxCzboVbu0XIo3r5sywbl9OViz552Fp6zjKhgzroSC
	JHTlJEnBiqi0uzdcyIGpUwlTKsD0ZRzR7rNwkBhHEOl3HBN3/DXnIeydNJJbykt/H+vC6e
	lq3APQxK7Cmb4l6OLPDoZ9tUzhD8GOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756299406;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aq7wpdiF4pl/TGxZNEC5pqur7Xst8wsCEhYLoncfMXw=;
	b=673aaeOv/+DLVfJCzQAvWk1+3jdWxqGW7VJUe3XwsPT+qbQ1p8UwvtR2LEa3SxVtQxSVYA
	PjjxpTu7HqZWu/AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C352313867;
	Wed, 27 Aug 2025 12:56:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xmqFLI0Ar2jZWwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 27 Aug 2025 12:56:45 +0000
Date: Wed, 27 Aug 2025 13:56:49 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] tools: testing: Use existing atomic.h for
 vma/radix-tree tests
Message-ID: <xz2m4q24kgig36wu3enk6qlsxo5xywsaffgivyubadsps5topi@6yupqs7b7cze>
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-2-5d3a94ae670f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827-b4-vma-no-atomic-h-v1-2-5d3a94ae670f@google.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2538D2000F
X-Stat-Signature: wctw97c47j5h9jozf6do9whzoj7nwwjn
X-HE-Tag: 1756299407-866262
X-HE-Meta: U2FsdGVkX1+IGKGLld2aSqSNVs1FEm0vlGuDDiHvahdmwqDvubElYeBVpM0lrC5QoSlQtmwGG4dTwGjUSyFoTWBR8o0iQ8QW63uA94nwzMqYjiBtIpjSVP6c0QqaaNT9r/82nDg5m5BvW2cHvfITp2eKyYpRDfdRgj2IzsSxodfIOZhySHlFF1IkHO648Db3G2O7AnFwAGJD7UTxsBuPMbQlXf3gALKj4H4Ms1zGj33jnF0BAUwzlvZtTmW8BQL4GuXlYgEXJ2iUjWwARajIhjliqI9RVDAF84SpwYqJezB9ppPyrOjxe0B839vBPOmNI7ZXUEladopjXWBF0ffxWTiMphVb+964ZkeaFdQybYvdda74gnuBcPhTF6lDSJMrVBNzrUBSvBX1qiTv1mXCoZnaMOH9emhSvaTSWpFG1MB8JhjVS1yL0dl4Yp4krWPCGNElBzb3sGBYspmJ/NKac7RenKp7YKl5yuxhFvUYCvs1ah7R5iASF7/5wwf6oYjB3ZdDmOcC3VkOUc4KC9YkXIymkspbJhuQRgMykzcFab3Lv+vjGuvbnoyXb47byksoxLnkxLFg4Tc0s4/SI6zS0Cz6E+qBIbna7LwAdXxRYO2d7f63jzRPV2jIcqhwsyS1/mdD4t+7iQZrAKCKryXTxJRPR7bvAEMtnl5qeMPiCMsdFqUhydoSVpKvCZF5qYrsW4BbE5hZnG7BcgaOGt9YXMoRu94oqzpBY8QufO+KbvBuAyr8dYbbqaDEURngNehheOp8EH6LIKOEqg60ZMG5broKucf7L3VPWO6V73WeD6Jawie9jzJksGKtsSgzBaliTF959meGOOE+HQtlh8AY0nPeAI2c+LUiGF8OU8f/O1yZRbG8pFPbAomstr3ZF4kfE0LfxsZfyvmpxkkP5Wj15cyQhfdvAMVKP2hCDGPwhsCX9+JMOoxICUtJXrRVDdkmu5dzn3gD9SEjfF78Fsb
 3Lwcqc0W
 fqtROjulKJIey/98JbZR69lKflqU1riGTqhU8hKMK4bZk88SvTXCg8OGif4DJ5o+jok65WFcf0/rIJ87loJr7/thQg81nrS+9FbK17+582xllSmSKZ7ZPoYlJ3kzU3zNPx0PemBH/4fxPT1NBuf4aKPE1TQVIQPieTT1C8vBGsQNEBX726XpMUlNd9wbMeo7pk5PTgYAhl+YTI4FmZiMxPtv/s2cYyaSn84N484SbSCeGpO22UALFglhiQGqmUQaYXnprsts7ipc0tBiNhMsLRF/C5vXhfJCbJDuchGY8CSa0Kd0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:04:42AM +0000, Brendan Jackman wrote:
> The shared userspace logic used for unit-testing radix-tree and VMA code
> currently has its own replacements for atomics helpers. This is not
> needed as the necessary APIs already have userspace implementations in
> the tools tree. Switching over to that allows deleting a bit of code.
> 
> Note that the implementation is different; while the version being
> deleted here is implemented using liburcu, the existing version in tools
> uses either x86 asm or compiler builtins. It's assumed that both are
> equally likely to be correct.
> 
> The tools tree's version of atomic_t is a struct type while the version
> being deleted was just a typedef of an integer. This means it's no
> longer valid to call __sync_bool_compare_and_swap() directly on it. One
> option would be to just peek into the struct and call it on the field,
> but it seems a little cleaner to just use the corresponding atomic.h
> API. On non-x86 archs this is implemented using
> __sync_val_compare_and_swap(). It's not clear why the old version uses
> the bool variant instead of the generic "val" one, for now it's assumed
> that this was a mistake.
>

I don't think it's a mistake. Namely we're checking if the cmpxchg occured.
So in the new version you'll have trouble incrementing i_mmap_writeable from
0 to 1, where in practice you should (AIUI) see 0 -> 1 (old val = 0, retry) -> 2,
which is obviously not correct here.

At the very least you'll need some:

do {
} while(atomic_cmpxchg(&mapping->i_mmap_writeable, c, c+1) != c);

to keep the same semantics.

-- 
Pedro

