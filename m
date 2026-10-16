Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55031CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0826B008A; Fri, 16 Oct 2026 08:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F3E6B0095; Fri, 16 Oct 2026 08:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D256B0096; Fri, 16 Oct 2026 08:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1556B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:54:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 921921403B0
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:54:48 +0000 (UTC)
X-FDA: 85328483856.02.A528EEE
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id CEF31100002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:54:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LrIA+nrJ;
	spf=pass (imf05.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792155286;
	b=J6RKdsESu7BXdqI0difkXsCip43oNJ9mQAYKtxB3frPCVpGHSdLHNgLBNKmXwtd+RoZgKJ
	yuQQCdTygIOCICO3cDtrjgVimp3hCUM/VcYSe5M3ekJxqu1dlA847Fa0lWiPsIQAohdFJ8
	OBuixzlAk8/4Z5LcD/MKo8KZKzz+Ofk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LrIA+nrJ;
	spf=pass (imf05.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792155286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=47xwNbLDV/wYZSE2wpX2Ena+RjFR2X+u3FxDomSqYmQ=;
	b=lZIVd/GaL9w8hsbvsP0lTK2Ic0kGwxS86zMhjT9+XOuhGCOF1ty22V4E2NfpGyJ1InOl7T
	jyrpjQjfcvamcQs6s9TCcfijdY+xpg2nCFYsE93+LiLTzPoS9Xzz4jYu2alqZLhbY5WX0B
	C39kevSDAhEZIobtn+ZBuw0nkCAeDQk=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3514b90bb89so5895069eec.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792155285; x=1792760085; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=47xwNbLDV/wYZSE2wpX2Ena+RjFR2X+u3FxDomSqYmQ=;
        b=LrIA+nrJR4d1hNxMOMvjJPG+B0u5gkqe9Mse3xr83wE7PrwdBT07HHqTpLOroqLwVL
         JvyLa/U42h/ep6d7GBE+A2xM8OfJvdbkQNfj9ywHI8hGIHexTcaeSZp4lwIDsNUvEP6P
         nQ4Fl5z4mUfO++IkNknFiGOkQPSu9KBZ1BvPi46d05YKgKY6W/WKQbEERcToFIjHkCZn
         LfxJHLDb51pC80z4dmsjOriK3Kb9M3IAm+ibccH1gvwjULMHFIkMlFSnBzAm6AcRm9sz
         tOlFOo1QVl5h0eVN1zpi5ATGgBGZJC/sJs0x7TTCklJucQnjHyACm9AZPTV9T9aBc2Ej
         JuMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792155285; x=1792760085;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=47xwNbLDV/wYZSE2wpX2Ena+RjFR2X+u3FxDomSqYmQ=;
        b=ZrTe94R8wreQ+vcwsAUeuSaNQ2AOL9k8oV10+j77OaJO2CmhwnmrDdCne385tbJ763
         N6iJ5od7XexmoFhmD01NwfuzjnPfHFcDkuI01rPodE9oimBFYlZcR+2NaMvJX0HFxpbF
         ZtKM4n/Gnu9NqGAWSKqotFldGQATkCj3F1U7OWnLdpzrJLm4toZhWzqIvViSSFZVg/Hg
         UEyD3SAVdNHKOE4uYZvZHeARNGWle9ph+D6zGaHKTOPR4CdOr8Z+BXueQfpHnFDawpGh
         7/4wCFgZq0x00SclJ5xX7+WW5RdHwQjvgCmlJNSnvL76QuWyz2DqhldORYyi24QKZo9m
         BzvA==
X-Gm-Message-State: AFq9FYJPeBpxU2iDNTXo7ZdPe8F9HsEZ3pLqUprhWF+PCAATheNh9nF9
	I0TFrgPmgIE1lBF/j3UC1JJ21PQ431+vioVrxMAzA6YCvhjtfBZJNbvo
X-Gm-Gg: AYBFou3gSyOOx9BtFqWrR6IQwr0kxd3c5DZThoCFCjfj+k1D7OQadReImGFJJBsszTA
	/1RbW0XBGBReGSATxNfZn3HoSTR2tq3sr2vBsfuZ6HRkE7p3PH+GzsxncF3RBS98zj/7/xSSfti
	fM72jRolleRwuv6E/yMAPB0dQWiPURqj8ZgEDESuBBXjHNU9lDJhNgzO0TSjvdIAx+sqs2jg+Wz
	5y7PrXRdis/m5ItgzNP07K8PS921isq6Hu1JxYYLVhHMdN/YTRdwU755qHGeWnNdS1RMfS7b1Zs
	VnkhSERhx8ua1Qh9INSBaD0Oyy8bW44LQvwiAgwx4/XvuGhHATryNflA6Sbh/rW4Sb+opesxA1U
	hAJIZ5btBsWDGKjLb+Ksdqi8+/YyIiA6XCkLao/wXivkYXEM6mkubKplVLZQHx6bMmp2pTCoqkK
	qBLyNmZPo6SSE+wXMNwAoz7JKFzU1YqBqT2D+pqqrxiehOmPlOYl4yJo+fCVH4r4I024YXKjJ8/
	ECd
X-Received: by 2002:a05:7300:6d23:b0:35c:6ffd:e91b with SMTP id 5a478bee46e88-35c6ffdf3b6mr20435005eec.40.1792155285484;
        Fri, 16 Oct 2026 05:54:45 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3607ee0e5e6sm6829118eec.1.2026.10.16.05.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:54:45 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 16 Oct 2026 20:54:37 +0800
Subject: [PATCH] selftests/mm: load xfs before checking for it in
 run_vmtests.sh
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-bug-selftests-mm-run-vmtests-xfs-modprobe-v1-1-b97dfc79e97a@gmail.com>
X-B4-Tracking: v=1; b=H4sIAIwe0moC/yXNwQqDMBCE4VeRPXchEUmxr1J6qGZiA00iuyqC+
 O6G9vj9h5mDFBKh9GgOEmxRY8kV9tbQ+HnnCRx9NbWmddZYx8M6seIbFuiinBLLmnlLf+6hpuJ
 nKQPYw7j+7ruxQ091bxaEuP++nq/zvACD1dWgewAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CEF31100002
X-Rspam-User: 
X-Stat-Signature: cfmr8obtyjihhr9e6zjgsm1wphhnx8uc
X-HE-Tag: 1792155286-923316
X-HE-Meta: U2FsdGVkX18dPGnz761XmzUR95n7AQaQa2+Ql1NikSYY/UVZm0ytmXbcOKl+A90kDF80HQrROnaEq7tdJj2lJ+SHQ+ncwgAZf1gKGlQBUCxG1yuJMAlS+sfRiEhzEx565d8RHWoueWwbC5sjyhUHvanb+vVF5MGgkh3sXeKb9qmrP1twoI8dXHlh0IIFNvTpTKPtXUt875BcD/OWwvIB5Yiwn4Z79a4sIPOleg3qY+nddLVPuTJ0fLv8SMy0Rjdp0p41FRbx5LN6Y6fJ2hWg+cfBXc2fQaN2uhRNIJsQt9e+Lpi3XIhH2EHTNerBCaTJ4/nB8LEBhcdbBzLnwPB/68wlkc9PBwbTbGwFvhwbzuRT6BwhmpjhV7+3IB5gZzoaiavBaaaukZeUWrqlyzIQWr4bnmAfDaBCpNoPQG5bgrX7dHXn+XQjtjNnV9aOFkO+Gp+fMinjVQWQv3RFDsY0TAH0cdEhcBt4x8BT7stMwkmW8Z0QzAyB4CAhs1l7DLP4FQLNI/yXJn3Q0ujBj5txwFBpydOx7m9YBR4YtKo9JgEFRrt4Z/yD/4shtz/1vxV6z40gdM9a7Y+VDEfvoLPDjZ1rgWB1Y0AuGevlpc48ZUNaoRwTT4W17NV/P6pTBZO/5FqvarT3R9p50YXjllXfc6eCEwS0rDkGTt9KiJVcSejcmSCM/nipWsn/AjgQOWJT1U1nHp1J1ZvD3l3x9FZ6nBtYQAe6ce/mpK2zEm+9jcg3X7flagWviIlEx8bmHWvspcUVOJy5BswmZahQV5kD/h1f5S6ZnOQdbrwBT9EB2onRc3XjjBpGQjs3udBZIS+8894+8QtrQd4grsQlcd7kOjy7r//qoMt0uHqyGQvemTsLOetRYfRQWcQB1jVWoP8tlZ0lgGquTzhish+1eWIqYAW3jlp93IBC3zGNq6gjdr+wTNx9lxKO6VVdSnm4QuUh1ACPzSrIrY6k+lmD6G2
 VwGMxQsH
 +1G4U+yGkMWqPeujXl9cMEqUtUKNGYXi2+m5TY34dLOrBMsXesu45WFsjC8kdziUKPHKNekbbKIgtHyszpJU8/IFKettL87myr5NKdGImP6mTkEJIMgmkPASJEBUnJisKX6EE6s/n3IyskOCZ6WZGAeVWdrZeDblGlh/gmr5SSUkbAFWTy+zZOxPo8PLWr7gYgj2RYpSrTUsD4cvXjmpGQZLCYNT7jCx8xjiqLAKRXSYxOuV+BRmRjY6EAfx0C7Der89s08vcJ0CEOlhVMI0BVb6viJ/BS+4eA0j3wnccrY/a1o7ytE+91XCRfvVZEjhobg1AUkkGbWon43y7wUFUGqknBKO4KkpIT2oNKSyPaJ2yad5cQ0+Moyv1itgTelh8e6eRdOIaJa/pXDSSnNZc2unwx209IURPggNJ6Idw6a5xjCG4c05zSrZ/HqJscRwxBXXU+Ck7PQouJtrm9WVlYcJ9hlPIXafyALXK6gSUL9vN0p7O7fxsx0bAHZ0zA/uCc4wpOGBWUVVu2mSXFHcFH0gVSJflqVzHIWhQon8JzQrrM78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh creates a loop-mounted XFS for "khugepaged all:file" and
for the pagecache folio split cases of split_huge_page_test, since
tmpfs does not give them large pagecache folios.

It only does so when xfs already shows up in /proc/filesystems. When
xfs is built as a module that is not loaded yet, the check fails, no
XFS is created, "khugepaged all:file" is reported as skipped and every
pagecache folio split case of split_huge_page_test is skipped with "No
large pagecache folio generated".

Try to load the module when xfs is not registered yet.

"run_vmtests.sh -a -t thp" with xfs built as a module and not loaded:

                                   before    after
  skipped tests                         1        0
  skipped split_huge_page_test cases   43        0

Fixes: fc4d182316bd ("mm: huge_memory: enable debugfs to split huge pages to any order")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a1b45a3dedaee..6b754555d5734 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -399,7 +399,7 @@ CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
-	if grep xfs /proc/filesystems &>/dev/null; then
+	if grep -q xfs /proc/filesystems || modprobe -q xfs 2>/dev/null; then
 	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
 	    XFS_DIR=$(mktemp -d /tmp/xfs_dir_XXXXXX)
 	    truncate -s 314572800 ${XFS_IMG}

---
base-commit: 437a7e839def0f505277022622fc59a8b071d6cf
change-id: 20261016-bug-selftests-mm-run-vmtests-xfs-modprobe-de0697d4c4e9

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


