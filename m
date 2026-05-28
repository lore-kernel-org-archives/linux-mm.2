Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A541CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0F176B0093; Thu, 28 May 2026 10:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEED6B0096; Thu, 28 May 2026 10:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5CA6B0098; Thu, 28 May 2026 10:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD9C86B0093
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:32:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 791BE40856
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:32:19 +0000 (UTC)
X-FDA: 84817068798.11.BBCF0E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E49E380010
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:32:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iUCKmi9r;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779978737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6Hoh14jwpBsk0F4PvvCTKLeaoeOEHn1zN3j2kuRmgA=;
	b=g5Kg37mvZu64ygagOWsqqFAKJA5hINL9P0idvV+mp/qT51himP4mBHxB0UjiXcYdPBXxEX
	WV9yXbUVZ8JPIDZ1dFKfI760mKEPTPi44mZwUkGsBFEJeTHPkACa2qhunQgGIf8XYNNeRE
	RWoWm+Q8X6eTYKnUwAmDimEINWL5Nl4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iUCKmi9r;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779978737; a=rsa-sha256;
	cv=none;
	b=AjgI1MbS5Tn+lBfdzVRj4hbXJ24eAPm3fdqeIWxBdC9vt0yCHD8Kw2NlLLdqGiu+lRoA45
	Gj/IZUa4Iw7m26gaTJWcqUU6tERvTOFstVRezdJR+GaljxejIDIlKDfz1yNTWGZT6FR2+R
	8xm1clVy8n7wM3Tcvp86u2qVZamrlhU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B19660561;
	Thu, 28 May 2026 14:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FFA1F000E9;
	Thu, 28 May 2026 14:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779978737;
	bh=L6Hoh14jwpBsk0F4PvvCTKLeaoeOEHn1zN3j2kuRmgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUCKmi9rswbLLaQKV1pfqUD1CcXPyXEPmZYpdrdV8+ZvVgg3/B522kSKrIYWGO/ZA
	 6OvDO/iGk185dYkGrH0V0/o5vPPArjiqayglj82BZ7DTGgODLYCFDqTUZx7k7xGedF
	 IpP3htgfk29MzCkFqcLgl+Lc/Ss+v5wziT58Rd4ZISqmRyvN0EbfXG2yor4nmipke/
	 /rpXuLdcZkDUaP780lwsCHF/Y1GKhZaQQbCTa6NjVoNCjouRgtprcOmq2/45/dTS1R
	 n8fqCxXdwm3q3aj21ioe+tIvYHpVeMa4YNerudehoAiO3G8lV9W8KhjM+QVjgBkxMA
	 GMYekX4H/wpuA==
From: SeongJae Park <sj@kernel.org>
To: niecheng <niecheng1@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: Re: [PATCH 0/2] selftests/damon: fix and validate memcg filter memcg_path handling
Date: Thu, 28 May 2026 07:32:03 -0700
Message-ID: <20260528143204.153713-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9479D47690DD7F07+20260528081039.1192194-1-niecheng1@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ou3quejcnybkyoe1ifsfgx4zhp1j3en1
X-Rspamd-Queue-Id: E49E380010
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779978737-341099
X-HE-Meta: U2FsdGVkX19WTvFKx1ojar6Bn0LD5VPCG7qgFiqVPaS967wa0mKpYLUW8vB3eU1ir6Bmvkmwwrv1EjUsyGQt4GJjkJ2GOx0dD8VecWUFLbNhCuFPgOwBeNi07CjYy3GIuDFuzdY3VBLVo87pYtC9od1m3HF1GNuQn4ceizTbNqyrTWt65rVswI46oHZm09oC6BAXsznX5bTimII7Rf0972ZyxlKPkgGkSbLtVc2yy2NSidFNWwTK9v7dkeUlxT1/HxAxxR9xMnIN5a65lBO4o9cOfDD8vuWBSzDBN2NfhIOz+4Q0zcM7GrhKGxhwJVcD9tcPTy/wkw9JagikcjpDEOTAPV8mPaGJFY35g20GIQPOAgJRluXwxC3hVZzGSoRNRU4cOQOPQ+mb1+EWP/+CAoKCxGdGvdo3Sh00dOO2ps4yqvfQKOuLLy+pCUfpBGzePGkhSXfrpFYQtV2CLaWQE6VXRFc9cstdM+x858wnuDG1tRFU17fgae/ZEpjCZZpwMgKLu2lk5No7/eUtR0ia4rYdVTD7lw3lUR5QXrJdLNaN5nirNKnOfJ2vL4sBl32kFMFN81RXygkdoXCIfgEI4VVvaBDznRLzi3zgHLzpZ2d8dc5PJ7+fIiVhZVUl6+4nDWHAa/LLow7U60ASd49mcMudOXCD74SObmCaEBQnzPYdNCD0qalJIufx+BUcRBdB0kGpd1KazQ+beXgfFgTbUX/N0b+LHPdBYggNyQleoA6dSuKtM+OohoiumRqV62j+2ElOhe1jdpOvZIIQBfObNyNpiBPzKvU2+RbBlOGCrZ2b+2cWS3a/K0HxTah0C7HXQ7ls+kCk3/e8jRzWsCuDQV8BACh2M2UbCjK8JELDNB1bPHctnHfZnF7NxHjK8L2mSFeYKsyDLqNDAMqG/E+bzuvlGTchF5Zms7/Vo82O/r0KhpqE7xkUs+tB+1vDlh7ig7An5QDxQ2y7HAt2RSd
 ULRcnx3Z
 EUXt0DRp74dVe2MAim4R6ZqOKBim0g8ec/O04jTTBHJ9vKZOYBV9susC5r2feaOFK0zqTfV4eX5B6OfkyFYcEgAEj5QFShQACpZPc2COFzQbHP6s0YadrKW58u+Vy/E9zMjmi4VBX1g7sGrfoc4aJp5/OToVKuuW8UKguHm/jhIk/5u5VTLMawkL7Cfst55wQcRr/E146KMLirZ1IXhZQL4AMbwh/NHA9awrZqWuZ+dnCEKnYY1avRt8E0vHH0c3ZJzl0LtsegT0mq/ufiadqXaAJVQYLzJu/EMRyEUxHd6FFIdzwViLZ01d7viUdRiVcjbu+U/nQwW+TL46kGLpnx52J8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Somehow the mails of this series don't have correct 'in-reply-to' field, and
therefore not constructed as a single thread but three individual threads.
Please check your setup for next time.

On Thu, 28 May 2026 16:10:37 +0800 niecheng <niecheng1@uniontech.com> wrote:

> This series fixes memcg_path handling in DamosFilter and adds memcg
> filter validation to the DAMON sysfs selftest.
> 
> The first patch fixes DamosFilter so memcg_path is stored as a string
> for sysfs staging.  The second patch adds memcg filter validation by
> checking the memcg_path sysfs readback.

Nice catches and improvements, thank you!

I left a few comments on individual pattches, though.


Thanks,
SJ

[...]

