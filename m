Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6BE9CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0398E000F; Tue,  9 Sep 2025 22:44:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276ED8E0002; Tue,  9 Sep 2025 22:44:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0537A8E000F; Tue,  9 Sep 2025 22:44:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBD418E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:44:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B79E013BAED
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:03 +0000 (UTC)
X-FDA: 83871795966.01.9ADC7FE
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id AE3DE20005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CzIHHQ8X;
	spf=pass (imf13.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isRfEajvq74JD8Gx5JZkbk62qSgMtw6IJwcPrIolSGc=;
	b=M6QggQNVVkuH5yhz+3HE2GsjmAObsmKkexHSZlC6N8kYEut0p4Exj2aYOOf6FNq9ZV/h2v
	mhEJOs2hmAM+/eIzTTXRQD5jXpYjl+ChOSLYYXltCMuwKuUu3FVJSV7UyPPWb6YycuZYut
	Y5rpVHwtP0L9VuVqF7TZZLLIfytGUyg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CzIHHQ8X;
	spf=pass (imf13.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472241; a=rsa-sha256;
	cv=none;
	b=mt46lBSjnEeksqgFFMl7LTqtevvNqnVhTegfD0vWTFoZ9PrsQ+eELDBPMF9jjE7+5AsacI
	ymVTToBKuxFrjQPy2i+tac0FcwVQwTTPTWlHkyHMWAR3723J2RwYBY+xa0gp085D7XvUVZ
	9NnYYHVdzOfZVYzFCQ6RhgRbtshseXw=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4f9d61e7deso4013824a12.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472240; x=1758077040; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isRfEajvq74JD8Gx5JZkbk62qSgMtw6IJwcPrIolSGc=;
        b=CzIHHQ8XTe93HAFCa3JaMRVMTRSfxdenlCqXOIExEJ90hF1tGY98jNXRY0GHeJ6XCj
         YA6Fw48WKwOXyp2yVqFDtYX7JjdCIgdS4VYGBXR8rlytsgyETfUZ2AVObAA5rAmp2Bjx
         WdZIhJPA+GYPUVJ3algxiS0NkMYnh0Zk1mJliejWUOPMGxKguMP0gfuxpzyxbxC3sj1u
         vbyUGHyq1NQNUgkWModImG9C0YLiWnAf/aLUsnrn0IlwlOMTU1yhZJ8BdT7A9hfFfUhD
         j7O4xvBd1mkgxEA58AQ6RVy32UY+q/SLd/oPoFpaCJemCCiCNV+hINPSEH5+CFtUdi0m
         Wz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472240; x=1758077040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=isRfEajvq74JD8Gx5JZkbk62qSgMtw6IJwcPrIolSGc=;
        b=IlkpYRtkQItopM+A1hTtslLkGn/SXgOetw7/rzpby7lE9KTuYBA174sowW3rbkL78P
         +vGyyPwG0+2s9kRwEU3Umq8HeVguiPdiAifxWghvDraMhv18djb7a4LdtURPuEFuxkEY
         P7HZFBcCBdLJijeKZeaQUTnqudXPz2xbh8QIWF4qZXwuSXyMspDTsUpwPr0PsyQMpsbf
         qOxZfSh4aaVi99AE2aYu5G5awWdHRMZZRi9xyBdW2JkChY2j0c2HceLUVzSiltSDDtu9
         BznkkPZbuhhqYkfiiYkHRP/tHbAPnSsyuD9cbjvAh6ppozZTy9QQjZm4G4/afcvF8YSb
         xwaw==
X-Forwarded-Encrypted: i=1; AJvYcCW1sTUcQOkc0JYZI8XQRyGOuflU7SZETJy9UBapgPdZFngfDkXAM8cR+JxYV6UGIDv+AiPirWz21w==@kvack.org
X-Gm-Message-State: AOJu0YxjCuKaHLZRjVXNEHuPIn7Oo7ugzIru1Y36NXnD3o4daybFd9YI
	dpDnpBD4V5SF/cmQkJu12Xb0I26pEkQYXNeWS3OWSA0PiffpfLIxOsdx
X-Gm-Gg: ASbGncusHt722F/M35FTmYS+OF52m9ESNPt6R1JIZMsRb2euM9FAstfTGDKHe3H1xWb
	WzQEWk3AhX21pWhuthGXgBGys1wMfdvQhMLuOA4H17+vEnbe++D5jaDdISQNxnMPFw2S0nMg73s
	//guCG0GXLH1C7y0MMVOg6lnFnaMaTsBkomfjjbtIuB9P2FcAZLvAAvjqgnLjZjL6hWOUAFRp6Y
	/y1URh/iWD/B/SYFMfC2eNRduVKwVxKN3JFQKaWzaBTQsXTGTSw93lecRso4VbTfxBpEwOnKJSV
	o7V+jRf9gt8Dha38z3oclfKivpKoNay0Ua4seQ12VfgrhNPyA1v2igE9jEKZIlSl+nHzCfAMM6l
	3rWSTTXSW90auV8EPaMPiLKATiA==
X-Google-Smtp-Source: AGHT+IFrrGtrsp5QApHqrAEsH4Lf99kNe3GTHl7qChWDynb5tQqdU4zGL9zb4NWW/Nh5w4cYNQSmBA==
X-Received: by 2002:a17:902:c943:b0:24e:8118:cc2f with SMTP id d9443c01a7336-251734f2edcmr195946635ad.59.1757472240373;
        Tue, 09 Sep 2025 19:44:00 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a2ac085d8sm10840225ad.118.2025.09.09.19.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:43:58 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 4B76441F3D85; Wed, 10 Sep 2025 09:43:52 +0700 (WIB)
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
	Jani Nikula <jani.nikula@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH v2 04/13] Documentation: amd-pstate: Use internal link to kselftest
Date: Wed, 10 Sep 2025 09:43:19 +0700
Message-ID: <20250910024328.17911-5-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=945; i=bagasdotme@gmail.com; h=from:subject; bh=Rg8Js/mQ+ji0aVDnd3uUR+wPkIV7f8cZoyAXSG+WzrA=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHnihuCjbtUDpafXJnbOHtXRdvzJjhG/D0b9KEh6svl Jx1Ocjf0VHKwiDGxSArpsgyKZGv6fQuI5EL7WsdYeawMoEMYeDiFICJSHcx/FNfPsFU6huDt7vJ kh1V1uZRLxRT1SOqp3E8VV6+6XDdK15GhiW/r34XtloUdOCT982MLd7bz2VGXmhWZatxbn38c0u qDSMA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE3DE20005
X-Stat-Signature: jrjkcm8yparycckzdbodrpnnxyg3h86f
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757472241-354696
X-HE-Meta: U2FsdGVkX1/Y/WiaFowzgsPy+wDpIZSXZv/sIwvL/V8GVCg+5WcVIYT3BdrVD+3yb92ZcRIKDMp0hwrcBi1swfp3rfOdPDPeRN8RWSVFGF6pjzc4hhx4Qz/hVacCEM2tDZklicxVNtOfZkxKwaG1vorygzD064AI39YWn1WPLc/HJeMQ5blKQi+BbNBd9+Vc/4s9ouRvJ8WuyqyAjsdaZUeo9JmeM2yVg6RYQGO9gH8S41BYZl9xVb4qWV5rj18JgH65iG3BGhz1K6V7Du29fO9u8EwQRY3ghoEh0IuCvhSb+hOSy3dX2H/jxDZLqkPdg+XR4cot79a5IkIfkWrWmfm6CD0F+y7jfy6AiMdmIvgk3rHU8iWtCV/AvqlYtlSat/Su9fBmXpCdvirROk2YUcoBrBIBOsFGAarFdvBE8ulGUUmFQ4yyvhPFAQQ6Q+pTUz44FRmy7hRZLsFmmYPQW7mOtugYcwvgpM5rWAwgMiaSWJkCEd7QuXTK1r2fNTlvpjayfC2/pLpaPbwbxK3fpnuvdQVHa7rTPmHZU3KTgRJZIrrQFRQEx9d9RWX+BOooTZJzflFdbe/ONn5AS2oinuZgUD99zU2dcnGerzW/m1PA7x0SRJ9eXqjTJQcNqH/Zt49WylQ94DPVocqjXENvRBltTrTpLoDqNbJDyefj4g4B6qiS8oEug0tpN/9EiITTaEjmmHcNY6NXEUGqVjTWWQWO7SlV4cNwjSLk1AMIgq2AlS3dJG3MgZjohkN7EASxdehMsUbRo8AKr+MKUsqdOCPQ8JpcVKMiesDKdmpWbFE8hh6b8NW69gsx9wL/THsdsGiv6urtslGnIH2mchOCO+aXu45AfrFg+YXFzJiKVLHzpr1gdXucD4YhZQ2JRSt8FCT/N95WyPJFDFBtbzXu7BfjIadVl5mcFQ5O6ARAZRYYabftAU4ld/+Y/Y77VGXNB6rWKLLQyrQyiWooBsD
 YLES3a2A
 vOO8oS4U/ZyXsDx3Sqff8eroEOLa83FVUWwTfi++AabcPd0/1FDszKPhswwd40QVhlkbW8BnKoaeUN+ewsdwQAW2CrYfI7Tff54HWGVR5tHEtGVw5SoHVCmE1vg0j1hsqf7fBQvlviZNqZebITCsJhJXCJTMr3HaEIq634ed+0uPhwlmuCcyLoKHLk32AWgJS950Z6QHlO2CjSXw636mcKgC4kn2ZKXBP/TR/PJrIHmPR92+6slf7lXCGGIrgnZmkM+riULY7Bdk4+ojBtnbzJyDegX1G/Rhk7FJZqHn3yCoi5y2GVfZMzLcIvEOp4Q1zKTynj6t1Aggsg2Dx2cjt9DyLrjxpFYgd2c/no3V5GovWuGB4yNm21dsm/V1Abp3d5PhvmhjSMT5JEji8bpUFM8TR6iJEUmRQKRyuIga1MV65soeBFx35D5f2CDwbFXrb6T+elEVlbmU1gyqmhAoErE62MDIvwTIThE+pDSPOB6TeMyQEjhOKqFuin26TDSKc2JE3u3tBdZnzy2pOueMizuSLaCOG+xnVESMPv6uLnH6S9c0QGTiv2zSoKaq6vTYZg0nA8NkTkvZAb43/v0xVZ0r1j0QjkWUOodjsxzCTs2Pr/g5PXE4HTYnz+KKP/tesD5kuN69Q7MJDmlfmcJRo8UxfBTSmGzBCrJncpkmOlXLUGgWdR72Ifz20UrNeADWuJU6iNtfUuAc7/KPONYWkEAP7lA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert kselftest docs link to internal cross-reference.

Acked-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/pm/amd-pstate.rst | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/pm/amd-pstate.rst b/Documentation/admin-guide/pm/amd-pstate.rst
index e1771f2225d5f0..37082f2493a7c1 100644
--- a/Documentation/admin-guide/pm/amd-pstate.rst
+++ b/Documentation/admin-guide/pm/amd-pstate.rst
@@ -798,5 +798,4 @@ Reference
 .. [3] Processor Programming Reference (PPR) for AMD Family 19h Model 51h, Revision A1 Processors
        https://www.amd.com/system/files/TechDocs/56569-A1-PUB.zip
 
-.. [4] Linux Kernel Selftests,
-       https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
+.. [4] Documentation/dev-tools/kselftest.rst
-- 
An old man doll... just what I always wanted! - Clara


