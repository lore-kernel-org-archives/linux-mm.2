Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C692EFCD9F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7274D6B0098; Tue, 10 Mar 2026 06:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE956B0099; Tue, 10 Mar 2026 06:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B8B6B009B; Tue, 10 Mar 2026 06:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50BE16B0098
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:02:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23A721405B8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:02:11 +0000 (UTC)
X-FDA: 84529712862.01.CC080FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 535B540012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:02:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=drxTRXjh;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvgZLxNoepIb5RCLGRo+ZeRNa66eCUaLE2QvjfikcyE=;
	b=6N83ARKDC+BWPoytNEnwqjPunTt3lK1ePmCKrjKp8Euo8wUtsjcxEMzbBmuKrThnA9cKq4
	R0WVvI3VtLsVEqS2waxxDeq8eEx+3N1UqqnfREHFIi8DMduDpVUB1qNDuQSpXHVZ4j+RLz
	GcP2xbZbz0xr7WUGBsP//mGc3nJQNaM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=drxTRXjh;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136929; a=rsa-sha256;
	cv=none;
	b=zGbmAMlbmi8kok3EZxcHkDakVee/HtPAlBrvDv/Tag9GziA5PF6CvG+Aje/+5gva+gZcj5
	6IcGyPAWBktT/o/QtER5LnX1Lt29pBUXokaymFHx1m56HILPAo+DfvF/FiV7Bd9qXH0h6y
	uF027HnA8Z8kygZnjYmE0jOafNTrh/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A2E4360054;
	Tue, 10 Mar 2026 10:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259F9C19423;
	Tue, 10 Mar 2026 10:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773136928;
	bh=AW2EnKIV5unNPlYnpWuupPSYBSspc+mdKzfnj40e7Kg=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=drxTRXjhF4eQcf8EDkeyKeEvVHbYNanT4mOGmTFPQ8LB3Akq1ZMHaC3o8Dss2BO7O
	 RU6Xn0Wqn0d7aACg3Q4w4TnFwYujsUfbgv3KwON9BAAuksNZrN0Xw4Cbtei+40efBB
	 lQkCDpt/zbm/TyLAp3Qoz5otVWdwJ9VY7Gr/PfgpPljvUmlJ1Q+s4X36oMKafVti5a
	 /Uwi9V8Hy+kWarZdlcAcyj4Pxr520wBVA87MY9bzbBMIcBa1Jji/pUW8ADAALNYwad
	 SM6SjQeZk0gAuHGzoQqDmy3K4s3iZ5mhVEc5tE0DhU+cXSm6FTXrpB7y9HVCgtPqTN
	 EchgDwG+h3PcQ==
Message-ID: <332271be-7ed1-449e-b7f7-ad815a941b9c@kernel.org>
Date: Tue, 10 Mar 2026 11:02:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: vbabka@kernel.org
Subject: Re: [PATCH] mm/slab: fix an incorrect check in obj_exts_alloc_size()
To: Zw Tang <shicenci@gmail.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: adilger.kernel@dilger.ca, akpm@linux-foundation.org,
 cgroups@vger.kernel.org, hannes@cmpxchg.org, hao.li@linux.dev,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, viro@zeniv.linux.org.uk,
 surenb@google.com, stable@vger.kernel.org
References: <aa5NmA25QsFDMhof@hyeyoo>
 <20260309072219.22653-1-harry.yoo@oracle.com>
 <CAPHJ_VLzRECge4=L5RRqZyf-Sou8APi=Sc=d0brBAMdj3UC_Cw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAPHJ_VLzRECge4=L5RRqZyf-Sou8APi=Sc=d0brBAMdj3UC_Cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c3qrwckpz38jqxwrp7ffn3u771utx4pg
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 535B540012
X-HE-Tag: 1773136929-489171
X-HE-Meta: U2FsdGVkX19UVEchPaNNNoCm3N6ocLY/RaEpxLq7Zz94QPcetMSpsePcN824Zb6wzA2fOzAcV10XOJdEpYIgEZFfx/jUSdndtOrHfbBPqqCx/sIZ6UnZvgqgLmQCCcNJjEGfNN7OLnMozfffTVC8eEedq6ffnAV7G621fQnXR9Lk7C5772U2i8AIiv3esrR79iPHuD5gV7Mnckg0s39rtx4oPJAefJ7hJfM2wX8yURKd9OwT5oHyAXhozZZv9ynwd6RLP/Pa/oWgnpWI0qJi674yVc0CYyshOcHd8yTxFTydVISDB1yqRHn67rHkRZZno4oJjiXq0u+BDQm1w/7UGqxMyPSnCq40lKVctbBQRGGHeK87FQvPUMBRF+ISOkhzCzV5UxelM1zW1LH3zZr79A1vR4BBhP7+X3HjwKaK5HLhvrDzG0HTpjP2wzypdjkREmoor76Roy5RBdU3wsjsxfBRe9J+81Xnah+E+SyB6gyj5k1QUDRmP2DzJjlzvH5PTbpntVbGnPHKD/lxtc2bhN2msiOmfJKkftSFgVt90laeUbWkxiloxAqDwEVdWBUfVoKKLGLYemlMs0K074ABQ6Rd8Bh458EIUb88FkPS0rOACoDy3iP1tg9RbU9WntY9HeapRXW/65ZEYEkX5JaiK6O1OxsFZKXMF0NjEmS4pXOBA0ltS6bSsAVc32myjS4LYH7d5Qx4fOogw7ZgfMIob1h2ve/2JZ/0WBs4q5TW9waL3oiVOdSaxwwR6MdxOw2+xy9Y6W2glIMpEPIZCE2Y90IsBu3rLJ7AcAEPq0HHHH+UpFAE7qp2M/DZjXuPiMU4BtILkYrCufu6BJLWW0WwRbALCqh+orI3Bk8jo76Vnk9rkssEkTseMhdZ8vzXpVhos7wb8MDMlj1nHNb3HyhsED1aErsvxEUK5JJDC1I79a5YsGvuvS6zVsMlnEMhF14/5h/t2XRFU0VlpE0QBnC
 LynhkLi1
 GIGkS/XP4/+Xq4Ur1IOjOYAYMMP6DPkDFS3Ob0RL/ui1bM/JjQluTp37pzTdJC/G4hlk4QK5AgmUwA+Y7P3yKmAgwLPqLBd6KjN5yIHO/vnYpN/7DUFOw1TUvavY/Wc1duXZiRkQ0MD92tBbYbmv8a06K0ZdYjGZ5CqqIRGWMQEkViouGsNJ7k2t1G8556Ps2/I34cNAAlrphWIs6QPJHJYCO8wMosOXT+x1ZvzcDiaRKo/z1vxG/kk/wkWv/scXnW9iRX4LWZYLDe/iqFCV39VfYJO5nCvaZM2v15Afe76IxnJiMNmt4btqQ00ilanHcPhmbo/oiuA76YL+EqDhaau/9e72gXpbeSvSO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 04:40, Zw Tang wrote:
> Hi Harry,
> 
> Thanks for the patch.
> 
> I tested it on my environment with the original syzkaller reproducer,
> and the warning no longer reproduces after applying the patch.
> 
> Kernel version tested: v7.0-rc2
> 
> Tested-by: Zw Tang shicenci@gmail.com

Thanks!


