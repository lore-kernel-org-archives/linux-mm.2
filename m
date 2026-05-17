Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AC6ECD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 07:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7CA16B0005; Sun, 17 May 2026 03:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D176B0088; Sun, 17 May 2026 03:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A056B008C; Sun, 17 May 2026 03:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7C8E6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 03:35:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E9ADC2187
	for <linux-mm@kvack.org>; Sun, 17 May 2026 07:35:05 +0000 (UTC)
X-FDA: 84776100570.12.96BB709
Received: from outbound.st.icloud.com (p-east2-cluster2-host1-snip4-1.eps.apple.com [57.103.78.4])
	by imf14.hostedemail.com (Postfix) with ESMTP id 76D27100003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 07:35:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="G7vjuzU/";
	spf=pass (imf14.hostedemail.com: domain of ssh1326@icloud.com designates 57.103.78.4 as permitted sender) smtp.mailfrom=ssh1326@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779003303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KZvJZ6sA8BqOCSFmfh6e6tNl4NE226dSLmvr6UFm2Fs=;
	b=mZsiN0qTaMfnAkTrcUfA9G7bOxUhtBgMvf+hTaVZ9qfQuX3itMRUAil2S3ZPEg0kW45yyH
	lGXOo1D9MLDdFK9mIoBMlS9lB+zE3Um1j6OJEMcDz5s6VJL9aW1RnqRQdh+17e85ZGjh5z
	1WltvPCkWSzwJTF1k2vt782uz2sq1Qs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="G7vjuzU/";
	spf=pass (imf14.hostedemail.com: domain of ssh1326@icloud.com designates 57.103.78.4 as permitted sender) smtp.mailfrom=ssh1326@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779003303; a=rsa-sha256;
	cv=none;
	b=y2YRw7lO7usitCocxgFFXUnkANkU3lRBcsOPLjs+6lWUVMdPhNg/rJ7FrnrTaavHUps2Wa
	lSw/SGdwkhXT2Bhgz6wv6mPRhWF1jpO2t+3PlrfnchNuXCCUNqp8xH7730me00Jn3BbZy9
	wdEEj264dfP9YV3GlZKt6JIW4sDMgzk=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-1 (Postfix) with ESMTPS id 4709618000CF;
	Sun, 17 May 2026 07:35:01 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKBUMDRQBBCFYBWANLVxQEC0AFBlgARnkRUAFYHlZeWhdeTVEPDwNKEAJeBV1yGVoUXBhTRVEfVFhBDgpaBFBRHV8CCgRHBFsXRgNTRUEEFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxlaFFwYU0VRH1RYXgRTVg5CCUoFXQJaBUAOSwdeBEUBQAhNHlwaGEEYCEsBW3cCURxWDVdDVARfThkMSh1SVlsTVRdGCQ==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1779003302; x=1781595302; bh=KZvJZ6sA8BqOCSFmfh6e6tNl4NE226dSLmvr6UFm2Fs=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=G7vjuzU/6HgOQQbCiaECZ8pNmlTN7KCrEhYqEDWRlK0Ot63PM2g+8ygdPBS7NH0K8CdBAgH1AJ0uCw6ys9Xk3qPvZn9O1Yi/IDYx4mJf8w+IncikiKMJ28/uoRPvmrP8sHRIZojpzuO1uymIW3/YAQmj+U+gbnMbCJCin29pjG3VQtNYWd0oFQ/9dGg3fMTaycOJTJQDzNRPk0E83TrcQAvoBtVR5xQMQEe6d3M3zsFAHswvQ5miKjXSkN7iRu2G9/cQp/H7Fp17GTkFT2MNfpFmzOCRXJKshS7CNWWxqrSYrlKSw+Bja8NGcTcr67psiw5M0CKZYi3UYRNcpATaUw==
mail-alias-created-date: 1778972301885
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-1 (Postfix) with ESMTPSA id 428301800302;
	Sun, 17 May 2026 07:34:57 +0000 (UTC)
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
Subject: [PATCH v2 RESEND] design: fix typos in design.rst
Date: Sun, 17 May 2026 16:34:26 +0900
Message-ID: <20260517073433.3015-1-ssh1326@icloud.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Gu3jiF3L1FKapOQU1W16M9Hnzjx67DJx
X-Proofpoint-GUID: Gu3jiF3L1FKapOQU1W16M9Hnzjx67DJx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE3MDA3OCBTYWx0ZWRfX5a2mqMHFYyPe
 JbrDuHWXfmYopx6ty+qt2kqc0lvIlqxSjkZWfcAXImEmj6aPHQvEDfHTyCRtlMrPfcmXnlea8z8
 HXmoi80TEs/9nLOYAL0U4DPXU9zQsg9bkmzK9s00OlBkRIPfc6QT7+kGRcttv/LWUgPHfXQERQP
 qY78tEuS2fk5I+KXGozOM7zzo4iN+mYbdk1d/kOq5GUW8Jy8gwjGmh4bJP4sJDtS+b4P4dGFOg0
 tKrfqng0qAwrpfXyO8dYQp+jjxt/eFP18EptuuDMXVP1HO5+WuBItdxt71BMjIo+t+eTCTA196I
 ygawgfNXbvEc5NyWjEEctDFGG28eyYAcaCAzeYGsojHvpKISvHoj1sg9Vxz5xM=
X-Authority-Info-Out: v=2.4 cv=Wtgm8Nfv c=1 sm=1 tr=0 ts=6a096fa5
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=ZxuoajvSgW0A:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=_08Xcmskz7rbIMj_RqsA:9 a=IxSG75etxsVYPPdR13TJ:22 a=lOdrInXjANxufYs0I0OZ:22
X-Apple-Category-Label: MjE0Nzk4NjU5NzY6JGNhdGVnb3J5JF9QZXJzb25hbCw=
X-Stat-Signature: 4mew67bemsxj9ynidz7py5ko1upfiec1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 76D27100003
X-Rspam-User: 
X-HE-Tag: 1779003303-376953
X-HE-Meta: U2FsdGVkX1824A91akwp8buKfd4aNa0g8aQd/92oKqr/gj/iab0DLcGGy31FuuMXodCxDEMyGjnrkfmFZ6ngZz7w7uPD9VJv3XBhIpIboFKrTPcGBCw6CtgAz/M1S9kMeRsODxsLIExjCrJ5V3zepS9C8Lt/2K48peyjgtDqUiZn/QzImWrZELW9K3zfTshen7+AoiZECJqPAvV7lR474BoWSOjPlRtGBdGt65q3oHpyfcNPn/3KoT5zoo8ZrXgt2v70SOS7kJSHzvLINjlDjHUf5LbSmdkxnUrCVbDzTFbbzIDgrRm4DJhp9HD0T35W4GG8K2VDUhtJ3WbLnA3RvRU3IRx+KZe0nFwPByo6SkZGy58iMj7qkYYBCOpM2WpCaf2BiVWFz7g+BOvJwfY7LnNYx8s9PBBUJoE89uZZsR/d9jKAT+bG9F28QesT9B4sR8/x3VKipgh2IW5wgOUqWEaj9HBZaTqw6DYpj+PGJfkN+A6gBcKtK5XqwMWvd2EuqRxG0+Jdv30pi+65hlHtvFSM2LHiPRhDtWAgiR8JqhNI4mXx2AXsfdKJ31H1YPA/uKT2XYPFpVtYhCWBW96GTuMA50ZnFn8IbWB7zssjGAR3BGOWGyTZKRsrisubXYN5fm6HY3gurL5gow+vGAAeHMyJqzXmi1vOsORoIHhq5gELxXJ+kDWjBXb+GiXvTibJrGnOkKprg1FmIl5ozd8ldDBzboSVGGQhMgb0GjY9Sp6nziOYurM8g8MlR/AQ0ReuwsDja+9SvVpOwhKYi8yIgATmQ2Oxi0P9m90xayF4P25J5tA3l66k/0ZyYE21/9VCiwRVyaM76CONG2DPmcpoq09n667+vNhkJ6ArbXCv8SyakP73lluYWHki2Px1tdLyNHuVqpfcOIWCjTKcyBzXHB/9MzAdw1YuievNwxcxlPpCF6BDeJOp4EmsgNiGAQ4bTswLuOmCsZG8G3ofZFi
 Fku3p38l
 PgprjSIkfNURlBf3zXa6fjjJV+x8A1Ez49j56i/PqoxdqQe2AJ5vtZ147xDq5CldyhWALEyri3S9IypEG6Agmr1Fn+FDC3CN2jS5MPIt6cZhB8wKcqI6GnTNpP+8cAS4qToWO8P2uVhcxrc2IwHJ8Q06lD+nHAmnARDIlMN2NKehJvKevPEXvuVUDZtLP+V4MK6F+Wbc48BbZC2WdxdgfKViE4JOTR4rGi0ujHpoE4AMHvAl2vvNEgtxOYpUgyxYLMR7A61Ct6pmLei93RpfAmRBsbpYotrl+WEjzH2tYsR8r/bV/0Dwr2xCZLQpinX/uYSnyukQRfkTw/82vO9HFXt3IRVGSSa+ZGCKcB6N8yw+ZvwPLndNiLU2aM6mkEoCY7Ac2vPxLVQHpoEI=
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


