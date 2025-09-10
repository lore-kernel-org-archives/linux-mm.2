Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8DFCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891E68E0005; Tue,  9 Sep 2025 22:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869C68E0002; Tue,  9 Sep 2025 22:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757B68E0005; Tue,  9 Sep 2025 22:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 632EC8E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:43:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02F4959D82
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:43:57 +0000 (UTC)
X-FDA: 83871795756.30.517B8A6
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 03D6AA0012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:43:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QGCzWTcW;
	spf=pass (imf15.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKHUedwTpnE+6902OLKWJUrKeeyE0icmaP4M6h8VeIM=;
	b=2WKTvpD1r/Cjue+VGV4LzvdP50VVBqWyCfqQ9SGTrRHJSZAyFzuYuTNPWg5b2MevngXC8m
	rlXoflsSnDHTqiefW3CgBVpxAQwXwBF0uZilgaM2dpvCIA6rK7CMZZF2XVvNKX4m+/9i15
	vWt64HvfvEK+Y8Uo8T8egtILMEPJXS0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QGCzWTcW;
	spf=pass (imf15.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472236; a=rsa-sha256;
	cv=none;
	b=YQoQVrO9seF4s48wc3gdUWAKZofcnUjTtYNPBXApDGk6FBcB7Sn0e0E0TcgRUorinWjRo3
	b7R5ZzOQtfqslo0SE3j8yMVwOUXcgzsoAxR6vHPBtkfVKm2adM6QsJY6ZC7grCMf0yh86J
	CSceRso7B4dZMtkRPrJa1+3oTOZW2nM=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24eb713b2dfso42570225ad.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472235; x=1758077035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PKHUedwTpnE+6902OLKWJUrKeeyE0icmaP4M6h8VeIM=;
        b=QGCzWTcWfy80i4HMrxCch008SSccs/VbzEvvfybOIU/jCEcpluFWM8Yjj3FpypTw6F
         mvvOiZehe9gwI4jiWPqJHx3GxpuEdvWafvvAcSdUztoA3+ljnZ8Ja0NNmCg/Ovz49RZj
         juTB5BF1FaaJIA/JxE0zUMwooyOeiCl5H76APqc7WAXezx1D4F04QR8T/KNp+MW/Cihe
         frJnHVt9B3PfzVSpo9l6o7fvAZDdkD6/SKCuf3UlE8RUgtLRywLAS3SxPxRUfQgK/QyQ
         TIH02076byOoU7PWfSOgYXYNh3e32qTKVPAyP0ONIoWWGLgnYhrCIUxZHELSRfuMaoR9
         87pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472235; x=1758077035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PKHUedwTpnE+6902OLKWJUrKeeyE0icmaP4M6h8VeIM=;
        b=W1cpMBtgYIFmzgRcaJG5FaNTJZKIqQuqe0/RUdgrxWRvDez1BrAQEVnbiEHf7zbG2d
         Kryqidxr7GXHGxV1keFroUnDEZRKXfsoxibZBLckrFKck/BCsEq7UTSsXgABo4POAEwF
         ebZSteSHi5NagLrvMySjFGfL/KUd4bwOl0uvpF03uvs1npe2YGcWitX+79PoExM53j8G
         R+Lvpyzt9cIGwIGL4kt+64Asa5/RVpjoxR53liySalDn2fpavzREnyJ+K7LtKZSqqzw/
         7rPFEwbiVhtebBUoe+/s9jnWr6HP4lLSQNKmXHf9DtxXXCrPAOsPSuK1W6+0wnSRcHT6
         XX5A==
X-Forwarded-Encrypted: i=1; AJvYcCXWK/IiSmCwPldMGCtyyLCcLYOGk5SWGs7ER+A/JOR/Hrjn2yU2B6lpEb7wLG1gFOXFTpMHtMn1hQ==@kvack.org
X-Gm-Message-State: AOJu0YyalrxHYuZEF6O7IbZk0KpYqbcEeoVJGLHXnzUD+zdPp+ZGeCnO
	AlRr1bYM/LyHkZqCUaGcbQGDSgQjScYgUkcj9IuLZpbPoANBuUFdpeTp
X-Gm-Gg: ASbGncuJmBmjA4LyqCzuqhtjSwhpsQiYvxeygInoHZ15X46IN5tgXPNK7pewNJgSwwI
	jG3pFFK93N1ccXuExJXPTPbZ9szo04W2Viig3WbwplTBOtG3s3QrLNwcT95/weOBX98T7xWFIZt
	LLQq2TwICjR2wBEswA0D3MGF3BYyPEiupjT12wXOjyS7mKb9p3+GTpjgGMeOoyqvd82gDkSaZGl
	vIaPiBVgwFcNdfzupoiEZ9yavN1oN6AwteThrYYbzAi7R1rK9yXKtOVV1gcOgjj/+u5Bm7uc8oF
	A2jdkPn8fsFBayncnkyr6tXM0fq+kZ+IKR39KT2IiQ2RUWHIVzVNVg2wXfl1/JFQYZs6Pwdm4d0
	xeiJA/w7oS9aTnYq/CWP4oOES7JRK1U9wqC3B
X-Google-Smtp-Source: AGHT+IHbDjWZY3VztYJWV/FENnSrT7+pUTw9iPKJIW8vQLIXrlNVN5ahZX5GB9eL2BwlCwOB0bsRtA==
X-Received: by 2002:a17:902:fc50:b0:24b:640:ab6d with SMTP id d9443c01a7336-25172b4b335mr233139385ad.49.1757472234639;
        Tue, 09 Sep 2025 19:43:54 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422ffdsm11441735ad.17.2025.09.09.19.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:43:53 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id E4226420A809; Wed, 10 Sep 2025 09:43:51 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux DAMON <damon@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Power Management <linux-pm@vger.kernel.org>,
	Linux Block Devices <linux-block@vger.kernel.org>,
	Linux BPF <bpf@vger.kernel.org>,
	Linux Kernel Workflows <workflows@vger.kernel.org>,
	Linux KASAN <kasan-dev@googlegroups.com>,
	Linux Devicetree <devicetree@vger.kernel.org>,
	Linux fsverity <fsverity@lists.linux.dev>,
	Linux MTD <linux-mtd@lists.infradead.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Build System <linux-kbuild@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux Sound <linux-sound@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Huang Rui <ray.huang@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Joe Perches <joe@perches.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	tytso@mit.edu,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shay Agroskin <shayagr@amazon.com>,
	Arthur Kiyanovski <akiyano@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Saeed Bishara <saeedb@amazon.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Alexandru Ciobotaru <alcioa@amazon.com>,
	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ranganath V N <vnranganath.20@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH v2 01/13] Documentation: hw-vuln: l1tf: Convert kernel docs external links
Date: Wed, 10 Sep 2025 09:43:16 +0700
Message-ID: <20250910024328.17911-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1333; i=bagasdotme@gmail.com; h=from:subject; bh=oQ/U51BIIgNGsRun+kwInz/tmig5xTqHruGeEvNRxQQ=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHnig6a/JZLY81M41OfrJ5W/1jtyyro8lZM99fCflwN Zg5yrW3o5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABOplmZkWLE7pDLv7RVG0Wlf H5ewasZymzr2NV7tNPkiErzi6eK/vxgZzoS7uJzLvPvRJPIa/z7RCs5jTcdeb3Q8EmZgt2n66RO ZTAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03D6AA0012
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: q4bz49m75w9qwuejbeeif7ogcxgm9ykp
X-HE-Tag: 1757472235-425957
X-HE-Meta: U2FsdGVkX1/OfeH6iIxUGGpWPQAO96ew6Zg45UuSEextePWtqDtJ6uIqiqZ1V7qCpLMVRR7IVBChzR9lGJPo0tLanqnKfpxe4J2MukqMTE6Vv3IFJRfD4oumYcyqUgkbrNsAYjGSBf0lxZXMasQ3xXXQAbcQPSCqZd4st/l8F7U8rZZfec/XYHHH3LmvuQ14v8K8dCLpZbBoYda6e/JaFCUf01A5b2StOGZQQM4c5d0akoKqhaMUtpVIAAKK2ADjcM5f5jdqqImX1l5oM294m4tgTjpRgpvd847B2dVg3t6Y0n9ONePDYucK+1cC1p74k1Tg1bA2RfedxG9ukVo1BJrSXo1cP4VpqKxhmQiCDsV8NQEjNqO6GSZ3gLMxC7KfkkyYNesl59CnHDreT4dpZ/hgxkhWv4tOlnjxadmDvtFHKLVRsajRh/dqNHX6gzaFTTPsyz5Pkmj9K//v3xyZm8vqb5v+g5mg9tyflPejsuM7dpa56iQDpTqp/O/DW3A5VkqJYFL2/IMIOHYJf2pGlMnllEQICF+UCQiqwbrLcmVOLPZlLoEJ7CcrpCFTJ8HYbtortO8GssDDszfNU3pqkbyOts3CN+fkZqDoyTINXvKSPUtyg19mwbRwDzBqgLVyVvi/AxtjIrmOLIKvJMsH5bOxU+0Op7UTds1smF6pC8fE6R6T864Hq1rcLLB5t6StpeaIxZqecfV0/T0EKIU7VSTbWBgCFc7ngVOR6/UQtdNFX/1MqbjrP754w6bWI2U6AIEyMvhNHoMi6IrYWPK2x77IXIjweW8RsWloTcL35nHIqeCVOJaYqu7IyUZPhQZCnmMMkTTNFX6HQEluhUCHCGmEfmZyfdX/POnp5CkI3GVAroHdAE/RVdOzw2Qu88Ip5leSkrFJi1nXgotI56jm0I92mNW+wknyS25SZhRvxGFFKlp0urO3hQs4/2galHwztXznVAv4Q+j5JCKt8xu
 U/8aCgWP
 71pEN9ypMowz9k3oGaHiTiBbxYP2D/zrxM0+CKO7SaKYCH1ZDM0NxAuV3riJXvn6nq19W03ipl7coznSgjMB+cW4Wh6Qwt1mPSYclhV+1cvi1Ax4Y2N6hBRgeOXSJgPvsOQ+3CoySzZqLoLDsHJkeQ/w5Td6i6j3LbEqcbs9g37qT75KZPOrnNDSZAqJuEVamg212gLXGUtlgjyjlu88EZtzjhKh8VdyTqVbt/P9iS1TNTWUr+b98KiZs2XPV2/t8iGUY3wGxo4BqQ8p9JDlnKKfmBJfrUFUOw5DFLb7JiaHufPGaeypPN2NxPkx6BRRWMVoVCteyuSwuigFy1X1tKaBzYAOhBJpR+nisJPpNXFCtJU4dkKIhXwMWiwodwi3euP8MX9u9Emgi9EozRijJSI4TCE2zQZOJTWwV1rU4+yjuwebMvONc1Tkm2kU4SOfmNZOW6HjS+rInRDqt28/17erb5GLQp2SUA9uf0ULCpXzQjvK9hYfHVZ8R3GNyfCa6m1S2lpCbC4NVI0waim6NyTYWSohGI/Yyv/nvVLBeCA0NauUEdGF1R4WhpB9ITDIDpf86B9JzEVNztY1ArFdtFM+G+y2NsUlzgTF0mdaz6gUeOwn1BHg5SHVtYxmB4xP/QwERnWm5jAPROQ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert external links to kernel docs to use internal cross-references.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/hw-vuln/l1tf.rst | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/l1tf.rst b/Documentation/admin-guide/hw-vuln/l1tf.rst
index 3eeeb488d95527..60bfabbf0b6e2d 100644
--- a/Documentation/admin-guide/hw-vuln/l1tf.rst
+++ b/Documentation/admin-guide/hw-vuln/l1tf.rst
@@ -239,9 +239,8 @@ Guest mitigation mechanisms
    scenarios.
 
    For further information about confining guests to a single or to a group
-   of cores consult the cpusets documentation:
-
-   https://www.kernel.org/doc/Documentation/admin-guide/cgroup-v1/cpusets.rst
+   of cores consult the :doc:`cgroup cpusets documentation
+   <../cgroup-v1/cpusets>`.
 
 .. _interrupt_isolation:
 
@@ -266,9 +265,7 @@ Guest mitigation mechanisms
 
    Interrupt affinity can be controlled by the administrator via the
    /proc/irq/$NR/smp_affinity[_list] files. Limited documentation is
-   available at:
-
-   https://www.kernel.org/doc/Documentation/core-api/irq/irq-affinity.rst
+   available at Documentation/core-api/irq/irq-affinity.rst.
 
 .. _smt_control:
 
-- 
An old man doll... just what I always wanted! - Clara


