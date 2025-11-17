Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC95CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654DD8E0025; Mon, 17 Nov 2025 05:49:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605068E0002; Mon, 17 Nov 2025 05:49:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B2F8E0025; Mon, 17 Nov 2025 05:49:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9A88E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:49:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7124C0596
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:49:56 +0000 (UTC)
X-FDA: 84119778792.30.D25B759
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id A17EF4000E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:49:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KmFLLsIu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5jnpOrz/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KmFLLsIu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5jnpOrz/";
	spf=pass (imf01.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=jdelvare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763376595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PnDekxF+6Zg9WJI5fWGwJsM9wHC/bJf0Iga4j4Nj3CQ=;
	b=QWEQrLjOZUi+Grvb4C9I2LwBC1gVBNJ65R7ZPE6pS1tWrPfuVLPO8DPNOxiz3xg5Ok+/wr
	1iMmZCgOW33ejpTFQfM+Jh+FSZIQW1MOGmq8CDiXp0WnLCxyqathLCFJYp/Utyaurb5jZ/
	HK1/le9CGLcPCDlZgLcs7fquOaOuIQw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763376595; a=rsa-sha256;
	cv=none;
	b=8jAknsIQBik2XKkjb6/ipiywp6R++tPg309Y4iq0VpZKmgBQO5VwkNf7R4N0s2At4sj5JK
	NTOs7wiX/hADsT2QwVvNDOWrzO7s5yhOgVrKltsdU8AEWujLSSFbdHHVD1xQ7StLJqV6wE
	P4NqvhuIdASCYt35RzQsvuT4MAdRz+o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KmFLLsIu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5jnpOrz/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KmFLLsIu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5jnpOrz/";
	spf=pass (imf01.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=jdelvare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C8E3B211E8;
	Mon, 17 Nov 2025 10:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763376592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnDekxF+6Zg9WJI5fWGwJsM9wHC/bJf0Iga4j4Nj3CQ=;
	b=KmFLLsIuqRO43EwLLMBPRBbvgLmpXal27XCYCj9ROMmW+iPqH5fD78RlRLlbOzXjkQ6qsV
	IfM5edBGOIX+52uUc9UVknI1tn5iIkUW3ZzwIawTwjOqxMu0RFqRb3PSccBKHKEPehjg3g
	rxrZUf5ycIROJcSk2cwxHvNOc0JbFMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763376592;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnDekxF+6Zg9WJI5fWGwJsM9wHC/bJf0Iga4j4Nj3CQ=;
	b=5jnpOrz/gXlokEYGj0IOCCXXrhDCHftXI9Dvdi/oG9L8DL/qwhX5eG+1tnkoWcXwPEpWcJ
	rDF9Xca+Wu1bsKBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763376592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnDekxF+6Zg9WJI5fWGwJsM9wHC/bJf0Iga4j4Nj3CQ=;
	b=KmFLLsIuqRO43EwLLMBPRBbvgLmpXal27XCYCj9ROMmW+iPqH5fD78RlRLlbOzXjkQ6qsV
	IfM5edBGOIX+52uUc9UVknI1tn5iIkUW3ZzwIawTwjOqxMu0RFqRb3PSccBKHKEPehjg3g
	rxrZUf5ycIROJcSk2cwxHvNOc0JbFMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763376592;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnDekxF+6Zg9WJI5fWGwJsM9wHC/bJf0Iga4j4Nj3CQ=;
	b=5jnpOrz/gXlokEYGj0IOCCXXrhDCHftXI9Dvdi/oG9L8DL/qwhX5eG+1tnkoWcXwPEpWcJ
	rDF9Xca+Wu1bsKBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A4D63EA61;
	Mon, 17 Nov 2025 10:49:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W8/JH9D9GmkUXAAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Mon, 17 Nov 2025 10:49:52 +0000
Date: Mon, 17 Nov 2025 11:49:50 +0100
From: Jean Delvare <jdelvare@suse.de>
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, David
 Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>
Subject: Re: [RFC PATCH] mm/cma: Inline cma_sysfs counter hooks
Message-ID: <20251117114950.73c1bddb@endymion>
In-Reply-To: <20251115014810.79376-1-sj@kernel.org>
References: <20251114110301.39316246@endymion>
	<20251115014810.79376-1-sj@kernel.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A17EF4000E
X-Stat-Signature: bqa78mhm5x35t7asg7kc4f37e3xhp9i7
X-HE-Tag: 1763376594-580896
X-HE-Meta: U2FsdGVkX18/hntlcXVQfin5TsWNTeaIK04tbMlKucEQ2CVYRxQRVUrunCgnAr8zNmcc8lyjG5IOaa/le68Gyi4D+jN62gc2TBMaRb5hq1+9Zyx05por8AURZhBYWbs+c1YLsG5o83bivdF2ZTQLrbHNHV+Kl29+94CIbdNKjg3z9CiM82317sb9DUV7BDajH5G6SWMFQn5W/31WNAIKRs6HOUZCGplb/xnmUsyNxCJnpbYUMgw+v1vHk04qU8vjxyAkGIDYXvwaPq9JPVSmiM7it2ALdfVQZyY4GVRZjCuEVB/iJzxDCZlsVX2TtZ1ynxw4e0Ot65TdG59wINf/rLLyw/Y1w6/TxqqEzV73sIlsxvurTGozCohE9K24Tan6chvIszfKu459MwDsk3UszRm258ler2mYpR8MwCqGWxZ1X257wVorxqMIcwfAaXhthpnnXUXzfogLptGt8fc4rYGlo4fyeKOtHB+w3JusAPgp9mSaLsvxZjrFTPHKztoxGFFt1knfAJGWkik+O3GeBKH50v0a5BHbH6mA5eIynvncc+vcAOgPD5pVaiC6aCXEg7OrVM6W1uplklj4JZXj1A7MpARP0Wnb4hqpabiuwGwNyZ3mawCG5Zm9XwiGXQcTCeTD4l6lOoSZveG/JdAPnshnZAJJj5MmWSygbrwmSjstn8CGs31HibznbvDb0iccmLMs0HOvMZcBiOiXACoeL4WxsZctXaPulhBR0I6f+IzccjOq9YGX1xJl/w5+vHTy4EslnJc2/eigQ8M/wL2RN9dZbQvFqWl0RDGwjBcZ88eLrRF1HEtuatqQ9ohBs/Pu1TIrJWFNdpCuzjvPTRfuo0Ez6lHJVDTAvc1DlmODWkfFxs2Q0tpj8VgEAfg0G7DOfMJi4sVnEOCWZGPotdBPLao5UR+T2G67t9rEpe0/L9FIV/ARBahv1P6t4C575OEECYYLcDPAX+8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Fri, 14 Nov 2025 17:48:09 -0800, SeongJae Park wrote:
> On Fri, 14 Nov 2025 11:03:01 +0100 Jean Delvare <jdelvare@suse.de> wrote:
> > On second thought, we might as well move these functions to cma.c as
> > this is the only place where they are called, so it's hard to justify
> > why they should be in a header file. Opinions?  
> 
> I think that should also be nice.  In the case, I think it can drop 'inline'
> keyword to let the compiler makes good decisions with its nice knowledge.  Also
> the similar event accounting code such as count_vm_event() and trace_*() calls
> can be moved into the new function together.  If do so, the function name may
> also better to be updated to represent it is not only for cma sysfs but general
> events accounting.  Just my two cents.

Thanks for your feedback. I have prepared an alternative patch which
moves the code to cma.c, I'll post it shortly.

I also experimented with your idea of consolidating accounting. I'm not
totally sold to the idea though, structurally it's nicer, but it implies
scattering the ifdef SYSFS across all 3 accounting functions, which not
everybody may like. I'm really not sure which I prefer. I'll post it
and let the maintainers decide.

-- 
Jean Delvare
SUSE L3 Support

