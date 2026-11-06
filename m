Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C77606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtvFSfZ9
Received: by kanga.kvack.org (Postfix)
	id 988FA6B05B4; Thu,  5 Nov 2026 21:50:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9602B6B05B6; Thu,  5 Nov 2026 21:50:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876596B05B7; Thu,  5 Nov 2026 21:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C59D6B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:50:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 127DE14021E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:50:12 +0000 (UTC)
X-FDA: 85403165064.28.01E8072
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65BA61C0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:50:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtvFSfZ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793933410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeHUsE+SloKGZb0nWVK8kl1QgbF4g6Bp+EeRtt1tz5o=;
	b=C4kOZU1MGiOdwrPSBeYxbObseQ+OwpI6/5FYKplgySHRpxEBE7ml3xhrEUiVKiywiH30UW
	iIzDC5WPtLuYgcNtAygSHvb+4FcEDJbpTx8uLYCm+tG9ApEbic8FJhrLlOqNgCvIinpNoW
	hWDpCKu3+IHyxOmH1OgPlUWRMcmzBz8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793933410;
	b=6La7DIjXtXVFfYRYxPxnJ9tVXRtjwElV6FCge2GYqLqh1+wMjGnO5C+h/0GGDH52zTIMug
	JO3EZlQqrf+CFF/xoX0XftdvpXdaZ3t5hSKwwWKbwzDM5dY2Chti4gOieILQJZOATdiPRl
	YMpKDP13akQk6Bfkjpl1X0jD+bax6OM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtvFSfZ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 512C7605D7;
	Fri,  6 Nov 2026 02:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7571F008A1;
	Fri,  6 Nov 2026 02:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793933409;
	bh=ZeHUsE+SloKGZb0nWVK8kl1QgbF4g6Bp+EeRtt1tz5o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gtvFSfZ9m+fLuKM1/9rEZM2ceQdcH9suvfvMXHObJ5lNiG3MvbO5N9FMXzhbbhzSY
	 h8GnvcBDY7v2P+YJBpU8PIvOgCcu7aJgQNyx6lvKRcbqh//VIQhImw3y7RmppZ2wrU
	 vD+Mvb9GYvbLTKzXWP22OzccUKnp8HqCT/nXCJEIRekkf+jMsOZYOG5nKv5UhsPtEO
	 LLWpO1bx3uz8Ev0vF8GTnp6XWw4cZBk6HJKSb/unesxhKY8PQVBW5YCbCVLMB/Ak5d
	 mdyxmwIXL1tcJIDG+kFV9RdULXW/7G6VM63RNhsZG/WLZjcMb7qbRYmfDKbuvzw0aj
	 Xm3dzzi7TkiKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D81B3391B1BF;
	Fri,  6 Nov 2026 02:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 bpf-next 0/8] bpf: Add user memory kfuncs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179393340767.310219.12502983957867843799.git-patchwork-notify@kernel.org>
Date: Fri, 06 Nov 2026 02:50:07 +0000
References: <20261105102343.311331-1-jolsa@kernel.org>
In-Reply-To: <20261105102343.311331-1-jolsa@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
 linux-mm@kvack.org, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 ljs@kernel.org, john.fastabend@gmail.com, nierro92@gmail.com
X-Stat-Signature: axrgtgykbh6srmpng47o651jwk9wi6mc
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65BA61C0002
X-HE-Tag: 1793933410-204062
X-HE-Meta: U2FsdGVkX19loOZLzfb5FiYkfEroaesqe5E3UP3sTO3lDqiuzfEOq5qpHR+CzxxJRGIzujTmYD3yf8WNW63xnEdRMDGS9tg6G5mq0Bdh44SpWtBl9faNHAeUxC4f4evXICnh59VLJVYxG/M4ii9tPu8ZnJow5rfmKJxmP1eU4+O91v1LkMLaW9O/VfnKc7bjQTiaUj/ZOfjTohns5+5EHdz4fdWqHcFPt3bhThsrV2cFwBwuRsXGp1ECJIrhMmdIrQnhLHeg3ftZNdzImYm6QWeDiOifafyn97tgoFvuw6pJyo7FZWVh/u4g2dwgq/y5Yb/nVpOBlIwtSBOQTABY7e9ecYcdVEQh5i6tAufjE9caWFMcB3iWz+VLRnZ3KF2Ww7o+3znZNU8viJmNv7yQw5qCmhR6IJ1Hr38/H1eLlcMAy36BBtdhYCcl2mpnOys8lkiUhFnOPZhLcpdKNmOfzIJz0pcW7Etwy5LwbFSVD9ztq1aSO6Yc68MCe/MFGmBULjX87Dkf8CWtMBQNmXXWCrhKd+joD9WYy1KD8Ytp7lt3SLXSCd1GHF60212SlO837b/OzZIfIQwyoV8d8XbZygIdaXNFdX5Ampdk6cpHVKSCP4BdXOFuLGV5AysWB4GWiuZ4yQxGJmBG1aho96FYbdNi60/g7A4uXcd+WgAU4z/4nGDuzA8ZAmjoUeTAgzk73wCxV39cULEJLCd6KXAjkzmFVSaFl96A6cjmqTzFENiI2ySG0PWzhD/gy6dX+YHdxlXyABIJVUDfp9HwBh9Oy+gTnxytvGblcrdq/vfA4obk/Je25sZmmcUPi3YPN8G0+fBs/gBwRnl6PeLvg2d+Fy4M4SNd410V27FsX+y7UHL0u6qPSA5x4dSfQwKxNIQBMl+WTyd6ct//7KddoP9A4vlSoCss7xRY0t2igpga3WdeJvmwKxwwERHFFFpWeRYFAOYbajg6J9hyQuDBR6K
 97peyw4/
 GzxDqGOKo0OupMZPdo/8GmCn2SFttTYLGMLW/RPP+XgluLZAsr8nfZ3I9OsrPyffWTj+ExVBAresrUkTcRTKxKndKo+rwbcq5YiqUhYdyGQHdG5dv5Exd4Oyfxm8paPNWhLPiwkhWSQNk4aP/5NTcpJiQwT9aOcaiv9KDpaMXNOaKQAV/W3zSEdMBndgpoH6ksmAUfPoklMCpTUfd9rAE9vG93aGulUGEi30fuNV65xRt37QaU5kZLMSzLJ+XmoPXAd6nyDbvYFU/wcGUw4YaaLL3e3K3pT2XAFd4TMmjYvWcdTVaxagEFONRdAra8VntXUDYf4JnJu3NwRuPT4rZeXJBcHlac6vCbGB94SPlCj3XU4mP1cM6iJySl4eDRqY7cTIimI0uGVnKKSciVRFW0VJwBINrGoyZXSiqmqFQCZzu4CHSSIX7jkK+iLASQ0dmSilJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu,  5 Nov 2026 11:23:34 +0100 you wrote:
> hi,
> BPF programs have no supported interface for creating or removing private
> anonymous mappings in the current task. This limits use cases that need normal
> or executable memory in a live process, such as replacing a function or
> changing environment variables.
> 
> Although bpf_probe_write_user() can write to user memory, it disables page
> faults during the copy and therefore cannot handle memory that needs to be
> faulted in.
> 
> [...]

Here is the summary with links:
  - [PATCHv3,bpf-next,1/8] bpf: Honor const on generic kfunc memory arguments
    https://git.kernel.org/bpf/bpf-next/c/e4d6d6a27b82
  - [PATCHv3,bpf-next,2/8] bpf: Add user memory kfuncs
    https://git.kernel.org/bpf/bpf-next/c/0efac50f3e2e
  - [PATCHv3,bpf-next,3/8] selftests/bpf: Add get_procmap_info helper
    https://git.kernel.org/bpf/bpf-next/c/ec727e9c353f
  - [PATCHv3,bpf-next,4/8] selftests/bpf: Test const kfunc memory arguments
    https://git.kernel.org/bpf/bpf-next/c/2af3f3c9be70
  - [PATCHv3,bpf-next,5/8] selftests/bpf: Test user memory mmap kfuncs
    https://git.kernel.org/bpf/bpf-next/c/3c670f43767a
  - [PATCHv3,bpf-next,6/8] selftests/bpf: Test user memory page exec
    https://git.kernel.org/bpf/bpf-next/c/2c9e3611035a
  - [PATCHv3,bpf-next,7/8] selftests/bpf: Test bpf_copy_to_user kfunc
    https://git.kernel.org/bpf/bpf-next/c/4058fb465383
  - [PATCHv3,bpf-next,8/8] selftests/bpf: Test user memory kfunc errors
    https://git.kernel.org/bpf/bpf-next/c/5b1e4e8b4664

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



