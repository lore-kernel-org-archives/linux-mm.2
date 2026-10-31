Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258E3606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 16:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=w0+M577m
Received: by kanga.kvack.org (Postfix)
	id 1BEB96B00EF; Sat, 31 Oct 2026 12:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FE56B05B1; Sat, 31 Oct 2026 12:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062B36B05B2; Sat, 31 Oct 2026 12:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCD6A6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:53:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 042B81409E5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:53:47 +0000 (UTC)
X-FDA: 85383518136.07.D51387A
Received: from mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
	by imf11.hostedemail.com (Postfix) with ESMTP id DB11240006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:53:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w0+M577m;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.198 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793465626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXG/VuGgA2nLHyyo2HBxCIFByTCjqyBPDh3lixMNfY4=;
	b=syeFJdIv2JcCRq5NqMnuRtCKzSjcn0n7XKv10bUM6Gu3TLnVI0UcdJX/kNlkwDdPEq93Mf
	8ZVQEIc4Pb+FGDnRNpNcn8kCFpl9AvtOYgUCB3V95bNl996kOyJs5elL7WD0vdZC2MqFsN
	R3fW8Jq2vCLSvDxmJ1Nea6QbpYfnuxU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w0+M577m;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.198 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793465626;
	b=29CVNYhT+VvoewGA+J9pDS43xbqtwrJ73aqQa8HJNsKrLbVyhIvebeQX88lrL4KyiBmWg4
	RuzgY0F70qXws9AAUgD9De66buREBD+HfPqvQum/C+IeQbsVu/nVLZXw2r0sfneV1s5KXw
	vFtBMIT5qWIQ3Lvk2srEdYYvR8azThk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jade3sx8Nnul+MHi6aqoKxBIknYtcAapdEpzanu8AQo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793465624; v=1; x=1794070424;
 b=w0+M577mVaWzqtdSUI3kEqiAiA64yOA9tnImxrrKnPp7n5JJoXbPlfWGM7FwWuWM5y06ESp5
 MUs5SfJhO0QzMIWJKGHpN+UTN31dxavlleBVkc1FZp9bbfIK9kTN81+qB4EclE5K4IcYPCdnAGV
 6PrUwCvKHgOS1w4QSUcd0Co4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a73ddf1f7291a74a;
	Sat, 31 Oct 2026 16:53:43 +0000
X-Mizu-Trace-ID: a73ddf1f7291a74a
X-Migadu-Flow: FLOW_OUT
Date: Sat, 31 Oct 2026 09:53:38 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, 
	qi.zheng@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org, 
	ljs@kernel.org, roman.gushchin@linux.dev, dave@stgolabs.net, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
Message-ID: <auYc-G488bbhy9QY@linux.dev>
References: <20261012022917.1102467-1-vernon2gm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012022917.1102467-1-vernon2gm@gmail.com>
X-Rspamd-Queue-Id: DB11240006
X-Stat-Signature: mshhhbaxqwyurg76osrs51gmaoz6y1m9
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793465625-947584
X-HE-Meta: U2FsdGVkX19dusDAg0wiXNtGGv2SlEB3pRV1jw9ojxd75pK3/kYSbCBGFDV6cWi2mr/N/nMlWnt+xA0+1Bu/PKiT9GBPE6SD8idSuYZuKfVmWjKbrTEdM0bv1y2oWqCiHL2eTqXVVdhDA/zqjHvouPQLaPM8B0WNGGeQZnoGY8WkhpLPGBVTJJOB+gE9JUKbPJTpeAHlqPnPAdcUhIJyS3Ji4y8HxtiMK4WudhrmBTtm18XBJuyh76x909c9rHwguInA8RFEgIsSQgCONC7+tUhqdHO+J+619PQyU7o6qxivKZlk16XIaArzwL9dIGk3FEvtzqpM1ipDjuqgvBW45foTAlq35l0dzkI2S2XQoC/1eyPXCd+sx2n0p74xQSLILyvJLS/QJ5+tkqXwk8mOZ+6OPK8grGeWQGagCqJ8H6i+N62EiuRpAc0gJ8ZtyX3BoyN9Bmap0miyJc0Glc5mvQe4Or2w1nSeXyQzO9lpm/TdZ9TWCEHCJTvDnIIx4qM35ReDCWQIxMy2DDACtp96uAYCRowG+XCz/Jgi6JjSimfTpnSWo6/E7lOCM4zDTuGecveV3vXPHH+0UojtPdHU+xaq4eWqFdlwqrNDNKo54FLjbXO1N7mHO3MQFAyorG9aKqOUiJGFRjvI1R03zPi1UBHkuKJcqFpSOnRx+K2+lgB3BXp89380QzgquK2OYIfA6ml8ST2mhZ2Be9wIDcEQMXVINC5T+QhJ8uVIHzJk8uNXaN0Evx4Nbi10Pg6irybNWOn5QmN2+tmfe7guBJoUBipO4nbsPcfYiWQ7ebVus8BsSg5kURpWRzorgGNC4SrNQ9jbafGm8NKfjIoJmj2Z+Vu08t+RTb72iN/j2B8xyooImF/qew/T1wCqO7k0RbA/jzf16rW4rqmEvvfuZ2bf4LNHizMnjYpMUh/FJ08bEFcA0yilYAN9430JPaMvMaAbG+dRPlE1mII887WfEwV
 CiIwHNou
 b/jUeitRPsnQAkJ7fgB6SjT76F1NKQLldaS/iutCj23LQzs+Vr4fCtitl14GGEFif+VJGBg7uZ2muZGYtNPrVkwYFWvAFgSA4QsXboE2mFNfa+KKO98sM2jDv7HJRY5NekG9OH2jW7gbQ8OWyjm2ybE5igHb/ZMRbo5gINnTHoLQ9W5L6ep9TC81hzT+3G1vWxVfxAAlLLpOZNDsZg0pdqVOkQdDawJ3hsC+1rBRO3lOetgT1h7Pe8DHZ9SJlnGmHJKwKsrpuxFSfRMFVdx3cETWscomGLbGnesE337iCHrofV6+lbZob7hvqvyHaTqN0o0Jj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 12, 2026 at 10:29:17AM +0800, Vernon Yang wrote:
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

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

