Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79C96F532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0CD66B00B0; Mon, 23 Mar 2026 20:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4726B00B3; Mon, 23 Mar 2026 20:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21536B00B4; Mon, 23 Mar 2026 20:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB816B00B0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:27:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BB27160ED0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:27:59 +0000 (UTC)
X-FDA: 84579069078.29.A678124
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9B2F680004
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:27:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c3d5O1zQ;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774312077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNBbEO41TGRIcfLATTm4gHmPxLY0yiFGVzJFvTskGZ0=;
	b=1B/Jkv6Lbqim0TgVID6DSpnOH8smQLzUkeH22eeO2Pm3hA/DX8rdSZnSpjF9EVsaur6NkV
	rq1+qQQBAHZOD65UViaVYPp4q+nH+rc4ATXBItmcuC/4T4Ttg5uef6HKmXQk/UYObvjU/q
	BhqioOlrAnWUG59puunv7ZN+9vr1/Qk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c3d5O1zQ;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774312077; a=rsa-sha256;
	cv=none;
	b=fZmkch1M8m4BcMReaAM2+Yrk8xTG652zcJjgarSgmmNkE2Tc7f7lo7/5c8FzfTO4MQSSDy
	GMSJ14aly/EmRQlL1arnRJiILAF6WVpcu0Ayg9dWN226dmRUwXQpybiS5HIWiD6b1EfDzK
	mcS5A8sNoLl+05/LXvs4CAP2n39WT9U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1830260120;
	Tue, 24 Mar 2026 00:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C083C4CEF7;
	Tue, 24 Mar 2026 00:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774312076;
	bh=CXHUdTyfTNdbD2JJq9Hsvz57+3dMhKPZJcBepqZpPew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3d5O1zQ811WSnUGMoslPtMT2h/0SBlgLhNZQuaF6NXRz3i+qZyYPY1eqVGbTjVA8
	 J/pIHmbNivVi9QqgRhCxK0LhmUnKk9vScprO2uoaZXtiaGCJTuZNDdIfcsFZcZ8J1W
	 cpEncRyTN0vhLrD+wfJezFHkNIG3/MQijZOuMGqaTfd1Mzn/cBOyQx8e5SBAeZ334x
	 OzFOg1Q3uV4F3VNB5pgZRBvgbqqLtFpysXR89MRU9ulBYdemeNJsWGGHhKgnkxmbc8
	 pHhCsEuCmDGOjs2CmsyqwGwwlwLLnQ/p3FMbUgEJYv6adqtc3ngr/k4xtjKm6XWNeH
	 mtYnR3+dY3TWA==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: optimize kdamond_apply_schemes() with pre-filtered scheme list
Date: Mon, 23 Mar 2026 17:27:49 -0700
Message-ID: <20260324002749.86524-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <43C21A6B-B27F-428B-B65C-1BBC9D66AF38@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ncdktzxjy93fdtbrfhrjfjdikb81u1ay
X-Rspamd-Queue-Id: 9B2F680004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774312077-276157
X-HE-Meta: U2FsdGVkX19OGtO+gkUWaqTs5EtZItdPMV0I24V7WuSMqpZOSXWTmFRRoOLGsVi7XBRyKnSsD8QbT6uIP3JONq+sCcm3XPPCSvzzLYg69SuVMzq96rR2IfeBXgiJzWppy+TBHM5ujCYjWXNRZbME45kr/o4pmtUZirYZB22hErbei0iNq5758M8XhsosrlfMUl8gC8spwFU5+95zZGi6W4NzUNkwjPwpUHEJY5W+QxD1utU+ugdFZqLGUMIUFR60Ue7JEEzMbUMiHUhiNrMNDArILmccjcaqxA0B6zczKh5is+5Q+3HUpK9xNj78exjTifsNqLScqsA9pvn9otoXms7vWsw4hEETo5ZTb9pq0BdSGoHyHU0P8LaV+CJu3gjfA52jg1fiJFsJJa9P/EPpcNRhM5Vz0/KH1JbyS7yZEudjFMfAZY0Q2s7S6goghHxohkSbs5/WA/xI6iVIjSfLzXyOizqpPWElKW4Mq5VP0xouVlTpjTxSTf6Xdnx23sKpNE70xxe9BP4ke80y+Tj09VEHN7y4INGMlZ4Nz8cHJ1GeK//Fmh0MK4xUs4iNIz2FzTTSsac5BYAJYt3Qaf3VxtrwmdeulrYVlK24QzuCIz4LZSxCSpYnJ3/a1vNB3EuAEdsvfCfNghzalxDVW1wtrstspCuErcvXx79hbqKlEPKxFUaWYfEsmi7xyTB7qmAj3IpvHkAWTsusgyTKUh14qG7akOJ+MpHKB1C46MeExkIscBrkrywR2y9/aDBHPyVV8AOHQT3MEDzMjozvMYeJNXnlWvFWCJnAloXA7+PS1hbn/2LvABKt7ctEJOAY0hN9MxT+GmBuL56TtMRkeXcm9O2+kfSsIYk0c0pXDzCut0hyTAz0Hn2vgnD/c8zBYVTy8xy864o0iN182VXI6IgjyTgQg40sOn2renJYtJ3aQMkqiUBoGnEAYx8AZhRbA//6MF3iIHHu6/vXdl+96K+
 e3F00cNY
 GiQ/HDn1NTNLU1Wx51ULLvSx1RbW59lQKzAdYULJyDvrydFlII2SAj6H5yXwx5wwTR/7VOZHP/g+bpbtzyvUuW4o/mqKKHCK8uCjXGqMsIYJPCJWA7bycfW4OYH5KKmtWYheeKFaNegP9jcx/T+sgrUH5SS4akPcaBhF/IKy/lnZCc84nIZcNWnC4z3nSykG1zQQNorPGyRhiVcqbQRXmMlmt8LkVktiPORr2nGfif45+p98Wps9ww7e1UY9qhxZL2tXCglNi5rOObRCVy+sIopRP7lohAlaFz51jm1ZFkAtaispG4Or+gnDI+A39S1wUh+1S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 15:18:16 +0000 Josh Law <objecting@objecting.org> wrote:

> 
> 
> On 23 March 2026 14:20:51 GMT, SeongJae Park <sj@kernel.org> wrote:
> >On Sun, 22 Mar 2026 22:56:27 +0000 Josh Law <objecting@objecting.org> wrote:
[...]
> >I'd suggest to hold this for now, and revisit if this becomes clearly a
> >bottleneck of a real use case, e.g., a user claims so.
> >
> >
> >Thanks,
> >SJ
> >
> >[...]
> 
> 
> Yep, ill shelve this at the moment. Thanks for the clarification

Thank you for kindly accepting my suggestion, Josh.


Thanks,
SJ

[...]

