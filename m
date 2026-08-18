Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59653C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 01:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49DC6B0866; Mon, 17 Aug 2026 21:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFAEF6B086E; Mon, 17 Aug 2026 21:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC30B6B0870; Mon, 17 Aug 2026 21:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85BA16B0866
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:41:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1035380938
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:41:09 +0000 (UTC)
X-FDA: 85112687058.03.8588EB0
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1DB76140005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:41:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=A01H37QD;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf09.hostedemail.com: domain of mambaxin@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=mambaxin@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787017267;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVd1wQKoqHI28CRDRlJL1+LVPbYT19FBeIKKZuHT1zU=;
	b=sXbgjylOCvAWowgntB0IroK1w8TCTgBkhLISq1HR2t9lSL/8wkaNvSibZP+s5oodl4FAJm
	T6qm6GwoTuXeg2Dd/H9AKvOSZcq25jqdiDriwHCIKwHIDRY8Ftlf2NOta/q2IHVD6ENEXa
	/NY4YLpWNtAC3zGFxz/UOsLuOjaQ3PA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=A01H37QD;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf09.hostedemail.com: domain of mambaxin@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=mambaxin@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787017267;
	b=s9u8pjOk52yHjmX0jsg7Xydocvq2YpuT75tQ1+jz8DvfTu5xityleDjmgxI3vggS6u1328
	q/JDCzLt84uNfmDkZ22wjNRYM4USD5grPfINjtdJPgbu4F8fUOG3AXVCnv3dODZrg37I2L
	Ns6PqDOhYpfWYyD/q3gth+Ubj+L7aU8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=mV
	d1wQKoqHI28CRDRlJL1+LVPbYT19FBeIKKZuHT1zU=; b=A01H37QDBAkloONm1F
	9JkR4Nia6hbpav299jFElRThfUApXovf7dK8hZobSOXeuB3KgTEbavuhGYhmf4Ua
	yHSNdfo4cEDfkXUTjrLrunEm0POI0GbmHhOsPi9kEoDU4aVXl3gDsZ4OSwU26UJd
	uC7gAkAGuA9fIV7g0f61Xh3So=
Received: from localhost (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgCXUo4SuINqCOZDLA--.5364S3;
	Tue, 18 Aug 2026 09:40:35 +0800 (CST)
From: chenxin <chenxinxin@xiaomi.com>
To: sashal@kernel.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	cgroups@vger.kernel.org,
	chenxinxin@xiaomi.com,
	david@kernel.org,
	david@redhat.com,
	gregkh@linuxfoundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	jose.fernandez@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mambaxin@163.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	shakeelb@google.com,
	stable@vger.kernel.org,
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com,
	v-songbaohua@oppo.com
Subject: Re: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
Date: Tue, 18 Aug 2026 09:40:34 +0800
Message-ID: <20260818014034.2632872-1-chenxinxin@xiaomi.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260817150000.4@kernel.org>
References: <20260817150000.4@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgCXUo4SuINqCOZDLA--.5364S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jw1UKr1DuF1DKFyDCFWUtwb_yoWDXrc_u3
	9Ivrn29w1rCa1kAFWxKr90krW7KrW8W3yUArW8urnFgryrWF13XFsFgrn3Zw1kt395Xr1D
	C3sYqayrur1ftjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1DUU5UUUUU==
X-Originating-IP: [153.3.251.220]
X-CM-SenderInfo: xpdputx0lqqiywtou0bp/xtbCwhOtt2qDuBPmUgAA39
X-Stat-Signature: 7dqme3f1oejdbr1ntxyie1kwwcj3j68b
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DB76140005
X-Rspamd-Server: rspam07
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1787017265-316845
X-HE-Meta: U2FsdGVkX19IfMkML2LeHtp0GTPs9WdWi+Gbl08zGlNAbXFSdhPqX/95cRcJCpGsg9K2CtN4Fx3ZX/k4MG6JbbtwAu1Siyf/viRfffaOvA/bXdLHpZVt52ShxnZoiR40iE1P3pgJC7gKQ7vn3FjWd5Pj9TV16LYf0QWI8QR0vFqNsNyvbvfTq5XZWDfR5mOlZOdxWNNjMCeJ1xcGNvHFBvmz9EzsroJFBxRfmyTePZrj7WAKNW7k4+lmHvbrJPLNgHQS+UXh9V1/9Vg8rehKykoGzx0HTkKI3+8zL00GZ+i4IZo1zK8YUBmOWWmvx8V3HwHDP7qX7XzRjrma3WDaP85f/O058SxHk54Tlj7VVX07RUNMJv5ffHaJCD5Fb1NOoigQCV6srpivF5mIjpmDRHXym9FAhJG7zoMQn942QqYRDRw5fsNnBK4Vl0CCWv++14fj4xzVhqgdJ2+Fmk4JyWlmBJ0SG9g/XZvmQPYL0OJJVQsOBmjiG8fmbT68APcyvuuVJL17e0r+zHHK8iBb5iKHSOVXVZ/Rsevpai1oa8ZSuX/Rbug8XKyhHKWiTWgP053E4XHFpFqpBimh3BazvrSMpIWngfW/HlgqZF+qeuPgsugvlyd/G94jYw9XIzzmZtTYPp7yKpkDDKXYlwal/LneFjmS3xxitPfdvP+QJAhXC25bJYRksHZB7mupBtQK3QkaNcvsusMClXvbQlYscIbTOgfXsuPifgDwYvxgvRC5vMoKn6Wa18czWGZ6vd+624SHjGN76vo4uMrolpb+iamsCewZvpd2iSnWUSWC2h+Cx2nduxoqGdUSL9FBXZrhmMvwieaRwQAI27iAhhUt3+RpiWERQfjYArReDs/5rbL6mcHdXKPS5bilZPEBGxr5aLpzKinDTwwY8Zb37YpqZHrfRVWimyvzB0b6ClztFz+oCkvhCt11gYvlNCMK4RIMQF59UP+J9A0DYuwkWgi
 XJ66YNPE
 5VsG3rV9RYENXWpuRiSz++u0LjFwecsekDxKsOAVsUb/cKKttf8PwCsujr3cL/3m/JDMqxPX7fCVhhDCFTgr9ZNWwi7D/32RQAHZlRrYOTTsdgfviOnWj+jDCYqXUFy+0o1yz3G5giwv5H+ih7kTOc7a4tpN6FP/sotIRp/GFX1rZHlW2knMsOYgrKBDzC1uzxSE+c56KXW/d2vUxuUjI1zRharUhJrhjf1OAEStfXz/aN1Fjgm3sRMZtSTiKTUbFVo4ldkq89oX3Ecwdn0SzcyOfrKoMtIKxS7AZkK+Y5Vf5CQnnq6bCy0WOnYGnRHa6doZOmKHGAf+YZeP/fFfnwNOKy6RoERxwrNaamv2OSZ4Y6NWusq4aAeeV/YmKXnC9AkoKJz3rl55Hkf8KlgFcDHqcpnZWbXbYwDgH6SwRF+y6Mp/+p6trssVBhF0Gmb07Q6XSiCFzckLjUviQLt/8sm+Gyh+cGng9WzlYfagyN557MhCVtDod1ewvGcm67/amPz0HYmpnFsLPhbBZp2bGZlF77lzxlYEtOA40hsTEmuJ9Vs9SwBI1wIDjhIgzr5PaL9eYl0/j7317oJVFBxhDZopAB20nmbxbg6LLQeVfyE3sGFVZHbTAxcMSCX+433aIoMFHMUQrkorV6yZqZNDovN4LAsTyctkCr76ZJzL0g3iWpU5XIGHwOPkwMtpnQNuaxADj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Yes, we would like to backport this patch to the 6.6.y stable tree.
> > We have encountered the same issue on a product running the Android GKI 6.6 kernel.
>
> This is not a 6.6.y fix. The NULL deref is only reachable through the
> batching added by bea67dcc5eea ("mm: attempt to batch free swap entries
> for zap_pte_range()"), which is v6.12 and newer. 6.6.y has no
> swap_pte_batch() at all, so the exit_mmap -> zap_pte_range ->
> lookup_swap_cgroup_id path you are hitting does not exist there and the
> guard would be dead code.
> 
> Your oops is on Android GKI 6.6, which carries the batching backport
> downstream - that is the tree that should carry this fix, alongside the
> commit that makes it reachable.
> 
> -- 
> Thanks,
> Sasha

Thanks a lot for clarifying, as you noted, this commit was backported
to GKI 6.6 by Google, which is what makes the NULL deref reachable there.
I'll follow up with Google to get the fix backported onto the GKI kernel.

Thanks again for your help.

--
Thanks,
Chenxin


