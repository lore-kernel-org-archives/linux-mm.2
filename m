Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DE3CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 13:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7CC6B008C; Wed, 20 Aug 2025 09:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0176B0095; Wed, 20 Aug 2025 09:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5EF6B009F; Wed, 20 Aug 2025 09:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4FA76B008C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:34:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81CD1117D91
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:34:47 +0000 (UTC)
X-FDA: 83797231014.07.1657F61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D873380015
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:34:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qLr4oPvV;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755696885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jvtwZijUUJUmdoME6YsCw0f09uHXkLXvGF2ITDjgxc=;
	b=8Xf38bCDrKvo9yylB2x9U+vumqwwcM0gwkMuxzi4iDnPSOcbDV12UTBVLPAkSDbdv7K7hI
	zyqlQW8rDflMFPb1cLSGoBzIfLZraikPhFkf8y1XVmEnOV3h/GgxnGRMivUCDfFmckOahm
	ngFLwYbzAN7epLC/8ItTEmgy2iwfuZU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qLr4oPvV;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755696885; a=rsa-sha256;
	cv=none;
	b=Fn2alsbVXBFePcbR0gdGoViOq8nB71CjDPHldEbQyArt0et4r17Llt633aMJwySFxrd6JM
	AnEMjXcvr+gYit7bdHRaup7Z2fV7eypYUhr3dNWqxXMH5PtZUpS5CEKvR7KnXPjnZawgRE
	QnCyfR7WX/J6g1boK/+4EyMO2AfyLm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32B5C61430;
	Wed, 20 Aug 2025 13:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543CDC4CEEB;
	Wed, 20 Aug 2025 13:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755696884;
	bh=fJG50JT0OUNU51LWIaGFHJLmpQ0f1RLLrMGdC8SZ9GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLr4oPvVb4qUicIKYCUNynW3uqKX1oWEGwoqtxQoEeUQpzfEf3A22qzmH1HkLQH9Z
	 3g3bycoIfeINnnilpl0gqYbgKGgXBqns8yLwNnHhQ9U4QUVnrVOoRjAt5wTTvjvuLq
	 QdbIzc31UmU7eols2VPyhEgVqcwGPWmbq7ODLLasi82lTOoeqhtkT1wasHyYNv4PdQ
	 YD7Oshwf9WBr9mDCyPb7FwtZ3nJa/aO02YRfHzp+2Wir87z7Rb9IkYcZQEcI/+asXF
	 7hYlPIJlz+6ZIbOBrmkI+WwTDck8+QAwjnCYZfdwA1aiBZLCJDGeY3BqPBZreysmDG
	 z+ETbpso4yauQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	pratyush.brahma@oss.qualcomm.com
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/numa: Use SZ_1M macro to denote bytes to MB conversion
Date: Wed, 20 Aug 2025 16:34:38 +0300
Message-ID: <175569679035.1410601.2889611634297884263.b4-ty@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820-numa-memblks-refac-v2-1-43bf1af02acd@oss.qualcomm.com>
References: <20250820-numa-memblks-refac-v2-1-43bf1af02acd@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D873380015
X-Stat-Signature: dhfczoe9jwx4xy5te4mir6w9mu9cqwri
X-Rspam-User: 
X-HE-Tag: 1755696885-760304
X-HE-Meta: U2FsdGVkX1/HzdgpKtnYj/cZpFFh082SmhRLt2MrKBWlfvetHCC0I+IBXdSBht9VjfRLOCoV+D0bDPnnAZW6wdCvCED23OLu8sPrFLN8Y9K3E4XL7Pqt7wNbpW31LWKhyFiDby6j6XvqnrAimd1BJxBE87X5v6g71dKmte3I/1l/TBTUmoDeiC53bRwAlKJlpDqVBPQVTe4vn8ccNu0taB3WB4RedS9jUGcmWKO/PorUzXiSAjEEibmS4r6T+RGZKUq4g/6c2E3/mMmKxIgVKO2wfm2g181cXPlukmjYWgFz/g9+jjIDPcqrYlS6uw8E8rY6AP0NbLimSb+819HqYWz1fs+VUVYOLcqCzLeVr5ahK0bvilFqStEiGsVmr5QhZe3fUHNX/lywCQC89MwuMksCGZvtK7Zk7qxoh0Ymw0SmIAHBEomGEk/5JGN/BDe64RDU+AQ8I7xDHNucx6UrytR81Qzz0CURNGuERzM1/ttL/gZIOio1qHovi3mPzWdOJyYO3EPHM4NB0QW3SLbrtivn5Ag4Y8Sj3iHD7k9wJk9sW/GlChDBZ++LDvAcJ+p9oH2zQQDhBY9G1ukW07As+MECAwx7gQGWBZKGAegKFp3Qd4zZkyw+LPBulhOx2LLoHco2gDpdajQXGl6sI54+8rbp3DtaFJ7lPz7iS3CKGyEu6BWoIDwPE/u/4T+p97X1Nc1DtvZzioaQaRd2KBy/TFjpIck9yIDWQRyR1cSc/z0s65XRxiIK2ujwG8rcZM0IPWycbfOU8O5pH7YAhU0PevdEdCwO5SAWqQNgo9S7sd3BxPJ11P+AZ5t694EhqhwWgZKxuNY9Rtm5cBQAbXPvePA2p1NZo/uqpDBLszyQb8fLy9xpyYeErFIQomBRdSYd18EZvFI8gu/EqeeVNNo8QyS0aaldvVpsGn1UcSjnduy85OIGtZzS3XM/k4y54m+Yj3U3aHhCNiDH7Y0y5kV
 9qiSYuTt
 KDlmq0pVR8gU+2xoaDmQFzL+e+XLvIVdleai2slbMhF3TO1/a4rlqcQ3sek1VGnlDGKjH/jdY179JUAALwqDWLB4APeh/IbG3fQq0FLBmGO8v16+pDs8TZRM4QCTBBvb/CxHo9uqv1OikJZLiFsy3nlGUnffiDbkC4MawFhtEJ3vUrg5rC/jalKHrY0O7/TflmTwnmLcp+dWBriaDh/u6c0B9LrRiGg4L2No0j3M4USGtEPtN7lnrP/SC4fzO8H3okO+bgOD72peAYX9Ke8zdlhbZ5C30jit2GHwePw7Cy/U027Q2Lq2jule95w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Wed, 20 Aug 2025 06:29:34 +0530, pratyush.brahma@oss.qualcomm.com wrote:
> Replace the manual bitwise conversion of bytes to MB with
> SZ_1M macro, a standard macro used within the mm subsystem,
> to improve readability.
> 
> 

Applied to fixes branch of memblock.git tree, thanks!

I've updated the commit subject:
[1/1] mm: numa,memblock: Use SZ_1M macro to denote bytes to MB conversion
      commit: 4647c4deadcc17f40858be06bcf416369a8f1d57

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: fixes

--
Sincerely yours,
Mike.


