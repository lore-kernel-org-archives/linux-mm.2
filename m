Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFDB606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XbCFXiyf
Received: by kanga.kvack.org (Postfix)
	id 4F4246B05B3; Mon, 26 Oct 2026 04:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455B36B05B4; Mon, 26 Oct 2026 04:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36C876B05B5; Mon, 26 Oct 2026 04:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15CDC6B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:02:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76719404FC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:49 +0000 (UTC)
X-FDA: 85364036058.21.375D318
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8ECFF40007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XbCFXiyf;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793001767;
	b=Mq/dZEyeZxvUPSIY804nAJRg05qIJYTl2dwHYpR4NiXCDd8x3snFhskhfLFpOi5rrrisI9
	8WNmFCRerGCa3VzZeGoXknX4eyZ2OoTWfpWs4Zgglai6TpUjH7GQFDl5WI1PNUFXVE9AJw
	A5Sg2kDcQll5l9/+OX7s5V3ZywALQvo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XbCFXiyf;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793001767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAYaxeqiO3EFcx6b3dV/TijEGWqi49tfP8usMyM8q/8=;
	b=QZ2BsDMVvt5GlJrNFyCPRL2rkZddtQz/TU9m+d1n3JFNgOSxKY2xRThK6cyeFVxk+NTj/k
	molU/7jGXMieyCFNrLU19NAiov3dFM24CZ9of9FJcOOVP7scW7hDsbJANmW7HG0Y2jU8mA
	oe7ZyRnUiI7AJ8F7T+D89Swt+31NJUM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=M2vUNFESdf8UcymT8hZpLIfWSeAjBKgtnQoCKkOWGtA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793001766; v=1; x=1793606566;
 b=XbCFXiyfd53I2U6rUn0a6tfgIsXsLRGnPk9Df5ofMIgusvXpStcf7O9GGcbaOM6it3/k4HCn
 J2xjorfRJj6uhinSb3Q9oTSzON+YqsEz51TPCv2VZDsv89HIh4sP09ZT66ST4ChrVyztH33Y+Ri
 YVwhGfVcKsRmAioZ7waR7B4o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 30faa018c302662d;
	Mon, 26 Oct 2026 08:02:46 +0000
X-Mizu-Trace-ID: 30faa018c302662d
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Hao Ge <hao.ge@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 02/10] mm/kmsan: skip vunmap_range_noflush when KMSAN is disabled
Date: Mon, 26 Oct 2026 16:03:21 +0800
Message-Id: <20261026080329.140244-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261026080329.140244-1-hao.ge@linux.dev>
References: <20261026080329.140244-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 17hapoyc7p6xbx3wtpu8ygbhw961n7m1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8ECFF40007
X-Rspam-User: 
X-HE-Tag: 1793001767-53799
X-HE-Meta: U2FsdGVkX19X9UzaHT+5/6/rLVA48/bSomQnE1f0710FVDiVx2xVVDmc3GU+P8GhV8pI3SHbjbQ6B5adal9njdrcboqoAKeKV1dlUdWaCCSHwqTJigAuwdtk5w2GsXJcEjThaduOB1JOKn/gKMpDK6AuzflbACKf22I+Y9vBH4WscVAWGCdoUrPcH27mtBbaE1KE6MkIbN8jUNC2I1yWfyJHir5qsJjAE27TgZKsDCD8FGqjN1/4Bi9htXIPiSufHfKhBv7Zz+LnkzN6jyfdISDHxxtnMHNCZVPb+8x2//60Uigud2P7ONjLoUCxKa0fgycnJ6SLNSZY4u0Dj9ZXF7ACxnheTOMskp633J1+o27KPEvh4p7tMrl5ytVpMBk6ywVRJTCd1N6OSJZ8U91yjZ/1KuO4LzweSV7oWRzwF6PposADyRVWOHLZ4sGSh2D/gTSx5AtTDG3yodwszZmdXrqqnFsapnne0tJrmyvF8VXRSxINw5t7i3lu/DLPW4A8JSzL86Kwn//k9ji4+gzeCbWZudXFrR0qwCu+tbRUyJYNlyJHVfkc2pYR+aNAzb5SuUqNSd3owqHRT+6TbsINUUDtHXAPaaYTgnVFxOjoCEM8b6Dy9uAwLEfxRX6t0gbK4LBI6Ws8kShIOTchBNBF3sN2n6QtfenWFpYo3TJrXj8zGvrZGkSuDv3oKhehiYJ24dRET7GaEVkJXnxij4tAVc/HbdySBChvz2Z3xaEmG5TR4dZH/VBsLXkKVZ7awPAxRBYleofGnHpJrzeB2FEubLORzoJ5IRdS7UI9BQ/iHs1Ljd9Lx2ioha3p6nCtzMKr+mbsoaAERMgB2gDqvHbuzdFSFiYI3IqVifL1/29cqU09XhWkAXEe2KeLw8nQpgbZvj/iEkV2DKoKr4pXoXLNOwfLWNd5LNxXz0Z+ivOACuaeuI/oX43n0s9SMGnd4H3ldzvpx21PvvjfjY58/0x
 CtVf5Ra1
 6Ev/PDOZnz5qpn/2Ld5K4reBe5wS44IGUoWLv8OI6gC3aI8WCFAGy/4RhBkjpVsyTGyisiu+bKJNcbHMbKqzy5C3Cs6uwcQrc9ZP0f8f/300xivs1+JqFDWvnq+zidPkb786Y8TbH2furO0X6y+e72/rTOPV45oHrnJK7+pxb2sp4UNJQh83UIA5lYK7hlkUCgH7Fdd+bi8Tfh8bva7JIbBHj5TsqH6LylOFb8U+78ktTr23/asbaN8LTY9RmR04yTrygi0L+vN2fhosPcPk+U1FQxn+mof/UFjNevT6DBYWw2lN74kqEsnwf+snEYiGURzOfskE2jF9gZEPrsACm72AZfXk2xcoMC16HNQ8dPY6lUgek6y0W5LGnhQyuhMMNgu1E750C8tCJjW3C9H+3Kuz9d9Jc65ey7iuz+wwmPkQ8Z449Muw4kF9MFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kmsan_vmap_pages_range_noflush() returns 0 when kmsan_enabled is
false.  The unmap side does not, so it still walks the shadow and
origin page tables even though KMSAN never installed any metadata
there.

Add the matching early return.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/kmsan/hooks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index a706666db097..107f66841274 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -138,6 +138,9 @@ static unsigned long vmalloc_origin(unsigned long addr)
 
 void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
 {
+	if (!kmsan_enabled)
+		return;
+
 	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
 	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
-- 
2.25.1


