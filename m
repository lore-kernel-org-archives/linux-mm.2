Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B364E7BD91
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 11:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53BEA6B0005; Mon, 16 Feb 2026 06:39:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9376B0088; Mon, 16 Feb 2026 06:39:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7E36B0089; Mon, 16 Feb 2026 06:39:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 297736B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:39:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E0E513C194
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:39:10 +0000 (UTC)
X-FDA: 84450123660.25.06AAF64
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1B54C4000B
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:39:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p3JyA8bh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kkqgt47f;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p3JyA8bh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kkqgt47f;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771241948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbjZPXjREGbAx7ntC8vD9Ig1U2Ql4S/pSKRXVeCyDvA=;
	b=Do68PZM45PfRC3bazLycRE2EIiF842KL1JNvOkcoEcoLg1ClqGTt5W449669+LmTJCQg/h
	d5hwEbi5xP8mbBoKhmBlWfiKBau9+O6oxrVZ9wr8Gi962ezXwzht3p/UBX6dmzMzEO7wt4
	yTq3NzchE5OcNNagrMyeau4mviGkbEI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771241948; a=rsa-sha256;
	cv=none;
	b=FVRZ1zO6W7xruuYK/mGY0vXnFAE0IlZiz3TDK9IgpIgO7ho5ZbKDgdDLdK9USebpbyjaPX
	LgXzuhjHtqQbMtnkpH+C6u5QxbxUr+ss7dyNtqAKX5DLK82BWiigCAXjlEuMt8fMjDKmix
	bo506JqKnS2KTKAvlNB2ei7O1a51BCc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p3JyA8bh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kkqgt47f;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p3JyA8bh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kkqgt47f;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5335A5BCFF;
	Mon, 16 Feb 2026 11:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771241946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QbjZPXjREGbAx7ntC8vD9Ig1U2Ql4S/pSKRXVeCyDvA=;
	b=p3JyA8bhdFyL0ld1P4fNn1Yxp5LdNpmiePmfuryjOTXjs4oG5Fea2Hh/W3IQd4aAqE9ayu
	ZST1PeI61pQYkbuqAVRLluJwsDwVtJA/+LhPU96uQ/YW0t+siQ8WuD1J+u8GNjwx9lUJ8t
	+Mg1n/h+US/VYCIJJtenyOXn7suQsRQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771241946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QbjZPXjREGbAx7ntC8vD9Ig1U2Ql4S/pSKRXVeCyDvA=;
	b=Kkqgt47f3D2hLb+DbYsty7+TKZ782vebLzWVOZFX+iakm22PNqoIcQ1lHzRH1rpoInDryC
	9LJSVBf/Oj5WH1Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771241946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QbjZPXjREGbAx7ntC8vD9Ig1U2Ql4S/pSKRXVeCyDvA=;
	b=p3JyA8bhdFyL0ld1P4fNn1Yxp5LdNpmiePmfuryjOTXjs4oG5Fea2Hh/W3IQd4aAqE9ayu
	ZST1PeI61pQYkbuqAVRLluJwsDwVtJA/+LhPU96uQ/YW0t+siQ8WuD1J+u8GNjwx9lUJ8t
	+Mg1n/h+US/VYCIJJtenyOXn7suQsRQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771241946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QbjZPXjREGbAx7ntC8vD9Ig1U2Ql4S/pSKRXVeCyDvA=;
	b=Kkqgt47f3D2hLb+DbYsty7+TKZ782vebLzWVOZFX+iakm22PNqoIcQ1lHzRH1rpoInDryC
	9LJSVBf/Oj5WH1Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B98A3EA62;
	Mon, 16 Feb 2026 11:39:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hj/sAtoBk2nxfgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Feb 2026 11:39:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D646FA0AA5; Mon, 16 Feb 2026 12:38:59 +0100 (CET)
Date: Mon, 16 Feb 2026 12:38:59 +0100
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, 
	hch@lst.de, ritesh.list@gmail.com, jack@suse.cz, 
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, 
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Rspamd-Queue-Id: 1B54C4000B
X-Stat-Signature: cekhjrh1zuoqhfn375usjwbt5hy9ma5i
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771241947-291121
X-HE-Meta: U2FsdGVkX1+7dQ/39o95IknFTl6/zt4yv+uhVodnQHTnjh66YRL0hCQD5KFxg6kEG0BdmWf4o2xR76oZuM1mXWJreTFQdHqYghzaWf3D9fOxgWOInRtTSRhcoU3dDVx/jmpTDF+1PDCcpoBrSfn4waxX/F7QzpJV69NEisy5krE4ebN4AEJAHSCFnpOv/kFYVznXTSuBRKOc2bwxQuizc5dmOeEAJhlA9RqXLLBztRGk/rhKG1bvtpRZobb/axCyUYpzIgfVX4fobelaMMY5NANyetjVvMpItWXidJfevPrJTZCZqJ+yHYYKZu3ZbcTezzgzWTFJkC4bKDuBTo9/2Sx9SHLhJrkFUfQ2DLUDR3ugiUf2DuxtsIoeQxGrjBxwwoE+pEZm9rbrC+iTgFF8f64AeJGWDq+Rpr7dKxCQZEQmnA7w1KXK32IH3eQmbjVnxWtijpGRD+OqDT60dNWkM7SVg48/7ZDNI5XWkwLGKPeD7PKG9UXbCCsdsTMyA1yOohiy1tplpP/jXsKbnWceMmbHzfUYpDngZpeU27OAndiRbiso5+cyz95dB1F26TQyGG3tOKIkecScmGRzgsXtEaJUmRnuvHd4vCn4DnW70hKdi9tDc3fgbIwsUOwYTpzfp0qvc1bOiaVYTJup49t57460YjJeffnHwbe+9qPuVvJGgwLMh+Vtp00h1k1YsD1hTn70JB34J7PHd1bj5drPfb9/OdonsWYB1s+AhbOkI6HB+jQlHz0of+ExJpNkaz9Wj2XGONBV7p/pqtAmdlbBKFyvdQZSF+xZ3yga2VWKxHjFtaUEr6J372CtggyiCKjjFXm5w5pQ9br1UeoCCv2cKq5wHmON1KuDcPvbJRYSIjakQyPDA+J4LpVd9/jRHR06/WSxDFtD3Mn5DHEW4xdHy49PLa6tasxR2wP6sFVhSxDFdr4pb86WqRj4TZMvMTvedK33bWi9vIY7eN4dIHe
 FXyLXyRv
 ilguWrq0jd2hFLl81/sVgf/yi2KzU/s9MQKmroipK9xQwf7q6DfWGD8h2/8R+nor9wklMT7q+ggIdRoZ0ZsdOsEnVcK3b/PCiUECYJj4nOJGJcwkWwNwarp3imC1eSHC/2zkYK8boDK/McLFWI9BsRdhyFbLsDPciPBofxDZbyd/GeNm4gS2kecpfdAsO//RYhCOq9P+8zMCkmdIA2sjIivAe5fwmj3/uBMAwcgWxTX6YQUR+tyO22Niv1IaqOixT7063Bqqh/msQGLHTbPi65X/Bh3FIXWbIbdqdaiAUTdvmNViHELu07jPFgxSxDIShun05dqvuKI7j8Qkd/BA60tv70q2A3vB2aGnhMBlRhMa5Yk3TFZN8VtBl9pfM1GyjB0A0qmw2r67ICy5m8HpNLu5xSlbYplXRMcj0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

On Fri 13-02-26 19:02:39, Ojaswin Mujoo wrote:
> Another thing that came up is to consider using write through semantics 
> for buffered atomic writes, where we are able to transition page to
> writeback state immediately after the write and avoid any other users to
> modify the data till writeback completes. This might affect performance
> since we won't be able to batch similar atomic IOs but maybe
> applications like postgres would not mind this too much. If we go with
> this approach, we will be able to avoid worrying too much about other
> users changing atomic data underneath us. 
> 
> An argument against this however is that it is user's responsibility to
> not do non atomic IO over an atomic range and this shall be considered a
> userspace usage error. This is similar to how there are ways users can
> tear a dio if they perform overlapping writes. [1]. 

Yes, I was wondering whether the write-through semantics would make sense
as well. Intuitively it should make things simpler because you could
practially reuse the atomic DIO write path. Only that you'd first copy
data into the page cache and issue dio write from those folios. No need for
special tracking of which folios actually belong together in atomic write,
no need for cluttering standard folio writeback path, in case atomic write
cannot happen (e.g. because you cannot allocate appropriately aligned
blocks) you get the error back rightaway, ...

Of course this all depends on whether such semantics would be actually
useful for users such as PostgreSQL.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

