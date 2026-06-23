Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D65FCCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 15:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FBBE6B0093; Tue, 23 Jun 2026 11:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD946B0095; Tue, 23 Jun 2026 11:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776616B0096; Tue, 23 Jun 2026 11:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1066B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:37:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A22AE12055D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:37:38 +0000 (UTC)
X-FDA: 84911582196.04.9127A14
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8F30C100012
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:37:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qYvQlaXf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Wdne8ZXC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MxNgs3U8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Vt3iRckU;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782229056;
	b=2dmGw0yn0fWUrpDPWd7VUUvj/tlrQVTGeL9OVAtDOMBOdNZX5x4ApFFoGdfabfPZ3XHo3X
	+uIJ/aeFJueQGu1xZ6L6Yh6xIbve6kkBHf1dmvoirGrCHrCTL/d9f55g/X3s13Q5KkrkkJ
	1xpLr/UKG4F+JJIT3rtgpB+eY8iE/fA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782229056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiD1HDzT0dAVNzQtD4cPBAiA9o8xQG+2zp040/DmQ4c=;
	b=v8N0nQ+ziGqPiNQ/C61uOd7EI9QdJfdacAcT0uk2OBhPn9W+bBsEdyrlImcEtv4xGWPkKv
	CMntrgC0QA0skN+vqDuizTcar+ox+1CfILogJ0HYn89OWvpCq+hmpjhFRzfEDsLfpOIB5c
	ulvvdmoTaSNi4W7kVz1Vj4ANJKDh3U0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qYvQlaXf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Wdne8ZXC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MxNgs3U8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Vt3iRckU;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E0A5D75B1F;
	Tue, 23 Jun 2026 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782229055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SiD1HDzT0dAVNzQtD4cPBAiA9o8xQG+2zp040/DmQ4c=;
	b=qYvQlaXfnfRFEt9oMsm+il25gqZd8o49PQiAtlBJuSMCzEqOhxI+iijeV1Cs8zscd1o1Iu
	43mq9bhdPkWl3maZ44/wgqik6Wu1b+i/UzWaJoDBaROo0eGXyE5nehr91OnRvl3QH95oB1
	oq0tp+oxevsIS2/bwomlM5Mx/akUVlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782229055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SiD1HDzT0dAVNzQtD4cPBAiA9o8xQG+2zp040/DmQ4c=;
	b=Wdne8ZXC/q07bL7Q9etkSilv8y7VoyO81suWnLaiMrbjkw4Q6+GwCHqKep/IqXoPJRammq
	4ep4zcp9u7mSFUCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782229054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SiD1HDzT0dAVNzQtD4cPBAiA9o8xQG+2zp040/DmQ4c=;
	b=MxNgs3U8wRRMXGJhgR3vi5K0NnhqIefh1FxtSITOJi8/sxn+U8ghMzQp0aetcHDxQMUBev
	1G/nWhGjTUziGG7p5eOhdjKSTeyIlxZ46Eeeg1jub6LLNiSFyfC4eb3hE3tHi/xnNsmW25
	ESVHCKRQJiE53sHQhAQp2qiPjRb6r7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782229054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SiD1HDzT0dAVNzQtD4cPBAiA9o8xQG+2zp040/DmQ4c=;
	b=Vt3iRckUuMYsknVhBk3Z2rCrmb/pET5kYAvXQomN1TVMkn4FzApO0AFwhnByeXuJ/fGeCj
	k1uDBGqCO7xRhbCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A96D2779A8;
	Tue, 23 Jun 2026 15:37:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qVkJJj2oOmoLcQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 23 Jun 2026 15:37:33 +0000
Date: Tue, 23 Jun 2026 16:37:31 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	liam@infradead.org, ljs@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, vbabka@kernel.org, jannh@google.com, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, david@kernel.org
Subject: Re: [PATCH 2/2] mm/mprotect: drop 'sub' from batching context
Message-ID: <ajqoHiUc28tcfm7-@pedro-suse>
References: <20260623125723.2503832-1-dev.jain@arm.com>
 <20260623125723.2503832-3-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623125723.2503832-3-dev.jain@arm.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8F30C100012
X-Rspam-User: 
X-Stat-Signature: eghjm4hcquwusj7fexzgb7kae1kbaen9
X-HE-Tag: 1782229056-552033
X-HE-Meta: U2FsdGVkX192SM5D2Z3c1NBbb5RNWyO59PnJjbzT8ol+CgzgY6+Z94ZjVmQBYa4AlWAIxoMEfKSHGUZyZibtFmnUI26lUEEZji5ihch43Bcj5PwgY76KMZfKRwRK5YNtQH88o+2ooed49svEAB0jzY6XEgyRrsULiFOBpmLPHguo6vTo6n/3KzP7iOxRZPBguOTeMLDO1X9M2mBmKh5knL2S8raC5TPWWHPqgg1F2Pvs3lE3gPdyePlWPwMMroGYaiOdGI9cuAHwZWVcN5sSP1St15XATj8vpgshxvJy7161AfthJOFyJGXMdFLnPuZQjp9FF8WiR08thrTmYqladqhHJ4tW9bH2lYah+dOiIh4+NfY2HFxHHJsbAST5YPS0MdrlwLaWrCEUTGoa2V5RWRfgEzJgssvO/dWtcXyc+SONvmMLGWVYkvpvKChkW/Ik7N5iqQGYvhkzoMXDOyWbHSy6VcMEwW98cjxFxB8W5awi3We9WLNDDph7q9TYStDaGFkOvTTHPRGZUpBsswI3VKKJKtq87x407KxIJoYTl/mdOi4Qs3BBM1ALm6HYEUlhNpj6AelK1IWD1Km6RLUJG/nCcocGP9O6en91WAwFCZ1gL/FofLaDzxRUpB6MIkTL9fGk45proWg7a4fcTF8Nv9zoCaB/qf9Sr+cLlJplgfRR4mIevXP5uZ64XQ60738BwCdZXPjZYyN3Ar7XCzywPFIS9HZlOS+0YEaQ9xKxwlqSicCovHOgU0o+dR8xAEgTa6J7+DKE5LXi8D313fCDBO/JgtRl0t+jn7UCuHRvdDoMo+YSiPeNejn6ALAiSOJIo4pUIfJJWmIcPpfGLipTuNF/EgWcjOhTnHL1+CiVHmz4AaF7wmOb1idKzr/EkWrNCfpc+pitllzT/VqeZKlh5PgSomu79cxZe0M/CpoKR7ugTAJynomRytL872zcfnT/lqJMWRQ6LlRk2fJ6EQB
 gteIwNmz
 wui4Xq33gMHGOROxOkdcWj6as/bN7jD2x9g6JbeWrVbmy3ln4LYstMw2CTkaxzMg3vezcM4VEh0hjlAYKIZq2BeDy7Umttsxpeiq9+sC+j/LV4Atq/TCJWjcKQ5ZTjFyliN+WRlv7aRV87+au9+rRutTvbp8y0ib6rM8LTCmYdJy8384AGqsLWAIedjAfTn8LSfhefJKbjPedDCbeqrmD5VeNC6/NW0+nkakkqZ1fmlaJEtfvicdAmu4F0rpHSLQX28xc9yPr8it9wj5LCQXLqIHzPN3eoESHjSK8feAhX5qnulBMaR80+6Zmk2dODKQrQgmQow96oHgKprTnSdMYBqewqgLaqGgOZ35NgEkRDiO91HA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 12:57:22PM +0000, Dev Jain wrote:
> Shorten the name of page_anon_exclusive_sub_batch by dropping the
> "sub-batch" context - the function itself doesn't need this context.
> Similarly, drop "sub" from sub_batch_idx, it is unnecessary and the
> usage is clear enough.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

This is less confusing, thanks!

-- 
Pedro

