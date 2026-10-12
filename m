Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3EBCCA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B962F6B0088; Mon, 12 Oct 2026 13:51:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6DCE6B008A; Mon, 12 Oct 2026 13:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AACD36B0095; Mon, 12 Oct 2026 13:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 822186B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:51:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EE7BC12B9
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:51:56 +0000 (UTC)
X-FDA: 85314717432.10.13CDBD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9F900C0002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:51:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oYo3Ib9T;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791827514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=kNahywYLBv8aIcm/NKKEaAKhrF/aTvhTm1jlesIR1Tw=;
	b=vnXBvaeKvcY7ssZXXBY/y+KUwEhMSzvYhDbosTMo0k3YBnoEhxGoD2Df2LV09VaCsgXGlO
	5HQVkDM5WTvaIsPP2fOG8e3BsoSMju9raUW4S1eQLzc1Q41tTILqcPVPyS5xxdKADDuz4i
	1tRJjU9Fjm5XwgGuBEAh+YY62QsfegY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oYo3Ib9T;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791827514;
	b=gsnEMDqayxyQALEiKv/Pf8ND7+A0H56VPfhh/2UYd/AEuVNqmiN6UfTiEQPQ92t0eG96EV
	3ep7jRwBEcMQCTa0+8E2f9qaGHcmy//iWmyupnxQPdeWSB27falkKjlatzgM8RLKdm9jX0
	PTmFXKA0Mb3N+eEf2J1DS71isVmsG6Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D69E860142;
	Mon, 12 Oct 2026 17:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F5D1F0089B;
	Mon, 12 Oct 2026 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791827513;
	bh=kNahywYLBv8aIcm/NKKEaAKhrF/aTvhTm1jlesIR1Tw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oYo3Ib9T2TZSshkFrVUqEOLiXFfRi1YL/5Ep6sBc6dUG5N/yAlaONNYFmgvEBgrHc
	 b9gj1QMF/XT2BhOc8rgrHhkT2xYAb2qbmTW1urn3miOGHSekiPjh4ErT4cMJ0M/21i
	 9a/MJ3coYndW9WG5251ppIixuze1q+EOYOT5rSnr4G9VGICdyxxTbg+z3lo8BYW+Vs
	 EEGdBOaSVLLMudVkvldsDK3nm3hwVFj7QKz5ZiXF152X1DHBP1sEOZXa2Gl9mEU8N2
	 i6fzl2GUCx66cs+DXUYZo9F4c9PdUJTvzejtHoBFarjZMvq7xew3/QlWrXnYjxjlVX
	 Thln3g3+yC+Xg==
Date: Mon, 12 Oct 2026 07:51:52 -1000
Message-ID: <d9a3367a1852158f60cc2e89677fb12f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode selection
In-Reply-To: <20261012120438.52849-1-laoar.shao@gmail.com>
References: <20261012120438.52849-1-laoar.shao@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9F900C0002
X-Rspam-User: 
X-Stat-Signature: u4trkponyub89ce3793ta5tzz43gd9h3
X-HE-Tag: 1791827514-593477
X-HE-Meta: U2FsdGVkX1+irHFF06kSrm4AzisLZkwQ16Tvd6GyIrQDLSJ7ZOmPqBfmE+4nLUIVeViRkRjb7pY1NOKhzVs1bFMfL+lnRrkFABKMEjQpRCvJIV4MYZMoaDz3ff9Yxnll15Bh3MD0AG0cgdUDBFaI1cnfEzUiGEvc0hmPNIUk5es69BbT4Zrah8W+IZQRO5JFtI4P1GBfE9LiQ9o8bOMdnL1e0X4l+bfTgl0DeriwYF32wzuUfkIlS4DdrppX7YgHjJXYbP23aXCxBh8eJ9Vu1AfsFh8xwGeywS/kUvokDt+9Y2pt9CDo4WWWlCSBbvHglB4s+BpgaDecO30EQd818XD9AuMZnjgmYwSVTPPeKhf4ICWxDErLx2tWCty8Z1FtsI3sXLnd7ZbfcLy+49p88ASdMVoqzm8VL3xIWFnVp3k5rM0qXS3B5xnBWLWAms6MT8G6l62/fexn3X5Ymyy/Q0XWRuvgpUhJ8Sl4BAK/dlRUREFtwKKgoGBSJxXhaxCaAuByZsYCkRtSpXZ3DVw/pp4sFDk0iDUjIo/0xKV2UYyh2VkJ2+H1UcDMaa/Qi/CDwFOj/EXX1MxVrrA7l9yNJ6Xsn0bTOTK3o7JpzwnjEMdgPSrjOwkqgark0VKbM4gtEHZbN/MmI0HGkAeVawtPDW3MnfLnbY6e+ch4xpP4MG0Vbq0ht4LB3xYeZFRe5gQiNHKa8YPnaUoEAAnF/HCqQtsnb6xP0sHwcGhFbF6RTy5g5Gw4yZZyoUSX/V2O4wNjrkog3inIHN31ekvW9pIjzVwGgHs6jOVVV4KXY0snbaeO+tPDwohYi/fQludWWupjgEReTWPLRvX6w+KCXcwbNMSTM1GtquV5jRmR3pIUYL6X1wrim2KZvMYOKZUAbtsbD0QzQe0Djjdq7Q8M3DW/Wshufq/g8WCfQdxDIjFA5E5+HWduK0ZORiOrNdYw5OHNwHE7pjLjw0IeX3IG22u
 J6vXOtlf
 4Zv3qybll4YM46laxivAx5Q4WOtl30eQdXCWo4WhzRQPp8r3fLfyi9dxfw/VwwqOeN+ZHYqjQiIO69zZ6kMGWuJ/eJ83ai0GwIH6kUwTnn1hFtAhiqw2dyWpGDp0JRNmd86SSaijueM/WP8HCmeq3qbccnyfxsiXD6jjCauGihHBUbLqn6bhzeEYMQnchhsh/EiFoKTF5Jpn69s3epn/pB9VU/mo8BfPGQ31uLrnrJ7Ya1WbiOmw8BHjdH3TTlOd02qL+PV3JxzOEQH+JDR8sf6qQoFdeEq8RHPTDivhxcCrvT8lZZgUpPTe6JJTUpYGYsNHr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, Oct 12, 2026 at 08:04:35PM +0800, Yafang Shao wrote:
> This series adds a bpf_numab_ops struct_ops which attaches to a
> cgroup. The kernel consults the policies of the matching cgroup and of
> every ancestor and combines what they return.

The op doesn't compute anything. It returns a fixed mode per cgroup and
that's all the series uses it for. BPF is unnecessary here. This is a
prctl() feature, not a struct_ops one.

Thanks.

-- 
tejun

