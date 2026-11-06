Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8C65606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KwGf57n+
Received: by kanga.kvack.org (Postfix)
	id 172C16B05B2; Fri,  6 Nov 2026 07:41:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148766B05B6; Fri,  6 Nov 2026 07:41:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FDA6B05C0; Fri,  6 Nov 2026 07:41:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD1EF6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:41:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DAE14A0D50
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:41:10 +0000 (UTC)
X-FDA: 85404654300.08.B7863B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 229561A0008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:41:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwGf57n+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMBLae3lRuQDJK5QznjTjPOTuJ0ZooX11mmURXzsTDM=;
	b=qzOdu26mH1ZOH9w598I2lv2kmxL4dS3GU490BYopTSnXFkjR0jW7f7CioBkS+htk7K9KGR
	kopcpY0IX049Rjd90/NkWJpDYw/Nh0iyGrkKyoJ8CrfbrV2O9hd96cokND8WCa/MXiKxdm
	0+gzXdyuQYcdz1CgcaMwUDou8pWqc7Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968869;
	b=Zjtrlpf2u1bFCFtRm8XoeucpMXL6di3E55KdvjbYAgCPiSitm6ezoklz2MJR7anELdPUSt
	dNpuZibUYgOffzuEKrXW1G2nu4GaQsfK4mZZq5GTMPAts6hYBESvHGKf82LiWLtOf/jQ37
	6P7DdJrdzRsUlv0525pW3SSvf/jXVbQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwGf57n+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D1D360232;
	Fri,  6 Nov 2026 12:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EBC1F0089F;
	Fri,  6 Nov 2026 12:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793968868;
	bh=ZMBLae3lRuQDJK5QznjTjPOTuJ0ZooX11mmURXzsTDM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KwGf57n+IdbnSA897QNUk9FhDl35OB3Kr0WdR+I9Mzbe3v4qTt3YJfgqGDgLiJMAB
	 r29pxm8iMC+2ftYzjas6w3kIuA2X1WdZpFBl70KY3k70BgHZ13kOef7qLy8hYMydlR
	 +weneF/AeXum482c1y/aCaC6XHpvbVW6w8rvBg7S+nj2m5ll/YDK3JzIuA9TE0/01u
	 GtO3yAGLNy14yqF6Ne1U6ZPS5tJvZKuWF0JOfvRxTyWWq5meJPDEUW5Vq6EUi5TW0I
	 9+yFtGraxcTbfWi+qnYgORUzIEkhSOCdw7uOUN3fsZ5yEfqmWJnCYyQVXGQLhnz6wu
	 GDBJK7TqukpvQ==
Message-ID: <455e9728-33c5-44c0-84ef-d6b764c6d9db@kernel.org>
Date: Fri, 6 Nov 2026 13:40:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: avoid unsafe anon rmap dereference in KSM merge
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261102-ksm-anon-rmap-fix-v1-1-68962acfb59b@kernel.org>
 <179387163181.11797.15205182972949028650.b4-ty@b4>
 <75926835-508f-48d3-a5d9-176cea61546d@bytedance.com>
 <au2mm0Y9PdumuzgE@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <au2mm0Y9PdumuzgE@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jcixse9zp43xtcasopym5n1ttj8yh5wq
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 229561A0008
X-HE-Tag: 1793968868-395678
X-HE-Meta: U2FsdGVkX1+7cRMAF0isSX2Kza17Il44Qxuagpj0g81mknir1cNqZh9apQOeHba6LTH1J0kzjBnWmxyT6ZKVMrolLtGyi1iZgSvfT3OR65re7MkYWSWsVXS25AF4wHgiV7H7ZEyZLusnXVznO3ZO8KQn+gRvLIfc9N90NQCbdtjkNiLMXSwdX8UjqX9eV7hvcaQR8CgIjQhbTw+PE7OtBAbo+4NuVswpU6GR9th9wdVgnXeGHF1XvvULBSnIWtJ025wHRVBzPx1OHx+TAYkZbSitV/t3O+ZqoqVyfqCMJ9wdFk4izv9x0K0nttoMMIOHek8EH52thypJjHs2MdRlx0ijBNRZv8SKtZ6pfUmV2w3v1HRkptbGxX+kRfwtej7Lu7TLyEp0ZixOyaCOw/D9a18QET33ir6sNwcFHM5KDGs86peyZDn+iZmQJxMV4GNVzDuOlVibZDvN1Gg+fvuVczgN+ZEwmJ/FdOrVlbrXNIke0TIhdKSMUPhnpFvIrAxZWkGYgDyY6zZEuWnn1I4Z9NRnO9mYGJIdO/LTjVwobhmIriE5zGn12d9PSQXq9y+w/xq0h1vIY7CxKe2pAUCZS60WxXFm4SgcKt+k0RiIXQWQfhEK6/XCxw38e4OOxfPP01bpO9p5dISfasu/GlZ1ZclOMflvQTZfSRPFkl0vbIbaUxyMj5xm1Y3fCyAQKnZ10Bf+lvhctkurWBoRyFnCG6t25jW3QzsF2Gbtbo0v4PJn13suBy3qwGrxHIxkZBCkl9DUinPCQL0JNioe1Tkn/PsGiOyeZrMJVMk7S+APOm2hIRLJ0I0w3jXbYxL3xDEDQdMJo0G5ueNf0MNc/QHZoB0wHgxg3w8XOJTqP9dZY9PxQvOBwSyI+5K8Soo612xoIkltY7SxUvAUJiAZb4NgBK0snHpiibEltEtwj9V4MX94o5Pu894EeuIWkFrrNAviPj1BOS0fDBv7iArlbAw
 9ZIYJeJl
 vUI1CmWiOEk+hCO1PbBEEUF+tv6MSR4mGPIP9hJ4dmxfiHqwqHA8LZfr82CPGr1KSMdY5MM0LTAZNEP9YE5nuph8xISmHGbHRUt7F4NDQmCOfUwuM7UNHERizA+q+FV+MYe0jf0JJseiiZA3AxERd8HrC3PYxiFCtlUiP2AQkB49P5HT4qwe8OYp5anlU9B6AEiRuC7mlns9VWzw3DfJDBDOwWQOgeVJNwjPO5fR/ltnhGcvpp+BPfqUMdiLx3RQ6oGF454p4uqVT+9q+W0ngqAPlsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 11:06, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 06, 2026 at 10:43:45AM +0800, Zhao Gongyi wrote:
>> I tested Lorenzo's posted patch on Linux 7.3.0-syz-13001714+
>> with CONFIG_KSM=y, CONFIG_KASAN=y and CONFIG_SLUB_RCU_DEBUG=y.
>>
>> An earlier unpatched run of the fixed-pool KSM/mremap reproducer hit a
>> KASAN slab-use-after-free in page_address_in_vma() after about 342 seconds.
>> With the patch applied, the workload ran for 12 minutes (1027 KSM full
>> scans) without KASAN, BUG or panic. The fork/COW smoke test passed.
>>
>> ksm_functional_tests reported 8 passes, 1 failure and 1 skip. The
>> "ptrace write failed" failure is a known test-environment issue; dmesg
>> showed no kernel error.
>>
>> Tested-by: Zhao Gongyi <zhaogongyi@bytedance.com>
> 
> Thanks!

Indeed, appreciated!

-- 
Cheers,

David

