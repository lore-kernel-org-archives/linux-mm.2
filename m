Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC5CD116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 06:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139BF6B0011; Fri, 28 Nov 2025 01:49:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111BA6B0012; Fri, 28 Nov 2025 01:49:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027626B0022; Fri, 28 Nov 2025 01:49:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E067A6B0011
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 01:49:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50F3714044A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:49:12 +0000 (UTC)
X-FDA: 84159088944.27.80C27F8
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id C0D264000B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:49:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E8YO4WCU;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764312550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=q3nBKbhWjGsI1f8A3Frg37H1KPv1WKKngUTmjZYjP6w=;
	b=iyyiUNj+fhr7GDRtgQ2te4G+906jRXONsqw+MBhKiXlT7ZoyRN0tEV7bR4LErWGGTPH/31
	B9nYw9ZOoKzuFMN5F1sJF460IH4gXmC1fcc/c8bk5c/iPAgwyVXNBQJpd2PuIGlfAT969Z
	2Rtuy8DPRv4r2VDccBxLd3Hb7r/KlKI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E8YO4WCU;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764312550; a=rsa-sha256;
	cv=none;
	b=Schecuwp95803CixHxwP/H+qtwWeQJbExcHBEcaV44WkZ47Sw1ojZvUbxxIT64auyXE+3B
	b0JBIJ+j8ldTQX31Fbn5P67dGrUXjFksjtMaQx3hpTENTGCDc+n2TnvCqXWnilqqj33Mef
	lcrNqkf3svHHfqgswX3WC6ASl59HWMc=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-341988c720aso1298222a91.3
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764312549; x=1764917349; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q3nBKbhWjGsI1f8A3Frg37H1KPv1WKKngUTmjZYjP6w=;
        b=E8YO4WCUcpQobYL8FqpOYW7BKCZfFVLvWcNy55MHNVJ9Aum3Jt8JuE4hQHNFAQhrmz
         sDw+AqwChQbZfaYCcKWqr2v2L/Bt7Jhkpzh2eQNHQAq0VetuhbvrCDEIk7NsN4kgJ0dX
         UFfVsuCA+Qosg2OzCtCul36+MXitQjyQEdUjoZmXz7CHqV7JnUSmZTipxhQE+zJ5dmnX
         Zry5llPnayagR3O0BOn5N1NsQT42X6ttsBCYKoQ01WLkyzDupqVqR+RMtotlrZYKBi8e
         oVzlWyjHuUxeYj+HqY1FNAYyBIBtxE+Ft1vI3tQHkEH8yFrYWF+DWFOGP9brG3LmsfsG
         BGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764312549; x=1764917349;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q3nBKbhWjGsI1f8A3Frg37H1KPv1WKKngUTmjZYjP6w=;
        b=YtXy20lDFw+GrsKS6lIALzHpLGST3Tp8w+BRU4l227qYTsdtmyfImZoNT2bkbnpxyU
         AmAJrlPq1SQ/iDo1cxzMnoMTq1/I+aArwDR0csr4aWktuPB1m4ShpcXXcnj9XYWKCZWV
         +ip0zBps5wNZLjaOfHU4LtSnh0EFelGy6MiKEf7J/TJgjKtDnp0KwEKHu8Iv/1pFuNRt
         zeia9ceqegaWDXk6rWpr5Ur5blsMW1vWWfhP8Jn9Blvs9U15rtrKL3MApaq4GdDlVLBw
         dBpdKBDrVKCRGVyuCjltLb2njXzHyBoP3GkS1D5qNo3bgOtkPGbjMiEgdvU7AuHo85gJ
         F+Lw==
X-Gm-Message-State: AOJu0Yy1yfjDWPH49eK2b6dUrnj8piAhY+qJaqNH8bf00+m+MAV9X5rc
	VNigP7Zz42j5O5q+t51cor5ROT+X2g15sPniofTKFuhYuE4VD1t+zEdy
X-Gm-Gg: ASbGncvoryNUIpHq1k1D/OLRb86hGhpk2KdGoxSBxirer1vY71MwUzcTpXq1Gh8f0NL
	06ZzubIFvd0Ilsz7X5952bThso03SrlVTxJ58+GajM8H+FiOQl799mH+suYLGn4SethMpLlnZDu
	8gJIc5Z1Cuyd1aP3gP9IKlMb+rKvLYjA7iDuFhR6KwXEszqbiSwX3Hb1wdd//2Y7paoBeyxuPMS
	LYtHvhlmtpoV+48kfY/BbAL+t4TgTmsYmpm5f9WczorMJO9aaA3YB4yNjiT/M/0cNSHW9XzPkE+
	VGxnV4wkJk+qSCmXByOcEe+sd8Ul3/9vBLEvQXyn0Psn6XEkEKA0nY1IKJENcxOFt7Rja8vC+yP
	t7QRgC4Ng0bPVMI8HmSm8b3ZZ0J8e5k2hwkZuVPJyHcFnkomxOW5nnThxTbJe+y5+XR8l0+Plyi
	DBUZOzDA==
X-Google-Smtp-Source: AGHT+IG+VLt0S3DJUgOgmVzuijavKzJxJCzMRYjobHFYCx8VNooM1NPLy8P93aJjkuMvTTzJO3xJvg==
X-Received: by 2002:a17:90b:578c:b0:340:e4fb:130b with SMTP id 98e67ed59e1d1-34733e92f94mr26758791a91.14.1764312549468;
        Thu, 27 Nov 2025 22:49:09 -0800 (PST)
Received: from dw-tp ([49.207.234.175])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3476a7a4c12sm7680738a91.9.2025.11.27.22.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 22:49:08 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v1 0/2] powerpc/pseries/cmm: two smaller fixes
In-Reply-To: <557b5500-412a-4d26-8c4b-147c9a00d5fd@kernel.org>
Date: Fri, 28 Nov 2025 10:35:29 +0530
Message-ID: <87zf86n3vq.ritesh.list@gmail.com>
References: <20251021100606.148294-1-david@redhat.com> <557b5500-412a-4d26-8c4b-147c9a00d5fd@kernel.org>
X-Rspamd-Queue-Id: C0D264000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fumua9r8xmrbi7eozagkgza6fumwhkzi
X-HE-Tag: 1764312550-929103
X-HE-Meta: U2FsdGVkX18CjwHfIRQUcpRr8VqIahMw+Dep17O9pQDW0MvzqCjJ1f4Z/z4WCCb/8faKeWc5BwdAbUiki1s/3QfFEUfZAh5WlY2EQeXthwksVDclDHRfUQyAn2Mi78u2n6IrV87FvSz9L68jw8dkyWZBakDK8NTfjvAqYNZMlzCsz0F2n40U/RgRUHFgtlFwbABTixZygOekpMsp4lsLaxZKgw8uX+mezmeTq/0p8dpSA5uI3mA9WiQEpzWl+pU9CaZ31Q84Je587HGNYcMySGjhl+Oabeb3vVyV3OWUjGr54TCBMmlZzuc2twg5QUI5zHX6wbN7Tig+06LL40NC0uHLiAgR2qZJ3apL3CO2qL7FkMCjAbW/feB+x9cgj/rHoVUGWpJocbL+sWhNQRFDIpvKIgjL59/Lz4tr49ZurTuo5hV0rkfp7MLdZt7CBl7bNBh6elV6kq3MSoqzjGavuNUrxuewHj4vHuYTnQ6FJu4GTAcuz9dMhnJUKNqxZexchn3pIjW02MpAIkIVu0NdkbVQM4+wxu2cTnyhLQWFZQSXnTiRnRxqA8pIRnRWJ1qgHA9SxjsF//0YK2Qw93BaoFim39hSOyey70wy9ajnpT5pCJ7YOzQpOgHoooIrAGStEGbNKom0k5s5RS3CjSmNur2dJFwHcsvPfEISMXx35e4A4BB4Ghbu8q8g31z5uqtUs0v48u/dimR0QbuJnl4LnqZ2mkZdTL/j8/17Mi4qtQ48SYcnq+5aQuJMlT0jDWhfpfqoab4D/XEIt430y3Zar3B/n/SQoo5GrMhi4DVFqWLjoOHp579xboxdFffUQpOj+zumbHn6uGBKvdOUHmmZcSPDRsad8RiTpol//V8iKfJR9B8/JM1e9T4KHxgJwM+Y974j6uk9AvO4oKQEZ/5yAtDvwc3C63TjZIA4Oxcv6kfUkb68B2chG+Z7ShZFX5HSJeyQnHHBeKHBdzPeqf8
 E7mqUKWR
 1weRs1mN/W0r+AP7l1RVvjAb5Mn++f5DGUmchfewlqdq1bbYg62PWwWETzF+hFcKmfsK3vlK7wyXGHCk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Red Hat)" <david@kernel.org> writes:

> On 10/21/25 12:06, David Hildenbrand wrote:
>> Two smaller fixes identified while doing a bigger rework.
>> 
>> Compile-tested only as I don't have an easy way to test right now.
>> 
>> I would prefer for these patches to go through the MM tree as I will
>> be sending out a bigger version soon that is based on this series --
>> I split of the fixes from the other stuff.
>> 
>
> Ping,
>
> I tried to get CMM running again (using the simulation mode I introduced 
> a while back), but so far my attempts to get a reasonable powernv VM 
> booted in QEMU failed :(
>
> (e.g., Fedora qcow2 images use xfs, but the open powernv loader is based 
> on a 5.10 kernel without some mystical XFS feature ...)
>

Sorry, I missed seeing this earlier.

Do you have the link to simulation mode which you are referring above
please? So far I didn't find the support of this beyond Linux LPAR
(pseries), but maybe I missed it.

-ritesh

