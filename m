Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C708CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 21:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF838E0014; Tue, 28 Oct 2025 17:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7558E0005; Tue, 28 Oct 2025 17:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4138E0014; Tue, 28 Oct 2025 17:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F10A8E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:53:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D65731A05E5
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:53:38 +0000 (UTC)
X-FDA: 84048875316.30.EDFBEAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 29CDB160002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:53:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jUDfUc7m;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761688417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12WMYfMdEl+ej89k7trP/WvBLPqBo1LgDjfurBTWyAE=;
	b=VlUO0cNF/KgV+BcoM2xkErn6L0BI/QHjjI9MsPPBNq2v2RAocAN1u5FeRGjgxVxkclvTo8
	zXazChSWZJzBq0nzjNaIAFdz355ZPweI+P25fsPPcjcftZ6G8Cx5sYYsEEqDgntlYPVUsi
	i8OUrqnAGxCBkPf4XQekv6HRPVaZudA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jUDfUc7m;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761688417; a=rsa-sha256;
	cv=none;
	b=vWYBa+DEWLZO59mbbSBXPJP0fA1pqStvWZdD48imV+ZBJdwOEhUNXKAH9BrvP6WO1n15G0
	ON0hoRzlgc23duVQAHwZSf0hSoY5dwp0uBSXpC7rcSYRzURu/OD0+f7JNxdBdMlbGNQYaW
	dtZdWWXGqU+J5UHfPWGDwCFDiDY3DYY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6092B602DE;
	Tue, 28 Oct 2025 21:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EE0C4CEE7;
	Tue, 28 Oct 2025 21:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761688416;
	bh=JPCaK8/B5tsYDz94pQe8nGhHm3auqtQ3gChlHg2P/bM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jUDfUc7mEFZUX45qomM6RsYqoM/5CDi75b7/yyE4Z73kJovnvDmd/C8y4u1uj24dF
	 ipBJjGLGPtR53JWmGj6U0tOIvgXHUDnwdse8EQsjVQofHFVhizI4f1CQnepNrgthao
	 2O7U1frt90PzjaFvpfA68R420ut+CTY5fKNVrsy8=
Date: Tue, 28 Oct 2025 14:53:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: hca@linux.ibm.com, borntraeger@linux.ibm.com, joao.m.martins@oracle.com,
 mike.kravetz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, gor@linux.ibm.com,
 gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com, osalvador@suse.de,
 david@redhat.com, aneesh.kumar@kernel.org
Subject: Re: [PATCH v2] s390: fix HugeTLB vmemmap optimization crash
Message-Id: <20251028145334.5a97211e0e46ca42fe2fa0d0@linux-foundation.org>
In-Reply-To: <20251028211533.47694-1-luizcap@redhat.com>
References: <20251028211533.47694-1-luizcap@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 29CDB160002
X-Stat-Signature: if535n1b8bmz7d4y3cyrrarthdkjfhcj
X-Rspam-User: 
X-HE-Tag: 1761688417-818362
X-HE-Meta: U2FsdGVkX1+QkxnUjfU/gzNQCRMB2y4hP+7Tbr8yV8GfFDi0faYqzkAIbFo6lHnrYo1Z1YuR5uGQbQEG1D4Iugng4fq7BcTU5q0UlqQsTOuU38Wk78EEyuS/VchsPGTH6gpDL15Dp4XzCHsMFhiZbh1Gd6xWwE7JLdX46CszJLfSp5qFlu+xCGnVqEbcUGaeAyXsE3r76iHbC98FWhIu7U/a5GdmFNjJGBgJKdGj8lacywhPBjdpaHewzxJwE2KDi6J3SYUg8osE4MdenHxhMo1W0XpFghag9VpB8A83zBSVN0HOp9UcRN+lt1wPPNjBTFy3p3uwnV8vmo7xu6rLX1zsfsisaGpYdEccffctphcMzlqeKBMIJUGvqnxvGAM7ijw4tJuHX9q6ph6BjtztFmoXjOM/EaCC+WCQPVjwFhzrTIAh2LA+B4Iz2xV7Ua4cYgLKUNREdziBQw1y9SEKY5dvZCVZKLdSeLM+ykb2wsuUM7pUZOUZUtwuwUWl3WkC1b8WNzs+907Xo4ekwHPy9N32oFLiYxKQH22HPynvDaKj8tyAkCRlpcb1bnbXo0311z8Wy66BY07yLH+TPtm4MfKnR6IVrMvlzxjczNFOGNSJMJgMu6paEXJHFhHhtzFT8TPmgD53/EZBLbe/vMuYC6W3UV98hsLNS1nA2IMmEkjdh4i/1VtYmATqNPmbkSwuvUQ7uSRDb4zUPlCKQ9Ie30LzsQScIOPVyT5ogtOIkNxoGQWId7Tdc8sukZNRhd3PGjztxJp9hHrTq90fYIf/tbbCPnDdNtlR7LBK0wlXWbNvv8w9lv5TyLX778Z/jtl2lhBEyZvvKLboV4HU4JTrikBayJbCj0sq76RtlOqmW7HwwH6/lbkj9uJE4sV4mT+lLxsHQnKjDsQAqgBGn7t39xWhQGd8PvMMydNOVXnKrKTloVELjPKuH1DSo175GBKF8T/hHwSKfX2RUJecWHa
 AlsJN+8F
 bSicv+4oem8Gd/+iFKWk/Qrg6PALs/w30MtGVZmbUW2j3b2B5NULjjhBEY8jqxFn6FWsXtEHwqeW3YOASgyAKMG14cFQHbn/DDiy7DEaBobzHbQyRdsxYyQwO/LHQAzAQYy2OELp8flmb2DCuKwvIzrgcCGIIqk/in0uhN+m9D1NDuSDRvTOme+DYEqjszPPiPEwKqa3SfTs8coyDfh3idVsGLov0X8cbbFDRhaIPddXBfSHYWpA3XmSKmKBscLCn9wYRX5nzhysMP2VB++i0v3MUzwyM6C5hnC1Gppk+o2rhOKg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Oct 2025 17:15:33 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:

> A reproducible crash occurs when enabling HugeTLB vmemmap optimization (HVO)
> on s390. The crash and the proposed fix were worked on an s390 KVM guest
> running on an older hypervisor, as I don't have access to an LPAR. However,
> the same issue should occur on bare-metal.
> 
> Reproducer (it may take a few runs to trigger):
> 
>  # sysctl vm.hugetlb_optimize_vmemmap=1
>  # echo 1 > /proc/sys/vm/nr_hugepages
>  # echo 0 > /proc/sys/vm/nr_hugepages
> 
> ...
> 
> This commit fixes this by implementing flush_tlb_all() on s390 as an
> alias to __tlb_flush_global(). This should cause a flush on all TLB
> entries on all CPUs as expected by the flush_tlb_all() semantics.
> 
> ...
>
>  arch/s390/include/asm/tlbflush.h | 6 +++++-

Thanks, I'll add this to mm.git.  If s390 people prefer to merge it
(or nack it!) then please do so and I'll drop the mm.git copy.


