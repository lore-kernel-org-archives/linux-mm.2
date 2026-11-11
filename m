Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393AC606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 12:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r0lYTis4
Received: by kanga.kvack.org (Postfix)
	id 1CDD16B05B2; Wed, 11 Nov 2026 07:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158096B05B3; Wed, 11 Nov 2026 07:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C766B05B4; Wed, 11 Nov 2026 07:42:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA30E6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:42:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AC6F802AB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:42:09 +0000 (UTC)
X-FDA: 85422800778.13.45BA2F5
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 50A9F1C000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:42:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=r0lYTis4;
	spf=pass (imf20.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794400927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OQ16sdEJf1gdJkohVqyloM5KBnz2C1+nxajXYYSElQA=;
	b=uH44mInE08SBU00HiiHqD6YRFYHjRJI/7HA3s0XXIkQneF3c1GSfBjeoG4TOsYc39U6HxH
	mu/dezWPuNkRdxeDA3hkK/oLqouH4/0NhpWq16D8FzskURbdVyK/qfnB9HG8MnlFaesqxl
	josnCLC68fQCgpTrCUAbDs+D/MBflT0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794400927;
	b=j7HYVDJorRvcy2EHVKEozqSzscU1XhDN60YZ6liKg23WB7wP5cZgy4k7rsGa0qrb8mxmcV
	r8Oimjn+gKVF0LMm5RYzKv0/DxWPknCx8W3p78pvJ0xzO5kGZ6ug/Kd/ufWvh+q/3wBbfM
	GRyVVVMooywxvX77EDNAQdTeOgDKJUg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=r0lYTis4;
	spf=pass (imf20.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-33c10faf6easo62736eec.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794400926; x=1795005726; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OQ16sdEJf1gdJkohVqyloM5KBnz2C1+nxajXYYSElQA=;
        b=r0lYTis4u1nv7tydfmx5tqKDt5EkR3EeFOTYmKgJ24129Bsr9zYnnZ6XFZY8fePmsi
         IG2S2i2m5Mpb0UUq+FcDEeFX9gYyzv+xXd11ZpCQoRuPKHaijI9Xl+9eh9mB1txZGJMN
         aNLwHAEFceZ29LCA3oeDlVO3TcJ68LkPRTNaygpF40vU1npKg2WvzTTajGNhUStx7s9v
         GHmAK338yMqaRdo54b/TsNCdXrb3orSRpuUHXj8WVULxllz5EjdtHwwWrzeadmPkSzLc
         O/wFiI8Paif2FYwGFhsxpf76z1QwKO4iif9hpmCRhefq1LYDCQYHFgWT7udnBGojNNz4
         /Bmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794400926; x=1795005726;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=OQ16sdEJf1gdJkohVqyloM5KBnz2C1+nxajXYYSElQA=;
        b=XMPFJ21MSkGjlYXCBt8KXOrsmxqUsfXGhUf0fdfV6DLZ4R2mVYjTUc6VwnvYwzxU0c
         skr+iLRvfQosHSwFfTX8A/lR9KIJiFxHXnVuUWdxzNocP47dnUby/KvNB71wdvDTN25c
         1Uu0HOlUpyD7eg13yoUMKZTjWdTW89t3TdT1Ul37IxyLGwW+6KQObPbV0dd55RxBlM54
         sQEBQkhPn+y05HsP04RQE5T78gpC51WyghDz1OduXnqPdanVdQeUsFGj2nUDonxf6Qay
         f6NCPBa6Qnn3+UitMJXFHQKSDWnSj5hYEW3FR8WtLUcH5NxF9S2g2YixgNo8e1KnY6Rf
         3Sug==
X-Gm-Message-State: APuU4Z8RdNWsyM4vi3wCrCvzNwiG2EYPKe1zfaG1dBRhzyIUBeZyjl5a
	ga4VFfFVEoTh6H7Be+pSUJpZFFPHxZSmoLL1v2J/mgqaLMd+Lac+NPFO
X-Gm-Gg: AYBFou3D2BVJLuRyT6szyYYuWmxltZuRH0kr5bxsPhAdt1j4YFWtrmfFggfjwbEN6RG
	tYVe+/7FIVwChGRZLZd0xBv76EGl5n+A2Mx4nD25iN/g3WwT4SYCCc3svQcLoNYQu4dsHasxm/m
	l2eKU5UMnWrZtL+tm9gNkJJ7haBjgVotRgU9bZ8SVKScjQ5twYxKUtAO3HUW66bfcfnq330N7CJ
	D3kzDWS2tWJlhXmnptEa3MQbzZGgR0pZa+H1nS9YquM04EQzJ7qX0ROyphtggsHHT19klp8BG1v
	QzjLAYccq9Lp9pMXwskEilohL3rKpRYFziC8tww3pyTaZhKl1KkN7dg2YjsHCvUUJ2DW/wJ2pul
	kSuMqY+Nx8RURUfRaajZSm5yB/rXQmoprSW6ZmEYr2tyf2P5QXpOTgzZVnrQMp6sZ+lOkWCaURV
	XEFFAdHUFoYlu5S+eQJZ3IOsSwi1kuEqpLVzRomOHRdx9wZLUdrmw5/7B0SbcwTDNGjb5thR+av
	sBxTR7Ytl/O31YStKxTNgN/nEG2KXmKXR57eahyr6Z2OVKGiFHcW6UFMyftvkMWC3rCzXS7gv0R
	2OSMUsvDskH2mJien/iHyRMi1CaovMhCWvfaZrnQCJFCg812EVse43t0LPIUJiXa4vM=
X-Received: by 2002:a05:7022:3a86:b0:143:5c2a:e45f with SMTP id a92af1059eb24-1b3c01600d4mr3616454c88.0.1794400925446;
        Wed, 11 Nov 2026 04:42:05 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4efc2sm13462032c88.15.2026.11.11.04.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 04:42:04 -0800 (PST)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Wed, 11 Nov 2026 20:41:26 +0800
Subject: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
X-B4-Tracking: v=1; b=H4sIAHVi9GoC/3WO2wrCMBBEf6Xk2dUmxlZ98j9EZJNs20jbSFKLF
 /rvNhWhCD7OMOcwLxbIWwpsn7yYp94G69oxrBcJ0xW2JYE1Y2YiFRnnaQbP0GBdO30OHXZAY2u
 k0VzkGRuZq6fC3iff8fTJ4aYupLsoiQuFgUB5bHUVKyUhNquvFox3V4juOK5s6Jx/TO96HqX/j
 vQcOKhNLguZc4mmOJQN2nqpXcPikV7M6d0vLSAFjUSSZ1uJCuf0MAxvI0pZ6ycBAAA=
X-Change-ID: 20261106-zsmalloc_stat-e261d4dc1276
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Helen Koike <helen.fornazier@gmail.com>, 
 Vignesh Raman <vignesh.raman@collabora.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, Nhat Pham <nphamcs@gmail.com>, 
 Xueyuan Chen <xueyuan.chen21@gmail.com>
X-Mailer: b4 0.16.0
X-Stat-Signature: kremiqxbpwwrzksqomtedz6xaxk8nbqa
X-Rspamd-Queue-Id: 50A9F1C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794400927-260496
X-HE-Meta: U2FsdGVkX1/baFHZu8WZss/Y6IEWbH7hgHzC1vl42tLLuwYRqQxrIYNhyGO5tBQfAHlN5NfRIarP2VWtUuzKX9BU3C4lIolZAyHK9avC+aZSptXbvYRTQ+RNALYonCFoQhqS/GrLK8UvSMHkwMj1oN6RbsBJBU5sbBYuQ5hw5u1Wz5mcXPmEDKJC6Re9lxcoQ6BasTWxYaagvH1q4Sc+RI8d17IbFv3JUtzqQ3O8ptJ0weKNjnId0OxljbRLszwuMTXdO9iZNGdYXdRT/4DBcAUiI+qQLpnQcN+qNwSyHWRRHdFUYzR1dAUB4F43b9L9xdIE507iXy7m/+z1zWbZ1srtVa2hrHXjf3WFM1HJstddh1NJoVPOLgWbHIPTXQS/IMAYR/gvd3jmqnrW7KeUnxTHTLjYsVndx5c2wSgtxsLh3F0VO1QrT9U6Ai6mjweDBo8iShSA/SCeVqvn85p3zwZ83WXhhZunha9kK+/OW9fJYeTiXZj3dqA0oP2AoO5oN+v79z1jZ6dwOYZmIW1m8VRKozIhhhpC+JY7Y9P80g8KGatXO3O9S2u1R4yGbvWBy67Flb1oaEp9wxDrkGqvSo21I8xpKI0DFpU2h/D6z3m2nSo547bY0y1qaxt4stnGH+Mfosv6xXXvrh1GyXZCfd6LV8bump0/3EcdQQRVCuKpCMHOmpmNiOpjt1fEm/XF9lbFRhaTmm+MIrP9ffPmi7P/idX3QlUu70HIv3DdVU7aPHoX46xEErcsPF40tsknTPzL9M2M1P2XwH48eebOkUr4cC0GKtfT2b+Cli2TLZNOUHiLMYY4QDcIuBLXtPPvh+pbjL94qmoOn8T15QAyBiibGrjT3O1fpqI0MNFMBG8fZ9vn53fBi1wLc6ZjB87O2e+8x2m0WgVDlhrCgRUo+hw6rk62hGB7XV1Zkv/NfqXPNi4QJqBKQK4TfOnuhwzsOXJedizqKpHdmvFERUG
 hdoTyMq7
 v+QeFiiuRYuBP76huz53H6QL0JfwLTmk4fCIvJdPMmdVejiQ/C6M8zws761DGBdEtWlLRndtxmzT0KRPyYQJZLj2v1duUitXYcRKDt+Lw3QNE9oDaR9mwSX2JunVauH9cNFLAxd0QJbR53Ec00VXG9AQnuALyvguwI4BxJRG9XFyd/c0wZNYxiL3+m4mYxsGJBZ31nkbdOadsphH/oop8j4H8gdNKIisqg199S4aRmE4A5wBLJuIJZ8EsodaSDVtHYHx34WNMqufizhu0CNB8Fm1b5s2XcwHyoUXuruDoRx1boOuakbcvwixmqyhcaV93JHssGdFjscXKQuLfLVr1yL3Nz5Un3EbOiU2UbCWkoXEAYd649ZdO0mlstUfcK7j82/m39yKwtg7aYFzLhmcNaJphTKTuTICxfE7VtkNzsncTyB1nVDUKwTkm+T6Evk2Rbk9Y5h1a9zla3PiLNyTgptX/IDwsthYsNcMH4NGqups5pZZ/0nVBTKKnyFec+DomdK4Kg80yG1G1f1y71Rp1h5vXLLX7c024DYUC2eo8wawz6+65vAaQuXLMIODXgg/Oe8j60P0kj2mu4tg1se+LHrVbQPz4dr+Qrpgq82OKmsF57Q21gI7mUEcHGgc6xc6Yo2q/9qxS6+eEJrNdBwzulB1NpkfXQt9ewcdV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
counters are updated regardless of this option.

Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
debugfs is unavailable.

Remove the Kconfig entry and replace the existing CONFIG_ZSMALLOC_STAT
settings with CONFIG_DEBUG_FS=y. Update the English and Chinese
documentation to match, and clarify the pool name in the debugfs path.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional. The
option only controls the debugfs interface, while the class counters are
updated unconditionally. Removing it simplifies the code.

Following Nhat's suggestion, remove CONFIG_ZSMALLOC_STAT and rely on
the existing debugfs API stubs when CONFIG_DEBUG_FS=n.
---
Changes in v3:
- Squash the three patches into one (Nhat, Sergey).
- Add Nhat's Reviewed-by.
- Update the documentation wording.
- Link to v2: https://patch.msgid.link/20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com

Changes in v2:
- Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional.
- Update configuration files and documentation.
- Link to v1: https://patch.msgid.link/20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com
---
 Documentation/mm/zsmalloc.rst                    |  4 +--
 Documentation/translations/zh_CN/mm/zsmalloc.rst |  2 +-
 arch/s390/configs/debug_defconfig                |  2 +-
 arch/s390/configs/defconfig                      |  2 +-
 drivers/gpu/drm/ci/arm.config                    |  2 +-
 drivers/gpu/drm/ci/arm64.config                  |  2 +-
 drivers/gpu/drm/ci/x86_64.config                 |  2 +-
 mm/Kconfig                                       |  9 -------
 mm/zsmalloc.c                                    | 33 ++----------------------
 9 files changed, 10 insertions(+), 48 deletions(-)

diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
index d2bbecd78e14..4c0786378dc3 100644
--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -33,8 +33,8 @@ proper handle-based APIs.
 stat
 ====
 
-With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
-``/sys/kernel/debug/zsmalloc/<user name>``. Here is a sample of stat output::
+With CONFIG_DEBUG_FS, we could see zsmalloc internal information via
+``/sys/kernel/debug/zsmalloc/<pool-name>``. Here is a sample of stat output::
 
  # cat /sys/kernel/debug/zsmalloc/zram0/classes
 
diff --git a/Documentation/translations/zh_CN/mm/zsmalloc.rst b/Documentation/translations/zh_CN/mm/zsmalloc.rst
index 4c8c9b1006a9..b555a07ac871 100644
--- a/Documentation/translations/zh_CN/mm/zsmalloc.rst
+++ b/Documentation/translations/zh_CN/mm/zsmalloc.rst
@@ -32,7 +32,7 @@ zs_unmap_object()解除映射。
 stat
 ====
 
-通过CONFIG_ZSMALLOC_STAT，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
+启用CONFIG_DEBUG_FS，我们可以通过 ``/sys/kernel/debug/zsmalloc/<pool-name>``
 看到zsmalloc内部信息。下面是一个统计输出的例子。::
 
  # cat /sys/kernel/debug/zsmalloc/zram0/classes
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index d44674b63715..83193ef8efb9 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -100,7 +100,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_IOSCHED_BFQ=y
 CONFIG_BINFMT_MISC=m
 CONFIG_ZSWAP=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 CONFIG_SLAB_BUCKETS=y
 CONFIG_SLUB_STATS=y
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index e00e252d4694..694a309377d5 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -94,7 +94,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
 CONFIG_IOSCHED_BFQ=y
 CONFIG_BINFMT_MISC=m
 CONFIG_ZSWAP=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 CONFIG_SLAB_BUCKETS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MEMORY_HOTPLUG=y
diff --git a/drivers/gpu/drm/ci/arm.config b/drivers/gpu/drm/ci/arm.config
index d7c51670da2f..fc0a8a4bfb18 100644
--- a/drivers/gpu/drm/ci/arm.config
+++ b/drivers/gpu/drm/ci/arm.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
 CONFIG_BLK_DEV_INITRD=n
diff --git a/drivers/gpu/drm/ci/arm64.config b/drivers/gpu/drm/ci/arm64.config
index c46125c1f80f..10b01b55a66d 100644
--- a/drivers/gpu/drm/ci/arm64.config
+++ b/drivers/gpu/drm/ci/arm64.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
 CONFIG_BLK_DEV_INITRD=n
diff --git a/drivers/gpu/drm/ci/x86_64.config b/drivers/gpu/drm/ci/x86_64.config
index 7ac98a78691e..8225b806dad8 100644
--- a/drivers/gpu/drm/ci/x86_64.config
+++ b/drivers/gpu/drm/ci/x86_64.config
@@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
 CONFIG_ZRAM_MEMORY_TRACKING=y
 CONFIG_ZRAM_WRITEBACK=y
 CONFIG_ZRAM=y
-CONFIG_ZSMALLOC_STAT=y
+CONFIG_DEBUG_FS=y
 
 CONFIG_PWM=y
 CONFIG_PM_DEVFREQ=y
diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..4a77cda7f1d7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -130,15 +130,6 @@ menu "Zsmalloc allocator options"
 
 comment "Zsmalloc is a common backend allocator for zswap & zram"
 
-config ZSMALLOC_STAT
-	bool "Export zsmalloc statistics"
-	select DEBUG_FS
-	help
-	  This option enables code in the zsmalloc to collect various
-	  statistics about what's happening in zsmalloc and exports that
-	  information to userspace via debugfs.
-	  If unsure, say N.
-
 config ZSMALLOC_CHAIN_SIZE
 	int "Maximum number of physical pages per-zspage"
 	default 8
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7ef80e0da626..104ccf3aa170 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -222,9 +222,7 @@ struct zs_size_stat {
 	unsigned long objs[NR_CLASS_STAT_TYPES];
 };
 
-#ifdef CONFIG_ZSMALLOC_STAT
 static struct dentry *zs_stat_root;
-#endif
 
 static size_t huge_class_size;
 
@@ -279,9 +277,7 @@ struct zs_pool {
 	/* Compact classes */
 	struct shrinker *shrinker;
 
-#ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
-#endif
 #ifdef CONFIG_COMPACTION
 	struct work_struct free_work;
 #endif
@@ -565,14 +561,10 @@ static inline unsigned long class_stat_read(struct size_class *class, int type)
 	return class->stats.objs[type];
 }
 
-#ifdef CONFIG_ZSMALLOC_STAT
-
 static void __init zs_stat_init(void)
 {
-	if (!debugfs_initialized()) {
-		pr_warn("debugfs not available, stat dir not created\n");
+	if (!debugfs_initialized())
 		return;
-	}
 
 	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
 }
@@ -650,10 +642,8 @@ DEFINE_SHOW_ATTRIBUTE(zs_stats_size);
 
 static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 {
-	if (!zs_stat_root) {
-		pr_warn("no root stat dir, not creating <%s> stat dir\n", name);
+	if (IS_ERR_OR_NULL(zs_stat_root))
 		return;
-	}
 
 	pool->stat_dentry = debugfs_create_dir(name, zs_stat_root);
 
@@ -666,25 +656,6 @@ static void zs_pool_stat_destroy(struct zs_pool *pool)
 	debugfs_remove_recursive(pool->stat_dentry);
 }
 
-#else /* CONFIG_ZSMALLOC_STAT */
-static void __init zs_stat_init(void)
-{
-}
-
-static void __exit zs_stat_exit(void)
-{
-}
-
-static inline void zs_pool_stat_create(struct zs_pool *pool, const char *name)
-{
-}
-
-static inline void zs_pool_stat_destroy(struct zs_pool *pool)
-{
-}
-#endif
-
-
 /*
  * For each size class, zspages are divided into different groups
  * depending on their usage ratio. This function returns fullness

---
base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

--  
Best regards,
Xueyuan


