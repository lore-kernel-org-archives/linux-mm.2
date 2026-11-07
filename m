Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4951F606A32F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X35xwWRW
Received: by kanga.kvack.org (Postfix)
	id 5A6FD6B05B2; Sat,  7 Nov 2026 14:54:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557A66B05B4; Sat,  7 Nov 2026 14:54:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446A86B05B5; Sat,  7 Nov 2026 14:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FEE76B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:54:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A61A6803BC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:54:09 +0000 (UTC)
X-FDA: 85409374218.05.4559584
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D7B191C0004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:54:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X35xwWRW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794081248;
	b=CDvmrmZ8mbmr+s2wkmccwsjFCufA/naUmRztKdF4LcbciQaMdggGhywTReod4JujCBjYsv
	gD4IxZxQiaR4aFSP483qezG509KTE5M77J6nL3C4K+tPW4F0tIUOld3VySGr8wNXh075s5
	rSGuZfaYE3dL5urGepFqY1h/xxMtxwE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794081248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Azk0M4+4kN+LKI92RpesCylB3qOSG44cG8TkMmyE5iQ=;
	b=ymXT1qA08GB4dxbflgyE9pBwyZBR+sqPkX9rgxJlKJ0dDe4jR9NhUOd4lH3vncFlttvN7/
	Mlnly2onM+UwcvyQ6RKOqBiKtF1ixppNlvwQo6xffsyjWuF6rucP6h7Vc6GHfi+cHMkiRy
	lrYFUkA6TRwTefv3T1d6ImWBNF06cA8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X35xwWRW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29F7143B3C;
	Sat,  7 Nov 2026 19:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BE31F0089F;
	Sat,  7 Nov 2026 19:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794081247;
	bh=Azk0M4+4kN+LKI92RpesCylB3qOSG44cG8TkMmyE5iQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X35xwWRWp1NJKDUjUGwu/dPhn1u2kLVBfKW5yRwfwaE8KVYkdjSh3+y4dkzuSMyrD
	 UC6f82CYICCr6FtBDy3AGdO5/L3cxDqjOEP59rX44rd4pqW9ydC79cRLVXVLHnS/Hh
	 VbGJ0mVhgah24nTHfkgrCnfUFnOeyyywupL6Eu73Kjj/SDlx/mnKMS4A1ftEDAqUNo
	 xFOI9/8SXDYctP9TX3Ot/ZiCYNdwitNbu+6zVHhI31PwPpWK5srd16sfb11kfSSfPH
	 eFznTuvk6MRc7KHP3RkQuTGYNcgEbDYSkl8hw/d6GgOebb3ilzVHB92t4ysP54Dtbz
	 THwAOjxx1XRNQ==
Message-ID: <e0a38b09-725f-4e60-8c53-e4605c36be78@kernel.org>
Date: Sat, 7 Nov 2026 20:53:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] selftests/mm: cover merging KSM pages aged by
 smart scan
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
 <20261107-bug-mm-ksm-smart-scan-align-skips-v3-4-16d5ce8b5fd6@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-4-16d5ce8b5fd6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D7B191C0004
X-Rspamd-Server: rspam12
X-Stat-Signature: dikjnx7gdwcwanzizxx8b53qikkp6zy3
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794081247-829325
X-HE-Meta: U2FsdGVkX1/tDc97nHvh8JVJuimBVLiJw5Yr8ervRKB7IRamSAVqkrfqq4Q985KXyev/aooeMCefWRHundE6VP+pnA8WAMB2u3O2Xux40i+MAEmdgk5NxIP/2B79jUjfhlrEMRPbLucmoXAyCV84HpZ7jpZOKvrL7Y/DHABmGCMrHIETlPRjWpJBipfXS//2FZ0CBSlsUiZMcJbqnkRdSEU6nmtXzkOjZJrOb2m2DZxMFHQ0G/7sGXvP0ymeh9AsReKU23hFJBGoYOStobYlEh8/td8HHyFMs7IdHdevAMcNwIkrG3IsLl6WVMrlYDOmSPDG1H8Ej5j0eXgQqFpStQ5BRhsxKVLPsTpUC38OFpMOyWAsrMYs1SgshEvtGfUM8OIfsdLMZnhcKLFEHeAuzO9rqgAHbC5uJygGGs2xlSEQR87NWYCkaoW6FA6DRLyr+YifVSbEiREgVC2NM1s5E/M/GUz4WwKOe562UjEzx3ENJooFaTe18JXmlqXDnCa57gkJVTFKY/xzlT2NgVLI/HSJ9zI+y1G4gfSHyFUwrFg134Y8WeTKVTjb/iI+LGstLZIdrJygMvZSybWWB+fxZGEdkoLnmI2A3UVV4Gt/uc83OU25C4oCIVDKjiSsTSfOHEHvXzuVSa47TNAc2B6ouU4YXRvv7Q4ra/wIDuF1hF08GMXDa6NXec/B5NAs4TEDbi6A8kWW3+xhrnc0yra+MXnZSgO0CQNOTo4GISS7HSBxf5ph2of5ZnGYieRtKpinssNKPotAFokLCgd75oM6bD7UpKdrii0gG6bw2QGwDz4Rqhw5Qc9OMTAR4Bo55ggx02IX0qzPwZUzHV5Lu/47cfBzgSyaR3LFV3I2VxWnnxTIAcAQa+E/EMIm/VpV0nqPWpVRmrge1ZIGhHWZh4QDmbKq0oV42vEyERtzc+ThsIL5DIDwiSdHvVPtnOOD19tW4rgZ+W+J9U665gwAl7q
 YHEDY4U9
 b2/KsIWSTg5iOgU5LrbYlAvgrRjCo6oUEntNy+inXYKmYx6hzehnKIiQDDyWfATkji/WFhJsEu8b/TYORx5ZzakDrXIsWl5hIWYzgEM8lXxGr2m/+TDHkeGlnZTLA8+rqjkw8WqwDvck+t7MVM7Xrd+KH++Z74qSRJoGMhs/gF7rbsjl42S3gsF7EByQLMAw3s3Nu5pwhrEEWCWw0QjZLcj/uojaByOIvvaFL2Yx83ZayYOO6s+NV7TS6aQPcjOsFT1dpQBfZv4WKCd/vg9FL47TEkkEkwJPBU+IaIf5St9RzW+rRY+kOtorzdBEH4hYugOJ/rVYTmmUFObwpodhurR8wlwtEg4kBNEemnIwLaWb4OVX6TnYVgorZ+RaTHC0cIQPrVopJlK5Cb5BJ9q3gvMl88itxoxqgLm/9RFTjGFpwZJHLFNM/LrpXuWRB24zTsEcO1r/eRfHqFUnyW2/JrU/+7cyyAinufm9QItM1+JF3eqE+wk3vSINB3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 17:57, Qiliang Yuan wrote:
> ksm_functional_tests checks merging and unmerging with ksmd's default
> settings, but nothing there exercises smart scan, which skips pages KSM
> has failed to merge for a while.
> 
> Smart scan used to time those skips per page, so two identical pages
> that became mergeable some scans apart could end up never being looked
> at in the same scan, and were never merged. "mm/ksm: align smart scan
> skips with the scan number" fixed that.
> 
> Add ksm_get_smart_scan() and ksm_set_smart_scan() to vm_util, and a
> case that enables smart scan, lets sixteen unique pages age for a dozen
> scans, then makes a duplicate of each mergeable one scan apart, and
> expects every pair to be merged 32 scans later:
> 
>   kernel               failures, two boots
>   before the fix       20/20, 20/20
>   with the fix          0/20,  0/20
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

