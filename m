Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C57A4C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16156B0098; Tue,  8 Sep 2026 06:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC76D6B0099; Tue,  8 Sep 2026 06:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5EE6B009B; Tue,  8 Sep 2026 06:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 666B16B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:15:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F012116048E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:15:58 +0000 (UTC)
X-FDA: 85190189196.06.227F5E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 24CE2C000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:15:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kPlt8z7j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788862557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekjkNjyquBfVj0KUaXkP0qTUEnu6sauJ66A70KU2iAM=;
	b=49o8jFMmbs5eda1gc+5f7cywnbMtcvxQIygU0qPJ2tZKq86ZjlQZhuCer9pg+st6Q3q0/P
	O4nRDTmLJslQFLwSQ+67zjRLOCbEbEXwM7aJBWiFjfxIMyTb6HRmQ3aYp/Rom9fzrpsyaK
	fo+VG8pzXxb/Bxi7vgy7kTIQeRfg4LI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kPlt8z7j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788862557;
	b=x7f7WzxRYUztezp/zCG9rcmBrk4dIsZWBoDXTlElbwVW9WipXjrf2YQdtWkSmTGKvjTGEO
	lNT1CDwhfpzSUSonMpBsuMKNvh0PtiBFxme8nVZvO+dsth8Vb+hde1dVJG4++I/VvnXdLo
	klltSt3rirYBIGY9bDeqqqYkR/JnX2U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22E2E42A41;
	Tue,  8 Sep 2026 10:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCED91F00A3A;
	Tue,  8 Sep 2026 10:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788862556;
	bh=ekjkNjyquBfVj0KUaXkP0qTUEnu6sauJ66A70KU2iAM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kPlt8z7jZmNtunlUzwNDs8G6avxVAMsAD5cPfdkaobbL7+WfVWyPofROj6KBDOnvS
	 32cslRcICIzEoo24KXgU2CT3g+SyznrFPBm7ratNwixpf4yLwLE7TgYJxyGEEUte+4
	 NOmK6Z4vDQxg64SpI9oIe6qTREXaEwLSaB2bJKk86vXY83KmzFPJGQqN8Ae15zjOgz
	 ql1QOtj43iaqQqaLLsjESsy9iEWnOuMQo716zHsbRulSrtKNsSf+D3qpGq+cJQADHY
	 fRsvFByfuaepL5ab9jTt/exrvglxG2dO/N5OM9EdTFs9GvfPEAkRYspWPVH3Nrt7ZR
	 ca5x/QANDt6ew==
Message-ID: <adaade14-6ce5-4a7a-9510-8ff99ee66eca@kernel.org>
Date: Tue, 8 Sep 2026 12:15:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] selftests/mm: Validate selections and scope
 memfd_secret setup
To: Tianyi Chen <hi@tychen.cc>, Andrew Morton <akpm@linux-foundation.org>
Cc: shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, jsavitz@redhat.com
References: <20260906135444.749144-1-hi@tychen.cc>
 <178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5tmxkhcsygz8dakxeqow4uy33d5ot3ew
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 24CE2C000C
X-Rspam-User: 
X-HE-Tag: 1788862557-596570
X-HE-Meta: U2FsdGVkX18fEo5U6GeWaeGgjpE3jpKhpin1rNK/vOOgxEE8gszqk6ZzsiB3u0OS2Ugc4nt8ftpms2UQeI/+Q0p4cPy/10tqFJ7tBvzw9Jkk3MOIYBQC+3XTUSuycivm7fyOelU584d/1+GiCiP697OZnWVp5TQsG5NdsZy0nvZ9q4IvRA8NlU58C2t6m5+kGGa/LMZVs+pvKAlHCzi0+4BmgOTLvvbK5iEoY6SWpGX1r+rvWUGAZR25oUQjl8d1hadZA5MqmCaZuwKV/8wVhwtG/RiqyqaeJqMeftrCTJQRDkOZmUuTF1zO2JfsX1bMwr2sgwJ/Jkp+W+49N5MrGVpCQlOrW/wccOP/7Rzi/bZIloq0Fi6gA2HF4U/ty19ZPVZP/pOde1aIi07gZrJokfVDeks9yQ3P8QPtDWkUbtFI4Spx41BXwkPbLSJybjdwsLVJsfcgwsje5rwcgC8fnB77qmOh8n8iE+Ks0rNeHBQEymEIKMK/bVGvdnQFUtUnv/2PEMxLga2PBP/BMIQNjp440KcIzd7TLBFWVvj7Ekt14hkk2FNRCigEYsdKOMMi3aUgAYUNGmtD8Ba1RYgv9hT9X5NUqDKhaqAvOuc4wOAAbcmvM8NgQBU9ud3tdj+WovmaKxcV0UMoxA7sUSXTXu3qvvGOO2Y13Cq2bKMkvKTvOL+USjljgOxS6ln+SP/CmfpxvaBEajIDPZwg42dIrT6+a7hOKwbUaQrXWaId6WKnf3KR2Vne1RiDJskycCWN/1qgC1T7vDqvrouF47lSMtt1qlKM97ByAe8joUs5rBzskie4yChT12GuXbl4C9yEmnO8kwa/o4ilLKUoMfSMn8S0+EcVgHqERqw2iKosI4b3RaccZWf/I3TRGmpwf63XXcz8LfcDb7UzdSfItSuNBQ1a7NyhaQ00IiexNKVo8BjEMrNAFQbISzSW5j+qhYksyaTEy/6xNXbF2Qq9tWb
 UWteMVQV
 PNYv8XRVJFffOjuJQZas/JeW3BW1mTQ7wHiQarDTGrrBOScdbsDjXoj3eP18JK9IXeyj3ZA7IPrg/oPe7VaQkveQsPeHW6Dd5mG+f24SDGtSOKl4YLgAhSa+1L59hxqC+RMKqyPUg+MjISp7feC4BpGNCjqgfsBQomBCWwcRP05mw5695dl+YewwKG3q19vlEu/6kwvdEAt60IQ4cHj8QIXlYVRtLLUO3KTx0EeDR22RAPKefAA/ilXJfvxz4qTjl8q/ixzGoMYqry9mC8FMaXYd/6QJYGXKMYrR5SM+CxC1/CIpJ1HafoyQrf1vm0Bf3vsh7HBa3almE1/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 11:55, Tianyi Chen wrote:
> run_vmtests.sh can reach test setup after an invalid category selection,
> and its memfd_secret preparation can change ptrace_scope even when that
> category was not selected. These two patches address David's follow-up
> questions on the earlier getopts fix.
> 
> Patch 1 extends the getopts error handling to reject empty, whitespace-only
> and unknown category selections before setup. It uses the existing category
> list in usage() and normalizes separators, while preserving the default
> when -t is omitted and the existing environment-selection behavior.
> 
> Patch 2 gates memfd_secret preparation on category selection and executable
> presence. It retains the existing behavior when memfd_secret is selected;
> it does not add configuration restoration or otherwise change that test.
> 
> Changes in v2:
> - Rebase onto current mm-unstable.
> - Extend the original option-error patch with category validation.
> - Add a separate patch for the memfd_secret setup side effect.
> 
> Focused validation:
> - Bash syntax and strict checkpatch passed. All 30 documented categories
>   match the categories used by the script.
> - Parser checks cover omitted/default selections, empty environment values,
>   explicit empty -t, invalid options/categories, whitespace-separated lists
>   and command-line overrides of environment selections.
> - Twelve invalid-input cases and help were run through the full script in
>   a KVM guest. Invalid inputs exited with status 1 before test setup.
> - The real mmap category's three programs and memfd_secret passed in an
>   x86-64 KVM guest running Linux 7.3.0-rc1, including multi-category and
>   environment-selected runs.
> - The guest kernel lacks Yama. A disposable file bind-mounted at the actual
>   ptrace_scope path verified the shell's write condition: the old script
>   writes for an unrelated selection, the new script does not, and selected
>   executable memfd_secret retains the write. This checks script gating,
>   not Yama policy enforcement. Missing-executable behavior was also checked.
> 
> This was focused validation, not a run of the complete MM selftest suite.
> 
> Previous submission:
> https://lore.kernel.org/r/20260906135444.749144-1-hi@tychen.cc
> Review:
> https://lore.kernel.org/r/519ef70a-679c-455f-ba5f-3841730873a4@kernel.org
> 
> 
> Tianyi Chen (2):

For the future, don't send new versions in reply to old versions of a patch set.

-- 
Cheers,

David

