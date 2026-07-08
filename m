Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8825C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8316B0095; Wed,  8 Jul 2026 03:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7EC46B0096; Wed,  8 Jul 2026 03:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F8D6B0098; Wed,  8 Jul 2026 03:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1EEC6B0095
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:33:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 432F4A0645
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:33:25 +0000 (UTC)
X-FDA: 84964793970.26.BA28F96
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6B01E1C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:33:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n37SAsGq;
	spf=pass (imf20.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783496003;
	b=uLcRQmtxfluWqiSLOi6+pAKQTkes6T7i0UBzfJx8Brlvx7NODteYklYK0u+nhGCZrOQ0Xx
	hqdc6/mI0NBvaPK7wps1CTYGbqpdDxUwxnOj/mWTj5OCNabsPBIOnx2LmrEg09NORAw3Zx
	/8PQthLy7aW6Hvk5SGeT5kcNA7xg1fs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n37SAsGq;
	spf=pass (imf20.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783496003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prmr/Jndi+BNbM07sqH6cB8cxDm8c7W6tjC6zXyacuQ=;
	b=P23BIIJeyy3I53WMA3xhhob2ZMy8GIrcBK+ILingBCVHcMSqAUghrazLVR3FkYnL0okH0n
	doboHz08yn/FPZa+KlS0fOD2yBo1p9DwrBYD5bxi176yNWpjEAqeiv+Uk5bSS7WLTgA32R
	S8hF60N47CofByDnb+UXVpBNOQ55lKU=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490d6730461so348695e9.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 00:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783496002; x=1784100802; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=prmr/Jndi+BNbM07sqH6cB8cxDm8c7W6tjC6zXyacuQ=;
        b=n37SAsGq7JrVB+fH2ft04kq3YzCXNnx5gmAwgAosScDksWZuzepvLmRvxO/peZLcvO
         0b9p++jVunxY1YyuNZxfEcxmJNJ+XgfU4l+0MO0H2/O9BDDKA8brAjvGAiycdxq/dmR7
         bHLjPqHAqZgXp3/0gT88w/FMSNirxmug2JVZBFf+ayehmyG9oPlwHAhs4N7mHSO4ZCYN
         bexbCKyyoTYlvqPctVo0M4N/xBX6mG9JxZ0de1ThpaHMpacaOaYiPorkmob84EJsDDqg
         DMshzr2vA/abJ9scmxRlXqPhymr0ctecIyK4VeYHlEgder8CPuf/xmgAfshkcInMX2tl
         3mEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783496002; x=1784100802;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=prmr/Jndi+BNbM07sqH6cB8cxDm8c7W6tjC6zXyacuQ=;
        b=O7oDCTjYzNWIGobNO73Buqkdcce9jCGHFjbRDTMN2UpJBz3Db7OXQpTywScyhikKW4
         0dYlJlKpowYn8vLYI+I5fazGmI/bhf51ROnzw4471VV/seMu92Jr/C/ayhpqZPSZk11Y
         yKD4r/hG5Bnr2uo30BTgTRyuJaoDj/gIpNE5diwTMhR+kUCnZWlP2zul/C+a6Ojo6Pae
         Xb6MNUm3tkioT4lxhEURSZHok1Pip5kGdyWMUyW+SqlpbSY1hZEJFBGeBkqbzjvoGEEr
         o2nmIuQqDx4m/Gu9mnXXCF9z644dujgpJLYFGX/hSECxtjw9excrHr5UTt6ck7Z5ZJn3
         KuPQ==
X-Forwarded-Encrypted: i=1; AHgh+RoYQPZN2MtADrA43vUj/JohqFiqiuVxIdBqpC6+NJGe5WUvdpQgEPhmF9kKJOWLXOfZD0Yy1TS35g==@kvack.org
X-Gm-Message-State: AOJu0Yz4IcPGaa1IQzReGMUT7hAVLdFoypM59ahizciFBoOYzPdVWfUf
	XTBYTyXEIhHcQa9A5Zyl5iqYUG0Ua2Y9IqJOJmizeT5iPuGpgrGD8rSf
X-Gm-Gg: AfdE7cmXDNM99s2IFPzK02bmOu3G9laite6PKPm8FEj5nxc+DyvZcH++6XV4Dgt97Up
	taPWyzKNZnB1tS8rsNZSG9TeaMOCDAzvqmdtiUEoE0BVWwJt4uXN2MbssRYCzQ4KZRZRYOuUBTT
	ZAyE0lapbW2+voyX50ZOJs5KaiNt6E3Bw65WswW9siyzjI8nWZxBT1VCzD9MNvH3DEr7DyvpGFq
	ktO9CYAZJtOBEZIX1lhP+4Hn7Nf3W0IZOdZDvuh2CZkZvEWosjwNWZF2lrhlbHSLgWUR10g8Q0v
	V5Kyi9NOb57PiZXLXy5pYaYR4I2NZCbKmYv1G/RZ92fElFp83+eWibK/3SPSerBp5pmc/hCHBkr
	ZMM4Eikhr0u5EfMhq3XpLV4OG2tOTz3/OUtnlacCvxF9rO4Pi9xfjte14nk3ttWdWJJ4diINnNv
	stYZJS3sSC6WZ86p7r/3yyQvOvhrbRFOjW8cPnIWFmX0G/wbxOtQqsTTG83UABlPCrnBssSUJ5J
	uS5E4am35G8tQP5
X-Received: by 2002:a05:600c:828c:b0:490:b227:da9b with SMTP id 5b1f17b1804b1-493e6820934mr7102715e9.1.1783496002095;
        Wed, 08 Jul 2026 00:33:22 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e610532fsm32876355e9.0.2026.07.08.00.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 00:33:21 -0700 (PDT)
From: Doehyun Baek <doehyunbaek@gmail.com>
To: Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>
Cc: Dongliang Mu <dzm91@hust.edu.cn>,
	SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Doehyun Baek <doehyunbaek@gmail.com>
Subject: [PATCH v6 3/7] docs/zh_CN: update DAMON index translation
Date: Wed,  8 Jul 2026 07:32:42 +0000
Message-ID: <20260708073246.1652828-4-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708073246.1652828-1-doehyunbaek@gmail.com>
References: <20260708073246.1652828-1-doehyunbaek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6B01E1C0003
X-Stat-Signature: 3mjgxbr5h43shd8s4n7r975k51gedmyc
X-HE-Tag: 1783496003-533372
X-HE-Meta: U2FsdGVkX1/yzzDnRQ7QQt3WLxrb8WlDCzI4i6IJAh34GnKivvTtmbL19RK6MZN6EAM5Z77XnN6MvtVMaI7lD3fjdH9ehr84MGkuyLrIw/xz3vMBf28SRRge3Xzau0EpLJnmudQJIqSNdJ+9cAGLWZN91ABK3Y4hxVzutCKBMgLZ/eVfCgmKN0iGLDTHaFZcabRK0WVeMju1Aapp28XbutlySAzdutvIkZZvjme8DHELVZSjmaF/KXE6gctQFlw85RKtZ1kTnFokHDvsePdjMyxnAA4OjalxpsBum1kcAA4v3g3gHzQHKkcrtmUJ6Rg6uuUtLqcBeMCYnlMe1c/Ajx2JCLErMf6wzxd4g2JlktcR7v2BdpxI33/fVmKbDqSlS1zAFDNeUAAU2eDKZrWyey34sNy6EuvdfrHraj3hRa1Jj4fDF8rSn7Nt1bQn6ija7gotf2DGY+0m2GeTaouTFx1L+qc4h+s1kAqRBqUo3EtayG79r8WCVtlMayeem1HBL3eCRqvTwyaPUDjUz79MHNuSF8FQsiA6AdLxbMpd3ZtZi6wpyNh+GaB9F0FxKEaOFIchxwSn1ntXMmZphkj+d4LGpsTMVoywIK8aRBGqtqL2FdurXKM+CG8/2GatH/YB1YkNP7CZ/O/7lf9rUj8d1V1JBHh3JrPg+reBtSjn4CO9E6/+IdsEF5vofSKQzBj+IkN8BxCaQJ+ST+iE23UABUZKK2tsvoS9elN5cUEjgcK+fqLqry2A3gR9Tt53GVY72noXmThthw24B4E5LbXyvfop/MNmuXwipKhIhRnHsqlGXJpb5fKE4gvks9rhK2N8Ergmboqp69h4oaohR5uBTilr39Ql0V74rjOMM/sx5xXaHQbAFTqU3OUwJBcuVZzII4qtFJ7NejYEkd9177IW6BysiU5j4u89u+dqNiJXur2hgPr2xc8iOMwqyHz6WcB77xhRvzw8w4dxQfB1mUY
 ITIMXk3b
 zNA7UNj/vg6NQOmYJfo5GuQ0VbdVrX/j/r/hA0h22z1iZzSkSwvgtzX495o+jQc7Q6y3PHyvfnFZK+13ZEepdn/FWL0m5LMX4fxAfMF5u/M788tSLexufQ6WTqhM3YsoJHc061+aBphR7kuLgFaI5J+GVQx0EVcKylHiGPhPK4ToqTTeZOZemWj+xWVV6FAjfQcZxRf29Riyz+U9s1qDQhc6SEKZYduyDv26Iy1ZBD4VjSuOV6+wPmxGsGesYA7taOouBTnGuhygLQ9pXubHeZQDdfg0Byt/2SOxERH2BoUr1qxgC0EEIJPaq70DsGvVq2bfbUez4ZWYOlE4As+HL4R6o5UmFxt0+y3JvDxjO6piD5vmrHW0purWR0P2qryYSW3LGA6N/Z4qcdZMTEFIe/3eocc6IWws7LOw1uFNKL5XyHBehotVsvOMH/72LpVFWabzDf3PmKXgUGkRZStadIJVaaVNC9CIj8BoyEkrVW0xH7ESSDo0LqjRTCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the Chinese translation of .../admin-guide/mm/damon/index.rst.

Update the translation through commit c9380cdd949d
("Docs/{admin-guide,mm}/damon: fix DAMON documentation details").

Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
---
 .../zh_CN/admin-guide/mm/damon/index.rst          | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst b/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst
index 6f8676a50b38..77bbfa7c25dc 100644
--- a/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst
+++ b/Documentation/translations/zh_CN/admin-guide/mm/damon/index.rst
@@ -9,12 +9,12 @@
 
 :校译:
 
-============
-监测数据访问
-============
+========================================
+DAMON：数据访问监测和访问感知系统操作
+========================================
 
-:doc:`DAMON </mm/damon/index>` 允许轻量级的数据访问监测。使用DAMON，
-用户可以分析他们系统的内存访问模式，并优化它们。
+:doc:`DAMON <../../../mm/damon/index>` 是一个 Linux 内核子系统，用于高效的
+数据访问监测和访问感知系统操作。
 
 .. toctree::
    :maxdepth: 2
@@ -23,7 +23,4 @@
    usage
    reclaim
    lru_sort
-
-
-
-
+   stat
-- 
2.43.0


