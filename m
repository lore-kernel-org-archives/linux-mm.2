Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F265FF885C
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 10:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069016B0005; Sun, 26 Apr 2026 06:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A076B008A; Sun, 26 Apr 2026 06:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72426B008C; Sun, 26 Apr 2026 06:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D62186B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:49:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CB211B89B4
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:49:43 +0000 (UTC)
X-FDA: 84700386246.24.A270973
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4F6A0180004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:49:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FCWhKPr+;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777200581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajDY3kCUWUjj1xfsi9X6I95j2f9yaGXagZjSXs2416M=;
	b=ClFgi+fI/f+qmWkMC4fETcMy+Iq72vrBWv1VuBamrEryiyNqM4JK6BVOLSKOtmUHS1Ijhy
	AVZnEuEAWqp1TMgtz9ZneHvpzn5Nxy5pt3s+Esyqb0YTG9Mh1SDXeq1nRNaELluRoB08ht
	+T54tr77dstUcofFl0tFHjwHGNGigyM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FCWhKPr+;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777200581; a=rsa-sha256;
	cv=none;
	b=BHRCHF/fEOmcvYJg+ofIOdd2EB85Ce5MEMI1n3rRU6J0RljS7QvzbQkgKVzwZM65IMDjZ2
	y8uAQqxl80JS+nRsiwFDTqfl0YsUta+Y7SXk+yaPKyifN3OpW+PbJJrrs2EoDr+Nrg1fVy
	2fXXL5nKBe/GPLsxhMlIyxhTDPz18gY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10D6541AEE;
	Sun, 26 Apr 2026 10:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9261BC2BCAF;
	Sun, 26 Apr 2026 10:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777200579;
	bh=L1nbLO0Xj7/K8G+R19OFJ/yJuZU2dwzW1RcyM4ouWPU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FCWhKPr+x/+OaHV3MpHuliUX7bbExsb2uYJYnKRtVWVy4rl0Nv8eVMX24Xbq19L9o
	 AAnb3kFvhj2UigzwT9nWAugGbRwWKuiAwz8lsknVS1eItkpd3oFKo9YG6WSsTdAM7L
	 FZI2jBVtYW1kqjslfJJtvI+qEGwq5SjujJ4ofF4o=
Date: Sun, 26 Apr 2026 03:49:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, shakeel.butt@linux.dev,
 surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng
 <zhengqi.arch@bytedance.com>
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in do_wp_page
Message-Id: <20260426034938.db29d74982a8eb8463f8cf3a@linux-foundation.org>
In-Reply-To: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
References: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F6A0180004
X-Stat-Signature: yf7xqryqajyntejy9r44t7bfwipm8rum
X-HE-Tag: 1777200581-786939
X-HE-Meta: U2FsdGVkX1/Iup8hgd/BL1Nmxnq9x8dORIK0LRb1Qj+C+i/n3KIMC9yiwLtI6UMkRhN25dq7U3QeA0qTLJaO79bw34+aQiSK5srCme0UAXlf6UgvghBUPR+918zmcMhw+4qAIo1lL/i2eLHuXAsIr5Zu4Jps0G+9N4LyS3wg8ioEEeWzgwx1TDZ+Va7HmOU+3sMyf85aAYYohouf+ojvZfFhNrUiyPEfL4qpHZ28xFfQJOMhnmi46QPFR1rIBcAStFK+9Ej5qLxO4WGeZikW3KvU3nRaUgpJBUQBKfvIvays8zhBhGvzRtbdg5NFph0gmMy9m0gD+Fcc/OJNHnrfVrIjpYfclJk2iGUfdqkEAU2nLSllc0iYMkDWB0ZKvLlZGb5EzEoNUyuu64JYRTPyGWZZvfVaBOUN3AQKlglICvgzZ3vbKDFIVl6uhlouq0+o+UePWU81tVyAL4ifGyBx7GUg6r75n/2zKdQRK14AHG9ugaeBkjWEiTk4+e7Z3CV7BuF3/OC7sKOZ0Q1GqWnNlIisU5Rqa5r5Qdf9xEZ4W6alt2WaboqnjLk7rK9PMXS+WTz6sQnT/WngkYnREDn5vk9AtcEjRvnPPRL+NH1FrkSsHut7Rtltw69nEZowKplr/JPDUop5QCZrME78xgb8cd6ofyqgQjx0aER5e5ngNVnD83ScUd9lAv8Qt/JbPSnQuQyL9WQ4SaEg9dmYf/vGry27ATkCS2el9wYTefU4iLpqBQQ211+Jm9B7Ns+hNpmxlWBSH3drfGO3JoZ0mYrzq9l6VU6xvAwYkVkSBGP6HbTmgYpHla61rTrS1k6YTTNiy1Kty3LLbGh4plJUJkOc7t+Z5v2vmlovw4AY+6RCUA4GVUeT08b28aTJPmuWG/WWfwSlzskuTDvgxNL+qmv0eqtmPSoSNiKcx3XZL91ztE59SID+C9d9UGx64WhHVFtPKTFfssW+lE9mJnUX7hU
 RNumpOF6
 eZysYO3JUyk2pah1YoTsKmAYTzmOrY9B0dyvLG2WWWhonV5n7hHTQ1dEOz+hTa+TAkf3djqMVHk68/Je55KIvdUOISFeaymuknr3TMx8oNjyK2UWFTy+YtC8K0Djw7oR63R9cV8QjAF9b8kReI00vf6DPRp9yGeDJz/AZX6PYADIOh4yaPNlO7dluL7KaJA8446SxYYHPpdIL4HfkwpXBUwNyd6puYco85jQk0IywvlK48hey2en5feaRLn+3rCe3TzECHGiEmrUJ9bbyFHZ6WTK45iOnEOE0Bd4BOXjN8YOdBnqK032HA8UexstynXZZVNd90uUhlC2Lu3UopTo1DpJAspFYDHsIBxyKWY8v6xi72PxQIgY3+FGyQihM2ek7u2CQoZ0MIL3Vb6fESR7UO+RS1RzC/HgsAJ5I7tNQrSIGfH2xIwJkV0TH02z/kT0MEqxaiOPFFRJkNp3skXz3t2xm1Bg9NAnM9ALQPiWo4r7+QevvdV3o8uE0kIwiIrd8ySfvq7ON2xER20vckXy1CDR6upy7SeHiByVKOUdUoan1taiTI9NjAW4qlWbgqg4DMBCWJSVgq3wzvHmvuTM2MWn22prxstqPJulKTWk7Hcy4/1zV449AG7oY0jbM3YIpwrah0D3V2u3SenNCQ9Ri7Ge+8pNH07coGQ5AmD1sM7VxGl0SmCKBhCe1Zm9N/qxpTHemrvT6Yf7dW04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 01:17:25 -0700 syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6596a02b2078 Merge tag 'drm-next-2026-04-22' of https://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12483702580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=24c8da4692f901cb
> dashboard link: https://syzkaller.appspot.com/bug?extid=7d60b33a8a546263da7c
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.

argh, that dreaded sentence.

Thanks.

Something's definitely amiss.  This is at least the fifth report of
rcu_read_lock() imbalance post-7.0.  Others:

https://lore.kernel.org/69eab803.a00a0220.17a17.004a.GAE@google.com
https://lore.kernel.org/69eab803.a00a0220.17a17.004b.GAE@google.com
https://lore.kernel.org/69eafb0e.a00a0220.9259.0031.GAE@google.com
https://lore.kernel.org/69ebcbe2.a00a0220.7773.0005.GAE@google.com

In some cases we released it too often, in other cases we failed to
release it.

The first one is slightly more useful in that it tells us that the
not-released rcu_read_lock() was taken in folio_lruvec_lock_irqsave().

Muchun & Qi: you played with that rcu locking in 31b54a5e8916.  Can you
please double-check that we didn't miss something?

