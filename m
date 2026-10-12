Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C21BCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D536B0096; Mon, 12 Oct 2026 09:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127606B009B; Mon, 12 Oct 2026 09:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31EB6B00A0; Mon, 12 Oct 2026 09:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D21E16B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:33:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E0FA80D21
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:33:17 +0000 (UTC)
X-FDA: 85314065634.26.B3F92A8
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8EFD54000D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:33:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vEKRo+2I;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791811995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yx58x2by4kjrlCwmqxXIEZOCdo8Oo9z3g4a/nl9RyYY=;
	b=4j/bTNEDOK5ttcw8grsf1hJ7WOlSixBryBN7d3Ox3gn/yRROhFTI4/59RTx6gECOKApWtG
	/DCPNXIUIV1XVVRltwPGSyoHAG/7KnPLyDSlnTTy74bkQ/2/y8RZDCeE5+Ri7FTu9k7v5O
	EOijS90oh8qzs7U3D+20DrxPibUOeYk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vEKRo+2I;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791811995;
	b=rqbJBexPhzffGXTMzsTAsj/cJo7GIg1p94F1TatSk64gnFydPIz1Qr7lMxNHzd4UvISs1q
	oEeZapmTpNzp2JyMLq5pfCd+lTI5ZvpL2fQoUM/U0VSRySlw2d/5K5lnWRrxo4BIWzf3vW
	/6Z2aBH5vxFE9ckdsl+ApcXhjwtehnw=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93e63522076so142980485a.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791811995; x=1792416795; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yx58x2by4kjrlCwmqxXIEZOCdo8Oo9z3g4a/nl9RyYY=;
        b=vEKRo+2IVtwZ1xRvC74jDTzy3euexVhWtVM+76v/MKMnCybKe3hAFGM/xZBTqUg/g6
         QFLjdTDRYkZFN6pbpKIZ5pV6cRdieruFleD1XmklCFm/PJSc59qrUkSUd6hig5rdUPrO
         xTQjLbtUH9fqeauwebUUh/J8noKYz0vCJYwDSz71iDEuwLZpDkIzqLd8JNIXkr31Am8T
         yNEskjKr9Sdg1fxWrj/yahMtbQlf1vcNt5jEFSMYdrcELUC3Npqc4H7FBkoKMbF7Hun7
         dgPn28y7bBlQ4Wn53+oDng96HuLOzxcGHANfOeJCVSwGEy6uIBiXxTdT9U27dBULwBHS
         q7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791811995; x=1792416795;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yx58x2by4kjrlCwmqxXIEZOCdo8Oo9z3g4a/nl9RyYY=;
        b=eeVwvz4oC6dm5D2LdZbD9PErSvTZD9iSJPLxS0J9D3Tx1EHcw+nargJiy6wReAzTN2
         Ru4mIPWHegyybUQuEfyfnId6hwP668+z7FogCOj/BGPWQh9SMxgf5MO+OzhcL4P//s28
         eD8cfAs7Ih32G1ABtpKpibMz1cbALCKj6F/yzVoNPEHf5PXFPGKomgfsMYvmhcaPoi6M
         9nv2iHhH/oMH1W0Ksrokib69dvbqsm1PFkED0LBlRkL47QgfC4O4wRLkAJxj7J8VqwIy
         qUpu4qaPrwzNThUsTAfQ9vwD4GGRu7sXQ9+mNujudOmm/PY9m9IafEpsla37NdDjbdPZ
         yrng==
X-Forwarded-Encrypted: i=1; AKwUvBzhhVlO6vF3FW+lpkZYCNry79653ug4S4TRzD9YYp4Az9tFyukctnC4XDm4fDnoFutjP23dU5nGfw==@kvack.org
X-Gm-Message-State: AFq9FYLZwvOEVXf7HqpxWyTVQ+w5d5Uk53eOK0Et3Om8Cm/kv1okK7hP
	u6OrnuiqjWKJY5DJ1wKa9Qo02LIXFJ+Jc2p9pSlQ1/BuRKacyyI0VNfp82jIDFoolQQOkXWBfZ4
	mRMEoVL0=
X-Gm-Gg: AYBFou3IpobagMCdJSy4oy3fQ0uF4yVRV30J54G0eeO0wBP0xv7R0Z6zWkZdRniaRJY
	rCGtt42KUEOzcelWgZreaNxtKDIjuon/XKdlhykKKkUxLNAgYjFcFUYluPvSZzTkwoqQ7Zl6VGZ
	1mLjJzkmAu9un99UNpULOf2VUTD1rjSMeEVlJ8082uN+YpvIzZl4/a55WjINaE4AiCJAmPU0nXs
	Qw+KdRdv/NxhCMEE6JCqcB5gQI0tAYIWTEleTonoizk8cfmAq0IFOGiipwG+BW+dfsEXB6ARycR
	KpcyIZndCrXoqtIjSMHvGpWkadRJ3B57oofq0m53RD2I2xb6APShU92tURGYAHTnH1/jJ27LzKr
	9UJk80+wFRUTUPWT/9KKap5NjYPzNuAAY/V9ifZQ81a25ROFYm8mzar7B96T2ZTHyd2vLHlpOQ9
	R8VZ6RnOFx+I5K9BvMerWvQkcvVZw5TQ/dNg2WEVrSchjLIfL1s3rYvicfbnxHEhlQYd7I1Qfd0
	gSFbZhLfPXUVybNUjQgFikayyvaPuszLL5lJvkrFBASlHSYLq67QB8=
X-Received: by 2002:a05:620a:170d:b0:93e:653e:6981 with SMTP id af79cd13be357-93ebd0cbff2mr1628926385a.11.1791811994577;
        Mon, 12 Oct 2026 06:33:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93eb98488aasm855431885a.7.2026.10.12.06.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 06:33:13 -0700 (PDT)
Date: Mon, 12 Oct 2026 09:33:12 -0400
From: Gregory Price <gourry@gourry.net>
To: albin_yang@163.com
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	david@kernel.org, vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, albinwyang@tencent.com
Subject: Re: [PATCH] mm/madvise: add cond_resched() in THP branch of
 madvise_cold_or_pageout_pte_range()
Message-ID: <aszhdUV9M8RVZlx3@gourry-fedora-PF4VCD3F>
References: <20261010024042.4070048-1-albin_yang@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010024042.4070048-1-albin_yang@163.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8EFD54000D
X-Rspam-User: 
X-Stat-Signature: 7uadkthw371tyudf7oy853kmbxrdmk9c
X-HE-Tag: 1791811995-834357
X-HE-Meta: U2FsdGVkX195Nci9vjd8XTtaWojEGaHcZfQrd2gTE73G7vgi6169EKdzFVis4w33d0Z8iHgTF10NwrdxjPeVCjn941mt8hal1txntGoz72JQEWosdeKoNYRgft1TsDFlzJm9ljpe5NexLrjo9hfVfvM9fQkeeNI/zAzUyHqU5I+aEMdBOu+XMR6Jdza7tPxsRFzaqBOJOO3qve/TMHH/Qh6S3xSEt+FURE8Z0aMxOu2xv/0Vy8bxGuCcIX4yWP6rlGdCNHRTKppjQWpyFpnlnMtnE0slFwyP1C7MO7MR4d0DX+cfpphEW5Jk4bVw2NFtxBYmSPczwHpyIwmy13gIWDIkwBB5NwKznW1UqTlWjhXbL3qMwdsDKUKoxj8MXhCDve0CR9PiGFiQbrNMPVPCBoi48gZVMA5V8qG85NbnU+OltEQBtO9ZxloXF3G0HWudBaXGP+2m/uVTCE2CEk6KsCKAEeQZLDM2FNV4CQbBVh9sziuJygiMGvUctiY7ddkgnxD3ZRuUin3cJ2hAWnS3XJv0qKAGDqCKKtvn9mzjYHpAFtktqiOTq9KP5bumOUarap9rnfmixgLxXrjJAKu5yEfjD7opdKkj9mMx0YOFr//gG93zkFbmQVYVuNa7COUwgQV4hsfBGEh6AyZhhWhQuCIz3YJzyv07BfS2Qt/pyIK9X3kfOJbSD0WhdC90h29Jey7MRz0P1/pqUchGvj3L2a1pMkKBCB603BGVQ9NBvF8hb/FEo7G24cCLkPN37cuHZr8g+RPFuN+Nsv5r1IZmsUMfEBcJuZvomlSfK4XdTz8Mu3XLSTmeP7bOq+7+k40ry39mOfOBqJR7A3g/WlsbAA0EKz1OMmvm6/0REzNjUzoX97OVbfHNjamcM+8GcT/OhKaw8SqK2aFAA/B0f++CvTc+hhq6O7y0PgPt0GT7bN7tiBcijsza3c6pLgvGqsZuolMo5AR1XN/LS8A+kp6
 OrEcLfKG
 m4jxsyjNLbVRkmf4XqdW03Wh0eq/AZNpUfythfKeqab6LD4QFJm0SzlJ9K2tZLBUCXO4jFpDE35TypAKUpXvIKMZeaRVTPBXilpseh3mYT0ctANF8xfiOgcK48/5+DTkMaKBjXhDX5Uz7fKB9IJsfLkYWClqqWlwpQZa4wZkN/WFVWOnrcOoL4oLbfbr+CJF3vAQ7q8Kyux1kBYfTkg+IJ/668+UK6WJycq1jzXX3Xj8OofsXt315i+g/2mqxgmiOA8/Qqa6UOWlFB+b8v820xuSgtN6QkzR0cwJfPWoX46kKA1xOLrtMb9ok83q/kQHZuZ/CHLNONxbiAwzMbCCQ148n92ous51+gOvmfXb/sqXxc7G1Ks2x8HpmvEqm851wu7Eix2suzQOR7QpKDC73OdOlpNi41uBz/bw+5B4py/xLU5KKsj4RH8EdId2oB2uOwY8YBvivDOY+4Q5x6zOfL3IbzIPyL9DryPb+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 10:40:42AM +0800, albin_yang@163.com wrote:
> 
> During stress testing with stress-ng on a 256-CPU system, a softlockup
> was observed when madvise(MADV_COLD) was called on a 31GB memory region
> backed by transparent hugepages. The region contains 15935 THP PMD
> entries, and the softlockup was triggered after 14485 of them had been
> processed.
> 
...
> 
> Signed-off-by: Wei Yang <albinwyang@tencent.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


