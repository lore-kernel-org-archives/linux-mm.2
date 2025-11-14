Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5905CD4F49
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 05:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418AE8E0005; Fri, 14 Nov 2025 00:07:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1808E0002; Fri, 14 Nov 2025 00:07:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2917F8E0005; Fri, 14 Nov 2025 00:07:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 112AF8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:07:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B65E313A298
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:07:43 +0000 (UTC)
X-FDA: 84108030006.09.AB80E33
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 37767180002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:07:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LYDtk+PT;
	spf=pass (imf16.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763096862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=kc5SP3ZHaud5cAzsFrlPvf9GXnKWLDwtapilGbxVFYk=;
	b=DB8ZXEoeOtB4DUxeTduehFyBTJwK1p2JqHXMYMDFNF5fo1LcKWCdxeXoQkFh9XX86bxh/U
	fwiuT6z5wXw+dpAj310vyk5wN8+KGavXKFwCMBajQ3qeQcuUenQyOL1KAK6OXI/1bDMuIK
	aLEmGWhGyzO/9NFem/ngLG1eR1/5n60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763096862; a=rsa-sha256;
	cv=none;
	b=Xl54DKEdAykDSv607rGw82vAbcSAq/xS7OzwcsSyHksKxG+b0k6SBzQo9ZkLscgw+WA0xE
	O5m0dFMWWjT2i3LJHBluh2Jr+r/6K/q/TRWXZZtqxkHCcWVC9r3zM+Kh5HHvmqMtBPm6yz
	QQf4PQjcqPaB+Z4xwGBwposoSc/NGoM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LYDtk+PT;
	spf=pass (imf16.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-29586626fbeso16194415ad.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763096861; x=1763701661; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kc5SP3ZHaud5cAzsFrlPvf9GXnKWLDwtapilGbxVFYk=;
        b=LYDtk+PTqhCZYJARwGr6gTOeqD/eSAPBcsxb6if2owALVLQ1wNSf7aAmLwatCo9X2G
         iqIFuwVrFuPUSDE4do8LTUpMl08cO4aOwgJuPoIjsKkahdiIq1/97ZufisH4Vh2rulnX
         TwFLtayJLwCGyLkyugJUfXdt2jgTJ6wue98cY67YEzNwTI1SimGTVfvljVq1SKSIs8Wb
         3EJN1+dQF17gYeim1jubiE1414O1Q502dM1oI6kzR0J+DD80yjR9YnUcMyT9xPkOXR2H
         E+92ll44mD51Zukuot3lRZmaFSnxpYFh5TukqUvOiGqdqfFLKUVs84wo4cpBmfPM/qp1
         VJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763096861; x=1763701661;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kc5SP3ZHaud5cAzsFrlPvf9GXnKWLDwtapilGbxVFYk=;
        b=lh2eQrjD/cm5U6tdAxrXpLiE9UhdRIXi1Z7QeEpb5ac8RtvEolJfn2CoWbxBjinTvr
         9IHvC7Xtqr7m5/OZgIE4Jx2oGiFeim57g4FN9Bm79oGGXmf+AkQFo8XRId7LDFQkOUPM
         T1ENS4g9B23FJCGfqlYWFwl2iwckjupufmi8um1n8kzqxQak/dWMIUz0ED9J5/BvOZGZ
         i8OuQxI3RQC5ROF0wYrBgFVd0AuYQM+CuItfSDfIykXQMDGLw2hFjjdPDJ02jtv08GmH
         3tZMmpusL3EXsdinRiquXVXxu10GW8XZzwJILB9TCJN5aeMplZBwymFTCSPa68vvt3cp
         PPig==
X-Forwarded-Encrypted: i=1; AJvYcCVsevAuJmQLReiU8V1baO4QW728W5thnBOr3sZZY2rjkIE9/y74e9hRPNgC269f30jND0189CRbnw==@kvack.org
X-Gm-Message-State: AOJu0Yz8SRdSnuDMPdYzgtCXICIRLeoIVNlKcCWzhm4KrOGC4FxZOZxm
	TPZ1KpzlJItm+yTYpIucS7E0k2coUlPpIZ3CpCU+o7OHWb5oQY+oQWXu
X-Gm-Gg: ASbGncs647bh2h3cxR2lgxHiUFZpFai4BY0dbJNHjmM0qGx6HyxJtiEDi76pGWbj8/F
	RP4Vm9OW/KDcTXxwaftCgwx7LnKTWPg2Osrnzgtj5vs4iZfcPXjHaM2jmcDDybBiliraNlnw6DB
	CqrVSyRbSjfyDIJZCs32ktNZTp2So45q6IZHsQ6Q9BUJ1BMtWfj8IQDk6KWJTOvBkW9k1yH8iwr
	F7eSQ+VbKAppC6rZ4VV1haKa2je5R/d7vTSznTc9bV8mK+nrlFolbs/jc0fO8CSB3prR4xvpx0A
	ldcqR5SRmYfvyR47qePVkoiK8dbdKu6dXtFOdFM+fgTOOIcpuojYCyX/Mo/YeEdWRboEwK293UX
	dLoxzVZ5xGFqQS4BQUfN+G7y0ZfPvei6Ol9SM2C10AYrkJfDAYM+wgSwKDsI50V6pJXBN280=
X-Google-Smtp-Source: AGHT+IEK285v1wC2XvzGikqccbF9tOIC6uZx3BccuaEpsjgYn5FPyTQAAYCs+R3hkEKMpO8EagDTJA==
X-Received: by 2002:a17:902:ebcd:b0:294:f70d:5e33 with SMTP id d9443c01a7336-2986a6ba476mr19617915ad.12.1763096860963;
        Thu, 13 Nov 2025 21:07:40 -0800 (PST)
Received: from dw-tp ([49.207.219.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b9250d195fsm3835410b3a.18.2025.11.13.21.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 21:07:40 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Matthew Wilcox <willy@infradead.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, djwong@kernel.org, john.g.garry@oracle.com, tytso@mit.edu, dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com, martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk, linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/8] mm: Add PG_atomic
In-Reply-To: <aRSuH82gM-8BzPCU@casper.infradead.org>
Date: Fri, 14 Nov 2025 10:30:09 +0530
Message-ID: <87ecq18azq.ritesh.list@gmail.com>
References: <cover.1762945505.git.ojaswin@linux.ibm.com> <5f0a7c62a3c787f2011ada10abe3826a94f99e17.1762945505.git.ojaswin@linux.ibm.com> <aRSuH82gM-8BzPCU@casper.infradead.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37767180002
X-Stat-Signature: 4679sdojbn6ktooxrzycboifywmzyh8r
X-Rspam-User: 
X-HE-Tag: 1763096862-218719
X-HE-Meta: U2FsdGVkX1+iGTNf4zzf182FK0mXlJSQz7rNcqhl7ClnEU8C9FvDJ9WGxDxv5X4fW3xJDTK8red5DWA6NZ1xrIAUJW4Potv9S+umoqXNky0/MW1+pj9UakVNHyNxq+NvrbSLNwA+JmBHVbbg77MGdOkNycaxGUy81ZkHa/JF4A0ZWfn2/wJAWM/5+l6ZQYtnsLvk14tH/IE0XV8kUIuDf68O66nRDNSVdq/72yccNP4aIhwK7mc5PgN/RcEuosP9qdJnVXKEGeUEHv/rGvY0WEHFeD/eo3E8OO76uTB9bK8k2vHXjnbKBf9f4N/vg33/3xHCUx7VvrrF5KvlUZQPZDxdwD84ZpAK9PXnmTq7+HRG+o98FGYsBMR+KmiG+uBsPcqyNKH9W+bvkjsDJ8DjsNilVD4n5kcRfx7JkVSm/jSxNSvbRC3SeiGy/asBU8Pr/hQNkPC8cV3fDx027xLZy+Jndm0+WfEVMlrCiRdQBV1QGC1tUn1i9pa5fPA189lylF8lOLWntyiWRZWsZilHwV9UvAliHTbHZHS3YeOHcJ/n4j0yAdkgy1n5OHV4lkj605dFZ+9kR6D94hYEedjdChDDxT/W1oM4eVKgVoq2Cs2IxAbTdzn0fhF4Tq5Qx9HPNAxndA577if56AoMs5YK97xu11u8rPICbkhnoXjMRuGZvFDSXx3mTnvWmwbgw067bK5A1IsvVi5jL2hhwiQSTNdU1SBA8uxCFYKBfAzpDxru0/6GYQ98lSB4GbPBII5r+nSDx1S9ebfYUo/eJIQ3u8OUZr/PLFKeiHribzYdPjRm0seAU7+ThdZixZsFGnLhySL3B/9wzY9yWL3wGzuViKktCn20PSBgglRoVM50n0P81Q7IDzEEKJu7H3uAQNBcY2wQOj1LJaseJpVgNRymvhLN5JP8xxKiGW6ndoEBkRuGBlSTZ1JezHOYaieigd1hXnDBdvxcXuSFjNa9gVe
 Z1aY3eGb
 DRlDPQwLkXFtBR6o3OLMnzPJLbtRizsbgMaXLwefacT5jc9LWoZLmO4CqgQg4MU95jEZOkceimWDJkrtZUPlDN1j4uGcrOhfSbspc0CJBqMaNh1Bwfulu2Lijzyr0Ti3LlZqC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Wed, Nov 12, 2025 at 04:36:05PM +0530, Ojaswin Mujoo wrote:
>> From: John Garry <john.g.garry@oracle.com>
>> 
>> Add page flag PG_atomic, meaning that a folio needs to be written back
>> atomically. This will be used by for handling RWF_ATOMIC buffered IO
>> in upcoming patches.
>
> Page flags are a precious resource.  I'm not thrilled about allocating one
> to this rather niche usecase.  Wouldn't this be more aptly a flag on the
> address_space rather than the folio?  ie if we're doing this kind of write
> to a file, aren't most/all of the writes to the file going to be atomic?

As of today the atomic writes functionality works on the per-write
basis (given it's a per-write characteristic). 

So, we can have two types of dirty folios sitting in the page cache of
an inode. Ones which were done using atomic buffered I/O flag
(RWF_ATOMIC) and the other ones which were non-atomic writes. Hence a
need of a folio flag to distinguish between the two writes.

-ritesh


