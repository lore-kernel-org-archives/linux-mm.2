Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45D3C5AD5A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 22:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C011E6B007B; Sun,  9 Aug 2026 18:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B5C6B008A; Sun,  9 Aug 2026 18:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0DE6B008C; Sun,  9 Aug 2026 18:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82ABD6B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 18:38:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEB9F405F7
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 22:38:29 +0000 (UTC)
X-FDA: 85083196338.15.82654AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 42F39C0007
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 22:38:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsNdqdn9;
	spf=pass (imf22.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786315108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZtIjDLVGmtQQMz9TIMBBoiqmko8Dygis52/ET3Z6U8=;
	b=TCX8UjhZyxKGcea7FMf5T4u45NpHbpzNDwExmMUyiGjJ6+G7/cAexQx6yZK05CPU+RErdr
	uPAfa7OzMSkwFyfkcnD4E8D6AkZQ5/wGzPCQQcIdxOcMBRJzpaOHzXYTfSW30v2JYkYUMs
	Kc+iluuroHbKFpxx+dKx9dVUJsdPRSo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786315108;
	b=QPa2sCjP9s8LDz2PW1ruYjUfqPyApPYchbvZ6CiS2hC1pNl+SxAEMMaSLbv3GQrxivxdiR
	tZnWwn86hJYOWSY2SxJ6JFRqwekMUup0SY0hpbm/YAFq203G5Ob5JSGlhZ0t4xyqhU5BDk
	W5dAjw+kbD0AgUAHpqKh2xv6PBo3qQA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsNdqdn9;
	spf=pass (imf22.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77DD8600B1;
	Sun,  9 Aug 2026 22:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFB21F000E9;
	Sun,  9 Aug 2026 22:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786315107;
	bh=wZtIjDLVGmtQQMz9TIMBBoiqmko8Dygis52/ET3Z6U8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=nsNdqdn9/5pv2Gry9QPiXBCjPia5/k207hYQCmR6BiyJZ+Vit126tNaUWahxLBKmc
	 IXFL0B8VUPvgJV0oBSC4aoK4wlDq0nCLSMN3NXLb/vusCNvzbiD9SA9xZ0cggI3maS
	 YzER26XA2HgxTKb4BRe/PhukPOVWqAvyT7E7Bc5jDv61xCAr/3iRCEw+oufNOoR2oC
	 91W35WuCgQhwZyObOWLTBEB6vPN/Q0MzxrxLmDGyreS9VmyQBq3L+5/sz8/pGTOis+
	 QaNJoW1/tvcqNqas/3IkNXGuqjPDrWaRiFkdSIXk+u5e3g/SP9Wz2bfLIQcJKo08HX
	 EJsdDQrpY9f3Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93BC03924A55;
	Sun,  9 Aug 2026 22:37:45 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] binfmt_misc: don't leak the user namespace when the mount
 fails
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178631506414.3049071.14867849911905814452.git-patchwork-notify@kernel.org>
Date: Sun, 09 Aug 2026 22:37:44 +0000
References: 
 <20260728-work-binfmt_misc-usernsleak-v1-1-dbd8d5e626e7@kernel.org>
In-Reply-To: 
 <20260728-work-binfmt_misc-usernsleak-v1-1-dbd8d5e626e7@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 kees@kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 farid.m.zakaria@gmail.com, corbet@lwn.net, jannh@google.com,
 mail@johnericson.me, stable@vger.kernel.org
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 42F39C0007
X-Rspam-User: 
X-Stat-Signature: xjoj1xo3c8bxhtfpii8wyc9ryg3iubdp
X-HE-Tag: 1786315108-367208
X-HE-Meta: U2FsdGVkX19mKKqdEgddAGzsqIj5PcLjRGZ6H9GkekMWlc25eSnrtdnCnmRoT/1fDT2dDJ1YgLgZ10SqzrqkQHbZoCgfOxGS2vJzX/7u31LkSuDtSFXRorNqJO4GUrLbrZI2iFGiaY/ilAFIhIW2cJMapUQS2c/GVHwXq+v0yxzPFA54YYkEIImMv39jLu7rnZy0bGwIm+/M53eRRzOFBB1mewJ6V80CjTXbftllccM96v4smUL9RgMY0XpXLy8njksNyX+zM3cIXeGQOHKFBHzYxTu+qyC0gyhVHVrSn8/3SSYAd/wvXORtoK9s6BMF6el4A4LICCddPMYiceEayLSyMJ0qIk4rzjJ6MLvMoryu3H8UlpDrLEemOtkv1JOvIK8Bx3OP4inV7cq9diYFF1B4xeEJ2ohH/gCX9dM7Hu44o5xBZA0PIbu04myJzsKQ1vCumltogi+pLPvcMxGcvBGnjpxdlyq9QSbZ3kce6/6IiLHy8lsWqwDUhZcBbJFYxPhg9vJSSLze9bcCt69tZE+EoWOqBKGxjGytEvof8vhX+mzmw5NXTUKcIGWFF9baLmnX1JXyurNZFT2mLimcm4A23k3UuRTOfghvbdUmiqo4g0y9+UkYC+uGGVIsY7s26OGS1uJVNxT3V+fqCtYsUGxbFrDlcsLUiz9CPIcTRPYaMoi0BqK4wreM5WFvcisHyojTW8REhTDWQTKLv3KbZsIgms4zP4OCTqx2EIuxAGEwNS4FxC8j2eB2Tkj4or0uEdp2NKjhopS+KB0twMOmqNzQL86jh7ujLxYYa+NGVtNuKxSrAzAHFBmvB0/8/7cfPuyI9ZfX/JY9lMQKL+4UUxI7/xUO+1SG5CnW6KcRc1gPMtMD/V++56QThtASFl3BF59g/HoWxEbhnsE3eUiQ71Fn+s7NjwkACg4ktQWZjG/9LWgRE7RIfIBfeaht2Qrb/eCmmaq39taoU6MOe7q
 /G7oo3K2
 pmGlO+eLatqBi7OTxLivT+6oBVkMNZVj4fK0dVB3+VeobGPxA2RzBsLyi9NaITUVLbO4PXr5Orey4nN25UEBp//AZk+GG0QdwSO/ssKg2rXtzrZbt/97o7jsswgcUGYWB+tVpAW3JRqtWH86OKyo5MFQuq9smFvvEmCFf1wgtTt8rFvMjbq5dt2VR7wdDMSHC3voTkWnwzPcYa5xg/AB0nzJ/wnk+jfnqKg4mzH3xzkeJtU3a1vQUTXNlgFW1j2G2PRqWBoZaFhiEOmv+hK+Nc0pYTk7puDdHZz+8K+sKHRLzfMSAys6PNgvcgXCrqFpNC+WdImDI8J2o4kowqeAlRH2veSPUOEKtaoGMhsTZPBq+0v+DRp3wWTfvAAbCF97G3EY7o9GZnyay3mRQLUvH/9RDp2tGu8jZZz9YtR6srlm+k6eJ+D4SgYy7Xp70D6tWADTo0kiT679OFDQaJuD2g89zWwY/HJbvpPir6p+fOmzMTxYjMKOEJ+BTGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to bpf/bpf.git (master)
by Christian Brauner <brauner@kernel.org>:

On Tue, 28 Jul 2026 15:48:10 +0200 you wrote:
> bm_get_tree() takes a reference to the user namespace and hands it to
> get_tree_keyed() as the sget key. sget_fc() moves that reference into
> sb->s_fs_info and clears fc->s_fs_info, so from that point on the
> superblock owns it and bm_free() doesn't see it anymore.
> 
> The superblock drops it in ->put_super(). But generic_shutdown_super()
> only calls ->put_super() from inside the if (sb->s_root) branch, so
> nothing releases it when bm_fill_super() fails:
> 
> [...]

Here is the summary with links:
  - binfmt_misc: don't leak the user namespace when the mount fails
    https://git.kernel.org/bpf/bpf/c/b8206f516fe7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



