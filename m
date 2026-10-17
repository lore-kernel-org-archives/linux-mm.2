Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9281BCCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 15:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557EA6B0088; Sat, 17 Oct 2026 11:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509896B008A; Sat, 17 Oct 2026 11:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E586B008C; Sat, 17 Oct 2026 11:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 142076B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:07:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79B6E12030F
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:07:22 +0000 (UTC)
X-FDA: 85332446724.02.F5F7035
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id ACC0E2000E
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:07:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oMEAUAlV;
	spf=pass (imf13.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792249640;
	b=Qo+j2zg1nmB7/xdn75Ty3TE+BFBJgCUEJocnIXpEcrsquz6PW8kLlxPdk7/ZLgXAsddQWv
	wNQ0f3TutYpiNuS+LdN4PlbWcHcrHDBbVCpybJAyKr/TiI+A+aKKBhP/C+4ipPchurvcgm
	b/tsj/JrnCAyo+VzG0kgkXzbgvt5JJM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oMEAUAlV;
	spf=pass (imf13.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792249640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hfbMKsH1Fz4AX+3Rx2rk0jVnFtUXjI/UntlVsfn/H8Q=;
	b=oNRFVmVEWp/H9UqVbNocfVgBZ6M35iV19GbW0GC5LRqXhi2FCUlPt54MMGZ4AfrmGFggko
	P/6GIVbydqgTwUZh4Q7+0sOYxiSaRDW3TbZIe9E+iAR8V5UrBjRhjDaXRDY7R3M/5RHMFK
	UxMOfi0kjePLuCsW+9dtKErnjDakV8w=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-354ba08cfd1so1208496eec.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 08:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792249639; x=1792854439; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hfbMKsH1Fz4AX+3Rx2rk0jVnFtUXjI/UntlVsfn/H8Q=;
        b=oMEAUAlVcvBbXYss+TCqjfIwmJV3tCM/v1i0jmvs/KdZ13zYdtsT9BGYFYPGaSAVgI
         G/S0ykjCkQ0+HJ5FXOZdZI+CCstHLmtOBKw5DkqwFZVzLm0HPmjEWdIMqnyrABQhDCI9
         xEfGVR3vI0uvyW5QMElRhsOInbrHlpaRHtvWS2VK5A2CLaTTDHLL6bFzUIwHdPdiwn3o
         ekndSZTfQBtD9Cygnvccsaf5ybkMrOulNPN66mIT2VZLhUfeFFSj4emqGb8QqYpxpHi7
         HDT1Xo70uoVLmAK2Px42mpgY+/g47Gu05c8Oj54GrJ3ok4hH/JOM7r2rje5FiCtF1U2p
         Le5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792249639; x=1792854439;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hfbMKsH1Fz4AX+3Rx2rk0jVnFtUXjI/UntlVsfn/H8Q=;
        b=yr/S1Vu/K1zgjmUFVmjsDMtvc6TDMH8E3Pwi+kQshQQlL61+p8uljbteIx2vxfkRJf
         TR0njmp6zmFHKgNs7r4wMUoCwpWc9NIMdDj5LIVG3ztmd1wZqzD2wnd8cvxrptCC8/aT
         +4J0CPOKqX+rhmjEMDQPQKKlFal/pO2vW2MyFlI0ylhMA7lCrOGwZaLY3Jw4cp1pNOhH
         tkyd0QbFj4vPAdqA57B4mMvZOxKM4GJI17u2q5DlFjHetlQBcn0R83aFeCiv+QQccdms
         dFRq3lYYv57/OafayOzcJv7fGYTvtcPkb/GURGB0YU3he8BUYKBUjTd+LVkh8cVb1BIl
         lciw==
X-Gm-Message-State: AFq9FYJ3XiFjuKoHjWbm/IN42WxsB1nh5gwfgguPWXeo812mI22lmSer
	45PZFX4ceGCKJC2G5ps+zunMxxMY+aFg8HUNjAW+Hyn4Vz1TBJ5zX7rhNU0YcD4iQ84=
X-Gm-Gg: AYBFou1H4OuGmsqx3LBDRmVFJ/IYJkRYAaOhzhbMGYv6ukBC+jCuqrWnHrAlrE5dLHr
	rkdn8bugG6kli9Adn1kIMDbB5VswswWe+/jQPG1RHWmaTIHML+wgowxJoPnhnQ0Ndc+mHRoYyVg
	fZLJyrG/13fx8/tDt1dzwd2hBc4+Ln3xu3dTYoNXbLVqPpu9PIku4OBvPIwPqFwLO1EasSOKCOe
	s4CV97vjp6arMsksEG1gO2Zp9WsXDYlPxvvVn7e8EsDBv2ECN7weiTRLRuYxjLrIwbTe0H/0IVN
	cxicOVo3cDPJJ64XrdiyhXiMW9KcHpOPDvgw9g5QGYSK5k8U1QU++JpncA7ZZ4SMbIXD4QGFnYA
	g9rv2IbQo5xZf30QbfB70H7T8+yoBYvMOOP9tL0iXT1IvUFlaWA4O+lVbtAyn5Ia+okYONYLaJW
	0/rOGWVYrsriNz/2xyzsLKG9NiadSE1UxRrLTHOH4ey7x+fhH7LnsnV4ZHgp88F08TQSttHgEmj
	meW
X-Received: by 2002:a05:7022:e1f:b0:13d:974:a2c6 with SMTP id a92af1059eb24-1851160d0c2mr5666359c88.7.1792249639147;
        Sat, 17 Oct 2026 08:07:19 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-183190aa3ebsm13170977c88.8.2026.10.17.08.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 08:07:18 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH v2 0/2] selftests/mm: run the XFS-backed THP tests when xfs
 is a module
Date: Sat, 17 Oct 2026 23:07:11 +0800
Message-Id: <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-0-cbb36b014322@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB+P02oC/53NQQ6DIBCF4asY1p1GjNHQVe/RuFAYdBIRwyCxM
 d691N6gy/8t3ncIxkDI4lEcImAiJr/kqG6F0FO/jAhkcouqrBpZygaGbQTG2UbkyOAchG2B5H6
 52zx5swY/IBgsG9WaWteoRP5bA1raL+vV5Z6Iow/vi07yu/6jJAkShuxY3SpUbf8cXU/zXXsnu
 vM8Pylm2eniAAAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ACC0E2000E
X-Stat-Signature: 3i6e7n7eebsfccyd1ogwrxdjmxjz3jih
X-Rspam-User: 
X-HE-Tag: 1792249640-18748
X-HE-Meta: U2FsdGVkX18uWFQUeuhlgP3X9Ja+14Qc2cTJ3xmJpn+LHuY3BUigg4wre48xxzPsu+VgLqKE5O93jFenpYFWvil8W2dUYX9bDNOSrx7YZy4TNtF5WvnTgsk9aNQ+USXNpzmUMYOGiJu7u10nt/TJScj49/bDIP/Xu2iCB8Wt0OaM64+mhVOojPDZsJ1XCZA6BOZU/UESJgV/cmt6rXiZuan1KMa+3ZZpIzjvav7a/9W9TZmawbCn6FyXnZb8HFv8eWnjWZIeEowr7KFCYnhhziDYpPtKGg+DWn1ZGOnc4SMjERfhvife2mmebpja+lQIs+bUOcYf/gEcNxOrqnJ3RMYfvFeQeY1vKofn5jAFIVzK3e2jH/H/KbKeRQnbpGOMbfyzMJZBaneCRQevhccw46CqDMwh6QjDpIYdDkvdlAmDhbuxS+36JQRUEwH93tLjeY71piTfKSksheRGc2ES6i38VeYg3xkh+/pSDqOH0RSu7OgN0FbSWkoKz5HEy+WotMoHsW6sEeLtlRqORocyp5zH3g2s+T+ef17ExB1D2OfwMFMoEqTRiV4a5VFI5uRcyk5yqpSMfUQGURgeTSuI+1siAidrSIV6MGj1GKcO+kAPKTHSjPh+K0JIvKFhmV8loUUok7A4OIlugUQ0ydwvIjsYJNNNd+S1mN7Os56I6sQ0HI0xWbEplUtjdDaZCDNl0ADCS3k+aSoLA5I/U/fDaX8YLxnE9ypmvBBv6dCzvJNKUi+87Xx60j+FuJL3V2h0nuYXw0to2qnky5ySfQSPysJjeI/A2yH4OBaAwS58qxglHtiH0+KwDpmU71ucVf8FDLOmt8Sz0sRmzlxjKz5tHQbtBYB8uhvYFQf3AaWTSjKIWR8o3kIAYSOvnpwVg21tZVQRVvVFyqhyaFP7R7jjPEWCQPvWCqNCxwqPpVPV+YwLrwZ+QFCudPZcmgJdWJsyeGrZupmjOqrbF3J6bXE
 UGa2jqva
 3JYtmd0Q54wdyPPDObGhHeaG57GSas9Yy3qEufb61hJcYQSNSc92tmm7Z1rBLTb2+/rC1mns405vA0rcKjBgC0PoGVZG2qBJDDiyRrnhH0DH5+4fOru8AC7bW6ym5mSP1tPi/ZAmwq3zaeq8lOkpmy3g/EQ5tQMCsEbMA1mqyhkPS5xX4Cwsljcoq1eiVI48HgVsLnLXsP+j/4RVLrfmx+gyULeod/i9WuUyk8UYioNRIxZ/hI9nVaZBBcb3tS0KOYBoHYE92EzxSMD5tktJe0rp5n7W3j3aOHVeVq2bBjWwv8dwq1FAa/JuQFEmeFiWlq+XgLI6SWEmNvoFrwt+EDZudjc6sfuUQjP4KQPpJA0tHUFh6iExRkxulB6w6HpIy/iibo/uAbFpe22hMYSpdayafdo0DZIY5a+M9h5vAL80dkGcXy1XzEEvLAw6O5/bOAfpgyrJ8IZNIYLQT2VjRe0Osg04yFleiVLQbJgRUpdG9HEO5pUfe+EgrfIkvf55FWFtnNU9OjvokdUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh only creates the XFS that "khugepaged all:file" and the
pagecache folio split cases of split_huge_page_test need when xfs is
already registered, so with xfs built as a module and not loaded yet
those tests are all skipped.

Patch 1 adds load_module(), which records the modules the script loads
and unloads them again before it exits, and moves hwpoison_inject over
to it. Patch 2 loads xfs through it.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
V1 -> V2:
- Add load_module() and unload what the script loaded on exit (Zi Yan)
- Unload xfs again after the run (Zi Yan)
- Rebase onto mainline

v1: https://lore.kernel.org/r/20261016-bug-selftests-mm-run-vmtests-xfs-modprobe-v1-1-b97dfc79e97a@gmail.com

---
Qiliang Yuan (2):
      selftests/mm: track the modules run_vmtests.sh loads
      selftests/mm: load xfs before checking for it in run_vmtests.sh

 tools/testing/selftests/mm/run_vmtests.sh | 33 ++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)
---
base-commit: 90201351a862182bdabfc1ad1c97b1e1b6ed5931
change-id: 20261016-bug-selftests-mm-run-vmtests-xfs-modprobe-de0697d4c4e9

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


