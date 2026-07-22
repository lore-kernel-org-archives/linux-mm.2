Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7302FC4453E
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43FC56B007B; Wed, 22 Jul 2026 09:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415DD6B008C; Wed, 22 Jul 2026 09:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C5F6B0092; Wed, 22 Jul 2026 09:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 115FF6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:47:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98EA91201BB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:47:04 +0000 (UTC)
X-FDA: 85016538768.11.C4F8D82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 067D54000F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:47:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mmWKKlyq;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784728023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TU1MQ7BeWFaTxBRrc9aQ1q6vtJ2v42CrYLRPX+haj9A=;
	b=Diuwj7IJReF6CPoQF1isCyNEPkZ3YAN88W9JGeJYXu5wmkGFErUO2hx9/OfQzO8GdZG7u4
	asyHvKO+BqAWkIcNM9qKBZAqEmwcx3UA+cMu5oE7FAVPmeB5QILCLSPIed8rfaSIn0hyJp
	PkRJhF/RxlG7LfV8d6QAMS7kVQuKRqQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784728023;
	b=k/GUuTE4m+l2Sx5T0TPIsvU960k4A3BgmSpLul8g5SmpuWn5XKhDst9omtJPbJiv3z0iOs
	ETLx/U1SL0WHdCpTyJ1acxZkccbc2X2OIcOtTUWAKOIqK9v0dcn15VP/k9Pf6fYfOUie4r
	cwKJGf2VZqMCakSo2bh5Zut4AMTfTzU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mmWKKlyq;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75B3A600AF;
	Wed, 22 Jul 2026 13:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026C81F00A3E;
	Wed, 22 Jul 2026 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784728022;
	bh=TU1MQ7BeWFaTxBRrc9aQ1q6vtJ2v42CrYLRPX+haj9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmWKKlyqqhYD320QJBZRm+9uE4C47XmP7jgW9+rLCD5lv3gtBmGDlLPrOWOMW1TX+
	 xN4zqiHMObOzhzKhC0t2LKfdeCa1fCHROrwY5i+bZekCZHAp8PgMlGSc6AkMgut/MP
	 HlnXERzuwdCpoWiXSCbQmoGIsp274iEpDZG60bCNoNM2JxIlpvzT7l6sjguBo/22yk
	 FO1fOV1xicUNJSjj6bmK7HFYxtpYjGg7dXSr85AFfpNkPRRcfE2r56G2hSvTUSMRO7
	 nlr8lUpsVmBW9pmvcDlU6CKw9VliA1/VzthryBVuuoHU4Qh67wvelcfy1VrrzC20oj
	 Rs7WoRKXVC/8g==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] samples/damon/mtier: add comment for struct region_range
Date: Wed, 22 Jul 2026 06:46:54 -0700
Message-ID: <20260722134655.87994-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721140619.297538-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 067D54000F
X-Stat-Signature: w4w8wtfnhabxyb1rp83f91fjhqp1ezpz
X-Rspam-User: 
X-HE-Tag: 1784728022-297332
X-HE-Meta: U2FsdGVkX1/JEbJOC+W25eQgPOxOQPVfAc9OOEE/3XAP5GkQI9XlbGYWOJKHzn6AjeMco9J4bOFml3jUGp5DjUWmRfFUDYvCt3dpGjBWv9FGc5oNrcbt4oMw0ZCwaGhxzrvpneSR6o62wOvhJ+6AWmNdaX2+gVRRP7Q8SmtLHsI/WPjeCPb/BUnet6d0Si8mDnFnU21AMlr/eNpZLBhvUbpYqQnyM5v2LGAXRTLDjeKqfO5IhpBMOJHZxESPRjONynEW8iBQpCb4KvOleziy0z8ahCy7HFJKsdp0OIxbKGZTSe6NU//jxhTXzS7nvZgddAF/9jpNkRFnpjs10bzKveBJOKOxVGkyYOkPW4z3e1lwbclMiVGBsXIbk3zcHAOaF+2C5xS1xh0VXVPkm7DSXq7etKWDuK0yRJLgyV6dFndxsK5hx2lWQYDoXi3AFjHdwxp+BR/2vGUwZvZ4kRBFOxW6nYelW8UPxs6NbsoizImV0HM3KPoDcdjx6Zg01uIyoDrbvrJyx9mIZkDRalYjAZkKIn+4Ne54ytv44edQVFSIQiprjJ0u7VcgWs6eBD8/xtvQv/2d68F3iSdz1zsCPjD70UmrlX58O/aIIgbXiVl7mAgoqBUuAnHEBKhrO+9GuNLintTj+QV8v5DmfGbeuupA0DA04WreojAyQyvSO1mUpmwOPfoD8ZFvKXRh+meIdnRBeF25sxinrSxcpBfOV3nxZviRN4ougnUd7iisiTTtORfFzohIGVxIlkhvyEe0/CDMCNuL0dT6u/VXQzYs+g18/1ZxktZnt9lZRNWct4ba9lyXcsoukzt4/OF3eKFjTjLoylFNMPKvPrwrOpx6tXEhCf4ZixUiIXJk5fWcTJ+HOJDvb1rVrLX/igLk8AwYba2Fxix/3J8pk2ayQaXdA5stvXTkVBkfdvSJuRGY+k3g+nxN+Uf1hPxf9ntSb9SHVF3lbbmwaFVY37Uc0s+
 G+QGxpg7
 7dACHdz+Z6Kjk6KqLlQSaXJjfGldc9PoMQyPqILp7UHVmA0uckdyi2vDx019n7lmngItWfN00gQZ0j/nrqb8xLxviiDFJAzxVZbOlyNUdxIt4I4mC+EMt5kGNMvw/QLvXY++7XVAnOItiIhGCGshx/Dj9dsZtIan+c290CsAgz+iLJfPzbbd2TcRYCeiD6EF8fueXOaGkXdP/KGjra0E2h/rXNbTXozyAvdeDy4GpZNNJJHWxqBsXr3f0O6sXedbpiZd0Y1+J4J5xlIUDTBgYWdMATVBLtTPgBEYTcTTRsu79VbU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 07:06:18 -0700 SJ Park <sj@kernel.org> wrote:

> On Tue, 21 Jul 2026 15:07:56 +0800 Enze Li <lienze@kylinos.cn> wrote:
[...]
> This patch is applied to damon/next [1] tree.  If this patch is not added to
> mm.git in short term (~3 days?), I will ask mm.git maintainer (Andrew Morton)
> to pick this.  So, no action from your side is needed for now.  If it seems I
> also forgot doing that or you cannot wait for my action, please feel free to
> directly ask that to Andrew.
> 
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


We (mm community) now want to focus on making mm.git more stabilized and
therefore ready for the next merge window, rather than adding more changes that
are not really urgent.  I agree and want to help [1] that.  For the reason,
unless Andre pick this first, I will request adding this to mm.git only after
next -rc1 release.  Let me know if you think this is really urgent.

[1] https://lore.kernel.org/20260722133829.87607-1-sj@kernel.org


Thanks,
SJ

[...]

