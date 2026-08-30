Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC86C61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97426B0088; Sun, 30 Aug 2026 14:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49236B008A; Sun, 30 Aug 2026 14:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DE26B008C; Sun, 30 Aug 2026 14:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6CC6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:14:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D1A9C0312
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:14:55 +0000 (UTC)
X-FDA: 85158736950.24.69A10A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 64C6FA0008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:14:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7iC1y6H;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788113693;
	b=gs72mYNT271YhMr7qchMD3vvAA/TzPUh8Tv8X/4LkCjNehPUe6Fi4+Yj8lBB6sb78pOAai
	dW+jKAoHgMi3so3BGnQS2OfP3D2ZS+MQ+JM9SgVbTBqX4kn88DhXLihiIn2Ts7Ht56lxNB
	F7t5ZwZOM9pwGegL0E1275fwdSymVE4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7iC1y6H;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788113693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/ExsJARLlh4YfLuTV4QZWOBWCnroOAl4CtLg4Wbva8=;
	b=u+fklRSJdcTJlAb4zvttOSuBy8TuAUlCPMq6M9Zjb88f297CxQMgA4wqgIw/sWo3wtghQc
	iVtE6//G0ValKcLW8vix1Rs5izrVQDLN/EFr/gtmzFhKFca8/0uH56cjzm1jM5dh2c2j0q
	cbvdddlQfcyG2IeQXZy4UYARYpEGhFg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DDE0411C8;
	Sun, 30 Aug 2026 18:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D9F1F000E9;
	Sun, 30 Aug 2026 18:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788113692;
	bh=R/ExsJARLlh4YfLuTV4QZWOBWCnroOAl4CtLg4Wbva8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7iC1y6H0Esa9kFZr5h4N5HEyHSq1fV4D0C028OIM5GxG2NOGDRD5QZBrxWRal5oj
	 Q7u6kSz3IwmZRAabxKbdKnu81tpCG8WlZM8WDOVgCi1mIJg/Tg06EiVHEQqBAFag/g
	 9nIjgX5mLSFs61vNnv2D7sxDHWqRUlbp15YQPaGen+y8vIvJdBfpblsNI8TVp1CUxd
	 nEsxCkSR1jq5gYYSjs+DQhUg2O0IJ5fXdzKN4BznUimxYPwPaAC+PPsC8EK5L7NS55
	 M5r50z6y1x/hh+sY7KiflyTCxFZyjmotgs6cnzax6Sd+J/IOYgPtm+amyOgyhyoRw2
	 w0aDJDpvsKDxg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: fix unconditionally skip last region
Date: Sun, 30 Aug 2026 11:14:44 -0700
Message-ID: <20260830181445.104859-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830063159.6347-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64C6FA0008
X-Stat-Signature: rwzap9ktkety75m19noyd874ujdpfret
X-HE-Tag: 1788113693-191510
X-HE-Meta: U2FsdGVkX1+ZIaEEnH3rgQ8z1c4V5MHWqqvCXjbzyD3qW/J1SvI8PPjm660W/A6mAn2dYdckr3JR25Zrts1Qq6Ek4BO01HUs+BucZignb4Lp3W2RFv8P9WgVPxhpRySMYPAzeubuFbkxoG4sDPC09u5yJoV3EjMtQjwjWj5p/ZVBTN9TkPk8gFXdREOqrE+jbdKqzAimmP8UIspELi1NcAJnLRdt3FlFqL2XpldQcBL/0P6BjHdUFiALA5mg2NRrBNPaSc3jhC5Q/OujSOMwtyOIug/ZFFHV+9rRJbTVCo+qX8w3WWX1AkZ4O56oUvD9BVskPrhWqfY6tRY1ml/i928MXLYrvG046AodPKgJJDVRF9y1hOaZ+RlGd86qwrz3E4wODl6Kk2gOG89N+5Aqa7tynh7zBFBmereW/TkwkGokZnF9LeBpnGjrdCSjOku4H/E8Q6htKlmLRg6sByXaQ/amw0x4v71pTaIW6kRTaTgrY6XEtrhuuvPLUWqma43kZ9HHpsrLdjtssD6C//QUazZKhyfCFQdWPeDaAiz/d3qrPE1HJgFLh1mabbeZRd09B2h4RgCrl9yKsQKMV4DIP2nefAJleO8GNkXDXYpncVfG9iWLWqHdbrNWisU8T2sniWKiVoOCRte+4t2FnopAabB6NBS0h0wPZoBVzgC3THVfdtFn6kiWhxAKfg/LIWMvcy44THutA8qV0bsDiTb5XAaoAsmA6fAsgOvOFIbOywlCetF3y7xHmrovymWeLCcuPl+FVeuPZFInEgbqC0eJjy5KoWAD1srekA6XrnXRdWF0jlQzSRZDD6bHKF4H6XrMQ2cV8qQ2JrCfOwrdgGvo1AzVQFA0fA0mpXu5JP8v5IkSRxBcaur4SEr9kiwXLeph9JpB9dCk9goVKMRLwO7SLe/mWiMu5VjvnFxZ7fN1yTdtkHGSDxUyk0Uok+2QZM26Pik5+stSWGiOFaDYQNF
 XqYluqqk
 VqE7B3tCFeuNrEhmr3bviBzB1V4yGOvC7PRdNF1TILD3ohjZJpDqGQXCxmT3ok20ITSWCO5+ZjDW49nv49s3IatEWl1KCI3VadaOrjlrl+n84UBuQbCs3e1ZgOeyGHPdLd7OmQZDYxRDReDrxP7kuxdC6ZD75PdNh+1gKmX59TMtggfasfTrTOJ7UYZw2WeWkSYSSmpOw4Fc9PLwhrVlCQQi9xkYRQpATd13voiH5tT9cwbkOcqxJbkap/imlZIzVRiwf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 30 Aug 2026 14:31:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Once quota set, the charge_{target,addr}_from unconditionally skips and
> resets at the last region of the tracked target, so the last region can
> be skipped even when it has not been processed.
> 
> Example:
> 
>     1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
>     2. Quota is configured to process only 100 bytes per window.
>     3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
>        addr}_from is saved at (Target, 100).
>     4. Window 2: The loop reaches R2.  Because R2 is
>        damon_last_region(t), the old code unconditionally returns true,
>        skipping R2 entirely and resetting the charge_{target,addr}_from.
> 
>     Result: R2 is permanently skipped even though it has never been
>     processed.
> 
> However, it is important to note that this is a very minor issue.  This
> is because it is triggered only when the previous window saved/kept
> charge_{target,addr}_from, and in the next window, all regions except
> the last region were skipped by damos_skip_charged_region().
> 
> Fix this by only resets the charge_{target,addr}_from when last region
> is reached, only skips when it applied or cannot split.

Looks good to me!

> 
> Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
> Cc: <stable@vger.kernel.org> # v5.16.x
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

