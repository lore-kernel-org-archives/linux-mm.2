Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FB1C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853296B008A; Thu, 20 Aug 2026 03:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803706B008C; Thu, 20 Aug 2026 03:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1AD6B0092; Thu, 20 Aug 2026 03:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 494E86B008A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:56:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD3DFA3475
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:56:35 +0000 (UTC)
X-FDA: 85120890750.29.07E0D9B
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0000040006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:56:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lA2kV1Q5;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787212594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mkIJqeI5lb0TvwcAO/Hc+RpTXNevimkR7Kn1RSFWUzY=;
	b=I2pLB+ghQYKvrZGpEMIMPYWdxLkfvXQfUPmLEkD60npfvSUFZ2o3WugyDyx95mj7UVQo3p
	wr/3z+MP8bcsXWoRv6MDEzL18s9HYFLcQw+cSq6it/8jWZ2KqDmtDHofegwtQPC01ZU9Ow
	kIJf7mDcYvunHGOVwc28mKxGCYiRSCY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787212594;
	b=mOY6/soH+It91TT+0bhgfMDWBqNNgH/K4UfiTA3PytRNOjyibaiajZCM8kl1pXenlWoBpv
	2xhVMqjlR8weoWYCCFe1i0q29TmVFPm/P686nyiToR6fWrqXW8ixBVSq7OSsEOzUSdk10g
	XumPKVMzQtlYhvcp0KLzvzEZrBc7edM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lA2kV1Q5;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84eb992a881so1568968b3a.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787212593; x=1787817393; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mkIJqeI5lb0TvwcAO/Hc+RpTXNevimkR7Kn1RSFWUzY=;
        b=lA2kV1Q5f1q8I8bNIMB9boxD81zus7TQD5zEWv3x1H62fsxxDMiYWRS5ocUDmcwACs
         ak0WV0UgFfeaM4q7eREIuPSGxO1rmLBTVrq0pQiE4gVlDKk23EcOkAFfrdHM0U+dxQCg
         sdhnXvpMmKi1K2WlapFaP6O28p4N7ZfFsg+ILi9HoBC2AwnS5I1gOMhg0jL1D3Yyv41i
         ZmahcYP5CDhONVBtFk7crjNazNmbLtLr4hoZQ7rmJws9LkPljg2o54EbWvSll21akc8R
         rbTXfzLAnCziIXnF6svBh17P1wRzypCl8IxZrr4m+saLm661Zd7SaOzqCXxoMApLxvO0
         80hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787212593; x=1787817393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mkIJqeI5lb0TvwcAO/Hc+RpTXNevimkR7Kn1RSFWUzY=;
        b=dTu9UCMKRI2RhvP7R11iPEO82tVn+hmbuxDyL2pZhilLvJmTPwMExmYHLE1aFWnIOL
         I9eZ+0EvEKsl0i58KL7gvm24l6afGQiKyXiw07bX3k+ICTDJcq6eq5ymRGBhUMdULXEg
         2aL31N1P/5OO6lvjDNFncWatcqDvxMZFwABHUOwFVQy8kBw9sf2ncyYhYLx/KZGAOMKi
         2E1fa2w/bjIpHauKkiXoTp99memQSrIT+aG6ujUWeSWWoHjL3tU2SRQ9c2oW7ItO6b2v
         pOHu71EaAz84Kj+DXa/c/vu5O/rDsr7a9ZV3OyQG6BWVVKo2yDyc08fBCjZwxOUzDTtv
         I83Q==
X-Forwarded-Encrypted: i=1; AHgh+RrGS3VoZDzSYvn4D8LrWgj1xU8hduNOfMSPz0D1flYBj5bvkvmD5aFKN4cZ/VnUYoFB319k8Smv2g==@kvack.org
X-Gm-Message-State: AOJu0YyW9slAteNDr5OPIFaz6DsH7ngfoNk1l2FrXP1q/GFWKtnTxn4+
	lC3JgsCvCePmBHb2/AQQyvSFSD2/3wChkdniTXGQAsw9F1tEesA+6lN4
X-Gm-Gg: AR+sD136pwSqt/dm2VhUy4g3rzgxkBLe/RQ6qIR3hVID5eDlZM4HY6RykSCojlNxFnS
	AwRNq6F4Icjyjau1oU3thy1h5Ngg8zIZXSe18KGyjZLadXxMPB1phAczRCsai34hzNf5VbDmpP6
	QjBLEq0QMXjDG4F/T2TqtF+P4vLkvk9ZPCOra1aEhZ3VNSWay3reCNdCtaD61R0/rFFbd/pgKG1
	0v5dUzBOgHdxQ+/yXjoSFfsrpTwuSEb22NlApXCO1eE8TOKFPoPINU3vl5oBAHaUHqppc8ZqX7+
	Llw0eLpr7sDByJ/pIwBuACph6WfFDFZnNzdQR+++1LmH5jUCtMGcufd7pvTLKPs8OgM11TVqSkO
	UqjPrHDiFm0azFOOPDocVhNvvFV/HebU+xf1qFQ45YO3MtEOymT4k0laiG1vtECSj1SZd9RimB7
	yhOULhyyQvp2aTPE3gw09rdka7xMAMeAZbz+j1lpAYU840AN9koJ1Vw3sfqNnWGvdWsYI2t6QQo
	lZx2Ln+MJpdyyLyenE2rW1PIg==
X-Received: by 2002:a05:6a00:94f1:b0:84e:24df:3870 with SMTP id d2e1a72fcca58-851d3488537mr16682622b3a.0.1787212592741;
        Thu, 20 Aug 2026 00:56:32 -0700 (PDT)
Received: from localhost.localdomain ([2409:8903:6320:18d1:7d9a:dd79:e573:720])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851d3668afasm1367347b3a.48.2026.08.20.00.56.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 20 Aug 2026 00:56:32 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Lian Wang <lianux.mm@gmail.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com
Subject: Re: [PATCH 0/3] mm/mglru: clean up isolate_folios and scan_folios for readability and clarity
Date: Thu, 20 Aug 2026 15:56:03 +0800
Message-ID: <20260820075613.99377-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820045603.68809-1-baohua@kernel.org>
References: <20260820045603.68809-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: x1jtyxeb14g7ize3mdx9y8u16arwuf7x
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0000040006
X-HE-Tag: 1787212593-555531
X-HE-Meta: U2FsdGVkX1+pZY0/rEAbAVf+eUQJ2yDX2v+P3ULmwK1jo8At+hPxIjKxmyg0UN3lxFbNXRiAcdeRdslTHUHLEfZAxxsiCQ2QzrmGj5xIf7udQEwaN4DZBIvgblO9pgVzWjil4J2pDwHA2HAR/DjcEjus6yUpM+QIkvC4ppwnmvDajXn6L9+HelZ7ukYrb8wOpq37RFYV4tJ1VLmRHUzLBdpKGXN8dbwTBQ6IXmM0/kZVE3PcGt7UkBwdCYGHOiBslRqov0N/ATmhEy4yVKo7GxN4QJeKvveRElJlOR/zh44HCj+gicrj0aYp9fp0pAJQmvPxzb0+p9U3tw2V0RsMN+jncRBbSs9yNVo0BRqFWJTPmmPWVCdHn7gyh0mhQufrMFePGDsb6EPmcJNcgL2cuTv/XtgylW7At0OJt2fobSFT0abY3l/sVKcX4ciY0bEvRtEYIeemlFR1HTfm1GbVCt2fi77IwubmATfwLDpk0IGK24SPeV99fK8mxFY5e8f8hoHcci88JMlTi0l+TiM+dBcI7fBtp5x4z4VahgsfojwRVuuV0lJBahZXC8safa5ogEZRKaVRAC6kQ3RtlY1ny6jYadP51Cm702o6Cfz9DZtr1t/DK6+DuaGJQ4S3vMKmCPn50zZe5b8tIgquA84QPRj/02qvOKxZmZAEiDloWM5CgFLV8419GQikYHdEK8oFefwMUuHo7sbMw+88C8vgS8rL+6oVSxBZId+yTcsN4kNcPEMjLjVRjnIZHoNIRFMGjAU7m/l5rcX3Yxg23+HpmUcfsP5UirE49sZyRUfRIRrI1Bmny76uUJtNG3Kd4K/3kZUKgIwBw97cA5C/rpCdq2Q6gmrQYrmbT3Uz59nUMmWfXUzWk4TiRuBzTAx+0m7hgwyHJWBGkRtycaCKufGosRNALXC9fJ3XaoHTM34EH04+ptLIzJNPo0uNOvp5HqdZhUQu5Xl/Rm6nNlDlyO7
 QSlQrAfM
 Rka8TT+Xt/qwDWhPtMNvBx5rhGaC1NFPMIzryyTyueYg9PeXgwt4KIoXVxzU9BCcSqAjS/DoRioV2vNt0QScKmYo2o3C5OuOPwkn0DMn9V70PR+J1FFLAe5+k1+W3UeuZfw1JFR6b7GakuYedW1/X9khP7arnD8r+0BMxnLRTEKA4vGNNulXziz02s6ZGtXPY6m3mtAQgcM1IsOgWaGsewAupPiU2FLB02RmyVef3NmhoopCFD+0QjlQvP8X79KF5JR4KGiLMgH88HOMG+ujinEt0xyQHMSB29ce5pOeqM3wJxQW6ZU9V7a0FbYfFUzyU1V2O5v4SFeqCpmgssyozbYJ/Q8JVy/FHTG2CyTAbuk+/zpVcYgQmmS1nBqRbgB596eDn6BoB0AP5GCcIqKXnUzFQEERcQMSOuXybrZjy41qEOChVVQJ3ObQlQJKDSf95K14GOrsY9MMM6GYdW1QUCitnKaW7/IIArCzF9BVy0Wq4HZCloNH85n3hfQTgwQB6/HdB1oT1wQ6zkwJxp3FZjwSoxwBwmJymZiAdtlm89eJZiTRVCUPIkMO5Pgc9PTy5PMc45pYCF+ujrT18arBPAMMkiJ2bfbMydzWbUD9iTZWIewk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lian Wang <lianux.mm@gmail.com>

Hi Barry,

I went through all three patches. The explicit fallback, exhaustion
reporting, and bounded retry make the control flow much clearer.

In particular, the exhaustion check preserves the early-stop cases and
avoids falling back after only the oldest generation has been drained when
another generation remains reclaimable. The retry is still bounded to one
extra attempt.

No issues from my side.

For the series:

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Thanks,
Lian

On Thu, 20 Aug 2026 12:56:00 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> This is a cleanup series split out from the MGLRU swappiness series [1],
> with the cleanup changes separated to make them easier to review.
>
> This patchset makes these behaviors explicit and much easier to follow.
>
> Thanks very much to Baolin and Lian for their previous reviews of the
> original RFC patchset for this part.

