Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84EE9D41D74
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 00:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC1256B0005; Thu, 11 Dec 2025 19:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98336B0006; Thu, 11 Dec 2025 19:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DADFB6B0007; Thu, 11 Dec 2025 19:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA40F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 19:38:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C699134D2A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:38:04 +0000 (UTC)
X-FDA: 84208956888.23.54929B0
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8404BC0003
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:38:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kkRJhWfy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765499882; a=rsa-sha256;
	cv=none;
	b=pfdJqk6DqAnfX+06BTMIGU9BWssoNGyEW0afSI1nmZ2H67k1cnbRN3gV5RJ2YWLKeScibG
	+dtnSEtKZ7ZzSJCgD670C8FvFKKbtTATjj6YGwlxqVro+Jkhb4Gw3fm/eZVdJNv5tHbn3d
	JNUNX+9HiZ5XsvRp+q/naUkH/GK7Bd8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kkRJhWfy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765499882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/84buoVRor3AbyQ4XPUysinXJkE6bFyrJbz8JP5bRgA=;
	b=AeY2p7+deUhhS7Zqmbp0bg1Rk0V9g5KtWIiV5GP/qMkMNDNwW9YpwRczJkiwq3S9Sejy+5
	6SR0yrCDOidUq5qwsoS08BA4t09njsiMAFFjW+XLRfgiGWQucWGcwbMmSO8bRUHokex/4/
	xuvLNoEmn1eHE6OfV+EIP8db1IldL/Y=
Date: Thu, 11 Dec 2025 16:37:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765499880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/84buoVRor3AbyQ4XPUysinXJkE6bFyrJbz8JP5bRgA=;
	b=kkRJhWfydO7d1jxdqMBv3LXHEOzvjDzYGajVGH9l65XdjBMd6hClnw5LY65i8Juy3CjBey
	6asRv5hsSuxaamKAJ2mh/o0O9PL4dGed84piozgm5rfscxthnmK/Gy2NGsPqNHAN6neC7j
	/mAN46k3Th+KwwE3eIjTuERi93dHb2Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, lujialin4@huawei.com
Subject: Re: [PATCH -next v3 2/2] memcg: remove mem_cgroup_size()
Message-ID: <2es3ycavnjvejeawchua6d6ueetxhlr3ldmkdd3d2vn5gkzne4@aho56i5oslmd>
References: <20251211013019.2080004-1-chenridong@huaweicloud.com>
 <20251211013019.2080004-3-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211013019.2080004-3-chenridong@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8404BC0003
X-Stat-Signature: oudpz8rse6c1tu5p1dbiux9akxtfusun
X-Rspam-User: 
X-HE-Tag: 1765499882-37674
X-HE-Meta: U2FsdGVkX1+Upn1uRUdoVDzY1nc1kfMYX6uMh2ke3W//NjKsNfnwQ+sI49XOAOORfIlrMXUMzBQ7TcV9WPZQUvokvT/Z678OrIagheILGzPEJJ2ODM2xwZ7rz1zXVtX1JiA55fSO1NQQBk9UnCt5GJXUcPrg/ogM+amGYoBXIfURBX2tlAX4O1KDsAYgX2r96W+D4LTkzz/bWurgpwoJIZMMB1yNTHkwNC1+C/emWHb9zcHTo6E5GP2Kz3n5K9OBuu/o0FXbRdTsTqw8jOhv5qmd48yndrJJ9amRD40GPakLAjcNPoTBEntxLJ9dpT3LC/4/3KT4xhVTuoB+o4pbRqo7Lmg2hd32F8i4ZxL1RyLfSxOk20DSq+K2NYN78IIzt7epkP0ugpUPhdksOrRnBKCJfRvKz9KJzRqWMyumeEI0HzKgt6voCu99MwGpf4OxJ+mZMPfR53jJ+U4tNr4jtsFvdohMxVQYtTE1+UDnOVTSF31pjm7wI1WF75yftutbUgBnCU3wSuLrdvqkTmEkuSnVBlY2o4F2Y2HGEBGRQasgpUnNeNz2FsFK9lSFCRZD1aARZXW7jXp0zIJ5gjqyeVo0ko0woVIOZQFykZkZe5rcqN6Xg4e1Bo1nXTDRvP34kHoTXczmcadhEr/jaVSmTUuDoG/bRsa0XpH9uGMVq5PD29mR0WVwMCmr3mGkUAaZfN2d1XxuFP8xTKBI9yDIVBedov5WnXJBrGu9diddbO2I7UOkfJadn6fFc8B+AZXJZbTg59WmsBfpyxrZ2J4b6CJvGQP11PlRknhm279LwCMvx2Vx8TyyKvCM38yTf14r/NU67kd3zaDdwKpc2xTtF6wFrWyC3VTQtPjLtrKNut/Q1HKIHeyEaeWKjb3yOdYN+qAhu1HiugWx+DtJpofKflpskYwFctQvRTAAwZoe0pos6dCrT06hJcjV5VYjXLbU62b/X59hMXWXJRho0ve
 yEPyKvtX
 tnmcXIB0WFK95v+j0znkSQzq5wTWcRiBDJG+yrC4E5gpxO8PhA/YGlklIfSnTmbVBc/dDboh/aMjUJQFrpIJ9YnpaiCKobSAVB9EStsq4dA7H4QZrugxoHyl8K+1hUnos8aZpBLp3V4ZDaTfXETCNrLRVsbU16NHoYj9gFrcy+h7Y+D8+qxRDPWXuraIr+Yv3Bcqu3VZfIcZsuRCvILfXjhNt7bzGBYTHktH19zqRlxI/4Pd6NYc9S497B71/HCfE2m01TE6WYQ9hdOlDODMCIClnsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 01:30:19AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The mem_cgroup_size helper is used only in apply_proportional_protection
> to read the current memory usage. Its semantics are unclear and
> inconsistent with other sites, which directly call page_counter_read for
> the same purpose.
> 
> Remove this helper and get its usage via mem_cgroup_protection for
> clarity. Additionally, rename the local variable 'cgroup_size' to 'usage'
> to better reflect its meaning.
> 
> No functional changes intended.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

