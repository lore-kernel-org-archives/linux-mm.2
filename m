Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F75606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PnAvX89B
Received: by kanga.kvack.org (Postfix)
	id 4D5AB6B05B4; Wed, 18 Nov 2026 08:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ACF26B05B5; Wed, 18 Nov 2026 08:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3156B05B6; Wed, 18 Nov 2026 08:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F23D6B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:22:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95F0580780
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:22:38 +0000 (UTC)
X-FDA: 85448304396.03.A8B9738
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BF559A0008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:22:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PnAvX89B;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795008156;
	b=MLtoTvGCXj0ydBy4QxDYI1Onrcdr04iCIox5cEBFSmxaP2jLy1R0Zv0utBC4uSiwSqZyV/
	tD3MuHL+u/v2LQaP6TbXtDHRmbyXGgrwkiG6eDSMW/ekoAx+FhEVxjk3zfrjCdbNO+95wa
	T5fl12W8BlbKXOVddFl/vn01br3FHeM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PnAvX89B;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795008156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TF6UKCst8lzq0LV30okvmZ/jdB3sqBqVgF0ME6NPUU=;
	b=i2DaQpwKqpMSIqqKM5j74aGgQMeAmDcxvbF9OBhrO08TagJ0sAEIZRQZM6N2bxFu0/zVS5
	aFyfOeuJobieed+uAXIe+5l9kVEFWozgJ4ApqiKuYSwsXCBC+5e8yeuJUkaUxhNxUPZIDd
	geucDOFhwzY4o8E/F+NSWpyJ070+sd0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78CF460D5D;
	Wed, 18 Nov 2026 13:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142691F000C4;
	Wed, 18 Nov 2026 13:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795008155;
	bh=8TF6UKCst8lzq0LV30okvmZ/jdB3sqBqVgF0ME6NPUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnAvX89BLlompbeCCkZjl3vr9MCqKZciuydSOpL0eogzTLskwf3xZTohivEs0roUy
	 SGHE3ptZwvcw56AzvAQmWHU2AKWfZBJ1Q+aHQiUujgs16dQbeouPrsRjUXjxqwCmzL
	 Ic0BLwqP6KqS0jGWCMS2T/Ixdqkpxh4ygAhpATxyMBjSiigYgk4GNjPL5CPg7RuAHm
	 2wFGRm0miTBwzMDFzEuxnDS2tc8VOXV/OZSGQmr95YsoKwOuCDUI0e75scvGjYgnhZ
	 3DWuuj7B7Ts5+S7mf+y4R+8vNESPWSyJ/M9EWivAgicYCJ5uI0mObnGGnufPMbHttt
	 d5ZeN50+Ga+jQ==
From: Christian Brauner <brauner@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Julian Sun <sunjunchao@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Breno Leitao <leitao@debian.org>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: (subset) [PATCH v2 0/4] writeback: make slow writeback report more actionable
Date: Wed, 18 Nov 2026 14:21:46 +0100
Message-ID: <20261118-abhaken-flocken-popmusik-322cfc4cfb7b@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1641; i=brauner@kernel.org; h=from:subject:message-id; bh=17BmXY+svo1KKAU3k/ez0FW6KIlSlOJjiwLKTuSYAHE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9XdZ/5kOhJceeRM/vHyZofy/xnxT4zdrUsSbiyamTA sbRT85N6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI74UM/z3e+ShL79f9uLr3 jg/fksyjM6fc89T1ub/9mXZq3aXuc4GMDA1OrMk/izVsRdd9amKoZV95hK0/V3jVt8rFS0XKtr+ 6yQ8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF559A0008
X-Stat-Signature: shskijjj9eqwqfxg9c5khbe68ondksna
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795008156-971576
X-HE-Meta: U2FsdGVkX19RGxarNw4sYaU430CaomplquyKQajtjpBEPlRG9EPgrCRadtuVN8AM9DY2zUBuW/D44dxQNeC3E9T/7k7bwR0l6bO/HvnzFX1r6NqTSmJeZWnZogbDpkqa7Lsqd7f5MzwTPy9lcefiOmvBvOrNbZCkYKEy9qubhi6Mnr3ZmI8so1j7ykeyNUYJAaQj1VO4TGQgUDjTjZFjIDup62cu0MSqCTAQBsL9bpMEnUbLDVJL+7YrF8k0XG7wVHJkDXZpI6/ZV9FFB0xvkq8Ib6o/HDV0naNMd424WjLgphyBUuJi54fefNXvRM56nis6mINdTA2Y8jWpzzxYNFgY4eEFfavvUjf3xBxmIG7LT7HsGvkPt9Qi9u4CagWM7dSVLXdnRiSOKwvmPrrd7HVmxght/k+ueFcyaC7rao+cCOJ6kZerFrTd+EauIUqb3Dgu7D9ZlOS3h2Xoz6xFsQcW3k0Zky2Ds0Y91eY4aNc77YxmNWh9BrWKnZxZRIxs7+qDNYp0pxeibRkHvA50zABAqBq9JJU5m4Yd/2DtlhsHSbVA7Fa4FS/Tx/gfx5VycN1RgpVq2oRX6ipomoBH0XJKNqNLiSPU4Semd8tzrdQFQuakSmvtj51ZnfwUkdzxpQp9tLvaU+N16mzWuz00smZPXVmNwioY5ccJ8DHPzy3+S7LSflfqFaUBpEdBo4gdmRBYiULMDQ/Ngf34MdB3MdwKvSLF/6JfPqtFSpdMQ8jCQ5O+Do2lEBfE5pFVtCnL9nVgD+EFEVQ7fzQDtgkjasEqcl3jbAmg0kCbPEBOSoN9yZ8jXqubP/PcYIenaEsFlwmm/vZS2D2CUtsOEq2hJetjZfsEwtK/ysRZbpYRaUccA8Q735SwgKqP7Q9OKE3C2MdTg/8Uo1j4fEPJapTPDtTsuejvj5TdsXjzREhGzCXmcAj9ZU2m2LCTQ0kVBm1RqdM66oRvUXaU9VJGoFY
 t+3Ahlim
 7sp4BWqW9pm6wR9sPUfFRgabgj+no4/l/CoM/eLwvyyvG2LHa5mW/Cf+jKG92qDS5kKL1x1mBcRcMeZPta9wJlGVqbKGigdPs3p+vi+91wljhMzC+5w2CnhZtGGzrqyCa42UHYnCfIP8ypSs5PCCuSm49HE6PsFYuybsiyhUVQgGqTta/fYOkRJlcKhIg3bRU7QD0teCwEOlZH3+6W/yfTEbuVqFe1mXEz5cSu6anEf4Ra+84kRMlxu7cmkNwhuylIItTJ6s2R+3tK7G80q0lVXOm8oBX2WsMw1l6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 03:39:26 -0800, Breno Leitao wrote:
> Since v6.19, writeback waiters are woken while their writeback makes
> progress, so a slow sync no longer trips the hung task detector.
> Instead, a waiter past hung_task_timeout_secs logs:
> 
>   INFO: The task sync:180 has been waiting for writeback completion for more than 28 seconds.
> 
> Across the Meta fleet, this line is logged about 19,000 times a day
> (the median over 40 days), and up to 82,000 times on a busy day.
> 
> [...]

I took 1-3 as they're fairly separate fixes. Please rework 4 as agreed on the
thread and send it.

---

Applied to the vfs-7.5.writeback branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.writeback branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.writeback

[1/4] writeback: add the missing newline to the slow writeback report
      https://git.kernel.org/vfs/vfs/c/82da6ca38c26
[2/4] writeback: name the bdi in the slow writeback report
      https://git.kernel.org/vfs/vfs/c/8dd5775aab52
[3/4] writeback: log the end of a slow writeback wait
      https://git.kernel.org/vfs/vfs/c/26286f60c266

