Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB5EFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 17:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450C16B0088; Thu, 30 Apr 2026 13:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401A26B008A; Thu, 30 Apr 2026 13:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317776B008C; Thu, 30 Apr 2026 13:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23DDF6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:04:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD3E91A034F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:59:43 +0000 (UTC)
X-FDA: 84715833846.05.4CFAFC9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0DB6CA0007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:59:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hpAzXkwx;
	spf=pass (imf25.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777568381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCAU7vqnWl7Uv9GCAHpaoq3byGTpicVO/Y19yw9xg38=;
	b=HZL83MrpBB+WL4Hx8wL2I+/i7SLDnQZ7mFLJDxjUm7V85JtTK5R7hVdleNHtq3bDaYY7q/
	2W/G17h30UMZCPq+iFtSRhVRwExOK8W4VB/SUS3n00sQrEyR9fb1HFh5nxX3EqSxZvUnbk
	L3qs9Rv+UO5XR8WyartLymM3a4CSmnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777568381; a=rsa-sha256;
	cv=none;
	b=uPuXqoWGFXw83JdTirqSpJ21txzv43emDwAsbv/X6p8vsDTsQNKyDt9Odq6vF155ldQvz/
	Zb+elQBMHw/aousCLGSsHuIpQzJfZlLCRTg2qAj7JI6G4NYgNCbwAMBRIJVjZGs9AWj3yq
	MAR3l9I2RKWfM5mbNFz7RNZ88yzNFWU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hpAzXkwx;
	spf=pass (imf25.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777568381; x=1809104381;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lal5krxYRhjuJ7DZ35OSP/WlDGBqbT9nvhV433fMfu4=;
  b=hpAzXkwxdCGuaG38ZSRVNRDtx2ncEtj2tqaoG9A24k4VMFkicMSLnZPh
   TWAm39yJHGnRiuNAtiHOJJfzebxexkVjdszdMVFrLEWNW65+mYUOVo5WF
   M5QI2v8HbMVAxS9K8fTX7SxsPu+7/QVWG9n7VXNi6y8HfM9tJgtSmSAFa
   DEU4dXhnlg37GShfL64z6Ad0DQBvqY4Xy/JXFIhXfvw6rcMSDg4ucRfJU
   tDmWSurkzM0xk93NF783bfnX9/uilN1v/1IqmGXP9+561ou6+RrgA+qG2
   +z5d33OwmhfO0JRTBvZ8rQZ4zXFb23AhAoPHNik3pc9F3ZyjUrD+zveNB
   Q==;
X-CSE-ConnectionGUID: w8ZsnNHdSROzLXYqJBP/vw==
X-CSE-MsgGUID: S2DthmmZTmCTIJUxoOrf+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="96095331"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="96095331"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:59:39 -0700
X-CSE-ConnectionGUID: KIoQFjQPTPCjaeQ0Umg92w==
X-CSE-MsgGUID: Mgd8RrCESZGFaKxPHOOErw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="238958199"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.109.74]) ([10.125.109.74])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:59:39 -0700
Message-ID: <202886a1-a433-4bcf-9d86-41e8ef6396c8@intel.com>
Date: Thu, 30 Apr 2026 09:59:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: mm: Make per-VMA locks available in all builds
To: syzbot ci <syzbot+ci0a2fe26d19deda39@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, dave.hansen@linux.intel.com,
 liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, shakeel.butt@linux.dev, surenb@google.com, vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <69f30b06.170a0220.3c4978.0018.GAE@google.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <69f30b06.170a0220.3c4978.0018.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0DB6CA0007
X-Stat-Signature: xw7cz69h3sgzome1dazzxazy8o1a4tug
X-Rspam-User: 
X-HE-Tag: 1777568380-355791
X-HE-Meta: U2FsdGVkX18Z67HjYgaSMJpvvVr2xXLn6KQEZR9LE8bTn+IfEtqunLxnL5OjZkq/fzjGQG5XRH/U08/JG58t3a2ivkGP6EteK113Flr4makSBsjoswm5GFzvezF7jkf7a10NhlF9FHMOo1bHwtlO0dXCzzKl4cWeg1RT8C3xGmxMHh2tVJx9OJqS9iQb0XvoydEWxSmWv4pPEdU6LNWy+C25cvC4+nmuf1CxjIclQ+s67kkt630T4eJkextWU7LNQ/8xnRsGlz2UIbTkP0pMijk+v1dTK6SAxqf9VtfwLmFAMdOFTsxt6nkEJtOOr8SZY+4pixvkadIrGJ3VBsiv9mbQL6tENp3faaBpEu9xNFidBBbvxZ87Nzyv0GzUU9kvMpyiIs3ABy2Wf7WWB1pf/87mVnjT836c9T1XyzJg/WXAru++0n0CK1+7JGlYAfZprXndkKtjLYC5BegPdo8ce3PCuovJy1EV4Cv8JhbE2t1IR1Eq3TptB1Tt+gqavN2bmBKcOtmS8O9hBjqnk9QlVShx+uYr1n8cXDh2s2ObYZrKuBnL7tdkT/zvgGv8U7ZzH9s0WYDe9M/Vmywor/94gtDOGjMQybsIzElgBBoesdLqSlbSaIwE+MZq2SG5rc9/1JLRNHFVceNkSpCgzZWVxBbhpUTDyWM9ULwz9U/1j/wDomJjcQT3fspkRhyVtI/+2DCzzRZkjlXoqVWV0JiwJMZpVsDocs8dzZfx4oiI2MAIfX07++7hhsQkwow07atxmH38hxy53cQRa2du8pZ+NExhUYlL85gIxv5VIFKznrhAvNkAHmAFhlw7FmKFsstia1aV1gXqhY7dcYw3xDOAByqRAeophUzEX2STiuRVAUtYV+2qZOnKe/6QEROb3jdErM0ywPNBvXRsZQKx5yxavDbDmEG8DhnVADgjgmmV590NJEyZ/3y6zGw3nB356FRY6o9dLwnAFpO1XH5LFY2
 avLwV5KF
 uzwQjV9rlCm6djC4t3oBwb8rLnykt8KLy2wpjqw2nPTge8PJ2eUtya2JF3tzyF5GJDUJsxdQa986ftaa0Q1GhOR3h8sYAHcgICWod3QW61T/eaH8F2eq4T/qkQFh4Q6Q1s+oPFxGcY3WcaSQNDFKCRUSonX/9TR+t9ZjOxvwGfp8P7UZbgUC58Qf60KyLqeZe6QWWTUQ3TvBZ28NmDLNfwGlwa5EnJtezULEKsSo6bd+FIQz8D+MgbBJdK6L3+LTxu/WIU9IsCGDARfq/96jSBcBQ/7xzhMZAke0lJqXjU4EwYmNsOpIU3Ds3SedFJ01A9Kn/bnz8ghOPJ2iyE4py9/7pUObcp3TJg30/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 00:55, syzbot ci wrote:
> and found the following issue:
> WARNING in mbind_range
> 
> Full report is available here:
> https://ci.syzbot.org/series/374f338e-4b3b-4645-871c-78964f944bbd
> 
> ***
> 
> WARNING in mbind_range

I left a whole bunch of #ifdef CONFIG_PER_VMA_LOCK cruft around in v1. I
suspect some of the debugging code ended up in a weird state in a config
that I didn't test.

I'll try to reproduce this splat, though. It looks straightforward enough.

