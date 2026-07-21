Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35582C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 23:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F18B6B008A; Tue, 21 Jul 2026 19:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2D46B008C; Tue, 21 Jul 2026 19:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8676B0092; Tue, 21 Jul 2026 19:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D82A66B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:07:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D26D8030D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:07:51 +0000 (UTC)
X-FDA: 85014323142.18.97DD075
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9129C80009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:07:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hu3XKlxF;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784675269;
	b=IGVJjcv31t66tV2KpwVLWJ8I1LMjiaYyHcJmCkGdHWFDCztfIdaVmqvY+x9XCxtDz5MX4K
	td8qHlCL8zR98wn9PGHOOdRWG0TzCt6lcm6kuWJrC8IcSs3ifPVZvJo36hpV9mNGAX0u/7
	1MZTSPloTjiYVICp6A9Ne3IAaDQB9o0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hu3XKlxF;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784675269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3OQXXVa58whyMEmCorMBVgdW3liv+RGIOlQFgF8uhhs=;
	b=VMsi2eUu85sOTgAXh/OnOVXcRI5w/WxDdhRjEg3KYAi4m+vS/NYnCNdR51IIML6ij+Sd5S
	gaZZRky3R0B3Im5K9d39l2B0AOwRSUdnATbiWXnoVKqT8poEZc3Kb/25PCwtcvR/OVVgiI
	81t7PDQn/edoQhDeyS7xFI472NPkX60=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38e7109321dso2017758a91.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:07:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784675268; cv=none;
        d=google.com; s=arc-20260327;
        b=JY/UdEKBbE3DEXwnimD5wJbaSrbCSlruNQttIsnC3w2kMM/Krs1xPgehzfp6U7hY2Q
         Joi8RKWlM7gDewYncDPko/6soh/m66kdIti7LSIpiJNJ4EAklJ+WxtgXwM1+PjvAe5lW
         4GLTpBtZ9S9ntomQAR12PtHqmw71q46fzvSx4upN/xcIk+g8gI2tgoIuQo9obbNxanI2
         RgIm7BRVrYuwvtONRzSX1TZsR9w/VBdUmj1SVzQ523qOyDA925lblFXcW/anNw5e04gR
         BK09WaGF36hfZk3rCq3/MdCuPf22rZBfe0J+DZakKKn7iQQqMuDQ5PtHxKutODBZjfBc
         hl1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=3OQXXVa58whyMEmCorMBVgdW3liv+RGIOlQFgF8uhhs=;
        fh=QHjN9Uwwvdtl/OZFSWpo6iVfaa0wsc8y5DagR87NuHw=;
        b=pQe90O81QEzY/G8Obn3NeRgLbIbhOIdDgcT4xk9f4AzyJ3/kpwlNNDdRqwvkuDN4Nf
         m9XTLFljfK19pFPGEoxAN8rzvMYx2OZ0TpD4ni3frheqLBrEwFiPu3YOA6BT7NXPD4CH
         anyCitWEuKILTofUPW38YL9hwZTg/WreFdr8EsAq5SxQKhEP0b2VEti9Duc/vfqLj74m
         JfDkI/0W4zNuCmdo27MDs7Kz2UEUalJj6T7wIkPqxJDujAuIyoPkSWeDvzd65oqu1p4f
         oWkyv5kYqAdjrUtRUZNlemEMTtSrKkbxeg0aeFHZYDHztZp4MLSVgj6RrIEXdVtvvbh9
         JvVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784675268; x=1785280068; darn=kvack.org;
        h=content-type:to:subject:message-id:date:mime-version:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3OQXXVa58whyMEmCorMBVgdW3liv+RGIOlQFgF8uhhs=;
        b=Hu3XKlxF0hxa0e34HgvlT0cWzq5DE6wsI2bBVBxxyu57uTzvxEa1+j2cm1scRWLyQw
         KWkIpDtNisvL1i5+p+2PsgT/rN0p3pgULBoQYcDmUhvbydMUzep4qY/5U52fXsoxTYIF
         Qq2e/vXzRUa92zlgBCd1dZ97WoFpNC7U4rJo0faLK4BF+js3Cv4unBVO9AzCCZlk3nmB
         E3F3praa28F3l6kWvSM1RWEQgW8NbezPZs/CrghjLXJZbk5XalZ9YAeIKwhR7yZxV+Mp
         s7RXXExWrR27fK0p40QLMHt1aw+gZb+CskkHhDvtxiT0y+NPE21wXkgX0VWvuTyVRT04
         jMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784675268; x=1785280068;
        h=content-type:to:subject:message-id:date:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3OQXXVa58whyMEmCorMBVgdW3liv+RGIOlQFgF8uhhs=;
        b=J9wA+dG+trzzrNwBHaUPEx197TDDCLPzbo4gOeMzNTcNz82b7Y9j01IJhS8qyzE+Gd
         WveZ+qQr4gcFnGYo7tYosmDVxSfAec5nYKTQwFaYCRgQ9sThzeyJOQ4oc8htyZQttgk7
         5tOHj5o2bOXM6S+S44yUCmqCZNRlehupjhPxapwL14bLXq/VBVsJDcsGD0Sf/xTnsRZH
         V4lELdM+TySi6advLuF+1kdSsnttb4OafS0y1pZuyHiDg/1iLEnImG+Vt2ILK4PZMu34
         dvRaNEfvIJAGqxDDEtcXI+nbqfh/oHmZraJp09TRRW8I1CeeapwSm4FaflC+2eSQAX5r
         mF3g==
X-Forwarded-Encrypted: i=1; AHgh+RpDbGVePvi1fkVTKJRbCabyb7n8Ymx6UE1VQKzSTxeWqf5PeZBHIaCDWsxdmythRq8aHuZBVTC4Wg==@kvack.org
X-Gm-Message-State: AOJu0YzoOnftWi4bIqvWyXfWwTzoJxRmSNyM/LEdpeCJ/98NoVryQSEF
	N8//VnzboIQcB6Id50C/4wQlonIKiY8AD0Q8u9gRll1V3zzSzLmGaCPZ8NBsPl2IrrKrCo83CH6
	2r6TkHwh8s/0Do75EZicwlEPrzprJG9o4YrBVAteZ
X-Gm-Gg: AR+sD11jJ1YDvra7+sOgSNCMeNpVOYHmPu3xUPW9E1QM4eQ/baA7r1ZJP7878CEs2n0
	oA61Sz4W11IDobZgEhaaWJXmhNRMEPtKf24ZtIvpLZCUM3poXXlZ/jP8xLFYo59iytceLTAV+8M
	b7jutN7RjgM/0EVTjvYWHULvYT8mPLz8TruZix3+Y3xlkhq2U/7ROnIqsAVkQ6rWEBoZ+2RfHRk
	P0MNwh1ZCaJBoEDfMWvozcevpw7ZlO/r14FgzrkQ/PwrzOyTh18X1WOgm/usTpJIuI+iy00woXD
	PdDflPR/4xN7I6K8jJvbU+0q030Kt9lQ1qPcyKDdkholCg==
X-Received: by 2002:a17:90b:1345:b0:38e:21da:9257 with SMTP id
 98e67ed59e1d1-38e4b56ed6amr22248144a91.37.1784675267895; Tue, 21 Jul 2026
 16:07:47 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 21 Jul 2026 16:07:46 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 21 Jul 2026 16:07:46 -0700
From: Ackerley Tng <ackerleytng@google.com>
MIME-Version: 1.0
Date: Tue, 21 Jul 2026 16:07:46 -0700
X-Gm-Features: AUfX_my9ZoAAGr2xVT-3ET2pTUKEhed6A55b3pp5x-TSu1YG-G0FttRwIwLL4RY
Message-ID: <CAEvNRgE74GL-pr6=GRpQWriGwXh6zsDP+ULxPd82GkFSQgjJkg@mail.gmail.com>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-07-23
To: linux-coco@lists.linux.dev, linux-mm@kvack.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9129C80009
X-Stat-Signature: uobzodc8dgomkzgnrn8tq5q7w4cz8gk7
X-Rspam-User: 
X-HE-Tag: 1784675269-393388
X-HE-Meta: U2FsdGVkX19I1xRnVrmC0rXxNxprWny6u5b4kTJkKI6uWsvbxuBZYBavV650pFhPz3nlp0/aLsdPQerkgOalc0wQmp153DKQVLtyYD18p1rP0+OvgYo0d46ggG26wo/3VYDMdyvab15pHPglyfjo5+MShLh+jMa+BrRC4rKoZ3Bnsnv13jIo89Y3dU+u3NBDxOqcVNJt28J9CO4yAnIDwzh+6kpuI1dSF7KvvI6nOq8Shuf+35dX1bkozRV/uQaLfcDc6ilLAmt2pWSaxMGl5C6dWcELbh8RCvHT8kyusQok2lhJp85G5RCjjs0pppl0LcLoZWgCx5EHn1AvCm3xlyBzRM1hAVB3ySq0lIvDhsqZ/B7h+Uju0m2TFhOoDziWd97cUJw7U5PcNQgTeK/mJAxqMdh2KLRc8U42lhOMc+f3D7dUYAAys9QN8L2buIbs240IbA4Q0gTN4gHISBgOUZiPRqK77CpUpsxtUszFWGL/sWVGh16m1lEBpjm3DWxTk2qwuB3dAiXcoUN10HTfCvtqncxPP4v+8OmPuvHl6fedoQWeBAEJBV6OKxoIo2Ygsga/IXjWxHJm7PF/PR2Hap/JMf0e1yMj5LOs5Vjt6VW9FT9Gp9ZCfu93l95At7rxgq75Le+0Uprf+v+Wkc119CpUR9hQ5AusJSi+CSL8jruH/K3KFVR0K899e0wZAjnUZD6ZYk/CYW4eBrC2KtmUYCsPdYI1WZO0/TArvZzfWbWFE998HqqbcMNYLbkfga0kteFipHaWjBX0odNElapiMzR2oV3fWGpzwSeREiaSWFxTBhXE2T64YCo361EBz+WYGZB2j6bxq78mcGGZ94+wB/ty52Uk21lbwbw+w4JMKcMuIN4iYYChV2bmiveUi1QJ0ImgYWG0nETKF1pzrQ+/ZJT29TPJf8U3/57+3d68JIuM2SLsFo781ncbyU296moWdBOOhXDpyq8SWvTJidP
 Fcuhu5BQ
 niMf6AzGppa+cfCHWw5+eCLwTOmdswRUy3aS6TKWCGbTBWHZPRrzJkktrIz0/bCpUtwZ8SJc0xFy8tmRbCfnhsx5+GgmkovE9QiXfNSy0pLRXYfhvJc6yKH7f8AcGw7FfOAqjQn2+UkGrU3dpMGHvDPVQ9uqudH0S2361hDJURsI6mZVZvw/C/CL2J2t38Zb5qu9HXxWx3dBFTygIxwyix/ayQewa5zmEOU1JK9pH9V6yLLQehnNKNL5N8lpcgmaxzo1DAxx0H0Q8znYIkfHo3jOLvvK0gLzkBExPNzVLyT1HD6D9aKEt2F6sOZ5dkaweFoUUL/Y4EHPZmcg9AHYtEZkSzq29j5OCZ3woklFP+V8MCVxPmfgtWyoLDyvg8c9Unp0TPiXA1EKhKEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for Thursday, 2026-07-23
at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

We don't have any scheduled topics as of now, please add topics!

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want a Google
calendar invitation that also covers all future meetings, just write
Ackerley or David a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

Ackerley

