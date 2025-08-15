Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F51CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44AF8E0007; Fri, 15 Aug 2025 13:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6718E0001; Fri, 15 Aug 2025 13:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5598E0007; Fri, 15 Aug 2025 13:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 998418E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:06:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 496ED16021A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:06:52 +0000 (UTC)
X-FDA: 83779621464.19.791C002
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3E98B180006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:06:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gQBfVZCz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/p860hM2";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gQBfVZCz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/p860hM2";
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755277610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uccM8kZmqedgGup1mx23o04K/x+hNFFVdcMyZEbPEOA=;
	b=LrkaPWXq7Drsq4SdGPmv2fL9wBLEML6boVWIJCrgRhU2iYV69HkZZDJ9zpd+bjAwhAZFp/
	q7QEili/j2R8xguU3sxjB64tGwHcB7VLHlWwblJoA4jqWwIzeRZkCKK8Wqy8kaDYuLs94S
	h6MZulBs6bVrrSOdoGFb3BlmHQWrJSE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gQBfVZCz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/p860hM2";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gQBfVZCz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/p860hM2";
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755277610; a=rsa-sha256;
	cv=none;
	b=ZZmIyOXXGZKvNl58wXirC7ACulr7PhF5aA/l/+qadFTrZ/w2ox7mHL20XOunUgUQUYhC1L
	7RBWNw9xFdsDDvDLJBfE8qiThQwhV8aS5+ZW6vvddVe8cWifJGe1YMYXV/OA6V2EwxvgS4
	Y1NwuvQX9oUi990DisTtAw85KdjcCIM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 804701F83C;
	Fri, 15 Aug 2025 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755277608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uccM8kZmqedgGup1mx23o04K/x+hNFFVdcMyZEbPEOA=;
	b=gQBfVZCzL8XjVvRVv1xBNgvLDmCwe4Mr6G9J7e7FgwHAOh5HB9WWbi8C2USx89PfWl+SFO
	2BYWOQh4rvoAJvzGJ3yMZZ2UAAn8COQxt31orjfgBl97wj0fOSF3Sq5BCrwCGmvrgtbvDG
	efIJf+gq5NIJivDUHrAA3WTW1FklRMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755277608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uccM8kZmqedgGup1mx23o04K/x+hNFFVdcMyZEbPEOA=;
	b=/p860hM23pO0TV79cBNHKMQE8xdvZJW/8aBzhr/3i/Joh9yE6JubdeBQYa9Z29672nudLp
	4ylUlxeaHKfPfCAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755277608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uccM8kZmqedgGup1mx23o04K/x+hNFFVdcMyZEbPEOA=;
	b=gQBfVZCzL8XjVvRVv1xBNgvLDmCwe4Mr6G9J7e7FgwHAOh5HB9WWbi8C2USx89PfWl+SFO
	2BYWOQh4rvoAJvzGJ3yMZZ2UAAn8COQxt31orjfgBl97wj0fOSF3Sq5BCrwCGmvrgtbvDG
	efIJf+gq5NIJivDUHrAA3WTW1FklRMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755277608;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uccM8kZmqedgGup1mx23o04K/x+hNFFVdcMyZEbPEOA=;
	b=/p860hM23pO0TV79cBNHKMQE8xdvZJW/8aBzhr/3i/Joh9yE6JubdeBQYa9Z29672nudLp
	4ylUlxeaHKfPfCAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E98071368C;
	Fri, 15 Aug 2025 17:06:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rJHZNSdpn2hzMgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 15 Aug 2025 17:06:47 +0000
Date: Fri, 15 Aug 2025 18:06:49 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v2 1/3] testing/radix-tree/maple: Hack around kfree_rcu
 not existing
Message-ID: <ttrjb4dhf7w6da3qqlav3kydcpohtimmdewvuxiojdvd3drn5n@rlxb6q656olb>
References: <20250812162124.59417-1-pfalcato@suse.de>
 <rocriz7qo5is6m2dcimj3qiczgv3eoneqwrqvrcpsrtgqnnmmy@eswbhyo2a6w4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rocriz7qo5is6m2dcimj3qiczgv3eoneqwrqvrcpsrtgqnnmmy@eswbhyo2a6w4>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E98B180006
X-Stat-Signature: 11qhyyeo8oxxc9ukmh3eqkmf58jjz6he
X-Rspam-User: 
X-HE-Tag: 1755277610-629559
X-HE-Meta: U2FsdGVkX18T/H7ss9UrPHJjSIbZarS81bbZZLnRPvD8lC5mRHepzePkpetiSzHf1j/WE4sP1r6WxweCcTpmKJNb1Dl5BeqL8OkwBXFc718OajmQyNwkESNWaKa89ITCZ1Vf4Fjt2VIziqpHg96uLcJk494l1niV5DuuezIzdH85vWGiZS4oIOzIQt6Ir6Nwih6ERw4buzqTOo2cEId9uaGB3ymHcf9D6v48B0tTG8gqp7On2KGnOShoU0xz8NBmXaOb7po8w+A6nh4uOR/mtQRVdpUNC/cudvTjOVjITeyIDnu8469I+34rKjbOUed1ZnOmZXcp9UoqxlnClt4SQQ8TTWzECiE5BAfQsiPLJkmqIWt22oWOeyCrlua70qP+QrpezbQwXC/J/ylqSBN3/a8v3KGWvnFOOWyv36bJWMTxMk9wBvXPxZxZEFSrdDBwl5h4XFh/JKPPGqP6BRMcQkPvO1GCgc/cgZ+mn8c9EUNqHK/a7p9RgjqzMCruTkKvxsZZwEahIyYy3M/ovcgIL+XztOmoUGXg8psBGESfFrGrf27spJcvttjSEXHzzZflSg2cy90Dm7TphfDSBbmdojXNQwsbb4ofzuMSikuV9jQs9n/YHnb66pXiisefrBOOHvuIGzn5LpMErPqUFZUrncl38/QlBQJKV9ss6EYvM5wZ+AU1GxOMhwPMczvmDIzkMj/H4oZoiwVVjZnquJQTFgWQkvXMblnAGFCUYsdOcPM8ze1OAzP5allIW1A2OL2jkaG9w84TmHr9lDEokKfKiap01M+bC6kie2mBUZiHEmc1Y3EyK/xeqneJvY0nDuNBYzUEsqgOaiQX4Vp6DBJUZIzLjq5gd+TQoIIQvwl69+5L/bDmzRvD0rdnbJE50WiyL2u4ihiTMd6PkIynMi7dLB9l1FxVIJgEgKU547qxAP6ZM+2y1+mcEW+sh9l+9Cfe+EfuxvfSyXoMWXhfCtI
 lAZDRfjB
 jKzuWNbHS21WVuGcue5zd0TbeGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 11:11:30AM -0400, Liam R. Howlett wrote:
> * Pedro Falcato <pfalcato@suse.de> [250812 12:21]:
> > liburcu doesn't have kfree_rcu (or anything similar). Despite that, we
> > can hack around it in a trivial fashion, by adding a wrapper.
> > 
> > This wrapper only works for maple_nodes, and not anything else (due to
> > us not being able to know rcu_head offsets in any way), and thus we take
> > advantage of the type checking to avoid future silent breakage.
> > 
> > Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> 
> Andrew,
> 
> Please drop this patch set.  We will have it go through Vlastimil's tree
> to avoid conflicts with other work and to maintain the userspace testing
> in mm-new while that happens.

In case this helps, Andrew, it's maple_tree-use-kfree_rcu-in-ma_free_rcu.patch
and testing-radix-tree-maple-hack-around-kfree_rcu-not-existing.patch in your series file.

(Yes, I should have used a cover letter here, it would've made it easier to
manage, my mistake)

-- 
Pedro

