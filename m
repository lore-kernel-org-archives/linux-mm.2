Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 560C8C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 18:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39FF66B008A; Fri, 25 Sep 2026 14:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350486B008C; Fri, 25 Sep 2026 14:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267076B0092; Fri, 25 Sep 2026 14:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01F706B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:05:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80C9B806A9
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:05:45 +0000 (UTC)
X-FDA: 85253062650.19.6504552
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf17.hostedemail.com (Postfix) with ESMTP id 82B7E40004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:05:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RmV8RCtB;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790359543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gfl4b7+zGwYXjBAY/2HSLJql1XSMJI3mCRWp0qvuwyk=;
	b=vrir5hKqA4EdfnrOiFxLMsNYzgFwdUeet4sb26d3C4MKEc7bRiQMPRQcJOZGQuluumy98T
	DAsulech1T9dvPtbBN7oppNFQFUYYdF5hz3qteTr22UWs/eKEK0iwYtYrtIn0jWJcefgX+
	Ge3XXf49W8w+bH3fJxHy047PHYWR5rY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RmV8RCtB;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790359543;
	b=E/1c5hjvgpOqC5d79waVtmPFmA+T8EJduO7FjA/LsoLfqoO3JHSfZXq9Kh+Hmz+EUNiA7I
	oNKP/kIbfFtjh+UkvIuKkNsNZPVy8Vge7jIR2DRO8MlVbQ2GcFjMqM+4Cq71KwLtR68wNF
	YBvIjeQvXUVkvO1YNuZBWja2qmh+Kuo=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f63546c5so980929f8f.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:05:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790359542; cv=none;
        d=google.com; s=arc-20260327;
        b=mxLskFJ8+woPjqTDtwkwsgFnLxpfscqhyU1ao/cpqvvHTuVpJjeoYY/1g4IpswKwjx
         DVSy7X7pMbMWNCFR+0Qxqqtq7Bbg5dvQ5dLmGBggzBdheRLQu9YCxbl1i9sIOtwXac7l
         7Y9MzzBX05KTAmNoDgKtSMNcZbvQjm87lKs9HdFoOnyqC03al515KToRRGOf/7mFZSwD
         1jJCrE46pynPDPqPG53niZCAEuzuP2TSMrdBrPbVo1AeqaJw4ESotk5o1/cjjd4lKQd6
         YcJ6Y9yBIhakDWjNUba5UM0V84WZwmOn+6Oo4tT022g60muVqtLcXd2NTlGr5xCW4Fyb
         xEeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gfl4b7+zGwYXjBAY/2HSLJql1XSMJI3mCRWp0qvuwyk=;
        fh=1yJlzty0VJnZ85sA7AkEjFNa6UWDQa/h05DStUdWWak=;
        b=e1L+yXu4qnkzHHr2wbiyXwfZVwfCiIDAQU9HncPNb6h284bSKTBtLuwb/S3/Da7m5u
         RhAHAQw9HnUZL8fRkjVO5CWq5vaP3GwdjLZKtEG64L/Xa4YTnaaaHKqctw5+sQeurP7d
         73w8dyFuDpynozzeRx8Pg64NGBchhX2XuGTN7PwV3YVJMvlRaGV+2erV1fKTchPi8KRo
         x/QqOh/bbiXfv01IPQmXGbVF2Tp+2qQz4g5oGNwwqZ2PtsOWDJ4vCA7hYW4zJGMN1qUw
         ACyXsxiMrTpMeRQEIndwOOkHxQz8+FF+pTFCgcilH6Uxjiqe8b+yxZ6KBh2PuRCnSq5U
         JbNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790359542; x=1790964342; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gfl4b7+zGwYXjBAY/2HSLJql1XSMJI3mCRWp0qvuwyk=;
        b=RmV8RCtBSMt4EarSF808FBTHzHH5CR7gQwIPq9Unq8DIRI0Rfh3ZfyN0Stuxc1xyYL
         SlB/S96EKEDtDQi5f1r2XNNUMLrIV5H2QwYx1YOPs6K1U7WLepSbX15G/wbwOglYG7eb
         b3qddXtpOcsSUEeij5Wb72C5Fy00LxtaPDYKylA+AWbYRQPnAwS7OVr7JvA2klDCfjQ8
         a/HMxVjIppzbrO9h6SztR1stjyzM9r9a2sSY2cNhlRV34rkbbATuECrcKd8FyeTN2J70
         c5mmZOtxn0+nTj92U4kzN21VvwtTxSHGUa6Xgn7RcoH2Duy32tRsxH9zuDF9TX8UD2pC
         Xjpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790359542; x=1790964342;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gfl4b7+zGwYXjBAY/2HSLJql1XSMJI3mCRWp0qvuwyk=;
        b=cvQ6jx9UBeWKhzi0spAbHgrnqirwdEL8e+QZ+UJLvwBOhIjuiC2SKDuML+CZ/52+Ci
         9hkFeaUbRzx/ZQMHxn7pUz7PN80WXx1unXKON8gGVZBd2xJ0vOe7eXE9HgE9PpPt7xXp
         4Vp4/RomUTlTPvzc3oRl5lOqngu0SEW/5RwFlIOlJWesZ4CaOwnGRNI03f4cTFlqAc/6
         g4AQHusfZilOyTENJU5n6WS1k7lRk0/6LkZlgY2ebU40TWg/6RVf1u1wD2vhAuVEyorr
         UqLBUovjI/HmvQcZbZr4NfUFulJD4YCUlX6N6MI0gVI00vEgSQRATS0U4s7fWQAr4fq5
         oodA==
X-Forwarded-Encrypted: i=1; AKwUvBwIdGDfe8Phqn4/oiEnSzajYVvXQPa4EUIBMkvB0J39BTKy84OsXWkTyLOuuXdd2myPIsDonYzmyA==@kvack.org
X-Gm-Message-State: AFuF++m6YCLRXP5f7usfnRclDMlKMK38INzNXRg9ETfMMR/kN45Z6Pcl
	Kcbjhv9W4FIZxRm+7vVDTlYXWMpvrNCcM+KCMUwTxIwf0C+yfRBuuDBFdHFS6HhqiWsqGQs3h8n
	bduWwfi2EAj6IlEcGQrSJSgyPA4ozejM=
X-Gm-Gg: AYBFou0C+vQSsfD2IIyhHX+W6GAg2tDqUWzzdCc9GGJlUE1FLeIm/mb1O2JhOr4mS7A
	wpgounJlmJ2tbMGKeYej57XMofUPx/s5cF+K3XtP5Gts28u3cTfH0J12CMhD186l+Ln6R08BiyV
	SRBTCn1976gmtNhuHGmqGnx394RJb+eLex/Dk3YHqybdF7gRk+kS+KtgpnwnS8aKsCwu7Br3+gz
	4u73OCIifKOdTz8wJczlmrtiJltYKmLJVpoHA1Kof7F6FSERsECdJU+u02K9G1D0zJQFeTXib3x
	b4S5j8zO1Mxo1kEB8FZTolYWYrmynTXJ1mCpLLatuFGU+yyGGGPzYINALr+2ufsIRikaAZMaOZ2
	93jWtEN4jUvtGhFDkW3qLrw==
X-Received: by 2002:a05:6000:2284:b0:488:8011:6834 with SMTP id
 ffacd0b85a97d-48880116940mr4896261f8f.53.1790359541945; Fri, 25 Sep 2026
 11:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
 <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com> <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com>
In-Reply-To: <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 25 Sep 2026 11:05:30 -0700
X-Gm-Features: AclHuK-FobqVPyDTMFnDSZvekiS4h2oZG-GWPYqDDrJKQs4ZBSnYi2HsqkCoGUU
Message-ID: <CAKEwX=NQtWudSHhR7-bbL8PuwFEW3uATj39DhSG4LR+mLVSusQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 82B7E40004
X-Rspam-User: 
X-Stat-Signature: ks8qbbu7o81kb1juc5wafsb3ir9ygngt
X-HE-Tag: 1790359543-16438
X-HE-Meta: U2FsdGVkX19g7b3YdWfG45sbB0sjmnky73e/odD/+96e+W16xrghbwJFsAh6jZUVAc3GkTfufdq7LoANR+FCjRSGt+UknJS0OFkNx9Zsfjzf/XkAWXqP7Ess4YY7AbRzJeiQJBtKs5d541R63I9zNq3uh2Xk7M2Y1L93nNva4PfyHQq2RuFxkZ5JpVHWMC/TgssIKfO8kVHvIvS443A4GUzjY47lzRxhdAI6JQaYolwEm4HwuD7Vo/lbgx+fm567e1EiHTFSkLOFodBy+751nvWe7+uWh9mPdO6fbBVrv5IDColaHqFFmzEvt0/BTEZrLEiHybXvdDgZZQneZ6DUxraYXe6wxysxzsBlLU8wMVz/9ZarNis2voDrKnd7Ehbho7Wr5V2B4VAy0JZF6G/+RvOK+NtKHIwZrTDMv0gp8DjzSxJTYC4xq0vsHQIPTXJpfwPDVr9HUsPj28e+TwwQX+HoLHKwZSVLx7dHBmUWTvmLWETM825AP0kARxBGM8SrYYCczfcCKPeqX/4sgvJBM4OTJmsWi4QuVMkJkhfUOKh1cpjoZYKF5qJD+4I7G6EOXBpf8r/UKZ7NAMLx8LJQ/UcoLZQAO2Und0nayMt/sgiG3h4XLWwLQykY65gjFGjWufnwaYKGuZ3med7KZihLuxPUg16sOMC1xZq1QBw4uFbWCu6qLRDmv8+orVaEm4BZcNPGmvn8aXU9SDAzLa+CbBMbYmD7vO0dZte6rMrpRfjwtrEbHkToU/T+uD4vYFe2WRJuw97iRgnsId2TIed0WSGcFBJb0KH2qDf2BrdHJsuA60MehCFGSFA4rcGBhMXKsgFPxRf5GzZT0VdZt29F5PbFI6JiNoQ1phNqExX+cj31GOfEzWupDj+eeNgcLPDyvF832ClEozIidULxuY81TnN4jhtJh6wKpQupRTPlTev0AvixcGklhfk2Of3m+o6OtLm2aQ8TWOSEG7dFt59
 UhIBvMkk
 bYyWD/tyx0z5NxDQ2v9meFRGHVDZRcCV5/heQkrME7SrQ/GnviNnrhwI0PLNdCYwdJxuQwJryKqVUbwUQ2Ty8E5T3mey693MnR9qL8oSRaMEZwLhmcabPHX9QzewSAVE1ueckOmXKZX18YLJ8fdZaRoyptH7XqrLEFRA1npaKZAxezjwI9WJDv4wMwDUQs7iHst4sCtLys6/HKm0Yy2czhSHMK0UYKrL12GzDyi2JWuUgqcI4n4XKiU4Cq2KyNarH6YHK1ZIhL3p8MWQsnUUTFAme6W9Md0OD5bQlN6G92wIA525JrlwgZ8vueG+LFa5005RwkFugNgK8rQgwIsJiQXbLOUpmO5r1pcqhjR0hTD3Uri9VhSdEvy8s0Q95Ci6o8+8tVtgZUExa0Vy1qn7v2A7/ioEhy8f4QP+hDhE+jAarwrA+8vm+jKzN/kTJBdFfcGkkP2I4H21J97w6BvjQtUg0CQ+Ejpu5Kp7p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 11:04=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
>
>
> 1. It moves the metadata from a new dynamic cluster struct and shoves
> it into the existing physical struct.
>
> Like, you can check patch 11 of this series. It's practically the same
> thing, with the only difference being ou

being our interface choice.

Sorry that got cut off. I must have accidentally deleted it.

