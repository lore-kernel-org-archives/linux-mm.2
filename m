Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF4FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 10:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770F78E0135; Wed, 27 Aug 2025 06:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748398E0105; Wed, 27 Aug 2025 06:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E238E0135; Wed, 27 Aug 2025 06:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55E368E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:12:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04FC71DCE3A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:12:25 +0000 (UTC)
X-FDA: 83822122692.12.17D097F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 88EBC180006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:12:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uYMk9nvz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mo9nlDZ1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uYMk9nvz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mo9nlDZ1;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756289544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZWR9aJkgWwglSMfdEyNeZDC1Q/6PPvkKevPkH+vfo4=;
	b=jncZqp9aM6J80Sk0LBYqFTOrMRumF0yihN33pJF1pP1SFTNQKm4nurlZRqSFxkMuH21OwA
	o5le2Co2RDHp722v9XPTtvy1qDVbpJiHvmba0BgOSqpUqRiQABV4RMTzTBhWoHzIdq+OyV
	yr7WvGbkWlEfic3rg+5Xc6j1Uh3A5xE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uYMk9nvz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mo9nlDZ1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uYMk9nvz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mo9nlDZ1;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756289544; a=rsa-sha256;
	cv=none;
	b=sbRygkOIiSJ8zd4uZrlcTUbz4dMET7VTA4bq1owLnXmWu4QnOOHRa/bYzDRZs1eVNZ53Vg
	noscn3SbCmU7+ZlZen3k6799j7LAfFvHT54cqlEo3Z8To7NU5PVuEkpkYKzddtCU/DsCMY
	U7QoMDFqtovTdS4KZnIi0orx3V8o7rQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2A35C2226E;
	Wed, 27 Aug 2025 09:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756288547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AZWR9aJkgWwglSMfdEyNeZDC1Q/6PPvkKevPkH+vfo4=;
	b=uYMk9nvzQYWrPL+U2GotGUao9zbNWGf3/mAL/+56cqzZ0zjzJZd0vlQ1lptP7zRASaK5wU
	LzrGzwGeHEW8VCg70USFPKPEAY8RAuKhuX22k//oLB5TFyofSlunuGvMcYMkjHd72Enz/M
	oBJpCuPV9UP8H5So3ezgFl7cPncIf4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756288547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AZWR9aJkgWwglSMfdEyNeZDC1Q/6PPvkKevPkH+vfo4=;
	b=mo9nlDZ1oFMRRLO6cZHtRjkW1zihLGZQxortiyhZylBKeBiwNtsXQBUAprlP7SqEKZrfA/
	x3zMP8G5+fUaUjAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756288547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AZWR9aJkgWwglSMfdEyNeZDC1Q/6PPvkKevPkH+vfo4=;
	b=uYMk9nvzQYWrPL+U2GotGUao9zbNWGf3/mAL/+56cqzZ0zjzJZd0vlQ1lptP7zRASaK5wU
	LzrGzwGeHEW8VCg70USFPKPEAY8RAuKhuX22k//oLB5TFyofSlunuGvMcYMkjHd72Enz/M
	oBJpCuPV9UP8H5So3ezgFl7cPncIf4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756288547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AZWR9aJkgWwglSMfdEyNeZDC1Q/6PPvkKevPkH+vfo4=;
	b=mo9nlDZ1oFMRRLO6cZHtRjkW1zihLGZQxortiyhZylBKeBiwNtsXQBUAprlP7SqEKZrfA/
	x3zMP8G5+fUaUjAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 065FE13310;
	Wed, 27 Aug 2025 09:55:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tdTGACPWrmhaIAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 09:55:47 +0000
Message-ID: <229010f4-a68c-400a-94bf-4532ee451ef5@suse.cz>
Date: Wed, 27 Aug 2025 11:55:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm/slub: Fix debugfs stack trace sorting and
 simplify sort call
Content-Language: en-US
To: Kuan-Wei Chiu <visitorckw@gmail.com>, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, glittao@gmail.com, jserv@ccns.ncku.edu.tw,
 chuang@cs.nycu.edu.tw, cfmc.cs13@nycu.edu.tw, jhcheng.cs13@nycu.edu.tw,
 c.yuanhaur@wustl.edu, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250826062315.644520-1-visitorckw@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250826062315.644520-1-visitorckw@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 88EBC180006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: f459c8kb6t9jbdyk7e3idzwrhnokus57
X-HE-Tag: 1756289543-408711
X-HE-Meta: U2FsdGVkX18sz/PPqEInUvWbBYNsMGXNq8wZNc852zk34pyQKUU3uQCgbFMboQzoDEs07b4VKC/ZmUALepsZgRX4qDwF50Cy+M8jD4xRHeZ+CKLhnACgS8I8IZ0QJF6s2uIoZuO5IT8Or5rG6azcZJJssVIYx4PXDBlgzNB420VPi8mVN0tsIlkxYHyz/3UMYP1ExqITnAS8/n/XCkY6WFU890oRL4eqbx/TV/mItQJB+XGAZKUOQ10TqnFcvkcr367mt1dsOs6TV9UFvzPr2biP1OpF0xGjhJvMWLVkKh1ODiZt/fZ/lpujyEeb6tu06H0aihOo8cHVewMLauXXzlQDXkq00fL3ZwE3G6jtMLnmheeTzzfe1PF+bnqkoQPVDoEDbBF0hxtNWRmVvn+kg8TSsiQACWPmV4/lsSPmC3t3W+dbZMo3E1VNAGumllwToRrrIcb9yAlXaSDPsbdYQiQqcLzBXiB3H9RFWyFtQnPvW9cfnd5gQ//Zmow7X6V99mO6s4qFM6qrMh11I+aOjIpqtyCOfmQ2NJyDGuf8K75UN6YXgeTfAECuGyKvMFedpEfY9xvbgD23B6cFbIvBo+o85FXMIzp/TVONYT1lGR6ha9JvdSG3BE6dglJY4AnkQgn30kdjr6fuaukjazhdg8Vv2bjsWGk3x7AQGGfp5bDZc56W4+3JIQ4cnea4xhSobMMD3a2NSYWN71qpgSOrNWPSJB04eXoQKINxShQJroVnnvss+yDigHcmLaNfMZNWBpU4nuaSoyRq1uJoC4q0BAuNv0WcCZTzr7OUXjWSdN8F3LWZos/2PtlAS0s0K0nyCaM/OuI+5BXmd5yuS7m1vNH1yWWMhxAfPf4zVLkvFg3RbpYPIu9BOyFZaQJjE2h75vrLmvAQNnp0K99ayzG3BFKaysTIUEf/v3zRWXfsBgYsWqLncEsXIidYLdxDKlpFIOX8fFSobtbTt06laMJ
 vV9iXaab
 yXVVpyjs1WNQLxh1HGkUebhKtEqHFyR9yAVBqYc1/HCVtor9PsFrS8aXj05ukQr4RdoZY9ngGnq4x4uJNHpoI8l9n1HUQl2J48ug8kvXA9MJzRKvpDOen70MD0UguuET2iXj8Gbqyozwxui2SZVo/et6thUWyPk0ZoPKqVU1YREQBQATn5IOJA+A+4LxWq7HrkOSw68ucg46oWQZZsno5keFadxsmfkAhmBP6xiDDgL/ouCwhvyc/ecKtvb4e9lNsazZXMt9vy4HWCugdhIB/0pKc+o3ShQ8s86w4d0gyHk+GeTbG22FPd9E4C7dt44vczGv8bPNZDq1CIS515UeNzT3uIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/25 08:23, Kuan-Wei Chiu wrote:
> Fix the comparison function used for sorting stack trace locations in
> the slub debugfs interface. The original implementation violated the
> antisymmetry property required by sort(), which could lead to
> unreliable ordering of the output. The patches correct the comparison
> function to return 0 when counts are equal and replace the unnecessary
> use of sort_r() with the simpler sort().
> ---
> Changes in v2:
> * Use cmp_int().
> * Drop Cc stable. 
> 
> v1: https://lore.kernel.org/lkml/20250825013419.240278-1-visitorckw@gmail.com/
> 
> Kuan-Wei Chiu (2):
>   mm/slub: Fix cmp_loc_by_count() to return 0 when counts are equal
>   mm/slub: Replace sort_r() with sort() for debugfs stack trace sorting

Applied to slab/for-next, thanks!

>  mm/slub.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 


