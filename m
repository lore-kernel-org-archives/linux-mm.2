Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 860F1C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A20B96B0104; Tue,  4 Aug 2026 11:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1E86B0108; Tue,  4 Aug 2026 11:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFF56B0109; Tue,  4 Aug 2026 11:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5416B0104
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:46:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01C78A0243
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:46:55 +0000 (UTC)
X-FDA: 85064015232.16.972722C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id B00354000A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:46:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="C5Hi/CYQ";
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785858414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=No2AlOpVpiMo9L5YjZVP0hbFpt5iqBLbhuLbStEN1Ok=;
	b=fkboCgfRGkendhXZEwfr8Jqhs/y02GtS1eXRHU8dbMc9psb9WjSD58YVlinJLkaUTGoD3R
	5gOBFOVjteRlGze+7T6hqeL9Vo4uMs62HINSOftT1+DLTvpsXtcaaHWhgm2QkYxkjqj/ml
	PFd8cKZES1xQ8s5I4VkxxI/02jQZZYQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785858414;
	b=Bh02yeeLKu+fX4xMXFBBLFbJ+T5wMgB87zpxSn256eHFXOV/cxLcto9WZCHCW4ZCEiIRHb
	5zBtSZeq+q/vMXd7k/DAS8IueOtktpyVQUClP+WwmqFM4oHxQUQyklGdNpIILifHg99Pwz
	cR6N0flLRNRxlJI3KvM8EBbcQbjqNGo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="C5Hi/CYQ";
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=No2AlOpVpiMo9L5YjZVP0hbFpt5iqBLbhuLbStEN1Ok=; b=C5Hi/CYQ85Cm4C6FcX5YnP5HpO
	+vWVNRnPQisyCy15f5qnKcfDnZ1ybd3gBXMhWehr4wAhGGVSvJDQmfwp4V755VOh5KHheO3fxyuti
	nldJ2ebik7yG63zkAvhf6LZzYvoIwxiWho+TcOvzmPmZDrpi93YppyMb+GMoYWOdDit/Szvbh0kok
	BhDevoV1YLCwUOaeFF9k3M3bnNlkN8O1uMru3nZOFf4XSOA+sAZTeiP+LUXJ7qAv8CQbr1fUf9Rv0
	ojXEyaZRc6wXdDwtfNe2ffV6k63gsLd6y5XFz4Ew5YYaLqk7Df4xGGjBhOKVu1u7sMIWXbP+jysxQ
	L3u5oBtw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrHLt-000000049Sf-0qQq;
	Tue, 04 Aug 2026 15:46:49 +0000
Date: Tue, 4 Aug 2026 16:46:48 +0100
From: Matthew Wilcox <willy@infradead.org>
To: jane.chu@oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 06/15] kpageflags: Use is_page_hwpoison() to set
 KPF_HWPOISON
Message-ID: <anIJaPXquzQrnCdK@casper.infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-7-willy@infradead.org>
 <7a72bcaa-06ed-4485-954b-2376f754eebd@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a72bcaa-06ed-4485-954b-2376f754eebd@oracle.com>
X-Rspamd-Queue-Id: B00354000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9rsx9qekn7mg9cn1gd9grato8kyho5rm
X-HE-Tag: 1785858413-834003
X-HE-Meta: U2FsdGVkX19L9wBtOE9DoDJFgCkzuZQ/+HhW0vS6nwbK2g+5/aP+cjznjUSgY7fDSeDM8B2v3uewpD+QDbktFpBLaBL9G0UbJ7RBavR6RJewtmSeLstbJ6SKxKPo8IaKwjqGRJA4dnOfeUdWwvUshxDL0OgDGG7AMJN4329vcIbJsS46TmGVosLSNyLK5LSfhvHUypgtxTdEJa2jZXWQVhREtN9aF6YB6tYZoOPFjAqLhw1k2UgZxN4R4/2DrEGnV0zXRqMiqiHBKqTy7k4qhfnFI1/mQLgXE/RUbh90VgHSiVgCiXR0G+QGgQOUIib2y1hH5qtXGBefNRxf34T5t8eZAf7tE7Rc79Er/Ygen9y4heUempGe2Yd8dshZ3L/wIJTppY0uAGOrliFUaQeIU1ZBMm+O5oeYMYYXMBenZq3BELqQgWBl6Ty3EV3uBENB0S7e+8QyuOZCmMwIE7youwsiBoODxhI97A3MSOhXSIHf+YQE8HaG8d7AaKyNurnHxwupUSje+QM0MGQzs1br2CAjezqiZ/0r4ImN5wsHRbpNymtA/GHQR4ICBstS+up5+HXDL7vcz1NmKiB15bKy5rfQH5CdAonQEngfs+VH70bYO/rxgCZcZ0C6NO/xA6tE4NIUfzav8O2r7i10By6LeoiGz58wFxJs91yyWKpCEAAenlKh6sz7OYjK1gyJa166y4ASVbDS284Uk7TNMHbfXZOUeup4f1L2FbvtiATRWOKCRlnK8DuGA3gYB0NZ5LX0NSdVRLkEWxVUruq+B82u1ddv7+MOctCpAMsUiyt7zFvCdg4gL9TvYW+TZLGi7WUKj4tAOElYomu6AugDv6MmwOBULndg8cINP9nNn+YO2wsiOigWwx0IsCjJTYlVxyiGdVQzw/QlPz2hfOF0+3MSWrQDFV7LQjXtq9YN4XdzZdiYDxggrIqvt9Eh+OdKniWMonMiTPwLSEnWAtAc9lM
 2qonE88/
 lQku+JUlaAEoOVfjt+GSxqmjjzKBnl/+GcGuWH6BMYMTBzNqLJVdBroWwjeXVIWzZ7QV4LByVJYL4PzDIkfI5aC4WRFBp3Bln0sby0vs/7IB9O5N0Amc0lCLv300sS9hGNTcelMdKnNtGx+2bJaumALpxnaCjqtDOLxE4OLi0Q6vmVOpXS5+mIIxbVZH+h8Ek3ckYfToDhURn4sRjbfLsGtmseVLGV2ByQmjxZg/F1sJz1j9/VHa64090wPENlRVzGHJOgzHvo7IX3PgSqSUVlpVYicxlZlcIcwrk3B6P1tnaUaX7pG+iJR3R+27k9xUpWnojWJnbF9Qc3TtOfb9eDPkG8M4WGPkZVuWbfqWJ38w6u3UgUBgegJQ1jawacgI3y7qkJnL/woxycuwxPll9f3QeELnJtx72u8fp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:44:28PM -0700, jane.chu@oracle.com wrote:
> Good idea, but agreed with Sushiko about the bit setting issue,
> with that fixed,
> 
> Reviewed-by: Jane Chu <jane.chu@oracle.com>

Thanks.  That's the only diff I have between v8 and v9  at this point:

        if (is_page_hwpoison(page))
-               u |= KPF_HWPOISON;
+               u |= 1 << KPF_HWPOISON;



