Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934F7C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BF576B0088; Sun, 13 Sep 2026 23:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6707F6B008C; Sun, 13 Sep 2026 23:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538576B0096; Sun, 13 Sep 2026 23:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26A9F6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:40:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DBB20120F49
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:40:05 +0000 (UTC)
X-FDA: 85210964370.21.004459F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 269CA80003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:40:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pHy6fbef;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789357204;
	b=nCApyWcvmGH8hh3SlmHKxXu4cwG/WSP0bHfTSWqgjiewRg8V1v9pZypbeRKbDs7wcOK/jF
	wA+l92q8VNs5F0xLWLA5xuFZlLw7fY0cRAW5n970r+rb02i4FCztA3RDKI2QZAHZSqr4zU
	nH6IDqBkrDd02Zp+GfuG/1UzDq/rIag=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pHy6fbef;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789357204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5zisV7HoQ8XMweM1XOT4E07P1NlnKsteMfQzVmO4Js=;
	b=ylN0NUXObimRFEH6oFNS7jewf2YF4W6FOWjYJg05EEemek33fTQPfMAWj1RD0Cu8e+bdoo
	8XdAZCb56E8HSMqv9hjhf7rjE9u0hAyODV1cT+ArLXPcoEibVLvhilwBGKPCuD7yV2l+53
	wyn55lRPN+TNTBB19eD43xy27SfEIhs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DFC540A5C;
	Mon, 14 Sep 2026 03:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FF91F000FF;
	Mon, 14 Sep 2026 03:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789357202;
	bh=x5zisV7HoQ8XMweM1XOT4E07P1NlnKsteMfQzVmO4Js=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pHy6fbeflVTU8QtsqFS5eh8OvOR3ntwRr+lHZYMkoAT3ltm91/zKHpwN5XKZntEOS
	 ILIVvwKavB+/VLgc77oFP5R90/PbqE2ALcouMF/TdFK9XZ9ovr5QioyLZB1yLh6r2e
	 gdt1bOJXa+0zPlb1i7I7WNxSlmbqXRfHn0UsNCp4=
Date: Sun, 13 Sep 2026 20:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Minchan Kim
 <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Mark Rutland
 <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, Juergen Gross <jgross@suse.com>, Stefano
 Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, xen-devel@lists.xenproject.org, Eric
 Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk
 Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org, Oscar Salvador
 <osalvador@suse.de>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, Tal Zussman <tz2294@columbia.edu>,
 Gao Xiang <xiang@kernel.org>, Jan Kara <jack@suse.cz>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, Chunhai
 Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, linux-trace-kernel@vger.kernel.org, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 linux-nfs@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze
 <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
 ceph-devel@vger.kernel.org, Song Liu <song@kernel.org>, Yu Kuai
 <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, Xiao Ni
 <xiao@kernel.org>, linux-raid@vger.kernel.org, Richard Weinberger
 <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>,
 linux-mtd@lists.infradead.org, Baoquan He <baoquan.he@linux.dev>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Dave Young <ruirui.yang@linux.dev>, Shuah
 Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/16] Remove PG_private by using page/folio->private
 checks instead
Message-Id: <20260913203959.6b46b0b5a052aec818a7f267@linux-foundation.org>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 269CA80003
X-Stat-Signature: 1ysohpioraf5h5udows4fqxuorj85qen
X-HE-Tag: 1789357204-244537
X-HE-Meta: U2FsdGVkX19Vg7z6Mc4Oxmt+FDotKfU0DoEuYrC7pYtgJWRnonOpOQT/VRt/+DBXQHMDkHl1US63aStTfhDlq0nDzMa4j5gz2FeFeThzzL7VDUYaTXI3yDzbSshAst88hROXEagjDAt4e0SRbKXm7xadJhRnvb2SKsbXUVDknguZ6LeC3sx8RMDrJP9zWhx8dofnY/kwbCOQrMf6Fh8iYwZMYH8i7pG1EiBQmCxuG6FsQpDmrfLc/4BDqS3RbcZSgopMbyxzLuvrE3+JCzOQkU66Tu/DJGWBRnRoRIqhmBqidvWRjGrASTUo9F+7RiNzaQbC/qpy0xOvIOGbaOnzTjgP8gvFbd21oAw/Y2Zxw6qUuQyWdXZxYBfbUjIfsrKcg9NTVmFZhGiQWqa+ndITI+91kSK6qWlVa2if6fKqOVa2ZE2BcrBe9j4QiPUsZUs3FwXdwC/Anehq+tcKqI4fgDHYZtOM1BZ4JGnur37ZlLTouEtSBgD2Thf1rNTwazrh41BZcLvv7HUANtqVjikfe7g+g/ZlYF7QicF7iqR8Z+VLromIsknq/cCokk1LXj2rg8fjkPQxqADQCPAu0de2VmLy7GuLS/EOcK1cCKfdHMwGGxFaEYuMLfAtmyIFPeonkTec8RnkXYoZx9oWFBWyLxJGKu9DOfOy59EM2j9Pj1sWvRaXFO7s6dqZ46ItSzVrK+An/SFD1QNwJPMeUCf4AbLGyMItztOziQSJ/w7vkZ0mhqLhg5tbOw/rbJFBbOsqw1SB6ev3xVXWC6GTcyipT56Ng+GoehScf8uEqmRaModWNHYmaD0pev68/DqXuCdKqmtX0myPSv+waMOuC3TggeVXDguLyfFtudvR3pxmDffH8PSUmCAuzt6y7hdRpcLOmHQ30Wmq3KbyTCmjOVOi1mPXTX96fRsFuUvlEVnj/hL5ND5fbUoD+4fsKoFDkg0NMZ98hlUat2ZrfJTwwFY
 TKPM78EZ
 bXBs7mLXFyhj/EhgWo6ZJeWrEiBjvTKgWWxIj52tjjPh1IdmAyISkaCM8Gc16JF6DfW4DWdcD4rW7Sd38H0WGwxKf4gYMgis8N67DtR9ZKqiGJkjjkL0lQ21Tk4zCecSppk52M2YBLM5qcqyt+02eDL0uG+XBliiPayLhbfnt3TBFO8WdHV/lRCZj7UdQ6e8M9EV4c/rTwYZ+0be4V4nK4gKoFpkWQpS3ABEFR/KICfHfRdMWDdD8fxu7QkNKynv29RYeZ98m8+CMK+TIt1U3o2dHE45NYYnM+bZ0U0iu5mQ3X0zjLQHmKDBOhCiYCtugBYt6WDnReYcA3Y67HND6hOfCLgyX2e/mkgFQgwEunjJ4RyP+yMHbGWNnCiFaELu/cEXvl1fCAuojmjYFHj59SfyeMtBzlQYC+NkITrGcR348CHXdLT5iNDaJLmnqx2i9+5Hfp+SZlwe7RT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 13 Sep 2026 22:23:58 -0400 Zi Yan <ziy@nvidia.com> wrote:

> This patchset removes PG_private to make space for upcoming PG_folio for
> identifying pages from a folio (more details in Note below). Instead of
> checking PG_private, all code is changed to check page/folio->private !=
> NULL instead.
> 
> MM people are cc'd on all patches and subsystem people are cc'd on the
> cover letter and corresponding patches.
> 
> Patch 6 is picked up separately in f2fs tree, but since mm-new does not
> have it yet, it is sent for MM testing.

AI review claims to have found a pre-existing critical level deadlock
in f2fs:

	https://sashiko.dev/#/patchset/20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com

it also had a few things to say about this patchset and, as always,
hugetlb.c.


Thanks, The MM bits appear adequately reviewed and review of the non-MM
bits are, as usual:

  Great to have but I won't permit lack of other-than-MM review to
  block MM improvements.

So I'll queue it all up and shall push it into -next after a few days.

Acks from non-MM maintainers are appreciated.

If a non-MM patch appears in linux-next I'll autodrop the mm.git copy
of that patch.


