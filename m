Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4946DCA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794CD8E0009; Fri,  5 Sep 2025 13:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CC78E0001; Fri,  5 Sep 2025 13:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9758E0009; Fri,  5 Sep 2025 13:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 59E458E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:14:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05A77B833B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:14:58 +0000 (UTC)
X-FDA: 83855846676.21.D1DA0F1
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5491C40004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:14:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=boDejP83;
	spf=pass (imf27.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757092496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qirg4842vXSI8wcxTP5sZqL8C5JuE+RDKuDJaU7fnCQ=;
	b=ZGhNGJr5DyNuGCwklLrxGFm+oX54VTzLLuKlyWoCJqN4+kbYXCw4fUS/NLyeGpW5GueKf4
	w3W2k4vdR6OL/C71mTYqK+QiX0eOIHXc+YwVZGla5/Ib4FOBoKHAA8kGxNErpBgUnB7woX
	RjKgtCwPBHWUsJGNYVmemLC2glTgqVw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=boDejP83;
	spf=pass (imf27.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757092496; a=rsa-sha256;
	cv=none;
	b=NTa6QrvLzvyTTCLE0gRfImaEXevBehXvYtAFwa8DItoyT/uzrg8yIoovE2uJuOi0gtdMy+
	+URChT2Cv1r5syXBeQQuAANIjntoAoJbE2URG8KKD/uheRFSgm2rFHUUvHE1KhOUSau4Nm
	8lNOUQnXhpuPhyUmQ/juDPpDMM/9ivI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1757092495;
	bh=/AhB4CQ2nuWJ8A8/U316hv8jOOa1C2KJNEDiEoM2kJY=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=boDejP83rZwIqDyJdwlUNbEjuWwQm0Sw7wSJ4hr2M88IpVUG5Vch8tHShhrx3AYLw
	 zH0K5/QhCGw24B/azv2cIc4eVWoIpXtcBz82EIN4o8DTPpzbH85QG1AtiTZqy0ax1x
	 YAVVDs/WqSQ/fXBFIfLQRJR6/tCcccrG1qyqHQoM=
Received: by gentwo.org (Postfix, from userid 1003)
	id 277F94028B; Fri,  5 Sep 2025 10:14:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 26A2A400C8;
	Fri,  5 Sep 2025 10:14:55 -0700 (PDT)
Date: Fri, 5 Sep 2025 10:14:55 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-mm@kvack.org, 
    Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mm/percpu: Add a simple double-free check for per-CPU
 memory
In-Reply-To: <20250904155146.485ab7def1b89ed7317b76ad@linux-foundation.org>
Message-ID: <7d57bb57-9939-df2e-243a-a0290f79c6f6@gentwo.org>
References: <20250904143514.Yk6Ap-jy@linutronix.de> <20250904155146.485ab7def1b89ed7317b76ad@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 5491C40004
X-Rspam-User: 
X-Stat-Signature: 9mchq769sgh38k4obau3z81fcdh5tsu1
X-Rspamd-Server: rspam09
X-HE-Tag: 1757092496-585973
X-HE-Meta: U2FsdGVkX19uHmlGi0g8FImBSw2Dgj3IWxf3hsCv3LzSjRFZPqwH61vAEWAM3y2J3SPrEveevdSSELgi7G/Wvq7b8lmVacw4xbPzs9OXKdSfOs2nGsM+TsDqBldOvy48O+UIfeWowl27KBRLIaZE7iv4Ozqf0MYh+/NL2vx9cbPJtxlzN/4BogfyEAaGcj4k9wkmBXcubEqu8vwI3yKcxz5gC5ej5RGgleFXi/lXl7JkITu1fUQtxbHYDg6YG2Gza10LrW21iOq+EIyyE0jwkTMSM3jByUPxfpUo+e/HcljApwXNHsAMdPYv1x61eGw7rlnRRJZC3FrGQl+RGhDLBX8qOuUZ9RnRNKRVV7zyQWPVKQ9ZVvTF3LCONCMJDQffCAPaqYp19gwPNUI8ayH+5aQr8hCnuEk+km1QBwi3UltZk13z/3ylrNSe4UaRco0CokfygTs4gTmdUvGJO2HMyDZ6TUrg1FNiJW0wEXsGOAxf9wg/RX9R+5bfQ+5CWUd1VJGqvTLbA+MpVeUktOUv2DbOqSC864YEJG3cMj6vafETx3g4wgfaGuzccEg8DFFilPPVujJK+W4DxaTa7oNcQuw/GYLK6yQpZFMvayLHmpIb3MK8HzZKBiiHudEGv9QCGJuz4CrK8fzJBluvhzsne06lIvIcEKkgqiLM0IH1Nnzf8TzJ0IGnqDylTLYUVEI+rNqu21BkPcwQXlySNEpbVlBHuZZ3JFKfa5rtpDKLkfimHc1uZgYPyNwSgQa+083iXUHlYDPVKKX1JPyP+RsoVC/kERMNVh5HRHU7WxADnV7uQwjqpM3pPq8a/bh/rqVheXFkw+U5bRArM+3Rr5yLB7Jckse1VM60WRz9AQfVuKhHRwfHKTNF4AbvKZczXjvOb5Z02jiUpU/TfbCyzZKkEhaegKYCdQWN0vP35BsnLt1op6de21nz5yTOX04rfSsbn9YAF0YzvpdK0EGJA+k
 XASTFj7i
 8hBriYU+Q6r09jcV7s+Dv8hVs6MhlRWQIeNhezUqaXm1NqILK8eCDkBj/Y6OtmFKEKqOEmPcMInIH/wR1D7ClCP/7iJnMb8h8eao6zDUKnr8SZXpFqldg069IDjUnJIEcYNO2o2qvX//gZ/w68nDWhjhS5BajqxdXaLR9bGIJJt2N8OCEFD2+qAy+9xF4PfvYCTavnkW/Qx7A/DTeeeXDQYn8DCLCEKZNSsMl6kDPDJ/2pjhaYSTqFTjll43fgyB4iseLWgrRu/v29II=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Sep 2025, Andrew Morton wrote:

> On Thu, 4 Sep 2025 16:35:14 +0200 Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>
> > The free path clears the allocation bits in pcpu_chunk::alloc_map. A
> > simple double free check would be to check if the bits, which are about
> > to be cleared, are already cleared.
> >
>
> Nice idea.  It's hardly a fast path!

And it could be improved by checking the bit instead of finding the next
one.


