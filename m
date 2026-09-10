Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE0BC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC0F6B0096; Thu, 10 Sep 2026 06:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3AA6B0098; Thu, 10 Sep 2026 06:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9112C6B0099; Thu, 10 Sep 2026 06:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72BBE6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:13:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E27024045A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:13:10 +0000 (UTC)
X-FDA: 85197439740.25.736A9DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3829614000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:13:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UoGjSLhh;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789035189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/8YS0v7RJmeRpFjbq7IZwtQfZpx9xUIXzXJ4MYqpxU=;
	b=Icpgahq82ipvpuEJXFN31qoIGW0QBCHpCGZbQB+mjmHZlORHA0WrhjCHbeYm0J3kd0oejl
	HIQYc4A63DBbTNpGGLmz+m8UlGxgYrIWzUqJjQaGsJ5CJx6lMcTdzwuAD0CLE+Gm6M/r3Q
	WZJ05DOCQ9NsRInoYbwNxGE6vObVpvc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UoGjSLhh;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789035189;
	b=NbRSb0DnTpU4DgOUJ9a+8gqhlc43BEKVBMYRs/CLGSXlSQv6+MaJVGuqS7tilAugGTR01n
	/qpmeCiqhT/KhRb4AB2+M+TwHfxbWsjZQr/cauDQZST7Dvcva4abwPNF6Yy1i2y2qTo7k+
	FvbALJ0LbCcqZjDPDzK2oUJ1Plq1aVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3350B600C8;
	Thu, 10 Sep 2026 10:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49841F000FF;
	Thu, 10 Sep 2026 10:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789035187;
	bh=l/8YS0v7RJmeRpFjbq7IZwtQfZpx9xUIXzXJ4MYqpxU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=UoGjSLhhTtjlSwKYzU/ih8PEW5F8wn1MnLeAWeLHcrVftvy7xiR6I/hxp34xFDx4W
	 gTwsgHcV4U3mYLuhFpLiftsBTS1bDi6CNPx4Aufljnh8g2dl8RFfepljwIPSTVWpPa
	 z/FmP42/foHDvRX+ieE1BD1WzD/7R8ZLUmTQifnhlflSVpdvTgmsj38l3fN8KwhkXj
	 qEosKMaJSnTp9HuSnN0aVIEIVtegtQlJrZg3cOE/IoLWJrVBPfgV1Vc4lv3Rvl7D7a
	 QLSIrTzilbAQDnWbuek0tdG/qTWVZ64fjtpTsU7m/xIW8yQ8lycZ86jyucEexdwjcb
	 e3z5ALe6ACzDw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] memblock: use for_each_zone() in
 reset_all_zones_managed_pages()
From: Mike Rapoport <rppt@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Sang-Heon Jeon <ekffu200098@gmail.com>, linux-mm@kvack.org
In-Reply-To: <178903430147.1489479.2162515570306846533.b4-ty@b4>
References: <20260908165733.1703766-1-ekffu200098@gmail.com>
 <178903430147.1489479.2162515570306846533.b4-ty@b4>
Date: Thu, 10 Sep 2026 13:13:04 +0300
Message-Id: <178903518466.2710705.16546329711992780120.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3829614000B
X-Stat-Signature: je9e6tao75jqngft3mpngzhp7xonoyuj
X-Rspam-User: 
X-HE-Tag: 1789035189-375486
X-HE-Meta: U2FsdGVkX18neyF2eWMy+X6bqMeWTnl7R6/1JUByhXqSd06Q0NyxmHtTgQVWf+UyzjKsvcY+cPoJw3NjK24E9iBCL9vb6Xy21id7PhZI0ZjFsYurgRnarLA1VlYGa5mhW07CcbFgjDpvBfN9yYplYfOjHUpzADLDL0y2VM+BFZ+MHNAkRAR8O1eqkHuCctRWepsfzUyCmUdzLzqRhP4hkTqKhTtWi82FO/k42eJhr0WRuZlaiWpxcTWY52y8vnPNwGENRRaDyGh5thWFIOD4WU/PiqIw/dHIWsV/LbT4EhKSMBMRH2+qcpUCJTbY0SCxdoH5svXvdVFtYN2RwtSJU+NqI6vcxMGmoHef64JgIvRSVsl6uwSorlQue5P7Bmrmpc8sZiB7//eJQcsvyj/m72dmH1s5CRulCIvc8cPw60As0IbxP5A8m2amYs1eXtqxVG2Fqt63GUxUvqL9LPawABufCj8gCYVTHB1VVJfN2hyf5/fW8XUC9l48p1kMu5ZX3ct8k1xRbo0u5E6f6rMIY4v94kE6uqlyxnNPYFOSPbxhjdqPj49dlRiTD+NI/bfhAtCDDaIOGQnPMnR63KCgxYiq0BgWudnB5Ob1zmvrGQ/qWwy5tdVqDtUGQhEIXdplmShqF3Lb8npDJLU7Zl1EkV8mB6Y/MH+z3P+SBPdTKcomLfIxyBTCjgK6A8EG7Y/9sUuDLOILZl9/O+IAL1f7w/w3PHpQAiq4w8c2fdLpQOrKWVXAQmXKyhzHXmICaLeTcox+X10KLQa7jaMWL/CcpAPCOcIGnfBATFyv/vDvdQjt6cxx9e+EXIU11VX57kdm+OEH9AHI+nHvrmvQKzeL2o4MDihf8p45fMQxlEEjeyAlVMqW3d8rUKaXh9MT/5CJzBmUJ7u9Korb26StZL7h0qw3wPHWwP9pDps/voZhUcG42ReOchqDmFBt05KwUiRIdoP9OmD+WJQXWiUID84
 UmEIG4NN
 X1uAVtbX1F5BRN5JI875hRv4xfn5RbFczhNuaYi9AcpzJ0BfXlevb/zczbg7iqR3nnQKeIlqg//eYxqn3bNIgWHbKatcrdwedoLH90nmqWY4MKPWenysJzGnjueBs/WlmNLHQssIhRKzmR2e6Iee+kVEnPoB/L9iv5alPzXSce1cNIdZvjiFcPE81mQCCTTyQMakC5tGWrLhMdQDUv5ECPs9sDUzqFZsP/BqtR5nNTw7IG13IDrhJXIVmRN8J8RMor4lnEV5ZhVYyhxBJwtfbI/IqAVOtMXSvrFFx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-10 12:58 +0300, Mike Rapoport wrote:
> On Wed, 09 Sep 2026 01:57:32 +0900, Sang-Heon Jeon wrote:
> > memblock: use for_each_zone() in reset_all_zones_managed_pages()
> 
> Applied to for-next branch of memblock.git tree, thanks!
> 
> [1/1] memblock: use for_each_zone() in reset_all_zones_managed_pages()
>       commit: 0876b2d8794913c867a1bb0dc3fd22ea1c5f0a95
> 
> tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
> branch: for-next

Hmm, I was too hasty.
This breaks mmemblock tests, so I dropped it for now.

> --
> Sincerely yours,
> Mike.
> 
> 
> 
> 
> 



