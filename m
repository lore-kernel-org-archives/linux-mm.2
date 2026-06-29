Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCC6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBEB6B00DB; Mon, 29 Jun 2026 08:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3D16B00DD; Mon, 29 Jun 2026 08:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2916B00DE; Mon, 29 Jun 2026 08:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7E5C6B00DB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:25:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39319120639
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:24 +0000 (UTC)
X-FDA: 84932870568.15.E4D7C34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 93B8D40002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N9kcot1+;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735922;
	b=6xbyZSNC6KD8jPCZzCDOn0g1UrVi+6rs82mR/QZFGRMngN01kPVR+DGVd7tMKR7wqotZmY
	JtoDcpBP7BUBbF7CZyNXyQpyk3fLpFgAJegPoF77Csas9LeLhinQcNiiq6Y+Wl7uWbewaZ
	JLi6lQrTYACnRKmL5+v1i0D5ht4OOB8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHOb9ve3jYcE/W9RyXVRFM5l4Jk2KuXJSM2ur2HmA8o=;
	b=2H0dFbXFMHgGMLH8kzH59CYyEyuh6mtNUlmVG5Wqj8VxnsaiVIl+ua3F9Tpt3Df17SiHY8
	+LGN3ImGfein8afv40QgDEi1S2rw6Nk6F/jHQOv0TEjmFFiL9V53HI/kP9VjLL6fiO5IJy
	OKZGA02HJiaOiPyk18coLI6fULzLD7c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N9kcot1+;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D436743BE2;
	Mon, 29 Jun 2026 12:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66421F00A3A;
	Mon, 29 Jun 2026 12:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735921;
	bh=rHOb9ve3jYcE/W9RyXVRFM5l4Jk2KuXJSM2ur2HmA8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9kcot1+WY2jypsv4U6kyLKClwmxgtXnpUiiDsh9uB4wjsv/6mJ3uO8Mm+KlvRTpt
	 x95DOn031RIiOjhD9YBKvRsJ3SWRscOOHqXP5//ffbZRcn2+ZeOGSqWcDJL8lpSdT6
	 9xiMjnB7g5DmFlroBbERwFk8HFxqwumjaOz9YYOFNe+t1tNkvjM4Dw8POSV8W15821
	 j0S2qUg2MPsEO6oUCpFNLuavOjl181R825Q1U0o2hykdFp0yv8/ZlyQqKxPThBHA+b
	 ZaWet0RIDIpDhYPXxPyW/nHY7c+UePobu/bAvV+uoPejolMs3FGhsJpEMMh+z+0i3V
	 QBTJtGRqk2zcw==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 29/30] tools/testing/vma: default VMA flag bits to 64-bit
Date: Mon, 29 Jun 2026 13:23:40 +0100
Message-ID: <27cd07f6dd862d92410cf9db03f7c11e5f66854d.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wgakg3xphj6wu4t7ikkdwcj74nraq64y
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 93B8D40002
X-HE-Tag: 1782735922-983792
X-HE-Meta: U2FsdGVkX18Daz9p9lsjwKsEeHjLJ2sGKCrkhaBOBS7cgcic00SzoanKzPxG0YOL/iKEahFN4sGW2SCc6fhCqFl0lU6CfVKOo0Mps7sjIE6oKMjDtj/4kYAlSvskjdO01vW3F1RbgC02fodOvSHgl1lnHPfPIIpr2FHM1Sv8Vke1ZNMMOGi6jNmHL/Gf77AEv0fVY6/ZzfNZB4pDO6X5+APDAdXdwcZ4hpkJPwFIBh5gho8XvydWO42cDOT79t+7Var2R1251iJBUDx6CXqd/Gpdhq71wDe8pm2pHDMaoH4yd3Wp72KtqT8TT8QRqvXnsLr6vRkS+1pvmb4gujncNsK6NK+/3Nc/OlqA4WXeU1dBjpzYL+sRoauNjdvt1yyCU1Ebce6R23endFOZtuKnwndtdamisk2kHgs9qhMoqNeHHfvNNB0c9KT+xN7AL5JXbSRWkUt2wvV5p3AjY0a3v6u+4zVyrp2qsKyUsVZ7KpMxm5NCZG8jLDNW5oWfWkfnS5/C12q/QySKO+DDz/ccx2CJ0hQEUhypTNWA/BAoGsEmGbdRxu5AOHl0hE5Przue0sbO7I1KmIlT01XpWojk5Krrbxa00+/OgZLiQQTkkj/5OdTN1dAg9aM4SNw0hiTY9NoXnjS2EbfOrxm1CQNNSxLQQ5J/2kVoZilrSn7LlbVXplzoRt/TPUCodvJvKSqllpZh8CDIiUKBqmuP6dQN6RJ+rluEkSp+5akguJobdEgaJdSh+X/JMBI+D9P8p4KetmDBtKMQjpogEEVUzdJuCd0zGTxeWPJkz4ToZgQZ/QK0fAFtr4QAfrU8tOcipcxvUMAw7eHgLGQbeNjaCNtR0V1reQm0vxXCKMdcHXVfNxoej0NyOHbuW1RmJs4m/GMTtq7K4gAqZKAUIPeNor8ZBTN8BzECr1WplvKd08sBLPf7rWQIZ+Pm0lXW3YfWO43xyTLNZPw5or9Uu91aeMl
 Rqz6z0CC
 TNIyZJU7vdGSbg9HyculTslovAvuhrUcvq3AfapN3R3jz2K6re/IFOdZLFoP/lzHHPo03YlqZwSGcNe7eyy5pvGuBRObACJzsAF08llnc5WZhKSHzvHjMLCnGLX12iEPEAarXDPlI1mmbydVHnqKdBNAKUNU8qSsda8cF5iXx9fHbT3HsZfTK85oD3jpkLFuA8vq5gsJ/azRwlSE38AMI4L/1BVn1MBZp87yjTY7GHO/dEaxrEzSIazHrsWhN6jJLiR9DbFc3AAsI5tPD2y+dTJFFsseNIfC98NQyEtjP8c66SUckUat8GSR6wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With all of the sanitisers turned on, setting the VMA flag bits depth to
128 by default results in overly long build times.

Reduce this to 64 - we can always manipulate these later for testing of
larger bitmaps as needed.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 tools/testing/vma/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/vma/Makefile b/tools/testing/vma/Makefile
index e72b45dedda5..ef6cc558afe1 100644
--- a/tools/testing/vma/Makefile
+++ b/tools/testing/vma/Makefile
@@ -10,7 +10,7 @@ OFILES = $(SHARED_OFILES) main.o shared.o maple-shim.o
 TARGETS = vma
 
 # These can be varied to test different sizes.
-CFLAGS += -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128
+CFLAGS += -DNUM_VMA_FLAG_BITS=64 -DNUM_MM_FLAG_BITS=64
 
 main.o: main.c shared.c shared.h vma_internal.h tests/merge.c tests/mmap.c tests/vma.c ../../../mm/vma.c ../../../mm/vma_init.c ../../../mm/vma_exec.c ../../../mm/vma.h include/custom.h include/dup.h include/stubs.h
 
-- 
2.54.0


