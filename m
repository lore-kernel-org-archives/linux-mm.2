Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77CBCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5C08E0012; Tue,  9 Sep 2025 04:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E2E8E0001; Tue,  9 Sep 2025 04:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BC28E0012; Tue,  9 Sep 2025 04:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EACEB8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:00:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB1C61403EE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:00:34 +0000 (UTC)
X-FDA: 83868964788.22.FA30C7F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 78C711A000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:00:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DOlcoyBH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NEfLVv7t;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DOlcoyBH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NEfLVv7t;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757404832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvUkPTxLnNWcwdRJR5b+fZTc1llU3CirdTSgIFnoxGk=;
	b=Gu/s9fLaALYiyPE3dleI5hcfWyogc37NrQ6K9NGgABzkOD95or0tVz8dKppST1hV7qyuNF
	XuwVMsHNkZQr9WIoemFOCsYTalWMmIkF2ZYsH8iQtUY/qE2D8dofm9bSfTiX34QT3d2kPT
	FTA6Vg6octix2N+G/Oqe/VUTM9b5wxc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DOlcoyBH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NEfLVv7t;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DOlcoyBH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NEfLVv7t;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757404832; a=rsa-sha256;
	cv=none;
	b=OVNWTG7bQZrWayXdLNlipCrw9b4z2Nb6bEMZhYxilUR/oWKYkzt//GytQEc8McpPSWkHJP
	7W/rS1A5r4YKI8zm6q3DxP83Ldxnvr6pv9V1I+Hg+wq0lrtBJwX7r/s3RJVEW5O8XwcRBj
	901v912AZivVdMtCVOopPEDbLgcCT1k=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CFAA42A00C;
	Tue,  9 Sep 2025 08:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757404830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CvUkPTxLnNWcwdRJR5b+fZTc1llU3CirdTSgIFnoxGk=;
	b=DOlcoyBHTMsysprimbITprbGAngs268qJe2ViwrT7luCpfo7boReGo70C9EQ3+Z7OOuS2t
	+ZeAKGqsD8TU+7zTJNseLXNUMD3j3Z8GORmNuOL3T0+O01rLRIxMciL1bjN4fxR4/3e8hf
	Lod4jNtj1B1DxRJFi1msN3QnnkGhtNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757404830;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CvUkPTxLnNWcwdRJR5b+fZTc1llU3CirdTSgIFnoxGk=;
	b=NEfLVv7t47IZL6oJO+HxOtv4VjIdCpB+QWn/oSohjX8DrYioUZGEPWFSAAGcjA25G3wJXh
	8AuClsUqLg3iGjDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757404830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CvUkPTxLnNWcwdRJR5b+fZTc1llU3CirdTSgIFnoxGk=;
	b=DOlcoyBHTMsysprimbITprbGAngs268qJe2ViwrT7luCpfo7boReGo70C9EQ3+Z7OOuS2t
	+ZeAKGqsD8TU+7zTJNseLXNUMD3j3Z8GORmNuOL3T0+O01rLRIxMciL1bjN4fxR4/3e8hf
	Lod4jNtj1B1DxRJFi1msN3QnnkGhtNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757404830;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CvUkPTxLnNWcwdRJR5b+fZTc1llU3CirdTSgIFnoxGk=;
	b=NEfLVv7t47IZL6oJO+HxOtv4VjIdCpB+QWn/oSohjX8DrYioUZGEPWFSAAGcjA25G3wJXh
	8AuClsUqLg3iGjDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E8221388C;
	Tue,  9 Sep 2025 08:00:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jUiAEJ7ev2hIbgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 09 Sep 2025 08:00:30 +0000
Date: Tue, 9 Sep 2025 10:00:24 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Hu Song <husong@kylinos.cn>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: Use folio_nr_pages() in __free_slab()
Message-ID: <aL_emHbGN3xA5i_c@localhost.localdomain>
References: <20250909074812.599030-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909074812.599030-1-husong@kylinos.cn>
X-Rspamd-Queue-Id: 78C711A000F
X-Stat-Signature: ugsienn153pr3qmcaxkfup4fcxxdfm1s
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757404832-502806
X-HE-Meta: U2FsdGVkX18Pq1bti534yIOdOYzOz+NaKDcK/eObKY64pxN4ezXNQ5jjPU8y4bwoAns70iAhAhJr/Y70X0ZoGatwKMT9hDLHueh/WyRMFCoI/d3iBcHTmEPurar22oPqFCZIOihxcbbUtiEALKhg6N7vaqoclXyNlMBNAvK2zKTxJkesEDr4GlvEzEZLSXMdV4FNkVptozxGfo2LT2HgpJ8j9AiS4ODzF56iFcrz/kF7qfR1BEqHEC5ZYt5HcxvLwJ9htzXe+A1RkN/lGi/rLPQG6jFcu5xNl6jz5RoMeX/k/UzAhkotvmE5fapwdQ5eUkOjgXuIUr1QGubZK94F2Gl1VAfDgFzQy2H7EztfIeBYBKrdvKp7VjmChcVO8UI3PM+oF1FhCua1AySzAa3rtvJbW7WE+t4Gfsn66qCM+/OczkmC+z/+iNOkZXdl6Inb0bNWqNT+Q7s2q99fn9XTebsyp1xaICXPaLQIvoDkZsLivS+9cxwQm44PyMzdhyS2Izvwa+97WkkLp0yTyvbfxiWp+yM30SSk9jZHNJf6lcn2jEdhsVp9ZiH2NBBl1lQAR/RCjoanZBFQgBHwPSdj5MY28T0sNPrvAzM21Mwv+qJUulPmVwzjwaaAdL8WCpqQwoRUFHgSq3GC5geYL0TGtNhIeU3nFsy22TJAYbhLtUV8FHDEaJ2CVxekvmskw4l23YVuBx+l9JgfJGQpuQ9yDqgZ0nX6zziKMe3Sv8QwkzgFxxnvuWk+p7mnR+ViUwb0oszoRfdLApgUDNsI7l4ulmAHYmKWMkypUWu8lOsj7ayQCKZ4C8lIijN7lkE+fGJP1KDq6Anxqs0dWD/VZ+x8wgGNcYlHSS6iusAU1NoqdFjQuPHfb7iA2UTGTlHgfgR8odNeQrOSHBarIIie1ZHNMQ8BMXBbyCDZDlYRdLFzkx94AfRrB6J/9mTbAnkZugvzco41PgnXMCrHzecbZU4
 RrGrZfFa
 f/0TQ1X4Vi/N2QEDOUTh/2gGHECfDQTYJ+Es48wSv6UYQ0lloCgWGccux1H0ercA0xO0Z5p0QhnNonnK6NZ6DPvoB9Qy1j2uuiFmBKzM8q4ZAvris5iahb3yBKceYfs2av/KEj0dwpmkq7CXlLsduO/sZcI6IoTU4SipAl0YGe/20g4C7ME4d3QpDfrRliDbLFkKiWeq1ieCTQzPhFWAUwVEl/RczTKJM28CZjku+Uz+Y1T9akucUumUkL6C2f5cDOUCGbhSzJ+LdVkTTqQetjMbvQ8HsURFivMEEFL4r56GbL1YwA13IPuo02A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:48:11PM +0800, Hu Song wrote:
> Use folio_nr_pages() helper instead of manual calculation (1 << order)
> for better code readability and maintainability.
> 
> Signed-off-by: Hu Song <husong@kylinos.cn>
> ---
>  mm/slub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index d257141896c9..eba25461641a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2719,7 +2719,7 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
>  {
>  	struct folio *folio = slab_folio(slab);
>  	int order = folio_order(folio);
> -	int pages = 1 << order;
> +	int pages = folio_nr_pages(folio);

Sure nothing might happen, but I find a bit weird that folio_nr_pages()
returns a 'long' and we store it in an 'int' type.
And then sure we handle that to mm_account_reclaimed_pages() which gets
'unsigned long', but that's another story.

 

-- 
Oscar Salvador
SUSE Labs

