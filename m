Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CFDEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E07A36B00A9; Wed,  8 Jul 2026 04:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91456B00AE; Wed,  8 Jul 2026 04:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7056B00AF; Wed,  8 Jul 2026 04:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C2016B00A9
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:23:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BD0E169220
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:23:53 +0000 (UTC)
X-FDA: 84964921146.20.EFCDF2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 831E740007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:23:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XbnXMFl/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783499031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RV/dMmkkmSHt2vwdVHOTWIbaMitNlvzdrXwoP14Ul0=;
	b=diVOdtxFZ6CEHT67LFzmJ2vvbbMCcy+OGPOPBcnY8wyVbhoM+uhYS3Nhs32HvQwT/olfvm
	whWnzn9ApsSfYVt9/imDr0ZC9pML2Oz6fsatl6177qgW0C0uQxlmN4eMQ1jrxfkNhrbfwh
	9vrPoHe81GCWrXB/u5Nho6mDJnZrmMY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XbnXMFl/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783499031;
	b=zVGBQGvI6fLu2uEfYAW2wSA2OLruDfsogfrN3wP3tMYimsIyUEny5qpX2FAZyUo9dOMvju
	LZL9A/9JIudjJNOgXF8kyd6sh1BPRy9mEVGDtu6N2EEK6wvv6dbTX/gLOSQvNKwFB9Y6vF
	FhEpPnrLMPD+flxL75tre6StIzX2AZI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF70C4361F;
	Wed,  8 Jul 2026 08:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716DF1F000E9;
	Wed,  8 Jul 2026 08:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783499030;
	bh=+RV/dMmkkmSHt2vwdVHOTWIbaMitNlvzdrXwoP14Ul0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XbnXMFl/gbvHei4pp1M4jXdPw5ckw6YBScH0CfKy/g55mZrunJGqDOFETswW8yFZT
	 uw+NF5wnKu8uQvkHR3GCqsOzZFp34NrfN422s9YcqKxt+q8VWdAuI1uDz8Wy/PQ8rF
	 5WnaD4rEFn8Vx6nXeWmStiv0cL7z4wiVpCiRUSORNwMh83eQh6/CtbCsq1KdMF+Rgo
	 Hcbu8eYmCmMg0LfsttDo37fj/i3rq84kP4e4kjn/jHRLcUGvViewg13McPPlgKvzDn
	 ajapWABeZfiJ4ByBb3ANWaNMaVyLL3PbHoF40XADVczxy5bdQbSlA1Jeu7BFC3ssWW
	 PU546EDiSZGsQ==
Date: Wed, 8 Jul 2026 09:23:36 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	david@kernel.org, dev.jain@arm.com, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, npache@redhat.com, 
	rakie.kim@sk.com, ryan.roberts@arm.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	Balbir Singh <balbirs@nvidia.com>
Subject: Re: [PATCH 0/3] mm: handle device-private PMDs in walk callbacks
Message-ID: <ak4It9Hm8S01Nun9@lucifer>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <ak0FtLIlTyCo_8lB@lucifer>
 <fde1372f-5d80-4a1b-8bbb-11441db9f55d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fde1372f-5d80-4a1b-8bbb-11441db9f55d@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 831E740007
X-Stat-Signature: n8bc8zgks98q3obsy84cee1o5aus8yyd
X-HE-Tag: 1783499031-162234
X-HE-Meta: U2FsdGVkX18mVDWXzC61q4+3vIVoYZ7mPrIbIiFcp3ctqIgskytX1fPg4Hrnv3iIK4aAYZky1G1HU86exwLtllVdVye6ybGMrFgU7pU/Wlgm+hkfekZuBjMzHItTo4lw5Klb/6uwqnXcrQk+9ELVFvEj4T8qLPQhB3y4z5MXlY9geKk3FdazVVouGweSODyJM4bBTp7Y7oZdQTJPVWiDeFzGVOw8yXQ7Tf8UcgnQPAKwUBAgHLVen0EZmzIEBaayH1POHFUFbUPZn+njznx32yPddKycFqN3OOu5C1ntB7AUxTdyV0KF9fsP9wfunzazElQqmdVHFzkK7l9bM7k2v93AHD8gy5QnYmtMFuwdkblYJqEHYsSbJb8zx+cMM0sAk/3xZ7368ENEOTwMZc+FFp/H/ma7CjOONyaiyh7UuS6g1g3BsRkch6L9lwNnxP4MRc6yMAVWXF1bF6wR/u9kVRflyXe53Sh/9Q7hfhhUkDMBZZbzNBTy0oNl5U8dRspgegAqGl9y24FQN4Trc4eya703AJi+rAguh6EVZYKkuwlfLYoBtcfp/gEbiiF2InGokw3YYyUiKoywwOWqarilb0RcXMJB6W+Oo0IGMWvoRO8BMsddSyg2Zly/qjjIJiQA21CnCyB31IoFI1QHd1zcP8oP0YNzmbf0tWo/DE3rtSCcIwZJIRCs8ydVYnb7Jdx0aXjKnzqSDUZJ9rfUElw5/4ABAJV0+Oxf41MS03gvDN9uLQgudQmoWAG8R7oM/8wGRa6rCWk1r9CaoZHdx85wKiTNilDZ4xRL0cNlElg1VOsinVa+DydEPWa43i9VLckxQoNSPiPwns7jz1WydoayB9eMbTr88mB2urTbDCCAUAnC938SMRWIaKXKo7zZ2mQgFLiop/dQXUeF5mrMizgNDnZIR6ittdSW/TnFoIlqIFwfYLfAe4s7qKxfX6MZKaXfZ3pLEhlfriNh7ER4+Gw
 aGPFURvE
 oducsmX00nHEd/cTxLUg86O5OoU5m6C5xmsQu5xQ8xuCm0mLcRn2+Yylv0gHs9UkaYlcweiwJeONNSD+WcPNGdHe//I/D0bSkJI/y2spsat4SXQF2zAPSpf7AXhpfHRTG+3dE62T6JoYr3kFtdw05x4hcCdr34iBCu3Xd7B/Kzv+iMklDFthSgNo7jFxNvJeYF/aZij9YOCnt/hewemo2U4ou8M5ZPdzpHaLzZ32DTjlHD4bEIhBdBg+bd2qRO64Ao0kcGsB0AGGjmhhCFXcvrEheTZP0NfFiN76Lwy7CPjU2T9Xos4HKYkLDv52QQWaiMJFrCpBEYdvMZsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 03:12:11PM +0100, Usama Arif wrote:
> I think maybe we should modify get_maintainers.pl so that if there is
> a "Fixes" in commit message, than the author of that commit is also
> in the output from that script?
>

I thought it did that already, but it's forbidden perl magic that I dare not
look at so who knows :P

Wasn't nagging per se about that (for once :P), often people who'd be good to cc-
get missed anyway even doing all the right things, so just wanted to make sure
Balbir was aware, also so we can make sure there's no other device private PMD
stuff lurking! :)

Cheers, Lorenzo

