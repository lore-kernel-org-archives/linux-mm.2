Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0162DCC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962E86B008C; Tue, 13 Oct 2026 23:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911EC6B0095; Tue, 13 Oct 2026 23:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82AE26B0098; Tue, 13 Oct 2026 23:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 636436B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:35:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA842403FD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:35:46 +0000 (UTC)
X-FDA: 85319817492.24.74B9C58
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23E6B180004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:35:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YVEaxKny;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791948944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euiiv0haxE5k/k8PT/ZRBONcRT6uKwGCzJ99UZ9s5DA=;
	b=Ugz67pX0VRMSobDIT4BTFirnOUZNjXWM+1cQkha94KEt3vJ3/HTXc3giIJzVBcdxXKSsuo
	E7qP5cSORi/K+Afu6xxxypZ46CWhCfg4yGOLs/+GV7HothXlmWzF3KD+OtIgAHuMbE+52/
	yDTW0oZ9OERbcHLhM0vs6sB6FjjerAA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YVEaxKny;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791948944;
	b=P/PTCXJFNbgDHNFvJzfWIKWzgRLzskx5snxtCgKQnOajWtctx80V0aEVWbfX8/o4Fckr8F
	DoyCuXu0bOI/z2hd0HJI3tflYFbqxDuT6+Olc95nI1Kzq7Dtc8D+Ky/ZA3+lwRSjknwH/x
	+XHbVU5Dx1l9r1m0vrgGSZw8VdyhEAo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791948940; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=euiiv0haxE5k/k8PT/ZRBONcRT6uKwGCzJ99UZ9s5DA=;
	b=YVEaxKnyC+MEEe8PEvNt3Ayag/57B0rxh1MJSV/o3tMucxqMt07PzPcdk5c4jhPNs3jltERPS2XNFKr/EEm9as9iTIVfKmCeovqjMJQknc+zBBJ284TUyio7Ajx56nVRD5DlcADJJUsA1MwuPAktDJmhZEWoCqh7p150s9JtQbI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCnt3KH_1791948936;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCnt3KH_1791948936 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 11:35:37 +0800
Message-ID: <303ad1b0-c2a9-4608-9fec-e94d592f4593@linux.alibaba.com>
Date: Wed, 14 Oct 2026 11:35:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
 hannes@cmpxchg.org, mhocko@kernel.org, ljs@kernel.org,
 roman.gushchin@linux.dev, dave@stgolabs.net
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
References: <20261012022917.1102467-1-vernon2gm@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261012022917.1102467-1-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 23E6B180004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 6zhoiq6199g7ypzjbcisncyum7dhs9gp
X-HE-Tag: 1791948942-679274
X-HE-Meta: U2FsdGVkX19w1FGmabAxToLwHZ/w28p+iRgRGKOeQVOre8HsxhFMcezV6nX2Zn8HbZXEpP0W+U3b5hZo/cxpnu7dh/2jeIIIjhg5qvyYmn5gBIGCd3QDkJBKd3PutGM6r/3P8lhfWxjwauwTtBR0K4akrQPSj4XWHImOXKFNh9lsm+FsDvTbUIrWcGekxVfwTzf5vBEtdHFQVo5cJtrkylWlpRJj1wlTLQias+Dy5EbwEE3Oa2NQCvf343JX3+PjDhILiR1UErDKL0Ehzltu0Nwj3FaEEubhRN8d8mqP6DP8tEVeJd9PH/vDU5SDdxW2e6+yxiyn4WifzYk38OluoEpdZJkybYhyPgz49zxLAH2ItA0DsTiNVwwkrJyz9iGszSWFPD6etAEXm6kJelCxQm5ertSe+i7doysBx4JTNJD7SoLfNiQ4225gVwYk5eSCNmqqzIGurDV4k4u2SfKk18euNxWblytJXZYUQydaJgG5Pns7fW079/QfVNSu8u3VtzfHf8NCTHckbqcyuGt+cSTVYTHye7Y8OV5UnGRnSx12TsKNDtlBvPAm1qXWwR/Yx/xZYGfgls5GCCeTB20zmC4i30m/7B202fSiu3XioBBaswudW8It+mNcYjr/YS3fnPm0NLfHaiRDZuTc4iVXuACTogY8jAbPY1bLk4xXDH5VRcQdjYvXN7LniAokPf7w+85QJlt4x0aRwOL1Kh3iikJrJDFcRN+Wwp9lrrPdgQFnw0jSntzAuEPaNFywx9Fap849BP49gKKxDZmB/3C1JcqWj39izRdULYFUxGWHANCWt+axycv2IyvTy/4rOefRRb7DN0ILz8qcYxUaWWjb1jg+Iw6QZaoXVfqye+5KrQ5KqiX4lKtkjcwLGeESt+jljmh9vpUNv99CSVYWFCTyLLPdfr9Fo38x4sukYDr2DFqG/ih8DqY/jdzbHGabvhVrcbTHieqMQChKeTa88Kz
 lIaRzLdh
 fjLH5HqhXeKgtcNxPsprMpdWHLftVm/4+8UK2DFkXhbJtXWwTyJQQMujoamzaxgSzKR4Yzm1tBE2S0BmpXFnKWUChpQCil9P6MCRw9ABLyabB7mTEloMCcDJ3rZywbFCY4Gcdy9AwudpygT6fYSH9LS6LzdJWr9O41jCKJxfMRnQnDaVWMvULrICN4ty+jNA7qDfI5tiTku0VodzIX5s4qrEuUAKRYQzfUxkNLjYCWZWkS2RmOTkmDk7zuzzumHqLz5OjnsC2+0tjRbxNJervNDPAge7gW5SxYBbR/Whyv9ar2l3SzsvWecuLS2K539nALqUIQhwGfNvOpl62lFRsoLkOo3d9RXNTLE+T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/12/26 10:29 AM, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> When the cgroup has no memory pressure at all, writing to
> /sys/devices/system/nodeX/reclaim triggers proactive reclaim on
> NUMA node, causing increase in the writer cgroup's memory PSI.
> 
> Due to this reclaim is performed in the context of the write(),
> accounted as memory pressure on the writer, like
> commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> as memory pressure"). This is unexpected, the similar scenarios (e.g.
> senpai) will continue to occur, only this time it is for the
> /sys/devices/system/nodeX/reclaim knob.
> 
> The Documentation/ABI/stable/sysfs-devices-node documentation also
> notes that "This interface is equivalent to the memcg variant."
> 
> This patch unifies the semantics of the memcg and node interfaces:
> per-node proactive reclaim is no longer counted as memory pressure,
> and the per-node proactive reclaim interface no longer produces
> phantom pressure.
> 
> I ran demo[1] that performs per-node proactive reclaim 10000 times
> in qemu, writer cgroup memory.pressure as follows:
> 
> without patch:
> 
> some avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> full avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> 
> with patch:
> 
> some avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
> full avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
> 
> [1] https://github.com/vernon2gh/app_and_module/tree/main/reclaim_node_psi
> 
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

