Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA47EC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09DA6B008C; Tue, 15 Sep 2026 11:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3776B0098; Tue, 15 Sep 2026 11:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5016B0099; Tue, 15 Sep 2026 11:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACE346B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:22:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E6E040479
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:22:06 +0000 (UTC)
X-FDA: 85216362252.21.4AAE3E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 54D554000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:22:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aqg9v+6M;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sqGaSkvdWQ60cpx32km743ewG0ao4oY1eQa2iuciX1s=;
	b=s3bt/hx2hr7WQuATcAa6QLue+i28KRuExlhKj37bJ1TuQ4mnr7uByH2LGJ2JcvBufSiEr2
	EMc5DriDNyMcb+CaKlbHt+z1QZYUcfbjjmie9mcifzJ5TyoWR0U1IWy4Szwcm4UFQoqGHL
	d9kCrqFZu/u8o10MTCaU+3B2JXUM4wI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485724;
	b=K9YRfKP8X5ZAUa6sBZWuKx9o/e1Q1CeIkL5LRrvRyUdwUOpC+VLIlcVTuTUEZFBR/PaG2W
	T97/QKiElgKdTh0Xfin5OusS1ezePIJgkecqgINwjBbRjJ+tTYbv2fDh35Erq+GKiM7Y97
	ydCmhH6nnV5tM+qnYByzFBycWO9JURQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aqg9v+6M;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDAE8600C8;
	Tue, 15 Sep 2026 15:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FF21F000FF;
	Tue, 15 Sep 2026 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789485723;
	bh=sqGaSkvdWQ60cpx32km743ewG0ao4oY1eQa2iuciX1s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Aqg9v+6M7v8DblQ+f4ysGGJ/SH9uXvVsSGeD5+NhMVr8m7krgF1WahVPvj+smpTaa
	 gpXRP5d/hxHr3CKK3jevO8UsSTo9YkbaYLJrUBzfRFzRhkMSCvKW4zPwnvfYyfZrI9
	 8174JctMpSjXK//CZOuT4QZf2RA1C/pDAOsEWdn0/uW80BGaEg+SKefERLSqsdpsCb
	 F0bj0i4KxNcD/26Qz1NK9G9CKVvPtpEFdUJ6LdsYPpN2qL1e8l8ZIZfAWIGHfRd7QM
	 N/VZPcv7wjwQnBt+Tt9r9qux/kEJI2bhZ2/8CJc0goHX0rIAeAp9XvPdtAb3OHn334
	 DD8w6mTIXuqNg==
Message-ID: <e7c72ccc-5c1e-4f29-8768-b30c01225e29@kernel.org>
Date: Tue, 15 Sep 2026 17:21:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 jannh@google.com, willy@infradead.org, pfalcato@suse.de,
 rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
 <9f51ac27-24b2-495b-b397-84865f977d24@kernel.org>
 <aoXRi3ngBhO54Akk@thinkstation>
 <fd179a26-fd69-4b5f-9af1-b3755ba9030a@kernel.org>
 <aqkg_iU46BJghUNk@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqkg_iU46BJghUNk@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: sdatwa36157yiaitb9f1dp7eykpdcrfa
X-Rspamd-Queue-Id: 54D554000A
X-HE-Tag: 1789485724-96983
X-HE-Meta: U2FsdGVkX18vk8/bdmvDccEO4gEdjx/irdSez+DPDdIUydc1OrbwNeCiBFROISgdHTi+ycbVZNWuZHmVmfEpila1gMJjhu0vjOKlYBViKFzllS5dW693VjtZ7SvcazveL42/mfVrAyM8NGG8ftlJUmjTlW0sQoKS4x19XZo3FqpHPIQeKI34idFIo8mqzf9cp6GaT0Xn2DKkri2PtNv8kxt1/35/DHzvLjPl3/RrCMsTRNMaEMIvVGaSxmsF3YyWgEhJmud7o7xnr715iyMkWbFgVoWj9PmXQUwxMXKYiQYMlqgmWca8xJmszVDSJOs8sc6SbcrQhsHHhjhbbck9xq0q+s44FUi9BLshyIsRLj29D3GySdFbwi74+2O5G1uk2cWWakgMkj3xsYCfdUzVgPYjIOICFu8X8OKRM9FVcCRQ1UZ+4ldRULQm2B5GYymfesdZm4V6qpLDaKtBF3QFECzE3Tob35p1BrPBYTW3eF8ADUDyUEkrdl9PxacmTVZMCBIvvBFuXseTzc51p+zPKm/c+i3zM8T95xzmQb4/S+qLfrtuvbuIPifV18O+c5zKfaRDmZYgGGmzbtXKg1LoFezayOhDSQ1Edg6V+y4jHHAOAX0+jX9IqV0YLZ6sUAxplctdWDo54TWUWaiTQ54CF4zD97u0Cf7mMTfmiiMO5GNEuqh5wSi9zTUORVyw0sHKySBIX+J0904QfdPMdr12J74Frhr+qD+eGWO6ECBmL1nyedWN01sA1LTNlDozmWSya4KjHr5eab6CoyJ3Pj6nKX2vV08pbr5SfamY5iPi8P44bCf8F4E6jrGTanDHMMyZLsrtVUUuuarIhJCpgTnGwYY8WWIYTkVAoRHAzeYc16mpFeiHMyT0hxL7QavnGLuib62/EvEyOxsDUmzb5/uClUpHjVcOl6kodAToGnXz4z707X+Nd9WD4F332jlgm0zXm6pj3eABuFgj6LSwm4+
 +c3jZgqu
 ktryUT3h4m/DirnrEywCPYvQFkljSRkG4k9cV8aT+kWmXeGdeqGPYurV4n7CAgvZ6XDdwEWd9Z5BxyflQEDQultk6a94QfkqbVdHga5OFV8kxr5O62Y/ieYQwhUK145TQ2EVK24wvTFfWFBBL8vGnpu+Bsr9H/Dbehpn5tQmMDvuywT9lnm/2LnISO13Wqiq/4TcNV+lnc3nIXa7GGGzmBxg3DvdGuUqQW+VBoEwArFQjfIYkUjBIBWIwVyc6sSigAz8F35LwaJ6o0C8sYE5OXPvTxiO6nHuyPUEi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 12:46, Kiryl Shutsemau wrote:
> On Mon, Sep 14, 2026 at 05:07:37PM +0200, David Hildenbrand (Arm) wrote:
>>> As I mentioned above, we drop the ptl after the freeze. And take it a
>>> second time for the install.  Allocation and the copy run in between with
>>> no lock held -- on 64K the copy at PMD order is 512M of it, which is why
>>> it cannot sit under either lock.
>>
>> Hold on, are freezing all folios to collapse? That cannot possibly work with
>> COW-shared folios that are mapped into other address spaces.
> 
> I break COW for worthy candidates in the faultin prepass before freeze,
> alongside swapin. It simplifies the picture substantially. No rmap mess.

Hm, okay. So temporary memory allocations and page copying.

-- 
Cheers,

David

