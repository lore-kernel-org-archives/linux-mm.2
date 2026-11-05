Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D63606A335
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=baidu.com header.i=@baidu.com header.a=rsa-sha256 header.s=selector1 header.b=BOqvDvky
Received: by kanga.kvack.org (Postfix)
	id 0922C6B05B1; Thu,  5 Nov 2026 00:17:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069EB6B05B2; Thu,  5 Nov 2026 00:17:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8B56B05BB; Thu,  5 Nov 2026 00:17:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB1046B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:17:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C2F18091C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:17:36 +0000 (UTC)
X-FDA: 85399907712.25.4A339DE
Received: from outbound.baidu.com (outbound.baidu.com [180.76.5.236])
	by imf16.hostedemail.com (Postfix) with SMTP id E6273180004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:17:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=baidu.com header.s=selector1 header.b=BOqvDvky;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf16.hostedemail.com: domain of "prvs=md1763F0339D=zhangyili01@baidu.com" designates 180.76.5.236 as permitted sender) smtp.mailfrom="prvs=md1763F0339D=zhangyili01@baidu.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793855854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mo4tZCwDPyINsh+mtEZQ6SccSEU/b2YuNT4z9b45fwA=;
	b=w0uBgBaHzR3cpSDVYhcZ82+dedLX2KvTF1kJ/ZWHbLFNd1tINU2LSZQfj+1ZNZSh/PEhB8
	0KWR1FNsm+viClb70HQEBt6nJvRgLeQ+DFOlRnZW1Um5aNPMg9puCAlv+ipE+r39kZ6V8K
	5dMFypiPkeCRuPACvm+Br28bZb144z0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=baidu.com header.s=selector1 header.b=BOqvDvky;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf16.hostedemail.com: domain of "prvs=md1763F0339D=zhangyili01@baidu.com" designates 180.76.5.236 as permitted sender) smtp.mailfrom="prvs=md1763F0339D=zhangyili01@baidu.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793855854;
	b=23nthv0o0nwuWXKJh7iHXQHLT+ekY/u7S0qLhw1HQvt4CAWpicm9XM6hg2M5kWKRHZvHQM
	yjgMOe/3xfqM7L4jlEfvzeOfNpT652zAVftnxOwxWQgq0GvRqdujshJbCCQd91zZpKVVxi
	InN4gUYUTqKkX0jFVMB4VNiFuAc2FaQ=
X-MD-Sfrom: zhangyili01@baidu.com
X-MD-SrcIP: 172.31.51.15
From: Yili Zhang <zhangyili01@baidu.com>
To: <muchun.song@linux.dev>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <kas@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <osalvador@suse.de>,
	<rppt@kernel.org>, <zhangyili01@baidu.com>
Subject: Re: [PATCH] mm/hugetlb: do not invoke the OOM killer when optimizing vmemmap
Date: Thu, 5 Nov 2026 13:17:15 +0800
Message-ID: <20261105051715.95172-1-zhangyili01@baidu.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6773CA2D-35EF-441D-A736-BBEA4A07B074@linux.dev>
References: <6773CA2D-35EF-441D-A736-BBEA4A07B074@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc14.internal.baidu.com (172.31.51.14) To
 BJKJY-Exc19.internal.baidu.com (172.31.51.15)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1793855844;
	bh=mo4tZCwDPyINsh+mtEZQ6SccSEU/b2YuNT4z9b45fwA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=BOqvDvky9f8FlR0JS4nEB44rUqya48Xg4nmkGLsT9Rn6WbZ2nZ2wxJ/H7NfEg5IUQ
	 gnMsTDdp613hw++c/HBEzbvF3LMTKDCs0rtkQGXDxaLUd50Yoxw3Y/hfWKiVovZ7pa
	 O6ns2UvtPWKoSl9weIiOv86Xk+wqFgVodRFnZnmhvfEer0Md48K0cI0n4/xFaP/sH1
	 bzxSgNOolOQ2NpddaXDveKjqHMdPzCYsHsVwhpkN0cenkOqvsVzL8GKfj556p6XWEb
	 14lVbEZDSmll1cQgmgNP3h36xvlXKxMjtZ05LgOj8od823vcnMYkk7ICyDfM9fezSC
	 /RrSFozmjPCkg==
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E6273180004
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: obat4jcgzqsb6achhjfp964tw67bhyq5
X-HE-Tag: 1793855848-195630
X-HE-Meta: U2FsdGVkX1/jUyremiQhLr7KmtCcnkENAUxPVvN24hc6Y1U9ryrq0BUnOvxEKHjL9AoGPa8PSalQxtb5X+Z9ut/2dU/vx2tiU6MkOIcdcYr2PWb0d04c6cLMl+TDtugO68b3XRpNL8o7cEeGThCou5onDTUyP4ksdLcbHYmRNYcipmB3dUqnGoeXlAhKMUXsgsNUi1Ssx8e2lOAap8cC1+ZzgbpsX5MwzIvasYt/QybbD1nAlyK7mqgkiXNfJnQwxWV3H/U2t49EjRo/vTwmeewB8sP+tQF/Z7KF9gxABwhs7TZCrckYaDnCEROXxFOF/Ji+nbVRVMnYBexexaE0JPJoOukAG/GYHenQ3aqruGttV8DhGHtROr8EvDVrYHYicIcgJe3FKGkBGGnOBx48o4g+sAicem6jbS/W4edfGX7brEjCY5e6cdYSlc9dF62Gp1NFZopN9s2FWc3Uwi1VyfLQepCLwZhEweAlYgOChITRzOaAuh8UZVssMYYdG3VZc61FRvTTBPQut0yQD3N6s5Mxb8e/VGCTA9Q0L+I/u8UgjrTEJd2SriFSuJgRb1fbe4s4+s9oB9ocgHVpuZwSaWtLKmXQbc8PSG8LCoBAyzN6HX0wSqVWrIbIqArdhKNfpztPzdHh5gDLYMFGRRclsxKsvReytm1YfQzyNpEaI8T8bsZSP0ov+5m5kH/yDWE6aoN4b5uZ6c/Y9cQT4YN8ocvQfRDk8IUNp7/d/GjK7Z3fWoIv3X9SNETulYNF5zsE3n+Zo5H2xW8NqfFw3PGxdMW27/4w+uPMR+tlx4KhRxfDSZvt4NROCYyrv/tjCjTY0KZvJrQbFPjs2StyJbkG8tPY0DR4VhohW92ZNxk04wUWtPNiSiGETUSB9oQ7tcTuM6zUWQQQ8bKmGzG4lLTeUQqE11vDjM9Ch6PCm+Cvzi6QB2+siwlzyXk9uESsdk6Wdu64bIOa698xwJpPDYc
 XBZu3bMw
 dqEvC4QFokNFMdvnRHqp7IwVw8PmX5MMMkqAcl2y0gZujshA2ogLjFN4ZjRe02+AYT1SJjcFVbEclvL4E7gUnfXX07xp+nSojGc1HjITQ9Ch+LikiklPwmTch47QKnm04MqkvwVe45dkE+kTEEIrbNd7x1vmKKuw7MbxaWNMH4uFwucW/1bDmuwI15yoOpTTu4EdhqktpbRLhHezS0dA+CQ5SjLGDJZazF5ElTg4yzp/es4bZ7wj27jbufKtwFDLkQMSwml/3R0GkmsPKPpCQHRDp5JQw9GHY/V0wwXu68sFt0bJNcXXVjSZvs8sr/vJDy4g5elf/URcej8ZtC6UpKulojHbqEfSSDK7ZEewFDAPNvv7g0Qtjrop3YYn/R2jxLWLV059GVy2AJ2V9TYMyDoU+FWdYygV824pXZZGYJqCy+v7qnuYHudYzTmZSSonk0RADrFftWzZSPhUoj3Xy+H/Tig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-05 10:38, Muchun Song wrote:
> 
> Thanks for fixing, but I realized that I've already fix it here [1], and I didn't
> realize it's a real production issue. If you don't mind, I could add your Reported-by,
> and make it a very small fix patch so that it can be backported more easily.
> 
> [1] https://lore.kernel.org/all/20261104023510.260766-5-songmuchun@bytedance.com/
> 
> Thanks,
> Muchun
> 
 
I checked [1] and it fixes the issue. Please add:

  Reported-by: Yili Zhang <zhangyili01@baidu.com>

Thanks,
Yili 


