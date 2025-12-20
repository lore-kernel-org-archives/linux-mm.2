Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE14BE668A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 01:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CAF96B0089; Fri, 19 Dec 2025 20:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361706B008A; Fri, 19 Dec 2025 20:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277076B008C; Fri, 19 Dec 2025 20:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 189B86B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:07:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D33391A03D9
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:07:14 +0000 (UTC)
X-FDA: 84238060788.10.21B47B9
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1678640008
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:07:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=URxwcVwT;
	spf=pass (imf17.hostedemail.com: domain of wangyongfeng5@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=wangyongfeng5@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766192833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AIcfvVbSuZUqyD2Zh9O7AozL9r/sM074v47YJlw3iCI=;
	b=2eF9g9x1rRuBa6/8uSHHIL+aipIvfOpAW4EXiG0tr4VYSHVYd2A0rxruJrZkectJHhLWk1
	FfTyomsfGWKPOyf2GyH8G1JZfJS0rldmPcyhobZ3980cGRQdm2euj9eJzHGmhuep/SefqT
	IUB8oJHZEVCJUcH5kulFVCV/epnVeSA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=URxwcVwT;
	spf=pass (imf17.hostedemail.com: domain of wangyongfeng5@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=wangyongfeng5@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766192833; a=rsa-sha256;
	cv=none;
	b=6UXWRmvUETuZAIHVJupGVIR8DUidjmD7gHTNwQXzVx7g73r8NQeYZtjtcU9EtQ7bM+syMY
	2Y+6BVQgrCQtUTQkLOBkI3TE02oTtmcBc9x2WMp5riW9i6Xv6vMqRs1C5pQwBW3ksXBULE
	0Lr+SgGASMyFC72vPyZdAl0SUhcfv2Q=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b735487129fso412223266b.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766192831; x=1766797631; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AIcfvVbSuZUqyD2Zh9O7AozL9r/sM074v47YJlw3iCI=;
        b=URxwcVwTtY2dk2b8IZxyN+qT39x2/7PQbiAKNEA3MUMt9mvLwmxfksPvpiQLoND/aK
         8RlQt0C71fICe3VXkltXfKR41H9yDd2forTdoM6RIBOuB8viP4IzLUph6gpbOCNxOi2O
         iBcIZMBuzHVpulFTaWw2YYprxZjCOBj24gqFwqw6C9G+hydprOibx+O896Aa0XktARZf
         70+Ipjj7TObQrcmHO+N6WNq+S6V4E1gvcATiimPEKH7A2VMQsC4BN/j0mibJ/9nz0Jn3
         YJpVHqcEK1lt2Oye5xsca2//gom/LdSk2LkuVyy1u2C81nk6aYorIg8eDpZyhjAgRk+t
         2i+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766192831; x=1766797631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIcfvVbSuZUqyD2Zh9O7AozL9r/sM074v47YJlw3iCI=;
        b=sXGnAdTBXEuXEq38WgdoleZ4FV2kdtfDdq0LTO2pPeBqgLNAx+9F0FFdr5ZVKM3YCW
         dvxGuRrb40anFnL+TCV3FBylHUurfa3FT3onVMnWBs+EAavqALxEKLp/iP3CWtNUMvDR
         AQVwDCPl5ZU7g0WZfDrDRkk/Y/DLAyUX1Y8LvIK84wAxcuY7S9ouL9Nsd/JCisF+yJgQ
         roOpkF5z76vkRuZdO+SjFTIV17NU0lANr65MuP7HzH2cdGEPHYK/AKjsqNA5EyQ8h8zy
         KFU60Df5mbNcFK+uLDFC8usSgFRpEArH8csq6/csMF09OrlorCMQ1mL6Q8CmAZ8SWeQJ
         inlw==
X-Gm-Message-State: AOJu0YzRLPmqBYYWd48CJxxyisKtM2/jjgcHblS2aG2oBFWw1eXLlyCl
	o//NZnE0E7oDoS4ew4MSRf7QpxJzstB2k09JHn3vXKNJM1L9rfLEq0AALifuZJTYI3i6tAfgmxT
	ECrDqpZu629JECaIYdLpGK3WVznWssu+XLnklWCdA2lxS+kk=
X-Gm-Gg: AY/fxX5XYYUxOGbggQZ+xAI9mtJvBOVYcKrw4l6Z7EwmVNWIMg+UfEVEZXV60VgHirN
	be0mslt8biZEGqIynVOMYaff79Knighd9wm76jrlJ9itxFug0FcyjYLs4y4Xej3zWzSfp9Ncevk
	+sJGA6RUuiMH2yxnSdgiwz8qvZ61uvVJVip32pP0MUZb0R5RR0Jgt7hZCVv8y/wCI0bpuN0eGRj
	Z9YCD5zVBHbEwOR7mOKTDQMFAK++UxAXv3yPtnhhdU9Yt0B/gmyautSmTrROMpRdfahTKSr
X-Google-Smtp-Source: AGHT+IGUYJO8DLoobdQSx74hLrXY8gnkykDhh9/MpKDFoEwIwyBqFqG19FjeI1m5ajg777Jk57AAb5qGibM2bEMCDXA=
X-Received: by 2002:a17:907:1c17:b0:b76:4c16:6afa with SMTP id
 a640c23a62f3a-b8036f637d8mr480373266b.28.1766192831424; Fri, 19 Dec 2025
 17:07:11 -0800 (PST)
MIME-Version: 1.0
From: Yongfeng Wang <wangyongfeng5@gmail.com>
Date: Sat, 20 Dec 2025 09:07:00 +0800
X-Gm-Features: AQt7F2oDrpuG6Jcx4Wb_o9NU9ULNQXUCpO4ulDqb-0Nva-nV-M6QQ1TjYb8cTSw
Message-ID: <CAAqLnKL540gM6xLZonhSmhO+rWtWPO9_UJSfmsPWjVcTzf_mgQ@mail.gmail.com>
Subject: [RFC] Proposal: Kernel-supported mechanism for shared memory state
 cleanup on exit
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: hnpec8xab1oubdb4tadczo451n63gtnu
X-Rspam-User: 
X-Rspamd-Queue-Id: 1678640008
X-HE-Tag: 1766192832-523299
X-HE-Meta: U2FsdGVkX195Jl11UxytP6R9rfzKc14GSovvNVj0kjY2GbvsYDzvkktul/1/+UB1BV9q+leZT8bnW/L9iB7VC9PEje6EOsJhvPsTkXAdVrO8tgMe4wsVl27ppCFLwJBlr0PE/+EkOesuowoRa0Mjr+IeZTIkzUdHC9yTVIkm2FJMLvyKZqTWs4nCBCbfcZ7M8/BEx8PN7fOITgxd/Tbs2DD0eijHMZeEwepeFOk6bsPsWa8WQ0wfAv1C5x98m7DXvoAA119VDrzolc8u8kz2dXyaziodXNFnWuMU11zeD5nMKDOuiw66qaqVw1C0oK4BzRwv1TtDhVTeRt4wKowJ7Et0B2XI3/wLoLhEUDf7JXZ8yM0k5B4vcV5Nd6kTT669+8RZ2iEOoVE8/C493gfsJvf3hcYXazNdRUu22RCWsfP7K8ebQ3GTtndcGsBm9vEJUWCA+atGqeKzRsoUtXDXNweidxyBGDk4wik7YgUywfVxOp1ZPMYNowBBYs5roBU0isEkGhxVEIUXek1IcDz1PJk9LbumrVNIF/91LYtRH2XbjvgKkB+7Cbng2WKAIN/BKDoNp/5yey+4myvX+Bbw/+fwpJM+UKpY65Zb2urAGtoHYuqEN6vTwhC7SOkyLY92frFHlfIe01u6cNvzvYJwswPwJFbp13+S2llExh7OdwkIkEbBa1lRRr+cZOWBaj/MT1iU8W9TFBnzWYK81aDKBN1GAXxLjyBJkBohPxTWaFNc+X7L84HXZAD/5E9H7A8+2Vs52vlECG2eA5SntPS9AdfKIDukhouoO/Y9h0zTt5DtYinDa6LUhK3kcOuBeJXuLa14BE0zP8e1UQeEoUx1Fm6ec7fOSLXr6K/nHdwHII9P1TlOc4uR9erWdfNfNVr9BjyDTMINF/W0EqyFsDjyb5eG4PrDVwwqjD8pWWzjRvbM8D6tV4eX48MH0Uoa7H7ym2IUNNUHQNATnX/iA2a
 4cDpRS3R
 9LMklJjNT1PcKlS8At7YjBg63CsdwWCoGWrMF1NY0bhURwocOK6BxQOk7mIF9AQueM4cpSCyz0NgKxWWfyoLPQ823UCidq+Yx7DY+OAH1N7SJQeHmcXTzgQuQRkdSEnNHYEV9ov0uPRRvTwJKwnA4ri35ZE5u1LV6fh1lxE1gctPVINHswsr+YPjw2p6Shix/FeVK2Trh2uxLNAwA3xGR0lg4WOLopqZ8PK0mTVS7hny6MemwKMMXyWL527JQTlUWKBnW+JjsSUi5COI3IFsBwLQOHgl2t6nONY09jFeq9eGdMZMf75IRTCr5z+3iQ0Z3wKseWQJE3X++AguhF2oYePiT14VvJKtQkTGG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew Morton,

I=E2=80=99m looking for your feedback on a gap in the current synchronizati=
on
primitives: the lack of a general, kernel-supported mechanism to clean
up user-space shared memory state (e.g., refcounts, ownership flags)
when a process exits unexpectedly (SIGKILL/crash).

The Problem: While robust_list handles mutexes and SEM_UNDO handles
System V semaphores, there is no generic way to perform simple,
reversible operations (like clearing a bit or decrementing a counter)
on arbitrary shared memory upon process death. User-space recovery is
often unreliable in crash scenarios.

The Idea: A syscall or prctl extension allowing a process to register
a limited number of "deferred actions" on shared memory addresses.

Target: Small, management-plane state.

Operations: Atomic write/add/clear.

Execution: Handled by the kernel during do_exit(), ensuring atomicity
even if the process is killed.

Questions:

Do you see this as a problem worth solving at the kernel level, or
should this remain strictly in user-space?

Are there fundamental architectural blockers (e.g., page fault
handling during do_exit) that make this impractical?

I have a more detailed technical draft ready if this is a direction
you=E2=80=99d consider.

Best regards,

Yongfeng Wang

