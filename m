Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC8B5CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 03:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39B36B0005; Fri, 12 Jun 2026 23:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12246B008A; Fri, 12 Jun 2026 23:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E3C6B008C; Fri, 12 Jun 2026 23:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 941E36B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:18:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1AA081C3108
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 03:18:26 +0000 (UTC)
X-FDA: 84873431412.22.90A6CDD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id AFB6E20003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 03:18:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HRtZS6HU;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781320704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmwnElAJhoAdKoLbXN+G95cQPfc8xbBCwPXx/b2LWdU=;
	b=p3p+dlKZcC3MYVN52uSWZYBJ6Kgt3qHp22SeoMkuF0Jb52nNLoBOXLfhLlaDm0CaIGuW5o
	/O7t2K8uOOmY8stB5xpB0pTvfDX2mQ5UbhTLMhO9xP4ptH55juW/b4DehsAZ8A4SlDPKFC
	iDoQa+QZ/xjq+ylaHfKKd7qFbimDu+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781320704;
	b=5X4GcGEl7awbUWZwNpGuZzOQskbKt6JsyO8myGwBvkH7suvx+ssMUs00hbRZv5JkVEjKJl
	jHn0jNi0giEpXBPqomXc3CNwiFn1EIj/ng5zaooa+LbWFmIh1cNg2ObPBxeUJcdPh7jZi5
	uloiQ1VdfjcUsV2Fvbm+dQJXPNLkTK8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HRtZS6HU;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=HmwnElAJhoAdKoLbXN+G95cQPfc8xbBCwPXx/b2LWdU=; b=HRtZS6HUlaTflQAFw0/MzUwjxR
	AHJEMVHKYuNjg69Zt/peB0oP5zXn7T9G+JmKy9+Qwriv1OCa85o3Scce8I6LEir65txd6lvqW+INZ
	o8ZvUsBDCxcVnxB0yq+g5TKPMrPCKyoppjrGsuzJNNiUXJe7Wq2NEPwjL+dhjnTTgKlU2ZMi0s/8u
	DQ/tP1K9EMIE/aTL7OxVh6PcdK8FEzISSS7tcJxw3bCngTFCJ0dtaRxzAkW5szMRGNalfLsUiNa84
	qbud9xrB9wS5KZxcESLQBRnxLYRpD/M6RqOZ3+eVYhz5BVSQ42lQyPa6N29OD1s/eu15SYMyghhjo
	yoLY7BGA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wYEt3-00000004sPH-1DfW;
	Sat, 13 Jun 2026 03:18:21 +0000
Date: Sat, 13 Jun 2026 04:18:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/6] show_page_info: Remove printing of page index
Message-ID: <aizL_QrL4dNWMJ8Y@casper.infradead.org>
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-6-willy@infradead.org>
 <20a5a752-3ed6-4fde-96c9-e8369b15524c@linux.dev>
 <ainCu2HZTTdP4skd@casper.infradead.org>
 <11cc4dca-7841-4897-8665-e27d7555f246@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11cc4dca-7841-4897-8665-e27d7555f246@linux.dev>
X-Rspamd-Queue-Id: AFB6E20003
X-Rspam-User: 
X-Stat-Signature: dfqixowx3nqix8tn4676qpcddshiyd6b
X-Rspamd-Server: rspam08
X-HE-Tag: 1781320703-298109
X-HE-Meta: U2FsdGVkX19ESYgQ/cwtkDTRLMCQrrdERKMZ5uTNzEIw+ZBayndnodyy2sSHyfY0Pitu+h0fkdUwBNHwBt79PuoPTHODa0UFDw1i9+c1dvAAWkzcAyLddNWNuOaBG6UbtwQ1cEUN/Ul0V8wvT2SwjQ0gknOOdLCl0UbWAm4s4GgG3KClOgZOEcdZFzvYDtLA2NTuMkVHbHJBwrBVBAPNW8v+5RadOx4Hqa3NypMxi+1iH+c5LDzx0N0Bg/EbWQIR/91FQ4HLvRjqspVLkHZOcud2vuhU7srf35QQSg9wdJGmM2kDDk0qBPHPsmEhf0CFAS0p42VYHyrfniMdk/iDbZUXNo7/7AXCtI8YVESmElbIroJj9u8h+XqC2ZSx0sMYhJDWas6DllNbS91+HF1jxmPQpjpiN2AdAT+EYCMAkALY4v2qGc9Sl4Nr95ep7pq+I95G2Fq2979d8tBdwBHwfEylnUk3ssoVgYBIq+SiNO48qAJQCuPjW/RGWgnB7ImGBUgf5D862eOtGRjOaz0FgI+cNGau9ibE57ku+Qd72PVzh+erE6IHYbfmvRtxam/VwCFgAE7mZuOS623jte3wq/Q5jWqo62zev4TFW11XiEbbrgyT9o4Mizw6VlkJPJcMjRSedU5sfNgGW7dt6jN2U6KahulC/JV+WpCMfCqEIgrYpW4zxrOzds0ovM0OScw/xFPCwuo5r4faYiH4l62n+R3hoaV7oNItA1RJ2x8gho8GhtzFAMiPToEqzIYwRiBkA61Y+2EEKv8IZEtQ0KpIc9BW213JNUEoSga6FVJEMjhTd8amPF6PaohADWDP1yospWsRLYMNoC+rEbW+j41AFtYbYByx4/wEna+TzhZl2H4Eqzc7aWy4vO2HUQl4lNcJzYZcfri7WMtAsJVzMy7iS2ozobUvMkJL2f7E8L9xfxftkUYPDMygPHXobKi4XoJrRmHzr5TBtCDsn+Opjn1
 52ue5omI
 B1TRlX6HoVSCxKslhrckpUcYWoj6Kwc3fZ0TyGHPrvXuR/H0cePyrmM3VADD8ROSal7mucUQa+yLWc1Mf2KwVJNviTysqeq777uD+wd2bP7IWRwsy87in6f0oO5qb7jmYyA8iq0APQXrBmL78J/c7oPtsOpZJKx4J/xgYG7PoQc26i36eNiVgpH7aRmjBnA8yY0n8LQw+CegZI8tAAKKDfieoviq7+HWHVZK6jhmcW2/1yN5RkUb7my99z7u57V4SiXLMpvQfl4KVlWOJmaMRj3JRS4EurVBN7ADSyWXxuuB8iRJYNzaDWxdk816Rov+a3O/O0KOf9yHTimtvQieFL3i0Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 13, 2026 at 11:02:06AM +0800, Ye Liu wrote:
> 在 2026/6/11 04:02, Matthew Wilcox 写道:
> > Thanks, but could you explain why you don't just call dump_page()?
> > It's more comprehensive and will continue to be maintained.
> 
> This script is based on the drgn tool, but the drgn tool does not
> have a dump_page helper. What kind of method do you mean by      
> directly calling it?                                             

void dump_page(const struct page *page, const char *reason)

in mm/debug.c

