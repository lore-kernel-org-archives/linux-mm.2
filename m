Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F64CCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B5D8E001C; Tue, 16 Sep 2025 14:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872F38E0001; Tue, 16 Sep 2025 14:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B01E8E001C; Tue, 16 Sep 2025 14:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68EE08E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:14:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A8AC1602BD
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:14:28 +0000 (UTC)
X-FDA: 83895913416.27.9303B0D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7CF0520010
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:14:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FPptwNAT
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758046466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZV7El7YGxmlz108yuF8N3muYpMbWywieV23Vjsw9B0=;
	b=pPGBMza7/IPmN29NIRk/narLt7EnL58kGXhKeDYqmHzVTpJENsBeZz0OQg3v00Yo+ZeEdp
	BCarjaxgdIlfLoNCzjNqdr0FTlMyQZW5PwBL1mWDYfOVfpHZcaoPoa4c9pdsdy8oj7l5y/
	B3x2M1ywTvw3moJ9SG2K7Zk4Ib22GPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758046466; a=rsa-sha256;
	cv=none;
	b=ozMWxK0JBJ7c0+AoTlDjifUZH+NgmFOrxqtgijHfo0hvk716QhAUNPTK8gdDyoS2x1H6II
	L7Dy33hG0Xv85xqLwfyYG9zGWKR5H1lEsKsVpyFaWSFjqr/SOMdkWn0GA2kCrXPWbN5imM
	Or/hIau48i0GQzn9HtdEwfRoD5vqs80=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FPptwNAT;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cZV7El7YGxmlz108yuF8N3muYpMbWywieV23Vjsw9B0=; b=FPptwNATr3c1vKuLLVIxeSk5FE
	poxZ6Rh1dvntHrkbjN54U04RbWtn+QIHQjEuhzBGuCFu4QFLlHX7J3BHAqAhsykgyDrpdUVpQVznu
	ONkmZXbrTlJemrlaKzfpL4ZKcSDuzz4apP3CfaeXkge45UXAa9Dyb0W1ue50BbTBN343R2ekH2ymC
	qSryiQJEaTX/1y+YlbMdpp/PnKipYgyIZVEukrAXvKG8Ng+zuzWapTVrY9oR860lM9RaQzWGM2o6M
	aZhb2eOQ0R5pKZKUYyuoY7igXRcKblMD1RuRiNzs0g3TYeGucnypeWGnis9X8vFJVx3Sj1g3Ml5/G
	mHaoM5BQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyaC6-0000000A6m8-0zbY;
	Tue, 16 Sep 2025 18:14:22 +0000
Date: Tue, 16 Sep 2025 19:14:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Longlong Xia <xialonglong@kylinos.cn>
Cc: akpm@linux-foundation.org, david@redhat.com, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/1] mm/ksm: remove page_stable_node() and use
 folio_stable_node() directly
Message-ID: <aMmo_oXbKsed--QV@casper.infradead.org>
References: <20250916080533.2385624-1-xialonglong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916080533.2385624-1-xialonglong@kylinos.cn>
X-Stat-Signature: dnyxsbdww1k6ccqj3qzd7qu9tnahuhci
X-Rspamd-Queue-Id: 7CF0520010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758046466-242768
X-HE-Meta: U2FsdGVkX19mG8hxzN05Y3yBIbe7yesG8b839L+lF+uquH/MaDwNKWbTcSC/9V/CGhRsoqC4IQMbhVgnwO5CCfKdzM/8ws5RK063p8KE3i2+NWpPyRMzzZQhObrt1yNqoHVgWyVhwZf1aF9IH02hLnuwKLIcs0xlDr1JjgbuJ+gbZcTf11KRk+7GjIF47arBH2cpKsOsxvc41fRpo2nuoKiWgjZM7zxLMvrJPR9NSAM86Wp75AeZr88UtF7SMwAjaeBT3h3cssuX00P/OCyCJykQv2NvL5t2BTH0KJq+tjo1BJBnpj2ZIg3N2ekK00EVWvOESVhqI6r5UmUK7FIOlnZMrbZmImvSFj449V7SH5oRY0AYcMroms4BaRs4pZKGBMA8zc0t0f9LpND6KcXAErClfgXTWwMYB9b2XzXKrBZDP63qR2b/1+j2gHYs8fpJhq5NJ80pjmHDy3vYBbbzQ9/G06M4ZnPJvCiEv2xbcN5jyWlpGAkdoukgWQcNlxTKdQ6BoJbw2LDEpeDYiyabNaKwA7ZlUlgbiKxJsd15iSmMEBJ6sDM5ebRiRTD2vQT4hBJ1Dd3GWydgKCt/kM01C0SEMhP6nX6wZAHZeYWR4e3uDlM8jji9Pob+Ce8RNeua5077jGK/Fkr4r0fBlMys3hfZlh5gEMl/+ZkMh1JicomyUehmyYLeNVbDu32nsfib1P+oLC8dS9ADANidZI4cagcSuGHdBCUrCaetJdFlX1OtapndJWoDb/bj890Et+YLKflO4S4Uqc691urq1hPFf3gA19xuUprrruZ/rgacEhUvRoDEYQqPAihhHpUmZ7OSqTyf1bPzEmLdvTL/h6Hqf2vLvsjN7JWf5xQh8cT1kQ45pU7e67JsQClIiHNDbsaP9a9ffsFrCCWzZ3NEkKfrAdA71zQ1ZO6ZSfAZYr3WSI+Jvjy7MLf5iG89C0oltA3jsB5auDc0Bc0+C2S3dlG
 W+plhq6n
 IEuhH1oxYdrI5cTCo3c+xKyBcDQgRALDbqwZLsBURjT5hbgvZQFUHOr60SzXzeSfSUbKW1DTWXrOyL8YbIX4sjjK+6lpV58IzoicGJ/YlBIIfjt4dmSjP9d8mUMgWJcUMPKc+cycIqaMG8A81dgdP4EWaJygBDCyiogL6+pRAMfvUcfRTz8rZYAAydLkTSRr2vBqlxteRD8nJIq/24UQRrGRfq9Mq+eivxQMi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 04:05:33PM +0800, Longlong Xia wrote:
> The page_stable_node() function was a trivial wrapper around
> folio_stable_node() that had only one call site. Remove this
> unnecessary helper and call folio_stable_node(page_folio(page))
> directly at that site.There is no functional change.

I just sent a replacement for this patch as a reply.  I've been sitting
on it since last December as it didn't really feel important nough to
send, but if people are going to try to do this kind of thing, may as
well do it properly.

