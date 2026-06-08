Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEBB7CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 13:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C2B6B008C; Mon,  8 Jun 2026 09:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323F06B0092; Mon,  8 Jun 2026 09:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2609E6B0093; Mon,  8 Jun 2026 09:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 195A86B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:29:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC8F8A0B4D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:29:54 +0000 (UTC)
X-FDA: 84856828308.05.B99742F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8BCD5C0004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:29:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="NJc/kQxI";
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780925393;
	b=gZeMQj3xmEGgFEkF3LFYikIj80D3tla2AA+g8RDZRte8pG/lhLLMfmtUnaVnEYXj2GPi3H
	W602nyZ4LfOMK3tWD72FkZXVeijnQUkk3tk6edwq6acyRVlmk1RGfpLXbixxLQaAIj7j5v
	Q1/+CVi1M27EmbMUQ7fCwt4sfEY6krI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="NJc/kQxI";
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780925393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUkJBSNOnoA10/A6KDnwlKgtc8FUefSWsQrMwnabMn0=;
	b=jzLEpJOz20sqLDZ121Zh+8hG3Bnweq/wtC153z9sI83j5fIgxGMHsYqQrjcetbkJq7caHv
	yWy4c0BYFVwpKB+YRi7YTCogYVv+mOP2bPn3NfUYSgzFRbkPTNLpUI0v7iHZ4o33mdYF00
	rSdMHTe/JG/pql1hti/+ukLGOTyb2Tc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 974DF2403;
	Mon,  8 Jun 2026 06:29:46 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FE823F86F;
	Mon,  8 Jun 2026 06:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780925391; bh=c7M+hivlyg+F6v5Mi/L9hmuj5dSm1f0V79z/a0ReWCE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NJc/kQxIs4jkLrn/5fXdA0MXYh+Ww/rixpyzsiBMMa86Syzya8YxfMjSldU128au/
	 rPV8JVR17KkDyhaNCNLOr6QR2f5dQnk3QgZpeqawEIYja/rq0RzIpVyMeXgtY/6+Hi
	 O5uv9VzrLBv8lkr6GQTQu3MFpS4JatWZkhqPOSeM=
Message-ID: <903740a1-d48d-458e-8fa3-c129c68b5390@arm.com>
Date: Mon, 8 Jun 2026 18:59:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG?] invalidate_lock not held in read_cache_folio()
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 David Hildenbrand <david@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <5ca6512c-bdc1-4620-9c99-c7525e059099@arm.com>
 <aiazUtNaS5mVlaCy@casper.infradead.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aiazUtNaS5mVlaCy@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8BCD5C0004
X-Stat-Signature: ypae1co5stggcr9rf83ac9g3b96gsa9c
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780925392-718781
X-HE-Meta: U2FsdGVkX187k2UHIKW+DDz2hzglYr5WdaVa/mu7fKGKViIDh37pUrSwC+I4ArS7PC+YLfAxYH4gdkTc6yAjWwUW6//0uYS36H8a3V9do2ZMCtMFRJuMD2UjEdG0tGqXQnXbS1+s89EQ/ZTljYXSnaSi9QQAqVDSAqsHtOsxErXBzgo1U1dk6nt9Vx5wmxXVyhI8vn0ej3+v2WimvmwD/T2KU/DBIGJI7tH01kcZypNUHKFLnmN1PlWFG5O8NOrcjaE9YZmoDah3r4YhAG+0jpycyS7cQwrYTflITR1bJ/TT0vtO1Aapp1vwEHCpOzGs0UG1ecmedzi6Y7AsrktPS3l55EFmtw/BUSgwDgjqznq/+Aiiv6KXY/lOcoSnQ8muqXi2QFHeLOd2/k1LdodUuV+4ttZVgoyu/JjQszpydlh9rVYJXSM+zi4nM1r5bX8J/nVGJFZf6WuuiXD3Hfzc3221wggMQUDG4nDoBe0eGih2gdKCNb6aesNAyF/ab9xrfjhzpJMpc7OIrGoj4VmWVZreefc6M0UFb5DpFI74uP7pfqD0fSHGfLfUvaMJmU5IFcOxG2iJbprPFEwTY0Iwh2I+aPQvOL4FBlzFwNW4wQCoGJkTfZzpvT/1gk6YtiWaiJEZk7W/X9cZIr+48ppOB+0koM4fdxrTsLQMjcohUcSku2SifhYZeomn0yvu2qQC65fT0iERdrt8u51x7/QiXHrycCggezMfc/ZNZ1RvEl3jOP5aEcIXfsqQTxAoxP9Xn+HCLju9J4AUq697t3NjWLle6+gpt0OPvF66iVuuEFUmeKyS0ivIDRXN5Z1dHc8MHn5SgxEoqg2ONVbWsSNWFsq9WD3QV+P8ANJmYiRSsDl1hmv6qnTLHxmhhHp6efrSJMKoCiau5rqPs7+5kSnhR22fkrJsjjlhsG7Q7cqLtRX3JnOVQUJlo+FKCWi5mSm0meLoyrvPv+s0+stZLHx
 Vi3lFqK+
 SmSe/hAIPQdFlYYDTLvVzjWD/K7sxqTlBcLvLrx+MxteWOS0tvwBruvTcSBn7ud8jUfARIQblCrOdIn12+9aYkFu3qJV/J+Q09UFrlJgTM5oH5vWKH6Hb6InNe3KvrCocVSMN4scZrHZfu7dDhdFh2ZEb4LgMrJciT8co7cPptKmLMFSl59++7z+zyQNuuSNf9rL8BBnLEmZIKAEeXPZ1qTZ1XYrzwdEodp796jrLI6rWgPuO3ffGBaYDJepbbdNWqwt4Cp3ZCpqERVnRXX+dUhyESeXKe6mOOresc0kvmXujErgwB9KJHPEZByEr/8mz+Tt5CPbJUjYIw3As4EQzzGyk8nOzxOf4CQRzzro6jRtdlXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/06/26 5:49 pm, Matthew Wilcox wrote:
> On Mon, Jun 08, 2026 at 04:54:51PM +0530, Dev Jain wrote:
>> Hi,
>>
>> My understanding is that there are two ways we are serializing against concurrent
>> addition of a folio into the pagecache (see 730633f0b7f9).
>>
>> The kerneldoc of read_cache_folio() says:
>>
>> "Context: May sleep.  Expects mapping->invalidate_lock to be held."
>>
>> I put the following in __filemap_add_folio():
>>
>> +       BUG_ON(!inode_is_locked(mapping->host) &&
>> +              !rwsem_is_locked(&mapping->invalidate_lock));
>>
>>
>> And got the following trace:
>>
>>
>> [    0.115587] Call trace:
>> [    0.115686]  __filemap_add_folio+0x5dc/0x680 (P)
>> [    0.115871]  filemap_add_folio+0xec/0x2d0
>> [    0.116031]  do_read_cache_folio+0x144/0x2d8
>> [    0.116194]  read_cache_folio+0x1c/0x30
>> [    0.116344]  read_part_sector+0x4c/0xf0
>> [    0.116499]  read_lba+0xb0/0x1a0
>> [    0.116627]  efi_partition+0xa8/0x740
>> [    0.116769]  bdev_disk_changed+0x238/0x620
>> [    0.116939]  blkdev_get_whole+0xac/0x100
>> [    0.117090]  bdev_open+0x280/0x3c0
> 
> You can't truncate or holepunch a bdev

Yep, I realized that later, thanks : )

Just that the kerneldoc says "Expects mapping->invalidate_lock to be held"
so was wondering whether this comment is appropriate. Difficult for me to
reason about that since this goes into fs/block code.


