Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D94CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE6F6B0088; Tue, 12 May 2026 01:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FAF6B008A; Tue, 12 May 2026 01:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5206B008C; Tue, 12 May 2026 01:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2FB6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:56:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0DAC1A0376
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:56:32 +0000 (UTC)
X-FDA: 84757708224.05.1809076
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9628D1C0004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:56:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LJpHcm4L;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778565391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YXOZpV+X6bJwsnuORDvZC9B66IjJQEmIupm8ujq2KQ=;
	b=MHQhP09HQhiAGQmHfkob+3tfbNxazucwigJzYgiDen9n5CBBN0TLtE2cSxHhBDSZb3jwRB
	7J1h43TwVzR+sYhR5vesofgGYRt/5Zh4l7caqxdvCjmmx3CPaBaWf8iOmFzhegQoVDrt4x
	cD9zohZvK82NqGDpKB31Qv9faioZHkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778565391; a=rsa-sha256;
	cv=none;
	b=C0QRauUZ+H/WF1mcTI18MNrFhloLczQTN4QUCCwChJAIMPd/BV/CM7it79cdNMwJXC5EQX
	Jnebb2V1zBxVxLOzqen9cZqShjCyVyXiIfEm4if+bUrUp9PYzHgb3Zhiwmtf/vlSolj+W7
	61i/AvNIFiINL+ebKg0oibOs2idTecc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LJpHcm4L;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Mon, 11 May 2026 22:56:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778565387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8YXOZpV+X6bJwsnuORDvZC9B66IjJQEmIupm8ujq2KQ=;
	b=LJpHcm4L2hbzEfiwwhJj4jG2YfAwAnItFIGA350acFzhwzotIRNo5M69ikm8qbEZaVUiJf
	9YPJXh6PvuWiwEL5Bq3fZ1hda31hMKkd15ZucKFm0VEmSDCKe1OTegOt60wI951cf5Xr6/
	TT6qs3jO/UqxuTIHo0c4n+gtUhQR7/8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 00/15] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-ID: <agK-rkIIZlwBiMsv@linux.dev>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
 <agH7qYcyFgRzkQDB@linux.dev>
 <CAMgjq7BzQAPp8u_3-9e3ueXmRCoW=2sydok0hFM=MYL7VC1YYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7BzQAPp8u_3-9e3ueXmRCoW=2sydok0hFM=MYL7VC1YYg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9628D1C0004
X-Stat-Signature: i9dfotmoxrs8egdpnd9gwx6jcmzoyesg
X-Rspam-User: 
X-HE-Tag: 1778565390-429035
X-HE-Meta: U2FsdGVkX1/C+FeEyAFz0q9jNHC5Qjt45ph18lrWIlwPHrWjQ3ChdQblJ+HP2UfrQ5maPsBF0HSgce4RFoKFexTiBz7hUOIKiPqBN2dzJCSfH8pmIdElGEygtyc3VeUTWvigr9ePrBFkS3wqSZMV5FHjmkQmOJ5t1ZToZ4eJ2D4VgO0XZGK+7alMdd3YIW6kVAMaZLLNYDSGrH2EO24pdoz6aq2kQ/ZpHJp1ZCuXpMlLtvdUmgp4+z48QM/ll9A7Cutq6o2Mh2NE+i6VUty+N0XCXEHd20Jnf3rFnz1AcZ0kgbsbGbUP//TQ+lP008XGzNDXzWmZusHvjwEaSU8HZCg4b2YyloXwmC9K16qId20QxpKr69tTikL1R4xSz0OoewJGP0wnHEn6SCqob8eeAzmtJ9v7v+5wac9Tdfxorf60EyG/dLXRS3z19VUQcuPhzhK29R2lyIajoqxekrZ36TWhZEZ+OrxjmgcdWkpaJ1XYAjwoGCnRNjEFZyhGnASIW+YB0F3iweMC78CKIUw/wZpScRQaR7UcWLYVU6Mt+YbzdMUfpHTasMHhufypZHqOu4xh8nviUZAWMgoLvbBgmuP64XIoRDe6R8bZ4p5Qg42cTkVy1O0lta1b8VY/X1fzJ0cXfGiAiUicN/f57190S9aGRzv/Ym+d5YgBap98TCFELM4KwMIrTeDeA9ubMpSLhU7ByM4+xVZNRCdvaT9lQjH4+EbqR+2FiHeQ8v6Clnvx42f7/MqPLfy3xCv8gBYpFRPilmKPnltmepO3QpYwpunXbVd08YqcRvjmv9vXgyG5EaKpJiylNQy9i9q/plsALzGCjR4yK07tdKBJyO/jUKIkSaXT26oIx+8jAmsO2/1L7f/NC34cR7uykHoB3dFU1zPPGTLLZU5ltCm8aSxiEoeHZVHEwNMgt7UYoPRgX4PSBFuv5wpO5Soor4aQvkbPu1inK5AKGtXY9X8OzS8
 I1DSh5uZ
 ul+AJ3FWqNBZujoiMj9uktyvCb3otLI+mg6YEAMefJ10EvfA1O7MGVasuoxW3MA+5/C+7aggRVPVcwjOKg/feuvF6qOm3DX2Hl8Jr7qWtU51R9MqntDb3ADaSqro+G/y8o5x4oGtXvvmP7czere701e2UIgv2m207Tu/e38A+uN179QwbUligZ/KRQ85rTw+K2FEksqggQsqbIXps1hIHE+wCKDmqKC6YXp8uXxykRIcm3gEdaVADTKY6Y02vqf8yXnuYxWe+NGqN/7x8cMQl23ireNpKGXPZTfw6yV9Xtlu4PK9ViWmxVLrnekPA9p0lKuMNQ9G7o97+m54b4wZCuJNkSdY5yOqTaGALdKtv9rPdjouqqcCJj6mC1O9s2poFHgwVUhehW7w3SB7wNWFKRJXk4aWts+F9p5fNzXK5z8iV3ns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 01:08:49PM +0800, Kairui Song wrote:
> On Tue, May 12, 2026 at 2:51 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> >
> > Hi Kairui,
> 
> Hello,
> 
> >
> > On Tue, Apr 28, 2026 at 02:06:51AM +0800, Kairui Song via B4 Relay wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
> > > and a 128G memory machine using NVME as storage.
> >
> > Please include traditional LRU results for all of the following experiments as
> > well (where it makes sense).
> 
> Sure, I've spawn a few test instances, was busy travelling last week.
> That specific test machine is occupied so it might take a while.
> 
> A systematic test run takes roughly one or two days to complete for
> one kernel version or config, e.g. the JS test takes at least 2 hours
> to finish. Comparing versions/setups takes more time.
> 

No worries, we have couple of weeks before the next merge window, so no urgency.
I will go through the series in depth, hopefully there will not be a need for
next version and in that case, please just resend the cover letter with the
information you provided below and don't worry about the length of the cover
letter.

> >
> > >
> > > MongoDB
> > > =======
> > > Running YCSB workloadb [2] (recordcount:20000000 operationcount:6000000,
> > > threads:32), which does 95% read and 5% update to generate mixed read
> > > and dirty writeback. MongoDB is set up in a 10G cgroup using Docker, and
> > > the WiredTiger cache size is set to 4.5G, using NVME as storage.
> >
> > Can you add a sentence here on why this workload is chosen and is important for
> > evaluation?
> 
> Because that's exactly the one we observed with regression since it
> involves mixed writeback, and it's a pratical case.
> 

Sure, add this sentence in the cover letter.

> >
> > >
> > > Not using SWAP.
> >
> > Any specific reason to not have swap in this test?
> 
> Because we are testing the writeback here, not related to SWAP, so
> just to avoid noise and irrelevant parts.
> 
> A longer history involving SWAP is explained here:
> https://lore.kernel.org/linux-mm/20230920190244.16839-1-ryncsn@gmail.com/
> 
> And a longer discussion on that:
> https://lore.kernel.org/linux-mm/CAMgjq7BRaRgYLf2+8=+=nWtzkrHFKmudZPRm41PR6W+A+L=AKA@mail.gmail.com/
> 
> Both are not easy to reproduce, though. YCSB with MongoDB seems close
> enough and I believe we are heading in the right track.
> 
> In an internal workload, we observed that patched MGLRU is about 20%
> faster than classical LRU with MongoDB. Upstream MGLRU is still
> slightly behind classical LRU at this point, and will hopefully be
> patched soon, which is the RFC I posted:
> https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencent.com/
> 

Same here but don't need to go in such details.

> >
> > >
> > > Before:
> > > Throughput(ops/sec): 62485.02962831822
> > > AverageLatency(us): 500.9746963330107
> > > pgpgin 159347462
> > > pgpgout 5413332
> > > workingset_refault_anon 0
> > > workingset_refault_file 34522071
> > >
> > > After:
> > > Throughput(ops/sec): 79760.71784646061 (+27.6%, higher is better)
> > > AverageLatency(us): 391.25169970043726 (-21.9%, lower is better)
> > > pgpgin 111093923                       (-30.3%, lower is better)
> > > pgpgout 5437456
> > > workingset_refault_anon 0
> > > workingset_refault_file 19566366       (-43.3%, lower is better)
> > >
> > > We can see a significant performance improvement after this series.
> > > The test is done on NVME and the performance gap would be even larger
> > > for slow devices, such as HDD or network storage. We observed over
> > > 100% gain for some workloads with slow IO.
> > >
> > > Chrome & Node.js [3]
> > > ====================
> > > Using Yu Zhao's test script [3], testing on a x86_64 NUMA machine with 2
> > > nodes and 128G memory, using 256G ZRAM as swap and spawn 32 memcg 64
> > > workers:
> > >
> > > Before:
> > > Total requests:            79915
> > > Per-worker 95% CI (mean):  [1233.9, 1263.5]
> > > Per-worker stdev:          59.2
> > > Jain's fairness:           0.997795 (1.0 = perfectly fair)
> > > Latency:
> > > Bucket     Count      Pct    Cumul
> > > [0,1)s     26859   33.61%   33.61%
> > > [1,2)s      7818    9.78%   43.39%
> > > [2,4)s      5532    6.92%   50.31%
> > > [4,8)s     39706   49.69%  100.00%
> > >
> > > After:
> > > Total requests:            81382
> > > Per-worker 95% CI (mean):  [1241.9, 1301.3]
> > > Per-worker stdev:          118.8
> > > Jain's fairness:           0.991480 (1.0 = perfectly fair)
> > > Latency:
> > > Bucket     Count      Pct    Cumul
> > > [0,1)s     26696   32.80%   32.80%
> > > [1,2)s      8745   10.75%   43.55%
> > > [2,4)s      6865    8.44%   51.98%
> > > [4,8)s     39076   48.02%  100.00%
> > >
> > > Reclaim is still fair and effective, total requests number seems
> > > slightly better.
> >
> > Please add a reference to Jain's fairness and a sentence on why we should care
> > about it.
> 
> So first, Here is the previous test setup for that:
> https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/
> 
> The basical idea is simple: if all memcgs are under similar pressure,
> they should be reclaimed equally, which seems fair.

I think this is too much information. Just summarize this in couple of sentences
in the cover letter. You can refer to your email in the cover letter for more
details.

[...]

> > >
> > > MySQL:
> > > ======
> > >
> > > Testing with innodb_buffer_pool_size=26106127360, in a 2G memcg, using
> > > ZRAM as swap and test command:
> > >
> > > sysbench /usr/share/sysbench/oltp_read_only.lua --mysql-db=sb \
> > >   --tables=48 --table-size=2000000 --threads=48 --time=600 run
> > >
> > > Before:            17303.41 tps
> > > After this series: 17291.50 tps
> > >
> > > Seems only noise level changes, no regression.
> > >
> >
> > Please add a sentence on why this specific params.
> >
> > > FIO:
> > > ====
> > > Testing with the following command, where /mnt/ramdisk is a
> > > 64G EXT4 ramdisk, each test file is 3G, in a 10G memcg,
> > > 6 test run each:
> > >
> > > fio --directory=/mnt/ramdisk --filename_format='test.$jobnum.img' \
> > >   --name=cached --numjobs=16 --size=3072M --buffered=1 --ioengine=mmap \
> > >   --rw=randread --norandommap --time_based \
> > >   --ramp_time=1m --runtime=5m --group_reporting
> > >
> > > Before:            8968.76 MB/s
> > > After this series: 8995.63 MB/s
> > >
> > > Also seem only noise level changes and no regression or slightly better.
> >
> > Same here.
> 
> I tested the page cache performance with buffered read. There is
> another test involving classical LRU, where MGLRU seems to
> significantly outperform classical LRU. The case was provided by the
> CachyOS community, I didn't include it here because the cover letter
> is already getting tediously long.
> 
> https://lore.kernel.org/all/acgNCzRDVmSbXrOE@KASONG-MC4/
> 
> MGLRU seems to have significantly lower jitter and better performance with that.
> 
> BTW I also disabled OOMD or any related daemon to avoid noise during
> that test. I repeated the test several times, and recorded one test
> run as well since it's meant for a desktop test and I was discussing
> with distro communities at that time. MGLRU TTL can completely avoid
> jitter, however, it's not enabled during the test to prevent
> confusion.
> 
> Classical LRU:
> https://www.youtube.com/watch?v=pujboGNcBNI
> 
> MGLRU:
> https://www.youtube.com/watch?v=ffnFUeaBQ_0

The point is not which is better but documenting the performance difference
between them for the given workload.

At the high level, I am just asking for a given benchmark/workload, let's add a
sentence why we think this specific workload is important to measure and
evaluate reclaim mechanism.

