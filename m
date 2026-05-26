Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3093CD5BD5
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 23:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59586B0005; Tue, 26 May 2026 19:49:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE32F6B008A; Tue, 26 May 2026 19:49:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB116B008C; Tue, 26 May 2026 19:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A160B6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:49:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4017D1A04CE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:49:50 +0000 (UTC)
X-FDA: 84811216140.11.F00456F
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 46E8380011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:49:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=avJdNW1v;
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779839388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UFTUqui+lyDEpkII00aPHz64gTpTCUqug24pFaLMXHE=;
	b=vTf1o2c0QllW3NjFPtrWZaEkRZsel4p8r4UudEXm8TBYBBu8QNmQf9CDC8ocFA84zI2Tnf
	zyjmqZj9dZirg66BqV1jsVh3wI1yegzxbk4wsqZ7l50Qc1C3nwExx0bVxwHyrFmr2YOjaB
	4te1o3bm4DX3p5BAySuO8u5TTEQ85ag=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=avJdNW1v;
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779839388; a=rsa-sha256;
	cv=pass;
	b=bNpt+jkn3+GstDfylFJhG4fTTfUKHZCDl/VoIL6DHH+nR+IjJCpDQOI628LHmO/Pqq2A10
	h+dGH1ZsBGnEA76+dEtSDJdwVu1FyWfiQ9JKU4KWwOwnpy7rQNFBnscJtt0m98BPgf/YWS
	6tITxPuTUMKaFhOKUC4rVDqTPRJn4OA=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-304545f5206so6694017eec.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 16:49:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779839387; cv=none;
        d=google.com; s=arc-20240605;
        b=jgadYJbRCP5vUjVkKorJQPT2wZBWbUbAOAUDZ8O9hehcCyBYVN2iR7DKREoS7lk+1M
         ROxkft6hlUvxhMcqpsVQYLNy9P5urtIWB5Sej8foPVfNcmr47KiOP1iZ84xqFthzJp9P
         xXT6/SvjAFN19ygEUZJEapcBSyuoqPSVzCC/Eg7xkHAmaXCRtqIlnb/Lb+bJB/RSi1ER
         nVwdJHer9siKKfpZRjV7WPpvu9vYpV5NNKtxMrGGgwr6MtMjYVLfSPplSY+N3DQyr/3F
         BTRzi/zI38vDpYVgzF3iK64sisms5sMyL7N+qOF9ttp8S8CP7zzd7kLRVZO7onLPh6aj
         1DBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=UFTUqui+lyDEpkII00aPHz64gTpTCUqug24pFaLMXHE=;
        fh=D8xJN2Qv33sssjxFceXjUK2+9Elu09Nkmm3GrYGeLMw=;
        b=IUyeBMwi1k1RtxzcE8vvESkmq+n24mAnPJrTCAy57tQ11iVwgeG5+NAxMBioUD6JYM
         MeKpff141S3zVp+0rPy97LdxfCQtX97aSutFM95n9UmgHkOo+36oQ0YTtUnDvgfcKvH0
         q4FFwfyMZN5sm8BYz/5IbyrRc/v1G5aH43Z0HeYuLTTXemPiLCaxWznttdrhdjrd2dE3
         hBdUVY4jXxGSE6R01Z8RrlJUvGddkOgw7PSAMq1uztI/yibJ/pPW97br71npyq7Ldhdq
         c8AXWpEVkNBupcuEgo7ZGX/HZ/T3h8PLY2gOzafF3pOeXcUx1f6hHP07kAsMC0gE/DxO
         CCsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779839387; x=1780444187; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UFTUqui+lyDEpkII00aPHz64gTpTCUqug24pFaLMXHE=;
        b=avJdNW1vzqy+oUJsmwafa9y38Xl0VDVr9dDkrCe066x0JOx03na7Lm1T99nzTjQBj2
         NooBvKReqcpduWmTquW1l+4hXIHUGFET2QQHHKSgfmqUGNg9n4zdPBzt4ugWaNgJYi0A
         ttsiH2Ws1rLctZfUmWR4LDt+G45On5HUckRIVTEfUGzGYpDDL3uEH+a+Gd7sYCAMaDc+
         4jca4xyCwNgSkFg1xUzaP7CXrg0yIXM3DwdrNWABz6TfsjTtzTPUWKQAk2Y7yMAPSL8V
         vjVq8YWzZlaEon7lSC9QbTIg7N2lNRaHe5JzIaNuvFhItQfi32dACTG6FbQeSPAHx42q
         v2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779839387; x=1780444187;
        h=cc:to:subject:message-id:date:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UFTUqui+lyDEpkII00aPHz64gTpTCUqug24pFaLMXHE=;
        b=Ue5FY5P1XWXCtZ7NZONJGnqzjKBWmtffkmGk+QhyAECzRnqyEKiGwbgeIfMXDtMCxi
         RWEa3oHWAo3aPiCyZ3w5H37MaV/Hw4wpFNOgF7UkeFSnwV1QpkAkI1V9BnCV0efr+RcN
         gVMyMBXzJHo7xX0YP49FWkCAm8zLT7MIrQc0a7UNcEYHejQUkFV7H3WQGilgQqAkgnFe
         OpDn1W3rVMtU8FNMjjEPsj8SdrRrljS+lbDwQNeqaX6ocAZC+/csg9Eplj+zdt70dTjL
         KN5ros24d8AYaedzy09cx2JrgR3jDRVmBp/6SyfKk/vV5vUclsgy5AJBjhiU8MWYK4HN
         LnLg==
X-Forwarded-Encrypted: i=1; AFNElJ+BT5/opa6WM6FuQax8zIoMgb+/30cFD173bl13T46PuGLYbvl78Xm2uqtGiyMDYwS9qhSsZqOjJA==@kvack.org
X-Gm-Message-State: AOJu0Yyd4gFiK5k+wLntjzx6qEuvB8D95SzVSq3u19pH9n+L1iJAwfle
	LrCi4x8I7RYfiV8FimsQHztLvjJPa0/Qy4J6F/bjI+a8BlEqL8lyR/f+Zr7cILur5ckPhma4Xlt
	DslZbuIDeZz5jZmqhUayZgFdZ/1zYtiJZV3MNM1Fi
X-Gm-Gg: Acq92OEiTHu0XlqvhZhJHSoYw2I986uxRXXzsZv0plTRVMyXZsDF2noZj3d5FN32zei
	ua4T+36sYs4L7fZd+vffBfRXlvbJkCRphRVhgT4T1LgQ6fvJ4Ym6UjTMb7IVhtV+9M92Uut1d4h
	L0NQk3k4fMAm6qkjGhz9AWUt7tpLX7KFo60z8AMV8esl1D8pO+HSulrqnQsKM8X5NqNQUFgQAEN
	BHI0h+XXSzDPdgDIUuy2U8BcwYkUt1/aJ8Y6TOXsm0gNFlsIjF8Fh7WHAGdwt7bmwKyb6R0fD9E
	u+xvNkBwE4bL/GhGk/gcAoEIXI70l1lD9RfcFJrnNO8D7NranaMwKFYy4nJjrQRWoh0/J+7vODS
	XLre3
X-Received: by 2002:a05:7022:ea5b:b0:136:8bdd:3f66 with SMTP id
 a92af1059eb24-1368bdd40d4mr3880334c88.5.1779839386030; Tue, 26 May 2026
 16:49:46 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 26 May 2026 16:49:45 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 26 May 2026 16:49:45 -0700
From: Ackerley Tng <ackerleytng@google.com>
MIME-Version: 1.0
Date: Tue, 26 May 2026 16:49:45 -0700
X-Gm-Features: AVHnY4Jg_aMxqxLmYUYtrQZjJQlu067bf5olggbfoUjTDaktgramXq6wUUS1BnQ
Message-ID: <CAEvNRgHLVPcJenAej85Q31YrM0tCnTpibDsEBdZmaTpf9QaTBA@mail.gmail.com>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-05-28
To: linux-coco@lists.linux.dev, linux-mm@kvack.org, kvm@vger.kernel.org
Cc: david@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46E8380011
X-Stat-Signature: kgo77x5q6zugsm3o5mey4f515izzny4f
X-HE-Tag: 1779839388-852334
X-HE-Meta: U2FsdGVkX19rmakmPO2WfcCe3skr/8SvM3Gz9Gx0Ts/QPQkSVroHLk3V7es/QfXxEqGFNdNyG3kU6HqY+r1wwmAgkIf6hzoIfDBKD+p1TZtdhOHUVcj2a4aiBsJEPl2nYzdADnHM74WOaX3l8aOs6cAeqyB8odtCff1Wf5tNIW8kZNXUxLleEnt6wOwK7ZNVq7ehUO+3OfH7wgihlhFtEbxJtQFcMMizYuKQP5FH9VxmolcT7bOmBxDkTTDYGvPjJfX2TF0Rfs1OyWLs02YfnOrZ9cmfzFJR9n9vWydwMOARSTbzXa1p23bxvLE0jdSO0naGmlvKB8AFts5qpMGhIEJXERdWVwQ348fsfX9JtMhHg5SHARvG9pIF9MFUeU8TSHu/wUyMSCaD6GMylSw4UnDErXM1IIiXDOxn1Irqwt4KowJhPS3pcTGnLzLfpNmjWN0AdQzzUqpDM8O3f8KDsN0OWgGPSlHdPCvZB6lPMbTD2EAJxubgrZ9ShtvOfe/LHWVIjtRALnV1xxkaJkj32J9yv7lebcVJ/Nh/GoTaz80uZK2gXu7zDGhXwI0UJUzMgm2WHUOq4IRcazeXEKyQb7NZfPRhPMrGamMthuhOhtTd72N05zeYx2nBeyT4coLSSftzjVoaR23LeyfZfuR7TvDJ2KABTbHk/KD8TEPR+4p3p6JHVdDldneQuiE5dt9hZ6Nsw1/IqOFXEOGAJWSmOudcLpioF7PyIZ/RHBjvKwtrpki+fyirmEOOmuhwocfvZFWiVNvYH4xZnxEwMZyJepf5b0og3+8maBR8P3hjCIequwTIjbK9FdJRVhx5vMpiCV476JxkkbHBbtreUriLIwUQ/rKDR+gS836zHsJ6aB2kl3oktcliHwWVbICjkpYQ8mXCYg4GbHAIarw05MiLHRdI4/sXuj0xWCmgTQgDcIKUSv44gIrPWVUcBtnoLOceyOqkzKX3sC6dthxjhz2
 JBIw40Tr
 V3SR9dsVLMEo7Xd9lTY2OCqC0Ld4pxQvAaMMmFWxfcK8PqHxKQ7hZdNSqqNRnJ6zZUUh6kT5oXv0Sxc5JEddH7sy6JRb2jLya7aKKAThpYxYBHTcF5NVdtJmk1AntsCxWLSHwjlM8ozsXkhbO5OosoesqAhCmqpzpzztDgIZIpC2Dc6I9aq0S4bzHEfRICWPn1v6UIlrLqJbpfNRIaS40f9Uxk8fugRU0+Bmgp5hYLTTRdnRxh0iQdPQeKFoVZHmBV5OYn6XuC9ef00ZfjQKQBQQ+aNMnc0ZQ4KNwc+05uefd/x+xzoAlC+h5NMbSrpD7N1d6FJ/u/A8Fy9KOPqcVk8AfS063egie1xFhm2aoqGV16G61FzH467naorGvWkfr/uamiv8hr82WJVU2jNt2+ivEutUNT54WPb6OvTmya/PNLX20zNoaGIWdw3G48gJV+z8tbl5ymtH+0D3w3m0Xl7wA5WS6ZyXu6fmx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for Thursday, 2026-05-28
at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

In this meeting, we'll Tarun talk about guest_memfd preservation for
LiveUpdate.

We also have one question regarding virtio-mem and CoCo forwarded from
David.

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write
Ackerley or David a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

Ackerley

