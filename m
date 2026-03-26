Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE0D109E543
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94C06B0095; Wed, 25 Mar 2026 23:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45176B0096; Wed, 25 Mar 2026 23:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82B16B0098; Wed, 25 Mar 2026 23:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA1796B0095
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:27:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A00185B813
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:58 +0000 (UTC)
X-FDA: 84586780236.21.729B627
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB86D100005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="NV/cfIn4";
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495677; a=rsa-sha256;
	cv=none;
	b=vyas/312o+fJJpwA3Fo4wCCrsKYz30Sq+daJQ11hWYsCOcCY67DFKmUxPmlYHk7y3BbBfk
	9WtzgYxJhJ+eeoA7TFBzUqeO73U6FUPhzt6LOu7Au+eEMK+OVLDe6CEvO/Cs2t8SlASymV
	arDJ8WT1U+6LYnbvoYcrQaCbIh/zyqA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndzs1chzwjWa+HhoTLaNi6/jE7QfCgas/DZ+yJy71T0=;
	b=cC1twAxKHCqw5XrFLVavd1+Rxd+5jPCuTJfyvgO1Hfjv6hNCYtZ/APlGARdAH/C1soWNSv
	DMczPKd4ZecVCV1phL3uiQbQRGFBqmOcQq0jr00LijIPKU7x2y46KEkOTDYaLXTvm9j76c
	3wBbdeTSUZpE18Vthgr6qbA4HaOjRvg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="NV/cfIn4";
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D1A560131;
	Thu, 26 Mar 2026 03:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE0EC2BCB0;
	Thu, 26 Mar 2026 03:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774495675;
	bh=UPF6fwps/jA1rVjnXI3WhHH/tW0KYcigQr0DxXlK6xE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NV/cfIn4vS9qSVebxXfIEva0vGh0KlrOAXQ/eVsffhJ8J3CW8fakIw6EzKc/VR86R
	 O3WjDH+EMNDYOdlfwAQ8xHYCWUyzvAzpanQoBikwKYPkUQ28RSpYqk9b6bLGZAG70R
	 5b1ElWPgMwmsI33/H6d76sxZeSLwelfPIvoPc+Y0=
Date: Wed, 25 Mar 2026 20:27:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ljs@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qi Zheng
 <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 0/4] fix unexpected type conversions and potential
 overflows
Message-Id: <20260325202754.c6b47b6c03566a9c41dd2670@linux-foundation.org>
In-Reply-To: <c95c2542-34df-435e-85e2-bc4e5346b65c@linux.dev>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
	<20260325165716.5d63522ba825f25a63e74e3e@linux-foundation.org>
	<c95c2542-34df-435e-85e2-bc4e5346b65c@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB86D100005
X-Stat-Signature: k3yhofw4na8r4eu1nowft3xmk1utdj7j
X-HE-Tag: 1774495676-973573
X-HE-Meta: U2FsdGVkX18KOsLBbwgek+Zb9qPtdDnbElZfXnUKFHDP1tSoyfsIJUQHVBHhPx1FrCYyRNh3sfJVSMpVkel6b3+xNaG+S39QOLtPi3H0lDe2XTCQ6E8BuleYFyWmys7ztVYII2Enls2TftyiBeqJ1OlUH3Q3RdFuY/s/Eyap5edYa6EO/aRDdOr7tELZgWQZNHd8kMQUyl7tCEhFWFBzmVAWFGjnLqXzVib0uHmQKVvkNSg1cCG6BL4eLFy2ETs/6aeVnXDc3WXH99SjONNenHmevHn0pY8gEVdM0YDBY5lUf870WC1JBlGl2BiIE3cQvjdY4uCBNrpZy6XtkYPWFbSJW1SARUExUWSd7NDhUmxpp53h1b5/NwY89aUnvI3gqzcPwwQwmbpn7fJfOP3ZdgOJYnORozaPnHbkSGI3GAyijxLCjrYQli7NRpb7h9/SC4SPfFH1X/KJRotxP6qp4yHuiC7cMEryjh4lNLlox5EPwQ9gPyH+olgEPVg9/90Q4hVwS2ug4OGztund2FPMxEV2Qx3N/VzNG43oD+jXDU8dFR9ty5YHFYJ1hZUinMU5Nz4VMHOpj9OkxkyIHPif5BtUgxusft3RblOcNroXRPaQkNxFQ7Y12RsrlBQgvJ7DG+GOAWefI77K+y0BTANqytD2TqJEoVMrQwMOw3BqDQIPz0eR1tPxL+mLAVcesxfNXOXeClDgGoopjqmF041EqUjH5tHyNWNYXgtoOdxMGmJlNljvzebpw7sjEnd9sk4Z/uXvmF6Jm61pkou7S50fVe7mGMCLP0EXQPOCZU8rJcgpc90VcFT9b44BIFZHjVPw7S1KRDtb8CIZlMJ7qQhsLy6DvmTB1im9PFGeta2XE8Bd2Eq1uTi1mgxIVF/jv7GhjwP6304T4LlbgVHwsagYKnB3qmgTM7a7j46xkNuSRDlIzlXDbCF6dZlARvjJjXdm5hwYBmQhnzBzOjYn4eQ
 7kUw+s+L
 rK7RF1H/X8M9dcxxetSrjhoYBpXmU75FZsTKN99pBgH7jC5mgDRl2cA6QbJ4IMhlqBavHzEeRyMN17QOn4PtubuMCp7dqvePdXGh1E5svDSvDDxLlcanKztR/ATUqb//ZJeOdZc43UPQBaTVo8FRvb60VF1GuaxehFOn7EZZYxTmo+lXUmB9txUJ0cOr1wAkXxhya3dtnxDmf41ov/zGIcndbuYQI+qdarq8f5sMfoE6qBxvBmGwooQeZaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 10:30:29 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

>  >> Actually I can trivially do this locally if you like - just turn [4/4]
> i>> nto a -fix patch against [2/4], squash them together later on.
>  >>
>  >> Please lmk if you'd like me to do that.
> 
> That's fine, thank you!

Done, thanks.

