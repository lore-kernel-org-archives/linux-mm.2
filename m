Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5979DCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 18:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA309801BA; Thu, 30 Oct 2025 14:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A6D8E0153; Thu, 30 Oct 2025 14:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9077801BA; Thu, 30 Oct 2025 14:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98FC48E0153
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:21:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41EE1140226
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:21:10 +0000 (UTC)
X-FDA: 84055597500.12.848D65B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id CAC37120004
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:21:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="j/xDpomi";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BgUnj8Qj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cCgp4+xR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Y02q4QQG;
	spf=pass (imf29.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761848468; a=rsa-sha256;
	cv=none;
	b=nrORkyBGBRqQjfjAXYWSoKtkZ7Sl1EXdD/c+X6+kb3e8gF81rm/TfN3NfLmzDsvb4znU0+
	5GYzF0QrT/iU2mq87U+q21CNf5YzcZb+ks8TSNKY/0jQ1eDkZvvs0w4HQjy1J31t18aCLi
	AS1Yssnn3gAlONRn/RBxPySv6SbvVvQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="j/xDpomi";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BgUnj8Qj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cCgp4+xR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Y02q4QQG;
	spf=pass (imf29.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761848468;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35Rgq9aWXXCYtegCi5Nd8FkRSQcbW288tXIHMGLSzos=;
	b=0U9X4j8xi4KHW0USxXdnF/A7wzXM3CigC9177WpX+h4DLRl1O84sP91neYskRMCFup18Y4
	rjEAas7SbMqLrjaGH1tTP0nBQX2yYCIVvG+SOH8viCgVH4OauIikh9Q71auIZjriegBRYK
	5cAmXYxb/8SZOb4hIwE64IgfSVVhEkU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0559D3377A;
	Thu, 30 Oct 2025 18:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761848466;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=35Rgq9aWXXCYtegCi5Nd8FkRSQcbW288tXIHMGLSzos=;
	b=j/xDpomipRi27Xvy5GBORux7vuiP/KIQypNiMxJ8XY5CAbXUZwuZU26mxFjInTO+/6/9Az
	yp4Zk/5YrAK9vfNS0FBWYcF1k/XIUs+WnhQtbidqXPDPPSHgwIfBn/uKBM9DiMXh76p25L
	QfOM3INTM8rTbEHkNjI+ohNh/JXVzxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761848466;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=35Rgq9aWXXCYtegCi5Nd8FkRSQcbW288tXIHMGLSzos=;
	b=BgUnj8Qjc9JEkRhbNm9umHTuI9hdu2AQHZAeqr0cUg5Ti1fHlpDUPAO2VvjgWm+mkJeEB7
	bh0sjWg6UEJwvqCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761848465;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=35Rgq9aWXXCYtegCi5Nd8FkRSQcbW288tXIHMGLSzos=;
	b=cCgp4+xRw5fM4joQmxNWc82CsEDmpI8WHpVjHkG7LIHe5MO5lOaHu6CJRJPph59idlGVSo
	1GEifCUC/UXW3iHjs+dN0oy9hpXC3sev/rDh51NDLoFJZ4y22TYsuPgNZzxHlmVyOE3yMt
	eR70wdyU9CS8HtyYY/REg7rgXoaEcgo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761848465;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=35Rgq9aWXXCYtegCi5Nd8FkRSQcbW288tXIHMGLSzos=;
	b=Y02q4QQGUEocIdhPkNnWmwYmiyhHHVVYkXfo4ejKJow+PUEPO/8nr0WoTihHxbaNeNEJOT
	4BEYFr6dQxGabwAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D15001396A;
	Thu, 30 Oct 2025 18:21:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id njTnMpCsA2lrBgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 30 Oct 2025 18:21:04 +0000
Date: Thu, 30 Oct 2025 19:21:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org, v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 05/10] btrfs: push struct writeback_control into
 start_delalloc_inodes
Message-ID: <20251030182103.GC13846@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20251024080431.324236-1-hch@lst.de>
 <20251024080431.324236-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024080431.324236-6-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: mzsu61co68ynk8xjhh6uuehk8tqu6jig
X-Rspamd-Queue-Id: CAC37120004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761848467-487896
X-HE-Meta: U2FsdGVkX1+fNYsySt+Gos0ueJrkj9iu0+mMM7Zil3BTo71W9VbpK/gFRRJKxNxFMy+7cTPCnFvjeUh48EnQOHK1avoOzU4uD0NF551eS/KyZPlYm08tPKDNjg7QbkO/VHm9DYT2MxsYtAe1izOY0P7fe53gZr3M+6RulX5Ksr/q5MSHbf62e2HBIVVDENIgLUePCTrOgvS1Nm5FtdEVReLtVT+tpLYWt6NidEfj/FqYuu63hLnzR5vr8qXw++JWtoPG01XTQQ9B8/MXoWinvgSsAXOoBJ2xsKjkUcZ0iok/g1b/nxMG59hZf6eMLFAcQuJ757mOhHRZSl7Q+2ESrlCUlzj5wNjT2cvJWg7bgKAYP9xGhpg22quq26K23HicN27w2fMdHCeOKZ/WL2QsE6/gELKJJ9Uk6vmihgLgWjWiwBf27Jq2tytWPs8LdMclvqmWM7i9Xaae4XQHfjzZM74nT4IcxodLqYk4zJ2hyoaIhiIffweW04jD9bkoV60LkeZvRE2gYK4apyHVhnTFFMbsGTcst1Yw3Ok7VDk2YGutwjGBqiz6NrzVN6nMoRyljG/s/8raX/bCs9mFns3jTF1SRwYwZF4CG60nARlbOHOOCgaFvXVJUW8QRLPXl2n7s9veKgoiWYkdmoNE0I1Hs8wO0aHzENENN3widk0ragMqDVOJi4LtyShz3kvRr6EBuPpTbJPBnW0zLi78SuQsQs0ILDD2nUPYwHTXX11Xxj46ZR9ttJMyXdLsSeED6EIgLSq+4ZFNmB0km/r2xIFT5m0TRoa3yGqtdSThWRoWbI2N7lM4t8OavkUO/meG8wUji04gpBVcK72DfCEFYsqooilk2qzlCuFEwFXX/qJVnjKfXOxOOcWHh8saaiH6CvF7oC8AfGeAYnN8D640iblQIjewPKsqbD50uuvwHt+SamG11jQJOl7qFxQnM6Eyrg2LVXQBRHg/mt6wJx2JQi1
 AMsPZzSP
 YKwqnKZaN28WSpsl6Xihj5zFMGOTLjFtoD6wcBjerCzRUgCZgDAgBblk3ax8DakdtFHpvnkVkEhIuA6yFk7C9I5KrQ5FoOYK49WQMayNJjHA5KAh9nXCyhWHS5cNeuNsThIk7uN+fUt35xzAbuAuAkxAnACFZh3cup5wtEf4H98RtN92STAXhfhqGgB2lsIH3PJlBlODARj/gE8n5wcJ8efV23wV5WzeEx8080o/4d/pHKQf+N1ViWIv4Zb1QSu1fYGjNbwU4yXxHK149PapOh4fEl1JnWzWTQDYBe1QDEdotxkF/6jFQDqUXtGmBIZ5IvB5EyXEgaN947XGpR2oiqN8VP34axQ0EdELOGYpvtXaYCPh7SRnYpaiBZAeRd1abFrTs6+z2+UXe5Yao4XUGjPoN2stntUMR683X2KuWzH8g+f0ciiLxRV6+iJFzJKm4N0Xs1bbJoA9u/Qns3mCCmBybstFjrT0Q8YQRl3Moxeq1Y65cw4NIVJ+eEdnldVLILYJdh4Yte7dQJ/lJ0TSYZ1LmL9DM7YojY6hR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:04:16AM +0200, Christoph Hellwig wrote:
> In preparation for changing the filemap_fdatawrite_wbc API to not expose
> the writeback_control to the callers, push the wbc declaration next to
> the filemap_fdatawrite_wbc call and just pass the nr_to_write value to
> start_delalloc_inodes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Acked-by: David Sterba <dsterba@suse.com>

