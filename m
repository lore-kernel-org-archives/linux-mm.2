Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F1CCA1013
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 08:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D318E0003; Sun,  7 Sep 2025 04:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9E48E0001; Sun,  7 Sep 2025 04:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8EB8E0003; Sun,  7 Sep 2025 04:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 152258E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 04:19:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B3D5BB015
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 08:19:57 +0000 (UTC)
X-FDA: 83861756034.11.A23980D
Received: from mail3-162.sinamail.sina.com.cn (mail3-162.sinamail.sina.com.cn [202.108.3.162])
	by imf11.hostedemail.com (Postfix) with ESMTP id A059240007
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 08:19:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=gmfgySfA;
	spf=pass (imf11.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.162 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757233195; a=rsa-sha256;
	cv=none;
	b=4Jgf5FmjwHuvj/LFjX9EWlwDHNlgAVGfkavApMuyDC/Xu7FFz2v2AproZiBkG7d/VHUcrl
	99uc4m36KxGqRcZ4x1Xi4JMmhRH1nYGmURuAYz/o9fRTRy8/ZWPmUz7nkD+XwcGeiXvYqC
	VfvjcoTNoLHlEoLzREeu1QvjTerhdao=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=gmfgySfA;
	spf=pass (imf11.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.162 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757233195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8vKqjFQuknmoEO1oFEDcCTzvjF6WGIiOaE+9yTEBtE=;
	b=ZY0q5d0ubgLWmIX9yfrQIgNnFi7/wjG19DgI7uQB5mwLfxlqOTSpNEFZ42l5Dp2TAx7Ara
	1Vnr/5appOJ1IZexu2QwvjjxO4CqL2Su/eaRaY8J2U+STJvMGwO3A+N+JKm4kos72+dWUY
	Rl35WrHPBK+41bM6QYqafKD7ZzU1lc4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1757233195;
	bh=n8vKqjFQuknmoEO1oFEDcCTzvjF6WGIiOaE+9yTEBtE=;
	h=From:Subject:Date:Message-ID;
	b=gmfgySfAicTEcZ05C+hN/uwKLQorPvCUwC09SJY7QB8u3RUdRjuf4br40pd2BZr7R
	 TqJqwie0YIxzyo8jLSTn2ahnQc9lLF3aMj6n8cMO/LcNwRGTO3ajls1izJsbn8WdUp
	 PTrICghN3Id/Wx8BgBvxm+i3XqlkXS/Ibh6o/nc0=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.34) with ESMTP
	id 68BD402300007646; Sun, 7 Sep 2025 16:19:49 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 5451956292061
X-SMAIL-UIID: 179DE4EA08734E75B9EC59BE00C9F239-20250907-161949-1
From: Hillf Danton <hdanton@sina.com>
To: syzbot <syzbot+b253ade8e1751d90a7a9@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [block?] general protection fault in bio_iov_iter_get_pages
Date: Sun,  7 Sep 2025 16:19:36 +0800
Message-ID: <20250907081937.6583-1-hdanton@sina.com>
In-Reply-To: <68bd3027.050a0220.192772.01cc.GAE@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A059240007
X-Stat-Signature: izxcs33qpwwfjc9tcogu3ibjyttd9woe
X-Rspam-User: 
X-HE-Tag: 1757233194-955160
X-HE-Meta: U2FsdGVkX1+223Vcvnu5f5ErLxRs8G+hPjxL6u5iIAmVqI9g7gTeUgPlCqS+HI52EYrw39HQJ1txfEHY1/gNtt4O2iH08VrtW7ondwBAuk9FD0FjrgzwrzwdjVv/Pzac1sdXA1+NVGQeqK6h+YH72m6B5tg5lftM/gzQMC826RUiVIq8l8i4oKfHdzFIkBRDKMetxn0PAj/0YTQZEYEzmV0YNX1XHC/doj8FzudSwL7QiI10wRhlbJAYavBqfDyuc9hh4TqOCJlJB7WkazYcDoaCIpDk0Pl/f/PAnTncxqgAR/E9UmN9gAE3nJbGbX9L89VqYxe+yl7NuvqazHthKyeDw7PK2r7h+VZjlN7DcFubiv39zqMoDSEr+OmUvQTvn+jOA+OkpMyHV55vdCvCFlapuC6Puy6EOnmXxh9nZWPig15Zc9S0r78rRSPl9RGOm4gKPN742ZTRJp33AfvZxpjAfW/QgkbuJFpQDJ3a2kvYLeuY6CYPUrEUkK8PUin1B4OojNl64Um80bCI+evi2UeJLKbEJF7WZnC8X8ftMFYGzeuhXL9zt+AWzg4fAWSjyPl24lObUl3UWe0i/esLYthjyLeLjbV5xnA61vDeGh+J7KvL2IJ591dRuGaI/fCntOsOlUleGuPJDmWdc0/XJ8REsjOczvJIT9t+3rgANktfUzsIh3iVCTTzQJprxUDlguVVo96h+p/A1FOate/vGzc7/EgGN+oVrGPFtsFkjJvEWTS0eaMTWu9+yIdrqp8TQRIHLHLm0o1Ye6Eq9I0AVSMdMNCv05QWZu0h9PhQ0PGAwpTRZN7f4ErZmFmJgVNEHdlqyZnodBPj+pE5VTB/Y9oycXd1tuqqoAmCfiLhyYeBSauxtNJt+FRu4x0fUA911/4QRsmizkgyg2FjEGPqpudw6FgZqsODsAimcjoGoOnlAonB1lN+CMncySWDz5setTqduY87nwrokw/uLbb
 oliNdz+a
 yx5A5D+Lsd8gxek59R1frKYLYc7yQ1jnfYlRILwlYhzt0YbSw2LdpQwV8OQOj6sUVaBG61iT9eMjwFvkb7MG59HOEe3ctQjmOdPcqtMnF3iiZIAKWqNZ54mo0ZXLuTRFgv0+Kb0HWcF2l0O3cFwEG41WyLGwXm3eZ0+OnBAkFSzV2mEvwQNUG+wfw8SPqT1oSUrapFo68hGEFndCTYw6ikC9eX8rq+o/m5h+T7SvrV0T3TYpZK8UVSDOd2lyJ8QjuSzv7M7SRn4KTqQjM1W8wkk4E4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Date: Sun, 07 Sep 2025 00:11:35 -0700	[thread overview]
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    be5d4872e528 Add linux-next specific files for 20250905
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=17896962580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a726684450a7d788
> dashboard link: https://syzkaller.appspot.com/bug?extid=b253ade8e1751d90a7a9
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10496962580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a98962580000

#syz test

--- x/mm/gup.c
+++ y/mm/gup.c
@@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 		return 0;
 	}
 
+	pages += *nr;
 	*nr += refs;
 	for (; refs; refs--)
 		*(pages++) = page++;
@@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig,
 		return 0;
 	}
 
+	pages += *nr;
 	*nr += refs;
 	for (; refs; refs--)
 		*(pages++) = page++;
--

