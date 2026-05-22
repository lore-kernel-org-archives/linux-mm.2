Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A81CCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 09:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41D36B0093; Fri, 22 May 2026 05:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19886B0095; Fri, 22 May 2026 05:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57406B0096; Fri, 22 May 2026 05:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9969E6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:14:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0663D1C062E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:14:13 +0000 (UTC)
X-FDA: 84794494386.09.D844B81
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf20.hostedemail.com (Postfix) with ESMTP id D6B8B1C0008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:14:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XGJDlEgX;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779441251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dBb2VYJICvfFkLah3xJP2KmNvEisma78ZK5+vFaSHI=;
	b=jnHqVQOK1TJ+VhpxnnX0N/7tmQf0n8OW1CsvMi/V945yOIvdW3WBUvgXibH00ZrrM0tSqN
	OzCstCeZoKMNzXrWvqkhVPjTzb9SJfp0w88pEbNunfmoWyyaRftVhyT/UppSzTeabJoDcg
	DNm2NGFCYTUEb+ktUWpDtfdO7iUdKaE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=XGJDlEgX;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779441251; a=rsa-sha256;
	cv=none;
	b=M+pD69C2n7cvnItkt76ke7qCEfUFB4b/iD4U0cU+mGRo1dZR6WVdbSQZJAQcXn/xvDB81m
	49VwGWO7O9CHaxN1TGzzUsIP80rtUKgv1utgo1UTJ4zlkw9riyc0EVuE2cUGOFn33Fz0HJ
	diFqGvESKBRN5aQXLsrD1g8G9HiKPSc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7dBb2VYJICvfFkLah3xJP2KmNvEisma78ZK5+vFaSHI=;
	b=XGJDlEgXWC/F3oYkUOKNYV3aK+0LIry2t0TpBsaGz6kas6NM/98NyHnYz7ilQ3mokqM+wrIKx
	bb/mthb1Rxp1ujL/m7qWnwi3KyQNxhmwWDvI7pcV6CX/jBpDuNKnZ7XajtZdYWC2U31cFfUgyQm
	XdCS3wRWy33n/HQi+5Je2zI=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gMKC00k2zz1prKm;
	Fri, 22 May 2026 17:06:20 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 36EE34048F;
	Fri, 22 May 2026 17:14:05 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 May 2026 17:14:04 +0800
Message-ID: <c8efcfdb-daf1-454b-8e6a-61ab8205c979@huawei.com>
Date: Fri, 22 May 2026 17:14:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
To: Wupeng Ma <mawupeng1@huawei.com>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>,
	<ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20260522010305.4099834-1-mawupeng1@huawei.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260522010305.4099834-1-mawupeng1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: d11mwpzqpnr6zmfga6smd659n5ffrftc
X-Rspamd-Queue-Id: D6B8B1C0008
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779441249-898833
X-HE-Meta: U2FsdGVkX19U2md65oQmmOsH/eFrGZiikIEOheYpzYhLrBakTW7wZ2dJ92QV3qAihucq1+g92urAWM/lg6TuABdLhwnmZiixiyTpcvy2lxshIAtYVaSdtnShezvLeE7SdSOPMx6tiNyS5TSIVoRGdMZUQ5w54WPUZ3cnoaW4oF3CHRsBOtgk/2/AMA/xRn1L/hHGMXfLrJTFULgo9qarEapP+vCIcF8g8iCNxqdMD5EqVev5rf2Jfhe2s04Hs9udZ+1CX0rqnZjlmZooZ5je9qOZoQ9kMPrKvXtYznkIFZMfaoPW6Ht/d++qLsMcsHpn+TSYwkJNAGCi5JDMlrCSOX8hvSsClzeEQyOTLB2OU6SJUxX/lG7dtyABnr5f2M7tnGBN9LKV8eup07+MzEVUzePBNfVW8Sh5oCA6VgoprTbczp+RM+EdtO7k3e0KWi1539dwkJYNrnv4+SEBma6u4FCjUrdsv2QXx3VHp67JBtFJfWi/COxENUMHnSiojLY+d51gH26yfmW/CI85XeEWxVjlA43K+tCQLvvNAy4/wTsA31bvvGCteSjRSbNNxu9pPOGHXJpMjDXJbtO7dsHjaPhRLa3pUTTnut3LvfD8CS62SJ11iP7hRwL/2WPNTm7hwKag6drkVglC+tTvjBHiW+LzQv8uH1NBzAksJ6Cx/FYthvkP9DeIJnq2V82GarGCHdZTrLV/ChAlh/qwzWUi4oqkkhC4jHRl7yss3NpryeO24pb7uh/CskWHjL2OXD8TRl2hU9+KCpF7URpaWTrh9DgY1tPOIyXZaQrjTIlDOaaAx4eWYYF3jr7IqRTgG9MSpsra3aKM5G73NPWgvEuoLngCkeSnewnocFX/ozVaA3o8qg27CDR4YswX75YYNO0G5k4wZcn1i33sOjBb7anEDfHrFO441PuQ357QpWO5C72fhwOTsKqjCsP08g4hag4vAUXKaarb+vSffnibmpN
 ZaBBqOXq
 gl2g3l5/CpsHxJcE2KgctIwWrd32PigFwicS+w+lZrr7ul3QJzUm0rxHAdlk3iDC4fQFdZdaqXCOjoNfFeN/DbFVEEB8ulSVoc+kNwOd2VJ7qDlRvU3bMXsPbMWTlid8jnlg+DWKu/591RC+N/0DkJwDp1IHBbX70KodoMlIOkYS2I5F2m0qEqxr+RDbaFuxbnWAZYvti7P+OdJYIV31a9GRUMGKQgXurBCmVqd87+ysFiDG0MaURiABAwe4tblxjPBE8cX1FosKOKrVvomqT+HZH6ukUVW00rbEK9HEgxsIYK/VcxrB+2GgxQJAp4Ru41rHNQgU7U3mUC16rYMWd4jfqi731trrCGyBVQtpZi+oQj+1eoL6ugd6gASLPwImos3EpDGuxhwqLcRV+vwcnJyQmbcZ9VRt/bCvk6Mh2d6eUmmMKLoKMoYOLCk4jybLGqTF6ETFoFWt7tEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/22/2026 9:03 AM, Wupeng Ma wrote:
> Two concurrent madvise(MADV_HWPOISON) calls on the same hugetlb page
> can trigger a recursive spinlock self-deadlock (AA deadlock) on
> hugetlb_lock when racing with a concurrent unmap:
> 
>    thread#0                              thread#1
>    --------                              --------
>    madvise(folio, MADV_HWPOISON)
>      -> poisons the folio successfully
>    madvise(folio, MADV_HWPOISON)         unmap(folio)
>      try_memory_failure_hugetlb
>        get_huge_page_for_hwpoison
>          spin_lock_irq(&hugetlb_lock)    <- held
>          __get_huge_page_for_hwpoison
>            hugetlb_update_hwpoison()
>              -> MF_HUGETLB_FOLIO_PRE_POISONED
>            goto out:
>              folio_put()
>                refcount: 1 -> 0
>                free_huge_folio()
>                  spin_lock_irqsave(&hugetlb_lock)
>                    -> AA DEADLOCK!
> 
> The out: path in __get_huge_page_for_hwpoison() calls folio_put() to
> drop the GUP reference while the hugetlb_lock is still held by the
> hugetlb.c wrapper get_huge_page_for_hwpoison().  If concurrent unmap
> has released the page table mapping reference, folio_put() drops the
> folio refcount to zero, triggering free_huge_folio() which attempts
> to re-acquire the non-recursive hugetlb_lock.
> 
> Fix this by moving hugetlb_lock acquisition from the hugetlb.c wrapper
> into get_huge_page_for_hwpoison().  Place spin_unlock_irq() before the
> folio_put() at the out: label so the folio is always released outside
> the lock.
> 
> Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>

Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>

