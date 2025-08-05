Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A848C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57516B0093; Tue,  5 Aug 2025 12:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE16B6B0096; Tue,  5 Aug 2025 12:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9C56B00A0; Tue,  5 Aug 2025 12:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8292A6B0093
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:21:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5EA4D13508A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:21:10 +0000 (UTC)
X-FDA: 83743218300.07.EA458E0
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 897D6140012
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:21:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LtrK5zk7;
	spf=pass (imf26.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754410868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2I8Y6YCxsX4TWyWrlqz+OvW3M3f6/2nWl2bm4+fH+c=;
	b=Y26ZVLvM9p3tuBMjVQRNgcWc6BBRyWn41Z1vNZ7a34djXwaIsRzrNnKIsqGuhR/FLFvWeP
	AAIvclBK6S8xsLIHwT8qaCWcsOb1j+lXlqxIC9J2xYs55BjKmXcEC87j3SnZd3IYAkR6Xb
	WL66ZYbvieJujM7A2TXcdRcbm6siXg8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LtrK5zk7;
	spf=pass (imf26.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754410868; a=rsa-sha256;
	cv=none;
	b=d9MCwV/ZbBXqobmEKYO/2ImerlXCcz8+i4FCiR1Ckg0ezAg6b6o63+MJIWV2WJVzEFip/O
	WJs6YMQQsVQAU/CIDQFPEBG6Re8kErRzOo/y2KZBwpRmXu/0iVAOJTQUd/zp9n7VOivBXB
	cN7MGMn8a3tQwK3vRDWIggawkjhT17Q=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71a3f7f0addso54026017b3.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754410868; x=1755015668; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2I8Y6YCxsX4TWyWrlqz+OvW3M3f6/2nWl2bm4+fH+c=;
        b=LtrK5zk7M4oYOhao+gdy7CaznmqXPkqxf68zbI/NyX39AvevK/ovPnWKmcrKHaUfeW
         Y7qeVKRKIVsifRf1/aZMvxwEJIeqmwZnTnPkykPJT0QNMctIF/8TeOpwTNzvY7NR0nde
         O1mSXdwY94CUbQ0zcQWgm6rL3ZK3RXpAdkenbokCrIQkm/HgxwGmdvsq4IA2KNP9L34H
         YGIhL5Yt3mQti21maTq6YoxQzY+XTO4kTiNk8hhi1dynDEu27xGLq3cjM1dG9YCJFvgP
         BX9Pd5qAXcNKVnBCLcTnfOqAgnSXIRLB6QZ7xlH+ntHr9ZfKMBEhKQHBIIZV0WRWCw4p
         DqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754410868; x=1755015668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o2I8Y6YCxsX4TWyWrlqz+OvW3M3f6/2nWl2bm4+fH+c=;
        b=eHETUdlDMfZ6VCgC3Hv+4X3L55gFQkN7IJVld3AK3w6EoEwYi7L6IKaEcN8Xf2EdT1
         oxb7PfL/scGKZE2Lb0tjx/Bnb5NPAPA5zoQwnVjB4Pq96lie6nJ8pB/vpibp7EZMo3AT
         XbEkJQCRfMhoxZv2q4m8CrRAx/Zzry3j3ZeNMw3g/cFPNBSjWAXLsalV99l6cZVqG+4r
         vT3vTs6QdmiFKfwDb9mcNr1rEQThLeG5B+qkKMk9KLxP5AuhW8cLFm3cKxKojjPcW4o9
         nF1QuJHL10haZ0R5wx1EFMN5YeucK9X+SrWNmz5Vp4Da3/3kq3lrxIqahGjggnnn/GIL
         iCOw==
X-Forwarded-Encrypted: i=1; AJvYcCUmjaOv+Rg79YDOnSz8l2i5WHnPaFh15Fj2PrYZS8Wh/SQ8qEJwmYUBLgSWlEFPZtNHPQyqzLTvrw==@kvack.org
X-Gm-Message-State: AOJu0Yx9yntYkuhwWgy4eMyw8Rge0TwEDKvwXbMUtkdwLBlb/coFI2WB
	nNegYQo8/uCe89Uwp2+cuZFZIV1iFnsOsdIXNAdYm4SFWY4NUfvq+9K7
X-Gm-Gg: ASbGnctSpb/H0L8UQyUESx6mauODRp+XKNYqTmw2/Ug11/883DZ+r/rX1SStjTmngzg
	nXUTpFX9JY5TxyfXwypXxnCXAwhIR5SHJ/e7wHMou8i85LsccKOZ6uOMfKMe2Drl2NZfMPXSD87
	/8jAfRLZsCpJOD6XFb2Z8i1sq7d3XwBdVPfmkyhB6rM4xXyr3LfC9Y3TRpPIHGDZILvA7/tYpvg
	VDD6JGzs+8XF2+5rI2jXomG3Fw+d1nUJgBO+OBJxlMvSgxUth1X+yuS41a/4cO4aUvtEel+bcE9
	iewUf29ZX4RFzvsVna8MNQmKTRJF9pF3y+ZQIY8UnBDY5S8M1XJJB0V5Xu7gRuUfs/V5QBdOZeT
	YSYK9+KTZ3DHkyfpvBpL542LMjRDKBk6TGN/IdhHKs8w=
X-Google-Smtp-Source: AGHT+IGS4lh1JrnZOMCC7QWGY68gCUxCM5gOUlyEM6e/iXESyuVJbUue1PFdHnmYU2Ldv5Xe1WJeww==
X-Received: by 2002:a05:690c:7107:b0:719:a34b:5e50 with SMTP id 00721157ae682-71b7f5950d2mr163236987b3.21.1754410867586;
        Tue, 05 Aug 2025 09:21:07 -0700 (PDT)
Received: from bijan-laptop.attlocal.net ([2600:1700:680e:c000:2c65:e45a:e7d5:5f0e])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5cdfc5sm33098757b3.77.2025.08.05.09.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 09:21:07 -0700 (PDT)
From: Bijan Tabatabai <bijan311@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	corbet@lwn.net,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: [PATCH 5/5] Docs/admin-guide/mm/damon/usage: Document new DAMON commands
Date: Tue,  5 Aug 2025 11:20:22 -0500
Message-ID: <20250805162022.4920-6-bijan311@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805162022.4920-1-bijan311@gmail.com>
References: <20250805162022.4920-1-bijan311@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 897D6140012
X-Rspamd-Server: rspam06
X-Stat-Signature: goxx1nnqtmni5mw818ndsq567b5yswms
X-HE-Tag: 1754410868-81541
X-HE-Meta: U2FsdGVkX18mHfgQ3RkwfE6RVywRKRKkggcCmfdTYhlvo95tqATnNnFu9rPJIvbY0j5m6Ghm0PYIGQ4R8X8MlBWiTHlcIDlP4hjf74meT4fGO04Kj1Tbrz7pzPSkvzvo/4wOiYn+S0KVg3fNJpiD/pAycIPCdqBMa7VDcpNWjXp3pmMvIaEKekjJmQoEblH1DKnYZszHNrUiva0D/z/XUxs4FhCKyU8aNsrxYFyrFERrpCvcN+SRDMdXJhysf5iSgXUYpsqqU0Lh6PSyobrUQ8pFAi+uVdGWaSTec94ibiD5BlNRNu2/t8WxoCcmC3U39N0PR+pPUv9YUm9CyeAgDpoKpdRy4Bgjn22K/wlQ46d2F4+oxGE7DpGSO7e2TscrSjyp1+iPrLKRRp1nuy733Nzh5GslFkzlVTMZpaOER8pEgjjSpy2ZMKcuedR2SuCfbSEEfyQaVHH3EwDkMWgPgOB9SfBIBBVFnlhvia0+OW/2ZbMWUuIUP/blIxPyN87Q14vaTv1iV9vndxHxpgL2Xiwq/0Tkymt5f927jA0pSAp5Vp+BmvYp2lywWkwmtyK9w+q1nqyLCAqTlhPBGBgEhUWzIqduSvv4zKwWhcSfX4vU+QnYmAm0Vr5/qvNZ1ncxAie8ojORlrOHjcvBIuTwOoEIlk3eGNfeHGhxXD1RYuUYkakX5HaeA+qP3j+mnEMp9RosI465xv5OZpt98RuohmxH5YHs+UYpEdc9c3nIRtLqEg1erlhTlx4koDt18Y8UP/O8sNszMO69hB0WhhWT6c5j89kUNaY9m/gmwmRPnATx25KhtDeKxrQeF0x+8WtXH5aM5kj79m5xV4zcIycIq/NB56S0pC3M1DiC3smUR2UFsL+P6Dsd/tvKJyTqDF6r9/N9o+MnNO8G0k6sMFlMyy3VLAS35+mD2+QfUyZAplf3+zZdCbgz2xT/c6Mxh9Tfy+6HT4Il2rWrBdgZfkT
 jZLfSHNi
 Ba58ZN4RZ9rVg1x6RJck7gyujwsXZDNmTxTg90/RRN557MUVactA8UOmmiRPCW5ruKrHyt345i7Yku+2lqeAjLV4ClA+50JdqJg6rIwmhwb8Bc4A0FFTAkEEcrpw342KoU70yfrBkSmATQniEvk+CbgZ5oWldJMKa3gzd1uJpq/BETw36kO8Ik0q7ZsvOR0dIKfA6g9OElhv7H7dG7gD6qkNIenDIEEGMsgxe1WcAU2YTpYnmYFGehbE62awgCc6oRRwh185xysRv4m4gYkHxBRvHSDzDJ6X6I6czNhm59A4WB5tfoPVklY44Nis4Wjb6ZCY36hbsx31HUNDqKIYRhMVr3HtM/k8WU3i3uKEyadsW/T0BjEm7+Eb3kKpLixvLPMujoqHin3eUiyz/l/nXNmcwRXuZEI1XT6dLppvWYZepxED3nPyLp4iWcd7mrg6KagapGwogM6RgpiPgDl/fo2chZGQNKS51c8Eol4UZTL8e/z3ibWPlZfVDjn/duphr/95bixbBpdUvgfxTEUGcDJS/NQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bijan Tabatabai <bijantabatab@micron.com>

Document the new commit_schemes_dests and wait_for_schemes_apply DAMON
commands.

Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
---
 Documentation/admin-guide/mm/damon/usage.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index fc5c962353ed..46b6260855d9 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -142,6 +142,8 @@ Users can write below commands for the kdamond to the ``state`` file.
   for more details.
 - ``commit_schemes_quota_goals``: Read the DAMON-based operation schemes'
   :ref:`quota goals <sysfs_schemes_quota_goals>`.
+- ``commit_schemes_dests``: Read the DAMON-based operation schemes'
+  :ref:`migration dests <damon_sysfs_dests>`.
 - ``update_schemes_stats``: Update the contents of stats files for each
   DAMON-based operation scheme of the kdamond.  For details of the stats,
   please refer to :ref:`stats section <sysfs_schemes_stats>`.
@@ -158,6 +160,8 @@ Users can write below commands for the kdamond to the ``state`` file.
 - ``update_schemes_effective_quotas``: Update the contents of
   ``effective_bytes`` files for each DAMON-based operation scheme of the
   kdamond.  For more details, refer to :ref:`quotas directory <sysfs_quotas>`.
+- ``wait_for_schemes_apply``: Wait until the next time every scheme has been
+  applied.
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
-- 
2.43.5


