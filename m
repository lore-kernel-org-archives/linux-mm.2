Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A077C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A22E6B009B; Tue, 22 Sep 2026 06:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179B36B00A0; Tue, 22 Sep 2026 06:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6C36B00A1; Tue, 22 Sep 2026 06:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFE956B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:10:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 775018042A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:10:10 +0000 (UTC)
X-FDA: 85240977780.11.1205DFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D30BC180003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:10:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKKeBmDw;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790071808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5lSCP2aYhFZTVX/g8FjXagC3d60ACnslJLgFNH4YdQ=;
	b=zBsdj4cAj4+hjqVh5bITUaiO8OT2wMIDcy19JwyEwkOV0bfdr4iBfePnqkkmliKdmDLlIo
	r4OE0gfDYP9i+k/EXGfXNB+D4g+aKPDOJW8T5hpdrU3T2UNkJRe5VoqssyYMEd8XNGkLaf
	7RH35/Dkvn2QueK0Ea92LfGMhBOCcjs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKKeBmDw;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790071808;
	b=uKz4ocp9JbqM+qvfc8UDh6XZM93je0Q7gxs9pahUeeJ5YR8w5xNlenCX/kWS3e0/zYRdRm
	Y11nmQBgSozIlALhR6XeAGxLBgzPg6mAo53WimfJGkFLFlLkukVcil7GPBMwG0ps+X/hQO
	KzKf5etc4wnO8vwUU3ruGeGC0UpaOW0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C11960AB5;
	Tue, 22 Sep 2026 10:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2BB1F000FF;
	Tue, 22 Sep 2026 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790071808;
	bh=Y5lSCP2aYhFZTVX/g8FjXagC3d60ACnslJLgFNH4YdQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=GKKeBmDw4sea+WyvahZYCx5LEy7oU71H/Drod5lxCIzOBimXtRjtmWQ5pzYebSfGB
	 qGR66NmiLI9T2BjYmnCcv730V0B6GE+KHnIUE0p3KrCPO1FZ2YviTnBwfvp+ANSldt
	 KwO+QXj2DOcId1ZJo5s+wsrypGIm9jpr/2vqfo2vJOxqQXD6P7bTWwOpKQfjQkFaFu
	 OvxMfZE2ci3eVOwdZlyEC4H4oRhJmTEYoAthX4a7zJdR8hCRD2ACSHWaGA9kD8dBSy
	 lPf0B7VBleOK6MEfO39WtLBKH8FJYreqMCR4kLiUct3zjHKwzaYL2R2xShHmTvQcqT
	 g2iQty7fIxeoQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/2] memblock tests: fix BUILD=32 address conversions
From: Mike Rapoport <rppt@kernel.org>
To: Tianyi Chen <hi@tychen.cc>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260916161105.2548281-1-hi@tychen.cc>
References: <20260916161105.2548281-1-hi@tychen.cc>
Date: Tue, 22 Sep 2026 13:10:02 +0300
Message-Id: <179007180279.508753.4595268983388589280.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D30BC180003
X-Stat-Signature: c517xykhewrpo3wf7nx58atog5s9fact
X-Rspam-User: 
X-HE-Tag: 1790071808-633440
X-HE-Meta: U2FsdGVkX1/yt2YPFUHqtX206afVi8iek0Pv1ZYurVlZFNXUNOlW9/J7OhF2+YH9oGe2CmgSj3u+riwp8U5lRQX4oGEBgJTrX6NC1UleN6dczCsazN+dEhzcazA8mHQCAHZEKJB0z0vm+QgMXHt30LOxwrulbzvISdbBcLIFc79NBFVQSpW8bGq9UZP4uD8rdFhTd4grNmT265Df6l3iWJ31UR6E+/g4nWCrRa4oZGH/XwjvQYSDARyPZDssMarI1qifxyj0OYfRLq+SduN4adl6EB/VXUqP+/wpJpd9nJIwexN5u9wK818ub2w64W+yJ8LBARf/0UpTRkRUMrSYHXprc9JeGEN7wG7sCsO7DBLAA7rrQoIKoQ5XXNLrp+w0GELiOLBTUxyNe3R0zWXizpX9AgqrEmpJ8RTs/zqL01oWN4rRzgUBYwyynOZ+mMG2gN3NdDIGVGdGiQrKuTLYtTYAnYgn796ynOyX2i/zzYSE2bHCggw5bi2McoRCB3cN8M4nr8sOXDULh/sX1wAE305BCUOKbFVZzIR45Y2LV9rTN+uQ3VAt9yA5VVoN5M1Nme5NHgXF1O9ixLnpJKkcgv5KHZJb6td9wLJvajL8uPhjAdWIeHCJsTDwEKL0uXlIFcJljCJWl7qprG/OgUY+ZR8zkRnweRE5C2u7hHBri43xwpZzsKDzHpxFL00CIp2nsIOLmTTXYODuSrtt5NCc5St5MwMLV2lQCwrAk9DOOMnDCfIJDsrJp8CUB7fqhsbXrQfgm/857vyB1yPYwliFKVW/sNl5XJPCK1uc+CFqaI8/ZJYc3yAAyokSPn2EJtpW8Ylt+nqqNF0U6+I016BYtEWHpXemv7vO32ATf0nX259Xb7dwGEoRlWrDZHew73qLCAWrL2cTFGTp5dldrWr+m6yNxt3ksVTyr3K3fEk6FzMHJ2RLIw8HD6Jn6gNIq9LEbqxgaJ5q9O/nbW/YZL7
 7lJZTSxx
 KbsZp9kuckiZAnTuztU0ANe3FWiAhEJiYGMmpsAmvvL+/pHmV0C+Pk8Ce8R66WodbAkx+OWrinBbqce9/tKvRU5nXeXaq9EhyF/hIY0ve4F529xTvUV975L5RVnxiKl7uKCK4XgL3pDGs8D+HUl6GcBDLuak/fTM0ttKQIIPXMHOcmHdIu47QB87h+MTArw/CCG4ozlIvoMSu9pgXaKft6CYIng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Fix two BUILD=32 failures: truncating a physical address before freeing
> it, and sign-extending simulated memory addresses. Existing assertions
> cover both regressions.
> 
> The runner passes with GCC in both allocation directions across 32-bit
> builds, 32-bit phys_addr_t, and NUMA configurations. BUILD=32 NUMA=1 also
> passes with Clang.

Does it mean BUILD=32 without NUMA does not pass with clang?

I see a lot of warnings with gcc and BUILD=32. Do you mind fixing them
as well?

-- 
Sincerely yours,
Mike.


