Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEC9C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303A66B00A9; Fri, 10 Jul 2026 10:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217666B00AB; Fri, 10 Jul 2026 10:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1540B6B00AD; Fri, 10 Jul 2026 10:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8C556B00A9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:25:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81853140478
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:25:43 +0000 (UTC)
X-FDA: 84973090566.03.AA579D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id ECAAC8000C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:25:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2BO+ksY;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783693541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djPcu0FaAOL3FlpJ1AH3s2+hbsgy3DtsP6zvFCsTW9A=;
	b=K+raoh392xVOmh/mn0dhElKymQHUAILWT22mkH4L1J6JKHtgCQR6wSgGof0xtjZM/RLSeS
	8vvZoDRNt2uQfPYCkgtfPB3Y2Xhbvp7EhYMYJFWt5mu6i8EcG8m+XdYUeG9LhM4r/513TN
	0wqCb2umIUltWcSJGTStAsqXzgjwLME=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2BO+ksY;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783693542;
	b=73K0upIRYB7Fe8Gqr5ViItCAk+0vqSzC+nHJ+QctRQtW49zlGmbf9/T4dH/valeE6ledJN
	jDWSOMyW8Cr8MU1CPeYeyiM7EUt2e4baf9FV3qhUNDM2mn6zuxTfGLuBNnZrfMs7hgFb1q
	Zrb7Jr1atcl9cpxpV3nQ8GwdOt6vHIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D10160052;
	Fri, 10 Jul 2026 14:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B7F1F000E9;
	Fri, 10 Jul 2026 14:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783693541;
	bh=djPcu0FaAOL3FlpJ1AH3s2+hbsgy3DtsP6zvFCsTW9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2BO+ksYpiBx37gKYrYNHUh2HlF78n89BGtyuZ73Ta2ah83pclTFsjnnd18tnUgE1
	 CfEg4zYqwCprIe85aRi75RuWGOvj4pWOHdp4RVPGBwdDGxiayiV3pi5kVpJ7bRozsQ
	 K7XPmGZO89OOJJ4cQxovFRQO5tAHtIRKljH5UaLtuwzn/fhxO91L5Nn0ssxuAQKD13
	 e+Pm/jk5CkFoxg3iHZOlLDMawkW/D6pO/Kf1TPI6CqHtVK+SOo0KPQfcNcPbiAitDM
	 /1qVc+q69HTej/99qnjeouENAUVr0gXDpXYyP4mv7zXt9Y7dlDIRcyNs5Q4Yz3JGPa
	 s3pubU758lSYQ==
From: SJ Park <sj@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/4] Docs/ABI/damon: document tried_regions probe hits
Date: Fri, 10 Jul 2026 07:25:31 -0700
Message-ID: <20260710142532.25200-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710044737.561102-5-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ECAAC8000C
X-Stat-Signature: 6ospih9hxc88prrit5117r4of1njrqe6
X-HE-Tag: 1783693541-249953
X-HE-Meta: U2FsdGVkX19OcATL/6I+q/BnOU0nSgXFISa3JEQwvheoNSGwwqomIp4TiD22CCtTKM8eD8BYgNARYgyd7H+UDT9TM8XZ2aaLHaOQjist4S5+aG0+K/64rqsMjNMiaEdmFHEVfi00Q7Mzl3IWsqq4nv/RSAU10QgI0t7afdhQTXJ2pVeUjghnu2mvTEpX11fTBDiH4VaRDdlsYKhVbiLHwu/AcTbD0WdCVWn/thGgGwe3nlbZ829eYA1SeHvOAfax1yxL+F/rgdGZcK0K1yv9/mL3gQ8Jn4nlm1hFnAUNSg9WrnrYsc2pb8I/LOMcs4KId2TMYK69f8hXuUZrFBTugQl/bcHWFG2vqIdA8sZbvdktioYuCrzkjTRvbM8OGgCDxyhuq3rJCfEq/9E21w+ELmoLxfmwrepQnajUEHZzWPQ5y0f5oAWBBa3VckjtGhPDZLDeQ24lnaBoFA1PzYgvc9/TZ26ys9p4o/LJGqT7HTJOdjHmyzA/7MgVOxILlblLS8XZdOzy/vYKpOERZ7513uIlWMNtxPLkxLp/MInVXmdJQp3YqDqXr/FdNVIHjesFcu2pa5Z1oIkPxv1DOuCmXFLGgjmd4RqHr6qdLLoFkoPxhDfUyIkr7seeWPXUqLdyX3lUKEB3wRO/ZmvwM9OPtPJmaz955J6228GBQGQHXuSgFYH6lQEm0d5AzZHx7feJR82lwbjkRw83Ux+mZ4aHclaQxzLWUgtuYspeAVMmQbjWWt1cYomi6tIEEGx0BLGOoY+FmUo5Je/Qb8KUnVql50ba18gE1XTz3dVJJuVJnBx/d2uH4zrIsEzalCiWXi1imJIGN8F7aZJmZoF8chOqfM40Vc7OCgKJ4EDWC49T6oNRLOahmohCo3OZF4cmkm90s+QiTqaFMlbOmz76fvKtO4ZRZj91B7loB4Cr78vJAy3quqdXfJ4SrmClHVBJSE5BNCEka9pnhFGoVg1tR1Y
 RefWhXlk
 nSaNhQe+sGCCPsnNcupaBi+FCAbtEzX5mYaN9wacIIA7L8xV26tLdZy4mtB2GLEA2US3Xt1Gurm5O9hY6eAgalBChf+/0qJN7Pn1UGlxbgD8h5JrYdEKzBB7WSihWkTRYFhHv547qol+PwpqleKyo78b8TfggVIU319WzN5bi6sbcu05HvB/FJ+XAlU4R5+2j0yeY0Bx+HViebkORTsHre/BMYHOBRxua+Mh7VaGwTAJKbJqHR/BFeAehp8Qt8gg+kr6sF1JlJA7TPVa4ZXKfHRUToQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 12:47:37 +0800 Song Hu <husong@kylinos.cn> wrote:

> The 'tried_regions/<R>/probes/<P>/hits' file, added in commit
> 5b0de1bc3325 ("mm/damon/sysfs-schemes: implement probe/hits file"),
> is described in usage.rst but missing from the canonical ABI document.
> 
> Document the 'probes/' directory and the 'probes/<P>/hits' file.

Thank you for catching and fixing this!

> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

