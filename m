Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D1CCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0D46B00A8; Wed, 27 May 2026 11:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91126B00AB; Wed, 27 May 2026 11:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD926B00AC; Wed, 27 May 2026 11:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABAAA6B00A8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:46:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64A8790CD8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:46:01 +0000 (UTC)
X-FDA: 84813625722.29.7E4E8C6
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 95D3A40009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:45:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AVYEXqRp;
	spf=pass (imf07.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779896759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lKvMOV5uJkkVkdu/ydV3n4EuIqaTCZ91Ux72HYHzFZQ=;
	b=NSq5xzXkzlNiYGTuK7T8ia7t47K4eWbE5o29CSYyYq2LQpTmzf4hvQGszcj5RvztxK/GJY
	K40P5kD/NOu7DT5JPBUu2EJLRKR9mYOYfyZjLVdyyYxVLHmqGH8T5F3sktrS1xsHnBJqFi
	9BKCMnI9PZPOByazbkUdDl+70DxWphA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779896759; a=rsa-sha256;
	cv=none;
	b=GNDT6wZSQhlr4k9BDnPSPkk2VhI1oUYtD4Y3RfP2U8oYZnGD5oxEbbv1WGE2NOoSk6Lm0H
	A4nJ+Q3p7mO8q/MjV6K2sVaVa1NWYI6GYu4Dg3UNhe4rxve05I1kLNFFpsfQ+D7rtBUITs
	zgKxCPS+c9mcfh+xMEYSGD6mqSjiSYE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AVYEXqRp;
	spf=pass (imf07.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso64155175e9.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 08:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779896758; x=1780501558; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lKvMOV5uJkkVkdu/ydV3n4EuIqaTCZ91Ux72HYHzFZQ=;
        b=AVYEXqRpB8Hm8HW4a2gIwDsyzHKq0puY2Lh4fG/QTGIl9Zs48Z4zKv5enNrdquIAES
         0b1z1JmFxLhIClkWdsabKseVmXyQW7tNjAyXzkqV0ieZ9Qz8T73bAo3hURPfkAx8wZO7
         YhLUwwstkIi7sCI8Yo8QE3Pgz6BHVRo9BptLIiRJM7Y92ev8CswiAMmFoFkOsKv++r59
         z1lFyTVzn3NcC0wqpPLMJYc0mOIrFz5r3aez4Mp4a+pIqCvNB2i8sVSFw/CVaA0woPVK
         T6FUsBuq4qzvazQXy9fpdJ6NPGPA3hbvdprF9XyPT9No7HQoghkLjAL69vIK/fXTGBOX
         9ecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779896758; x=1780501558;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lKvMOV5uJkkVkdu/ydV3n4EuIqaTCZ91Ux72HYHzFZQ=;
        b=GX3PAoU5Vzq6EZBnIr404jtQh0+/OqlIpPhOHOTpdlMe/fo/gm6be9J6m+fw53VwxX
         div0LkcVfZblhDKU+rWH8R3gBI5I48WIVOrf7w9DXnmo2mqH1YNNx8Gb/cq8ru/wYyhb
         yS9JKr8v4Lyj1Kc3rFXbDsp9zYzYQ3x1a7HI7nYo44YhseoQeflcxrvNHdoRLCiQPT4d
         ksc0GHIB5OjB5odXPED+QnPAFiAstk6yZjMFzxZuL5ILQvpFPKe5I2z9hwO65sSL8/xt
         eqfkvTm84EDZ9UCkJ6HBvbV9cL/03r7NU6trXFJoWkJ1ZhZyvmqAjfzQJlNdn/6TamY5
         K00g==
X-Gm-Message-State: AOJu0Yww9+SI/VZT2pmI1zagNMysSVrxCMsmaxypmJpMFslL78TRk7zE
	eRNcfrYP6ucJsKTn6ezK2cQQ3W67kgB5QbedSsuL+NZfDqyXKNv1SGem/dF7Cf9D
X-Gm-Gg: Acq92OE2i/yt8Yyqwa3uRHgsvuTkjH3FiyDKjlTesq9bCBhuDR5zbm1a1A54Z7kd1IJ
	G6OavGo7TpPRzsBIpk4eCY1F81vDS3x1dnsgTCTnCtCg6Tt3TA7/t1rgw0JmMrhhnqerpawk63R
	QNmLw9g/AivQTTI7mUEvNYoFDfdmQRf9J+YQx2KFM6dqxrcFz+wu7v2ABxPAcD8lA1Qo+2l8Vas
	PtCgixH22BegpbOJshq8rnqCwDihS8rYUaZ0T+btPqOEWV21dBC7N3OQm3F+fwDM3Z2bmJyJSMQ
	IWcjo6MNacL9u8e0w8WelUqwhsMMI0LqZ/lv0lqt4vD10OZQpQT07vqk+u/VE2tGaW5n3sOHmkf
	BtNrqwimh9uUSUyqoHEyVbig3kY5ABQkvonPWgXal8UEOy4/sAgz2uzLWZO/WroUqQ5C3ujOhjj
	hl05Us2d4z9jQZuR0+GdEtYZx+i5C9U5AFx1Y7Kx5lyh7kiuxS4O0AHjkMCA==
X-Received: by 2002:a05:600c:a30d:b0:48e:5d91:cfe3 with SMTP id 5b1f17b1804b1-490424ac7bcmr294290885e9.1.1779896757854;
        Wed, 27 May 2026 08:45:57 -0700 (PDT)
Received: from localhost (dhcp-91-156.inf.ed.ac.uk. [129.215.91.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5b2a2asm7023605f8f.28.2026.05.27.08.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 08:45:57 -0700 (PDT)
Date: Wed, 27 May 2026 16:45:56 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: k.manaouil@gmail.com
Subject: Memory fragmentation and compaction test and evaluation
Message-ID: <20260527154556.chak2cd7woi3gagy@wrangler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: p95wnq5qi6cuwdj3xg6hpy7nkqtrthz5
X-Rspamd-Queue-Id: 95D3A40009
X-Rspam-User: 
X-HE-Tag: 1779896759-41376
X-HE-Meta: U2FsdGVkX18f16E5svIOucJsp8zqVcXEToj56D6WrMhi5dhk1BjY5tFJ8/WoXAu4OCnWlaAiZih6MmvpRrDygV8450x/MFViKL9SneaMlfux6zuqn0NwOas6CO+FNZ6SuQ4ne86uaPumEFlxqobRDD9kpIn1M25qfsdOnuaPrHvc6ovrBKpMgiF27nmBm3ATBnh/KcHkIYclxU8Xnvfg6dP4Ju/LoZp3uAxEt3boL/PQRVJPVlmxyTHQny09pvL6qlwJ7xAmdN3GtZmekoIgNGouXc/aXjHFEBiKE8YuNdX+WivJId74oLcNhEgUbEVHNhtS41Sbx6f+JkodTMaUE6COj2uVAZ0CikJAfCxNNEiW77YEjGgYdXNe4G7YNExvIFXyeN35RPEpllnlS3W99o/c56vlH1jbqXqBGOPsg+3mRWWjPDZ0v9aLvLvI2yYBr8hQlRhsgm6ew5eBbp5TzlB/fIOtwuOuNiFYGLcj90StdqZYEUoYT7YomD6kAXkWLGJ/8KuAz92eZNUXQ5uky9MtLP+t0mGahYX4ssj9Oq1UImDxenVO2ctHuty7AmxMMEI/YGis9hv85WtnR5bu2aKUqL9k0lRb76YnmkaEnCKRlpfdT+UkMCi4YA0OYw9wV7v9+Swfh0RIBUxZrquxKgOpHLzeURn3T8XdLtEdb9UPbmCW4nDUi+k54tF7+HjiAKPQ6rNekXk1QB2hQ2gxYx5SRm3wzVkGvU91w+fkW+D7ZdBgvhD9JXUyIgB4Pjr5QaJuCIZn4SG9kQL807R7azLataRTDPNgWwadYC+QZTRJo/3MVgzCjdkJRaXtTSjAtyiW9X76rwoXspDExISEY1YdDZPkqLNWxt0cJGB28Bq+UaTQGcPuViqN4cAjme8VIbaHiTYX773hliSpS/r4bPizqhTekFP53ZHRvnT0LDpWMKTUROWE9iIfT7VO7LrU+T+6sbA4R9WJ3D9SAKR
 HFlGS1pe
 UUKnZtKvxn73KTClhcyEWFwcJzGPd2Rntw59AsBprl+I+2CA4mwpC54FQ+8960leB9RnOKxQdEEKIRMqnxDj6ZNF9qsFUhsybUlB7NIr9s3zdspax2sgNWjgTyJV20CGG7gy5LsakZyP5g71Rx8z8S/tm3g5SEBJj1TQyVVyA4wdJzoEL0/v3/F8PtQgG53iqbkMbK7ZL0NsR88K3E3PZ3KNQUyqG/kY+MlBxefJjGqKY/0jdqVyQGOVSGVBjcaRVWPR9JGBhRyI3zwkUCTnk2kR5/QhypSrZ30R/pT/pQ8CEPs/xmmDCF6P9qgkUJDsW9P3Mdp5yMTscPMl+1YF0IvYxr/0cxmDQImlQXL38ViWFLYM38/L0KuWytq1uX+zpFD4IhkAfNPQM+bNAj7d3HwFRnmd2Advy+GMSQbNP3EdQmr+xXFpu6mc5EUWEiYn57D/Ygh369PD6WEyIjtlVQ17V15sgQEYiTXsxDdJMtJCW1Jh5NxFBDVjGmBRdUmmf9tML6US3/2T0dZIGey7Tdk5yQJnbGzYZ1DvJlOBD1R+Ch57knUNycJdVGwp00XsPOy3FCpUNHT52WzI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi folks,

With mTHP/THP, large block sizes, and increasing adoption of larger
pages in various subsystems (e.g. drm/ttm [1]), there is an increasing
pressure on physical memory contiguity and hence anti-fragmentation,
defragmentation and compaction. This brings attention to revisiting
existing mechanisms in the kernel, especially with the rapidly changing
hardware landscape in terms of memory technology, memory bandwidth,
CPU microarchitecture, CPU core count, interconnects and other factors.

However, it turns out it's extremely hard to evaluate fragmentation,
compaction and huge page availability. The main challenge rests on
reliable reproduction. We need tools and workloads. Specifically,
we need tools that:

	1. Reliably reproduce fragmentation on a system. Preferably
	   with varying degrees and some control over movable vs unmovable.

	2. We need tools/workloads that continously stress the system
	   and continously introduce fragmentation and challenge large
	   block allocation while other workloads are running,
	   preferably without interference between the two.

For memory fragmentation, a famous synthetic way that is widely adopted in
previous patches is allocating massive amout of anonymous/file memory while
an I/O metadata intensive workload is running on paralle to interleave
unmovable slab allocations from the filesystem with movable allocations, for
example by running "find /" or running fio in parallel as is the case with
mmtests/thpchallenge. This addresses point (1) to some extent.

Point (2) remains entirely un-addressed.

It is also important to have real world workloads.

I would love to see how other people address these challenges and how
people here test and evaluate fragmentation and compaction, especially
under sustained pressure. We can always start from a fragmented system
(for example mmtests/thpchallenge way) and run a workload to completion,
but that only tests how the system recovers initially and not how it
copes with continous stress.

Please share you experiences in this thread and share any workloads and
ideas for tools that you think could help in these sorts of development.

[1] https://lore.kernel.org/linux-mm/20260506033300.3534883-1-matthew.brost@intel.com/

Thanks
-- 
~karim

