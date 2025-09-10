Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8085ECAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BCC8E000A; Tue,  9 Sep 2025 22:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC54B8E0002; Tue,  9 Sep 2025 22:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A949A8E000A; Tue,  9 Sep 2025 22:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FCA38E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:43:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D763160616
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:43:59 +0000 (UTC)
X-FDA: 83871795798.04.E675896
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 49D88140008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:43:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Oe4UOzyV;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7bLAL3/wNh9TSZolDjbNqAfIBJnmt2XQBMTZKVFm5qw=;
	b=MgbeXhFBRqHtKMp+8NdsZvr9OgsaDfrfT8sriCoF5ZwtSNiK+o8QaIuHiCiwM3hyxrVGZc
	HdeyhCdSXIWVl4LFoTS60nXXcYNho7gWqT9Y8atQwQLsdwE56VEGBaJE57rgop0ihAQ/Hs
	FYFIJW/vVN34oWp83Lwc+UTMAxG9lJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472237; a=rsa-sha256;
	cv=none;
	b=tW63vmp4NpT6XFOdYsTjyHjutkf/1TEQrn/OtdFCnvXOMR7l6BsoNDKycMTFgZGi9s0lEd
	Mepw2iEjnx1NVKkFn9gU8Vv5oS7xuS/oaYi4sWShViaHKS8ta7J7awH9f8Jt5msGl41rES
	kp516XYzFS77/LT+u/ShP6uoBKn9IWc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Oe4UOzyV;
	spf=pass (imf26.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24b1622788dso44081095ad.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472236; x=1758077036; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7bLAL3/wNh9TSZolDjbNqAfIBJnmt2XQBMTZKVFm5qw=;
        b=Oe4UOzyVgmgay14KN9dT4VxdV0bKdHbQXReHK+5JrZamfQSOvYYepckfd3q3+EgPxT
         RwyqolyaRkFIQcFgLFz5UlWFiyJ5CJTwX3Gl11zJ8FrrEsx7SzSs6l4jUPFQjKdZihN3
         fTFaban8nl8dITb3r1kh7BZxRteMJiann4raKYLzW7mjKUHrMtn72xy+RqMbnoK6Cnwj
         QfE5VCC3LkuY8WmAbaOzfvRKz3/+78fXNh1xyinsS4x/2MnNKW2REdK6U8htrrvOYnBC
         iKZ3nd1glJMUm3zESqqhSxJdF3elksTv0EGFbVAVfBXM/lleqb0GAAXa3ID5za8eMqgw
         LB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472236; x=1758077036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7bLAL3/wNh9TSZolDjbNqAfIBJnmt2XQBMTZKVFm5qw=;
        b=TugIVfou7grLGBMSp0e7MoPlR7buA5OPbJc/xHo2ZYXSHUZB31FYnbrZFNS6sIOFSR
         H+ndLGigPjGmhbC3kXdi0b06FrIEuaeCqaixH132u5bhkopOScBkxdx0sEw1z7Mt3PDa
         te2rH/rgbL1/JnKJ0nEj6qnTzHqYmL7jPP2rJno6vhOvMlFH56hAmG/ZT9xsHwUUHois
         LEpt8SUmgeHD4U9fKVa9fd6gVPJht4EXXVr9CGjgVZv2vu2K6DLz7uM4iypS2IFdepNV
         qYhDD3oUvQqgmXp9ZS1eWoKTOD0ergzTHVK4HUsrgFCpbRSCM7CY/tz4kwuEajMSfdYN
         rKfg==
X-Forwarded-Encrypted: i=1; AJvYcCVe7iMba6rYY0S4CZXgMtkgGSHhckOjkW71mn18E027JRo9gmSvdYUcFLLw+BCKdPaZU5wKmmqwFA==@kvack.org
X-Gm-Message-State: AOJu0Yw03CntXkS6ww12O93wPS3Cwkab+vuwu3scIo7OdVVzVUkpg3bf
	Tc8NwNHwVFiKWfBdLZZ48FxQF6qwwaEiRWRfOc4wFfPxAowCKlTIUtZl
X-Gm-Gg: ASbGncsh+SaXs+XvM+pOOBqnjboIbwYjUVxCtTqrxiIOygsytZngL2rFcY7gNDeROXG
	08b81egOh52hfK2iVMbBKuSoUqOPmJJ6O3N66qF/1zYS4V7rwpCKKhx5NclhmWJks9SG+T0RLc+
	J9qKZNasGV3jVJ2zdV8oVGpyUO9xuuEtmomRdNzJJLWxrN/oeJVojqeWvwxzaFcZVm/A3zVXzLP
	OtZbAVSK4MCGkiwvztkxk96QpabuFB698uOwScuZm5r8QtrHmf1eHUctrlefe1OFb/XHjToEmwL
	Yuy0i34C4I4Rq57nDJDxahq4WSWQikIbIiDudnJzPEOARMjCrzdve7jQoxb99FXYsgPMVMAqMat
	xvc4C6hWpvXdKloathGdW0uBtRjYbAiM2JwCz
X-Google-Smtp-Source: AGHT+IFGZSc9/jA9fPG6OfeDi4bv1kxrVTimgNKDvpjkwaVrL+5SueCfropq9o2yM0pmLNmhCmQCiQ==
X-Received: by 2002:a17:903:2350:b0:252:1d6e:df75 with SMTP id d9443c01a7336-2521d6ee123mr177310555ad.41.1757472236069;
        Tue, 09 Sep 2025 19:43:56 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb313dc5sm629853a91.1.2025.09.09.19.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:43:55 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id BD1A64206923; Wed, 10 Sep 2025 09:43:51 +0700 (WIB)
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
Subject: [PATCH v2 00/13] Internalize www.kernel.org/doc cross-references
Date: Wed, 10 Sep 2025 09:43:15 +0700
Message-ID: <20250910024328.17911-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3670; i=bagasdotme@gmail.com; h=from:subject; bh=YkGAhUMgv4n62Z+ysk68FYvIotbnN4rNKVg76eclr+0=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHnkjdCX+kN/Vk8dEtTx4oXHJVUlr871/34wNfprkGL ftS0Hh2bkcpC4MYF4OsmCLLpES+ptO7jEQutK91hJnDygQyhIGLUwAmss2M4X9W7lbP1sh5f5RO Hw1mqOzaUvQkVGr5Yv7A7uJI7gMzyrwZ/nD+Ytx+cpXRX/eb/x2rj6W/XClZe5lBR2mP0knB37f n7WUAAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kha4bz5jhcqrtxg7m9un61zyq6ij39oi
X-Rspam-User: 
X-Rspamd-Queue-Id: 49D88140008
X-Rspamd-Server: rspam10
X-HE-Tag: 1757472237-112823
X-HE-Meta: U2FsdGVkX18+wBUvplfX5Oy7tFyX0EJcVqzUbAEhhL2Tk5v8ko/QhdjIDZ6lPKHw9lKFSJJTOVCd7sjLOYA3xUMaGTmmC0YeTtZVEEzNXjin9Jdr5CdzgN1TCqm773nLPI2BH7ZTsXMYzPbaSRWl+lLe1/pyxQsPYPf3Dzxgv+oNdOmn9bo6hUmK6gzsLe27D8ejIGrFU0oa3NCJR1QjlAIneuLw/paAO95H4ZBsaKIiqYyCPT/idisOeuWhDiNYcHjkz6PBIQF9r5S2z5CwoT8bJhO1w+9d5tUzpa1d3JS4jML0og5w0YY2jXR5t7x01a52f8nK5VEmUHC0XMzQH1LoperaLDYbSnWJKaBwV3iyZjxtXIApZxYninqAd0j27omTx3t1kY4CuIWscPFw4AgA6w00101nst1W9Pp/HANLEK8/VRzIZp2c7kmkdOvCDiHtdY1UGWS7v49GJOQYWXWjNcLqKlvv+VZRnvG/aoDyIe3/zpTem3N26UhEYCdORiNR1wz0PGwleyxjoW8/MvDgyBdu6EMLvXcsM4jxYzOj2zmYfGuPpTe6bSalqQ1WcKQEk5qO7aB/jaSIhmZ7wMd+DhBQUmalKo/cSeboA1Dab5tXxR8xYF7+2Lsc4Rh4k2knuT6NIo1nbnkrGPs8TpoxOzB8i8UVAUEL/p3SG+Dtq2PqFilpIRVoZ+4lEsGTiP/pffHNWeMDKkbi8rOgxlXDQb8diMGX/g4vC7MI9GlFydxB+f6J9HpC84gFlW0fWqI3PwYMRFlWEh607T4eUFdU8MgWCUF//XSJ70Pa42VenQAkYXnOY/HGrxSNgdCpdjTOPLa+Vmxxzymb//ViA7gLW2npIqJFpwUFBhBpgFH/smyRJcQL+axdvkci6VxT4bGJkINYJktHtNTLbSXlBVDrZOFhjPH9FsN3KQoDt+HO5WlLd1F4oyGZkkzFj8is+1PcGF+D6mh6TuLUJxC
 95R6OjvI
 lhT9mtaUV2nO/BXnVtXq50/q7S8NYNTH5hMWfIz3BHzf7WisWTCtkQwAqEsCGpG9SfxRmcKlzXfbJwW6DzWRsrZgJ1WuBDIkciG/XNVLPUJ9cC5pGliOANBRG9ZDVbf3wrUGOh0wh6/vhclJguTBNZqMHsfi4oO5RWP/H1pYEQ5KKFolC847llYo8hGFEgkE3edUpeD1uQ/29XrW8hLyK77yVHp6/sOP7cy52PDRwLA6zB1b3HBGwWLdF/GDX9UedIL5Oi49zq3hdiWSL2BQHSKb7J+iytaoSMMoDGUTyhnoU1paJkaQFdiAc+pNqRxlzCgN4+aFdwmyyAJbT8RkHnF3XZCwN3iXpz+Zb4bGvN31GVco9uh5EjTSdXN7FKJZncZD6n19VWf4zaHSIbOhIJYoC1vi9GRf2rspw48ecklmc2FnBEB+Mts+maEhaDlHpaQDFrtSYj0GNkcj2ir/mFTEf3mPFrOntNlXLGYYr5Qhc59xbBrdmvxuyZuIrYhZr+97j4Lgn8L0U7qoVn1yz7/VMbBPPWmj1TnruyZ9hOTTEZTQv2g00cjSZb+uIT1VwXFXO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cross-references to other docs (so-called internal links) are typically
done following Documentation/doc-guide/sphinx.rst: either simply write
the target docs (preferred) or use :doc: or :ref: reST directives (for
use-cases like having anchor text or cross-referencing sections). In
some places, however, links to https://www.kernel.org/doc are used
instead (outgoing, external links), owing inconsistency as these
requires Internet connection only to see docs that otherwise can be
accessed locally (after building with ``make htmldocs``).

Convert such external links to internal links, while keeping the
original anchor texts using :doc: directive. Note that this does not
cover docs.kernel.org links nor touching Documentation/tools (as docs
containing external links are in manpages).

This series is based on docs-next tree. Maintainers can feel free to
apply any of patches in this series to their own tree.

Changes since v1 [1]:

  * Apply review tags
  * Drop patch [12/14] as it has been applied to sound tree

[1]: https://lore.kernel.org/linux-doc/20250829075524.45635-1-bagasdotme@gmail.com/

Bagas Sanjaya (13):
  Documentation: hw-vuln: l1tf: Convert kernel docs external links
  Documentation: damon: reclaim: Convert "Free Page Reporting" citation
    link
  Documentation: perf-security: Convert security credentials
    bibliography link
  Documentation: amd-pstate: Use internal link to kselftest
  Documentation: blk-mq: Convert block layer docs external links
  Documentation: bpf: Convert external kernel docs link
  Documentation: kasan: Use internal link to kunit
  Documentation: gpu: Use internal link to kunit
  Documentation: filesystems: Fix stale reference to device-mapper docs
  Documentation: smb: smbdirect: Convert KSMBD docs link
  Documentation: net: Convert external kernel networking docs
  nitro_enclaves: Use internal cross-reference for kernel docs links
  Documentation: checkpatch: Convert kernel docs references

 Documentation/admin-guide/hw-vuln/l1tf.rst    |   9 +-
 .../admin-guide/mm/damon/reclaim.rst          |   2 +-
 Documentation/admin-guide/perf-security.rst   |   2 +-
 Documentation/admin-guide/pm/amd-pstate.rst   |   3 +-
 Documentation/block/blk-mq.rst                |  23 ++--
 Documentation/bpf/bpf_iterators.rst           |   3 +-
 Documentation/bpf/map_xskmap.rst              |   5 +-
 Documentation/dev-tools/checkpatch.rst        | 121 ++++++++++++------
 Documentation/dev-tools/kasan.rst             |   6 +-
 .../bindings/submitting-patches.rst           |   2 +
 .../driver-api/driver-model/device.rst        |   2 +
 Documentation/filesystems/fsverity.rst        |  11 +-
 Documentation/filesystems/smb/smbdirect.rst   |   4 +-
 Documentation/filesystems/sysfs.rst           |   2 +
 .../filesystems/ubifs-authentication.rst      |   4 +-
 Documentation/gpu/todo.rst                    |   6 +-
 Documentation/kbuild/reproducible-builds.rst  |   2 +
 Documentation/locking/lockdep-design.rst      |   2 +
 .../can/ctu/ctucanfd-driver.rst               |   3 +-
 .../device_drivers/ethernet/amazon/ena.rst    |   4 +-
 Documentation/networking/ethtool-netlink.rst  |   3 +-
 Documentation/networking/snmp_counter.rst     |  12 +-
 Documentation/process/coding-style.rst        |  15 +++
 Documentation/process/deprecated.rst          |   4 +
 Documentation/process/submitting-patches.rst  |   4 +
 Documentation/virt/ne_overview.rst            |  10 +-
 26 files changed, 161 insertions(+), 103 deletions(-)


base-commit: f44a29784f685804d9970cfb0d3439c9e30981d7
-- 
An old man doll... just what I always wanted! - Clara


