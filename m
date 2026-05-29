Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA5CCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1380A6B0096; Fri, 29 May 2026 10:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110756B009E; Fri, 29 May 2026 10:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BCA6B009F; Fri, 29 May 2026 10:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED1EA6B0096
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:53:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACE0E8B4F6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:53:01 +0000 (UTC)
X-FDA: 84820749762.05.AE3B80C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1A0D4C0018
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:52:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=keYCTE+v;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DoKHSghnTxv8S3QLNddszzUqaQvDqqf/WFprH6BXgYM=;
	b=Iy0PIzx4LZwALStqMPjzfL4GePjKlyN2lWestIQ8deaIZIfMKVMbwm7jA/CjdEzdndnA/Z
	4+/Xiuk71s7c/46eGXkaX7A4Mui7tOSBJ71SHxpl5vqvwc2ZR7uJPPRwsEL9rK7HCdaHSD
	v1n8iZRnXLEg2A3rmKLPbvfYhvzwR8U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=keYCTE+v;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066380; a=rsa-sha256;
	cv=none;
	b=eXd05xSs+d6d0XtGeeV+1BrXwoLRFGWdthb6z2a4Bh788KoMrvI5yfhWy9Pr/WtXb0yFIh
	5bb7J0Lo//GpOoU4NeCYGKbj/yhq23Cq2i27baMd2Ab7TCoFsOdrBIMUBvEoWbrL5VYjiS
	/8c7QWpuvR9ztOuAmoGrI2Wd8eOpWo8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8151D605D0;
	Fri, 29 May 2026 14:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAA21F00893;
	Fri, 29 May 2026 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780066379;
	bh=DoKHSghnTxv8S3QLNddszzUqaQvDqqf/WFprH6BXgYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keYCTE+vnVo3qXj6X5rUFkDWg/ADhxccUC9DidvaR6t0Ix3/rqHEnTnBNQ5nhvULK
	 2URcVTlatAZmTQezK76owvgpfJjNhPXY3VpYdHZ5DcaHX+GofjyXTo1DVEptRBKWDZ
	 rb/ZJ3aGvs2y5WVcOGt/vB1KWIRD1362kD0/985Wv1jFZB/LVImrYZJ7stFCqBPC1J
	 WzaDpCyB9FxEZayjvmPSeweWi4ite9LR9PdLSm6WLqxGrybxLc9C64L/OHoCvGTJ2q
	 RVu1PSnpUkm1IceG3FOprhtiYr2G3FoHZITbUTcyupzV2++Dz/NFvqni3mUH2sJmwN
	 b0mmBBit25pTw==
From: SeongJae Park <sj@kernel.org>
To: Cheng Nie <niecheng1@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: Re: [PATCH v2 1/2] selftests/damon/_damon_sysfs.py: fix memcg_path assignment
Date: Fri, 29 May 2026 07:52:47 -0700
Message-ID: <20260529145248.84593-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9EAB27169F5D0F3D+20260529091948.1702421-1-niecheng1@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j6wtg4eff5uzx83d17hutynb6eoy974i
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A0D4C0018
X-HE-Tag: 1780066379-321880
X-HE-Meta: U2FsdGVkX1+MRuhQAOdqdmfsNiLykQFgd6aYlg38aJougf5RIYK+F2qpVFbxtt8zhU6TrwO1M9lXamX7CGzPSwVUYr40MvIZoUEgpPCJVTEB5iL7TR/F+qlc6xWLw7g/34Xc5AHhi4BiTlThDjWnTkyf9aWVFAjhPkT4/gJ7REBpEpl13fcDcc6gn4gp3M+WoNrQlO0JUZkqtLBmoGvnHKSEMenV2zFEIRAKxhz5IgsCzWEDzvQCt8/HoZ/sutdQ5gKOTHSmZ9t4jgATypVyMsmLPEDlWrHodtBDvzD7K3RusO3ckGPSBssi7UM0y/e8owgPKzYycvQ7vel4MvT/A01+cqPnVO8+DWEAKZmPRO3diEJKn5kNOcozV4/mnWVq+QeFEy08me6V/VflBu+xMA6G8FCjh2Bhgi5TY4tFn+5FyGAWN3n0Unwjk1UROgR/iz+lH733Gb2va3gPIX9bXA/48ThF+L+jgqCtii5zE7b0BMk5KmcW/iEuvURMgmt6Xce+uCj2oiHOStvUelVcyF5bGwhXN1cJ/d5vFD9PAkxBmsqZTX6+hm+Q0KWlnGP4jknhAKkkmqFrQDXe410TEAwQ51antEq1VWKVGpdSNr9ghukj56Uo/NVkOdnX6nK66IVcNJcAxd8tG7E1CNxD+Rr8M5y36/26g3mllnVunsko2wNPtGpGRHxeWba7t5mZtftFdi3FS7fCsDYtac6V8ScCzFrmJH4hjBsiqizDDxKOOdvBJCP5E83XQAgDpkvaRxSk38ZESj9FZxFanr+/kLJArR5L/vF7eLYBhY0uTDzwHeM+WDXXee/DMv7ri7up2mza0Eu67uJyYp85FSH9SPZLZ90AHg1lVIg34D7q8d37roEVyGRvvdJ/0wpPulmnPiLAbKGJSXAdNqvSenKwcT3p4gikagwNROagGdadTGA4qShDdGTYEd7zZfeC+X0N4eDtFk+6JlMg44bXdVb
 NVfifkPa
 swgh6rU+bMzyPu4lGLn9Rdu6LCIunQGe47dGDgGaOvHOLQpwSR+ghZvOXPho8wcRtf179xAUF+Wq/r03ObPwp/5LSqBSKrgLj7sqhgGg0nqKza5eiKPKWmGDSTx7wV8GYCrb7FIKr2EwiCwQMhoCmZnpvgRn+S3BLZVeDy8sUP5o5ybp41SOzP8yJUk6XFUrbE3QwjluuiXIoBR0N6/veYoPyK2Z+mZsIpur0z+4b8OmY6Dk5+WPhSyudcBpQFtu8xZbS0Vl4nqXaHXkfo5qNxf536qYzEcsHgadeMLlBGc+3sGpu8HfhqrBbDuRVZqyGI4p/Rev3nwdFpf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 17:19:48 +0800 Cheng Nie <niecheng1@uniontech.com> wrote:

> DamosFilter stores memcg_path for sysfs staging, but the constructor
> assigns it with a trailing comma and therefore turns it into a tuple.
> 
> Fix the assignment so memcg_path is stored as the intended string.
> This makes memcg filter staging and follow-up validation use the
> written path correctly.

Nice catch, thank you!

> 
> Signed-off-by: Cheng Nie <niecheng1@uniontech.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

