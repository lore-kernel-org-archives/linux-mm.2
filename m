Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04C4FF4933
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 03:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5423F6B0096; Sun, 29 Mar 2026 23:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FA76B0098; Sun, 29 Mar 2026 23:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430476B0099; Sun, 29 Mar 2026 23:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 327C26B0096
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 23:17:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6CE81605FC
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:17:16 +0000 (UTC)
X-FDA: 84601268472.03.EA9BA0A
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf20.hostedemail.com (Postfix) with ESMTP id 689191C0003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:17:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774840635; a=rsa-sha256;
	cv=none;
	b=aJP2qnpUtE5p83rbtRp4hSx++jP//85xWHm3xGQW/xXs7UPYnkjnvkJ1tR12qmQZFEhyGp
	S2j3aHDtshTmYMk++L2uODLAnjBXS2AbYl1cIg3K/ErJbrhBJRr9ko/rjjANqEuof575We
	Lm5euHhq6iBzP3jrm9iW+5k8LXGfzqQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774840635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feszXcbqqUN0+tYjNZDv7pi/0VAVmM2+e2UTvKOyAG0=;
	b=sd+VN4UO7IhhTCCcuZ07RJ+7rEYwoUIJIk/80+LhsLkiMQdMbT6GMKyXMjGXNlNhoCNksp
	dRrT/89l8T0VAnNBtrjgaKCnQRV0Q3jqK1ZQMHphCRMJANQ3bBwUGhALwRxNc/837NeWsq
	QF4aHVZQZ4CYnUfDgp5XpF3uxrP7ekA=
X-AuditID: a67dfc5b-c2dff70000001609-5e-69c9eb386bfb
From: Rakie Kim <rakie.kim@sk.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Keith Busch <kbusch@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Mon, 30 Mar 2026 12:17:01 +0900
Message-ID: <20260330031710.383-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <9d672ece-e67c-47ff-9978-db405c939f67@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02RfUhTYRTGebe7e6/L4W0a3jkqHJQpaZaKr1AhRPFCEEJBoPYx2sUNtynz
	OygVQ0priLpWm8VEc+WGq5X4kWGO+THRHI7EKdPEmZgYukpKDXOa4H8Pz/N7zjlwSDbfjoWR
	MmUuo1KK5SKci3GXAuujkxYdsljjcVhnMePQM+vEYef4FajVOAEccJfi0OQ2AzjfugbgH08/
	Abvn5jHYXD+Gw/7W5wSsto0B2FbyhYAjukEMujrrcDhl3uRAh+4VBlfVQjitToZ2SxsL1owa
	cKgvVQM4UdXHgiazFOp7p4hkAerQeQhksOahynIXge7ZlziooWuBhazND3Bk9VUTaODJOoY6
	ZpLQo7LvOFqZm8CQRl+MLO8+Y2jIYCfQD+uhlKBU7mkJI5flM6oTZ29ypYN1nVi2TlDo1WvY
	JcAdXAECSJqKpzW/yvBdrTMNERWAJHFKRPd9SPfbIdQRetoyu4VwSTa1zKEXyu9j/iCYktJV
	xk22X2NbkNbk2PZ5VBy9tFzL2pkZSbe8mdj2A6gzdOOsC/g1nwqkv73uBjv8ftrx1LvNsKnD
	dFmrnu1fRlN/Cdpb6v1/nIDueTmOVYEg3Z6Obk/HAFjNgC9T5ivEMnl8jLRIKSuMuZWlsIKt
	3zbd2UhrBz7nZRugSCAK5MXiDhmfI87PKVLYAE2yRSG8Sm2fjM+TiItuM6qsG6o8OZNjA0IS
	E4XyTq0WSPhUhjiXyWSYbEa1m7LIgLASkNDWoBsraH+rVdqN6jBfhOHh47hPpoQWb23qxcRr
	aVREwfDvr11yRVT6+bXJ3jzfvguTH68LM1TCkfehntClGSk6OJpytbhkTiVUvHBPRy/aUERl
	3c+GzPWjjXfrm45lPQuoda4MF00eWHWVG3rOXYoM7zOGKBKjBOE1I5INjwjLkYpPRrFVOeJ/
	MUMk/tcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRyHeXfOzjkuR8cpeLxQssjIyLSU3rTML9WLnyQEIQ0demrDqWPz
	GmQzxXKambmm2xTFrk6yTDOHl5o2NxETZ95iWqktE00rhDIxLwR++/E8D/8vfwoTvMY9KUlK
	GitPEUmFBA/nVRyIPQznrZIAu9EP6hsbCGifHiSgcSwKDpTrCKhRDwJoGc8loGG8AUBHyx8A
	f9t7SfjzyzwGu2YdOKyvHSFgb0s1CctMIwB2V1m5sFX5kYTvtH04tBn1BJxsWOdCq/YJDldK
	vOBUSTg0jTi4sKexlQPvDtUQUJdbAuBEqZkDDQ1iuPry8QZ6O0mG70FtWjuJaprSUVGBjUT5
	PQtcVNc+x0FN9YUEavpRRiJLxSqO2j6dQLfyFgm0PDuBo5UPCNV9XeIgte4aamx+j6P+mh4y
	0uUC72QiK5VksPIjYfE8cZ/eiMu0HlkzOjWmBOOuKuBEMXQQozX0kypAUQQtZMwdsZvYjd7P
	TDVOEyrAozB6icvMFdzEN4UrLWZKH61jmxvfiDQG6xbn08eYhaVyzvbNg8zT5xNb3Ik+xdyf
	toHNLaCdmW/PusB278JYK2e2Gozey+S16LBS4KzdobQ7VA3g1AM3SUpGskgiDfZXJImzUyRZ
	/gmpyU1g468Pr/698wr8sp0zAZoCQmd+AGGVCLiiDEV2sgkwFCZ04xdpzBIBP1GUfYWVp8bJ
	06WswgS8KFzozo+IZuMF9GVRGpvEsjJW/t9yKCdPJYg8PnY9p85S6Th/T62qOvPCt3lXiKa3
	0Gf4TWdov13WHlURVzec6Fc9ZMvu9pCGFefEpPt63g7h3aha3+dukAdfiolWcS3LyR0o0vy5
	8Ki3IcRnfc0rSPa9NmBRH+rReci4mHlWOeq1uy18NOLigwHlWprWW9mnjyxOOG0PzM8U4gqx
	KNAPkytE/wBtP38J0wIAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 689191C0003
X-Stat-Signature: q3jhptq35rjcu49f6cuehktc8t5hazbu
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774840634-638500
X-HE-Meta: U2FsdGVkX19q+4krUTplvdRc+QfHj2qLJ4Rxbi0XsiKVxT0l5cD2YksKpauZpecqU+TOXUPK4DGDK3XxZSo5cCPs84x1uiqmkHL1Z/azwqBu1ZNeGjandVeuRGHyNyBI4ENOuIG9td0tH51cas22FtTSYJD2uYrUU1nUeW1dijoCiBJQIfDLfSEN0/uyuPndBYOSyf61U/mGkOpAubA7rU2ZLCOXKw1A1cDvom0cvbVj0cb3EFK3IvPV5dUHOjnAKYCPl2BYhWvlSdGlAp8R5UyGpgwzGqYpgMj2/35nSTmw6N5QtRKQQh3R21dZXHuAlpWfg3dyFCAXvQfh96O1zOA/bYHYst4+LZk9ObqtjQhqWYNFJBI0FjEMR5tMPIGz7snfV3nbLUuLwlBqyfFE1Qy+57yagAW9RnipmdeKUqW/4PrvLJI9SpKkssl3HkYzT5hXP0NFFfpqVxid7fUd7aMDy/3LNNheH4tHHjS/wbxoNrNJqYbJeKmzUvPmYXIrPN81pMCiJDqeLPq9Io/7vCB2+xoOL42b2iPv2jR3sFH1ZKqAcoRMSnGrB7pcTPXu+/C6+w0gSzfXYQSLzUfNEuh6r8nZ7Gq3vEXNWRfmu3vYPm04wODH/O8wQH1tw7KAUyX4hHzFR4Dw4cYinTPGpZHahFL8XMYUUDvnUBF8KwxQyKSaU+qiE7S07hX3nOOS9cgvS3P6x6rvLIQW+ZyybxNNbS30koC57tWB52G90o++awsEUSxNQfleKlspiLHPb5RT2BVF6PEFpWbVrhsmJWgY/RtpByRaDhcfxNKiXp4S48+i9Kc0yBb1YY3e56q97jbHpMY2HQGgh4EckW7VUkV19wKBVQuDOYz7hh7D96y8NxyhRYmKJ7weeK/N50NEpF5oeUS2wRIK/903cGLqmbnpvYwEXPANH6oh3Kfq84NbmrvcAt3Z2myet/xPULzRd4HA4sTUyeHI9fXDBD9
 DnEohYEY
 KwxY6QNQytC0d/KmOAg7ewPMPmwVmTtyL3LbM9ZQsYA2vfwIFQFt9LxRE9H/K/PFdNstXJttiKqAJdziIDe2H7X+yJTs1mYEqueODyq5av/uy0ppIOS8ODeGdAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 15:19:49 -0700 Dave Jiang <dave.jiang@intel.com> wrote:
> 
> 
> On 3/26/26 2:41 PM, Dave Jiang wrote:
> > 
> > 
> > On 3/26/26 1:54 AM, Rakie Kim wrote:
> >> On Wed, 25 Mar 2026 12:33:50 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> >>> On Tue, 24 Mar 2026 14:35:45 +0900
> >>> Rakie Kim <rakie.kim@sk.com> wrote:
> >>>
> >>>> On Fri, 20 Mar 2026 16:56:05 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> > 
> > <--snip-->
> > 
> >  
> >> Hello Jonathan,
> >>
> >> Thank you for the deep insight into the HMAT parser code. As you
> >> mentioned, considering the current state where node 1 is still
> >> registered as the initiator in sysfs despite the flag being 0, it
> >> seems highly likely that the kernel parser logic is not handling
> >> this specific situation gracefully.
> >>
> >>>
> >>>> Because both HMAT and sysfs are exposing abnormal values, it was
> >>>> impossible for me to determine the true socket connections for CXL
> >>>> using this data.
> >>>>
> >>>>>>
> >>>>>> Even though the distance map shows node2 is physically closer to
> >>>>>> Socket 0 and node3 to Socket 1, the HMAT incorrectly defines the
> >>>>>> routing path strictly through Socket 1. Because the HMAT alone made it
> >>>>>> difficult to determine the exact physical socket connections on these
> >>>>>> systems, I ended up using the current CXL driver-based approach.  
> >>>>>
> >>>>> Are the HMAT latencies and bandwidths all there?  Or are some missing
> >>>>> and you have to use SLIT (which generally is garbage for historical
> >>>>> reasons of tuning SLIT to particular OS behaviour).
> >>>>>   
> >>>>
> >>>> The HMAT latencies and bandwidths are present, but the values seem
> >>>> broken. Here is the latency table:
> >>>>
> >>>> Init->Target | node0 | node1 | node2 | node3
> >>>> node0        | 0x38B | 0x89F | 0x9C4 | 0x3AFC
> >>>> node1        | 0x89F | 0x38B | 0x3AFC| 0x4268
> >>>
> >>> Yeah. That would do it...  Looks like that final value is garbage.
> > 
> > Hi Rakie,
> > So I talked to the Intel BIOS folks and apparently for devices that are not hot-plugged (with memory ranges provided in SRAT), those HMAT values are the value for end to end and not just CPU to Gen Port. That's why they look so much bigger. So there are couple things we'll have to consider:
> > 1. Make sure that Intel, AMD, and ARM HMATs are all created the same way and this is the agreed on way to do this. Hopefully someone from AMD and ARM vendors can comment. We all should get on the same page for the CXL kernel code to work properly.
> > 
> > 2. Add code in the CXL driver to detect whether the range is in SRAT and then skip the end to end perf calculation if that is the case. 
> 
> After further talking to Jonathan, I don't think at least this part is an issue. The devices that are attached at boot do not have Generic Ports in the SRAT.
> 

Hello Dave,

Understood. I'm glad that the discussion with Jonathan helped clarify
the situation regarding the Generic Ports in the SRAT. Thank you for
the quick update on this.

Thanks again for looking into this so thoroughly and keeping me in the loop.

Rakie Kim


