Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7043BCA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 12:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0AB66B0424; Sat, 16 Aug 2025 08:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB306B0425; Sat, 16 Aug 2025 08:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0DB6B0426; Sat, 16 Aug 2025 08:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA556B0424
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:53:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDA261177A5
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 12:53:01 +0000 (UTC)
X-FDA: 83782610562.21.E9EA02B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id A8DA240005
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 12:52:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wEgxsI7+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3znNidQj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j38dKAE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zmcKAKAs;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755348780; a=rsa-sha256;
	cv=none;
	b=PLCdOB8vuwh7CFyOkUrKetGoc0n+NV00EcCV46EXOqJR0zYkG8u95J5N1kgi+eUgglSfbv
	R1Os6p7KMX6QYx+MeD+3HRMW8pFcS2yQb/d+KSbmFhPVYOxfSxBAqzstDsnczr9dk+QPVJ
	d1gIefeTpnSnU8wa7Ak/hdGFxO8qIx8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wEgxsI7+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3znNidQj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j38dKAE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zmcKAKAs;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755348780;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJQEqa9v8718kOSsvxcj/FxmPISevxVZ2InX3UKuGsI=;
	b=2cxGYDLPzTFebDDx5+hKJUaeOlK+9TmlqEBiyGGQLodGxIt9UluHHibW+iVPXCxV6M1hcQ
	H47XqWATBJi0QEF7lKT2ePiHF8qSQYYXkLfaLaBvDaKfAvGitSdQWfm3yOn/ffVwzsAF9r
	gRuj7+Q6bKjcFs1/iK9At/nLFAJrMwY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 72F692190C;
	Sat, 16 Aug 2025 12:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1755348777;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eJQEqa9v8718kOSsvxcj/FxmPISevxVZ2InX3UKuGsI=;
	b=wEgxsI7+X/ARM5bIZDKY41AXLZC9JwWc5lDlxau1D5ACwlczq2KZCfkHTqPsQAfy3+soda
	y6qwhi2pvb/xrZWeJFh+OIl8XustvcbaK+sKXk+S5X9paWbnu6RtzbDKr0jrcGXNvdCPXi
	9GvONnhX0FIEgYGhsYTJ3y5c01iBs7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1755348777;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eJQEqa9v8718kOSsvxcj/FxmPISevxVZ2InX3UKuGsI=;
	b=3znNidQjZuA+GPzVEcLyrZW/6CD6oD0vEoh3Ll3c0UthAkSKAVxbCA0nmdqEqojqJ50FFd
	WOJH+I5l2XB9Y2Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1755348776;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eJQEqa9v8718kOSsvxcj/FxmPISevxVZ2InX3UKuGsI=;
	b=j38dKAE8AkEE3MeRt7qE7MME8+XOp+uJATmzeyMUV0T2BhvwJLcIk1vMJvtPsRNCdNn1o2
	k/4USXIQYr98hqPRbWs3idY4Ey9/vWGUJjiQqLJgSK9UhdwOVZKu2ueIhitdzpZtCqIm9G
	VXLMksQCwfYmuN9xeorqZl3b4Am+a3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1755348776;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eJQEqa9v8718kOSsvxcj/FxmPISevxVZ2InX3UKuGsI=;
	b=zmcKAKAsyB0fV1t1GzL10RhuD+FI4cJ+jz6ge2aHrnQl7vW97jtw92de3kQDwLNd8dBqvN
	mBev4b0RbhmYfTBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AA5813432;
	Sat, 16 Aug 2025 12:52:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nDenFSh/oGiINgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 16 Aug 2025 12:52:56 +0000
Date: Sat, 16 Aug 2025 14:52:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com, wqu@suse.com, willy@infradead.org
Subject: Re: [PATCH v2 3/3] btrfs: set AS_UNCHARGED on the btree_inode
Message-ID: <20250816125251.GJ22430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1755300815.git.boris@bur.io>
 <786282400115bf7701d7f9c6b00a9549f67e29f7.1755300815.git.boris@bur.io>
 <mlfxq3ocdmnzvpykzo3zmeebdv5rpohk64aevx3fbwvmj6xitb@ebxlwsd72utx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mlfxq3ocdmnzvpykzo3zmeebdv5rpohk64aevx3fbwvmj6xitb@ebxlwsd72utx>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A8DA240005
X-Stat-Signature: aw1n6pbhhe5h39rhwhhfsazwedujtyd3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755348779-110215
X-HE-Meta: U2FsdGVkX1/NC8VCpYR41luGZbD/LN3Y3doQ1AKneX7kC2x2wbaPt4a8Q8QlHQoQawIbJ+BnWEgXzW/m2y5oWndBJzQz0GHv9lcYycBAxzzTJIX2MzvAL/vnFQu+NXCO1nwRy+lfm0L5hBpJg/Jci54s89/cpxDWp4KvfsmaCZNtWakI7Wyf+NWl4QlxO123M34Dahhf5t38dgLTseFR8OOeOF5UQOivzzX/buEF2aynLFOHu+xmqDVuF7j8POIiH8k8kA3pITbxBb9VNtsX+AGex3L6CuvNjMHNoxAF/UDomQFWXf2/oV/eDkbwaXFC3jfo8nHKlpKHg9szvQaOsC7mIboXtyFU4WbUDVKeQMBW97E3w+59Js5EEW3EFqKRPI+3HyrXcKFzUdfTPwy3mHjL+RfESuZO0PW8U9fGgT+1dfsWS7plTy0TvlyfT+ExDlXhP9f5xohvdLe2iG1gjA0AT9COFO2B1exDCc0a1lC6s8HcoSE5QaAatuoP7YcNV6VKB49ZyE0yr+ikhMm99WH4yGRlrWslH4lO457qw8bLBqkbehl5OdmGsOWE6gEkXjlmMyHhgLrrJTTHChcUnOunGSi9sP0VL4wJHp1I2cK+Fq1sPB9f3k929eJkaNDzxe4cn/y5MjLw8WEAkRoMxFnRIvnlsB/L/3m2ZOI4NUfRvXfZFOg7xKMF30rsNAXrzYYOGlteqKAA6TI9fxANGWjByrmyltxAcmvORPoYSerAp65aMqbzjMZCZn8/8UEqFT8usNvS8zRHbiH/CWJhgXRXgAI6fgR4JRjKURYYwy/rw0+SY/hRauUkWRy8MZLIronJPAq/XJ6Nh3uUE7aR6iFvCJ4TyuoXcF3wRwnv6JPdVfb5F8vwHZ8xcdU+BvIR0mIbQ8mVIGBCQko8WY1aW3givP/VuGrmQtUqa3bhFoQmTD7hbfUqc5M44/PESQs7dHMz/QOGdbdole/0EU2
 gj/XtXAh
 iQgXGuZB8+WY5C3TiXFVGjpIaANuOJwY9RO0CkC0oM5SHACVVVd8SFIjb/hU9NSjhxxoOhkW1LZNNOhUmvg2rfPt3QzNd3P8fCi6lryME8Ii7AdLH7yvNNtQYvC5n5pCbBFckjtqBrueK63TqzUkrg+P7aMxJMhAvvMEkv5LR9WyzV9MsORVtf0RM7EXN0dZG+UPdeTDuxF9ezJdol53L9k44vzgPEv3VAnenCWrzIsRCCVE6PRSZuoWyMCsyHham2shtvWea9TyMRDXD9s+fMx487Y6kkZRrb0/+W9cAZcfk+PzcK9t0wrUgMDraGi/DgsiQFhnNloNyrwRAmAfRuVh4GqA4eyRpZZF77nlmD+uVIJVpUdOEtwaoeFe1a+gEkoIIYIsDLeb7PNwj9hNW7UAGwMvUaOcH9go9Lob5PSS57/jtKMjmbB5wTd3NX9WO+abwZY9VnR+btCQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 05:50:28PM -0700, Shakeel Butt wrote:
> On Fri, Aug 15, 2025 at 04:40:33PM -0700, Boris Burkov wrote:
> > extent_buffers are global and shared so their pages should not belong to
> > any particular cgroup (currently whichever cgroups happens to allocate
> > the extent_buffer).
> > 
> > Btrfs tree operations should not arbitrarily block on cgroup reclaim or
> > have the shared extent_buffer pages on a cgroup's reclaim lists.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> I think mm-tree is better for this series.

Agreed, majority of the changes are in MM code and the btrfs side is not
something that would affect other testing.

Acked-by: David Sterba <dsterba@suse.com>

