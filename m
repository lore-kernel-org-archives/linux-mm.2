Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A16ACCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7DE8E000E; Wed,  1 Oct 2025 05:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999398E0007; Wed,  1 Oct 2025 05:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AF778E000E; Wed,  1 Oct 2025 05:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 761EC8E0007
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:08:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AEC944BB8
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:08:05 +0000 (UTC)
X-FDA: 83948968530.22.F534021
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf08.hostedemail.com (Postfix) with ESMTP id DF4B616000D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:08:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=YnsfNjBo;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf08.hostedemail.com: domain of "prvs=3627e3e53=acsjakub@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=3627e3e53=acsjakub@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759309683; a=rsa-sha256;
	cv=none;
	b=22+Eoqo3TRZGNBsl51TI/fvBl/SESQ5GdiR5GkdSqtY7aOaCDFPAMmlPCs/6/bY1QyQYAw
	ORpg4+GUvogitlo2eERRgOn0tgbjSc0HS56PCvZtKs5rN1X0sVCvee/jUucHg67z5M9+2u
	MMehx70ToGcGtuMuVXAuOtW5qtdm8hw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=YnsfNjBo;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf08.hostedemail.com: domain of "prvs=3627e3e53=acsjakub@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=3627e3e53=acsjakub@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759309683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+nXW15w+7dBN6EUXm7aFj+3+vhO7ZTN7faFbVeZpUQ=;
	b=yoTlp+LYI4mWMXRYUrv6iKMRjH7p2dGCtdeKmoPLUIsX3t2x6eP8X6kZl6ty6GqlBsHp4u
	EOi/UCTaiOC75tOJ8cXuvkcYoxB9Rts/5Bmub5tnzAbcUO1z8sbMSqpMe1d2GIEY7i/G+b
	kvcReUilckqsbue4y+J902DzmbQziI8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759309683; x=1790845683;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6+nXW15w+7dBN6EUXm7aFj+3+vhO7ZTN7faFbVeZpUQ=;
  b=YnsfNjBolWdVuNiPRqHYJ5yGQYHPP/oB0Du62bM6VU9jtpfv3CmWRduQ
   MSeeGInU5tlmUHjKY1hn+Z/KpuQKJW1dmyqvXfIvEhzEdhJdhKC31+JPi
   L0BK5rzG+LvTALc0TTzO9D5VjQjHJ0ME3CyfMbH8v+uq8RQngJsAzKa8w
   s2B/NOci2xVgPkJ2YYxkpEOx8rLAWz+6goXWNC/wTNiOiDwnIHDicUO8W
   oN0kiPcZrW6DwMJolq5A1CCJ6Ol1byMgzAbE0BQYQB3iPRLr1t4FRZ8Fk
   kaPKrIsc+dxqgUviBccP46pL8EIwlgro/bYRZUecO3Z+HSGfuyXy/WnaH
   A==;
X-CSE-ConnectionGUID: 92LAiI7pQ+aZpl4wa2XNgA==
X-CSE-MsgGUID: vs7DOnDiQkCkBcYNAumq0Q==
X-IronPort-AV: E=Sophos;i="6.18,306,1751241600"; 
   d="scan'208";a="4068769"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 09:08:00 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:7533]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.36.10:2525] with esmtp (Farcaster)
 id 56bfb667-8496-4537-9162-31c05f1cace1; Wed, 1 Oct 2025 09:08:00 +0000 (UTC)
X-Farcaster-Flow-ID: 56bfb667-8496-4537-9162-31c05f1cace1
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 1 Oct 2025 09:07:59 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 1 Oct 2025
 09:07:58 +0000
Date: Wed, 1 Oct 2025 09:07:55 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: David Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Xu Xin
	<xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Peter Xu
	<peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm/ksm: fix flag-dropping behavior in ksm_madvise
Message-ID: <20251001090755.GA66706@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
References: <20250930130023.60106-1-acsjakub@amazon.de>
 <85f852f9-8577-4230-adc7-c52e7f479454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <85f852f9-8577-4230-adc7-c52e7f479454@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D040UWA004.ant.amazon.com (10.13.139.93) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF4B616000D
X-Stat-Signature: qi3apf9tuiefnhf7zcu46xg8brtdx6ox
X-Rspam-User: 
X-HE-Tag: 1759309682-352602
X-HE-Meta: U2FsdGVkX18wGZf8nuBVL/5J+bYzizE972UiZWaYJzOiKcPooJh3vskUwd9wcTeQFBVqIMGzA+sL5n8/qgG5i56DZplXClIFLWNzUn9nKRkEx9zHa1YEQB/9U6bqwtjE8VHL+Amj7hf8EjG/ysTXYN21ShMxQVvAPYxr7TKuDUnZuTsnO8qQBAwsb0Qb/DiQ4ksyXWL4uKMOMGvHPqFFcVf2rJ0BfI27vPaAS1D/oFlErm2PwWnvYkrK89wicYnHfnK1cj3GYTT9DKaX/+KwYc6pKxZ8wW0O0KvwcpKTyIr96JBWOZbliPuwu3Euq9xZs/mL3m5sVcXnfXq/SYnaTRwn21RNww1/vmpmOFeFUrNcmE7uB9ZlhOvTj50Tqhor3TqGLKwd5QUxG0SzGGbfUrt8B4nnmH78UgbLA7j3/Nm6wfrmyz64T7m+tqdN9dEhItW3aknzIAqpaB2s0tr6Pfa5Qxw68xJtxvOF2xxVe/Her/y8HcNMcWwf48dt4mtd4sH1n/8FpAEryQ7uRXM07arB9dhcZ/zYtHeRoStVHxPEVjC6PGJFhFrRsMHDHOguotpV7gpXzoDTKLZpDx4wh1Yy7TD0CV7vomxE0lsKRscReQZ/tZjuNVmBtqUw5z6mkCaVxmVf1CynaRucq2oB2h8HGuiECL3jSioKyHitP+SqtLxigQHOFL+FfmSD/H66K4aomUOACimQrmpcC9/u3LDctZVbwDTxIAI/3OEHSOvttdq5KE1hiLwwnxCFWh72aHvUR9AMaaAQpO388PFkANikqPEwvIBEpdp1Z6QkOcqjUEZptLPz8MI+FrEWKdlo/37z+FJhlzE8I6HvQrcUPdNq4AdntPidQp+BDKdQ246DNPgMctL2limo7+O9w24b2M5PhN20dArL8myUmHCdNu0UWNgbqe8Do724pYRkVwVEImHlPvD7EoWQtj4tX929oJVNzp7vjYHxiYl9TSz
 rLXtpw6+
 UE9SRhrKy9cke/CfIHap36aw1ZPZHsZhGx/iPrDwbmxT0Hz4i8mssiwic2q2Q1ibOOOZdYVyrsavyS60F37NbviR9LcD4LmN4rlO1cH01ApCapgjoLXdqJdHRiA+MFiPqFsGM74Btoro6bKDlgH6FbcrWup9+OARUSQMMdHslgyxHy2D3wHMBiMg4EDy3XgWGMDgJ6YIJLReYjBwLkUaD1jTdIkaj+4fKcg5KjNLzr/3eRQvotIh33D9tBuhoSQavD1LIHp+3i8g+IndmfFhPmTnukRvtt46DLhib7e+1RbpZhuNKEtMDYJ7GL2ZItjC7ubktsl8rQUinvGsCIRnNKPH2sZqAZUfPyah4K5/QtIsuaU3u4K6MTGe7e20Sdj0rZ2Gu+tygfbs08vKayIuk8KITNBo1CrL48lBXT7/sSwGQ7xJ7lb0XE5co1LOuo5RxFxtp8Paynlrbd1N1gMEHNmKscoJZpYuGd/12zBHEWzWoYXzC6a9vT2Xw0xDQvUYJe/OlKqFefqc8RExJf8Urc/YFsNxDN3thXTCoZ/EcCGAub0s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 05:32:25PM +0200, David Hildenbrand wrote:
> If we want a smaller patch for easier backporting, we could split
> off the VM_MERGEABLE change into a separate patch and do all the
> other ones for consistency in another
> 
> Reading what we do VM_HIGH_ARCH_BIT_* , we use BIT(), which does
> 
> 	#define BIT(nr)		(UL(1) << (nr))
> 
> So likely we should just clean it all up an use e.g.,
> 
> #define VM_NONE		0
> #define VM_READ		BIT(0)
> #define VM_WRITE	BIT(1)
> 
> etc.
> 
> So likely it's best to do in a first fix
> 	#define VM_MERGEABLE	BIT(31)
> 
> And in a follow-up cleanup patch convert all the other ones.

Sent in v3: 
https://lore.kernel.org/all/20251001090353.57523-1-acsjakub@amazon.de/

It's the first time I sent a series, please let me know if I did
something wrong :)

> 
> Sorry for not thinking about BIT() earlier
> 

No worries :)

Kind Regards,
Jakub



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


