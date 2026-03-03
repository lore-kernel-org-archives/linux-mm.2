Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D15E67A9E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4AB6B00AE; Tue,  3 Mar 2026 09:59:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C3B6B00B8; Tue,  3 Mar 2026 09:59:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C58D6B00B9; Tue,  3 Mar 2026 09:59:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA5E6B00AE
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:59:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05124B73B3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:59:20 +0000 (UTC)
X-FDA: 84505060122.11.9489961
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5063F1C000F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:59:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5DORz8N;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772549959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/0gqR3NbBrc/domse1izSa8zbcmxDtarJwLLaAhY44=;
	b=disM8W/IUeAlwplGOLXWEh/SpEP3AtBN2F0HHfHqp5onO3c63njPKoMGQpMf/gT6NtK+jK
	bUIyc3cmNPRgzZNyS6wURoaP7OavO3/fvvjpGI2mAsAOBCb/XWmXlQMVzAfMob25XIwrH3
	AlbGXi5VWd7K3sPAfDMomIEae5g+K1U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5DORz8N;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772549959; a=rsa-sha256;
	cv=none;
	b=6JNYQbIgpmb78sjYwv+Ttm0al86cIZCS2WIKMkoFIRQ5Ed+dju1yICD7e0cPy85qPf9NDx
	tgjXVwzOCjjefhG0YHj3lY3jyOXhyNa4j4DOck74m3iCJLzCI+mEWg6I77cBD2jxLLNqWD
	Oxx2hVVQHrFF4AQN5BqZHTI09MydHJQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A01B1600AE;
	Tue,  3 Mar 2026 14:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83C1C19422;
	Tue,  3 Mar 2026 14:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772549958;
	bh=xrDoBLkBEaX21ErvzFBZLUETCPovsLfcVA0ts8/6Izc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V5DORz8NEJZmIQUTGn+8RxHixCNUsali4vBslV0zsDrQAQtO7SZzO68QIAN7AvoVK
	 miQeIRzzTc+Yn/S/NEdq6EdKxyZ/HgaRgKmja/waUOv9VowIKIhVZbQHXG4TATdCXu
	 fflKX/Mm6F+QjU39KBg2Od8YLcG2CHwnUD13gH9ANe0nJykimyC+hz9GTbjk51PcDv
	 jshOAEpvEyks3jNyej47eMgr6kA0czyzlNTGhrKdFFYYk3FiWjbni8W1VEq+EiTsc7
	 NWMADvhdVSP+WzfFGxeBPla1TH6BCDAhBXCKOxAA5NhKuy09QAIRlaM9OmcBsIXWrM
	 TwUsBTtaTVw8Q==
Message-ID: <849233d2-9d40-4d67-965d-262153d15d07@kernel.org>
Date: Tue, 3 Mar 2026 15:59:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] mm/page_reporting: change page_reporting_order to
 PAGE_REPORTING_ORDER_UNSPECIFIED
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>, mst@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 linux-mm@kvack.org
References: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260303113032.3008371-6-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260303113032.3008371-6-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ct5tsxoobkuhyro956n4m6pghetgyazn
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5063F1C000F
X-HE-Tag: 1772549959-141611
X-HE-Meta: U2FsdGVkX1+ACH7eNcf76rhElLXXQ7hQN2ws45K+HPo2T53y3LPbp9jK5mJRZm8CgSol+UxM1IaJUqTViKmPGFWiiaZQ8FNxetITwmRsJR/Uis39esyAMTP/49TH4V+nrKT+U9VRNUoDzZXH6IZT9WqY87aBX1M1quOp+2fa6gCKNNuVgPlqEuiGgc5l8baREAivFZsDiXnP3ppllf2yIB3+se2/YCPsZAXAbVLnQoDLEC+CAgF+849I7c/fcSpB624qk1KRZDbcsQ9OOF/dM9XqP7gNvBVTUCGhH3KuTvxhOowOe5yGzaSFC+5L8yH46IS+3kAh1JniBmxv5N2QeqAm1qJT0XBUaw4Ok74Zg6vja4SMGcqSM+qI5VrZ4iuSL+HBksw/VxQjTeq5pKmTUzLf2igQJFdFZDyeYdmdXP+GuRywZ+H9OcmA8PPGjs2NgsBbcPK/T2Y54IoIW89Y064jHWZ+UdamYZ9XsFEIdq72kLXiwAbAAluPtGYUXFPgUuc+NV0mjIdsMSwP0PiS3NafqbDunnU4Yi5hzdjbnfEMl455ggqjJHIZEoVUgjqVUXq1TJamxZfKZ7uGzQ3QROvc9JNFLMGuViVb1/c9fesaHrukeBn6BDlv1iwyM4DaX1VoP2YY11Ot1z3+cb4AHlbCMgNOAlr3ksOO3mU5JZor6m935ax0eV8XrlE4RQDAfG4uPeH+xVimvgSvMZ7fTnYi9gj/crl+cmhuULhTM35NTuyGJ8csE8hOB4EGjj7Gh4Mp0D4Ph8lgmAtgIIHekqHn7f3DTH8Ge6Xa+WWNgyR72cY1vmFonZxqd7vONC6bUoiJGpfMioH+gSOIPCzypWsC0uGQRoxhHJX32U4f49HCyW6unWi0uVx+t50+vLGzm21sEd8W2hy1Rm+xLbkLQF8AU5CXfCU20+/+YAk/lv0yZiWOgAC984Re/0WyYkhtKe0PC/VB3y12oWpl4qN
 MEZds5S2
 xnYa08OZjyB5HXHbaCDi+/KNjRhxG1GsLOWdZr9iq/FCHx6vplxMa5lOyeSL+QvKxGd2iErqK8/h6TIGI+jNiOMtkfZwDT8/Pr4hvXRiYJs/OP9dohvx1ufbrtXFJLK/Jknwx5SC8+0Jbbs69lS05w/TpvZOhN31zpM6iydIUm7mn7gu4LTAa2lOdpWnth6KQmDptyvSVIlu1NoEeWfUkCm7xufbejBp/irF8RFFpyvp9/8VxZktHcljIccaG+glztyjnzQLoped9F4b24dLGM7fvpQcgnNf94IHaclW5gZXCyuydreur1tEm3iORqDSND91MXHUIlFhamWYsamXHlHqg1V1S26Yfyglq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 12:30, Yuvraj Sakshith wrote:
> page_reporting_order when uninitialised, holds a magic number -1.
> 
> Since we now maintain PAGE_REPORTING_ORDER_UNSPECIFIED as -1, which
> is also a flag, set page_reporting_order to this flag.

It's not really a flag. It's a handle for a magic value :)

> 
> Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
> ---
>  mm/page_reporting.c | 4 ++--

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

