Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7340CCA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB0E6B0092; Fri,  9 Oct 2026 16:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6829A6B00A5; Fri,  9 Oct 2026 16:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599F16B00A6; Fri,  9 Oct 2026 16:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36BDC6B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:40:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BEC781C3B82
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:40:09 +0000 (UTC)
X-FDA: 85304254938.16.11FCE84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 28C38180003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:40:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dgcmS4l/";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791578408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wtgYPMXZXp6zUY4OHNPQsnexKANsg38h6IetxV4HVw=;
	b=IMRlvUsiQ66Lv+pmARy0IeIkZYbBgqr1xhJWWMim7yVor3QJ3arpuEaaANy1twU/ffoLyp
	KS431E72gosQnfgwglsfJMgCr4gR1fpVkfxgjDeQBEP1sM5Z2mNKJISO6UYI0qvbn7rCBL
	nMDMlTtdt5rKungSN7jielMbOMpRqCk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dgcmS4l/";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791578408;
	b=AVountfCzT0x3wX4WiAHYHl1IOgPIBG+MueTiWC8ngviM3MaKJGhaON5ZL/1WLK+r5e7zH
	HJmgTu8yefhee00e6AF5cVFRZs40XNaq0Ym1VRpdeKce7NFdkVc46qxVtXka2VHX+m2Ir4
	9Y8sVRlE4x4BY8YK4hudrgPkA4r0CCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E5BD60202;
	Fri,  9 Oct 2026 20:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453CC1F000FF;
	Fri,  9 Oct 2026 20:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791578407;
	bh=/wtgYPMXZXp6zUY4OHNPQsnexKANsg38h6IetxV4HVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dgcmS4l/QB2CnJfDYDb17vKsMvHwe53V+g4Ny5HGZLcV5gOUveA1mlME5m2xvJll0
	 qlUS4Ga5e759qUed1A4v2aR0S040B5PrEEqq3TelDuazgMw35RQPpICF+RqgZRjh2Z
	 ln7mczbcOy+zB98SiBFCN1gRr7qUvvBpH6YAz+xVXjNMUdXRX0HsAuzn2l9+wnAiMA
	 /DpP3vUwTSBelISkmNevY4ChfGIF1LmPKX+R7lMKcfwXQkh1fvGMISs17uVB8y9dz/
	 NTPjG32jgpViqdMZ+BFrxJKXy+inzS9lARKZ/Q+FEbeNymNsYXSG9DAQNLYkt5vu3e
	 25Tn0gCA06Xsw==
Date: Fri, 9 Oct 2026 21:40:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	buddy.lumpkin@oracle.com, akpm@linux-foundation.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com
Subject: Re: [RFC PATCH v2 0/5] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
Message-ID: <aslREDvk7gsfkHDl@gremlin>
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <cover.1791577417.git.ehab.ababneh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1791577417.git.ehab.ababneh@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 28C38180003
X-Stat-Signature: 76ynb4q7escnc75mtnbx1imeoinmbcdu
X-HE-Tag: 1791578407-457292
X-HE-Meta: U2FsdGVkX18D+uNywtaSmLEQet+MkEyw2zRid/K/aU+JCbae/k5GXVHQTlBDaA5WbMDC8yD0ixHBXjiGlq/iYF0R9RZ0xTGioLhNzig516Xbk2Kb7ej47u+j/yEDL4XUcPPQ0ihuXAPjqXPl7BeUZxH8Sdyw1s1Sj8PtUPUY8q7MOp5WTTZEeKgyOxRaGFyM8bNlR/EQQp3dO/UU2qpcDTkG6OwcMK2DzV9er5jsPkhMbsRW/mUn2MNRlFPpcar6eYoN1Nn6T1YNAVZPIRtTqOFaeTxa7H0gbDpW+A5wXZtAJ5z8+9T01rDXQjZljYChOjghJkouznBTk6YyAZH000Hc1k6ku5khnTVdH9Q79JS80vgQ4WU1t04CxNk+qQ6yuaS94h2WnvbQ6MCIzO7ClgyGRZehVcBeUA31+X322lX5ZTDChLSSqab/fY/GqzcIVMLGYp9oRX+yBnfN5UjIHDf9eQhKvDXRSY9I7e6fdh0kHga4QE+WlG+fyk6bnTbJdjWRco2uQniARoHMjwM3F6vu30Y6bOiCJK7N5A0AxdXS2W1y8PenIL2X0oJduSaLgscRCe7uGTvj14Q1cOJ8FFemyp8ZfY3yluK6QZIhjZIyvUdYsC/B52x2RB8JtOqPcv8DN//XK58NdDolZBgpHCVdWQl2s2x4OkvYaB+KsaPruLffTVK83Hc2a8KzVKBjH7pkfBqbiMAUCnB/oIs1S3NcIO8ucQ26cxR5ZxR7I039T2XGxIb6XruiHL/vkF5ZT4m6VCx0AedvZX9HLkjW+3xkg0xOXmNll6iXrer3u4AWqaggoGyxg8Pg0RzQNdQQ0Btul/dM1kzo/ppPYZOb+J7688eHh28HltZyDUIhBaYQqcwmQYWdaGeU7og+8uOtZ2bG/1XE+bz1sxEh/B8cNCYJrhNWK7yWRkDWhIXMh8bCj8vH2rm1J1LZ+HZDQKcd5WcVAIhzQINwzAk1l4L
 yrTRdei+
 aWeLtTRrTir9jy8nhabv+TH5on4RwPH2uaCGedNt/VcgEElw8g0hzdh4mA+tz3wkmMSsA1/n2GQyoZBf3WHtrUQ1MezV1gPB/CekKpLgPqpGHjxfRKNVCLYB0ZZvMcdrXlmAk2o6xUcMy8bDmlbREhEedB7kYFllQPTylETcM2Dc0QQUSvl4+EcTUXHaJXjd0ihKJv2rm/fRjuYYyY/jK3gvG2jLwxqN+DSzrkOXmHZucbxztcuc166AQ9w/9NdbwZXOAMB4FMyuZIMnrLGewHxrklvuH4VU9bkuBmt1QZYBwAc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Please always send new revisions of series individually, not in-reply-to
any other email.

The easiest way of accomplishing this is to use b4 [0] (the recommended
way of sending patches to mm), otherwise format patches like this:

For a patch series, e.g. at v2:

$ git format-patch -v2 --cover-letter --thread ...

For an individual patch, e.g. at v2:

$ git format-patch -v2 HEAD~1

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

--
Cheers, Lorenzo

