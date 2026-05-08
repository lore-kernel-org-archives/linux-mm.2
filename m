Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E05CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 13:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276CF6B0166; Fri,  8 May 2026 09:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E656B0167; Fri,  8 May 2026 09:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BA46B0168; Fri,  8 May 2026 09:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 067BA6B0166
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:49:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6DF81A0100
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:49:46 +0000 (UTC)
X-FDA: 84744385572.23.7898877
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 25011A000E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:49:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Brq1PWNw;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778248185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hE3evmT9zuaPzYlm+29Y84UQeLD8xEdrEm5YfrFbxq0=;
	b=gPNFC6jPlUgd1+zOYwum1m2sl+mBEUBZqYfBJO6JAQFD0cJrjevxOPW+dofbTxCqObyweb
	Dv4VxKzotr8y4xgHThfspdIud8VMxVcn2c0NJC0AW21L4W5xffRSMB6H8HoGN6D+NOwiB+
	WdjZrHpcvqAmHaytlg3ER3PRULYYQK4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Brq1PWNw;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778248185; a=rsa-sha256;
	cv=none;
	b=N36oz61kUjj3DzmLy15AcI8nrBCVWG5tNOX7LWZmUUPSTTkvycJ7frwsJLjc+45lyX2P+3
	pLdsJzCUMqrb+xd00BsawBeIZIRUrtHZPPUYA0yIxwQhefF0VahFvcN1QMLLWXqfxLKW4X
	goBm4LfTWU5CdClqENFJudQyxzcZFfg=
Date: Fri, 8 May 2026 21:49:31 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778248179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hE3evmT9zuaPzYlm+29Y84UQeLD8xEdrEm5YfrFbxq0=;
	b=Brq1PWNwnrbds6UweA2vyhCY2nUVm8GtS+tIZm3X2pzPIweAZHs7Wv64AOKWmRI1vsvdOc
	+sAxomsjT2fgSLsCPhsKu48AfL2Nsyq4S/dZuaep65P+00H2ROsSEy1GVMtcJEo2lypHbU
	fdYlq67CLoGKs/UAxnMFJOSJRI3BDBI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Zijiang Huang <huangzjsmile@gmail.com>
Cc: chrisl@kernel.org, albinwyang@tencent.com, bhe@redhat.com,
	flyingpeng@tencent.com, kasong@tencent.com, kerayhuang@tencent.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/swap: Add cond_resched() in
 swap_reclaim_full_clusters to prevent softlockup
Message-ID: <af3p64XUDKCAv1Kn@MiWiFi-R3L-srv>
References: <CACePvbUy+rg9YuDAikGiV1_W5tV8XJnpdcZ8qy8zRqBY0x74aA@mail.gmail.com>
 <20260508113300.3977280-1-kerayhuang@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508113300.3977280-1-kerayhuang@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25011A000E
X-Stat-Signature: 56rkz5dxx5ogz5ybmn474nar37pn8r1a
X-HE-Tag: 1778248182-45962
X-HE-Meta: U2FsdGVkX18SB3Ai4m8otJ9OUiAUaTT77FqR4aOfYz4s9wGgsp9/mYT9BU498TiH+H80S2aWCX3Tzoz/jP7D8YS58h9FDJecqLNdD0Tdg/OB8hgTIZ58udzmlpaDgYtgp506rZTpZvdZE6rfs067Rsq9BA1/Fwn1uhMqOqzCsDELAYh9Nu/WTWhlQooqohQ97A79SRwcjqnyFbmSLNUPF5bULYKC51ajZF97Cmq/MfIoJCerdkSVpideaVIcINm2ur9f4fGDY2Ww0Tymg6US8YpWMwOMED5Y11p43j50bXTLChsfqF1PVMhbp5Ploltm2hfeszy7OZ2pGAiJ2cw/LLlA37fBiOfYDDtNaLsmC4V+DGdxLk4ja1B+WWR7MZyGP48zdqFIU1ooMzijLDbW3YlNhWVGUgBf5kc/DnO6mit24D1xKroqteEOV6k7Jwd0WeLagcduM4I7Kk+8Vo0jT8bJEV1Ht9gCQ1LGZx03rHWiBeveTmcCCdds7U8xpSjfC5ED1O5edp0m4HNC8+9qd5YPuj30BeAGubL7EAsAqeXiA1C6UHnyqEKTvgsE0qMBu3Do4DZEgvRa76LxFOHdnlqRFS+R3MnYGU9g2uZ8SpDpvVa0afiWVYS6KTwntfcDFlWi20B35FV4T92m/thw4SSNtSK26rpDbBvnCzNGHEIqXIevHNerSmp+FJ9gMXEVUUGST6sD1cIoAc3yhguKHB3VSbDbtRRfw0Qkggl+0QLZGYv5MxtmW1kkmO+yh7NVm1G0HrtZzzm8rDQzJ1T6x31gHu3vNk2tsl3pcvYqKgWYQiP05LddNrbiFTQAftLQuYRwSo3moHYW7JxEDyUF8HgfRlM47UH8I42MAkL4FkpgSZ0fhJEVI+u7rvZQ4ZpMv6/37NZU6iadDToZKSgIC/0WizCopoKYhkZLfWnTtF7ThcnoycejbbSh6qccUjT2CG8CDEDmBcMexYRQBx9
 ADTbM/yu
 QODclePguplmA5DfMAUugRIVemmYNtCy9tHkUO4Nrz+YQum8U1e0IKWSYM/Wz6XbjlNb4+qCO+UA8Tb+SKK+V1AJ9JodN2eAY0Xru/xlHcxc1VXnWW6LVc4D3P1sflWRZFhanafmmba/mZxmfDJu7KAHO4ffsoyqF5wU43jm8l1Qy8w6xziN6MGAIv0REgS1rAPOLvzGhReHnSbgGtq/kjnLa+8psiywiDyKDjTTpnRDfqbTbxk+sEybsO9vOaeHIOlEQQdOKuiiGbK13VpzqrftNAqlMAV84oWdD+LEUGFJvpQE+P3tCtMppQHo5viXbpTK6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/08/26 at 07:33pm, Zijiang Huang wrote:
> >On Wed, May 6, 2026 at 4:56=E2=80=AFPM Zijiang Huang <huangzjsmile@gmail.co=
> >m> wrote:
> >>
> >> We hit a real softlockup in an internal stress test environment.
> >> The workload was LTP memory/swap stress on a large arm64 machine,
> >> with 320 CPUs, about 1TB memory and an 8.6GB swap device.
> >> The system was under heavy load and the swap device had a large
> >> number of full clusters. The softlockup was triggered during
> >> a stress test after about 3 days.
> >>
> >> So, add periodic cond_resched() calls during large full_clusters
> >> reclaim operations to prevent softlockup issues.
> >Thank you for reporting and fixing this issue.
> > 
> >Can you add that to the patch commit log? This background information
> >is very important for the reader why this change is needed.
> > 
> >Assume you will update the commit log. 
> > 
> >Acked-by: Chris Li <chrisl@kernel.org>
> > 
> >Chris
> 
> Hi Chris, I've updated the commit log with the background information in v2. Thanks!

From my mail client, I see your v2 is in the same thread as v1. People
may mistaken it as a discussion reply. It's better to post v2
separately. You can resend v2 with reviewers' ack tag collected.


