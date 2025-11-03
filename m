Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FFFCCFA00
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 00:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF6C8E000E; Sun,  2 Nov 2025 19:41:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B73E8E0002; Sun,  2 Nov 2025 19:41:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5B18E000E; Sun,  2 Nov 2025 19:41:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64AD48E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 19:41:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1877F1609AC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 00:41:24 +0000 (UTC)
X-FDA: 84067442088.16.1812985
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5DE44120005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 00:41:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cqyFHFQZ;
	spf=pass (imf29.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762130482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RLFBPxkoMusJUNUvtbU4n3rAWn/Azodm+yIAOfI9eqE=;
	b=I009NETFJmbqm5bxKBCPehr0fHzyrb88yrexSIKhfXk7nLphE5cJYJVcc6cOpcWlvnRv/B
	B108tG4ACRgPqUvKKH0lMiRf5XguXlxkHYA5aH6o/V+Bpmluhz9L5xcnPWFlPmSVtlYrRo
	7VE0EouAQlU+cNfOAk00ia1Gl1qa6wo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cqyFHFQZ;
	spf=pass (imf29.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762130482; a=rsa-sha256;
	cv=none;
	b=MAO8ExuCRawitOrcYDz53txuvZLE33NVQ27EjUXSNvep0oiflFo0jpYO/WyFNpawXtrpN5
	IsYb8VcUUw861EH7iTXiK99x4iF/hR86givEz4bz78jdut16Ox0aIv4saqkkYIbSoj+ZW9
	rIvCmO61KU+DZn0g6+QaGvgs47KySFA=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-295c64cb951so40095ad.0
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 16:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762130481; x=1762735281; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RLFBPxkoMusJUNUvtbU4n3rAWn/Azodm+yIAOfI9eqE=;
        b=cqyFHFQZPNYr981jPpkUmKkEQ3l1sywKwQvTyiKxvU/ewhB3Z0lrjvZHTe/7oizp69
         TOfekzBgoKVM4WmximpKU3BMqVZ15MlCtbKyZAvb1XepHE7BWvOh/HcEpZSyQqGxZ6mU
         Iwm97shEETD/rH52kvGwpCE8jD7y1roeVSH2ymmqtSWKG7OL6xTvaqeDTyGQSUIJ53Gf
         98RM6zkxZM9/Q4gcAbr0kPqTLpwTo4U8Bds8yjTeCqFCkb07kaBpqPSxf7tc+w7xMERY
         GzyVvGXquYcn6lwLbNB78j8O3bihDvISghCAzJm5IJW3c1LyhImVY/pan6jrVY0DfdOD
         FoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762130481; x=1762735281;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RLFBPxkoMusJUNUvtbU4n3rAWn/Azodm+yIAOfI9eqE=;
        b=IEkdUeIZhJNb9bIoSDYwFjuH7q49V6TiNDGxod1tcy0DpVXFDAcRfyWAP8CGIlOngO
         nm+wsyJKe6a/guADMIwVa8YrO4PlPod30F3sPstKQdJ77/jTSyve6IUuk/+HHDQHzPXO
         wEREhyrrhq+UuCDfBH8OeXhqv6iotrppjeLix28tdbR76ph/sgD+zbpp7xsc4jA9ZhLS
         thyR2QNUEW9csJhifGBSgMsnTiqhJXSldUDfP6OqQMWycaLQPCDPb2O+0ZIgZjPeVUio
         Ypy+Wt/R4LBOXQ7JtO4yK9hmVkuc0isXtFQV9Z9mNun+b9jBaBc8DQlbA3XrMsTSYw9/
         Ow5A==
X-Gm-Message-State: AOJu0YwGLkkDKDgSXXGpKc/BCn5CZ2HuTNo74rffIgR3xJDLZyTrvY2/
	33ZPZl3WbxhPi0XxT16FsszuIpfORbKGcR4TYbL2N4UqgeryNRX/T4dGtX3vO/5XDA==
X-Gm-Gg: ASbGncu/qO4nNGlzy3kW9Hsu1NyjjBqnpJpwZhtG48zH9+p9qbh7ifKLsTqG+m7OJEo
	hrFfUhDKCoWYB6fH8PX3MKoGiKGa2tjvaONZrlAoMcfbAfC6J1aHU93xljemvPU5IBJoxsFhrww
	VIIfBWJMJoM0o5tn8MnDCJ+1Vc2DnVEj1r80MKchlnnli8LiKdx5Phg6cH4MVf/Va8w82rF9Zku
	fzmy8JHYuaLt+8mYYEKDmuemYXNjiAjfUpvjxc2HFy6Wd8wf04mRTe8tP5GPN51nSUafgmjDFZ3
	iOMUEtH9UP1WmTJUFeLKV0KvwkyizwBlpVvJHLMuh21aO3jxGqZPZj2Mqlr/6MGAcKKOsROLR+m
	fvBFdGjTIFhSzCA2USFijOi8/N3qKlmgq2gUcdtOM+YE9jwtavenbsdYtiHlNolwNMrsLEAOSHC
	mIDu7+GIZY+0NKfJpZ4XsqaJiuvUuZ+L/3v7JeXwLGsFcJIBtAIfOv/WPXxYNcAVAzWHpJycDia
	Pbbm/IZy/KaPacevWen/C0XEVRlipc=
X-Google-Smtp-Source: AGHT+IE7sxa0mbbal9xnbgfJcDXB9A/R++VW3auw7sxHtK4l/3sALpUJVk9K/FGddDChuEWZu2xZKw==
X-Received: by 2002:a17:902:e891:b0:290:dd42:eb5f with SMTP id d9443c01a7336-29554be37d6mr4770835ad.12.1762130480371;
        Sun, 02 Nov 2025 16:41:20 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:3344:2037:9578:933c] ([2a00:79e0:2eb0:8:3344:2037:9578:933c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b93bd961450sm8812437a12.20.2025.11.02.16.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 16:41:19 -0800 (PST)
Date: Sun, 2 Nov 2025 16:41:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from October 23, 2025
Message-ID: <d952a84f-332e-8f7a-4816-2c1cbd8f5b00@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5DE44120005
X-Stat-Signature: 7ie5zhamd4wp8jycocoq9mktjw9i389u
X-Rspam-User: 
X-HE-Tag: 1762130482-442769
X-HE-Meta: U2FsdGVkX19HgiRv0U3J3q/FK0MLOqrDXpvNz1Q0G22/HX722J0ON3xB81D3rZKCRsf8pgx5H/m3GLGF+DmCRxvtgVtZaGWA26wo4wQzBCFwsLRwuovEx4oOIYBcxs++v+tVVE3MpkLcbVGHHL80lZRxg/QN7xQyriFGi+Czm/nIFQ0nNl8JMO4iBSIcE6SrqhoRb8+XkuxLOTpP5G4yRj/i5ci4FtffZzrqq5IuWvjr8cnqmta7iP8DqmI8uV8l8LnP6dKb2M58Hpo6g04tKYQ6i5duB7USejr8Z6113Wr2wlK0G/OEUY80JQuQhvFrbmWyHrPu726jxjvNbc3ZlQPx9huUqXTCboW0HgjN2oSuIJytPK2lxsDk7voa+JkRHmkpDp+z/nRuuC/sQA/tZAfWe6BWfD/vWq0b0cpdQM00TszxdzremjyTrXw/4505koLbp2Ou4/lOaaSZ/lyZwGeUdAC4RgOw+vuF6C8TdAjq5qIe6wnOGGKy4C7bwTVeq/U81NZdBjTPg02f8F+cCyf5KFgymGtVZY7ECI7O+lUH6soGcAI58ZTLX5vga1grB6t3CPikpqePrzut4aI+KSRuzkiQuLRrBPVoxoTodFpoApQ6VV+hETK0tDFOXsNDqx6QqbU3PcpH2e3fQDC2XL4/L5SPgGbn9oXJxHxGUBWz8xiZYkXKXEqt8H5OutGB1rnp6jK+uwcZ2F3tR2ajPgmk+GvXwr80z1Z4ecRtohpfb+VGRCLwIvqaFl+Kzbg0Nv9TJlaFfl8O8o5s1IyDZCVfvun3R2arjTciT5N/RvOVSeRO7IYxGcX9h5GjJmyH4PEH00SQK5XTUskkVI9bWqUYSz0Dmyl2uSbCwFrPgKQ8T7Sa0kCIaYtllffebULVa6l8SdT865seQkhVKukhNCp3+CHEym6lXsB2kEhq+IKyHB9+hubYDyYhz+7oZulMOGBp9Dsisc0TTN0SU84
 DYYvc0CT
 cH8qo5xbzj94lpOF1NE3uRUqKHlkHnjw2OwZDtvTExjTzmLu9N+4v4Vn+mVz1Gbklzo7iMPXVuKEujIQ5rByOBPltPNQQ8zIUvR+AonoXOZ6dUfvNswWFVyfKiuv0pWwG3KT8RA4xPdbPDJtQwI8dO14AIdXA2gIK+mQWJBNy0P9IJbTKnwSeJ5hHIwoy4umNp2fJAP7x5kJNe3fVckCumw71e1Xt8QMahe2I5YRXoZC9/EY2kLmGilIyvMlmhM3RL0vhxUUeTp05pXofogamgFZg4Rgu9QGcrF3giIOV0G14PeR0P7a96uXUjwjWiuX+6897sEke7bnMQ3E4LQ7ECe8JrSurl84W4E9LS3ieAN0VMm5PSweQ17Qz3KFaSRlULlTcehCabk2Dhr/KZJ2TzUaFIE8D8gUhGRJjkuXSbQu5SsRWUvd0cZ3UGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, October 9.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Ravi Jonnalagadda presented dynamic interleaving slides, co-developed with 
Bijan Tabatabai, discussing the current approach of promoting all hot 
pages into DRAM tier and demoting all cold pages.  If the bandwidth 
utilization is high, it will saturate the top tier even though there is 
bandwidth available on the lower tier.  The preference was to demote cold 
pages when under-utilizing memory in the top tier and then interleave hot 
pages to maximize bandwidth utilization.  For Ravi's experimentation, this 
has been 3/4 of maximum write bandwidth for the top tier.  If this 
threshold is not reached, memory is demoted.

Ravi suggested adaptive interleaving of memory to optimize both bandwidth 
and capacity utilization.  He suggested an approach of a migrator in 
kernel space and a calibrator in userspace.  The calibrator would monitor 
system bandwidth utilization and, using different weights, determine the 
optimal weights for interleaving the hot pages for the highest bandwidth.  
If bandwidth saturation is not hit, only cold pages get demoted.  The 
migrator reads the target interleave ratio and rearrange the hot pages 
from the calibrator and demotes cold pages to the target node.  Currently 
this uses DAMOS policies, Migrate_hot and Migrate_cold.

It was shown how the optimal weights change over time for both the 
multiload and MERCI benchmarks.  For MERCI, a few results using this 
approach were obtained (lower is better):

- Local DRAM
  + Avg Baseline Total Time - 1457.97 ms
  + Memory Footprint
    o Node 0 - 20.3 GB
- Static Weighted Interleave
  + Avg Baseline Total Time - 1023.81 ms
  + Memory Footprint
    o Node 0 - 10.3 GB
    o Node 1 - 10 GB
- Adaptive interleaving
  + Avg Baseline Total Time - 1030.41 ms
  + Memory Footprint
    o Node 0 - 7 GB
    o Node 1 - 13 GB

Jonathan Cameron asked if we are using all of the bandwidth for this 
benchmark, then what is the use of the extra capacity in top tier?  Ravi 
said if there are two applications, one latency bound and other is 
bandwidth bound, then we can run both at optimal levels.

Ravi suggested hotness information need not be used exclusively for 
promotion and that there is an advantage seen in rearranging hot pages 
based on weights.  He also suggested a standard subsystem that can provide 
bandwidth information would be very useful (including sources such as IBS, 
PEBS, and PMU sources).  Wei Xu noted this should be resctrl and Jonathan 
agreed.

Ravi also noted a challenge where NUMA nodes may not be directly related 
to DRAM or CXL.  CXL nodes can be asymmetric with different bandwidth and 
capacity.  Similarly, we'd need to differentiate between direct attached 
and fabric attached bandwidth information. 

Asked about the methodology for the testing, Ravi noted that bandwidth 
monitoring is system wide but the migration and weights were application 
specific (virtual address space).

Wei noted a challenge that we cannot differentiate write bandwidth with 
CXL; with reads, this is possible but we cannot do it for writes today.  
System wide this would still be possible, however.  Jonathan noted with 
resctrl you can reserve some allocation of bandwidth for a given 
application and you can optimize within that.

Wei asked, given there will be significant overhead in migration, why the 
workloads here are not using hardware interleaving?  Ravi emphasized the 
need for adaptive tuning where it was necessary to find the right weights 
based on application signature; this does not restrict our setup to hard 
interleaving ratios.

Ravi's slides were attached to the shared drive.

----->o-----
Raghu noted as an update to his patch series that he finished the changes 
previously discussed but there were performnace issues so he continues to 
work on those.

----->o-----
Shivank noted that he prepared a presentation for kpromoted with migration 
offload to DMA that we can see in the next instance of the meeting.

----->o-----
Next meeting will be on Thursday, November 6 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

NOTE!!!  Daylight Savings Time has ended in the United States, so please
check your local time carefully:

Time zones

PST (UTC-8)		8:30am
MST (UTC-7)		9:30am
CST (UTC-6)		10:30am
EST (UTC-5)		11:30am
Rio de Janeiro (UTC-3)	1:30pm
London (UTC)		4:30pm
Berlin (UTC+1)		5:30pm
Moscow (UTC+3)		7:30pm
Dubai (UTC+4)		8:30pm
Mumbai (UTC+5:30)	10:00pm
Singapore (UTC+8)	12:30am Friday
Beijing (UTC+8)		12:30am Friday
Tokyo (UTC+9)		1:30am Friday
Sydney (UTC+11)		3:30am Friday
Auckland (UTC+13)	5:30am Friday

Topics for the next meeting:

 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast
 - similarly, discuss generalized subsystem for providing memory hotness
   information
 - determine minimal viable upstream opportunity to optimize for tiering
   that is extensible for future use cases and optimizations
 - Shivank presentation for kpromoted with migration offload to DMA
 - update on the latest kmigrated series from Bharata as discussed in the
   last meeting and combining all sources of memory hotness
   + discuss performance optimizations achieved by Shivank with migration
     offload
 - update on Raghu's series after addressing Jonathan's comments
 - update on non-temporal stores enlightenment for memory tiering
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace
 - discuss overall testing and benchmarking methodology for various
   approaches as we go along

Please let me know if you'd like to propose additional topics for
discussion, thank you!

