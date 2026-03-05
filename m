Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9BB6EDA69A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 04:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A0D6B0088; Wed,  4 Mar 2026 23:31:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7D76B0089; Wed,  4 Mar 2026 23:31:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB9A6B008A; Wed,  4 Mar 2026 23:31:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB6196B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 23:31:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7515A13BB46
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:31:16 +0000 (UTC)
X-FDA: 84510734952.18.66B9243
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	by imf18.hostedemail.com (Postfix) with ESMTP id 458FF1C0004
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:31:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=WLGgvEUt;
	spf=pass (imf18.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772685074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWiReCix3ifNv9wEOKG0H4l/dBG6k1jJeJufKk5vE5g=;
	b=5XccqsDVlcae4keWHPjupP5NsfSlIjd8iA2eXYDqk0TdGk5vbRmbA/+jQ8SmixWMK39X2N
	eaUQJoJKLrVxQpDXrvCXum53p5DXEf6XwqLzhhS55RBQsMLL4tqFzmQxhG5+rJ38iRZxxf
	73F1NkUaIWF61UqkR+WNRZJjKbGq6AU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=WLGgvEUt;
	spf=pass (imf18.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772685074; a=rsa-sha256;
	cv=none;
	b=hM+GAkJ9jQpilLRGu+mTFlD7VJsPQI67aqDygBa3d+C7V0hv6SZniRVn/XnjJ6FGJeT2eb
	/e5BSHNXDuh1r9a8Sw5tvmQMsqMxbPX+FhKq8kM/REtXA8Y3Idii72nbbv9U74Lp6yoUwq
	XrIqpsgIu8c4K0QlVyiNnMR/2VGOQ3E=
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 3736126406;
	Thu,  5 Mar 2026 05:31:12 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id XXPCjDwkRAKw; Thu,  5 Mar 2026 05:31:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1772685071; bh=A2XNTmUtPHFg3CLqJTv2JUzU9DkNwUrzNcQngT3Qnb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLGgvEUtrYTQyuiep4fWcmUqEGI4IEruNz1bU/ehR2w6z3zbNlhdMOk6KaDCmkYLk
	 7J4cZLk4hmwTmCISL7j5WjlfpWLDfw4VBQ717CIuo/DonY92qmUiikbU4KHBSx/0RM
	 ZOR9RRpg07a/5K2ZqxDWn2DZqH6u4b3Cd0BF3Dd2lfTdYoD53lB3cEfN2EiiNjGeHw
	 wGpRhCXWIurIVb4hiBtpIJwcPHFT5R0GNNpCfWpuBiGPX/ttgLWQolo8foUik8qQ5c
	 gzgdqvB9C1Or0x/JVfITNhLmkf6MVULElembEHrCqRzbVpYVtsKMOh2qzlO8aHeu59
	 lA5GvL6baljxw==
From: Benjamin Lee McQueen <mcq@disroot.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Benjamin Lee McQueen <mcq@disroot.org>
Subject: [RFC PATCH v3] mm/vmpressure: scale window size based on machine memory
Date: Wed,  4 Mar 2026 22:30:38 -0600
Message-ID: <20260305043038.2176-1-mcq@disroot.org>
In-Reply-To: <beab70d3-470d-46ad-a890-76fabe49272e@lucifer.local>
References: <beab70d3-470d-46ad-a890-76fabe49272e@lucifer.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 458FF1C0004
X-Stat-Signature: 5gid99k7aof6kfubqnq5ckeypd65iod6
X-Rspam-User: 
X-HE-Tag: 1772685074-656734
X-HE-Meta: U2FsdGVkX1/79SrRdCYgPAKvbkpXa+SxO2pAkI4vi5pSKaLPTLiWw1+tNNosmAAFqI2T+zSoQCF/hug/VVEPVN0Gll5KCxThHw31Sd9uNhROgbyz0CypBD2Uso3moknZFMzV90/VASd0qbNHIXwQ6nB+oR08osRo3GjNBgmjCaQQBinYcrhVN4TmwtwqIW39fodzXsl4/stns0HTG281ToKkuvMuBS7rYSTc/87VqqloUVu3pkaTMVcA6ZdtmtZvQ6FeBBTyjOHVktx6uHYXRGVAYL15XeWA0IfKh9177wu7WzsFCGXryImJlfgUXJcxGZnKGxWz6Co9k4lKXZP3tsRsq/knEM9ttI1ZhL+jqfwXXYrom3+5pzaRwIFQC95owQxS3DOkjDfVG1sH1dHSsQ4/D7xvf2ZT0JQEPywiy7CyNWaOkJT+/9I3lFtRpL1Kr7EyyJCO3332B71azdzfsP9C7RWGA1jO1Gn4SvbQqlwjOzfilHkofkqAuSwfeDATEkM9h1QUwXbuXDN25leO7Tn+2H846QBPdU2hguHlGrdtljANwD+PR+nvaTBaiYlovH2cL2/Afp2PhErbnA9eDz9f6SdqTA7uM4jcdd64rUVVaP6awEubAxAf/1jGW/AN9W0hkhYmEnu3rhvpiicXDlhDS41FIfGB6Mfc509uUDTeag8XFguIm4oIhatU+zE/dTlXYdPy/03PXRIW18m5IhCZVOGtwLxsDGKhTJ8mg7XHWgGADKFceigSwd/Jwr9z6cSk9y2iwe1C/LJuv2AgB6G0rBKrQ/1Y0uoP4n80P8fCYAgzsq7q8+SI3HlxFvHOrBlL3aa64zNqTGZuIcqnHHsw+STvg9aheu147jQjK33vQDcdsYdYHMVwTDCZxVjqQu6jR9Ae2DuvTwItnTJ0Ql4FYROJLlQIDfP2nzxKKgiRXgrBUkMJeqjh19NBi0rD/wETCmoX4NgtUnHWTCX
 9lsadiXX
 ucQsPK5tTmgyMszyo98Pe518VEaUJSjrgYH0Xn43Iuimy2DJk4cVGRIAwy7pHVn1Xmc3/oZfu9tXgu9hcl2c2cNJOCPuMxN4IAvcT/Lhkf+TQSGibPuUx+XL5ZRsRB8P9MVLfCw13thuOxuB/p/EIinvV5vseJoXSwJ+LK4OBnZpMyjm3kiCyN7rABuXEp0ELSe1hcvdQsEc/sWtFEcyUS+HAVifibo95txbry9bC9F/mQTd24Y8jmsz923/GcmtgTOGV+Bdg5C9GirzPauuOuSOBcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

the vmpressure window size has been fixed at 512 pages
(SWAP_CLUSTER_MAX * 16), ever since the file's inception. a TODO in
the file notes that the vmpressure window size should be scaled
similarly to vmstat's scaling, via machine size.

the problem with fixed window size on large memory systems:

the window fills after 512 pages (SWAP_CLUSTER_MAX * 16) of scanned
pages. on a 256GB system that is 0.00076% of total memory. the
reclaimer works in chunks of 32 pages (SWAP_CLUSTER_MAX), so the
window fills up after 16 reclaim cycles. here, a single (or more)
bad reclaim cycle which reports false info has a considerable effect
on the scanned/reclaim ratio, producing an incorrect reading.

a larger window however, is *potentially* prone to some additional
notification latency, as more pages must be scanned before the ratio
is calculated.

this is what we consider a false positive; a notification that
doesn't correctly represent the current sustained memory pressure.

as for issues with why false positives are bad: applications or even
maybe the system listening for these notifications are woken up
unnecessarily and may perform actions that aren't supposed to happen,
instead of being in coherence with the actual sustained memory
pressure.

i did some testing, as well.

the testing was performed on ONLY a 9GB VM and nothing else.
window sizes corresponding to larger machine memory were set manually
via a debugfs knob, so my testing may have been corrupted as i only
had 9GB on the VM, and this doesn't correctly test on larger systems,
but it is the best i am able to do.

vmpressure_calc_level() was instrumented with a tracepoint emitting
the raw pressure value. a controlled workload (2200MB allocation into
a 2000MB cgroup with 500MB swap cap) was run at each window size.
1000 pressure samples were collected per run with 50 sample warmup
discarded, repeated 5 times per window size.

the key metrics are stddev and cv% (coefficient of variation; stddev
divided by mean pressure, expressed as a percentage). cv% is
load-independent so it is a better measurement than stddev alone. a
high cv% means the pressure signal is noisy relative to its own
average; essentially the readings are unpredictable and unreliable.
a low cv% means the signal is stable and trustworthy.

do take the data with a grain of salt, as i probably didn't test
efficiently. this patch still needs to be tested on larger memory
systems on real workloads. but if you think there is a better way
for me or others to test this PLEASE REACH OUT!

  Window  RAM Equiv  avg stddev  avg cv%
  512     stock      45.86       91.24%
  1024    4GB        34.62       69.28%
  1792    8GB         4.03        7.97%
  2304    32GB        9.90       18.53%
  2560    64GB        9.95       18.59%
  3072    256GB      11.49       20.99%

the results show an improvement in quality as window size increases.
stock at 512 pages shows a cv% of 91.24%, meaning the noise in the
pressure signal is nearly as large as the signal itself; the readings
are essentially unpredictable. at the 8GB equivalent window (1792
pages) cv% drops to 7.97%, an 11x improvement in signal stability.

the data is consistent across 25 independent runs per window size
(5 sweeps of 5 runs each). stddev and cv% barely move between
sweeps, which gives me confidence the measurement is real and not
an artifact of system state.

stddev increases slightly beyond the 8GB equivalent window, from
3.82 at win=1792 up to 11.49 at win=3072. this is expected and
may also be an artifact of testing on a 9GB machine rather than
real large-memory hardware. even at the 256GB equivalent window
cv% is 20.99%; still a 4x improvement over stock's 91.24%.

since i only have a 9GB VM, i'm setting the window size manually
to simulate larger machines, but the actual reclaim behavior of a
9GB system doesn't match what a real 256GB machine would do. on a
real large-memory machine the reclaimer has proportionally more
work to do and the window would fill with more representative data.
this is another reason why testing on real large-memory hardware
is needed.

the formula itself isn't like vmstat's threshold calculation, and
uses total machine memory size (RAM), because reclaim costs grow
with RAM, not CPU size or any other variables about the system.
the formula's floor clause also ensures the existing 512 page
window on smaller systems (512MB), and only affects larger systems.

if there are any other questions, i can try to answer them.

IF YOU CAN TEST OR COME UP WITH BETTER METHODS PLEASE REACH OUT!

Signed-off-by: Benjamin Lee McQueen <mcq@disroot.org>
---
 mm/vmpressure.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 3fbb86996c4d..0154df4d754e 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/cgroup.h>
+#include <linux/debugfs.h>
 #include <linux/fs.h>
 #include <linux/log2.h>
 #include <linux/sched.h>
@@ -29,14 +30,19 @@
  * sizes can cause lot of false positives, but too big window size will
  * delay the notifications.
  *
- * As the vmscan reclaimer logic works with chunks which are multiple of
- * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
- *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * As of now, we use a logarithmic scale to scale the window based on
+ * machine RAM size.
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static unsigned long vmpressure_win;
+
+static int __init vmpressure_win_init(void)
+{
+	unsigned long mem = totalram_pages() >> (27 - PAGE_SHIFT);
 
+	vmpressure_win = SWAP_CLUSTER_MAX * max(16UL, (unsigned long)fls64(mem) * 8UL);
+	return 0;
+}
+core_initcall(vmpressure_win_init);
 /*
  * These thresholds are used when we account memory pressure through
  * scanned/reclaimed ratio. The current values were chosen empirically. In
-- 
2.47.3


