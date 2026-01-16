Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C19EFC982FE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 20:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AF516B0005; Fri, 16 Jan 2026 15:45:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DCB6B0088; Fri, 16 Jan 2026 15:45:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F376B0089; Fri, 16 Jan 2026 15:45:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 042D96B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:45:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3D511A0272
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:45:53 +0000 (UTC)
X-FDA: 84339008586.03.EB754E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1648E180004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:45:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YF2dio7I;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768596352; a=rsa-sha256;
	cv=none;
	b=xcX0q5mhR74YDKszeXQzv7oLHuSuNPixJZ0Zy7QI5mdx+TsIN+DoVuw5irqWwISeVHZHd+
	Lql9+gDx8E5DjAF+42IIQCktQT2pQGsFHTuTb17XoT2IyozrIAsVm7tk6tEh2X8mSCt2oP
	61e62s5XOpHjexPzmq3kWpHhJt8s3yE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YF2dio7I;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768596352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOImlsGNmjiPGX0PpDpbExJLn8/h6ObYP4NuVrw+4UQ=;
	b=63o8lncHb25PI5hjBEguO58KwKJG8JmByYifosrGzgvSkS3DxI2zLBlG863mkW6VWEiRaM
	kMXF4ryNED6i0bSYUwhzLGjS0xPguRvAe92Fe+IxFN9JxdbeyM9uLY3oWahpfgnoMUbRND
	fLMFVVg/6rMjIi+zxUX5B3hto5DJZIk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4191460160;
	Fri, 16 Jan 2026 20:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A21C116C6;
	Fri, 16 Jan 2026 20:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768596351;
	bh=bOImlsGNmjiPGX0PpDpbExJLn8/h6ObYP4NuVrw+4UQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YF2dio7IHemM0ABIjiE+Gmc0RLoPr8rGsHC06ooOYb2vRssBLtSsfT9QKrfvsDfoy
	 g5Q+HjnVbPhcy12AgAvivvkzBTM/1NAaEvemOOVH5Tvdf7rNN25h5UsiSmxGZIdIRw
	 iMAaeAtaWAuqipCFRipaXp+6WHrVnEhanUctQxyQ=
Date: Fri, 16 Jan 2026 12:45:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: kent.overstreet@linux.dev, corbet@lwn.net, willy@infradead.org,
 sj@kernel.org, ranxiaokai627@163.com, ran.xiaokai@zte.com.cn,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] Docs/mm/allocation-profiling: describe sysctrl
 limitations in debug mode
Message-Id: <20260116124549.db884e094f093340c63aafbc@linux-foundation.org>
In-Reply-To: <20260116184423.2708363-1-surenb@google.com>
References: <20260116184423.2708363-1-surenb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1648E180004
X-Stat-Signature: iphsu7cxpbn9prdfyid7rrdumk1qr13x
X-Rspam-User: 
X-HE-Tag: 1768596351-430385
X-HE-Meta: U2FsdGVkX19HFdtxQiQ+GudP/dOWATyW1Di53f1OzTXZ5mlvpQSeFK5dc/xJA+wnPO8T8wEFauTYuzW8bQwUWSUj5sbsxPlybd5T0OyMe+A+uPwNfWsC3od3n8/b4+LDq7sffpbMCHNMPk/tkOJ0n2pdPnjm+ylS7hVKpzwH1kE+sIk8plx290J+bs6HRZ4rWv+ZukO/TgkcZvx53KR5w8y9iSImrl3zFMxFr9e/8E5Xtk6B4ViZUz8gX1mGcFzltaYr4kZMTObaB4VtWwpKj2OTLiIFpiwpRxxmpDf5e3PZTDEeyPQhE7zQoK0wJLai3p/EX5FmjV+jWfjE14bNYppINFTneLqZ0VgGst6Gi6E/hNIAIdlLViM8mg+pX79jlIZigWf7EBB3RACwessuk1ub6IRJUOZw0f/+aBIUYAZxlisvQwi4IBxM/0lavsFjLW4cMxCyPOBiYxcNL0G3W4g+TnWNoFWMDlw/Jl6SnzgMaKsRXmVJSQw75G1voCN9nTR6kl8HbJhOqeE+Mfnib8xgY4AwOiEpIHhOYE9pavsGH9BDD1y4lSDk7e6V8TkLohIwmKsWREl/kiJmh1Yxr/9C9IQddzq1UlQOh177E/5/3jfjS8XmLgOdduFSD9jFL0IsVnMxrbfYdTYC+JeMFCkkYm7+wnaecsUVmvsKiuBWbQFZJRvntwajptbdBvYX06bH3Wf/a11jxX/waCCIVQf1QZ0JvFP+fSb3g0T03sl1GG97U/Z87iRwuS+qDvG5bAsvGRWDQN4Q9z0cH4mqY4s02wjrQ4RXF4pBkb9lpb8k9v7lN7tSBsQrxDL+X4m6aA0JBivO9M3PefINUj49Ei7PcSTsH67c0cEeEv3+uf0jnxR2v1P5euJUl8jAaTSCUeBAWAyXZ9p3n9XZ2/MR2EI/pWDh0W/SMK51r+wZdD5mU7DurpnDwQrANQGG1rBiGRPAOZXbChm2/BDnFz/
 HgyzlDsI
 Mpj0P9aTsRXQCvJ0p6JGtQkT9xeV0YWmheVhN8OyU+8Rhg5nNISZQCJpew2NfxgW/tMQX2n15GxvUqzJdt/dO74EwhMKjxBD8uh2yUYf4xECKcgJPmtdWZyK66tb4w9/8pgBPM4NXCeP/rwmQn1XZoI4ucoL5oX3JGiPbL7P9g1xmMOSsv5o+YqB4F/ewdU/KNoHzKhYa2Rm+on6CDVtNFiLhkjl7teaPIFQulOZ0JzYVVE3ElP4UmTFsT1IlmISrnujAm417VWrBjwr267m/W2uPAo9ilryvg9WAKXCuBBkl+/AS1MQv39vPbs828NtgxqFP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 10:44:23 -0800 Suren Baghdasaryan <surenb@google.com> wrote:

> When CONFIG_MEM_ALLOC_PROFILING_DEBUG=y, /proc/sys/vm/mem_profiling is
> read-only to avoid debug warnings in a scenario when an allocation is
> made while profiling is disabled (allocation does not get an allocation
> tag), then profiling gets enabled and allocation gets freed (warning due
> to the allocation missing allocation tag).

Cool, thanks.

> Cc: stable@vger.kernel.org

Documentation/process/stable-kernel-rules.rst tells me that -stable tree
users prefer incorrect documentation ;)


