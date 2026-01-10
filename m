Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 040F1D277D7
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 13:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460956B0089; Sat, 10 Jan 2026 08:25:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3E66B008A; Sat, 10 Jan 2026 08:25:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E35D6B008C; Sat, 10 Jan 2026 08:25:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0B76B0089
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 08:25:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A593B1AB4A1
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 13:24:59 +0000 (UTC)
X-FDA: 84316124718.06.D94B070
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DFCE420004
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 13:24:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jdjV/hI9";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768051498; a=rsa-sha256;
	cv=none;
	b=eGI1ePYVCWMv2/LxI7KZzz8jf/zcvg/ptLqb4fbQCrV2aqDVLcOXLIey/GhMP+c/KRtbM/
	OT8zHPTg2BECUrAIac1i01YESAPW6Ubov1oWpQodqQ65ms/t9jF/Ug972snDFvG6jIukn9
	KJHM2a44TyRpACf1PNAX4Y+2p6W9lBw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jdjV/hI9";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768051498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=t8hmhKecuVTGXZjRDkn2ex5jlI1GPUMbmXgngKLupKI=;
	b=bIde5RPkXwGILLteuK090a38uebCRBCS3ui2o3Ti6yEX8TU+LyoYik0jPGC3Uh021Tk779
	wW8sEOmSy4CMuRx/VuwMwaAej59s5k1bmhHKkDat+pBywDu3I3sfsZc4WPvCzIvJpnkttB
	sXAt8t7waQrtExlcpgaYcmXv0yIvUuY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CF5F418B9;
	Sat, 10 Jan 2026 13:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66204C4CEF1;
	Sat, 10 Jan 2026 13:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768051496;
	bh=XA4YqUHgVUeiBE4BwIy5hjNCCWAzL6nLNBDSXX3oIa4=;
	h=From:To:Cc:Subject:Date:From;
	b=jdjV/hI9oazcXsnapq++rNYBetnJTCDRp1y0SsdGZQ9mJvOp4uDsRJuu9Aplp/pjE
	 HIli9Mc6YG1zVJccQyojy4dbZEm0u0u4oqLZIIaPPqIQk1gEft9lfyQr1QjAxOKyRZ
	 LkDNJd8y+kK6sZhx41M5sHN/+wXzT6K9oHq22GKAvQtGfMG0ZOQ5pXrFSqjvIamnoA
	 sbYPtzN3H0SeI5hZFjpVtV4Xs09wTfH9c+M9in87y58XFTClsTJumtBme2vHTUZXd0
	 +xxvB8838GPVI5655N+E1lN3bAxlk1c269Qf3gVOwp/Phtu80PA3RUhJ7ImjXJNgsr
	 DgFUeKAtm/45w==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: LSF/MM/BPF: 2026: Call for Proposals
Date: Sat, 10 Jan 2026 14:24:17 +0100
Message-ID: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3604; i=brauner@kernel.org; h=from:subject:message-id; bh=XA4YqUHgVUeiBE4BwIy5hjNCCWAzL6nLNBDSXX3oIa4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQmBTNfW5TyusdikYe/c1Vxhbhzj9Yb+TkB+0RNHjjt4 fm3coN6RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQEmxgZzpoGuQadvLVQvthV 6leEY91rxzlTngl7mvFk9XC9OZz4iJHh/sXdHe69W85W2X1VetGk33XRcSeThHbBCvFFKWFM3Yu 5AQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DFCE420004
X-Stat-Signature: hq6uwo3mxrpuz9z1c5mamqpoewp43oxf
X-Rspam-User: 
X-HE-Tag: 1768051497-406855
X-HE-Meta: U2FsdGVkX1/j3yigzIhSy5xc9CNnW6PlEGPpgAgWEsyIJ4qweKHpjFpGpoIuNX0k5g0EbPr/3NzDn9iswJ5Bw380xovVmZggms73A2OSWhn1hphuzgaEG6hXL86Nwda0JD+Nf9CqanUW1lyqVamD6VkQ/oxr6dtchL3B7xVLmCzUGGMirXzskb0vQIbsm/ZjnnQvuhsO7mr+2etN+DFYb9j6CuWV6iih3AmAa7EgwHEL7tSVVcsArTYuu0H/BTBV7UYnHLuKP4PhatsWwTZx9wHO364YiO82Jg4ssWmpDO2ZDgwZ/BVc4+woqemRgJK+AjdM1ho5oSsTwcqOH/jQxYWlS8qu5P1N1Yf0nB9Zy6mAldzefcb/r8mNDBB/JWP7ax1udZWoOv46k8TVENBQdMlAh3qkQYhOfbslSqwjk5Z0mZ2T92msmMp27Y8x0Nd9aICA2geREHabMDc8Xw+ZNDJIBh0R8WNIYIoMrrqh7WLKMzL1HbnOHEx9pbhq8tgyi8UuttkSlhdebSOuG5PkbuPCXGtxSih8u9GO1JQIfP9XV3v11/afGQwwnN7fLcfh0gsvq5IE4eiJ4FePBwpsqTHlxMXBr3iW5T9T7Kg10B0QuTinmsmNKaV/kGeLl8qpHV6gVoBNQMmta5/2tocdTP4A3wSnkI6+BSaeeh6MHQVDnJes4l5xyBVgqD1VQeCpFpZBEhnq5JZiwzPUGGjeg+z0D3mIgWWgQT8dveN8hYwILyM5VqbY7Iss9iyuixjcqQhaCWXPOJF1Bayxv3xi+rO9m98+cJcma00WDZXkkTQyW0auubo3QS06dXkKZ5SZfvzk4KOZHnQF8d3B6wzCCvYM1c6gwtbMw6efuQNbzZEDUx/IjmXFx6YONIR5m+gMnzUJC4N+85+ofkAEMXKflNIaGpQFhQeBTQLDpr8jcIeMSEnHHu0Wuu47Vw62Lyqa3jQwnBdOeFll9oRcdwb
 d7n8APFW
 KpyjYlbqM/32dwXpoxnKGaxexbAP8NuvKg5R6fO82exKohjxcIjQdwRW3di6CC3urDT6xu95Opp3zKjK8rwTzP63o/aMdXwGLXRKklDLkEllWP/KQ5X7KldutF8vhZIVb/KGSZAACF66U7JMIji+B9z5vVUC4UR7Mgnc26DRAJnFpXzmO12C2TEjmMHRVvWslKFiv+F4aO8MtgkR7B+73+0Cvh/pVSk30nyWdajEM4lOaKFhPPxc+HnEFb7TuVvLhPcdLv7nkUkK+mXPcz/p3SRaQbWEWlcTS8palpT6xD1wLwGJHJO7VEFzyk3p3pgp4HpkDxGvecPf2uza7xWkQ/ZY2YuTrsZw/oHFqa/IFY1LSmZXXG6dcGkOnn5CEevEGWG2AVGlXfxiytqJHXt6kDOy29wvy3vRNSXUKfJ9lc0303EBGmWfTawiyL1H2kabBONdAqyYqMcc3xOwTDmTXleBI/hwqasKhFJqeHw0KUZ0G1x/RTsqhVyTrLjLUzL0OhoOZgAnwhQwHgzHQ+dZvtc4lh24CvLTUDgJ7xvWQsULXty3I7UwhzpU2jaReN1d269gwVl5ILLt9KGP3hE13tc7LHGe+SaKxpijALbrjihLEz5i2QG++mRWR/+ARwidUkVG2DCBBKlBkZeo4xGtXRqwjcz4FO9nQplmIvULUOG8Yg6XyatPdaIjb/5LAEmdWCbqqRCn4aXmm7apu07jn1hiQFZy1m7qEeWO6QPH9oD1g/6Inla//kv3Ck2styFwevWRLnTjn1Rtkvj5hlkkIuyvJ6LYfHwDGVegVXZ+TdOAGbatR2rGX7JQyk4ztHxrHo1/dDwKi8LI9oizVosg46nfXsMQ7WWfujaactJ+v/m7yt5hEkaia38ugdoDkFPclyzUc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The annual Linux Storage, Filesystem, Memory Management, and BPF
(LSF/MM/BPF) Summit for 2026 will be held May 4–6, 2026 in Zagreb,
Croatia.

LSF/MM/BPF is an invitation-only technical workshop to map out
improvements to the Linux storage, filesystem, BPF, and memory
management subsystems that will make their way into the mainline
kernel within the coming years.

LSF/MM/BPF 2026 will be a three-day, stand-alone conference with four
subsystem-specific tracks, cross-track discussions, as well as BoF and
hacking sessions. Please check out:

          https://events.linuxfoundation.org/lsfmmbpf/

for further details on the venue and hotels.

This is a call for proposals for technical topics for this year's event.

We are asking that you please let us know you want to be invited by
February 20, 2026. We realize that travel is an ever-changing target,
but it helps us to get an idea of possible attendance numbers.

(1) Fill out the following Google form to request attendance and
    suggest any topics for discussion:

          https://forms.gle/hUgiEksr8CA1migCA

    If advance notice is required for visa applications, please point
    that out in your proposal or request to attend, and submit the topic
    as soon as possible.

(2) Please send topics to

          lsf-pc@lists.linux-foundation.org

    and to the relevant technical audience:

          FS:     linux-fsdevel@vger.kernel.org
          MM:     linux-mm@kvack.org
          Block:  linux-block@vger.kernel.org
          ATA:    linux-ide@vger.kernel.org
          SCSI:   linux-scsi@vger.kernel.org
          NVMe:   linux-nvme@lists.infradead.org
          BPF:    bpf@vger.kernel.org

(3) Please tag your proposal with [LSF/MM/BPF TOPIC] and ensure that
    each topic is a separate thread.

(4) The Google form has an area for people to add required/optional
    attendees. Please encourage new members of the community to submit a
    request for an invite as well. Maintainers or long-term community
    members can add nominees to the form to help make sure that new
    members get the proper consideration.

(5) For discussion leaders, slides and visualizations are encouraged to
    outline the subject matter and focus the discussions. Please refrain
    from lengthy presentations and talks in order for sessions to be
    productive; the sessions are supposed to be interactive, inclusive
    discussions.

LWN has covered previous iterations of LSF/MM/BPF extensively:

          2014: https://lwn.net/Articles/LSFMM2014/
          2015: https://lwn.net/Articles/lsfmm2015/
          2016: https://lwn.net/Articles/lsfmm2016/
          2017: https://lwn.net/Articles/lsfmm2017/
          2018: https://lwn.net/Articles/lsfmm2018/
          2019: https://lwn.net/Articles/lsfmm2019/
          2020: 404 - Cancelled by The Plague
          2021: 404 - Cancelled by The Plague
          2022: https://lwn.net/Articles/lsfmm2022/
          2023: https://lwn.net/Articles/lsfmmbpf2023/
          2024: https://lwn.net/Articles/lsfmmbpf2024/
          2025: https://lwn.net/Articles/lsfmmbpf2025/

The program committee for this year consists of:

          Javier González    (Storage)
          Martin K. Petersen (Storage)
          Christian Brauner  (Filesystems)
          Amir Goldstein     (Filesystems)
          Jan Kara           (Filesystems)
          Vlastimil Babka    (MM)
          Matthew Wilcox     (MM)
          Daniel Borkmann    (BPF)
          Martin KaFai Lau   (BPF)

Thank you,
Christian Brauner

