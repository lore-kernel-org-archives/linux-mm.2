Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE22CD4F46
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 01:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F596B00B8; Thu, 14 May 2026 21:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7C46B00B9; Thu, 14 May 2026 21:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDEF6B00BA; Thu, 14 May 2026 21:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2336B00B8
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:18:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12F808F964
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:18:31 +0000 (UTC)
X-FDA: 84767894022.03.6DFE59E
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf12.hostedemail.com (Postfix) with ESMTP id 52B7C40004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:18:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=E7OZSQaC;
	spf=pass (imf12.hostedemail.com: domain of niecheng1@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778807909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlIgxv2WOkhd9BA7qgEROukyQZLnqCDxFPXBnBgpkxk=;
	b=nEgbo1hb2UeI9S8IgovUMU3nkW7ScOOa83ZydOVne97W4IyHlG48Vxuzk0Tzt5q7duQFpq
	E8/7Z1o25e0Qj15gItOMpY0duj3X/mOPI6Y++jf7Xp/AaHO2UP+vYXUqdNW4Qwg2c/lb6m
	K2X77pwqCAqzM5dcoL4pO9K+AbFb0L0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=E7OZSQaC;
	spf=pass (imf12.hostedemail.com: domain of niecheng1@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778807909; a=rsa-sha256;
	cv=none;
	b=I5AxIbqrjvdmXbyGyAcx5ng9l2BaV92iAcWisos4hI1dcDoIID+3jDOivCu7aQVk7uZExP
	Q2xVMwGC+evSc2RJbuL5Tz2dKYyhoWfdxB2kOJEtxASRLciC0Gap5U8t45a1Kg8Mrj9nTx
	369cXznkufbv/FCMDdjdCh41GITyiyM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778807889;
	bh=WlIgxv2WOkhd9BA7qgEROukyQZLnqCDxFPXBnBgpkxk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=E7OZSQaCZ82ptg971hBAahqjlK8pUNsszyziGpr/+lB4YwfFE1ZgRaXGcHerlK20U
	 AmXxpJosUPSBEh4tuIG3huvI9KOMLvI82doXQY4Sc4am8q1HXriK7niTk1li3keHwg
	 pw6tlMQT1FpRSslPSVmhwOPheNESXLDqID6xNpqQ=
X-QQ-mid: esmtpgz11t1778807875tf5d1f439
X-QQ-Originating-IP: 4enGO/YdavgA2rkJqVQxpQ6Y3+iWq8buDIolvawtqy8=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 15 May 2026 09:17:43 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17802444263812327698
EX-QQ-RecipientCnt: 7
From: niecheng <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	kernel@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	niecheng1@uniontech.com
Subject: Re: [PATCH] mm/damon/core: clarify next_intervals_tune_sis update path
Date: Fri, 15 May 2026 09:17:43 +0800
Message-ID: <60CB7FE07929DFDE+20260515011743.3476164-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260514234510.123948-1-sj@kernel.org>
References: <20260514234510.123948-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: ODmRr9XAsEUIewZAytL2fcXlbW5VEZcrNMx3fazS9SD2LXSNGVPSKwCu
	D+4SrxJ1OTObGfekBvo+kiYqE1D/kTC3o02OOy2J9GwJO1UKEALkWem1e2mnsYq3nf3eXeX
	bwvBuWlAxMIckPICH4SLDq6m1tg6OG4hzoSaRsLbuBSIpUkWUUw3fUpZfpYBk7DceGFTtTt
	VNAx4gRGEx+Ud0meNAl6r/m18FWzt9BE8vbsQ0dOowPpptS2uUk97EGK6XTGGVGb9ZwcTFd
	N8s8u9pCezGmF1yFXT6sSOqizYbNXttCOooMKVq9hB54I0pTEqtbeKmiT8BQCrNp43iYk9x
	dS02AtS4f8lVZZYgE4jjUjqDxUnGynq5PfOc6JNy5APfaF8omlKOILplsa18PcpUhc24d3M
	CuvXOoHqEkU8bgIQCrpObMWMRRGv87vPF2B2KihM++IurIjjxxSPf4N1LlNesRHeOZYkZDB
	0oW7Po4KomXjxGjKP6f5KBgUaudeM/7PeJk0dsASb8YCagx6CH1ScUkz8vjYJL7WLE1QWkW
	wQsxJTV+zg4sGMhmaQPA1Yb1h4VlGU8qvJsypsipmWgGHuIDCe++6CEXK8bIexu7OphlnsT
	f3Ymlfk8QpRsx+xwb8cA6TcewUoUXLvWEBIhQtbIBvQkR0Yvb7lvJPJmJUu3IKWdr/PMTAS
	QO2QvPtWWqkUqbB/gVjtrQaydtTHXB4GEJ2xGdcFXVPWx1jcHyZprFZkiVExGp4hHmC+rKS
	XE6+0HxCqwjRrrA26fcgGTBuruiEXsygaGTbgDP0Am/k7y2lrDVx0wXiqBT76Yqe3C4L922
	+/9/6HXVDSdjhw370Ytqvaf4ya5gdGjZBLx3F67x17uLP356TZ57NC4q+Np+puNCT/u/Awq
	xMsyfOSH0mSvqziLixKYGnaekRiIGFI+dNAw0S4Uy3DbhO/J0oRAq3wL9v0Gs8l6xm2escL
	RbDhVQ2VZsmufUynPUVEg0t5JHEWEhZbOD3mlP0L+yprgAdnte6Lod3JB8GAxCaNVxdh0sE
	84KNKw1XEw/1ak32F1LP10SqDf+ungtAFeV4wCE9zccbRwFXIf
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: 8c5yat5kjmrb1jguduhyr9msyqwiz9n7
X-Rspamd-Queue-Id: 52B7C40004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778807905-396055
X-HE-Meta: U2FsdGVkX1+SymPr1DIWfrkiteCd6BAfIG/2+3rvUebTMwi2VPrKRcAn/gux4nlo4CDKiNw0K6yU9zpEFzPlqjUDffwaUq1pusrBjOtz1G4QcWgqCjGJFpSqsfS/KQOFiD8F3DdwIYxX2/itGrEkJvJcLYrPW9d+9FzOhH1vh93gxOda7R72dXWZbeQfgFpC2fy3MfqFWuANRUI2hFtsIIH9DoTYCjRQE7dzJjoD5alNCcW6sZDLi4A9odTioYT4zpwroYAr7Kr0QwsHJLxyiTaWIdQjx4C16LaREc9JkNkYzqeBqEOOZ8LssNKBhol7Y8rozwMgqzIR7MncCLkX2KQubpvOA6rxnmu0Ynqt2PjYsHA7zzZpkLqqFgz6hCMMGbQvvc9xhxKJ3IoYG7VbAFiA+wdIlDikKeFuaOxi2231dRZIhWqk/6pbeBPntCq84jnwHE/hHFvKzCn6+l43fO1yzjf5WHP+MD6Z0z7x6Ww99wswVH0vWRF+3JBVwcqP9WNeQLt7Jnt27d9wHKU7oTULinMSlQVGq8ij8bjvd7I9RSxpOrYrQxWHhKAs3PUg4fgn44lNZFSm/r7qWIeRFVeSuIGfZ3tf6dHaVe2Qxf+lXpne886R/wuO04Rqzn2Nb+uO/vZ+Td8R0khOR1Ed2Zlw41kcX2z00hzf0QRRMOeHr6qF4MJKAPdzCIsod/3VuOBQZWlfLqnzL84MGOeN8XJMYW83DVeYuB/AmOkO5OrszrSOhqR1QvE5g/VEBDgqI4a8HeITIUtXSZoBR7ml8v2OvZti6VHkqttLMnvNQs2L1QLR/zlYkg0isMMov2j351kHWxrvv4QnEqxvqW9NLIJeb6vT8SFgCIQhAf8i8CZHPMyZgdUVC3KBY6nZl5jGFJy82KBwMBcZbNiemepMndm7V70oFHUwevBMczcIMajIwLBhacY4ZwXOUGt5EgoSILyYbZNbEvtwSF8YoCP
 AJWf/l66
 LBwbdQd6hJy72jQ4qD9YVQuedJSiaCuYVqeAIa8kb3tClexmqp/CVzDGvJfGgpCq3+sXuXKV22bCUrUYmyij6JzKn330XM04j+r92i4uAEUCOErTlQqUWp2fwBtjRQCnOE6hPnVIgb8oAqggTYDC+0EBdgFgBSPI1Y3xUDEO5a6ZZroHGg69A9qyCEO2+oxDMOqqA/bUa/aTiV+CDs1S5SPmyFAPvWsJVFK0t4JZRWHOe/ZLXtXArWy4VDgwFTHvbELvktwtlwZyoeae/wlHnFDM5rvXaMc0p9KImuSyVmMYZ/olGOhr+NkZO2QdIyk8b/SG+6Szcjzuk7e0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Understood.

I will follow that from the next time.

Thanks,
Niecheng


