Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E66BCF2564
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 01:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3F36B00A1; Tue, 18 Nov 2025 20:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CBE26B00A2; Tue, 18 Nov 2025 20:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9086A6B00A3; Tue, 18 Nov 2025 20:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81E7B6B00A1
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:50:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 11FC31402C6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:50:25 +0000 (UTC)
X-FDA: 84125676810.16.9AF1C29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A552018000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:50:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L9p/4x1d";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763517023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1DQxsNHzyvyA7htUSJkT1W9nC05SUrlp+VZNXq41Lw=;
	b=sOPpG0EnL7ate8kQ17PUFIox3bCObvZOIJsB89wG537WlXsJY8Aey6sOE8xYbO0gL+Z1jl
	Zv08hmNWaZHpma1ilZU1qdXQPkPJ7zPpFiBSUOJs/VvLnWcU0AEFRcMQhQMo9KbLjmhzDz
	QxVq+C+2CibdD8TauCmy8kssaAjvrFQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763517023; a=rsa-sha256;
	cv=none;
	b=Lmk6jjqQxHPpraTm3rVoUCawUuy/EMEFDfnsHRiMBBRjM/Ch/Vsu5WB5EvMnyy3dj04G4U
	RePh2F0EAKBi8Y6aaiTKF8LVeJtCPAoJwpQ8YDnCxleQUwiNNl3RPFhzn9ddoFb8kMKrjw
	3SItWkNP9e1beBmZU50XDo5P5FXuoFo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L9p/4x1d";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EBF97600C4;
	Wed, 19 Nov 2025 01:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1832AC2BC86;
	Wed, 19 Nov 2025 01:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763517022;
	bh=sJBRgaVUTHcy26kyOyYTfGMovMb+qdHwybDZJX/Lsr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9p/4x1dZ+gNaGtPJXLKNw04NGgAEzkGRjZ9KdoiPHETBAswN2QppIBu1YCT/x5B+
	 hTWeifxZoC9UqAWwhLIC6B3GLeZpaIfeVLmJD05fvbQCuutFXrFB6qKSZ6ScTXm3ch
	 Hq9Id+M4uUbO4Ru+J2Iaze68CXS81t/O7eq1uhTBqJfUDISKY+ukQmpNoGsAEwckBO
	 LtGYWxUQHtcKaKU+w5rBslWZNkaQz5zt6yz9c2J9wca47NDVkC34BEim3Lybd6jcIe
	 krM6dQ43Mm9dqeBPc8qDypUdEYdsVh0XxjSlyi15pUr4JuJMl4K151tAgZ8MycEPsb
	 r2ci8HmnPO8zw==
From: SeongJae Park <sj@kernel.org>
To: Sahil Chandna <chandna.sahil@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/zswap: use %pe to print PTR_ERR() values
Date: Tue, 18 Nov 2025 17:50:11 -0800
Message-ID: <20251119015011.72642-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <555cdbea3a51898e4c84fdc0f444dae0c2e20f24.1763227530.git.chandna.sahil@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A552018000F
X-Stat-Signature: wo9771up18x9xn4o4g5ytb37izaxtqrg
X-Rspam-User: 
X-HE-Tag: 1763517023-105885
X-HE-Meta: U2FsdGVkX1/QGYXeEFOsAKcQB9mv+N80T78aeqPeuYIAJJvGLHF0tJhVdRm1Jooqri/wKCdKQwktmYh5Npoyy1UCxiiJh72JHuw2oxyzljnBXl20QUmYW2/zzriZmL9m0mqRrJsZkxC1QIMOWPVMclESf3iZT6z3FT9EfKFTALZIZK1zqWUG9SOcLXsV6IO1TGhb7fgU9IEdAg5xs7JBoYGim2qMawFNrEL3RhQWennQ/P2b58MfB0zCLhEsMSfqNe4VtOEKxXnx052irjCAhmM1sJE47Xgh32iO3rBi2savHf31x5UHsXMM39P69jZPNHUDgJatUTdfErgYfPoVGHRB4382pixJMIoHmvz8UEksGrhupWR+vNWI7jUNjs3vvF6a8yQj4CW6BHFA6ssVRf+6VEJAg3OF2s6UCs0W5pP8me93FONAH0J9vCD02RO6dkbOowL8LjqDfxNPN739jDp5iafTueRCFlWj3Rp86Z1gTyff2HTWT0PApT7LscaLNgjAifNGLSJZ4tJzimXdrb+MXSoviEsbQjlS35AZ35lBIbtyAgnSy2iW2Tq41OdsLEmWDvOQ7uwBVWjto033xp7EqRsNXagFws5animdILCA9JD/+j/mPy8pZ9lIpBQKJWoMP1KAo6MG9o0l5qiNo+SgtdV/zSIugoLiLtj1iezhfncTRAqCZ3HSD96r0Nqu9ktOQHEy6/RYHAQxXN0733WIRPRVIFGUvDglAfOVYjelLHrMCyUW/FMBY2foz+a20LhbIa8P3rXfuVs5+cdxHfMAQ2kQJRj72pjPd+t5+NOrZfp/XBvCnNY54PawjFuKctK+giQCXje6kZP8gk/C8PD/Vnf7TVuML5C1uMBvL/06sptXiGF9ZQzZi5MnDrDypKGs3S/9xPAAVjYx4XBa4ToLricDn3ejUKjg8tbFTBpFM6KcO6CROwf490xyyh79QFTDoym/FqGDzqUWbhS
 nNI0teYd
 GNSN8fpFZEk37r375xF6bcd2MR/NDXWONNAmJKEtD7FI3JMwpK9M9aoqolq6shcOdmJ37aIuQeCFaZVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 11:38:51 +0530 Sahil Chandna <chandna.sahil@gmail.com> wrote:

> Use the %pe printk format specifier to report error pointers directly
> instead of printing PTR_ERR() as a long value. This improves clarity,
> produces more readable error messages.
> 
> This instance was flagged by the Coccinelle script
> (misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.
> 
> Found by: make coccicheck MODE=report M=mm/
> No functional change intended.
> 
> Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

