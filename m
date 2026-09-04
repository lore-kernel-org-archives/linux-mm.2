Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB4ABC624D4
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 00:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D765A6B008C; Thu,  3 Sep 2026 20:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27156B0092; Thu,  3 Sep 2026 20:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3CDC6B0095; Thu,  3 Sep 2026 20:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A86E76B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:44:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32B0714060E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:44:16 +0000 (UTC)
X-FDA: 85174233312.16.03135DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id ABA0740004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:44:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8pOMMDh;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788482654;
	b=tMF7jN/2jji5R4Bhrj7V8VUoiZYdFYPxFA/srEpz8XQAohaUYJgXRUng+VuLaIYgGXpd8O
	Jgkbs+c5lRSRC9jBR8ddr3GuGV3z0l+58vd+6vNIe5Ji3aLXHXn+bqu8aodAu44LMZuJ7t
	kCC4AsMEJ9w13UHIUciNQxZjMM+0Gl4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788482654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KraBssmMEiWIBzyn65iDWbUViqjTaiDbL8M21HHwgAw=;
	b=cIgMv7aP/xvq7gLugRnJWv2Akc0ug8ocPf0Jk3FrVsK9+M+w0ONF3AVWY4cNNmWUYx5GGG
	/78ioGpjvv9jcl6bjo6DRhE76zA99/u4Ld/MTjRIiy0iwfjyf9LIfprdQizNR42YOdLuTW
	V+/YtpRHJlX6AQrxU4qd/bQUEScZ6aE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8pOMMDh;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B51A60234;
	Fri,  4 Sep 2026 00:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180D91F000E9;
	Fri,  4 Sep 2026 00:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788482653;
	bh=KraBssmMEiWIBzyn65iDWbUViqjTaiDbL8M21HHwgAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8pOMMDh1Z7TttwCKihKzuccCRBEZrjT7j/gIJuixvaPcRyABx0q5vkmdefdAFVEw
	 gmTdX5+k8WBG43R6I6IRzTFITAC7liJ1tduPzDmZ+IzDSg+RSiDdPij31M3uA1LW3H
	 IPUb55zkVjTROVZWmvIoa/qGLAtXc26UbslMIIMjedyl/0jBtwTf+taIQf6DDZb5Bb
	 0pmW6bv7X/hyAAZHoW2MasZxmB/RjxFXbXEcbcmMORoVMvXtOBKaYARyejgBtGrTK3
	 kdEbBsanlq6IiPYeeUGWDInPYRArnHJxb1xPD3TOhK8jGIhZ9rIX//UBtOleT/ZwIP
	 /ZmeyT06BpDlw==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] selftests/mm: remove unreachable returns after ksft exit helpers
Date: Thu,  3 Sep 2026 17:44:05 -0700
Message-ID: <20260904004405.116994-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903135251.39593-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ABA0740004
X-Stat-Signature: f85engo5gjouyfqzff5qnxyd8nb1o3x4
X-HE-Tag: 1788482654-27846
X-HE-Meta: U2FsdGVkX1+et52F5U3ZyJlvX/l7O0HU8MpYKMPhWA7bdIn+brS2fdv4n48q05Vxk9UHsz+Hwe8cP3wEor4L+1PAp6JZTrcQGhWyKm5gIdQ9E6whAA0iWG999WjVrjhv0YY0oMSHD5NQpJH1cU2rOXUivtmTKfm1kLee7+AF1x2jgatz/QfPjBxURzOUZyWFAwP5jZFQFYpjc+HqaMK1Yq83LzJRZuv7x2qpuBCjqJIZm0456L5KCm6+Iu+murl8AoI9f7k7kzKK949bPiQZIAxi70rtWwmfDPLIv3OcU0xej5uxUOwpUdKVpNb4grVaNFlJ0Rth8VSzgFKv6szVT4srY6N/+sHNUxNCXfHHNcZgcm70jGrVfq51IL/j7jXvPp9i/Mbv1FLGjMrOm2G9UhHCN8XIW8DSOlRhCsVWU/g1cRoYsLaYRI5XIQrjiCkzc5GD7sY4QZhwL4qSTuNGmMTa3j8C8qK0/6unWbq+qmDkYyygh4Iu8Q2+nhM3yI8g49V2n5dhDUsBYtzWN7ShkppbXzfVAZEOEOKcYpJxyttJnxi128Vm/Q/+kdVW7roug0RaovAhhXbI9ta50LowVAzZlmSsCjCdouGl//d0Bx7HF65FrtmqJtGiX+YF/isiyL/EbuD65mQRqf/IDjmwm+hEaLf++gL2C6zrvoRj8WiOKadrJW/ShX/zmkrYW9GYTLQM4onuq/lLL6x/cE59XbTxejFFj5MO+5FGkLeKg3L7flXYu7tKR3yWOiG8pUkdDHWDYQmZBuV9ebdhuCG1HTP/aeYI//5Lde9+Ti7r8olnn9PS0+b17tcraNjwPkdapZSkGxNZ2jjPpTE/OILivXAnPj61QaFqlVDq6AfirY/UkGNTnw8vnRle7Bn1Ea4k9tm/WgK706kUQx4hQFyV5u2YCsDny4s5J+iFkA5L0I3kCMPCVmxzvAyoDCA4Qw8xx9SptAHJV4NYpL4GWqx
 uWttJhie
 q1ARK/XkAtjUtWaHr4pYNWoUjnzfeIJXb1O7TyOeVCmstkNcqqJNbp5tjGs7IXFogSLaKrAvbYFImH8/LlTQctbjvWwg/l/1FYVoH2b6l6Kpkgv1XMR9OPg2sobPRFlzexbkmts+JS908Vdni1AwvRK6wKe2aGRoOdZN+vGprVQoD5UFAcssl2lCVE73xsY7MGFq+LX89KgN/lmkatJ/eAq7gNWaUJdSNunBleNdRy0r8izBOYykwVji3Rmht2+49NTn0d80GMJFyARY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'get_maintainer.pl --nogit --nogit-fallback' on mm-new suggests adding Kiryl.
I added him.

- Kiryl Shutsemau <kas@kernel.org>

On Thu,  3 Sep 2026 21:52:51 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> The ksft_exit*() helpers such as ksft_exit_fail_msg() are declared
> __noreturn, and the ksft_exit() and ksft_finished() macros expand to calls
> of them, always terminating the process via exit().  Any return statements
> following such calls are unreachable, both at the end of main() and on
> error paths of helper functions.
> 
> Remove all of them.  No functional change.

Makes sense and looks correct to me :)

> 
> Assisted-by: GLM-5.3 OpenCode
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

