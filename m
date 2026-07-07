Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29AECC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A826B009F; Mon,  6 Jul 2026 22:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213046B00A2; Mon,  6 Jul 2026 22:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129346B00A3; Mon,  6 Jul 2026 22:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E42AC6B009F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:40:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66168A02B1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:47 +0000 (UTC)
X-FDA: 84960427734.07.EF8F221
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0DEBD100006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YgTUAB9t;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783392045;
	b=Bl9iyifZY7W7KMueyqg8nJc2oVN/i1kYkhSELwouNaPDsIIYxYgnGC/X/rqEy3SVinFwEt
	BJDlIq3/VQxiTPyfYpe3kaAvVrplIeY9lcNsr6lW9Deo335/cGbvDalhymQQMYA74chhtV
	CBjvEJoRsgnBINp29e9gScopSZP3CBs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YgTUAB9t;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783392045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Wb1AwlQUDANCXLIlJe1BEf68T26OAw+skWP98OVAlw=;
	b=5U6tmA9O/Cyd/Z2wNFoJQEg/qKvaZglsGp6x+QBAGGJugCDHXhtCS+wPOF1pf3JPzMyleZ
	th7oYp13e1SEktDOx0I5Kv57bL//emi8r1UhYcdJo5lJ08vf64QDnsDToSI5+qCk0CiQKP
	i2RYKhAdwP/XnroPpQN8y0Z6swAi2RU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783392039; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/Wb1AwlQUDANCXLIlJe1BEf68T26OAw+skWP98OVAlw=;
	b=YgTUAB9tcpLl9ufns413JzT/5yhv81DSz5Qm5936DlPnlZlWNQl8Ui+Whu+IVi7Y0gplXxUjrXmN1QCSDYZ8V0Caa0KUSgp0hgQTqmCrBxVoNzJthgU2qIz6MdbBa7+qkyUqqI9taWKnXAKvglTmVjSHEXFUr7lYEM8ROUPalCQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X6b9RnM_1783392037;
Received: from 30.246.177.139(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6b9RnM_1783392037 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jul 2026 10:40:38 +0800
Message-ID: <235acf15-9eee-46ef-b283-2fd12e4d4682@linux.alibaba.com>
Date: Tue, 7 Jul 2026 10:40:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] shmem: provide a shmem_write_folio wrapper
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org,
 usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, youngjun.park@lge.com, linux-mm@kvack.org
References: <20260706132206.935272-1-hch@lst.de>
 <20260706132206.935272-2-hch@lst.de>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260706132206.935272-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0DEBD100006
X-Stat-Signature: zuo1z7quezfefs9x7br7hyiscs6n17oh
X-HE-Tag: 1783392042-217630
X-HE-Meta: U2FsdGVkX19QQIN2Z0BnWEmjdsQsoH+AJNJnWq6J9rB1g4WdHpwvATmRYROEmvXcl3Wl3dWvSGhjG9KMvC9XvrL+oHFygjAN5s0ssX7Xa8gk/NnjLRvA612kRZBeyq+y01LdqhcHEwXbXAQ2VU8ozO1jJjqbcF64PuAxPN/LTbMVC4rkFuBfuH0E/9Tg7o5U4zao+4omx4ylzE9ZvONZEtPLbQPEw7nMucogtzlloDyyeeduxNreSQAOWPvziikDJ0/WvFIyuUifESOFIlgkeW2jaQ3E4FL70eyb+PJQQn3/lOmkRtsTGm3yr+LekkEFr83D7WV3FnA+X9HKlQBIOHnheIE7MvTIHNzbhtzvsvIlObfUmhmlZ7Ih3hls+PUWeSit83RYKNVC6LSt3EBtxtFG/tNnizautY9z9K7QzMBv+L5trvkcVBtISU5pC4k1RSDFpu6mulGKNEZUlqJasca0taTZxTbvfiy6h5z0HQ41ie/DBneYyJR6RM+2UwwJjpPpt+8eVbwf5nb94v/5BtOeAKY1BdsjklT7QP7L9hmqiNHNGKSfRw+OlP/iSRwbytD9iPBLa8g0o4zLmZGNQDSdfYrk7qDLRFza2AwuOravE7a2paPNHqLl65gxx6Xs69rpgbQc5KTMp5GxuUky1C9l9lDENc2nobBngPUkkLz7OG25t9BSwKDDj6BteikFTettYBlJQW8hZJ+TacGP80DMQx7A9Yc9AjXDp5/KOzS1p/TyGNJGjvaS6a9otM5PIlIvr0c1X4B4w1WO1KyjTToBLJmLjEomf/QLDcOG0TeRbK3RguH4ED/SZtlzyxLBbPl5KhqI6frz2BxkzgcXMbw4dU6MS9HN11zMHftj7RoSvSjpO/l7iuhYPdynNZNbEOh+dOaCsBSUxyY0EX/PcpJ+R0byFM0AK/WrUUkj59RlUGYPMFDGwbPYZ65OzztVuEznh8l7mTV+pYSYBni
 axKJ+VUc
 LuRAyEtgiAyZWJBepapmmDmQ7/iu+2NMhb1+Yt1MecmpZr1EtVWSMzbOjXWXIalRJxP8b6vNLxx8Llv7zhesl5qaIrFgl6roZr8/05cygewdmyh14cKXH3M+UmcDAuxxKndK6SK577WrlHnQJY7d07wDpicBUk4NR3rxsRIhXjjEUPdk0DO3+EARxB+eB0qoV5exbffgYMWr0bvQn8J4vFXgK7rPeBZa4xE1ADg+BQGlcG8QD5tVP6e3UdJgnG9pjxsMgHWaVJ0zmhawa478NladeMI9fQeqBGxTsbJ9Rdc+pr1UwQmEzBsRbLzCDkmPAjgXycX8zAbkPj9m9sLxwtwyFzuoKWQwJ8jPpi9Uicz49y/+Ylzbub960RPNoHTeoze9TgMJGPQ3ialE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/6/26 9:21 PM, Christoph Hellwig wrote:
> Provide a wrapper for the shmem abuses in drm to prepare for swap I/O
> refactoring by keeping swap_iocb handling entirely contained in mm/.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

