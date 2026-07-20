Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA94AC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE8D6B00A2; Mon, 20 Jul 2026 03:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6FDF6B00A3; Mon, 20 Jul 2026 03:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F336B00A4; Mon, 20 Jul 2026 03:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 660206B00A2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:19:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3665D120506
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:19:47 +0000 (UTC)
X-FDA: 85008305214.19.FFB6AE1
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	by imf25.hostedemail.com (Postfix) with ESMTP id 47D81A0011
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:19:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Dz9YWgNu;
	spf=pass (imf25.hostedemail.com: domain of chenyichong@uniontech.com designates 54.206.34.216 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784531985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIQC72hPohO5MdyCEUkKF6Dc4FUOXarb7A6cgM6I2Gs=;
	b=zR2mzntnVNDHyM7ZmW8gUR+eXXivE6CzFqRfhtLZbDYnt0omAvtxbhFv7Qt8VFGYmeLpJ7
	mbt6O3VmZQQoSoeNSusI1HzUdozg3NfDZOas4xguAY2OeGVwPXFfC3a6nwW9us6PXPlbw9
	7NCa6+SidaEU3AoiFzJHUoKRRQzvLfk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Dz9YWgNu;
	spf=pass (imf25.hostedemail.com: domain of chenyichong@uniontech.com designates 54.206.34.216 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784531985;
	b=qqn+kmYFI4MWBjvPWOA8YoxPZNgW+E2Bf0z7feTZ44wG1Em95w1+NjvXIuZSJMnrBXTfF8
	zpIU2TJ7X+tiw4RP9Gmj4kn2XgXn28rt/yPSW0UgtyLhpUP6TPw1fIbcjinKFRpzlZWyus
	YNyZ+TBan20roradMDRjm/kTxG5r1kI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784531966;
	bh=tIQC72hPohO5MdyCEUkKF6Dc4FUOXarb7A6cgM6I2Gs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Dz9YWgNuU5hTFfr+kd5ANon8Ltov2+KZuagz/4NFE/aDYLnlSjq78A1yhhy3U6n6E
	 WWW8k57bAG5koPNzvqyy0sikyNxZvRi4IJbWiMbWCMsbH3228Nbgu2DyF3IUTaKBG0
	 0PyXeov/GLjdKmTngCTGSdendWYLYLn3gAkr8LLI=
X-QQ-mid: zesmtpgz7t1784531949t87c9e98a
X-QQ-Originating-IP: skF274xtqZxCW0zkSPWvhaZPU8kqux4Sd3OnVjdaCTc=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 20 Jul 2026 15:19:07 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3588568058455700877
EX-QQ-RecipientCnt: 8
From: Yichong Chen <chenyichong@uniontech.com>
To: akpm@linux-foundation.org
Cc: chenyichong@uniontech.com,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mike.kravetz@oracle.com,
	muchun.song@linux.dev,
	osalvador@suse.de
Subject: Re: [PATCH] hugetlbfs: release subpool on fill_super failure
Date: Mon, 20 Jul 2026 15:19:06 +0800
Message-Id: <20260720071906.1388412-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260719225438.041287a56c87effe61796483@linux-foundation.org>
References: <20260719225438.041287a56c87effe61796483@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NPkjkILWyNMcQcxblSPVW6k7LLoYITpO19mVcVtZ/9At4+EdSXVR1dSV
	XUk9Y43Z4n3ADzKG8qafLAzi0F30FKM9o0cKOIyBFVIy1usnuCmrTwnNge4jn+ewN0mLKet
	06nFO99/IRr6PKOQQGElaw+u30QvRkiXgJWh7bMIwetZMX4fAzpOyuT4S1eYefrC4z7uJgD
	MEXMJJ6DfGSD4trF5FDV9QeNg26s5oT/fpVR13eFpiVotk2sy26WQe7altxQzN4tYElNNXJ
	JvsYY7d7+5/dKiJ2EnNd+wSB9Yl0zsGP8CDfk2Babg/H5vwN3ymWRjm5JZwzkC3EocRSy/y
	9vXNMcfyT9P2v+YbcX5ETyIfwfOpNsoivpuCoUsjIXDVV50CE/8Z3D72Ecqu1ogSk3n5Aw3
	PZKZTjm++qSNB9sR7tXkqmUfaxsjZpm0u+pLgca5sXWTJck0xumGknyI+YtNkDbMqNDMZvw
	fKzHclLQ+wXcSJUeTyjJBDPLEFHIDIWNQcPtA8UcaBpH+zjUoCwqpU1HKY7LjsaxwqRd10b
	leph3G4mxFhoUFSmpCvgsj8f5DNAF+jHDKSpTW6L8+NgYMUf2qdIsHU2SyUxavF9esGJ+Mt
	ULqtyTVWYYc6uBumWkE4GSzAbt31ztDsNW0PPqqAldcA+1zA8/W4ZaafMdl44xgI9zzNcLx
	cQ0ER19gCN9YGHutkMBsPLl0hiv9390VusZiuLbeqZ9kPgsr3DsmWgW6SWFIlS49N+ka3Xa
	mXDS73KEUDDxwT80Fd3D6CNzT34/wZdbvAgeslTK++W57KzUiUQeU0HeIhrBd3M+diiVzeT
	7/CBkyJK7FwfwcxEeLOJNy3cNjvdlw5z5xYlezuOoAhQMR/euge+jgTZ/EV5AT25qM5JRIb
	I9e0DL/DxVsQ5QF+skWY0Z2djrqH3b7dUVkPoOiJ4IeDjL+Ug/Kq3axfrAU1ep/KtatXrgR
	8hOi2D4gTc7GLKiUWs9sCt9Butrb6m7rn0bVLbSkjmYyHfso7Zn4QSWVMLciq+2j4GuD8cX
	4ax6eku520yM5ouXXk75HSvlyRItxCfRQeyX8joiwAba35LPqP5F7CD0E/aDKI4eTJBSCw1
	FFGGLoWT/9bLEWgiZw6G/E=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 47D81A0011
X-Stat-Signature: 6a6jnwb48c1gdsmwjkz8h9k7qyum17hx
X-HE-Tag: 1784531981-600455
X-HE-Meta: U2FsdGVkX182dvgFjhVlXYHCloC4WFeOjA8h9/DnjGNIaZsm0UNBiC1EeSsMNX0X7dsz6fYMA1/a2fL3UiIiW9WrTD4RkW2fK7zwIZ7BCuDSAdC9X6VIB9l1WKFuSCnYIHbEGx/URpZXT3mWX+2JlhbatVYBMpqD2pd0UG2DlZ+4inAyz3yNL5LDcGBuIjhDvTEecuVdckTFQz0GdTqVkBX/qkPTFLlPo7XxbCZRB7sPmDIixiWl39SizAw6Iwth2o++5/teNMKCor8qDqSkbMyF21k5g8aqo3frHN+J7IZUwvXQnotDJjukHC+Akn2Y/yJy2kruPzci+o6o70ofGEWu9PGAl0fW6wwRujqABHyUc/UN3OgNlor0HCb41hx8hXYXPFmOTa3Mx2UQuSVoIyTyb7OGFdqMtfmbzeKVLCHNVQdnwwiHF0ypRDEKLz6s3YmPYYYWZi29cVL33ahsZeh0L6mCY6fDglwlP7JcXn7FqXlRVCvFf2qMtYtYIbMmCrapDya/uzZ1Xhcn4NcJ/yivqCGFjRUKRDRVDR8fbhDJiYZsh5gqW7VEsLnZcSrUzg9i4MKEU5otN1CSOxvYsor837kooSTX8YX34rD4kPf0eK5oqyVYF4nUVNZdYKQk/77w2Serk08Fst8YL/hFMZlZIZChZObCDHdNtLfD1HAyFOlaF6ltiU1IjoKlwnnEGKw40zJ6uMq+cRQQgEd0Zf/Iuag2NPgJr3rfQQXACkOmTz8/KnkNl3Nni0d7N+2ht5AuEZSUFKp5+wh0SDRFscg/OQGdfDuT925ITQtUVU56MQrdDjO1Atac+JEopfvaGNHGtoAvH4rUf+PsO4PBG8iSYE7GqSQLEExigfLkoc6yFi7SLpPd77v1NWgxm4xKJn/C2ZzBPV+qs1lgGedu1JSEa9lw6XzpfbjzlHmp9mLtVUcEHiWfJDTpFNCz4P1z3ORNhuSmLu1gBgkhYF0
 xJ0iHyyK
 IADmj1eXDnHVzi3uj2XaoWdJf4PNdN6elELTl0JFTjppdP165b1GmhTZNV9cZt0CAF9EpsQ+gFTLBS+Ie90ouCXVFPTDLKPD72P3SI84vGSmYZ4W9lxPqCOeuZUXsUgntcEHs34Cr2OebsKRV/3XzIr9mkHZ/MEMdsJyBwr+7VyMusUxqWdYhhDpMQcN1FFhmPp+jRWt2+J8uMv9yz7N+wxJFyjgX/vR/+XhUa3JbGMlzHIhCPxJJsxHjuJp1+o+i2qHfk7DtYTEdflPT+XySFIPh0oYHsUzgNve0YgdCKcCHahWUtF8xob7jedr87lMrWsctQJMTz535/bc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks, Andrew.

Yes, moving the NULL check into hugepage_put_subpool() makes sense.  I'll
send a follow-up cleanup patch for that.

The Sashiko comment about unlock_or_release_subpool() also looks like a
separate pre-existing race to me, so I'll look at that as an independent
fix.

Thanks,
Yichong

