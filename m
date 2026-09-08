Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B66C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B456B008A; Tue,  8 Sep 2026 07:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C026B0093; Tue,  8 Sep 2026 07:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D54A6B0095; Tue,  8 Sep 2026 07:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BAA96B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:22:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7D831A0463
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:22:33 +0000 (UTC)
X-FDA: 85190356986.07.EA30472
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	by imf31.hostedemail.com (Postfix) with ESMTP id B429520004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:22:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ies7xEzQ;
	spf=pass (imf31.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788866552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfFKgEaR5N0ccB7p1iUJntQYHPyNRYEKS50nvIP/hf8=;
	b=MBn+PKJWi6CiG4rE0TLgwImEeugMQXuWRt/M+McjIbcxUdm1vm+tZXMJcRUDJenk2t1/h5
	MgeUnL1Wg1my5iETG1pLTDS/uXDxVDY6PLNZ0V1w8cvtztZG2vOM8yJA8JZBeaXARttJT5
	uJLIt64beLVdIcnKNLKIzAecLoHOwvQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ies7xEzQ;
	spf=pass (imf31.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788866552;
	b=SV+YFYZq1KxvOyskV/701Uj6r+kk/7kxoUSTLnPq/4N+RaD5y6g83NkMPGv7Q1AWpr/++j
	Qz1HzirdaU1Bq03aGqR4Wci3t8ijq90r2QU/DMifU1eLrjaYSXySfMyF9P/BXttGO7NHC8
	8cR3SADqERNypVBmw+yQ2PzETpmYY+4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZZA+ZfYds4/VfNcL2acHrCCj6KTrChkpY0m87hvHxuE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788866550; v=1; x=1789471350;
 b=Ies7xEzQJf7JxDZI/4u0i0dCM/tumbE7X7UkIPTCa8Z5ARLiHjNVkfxiZ3PFHwp96chf3NQU
 dVIvz00L+tb2eBJs9D+tVhVjH08j1q+CO9C5+6xJMDiGR50gQGryYUZlA/6AjSIqP64De8daXGI
 nLGXEd1Hr+gXT+pXN1droyn8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1cd0bb8d8965546c;
	Tue, 08 Sep 2026 11:22:30 +0000
X-Mizu-Trace-ID: 1cd0bb8d8965546c
X-Migadu-Flow: FLOW_OUT
Message-ID: <df053a08-6c9a-4e56-9ba5-bdfbf930331b@linux.dev>
Date: Tue, 8 Sep 2026 19:22:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix size truncation in pagemap_ioctl test
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20260907135613.68692-1-zenghui.yu@linux.dev>
 <9a21fc3c-1ca9-42a3-a044-6421f20341f6@kernel.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <9a21fc3c-1ca9-42a3-a044-6421f20341f6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 3atmrdiiyy4pkzc3pcqjteagrrnyjwoo
X-Rspamd-Queue-Id: B429520004
X-Rspamd-Server: rspam07
X-HE-Tag: 1788866551-538795
X-HE-Meta: U2FsdGVkX19So42nVrjcUPaZ1QCTLyVVMqGoS+GNY1ZPtcAA1QoCS4xS+oe6B5Y7+L311rkuRuKQ2JnxqlrKPySTox09HCR54b8/WiHJLLGptJVlimCc4BXOP4o1O0A3QOfQYgd33AseK6I0cDornseI+65cA8saexa4IUolav2v0DyTHMhQactlia8SuGvLzNcmtEtVrXIN81Tel0b8V+CGJGtvXSIJj7id+Asyf+bqtEP0i+BKY1cYMJj6yFMeiQtzg/2EQ9TdwmMNyJxvDs8N2LDTCdkb0EUqXqSsLhFVKtbovOua/0sJVk5AizWaoqzZVFZLR6jEcO1KnxGPVDAkg69Cscd4r+eRalKO5y/1F9vSz3l2w2+P5wyXAXD1EW2wSskSdqri/9Wv/qbdeg6YhyHsasQUekTFkxTJB8bMgtLeAVbFK3BILC8Sj5dBZqHP5vYD5SGogBTagCKZA/cLYaRcc3K1ikP38cm9pkUkag37dsmOjzbY17ho76tqsKrqPgoVShZZEs3Pp3uXb4dgnZECe6luRwrj4A1rqnZauwvQOzhC1i5c0K4SwkjiyqionqJQTeVNx7AscdKU1yxR/+mNXPUWg5PCCbcRR8O6SxUdQ3Zq6Hl4wuO87DUAGJOJk5AgiV2zs5+E2A3ePvALvNj9TBusO1oLouoC0qAik7NTB4EdjeiucngO7HZo+OPWzrU9Rt5LUcov5Mi8pZ81yZKr6CWB2pbhHCczdmSozdTmCbBmvFKMm6cuO3DvbAwJ3k2bvi5KlZr9UCn2Yk0u79Ua6+kyCBobqco+whPK4q4hPlJeIiAG4OTpbY+cdk6C4NwABxA+YI07Qp/+HnEkHbzjirNh+TFr4Y7X0MM2N0+nQhsSUc39ALO6dNSgYNIj7k2JMNj4c27arqifCyNGzJ2uFyiL3/yhE7KGlKyFR6ZLOtx6E3Ase+6vuxE+6lwpvBwgqDYMAqc0REW
 5Mg6Y3BB
 zp3GkbVpJ8mnkJHD1VSGSopF6vc6TN0o0MiBJqEyPVlBi5MzcyJOId0WlE5XWS/5oMATC71f7zI275uYeRAwoshc30WkyvmswkCF4GrkQWeORbIIehLviqDe/CjKoF4jQ2obN4lsTJtGHJBtw7lalMOMy+7tXkGmKKdGK6SSnKtOo+mWPNjz2ZRKzH6Jb4FlddFp56VMlDbudO7t+2ON4/Cw7gc5M05r9daACBWd1iXcEZvu5nZ2cWnYkKwzR4Y5+zDXoZuNhvZ2vzxmkvznZKyRPnqvRUfeayh6lz8Hk1QiO6LcZzkC5XejjbiiaVJ6w3Qmx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 11:22 PM, David Hildenbrand (Arm) wrote:
> On 9/7/26 15:56, Zenghui Yu wrote:
> > From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> >
> > On arm64 with 64K base pages, the huge page size is 512 MiB, and
> > hpage_unit_tests() builds a 5 GiB range (10 * 512 MiB) for its tests.  This
> > exceeds the range of the int size parameters of gethugepage(),
> > wp_addr_range() and pagemap_ioctl().  The implicit truncation to 1 GiB
> > makes gethugepage() allocate a too small buffer, while the callers keep
> > operating on the original 5 GiB range, resulting in spurious failures or
> > SIGSEGV.
> >
> > Change those size parameters to size_t.
> >
> > Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
> > Assisted-by: GLM-5.3 OpenCode
> > Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> > ---
> 
> Looking at pagemap_ioctl.c ... I think most functions should actually be "static".

Yup.

> Using size_t is ok. But then we should also change "unsigned long long mem_size"
> to size_t, no?
> 
> Also, in wp_free() we are suddenly using "long size". In pagemap_ioc() we're
> also still using "int len".
> 
> Can we consistently use one type please?

Yes we can.  This patch adopts a minimal fix for this specific issue.  I'll
unify all size-related parameters and variables to size_t in v2.

Thanks,
Zenghui

