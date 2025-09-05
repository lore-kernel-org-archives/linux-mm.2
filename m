Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E61CA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68658E0011; Fri,  5 Sep 2025 05:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FC48E0001; Fri,  5 Sep 2025 05:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EBA8E0011; Fri,  5 Sep 2025 05:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB1E58E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:13:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45DCFC05F1
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:13:45 +0000 (UTC)
X-FDA: 83854634010.12.F9A8FC0
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 532F7160007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:13:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Pa+4wjQZ;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvFTLDPpNit3hMOVyUmFR9b9foOVm9W8HVS2a5TvYeA=;
	b=2wMoqgg8fNk4AxC4ZqpQ/ay3VrA7/4LXaZ0ZeNzQXiclq+BPyDWCqT/br/90asTq1/QYXq
	ksSW5826M0AbjU2GVIJGi+2BvWjQgXUQhTf4/qXMogSHg4A8aOoYUxV0XsgMCqX14Db2uU
	vkD6QhIVZI6OxQ5ZFGsbLCIYSIwmwvQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063623; a=rsa-sha256;
	cv=none;
	b=G441VXIVFTkQAGg4WROTZnhPQWvb5rboRUN3SUNAPq+4TuKRs9zToQGrGFW9boPrgSuYgi
	Pw9fZGra4/DgrYUit4KkkqeM0Ifnu0RdjqQ7f16Rsh/mjSO6mwvqHRCSXcXsjwGkUG1CVU
	AxtVWgJ2g3aDtbb40hzbtm/+GMpO83I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Pa+4wjQZ;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45b89147cfbso20775085e9.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063622; x=1757668422; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PvFTLDPpNit3hMOVyUmFR9b9foOVm9W8HVS2a5TvYeA=;
        b=Pa+4wjQZZQM8JNfk9Tl5OMiztJf/3aiBdM05E+1JJNEVj+si51+WiTktK/Cn2D9ZVP
         vXr0VzGnCbPXMRR2do+BKwTtwjccVDc8s4IazZt47X90T0k/BPoA7bT5ty7ISwq4IArB
         A7XBZJMCXluU4UPrudiRWDKHJJFodFyNRE9sxiyliGT6QTzv6MGugiW/To8BUm29JzI6
         v3TbitaeLaLDRGplND52Dq29uTFKkKxtLd75PtX0ABk8SKax6KAZ/3vWTn/CudZBwQrx
         V/IQNEYduURvUyHS/1lcLp/dIKjj2e8iyy84/68sriVX7OxA28PpcPU6idTOqv7QBy1e
         C3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063622; x=1757668422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PvFTLDPpNit3hMOVyUmFR9b9foOVm9W8HVS2a5TvYeA=;
        b=OrhP4IQ0y4K2LmHkDdvZARzi+rI6s9bIoLbhmpqGnRMdcaMl/D+PJVccPnTHG8t5U1
         5lDkjbFFWxmh8daCiv8gmGWIUN5UASg0Y7lFl7OJHczalPmtxc7fy3O8traXC7NI4/Yy
         RtYtGmeoNx3u3D3poHkpi1hNvLdfXvLtxuV6NYdg+JZ5mJhAvlgDPs2HRwJaZbeqIhxq
         VqCnbM2KEp2qRn5uF8StmvPm4UZubI8lSg1IWy5Hu5ZbWQGoARK4LQ11W4qerHq2mXc1
         rk6pdkAomjCo51aFE7t6nGuua8CQ9XMcyd0rhzaoO0KLel7rCMQY+bQTP3LtXnNDWjTT
         NPnw==
X-Forwarded-Encrypted: i=1; AJvYcCXRmnN8ernqN6ZleGz6aFECLq8lZqG8i9U4GeGbChcvQNIVFH4E6IFAWoQetREnRvJGtQJfoL/HGg==@kvack.org
X-Gm-Message-State: AOJu0YxGFwpcNxEOJP0xtirpi6SdD86+pt3MLXNLSQ0Tf3XAqSr+aJtd
	Yp/yjfBWtgTp4Exb+crCyQjswHMnHI6Q7DqpjrxdmO43qw9tIS7L87gH1K3OA5eGmhE=
X-Gm-Gg: ASbGncv8YuiEMGdscsFbem+4wCFZgh4ydajFTu1YDcubGsRxiCgxw7KMqxYdoH+Hssy
	zJV13v27rhrDr6B4rjxKO4eE32mLN/MB3+1Ac5iddRwUjrYtYI2p5NlM18gpYMJKPRIrTt0/yRs
	PajikARQ7R7lJEPRdQj8y66FCU1ZB95qBuBAjE2oI/5TfqDdlalsaiWgbNt0QobYtj7iMahF57t
	agPG0loHbomtMTfCHt+WJw9AW1WsVFcK003l+0GYIiVAWcp+XLB+nlvmdWKJf8MmAN9maZViXvr
	6jD+KQ9uWQKZCLUUstezjY2fPRE+5XLLqW821UgPhGiF5NFvQ7JGHG/7k/fMiGLFJtw7E5Mjj2X
	r77JPUPOh92N8q41sVgimK4LNxBVblT0F
X-Google-Smtp-Source: AGHT+IEYH2t+HLKybE9fCX0tdMhhQPT73xjKgDELDCewHk60i42q1kwx7dAVO56aCSC8fZB5al8euA==
X-Received: by 2002:a05:600c:4f56:b0:45d:d286:6e06 with SMTP id 5b1f17b1804b1-45dd2867096mr46407595e9.17.1757063621802;
        Fri, 05 Sep 2025 02:13:41 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45ddbc70fffsm1962545e9.3.2025.09.05.02.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:13:41 -0700 (PDT)
Date: Fri, 5 Sep 2025 11:13:40 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to
 cpu-less nodes
Message-ID: <aLqpxGYI_WHww20s@tiehlicka>
References: <20250904134431.1637701-1-tujinjiang@huawei.com>
 <aLmhbjtF0Sp75XXE@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLmhbjtF0Sp75XXE@tiehlicka>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 532F7160007
X-Stat-Signature: nwe65i5zqqhke95gpfy9x6oax9cg6ky6
X-Rspam-User: 
X-HE-Tag: 1757063623-438549
X-HE-Meta: U2FsdGVkX1/L0rqw8hx2Ka0LZNr02IHB7+5N5otS4rLYg/837wGPuklFXjtFCcGEN9j4jUkZEC+pFrfWnDbw9raPHAzZrpo20AsQA0MlQPNmPLAlED+ttZIgh7AcXwA2CPeWDSrcHnJFQorW6ok0thB55Xu4RSQcVexG776wcAR1HEYnWYQr7+fN8i/cRhLXxL8Js7zEPafQdUdc3e9l5ZS3vZXGvf1th8fmfsNIYIpMk1K1xocqffLfTX7SxSLPiWeMARG3CWlUwI+SB7dq6kO2jlzcArM6m0/mikLoO/tiJQYGxyPRbZIPo0ufRQRhVQXFcTAN0SuD5B7ixWQ6Bio1fp37HMzYtPqoXF7u5H8OCdfsPC9kINY9OUwLyMPn1Pj/3uBBmiVGZxeSjZ2ZvTtK4s6Fjk+J5+1809xephvyfe9Mu2IYqvZ09/4+AfgEc/0WgiqHIX12TQHfHsST1B2IFdKxHO3OIMEreguvzICA6Id0zk1r1fwACjCQvZ8eKjMV8pZlJ5sADIAxo08vAzTy8j2jqsYqv8a/wUFuMqkU4m30XTq7db8UwYdtP9Hil7USeVSrwpq6u8E4YBMHTH+I1HMryw9J8t7C0A5Dg+VtI/5Tx4CcphO6Xk1GfqkbjynL3vwUQTrl6OpR+xft2l+zMva6cPALBpH/MGYVaH19MeIJx+grUhrgIGFtRHLYf/oi42o2lqyfwVwNIrf84i8ksGq262CaoSKE48074YvKyFfZI9mw3wOR5Ht6P/+p+Q9h0rm1bxxjszNXE+eGnLwxrF7AHfDiaWmTb3iDtfRpFjb3NB5844l2xOfGSsaQSs7EoKYYidwtQUbWPoQD6BdxaeeKyLD4Sz+FQaCduQFQsWM10Xah1fR13gNj5jOpsXaREeuuqF/hTPr1eeiJBMdBS9cSVAZmDY+oP+mUka/m0NRSyRm9WJG4I4Ajueq9jWhCr7j2gA+h5ZJ7mgl
 HrCz41Yf
 sOg+UP5qeE4S9E1HhKhX8ETQNvGM3cYGBfqw1P2m8U3/5PN9dLTn3yk1ijgNZNsK35lfF2/PjLLDbKh9CI5kGf4hCvM2bMBA6Ob2n4pFWBR6pT5g1Tyzu6YKUv67+U53b9HqIXuLU8zZKLydjYnWLQt1z/dmLCvmER9SUP+dOhmurMDZeiHyyEL8ubPoBm7vJenAOrOylZn5C/M8jzZ1iaUWIK38QzuZxdOV61m3WWq8dtvbix6SM0XYUuGZFA7mN//RZB9Bxe6swmrfU7/y9nDVK91uK6Sfj0f0jn4cMNGvzuNONWFUgnUyHHWh6iMZYv+HRoT9w2Ra0DKcztfMDMeg/G2kJ7S37pN+rtDFpTeS06CpSc8tRNgnBbTDcdWdOGgYKCDb9VPBouw8kv/s4hsOXAOp1++CbVJiTUl64k48tYpdyO3If6VOJgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 04-09-25 16:25:52, Michal Hocko wrote:
> On Thu 04-09-25 21:44:31, Jinjiang Tu wrote:
> > out_of_memory() selects tasks without considering mempolicy. Assuming a
> > cpu-less NUMA Node, ordinary process that don't set mempolicy don't
> > allocate memory from this cpu-less Node, unless other NUMA Nodes are below
> > low watermark. If a task binds to this cpu-less Node and triggers OOM, many
> > tasks may be killed wrongly that don't occupy memory from this Node.
> 
> I can see how a miconfigured task that binds _only_ to memoryless nodes
> should be killed but this is not what the patch does, right?  Could you
> tell us more about the specific situation? 

Now I have realized that I have misread the patch. You are indeed trying
to kill the allocating task only if the allocation nodemask _does_not_
intersect with nodes with CPUs. This is better than I original
understood but still rather ad-hoc heuristic. It doesn't represent the
movability of cpuless nodes and also adds a heuristic that would be
really hard to get rid of later on. As mentioned in other reply I would
recommend looking into using cpusets for this purpose.

-- 
Michal Hocko
SUSE Labs

