Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49C9ECD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 17:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9B26B015B; Sun, 31 May 2026 13:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880B66B015D; Sun, 31 May 2026 13:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796BD6B015E; Sun, 31 May 2026 13:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66E0A6B015B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:09:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08456C207A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:09:09 +0000 (UTC)
X-FDA: 84828350418.23.DC85041
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FCA51C0006
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:09:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIJE5abn;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780247347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVEJL4GEwkXkrp6OsZZkCybl5z2/KKltadlzYqj29wI=;
	b=s+nk/fYzHXP8sJQfyhC7hpUYP2TbDYoHWD6NaP808loeUF4+oW3zFFfocmG/grQ/jfthEg
	siYY43JNiW52SngFn+ojvCO7+lNfY1T3DAw9BaJbBUHjmshzzGY5Y6OYy3L0Ky+m5EGb2G
	F+9qKusqg2WZJl2FXNzUDrKN0uAWCz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780247347; a=rsa-sha256;
	cv=none;
	b=EoBCZ0JztRE+yiIcKeIFPtJdlCjH+xt91NrqtBuRYB5W5ZIGIgJ4rSycgs9/5RZDNwjaGQ
	ALLb3V+5Zku8kZPBaf+BwAiXfLBm6xhXd9F1xs8trKK/yJSkm6aIXX88TjQhSWQslCNlz1
	LYLhp+4Ad62YpfET1L8CI4TpWIBl2EI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIJE5abn;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0308D6008A;
	Sun, 31 May 2026 17:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897FF1F00893;
	Sun, 31 May 2026 17:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780247346;
	bh=SVEJL4GEwkXkrp6OsZZkCybl5z2/KKltadlzYqj29wI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VIJE5abn5CItq56HmUAdW+Knc3RYlzlx17YNtux49HXAuFoZ5mrgTdG42OZxZ20XW
	 zfe/XXcBnZAMbDuWNIh2CNnXDOB9QtCMdDlORVJtZiOa2f7KFhI5ZsQ+QVbwgrokbi
	 BzQdroh8CHBXMyQ3RM0lCTErePv+oXad+PA4DrKKE12M79hS8nnabqO++Ml7MRi/jk
	 876Tt8TcYO/m5XbWAShgoX2dVkCpKp5ZTSaTG+RyLOn4z/pw5g4lqnxYSW32tuKZuN
	 +mnja4ml2mMwSkQo9K2R6ai1tO83yq9cgZQdfdMLSgaVA/zzJIh7+CVm7vpe3MfznR
	 Eklpd0LVEZ1Rw==
From: Tejun Heo <tj@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>,
 Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Natalie Vock <natalie.vock@gmx.de>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6] cgroup/dmem: implement dmem.high soft limit via prioritized eviction
In-Reply-To: <20260531-feature-dmem-high-v6-1-20563ecd6dc7@gmail.com>
References: <20260531-feature-dmem-high-v6-1-20563ecd6dc7@gmail.com>
Message-ID: <20260531070612.GA03193@kernel.org>
Date: Sun, 31 May 2026 07:06:12 -1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: eucnt8obkx699nrskc7uq6eaoxm57q7t
X-Rspamd-Queue-Id: 6FCA51C0006
X-Rspam-User: 
X-HE-Tag: 1780247347-951766
X-HE-Meta: U2FsdGVkX19PjyFWwJ9I0lj3ukcIxxPfcEqzB1TXz+/Y8IZktvZqKaSmYVwOnyxemJLhjtIHdzWUFhRptH6I7htloKUuTm8npPLrR3ABG0uwErboMKPIcgtHKIjl06XL3QDpDvUsPwcnI/WJEYqDeNbIiU4+DpI64JE3fAWuRFFM3yVqzk8x1Y0M1MeJyNPPOkXAY4Oo46Iqe9pKblxwnPRgRrkaLI2MEL44ZgWU1PEJxxI1L4+xmGk5AUpfEVz4nu1TXCJF6mYK98b/If4OBpQXHHPi4p4SJKvC7umzd4T/WglNIUmHpW3HQHPE20iUqQiX2KdfrQs9sSUQV8U4m3slpF1mKzwF+aMdIyhxD0MnGF3INjgO6ysRrtxqm2EkmvOf0LiI2105Dc4K5FDxEQ743jYA36mEOIxB7STJmNbo0/4zh6cgRAUstYFTF2dDPRaVr+dIVQxyW6Ki89DV2Q0kg1YO/MthKXJdAwdmCSVnIYMbSszPrZdWy1yKCIZ5xrayh4rkhRu3FWzbGJiwEp1qGU/qdfJWaWTjyDU4vAjPLUaGTXxxQWR04m9ODDd0tLtnasPIoXk63CryUrAFWcKtbL+X042dfOlgCGzqkI4Uteiks0remR6q/M6g1Y3MbAnKGQQez5+d/u6SMOUBWYWw3jcpJaNGbNjU2uvPT8/Q5DjuvhU6kwi0dYkqHnK216yddTcXob11nrI6j/+AtsKR8SZfHTsLKcvbN8BidbZ9dD4NpvM/PWv4M1RrZD/YkmfG3DfKXMU5cgdtIZtwiqE5aoUD80dX8Wwk39sLjDHm6sIh2g59eFLlUu4xsURWTViG1Tait2QoShJn+QOjoIl22di/aEA8jGAcDyM1LLHvTYDf92aVctuDRdFMrMkO4EdEgexKxv0kUeHjDoqcedZf3vXuuAECLzBx1EoHPSraBiRjQeTuVga8BME9/nGRANoCaLpl54q01o5kUkf
 jSouKEv/
 iZwb9K7sJCA91IAZxitrvXyacbIVbEbncassPs139d3p91NfnBfGUW1G1cEeaD60bQTfk5MlS6QyV+RoycFZIahpUPqHxaO0nfzzVHyk8tuRVEGHrMkTiYd5VwVhLGmw6L0RMHMFu19BD/QVcRxsn5ztElFEdYXECrtUWKrJrCykibrqGlf0Qe/N4kPlIuBRXwZaaL5tkXXogk5mer9lx5J7ZoPtpwiUueCNkheuam1/yRrY6M3RNKLwepofhNRy1iaOI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I don't think we want to define dmem.high (or dmem.max) in terms of a
specific reclaim mechanic. These interface files should express a
generic resource-distribution concept that stays valid regardless of
how the underlying reclaim works. As written, dmem.high comes down to
"evicted first in the high-priority eviction pass". It isn't consulted
on charge and dmem has no proactive reclaim, so the file does nothing
until a dmem.max hit elsewhere triggers eviction. That's an
implementation detail, not something I'd want to commit to in the
cgroup interface.

It also reads as a way to work around dmem's reclaim behavior rather
than a soft limit in its own right. A dmem.max hit doesn't just fail
today: the charge returns -EAGAIN and TTM already falls back to evicting
buffers and retrying before the allocation fails. So the question isn't
"max fails immediately, add reclaim via high" but which buffers reclaim
should target and when, which is a property of the max reclaim behavior.

If we work around that with a high knob whose meaning is the current
eviction order, we bake an implementation detail into the ABI and make
it harder to give dmem.high a proper soft-limit semantics later.

I'm not against a dmem soft limit. I'd rather improve the max reclaim
behavior so it makes sense in general, and then define high as a concept
on top of that, rather than the other way around.

The whole max-vs-high distinction and what a soft limit should mean has
had a lot of thought put into it on the memcg side, so adding the memcg
folks for their input.

Thanks.

--
tejun

