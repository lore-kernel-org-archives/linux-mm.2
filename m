Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 154FECCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 08:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F888E006B; Thu,  9 Oct 2025 04:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577648E0002; Thu,  9 Oct 2025 04:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48D068E006B; Thu,  9 Oct 2025 04:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37D988E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:07:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 063071374A7
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:07:51 +0000 (UTC)
X-FDA: 83977847142.26.F2D2F98
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id D682714000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:07:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="lT3BcE/3";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uhJSxLdk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="lT3BcE/3";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uhJSxLdk;
	spf=pass (imf23.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759997269; a=rsa-sha256;
	cv=none;
	b=XGM5jPHPviRs2OtS5ypXHAURnrZe74jPSfG/KtA05XLyMPKsMzFpgyn95gMI6bjeiryLCZ
	7EdC4PBzVYhu0qQVWdOMATFRZbKgTXnb9YiI2FVb9gQM6pXJKxAQqtJwF5Y60zwIMiAH+J
	nIzeXCsnSTGi4gQlibU39tNmN35oTVI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="lT3BcE/3";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uhJSxLdk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="lT3BcE/3";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uhJSxLdk;
	spf=pass (imf23.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759997269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=840BVvk4h/vQ3iIDPplNBop5pm8dJACDtuDls2QAuzo=;
	b=AYss010jdVYHX/0UyGBB7WLAf09SAngoMVuCuea6Bm+RRcVfdKonPF8QqK+CtZDb9IjEle
	U2Y/fEUySPGsSw8+1gz+qkt3mDsCqAsEnyBief7nT1GHSdCbLeqbZGaiirclZDYKXJGJWo
	lmNIKra1rv5Jc646+kWjN7cByAAHcq0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 59C20224C6;
	Thu,  9 Oct 2025 08:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759997267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=840BVvk4h/vQ3iIDPplNBop5pm8dJACDtuDls2QAuzo=;
	b=lT3BcE/3xLnQc9f2v2Q3k1PaokeHfbIitmRaSGJFjpMBc+Gi3AhKPqgCIh+KbCM/k5CDgD
	0g+hXMyScNWMF5W2sKtxiI++tsS+wb4Bmj9LPmoBF4ZsGG9RWUZimUEuo1zkK8iJm1rRbU
	Vtvs2hNofBorIJpm1pODkmLFify2KVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759997267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=840BVvk4h/vQ3iIDPplNBop5pm8dJACDtuDls2QAuzo=;
	b=uhJSxLdkywP8EgjhSzopzlfXz6YCM8o/5fj57d7Jj60gAoL5kZVIg22rAKAZkeP+Vu2mxV
	Xubi1K3Ydm1QnmAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759997267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=840BVvk4h/vQ3iIDPplNBop5pm8dJACDtuDls2QAuzo=;
	b=lT3BcE/3xLnQc9f2v2Q3k1PaokeHfbIitmRaSGJFjpMBc+Gi3AhKPqgCIh+KbCM/k5CDgD
	0g+hXMyScNWMF5W2sKtxiI++tsS+wb4Bmj9LPmoBF4ZsGG9RWUZimUEuo1zkK8iJm1rRbU
	Vtvs2hNofBorIJpm1pODkmLFify2KVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759997267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=840BVvk4h/vQ3iIDPplNBop5pm8dJACDtuDls2QAuzo=;
	b=uhJSxLdkywP8EgjhSzopzlfXz6YCM8o/5fj57d7Jj60gAoL5kZVIg22rAKAZkeP+Vu2mxV
	Xubi1K3Ydm1QnmAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B723013AAC;
	Thu,  9 Oct 2025 08:07:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AavsKVJt52gYEAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 09 Oct 2025 08:07:46 +0000
Date: Thu, 9 Oct 2025 10:07:45 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH v2 2/5] mm/page_owner: add struct stack_print_ctx.flags
Message-ID: <aOdtUZbMhV77q3Hk@localhost.localdomain>
References: <20251001175611.575861-1-mfo@igalia.com>
 <20251001175611.575861-3-mfo@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001175611.575861-3-mfo@igalia.com>
X-Rspam-User: 
X-Stat-Signature: f17if4x6xsqregg9ornd61d9bprj1fab
X-Rspamd-Queue-Id: D682714000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1759997268-275762
X-HE-Meta: U2FsdGVkX19Ju/2u9rbuDYkqjzAGcNG5RWKdOnNFBMyPFh9xFGQARKcoP6c+4bKN27T1bn4+ofCESambImQbv7EYJWIWeA0v4IRH1fweFI9mIXjfk4vda2dcjPFWARZaRiUWVHv8Lr1zidqftjFI5PAeVwmotqzd/8TVxPDc1LIQux3DDK6PHFv/SObwc7W70NfnXc4LWFK63Rjrn9pX1+FVTweGStIk57sppcwaxvhUxaKVdEYB+6xqgaZELiqGp7zAqOuvhQBSblihT9tDy9zF4sPzpJRfWskL49gvVGeaVAZg+Bnt20/d86Y8YHNhlBT9wSyAVyGpqZ596w4sdvP8xAhh9nRK3fi+QJIwABtnBTvzlSeF63R5yN2jY5MFhyb9oI7AxOPkw3u+IzcJThlFaLk38Gl7fuqjw4l8U6QETq4x2/qQCIHNJRq2AAV+WWDFX9IEUvMpjITtphktGFTpG3Y6HSPNYryXveGFDbFoL2j6FYp74iT0c5ZV3ih02zkISd6CF+MV+4xAZA2dzTmY9/UxWlLEowytMYDrXI9hd3UlTROsuyNSx/MJagGf3uumMDvYSo2QTrm4hg5aDE7iMSNBnxc0p/T10V9IL5heKZaLy0BzGwM8wxU+V4oadsKQVCr/oPiDAVQHkvl3R37MbzkoW5Do+EOLTX3rQEXYUy/IWg6sRcR0TrZJrzlf92CyAA5h3HJFZboWGb8G6FcB2xQMdJkYvH3o0ncUeAUMNSGDQvnBup4sosPisSM7PeR/qoC7gKijm5wRYY6O2vG7dWYNEf9MmfutaSWMBAY1PBxSUNTT1i4EOtY/H3IXJrDMs9k7aP3RsqeIVYDvjUqglod4og2PhXnNq+4On3wVoCfILSHWJmtJqQfZfbdZF0+b5DaMaNj6wO2nV039MHGtVGM2tdYwDf8r2IlaDao7sM5hga19PwM4to1Q3X05jHPQzAfFsXiUqYE39Bt
 BMMNgGvB
 DMvp2kazKuaCBIr+s5Vrr2UCcjdtQ0+0ZHamrJv6QgfVSbnTJf2WX0QrBdKJycV+kpzjZVq7OcQUYBZqFIWbT5NEA1Mh6nkUoy53Ew4fVGKjqMUGTAozRERpEJwhWkZgMnoo6ZlqvuLV7RX46Mls5AvMnubqHgOAsa3XE7oSGELkH99ovBZjGSjQ7BpOCQE2ajawSrervYOek5oBQ93JRIt0YznElpA9EKsYk3Y8ww+UdYwhNfpf2uNibG3yN1Jw4Av+2wEhrthQ9JOKQxIJXfyDm2hye8cOivkxPV0qObj84BXpF60MLJ99nRtonvsg6LkeJg5+T9LldcCQYA6Tkh4OtSOfkhHcGhIS2y5LXq4w/wD/pre334aO+5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 02:56:08PM -0300, Mauricio Faria de Oliveira wrote:
> Add the flags field to stack_print_ctx, and define two flags for current
> behavior (printing stack traces and their number of base pages).
> 
> The plumbing of flags is debugfs_create_file(data) -> inode.i_private ->
> page_owner_stack_open() -> stack_print_ctx.flags -> stack_print().
> 
> No behavior change intended.
> 
> Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

