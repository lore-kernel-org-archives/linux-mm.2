Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A5BF99C63
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 00:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDEB6B015F; Fri, 17 Apr 2026 20:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5480E6B0160; Fri, 17 Apr 2026 20:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F0D6B0161; Fri, 17 Apr 2026 20:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28F566B015F
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:06:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF3D2E4297
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 00:06:47 +0000 (UTC)
X-FDA: 84669735654.15.82A2FB8
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id E860D18000B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 00:06:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bqxekOcb;
	spf=pass (imf06.hostedemail.com: domain of sef1548@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776470806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XnzlPBGDUvWxUUnLdKcHZKjWamjXrlcano0vZQ/8+jc=;
	b=1K6DDZZgeaowNALcTEoiHDYydAYxiPcpbJ+rFMXsscYRKYseWZfkn1/cuVYoqPBavxsFP9
	aCHU9UbQlaZMTaFstex6horsqKwRJ5/WG0jPXKCh3SKLaZi15+IgV7nJQ5hO6cYgdbzp1y
	iVUzyzE8PM0IXaoLWeca+LPmPMoEo78=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776470806; a=rsa-sha256;
	cv=none;
	b=qM57MP3ANAgGWoP9+GEWUl+5SHFdrHa3WlEtxedlDCjdXLkzRllIcABu99X4DN4NfAQGBh
	htuqSFCESEDScoQkmmTEx1zHG7XIVA2Wd8ow8tYNABMUUeZ7lgnpGIjd498Oryz/5xhfVr
	rE7GtkdZ4Zhx6WSw1sK9dIdvligEeFI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bqxekOcb;
	spf=pass (imf06.hostedemail.com: domain of sef1548@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82f8893bff3so591260b3a.2
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776470805; x=1777075605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XnzlPBGDUvWxUUnLdKcHZKjWamjXrlcano0vZQ/8+jc=;
        b=bqxekOcbnt5e9VtrHf6yPAw89IjRsNeQWnWWdRI+mL+kLLZK1j+3xAMw0ksf6APP/H
         e0mnZ6UbDLAUqzoUwgV1uiymGn6lfKHdQMUGtzoj5gfr48H2lHWUzFXeq+P0kuwDZ9N9
         gcY2PZ87XioKihXizS1eDky/gS8yQsKUmVO191s02i0HlJ+zi7F3kgrcp+E7Qnpla0qv
         zk0m+ju0nBiwlU7JtYKBOo+cQ69jxahRP40UN9cxaefTAAITU42AtwbFdHqXl8jQjI5N
         lsAd5Ykf6svOdCvbREIxzpNhlDbS57ID0U8rrA+G2tgMgXcaNIGCdPCRa2K+Jc1pgnBR
         dynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776470805; x=1777075605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XnzlPBGDUvWxUUnLdKcHZKjWamjXrlcano0vZQ/8+jc=;
        b=pvJLB2RqldOj1x8JxSzmET08VodRlrJVLGzcw8jgoF8HF4zX6dOh4E6AlvIL5l5XyF
         rG6uAsDZdNMUdalNI0/LSx9zWXi20RTwGszYV3aVxy598Vw/jvoUpRXQ9Ipgdx6TdQxG
         kvqEc2TsRvfcrcvIbqzk+oJ+tUeqj7G30HK9oxPrMZA1NLlkN0uLn+hyDpVSgRqnc+01
         m4GdYIz+umrmOuFV0wli/jvbrXmZmsQgqTsjNk8TkvLTxpmmI+OQ7WRKmMA5eK+fyBNs
         BtcuakWWo7+2x+onq8bRucGkA+mJTtGz3igEfs81OMW6NwdrgXzQHuaOhiSpCbV6x9AQ
         o8+Q==
X-Forwarded-Encrypted: i=1; AFNElJ9aXlT9NtEbVzoB0vu/hY1kYK7d5KLyWbLKYFph8Jy+Ajr9xyEQkmeXJrWZ4FdpXqIxjPBeHhVcsA==@kvack.org
X-Gm-Message-State: AOJu0YxDo5DihWqOMuSx82D2qKVbWsT38eV7IM6ArTpbwhIcHZQ3Y0A3
	sIjrfrTJ24rQL2FszDgdj5hiIKiaJ1vE5hsHyUw0dupHDwq9qFQWDp+7
X-Gm-Gg: AeBDietH3fdIo+dTks/+/+kuKy4T8OGghEUSqQAiZqXfY38LlRuXF8DAG+8cdHMfz2E
	odf1pPLGk5m8z8LJembs+fKdLBJYtLlGD+fZa76oiA7CMVrRhen0oxdlOf+r4cGPUjDYMy95qwO
	A31jnX9Arkcrbtp+stYy65kfkMf69Mlgb7OsQ+l8y+3g1p+4nDCm2k0MwlAQIHMmonGOaBkviKP
	JoqpkJHN+q62gYHr1Hww0lo4CAVqsxHgmyUvsEESlaLbTqE7q1UZ07bOJazkSzfDSh2uzuxwuLU
	m33g832k3CuY6gLctuy9AePPHsMQr7lHy8MGfq4KMjnAiX9rlTYefOqvEXTVwx6X+s8ygDRR6L/
	+eEoqq6e4A/oDoDA0jSdLu5S1tNhKfuhDes/6nO5Hm8RAfjoxAkxIOWDVhPDUT9vTqPIriduegx
	geJOoi7/L5JiwrvdS08QRWxtrymmCBfXAvEgBERaYXOUlIam2ViG0X0KAGwMCJqycVn/xgtZF/z
	DAVZpoAaFz7dSzXSkFBSeh0Hp0smxSg
X-Received: by 2002:a05:6a00:1c9e:b0:82f:6b6f:13ec with SMTP id d2e1a72fcca58-82f8c9427b4mr4686092b3a.34.1776470804566;
        Fri, 17 Apr 2026 17:06:44 -0700 (PDT)
Received: from nickhuang.. (2001-b400-e28d-2380-bd61-3c44-585e-51bb.emome-ip6.hinet.net. [2001:b400:e28d:2380:bd61:3c44:585e:51bb])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e982fd3sm3840200b3a.10.2026.04.17.17.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 17:06:43 -0700 (PDT)
From: Nick Huang <sef1548@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nick Huang <sef1548@gmail.com>
Subject: [PATCH] docs: Add overview and SLUB allocator sections to slab documentation
Date: Sat, 18 Apr 2026 00:06:19 +0000
Message-ID: <20260418000635.17499-1-sef1548@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bz6ixcufj6zf8pwo5wqi4zcnrwc3xhfc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E860D18000B
X-Rspam-User: 
X-HE-Tag: 1776470805-88950
X-HE-Meta: U2FsdGVkX18mXkIznbjYGCiY4Gk1J/dkQl3KYeQQNeWdjHWQ19jisPgSGua0DGS2xabZiDu3CdOofNblI64Wzhq7pV+lOu9oSQ8h5kfUFu/yPQzBNf5VSI2On5yUavPzGOdMCA6B2425LXdCHp6lNdPJ2mVmTawNUYS+gEVPziXNewapg6IDfHJMaVB5qA7zUPp2QGa9bhC2dmWpCqrKG/HXPnFww17zNjqmqQTslFFvyBAnqsyextPPCfjBXEpLNJ4bOf8zcMuuRuTWrz/rr+nfWK4Dzeev3T1XeV/F0VxEYpvpVllFwp+Bc51mDWWIfu8PsOXdWzkjZFsU2/xPTkR0soVNmSdJy5WQ6MoMhHpN4l11Q/mztR72iAeVJATPUOKceKczyGiZZ0/08REG6pPF5muvjpX0ypcZjeWtaaNOh8PxP7HB9Mt901JiFnTd0WQk8lr37OPCOzDC1dDofeGxeDidbXkdGUqD2EDbPsd1G1KkLLMf1+8JCoEOyM0zHGs5Ojrsl7wfIhuqpfyVOFzIUDFA1hq00oFG1/pWHwOyIOkR2tAMmkZ+Je6XRzovIVfZFN/PZZR9jtjzPvQPdoL3cVKzpKrRJthy35tYqkSyUw+6Pah/dxS2DyXuEjwwTUuLls4laDDecI3PZHACimEiwXR2S3bC/2WbN8oljqNt79UX+BBoO7xILA1nXIitWkQyEC/O0Uy458Cz+MuqqIbJrPc0DNeMZPfd+48jteL8xV5P1EqODDANuZUIlIuJonuaBquts1B0rwCQ2C/tvcTXQhTnnQCiOo8ZquzRV3+HCjOU6LqlRtA7vMibOPt0Q/dw9XBgGKDr0yaSGrZPc1H+CBEGu1cW/uxj/1XaZd4kTCrvZ8z5N8/Fu/cB2WB2OfeBE+8D3Ti6f+rudy01oE4c6vsCcPTUqOiAH1ESZMCFPdtFLSmLCkTut+nOgzD7WoAsFXG+CKBqztuxYfv
 iv5GBYKY
 mDvfu1NJC7YmgmDEccPgrxbDzsRF6f2mEDrTYVgCVpjNyntqfEwumnE5c0EOJx+ax6kSl17xf2YzZTrem0fIMWy/c4sDTTNrGyaASzBAfHndh0Hn1qJ8zHLnh546eTsyCDNyJyDcMT9ID+wZRLVRa3eNBf7cGsamW7e6WatZkkebWqJSe+WC4loXzMHhJqRWnWjx2Kc+i3/+YkQth85TwxJsiYOBwiiZm5tLNwoSspgvmHi9E/pPbqN0lWxJfFjfv0K2zZjTL9FMa1YC5A47di8NajGmhBWhIrD0ZHK7UR1FHtVORzAjd8Bb6qSHSTSSeOx9usyciiVxqiifErg2kgW/btJq2DV4tVxqFeXrIJIGmU1+aDdgJhqC/yH8ViiaRfJ12MYDbXeW0vQQ5ZWAZsVfLjGrTrmk400R6mQKiuevctWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- Add "Overview" section explaining the slab allocator's role and purpose
- Document the three main slab allocator implementations (SLAB, SLUB, SLOB)
- Highlight SLUB as the default allocator on modern systems
- Add "SLUB Allocator" subsection with detailed information:
- Explain SLUB's design goals and advantages over legacy SLAB
- Document its focus on simplification and performance
- Note support for both uniprocessor and SMP systems

Signed-off-by: Nick Huang <sef1548@gmail.com>
---
 Documentation/mm/slab.rst | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/mm/slab.rst b/Documentation/mm/slab.rst
index 2bcc58ada302..2d1d093afb7b 100644
--- a/Documentation/mm/slab.rst
+++ b/Documentation/mm/slab.rst
@@ -4,6 +4,32 @@
 Slab Allocation
 ===============
 
+Overview
+========
+
+The slab allocator is responsible for efficient allocation and reuse of
+small kernel objects. It reduces internal fragmentation and improves
+performance by caching frequently used objects.
+
+The Linux kernel provides multiple slab allocator implementations,
+including SLAB, SLUB, and SLOB. Among these, SLUB is the default
+allocator on most modern systems.
+
+SLUB Allocator
+==============
+
+Overview
+--------
+
+SLUB is a slab allocator designed to replace the legacy SLAB allocator
+(mm/slab.c). It addresses the complexity, scalability limitations, and
+memory overhead of the SLAB implementation.
+
+The primary goal of SLUB is to simplify slab allocation while improving
+performance on both uniprocessor (UP) and symmetric multiprocessing (SMP)
+systems.
+
+
 Functions and structures
 ========================
 
-- 
2.43.0


