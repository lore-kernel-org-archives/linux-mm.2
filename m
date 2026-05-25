Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F3BCCD5BCF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB566B0096; Mon, 25 May 2026 11:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB726B0098; Mon, 25 May 2026 11:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1826B0099; Mon, 25 May 2026 11:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE08D6B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:29:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76A43C01D4
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:29:37 +0000 (UTC)
X-FDA: 84806326794.09.FA4DFD2
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61E2DA000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:29:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=mQNEqOkf;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b AK4oyE";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779722975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=koqpQdEmzECFo5R13UjpmYRDc4hRc7E76rF4OR1LfuM=;
	b=i1i2zMDPwvgQ6ltWSpVLSpx9yDoz3Nx/Y6c98SnLOTqdvxdlVmnEhNE8H2lRHDreC7x9qc
	TrmWXnQVPvhk+6dugaKrIj2Gi5hoAV6wrzWtGMUoZqwQqhCppJwZ7HhPa4l60QVTeMdPjU
	UyHEq/KBZEOJpIuge1G4KzcUKfnbHLY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=mQNEqOkf;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b AK4oyE";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779722975; a=rsa-sha256;
	cv=none;
	b=jZzpqpBZWXCUwqWoedKxoWOFqezLf/0+6+1SGMeNAEaKebqciToGrHIfCePk0Io/ZkeD2r
	tVN+TxD8zLPaXOApHosbpY/njWqC0oaR0UA8ZSVbaKZMkrBzlXldcbtuOGNyVOh1V93lHH
	nVEYq10xjNfw5P/1krY5gf8PjhjG8Vs=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id A081E13006FB;
	Mon, 25 May 2026 11:29:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 25 May 2026 11:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779722973; x=1779730173; bh=koqpQdEmzECFo5R13UjpmYRDc4hRc7E7
	6rF4OR1LfuM=; b=mQNEqOkf7IpGi3vGbbjzUi4EdXEo6i6Mjljoo1lxF66paGpA
	1dpprCzpnhoTyreHsdhzPSubEh2iCQaU0g/Fy7yYQpDKCDJpN3NCbPBkfrCPn1nm
	ignGr3nmVkxHGLfC/JvdiRa6n1k1m5So5a1R2iYxE55BZpOyTbcXSp/YGorUlUeE
	ALMEwrfiZA+sW9aViJx19V4aHfwIJNtMa7o3xuujvD+GzoH7cLOIaD6oCjsMHATt
	p6gASQT1eemlldTDOwD0nxu5qXs6FOVSvxJ0txs0N0dYoS157NY9zovux65vz7zT
	kHml1WbnYs5ThOUxS0Sv0+AC4Ssd63zPsLSyTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779722973; x=
	1779730173; bh=koqpQdEmzECFo5R13UjpmYRDc4hRc7E76rF4OR1LfuM=; b=b
	AK4oyEk51g45pbTr6y1pt8ZOLG1Q1UsRKZsh+WZpF9b71ZKYMhnqdbDxGsoEg2kO
	ZYytwgWkJJ3TClxzvmr/7kFPk5Z3cy6yWo74nB+sdJjbJ0MdZlxUncRcU5iYj/Bg
	JEFN6y5ZaVYwXW94iSd5taqg7KyMHT/9NacQLs2v4TsiLPrghmMxz+rcEynIZhtD
	4jfN0WmtllBsCBYM/0YQ27Ek8EITHTEUf0GmByNXxkkvF112UbTS8+lzgET/3Qzr
	jwjPglY35fmWwOHt0ba16zwTsoD61jaX5mfRq4Lcwaku5nW6lQTVVnx94cfd1fOe
	wD2atHYen7DsfNsGeOUJA==
X-ME-Sender: <xms:3WoUauZwniadSV_0XJQRR3GfbfqezAgVOnEiJXQvVGpDxxbEcg-8ww>
    <xme:3WoUarX7I_TM33rJvpXWGdacq2w_BXWHKYsKrDtT4MqMNZuGuyvszFk_XbJRiYcpM
    ITuA0dRxGnyQ0Gv1AsiXpaRtcU4LdLYpXaHIIGKxK5Q3609Zv3qDj0>
X-ME-Received: <xmr:3WoUaq3TMWAAgMf8vwCjKN6t-AtgQq3AYWTp4Zx9wziGwgpipvalglWr7wgoYg>
X-ME-Proxy-Cause: dmFkZTFSztvldXVRZEX/sh1yXy8WVaJ330r2bAU/myjOo0zHQHyhaQcNvZ+pEoT1dFLitq
    y9M/24rkaHAXtyxJ8+YKwCOK5OI+TxBImPalB+hF93G//nOGkpwin3NA+Xhgw0dprXVYJd
    OlxJsf+n+k0eK5y68GajmHiELU44SlxGcmIWwYVJzM2LiyPtdPpv8KWzen85uN8aL9q2gC
    ACJiqgb+7E7PFVNiU+XMNhLKGxaUtcBWLPmyA7Crz0BpRKvP7IYztEWEggnISgXD22dJXN
    qy0iXTQU2ZIC5hEXp41L/fgWtwkvSLwzwODrxIvGKMgxGwmdLTalZ1mj7jeAiLk4m9LdPM
    /mk7fYPYgsZgbWYqVddSXwx0bpB0rF1U0eGSxOsGKQJOGmlu9RA+BNOgIAMlY1JkYef/6n
    gRxko25ObTCU8piLty0JYHtbTDEkXe2qxSFpYtCcjj2niIPen9VcygMVt7xm+ZR/A+RXaj
    3zKfrkQ3nU+lleC+rxPLnmHTlV0KL+0aMeY74mmoZjh0sP3KIbPOMD/p73DF1/b6pr9Ang
    /cFLnkCsXwRrIkajp6uUYf9eSjOLmDIoRa/WSPV8ZSkjt+T4sbHnzLdz2Nyq5vZi1KuhCe
    ToGk/UwYCgmZ+OMsUIYDTVI5kx8eei2qnuHFQgVRWuu2UDZ8Ha6vRrVcYIeQ
X-ME-Proxy: <xmx:3WoUasEN6LhIkvyVDGDHLBmki234R04Rze_yFsGsgfwezUtJjZZwKw>
    <xmx:3WoUajAhcewLM2mBs-bYnzhjRx9suE8c1ZWBT_7hb3eGcfG4guupuw>
    <xmx:3WoUauMoy_ZRzMXlcCosqpFVASZnRe4r0oLoV4mnoS89y9y9rNfl4A>
    <xmx:3WoUamc98WHaFJlzMMrOOsufxmvDJruVtd3npP0G3rZ1SfXRnRbcDg>
    <xmx:3WoUaiO6L2fCVXg-dfMrikcfQFbyI6ML7eWFPiiFicp7NxgUbKu-uTpC>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:29:31 -0400 (EDT)
Date: Mon, 25 May 2026 16:29:24 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 10/14] mm/pagemap: add PAGE_IS_ACCESSED for RWP
 tracking
Message-ID: <ahRqq3NBCEVx9BTU@thinkstation>
References: <20260525113737.1942478-11-kas@kernel.org>
 <20260525122659.BB52A1F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525122659.BB52A1F000E9@smtp.kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 61E2DA000D
X-Stat-Signature: gtehm11s17677drk138mxmdt9384qhxf
X-Rspam-User: 
X-HE-Tag: 1779722975-854144
X-HE-Meta: U2FsdGVkX19+c6N7U8MAlUC7IosSuEtPTj9cjMzLBBQpROtnP2mb4PpOsxLo7yFPFD03A/xIZQHXcZqZ6OqhQR1GefH7h39Ew9uvt1PTMuOq0nPzZASWRO/J55QHde0Lhatxc3bWb5Sd5Rx5IdHUou20I/6njuMxdZP6Ve4jvmbfQinlwpzUNl0OwV+gUSfxo43F+34bXHRagKsBgmvVzuP92ZhX398AD+e1XHO4gw1VQecuz7eu59+z5emGfwZ84dObEjFMFbmg41bTBwSfR+wXsybyoU/WllHoiTbtTy0dVae+V/gn7ZKyQ1mNp3QUQ3Tx18jXgGG4Ef/WoFNmVNYIC6W1ZDrORVSHM/AcDr/pI6NKMa2TpE294YJjJ2OpjlQWQC/a4EcrBoW2IJeBK1WD2QLq5ABKraRgs2l/ZLofvaWfeDN8xCND+VKu8vEsY1/z9w/WQ72nxvbaVqTfY6TS6gYbwxIOz0H2svqnDgnyBsxriyPTDXv5w+3F1StIvqi9o2V5tf1JtsL0JE2MB/HtIlSwoql7w7oS38T0+fc74a9HzMDN/2BCGUUNQjWgjcXENIExKwM6kKli67ap26rzgcumIJJUPxsHHfyuMTCNcrt5iwTElznWG0M7VxkOASp1uUK0o6GsjgOAB4Zd2zX3+aYHpzirMhWgycMrK9CUNq8X4VzzujkVqfy6j/kDPHba+5DKEV+m4IOsEQ0hDiZU0VcF2kh7kClvKe2bu5mtwABB1JQc5s4gMWdkGQnlyMC6D5yBnpEPqFBvSB9C8vQ/yX/6nVZKpnuJefd9EJ7LJX6sgZ0aUQvrwmear8+j7pMAvE0OejZolK3AwXVvbc99tNZnN3sEjqITDh42nFZsNLEYrd9OjIdkDhkZNWDlIiE2XZP2hrBGkL67jQPTxGRVPlkQeviwPxrK4DHk/iM9AHwi7cRrXk1mDG7153GqLN9aSUGIqJNyWmu4dlL
 CBGxceHz
 QuZBhccCp15RASoB0QaHV5jMFXJhIEpdixItuZOOeI8Rkv1dL4L+vzW3hGFN1bIoqdzMN/70bUWigS09iaKPf+WyQ3URfy4Lo6qyAjSfUpZ/kFQxdwn93HuvsMENokBa2O8XwmyAQqatFLd94XWGCjWn0gi4w0wA2OqM4t20w9MkkcjcAlFta2N1tmlbORzDvmmX/rBgsuN7yK4Gjln2Ri5qXDtArMb6RIz1YDB/AQ48peYi0su7Bl9CPPjodcyW6AHF4Kx9RGuWWahEPCle2mGsZ+ep7JNCbEzVSfzV06/Rdv4+/egVVDzjr7jJegjwcjp2JHNEcWxxbILQ051c9SkkEswklvXJV1CRV4OeBm+dLkuBxG5q+6k6dWuvUQpasaEdrOX6o1m8VT/ZHX8OYWnSdy52W5wddJgmoAffMjVKUmPYI7YtapeNXJ2bTT6GyQM0DUCEv4ggXqgyz0bEFzUtZqEc7v/DpzNg05jLv2PMIpI/JO5T+4AEie8cw1v0kghFEXaoDsMGShLcgFIN6s8Tdnb2jQUKjU/ffax9YLpbp6mIcCQsZQKRDoLj4I5zjuGW9IgJWMoWwBW0V6Z845DJJFb02fKsAKHhc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:26:59PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Returning -EINVAL from pagemap_scan_test_walk() aborts the
> scan destructively, permanently losing read results for already
> write-protected pages in preceding VMAs.

Confirmed. The non-wp-allowed branch right below already follows the
right convention -- silently skip with `return 1` so the walk continues.
Will fix in v5 the same way:

      -       return -EINVAL;
      +       return 1;

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=10

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

