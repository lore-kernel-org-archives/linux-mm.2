Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17525CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB056B0088; Mon,  5 Oct 2026 08:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292C96B0092; Mon,  5 Oct 2026 08:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CFC66B0093; Mon,  5 Oct 2026 08:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F117C6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:54:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73BEFC0254
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:54:06 +0000 (UTC)
X-FDA: 85288565292.27.AE0745D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A0EC31A000A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:54:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yyipCU4a;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791204844;
	b=IsVRKYsQsNRsrKC8HDLbOnzON93zsx/zm4zZ8nnXwLaJGspOL2IhLy3iylWA8d21Asl6ey
	8eKI7Seos+nfg6aQ3DXRZyv2QnfkrffHeA6Q1h/Lo5gXqD6uZFcCG21uaShCqVMwcrBbKl
	g9f/FI4MqzxENb9iixTcZEHcpcD7gko=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yyipCU4a;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791204844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0WZ+X3bCrlqT3aScryv2WGhSJF2SKbCE0Wf2Qf1Okk=;
	b=J9BwdBZm11cm7gYZsFGuHp8Om1+dJwBuCipb4UpTnsZibllIxrThAsNTFXgbRXa3S+ZGLI
	1u8jl5DMNMo5VvCFe3I9RReroq6ujUBFho/Bs1YHLzmLdSSWA3biL92RWbzX2IO/mMoiwd
	ym7jwPKS47jF0bvDyI2dQ1Ws416UcCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B2374002C;
	Mon,  5 Oct 2026 12:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A667A1F000FF;
	Mon,  5 Oct 2026 12:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791204843;
	bh=L0WZ+X3bCrlqT3aScryv2WGhSJF2SKbCE0Wf2Qf1Okk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yyipCU4al7wZUCxLPJtBmtOl5273fibvVCgLfHNF7po9bNlRLGzN210UCpk8JwAsi
	 doC9AmMcNB38C98pfORUq0o7zRTx6j3Dt14cazQjO+uIbCyhbpjfb5aJVWVrHAS8kP
	 Cm+cpgWnTUI3Up4Tp9CQJNZTLyemXpfPW13JBFn0=
Date: Mon, 5 Oct 2026 05:54:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: david@kernel.org, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
 hannes@cmpxchg.org, mhocko@kernel.org, ljs@kernel.org,
 roman.gushchin@linux.dev, dave@stgolabs.net, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
Message-Id: <20261005055402.61065464d9c66f1540a08c94@linux-foundation.org>
In-Reply-To: <cec875e1-2afc-44bf-929d-b8f2b2a795f8@gmail.com>
References: <20261005062236.564210-1-vernon2gm@gmail.com>
	<20261004233615.df26e580c1bc916c7f3a23b2@linux-foundation.org>
	<cec875e1-2afc-44bf-929d-b8f2b2a795f8@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zucenot9ncj5ep153m1nkp8g836k97bw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A0EC31A000A
X-HE-Tag: 1791204844-744674
X-HE-Meta: U2FsdGVkX191yf/qpo1p2n01kVJnNH9Kaz68aGwRiWNdI59J+IipjZyxcBPj7JXN9T3d4d+ncUn6boHnlrKSU16cxJfITPrJaXdcpqyQZl2vVmdJ4/SgSs1tEbgpnKfHVIHtAPwCs1akwY0Qkqujk1JfLWLUcVWqhAQENQPGrJRUiP+KlbKtsWPSS04Rx46E4unhPj4qko/cNOFrYWC2sXp5LnL6r4s802JDsBia/t1F2NWHqPixidE0jC5mw3AQ23c7sCfxFJ0kDf0pInJzNWU4mHcf2ZSy7rA0YsIdFHSynp4dWZIzZqtOPHfyk+UHaPGKNEdowBoW/+TuhQx7yiXPWxfgXrtCQryUhVmcZt5NZjru1o0oLBdg2EiZ0mPt3Ueey/zC45N9fNdnnkn1Nv/fQ3ERuonLBo7HtrtAKKAShyvoPXQAm7BboiXRQOben+YZuHVhor+8NIl5pU8yVkVJ6ZJwNkN675WLnbbxeoYPtU7HKhdjVbgSn1eMH0hc09vVfUN8VzmvknBcIFmQmZTdpA3KfwkLmpjA9+fgryo9/968rsgq3SUTpz+V8fHqmbmOWYxl728IzeYHIuipKzmUFnlkgRGxXuqMnbY7j+4ywFp+u6QSZukkcyEVPFYl6WEaoaWOJ/cydSTr/SCCfjyrka7PTtxSCuQ4eonNjflJdcMrNE/63R+Zh1myL6nBAFCJE3bkOX3ITgBlmAk9sju8mo2rt3h9acy+A8Lkb2ssjoo4HyF90RPk1CvoVjSQMr7qK8VLNVzWDRHsq8vceDv3lpWCRvz/Pn8SD1h4hsEsuW7qDzmGQrwD8OvwSvTC1x9qAM0tBAMckWggZLc+3CFDW8Y87/0G+6ciCXXE4JrtajUbaszQH/RnNT7tMa6XMSU1vu2pC2IHnI0aOueDGjrrv4SV48CrCEhhQ+5zKYIWabrwyviqYqjBdzo5/+lqT772n+ac2sloBouLc/e
 wTvy1WL0
 gEAGUt8Plz0lKITeCK5GmTIgT/epkJx6B7p6xV1QRYTpIH8kO+rGVMdJ6YyRmW5njq7d9BnKw30ydLROmyAlewB1cBxB7VImOfml0YFzp4BgiKc2IEWQ5ln4TbD2pSy09cswxigK4P73bC/vbhfS2nE03CSHTMvB5Bn9WwXWAsovZnjFxDd1wxNxiUCqU8a8Jsz4GLHPeJMPwt5dGs7g5/HNqEMjsf5ojAm6aS8jAERxAS/MBFajpyLdmlO17oavHjJaAgdmcq7RQOQxec/JsLE8g6A2BPav5vCdjXfpNb0Qv8mw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 5 Oct 2026 18:10:45 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:

>  the phenomenon resembling
> > > senpai will appear again.
> >
> > What is this?
> 
> This is commit e22c6ed90aa9, which addresses a scenario mentioned in
> memory limits of a cgroup, in detail as follows:
> 
>     Currently, this reclaim activity is accounted as memory pressure in the
>     cgroup that the writer(!) belongs to.  This is unexpected.  It
>     specifically causes problems for senpai
>     (https://github.com/facebookincubator/senpai), which is an agent that
>     routinely adjusts the memory limits and performs associated reclaim work
>     in tens or even hundreds of cgroups running on the host.  The cgroup that
>     senpai is running in itself will report elevated levels of memory
>     pressure, even though it itself is under no memory shortage or any sort of
>     distress.

ah, thanks.  It's arguably appropriate that the procfs-writing process
gets blamed for the I/O which it caused, but clearly that's the wrong
place to account the memory pressure.

