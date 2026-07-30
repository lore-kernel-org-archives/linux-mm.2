Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2246C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C250D6B008A; Wed, 29 Jul 2026 22:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD296B0092; Wed, 29 Jul 2026 22:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEE586B0093; Wed, 29 Jul 2026 22:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86DC66B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:52:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1572D408B6
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:52:26 +0000 (UTC)
X-FDA: 85043919492.01.3FB7286
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id 306B820007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:52:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AvPMgl6e;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of linkl@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785379944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxmpVJvWjMZMyt/jgVtLy2EX2JvxTMqxDINieHaDSfc=;
	b=1eiv736eY1LGmBDr/jK7SX7Tjq/oqIgJBBdKUH3x8DwI7kle/YTtm8UC15w4k6KVoJDPyj
	ZBMyPpEhyFbrV4QrbaE/W5augcLeLzMfH5Zr2Iu/XA09or2YAwtsiWKp5S26xdFFMH/cRf
	MQZZcUuixXTZm4zuF8eq0FBRZ8PlebE=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AvPMgl6e;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of linkl@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785379944;
	b=TmFKlfnwr6uu7in+1dcuUco/ry5Vh449xDN5g86a8wyU0IfwcxJs1WctyqZ13OXe6TmOZp
	HMakNAKn28YDBoCu0cTbluHWIpHEu66AqDpgmB/b/ZMGr53P1qmBUuRrbm56Xl1nofl5GL
	qT8qRbgeg9ZOT42b+1hph6SiWpSsnds=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c10ed63c0so85651cf.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:52:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785379943; cv=none;
        d=google.com; s=arc-20260327;
        b=CgTdeesWLGEi1C5Dmj31/XwPSOzw3jc+8c+C+ItaS4PNrjTSUZ27HzSR5W/TSBcmvr
         QGhm9c8XXBB7o2VsMhURVsF/x53UjvfKo1synZqTJjjldjbhhC9hl6xIYWpoMx+BoLNB
         uLf5xkZEMM/tbbIX358fZzLgtylV7AD2VtRBc6y0fBVvA+C0gaiaLqqZW0NTbzmgRF3H
         7Ejc9HG8/KEEnW9TgIx3lK7Lo/UwX3MqWQ5YpxzBOv1Vajf/oOIvQfAoov7sAg5u19qE
         kuNnIA569UgHOuK7Uwf0myOzB7ZIOtEbEYXua+GlG2dU843Mh8Jg2aUHsX4wT3p9Ep9B
         UDyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KxmpVJvWjMZMyt/jgVtLy2EX2JvxTMqxDINieHaDSfc=;
        fh=bH3Qm2NYzxIuzBK1Cusa0Andjsh2aMLzxyeQ2J+ySzY=;
        b=eVhsevtN4lTtyWrdWEAOkffdNY6GMUGI6nXNRi46Y9hBsfvoCUr7MCE+rIJxX2eauV
         A9DKrU3+6nTycnPnIJfLQ/W+xJMw1s+iL7COu34yIeAhamoJbWoCX9dx3HJnJpr2z0v0
         ccgix53aO6ninEfMx5fHg77/NZOmYtiop8V1NFBpzfMx2DYIrZpOUVQicUjLT5on4BuS
         uytmxxL5/09nMva4Jf4ibQN0Vdu3ZxlV+dHhEPiqf4/LxVUjNWtqhlMzb0WgSr4qj5Fx
         bkI9MWq+sdxhSJYu6hXpaHsEfGnz3Qf6YU1gS6CqaQC2skNtIyCRR/CCDzjF8ttCoGwE
         mEUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785379943; x=1785984743; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KxmpVJvWjMZMyt/jgVtLy2EX2JvxTMqxDINieHaDSfc=;
        b=AvPMgl6e9I1pWQIMlNMNWQ1/5Xj11E2AccD/bFYa8iLeVLkNBHZ/eOtM7LcCxK7bN8
         d+5PpdO4FR3J+pl3ArXXk38zPHQvo7YkMTsoa2loRVi0C/lEieYm7YhVZFnfaI9qA/92
         b00uHbiQUivM24n4BsWP7xicuwpe/roJFsM9L2lTEUWaIyAQgYB67jhV2NpWVKlJ0hMb
         IQQ8woqPKOchHZsiD/otrRh0bvfPqz8j1PTVGlK6w8k7l7T8msG2Sd7Dl+iq7wEi6aCn
         O1gswpNQs1FiA/UgfOuznT6n/ujrbS2/RCQQoHuQhFeHOLAMom1oVTubI0IcPrJ2pSpT
         SYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785379943; x=1785984743;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KxmpVJvWjMZMyt/jgVtLy2EX2JvxTMqxDINieHaDSfc=;
        b=qJI9VHs5frFpdWB+XrEkpjoqJwt9xfmUKtdxSGNDooraJiL3a67PzLMTePHdAuGlve
         +DQeQ2s37Eg5aj5tU+KGaHWBjCwVJzi6f3Q9WOCvn4SPOFBBSOdLutzn+we82mP5Ume1
         FAkGgIiH/eksTNjpwVHdS/rHO6ogyvNP5Tq+e428L6PPp32l/wrTjY6zwIhJrHaf+Q5+
         zOUfTq9xy6PeWwxu6n7UHSVWu08QlVrdfhs+cFOQalxydXTjPT4mAcWgGLfPOPf+aTW0
         +vWScqLj5wBQITE9c2Z1I+ZXrR0fkAFhzTcjpbxPwGdDVrm4qTmBg6V0tOExUWtquwRi
         sMeg==
X-Forwarded-Encrypted: i=1; AHgh+RqiCLwDsgD/L+MEvXWs5x4nukpUhULDgkkvm8bcCV2IxXfRyGV/cTh0ufrY26sAaVFb4JWCOs+6eA==@kvack.org
X-Gm-Message-State: AOJu0Yzh2cUWLXVU/vFE8RYHb0HQuF0DxWKGmpQ4PIc857DS3zzN7gqr
	G+Vw5d6laoE20hmL6P9Dg2Ul9HBmxMUWE97UwGJorWYjrp7qQWQyAVZQO19AFjyD94CmGHQ83TZ
	EQ6UEl1bAaKDcoDgAcelbm8fQ4zxCI3Cwsy9wH+gr
X-Gm-Gg: AR+sD12grtgtUJVgnkIZCaoXh3jX/gVaWM/jz0GAe2IqFyzKmPLOboUvQ+gFwK/p9qX
	FedvrEcC/IWD4vmIsDC8oVU0Swoa28Y/VXM7ZLFwn/f4UtmCD/37EQwhbgf9UNLQ70MfZyVM1tV
	LdWSBZVpJkSbXksS27UHE+F8stOkMlsLv82YucziIJw0TCoPEHKjYXlvVjAg/niCbCssW3bn0/H
	kVW7RDQBY0BaWXxTBo/p6hkA0fpOmQsXhwbxav+cA09payn/GI/QV8GY6F/BteazMVMn3Ybxyci
	1SjsPKLMK/btn1FfS+x9ud13CMTKiZKtw4vD4tB6l9WFfq9gtkbyNJr+o1NJ0+B8zozvVLzyqCQ
	=
X-Received: by 2002:a05:622a:aa8c:10b0:51b:ff0a:2048 with SMTP id
 d75a77b69052e-52b393ed56dmr4235251cf.3.1785379942843; Wed, 29 Jul 2026
 19:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260724014605.3377283-1-linkl@google.com>
In-Reply-To: <20260724014605.3377283-1-linkl@google.com>
From: Link Lin <linkl@google.com>
Date: Wed, 29 Jul 2026 19:52:11 -0700
X-Gm-Features: AUfX_mxpFzT0hpVdDxPUqKHkGPgYahhbPQV0xHfM6lq50s8el3BKANlDBJ9mwYI
Message-ID: <CALUx4KQfyRgG3ewQZMuU4+AMCyrh8+rH=-MOZLBv29PbPcnhYA@mail.gmail.com>
Subject: Re: [RFC PATCH] virtio_balloon: add VIRTIO_BALLOON_F_REPORTING_PM_SAFE
 feature bit
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org, Cory Maccarrone <maccarro@google.com>, 
	Taylor Scanlon <tayy@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 306B820007
X-Stat-Signature: doju3bt9kxir86kz4zsj4gpy9j8xikac
X-HE-Tag: 1785379944-633583
X-HE-Meta: U2FsdGVkX1/SumZW6kC+8xseVX2mEfcGOs8qbXe8CFoekwG+Lf2kWBbR2af3HRWOqV3j3ZAO6D2hl8M004px7T/ouDEfgJEq1VVGADIC0K/6JiClgQJlGxmqlw6jgKRxOI73cImDVuRsE/p+13Fmy+PeKsE5wA2y2GFLJ32Ceu52o7axVDx8oxzhpBw1zJCF/cxT+MAYc1aC6UGmbssgJVOSrYuLxAW+IExq/TQ3TFmR6Uo3ajBENnnNjU/kCgikbycP+3tOqyfl2KFua0EYkZTphMbuRNuriqVtgTgcKVIsZVgToKtoZ3Na3Joa5WdzSJVYkE3pk3Hj/3512z7DA8Ve/mZPNEnj577V47O44xzOorhnAUbj8EpRMvRSgOFAXDhpFKjQUMe5pK5UBnOUGzyeIf+QbaWmEYhcKAVEiPC8MNr4cUNPcg7FnhIvn1AQBpqzTXBN3+HBSvUNMABe7cxl6cykpCPjzZxCpb17udDz2rCX5z27CcdyzOQri1hPah0TBUjPUukYL+U2b/zL6vhQBr5KX28BLsjag5UtFU9+tMX5cAclI6mj9gTbu0y+2dovh9ogv1fdJLs8lqwiQjnnfYTytsc++PFH9alAdnjA6ftyYmLmJXue+1O8HRCx5USdTWxcvUIj0FlEfERkYhlrff/413iQMeu8Kyd6FoLdsitOAWRUwnp8tvOkeirXTWasV7uk+xbY1Y06KtR9N0hZWaunqEnfCJtyfAjfHRm9sjmcnL2Z5NAZgxWr1FPRYjxCDJ1zqXUnzBbDiwtN7/BQ9g8AfozwEMj5gX1RVRDr7mV9ksRQ/BIe8s3z01ftgY8IEp8m3sbYBXP58zq9bWhSgyYieDV3k1FENHUGNsU7eiCTk7qSBOBhb/NkC9bGYJGLvj5k8C/H9991kqBT6o7BNX13POesHKhj+A+sKvQ6uyVNYJ7att9hTutQKgYgxoCImCfy/xFXnY/nsrO
 IPoX1qq+
 YhKouAKHRnaGPIFylJNwGVVaK3ruVLs9e0HwijgUoVYlSiyHCw9Zu37uUnjnVnfaAbOLUYMdz15rd9frDvkg/7ziiIvtyNDqLQt1hxI8rN+3sFUTx3QPOJIUwoiQrH1YeFfbXFI2DXvI70ogqN+Yd0oYP7j3DMAGWeZI+G73aTd7u7ADj5vrbCCn5e+kvJB8Dqzi6F65yw2iyZaK/I7uMUYhMtgLmDTYCTCaCX4uaJWCjUAUAS9/guvH9zoaJ2aMJavuqd2mPavRiCeDfl+qRZH6rtewAMB6AiT4F5kC98ayKTH3Va1zavGKtcqjUm3mEFFbao4QFfTca9FwWUK1aww9dWhz3cNbgDYNq/IStSxDUx5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Friendly ping on this RFC.

We'd love your feedback on whether using a new feature bit
(VIRTIO_BALLOON_F_REPORTING_PM_SAFE) to negotiate PM suspend safety is
acceptable, or if you have concerns about protocol-level handshakes for
kernel PM fix states.

If you prefer an alternative approach for safe fleet deployment, please let
us know. Thank you!

Sincerely,
Link

