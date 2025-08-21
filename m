Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5686ECA0FE2
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9A86B00A8; Thu, 21 Aug 2025 12:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1216B00DA; Thu, 21 Aug 2025 12:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E78E8E0001; Thu, 21 Aug 2025 12:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 784306B00A8
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:56:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3088416048B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:56:07 +0000 (UTC)
X-FDA: 83801367174.14.3065F28
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8620820007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:56:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2pFq3sw;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755795365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fR0Q1Th5zvX+QqpFPADy2v0k1mWgMpF7KjRFCGiiaRI=;
	b=tfJEZJ69+/4LzqmFK+KyyQtfkkwa0DtqUlfUw8K7N/vzJ9Lw80myJFeHYbi3w9j6t6eAzM
	VTcIcBHj04zDgj/HjMFbo+2ugvazZHIX3mCV+w70Y/vb8Ezk2+BPk+wMNZx5mJ/OFyx9op
	EcbOMeGLVJBjXj2hGsh4TZkGCC+yoJI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2pFq3sw;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755795365; a=rsa-sha256;
	cv=none;
	b=DynyUiToemNeN0S4CTdQR55lH86hkl999gzK9kti8wV+0XExh1K0Da1Ol5fciobzMequSS
	G6i6bjXQzhdMnR4R0y7LQc9FI5umiLdMRhjSI71Cx0xaMsQWOH8rjk0VGBkkb23FOHhut/
	ZVNopAwCrGzu/0RwTtnoTK29/USXpIk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id DC140A5851E;
	Thu, 21 Aug 2025 16:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C4FC4CEF4;
	Thu, 21 Aug 2025 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755795364;
	bh=OTJfMD5H4cDT5DeZwBC9vrpTKC9XBlJdn8JVZTk0OfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2pFq3swWLYIK/fEgSYiOtTYtShp4zuzf3sugfUz5NkK2zy+tphCNy/d/MvkUV5/l
	 qFPdgdCYcUco0Hsy/E87K25hxzrJSQ31SToOjB/EDos+/4n0w6rK+chN1ioL48MHSe
	 cOc5MJ6stgKBkcNayHxqqXcg8aqP6QVytAEXPOyhG5RaxxZ0QvEQbRMCvNLn88Jt8F
	 1/zMcIHH7gpllTV7BrZG/PzZfyVGS6HQ3RO6p+MTrHHYJw3elBu54+axH4A+Wr4Ent
	 XIxATolM0fhS3WrWQaGvf0yC85rJjWG5KjW/yH6esL8uKfzbkPthPD699lY0fSp/rN
	 3mZePrUrR0Jsg==
From: SeongJae Park <sj@kernel.org>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	shuah@kernel.org,
	mic@digikod.net,
	gnoack@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	ming.lei@redhat.com,
	skhan@linuxfoundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH] selftests: centralise maybe-unused definition in kselftest.h
Date: Thu, 21 Aug 2025 09:56:02 -0700
Message-Id: <20250821165602.79023-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821101159.2238-1-reddybalavignesh9979@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: due138331mgo58ujdgtw1fbakudy9fp3
X-Rspam-User: 
X-Rspamd-Queue-Id: 8620820007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755795365-736843
X-HE-Meta: U2FsdGVkX19CGOnuJbsK5wgqMEUrGC2Ro53U45tN3IZPVwYle39gDCatjZT2j+9szXMaBOjcJbvIVhKejfCYs2nfl6fquORZF7vdlRKqEzpgB2NV0MH9MPiAAE49OT23B41WyoUoMIGwBPHAdgZtNEkF6VzxY1swl35OBlcHKAoAmyQixZSmLCWBi6oRs/Vxw1SZA3KxBza8HHqc7Ak1wjSmuEaxbZ/DZUiY2GY1CPenCGqBWyTqSA67tqcHHSwh0UkGdb2pJCO9H+c/dB8oLRhG99R6DmjjpI0rMSjNaPcdNnyCBYyECFFsFam9mcifmwyXyOEU5+xpTJE14clQly10p3jGCQ03DOLX2Zvi2jjj1UgepQPeBpTNuP7qOQSh/S+hpCRUZ5t4srYhuh1RGMWJJGYsnsXAkC8U2WIWhg4Fz+pUhDIhxT+dNLw3gGQ8y07Uk9EiF0XatalK7m9QZAlYvb4nb23EnOG2zSTVu8t1RenqA5RGmwG/kk7/oOx/4jp8sMRqUJR5ms/f/xVmiEuaqgTEd3BflTSQQsb+PT7nAVepckZxqum/VlvrIuN9OEUlgHIeSciF2fbEui2yB383NbOX/EkPpmgiLxrlrqqEtlFHnOBNsB1t6Xj760uqSW+tPa9riQxcdoNhyPXtC/xd1bLTy2OH53vV+uHQUs059wXC6mUjIcz58BGaEHZM5kT/UPj/hZ1ckb773VZWzpuwWE7v9ganiaOU8+GbpDjQloFAqAUBBIyNfxDbHkGaGbptxP6cVN2HIjFuOL7Ha/9utbJPAN+59e25AEvR9Srhyy+uewtwlUWPhNGqJ26n3TTUu5XMLuSb1igkh7GdU+f8tntNvfWbkNhI10UN3JEIGsaxQfMRnXRTBCVJAFVgMk/QMCPhDHyUTtGcz++rWIjWjsnbw7yWoUsb/UhOdMAgM1CZ8xUEuBSvXaGHzgV55f1ckwZ5cPX+ah6YTsG
 Nn2MSUS0
 ukJoQBQrLOpzmeLrCR2W1FmongzOo1SZM5zZMxTVsgTDpPG/1z6Byyhj4FdouJRjFSiqDM/c8gBcSsGaM1hnb1/mNDp/BlbpVWrTMKB1B88p4S11e1PLkO6zNtaZSGuCOY777MoOQqy3FgNa+Z/TrpsyP80ohdTRIUmm86ArwaqRTElq1Maym6NA1dKsTDeWwe7t52KL1dkfVRwekgX46KugFyNZnpoXPROPJ/wMXORM6zVoNAfnUEUSt5qOGbNVblK+3ly2ZFGCiUaxmKJEvdccOKfGTHUksrYEFD0Q38wIsey7z7KwoesoKJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 15:41:59 +0530 Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com> wrote:

> Several selftests subdirectories duplicated the define __maybe_unused,
> leading to redundant code. Moved to kselftest.h header and removed
> other definition.
> 
> This addresses the duplication noted in the proc-pid-vm warning fix
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Link:https://lore.kernel.org/lkml/20250820143954.33d95635e504e94df01930d0@linux-foundation.org/
> 
> Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

