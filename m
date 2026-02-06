Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04784EE2085
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 454EB6B0092; Fri,  6 Feb 2026 05:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4033E6B0093; Fri,  6 Feb 2026 05:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305746B0096; Fri,  6 Feb 2026 05:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2171C6B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:47:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81B535A606
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:47:28 +0000 (UTC)
X-FDA: 84413705376.04.5DB151A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id BD7D8C000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:47:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LsKO82kj;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770374846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeA2fPs+K/YI87IFem1uMAThA/X9sGtEi+1lh/fMTzU=;
	b=hTmNuCzAa4mViRrZWyeafYbGVwrr0b7CdUSkggbdcwYjyVzxGTUX/puUMwu0xH3MxjZeYy
	OdOi4JlzfMB4vgWdr/5kTXFJnOq9AuKwEOKMLK31Qqa7OXypAwGSYfj3V350ZytpSoTGZW
	2ReVIdBM9dClQ5N2xw4aC6HIK4MMhKE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LsKO82kj;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770374846; a=rsa-sha256;
	cv=none;
	b=yp9EUIRy7RxYAJH78epn3n2CtVJjwmpylQrIP9a+bsgsHLpdlW0fjq72iLb3VkefWIHHlL
	Ukzbe/oZ5u3TBMSVCIZWsbJGoLUIXKRam5X++qT3SeejuPU8IOlbONyy5Cyu0UD/3j181x
	AieLevY2Je+6xfW0lyvVrkVTh2aU/J0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3671A6001A;
	Fri,  6 Feb 2026 10:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBA4C116C6;
	Fri,  6 Feb 2026 10:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770374845;
	bh=5i7dp1xUCJOG9hy7V+b1PdlJOS7RsJ7dHlcYAV5h2YQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LsKO82kj6PRszI0+zZeQc8tluJxIE69Cj4vGHdqA1NlH0u10MOVEs22ixEWvmimIC
	 awoKQatoPIWQL62cf8xL7ZSF6YFMdTuycox+je4rHTSrjgWQL8CWbmsT5UbUHFsicm
	 XLph+PdHZbweJ6qmmfw5AN0yHd9m4e+AI1wBpRRNeaROBGdkqrTacsljEV5Fauz762
	 Vz123gFOVcmVVxRP3S3uafACvi4/Fprxx++TYBInXU06Sq17MxkuP+Gjh7fighEao9
	 NDGMSSHGEGHWiLaZLNrhzNoxW6zaY4DbkVYf9lzbRmVI9jEMNkS80x3HWbMQf3lhYq
	 PNQi6VMYBoyKw==
Message-ID: <a97d16c0-b31e-4f7a-9fa4-171ac80b33a8@kernel.org>
Date: Fri, 6 Feb 2026 11:47:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] KSM: Optimizations for rmap_walk_ksm
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 yang.yang29@zte.com.cn, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260206175609696_A7uH3a1F7VmQN-iTzjC3@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260206175609696_A7uH3a1F7VmQN-iTzjC3@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BD7D8C000D
X-Stat-Signature: 9syyewfr5xktkojthk6s9pkrxr7f618r
X-Rspam-User: 
X-HE-Tag: 1770374846-909143
X-HE-Meta: U2FsdGVkX1/06WoQYN5/LA1e27hCnBpRv7fYVmDKFpPe8pEvfSV80/ekxxUzbpKHLjCpjMpoBFkPLZJbv7Pto8ltKnCE0gu2FZOinKEG8Ap8tAa3uYRxxUm2zR9rQ6LB7j6n759a3Uv9/h4f1J2iPAFmy0w8KufcGoYtQ7zU/NSnyVtDMMHfdv+L7SY+nBs7XQlzzccZ5OATbGzr2bxHyK3xQY/QxV5CRsjpoz7TIUc2nofIvaA7ARJkSz7p6bFapa49uJR80riU743JLYFMdmOvcVlwo4wjG7ZQMGgZa0TWKcZKdIl5vvcb2yJWcNjtjK9pD0PHy2DTxHUNwqWKTcFQADZELz9SfsDNAHsL7Nplvb6A6JL4jc56EH4FUymkS5CD+MOyuQXd+hxcl950CjHvtQZKpjZr8ZoZxvKdv5y78QpH5SSXQE/i/j+1oTabpd5JdR2eOyU1lTazHFI0vW8grFfM1Oz3r4y3Oskd7c4VdQQTN0pz4oxioAyXQxsu7TuoRfAGGbC//s9Q6S5rhaDN3WNt4x+cKM/P5oRzC16U+C3q7O65eGMOaLsSYZ0beqxYGZevmXl/GexpMOkPnrmepJANrkKd8Oop8u8OqEoqqTnUOsEhe6KpJKG/kRreZUBacbRu9kxqGmtffy/+ru4Edg/3gpHw/LNIS1AxSPKPw8+Oj7eFjCx9dyIa5t44NfgWwsTQzcaRwGc2StjSn8HCrqX5GIqd/ydYPWwnnE9viXIf5MS8YX5REESu9CSpL0JRYP0iUyTNnBwYdwWEBf3VHRcGBZ5nnX4NVSShcWtqWfMsZNejoyXvGgFV9oqB65xpmt8Jj0GBS1HUz6DPaPGF6E5xnE/UE2nvZqU80Jhvl24k6OH1ke9mLcjLhK5XO5tNdFNAXeO88MNGGBpabULQfB6XvHTiC+Wso3pLHZqZusa5JOp4wjSdwlbrZEx0zCqmrAYNjtNcwhU+Q8S
 NxvzAtju
 VXYj2EuFIhXRMGJDEPdISFAV+avewTTHJfdjYsay8DEZ+7IQHGctsonq47NpxH+ZJsjJYbuU/XraCnX5nFOJl727NhQqU6aMxUBokMdlhfR0Am2wV+iGwsKc7XXbgDj6GE2Aw5SlaxjABWCFqMG0P11yHCxBUs+3qRC67WYT6lZtd44RVjU5SaPware7NhAOvPiefZLpYCUws9RKl25LUiy8DypAcKZfALbwfKtTpvN7uxj4Nfir+4uaWobA3uRQFiXXGFVhCc0zLaQiHhJ4ZM4wkxtcfnfxYuvrMl0kyD8c6y8AGxBUEryGQ8LoQSATY1lXGbk5QGvtgIV46cz+mLWKuK6E4E+8IjLUV6Ka933IGDiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 10:56, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> There are two perfomance optimization patches for rmap_walk_ksm.
> 
> The patch [1/2] move the initializaion of addr from the position inside loop
> to the position before the loop, since the variable will not change in the
> loop.
> 
> The patch [2/2] optimize rmap_walk_ksm by passing a suitable page offset range
> to the anon_vma_interval_tree_foreach loop to reduce ineffective checks.
> 
> The metric performance is seen at patch[2/2].

For the future, we usually describe what changed between versions 
briefly in the cover letter. Thanks!

-- 
Cheers,

David

