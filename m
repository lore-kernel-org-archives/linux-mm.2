Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75105CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9528E0053; Thu,  9 Oct 2025 21:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69D08E0002; Thu,  9 Oct 2025 21:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B58AB8E0053; Thu,  9 Oct 2025 21:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A45928E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:31:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59C991DA553
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:31:49 +0000 (UTC)
X-FDA: 83980477938.14.C8CDC68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A8B9B180006
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:31:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nLMUr3wk;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059907; a=rsa-sha256;
	cv=none;
	b=GAZGc1TqRfA+aBX5Z/A2gYZg2MmsJ3TitzHujRUffWf8CjST3LNVviqbH7QP75S9Gbr3Qw
	bCg+WUMDla9ccfKt+KVEFo48WSGHuy2hLNhUCgt351LX+9dRH0OOpOpaHLIhMkkzwhs/XJ
	3nOU384zbxCnEzrR5K7iAV/Pdq685Ww=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nLMUr3wk;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8Dy6f5tau94xK2M+9ttNaI46YK9xGNDbCMWVYShkss=;
	b=XriUktdylPiRXeHQJnMpcNlylycG306Wg6xNIL26NYmjYsIzMAoUCUObOS1CPabprsl/8Z
	tYCMBq8pHfobMoywkIyZR3BYcT5FkBO69I3KANMdzTWAmWk3N7M4DUitQBxOxqq+fxKzu8
	SHV/lxp/P/OFrH/dSggkA5IorQGSQRQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0543D60145;
	Fri, 10 Oct 2025 01:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1812C4CEE7;
	Fri, 10 Oct 2025 01:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760059906;
	bh=+XWd4FA5IxyJuy6HfD5Hzs9uYPDiwPXhP8vldhK/Lm0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nLMUr3wkvRpNOtigBtfd9AJDhK6ODHmyiAhqRnF2Aw8GT6tKS7vf/UTH3+wErqc/5
	 IZ2gitJ/bCB71BPQSFZ90M6KC4VGbXQOw+5nDAa3uGChJj41p6E/GquCw90OnO7Aw1
	 Kt7nqHI7M3EM8MUOaexWUU+Vevw5xG8GTNElbYeA=
Date: Thu, 9 Oct 2025 18:31:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org,
 rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk,
 viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org,
 jack@suse.cz, willy@infradead.org, m.szyprowski@samsung.com,
 robin.murphy@arm.com, hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, minchan@kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 iommu@lists.linux.dev, Minchan Kim <minchan@google.com>
Subject: Re: [PATCH 1/8] mm: implement cleancache
Message-Id: <20251009183145.3ed17cb0819f8b7e7fb4ec43@linux-foundation.org>
In-Reply-To: <20251010011951.2136980-2-surenb@google.com>
References: <20251010011951.2136980-1-surenb@google.com>
	<20251010011951.2136980-2-surenb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: a7bw4u9qkfak58qetnubgsrtkoqqcikr
X-Rspamd-Queue-Id: A8B9B180006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760059907-966943
X-HE-Meta: U2FsdGVkX19tMcLL1hrFyyNCVZBIsalR+b2HsyrEHPBtWBJkKHPIIQ93cq+m102K+KO0F7ohAhshUls7psrJvmYqVexZwd2eN+6jXwI26aLJSC8KeAtVrfDTRt+M5ZV3CFlJBUkDHamMo3pLZIfPk9T28rDzaL4ZOfQhQdfRw4NPFM/OSsgrRaU/1HD6C3E1pzWgbU+xoDxT9ETJP5kejcJ1sa+eflMF8gA8OrSVxHoAN8YBswNcSdMb9bGlmbciG7VrWspKkqRoQo5qK2MVKzr+UbDwIs/oPXUnmBY950J7Xwh8mB5CAlWuHfjv7PjJy25Wa1XOJzQBwXi3FutK+nhfH8NiUxLXPjxzqqtJ1CrPG25tVHKrU0/pcdFmOkOINGZhA9ZqVXsLtKF9kZfpJysqEMHfdaE6M99IQNpiXOVrIedOR7y5PDEmBX+zfPY4p+KgJDWZPaIUq5KQqTyApXKuOV0ORo/pl4PXMY7x7X8PNIdoOEaEyzDFyhJkxGtglPrPp838AM9LUoDFR+QoYbp91WS6L4Pq5muZPGcfE1O41FHqOaJ3APQQbzqkyjtbWOzviBkfr9f0p9yGzhGwbzSRsNQZlOFZxggJQEhElP5U/xqDNUB0oN54TFXYgHxRFI4766ql5hdjulQlSbRMx60oeroOPpvRZDTGDhGX61XluDmytE576ApVLxRYpMEPBKahCGe+QShFjyjcaT/TZkPVUTLio8oEeDUIlPUWAS+IQhKkKNFMWwhBRXzRwsoqMTjxYqslbEbjV65cVhR0iAa1kLbL11tD4eQ875TivFM9rHzvad9r0V/tK9e7qxZ38BVj7Oyh0R7pnFoZFuqJAbL4PzcIESxPeqxFmvGFj8X7HVszn4XDgcGhz4nAMg4/+dVWRFI1IUqcEJNnCcy9rluzMpyQgh55PgtR7rQZAke2RhTAOiQnMGHDcnWdt3L4/c3XxO+VopmDqOJIs3G
 rIAgVaDZ
 HuGv2v7J3VYqSW2YV8n5TB/Ii4Bdzoxkv7vfuix2oIOHhBfcZXHDqhDq/o5nXd2D5VYZhoXP6Me2RvQQGQju/GVPLCFcGnBcMzJrAETUfB3yemZhZn4GLfFXLnHFEllJnp3//SwR4UEdBxn2kNqqdmwHZky2L0bBvWGp4wwOUd3+l+sc9uCA6khCcGWbPdezpqs3V/Ms7+sHXhIhu8yNfhTHARshaf33JSPmo8GxHYiL7XJu/80HyO8YolzeObY+k5RLDj+kZ5xrTASG9CImM5na7EPpn/sgSDTrVHKtoPdLi884=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Oct 2025 18:19:44 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> Subject: [PATCH 1/8] mm: implement cleancache

Well that's confusing.  We removed cleancache 3+ years ago in 0a4ee518185e.

