Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F3A6C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E7E6B00A3; Thu, 17 Sep 2026 02:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6F16B00A4; Thu, 17 Sep 2026 02:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336FF6B00A5; Thu, 17 Sep 2026 02:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1393F6B00A3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:08:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44D051A0237
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:08:31 +0000 (UTC)
X-FDA: 85222224822.16.7C3349C
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0B1A840009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:08:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uM1ofARJ;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789625308;
	b=nePAopeH4XlL2iIkHcrXtpUx3n64RdU4opj/2EmunTZjOy+Mtf3++d7/xZ2MdpCBZtdi53
	b5UPSMW/m0J7kg5skbU+TDEJ9adqilDz/1njXVJoYniHFb0ubbhrA8s01sTmIfezqEGbPo
	dd+DwOkr7F/jle8rlMsR2ma6M9o0iSI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uM1ofARJ;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789625308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJucBStbrluE/UkSCfQnojy+iXzfLDJLO8j3Jn9U1fA=;
	b=ImcR1AHQcJ5q0PFMmQtmLJs6V1d6jfvwfOhI7xe/pxv6tfx1+lk3mhMpwlPxtjpzQ6jycQ
	s8xePoA2YqbehjxrvQ2M6K+HSJEFLAhOP38sS+CCMaUyKIRPmQetFMAiXTkECB2z88uLdD
	Z/CYxrrtfK9+CwVW2ghR7aus9MOMx88=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ElFJqSc+70lL1/cQRQceNiS69ssSlpSJfebxt7yM0jk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789625303; v=1; x=1790230103;
 b=uM1ofARJhQpH3pstizTba6PiCYLqihbk5UGbAQudPaISrrlyS4p+uEdHbnApIwEfpskJvNQ2
 1Sub5infXZsXtwY+bdFgYNaoZj7UtcXsksZUjJgZg147h+BIJUWYh6HAHeOtPxS0O0gJURHwqWm
 HlFD8tUYhGnSR15RWZ8b/vhY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3f0bbeab4455297c;
	Thu, 17 Sep 2026 06:08:23 +0000
X-Mizu-Trace-ID: 3f0bbeab4455297c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] mm/hugetlb_cgroup: move per-node usage on cgroup
 reparenting
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260916-for-hugetlb-charge-v1-2-70fb708b2e4a@kylinos.cn>
Date: Thu, 17 Sep 2026 14:08:01 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kees Cook <kees@kernel.org>,
 Colin Ian King <colin.i.king@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Mina Almasry <almasrymina@google.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <595A571A-C790-4AAA-BA11-F95D44BB063D@linux.dev>
References: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
 <20260916-for-hugetlb-charge-v1-2-70fb708b2e4a@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B1A840009
X-Stat-Signature: cquwiwr64h71pk47m7bd8sc7fdos5hf9
X-Rspam-User: 
X-HE-Tag: 1789625307-87270
X-HE-Meta: U2FsdGVkX19c4a9DRO5dsxrgWGHRdhYIrkpupUQSMsCrtBsIL0aM9SeMyCQTDuqB1UKpmL6lWJrwD6H9vDrX6vrS2iJ4EGDdPZR3OKKaq3bNctQN6I6BLjDGVwOtxTXa7y6M+Ui8hQMu9iJK57pAA9chWclyoy+hPr9UepVRGCXb7nm7+TqENBDiS7GjAkvI39ap2e19sM//ltWsMleuKAJTa3idU3p+PJ8GGsClMIdxU2UyuJcb+9LZjTr2WtB0VOurXCgN6JBXe3M0zFyTsexnMasdMS64c28OJWPTp393pdtIOSLVVusG9Hx2azfUigL0zRMKLt49ZBTtWPqLvaU+g3x6TKk8u6zO4b2VXKhE3ANBqVSMOjaTLQlh5vesn3TEjG/AV3bvcoyCVTDluyhe3sGpdHe5EeK6F1CUg1drYnJQJz6B0mE26+IbRAeJOgS+dMIkXXTmNo1BiP6aeOwL7iFSC+udYWxI6hEvHvbOzeKrW/r1Od5jJpovZqEfW2zZQLyKHwMkb8aKpkV5wMxrxRu51osBSn6juZ+f1qAR2e77WtaNWpH8sp4sLY9Pv4YXlJDz6dbxH1fKRwBFT48G5ZgKWbLYWxZwm8CkErYsuJbG34eLhQzQpYDGTgeS3HPPUUutcgr5N3kXZl8qjUUKPX+Caa6EN3bTgyrCRRCLEbFdxvkVRM3PYe/QO3ni5wOGyyRAo6LmBR3w2vsGq0A3KDnwDkchoARSTEgL8AdXkABipfLz4208TwZFmjyv97RN/4vVYSJLph1B4sCPjEsvrlCLL6/RBnGew7vLmBYRWPWS75nHSaPWN6u5fQBYrCR4MlpiUVaGVj759HwLoLsVTXZ9g3iwkOhkRDJPlhsAUHLXUm9IdOenbNu0zv2Bvcv2+LXT6aLNmWNns5lXUFkpyfefxCy7F8dOwGgZxv7x5ODfVxUp3pUHUKzRNoginQ5+0aqhqh2BL+DbxwF
 5tLr8qGB
 dYYdeFFRAgVj+wmYojLKAG+9eluzHnIfiIZ4bTxABXqSL+LFnQrSrFx/QSZ+G4tRhQDbWeoMoq4SuX39Cz5qRQvnISDAuJcpB1rRPaKr5Yj9q3Y+eghJszcBc6QidRluFTaO1nB3ihLaaSSSUxr+khh2tIBsuMpl0ds3b/flvD9z+vuW08fcK81l4hcBnY7CwgzN+h7WM9uZhR1hJQswzOONwSyg7kgL1yaMg8akMkJH+WK8kXzqB+Mb30KlCX0+aRNjQMwPZinduEeKDUE9/oxqXa2Y4G5BkLXmozouO0CB7ozBi4SslZuE/4H1UZyKa9rRLzvbAEeqwSuz3LaxztEpTJ9CSDOqQdhX4GJHtmkMpxIWbIqk1RuEk/BFswPCEnrmIz42OfA2Yyw6niYSdBTuwiNDXtBvGTCE3iFHNwRXmbN+WWQoGCpYkZcirffQNKlLa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 16:30, Hongfu Li <hongfu.li@linux.dev> wrote:
> 
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> hugetlb_cgroup_css_offline() hands the folios of a dying cgroup over to
> its parent with hugetlb_cgroup_move_parent(), which moves the page_counter
> charges and the hugetlb_cgroup pointer of the folio but not its per-node
> usage.  The parent's hugetlb.<size>.numa_stat is short by that usage while
> they are charged, and underflows once they are freed, exposing incorrect
> per-node usage values to userspace.
> 
> Move the per-node usage to the parent as well.  The folios keep their node
> here, so only the cgroup which holds the usage changes.
> 
> Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>



