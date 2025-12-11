Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1F9CD41C15
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 09:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D27E6B0007; Thu, 11 Dec 2025 04:36:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483846B0008; Thu, 11 Dec 2025 04:36:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399706B000A; Thu, 11 Dec 2025 04:36:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D11B6B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:36:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C475ABB6DB
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:36:09 +0000 (UTC)
X-FDA: 84206684058.26.5A4D7B8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6B59A14001A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:36:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eXpc5sqC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z5CBQygM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eXpc5sqC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z5CBQygM;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765445767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqcjxDLPoWgnAdY5fHE96eGtR0YbRlHfg079oni54js=;
	b=RuNPMpDit2J17I2SjMi+WGPwWcWFdNe/GfVLet3azETgg0nxZG7KGgelPx/BerLmSUSzJ+
	z4e8tuJl60g9zW9TyWdVxv7AefsyFbpwa73Ss9HyHHTX3malbsaJpA70873rjwxIlv51HV
	B8LF/5oD9XC8rerr1udD8/IBczeIAUs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eXpc5sqC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z5CBQygM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eXpc5sqC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z5CBQygM;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765445767; a=rsa-sha256;
	cv=none;
	b=Y21PGEjoUZbDnj+A8H/otTRSlWiBqtMDsLKhUZSEZF/1z2od+/S3rHrE2nja5wAdIGOzwK
	QlSmEHyw9GA84qU46UwtHthYEkslaH1G3A4zwKEk9nbq/JfJ9uUOv4jC9qpQcoiDM/MMQa
	0tIu9CPNcAuFgQGwPEwfKyhWI3j5VkY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63AAB5BE4F;
	Thu, 11 Dec 2025 09:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765445764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JqcjxDLPoWgnAdY5fHE96eGtR0YbRlHfg079oni54js=;
	b=eXpc5sqCRLyQHJmWkw70JvrazPrAnL9rUGP+hbUfRlOYV+yLNCEUoGhEWMSetiUSk7H/tb
	MIvlsH8lmd/3EZUutXLQhS9jaSC39C/exT4bclgwWM7USu7fAgOlcT1LYtND/PdXGfQFBG
	3o3RT6FsJ/kePy2O9bnrk7xlN8+6fR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765445764;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JqcjxDLPoWgnAdY5fHE96eGtR0YbRlHfg079oni54js=;
	b=z5CBQygMaK9mDztcMgi6J+Rk1lE9lobHxmOoC9NtWZA1Aj0Qlqzfr/yIsuydiX6L0EYNZ2
	GUtXlD90xPDWiNAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765445764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JqcjxDLPoWgnAdY5fHE96eGtR0YbRlHfg079oni54js=;
	b=eXpc5sqCRLyQHJmWkw70JvrazPrAnL9rUGP+hbUfRlOYV+yLNCEUoGhEWMSetiUSk7H/tb
	MIvlsH8lmd/3EZUutXLQhS9jaSC39C/exT4bclgwWM7USu7fAgOlcT1LYtND/PdXGfQFBG
	3o3RT6FsJ/kePy2O9bnrk7xlN8+6fR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765445764;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JqcjxDLPoWgnAdY5fHE96eGtR0YbRlHfg079oni54js=;
	b=z5CBQygMaK9mDztcMgi6J+Rk1lE9lobHxmOoC9NtWZA1Aj0Qlqzfr/yIsuydiX6L0EYNZ2
	GUtXlD90xPDWiNAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F3343EA63;
	Thu, 11 Dec 2025 09:36:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zzEAE4SQOmkbAwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Dec 2025 09:36:04 +0000
Message-ID: <84c222c0-daf4-4135-9f99-6edf6601c92e@suse.cz>
Date: Thu, 11 Dec 2025 10:36:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcontrol: rename mem_cgroup_from_slab_obj()
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251210154301.720133-1-hannes@cmpxchg.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251210154301.720133-1-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 4zy663xggptjw8681qhxzroo4t3fid7d
X-Rspamd-Queue-Id: 6B59A14001A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765445767-198344
X-HE-Meta: U2FsdGVkX19uqt2bPdBdVCmpACLQB3huSh9suYo6IMUAYExaEjKk6Omu8UnLdWBqNrowVdzSTr23da07zh5qoMrrT65tGpoNUjG8lGoU42qu/TGU911q1lwDHcfONJfhqGe0Hd/tiZXuNucFgh/vtib/O6XKu2Uwg2/zyQ1E99foVTBBlKFXnmCM6Gyx483rJTEYXSHa8G7FCseYEXGEhwclGrR2fuG0E8KDe4uOinWDO0okRR5UuxYXXEdGSD5C0hK0XDiC52qRiOGHhYckVXAUCOBqO0qh3J9uoUg/zy17J91Nq4mPJMnPDvl21Y1e3+cwTwq8N7zPBUdHhve5PwBHcKb9xxsLG6X9j2AvYtKdaKAS8axLKxNh/izBfmDBFtfJLqDhp8pqk1NBApELehif1wwdxFnHKaIuB+WyykBzu0+sAEwM5u/zjk8hy+oO+7Dpce0Ve0m5W1TRdrP9AunY0iduHJs8Mp5wA0WuT1Fho6gLjeWsAD0RTdOJsjz5ZTmAhOiCapsS0U528uNEr37vVTlU9DWip73GS1eqU5U7Hx91qjMWCNaIVWnwEvTmW32fJ1SCcII/ctmhr1tn8WnuTDW3WgVLDL6yJgGGZ9J8Shnydx7YpfqKgiAfd4uoLMsWVcLUkSz7SU4BDRr1stfuXb83Gl8rQIeCfx7bRKQ7SSF+2P92iruU0bM3oIE0JX7+bGe2ejP3Ncyh28wPynaK8wDpYO3GR9T2gJBbuFMdNJEmJKS3qNcL1O3BFDyE8RgeXETDS0Y75agoGxjpLYEqBvYdE63Z4fTG1d4GdBaq4Ux5/kygJuWwXT129kpocceViSauQhPv+ecvlFICYn2hSTKydKXEC1hpswkQ61zwUhrHknltITMCOQopEqkSdoi7dNkkAUOHq0OhMRWUWfYXnBgnoRJzuccwAUUChq8J/C2KbovUc6D/vSBkpvT11TCLa0KjsXmPXTcAJjR
 dccgQfI2
 0IW6hh5HpkkB3DkJFzWmyhLhKRsgqvNbL2YWWISnx6I3MlQiD9G0QahMuF/hoO4r8SJ/SAO3EtWGiJDiqSjMRGxKL6czRn/1ZtSjXlIrV5U1X5lA7xzoAGl0SewyO54+riSWHULVXXEHADB1tzZypu6SPXFK5c7FXmI5tykkoYyLgsfdhQxHX9NFG0PDhWH4TjFLUG7k88osZIYuOoITx5RqCVexzXBq5FFhs+9ukpIHgBWMpbaZSW1D6bD0/+yWohcyRBDc9DjHXL1lqyocKwaIYTl+kMiUka1ADqmU2hBFINfnRzoVRj6qB/1iF3vDNwzevJhHU9MIu77kBj130HoAUt6WbgQivXCqgYGcwGcrg0822cIbg8Dn1fKX+RPVxuc1ime9SapaNpTYH6VyYFDrC+k4gU9AjJd7A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/10/25 16:43, Johannes Weiner wrote:
> In addition to slab objects, this function is used for resolving
> non-slab kernel pointers. This has caused confusion in recent
> refactoring work. Rename it to mem_cgroup_from_virt(), sticking with
> terminology established by the virt_to_<foo>() converters.
> 
> Link: https://lore.kernel.org/linux-mm/20251113161424.GB3465062@cmpxchg.org/
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>


