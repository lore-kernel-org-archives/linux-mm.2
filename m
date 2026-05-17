Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F4DBCD4851
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 01:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870156B008C; Sat, 16 May 2026 21:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8485C6B0092; Sat, 16 May 2026 21:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784886B0093; Sat, 16 May 2026 21:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6770B6B008C
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:02:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2CAD1C12B9
	for <linux-mm@kvack.org>; Sun, 17 May 2026 01:02:32 +0000 (UTC)
X-FDA: 84775111344.09.8069A53
Received: from outbound.st.icloud.com (p-east2-cluster5-host3-snip4-6.eps.apple.com [57.103.79.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id D5DD116000B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 01:02:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Bgdpwqtn;
	spf=pass (imf08.hostedemail.com: domain of ssh1326@icloud.com designates 57.103.79.49 as permitted sender) smtp.mailfrom=ssh1326@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778979750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZvJZ6sA8BqOCSFmfh6e6tNl4NE226dSLmvr6UFm2Fs=;
	b=Fzhn4PArGdZmo0LN77DE2Oom4VsfMGC9PJK/ECUBeP5AYBUjjTqTXDN8PQtM+dwt9yuuMm
	cHA1hjjzuVt/HXsFpxBBp/s2t0kLp6D7TKBTeoVBi9scg8xkTYQCR+wSGN0qd1j+dwxLUF
	yoB6xAtjku3zAOYQicM+ZGqW46CMz1E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Bgdpwqtn;
	spf=pass (imf08.hostedemail.com: domain of ssh1326@icloud.com designates 57.103.79.49 as permitted sender) smtp.mailfrom=ssh1326@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778979750; a=rsa-sha256;
	cv=none;
	b=uaXMz50+Np2orFh4GsXX8QT8zV1qpTulSpguKj72af3nkB7U1SJs+w15hVTItUb5Y47mfZ
	gr0nDFoWco0wQA3oc+p0gxtIOOZtCI5NAiukLNCLS+maq4n9ry8y9w9/Mcve8RRIVJ6jxO
	iV9E3L7Zcf10612RA+NECg2IY6qiM7s=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-9 (Postfix) with ESMTPS id AFB2D18000A8;
	Sun, 17 May 2026 01:02:26 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKBUMDRQBBCFYBWANLVxQEC0AFBlgARnkRUAFYHlZeWhdeTVEPDwNKEAJeBV1yGVoUXBhTRVEfVFhBDgpaBFBRHV8CCgRHBFsXRgNTRUEEFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxlaFFwYU0VRH1RYXgRTVg5CCUoFXQJaBUAISAFdBUUDRAtKCkAGRkEDUUkAXwErWxNVF0YJGQhdHQdYRxRHDg8ZWhRcGFM=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1778979750; x=1781571750; bh=KZvJZ6sA8BqOCSFmfh6e6tNl4NE226dSLmvr6UFm2Fs=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=BgdpwqtnKYIDnhy/U6B5W2QGX4O4En3K+2N/ptpstJ9QR2KL20o4zhKCEcHDDOWeNmfzc1jcUUQbksdWNDcctuBhc/1oC9gaZO6HnrfleWNSPC08au8jg2c0RAznwSHFu8nWNzsJl23jD01Cb8tfWDQ8IaPalCMICe714P3SLAlatNWJ/a3bpNxQCwsS7O7k+FgK07S/lq0+XzRFiMcerlWSjMeN3LtiQQvg1XzVOY0/ZH6H4S2PfsbSXxkzcBufJ+hyJZhzzAB4+Q6CQ+37wCeD+MjZs3ExbdNczo45LOtBDEufv5g6/hSJDxtViHPQuspfG0Imyu3zTlMnls1b/g==
mail-alias-created-date: 1778972301885
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-9 (Postfix) with ESMTPSA id 698EF1800146;
	Sun, 17 May 2026 01:02:22 +0000 (UTC)
From: Sakurai Shun <ssh1326@icloud.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: Sakurai Shun <ssh1326@icloud.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] docs: fix typos in design.rst
Date: Sun, 17 May 2026 10:02:00 +0900
Message-ID: <20260517010202.14229-1-ssh1326@icloud.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260516170847.146524-1-sj@kernel.org>
References: <20260516170847.146524-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: RzyQ07uK6sRGQGqmE1AXpUZWNipFyCnm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE3MDAwOCBTYWx0ZWRfXzqH9oquXREoN
 b6SLt0Bu5KTSDylCqPBHENuyxbEeAOCmvboxbMvwF7N6gDbdYKLlWZ5l9R4U8eos9mr3silBiN7
 Ctt5ZQyeAOCqQOvgVGp11q/UAUbGI7liXXE8W/gKDmONyUEvtQvg2aF5Rtrr0GQS0JmNaKqwV5e
 tBtKH7GyHe3l6ZKMc2F6qARVnJJQkIGMIa7Emp6AFiukuTp44l1glfMpNCVg5/KJEctveAeFlBW
 16POtcNZ3VTX7e5UDz5cppqobq7lVii58G8E+NoC++z8U303YZtkrlssVyG1xyRub9sngD1e5FE
 D7RTMP7gRHA6vAwzMW+fOyDIKCe9HwIHjr7UnarWhfu2euM0wibFvHRY7dmimY=
X-Authority-Info-Out: v=2.4 cv=FssIPmrq c=1 sm=1 tr=0 ts=6a0913a4
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=ZxuoajvSgW0A:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=_08Xcmskz7rbIMj_RqsA:9 a=IxSG75etxsVYPPdR13TJ:22 a=STymlzgejnUetJ8yQWeq:22
X-Proofpoint-ORIG-GUID: RzyQ07uK6sRGQGqmE1AXpUZWNipFyCnm
X-Apple-Category-Label: MjE0Nzk4NjU5NzY6JGNhdGVnb3J5JF9QZXJzb25hbCw=
X-Stat-Signature: 5uubjx8fubeba439mcedjq981abgywj3
X-Rspamd-Queue-Id: D5DD116000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778979750-682221
X-HE-Meta: U2FsdGVkX19K1mtBAV/br69au03zJx8EgpaNaOz/smnFegk4nnu0Gg3TDV8Oufdpem1pO/BosAd+9+MHPkPkHgvLKT0U35atvZcRWSS32pdxjudqKj3IGAwPktVbscgEGLg5p7ET0zyj4A8cGeLCJD6o7R51y5Ft/WZ/vhutTQxjDlRbStGJNJ8mqlNcoXBdt+WHmbGUKkkJAWY4cyvB1bs2zW0mkWhJbD8FU3t0LRRKjiJ+w7WsNh04yt5u6ddssxAZnSCiYQyx6XKxx1BSdByoJZTl0r6TPwWL32DUO3He7142u+ndGWB/a3Fee/80EmZ8tNn4LNRet4eNBE7ikit+C+lA1R39WnU8tmabycCj6JTl21+8GHdIAGgfyW5ZNoONN4awVmloZ2750XEvn7ZW1HzLkoFgo2eOf7yfyFMA2Svz6nCD+FG/JBVPfIIQ6Rg2l0ZS1SmQo69FOtugG3rWRwW76qnXaUAGkLQYCemF4XqYugLV4rIIHu2MgZrjAETquzKi09VY6d64zj5xADA0AerFM2KOfDkAno8Bxa3R5leRAMCPJz94tlOM4Ptyik/8X16iEjRgd5d262R+Y9DyRvKTSmk0rJ6fl9MeCsDhjsOGae8G8iPMSoZV8r2Ebw7eoNDG9mkEiE8kZ4q3ygUivwKzMwcwCWG5VBV1jt/BrqNt4gtcBkkta09laY7g5+DyMR+6rFcb//jf7cl1lrr+XgNoZ+0uy9AZLBWLKnH/Bs8W687OoxSHVWAZ3/m8uOkgQZ5YhK2tT1bIiAXllekJV765H02mSa66RjdE0oLDKSHsPM913n4b4qQ286fbAbPwzUDsdmmIaRXM1PvaJyiu5yh2dEYJQd5mwPh/IhCNQ9nb/pLNnHBVRwJBJSbUFiuW5eAknlGu6p0NKRcrDMIqiHTwPJ5ipeMaccdZK1NHY3AL8lO/Owfe+8/o8+RylrCRuzEklqE2LetdF0l
 erMRyX0v
 GqdfjwLMIeggu31fORmtRNOXg1dYw2bYjviQCrLoSkVbeYCbtPkVT8ZUG2RxT59uauvYY0m6NFmy5B5aueGLmSlXa0QBX6heC1R3YqXD2ZI2dS494/Uup3I3nkFxLmjYDXo6D9aQLQApKTzsYU031QhRXndNv5h81L5jRHu9Vzmvf4Rrf9f7DyfC7QudZSMVTxXMPSuUL9QQR4O54OijHg9vFgPd34ojOn0w8lBJv1uoIs8DLiumHJQ/b2AOJ6oXPIZrv589VwYb5GcKtPSvAFRDBEAeOFlkilPR3cK/SdK+ll8Bo2taXd4O+Xuy3mnwftQpAO09F0guTY3PzFU8glLhSBBCGVeVAdMsfuDdbLxeI51rNfxSC5gnTjIKoX/VABJ7I7N97FuE1Bth0iCNQIz6dlDulHIQJgPYIVGN0vFCcxUTmquP8qmeVBHyZED65Qn6+ZzkTj+T99VI/3R0han97NYHNMGrXLnfZ5EjGwY4jfNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

L140: "unsinged" -> "unsigned"
L371: "sampleing" -> "sampling"
L387: "multipled" -> "multiplied"

Signed-off-by: Sakurai Shun <ssh1326@icloud.com>
---
 Documentation/mm/damon/design.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index afc7d52bd..9cc70a296 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -140,7 +140,7 @@ as Idle page tracking does.
 Address Unit
 ------------
 
-DAMON core layer uses ``unsinged long`` type for monitoring target address
+DAMON core layer uses ``unsigned long`` type for monitoring target address
 ranges.  In some cases, the address space for a given operations set could be
 too large to be handled with the type.  ARM (32-bit) with large physical
 address extension is an example.  For such cases, a per-operations set
@@ -371,7 +371,7 @@ with theoretical maximum ``nr_accesses``, which can be calculated as
 ``aggregation interval / sampling interval``.
 
 The mechanism calculates the ratio of access events for ``aggrs`` aggregations,
-and increases or decrease the ``sampleing interval`` and ``aggregation
+and increases or decrease the ``sampling interval`` and ``aggregation
 interval`` in same ratio, if the observed access ratio is lower or higher than
 the target, respectively.  The ratio of the intervals change is decided in
 proportion to the distance between current samples ratio and the target ratio.
@@ -387,7 +387,7 @@ The tuning is turned off by default, and need to be set explicitly by the user.
 As a rule of thumbs and the Parreto principle, 4% access samples ratio target
 is recommended.  Note that Parreto principle (80/20 rule) has applied twice.
 That is, assumes 4% (20% of 20%) DAMON-observed access events ratio (source)
-to capture 64% (80% multipled by 80%) real access events (outcomes).
+to capture 64% (80% multiplied by 80%) real access events (outcomes).
 
 To know how user-space can use this feature via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`intervals_goal
-- 
2.54.0


