Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6984FE51FE
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182A06B008C; Fri, 24 Apr 2026 07:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133096B0092; Fri, 24 Apr 2026 07:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0490D6B0093; Fri, 24 Apr 2026 07:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E28456B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:39:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A1FFA08AD
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:39:52 +0000 (UTC)
X-FDA: 84693255024.16.462A003
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BEBCB40003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:39:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="kwF/5h4g";
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777030790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uT2NGwkRaNy7QEjBH6R0P5hT/mlXqOeQgAMYtSLoIpw=;
	b=cKFaywuFVZ7WJCg/UMY4ZwQe7cI84CLTJSgKMhD4+aVj6Xvf1dugmMPoo9MeLau2SzfHB9
	du5+M8qmS1cVVtMtLcJyitFR6zL4cW1V0tjJVejDRhbge1wU03UKoMq+U46YFAQJcrtOuI
	TW/YwbIRJ3dqf2cjgs8fd1TVTRd740w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="kwF/5h4g";
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777030790; a=rsa-sha256;
	cv=none;
	b=SDJ0TxpGcrr9kdmK1td6YOxzFm/XpH9vt53P6PbMFYdAxnoUA/fBwYz5QCMtKgHyLLPHZy
	NoS6nfVXNI8bLPzdLTYkuEmyWBGzlgpgb9iUThlCOehzTbnA70hrqyoHADCTpxk+wXBTkQ
	14HPNXTfRYX/Van5sG457LfH5uNjNp4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BDDD5440D7;
	Fri, 24 Apr 2026 11:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6775FC19425;
	Fri, 24 Apr 2026 11:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777030789;
	bh=eyNaJXFjJl8guznsbPc2WyW1JisAMAbK/hgLHo9QuAg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kwF/5h4giSsJl3rn1dcWli10j7U7yuKlJUwOCJdbQBkpx272Mn9Kip0y2dzgVG6hJ
	 rp4XbHLqaSSEJJfkK/PxBziuGuMAfch1P3Nrvn3EKJTlKe6kLjwcsIC4fXkgMouQ5/
	 f2VIu6zlYKawY66cNGGkulu3rrd2jJYNQUF25KvU=
Date: Fri, 24 Apr 2026 04:39:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-Id: <20260424043948.a1b0ef6218e3dc13e5f7a97d@linux-foundation.org>
In-Reply-To: <2026042431-charter-ranging-597c@gregkh>
References: <2026042303-vendor-outright-b9d2@gregkh>
	<a20913f0-476c-4f56-a044-9802bb1c7f1a@kernel.org>
	<2026042431-charter-ranging-597c@gregkh>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ohwq6krsxnsazgz7mhhuhse9hbmgjj8f
X-Rspamd-Queue-Id: BEBCB40003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777030790-714800
X-HE-Meta: U2FsdGVkX1/y2vTv3zlWZNqKgXO/tvo/biTcO4ieLOY/EeUdjCMFYwRCIMvT6G+prxUXDlWW7Nu2BQUhFkG0qWhTvhOZjqsLhhKRCtIXx63izMOXGCMdGa/yBLPdCztlw9bTUrNtraz+LgQSnZT7rlgCfC2HndBoRNzaJ5Y5jE9hxVVUf9v6GbVh7HDLg2hxu0RadzcZKeF+KHYAPo9teGul0aAu0DvHINEAu305RtyRLaH/PlFEkoPWftY513feS3xvwoo5Loq5YtOLyEI1jctfCf1mEXRr8z4HX+zT6MOfP8kMPm0D+aL0UAquLqkKbZLg418h+kL8QE5Yw2wqXKSMBqZacp1Xn7/qHiuOosiW+jMa4jeSqQ3nm/WZUP8T2rs91IVvMTfUB5/3DMqct3JwPXd2fpAhtXGDOI68wNXxnHFTz4BL2xvL2V6cgpGD+u5p/k6Z/g3viMvTuVCgS+p/0fJog7TlVZYHgWXY8AbgcsXJYiiUc0qzmoJwz6FYWXzd6Jcr/o+BeLgBPcczorrzcCBNbuCSwSa9hA9YWRK8FUc0G2iijTKaKzA3kiQmHCCu++LUzloRMl0U73GBGoEkOZhyaRLC2Qmv1gjnTji4ga5HIVoilldU/MFZQyoiP9sItacN3jBl2BU/v/aGbZMaXxSaFwWc2VuC1CRAcnt9kYs7kWlgR41Pp7siDEV/wEyoRIB99Alq9jC9K4c2xxtprfaPsOMU3TMqeisMvE7UAKXlEWjKGiGiIkntjT39SMTW5TZxEIJVhpNv+f+5T1+WsLfujBf7o7w1UsTu3bUHd7iLny8Wae0ilPTqz5q7g+pxSqRctNOWw2cpRwniU2M0EiqGegFOOmE8dU4prjsUxkv5Q8u7MKbKNrHNHN7Q4+/HPouw5DdGAuMERyigWkOf/rMw/S/rBnWY1nmzepLkLtkkQJJxNupHg6SYaz5Y0pOEukB1OkGJ7AVIzSh
 DIDY6Idm
 g4gheE3hQnZ5UKBR829zj3HNUWSf6ANjPmaAhYd6yfoOP4iRmG8nVRYEIrFiE4+mxyZyHf2GQBE9k1P/tOdCDNuVBG1L6sYuFt/E0/HkSXYtL/TRosRpxYk9CP+RMPYh7Xt4sEOx9k6EGo1PNMquduO40oYKh18isdjJJiJ9Cezl7zSmoBVAZfv9/1R7usVfUs4Pbu2vfNrPY7Hqr+TpHhOPVzvm6b1zDHoE+wJcL4I+OmPDCLOPfkPuTPt97u4dBarEszY3SGoUa/VprDmpMv3i0Tb2vXqybc2wmqQHVsPW3DIDZDXmnEeryY6BRn+rCwgyu0wuhetzvw6wHFqjR705BkoG5mJsUiNff
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 13:31:34 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> > > @@ -2019,8 +2020,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
> > >  
> > >  		if (pages) {
> > >  			pages[i] = virt_to_page((void *)start);
> > > -			if (pages[i])
> > > -				get_page(pages[i]);
> > > +			if (!pages[i])
> > > +				break;
> > 
> > Best to mention that change in the patch description. I really think this is the
> > right thing to do (returning NULL in the page array is just very dubious).
> 
> Ick, I see Andrew already grabbed this so I'll just leave it for now,
> thanks for the help and review!

Andrew does copy-n-paste ;)



