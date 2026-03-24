Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DB0FE9A772
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53C36B00A0; Tue, 24 Mar 2026 07:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2AEE6B00A2; Tue, 24 Mar 2026 07:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941976B00A3; Tue, 24 Mar 2026 07:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 813C86B00A0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:34:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52567141AD1
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:34:52 +0000 (UTC)
X-FDA: 84580749624.14.67173CD
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7A2218000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:34:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Xhpigj36;
	spf=pass (imf06.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774352089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iP+Zy4ALbwUoKW8JSdZqcrKJG5FAhobuMDa49D8quM=;
	b=vLinZJr4z0XTvhe4kVDHSytl0fyY6Pw4aygSPukdFivXa7LhhqLiHLZyxwfnHKx672xONL
	OSO2cUyuSy4McRoO5m6+qK1us7Eax9n8UrrC0Q0L+uZY8DYfczdwsNQiMtRcvmz0wUCQXX
	WA9NNX2EBJyC3Ka3Gku2aIavWRWR/FQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Xhpigj36;
	spf=pass (imf06.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774352089; a=rsa-sha256;
	cv=none;
	b=v48zzuiaOvOBHl83A9+Skwv9gcMGhhl71/i5ZWx4WTYkepSxFeeon3BI8sjzdCNJZPJXZm
	hm43feDLmUMwmabxxsdaiwRiGjN5XDbT3eVsn27z3rdDa20WYLUapotxo2MBVKv2NNBVKV
	9+3bTlfmhSpU34cxfKnjJJOZpsk/Nzo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1774352081; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+iP+Zy4ALbwUoKW8JSdZqcrKJG5FAhobuMDa49D8quM=;
 b=Xhpigj36SYKJNEOQqYBX5W8FtJrqsrWpLuMwcPSCACyTyCwMr5kjT7XUbWoGE0BlsUHO/7
 Q9FaS6aEaDRSqci3Al4f+Ofbk3cd4ISPidm4bC6GFM3Sjh5rP+map3Ib+1cS5awOCPFwly
 snNZdviblysI6EeJ/0sopPUsGyUIoA66TNFWg+6gBsahJVUgVgahoqCfQVtUYHfnTpvk76
 hRJiGQgwB9BQkEnF+MgPMTHvNu3DCjiauiTRsJy9Jc21mRxfjisXF2bjcvi6foDV8SmMjy
 OaRRKSn/Ryo2JCehnivp2pu/SgKXFyKpxumNKCI0+br1dxFu4MQlRNYqWGh89g==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
References: <cover.1774342371.git.zhengqi.arch@bytedance.com> <20260324113206.26539-1-qi.zheng@linux.dev>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	"Usama Arif" <usama.arif@linux.dev>
Mime-Version: 1.0
In-Reply-To: <20260324113206.26539-1-qi.zheng@linux.dev>
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
User-Agent: Mozilla Thunderbird
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH] fix: mm: memcontrol: convert objcg to be per-memcg per-node type
Date: Tue, 24 Mar 2026 19:34:12 +0800
To: "Qi Zheng" <qi.zheng@linux.dev>, <hannes@cmpxchg.org>, 
	<hughd@google.com>, <mhocko@suse.com>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <muchun.song@linux.dev>, <david@kernel.org>, 
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>, <harry.yoo@oracle.com>, 
	<yosry.ahmed@linux.dev>, <imran.f.khan@oracle.com>, 
	<kamalesh.babulal@oracle.com>, <axelrasmussen@google.com>, 
	<yuanchu@google.com>, <weixugc@google.com>, <chenridong@huaweicloud.com>, 
	<mkoutny@suse.com>, <akpm@linux-foundation.org>, 
	<hamzamahfooz@linux.microsoft.com>, <apais@linux.microsoft.com>, 
	<lance.yang@linux.dev>, <bhe@redhat.com>, <usamaarif642@gmail.com>
Message-Id: <66a3c4a0-c3b2-4a54-904b-bf3e30bcf7da@bytedance.com>
X-Lms-Return-Path: <lba+269c276cf+681df3+kvack.org+zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Stat-Signature: qwxwhay38bgbp1jh15bzz4gzfhzkix9m
X-Rspamd-Queue-Id: A7A2218000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1774352088-403039
X-HE-Meta: U2FsdGVkX1+RGDl4MtNB2ulKDVn32M8oVQeVJqB5FLaX2Hf3Pg8a30xAfZuwvsSJHbE/G4yc1OUVIybMP1aiAw8BnEB7COYrAzq65C9kNdinTGX35SN+1KIxSwtN5Ntsw3yw0tmEjEK8TBMIEQt9XAv4EZGj007SL0RabP9s+pwmwy+yFqyg4pnFx0FCkIQRtoVqtJpFG4OVoxaKS6tGkrbZKzELuNgONlFbwEBIrl4gHt9Jgivhz64W43JDhcIUEVN6KatFWLAvtW8e74oPgWokx2kbx8l5c2OVNQyHH0jzmSEXyAMKuCcvp9uYqCOQG8EUOw+Q3DRxvsuw8PI/fPv3iH69jENyI+9Ty5k8CN2AMadVz6Z6pluMvpmvVpUN8rBFVYeO3fpNR/52lgDUqFxquaL4cwTTdV8P8zSqyL+Mo4ML8bVuvBUd3eHpQCHVYCvq3nSHBmGHJg5sN7laJD/Sb3hadI0g+0OzdXI+jXo4GmYN3gy9OmBZswyCqmDLEWcuC0GXwB9XUdgaiwuiuo0QCRLxFU6QR/VbaMwbVRZG7uWoU9FeEp8O4uNWus6QxL0uO/fcPIB1z0HM+j/ahBzBzdYr5W9g9RqGvt4WMTjisfFLqRJNXPz+/3LTID2noandBv9UCzALtwjQsnak/aBLzya/8rj2rR2XpmxRhhupLieNF6QZmNBPoQLRjetqK0DdV1fVvM9+Ss/UfAc1tnK05mpcMbV5iOlk497BpTahbWDCnPnqi4UrzosBxJynxjauIgxVtZMujB1dHPW+S0D/7W/YVW0V2afgLmfboGgVHN4w3YpU0/xgfXvkWMUHQ3pMlFV8lByDvRXE8SI9d2JW1XFvtOvHHwDjY1TcE+pE2leM+Be/iDgaGedqp7ZLmhve+GYhFElmnwDe+oijcAQqXO94MLSHq8MGSFA1F55EO2c/aqzpyl7s01oCYtShvjwhLrXkIUHNLNkwgFF
 TzM4eAZ2
 EyyJJUo3D8JTYBwqMDg9oGc6eLJVcQDLw94ITN9PCoS8NnDH6lVl+LoO1k0cQmKWhn3MbaxiS+o55nN7T6M2wrhNpfMyah/4F/Wf43d/ECT+1efoCgV9aNttTWCO9A/UU24JgWQHQVLz+nyqrrTW7AZGGHKAgRS1YfXJ4jVSjol3clRw2QmLStBou4aF6Nkie9s9QbZ4zWef64fc4WWXZj0FUHGb4aWmhkTrZajklTVKmaMfnJkKUkAQ53v148oYOWLO1Z0FG4Yp7vSbzigrabKgHXz9hr0KTjvwLuKMlz7rUmdKtXtFfkOx3NwfX/6nPqrSG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oops, Please ignore this patch.

