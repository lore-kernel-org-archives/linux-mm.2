Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9099CA5FB7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A366B046A; Tue, 20 Jan 2026 12:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041C76B046C; Tue, 20 Jan 2026 12:22:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBBC66B046D; Tue, 20 Jan 2026 12:22:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8C1B6B046A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:22:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98001D27C5
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:22:56 +0000 (UTC)
X-FDA: 84353012352.20.F68F549
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id ED645160005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:22:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s8lvO7fL;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768929775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kas0VoJnRsqLNgBbkeyIhFKQ3DwfYC5LPkjaeDCIUbk=;
	b=LnU87OvmrhIX2HhGBU0kc5tmoCjTs3LKDVddcsd3O1ozhxOyk/VVZ5jmioqwKB3w4gveV4
	SQl2GEb0BTPKj7boXTSLqa6rvHuZ+KkrU7EjQ0VFNq5w5VrdwTugKGPo6VNbCq0QyWFeji
	7/BDRMO1IQyi3AavjruxTCmF/h+Yfs8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s8lvO7fL;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768929775; a=rsa-sha256;
	cv=none;
	b=Zb7RnlW8vE0XhkOzBpzV1REf6uyWkqkA0bS93c4VDCO70kOQEDM2zXpAy6kfWXVUKdGJrj
	+q59VsDkU4KkNnn8kvRDlaE0JcDTD4mRuhe7w6rEstNrYptkP4u5c3ZNZ5YF6kfbbRI2H9
	tjkG3KNt3XI2lVFQooPp/IkhhxdC3l4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FE2960010;
	Tue, 20 Jan 2026 17:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E111C16AAE;
	Tue, 20 Jan 2026 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768929773;
	bh=+PpQhlnYOghCS9FQdpea1dqa5DXErdHY+bL/BwEjMXw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=s8lvO7fLdDgmuSM7nWDJ+1STjiJK4yz0QTXDWDsnC60f57BOxkn1aV8PUyyd5tGJv
	 CpAdZzrrFM1+UaaGDgyfYAsCdjuC6mXplHGhDQyBJpXj/zJLdQSmuTBoh6XNq+clD7
	 itFs77aewVdoUUl2AggxsHzWejrcHv5vSI5/BXM0=
Date: Tue, 20 Jan 2026 09:22:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Have the harness run each test category
 separately
Message-Id: <20260120092252.8597a496ed1cdebe5e120fb6@linux-foundation.org>
In-Reply-To: <20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org>
References: <20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: b1fdn119hr5ityqqsyyyqq991q93a76p
X-Rspamd-Queue-Id: ED645160005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768929774-316832
X-HE-Meta: U2FsdGVkX18Yg7pp9sJvSk1pobdvd6qIXi/n6xGC28JkNdSHB/rOESJOEYde47H4GylWfp0sqPySZ4iqhqcDl0UV9lctf2FeG0iVJxTNyx+0bga/vL5SlFWVbWE4DBUk76knuoWwNAeP04WHa4BxNMETFbdkxGIyNo8qM13CufRhtCpM4DROf+1qxVg+A/hyk8HdHQajQbweOvMfseVnrXrv4PK/VtPU5N7EHrgUMHVhbCNVo5XKkU2Q8OeWmwkjuLciLoKwES3wch7roISX48b2GTMIrLBVW4CEO8/3waLN/VhoDVOYJVwvZ/VwCwXhDD+/LbYDwtrIwhxTGBbOJYZMhEORLxEPAIPLn/C1yp/Ni9iCRBfH887guwyOUkd3wTg0bhEcsOhifX3YR1YDS9qnfeu4CmD9yJ2YZwyyKqSwuvSONYKyjkKDKj2eix9TXbS2KRppcuD2QripKPR6HVeG7Cv977M2rksnNsM7Ed4iJdhJ5VOtoRCt2RBkVjwAT5GJZYuMerVadTomEcyyYZPLOIa09MXIMbLOqRPkxVcMOZ7CdAZl9yRSXAAA8Cyu233BZXT6nZ2kopv22FUvfNFmaRADBeng4h6ETetVLhscjl4zZlYbkDph5CzhV9XoXUTNy1vsjVbUZ7Oq5UfsaaER2YrvOyNjkPodVKO6YujTzT0VTdy6hOHLdSqAhGdT3j7hS3eN7kSzVzPcQ3eYPb0faUkB4xkvL8h2Cuq1qM0A4nGuGVHnKb3kk7XIFgzcnUykQWgqNqYth8jLD3q7HK9rOp+VZaYb84pFkZvveDyqnhzPn/YOZqgeVn6oSA9LdLoRFdeB6OHxyRX8LbkW9Y8juv3ESI3Qu55tNzYqL+EKP1uhFqv3BpKuMYgLwNeMGePWotFJQYxj6bORwcDnJdSKAFU8Yxg9ZbcTJw8bJQDLKifX9BHqT2KReCG0A791AhOMVZoB51hS+huPspI
 ELpGfd2C
 zywazm7oyQoo3jq9OUbNmBAZIf+It/Sw4KrHuz/3iWAu2xMW5tMNos2FXgKsPt1G0NZ8Hbv28dWcvEXPxY3P4HQ/UMT/vuhIrBHhLsSAp3cs1bJC6nciCLpOTMZzii6AL+vCuNaB9CL/WnR/X4Mb1eGAlm6tEs/UGKfeHHFZYsDtINHZqOUEcnHZ4kJQOEz0a3H0JK1yHpBX0SCpF7YlMVFMQbzpevzHITDEnONZff2Mo4Z5BOYjYqsBfFoTjWDk9ArW5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 13:25:32 +0000 Mark Brown <broonie@kernel.org> wrote:

> At present the mm selftests are integrated into the kselftest harness by
> having it run run_vmtest.sh and letting it pick it's default set of
> tests to invoke, rather than by telling the kselftest framework about
> each test program individually as is more standard.   This has some
> unfortunate interactions with the kselftest harness:
> 
>  - If any of the tests hangs the harness will kill the entire mm
>    selftests run rather than just the individual test, meaning no
>    further tests get run.
>  - The timeout applied by the harness is applied to the whole run rather
>    than an individual test which frequently leads to the suite not being
>    completed in production testing.
> 
> Deploy a crude but effective mitigation for these issues by telling the
> kselftest framework to run each of the test categories that run_vmtests.sh
> has separately.  Since kselftest really wants to run test programs this
> is done by providing a trivial wrapper script for each categorty that
> invokes run_vmtest.sh, this is not a thing of great elegence but it is
> clear and simple.  Since run_vmtests.sh is doing runtime support
> detection, scenario enumeration and setup for many of the tests we can't
> consistently tell the framework about the individual test programs.
> 
> This has the side effect of reordering the tests, hopefully the testing
> is not overly sensitive to this.

Thanks, let's see what people think.

What happens with tests which are newly added but which don't integrate
into this new framework?  eg,
https://lkml.kernel.org/r/20260120123239.909882-2-linmiaohe@huawei.com


