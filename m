Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B196CF94CDC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E690B6B0088; Wed, 22 Apr 2026 03:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1ADE6B008A; Wed, 22 Apr 2026 03:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09256B008C; Wed, 22 Apr 2026 03:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC4B16B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:44:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 738D413C3E2
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:44:09 +0000 (UTC)
X-FDA: 84685403418.19.5FEC175
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 698F180006
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:44:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FtOJQCgk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776843847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmS38NUQHeJeqrUoD5gSFHYpX1o367qouos4Oe2M4/Q=;
	b=OqqUMsom/TQOYj0DkJKNFhV5PEHkxUcPwS41bvMMobPd/6o7QoEMvKhNLsezV1p1oFFEVn
	l0ORe35+MBh03+IdMzhUhQYe2OOI9ttE1DbCvDXyGvOgpJWhWCGKPJjAkuxiF3TIiM/msM
	2fR6K33VRGspepKtL9XLnheG5n1VAw8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FtOJQCgk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776843847; a=rsa-sha256;
	cv=none;
	b=LCYz96DVhdR0vKCf/zkXfkgo4k5sMeJ2vbGMEdaZxobp6muEAEBCQNRsWvLr0qLbeoZ0gS
	hwwDFUkYHW8QB/wyselfdqyaO61ByDwbiLSsdA++uFNaQ1AygIPyW7zxtBtizcb4CHkFpV
	GGju4Um983CwloDWt1QCyk2aEbNqH0g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 39E1340B1D;
	Wed, 22 Apr 2026 07:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C9AC19425;
	Wed, 22 Apr 2026 07:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776843846;
	bh=vWLjnWt7YlFAE9bRILiFkIEkqtF0XExovSeFfrogYw8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FtOJQCgkPikLqgGI3awmAu+n1qOETDl8CpqMIe462CXoOjXsqw8gr9+cVQWpR2zGd
	 fLipr1uIKIEbW5txQLdqkrZYfGwsVxbLFRbGDziUpKe8bg8x21czlzwDX/PPypX3+C
	 mdhyg2GiToALg5OZmaQAb33vjIjDYNO5yUDrZWQ3G7mpHZx0r/WC5100WlL/bDqbQc
	 p8qboliNzdCWFbxNfQRb0hziRMjOvU0xFhlFMX6fVp0m0LcKgZad10aKikqCGp7jYZ
	 kcGEjng29R2OhnTmny1bwQu5ADqslBUj+xvEWyttmeYiMTP2PJihGk26iExz5Q2pn9
	 zJe6KEK3DuPYA==
Message-ID: <177d0a41-5267-41f3-bc77-415b756ea4bb@kernel.org>
Date: Wed, 22 Apr 2026 09:44:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] WARNING in workingset_activation triggered by KVM page
 fault path on Linux 7.0.0-08391-g1d51b370a0f8
To: Zw Tang <shicenci@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
References: <CAPHJ_VJGTsRDc7_Kv0oDObuDX2pJ0evcAvH-mnD_RYMX536+mw@mail.gmail.com>
 <e48748ff-0fcd-4561-9958-124dd853e70a@kernel.org>
 <PS1PPF7E1D7501FEA2B54606827E0DE1805AB2D2@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <CAPHJ_VKsVzyYzZ5ZnBkNbYLEMXDYL5x+7jfyUxhcwT1j4zPXOw@mail.gmail.com>
 <CAPHJ_V+L92DxzEB=4+Tj+C8MNBW7LM35xWYXAoLhHqU5p2nxfg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAPHJ_V+L92DxzEB=4+Tj+C8MNBW7LM35xWYXAoLhHqU5p2nxfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 698F180006
X-Stat-Signature: wyhapm4ruxjsxhq743b7yoajaoh8bycf
X-Rspam-User: 
X-HE-Tag: 1776843847-353842
X-HE-Meta: U2FsdGVkX1/79jakPHVeCgWkXntTs/vm1viwXt3gxJkiNIRYQbW/S9Ix+qX/rzPUwN6jQnOL1D7f8lblT9U+SydpF9RMqGZ8hueAAG3IZCwILpUVdjyEdTYUeREVc8pi4nqCpowizgUZLt5KG/8rEQHM3ePouWabFsEJgDa1nY6H11mNi0OD1DXA23QVxIKJGtwodsBwJ7abTJn3P2kWw2bAgeTvN+B8djYpjWEnEnb8SmazMJmW4oh63FjS8WPGuTjdpuGRQLK9akM7BfKfmUz3umFfteZ81AoPnpLGNmWE0aZCpIEp+nrkkrTiRvHvaYnjVgLGwze/buiw6bUakIr221h8PEMfu6Ve1v8Geg0NayPjfC9zOycYtk0RIYY7ryKZ2VQvkSPtdwVlNenIcqEfVY9ZVkMka9BtYXhV+Ezn3gWdLHRv9V5Ej+J7l0sLmA3XOBdeUhFqxB014eMEsZEfnAXQtZkzVDNCsi4umQwPMB4PLvyaBkhDzuorVkQjDe1aD/yS/5SigO90KT8hveDAZ75HlH51hS7kLRpW740KV0mIzTyNq2tHsNpGLkFVicFMZUgTGQgZKY146/3ZK5jTBjxlcF/PeVrE72vPcAiAEsPo7GrLI0g2kH8ENp4dfqRA42wBZ4Ywpoe/grQc7F3ek43EmmeD/WS8GOpePd6YLryZOv7ucC9tSB0cBK+dt/fbPUt9YiOZw+kVru7nA+00C5hDb5MunUPcyF395iEd5Dv6tlv3zvfACAgeftiot4Skxfwu+wwdxiZF2udRYl7eN6aUjV9wuoi40gqG2M8p5a/Pq7MMRRNhRZIhZD3A5Iww5uoWnU8vvVCt0Fy6CSiR+suuCCg4xGpjBB7v20pUt5jbV1FgyWyui10pdPKJv7HD4Eg+fSaSmDhGmFwGShyAxvL8N+CJOi+lneKY6smKaQ6NwyXK47yEN/ce3m/RMwFGsAr1SKh0RrDoiOv
 soPLSCS+
 cVS+TBdhN21JZxRWwV3lEKzGY7CApxsraMRD9BJy4Q+oDRKBvRXmVstWWMs/WzrYxgqrzmKqfGjrCARy3ORacPUlppZURW9YsRpcm029PM5/XAtlttTZt9EMUHYJpX/AS209SZ8EVQKRNrVguObSiSnIIDE4ywBMjEX2cG7qkXj8V+4+oaZfGAFbmGKIJLuXHqH5Fn1eYdb+0OV7/6IopbeC+axXFRNwvdhu/GoR4nlQr/7QtAlp8BU68nLikgAgH+0/wxBaiXxdWFVtMXTAfIb30qa68EIJHFK0sR8fGY0kxmckSAEn8PN7i00ev1L0g2n9EY7bYuwiztf8yrdbwPSMt1IG5O7uRGsXdYbdinEPxJ+7t28SZtncMMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 04:06, Zw Tang wrote:
> Hi David,
> 
> Thanks for pointing this out.
> 
> You are right. The commit id I sent was incorrect. I mistakenly used the
> git describe-style suffix g1d51b370a0f8, but the actual git commit is:
> 
> 1d51b370a0f8f642f4fc84c795fbedac0fcdbbd2
> 
> The short commit id is:
> 
> 1d51b370a0f8
> 
> Sorry for the confusion.
> 
> I am also re-checking whether the kernel image was built from a clean tree
> and whether there were any local modifications when the crash was reproduced,
> so that the reported source line numbers match the exact build.

Okay, on that tree include/linux/memcontrol.h:381 points at

	lockdep_assert_once(rcu_read_lock_held() ||
	lockdep_is_held(&cgroup_mutex));

lockdep_is_held() would not trigger a warning like that IIRC, but

lockdep_assert_once() does

	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)


So likely we are calling obj_cgroup_memcg() without the RCU read lock held?


kvm_release_page_clean()->kvm_set_page_accessed()->mark_page_accessed()->folio_mark_accessed()->workingset_activation()

... grabs the RCU lock, though, before calling

	rcu_read_lock();
	workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
	rcu_read_unlock();


The folio_memcg_charged() only checks folio->memcg_data.

So something does not quite add up here?

-- 
Cheers,

David

