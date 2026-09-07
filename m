Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0864BC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08F746B009D; Mon,  7 Sep 2026 07:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040BD6B009F; Mon,  7 Sep 2026 07:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E704D6B00A0; Mon,  7 Sep 2026 07:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD4C56B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:47:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 562A2140126
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:47:34 +0000 (UTC)
X-FDA: 85186791228.03.20CA7ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9E74540008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:47:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K4HQVbNI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788781652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAfJw8rlDGFV693RqXxEhHyrkGOz+/nxPst/tGc5IDk=;
	b=BkvK/FNOv4rveHXIKdJGsw/MKHIxzx71ZhXCE0f3oU5hzp3IQnCcGNQhTJMK6TqQVIDDjJ
	v8+gRaGN1hMmmRaW9H4UzbCREWiNWoAVraHGg91jTyPs7Q3lwp+jKHkb1kiaqRoC+1CbkV
	YD4RMrZLZr0/C/A8Oca3BIVuVABcuP8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K4HQVbNI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788781652;
	b=NTZa/4O7pozqW7axLNxK6riPTJFLur76/j0hJTZP4+GCsuWkBNp4dF8sRGymMXMyW9Eq1P
	MwktuMYG4PDzg50ABEwBaiwSXyqMqHnNjw8fOAcPM19wx+71SBDvvx5tEkXTA1HLAu3qgB
	1wZp6z6do3DKZFfyxMCVRXpAzfehUMM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C620660D8B;
	Mon,  7 Sep 2026 11:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7211F00A3E;
	Mon,  7 Sep 2026 11:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788781651;
	bh=WAfJw8rlDGFV693RqXxEhHyrkGOz+/nxPst/tGc5IDk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K4HQVbNITmdLrWTPYstHL1ppZVvLW1xIAtP6plAGta2iU2+YP6b/NBRC6KAIM+qS0
	 1vlGfi9fcFBF17GKoZqPUwSJLJ5hM34ur4aAbNOioSf192So8R0wImQw/R7AJGAF2N
	 pCeWs5g5b+91bAuq6A1mDAsZ8QrEw+bO9zTQXiUaiZT4JUuSQxddyaDkHemDT3m2bd
	 TPugwJ4XwSllwkNP1Kd7OyW7ulhTeQ78Ru49cszmGks+RPTYKj+/rL2cADtDVgFGLc
	 8M13V3Qghn2BHWhQxBBX/7qsIqlUJZh7GwhgHCbLf2hwHsayxStONew1cyQlxXRnHk
	 ZB7BUnoi0v7QQ==
Message-ID: <519ef70a-679c-455f-ba5f-3841730873a4@kernel.org>
Date: Mon, 7 Sep 2026 13:47:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] selftests/mm: Exit on invalid command-line options
To: Tianyi Chen <hi@tychen.cc>, Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joel Savitz <jsavitz@redhat.com>
References: <ZTYJZT7Q8UU4.KPP9BUAAJVQO1@mailcore-89d674988-v7w7p>
 <20260906135444.749144-1-hi@tychen.cc>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260906135444.749144-1-hi@tychen.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qsrhcijtpe7km5xi6nkcp49exbfgdcpw
X-Rspamd-Queue-Id: 9E74540008
X-HE-Tag: 1788781652-559362
X-HE-Meta: U2FsdGVkX18gJbmW01jvUOLPonSHXZr9I4GZdUZPx1/GWnQLrk9VrWI0XqANcTJRE7gXllhKtvWh4nAy8LJSiFen5AX3Rg1EI6VrT+GuKyAnK9JpYwoql9j6dMoUbFd6KUZWqfTkqu4r5n5AkWtcRxy01hmVLjVNSpZN+8iL2Nhc4cR+gFHaLVsggXt7Mrr1dkXoBT3Zx1BDyFInLjiVM55N3K3f8WS8NzODG6wgcP3j+jfo4ZYBCBsc0lua0dmceqqS1ZzTvbwFhH1c8R39bNrN4qJwWcXlbgcK6GF2hVpFClN4FtgnsgkjrIvJ4hg7o8KcMzRrMFKaX551Y3wElzXWMTmM6bfSbPc7BOhI6HZT/ff1u4WZcvlvA0TeOTtgXcSTaMja2Hdy3DXu9B6jMMXUknGxpvcF433pvdzE6PX/Bjd+zPDmtsGarzfPwBn0gx59P6eTw+MkWrzdQ8Y/wrRIGoNgpFQMFD36MJzzTzrGRquPWxcyoo6YGtwfW2VZq7idJNTfwyyvHL21a5bUDXgdDe2N5bO0iC2OTx/0lfBnP7ssQFOhegjn9dclB7sykv5RTS+7aCXO5K5V8vDtdMlqQ1u2y6th4s1ZX/COB030s95c0o/d5o9Gzgr6VD9DYcO50wcajgyqZciNkVwzeuoUCcBAL7fNmPjEwmhMmjs+B37la22Imc6Fg/g0/bIFm4gd/RsGZCe3kMDReZ90/+qaIteBI+kuGXRk8Bqz8MYH7O4/M8iCakBMPyacwtso/A32SgCrpgMO6rIW2cdmXUJcaU9pBEHreEq+bkNNd4d1CaNuZSkOvOqE0cuN2lbZCnRGNSveo1xoq2WHZ7I65lRQCzail/zfTjIsm/wvUnPUI4LDNWy7cM6DvEiYIcFoLxmxJrjqZg+YcPeZS3uHsxFwlFVvkuWdf5m9VcCqunilver+xNXOzLWLt60vop/7zc/79cflBGfZb7FHFKy
 yjGHaQle
 d0djkpKGvbBVmeE6GgWve2vLVoGc9TYeQsMEhKyCSXAxyoAEl0C+Uot2hZcdBoZnEvDiwS13dvKVXiniSfPXIczg239lrUtBz2T7ng5i2Jm7ezT6N+UIS/T9pql6KzXu9l73NzLE7CSbV3NZMaEE1Qg2zmWBY1tig3vReQPgBvTnuftBfE16y1e82au7yEdP39htxKxv5MeQappu23PuQfuEFQ2J85UQB/CJk5y2G/JuAqnSTa5tORzg3QGutfSEWNuGT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/6/26 15:54, Tianyi Chen wrote:
> getopts reports unknown options and missing option arguments, but
> run_vmtests.sh ignores its error result and continues running tests.
> For example, passing -z or omitting the argument to -t can run the
> default test selection instead of rejecting the command.
> 
> Exit with failure when getopts reports an error, before any tests or
> their setup run. Keep the diagnostic provided by getopts.
> 
> Verified that -z, -t and -t mmap -z exit with status 1, while -h still
> exits with status 0. The mmap category's three test programs pass in
> a VM running the kernel built from the same source tree.

I wonder whether we also bail out on wrong/missing categories?

It's also interesting that we do the /proc/sys/kernel/yama/ptrace_scope stuff
even when not actually running the memfd_secret test.

-- 
Cheers,

David

