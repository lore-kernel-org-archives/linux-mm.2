Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2B8DCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3090C8E0006; Wed, 10 Sep 2025 09:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0258E0003; Wed, 10 Sep 2025 09:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5FE8E0006; Wed, 10 Sep 2025 09:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B01F8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:08:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95D068710C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:08:13 +0000 (UTC)
X-FDA: 83873368866.06.F893B62
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 52DF74000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:08:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="RU/uBY3b";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FfUSJVXS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RH6Xz5OP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1XKXjTvv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757509691; a=rsa-sha256;
	cv=none;
	b=QXty4zFL3GKnlDKp7AzW4FgzrfncqFZI2E1fSotFphApiiNiikMlbcImWRi/cXSrQnSBG0
	0Zdfa7x0RgSSJfmQpaCd8zqgOv7cJ5cG5nNz3jDcUs1J7p3Z8y6W3AwSGyLtqowHtW+x4N
	0LrTgupB9eieCc/rNDE+4V3z7XIwsTQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="RU/uBY3b";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FfUSJVXS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RH6Xz5OP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1XKXjTvv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757509691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=relwdfeW8kjZZ1uxYeqyI8QEzX2UIZebEjkKJ/MG6xE=;
	b=7SVcJwy5whpWIoxPVy4YgH3xqSnUQtTOcptmfNrc3iCD8M3UVLTCH+sOgIFDgbve2bmr+b
	gd1TkZFsBIuEV6btDh9I1hbh2GyRaGeIBQM8zwMcxq/PZJCbe1cxIqptXxjN4zG2ZrzSPR
	RQOMmSUbKHdhO9mWvI6fTNpCXS8bKao=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8306533B96;
	Wed, 10 Sep 2025 13:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757509689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=relwdfeW8kjZZ1uxYeqyI8QEzX2UIZebEjkKJ/MG6xE=;
	b=RU/uBY3bu5qdZoymGdLMbFNaHP87hzrIm4JlKiqr+A0G42mR4xkT5hIgsbZdGwfXLjeFjG
	CAxNVMc/N5jiOc5lVxyQ8WZm14T4jmCOcTbkzTyMijboYGYPI6+VkZ31VG9zLv1kZXh//H
	CteRLaPxqZp1Novq/ouvykFIIoCsEDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757509689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=relwdfeW8kjZZ1uxYeqyI8QEzX2UIZebEjkKJ/MG6xE=;
	b=FfUSJVXSupM6eUZwikrTwms564oNH/d811+wd144+RvJ8T1R6OVGUXHyLBNGipFlRj994g
	FVOFX5iSZ+FKP0Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757509688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=relwdfeW8kjZZ1uxYeqyI8QEzX2UIZebEjkKJ/MG6xE=;
	b=RH6Xz5OPsrpHDxiYvgyJitqo4x5gbm1HaQ9VoKhsBdxR/M3VHDWYafhiogful84XwBvZ/9
	c6W/ddQcZ85/eHy6wnGWVNq/gtD89aP0ur5i3FvvfAgWD4imeoFzvYx4FCWwpRl8osMGCS
	R7/MUzqoe82UdzyWCvR7dMuqAHOz9RI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757509688;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=relwdfeW8kjZZ1uxYeqyI8QEzX2UIZebEjkKJ/MG6xE=;
	b=1XKXjTvv1yKKqXqNwnkonB7EBS2FBpX9Pt9rKzZGr7mioCktm16jXskHfTpEA5tVtlsues
	zD7RU4YmZo/PjHCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 528B613301;
	Wed, 10 Sep 2025 13:08:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /BQ0EDd4wWjGCAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 10 Sep 2025 13:08:07 +0000
Date: Wed, 10 Sep 2025 14:08:01 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 4/9] mm/memory: Add tree limit to free_pgtables()
Message-ID: <3pn4anukobmyhul2zw6cqwl4nvu47ecji4cldgsfer24p35k6s@km5dfxpzvzzf>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-5-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-5-Liam.Howlett@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 52DF74000B
X-Stat-Signature: imeeuaatpbge3ic6cfgirc7rqu4gehn4
X-Rspam-User: 
X-HE-Tag: 1757509691-195221
X-HE-Meta: U2FsdGVkX19B9X7aH/p1Nnazfw5FZ5D31zGv1kw/hXMzHAmjBkc7/R6Nx3QwtfEvzrcFgJbnpmVZ1D63GyyEfHDrrvuJo/yEK6CVy3SAWZ4TRekhaDE5LRAosbV2Wh4rzRmjDvzrlF7tWoCZcva5O7IBGO14O5MnhaYO1rsrjaAShfxkk9uKnlhJzo7iD1VsgY+tWNftbgpl3454zKNUXz0pNT07R6aM4Jw2ILJ33pppzDGse2/Okj/XUKF6fyCASm0rR9Cq8ywpy5vDG2laMGXXgrKPqNSViXsR0Co2mP6WHVs8wYdgXm+r1krAkgWAuKkLRm/JV1zOrYbPejntjL4Lu88yA0cP8qlSOktbXYHq9bdjPJMPaM72wS3TRY6yBvc//xV1hqw9pqK/WK6sfLbr3Z+1g0zUcvAwfOK7xXvCVRO0wvw3nSGB6pz13X3XLVnifhtk5XcRbO2qI+wKqOfB/0nxT8hZtwvSDGMrTuVgF93ZQxAQHK1xXmS+d+rPFHNEEBiCbYbD7NFLiPGb4alzC9UtJFAQWncgSI0qsoxKlqx6WQbpBlPPq2lI4sAiFR/kPn7xle9sAxiTHdsxKk5EUjEkukx/4M5z+A/sJcj8yiSwdG9VS64Bc+0ennnxFvZlaFWl3dwTPetpX0u9GwizOM45m5p9fCumJFY+VSqKZu3PSnG8TzsN3VX4Qr49KeHQNmfap5/qThiwJ9Qoidyt/G+q4rJkZZCY2X/AKDlGGXkZL4UZ2Z2YvfJXEIAp7L+Vs1PvlfQRjVRCxTjocglGN6/SoRRKlp9urH7zZkk+DIRD/MErwweDvK+Fr2v+qOqm7V7neqC9A9S9AsPkN0H4vU8gDobAbGw6gjWrkl0c9cIyoE577m7GymkniVHaj0mPl13psjI5BMqADhfzdoGvKfPDOY+XdbrvTnkweQ70Cd7L65JglZw5v21Oer0HlgYI3PDQcv+QlvQ9u12
 Pyt6e989
 jdRC4/mt+Un/5QpRsMZSn9KlyQJ4Ov7FWHYIAHNlqaZhsaLqkeDpzVtWQpPec9naTUYjlt50Nk7IzNSdObowYz9QfwyHh8kgZhTqPyln/pWhJTp2SPdOeWhteEkrjBjN28HKiHaiaLQPeiWFvloMbhFhmSWf7zGbTuQ9mJlXMAICk50xyghpoOK6ndjPgJnDZfRLCHABDQzYA+DPUIyYvr+lbICpZjeqjhIfpFFgdnmitOOXctr8VG4uvT9Yl4Bg+UEb7CMpYpXwVhxLd383pEiJbzRtaJ/NrjOpXIsQ/HVR5ttxMM3FpaPsIu+35FTwVycRNeQ/VM3z4m25EDpzJmhG/ujEsn+D5sMgJkJjNsFc5njGbnft2/UmKAGHIVJ+LSr2WzIwDMWhKM3G1buLZF5e1nEW6NzLZvLDx00qZxcwu7zI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:40PM -0400, Liam R. Howlett wrote:
> The ceiling and tree search limit need to be different arguments for the
> future change in the failed fork attempt.
> 
> Add some documentation around free_pgtables() and the limits in an
> attempt to clarify the floor and ceiling use as well as the new
> tree_max.
> 
> Test code also updated.
> 
> No functional changes intended.
> 
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

