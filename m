Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B167BCA600A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2AD06B008A; Thu,  8 Oct 2026 03:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADBF16B008C; Thu,  8 Oct 2026 03:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1FD6B0092; Thu,  8 Oct 2026 03:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1796B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:59:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3B8F1404A4
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:59:04 +0000 (UTC)
X-FDA: 85298708208.07.AADBA62
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id DA749100007
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:59:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dFiTtafA;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791446343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcrCKp2Z/lN3tk4V8Y2aF9bTvR6+Hep4GNXCTRa+zWE=;
	b=LA39CUo54ETkUWvsI77WrvZDpQdDYcA1pRfU0aWLijm+qfSolICEtr/rO0iqLunP8iAla9
	repkvtw5DX/gqJEdGhK3+Q0HFxTzYK8jUAZuf2dN96uh5gE88fskVPl2ylRX8sfvIkKYML
	rsdbWxS7gUIOCKPuG6oBkRGRB/Vpx80=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791446343;
	b=n0Bgi1E2RGmU/JoY7kpoa25t0W2zg2ESeveK/2Cq3f6e2/HKYMtT4qD9ivz9qa6CHvXv2s
	P2OOZ+EP3TuNMGCh7b9kR6YZ2F2VOemVjDDiVVyEX2/Cm0ERsozE7bu5hDB/g8wfNMB6XP
	1XyrlOf19IB0PJSX9dkAjrOpKn3oFM0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dFiTtafA;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791446338; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HcrCKp2Z/lN3tk4V8Y2aF9bTvR6+Hep4GNXCTRa+zWE=;
	b=dFiTtafA+hTEzTM5n8mOC5dQyToXnNtnazGRXnK+PvSfTVvz4wIh66r2JTan29Dm15WtNWX873NdBHYY5S+/hA57yfSoxGqgvFnaltcNhwOOHami2xyhfKql17TxAO6tpF/8bZ0uYMuraMe5X7rYpWFOR/pqe/wUNdgPSA52YQE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XCMHsUt_1791446336;
Received: from 30.74.113.73(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCMHsUt_1791446336 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 15:58:57 +0800
Message-ID: <6aa5a165-3ba6-4974-b549-fed7318ead49@linux.alibaba.com>
Date: Thu, 8 Oct 2026 15:58:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
To: Ayush Ranjan <ayushr@modal.com>, Pedro Falcato <pfalcato@suse.de>
Cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924061708.1645968-1-ayushr@modal.com>
 <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
 <20260925053027.1998394-1-ayushr@modal.com>
 <20260925065013.3682431-1-ayushr@modal.com>
 <20261003033107.1488699-1-ayushr@modal.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261003033107.1488699-1-ayushr@modal.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DA749100007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1bp9m1rrwiqmt55dzd4111uj8s9of9uw
X-HE-Tag: 1791446341-182711
X-HE-Meta: U2FsdGVkX19Io5hKE67p+lchb+VpE3fjgqBrel574XXIVJVAyU/z3RlFA1VzHiMsPY11QfAz6Dy0leUI67UqqQ9Pai4p8o3chZMVIkOB7ltgTIuT22x08NGVO62qFTufN0DUY2IdnT2sEK1Jo1wOpMtbslolhKvXTwVYiWc3OwZvYi+QLbYRFpIxZkLJCeMxksothnU/00lUy1hdysOM0lEAnjJapB57+7s70KJCqZvO7ENqg9D17vdwXK/MSMN/8NMPIMrS3wVoXzMYsfwOLNOgwaxii7y9wDzW5snMJSgdrpgheMcc6T6saiUCynUw0TwDjGHIiDzisriRn13HVdgoOZXxXx6zDX4oCCHbh72I6mqrDfUqve9T3vcFUhDJp/ooRlBLwvv8oa++quIlc5KGZXLIUYArg8KSoOGndmZXqPyQ9H0VJPAEHSmaGKCjlacTbPOnrdWV4PcJ4gL+RBiwh06k2xO63z57eVxyLpzllFSQsIG7txm7QIWz70AXd9eagTD3YLXHraEDCcUqkUCp2SneW11yjymrS/PRBJKMHnVAG+1Qp8GQ73N/zuDZYxsaOK3PsI1yo6EoZBwKB38whsRTcAD44ECOHmlT2QTzEEn33VKX7N05BQpYp1+rrbqfWnsti3yvOG4TgogPdlb9r+8N8OW2xl2yDUmGJ5I+55aCl7JhFxcaJstyvsPdgl6j3LGBfXLOadRjXJcPLP9HHfWCbFsykYoJt3W/ljAHrEnX7HN2xgpfFmqKFKy3QAOa5xCj3/nGmp7m+68BDj41RNypSTTlk2RYokiguKPctF3WJsr7te+j2s6yopYOX5fQslG0y/zJtFT0sGk9MFpwLCXi5870zqEM4oYn6/1XAlh3o+fwpzCKMTewYeFH0AtXgVJzHlZR6E6DEKEQShFr/EGHsQpxz1rt5asVYzecxo/bQ2i8c2FEaIxOuaGmfQAzuHcHMh4MmUXwQS/
 OM4Th37z
 YtDtzAbGjfhnxIEy5+NsTkTBOANxrDyVDPSxmGFDLJCTucR76RO86IJswPAvP5iXdXddz6mhEEMhahj9zfTK0IgeMEL0t3qlA5Xd1/vZFV9aVzFhkz2dmcsEX19rbkor9pKHIeyPQYtspvIraFsbTAyKJWV+JmEU/I1Yh0KatCwESGbQFOBShketxY74Kkes8vURa4G5ZgK0Fp+fPqiRNbv57aM6Bg3OyQqm71aX2y7IGNxah8J33pNQPBMb+OJWoL+CLLu4z63d9eXC2jbuc56cjRXDUqUkJx/9JGz9OQ0HgyG+pwQ2MuzicH1W+AGI9a7ZyjGLVQlTYygcP8Dj1RvF4VsbnBJ3M6AuWMQVrMHOF2es=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/3/26 11:31 AM, Ayush Ranjan wrote:
> Hi all,
> 
> Gentle ping on this. 

Sorry for the late reply due to my vacation.

The reproducer in my previous mail [1] triggers
> "Bad page cache ... still mapped when deleted" on 6.18.46 within a
> couple of minutes on a 128-CPU bare-metal box, with no fork() and no
> gVisor involved.
> 
> We continue to hit this in production at low frequency, so I am happy
> to test patches or collect more data if that would help.

Now I can reproduce this issue on my machine with the latest mm-unstable 
branch, and I understand the race. I have confirmed that Andrew's patch 
can fix it. You can try Andrew's patch.


