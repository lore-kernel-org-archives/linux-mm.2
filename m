Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E532BC44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF35E6B0118; Thu, 16 Jul 2026 11:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB1E6B011A; Thu, 16 Jul 2026 11:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0ED6B011B; Thu, 16 Jul 2026 11:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 935396B0118
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:00:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D82C11401EB
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:00:28 +0000 (UTC)
X-FDA: 84994950936.25.ED569C4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE5CEA001B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:00:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kpR6qZeJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QbuJu5cW;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vlV+wa1i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UgL2TXKp;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784214026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjvkGKuPJ296l1J1J3uCsSQ+DmnJfmCxvobbSXSn3RY=;
	b=FDW4Wle2TsMD/TZWKSf/FvEnUxOpU4qs/PdtCqTUAd8zbNCt5X8O7yhptOIkuV7eUP/2yJ
	bOAhDTAsNhHacYSlzI0si8lBmi42rP5BGYZpCYFWNnNjM94lvl2mJMowfdqOUaWsn5b5TB
	602XhXu4TFmBhV2mgEbG6LOS18VS5rQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kpR6qZeJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QbuJu5cW;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vlV+wa1i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UgL2TXKp;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784214026;
	b=PhNDW+HLnQpfpFbXaT22Wdmy+sAmBpQ6iecEcedscDWYg+jqfkrERQJd6kJihehNv9JnrB
	GEJa2eMV3JZHa68kxRJLBUw91Sqaj4lyRMGSBoYZKcmGP6YmO15SmLfHXkkhRtQJYe71jz
	1fXNCuLYyip6eullh1ZZPF1PwBNk3mQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 18348789D9;
	Thu, 16 Jul 2026 15:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784214025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GjvkGKuPJ296l1J1J3uCsSQ+DmnJfmCxvobbSXSn3RY=;
	b=kpR6qZeJnTWfFR5xq3HuUcnvmhUFB1z+KxOAtkBDXoEO0GGnKalTLFvidY1LuGitqQGyr8
	15wJnYrknaYuwCWtSEcBF4fWJ65LDm1OFZjDX2AWGTkchqLd1K8ufpJAi+/z/9JbAYLDG9
	ctrr46By/iIwLvlmjj2Gc+z9crLP6w0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784214025;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GjvkGKuPJ296l1J1J3uCsSQ+DmnJfmCxvobbSXSn3RY=;
	b=QbuJu5cWpxZqmSZN9YbystvcbDUxBh1PYRIldVg7ngHVdNIntESifKTkuw/kmLVMREzler
	X+GL1KTiPJx//8Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784214023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GjvkGKuPJ296l1J1J3uCsSQ+DmnJfmCxvobbSXSn3RY=;
	b=vlV+wa1ivQoGPbk3AQTEA5ZDf+ThRTh06m6oW6BEVZwIkYDM6cueF1j2E9b4/9DnZBA8lV
	Xzn4Jias30EC9wkHbqS+i+6MtAQ0MPNi8FKEFENUMaULMO9HyK8QeGXdHMZKW+vES3d0xd
	lWmP6QbNb3gkw0/dnq1icPyROfoz2pM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784214023;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GjvkGKuPJ296l1J1J3uCsSQ+DmnJfmCxvobbSXSn3RY=;
	b=UgL2TXKpq11ef3h1QHS7CS1zGkZ+Na/xDv1HfH0FgTBs6fyyonHEItDRJXI9CNoFKD07Na
	wjNy+ibhS74MTXCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08C82779AD;
	Thu, 16 Jul 2026 15:00:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EaL0OQXyWGrzYQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 16 Jul 2026 15:00:21 +0000
Date: Thu, 16 Jul 2026 16:00:20 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/mseal: remove superfluous comments, fix confusion
 around mm
Message-ID: <aljudrDILCC5KDso@pedro-suse.lan>
References: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
 <20260716-mseal-fixups-v1-1-3a9609bf041b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716-mseal-fixups-v1-1-3a9609bf041b@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BE5CEA001B
X-Stat-Signature: zkci9h63cebj7k169cz59t7h8bfni3mk
X-Rspam-User: 
X-HE-Tag: 1784214026-884627
X-HE-Meta: U2FsdGVkX19ln3gNAzd8zeAKqU9npyuolEuyBmlhNbeEJRFSal04CJDMTAwr2wTzV6U0rtqhzl/Gf/CNWGFxLkoaCOMHl3QV71us7/1LuTLPCZUH9JbUx8HdvZ+pcqkkUkzjTdliiOK8iCd7m2QhFTl696gLKHeckzEQlGrvLPucnLkxX0ZFJEVfU45KF//xaA+i40jQMXKVTixAoFGWJFdfc6qBcH18NBqpoBCURCPf7JuiQFT+go4Pieml/26l+3KdJlLuJmnmX7ybfg7NkOohuKftzZ7qkdK4tP9/YgWvghTyACK4In5QqTqRq7l8NU82R/C2bCElktfPJ8il6x21bApWZhVAFUpYd+jNHY/mucAsNEu9hdMSq8OkkqjS2XZ0VKlUsyUnZNgbnJmLPWpJvm2w5HLsgQRUlqpxZ2cDdPe6aYGh/IkhEsvwS2opWETQsYdb0vhETJTEt+SVoyHQr/TtMhsQdGgrwB1E5S/cu1PbjmCmkwmGjd/SlSpKw+m93jA7dcBlAAYvTMA6lZJgim161JYlTkXpfAiXuQ2Y9NZKL6J6N6en1nOugq/2X5yJXyPX5KvzwPlVRTU76ebYgGUjO27W6MNxb+LuF0LOnVoirhBusEkYk/E/WtWahbyGEm+ixEbUSHyPocrRAjSWrEH3M+W1MGAof2diuYJn5tjH7RVE2ZTXsPDCaDPn1JyNWTEgEET7iuX3Dmo625nyHkzC81l7/HDq5HB8K8h8QAiAivNPkN8DGGi3WDzG7nsSKjCNZcR3tUMkzZFJ+s1avjn5bYd3/NJI/ktZ8nl1de9ZtNLfA1VjebworcvCcY0BoustIWvFCxZVEuhGBIdDSM1xyUeP6SCbOd8JH9A6a1LbWVadOOkpm7wYAPoxN9gPjfFEoh10+qv1gQNB37OC3av64Rj/rixjKLo45v1XiqY115okoVvQvhUHwGcszjmCjJDL6N4/YXtjzoV
 GHF2jCwZ
 kMrJPN8+5JSEGRncnwe/2nSrn9xCXpWv9oVm156Jdur1Lt2SzAl8ADU0rlX2Ru7n795Yh7BrCWoiu0ax5L5m7dZgGlsWjyCca4fUZETq5tn7P9/feOrUfilgUYrk+rDP1kqq7gnxs1cWjUa3wqAdxoSqGHvs+eybp3eriQ2tgE2ZrufJxqkcFuwCvv+zKMOCEDhYgZ4WHUkmKUoxlrOq4qFiPguCG5GUplPJ2Cs2HhSb8ey2b+t8jsX/67BnqnNjjj54yZlIxIDTDpFCFwrALypVVykPQ9RGKioq1wqqjGMSulLQU4jly7sAynugK1Oiaf98p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 02:43:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> Remove comment blocks that don't add value and eliminate any confusion
> about whether or not we permit mseal()'ing of remote mm's by explicitly
> referencing current->mm consistently.
> 
> Also avoid ugly goto by using an else branch.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

