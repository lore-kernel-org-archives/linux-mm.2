Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1833606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 05:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=g1F6U1vk
Received: by kanga.kvack.org (Postfix)
	id AE6ED6B0334; Fri, 23 Oct 2026 01:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97FD6B0337; Fri, 23 Oct 2026 01:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE146B0339; Fri, 23 Oct 2026 01:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 633B86B0334
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:01:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C137D1C3409
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 05:01:40 +0000 (UTC)
X-FDA: 85352693160.21.EA2584A
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id E6DF6180009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 05:01:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=g1F6U1vk;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792731699;
	b=kI7dRZfmCpbYQ7aDjnX729cF5swuvFgLs4zPiMPXe+9en1orF6xMbDbue1ujToLAEelLTT
	x6qnGrEmEyS13TghHjSvH0YQdsdaHsV2X8sW/uKPbtGmAcvNHrq5VmxNC+jJV+4lx1rmTI
	AE7tGtQilN7veNfDok2UuPW2B9LpdrE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=g1F6U1vk;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792731699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vGSWPVRPxP6ajcwPiQ6sdZfL0TLUXIf0aO/2OiD6KVc=;
	b=SDerzQ42A2uxB4yvGDABaQFiKSshjPTFMCGl2H48VYtNJz2HaWslxJ2wQ7y9uoZSZrvghR
	RXS0WQUAxRH6Tkemlu0ev0LH6Akd83Z6DD8NJDe8wwbxciW0lVcQSDGcOEOXNZIrTIc4as
	xLNVrQk3mEnjB4/vvbVo1BZiB+ENRHg=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-170135e43c7so572261c88.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792731697; x=1793336497; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vGSWPVRPxP6ajcwPiQ6sdZfL0TLUXIf0aO/2OiD6KVc=;
        b=g1F6U1vkvRTLLbMo2HiGxshlg+nFnNXUNzCq4mNrSTDWd17MTMHtFLPCOISUQqLlJ4
         S12FKZ1qk4R2jHHTl3PMabigzOMdHJII0x83+6/lLXzWh/o/wAdV51QUG0Tg8fz0b5Kx
         IYeUVMBcaABLh6kTFVOaK9HksIrHN8kur9v9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792731697; x=1793336497;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vGSWPVRPxP6ajcwPiQ6sdZfL0TLUXIf0aO/2OiD6KVc=;
        b=iqg4khu4WhV9kjYEujaN3V/GL/WOpddsCsfZIMTYe8XWMulHdkt1iM/wbTVOh7yvwJ
         3QERymFJo14GUVoLHaf6gEtP8H5wZnVsX4sbIWcqUpolHlol6c3XAhQEk/v0eNO/AtPB
         5b8l+6QQhsSyMyDvpiZKbZATzs1Fbduo/tFnMwOjvejFE4bhakDnP8IH/YMfH7f74tgb
         IjWLXyH2gCuaCQcS6raMTrEOoRd0sHJsf92HTAFaAPbfJh5kg3LaYeY4PmAJ9e+MxwyG
         Nywd4+E7KT6cy5Yyl274o4tKOx3Z4lpA1491eXWT8XpcqV4+WHUXGmJYL0ZuoZV2orUe
         4beA==
X-Forwarded-Encrypted: i=1; AKwUvBxcqFBc7i9FyRXd27HRaXXqEk2cApGYQCIqBizcbLJaq2ov3/qyvXYDyCpkO5124BuYBvk0K58tWg==@kvack.org
X-Gm-Message-State: AFq9FYJxlh1xZ4NGXAMMuY/yCbeXiUpU0MPIOSjNZRKBB6K9aDlXVwTT
	G2VekboG9amXaF9XAvUmhx2g/1ljwfBtoec7Ix1fAWNKCYP1zCnF4P9GviqoqJAX1A==
X-Gm-Gg: AYBFou2o342sfKghPW4izUpxTYnZt8pkch4Asf4Ey9HxvLqqiR4R81JDxz80tdIfmdJ
	yuAjQcs53yq7oEHQh8eTeOM6zFFvnFbMaXWkPALSb3Bcru5psjD2ATiT1POXQX5UAMKwPJt/wCb
	TA/7waYnDOouUabXKBewKNk+rewBR8CrGv5LqW2XRvLcOSK/CPcF0cQi1FiwP77QMWisbTZtd9H
	NveY2KU27Ewqlf8B5NfIVwMUX8EItkUYjHAbAa4dk6erzgOxPMUMG6reXcEjZslm3LvVvsjVzv2
	JtO8nLNzuBrbZM5OhPqaNMudeZ7l47IXEUWddnnSHwgReCk2+23fHuUQYGNgJn2/nWmQC+ELOPc
	SrAtP0fvOSuM/02CEJvxt/4Hw6u/cMi1SIagRS8+U/iYu3X/wUUC893T/UckSS6fs5JDOmrcN9F
	EmxyUKClQoSV4lLjuiYhngXIcL8ZBGU5NhlYEqxSohTNZutbsn7hBMnaTWIcmtE+K25gEpqA5Ro
	sD1vMrsGkw4mJ0k7Y8y82hpKt/dkKz8pc1XUr2cU2gEeKz6fyToByJ7/QIa0suh9QUZKs8tJ6Mg
	CBvQk967e7uQsRW9tDFA6A==
X-Received: by 2002:a05:701b:2309:b0:190:b2de:1549 with SMTP id a92af1059eb24-195bfcb294cmr2047930c88.1.1792731697413;
        Thu, 22 Oct 2026 22:01:37 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:30e6:10e1:f7d3:a06d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-195ec82eabfsm5512711c88.19.2026.10.22.22.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 22:01:36 -0700 (PDT)
Date: Fri, 23 Oct 2026 14:01:32 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hillf Danton <hdanton@sina.com>
Cc: Barry Song <21cnbao@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Message-ID: <atrnvuQkeldgPqH5@google.com>
References: <CAGsJ_4wMQteCGxQ7wxUKP2g96myo91ipF_zedFVVbxKdDrb=bA@mail.gmail.com>
 <20261022111151.960-1-hdanton@sina.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022111151.960-1-hdanton@sina.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E6DF6180009
X-Stat-Signature: sqsyfi6j7cnbkwnddcs4sstemq93u1ag
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792731698-62521
X-HE-Meta: U2FsdGVkX18FwlJiumv9M60tD4uNH7aNE+Z8ez6tgBnQy1opSqmxrlCMsFZEdXUiM6jvuPAnwuEoDQ2ETSCjzKUQMREX12qpt42skyXXcysLY9pMQPWaUe7+ranAsQ8eeVUGeSJGnBWbC/08hrEisb5YxSf5JdLlfE0rIFw9zSJkjSbZpO3QxDel5dMvoGOFoI4vp1e37TfQWMv4H83Ao0DgAfq8sJ8soPRJcW8Og7OvsvIVVvrTS0lxLBk4shNIfnE7Cogm+PVakuLY1BBfzWjL7folmvYYdI0R2dfhl08+IhYtRt9E4RHJ7mHUySqgL2eVhTHUYQgH7nP1pf9IV4JKaExYcbhKcWlou68FSix4u+COr0cbkuhejUyo5Po6uRvaLLmKGVrOIHhA4z5+oHZuFGVytgTf37bWsYKE37mp8jKdDr+dc3FAO9Zpqf3FrFktwphnFnTxRrGRdzVG2p2Ug/MhI1LpW6TtygwISOffX3hICTA1m5iJRvcN6MppJtRkpykU+QPbslIjjcVsz6zKFGULmq6jXGgZB5EO2uGut1pdZPWeUdRshX85//15CaurA1xD5VBgCUNsq1NR/Isr6mQVs2KU4sWTQ4dBJViZl/5EbvrsO7gnXp9auQfBPTCxF5UKdLBiWaoQrSVqxmXyVVv3OD+bjd6zc92XJv0phXvm+2tu+9pzjc74TF0oOP1s7BghCNGCzQu0DPeIXi9E9deBNg//MwSVTI5xhUo36VPNB3WrZrGiSxWeieoUZOWMbq6uDdqiu6uL0OywVR78Dp+9wL55Jwho0D68kBJIz3Maj0qDsD1y3IFKi+HTMqggoeDndQyoEzVfYFXY/w5srebFfn/gDOKG0X8T01y5XhstakU1SQAe/GaNKGOt8isxhSnPgvQ1o5HR4WvUP+BXerTVbUaA0QkQkSOGT6RSNbHPWZnYAW9xSfM0uUxSvqhstqzwnKJUJXh0oZa
 8JGCQ5OJ
 ttvr3pDvkT68Y/ILBdNN/pJkpgX5kFi3ynPyeyZ3mGdf5/UltcGa1ur7xMPmnq7lfJMkS3zvBMHASt5BC7e6wwRTwzV0s1S9Sy7GRZ/sOWr3FEVSs4ZCVPUi/w9aK379DLfklHZGxb48D0HXIu8kk0zLlgTdrDR7MbLm20yYu7FNbIS7kWVBJ/HwtYSRBBSztJ9ANtCeO4wK38WwiF/pxUYs/Iph+LiOpo/Yodv8L6f93Z77VNz9P8a+SZaf33Ve/DvTnMPKTYIbAlB7c19cklgJY8gVMCqDHGRnJaN9/391z2l9NsG+WGCVur+fAWD/P0CJsBLayEH2HFmrCDHJ/g+A6dqqedn6Ruo3S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/22 19:11), Hillf Danton wrote:
[..]
> What I am confused is -- why decompression needs to run faster without boosting
> compression up. Where is the compressed material?

In a typical embedded device (e.g. android) zram write is swap-out
(direct, indirect kswapd, or backgroud service swapping out idle apps),
users don't see those.  zram read, on the contrary, is what users
see - because that's swap-in, read bursts when user brings back idle
app (camera app, etc.) which needs to get back to foregound quickly.
So, the read path is more important.

I tested the series against PE.

readers vs readers (no writers) 3 runs

    BASE+PE     IOPS 1,449k  avg 3.48us  sd 155.6us  p99.99 26.8us  max 280,820us
                IOPS 1,435k  avg 3.69us  sd 322.9us  p99.99 24.2us  max 540,512us
                IOPS 1,459k  avg 3.46us  sd  92.8us  p99.99 25.5us  max 172,186us
    PATCHED+PE  IOPS 1,457k  avg 3.31us  sd  15.9us  p99.99 25.5us  max   7,580us
                IOPS 1,475k  avg 3.28us  sd  14.6us  p99.99 24.5us  max   7,327us
                IOPS 1,463k  avg 3.32us  sd  17.2us  p99.99 28.5us  max   6,816us

R/W stream split makes sense for reasons that we already mentioned.
Readers don't need to be blocked on Writers - they don't compete for
the same data.  And, moreover, readers don't need to be serialized at
all for stateful decompression.

writers vs readers 3 runs

    BASE+PE     IOPS 1,271k  avg 5.57us  sd 1,393us  p99.99 27.5us  max 1,581,800us
                IOPS 1,461k  avg 3.43us  sd    78us  p99.99 23.9us  max   227,015us
                IOPS 1,444k  avg 3.48us  sd   222us  p99.99 23.9us  max   592,628us
    PATCHED+PE  IOPS 1,457k  avg 3.32us  sd    18us  p99.99 27.5us  max     5,620us
                IOPS 1,464k  avg 3.31us  sd    17us  p99.99 24.2us  max     5,621us
                IOPS 1,475k  avg 3.29us  sd    16us  p99.99 26.5us  max     5,620us

And, in addition, R/W streams split saves per-CPU memory.

