Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC16CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0FB8E0031; Mon,  1 Sep 2025 06:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0C68E000B; Mon,  1 Sep 2025 06:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F608E0031; Mon,  1 Sep 2025 06:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4588F8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:29:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDC57BB6D7
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:29:10 +0000 (UTC)
X-FDA: 83840308860.23.07232B7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id D93FF140005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:29:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o5mX3sK+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ROkKFYzV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o5mX3sK+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ROkKFYzV;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756722549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IstnSSEM6WhAWS9C4yTrjF1j9Id2QMVd3M4qbSZkQLA=;
	b=f4W8SvSpGVvrcFzSkZQ0hsKvJ3hhAZtaDqBBtxhaJLEP2wcueMUGBk36l2SV+4bQoMJNsA
	qIm8xbHCLg+qdEa9UURfB1Ti85fXKRmy5VhTbNuRWoMJTlcPhXvgqvScNgD3BSt1I4rYcQ
	7ymUveeztC5YHf9lCyKPYvs+9/RFsD8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o5mX3sK+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ROkKFYzV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o5mX3sK+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ROkKFYzV;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756722549; a=rsa-sha256;
	cv=none;
	b=sYnecuJMXZQcL62TVHcVPpVTzx2jc+MngM+MkNwNO1sbvrwoZCuuVueODo62g1APuH+ZCm
	qiRjxKq6g44wK2EoWn/Q4BBKDE/FXJwITjBV5ZQsEAlHyArxJW3lw/nj40xsjVdfgaffpU
	tljPJoWo2wR967No1N6rbwCyLAChOoY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 536D621168;
	Mon,  1 Sep 2025 10:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756722547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IstnSSEM6WhAWS9C4yTrjF1j9Id2QMVd3M4qbSZkQLA=;
	b=o5mX3sK++eSAy2qDUmuR5hEyWelNlWLOA73OACqLo0g96WPBsRKyn5ScPIqYiku3p1YNQH
	oDMCXV+1JseOSAoINlTolNqbvmkEJiCxOGdfetKtBrf1pSjkbiqNeriR578kjvWcTjxrUZ
	BusA0NBYQg2V6fISaLVfqXDTwWaKndY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756722547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IstnSSEM6WhAWS9C4yTrjF1j9Id2QMVd3M4qbSZkQLA=;
	b=ROkKFYzVgxAFxj65pnf9qtvf3LkhVlzeFDDpjqx2rRuNm4AL5/ZQ/dQMgo0tk763wCnufh
	BzFd+LBbMfhBOLDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756722547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IstnSSEM6WhAWS9C4yTrjF1j9Id2QMVd3M4qbSZkQLA=;
	b=o5mX3sK++eSAy2qDUmuR5hEyWelNlWLOA73OACqLo0g96WPBsRKyn5ScPIqYiku3p1YNQH
	oDMCXV+1JseOSAoINlTolNqbvmkEJiCxOGdfetKtBrf1pSjkbiqNeriR578kjvWcTjxrUZ
	BusA0NBYQg2V6fISaLVfqXDTwWaKndY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756722547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IstnSSEM6WhAWS9C4yTrjF1j9Id2QMVd3M4qbSZkQLA=;
	b=ROkKFYzVgxAFxj65pnf9qtvf3LkhVlzeFDDpjqx2rRuNm4AL5/ZQ/dQMgo0tk763wCnufh
	BzFd+LBbMfhBOLDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACD03136ED;
	Mon,  1 Sep 2025 10:29:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qlHpJnJ1tWg0AgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 01 Sep 2025 10:29:06 +0000
Date: Mon, 1 Sep 2025 11:29:05 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/4] tools: testing: Use existing atomic.h for
 vma/maple tests
Message-ID: <q5chl5fnmaj6wxlj3aclz7n3k4bz5sgjfliao37wdiefi32mgi@wxefcss6cmqp>
References: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
 <20250828-b4-vma-no-atomic-h-v2-4-02d146a58ed2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-b4-vma-no-atomic-h-v2-4-02d146a58ed2@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D93FF140005
X-Stat-Signature: jwf7t19tkom76n7gm1mjs4ez8uq8uyyx
X-Rspam-User: 
X-HE-Tag: 1756722548-539312
X-HE-Meta: U2FsdGVkX1+PwzQ9T12nF0dNh/Y8VEIbSRQlRMXMYpnGhu0/kRX92uzAGuy0Q6FQBsO+9XYHBKmBYQefsdh7K5E1AHBYGQf1EE9YWRjd/3RzFsCRPzzrHUY/GzAmgcW47kcHSHlqSKmq1SCYoZ3hTs71VYNGDVrIeIoLsOPUHj+xkvPVB+eTaLjsAFL4vIvlNlnDoClzLzc34MBN3180abmjef/AP0e7A9YQbAmygc5z/VjpI8+5dE6RYuHZFWfvqIOd2CfR41zNyIJoeuXwVdpMcQDOW6mfb0uqZ7qStwUjRvB2T23soIKLOzUQ8uBesbBRy8rdl2LEeAM7z/3WEByv4UQuApPY/eArO79RYO+rPhpSdBRGQJimscFMvfKuOOA4eywZZKaePnBK6axKmkYwqetS76A9FOvqC1TLAL63nmQh67yWkSnGK5VuXItBdv+kpbmjrNUwnZufk21pY9lx1zTEOVE7B7wymCQ+aO8g8fNvG4SHBy4Td9OmP9kVpCAaRZZ6nCLIEa8hzEY0K8KIPotQFzSiShiXg0NOfnccOCnQG6Btq0zcAJOjgBgCx/z9Un6YgDRqJR55byM50ZdAIHZk+4whZJ5p/yiT/GpDZt9C5YBHFTbfgX2zucZUpQBi0OTwTwHDCHKWr4tU9tj763O66C+D6msrZyOQYY7J+JwILFIEzPhAjOdUvkGULIOmZAN8qlfvNJYg8oxb+vdOmrezr8Fdha956YHiyCU2cn0PdzSqjQV3JS++VaZzuC278pjzaSm88Z5TqC1b+2T2fhpDA0EvKUy3o5CdBdZN08qBWf9AxbrKF7g709TMAzMdXt5PzV/nbt4LRqSZXE7B0BSu3lPEUe/QcvGCKe+gVu47DzR4rKKRd4DkJE+WWlkeuuVZPbpd8aoOT5Na/C0E8iwzhKJp0zH9NN83uRBAoOxqV6ZYh8XdprBGswWrPlMaBNFljTo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:28:01PM +0000, Brendan Jackman wrote:
> The shared userspace logic used for unit-testing maple tree and VMA code
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
> API whic has been added recently. Now the fake mapping_map_writable() is
> copied from the real one.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> ---
>  tools/testing/shared/linux/maple_tree.h |  6 ++----
>  tools/testing/vma/linux/atomic.h        | 17 -----------------
>  tools/testing/vma/vma_internal.h        | 12 +++---------
>  3 files changed, 5 insertions(+), 30 deletions(-)

Yay, less code! :)

-- 
Pedro

