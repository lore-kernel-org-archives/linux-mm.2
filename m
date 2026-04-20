Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 821F5F5A8AA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 19:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54536B0088; Mon, 20 Apr 2026 15:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E055A6B0089; Mon, 20 Apr 2026 15:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1AE46B008A; Mon, 20 Apr 2026 15:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2F766B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:03:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28A731409C8
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:03:12 +0000 (UTC)
X-FDA: 84679857024.08.214B561
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 628AB40012
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:03:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UTxb0bxf;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776711790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZXTmsrU0/pJ1tebX4gelHJDs4GiWytOzVRnEm7LrNQ=;
	b=ENQuDSX6AbOAnlqoK5oPTQ3DAthhy9J9GC8mOnEHJdwNOcD2PtTfYI7c9NjZe4sNFSsg18
	Ipql8lVC5N2iSCpHMK5eH6u03NHhuRDgOkev41TCApZmzaHSqtcmVqTUp64+JcxeA9V2G0
	FSzrDo2tSyFpo3VAmP0FLS2iTncqaJ0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UTxb0bxf;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776711790; a=rsa-sha256;
	cv=none;
	b=JRzlVXVJMJ1ZxuSmBBwdfzEoMpoNnu8D0igN63xJILVLRjvSOpOAU/ePrOgKoLBcwTweKw
	5ThpoOOZQFLU4/oAZrPFf0BzTNUCM7dhVNsfBFMyTVzBXwPLekg2zBRLEVNO1QoW1E/FPJ
	A4nkGkZsf+4cwnG1UeQvoog3hMSB3Sw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB50D600AD;
	Mon, 20 Apr 2026 19:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE27C19425;
	Mon, 20 Apr 2026 19:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776711789;
	bh=HCf8DsqrqtUoC3kEuRnRvbL+Njp65zOlbz2OuhLRP1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UTxb0bxf0p9SPGEz9c3QpVnszUtxBZp8b1Ewfcg5N9lAntzEIcDLXzN7AJts++4yy
	 T4Zqs912LANKgvHFYt2K2Cp4dmiB4jWbjLdg2CP3iSJMLvosJc2dpCsUTqIbCW3Ap8
	 SykFg4rNgwuL9fA3KwKuxGeiGJNOc6wcS2DR3dpCp7+2mphDlupSbw2QXo4NOZ7qCM
	 3V4MIhpkKrYSNDNKlHKq0DZHZB4HVyf0HInlsg8aTte2nZyh+ePBBs1sHMbcihbUBO
	 YTLzFYBgoE63K/l55t22vG6PY6Xvso7AMEPv1bY9x3voVlYzYkt8EWuwmxHUkYkbox
	 tqGCfkEPFY+eQ==
Message-ID: <5bebc75d-19e7-4d06-a5c1-d3f0bb5f4e05@kernel.org>
Date: Mon, 20 Apr 2026 21:03:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] mm: make sure freeram is smaller than totalram
To: Yang Yingliang <yangyingliang@huawei.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, hucool.lihua@huawei.com
References: <20260413115736.1237680-1-yangyingliang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413115736.1237680-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 628AB40012
X-Stat-Signature: fehd9iicrmtonrq99ymrgncfsowg61po
X-Rspam-User: 
X-HE-Tag: 1776711790-719114
X-HE-Meta: U2FsdGVkX19+BM3OoAyki4fuy55qdOjKi++kJDN87D9eh3IygabshzyzCR5Bg54FANF1u/kP6j/y55yELJE0uiGbQdG6/1L8v+vXb6S3SwP1Fyz+gcukmqHDAZTt+JUXDqPbz7o/pM1HMx/hMNHEI2HTV1YLMGAD7o0SK1NxcB+ownuetk+OPSgMs/uHJ8e37fRksK1fUFdpHr3vJz0LhGrHZCA8yHjS+r0Ij+I8znyCg3ICiu1yDdHia09XEKliplDKXFcwBMJ0jPyPqXlfoGVfS8K0/LvCXZI10oZ1SUzlAmJJjDW1pY7RosG5OpdI54qzWvNKHSuvPsV3u51Iln8Ikc1G8yRmot7H8Z5ITeNH+qNcKWpP0xLaCSSJr53cERihLizhryo7Y2ha14L5rPllt3+a6V30nS4nrCQlSNdWSSW+L1u9Tk4yKzIljpI26odyJiRSP04XxAfdf97+g675cdlKFOel64L90zmHX+8zdhf8OyEEtgxmJN+oyFvq0W/U+gO0FNLB11zlpPPEARdVFDP2Is2rYmJ+U6CutAe3/CBluQ+4E0PC0U7mFT8HME77nbjMlnfRhgfx9JSagXEXLVJdjjm/VcpxkfmPXrHiTTT1pJksof19G0aNdL72SX9dHJ3xzL6BIhsbuttI1zNBur6CKWi+fmHRB0e7lIYh1OidO8ct+WJsuZ594hOFv+TsY9O5s7Sr1eqTjFEkKjLNb9h39qXFwLgY5McoHuLgL02UKzaY2dsJR4JgCaKeVAgifwwKEmmxJ3bbiBDOraAenzYJhhFvLaQ2AGROe5+6XutK90pIRdCTAYXN/1YCEU6PAWamvdZ0tTphSUMNqmyX6RGBgno2O52pwA/k4oJCNSoHOAAvF+V2hVJ3Eg1Y2N4Aq2HGjTzKdESU3xKgLGHsTZDfckOZVHLewiEN9BywAo3M5rLdGo/mHgZsXbTYqxHIJHr61miMv2B67Y4
 8m4LEkqe
 ZIKanRWpRouqOSCI6Knv7QGX8gYCIl2ByEtAmfS2J54++ixKs9ZRjHUOLT0ce5LHUDOn0R+RzEfxxUjRVeYE5aq+8Fe+RARjnLP5gv7aC+sGSv1tIrtqbuUANps8OSUMOEEdXGXd8tiu/j1i//s5cqBkLWqqGxfSKeCCYiEh9HV3sm9lMbGDYXNMoKIV27kaS4OaQwMDxvrflsTeU4iR/+EcDyfBDp46itN6cK+P+nVBvHj51ObhhhyZHhlyqd1Sg229h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 13:57, Yang Yingliang wrote:
> The memory stat is not done in real time, it have some gap with
> real value. In CPU-less NUMA node, the values of MemTotal and
> MemFree can be nearly equal, the gap may cause MemFree bigger
> than MemTotal, it leads MemUsed is negative which print as a large
> positive number.

How does this interact with CPU-less NUMA node? Some concurrent memory
hotunplug, or how could be possible get MemFree that is larger than
MemTotal?

> 
> cat /sys/devices/system/node/node17/meminfo
> Node 17 MemTotal:        4194304 kB
> Node 17 MemFree:         4195552 kB
> Node 17 MemUsed:        18446744073709550368 kB
> Node 17 Active:               52 kB
> Node 17 Inactive:            320 kB
> Node 17 Active(anon):          0 kB
> Node 17 Inactive(anon):        0 kB
> Node 17 Active(file):         52 kB
> Node 17 Inactive(file):      320 kB
> Node 17 Unevictable:           0 kB
> Node 17 Mlocked:               0 kB
> Node 17 Dirty:                 0 kB
> Node 17 Writeback:             0 kB
> Node 17 FilePages:           372 kB
> Node 17 Mapped:              320 kB
> Node 17 AnonPages:             0 kB
> Node 17 Shmem:                 0 kB
> Node 17 KernelStack:           0 kB
> Node 17 PageTables:            0 kB
> Node 17 NFS_Unstable:          0 kB
> Node 17 Bounce:                0 kB
> Node 17 WritebackTmp:          0 kB
> Node 17 KReclaimable:          0 kB
> Node 17 Slab:                  0 kB
> Node 17 SReclaimable:          0 kB
> Node 17 SUnreclaim:            0 kB
> Node 17 AnonHugePages:     79872 kB
> Node 17 ShmemHugePages:        0 kB
> Node 17 ShmemPmdMapped:        0 kB
> Node 17 FileHugePages:        0 kB
> Node 17 FilePmdMapped:        0 kB
> Node 17 HugePages_Total:     0
> Node 17 HugePages_Free:      0
> Node 17 HugePages_Surp:      0
> 
> To avoid this exception by refreshing vm_stat, when MemFree
> is bigger than MemTotal.
> 

-- 
Cheers,

David

