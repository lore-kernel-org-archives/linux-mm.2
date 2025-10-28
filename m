Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BADCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 22:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FCBB8E019A; Tue, 28 Oct 2025 18:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD258E0015; Tue, 28 Oct 2025 18:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3358E019A; Tue, 28 Oct 2025 18:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56C7A8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:53:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE00659BF2
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:53:26 +0000 (UTC)
X-FDA: 84049026012.19.E0B6F5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3324D40005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:53:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y70QZHG8;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761692005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4SFGU0lgJj/10+0QYHjZwLGjT5sBHYhEzNGPcYiYTY=;
	b=WDaW9nrnTXMn7qCInk0q9ol0TpTsYtBpDyAbQrSbOg+LKD8Djy0DTYk3fzj8yu3oU5w/34
	YWEw5sp8j1enSfoN7WSNjoStARwM6JxmGRN7CI6mJgS8pxwtoTldHCTkysmb/CWeW70PIu
	jQD6zHp8Tb7LcBEDklcvktq4uASTpfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761692005; a=rsa-sha256;
	cv=none;
	b=tmG/bKlZujsqipbQdLYvk9VosjfcCNMcPYOv6cQXvywLLgmCpJYt4GDY3b76XHmQ84tHmc
	pecdzZABWiXF/CUOsC5EwiUR3s8UesK3qvqSLiAiNuRD6tf1BeozjaVgZRWvET+JL/tn3G
	QGv5hSW6sEKtv+ZAzkC/Xbse2yM0rjE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y70QZHG8;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3918C601EE;
	Tue, 28 Oct 2025 22:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4935C4CEE7;
	Tue, 28 Oct 2025 22:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761692003;
	bh=E4SFGU0lgJj/10+0QYHjZwLGjT5sBHYhEzNGPcYiYTY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y70QZHG8LT9n4mmrxudVJN2xlcIb7ty3zXNrXYaF/C5I2/VWyDIoGpMh4YZ/iSLnu
	 FuQQTlzhSw0CvAOVj0syku80FEVFazIAtXF9r5PGaMqJQ78mlt1y0UEW9yu3G7UiYZ
	 X0+j0cGGGcCKDj0+ZEMITrxP/v7bGrvOEiuXkBYo=
Date: Tue, 28 Oct 2025 15:53:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: balbirs@nvidia.com, borntraeger@de.ibm.com, david@redhat.com,
 Liam.Howlett@oracle.com, airlied@gmail.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 dakr@kernel.org, dev.jain@arm.com, dri-devel@lists.freedesktop.org,
 francois.dugast@intel.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
 mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de,
 rakie.kim@sk.com, rcampbell@nvidia.com, ryan.roberts@arm.com,
 simona@ffwll.ch, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-next@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com
Subject: Re: [PATCH v1 0/1] KVM: s390: Fix missing present bit for gmap puds
Message-Id: <20251028155322.392c2fe0ce1952a61af39a89@linux-foundation.org>
In-Reply-To: <20251028130150.57379-1-imbrenda@linux.ibm.com>
References: <d4a09cc8-84b2-42a8-bd03-7fa3adee4a99@linux.ibm.com>
	<20251028130150.57379-1-imbrenda@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: b7hnnzymtxuxk8sxe86rimprie5obee4
X-Rspam-User: 
X-Rspamd-Queue-Id: 3324D40005
X-HE-Tag: 1761692005-462654
X-HE-Meta: U2FsdGVkX1+reaCbOdOdN3sk0qlFuFQY4dRFsF7lDsKd3TVC4jK36lTUxXZJdrhJvHORQFnm+4+Z+CSO6Yh5Hof2CVOehmDYc9bAUV53TSuH7Fyw7mSAykokn69maFS2zBajiP/PNHixpJeTmVemhf0nyDuV+M3lVNHzsX3sNdIOwEuJFN0DtQjv36RYBmQpVU/u1jEviScIcM47diB99AesFlWD50c7IYdZVD6Qp7mtZPXTaRe0v8nubczCIlzirnPdKF6DF3f4DaEJOG1a+fj4SMQArzthH4jNHG15pCcbNFqUx6ZTqQQGdhRksxSkO6SSHP9xmRCCkMOB3Q0+tcbs3uVV+tmyGH8l8xq7GXtRNqYvT6Qbx8PU5aui4ufOUgjlaN/qHDYP7JkKsN6lEQ9SM4dHqYc+tPkZ1b5ikBLtL6ZGx01LjRFhCLam4/wheUwAjo4fLnb7L0outy+AxWFNqtAMnJdnwXtcG8GRFcmmhWt1mY4qOcfFtn+7n1X7ZhoyPJbLkMo39+6BlQ9r0uTHOLAgdEjmFyeqnvAnz0NZ7LbhmdqAjLkqH1EJ4+vJX4v266IwcnLOs/tNLlJkGzTs7+sLyDB52SbENCTV9PSnq6FXgkxsOP0gLpx9MuqA7dZGqZoGZeS++mp050/ONhIkNf+dUZpkAbDkF/zqLzrc0mtQO3vY9FXgyYrLcnc2fZcsh/D434RC+QermKJey08l7d2szdQYI6pHRpqPD+jm8yxPcb1+Hh0l2z1/nl80sdcdWoDstqdB+WvtkvPjpYd5ROUfwer1NdsuQhHgLxKi+0Yh0vA0KZegUe9ix7+cq+9VXTyUXh+Nfr/40CMAgrytkqnHFZ/+7ETQZ6q302ItY2m03Hjk/U6WI1AH0zqqprQ6SghKJBb+A+7vdFH2EUGo7x0cGnRczh0xi0gQwqUsrqPjF2vWxPICMUXfxZLgU54usKeTpRid0y0aFY4
 xipwd5Et
 xHON5jr5PToVd3JamZlCdL7BO/xYMalIJNIcHXILtREON6A/ErH+NbJ8ooQgOesL/H8rBsmT8ooRRVk42G35qRDy42Xku9lgbfK86IHCkfTdTxfjJeHbJrGuZR7SA07PkB6dS7qJtNks669NELtB/iWH+mJaboTFgZFqFZaL2NmwmBrwQVFGk3dISjG267Q7ljaWU679BzFuUNlL3adMhbBmwekVsrtxoynkg3W9GH1JvHCH2zniwToT9PhQNm5dlRxV8ubdESAnQxwHXgoONvHtLjZieqzRVJ1f6jR535ey+diFo3WmXQ7/phgRa2KEjZKlJj4vxJlvqL7JSyVOtzy92Vg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Oct 2025 14:01:49 +0100 Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> @Andrew: do you think it's possible to squeeze this patch in -next
> _before_ the patches that introduce the issue? This will guarantee that
> the patch is merged first, and will not break bisections once merged.

no problem, thanks.

