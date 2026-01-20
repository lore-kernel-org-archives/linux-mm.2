Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A595AD26280
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFA26B0484; Tue, 20 Jan 2026 13:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D2A6B0486; Tue, 20 Jan 2026 13:36:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDC276B0487; Tue, 20 Jan 2026 13:36:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD8486B0484
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:36:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9673C1606AD
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:36:39 +0000 (UTC)
X-FDA: 84353198118.03.E40CB58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E94A140002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:36:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nWDbIb8C;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768934198; a=rsa-sha256;
	cv=none;
	b=pX28A8FCu5/etgeLPIyvV/ks0iW/s3Hd3g2Da1uHlQzj5t0nQgQajjVbb/EhC2xu4yRYlP
	vZFWa6TvwZKkXzDmH/2OVC78IXHJHxokcQv0wA70HFBMfph5slv3tt2Azd1xA55tslmX95
	aa/2EPaPwnauy6wfJQfhesjJ6EBtmpk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nWDbIb8C;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768934198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDMPLKA0NvtUquTBXi8bx6F+PKsFGu9VN4ljw7/OJJ8=;
	b=3H3Id+2Xfr/HVMkWfb3+B3r1INvF1wJaovcvqITP706mK300yTm7dG6ksJtCF5clVwIwDn
	mcbt63SD7EA8jNEGKzfNsQhCqczJ+dT9lGHo+fPprfyh8H5GYLtAZxFwaILPW5PM2lMSqH
	iHrsC527OCvfGxZxAIAQuRhaMM1eyAc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DE02160007;
	Tue, 20 Jan 2026 18:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA94CC19422;
	Tue, 20 Jan 2026 18:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768934196;
	bh=QYKth/XopUUmN2w5/xA9zHlbSfdy2ir24LbewWEwvOU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nWDbIb8C4Pdc9S6Dmuhx0sP4s0TJLIBQyQ/AcWbVHuZ0hRe0PoKYtU9Hxw7X8LLHA
	 aGURL8szqEnjBpSMEtjFVGh8C/URSKLfq0rrzoK8uC9cmJppJqsnolI/JyuUHEPJr8
	 9reBvNxeN1DY9U2ZV2noPOjkpnUU3Bqg1QxrwnPWOSnMq58zo1iMYa7l2HieqrX0oA
	 8ApTo/v7yNwJwAlbNpibuU1nZvgD952gLoAG/3qwjwIPsbPb7UPar6tliXWZ4G/KW6
	 LfGny8wlbK+Hk9h47zxldaGYXNLdGVZCr+l+U1QnflucJkAB4DfAjL3btK3jNCFHlr
	 C+4tPohqzOZ5A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Jason Miu
 <jasonmiu@google.com>,  Jonathan Corbet <corbet@lwn.net>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 3/6] kho: docs: combine concepts and FDT documentation
In-Reply-To: <aW_K7QZj8HYzA00t@kernel.org> (Mike Rapoport's message of "Tue,
	20 Jan 2026 20:35:25 +0200")
References: <20260105165839.285270-1-rppt@kernel.org>
	<20260105165839.285270-4-rppt@kernel.org> <2vxz7btce06f.fsf@kernel.org>
	<aW_K7QZj8HYzA00t@kernel.org>
Date: Tue, 20 Jan 2026 18:36:33 +0000
Message-ID: <2vxzikcwcery.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E94A140002
X-Stat-Signature: md1a7rbmtwh9irpbr6q57unf3zrsngkm
X-Rspam-User: 
X-HE-Tag: 1768934197-515055
X-HE-Meta: U2FsdGVkX19jVjoBg4ce+/9o/+jLO9/eMiDFrg+njDuaYmYkne2Faphau9/f6Epg6zC+PPwMMt8OhHStwm3u/c4srhDHDbVKkCEQQF15BQ5EqYjfCvTbmaHdxUe/IXXQSd7EIWF9dRQoEzFfJz8yYkvVr4/rZEQ+Kr/jkrhX7wT4CnuCjSH1VTRHjhEl06IC3MYOGb391RKPbUkUodWd5TZZADbrjKKIl0YxAdnOcSY1OrvZqSYyRRBAXDsBO8ybj+esh6JhJpUq26W/ZV7zI/1PIeeS8ktv5xrsIS9iHbWiEBdLRe647HS2IO1baB8hGkjxABNLGhBxSEdgHNG4oLldhyBRFpjaEr8VSF/1xj3WzazIOse9V1YC0MmsQTuMj1xCiDyUzYtey0+Q1XBBKSwW7e6R9G0XZsTptELNIn6NzFcvJeybq8baCBsK61UrGgPdRaA1TtEglScHDfNXw8l5CIDuNkfFiyxLkeztCE9DIRFAEidyfaYGCHMX2ZFvEjUfAjwI2QKcVUHeHVU7aeYxk/VxKg9YkQuKZ4dbdVFPZDAY2dBM4hitpiv2iLMhuQU7FPBL8FsXVrh8YC68+5uxkoDLe+MgJ7FVX2M5GuFQKGiHlEzHcvm/bQNBhH4G2D5qjXrFx8vMjhezDE877QZPoBIizVDjMxVR9PmQf+yccKChGTIqya6c1q1xnUbfE+UoC9xz3aeOnB4C8PV3SBZsE3q3shpN3QurQrxMm5vwXjfOU8l4Y2uVicsJhV9+8BONyWSBcRvdCvjkNvjSi7/nmzaBqEeKuHj7ukAQxgZu4tlLykyMU6yC8iomtTM2Y/pWmrASe2cymGA8j5ib0tVSJuGBHxfIhohVObid4ojSYQ5qmGF+ejbeRNAAek9ysxIK2FN7pY74SdUqKCRqNaAi+5lfiaYHVRpyWrWNKcnLE5setBLRvzKV27TegfqNF/k4HZyosQW9phkWDuA
 7izQtbmR
 P3xWtSPs+f1Pi3f5IiRo6uHbH7/3UFw1VlOE6I+bg6UE8lxC2WicFiMFx6NcEQDj0xgtz6XWYCxci7JHWVdPc8G0zqr9E13VZvjuWDk5Jbcurq7ZPImPsEeLGG0uUBtN5Y4e6cWFO+qJU39hovx5tW/sjDMQPbKv5IsDx9jBpm3jEFgwPgdNcSP03EIhdQPgYLYXy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20 2026, Mike Rapoport wrote:

> On Tue, Jan 20, 2026 at 04:08:56PM +0000, Pratyush Yadav wrote:
>> On Mon, Jan 05 2026, Mike Rapoport wrote:
>> 
>> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>> >
>> > Currently index.rst in KHO documentation looks empty and sad as it only
>> > contains links to "Kexec Handover Concepts" and "KHO FDT" chapters.
>> >
>> > Inline contents of these chapters into index.rst to provide a single
>> > coherent chapter describing KHO.
>> >
>> > While on it, drop parts of the KHO FDT description that will be superseded
>> > by addition of KHO ABI documentation.
>> >
>> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> [...]
>> > diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
>> > index 0c63b0c5c143..03cd9afbdb2e 100644
>> > --- a/Documentation/core-api/kho/index.rst
>> > +++ b/Documentation/core-api/kho/index.rst
>> > @@ -4,10 +4,73 @@
>> >  Kexec Handover Subsystem
>> >  ========================
>> >  
>> > -.. toctree::
>> > -   :maxdepth: 1
>> > +Overview
>> > +========
>> 
>> I ran a test build and Sphinx complains about:
>> 
>>     Documentation/admin-guide/mm/kho.rst:10: WARNING: undefined label: 'kho-concepts' [ref.ref]
>>     Documentation/admin-guide/mm/kho.rst:31: WARNING: undefined label: 'kho-finalization-phase' [ref.ref]
>> 
>> I suppose you should add these labels here.
>
> It's already in Andrew's tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-unstable&id=bc1a060da2a76161ba65f1badc551de15056e398

Okay, nice. Then with that,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>  
>> Otherwise LGTM.
>> 
[...]

-- 
Regards,
Pratyush Yadav

