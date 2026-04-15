Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90BBAF531FC
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98926B0096; Wed, 15 Apr 2026 05:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70066B0098; Wed, 15 Apr 2026 05:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C860C6B0099; Wed, 15 Apr 2026 05:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B855A6B0096
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:21:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 565DA140529
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:21:50 +0000 (UTC)
X-FDA: 84660247980.02.BD8CE51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 996F980002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:21:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kQSTaEVn;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776244908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiOBm4df7jdS2zDhULxqnn4yfI4Fv84Yv2TY/gcRebI=;
	b=X6awEr9q7uKw3/UHiwfpOwFuBWWfPmD477pe7GZzfc45Sy0FgTLCVY3K2KyUOr5XvNLIYK
	fn/XqJCSdJTyYBjJOzNzfd9QP8EU2DVoM3YJKrizWev7j9jsPkOp17iRHZv3Hqj9fR5TEs
	H/maidy6my7cXOPYtSnRcyOawHIPhTg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kQSTaEVn;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776244908; a=rsa-sha256;
	cv=none;
	b=uEErlbMnoETw0cd6VJ6AnnHLL5WPAT7lnl13Roe2ukEaVqhGSWhvq5nFq/mGgf6peO4k3K
	HXlmHqy0bgW4CYd+AfRNEz1pkgyTjL0HSqG1Bhv1mKda/apZ+YYaIr3Zk+8UGNquQuPKOu
	AhztGpgCpmMruTqiDCwvAbL6qnfX0x0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED9D5600AD;
	Wed, 15 Apr 2026 09:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C96BC19424;
	Wed, 15 Apr 2026 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776244907;
	bh=Nyd02k8wHSVHcskfbQ/e31pbVxKDuN7GUAqTezhSwxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kQSTaEVnmcNMEayJC4Cdj/51l1D+CotiU8oJhSCZ+n+XCW38zrM7FFjnFodrNTAo0
	 hoXYF0jODMNUIA5dGlfQrWI1w1Sb4EWPDWx+EiNqzha5OdImJSeXsRWy1PHze80tx1
	 ij14qPLStE8IcUj0K+1WYPLdnV6DQHiTBLuVsh/H/qRUHMFcVW4gZRZiDxyVGQCr+B
	 zNt0tqwNFsWFE23NVYbPp8mTWU2Jy0N/grW2QJ5Xm4Rtz5yVpPrzYRQ2EI+YO5ro4d
	 DroTFqaFWxiwoXl1CRfNxO86ExUf9CGrwI+9shWaafAXbSIjZ5fIl9/a2iZO2Ru5YC
	 kyaaVfKV2GD6Q==
Message-ID: <6339e1fe-bdd0-4ae1-bab8-5a2ead0e6a84@kernel.org>
Date: Wed, 15 Apr 2026 11:21:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: David Laight <david.laight.linux@gmail.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260415044509.579428-1-dev.jain@arm.com>
 <2e34b619-085f-4a9c-bb41-bc024fd40dd7@kernel.org>
 <57b5d0f9-3e56-4f96-9e3a-2f475a78a8eb@arm.com>
 <20260415101623.33004858@pumpkin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260415101623.33004858@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 996F980002
X-Stat-Signature: gbpiqm6gdnesiqoh5ff8iudmss8agane
X-Rspam-User: 
X-HE-Tag: 1776244908-765984
X-HE-Meta: U2FsdGVkX1+hKHYZfXwrmb+DQXcZ6RId2V4WjP27sJoaLA5CL9VTDNH1y/hEnynnlvHJiqJp1pkqCjqazRf5NwYinYAaQaAX3hY0jwV7lZnoVUcoF/hj1kvPIPrS4qm74ItcVuy+xcGth1bb40syS0KB+EO+dH65tP0LbhoCfA/xXxrB94wpvNm1fCRGnpv6lZZsRCGGPHEwc+sfrLZwB3AXgIVSQ5Jq0+LJFVjT8oERmAHJ6SZedd6JY5OKqnsGm3dRgngEKoeIgx6DpHFjnnQ/IaT69No3DlZGH/Sme3PGfUZ9Wfz1j2U06gw79ep9P3GPwNlROs0b4hr9eXYgNu2dbhup7z8rP9XFFfMzkpywVdunfKPLggIp8IgFEh0f/Rmq1l1Zd3oZEKGqhjZAUaPiFRq9iWNU14ZlRTiUMNnWvYvTovnOFi76qo+SbGCClimG0z3qz+I5vHkL5A+Ar6E1aii3e/dqNQEAZ0ABz8fpdJ4dt5U7UGXi/ThJ120Vu634GT6VsHEw6qIhTFW8TCFPZXP+L9sAA8rYTYQQudHPq7V0ObG8sYfzYUax7weoso9m9jKgziwqA53eahaz3lfpaEnbJULaVfQMlqeuRA+i3ZzeKI1e91v1uA+fprXC+kwPV8s5jg3XOyzNXzk6V2xiVsLbXI61gQrTHO1W/KeOaop4LDIqldesR2Jac7vgsRAC5KydTcuk9hyt2IW9OgpvdYSPPgx2VoTYKArMN0Bn9+ivhUHl+JfQn+5Hc1akv7/6gsfUuTsvouP/irjAKRvF45iuzYi5Ymzb+GwD5wK4KpG8UsZa1c7w0mPiPnugX5R1PWn+/MM2ik3K3s/Kl1ss9+GK60iqyuAoBo2Ns9wLMejoJm5PrfQfeQKVFqEyVCoNcWiSw9NoQCxlsr88skKWh7gGcFpeMtq2ilAvOSWEohi6Um+RUnAXpSNgTXCiR0+uARxHzwyeUa+PpB3
 FfW1sj10
 k9bJhwfOf9G8XAwz4nCQLDcUTr5EgsYejR0iTKPVsvHaOnNZ1zeVLuGwj3SDkEdbqypenoYhkvK95NKBQPokvPxgh/I53nmW3h4WuLHlGUqUBQoX9gpmoKiEg/UfW7uym7t697HwvoEQQsCIJvoMSSCQihCuVOwBrhK7A4ruM0N9GAHLuiIzx1yZpGfrPL/vMgUFR+L9bGOuVeiyQMfqJQfGaLysvb+KdwtPTqSBXysK66UmCQTxdfC3QAFlRQMU5Wm6jaWrjtYfj1M2aOB5IsRAPUY+AbmU5/VQZBgrnm9ppp3m9o9pi8EZZm0dxAFKhej+Vd8VNSth4kL6f2BpQO7S+MFWU7LP1bzWWLgI+VH1nPdtrgNY/FcX4v5pJu2F/GpX2FOK9LRh2N5U9vYsiCp+CYW/Wk4+cxrYTIaM8kAAvJovCTciO5m3lnrS5i98CnB9VFIr8e0P/BY7Ec0BAob+fsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 11:16, David Laight wrote:
> On Wed, 15 Apr 2026 14:05:01 +0530
> Dev Jain <dev.jain@arm.com> wrote:
> 
> ...
>>>
>>> c) Remove any randomization from the test. There is no need for random
>>>    patterns, just fill pages with increasing numbers.  
>>
>> Agreed.
> 
> I'd start from (say) 0x123456789abcdef0 rather than zero to avoid lots
> of zero bytes.

I'd just initialize the first page with (unsigned int) 0's, the second
page with (unsigned int) 1's etc.

mremap only moved full pages, so it would even be sufficient to only
check the first (unsigned int) in a page. But obviously, just comparing
full pages might be easier.

-- 
Cheers,

David

