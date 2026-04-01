Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B127BD2ED0A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29BB26B0092; Wed,  1 Apr 2026 10:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C756B0093; Wed,  1 Apr 2026 10:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162806B0095; Wed,  1 Apr 2026 10:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F41BC6B0092
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:11:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B65008C77D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:11:02 +0000 (UTC)
X-FDA: 84610173564.25.F14045F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5D376C0008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:11:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oVoPW61S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qXl+1naZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oVoPW61S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qXl+1naZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775052660; a=rsa-sha256;
	cv=none;
	b=HOlCD26/eWgUMpJQOh8p3HxvCD92ZPYl88QIcr5qeNiPdNLHRn7irY9ylCdLkphHfhxu71
	Rrpz91hZP6yFJaZUfqpMpMjx0mxWZB/XonSdx0WpHcqakXWE9ozbTNPUsy9A9jvNv5SKIG
	21/UZz/zdA2ORXhT3EJRWG9oBAYBtcY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oVoPW61S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qXl+1naZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oVoPW61S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qXl+1naZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775052660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30pO4bpNJu1HxVjo95gUkprwgr4srW/LYX9D9JXGxIE=;
	b=Jd1Lk1J5C/zogaMATSM4ifD4k0UlVccrgz5XeAR+m9mwPKYf9brCE0ANx4fxIcSPiDv5nS
	hIxr7Y5QjpNj+2rZmnsnofwASXQlAQk/3hXgplfArRnTPFNcH3K6z6CFM1v7T/MmGoZQ2n
	rfP+XoNJ8NKUwJWveo3QzRa0kWXm7ss=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B62FE4D6A9;
	Wed,  1 Apr 2026 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775052658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=30pO4bpNJu1HxVjo95gUkprwgr4srW/LYX9D9JXGxIE=;
	b=oVoPW61SUVmNaFbVQCszOlRAlEBOLszdOeQt/uQ9xRSOmjeFmbMPkBYnCf26aPTlw0Gp0S
	44bRLrEyQDz75gQlBAgm5gYwH+mIk6Rroow2IMboB84sUeOITn93iCB4BvHNMmZDevjUa2
	waE9XQDHtR46Gne/TkdNihZU1FnTCsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775052658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=30pO4bpNJu1HxVjo95gUkprwgr4srW/LYX9D9JXGxIE=;
	b=qXl+1naZg3MhHsdnsl2ghio570of56ScPNuw0xER5/lZMm8sU2/l1big6ke1PnG0hGOBex
	FCPZlW3P3cAYF1Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775052658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=30pO4bpNJu1HxVjo95gUkprwgr4srW/LYX9D9JXGxIE=;
	b=oVoPW61SUVmNaFbVQCszOlRAlEBOLszdOeQt/uQ9xRSOmjeFmbMPkBYnCf26aPTlw0Gp0S
	44bRLrEyQDz75gQlBAgm5gYwH+mIk6Rroow2IMboB84sUeOITn93iCB4BvHNMmZDevjUa2
	waE9XQDHtR46Gne/TkdNihZU1FnTCsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775052658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=30pO4bpNJu1HxVjo95gUkprwgr4srW/LYX9D9JXGxIE=;
	b=qXl+1naZg3MhHsdnsl2ghio570of56ScPNuw0xER5/lZMm8sU2/l1big6ke1PnG0hGOBex
	FCPZlW3P3cAYF1Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E33F64A0B0;
	Wed,  1 Apr 2026 14:10:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /IgtNHEnzWk5cgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 01 Apr 2026 14:10:57 +0000
Date: Wed, 1 Apr 2026 15:10:55 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Luke Yang <luyang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Nico Pache <npache@redhat.com>
Subject: Re: [PATCH v2 0/2] mm/mprotect: micro-optimization work
Message-ID: <vss5mbyhbf756jieb227fh6yu6vvvsggagll3ru4cmlhbbwo25@xv54cwfx7klf>
References: <20260324154342.156640-1-pfalcato@suse.de>
 <CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com>
X-Rspamd-Queue-Id: 5D376C0008
X-Stat-Signature: 38apwpi7ja6iapq9mc1puho6scwjhfi8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775052660-246136
X-HE-Meta: U2FsdGVkX1/ELEj0KqIG6WYHo1sJipKU/ARA1K7cvB2kIQcrThnpS6+APykCIJ2wZ54bJM9uAFAliJ5wIb5wNV3ztx6//mCguf3eI64OlFVEOyXKkZo1S7shiTOh53sZpIIi3OQHyP8pP9igDVF8rXJDd7yOAajKoIML4HDDPxsiHkAU2BjEE5aMowm51h7RCzgyivZlPgZf2voJAvX8jinqeA6/mDlZl2Ik3znWiyY6S6E4DcHomAaCDJBmcPoSAPdVhm6wXgQbiHKxuVJwOabhucCznuoydGsFDSjW4XdcnBkzlr9u9Xp9rp67GjEzeRh7wZ69mkn89OsSNxn508moIioNA5rHxu3HJnQ+bAgKEzlgL+kjGpja2tnrU5hG5M/E/H5R8Wnmc7bV96yO3ydoo4RbfWsyYEC6elFbJTSZOIQ8l0Kej0LrK02d7feotkaNTyrqE85roahNCIkgx974e0MHSdytZT86e9BN4er7jyLdJLE1ruKjm55a6kwoD2vHyX1C+8lr+XNj5jjXKrggyK8ZMbxo207PC7puLxoA7g7OqXYli2LPYIg/tz1/9ndwc3yRxWcMfqUtCzGbvkM7Q6onKn5AJSYrXr1Afo2ZOkdoGyvKpD+YECnbpCVJi5zrCaWZ9TipdyfzbXvbXljKbyMyI818vt6psXSjkdhhYPJ+vVuuhdeaRJC9AcHNwsHiBgdD01+CQbBVboLZlLpg2tpYh0mJkX0MuqzlvTUCucq2NLFyDQ8Sp03mHLemL2pz4rbOWtMrQnFP420o2g5LmXHDb39OVkzfzdu/x7ik7gGKGpSLPJWu0ZpOZNTMBQZnrq7LZuSF5dJ/+dKixRYfI+vYSG9EKYh1M0AJN45/2O/dOiltZa+a2S9QgSDY+uLzY6wXKLIKbiYKL3wNw2ef3WUQF8CXKoX3V+6PlWNFEnEA9b8k98JzGecx75UsnjEsPX8dsrxMntsIxQd
 yJE663g3
 OaUGsMpK1tnEO2jOiSntWOHNsf2pUUaK4GHNAkOd3o+Z0G7PnlxsXX4w1LVdfphlTyLuXCj9cI9DADTuqLwR7GiO+uxW8yEFSJjZfiffh3Ecgr3D3Iz9+ZfEDz0ifd3QRCXT6onNQUFa4CL93QM2LDD5UyTxbvlJ/+l6mj1X9eHZuaa2KmFQ173R23IAE91E4WMDFQzhxBYOdGMwLaWTqULA1hhf+YzdVwCWCTFwQyaDkD6yMKPX5QPM1uxUAimRF3eGs5mM4zbVrDmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 03:55:51PM -0400, Luke Yang wrote:
> Hi Pedro,
> 
> Thanks for working on this. I just wanted to share that we've created a
> test kernel with your patches and tested on the following CPUs:
> 
> --- aarch64 ---
> Ampere Altra
> Ampere Altra Max
> 
> --- x86_64 ---
> AMD EPYC 7713
> AMD EPYC 7351
> AMD EPYC 7542
> AMD EPYC 7573X
> AMD EPYC 7702
> AMD EPYC 9754
> Intel Xeon Gold 6126
> Into Xeon Gold 6330
> Intel Xeon Gold 6530
> Intel Xeon Platinum 8351N
> Intel Core i7-6820HQ
> 
> --- ppc64le ---
> IBM Power 10
> 
> On average, we see improvements ranging from a minimum of 5% to a
> maximum of 55%, with most improvements showing around a 25% speed up in
> the libmicro/mprot_tw4m micro benchmark.

Nice! Thanks for the tests. I'm wondering, what CPU saw 5% and what CPU
saw 55%? Or was it just inter-run variance?
 
-- 
Pedro

