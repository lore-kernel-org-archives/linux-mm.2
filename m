Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93815CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 20:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41716B00AF; Wed,  3 Jun 2026 16:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1FB6B00B0; Wed,  3 Jun 2026 16:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92ECA6B00B1; Wed,  3 Jun 2026 16:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85EF66B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:57:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 099601A0561
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:57:06 +0000 (UTC)
X-FDA: 84839811252.13.F290F5C
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29DC214000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:57:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=samba.org header.s=42 header.b=IkdgwTOo;
	spf=pass (imf23.hostedemail.com: domain of metze@samba.org designates 144.76.82.148 as permitted sender) smtp.mailfrom=metze@samba.org;
	dmarc=pass (policy=quarantine) header.from=samba.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780520224;
	b=a4btHdnNOGMLrn6LgRoEx01zissqhragDkULn65bL5IsulEoyiohQTwja5HfDwk+EGAeNU
	OSIv7oWv9wqJGV2KKRW5DQyzmOjEQoX8zODmpECjqfzG1tIi2S0YSXEA5q32ZNTFEtjyOq
	os1NPcIv2p/8wqhyfI7e/lDbUWiSpDo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=samba.org header.s=42 header.b=IkdgwTOo;
	spf=pass (imf23.hostedemail.com: domain of metze@samba.org designates 144.76.82.148 as permitted sender) smtp.mailfrom=metze@samba.org;
	dmarc=pass (policy=quarantine) header.from=samba.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780520224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BcJ1AYTFKicCZr4Jz0bUiyIXeLFCzsYHFc8JfDuOPI=;
	b=iwbvPST0NY8DkgFhNyuZ1Kj3KGFnd3sWhKCtcFaC0ZBVGPt1PaWGVM0qR3v/FRVZzx6DLv
	w2f1nLoQJl+YXQNuUH9oHelThFV0OxEc/kgc+cyDKjSt+6pEfIqtHoV7NTmDFh9l9EEkuc
	/UpVhRqF0ItNfDFW0pdQf2RdhQOn210=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=8BcJ1AYTFKicCZr4Jz0bUiyIXeLFCzsYHFc8JfDuOPI=; b=IkdgwTOofDKPbnSVfFpsvzvLwX
	eOoOzStETsZ3WEPO0WPXmqBwdzYWHPKtXsWUBnPrhS49AtanwdCw0YdlhOj8U+4uuX/Y+SfTGA994
	V7ALuQ7pbP0qgnPLvhDKoW4JaBX2kBwD+pPOmvpZsDURTw+GW7K1+NI24niCZg1RzD7JOHoHF0SmP
	hdcGlnB/fPmeokjhlU+8VVRBpZh+b/J1zE3upcIPtx9c6TbTI3ByJCL102NkFbqcHCTIoTCffGSni
	xtaEVXw+VwiZSATF2Xkm+AdCErd7J1WdkfDSXvkaDex04ioZI6pz8mSvaUmBgstMGtyOZlp3OjcJW
	P7D6uZnanayQ1fDHOYYKRvi4YPhXlXQZbFaku9paKoIFPTrOzvfo4fQ6ml8lPxemUdrPhChWMRMLB
	KbBvwt5/zIz36T+cmighMPqMSn7ZLdhtyimFeX+K5B0RraYwM92HQ/VTyeWryZpwntdJ1Vx0rG0ql
	oWA+ogV47gyUOm1BondGaIYR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wUse3-0000000Dpix-3X3G;
	Wed, 03 Jun 2026 20:56:59 +0000
Message-ID: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
Date: Wed, 3 Jun 2026 22:56:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-api@vger.kernel.org, netdev@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260531010107.1953702-3-safinaskar@gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260531010107.1953702-3-safinaskar@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29DC214000A
X-Rspam-User: 
X-Stat-Signature: esrwkepxc6ai8q8n9eno6z4ikik835gy
X-HE-Tag: 1780520223-10656
X-HE-Meta: U2FsdGVkX18UrjsUnfd5Gz3eP5TMOR1XpukTpiGOKFMmqEmip88w2VRHxsQL9Us7ZhPhffbRBmvJ+d01ZvI3gy3I6CwgrdWDgm8vGzpOFoZyJMsihdGELJ0c9uxGYtgSvWwoAD3G8pfqFIEpmVeDgShNEzWUKVH1U4aRf3EO9x6T2mJrgqtKZbjaecIPjJGF0+KAnonUrEtQZC+EG0J3101yuSuN+CECEVYAsI/8MzX7RjuFn7QWVb9iJdpkTH/+Ntdyn+jmcUzMd2cxKkGxckcbxZQG+80nbPmxbviZUGZTcloyoijvmxendK+X5bNZebBIUKRhyh6ZDM5omRCudoRaRcnqGw5Y25i+XC0Tz+Ur1odzwaOxtou6gQnRg9jABZ3arGEWeQEgHPjrQrZ9hb9+jiV6D0OoAajxLZPljvip1bH/QfFkFHljrSfJrEMnwlfAAZc1IXG18s8X8DIz3nZCyVObF4nq8hicUtPqJD3dCmzPZvgt0Jr8GbdPxPCDxLIXAjP5Nlwin31s3ygkYUN+eEvtV0MjZFQaAbDGLqoE3CbXnowx/s1HaGEKyxhGXoSOYY2jCAFk+DhPpzysM2dV2j544vp6IWWsXgbF71UpSUM8Njx8Pp1los1IaOx0IYO+dQCRBdK02mkBxi9/LS4sxy9jtx4fRLRqAhhxYBYyXho1mMH3TKobr0NFyjThJGoPTs85qb9Rp+fADQCmFNYr+yeNeZAO1UsQEscDu7+Al1jL2u4w28ky45s3NZg7mmhsx4frcAeT9Rb0GdHvO78huSnjTnBgn2Bpbmv/u9SeuuzYC/FnSHtKxRsU5wmK7iqKqy1Gp4Hyl9jJ09qwKWWWHg7y2E/8/gjPtoTTK6Rdqa6Q25QcRjwM4Zcnw1KxmfZksQ7uunRB/vWP5xMWHLsX1nfovsBWlzzvz9f59k/nBIQ9vkt/dSPswPV/K4WeM2Y3o6L59fJPngp6cmw
 ecwGV/de
 fUvWwiNsLocjtn30XQhvnrM9WQtvMa22QMUx95Aviwdfz1Rdl/L+rzsKiyOfeuho6Wpzn4uJgpsjR70hNpdBwdHj3bJDjQbhOo8mNMRK7ErsOxcYkE3sSicC3h9hN3mVPYZHCtuo8RnH/4p9eS+cY1Jvo8ambHCyBG8pbIFPvSGJMGINQ2YFCwjo2fq3Ho465LMTwuWBX8ETM1R295MHjwngZZdfEV973Br4ER9s4/qbobLSICh7MSyjS0y28g2lLH7x6QbW5kRodxbHAyFDnUKRSTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Askar,

> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index f5639d5ac331..a86a88207956 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -514,8 +514,8 @@ asmlinkage long sys_ppoll_time32(struct pollfd __user *, unsigned int,
>   			  struct old_timespec32 __user *, const sigset_t __user *,
>   			  size_t);
>   asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask, size_t sizemask, int flags);
> -asmlinkage long sys_vmsplice(int fd, const struct iovec __user *iov,
> -			     unsigned long nr_segs, unsigned int flags);
> +asmlinkage long sys_vmsplice(unsigned long fd, const struct iovec __user *vec,
> +			     unsigned long vlen, unsigned int flags);

Why is 'int fd' changed to 'unsigned long fd'?
Should that be its own commit if the change is desired?

metze

