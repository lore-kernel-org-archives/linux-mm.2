Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38260D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85FC96B0005; Mon,  8 Dec 2025 04:00:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9416B0007; Mon,  8 Dec 2025 04:00:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662ED6B0008; Mon,  8 Dec 2025 04:00:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 512526B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:00:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9A5A5C02B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:00:06 +0000 (UTC)
X-FDA: 84195706812.11.B8D2B5B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 56FD112001C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:00:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jhiFHHcK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5B5AvoxT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jhiFHHcK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5B5AvoxT;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765184404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JJ1vxPbpVm7FEKxgzHFQFynHB6Ti0lQqHUNYjkzRYw=;
	b=6KDdQeYOYD5PZ4scw3LBKe7o7luNeOSrBGr5juW6WxI0Wpmm0gi2g0iTXgd1XRN5iowsok
	hX930YoHnHtYd/mb/1tChcUzD4u7SPWz0U5u4EuWMJLTryfhj4XrwHB+fIzsGqp8MISvs2
	IuGgMctL+KMsuh62tCc5OHUYBh12XkA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765184404; a=rsa-sha256;
	cv=none;
	b=XxDA77QDL3gtrc/jNyT6ykWpA9HTLE+/vgwhXHRmMVbVx0PlTdAB6slyuEyc//5jFBPwPm
	1bD7dqGZUmwEiH/i98hExeRHIq1w5qz3jHQwkWfLdiHLCDxFR2ozzfOBy9/Ei2XNV8I1SE
	vVTHsL0UOpOQCOD4qi+a8U6uW6LRF1I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jhiFHHcK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5B5AvoxT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jhiFHHcK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5B5AvoxT;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5E7E45BE9F;
	Mon,  8 Dec 2025 09:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765184402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1JJ1vxPbpVm7FEKxgzHFQFynHB6Ti0lQqHUNYjkzRYw=;
	b=jhiFHHcKh4irg3B+mEOWp1Wd25iK15yAGqI/nvLZ+p7FgZ1nJFDIZD83N+mHGi5enAfriD
	LuoASFpx8s7x2xfGU59tvRsJKEKXpUFtN/bc1Z1JfN773+QGFf5TOhBKsZjvMxfUd4eTTe
	sIK1MVjorw/QlZzoXyI7es6Ehblh+VM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765184402;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1JJ1vxPbpVm7FEKxgzHFQFynHB6Ti0lQqHUNYjkzRYw=;
	b=5B5AvoxTtJr6QiUrxeakLkdNlwd13FHZ8SC2S7jRY53kXRpCslli4JXYBsAOeSNfGXeuGs
	1GSYMtjiBF1hWCDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765184402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1JJ1vxPbpVm7FEKxgzHFQFynHB6Ti0lQqHUNYjkzRYw=;
	b=jhiFHHcKh4irg3B+mEOWp1Wd25iK15yAGqI/nvLZ+p7FgZ1nJFDIZD83N+mHGi5enAfriD
	LuoASFpx8s7x2xfGU59tvRsJKEKXpUFtN/bc1Z1JfN773+QGFf5TOhBKsZjvMxfUd4eTTe
	sIK1MVjorw/QlZzoXyI7es6Ehblh+VM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765184402;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1JJ1vxPbpVm7FEKxgzHFQFynHB6Ti0lQqHUNYjkzRYw=;
	b=5B5AvoxTtJr6QiUrxeakLkdNlwd13FHZ8SC2S7jRY53kXRpCslli4JXYBsAOeSNfGXeuGs
	1GSYMtjiBF1hWCDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E184F3EA63;
	Mon,  8 Dec 2025 09:00:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cv2DNpGTNmlPfwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 08 Dec 2025 09:00:01 +0000
Message-ID: <455f95e6-4301-4877-8d2b-548504f1823e@suse.cz>
Date: Mon, 8 Dec 2025 10:00:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/13] mm: introduce AS_NO_DIRECT_MAP
Content-Language: en-US
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@kernel.org" <david@kernel.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
 "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com"
 <riel@surriel.com>, "baohua@kernel.org" <baohua@kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jgross@suse.com" <jgross@suse.com>,
 "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "prsampat@amd.com" <prsampat@amd.com>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
 "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
 "jmattson@google.com" <jmattson@google.com>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "vannapurve@google.com" <vannapurve@google.com>,
 "jackmanb@google.com" <jackmanb@google.com>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 "Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
 <xmarcalx@amazon.co.uk>
References: <20251205165743.9341-1-kalyazin@amazon.com>
 <20251205165743.9341-4-kalyazin@amazon.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <20251205165743.9341-4-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56FD112001C
X-Stat-Signature: hkbt41yud9gdhuqiimbepg5ne5nx9yhp
X-Rspam-User: 
X-HE-Tag: 1765184404-537868
X-HE-Meta: U2FsdGVkX19+KlnMlgiLwPlX51cYK1QaLz5ug9cOA6MH2zP/ceB54KLnQXcMRYWPsSMtnSKJW1IIOUZI0fh4Z4Oh/R+8vJjSE7nfxo5VA6pv9JKhTGWHnroJi2b0kRc94lZX/A+dtk2n1N6WXfLsO6jduPxAPiI4AaDnYX4dFW65XHblJei7yiQFjbaDQNC9ZQetyLXFwrYhMHoXWmZV+QF00Uisq/Zx8dL5lfhgyrcdUMHL7721rZgsqINBTFDDYRgFFdWfuGswvdLvUSnvd9AsIm1vmbDM/as7bb0yNVqyn1Q8vNSi1ixW4cdyF24PJrbmvcOM7zFMMtgP8UnzX20gEek3x4Ui5mrnYFd/ygvHGpneGaOu1GGIg7jZiKjz2aPTe1B9GfipvqgZD0xmRQpRzeiQaB186uActXHFAKX5xhAbtgipZY06DJSJrsyWcOml9J9Uu7LTRxFVNZ7Jp220MJrXcelELelHYv6CcnJLV1UNhPzuA3/X4sTPdY+cuMB9QuKtoKKVonxc6zpcHMRlf+Sv/egAGa/81rRnMzepDgQET3Zu+qjYqp1A/Pc42T0l0/jHcysKDtF9IkbxIO/McYCBK8/9t9GHitZoNWMqHPtbDxukY1RzBXYlMUoL9ZR6G4HW98C29owcZJWi+KP2+kmCdPkbVPExbXiqwReMgnZFfVYAUr3LVqVkF6rKkQmoC3uiA/Mm/Blvd91QyyCeHn7OsUF6XwS3pQHVvdUG6dYjQrWUDMVeOl4uOD2Ff7tUXP5/QwbK8j0f/qFu8c5+4w5zxQo77HHWNMBesVOC8c5WvB5UIwRpRYQyatZVfItVmrJbbMqm+oqFyIT8L/Q+ojuhBNZFF1dnzhOJp9RjnwowJaDV8/a8UQCtLMNgcjmJyz+hJ6qTjrHQ9McTYcZ2Sa2262aCYI+7Rh2ryXiBaL0DPHdE7FwTB+W/xdgozU2+cRjTiJ8xuMLu+VZ
 Xzr6iPQW
 XhoLaNCAR1f2k032Xor02h3tNARVypmKNMdJq4gjFEkfPRNNd0m4mP6hHpPHdoO3pS6jhutaszownIL44OL75cvrb636XcF5+SjkkJ5NGBE3uI6ygMyj4XPoNNCBnoutHePg5SqRun+ISRQ/T53sAH5X+d1949gD53jNiHixpTTchJC2lcwOe7gTcJDIfBbBavfOPL8UPnGh7zqja4ST9cQATlVinC1ihBttfAEoTbZ2eZHsUZRaOlRN8p0qlO8bpn4Mm63MmPnB9+ztwy1CcbLRjna5FvbMXWuQca2MR9BwVEYdptSK8MdXxeyPmCLMj7rC4i7wq/G9v1hN9F4e0OS1x0Yk/knTEqhnUQqBSFlG/tSXQTOGI970DLY8cvK5AB97B5zoBW3t0ZG6LuiGvDa6dVYvBeatUHmXaSiO/pUp5W+t4cCv7M8TDZtWh56dDIjxCAiJbKrnthkfYK2/IRAKCRJ/MneSn7O8+Mqx+HxpfD2Dd78BGtqDA/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/5/25 17:58, Kalyazin, Nikita wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
> 
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present. Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
> 
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
> 
> This drops a optimization in gup_fast_folio_allowed() where
> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
> by default"), so the secretmem check did not actually end up elided in
> most cases anymore anyway.
> 
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: David Hildenbrand (Red Hat)" <david@kernel.org>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>


