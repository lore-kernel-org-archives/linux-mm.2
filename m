Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD335FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D0B6B0096; Wed, 29 Apr 2026 23:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD586B0098; Wed, 29 Apr 2026 23:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550536B0099; Wed, 29 Apr 2026 23:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36A966B0096
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C41B21A0385
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:05 +0000 (UTC)
X-FDA: 84713783490.18.4367CEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 217A32000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V2/IHGrf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519564; a=rsa-sha256;
	cv=none;
	b=OKIwpdwqi8LKdMd+c9aNryQcdcQxQoBu69UUfhxE89RhPTon5ziuzYJKZDXlKIVQRKSTwf
	WYXhcSHaC28yNvJSiNSnmoxqwk52zoWVYuSBWzj/0TDOc3QbsqodoM+yqdTff/pBbzNyI6
	lWru2QRfksPm/rycPnFSVTORXP6KKhw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V2/IHGrf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtZvvFsn7ntOWmU+f+LKjcOxYAtpK4lZ2ZorwARbkMQ=;
	b=x1LWNFNW08lMjwSSbAZtLHpZPsPI9wLGmD86slTggtqWf7Gzlq1aOWhNzXeLHjjx7NufxD
	cpcCX/M8B2X149iJrlijK9jgYZis/TLGxRX3qKfar54h7lIgUMdSX1F84/xju9uXsXsu2I
	PGuDRrAuTaeswG4rS5BRPT06X/LDkGY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40E9243B2D;
	Thu, 30 Apr 2026 03:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2178CC2BCC6;
	Thu, 30 Apr 2026 03:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519563;
	bh=uKdK5DO8u2N0tp/g6YrMeqTyIWEtsNmEtR2OQZOamME=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=V2/IHGrfyciCnZ68jtYyLcCX+9M7ThJMZaRbPHBvBmKoRk+K76qcgOuTXYyo/kQf/
	 h5OTplRTliCc4X63Y6FlfrVyvAdg5KYdnsvxSXwm9hkZAf8pdGxkdX/t+wSKmPKykm
	 3o2z+7QFO6wUIvvg+B0mdIk+nx1z6uoJGIDFvup9VAMO4drdvfxfJ8iFN05E11UcZy
	 rOwhunXd1D1ig0KRo5uu1vq5DA20gcZZ1Y5ckR+SNFRn+SNJ3mB2LionwukPg6k1ck
	 b3Kp9ZgtCTOh6fyut2FuoH+jqJa7iiIMSyJ3HPmYm6RuG1wUntuJYtMYTQhd5hUjoS
	 OIP4lynLo8F1w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CFE43809A07;
	Thu, 30 Apr 2026 03:25:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/6] change young flag check functions to return bool
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751951805.2274119.14382362682727203864.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:18 +0000
References: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
X-Stat-Signature: yaoapr67czejnepourdbuy9kittu3ea4
X-Rspam-User: 
X-Rspamd-Queue-Id: 217A32000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1777519563-29391
X-HE-Meta: U2FsdGVkX1+8+ieONt0nIjnD70M3V2RvZL6g9jvv0Xjb8lrOFLL636yZ6rIIMH3wpMPCYtrWuSAGprgZFSzdEgpF5/zDuitRecSQg17xxxzs3gWbn/5WCi3WnJOflnA4i5g4ycf4VPquZ1Utgjyg5rph0Qm8QHR74wOG0MIbutQuFXTIp+CNVa5DnL0sVbGUA6A4r18X10oYWDj0j4HQdivtiyIWbIaL44uLvFo8ur0IABTDtF9CSc2pSAlZ5F5hLmmeM9oxEpCfSZwMqfWM+yx99PlOgf8hQrk7w/GeFPaKpQQeQX8ihJfqgfkphnXh3+x8zQBzzCa1nzZT92I8+RGmckkR0XSYol5xB8h9Yj5N3a3MJLpwzRCDM8wGkc6fMDdfPgfKwqk8jyivhzQ1rPFFouM8hj6RYHPx54jQWzr+ujQzImk2+79R3yIDUA5ZrhdG7Bjy58SlvKTenVZK42g/sCAEVD2ikWfX0mZxyVPBbxmlMEAQrKG9HNcexHSPkI+LXCug3MZeLmMAAGb/E1aVbWK7aggiCwuBAqNADmktfcLsFiriHDva+9oq+hglp94+hltYF8dp6r5lnk+ijOzVMRLtapz7aVQrJTSMm1nvBtg0SnOMQPlk7tJuq9Dfmrv75alX3W43bM0YAp+CXDJgLeJG6rTvSvYAT+n3TSHkM79xfChkl+imXKUJm9kECPNxvk8h61zUBtYX0zIawz87lpnuuBae8GPfOokvGsrBWLhFO9/sLX94GxEEC1YbhjSsqUkK2EJsYYiZsjFyphdpc9IfdQaHT68+GJd6h7D1iBnO0O0HaPwtKNAw1w3ihvRaO8HV/JbfZ5oDc/0AnDEm+DeIr4w3K6jqCJ0GcVYAtpg+HHyrOmfj3++S0qR0MtA+05OXezoqUD5tw36foC4d3aIweXSw5Svv4/BixIj+6BysBAqWEye04K2pKmj3p+72mVf2Jq0+W3HI7al
 uuTezcId
 FzAhSd1G8cQnrPAxd/Ygi6iuGwnIcQhptjh2ysFLGHqoOApA3GIa2qWq4R0VL8MV62N7lXH9MiOTi0CrfcrlbmE79OsvVp9nL7Z6wHuZFrQPiYP2VetqLn2zeiZRXcCG2mP4n/AH17lCwKVnIwVl0+pWZ9FIVtCPLRRMClzXZb4omwXeit2JWPBi1IIy8U9rIZ0f66AAhDkoQSXsgToDJO42Rss8lv3G54kSN4JpeHsVxh0lhCdvNzPBd8j75Q5oQ783epm6MtiE6arZiztxhIG8UkHZPL6Z4w22VrkDowhffZDbkywB+0dbPMyh4bVdDbn4Eb2P+zxxUTCsMyrwH6DV/pgCM0LnhmXaK1d7b9mVC/yT+pNmP6/I4s/KFDX6hxdlxDkVyDBuF80y55eAvsh/2BIUfu78oVSL5kF4Twe0KuvX6zAEnNKQSEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Sat, 21 Mar 2026 14:42:48 +0800 you wrote:
> This is a cleanup patchset to change all young flag check functions to
> return bool, as discussed with David in the previous thread[1]. Since
> callers only care about whether the young flag was set, returning bool
> makes the intention clearer. No functional changes intended.
> 
> Ran mm selftests on Arm64 and x86 machines, and no issues were found.
> 
> [...]

Here is the summary with links:
  - [v2,1/6] mm: change to return bool for ptep_test_and_clear_young()
    https://git.kernel.org/riscv/c/a62ca3f40fea
  - [v2,2/6] mm: change to return bool for ptep_clear_flush_young()/clear_flush_young_ptes()
    https://git.kernel.org/riscv/c/06c4dfa3ced6
  - [v2,3/6] mm: change to return bool for pmdp_test_and_clear_young()
    https://git.kernel.org/riscv/c/42e26354c4ef
  - [v2,4/6] mm: change to return bool for pmdp_clear_flush_young()
    https://git.kernel.org/riscv/c/2d46a3974721
  - [v2,5/6] mm: change to return bool for pudp_test_and_clear_young()
    https://git.kernel.org/riscv/c/fb87c8827297
  - [v2,6/6] mm: change to return bool for the MMU notifier's young flag check
    https://git.kernel.org/riscv/c/1fc7dc675e26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



