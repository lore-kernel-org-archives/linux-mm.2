Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5177CD37AC
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 04:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42BE6B0088; Tue, 12 May 2026 00:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3596B008A; Tue, 12 May 2026 00:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FE66B008C; Tue, 12 May 2026 00:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9234B6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:54:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C86BC18D1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:54:01 +0000 (UTC)
X-FDA: 84757550682.25.E9F2200
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7EC8E80003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:53:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vRDMdSHV;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778561639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40KLF/0VnyIOPLh6rS3n/c3yeEGxl8OW+8w27R3WiO8=;
	b=JgPhmXLq6DtjkTKK5V8BYy4hGUga4Jy/E5dVjxIOEWlJOhofb2YSmLAUpfmLnVVoVK8H1J
	QMm2wTueUUcWA7DJXMDncj5LrwBdWuYZQnXqHuhQYZcG35RB6av6R63wXBEpz+jTidKvmV
	eWV0VAy+ChFKcjDnH3QTqVR3c+5FxNs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vRDMdSHV;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778561639; a=rsa-sha256;
	cv=none;
	b=Qvq/sIfM4LgEwCCs+PqxAatEdGcqRrkAYZdQ8a7kGE/leLZLgFypgta04T7Z47+H5ifMxf
	m7TW1UcnZBiTas4flohewar23LpkPeP/JnVdYgkPwWOe0pGR1Fm2H1iSVzkjLkBYL84o3h
	PdKXILsQmHskjMc8BeopWKpiX/KE8PA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3347141735;
	Tue, 12 May 2026 04:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA61AC2BCB0;
	Tue, 12 May 2026 04:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778561638;
	bh=v+BC38I/J+s7NNS8QzT926dbnk44scOJwG+CMFw9hVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRDMdSHV66Ov5XGS84oFpqOnMVcpPTfnD0gsKq/cMSsxb2BnHcuCSCKDH6344QrUQ
	 8+3i/oKcRrQZZfca/Yq5cxEO0LemHDl8yqavnrLJZbTqmUpLIGx/Xh4HDwQdeEAyo2
	 w23VZkpsHJbpCE1nNrBDQ12xvUGJjlJkjlHMAw6OylLYG4pENkJKrDfjDo0Yy2n5Ez
	 X+bJtqNj6Hj1ygySzcpa1TAFt4+cxWzN9xlUW6lMSIPRn8R4DiE52woxd+QFQGUyr6
	 9NobtMNZEYVlB08a7IEzy4oZMFjxtxxDqYSbNlRyhaB858jtALLMXwoxduc31xhL/T
	 emYO+o+Xp4FwQ==
From: SeongJae Park <sj@kernel.org>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/sysfs-schemes: fix double increment of nr_regions
Date: Mon, 11 May 2026 21:53:47 -0700
Message-ID: <20260512045347.102434-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512041157.109845-1-agarwal.vineet2006@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7EC8E80003
X-Stat-Signature: waj73zy3r9jybbr37x133hg1zgitqn4q
X-HE-Tag: 1778561639-315350
X-HE-Meta: U2FsdGVkX184uaCSFSkBa71/91GgnC7eovnNAykuyWMoDpvi4InJGNaSDOo6yFNSs/p/aqNxWnQsfiIAEbwmE9f5CAedMR1JfQpwUtod+yNzdYXA4wOabdhfXm4XZfA9f6ovWDmgQdcD2z9ODZjn/lbn/IV8xLWUrTTg+FnmBaDpQ4rweIj/Ed/E8NvXDGpDE3JyzF5poFbJYrRGhOAyrgJw4nxuS4/bNVHQ/uI5zZa9Xj922JSWgX8uaQ3NiUAGVSrswDBTuvm+UXhVbe+Afo+uwC1AWgH0AU220PeO9a/CNPk1lvt+BijaOFqUSZWKdNBg9/KEOZ6cvsZ17blDh15SsR+SJqKvq6Na10Qfllx4V+QtBjGTqICIFFq+Kzx9BJ9QqNbxPJIkYIVJmyTRyv1AX4JEt0LQ0eiRKzrYPzSq8MzBr9Oe/Lf2Izqzo1saEuE8m218y/Xo8Xjb9usL4w0O2OeIH3F0Jv5PBZeo+CPYtlYyCCQUKv7PwJWIahBAjuNDNSfGA73+888SG9iItw1Fx+0L4rs83byFI18gQI1v0eAXXmYOu2KbsOnu2VyUedCs9B/e+gtsl4HRdmAG8SkfbwwKVEnQ9NtMmO1zc0eMjA4H1fIVI5PQk7wpzcic/cMdfDrSRVxsJuwt6yarrG7+K46nfYwGCwtjhSEYN3WQ107F/WiqZ+RjLft4o4W/0HEjYPVQknumLHAhe1caW/9Yw9KBtRTEOnchOpsuzq4ovKtAf+NHgWfnz8QfWmObgf0/F6Q2ZWeZoTICu+QEREGwUshEXgaLwN9efjuKRmhvgJOu+jvYlDtdCc3N0Dfv6If1yDphYBy6SeO0m6vf491x4pEW1ODNFpoMK4fe9dYO00zV7e4wWEZOTtvhJKCQmFydB3L6uVVBn+M7NnIvve1mFlp0q3IDK+5PAjlWE3ti8xAJ9Z0PdnG4fVrch0fH0HuchbLDwgJhoIo1q0A
 BWBBjeej
 JRaZiOSLz1zqbIxyjbxP+2n9SP1EGagRS5gx706eJo5m2hQinRh0Zebe3dRYH7csXfdpzbxPjWN56I5Jsd6oKq1x22s6gBl9JeYe1nnD26nTOg36POjgd7mvvOdFEWuLX0izWmfPD2+6jqze/dRVPTeniBu37bVrZaCa2rYO8od1DoqHmSSeZ4ddHwtC11PRXjP8kNoumxO6KniONOWzc0A0cF7Ea4nAcYZDZGPq9r0YuIHf64Hh/nU58AUxkUzOB2E/9YXfsXRwS7W7aJdANAU2g+Jf7Ge/Boxcsnz6MXF+4xo08HR2BNLiVZPlo7eR84dfriR22cROGB3pwEl6wijW6hHQHrXpQs/PT9NMoRPLbTXMQE3jwPIT05cTX5sJxUf10vqSJeu/Ff54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 09:41:57 +0530 Vineet Agarwal <agarwal.vineet2006@gmail.com> wrote:

> damos_sysfs_populate_region_dir() increments
> sysfs_regions->nr_regions twice when adding a new region:
> once explicitly before kobject_init_and_add(), and once
> again through the post-increment used for the kobject name.
> 
> As a result, nr_regions no longer matches the actual
> number of live regions, and region directory names skip
> numbers (1, 3, 5, ...).
> 
> Use the already incremented value for naming instead of
> incrementing nr_regions a second time.
> 
> Fixes: 66178e4ec30a ("mm/damon/sysfs: use damos_walk() for update_schemes_tried_{bytes,regions}")

FYI we decided [1] not to Cc stable@ because the bug is not making meaningful
real user issues.  The above Fixes: is only for people who seek more contexts
about from when the bug was introduced.

> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---

From the next time, please consider adding patch changelog [2] here, with link
to previous revision.  To my understanding, this revision has no change from
the previous revision [1] except dropping the RFC tag.

[1] https://lore.kernel.org/20260511191218.98881-1-agarwal.vineet2006@gmail.com
[2] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

