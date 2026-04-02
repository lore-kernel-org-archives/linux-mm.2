Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45838D39413
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 11:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86FE36B008A; Thu,  2 Apr 2026 07:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847886B008C; Thu,  2 Apr 2026 07:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7845E6B0092; Thu,  2 Apr 2026 07:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6865E6B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:06:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3302516050A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:06:29 +0000 (UTC)
X-FDA: 84613337298.05.6082822
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8826B100015
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:06:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mepq+1tw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775127987; a=rsa-sha256;
	cv=none;
	b=TGfiVKQ67cbOZNmxc4zZYbGcl3ksfln8Gh/xFeFqG9T2uK7dJoxpu+c+jhcn1cWhpD7BDA
	1hUAm3qbHBwFI6cLLJCYrH8u+gfF4c9HeO1UoWhTuLNlDEx9W10+OjKxf6/O04Di/o3uu8
	xyjWZPN/xYzfHEzbkDTldcD3dLZj740=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mepq+1tw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775127987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOiXpkaDPT5+GnZzDc3tKc6/1/d+LR4XE4czeE+jSGA=;
	b=lA9Ll9UhC9QpK4n9K8MmPXWwHsoweEhZs4Fri5Ptjlw12QXhVzNbm4TCaw+uQ62WsMP5oZ
	qFlsRdIe6ppcgkqk70mfkmDaxqbDShaWhItQsBTsRhpbfKhxRZ7d9pyU/mmGAXts/gAGIX
	2V1id2Ar/krK3sExWaE31xccU++oPHE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E38A061868;
	Thu,  2 Apr 2026 11:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D28C116C6;
	Thu,  2 Apr 2026 11:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775127986;
	bh=tsBXonxD8VPFQ/seZUZthS5OGTJWUNF8u5V2lMIyKs4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mepq+1tw4dehbvThxacvebLDkSLxeMiLdGmS5dsQIQZ/di9vk5nOtxBo9cPlgkb1y
	 8zIzszO1DyPVyuMmPlk1AqyDfADbPFThwF908JdOGKd/XEFFuq18b4m4T2mUrKS9oD
	 kSGIYkyLxsy9IVqq5m607wnc4AQImMAl1DzOt3Q44Zvyeqcb+oWvC2UwKJG0SgQC8j
	 Ls7p6Y/XL8BoPe2x6XlZMIin7z6/PtYOoOaaijmw2GAWp8wbAAMdGvboIlXI0Nn9BV
	 Jc8UCj8RNZdWhUqOUtIki9hdOkom66bJ/aeXJqJUe31Wa6rwUKkHY31D2VjctzkfJe
	 UWO1WX1qxGTrA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 5/7] mm/memfd_luo: fix physical address conversion in
 put_folios cleanup
In-Reply-To: <20260326084727.118437-6-duanchenghao@kylinos.cn> (Chenghao
	Duan's message of "Thu, 26 Mar 2026 16:47:25 +0800")
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-6-duanchenghao@kylinos.cn>
Date: Thu, 02 Apr 2026 11:06:23 +0000
Message-ID: <2vxz4ilthb9s.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: b31nqrwcr93tryxr3cifb4z8f4i56uni
X-Rspamd-Queue-Id: 8826B100015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775127987-895972
X-HE-Meta: U2FsdGVkX1+da8SdP+XU3BsqCgW4cNbiL+33wLoG5AY1ruB2eWXZS5xbGI7JuXU5DA2mu/o+ZGJMP/EXD+NFRDP/luDVWF+Uj5KnZauvjP0hSyw6nI6ySuHlyOBxC3kdAJ3dUjb9YO260HuHuYLywuYIBBru+jbjNSzwV+a9EsYj1waF7ZrLmlrJ424ajgdrTuAww+fvNg7HXBHENFkOFYMe0ZVNM39j/unuOM7ubNL0g4SKfLc6xvD8X0GqREEtN4eTZAQ6PY2Ln9kmHZFlRjuLvZdEYxJYsLWl59msx7pTMoHQyrdVs+G/3PboZRiG0LciwlwjTOIDYLuSncGGmZsUnX/783uN3pqGUVf0nS3VZvL/kJPGISI4uyufgeRJUivpfh2IwuYnzjaR4AEzbUJsHZAojr0s13d4ionOqcAdrDpVFRgKEsOl+w0obecG+iqwQ0waxOTnHBwlpXAVdZyZGv9E/VwmC3cS6GeV6ZQ6Px3k+LYxva83DhoPApZIsRVRgv/u4d8jIw8biecgQDrTGuiN0zxU7u/xHJPBAlzujGiJu6rmWQz1BjkHSgK4oi2gECLTfjXeWhuxzqr3GmVHgqnpOuMKh1ioCAvbzIUW9Ptb6rJMAQx0F4yXoca1FwiZinzGGsTQ60zeQQHsTbJVtlvpNen4njQZXJ5HZOcap9YYqwjkMivun7RrrSM4PyuDezAEhWCqtmpLBv+kCR92tW/0wShx6uudb6ziczNuod/kSA9nOB3YngoV4ajj8a2QBOApZHHpVsGr7jMnAO5LQFtVfcTYXKTVVWnVuQgdPsTkr4j4wgUIn79zHpGE6Hn9GXVaL39s5+rXoTiP7DqV1A9j7estR+FrsRssek6xdrpUyrW9SobzloZT/LHBXZ6PpDcUyap2a7YhKBg+o7on39+4+7wAxoRBy9MCgvw8DeiojEOvZN0gHAKCxr9k8hUzKt/lQxsm2LZoX2d
 IpYHLtbH
 HJR+zzdP/V6t24HT++JzpbbAPOavLSldFVyguFXVriaVZhBkfRwBV4F5BS94/YtPFZ3uDnY1ox6RBiFLwkHYUyQMh8gBj17uMN92PysCI6OF+H5NYlebrT2Y5UvKdWNv/dEmH/gyvPO54vjnMYwzgCigO1iKC4k57MCPXjbOliCWtJ7KuutdYhEa5k18GUuKPnlDwWwtbVuZenXiFc6i9mkOhW4LGrXZAeubdDIYHgEemH+lwp0rjsHv8XqkHyZWL5Kg9TybPr5yXAMmhux5ymAP4Md/YjjI3tZqjstBekWrRE0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26 2026, Chenghao Duan wrote:

> In memfd_luo_retrieve_folios()'s put_folios cleanup path:
>
> 1. kho_restore_folio() expects a phys_addr_t (physical address) but
>    receives a raw PFN (pfolio->pfn). This causes kho_restore_page() to
>    check the wrong physical address (pfn << PAGE_SHIFT instead of the
>    actual physical address).
>
> 2. This loop lacks the !pfolio->pfn check that exists in the main
>    retrieval loop and memfd_luo_discard_folios(), which could
>    incorrectly process sparse file holes where pfn=0.
>
> Fix by converting PFN to physical address with PFN_PHYS() and adding
> the !pfolio->pfn check, matching the pattern used elsewhere in this file.
>
> This issue was identified by the AI review.
> https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Andrew, can you please add:

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Cc: stable@vger.kernel.org

[...]

-- 
Regards,
Pratyush Yadav

