Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A4DCA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 12:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB3A8E0006; Thu, 11 Sep 2025 08:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2BC8E0002; Thu, 11 Sep 2025 08:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2008E0006; Thu, 11 Sep 2025 08:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A78578E0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:31:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 545F7C047D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:31:07 +0000 (UTC)
X-FDA: 83876904174.23.8E0015F
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 30A511C000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:31:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b="ZE036/Tg";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757593865; a=rsa-sha256;
	cv=none;
	b=0t7sSN6bKWREXCst/6oR/flCaDjWU0gNxtnO5MLEgHJAJH2tNv+0knhcsMbGe0fix35cUN
	Ham0oMoE6WUxwv7mIW3X+NAj04mJzIpMLsGMjweF+aY2oj0QWE1MzJkJTr0Hj+XBL2I2QJ
	+2NtQw+DZMdQKCCN3pFm8ilWfyQyR+w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b="ZE036/Tg";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757593865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PpuHj1F+BrkKFutKG3gDdW+7++9553BIyB97K8B1eyg=;
	b=lBeh8QUB7DZCh11/LHgzpmKMuB9vAQghjRncwJb4hDvV3Qe02EzDE62jcujPrXcCxqn2RR
	JcNDGmwvWvmfyqXedk3T3JP9f2fnDeax6OQlnQA/RvkAikWNnwqfRz5T2oDqF2r+r2zTRN
	loEYgjU0pbn9pVcV1h85xTCPbowSWQQ=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-724e9a1812bso6188376d6.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1757593864; x=1758198664; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PpuHj1F+BrkKFutKG3gDdW+7++9553BIyB97K8B1eyg=;
        b=ZE036/Tg+M9CROOt5PoSWdywJMeN9LMUv89RR0ayLEevakCPr0U3vXKNiGMlRVuZL4
         wRWKkPoddIcWdL+ICtJNQKkjctJYjP0zXsGj30F2Tom0iXoS9LeNDXlFwRDVaEHetV6F
         PVqQBx/Upsb7uTno5wbVJ6jqlRy6+tAu/PPCYe4bNhfI6+l2HY12xr6DJ/TnC1u4QCOK
         4swenUfE0nKSzjNhEMeo1aeYEWibvV7NH6F10YJSKLNVfxtuITj7DdpdwcJ1cRLnk843
         LF7si3odxyKkZgi8as5rEJyvWsuQPK/c94MuKC5G2es/JCzZMMGJ3XdVyxYEoI875gQg
         n7SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757593864; x=1758198664;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PpuHj1F+BrkKFutKG3gDdW+7++9553BIyB97K8B1eyg=;
        b=Dw7gdohyIYWjrvfdOLowC6IOsNtR+vQ7+Xh7Kv+RYiogtk0+6d+k8EyXf3v9CssJms
         m1t62FtAe0pPEoGxs2vOOzrOqYuR5Nu25TDeTEFlgkU0LAspAW+WbopozVteWxrhBOHI
         JPeyqoxyuAe7KfvhgWuo/upVi9otjfcOWW1+030u859PIOzhnHTUD2WWWpJrVEvvB1Zc
         wqIAHZLbkBY+G9JO7YXdkUiDJJwnTMJtLMf+NCdk0WOpKnjSqvMEqDH58TEgGZ0md3G/
         L6fnZmfs3U4lsp5++x4LjqcwzFnhyfnw0HYWeXW9VXtfuoTiSSeiic0/c3dfAWXRy2wN
         4aMw==
X-Forwarded-Encrypted: i=1; AJvYcCWKswufvoasW0JUYKbY/XLMzqRCMKIKfaFdCRJJnDw3frKdQVSZTEiSgDkb7ojFCEfJNcjkxz2Frw==@kvack.org
X-Gm-Message-State: AOJu0YwJCIMuQRMA/CbyB5BptXr8xMBFXwUE6lJGaOdRl7eHK1lPOL1Y
	I+8ZwxFoOUUnl+uPOnnUzCxFRSx6VMUNygfWs0SwyZcNetqZN75rmXz7jIRrBuEOsIA=
X-Gm-Gg: ASbGncsZZ2djrCemYkO0ZqmVvB9cpzmdascZG8HXRM4DM7foPoUI4yE++LJYR3ZhuMi
	lH+9ECh0dpk4aOq9OImFYi9ZmqCistMVmnMC8mTIyeSplog7D6rMj0pfhDrwvKofwKLjoqVKzU4
	7uD3Gw6fh3RaD1Dum0o9G9OZn+IxwyeC9Ld7heX0h26RYX8Sleceh73Di8eHNG3F0MXOWCLQjbb
	1AfjAfnpms9M8vOBl/NQrXgQUa7ig1sTuI6grco4CWY1sJqVL0ZDEaSy1ri3NgYI8zDO/lF9rvA
	HiSM4r7HfpEzxVFOb4ZNlvqhK/Otu/HN5SDBWXpxrzx5EeBJfDjpPERwBh5oNDtu2FLW/sxD6lr
	ho5hy8OrjpgLkzIOUP68p1UeE9thNqVl/
X-Google-Smtp-Source: AGHT+IFcdYtp7UocDozjlEvj2oAiymL2RS2sZ0/qaE9q57gl4Br+ACFwqJ1RTF0HNC8BjqC9/1PwFA==
X-Received: by 2002:ad4:574a:0:b0:70d:dbf1:d082 with SMTP id 6a1803df08f44-76224bd0780mr32970706d6.21.1757593863949;
        Thu, 11 Sep 2025 05:31:03 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-763bee7c80dsm9791846d6.52.2025.09.11.05.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 05:31:03 -0700 (PDT)
Date: Thu, 11 Sep 2025 08:30:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz,
	usamaarif642@gmail.com, rientjes@google.com,
	roman.gushchin@linux.dev, harry.yoo@oracle.com,
	shakeel.butt@linux.dev, 00107082@163.com, pasha.tatashin@soleen.com,
	souravpanda@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Message-ID: <20250911123059.GA794451@cmpxchg.org>
References: <20250909234942.1104356-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909234942.1104356-1-surenb@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 30A511C000E
X-Stat-Signature: 83byfuqnnutshx518q8hsmfqggyupcbc
X-Rspam-User: 
X-HE-Tag: 1757593865-35902
X-HE-Meta: U2FsdGVkX1+b+fQdQLMDbowL5mzlaf3VmJbVga975CqrzcZ0fm7itPMvrA2hdV6SB76R8Bl9mZZwZQDNXlDPNTMYF1qWbTgt22KV+mzPctiDKVaZtJA7sHbsaxMGXLmN7ELGlNI0bb65tnKZPXP8B3haKLqp/qZrduRlZsNWp1Yt1BvRNaU7zbW3LnPfri2TGT4GhE1YkmrNx+jjbyugGjKr4oO7FHfCiTeRLzM/N69yrAb5+6+xTd7yqQgUjq/qS6FH/SnLzdUGWgtQmp9b1LfIcSwf36f/ZS+vRvQzwILa6MLUetECUnFlubWIzr3MVKKBuw0Rs9aDvzQVUyeh2DPbDlXCwkOZEXf5ptBpLebTrEw/8c9tnxMVTQOEcz9uGViGw50vP19HShgUwLqId3F5zXlVdw6TNopYz6Q1ea74vBAutKqlJ/B7kaKfje8FYEeNNDWp+FBOvlSpbSVnWMdxqLv73GdtTX9EAQ4pk0dta6kO6WJKlyL+tOBFrzjOQpWacRqI8pNvfjhKmAV6c53Tot/sLKW8cgJqjdTO1XK0H/UDvFn6lrVLh3LdjB4WsW1mrcI9u2Jphj+niMn4jIymIfJWMJW3YaWH+peieVNMU0PRJpkc/hQ9WnAsavDLxuMELc+HuoSanSNUR7O5Ui1KuMHkL6gQWyz2992+DghFOf12hUNcOL9/psbpvC7J96dWocrwL7k1XGe7IN520yGtHd09BTiJxHwiwcInTprNvP1KG0wYgHK/ACC3Bv5zx7SuL0TUxLuXG4PKrKIFTCsKj8+q2rBr8yMO9/RQUU7wrbF394TyhIalnalOpRjAlTSIbEiz7JVxf5kB3mrOxCWpYfnqdEAqrikzSxVAGxwy/Jn+6kvTxw4FMF7H9E6NyX6MuVcr2B1b9jVh1VQPOxW5n99IQLNaw3DBgZSd+sSCR5ZIiamqGn10MFdgyJ9NuNiOGDllsiXkvWAkT5z
 8zGRQR/n
 OplukW3juiKyEEbbel3FXIVOdpeDDc5Hw3dPpfCl0zaPTBKW/27bh9FMlGjXWKDLq8+5T/sWzO6gnaTHjMnhIvjG0IbUpC5Ome9XbEUIDGsf17im2z8mN37BcDKZPIuRGVSYcTvTGbvIGKrZ6Ib/Ear6RP8ygV5kg4iYNrUSinMtMspTN4Jkcz9Bd2VchIgV4msxdap1Su4cFtO5C9CWb0IRnKLRzPOBSmAssxeUhzQdgF+blHFsUYZFGOLc7s6o9HasKr7Qb1d7UQ9NNufSqKMv5VF8XRIi8DTyMqgDUYGvkF7uWDBewtlFzZL/cb81kq/sKJReIWtAAfS6x75Gxh3uGlpYSV0nOJfgwW7VH3WXWg/mD/7+HZPCpn57YRf/669F36b+iqXGHs9/5F5169GbVCj74WPJMqjg9Cni+H03Q+UOU118ZSuSybos9el14f8u1WA49j2H0Rkpr60cg/E3juPHoPZib6bJB3m4Glpv6PW+KEE3na0giTbLjeC/eDb+u2VGAmXBZBf/NbRTl2wfS21smCCU+oNvPvldvjI4H/JQeGOPkGcYH+97JAWsK7cj0JYJJvqIu15v1FCPNY1b8Zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:49:42PM -0700, Suren Baghdasaryan wrote:
> While rare, memory allocation profiling can contain inaccurate counters
> if slab object extension vector allocation fails. That allocation might
> succeed later but prior to that, slab allocations that would have used
> that object extension vector will not be accounted for. To indicate
> incorrect counters, mark them with an asterisk in the /proc/allocinfo
> output.
> Bump up /proc/allocinfo version to reflect change in the file format.
> 
> Example output with invalid counters:
> allocinfo - version: 2.0
>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
>            0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
>           0*       0* arch/x86/kernel/alternative.c:127 func:__its_alloc
>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks Suren!

