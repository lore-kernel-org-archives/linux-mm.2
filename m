Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBDECDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2844C6B0088; Thu, 25 Jun 2026 00:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234E86B008A; Thu, 25 Jun 2026 00:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123606B0092; Thu, 25 Jun 2026 00:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E054C6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:15:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FCD21C336F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:15:48 +0000 (UTC)
X-FDA: 84917121576.20.6C0C597
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id ABEC6180003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:15:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZLS5dK6g;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782360946;
	b=b10Su5jiYIBg6cDAUXRsuCzaglSY6hWFiyDgeHuiQ4opQGS9BfkSlNcgqCg0nLYdrGr6NI
	+UmBpdyaY+vWD8AUuIjQLQjrYONUTS2Tnf5CJ2VGUcMN8ZAtxUujtu+GaQLa/IUp4Bp1DU
	KGT1leYwn+ZhzXy3sL/HM8iiYxyWFmQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782360946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51Vwf7r4R/QJjXahvF3Y5sU3KO5yMhAS+nh75QADU2I=;
	b=W/6GWAw9pX/YJvA5qWUk3gpSxJLD2yp0JxwOiLyNCi74eeHZVcQvJ11+JQpIFi3/aB9aAx
	dZEZMnqMXRVyBJW+666mwuYRhuK7f7t2UetxFan3uk1Jb2SbCadWo5PooLttM/fG3V0qH/
	A8zuNRObuhlklU+N/A2EXX/xmfcj1Hk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZLS5dK6g;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 029D960018;
	Thu, 25 Jun 2026 04:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C3D1F000E9;
	Thu, 25 Jun 2026 04:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782360945;
	bh=51Vwf7r4R/QJjXahvF3Y5sU3KO5yMhAS+nh75QADU2I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZLS5dK6g37UyrD5KNuS+eXfrfuXP0BCm02JVUEGMjCpTLRRFbGXsMSJ/vOoyxShoR
	 e2TM2vExt4C8ovV90By7keM5BnNr1NF6Cy+jGiotxajy4mk/WJ4cQknVYhL8ekSpnu
	 Id7Q9hPtgdxePh7spy62dThv6kOJ1YH5MLqS8g9M=
Date: Wed, 24 Jun 2026 21:15:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: vishal.moola@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Ye Liu <ye.liu@linux.dev>, Zhen Ni
 <zhen.ni@easystack.cn>
Subject: Re: [PATCH v4 0/2] tools/mm/page_owner_sort: split filter cleanup
 and allocation fix
Message-Id: <20260624211544.8437baec5054d079e7ea30f0@linux-foundation.org>
In-Reply-To: <16E1A77F98E4C49E+20260616055401.1570629-1-chenyichong@uniontech.com>
References: <16E1A77F98E4C49E+20260616055401.1570629-1-chenyichong@uniontech.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ABEC6180003
X-Rspam-User: 
X-Stat-Signature: pd9atpg4xs9or3nj3fi7ckhorddxbcs9
X-HE-Tag: 1782360946-286222
X-HE-Meta: U2FsdGVkX1/O8Qepj3e/NdzAN1cNtRS6rUt+1wGSZyzjachejObBgsl/8mKh3VfZK6zzts3bH5/n8CP0EmxVI+/chpzs5zTA5ednaVb1Zn68ZCUKkuyCusd2DupAGOIegi3CgfP+yr6uvDYXFvYz9ZMmzspZp5WQwrfI7Wj4DWs08mJiRJZwFCGlRfPrKyEQDEBRvspxWBaB2p/J3KIR+Q9YchFXQTJglLiJUaKFFgwzGHPZWvrNQU1gutqNsYjvMH/k3/sSQbPiHZMD/q1NT+ZcR2CqB9b9EFdw3+TpPDpPmNs2hiVfqO8Je6yOJtLANHWHNH1TC5h0aoZOR8mLXJYIPv7aOWIGZ6YzOdyQV0/TnrQjmzFL5lUD66dTo5SWIHu6c6TP6dGyIjKh7AyEe6UJY/Pa9x38bI2Zp1rojuUIL1scqvWvKiwyrgfSgqoiBKFbGPNcNzZ9fQAaQMD0M2mNcZUwOgeFxLepGwASfpHD3CShhQ290W74Nz90551dp6Hcjs9fu2u7s1XPJwchLQHSZvtg8JpeNtGM3Jk98oxCIMOEVUYrhiKMO1IpU/5BA6as/q2Sg32pwRZU8SvJYoHrDKpC0ZvhLFg2IU+lwpEsZ9hY5sRBv6x2fyS4YlMQtTf7Wa8zTtJFx4zbK1qLeDwvvUYzwf8labAhqtGjZ5AtsWff5eVsLKHMXKqgnB3XQjTdINtKRBmnQArgvnQDmibTcTd0a6pFJg6ytQ+fw/3yCCI+5KGjMwvYxldxi0RbGJ8UAymLs6rRmpG0NCFuvnPUYXbGAm89lcM4EsiQaoGq9MRQLYTD20LK6TyD7jeLFHOKueL9nXX4uKsknPf4NLnOavc02LJHNsWGIihAfQ0rTEjLuPIDPcMmT/v5DN6HWIxMjHvDy3mP6JYfYC3gQIVojlK9V3oFYp2UbdQKB6dp0FpcvEziaSKOxBHYd/SRHysvUjWcb6n5Nomr+aa
 BqZhsGV7
 5xmvcj1+F7DsBF1fi1iuUY8kR/XghQnb9f8rnW9nc1NX1VoQ1kNzKIVZTPu4SYQQlKXraUQD1dvH310/zA9PnGnLFgvgNiU5+iDBOGhq16dS60ZkFlL9lM3UMJW6EKG7mfqkk8to/hapMRd1nlT9iklaQiEiTz0pH58IN93UgFtJIMOyButN9iA/+y+OHJexFA1wPYIhH78vIewLaHgGqrpPsM+dhVAgSKQI2sjdqr1F/zi2lTMyDqjUS5JmB/KzP6lbkBfPvoR4o4CaMeE5udUQRNpYXHslpgDQZnqXOchhJmhdy55HhRY8Es3BAubU33oXewsPPAiXNiKO2UW39HfNBVOxMRQXIiv4CD5ez/LED7wz0r5tma9sMsS8o49uTAcuGll7S64AcGcjsBX0FudtTQnKaeJeqoZpoCVEsTjOLyv1WBvyzkWqoCpOYruJdPFt5NPWnmHC5EDaoZ5LsJUc49fixD2hDU97G+CWwyDhytic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Jun 2026 13:53:59 +0800 Yichong Chen <chenyichong@uniontech.com> wrote:

> Split the v3 change into two patches as suggested by Vishal.
> 
> Patch 1 renames is_need() to filter_record() and makes the filter path
> return explicit results. Patch 2 fixes the per-record allocation leaks.

Thanks.

We're now at -rc1 (almost), so expect people to start paying more
attention.  Please plan on resending this series next week.

Please try to sort out the message threading - sending these as
separate emails seems to have fooled AI review.

AI review might have found several issues in here, all of them
pre-existing.

	https://sashiko.dev/#/patchset/1F4441B54A305CC2+20260616055401.1570629-2-chenyichong@uniontech.com
	https://sashiko.dev/#/patchset/B8742494160D4CAA+20260616055401.1570629-3-chenyichong@uniontech.com

Ye Liu and Zhen Ni (both cc'ed) have been working on page_owner
recently, so please let's keep them informed - they may be interested
in your changes and in the possible issues which Sashiko has
identified.


