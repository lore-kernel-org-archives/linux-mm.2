Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF0EBCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 02:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7EE8E000A; Wed,  5 Nov 2025 21:28:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAFC58E0002; Wed,  5 Nov 2025 21:28:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC458E000A; Wed,  5 Nov 2025 21:28:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2718E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:28:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 030F1C0543
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 02:28:56 +0000 (UTC)
X-FDA: 84078599514.20.7C2E8AA
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 490D514000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 02:28:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=iBXxYJTc;
	spf=pass (imf09.hostedemail.com: domain of ywen.chen@foxmail.com designates 43.163.128.53 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762396135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+sn4rWDbaRXab2FydeaqMlsDRUX96FTNA0Hi4iwrBR4=;
	b=dosniZCs7w+mIp+ysFY3g6lru7+VW1P+OMYZMO41dEV2Wq4hjZc6KJScOKonR4YMKySfyB
	OEweSQ0w3hO0rYg1Qj3cTNUvP1F7DBzUXEUjGuwkTeJiWny3py+2b7WKROKWExJDeaMaJ1
	peQlErwamqjBbN7TnJqeYw1h1VNq8nA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=iBXxYJTc;
	spf=pass (imf09.hostedemail.com: domain of ywen.chen@foxmail.com designates 43.163.128.53 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762396135; a=rsa-sha256;
	cv=none;
	b=3/FZi0QzL1lWU3ukEGdbwU9XJ9ooQSi98VoHNczcgIB+q4hBJ+1KFKNMeRehl3gKawfx/3
	8D5OXxo9tRez9WwL01NgWrmt/RIgMxZJ3HQgy2lEOO+DCMiDgggFCRN4bGDQ2yfH0KIqhh
	L4UD3Db8XdBxGbMVBHUSSVW3GQwpBhU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1762396116;
	bh=+sn4rWDbaRXab2FydeaqMlsDRUX96FTNA0Hi4iwrBR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBXxYJTceLo1Wf9glKNPyOy1MgUSOw+Z2ZiwKFD3ZmFLhviwAeJcQ99kA7FfOMruu
	 31z+uqAT8CRJm45JmKQICG7ehnYlwx0oxk5bWDD51nIbzdiDj5T3UGQzhT89rN/BRv
	 bLEqSxKsquWDuKFcUmIiY0c1dLFdHIjgFlbQ6EcQ=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id 7219A68A; Thu, 06 Nov 2025 10:28:33 +0800
X-QQ-mid: xmsmtpt1762396113t601gxnym
Message-ID: <tencent_4045D6DC43E374AEA3E78479385F205D4008@qq.com>
X-QQ-XMAILINFO: NWMjIPXM0fdCT1+I/1CYrF6DG9jOllEpOv+iqMAJ7eN6IE0/BEhrtRt3kc0vhK
	 ssrMwg3CLFRtkFZkvvA6QZm8xDXaBayrN4UnYO8X85dYcN+hMocRQU7dWYZy2QhHbn4LDr3vtCUA
	 Uw+Jy33swxco7versuKpRglNKowIHxlifhiXk/fbyCgUevkv0P74qMBNw9mpjX7KQTmxY0xAYlzO
	 hu78GWvOnebdxyfbmebTc6wWWuw0GkHyYPpyy91vsEIXHmqp/9VUOF8J90jQV73wAj+gzVk97fN8
	 7maOCd6qAvtdDcRDEhRx2f05qjRGF3LIT/gcTyamxqgH5kdiZHhcuHUDRz3rsRjvP2z4eZp6RILg
	 KpsbPFBANHRh0F+dldwdPBSlMdw/s9et3FnxVA5yGd+rdiZDHZZRiHvoH+LPxXMtay7A9RkUFAzN
	 8W/bz7wK+RF9tUwf2MbvdMG00+BcYTEoO+crtg2SdNaIQ2YJjleJQSHKob30P1djM9lk+eWI4EK4
	 tHnd5oqhZTfp6Ujji/Qt6LLM1WpiHEOJb7lG0hh04pAmrSP7e16ouF+8qnCmkoo+eS46rN7P78SJ
	 vdXannnBYQflhk6Ue7rf9HY0KPCwFfhuXMuewjONpI1Bn5AogeN/LDhtA7trjU5ClD6Z+tKt+epV
	 YDSDVusL2Iou9IB+a7peBn0iPqz4cJZHHjNHg9I92LdYOuopEh6RvU7IDy+wr7LZ6tAAazN99n7m
	 a+CCtqj6pkDeXs+iOOc7c3QEN+ilxmh/TuPRWN5FvlLb5uB41eEh4/UgKijftESOHixpyeR58sFT
	 ShcjvWc02SVJoVSB5gSS+WCP+hnTGWnmszsOb4y5nhvbtk42ZoINEEF0pFlI50Xm/kyxbmVztkxN
	 eotcRqh1reHi9QYrvH+zOEN80evHNeSDWI9tIPqAnLEOmFuftMqfoyvIMyP6tjV48UVm/D6NfVAF
	 bFpff7AB3KSWWfwajtp5pXj1cbFgp3a4bghKel6muUMd1G5RQ8eEtCrUFd4KkPE4dp3hTykU6MB0
	 C2sCURcLT0g4rLnG5hB3u9JY8ShWl1mPoSBb0GE+O++prCzVlypBBXTUylxnqXG8cFVdVbcJ67kX
	 TpwWPcAki7ZQWs5+I1+IEscMmgqn1Gb3RmVx1OI+8HB/yYJDvPD8YKvb+Wd+q38k2A8XSAamI7MW
	 n2ycxWHXSOaQKw+1WNVNIx+EoQR0Sbsil1ulo=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: axboe@kernel.dk
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liumartin@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	senozhatsky@chromium.org,
	ywen.chen@foxmail.com
Subject: Re: [PATCH v3] zram: Implement multi-page write-back
Date: Thu,  6 Nov 2025 10:28:33 +0800
X-OQ-MSGID: <20251106022833.2729849-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 490D514000F
X-Stat-Signature: i8yjz6453i1btm8tm74uo8eeqwizo5tg
X-Rspam-User: 
X-HE-Tag: 1762396133-549676
X-HE-Meta: U2FsdGVkX191kxgArcIIq0s8cYT02R5bemAH3r01+SGcRJ4BCC7cPB6gnrGsYBcl+352Hy+UaPH4FWqw8Ysm0izW8wkw7YgwHdH0SMCecRJEEpzlZL5nKJHaL1mQwBb0lUZlU6jaMR8zXW3YrzJJW0aqZdTzuW97B2PX4tc6ZG5VHvFGOpQ6lL1lEvfvspM3ugXncjALZe7apVNDwkit88XIJ2aqIbqLmTvY3IN7wS41BWHDIQhhvqH5viakXiuPVk4rnMARgQcy9RkEJyhqBozNnlYhtfwpahfTmhMNwjPkVcShpE6cmnjpm8JSRomjRgG1KbwgzkahLcIfa65u//a4j2ReX6CNYKEVc8YTmS7+qWDbVBDzkiqcmzTu0r+9ZBQjiXSX+y7WtTHTc3yXe7ttVPMgMEhSsd9Il89a61o82erCsSGY/fr8Wms4zCSQHnMLk4SSJHzEvKbj/Ydptw7ro5Fex4EK8Eu9nnn12GB/SIEQKncOi/O6hmHlA60K5pkUr0VDyCAAas80Evsipa/Wk+35wvlLGA8h2fb4k/KjTGDJjtbxE12ybqDFYivUNQ+5M0NGk/eiBqbwxDJsl/rcFJSsaUwzRKAvEWANYx8yuv+ZiqvQmoh3zrV6U0wDscm0nJz50hzZFkUCAfJ6Dzxm3H7eTW03OeCVvJMKcPwntzalvRsB1tYtFkosNXNeyWxNEgf+2X76vwpq0QISVJ5+3CmRhpXF8OfxPlXS+NNfhGf5JohODxipF6z6CcUQLH3pxvv0ScEjDN60IhqCpNFp9/eAQ1sHWMJ2S8KhZxvSJjCaEKErWIPqS4eM6Vmzj335dl6FekDlRWzGT94H49fo8C3SqgcRfiat/Hs3PUXb56WcObMCG2rl2BP+MLrYc11b5gBZX0bNrn82pAj8usMciszAfVi32DEDC/pWIQiynWqXEH7m/xMjCy4w5HMiscqJuC2ctY59ZwPduBK
 wI9v5eEL
 dafn2hY3VFYW2+oFv9UetWDQKmJTY1ZNqpuxJJMcx2LXg+4ff3VKVzM9Z4rbLi2XGldSjks4ZucWTxu1tY0XEGj3gzmrMgzaLCMXPFr0lXVSTqGrJVH6YRNww2Naid4e5TBOXMmBM/lV6g9mI//0M7fJdPF1gZKXvvvLpCUJonnete7I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/5/25 08:25 AM, Jens Axboe wrote:
> Please either finish the patch before sending it out, or take your
> time before posting again. Sending 3 versions in one day will just
> make people ignore you.

> This commit message is in dire need of some actual performance
> results. This is a change for better performance, no? If so, you
> should have some clear numbers in there describing where it's
> better, and where it's worse (if appropriate).

Thank you very much for your reply. The description of the patch has
been revised. This time, performance test data has been added,
showing an approximate increase of 1000%. Please help review
version v4. Thank you again!

The QEMU parameters used for this test data are as follows:
sudo qemu-system-x86_64 \
        -M pc \
        -smp 8 \
        -m 2G \
        -kernel /boot/vmlinuz-`uname -r` \
        -hda system.img \
        -hdb zram_writeback.img \
        -append "root=/dev/sda rw init=/linuxrc console=ttyAMA0 console=ttyS0" \
        -virtfs local,path=`pwd`/../,mount_tag=hostshare,security_model=passthrough \
        -nographic

The approximate configuration of the host is as follows:
Kernel: x86_64 Linux 6.8.0-50-generic
CPU   : 12th Gen Intel Core i7-12700K @ 20x 4.9GHz
MEM   : 64G
DISK  : PC801 NVMe SK hynix 1TB


