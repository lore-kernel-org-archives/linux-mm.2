Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB206C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 04:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1886B0088; Fri,  4 Sep 2026 00:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581806B008A; Fri,  4 Sep 2026 00:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A5B6B008C; Fri,  4 Sep 2026 00:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 234656B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:28:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76CA5140708
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:28:03 +0000 (UTC)
X-FDA: 85174797246.11.A527F5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF18A180006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:28:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="0gr/kHqO";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788496081;
	b=IiNfX8HImGbXTcvOqu7YAno1HugrDnmxZfziVFmAaPXwqsiX2vJIgzHZTjYS9NRgNWSUHt
	+DfIKgZE6YXdeeQx2d0lTat1W+YTDvLuj+ntUYUnOyFekCuf245u/cR3xfgZpDjISFjuqb
	XNzZv7JyKnAwxh5mUZ9E7GDuHDzePrw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788496081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCJFtgL6xdcTMGe+9WP8iYjWEvs66hdQP/mx1LoKy90=;
	b=OzDSMeCTTSc6drWMOiHR6qMfpRDvUgbaSm6kJlojm6jqDa/mwGcSAw1q7Oh6RJZU/sAgg4
	N6QmCmKZB8DlclPy15ycLtgRPw6poV0ORnsKZFDIcNz/wNZmS02nFmLtGIEsBzNNMSx1Iy
	axJ0e5xEAvrsRRDJsvrxwSUfbMLupGo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="0gr/kHqO";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8EE341088;
	Fri,  4 Sep 2026 04:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346F91F00A3D;
	Fri,  4 Sep 2026 04:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788496079;
	bh=kCJFtgL6xdcTMGe+9WP8iYjWEvs66hdQP/mx1LoKy90=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0gr/kHqO/4ULNDJqPp84Lr60lI6kRpHpGBsaJ4e4DY0IrOIABLCKnu8b0Zb8++P4U
	 Uz9mbSiKYC/18RzGfoNdYjWOSH2jJ7d56y9bvv+pHFNAGH8w+OcP+QvpuYDENuS+y7
	 1wg732cuJfMcY5ImcFpZd0ZoqDL+FeKIUTzsD2TM=
Date: Thu, 3 Sep 2026 21:27:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: baolin.wang@linux.alibaba.com, axelrasmussen@google.com,
 baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, xueyuan.chen21@gmail.com, yuanchu@google.com,
 zhangbo56@xiaomi.com
Subject: Re: [PATCH v3 6/7] mm/mglru: move folios from oldest gen to
 second-oldest gen from head to tail
Message-Id: <20260903212758.4ee5fec2a7def1a26f19eb2e@linux-foundation.org>
In-Reply-To: <20260904032748.210-1-baohua@kernel.org>
References: <129ecc53-f96e-4a5d-a79c-c05293d815d3@linux.alibaba.com>
	<20260904032748.210-1-baohua@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AF18A180006
X-Stat-Signature: or86h3xw9jq1k44wfkkri1an73pznrzi
X-HE-Tag: 1788496081-451093
X-HE-Meta: U2FsdGVkX1+WjFdZ6E6JY6X6cAiHKPR0DeKWjDe43J9hEbPeKNj6lNujHBmi2aN3Dlv0tcuiF9kCDAgDOHLZbkpqQZ4/Hpvpyz93jFNYH8WrW0auumVQSxNaGNb7+WW2FdRrCZJAx2m6bTGxezZyjImJ14QuVSoEmVB90UcgDgxtxVeTzMv4gSbAcSuYiLutWDv+3SLbqKLchrM95NdxUJI7ElNOpqcqib0f5P6hJveK0DAsmaCXNPuWrx/SRHg72ToBZYfVO4+ujHTd1U5MrAJ6YY7DQxxThXVS+kyGoOO8LbC9gveZ4IwNody2gjKkGeQwQ02+YlWhV+CNmMWyh/6jaL/2TX7hz6fToomT4bmt40AhY1z7RoS03uKNGrc4NqqhAVxbuOzpvqSiOQHnhow0p18NC0YsaUAKCiILj3tyZjrlOEHeCqoGvqcyPrePE+XkQnDIK+PaUhiFthbSmfpFM4J7H05Yoi1a50n2x3dLN0mLIWUrsjdLkAB2ytcqJ9QscVL7kgMnSYlTE15YgR4WlFvN6mA33ZR6oOx6fkI74oBqnDVtHk2nmvsXAwkdAWrtgf5MhgRsyeD4lLjR+i0MKGgp9yaj4Dk7ndq81QYGOMeyNmWJMJstfvmLEUKN5fI4eGjgUy2ryD6ROrRr6Ty5Hf7JU1tPTIqqcqT7TscBavdBfIjY0TPt1U0zInHigO1He93hVdBOWfw2z8PZIFXNLiXQcAvtyPOhCLU5IeWNzgX0veINf4bes//0lMhmhXgcgPv/otrBwP6QkmRLMcz4xr6yjgGHCb0e7N806mmgDFz6/wGTNXmXjGu9pfyLfC5eP/dNz1WldPVprWfVMuh0coXv5dB76r0eu47+/1gFEHWxcVKyi7cIonrgwdoZmJNiovNwvg6JIL3ZxdZGYM5wChAAGYZqTqkgPIDIkOuLp4+n5c2nzSkk794V1Pj5JAUbMhn7efepCLcaRRH
 labUPMrF
 jIO4cRFWPHaKePw7TcLuZd4btJKSLTu+I9UQo8Cw5npvdsY+G8XqNAq0u9PqCdWfYgw5R0c01duxozlZrElZ0My8IetFs1Jw1ow762fP0ICgq5elE7lIccRWLk7JVZtHpG3vE0dXhQhDOpS62Z6eH1BGAmVF4QRjnDGkyl1y7rmM24JMvofQVOy4JsfGo4qSS7XOnHYJvX+opvIed3a2R3+0IqctpHCmW0xeSrYN8INrD8RtuMMLQvnV07xFshbDsT7AlgBw/W5OtpMcZjldCNJGmKSStsmmiDdMi50WrYBeYmCies866hsA/9pdWL3KOm2T8Eho+DwwvI6fJGfY6Lek8iHf2ul4+16F/lIX4+rPzjnWiD2Kf01mph6PfUxH5hxGpiglGrj5/wll2I/4YJU5Niw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 11:27:48 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> On Fri, Sep 4, 2026 at 10:47 AM Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> [...]
> >
> > Could you add this info to the commit message? (IIUC, someone tried to
> > remove the prefetch in MM, since they found that prefetch doesn't seem
> > to help much on modern CPUs.)
> 
> Sure. I guess we could ask Andrew for his kind help in adding the
> following to the Changelog of this patch.
> 
> Hi Andrew,
> 
> Could you please update the changelog and add the description below
> at the end? 

No probs.

