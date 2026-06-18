Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38363CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A23C6B008C; Thu, 18 Jun 2026 08:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179416B0092; Thu, 18 Jun 2026 08:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7716B0093; Thu, 18 Jun 2026 08:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C01746B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:36:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 412051A06F8
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:08:30 +0000 (UTC)
X-FDA: 84892608780.22.138B87F
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7C978160011
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:08:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781777308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V13nUPG/cVMOpai43Rnu/Im2r1VdthgN61RiXX4t5Ng=;
	b=PjQtYCuir3JJO45ZBTcKq4WgHpCvPfcNaRE101WfWSSieIgjvUB0lLOkem5ofQRR+2T+up
	tkf73miM/Ha3TUW1nNHtqMED2sLBauDKDt0W/Wh5d0yFZ+nm6hGSBRjs1rLYtJalX2gCIi
	UuYLImXCvbYmutOVWiGwXX3j972qEPo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781777308;
	b=rovmsqIclDkFxm9h8geRo1upMlxE8uwfnKb8YIdl/ljiAJy4CjXVD6PD1LYU4sxvuH7HtS
	SiSedmpr2Uvk/BNYdWJ3XpFGRCsJ8M+Rx0aWht5lQy+Wo8Zy+PoB2fcD5idVNx+z9yTWiM
	IptN/XQmC0v26JebCLdppimrnJQhhb4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4ggxHz12shz5B7RN;
	Thu, 18 Jun 2026 18:08:15 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 65IA8AeP001695;
	Thu, 18 Jun 2026 18:08:10 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 18 Jun 2026 18:08:13 +0800 (CST)
X-Zmail-TransId: 2afb6a33c38d76c-c4b3a
X-Mailer: Zmail v1.0
Message-ID: <20260618180813523lpg_cRMfdaELojCmC8Ap2@zte.com.cn>
In-Reply-To: <a777b4ad-157b-464b-8cdf-feee9a6a03a1@kernel.org>
References: 20260618080411.3902214-1-wangkefeng.wang@huawei.com,a777b4ad-157b-464b-8cdf-feee9a6a03a1@kernel.org
Date: Thu, 18 Jun 2026 18:08:13 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>, <wangkefeng.wang@huawei.com>
Cc: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <chengming.zhou@linux.dev>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW06IHJlbW92ZSBQYWdlVHJhbnNDb21wb3VuZCgp?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 65IA8AeP001695
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Thu, 18 Jun 2026 18:08:15 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A33C38F.000/4ggxHz12shz5B7RN
X-Rspamd-Queue-Id: 7C978160011
X-Rspam-User: 
X-Stat-Signature: xgs8dxruzd1kttypq3z1di413jw5hc7j
X-Rspamd-Server: rspam08
X-HE-Tag: 1781777307-216913
X-HE-Meta: U2FsdGVkX19L+Fgix+IV6qyw3VMITaQZ4qrOMnukQnUJlnHF5xRIGqna321Au9R96e+ZIIyJsRvdJo0YShgESLOaYnU3T5E3w3K8TVKGTaFmZlOAX8rt3oNe2VEQIO/HNetc6jHoXPRVVltTxEgQnqm3RuKMVVfipSLcFH9r6ael+/bR2+/agAMl6CRshR3OpfbD8V/wo/ZFMIvD+0kTPKpMGBczxFKv45VuFZoqOKddcketb/qICKgh5AAqdub/u2WjvpYieBQKK+5cJ+n1/re0fsDbMpqyuRZn/lLREzYsZXabNMuvLGqmq5xkejPewpNQqZ6HCDlE+4hfqwj4RqSXOf9J6tWu+QHj3Ja67NKi//FVRG2/2v7kx/5Ah+keHEPKuvUEfpAn7hZau77Bga9madj8rUjYW/d98C/GE74fFx5IR7kdKyqKIU3CT0hSY7z+PNf5FEN/l3zLZSKQTKD3kW4IS9GL0aK0LYPMkowLvbqfzY5nHb9f7z7Jsi7KWKfhqxJStePC93jy3DwidCkRVplljas5rAp9P0qnL0HoT0oNVvjtl8fUqI6HYRAhXf4wrVghbGe0JU8NF5oyUOcdbfEKn+25nFKOXt1l0OVqLjzqP8PZe+WMG3+SZwFFNx6nfTlXK/931YqCz7OP4oy2ym77V4OZCOAwO1Bn/P0Bg/E7DFOgQFEJSzDdC0Uc3Xk9dcFq/qCMFaceAZGQsKV+sv42yGTAbPlGFgSkW1zmR2QJhTzBmll2N+HqblLPws/gRdg0q54KWKqIeJ3P7Dt3yx5O6r07ExELP5amL5MpzA2A1oR2uP6nOOI87SzOSgkOLKwtlLu/ZuqB7dRSH5TsFtBchNvJb654/cTraqQ3P6SZlEvuBi+mmhkSEjoTAY0Um8hPV+lUXM6hXNdhiA0cxN0z21Z/Q59bWafuqC+h0XIFcH11V2tKrTYktmSjsVMiHf/QOR1+PoPXiHi
 6QRY35Fg
 xTvxFd1eSE2GfLX6gfTA5sT/5qb/XC7i/0S0IiTOC5yib4OCp8DA52jLKTehoBIgzmQ+sizoQ+AZhAJPI/q5sqRIINxUxN0M8UBqgcHRl70Vc3xViegXp3GT5dR249Qj+3GGT7mn/Z8KyJmz9WzBDaSWUnFSfgU5l7IIY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Nice, but ...
> 
> we already have
> 
>     struct folio *folio = page_folio(page);
> 
> And we know that we work on folios.
> 
> So can't we just work on folios?

I think this will work.

> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..41ab25aa2a82 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2327,23 +2327,24 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
>         tree_rmap_item =
>                 unstable_tree_search_insert(rmap_item, page, &tree_page);
>         if (tree_rmap_item) {
> +               struct folio *tree_folio;
>                 bool split;
>  
>                 kfolio = try_to_merge_two_pages(rmap_item, page,
>                                                 tree_rmap_item, tree_page);
> +               tree_folio = page_folio(tree_page);
>                 /*
> -                * If both pages we tried to merge belong to the same compound
> -                * page, then we actually ended up increasing the reference
> -                * count of the same compound page twice, and split_huge_page
> -                * failed.
> +                * If both pages we tried to merge belong to the same (large)
> +                * folio, then we actually ended up increasing the reference
> +                * count of the same folio twice, and split_huge_page failed.
> +                *
>                  * Here we set a flag if that happened, and we use it later to
> -                * try split_huge_page again. Since we call put_page right
> +                * try split_huge_page again. Since we call folio_put() right
>                  * afterwards, the reference count will be correct and
>                  * split_huge_page should succeed.
>                  */
> -               split = PageTransCompound(page)
> -                       && compound_head(page) == compound_head(tree_page);
> -               put_page(tree_page);
> +               split = folio == tree_folio;
> +               folio_put(tree_folio);
>                 if (kfolio) {
>                         /*
>                          * The pages were successfully merged: insert new
> 
> 
> 
> I'd assume we don't need a check for folio_test_large(). We'd have to double check whether
> folio is still valid after try_to_merge_two_pages() succeeded, or whether we have to re-fetch it.

It doesn't matter whether folio is still valid after try_to_merge_two_pages() succeeded, because
if when try_to_merge_two_pages() succeeded, we don't care the flag 'split'.

