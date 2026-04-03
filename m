Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B3E7D7308A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 03:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 446EF6B0005; Thu,  2 Apr 2026 23:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8186B0089; Thu,  2 Apr 2026 23:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30DCC6B008A; Thu,  2 Apr 2026 23:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1806B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:30:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB24C580CB
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:30:45 +0000 (UTC)
X-FDA: 84615817650.17.59033F8
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf22.hostedemail.com (Postfix) with ESMTP id 745ABC0002
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:30:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZfHhs91B;
	spf=pass (imf22.hostedemail.com: domain of zhangdandan@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=zhangdandan@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775187043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eyyeNEj4Gf9KRJdPSLo8UpBkwbq+VEUox43X9jfZIHM=;
	b=IIPad/qNerGmOmXHUB7QTmq0mYSE9hodh4ujct7xXw/UDsQWHBmt6l3j+kZ8HAx3Q7fi+o
	n5IHJIWv6d5ZM0fNMWQ48V1GIqRCbm9ThTMaoMHbyxWoh8DbQK855Nb3M93kovfSn32tbp
	VM8+P7bIn9YvYXdxxYqm0ba2VgXMkWs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZfHhs91B;
	spf=pass (imf22.hostedemail.com: domain of zhangdandan@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=zhangdandan@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775187043; a=rsa-sha256;
	cv=none;
	b=nImTxoOoUdfA798iBiR7YlkbtZAWZ/yU9zR15syUJ2nZNMMwsCbZ2EXthPSskXJnefz0Qk
	3BqFJXC23lWfX+jMifuXSGfJwtKyYdVTPRC/CBFnnbN/cs+/qT54Hipj6SlfVdW8/mRQ9M
	FkFFmTfq+X9AU3XQ871a1NK3pm6mvgI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1775187026;
	bh=eyyeNEj4Gf9KRJdPSLo8UpBkwbq+VEUox43X9jfZIHM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=ZfHhs91Bp2ENcP/blW2Jt+bqidaI2YGm5DFGvTCabLLXkfyRNDzSAC9U4ymaOBT6t
	 K247f5FwzmgW6n+H8ip8i4an9GtM/OTX3yi3XKDzDsi8wd9hDBInA0fNXWzioQ7eUP
	 q+1bF8hulnUQokplPki2uYxFYmIucpCLQqC62lXc=
X-QQ-mid: zesmtpip2t1775187019te9414183
X-QQ-Originating-IP: gSwusCOnjLyaEM7DTh6hBqGmaolhi8+GxCpgvXVlV2g=
Received: from uos-PC ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 03 Apr 2026 11:30:17 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17905748780237733269
From: Morduan Zang <zhangdandan@uniontech.com>
To: wangqing7171@gmail.com
Cc: urezki@gmail.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: fix KMSAN uninit-value warning in decay_va_pool_node()
Date: Fri,  3 Apr 2026 11:30:17 +0800
Message-ID: <DFF3B3301CBB8797+20260403033017.23370-1-zhangdandan@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260403025614.2032877-1-wangqing7171@gmail.com>
References: <20260403025614.2032877-1-wangqing7171@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: M4IGCaTLe0Qduh6c2pgyZUFkdPtWz8EyDz+Zhv7VL8IOmJ0XjO/JTuR0
	+1LvYdZ/LZb5PAEabcxRVka93dVR3byvqa4OrHz6Xbf6zS5acbrYp6/aYgYZTY2lqGvnUyn
	Moo+v/MXCNdMpQN1uK2rkvq92L3QRXh5ZOEXnLm44MDMbs9fUjG81yzJFdUz+Cc/TteYFVp
	chcUjUlyINtA4BKG+uZmlWMJsdYr18ddZ/T4soCF9ViH4aacU27+tSsS4u5UdwcUSBKflC1
	3diZI1QkEh4CLTVvNQPt9quBZ2Onoq4GkoLYzN9gtM6N16VrseDkJPn42s+bBG7J2EpUvzi
	lo1Tc81hN/RAfOhx3SY44Wwylyn8sLm8ky6jxG0wT+MdpfQKyjpE71se7wbHKPXB0j0DCsy
	KxmSxQeRt2apmvQZrpXZh126KGcQa921ia0qE4ADCPqzKKgp47ebWszIkbvun5/VhXp0/7w
	q047RNr/dE0vaPKanXFWNnUHUuLUJdgqyXW+IhmIjfTpA7JZ8L3Mqle9WwOU4BgZmgETrJS
	I4BZ6OeaKLTZUPa8Stp05mFWV+PCrApEkFp3K2+FJSveJuxBQGcLi0Oy0uZTqg8JwWoe8ZS
	0j7bi3t7SoSRymXE4wl5jwrClIuVoPE+qA5HEqIZrhb3qwhFU0C+rKLFbN92bHprDJs9I3M
	c1RMAzJAHW2KFxoOOjXyhxus9Nyi4hPbrzhWH/5Bu0xFy98FS3Mu+i3rxro32+l7uKDi+Hm
	FEKSqXIPaTA/Fz1/MZu1NkM1uZx8bhPsKlU7K5qAPBHYxt/9/OronFa1AaZO0BBrjcpSIeC
	iyUTyzkyDYVr0EFqgIAwrBY2jiy9c+tzyAxKc1PnsorWHVOJapDw6/tm23wilZ9vxWHDTbl
	BldMwdOe0ZksiJ5MXfzKt9LSTWcw293gA3MqvvNihIV/u1UHj9nmCB8RXDgixSlboM/We13
	VodICGxwdaYXQolRSiDyWHoJ8KwUU+/EIF6Lm/8r1Nz9wLbO5RHPbEteLMmZs0QRssHBsbk
	TuwBERcw==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 745ABC0002
X-Stat-Signature: 6dd3sz88tj9n9kkpirtyikyroj3dgs7r
X-Rspam-User: 
X-HE-Tag: 1775187042-421855
X-HE-Meta: U2FsdGVkX1/EF31vJA6DbF3q3dXi4sxNKP/QzfVC27TjYoc6mSJqnoSkQDbh9vSYYUXTPenftvmVga9km3LW1Ajzaw9vArxf5WPo5f6S/IUIhtM8A8cKuuXY1RusBNFllpa7itsJpUlK1zPZ/+fjtaCcAofkk4AMTy5e8xAfSTD9/rvY4tjBNT+cxTPYVuUcxxsSBWjzccl7e3IuUp7Ncn9YsSAE2ce1YTBQsw+ZwYzWUcmJxy7ImrNyLYoX0bpUMhGz/xKsaLP9CtR4caNpdt4pf2Gk4Nwde5VmshCWcbefNoX26Y4Rd4cn6BfQ/9fG9KFA8KLOQMfqHw6flai25aOvWNUxfiv6CE1/JmP1adr4h8e+HG+JueH9BDH1XRbGUrKWA2n9DCE7/glZAq/I+9eNTNraUEV51BUrLiop02h2dBG8nQpQLZQjJQTFjrE+zhXYSd/X0sOqr+Er5gdUKUGNWSw4R7k0N6dKRKwCPigXndO7hq0I0asyh1fcSkUg0RRD0nfNvNNOaw41w166OhR71hATD3O7dDYAIj4zsQP2zaxIytx0OKDHlXN9R/fJGCvvzN/K1mDe5ZLRLALp63oWCGqwNTWWwCaKDM49FplkVcQWXc+O8UR04LhmTZTsGLlDM4PpjOhoisrH8anZvvd90TqVFB5jbzh8KMhLIErxQSwBqhHKBOrLuzT90EF7aXIW0kf/Ix94BZ/W+DX/hQVEhn61yKra6VGEVjG9FsMZlQtmsnIUd0887vb8KlleXZLYYKz8dNQWBFpFMjDSVTPdzeWycqjRIsCY58rKm3RQSf4FnIN6+hvZRA4TDtWs/hSJ6LUH78LgqMvSslc8l9K3gMVBbpQbF2C37xIQDPH0myyAIlLsLD+a3TuFhqsLjkq/6xbJQLpHBisezN8TXupTSVzqn7jG42LLD8E2+INP1VbG7/pVe2qJOGLZ2DacJsN9Ykf7ylST3/mGKrL
 CZAbnEjT
 Cuuw5B1ZJ3CNjM87KYw10afZU85jsMPH8HmpS+vQcMl6/gYDpOYLijBIrGP4TOBM4VpXFoubzXctuUh4nexp0xdIuJjRhICjT0gKp7Ff7C8pslNRG5qr75eAwmfw5XrOUfLChvRIOCZldDE5fFPUAkfJ93uexuMBYJ4pbdXSF36SzpRsQnz0BFg5q/e1clg2qeWyNengtdm0rouudd07Ih2qnlTLjcMyl72ewJ6GFat5Z/sEcTERFz1uMFxytavwIpN8TD5D5SZA3UPKbA2wj2upCZy0JnC4q0SnFJTINcNjnqxZXEBU8BGjyT2LuVWlnmVjK0q0u/njsWaO46//Z3B0diPbpitbTR0q7GH+mGXemtWbd9dT8A7bi3eW8eR6l/+OxckkR8F4xSh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 03 Apr 2026, Qing Wang wrote:
> First, va->list is inserted into the list_head when insert_vmap_area()
> calls link_va(). However, if find_va_links() returns NULL, link_va()
> will not be called, leaving va->list uninitialized.
> 
> Second, even if link_va() is called, list_add() will still invoke
> __list_add_valid() which reads va->list fields (prev/next). Under KMSAN,
> this will also report a same uninit-value error.

Hi Qing,

While adding INIT_LIST_HEAD(&va->list) in alloc_vmap_area() would indeed
silence the KMSAN warning, I'm concerned that it might only be masking 
a deeper issue rather than fixing the root cause.

It seems that the uninitialized access in decay_va_pool_node() suggests 
a potential race condition where nodes from a concurrently repopulated 
pool might be lost or the list structure could be incorrectly overwritten 
during list_replace_init().

Instead of just initializing the list head to satisfy KMSAN, should we 
consider modifying decay_va_pool_node() to avoid using list_replace_init() 
which might drop concurrent repopulate nodes? Perhaps using list_splice() 
or a proper merge of the leftover VAs would be a more robust fix for 
the underlying synchronization issue.

What do you and Uladzislau think?

Best regards,
Morduang

