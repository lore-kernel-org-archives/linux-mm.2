Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D3E606D817
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cfCTXNo0
Received: by kanga.kvack.org (Postfix)
	id AE1BE6B05B3; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0686B05B7; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F0E6B05B5; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 557876B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66730A7C19
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:51 +0000 (UTC)
X-FDA: 85392000582.30.325C4D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id ADA4680008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfCTXNo0;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUuIwuuN/5vKEs76XMgA3aQriOe7/CMf19j7+VM0x1U=;
	b=eb5G/gSM2rKN1SvZddhUA80GAyaq2ylhUafXAsZ2e+0t6+obaKaKnR7SCbJ1j1zCticsse
	fq1TugCgy2o/BFerUrJ7D01dDOsSX5gUWxxc1L7jL60Mxh0yobuchjYSj6NXpIVVpNLTaA
	iExOSeyruyDaXSKH5043nsL2C96iwnQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667589;
	b=FTFl6bYsihxO2k5h5Ced/eIUoZRAydzemzRwcsqLE4fh91M+PFWMFdeDaSHTsO0PHD7Fd0
	MJulK/BYtV1KaTezSxxH2AefG/zy8Z7fviHUCIIoOSBrluO1FCWLbsPLGiaWg4nfyJO5Jm
	rA9N0b+rxN6hbvapVxpVAxTX5wwKUPo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfCTXNo0;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EABD143C5C;
	Tue,  3 Nov 2026 00:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755CD1F00A02;
	Tue,  3 Nov 2026 00:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793667588;
	bh=wUuIwuuN/5vKEs76XMgA3aQriOe7/CMf19j7+VM0x1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfCTXNo0ZPM8K1LgRTrhE8S73NmxzqxhLzmYmP8qsqMgJvPkgdU5m34zUIO+MDX3l
	 pU7qiEvi5XreJoN2NZ+Z6WsvmGOr6pXq60z40hak9Ctmg4QnsgeqqVMczgr/R72pdt
	 ORxeshkRbhxX7mzpYY76p1JSMXo8btnuPMW4mbC9w8EWSLQXiXaQubBQ4kamwbZRBf
	 VnidLDjj23i7+/eW5MQjhG+f/PVV+D7K5GpVZhSWin4nMBTmMO0ODuFasksiTLYjPA
	 YlbdomK4pfJCvhMxfVqcQFi4zMY7WZRc2LAbkRNzTiZyxMTganEklLkbFTmYjcTMrb
	 7NNsd6ntD6izw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Manuel Ebner <manuelebnerli@mailbox.org>
Subject: [PATCH v2 1/8] Docs/admin-guide/mm/damon/start: fix grammar
Date: Mon,  2 Nov 2026 16:59:31 -0800
Message-ID: <20261103005940.91432-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103005940.91432-1-sj@kernel.org>
References: <20261103005940.91432-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ADA4680008
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	T_SPF_TEMPERROR,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 3shprxajaw5drij7o45z6bwhc3wjdhtn
X-Rspam-User: 
X-HE-Tag: 1793667589-78717
X-HE-Meta: U2FsdGVkX18s6mUaoTAvr2fo6CIbChBZ1KOhEBDovYEXO52mEKttoE4Zq7mKs9HsvV6orY6ZzIyDDkBGSHxC6mTd1fwFQS4e0EaKqBoFPB6Bv39+yvjgPfMjHKiQ5txO9opLi97/3y6jLKRR6OsBO8iBHiJjuH/CyH+gu3LY6yY4Knt4g6IcBNkDB1oZCox1AzRwxxlCh516s5AAqyBvbiIDliDXusY4s9RGNHMAjXdzRWEByvFg755W1ifwrdD5tAZ5XvmJ92eJINBn3UoWppQXMR/AQA1khDoFT0nqG+PUKGuLK+mSQsb24X/6DOs4DIihjYl4WVVFUgKWhl6guSYNE5prsaz3f2ffvDO3KKd2Pp6rwHDEtNon0E4jDMFM2ON5xywrOdwVPS+2u3+EoYpC13tck4gIxRZk5vG+LSKECPhODmURcbBY0qYUxnvNEicZt/2GPO51RCyBUBG2/IO32eG1Ew/6Ail/70ndl+cfBBGMxaixErL1fwt70Y3Y+fEK5gowfQ1YYRAjgubR7EECr0e5A1/cQw3JHLUw+SfsI9xrXhM8TrEJt2LctYp9P7lXqG+xpq5NjnMlXiF1dQgZcFDetXKrDieOrAEFKq47RjE5CYtSUOwTfNG577Kc7httK258otfuh8C0FAsq7dafIPa5u6I5wvLE2pUkVgvFHNfImkO655wt6x6a1nl9eGo5bdEvgIyHjFT7yuxAQbn9YSFViy3eMgTqZjqpKWcrtcqXZBRaqnA1gI4jJFWa72wE3H8wI95GZHYJSoAAdn+8JNdC4PtBrbD9eaS4LnTuOsjcWWOYaqjt9bF2hXfI46mtrErvA+ke8bv37gel1dp+6dwUxcVRMLWUz3ZOQ12oth13qJlsjTVqXmVTpw3l5Exg4mL32EKMCfBkbXsA8Bht0KjSMbXOpKgd9d5AHnRsgeoctrBUJ83DP4ICVqgK8/embDVq4iuaUiimX0s
 1DbfqA13
 rxAkps+Z41dJisUg7Cnn96hV6UEKFBnYykdZs4vIQDvsOaCKt+IXEIOR/TeBGKwhnmyEm3F+hQQJcmKgyU0Wafw0MVNPrIH3FLvaQyzJQ3DoSi2/9FRFobrxl2/npgGIYnAYpMHd5V4b2gEg8xP82eFHW5r72/AOrkk2sb/dSL3iPR2jhsjxRszBqdyKxIl3BtZCOVzkP+lKYXX/WCULyjfqWCeQXT6D7vHDVACVLX3m6WDM8Oa/nfN76+vm7A54yNFCIWiXuSBj52uqLReOdzbMwkw//vWOglJ/M9IssJ4OoqA53w574B+AsoKtj40taiT6m9rJYMi+NHkdEVyx2VSoA3CaLkGjpy/6ouEzgFPdQu/OC31muwgzWgbFrzyWQR9mOxqugi0SqvdpvHbhl5dZJCD1pIZNiRY8ovsKExVwBnaHSuK7t2xlX5sQth5F9kxnuL4ZhrYYR0pyzNMrzKSXZPBEXtu2A2Jmb8C+BBiZT1SWgAAy3Mp6BzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

Fix a few grammar slips in the getting-started guide, like "make DAMON
monitors" and a region "that has not accessed".

"The line of the commands" used to be "The first two lines".  With only
one masim line left, I make it "The first line".

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Manuel Ebner <manuelebnerli@mailbox.org>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/start.rst | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/start.rst b/Documentation/admin-guide/mm/damon/start.rst
index d98b0eb8e7713..e9c77dcddf7d0 100644
--- a/Documentation/admin-guide/mm/damon/start.rst
+++ b/Documentation/admin-guide/mm/damon/start.rst
@@ -63,7 +63,7 @@ the execution. ::
 
 The first command of the above example downloads and builds an artificial
 memory access generator program called ``masim``.  The second command asks DAMO
-to start the program via the given command and make DAMON monitors the newly
+to start the program via the given command and make DAMON monitor the newly
 started process.  The third command retrieves the current snapshot of the
 monitored access pattern of the process from DAMON and shows the pattern in a
 human readable format.
@@ -71,16 +71,16 @@ human readable format.
 The first line of the output shows the relative access temperature (hotness) of
 the regions in a single row heatmap format.  Each column on the heatmap
 represents regions of same size on the monitored virtual address space.  The
-position of the column on the row and the number on the column represents the
+position of the column on the row and the number on the column represent the
 relative location and access temperature of the region.  ``[...]`` means
 unmapped huge regions on the virtual address spaces.  The second line shows
 additional information for better understanding the heatmap.
 
 Each line of the output from the third line shows which virtual address range
 (``addr XX size XX``) of the process is how frequently (``access XX %``)
-accessed for how long time (``age XX``).  For example, the eleventh region of
-~9.5 MiB size is being most frequently accessed for last 3.7 seconds.  Finally,
-the fourth command stops DAMON.
+accessed for how long (``age XX``).  For example, the eleventh region of
+~9.5 MiB size is being most frequently accessed for the last 3.7 seconds.
+Finally, the fourth command stops DAMON.
 
 Note that DAMON can monitor not only virtual address spaces but multiple types
 of address spaces including the physical address space.
@@ -95,7 +95,7 @@ monitoring results to a file. ::
     $ ./masim ./configs/zigzag.cfg &
     $ sudo damo record -o damon.data $(pidof masim)
 
-The line of the commands run the artificial memory access
+The first line of the commands runs the artificial memory access
 generator program again.  The generator will repeatedly
 access two 100 MiB sized memory regions one by one.  You can substitute this
 with your real workload.  The last line asks ``damo`` to record the access
@@ -170,8 +170,8 @@ set size has chronologically changed.::
 Data Access Pattern Aware Memory Management
 ===========================================
 
-Below command makes every memory region of size >=4K that has not accessed for
->=60 seconds in your workload to be swapped out. ::
+Below command makes every memory region of size >=4K that has not been accessed
+for >=60 seconds in your workload to be swapped out. ::
 
     $ sudo damo start --damos_access_rate 0 0 --damos_sz_region 4K max \
                       --damos_age 60s max --damos_action pageout \
-- 
2.47.3

