Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AAD109878D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611E56B00E8; Fri, 20 Mar 2026 10:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9606B00EA; Fri, 20 Mar 2026 10:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526916B00EB; Fri, 20 Mar 2026 10:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 450BD6B00E8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:45:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFD241601BF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:45:35 +0000 (UTC)
X-FDA: 84566715030.09.38BFFDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 39D2A12000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:45:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Unnq69Ql;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774017934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHvgU0Pg6aIn6JhqG/RBOVTcA1SaqRDMu12DKZbPEyE=;
	b=P2WgRrBfUwmtMXnz2Z7t1Bh8hpfaMOiOLm8KNFFzHONCh/T5mVTAsDxhFi4LCWBAeC7Bhx
	ZWPcXUoR0/eHi59x8yAHifOyIM8CvY5OiOOSpWH/ae+LQW6pB9ytVWSTbomsoDhYmGhqJh
	lw16h9tuCssogKjEF5VE8d5xBQtSVYE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Unnq69Ql;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774017934; a=rsa-sha256;
	cv=none;
	b=6nRJPCUfdOVDsPkbTUZPMI5//YOer6A10Q6K1YAM7Fn2BqcBntz3kbSSUm9oKUGemcnU6L
	SdGx/iyVzUOKvG3PvEd8+QRd2gcG+SJb2g/1IbJYciVODonZ6GXypq59iwufXbaWoHlO4U
	bnzd2fFl66Cpx5q1yYNfMjbVcxm2Tpc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CF0461877;
	Fri, 20 Mar 2026 14:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2451FC4CEF7;
	Fri, 20 Mar 2026 14:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774017933;
	bh=myZR/UnlE+SI0oy9BRK0X+Y9scyat+qDRsNLHUTyFWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Unnq69QlXqH2oNBMdgOndbbuJ58+x6JSFqTk9uQ5zb89qOF3njkhcNNjP9kWH+4ld
	 ER+pquzrTBUyXfL0XtbdK23k4XZTfLw24qqTlJVWB3tqgpoju6RRUjjCqibSy59Rv+
	 RoyH+sof7UukWsTxLUa0g7CCu7l2aq28AjIYyWoiIyI78nl0f0/Hyj0i4rYd5ytL/K
	 DBzQhCHFIaHNo7MZgs+d5R6PTQDNd5Bh2Zn/G1sG439Lt2cAnZjXSOXc/eGI0DbhWw
	 Pjy+kLZcHDB/+ij0Cba1zBo7wMa+UDIViAFIYfDbWPmw87NL7A/gBWJcz/wzjFkelD
	 UIJFloVOLqhqw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Docs/mm/damon: document min_nr_regions constraint and rationale
Date: Fri, 20 Mar 2026 07:45:29 -0700
Message-ID: <20260320144530.91737-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320052428.213230-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 39D2A12000D
X-Stat-Signature: 3c8fj14fwm1qhtspxrpegrmd317b34uc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774017934-167336
X-HE-Meta: U2FsdGVkX19pjFBhevc45ofVQq5izXb+UDnOSggdgyfDFthpUJiUhCd9GwXLGROQoMP6flW86VReFcFfOclcE9joNRm9XhD8h9nRo7U2j7KNaZ6fKaEowizsQJDZyCTuFGQnNkz0MX34cdMyhHOJNInheMal0DnnSmCj2g7sLl0QCJJawgYfSHplRKCJbn4xRNVsNm8YfO6li6iUf70p4jyPOGJxfUC5x9GarYrK4UdLWmTnMBga2sMYGCoDZCA8G4M4uOyFjzM9c0+Tt1JNMH2idTKoHOWr/D5BAh5IJCRBVTH7w3frBXtvNW/MyV6xUNQOjZj0k3Sdtdes6O8jhH9hAGubR1iC5qvUwonm2nVNcEuNrSKYUQwXYXtyKmYHq4yGq7PB5pELOzuFcL2cfK2KvdvbPGFeSWhmDmVUZx9OzDIc+bZ/AKQ0EPmotP/x73ZsrEyTMYV/TUDwKuwlwNy0mTHEMSmr2W3R9kjiWYoJOOzFd0bo71ZQO2cs6DR4BBoWw1r8NyOLZDoS0a/tIvtOvu3IvndLNq81pjzU3f4qEX5yBW0B2DRzm1iNZJ2tKCWO+G3plO5DellpSOZW6AcFDu77YGDoVqikpdnMxB+b/o67fDz31aMYdozfK7RYTtVT/ZUKwzX4kBnrsZZCN18x7CCx73yB79z0cjSqJ5PMeFILPeE+KTIALfUSpcwr/wPZKkW0NVzBhZM+Ag8lJ0GzHldjLuam4xgjfDY5vR2E2/cqTEcxm+4BG0aAAClanYiGpebM0x5UpjokaoQY4ZwQR9XMzrpfVEpfpcRIUyHGKrTEJDaa2M2OXZQDxGLe0ezvipIyK+XyoJ7JxaK54KgBN5XL2YshSHuVGdSc0zvmfyTq+XIw9gGI36WsrLzfOS0B6hJXkacwa4Ao/kYgKMRGik5Gme4sMCS3BVDIMU/FtbZECJhVjRMscTjYPbPvckQQ745euCCpLnK5k+i
 y+vfoJSF
 /ERx7EP5nBBLx32PjQeX9v1G09I+Yh9Y22HgwMAuCM17/IU9D7ZoIGhe2gV0L187ePi5ob7AqxMQj29jvwX/QEDX9ClHjWd0gSYncz+nUVXxq0ZJryMfaqRynGJvbVwzFY98/2QSkBJFA1pibnIgIe35SnLcm4SCULxZJA7g0SlHmRyB2dtfS/oXEJRULSE+tnRo4ToMAWD9xiKN2YSdjNLDLqTplRZI/62q3Wz8OtOqOPbuniLc7+nDrIzdNai12TkRqR70uW5Ifq9oNOeWLk/I1HudYWgYjAeZ3OVUa4QgS5Ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,


Thank you for this patch!

On Fri, 20 Mar 2026 13:24:28 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> The current DAMON implementation requires 'min_nr_regions' to be at
> least 3. However, this constraint is not explicitly documented in the
> admin-guide documents, nor is its design rationale explained in the
> design document.
> 
> Add a section in design.rst to explain the rationale: the virtual
> address space monitoring design needs to handle at least three regions
> to accommodate two large unmapped areas. While this is specific to
> 'vaddr', DAMON currently enforces it across all operation sets for
> consistency.
> 
> Also update reclaim.rst and lru_sort.rst by adding cross-references to
> this constraint within their respective 'min_nr_regions' parameter
> description sections, ensuring users are aware of the lower bound.
> 
> This change is motivated from a recent discussion [1].
> 
> [1] https://lore.kernel.org/damon/20260319151528.86490-1-sj@kernel.org/T/#t
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

