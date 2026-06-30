Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B82C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCB16B00DE; Tue, 30 Jun 2026 07:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE106B00DF; Tue, 30 Jun 2026 07:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4BD6B00E0; Tue, 30 Jun 2026 07:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78BCE6B00DE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:21:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 063F91C6CF8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:21:30 +0000 (UTC)
X-FDA: 84936338340.13.B5BCCDE
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf25.hostedemail.com (Postfix) with ESMTP id F045BA000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:21:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="aR/nJSKg";
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782818488;
	b=0w4euYezVTj94Azuj+nZjwJp+CRMHyGN+cslYS5molQOw6aQUoicBErFglx9vlmkQg5mrg
	gET7fEpEygKeSRrHWc3f3qS+FzUfuW9akDKKMODLFBKr9GaFjRS2FSMwh1/P1NQUCbCDya
	tUWXGgxVIFCO0Mby9rH6XHC93T6KSFI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782818488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ljfnf+EHUqjOGTWLqk9h72HDHTyC4ixrumRdsjLJTBc=;
	b=ctWCbnA8Sd0FL4AkGUn/om5vtbujgNdq3fSAYuIbEA03B/QpxzFX3sbEEsaxZTn9XplU8n
	7zT+HAIXsysKp3AXQMIcU31KAm8JuScAmFPOOU6MsAFcMckZXmQcqJy+xjv32gR5lRXynT
	bNlZf8AdmxVuUTNftkuVrDpVU801clY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="aR/nJSKg";
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782818483; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=Ljfnf+EHUqjOGTWLqk9h72HDHTyC4ixrumRdsjLJTBc=;
	b=aR/nJSKg6aT7iE/00fjT0ILTqXx+56xHbaSPrlMX6U8iY9MNucbhFaTDZ2161ckSMH+SwHidABvSgotLPdg1FnpehivqrffSGeyGthz83nYusafe88nSRb7XtLLyHchy1GFv2KtJDtBHdHSbWSjliBcb7gPLveWELNmccyoPyew=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X6.LgeD_1782818452;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X6.LgeD_1782818452 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 30 Jun 2026 19:21:22 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,  Zi
 Yan <ziy@nvidia.com>,  Matthew Brost <matthew.brost@intel.com>,  Joshua
 Hahn <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul
 Park <byungchul@sk.com>,  Alistair Popple <apopple@nvidia.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Neha Gholkar
 <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
In-Reply-To: <akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F> (Gregory Price's
	message of "Mon, 29 Jun 2026 13:59:41 -0400")
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
	<akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
Date: Tue, 30 Jun 2026 19:20:50 +0800
Message-ID: <87h5mkz33h.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F045BA000D
X-Rspam-User: 
X-Stat-Signature: qfj96ofwxzrztbtanargckm6uef8bqom
X-HE-Tag: 1782818486-918329
X-HE-Meta: U2FsdGVkX1+CzTbYo9mX8jdYY+BUBk+d4H/o+mOMgm8grBK6UYxB229nXqQPRPZ/fqlx5m6PD9LZybDM0TqxflzZvNatl0QnAmTwe5/kJHtgfP6aDkR7N9DFB496+Uqu2qXiUwY/gZZdR5WcFTCULIA/BmA5W9yVRelXyleGfU3YVwJtNHkS+k42nomqYc9l43qlrWgoS3lIKvlodyWr3FN9jvm/i1NL+VGZ9aQaChTHuAkgO83lzUB6Am52nEacHFCuTx3ac2O4YHXG8gv9GdSNFAUTHOwc8gJfTQ3jhwGtqRBajcV+gN6O6snHXxYqp2UVCUpz50zL/4AU2jSH1ACaI29MJW+YRHfF1O8xoX7nSlLlGTWoGV0PkHF2Hmn07He5pWtNmhHntNEi3IhfZS22qqqUfglBW0RCFDsK2FL1qmc02yvezjq6pWiyENRVfwrqK8wZpDd7E1mBXJ3VYr9id1ohUpAeo4eOtpJ+XFCQLe+PV1eseyK4+2aFhsMgyL15nYBaOrLAxwl8J/yWGIYrdrm6hkHShf/ONQew37hcpIkEhvTuuR81H8qCD9Gj14xIVncR6F4pDcOAKr+f4tC+776QAMI3K1u6bwbNQdy6mn6MzkY3ZXcenw3Lg7SakW6+xeEvY0GUUaE50z+g9qLJDmcxW3nUvtBz35rmEKhhc9OPpcFtHI+xdISC8HPeVpRbE/mfQHCiVp7ZwZJpALD+K2YP8gEP38t13X9AS5O0LlvgSZZHk+tJZcLVlRnAlGWokiCBFaRyu3V5zcQeD4tLFewXu1R+yZklB32tjFNqqQgKEXAHOgiwt2p5loovAJLKeZhnV3b9XJk0m528chdXMXZ6fB2h3pqrBgGeH/Yl5LCl4Du3aXZ6uu/lRNromEkQnv56fJHyQAcg21St0F7czBhQB6BWBkQo2ZLqdUUynQZM70D6bgHHs5GfMUzcOhFT0wJ6F7OHzW6rUcr
 YLv+P6Pu
 ybISQOkL+ejEb8wu5ADw8hPjWb6mp4SF/TjyeNSNEwLbiPHoBcEOnTo+k7ZE+A9NPUvYIFPUPmbofElVmD1gaMTfr8DvYv9keHRZ3A+iT0Tmru20atQXOIYb+5iCPbD8jb7pjGG0nOkgNI95rQlrtC5weIHIEEYvJkKATK3Ha8y1vYNE2qLak4WRQLHhIoluxZFPcRnZdXSsJWT9aPWavwUcRj/yqATsQX40nYFMS+rpR/UyMn06oZOhwHd97NY+qedG2LltCjNcGg3jpws8ngrrchSC1SFlM9JDAqEroLmKJRubwWcfnI7jEC9d8or3vFSwUVYqNHWfi0E3Nn1LxU2awh4KDZTDas5cDZPJou+xabCkeM9JkBdJAGCITWUY38o2tVELKZLxFXrOuVS7l5szZdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

[snip]

> Demotions don't care about mempolicy, so opting shmem out of NUMA
> balancing and mbind'ing on a tiered system is just full sadness.
>
> This is all just more evidence that demotion needs to be completely
> redone, it's creating a mess of undefined behavior for memory placement.

It's hard to respect mempolicy during demotion in the current
implementation.  Do you have any ideas on how to improve this?

---
Best Regards,
Huang, Ying

