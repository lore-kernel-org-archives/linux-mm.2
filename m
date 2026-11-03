Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F9F606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=nFNAv8Zi;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GVfNg+91;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=nFNAv8Zi;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GVfNg+91
Received: by kanga.kvack.org (Postfix)
	id 658DF6B00EF; Tue,  3 Nov 2026 07:13:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601A76B05B1; Tue,  3 Nov 2026 07:13:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517E16B05B2; Tue,  3 Nov 2026 07:13:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36C5B6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:13:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C94881603DD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:13:04 +0000 (UTC)
X-FDA: 85393697088.11.C00A0A6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id A3F53A0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:13:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nFNAv8Zi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GVfNg+91;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nFNAv8Zi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GVfNg+91;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793707982;
	b=RgGvvQd7R0ks3QewiMhtzeVJCcWuMCmFrKmICiO4Gd4cgcz/T72Mx9j+LAPZ3kHgTL2OkC
	3dS8W40ER0jOSHuffwtZFXBhGNl39YFs2vZipAVXGvFVg1cj8mkELJaWdmAM94PYnquq8s
	OeNaRPtZMJPu/G8zkzBIuY1yT7BlF74=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nFNAv8Zi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GVfNg+91;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nFNAv8Zi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GVfNg+91;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793707982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kwRa3DN63egfTMxuFyQnVb8zSbbi4+PrcwPMbluoIU=;
	b=WOBjJ28ebjnXJ2ggTmtDu46zXQ/RcZwy146UYQDYu4DA4KxpwWLjDiUAUk3ovacf5AT0rV
	rihdLXCDTK8Xg+Ag5nbXGY9ux7xlAAUD1UVebC9ZQVOmxAKf1i7trI3iMAaX1EJ9S5Z7F+
	8K4VRvyfsW6XUoJssirKam/ZmC6BsmM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 078272203B;
	Tue,  3 Nov 2026 12:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793707981; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9kwRa3DN63egfTMxuFyQnVb8zSbbi4+PrcwPMbluoIU=;
	b=nFNAv8Zioud6qE1gAeujq9KkGc4xucpVaRDNIUIWWX9XTwq8jLzW6ZtKxLoWAcp9/FD3bl
	J8VeCiESZ1e1RlHdtITllfC+OqVoS+QeKj6qeGiWHSmy/lNc2HC7rBa8xG7cNF/x5ZPvrY
	d8pEs39zG8EesiVqirGy/RgZxYQUmPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793707981;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9kwRa3DN63egfTMxuFyQnVb8zSbbi4+PrcwPMbluoIU=;
	b=GVfNg+91FeXcI/1vlZg/XLq3Gf+f6kKU3xQjda4/0h70fEplH6m/p0hhHVo865U5PYlwG2
	phUnBMfzkA1vaIDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793707981; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9kwRa3DN63egfTMxuFyQnVb8zSbbi4+PrcwPMbluoIU=;
	b=nFNAv8Zioud6qE1gAeujq9KkGc4xucpVaRDNIUIWWX9XTwq8jLzW6ZtKxLoWAcp9/FD3bl
	J8VeCiESZ1e1RlHdtITllfC+OqVoS+QeKj6qeGiWHSmy/lNc2HC7rBa8xG7cNF/x5ZPvrY
	d8pEs39zG8EesiVqirGy/RgZxYQUmPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793707981;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9kwRa3DN63egfTMxuFyQnVb8zSbbi4+PrcwPMbluoIU=;
	b=GVfNg+91FeXcI/1vlZg/XLq3Gf+f6kKU3xQjda4/0h70fEplH6m/p0hhHVo865U5PYlwG2
	phUnBMfzkA1vaIDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0FD15134B8;
	Tue,  3 Nov 2026 12:13:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MgVXMsvP6WqucAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 03 Nov 2026 12:13:00 +0000
Date: Tue, 3 Nov 2026 12:12:58 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Krystian Kaniewski <krystianmkaniewski@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
Message-ID: <aunPI5eOUOAEUa8d@pedro-suse.tail5790ac.ts.net>
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3F53A0003
X-Stat-Signature: 3ozi3g8gjtd3gfqp998oponb7xtfqsim
X-Rspam-User: 
X-HE-Tag: 1793707982-391509
X-HE-Meta: U2FsdGVkX185pSuEU2YRnB7VVZ6G1vJejGXn7yWUBeDzg7T+8W5/BmkfHcgkSuVeqKdUq+wh2rsbfvuyq5e6QqwqMfJsOe3Gq0s/XRoDDasE6qum0rAoBvaah76iKqLBb13xIS3Y+GAiJedeKIJNlDAmFlKb7faNFeKjrBa29O577Fy6EqV1XZTurScfaMPcOpNasGyJF+u6z/9bOJahyHnx/GrRC4Y4sFh58Bufps2Wx+hE2ZrmmwZKYUslwK5rCGHuzDSpmEFu+yQusLVaVHCWGlkcJh9ywT2Aw7b57CrKghkY1XOKVSVgyMs3rZnbTPIslt0HMNc3XTTgMzzfC916TboW24n75X/1W0K40LS5M30f3HD/L6032GYSYDY7/kQxC+Gt6+a/nhW8RvbEaZYDymTzBuPqYvDIVdaQKrcDEPvLhCMm6waU5JWCcXJwK7rfFmFfK4+L6CpmfvcnJooYZI5e1oFxqEHd0kw/FhRnYFACHsKaAZ5bDm49GJn4F+fF+pJ15gUFk/1cPxF+1h3tdJ2niCRCmjAPGuZAK5yL49fv07iGh7AG1f4+lruU55C1UHzR1+WesGr7FEyyw5NMajvmuXXvxePE6eM6+0v0A999ProtZ2ZfC1EE6fiyaBZm/dFvnCjtFuN4fxveJsMSMcNOcOVUy3RpGV005GxaLA2c4OgtZGO7uSXuQM3IZhNolZQgKZPWQO+caKsfAxyVr8DG9SJkO1rhUab4JmaZRoC+gAhoL1p+1c0mmTJ9iBp94fU7Inj50q8oDMdNF/sodPfodZWmqtE2tYhG9o3bfWtv7qZk035r01DaHllL9iIldK2Z4HbeFJEHREX4AkqfZPtpbWsPCRo1EGj1XN1yAGmAImoqlsSwm945OdJWX0MXQcJh1idpf5nj8IKWDC4m/qnMqAEWKBTfhkysVr6GVl7jxqPffMoTLlQuHydY35ChqxG98ftTFE5SDFY
 O0iK58Mg
 nV9e98C4gwxLposo4P/wAaunXuMp/sV4rpz+TB3ldAkCAoI9fvRubq2eqHpM7NLlYZ+Jfpg6JYPld0R8+7mehMne3EyRG1+1MN1fq5EFCvFeUFyUugyYwolPi4ufxhjJzCvIQtCjV0FLQq4jGtaQgQFTqf4WhW1TeM7cz1VBxXbAjPPTubbtt9PwcrCv2A1+8i5IuZdDo36Cnq7x/a7BrMjuktrJ5OvJnZop/NlrFxPecnQiU9OKG6kiUPP3KFiMwFZJYAJWmBm8c+jc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 04:33:59AM +0000, Jose Fernandez (Anthropic) wrote:
> filemap_map_pages() can dereference a PTE pointer outside the page table
> it locked. KASAN has reported this as a use-after-free read [1]. The
> same path can also write out of bounds. When the stray entry reads as
> none, the fault-around loop maps a page there with set_pte_range().
> 
> Its fault-around loop walks the page cache and moves vmf->pte by the
> change in index. A lower index moves it back. xas_find() can step back
> to a lower index when a multi-index entry is split during the walk.
> 
> [1] fixes xas_find(), but the loop still relies on the walk never
> stepping back. Stop the fault-around when the walk steps back. ->fault()
> maps the faulting page if the loop did not.

I'm not sure I understand. xas_find() was fixed. Is there any other case where
this loop can step backwards?

If not, I don't think this should be Cc: stable, and should probably be a WARN_ON().
As it's a hardening patch and not an actual bugfix.


-- 
Pedro

