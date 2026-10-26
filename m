Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C4A606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gC3U5SKs;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=FQwhEslu;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gC3U5SKs;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=FQwhEslu
Received: by kanga.kvack.org (Postfix)
	id 03F016B05B6; Mon, 26 Oct 2026 08:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0162C6B05B7; Mon, 26 Oct 2026 08:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6DF86B05B8; Mon, 26 Oct 2026 08:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFF636B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:57:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5541AA82AF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:57:11 +0000 (UTC)
X-FDA: 85364777862.13.0DDE0D3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3AD11C0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:57:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gC3U5SKs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FQwhEslu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gC3U5SKs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FQwhEslu;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793019429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtIcRoPsuzvE303euSvkccl6Hv/dLG7a9Be0HhrqmYI=;
	b=5cbidJhSAftaZFjme+8kpFLI1ot4ZUbZ6oTysPTEj9S9gfI7QCX21pae5MnU2LIVRVfeMS
	6UF+yiGYCCu0kWOKeZ8qJVEMsUc3mOw+ZZzmyP1tYRi63BjW2cBBryq5/+e7uy+BJnp1bN
	ovaJ5dRQ2di0WcbY2XEVFqc286y9OMk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793019429;
	b=gkcBXDuGFFjrMJ5U2MKTLcuDRTqU7m/7GFlW7whA7BwIxp25S9BCNtd3tG/KwgxK/WFdre
	g8k4E59xj651tNVZqZYEaXYvlmr+j5qHdK/aiDG1B/5BHkkA1cvrFVk9fOwKbxM92aqnbD
	cBD45Dgse/uY2R9h0Th4WgpTNNjVaDw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gC3U5SKs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FQwhEslu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gC3U5SKs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FQwhEslu;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B8EB21F46E;
	Mon, 26 Oct 2026 12:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793019427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rtIcRoPsuzvE303euSvkccl6Hv/dLG7a9Be0HhrqmYI=;
	b=gC3U5SKscHPXg8RjeWwr3oZamighRtqxYQRxVNIjY/Y6YK8s6TQqmhGyALsdAWqI8ejswA
	T+rG5lmAVGUtVhaN/yYAcLf4QrIQObD0vS4ju5KSjgp0or4xwNEXd04cxTcIUKXOcdGriZ
	ococ2Hfp6IrF3/SNKrEO3nZKgi8u8PE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793019427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rtIcRoPsuzvE303euSvkccl6Hv/dLG7a9Be0HhrqmYI=;
	b=FQwhEsluY/yj6aGnxk6vNIjdQg6JMSvTMi1YubrRCm6nbZKeGaLY7aLGkcZyAfsEiVUZ4Y
	oZhfSEg8RUKZwjDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793019427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rtIcRoPsuzvE303euSvkccl6Hv/dLG7a9Be0HhrqmYI=;
	b=gC3U5SKscHPXg8RjeWwr3oZamighRtqxYQRxVNIjY/Y6YK8s6TQqmhGyALsdAWqI8ejswA
	T+rG5lmAVGUtVhaN/yYAcLf4QrIQObD0vS4ju5KSjgp0or4xwNEXd04cxTcIUKXOcdGriZ
	ococ2Hfp6IrF3/SNKrEO3nZKgi8u8PE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793019427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rtIcRoPsuzvE303euSvkccl6Hv/dLG7a9Be0HhrqmYI=;
	b=FQwhEsluY/yj6aGnxk6vNIjdQg6JMSvTMi1YubrRCm6nbZKeGaLY7aLGkcZyAfsEiVUZ4Y
	oZhfSEg8RUKZwjDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15BE513408;
	Mon, 26 Oct 2026 12:57:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eyl2MyFO32rLVAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 12:57:06 +0000
Date: Mon, 26 Oct 2026 12:57:04 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, 
	Colin Cross <ccross@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/vma: write lock source VMA before duplicating it
 in __split_vma()
Message-ID: <at9NKAYk-W7PhlGu@pedro-suse.tail5790ac.ts.net>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
 <20261023-fix-vma-atomic-v1-2-8ff4fae1fc85@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023-fix-vma-atomic-v1-2-8ff4fae1fc85@kernel.org>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3AD11C0003
X-Stat-Signature: 3yqyrwtufh8iixqjyxbtjp996nt76j7k
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793019429-453576
X-HE-Meta: U2FsdGVkX1+1AJQdPD6bfw2PCnr5cmocpb+Cq56HksYtB6vOXQqO9pdy5xTQn8+qZMogNCBGgop+vAdPllecf6HnBXZvDbtjtnGozvPLKhI9B4OdXGfhGAzJHo4Ut8WS5YohdxaC7pZ74XOUkoIF+9GuD9L8rccb1a5NdpF1ZxD/jn3UQot4Pr1VdJK1SqMOQeg5aCJNGMdoCcchDdgG4ZE9H7YMiuRHuBegxvuUSRgwhUOWRbzrtX8DnmJ1tBQyfNT/TStu0bFQiohIDdYDrp5Kn8WMAN6kSdK27sSvSX4P4x61WyapUZ0IlqaZZ6E5nfF3EROQNLWy8A2w6YxzTxwFUz0B26GwpVKCpJSmSVqPkMy/cpz/hzyWWC+q7ywXngILrqJR/nB5nTRIEgRQzG1BE9uFrvCIXh7n3gjQTnz2lxN3Fpri5nSTC8gOOKXf1MmyBEEXpklLvK/PRS2sV7UTqsnedQVFJrU8MkLc7rj0qK/0O0yKl9blneQeodYsVDeGT0F901ficG7N8sPF57GxNnqGqu8Bypt2L2P2Ev5i16AiMxwx/gZSDhWKZeJCEykrbPaeqfKqMqMc2w30z6hRvGzPSqRNkMRiTQbmvb78JcYs/M/jmOPRBmcZvDNyptHkNLAXmg+AdSUtfKLZrphE9vq/y/RmLw/MeJY4Ptil+TztgxxbpX82RSqn8w0oHhSuKwh3MU+OSz17SlEDeMlRLsVnruvER5xEg8LDQPiUPJ6+iT0Iw/zG2oH/sWEhLo0MI+M9dCIiMpEyiMWb66384BoLvLEMm2u+gEkdKd7+Gfq4PgGPLKE9dgOqX4eIbZfwljpVt83VOszaYnDDGPE9bZUV1l16hGCJtZ3jfiWNYayfRO108jTw5xxOmM640c0BvpZ2H3SUWcoqb+m5AfXvLk8pvWtiKcx6V+f9ohAkNAN8tpwM33Ojiepx8I2hMKkEBvkzACY+cYXK8xK
 RlmvMH+3
 Bj9e4B15zAsTc0yTSJ/6BIwLmPVSdZbbM8dkRu1UxezAj+fIpSLPbGUndoPjTlV5Qc4CmZQWV+u9AnpeRqaojQLMg+KPzewXBXgscThZPqPV/uRrdBvzEeGYjYZ0ohDExtsjcr41X3V7ZMwrzhs4BTckGijjYMgxNH2kFqmPym+Xc1zxr8p2x8fxWEgynhu4fYGx0UpN44DpNuRfRlOB2hpNv4fICkcOLaFZzRoFa+e/2UMKm3ciBC+OFdcDGd/Qj0Xs17tCzXYgHvEMBArS48HWbSU8xR2IYMh4zW7Xf/mFqZF6qOVT0V3+tUBqWwfAsys5nCx+z7p5+X2dMwBaBcusgGTafW/1DgfTctPeEhNqqznJcu5PelKnWOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 02:47:28PM +0100, Lorenzo Stoakes (ARM) wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> __split_vma() duplicates the source VMA before taking its VMA write lock,
> and until the VMA is write-locked, a concurrent thread might set
> VMA_MAYBE_GUARD_BIT, resulting in the duplication missing the flag.
> 
> If this happens, then fork may fail to duplicate guard markers and, if a
> file-backed mapping, THP collapse may also discard the markers.
> 
> Resolve this by taking the VMA write lock before vm_area_dup() and, since
> all callers of vm_area_dup() now hold the VMA write lock, assert that this
> is the case there, and add a comment to explain why it's needed.
> 
> Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ ljs - add VMA write assert in vm_area_dup(), commit message touchup ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

