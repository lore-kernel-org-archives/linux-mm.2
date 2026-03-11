Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 425B4FD88E3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 467256B008A; Tue, 10 Mar 2026 23:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B566B008C; Tue, 10 Mar 2026 23:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3473D6B0092; Tue, 10 Mar 2026 23:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C01A6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:02:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FCE41604FD
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:02:45 +0000 (UTC)
X-FDA: 84532284690.23.2040862
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id D065780003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:02:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=drK03i1f;
	spf=pass (imf30.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773198164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oS86FXpKkrcQ5DT8L/I/9XrEEUz5zSdMQ8sRGkPb+gk=;
	b=MMc3amIk14R6zFVNPbXI5PHPPwIp9tiIiKP95leeV0MeSaM98pUvvirxzTZuVWyBvBgEBD
	KBDn4gwLT6mrRlAx2zt48a3OjKrSb34ofaB3rvZk4i9roFpTfmQZsG7B3f6pP3rLnrWs7u
	kATZ3m/2LfWAAIfnUduPl5TDbXGrk9A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=drK03i1f;
	spf=pass (imf30.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773198164; a=rsa-sha256;
	cv=none;
	b=tOurin0kpJRvJHlf8XQhwc9XzdgBX8jCaemlikie4l3Wh6vur9gY+WZqJpL65/1d9DPvJa
	K+Uae/TbzqSqiNeUpazL20g9TZfAo1JfmELmKj/vZBGpDJfuDRxgofNjDvZY0U3jrXkIzJ
	3oP39oVgXUobz/Cv1cIY7k/qZYBXhUo=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ae5423b02aso64607015ad.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773198163; x=1773802963; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oS86FXpKkrcQ5DT8L/I/9XrEEUz5zSdMQ8sRGkPb+gk=;
        b=drK03i1fi4y6rNIuXRtHBCZVRObAsaV2oDPMtei9oTm7UGlVjvAJAXqtbqu/Ixhgga
         WTTwIGi6S76qjfoCbxkB0dacwQQgERh+D/yD+R9Gdlxv8o3d5GyNYIpG30JRExxkNYie
         V+hpCAJQpjiu/CANq7O3t0j/tYBZ9hVwvcXFBpqBnPTV7XUDtU0TmJb4DSu6V4isusJ+
         DGT6biltPgBuOAEdFYjajcMPNeKbGYo++n0HvtdbDynraNxxeQQbJgjCakRSB8Nkfc3q
         /EgcX1DXaCcykMzodGiSiB1pDLDaU3brGuV65kH8qdtiaGgSxqKjc999g+WmXtNjuK4+
         l1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773198163; x=1773802963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oS86FXpKkrcQ5DT8L/I/9XrEEUz5zSdMQ8sRGkPb+gk=;
        b=iCA9/wv8iRzJ2Y2eEVjehNtanjMZG5Wm6IwH53FA2UL5+XRGKdhshLmPF+bnMZW2Cc
         SX4XNGq9zGJdZUkEcWWvwCi/Ga+Vic+6CcIMIltjyjJ3f26MCOLLmYBp1w71b4nq1H8x
         lJvVu4+/6x9GEJAfqEJdrCJeHyaBnOSDpXJjcestH2B19cAcZYVfxmEltZAjtugOEy67
         nNuVgxfK3RFxwUP4yOCSUENKB2WH0akKTb57xAxlChl4tMKQwDRtBeSjBmybrPgw5DU4
         ku82+gYl9lHjwSn1asYeYBUPJoMvRDCcs1pHJobe5PGauu4FkWKr79GNSZX2mefDFXfy
         +/RQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAX2tUWckdnvG9ARkV6l3ZT8SniaPgFr9l8RmZFtsG19nXYR46C9CYT1DW4/vzqgKziDptFMxb2g==@kvack.org
X-Gm-Message-State: AOJu0Yz2COW3ZoT7nR35Jx7oaKmNGt4LkH/Frd4g/aJfN/Wwn26hCbaL
	ojPlOSfcMk0VlQc9XENVSnw0rgm5Yt3oTdXwHMy+Tny5I75CaJW1SN83qXLWp7CXU0A=
X-Gm-Gg: ATEYQzzHarW2rIwTLOuKzLIhMRtXHtzBcjB4T27jnDjzQ4NzQyO9qajZ7PIDpMrZTY+
	cQSpd7ilkV51amblM1/saKCEttl5tVy8XgO0Ii4nEmtFqfeqz3hqcBfZeqiJjEbPX4PtmENIu6B
	zCKL1kOutXhrO458lKK0Ow5E+ipumsFjM2VxsMEGLR7OtAnbzrOfCRojyO8r+pJPdH+RvVPLadz
	boSKkbvwVaZXJlDgw07MMAt0cQfif036UES86RcRcWeJrm8sLD0pXBK8Y64Z+S+ShXYpXZBWqgw
	48FpQj2ECExTzr/wtdv66ECIWskadfYaJdUVoO3qemn/9V8qnekBRO/FgyQbU9fUdrJIdYrHKUG
	En3CoSiWW4RCrZPaEu8O7rQYeS1Kk7zP0QV9cJ9TfPQi0Thg3N/KSS5ueHbTVVtBd0iA2buPUrN
	549+WDb7tDAZYRsytQjPJGVTvTt0iOMcYOMX1nzQ==
X-Received: by 2002:a17:902:d2d2:b0:2ae:50e2:edd with SMTP id d9443c01a7336-2aeae8919demr9978055ad.31.1773198162527;
        Tue, 10 Mar 2026 20:02:42 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae378974sm6251555ad.82.2026.03.10.20.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 20:02:42 -0700 (PDT)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	shakeel.butt@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH V3 0/4] record non-slab shrinkers for non-root memcgs when kmem is disabled
Date: Wed, 11 Mar 2026 11:02:31 +0800
Message-ID: <20260311030235.240953-1-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D065780003
X-Stat-Signature: pns69oh1t18wchhcihtxo4uzk6jypzkq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773198163-314753
X-HE-Meta: U2FsdGVkX1+4dnvGodXQ8lgo4okBu/k+n3RWPU3MMbx7J7RXoYg8ig6W965iJurvgbiehnrVYZxLAM10IK1ORb1wkI1+HnTpDVHi9QNp8z9TsYQp9DyGFqBeeIBqWZKjLimC4gJyMSVSVhmh8UPbke6gegZWvtlud9MaOSq3cCYTGhHiuIjbk9yQpXFVVMjKpxUivqnrtVh1AinLXyAxvaPP692H9Z4/ZgTqgvadfbE+VUbgKYXQ2k1H9kpNk/vep/ilYIrHpUCYdzIqVnwJzNdGZwcNX1bE87zSrh9zkJmtmcTMCqTTtuzlLpxaN3yXtDN7iklqwRi6kAH6x7T4qF8emJQV5YT3Y5PLK/i6sbHcszx0UK/vbqRe/SUJOQnYeCwnEu0WTMux5f0B+QRy+NYoBN36M+VceED5fE3E9ahDPJOHs+toANTu4iylCRBFDyZmGKVx2vvV+OyhfaJbjR3bJ2xRKj00qHJv82R+eu9JtH9ba6EzJ2+MifpzK9hAbZ6GxzqpoNBo4NyEYA8g0ohLnhWBuC3i/rCBVALE479nCLy6pqF2vcpNcqLxXBOOtOhO2soER0R0jcEOd/Nq6LnSMtG6mVnorm8nKAhxWAJbM8rsKSvCxpX5gvQE0HfFCeHMDKV+sq5cHV0mD/2q96vIYMQVO0+EjwMoBX1EIP3fOCvZfAPT8jt3foOu6vg42A843xK0J/gCLBgX09FyBwCRG9kZDoEiyd3TAISPA0fiI/IBnUaC4cutuYHe6RsQcAGILHlr0alo1bsD6uKPl7hNm2ZN8psXvTpfxN1M4yRQzqvewHdW0fzFhcfF6iZGAyIffHSAEfemEw7pL7wB4DWzJjq9zFDStARut72m1ay+UpBRgThmyY5cqkeLZXf94a8Fk/uukWdQ8cjUHeVdwChbbRZlBkxrsM995QMoxHlvKAK0P470LIssui+KD2jcv3NkYbr5IYXwqj0WRfi
 4KgvDr/x
 l2MfPnVbKwc56GR2vBQA1ujz5IvoXDLSeteu0TLLAWABGDT7d4vHib7X/XskDLvMfM2hUOcjn878NgSNpVl/iqzeiBeQvEVW+KvRP/hRX6NwjwZSfUcMlCxJglbcWuOEpvqbwidLMZg7cam+iknTf+Hm8foTDlB8ZAakMJDpOa0Vx0SrWgel+R1MTCKRTDoyfKzTMf7lItdytJTjwPljxV5+xHWSWI3ZqAfxlbdLx5BDPlt/rtbHhHwaYzQs9IVH0Be2YfKSlE7A0DLnM4chlztb66UlZHN3VfMYXS0N3KGftmgXxthIiWe6JV0aUhbeaX7TXeYOuH7wY2yF6Wv77VIAReCY06qDesVfj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When registering new shrinkers, all memcgs need to expand shrinker info
if new allocated id exceeds shrinker_nr_max. But if kmem is disabled,
only non-slab shrinkers is useful in memcg slab shrink. So in this case,
it is enough to allocate non-slab shrinker info for non-root memcg. This
can save a bit of memory and reduce the holding time of shrinker lock.

With this optimization, the finish time of pod creation in our internal
test is reduced from 150 seconds to 69 seconds. We test it based on
stable kernel 6.6.102.

Changes since V2:
- read shrinker_nonslab_nr_max and shrinker_nr_max under after acquring
  the shrinker_mutex.

https://lore.kernel.org/all/20260310031250.289851-1-haifeng.xu@shopee.com/

Changes since V1:
- reuse shrinker_id() to retrieve the id of shrinker, this also fix the
  build error without CONFIG_MEMCG.

https://lore.kernel.org/all/20260306075757.198887-1-haifeng.xu@shopee.com/

Haifeng Xu (4):
  mm: shrinker: add one more parameter in shrinker_id()
  mm: shrinker: move shrinker_id() code block below memcg_kmem_online()
  mm: shrinker: optimize the allocation of shrinker_info when setting
    cgroup_memory_nokmem
  mm: shrinker: remove unnecessary check in shrink_slab_memcg()

 include/linux/memcontrol.h | 194 +++++++++++++++++++------------------
 include/linux/shrinker.h   |   3 +
 mm/huge_memory.c           |   4 +-
 mm/shrinker.c              | 134 +++++++++++++++++++++----
 4 files changed, 218 insertions(+), 117 deletions(-)

-- 
2.43.0


