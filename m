Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9283C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0B76B009D; Mon,  6 Jul 2026 22:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661AA6B009E; Mon,  6 Jul 2026 22:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579E76B009F; Mon,  6 Jul 2026 22:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4AA6B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:24:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A8C91A02C4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:24:53 +0000 (UTC)
X-FDA: 84960387666.29.CAEBBF0
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9A64A40003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:24:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GgOyj+PS;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783391092;
	b=5EHYqlP/FxwpdNBG6MpceOmfG8TBYV9H5FQjOD1Io6EozTjl7A3IZmEDGfeJTmHVpLsE4v
	9M4IOTcaGyGBP5yI/q+Gr6SAQ3DsXAkOsuiv9mkaKEL2LNkDGYqm8rxAbbol7b3lhC04Vz
	atUMFgV0XHNPx4tKMzPK9+cLVxdjQ08=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GgOyj+PS;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783391092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QC3O2UucywZXQimgMV3VSL+pHVajRHBfYvR5TjfVN9o=;
	b=bH0+39FhL5mQ4PHaYKTRh1lK65AJ1GTWMFp4sIlPlYwLArk161wOuZU9ONlQvolp05gAG5
	ERBXtkE8H5mLW1YgZ+yaTm3p7ZQze3+Mh8CNq7USXQtArZDJ/mAFZMm9lovWxPjQ+h4mNs
	L257kaLtRkLvNiZ+i+IEU9nIfwX5gPI=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783391089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QC3O2UucywZXQimgMV3VSL+pHVajRHBfYvR5TjfVN9o=;
	b=GgOyj+PSOUlCJ70vsX+GszKAOkfW3wnDOjrIyGCu3XZaXzgX3LmM3B4J/n+apK/kPZTCn3
	9cKCDtlwtEhDbZEXfPxq5DaLSm6fyfuMLVJzhg6rvTwUggY7voO1opb/4soMvNQjoHeZl+
	0ZDmSTWLfvKdnXGfcG3nL6DdAqLeUJM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 2/2] mm: memcg: reset oom_group in css_reset
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260703063826.306878-2-jiayuan.chen@linux.dev>
Date: Tue, 7 Jul 2026 10:24:32 +0800
Cc: linux-mm@kvack.org,
 jiayuan.chen@shopee.com,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <7EAAB709-9AB1-43A9-AE43-8E0191BA1B2C@linux.dev>
References: <20260703063826.306878-1-jiayuan.chen@linux.dev>
 <20260703063826.306878-2-jiayuan.chen@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9A64A40003
X-Stat-Signature: eeej4tqfo7y4u1mq8mjdc8jq1xu6nt8i
X-HE-Tag: 1783391091-346928
X-HE-Meta: U2FsdGVkX19QW5H/xXuWT6RcxVHuom75rox6/efb4c0WR2FEBZPLWtPvXXQsdkeX9XBoi5lgzgB3c6UIwgFUOxLy3m3jSzcj6tD+93YJ2ilauZJkqCl2rmDA/igqgxtJnVF+YKxOucxWZICi37IB/Z9mIiXX2CqUC2ooyPX2KFAnK2jq7lGeURehq250X4dCVIAD09/ikGhQK4iOjRrGNoJ3ASWZJXzCs5UcsUrFwkQFArko+tLU6cYwfcgAkBqUW4077Kg9YClkT3OKf1e0gaptqKr0AOM9XgeUyIrxxuH3Y9i/Th3RRkW6pCUXGEQoPzISVTzJ89cbECp2ZdNAKTK3vtDPLpOOZGYotwVcvUN+4btfP63qQlhba20MGVFRlZ1p/CpbEhLH1C8CrHymE8C6nWUnTxrdsDABOtGlGLzBgHWc2/Sos0mnkObKLV/p1IhWhvpD4OXufLRFk5F1y1CgjcIH847EMEv7Oc2HDroMZtF4XKxxPS2/jiUB4aX4gUbk++n58c1g05j/E6Br0Lo748c1TgcOwh1uZtgb6aZXdnEV3CE3AvEjXlZPhJLa+1aiSk++Sx8wI9MfO8AUIhrQFcFU/3rutgYZbOc0NKGAy0gx6dutZc60QPU02Ij5lBY7HlqQO2Xh8knVQS1Muua1vKDMpIF8C7bmLHEtw8S+DNJPif2StL6+ISqpbZuA1mbRegHgw2RglMa7ThVLep9KvdLLminJFSXTJfP+o2bFLj6Ape06XUEE9ZNmmBipKzIF00N5jdRECccWOcVHFN9TqUe2SLNkFYjNq8bsOze9mQprhWH5xObLq/8aBkyaFf352xcV8jAkXseMuJPpF+SOm1wOjY7EyI9KmKbmR6q6QGfcB/Bn5ZOmMarcYzSUn1z430KCgP84ySrmH6Z4/Q+0M3TqdBHpe2G22pGp1gm6vTsyW0Mpz/NnDPL6EK5EHoeLTWP5XQA90Ul8E/G
 ER0LIFfu
 iju0Z4teLGIfARScMrXjEF2m23lKl+6lOGSt5oP/idce2ynzbB+BTudSJMiTaTbk22/hlQCIGLk05bONpIhJsQ9yxZsavKHW3GsDzod6QxWaRSp5xYESw/LQIIlFqKjOrGn04FnYFZB5dTXGozyVQ4gcTVuTgJBHZ7HiqosAhL4VLf0r+xarULLMUNZ/bNw5bTsEyKKrf2GHuT0sIV0FNkLqFJVQ7qJewK/Fsp8tJJKvF2B+BoL/3OL9w4aQgnrM9bgUSuqPOElmLrIAJqsZYAiJHblsy9kQW6ITun5AUsKzxp/W596TzUDaQq1LgO5NPNQVP4i5pJbeWQ5HhfbyAs1cGKiP6tCYBj8HcsVyYI2kDtipIQgksh0tgv5bS4cMB7Jvl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 3, 2026, at 14:38, Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> 
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> memory.oom.group defaults to disabled, but css_reset did not clear
> memcg->oom_group when a disabled memory css is kept alive by another
> controller dependency.
> 
> Reset it with the other memory controller policies so a hidden memcg
> cannot keep applying stale group OOM kill policy.
> 
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


