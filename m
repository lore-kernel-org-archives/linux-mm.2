Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F6BBC2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 07:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A77F6B00E6; Mon,  5 Jan 2026 02:29:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87EB86B00E7; Mon,  5 Jan 2026 02:29:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781636B00E8; Mon,  5 Jan 2026 02:29:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 645C46B00E6
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:29:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9F619BCDA
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:29:39 +0000 (UTC)
X-FDA: 84297085278.02.09C4466
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	by imf18.hostedemail.com (Postfix) with ESMTP id 14ECD1C000A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:29:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=UNcXnX5z;
	spf=pass (imf18.hostedemail.com: domain of realwujing@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767598177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2dTv/FNr5ZBYUYJFBjrwwsOib3XHe+T921gUuHMQXY=;
	b=dWf+eS0ubRzNJ1LktrwBpORLGZ5Q/3T2OkYoy0y/otwtHOLyofSTE7FpDWLRwOwNh/17No
	ZGCvAJtIlk3G9s6OfElf3FlF5D8inDF+9Ghuc6DXEE1rkzB11AAZW5kEXo7E4Mu0yKH63H
	+Og6GrZO6x+vnqgMlGkUpAsSZ55F9i0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=UNcXnX5z;
	spf=pass (imf18.hostedemail.com: domain of realwujing@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767598177; a=rsa-sha256;
	cv=none;
	b=a34SDr+InrEQGultRCUx9+J3hLFXwa1YjBaQ8/DTb4WbhDa6oSgskJYyL3ULYrcjoMC6O+
	ApaZIoSYTTmP1mb4c0etTLfVBGkXnbhlUOKt0KlGzxw70drffA2hP/w6HWbyqC25VZkCpD
	gvxsfxRj/ef1cRDWTRi8xnd7SFRbNHA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767598172; bh=l2dTv/FNr5ZBYUYJFBjrwwsOib3XHe+T921gUuHMQXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNcXnX5zEGPcaXvQXPhs06D1/aQQXberSNaTE5LKiKwaEvjrr/Djfy/w56aIT2QRv
	 Valu61uZCUK5b4ZdjNJztz1pBjkzXPmzydhbUeNbbkVFWpwFAFtj1uRUOhRU/vH5+3
	 KJb5JvPCnNzf4JMvkntU+npUFnlTaS+hSloytAlQ=
Received: from localhost.localdomain ([61.144.111.35])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 75D3C6F5; Mon, 05 Jan 2026 15:29:29 +0800
X-QQ-mid: xmsmtpt1767598169tnojks7dx
Message-ID: <tencent_8CE8292766552797836FEB198A402CA2CF06@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuJvoeLQeVKYia9J1U4yJYBOq+Hs3nQSkJdJy1wM+tCIbcktScox
	 NjqviY2TdsPPF77D5afaco96fcLMdjKMemSwgF+Wy9tcxENaQP0mhRYSn3e/cL9P0fn369uAszqb
	 TDUaQigd9SDOvixQRUZTYSIeJWlfL1/MWlDAY7t/DI4xBonNLkLDwKW69lSJPAY7vGPyBhffFEgC
	 OQRx+SWcy5+euka0aW0Kc3Y0ERP7czOnzPCNXzYxPqxRyeDyRZXpQ1qcOD4OP0UNcNsAKUECpy5a
	 XjvxNFBqIXnC4iwnE6Zjfh9gwLbu0xsu+J/wiAWP7xvhToVYAO3BWId2+mCKzcYeG7fD5/CMhWTa
	 MMqa1bXsHinhH4aQSNlwsboCwmblld7wR6X4KZLt6ZHqsYQr9OODQ9OfetSbaTkqDZ8nOBv2Us54
	 zP1pxcwYc+ZShobEnobfKU/hfpbUIoqRkHOgVsNRJs27Dz5YAHAfA49ZTSkoqFpMFZovJEgBO6tc
	 sxMA40/i9DoJcsxDVMHC+WmPUiu4t90+0os2m5fzXMU6bLt/ejt77c4glImQ17hpIwRk9q9ELKVC
	 TBTEXW5xjYhu2MHRf8HpptJbxIB1cqHX+Cw6AxQCSWoYKQgM0nd5OUR24B1A1mBhFSv15lnNGj5P
	 GkiZKeQDpjjPjdq9rsYyC+TATUJTSTcuQ86yo0EIGjyY3QZgNgeTR2KCcsV+5NoAWJhZvEtUwhGI
	 GK0Ch8Md1P0st+UXG7VyV6fZ2q5WhKdhQUKysMcdWuIadHAh7c7qGTYLgVrJ9JDsfSMtiaBOWrlu
	 mazaYWv4RKLICBmHQ1AXzK17uyt2CIH3S8ZquNW1HOvloqkj3QOnCLjw0lc8PBn3/tOERp3cVzKE
	 6WsPAAm/Ax+xq3A72rIDgXz5Zg8wN8PTZw2P4qKCS4OUmxCPEG3vLJsMikKoLH7nZWo5CICmN6mA
	 v50DlyoN+qCURMDmsSwZKk3pTS7/6f30MzBoJ/QFYbWSfetdPs3p2sS9xSpMkqrzCzvc8Fl3+on0
	 dHNWLtbPZmUvFhTDpF0mDWAke+0y5sBk5sLqMcdw==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: wujing <realwujing@qq.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	wujing <realwujing@qq.com>
Subject: Re: [PATCH 1/1] mm/page_alloc: auto-tune min_free_kbytes on atomic allocation failure
Date: Mon,  5 Jan 2026 15:29:04 +0800
X-OQ-MSGID: <20260105072904.1298002-1-realwujing@qq.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260105063830.15140-1-lance.yang@linux.dev>
References: <20260105063830.15140-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 14ECD1C000A
X-Stat-Signature: o876di3fsgdkgeyw1e8jygayk9kmresy
X-Rspam-User: 
X-HE-Tag: 1767598176-335343
X-HE-Meta: U2FsdGVkX1/BLhDazWImHk3xFY7QcLCzLzAeSG8wrntXVTz8KAQ4n4K0lZvLxFzSIjtmth/OepSqFAYe/vDtpVcPrPY8qXyZjKMfTFQLY2wYTCnDbtQvZu/0yF+6JhhhURZ5RPS5CXPsm8p+olb+zvT7CvYWGDEsN6l/SXEz6XUb5PS1vts5BKDlMLTcFoit/xE1LA2I6AbMRMLH9dDMAnPDgZbxHq5ScnT+HM6NZBGFT3WLn8gqP/57W55xRgL/gc0vWGupyGDqYjqRRmVPbWYdvr7lfrW/5Sx98aPPuRqSUGPzuIuPl8f9FMBuF1C82wzxWTuFKJDIIuc6GO32defWtXs0CvgOJhx5hwf3G3INv8URiTSbQdrnZgfB/M4oKo0ek+ntsNF789ljVAMIvEK6Bo63N2TQtuNGhSxN44NFl6UjWqyBcdYmHWTcaV7KBc5wJRmTXcXjiANO4vizYr4ESy75IPXsv6xXU8DE2gM20P2rUbYIbD0NbesidwIaSWfk+msyPKxKEe12JDYuDRnpgoMSzE1AyDFB+vnSxKD+H9xM5hHt20pq9kUfQKgTDgysXejcWplSy2uWClXBMKRQmROo8IG3Hw44Ii+YDXsx2ZeIwRLvPOH5X3BgG5ogonKFsiRNxOA3nC0RkSlXufWQc+o/zSpWuMKhW3JaaIaw3GF7LEcT+19cMttyCz6T9fYmiHfBzsz6mgsTqF8ReZOkR48VI5pqFkoFcxT3FhpZltPKqFpqPg5e/xf2mtTpCViKlm0RDaH3bAWc+fRu9xDmXq2y2cnjYj8fy6jQr/9qGZ17RmUOyNTyJX4brptLzTk5fP3SSHAcqDNQAKt0hBnB2ZVzsC8BgsWxUMVx4AJ131/paq7CoSETHao9uBzF/6/N2yWOOPurTkfU6v855Guh1Ag7dzPd4vJepe+eNAsjb9czEb/8KoZ8TzaKt61OVaY4a6+sSmf5Zq6w7GF
 hTQ8gALL
 2yGJNJm5Votq5MBPPA868q51go3Zpp93vyUUNGplLsAaAUfPUH/+PYMsulc270w70KaOcHepiwVd7XnzSrMzRmg2lov3Olh/kIjrvDPEt0l0Rfc/BbElth821EsJg/s2f793k+EzIWng7DAGouQpM3Kp5aTHKO1S7VCWjWvgpA3xrVGAyK7baSqYFbz0tP/X8cpxvYtTqaHCSs4ejzXOPSjEBInvgJ1dC2RyPROP4IWLFF2YfO+/B+iMUVOsH25BSS2lpggzktUstDRKefeouMFQVZVwfFOKtD6QbQ1eymhlxl/wMPWYjMY1M4qdBZozRGYJ7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance,

Thanks for the suggestion about using watermark_scale_factor instead of 
min_free_kbytes. I appreciate the feedback, and I'd like to explain why I 
believe min_free_kbytes is the correct knob to tune for this specific problem.

## The Core Issue

The failures we're observing are GFP_ATOMIC, order-0 allocations in interrupt 
context (network packet reception). From the logs:

  [38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC)

These allocations:
1. Cannot sleep or wait for memory reclaim
2. Can only use memory below the MIN watermark (the emergency reserve)
3. Fail when even this emergency reserve is exhausted

## Why watermark_scale_factor Won't Help

watermark_scale_factor controls the distance between MIN and LOW watermarks. 
It makes kswapd wake up earlier (at LOW instead of closer to MIN), which is 
great for preventing memory pressure.

However, for GFP_ATOMIC allocations:
- They don't wait for kswapd
- They only care about the MIN watermark itself
- A larger LOW-MIN gap doesn't increase the atomic reserve

Even if kswapd wakes up 10 seconds earlier due to a higher 
watermark_scale_factor, network interrupt bursts happen in milliseconds, 
leaving no time for reclaim.

## Why min_free_kbytes Is Necessary

min_free_kbytes directly controls the MIN watermark — the actual memory 
reserved for atomic allocations. Increasing it immediately makes more memory 
available for GFP_ATOMIC, which is what we need.

## Alternative: Hybrid Approach?

That said, your point about side effects is valid. One option could be:
1. Increase min_free_kbytes for immediate relief during failures
2. Also increase watermark_scale_factor slightly to make kswapd more aggressive
3. This could reduce the frequency of hitting MIN in the first place

Would this hybrid approach address your concerns?

Thanks again for the thoughtful review!

Best regards,
Wujing


