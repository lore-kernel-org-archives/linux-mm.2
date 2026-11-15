Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19302606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=l0FofxsE;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=uC+Qn4yw;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=r8H5tXPE;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XhxLpZB3
Received: by kanga.kvack.org (Postfix)
	id 0EDDE6B05B1; Sun, 15 Nov 2026 17:20:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E776B05B2; Sun, 15 Nov 2026 17:20:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED03D6B05B4; Sun, 15 Nov 2026 17:20:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C61D36B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:20:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63B5840875
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:20:05 +0000 (UTC)
X-FDA: 85438772370.27.ABD6A68
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2E8E11C0005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:20:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l0FofxsE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uC+Qn4yw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r8H5tXPE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XhxLpZB3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794781203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3rAtedktrSwXVekAFGPioCnjnnEo6sIvs0uSQj8koE=;
	b=4slKylomEV1AsNcS5FgiM3k2oTj9UlqJqYwtp1/7CgXI89P9tbv9Ug6xHPu5RegitRrkfR
	kpPZBeNuXQ5MOOYO8yAYZ0eHB3i9rl+KNAknBFsJ9m9ts6EJQF6L/gdYS0ndlp9Vu51Z97
	eInv3AXT5Tw93Q1Q1cvNz+pTd9Td33w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l0FofxsE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uC+Qn4yw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r8H5tXPE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XhxLpZB3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794781203;
	b=x4fIbFALNA0nYYWahfaMKewpAc6XA0zobk3Cb2LsaJU6Pewu53r95W5HCiTS6Yap9pWfld
	t9rdUrf9XZvSG7ahcIyMT1AzAIUGeHuFslGfYNOO2fwsaD96EjW/vILVJhA0i3A4vdyFv/
	zBIore4y8LhAalQUeXnMMHy4NQy15Bo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2320F1F453;
	Sun, 15 Nov 2026 22:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794781200; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d3rAtedktrSwXVekAFGPioCnjnnEo6sIvs0uSQj8koE=;
	b=l0FofxsEj7ZfE5jdC8pSPGeEiJJBaKymA4HRl9c+CNaG70rfjcdrQH1+vKsjEukB6864z8
	kCVVWURXjil96kZmgY4K4F6IhtBZELjq7qZ4NneOaNz/q1RDRhljcIy8XjPyecEnHduvYX
	GtRqwwAvJpzaikJtjZNlcIC5jwdfsnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794781200;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d3rAtedktrSwXVekAFGPioCnjnnEo6sIvs0uSQj8koE=;
	b=uC+Qn4ywawI31ggkR3nxBg4KdFBGSO6u95J0oXgJ42zKn2UElFjFNmgN41BHBkGdy7OZ7Z
	rFtdTHKyzEB4ThAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794781199; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d3rAtedktrSwXVekAFGPioCnjnnEo6sIvs0uSQj8koE=;
	b=r8H5tXPEcYAOEhBl0gVbqRFO0u40h4FsQlxVnPfSqDvfh5vBc3KiQmfTQrCUgm8yOdiMxr
	+RJUA+zY3qVDXarEuqD9hlGqn5v2EpZWlePta87ucCAzGVVTmABftMyln1tlanwZXcw48b
	SYeey9qwqhzcjUds7EVfs/4QLgXplcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794781199;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d3rAtedktrSwXVekAFGPioCnjnnEo6sIvs0uSQj8koE=;
	b=XhxLpZB3Izj3+Sqc1fD3IYSg8BD0r3TCwNIGyJxkHeFD6TeRbep+ifEc1VkZSK6j/fzFlq
	nxF+ZPZgnRZ35VCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E34F5134F4;
	Sun, 15 Nov 2026 22:19:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 83EDLA0w+mrmBAAAD6G6ig
	(envelope-from <clopez@suse.de>); Sun, 15 Nov 2026 22:19:57 +0000
Message-ID: <749a4a86-5b7e-47ff-a6d8-d885354dc68e@suse.de>
Date: Sun, 15 Nov 2026 23:19:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] KVM: don't zap secondary MMU on permission upgrade
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org,
 seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org,
 david@kernel.org, peterx@redhat.com, imbrenda@linux.ibm.com,
 borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
References: <20261112142039.907090-2-clopez@suse.de>
 <avd4MOhiTCw0I_e1@gremlin>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <avd4MOhiTCw0I_e1@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.50
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E8E11C0005
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: fe3ozb67hkw3kptjkg18zmryoyy4hxjf
X-HE-Tag: 1794781203-195762
X-HE-Meta: U2FsdGVkX18wOHQxGiHSMrDLv1oCXwgw6UzPoLsECyLT6ICI/mzJgigBPGNus6bVlbtWxJ2mGivXkOMaDrxhoY6EwTRb9bQlwpe1sVmv3RsUgF4MiFZ4q/XhEoKJY2c1F2F+I4LreFnUx4peTNx3yK3ueAa9u1ZpPWU1LCK6r8bS4YhGMykkJ2Nldp94SrrZa+bpt1OEWJ6rTbHWfEkcq33fuk1KUtWRz/qD0kx3GD9ldkdDy/47gYp3l9DZWKATf8tlUYCGe51p+kQrP2v7rYvUVFe3G33GlXmomLIhhZPJCXI1Fq2SR/UXal7LuzxtV6w+1F1NKwLlrXnLKUbrXzBqyEc186bFXDnkYE0yztwSuQ6QaQ3dpduVuq5yNQglp5A2gsuNgbfVQN+pyUhH6GAjbtQ25e0Bo1+nbJXBn2kvwfpknKJm6PJP/7eU8A2L2ksQayZii/AOXs522Qq/1x09DGWXnjPThW7787hvgYBVIimNVWQ4S15PwJqPrFaRitTwcpl77qoQyp64QhlP/XsYigRu/9anh+UgE1v4YAtujEwXUfbdCgUIgeQuRtzuQuRstpwPKReulu3J/btXHOOzr5oBCanNJaD29tPaMhaQ6mv9O8FPerCNXYfC9LGw6JkXUoTIkBF+9OJp2neR2pxlm8MsA+MCqU8paFUYr65XNr77rhVw7VTn/vN+sfLpdpMn9cFa90+ggK9ombeMyABHlOePzs8idzKxZCR3MmKsjIiO/kOPQKIf6NpVXhQUA0iir4GVUL6zaUSTBCzm53T4Bo+n13pPRmq7rf3iCGW8lg5VTk3nv3ELiJLS18l5mqvwmREQdvO+4yBdNWx6MZvLlKvoQNhTexFvaFRuO6ZvRmdtmYVQeisbYKDN5a32lR3YrRMA0Rq67H8YN6eiutUiI/JtocNEGWSJ3Xq6JMvfdv3V0h5iQWvZPGRI+spQ9dnqhvK0bVvGrhKx4oG
 ciT0leqy
 8OuuG6DerzERvDTPr/wqdISmNGX//s4t0/nmzcrlMmEeS+4q/nDw7iIFPVvcDfm5mUr/B7j3C1DhzbvlvktBP+BeLHgPb719Gp5DAM5gwF3SleUqLeYfdG0Nmne/2o1ndCt5fj79jlaqPo5Dx4xO3e27MAcPy7E8dAjifSGm2OFVh+E8L6OIfbW0XkbWG3KHPUmTG0G4R7glxze2rWK0t9H90JfCck7F/WfaHVWhnCkKCjrmJAaiM9yykYXOCy2kd10CzReDry8PFuBN+x+lOyou7hkcjxHDzQwQrVSLHGhqo1ZLhCquVG+j2AFbuv1Zljol4Wuoq73E7o78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 9:59 PM, Lorenzo Stoakes (ARM) wrote:
> Sorry but as I said to David I really question what you're doing with this
> series on the mm side, and I wonder whether we should even consider it for
> this cycle, frankly, given [0].

I was not aware, sorry. Considering this, I am happy to wait until
7.5-rc1 to send the next version.

> And, myself being the fool who is engaged in the Sisyphean task of
> converting VMA flags everywhere, you can imagine my delight when I saw that
> you (seemingly quite knowingly!) chose to abuse that API, writing code that
> I'll personally have to rewrite later.
> 
> Don't do that please :)

I was also not aware of the ongoing effort, I'll use the new API.

> Please also do not keep respinning based on sashiko feedback. FIRST get a
> clear understanding of what maintainers want.
> 
> Sashiko is a bug finder, not a reviewer.
> 
> And see [1]:
> 
> "Wait for a minimum of one week before resubmitting or pinging reviewers -
> possibly longer during busy times like merge windows."
> 
> Please only respin once a week at the minimum.

Understood. For what it's worth, each version went out about a week
after the previous one, but fair enough, I should have waited for David
and you to agree on direction.

