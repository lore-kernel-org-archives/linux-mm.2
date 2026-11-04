Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B889D606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AzTo5fQd
Received: by kanga.kvack.org (Postfix)
	id 959206B00EF; Tue,  3 Nov 2026 19:08:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F986B05B1; Tue,  3 Nov 2026 19:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C846B05B2; Tue,  3 Nov 2026 19:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 590B76B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:08:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 984621205CF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:08:13 +0000 (UTC)
X-FDA: 85395499266.06.D05BD5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9ACCD40007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:08:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AzTo5fQd;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793750891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQlFV3h8W4hzcc3wXLAhqdkni6VgrshaevEowsNExCQ=;
	b=kvyMbKKQqAXflzcIuflXAwhjmBC+rKvSdfC0OqO2EdGg2ATV5kOUFpz0BeMyY4YnC8FSlx
	CPyv0ObyMwJCEfKptLrXTZfF3OHJD4Jj0iMWPWKgFFSK+wWAd8Nh9jscKTty8Q0f2txTcS
	7xLEjdUTef4ng6zklbOp8RjCesx4v9o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793750891;
	b=dz080EJxMs2OyX2AGJUYkEVuRmvfOzaLXn40/QCdZsLD30zB8rEA/wAFYJNQHDb7kh3X8E
	jlThU1BRyyj0xz8hXxOedLxULpKIrLkViaXofFjgr7tCNcO+aWn/vE2NYvtxKLm7yMSPCK
	MMMq21es09q89R06hJQk5fzoeOxluU0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AzTo5fQd;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AFD643EBE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DA81F00A02
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793750889;
	bh=VQlFV3h8W4hzcc3wXLAhqdkni6VgrshaevEowsNExCQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AzTo5fQdsewTd2AiUmb/7d+25HXOqu8+DC38kun+rc0Fg/iiBZ9h8xwozHZ8oKKaQ
	 qCFO9A+a2dnhDrJDhwj4tCympaqPPsDbenICxQM0LbGl5O/8hrtlmsd5SmL7qHwCR9
	 gtbbJDnLhTjqVsCezKv2lDGDGSrNBCOCNliAzvPoiWaAi20PP15ODXcGIjwpX9BsEa
	 Mg9KuyIW3TdfTFaC+HWa1W1xSbP0797qhv210gNNB5xSv+qWYsUscu+jD/DCG2IZSr
	 lUOC+mZXwm+gGIpMqA0m8ogc8D+mfNYQURO9EQt4zExSSCK0Zhd3fkVVToMR4kQBbN
	 VlyS91ZVM7HAA==
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-53c4b82919fso1062561cf.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 16:08:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzzV2p4Pv5hnX+eewDfb4b7joVnrPcigVycQ9wYALtPGrqVdIGAiIYYWc0RTmjuPwLZfO9oovBapQ==@kvack.org
X-Gm-Message-State: APuU4Z8aH4Jzlra4ZytnGpqHGqSArdFP24q0EuQ8czmRE85NkXcLPsPl
	d41el2tZ9na3nQSKxI9SfKggiAWa/xU5bvngXkqm6zi6Zm8KSpmhYRoOEX4QOJRBdB0FsJMKsYZ
	VU+kzfH+L2f/I0LuvTmP0RzXOozRqiLc=
X-Received: by 2002:a05:620a:444c:b0:93e:4d60:d389 with SMTP id
 af79cd13be357-9442163032amr2590329285a.25.1793750889004; Tue, 03 Nov 2026
 16:08:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <cover.1791577417.git.ehab.ababneh@intel.com> <CAGsJ_4wmSL7i4EPLWLKhDD6J=1TywBi5EYYDxp=SvOuXdmLGjg@mail.gmail.com>
 <SJ1PR11MB6105E839E55E9B0BDE183E9D8C9D2@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <SJ1PR11MB6105A05870574FF39B449CE28C692@SJ1PR11MB6105.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB6105A05870574FF39B449CE28C692@SJ1PR11MB6105.namprd11.prod.outlook.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 4 Nov 2026 08:07:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zwNo3pqXkE_XrcU8ar7mF1O+q+FOxZc-AZeO6go9PxNA@mail.gmail.com>
X-Gm-Features: AclHuK__-B4xhragLAoUY61P7F488BPbmVRI2qru0syH4YCL5Ok566Gx0Ciw0z8
Message-ID: <CAGsJ_4zwNo3pqXkE_XrcU8ar7mF1O+q+FOxZc-AZeO6go9PxNA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
To: "Ababneh, Ehab" <ehab.ababneh@intel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"buddy.lumpkin@oracle.com" <buddy.lumpkin@oracle.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "axelrasmussen@google.com" <axelrasmussen@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "weixugc@google.com" <weixugc@google.com>, 
	"david@kernel.org" <david@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>, 
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "baoquan.he@linux.dev" <baoquan.he@linux.dev>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9ACCD40007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7qq3fmjp5b3ip495npdnnaq1iz9exx9g
X-Rspam-User: 
X-HE-Tag: 1793750891-780460
X-HE-Meta: U2FsdGVkX19NfcZh/1dP0DkWOJFED15IjFE/VtVe6Ufvlo+8eN0D8+SQMfrRYF2UNGNF4JUtaqVA/VepYCj4P0hgdP/Sq3V4Cz2wNvEPCyzeraewNjJax0eYLDgeCwEyjg2qYbHxSSaxh3q3XR13kGhF+4bCyhkJwMAE89Fp7NDsNiamiXUP9vHx30BgGziSXyO3Z9hvWnncY3zUDTikDUX25FvT1Y7Olsfi3sbK/izhBD5nb1SEaepgBZ+wzDQnxkXz3jlKseLzmar8d3vdiBbSxp1oXfGTP0vtGTQb5N6nGjjOrNLFhMvxacmCQlKcdmRWJZLQqsUQFLs3azbbuajHZDXoC5EvyIVgHCt5Cj9xqOLq2yRxNdKIhjH1IxFKZJyfl+KRmJt4zG6Q+emsSXvss78YIg2R7upmvATXne7hO7Gu4Qj/zb4A1OC90PsYE7zt2CE1Yk/gSG6gRBu4ARuRdJ4Rp9P3OoQwxr04/kbTDbkQe/m5+7w8dSTkIeQr/I4wjiq7WXihsDzEY5XNBygqT44NN3z5Zqy8r0TLR2FxZ9fHPouOLsq/BQZ/u7KzYsO2c3eqgipzpZoL817TJpw8PdGY/RqwPlW+nebGB46VHZTgdoWhK8RSHCSTOz/XNjhGRjWHNOmaF3uejN9vRHlOvMv7H3mazVJ1xcfg1nI0xuiLUsBLungICcVDkQzdcwjvqUw0kWBo34dr+b0m//pq5iUUCEpZbAPl9sE/N6LLOtfMG3DfS8gWCcRi/mD3TpP19ibu4H4X7xfZDVwInZZDMUeuFLQoMRfj8ofuex3VeiPC6R/Q11bvx1RLJTu4T1hPEL/3L3fuBoNo9wbHPPWOIRK4vUrSbZDC6wHxCG5uWSvdmJNmj27shiH+08KaWWzO9fhF4kgd2swZW2zd+JP/o43V2a3X6rG3lWQjAGo01n1HBK8ZmVRrmLxnB5hFitzp0MuaFtmoQ5xOeOA
 OaK74uAA
 K8JUNqEPAz1HEVDiNNMoFHabF+REWTcjpbxKxbBe7i/ALwE4R8KGyp2mSs5VOue568MVNQp65qj7pQ+uhN07FUT81bykxmDk6nkyhpeNnCswvEYQbtclgWtuFOKOiPvjqgglli/f8YHDPFZck1vGSnXVfszj9zL0c6TZhK5HzRspbrjZ+Bxn4FXb6/bAsGYBE28Q06osHwSOOShZ526lvURHctHq6xVKRXW75pHbp9lQ0Z5FGmJMDek9SFYX9yGW0IWSbNojZZHrPP2R8R+2bazDxjZN4m3+9Ti4JBCLZrtcGizpO0sS2WBtg7ZELTKB1eZWbZ1yh23n6urU6QtMabrvxPtaLbeoWPGZu56p12ETBE9H/A8JpKc+ctIWYb7HQm0zAnTkwRu/u3WY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 7:42=E2=80=AFAM Ababneh, Ehab <ehab.ababneh@intel.co=
m> wrote:
>
> Hi all,
>
> I would appreciate your thoughts on how we might achieve a similar
> performance improvement without increasing the number of kswapd
> threads.
>
> In the previous patchset, using four kswapd threads reduced Cassandra
> p99 latency from 6.5 ms to 3.35 ms (about 48%) and improved throughput
> by 10.3%. I believe this is a substantial result and worth pursuing
> further.

Hi Ehab,

I assume the performance improvement mainly comes from
reducing direct reclaim by using four async threads to
reclaim memory. Is that correct?

>
> To explore alternatives, I tried increasing the reclaim target for
> kswapd passes (testing multipliers from 2 to 100), shortening kswapd's
> sleep intervals, and making it more patient before declaring a node
> hopeless. So far, none of these approaches has produced a comparable
> improvement.

So basically, one thread isn't sufficient to reclaim memory
in time, causing your workloads to fall into direct reclaim
frequently?

>
> I would be grateful for suggestions on other approaches worth
> investigating.

We have various types of proactive reclaim that can run
asynchronously in parallel:

1. Memcg proactive memory reclaim
2. Node proactive reclaim
3. recently, Hui Zhu even provides a bpf-based reclamation:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D48ea1ba704aa3a9

We have these approaches that allow userspace to
flexibly ramp up reclaim before we have to fall back to
direct reclaim.

Also, if you're using zswap or zram, compression itself
could be the bottleneck.
There was a proposal for kcompressd to handle compression
asynchronously, which has been on hold for a while:

https://lore.kernel.org/linux-mm/20250430082651.3152444-1-qun-wei.lin@media=
tek.com/

Or, if aging is your bottleneck, perhaps something like
async aging could help?

I'm still not sure where the performance improvement
comes from. Is it mainly due to reduced direct reclaim?

Best,
Barry

