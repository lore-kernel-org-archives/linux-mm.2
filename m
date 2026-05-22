Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B5FCD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79C2F6B0096; Thu, 21 May 2026 21:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D676B0098; Thu, 21 May 2026 21:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A426B0099; Thu, 21 May 2026 21:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A71B6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:03:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A11C1C1EBC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:03:45 +0000 (UTC)
X-FDA: 84793258410.13.673BFC3
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 259B1C0006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:03:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nck6x8R7;
	spf=pass (imf10.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779411823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wKk87Bzqf6zyI2T2MlfJ+TmLsi8WzInd0FzeqW5at+k=;
	b=qVoImJOJX3FlB50sLXDentZVofO8SSiw4KmX3o+gSkqybRFLtWgf3PGZLczN7zjCQ9N4lV
	9/qy+kEjzcM0P9N34N9ArX6OgH+ySQlTpNDt61VlmBougNpKCpPaDBtb38DDNUt8WVb7W5
	0ZxRC75a583n9HEnmOoZTxtAngbR/Us=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779411823; a=rsa-sha256;
	cv=none;
	b=A19hEKlRUlLHNFLP4Jc0ooXBe5CjUSKVrFViK0LfD9CO4d3Cifzu9jvUYNqPs1bPOF9UPo
	10UFGbaIK+T70HziGXXDAmFd84akoMeO/gcXKnW8vn4hvgU2/nPZwtBLEJ9PXdz+pBWEdy
	f2TqL6HMlsHr62K/TzjGU87KDP7WSmI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nck6x8R7;
	spf=pass (imf10.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-367d88b9940so4331306a91.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 18:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779411822; x=1780016622; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wKk87Bzqf6zyI2T2MlfJ+TmLsi8WzInd0FzeqW5at+k=;
        b=Nck6x8R7e7KWrTakGqdLgJE88JsPz0MvmS7jDhzgkge31mUl6K5xgTSGFtx64L/jz/
         QGfXNJw+c4bLmgi1JQI12qTW4zQi11gCk2kx/j2p7A1TdUpuZ1uigWKDlg0RA+DB97N1
         PZ2g9GL3yZJ9qbyPLpvbvepi6NSpEzXvmdSfgZtxicEk025StdS9ujlQz/uWBLo00WL9
         fhEku8x0ZXBnZ0bg+N9iOj/w86qbA6mpGIZa9/3i3XixvHTaz+RkpHCGY619x+ELJpgi
         4h7Nmy7i9MicTWGXIvqZ6uGy7oVGLCAHq6IzJIyq3yLA28f2M4naVViZSKNfnAuR3xfg
         Pyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779411822; x=1780016622;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wKk87Bzqf6zyI2T2MlfJ+TmLsi8WzInd0FzeqW5at+k=;
        b=P5uFSkvKDl9e6kuVramm92mWEO+Olv1qtZtJBB9duKzRdxcEo1S6G64Se7McbG7MmI
         p4cP2aBj39vIuoClOkJziIyTkXkH3dQkyAziX63ub5UwoMSexPT6Dlc29/9H7WyC7OWH
         ZfqP/AkdPlpy9vGLF6Mvu+Vib2Tdb12fHRQ/ZZJudlxncqoCNkqKIv6gFGm77q06bwK1
         POC+gsZZnp2vxaOvRuxJSjcgTPW97XR7gP8Rf4bLlMMGybORKN4OQYCwOcCRsV0b2eho
         xn22cF0T1qVisqqyc7D5qvQETfeUfFTb+ZEyy5b9W0G0S1yfYBGJJcoWM7aL0qqYEJpv
         r9Bw==
X-Forwarded-Encrypted: i=1; AFNElJ9PYu7zDOotjLHzynrSqJMi8RwZW2oKztAPTttAVEth2PY2bKu+pLeJ0yuSsPIdsHV59+Tsw2tNAg==@kvack.org
X-Gm-Message-State: AOJu0YxtW56qkiEeJn2BLFI7MQx+qJYPxpvyzUjjmscHyFOzvtv8+M6u
	0NooAQpG2uWENDBy7BeFfPjF/XPcOMapLhio/8aCdWfUHLX3HMg4bcRAUEYq7w==
X-Gm-Gg: Acq92OEdOOWCq660/IYhOK/x0ZLRLM4JOTd37i8JQrKOkBj/JyludhLGvYBmTYl1lW2
	2QGuz9+XpKODa6mmYgMt2l0ipHUhwe2F6XNLI5aTqhtnR+gu6qGOyyHdfG6ka7a6EnZSa0KEg2s
	WRiQzrc/THtMJHxu5yjDaP2ACHnFlKXRRHDfAtLnmVk61WAACi1vdbXT/a/7c9DSc48ZG7uesNJ
	KRydGsunBHKHnA8v61gnIv6DEOPX8MfQNlhmSKtwoBoGRucFbcZ73aYMXM6slCgUJc6gA7Z61LZ
	VBVPIQJDIXjUVgBc3uwlpR6zosVZisze3NZzDEvOCbpQ2FVxp4VA7ZksrJ7LtHFDFlm/wr2f35T
	BYV7zIT3lwOA7oCT4t06J6VbiWzLmVIdMI4LQYSvAkbEihRfKdhJVG7/K0uJRlfg+eGPg8ES4cU
	lJjt7q5jPXiHpx4Ncn0sN0JVdSVPIU4g1vQ8As3Zyo2HR9RL5QQvBcEG6seCLlND6sog==
X-Received: by 2002:a17:90b:564f:b0:35b:e5ce:73bb with SMTP id 98e67ed59e1d1-36a676f5108mr1245665a91.1.1779411821776;
        Thu, 21 May 2026 18:03:41 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a72c98b95sm189315a91.16.2026.05.21.18.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 18:03:41 -0700 (PDT)
Date: Thu, 21 May 2026 18:03:39 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam.Howlett@oracle.com, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
	leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
	shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
	vbabka@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <ag-ra7N7KbUxXPyG@skinsburskii>
References: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
 <20260521163309.c5cc5d3f6cf16bac212cf90b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260521163309.c5cc5d3f6cf16bac212cf90b@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 259B1C0006
X-Stat-Signature: gks8cww8ypseci5bkoak3py4b7ac7ppt
X-Rspamd-Server: rspam06
X-HE-Tag: 1779411822-815119
X-HE-Meta: U2FsdGVkX1/2FrYcvQGj5Hc+lB+UDDuDYecZmIP5tiiTQQwuyhHQ5QRY/wFFiCmN2NCt0wnYEHAn1fGqstCclqzsLyiYOCESkhZElIV/DFZDN1tthlQdRmb95eORxwdliANQTeFM7McP28aPlUKF1lxWD8ewHpsH+zInqljtTFpsK+wVD82QRUPvfXegohup7GHaFK8jnuZkKexcCnSJCkabzTr+i6meUO6JkaKtbVNZEa4C3fJ4i4VuwROTolBuuuoMWTOIBcQdxhQjyCbkf5qu275634pZnz1afkimPfn5faBucnJrMUIZWr9CibkSCbH+nn/m5rj2cQoPsOPtljH794vCo/6T1PnCRDixuoawfhL1BCcIKzumhtW19/nzVkgYFgqc9S45R7aXH7MKq2gCa7slTZay7DXlK8J/lK8jWzkRIaO9xwnBCOObz9h6xec6u90EFKCzM4t1e31h56ERNP70WoQ6Dk+SSoJ3fL0L26MR9dj7FKxWO1DR1x82VwSD+YAkugn5Q3DT/xwhTUu97ZB50RS+Au2qtgHW8jaTPfEym0ZkmedACDVfYdVI659xBG44xynGbkAl/yuZq8fDsVfGp1RTT+02RI6ER5PNxMStJET/qCJOpDdsNE/0OlFZ2vzthcOQfR2CtmoYJRdxW2qo+xk8B/18a27EyuBrw3Tt7Ho+ckqJDHmSyGkKyIMfCOR2VdwDZl8MroJpB10MPd/7eRe9N14MGkrPhWv2bjRa94Rp4gg3te8tidon6h/Jczvf4ALzjgSEPTQChHGc7iplNXep+QDB0nqvf7zXfdqKwBAOMul/omgbeXS35fNvhXVm8sGECaRzDWXWLaIeKQGVJ+77+/5vd7P4A9NaItaLkRoZa4yR098xRW/przGRf1W1+1by+t9jrmlKW0P/g/65b7FrmZhWEA+SDj5gMSC3hHRRLSyYDhYtTQwGLp8KRkY0dukhV2Sf0kX
 6h9/WOeP
 dHqx0pAQ9G+f1fQe1lzaGsSvVdq78TXJmTyQcRErbr497rTK3BjpyR6cyMnkL3QmfAWxjZv9mc6JcDrIwh50U8lQF0zQIDVB9fSA4fxUrKJVWGFIOHu2z2FAcbVJvqB21QC+6lBKEtcDw6onZJylKuzlaGmnZpdvLjgQpi80BHw2xmSaNpnyAP3/NFiVO/k8R2gTfE79Z9+RWvEt0NThrFBgGolZWWqFzndXFMbt1UH7pT75Oi9JabswTCg1/K6bzd+VhW9teEGAOR1vGel3i2DgfC3hVVgaJsFExM33DIeDHGd/NBQbNnrzFFX6zR8POEcgC9jw6eTt/9lKkTyr6/iBbBm8wo5ZTmuDdfvKoDMUTDWk5gPgZa+ndr5/3bziktQltOo7tlHCBt5DFpYls2m9a0zYJos1BUot5EbgyxpzpifBUo73vfxThKaJ6NHWPh10pEKr7HktrrDG7PB5RXq6nv2zKrENxz1KP6fgEpmGLCJP4Qi3cU9/baQJyF1moiuHLMBESKVcMqsFKaKwIbVVeKKDrM1zOd1x/X6J6hwQzaCCF5+6FRzQNlgqRfI2/YA/qrUcwt/q7cTZsdveajMejng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 04:33:09PM -0700, Andrew Morton wrote:
> On Wed, 20 May 2026 07:09:19 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > This series extends the HMM framework to support userfaultfd-backed memory
> > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > 
> > Some page fault handlers — most notably userfaultfd — require the mmap lock
> > to be released so that userspace can resolve the fault. The current HMM
> > interface never sets FAULT_FLAG_ALLOW_RETRY, making it impossible to fault
> > in pages from userfaultfd-registered regions.
> > 
> > This series follows the established int *locked pattern from
> > get_user_pages_remote() in mm/gup.c. A new entry point,
> > hmm_range_fault_unlockable(), accepts an int *locked parameter. When the
> > mmap lock is dropped during fault resolution (VM_FAULT_RETRY or
> > VM_FAULT_COMPLETED), the function returns 0 with *locked = 0, signalling
> > the caller to restart its walk. The existing hmm_range_fault() is
> > refactored into a thin wrapper that passes NULL, preserving current
> > behavior for all existing callers.
> > 
> > Faulting hugetlb pages on the unlockable path is not supported because
> > walk_hugetlb_range() unconditionally holds and releases
> > hugetlb_vma_lock_read across the callback; if the mmap lock is dropped
> > inside the callback, the VMA may be freed before the walk framework's
> > unlock. Hugetlb pages already present in page tables are handled normally.
> > Possible approaches to lift this limitation are documented in
> > Documentation/mm/hmm.rst.
> 
> Thanks.  AI review identified one possible issue, possibly a duplicate
> from the v2 series?
> 
> 	https://sashiko.dev/#/patchset/177928604779.589431.14703161356676674288.stgit@skinsburskii
> 

I think this Sashiko finding is a false positive for current kselftest_harness.h.

ASSERT_EQ() expands to __EXPECT(..., 1), then the optional handler calls
__bail(1, _metadata). For assertions, __bail() calls abort() after
fixture teardown, not a plain return from the test function. See tools/
testing/selftests/kselftest_harness.h:521 and
tools/testing/selftests/kselftest_harness.h:962.

So for these lines after pthread_create() in
tools/testing/selftests/mm/hmm-tests.c:2979, a failed ASSERT_*
terminates the test process. The background thread does not continue
running after the test function returns with uffd_args popped, because
there is no normal return from the assertion path.

There is still a cleanup-quality argument: aborting skips the explicit
eventfd wake, pthread_join(), and frees/closes. But in a kselftest child
process that should be an acceptable failure-path behavior, not a stack
use-after-free.

> I'll take no action at this stage, shall await reviewer input.  Please
> poke me in a week or so if nothing has happened.
> 

Given the explanation above, I don't have an intent to address sashiko's
comment and send another revision unless you are certan there is an
issue to fix there.
If you are, please let me know.

> Which is quite possible - things seem rather hectic at this time and
> we're almost at -rc5!

Indeed.

Thank you again for your time,
Stanislav

