Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83481FF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 07:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CFDC6B0005; Sun,  3 May 2026 03:41:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959B16B008A; Sun,  3 May 2026 03:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848326B008C; Sun,  3 May 2026 03:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4FE6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 03:41:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0BC91C08A2
	for <linux-mm@kvack.org>; Sun,  3 May 2026 07:41:17 +0000 (UTC)
X-FDA: 84725312994.09.FF02B4F
Received: from embla.dev.snart.me (embla.dev.snart.me [54.252.183.203])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9E3F8C000E
	for <linux-mm@kvack.org>; Sun,  3 May 2026 07:41:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=dev.snart.me;
	spf=pass (imf22.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777794076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqhWSDCINRPUJBq0NQp54xI0NhCzqPhP9E4SCq7zTsk=;
	b=zoMVJv8yk4ee3RRufhYN+zPXOSlzv/dGqvfR33ZZDiPnZ0//FnYhof2EL9dn6TxVw0YhVt
	QKs09FDkV1g/Pn6xFZDMykBAGYFJkvV2D66sHdIHr33cF84fDh38QdAKgrtYPRMX6a8Jlz
	o6ZHxQnSN1wA+b40Of2l4T6dfpoToVE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=dev.snart.me;
	spf=pass (imf22.hostedemail.com: domain of dxdt@dev.snart.me designates 54.252.183.203 as permitted sender) smtp.mailfrom=dxdt@dev.snart.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777794076; a=rsa-sha256;
	cv=none;
	b=ED+gMokS3YyEA1wTV7uDRA+EYkWmGg0Z+yzwKC5eMzijh+LyDSXJeDkC8bKQmKIy1ADSTg
	L3NM+h+0s+0vod8Q0WQJZx8pM3XvGlfzDdGQ2dHdxnwlNWEUVatSLyj/jY8n3MHhTJGgUO
	72XL3ucJtT590LmyVIrVkK4n11Gbayc=
Received: from embla.dev.snart.me (localhost [IPv6:::1])
	by embla.dev.snart.me (Postfix) with ESMTP id 26A761D490;
	Sun,  3 May 2026 07:41:09 +0000 (UTC)
Received: from [192.168.1.18] ([182.226.25.243])
	by embla.dev.snart.me with ESMTPSA
	id rQP5MRX89mnzmQAA8KYfjw
	(envelope-from <dxdt@dev.snart.me>); Sun, 03 May 2026 07:41:09 +0000
Message-ID: <b6c3cbf5-d8da-4157-9b75-918633bbef1d@dev.snart.me>
Date: Sun, 3 May 2026 16:41:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] [exfat?] [f2fs?] memory leak in __kfree_rcu_sheaf
References: <69f6f8c5.050a0220.1584b9.0044.GAE@google.com>
From: David Timber <dxdt@dev.snart.me>
Content-Language: en-US, ko
Autocrypt: addr=dxdt@dev.snart.me; keydata=
 xjMEYmJg1hYJKwYBBAHaRw8BAQdAf5E+ri1XLtjqYbZdHOyc8oS+1/XJ5bSlbx5WHXmVBZzN
 IERhdmlkIFRpbWJlciA8ZHhkdEBkZXYuc25hcnQubWU+wpQEExYKADwWIQQn/Jn96EMUaIoF
 X+T/ldyyrZpWaAUCYmJg1gIbAwULCQgHAgMiAgEGFQoJCAsCBBYCAwECHgcCF4AACgkQ/5Xc
 sq2aVmjJZwD8COjPlUwccrlRvbNQ6f87DWchtYO0o8W2DNRM3RLps0EA/jEhIbRV6AsyC8jr
 30Ut3aJ3/mO/6G4sLj7OvkEEBH0MzjgEYmJg1hIKKwYBBAGXVQEFAQEHQFpgtIgaByv9lIEY
 EmpavMO0pYjtu7TMJynwdnGYkN9LAwEIB8J4BBgWCgAgFiEEJ/yZ/ehDFGiKBV/k/5Xcsq2a
 VmgFAmJiYNYCGwwACgkQ/5Xcsq2aVmhFCwEA0kM9VyYB4bLCM7+SuXUUH+5Ec99Nj4RXxFad
 Key9GuwA/2BZK6bNyrLSfEk2JDRoskqf7OIL0wa6JOD5SrBnMe8E
To: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
 jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
 syzkaller-bugs@googlegroups.com, vbabka@suse.cz
In-Reply-To: <69f6f8c5.050a0220.1584b9.0044.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 85duhciknmq9kpfeydsdyk9tdkntxuda
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E3F8C000E
X-Rspam-User: 
X-HE-Tag: 1777794075-719413
X-HE-Meta: U2FsdGVkX1/bHvx4syoTM5AGcDQIkOh58hCm3DYASPm//wkh5CuZcHrjtJUWvSf/vzsp59MpxKbvuYqDN6HUdyYXlTrcYT5KRil+6kA9VIg+x0XiOzlShjnnxH+9JIgTy4ZiaFEWQjnbmHv8GwFZE4hDgYMbqsEDZ+cjXP6QU4ibnNttc1sm+W8RR+skFXSDBW9V4aQXr3SlcKuakgrGKtwSLgPCnm+X5vqxWFo0sQyy0LqkWrLbvJfzOO0OJMI6XT43OfIamXZvbf17vmHvrbPW09DdoblBzv75aAqmEgXpP124km/Sx5RLb2hyJmUoDQzXrKhtby4tMIMXnjAJxdpsaSlKDxy4Y+mNWbLC9eYHmYXLZw25t5SB7nOuQKD+NupmMqEBU8wg+gGY3sGwNTDLvSCv4ANI5hr8cp1957CP7VCsSZxg2rEFU6MILAW7PR9kRVaAlT/BeyAqxAmmdNniQ78z4/ezQfQTtmdfwZNdM+fkD20Ql35Uw5tFOc+69XBidE9xOtj0ACMBBPTME4PqlUKfo9E/9Tf+TM5rRkHro3IYgR8l3vZfOqw771QNZ566Wu0Ng/1t0xcddWbzCDMWdTTq37hCJF+3nFafU8TyJaHyiUuMinyMk3QjZTDhW/2Ni4LF2lJvIp4Q9/e5V5/U8dMi1g/n9Fstje2OWDFoheOwWM2pDCpdM4nMxZhZt4ejBz21GnIkW/ugU5qWJ1TdaM2luU7fi3BJl8sI907lNuRXz23JSzl1IvA2o1+sxVGvckmZlN3kqoTylMCUMe9I72Eg0r/yuNU/agvHTr9eaz/QNVP9Pv2wz3Sp+iwsas3eBt1pRk9SoSBumesQjQhHAipSQy5lS0+AWoE2iuW+mCwm/yTv9V+rDZvS8t0hUNAqEsH8kU1jzoIa94H65QDVrjGPq2A2q+UG7l2jkGejL9my4WlSAlsJBrKmfpWLMaXvoG9oDzlOv0xS61G
 vff65sj0
 d/iSfc/VOfZ/4qOxp7/Vu2aQ9yaUicr6fH5o+MFN8AdCcqG4d8OaRIrv8tkNDLS1tLMHuh7kL+LRGlC/x8xy/aOswFdjmAWGKj2KEHAnkFfnsmitqac8StdEkBxfv35Sjd0ZXOglGZUAkm9TNMvPNG52lRa+I+054zrRp4IHeIvxNbDrzEGX1Veihy5/YrZChUs44mpn4869blhpQayvFO7aPZZvHW20jwJZ4JVds4XuD2uCLA+tmaf3HEs0GvzUhKsWoIWsNLMrqkH1DnEt4HXLmyjP3fW4kJBzshUqnFldYQlbpZr+7sy2oGBJ/jdiT0F/yaQK9tafHj8oMUSWohhJGYTHXAARxvcQpPm+Ca+6k5AdWDTRb5uCbDr4xCcETx3kFDl6+VT6luh4Z37fXbOtAe3GrEQ4jkdVuPuA+wSKx7hEmjP2t6BTwKFlXwWpUb2v16IMyQICHiIAyTuFnLJxT+PaseBTI0ZVCedpxDU4eVI15rsUOhWpFXuhFBAZbSfAx+rslXyIUPqG8Jn6NmCkKI+kncO8EcFv0Cbp2zKSdgC4T86gqKjiC3NPir652xqcbIGrGwR64vdjO8fFZLwpbDSbWG/ZNZ31QaEm8hGXTg9oRL/Fxti4Bu5sycK/aV7dXrOuQdlOrSP0bv7I1yHlMtMSsaiaq9uHW4/VI+IVfsXtiJs+Du0CphZSEmzzu6VS90K4I8gR0HwbKwKQlWVNtouw7ul+1AyH8zwdeNYpJbVEdrUtcv9u4fWwcEJMMzr8e5KSCe0R4Nb1dm5M+ANg7R9lMOozaEbwP+XH7S2m/mPDUR/EnIlYvlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/3/26 16:27, syzbot wrote:
> Hello,
>
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>
> Reported-by: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com
> Tested-by: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com
>
> Tested on:
>
> commit:         66edb901 Merge tag 'v7.1-p3' of git://git.kernel.org/p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11fb7082580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9645c21cfd1d3e8f
> dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=17f2f326580000
>
> Note: testing is done by a robot and is best-effort only.

The error message might be misleading.

 1. the report is done after f2fs attempted to mount the corrupt image,
    not before
 2. f2fs exhibits undefined behaviour, evident from the fs attempting to
    do I/O out of blockdev bounds

This might have been cause by f2fs corrupting memory in which case the
leak report is invalid.

Davo


