Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 944AAFD45F8
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 21:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B557E6B0088; Wed, 25 Feb 2026 16:57:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02996B0089; Wed, 25 Feb 2026 16:57:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0EA86B008A; Wed, 25 Feb 2026 16:57:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC366B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:57:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C4B31607AD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:57:11 +0000 (UTC)
X-FDA: 84484340262.08.D775064
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 426F2140002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:57:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="G/Vq1kfz";
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772056629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiFwMFnRC66EdvVEka+nTnJQSeLox1cNdW7WVtL5m2w=;
	b=DqR4mD14z0bSXfiZej66H0oRKzBbH0D+KKHzzf0NtoH0/oxn7z9LhVOe2ud+0kOmX+sax3
	XbAzfO7XEBqG7JH0f29M1ZJXGbTZEwbS+VuSBFzeTT/N3W4whxQHjxTKTvBJHMbVLQsQKw
	w9Wd9bIcCrqh0dKet/Q/ua8UTDy/JV0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="G/Vq1kfz";
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772056629; a=rsa-sha256;
	cv=none;
	b=SGo09upO/yttRqtU8WmXPKCTp379qhi4Aje7Xws3JDZXPqa5u2f8bnriuyPuxKcX/cOcln
	Oe/r0W/4HcDRfqktNS12FQHFNJ5rE9elxsB5bSScbHyaa2Cc0CHri9HhdLbooycq1PAE0o
	ddtU5tTS+q8IOpf3KqrYFjr1gjyfDvI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8ABDD60053;
	Wed, 25 Feb 2026 21:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2780DC116D0;
	Wed, 25 Feb 2026 21:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772056628;
	bh=CiFwMFnRC66EdvVEka+nTnJQSeLox1cNdW7WVtL5m2w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=G/Vq1kfzJAALm4ICHrgT0kZkyQY57Mgf9BP/lWZgfG/fCEURrkmzKL+YInLwxzY/R
	 WXrmUDnN2kHOEsREOKro5+So877c0l1gmR7lBm8biLCHtXYl28JRcFoO9w4wq2rFC4
	 egjuwp8w+JwTvAJUnBP2yzl6gYH06fgJkR4U89yY=
Date: Wed, 25 Feb 2026 13:57:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 00/32] Eliminate Dying Memory Cgroup
Message-Id: <20260225135706.28a93fd5817e0939387275b6@linux-foundation.org>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 426F2140002
X-Stat-Signature: 3811rmakn4jizkmmj1r8h6jx9yiek6qq
X-Rspam-User: 
X-HE-Tag: 1772056629-259167
X-HE-Meta: U2FsdGVkX1/oSG+9PHpy7zEo0h4auzT4pb+GBjYuSV4osVbMD+wsbCQk2wvS9PdScvTEmJ39xWOdyZa7PlcXbvZMRkS6sHSOAMph0OFreq0An5oMnSC3fAMnOMjJdMtjWZBJjsBF7T/nC6+VXdci2233XyH3NBLpl4r46jqPGVEVWWrTpqgk4GvhGD0B7Ve9r6At6xR91NpqshtSxGz5s/HctY5xesDD1t6P8KyWJphRZs8TsXTZJ2oraJoCDmdzgkEXBSc8jQlUEzCVoIUVhQsxLMGbVl8l9G0hikYIeIbrnSMSw/CBnFzK1F/eJ3doi14oo9hQEbH3WNi3rVF/RNyElk+lRUKJAdpFCKYVtVUpF4qAhnJMaALsksTx2IC3VQxPvS+j2it9ulyFhKzNb5r3M7NBz4cDlX7UHYAV+CdHQZk/lcLuLZGYuEqaMoTJKv/0F0sfN1JMhTQ2YRS4vHEIlDuCGn4xtECnvPZnq9/YuqlQIjFN8u+6/M3I4EjYoI0ht3ISwmkfgjQnh7oHu04v49vBrvQtcxpg8Ngwodg6vvtxVfrG9yp+vICGq4lc5A37qMgRFD4t1R3ZjLWVeAXAoyh7p5Cwjx2a48yhdXpvmZQiLN0VnlFhzbByE1+IpnQFGhJLkHpTj7ZTt5NjO65g1Ne6lF7oBO9pYNY6WVUo6ndlXzvtXAcyOX+vz6U0Plbee/Cw4vxWUQx8lXL2eISf+6B5T3k9qTq8yB1ulpj27iDycCK13oxn6rilTbKDY8/X3j074ujST9U4VLhqWCW5kSeB/eqTr6X35SYx/94xy4wNWWzdMl3+++ETMMbY0kYY7lBy0sRKHah3Bh+THTG+mwCa+oH+oEAD9t6gDysqS6uVnyD2OAxdtd4cuUeVHJdDFLsAeZJxQckrKxTKQFwTBJfzBCjf2KLNcNvGfpUKOd1jeJUMbSpPfS7Lecb+DzxZtYhnf+iEUtk+3V5
 I3U0CvYv
 tbuxQxNoeW9zF34L+zzkQGc/wsAAW5OZZ0M8Wl7PISQkzMDZhba+eZxtDn//wyGuUVtN3uRlO9uvkM1sHfym9Pu2oSPUtyJQ6G1cVaOne78cWKjxxa71iGYASzh6Jk02d4Ke+2ptYytm3gsZsn2zGtLsRg0nWNVc/MRLeKCgrcjSh7Seuzm8NrhCrDz6SDU2wcEZDMzGwsrtCgt3Eg+8LK+meCB/Xc5cNJuTtMDzaOrDRByJom0ElQfTLBKlYSJiIShgdi0Yrue/eWWGOYRmLjWib2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 15:48:33 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> This patchset is intended to transfer the LRU pages to the object cgroup
> without holding a reference to the original memory cgroup in order to
> address the issue of the dying memory cgroup. A consensus has already been
> reached regarding this approach recently [1].

Thanks, I've added this to mm.git's mm-new branch.

All being well I'll move it into the mm-unstable branch a few days hence.

Then into mm-stable around -rc5.

Then into mainline for 7.1-rc1.

