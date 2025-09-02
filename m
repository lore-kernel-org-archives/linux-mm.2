Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 913F3CA100B
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA18A8E0025; Tue,  2 Sep 2025 11:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79BB8E0002; Tue,  2 Sep 2025 11:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6798E0025; Tue,  2 Sep 2025 11:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C99438E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:46:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6ED8BB746A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:41 +0000 (UTC)
X-FDA: 83844737802.28.3E5E61C
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 863B6120008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cBKK6Ho7;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756827999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ehw/eR0F2M+6G/BFd9v/1nkHSYwDgsa32Hkiapct/js=;
	b=b5zPkPTqj4KrMkRznH839bu9HEBXPQg3tMtkgna0plQJHJApbcCxxkscdQPdi6y0GL0acI
	14M+GWDAHZsjvR+tMNXGj/7BehKgBzmQUOtZruYZlxanGLrqEDqNe6sRydXnQwBdywxWy3
	zsyY+5Dipeqhu33OhlCpjwY88nLzB80=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cBKK6Ho7;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756827999; a=rsa-sha256;
	cv=none;
	b=Kq3b3pyULu9+fdbi9BHvM784it33xqMf6uUQjtP8TwfzgUoCi6IllkdoFf+1HpU0PZnE0O
	+BN4nsFnqe/dtFI7SEIPMgo6+WnaUC/ZUMbURgURVpjaBB5Bvkmg0rHKo/1LebAh4ng9bb
	ZrQ/AKs0406/mFsuImEWSU+ezNevn24=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45b873a2092so26889895e9.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756827998; x=1757432798; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ehw/eR0F2M+6G/BFd9v/1nkHSYwDgsa32Hkiapct/js=;
        b=cBKK6Ho7KCi7k4vCiG975kP9oUkGRlvw1pTUC1Ei3fhFuaJbX33HXeN3ZXtYCAcrHh
         VXoa3GYxxBzSP7pHn3n1/74/gQCazaPx/K8tbh3XA7AcTuZqcBjji8KpFLo2YQpm0B6E
         2a8gKoTIZPBe4DwK0B5bbGlTCbXcsMubSN5d/8BcNNFs1cN7D/gBvAI53v3szo7JKjRY
         Azk9R6pbzjQcDm6lRkNWUtYVt2HdMn6gb7M4qBwy/9F9IecA2ylvgmCS0O6c+TyP+E1C
         iBf2nbgzJ0da0ZvmYwJWSTIJv6VPAYVyD0Ul8zkfK8TJGFluDh0KpXYhEPWORuRxy7cE
         q+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756827998; x=1757432798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ehw/eR0F2M+6G/BFd9v/1nkHSYwDgsa32Hkiapct/js=;
        b=F8imj8dFexR9dJ2XBbWquuXQX43Oqb4cXzWgtbLdd5Ir8v3KYTrxfKpba8Olb6IK3v
         GF+B2lMACP92YIj4qMPabAZ/HDYkD0Qk1+Tvr7PUfWbTS3Cv6mGH+sGK8J+NB8263C1r
         ucDmLwyhE0zLzIpkmfwWgzgWxdNJpi6c039zLvKgG6ykwJwzIt9MBCUFc4Wh/I/SWl//
         mKqjG1bRNtX9JW6gKuHOu7KUhpGg4wB9VZtu3+3lFjxYelaBrpNto4NVi3cqOiHP7xxD
         lmeQDNWyChUqgUvz8rq4xqCfxw2s9XvRDrcMEQ73JTaN1kP4QGV5/xyJlhP+J5puoK5w
         WAyg==
X-Forwarded-Encrypted: i=1; AJvYcCVwT3jiU0K5E2zyCPMErTziedPiVkiQ74minZ0/DfEz3T3Tw0h3DO1W5iCEEQV4l4oeSnp7gaLiMg==@kvack.org
X-Gm-Message-State: AOJu0YyhB1iv6xfjMizyj/jFQm1mjIM99TnY+9Q0hl8FZMi567bWuCLO
	O+lCQ2arvTZONwh48i0uFKzHr3K88szXxrcUeWOCvVnAzb+ALyeXOR8+
X-Gm-Gg: ASbGncsjvYA+HM0OuM6Cx7LgECtAVPXn8IqG/uI1qoVhXyYRc2OpUzk15M3HNH30+RL
	m8l/SG3NgyaxhYjnx8lDrcbXQ6Dn9T4FkEZLCgQHzFbSyhcvjAcSvsGRuPdAHJikQsDB2jxOuH9
	bB65uBbWF3Wl9/YOu/fAGhznq5KPkPY8tWO/bG7bHuH/N+gal3Ct46HfWwhzA3TG8nHng6vHR71
	a5lelkFFEAFjgp8olRbeyv46QwRi85iUZJBVjPLZ+l85cFdkRGUY6OOt3kZ75CovuJk7nYAH2a8
	n9gQjUCdNl5Ipifsek84VWfvgcNQ6XKHTwTBlSB1sAN9APvpYGaQoewIZkviORKEioTv9YjzDjw
	6kQ5R18nElWXQdahFPWX1QITXFqsBmPcgUZwYUvrrybavA2HTLxUEqKleMSvpWfCkR89suWxowB
	vJowlGAH8w/MWMqw==
X-Google-Smtp-Source: AGHT+IFWiFaPK/3SzCCDMU0eaVs82NQJjjs4OJMxCNhx+PRy+qfGvhLoB3urjp1BVbB0eezwx8zy/w==
X-Received: by 2002:a05:600c:8b33:b0:456:302:6dc3 with SMTP id 5b1f17b1804b1-45b877be066mr95265895e9.26.1756827997621;
        Tue, 02 Sep 2025 08:46:37 -0700 (PDT)
Received: from localhost (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cf33fb9d37sm20384921f8f.49.2025.09.02.08.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:46:34 -0700 (PDT)
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH 0/9] dma-buf: heaps: Add Tegra VPR support
Date: Tue,  2 Sep 2025 17:46:20 +0200
Message-ID: <20250902154630.4032984-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 863B6120008
X-Stat-Signature: 4eb7a4tijbit5sp7kfx6sqhgmzk7y9px
X-Rspam-User: 
X-HE-Tag: 1756827999-604410
X-HE-Meta: U2FsdGVkX18LlPd6NkQqK8wkRvcpOX+OvsOS66bKh1PXGdCpxV2hkQ2Dxi9rvK+7HzJ8F15K4EG8SuFHDCSRV17pt3gNvv9VlHUG6sUgGzKo0CjzKl/6Z1pHwFy21NTG7dQhdfEYOIBsA+ZzxirXfHdn676yE0k5+WGQgCKGGTswTIyhVJc75D3IeLXt6FYai2CDfQPkDRnA5fohVHqxp87WGg//AeJbH3y7jPWofFwQ077yqzJTPCS+tNPxw7SD40m7UJODI2rottHhYNkfkSW3tObk9qogYM7bFfZcbqSA8qCreknvhb0MSWh6Uidh/BHZH5jtv7wtSFA1yAYTw72XPm6N6h68lXqVXNaDBMUXbdPbVZCNTkAd7krx13bcJCjmkVlz6SOjVP+XmVlVnbt3xqypgUwokQn9CQTE8/qWjJzaVhZKI7IUo6itLd0doczBB1pPDGSzcmdsrjTHSSiOr1QMhUTsp4WjhgCDP9XT8aY4DGSWZRs3OqghlkCu4uapTn5DF7Fme6VBK95nD4pXufhTWx5Xhi0oSMnLc1WF9vQez/5w+42DtCo+wTeXGTVOBSNT73QYHHrOwBvfZRm9rjTiVaHvK5HupiVCqyfhpHcJii9d8impSk1tzTRFG9rD0j/vZZa/7A0xiB0aJV9xYSF5gVVEV+BSN1X2Cna5PVEPxBlkR7XAlnMZR6O/k6TJQVmebX4tXL1SNx0bIjFTQFsbuHuv3fsdPZiVXg5Lz0ENW5/SptorPKOudUSny+e9G2Ky5ydYvR85ubxbIrypIeoShl8xHvKeRFdp9uQRnrpLdMW9YG20GE3Jnt4zTcn9SKSqaqP6NXFjEO+78zgO6AJR+X6d03VF+W119CTLIF+rKxjyGrY+ng8A0ZxZ3rZ2tJqCOSQlOY53u4C9/sr5gdiTYkN6BibVfLejcyDHbzrSAz0vdqw2K2+Gl8xQkuZ+0pK1mTYyFw6AIFi
 nk+vuXTR
 wGHTdg9trhQO14GKKtBdwPx9nNk1Yi6WXj8H28CgWit+vTPORrB+Y2He7f5Pf+aVN/yXdgxb3PIY6ZgerW+T7HI8Gd8tS1FVWJqEyQn1i1jVKY1yPsQM/WP1crHyT6tl6PW3pb36asOTmnZ5eLtY73dfwyGt5TfThDWROu3Ex8F3MPT4KAPi2shRdS4L4jSwyj5YhBbWCXybN6DY8NqJOOa9ChcbzPNvXhEy2ss36NaDm+ZheH8rzKhfiBZSKDWuu8nXd8CrLc7Dx4KGUMenXjLfkANtOonnD50BfP637/F1LGkQAqEFr+1QdbEu8SuyxxDCo4+ZNCT+EoWruye4UvbfCWkBe5lVdyMxPx0NALhkj8wnAFyapTwHCfZ14NoBRFRg/8Bib27V/DhAFQiffePeBpwxJbyVI9Oc51wOLJDP2xlmAs7aymgK8dSADc0V01vKfMz866bm1RdzeSybRH+mMS4sSowOc+IwBkZXqOESHK4BHEJY97eSjtccL378Gv2AJ6Pu/fyusZ5LmEhk0mvPdShCgCC8t3S5y5JSVd1E0JR4jL7YK1nYb0U2/Xnu5Ynoq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

Hi,

This series adds support for the video protection region (VPR) used on
Tegra SoC devices. It's a special region of memory that is protected
from accesses by the CPU and used to store DRM protected content (both
decrypted stream data as well as decoded video frames).

Patches 1 and 2 add DT binding documentation for the VPR and add the VPR
to the list of memory-region items for display and host1x.

Patch 3 introduces new APIs needed by the Tegra VPR implementation that
allow CMA areas to be dynamically created at runtime rather than using
the fixed, system-wide list. This is used in this driver specifically
because it can use an arbitrary number of these areas (though they are
currently limited to 4).

Patch 4 adds some infrastructure for DMA heap implementations to provide
information through debugfs.

The Tegra VPR implementation is added in patch 5. See its commit message
for more details about the specifics of this implementation.

Finally, patches 6-9 add the VPR placeholder node on Tegra234 and hook
it up to the host1x and GPU nodes so that they can make use of this
region.

Thierry

Thierry Reding (9):
  dt-bindings: reserved-memory: Document Tegra VPR
  dt-bindings: display: tegra: Document memory regions
  mm/cma: Allow dynamically creating CMA areas
  dma-buf: heaps: Add debugfs support
  dma-buf: heaps: Add support for Tegra VPR
  arm64: tegra: Add VPR placeholder node on Tegra234
  arm64: tegra: Add GPU node on Tegra234
  arm64: tegra: Hook up VPR to host1x
  arm64: tegra: Hook up VPR to the GPU

 .../display/tegra/nvidia,tegra186-dc.yaml     |  10 +
 .../display/tegra/nvidia,tegra20-dc.yaml      |  10 +-
 .../display/tegra/nvidia,tegra20-host1x.yaml  |   7 +
 .../nvidia,tegra-video-protection-region.yaml |  55 ++
 arch/arm64/boot/dts/nvidia/tegra234.dtsi      |  57 ++
 drivers/dma-buf/dma-heap.c                    |  56 ++
 drivers/dma-buf/heaps/Kconfig                 |   7 +
 drivers/dma-buf/heaps/Makefile                |   1 +
 drivers/dma-buf/heaps/tegra-vpr.c             | 831 ++++++++++++++++++
 include/linux/cma.h                           |  16 +
 include/linux/dma-heap.h                      |   2 +
 include/trace/events/tegra_vpr.h              |  57 ++
 mm/cma.c                                      |  89 +-
 13 files changed, 1175 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
 create mode 100644 drivers/dma-buf/heaps/tegra-vpr.c
 create mode 100644 include/trace/events/tegra_vpr.h

-- 
2.50.0


