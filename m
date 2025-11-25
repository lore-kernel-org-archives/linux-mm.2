Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5925FCFD315
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 08:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95BD16B0023; Tue, 25 Nov 2025 03:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90AB36B0028; Tue, 25 Nov 2025 03:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA6F6B002A; Tue, 25 Nov 2025 03:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE456B0023
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:19:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3FDA583BE
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:18:59 +0000 (UTC)
X-FDA: 84148428798.20.FB9DCDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3E76740003
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:18:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mvA/Z70K";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764058738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7PKn4ijSlEHXa5IeyWTO95RwBoiooXbzkWeUii8sJJs=;
	b=FevldB+ORRkWhRR9jK/2OAYl2AME65yGjmdXN2UVV+U8IULfRwu2MYr61pZGCp31PlY+Cm
	wDMT85/WUyYUb9GkusnQQRtK28SXQOOWIUKMtZTCcS2qzWEl2ColVNmTbeN58FeYqqt39a
	98e1HjO8vGDaA+QidFHLDx0hH889x2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764058738; a=rsa-sha256;
	cv=none;
	b=njal14a/4PjYA8q5XKFEOI8HTL9YKPxqJvVdkoZQEcsEIAFd1fj6gyoxgkOIdgHpdPP8Ay
	KW7ZHM9b0/DeeYPHQvM6xfH5TKowe4Ft+19PZgShlTkr7noXz0/dmlbXUktuffjXCtsVuL
	sn/nXSQ8l95f/EQEPQqSXyQmU8V63cI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mvA/Z70K";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 407EF40475;
	Tue, 25 Nov 2025 08:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5846C4CEF1;
	Tue, 25 Nov 2025 08:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764058737;
	bh=XYNAwhlrNrGWRmaAZUQEDrj1+kspEfhdgIAxGaDsVFY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=mvA/Z70Kt1JdWg9tYbtVJQb8zJvJarqaSsObCaxf4m0JRIspPMUDfKYu7NCdPEpx9
	 iyOfDRzvbJEKAgL7xxM4zsj0y14lm13bsZ59kI+BcdREuhoFluLhWIp6DPc2D31kJR
	 fBfm/uQBujTHBGNLkw1UIXLeXwdHCGujOEh1ZulPdwx+33yRZb9lCeQ59WieLDSxhG
	 g60YDYWSZ+LfxhNwAmHEwCe/P1m8n1ztq+pabXVRhpCNUOJlNo35VxGy3uHefeDKdF
	 ryWFY9TcwTmki9tWV2JHCo2CaNVUZ9t9YfsENzKAepQ82VC8W7WD/F+c7E8/Zo2qkW
	 B9mIHw6aWoQ8A==
Message-ID: <a33e119f-09b9-4cd9-a895-e3f95d659a35@kernel.org>
Date: Tue, 25 Nov 2025 09:18:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Ilias Stamatis <ilstam@amazon.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, nadav.amit@gmail.com, huang.ying.caritas@gmail.com,
 andriy.shevchenko@linux.intel.com, bhe@redhat.com, nh-open-source@amazon.com
References: <20251124165349.3377826-1-ilstam@amazon.com>
 <9fdc1d1f-ce00-47ff-bdf5-66e8a511be25@kernel.org>
Content-Language: en-US
In-Reply-To: <9fdc1d1f-ce00-47ff-bdf5-66e8a511be25@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E76740003
X-Stat-Signature: p19njunisudbsh1eee9qcwpw3j684t4e
X-HE-Tag: 1764058738-364897
X-HE-Meta: U2FsdGVkX1/2r0K1u5HnfM777dZbwS22CokqWPqVydMcpqIPCdvRIBX13dQqpMRi0RuVCBKO2joX5jOjI/BOXkWd9RFPibU3xnGHi7oifTliYs21vtQlrVtQf9E55jLDxPhNzAmDxLAqFEQlGuBO0PmStJ1QV0v6oYImpLtvt71GRBpQqTztCf+sJHBcQ+QfRb32GSfXAyDB20i+lCyYg+pEAi0vtRzxbl7QLPGzwHWpnuLtdvdNunYDVRwmufBQ1ZUBbRUbMJhIan7ODl5S2oiWKpTXjEJXdHOvz/fKC9gkwLFLNydAZfFs3GBg7CVVUII4GKwI0SYpQbQRrEQmRhqEcrRa6duG2uT7z53o/A8htwM7q2xcX3iabqU2d6VsWsJ/bkwxWz0Vvx/nTnDvp2jx2v76FXNKIqO4iQ2oQ2taPLqDgM7rS+NPXVZtn1V4fV/LHZCajd2r6cBD+4xF7NfK1p/3yyFLmP/ozCtWalxzJzoPZ75G5+vj6xA4tZLstcFgd3CFp1GseyYm3avaSbQYJ778Na1ZyFZ5k8OX3BJaQ4hNUD/7bUVGeS4VGaC9w4rEVDi5ufWxye/UuxIyVyw+SgQRRVJniofEMGrQPdlYSaTscZbAFxD23VHcCdXeC1dhPy/TVV8tUi6/d+AionoF+k6MRQXrO8Em9xmpWE9JDAWKmgigWbx+XfnNK7CuJrGVZcMqaP7cGHJYGB9HKQWQianNZhEPXUsSaFQlk20UGQq/90pqQVZ3a5Tn8bXWwJCjkSYwv/MsktBaeEoJ8hlNZjdlBSZ8lYrKMl6A6B39oUt9aR0w8eDKDGnRhMzkXbpBiCnXd76l8+wFQRzzaVkfRN39S8sep4EFJZRi9MADrdf4C94PTwjDL6im2uy2wEEUUQx46WsivH1dJlI3yuT7QLx8eXxUG9kesTkg+j95X90f2F0++sT1B/NWhh2k4EJFS811iHKCuyolhSI
 EZsOpW/h
 CMhihSI81xRJb6cH3KYe8mTw94wvbR609FSjwLSs8VVZnLEoKtU74apm9qM9ereycAPgCqeRIxnN/ihRCeC+7m6uoJFisuHqZKMjNSppqBU4NvAd2z+uQuCn3scIvMazoHbQp7Bc0g/Mnnc4EHux54O6zZbQLu1VY5koeakM3Ftl5jwJo4pmCU3ta+iChubveJdeYgv81++f8ze6c7kBur18lN2XYjt2+/2gJRL2KTzL93e+o1mEUFaIV/zbwWwc7IEK9AiL3GulHiqOJ/yJA8Iujda2DsDS+k0ptnPxDbwPANkAvRUXXWRXCSu66orbHvanaoYySaD+z46r7HTyDBv4JVDR22ItPkIizqi9ucD5TjTOiyyqjqMI7Wt4yX8lSnMdrBKdDuuK4JGDjxJx++e/ZFxUtxnRwWxGXfW3Sj4SDsBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 09:09, David Hildenbrand (Red Hat) wrote:
> On 11/24/25 17:53, Ilias Stamatis wrote:
>> Commit 97523a4edb7b ("kernel/resource: remove first_lvl / siblings_only
>> logic") removed an optimization introduced by commit 756398750e11
>> ("resource: avoid unnecessary lookups in find_next_iomem_res()"). That
>> was not called out in the message of the first commit explicitly so it's
>> not entirely clear whether removing the optimization happened
>> inadvertently or not.
> 
> Remembering the history, we have some things where the top might not
> fully describe what the lower levels do.
> 
> An example is for example found here:
> 
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Thu Feb 16 00:36:02 2023 -0800
> 
>       dax/kmem: Fix leak of memory-hotplug resources
>       
>       While experimenting with CXL region removal the following corruption of
>       /proc/iomem appeared.
>       
>       Before:
>       f010000000-f04fffffff : CXL Window 0
>         f010000000-f02fffffff : region4
>           f010000000-f02fffffff : dax4.0
>             f010000000-f02fffffff : System RAM (kmem)
> 
> The CXL Windows will certainly not match System RAM, as one example.
> 
> How would your change affect such cases?

Looking into the details, I assume, as we only check that the actual 
range matches, not the type, that this is fine.

So yeah, that makes sense to me. I guess I removed it as part of 
97523a4edb7b by accident, when I primarily wanted to remove the 
first_lvl parameter.

Given that the above still works as expected:

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

