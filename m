Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77598CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5766B008C; Mon, 12 Oct 2026 13:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C786B0092; Mon, 12 Oct 2026 13:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3396B0095; Mon, 12 Oct 2026 13:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E69AE6B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:09:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A053811E4
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:09:26 +0000 (UTC)
X-FDA: 85314610332.11.7D47AB9
Received: from mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	by imf24.hostedemail.com (Postfix) with ESMTP id 83EFF180008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:09:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VaL6JJ3g;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791824964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JpTqusvCvIzLOMVSAAP/rXcfDbs1KzP2FdhevxXTOug=;
	b=Go2PdoCVfWr4hxPHhb9cxYx4tYTDgNOJ+pM+0JLO75b3WybLcy7qPImu9wvY5+C4LtqYSK
	0MxAFPrYONSJoSgHqD0ryHTPwZN+FSsbGY0Hlbng4nHxpcFVMWRMmb+rH3/xJRlIE3NE4r
	LPmmH5f2/LnWL5yGfPVecyYUZai1bRM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VaL6JJ3g;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791824964;
	b=RCt6k0BYtej8sSFkHeftWY50HG4AfObnUJgXtUxkj463w9KskgAZ79hViCdl5v5pLtIkDq
	ikvVEhkDfr1JapJRoDToRrQz5DzcNEmoVFY9wL23kDBft6fpnvD+64mkXUOsk7R4QHLQ0b
	PAYoiKwiGkb0+il/m65ViNKxYIJBQu8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qDv/NSdW3MzL+jLfvuFsv4SG2honLhUx5uSId8sNcR4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791824961; v=1; x=1792429761;
 b=VaL6JJ3g8i4Pdt7XxbObuaXCKyDmWhc86BRkg0sHdBRYyHQnDrK1V6FA04GApWfmEJSyEqoJ
 IPAjuMO/ZN39dM17KKjtzN0nzHg70xc6CmsVbI1Auzi6sOefPw9bGAfyaSapsRsBMtvzW79BuM1
 1TVlpck7WcIGktWcVrtQ7V9s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 91230e58bb63eacf;
	Mon, 12 Oct 2026 17:09:21 +0000
X-Mizu-Trace-ID: 91230e58bb63eacf
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 10:09:19 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Sasha Levin <sashal@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Amir Goldstein <amir73il@gmail.com>, 
	"T.J. Mercier" <tjmercier@google.com>, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] selftests/cgroup: free the paths returned by cg_control()
Message-ID: <as0UNidNPx1Nblll@linux.dev>
References: <20261011223358.2327625-10-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011223358.2327625-10-sashal@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 83EFF180008
X-Rspam-User: 
X-Stat-Signature: zw3gcrkt9znewzjtp7sse84fjez7uph9
X-HE-Tag: 1791824964-289987
X-HE-Meta: U2FsdGVkX1+2Z+1Jmktmz7QHu8bzfpY8bF3zNQhC759pNsW4QA0dO12GSoh0Sik94Z42DLi+1MKH6Wv7fjptQ9rDzRWUnlYY3oX1wdDH20+q0ljxQ3Q7+/P/Y1tpTMM0SKoodeik8Jh6ncdF+9Hx3um6zwzqrkVA4NHShPKXdGrAWzAiM58UWQl4rkDshcAIKNbfaiuV9z+Mbir1dNvlW77GzJ40j0umVTPAG+9rvLbUgwAwOpylgTmtqVmBT9/zmnY20kWYpISNFaWRWPFVbBbAhulK8nxCUcnZKZ4O0L2Bb8r43Box7XMMR2u4SLZSH0n4v5R4cnhV/A5jVG1vJ5Halt5ofrK4IXQ0LJ7t0rn7ihaIIICVeXBtxDbIBXYA3NTJfr5Bse794UX+fmny8KbGqjV2pCAYpXc4ORc3Oi1cMw6jlEg40d57W+LUSSa+E8nZsOtzRX0PCV73invbpHXL8Jkfl37j+IQWY/yLq8NeH+i1UVsr4XBFSlMGPDr9K8Tmcl2KiaDhhRB7Sjkn9OftV+RKkW07zzbEuiYBoClrynEhiMgkbA0qE5Y+nOKwZkLqNP9/OzEWdLTvTubN6Op+O8IecGjygAaR749zUjlNao2ZAaDiLYt8Vrz7g98u2BmiBJP8pPVsJHDzuM1sf8JGtsl/AWZcx9FRmiTdiqRbWGVHdJHXf/SsfghiI3K8vTqb9FbFmaR9tV5ZZSIq5s9yMi3Skpi+8T18+W+ZZTFgtd78NIiELQED1NfjRJk2HlKAqjkdCcrzB9B+CPnkEPH/hNqkgqkdSz1cBoLzeCbbTROQPz0e9YXxbmZnJxP88qXLKNno7rw3+4+QKNAAKGxSotyEp9N3WKeUlEzRwk3auEnhmX8lMjJTM+xObSEOpl3/YKQh5xKf/ILX57p0E/Yydhhy6+53AuQiuAl0jYLSwMH9Ikz2iVLcoKo+rkANGs8Bx5mzqrwFY3wrKbr
 DwYq3/fg
 XP3eGKPSE91rZiZD2RBDzZzS+ktc2EkSjFUpZrScOScmOShgfQS27gWzf8HKYmVe+n52CDvk5Y+eaqAmX2mbbKHAP7Ajr56XemOpC5Ia82V9SFSg1e6wJZnZWhFSs/0bih34ouZd+7BUg9bfK5T2DnEj+XocMXW6eijZUmqeEpRHgYuSTw3Y08hD/aFim9jgPlBew+57fq5oGgJ9pTV7BVsgdSYo/fhJPDAukc6OEX/7SiZ6EPK3aYsWWTuOVcltkUJxXvsEKEE2Oj341afJ5FvP7a6t3UBeEvxvXARDNRHTTobyhhB0Ih83Cz4dBK42UfFRKI5NgdkT2aljJKnFuSpshHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 11, 2026 at 06:33:38PM -0400, Sasha Levin wrote:
> cg_control() returns a path allocated with malloc(). The two callers
> that pass it straight to inotify_add_watch() never free it, and pass
> NULL to it if the allocation fails.
> 
> Keep the path in a local variable, check it, and free it when done.
> 
> Fixes: 5313bfe425c8a ("kselftests: cgroup: add freezer controller self-tests")
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

