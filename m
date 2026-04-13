Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A249E93804
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 00:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED556B008A; Sun, 12 Apr 2026 20:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E176B0092; Sun, 12 Apr 2026 20:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEEB6B0093; Sun, 12 Apr 2026 20:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D65046B008A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 20:30:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 656B01B9035
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:30:30 +0000 (UTC)
X-FDA: 84651651420.26.FD4F92B
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id ADE648000B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:30:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vB6mqWWq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776040228; a=rsa-sha256;
	cv=none;
	b=I+zTS2/4ELcomZabDOOeDbY+kzv6uDf/iICF5r3ZBtiB5dcfRZo7Eq+BvnaTkucO+Dfzx8
	qrGNAvuTfddoztiD5DDoIzDvY+h63JriG9TeriWPdIFSW9j9EHkbJH1KQagKIbFQDXjfxm
	Nc1hgZJVz9OUsaob6YoJujCZFtwT7t8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vB6mqWWq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776040228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0Nb2J8Z0ObGnFlNMB2+gtaA0bURf+FmR1tfl+GxBQ7Q=;
	b=FuOvzGtGU92shGmjm1tdUnQjkGqLDnZiIxSd2JeyW/j+rNCuayfZVueVLAyh74tb4X2nED
	tkpbxqjQ/+3J+hGn+lIAeM5VtLSON0ztQ5b/Bo2EvNdmQOYuYr89Q8qrP00MF6KvOzOnn8
	Q/VpPIc1hvVZ+/Jmk70AIXGCzVaTxss=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso58855ad.0
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776040227; x=1776645027; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0Nb2J8Z0ObGnFlNMB2+gtaA0bURf+FmR1tfl+GxBQ7Q=;
        b=vB6mqWWqRCp9jiWNKsFfM0yoRT9iPdUCXelxlKJm8gE1/QRkzLWFcNzdAQhqfGazZw
         U0eE0t1eTyX1k9yt7VqD0YjUKqE579Dtl6SvIqsDjQPbNcjmHYiEoxEqa9mUXlAiIcNV
         vGPS2wq4hna/D0E5ZyLJAgrMIjOJJngGrOpfDuxqlQZ4dmDNYQVq88boU67alAycaaXl
         w2xNa6U/3NW+KXDm25HkJ2hK/oXOErwdN/AB+WFw55z3yQbnCd9iEmf2RGehybFVmZag
         P+PXQObBbien8RcLR0NbEzbe0CBNTrjrhMjahMDaJaCC4XI8c3j8s+jagN7DqS6HmYMV
         8i/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776040227; x=1776645027;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Nb2J8Z0ObGnFlNMB2+gtaA0bURf+FmR1tfl+GxBQ7Q=;
        b=sOhuXUFVdMbbAwUVhGA6TGnmYvbiS7uIR3PQHLGLET7r95OSgCbi8/NaWsIbSCcXAa
         zturh0fl/QXpxMIZlktNvsnq0hEu4CfWx7tHbbFGn9apYS3hzzIwp2huH56d8LWjY2wH
         QgE38nyg2WN6Slzrj66aOzURVKzOR6WXoCvK+4fgOJnCuscHuM0v66q71LvJrt7XCVii
         ZyDgWPa0e6iIjL4Q0L6qXY0jA+ODP7uLDIyhbHm94MzRCZLDhNfFRPdZ9tYFC1rikThJ
         CkHwuzd7+mhHUZirGK5/yyAPDMYIbKuMH/OwxodtpF7ipVOcEP8YTs/bHz54Ui7yRdCp
         qGtw==
X-Gm-Message-State: AOJu0YwDRs0ZGxUmumFXiR8tZ7ueFrQlKBR4+qnGaJvUsZ1Iu5WK/GHW
	EaqLLy6MzFPe3eSY6+0bMcdYWthc4Uqs+ykp2j1NOYJ+dl6Dp4RtVzR66dD8S2G0zQ==
X-Gm-Gg: AeBDieuKPHcZVCoGE2d5QjQJg361liiwGGM2+nJuwPMXIKfOP0x0uTp6v+wOgzunRKV
	/es4/agoPUgl28zqLJtq0ELvHpGL7C9rtKFX25QVquSdQ3Yh6eXV+RgR7y7G9+DLizL5o7eCcFO
	kloL9INwF+tvnzLpXwPzXf3iHxaqi8G4Q5f3Wz3LDEW1TiuiDNhfdssYlaIxxHWIpWuqjtOVbZV
	eIOcb3bFd/2A0LeiPrX0bFFkVZRr+5zToq69WrKg71xW2hSViuR/rA9a4VRUXY35HEItCpF/UrY
	/+PBL0idDWyCTIAIfx25qcvdgmiPw/nD5qJrvgk0eH/gKAW0YAY7MBRBatJ8IWG1Pjlucy333yF
	FCng3oiQbVqKzDhycEsDYNbktOfWh1j30VzLCKceOh3g1o7l3ibNCf3+gLoH7uQ2f16PTEcIqiP
	xpzfHpyUAbZ4Xw9wT41Y1Wmomu9sVVOPyeDsTWsQevYBSoGR4oT6Ytpd0vEVL8Y2SNch7A3BIWc
	EchDFt230kAEupaBKALLDF5PjJ+yqhYM+WoCyCKm0zIbTZpC+MqGEcJ6Kx1Yw==
X-Received: by 2002:a17:903:17cb:b0:2b0:7a9b:82f3 with SMTP id d9443c01a7336-2b2c79ea70dmr10505515ad.8.1776040222455;
        Sun, 12 Apr 2026 17:30:22 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:84d:f4e6:fcac:cce0] ([2a00:79e0:2eb0:8:84d:f4e6:fcac:cce0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e41355470sm10225839a91.17.2026.04.12.17.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 17:30:21 -0700 (PDT)
Date: Sun, 12 Apr 2026 17:30:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from April 9, 2026
Message-ID: <4b9961f6-8571-1d45-6a67-2c9896ac04ef@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: ADE648000B
X-Stat-Signature: cekxdpzy5c5883z5yf1kc58kjz69kn5d
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776040228-378351
X-HE-Meta: U2FsdGVkX1+OPPrXEDDJ4h3gyKYtBFaiGMHxjB4qb5UEmUEeXKv7NmMVCHuMqPEOmZ2rlokObETMs1WwXVDYaSdBLMGMdI6CiqZei3/HsRzU9mL+sGAdcaKxePT8mXDqjuOImMQDASZ7aQW5l74k7El3BbwT8HhIPXjMoM6kPlDJ8ygmHJsQVbfPG19P/CEiP7aUu86rpTRDOzPobBZiUwaDeC9DMTHTm2PkfmixcxNYLRbfWnhkuUH4nmnNbJIra1f5Z3chsBmy8307MXpCHpJKVUbFL6IbYlliM2HRrGMmUGqozN0HSAEL0JqlHHeaLByR462Bcki8F6EvamclXL1EKxmT1zKI6wPZ+T32rHGem5tnGBRlWx1iE8RGBRsLtP1GawNZsUL1P7xYEDGNUzHSMVRKOelqkAjq2P/AaFHDdkj0ELe8lcuzyrC/geas6hAuPxyetuS78SgkNtkrsXFrs0y4nVC+77L5OeAU0E5I4zhPTUMRTpMVXFbqdOshTONLBGnHWNjNPjcfsSf90/GjAdatqYL7uNPxiUYSrLwG4NlI7hixCotgg9dUa/br4tUe4ybR8ICm5e50X3c2yIF36Cc4c4JzGkiWf3apwZ0jDl7d8uWCAvuVXsMg6picwko4gTN7pf3jDZNRqCHIRYkNREhe91q2uoZvKZaR1McEsM5XMT3LFxCG9WyfGv8QD10PQxYscEr/srRImLBejUNQ+lQERyqBJkXh0guyxNJI1LBSLcm5YAgBj/TN1GiC3z+VAADaGfXWkbWMIi3Cuxvr4XLwvWxqxnarW8FXleXuLeGvnK92NBvaOz6/VowjQxIvji5zAir2w0RnjPfFV3DjkBvrLfd17ea9rbP2bXmTHyh3epNwGyYevIzUI2CHE+XmqA+a6LFDrD/14Pk0vlXpMjOSsj6dWwqLvPbzM+elGjDwVR4/Uw7vTCO6LiH+ToRPrp97k0HfvvN3pfZ
 ASbfSNh8
 /o4JY3vB/WJ+Bx4qa02SCJMsCrYteJ8zBcHbGB72oRGRz86eDneQazyxqhzlFvlx1Z1ddxKAUVR5ilN2kb83WMrkA5cgeyy1CI0ddj4E0jc31HEm1+E593IKoEOEgR/IumUJYCNe/70UsLtpaqUX7ApKVjXSQJ357kiw8k6sp4cBvfENcKSH7Xnqjoe/sSd6lp2LDPfppDCr8dBsxlt8VguJxTzyuJMPjFX4PlfJRtx7ShR5f2D93q66jHeSPNyKzqGrcR5HD2qiGW5slvsFj9iNINvNDZYPm0I1Tkv7GsJ1d6IxtnCYjt+99JQdBlNCzem0FmIUJhTSFZtYkL/lGsM0AIyL3QjDFgTBcjPg0bW946wOdXtY3jyrB52yg3fbs2FGgO5VSeziDuPVlqDkIsoBIHDEhgI3DZYp3CURY/Ipis8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, April 9.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Shivank updated offline that he is working on addressing the v4 review 
feedback for his patch series and that he posted a compaction benchmark 
result on the v4 thread showing DMA offload freeing ~6% more CPU cycles 
for competing workloads on a busy system.

----->o-----
Bharata updated on the status of v6 of his patch series.  He has addressed 
all of the review comments and is getting ready to post v7.  This series 
will drop the RFC tag.  It will also include another source of page 
hotness information: the IBS based memory profiler.  This is a new 
instance of IBS that is available on Zen6 and later.  Earlier revisions 
were using the standard IBS subsystem and there was an open question abou 
how this would be shared with the Linux perf subsystem.

He is also working on migration from non-process context: in this case 
there is no access to VMAs or VMA flags.  This poses a limitation for 
shared executable pages and prevents them from getting promoted/migrated.  
He was specifically looking at migrate_misplaced_folio_prepare() which has 
a folio; with traditional NUMA Balancing this has a VMA, in process 
context.  This will not be there in the asynchronous promotion path 
through kmigrated.  In process context, you would be able to check if 
VM_EXEC is set or if the folio is mapped shared.

The v7 of this series should be available within two weeks time.

----->o-----
Joshua updated on tier-aware memcg limits and suggested that v2 is going 
to look very different than v1.  This is a byproduct of being the first 
project that is bringing the concept of tiering to memcg, that has caused 
a lot of prerequisite work.  There is an awkward interaction with per-cpu 
stock and limit checking for top tier memory.  He started looking into how 
stock could work with different page counter metrics.

Wei suggested treating all the stock as top tier and this should be the 
default location for where the memory originates from.  Joshua tried to 
rework the stock mechanism which is per-memcg per cpu but this is now 
pushed to the page counter level where each page counter has its own 
stock.  There are other tangential benefits to doing it that way, 
including for non-tiered users.  We will have two different page counters: 
one for top tier and one for low tier; this is not user visible, however.  
Instead of passing a number of pages to charge, we'd either pass a folio 
or an indication if the node is top tier or not.  This also requires 
converting all the memcg stat items to lruvec stat items.

Joshua noted that there are configurations where kernel memory would come 
from lower tiers if set as ZONE_NORMAL.  In very stressed situations, he 
has observed socket memory getting demoted to the low tier.

The page counter addition would be sent out soon and then we can decide 
how to manage stock for top tier memory.

----->o-----
Yiannis updated that he was looking into the non-temporal stores for 
memory tiering.  He's prepared a follow-up from his previous patch series 
that was shared with this group that should be posted upstream by Monday.  
Preferably this would include performance numbers to share.

He is slightly concerned about the duplication of arch/x86 code that is 
called into for memory copy from the migrate_pages() path.  The next 
proposal may not be the cleanest implementation but he was still looking 
to solicit upstream feedback.

Bharata asked if the non-temporal store work is happening in parallel to 
Shivank's work for DMA offload.  Yiannis looked into the first version of 
Shivank's series but hasn't looked recently.  The goal was to get 
non-temporal store feedback even independent of other work happening.

Bharata noted that he was doing experiments for non-temporal writes in the 
page clearing path.  This shows promising throughput results with 
handwritten benchmarks but when running for upstream benchmarks the gain 
was not as significant.  Yiannis noted that his main motivation was for 
compression backends.  Wei noted that using non-temporal writes should 
reduce bandwidth consumption to the device.

----->o-----
Next meeting will be on Thursday, April 23 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - upcoming non-RFC v7 of Bharata's patch series, including new IBS
   hotness data separated from the general IBS subsystem
 - v4 of Shivank's series for enlightening migrate_pages() for hardware
   assists and how this work will be charged to userspace, including for
   memory compaction
 - v2 of tier-aware memcg limits, including new page counters and rework
   to pass folios into the charge path
 - Yiannis's patch series for non-temporal stores support
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast
 - later: testing of tier aware memcg limits with Bharata's changes once
   tier aware memcg limits is stable and further along

Please let me know if you'd like to propose additional topics for
discussion, thank you!

