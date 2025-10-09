Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48684CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 08:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2A58E001A; Thu,  9 Oct 2025 04:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA2D8E0002; Thu,  9 Oct 2025 04:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9108E001A; Thu,  9 Oct 2025 04:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69C8C8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:37:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2C3146304
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:37:13 +0000 (UTC)
X-FDA: 83977921146.17.9137450
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id E352D120008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:37:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kL3ktFL5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FD6L3X29;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=taOkQvsj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ISTxMOjt;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759999032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLHJUMcs8cKGTkdNpbowpIOfVp7jR8lMa18VcOcGcw4=;
	b=Z1SY9jzAlC6ySXbpvNqntuQVVraGXZl3pi2qv5Sj6zkPWVgfA/cPgcjSdOfCHqATQM4+wE
	lYGHN8kh0c6AcI2KL8YR3oLBJhULZdgwNiEVuw4sw8Fwok7Qttrkqv/7Tij/U/pXRNwOHg
	vW0P5sl/EA+1tRr7is0VnoMZFbzgn4M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759999032; a=rsa-sha256;
	cv=none;
	b=FSsubI+Vf/LU+/hqEzPejHGKz00QqYO8jgzo7wZxVf4gDHfGZFmqgH+YT+U3lgmTXouVqt
	kSciw/rcBhNp+8EEjiKcErqUPWzoIpK7B/3+gChvDok4Uviw90RHL3z/Qdlyuvg8LwAToY
	hzmffDyAIlnoUhxwgbWIgYgpQ5bJrPE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kL3ktFL5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FD6L3X29;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=taOkQvsj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ISTxMOjt;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63EE51F849;
	Thu,  9 Oct 2025 08:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759999030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PLHJUMcs8cKGTkdNpbowpIOfVp7jR8lMa18VcOcGcw4=;
	b=kL3ktFL5hdwhjBRZxX8bVvsngqhOPMdItNsNESeUQHBJAb37gPz//iFhlg5oCsURRqGBVG
	tuVxNCxbPGtE2UKQ+Vbc93hWGOVRdofTIQbUt2QdhAOwp6Zbcj4XbEX6G2J+x8JR3KouLC
	UDXgdzz6pBlRmSZC8GkeOebvCibv8+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759999030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PLHJUMcs8cKGTkdNpbowpIOfVp7jR8lMa18VcOcGcw4=;
	b=FD6L3X29KJtnzCYzRQhYaWzmqyit5mavYQjURUl7+Woi0MZdjo75/LrpS33M2L3U7/b7f3
	kPWhalWE60PhCDDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759999029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PLHJUMcs8cKGTkdNpbowpIOfVp7jR8lMa18VcOcGcw4=;
	b=taOkQvsjGVo9HZOqqJ2gid452GUv4Orc56MeYjjPORpBERlPaspov1MtIH/k9tCW0igW80
	+o5qCrspooCetfuRg9xp7+wN9KfEA/Yo+ffAE2U7efxjsdOAYIAjrcQkA0yo83jbomKhUb
	SWEcS5Vo6yno/uPw+5+iqp5doo6aSqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759999029;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PLHJUMcs8cKGTkdNpbowpIOfVp7jR8lMa18VcOcGcw4=;
	b=ISTxMOjtEEOdFTgIVvxdSkW7De1IQ5tv4BqHh2g6R/sb4mTWPhaqxlX7NcBY7IlQdn49Jg
	PP2HAfxF0qWUhcDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF1E213AAC;
	Thu,  9 Oct 2025 08:37:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tIrmKzR052iDGgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 09 Oct 2025 08:37:08 +0000
Date: Thu, 9 Oct 2025 10:37:03 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH v2 3/5] mm/page_owner: add debugfs file 'show_handles'
Message-ID: <aOd0L1asypia7HB9@localhost.localdomain>
References: <20251001175611.575861-1-mfo@igalia.com>
 <20251001175611.575861-4-mfo@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001175611.575861-4-mfo@igalia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E352D120008
X-Rspamd-Server: rspam02
X-Stat-Signature: bgr1k9ck6tyssiscgq5ese1n9d9csjds
X-HE-Tag: 1759999031-319707
X-HE-Meta: U2FsdGVkX1/npnwmlZT/JNEknqDAPP3nm3Pfx1oMv1EZZNIOVh3EF/BBLGeyEshoDMzhIVmVFOT1kZz9aW0q3stVgNk6439HBwIHb9jBaWSU3QWSFIgE5aUIkaz+e6d16rI/U1hSjDlZ+auh7/IBMOHX6/pihmivqpQBUnDpaLxkhznqwbWrcT9q/tZg9SKeAaS/niUlD9c7xMXjL5fkaygievfzUzo6nG0jnnhIbz6ZNErefjYNyHEELJXTDOU5IJK2lttqhB8hmr5INRYwkw/50EyPnM6iFjJWd+wX4Oe63Fb/jBGNUYHHZvJpndJ4B/D8orMD6Fe5y0+q2d0VNjVePi51LXxBARp/lAc+RRdQCwKax7/rxCO78p8U1j1ehcdEYmCk3u4+iuD6Cg3PzdM7tetvLwXU64izc4k6X40hPuvC5A65I3S2xUQ7ISvdtDzLzM+NnkxN1qFinlQtzH1geXvumsCeGqJoxAyJ1u+4uvNvqrdIu9GaVzuEUrG1HPaCh2EbckfHLaE1UeZal/ZUwAnEi7eBPkCJIW0NtnBEmB6gnmOMCgVgkHb1doKsLCdcN/Q7rPfqBOM3ogiNlrP+BntSyTsXBDTxFHwKFT1+z2Dn3nPtXuenNLV2mljDRA0y1SXiRykOe8+mirB47RzZWh0kYOx/D8prWwyqPNwaiOitDP6OqYNbUVaQMEg2bw3t9QjROslyvqutFQVM2HrUqZCCoPMjyaWM4lk9+DtVjCUforRm7KTz8BpaM7qACRMOaj+26CxueRy81nn17xyqpXduPPpd68+obu2+5koxB4y3ej5v70R2TBcLnEhVIGXr51weItwE0bYYMkl/k2DjZdGGTPMw9+pPGx+jHhVR9Va89OV7EnF4mhVXjEYtu3ere1VVb3nSgzX9otww9CvYA7yaZv4Xsj7dMwcRQW+wX0n+B1MdvxTBur/r5KnBFmMDmLF5FoaEK/+rTjQ
 eog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 02:56:09PM -0300, Mauricio Faria de Oliveira wrote:
> Add the flag STACK_PRINT_FLAG_HANDLE to print a stack's handle number
> from stackdepot, and add the file 'show_handles' to show just handles
> and their number of pages.
> 
> This is similar to 'show_stacks', with handles instead of stack traces.
> 
> Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

