Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37716C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 23:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127626B00D5; Sat, 12 Sep 2026 19:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0D56B00D6; Sat, 12 Sep 2026 19:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3476B00D7; Sat, 12 Sep 2026 19:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7C956B00D5
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:15:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6BF11205C4
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 23:15:57 +0000 (UTC)
X-FDA: 85206669954.11.C4A55E7
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2C818A0004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 23:15:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jE9pWcy2;
	spf=pass (imf15.hostedemail.com: domain of rientjes@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789254956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hrHGia3UYotbURjNGtmEF5DSWsvDK02hj0DhIk0RRgc=;
	b=alIB4bzINvRVUmoS2mogHjBxYtzJFPH0yqaNIw2+brB0jfWOj8QfMzuKuP6AR/SFVWiqlT
	75L8El520IHWVU2aBM8D/Uq/FsS2D/HwRSGn6gtVi9cZsVajJXD73I+I+fUtf124XUHWf7
	uyIOJdzA6q5gcY3tjUYVucdxU7QrT2A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789254956;
	b=1V2mdVT20OE0yF6uw6IIGCsfj1C1qAErpIiriPOzXoGDcdPC/W6x91hyYBudRo8srNjnu5
	okqdpnw7fkpuaj1hw+smryfRGznrTiX3gdPCRFCZV1ORXQ3JNfakpgBVXAYRlEINOu1DZO
	TPq8sY4vfypbGx7c2I2XrbMnGROJcMc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jE9pWcy2;
	spf=pass (imf15.hostedemail.com: domain of rientjes@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d6ff3aca06so44425ad.0
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789254955; x=1789859755; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hrHGia3UYotbURjNGtmEF5DSWsvDK02hj0DhIk0RRgc=;
        b=jE9pWcy2jajQJ8hZ5Wg34Lj/yNHn1RmfUbMuMoPn4RB1Irg4ezNAtuJ5ITPm2JsXRn
         wpd5qFUU+EV6M8N1LHHLG/R5Qul0ZD6HJKwfHiPN6ZGu31xJVVuYoYBwI4NsB9CBZ11a
         CMaPFb6lNR90XQ4ayVDnSYSBehix+nt51LxMzrhv+EbidPCuNHiWaaaKCj4OKsiVfMIA
         B0F000Qsvhj6vDOI5E7D7UNgd60lDD62Du27B6NmRulS6UZO+6FctlNgIa+jUE4Or7Vx
         YTEQw+Hc/94lfVnFHgb15gDgC493k2zAygKLQlRkXAt3scyPsbY6X6hJkd55no7OhDCO
         ZT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789254955; x=1789859755;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hrHGia3UYotbURjNGtmEF5DSWsvDK02hj0DhIk0RRgc=;
        b=Fk7v7jkcgnf4ztuL6ZMkFHlmbeL+gVu9LVft21bu/h5YpZqlkJhptPdWaICqyHhRlc
         O58RJI55GIDn0bDCQ5dwQx+XzSNx+y6Pv65qlStkV5DXBd47jYZLlnzOH/u7nGxIUytP
         eiAn5zVs3p6fTr3cIMXcAohSBpELpAE8Q9Df1CMh3o2xLY5EeMS8JF62ALUF4+WqWXVx
         Df/Z6fMw3t/YGBZYXLVNuqpFsjf1zR1SNY7qyMj+paSInB/Dc+/ibVKJ68B8T2RxKKX3
         qlxhPoub5EYrllPSwoVsyUM1nzY6f+AMD3efDTzmNKeAnCZ5FkeZ1CJANOOQT+DbEeks
         Xcvw==
X-Gm-Message-State: AFuF++nGIRQGuRC6Hgn84un9ymR5xko2mce2MFinQM/7jyERQdKIEm3q
	94jBwbbMOlOprqt0Kld9F3wv11HFs4SpvD3MpJn71nhy7qU7vbmp1eqigEVWvefWUw==
X-Gm-Gg: AYBFou2JwNC18BnSD9TLvNfTzXHHAWYN1Sh2NXKHYAhq5CqRXiKgzSoYvQ9sCBjSIZv
	Ik8G229RZjbWqCe6ISV13T2EM31/1wse48chEw2b5Gun8VZJHZ5umIW3PCoPtlkU5TiS0z4NmSz
	4kFWivPVAXHtmR06cW28dJoRbB/vfksV2FXgQBCDrak+M++Cl0t79hTRKtTAhLVbI1NZkMiJ7AJ
	fuvDZeYY8L6dAGEMEN4v1E3gsFMpRCgYb7As7bxqKYOZnSU7QhAcsfeT4njO/OrMQD1yQ9M0wp+
	wzNizzDPg71O5ySrx1wAtBEcpDrykwav9yb52UtJbDbhTtl/8QUG48uQnfdNY3TK6DzXIqoTLiP
	VUnDwv2buDCfr+/agefk0cMlEMMWXZ12VXaZXAj9NptByAQzw9XzVty9aJJrlU5A5ThHn3SozIz
	f9j7bQl2Shjx1mX3KcVB6w6iaNpysHC3sGgPR3gTYn2Y+/9FB0p/2l/oLLmfID7UM04dQZJJ153
	Ho4gIXvfaiK8c61RRRKoa1+TI625WsfgH4eyIkYPIW/KnEtLv6QmkFQc/3U7rGxUatsQjF+5KK+
	Yr6w3xs+uxCKyY2f9NZq3xXjXQyF4L7uz8XjCHDPQAWQ2C8N8OjHkp2szi5hmBxcqERKClhorYD
	5MkMC
X-Received: by 2002:a17:903:2c06:b0:2d7:2a35:d14 with SMTP id d9443c01a7336-2dd5e3bb3a4mr207615ad.11.1789254954278;
        Sat, 12 Sep 2026 16:15:54 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:3d64:ac9:6488:d633] ([2a00:79e0:2eb4:9:3d64:ac9:6488:d633])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d95424fccsm12203815a91.10.2026.09.12.16.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 16:15:53 -0700 (PDT)
Date: Sat, 12 Sep 2026 16:15:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <jic23@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from September 10, 2026
Message-ID: <f5a9467b-1cdd-732c-a70b-625be9fc8dd5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: k81q5eq3jawaegjmjgqest4imcyu8uje
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C818A0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789254956-901635
X-HE-Meta: U2FsdGVkX192Vx43Cm2rLtRv7zT7fAtIHWlE3VYdwVIkoaGOEDVmg4K6yJEiKFGO22UcPwmP5cqGgSZ8Q3HpJVMyMCwVno6QIkYt3Y+7dh4hhKwEk72x+CviejeU6otgUS0tDVsMIM0tLsg8mp6KfEsrjYmvIxNW+3YbQ8eU1shaqhHV4rSCnOa2IBQDiA/Sahg/Bwdfd3ZqLxjz+Sti5JpxBk9KoCNWdQ1IRN78J9nVe9qdKDZVPI4wUgmBZIL/m6Su1A4JyElNqt/dSm02PVmQgICNxXQmvUeN9PIyzFjSiyjFzb57PGxJZErX7qJDJHu2h7X2OgqOf4Y7olEI/2eCW9193PGh9bsDZ7NUkB5EpKT8vuuwEMMy7pzxEekOkwSlchSvljAjivSru132hLS/HevA+o9e5N7pWB+kwfef0aId3avBZS1b7LYWdYaI0pBuUBPbIQF4fRv2uq2ADhztfq0BBFNqr+DwBa2hi+39BY1tX6o4qnzaazeggQ1ifMBWA5Wf5QxPphew8nwDEpx/+j02QkRyQ2TfRBRlEqju2swHgi8ipXr4tOsjBx7mDuusgtXoC552vPefksQ0d6QLgGFuFe3BlukxAA2RqP7Zdhv00KRC1kbfK1aPijH3/kT+wK/MKsu71Evg3b4KkJJ8OELnbNmnGAquIMg3/MQKVVYL1/h5RBwPm2LF5ZgWoh1TbOUAfCp4vZPlItWqpB49gIx2vrxC5JL2rWsyNIEGrTc+kHK2JilnMVxt+QQRKHAtcYT/0sIi5MiZ5SeBPLP9XywXFVTt6/5iVe0MrkrM48iIVRln3gtO/2t9B1ocekitEfIPmce6a5phhWXH52mpSC4y2ntmiPKl0wTvvGGIRo3KgNEFOMq0Je90QiI01wT4WdwCaI92LD5Q3i5N3SCh223Hkk5c2Ujup0+A3xA8LhAsoMVEgkzRAVQdxy5X9X6Hh/Xj2ojKVUu3PKh
 dfI0jKD1
 i9oi9hwN+XFynntKltcr17z9g5QzYiHtym3C0daJd4vrwMnOVpyzUbc6XLv00oCEuXnQuNrISBj04gh2v8fjeRIDobumV2c+vdRj7jQ6xYH1exYHNb9sgfqIfpIuTIaIbQ3r5lZbx0UlLXVWWJd/Z21etyDloqDMMiTVBJ6hI+7KBEW2/Xm9gZNBry4bkTWwYgtrVnghOvrMP802u6A6dLne24xyhdmkjs51Q2O4QmD9QkeIZucxPG2h/Z8gp3L9sErZ/IAwxaIvtXvh1N6eLBSsxPE1/hsxoSwC+ksz+JeJSGVnK5DkVcjZQ+0p4YSJxUBbtzQKBRpQ/9yjffa5oG/1viVB1POUoKbSHXkbZ6Z1TYIQZeQmPzsxXsjXndY4i8Q4RzEAwB8DqGBh0yJGDfH/D4UIccGpD6+IB5IFRiUdKyEe/mB5PE+/HU2dILtvZJH03evjnDrIWwzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, September 10.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Gregory shared his progress on end-to-end compressed RAM and performance 
numbers obtained through qemu experimentation.  He will also be talking 
about this topic at LPC coming up next month.

The theme focused on a first principles approach for a memory architecture 
that includes devices that necessarily lie about their capacities.  For 
example, devices can tell Linux that they have 2GB of memory when they 
actually only have 1GB of memory because compression is enabled.  Some 
problems with this include releasing capacity back to the devices and 
including poisoning of memory completely (not just best effort 
prevention).

There are two ways to access this memory: files and user mappings.  Files 
go through the kernel direct map whereas user mappings go through the user 
page tables.  If you made a poor assumption about the compression ratio 
that you have, then accessible pages don't actually have a real backing.  
When you put file mapped memory on compressed RAM, you lose control over 
who can access it.

Writing memory causes physical memory to be loaded into a cache that gets 
invalidated and stored in a different area of memory in compressed form.  
Compression ratios can change out from under you, thus we're expecting 
Linux to operate on faith that we won't end up poisoning memory -- there 
is not great precident for subsystem components in Linux that operate 
based entirely on faith.  This is particularly concerning when dealing 
with memory.

How much capacity do we actually expose?  Zram and zswap have had this 
debate; in this case, we make the decision at boot.  With software 
compression, you intercept every access through page tables; with 
hardware, you don't have this and the result can be catastrophic.  When 
writing to a file, for example, the page allocator can continually hand 
out pages but this can result in poison of that memory.

Accounting is another problem: zram and zswap can charge the compressed 
memory back to the cgroup; this is important for oom killing.  We 
completely lose this accounting with compressed RAM since it's just a 
memcpy().  In the extreme, consider task A storing 1GB of incompressible 
memory that has a real usage of 1GB whereas task B storing 2GB of zero 
pages has a real usage of 0KB.  In this case, the latter would actually be 
selected for oom kill.

For memory poisoning of memory, this is detected at read.  The poison 
occurs on write, but it is detected on read.  In the future, interrupts 
may provide insight into this.

If you have the ability to cut off future writes and allocations, it is 
possible to avoid poison entirely; Gregory stated that we shouldn't try to 
migrate our way out of this problem.  How we do this for file backed 
memory and user mapped memory is entirely different.

----->o-----
If the entire device is saturated and the compression ratio drops over 
time, there may be an interrupt to inform us that we may need to start 
reclaiming.  If we have uncontended writes, we need to reclaim faster than 
the rate of writes; this is likely to be a losing proposition.  There's 
also the opposite problem where the device is largely empty but a user is 
writing /dev/random to the device -- the page allocator will continue 
giving out pages but they won't eventually be backed by anything.

Gregory has implemented a number of solutions for these problems and has 
approached it from first principles for isolation.  He suggests we need 
normal pages that are mappable and can be reclaimed; demotion should "just 
work" like zram or zswap does.  There should be no ZONE_DEVICE requirement 
to support this.  Additionally, Gregory suggested the memory should be 
mappable to read-only, we should support dynamic sizing (ballooning), and 
allocation control.  The kernel has to be able to control who can access 
the memory especially for writes.

For page cache, cleancache would have been preferable but is no longer 
available in the kernel.

Gregory provided a link to the github where this is implemented[1] using 
btrfs.

----->o-----
Gregory tested this work by setting up a system with lots of qemu 
instances on hardware with actual CXL memory.  He sought to prove two 
things: that his work does not impose an additional overhead on the kernel 
and that the page cache implementation is safe.  He primarily used NVMe 
based swap-in and zswap swap-in as the comparisons.  His implementation 
was much faster than both, closer to actual memory speeds.  He suggested 
that we could not compare this to standard DRAM that supports uncontended 
writes.

Gregory noted that for read-heavy workloads there was little to no 
performance implications and the additional capacity resulted in better 
throughput.  Performance dropped with a lot of writing that required 
promotions, which is intuitive.

Frank van der Linden noted that he'd been running experiments with similar 
devices and that he had largely come to the same conclusions, so he was 
very supportive of this work.  He asked about promotion on write when DRAM 
was under pressure.  Gregory suggested that we just need to reclaim in 
this case -- it's an allocation just like anything else, promotion is not 
special here.

Wei Xu noted that some users have the ability to kill jobs to free memory 
capacity, which may not be possible for all users.  Gregory noted that 
bandwidth on these devices are ~45GB/s, we might get 20-30GB/s if it's all 
writes.  If we have 1TB of compressed RAM, it's difficult to reason about 
being able to keep up with the pace of writes happening to the device and 
be able to make strong guarantees that we will not start poisoning memory.

----->o-----
Next meeting will be on Thursday, September 24 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - update on combined patch series for supporting non-temporal stores in
   migrate_pages() with memory error handling (series from Yiannis +
   Huan)
 - v9 of pghot and the PTE A bit based source (kscand) for inclusion in
   the upstream kernel
 - v6 of Shivank's series for enlightening migrate_pages() for hardware
   assists and his rmap batch series and LPC discussion
 - Teja's update on SDXI page migration based on AMD patches and hardware
   issues being encountered that do not result in page migration
 - update on tier-aware memcg limits status and production testing based
   on the latest major overhaul
 - first class support for virtualization based memory tier support, how
   to leverge memory tiers in the guest
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1]
https://github.com/gourryinverse/linux/commits/scratch/gourry/cramtest/cram_72/

