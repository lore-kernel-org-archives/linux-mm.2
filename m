Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D14CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 02:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1688E0007; Thu,  6 Nov 2025 21:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0468E0002; Thu,  6 Nov 2025 21:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7638E0007; Thu,  6 Nov 2025 21:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2BE8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42EAA4B2CC
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:29:54 +0000 (UTC)
X-FDA: 84082230708.13.577C552
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 76191100005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:29:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bxrEYTaX;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762482592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZQ0+RmNgxW4aWFHAvFiBm30gZ5bXB3jf/w/+PSoSfc=;
	b=vdS1b/HDpe7RLF0PyUewAUOQnzM99rLMGR/TjREIRVFTGiDktPabOa6PhvFO7uMzN5ZKP9
	dz0sb+iatU03RfaleQ9FDsnIOo+kY42aguUDktstVziPCguR5ZMQZBamCe6V63j+imB8nw
	nULRKKg8mKscMMWR1YnGmhj21IHdLIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762482592; a=rsa-sha256;
	cv=none;
	b=kvKWeqsOzKEQENfixS1gwPJeDuKQwtqFtN1neH0hVjc8ZfFoOsboTbbIIASOxVflMXzvSK
	tzCu1PRAx491YlLsHFDYOTzJ2BiS2jqA/gCkjHbYiHcuU1A6SsCSvJh2scbYFTmLNlG/sQ
	AY4/mdkF9IQefdyMo43L68Yt+t+FHMo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bxrEYTaX;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7702D407FC;
	Fri,  7 Nov 2025 02:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E61DC116C6;
	Fri,  7 Nov 2025 02:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762482591;
	bh=Yv7Dow2fFXN3wdJAsNrWkVg7HvQAvwMM83WA7IZetx8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bxrEYTaXZiAEAf3Utu4PW8YAwIaQineyjR3u7q/cUBGMZCTM+t8+TCK2YyBhyq4Fo
	 fBtyH6kpFZuZcPr87ylM9PlvXxD5mEZlWPJfSKonQ4jdORR1QFF8uMm6/u/j/0klNL
	 0pXMNSwkyBLwOmRP/xZOPLsBfL6Qt4q+PzctlPoM=
Date: Thu, 6 Nov 2025 18:29:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng
 <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 3/4] mm: thp: use folio_batch to handle THP splitting
 in deferred_split_scan()
Message-Id: <20251106182949.1ffd6f5529aa18139f2ba9f3@linux-foundation.org>
In-Reply-To: <20251106145213.jblfgslgjzfr3z7h@master>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
	<4f5d7a321c72dfe65e0e19a3f89180d5988eae2e.1760509767.git.zhengqi.arch@bytedance.com>
	<20251106145213.jblfgslgjzfr3z7h@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 76191100005
X-Stat-Signature: zw94gwogjj85ueqnu4yeg4h6zfj86xbk
X-Rspam-User: 
X-HE-Tag: 1762482592-97870
X-HE-Meta: U2FsdGVkX1+ESiGZJGIM21j03JcXnQ6SsTZWzCrAW6mNU8Utxh9NQoVUCTRP5f37m6k+sIqByJ+p2MQteVpNywu87GNJbEfQTf9Vq8bGY6s0+USA/m1xi+oNBd5e+ZEcc7eCz8nEA4kH3tPvGGLf/SLnq394doCPVz6piZugFwFqR0uZCLDIDfLFT8sTYCdmys2I7mvc31n2DpAs5+3mPukMzv8neUWJjtd1XrYqCJ2U02m8VaG5xl1ZRA9urVQIgFqM1sccWEjrc8Oz6wTNLgteluUliwh2+9av3prLuTs08rxTwfAz9BJ7W1Iz9cksDfsBIG1ptXA0S9PNPxYXMaellmtqwCVHgn9X7ZG5JOMd86KtTwBrtW2mb6GBwb6m15kR5hTaXMMVvt3xaYDovceapfYn2KSoGctoGLN0+2TH+bIkk8hepJ2wIKcCkXs2pdPaAXUSQ+LXej4l6Jg4S5Ntrs0fnx0CrgV+QRnii9xoiO4oMV8oOdcdwDQvEj4mkn/nN72jtFp9so3XxU5ImO+wrPf9qsK8w2wZwGyzMQnsKWEBZE8bf4O2qpnaa4WP2/NU+WJjlJCKO+90cWzpeauiGJPMKfTk0Ld2rp5yV6Oipcdf1/W/40O7NR2KDWtrS00qmaWBmevNium1vY+MAHfnU7mfztXYfhSs19IjvBZ/UoFpUy2Xa76d+MSmQlDSy2dHTDn4Em39SvnbRnswC6TtERm993AoKsthICuv+LAdfqZpjVzQ8Syq89f0LEaamUp8Xt6omrJFxjuNRBC9FQ0ksJzxKWiB9OCSqvl+o60NtOxGtCmcqtP+E2jTm+F+HTcgqJHLA1hWKFW/U2OrXnW03T31M54IWrYif1+165gEgHU1HEYvuiAVKyNGJXkl1icO7MS8ZIiyIuPgYfbik9Pv/bHw3547z0wQPVs2Tsl+CeRCEY34wkEqLqrx72fNrrBTPzSb+RjWZKFkCM1
 0HqvaZtZ
 M6nbE7a7c4iH3tqkqUqcoK8Knn1fe7IKhpR9THOr8ePjinhZ4Iq0G7EXufxPPccTUUsXWjkXqldWqX8Wc57sbLcR4SjeREmNo+P/gtd5+XB60ZS+Cot8g8PbrMJl/6uquY6hM1DOGgUeiE+pYfzc/gXSOS+395jzSUM+QaqHmzUjbCos6Ch2jISaiewU9k9oTMnvMV9jJdwlgdng1yfkU5SC7TZJgxS8N2Yvwpja7aLTH6wrOc7coetZzfNmwDDHAIaix1VYK5gppzCcAxC96w/x1Rw/ucqF79PrVjUc0MKFplXvAN53SlaXLwj1r9oAAFikZq/nB0AdxOn04anZ+BYr936OJoklGUFbkFGk9E9yur8RZNTX6v3EJFXGH1mvyufQ9uEtBtjfUFu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 6 Nov 2025 14:52:13 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> >+		if (folio_order(folio) > 1) {
> >+			if (!list_empty(&folio->_deferred_list)) {
> >+				ds_queue->split_queue_len--;
> >+				/*
> >+				 * Reinitialize page_deferred_list after removing the
> >+				 * page from the split_queue, otherwise a subsequent
> >+				 * split will see list corruption when checking the
> >+				 * page_deferred_list.
> >+				 */
> >+				list_del_init(&folio->_deferred_list);
> >+			}
> > 			if (folio_test_partially_mapped(folio)) {
> > 				folio_clear_partially_mapped(folio);
> > 				mod_mthp_stat(folio_order(folio),
> > 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> > 			}
> >-			/*
> >-			 * Reinitialize page_deferred_list after removing the
> >-			 * page from the split_queue, otherwise a subsequent
> >-			 * split will see list corruption when checking the
> >-			 * page_deferred_list.
> >-			 */
> >-			list_del_init(&folio->_deferred_list);
> 
> @Andrew
> 
> Current mm-new looks not merge the code correctly?
> 

It happens.  We presently have 29 patches which alter mm/huge_memory.c.

Thanks for checking.  I'll drop version 5 of "reparent the THP split queue".

Please check what remains, and send a v6 against tomorrow's
mm-new/mm-unstable.

