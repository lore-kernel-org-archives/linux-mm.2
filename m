Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2FBC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23B7C6B00E6; Wed, 12 Aug 2026 09:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20EFF6B00E9; Wed, 12 Aug 2026 09:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124D36B00EA; Wed, 12 Aug 2026 09:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D89526B00E6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65018403C8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:13 +0000 (UTC)
X-FDA: 85092683466.03.779A5D6
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7208BA000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="w 6sy2mR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="WS/CpC5r";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786540991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFVegsV3dbue/WpZaO1ywLiWC7Si3PJqV3I+1pYiJpM=;
	b=Duct6F26mqckgIZB4NuLTrGuMjO4i9INRkEcwGqLgArZ+ouLodg22hFhW9IIyuEM2l7ipP
	6vfeZO+gC/h4Y9dQ4huSWuQw1Vm4g4m7h4ZGT3j/dCt5tMxuBiOjkEw0ix+6tQuC6wpiJz
	RVSQj0k7x+/39fZmIfmtj5oMI5cYN/4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="w 6sy2mR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="WS/CpC5r";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786540991;
	b=YXOf+CN8edj5BzKLj9UInDPKhCybtp48CNpnGRQ5SVZe7AIEt9w6ZRDJdiwUimZkdU34Oy
	Y6mAepcU+QEbS9+D4m69PdFGwQsc87MfQ7UH2qs5gv6sjBmEOi2EfQ62xcyuPEEIS8bNbt
	7GzJpKB5jwx7gey7n6I7mtOXq0zPhic=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2C4E37A00F7;
	Wed, 12 Aug 2026 09:23:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 12 Aug 2026 09:23:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786540990; x=
	1786627390; bh=dFVegsV3dbue/WpZaO1ywLiWC7Si3PJqV3I+1pYiJpM=; b=w
	6sy2mRPTMtYuyXT7SOYVmXl5NjLm5GBxukeObUH6rzKetbsBFV7ASdEGTVRAj3HI
	pxOaZD7F7GXV71xARLgxnUQM2FF+CvAJLyi9Mls8EgceOTDHfn+RQSfyZtVXArgO
	XrXZIHwlTb5L/VMrtPR81C8kpz9PJ4N4LR47yH//mqd4ovCWDGNAMtrfpP6e6zpb
	LI4ubGbq1dU3tlAkmT5afEWWZKcnqVU4PFR1nRt/lxhykKhAa3+jFPjGYqRwMEEV
	XDyv+RCUiZX6YJh6EjnQBwKesj+UIZwrPJ+zsSOfv+AlNQlQjEnJZn36rs+w2b3N
	4xLpCzLg11Rx/GwWonfwQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786540990; x=1786627390; bh=d
	FVegsV3dbue/WpZaO1ywLiWC7Si3PJqV3I+1pYiJpM=; b=WS/CpC5rJP+IE6ydp
	+eyJ09FCWELGS4/g2Iuwq7Hsz7G5mNhaG07e25lecZMwxPjjglJUT7r7w8ehrVS6
	lwWN/W9LyMoEk1j+xtxLmQFLZhc4Isy0PkRmFDbtORFGwohG25GmEH9MvqK1q0zQ
	ryllkbLOyc82gx391TeChv3ZApqhb0Kk7RoH0/Vf+mi4ygCI+hXfLPSdcQvohItW
	vNqF//RSpAKgTcizY6SMGUpYjnJjChg31+cjGtKBkJvC9VtbsjkovwbEw3HkzMnC
	jV/HW5iwmgzsdD9/l4E6Kbbd5znTM0RpAdBlfVD4HPRy9Q7PGa3O84cdEjbDi62f
	xBitA==
X-ME-Sender: <xms:vXN8apnSALtgaJ2M19GqF1OmW4j1l1ELCmMXfJbHKqiJJehJbyut3A>
    <xme:vXN8aoxoxf3IUexRVlrDFt-RroSuejROTiBCAtUuhCArllJTRBwmw0c4huYELTjuQ
    GtBtUFmYdDI5LDQLkZ-_1BIurq4dYcG5HiWX8W1SBRJ4RRFc_S-R4o>
X-ME-Received: <xmr:vXN8aoKLyHrTTVOHN0yUV8nrejv1-P1FB9_bHXLMeDuyZjm6b3QbWg8Ef9U>
X-ME-Proxy-Cause: dmFkZTEWZPjKBYDoSh3uCuJ0ogiZvSuDj1RAgMuSmimalRft9LCPvZxyrluChLfTbkjo2r
    KkCK8Ttm4mqxi+W2/UjRoyI4gRuaMCGjIyoE2sYafZhhTXl0iIGCKEOr9/WVtZfHPc/pjz
    XsLpzK8U2Xu6F30SrJOujIlp1bmlomKUtpU/iiXSkRy6wwaI7NV8wAm1PQ0lHgRG0nCRKX
    WKIh8TtevEly/nhHwG2deu/klJhGkXN7h/CDYOOyqjOIkeF7MAFsC6fZtQDVeVkgzM4xU1
    Py5NrFUehZdXXi5LHUYxqNjNVNbuxWN2P2YJW6J2IL8s+zlVHHPN2YdKOlFVuMcbnWK9RR
    he9rwe5OluvMSoZqJuhbcBqFRkamYKpUstN2ZIOi0PqxW8vU9FKgLKQmDf6VUCnKAQqAKK
    LKfSV1JqAWZZI35Umt11vo+D0VQpW5CMHQewiZHIhNYSwL0WunauJZTW72Si2RCbBxCrI2
    BLsRPDosTNNtjZRTQiK/cLEA+xKIOWLPVccONblN75rB4vSsls/CzPnovVsLJhOpzFiS/B
    UqomOZqCJ0Lu+0+wAtFKYPFd/4sE+/tKt8gMwGA7v8pgFrE+DhcglpAgXlu9z1idk3YvNd
    nA5AZbt8QYP3wW1iBN//oI/dRAJZiIvYp94BPDbFE28g4ZnWdjWyEuJzas9Q
X-ME-Proxy: <xmx:vXN8ajJDbj5Dg7MPxH8jl5L02Ug5tZ3-maMzl92ZwZ6PbImVmBUzhw>
    <xmx:vXN8avXaMcIosaBbB6dvEqVy-n5jTLnZ5gEhhExuHJj-Ic6HsA0-tw>
    <xmx:vXN8ajBqF8k9tzP_Sl4B3zsSgMAOAzUzr4HvFYItkhmneaHy3d1TFQ>
    <xmx:vXN8aqF8kHwcyBjecZXmZplhVFYAgpKP20Bi6qO6KYlGZRXWHFqJsw>
    <xmx:vnN8aoHuAJ885FkU3iXHcbSG5gVGLzqtQ4d3O-OWtK-hg-dg1IEomGkh>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:09 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v3 01/18] selftests/mm: raise the khugepaged test-case cap
Date: Wed, 12 Aug 2026 14:22:47 +0100
Message-ID: <20260812132304.199287-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7208BA000E
X-Rspamd-Server: rspam07
X-Stat-Signature: 1cknngg7u9aq1ozyqfzjkziihwdho1xj
X-HE-Tag: 1786540991-978441
X-HE-Meta: U2FsdGVkX1/LgWhKWfqprsEuh8Ywg81eczTRn/F8eWcGepvTB2kTTOynHuZpGh+8kHKSwpZ/HV6UORjH/qLecHkqqo3Lp8INvMDb+0xHKOLQDxY39xTPeCvLz0Psawz/HH3/azL8O/u15fR9Hwq0pZDmEEN7UYLMsJJFbxq1Oc4SXOcvldHIrlB0qAMO/HwamwS9JOASwgjDY1mcnh4epd0Hnu/Z8i1s5thhQHJuIm2AIPQ0OK+tQV7GYVj2/kiDR1CCEEeFd/wmBJ4l0/E0rXytq48uySCGWkb2eRGVaA9RLLo6ZcEyUMyEX0IDBBiBNstVVa3Qxmckm/ogb1Ei4WeSgkmJrGlqmIV0eYvaQwcD1h71RtnZg+TP3WlPrPSfuecR458VwBmlg1BI1DcGIyC25+/n+3waUASVrCaOQJ8KXWnH0GNmSiI4p8ufoZrOb29yEaic2ybaRR0u+/23TXr1XulyRp3AkTJgGvFOgyzk0LLi7ffGcSM224AhbzlZfs0174Xke7nMLxtSKPlONbHqqah7Us69BMghmd+Kual8sgCzQz3uUH6YeOSHzgorAccgLm0Yq6Ge7OM6x/oJ3fXwYUDx3cyDQsviDKO9gwoZvfFMaogECzxMQ+JTwSYrdJBcHhtK74i1ETlpmUe+5nfsaI5+phipzOlkRRKfGqRhhUPckgY7Vx/UWFnZeOdJaSXvo6WI8ihdl3XLvWm1tmYzIcaJgL/SMu+USvLKZddJe0J2kSofmUqo+P1xa9nflYcYcGqsaI4atkDMEOzGtPcaxQFa2ZJ6lr1/sPIygRzuNVU/07/DpOt9n9LCT9a8juf23iezpjNQX+wTy1rxTW7dt2ZgJnF/LaXdvurm0h4Km6zUI6Pzp1ClmMlc3gTdgpwYYJjhVpHeWr9Lnp66UCEOiHFZNZ372E1s58x+6w841w/kUxIsnKk8P8crosodO94DhMm//vmZh6DCchA
 eBu2Czqr
 7Dfg6O+uEPQE2Lrf5WN+Xr1X+6Zk4vSs0pW/Yl3FkV4xfKyp7sEVsmFk8PTVrdcOzhoHqnlSv15fi/1z7LPPGzwDKOB7be6va09h1wclTSKIR+ENDYqOLmoQLb96miWJ4yxM1nOP8YsxNjPq/FEnuhcMkb5KiPKhr55fnHHaXADSjYTPWYwJa1Guiru7Qddutzsv1g7MgCd9FqAqN2UmFaqmdnwseANAEuIMws+R47nL3ya9NzAzu6Tk91GWzQzebi4MFS8V4mw7jSeZmN0pM73TmLZ1eHPY44GNnpGFCYIu4DZULOcnsJ5RnesrdyrzjMUeUhkeiSKU4e9L6IX5aFCpKp0wzIzBHMNsjLhnPFoas+Oq9eIn4USst0Ne6m9KE+r8w4TY67cJZgkbZ/tfF8BbEXvflPo+wUupXDvn2balPbt2UOlM/UqOh50Ku5Yq1dowo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

TEST() ends the run with "MAX_TEST_CASES is too small" when the table
fills, and the table holds 64.  A full invocation -- every context crossed
with every memory type, which needs a directory for the file and shmem ones
-- already registers 63, so the next case added anywhere aborts the whole
suite before a single test runs.

Raise it to 256.  The table is a static array of small structs, so the room
costs nothing worth counting, and the cases added after this have somewhere
to go.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 0d6c71ed2fae..018b0698229c 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1324,7 +1324,7 @@ struct test_case {
 	test_fn fn;
 };
 
-#define MAX_TEST_CASES 64
+#define MAX_TEST_CASES 256
 static struct test_case test_cases[MAX_TEST_CASES];
 static int nr_test_cases;
 
-- 
2.54.0


