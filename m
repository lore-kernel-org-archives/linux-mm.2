Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC568C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19326B0095; Fri,  4 Sep 2026 07:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCA826B0096; Fri,  4 Sep 2026 07:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0266B0098; Fri,  4 Sep 2026 07:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1B266B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:59:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4067D12100E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:59:39 +0000 (UTC)
X-FDA: 85175935278.26.7642CCF
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id E12FE160006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:59:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=G5dofKio;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf08.hostedemail.com: domain of gaoguixing@uniontech.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=gaoguixing@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788523177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CgQf+B3SvYZRu1f3QssxgcgWnfYZODXI8JXRV6DDSrI=;
	b=Zmr0aqGGYMfAUyWzLuNGsosFdL9p5E0HTTLFThvACztxANv1/sugkTKE3h3lEsI1h8EOGo
	zpO00DyAltfFr1v4KeYFhlnqCNIYmvUpvImztDXcE/HIEq8sGVf+2KEr+K/5VNQiFTMe7j
	MmL+TOqA+8TPB6YHEODZ3weJAE5kDFk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=G5dofKio;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf08.hostedemail.com: domain of gaoguixing@uniontech.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=gaoguixing@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788523177;
	b=VhYZuihatspRFi6yZ3cZOhqrQ4MHPNgIcepHFlFhiL4eMKN/s4piPTmEyK5yuQooKymPUz
	6P2hyLHtK1mjLZZFigGI+2mPliu7vS+ce+JCwo2QJwKR8GiCjMZ/SjTydtIN8eUkqU3+ye
	3Ic5VWeukwV8lQcbPpMYHvGmEi4gu2E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788523116;
	bh=CgQf+B3SvYZRu1f3QssxgcgWnfYZODXI8JXRV6DDSrI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=G5dofKio1U5ZeIPAVQ3CvYobA4Qxf/xZMUoO2Nb70cdyEzx2ywLWJXbAuBFPcF0ET
	 NHZhCd61+NcrgPjUtMusP0MgoE8fd1TlriDg/ZAIbPhVIr9mmoi5IGshLAHg+yC23w
	 IuwWAmWm3tFdMm98xm6EF5z9FU5Dafno8JTTiAZg=
X-QQ-mid: zesmtpsz7t1788523109t32eeaed7
X-QQ-Originating-IP: Yf6zIeMAQMXg7vQ9lJEY7WQGlVEiqJORvs6GqIv+C3s=
Received: from ggx-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 04 Sep 2026 19:58:26 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3520154375068366657
From: gaoguixing <gaoguixing@uniontech.com>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>
Subject: Re: [RFC PATCH] mm/swap: fix swap table count encoding for empty slots
Date: Fri,  4 Sep 2026 19:58:26 +0800
Message-ID: <4442A232A068B3D9+20260904115826.193612-1-gaoguixing@uniontech.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: Nv1Zs1ssfOILZ2647zMltOD2pep99YXU4SI5Z9vviMHKTOkhPGUIP9zF
	GUX4fB3GyU5NNhQB4zLiKR+mUeAHqBgJ4pTOrWRbo5C5Ix4nGvuDphlwSxqDVRyXxVjmwMq
	Yr7A4h+8ompDAuv+K8xorFBdRR3gAci/52pKyX5PSPfulDz3yZDVl20vWpqXylGepIshCM8
	inuH6OtQ2H/NQbHJ977v/ymKqkOQTK7ZrNu7ebbIzqvcNQZnT4qMe934zK7iPgztBvrX+5r
	R2BoX5ttFth3EFJnHzD6gmNoYR8nQVOtBrkeq6x/1F2wPcUWHJvDmB30adqZEPnqVMJxS2i
	wceV962hu0+ZJPxcqBASn9U4AaOYHVlAe231mjVoSTZp01c4reG5WBWp6HfkEUcAtQibM8f
	LRW/GWt6ind5QzMvRl6fJZ8yH4sBsGO1wzZcY4OL5rlFcDOBXV22HK1vmhn2oh7yLSRqA5r
	O405BrEGXRNMPeoXYGRaiqaLIcLjRpG9BWi6I9AHqsIC0rSlPC40/r10vd9NoiR/0ogPzBJ
	+6+G7k7dvrePuA2p5Xd3HpBcocOYp58kD2y/wfZj96IvcmQrkDb/b0gsGBAAer8xxtCW3up
	F45k7N91P0WucssxkKRwvIPQa7REYX/5xQevHXDZg4A+g9H7BtPRxbeJNwATEELiwm2LJjS
	1rwmrHqC9nQoQcHrWIEW19LKhP42WX5IwI6qry/7iB7+Y0pHh3ZpOc/1EdPDXNSzHDgCQTo
	ETcBBYC8UArzSybPsEnCXR17YOvWs7GmKieOkqesJ7/g29zCemgBLPxxbeOLYBSbZ+wLiju
	C+VFtrCzqyTUd7129eDKZ6L9f67n+h/3uFXtc/aj5eyadG8lRGjo1+abAJq6aiNYru0CYaL
	SEdrSQv9h1wMprAJkD3danqFBJf3S3FdMMHqdge9Flu0ms2OLKb3m3iiv7AQTDAw24RP9Og
	vYBRMh7cvh0uB2Y/QXOaKvUQOxO7F59zBR0Ysfw+8Di6TItWGUVRsAvTe927HJxKcUYAFq4
	/YoFHqboxQfLcgsQJUoL7f4+UNf2Ur6Ag5SmDvxA==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E12FE160006
X-Stat-Signature: 18djgdmd6fupdy641mn3u5mi48jfzqhh
X-Rspam-User: 
X-HE-Tag: 1788523175-325242
X-HE-Meta: U2FsdGVkX1/tIyAnqJXRafWqIiebY/h4kqESh1O3FvfKNmmmcKUbeQz8mwt9BO1mwiKIavxPT/l6nOCN66hEW/0iKF3G7XiKhTwLSBg8m4o+NbJCDbZfqP3NCUVZSQt9QTheUKXFhgkyUSF9O9qx4M+Smrg2otrn3cG9gU3fJk8ZH0esi0d4+x/NNidSLKZX4+nLG/xIQRQMl9ytzLHcMrY4Zp83CZN/tK8Ht/oypmyA1SOCNZ3vyfLlyrgwhEytswhwLydREWL9RzGQ9Rf3b3Oji7D/pbgLCKQv/UL0hMxXFLQ4d9ztiQWEXOo1i5wknq9gE+N3DHRonZ+dL87agU1ylnhO+M5we03eKcb14/v5PpC3l/5LU5W8gPha5GJ21AttGYGYt5sYqFRG1Ys1JRPCvQx+ULc5jL73F2zQDLbMPd5xCK4GWjVupqo7/Ce8j1mu1lLz7xqPX4roxoLXS2lb2VXE/Z2P6SiUcXyyxupGxOP2ruoKNLpqkmKbTDsfdp77THPFVySde9Psw94S4xjo5xCOc4kbQTLXLpJSo+2J3I4Ygy3oeCXJ3lJ3TjV4tcBi7ulZJ3l7mzqV+iLlD2pkmozAbTeJAwoTHkzrht+i7KgroZVc9IoBME4dhyau4kLFXB1QOv+i/AKmq+KonaV/toMGDEkoJECZV4Y4x9Z2XZloHAvpol9kgEtu25ZDPHGJ8BqckBUPGmZ6RrjF3IzbAMlCVH+l4zMZ2fCtkREerRy2wMIdCA/LafgjWL9HfKlZk466quW4SmxJ9BRE/t/Cl2AeokPNi4ms5dEooDbcv+V+OMtZXc/hmUMek8E4s2A/catfxhS+lZC4A31NIIpZrnCS1Wi9fq4qdj/ulAe37cApupYDaSZBNxAicyLUfkaVBZodGFKLVquHBf9ISX4fPG8WV5HUKyMUgHLC8FSKUiTKiU2Zms3fmxBMNkkPICiAUcanjk2k5LGVqb7
 dKz6Fg4o
 NW9dB/q2ezWIfS24ftYcxENXQ2SZMog+1Rcego1iiPIek7A+eGj5LmgWd03W4AB1B/C1s1KDgNNZYJrtNXIzTH6y1tA6ltwnxACxTtZzUjQV9bvuCqQr2JKVrahv75GPN+KB1ZmKze84wHeefjIFWy+TxXm7JX6uENJlh0GC5Ns+Ls199A/oz+Fw6Fy/ke7ZfTE0NRGgS5GD6dmnzytS1QmaPA3eijW3qHaKwtrtJ3LmTmm+tIr5rZFE98nwShRnl6ZUTeW9DNAXk/myl6yK8bPwsZdTHy89a+2BKxRro7ukYe0tYHUK2GtMgrYEFh+xmjp5Z3c3xIwcdWfTqKhbNYEJSuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Sorry for the confusion and for sending the RFC without sufficient
context.

You are correct: __swap_table_update_count() comes from my local 6.18.y
adaptation and is not present in the upstream series. The issue is in my
adaptation, which incorrectly passed a count-only value to a helper that
expects the complete flags field.

The current diff is therefore not directly applicable upstream. Please
disregard it for now. I will rebase the adaptation onto the upstream
series, verify the issue independently, and send a proper patch with the
necessary rationale and test results.

Thank you for pointing this out.

Best regards,
Guoxing

