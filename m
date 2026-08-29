Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A99C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 21:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370FC6B0088; Sat, 29 Aug 2026 17:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321A56B008A; Sat, 29 Aug 2026 17:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F566B008C; Sat, 29 Aug 2026 17:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC9DA6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:48:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4369E1201D8
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:48:35 +0000 (UTC)
X-FDA: 85155646590.28.AD65145
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9252140003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:48:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uCDCCpJU;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788040113;
	b=l5MBFbetXDcxfnRW/HmTizNrz+MrpYNnoNWTD6F+hzBvoR8By3Y3zLEU7uw9cZOuqfgR8C
	kkkBzTG8dnebRhgKAlj4/UxXbJ+QGpRX2J8lZxLANwZhv+M2VmYna8hqT7r/2oBEfaKuN+
	kxDdu6A3X/X7/wvwmaCNhDoefWcI/cM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uCDCCpJU;
	spf=pass (imf07.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788040113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NIfPECdOC7+2I+bBH3nhv6b9o46APH+A8u/7CKah76U=;
	b=VYlQiObsEobwiDKHBuySLxHFHD/VTu4LljsahyaldOWsXAlzImTkh1N6VGgrKS4Sl69amu
	XPDqr+FlRplt4Jf7cQgRMuJxB/2bwf7dK4cIbj//KB7GcfkjRGVMgMD4C6R07wDzoBruQV
	vSn9Jpb+eWMrY6hl5ybOdeT3s4WJNzE=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d8facae850so17735ad.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788040112; x=1788644912; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NIfPECdOC7+2I+bBH3nhv6b9o46APH+A8u/7CKah76U=;
        b=uCDCCpJUUyLrQz7Qh3E9nYOS2Km6pJ/W4f9AiiRLvCNRkWW/HhYnjeSxTHG5TvIKAu
         r7oOub2ES2ODm14j1akAhzLRdVGjR0oX7f6ThMK5KtN9KQ5aHt3CPw+g/NxfHh8x/xch
         bGpO3foe9YXlxH9XXzf0z1bp4+W5aH7V/EzlekrPJsbFHDrw6rBkqu7ovgIZSnq6E2FD
         TSPASslKHjKZi8adgvDfHaS94ofPVH35SM0i8V6dG8f9moxDi0PXN+w+fsHfZjO5qO6o
         bdaM9DfR656DkMtsURRHkqyGD0y7I1Rax/fcvcSBI9ILxpd90v8VNZk/w2ewYkj3/k81
         +B2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788040112; x=1788644912;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NIfPECdOC7+2I+bBH3nhv6b9o46APH+A8u/7CKah76U=;
        b=Qj36LE4wmF63FiegoYPOroTk0DC4TN2ppZ856cncw5kSuq9xsizUV08p0rsx8gn77/
         dnnkqSLWfpkzHa8Lpd5gNNLkDNMXJIyOOde2FYjA9gu4Te+TGOjEE5KOoqJAFj5gO922
         HQhO98ybV5wEJLJm6Dz1BSZk7kDfdl8enJ1JGBC9D2/Ljq/giv7JvHRqW8psA29ywG3+
         AyUIxeWEgBqW/98U7f+UdWc3h/oTJoogmpHQcT7GMsDQYOas+96vAjhYJ8N9G1RcnUaT
         gHmndwAPM8mVOlMiRiDxIRf6mEY1eW8yA5ThVTNdixGi+xZhHp6+0LvypW41w+OMQKh1
         PvIw==
X-Gm-Message-State: AFuF++koxHgjkclnhcw4mWgiRog9dYvTdB+ephORdPXtrl9JLyg0/zzm
	MONDdhbr9NAVBRtzsT0MvhbgVyWMuyP3gqvM0Cjvj+QNMqt3UBBOxfIDQUy0NiXOXQ==
X-Gm-Gg: AYBFou2PvUJRZ5BiL/6SOgl9uszQKg5MBCX+8xaDdHFAkNJonEkd8OckYTKeuAJG46G
	cDR9QlZCSFTfpfykDBZ0Rrb924zvKipsXYQu8blmWLMC0+oKfJjVcQQKHyRfPXfTAr2hRXvJwg+
	84Eva7jDZ8433L1rQkcVe0BiSzWIVUZZHxKq50RggusO6ezizfNTnPLgWEo1o8DxGC2vwVLrD/e
	UMhbvoUMJUp3w9s1uW1azxOY2oJLSleZsnrhnd6LJNANc4Nlm1fnecv4DsdGAVBazR0+QeKFgZK
	goIIq1EpDWVB0EAcCM9+BETsh+xpTSlr+gAJ2oeNlOirNZQMBtH0MCu4vl1M6b3avm6d1d4N7Cn
	d5+rZ6+nFT90nZXSGDBqH3JkBnxmTRX95St5tpASmz+rK1Vwe/u+6MTP5YPL6M+Fn28eEs9DGrV
	peHAPMrXbiWWw9dxlY3lA8PjAH9S0KUNtUUtqY0sxmPwDHZpdYuU1nbC5NUhZbsFCQypuol9e1g
	ViOeJz+ybtmmXhQj59Ba5Czfm0wjCHHcYtkhlN4UaHVG+BiRRb1fief/NFHa0TA+vBJTKqGYWxd
	W/A89YLhu7mBmwg=
X-Received: by 2002:a17:902:f642:b0:2d5:db38:800f with SMTP id d9443c01a7336-2d8df554483mr5357385ad.14.1788040111466;
        Sat, 29 Aug 2026 14:48:31 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:201d:c4fa:f5f8:451f] ([2a00:79e0:2eb4:9:201d:c4fa:f5f8:451f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398a661a0ddsm1530877a91.3.2026.08.29.14.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 14:48:30 -0700 (PDT)
Date: Sat, 29 Aug 2026 14:48:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <jic23@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from August 27, 2026
Message-ID: <ba64ee1d-5fda-d428-9955-a89b28d1de8f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: s4p54erxcynikk11g791tu94emmyq9qm
X-Rspamd-Queue-Id: 9252140003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788040113-719419
X-HE-Meta: U2FsdGVkX193jaM71xnewa+X3utHtjCiw/b8vUPOoJ+1M7E5o8MdXuNCaAV1vZxu85xJsyoWNaRmA2kHS615vtB8HmIvrwev2vbshQu8/tYNLL8YWM3JBxwbmxdmZ3CMm98jXKqSX4Qp5OsnTyW+xIkacr+PNx5RdxytsjGYhxpp0rcayxrvLDxzh4hEMdSlFlbHwSJ4/kgHzGNH2QGgCSgIoPf4PH+Vlk5zgFbeH7qkeadYON34qM68/HKuYDwpGS/dYCnyaChwDEabR3OEksd5EmzaGFEb9tOihbYDemyULypkccJdGjniK2EvulUke6LnEYpDDLwTruZcguGaVcd32/UOhXq9EpECT46ucJ27W97EZT12Q/uqUwWQG57shRiOMuogBdmhbMM0ZC5XpOudKwuAIi897WApRFf53SMyNs5eaevZfhdqseAyPZ/M6NMat12OFk3bBoW81pHGBQ+hvWlKNB31vyN5eMPbhZ6UeUmrgVLW12Fhb2AaGiUs4EEBqipH0m1OU1WceKl785+ZUWHGAn83sWDwAFLl8YiVlVB/XIF+3tSTU6S6p31cRnfQr5xummPAsx3lS5cYlo5Yn4SHQ2aGWM+6XsEKQYZNmU6nSRXTsjiPwqiCMSF3TY35/4EEkkXhlOGPwcNh1DGixm1MNzMLtVP+CkgIBEbx20sbigYwgBaNsE955f8ujop42xa+hdQYGmS12sxVaKgpsmmsXwVH6mrOIzM+01VEr08Wavz/5urTFy9fx0n1TJwOvtFgofgQFogndyQtQA0PAad+0eHnO4L3uKntzvLfvnaWQUNPFZPVktnQBRkwGRmM0kd52Ya6IHF2VljxzBYG0+xKeBfK3hlNLXHnGA+ig96LC021S8J7wFYE6/iCy79okxIRuJymAFdlyuLomqNRKkgVVw0BdiXM6gl5YMMs+BlOTtGiV2kzjv2p6DnxmRIJ2o10dHd17o/8+GR
 OM4MRCgz
 APbN6Eqlmww1660lSNe720SILlTH45rWRBmtapApC/nK9vUtfOXp9tt7uctx737YSiRzdwaUf3WtX07RZ3RxylTvai+CVC6NCYIpTC5FLUvRUkEuVNRepZUK7q9toeMnBJop4cf4Mz73EyubTBi2RmlPFYVB0lsichzTgsMZBHEhwSs62+6urAMbw4XxE1qs8HXK4SqmX/e4oHv/+F7gDP6Z+9IGAM7JUJOWYM9jovrMxFqdEx/QlWJUw3r4ggd+3VU7GOMWXUSnMrAzwsHcwqUOpmYXwAYhwkLr7nSpFtpV+E3Dj/yVGAWdZg/i8MjYqq8nweMjUzIAXfvEhcsUkeUYJifHhe5VPns1N7be9XXUYm+hT7xzrNEs1WplBbMHSL3SZPNF1wJRpVBTxR8gOjyqqK6484YfThIGCm1RpE8BRGGjN+7OA8MYkNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, August 27.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
While Yiannis is on leave, I noted that Huan from Google would pursue 
sending the non-temporal stores patches upstream that include his 
extensions for handling of memory errors.  They will sync together before 
the upstream posting.

----->o-----
Bharata updated that he is getting ready for pghot v9.  There were a lot 
of corner cases addressed in preparation for this.  He also tried to 
compare DAMON with pghot and was able to get some realistic DAMON 
configuration working after some iterations.  He posted some initial 
comparison numbers and more will follow in the pghot v9 posting.

He's also planning on sepraating out the pghot-hwhints (IBS Memory 
Profiler source) into a separate patch series.

Hrushikesh is working on reviving the PTE A bit based source (kscand) that 
Raghu worked on earlier; the plan is to integrate it into pghot, get 
benchmark results, and then post it.

Bharata continued to request additional patch review from the group and 
any insight into relevant benchmarks would be very useful.

----->o-----
Shivank noted that there were no new updates at this point for his 
migrate_pages() series because work was being done on the rmap series.  He 
is waiting for additional feedback upstream and preparing for a discussion 
at LPC.  He is also focused on migrate_pages() refactoring to make this 
cleaner, including for pending batching optimizations.

Teja discussed hardware errors that were being encountered in his testing 
of SDXI, he was not yet able to get pages to be migrated.  He is iterating 
on this with AMD and will continue conversations next week to try to make 
forward progress.

----->o-----
Wei Xu suggested we add an additional topic for this meeting series: 
compression enlightenment for memory tiered architectures.  He was 
advocating for a unified approach upstream for handling of second tier 
compression.  Specifically, he was looking at software support for 
efficiency such as handling of free memory -- the goal is to represent 
this with no memory footprint in the second compressed tier.  This would 
likely require hardware signals to indicate.  Secondly, he noted that the 
physical capacity of memory on the second tier may be insufficient if the 
compression ratio is not good; we want to ensure that we do not run out of 
memory in these cases perhaps with watermark handling.

He also noted that handling MCEs for compression support does not have 
first-class support in the upstream kernel that we may want to improve.  
Gregory noted that we may end up killing critical processes and that it 
may be unrecoverable.  Gregory suggested that we cannot allow writes to go 
to the device uncontended although there would be performance implications 
of this.  Gregory has an end-to-end configuration for this already in 
progress including separating the second tier into compressed and 
uncompressed memory to provide the necessary reliability while still 
having memory efficiency.  The most obvious example was the lack of 
control over file writes.  We will invite others from Google to attend the 
next instance of this meeting for more discussion.

Gregory noted that he has a talk for LPC scheduled for compressed RAM that 
will cover his end-to-end design with performance numbers using qemu.  We 
decided to dedicate the instance of this meeting in two weeks to this 
topic.

----->o-----
Gregory updated on behalf of Joshua for the tier-aware memcg limits work.  
He noted that the LRU inversion issue was due to the system as a whole 
being pressured.  They've concluded that there is no good solution -- when 
we are going to swap, wherever you can get the memory is probably the best 
we can do.  Aggressive demotion typically just ends up resulting in much 
worse performance.  For tier-aware memcg limits itself, there is a major 
versioning change happening for this.  When testing previous iterations, 
there were issues when the amount of hot memory was larger than the top 
tier.  They have a solid solution that provides fairness using memory.max, 
high, low, and min settings.  The proportions that you get are based on 
the physical topology of memory tiers on the system itself (3:1 top tier 
to CXL provides 3:1 ratios for each memcg).

The latest revision is going through production testing.  Notably, there 
are no new tunables to configure.  This is enabled through a kernel boot 
parameter, mostly for production testing.  It also helps to avoid adding 
new userspace APIs while still iterating through solutions.  Later, this 
could be enabled at runtime.  Since we're in production testing right now, 
it's possible that this will move beyond RFC in the near term.

----->o-----
Next meeting will be on Thursday, September 10 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - Gregory's end-to-end compressed RAM design and performance numbers
   obtained with qemu experimentation
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

