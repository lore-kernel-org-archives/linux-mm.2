Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E71606A335
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BeZMMawf
Received: by kanga.kvack.org (Postfix)
	id ABFDF6B05C5; Wed, 11 Nov 2026 06:11:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70356B05C6; Wed, 11 Nov 2026 06:11:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9863D6B05C7; Wed, 11 Nov 2026 06:11:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7B16B05C5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:11:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 164E8C0298
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:11:02 +0000 (UTC)
X-FDA: 85422571164.01.C07ACC9
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2CE721A000F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:10:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BeZMMawf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41dldmnzUpbVdvTasv/OLzoqF6WSHnIdkg3e9karzSg=;
	b=exiVfQJaAF2YiSYIQJN0e4KAbZXramFdEzdI/eMCC2poQCYgxMBh4UVykhlZGR3ln98lmb
	PT4Fc7Wy7wzUrIaZapU+sjHS+zEGFQziJgpf82qzDys9JZzU6X5aKiyBsi2dSpWN42d35J
	h0Ymi//9yNMlS3WMbAr7TfXeoHDxrDI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395460;
	b=zJA+HlNrJMtdwM35mBAx8xhB3QYUrcQdkEh0mv5lJnvQoN5k2EGQ7XwbaSPbLaWsSEEq7F
	I+KawYBLV/ZELaYPoS9YceoLvRG9hEYfcDYJ7mgi7cYj+/fvJFEdsz2jdgHKTYcuhALp+Z
	MASrsY41iJF95YnfDdMGuQqpp5LSCZ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BeZMMawf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794395454; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=41dldmnzUpbVdvTasv/OLzoqF6WSHnIdkg3e9karzSg=;
	b=BeZMMawfNUA79+3UIxKmYl5iVh1678JFt9BajSOX7UZbO4zQw5uAFgoTxPZEAYS1eUpKm4Cokfw9YgoQQ/tZ3GKPIp6L4Cry5Bd92u38u+andYi2kdmELsWx14LrU8rSBWkBMUV91tkgwZp+IRE9uc1Vxtf6lavA6VzC9DH1aXw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XEYmuI._1794395440;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XEYmuI._1794395440 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 19:10:51 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: wangkefeng.wang@huawei.com
Cc: david@kernel.org,
	xiangzao@linux.alibaba.com,
	akpm@linux-foundation.org,
	ying.huang@linux.alibaba.com,
	kaitao.cheng@linux.dev,
	shivankg@amd.com,
	vbabka@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com,
	tianruidong@linux.alibaba.com,
	tongtiangen@huawei.com,
	xueshuai@linux.alibaba.com,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks
Date: Wed, 11 Nov 2026 19:10:33 +0800
Message-ID: <20261111111033.627610-1-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <64df30e9-4297-4e37-9e9c-2760d68af24f@huawei.com>
References: <20261110112641.1196786-1-xiangzao@linux.alibaba.com> <16cf88a0-6652-4276-95fb-12306e417701@kernel.org> <64df30e9-4297-4e37-9e9c-2760d68af24f@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c93jknbjge4zd5ecfh8ersw6ofuj9n5h
X-Rspam-User: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CE721A000F
X-HE-Tag: 1794395458-905622
X-HE-Meta: U2FsdGVkX19QReJVhfe8XBR9ENEI8jZwrZokprf3FQycdlFDllOs3NMgN0RBEntAryT3WnYytFh3oDIJkB96qRQWNYERdNKQHBeDvw50D6tX0JSfqVLpS4yaQKTSvIQr3MOQvUq2zk8k6ayQvCOW0FEG2bAUwNs2p8Q9traCYeZ+yZ85Q4url4CODy5e52mHD2GXjlqaC5fsGORWLHfZMHs9+mJiVYH/dPdK1V/m0X+pSZfMOxS+Xt/B6xRTAOT95GoNgZTOpNCjjZvGAvXuXPuN0U8e+3sLQq+/VmgX6nkMmWSERiRRW36XiZMxpH7iu9T6v8eJibPh4pH01CkSb8xYuZiD0/H+bclIGnuLShRUqlNd3lboTFsWUGUM8Jh2xBNqFKZrHZhFSf0mUcyI1m7Q1WzZh4KzHzEjO6ZMnRjA2LHuBw97szrmW0tXizWCaECqXke/cfMc8eMzTyjlnIC/Kdc+NXZDz/KzPlwRo/nO6r3wkRyrGIS4T6Xar5/jWI37EnoVO9caSj7DeFKtcyE5MIpa6J/mA1DMqhDcV2usLvIF424JNm4xwcmFgnAX6oOGKHa1oTrW//GL7S/Ma3/nusYGx49+jF03a7/dT7NnsIAcehAuWjcGt6nXWGxSlm2iXvis+IhLl2my9tVsRJCIPQxJuuQF+mySonT6dLN7OUlyos6aRPKXdducYLZEsQjiga6ubWwMKodpAXgLo6CW8H9wiFmyd9j+D8BCr6MguS0cP8zHQhXtls7OiFvLJ5bgd5dsA3ylu5E7guoL/GFxxU0EkwPq+/NCAfYKWhZNkqCA6UWwL+QArNviab2Ec2rD1Zd+US2Akqi+1yoviLVFHXT9vjfLvFnSA3moESGGiqXSTchRaKc1VZj4kG9H+JexYFMyKLMifunZi8XFwGZHZxeo/Umrk3k7GwCG7ed7WOLYL5n78LK444jbXf9uGDC/R4v7TORCkrRE3O7
 x7jNRk7X
 wGPJ9cgemHaaSSDvJdZ5m4asnlJ1PmCigDPx6rNpot/wEZeNJqgRArfGB8Pq4Su5anK8wOuic3QNGT+RlEr7YSaGc/8Ct+qQkBFJIO6B5TWSg8j0yrlBqoUXzRcifvooEV/sm63MXFDyXX+ETdpqwTjlzjvufaxHqHHzPfuPc/1SugFbrQa9RVcMkoLAdPUMPV9FrQM9GAGRYv8Ym7ZtGlqRkjqioss6h6MZNh/KghCQSAx8qldm4EmzOKj6uCkVfSPtVcVg7k/8BcEEpZlXiOy1IVE8V85FchUFkFcctib1Qy5pSfSCRkasAmmucOMccpkEAwuaEqK9U5Sgq6kbmGl40jz4XXnpbt9HY1kXSiCUcJJMsIOa/gD/lzPICVeazi/iIXfhpw3Ryh3gO3FmlH78GdVEoKX02U0rPRQmIbiX1ZEnnTX/zEoFYCTct+M3QnvI6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kefeng, David, Catalin, Tiangen, and Ying,

Thank you for raising this and for the continued work and review
on arm64 COPY_MC support.

I would like to provide an update on our side. Ruidong has left
Alibaba and is no longer focusing on kernel development. I will
be taking over the development and upstreaming of the arm64
ARCH_HAS_COPY_MC series, building on Tiangen's and Ruidong's work.

This work is already underway. I will follow up on the feedback
from previous revisions and plan to submit an updated series
in the near future.

I have also added my colleagues Shuai Xue and Baolin Wang to Cc.
Please keep me copied on further discussions of this series.
Any additional guidance on outstanding issues or priorities for
the next revision would be appreciated.

Best regards,
Weilin

