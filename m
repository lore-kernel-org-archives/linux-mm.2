Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB2ECD5BD1
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DEB96B00A0; Thu, 28 May 2026 23:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58ED06B00A2; Thu, 28 May 2026 23:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB436B00A3; Thu, 28 May 2026 23:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED876B00A0
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:28:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6353C288A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:28:15 +0000 (UTC)
X-FDA: 84819024150.15.A1727BB
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8B57340008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:28:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Qdh394vT;
	spf=pass (imf11.hostedemail.com: domain of niecheng1@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780025294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6PEc5psigEz/kH0bVSk2Y2gyiMDJw494/MMiO7Z36M=;
	b=zXB2WCiEYTxKhsf4jJ+VYzb2ygLyYfhBbp930+hyA/RG/xNRZLac0irGIJusBsTMzYbuPC
	AVVDFbUAkqQL91mlBmzFgDkDgQK3Kn9a9uvqwknpkB9biMF1x02Dt4IyD010sqsJSJ6uYQ
	Z0U0S+VXmIgRinsDmnwq/4WIoAhOMAo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780025294; a=rsa-sha256;
	cv=none;
	b=J4bFksJyfrK3Qm84b25SiITt7EgESirPs+/0PnMcYxIchqX5iq0OhXrMQMxkboHLLD0nH0
	i7Z98ZAxSUMxb0/QIoDAwBrxfsdCYZGa9E20gJTOXQ9wjOF+xB6sr2zwwra9kglpzWy6uU
	zbDU4GvGeuZyDmmzT8H//OQicXy4tzM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Qdh394vT;
	spf=pass (imf11.hostedemail.com: domain of niecheng1@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780025268;
	bh=h6PEc5psigEz/kH0bVSk2Y2gyiMDJw494/MMiO7Z36M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Qdh394vT/vI/ySlc5OYI2nLiVE1WQ4H0HGAeJAj3ReyLOIw7R3pSyvs3GxuUR4jOg
	 YdBJk+4sCv9Jxf+k601Y3qNq2443wn0oW4CX2J22tHNnLYUvwN+2KzKB7222erR5Vl
	 82IOLEedAghxebDHOB+aq0NNbtuQc6kO3+iJL/Vc=
X-QQ-mid: zesmtpgz9t1780025257ta18e5e23
X-QQ-Originating-IP: i22l7cR4uab6Epn6Jsxfji0CDWCVfMPMotNMblrXw6c=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 29 May 2026 11:27:35 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8449337721891734476
EX-QQ-RecipientCnt: 8
From: Cheng Nie <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	kernel@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	niecheng1@uniontech.com,
	shuah@kernel.org
Subject: Re: [PATCH 2/2] selftests/damon: validate memcg filter sysfs readback
Date: Fri, 29 May 2026 11:27:35 +0800
Message-ID: <AEAE007AE486E7ED+20260529032735.1564733-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260528142819.153573-1-sj@kernel.org>
References: <20260528142819.153573-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NJC1vxR0K3U+co+ZB9/PBPXOqB4jNN5WenhxLVWhlk+8QM68mOyHqYM4
	j9MeKvnbki5bkipvzhr5vfdwcHYQ4c2KnfWYl+jyJke0QeiY//HjP0XAF1nC70eqDzLuk+D
	62xQVBwTMwGNhZDxIwNnz8Pny3s4B4ZMUZgo/5LR5JtkOHzCrVczb3UodQbVmW+JVYN7zNb
	HDG/wW4m66EuXrW9S+ZNGvzOqhsuRGIjcCOZn5l6iAjpKNv2BzujN/IKnxQYyyM9pUzST5G
	JSYtZjufe14avYO6YyR3MQqB1OMkJ27A68thlbB+Rl30q9kbKSAYN5Zkb7Pg644ZwHmyMzy
	gfHpeZV7wSVp5e2+KlxR2CTlh+SSIbpCjHb2m5dC3kWKQOlh0WYD3zuDX4V6TNJigPUP2/p
	fAfaZn4R0FVwsTCkBfoFuuOJBjawtc3N+TU14P8+SoRpWqkJf0ZQavEUNKVVrD78avrUAz6
	r1Xcw4TVbr648szQAZvq9dEn0cHIrFiTkWFhetiIb2DBQL9/c5JY/Yaj5pNbolJPFiLqvoA
	qfqnkjq4K5JXNNi6MdAY8RPMr9YkwIG/ppNHe8jUbIA2fFRcyVqNNmcxmPBugZoOplhfKt8
	tKk/Lxinsn5b9lcBJYUQELzRf7S01SM9lmp8NodEEeSOSjTaDjJ9c7BDaI962BB08suzupd
	L4vnG2oLgiLO5gm1szyS5dIhMQyS5u6h9zI3cR0brFG0XV/LsoV/XLYlDpz8bJAa59cKeME
	VVG+dyLYar/TkVnMp/gI06n/3dXBUNjgc0Jg69NoowUial6YnClhAtYyrUgzeqoaPVjEmVt
	3uw0CUasQp044hpGozP0fhFbvWqY5lCwVEeAAjWg2tGCctiGSV9NTQc4WudmxSyMzfach8d
	qImEbW0gl/CukjU5J1KjBAOrgaB4nDSR8wyR5ermHcqpesIfK1TA+9geiUwEj8Ox/1J955a
	WQ9uwGolkr1R3bEEaJU2g6TRthcN5IWBufyOEJByuxUdujsZd6y+BiYZvWfjNwsAnSNc3OZ
	TzkZmnK0yR/TJLq6ZLCJDuQglRv/2pRi89oQBbgdhLjRIGcIZiifxzucP/ARkf+ae4BC2Ht
	MwsqptsSty/gDOTTyUdEaCTmA+jKJuiSIa4YkEOvcWXeYNQ7WhLePM=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam11
X-Stat-Signature: 1ob6kpeodpt36jaigcbce8761gi6ftqq
X-Rspamd-Queue-Id: 8B57340008
X-Rspam-User: 
X-HE-Tag: 1780025292-401256
X-HE-Meta: U2FsdGVkX18X+mV/YQCzlMzXnMmMI7V5aKmx81jy1U2ZWRfHQZSuf/WkhhySDY9fvRzwh9CykJp3qYFCS89Ul39c4sMvy3u3WX+FcmmE2ToWwNxz/ecjkA03O2BBW+rJ2ds5h33b9uxi0GNArk4LeShPeorfuMr4KWTAVIMBWQEbmKEu/E800ehg5yODHTTM1IJn1IfPz6bGuSXkmd6flhyR2FIOJRvTGuDMmfyXh6wQASy4tzzKjYl9A+BF2B9zMGhBrYvuylXFYDmm7IGd9KPBAnTsMgzkRmjylxAGn6XAFnWgPhdoDbF6UlYB1F4WSXCIJuPFOdp8zYgmelWGvUx4QymvR42bNFJ7Wz1ImgnNU/SCC4vnBE+B8xrcw9KtCcAoDHN5lQc3kzr9wLFQ3MEuwxN6STIR3GkGqAilT6G5klMH7V9GPWRNFC4SLO4uF/jZVYzyjKWrmuMVSoGc8znWy3GJecOOuY+JD2rJco+vnEF6EUdZGtAVO/5MQv3q/uwmjuN/wVXCiBNP39dI97TMfznrkInAcxdS7zIezasLU269kvGKnIBHcPETPYJQ8aSfqYZsEkJMQyUIDqtBQkwrvAb6CzhdeVeOMqvtg5voak2NtPM8G0P5bFvAhRD7SwD2ydkzg7E+t2gjV77BLJPWTs91qP3alzIAT9Ga0m9pdqhbsMhTiAkYHH2Ir0BeVkOvzjVGqS19dP09JeP9qH2eQuile8ryhdVq0FIMpnw47dmFZhrRPiG27hOMcMI/m0z4k72JjskazBp3fA/34ZvldALKc/NbkdNC0OfWi6U87MXf1SUiAUY20vKe4AKh7MIAaE3bzcsG1lsU5r8jOj7aURikbg4oTFgaiSCXqlhvPnPoEwp8pgKXR1RgyKJs10bVf0frtXA+t9IUv2cWP9rjIKGad3IwsxuWL2xtPs1Pj5LZWZrVC0CAVaqfdTPjUJeZbU90n5Ny2o7DGry
 /AGTr/WP
 H+Qs4mgOd+juzqadG/Rqm7rEe+qC5PyQ9mkwdOvMiB1kRIQABP1QGx8UTm/+H9pYorGLNqvTJPwPtjk9kgIqgzM03oYYsklGb68rGMGGYNZQa8ICfgqjbYcFxwY7jCQSLDNm76DWm1lRgepjFwtGWu8GlKOIEpQTBZHlLZPzSPMXmV+9IKO/1KX9yp+EaeTyPyiXbTXJFiCJBr6mgPzQf8TT+c6Qkah5ZGoLzkXtzE7oGOa8wey+gpU2CtD3pCP5Rel4DBcYIO0BNPwf3n9IDtq9+Wdp0H5sM0YLD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 07:28:18 -0700 SeongJae Park wrote:

> Could we use 'selftests/damn/sysfs.py:' as the prefix of the subject?
> That will make it consistent with other commits and let us easily know
> to what test this change is made.

Will do in v2.

> But this is in the middle of assert_filter_committed().  As the name
> says, this is for validating if the user inputs are passed to DAMON
> internal.  I think this is not the right place to test its 'staging'
> functionality.

Will do.  I will remove the memcg_path readback check from
assert_filter_committed() in v2.

> What about adding another test case at the end of the main() function
> for the validation of memcg string staging functionality?

Will do.  I will add a dedicated test case at the end of main() in v2.

Thanks,
Cheng Nie

