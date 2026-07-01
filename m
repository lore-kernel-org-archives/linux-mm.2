Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7300C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5AA36B00A8; Wed,  1 Jul 2026 10:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32066B00A9; Wed,  1 Jul 2026 10:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48E76B00AE; Wed,  1 Jul 2026 10:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7FBC86B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:23:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E43C0120346
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:23:16 +0000 (UTC)
X-FDA: 84940425192.11.B64FE8D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id BADE5C000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:23:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kDhD0Kph;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0iTfvM0k;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kDhD0Kph;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0iTfvM0k;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782915795;
	b=IqKUrTgS3BwhkKgWmJTNQZ9Lr33RrYJXnRKdkQJDe5XuLnWtm906YSTorra13zP8ztd0zu
	gfbNSOWdp4QplvtPJ+g6TIDSXaUnrg8Y9EYeV48zd0cB55U6h4fGdgoUn4yds9zw4nsbBP
	DAcl8GgruseM1In/h9dxVFrR/ioUULE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782915795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95W0nKL1hRUxqV1DLYCYkKF9o64WWkoMvBh6p06VBkM=;
	b=Y3xU1z+h4bDnBqnpGZ4nlzTFLCYRwxcnsZFbeYsL0oyHC1DG1Fiz9JdQjUV2GOuB8LmE0Q
	IPPlP7GFZ5FWL1f7lPVPjrXANalHbPynz5n6oAd7JlY5tGhti8uwlOaDh2LB6CHwjZ4qAh
	Vm44xzRpmk4nRHIDO5bOL3tpnASsLKg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kDhD0Kph;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0iTfvM0k;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kDhD0Kph;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0iTfvM0k;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 58407721EB;
	Wed,  1 Jul 2026 14:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782915793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=95W0nKL1hRUxqV1DLYCYkKF9o64WWkoMvBh6p06VBkM=;
	b=kDhD0KpheC/f6fecE/el33e3lS4GXzLSQ1s9ZBXDmqeliUWes25Db+ze2Er9UGrjbwstCc
	iBHmEkNdNy8Coa9E2fIb6X9qTDcSwzKBpZJCLbR/Cu11Y8k/n8bS8Ijxui1H7S+tP27fQ5
	Gl+irvlUzVZ5P3U3WaJffeIPdOBqfMM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782915793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=95W0nKL1hRUxqV1DLYCYkKF9o64WWkoMvBh6p06VBkM=;
	b=0iTfvM0kurn2XV9ZWhpyuYqnCke4yZiUGIKtPm8c8I7R3YpB0QJVXYejip7G2MIyk0EaIG
	yLiy8Zroc3MZxFDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782915793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=95W0nKL1hRUxqV1DLYCYkKF9o64WWkoMvBh6p06VBkM=;
	b=kDhD0KpheC/f6fecE/el33e3lS4GXzLSQ1s9ZBXDmqeliUWes25Db+ze2Er9UGrjbwstCc
	iBHmEkNdNy8Coa9E2fIb6X9qTDcSwzKBpZJCLbR/Cu11Y8k/n8bS8Ijxui1H7S+tP27fQ5
	Gl+irvlUzVZ5P3U3WaJffeIPdOBqfMM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782915793;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=95W0nKL1hRUxqV1DLYCYkKF9o64WWkoMvBh6p06VBkM=;
	b=0iTfvM0kurn2XV9ZWhpyuYqnCke4yZiUGIKtPm8c8I7R3YpB0QJVXYejip7G2MIyk0EaIG
	yLiy8Zroc3MZxFDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66D40779AA;
	Wed,  1 Jul 2026 14:23:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YUq0FdAiRWr8PwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 01 Jul 2026 14:23:12 +0000
Date: Wed, 1 Jul 2026 15:23:10 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Gregg Leventhal <gleventhal@janestreet.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Eric Hagberg <ehagberg@janestreet.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akUezvsxuDKR8D6z@pedro-suse>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
 <akQIIav_zaK6RmIC@pedro-suse.lan>
 <akQO8JtTxmp89GS8@pedro-suse.lan>
 <akQekZUyoKadiGCH@pedro-suse.lan>
 <akUADHLWEetveHLp@casper.infradead.org>
 <akUKty7jsWJrdyho@pedro-suse>
 <CAFN_u7EE0ooQsH2JAnYn6EFrxnRToXAqvW_uUE0aqPDEPEmSAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFN_u7EE0ooQsH2JAnYn6EFrxnRToXAqvW_uUE0aqPDEPEmSAw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BADE5C000C
X-Stat-Signature: i1nhmqxafqipjc1wycicrpk87st6ddoj
X-HE-Tag: 1782915794-350519
X-HE-Meta: U2FsdGVkX19ZUKA7knV2gq0m+dxJ+Wk4Zk3lyvwlIKjdIDYbjAV1ZyHoPtY26ziao4ddpM5Cly5rIDC2FJ+qZwn+RDZceicb+gzFQJQWaNdJiinVt8wVO1jAfJFFbPIKnzabDzSWCY7h1xkaU+J306RhkSb+aodzHC6CIZhYDKShv8eIwnRKM/0nLa4DW7GhldjKNhUpER2ptJxS8+5YL2y+qGanNdFlIMcAGmDcQP6XbJ5m9qAvYCFJ1MJjmD+fKCOxxgRY+N5ztR8H2Nrb9SNdvQo7cLcUm9D4cQWeZEYksDIUGNb5wAozvUdzNP2IkQ5rWfmA30hl4biXCq8GNKVdAFH1r61e0U3EUiKiNTymizKJTrk8vGx2oFWguE+IF5BVcnrmo4kvC4JcB8QRvd/+7sZm9/vkDOdqKM79T6E0OTSAzshbXPhXuoVtDXLmW1GG+ChmafTbsZwsr+PJf33tmP5Q4Zl5a82PGW+m9HqQS/NECuAVxMZFVrxW4/e+qQwncNrIKXky++4Dw9eP2toGCJkQegNb6hQPwDz/RaQAOCK0o67Yo5lRfsyooQO4dw7FlchGNZyF5VbWJoATr7dY/oaS276urCVUXap6Y3jTQ4hOnZe8qvSRKprRLh6CWIYeltwpQsGAIdcsJiOCIhQ3noyNk6esjLkyFVB1SPQsWH/wlV5ojEc0g18cVfRx9h7xD/6KfXddf8HXRQPLx94qOLk/0ngSC9E2hqvblizD1URP3+ufot1oicz/+VnttmEeX0yysyBIQMCXRVvqWdLHcN4hXlFXYbn5Fvdx0fBMlXSg8XpocFZTfpz+TaZIwZ0+Qwoj6IohflCyAx+PEZHUXLTF/08m/bIToLJuieyrr9BcaXQHRqdkECPZMYQIjnFsruZgcwmPHedpqcC3Q2uEAmX0wQTAvdjPEtOiG6qDGLNO28T4aTIR/dJ6xJRk8mcrauZTupeaTo4Hnkj
 45DpQOek
 7CAxeB4bobKqvQjH02hYeRZq9fdLdHO71fxecGmFNp47fVbjsgtVyYHYWjVMAJpmT1UxrAZtthdu0o5R91HnD4OLbvFxmPyPo8A/nRhha+fUTjwiMQJowkOQi3/E3MV65ML1HzSxjoZwslzHSItSrkzO8dCYep5e0JpLR/Ua6Lm2y1pJJ75tBWQxb/fU/K3+A5Y53XI3jqRmrAUVquc/CQGLaB5M5DPuZ8CMJeMi5+fg5RjQX7Cq80EZJMbZDb0o9xCG1B7lTeGNlcUYmayTx9U68vAuv1ESxDjmi2sd5yNNly2EyOO+BiIZUsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 09:07:44AM -0400, Gregg Leventhal wrote:
> Thanks all, it sounds like there is nothing for me to do quite yet, correct?

Correct.

> Also Zi Yan is correct, I meant order-0 folios.
> 
> Please let me know if there is anything I can do.
> FWIW: The patch I suggested did seem to resolve the issue (based on my
> testing) and did prevent my reproducer from reproducing (whereas it
> repros ~instantly for me on a not patched kernel), but I (obviously)
> defer to you all here.

FWIW, yes, I think your patch approaches correctness, but there are subtle issues, like:

Thread 0                    | Thread 1
do_dentry_open()            | do_dentry_open()
 FMODE_WRITE                | FMODE_WRITE
  nr_thps > 0               | /* the rest of the THP truncate logic */
  write_and_wait            |
                            |  write(opened_file)
                            |  /* we now have dirtied folios */
  truncate()                |

where the effective result depends on whether the invalidate lock
is held across filemap_write_and_wait() as well. But it will always,
as far as I can see, result in weird cases where writes can simply go
missing (truncate isn't really supposed to be called without the inode
lock, I think).

Matthew raised that, fundamentally, large-folio unaware filesystems should
not see these file THPs mixed in with dirty folios. Which is sensible and
seems to result in a simpler and easier to reason about fix overall.


-- 
Pedro

