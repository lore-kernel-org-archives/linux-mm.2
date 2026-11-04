Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B511A606A324
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=O4SH1a9V
Received: by kanga.kvack.org (Postfix)
	id C24C96B05B4; Tue,  3 Nov 2026 19:15:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAEC06B05B5; Tue,  3 Nov 2026 19:15:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57656B05B6; Tue,  3 Nov 2026 19:15:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C14F6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:15:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2512A0593
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:15:52 +0000 (UTC)
X-FDA: 85395518544.18.8D6C377
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2632EC0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:15:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O4SH1a9V;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793751350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yupwsl26WPKHnfflgYt0LlJCyAjS9VDdHq3ty55cWYA=;
	b=dZGJPn1frVjT0y8DhgY91Mp+D1zKlzYdNhdXVoKk9XtG5T0DTpWYc9EsgwY7YNPWlfXW3t
	z7nT7QtupBx2MovFS0ckH567KaS7voqTgE6ScNCpRN/O0nBfEHujqnMCW2vP/N9cb0Dt1W
	SuuLaU5+x9t7qOE2Odx/d4LQ+d9Z968=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793751350;
	b=y60YR7pSzn2DUtNGacqcgTN6M1VWJ5WSwC8Nr1IFqacd82CsWyggNGSLkNss3CAjva9iG9
	/iIo+FgVRQWJHkx9IYMi07d6eSqrVuxeZfTnYvwFFeczBFvj6R37sDG+YXdulQ+rjXWYtx
	sOfHPTmx1UTRuBYdQmdn/RZFNqaTSc0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O4SH1a9V;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793751351; x=1825287351;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yupwsl26WPKHnfflgYt0LlJCyAjS9VDdHq3ty55cWYA=;
  b=O4SH1a9VbhO+bauJgYV0mxITvYp/ubM0yabHUZYwy6lm/fAX4u9VdLal
   CYCBhMHLP2HBzAkqcyx9CqMgktTYNxbMV762O7++xCLyEPP8pP9fiGmhi
   CqMI3FnEDSSOHplT1CzCL6oIhBOXKNAT1bgsYjMQqi5wU5mjtPZdJ4B9t
   EcOvHTNnUBc1hYcz/5h8+gPt9f0Hl0a1BT1tXAQf9r4bLvr13ZJ8aGu1C
   5xS3qvXda+6hr54+yVX/qsESgAFWoEdaguGpmYvQ4UcqqMTdbl4lUYV3Z
   uyySQglnCYvv0URo57tJAy4Q5HeaA0lGSJC+rIU1SSvhc2IIZzcCvsTLa
   Q==;
X-CSE-ConnectionGUID: 2yYQDb1RTlGZzuOceSiOfQ==
X-CSE-MsgGUID: 6q1rRMwcSlmglTCHhQah4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2512050"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2512050"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 16:15:49 -0800
X-CSE-ConnectionGUID: SvpQpvFJQNS4i6TP5pDSJw==
X-CSE-MsgGUID: ehxL3feYS5iu9ptiVVWgCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6418120"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.109.226]) ([10.125.109.226])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 16:15:48 -0800
Message-ID: <ee9d317a-9829-47c1-81c7-1145304ea484@intel.com>
Date: Tue, 3 Nov 2026 16:15:44 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
To: "Ababneh, Ehab" <ehab.ababneh@intel.com>, Barry Song <baohua@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: "ziy@nvidia.com" <ziy@nvidia.com>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "buddy.lumpkin@oracle.com" <buddy.lumpkin@oracle.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "kasong@tencent.com" <kasong@tencent.com>,
 "qi.zheng@linux.dev" <qi.zheng@linux.dev>,
 "axelrasmussen@google.com" <axelrasmussen@google.com>,
 "yuanchu@google.com" <yuanchu@google.com>,
 "weixugc@google.com" <weixugc@google.com>,
 "david@kernel.org" <david@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>,
 "liam@infradead.org" <liam@infradead.org>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>,
 "jackmanb@google.com" <jackmanb@google.com>,
 "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <cover.1791577417.git.ehab.ababneh@intel.com>
 <CAGsJ_4wmSL7i4EPLWLKhDD6J=1TywBi5EYYDxp=SvOuXdmLGjg@mail.gmail.com>
 <SJ1PR11MB6105E839E55E9B0BDE183E9D8C9D2@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <SJ1PR11MB6105A05870574FF39B449CE28C692@SJ1PR11MB6105.namprd11.prod.outlook.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <SJ1PR11MB6105A05870574FF39B449CE28C692@SJ1PR11MB6105.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: c5j6xkuiippi7jfi3wwadgtx6ytsbbhg
X-Rspamd-Queue-Id: 2632EC0008
X-Rspam-User: 
X-HE-Tag: 1793751349-190630
X-HE-Meta: U2FsdGVkX18uREalQ9vu6dtmZezOJN7JWMHvPHf3bq/xk9lbDpQCd9OjHjQgTeB1wLSVMu1zEgpE3/QVJS1CwhGotHt5ysWrkjiKudLVQvqn1BTP5gboxHyvConB7cVYdCuE2UvsVEhC0w7Wh29HxcSV6Bqx6obCWpiyB8Gx5+brfcDfUm161fQ7NoMgYFtShPJUDSPLi4B+PiuJ3i9xTjScpNqzU5QPGhAPhDDMr7hW8Pr1s1noAF+F+gI5JPyWJyw5TyRy0+p8R9+sZmGPKhAkMLcuAVKvgsbGY+tjBnCYj7iZttZ7z+0Iduk1wdmMG/Dk6pFBE+UHEVA1X/JPTh0jCq86qJrOSJ3ODag0WoyBfjhjOJWwZlEHkRjptC20jHYhiwzS0LvzC1X+QG4SPv+yAnZZ0ec1M5HmWdWIHWR9zQcHNMFi9NrR8bkRsMruYc46jSKHVyBF4uFZL17r2/VFLOuGIw1cBVLYlnJgeqpTkUy29XBUwzneLjvWQ7PtXHZZ6VzR6YvYwNDikqUhg38sNJ802QDyvvEraOiBMK3ZTgbpknHfkD6ecNfAOBefJROu5sSoLqxybRxWi5fZqqbHgpdbhrefhGDZbatXBqgoLGZUU2qzvvija43KsmgA8rp6SV5z7ek6nZgj8JXwIkhhePxM11TaTn/4j4Pk4fLfDoZB0fl7Tgn2r0xyA30maiGhTTnapM4QVZxqVfv0sDIRVLRbJYpYlDGYTaT1Ks4XrSbdChu98mjXp31MmtxOeE6klnBbMDehbVycye1qpmAOi1i7XmqJaXT4kbQ3sD8DRAbca4OfFIJ7Y1+WTEhfPmVkdjArGClEjfttqr7V7M7htFrwTU1fMJpF30lH9Jsq4HCzWbc9ecZMp+9jLRQQ6YF5MirseoIS/BQyQWiRqUQ3VLFXg4YJZeoKWu8dQRaSmKxk6cHm3HObD6lRUtug7V4WyCzO/sTbIleusvv
 s4RAtk+V
 UIY2XjYh9ElyvkRRdD5xxAcOTwskb5OlWlrsxbqbYUbByfLiZicGMZl3VvrgJ+wlywaPjk/Xw1jn1U2sQ+KJUW2shHuvDllg2LUjMTawicEbl0mukFoKDhXemGMIbTsZPbzzeAQKp9TAzRMTiYQbkKTxMFQqQlXAhyjd9oKoAW1Gjg9JjhY6Q2teids0J6IZI9kVpp08qXeiNM9QHs/elzunW7VTaocfXC03wj17waNk7Lxev8VlJksmIdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 15:41, Ababneh, Ehab wrote:
> I would appreciate your thoughts on how we might achieve a similar
> performance improvement without increasing the number of kswapd
> threads.

It also just plain doesn't seem like folks are very interested in
optimizations in this area at the moment. Feedback that's basically, "go
optimize something else" would also be very welcome.

