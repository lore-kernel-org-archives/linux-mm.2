Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5F7C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA97A6B0088; Tue, 28 Jul 2026 00:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80B96B008A; Tue, 28 Jul 2026 00:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98896B008C; Tue, 28 Jul 2026 00:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8ABC6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4943D1C047D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:15 +0000 (UTC)
X-FDA: 85036863030.01.46CA3E5
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf20.hostedemail.com (Postfix) with ESMTP id 10C811C000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="hB/aZ23U";
	spf=pass (imf20.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211933;
	b=NVa8ZUIVHU8ucc2K3hzwGgLif7hx992fMCXVlKnZ4wne2c1Fy6pnyDPbjBczIBccHgVDqV
	KMf2SlKmI65Ta+ngtl+1jAI38Z+1lrjfnK9pIIz5QFGfptbgztRjacbxNc6lKLzedYltyU
	Is+v+WNBTXk34K1BGNn5FzzMTPJ7jNk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="hB/aZ23U";
	spf=pass (imf20.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rn0MDToQVMVKINRjrVJtJCbIBEg9do1xXTBpGls8VJE=;
	b=YSlrRVoP5auyFdYu/HBlbg21awKIOHxlVy8v/dP5igDzrzvWHXVSa3Pm2QLkeHhCTURZ/l
	3y2iaGFOFCUnDfIndfQCRMBJ/+oWlZQf8TaGEnWYTtvtybijAUt/jdr8tFNbh3Mj2K7jwo
	PVvTVe85gRxD2fO02WUcdkDeFKBv1ck=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=Rn0MDToQVMVKINRjrVJtJCbIBEg9do1xXTBpGls8VJE=;
	b=hB/aZ23UYJpNyTn51mUgn79d9ngvPnHef79BV5jT/2vMkpC8CkJQCtPSCriWnd7+YUvHXy4A8
	7Su/HYrNpa+fso4DS1d1RkofH+qvbiaX3DDoH4S5SQUQm0z3rgDwFh0Nktcn8IVUSH6R1f8XnLe
	l7Ge/ZYUBy8yW1TcfjeC6Ss=
Received: from TW003.hihonor.com (unknown [10.77.199.161])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4h8MVb3SGjzYmf94;
	Tue, 28 Jul 2026 12:12:07 +0800 (CST)
Received: from TA012-1.hihonor.com (10.77.199.132) by TW003.hihonor.com
 (10.77.199.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 28 Jul
 2026 12:12:04 +0800
Received: from localhost.localdomain (10.144.5.36) by TA012-1.hihonor.com
 (10.77.199.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 28 Jul
 2026 12:12:00 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
CC: Zicheng Wang <wangzicheng@honor.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <hannes@cmpxchg.org>,
	<riel@surriel.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<harry@kernel.org>, <jannh@google.com>, <lance.yang@linux.dev>,
	<kasong@tencent.com>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
	<baohua@kernel.org>, <axelrasmussen@google.com>, <yuanchu@google.com>,
	<weixugc@google.com>, <mhocko@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tao.wangtao@honor.com>, <zhangji1@honor.com>
Subject: Re: [PATCH v4 0/3] promote mapped executable folios after first usage for MGLRU
Date: Tue, 28 Jul 2026 12:11:59 +0800
Message-ID: <20260728041159.3409603-1-wangzicheng@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <fef26b57-1e5b-42af-a311-7a961806a22e@linux.alibaba.com>
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com> <20260724160000.b4-mglru-feedback@hihonor.com> <fef26b57-1e5b-42af-a311-7a961806a22e@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA012-1.hihonor.com
 (10.77.199.132)
X-Stat-Signature: ais9iorrc8cfj7jqez6h4ohmhawa41f5
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 10C811C000A
X-Rspam-User: 
X-HE-Tag: 1785211931-310424
X-HE-Meta: U2FsdGVkX1/rFVpvYSMUTplUllspSuiLaR42wzwHKx3mZPD0oIsvrzSxbRG5Ub1ZedBN7fGhDLVUZ2l4LcXEnZo+cBN+9xos0lkL0tGxyWHFUXkl98mkQghd6he9gXaa8WWlxD1i9Z62ZVoOK6AdPV6fpUsYWgtKlIFBQ4T7y5CMLg6+FAejg1KOm0JOlluXzP8RaFON/qYf1quwzJdY/po0du38ev+oQfjDRLUI8jMth2zpJUC8NkxbwsWkfMhS3BJ8WZbxtPJdCJ1Kylsakatt23GfNl5G01GtPKcvFMd8XUs1vFbAaxhcKtjfL7P/hKLVRlsTAkubnesW0PxIaEp0WpkP5RgqrBeS6/1wMBdAPoJmFHUBSdWm78+dkHs3rlEPPwcG1A9K6p8gAh8Zv8+nCfipZSQGqMUCOYO2UODMByHMIQIkabT6B9OK4iNfwUAs/r3n5DZLxrC6C7xsY39FK10EiokgJhE1j9+2GW+bJxVSNa1fhtNHsR25yhRmZiCbejNTSsbU0r+VUSgbe0PdtWheJ66rUZgq6Fr1KPx/ReNtSM624u0n1E8ls9cfv7zFNGG/EpWckTOvqfpeIIAqZmkLT4ugELAWLOveeDjDglCLVb3HGPI26MmnFGYjgofCNk5co7bv8WoDbIrySiI+QiXsxtuSOOu7+SC7vUB4M+XJx2Gl4TqUCiTi3cOrkhz9tstM1OBKgxbjUZf1/XIKulVX+71Xk7vTyzB4yPxsfaNrQxDedWEuhNyQNyymirJtx7jBsDQSzNNX4pWOpTqWeUou2fPnCIfUtGTM/XfbI2XUx2jgwuf5DcEercymareOqmsGZBfaKLekdF+MUiJ8n58dpQM8PJEDtvdsra1rA5MiQ3a9EIFF7aujF+G9hE14Kyu/6f9YuiZ4BQFrcOR/fX0zqAyuJw5YeYTSeOuFq/aQ/SIVlM9Usc8EB1mCiHQg1/DC8GBqHVk+2Fp
 /7RjXTn3
 2TPz4dT2eQ9Op4Jlqjb/Ne+VAn6lvDCz4f6F1ORM2Uph+p4gOGKujLhmyos3ieQnc8QoZ343HqFnC1pwnIKpH/mT0zdOFAMdFxrrpuO1pOx20g/62byPcYgl+dkXyWGYypUFzF4Nfk+Zi9OElBFZMllzDy5ofoIiqO+UwZPWOb6at29kB5OFgUduOQIlQYtC1ROQt+uUD+bWKqSNdJvye5BVJMHvQZcCRZwLfMrKKXlr6ebPgcJVWLML9F4WcIHWkWfpAz+PE10NWkUTdZix2jwXPng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 4:08 PM, Baolin Wang wrote:
> Since we try to keep executable file folios in memory to avoid IO
> thrashing, which could cause more severe problems (such as the system
> hanging), this also means that the stall time of some other folios may
> increase. Moreover, the stall time of the original exec folios might not
> have been counted at all, for example, in filemap_read_folio(), PSI is
> only accounted for file folios marked with workingset, but before my
> patch, exec file folios might not have had a chance to set the
> workingset flag.

Thanks Baolin, that makes sense.

Best,
Zicheng

