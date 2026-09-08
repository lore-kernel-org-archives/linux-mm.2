Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64EF3C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601566B0096; Mon,  7 Sep 2026 22:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2416B0098; Mon,  7 Sep 2026 22:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7906B0099; Mon,  7 Sep 2026 22:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 241C76B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:33:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD48316035A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:29 +0000 (UTC)
X-FDA: 85189023738.26.4F960B1
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id A12CD80005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:33:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fi8Zrlb8;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788834807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDV+vVVwibDbfJfTqoi2mWtqAmqXpU6+APuY88fPHz8=;
	b=0DtFFUzF4Rhszs67gv1C1Jxtlz++yDVYFOSBMfyO/tfJoGGIjdneZ76EkxY6n5kM5WCxI0
	B389/V+JJ3jfb7MkIokjGFhdGFuE+fO0G/fVNKhplrqNoGF7WYR/9kIq6rCXKsDmf+Ctk3
	77PqqoJ3/BSnXEIlTedUjxGEHUJZil0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788834807;
	b=P/dwRgfYhvfWlUyq31MLwqNmpqiaIXFSHCkUTh/oGm/NCQBrt2gEHj9bYR5SiYW/ZWV9WQ
	p6wmEfogoA10mcX7dCmIsiKM8ElWR+WiJyvsE1k+fLP1smTkt2xgFlArwoIe2yYstHni28
	1I4tV2D2pwWWX2s0DQBj6wHUKn/DyDc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fi8Zrlb8;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R8+z3o1kgaYxeVPoiKPiKfc3vwuJg9i4MPUEOvW9gvk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788834806; v=1; x=1789439606;
 b=fi8Zrlb8KjB+5wBtiTI/2pQmRnl4T2DQtpOXLsjHy9eccO1LmstGbdRtzLUthSwEHSlOdKGs
 nE82HILoE7GyDnaAAPHWj4f+ChQSvloyfAF9I+XKdoOyIN6Dg/J4p34boY8qvTXdNHsdhZ3+x1a
 BHj23ntEIJeMLro2Af0fx93o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 41c10c52aea90560;
	Tue, 08 Sep 2026 02:33:25 +0000
X-Mizu-Trace-ID: 41c10c52aea90560
X-Migadu-Flow: FLOW_OUT
Message-ID: <d97dcdb4-d060-4e1a-9af5-6b768339fdf6@linux.dev>
Date: Tue, 8 Sep 2026 10:33:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add Baoquan and me as MGLRU reviewers
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: kasong@tencent.com, shakeel.butt@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 baoquan.he@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 385emacsat8zfnrb93u3mfaw7xfyigy5
X-Rspamd-Queue-Id: A12CD80005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788834807-241183
X-HE-Meta: U2FsdGVkX19kXlJfIExKLcBU2SIRXTxWBKVnJmNzGqGy6iwL3fcBqLvBHCaBeaVXo6b1b+Fl78k+kc5bJDrsNAykRQxqG+aivbQzPa/Mz4A2gEtlXzGpTPyJjtBwTNqrxPbttp8T5WOcn7InAjxfTRh9IqVnlKG0tOzw+PDj7pshr0R83BpH7OotpHx8Bas2zIRh7ntgrFB+seznmh/yJ9DpOdj1UhF60cBZOvXBju5xxhuDMFnqOGbn654tBswccu15LFir2f2UEXnXadx5MBowozn8lKi2ZbzZtF/DAVSOjS/xE0vOhymtE0AzYXqDfAe0Yh8Wjz3rTbwfYWfMhwDcSqKrwmjmpD+jhe+UEoRXrfYCgbVF1ORoNDPVfjkmD+eEMAmFHkN3w+mAdLIEdbmDCmgP0IWxFdFvK1IAvW0Qv81Ubl10L7DdhiJNyHMfqXdam5HXMV7WJG9fNZmBWd7mmJLxpYp3OPcIau+Z7y7PRQWQHDcn+r6u2zJ/QNgwEyfHNjFqQcjNryz8lUSFomhIVhM/51h3wf/ZxJdjs145g0g7KOLtsbdsAGzOsjv31lLvqdJtn7F56iydhEmS9u6upqWqVJBtcMs+Jsu8V62kU3sLoAyGtbbuynE5CGIIn/Z5Vzy8dz9D8ekhBhSuCYE/t7uTkOXV2mx4tZcEO3MkRVy0ciHM29af+Q/nFU6x1DADmFUj/YxTNkKl+74zE5cmF+hV51MBMSf58i/fcx2lHH4Iaav/VahS3Qj+BwvX2DOXLI1Me6DS1AYtd9W5Wz3uU5IFbPwpk6YbLiU8Qd3Qi5zvgREaTKC+OtyHz5Btw995foyB+uhyR8nd0TmWDT6y1GSIDjWTI/I7Pf9TPjL8tnl78L877UnmTXApEGJTT3y09X4rEmWu2wn6WwFtOXEXDBK/nV/aHGXfxGPS5+93thKn3UZ9s/nsk77OilGhUeDJ9Wh/hvXcezsLRjD
 w+K3m9qg
 X+FC9fNn5huQS7CCH89ymnipRUVT+w6QRWADQZI9qkQhnZACECh+E/eQBGcrRYe4gHB9KJRmp5Wwldyb5BUW+3g6IpeyGrbRhY1UEedP90DAGtDzDUyG3C/4bivKNg+egQKbdsw/7TJbQKEM6NdBZLcN48nWvkMNEEvUG+UDZ3edBRHxePjxZmcEXJ4BPE2MZHDv0hHX/yqtFs1Rw2LPTtaa3dXU7WDwZdMIQnAnExQnTYPVb4W6NkD8jR+yQYK0dUtFd0guo9qiP7144B0ACcD/bKmEWWlqrtPvn4G9R2lv40lmuH74SENrFVYXbzoyHTKJeROCZ/TvdLFRJGpfTLJFy27DhyvTjkMda0LBeaavxNNSuf3ZNjuyxXdcWdGKAZuaY7WWMijKVVES9lcgxKoweUtzP2nsd5nmnvOpWMAmIcf0aqmMa/oJYcDyBP+omK8Pg1C0K3N1RQvgFjTF/Z0jyOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 9:42 AM, Baolin Wang wrote:
> Baoquan and I have been contributing MGLRU patches and helping review MGLRU
> related patches for some time. We will continue to follow MGLRU changes, so
> we'd like to be CC'd on MGLRU related patches.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   MAINTAINERS | 2 ++
>   1 file changed, 2 insertions(+)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4d1ff4c76496..c558d5370dd0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17242,6 +17242,8 @@ R:	Barry Song <baohua@kernel.org>
>   R:	Axel Rasmussen <axelrasmussen@google.com>
>   R:	Yuanchu Xie <yuanchu@google.com>
>   R:	Wei Xu <weixugc@google.com>
> +R:	Baoquan He <baoquan.he@linux.dev>
> +R:	Baolin Wang <baolin.wang@linux.alibaba.com>
>   L:	linux-mm@kvack.org
>   S:	Maintained
>   W:	http://www.linux-mm.org


