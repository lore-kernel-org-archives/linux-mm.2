Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F78C79FB3
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 18:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BCA66B008A; Mon,  5 Jan 2026 13:13:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108486B0092; Mon,  5 Jan 2026 13:13:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0031E6B0093; Mon,  5 Jan 2026 13:13:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E035A6B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 13:13:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7E2752501
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:13:23 +0000 (UTC)
X-FDA: 84298707486.17.78FAF7A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id D3B4940011
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:13:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767636802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eFhTg5REYdb2ZH1l5YtruUEOCophGL+u4l6PsjEGscw=;
	b=f8aZbafRoPt2UaEBFy84Bm6NTkz53wZXJmFKLqGxXWtY6N0snKXAWEsgLot6q1FHOgHzB2
	+zn0E9UJzDe80KF1dEapuRO5SnBAzPygpRKtIs4ycilNTQ3A0CM6zYYjIrt+NnA/+8Z/ZA
	7a3Yz3HmBTdtAZS99RjZdGAVT+bn8Sk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767636802; a=rsa-sha256;
	cv=none;
	b=MXNMtPZBHWscdmuWKrN1BAu0vmsvrRRPe/ZVzaWIKeV+1wl1Sa4dYwJZjyw/674+J0jeTi
	V4RNSoTUUtvSd1tv8AP54sWqXWT77iz7arpgco1gy2XojYnklvb4Vy4vMKIXDrlQjy5wwU
	Ex/x4BByXyKucpe+HfQKFQRkWXTJqCE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFB8A339;
	Mon,  5 Jan 2026 10:13:13 -0800 (PST)
Received: from [10.57.47.111] (unknown [10.57.47.111])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D61093F6A8;
	Mon,  5 Jan 2026 10:13:18 -0800 (PST)
Message-ID: <4ad1bc4e-b1dc-46a3-845b-e648e4304ad4@arm.com>
Date: Mon, 5 Jan 2026 19:13:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] selftests/mm: remove flaky header check
To: Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Yunsheng Lin <linyunsheng@huawei.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-2-kevin.brodsky@arm.com>
 <5f866c1a-c8cd-4dc6-b312-9017cef89920@sirena.org.uk>
 <e971e44e-5539-4fc4-8128-0ce9c3d10a38@arm.com>
 <682f64d0-353c-47bb-808b-eacc2d4d6c00@sirena.org.uk>
 <9c97ac9c-b0df-42e7-84fc-7e0d986c7324@arm.com>
 <2bc4e09a-045a-4d33-8857-1bdfe3281da2@sirena.org.uk>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <2bc4e09a-045a-4d33-8857-1bdfe3281da2@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 73dh5m9z5xg6wkxrgoczrp5mnzgatjxd
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3B4940011
X-Rspam-User: 
X-HE-Tag: 1767636801-461806
X-HE-Meta: U2FsdGVkX18Ww9YiuHxpbFpposASdAVKw0qWNZdV0zXiopVHjM5LJ+UaptCCXclKwKBQQjByzAFrCqpGdv8EoBFq3Q2BROlVgkuLTpCFYu90oLQehGdN7ebOfR8Y72IAQuAKyl/h24lPUu0L0VDPKBbzaScKcQE1i4ogAm5qHlh8mP4EJi1qGLGwzIW6nBE7zPMZCnnO2GuBl/RBARC6JFjmkFozVwVXKQbY7KmhtibbB7gtie0Q2mM76qYnw3WMkokk4SEQ1wmS6JB2OC6dLojP6e7PzCsdDQrRYGefKfNxFu10aBw1y1JWRKeO61qKnsRqcH+vAQwNc4cEfnCg4MxDJEtvP3vZ8Mvd0TYkyaiiiLIHJ22oe4CLzp7EIYsDmQGh4vQlbXCLH4TgNod/XwHgCbS6I5WXkJYPNHYETF3zKGtgVXvW2YYMQIELvE0lZwDYO3jC7FI3jpXduAXc28JWhZh/ot7hFWJrc09+Zw6xzYAuUSS2ANNE8l+0H8Uj+mFv++lcpQJ/5OVGPMPSXqbXbnl5zVU+C+j3JHjPgIHIFFj2zUCRdXRIA+r4HaExPXlPLE/F5/YNHz1XfsLb0d8hjeapbow8l6t7IYGcdp+xr7gzrPkc54RBOaA7w9A9L4N67xT+CKMXg/N84XgYos0FhHCDI4p+sn9uqwHSpsPtLYFY4RYmaW7TzGTAt5t7zhyK10ieKSZww351KqBD2wL7/guTREgbr5QOzNEtlZII3XJSkR+QTxu9P4TF4/1N5CO3VAxRM54GcstlJOEK2zU5LoOqdStXlFCUOl0jecK7j3vrrvhWtw/FHCIIHme5DAk2CZkrUKAjQvm7YgCo9t0rhXS8m/XeL5cfStZijknRXfELnTSIqx6if1TsPPfSeYiGLs4+eV2sTmxJT4nNBLKB1a1fVpF5RZ2/tpCeqYa9gO2zI9cHPZaw1gfv45igahuvizDpRcCSs9ZGVnU
 iC4X1Ufd
 CRQJSBMn09KMkk+Buo1WOXX0uKEuar9ENb5WpWGFK+YnoonjajMBGnsKE5gROB92/CF+jdTGXgxgjNSZMx+B+KGl1KotV0idCHMh7yn8960J46LFCoPiXBOnMfQdx5gP68I285l7wNAX3mg4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/01/2026 13:46, Mark Brown wrote:
> On Mon, Dec 29, 2025 at 04:40:26PM +0100, Kevin Brodsky wrote:
>> On 18/12/2025 15:25, Mark Brown wrote:
>>> Well, there's also the selection of KDIR which for some reason defaults
>>> to the installed kernel so we get:
>> Overall the kselftests tend to assume that we're building on the same
>> machine we'll run them, so at least that feels consistent. The same
>> default is used for most other out-of-tree kselftests modules
>> (livepatch, net/bench).
> That's really not the expected usage pattern, I'd be surprised if a
> non-trivial propoprtion of kselftest builds were intended to be run on
> the system they're built on - a lot of people test interactively in VMs,
> or on some other target hardware, and automated systems are going to be
> building separately.  The two you've identified look like special
> snowflakes TBH (livepatch in particular has a bunch of other issues due
> to what it's trying to do).
>
>> Maybe the documentation should be updated to recommend setting KDIR
>> explicitly? Or maybe it could default to KDIR=$PWD or $(abspath
>> $(KBUILD_OUTPUT)) when cross-compiling?
> I think defaulting to something related to the current kernel build is
> more sensible here.

Fair enough, fine by me. Then I'll change the default to the output
directory and remove the header check.

- Kevin

