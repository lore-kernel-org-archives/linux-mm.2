Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49F5BC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA34E6B00E5; Mon, 21 Sep 2026 03:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28676B00E6; Mon, 21 Sep 2026 03:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9786B00E7; Mon, 21 Sep 2026 03:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9E06B00E5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:01:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA2841C2E6E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:15 +0000 (UTC)
X-FDA: 85236872910.06.0A37DDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5BEA520004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0fJ9EKu;
	spf=pass (imf31.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789974074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i78DpXU6G1P6U4iTP5gmX5SRaeIRgR1YaUqQ+TZuQSU=;
	b=kFjL5AV2RgajrAnshtCUeEUdYrklYGFe2RYa/hJTRxKaA3r4Ako9hnz6EfnqHsG7oz0Bl/
	cqnX3Mh3hqdrp1zu4UtxhX0KwhgTJ0cLbqdOdfiK8dHou7wmw7XtzIE3vhKQWtGIamvLkp
	t1jo3KCWnDv3USoYD06lL9lTTdeVZVM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0fJ9EKu;
	spf=pass (imf31.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789974074;
	b=tWJEzr1Z98BnRXwrs/NQKO5uMFQJRySvZHcrz4GwLhJA3KX59TG7KRqa8u8gXoiL5KofUi
	B0zfSaQuFFqaES+WsX2xaXDFCfJG9WCVxl/S/u5R7FU3n8mIqtW9a2pbhzGTrP6uCdDI0z
	l8CTDhGeimYzk62gg5HByJjB5w1uJSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC17B61B71;
	Mon, 21 Sep 2026 07:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3F01F00893;
	Mon, 21 Sep 2026 07:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789974073;
	bh=i78DpXU6G1P6U4iTP5gmX5SRaeIRgR1YaUqQ+TZuQSU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=m0fJ9EKuEOApABqdpECx+B0q8OocMmr/FLt2AthD34JiaM11GD+aTrxDCpHVGyIM4
	 m6XwioEK/PAGKvQxZcI14MOiFhkJa/vQJ4N8LDA96DoEBeA9jgvE6FySzjWEMrEI7M
	 0otTHvecRE5IIGSEYybo2kC0ExJKmpE6Adsiu9MLzYwHIOGEq+p3vmn8n1tKoX1ETW
	 NcmMzdjNfbadpRqunWbRKD/cI+3vd1lWwDrog6jhV16oTLEJ9bcdHwwo3U2BWaj+tm
	 7ZsgR0rP6gAbD8Xfu9CE72IVjenPXYyBW9taNAFLXAU3j1CuyrKK1bBm9YgMk2MazH
	 1qvBjGR/Le7sQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939BC3926266;
	Mon, 21 Sep 2026 07:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v13] mm/bpf: Add bpf_proactive_reclaim kfunc
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178997400515.2390936.16367635369472910068.git-patchwork-notify@kernel.org>
Date: Mon, 21 Sep 2026 07:00:05 +0000
References: <20260921030854.17858-1-hui.zhu@linux.dev>
In-Reply-To: <20260921030854.17858-1-hui.zhu@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev,
 akpm@linux-foundation.org, andrii@kernel.org, eddyz87@gmail.com,
 ihor.solodrai@linux.dev, ast@kernel.org, daniel@iogearbox.net,
 memxor@gmail.com, martin.lau@linux.dev, song@kernel.org,
 yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
 shuah@kernel.org, david@kernel.org, baohua@kernel.org, geliang@kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, zhuhui@kylinos.cn, jp.kobryn@linux.dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5BEA520004
X-Stat-Signature: yr73o41e3w1mg6h5mnxpz4gg86hac59c
X-Rspam-User: 
X-HE-Tag: 1789974074-754183
X-HE-Meta: U2FsdGVkX1951NzEmY4tRwsY4NUly25dwKKeTGK2PJacOTnlrV2kbvSJIlA5MxSrSw0/mAhQ2oRfKzKHFd85qxiq/UJp3iAhFvr9OdhOhHEK1w+tJErBVVOK0dJ/x36cjC07eJ0ebnVOZwOuxUq+H0usbvOh839e+mEEdgJC8/eE0ibme5RWeCXbYKLnfC/Gem8h68e0IRAnwWhLadW9Lsjy8iE3bXm1HEGOKWNy3p9HQFP7i/TPOc17EzLBdaRr4Rlezge2Em2CYOF1z+oXHEheN8soIwdtu2HTm+51TVdUCRX6R5bEWfebcSw9JSVM1qauat70918KcKdYaf0ElBVd0+D3pYfE8OlZqDfM/p+/T9OaomnOVW8DiwQa+nF1Z8hjQ1+TUDgps6+CRxDUjvesvwcTrJe40Dc4o1prEMtadBODyaOxrNU4+s1TIG87flG00YrbSYJef44Ypmby9q3P+ZGlk+XlowyBpx/nsAg4NcyGNE3GJv62X14BMDVh7cZb9HMpMKtMEqNmxawQPDDJAIfANryMEJ8YwVfaeH4J/IpXUIKTnmStB5MqfLotLTlL8LKAEoZlfAurYOB2Xe+M4HUoQZ0RoYhp+ePzzqL1YS87nSXN1mqQ9bS22VN09QwEVCx5DzetA6OqwdXXqNhXJFxDSJkd6/U3JlkKUbgele2CTm9AIYmaHeRU8DJPtrvgWQk8kjSneoIHKsCfUpFui40FedYKositc2f1AqhRpZRPUr0W1yHf1LvDsyFiRwjkqX4pWBpW6rrfCXlEy19Ltkx9XX+FDHpInJUyY7Fn2XaUR7KrdAvfjQ8CATb3zo0vNlul6FteHMZBMRN09W+rnq2YWjJwRV9FCpec7kgmx9QkWAf1Y98s2gKryCaio0MWeeRggWP+fmX1wfZgpJw1KN+Cuw13m2h/Ls0OjtbH8vKNmWj2QY372dkaL4cNBg+z/Exyd9ON5kxs9te
 Zx8T438I
 z/lN6IK2WoQOZhZOSL3hwpcnZXhKOSt2u3FCWfzxO3FDnxSE5Zr7R3izSCox1gIbwEziIA3WrUBa8cHIkzRcfbr8Y5CLESN8M2YYD+xuVDgajq/JXB64KKuBAvHo7ArfROzIWog6YFqSlvL6dOUZowSOkr4/qf12/Y1bmFru28T9teIGSWRRsERUIS2HHc1ce08pF88BGRdgjvhSbMLTYszbBO2XHF5Hh5zAQW4pX1VtZDvZIZbty0HkT5TNgG2OVRHQQyDdc4d8pfU2fSmLgrxNkpl5DqQWFafvpbJIfuAqWPOnhaEFT5JDo5y6aQOJTeJq5JeMAsynGiU5Md3EeUwonRzn9fH0VaQZoHNfgg1vlyi1BZzQN+lMijnYmSqjWeb05eIIsmjFrNB1ZpdB+rYhlquScIUaT8zXw7ZVU1OdcLHRtM2GMkddYgcfJrUQ+MIeSEIEul7wn/vP+VGES+77noTN408IhRhI8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Kumar Kartikeya Dwivedi <memxor@gmail.com>:

On Mon, 21 Sep 2026 11:08:54 +0800 you wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> BPF programs can observe memory pressure on a cgroup, e.g. refault
> stats via bpf_mem_cgroup_page_state(), but cannot act on it:
> triggering reclaim requires writing to memory.reclaim, which BPF
> cannot do.
> 
> [...]

Here is the summary with links:
  - [v13] mm/bpf: Add bpf_proactive_reclaim kfunc
    https://git.kernel.org/bpf/bpf-next/c/48ea1ba704aa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



