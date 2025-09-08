Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69734CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 03:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AC0A8E0002; Sun,  7 Sep 2025 23:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95D748E0001; Sun,  7 Sep 2025 23:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873668E0002; Sun,  7 Sep 2025 23:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 771318E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 23:04:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1970F160939
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:04:06 +0000 (UTC)
X-FDA: 83864588892.26.97AD91F
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf01.hostedemail.com (Postfix) with ESMTP id C6AF240007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:04:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=h2lDSaLq;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757300644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ch8Enmtj/KH0mQ+evioqR/00NLP1dhKFZnhe/KioV9E=;
	b=eOCEMhxKtKoXFDdhn7YXppt0X4MM1bT+yAwQpYAsIkCK1HpbJ76RUoUrpEJEeFKyr3xLnG
	wQ4v+a0CwH8pLTAnTny9+RJNJqyds17x76sDlASyVrbrcX/nEJzW2p/Xgd4b0hDASw76sV
	A7Xf9iNN7P7nu1EBaZL5CQe4Ji6y7lE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=h2lDSaLq;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757300644; a=rsa-sha256;
	cv=none;
	b=4dRhpfiPmjD/CGK+zkkPpuK2/K/TFhPsi8d9ci5khJZLdIaWzFWKdTskvCd7+30RVwXZlb
	eJlFhSWnvZkWUoww63I+ZMXbC/s1fl4231yUbHlVgvO/qJRLwdDRi6zbG7R1Mn+65e72bV
	bGCMbr+Wx613ZeAQZ0brzfINRg8xoYc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757300639; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ch8Enmtj/KH0mQ+evioqR/00NLP1dhKFZnhe/KioV9E=;
	b=h2lDSaLqt3GGx4AldojmsSXQsBXp9d8K5VGO8lE1fpLCVLzlv6qJkVYeZPLE10HHNU2JSbIKcu9z+E5/xI0DjSSTo3Q3FtazUQSZC+bZP3axlMZ3lsrOudOzDv6BSCAWwlvKQFhlvX0GW6QJx8CebgIGFBo82ao0H05o1i1I604=
Received: from 30.74.144.132(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnQXU.e_1757300637 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Sep 2025 11:03:58 +0800
Message-ID: <91aa3a4f-5c20-4591-ae2f-bcd57c2533c2@linux.alibaba.com>
Date: Mon, 8 Sep 2025 11:03:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/15] mm, swap: rename and move some swap cluster
 definition and helpers
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-7-ryncsn@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250905191357.78298-7-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fszcnkkugjh1who6dx7gtahqo8eypr7b
X-Rspam-User: 
X-Rspamd-Queue-Id: C6AF240007
X-Rspamd-Server: rspam01
X-HE-Tag: 1757300642-177181
X-HE-Meta: U2FsdGVkX1/wtbPZCmzwKccHgYcUudtRlLDjuf+TEI6WzJlTyPF3gGh3YzeLVPEjjN0XVjiqqAhR6Us0Q/Ua5CsRrSQHCVdQYP+pO123M3DfZDHtCDZhGPEtITICjGtQbqQgOVterVKnQvClC20spLYIDd2Nz+dfrKmmAblr/7WZ6ROdyipUrvBbjO4i+cxDPdZnGfU1WJeEv7KjHF4QcQ134kgWOJl8A+MPyIIU1lwBmBj4gmRNOSwAT+j9hKD5VBeSJLBAc/8BVxJnewsUcdwLSpBm0KsoQFndkv68O+RsJDED/iVRJBPVrKFG/Oljng7SwTT5moMBtVQOhSu2Tc9ajijA47gIy4uDUnBZAMUZb/oobQ7hQWb4+JPL5yLN+Uf5D24jEk52M+EQrvGzpdkiYcT+4WbZ0/wZFy2p1E7y7mH0q2SFnmKVyR5pKaG0LWW74EIdftp3ycali5gJsN8BWC/FGsw/zGT2hItUHAjfGoxQWi6Sf+ohnQxsqORNUjPbiV69v+grnvCBmpByKmmI1xy8Scx2oMeT+T7FrlnnRiaEwH8qyHEAdra3j4q66l/ZpYSCRwJuYLIdSMqYuJXsGei5GzMxLefWgdB4YBVS9KHn2dCDCGRVLQA4S4XpYLH9S4EZ7Id4fOwm4NyRHdwpIpkyCVF5BUnFAcA8o8lO3p3zFc9QESigsmiAzGJWtLOAd3KfLH4KPMRCeM1aC4jszkFaGkcgb2YiaEPF34H0MdtRbCDR1s2Jv8Rz2pGQDQ9f1lWfcsSmZ5FtgdPfrHda2T+lnxiZvmhUwDCnVkrWOMYK1IMGLz+hNFdHgDp6IlnXka885/6aPjSWU+rTMA/8t4IkaXVBJdTEw+VO57Lha8WkDQfOZRv5uI3Xt5KJwIZyRgvnJgvW0z+I3HU2NK5YZG1d1SNvz9FNLf7D/l1W8TsBHVEfMhk2iNzr1JkPxgHZRGQj1GHM/802m4R
 jL+QRhqW
 mOGuL8BappZxWfx4Rv+A7BpIR/udrKTH1m5xdn8MZB9ptiU2J2NiF9+IdleiRQSWz9mBa0WGkuDyUxF530OGkbL6DUzRrIAyvMQE+/LIKh6X3JhVxyFPVHpZ/wkuzB+IlbJrbFfRqK8WUFKBOBMFT+0JTGC+LLwtlBG19MGwdGEeiYd1Tmq+TyMk8JFQF122w+e9JJLKS6LSHMfqlQ+K/yZHPdtO7mbV1Gx0zJXqWrv8IipHrfgX8y8Ii9wyuvHfqEatFfWGjkSg0SXIky7tc5ldBI4HTsW1ybn6xsp4n4WnVcdCn25mgbjUdq66BOkJnB+DhD5CT8jY0CWqnDEe5X9/B8D+lGq4KfezZVKXxiWusFOrT8SRPGj0BYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/6 03:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No feature change, move cluster related definitions and helpers to
> mm/swap.h, also tidy up and add a "swap_" prefix for cluster lock/unlock
> helpers, so they can be used outside of swap files. And while at it, add
> kerneldoc.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


