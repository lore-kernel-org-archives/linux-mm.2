Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60D3F9EDDB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB306B0088; Wed, 22 Apr 2026 10:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C2F6B008A; Wed, 22 Apr 2026 10:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3920F6B008C; Wed, 22 Apr 2026 10:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 253356B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:41:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2C15C0C41
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:41:19 +0000 (UTC)
X-FDA: 84686454678.09.BC16255
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0313A4000B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:41:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Uje//+Uo";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776868878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGlQc+AqP9diL1HJyH6+HmRQnGbn5ga6UORt7akFb0g=;
	b=8B5PI4eRMVvsaN/GtYsuEayEZ0jxNw4vinGicwhDkJYZsAW0v4I/IVDndJOpShCRBdn0N2
	5T3JklKUaqj0/GKLCLIULRal+4sXoUQqoHi5PD9QX8wvfBqYGa01eywvYR/RG3U1ImI3BR
	n3Ah814DQXFWPmzimLlTpQApa/kIAIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776868878; a=rsa-sha256;
	cv=none;
	b=DjndkBUrxkLchUXfMxZPy9NVCbySkwDqdPFRgFPkUwaVWe3uKC2s471TAzBoF/3hh199x6
	9GP7UAOaTTBETFUHJW2kCBhycmkk1n0/mNYS/3qaOcc9Ax/GuhxN/xN0WuUAs4h7Z41yFC
	p5tU/uiyI/JoViTM3f10MIo5gTN/x6U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Uje//+Uo";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E06C943EAD;
	Wed, 22 Apr 2026 14:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4D0C19425;
	Wed, 22 Apr 2026 14:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776868876;
	bh=dPh+28e9o3rFcTZ19LGrpIKOeKqHRgIxt9m1cNTW0OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uje//+UoTKmRJ5EoGDyItpPUxlbew9QtwD5e5jcyMBDhgk5QI6JF5kJG/fdtkc32F
	 Vva5ikvKVmSmlKRS8JSCBlRVI0DuNKbeneEvZyXp3OrTg2oVeAZ0um3pFGZuPIgvXe
	 uYxLOIRnwk2IqagrOgdEoAn3nLknWU+aov5+Y3dFoWx/fFTMQFGMl69p9Is/r6zAGR
	 Fj6lufcUj7ONPb/Jd2qUvGcxFQkKCVWfWY9ZODGbzszJzOQHt6zv2v9P4c1zSi4CIb
	 9YeHwGQKivViLtoodqTQy5EpcQh/9FbHDcMTU497CxLTtBlIKgqLWEkFd5aGL4tC6O
	 vihd6xExMyVHQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Junxi Qian <qjx1298677004@gmail.com>
Subject: Re: [RFC PATCH 0/2] mm/damon/sysfs-schemes: fix use-after-free for [memcg_]path
Date: Wed, 22 Apr 2026 07:40:59 -0700
Message-ID: <20260422144059.72000-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260422143503.71357-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qgscsmjeqwmdjp19os6ctzeekdjud6gx
X-Rspam-User: 
X-Rspamd-Queue-Id: 0313A4000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1776868877-545173
X-HE-Meta: U2FsdGVkX1/e8F2tO86lOyGq2gtoOCkjN2rcRsigeMCWnu7OTgPc9uyK0BSPzslTCA0k76XwAuQK58xs5QdcrOdZONV9ZHxaAewkxR+C/Zchy8EeeF5P6Fbl3pPUCj8pHKyex8xGDMLGjZBzGdTT0nQJKdpoWWSyhIc620X6kQq7fVAO8t0eg+BHnH4MlkUyhr/nBmTHw2Ysdwhg+i9vTcJn92QRcQOnM1Xtwjw2wx3LJqPnPyLiintkLcl8w1HBKO1ggnOWKgbRrtg7vLJWwNY/5K/R2lpuRSzNDdKMEf4isK+FqNBnbRabKZnUHFhYh9724GQHYfrgqr//zvua4bAb0Ep3ctZGgVr4QEeb/KpO+rm9pGwE/TsUwLHXBU8WvdJDv5IPteR0rSdzq8msar0bpX9DEoGawYmPGDqYF6p2eInplDUXha3KCFg3lXArDOI++DdwI7onRixbtflJtNlOKyQXBrf1e1rMovrZNRIwgxHCaIvsL8MCYeZXdZS2H8lxXObibPBG0oGR4NA5ktEhuCywzODXuPp0Gyly5pLpeJHiOTsOwUlBtbW1aTQq90tg10yKlB+GYKu2he72GFCNJ+VRyt5YVbDWdoFsFEMUtY8LLq31pfFfIOKI2wJ+lDTEOVBCTTOVjBz85tzGzRMS9ptHIaKcnklXpwGMr+NAZ1YltbbJuFcJMKmO2EJRy4j0qoL9zqtTAnK+xMDsO4sOSXnOdJ5KFdOhBBBrhmNyPRXk6NwgemORUY++D7s8WFrwz2DpOtzCOG5hD6CcK90wldNNVPnfuP9KvXELmmGm4AlwzLQMDl6kL9yCeWDGsrrYO/ynDUkcu8BrmzLDhWIsb+H0is1+vpmABueMcTqvDX20sJv2rDG5J6DnhqlEpcx5v37I+GaChU6jW3QRTxljltvuu4PQr+xD3Is5i6xpYkO4luP43AsPvklHvUX/SqbRbFNEUTNxaw5irO/
 bcCT0zY3
 BU1PcHlFA0P3x7oXoCEj/L3fQdg9XctisGAziUA1HLZh0jpvzegoB8f2VlWKu+KPTq1ET7pLScUplSWyG1rpRhxNaXvIUzrT8wUENdv1CLECNJJQxxX6lauHZlQNAx6O6elAKsb3dLqNRiZqTn4E1SksIEpTwXQemP4yfM9R3++oxmQ2OOwCDUXlpTtox+LbSekLxSTuevZnv7G/APKIqOofAe/gLdiriSyr9m+HXj3n9hRHdJ3U8TeQlv6nF4AB/ax3vmsCxISRk8cJUF0HOudFlqMSHb6md1+vLs9XP6RpKbmRdw2HKlEHBgmA0JJCXvxj+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Apr 2026 07:34:59 -0700 SeongJae Park <sj@kernel.org> wrote:

> Reads of 'path' and 'memcg_path' files in DAMON sysfs interface could
> race with their writes, results in use-after-free.  Fix those.

Forgot adding change log, sorry.

Changes from v2
- v2: https://lore.kernel.org/20260420125405.362137-1-qjx1298677004@gmail.com
- Split patch for individual fixes commits.
- Hand-off authorship to SJ, give Co-developed-by: to Junxi.
- Use mutex_trylock() instead of mutex_lock().
- Add RFC tag for Sashiko review round.
- Wordsmith commit messages.
Changes from v1
- v1: https://lore.kernel.org/20260420085332.178473-1-qjx1298677004@gmail.com
- Protect not only user-writes but also user-reads.


Thanks,
SJ

> 
> SeongJae Park (2):
>   mm/damon/sysfs-schemes: protect memcg_path kfree() with
>     damon_sysfs_lock
>   mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock
> 
>  mm/damon/sysfs-schemes.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 0d45806f3a75bf53e59475b0e56be324f650ab09
> -- 
> 2.47.3

Sent using hkml (https://github.com/sjp38/hackermail)

