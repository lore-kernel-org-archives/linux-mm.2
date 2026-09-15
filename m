Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D25AC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77406B0093; Tue, 15 Sep 2026 11:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B501D6B0095; Tue, 15 Sep 2026 11:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65EC6B009D; Tue, 15 Sep 2026 11:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 780776B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:05:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC60F40417
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:05:13 +0000 (UTC)
X-FDA: 85216319706.07.5F4167E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6FDEFA0010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:05:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="QJ/vpXw3";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QO35NEmy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=myMqx+02;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lW1KVg7W;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789484711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3KTT74G6LskIv8dzV6ZUH3pgNKrm9kQ/2p813ga0zQ=;
	b=Yyb3TKcB28WGcrZkHBtry62QGr3Fd9f87e/FDr1ZDO79mAeVEXuTaWebEJK/0mVGygKuBr
	5R2M4CL5QZFY3AtW1oT+9HRqn4GV1PIh6MaYXm6ujw6u/zOJhjzBidCKom0GAJYCdUmY4v
	kcCdjuyjuZ+XnUpOZgziiprLZNv+uLk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="QJ/vpXw3";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QO35NEmy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=myMqx+02;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lW1KVg7W;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789484711;
	b=0BN/UlUKXD455POFu6B8j2IG88mnzR/KIatoLxXPV212hbeJ1ErH20IynpGao4WSIASsuc
	+wNBHA7w4GCyqHUvlE2qH2QkHXRI9zWOhtgAa2nrFa70HIt8QPIQxh2tE9ciqFzhTX4xL3
	adw1X4Z92MDVr4yu+BYsTd9yJ3KB9F4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 939CC21DCC;
	Tue, 15 Sep 2026 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789484705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q3KTT74G6LskIv8dzV6ZUH3pgNKrm9kQ/2p813ga0zQ=;
	b=QJ/vpXw3QdaUNQagKfYMcIVKXmQnreVVLxTI6XgCNG+7/AGPmhnhCFq0iKDVpxmrwVgc49
	r57x2toR4P7GHH/7RM0oym11SkeCCWH942FPadfJngfmMjJlfKYgTFcgxUSnsiQA4ocIRO
	g8aRxpzFNIHD2sWhXEcm1uEkFPkBkQU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789484705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q3KTT74G6LskIv8dzV6ZUH3pgNKrm9kQ/2p813ga0zQ=;
	b=QO35NEmy72PaPlmSffOGLaWz2fIaltuiM5QjcXvjc5iBvru1OnS6JycExT8+qAOPlRtCyF
	S7HPsd5FRnBY7HDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789484701; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q3KTT74G6LskIv8dzV6ZUH3pgNKrm9kQ/2p813ga0zQ=;
	b=myMqx+02zxqHHpnlBr1u0o8JRTo7zIdo5SMIvU/DthRTvYP6c3hvdrYUhtka42QSoVntxI
	47UeajR28s8R8pUYck759kxpYlmrROu2/U3I2U/Hr+nPsd8Ocu+4UtQS6PJ72Zt8v/ZS+Y
	QLoGu9ixdpOte6Ni2DFz3/6HrN30rJY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789484701;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q3KTT74G6LskIv8dzV6ZUH3pgNKrm9kQ/2p813ga0zQ=;
	b=lW1KVg7Wg/U3urhnRqoN9WjQC7RhbHmWeo2EWZg84JLmpX5kTp/nnFUw/xBgJkvwB+Fkch
	yJPNFsNSX9Ham0Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB29E136D1;
	Tue, 15 Sep 2026 15:05:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hUP1I5xeqWr3XQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 15 Sep 2026 15:05:00 +0000
Date: Tue, 15 Sep 2026 16:04:58 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH mm-new RESEND] mm: mincore: use per-vma lock during page
 table walk
Message-ID: <aqleTfv8mqayeAo_@pedro-suse.tail5790ac.ts.net>
References: <20260915143138.2595767-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915143138.2595767-1-wangkefeng.wang@huawei.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6FDEFA0010
X-Stat-Signature: ta1xs4ngi51rnqe7ekcb4iw3na8brjxf
X-Rspam-User: 
X-HE-Tag: 1789484711-116851
X-HE-Meta: U2FsdGVkX1/KBKtaJYR2axpB+fXERarIu95z8HrIVlfcQisMiohPm89Jt8j5LbIeuAOLnXPm3cKmIlymQ6SHJFwg6y9aFzJPeN9A1urJSRv7g/uMHW8RoiFmhqwf9cY6V5W0HZ62+sJRR33sM32iTGMlyN+V7uV1QaTlwYz1VTGASVLry7G+pOOHJlQ15xFji4zRc2iuFSyLdllZei0+duMD7+ky+ho5yGxzjzCnTjcKmsz9yjAhlSdZyHWbrc5t9h1nKpdALUPMJBBEATws3O9ZD5UCcoxFEkLJB5Icab4u386mLD98mBLhw0mdggJFq081GMY5o//BZoUACnHBtPRfYvejwMkzI1hcXenG6W95t5i1Yuxsj0+14jFPWLrAYiCTjgRW6Oy8GRYwRJRSVvvFSf1Gt3gGhZMw4+W+hF4JKyg8qnRO1kFFRpHXkvY7kGgzcuhMWUjvkw3hHiuF0z8ab/dxIP6sNXf3j9ACbIsdRHMqzAb5AV3o26PKqsEe7bZWAh/NT3Hal+WfpkNy6bX+jWxm3aK6KlCHOcgH6/eETpHtXLKxOND0WaZ7r/SGyGUKYotQ9vfC3QKsvSz9vZt0l2aFcRTFEfUrdtyzgtjP7KhuK7IDrC/uU5ZFKCuneGFOPf5qgkoo8Bt97fv+gPcqRoj01Js+qSYJet27FKjaQrR0yYDTXyYcdWdHH5xuQm7/MXaTiIYP5PT6L2pUWrYTOrMUaTGb9UBF4934Wce5Ln5N95RN7WCvrfmfzgysPR2euC5yA6woij0kXXfzgm21svc8rrhAG1E3lFWn/8ZeoRWIf8WPkq7gk04HP9r/bFVMfnYqDzISzH54O+OCP+99Ncz+AVaThw1B2ScHqnDsO/+H2UFw3YcgsBf7JJg62D6C3/EAC+r0KimsDwEPpAmKp6InehoiAiSThNeidjdxhTzZvJc4B1FfAMEZM01erUPsHt09v3bt9M1VSVr
 S06mrblw
 V9kQcG0/7SZy51IvxQIe+AljXLr6sDWuTQV3o7BExinVAGGkTTspgYy1nVSgGH8CGwpG3VGjSSVL0NNmKz0lflVwPTfztgDYbNpM2Cis5qvAfRtj2HpveWVH0n+zBf46LmwsYFKTrM40st2hEtElYWCu6HDd2xpUQ/I6Lm7XgErenqO1+SKIDWwx9C8Y4Czz9E3prrs0MOvGhgxITzLE1ANLClXblaPS7BUNUfcT+hwDScPXdkpcrAMuFpSbBa0z6Q2G0XO5r+Fd6wyYklwq5yLK3O4zcBV6mUP+D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 10:31:38PM +0800, Kefeng Wang wrote:
> do_mincore() performs a read-only, per-VMA residency query,
> making it a good candidate for per-VMA locking. Convert it
> to acquire the per-VMA lock, thereby reducing contention on
> the global mmap_lock.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Looks, to my knowledge, correct. Thanks!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

