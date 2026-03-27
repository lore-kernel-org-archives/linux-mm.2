Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 746D710ED640
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41716B0092; Fri, 27 Mar 2026 06:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18C96B0095; Fri, 27 Mar 2026 06:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E0C6B0098; Fri, 27 Mar 2026 06:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A159B6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:09:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 472EC140DC0
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:09:05 +0000 (UTC)
X-FDA: 84591419850.27.F9EF0E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6945914000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:09:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FRO9T+jE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774606143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKshimaIQgEFCem7oL4whWb6C/RFTmrwtq7Q1tOezPc=;
	b=avrQYdyZTplDZJac95ymH7GDIdFxnEz980mmOZl929P7AjNpEu7vxd9RK4VFx3Nfjff2g9
	adJkZg0Ae2nEpd9O+wAcsBP3PEaoksXlC3DHhrdUFRblveLLxNq9s5hrhBkd6kSNKso+M/
	a3f9sLOnV6bnzCq39sWTPsIIHbzB3k0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774606143; a=rsa-sha256;
	cv=none;
	b=YGf+o6MSmt45i+mf7CanRJFGduzF0fsUhmqlolbPtNtBLfCi8lf88omToSfqd8gpEWHO75
	MoNWqaPJL18fe+GD8H/++yVzTY6Rqq+jNZhUWeOSoDdGOln1wUF2OQOMvrLgQTChk1DSdh
	Z80V0yTmF58xX+pKeaJzTvFJbpgihOU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FRO9T+jE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EDFE43964;
	Fri, 27 Mar 2026 10:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A77C19423;
	Fri, 27 Mar 2026 10:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774606142;
	bh=XJl6davOB1UKhtP/CmtPqusFwBx0yuKoqZmBfBuhfho=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FRO9T+jEUqFsA/stouSLI3/Ptj9m3UtKoM1ZkGEjDy0YQJS1cweK3u/ksADPcTTgI
	 ZBvu5onbBsUmgErPC17EUpdVIjCY9XSDcYYt/GSqSDSPTKEMQDtsbbXvdo3HYgQvnx
	 ZIqdPZ/OfiVcGLoO4dzECYvpqjOyVKwgGaWq81oR4tpPkF88DCs5sVxbnRqMO7y7ql
	 7pcG5qYPAd5oJub4rp3Ze5Ua4q48p3xU85EmZudCWtJbk70Ew9bDrRZywDfIFf5VtU
	 NDw+jqj9WjzJZRBSZEATBisszom5IiFGJyS8Q07UvOz06UqUNllZTUBSGXYv7/34Hj
	 BAcvWqqFyEclw==
Message-ID: <7d6b4401-e230-4ca7-b64f-c1277fa643b8@kernel.org>
Date: Fri, 27 Mar 2026 11:08:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
To: Audra Mitchell <audra@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 usama.anjum@collabora.com, colin.i.king@gmail.com, avagin@google.com,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <f7fef55d-4334-4d1d-b6c6-b409fea7e2a1@kernel.org>
 <20260320184010.759461-1-audra@redhat.com>
 <20260320184010.759461-2-audra@redhat.com>
 <a4fb1d56-8c10-46de-acf5-9a00ce0db4ad@kernel.org>
 <20260324162324.6efa49422d145afd4dd37dda@linux-foundation.org>
 <20260324162445.fb353f4d2c85d89bc25be03a@linux-foundation.org>
 <acQMDW9qM2MtYpkT@fedora>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acQMDW9qM2MtYpkT@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6945914000A
X-Stat-Signature: d36rx376777p54uuqigy815cqubjmxt3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774606143-607521
X-HE-Meta: U2FsdGVkX19t8buE5aQM6rDPuzWfUCcOFm0mt+tHhhiQf8FpmYTtuEbu1nGa52XONYD19eWEjIkXLAJUP2V3PO4EvRM1u0L6a9RTXAvlF/evNfSH/dxK5YiIW4WG2Jg3S3zrOchXN2Rz8kzmlOfG3AbfhKUQ7TkKJ2wwSw6oyXB+JWHIaig7CPxVDoSFxd9svuqH3q7KI5EnfeVZRXQVXPIINatdM736ERDz8o89wWnWqibWCV5uxXKHcGoCAUDi9yYnb0a10Ru2wVesZjsKWdZDX0A82/PbWoLyX40ACHTEffM9eq4Xorr6il2nlVwPloK0BMLUqU3FHNQHtSaxtaEg580kas+vJpxSQma/vI5xTxTGRoho0PqiremYKb56o/20j10YakJCFMSKsyoQgeSNFAWlY4Gj5Y6GQWP6pov2wldQqH2fxes8DdvF1JIise8eprBjoIpUJZEEONROhriqdglRmIrvPXFnjJPWZm+FyCIyycH36726yha+LwXpjkCYn0PAHFux5malAOh4AZ9Iyi2URF0wY2wEBFAGz+IUvJ+DgC+b1LoAZiPb/lf0C0MA08C3Z1yIgDeFqPvRsfMvcfYbekM8qKnY3oGh3a6z0zoYNLSZGHgJJIgd3RG0n/UZ4nUAs4M8HHU7DtNYS3S8xFC/7yvSlMQ+pfhEQyS4cpVhQyGGxZDiwGN/gDtGomU7TiHNLC2wsO1BfdK0HpkfR767f9knpeIfdbUam2mydCxEnpm99nF6Nb5wUkEeih796tJg3fHfWCvG5YQCCOAnUuiUSUC8ao8fiMLubBuexUbEf2K2yV+C+0TmCeuOtMpNMluUW1gdyTfXtIiG9HLMBCdCHNdhIbdWm1QRnE2XTxvLgpsCSCgODdJM3K+NJKHQOGRo1M/AXoYSuoFhNvx8N8m/IWEBNIIxZuZtIUMkFIKrpNhX1OiQcgl346SxUdhhbtlW++nW5PkblIY
 KX8/DEFX
 b5lHC2ZPghbyJhGcbkK89y9owkm/OfUsiSkn8cGPp+hEWksBkt3+XNKI0Nyf7/NFETt2TAJALhj6IwYkNEwx24D4Lfwh1HQdd23gUanwtoVkcnsa5wiCh5x59GuYxLhRiq5A73owzR4s5ko+iH4Aej3uZrdkMwGy/0mHoS9HYR9O7pmrToP7lza+amjQ6rnHmwv/m5bqfu8CBAtzymjF8iRO7OnoFMHdnAzNwILZ8mpLtg8yEnsXU+N3DNEgHXAAXi6xOG/x0EFM1LFsP0XeuToIvLIYFG3EhMNN/1wXnN0gYY0WD+8XOFHAZssZS6dTwPhh5RoamBfraTDNdniT/7NI9644dq8eNuia9dpTk7gvKottBlXnlv5VhVGiwaOIaPmsfq7wBySPhPBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 17:23, Audra Mitchell wrote:
> On Tue, Mar 24, 2026 at 04:24:45PM -0700, Andrew Morton wrote:
>> On Tue, 24 Mar 2026 16:23:24 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>>
> 
> Wouldn't it be prudent to also update __pagemap_scan_get_categories
> return type to a long? Right now its uint64_t, but we expect a long
> to be returned from the ioctl:
> 
> 	static long do_pagemap_cmd(struct file *file, unsigned int cmd,
>                            unsigned long arg)
> 
> I've made the other changes, but I'll wait to push the next version after
> this feedback. Thanks!

Yes, definitely.

I was under the impression that __pagemap_scan_get_categories() could
actually return some kind of a mask that would warrant the uint64_t. But
we really just return the result from the ioctl().

And ioctl() is defined to return an int. So you could just return an int
there.

-- 
Cheers,

David

