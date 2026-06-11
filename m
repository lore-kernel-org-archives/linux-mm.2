Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22628CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E5E6B008C; Thu, 11 Jun 2026 07:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8476B0092; Thu, 11 Jun 2026 07:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F706B0093; Thu, 11 Jun 2026 07:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51CDD6B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:13:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 162A91C2427
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:13:38 +0000 (UTC)
X-FDA: 84867371316.08.56FFB49
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3C8F180009
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:13:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h7gGhUHC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3oX5UDZz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h7gGhUHC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3oX5UDZz;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781176416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTPmKDC2++fFuX1IGIaCfTosGFLn7J/XiVm22BhhlKY=;
	b=1OAXFybvKhQLu0LbHV8qjYJtVPG38qA+uvCyY7hvSywHsCzoRChrZ3alksO2NAbAGWYYpA
	4JEcJAaNxSTeWxcjsvv3cAumcHlQNF9xhepPGVfVDjI6A0NybUHOHjehaxlac3wcACvbbR
	xvCgV7v8jZt6c3Y2jG93WI9jKkVSEik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781176416;
	b=N2JQhOy50Y4acmJRppuDIW6fyztxfrY2yc0W7O4jP6b1pfJ1gIBoW6iGIeUZZmKWqfJn3r
	ioM86jy4C87u05a9sgqh5A0RrT92hAZIrPJXJ0iDF74BpvI4SAa/3xqaSKeum32sUEm0Rx
	D43bpXUetyqexs28zncAv6sYmd9Q7Zo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h7gGhUHC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3oX5UDZz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h7gGhUHC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3oX5UDZz;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D4517595F;
	Thu, 11 Jun 2026 11:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781176414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uTPmKDC2++fFuX1IGIaCfTosGFLn7J/XiVm22BhhlKY=;
	b=h7gGhUHCMWHR9qmMcGC0AoT1CAbC0qDA+DovzA8zAz7H7fQv0PFs7CPOjJnxhCdFaDcGUu
	vyvAK0DfyY1RdmfXFklPCJyPNhMzAuw2CP1s6N7qwcEYWiR5mxL9DG/5BysO6PhZMxKoKD
	ISZg6RTIwJecj6GxaQYPdfgUtqJTzRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781176414;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uTPmKDC2++fFuX1IGIaCfTosGFLn7J/XiVm22BhhlKY=;
	b=3oX5UDZz+h4XTy4ey9XkDARLpL0LSp4+oHtkq9J8VDyjYLcXPfbAOHxVyfqg6po5L3jIcS
	rP2TI5nu7gaMawCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781176414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uTPmKDC2++fFuX1IGIaCfTosGFLn7J/XiVm22BhhlKY=;
	b=h7gGhUHCMWHR9qmMcGC0AoT1CAbC0qDA+DovzA8zAz7H7fQv0PFs7CPOjJnxhCdFaDcGUu
	vyvAK0DfyY1RdmfXFklPCJyPNhMzAuw2CP1s6N7qwcEYWiR5mxL9DG/5BysO6PhZMxKoKD
	ISZg6RTIwJecj6GxaQYPdfgUtqJTzRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781176414;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uTPmKDC2++fFuX1IGIaCfTosGFLn7J/XiVm22BhhlKY=;
	b=3oX5UDZz+h4XTy4ey9XkDARLpL0LSp4+oHtkq9J8VDyjYLcXPfbAOHxVyfqg6po5L3jIcS
	rP2TI5nu7gaMawCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0CEF1779A7;
	Thu, 11 Jun 2026 11:13:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wxlKO1mYKmqmDQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 11 Jun 2026 11:13:29 +0000
Date: Thu, 11 Jun 2026 12:13:28 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Huang Shijie <huangsj@hygon.cn>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, mjguzik@gmail.com, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, shakeel.butt@linux.dev, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, linux@armlinux.org.uk, 
	dinguyen@kernel.org, schuster.simon@siemens-energy.com, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, djbw@kernel.org, willy@infradead.org, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, james.clark@linaro.org, 
	mhiramat@kernel.org, oleg@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, linmiaohe@huawei.com, nao.horiguchi@gmail.com, jannh@google.com, 
	riel@surriel.com, harry@kernel.org, will@kernel.org, brian.ruley@gehealthcare.com, 
	rmk+kernel@armlinux.org.uk, dave.anglin@bell.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
Message-ID: <aiqYJTJFIHHk_IOt@pedro-suse.lan>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <20260611061915.2354307-2-huangsj@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611061915.2354307-2-huangsj@hygon.cn>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E3C8F180009
X-Rspam-User: 
X-Stat-Signature: hbfg1h55myuwa8z39y8kaumjmm4tn1um
X-Rspamd-Server: rspam08
X-HE-Tag: 1781176415-452152
X-HE-Meta: U2FsdGVkX18yHv1XGbU/wYo76j8d/DEtTbILdHMlCLTONMdg7Vp92bQtum+j+Vj95J/ce/hbLtkpknGTw8uholwZvGqREIaqhsg3YHY+wrBsVxwXgnHLs2bNnBbOB5XZF/sv16xVqUpeRKJzF711pKf2CMyJ+4vPDLs8JOyzXYhLHk0QoDayEUmCtiFRvJ1+PhbM9Z03U12Z5emYxn+EU3PuzwIZun5gGm0b9BUf6k9EVnjt4loaadYhddb+Y90MwycVNgOkFwg//rDxkRysPc5bU8XYlTBqw3gN9eMvFCINXfAdYFkWosjDtdysc0kFp4BmpdzUJ3TIdSNebvGWqueEHdBTfXVljbyuVe68lvyQUvaIwsHUZK0eSM308f0ym+4sLgK4yC6pY777+JvffVFVagalak3OITi58R5bycU3F7Sc0/TeCwyuxfBW8hWnIML2UMJxAPipSdLaPW8tk8pzSWbwDJyOgmWr68itXk7gjgd56cTDrUMRovOnQg1TCrtgUn/nqG2sSjXOsjNoNIcG3RNBQnswOwiaAE5HTfeTQgM9vaHVJBKH861Za+3y6fVeAxyj2yyVoSZAzkDlAE8o6buWr9+mTIw19NcFTBiobKkHJk1EVDHiuCYYCM3ZJTMPemUV4mECBXISNsqbXdI0MQ0ndO0hp1msNaVFOBaddPDdv0Huo+6Y6Y506K0scr27Q050L8G51il893jY5qLWE9897pw0Nm9QAja4sfwPQIURYbqKvygxMxyJrsO0NA5WDFTVeDEWSS7FvS2LfpTUSVXA4IsWDE2G/Ztxr8G898uqbUD5fHH6/LsORaSNBPvdzFDwMaPHospMyttg+J/73mMSRNOeZXNWjSWWLdnaGfczTnJcUoGEdvh2tg9rJ7fll0Fin56fhu3l7nuJZbvzure5bUR/6m7tRA1KVfR2BYwjEdIBnCW9az/ll3ALfHc+TL4TvWumbZCrCJ2
 0HIMNwQX
 PdNzxSbMn/g2iCShbKDqMXDTZ2WeRfIwY1baDFtfVqIexgtVEddAUsz9P8pyL4k9S+o8BtXiWuO5vg5mtAIT2rXR0Nv2Uye+z3o1/FgIwjTETyDcog3QBPJdxsdScuUCD32ZIJ664dTorBAezh/7gdC+UOG1F4wZ0IpNMcH2dHFBgaSJPI6CBq5qzVO/lQi9SNkChyND5oAZ9maykIoDvjJdJ/SS79//qxP+Lw2UZXzeT79XoInrwAUUT7b3HE729bE2qma27Rh0i0uez9FTrFHNVGV15i3zsljny0BVwS7DYucQtJd6qKHS99V/ntylznMlWKhz1K7HBv7E6TPyBB5+vPoZnF1gZih0CtIOnMueT+yugVgWF9wSCY2tXDrqDNtPQdHJDpiv/pYx3k7ToWxxsBTXsRqIrVJUL0fpxp1hU0hLuNcQiFWSwAyCVp1mlg0Ku/UC4w0MHnpl6eHFhBwK7hwjGnXfO4We3PRWeLEphfTFoMN/Rc/ctMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 02:18:57PM +0800, Huang Shijie wrote:
> Use mapping_mapped() to simplify the code, make
> the code tidy and clean.
> 
> Signed-off-by: Huang Shijie <huangsj@hygon.cn>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

LGTM, thanks! Super uncontroversial so perhaps
could be picked up separately.

-- 
Pedro

