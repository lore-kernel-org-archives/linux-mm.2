Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 702BEEE6B6A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 23:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3586B0089; Fri,  6 Feb 2026 18:28:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90C96B0092; Fri,  6 Feb 2026 18:28:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98FEC6B0093; Fri,  6 Feb 2026 18:28:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 841D16B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:28:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F08E4139059
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:28:34 +0000 (UTC)
X-FDA: 84415623348.15.F475AF5
Received: from r3-20.sinamail.sina.com.cn (r3-20.sinamail.sina.com.cn [202.108.3.20])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0A47E180006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:28:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=Ufj2C5zO;
	spf=pass (imf06.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.20 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770420513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+q2ZVcAz7bB71SNxE1U3HEq9dQbnKL+GOuYh5D2Ugo=;
	b=XlBELZzVD8zrBRV3reSr91W09DgIucz0DU6/rQiN+CjlZ2aUg2PKqg3g6VKVME8qrnnOfQ
	jmAn5frHs/fJoX7ZYHMFWBcV3R5kbkX1moW/OI7QAl7yBd4APqlzGSeE3hg7fqlwZpm59R
	Ebh0r6yN9WDX5CzkKp4N32gP8khc6gs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=Ufj2C5zO;
	spf=pass (imf06.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.20 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770420513; a=rsa-sha256;
	cv=none;
	b=zYM7MUwvJSDFoVZivZ3NnVCMkDL+nOE82Kbfv8yfzQDM345zjooqTq51N9u8NRP5C8UBub
	4fYA+8HydkI/ySnY4fmp9tEmBZPcrx4bmOv02SO+q0BtA7WaB1y233tEbJIWCg/+2iLENI
	a56jVvHa+Sr5vyfzDDtb5IaYZ2E0YTE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1770420512;
	bh=5+q2ZVcAz7bB71SNxE1U3HEq9dQbnKL+GOuYh5D2Ugo=;
	h=From:Subject:Date:Message-ID;
	b=Ufj2C5zOIlVOjp/r5+VzNdpBG4yBGMktKJ+SxOm0epOMk+pH7ECt1IsP6CtqEtdIP
	 lLaTVa7b0dJYT225adWtbLyo5+LD7w6++3cM/U+Fwhv9+ZC1QX7cVKnmIXMXeax8yp
	 BmI1VpAtEpiOpINt9Eubf5tXszRB9X7hXh+7Wse8=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.32) with ESMTP
	id 6986791A000015B1; Fri, 7 Feb 2026 07:28:27 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 5619754456882
X-SMAIL-UIID: 5FFF89B0442249D792C553FA56B5A095-20260207-072827-1
From: Hillf Danton <hdanton@sina.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: lsf-pc@lists.linux-foundation.org,
	Viacheslav Dubeyko <vdubeyko@redhat.com>,
	linux-mm@kvack.org,
	Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Machine Learning (ML) library in Linux kernel
Date: Sat,  7 Feb 2026 07:28:11 +0800
Message-ID: <20260206232817.2596-1-hdanton@sina.com>
In-Reply-To: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: bs9gofs9mukbrk8f3oynzahysmwdic4h
X-Rspamd-Queue-Id: 0A47E180006
X-Rspam-User: 
X-HE-Tag: 1770420511-509696
X-HE-Meta: U2FsdGVkX1/UEcLHF5qbr3wKZhacoWE/HOG189QRYJAwvsk/v2qvjv0V+O5WlOwkmuJeM3guA0/2nTggc3aSqdMXCysQ1mlskOwRfxaNOrtgji/gtq+zh3whZTKiNElohTIJlApf6uHD4aevGd5FDZrOAasTH5or5HdftIH/9i9ZQqZQH9HAjw8JGM9XBB7EmISOMTc/1vK/duXj36vibZ6S2nIK0EUTpdign7hkS9sglyj0o6c1V/v5hz8axCcRrgyqorv246CXdJfoHrfCI8eV2VRK1s30kFg4buQXkfisa/49Y6xedGjfW6og41EpjqClLfCYtdJodP2aT0IFBWqKdfg/91UfWEG4wQToZ/7gmXIlU7VAvOX9Nw4jjbQJZ5lGjIv9vWGm2ejHC3F7ZuIzMyhcOAlST0//Zij1vf2nd8vHuXC9cWTbJhrU7LwuR2wFkQMyK8U1Cv9c7ct4twn05cXMoZEGEDXiTA4KcTVp6DiylwfgDMe6cbWZFaDgdPXfVvFW38a3Yd7QJDatwXHg8MI6UrTjabfP7ZqM2Ezu64OJ3Pee+iI3tMR+fx8+y3Lp0FFhYkKMhC7Qj9VJe3vp1+2bIYKFafShYtesFnShemvqzcewPtbRR1CYOcufPJUvq9g2dBEo6nhbScts8cdpDuHJ3FoXKEpKdV93or7F3zblj3a+9d8jHYh0Pg3Y07/oT0vq5RjJJMHo4LPjjboPhwXuu4Xo7hXHphR1XkoMXHar6yiCB1V0HJem5G4PIKmop3LwL92XZSWp9GOwA4a21TM0bcKGoA/1JrgXgjhfKCy6Kh83P2GJFLQvpIQ8Dzgc35PJgEt1dAK7/MF+xHsECRDxQb2dkkluJaAzkM515+JUsnlb2hO2vPt7/pbtJh73VpfWR4sRuUXkrY8vbCdbKFy2rjyf0/erDgPFWTGmHFdgUm69ItUFO0/IzTfY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Feb 2026 19:38:28 +0000 Viacheslav Dubeyko wrote:
> Hello,
> 
> Machine Learning (ML) is approach/area of learning from data,
> finding patterns, and making predictions without implementing algorithms
> by developers. The number of areas of ML applications is growing
> with every day. Generally speaking, ML can introduce a self-evolving and
> self-learning capability in Linux kernel. There are already research works
> and industry efforts to employ ML approaches for configuration and
> optimization the Linux kernel. However, introduction of ML approaches
> in Linux kernel is not so simple and straightforward way. There are multiple
> problems and unanswered questions on this road. First of all, any ML model
> requires the floating-point operations (FPU) for running. But there is
> no direct use of FPUs in kernel space. Also, ML model requires training phase
> that can be a reason of significant performance degradation of Linux kernel.
> Even inference phase could be problematic from the performance point of view
> on kernel side. The using of ML approaches in Linux kernel is inevitable step.
> But, how can we use ML approaches in Linux kernel? Which infrastructure
> do we need to adopt ML models in Linux kernel?
>
Given the short list, eevdf, slab, ext4, IP stack, usb bus and kvm, ML is not
needed before the second half in 2027, because it wastes minutes to make
either liver or pancreas intelligent. By intelligent I mean liver can edit
ppt in Russian. Perhaps Cerebellum is an exception.

Can you build bot to fix syzbot reports before 2028?

