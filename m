Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A721FCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F526B0092; Tue, 12 May 2026 05:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FFF96B0098; Tue, 12 May 2026 05:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F312E6B0099; Tue, 12 May 2026 05:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E374B6B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:07:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 906E512040E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:07:18 +0000 (UTC)
X-FDA: 84758188956.17.EF9F1F6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 64A224000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:07:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rG99AFac;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=q+rX8t5m;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rG99AFac;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=q+rX8t5m;
	spf=pass (imf11.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5PeTgBX76vXHUAgPDfAloUdL4hOjlBFn6DxVzaUVl4c=;
	b=n7L2p7EmlDY/4jZmSI2MSzfDt8lrLpPtTaM7+i+H4kDB3NKyVE57wjMOQ1xKv14IRBo5rt
	YloWAMkElSxYJgpJON8iP0yvn9jwXwO2cZiJiyCzom4urArMFi0wqeWpXrgy5IfZANS0xk
	HNyz/fACKmgCcN6OTAX35Vu2rsMqXPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576836; a=rsa-sha256;
	cv=none;
	b=uMWhzaDJKbfy9S1iQChdGAm/WpPynedhzVm6EhP1M+GMEqU1avMKFf6JdVHg0B9Pk68uOu
	BYF5IWfjQXkn/qgpMitAq9UMuA4zExo+y+81VTz06YOaVuz3fPvXStGrDuaCR/LYcSEsEd
	SOwZTMdSxZZjmzteaSurcVL/Rs0D8v4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rG99AFac;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=q+rX8t5m;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rG99AFac;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=q+rX8t5m;
	spf=pass (imf11.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0736275DF0;
	Tue, 12 May 2026 09:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778576835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5PeTgBX76vXHUAgPDfAloUdL4hOjlBFn6DxVzaUVl4c=;
	b=rG99AFacfrHS/mn0wAKIrPoRMZhB5437olqWHs6c2YaLJ9xLk3+Q+bk6U0HZwo8l02rozK
	h5EHjA5T3FVUFcoJfzjjmHG/Rv4a8xGO25/SKzu3KkK9/LpNGPa7HkG+ej1aaMmzWjIaWa
	11jCAKPP+5HgZQLkGPA3N/LLEhC3eLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778576835;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5PeTgBX76vXHUAgPDfAloUdL4hOjlBFn6DxVzaUVl4c=;
	b=q+rX8t5m2AVF8qLXwL17Qoj8pAPE+ACjDRHNO4ulc0Y0/ywekk0gGBXlVsesMecYM/NEky
	HqrmbijEr3GvtNCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778576835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5PeTgBX76vXHUAgPDfAloUdL4hOjlBFn6DxVzaUVl4c=;
	b=rG99AFacfrHS/mn0wAKIrPoRMZhB5437olqWHs6c2YaLJ9xLk3+Q+bk6U0HZwo8l02rozK
	h5EHjA5T3FVUFcoJfzjjmHG/Rv4a8xGO25/SKzu3KkK9/LpNGPa7HkG+ej1aaMmzWjIaWa
	11jCAKPP+5HgZQLkGPA3N/LLEhC3eLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778576835;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5PeTgBX76vXHUAgPDfAloUdL4hOjlBFn6DxVzaUVl4c=;
	b=q+rX8t5m2AVF8qLXwL17Qoj8pAPE+ACjDRHNO4ulc0Y0/ywekk0gGBXlVsesMecYM/NEky
	HqrmbijEr3GvtNCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E946593A9;
	Tue, 12 May 2026 09:07:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DzK9H8LtAmrEIgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 09:07:14 +0000
Date: Tue, 12 May 2026 11:07:13 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/7] Implement a new generic pagewalk API
Message-ID: <agLtwa2lzXi7Kz0S@localhost.localdomain>
References: <20260426125719.24698-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260426125719.24698-1-osalvador@suse.de>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 64A224000D
X-Rspam-User: 
X-Stat-Signature: rmz8o5maexcytqs1m83758thqssuc78u
X-HE-Tag: 1778576836-842762
X-HE-Meta: U2FsdGVkX1/L/Ika51MmWDPFjvJEfQNI5WP+GJ3CEK4Gx315jj0dErD4f3K9T3pKWRihFC6RaQiDqYUvrHWGgW9UaeFpHaEYFjnm0PHE5vgDacBtHRrZGruayt0gp9FDC7PTsn3Wh4IJHjVrp17Njw0htBxJxahsemlr6RXL+XswMinS+0OVD/cOyYI2j5H/Ez1eIJy15/0zMD8IyS0qBLyLzUnX1FPbiNlfj3AfkGjN0G8wyQpq1x3j03TEA5bW8WmDoYZhQI1tVTkLmGNrmvbXgI6nvg98LvrYZW5MSFC1TH99eqaHqmPZ4Go7fp5rJiFgxMVAcH+pP1PJx315wfKx+3X3yeXf1qBmUA4Y0CE3pfvVtXNH14YmMUKARPKQmRtglYhLLbIvTrwjaIeADKs5b85EOzsTaLvz3RmF0eetf8oTk0Snyy29vllWOEsb8EdIfs2AMsYOb3I0UFg8p0i6MB8KsYmcrFpGr1CaHSqWSC+G4LmgqkxRAfaJYURCti6atfUg9z2G3FLa8K11C7zqdcgEIO4X5JP+fsr9pXRFCzLzxu2yKIQdShyZIutQcPXeMtAS1x5e8pPPvG1qiiEH0Xbtl//Y/j5OIGQ2wR4kzCuCcyfstKapTHoHHzUbSQqkkpT92RlXdWZa5zbt28kLaDBZ4anPMJ0gqlyNN4gL9OdVOnT1mW2JUQLgVoqM9wrCku/ffY/Q3FUtgLMc+2SRUvv68Iyww0Y9mCUPgY8xnBJ2kT714VScwhen1jNwXCliF3V+3e/Khos8ChG8bleuXP6JV6tR09du5OtuO+3m0b5D59/VQHC3AZAnmQj+Cg+Q0NIclXoaOVFAgKg7wDaLYoqjO6zvwztKO9bMGAuxHfKhDF4iWmvNpW2xPY/keWak5TIJxDoEa3D3BQ0PUfn8OBxa7e/bkX4MC+bj0d15tTaK+n/DYAJiJ6WOdHT7z4RFuLjcH7nsvT1bw2b
 bo0pGknn
 yI+itJxVo6ZEaoWvKGWl8JdXVI0xTgGP7RWwMj3siphrRxeyE6OgR3wQqfwvqqPBWQfggfWrhn50zFczmGRM2lHOdF23iKc7gqQfi5bPE5K1L8DEhEvKWbDJ+Z+55G6aiZv9IHpqdfcPNyP4tyQAr3+0hYUok7NtDZors5eBWiuqqNF3xmRjBeNnkjRR1LykphwAPQLH/LbxzWgnEzq3ODOigF+RJohLGXVEG85TwT9oJJ6CXEeuxoYk9fIEGtRi6DyYl8z84G3VFuHEHCvdBxWcDAbs95tH87s5o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 02:57:12PM +0200, Oscar Salvador wrote:
> Changelog:
>  rfc -> rfcv2:
>  - Add pte_hole functionality
>  - Fix pagemap issues
>  - Fix shmem in smap
>  - Testing with pagemap "testsuite"

Please, hold on to for the review of this patchset.
I have found a few issues while testing cont-pte/cont-pmd on arm64 that I have been
fixing and I plan to send a rfcv3 by the end of the week, so we do not go over issues
that have been already tackled.

 

-- 
Oscar Salvador
SUSE Labs

