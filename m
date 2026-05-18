Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E417CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 03:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EF76B0005; Sun, 17 May 2026 23:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425146B0088; Sun, 17 May 2026 23:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361ED6B008C; Sun, 17 May 2026 23:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 254B16B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:54:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BCF438ED45
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:54:11 +0000 (UTC)
X-FDA: 84779172702.12.209072C
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf13.hostedemail.com (Postfix) with ESMTP id 121532000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:54:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=r6PMXp3v;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779076450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhzWgNsFCqkb6gA6X4u24Coz6XUqSynWVSY1ic8K1+I=;
	b=Beq2prs7hv6kczseFakNPOc+RrsXxJymPOngnJcaV0wxzXb+hT+ej0j6QoP/vU5X6VIlru
	db6x5exdhX3BNShx2Wpy7H0N1hNLcgfq4EUsVPhaOYARSiWIbsDBs+0FgldUz6p0mcZiaF
	WlIMOFA81NMRZ8BC2CWDG7SJ30XAiVY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=r6PMXp3v;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779076450; a=rsa-sha256;
	cv=none;
	b=r1+9b5xvbHnm2UkzGyfRft1Q3RwZMaNV55UalmCnp5ZDcb6NPXfzO4KKxArviR7aT8MHcp
	+kgT9QQkPAiUaCALw1w4I5z8wRfk8LFCOTdw+DW/eg9ZBfrrFS1nDQAHKZxrlZlf7HOmz/
	sb6xMJ6gUpH+W9yzuS4M1pnLVIK1GFY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779076445; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AhzWgNsFCqkb6gA6X4u24Coz6XUqSynWVSY1ic8K1+I=;
	b=r6PMXp3vKTZ5DjC0/8ZkZiygmF49SllYxcKjFIoS7b/EpDA9dLAFZqGx82hp+yK2tRHh3FtpYsTcHXzuy6mbCkFKNG9j6qPOyrgy1j1l4K7MGG9lwlWkfxY9GCRsX9uifzrss8Bt4cNwkkwsHt7j2FLNg+zQ+L2h8OidZVFQSAI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X337ZhK_1779076443;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X337ZhK_1779076443 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 11:54:04 +0800
Message-ID: <d5cd1ce3-db3a-4053-8556-a52982ff4a16@linux.alibaba.com>
Date: Mon, 18 May 2026 11:54:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] shmem: support xattr gnu.* namespace for the Hurd
To: Janneke Nieuwenhuizen <janneke@gnu.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Hugh Dickins <hughd@google.com>
Cc: =?UTF-8?Q?Ludovic_Court=C3=A8s?= <ludo@gnu.org>,
 Rutger van Beusekom <rutger@reasonable-sourcery.coop>,
 linux-fsdevel@vger.kernel.org
References: <87se7stpgy.fsf@gnu.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <87se7stpgy.fsf@gnu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 121532000A
X-Stat-Signature: hf878pi49ue73s13s7sqj6ium1mmhwmm
X-HE-Tag: 1779076448-209787
X-HE-Meta: U2FsdGVkX1/uT9pL20OGUrmoNmns92h3J6qcfmsKdPq5hvc7RsGdkLS1/GRcRTOFv/7g+kUUavanGYw0IQyrmXCJ+VKBaxsov0t+4mDptdqXzvHzgd6T08Pw6MExIiyfZCVrsZTE5aaFPwDm0+lu4oF8kO7hjuyKCXAAOmXuTEN8+x3gOLdgtXXD/+IORvw3fDBYBm6z81WO/HAuDJ7PV/vYBJE3P2kGBiEqKP1aZXnzDtpuR9sX4Ah56EjIXyEqSZ7IbUC9IoBm7jI+Lgw3DHlERaFlFtBiFNqHQWYSAHHjCWdcSWc/vvZ4OmCpNnhiNu9ht8BYoSUr7xJS50oM6AqqEg3xNTSQTmIIleJo1vrKJVoImhC8s/iJqmtq3MqoqOw3dtw5r6GnW0qUV+hHUKtSZstp3IjPJ9SMi4gZnboRq56B68R3atqKPShEyfZp17zxuI/5z52Dxk9DspLcn4b2pjEwfPNbt1XcVu/EaUp1iYTpLMtfxdm99vMzELdxvOXLER4bM9c+gFA+nyj3oshbGQ075yBpFq65nMehNJJJ3sxv+9ZM/CMvJyMIRPYybRWCrlnEEQ/0/8sMJVMdV9w5xm2xa4p3FxPmP7WDPBH7E9Q4IB0n6rAcqiHcK5VbYlC01GLPqie9tIXnp8prTLk+XkQSHKUFJ2Oy2ypSfiANc+Qv0ybHBg67YpAfiRRXJVC2X/SCCcavEdqR1Oy8NJnl5UqQGAQgsXyjFY8mY8TGsj4btoMZu3Qg5pGL03WxbljUNoTFljJv5kHvzSXYQY5svyvMqoX62/nBMA1MLQ/PAwFhkvXfjPhsRCdG+ljIwXpTgqGs4oqPaqPtQeU6oIZczuz7BdKG4r8RMjisNFLkuK4eS2q5uAWZbxhuZmIWwdapRvUCGz1q1/A5gp31sPrYT33tRzmiD99ox9KF/YipdFA0aynDgK66JkHPkLdkAF3b+DJcdJqJvVQaLtn
 7FFyZ9kA
 6tlY2TOOI1B5d5bokAfuz2tp15PrSgHPBpf5j0Cv3mhG4Io9B60ylNVQxJSDlg1TKKlMsarPTHCDUn5Pd38lpbmf4/Nw/F0Q5fcG/yPJmle9t8hAU+X6C56PfSKC1CfEPxUtW4K3tMjCttu7X/9dpRNnbumppvOO/5F1d78E4gwVn4pZvx0ybdTrL0WK4FFKQsqELRxLGz+BvenFzilTf0K8SZsd7tEZ9WRHMtSMIvveNvtPezQT7gQQN8wu7W7aCv9HZ3jKx19F0cECU0DenCSi8t5ZZzetWPPv53bj8VL/PH1CBUVU6Q9KvSy0moi6ktUTHdoPTHAjanRqQ+w5pFVLcpx6kO0wREt3KUMsK9gNiZc/DqH3OxGA+TPF02F37Cf2GuvforKDMJoBLj5JjuXwp39yW+nx3VKs+XYzj7SnATtzUCjBt/CqO6odQuV8PzgVZuHLYpPL5yKAE4GuPS/QyXEVBRj7TDNfLVUlY2JoMVb2k/QSIFzbtmU2fFZXDdgqJB8qEWnklB2aUkOQg1EcXr/10GWvJF3mVqFs2+sY+mhrFlJyQ/bLF5dQLdw1PuEiYYzQWBzBys9F1khTAejlWIqTBt59HDgLREMLjwvd97Ks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC fs maillist

On 5/16/26 3:58 AM, Janneke Nieuwenhuizen wrote:
>  From d8291d06b67db045033664fb440f59001d7755a1 Mon Sep 17 00:00:00 2001
> From: Janneke Nieuwenhuizen <janneke@gnu.org>
> Date: Fri, 15 May 2026 10:12:30 +0200
> Subject: [PATCH] shmem: support xattr gnu.* namespace for the Hurd
> 
> The Hurd gained[0] support for moving the translator and author
> fields out of the inode and into the "gnu.*" xattr namespace.
> 
> In anticipation of that, an xattr INDEX was reserved[1].  The Hurd has
> now been brought into compliance[2] with that, and so has ext4[3].
> 
> This patch adds support for reading and writing such attributes from
> a Linux tmpfs; you can now do something like
> 
>      mkdir -p hurd-root
>      mount -t tmpfs -o size=2M tmpfs hurd-root
>      mkdir -p hurd-root/servers/socket
>      touch hurd-root/servers/socket/1
>      setfattr --name=gnu.translator --value='"/hurd/pflocal\0"' \
>          hurd-root/servers/socket/1
>      getfattr --name=gnu.translator hurd-root/servers/socket/1
>      # file: 1
>      gnu.translator="/hurd/pflocal"
> 
> to setup a pipe translator, which is being used to create an
> initial file-system image for the Hurd from GNU Guix[4].

Please add your Singed-off-by tag.

> [0] https://summerofcode.withgoogle.com/projects/#5869799859027968
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3980bd3b406addb327d858aebd19e229ea340b9a
> [2] https://git.savannah.gnu.org/cgit/hurd/hurd.git/commit/?id=a04c7bf83172faa7cb080fbe3b6c04a8415ca645
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=88ee9d571b6d8ed345f877e05f685814412e359b
> [4] https://codeberg.org/guix/guix/pulls/8632
> ---
>   mm/shmem.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..5d60aa4dba92 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -15,6 +15,7 @@
>    * Extended attribute support for tmpfs:
>    * Copyright (c) 2004, Luke Kenneth Casson Leighton <lkcl@lkcl.net>
>    * Copyright (c) 2004 Red Hat, Inc., James Morris <jmorris@redhat.com>
> + * Copyright (C) 2026 Janneke Nieuwenhuizen <janneke@gnu.org>
>    *
>    * tiny-shmem:
>    * Copyright (c) 2004, 2008 Matt Mackall <mpm@selenic.com>
> @@ -4371,10 +4372,17 @@ static const struct xattr_handler shmem_user_xattr_handler = {
>   	.set = shmem_xattr_handler_set,
>   };
>   
> +static const struct xattr_handler shmem_hurd_xattr_handler = {
> +	.prefix = XATTR_HURD_PREFIX,
> +	.get = shmem_xattr_handler_get,
> +	.set = shmem_xattr_handler_set,
> +};
> +
>   static const struct xattr_handler * const shmem_xattr_handlers[] = {
>   	&shmem_security_xattr_handler,
>   	&shmem_trusted_xattr_handler,
>   	&shmem_user_xattr_handler,
> +	&shmem_hurd_xattr_handler,
>   	NULL
>   };
>   


