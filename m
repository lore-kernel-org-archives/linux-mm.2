Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED57CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440546B009B; Wed, 29 Apr 2026 23:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418106B009D; Wed, 29 Apr 2026 23:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3549E6B009E; Wed, 29 Apr 2026 23:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 268376B009B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE2171603DE
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:17 +0000 (UTC)
X-FDA: 84713783994.16.2265DB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4340310000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dlIOoBl7;
	spf=pass (imf05.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAxF4KvCzbgI60Y5PvtMWwmMnfgjdlih7s6XmrKXUiI=;
	b=kEdiwIMsPuqdPZ8eAB9NTt/pkz01JsxSf7SzMKLSMS4KS9tqsl/knueVktTw9nQ00Igzqw
	REhRXFqr2OFPwvrQkW73V5MacCzG4J08Up4Aji1smWGLVFDCPsjqk9bBOmOJ7vRuiq3tYW
	tm5V2jamV5FnGInXAX1Rv+6tJWJGW+Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dlIOoBl7;
	spf=pass (imf05.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519576; a=rsa-sha256;
	cv=none;
	b=CkVMb4TkB3plDFHEPwWq5ansxg8WYhRDxvZEmWQUnC+OAkAOgF4ekgMoF29/EZwVoQdKxQ
	qUu7bEQQoPixUzdfDTOCLI4SIQxlGMzh5XRVGj7zdtyERvYrQZA+SZ7J8u8U4FE6Dwn9ke
	989CBLjk7z077QheSJU+4ni7yKnFRY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B24796111B;
	Thu, 30 Apr 2026 03:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CBBC2BCB8;
	Thu, 30 Apr 2026 03:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519575;
	bh=smOY6pVVDHq+6KTLdCSD+6r2J5A4soRjk1OnTI5ZlHM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dlIOoBl75hOEvwa9uZFaZ+vWlsAdTS39VaV4zcZr1mzQxorM426fS9+fb28XtX88C
	 mIMu8bSZblyQBO31WlUqBz/lLMExGlKNb2t502quWMfL1IhwIaR/AD0zsN8a+NTHJ6
	 zmf4ytfrdcHkQlThMspBfvMBQDI0tL1x8xlIkXHVW0gMUhTWpoTSTiWboBMAsfLejF
	 xMSpymzn8EpJxwfu8ylIwFEzlUqynLBRHPUrG3gQLEWB71MSDyIjlXH8YvuULeIEX1
	 QjYiMQ3POVX8oQTp1LZaq859UmwFqPiAefqkYOMchJ+U9DxQPoBfsXiabOdjSMuvQk
	 U0dvV/7SEMN8w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E8D3809A07;
	Thu, 30 Apr 2026 03:25:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 15/18] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key
 static key
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751953040.2274119.2787096861157625411.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:30 +0000
References: <20260227193030.272078-15-kas@kernel.org>
In-Reply-To: <20260227193030.272078-15-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, david@kernel.org
X-Stat-Signature: yp3bq7dsuz393k45ak7uxzbmmwp6kfxs
X-Rspamd-Queue-Id: 4340310000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777519576-360487
X-HE-Meta: U2FsdGVkX1/v9lUnIKMTUdy1gUsNx4rt9Mhb1C/cfDhLP0Nna9y8iY9JaVQSwmDds1E7QCY+YkvA7AlWT1/dARXYK1vEqN7MD6/UsIW5xqpn76Q0V6FSjygRNk0Cio+v/6vFHJgpXzbqnSQMQ/Kjc5mfOQbO8NWkIc7q9Xmq6BlII9c1CXz7CqJYwc4ZvKlqe5FOYnfFA+X+H+vaGPjGRShA3hcfs046+B8HfD0nbLewBPyE8lXwjmgNc8p/EO55hsvtGezQpl8Q0R4FyQSqgJfWJSreDgX5pjBAO7ti8hZ+gpryEUUIojpExIXrah0gHB71tdGDi0UYKZIoJbqQc/zvf/eCBoYgjsxAjdFgfB/gv+18vbrz5+mA5E5dBKsAHpAMpJ9/yhal7FR0EujpQZNbC304wLOmmKwGVDWt7i6MlD3gmpGqIC91Wa75u//z80Bd+4Sp3gqIeUoq837UD4B8Ei43H48wZrfWMImREhzEG1ns9eFP+RuOJX6R+AQWxKCvEMYWfc+b/XVSCL8Fb+q5D0ncw4ytGhuc721JNGdyre+ksYoo/VVDhkkzUykAC+1Vguq1Ryaz1VivMytri3wtHy/yxQfaF4OTrMyQIZU0wOvoHJjGlOLOTsSkb8jIW4LDS+4/EIzh5XlugERUfKTNJ91h4twZuHRNxAYqJA73exnEW+W2Lly5BM40ItXjsH4h6l8ntV/PDXzWd+aUHXr0vqKC5jXPzpdlGwkN85mgN4KkBibr6htRDXVmJBB6DaX6jdZ3tG+N0rMSc+CnxQBpQhILtSpVRII9ama6ru/v46exvteZp1gKkizVGEahxXjSIcEeOOFYvk5soah3kifrKbAggG2SbsWEKg7WISFb/hIY140jkoiBStzy4tzcrVcZOGTF7KK31CHCD9ngY68RTnPC7cMXtR98viDvxTTw4kr6IZuPNxoCxrqoBYW9QGUupLKxK23+lkJmX0T
 796u7sb6
 Z/THEbHPPk+OIMSW8S5W8ajP592kIQ5tprF9aG6r7eCTUBWeYq+Y5Aq2dMu2JWH3yIH+HQFmnWEemd4tJx/p8vZZY/HAC14fqX/cl6BLxsk8IPbFHF1QoGhedFwzrvCIU9eQFExGCAB/DQiiMrKwdI/qa47zO4wWnTz8KvdlsouIXCRzH59cfmoUBGa5dF18H2gA91YK0BhPYpxtvTbDlE5GWW1sXMKPd+rQj15grzTrrXFQ+6PsOcMS/hgT1RCDev/Y5EE+zXgloHuf6JStLtb8yMm5BjJ3icocDik6D29MARRf1sCeuh8jHTL64T/WKQ5uHk6uimVG6rwuia2MwJnGb06q6FQsRQ4Lv7ZyV7+aNv5E346b+K+MhgyJ3LXJOX4MOLUcTnxpEQpmwYZI5ALVAP+fIpLzDFmMUa5cqyzix4PxH+2gsaUWlfx5i0YAdyqN36dmK5l9WjIIVyRXkOtzRRXdO7jMOxfsg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:16 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The hugetlb_optimize_vmemmap_key static key was used to guard fake head
> detection in compound_head() and related functions. It allowed skipping
> the fake head checks entirely when HVO was not in use.
> 
> With fake heads eliminated and the detection code removed, the static
> key serves no purpose. Remove its definition and all increment/decrement
> calls.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,15/18] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
    https://git.kernel.org/riscv/c/da3e2d1ca43d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



