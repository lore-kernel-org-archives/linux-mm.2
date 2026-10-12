Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 473E6CA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53B996B0098; Mon, 12 Oct 2026 13:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512F46B0099; Mon, 12 Oct 2026 13:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404CD6B009B; Mon, 12 Oct 2026 13:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 153F16B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:59:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97F03411FC
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:59:33 +0000 (UTC)
X-FDA: 85314736626.30.BD98026
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf29.hostedemail.com (Postfix) with ESMTP id 496D9120007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:59:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="jeSTUY D";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791827971;
	b=SvBMwI8O6hSoSJi/CfUSPizOINu0kq7uVyWlFN936iyOQiE49e2hljtSHy63cYC7zjmnbq
	2ibXwmL80rW2kJj7pNh1tY8t2V7j0x4vqtcrbX2ez0vzvXZoAMmRRMb00E3xdL+Oy52DCF
	DUDVzk2Ops7xLE3wVk64LKq5Sn0XxWs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="jeSTUY D";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791827971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSqVsa7i9/0F94O69MwWRbVlnv3K0SgetLyAuG6UTWE=;
	b=ev8E3hg0LbG/JJsvCeK+R1wVU8zTSwMG9Q+1tATm5dt7cKkPuH0ZfQ3tKTXxkjH4Sa4OR8
	AppIMbpiMI4ak32i69LJLpnr5ES4fFl63k5m52L5MfP3sCsc0OmxBha1NSocRoxxGQfAIz
	cKuryBGWu2jpQvwtnRz8yazzbRGMKEk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=sSqVsa7i9/0F94O69MwWRbVlnv3K0SgetLyAuG6UTWE=; b=jeSTUY
	DeUDo17lXLykd9R+RCjk8/w/Gp84CsB78GurqVbeBQC8q01gsTjH1Q/FHw8TpAvChnH93OQLvCcDw
	Gew0ci9/BDMbTKqN46a0eaYh3pakexQT42lD20jPc9LlBle9F0nyghOaVN7SH3Odvpsnwq6Nz3et9
	KHQDC0nKt+gNl+0hHtZc937gdIwTb0Ke94/lmcCXRVTFKBt7kCN9x8/tPytSkNTkhAdF5Zpp0ggvQ
	wAErXvl2P5WpbBPXAFykQpnWTNqZ5Omj8moMZx2VcRAfMPS3PP/D5QA9eX5ywWDkggngkpdgyzJiZ
	xu4wwoW6went70/oJttxl7NVZq/g==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xGKIU-00000003Uxj-3Uz3;
	Mon, 12 Oct 2026 17:58:50 +0000
Message-ID: <ff62aeaeb5ced49640c959c047b2e9f320f5c10f.camel@surriel.com>
Subject: Re: [PATCH] mm/gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
From: Rik van Riel <riel@surriel.com>
To: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand	
 <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard	
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Lorenzo Stoakes	
 <ljs@kernel.org>, liam@infradead.org, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,  Aristeu Rozanski	 <aris@ruivo.org>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Oct 2026 13:58:50 -0400
In-Reply-To: <20261010195202.689-1-aa9736195201@gmail.com>
References: <20260917083747.786-1-aa9736195201@gmail.com>
	 <7dd4ec994502233cdc09fe5c4369adc89168d738.camel@surriel.com>
	 <20261010195202.689-1-aa9736195201@gmail.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Stat-Signature: kqenwqrx4xmuq9b91pspgpcqyhkfa1k7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 496D9120007
X-HE-Tag: 1791827970-12760
X-HE-Meta: U2FsdGVkX19W7xROV/tfZ56AIPjkastaxpPrsLK+iJM1VXtXzmt35fpr2oN+4IOM905VFyv41+sBkxyP9KLKkgbBSc1STnOq8bXG9c6EOn+dYEGA4CzWTBmOZgM14+UdUinXBYcl+fBZ018e6y1mUmRFApgZi3tTob/7uiuV49H6iPmn83sLHnDftVFw71cRav8ISi75DMB3m/qg4MDvWH1dMYvz2CdDon4HMFRM7cL6Sebp0llK58XYAW9OvpUDCCkcIUdej/ZbcXXIrxARH3e8N6es3+StsUsrRju2qz5Zb/gjxq/jtgUmvSlQkrBvdyv60Dw5i/hD9sFha44aZ5yjdREIFq6NQTYxlVLKkf11dg3VgVTkvZdbJ8s4XHEepfienTxxZjvFXZzeeCReD5eZFzNgm0sfGra3/go5TFO4vOYQU3G2/j5ZX0LewrGTgC7nvTRzBT0iFVRBXoLGiG+WSgz0nssL4rF3ms5dpl263RlmwyddNh4iOP+O26Z4g6DXGa5c1oDdHZn5EJ1+oRWbUvTNQha5OAgKnlUioHvQgfLwnvUOYEoskB6QsYGfqAvYhtdHHyPiEFp5O+cZ+Lqdg/wc1fRZnwvM/JNp6DBq9zgqKzyGYbcSRC9g5lijwQXNs2hJNqI+HxBPKVscx1YOn4HQJFlG54aOt+1iWFml0AfzI5ZHvKe3FM/qFJh3gQOxiT6J7Z71x77fine78e/ObFrW74jrX0HIZqU3Vr5P0EmkeNy3ZuCdXHdTu9NwgEvCi6uVd8mRnEpe8KIakglihRWd4nayadhuA53kQjTsYLdXlD8gwHhRVfLqq3vErfpKOrNBFaux6zAvAUqv2S2hc0r/1fI1qGq04x1LnMvzBT2TZPaRJBrQbKMyiObwxVY1twYH43Tl/2hAMUJhHpFPCAsTJiQl2CPUigkG9LexU9G2rmaaYkSyWdvGcs4p0fYdynIIq8PiIWXUiim
 Tr63oHWl
 vGxG8fBhueVnIbQJIh+pCOOeBJj8jkxAabI2tegWrhDb6W8VyyfJOBhfT6Z8vIFoUZXqo7g8yZas+ociSUdz6yuePzPyEngb5iY9qPHuUq8mc/moimPloLmu3BSwyuswrVRCUYbnTiywzo3imJCh9jaB/Lk6vNBbaCnYOrR6WdJSJivjrw15V5ccGThlOlY2eWb1KhfhbEDkJf1g+UmRRhJzng5813BO8I5AS0eixpThSH9eeT5RNBO5dftkXRUejnAZme7PEls/M8T52cWj+wQRf3LGkraZ7ptZ09JYdQv3F4zLePPW9YIuUWFfHqwVJ1EAF6ixmmAZbDa+n/9ccUoG6VN0lDPoGmuXGFon5Kg4oiyB8dd9Zacb35ZIx/ByeIurKzve6DP5/02u7pWHvq5KLodeMJHP6vxYm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-10-11 at 03:52 +0800, Yuan-Hao Hsu wrote:
> On Wed, 07 Oct 2026 06:47:06 -0400, Rik van Riel wrote:
> > Since this is lockless, the PTEs could change under
> > us between when we walk them in folio_pte_batch_flags()
> > and the batched try_grab_folio().
> >=20
> > Is that race condition safe, or do we need to re-check
> > afterward that:
> > 1) the ptes still point at the same folio, and/or
> > 2) the folio still spans the entire range, and was
> > =C2=A0=C2=A0 not split before we grabbed the refcount?
>=20
> It is safe, because the batch only runs after the first page of the
> run has gone through the unchanged per-page path: the folio reference
> is already held (and for FOLL_PIN the _pincount already raised, with
> the smp_mb__after_atomic() in try_grab_folio_fast()) before any of
> the other ptes is read.
>=20
> 2) With that reference held the folio cannot be split:

You are right. The page tables can still be remapped
to point at something else after gup_fast_pte_range()
grabs a reference to the folio, but that can happen
no matter what precautions we take inside gup_fast,
because it can happen after gup_fast has returned.

I have no other concerns, so feel free to add my:

Reviewed-by: Rik van Riel <riel@surriel.com>


Could I convince you to take a look through my
earlier series to make regular GUP go faster?

If there are any issues left in that, I would
like to fix them before the maintainers get
around to reviewing that series:

https://lore.kernel.org/r/20260811025157.1632867-1-riel@surriel.com/

--=20
All Rights Reversed.

