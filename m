Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4DCD6083606
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=AdMzsJd7;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qcuNXjir;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=GPTxdliW;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BlsmKnRq
Received: by kanga.kvack.org (Postfix)
	id 074C96B05B7; Tue,  3 Nov 2026 06:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B286B05B9; Tue,  3 Nov 2026 06:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8E46B05B9; Tue,  3 Nov 2026 06:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B58646B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:37:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 482ED1C3AA3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:25 +0000 (UTC)
X-FDA: 85393607250.22.35F81E9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0AE93C0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AdMzsJd7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qcuNXjir;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GPTxdliW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BlsmKnRq;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8j92hybFHQnaobaSpqwDPNDEjwRDPEUTD3UMs1Ts1w=;
	b=3xylm3jDnCrtxuV2VaGAAS1HmoFHJyw4VQ8WTacccDMRHo7d9E3+t8jpyQKBoRSxPFCyBI
	kzCHtGdILQ/CmbJ6+i46a1xvzQFj/JiJ+CAN6GQg4tlwDhtVyP7v36+Zf5UxQB9KWP6pLS
	MyX6wEILB4kg+P1dim/5MH/0IPedjto=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705843;
	b=PjVhOO4FkTXVlqCXr+ynoGDODyJd6/DPzEryAiBKY5zXRhi6nq52JExVRVULhpstEP0Oh2
	7Ob9zGTruPotvlHMn1KkUihiGExGFR0eycFHSVzV2sJF8V8kAKQY2bkWzuUXIc2kCx+e0o
	DwHwVyj3ThhP4IbBb7Xv7GAadRa8XIY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AdMzsJd7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qcuNXjir;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GPTxdliW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BlsmKnRq;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A7D3F228C8;
	Tue,  3 Nov 2026 11:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793705841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B8j92hybFHQnaobaSpqwDPNDEjwRDPEUTD3UMs1Ts1w=;
	b=AdMzsJd7BTY1vMsvqPR1dY9+mcRnzNWajy0kmkYRQEDKHdjhVio/T61M9GlgCzvLc2SjQT
	opQiXlZcjdzrewnfzyNOSmhKe3fEJCNm2CJR2MPJSkbMYy05XreC5GmkxHsSpCfuh4RivM
	ccx5lMgD7hdu+vND+5RtJj0V323s0RI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793705841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B8j92hybFHQnaobaSpqwDPNDEjwRDPEUTD3UMs1Ts1w=;
	b=qcuNXjirl4sgQyWfrimO9Uiw/TkfsMyjRKQ8ES5My4BDC4QsJuHJn7nVzzgJVgTAXNQtPi
	/4yMJMyp8nzeV5Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793705840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B8j92hybFHQnaobaSpqwDPNDEjwRDPEUTD3UMs1Ts1w=;
	b=GPTxdliWplSou1ClLnj2+Kfxwhbs1yPVbkxdcZkH44iyO7j/mdIVSM/Zc6IqLbo3APNR7K
	9kJ0X/A1wcYubFjiTV9pPg//ggQvnKOTKsZMFQV4qg3sF6kFR7gGWaD87mYimrmRWXgnWI
	sZCyM+Kc+Dx1ofGpsb3T+D006P3pHtI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793705840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B8j92hybFHQnaobaSpqwDPNDEjwRDPEUTD3UMs1Ts1w=;
	b=BlsmKnRqvkggekSHbDTtA63/yU0kV24/p+9munsk0xIYPcfcDGJeON3oKkbosTyMbug0X3
	/i5mu7+V43IDdNAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 72F4C134B8;
	Tue,  3 Nov 2026 11:37:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mg2HE3DH6WqiSwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Nov 2026 11:37:20 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 02D42B231; Tue, 03 Nov 2026 12:37:15 +0100 (CET)
Date: Tue, 3 Nov 2026 12:37:15 +0100
From: Jan Kara <jack@suse.cz>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Jan Kara <jack@suse.cz>, 
	willy@infradead.org, hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, dave.hansen@linux.intel.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] shmem: do not extend i_size when no data was copied
Message-ID: <rfvf7awrww55bg3hwq4edbz2ioorodlrb3wcmf45wcrof22cda@yduswvswhz2c>
References: <20261025164619.89992-1-dennylin0707@gmail.com>
 <at9xXRhD2xZhszEj@thinkstation>
 <xmp7ni65vbinfj4j2baisrhp6xzro3asbepuq7xp3mvx6maptn@r4dnoj63uw4t>
 <at-XtWBQg3jv3H8Z@thinkstation>
 <CAGEkeHfq1xZf_jMw9a9cz3iunj6O3UZ4-=iW-65aN2Ss0oT3Uw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGEkeHfq1xZf_jMw9a9cz3iunj6O3UZ4-=iW-65aN2Ss0oT3Uw@mail.gmail.com>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Stat-Signature: 8riuhx4whsp356sm6r5mqjt51ojwmhpg
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0AE93C0003
X-HE-Tag: 1793705842-692557
X-HE-Meta: U2FsdGVkX1/2rmZt6Rq0KTbca7pmrMEoUC70OPU6BdLO+ndbfe6D8TXURUY3ouoV1lvYXNvt/E6BNJEuOeUsSDd6b6JVzqoHI1JPMVoi80sGDk/+4AVJug7E5B9DqN1kBZKpk+xiFd9AfCMiquNrOrArXKK5vytr8k4eBe1tb1pn0ALCeREx3NG0IJxH6enPZHAoYcntRD3BzfQEh3Fn0mCgGZnwQc7v2mWq/q6F0vCHM7DugLqrynsvZIxx0nR95/jkMsh449JPiVuEWnkw6YFGjdOknH1173n9ZGqGfre6D4gu+NYm21vTVA1CugxYHbOvXtqfag6tfwuPu0dp0iOeP/r0pseQUCJwZN+QJq7gPOHm0IIYT/36yHQdNDTCfJhNTbbQkCxKn5WP4pUzTwIURD0874aZSeG5m+y5rEDkQb7jpGTG6ZJ37H00wPbdGrAnZdP7p6QtN0W/orOgZbHByDSt0IAHGdGrZIYqHuz2m6NbU/VP2thfZqiSpyD/FPXMSl752zi8r5thM7p5LOIU6oAKPnYFCkrAig5agZ1uDMMpWuzzE0i+smCC5l0kkbMeGbKEp2VcDR4cj5OGiv2iyYBMTiZe4GVSknRm3Tz/cCFbxAj5sK7KLft636tM4aJIZQUMBl9tRw900RPGe1RGj0ZkQQkWpyLcrf2FrO0yBmYGnoqZg3HGmzZ3Vj75cETqAbInYPhp7hsEEp3cGLdv8MyRQIAg/rOfEzYowbnQIMfX9g2rKay0N+2A4jC5vDfSySMo3RVkunfxIhLB5w3ixN0JM1YsUhqJQTkKmNdswqK4zYKOWepJW4nP5hP7HyTP1GiSOOuOn8CmStKEflVg0pbBH2Vnuy1sDogqe8QngspBFeOJIraQMqj6gia3YCdVVJ/vE0E7M4poowO4G6dYTYkbK7A5nasj1hj3qfbke3Iu3GuLSoXfyVqF6bh59YvQNP/7B9qwykQeq8y
 Hhbb+Tu2
 0Vz1MfHFxXnGQOCNbGcBWnRM7z++KVX1ViPl61k/+xtHvucO80hEHFt4Op9FS9rm/yzI+w3Q4Usr3UVoIBpS4JAA4yIjVqxvOI8qH7aNdCc/1a+86zLRjG73EHu9xjbneq08YCD6ZJwAn5bkq1VJha15bClAApfmiUW8EHWC2gaw08ETk4Pa84bbr+UL6DruxkaU9Y71WCBDWqpm/sD5CBRUeXI1YP69y5xa4deT4eqxHNO3izPG6wJeQOA/AhG3CQShZ9w48wPKR+bM6ulYu/8ys7/Rgm9EJXRIullFEIwSS0vcwQCPLm17hKMTsJebVQYsh8e4TwFrcpZd1uVy6ja3g3bUktnusJPVlk1Rk3on4LnoH7fPn2l9c5AiNaqYtAHT1criaicsulWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 03-11-26 02:34:11, Hungyu Lin wrote:
> On Mon, Oct 26, 2026 at 06:18:39PM +0000, Kiryl Shutsemau wrote:
> > The per-filesystem alternative is a 'copied &&' in every ->write_end.
> 
> Would it make sense to keep this fix local to shmem for now?
> I'll check the folio handling before sending v2.

The trouble is that practically any filesystem is going to have these
issues with 0-length writes starting beyond i_size. So if we can fix it in
generic code, it would be certainly easier in the grand scheme of things.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

