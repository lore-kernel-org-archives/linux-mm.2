Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B9B0CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 19:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980256B0088; Mon, 12 Oct 2026 15:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9315C6B008C; Mon, 12 Oct 2026 15:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845CF6B009F; Mon, 12 Oct 2026 15:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58C436B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:02:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47A2AC0AD6
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:02:27 +0000 (UTC)
X-FDA: 85314895134.01.29DC266
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E71818000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:02:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=masbJiR7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Kr04+8By;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=masbJiR7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Kr04+8By;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1MJcydieOLnLddhhlzv+LN7MrTTO0vD0Im1KjvgXII=;
	b=hj/mVR+SiLUkb7iFvs1qoDf3E3ULUSSAW2NTUEXn7MK2ZTGhFofAelkT3f/4hWocC91igE
	smI4VrBhHpmYCPTDmmPy92fOwS/8PQ0lhW2plI/ti+oEFpmkIW0kwA2qDg6Nmt53WaUU1q
	MkH1JjVhzkHyog0wLpgenprg+Nw4nMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831745;
	b=LW1uF32Gxnna4cUeP2oH/jA/nR0GGJqiJatVBGvA1oXq3nAjOQWMIzLJGcCE5XcDCXinRr
	Q5IxfoBKVnn89AoK+HdRB/8a1iGMiVcystPO1FcEfzQosfbisjMsHoAWDwIHU8X5e8DB2m
	baCP7+Mkq3ynQ1C7KzVeX+sle1Pa4pM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=masbJiR7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Kr04+8By;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=masbJiR7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Kr04+8By;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 424B721E04;
	Mon, 12 Oct 2026 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791831743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o1MJcydieOLnLddhhlzv+LN7MrTTO0vD0Im1KjvgXII=;
	b=masbJiR7ZhTvYFKhFm1zl/0w/7elJwX8WwH6QoAFruwV6fHt5Qk5dx2YoaqGtAZXioJ1R4
	wM8arvdPToaDjIuNloFEXafoBOy38SePsA9GTSxUUTaL9crmqzBCCtsFLKN/h5YOuvM/UX
	q+L5sHnezzYhyz1SnzwWjUFHDS4HUeQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791831743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o1MJcydieOLnLddhhlzv+LN7MrTTO0vD0Im1KjvgXII=;
	b=Kr04+8ByiiE+Fka9M1EB4QURJv8iqJbcAuTn+0uiCL0tfYsKOfeSCRN9UqSOCshqpi9gDG
	cBrflbtMpfkhpyCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791831743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o1MJcydieOLnLddhhlzv+LN7MrTTO0vD0Im1KjvgXII=;
	b=masbJiR7ZhTvYFKhFm1zl/0w/7elJwX8WwH6QoAFruwV6fHt5Qk5dx2YoaqGtAZXioJ1R4
	wM8arvdPToaDjIuNloFEXafoBOy38SePsA9GTSxUUTaL9crmqzBCCtsFLKN/h5YOuvM/UX
	q+L5sHnezzYhyz1SnzwWjUFHDS4HUeQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791831743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o1MJcydieOLnLddhhlzv+LN7MrTTO0vD0Im1KjvgXII=;
	b=Kr04+8ByiiE+Fka9M1EB4QURJv8iqJbcAuTn+0uiCL0tfYsKOfeSCRN9UqSOCshqpi9gDG
	cBrflbtMpfkhpyCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D07A13314;
	Mon, 12 Oct 2026 19:02:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m+QbCr4uzWq2XQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 12 Oct 2026 19:02:22 +0000
Date: Mon, 12 Oct 2026 20:02:20 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, jannh@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: keep the hardware dirty bit in MADV_COLD's
 THP path
Message-ID: <as0uqGJ6zuCc--qL@pedro-suse.lan>
References: <20261011132227.413217-1-samarth.colleges@gmail.com>
 <42087cd7-473e-40a7-ae63-3c841c615c8f@kernel.org>
 <asyy7Nwik5yMTNbo@gremlin>
 <asy4c7zkkmSRln1H@gremlin>
 <D964ECBC-59B6-4A4B-83D5-935EA2D06D30@nvidia.com>
 <asz7YUXhdmlenXvh@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asz7YUXhdmlenXvh@gremlin>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0E71818000A
X-Stat-Signature: ake8yioziustxd5hbwpirmc3anmo83ur
X-HE-Tag: 1791831744-487087
X-HE-Meta: U2FsdGVkX1//QCjNjZpa0/tLunQz/EY40p/QSrPcI1uu8x7ilYfw9Fs34n3+amOetCIgN0wsrs61KcSNlkFtBvVXzRNTeNNXu+67UJKbIIRJ1INWFjoGqPk7nYyZFAXMbUapuSa3683eS9XuhKau2v2Oz1tJOQHGiiX1F82VIq6VaLgvzStsLpqB6Gk+V8x2aabWq6BsXePlISo2EhDHtBz+xwST/aYrUnxtF5KPm9CHccm+hFBSQDaf/WZmuBx12A3BV8zYXE7+SpaZqMpDCH55qGg4oRbbKwRjTT4mqJlV2GEtmwmGK9eyoaia6tTj8J3dlFqaBY4rIfrk094j6QWepGZCnMvOsdFkF/ydTu5T3akXyfwmMul+JiftFk1fYl9LDKvDJ+D3WgpPydL5y0AxM56iMmv81wCvBKxF1SRh5RthQtIyVfLXUAtkLkARPiBVMKO5UDAth/+u0hRuS9y/DXjbdV14JD8YW9cM2F3pWIkHs02nkIkSnqgk3S8g6hXZ02S5CDBmupRKEJLYjjeGBHOXSilidp8dhk9rzbzRwxGTB2rv1KKw8S7wGHOtRXo4IldvPRxlDI5m6F3fmhC/ZSfWnhfPp1OY/f6+jG1QR+x15vFr+PdW4fSG2ex6Ikv29CArRWXb5jTG/YqVa7pT3STFUlE6GjLpIU+eggQz465+BRvXR3+cpMM8U4yRHnGUkShQhtyX93yGKrTtH8xf5YSo17KQt2x6jeMZL+lYaxn2pupzkt/eVUt+tVURVpGr6X9ZZ7tO49RpnCm0uhXDmNIb1EZTkRifRN+z8Lotym2gH9bAkcaZNHHC2jis5g6SDZoZBSkEcucelndP20gLiuoplIq3vTMTSsYlfoghjeytGrq0eRwVh6irCA1krwkYdAYEYD6TB3PZsWMnzw+iZve8B+40qnt8WVJ2oIYRsSrPMfkwiVSzXm/2KVGL5pEsNlC9/VNc22Cloiw
 3kHZDWLx
 5Kg9dtmdtjyuxJgu7HNWvdVO6pD5pxRZT/gv9/2pi3JmXThPHWS2qz/63DY++BWb29OMmaWjMfNNCc6yiRxgZ5rnBZtUorwcdfZ5GwLIb8qbiwGQ3jesjaZLvMI+TPwvQJ6tckivkpdkVdiLWYBU6wDbiYRkg5SLzL+n6y5HJ4MLYRMFukpoX8V9ZLWrGmP52cidhkmZmwXBTz6Vx0aCuobI8mEiahA8wqPnOjQNSbibLYOKY09LM6ggWCIghLVZ6O9snDWndFpBAg0Gm2rP/TeiWuFRbR38YPtFIzhEmn+UBYovs1FYErOLzSCtWrIdOpHl7mPTw9YXCEpn2F53uloBHaIqnIphn7bwzxon5eUg/yO+UVkU2GlOqo+/2gbwV2lSX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 04:26:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> +cc Pedro
> 
> On Mon, Oct 12, 2026 at 11:17:57AM -0400, Zi Yan wrote:
> > On 12 Oct 2026, at 6:38, Lorenzo Stoakes (ARM) wrote:
> 
> > > [0]: https://lore.kernel.org/linux-mm/20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com
> >
> > No. Without lazyfree PMD level THP discard, the affect PMD will be split
> > into PTEs without dirty bit and the dirty folio is still discarded.
> 
> OK thanks for clarifying!
> 
> >
> > We will need Samarth’s fix for backport, then we can think carefully
> > about David’s per-arch solution for mainline.
> 
> It's AI slop, and we don't accept that in mm (also -cc slopper).
> 
> Somebody from the core team will take of this fix separately.
> 
> Pedro - you mentioned you were interested in this, will you send a patch?

I'll send something, tomorrow :)

-- 
Pedro

