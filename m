Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF03F3D5FC
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 09:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717C06B008C; Sun, 29 Mar 2026 05:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EF9D6B0095; Sun, 29 Mar 2026 05:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604D46B0096; Sun, 29 Mar 2026 05:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4A36B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 05:06:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7839E8B894
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:06:06 +0000 (UTC)
X-FDA: 84598518732.01.584D7BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 884F818000B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:06:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XCqQrXFR;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774775164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gm9WbX3aGbzz+xm7VEIAM/1LK2XfhplZSKMKkWgFnuo=;
	b=sbpJMEl7HdxoTCEkrLr5LYFzz69GIqmbe7MfuAiQVeJ3SWa/nCWqI5cEKoEuq+eM+WCD22
	0CaeFUlAvnYYjq5e5B86LCJPy9i3mee+SkaEggedyYoMVlFeDRWNbNXhsoChe2/xcwfJV5
	UPl2o+4uFogkelzLyKKeM2/OAYloApM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XCqQrXFR;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774775164; a=rsa-sha256;
	cv=none;
	b=N5Di2hldRMgpN7Z9AMN2SRc8ocmcG7ucjGWA25CXKdKZhUQuRny7W25Xx02jMezEZ4s6ka
	k77T9Qg5GPMAR0IKBmErvfQHxbmmutkiXpRLaAWAvwjJLZ37Vl2wHTj4MWfD0hoMSXG2DS
	q40JVX1zWc+qSGplEoRdcBW6F5za2Uk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774775163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gm9WbX3aGbzz+xm7VEIAM/1LK2XfhplZSKMKkWgFnuo=;
	b=XCqQrXFRFeVOtokHU6FIgcn0a6iboc1IBWhmEXSg8oVPLZSl7o8p/sW5T75zXaH+jtP1Rk
	nVl3J+0tm/zmvEti1QY2NbXVIzCmt6PodS9sjbZJDDz+e1XUgd+Qt5f0nIK+zMYVkNAfgK
	jaVD3aV2xmJJBsX/p8YeQC5jVbatbKY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-83-jyU18zvWN16pE1pBORFRkQ-1; Sun,
 29 Mar 2026 05:06:00 -0400
X-MC-Unique: jyU18zvWN16pE1pBORFRkQ-1
X-Mimecast-MFC-AGG-ID: jyU18zvWN16pE1pBORFRkQ_1774775158
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B011195608E;
	Sun, 29 Mar 2026 09:05:57 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.11])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30ABC19560B1;
	Sun, 29 Mar 2026 09:05:46 +0000 (UTC)
Date: Sun, 29 Mar 2026 17:05:42 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v6 0/6] selftests/mm: skip several tests when thp is not
 available
Message-ID: <acjrZtVxPr1uad8I@gmail.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
 <20260324090927.eeacb7987d22ed8ba13fada2@linux-foundation.org>
 <b28ebf0c-c10e-4e1a-9e8e-30e6925d0da8@kernel.org>
MIME-Version: 1.0
In-Reply-To: <b28ebf0c-c10e-4e1a-9e8e-30e6925d0da8@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: Jl5gEJkwV9rD1k7Is0bBY2M3ylWqBmBx-z1iEQJPahU_1774775158
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 884F818000B
X-Stat-Signature: 44y995f8kurjztfhrbpay16h3izx99jt
X-Rspam-User: 
X-HE-Tag: 1774775164-778486
X-HE-Meta: U2FsdGVkX18NKyDqlf/wUGZ6wt8dN8fGUg3d5S6ZsJsYzI2+O6gDCIcVBDgtp6gl5cA7Z3R0nfVq7JDGv0fuehqC64YSj/TjSUz5PTFF3Gg0/f7Gn5wDw5/M6ZGvLxf8IYHcDk1bJ4MlzmPYWx41C9We9fLAbSuWPZRXdrm+chsL5ydMfX4q8SIdPT7FkzqyTVZHm0AMmf/ZlyTML7Psn1Bv+m+c4le/0xECxFo9zkfRpmxERAAylG8IfXRl2uYnO+aHJQP49HSamE4207WD5/ogsuUc1+9aM6Kjk3Ml3EZbMvZHLfBuT07YQNZWbf+X3x3Krn6SG42oMLRU1pXkj/GgBm4FtMsDmIfDT3eEJUkHOVrzwMzdkOvkemZebfB4+kpLVWLIp01bFWNYjgsWaav3Dy0Ow2opYJe7rb/5QhRmCDV5q7HYqa2FibQXSerhYlx5ONgd8SfANSXcMhwVXHQ6Mv4LH0m5hVlH9Bl3ngX55DZW8fXp4abCQjwTcw+Visux3Witmls18l00LxL9+ev1xYXU0/OF5pgQQRcnLPUBiCR0yQPBagrrjn5GBBXTor0CidI+TC5457oOMlQ56ccTxKsf6Gb+cTTEUU3BbqQdzyKCaHHDNKNmp7ahPuu8N3HlxLKyKmUFNjeviGJWrxvXnVc68oWpQr9+NcC2xlGymLhmfsN3MAOVu+lm8hswyP9aTi1++9LND5jaz0LW4cGsXeyFRXDTxocAyQQX2lffQuaTim9BfCXQFhdFxdUbYCLpaS+ci9rBwhkaqpHcvuY/WJcYmPAo992xUxre5cMSy892kcVyvZEdjGQM9590FYjWyj18OUBcpC1tLvxFB2ABcnzAAEzKTOfJaCKwUcZy0f9q30XYquG0BfOkbSKuUsRItZETxIZxTm2YkcVaLVV33NLmeZb5lzLjX9cXpgN87fj8zd4qv1Xt6zTLIbOYbXQKKsKqKGSLdnzM6Xd
 l2z+uATk
 2XLkWaYohsqsEL++zphzn/tCMgd0XMMbdITm61ABqzkzt+HJ1CvzvvAslxUZRFzc/VvZP6C8idcu82CiIiG2AVaUTsgN2OvtS1xXXHfLwLWJXZ9bveb2mdZwZ6GFRidHKUn3gb1DzCkSAXtD7N2p+FyIkTFnc3Fadcz6jnpcYiJuyKoV1x/0X3wMS8ooBW7sWyp2YpGZIrdsL9lThSZLy28qHDB79TP/6lPpfPbNCBrKi+7qFtGNTqbjH0Pt1fwoLW5yr7RaMrW/XrRQgj17FKxuMW0eSW4m3Dby1gVJGDVpvtOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 02:24:58PM +0100, David Hildenbrand (Arm) wrote:
> On 3/24/26 17:09, Andrew Morton wrote:
> > On Tue, 24 Mar 2026 09:33:10 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> > 
> >> There are several tests requires transprarent hugepages, when run on thp
> >> disabled kernel such as realtime kernel, there will be false negative.
> >> Mark those tests as skip when thp is not available.
> > 
> > Thanks, I updated mm.git's mm-unstable branch to this version.
> > 
> >> Chagnes in v6:
> >>   - patch 3 add reviewed-by from Lorenzo
> >>   - patch 4 handle the errno before and after close(), suggested by AI
> > 
> > Here's how v6 altered mm.git:
> > 
> > 
> >  tools/testing/selftests/mm/vm_util.c |   12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > --- a/tools/testing/selftests/mm/vm_util.c~b
> > +++ a/tools/testing/selftests/mm/vm_util.c
> > @@ -785,15 +785,23 @@ int unpoison_memory(unsigned long pfn)
> >  
> >  void write_file(const char *path, const char *buf, size_t buflen)
> >  {
> > -	int fd;
> > +	int fd, saved_errno;
> >  	ssize_t numwritten;
> 
> Empty line? :)

Good catch. I will add one empty line in the next version. Thanks!

> 
> > +	if (buflen < 1)
> > +		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
> 
> -- 
> Cheers,
> 
> David
> 


