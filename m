Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0BAEDEBF7
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 21:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F253A6B0088; Tue,  3 Mar 2026 16:54:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2CD6B0089; Tue,  3 Mar 2026 16:54:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDEFE6B008A; Tue,  3 Mar 2026 16:54:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C92E56B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:54:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C569140335
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:54:45 +0000 (UTC)
X-FDA: 84506106930.26.DBAB317
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A5DAF40012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:54:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jfH8lLbD;
	spf=pass (imf11.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772574883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HeGJpo0ChYRBaYU97eJp3XQkiGSyyR4Op2Q5IeJ8AkQ=;
	b=VwX1htRgY6u9T+DtqN/6431nCK4OyC7FbT9tIwDl7N0qApHqgCF0/Hhfs2OwvTywcnu8SA
	u5bbaHg/Q2w3fAwM7jY0tUR9pMF1r8pwyyrZtG3gu0BChJjiEd0XiM5wcrLYqcv0onYZTV
	iWhinMRNe84OBMjKDR8QWJx8c6PDtXE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jfH8lLbD;
	spf=pass (imf11.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772574883; a=rsa-sha256;
	cv=none;
	b=EheAtCLnq9MtaC7fit/6sJjnw2+6l1jjGINqCx1GsFowcCPnD4+FP6ZKAFfXygFPmMoC4q
	Efepn3kuZ7f2fOcxS4ZrgeaweS2LCcob4iryyxT1RbJDMNvbdRMgvgtUAYXhv8LrPiUrEB
	mPGMWEyY2HE5krrQkiXHBSxzGdZD6Vo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75A8644195;
	Tue,  3 Mar 2026 21:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3405AC19425;
	Tue,  3 Mar 2026 21:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772574882;
	bh=VvOOzNE9BueqqRI/K17eO29FNoYNhF1HowEkUUOpvgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jfH8lLbD1Qlc/I69ExYqvE48A1/rFZBINF8w4o4XIG6p6iRD6dIr+7VDpOAC+3HIc
	 S0YKGBNBalL7PjWcjWR5ZDIUWuyEUbRk7nAySAiW1QymhuU052IRRoE9SczrI41vCW
	 +5WIoUT/3n+8UVg8xK7o1TfKTT5PE7NZXC6KMET5zx1Ohv+a9kHuYsNK/iiJk0C8zb
	 Bv+9vmpjODPgsPvIq6BQg44CMRQmeVjjxk4WtVSv/EdlAzAUonykX+K8VLuOHpyLcz
	 06U4gtFKKK5ySUFHnwl9SNkUTGeLdIyhC5oh+P5cXequMv1rkd+HxGO7P7XHmfmdSA
	 pJWSS9oxs3Fpw==
Date: Tue, 3 Mar 2026 11:54:41 -1000
From: Tejun Heo <tj@kernel.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
Message-ID: <aadYoaA_JYduCx_S@slm.duckdns.org>
References: <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
 <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
 <aadKDCKGHk1Ua-7_@slm.duckdns.org>
 <3303d57a4ea6776dbc66ca72441023f76e6f1234.camel@sipsolutions.net>
 <35a7ebcf-862f-0b3a-a245-c32196a58692@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35a7ebcf-862f-0b3a-a245-c32196a58692@candelatech.com>
X-Rspamd-Queue-Id: A5DAF40012
X-Rspamd-Server: rspam07
X-Stat-Signature: c41defbj6fydb8yuxexz87tddohf8smt
X-Rspam-User: 
X-HE-Tag: 1772574883-822756
X-HE-Meta: U2FsdGVkX19GsH1sUkhgBU0FBmNMYNAiHnLROUxSOJ9Ko+Cxa7x+1IHCImYnWgu3zmw95/azDmr+cGdT75jKZZyiU/9QLU01rkHDUkgAqjqAvbI/TsDSXmyLhnSngtRCbWh7LACfiDSkAYLyQInCcL2RIhr0Eg8MaIgZnMI2FT2DASbonl00kjbjz8zBMiDW8pSEFgnnZMb440Up6+bE1YOHOr6bPcqMRq+qzSWSXxBixMmfPk/FGtKv6A0dfQUOzGQmyM38POXw1woYvGCRKXiNEwcy9eHQpWio85yd/hvHVzYsKJkJT/EPau9LG4goVg8dED+07glVsr74RdZ3h6PKSCob20kyE0r4OaIQXakUMHJGKMOhiQd7uiVJV0gEjU/A0TQzALBc4iPdp3gsqrmAniS1spCFvXEHqka7U+4u8NQVNSKwrx//vaWVRmbpJhuO/DUYeUd+UlfnoIcfxLcRVeJ/A21GMMrvyE8Ma8uBXlPRaT7CTAhIgYBrtH4oGrDMzPfrI9lS6yncUFxjKRNj1JPPvUTMihnoN8SeYflFh8deIVQ7t7Z//yqdqgc0nB1/YEwjEG/Jv9DFz6aaqylFFJkY2sup2OCevr1rqWgT3Wco0o77Hf3zGFm5a/uONd+RDV2/4LHKPZoRlpUpTnNHzyA+8HCvpv4yYCdCfN8MMms8D4Sn/L9KE0oQhh054iXpEGXQ5KPvTUduilRdm8JqgvEgJu/mXcALi+BHbrqGSjBWzbyj77GzuZdBpiRbab2NAWO9KQcyVZwCOZDiOzahx8O1fWPzaHnYSM8lnCCGf29sWZCVwIfeRIKNz2PJujnaLh9r4fDILH/jKnFuN8chsluMx+kBxqB6WSPynWftLhL09Ggg3lvuyog0cBoRlMVAPexMeRAi34mnnLhwYo+/0n37aPlol9z/88pdc3yr8YQE1At07Cwquxv4fGdYr6SGOa93dhqA1XKOtz2
 TgZVSVXQ
 g6Mil2aqMv7atbU5v/V/Lvc4itoosIcyxTGj58KvzPwS27r9LSDAaFaHLyrL9saz5Foex2Xkk81UQaZ0C4iVQz0kyQu33PnnBmvXVmgGcFDkPeV7BBB4pEWsR7JYFvVdmw2bzZBwfzxL3WWF3rZq9uJXfxaqKkrOFi0BNYpWlv1cNMd3XyeHHDiJ6GlkcIt5k5K9AYMNb9VUp7yuEfDzBby7bgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Mar 03, 2026 at 01:40:54PM -0800, Ben Greear wrote:
> If I use a kthread to do the blocking reg_todo work, then the problem
> goes away, so it somehow does appear that the work flush logic down in swap.c
> is somehow being blocked by the reg_todo work item, not just the swap.c
> logic somehow blocking against itself.
> 
> My kthread hack left the reg_todo work item logic in place, but instead of
> the work item doing any blocking work, it instead just wakes the kthread
> I added and has that kthread do the work under mutex.
> 
> The second regulatory related work item in net/wireless/ causes the same
> lockup, though it was harder to reproduce.  Putting that work in the kthread
> also seems to have fixed it.
> 
> I could only ever reproduce this with KASAN (and lockdep and other debugging options
> enabled), my guess is that this is because then the system runs slower and/or there
> is more memory pressure.
> 
> I should still be able to reproduce this if I switch to upstream kernel, so
> if there is any debugging code you'd like me to execute, I will attempt to
> do so.

I think the main thing is findin out what state the work item is in. Is it
pending, running, or finished? You can enable wq tracepoints to figure that
out or if you can take a crashdump when it's stalled, nowadays it's really
easy to tell the state w/ something like claude code and drgn. Just tell
claude to use drgn to look at the crashdump and ask it to locate the work
item and what it's doing. It works surprisingly well.

Thanks.

-- 
tejun

