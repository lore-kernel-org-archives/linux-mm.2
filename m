Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F8E8C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963796B0088; Thu, 24 Sep 2026 08:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914396B008C; Thu, 24 Sep 2026 08:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829C36B0092; Thu, 24 Sep 2026 08:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 649936B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:06:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7986C032A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:06:50 +0000 (UTC)
X-FDA: 85248529380.01.E3FCEB8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id B259A8000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:06:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790251609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CkGwrkFEvRrMEHd5zIx4l3BR6iYKh3HYjBWb9FWkrBQ=;
	b=oxIaIplzbpZxuDZUDSVugzGZe8FVGKMu3TC3a7ZILR7NTfEGuGnk0jo7z02IC8DizCWp9N
	oSFwFEiI6nErKIupCtSvJZ4AxMBqInffRtph59s1gXOeM2ToSr+ULpB6xHpasqHTu6zX+h
	TzsxLDrtFiIM4PJA0tUx7WrGbYPKUXE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790251609;
	b=RevmopFNNJb/IBunz0+4FxqWGjyzd2x1ZG0ZQQ3Wd4C+OMX8dMPWSzifdd45o1Vjsfh/rM
	n3/fTA3qmPiaVZlGfwwspyG5Wt+A2jOhv+aLwk/vPbd7XPMSw4ZcDDJ0V3X7qPyTSaEr5/
	EmZdD6rP7xoDQzfXiysts+i0VIizKP4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7855821E38;
	Thu, 24 Sep 2026 12:06:47 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4CBB913354;
	Thu, 24 Sep 2026 12:06:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id unHNDFcStWo5TwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 12:06:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D698EA132E; Thu, 24 Sep 2026 14:06:46 +0200 (CEST)
Date: Thu, 24 Sep 2026 14:06:46 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, 
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v8 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <qjaulcom6f6ggwq5aktkq2glrdzfhdc27utpg36moywpijmbgc@pz3chxpmz6t3>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
 <20260922125015.3435215-2-sunjunchao@bytedance.com>
 <sb2ptqety3wgay5egv4otva2s7hdvztifhsealwqpdnw5nyprc@ceu2bsedj4wy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sb2ptqety3wgay5egv4otva2s7hdvztifhsealwqpdnw5nyprc@ceu2bsedj4wy>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: nz6gkzugap885frtca5ywbranconktrn
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B259A8000B
X-HE-Tag: 1790251608-118292
X-HE-Meta: U2FsdGVkX1/TR3UcHRL16iFhSMnSINCBQmzkbqiDQhDROoJYh5aDvQ+yXfGd0Bgy1R5q0JibGa5FL3AV7YicIKFawndliNjTO4KhmS5An9EBU3EEuXM0GdvVAjDycGg0pRkdDhaZcFfDEywp0Wn3KSvqXCSKyjRDqtHTwIBD1dcOwcnX5RWVF/ZUhqGrSpVkdkJ+NCR37ch/eQ8HBzj+AVb+19HDZBQHrBlICXPqKw29JolK1cQh3D9dKzgunpGPQz1x7q9Y3oLTe2uEa18oWVqAhAmggscY4+uYZd1NbDOxD23eTuN4aN/1xPLMINKESo2/SX98Ng0NLkCkKBLBySIQB2j1a+ISNCZ416sIinuChrV3hiI8iUrmrK/Spez4jRnjh4cMushsp/lZyOp5NXH7tiLq5QjOscacNTH9kNA2miICETcHfb/fYCecg8EGMcO/h5GyxponLo8L7A1luJa76v3jlZ3vyECzUoZvfhav0nnaGfHwDXeFxSjhkw/r3hgBCX63lNEy54d5PoVNs9GVdhfAe3iwVXmVC7JMi5Gn0u9xS8DeO1XdGf/+1W90LdsLr85Uf+Ce+g0A+gZenpxMBY9dTi4424EPSpSTg5eIpI8S3J+XcNmlniM/KNG+B6W/yx3Xq/x9t9lTfFvW7BWrd78vXmfvlX+jiPjoEgdS5LW813JFbjJj9TSnzskzi9SHZoxtI7ntz0xGZpBpHO7uT7DWs7WGmi28lSDJBhdchg6H3c6Z4EERUlbhCE50vLIHzwP2mXTo08tL7XcY4jP1WnkvZw436LTiD0XBkTRONduv6dA9oQ66Ts9nhiitZN6daMrKoWc3zjIb1iENSSYMDayADIuz7m1SNduUsBZYr2ADhvUtynDzUXgt1Vm0Zqcr5xM+s0ZF4B/rjY/4lz/9H/dxLV6j/nvzGFvfaT1ozBdDK/ux8hYJMhO6cOFaW/+w9JWTdp8jQG1cAQr
 +wFY6XSl
 aaKmV0/q5yJsEr0X106n1yetX4SCygXdFsPuH7Ov1WJgCswpTIgqKRXnG8AmZkpNsFCGTpcBY18HNESzqcUVS2a3IIxV9DhhcQKGiJ217hzE4K+fbhs+1I7vTfgmJ3se+q7MTgFUxWiKAfhRWyLLlgehqRYexqSivrWKTFPlBi6kZ7wCDxv5vrktM1+5/fzXgLdmXaqtRB3crLqDFUh8KkbcZCaqZp1YhOSkcpSkX6ZCt+qKqakQTjvBHkHKfta8ebkFc3l8+hXB6US34Hmft6NKMgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 24-09-26 12:57:46, Jan Kara wrote:
> On Tue 22-09-26 20:50:13, Julian Sun wrote:
> > Add bdev_flush_by_dev() to submit page-cache writeback for a device
> > identified by dev_t without requiring callers to hold a persistent
> > device reference.
> > 
> > A subsequent patch will use this helper to flush foreign bdev mappings.
> > 
> > Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> 
> Looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

After some though I think it would be better to use

	write_inode_now(BD_INODE(bdev), 0);

in bdev_flush_by_dev().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

