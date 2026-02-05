Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D60EC1EBE
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 14:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF2B6B0089; Thu,  5 Feb 2026 09:04:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571D26B008A; Thu,  5 Feb 2026 09:04:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478806B0092; Thu,  5 Feb 2026 09:04:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FED36B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E300EBA002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 14:04:45 +0000 (UTC)
X-FDA: 84410573730.26.96CFAB0
Received: from mail.eskimo.com (mail.eskimo.com [66.114.134.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id DBBDB1A000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 14:04:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=eskimo.com;
	spf=pass (imf19.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770300284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0aBH87UOAy7WBzGMpEepbDm6rBv8hKsHth/TITZh/do=;
	b=YU2Dh4MgCaJgD+tFBeV3v16+PcKgS1Sj8QpphC74H7PEa/+YQEZWuewsCXidyBvjhskIDg
	QvDCo/oqY4D5cUXskIn296dgd++1rMvUZx2Fh2Vtyp++Kw3XPnlrzCfA+WWsRuqYwEywzM
	ZC/BqpkWhAYjWshPVA06ARFnQkbwoQc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=eskimo.com;
	spf=pass (imf19.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770300284; a=rsa-sha256;
	cv=none;
	b=bLIPwT1L2azZdjYtgzW/WpW7u2D0taO1id9rr+4fsgsKNxZDJRreXsUsZ5GooNz1BMDEP3
	LaOsYmxgRcam5i4J2rX6bWaeulVLQo2XdJ1ci8/xMy6tQYqow133adN/qJMVPgYib2lNgN
	Flv4A4f9jUcpYvS51cDhYktPA+ir/V8=
Received: from ubuntu.eskimo.com (ubuntu.eskimo.com [IPv6:2001:560:4407:1::106])
	by mail.eskimo.com (Postfix) with ESMTPS id 9B7123C4108;
	Thu,  5 Feb 2026 06:04:38 -0800 (PST)
Date: Thu, 5 Feb 2026 06:04:38 -0800 (PST)
From: Robert Dinse <nanook@eskimo.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
cc: akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: Subject: Regression: CONFIG_ASYNC_KERNEL_PGTABLE_FREE causes
 memory exhaustion and stalls on busy Cascade Lake server (6.18.7 only)
In-Reply-To: <e3759678-0b2b-4236-abb8-a16ffc81d4d7@kernel.org>
Message-ID: <cfe0fc54-ff12-92e3-923a-891316538390@eskimo.com>
References: <06843c7a-909b-41e5-9359-2be51cf9dffa@eskimo.com> <e3759678-0b2b-4236-abb8-a16ffc81d4d7@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1916979846-2012704520-1770300278=:1785895"
X-Virus-Scanned: clamav-milter 1.4.3 at mail.eskimo.com
X-Virus-Status: Clean
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DBBDB1A000C
X-Stat-Signature: b8ozhqcxbc6ofeh16u9dnhwx1jgopgag
X-Rspam-User: 
X-HE-Tag: 1770300281-646546
X-HE-Meta: U2FsdGVkX18YtjAqGHs0+U+cxQuAqNdVJ5fXr2JP7uPC1J56S0hEKYZIICvgPDEHlazm+Xsj6rGeRHYIsWWFc2Y54UOGQd6t9z4I+ql99s2wT7KscfImg0vWQWlWdX7xFIXhEe2uQ2oePlpxudLFWZUMgzMnQ3/qd8aHmH20z9HcuFeAjwQGdF562uW11bHHL9zpOQApJFVis1oC+lTqwRT9Kr0JwFJe0yuwc5eHLy8j5Fj38G1fh2W2PselvThp5qBFPjhrz6k+n6KFLUcK4uNiIu7Ud95JDHn5oOzaUL5vrhyqSSD6r5rvntvLv9CBq4153BPbXznDpOLCanbEWkT3ZtInI5oO/jb5dLIFStgryhChpdvhpyVHESiT/2hz+yI+mwwQe335wb5i8+p+b3q1aCt5r1DBJ7aa93L4RGfUC+aTxZr6h+oTOLiu6Xk8HX1Dh5ulp+KsVv/HC/irY6R7nysgeNe/zm06xCTiJjPVdZAgfs42Kw4UaV+Qb0zNGvPRBC/xnDJfZc8zsYEah8DIxPiXD2s3Fq+b8VbdXDIwdokieO7I/EOR4Z0QZerdzJB0onQtSH+riqgpYJr6j+PyGgnaviydL0QERlfgj/MZAIxoOgbtRRinPdCbFurSpGHj8phWgsU2Z2TX42l2qfN03KsQhDss7ddIuxs5FojE+15HnXPl1gwNJ14/VIh09neuxvizhzFS+9efdRnh7UOcXfQIkNAOEOCcP6aYXgDRjtw49yZ83DK8TPODonj2At8OVF7uWqoHG3ZQzxV+RLxyZxYkov3qFMiIHuuMD3NaiJ1rdCKBQpzT/KAmGf7FZXxrAhTNmujk+Rcdpt4wnoEhGSWmcKasR8oMmymv2m6g4lq2seyZ2smZfOFZW1GQBaN58/wAAWeyn3YLHTeXiSzRblday3SP+LpKbBpxnAdPJuVTrbq5Ku+Hy0iM1IC1i+ye0bBbw2s7sqCGxt6
 mRXMNR6q
 DayA50bPSz8X9gkP0YMsg+3TBi7xQJyroJ2m2cLpJkWM5KskBXvkKJ8tI23UlRSMQIf/FYjWXpNFWDKhwol+YD+twjEoVPtKS+0dimW982uXBhX+WgtCIDAMstGkS1T6VDYIqzjlniaTbNxZgN8tmfLQHM03fjT899i3natIIqXIdyldbRY5TJAfK0eHsRe3bebKeM12IzTBDKtr+ZBoVUtWHKFyyZPYaFjbC2jmP5lLU9Nj8Iadnv8pE/nUO1GGjAiDx/96/h5+zN05w1MQwibfvwyMoE9Lszp97A38yWaXZRMgOI7W28joT86+eWciQO7Ig2nWTgI7nCE3omDGUO01ArwLBojjG8+iXAdwp2f6PD7AgW3CsCzMIB9wbSHcCKcamctuk3vIv1VH+VBPet0twYio95VhrG2XjSdVNONPbpxJ6yEKMF5ew0E/bkJCifJcrXrnld/hseVw5sImEP/aksOsqTrhopqc8sDAePlNLOTPn+mtQR9HCZzFVC27i6b5yjHycI6WOkVE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1916979846-2012704520-1770300278=:1785895
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT


      I have run 6.18.8 on my workstation for two days without incident so I
suspect whatever was broken in 6.18.7 is already corrected, I am now putting
it on the other server which had problems, will know in about 12 hours.

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
  Eskimo North Linux Friendly Internet Access, Shell Accounts, and Hosting.
    Knowledgeable human assistance, not telephone trees or script readers.
  See our web site: http://www.eskimo.com/ (206) 812-0051 or (800) 246-6874.

On Sun, 1 Feb 2026, Christophe Leroy (CS GROUP) wrote:

> Date: Sun, 1 Feb 2026 19:16:43 +0100
> From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> To: Robert Dinse <nanook@eskimo.com>, akpm@linux-foundation.org
> Cc: linux-mm@kvack.org
> Subject: Re: Subject: Regression: CONFIG_ASYNC_KERNEL_PGTABLE_FREE causes
>     memory exhaustion and stalls on busy Cascade Lake server (6.18.7 only)
> 
>
>
> Le 29/01/2026 à 07:10, Robert Dinse a écrit :
>> 
>> 
>> Reverting to 6.18.6 immediately restores the previous stable behavior.
>> 
>> Attempt to disable CONFIG_ASYNC_KERNEL_PGTABLE_FREE
>> ---------------------------------------------------
>> I attempted to disable the new async kernel page table freeing feature:
>> 
>> - The symbol `CONFIG_ASYNC_KERNEL_PGTABLE_FREE` appears in `.config`
>> - However, it does not appear in xconfig or other configuration frontends
>> - Manually editing `.config` to disable it works only until the next 
>> `make`:
>>    - As soon as I re-run the build, the option is silently re-enabled
>> - I tried to chase the Kconfig dependencies, but the chain was too 
>> convoluted; it appears to be effectively non-user-selectable and forced on 
>> by default for my architecture.
>>
>>  From an operator perspective, this feature as currently implemented is not 
>> workable on a busy machine like this, and the inability to disable it makes 
>> it difficult to bisect or run with a known-good configuration.
>> 
>
> Try reverting commit 9f0a7ab700f8 ("iommu/sva: invalidate stale IOTLB entries 
> for kernel address space") ?
>
> Christophe
>
--1916979846-2012704520-1770300278=:1785895--

