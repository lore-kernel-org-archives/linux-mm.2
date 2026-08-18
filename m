Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60570C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549396B08B2; Tue, 18 Aug 2026 00:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520526B08BB; Tue, 18 Aug 2026 00:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438276B08BF; Tue, 18 Aug 2026 00:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2551B6B08B2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:56:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA717140AC6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:56:03 +0000 (UTC)
X-FDA: 85113178206.15.79B3606
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2F77D1C0006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:56:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kEA27Vtf;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787028962;
	b=nwgRBPe5CVlCpvj1v0w7gFluJaBvz5cWtoplhhtQV+f6uYLn8dLtiKtTsVrEQe9BCi/GoR
	xITl3VNVVTOp/QU6U/5xw4eMh8uKMF1idEzGNQGNMlA4XmPjN3eAXtZSbPMz6EC2R6fhjz
	fx8GcDBsl6F0nJ0NX8u48btTcAz0QXw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kEA27Vtf;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787028962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdlfN25XAKgFUitCj8lI1oQIUQ1SvqTjbVdFyVZb26Y=;
	b=u7FHwI6WIrA4+wTTa23uCMHo2GgAksXorkZ62oqSagRWKUysiWoWo6UbnDOeILKNTAHGhc
	cBnFcQCFiwyZXg8wX9WpBb+OA6TP4MGFNxhIAGGoqcW2/Wvogx0KornzM6vrygZoEf6mg8
	oGdZcmop0osaXW1xDIiIIUEfoJEgYh4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EE0441FD1;
	Tue, 18 Aug 2026 04:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE38D1F000E9;
	Tue, 18 Aug 2026 04:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787028961;
	bh=vdlfN25XAKgFUitCj8lI1oQIUQ1SvqTjbVdFyVZb26Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEA27VtfaClVxed/T8zuh7xSAo5X9ncPa9FdCPTgz+n7if/wcZLgJ1WH+vyQXgP7E
	 GN2c7TazsbTI3MMIjBFjOcLgfKCCxUxZq3c9kVZ8so84Pg6VKcd/8CrTaBqoZJGQGI
	 HasBfZPqn1rXoVTNnE7RGxk90uQrBKWEmzuC0gG/Rv6qYPa1G2UsDAwwsMse/x4pK8
	 tFrqqEwB+dFVWcxnuu29Yj95AIefoM01enwcilVD8o4JNNoT2SvZ6U52Z5gS+pPSxK
	 9GFFNXNZbufM5Z+WYVgbEqyigfMlODjf3sm5g4D1jzr4czVs1tZHjLNw0UdXCLrjo4
	 IR1/QT5HYteJw==
From: SJ Park <sj@kernel.org>
To: Jason Angelov <jasonangelov@ucla.edu>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/core-kunit: test damon_valid_probe_params()
Date: Mon, 17 Aug 2026 21:55:57 -0700
Message-ID: <20260818045557.97267-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818034552.11975-3-jasonangelov@ucla.edu>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F77D1C0006
X-Stat-Signature: yr7kznbxuknigytjc545tsxhnkfdfchq
X-HE-Tag: 1787028962-715639
X-HE-Meta: U2FsdGVkX1/cMPelfbpupHpkQliZA/ph34Rqew3nxP81XancIsCM1zETxpVUSYHutXWUPDwNn7uZ5mCJjCJEAl6j9LxATB/zQzWiv9Asn8s71bPy/pLfw48QjSwS/urIDRkC7MlnnJoCaNwItBNjCHzny7jpITXouQuINUqT/50pmerdFBdHLUYxT2StXZxjQCl/WLiDuUgODqRyqTPepcc06TdRG9HGEwy2j7BSlb8SugCctSgJRKZrATdDO1Udf4QPk/EE0GZ2Ll7yYBW31N1HXH6xh4OoIeWm4OdPj35lFZla30ilUGb726g5JKCC/ijcvGtg+CGmparGVbtsiz3mayhBWXo5vrbulJGJB8NFpVs9RkKRbQQNUXU3hdJi1fGMRznKpw0vqSwnLORkDnmX7wqF5pK/1HC9DyvhqMMAfDsiMcG9HO1wg1NeWimi4MCUPtJt2TlB19gepEjD8Ac7nfRi7vSswBeBcB1sCSZjqN7A8Zj1UioDVtRZjfnSsFhjVLnnjD1SNxq2Bm9HDI5KQB5xXZ/7nrTh85hyPOhTddIT1CV5gnyLz4JvfR7+LRRomC7D057L+aciOKWTDIAfH67Aj30JpOF/7EAwfTxXCtX+UAIyJKka3GX+aQCKfmGqBTusQDLgPZ9Eye+BSv1Y5i9B/QNlwRlAAx8fkRdC9PlaRevCWQ0QEw1tPxvL2Fyy2VgsrWJ8PAaY/H8QAL9F3M0aPDe+rMadV45vXa6m1YIXdvLHT0M/qDhk+mK34TCn3v1U3/Boj4Xv5YmsoRt2kXIIq/Wvx6c3jId2+2D+wGiDpDPXEp3dygCepC/fWxVwbByiRxXJRVxTYTqsP9he7v8udkHx65NMGw7suE7nvFybFyUV1MTy/UrupJWKzDyv2fJDI6BGDkytil5/6xdFpvjcqhstgG+NBCRSOOy06ddIMzZDL968b406MgC/AzkGES1E4DjPgurH7UR
 /wKZ+Jut
 vWJ3M+oasrrQ2Ysp4D2+Oo9Wt6TIHCBsjx3i5SiiWAZaYEZgVFQEmRYXpDjTR8srD0v8IpMehfYoNg9MVx+nu2wODjPetJSTIjO5gIJI1NIzyNM6W/Drd8ssfPscYaEXB9ucNEwwLU3aJ9SW++yGTXsduyMGuhppXjiHUEkCwuwQR9mRF6EJM2P37OgqdJ0aIONd+jaEj9vZNLqNDsKtztrne6vUi/Gd3R2WQgmDzwrR7JRoYoaYEaQJ9UmoM2s6Y3yoUze5ty/UoqSRxCrafBEgX3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 03:45:52 +0000 Jason Angelov <jasonangelov@ucla.edu> wrote:

> damon_valid_probe_params() makes damon_commit_ctx() reject probe
> configurations that could overflow a probe_hits counter, a single
> (weight * probe_hits) product, or the sum of those products.
> 
> Add a kunit test covering each rejection at its boundary:
> 
> - samples per aggregation interval: U8_MAX is allowed, one more could
>   overflow a probe_hits counter
> - single weight: the largest whose product fits in unsigned int is
>   allowed, one larger is rejected
> - multiple probes: each product fits, but their sum overflows
> - no weight set: the validation is skipped

Thank you for adding these tests.

> 
> Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

