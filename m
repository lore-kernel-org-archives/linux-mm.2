Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F911073CBF
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E52F6B0093; Wed,  8 Apr 2026 10:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296776B0095; Wed,  8 Apr 2026 10:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC466B0096; Wed,  8 Apr 2026 10:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05EC96B0093
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:07:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD1D386941
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:07:40 +0000 (UTC)
X-FDA: 84635566680.03.D21D1AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D0245180010
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:07:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DNa2eNYE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775657259; a=rsa-sha256;
	cv=none;
	b=oZwb92dEi3zko0R79MhX0zKDkjb3XEre++16rmRAEsdHjUr2ZuDcOqd4G4vmU0c6EqpO7v
	6X+jA1AEDjS9eFsd0bU/Y/bqdqVgzvLe2QvQylOyjCyJurnE1/d5EoXDQQNWgg7DWfEYiz
	aTB3sAK+IbOsfLiXl3/bjg5jbOn+t4A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DNa2eNYE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775657259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uB85k2vDGr8cwDuEBb7uhm1tAiVQR+MqzBWYQiSeJ0=;
	b=4wemRN099elIi4brJQoN+do2jbCC3MAFAw49qsTAGeuK5NvFGfHP6F3mIoQDqYWpYOLtEg
	pX1Xo1q2S1jP9rocR0t9ck7jWzsA4vk2OfCg1+6yO9G6uRtyaKyLZMQ9M9QcWBH/SuWZcG
	/eVzUoCaSQ80Obo6+sR2FZefzTk+0NE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96DC2416CD;
	Wed,  8 Apr 2026 14:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C14BC19421;
	Wed,  8 Apr 2026 14:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775657257;
	bh=P5+lt51Yda2ZBLp41wke251xsRAk4s/phWYtTBgyOwA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DNa2eNYEy3mIdqofEGmbwfjnDuioPxR6HhgjTR8wJcu7lmEiQwK6QTNCRpZdWqACi
	 pulYZdEW8Xs3vClZq/62LU+zbXYhCAT8w0tbMJ/8uJQ1cA1XeQJ/BeYHBsCkyx7/mB
	 zURb7vmflCe5DAN7bKC49flwku3/oqza/ccECu5S8/bpyaflek5C6W07Shk3HPrX5M
	 g1727BdU8Dc1jgjB+njlQkENkBoV/Ue+wI/rxKJ1ClLyOSj5rhvzULPebJTWD7W4jX
	 z692bU5iMAEaBFqKaZTAzphuIMUq32vyM+/Tcl2GNK7VUZZdcHVMvTrd0zwto72C25
	 gRLZKIgdTah8g==
Message-ID: <2aee26dd-703b-47c4-9210-f70ffa6faf09@kernel.org>
Date: Wed, 8 Apr 2026 16:07:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] f2fs: do not support mmap write for large folio
To: Christoph Hellwig <hch@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260406154940.2407853-1-jaegeuk@kernel.org>
 <adSTUszGSlEK_IBv@infradead.org> <adWMAzmaHiYzSTzN@google.com>
 <adXhq-eEjJji1rcc@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <adXhq-eEjJji1rcc@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D0245180010
X-Stat-Signature: hjp8erom7n6akd16pqszojeh1nadtxoo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775657258-213926
X-HE-Meta: U2FsdGVkX181rHMwjN4snbBqIo/Mk7Kdy5cu3Z3LexslJXen7BdC2GfT/bV/8YKejelL4s6C5Pk8la+V7R8AxxIboBBn1PgzGT+OOs52HcH3O20fLepkAqrHSGilipXM7l9Ecu81RfUY8sZqeBl9CshJ8fw6mJ1vCcfvkbYwhN2o6rmSEB6DYH8o+nP+nXlUv7TD3UoS0ugxFvEkJVmsHJ3n9XcISfDOyqa3VDc/j4S8DU5beiov0wytC4mVHQUiI212dmYeKI7qkAUSaUMO4o5UE7gei4w695Z9z4z5luFMki7+GyRFQpOBzN7U7b4R5eOTNEXG12a+objI6TOhAz7TOD/0d1W5CFcw9EvF6qT6gW8qJYYrYPjzEXXIzc/AG6Yfbsii9P9Lm6yK+kF4RDgoTROf1buQUVkdGYAndualD9XAlYoLqQpGsYxXj9eLFohtBZ4MexMzi66Vp4VMDLHUaBfaxq23yayVd9zrc9dgJa7S2foyC0XVPF53Xk1YWQBLOBk9PxulN0IMmrDasf0In4dKgHWwWjvXiB4xS5tXj7O+k93b5ytpjhUtPeg59/+gMAfmEYdKuMP2iDkoLiZ4sDTmIAen9HTuhdOnFcl/qrnod4fwwgGAG+tZb0aoj3mtu0UHfasIMGtoMZD1ocQCozvmvdXH5xTk0OkD3OUdx9fEA+q8Xkpqu1CNvExOQtkWqqaeMfWgixw54aLoDkg0lxfdKMaYEs5XwPOL7/wHSf7HCmx0gOkuMuAZDwRcXVRDH24jwNj3rEsIloSNGnvJYqXNm7IyzQvPW6rqwh7jEIhAS31BKfurNw81BrMP6Fs6FSr2rctZv5Ajux0Z5FjjkCoCuN95a8EjhyHihwsqypjlPa0DHivsRMX+FYwk+mAWmnx2NQ+i9cHRbrWbPceZDrcrL0oEMC0l3uTgDmAs2S+DhmJ38LIfx/A1WxBq6T5wJgiNQX3lJDcZhiO
 hJxJEyrd
 g0jXSRxTI4lcdlYkByoZrdvwOK0ruW+bL2aDp2rSeYJsv06rg13SFM9vFq0pmq7VA6+5oiD4uH0NhIhnTemvN/YLA0YhGeESAMmQzrUMkKVcX+OwR/zXDVnHSFxjrGzA+cyKcJjqLxU8m4nf8C6BwTJubzNQBaUBasFoyl7sGg0OMS0RhDGQPKsBFBx+N7Wf8WjK5yPNluQ343d5S/ynf+jKCwNQx5DKRfqTQM6qqgabmgypxyLYXmrrRDGdtd07B1NtU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 07:03, Christoph Hellwig wrote:
> On Tue, Apr 07, 2026 at 10:58:11PM +0000, Jaegeuk Kim wrote:
>> On 04/06, Christoph Hellwig wrote:
>>>
>>> Why?  And how is this not breaking applications?
>>
>> Since we only support the large folio on the read case.
> 
> In general spelling such basic out in the commit log, and even comments
> is really helpful.  I'm curious how this works, though - by the time
> you read a large folio you don't know if it will ever be written to.

Why are only large folios supported for read?

Where is that allocation logic and how can that path even be triggered?

Also, usually we check for large folios by testing the actual folio, not
whether the mapping supports them?

-- 
Cheers,

David

