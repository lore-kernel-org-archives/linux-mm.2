Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B36DC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 22:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081E56B008C; Thu, 27 Aug 2026 18:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032586B0092; Thu, 27 Aug 2026 18:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E638E6B0095; Thu, 27 Aug 2026 18:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B26746B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:35:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2401CA3371
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:35:58 +0000 (UTC)
X-FDA: 85148508396.21.3872C36
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0E52F1C0007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:35:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=LVHTvNQ+;
	spf=pass (imf18.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.214.170 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787870156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MoeD6WLey2iPImsUR6TLXDfulyi5sEhqEwHnTLrN3cQ=;
	b=iV/tixB06jbKWPSHZ21IujAOEIlkJDZwfkB2r7tvywv71mqk9bIFv0JsB+hczRNdtG/GG4
	8kbiua7Y/23QxjlHE1A0nXYP9XvJQfhAw1hOk+H7WfO9VqJCOtJjrBL7pI5+qQIQGyTzNo
	e5NIp6pj2VNN/gBUeAtEjZd9HDIEtg8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787870156;
	b=h2Zm+MJL7rU1r5UL4JECAHGkLIAnVqQq1LK4inC9rsNZjzliMqxp6l7kE2/cj4sll8E2R1
	FkUshHX8nsX0MaxGnnJYvN8oq/SsLmMCqxUrGYRAb3eORWqDW+QhsmT3/82fL/xbejg6Cb
	CV/lcwN2zNsMrjcDnQj6bcubJ7o4Aiw=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=LVHTvNQ+;
	spf=pass (imf18.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.214.170 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ceab75934dso2082825ad.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:35:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787870155; cv=none;
        d=google.com; s=arc-20260327;
        b=OqDkdeMiEE06r98b1fSCaaPajzm5mCySPJ3AZsFGuU6xR/bzGNmaWp6pQt9v/inBTo
         AFpRwBA9xye+c7NFEs6vrEPLxXruf18LVMWfQiXeb/1/MydDLkpe+bh7pjjeNQlsN/x0
         5Je+QFPjA2qCt0C/Td8uPWzfZiW2kgIWrh/DhBuIAIZlJmbnp54+JbEBiMZx6gX7a61e
         RwcxHEeq70GsgiaMjd4JdY0l+1w0uF6nL8qfh3Y8vy3fGb7PQRAfan5x4wFovqfEkUbv
         oO3HV/28UG8k2pG+4tGQLVv4Dh+LCuKPXRej1e2NtUDlnwhExoqCb10WRV3uInUk0mrZ
         cYpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=MoeD6WLey2iPImsUR6TLXDfulyi5sEhqEwHnTLrN3cQ=;
        fh=9MghNfmC61BE46ukO51qyUHib7B5nlbz7EU30RndqlI=;
        b=B2K6fSTttc69/ATQPzKRS9LqiMarPbqEL3i3QBTcIUjZ8pjRv9TgxvVnwkE4SfIMvB
         1I2+n12220lIGbK3f4N2V20seg7MOgZqBLiXmnBGDSpKC4UmvXqvoGACz1y+e46yXVOI
         PlKhMj69Tn0Xk8Iz00DGqjvFtPV0yMih9rddMY9D0KKriTybfTyaNLdtX8faH42xRk+j
         qTu3kambGKwAK/iBiNsLoGB4+h0yRy4dO4vaJ0sPXhu3UHAPuZ2RZbhWm88XQ3S5OM8T
         yGmTbBPZfV67v+/NfRrNkwAOOHguF9b2M6213Ix43KwIDP89cvF2TMtUgHPeDhTGiqW+
         uGXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787870155; x=1788474955; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MoeD6WLey2iPImsUR6TLXDfulyi5sEhqEwHnTLrN3cQ=;
        b=LVHTvNQ+oBSjl6En66W6SebRjX44IwIZE2hrvXkv0MNrBZokY8ccJ6jdP7hAIrcLiT
         90U0epZBURYXye0xc7dJXRrvYHqJvHoyAMOqNEgLwJmO50Y7Eoqe7ZNk+ovY0+Y0tOsZ
         Ba8ETuHksfsbLtekit/wFbkr0R1RDcAD3Vvaw1SQao19KfuMeTES/m+3Q1Zh6da7wgIx
         NGmHsOVX9VmNpGqQYHs07CDo9eFKFk2GdjB22kLB2IZjityaI1e3R4HUI9aFGXqgJJpK
         ZlT/zkzCHdKoOIla7kJn1rGkwjSCgHySgJlm/ZPv7Fq8QZKfvImmuSS0Se86mz0CHCUl
         x6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787870155; x=1788474955;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MoeD6WLey2iPImsUR6TLXDfulyi5sEhqEwHnTLrN3cQ=;
        b=Xpo/8Yx882ua+Sqj0FEpNKKZQ1bV7vM1JgDsDzrAMi/taqLejUypJThFgAXk8SPnOx
         xbxMsHZH/54yiBA9/JikQ8Tcnl3vPxLgkFgtsW7EfIgBpGIQ6ktZTGzTafmVTi6XJPyC
         1z98vtACnHnStUG33GzgZYEYEjNlFxcmE4VtFm4lXigIwfiwMl2ar8hlrgWBeYR9qNLH
         S7EHS+3r/pM0bHm/W0mkfWjZ5CyiDYEIZQrjZCRkmZ9AeRrMcanXeyjgIYtJYWup1UfW
         QAGaR8AL+TnwJPMH2tTTvm1ShCaiYYhoCP0RYI190VuvQcm7W7hMPTApU/aeUSImblHl
         j2eg==
X-Forwarded-Encrypted: i=1; AHgh+Rrak2uj3u9Iu3ke+G3kAX1esSVdgrMxR94oHqGmrF6/M+T+2sY/rRJHlQpFC0xqlkT85VoPaS7zgQ==@kvack.org
X-Gm-Message-State: AFuF++lHvykzQDTg8FWJR1GwxZuDK2Tj6z4iSIn6mNBQIMDfEvNqT09d
	Uc0/91FbLmAi8FlclWo/VuRIWIndwB8WP6kMS3Sh8EE4+pmHk+O96aTcflhBD21IEnO4O/HLacU
	KcpJlTqEcg5ugx8fE2naMb54uZ2RDheiAxkLwjpOV
X-Gm-Gg: AR+sD11K2q/2z0oQ12VopDGaBjAUSWcHwgTbvl67WIknzipdIthNtEktzqOnFcuKgTE
	V2bojReS2BdPXQbq1gUKMRviP9jIXBRoN7KrndHm/DxQty54u45yhBMDL68mpwXLvSPPJS6KVp+
	TwwNQAoY5HOOgPkmezsF8hY7GpgF3F1Mu8USFTCDnQpLkMUGqpXz2u+d+FfGCxBYYCwAdtUeXSB
	N+DkPjOGAOVUphY8852TzG5Avwaky5TGXWfDO/aARc8/8P1FmloPHADaNdpQjSiuMI4cZz9/3Ru
	pcvAwPJXMMNp9G5ixBFYpoBzpR9sSdvWCkS3krcyJFT8AFfopsGodfBoDSi0YH5awUWds8zV8GC
	U7rGe+MKnTM0N+Z0l560MZANxNXkr/Qtw
X-Received: by 2002:a17:903:286:b0:2c8:248a:5dbb with SMTP id
 d9443c01a7336-2d74dcbe867mr43946985ad.7.1787870153630; Thu, 27 Aug 2026
 15:35:53 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 15:35:52 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 15:35:52 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 15:35:52 -0700
X-Gm-Features: AcwNN1WN9_5wnj8R0zXdgU7mM5B_PNMO1_m9fHEFXOCMJ-e7juPFtPd7hxiDQzI
Message-ID: <CA+0ovChCRKkAga2sWaNCZms8Hv=2+5gSpQfkaN0eePs7eWPXrg@mail.gmail.com>
Subject: [BUG] quota: NULL function pointer call in dquot_acquire() with QFMT_SHMEM
To: Jan Kara <jack@suse.com>
Cc: falemi@asu.edu, Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E52F1C0007
X-Stat-Signature: 8eu581m3tis67hxx57ksmr61tzy1qei7
X-HE-Tag: 1787870155-620085
X-HE-Meta: U2FsdGVkX19tTyMHMsOg/AyEbcvidYshobfufW4rNuSJPNnP3G36MvR/9g5PgGVYDi060W068K/P/Cb0uiDrQWU43Y4bMd89BNOqt67w3tEKblMrbmmCNdODI2g3wlhqkX5Kio37Nm7uPUf0TvCl6X2ubfiJzHWTIZiUYv7SVWPFJB37N2dGGaaGH9qHl59UEGzAGEBJgcIuR1SGlSUTZ1CwzrZ8pCSVQGJxsS8+NbEgFtkjvvwiLK+rnagzmBdE701VaMTyqqazqeUdRmdw894tfp9d3VnFi286l3uX/1cLWMTrJp2cicA63vF/s4Z6P3ZdUjsAR2QYaXyKa4eTCIRGQ+RJH/LSKaCa9NGzBrO3rFhFGCsJxz0pFAAaUSOG07y9I/Lqe/4jQmUvq2k8JaPF8QupJkiVrT1pUDvcBkVCTQwRlWMPTEE87biHCLQ7NWwSQfNiNQCA5CCEOQfePOE+mHVOYNgx53ltfzInNWDN9EfS//Tk29LyM6Y27NCEp5PnyQpiwnknV7oL+cWb0J3Wla6U1pECSwLN7f9XkCAAgSlMNcbkhnGqEsLZUPnSFg2vluGk9COC7xI5xWpKY2BllgvkqVD1J6JcPHs7WYHfYAOElUh0VEvpaR4y7StBD1NFfmLC0j+9a7wPOdErYJ+ljXz/Frcr3QNupRI+KwY3Rkit1/ERdenadLi/AGg8igEK45Pt/EhDm84g1o9KXMofHxc+CbpFJRB6PW2ttRrSND0FzXV9Hq7CfzCPRwEGFzKwlYEby9nf1m9VgNH75QTUoyaoVGPUo9HJD6yhidaDWSa07HvgffNWC0/iA5Z47JMoQd1MJQi2xW9F//MrC2l1H0UfwP7LmNR16MkQXDV37NYuotEW8QHOei2g3aKqtGMMq5Ll6m5qYQWU4nOjK8M3bLMPAChkkzgidCnQjYguq2XaixYuj4BQWaEhoEm3JdvH7+AAGo6E3z6UXvd
 jpD8Qk4H
 EqOj+8zOYZbAA/gGRK/00VeX8mdl3QMsTo2f1F9M4BFGP7GFkGQaaKLXX6WxfOEN8boocOTnqBV4CcrWlfFKMmZnEmq2mAbmKc2tXDC98JKl6JQV/Gk0HIFeJATs7RQe4k4rv96hZbSY0mtUeexjebLQ9CRQ0T25S13rP+95dupLQB/iAizhj6BTYTNv7eNXQOUHffgMXzLRasZObmeCLCsJCOucM5s0at6uvaS6JDYSJ02zg804qXs6fhx+d/SZTEX/XJpVy2Wgi5sSnvOcUPA0gHSlH2/Oi/AphX5KQfvvLuEO4Ufip8403V6gk/SjH6FvaA+LAd7yRI2K/cz9hGNSK8zu0lRGOfKxrzQVYZ4wArdFh29n/XjyrdKJlAAg3Q7NRnf4aHd0dz1Xxt+kMXQ4g9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Jan,

While fuzzing Linux 7.1-rc5 with syzkaller, as part of research at ASU's
SEFCOM lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/103-quota-null-func-ptr-dquot_acquire/

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor instruction fetch in kernel mode
  RIP: 0010:0x0
  dquot_acquire+0x175/0x610 fs/quota/dquot.c:489
  dqget+0x795/0xed0 fs/quota/dquot.c:1002
  __dquot_initialize+0x3ba/0xc60 fs/quota/dquot.c:1530
  add_dquot_ref+0x2ca/0x3a0 fs/quota/dquot.c:1073
  dquot_load_quota_sb+0x873/0xb40 fs/quota/dquot.c:2496
  jfs_quota_on+0x2a/0x110 fs/jfs/super.c:803

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,

