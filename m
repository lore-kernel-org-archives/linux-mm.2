Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48228FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3406A6B0088; Thu, 30 Apr 2026 14:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317EA6B008A; Thu, 30 Apr 2026 14:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255436B008C; Thu, 30 Apr 2026 14:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1227D6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:22:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D77185E7A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:22:49 +0000 (UTC)
X-FDA: 84716043258.13.42DBD20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F96840007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:22:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2UHaV2Z1;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777573367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55577uvOVSk5c4CaLjbUALrN58lMqMmyHDHHfPsxWtc=;
	b=OUnZf8BajGlP3DR2cqZPMkqEEY1UXohr7ExQB559xXgr3/56S9TBkRiBSynq4OyKz9+dTk
	sWyGWEzWxto2dV+bu0XSbbTWhxOOvR8HxScbZpnCWYMhSSVsgg8OADl6rRPZefv+Exsmgl
	6287Gsnqbtg1I3BTJH/3Kf+4ChYmFVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777573367; a=rsa-sha256;
	cv=none;
	b=r9hyJ5gYwPmq22A6mLkP9n/0SMcxQ08FIhR/Fto7+VzCbDDjTa0MNZHXvggmz9MBCk/SF/
	Li19c+xpeDqtS1oCHNxiiKV2Zp4F/BSUnYLtwdObriDR8IjFOfxffNC2RLzkLO++zK/9n2
	LhTFKhB8d1SyhjDoayBcZFInRgzoHvw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2UHaV2Z1;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65426433BD;
	Thu, 30 Apr 2026 18:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7513C2BCB3;
	Thu, 30 Apr 2026 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777573366;
	bh=PrtEN7qXDvun2GKuTX6drcFhgJ/WEonnKxBUogYiMOw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2UHaV2Z10+hRSqPf8sRMKcLk3psL89le0ELSb82AjOxpHAG4T5mitZMfhIV7PECOQ
	 fsX9KxEYTtg11K45dDz9uuzgV4kAOrR/yPlN2rxrTD7cOtiBMT8o5acTkg8PIglQqo
	 A+svBiZZfi0jJ6/xQFbxbtn+6UgnnrspPgG9qqdc=
Date: Thu, 30 Apr 2026 11:22:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
Message-Id: <20260430112245.be3189f09bd6a71970a74746@linux-foundation.org>
In-Reply-To: <20260430163247.13628-1-zhen.ni@easystack.cn>
References: <20260430163247.13628-1-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F96840007
X-Rspamd-Server: rspam04
X-Stat-Signature: n7zbbdeep5yo7j1q41hfjkw41juwarzk
X-HE-Tag: 1777573367-528447
X-HE-Meta: U2FsdGVkX199NScLBsHQ3jKKmo1Pjv6d/vhoReCoGS3nTFuGXgVwW77QUYOMB3y1IeQbs3V4CwSRKiZ0QkT5+A6SvaGQ3Z6CNkQpfT+McNGBahLghHtbNfQUe4UMxej78YcR25XmcDuS/IgicdF0KbAd0ve9pkhgN6CuXZz5g1JMpPG+RLHHt85hhdJ53T9iNFm4GMnQWDldil3EcBR5Zb6wxbWdbAvilvoeNEW41/SmPtl3My7q3K3x9ei5oeAC0Ilsu5vZMB+m7yYldLqT4fajvsQZpk7E9y5+f+LU6A72xiVf/c7jOSDWqlZRTuW5MI2yPBQCTlj4+IJ6SGEjnw6XR9Bf/OMb1R4Q6+aQmkIV9bfIRbPh71uqXbOIh4CMj4YfBmXTNpcrr5ntpo4Eg3flUF5xBiZtLXhHfRh8uJI9csstvOO6zJUnzKEJMaTx1PgdKNXSPaKOJITjUPrGEHojNWmUPI3O7ZtYPVW/S2kthBxG1IiqSGNPAtvJcR1ulfDWnrjd576wk+4062sDzqaxzrNgbJkm9UUSlE8nTYB8Bf/jbQbwNsOY8z8o29/hedjxVXOV1UD9fPxcKcJWearWqnciypD9NCDPspcqWzAKIOrlzihPVlhKI7zKrdVXrfyuTZEeaN7JhfLKFnVw36D9+dl2IZ4q/zjBYFcjD/sJLtQ5xS11HNdriSifLBMjycmnnD086Rl1Y5SmlFabjhwfO2n1dTZplP7tyxEiK/FrFhBkl2x6i/kD0k2eD8bmLcXUV/HXgtV5EU/Ffgn7WwPSEDARPy1HGERwk7eE2wijWFMf8H7S0DKviDOBsTW3Unc2jtUkaosiFYuEFcZ5NNBRsXbZOMuEksHTiblGKEhM3SNvmURHiW6tgELds85i9efGI7Vb5MvQdW6rD0QAIajkAHb9QdZSXVOUhfZL8fTN5Epf6GEXVU1rJ3He3KThxk1NccU+b4x8umAnKrx
 uv3iNyOY
 n33nLkFO02HXwhtTrEI6Y+Ii48l3ILiesWvpSTJcnXBoRZxqDEcLr0zbjUWnBqEMKcDxL2iIzKAs+Rcs26LuMBEVkRXGjSdCj4A/MT4YyGNvM1dBMq7cHRgh4n84LNDogbkanulJNHgjs778WJ6LwvmD2CWUfylbASA/uZXcqDMlmO6t/2sa8i+Zh76/LSJPslHBExocMGZrY7ZkmsBqOJP/BINrrZ8PmbWHh4d1YE/Po4O+Mfx3/c4i+Z6+g8+ehxQM2L0TdBtCRWlyldypur3WLVU7jKGt2cb+yXHTeWrQpHWai9c8cZI82hesABI90kFziuqHO7OiukAL0iYn7T7iowU0njXwI5hNx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  1 May 2026 00:32:44 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> This patch series introduces filtering capabilities to the page_owner
> feature to address storage and performance challenges in production
> environments.

AI review asks a couple of reasonable-sounding questions:
	https://sashiko.dev/#/patchset/20260430163247.13628-1-zhen.ni@easystack.cn

