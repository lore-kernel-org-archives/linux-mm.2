Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C51C982FD
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 04:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE8B6B0088; Thu, 24 Sep 2026 00:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280436B008A; Thu, 24 Sep 2026 00:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172106B008C; Thu, 24 Sep 2026 00:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2EF66B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:04:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CEEF8020B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:04:55 +0000 (UTC)
X-FDA: 85247314950.18.816B194
Received: from mta0.migadu.com (out-48.mta0.migadu.com [91.218.175.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 27E34180003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:04:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tEnr57V5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.48 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790222693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=To3UWtDOEj/NdfNHQeB9MGXtoG6IDrBG8ZqSxzMa7Ec=;
	b=tJibzQRyVArn1tKxgFTLS3xVY22x86ObvRw3OicBYemEr+qCVOfGE8fAXdfe51wAFjZ9vr
	tTxSmAKx0GXAh8OP8mRtFtBHTZzBfnaRlOn8xDIo9cfBMy3zcUkHkK2UpwkbHjS1fVU1nR
	ozeraMi9sJvFaNJXAtYE3zlrGc+yxfQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tEnr57V5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.48 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790222693;
	b=UW1Wn5feBElN9BdMWBGiOBhqHBrVTHpoy8YiokYHrg2UDUSgU5WO1LzTv9XfF37QM/1nRs
	KHcb0bChSmQyebq7vWD1/8Q95q4/8Lw4X8F45gOgf81rdTiNoS0+8jg6iSvCvw9aK4Me12
	3MHWT/8lLtG0NWcxjOMTFMlklERgsVQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EZyImxcigBOaI3Lh03J91/GKsa2Gh4enEbwmZ8MnhwA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790222691; v=1; x=1790827491;
 b=tEnr57V5/cXCI7HFITG5I+4K4yZBm74dKG0omFoTyFbw/0uK+R2pZC4+P5gfoBZWFTZWcWqD
 ecuoRSAgpBBxcCM0WGJQOGj7fVqSFJ6QKXa8QXQ9aR0Qj5s9ZX/Rh/YxRDN3fAQl2R35tJduvPK
 tjIn18cBTX2DrgheCvU30WyE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id b65a1ef1592237cd;
	Thu, 24 Sep 2026 04:04:51 +0000
X-Mizu-Trace-ID: b65a1ef1592237cd
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next 0/2] selftests and sample for bpf_proactive_reclaim
Date: Thu, 24 Sep 2026 12:04:31 +0800
Message-ID: <cover.1790222105.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oda61isb84z5dt1f55pauqb3yb4fjkas
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27E34180003
X-HE-Tag: 1790222692-140835
X-HE-Meta: U2FsdGVkX1+SBvXnnW1cpK8o/Wj8iytWVc5DltDONXGtutomT2pQcYgpW3OSpBGetz+MYe5sEp5a4zeZsYGrqylEYjdUKeSayHdJSGWF/BHovxIGhoBScTghvlJpC13ovXD7KIllqdK309EpoGk/gwUGsrekTwni4KnWWecfDLaPOWreuQ1k5yHy+/zdO6GwaIw3yIE6qgzA5kBPiWr/aMq9FraEzQlosWF+UcniFrmLbHyxuX3ZC/G1uHW32ZzaoDdysVfswdb7zymw7NcxDwMEY6df8/kgAe59n5yn5VoPr1jRLW54ItpdK5Fido2chrJU7q0j/giahLWSrGdDe/fFni8uX48PnRHlTdNdqu8R2TGkd8uSLuolsk5ZuP6M3ZXiE+unOpQpXQeTzcMN54RFvjGdgiRS/ZvP3phE9Oq7XtuhpSr8s3KoTmEILn2D8HMTFChTIt8MIu0Bq10xCKTj+utYsnkZjxYD6PcfO17QpSV2vNI6qkGtAYRrqaMKov0Ppc3WfhnxcJeDIETgWra1BqVFgeO1EEBeweq33EP/PTGbg/UBYi2QkSCaqH3bvmd1HMpljJH80O/rHOL7gtIE9axfjZyKDn3soGdYYDjhKeIvfyjb+tItQ7oCX0wKk8b4ub8eHX2O5zM8gbDJ+Cb9V0FdI/K0mlLQOz5jvEGdsJ4uDcS6MNAXPFAo+NtHQbcoh1YftNM3wWoHZoPjHtH8/gWMnbT9hMXXFJRiThYCj5A1VWlx3aoaANSRL8Zx0DNUdoPxMX4iEQqufloBG9Dpqwxev0Bu8jaqzBP7hq7JMxHIsuGymf1us1pMUDMjq5hPsQdeu3P18fSNgUpxHZGsCYU2FOHTIJ3mR0M4ujf5QcRhWt1yfsECfGuRwJdRFQ4tSZ5jU2fCLy29zxhdTqalSMHMFch/QeNhL211ErxGypEWtEWq2qGZOXiGv6DaV2k3v8QXhta+9DaIYHu
 i5MVwq6h
 ke0SL0d+KPleiVr33oCa/i7rPOpCUIHfdDA0amwWB4N91c1Ue0i+0bUUn/ClELIl8r/NC6QwAt8/JB7OsXLDkGybu3uIxrGk0V91CSd4tMNiDRH2/nJAtDzgJqWcSx5u0DnYhMyvAJ6wFLi9xpD0kbVahdFZuDBqtZrZSPjlViQ2Gzv8tm4MwSXdnot9kRmsXSXMI9ajf+6g2Ds6aAmFfkwu1rr6wGmev7ZlTnCVIIBaE023hY+iXZ48APUjujrG/aOMkZ30UwcwcNvsrdfw21Uj5TuyHxzw2nu5l1eEsSNlNKmyYaE1Yxm0psg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

This series follows the bpf_proactive_reclaim() kfunc patch (v14, acked
by Shakeel Butt, reviewed by JP Kobryn and Barry Song). Review feedback
on that series was that ~1200 lines of selftest for a ~20 line kfunc is
overkill, so the test material is split in two:

1/2 is the minimal selftest. It mirrors the memory.reclaim selftest:
charge a cgroup, call the kfunc once, and check the single bounded pass
semantics (one call reclaims at most MEMCG_CHARGE_BATCH pages and, unlike
a write to memory.reclaim, does not retry until the goal is reached).

2/2 moves the complex asynchronous scenario out of the selftests and into
samples/bpf, where it belongs: a BPF program watches the workingset
refaults of a pressured cgroup and, when they grow, reclaims a target
cgroup from a bpf_wq callback through bpf_proactive_reclaim(). It runs
in two modes: bench recreates the high/low priority benchmark of the old
selftest, and watch keeps reclaiming for user-specified cgroups as a
simple proactive-reclaim daemon. Besides exercising the kfunc end to
end, the sample is meant as a design reference for anyone building their
own BPF-driven reclaim policy on bpf_proactive_reclaim(), bpf_wq and the
memcg kfuncs.

Hui Zhu (2):
  selftests/bpf: Add bpf_proactive_reclaim test
  samples/bpf: Add memcg async reclaim example

 samples/bpf/.gitignore                        |    1 +
 samples/bpf/Makefile                          |   10 +-
 samples/bpf/memcg_async_reclaim.bpf.c         |  349 +++++
 samples/bpf/memcg_async_reclaim.h             |   39 +
 samples/bpf/memcg_async_reclaim_user.c        | 1141 +++++++++++++++++
 tools/testing/selftests/bpf/config            |    1 +
 .../bpf/prog_tests/memcg_proactive_reclaim.c  |  124 ++
 .../bpf/progs/memcg_proactive_reclaim.c       |   34 +
 8 files changed, 1698 insertions(+), 1 deletion(-)
 create mode 100644 samples/bpf/memcg_async_reclaim.bpf.c
 create mode 100644 samples/bpf/memcg_async_reclaim.h
 create mode 100644 samples/bpf/memcg_async_reclaim_user.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_proactive_reclaim.c

-- 
2.43.0


