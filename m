Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA23CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 12:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48698E0009; Mon,  6 Oct 2025 08:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF90E8E0002; Mon,  6 Oct 2025 08:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0EE78E0009; Mon,  6 Oct 2025 08:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE348E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:13:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48BCB87A05
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:13:03 +0000 (UTC)
X-FDA: 83967578646.05.6E019D3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 204F680013
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:13:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KaxO4xqn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zyYuS0fQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KaxO4xqn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zyYuS0fQ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759752781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbYTEVWJa/I0Jmvc9JTdtMIW4JnYonDMYg5KYJVrA2Q=;
	b=E28uVMu7FIIeMvyy5HzcQaksGCPvGkV2+lg3Boi8UDD/rlvu95dbjUK1z3bISu3wjcssYd
	lt6WNYNTAMPXWnLfy7S5BJ+xw8YGyGob9vW9cGtQ1SEuusyzuLygflTuJDoKoR5zR336Py
	sMOIL0SignJ8N9LnG7HoHtWieHwzy2I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759752781; a=rsa-sha256;
	cv=none;
	b=k3UCCYrWK7OcuEXmWnwXgth11vCzloB2jISRmuDkuVM3E7FLsAqGfskfc7RmjAKz+w3n5Z
	lciM9wdRH9H6sg/vIwslnV77WDDPdfL9WpiJLaxiqLW8d6nSw8m5bLZAukTVt914dq3quB
	rYIh75/uAAiaapZD95gkz1EFvUH8id4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KaxO4xqn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zyYuS0fQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KaxO4xqn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zyYuS0fQ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D19B33771;
	Mon,  6 Oct 2025 12:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759752779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RbYTEVWJa/I0Jmvc9JTdtMIW4JnYonDMYg5KYJVrA2Q=;
	b=KaxO4xqnk8T7RjnDrSaKFZtwPzUWS91zXISItIVOEkFReRVUA+YAhRjPv9b8q0dLV0EC6S
	IWkZ1Brsyd5gT373CG/0BzKcvN67HHLCmKMuWy3fd0J0u90nkB24HXsLoRFEss/DAgBiOZ
	MohyeHwvmyFFWn3Ua4KLyHgAS6LD34k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759752779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RbYTEVWJa/I0Jmvc9JTdtMIW4JnYonDMYg5KYJVrA2Q=;
	b=zyYuS0fQh6eA03WF7ObaJ3Dj9yYyBe+b37w+dllVFy/+FDZ+iD3vT1x00YIV9Dkg6l8ILA
	wfhHbDNmQqciymAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759752779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RbYTEVWJa/I0Jmvc9JTdtMIW4JnYonDMYg5KYJVrA2Q=;
	b=KaxO4xqnk8T7RjnDrSaKFZtwPzUWS91zXISItIVOEkFReRVUA+YAhRjPv9b8q0dLV0EC6S
	IWkZ1Brsyd5gT373CG/0BzKcvN67HHLCmKMuWy3fd0J0u90nkB24HXsLoRFEss/DAgBiOZ
	MohyeHwvmyFFWn3Ua4KLyHgAS6LD34k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759752779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RbYTEVWJa/I0Jmvc9JTdtMIW4JnYonDMYg5KYJVrA2Q=;
	b=zyYuS0fQh6eA03WF7ObaJ3Dj9yYyBe+b37w+dllVFy/+FDZ+iD3vT1x00YIV9Dkg6l8ILA
	wfhHbDNmQqciymAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12BC913700;
	Mon,  6 Oct 2025 12:12:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T4TMAUuy42hGcQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 06 Oct 2025 12:12:59 +0000
Date: Mon, 6 Oct 2025 14:12:57 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/dirty: Replace READ_ONCE() with pudp_get()
Message-ID: <aOOySfntnNd8IyGv@localhost.localdomain>
References: <20251006055214.1845342-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006055214.1845342-1-anshuman.khandual@arm.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: djqj3bruzygaycpzx7u85inzkd39ixxk
X-Rspam-User: 
X-Rspamd-Queue-Id: 204F680013
X-HE-Tag: 1759752780-439909
X-HE-Meta: U2FsdGVkX18pafSU6q6IYGRxcJ8glYUhKV04ZARm4g05JqbVsCl/sJh0rLNJejMc4uktmK3gJUFJ7w+b5OkT6641MbZT1RdevA59Z5fm2WuD/v1ofpm1+FO4ziTig6nQIFdJ58W1+O226gtrrBaLxeyGAEDg60wdQaQwVpec4/FpiuHph7xc+K2s201tvJE/pyPXP2eUBx0euUi26JBhyWi6DT1Gy9/KQwmNjvFaJbuXfBSN/E1HCdSP0a9d8nO65F8Fze3nPfqlXQGtY1fCA84SeqnEEJwplA7c5tISrHjOj9PN+HAvJEIcUCb9RAFnGIAL1YD4vNXj2sjUe9mmdWvateR1fpSopN1jWBckxYGSJD6ews2lEwn5Xkfxa0rJQKx1GWqDeGhIp+IxIr9SBbbdRcxZnPB25poYwmtqBFVY/npg0rcCOZ7+cVV/Tm3zfR9tfyF32+yeExnhBQLU6Sk8zJSandyfNIeebwdFzuo5Va5jFdDhAQdmKvJiekuelLwCFFFYZ9y+CMF+vTiD2JYHm9GUY0y6UshNkXFbDX4lnbVJvGrMAYLFI4cGxfNFrfZ5VRCua7QIGejnBnXPDCDcjoMwuk1YXc6AaXXIjt+o3TQcJGeb66z4ZWUZdnWZPUKuEiNS4S8Cp7m4nY4gqYGF5F2SjJqQX9LkXk/OVOmUc8rBzSipiAw1ymGYye727VicwgcODDFv8385ELWVnPl2CyfswO8ZSMSxSpNcAHnlROJmQKdTRh3GTDw+xAnWPJWW8GqWUy86AGCHaNvTOGo2Y/SBrVowgcbJMHTLx8GXvyUV3qHiGjPyR0MgQXjdEuQYlSvwyEy01w/mWTLojfOmQIYX0n+PKpyU+KOj9X8EwxaBzpJF68bdVSSJK6B8Zi1yLMJTujQTBqmN3sOV+06NtX1ceeG84CqAEDFIN6KV6+1ldvKsRVTt4HemwLVp4NPXeEwf232ahylJqdJ
 pz8EPFHv
 05iIBZ/zLhG3cwyu8+f6WmhZwyKOU8K/Zyjwfs4MQZVpu9ZlhAcRayl8YQQYg7bKQipghsq55ANE2mJs0ExNYlYH9ecpoVrlIMhoUdyvPYfVdTUVd3NsGS0aFxMzploI8gYkTw5am9j/pXbSXhAyp12DXgIG6zOqRmEVdIlDh1yhW0WGl5TQPZTA7PHW45BaXrxxBnIx/zMjlCksRu9IBO4OOEHKCxIsyDuvbhjE5D1fvr4cUfllbHn6VzXcUzfsPT3kvo0hnj59QNfrB2+lbdqTidKKptCDN6Vm5PHe9Q9/DkPqsgPHtbWGSGfychpJdWrNguUs18x83WhRtF7T4jZacK2BB+fkc8DqK1Mwab6Iv2DPtgf0te2s8QIZ/wgndL7u5/iowAp+FuGhXc26Fl13xu35ne27J5aUoODgQmVcakFa4WTeo3USGRUvNk7VMArzRRMunHSaB3e3pQIsEb/t9RAJ7gh21tS/lf1BkbHjhrIH0npa/EJPYBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 06:52:14AM +0100, Anshuman Khandual wrote:
> Replace READ_ONCE() with a standard page table accessor i.e pudp_get() that
> anyways defaults into READ_ONCE() in cases where platform does not override
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

