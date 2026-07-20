Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6B4C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 08:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038026B008A; Mon, 20 Jul 2026 04:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2B686B008C; Mon, 20 Jul 2026 04:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BCC6B0098; Mon, 20 Jul 2026 04:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3B9B6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:24:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A5C61607CC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:24:20 +0000 (UTC)
X-FDA: 85008467880.26.BB5A9F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5B7EF40003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:24:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QbM2QkUD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784535858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ekzku1wsCsF+sOCtcbQyG65mhhqv0A4ZUR3g0lGJAY=;
	b=ovsSlRnAQ/y5DgOmIvAA6lWhOxVdtfsEya0STJnzSZQWAiIJTlMEt//fWgQok9NPksAoR9
	EDSy95G4gG2yhX3xPVWNFXna0B+RjBBTiaAbPg9phq9w+DunGGxME0a9mJdnmCaFnrlVkc
	J5KBw00X/q/MqtC9yEDvM4ZiGPFU96M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QbM2QkUD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784535858;
	b=qRaShKlc/WYw7kIR4N+v0H/YTlHY1jmFLr1X8uLmNTRIrIMjvnX9jLTiabSf9A7PCJQUu9
	rmRlNv7gnSLV7OKVk/zZONXjHM1pIgDiyKrRu80b7HqT4JkfV7hhB9tISTfuQ3dCN98Wu8
	FffrVBxYALSd9YumK4D1+S/qxlXTB1s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0D51601D9;
	Mon, 20 Jul 2026 08:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFFD1F000E9;
	Mon, 20 Jul 2026 08:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784535857;
	bh=/ekzku1wsCsF+sOCtcbQyG65mhhqv0A4ZUR3g0lGJAY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QbM2QkUD5uKL3nFBRtsXrKhSrS4fbO90dxM5Ip/R4mwgDxtpVxiQKvcbXVTFmMcmZ
	 8OC4yQbnxfmgdR+DszkxvcMHvhLf7UAFwtExStMW+jpCjv7y1loqQZD59ZLrQLVPzD
	 B4FdGUn7u1IRFU3n3kqIdR9KOvPCD5dUnaKume0tO0vem9xd0B++TtAsMYqiFn7mOM
	 BSISliE84VcxudbbE7x9NuF0LAYDtV/WQ9SlRD1fX1FrHQcA/z8fHO9QpeLSMSux2A
	 a7d6Z6jCjOUquVpe42mGKH2lBHjeV1a8ZwPnUlMLlwxeouPt2zdcPSWzBbVJl1cOdQ
	 nx1L6RbB9gkBg==
Message-ID: <d3b2b0cb-7934-4f9a-ad25-f7af3fdd1d8c@kernel.org>
Date: Mon, 20 Jul 2026 09:24:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/folio-compat: Drop superfluous return statements in
 void compat wrappers
To: Hongfu Li <hongfu.li@linux.dev>, willy@infradead.org
Cc: akpm@linux-foundation.org, liam@infradead.org, lihongfu@kylinos.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org
References: <alpmcNoufw0T2EU5@casper.infradead.org>
 <20260720013703.4257-1-hongfu.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260720013703.4257-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 68y8qyjdr7eanj11a9b1f9p8hfawc99y
X-Rspamd-Queue-Id: 5B7EF40003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784535858-101460
X-HE-Meta: U2FsdGVkX1/imsvSsLCxCbsd5YpctIr28ThKN44h/JmIOyYOH6v1l6DAIZvqCPYoJlG2cw/rJOVdEc4OakJ+HsnPK9a7VmVEL24l3/J8zN8PSkLEMBm9ulKlh8J1wLsNPtpgxEly/kd68X2MWdQ87VN4oEDOr+cvQJsQP0YHFETFa7ui/vc2wHgSdCx2qQT+jt13jF2uQWHKJNb+Hp7LDSw5IAk5SyIz+KQPHUOl/nVGGxivfOuZa5YtWqgXaOvaCHwpNR1CPSDJ7kA87BdfaB4OCdhOsuTPPuttLFS3PHOMRmdtHh42VkY1Td0q+6DJroH3FMCT2YUy+9e8uERJUnjLMILJ9496dKSVdaCMWHTQMmaANDYI/LENrrIjyzNIa+ar6l7YAiBNnd0qXgWU6KC/PAuSvZXyPTTjm7B7Qbr1YfKKxrUWMHtB5NlHhQRcnK3VWPypllEO2CiKehzJhnScN16MFk/kqmqbzubQnliUgQjsTx8GTpT51uzBPPRMM9qS0wj2Rfbi8T5rB45mELqBtb4TTHH5T2cqO/xkGqq58gbwlksPj4rgTj/rWO6i58MsgmCR2b+EjBDDtlIAuCGEKXwcYvKHZeWSy7vhiWpIv6Ra3ZJ+4hrObDa/fPa6VIbOowRPwocFQejJ63BrJfRhl6+VGTHUMIqtDsKJFtL11rbDGpsTlUaCo7mLVFjjpzfUEsSarpniQTqA5c59FFuI624XXcWbCQE7GD1LLoQ4NKXt1V1MSoNiYHuvm3k3hhViEWZD58yWP6F0jEZU3gumdB4NFToCcW9jVGM3YLgc8TZ+AktXKgZOmwW67shOUiom6KoPMEi+2rbpo2z5vJJnG8Z0QoAWwxbhawqbGnBhtKRNco4pEg78cGpZG/+yYvVOaBvdK8tHztavaSqco4eq/zf/a8Q3auiaRlE3fgAZQfuVAqvwzHbnHs56jwzGPwMLZcE4ptVtBdVxKxM
 Z4klR53j
 4Gk/FkN/02Ak9uGsj1aoTYC7M/dN2KO+Rrz2NVwu05c2gOYXs3Z3Q1pXbFFCy9SKcAxEFT2p+h6cmmzXbGeie5MsI6/dzRoBCf1L5SGGkuBXerUfqLxQT2JPGS51vDP/dc0pMUaS+gLd5L+jFLPyVI7oEcFwqb4agRzlC79dVfhNDCYvFgacGIi1Beqn0+rUSbITOft6kJJTnD1kZgMG7e31G3XhDF4PLgg4UeqwQIXwl5KUn3dMXID+MWStqo72cFOAw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 02:37, Hongfu Li wrote:
>>> From: Hongfu Li <lihongfu@kylinos.cn>
>>>
>>> unlock_page(), end_page_writeback() and wait_on_page_writeback()
>>> are void wrappers forwarding to folio-based functions which also
>>> return void. Explicit return statements here are syntactically valid
>>> but unnecessary, and inconsistent with other nearby compat helpers
>>> such as mark_page_accessed() and set_page_writeback().
>>>
>>> Drop all these superfluous return keywords.
>>
>> why bother?  this file is temporary scaffolding.  if they offend you so
>> much, work on removing the need for them.
> 
> Thanks a lot for your comments.
> 
> I fully agree with your point. You've already made great progress cleaning
> up this temporary scaffolding. I will follow your lead and keep working
> on reducing usages of these helper functions.

As much as I agree, this patch here is perfectly fine.

-- 
Cheers,

David

