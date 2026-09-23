Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 124CEC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 19:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266F96B008C; Wed, 23 Sep 2026 15:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216946B0092; Wed, 23 Sep 2026 15:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156226B0093; Wed, 23 Sep 2026 15:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E64D16B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:34:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E26E808F1
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:34:52 +0000 (UTC)
X-FDA: 85246029624.11.E2B2665
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 05BC74000B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:34:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="blR1CfZ/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790192090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MC7bV1KDRC3HAA0Rfk68aX2zLG1AyMKOviMoLr6oKFE=;
	b=b1TdAuabd4NnJde5kNfa/aB/3ZmO1knPt0V+u6qk3rIFxl4AFu8zNzYluJFiJIH3KbDl0c
	qKzKYT4xeuLWPJ0GSs/scCtzhwF8Em3qq8GFrv+JnWtkMWxHdEz0SgnLxaYw8ZKJOy4T6Y
	QeAXVRUANXsIYF23SzNoAJbqFq4b/bc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="blR1CfZ/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790192090;
	b=JxYZe6NzuMQvWz+B7gWeRFu6D4vtwrvgH9x9LPyaGnM1lB6xBcYsVNJJol1gbOl4eU0QIU
	sRqBZEtQ4s5oIatUfUpicDsA9TuXvSpMswWxJQUa9vUMlDoasv0wuYMYpZ+Q3RaE8ybSh9
	kbRKe8p2M/o8b3Y0cYDw75SfQutMGGw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MC7bV1KDRC3HAA0Rfk68aX2zLG1AyMKOviMoLr6oKFE=; b=blR1CfZ/ar4yWsnTXxlRiOfmqL
	wcUAcB+fSXQGdvYzGqfCtXoSj/AowUSXI+fw0u4iXUftBNriZzYVBRA+RZovC9aiV2RAuAw9XyRnG
	ZPwdXA887Gbu2lqgB7XCh/7nATWVn4CGY90jT/Re7CgbPl0cXGFTCN9LdLZqv2bcyrBCVVW1hCqcU
	FR1xZ087BQPFlcLIQkrzp9Ajxj1Fq2BhqoGjDwNfTO6SMf12IrPkrdqKv9ksZvDTBO9rHQ4LVRFKz
	6OZosb1GC1v+FXYgXWesG9xUPNIUD4PVWs2dFmf1uZo/w+GGj/qQDA34tjicCSgFh1eFnLUIUcDaq
	kAXOCoiA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9Sjl-0000000EFZU-0Xhc;
	Wed, 23 Sep 2026 19:34:37 +0000
Date: Wed, 23 Sep 2026 20:34:36 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v9 09/15] mm: Remove locking mf_mutex in
 is_raw_hwpoison_page_in_hugepage()
Message-ID: <arQpzFI6KzFNWk5w@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-10-willy@infradead.org>
 <6c6968e8-b644-86d1-97d1-236170e9dc3c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c6968e8-b644-86d1-97d1-236170e9dc3c@huawei.com>
X-Rspam-User: 
X-Stat-Signature: ndsxmc7774geg3fep5mkbbpwj6waxk8z
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05BC74000B
X-HE-Tag: 1790192089-947445
X-HE-Meta: U2FsdGVkX18858gbp4yJQF1lYSM02qY92BtSLCbePfhWb3KyIGNBH1Gwc9cA2Eye5zg/1oD1cxOpz1bt95lhCY9ED8HBgcNUirbl1v9vy3c72+BMdqG2ONNgEndruhqaHMe3KmRSW+hbNeCBwNtVEAztjvKAVXM3X0z57+m+UCzbhjpowbNXvXCnRprQhgahsxxjIFiLvZhrPYB3KZjCZes35NJ/BRz3tk498V2ure+eSzxzbgwojzds63dvXlIF7XjkZw6OdRlEDk6vCbKenTcr5x5RxN5V7xsK9ylgVI6EEjqq7gYBJJvfdJ3PWZ7N9kWQlVUiOMmmAR3C9uZRu9ue4Nl3u1NboOLl4UXajr7s9ssFZPUP0ReHWBADOoGGYl3jINVHu0yRnnrnzt1K4I46oF0am8OzLCgMSalj6+Yi8FPGVvYG7uvZy2lM3jx6VP2kfCox731r4+DJ5gOe5BaigwpUG3hRHS15nf8sj+RYaXoM13LHv4a4AHvhA2ag+MKTT7W/A6H1vmTq/gvMMmaodzV8frjGcgnSD2Iiif+j4u/aXbV2WWXdzu5opLdfmvdrQigY07SRJkwU9ZHQH7qJmz4ElayzaYGDN+n1EqxT+1kZrb7Ol5op3gm4Tw5zUfdCTdvbR9/smFIIpQseO+p0EntN8wdHzsP8IdBAppkzCBveZ4RnvzaO2t/TpbPBP4aytp9yot4/35HwVi8AiacX+7B8gPzPrbQwzHKCN30Kf8rWZi9H/txVBoWnzchVoHGRYTRMYnC9ffZUzJv1YebacovSJNMvJtQYA1TGwp0+LaWlZ05ftLGZieN5dLWpKoAJJTE1lWyEgO0igrbO9qPYJz6hDi3xwLYxQAX6TODAeSRW4by/HgkfZxTHf1Yz0be8t7on71DutdMEYXtlIJ64Y5MUe8QvaoWb/0V9m6aklDrbv0G0cp7IL6Pt6FBCi61dmr+hfuH1ZC7N05Q
 XfWsq7F/
 eER5fGZgrDKI2eBnz95FLLxJPbmWaDIdFIu2PRFDjEFR3zI7GnAKfGkgt0fihINVqfIV78tczk+n/78QERCtTwl/0OEjABxdyrVtto+HesuLHIJ9BVzL+Ps5w33XYJg0c1OCN/fpF4K3cSCgKoQfuFsy5e2os6Ze/m/BiKV5D+zW0eMYVrzIJJpQ8Rh+pNo1xOhCIlmXpXpU8CxLZb4e2GBdfpTt6gLc7SqpSvR81/qnjF4OdPF4CykyCAW9+CfWqNuhSl4BILhxI5jjaDspHXtK/Xr1Bxu1797tKpFy9bh+b1W+BgLi4+g/SWCsC1WVYqn8f4NE8vcpTHBsK2tNurosV9h7lU9PT+7Lx39X7wvPentM8+5FPJjZAiDY+H8ailV1IslqK/IwfpsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 02:35:25PM +0800, Miaohe Lin wrote:
> > @@ -499,7 +499,7 @@ struct folio {
> >  			void *_hugetlb_subpool;
> >  			void *_hugetlb_cgroup;
> >  			void *_hugetlb_cgroup_rsvd;
> > -			void *_hugetlb_hwpoison;
> > +			struct hwp_page *hugetlb_hwpoison;
> 
> It might be better to rename it as _hugetlb_hwpoison, i.e. with "_" prefix,
> to keep the naming style consistant. Anyway:

The '_' prefix means "don't use directly", but there's no reason not to
use it directly.

> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> 
> Thanks.
> .

