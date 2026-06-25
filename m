Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70CE9CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7E86B0088; Thu, 25 Jun 2026 04:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432376B008A; Thu, 25 Jun 2026 04:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3477B6B0092; Thu, 25 Jun 2026 04:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01E9B6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:34:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 575868FE19
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:34:50 +0000 (UTC)
X-FDA: 84917774340.15.1F8E594
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CFA6100007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:34:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TbCetUme;
	spf=pass (imf05.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376488;
	b=uqeFwpovIAbHvu5/8G9sAP5SKw2TzVcvyEv5r51d3NJUP3yv6CIxZbNq6fq5bfYNYTwyeP
	wkI6C4ghsxRljj0OTSxRMIPVqRocefDk7qEUreS8xjAlw5ayArA0YvXpTuxFV8ttrjFXoQ
	NC7rwTh+qX5osYjKGzi/ssvGaNXwuME=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cwuPvDSXXbiyOTdpO1yF6fW9CB9apWEc+I7V+XWMZf0=;
	b=AsZvNE9mS4WD004qneyyaNAesp/wH3nwZRG6DpIdGVy7zhYm2zduLvE6Wals3WtS0sfw3a
	IVqE0D6CUjRMOfF9YvfwAGyi2qEmnThKz84jEUrKSd3yzRv+zDLbp+1qi0Wu3GxBA96Bfu
	iAxwnnUGTtzUF1pXjSuE+3zbX040d+s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TbCetUme;
	spf=pass (imf05.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4629d80fa08so1808333f8f.3
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376487; x=1782981287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cwuPvDSXXbiyOTdpO1yF6fW9CB9apWEc+I7V+XWMZf0=;
        b=TbCetUmeEnrDWt0d8nuHvjISrdCAKz5oMeLGY0qhfrVC7fhxEnxVE5AADEa7Je4Q//
         nU4h533dvxW2QzNOWfd5hU1KsBQ6MmbEjeZ1wlwqdOvT024yZdfU+Epfgjm83Ij12caH
         gNU7VaFUWX5MMiX6EfPZjeuJCmseSOfgXZpMtcdqCtKuLTNGzgzZIUW7ysX6eqTXIVC+
         YtUBqYdqzv8wZ+TZyZ5IBJLsYKm54jTvXxH2A5A+RKeANcmnWcSnBpzpxqsA//AJcRLr
         RNy6BfmMVKgJmImL8G5ZXP3kd1DyIjT4y8wfCdAFGqZDtuWhNI+Y/PxbMMb4MmgllIbP
         aaDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376487; x=1782981287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cwuPvDSXXbiyOTdpO1yF6fW9CB9apWEc+I7V+XWMZf0=;
        b=AxoKJCnkBgbYHXFm/zHD9u3VZX8DHXc8POZx4e50n0O0W/GWIzAQlx7TzTA1/g/E+a
         TSIhcInVQqRsmuVhOjaZCGVh/6pWHdXthygahzsQh9XNaP7iQ4Uiw4w9t32JJQR5WUb4
         TlMg3/vLGJwlWD5EwEGHBG0kKdv5oPjxHDA+X6QFX4cpfbZ0iXY7rFhgfH7EHiWt89wE
         7jcJdo+nq6HNW715wtZP5Vv6wUzpeYIgiMcBSjvCHoO66qrAJbV6bDv10OliE086udkg
         QkHu38Mzbz5XfrJOx0JXcfkicmra3BMo82gdfWEJb480RHsz3T/1K1VrCcbgRPYtTiVK
         p9IA==
X-Forwarded-Encrypted: i=1; AHgh+RrgtwuFZ6EREae8cudFdEwACPbQvR4jYpvDJzQ3lbvj1csHRgiCkEfvWWD7mVw3nXynvwA7X0ug/Q==@kvack.org
X-Gm-Message-State: AOJu0Yw2QECKWVWXE0l7jAkXpPwb4CQleEkSaVPN5yDRlGZHN+M+yx6o
	ax8r/vzVmrPcm5S3zV+0YCTCckSK8Ouar5JI5E1iOoSyskmdnR+xhrf8
X-Gm-Gg: AfdE7cnPlSHHuKo//EDHui50/M1+heA30ISczaw1PyMJDrmciIrpbvgUC8A+3koRt0m
	3T2Umb3Y4FvEsUoL35bWNPAGnO0jXwd1+2dbt0aVwtEfmS+z0qZQ8UcfmfpfaaQYuW/TbcTny1A
	SBFEihussWlo1RpNS6yzPYZuWBtklnA3aQEqKTKnYSImRs7Iaemd6HG/dC6U9YQQlSQGRcb+b7O
	g/YmQiSYcWtlc936e+zXiLlysmr/K2kNNCNZtHlmLlWmeaTI56nImJQe2YhamCbYlekF+2qI8N5
	Rf/z5jn/JP2V2GuMLYmoAHHsG4MJT93eRFJNy9Q1kqtQquBJuFwO35vkBZ9WucjrW5sM+CWQQ/T
	2rCQ/YBQaJ/7GMLmFfW8sHyL1Q8y7G4xD19fpmFCXSxeFXKAWZb89udQvL2GQuHVYqdoXeaZiDM
	zVgbq7V1zV
X-Received: by 2002:a05:6000:2f8a:b0:46d:d6c1:8383 with SMTP id ffacd0b85a97d-46dd6c18494mr1746107f8f.44.1782376486646;
        Thu, 25 Jun 2026 01:34:46 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c221d998esm13183555f8f.24.2026.06.25.01.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:34:46 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Val Packett <val@packett.cool>,
	Andrei Vagin <avagin@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 0/7] vmsplice: fix some problems in my previous vmsplice patchset
Date: Thu, 25 Jun 2026 08:34:02 +0000
Message-ID: <20260625083409.3769242-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ua9b9kx985xa338z3px663adxb5sehns
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9CFA6100007
X-HE-Tag: 1782376488-572881
X-HE-Meta: U2FsdGVkX1/aLEnFSdKoueYwYit7TWyAtKJh6UZ6VYJO3m6Qoxj8N7eBaJ/8BI3K4lEEVsnUNkKXsxFc+cyid3uBcEHfXd2V7UaDkwj25wQzOV10li1sihOpzxbZsVUdj7oFotM93jFb7RLsFlFyr3VYuYtDj6D772oDcD8qHUKSaBT2QIBrM+swCXAaS2BoUvYAM0PsQh72L17gXK3aGBiEsSmYIRHeRTziFDDUAo5zz48xiraYj1DkKGXn8KHNcHgbj3WjDQ3WSPirFELGQHlcQ02U8LrUtW4P6kN1qLTBzUguDPdeI2tXaPfE2WAX7bqNU6vf+rcSXv40vn/jAIMkMWhw7tL4OZyOVJLzL45PeddQVs1qyBs+hgiccw5A+dRkLMY7DBHvvCaJZN7nHB5Eqkj5mU1tU7xKokeICMaFzEBVyayLvhi1UBa1XeF+0wpn9sPxSfCWvgQCNNOUjrmINdVukwAAl6h/HmBJMjxZvCeFyNFrkqtnBFTRTOu2zQd/y/v+4r4ZQkWfaU2TuFvNsHUBf4/H2CoT+BhF/HjGETkxLBWE32dCwqq3BkpENvwd2SGQwYNOW/y61MBGDJUvoP4YKZOza3OLepbrebJyqW2mq0HS5sjvjhIswZIwVscmwmBVj6N6iL5CyS26DbCv2Fac9CAMir7B/Xf8WdSj/qc/hw4wQukLixKVFmclSV9A28WOH/M/lshnVmAu070HWfiRTNIdDoo3T0qvCdUtebnYkxPvMrElvotv9cE7DNXCXqNhefCxkMrHWWvedetbh5yA/FDB5OzlcAy4+zW9F0W07VX1lZWgXpFXQ+YAWBfhsojvan8ZLMF4B195Qia/Kf5tZ7L6OKF1ROI2AIjVFQgtTiIugx5JKKsBsECp4xqProl1LJT6+PHg1DIoWMkpfeUEHRezCK20Wzg7Vcg4YgodOgC60EZvkiueK/SW1d5J4/RyLaqJTaSX19X
 IhueGo16
 KZIUGJ5oGL3HJ7qQb/x1HGu9/gPyC+gttg5U4v3IGVL0O4D8gzbje1s0Dg4TH3/QBZPm/pkqM3VkJHxSEkqSZXC71Ze3Y18OBWEX3ZS04/pY0b7win3hce//+XJOztxkDkGxxKIjTpPVifB9qcxmaXZt8GnLBVKltHBfvXYR3s+zmEEuDUmNFEUZwM812HT8V115noP86/6m2z/28DAlkP5tmaY+hbtQJ13myD/LE2KWlHpQ2D+jn8sWyH5coNIedp0maEXRgi17topBMnWfHe+Ek1QE46j0PcwmayFyKBuKVnGa5/+YSzbs/Cr2hMzUNvz5T3QHYLWvYe0k/R1dsR3DygcvggRoXUutnXKQeeIQohdSZuYHLkkhNERkRZFLI2piG+I36S5nbECdKrl4RJ3IN5TwAiXRsfDS29MUEeAxctTW6ueTLkANZH2LjCf+Rxb2VhuuVZV0xY3ec4aaQ+MvYhPkDuC2Bv9q8loujkFVf0/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset is for VFS. Of course, it depends on my previous vmsplice
patchset ( https://lore.kernel.org/all/20260531010107.1953702-1-safinaskar@gmail.com/ ).

I fix some problems in my previous patchset.

1. Fix problem with CLASS(fd, f)(fd). See first patch in this patchset
for details. This is probably not so important, but I fix it anyway.

2. Change "unsigned long" back to "int". See second patch for details.
Again, this is probably not important, but I want to fix this anyway.

3. Fix that LTP vmsplice01 bug.

4. libfuse relies on sharing vmsplice behavior. So we detect particular
combination of flags to pipe2(2) and vmsplice(2) and return -EINVAL.
This forces libfuse to fail back to non-vmsplice code path.
I. e. we fix libfuse-related regression [1].
I did debian code search for regex "vmsplice.*SPLICE_F_NONBLOCK" and
I found no other packages with this particular combination of flags
except for fuse itself. (Okay, other packages are fio and stress-ng,
but these are merely testers.) So, I think this is okay to return
EINVAL here, breakage will be minimal.

5. Set FMODE_NOWAIT for named FIFOs. CRIU relies on ability to do
vmsplice(SPLICE_F_NONBLOCK) on named FIFOs. So, I fix this CRIU-related
regression [2]. But there is another CRIU-related regression, which I do not
fix [3]: CRIU behavior in splice mode becomes so slow that splice mode
becomes useless. I personally still believe that removing vmsplice is
right thing to do. Other option is doing nothing. Yet another option
is to implement some deprecation period [3]. Let other developers
decide.

See patches for details.

Please, run that LTP vmsplice01 test again.

Notes:

- I want to repeat: I change behavior around SPLICE_F_NONBLOCK.
Previously, vmsplice ignored whether pipe itself was opened as
non-blocking file. Now it is not ignored. And in my opinion
new behavior is better.
- vmsplice(2) now is in fs/read_write.c . It is very similar to
preadv2 and pwritev2 now, so I think it belongs to fs/read_write.c now.

Please, review this patchset carefully. I'm still new contributor.
In particular, please, review that do-while loop, I'm not sure I did
everything right.

Tested in Qemu.

[1] https://lore.kernel.org/all/CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com/
[2] https://lore.kernel.org/all/CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com/
[3] https://lore.kernel.org/all/CANaxB-xUrLQYGiRJZc4Boi+KX=0TJSWymErNovANVko20fMDVA@mail.gmail.com/

v1: https://lore.kernel.org/lkml/20260606061031.3744880-1-safinaskar@gmail.com/

Changes since v1: fix fuse-related and CRIU-related regressions (see above).

Askar Safin (7):
  vmsplice: open-code do_writev and do_readv
  vmsplice: change argument type back to "int"
  splice: turn wait_for_space flags argument into bool
  pipe: move wait_for_space to fs/pipe.c and rename it
  vmsplice: make sure we don't wait after writing some data
  vmsplice: return -EINVAL for particular combination of flags
  pipe: set FMODE_NOWAIT for named FIFOs

 fs/pipe.c                 | 23 +++++++++++++
 fs/read_write.c           | 71 +++++++++++++++++++++++++++++++++++----
 fs/splice.c               | 19 +----------
 include/linux/pipe_fs_i.h |  2 ++
 include/linux/syscalls.h  |  2 +-
 5 files changed, 91 insertions(+), 26 deletions(-)


base-commit: 8d86fcfc2857d64af85f5c87c193c25655c970af
-- 
2.47.3


