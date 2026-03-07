Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F5A5FC9EFE
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 13:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67DE46B0005; Sat,  7 Mar 2026 08:38:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62BA36B0089; Sat,  7 Mar 2026 08:38:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537636B008A; Sat,  7 Mar 2026 08:38:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 451DC6B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 08:38:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1DCA14090E
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 13:38:01 +0000 (UTC)
X-FDA: 84519370362.21.4A868AF
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id C8A4714000A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 13:37:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yp+8yvGT;
	spf=pass (imf26.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772890679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRzLVvHgWD93HYQHbQBL1as10gw9qzKkfCllaJztG9o=;
	b=62Zft0LGQbuy+AkxSsaWVdD75jZRcGkJZcf7UbRpi+4cOPo6aIYwmEfE8wKLXRmnmsHG3w
	ZhWgJGAOiYRh867dlC3NviaNK1epkGQjMDPss2vtlHHM6t7yoXCYxUt8LxH0XL7ouoa+qW
	QOLavoEtVjYMSglHI1SHo2z1sS1zvaQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yp+8yvGT;
	spf=pass (imf26.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772890679; a=rsa-sha256;
	cv=pass;
	b=yhTn/mB+KFKtiltOrpsNflOJn2fOhVL5xNuaVOPpY1wNCiCGQvDQr2YqDLxfk+Fjx3+In3
	hFOGbcpSROeFY4NFOkck36hnbrBuLAdXSTxkI2TvYt5sREgTIKXHlViY3ciQinR5rKMGNe
	WLrQFT++F/zxMW6ZsQ8JlCVZVI0jYKk=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2be0711f493so2428901eec.0
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 05:37:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772890678; cv=none;
        d=google.com; s=arc-20240605;
        b=ZQam41SY9ex2d/YXW+TzAbPY3OV4qIncnrTeb6ASv8VsE8fLGVNBBDAZEIJ/b4GSCy
         GeFvH7PJeNAIXkfvxqATnJ5zO4YNZ3ht3EGKYGhF2H0oTj2g6qBZ+urKJ3RUKxLvbLBi
         eHsiYCvnR6kJ7vGPDC4TkWT9xtLGdr0GNqhOw9ad5+wQfV8mYBvTgEwvOnWZMYe1jgbZ
         UYKnhT5gDmOvCYBXvjZlAOfInZbe5f1Ri479sFJAhjmwKkBaHEwneF9Tgmxip25EJOhU
         yUHn2e9lfOSmu8rmzU+EDJWOzyrv4ZA1hnvG7a6Jr28f6pbgm5t7TVqeX4+HhRrMyxnt
         kGDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wRzLVvHgWD93HYQHbQBL1as10gw9qzKkfCllaJztG9o=;
        fh=UQrhBz7s6ob67mZak1bYRBPfkVCOaTNQeERveOe2zBc=;
        b=GIRiB2u+LHKrQ/RGk6H67iJxbIXTNB6KzSyVobZLNx6c7+XFIpHN998ctv9QsPr+qV
         CvklA8wm0iQbSlo2znud578S3Z9cNuzJgwoBsoKc0zwE80Pnw1vOMiiNpfjWGFsg7rzk
         D6o6B3/rB8u4A58wNLLuaCdgIPdydZE/HCLl45gdpzWfsqSCqCEGDkzCTepByMdm5VuH
         RgUW8gtyopONJmAdfeh68XR2gtHyFF7m9pP/CY2ae8732u8AtnmLKt6Q1mvKTnixiX0e
         lQZw/7FCnIGv3fqpFYNaYFWPWNRkDVyZlW2ipmgj6Z4q2kUNCJQs7TrODalysmehf7ME
         0rrg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772890678; x=1773495478; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wRzLVvHgWD93HYQHbQBL1as10gw9qzKkfCllaJztG9o=;
        b=Yp+8yvGTT3+kK+1wI239ZNVLJOKSsLtK2bOagBA6uBSwxsDXr3tTIpBhlZLILY8PT7
         oYZPcjZ+KIaaQFoVZOkrTyTf4cUBRi2WvGFWHWRrKTsuW+OGkreZb13XWwLNFMlPPJ8p
         ke8Mz4ruyR8Jsgzki96cqU0xkrOJT48+KPwBzPM4T/0bQzA1aeZ3tVlqGaLb6mKdEr3l
         14AHqLn9L4sNZP9d39jLiPtt4nicAirR3fh9LrnDi7nYFOigKWwP/hlLksVRNP2n+XlI
         /aEEfyHyF0lnhBnHMB6a4LN+cM1e6oude8pZxkaeVI/mHTD7GdpNw6TqSSc4rsjzTn6h
         IwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772890678; x=1773495478;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRzLVvHgWD93HYQHbQBL1as10gw9qzKkfCllaJztG9o=;
        b=BozpHgyr61P8Psoq0Vg68dYoEamV9lIc4B20yxn4XvbY8CFsLr09Gfx/7IpQYc8Ikl
         CvTzQkxwM7DCobqF7QhQgoNEv7wfmsxdMT+XKg+chQd1ijyk97gsAsiVMh1rl7yrK5Bq
         T+H3NirJAmVQg8kBcuwMrTDv3TRo32j922ID5slsq0CSi1S2SoOzfTxCWTD6vZTb03Wn
         tWGtpqDYGfjMJO73/aOpEdqzLBwTEC99PkJbHmCzg8wpYARO09Gr2CiGh/l1ap+lt8mB
         QQ6+EAxiJQZZ5i2AN0F7lNWO1nyAtEabcwepgOLK9atDM/UV7T+rB9/AwND7pKErpcxj
         UfcA==
X-Forwarded-Encrypted: i=1; AJvYcCXmLOPdDoQJBoyJOQJljzjsOfU61deTcX/4Hb18vy+cln8T4ZKSVwFSfmBgd6ut0YQYnssp4kUBbg==@kvack.org
X-Gm-Message-State: AOJu0YzAiQWFvjw4dt9OgWjv4J4CaHdyMERv7090m7e9Khlph2AZ579t
	0i4tnsZSYDdAtjn0V5TUQHxVChAAwCrFNpnlIa7p7pPBWIjrbprgWBqPo/WwyXl0xK0drCAcY01
	7ahS9AGegmJ2cnsv5q6dwL+VhgWpJ6EE=
X-Gm-Gg: ATEYQzxBaPdHWBWzHkjGjLx2+9SVluQiQIIMV7C3DCFwzZsXCw2uizxatccjFLlxBpK
	ob+qUh9sSQA0qMs/rySOIssehyKKrcm1k85qo8O52F7x4nE9APp0EjVS2HoDBr+KBmfaQExVPNx
	GGkbGiAhXrkep4p4AUeYMHZON5OuRUb7YTV1bYa5mFYzSKh6yOXpcrVdLQbw3RLMldDTBxdEO7y
	FIa8A9F6NBBPvGWcvzljmsdwdl6y6phfxk4IooQvwECjP9olPwgHUP9wQrK2A8sSc4joIEqbpj5
	8VdMPdXvFmBsFu+NZngMVbSyfyGtLgB9UkZ+N2Jw
X-Received: by 2002:a05:7301:408c:b0:2be:fe8:8af6 with SMTP id
 5a478bee46e88-2be4e6f4529mr1593900eec.17.1772890678441; Sat, 07 Mar 2026
 05:37:58 -0800 (PST)
MIME-Version: 1.0
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com> <aasGkA4r56pLqNC3@x1.local>
In-Reply-To: <aasGkA4r56pLqNC3@x1.local>
From: =?UTF-8?B?5ZGo5bu66L6J?= <jianhuizzzzz@gmail.com>
Date: Sat, 7 Mar 2026 21:37:44 +0800
X-Gm-Features: AaiRm506r2slOn8XqCP2XahA-mrOVOm_yyBjDyj8B2uPbMpTlfnoOusq7ajmnes
Message-ID: <CAEgWzV6KLtd+05Q=YGJXWSyKF+UJvyAXk1dhq_a7s4M3h0U5zQ@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix hugetlb fault mutex hash calculation
To: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jonas Zhou <jonaszhou@zhaoxin.com>, 
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: u1bxx3d3wo1d9p5enhdqbq6rhf8krujh
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C8A4714000A
X-HE-Tag: 1772890679-880530
X-HE-Meta: U2FsdGVkX19XyBkpVhYiv1HSWyw7/lv9PcItU23hihW4si+odg1rVqq/b4Sk15XKymQARvIKpn9KVMB2UsqzmpalXQOaVH08qCI1AjPEKM00pZvfi9KcBOFochK61XJExMgW+PdO5XotgWzzuqLf5m39M70PPobOaqFMdAijmh+pXze1Ws3ZElvlGl5j+AYXmFiLNKfUgBSWJH/fhJ7nMyK6EdJTWepXbqdM99t89Fff7SsJtKPEG3BO77kietMpGbSFz8lXnGQsvPgmnoYgr8XfXmV6Mu7lZp0OWRThb5ovMTF6MyuOUQ7ysFHmsHYSEQAP/AJay3ybepRW0ioT5jfjq62GOgU+WZxUMfYNqtwGR/25JIzoMaYynMdwZgRrBNC/6wLEtc7HHg/Nfgs0BEbn8qWVgbsGkUDxngFlr4BDeejCOpCJu17ukVrpyp0sQztC++TqSh29M6HPG/ZX9aA2w5Bfaq6igeqVYwhiChyfIYIBPDl1ZwY1jxpCO4oBk9lOWcuPHlmuRAldnEjbrTSMWNFUJM1o6X7KvW+ZgtK3QnKCg4ugABZMEFs8tDTkvb85Ac9YnLshzdVTVrD1xQkl+utnRbPl/uyj739Xl44mMhMTJXRMW/Ttct5Ln5kPlUbEeuCIY/AXlQafuNp35RQOOfQLhX4gPMdmzqA5bh9m4aCTyUpE/h1Co2TmUMSqQ4jbphlkwHGRVbYPBZyPhTYyybw06Hzja1IMZD5lLXC3dhYIeLq0FlSBl+zSZ4Pl/xy89XHZCxq0sYsEQLt/pCMSAS5ssZC9BqBNL9ikYSOU8hOi2R14f6Xoiqdt4q1u/Qirs2VRIwAcwN0eh6LzbHy4jaHOXAVfjuBWTJ4Yz6jW3W8EhIE5ZghT673UKQe6aTp2UXv1NqCAMRL79cWgFrKj+ZioiWzBIdCNB8yJVvUqzVmTopXxaGEJcO3jnRqqbyVhi2KhFukJpllmJ5d
 /UcuHBkl
 mjrPLYbMdsXansDwXtNEKEq4fjNyPfHaEesy4oO375Ea214s9BKTAC/kSlNwjIXvexAgy8pprtVXVoOuaN0N3j0ndqLY8HxIYMGVc4N5g6AxcNsJ5V6K6bbj6FaciwaQzSCsFgAhxbWUsID2UNNgTKm5XQGL+d2CkEnGPZE8MRtw+KPohhPo7qXgsB+OEewcb3Mrs5uG7Mx2XECIdln9prTNi+nyaGzo7ocKv1BtTJhjGb/LrETZkzKmyHU2FumJj69wvJ0FtRUcr6ofcfcpPlZc7v+PhoAp8440rD8zMb1BEXL8Y/ZNrZY9yhlprjVY1g6pVpRl0qJ3giTw19ZJctl851YEF6Tno5hiBD+nAImeTb3FcYaS8OSvlSkU8PrcLqYIPoYggWU3m62lTFqN+xehvj5+LZZbkMuLgMPFAFd2vJYnzJ3S3anJj+U+IUpmNBO27I9RHdY2YBwdBWSXjnOAJjwqs6Uk0fFSibP7VP/L8aTa3cM0zOOVjvCKuz5zHtMdeTzWBp4unhE/jrtePBmDO4LbgHCYpQ2b/K9fHyawi6xE3n+uEwcHcj/haidRCQTg651jWkGWvsw7YqWBQ5K2u1OcTG8Zbtf3O5G5mkc5LV126YsHfswKHAj3/u4S99NJX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 06, 2026 at 04:53:00PM +0000, Peter Xu wrote:
> IIUC we don't need this; the userfaultfd.c reference should only happen
> when CONFIG_HUGETLB_PAGE. Please double check.
You are right. mfill_atomic_hugetlb() is guarded by
#ifdef CONFIG_HUGETLB_PAGE in mm/userfaultfd.c, so the stub under
!CONFIG_HUGETLB_PAGE is not needed. I will remove it in v2.
Thanks for the review!

