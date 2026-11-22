Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4563F606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e6LvUN2B
Received: by kanga.kvack.org (Postfix)
	id 4468B6B05BA; Sun, 22 Nov 2026 11:05:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F79A6B05BD; Sun, 22 Nov 2026 11:05:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E316B05BE; Sun, 22 Nov 2026 11:05:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F02CC6B05BA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:05:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 814E8A8050
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:05:33 +0000 (UTC)
X-FDA: 85463230146.28.32BEC39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA99740008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:05:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6LvUN2B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795363531;
	b=wHnnhqC38jB+2xexofRRUTrYN+xuAlDgh4URaB2u0VM3MBkYeQpM4ZM/FmjoKqm4fn7kA5
	2xuyAvkbVNjzpz13yRsf5uUzOG8TjaI/iliZn+El1mFqAQ2m32V6D13uLQJMHwpcMRBhs4
	+RAt+C44bm7W676+QJ+rWRE8+nA2G6c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795363531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcYPGhhNRQkPKiAevxXV6mkoY0yLLDaPyFoFmXuKLVo=;
	b=g+nlyGTJpo8o95DqCOufO6UEQYby+VSel2mEiHfVk/OnE2o4p9csLkCFc6mZ3ywViASnXf
	Z1QBTP6UvZJxmb3FTlYBEPmpKAGCipCqs34b16B+33fDXU1+QaHoI1FZAhCR5Cf7n0k2+E
	d7fsqofhYdmMJatFmb2NdUiqXIwwVTI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6LvUN2B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4606661874;
	Sun, 22 Nov 2026 16:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F4D1F000EC;
	Sun, 22 Nov 2026 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795363531;
	bh=bcYPGhhNRQkPKiAevxXV6mkoY0yLLDaPyFoFmXuKLVo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e6LvUN2Bfc5dLrNMY5ZDTuCQCgxrj/lFy7kFVIfMpe5Mm3kjCLj7cEkYFhpx9l7JG
	 W9knIw2yKLc7bB2UbxkaUveTlMpYkI+UMuQN/Jl48kIX1RjLYalUst2zk7/9nHY2Yt
	 PNBpVWWC2G2+X+G/e/BYNsukReSIXWO+KuqxOW/EuSBC92dbnrMLSsxsoHByR/Se+/
	 Mxv9x/SLBlbiArTACoe3CmKbfFWiSS2jDQ70041SY2KHJMWSFp4wthwODCveiAP+/f
	 ToyAmrrvnpyxAxSe4+jLLM9B2tbstPwFAT6USDQAbBq6mRpGj4wIVy+ZBW1QjbjIBj
	 w1mX9QpnylTig==
Message-ID: <e95ddb9d-4608-44e4-8602-2b07ed656901@kernel.org>
Date: Sun, 22 Nov 2026 17:05:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/7] mm: let vm_ops->open() fail for hugetlb
To: Josef Bacik <josef@toxicpanda.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
References: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA99740008
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 6u973u1ngtt61sgxob3yhud1d38854mp
X-HE-Tag: 1795363531-813171
X-HE-Meta: U2FsdGVkX1+goOVz81VaUILsXUjz6I8jybCM+lvPztv5wmQbxZZF1MMMHUQZLlSr30I8GEpmuElDO2xluW9VcI/eTF4CMS1MIQs3faPDzTooe8GlZsq5AdZvF8zZoxJqwyrFifHrxBemabLC91PoW9tsL2MqHoxH5KDg8Z8Fy9qIwJkcirKwnM4imLifMPiliyAZOy/ufMxTp6/J3kFqRBnM17HIGakTCkEzDqDDcwhxBp4WU7RI4pwq/rgo3sIlBdA22KbeEL2YQnrzGsASL1fq8Qwy/f70ZcUZYQEvsecU2+AqIOBEXnlK4l4/i/Se84JHA5WmM375syZvREqVnSUJX9Nb61QHmzqElqGGQGq8dTKR1C4KDAvF8flHLXBaj3hnaW5u60DiPiNNTN/VLetOd0N0dU/hvrGnfeh1hhcyOOpjT8GVHfSYPtt49DT0coB4PAhb7OnXtTj0uPi8mEoDW9Si2q1T8Prn9HSIHj3dz1d58ZEe/kWhmqGH8/uqpDP4pT2inVJFMOefc1hHkchIdrNAeMP0yedpGhLgLA6w2FNdQMvflyTBr743RW7IKUid4TnTsJ1jArHLJerlL/Kcp4ABR+89Bidqr5fZHaR8+kvf7FbGo71E3qohW8Y47me8ELVpVzj3S1BCd8kbZYPipMSGSal4L6OKMNV3xRLhOESMJ2Hxk4QGdTgZ3NJsgowusJmHbDRnwkLJwA6ll/8G0sjMxkYCWwqdF53yhgqzV1Q5HCOxw+wbdTvi1A9dFTtrSev24JWc2b+RHjCn3MlfmG5xN4YvhAlwXlBpa7jGdTC70Uw6nQUT5qFTRooCVtFmvk707zTiXjR9eWxBH4v0BbAvHjKH1d+90bYMBhY4LpDh2VIY7VX/nG85bTB5C0om9WzTCm1Vi/sLIoOXI6xByasEcdy5pQxWfNjDI+XLEYQnyuHgbODVU3Ub6qYYgogyKGPM9EXARE9svzF
 dGskQkyH
 5Mc98M/4J/a28VUldpE2Rd5V7LTcdatdMvFBm+FRDnmKxcYOb5GI4mrrodDZXR2fs7Qt+F0gWydenvuHRGZrGexD7CzSYQ2GoLMP3DDLdvohG4OhzhuR3rKVxR0DV2hGX/lLMPAQuKVSOfBCbNG6N5a61tp6j/z5kXBgB0GCRSZlptElCbnZy8ocTu7rPKnKhwQZFhj4ZqVX4VK693KLRWsVQebyuarh2JClu3e3nvCp+xH5z94pJgIWmv70J2aw3avYOL2jXHi8JF4MI4AfPy7xiGXAIl+xlTMGazXlYGmyUT0j2ijR11T2qqg4GDfjiE+Hprat8vdYkoTIOMWXNtRWE/h17BaHhjRNtuwqkn386jJafBWAH8o5KmWwA1bEWgqu0Y19U1EE/ti0rk5si1GNSmw9Wtl6g03UU378vmaM+qiZrYCoEnLXYSirkRf/LPz2G72O2DP5bO9xwPT1OZ8mj65XGEvGLrnm+6kzHDuH+gwcyYXUr6iHqCb9BrfavuZ9VBHgqlZ5o6jrnTOVXRwJTlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 18:00, Josef Bacik wrote:
> Hello,
> 
> vm_ops->open() can't fail, so anything that allocates in it has to hide the
> failure.  hugetlb is the one I care about: if it can't allocate the VMA lock
> for a shared mapping it carries on without one, and faults can then race
> with truncation.

I'll leave the final decision to VMA maintainers, but for me this is the right
thing to do and I'm sure it will come handy in the future.

(I have the faint recollection of people having to work around ->open not being
able to fail in weird ways.

-- 
Cheers,

David

