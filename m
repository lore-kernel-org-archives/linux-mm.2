Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65915C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01AE6B0092; Fri, 25 Jul 2025 10:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2D36B0093; Fri, 25 Jul 2025 10:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA15D6B0095; Fri, 25 Jul 2025 10:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AC0196B0092
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:38:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52DDB1407BD
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:38:53 +0000 (UTC)
X-FDA: 83703043746.05.CFED487
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id DD02A120009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:38:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IqDqvDCE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vQuLa+5V;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IqDqvDCE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vQuLa+5V;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753454331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7j7wE/OfZbMC2OGozrK6OOwR2Ig1tNfirhTxU/cEnuY=;
	b=ALfoM/ApdTgOeHxUcIA6JuLZPw0cdN7PPWuditDSE7m2ottb5h/2+YzDBfs8YYtykU2gpE
	d+uJPeDGbWYKyaD7LJOpMXR1t5QGIMgDWcZvHPqbv3JhFNPB19BkSGIHsTCAEeI6zul+38
	yXu9ametnDgc56glgncIG8jT7Xab5s4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753454331; a=rsa-sha256;
	cv=none;
	b=6r1Kha6AePvWp8Kmi73SsyuiCxJcoglhhKZG0se0L5WeGNQOb5gNL8fD0EmKEbIk/OdSHB
	2ZTD1RPN61Eg0PIcCxEtuO5EirvU2JepN8S/QHgB+MePz52cAc/cpZIQUVWpjdG+AJWn8c
	BDYfKyiKXqkaJQ3LO27MaJETPrRxnsM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IqDqvDCE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vQuLa+5V;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IqDqvDCE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vQuLa+5V;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 22685219AD;
	Fri, 25 Jul 2025 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753454329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7j7wE/OfZbMC2OGozrK6OOwR2Ig1tNfirhTxU/cEnuY=;
	b=IqDqvDCEh5Y20kbQo7Jq5+xsSJOcpbSE/S5thDMdDeJT4eqR+P7rTvgj0O6RvsHq7qNQFc
	qtJCN1WZ3C9qWDmxfSXT84P3BMCt6weAGOrA10R5P3wOlsdLFifKNHEYITKjh4vtl3NakE
	oN4sNLr9MWEBaxDjFLiLWNI8Ja/+c1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753454329;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7j7wE/OfZbMC2OGozrK6OOwR2Ig1tNfirhTxU/cEnuY=;
	b=vQuLa+5VDLPu8N/TbNpCWcuhglzSV26ix2Ni+TF+cTkzNO51yVJpPrrtcu0fU0iTdRyqGV
	8OI/4x+OWgob+vCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753454329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7j7wE/OfZbMC2OGozrK6OOwR2Ig1tNfirhTxU/cEnuY=;
	b=IqDqvDCEh5Y20kbQo7Jq5+xsSJOcpbSE/S5thDMdDeJT4eqR+P7rTvgj0O6RvsHq7qNQFc
	qtJCN1WZ3C9qWDmxfSXT84P3BMCt6weAGOrA10R5P3wOlsdLFifKNHEYITKjh4vtl3NakE
	oN4sNLr9MWEBaxDjFLiLWNI8Ja/+c1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753454329;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7j7wE/OfZbMC2OGozrK6OOwR2Ig1tNfirhTxU/cEnuY=;
	b=vQuLa+5VDLPu8N/TbNpCWcuhglzSV26ix2Ni+TF+cTkzNO51yVJpPrrtcu0fU0iTdRyqGV
	8OI/4x+OWgob+vCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B792134E8;
	Fri, 25 Jul 2025 14:38:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y8ZxAvmWg2h8VQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 25 Jul 2025 14:38:49 +0000
Message-ID: <3877d5d1-20e5-468e-896b-0bbd54a198d5@suse.cz>
Date: Fri, 25 Jul 2025 16:38:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: remove mm/io-mapping.c
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
 David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250725142901.81502-1-lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250725142901.81502-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DD02A120009
X-Stat-Signature: 3ussy6qjzgt6ygegastht3c7xw1m5sz5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753454330-563344
X-HE-Meta: U2FsdGVkX186PMZ5f7NcsqJHWy2ujTweZ01Lhlt1fstZ4ndLhXimQL9JhrxdOwETLWFV2bPZOgz46mRr57VPh1/Ps2kCmsrlqq+vEY7EKeMdZH+UWeqjQMaMm8iO1pEVK73sLbacUdtXHT5ZdMpB3v8PqH90VqgZiNQAN/AoSbYZYRk+aIOUbu6szwVG2OZ6xGhpOu6tNYo8Oqka71zmQJpi0bJcYlYM0vS6VwL406kETcE1BdlueF5j5WL6jMA2sv1R+ZJPeKboqjsKihkxRKG3YHOTRb3aKhGz6j4Sv679skovtCgBs6jMk1KPi4nw0+ham6EhKpOXRdMk7JAQ2vfqs2GSAWywYvrAbMM/rDEqqfZNQBOF60gbpMCQc+QOjL8tewRoly49aWFHCWMerHyUe7vJ25B9hl2MD2zdL8kFEWxYD3Rgmka2eVMCwdKTrvVMUer98LtIdUDw6JSfVEe4H0VHyP1lqqiEEXHMp2JcIaB6+MyBMajjgSX3tPB92AYOrfLnUWrXcSROb+AaETsgoSKJ91ijvghG8Vn0LBP6oLEHtlEasfFavNlj/D3StWolbhBUtC6FuYVgtgcaRSLakADCXovpUwp9zRbRKvSkSZxGXJgp7ifyVKjTfmzXB53uha8KyRFdZKRHd0jf56/mpOKcpMC08Is9tTtBfwF+ncDptVTrv7ypYcK++JVLbqmopCSFM2LeobVrIF5OAzuBNm6XqyMjdsgxk5Vi7nkamQnlsAlSRzkZwiJJ5Yabbykb979SuhX/XO0cSewBV37XKkg7fyQrMz0Aj+cb3SPsx2wqp/mUxqO+TEHH4FQIop00t7bCFH4U1HO7IzRH+ETYWwH7YXW+G8myrgcF1XaMxZ3XAD2V8Nx6Sl20CBVt4rs3A2zTurk7BggURVwGad3mXAM5sxujcJA6uPNiP0YlaRHGxB2QP3lzsPamIT7W97dcEsxt8IaFAisrQ4m
 ID/OJ1Tz
 RYm7lcqLStf69f/WFO64WjqtxSjY8Ho51pRp3jX+POFTWg6nddR6X8Ea2/fxLGdik45NbZM3UjGnr84Gz0maZ5chtWYRjUvQaPIK9nbk4s8QcHEOeMSHrBt5QLSU0FY6R7PWh29BtBECBAGsCx5k4tKGH/en+6ydRURbqb5IUI+rtFKG08A7ynM6zr3UmthZO7ggQcWxn9hsEM3Wj3B3vuyfgLUwip6xW1bve/8VmowNm6f8opCZi8wfnavNBJoWzoVL3xu60Th+bN87nAZM4KPl/GjN5JKIcOWJ/UgBo0AdlvW19jETL/jrn0iXUq5GqwpjW3SMRgbJt9Ks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/25 16:29, Lorenzo Stoakes wrote:
> This is dead code, which was used from commit b739f125e4eb ("i915: use
> io_mapping_map_user") but reverted a month later by commit
> 0e4fe0c9f2f9 ("Revert "i915: use io_mapping_map_user"") back in 2021.
> 
> Since then nobody has used it, so remove it.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Think we'll need also to remove this line:

Documentation/core-api/mm-api.rst:.. kernel-doc:: mm/io-mapping.c



