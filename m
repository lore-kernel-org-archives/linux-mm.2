Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC9BD277C1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 01:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE006B0088; Fri,  9 Jan 2026 20:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5BAA6B0089; Fri,  9 Jan 2026 20:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67A86B008A; Fri,  9 Jan 2026 20:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95B536B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:00:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43C575DD66
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:00:49 +0000 (UTC)
X-FDA: 84314249418.20.7A34926
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A84EDA0011
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:00:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HlR0bOOC;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768006847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dY6Ov2UdQLt919gxtLxlyF64jqXl1RoJoqrsq+bVY0=;
	b=fMfQ+P5VDpZ0owOr3ouZ57fNW56KnmqP2oF5/2qPOe9gay6fR1LnlOICDGOB8JSScYv7PP
	FvaT6A4uXykoP7TVVgp/d0SyPp05R+0mLblwdCSfe8rs1ETYMEEGww7M7JwRFKX85hjuuz
	bhRx4OgjirtzM6i00K5wj2e2chA8dH4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HlR0bOOC;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768006847; a=rsa-sha256;
	cv=none;
	b=oXUipRMmZ8Owr0ZKAPAgakYMtATNHUMMRQj9oCdYEacI2dN94fyTAOaDk4WAum8Ddv3vtm
	YhMQ46Z82dLCf0a0U99aY/rRVWZ7TiE22FZACIz/dYoIhDv+AuGZwGKq2aYTbY6Us/N+Bf
	NctBOunSSOVyam7x7mErXeakz+hxJTc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C1BEB60052;
	Sat, 10 Jan 2026 01:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4DDC4CEF1;
	Sat, 10 Jan 2026 01:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768006846;
	bh=8aEYqTxr0J54u22VUMYWBDE5QKYiAhl26ZI9/MaymeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlR0bOOCV6CXoMwvHju+GiBQph7JGA3JPhcidDf0e7j8ZSdfMQCMvR9sOr6igaBxL
	 lr4E+h3zFQj1LB8PBHoPm0rTQDffVYcZMplmVsxcBsT56E4SIOFrmsZnY7nCGMntuS
	 b3k5k/J+olc+eyt/QDUmurAKl2D7e1rl204gXIet3fMHBodiTGDMJ+UWzoSKa1h44F
	 qLRPqqJpEgdqIzX6i9IZWghWVMhWX95QKdWbpztnb4mX6SofUy+OaAmJ2eOXFN43ee
	 apRsH9v8mDAxrtMAiDzZXe+LTuOBIURxmltGbqyiV+NARYp8R3N/UYPg1QV+nbi3Bz
	 9v/ipgwxRBrDA==
From: SeongJae Park <sj@kernel.org>
To: Sun Jian <sun.jian.kdev@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: run_vmtests.sh: fail if invoked from the wrong directory
Date: Fri,  9 Jan 2026 17:00:43 -0800
Message-ID: <20260110010044.80694-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109172833.2989-1-sun.jian.kdev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A84EDA0011
X-Stat-Signature: gpmktmk5uqr56d61bpc9qw9oskwypc3i
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768006847-540476
X-HE-Meta: U2FsdGVkX18LrdaFvBZAYcoLe1IMbhbCCvLGl718Fpi7jA8ntoi3/cjQZN+B/VGP1ObUAyy1G/mh3D8sUlNdVxqO+8Ivgpcwb7qg+m+/Rcb8C7Az7WBCOnFT1QhLAR9qhSbSA57RkctRadJBszj69usCcq2qxf7IVWmEEr0PISLAVtYbSWNt9qLQXdmtPlXmoqurhFR1vKqpLy2wny8Vg1mr0dGwGDklsdqwjRxpPBoyQYX3nge/2qa5lEVydFWg+5XTuEIhpGY3NA5w+awLF+i7TzBlzZAU6QHK+O095GMttrEhHpwKGPTMr9LU4rRe5bDBXcoRpvroXoTzdJ2f9t7gWjqKXN4iGCeggr/eqP3Yl/0y2Br+/eHpnurMPzdjI4SQU4KGY+W7CzFl7YAWL9/nFQmcS6HUtqoRNUysml/P09GfzB03yIBb4e/SGPozpOuLiLgwJqe+IDxxCqBJEEjy2k5W3w7yidFqEkBd8+QsTQ1o+i5hFzbvXZ4YNXCno4HqUwlHElXqrcdKjvmSQTifihaH/WH5y3brfhPa7fl0BoJAkriEDcQ6EjuAXH4yCJVhAc78FHFMmLXd03iMN8HEY1BmQKL1VzH9cWjVbsQT01mzWfGNAbBLIwNRSNkIQqmP1wCPikELhdTcUGyTs81qXneCwcogGllX562thq47uQSY8GleFmA6xwrRWDqsbJafyGtCu6Z9k8YdQ0Vt1tASTbGJ3DNP2teaBHqPZ/w6ChrmHun0Js9x6oq6/AFpidPnwOhytNGv+57daISN8NZ/GAE+2iVu5Qz3I7iBhxorTDY2kp3PEDX+bUlQXTBWwrsDDeRqrHKanhs3vRpguZZKqHOT/17mkV9uSIvqRlG9xJzLcMma+zlgXloeLLpnXeg5dw3/C6H9nXb2mdzocSfJ4zyZjoYAPMlbnlXkKMTh45PP6kztD26VbgeGT+NJU84dAOeWuULGLINvWOY
 L07F5P+A
 PSoUZD5DQ1zypP/EhpVQHjwyI9QXiFqgvVwwljRAMpLUqtTKg0kiLs5mLKwlbemTaHF8xOBma4UcyLPlGjLFIqhgmUDCaw5/WXxPkjUlaQmbCF/tRr4gxiTmTy4Dbinagvf8MCojuQ/uXzcRrhN6qrh29Y4Vp+Q3j5OrWct0/IARzWz93QYoQyQ5tdPkluvvEaAOZtfeUngWPC/HG1pzv5HI/tPa5CPrYYxcgEs9boHblLpufvU3MyvJlKqCeWGz92HweYcCGoOgJyLpm5p7fcnHTr5VKOhvu9PG4NSpgFTSD/g54qipzRxbaxTK8OM3ueNjECQ5DdsLyS/E9E+n3s2C9PHrSI8X3BPw/g5W/z2WLkrb8gSk6V6UtdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Jan 2026 01:28:33 +0800 Sun Jian <sun.jian.kdev@gmail.com> wrote:

> run_vmtests.sh assumes it is invoked from tools/testing/selftests/mm.
> When run from another working directory, relative paths can lead to
> confusing failures. Detect this case and abort with a clear message.
> 
> Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

