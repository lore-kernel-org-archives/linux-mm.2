Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 142E0C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 03:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9432C6B007B; Mon, 27 Jul 2026 23:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91B916B0088; Mon, 27 Jul 2026 23:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8593E6B008A; Mon, 27 Jul 2026 23:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 544126B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:45:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE83A8027D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:45:08 +0000 (UTC)
X-FDA: 85036794696.02.0187F0A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id AEC0740006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:45:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kZhCQWx8;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785210307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bT3+KK4QSJMJlgpLZhEeL7jVPOW+yK701niYYAzf6Uw=;
	b=HDQDks8rR4FQ996vSWoFhJMttrq4L43VaVjlYrY9sVIKnLPr/tyo7zNzQSzBK47bhMaGT3
	zB4zNt5O/iugtUJSfM7V7Jh3YCltMhUWV4VOsTY1GEYodaxCK7c8HaAjk2Xv2g7U5j41MV
	0M3UGPTv1+IJv/iQ038gK899kXYDoxc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785210307;
	b=26FbxKZ6vqlSoQi5W8FYQsDHIgd6MNAW+m0fnn7/e0o0Mml9mOuAECzr1WiK4TwkEPVVIm
	JIFMZn84pltoC3cNC2dpbskmjPOBoqV+4XOBOApNzcZo0hABM2YWoovqn1Q7V1VIuI2yVJ
	a65TuqfhAzzgb5MbNMhSRf/yCkms0m4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kZhCQWx8;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 692C91BF7;
	Mon, 27 Jul 2026 20:45:01 -0700 (PDT)
Received: from [10.163.132.30] (unknown [10.163.132.30])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 526183F66F;
	Mon, 27 Jul 2026 20:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785210305; bh=lF4z6UiOu2aQ+vwsqCLXwrfNAzwvXtXonJ42w0LYqx4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=kZhCQWx8uyjFapPdZuaxxkywMul/T7S8sVlyjyePu4LCy9wevlfcCMc7Fh3F87nf3
	 dRBijIiOAXLXX1SaVm/fsB8A8o5LeQ5luGjAY5tQ/j0qxPz/dHNdpG9G3S7aGbStoA
	 C6hIJ6x7PbZQCRCsn7577iwioyYi+DtMulc6+mOw=
Message-ID: <14172dd4-75c5-405a-a802-a2b82a2d0dc9@arm.com>
Date: Tue, 28 Jul 2026 09:15:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm.git review status at 7.2-rc4
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20260721225139.fd654a3a40e755d3e621899d@linux-foundation.org>
 <73ccbdf2-7145-4dcf-bb73-44fc23fbb325@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <73ccbdf2-7145-4dcf-bb73-44fc23fbb325@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AEC0740006
X-Stat-Signature: dbqdz41n197gcqk8wqbgfp8a55hetpk7
X-Rspam-User: 
X-HE-Tag: 1785210306-987979
X-HE-Meta: U2FsdGVkX1/DbZG38yrp2TTvZF4ey+dmJGYOQ3/fNgChvINW07n8TzuDjogoZ+Rcbp33WoIXfEVlJUao0ylyWzneKm+TXmnqgCtQT6wrlx6s02XdwrpHVwJu45A44l5/y5iJb9GDGL9o+35wf0AWNpu2uqDejIcIduzkJIXFiBIutCnpYPSM5ecexbizJTwlw2kDs9ALUgX1afHrqKynuJ95+RbNAvE0FrbRtPGsVwgAj94JZt351ZoupLSMbWch/8RW1aYl8EeOYcOg6g9JxkEY2JVQaUFQkTDCM5f/6M73ETovorhEbOanJErMDPny2i9x4X1DJl1WM8gZzUSPY4oCJXhr4duyS3l4OF7gAAr3S/EDSlkhfrebLIf2TXF/Fo3uRBzmeh9ZPnHsUWu7So9Al9CitvTQ1h2CCIH4SHf7gu6IRJQ4O4sc+Y8M+L9qwDOcTT9jod54irdaTbFkuyESBrnpbcLnZYD9OsiuwFB1y1TPrS5x0bAbR4JVguamOkHM4tJ+nFJwg5aUDnLyk6J3Hi8ksihuPIAhaYQtvVaG34pK7QxEJ6ST90X50KYRJjCZ9bF6XMQlqze7ClocwezqRvPDiOCxMhDvDsLH9uohHz1aRuxHQNY2fuTXhWUxzCg2QUrCqsjlceY0aBQMY3TnVce2Pgt1+2i2PA0e5Uz8e/eDeBLG/joN4T4HDlCMfayreFIH+v1H5D/+lSkcZasle8MxuTXpiuFN58wC88l5o7z353MD9KIS8TrXJiViKKBPcZbksFjRos6hdgkjEUMihzME8L4Sy3LRZ/3qvM+Mz/JYJcPOBh1dSK/uFVchjYBOWDUjHb/2sM4aAP8E1LIxCdwqUkYv9tY5+YkC8ujYaI0OGHOqEkdEyZ0qoMy7FD+B6/eLoUl+soVHp8ZiMqqZroh+6CgjdCZ1XH+AHRZJcS4jG7UYV8gbzI9Ng45JtJIl4qd+Wse3froSRA4
 iipZSnG5
 Pkznd+JzyvSFuL2i2pNxDL14WRuSHa4WmaxVeT/WlTclRl9pv3GZ/11YbyjS1/cI1bzHlghx+q8Gt1cwdYySeCLYFSNC7fYdomnEm+qt0JXSA/kd0BQ+D+x1IaM578qAJzPRjlh4/Zwg48QBI1yCXZyeTtGvErP0bNcXbJPo6ZxKhr9j2rgR+uKpvY+Sa5aqCjiQC8Eb4Jr7KYP6GsNS8uQsOOMalF0ZkfLkUodMt8KJ3BUuZ9gLMs0qYzJKhFzfnpGZJj0gyVTYpc4GGBblF/JfE4uKZt3IwjH2ag+x6w9dBYYjV3RvcSNtxFGOg4+VWsuDT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/07/26 1:12 AM, David Hildenbrand (Arm) wrote:
>> avid Hildenbrand (Arm) <david@kernel.org> (1 total)
>>     "mm: standardize printing for pgtable entries"
>>         Link: https://lore.kernel.org/20260709044334.1741263-1-anshuman.khandual@arm.com
> There are still discussions going on, Anshumann will be look into Willy's
> suggestion?

Responded on the above thread. The patch should be left unchanged
and later if there are more callers for printing pgtable entries,
then earlier proposed new printk format could again be evaluated.
IMHO the current patch as is should be considered.

- Anshuman

