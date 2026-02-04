Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB57E83EFB
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF1F6B00AB; Wed,  4 Feb 2026 04:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA9B6B00AC; Wed,  4 Feb 2026 04:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398196B00AD; Wed,  4 Feb 2026 04:28:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 262596B00AB
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:28:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2CB4D55C5
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:28:43 +0000 (UTC)
X-FDA: 84406249326.24.032CF9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 46ADC120009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:28:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b="rRAuHi/9";
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770197322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysLKu0alayhPEcHTLjw+r9c0z3iVlDFzYKnkqtZ1jcM=;
	b=AljPiFe3XGNbc2XJH4Xe0bO+fiTJpF6B06LaGqr8Xpu204JYguRvXGEvA1BGlsBdN/h2uY
	5YeOX4V0lKdpjXxLHoWp8pqByn2rRrcXHoMeCz5kHZQgRt5+39qqaQOIfmXeCBC/wuGMiA
	4i9yw1QKBMrVv0C762y5cOLH0dTPRn0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b="rRAuHi/9";
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770197322; a=rsa-sha256;
	cv=none;
	b=ScazPVokOXQwzUIMjZTOAjl+R9pHQz25TSDFZRb/n7LmwBz5f/xLoO6H/quhC8qY0jZ/vY
	27yhigMLwsdB4GxIg3nr98uId/nz2AQgtGcOoYdNm/KyNTHycP+/LawKe1zhr7Hp9tulpU
	ecYLLmtALieXepilZKKpcUCE+WUrnzc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C1E686012A;
	Wed,  4 Feb 2026 09:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D594C16AAE;
	Wed,  4 Feb 2026 09:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770197321;
	bh=i23KQLYVqaaHnlpy1V0F8zPNsHw9NrW9Nh2uMyA77DM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=rRAuHi/9b6nRIdkkbZ67+NDu7rXjZLms2kDRQQY5YRkj+HMc6Tcm6Ue+GGDg15JN3
	 8iNAt7rzE6PnIQeTfujsWsGKPQmbRlq/Ec4mzAEu9cgi01vE5J455AqTm0gLcrXPS8
	 dJJjMC5t8LMiLEAquqID3+jRhVDJutOIw20gnfeHn7vflpmXmPtDfgDm6zmNkO/B/w
	 tH8lEow9AS4THlw/TIJV2+igES7T8gA9RTDC5iBpksU09Mi4ldhRCMKVOwBgMzWUBP
	 S/wkmmlxnCdp7Kj/Xdco9E3e7sGJB0mh2WZxtYj4GbbOvg8zTijhdPH/699xiPn0v4
	 xYiQivzyOvTPA==
Content-Type: multipart/mixed; boundary="===============6059499729326011323=="
MIME-Version: 1.0
Message-Id: <3b1737450f8be7b9ab2c4a7aab7bc1bd7bdcd74d8ad526c5d60cd45918ad9d3a@mail.kernel.org>
In-Reply-To: <3879deea2efdbc75740e985e6cdbd67a57aa5651.1770194182.git.zhuhui@kylinos.cn>
References: <3879deea2efdbc75740e985e6cdbd67a57aa5651.1770194182.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v6 06/12] bpf: Pass flags in bpf_link_create for struct_ops
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com,
	jolsa@kernel.org, shuah@kernel.org, peterz@infradead.org,
	ojeda@kernel.org, nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, inwardvessel@gmail.com, willemb@google.com,
	kerneljasonxing@gmail.com, paul.chaignon@gmail.com,
	a.s.protopopov@gmail.com, ameryhung@gmail.com,
	chenridong@huaweicloud.com, lance.yang@linux.dev,
	jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
	netdev@vger.kernel.org, linu@kvack.org, x-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed,  4 Feb 2026 09:28:40 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Stat-Signature: o9j7ej736t8ar4ohddct4qus47775gt4
X-Rspamd-Queue-Id: 46ADC120009
X-Rspam-User: 
X-HE-Tag: 1770197322-576675
X-HE-Meta: U2FsdGVkX1/RzX8IILiSaMS5To8gy2Me5+oG9bEcfww482GjnxOuMSV//Rx4HgSH9G9r3Wh5M7gFBkC4SrRhYc+g7E1OIgS+g5FIP8DV6YW0N0JBX+hIMTppRzC+81xCXLIcscwOkwrDV6KVMwqkM6JL4HpJLc45g8AhyRJY3fs6zVBPJZEN1IBIg8aD9RKMRM3eyeOiHZRffDWqD28SRiL56NBl6HkJK7KIzOjjOTm3Klivp/XVW9DyXHy85uUE6Iab8uFC4gU+DZdJKM1wwybqD7FgfsbypLRk+f03d+gcK/QSGx8itANjkFIs0HxgsERF+o4uiI3prIuV1KmADV8hq2Nb+Sx3gKe6HH6m+M698C7tXX7nfthwVq1thCxstjAfsCa9OfcDrcSTq9/R45mT98Ghs4MglvYFYAgNglAnismZa389dR4bd6+OjPhXV3A+rZsSs1+WYvKqIrheW4DiMnspXKXeohaQccPYF1N1uZodBpsnxcdV74wO31U0ys8sF1ggqewvAz5KgHITgF2HmxhhavW6bdoeJCuyQoUOJNsJxjPbim/JSakPmCFdmOvPqTrjX1FF8lij7NDqzJHKSGLdtz3dVyCxrF23NkChkXWlQTtBAHCQwzpPVXyd7om6oaO4bIPNxIgXaNqObB+ZoIZJgz3KqZYUe8mfD838kFU/oGgTq3G9DW96HhPxvKTQEjfZ6QGXJ3yywvhqVfc5++nhfHYW+Zy0TCRLeueuSvxKZCbPcGSNrt88fgoQB1hGHwdAy2VpdegBmOL83p6NJn0u3QafQR8HgOMZTyUhM899CfO/H/iI6y0uBQK6DVfxy1JIwFhr0dWT2OE+HuNKoodMBomR1XvQLBy06Dl3TvzU+5HmaoSy42zgK2DbFVeTsex9KkX8gaPDPMlkSHSqBMarovyzmhMYL5Xgzi1d6zWRy/k82b375HKqifvsVHXHW5AUTD/IbNk1/Zd
 bJLLj8CC
 hEkkFnTVxFcBAZubYyt5vNVi3j97a5tpXsNBUKBTP4R+dRSXiKWfbGED961fj4jilFbgQkl4bckJMu0hg3ZrY5aD8TaaWAfG6m5CpV1/nHf+pMzRu7zOFHJLg9Krvk57s6E/qW/EVms7HhTGUBqcddUXqRzWbv3UcRFTMXmKSOtMubhwA9r/prTcJk1dExA89XEDY2ahGoxib9DgPDaZAJlgfqjOr/wxd6pMPDFFPAiUApwx2W7GRGcLqYIdgWo8WbRD7sccJUwX396bujyL/yku25kgjtjRMYNdTgmBnGnOgGku1H/i0FOk7DbDFmOH2bjPEbmVpmsVJ+3iWcPG5/oToY7Q1PFSmBSPbY4lmo/cqRot1KZmvI2XOcu8dfKPmjLf0LzAhYijsYjz0JmxvCrBQa+PChZGKgekGmAKY2d4pY8R+ANQXjDpiV0Z5kAVIYzJozBi32+RPx+1bJre849upGkOf+kGIXz/1NrI84WvKHIwZibWJtcClPveeZiDEVxVc4yziE6rvEBN0nzT7P24ZjlSKJQug6mpNgb3mXLI9Sk337oKG/4gewHlWLyfDxS6ywDfgH7SM5BJI7t31QniFcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6059499729326011323==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> UAPI Change:
> This patch updates the comment in include/uapi/linux/bpf.h to reflect
> that the cgroup-bpf attach flags (such as BPF_F_ALLOW_OVERRIDE) are
> now applicable to both BPF_PROG_ATTACH and BPF_LINK_CREATE commands.

The commit message states that include/uapi/linux/bpf.h was updated, but
the diff shows only tools/include/uapi/linux/bpf.h was modified.

Should include/uapi/linux/bpf.h also be updated to match? Currently the
main UAPI header still says:

    /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command

while the tools copy now says:

    /* cgroup-bpf attach flags used in BPF_PROG_ATTACH and BPF_LINK_CREATE command

This leaves the two copies inconsistent.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21665371660

AI-authorship-score: low
AI-authorship-explanation: The minimal code change, multi-author collaboration, and human-like error in the commit message suggest human authorship, though the well-structured commit message has some AI-like characteristics.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: The commit message incorrectly claims to update include/uapi/linux/bpf.h when only tools/include/uapi/linux/bpf.h was modified, leaving the two UAPI header copies inconsistent.

--===============6059499729326011323==--

