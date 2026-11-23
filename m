Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C6D606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xoxygFZ6
Received: by kanga.kvack.org (Postfix)
	id 26D896B05D0; Mon, 23 Nov 2026 12:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B276B05D1; Mon, 23 Nov 2026 12:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15B566B05D2; Mon, 23 Nov 2026 12:38:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAFF46B05D0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:38:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 952E816091E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:57 +0000 (UTC)
X-FDA: 85467094314.14.DAB4650
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf12.hostedemail.com (Postfix) with ESMTP id B7AC340005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xoxygFZ6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455535;
	b=c2TaVduHvDPHLi+E4hlQDwytJ+Nz5bR0kl/IyN1Wg0g8PwC+rpoIH0cAMytLKACDy1Hyfg
	mEmgE5vv5WPb1I+coYYKCk+WvHU3bWYKL5Jyg3HvRoHuj/IhvqtYLnsg/D2F4d0RQ4OKUP
	5ViWTOFVlpjTS6ulGbOEHh1YHmvnHN0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80pkZVTQUzpocvFf4Q4AZ1jQYJsntKDso7wWkNMkYVU=;
	b=QmulOV0x+ih4LFt2vDmP+WFs4OetgP+SgDrTtcsFdwx7Ptzntc+mjrYxERwIa4a15LZ+S2
	AFk+IAiAYduRuGC0IQoHArgVLQajL9hK6JAYBHGnyt2Di6pWE3FK7f35WPRAmTSyylfKbb
	IjtyRdCOTiZ8nPtx5kTpyMQm3jShocM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xoxygFZ6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a6ce64b95so1376629eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455534; x=1796060334; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=80pkZVTQUzpocvFf4Q4AZ1jQYJsntKDso7wWkNMkYVU=;
        b=xoxygFZ6NMFAoLXflbSKSksr76tOn6Q08Zn+66tPSqHnIWxIqyiuUc1bEHjgzaeLGZ
         gPvHINGsU8zr/N4R9NNb3Y2grueaPdLYXZyuARp39jOmP4qGRuvkhvGBMCqfAbqU0RFY
         yx6z5P/V6ts69qmy3/hRQFd6CEeOxCN1t3ol7XLERs01ULEnO9z82T71PEnAt6YshMZi
         stcCj3fmjSCviknLfEXrGYpNYit8YWZI3T4kIb8LSqvAjN4BxHvxkylKcqprarISTPmu
         1faJTo4qS/n0KPOdtJBRVLmbGKk+kUGfhFKe3bMoPkAkOyyUDctIDRYCBQi3eVR276oF
         RSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455534; x=1796060334;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=80pkZVTQUzpocvFf4Q4AZ1jQYJsntKDso7wWkNMkYVU=;
        b=VEbXOBY5TupxX+17XJXHAfuNcUI7NbA/lxCS+pJS//g9jMHVMZHBNYvVTzQgElF1N9
         sZBe7HuR0VsWyMpGIOE1E65dsRR3+xqc3O/30T8vN5xP0ZLreRVsbx6VsscwkCTpDZTS
         hpu2/mWFB1tXEDfpPhv56vqumPbAV+WkEXObjtTSEkFG8DiWDvM2Vk+JUUm6LG/uM22R
         tEsCbCA57wWXXMzTymxG6m17odqdnsN0CKTv6/Sl/iXWnf5kDL4jlHu+q0CSBfHqdJd2
         JP64ESjgdHksAdAHB5HCpwFp2YYnHibRuHSeEhN4BKjQrGwDiMRSfuAg/RTGFRmmoFm/
         7Aiw==
X-Forwarded-Encrypted: i=1; AL+hErHrSrIIVvXnZVTh37eQuATU5GVnk2EukrBN8sWyD8KnZvevqKP3k+whqC5cBBsptBqNaS50GF8ZXA==@kvack.org
X-Gm-Message-State: APuU4Z/sVCryseeq4cbktAg1W+KaG64YTRYQtyAzpjNV+TpTjB8jxcY+
	AymLBjRIjSOLOnIgU399eajU8t2jh7pPtrsQSxF5t/aBm7r868OV6udF
X-Gm-Gg: AZFdTZfT6h1b4IfYMe8FsgY41BSo6IxHembaoyjoFLOsA0FPfk3fcX9lSLQmNTAFsIV
	a5LZ5Mx9D1LtXpQQF0MbOdHpflm0U9vX024wie94GnqKxMPU1Wu7A2yO/Kk8vmK9zA5kRZFkKJ4
	PcWRgyoHIZMGtiqM9n6GdCMQlLL2aBWkofveihszlRPBi+oSz2N+56gD95LhfKpbhf+jBsa/L7G
	SXZSDxfLNvwkABs1JDUcf+pxlghdFspUJgDz3AiB+PVQ8/LcLiOXeeQZ5HgBoHZcR9WnW2vxXXU
	AOqIQyZneEUU/dUmNU4MFiVsA6iDhHn7wHhicqNbi/JLlMUdXe7E+e7X410zQdjOqWIsqEMpWAK
	T60YfdnuFew5sIC3qVs6GrnLtWW6PzXHRcwIi59mbfboTWS3bhQWTg3WwD9/2NsSgNCSjVm90Tm
	TdKIvD4XWO5HpOaZMlxMNkXk32WcjjXFeziwJnsinEAgmUyQvN2TQ6c1r2RyqUpZ+EJyrnzYChQ
	mgjEn9cIfvMhz6OdApU6umfc1hxPcUpDWybpaDILIo6nUQdyPQ4vzp4lBMRAhnH+AQUuhDXJGsm
	6Hd+C2dkJNl7ei5HhP6th8+7eCKXQtYDyEfDqH1BsolDgc6pEZ2GW9H4gETGlizYAW9rE7Wolk2
	Fskk7hgQPRajI00TFl4R7D3A0klFFitbkAJ+k1Yxaj0kTkm0G30+2DVM9tbE0kA==
X-Received: by 2002:a05:7301:3d19:b0:376:ce6a:a499 with SMTP id 5a478bee46e88-3857122312dmr17033613eec.36.1795455534319;
        Mon, 23 Nov 2026 09:38:54 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:38:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 25/27] Docs/mm/damon/design: update for user report
 support
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256496.4.12112355431870219445.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-doc@vger.kernel.org, 
 linux-mm@kvack.org, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261121210013.130397-26-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-26-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: B7AC340005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: i1swq4gdikybqhdrazyu9ohsxiyxqdht
X-HE-Tag: 1795455535-786961
X-HE-Meta: U2FsdGVkX1890/50p6g9Ay69EsNUkXsq2AS3iQcT5aK0N1gfNo37LxJcctQ9LtDSXTTBzS2ZyHyS4iPF2zb32buT4qBBzm7DqgZb1KS7RBC+DrOPqb8lu1MQPE/JGGJiI3m2I9mYRXWrGoK8eAcPHHOGcJZTthLWBVZrb69hpmf01m99/WzkLRG2aMuVE4auYS5Ke5+ZpCagTVAw1L3kWZSJ4UyKHnkuuFI5TnrenBBphe7ExI13hPbN9t+ca92bVLffQ4qORd0/O6RMa8XYgjyL2JlM+MBEE2o1Zuc9zoJTU3i9xzI5IH+Eq/yDnufFPJvRS9t7j2N0plUpid6KqJslTMqe3SeoNUawjboIEDcTpx+o9CCCUaJpiC2z8jcYFdLjmVM28R5+KQ5U0h0lHoVxcqTUiX0slQodibejWCjfU6UAgWEH3Z2chZnsxL4vj3U3INvebLZ3GW1d92VQmuud3/9XgD9eWEdoLhGCGezE0p5IqhsF/7SfwaJGK5aXJEbTTwT+erJ2kQcklBmz9mUFo1PsG3tQachBNTmNlIHBiS630Lx5ZudjGwal/JI6rhKMTe/jR+tBCnYzyOy5xxICUVL6Jf+abR9ZWcVje2RNWM2Gv1WTLssNfRTHptKL56OgPqBn/Wj2hc4Hs+n9jL4oq1cNOksMzEjc9Kdq84kaugSvoKXTNY6CSrG5uUw1G2ULY/doD8baemeVaqHGmxoFwrMPNpEk4mjFfnjGK1jmMQcOfosFT/jZdf/hccdcdw2MfwwafAL2NobpMLbleDebKNePLo1bHGjFGvIFbbE2fVq6v3Ty1wjnFK6kHbZrRnElAe9xfOZIH42wzHH2URdNVtm9w5IsNIpVlf2NDQT7BGca6ECltkthmFEOtSd+k0Il+82ItLBIhdJcSdhvTYDBgLmAJ9rx2VLteZlpIDM/xixOnPph7O1s9MwNnWAnQqZplqOnmWC4pop9t66
 qcwgCo2I
 FrvlU0IRuJkhETM9CsItlNQ+JjHyNwUUkPUBgKwPYLLnFACL9qA1rN6M2ycbb1prgV8QJ0kVVLP50K8C90Dh2H4Z61ICHY76iNZqgSaKMdzOzSqUtDCbKRoBCRkLEurOWdKQMp1SEkYqnCbdWJfAKyA2pyZyAMoA7MUKJ8Kgz4NupUUFh7fGXSQVHWbTgPSI/OSBp4SXVV7Fbtig0KD5PtwyGnWY0/Nfn5SUjQYuGE2nHCvpB+18KfkoMdyX6hJoKcnHrU77IhBiVKsRSOw3vByKz9NNC8MitrMFsBUnFWVkJaYb0vPJfpekBdfQ04ZZ9yYSaByCONYmehJLbz5y60fQxWGSlLoARwq0AWL+IovpA8vK4qyUaQOq/hzWO/IfyhtgavXBH4t/ZC/RnBtU+vyDv60qXs5yKYxJepTmRldJw8sHLBxZqD5PUBi4svOgLYVjC21HuBkAa9AFuh2xObbAHexw2evw7nl7GKfEqvqgy5UZyf2R1toe9tUQBGvymZSIw5bx3ObpRTj9XdKaQZEEDLjlqb419zUr/q1Fbp8U3gBKnVl56YqMghCeQJukzXB5q6pgGRLYcYOFtX7aB9DZlaa57KWJfCLEn0mZjtZZ534xcjZ8MVZm3FrrYUnvcz0j+xOozVQpG0YMIxyTYhtELYwHvaDTGeUXa8iC7wAekIZz6l5xyPJ0fvxekb82Avle4opOQsNBia6GG0Cc9RDhfN37rpZimOIo2F75fG7JpIPi2QaVIM/1c/Juis15xr8s/kzJVbuz7/nYwyivigp+GQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:09 -0800 SJ Park wrote:

> Update DAMON design document for the newly aded user_report type data
> attribute reports.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

