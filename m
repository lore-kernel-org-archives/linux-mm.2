Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E2CCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76218E0007; Thu, 16 Oct 2025 02:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A264F8E0002; Thu, 16 Oct 2025 02:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE728E0007; Thu, 16 Oct 2025 02:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76EB98E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:39:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10075160201
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:39:54 +0000 (UTC)
X-FDA: 84003027108.06.861BF2F
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 463CB40009
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:39:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AzqtwqII;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760596792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XLYz+sxApW+N3B2ZP3MIw842hzBlsff9zJ8nO/j1d5k=;
	b=hTwMnWZr/TSXAY7YbJFmSFmXPVK+gWBSWBYvqBnhOAjvpIiYo2a3Pon58R9DMrCMRLPAsG
	t12YXsgKUJiCAz+ommF30ep1hTU3HzuDG6EMeMid90QqF7QBQB4WWyVrXUaAlC7QTMB2fe
	9nPCCn94TpJW5Y1XcuVmmbEJSqi536o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AzqtwqII;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760596792; a=rsa-sha256;
	cv=none;
	b=dpp99DMsrjlnaIhgSQLtvobfMlUAfaiCBfrDbmgjQcTcvJ7Yx536Dem0R7br0JA/PS16E0
	e7IkIsS70v6utC2h00hoyO77iSeh6zJc94sWEXxZLqHmdvBiAqn7eaOgaVaKoPlFTEzZi4
	dP8Ib+qGTYnMd64sLchdL12JBirLJFM=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-27eceb38eb1so4478055ad.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760596791; x=1761201591; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XLYz+sxApW+N3B2ZP3MIw842hzBlsff9zJ8nO/j1d5k=;
        b=AzqtwqIICpF6Ew+IVbI00Yb7NCMPMYRhAfO5YQvSMW5nwRzjL1D67t0nP9DU7RGrAD
         MGilGPqmDvdoMCjNlPsy+b+yRv6tPpL4TDpePGKZHCJOWXPlfvSlDOKoaEcMUHqdiwOQ
         exAXuq3ENzUp1XfbUJlG5nBSnristnxbXQw0WiZAn9JYkp/LkBwlgzgcwGFoPe5xw/0/
         ZxTTWXTY5sKAH14HB1Rq+njz3Z8buZ/lFxNWYmO+Well05lGQ4nRykNootw59VeKXBzl
         aT2isCxZed30XIMWaOIS9k+QkXscfQB+GKaVsCPk5Xq+yu70j/uqm50rqQKL1jTOmI00
         gNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760596791; x=1761201591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XLYz+sxApW+N3B2ZP3MIw842hzBlsff9zJ8nO/j1d5k=;
        b=UV3uz18Plf/07AiY5NzQ4awbVTrZvAgdhioTNe5RP4EetrLS6ICxP6NeGfEHDz4tA/
         PNKiDeLRF6s1JDDbuJP4OYdFekqa7s0MOX9BB6/Dp5VeKO9kTxlTVXA5uohln3PgaewG
         i4nh/x1C5OJ0qSZroAERemi3ZkK0LagxCOLJlhgA0SQH+aJDjxQlLqnHvfJRd9bwKByX
         Qihc4xIL1u7xUnYiYb0FR5gRn8qookmolIWKI+hr0AAL76wiXyc/suDsz4841NPzfQMm
         VGjO7guW+hrv9yRxdWViL6fmmJZfp7wC7lseo/6Gzow2F+LbxvqrVOWzot8Clj+nFNIS
         BW1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVc1SNrVZhKQbEL6UtKTucwwJQQ2f3LCHVAfZF/hCnVkUzeAUBYEL5a+VwKr3xvl8KCIIPZgkr5ZA==@kvack.org
X-Gm-Message-State: AOJu0Yz4MDAkHEgR7IAGzgTQ89bCKLwzcIVw+rXQ/a6k8eqUcjyp2S63
	1l7yQFFBIsXX8+6XJkEYg9JblbtGgEsEjtL9P7N/jLJcwkXb77qa6XbI
X-Gm-Gg: ASbGncsphPMzxZd1Z+jnXqPz9MVFY2V8q8ittrZCxa7BvDFe3f9nJyS3PksQbY/v+Dd
	LcJ63JicKn/B5QVFL/PvYQ9X8lrnuoLTwExSBSHGRFSbss/tidYJwoSb35o6nAzLSkkBFBRfPu2
	GWE94dXDWEexGvNoqxyRRzjsgU9D3huHfsOdvzvQAtlXFq8xiHE/x5kdsC/Nq/iUR8ekjEoW1W6
	WlBclDnRIK+HPTc7AZfaNQ26ao87bS6cGHtqp1tIy71OBkCB1544UOE2zpdf8UrRsba3sLq/CZQ
	zhKEq9RKbdlivJ6GTScVfieQTNgQ5HvHMYSp/PrBs+TSUluyVfGIw8RLJedCbWm0lu7Vj99BGyW
	Xg72dIMPziBKR1JBdaHGPaG9uIuAIpHLTeM8RoLf6igv3DA8ugHD2ORcbnf4RHOMZl56w+O864m
	8+32UB6zl0VWankPpScWOYFyZ2n2PhB2/E/edqiFg4BwYlJqJPcDw=
X-Google-Smtp-Source: AGHT+IERjmYAk4jdxuLqgB3pee8YjcgnDd7TPXuBe1q9Otc92V9NoAqnoqGjA5dhRZzhmASR6Uev6A==
X-Received: by 2002:a17:902:cf0f:b0:290:a3ba:1a8a with SMTP id d9443c01a7336-290a3ba1d59mr18628905ad.53.1760596791121;
        Wed, 15 Oct 2025 23:39:51 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1d64:636e:f4f7:9293:7b0c:3078])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099b0215esm17555295ad.112.2025.10.15.23.39.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 23:39:50 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	root <root@localhost.localdomain>
Subject: [PATCH bpf-next 0/2] bpf: MM related minor changes 
Date: Thu, 16 Oct 2025 14:39:27 +0800
Message-Id: <20251016063929.13830-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 463CB40009
X-Stat-Signature: aspofm9685rucpuobcznih5sfqw8mmz8
X-Rspam-User: 
X-HE-Tag: 1760596792-228181
X-HE-Meta: U2FsdGVkX1/FHxHnPONWtRIfR1qIOfzG3LU3E9JVhIYP5SYdGZY3f3+LDZUCwB61FSPd+nNPArul+7Bs/p+1S+BEwmvLue48WaHcBgoljGYGyViAmlbbD9UzEYfnbqFHFWezBXMej9JEVPm/0LcPKW9GpVPB++Ipq7JAIGgOSqrxYLeRKzDqKC6XAoFO5EBgqk7AtoCGa55mR8a4WnYj0AWi4iVkh7k+wFT91+yCOci/aLJ8f+MpbzLoTpjhZHuW5WOC9N4vkwu72cyzU5yTKAWP64NBlkp23sRDHoyD/RZRAlT7RY1wcylrViWtQIRuILQx9pmyueL9Nw4l/dpA2WmrbXagSCMtJrhXDSIvW/Y+ALQmJy5jXUknNYdUtY/QHreQFIeEsjIDIq/eROch1qMa6f9cfFz/o6pJq3Z29cF70D1qfdZ+us/rRDfxDns6sUBx80YlyQmkGRKRwwpNv5Heo5IN/MjmQsJDtekZ40Tuw6UByVtvwimN1RgfK2OCWfo7nHhOGGu7yDP4SjZjbv7PcrpTeVgFj4qhO7Ajs5n7ycDxzLNuYlGDnPChjcGAcW8fRrF7JK+XiMlrRKT85d3UH7mQepU78hTUWCQTQoj+YeWrXLFu4ylghNaaVfiKYB/ARyN7MOwS8Wky6Mg5icJ2Tx+YS/p42OZIVGpAzOI0mFXYpRWcNOpa+OXuD2tqV/hIdb9RlHKZW9YH4vQwVbSEyRax8DB/ECmgZRmGAtpIZ/gaxzHzLNFuPNZFgi6i7+h8Oy4lwn+RszdyCVpem++mRYJXS+2H7MHx0J/ZCkMvRUsm00is33GbQv0UVWkV4stbZ0QA+px/ucPCk5m/ejpOPAcC4thxm3WqposnDMJjO1RqSSxVaKUMtkgRJqdGQTBZITtouM3a9aqlQ+UU6D2zCLA4UqUALFDYdjf3f1u3ZiqSzvQsftbkahbzGltDwQmtluGJAcHHpUPKB3p
 cOzStH4h
 WwfZhE2/9RcJzNB8S4eWdG6tgu1DsT1GZWiPUpacE2gbjNIVex+v66D8GnfCy5laGQ6547uuzTCL90yzaqe0EELkr56/trE5m1RC88a1Rp5SihprdLlkk0Sfe3wLVZ4qwQ0J21nl7lFVMQqaq66nNaaZXTqJBQnv3DD77QTEElS8JomaA5M/ik9LyJxlnAtBdNrboJjEr3Zx1Hr2owqgw3PGuMbaBlE0fr3kGFXWMYz8gOYqPvf16hatPzIWi3R2nLDkbfH4JcwnMrDoDZ/QGphHsmMA73GFnTASzD4HuxQ5VMOUftRNkfK61jQQlet79XGAZLNYTpDWu+V2HMtWHKbROWUQRl6HSL3SpCm3b5Sp2KSfM4+a/2FfHb5K9uU+TbVqZto9AetM8EaU2UccPsSQauEKZAXDnSbloxUo3Tt9r3heeMjaKZcjDtL9Qq7fnlJZssc8Kkpag2qHYbHnii10Vsft0Yo+FpNuqzdaYgyCpY+XyuXghyXfdR2VCPylxVrG6zsECYjR3JcYI6bQkgP9c+3PhXSs7WIm9XiPOAzkkXLDqlN7gc2Jv+iRnOv5/9hqeIsNmopy9aJx4C7SR5dGX2Ve/N1mmVrcA9SXS+KfPDLQ6ESgA6SQTuVLS+/j4Kghx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: root <root@localhost.localdomain>

These two minor patches were developed during the implementation of
BPF-THP: 

  https://lwn.net/Articles/1042138/

As suggested by Andrii, they are being submitted separately for review.

Yafang Shao (2):
  bpf: mark mm->owner as __safe_rcu_or_null
  bpf: mark vma->{vm_mm,vm_file} as __safe_trusted_or_null

 kernel/bpf/verifier.c                   | 9 +++++++++
 tools/testing/selftests/bpf/progs/lsm.c | 8 +++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

-- 
2.47.3


