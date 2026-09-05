Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0472CC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 11:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7E16B008A; Sat,  5 Sep 2026 07:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1622D6B008C; Sat,  5 Sep 2026 07:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C8E6B0092; Sat,  5 Sep 2026 07:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D76996B008A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:39:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6DDDA120332
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:39:16 +0000 (UTC)
X-FDA: 85179512712.07.B7EBB81
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E540100004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:39:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=YLL0eOp9;
	spf=pass (imf14.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788608354;
	b=5tErIwwMHh3ZZsk+pRaJYyrGlsRpkKfj/qIcPxe/z9nsGDYKGWNuD0OcocSWL6o/zFTl+4
	5JYffVwlhS91FL+CU2cX1LKnbZEW4nsU5N1aTr2+AOqsSfFnvM5m1Iy5jzJpAVelNLlt7d
	pRCm+9C1Ni5vjqBgP2e2qawfjOF0Vps=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=YLL0eOp9;
	spf=pass (imf14.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788608354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMEz9anmh29niSjIZwxuAScbscWTfZJBraDziYakze8=;
	b=hwUqb/DifoHxkInYPtdhP2hcuANm9kqU3E9p16BppueP7Y5uxlZYtNm+MgzOV6+vLnbnRQ
	pxR7dO363JAbn0ZNO3S9JZtCWfF6cvY71m/h6cWr6HLMvaDqKbfKAEhckvYo1eJm2oWiox
	xSXL7cxYQLXS7WFJmX3sTUESWyuodaY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788608295;
	bh=lMEz9anmh29niSjIZwxuAScbscWTfZJBraDziYakze8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=YLL0eOp92KfDzX5XrS9yzVrZ0o2uNRcrgBHhhFlKuk+tJ3bhATkgwJIncM8IrsOTN
	 0fsUWMengTy/aKtkau4Euvexf4KISeYwHnyChmesVbVNElwAcxQp+vBLe8nyuj7jmf
	 IvGTdOtFq0RSizk2NHHzZgkOyO8wQQIbprg4dhMY=
X-QQ-mid: esmtpsz20t1788608293tef3e1836
X-QQ-Originating-IP: 27AhG9p/djI9g566/XZgLSrP78IAGNRiW9q2swTfNdw=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 05 Sep 2026 19:38:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13578306995493492248
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: ljs@kernel.org
Cc: mike@recall.ai,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com
Subject: Re: [RFC PATCH v1] mm/madvise: prefetch private file COW swap entries
Date: Sat,  5 Sep 2026 19:37:42 +0800
Message-ID: <2FDC4C32B782E1AD+20260905113742.2201351-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aprY-BekgYlsK-Y9@gremlin>
References: <D758D1DD4372AF8E+20260904100919.2139680-1-zhaozhengzhuo@uniontech.com> <aprY-BekgYlsK-Y9@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: NZoGRXcpWFb2hwuvk/1/X3epi2FQlVQXqKx+HgMb/SpkhwUMBLEA7r+n
	kLXsR4FAUKp2BwwXjIHSKdiSqgPrwm2gtcMwacsFVSVqW8vFXnsJ3mwVpohgKlfeXuE4Odj
	a13a4SPUwuA4NbJMHs3CsibOuogxalc74gAzHdTwZsd8HagXvtu9F4Mcm1KDssOj8fJUfql
	FUt0S/TrgdWN5gn+5XdHxm0n7Zgg4NgwcnmmxLrK3MRONvW7wjjwPrrXNJGqn8xRiOCjk1i
	EKgEVYxs/8EGnoWMTBBdilKhP8+fsFhNp0vWxwUhhduiS1aQC2xPM0O6NO6HSd4x/H2zi5W
	omJwmfAdqEm3XpNyLGR1AO+5qDqtlLFzQFo9bJszow/CbKwicL2kcK0VXv7AqaiE3F3GXOp
	OGLKbu3avGBrveBxCbwB8tv46ihv4s62aR621Aszy30fa8zwe3jDG0S78vugbhQnqBDkHFB
	9jRsMMrXttp1D++/50X2kg+45D3u40DT/wKm+xZACRUMm2QBifahpogFZgffDhNzWNGA7FJ
	hGRFe7ae+jw50Y1H26WljQC8VtpQbOkzwvwtjpv6KRXxiZ+IR1AV/ivpJ7vbrb5HKoeAyaa
	0qsvrm7GkSxTeBm9c7ZKLkN5ACAT6AkQ+XodOXRfM3xDC/12Fyjqd45W6scz1sK+idtct3m
	zc7HmXFa6Od/SwmB8ZD6ycB0iHbDnR7oUTlJmW+iI3tOBKkDmYxBhsd6WHCk18SHUgAUkIO
	BvwJIHM1B2WA5vLGTVs0O7eEXy4cevUUrz+2PtRE2SzdeTm5ez03kNq9XVwTWOn5PubdIp0
	RwBewKxZtWL5uODPxmXagC9LB/gvJ4HxSwt9Pa7Q77zb/FU1kLBjm64b4RR70/l2KVv1ZW0
	fEkzqqtsI7TB89hHaYKFauBiZArnfBUd+KJ/5fCUn0lPDZrjUU9+o1IONV+uMxmq0EG/XWA
	F2hLvuMmt4YYWGiF/AEBtDdK9MQTy19LNb6lsmRErrwEthAQRcjN+Mjn93kz5q5oz2gprRb
	w5QU4l7CLlkJVAEVUNEw8XdB9dcZRj3cUSOFnMQ85FzsTCGlEr+2/2eDsFEMUNFI792i1OV
	vJs3n46qomq
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E540100004
X-Stat-Signature: kui56849zsy7ri5go5kxyfnxeowmpab1
X-HE-Tag: 1788608351-223585
X-HE-Meta: U2FsdGVkX1+GwTbeYEGIGfWfepqNtX26Zf3jBMKEDPW64yi2vReWKgKcWZ3VhX3yDPXYcgI0W+t9uiOfJGWbAoDAYp9pAvNMhPH8S4rrLEwDkiJKoSpkVmT0tXyIsdpU6EQJ4sQT8ELG3jDWcqDV3tYJ+Nz+foaVIcd51lPhLWWA2dXp3j1aGtfDD/X/JIu0r0hjRmq+4Cw7OcUPqwkNL1nINNs+p0UHNdMnK+Os05IuRgjIbb7TY7Xs86tL57nSAkmXtK18oRJc4dM1bRURq98gJBw4HF6US8FCRvsbbQC3sEWxaZjyyAJ0LfAs18IVQ4DS6EX0p0eTVqNhM2sIEcu1RS36EOSmg+8NQ+9OQB5UPM3k0+XCzKszq2JzWhYXwwobyMVyndPCaUgEwIRVLB0a/slUGahOzpYy4oKlB9C0rB7bfup3aj7kFutPFXoKDoVDtUwDYU7VhLxulvNal4YRLlICMXMDGnCdROyq2Z8FRMkYfpNSZ5uxpxR+5DNWb29eETuR76Ou2dLu5YFmqwPOFBfCIEGGIddFZ+8TEKKkwDe1NfQ1eovJtA0QCb4ZrcAZC1ewb3u7iqLyTz/Th9krvPIQcy/V+nDmmSq146wtyNUFQjkc+e2m/9MUj4+tIThqmKXfdGfE7AribLYI3Txh6xfOBsKFsMOa+KYiuGxmwszbyNQyl5llQHNPT4NEyPerZazQk6SkYvaT4K+M32+yny1bA5JuWvT5AQMTw+Ud35P9NqlrHhpBy23HPV1ZGQuNCQ2TdfaJsv3W0kNnsuLojPHZHsu9GxUEOj8n4hjo2DjmWGBtJn+jnQlCyWz46xY7iPo1CBnYD8AxVOxAmLyKMsr4+Ni7Ea0+1i/8BZvrPmhITABAezt44Hd81ICRHRzprSkV1e+0Wf3Zua5IeP5M2RLBnzi4EExjq4JOoEv5rAlacamc1P0vX2iKPm1jZ8Cna0/nklfin1XU+td
 cYFaXTlc
 mwiFtSrOluS6lb/QWyvwNbY6JlXetYsl1oQPAXVZdd0ZoAl0tbi0rdXPK1UmGO3sf2Iyc/esWqED4RTaY7WBn4SA8WLECfXzFH4l9Neqdhw0WW2F0bGQWSCM7XURFdyrr02aPnN1qxYKEVq4xE05bEN9b0Esq8y9BHMpnbPsESpdO6UFTg4QK1nWwtliyEx5JdDrluLxQ2Qjh7sfsgiGQV9WqAsjI+oycABncamB7xQZs9ba2AykeYI3xwmjuElDjTRDumgrROkDiPeHMeura75ZlNhsEbLy3bfhH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review and for taking care of this.

I have gone through the issues you pointed out, and they are valid. I will
pay closer attention to the complete thread and the kernel submission
procedure in future. I will not send a v2.

Thanks,
zhaozhengzhuo

