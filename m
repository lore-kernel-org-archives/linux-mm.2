Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 711DDC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 03:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 579496B00AB; Fri, 18 Sep 2026 23:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F9A6B00AC; Fri, 18 Sep 2026 23:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C4A6B00AD; Fri, 18 Sep 2026 23:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7AD6B00AB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:07:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCCDD1A018A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:07:15 +0000 (UTC)
X-FDA: 85229025630.29.DD2E270
Received: from mta0.migadu.com (out-142.mta0.migadu.com [91.218.175.142])
	by imf12.hostedemail.com (Postfix) with ESMTP id C815F40002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:07:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ifvYuX75;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789787234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hq4S8CcRaYwtctA+BOu3psDdJ3Hm5CC2SiBZ9Lk5JH0=;
	b=unH2htNwclOHtIq+rzIarqVqWApocDxXJBA1WZ9w4TF9ITrlgtcns7+XT1WAfeSdZ5E5j/
	wUEuaEQcGsWi0FZmlpJXqL7fWEulQIt2zACZyqoXmVT7eT1GUSD0TaInX+RXb5Scyw1pza
	gUg10vfnUGsRyAO7C8LpCSO1wFnLXYM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789787234;
	b=KHzh7AR5PRjJBWz5fcAyZYMia/mT7/K3o7w/9otn+D8B6tSBspSAF1NsYKpnreRfGKHqWR
	vT8QRqMrpNRjbTfO6bJtuWlX94fYlSGCOgNZzOz5X22YLv0ey/YTGeYEWCecxsMfsITkH0
	oR+cId+ddGwxHLXmq7M+xDGKx5Q94e8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ifvYuX75;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.142 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mEv5lyTLXjPbg50EKTMVu3qs0TVt6kgprNwgFGaHm1A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789787232; v=1; x=1790392032;
 b=ifvYuX75R8iXE4R5+yLfLclZ9qZ+bvjVAIHDAeAnKmQ23BbiUsuQntm9tt7kYASOT7HVGnDG
 BbpUX2Jgu5DHYaDau3GiQaR/Srz7I3rgl8+s9Oj1CzXMN5HLcfEFXUysvrs3ZN3RTxSvpeCRccG
 +5cJFT+QgO9/+mX+Lh5r+mOo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 17c77f7b96f6f559;
	Sat, 19 Sep 2026 03:07:12 +0000
X-Mizu-Trace-ID: 17c77f7b96f6f559
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
Date: Sat, 19 Sep 2026 11:06:49 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Bingfang Guo <bfguo@icloud.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <90F1D900-0756-4A33-AEB9-5554D646DA57@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C815F40002
X-Stat-Signature: zat6yfgjfhingg85369t4h4e5kky84be
X-HE-Tag: 1789787233-370040
X-HE-Meta: U2FsdGVkX19oRNea5NIegtDMNSs+ZFkJNE6FQe5rX9+LUJAdPAaLr2AtTyVRx2DoIh8quNFT4+nwbjDtcMMMljhNUaz8ln4p4S1PYbs/a/Y06UWPlsqtw9T9/nntxaSQLcDGIKKV/fnsp3NP1OeN/2mgNzb+qi/uXxP3RY46qXF7OIJieV5GduUEsauxhdLHXrmBpVXDdxrFduKgi8POe5vx0AOJqq7EMcWQVehAN4rml1Xnya50lXW9MigjsqEmXzWqJ+omy9qLub8/qlSdP2EN2vkKXSRjmPVuU5avIuBIjCDpGS2rT4/Z1vFjQim0vVOrtffLdll1HOP+8nkYBFeRbly6h6m1RO5RcclWvthGNziSf4GrC+856tjbQ8LENRfFVwhpmMynJx2qN1+RTloSDq+VXTZWKCWVSNySCkP812FRHYT5ahq7aH8wAtv1i7VB6kpmYnohDNLmEi/GUfKvJZT23+AkEAfwTKVZyphpLHtSHtFbDwkBW8GtzlqbNF/D8YRUCZefGKW21leWNmhKYq1jGSBwfDdhZbzGT79DtQSaTCLEMXssWIN17WtFcsR6nyuSZRfcIHnzpYZl2Gbcfb+tERp8z5zRU1oXjF4cOslJPz0yhI8Gyzm1s9ze/nUVLFHXnFEspReVUnar3L+wSFU+fYTsa+UUGSF6CngOjoR1/Ol725/Q5dMspY7de4e9z1Z2xYuCj/clg+j6dQDNrLBdcAMTd8yylzJJ9BnGvh4FjUd8d8gWn0wc1jFodQh3Ln6xakWq+h4ewUsf8UEOaUt/z9CH9slOUVSRtV2qbic9En19YwSsDZ4bNNigwph7FGsd0pU3/N1zZmTADy4X0JftGj6TdjIZG/Pza8+SzSlfIhkYLIiSQBRQaVKeMIoubi5KhBiHwePIdraS57OEN7dvPGLcdJr/VsWHlElCId3dGBpXigGmCBNn2DWmyTmApEe/R+sL2OY0AOh
 h4/UXEda
 5GGTCUAx83tqIiHCIIBhRN5URGEwujMCFy+UbJv6sooWLTngJeyKMiTF0Jd3VPnfH8K3zPMSFHHuIWSXfTGbDlswV912TWM5lw9LsJhdd7yxWXDxjRPqPzg9NvHINoffEHg0wvO7Oh3z2OQ+LIY20jsoQ1ye917uHJj8smjX1K2KizsfaXECKkZ3uOTjj49oaJXvZK/MjDY30QbUlClCc5mxnTn1BEADazLWJXvcIpQ0xEAdHsQm8aLqZdWuLe8ltm86ZOSw1IL9QIFmG/0kV6UyCmA79ALUBdpnLAerHjbRrVDl3h8+WfSvHCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 18, 2026, at 17:18, Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> This is a preparatory work for moving memcgid from memcg to objcg.
>=20
> Swap entries retain a private ID rather than a memcg pointer. Once
> private ID references are moved to objcgs, the ID can also outlive the
> memcg to which it was originally assigned.  So it's better to make the
> get and put functions accept the ID itself instead of the memcg.
>=20
> Rename mem_cgroup_private_id_get_online() to
> mem_cgroup_private_id_get(), and make it return the ID only.  If the
> memcg is already dying, the dying memcg will still be used for =
charging
> and stats accounting in v2 swap charging path. But they are =
hierarchical
> and will be reparented after offlining so it doesn't matter.
>=20
> Make mem_cgroup_private_id_put() take the ID and resolve the reference
> holder internally. Convert swap uncharge and charge rollback to =
release
> the reference using that ID.  This introduces an extra xarray lookup =
for
> now, which will be removed in the final patch.
>=20
> Separate the online-state reference release into
> mem_cgroup_private_id_kill(). The offline path already has the memcg
> pointer and can call the underlying put helper directly.
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>

With Shakeel's suggestion.

Acked-by: Muchun Song <muchun.song@linux.dev>



