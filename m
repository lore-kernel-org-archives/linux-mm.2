Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B50C5CFD9
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 10:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA6C6B0093; Tue, 11 Aug 2026 06:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1E96B0095; Tue, 11 Aug 2026 06:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C87E6B0096; Tue, 11 Aug 2026 06:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33B336B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:18:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80E418037B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:18:50 +0000 (UTC)
X-FDA: 85088590020.09.7AC37F2
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id B3DDB20005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:18:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rAlSDqY9;
	spf=pass (imf31.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786443528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxZo8B7n4c14lfP0ZG1amHyFP5yaEQUN0LvXnBt5yBg=;
	b=rF6t8n46b1aPBDPNWkZ3MlpR+8UvpVW8D6xH3SZjhI6sQ0rHeCSFwcCMwzevRHy+aLrY42
	v77fNzyR5EeFxJy5kahACwExQlEAGt+blGOdmNwh7HNuc5zUZ+nqyTzCsPSzHjRnxwSEeF
	VLyRY88qjdYPAq396CGm7/7lxNkdnuo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786443528;
	b=0KetBzhC0cyFzI4D8835Q6z55ZLxcuv4yrViLc8Tfjar1moiMT0JAmO83SmHhT0UM6wD2D
	i7BbW4U7ip2Jpypo5/vBA+FKajWA5ylBWTJPHmwxgltwxJauE34jCSSOgZsjXZzMd4RjBl
	nPwhSegnreJKGfjM9ZQZtHmvZYF2RMs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rAlSDqY9;
	spf=pass (imf31.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-384930ca5e2so3056392a91.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786443527; x=1787048327; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JxZo8B7n4c14lfP0ZG1amHyFP5yaEQUN0LvXnBt5yBg=;
        b=rAlSDqY9HcsdCVJMg+Otwe0B74FWgIwfTocCYgPj4YKTTDKP79HyqN0TcxtkAy+6w3
         VNggM79mOgxTY4BN/Fb7lJ/j1Aa2pSTeahWjFGrYuFUVChfqGRvMDVR7dsgrugchnST0
         qDdXu0Q/kOOJAX4C4MHzWJe0PD7uWi772vcAV7OXmk7R37kNaqILklFsasZzzoB4tXov
         grnIDcSQJkF0DmPHq8LKks6lfsF2PZwxE/CyBeafI6n2d+0lsC0cmzFtR15W8eu3/yYU
         7iWiU587iwLsCg8FkT64iuvUal2RA2HMDIdu2AOEBYWJtDSl6WeLZvEw3KFzd7DLuQmM
         KUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786443527; x=1787048327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JxZo8B7n4c14lfP0ZG1amHyFP5yaEQUN0LvXnBt5yBg=;
        b=OxHPJGtULZvEiWpPUalgedNhT6xKGyb5STEzDn/M697lW5dw4vWKihBCePem5jYoHD
         ZJX/tml8HuAf3YHGsxhyYSlwzz//C5/axCOBlfoM+3l8yoOYKnnxq/nbX/eU8ahJSNLS
         f+/M4dJLlUubhI3LT8OhWsVeH3gn3cuVS6tzr8goJadkHoCLCU1JXA9LXIxLxfbs0Edp
         8hpxc1WYX2qmiKzDXfaEt+PhtYPui7BXIT39STiXuPjWLa0UbvwFphqdvXwWj3rQ/fzK
         TB+BWatVDhJU9eOhGlGm0oWjNL1Rm7zodtmf6fngC7CPfzogaKpwOMbWdtuRoNgehOtZ
         FZAg==
X-Forwarded-Encrypted: i=1; AHgh+RoSNd9CzFomnLUzNxZ07C0EOqeswb9RXZpRa6p7KUKQEXzzjT9ihvHSi3047+D6Qn6Sf6Tbi2fn9A==@kvack.org
X-Gm-Message-State: AOJu0Yy+4CykO9AQ1wUR7KOi+MU0+tP0ZAgsDndYk3nfwHg5LsxUtf22
	UxoZXS+0hRcQCaeiJ4SqK5GG+HrrNfHJ75lKYKQlCBzhmKshSNc29g6z
X-Gm-Gg: AR+sD10nEIjDzido1F9vOPeIJerNEXMw/r07OhjG+2fgdTxyLBMqqMjN9foLwgq4Vgy
	Y6+snsoNUzIBtXQA6uljZt92COygshCwvd41bjKcj43aflcs10V5B96MV0BCUKVgrHsPJiFlebB
	uQFCUCuz8e8/luxAb6onQB4uGyekoAANK5LNnVJ3hX+dIGL5kxZKPGhN+N5JvL/aO+PR6/Td/Zl
	XXM2qUMtHXs4XOMy7jKr6hLsvGdZVEPKgigIf0Cg6WoGtBJaklI2rsZK5Dkk7mKtkYQMSPMsizp
	6auLU3gjSyN3VgV8dlXhRBaIAGhpwetbOeFeZU7VVg31CKEYH2IBfE2F1A1eeDpkk1kCo1i3jx7
	QovUvN2odHxaEjxzLRWjjx9qPKuIi1KP7Cg7G1rJHvAI46HFE6EMk4+tSlkDsLS03NpgTH3bJMa
	R925VzqJw9z3Xqo9kvOHKXGuPb6ksqCXkRR+j8wVT9o2ZgTKHY2VII5hqMlbXq0Tc=
X-Received: by 2002:a17:90b:3fc8:b0:38e:5964:97a8 with SMTP id 98e67ed59e1d1-392ec629e24mr2228780a91.16.1786443527572;
        Tue, 11 Aug 2026 03:18:47 -0700 (PDT)
Received: from celestia ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1412042dd37sm3752328c88.11.2026.08.11.03.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 03:18:47 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 2/3] docs/mm/damon/design: difference between watermarks and nr_snapshots
Date: Tue, 11 Aug 2026 18:18:40 +0800
Message-ID: <20260811101841.804596-3-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811101841.804596-1-aethernet65535@gmail.com>
References: <20260811101841.804596-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B3DDB20005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yh7g7xinq1mxqa5hk43etsg8rmg7fxt6
X-HE-Tag: 1786443528-641620
X-HE-Meta: U2FsdGVkX189IzBp4budtR6YWeBNlBWTN64vpk07H39f2N2BKWyjfw0ADpeptH1zehnWe2xXRHZNlaAfplOXb43inDddvXvytFUg7zwlGYWpZt1LOMqxSl/uFDlYbKhUQ91hNfTYvi6T1w7uT3v7b6KjJemguqXa7gDGcVcaMEXMH/aWbnNkQCeTyXYUgi/FAakCTb/lIFqDqWoOSjqxLj0MUI9o+wWSHmcPxWDjDAWrddaK76i19iGvlNOXlr5eXYqHJpfwgU1m34dR7mgqg4ft5jUJYtJoR7xuLexWkpH9rs3ihyASli5LoNkfYY7hTgyjFKhWXVrFFTtjsQC4yW9/Iwc7ffqeLlXeQDrUYKXSLBhRcCDQIFuYqlvsy8Avu0j4CrOCO43ReaSTME3Pj0LZdlW8KicKu2my6dSl3wQ8voABKBnmcJ3zOhLwCo9jrwCGE3nN0bt850QMf74D+DuAZAI9utovZUEqOA+q/qoeif/f3kmx3gJ382r9UBZtp+FBHL1k7CT7bY8icnwHTOE2/4+vtPlkZ+R6rZ9dVolTYiX1IdZ9+1ivjlOKbzU/a59RfZGY9V8ITW5yEKoYueIjqhVZ+zzMGpomiXIN2Qf34k3JE2ar2rQ1JIs5ax6Z5ZdHI6HRrZh10W65eeGQ7BGsV+yv1e47ShbkJG79ftcvW3I8twmbQCvJklTBpDJQmYZDe/cRbt6AHhpQOPEn0Q8lggPxzMbJ56vnZqZn5bXDl/IbKduCtoJfoS0ObhafGUEsSJyj8fZ07amPqNMugDNP5vbtaT4fwf9OXLTubNzL6DKv9LOpHD7j403UA5rkRuD2S2ysU0yCxMeEXmaS8l4wyePp6Z29BQJNgywjz92l5D8T8lIg1jWkffTAJZ1J9yNGf8ZhbgnYZXvhjw6VrBxTsx7/gnZVY/0IHXZCW7/rdlLiDFKE2Doz3MrXvr3eRR9oh9acagSVkSGiTDN
 +4FzGIq8
 7jIMded3lj2F/rjw7QRHEc7V7J8u9X6NIcphsMEu4VzaxOnIFQsUiw+CV3M3xE1LaJx1r+Bo8HcbQEUnaaVlCU/wP/EBeiRM/7ab30U5GpCuGTGUNYxRRHWoaxqzJWPyZlJ7n5G0aeoU5wXSaGtVh5gK7h75B9VBnqho+qBpvsfJOKZQfRObaicxBlKlWOVFUo5Rh7R4UW4u2PYEGOfR1lxum5IEOyeqNAqAtY1c1ceZj1DM913gfpyB6D9g884QJGD1Z4E4fPK7H9gadBwe4HpQ4+uX9C2+uGJ9jzfo1cFkNWux/PdOP/K87bM9vHGaZMowQdgtAzGfpGB4a8wA96zh276us6V53Sh9z16qX8qhc906JTufeJZZapfF4GDAHJbLciaFU2hegg6h17QOxBaImq8FQe0mlUSvZngeuOui3oCqKieTAWWQS/W+p2KnVy2HlRCwdEHMNzQPHKIuvhfkA/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Explain the difference between nr_snapshots reaches max_nr_snapshots and
watermarks.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 Documentation/mm/damon/design.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 939298f2a9b9..1fcf0b8c044b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -872,7 +872,8 @@ the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
 non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated.
+scheme is deactivated. Note that, unlike watermarks, even if a scheme's
+``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
-- 
2.55.0


