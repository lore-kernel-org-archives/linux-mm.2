Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F8CC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D6A6B00C5; Tue,  4 Aug 2026 17:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D531D6B00C7; Tue,  4 Aug 2026 17:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6CA06B00C9; Tue,  4 Aug 2026 17:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A51EB6B00C5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:23:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 204C4C02F3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:23:33 +0000 (UTC)
X-FDA: 85064863506.03.F308979
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id E6A3D180005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:23:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AfSXrRDx;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785878611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfP/6kO/mdLo3/KbGIYKYnGzsR8tUbD5DUupz4bpY6s=;
	b=RWqXDqI5eFyyqwxZy76A1rTEk3A/ClfRngRfIzVPrtZpavQw83AmWAd5auy5YXkcBMK9Xq
	3qmLuiM+xiFvDuKnLhd4t8MC3k6PcbZOnXdwRmUaxBtuZisyn+v6XheNvkxwcV2jk58hDs
	myL0t7Y1qEjy0CtU6AEMMDX/GXIV+GA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785878611;
	b=dd4iL+GkHaqi+8Xbcpl14qf+dbL7sk/kn75uvQEpr4I9MXD6QF65qVUJwUMR14hjUZ+ZUB
	PSylVXo0nX1lVrHEB2jaemz1LQzyjQPbB5JnA/7Gzeix1AWpQqG4UGeTkEuUAh5zNl2sCC
	hMDeLTYYWNabyYsyMrJzbrTN5Kl5GQ0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AfSXrRDx;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ff20870ac7so2154986d6.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785878610; x=1786483410; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yfP/6kO/mdLo3/KbGIYKYnGzsR8tUbD5DUupz4bpY6s=;
        b=AfSXrRDxtth8n8bfPbhxlJSZNpPbB+Tzei/jQ7aYCMrIxhcbARiYklxmsToWISyUlZ
         cwUjxT5NzugmnrJ4OWlOedLk86KNRRES0Oi584eBE3scs2sv21tcWTHLqXxEtCi1Vq4u
         Eh9XF9yn8ShhRHrcGKcTUZpdx/DDvdxvY0i2pNc2hvAW5xoZQO/FQXewIGHA+S0s8KZy
         PmjzzrebnM7eGxeg7UFCLWvSJxG/qw0HX/Fk1btr7DV0H9ybKXvuf3DVLXRjwEdH1UFO
         ko/jKQbqxcq2aq1+dhP0JZwR2bhFaUIcMeXcBWwKJBYfclW4ZWy7d4mOgv/fdLC5/Kng
         nNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785878610; x=1786483410;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yfP/6kO/mdLo3/KbGIYKYnGzsR8tUbD5DUupz4bpY6s=;
        b=dZrhm/Gux3LdRI1pj635Gkycw79xI3sT4mG+bU4N8eLZu8FttLVLwPUNWPVweMbfJm
         lQk5WCqlp6BL7coi+xX5PLSciZxGvObr6jyEq0Ge/u1GEhfXMoxYEZ8yh2xVRq712JW7
         /PykFm5pp9mHN6YM5tme/bZB0FVPwrHQy0fKAieuE32X6ASuyEgqZw3O3d8IZGHTLD2S
         HkNG0pEslWslpwjxahbxngeP34QNCafvqueR4tEkLA4bZoKE7Fuc2neSYX5q3F3JXoaT
         6a6WX0X0FdyAPnPQuFHzkj6KTd6jF8owca02uo/FEf0MUezq4ZfgPCxEi+qX+2v2g30r
         olkA==
X-Forwarded-Encrypted: i=1; AHgh+Rq1opqpCzHGQ3owME7GNF0aOMeiZC6c3rrNu6DtMp6N2lh1L5Xpysls7Faie7WzamFgU3fuUKDUGQ==@kvack.org
X-Gm-Message-State: AOJu0YwBSDU6kAAfjWQWY2MR7pmu+I67ZRB17lOHJ9Jyq28SiqOpWAov
	/4wrto32fAzHUUnE2vJeYkRRNMoydTKzGtjIAre+k8ay081orkBcizKZkQ/iqGuFOCo=
X-Gm-Gg: AR+sD12XIETw/W2pPDvRbHkqKRiGUTk8WjuPshDqKsGwfK0QHM0X0BnFHv9WifujBdb
	ofeb+p2vGIorr9cSS56ChTAvf/2ZhvSATcWlvhEtlx8LkwzNCOGfLShQUyGpoJMjBejMyu/FLE3
	JbZw781t1sA6cqJxyAMj81dm+J0Lm+W0q2ksOQ/FNh0YQEi5BBLrymH1ss49/j+15ZkvpS6YI7W
	2v6Qc5CoTACEFvAhG3LdpzQoDBd27egTsaMFCSIAkNQ/cRRUaA95nB/Xee9eBGG44aFBjqobxsl
	WuRc0HWMbSZHNYl+9fDIugjo3kr9rmOaa5cyzXIlVgAQEFCmYckD0JVI8KfvbYFlHYYGgknJmHS
	LP1CbggE6iYJ49C7JxfxF27wbKVU9ugJt2f5ESExF7Y6MbPSLzggXIR7h6uoHTbxLVkxDE7bu8M
	+qJSnp+YGVd0dNNZh8UlI9ggm2PNRG/bJ0GQHMBCgME7XttLSqHR714gEAbVY4mDXd+SZ6t/O1A
	KfyZJhrcWyyUHKnQvvMGQrh0zzFD1B9R9hzWjIqFweW
X-Received: by 2002:a05:6214:e8b:b0:8ef:b049:7e35 with SMTP id 6a1803df08f44-908813c46a4mr27285526d6.31.1785878609934;
        Tue, 04 Aug 2026 14:23:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908800cabedsm10767526d6.46.2026.08.04.14.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 14:23:29 -0700 (PDT)
Date: Tue, 4 Aug 2026 17:23:27 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 12/15] filemap: Remove checks in
 mapping_set_folio_order_range()
Message-ID: <anJYKOiKFoqLSTTo@gourry-fedora-PF4VCD3F>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-13-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731200802.574821-13-willy@infradead.org>
X-Rspamd-Queue-Id: E6A3D180005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3s98837xmbqpea681wyuxmqkt57gjd3b
X-HE-Tag: 1785878610-65438
X-HE-Meta: U2FsdGVkX1/j8ZyEvgVYXzexdHk1xvRQiCYvWt2DONN6XclBwxRktq0CZbhh688PMVSE860Co6e8hh4bvAc1YNaRm18JxU79/UiisBHYCe9WmhkePMx8fET1IfzlORxoOPThEu8BYt30DaC60dVDz6TpRFqKdNKk/iSf4jQIbt9H+qsTIR22J52MVyGAh9e5EV2tx+LI7WAcW+GV6+TXj25787AOztttxoJ2zucJu0rzhg+Tp3uIz3sqFktvNzbUFBb3xsys7DPzSni3gDDdw+3Coc4dzHqcyuPqIwLd7JtNxpogNe8J7pqLGAQhi3itAHzoJVqRr7taU/YpPXFmP6a7NuxIKnzjyaP4NP9EEvg1bOtPQZYsjvn22jOsspoE3BC01ieUFe/NwhZvp0Q/B75At6ktb8llFSEQZdjxCBDOZuuKvXQUXqZg8vE2DbB0+0Fmg2tKejY/PfSUXlJnw8w1m42FdTPFqxxckQbJ92clj14cYS80Gszqx/lktzLJ5T151TDXASiooimo/GndYNwiaPl7R70Hox56QnSFAOY8kOwbodf15dbcycFzn/svlE1h2RTpeACh2QmtWO7KHoFLNRxbZMAqgfxYg/GywYzZPkoEQjXEUkQVoIZcU2x2EO93BAeJKu4PDXgHy5EDGURZvLYk1HwLdwWgpYvNPvfbj56LQlxcf7XNhM+5B/MHZ+538cKn4UZas74cq5SuLlvm0SV8zmHtFc+yO6QHWaCfVwCQlBMT+oax1Q/B7NXl150IBqKR83kawl+GLGHaMH5HtrpervIhSyz1OaPDBskm2HX9Oq/ZK7xxabSsIon8GNPskPHxLYDP98wGvYr3Bqt+Mz/eUJ2+AYDBZr8xExTK1uwfQy5bHC666K5vuvmsc3n60ASlX20T7ajVkqC0VjBENytZ4jC/z3QSjfonsZwIBmyIcKEvpTt2t8zAuDmS4eGAUlOK/LBOnOK4YHh
 y5giDCtR
 5ejd3aM/Gbzf9MwByF1N9r7WMzQcIAGqLM5RvR89pY8CpyVMVf3ZjY4/lGGXakYfWCCFrQfDIQr7YSwMb8GA1s2sxHR6Z67jA9iLpOeLXSze3IL4CdZYqdAuVY5kQf7HMYiAGqoKRwL5SPKCD4Gd95o9mhIkle08Lb6y0hDK7wryTcQ7tsBdp9hHkSGku48/lDqHOPV7U0KFVHpuUNLzxJXgJoQnR3fb78F1pA0qfsQ3jhNH+mGW6iHk3ACWNcXJimi2tgjkgKdefBuvJhNCsEj5sbP03sXk67baK5UdSYeuux79yQpJWS10J9ur+6TTewV8oSgw6/8hVPzgEWKv/FqeMgx3ObPW9wBrSyXK+SH1DtaUbai3+hgfDOlnp3MyjV9ebd+DtyhJOMEWxuiqnMjIOTee8gY4Y4kAlrb1pFPwQB/6eZ9+BRdXlfJQltVUzujRSuN4yU/tGIUo6DHHC9Rwjqa02/a34exWGCuOI5xyI3T8Lfz+zuCiICk0VweVs2Jqi7tz3t0po9R1wzC8Gdgzh28Baw+Zv5/bp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 09:07:57PM +0100, Matthew Wilcox (Oracle) wrote:
>   *
> + * hugetlb calls this with orders larger than MAX_PAGECACHE_ORDER.
> + * Normal filesystems should not do this.

Any static way to enforce this?

Otherwise

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

