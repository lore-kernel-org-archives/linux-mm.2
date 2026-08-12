Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8552EC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9C56B00B0; Wed, 12 Aug 2026 05:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790D46B00B6; Wed, 12 Aug 2026 05:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67FCB6B00BF; Wed, 12 Aug 2026 05:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 430E86B00B0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:24:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB66012016D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:24:10 +0000 (UTC)
X-FDA: 85092081060.12.2F643D2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id A156040005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:24:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fYowjGmY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ERmWLsxM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UgFreQx4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5xshYV/N";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786526648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBaU2Wn9BvxVYjypevPijiacf8bTpCRTGLYa7EXyl6Y=;
	b=hMcz9BSPQCtViLsPov+i0/hvsOpN+Vj6VshY5CwhN6U+pLlNx5XseaUUjIHC+0l2hNgHYG
	eW0OJ6oOyiKGYK48qExoe5T4mmESNpNIA2PEFHV0Ggzbe3wHAFTvvdXncG6Q10S5rHWmzq
	zPinemvCUOoS/5ASv8cOU2urf76kge4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fYowjGmY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ERmWLsxM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UgFreQx4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5xshYV/N";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786526648;
	b=1/TPEdDg18chFqMYuGfBPafWGEjfFa7QgpB7ees0e0uHFajx/R9c6YyfLPwQHehJpQOgYX
	TYXTQ1xeZvHDzpRsVhOWubsDQRUUcJnFcKxYagj/tJ9XFauSNjx4wSdh5ZXmbS9zzeIxcC
	mcEeXCgUI9Xi8D9l9+vwF7AWxlK8gZA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 09D463E5F;
	Wed, 12 Aug 2026 09:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786526643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBaU2Wn9BvxVYjypevPijiacf8bTpCRTGLYa7EXyl6Y=;
	b=fYowjGmYwDrtLjMYFtb2r9WmVlMtAwYItDujksbIUR87O2OVJMCNHc8ZdS4mwtomZ6Wcfx
	5UpfGmY5Fax3nX1nUpq89vLK+OnJsrnQGD9yqIMV/rgPbUOCDgu22zV8v1k+GOM4Q6wMdq
	RQNP2gXREiT+zptWtt6p+rDF2zylw0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786526643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBaU2Wn9BvxVYjypevPijiacf8bTpCRTGLYa7EXyl6Y=;
	b=ERmWLsxMcRnJRApGJR16Om96FXa9cpG9EF7xq1oOzLul0yb0RC6lj+jA+LtQ1eTXtWQhSG
	cinuNeX756wq2QDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786526639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBaU2Wn9BvxVYjypevPijiacf8bTpCRTGLYa7EXyl6Y=;
	b=UgFreQx4v4iX2TMSEludlSyCfO31JmcONhUrl5UKV6j9FBmLHAq3CYSPe68nZmKHjBgrqC
	0tfqnNMDhKK6Sfys/4DrC/Sbq1bZ7FvaKKCjRpvJn5fjtEXP7X741NbObAF5ELD0/hW8aU
	Arx8fzo57r5xRq3wknJWXEof12pmcG0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786526639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBaU2Wn9BvxVYjypevPijiacf8bTpCRTGLYa7EXyl6Y=;
	b=5xshYV/NGWdLwDqMByLgqmpraJtbABl2gPGpRInoCDsWL296EsibdiZDz0xis6BW9kb4Dn
	Ysl4qo1KzxgfwLDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC1EE779B1;
	Wed, 12 Aug 2026 09:23:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G1bAJq07fGpQdgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 12 Aug 2026 09:23:57 +0000
Date: Wed, 12 Aug 2026 10:23:56 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 1/7] mm/khugepaged: refactor per-scan state clearing
 into collapse_control_init_scan()
Message-ID: <anw7F4FAHEIaW0nx@pedro-suse>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-1-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-1-ddac39d61c4a@linux.dev>
X-Rspam-User: 
X-Stat-Signature: fgxek4hqfkfxinka496o6htytxxe6xge
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A156040005
X-HE-Tag: 1786526648-895418
X-HE-Meta: U2FsdGVkX1+5ryUOf/mn+LAEOGU7wwzuUiNPW78iwj2BlwIRx2zScxBU3ltb1Aw4UH6bWKtdTwh+ogKOFf/Y1hhhhzILwaNnvzJbma1994tg53NgpOFHgHQuxhYK1uDL+qx/Ze53uQ8w8uzlH4yTQQyOA+hRLCYWMYBfUcgkchufce4wC596+jL5oj8/fmtQg9BvhTSuDYZpGTnzHftsqUVIng5++W0bzFqpmhA5HrmE9x7FqxcppKbUP3rZTzUM6MyYFHIwmVyooEzyc8ibHZN8SsEfziMCAnufiN0ExzVAVcNNWTZhpbm2ypt4SZydCbyrYKSKu0e25YJT20qpQue97BS+eWY+Takk3kBOZshnUxBgw5eUR+TIJrg4wep2s17hh+Vlitcuu/RgeorlTbk9ofyourpHQkVJotR1ohCe8V0ptnSTKH9kGQxjYf7DuAjRZ0lNTA/xn+QGEqj2lWafcBRXukHJHcQ1GZaaYyt42xZN1jWs3cTOnOrYzj7h9v9yBl6w3G2i6o8Pr55P1xiArKJYMQgYgh1m7S+SvO24dDd0xx8obLine1LWjUJULCpMsoJX3Giap1i8fV/BydJCejuAnbfQveevXEy2Vx8gWZNHELrPDcR6fwQuiQrc86yJUpI8vDei1bb0V4nMs4m3iJCOpGsB3je6ryOB9XXZaS1RIHKzehRDlC5c/BJ7QcW0as4HqKXX3pu+gC8XR99NUcoALd0ogKb6yL9d2gQMsuTIbi8vo6L4M/TcF412DPGQuRemsZ4fyTTrgJra7PycmvbVEblPmX16tEvfoX1nUV6oQOkjgfrufFKsdpIgOR47XJFY9YanhzWtaMBNgyMn9hUBVclIYJ1XVnH11IEvav3Siiuvui3Jj0Nt0IBp974+uOYB+qGKwpzACsG5Wd2GIl3s1oeAF2AcnAxZ0hv8J3fOlnvr4I0aU3qzy7pejckdlH8x1vOdgyhLD6H
 iMNaHSaU
 T6MlADRSrPS1TmYwCFpGnqNIHcmLtd7fgC/wdAicvQ0C+2V99XOEvCoxscq+j6l3LQXXqhMsyiaSKJTV32aL7udJrKrKqIYwRF+M2ozinRmWioAKZpSeGmcaRR9qpWGfUtVHywvp0PZs2GH5FnYK6FGN1y7xGXe4aFeEgLguMLDjPLvFqnA58WKaVQr02UmfG9gJMLl7A4ReVHPhGZL0xVSOZu64KYXRVH4tXpxTvSOXfO0PnWCpQZXpLMqYjH1nlV0RYPsCwDA3HEgzFUx9zCMzudMtSfoM+RqA8lLecBoFMjDUw1JrNh3sVweFrcnKj2Dz+C7YGxpRjCTsje4JrTXJODjPfi6c2ND+mlBb/gF5ZQp5vFTjzBu4mMxNsKvujn1GwW/kW57T/pUyVcagYrPKx2dGSk5FpOrbR4q4CwJMwjJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:33AM -0600, Nico Pache (Red Hat) wrote:
> Extract the repeated clearing of node_load, alloc_nmask, and
> mthp_present_ptes into a helper to reduce duplication in
> collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
> current use the bitmap, they will in the future, and clearing it now is

Will they? (To be clear, not opposed to clearing this regardless).

> harmless.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

