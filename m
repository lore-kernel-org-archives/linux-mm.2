Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C3FCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE90C8E0012; Wed, 15 Oct 2025 05:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C993C8E0002; Wed, 15 Oct 2025 05:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B895E8E0012; Wed, 15 Oct 2025 05:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A292C8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:30:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 41F6F1A0B83
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:30:44 +0000 (UTC)
X-FDA: 83999828808.22.B4AFB96
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 773F34000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:30:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aUWFVO8t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760520642; a=rsa-sha256;
	cv=none;
	b=eURe0/4rmuWmxfHWOeCqLnczZolFTUuBYahLOONk2Js/1vS8P5JUF63MEOvIJ+oeHtRmCk
	k/fAsRuE7YTOUdCPO8wsAGu6ht5rNnX+M6K1UYMzGjdmsj0ELhy+qsrHY/BDWVXi0QYitQ
	l0OEJOJH3gkw+n9c1yOtjAtFE3EDglc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aUWFVO8t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760520642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XDtXgZFzYXZK/ibRrp5PX9uMJOOke03pAz5gDdS9N8M=;
	b=U8/Xsr//QSM9MXp7UwO2ZjD1LyAjIh7Gr46oYT8mmk5iBU8sk0Fz/hEbYU2KxK7kD+Vs+g
	NCgTMhFCmzy9awP1NC+dv6Oczv0Nn3ha2MwSPzUOBpGxGW55z2ST5re/rTb6z+SF9mk7b8
	fnDT5sFN/CnNhesx22rgAh2ZKQiF9QY=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b5579235200so4007869a12.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760520641; x=1761125441; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XDtXgZFzYXZK/ibRrp5PX9uMJOOke03pAz5gDdS9N8M=;
        b=aUWFVO8tWioIgth0pfXinTDRiBO4HIui6DqBKFy/ZAgxnL/mtLcxXjJr6NvDZTa298
         LpdCVy/gAvQbrttE9oHTV2LBNWrxGuoHrxiB8FmQvMlS1Zzyqsa3OXouH7Wy73qizHy+
         E/NZXXOXEguAvv5PxlYxyzLRQ1Ds1n9p+XAHE2JlookrVqggTw48nuzPvQZtSnHTOZD1
         l54buM/2I/ULC3pJX38miglflcl6E5Vrr3/111qlcANlqTRNXV8t2/6Ev93571BXVGIU
         H/uIsnVYsIx8OTOyqnP8gIOYWApCs5T1/Jij3seDv4Come+1FBy1B2OizcctxCQphMXe
         6Haw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760520641; x=1761125441;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XDtXgZFzYXZK/ibRrp5PX9uMJOOke03pAz5gDdS9N8M=;
        b=tTovElsNEHg0MywhQhO+vTiZUNeP4XDfpACfs/ij9JOEBRHUXaaEJo76d0rdkupYbD
         D9LT4O4ppAS2JP0qUszBvVjKv+kQDiAc9KPS5KO9FfQwmggFM5hu0lXAxtzTZCBS5535
         hDqVovKmWXn8nA/ZRuS+73nWCtSNanIU2qpRx5uwgtxs7PlN+xf8Gmh6B5P1Tl5yJUOV
         1hqrmKaUg6uU1c94Hv9s3qIbjQW6lGH+lc2daWbG1Of6oT3DxqYZ51tuQc+7SFPhklwd
         3ZrBu9nSfDo1BwScCA4yPVl5dxy0iMsjTosmDV0QiDFHDyQk1yLQF+u+SKWX/ne2CIVs
         Q9kQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbnRUrDbBHAY83wGvwMWuQE95IUFdzE4BWOMFkALZpfqErqMCV5T52Eie2tEReLvIW8kSloFlmaA==@kvack.org
X-Gm-Message-State: AOJu0YzfUqdRYfjhMYQA5c1JqQSN5IS8334I8kNNAJK6i4JudPqFwZpn
	sZrHHhL3B9jQZ2ULqVzF8AcClIIw7rgVLHpU+aGh5+xCFD51Iy6Q0tQ2
X-Gm-Gg: ASbGncvtOJeMOWTj1uKbjh6CKfX6rO2ud6zPoKVCjAfU5oKO9fHeX8pfrmM+qSz6tZe
	83HigPN7rZcg4dX8eHdviAl4/uJJPZ362sC+kEuRlir8xaBgxNPf3hxv2hv6Qn5o/KenIyG0R8z
	TztxwA6bhivI/FUh5DXiVUbZVhBGTa9ZJYCLeE/ndOqxdkXAOv7m0VAVXujz+6s0tWa0j3RmyWj
	bnc2ILZc9ka/WrB3HTl4uclbj5z4SmE4e9LgmesPA7ezspbhPZjfPcbo2ct+QKZE4H0AQc92m24
	okLp2a1LZmxOnWtIQgifbZ4nJFeFIDEMBIqT0LpqHLN8uRCMkV8v+puUcbq2jgjV/NrBcSyshcb
	UVwNa//fnXEEcJDzpVs6iEzSbeQwrwBTeWUALX3411mHnbfw7pAqFSuNkz3Ii2iBFe23umdaidX
	/b4fucFrnYjszZNw==
X-Google-Smtp-Source: AGHT+IEK9gGd4ylhL+ohQ0j4ij/MvWMWaktFv9kBT3L4nH8VbW7kaaXONU81DrtfDoVueDQoE/cLTg==
X-Received: by 2002:a17:903:3c4f:b0:25c:5bda:53a8 with SMTP id d9443c01a7336-290272b5529mr333496115ad.37.1760520641158;
        Wed, 15 Oct 2025 02:30:41 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:1896:1396:9404:1b8d:6e77:8dd])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b678df2360dsm14730127a12.25.2025.10.15.02.30.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 02:30:40 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Rik van Riel <riel@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wang lian <lianux.mm@gmail.com>
Subject: [PATCH V2] mm/khugepaged: fix comment for default scan sleep duration
Date: Wed, 15 Oct 2025 17:29:57 +0800
Message-ID: <20251015092957.37432-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4n18t7dtzzhwmeo8r6dirrxhw78xegbf
X-Rspamd-Queue-Id: 773F34000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760520642-799382
X-HE-Meta: U2FsdGVkX189XI/5fHGE+uDMEpycWM289G5umkAkTHz+8lspEM94sFP0q8uE9X+ahhD2vxiCciNoWw9Semk3YKYeG1huYkBtpmMUOYKa5rfdzGI/OGwWZi45byQWFFhe3XwhRKVNf56Os94OiaReYVNDNc5i9NrMJuMfprHiItIAbcZBVMYJ3GYnVg8VmqhQJ61zoD5hrXfPZGh900C8fOEev7VBEwJABpWRYnwRlk9CosxWUxoIiVxQ4WQFHF4HVImcrdL+SmYnaPLJf66NoYJobQ8SpGdmKlzkQ7bJZbqYRulMsBq4p3WPvAamL/fFNjqcQKDfo+Y7SBh6AB2KBPyCSFy76AxMKCBNuwtW9HSPEJMOmXnUJt0zxOm5wKQBumgfK86tRpYHAEpn1/82Dbi2g9btA/RyjW5fL8Hn9B6TTFyRTmfQb+8h5nLegbMMhaxaxnPZkha2dP2Z7+yqXqCb78KHZ1/j8XAShZIe8VH/ysvOZIsVh4SXQKY/1+NkR5vUcUowORtcu0JtsU+EocloYc6kjeEOWuO+vMGgJZtZOrYBpxEfC9vyILlBiOWl2oRgT0Gc819iTTkmUMY2nb9gHPBIrO3h4ozVtWux0umqQXLwxeqYflkIxDvlAZisH7SajyCaFyiwj5XwL9Oj+Et1k5yfPmUsI1S7GOvYzeEwfBqsCcEd1XcervVM867QBMqV4D8V+p1DxvVa14ezWMXDpur8b2Fdfxa7DtH3F8e/g2qH1B08lpvhlvwzXDM4orn/TCl8E1BBDR8OUgWz7YQURsC18mfyY5gX6Z8mHMSK+rcj7/WfraKbuaD04ni4A7OkvzlucwKNiu5dItp3AS6jDZCODKRRvcnQMgVQkRZaqFbaGlgOkMJkfUtE/Lw87csorxqpM3yJ7ImVSeQpz9aJNbIfFRl1abbY5aoHFo/f/ZgWEU5/AePOUqNMH7IXa8U+ilu8lw4LHhxzRgO
 5r6riMcS
 ubc9qmMpGN/40D/ktKvD3kirMDRLB/cpGRpBoqWo4hrOyk/Ma3C/xGo6o0Diqh0tMTeDBKwSp5nJhepAM3KCh7PTx+U1TzBZUeEpsAP/x+54ZZS+DBs2wuRQusQqty9eD7gMG4/ime7HC1hq90w6hWvntkdVJeybHNxEnXas/GnerokcZ0sZ8YypOTqVrX+vyR1XQPyo+7mxAfOG0gsMgPh+upmpqdPahyDxNWDzxeL7eXCKjsMlNryxaBRO/I1Lez6/1tLt+UiFrZzM7QI9lFnH+/JfajaaKRkLUUh9sKkr3yJGytwPWezL6apU6Z4LAjGAfgLKnjEiirAPX+YAFG+c++U+6PRcS6ULDwRLN51SOMmh53ftIi1G0OeLgvW35amhi3KwMJzXiUmtxJm/QU16JbaG4bfd0BI1UX6kzM76C8lyiAS4Jl5b4E32bG9FYXT+FhWX+l+muHzff4Ydxees+JnBS9pVgwIKThIK+6QsXoWZEkz6Z87HoReztq6XfwhzMAN1NdTlTdEr7yzSazMsIkkkwbfHRgbAZP9lbko5O8UKcSPjEOU4AdPT5b8ypD8pkTI/C/Y/jhgMRcf3C7KcubTdAEfLgdrnWuDTDfpENWgJ1qtsiN5rFu7ha67uJNNJ8dJhb02gscoU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment for khugepaged_scan_sleep_millisecs incorrectly states
the default scan period is 30 seconds. The actual default value in the
code is 10000ms (10 seconds).

This patch corrects the comment to match the code, preventing potential
confusion. The incorrect comment has existed since the feature was
first introduced.

Fixes: ba76149f47d8 ("thp: khugepaged")

Signed-off-by: wang lian <lianux.mm@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e947b96e1443..d635d821f611 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -67,7 +67,7 @@ enum scan_result {
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 
-/* default scan 8*512 pte (or vmas) every 30 second */
+/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
 static unsigned int khugepaged_full_scans;
-- 
2.50.1 (Apple Git-155)


