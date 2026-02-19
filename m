Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52DB1E9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 09:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3956B0088; Thu, 19 Feb 2026 04:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751966B0089; Thu, 19 Feb 2026 04:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6290D6B008A; Thu, 19 Feb 2026 04:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 47F516B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:07:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E071F1C457
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:07:31 +0000 (UTC)
X-FDA: 84460627902.24.A18B221
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3224710000E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:07:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1GqSZMP;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771492050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncT3gy+qlXaIOq73UkviwDRTecwGifzxwmGomu0Vs3o=;
	b=afsPuFbjs0xydUTsOXS60ijcIz3NXWL3zj8Zb+9SW9dVtlLZ1YbgofVCvxzNEDs9vT+/Ay
	Njlz3qPxZMz5H7lssvRqoIN7opFt9dTjdizCNLxulGJ56dxVCCBEuY26nNgQ4doALHoOPQ
	V1AdQ4vne6dhXuqf9O1IMRcvkzsEq8Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1GqSZMP;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771492050; a=rsa-sha256;
	cv=none;
	b=BAPf9bCFa+G6tIGBleTf1N+7dYJsWwOvZvr/1D1LSv+kjv+36aAr+mtdyUqZriCy/AF4CY
	CT4b45of8MUvMRjD6CwU6nSE0qkmVtdzi1tJTW0RToDXXt3u4oheh5DIBmF/UgTDejbVXm
	l1nXOyOy7sNnivGaWUhij+/o0urFeTA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 673EA60145;
	Thu, 19 Feb 2026 09:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6394AC4CEF7;
	Thu, 19 Feb 2026 09:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771492049;
	bh=xfSbSFMOR5WWZYkD/q8j+zwbninOKJZFgeYouvFQ3AE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o1GqSZMPrLBpAUuJqza5bmDUQOVrBe3F6G2X89Q+yFPp6HbKLgeegbzCQMYLF8520
	 HTrLyJ1UYcreRqV8EClqLPD+9cfzx/nWsT0/8i324e0c267AXaxKAmdh3uFk+70knL
	 4cb/AkERs8BbCeRxozLoV84DS6jgXQ/32HbrNGyG8eoDAx3g/QlCzxLrxY22CbVE3l
	 dnYW8BDqZ61K2ort8T2c1Z/luTvGXoItq8BHs+vJdnQBN4xZVSTPuZj4qFV6pCNpAr
	 BhgwMwQlSP3jDokl3tJEdZZ3oYxd5Aru3ZaR7VIQHBY6/4Afi+kbIOOCNzQjzDvAlD
	 Hv+PPrP+ihZGA==
Message-ID: <8a06e724-7def-4c61-b340-ef1b3cd8100b@kernel.org>
Date: Thu, 19 Feb 2026 10:07:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: skip migration tests if NUMA is unavailable
To: AnishMulay <anishm7030@gmail.com>, akpm@linux-foundation.org,
 shuah@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260218163941.13499-1-anishm7030@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260218163941.13499-1-anishm7030@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 3224710000E
X-Stat-Signature: sm5ipt8gxsffpbt9kebce97ihg7o91xs
X-HE-Tag: 1771492050-995278
X-HE-Meta: U2FsdGVkX1+tFTLjTlRgWlGks36H3bKs9T8eKi2Br9Swt6cjJGGgaOkyuXKZ2zfjmI3fGiH5gRZKbQKyCyHiNnPBqW/EgzKeHkYo5BlAUBh0pwA4gHXMUMbDqhv6+VDok/53Bfbu/cD7tmKWCvASE0h2sYOmzmGyXqYHxPFYgL0z/+iTuzQYc2bvwm/LhxYm5pl0UVrgEf5ZYng+vbF39p3lgPhY/93nbIhJ4+hdMrsPpSSzxKIb5wFuE9Zl86mkIxGvpcoHAiU0tJt57F/aJlQc1Xis1afsSWtOUBZ2rF+UwAYbWNEUC05Cxi0HrL/xY525lzp61vfHvQljsKDBUM5qpvlRtuNQ6wkCxKeWy+HjagI6Bpgdl06mEdk+mEY4V2bvZW55QyesJVhdJia2WtjYYhZsFiIXyTV8rNw/L8/eKjN2oJ40va/YVNiDx2KG9Wxa0IGrFmQY6hWVhmF5kOCF8Hxtmq8KW+eKSccKgYtXqPOysKBlEiM3IQjeyNB2FCxDa4uUNPQEmwi1T786GHfQemZZyHqfofZaWsbLYwzEEPsL1z/Z7mXUJtLgAWTDpCN/W4nrKNnFn75FBok2dyp+ygq1Sz9o47yuyJROM17RA/9MegPX6Cc7SgtmAFz4XTYey9ZwGVXU0xBCqdPMFhOwh3esCrdjkTVu/D13pDvEI3ONBlNEpPUOwfnttU2C5rRp2ayXl0X54PCKTHS/5u/wHMx7t4K2zAfKh5gADdVdcJDSi4ki9PFNyozljJO2mvX8Q5XUzbAYwbPCMQujACimvXjsF7avcPGW2BnbCLXgBnkE/lAA5X6Pb4j+6Ksjjvoaobg6zI7z3TeOgSo3eoRyaYGaSL4Gag5kKAOrksncpCMiBdFDt9zOu7FwIESmqZoH8Dv2fl5LtBeief9sdqBLaRLYbVc37EWPtbT8RsCqqfBbmGhlaP+FlOs4wWLGLwElQ433gK1ffPL+Nv7
 NrnBftmw
 rPPfh9zZC1TsprezH6nhJgz69bp1nKVk5aM0RDkYK0yRFvWtTwVeixwIT3V+1ufdj5ikC0HR2bXmU1cKfHePb9XaKW2fScnUJ5nSS3E088cR+Zg81NldiGV11PDEUCCeHR+fxKWQmp/ycHkjJmW/zIgA3VmF8O98L9mapCNi+sb1ZObZbxtjiCinR5Cea4yHtAIAjne7rQmv1hbKVGGeiVLj3RFgujW9XgRl5iq5mf5c9HZmmqqBSB4mYZK8hBX8572oqXg4Zc5EllL8S1Wx5lhalkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 17:39, AnishMulay wrote:
> Currently, the migration test asserts that numa_available() returns 0.
> On systems where NUMA is not available (returning -1), such as certain
> ARM64 configurations or single-node systems, this assertion fails and
> crashes the test.

Single-node system (my notebook)

$ ./migration
TAP version 13
1..6
# Starting 6 tests from 1 test cases.
#  RUN           migration.private_anon ...
#      SKIP      Not enough threads or NUMA nodes available
#            OK  migration.private_anon
ok 1 migration.private_anon # SKIP Not enough threads or NUMA nodes 
available
#  RUN           migration.shared_anon ...
#      SKIP      Not enough threads or NUMA nodes available
#            OK  migration.shared_anon
ok 2 migration.shared_anon # SKIP Not enough threads or NUMA nodes available
#  RUN           migration.private_anon_thp ...
#      SKIP      Not enough threads or NUMA nodes available
#            OK  migration.private_anon_thp
ok 3 migration.private_anon_thp # SKIP Not enough threads or NUMA nodes 
available
#  RUN           migration.shared_anon_thp ...
#      SKIP      Not enough threads or NUMA nodes available
#            OK  migration.shared_anon_thp
ok 4 migration.shared_anon_thp # SKIP Not enough threads or NUMA nodes 
available
#  RUN           migration.private_anon_htlb ...
#      SKIP      Not enough threads or NUMA nodes available
#            OK  migration.private_anon_htlb
ok 5 migration.private_anon_htlb # SKIP Not enough threads or NUMA nodes 
available
#  RUN           migration.shared_anon_htlb ...
#      SKIP      Not enough threads or NUMA nodes available
#            OK  migration.shared_anon_htlb
ok 6 migration.shared_anon_htlb # SKIP Not enough threads or NUMA nodes 
available
# PASSED: 6 / 6 tests passed.
# 6 skipped test(s) detected. Consider enabling relevant config options 
to improve coverage.
# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:6 error:0


What numa_available() really checks is if the kernel supports NUMA by 
trying get_mempolicy(). If that fails with ENOSYS or EPERM.

That should mostly (cases we care about) be the case if the kernel is 
compiled without CONFIG_NUMA.

So a better description here would be "On kernels without CONFIG_NUMA, 
this assertion ..."

Given that tools/testing/selftests/mm/config does not include 
CONFIG_NUMA, I think we want to add here

Fixes: 0c2d08728470b ("mm: add selftests for migration entries")

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

