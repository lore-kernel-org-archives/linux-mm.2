Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC7AF99C89
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 17:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19596B02DB; Sat, 18 Apr 2026 13:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA196B02DC; Sat, 18 Apr 2026 13:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0406B02DD; Sat, 18 Apr 2026 13:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FB636B02DB
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 13:18:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3FAB01B8189
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 17:18:18 +0000 (UTC)
X-FDA: 84672335076.18.7E684CE
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6A83640004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 17:18:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O+uW6xy0;
	spf=pass (imf07.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776532696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Ow+4rd4tgyupvcLrfZUEZ0Ce/0V3cb2OAK1mKbRVJY=;
	b=ywzTcIoGA61ZSIHnIcuSIBLiLfhkPRS7SE8+OomCCYEKQjNDL/pq9lFQEgVlVqdZGuIrfg
	wz4fZbXNeqax1PY0OuXWvxYpGpX7mFMGEjk7udXMfJ7jxdZ9mrgMzNVDsXNz9DzJ3S4MNO
	28hq/GH1Vn5U1AZTIA2hSmpafcHjPOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776532696; a=rsa-sha256;
	cv=none;
	b=4vvIwPOFUVK1apAu2HwZBxGYwx1lte/+drNJ3za4RlwrCr+ptV/lQw9JV00kE86nnVEc0N
	VhGOBLi2QjvKRiOHKak6CG7ubueEHxlJOgeWmo/X7b0dkEgEBq9ePz3wQMgDn3Eevb/T6k
	dL0gXPWSq6O2LULMDHJLieEanLcgGBY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O+uW6xy0;
	spf=pass (imf07.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82418b0178cso954563b3a.1
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776532695; x=1777137495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Ow+4rd4tgyupvcLrfZUEZ0Ce/0V3cb2OAK1mKbRVJY=;
        b=O+uW6xy0z7vM2K3bZ89QwcKH4Lw3R/Cd1Qj88/jZe2+w0X2V4ffzmvS1yLIqTWTcyC
         7cW15V3OyUkYmqYWbguRYI3Cida0WsrKs/+I1jf9igEnLbXSp1LKr26LQc1Hs+dR6UfN
         AtIs1Aw+7PxFlFSL7L6rlWQB4xkmzRalUB9IFaljIvn/xAJ9j+WtGsQBSj7hsxrNtAD1
         5cwDilc7gcDM1OMyq9+sfdctXmaSMyE4cWIYwesOWrEkq7oefZ8cGvAVfkJyPiWxMgj0
         udTQ53/LGz1RZeVRJRnYedVEHFlv8/1Q6MkWRGYuXiR4o/l3/Z0uNIiwf82+lVDHBiSW
         iUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776532695; x=1777137495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Ow+4rd4tgyupvcLrfZUEZ0Ce/0V3cb2OAK1mKbRVJY=;
        b=SDVpYi6m+RxQ4QWWYEDglGy+HWOweS/usaGQ8/lnZaLSL6j9Ifpz5Dz2K2zzZAL5PR
         IH96fw0S9erNNHD2Fw5PGf3+swwqUQJHzDKsx0Q/RAKCJPi+8MrBUPJX5hO01BV7ODi4
         P4AK4T3CVhyVJvko2M88WdN9J4KFdBvgSMAT/gzypyFICARSPSPB1hX1SCyu3EbQoL8+
         u26wgqDcm20NqmDzfRaEAOsx1H62xEJSFeidxLjBy9khEwpkdEQbMzXmuVh8D4667iZ5
         +6drwK8UrPTwAMTAwvKB592y67DbrAdjzWWiorCW5emDTPq4zFEyBFY3Y8WYVSVpIlOd
         IzMQ==
X-Forwarded-Encrypted: i=1; AFNElJ/X/OzHAeYuN2V7zCeQk4KkfILCahajrMHP9L8i3ic23Sk5HQq7bV0cNuhMSVrGezvOfMwb2kq+PA==@kvack.org
X-Gm-Message-State: AOJu0YzDY8+Us3dHQT+XCMyeamugwJKjCbWv4ecoXThz4X85mLMODPza
	b0B0xDlrDaGq63Hr1gBakJMbOBqgE61vqBh5V9YqmkBRrm2ie5As4avj
X-Gm-Gg: AeBDiet5Vcif1VXQPNj9dquuXlO/wU4ieAdQdbTGuhVGwZu1YcQCITzU4O+WVTW0z8w
	1Ru9Obvmc2knKxZA2iTrCfWNjDofPNSMY7DbeQcscyg9iAa2ZOHoCAvB8+F5gYNCPe7kUdsfJ/X
	rCFFBGe2ClbNTDmIRJ01T7T8nV4FHA1VEKdjHrrtqvN2Wvum1COVlFmK5ek7InnQSqJxRkb2tfM
	PExy8x+QuU35e5OxbWnZ3Em017HRI8qgBt53rb1NzEMJfEfbJLixLT5Jik809pOWuoxcQP8qKwQ
	MgLXZwVsAkn4pprSZcGpBcdkyeQ1X7XYLhtkPRkVyXEKrUFW93tTZL0q4e8j2ubVX5XxphWJmuL
	b3zL8gOTUF/VA3QMa572Vu0ciALdSWsHZr6sS4Dyi/RR1QNYqyqXigDI2S/VyMTkM+D6+JwB1lv
	SnJoQ+ciC/BmHtiZyjgw0HkLs5HLuTEXBmA/NkrAxaHwQ1HfrgT+CiylFd
X-Received: by 2002:a05:6a00:22c5:b0:81c:8d47:33ff with SMTP id d2e1a72fcca58-82f8c92d36fmr7813197b3a.47.1776532695193;
        Sat, 18 Apr 2026 10:18:15 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.16.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebcc9easm7211169b3a.39.2026.04.18.10.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 10:18:14 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	apopple@nvidia.com,
	byungchul@sk.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	nueralspacetech@gmail.com,
	rakie.kim@sk.com,
	sj@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Sat, 18 Apr 2026 22:48:06 +0530
Message-ID: <20260418171806.11615-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <82193ab8-e6f6-4664-8b4f-e30d280d8b1c@kernel.org>
References: <82193ab8-e6f6-4664-8b4f-e30d280d8b1c@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ma13jwzpjf1aco5y4jhihmrkjjabon3h
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A83640004
X-Rspamd-Server: rspam05
X-HE-Tag: 1776532696-313754
X-HE-Meta: U2FsdGVkX1/KMgWfF1/m0btVRQvA5Q3NuQwA843lb5yWCGfvv1J/oBuFajG28t6+0xPi8cjOBAYFfFzaGWopjQc7jylTi2ZrUw1hDMWMDYHv2FU/X2naqM0ODmlopMqfqaV/uvvVygiwVrPhxXuYcUMOfLlQmXwLGhexQjw/mrzmmnS2fh/waCGpz0MO/1uxZOjeJUbiJgwESxJvoDvycfchS9V5oI9ECGT+2mmKfWVB0qVlNCKgEta24LhVBneekGP/jGRYqPfPkJoMUR3O0glO5WI7Xr3uq7Szv5PS46cEwgH2EwYJqKmbAQDDyIWL9jbQHHyiCivGuznICnh43kcNloRXWcsEUCRR7kKmbKMR7e8UdmCfK1dxK58uPDBOaSzGTT7jwMuOPyvj5TBd2hpRAMOy8mllCgeJ9D1UP8p0K5obR5AkA0BjaToUJdEKVCvv4Z2egQRCWusTaR8hifUyegceH1lBosDBLdjbmdpk5M9wjes150OYKY3xbxn+iY2+Mi2/3+oNz7kPUmFOBAai5La5fb24oKaMegfhth3+MpV5Rqv+7p02/OfiL5r5Z6IEyz4HNeljCsige8Oj54RTN4wi/VEqZb9ieuw9ao2bsNlbOj374zDMnXqMzU1X6vhvlXbD99lxVnbgeOxByybZ/EhkFIavc1etrJhctJbzf3j0cefVwc3+damWVy2wfgDAYAtW7R4QR1rDxOP3bD6f0dDNnnMM+0JBWSSNZd6QiNu3Ru2yU18hM5pPgDQeugRkQTlVqc59gebQP0Zwj0qjCuHEoqSsK29DkXlrnRwafqyjQvxE68EzbfcM/SNNJNji0SYk5G8KnUTJH1rXN7N7SzbdwwXYV3J1wvS+SPh0SHt5Y2272WY4UUly1DHzuW+6sbMIBZ4miTplX7EWjfNwRZXO/NhbbQJLjdtBwECO7T5y9BE77/EhLu3wbVukGhVfTCsF63E0nDfjjF4
 yW2ptdeY
 w9vUUFATrx6kM1Fg8Y4YDYrrCpAzX/N3J8NHEi+sYAvG2kC1jJC/OlHmCqLX2PfCF1bWjsJo7oO/Y3l969ALqrKQiB0AUeYU3UO+zCzW7bnMjmF4XGKaBn8QvdQbuW4/7N0ODXREOcGWJ7PMXKQJzd4nxXtzOnIf/GEUMOuyVvys8761UA1BynKNGO7GhxcqpUV5jrxb0r0gkIgzjJ3dCkzcRD7d8aIiPLQoaiCcY9x2SZrEBlgzCn77Bx4kCUfkjNoiuVfK4c3dJgU2FDVQRGYwhZxSfNqdz8Uu4q46Iby2zcV+JeuujHwJkPTjUQ/PgEVrNC3ZlDz7mN+rnXFTCuq9c2RejKzpS47b7U4Jyo9+SYPOxJ5hZYKCaRhFp6V9i+3ZRlVVZnlbJglFPZxJHOEgdHVsS2YN4rMx2kmVJ94wNDDmV2g5SQGya9EmsxMHv+ZUJJKTurQsYbLNnpH5Rg19JHO25D+3havbtFUGS88U6Q4pnKtFW6J4fk4H8Jc0u2bpA0J+tam6atmJwNh2NDAB4X2WcU5axqP0ibOvMgycPBToQZca5oN04IKZnN0/H34cBAI5mbn7lwBlxtt6H3W5LZ7d7MGkLBsUbNRjBK3lP1Zax9guVn1bBYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 01:52, SeongJae Park wrote:
> On Thu, 16 Apr 2026 21:44:15 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 4/14/26 16:13, Sunny Patel wrote:
> [...]
>>> @@ -865,12 +864,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>  	if (userfaultfd_missing(vma))
>>>  		goto unlock_abort;
>>>  
>>> -	if (!pmd_none(*pmdp)) {
>>> +	if (pmd_present(*pmdp)) {
>>>  		if (!is_huge_zero_pmd(*pmdp))
>>>  			goto unlock_abort;
>>>  		flush = true;
>>> -	} else if (!pmd_none(*pmdp))
>>> +	} else if (!pmd_none(*pmdp)) {
>>>  		goto unlock_abort;
>>> +	}
>>>  
>>>  	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>>>  	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
>>
>> is_huge_zero_pmd() checks pmd_present(), so we didn't have a bug before.
>>
>> We could also do:
>>
>> if (is_huge_zero_pmd(*pmdp)) {
>> 	flush = true;
>> } else if (!pmd_none(*pmdp)) {
>> 	goto unlock_abort;
>> }
> 
> Then we could even further remove the braces and reduce one more line, nice!

is_huge_zero_pmd() didn't check for pmd_present as of now as per the current implementation of it so additional check require for pmd_present(). 
Please let me know if anything needs to add in here.

Thanks,
Sunny Patel

