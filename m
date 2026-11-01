Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237B2607187D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 22:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PCRw8XNL
Received: by kanga.kvack.org (Postfix)
	id 038FB6B05B8; Sun,  1 Nov 2026 17:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010236B05B9; Sun,  1 Nov 2026 17:16:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92916B05BA; Sun,  1 Nov 2026 17:16:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCA676B05B8
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C20AC0B4C
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:49 +0000 (UTC)
X-FDA: 85387960938.11.27FC42B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 955D880003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PCRw8XNL;
	spf=pass (imf02.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793571407;
	b=JKhgIflaNUX2GZl8n0Cphe/dhbRB0cc8B6NN9X2uqHYcnqaS1z+Oo5oAect9yxvv5bfRfz
	/db8nrtyZGnE1WyBsDZs35PPRzNtd8yGdTCObPaATa5Odgw/n25VfffIulxypQsb+9H0ya
	365FotJD6AEzDGKIm3cdMuEVxFG8B6c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793571407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SjWrhc7XGpfrZLDGv5e/UGJ5LKzUlRr1ymU5F3rbK4=;
	b=MrvM+MD+CmcXp+l4to17rKE2A6hPDFDSCCtCDKNUzA6sBNCupVu2KEjAmHq4VyUTmDHBwj
	3GQqR8UfWzncR+CnojffofdF5ruD/tnMrasvrOwwsK29X+Qly85lDzWCUYAnoh3kVxAFDk
	jMTKwU086fXGhlpilSJwtgPJGgx9VmA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PCRw8XNL;
	spf=pass (imf02.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32AD660618;
	Sun,  1 Nov 2026 22:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43571F00A1C;
	Sun,  1 Nov 2026 22:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571406;
	bh=9SjWrhc7XGpfrZLDGv5e/UGJ5LKzUlRr1ymU5F3rbK4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=PCRw8XNLxhwpgQY+VNJEgyemCH7WcIUexDDLxDQtKsJZyKUtdTMN3MNlZltJ6M0iy
	 0sNvBS5zOI3cOGvEHXCS4FDiiBRJt4YTWvt0Z5W2pEwwNWqyPsD/jW7sJeFMWEVfwu
	 32f/8TpLwxDIfiPxqr6f6Sc8JtU205KYvtKUxdXIsWKDgfMrSec039M8wUBLONKqKV
	 C8h60HgiPJV6UBIQ+RJCyhEArenvuts1IeS5Ti1EIWkF9gSpCYTJmdYsxaCB3+MhvH
	 cKC00fZeAT+3Xb1OaF1XeCb/NrEIVbK+ayJvZHgHKBP7c9ZLF51en7iMywKamnPnBz
	 Vky2U/YXxjHxw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA1E838003B8;
	Sun,  1 Nov 2026 22:16:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] arch, mm: promote DEBUG_WX to CHECK_WX
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357140534.2624073.9989407542230376185.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:16:45 +0000
References: <20260926-direct-map-verify-wx-v2-1-efcd64a6b74a@kernel.org>
In-Reply-To: <20260926-direct-map-verify-wx-v2-1-efcd64a6b74a@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 aou@eecs.berkeley.edu, agordeev@linux.ibm.com, alex@ghiti.fr, bp@alien8.de,
 catalin.marinas@arm.com, chleroy@kernel.org, borntraeger@linux.ibm.com,
 dave.hansen@linux.intel.com, david@kernel.org, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, mingo@redhat.com, liam@infradead.org, ljs@kernel.org,
 maddy@linux.ibm.com, mark.rutland@arm.com, mpe@ellerman.id.au,
 mhocko@suse.com, npiggin@gmail.com, palmer@dabbelt.com, pjw@kernel.org,
 hpa@zytor.com, ritesh.list@gmail.com, linux@armlinux.org.uk,
 sshegde@linux.ibm.com, surenb@google.com, svens@linux.ibm.com,
 tglx@kernel.org, gor@linux.ibm.com, vbabka@kernel.org, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
X-Stat-Signature: ss9ib8s38yknowzco79f8y3pea3t9qt8
X-Rspamd-Queue-Id: 955D880003
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793571407-579038
X-HE-Meta: U2FsdGVkX19uhPC79KUOAm6RvkT+a4h57Ux4gXtl/Sc6CtJ13HsndHTmK0KnGpwLUjLEPqkONLdQ6sIPwvEHbAbtOELw9CbYkBaN1ypwmShNW+U1Ic896W67f5tgb94UXIq75b/2VObj95mqw8FC2JYeN4LgI2/nDgZUDAo/agcysVPSyOy9daR+cVsctzBGxeSHgNtWKAB2ry7MFtCvTA0pYSrLdNa3bnQkGda18ye78eG/niQlsNMpvO3qAJ/jZZHQ9F/EobZtd0xbZm2JPhfcHPsKGZqQnHIE01gB0sDG95hTD4Jvh9bOdqQ63mfV7QGen5whY2cCcflCxBJmsVq9RC229ba4kBccQ9/WaE4H4JGom7W9nQ1tWJ5v9uDc5apNT6U/a9my2Yu/hzG5I3ciVyqPp3QyFQU6ZNVpqKfU2+sROUOZ0iKoZeHpYUJK/gqOu7C4taGhTdx56CqlDcZE06ayp7/Ox1dkfYp8KjwOO/x2T4uWBtk5yiuF3RyYW5WuFODmQE222imCGD+loqa6nvzJztw5/7XT0cKsaver/Zi+kq8cMZYW6w0hE2gxQf19agTYXX0exB1j1dSBtfNeivLhp4QCGRIATsL9dN/sjizTNRnlwmhvUEMP9NeyyNxzyTKZ3HXRvoLED/+gXLXX5gaSAvYKFr0w5UmiDEjokJAzh9tLF0jMHR3GseiitcPEV3HFckQqM4Z/eNg/pSDFeMeNGf+GA9OhvkmgYMsjvtwgkrdbGFSN3XYnSke9rGaYqD98q4HGp/R6HVYY3EvYGzvpRvlNXRIYHlMszQYIa9T3ks8ZLY5yFwNclRDMEthhc9M77fnE8j2wapNFBWa3HPu+t+A5FG049fl3KjMbv/bkxg17lY3RBwQAcMr3WVSiTsqpXrhIsG38LdMbDPCiWuG8rbQzo+OfLDE8L0Vmy945sJKbltO7o+a7OT5vHIL28074yvvrRTX+uHA
 A/ddVBkV
 4accJjctf3jPQSz9ud3BGQGlamka7oFf2xFTRqFpJV3xjR7y+XYKbcT5b77QG324Cs+cNouN1oo0UQreBWwykJhw3Pyh+Qi0XgFvTo5lY1VH2pZkZw8Rz/WgTOCth2IU2jZoO/SWsB35IlUPWmtz1yn89j0p9q3HSX5iWFX/j7akz+9+k26CGmAZd+UHYcgCXnNvUMuA0If1ArUI4N2aArKNaKSfVpZpdyS8IjApaR0IyP3qD8caYRf/Iatho6DxmztJKZqxTP49kw6+QBLLeRwlVGqTLRB/DlnRZtiXVIuFNzQZNrFjZGBUzdudOqvTG/a46Tn2tqJl5CAvzbVbi3c+MFc8C+foyTTeL8k7fEtXbfbyYRs2I+OJGPkUMKVXFtafDJzkIlHgPLluM4JE9VdHu/kWA6cwNzrYuaLSESJ2LSZ89AD1ZDYPU1JEhMZR/Ft/uCXWPkGasZKsM5BlgCFI1Us4egkg2SGcxm/CHhJW9bmx9Dw7fsJhJ4o+h0vw7Wx0PZLDAgstPnWpZ0NPaQeKlwY/0c7+iy7BEzceL6HRfu4v+kE20kW+aj2g6mk9UKP0cpurTruHf3q2hfePss++Ecxroh1QyHBJOWF9LSrmJs6V58q38qtVR2fALzk94V1b7CkzXaW1TtHczJg+R9Fe0fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Sat, 26 Sep 2026 12:29:29 +0300 you wrote:
> Verification that the kernel does not have writable + executable
> mappings is about detecting security risks rather than a pure debug
> feature.
> 
> Major distribution configurations enable it in their kernels as well as
> defconfigs of most architectures that have ARCH_HAS_DEBUG_WX.
> 
> [...]

Here is the summary with links:
  - [v2] arch, mm: promote DEBUG_WX to CHECK_WX
    https://git.kernel.org/riscv/c/2e83e2ce34ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



