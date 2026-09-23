Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ABA3C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 19:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C85D6B0088; Wed, 23 Sep 2026 15:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179046B008A; Wed, 23 Sep 2026 15:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043DD6B008C; Wed, 23 Sep 2026 15:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D03876B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:33:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32F88808EC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:33:50 +0000 (UTC)
X-FDA: 85246027020.21.F4F2F21
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2CD40C0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:33:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QT1PAU98;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790192028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlF2IHBpGoMsAW+PGueMhFZSAFiwVwxev332r0gbKW8=;
	b=rD0Q8dqnesCO60B4UT9rWH9OufjOKKyldrj9pkpVnpN9ov3zsUo0YRXi7LS6iZZrHDJ0ZJ
	NZ5BhSd78EAbs3jRAhJMJUtHzfvMgIVF8nYoZV8Ah3phFtfHePk5r0NTLaXdcDqjiZ8OUB
	XkzymH5CKWcuukhxS1Ar197XjxeuR4c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QT1PAU98;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790192028;
	b=w/73WTFXifPCBbcSZpEUjIGyEa4Gfees9gKR839OLYRVsuiRa/sA8oF2blgKvJ/yXeJGgu
	+j5NxlrAOXLFDaMJGcBFlT24PHXF9O0oq7MkfVQTfJhu4uUN89X5lf5EwJvyHfMhYxO545
	i0ErsCDUfzrXysun7QctRHSFuu3smJ4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zlF2IHBpGoMsAW+PGueMhFZSAFiwVwxev332r0gbKW8=; b=QT1PAU98ZJkp/BlL5ftLjhFNug
	BvKHevpJ/YlLkvNj7hHwEBJFcr1zf3E35h+m+BOgBYCSWdEnJw1X9ZQrO/SRYn9gAZuif4BJGCDhT
	ayLU+GyxTD4uxXdG5K3P+XCMwxpWgm/2OVTBg6GKHuVhlQyQabwuyDVi6gw+vtf5roZTHa9V+klxR
	4admyx1UoGsAwtPMvenoa7xuolkH8RXP7HL2Zt3uVomKQWKWzrSvkl/iZfdF2aCir6Oey3NJNpBfD
	IKfg5fvDK77dRtl+YtR95MQ0T647+VaUOIRu3PqwLSef1QUsyBpYYrvQmt6zjlS+7iUQ00RdsMlZT
	v9QZ5UcA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9Sii-0000000EFUQ-2XSG;
	Wed, 23 Sep 2026 19:33:33 +0000
Date: Wed, 23 Sep 2026 20:33:32 +0100
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
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
Message-ID: <arQpjJlN9CGee5Xj@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-9-willy@infradead.org>
 <d30db03b-ffb4-52ce-c922-415ad75661ea@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d30db03b-ffb4-52ce-c922-415ad75661ea@huawei.com>
X-Stat-Signature: nh6pto6m641zxrfds8q3dq6cbacwmawf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CD40C0005
X-HE-Tag: 1790192028-423433
X-HE-Meta: U2FsdGVkX18mvtmTCVDdmeF4P9iOPo8/E9vycEu2iC5Go5x/YdAV14afItpGB9IZajpAkphwEc+BqnB5SpnELgm3sWklNQVQcokV6Xe0badd0KZXuCdvVD/WFF+EV+lBciJ3R3z/9nx2WRjbLEeagFP7dSCPjWqpCPuDGcVpYDopQCk/R6xWCC6fupAelbdBtacGzVf5a26BopIATvYaJge7F9wu41DuBdx8jzE/6AQzX7XD/2uwzJGJYzzgBzb7b2So97qCLDarXAmFHC3uqo8QCPIBSDbiWHcTr7emp0ie92ExGts1kl233oc5UPTzvCTQ1pjG7ET/iw0kkKGrrVeMBly5kcnUjutQFb+Hk9+d+5ZPmoHQhvQ0jVAVPc/bx4vtRuzYTkygiggyalTuCJ6CCuLfzI9NetZbZboXLMiSJUeqm9bEvB+RCKZAGcyJs3N66acRM2ctq6Z7uJOQuMsJuYcxBkGG5aYWn0p8GXn04oFdWfUcOk349k8cTepNiy/e8iZWjoj+mCakotL6JDd9JbCh9ZgpqSimkY2DEoey0lqno9+wFbvhi+UkRpzecLsssOUDGMgHodOTs9dVZs1ukdNDM6E+OTQIf7jHEfO6oXt/Bc78pS+7vZtn74t/2mRYabzqh49OtvTyDv3Rf/KkuxSpW3hwxPd/6GYf2z8obnY9ncDHElRuOArbMQl1HUfsvzrtywCGK986jfndvrbKTQbhtT7q7ECikH2XwYmJnpnFit3NkdTJMIpxU3nhHMRoGj3XbYUOqcx9QoB92zrbB/0soFNywg7g8E3vyi8tbBTdtopZTWQTQ+gVG3hqw4kGJU41A5ErW2kqQAFNOkEKp4uEpyd5BhJQhWXBDyFcRoZRb86d2QbOyjMASq20o4TRQttolah8L0Yxji/7dFv7aQXjVARkI8K8M//WTL7ZBRh4VF4B2d1zxHQBHlDBUQQttd8HPbbv2t6bblh
 zYWizZaw
 fso8vAktnnS9r/cPWSN/AfgLS3AUbqV2dCDYhiD5ty5e0VtdN7+t5dw8a9scz4Md7d8k7mboSV/mc9r1gHUhhkH3Ft1rW9Lrs+WXzAJxZJoZB7jEok/6lpV3xZtPkeI/7lPvltMYij/10/ZRmtcMRbPhrXVOObtkB/K58TEahkASf44mzQ+sHa+NnV05K76cLBVR9WY1X2JbLAapO1dP8q4YSBQvS2bL2+up3XK3IqRlOadXwg9Bwt/DtVHf8pMvUx8cbj97dC+0QA/3eY/2aDqIB8eGdd8v+VNKH0CYtyf2pKP2pYjOIliSd/rd96jYbulIT97a0YZLlgbYpk2WPWFtFdBF6JpMy0j7lvYAVAnlzd25UZws8Dk4gdgi1iQLit1sgWA5BWOQTfYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 11:46:07AM +0800, Miaohe Lin wrote:
> > @@ -1950,8 +1968,8 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
> >  		return;
> >  	if (folio_test_hugetlb_vmemmap_optimized(folio))
> >  		return;
> > -	folio_clear_hwpoison(folio);
> >  	folio_free_raw_hwp(folio, true);
> > +	folio_clear_has_hwpoisoned(folio);
> 
> Should hugetlb_clear_poison be used here to clear huge_poison flag now that hwpoison flag
> is transferred to the raw error pages?

I think that should be safe.  is_page_hwpoison() looks robust against
that to me.

> Apart from this, this patch looks good to me.
> 
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks!

