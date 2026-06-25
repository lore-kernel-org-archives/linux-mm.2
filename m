Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22373CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 021646B0095; Wed, 24 Jun 2026 20:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19D56B0096; Wed, 24 Jun 2026 20:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E048C6B0098; Wed, 24 Jun 2026 20:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B33976B0095
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:16:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 350E21674F9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:16:54 +0000 (UTC)
X-FDA: 84916519548.11.3C90B84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8DF3C2000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:16:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nwICYtMH;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782346612;
	b=slHdLshRpvjwkxgZtjEowT94ceRTQb8pozydV8JfCJE4EAs8wsnbUY+8+hjwRbnzKkaasr
	loHpMGVjgmsE/iPHFQrJvSzsiu7PPTdFaxKZrajT8LXLDWF0czuwsKavIYPe81PW+u+TjI
	3wPNV6Ia5qSWKy+HFxT0O0lnkYxlLEM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782346612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pkeq4I9+2X01e+cS/e2bmuZOh5o7mMzGdSbwE9VO42Q=;
	b=iBmKHqDSk9qxukHkODfbpH/yvVXtAfDC/8a7ZIw0opuf7ZdVZmBYUSYE6I0hJ59QDhjELZ
	9ITVxDmU2xA1naycwTpuCBEjA4FG4WDtynOXYWpzplsPU7BA2APVTofgVoftoUTLadHBoy
	LSapq+DUuWwVeGhvLLk4ifzLK/kG8/0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nwICYtMH;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E826860018;
	Thu, 25 Jun 2026 00:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152CE1F000E9;
	Thu, 25 Jun 2026 00:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782346611;
	bh=Pkeq4I9+2X01e+cS/e2bmuZOh5o7mMzGdSbwE9VO42Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwICYtMH4Ky4vOppdtz61PMskudlJvxOVqtZmTF58TnqwzKOHLghH0Q8UURozXMRX
	 CiVLivrW45j05cHSH/jKNS5PbU22Isn62v/OJWdMgVfCDVclb88oguf4sdHPVIQMoX
	 PM6UiI8v5DLvkNMjben6fZuXzw5T8X6ur1OOAJsGUanr/EDXgjvcDUNK2V6hC8Kgj5
	 uCe3Uf3K6ctD/VZ68RJRrMhb9bkRxao+2vDNttp5Hnp6p8J3irdFwzyDpYxbeIdrJf
	 StcdaT1+/GicXNPwhRQWWvF3mqF7YEORVWQ7FwbPhW7bJkeGN2oJvVUT0Uh8X7g5cf
	 lrWZJ1gTSi4YA==
From: SeongJae Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] tools/mm: add thp_swap_allocator_test binary to .gitignore
Date: Wed, 24 Jun 2026 17:16:40 -0700
Message-ID: <20260625001641.96043-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624150642.19749-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9pkyh4iz3uxhsnbzw5dp4ofn1f3e5r9s
X-Rspamd-Queue-Id: 8DF3C2000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1782346612-644724
X-HE-Meta: U2FsdGVkX1/uekp5PHLokZ236IZ9ZyQ1DJ0NIvZmtd2hVzZMdyKtHeNzwzuC8T6t29oVODS+vVtTWwi3lD2y1bhosXiNpBDDEnVarBilEEBtiSmAErETw2zcmRBZuHmrGZ1l8+1pAjq+zhVv8SnJcNPxFkVpDGtCRAah8knX6LAhkP1RK93WNXdPvEBqC1RnjUNzREzOqRUb67+wEU2AErIzrtsLGlcRpAnOmT1l0rcybMHhz4vGS3tTOI+G/3hHT1yZ9FfzxZhnrOG08j41QxDONLwKWh+ey20isztpiNKiupE8hcWblZQhrodgHWfHzAgH11G3tg638bfvRvjWcf6NrwHsCbBY8kXV+WoRIRqovGpmWXU4uApPaA2IOREAtz2cJto62fMe56XOoquSkkoWM05JusrThbTCp+gZlCILn8zE9F/FBnWSnxN3WZbGEVJLmqc1jT6GQ/5sPkkX6uUCtGtNFWWuV1QrYYyz6R49pDiC1nGSbM0c0Z0ZRjrrK0zuN3mj+8dvBN4t0RXegzyBIAOvEAJB0vsUtTRRLcpDMkDqbZNo71fAn7JIDQTcg7NyrDC1ekrjQEjyKDs5+R2XHr8KkPNEyNxCHmn/YkrJ6yLCWqUYzgVi/PEUR+uEzclEJxOpnaU++Fu/yZ3odWmCYptsoVARG1ev1uYEVh6AP9ipmO+6p67SQz1caTapc0w78yR8f6EuLxAjPNkGjSUWqv6WrbNU/+tXYNkUsxiy86HyRV/ur51K/3aRl8EvZrmgOx5k1UOgUmHeK9PkhqWgL3PzDk+wbpCtGBy/xVDDnCkk9R2dNn5lfpniejqbWxUDXl1nVItsBpdYI7LsgJfSYFQB59WCFyAWdSNd364JGL0G7BMJtiezQfqpFrYTDptQpfCO4R0FdL2YcZWGcR1OIDAf/S/ybq1VnsVgQhXzXOPjiA4okdxRfO/+9Zv9ZTiL0++gI+ppsDzOYz1
 2pXTHseP
 7mDPY2cO7SrJ1MJS22fJ06f6emziXXt8jzWuk1g/QHRPlDv9Fm7xkSTffC0+eWUNk0bUIuB1dOycDZl/pOukRYi4oXZvE9PTAQgkeF4K8XZTeqRTBp3rqL7TzC0gfzmbxgpO7UxVvGWdNtOf/R26OYwD7OQJqM+FZj6pFjlrtntquw6lDu2KS/a9xu5okwXsLsvE+og/HDHat2G5hDRh0R6MBHMyuuka3RyK1YwVOBw4rdDPjPCWWzr4CNiJNT22mQ3QEwLGIvnHbfEHB0yctUZ9U9IIy04hoHK0gJ4VcOPOlNSlP6dGleYJmnr9rqd6593SsgCiNK4XFkO9QNmhbuK7Q5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Jun 2026 23:06:42 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> Tell git to ignore the generated binary for thp_swap_allocator_test.c.

Nice catch, thank you!

> 
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

