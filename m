Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B23AEB28ED
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 08:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4DC6B0089; Fri,  6 Feb 2026 03:39:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92A46B0092; Fri,  6 Feb 2026 03:39:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2896B0093; Fri,  6 Feb 2026 03:39:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5346B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:39:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E83E8B788
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:39:08 +0000 (UTC)
X-FDA: 84413381976.06.D05D542
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf04.hostedemail.com (Postfix) with ESMTP id 56C6740005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:39:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770367146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oedJcNMmq9NjWzUkUh5EtEydrclz4I/fjF2DDPnKBmM=;
	b=okp2bOelKMgY4F9nKzU+OriCAssDxp9HHHELhVx5oZWS6ts/ce3N1yHiqS7yGOTawgDnFA
	TNfjkJhR5DaIxF609JlZMI5yivhyhKqKi9tzBO/vtcD5Liu3cjm8rb3w4CjGwq6kMKr814
	lwAhndRoyT7wwsnAbq8fNWEQYAK5znY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770367146; a=rsa-sha256;
	cv=none;
	b=F9wgN5K95BgGjDEuQOup2+TxG1BzvMhR44DYfMIx6B901dGazYIQ6s+RjTdJH1eMrqhqxq
	ax2Qbn/qAQuOyyDMgKtUbZE80h9nxl25QWJU6XwfV9U9RF18mqpjQDOrkCMYjVKOFMTvz8
	D/4ky9kNQabp1ken04ar3WhqrPgf+UU=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4f6nYw5S4Pz8Xs77;
	Fri, 06 Feb 2026 16:39:00 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6168cmLo061704;
	Fri, 6 Feb 2026 16:38:48 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Feb 2026 16:38:50 +0800 (CST)
X-Zmail-TransId: 2afc6985a89a9f1-74dc4
X-Mailer: Zmail v1.0
Message-ID: <20260206163850402hEblYPDgLSG4M7CT1ju2G@zte.com.cn>
In-Reply-To: <a1d5bb75-3222-4863-a24a-4343b25ca6b7@kernel.org>
References: 202602061522548871ohgXN8z0qq87sTSX-yZc@zte.com.cn,a1d5bb75-3222-4863-a24a-4343b25ca6b7@kernel.org
Date: Fri, 6 Feb 2026 16:38:50 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <hughd@google.com>, <wang.yaxin@zte.com.cn>, <yang.yang29@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IGtzbTogaW5pdGlhbGl6ZSBybWFwIHZhbHVlcyBkaXJlY3RseSBhbmQgbWFrZSB0aGVtIGNvbnN0?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6168cmLo061704
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Fri, 06 Feb 2026 16:39:00 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6985A8A4.000/4f6nYw5S4Pz8Xs77
X-Rspam-User: 
X-Rspamd-Queue-Id: 56C6740005
X-Rspamd-Server: rspam07
X-Stat-Signature: ztqo7m4hd3a4yjypaapbyeryir6k3fiq
X-HE-Tag: 1770367144-569127
X-HE-Meta: U2FsdGVkX1/icML7RIhBAxbomqJdWcsXg9PrxWFXkaa3zrDHt+6L1BmGyxRJRNKdACEVdbKGTn+Srm4Fb5ZI0ZVkrlKprPXedAvqr2yPwP+LlGb8TQnpPhwx3/TK4MiKFKZoowkV1i6HU4rhXoNjM8gW7RSkhR8X33e2ZW9ej3ci1PDMh6SCcflP72HtWOcNVN06nVzPObjpb4TF2doL73cm6EjuG/eSJ126/7FTZHA3D2lqh2wUEyX78advoGF1vDtg51ktHd+d2u0URcCLXT/0LqomTORJuDw+NYoCcradzngK9QR49UIqJZLvjNZoLI89JOmvWh0JxoRYfwko4Kw23KbKKf7auld0Rfchp81C9vPG7biHBc9fHysx0M4YbwoAgVB864NANsJW/L0jGnYKPQ9uuovIHcOEcTEHDhg4C68vPvKx7MebQ+IWTPLy3d920TwVEKBVc7Gd+yDVuhk0UX3PgKrS9q+dgXeKJjw9P/2ht3OmVPXFtr+8GbOk3TDFFNqQq4NhpWDS+ERPaaM+UfV0O0IB9dIBCeSgAmCZdwojEanE/cT7ewRFOXeG/3oS8lmV9Sr8R1Ik6CVzoR60L24H6DljvQlfbYsyv6b68yACCQEt81k5y9BV5mIdBwXCJ4+aKg7yNEV2gO1JcIe75XquTznXm3nEA9dCTcKQUtnAt2TvYlV5zg/nN1RvCqTipCJZu9+vtDeEjIf2JzmpvSg2l0oTIetUYY7iIGddDrHEsHFIgHTz9JXQJK5ZCBLeDvch6t+0SZTj3HgHciMs2fP92ZJqzIA4QAZlXWKsLVAnV13KPhHgMm9IG6jooymgAyfTr0he3K5c6r1HOaQI/NbXz62e82Nbz8x6AtME9c30zqDMnpUAZJYRu2s4vzch1k7Y7cFcFUW9C7eKZnobkf8IqOikLhL4uE3rj/JU8uy+s0POlZx9L0QsWG47zTk8CwZzP+4Cz1kYHFa
 QJwZJs8e
 8ZYSFhcCzKiUS8kd7B8m0jj4WJDR+IR8Arotqdv/NMSOChSfw6yN4diohhSZyosm7VkVpVE4OdFX5DYHYe0cSJwVTeMM6BPboD9vQcHbpW3TXVg5Rv+q1R0qC4sk1rbySVPospGPS7fZf/oowZH98U+mViIP5nUtaJQQikLdlUxjz7zQXDeT86kdA1FtVr36hP2W6eS09cARHucP6y60pQvQdne/jjZucMeO2z603c8k5qsc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Considering that commit 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by passing
> > a suitable addressrange") seems to have already been merged, this new patch is
> > proposed to address the issue raised by David at:
> > 
> > https://lore.kernel.org/all/ba03780a-fd65-4a03-97de-bc0905106260@kernel.org/
> > 
> > This initialize rmap values (addr, pgoff_start, pgoff_end) directly and
> > make them const to make code more robust. Besides, since KSM folios are always
> > order-0, so folio_nr_pages(KSM folio) is always 1, so the line:
> > 
> > 	"pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"
> > 
> > becomes directly:
> > 
> > 	"pgoff_end = pgoff_start;"
> > 
> > The test reproducer of rmap_walk_ksm can be found at:
> > https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/
> 
> Thanks!
> 
> > 
> > Fixes: 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by passing a suitable addressrange")
> > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> 
> The patch does not seem to be upstream / in mm-stable yet.
> 
> Can you resend the original patch with these changes included and the 
> reproducer referenced in the updated patch description?

Sure, I thought the original patch was merged in linux-next.

> 
> Thanks!
> 
> > ---
> >   mm/ksm.c | 13 +++++--------
> >   1 file changed, 5 insertions(+), 8 deletions(-)
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 031c17e4ada6..c7ca117024a4 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -3171,8 +3171,11 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> >   		struct anon_vma *anon_vma = rmap_item->anon_vma;
> >   		struct anon_vma_chain *vmac;
> >   		struct vm_area_struct *vma;
> > -		unsigned long addr;
> > -		pgoff_t pgoff_start, pgoff_end;
> > +		/* Ignore the stable/unstable/sqnr flags */
> > +		const unsigned long addr = rmap_item->address & PAGE_MASK;
> > +		const pgoff_t pgoff_start = rmap_item->address >> PAGE_SHIFT;
> > +		/* KSM folios are always order-0 normal pages */
> > +		const pgoff_t pgoff_end = pgoff_start;
> 
> I would move them all the way up, above the "struct anon_vma *anon_vma = 
> rmap_item->anon_vma;"

Yes, that looks better indeed.

> 
> -- 
> Cheers,
> 
> David

