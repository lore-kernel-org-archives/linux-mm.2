Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6678ACCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94C58E000E; Tue, 11 Nov 2025 14:10:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46CD8E0008; Tue, 11 Nov 2025 14:10:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B820F8E000E; Tue, 11 Nov 2025 14:10:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7A1E8E0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:10:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CB5E139308
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:10:05 +0000 (UTC)
X-FDA: 84099266370.17.31A886F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B1AB820007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:10:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yMmALMuA;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762888203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KD+mCwPCF3kHkfwRrTb5N97Q8DVr7AMaYPwz1ApO2Mw=;
	b=Bcw4T/4pTf9XeK0dLiCi5ujysyxURCxFQksqmgHvqfV4qoDPYfi7av0teWPjXOnCsH9g75
	BwD7R5WPJLkx7Uo19c0+L2s6lcsnENCIgKQnD3UjOKU+6T3VX1hO8O/crFRQKCW3HCE06D
	7kDPfIDx/5vxrHVcyRFYDtQGLmI14VM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762888203; a=rsa-sha256;
	cv=none;
	b=4pTeHOoaFPg7xFWiawxIHocv3SrdEK9dqvXf4LxyeCrcpJfmXOn2tPTectYOY9jr9dyOLk
	lXV5KwlmL6uCcApUvxDTfJSE3MyHXfm7Z2LIpjysP45zmlrElCNTPREV/gR+kAM1P9t1mH
	JHt/4Xi44WCVNVAHBnMas+v6LRlX8u8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yMmALMuA;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9EEE60204;
	Tue, 11 Nov 2025 19:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FD9C113D0;
	Tue, 11 Nov 2025 19:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762888202;
	bh=El+Z/L3HXKC2aFhDnhlEIS9FQckPXE2P5pGlBt1edZA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yMmALMuASVOTl3Ax05wz3Zqh3iGBO2/lclrUnhOWppWSyY/IMwv3q6V3gyRKcgTKp
	 1b3iUf+YFnPkC/qrN7MtjYiVW5kac7f5wNRJ6C0aPwfTQBTTA1GQXZtRuWFfM+YfM3
	 flFsQFRzQmVA1/biAKn5D9dZgcjBPZ6/xRqCB9Pg=
Date: Tue, 11 Nov 2025 11:10:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [linux-next:master 7210/7661]
 kernel/liveupdate/luo_file.c:571:3: error: call to undeclared function
 'get_file'; ISO C99 and later do not support implicit function declarations
Message-Id: <20251111111001.a4a4bee3d4e132b76115fe5e@linux-foundation.org>
In-Reply-To: <202511120222.vMZm9rD4-lkp@intel.com>
References: <202511120222.vMZm9rD4-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h3yt3i46j45im3g1caj19hjuxqwerw58
X-Rspam-User: 
X-Rspamd-Queue-Id: B1AB820007
X-Rspamd-Server: rspam01
X-HE-Tag: 1762888203-375888
X-HE-Meta: U2FsdGVkX1/Q/0AU+q/nSKvWuLSiJys4CZmntu/DmGSkd15MAewsrvr7utLxbt7sbS4MatgwLvA5SEpofr+EKPKxp+NoOG8cGp6gOLpCSOM6pLzesQqXyhvQayB/tb4F46fImJ2R53yHLqbOnObGh7xRo48MchBacaYUkcpvJhicJfYRkROQYi6j9Bna5wdWdJQSx6BYzyRTrSAlcdFWGXuigZdsDqu5K0W3RXeuJNDJoHAvwVDP3aNxai/Z1LlvMLzgvCERU25yvSURHPkqQztM1UotlKR7ngC+OqykHCWCa4ptMPKuJOSYv8n+lUCPcQoCl6IeqQtb53H09kKxHPSOTlqj/dvhH4t3y7FYoeRB+64ADqa4Oblp90o6cXZqQnyl38zBNH6xme4/wczw9WaKQ2Roq8YWs4YhR4C6/X8nnHKJ+mMhTVZRZeQcqZ7AF8yWCyJE5QF4T3aJkQ4cZ1IzjmEotDtK2BbNWk7/lm+PtMP57jIVQP1nBhCQxANI0q6VjE9CoapVhKxVqzC5kadlFkl92/z1dBWQWQYgXd+YNgeTrRpxHb2/7qmXXaKyx3OwFIT8xjZ3sd9ws4iUB+BTAjH6U+dwZZZCX/ih85GjsdmooofXBcqk+EWTBKNB6qtyLqoBib06oG7+0p+CeH3UJqXAD4Zctv6MKDp34JXPyg+4YoUTxU4/DEoHYVqOn88FW7R3ULcbqNHs6yzpyX+ONztREbftWnDjioWjpWrDJMDbZltmv9eXSMPZ26Vqx4cQwSARmZG4OgHWIj/aIpS6bo92Rnrav8XN1+2fqFVAx4KCbcE8seOngHBSNZcVd2kOhPGmpoKRNsW1fzrsE8AEbe8/RzmSz9D5Iqxrds+ta3m+/fpckOCFWLO/c8klOTf61lpExHvenZ6kFTcVafqFWgrGzIiap++ja7HZ3SBDDlozKt6b/0oLs6l4oXcDTcykWDheF4IO8VGl/3D
 DFmTJ5mR
 aSjXBazximPE2rn+qs6SmNsP6vcWhiHzjf+U4R9kQaxLHZvER9alVTYtDUKYf1FRFu8WttI2LfCZMA7ia6FGGehkRq8JphCjBGpUbn9wCw4H5y522jLAf79sGHs1VdyxEhrMkldXwo++tAGml5HRUWH1LWn8wWtK25+D/JrAWOfKRIxs9rLHLK4pslvcJiPyUpce4i+TfyxQflm6Rk+ijlZpL4UaQVqa9AyJ93tDWw+S4Gb+Twmxt1og1HBU1b/ZT1AG36xKkobddCxmSo4Sk2rgGIGV2nyLGBkgmD2zC1wo3Dft+HCABnzpD8FVoPqLnk00TbM6okpw7AzQ+zQu4NyBNR3by5TFHCirXySX4jV+qRQqA+vvmCrdv0qozeMu464nr6MMUgoK7r+lOPrup3fM7ky8+x5Q2FqBCyXHCJXAE0XOPwSlF2YMaeYOf18Vw7539daCfBmR65ZWEC/I+OMhpHdG8Ty5npKQL92ymw+D52EQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025 02:19:06 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   2666975a8905776d306bee01c5d98a0395bda1c9
> commit: 74602408d6248999ca8a567c46ce0f78204d6e89 [7210/7661] liveupdate: luo_file: implement file systems callbacks
> config: x86_64-buildonly-randconfig-001-20251112 (https://download.01.org/0day-ci/archive/20251112/202511120222.vMZm9rD4-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251112/202511120222.vMZm9rD4-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511120222.vMZm9rD4-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> kernel/liveupdate/luo_file.c:571:3: error: call to undeclared function 'get_file'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      571 |                 get_file(luo_file->file);
>          |                 ^

Thanks.

--- a/kernel/liveupdate/luo_file.c~liveupdate-luo_file-implement-file-systems-callbacks-fix
+++ a/kernel/liveupdate/luo_file.c
@@ -102,6 +102,7 @@
 #include <linux/liveupdate/abi/luo.h>
 #include <linux/module.h>
 #include <linux/rwsem.h>
+#include <linux/fs.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/string.h>
_



