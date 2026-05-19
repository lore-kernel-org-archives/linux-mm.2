Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5466ACD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876E36B0005; Tue, 19 May 2026 16:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827A36B0088; Tue, 19 May 2026 16:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D9B6B008A; Tue, 19 May 2026 16:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6FC6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:49:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A3191C0925
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:49:31 +0000 (UTC)
X-FDA: 84785360142.28.5ED2592
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7162F1A0007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:49:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n6IZ0yBD;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779223769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7A9MniegkQbxqmlA+0leczj1ZhP9CB3CjDe62JAKy/A=;
	b=bL0h3/WufD1QE5jQIxBnhVMRuZm+pxuXUP/GYMQDSJVfwUYOQfKTTaQ8Lcjh/VfpnYSHQ7
	7ADDP3Bxm9d4ccESFLJEm7PwfhKDl9B0Vr2jUcLpx48qx8pqjZeu1f2scnP7B7XnNWQvjg
	MU8PIOr9jblBUn0xfctLz00WcLOVSD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779223769; a=rsa-sha256;
	cv=none;
	b=IyB64PHp44AZkl7kYVzwF2C/iynvuy/2lPZ1+HQZlgNOMImgNe+4hMB3kwTO7JrdyIF0+q
	wgy3pHBiNQ6wuNILlIEk9RhmcNIibaxzQR8S7ZlMBDyPdMV+02NiZ4GteVnGsXwmnWXNJf
	4nppg33W+x9QUWXv+tALLlxGPWaDzhQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n6IZ0yBD;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D79D4085F;
	Tue, 19 May 2026 20:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93311F00893;
	Tue, 19 May 2026 20:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779223768;
	bh=7A9MniegkQbxqmlA+0leczj1ZhP9CB3CjDe62JAKy/A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=n6IZ0yBDF2P1AATvTvw0B5+2TpR4sLiQVxkGZgKoCJAnGnokB2z4kxyLEjb4fQ0Jz
	 2IrjZ1hzzGX3N2W9RomnUnrMPlYVTs4Vax/Cy2Vf8xZPpdKsxZDCC+bRn8dh/wvMOE
	 qtBq+yvSnr+eC4zWfcIqPYXlbBThb9B2AGZmxq3s=
Date: Tue, 19 May 2026 13:49:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Qi Zheng
 <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg
 pointer
Message-Id: <20260519134927.ee04379d07b0674872422c06@linux-foundation.org>
In-Reply-To: <agynzVVBb4CYJTYG@linux.dev>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
	<aguiSnY3ie1y4nEl@linux.dev>
	<4e296262-fbbf-4ac7-aecc-3ef831583704@kernel.org>
	<agxszIIN6FtK0fEb@linux.dev>
	<ca8e655d-5fe7-4957-8a36-6667616be8b6@kernel.org>
	<agynzVVBb4CYJTYG@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7162F1A0007
X-Rspamd-Server: rspam04
X-Stat-Signature: ud3k7r1i4j7zkua5um9p89ym9zkb7wmd
X-HE-Tag: 1779223769-366788
X-HE-Meta: U2FsdGVkX1/j6Icd5fQy2Ibas2RQaz+1BUeKCcMC//Fm4FSNCEYs4VCTbPWqslbOu+qWJM8rRdbtuA/Fi2H6Atf1Tk7AWuxga3q5gOBWy7CPduKpSobE7j0cFvCFtKkc2Tnuv5Druy5VJBSwj/4fEe9TXcL9zA6DD+4DL1zJfFx6ppXtqiVufAIgdowvV/pkvhw8kKZkEVgRD+NO8uELHZeOLN+TU26RJC/ezkngOpEHNR3bBoFF6gmp1v3ddg+jTznvCGZXdW/joozQZd1+uJ7q5U2AnmvyxwRvaErSpvhYRxHhBBn+CUyuHQ1LvwqS+JbQLe7ofFqPUyIO2FDZ/VaS9+Li1jYMG80dDd/687gG17WvnjS6Qh+8c7NQlfVAF2wA8jTpyAbg80pU/BWPP/8BHidn/ILXFHC1nqPn95GtBPEUkLW3NIH0HYenvuLTnoiOoGPZQxGMSsiYpNVFjkQTi3eqvWF/qYYek6BxVi99mUJTNPXK/aF4y3i3MN7h/COiTZe8fDyWBteMWAD27+epQhQjt22VRisvCFb6enGx72bsKab0ASUzof/uzZeIYW99og3Dyx9ueXSj1dkE9aFf3tWeE1DDcsrIiQRdtgunNY6A4mfzpEIUNpCHsDbbClbtTHUnxN7uGj5Hl15/lQCuMCtKkD9EjEKetllRgCDjakp5qehd8mcz07mQ2TK4OsLcbp9DhRGHTcWFz/oe3jinqHkZqVg/lhn2fz/8+oCg0H0gtbBU7xQQBrJVnMoGb4drAeH5YuFusxcG9A7O/4Ech66OVlkWBt2FhlsYp7lbN+eNLRZVaqvuidGHhL/yqbhLRtAePe9Re+3VFStgonXzDTRLJhzzA3gci6MKEyiEAST/6iJmV3EwoCX/+PM6ilH6RgfDxEraKhpbC6w028ilZ+d4vR8AVn5ANC+0M/TqgX2evl4GtqF2cbSqKoSL8j+i4fwnz5uFIrm1LHE
 9YZ56QPi
 m53dof3xdW75cNMnSrkG39Nf9NZUWQhTGhrDAQizTrGPEEO+sy0WcR4OTR42y6GPK5nIQCMEefhAaNHvL8hsj+ssfsiQkSREoSCLRU0dmYD3ixDAbi2KlYqV0Bg7NsFilNaFF8Tejt5aBc+psl149CO0lMmtz1bFpebQkAUtYiWXetS28a89uul0PdthI1swvUtF3nMmVu55zpyIOpIAgI2LnG2GdVJeLn6VjdhBEOEQkfShLq0j/0yMv14i4JfLKhfKrgHBoBIqtoBKocyutbe4pRS+erSgOSXD+77bteAgIXlrqGd6UlNSyZQY4pbPomkJBE1X9LZkRtZNlvTUxkj+wpMjKBvIXgX/p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 13:11:13 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Andrew, please don't send this patch to Linus until we decide on the option.

No probs, I added a note-to-self.

