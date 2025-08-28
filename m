Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03ED2C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F57A6B0062; Thu, 28 Aug 2025 08:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCD26B0088; Thu, 28 Aug 2025 08:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409C06B0089; Thu, 28 Aug 2025 08:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 306156B0062
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:42:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D278BC018D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:42:41 +0000 (UTC)
X-FDA: 83826130122.07.548DD19
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id E40B84000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:42:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=EM8EyUdK;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756384960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhpMCWe5V/F/7PAyzm0puD9kBtIwTfCh1oTxflApNds=;
	b=XvmPJQRAtA5ydvfaiubIZuUnSUQLMsQChn1SWnBQHb6yTC1vTPt/hqpxIXZ8Sbf2hdCVsa
	1zA6xGxPBKByFdbofHPOBW9nCt5J4AJ2UtpG5Pmw5sOB1rJaJiHoBg6u6LQ86Z3K85pUGe
	UU/XZJQFnv0k8ujV8hl6wCliIRsjiMw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=EM8EyUdK;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756384960; a=rsa-sha256;
	cv=none;
	b=Ce8Qi/uA5E5aOlB87o2spKFU2cT2FQs+zu2c4Kxs1kHtit3MBMx9nkOfz0VMigfMzlNP/7
	dO6TxlTfx2/WcE2/LUPd3kTMUFnix9Oksf5arN2Yt5xHJumda39u77Lp0zvWlr5d1oNZjs
	YvruZQ6Sqz9YsY399NjL0SClQ2k80Mk=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb78fb04cso139372066b.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756384958; x=1756989758; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GhpMCWe5V/F/7PAyzm0puD9kBtIwTfCh1oTxflApNds=;
        b=EM8EyUdK3obnyyldYw7QNiLk8jIAtCXtwk7U/E6bqaS17YjoN9mQ9FDh6AaeeWGG8o
         QTm1hB0B7+5/eqlRSnFIWtbXvlx2LsGyb9LsoBDFz6o/95RgeVcgkB+eaJ4QmDN3495I
         Vrht8fhryPVhgSywqA1R8yndnsiIhWkkvXQvSqx5K+eYlSr3qsj2CGdKUZmnjjkpSSty
         RbgoO0M3VrgxZ78BI8G8SRg8dbSebt30bv8r8SbExVmvlLIBCad4IXZV2y5alWUdStoa
         0WNp64mlWSIDsdnBXCVrheujBKAnRK9ulmbf5Pt69CCEFYKEMxu8NvmPH+37ShrzJCyO
         SbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756384958; x=1756989758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhpMCWe5V/F/7PAyzm0puD9kBtIwTfCh1oTxflApNds=;
        b=QNA6NAqLhBCDGraV+LjEO01cbl00cDQRJTMwNkPZR5Hz3lMd/UvSfkLeKphzN70k57
         n9ABD9RYdIl0JIhJZMv4DiigFudPAfV95OLNknvyUsBifd4tMFxqi56ptuMfgb6I61Gv
         5KaGWhqsR4AdSt00aE+0JXU62Tarl/d+j/wImnkopLCM84F+2qubJQnp9I7SGtPbxfFa
         VOQJBlLFaFvPz/8zPPLpyyNFe3CRH4lc1hzPekmheLZwYJ5smvitH2uWDm0QNCAEE+kN
         XeMXiQ8F3jM2hGpF6rLKue+OhhC+OU+rX7TXYdAME5buYVrok4SSJi/l4Lp3UE6QgFeX
         gz+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWUHWI9IP0vklBQhclGYhVqbDhl5vG1xOU/Qk8HT3o5P5TnoVSnmqV97TpVAtDlEyOrveTUsgnY3A==@kvack.org
X-Gm-Message-State: AOJu0Yy2sDoN8EeINYv0NKhtRrAm0uBCk1L8XH44Y6Qot+4XyhLTUYxD
	sCJqr2je2NoXMDsmoB8fK0KfJ95d/awRPQGFdtDRONwcMZ/K/FkDjVmfdtqDC1iJKD193tCfSsa
	owI+xh1iJcpujwzRQOj4ObXY1SApZNdJgln6lzB9iDQ==
X-Gm-Gg: ASbGncuLVfqfYe77hLt4dq+6HEpTpzcn3MLgUgFFsQkXktESUzEFlMsXkwgv7xWbsL4
	zFCCYbNPKT4huSByVdnHOGqV9UXufAAjbfW3aWNEYluO16Kf4u8IulFZdTFGbJtVLwdjAHrZLEo
	rDjUenhUJ4eZv96yDM85mFptwDXP6n9mr2YGDdYmMtINUu0s+rAZa1FD0qB5mTO67ie8CncSQUi
	ilCkQ40jND983SUqnlh9tZ6DZVxfWs5oeg=
X-Google-Smtp-Source: AGHT+IEFqGC0QiMn5r3QGUYrEVf2XDNrF8z/feBWXqNoPN6BqcxgASWKggdDBNsOZ7N2Iw0kXM5omUibGVBRKtEqWR4=
X-Received: by 2002:a17:907:3dac:b0:afe:c0be:5ff9 with SMTP id
 a640c23a62f3a-afec0bf30c9mr541232666b.65.1756384958305; Thu, 28 Aug 2025
 05:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250827192233.447920-1-max.kellermann@ionos.com>
 <20250827144832.87d2f1692fe61325628710f4@linux-foundation.org>
 <74a33635-3348-4e70-8cdb-16307f839b79@lucifer.local> <CAKPOu+-0zuz-t22RmENiAT7SXTMyRVeHgkCrnLK-Xt-DDxHykQ@mail.gmail.com>
 <56d18767-8b3e-470d-ad60-781a6f17f9d4@lucifer.local>
In-Reply-To: <56d18767-8b3e-470d-ad60-781a6f17f9d4@lucifer.local>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 28 Aug 2025 14:42:27 +0200
X-Gm-Features: Ac12FXwNjswXU0Ay5JE3li-px1S_CvvDr88iUS2o3Te1_iyJNAzZiituBsisJSE
Message-ID: <CAKPOu+-PVcmnYq_xKCE2S1saJ_iW3xDK1B5k=DCttoTsSyBJmA@mail.gmail.com>
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pcbi3ntp3a4p1qgqjunhnmsqyru5c89a
X-Rspam-User: 
X-Rspamd-Queue-Id: E40B84000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1756384959-470191
X-HE-Meta: U2FsdGVkX1+tp8d4hcqRk0oKTpEFdjbOHSO2vvrvn6765ImLOZYU//oMQbEKrVAgXyPZZQqVtBwxaXSifSjeeigrQ4psSf91nC80o/XgF+FIUvKeuyN1vaze9Ib00RH4zYmiccMCqzbtE3K9+O0rcVvgVnAQdr3/6M94tSlgVW2pu7tzhVLpIDl8Pe29SX4LYBL9dX65FpWxRf69bbwOcF2MlE/nVAGoNaravJUtfG3fir3O9uPU79jKpd/Ni5jMBMhH/GHCzRv6M0/7YQ37dAyju5skV0mX+4mBDmQ6WSwRukh06SC6a9MRjPQiKHamwpZ6FtPiH8uZ7o0aMfRWtI9ViBrwcpBX3KF7ruocUz6kGL34K5lHa9rwGCOTXoZ1qwoj6xOurm5xZsWT5ciGmRQuJqyzKcKJGRYEhu0TjrdXgVwzDgwnpyiPVaxHiCIO2MDO4eTVkMk4G/fYZSkUGjvuCD0qRUxhCfzpi6ZHEf1GlJ1bbqvEul/EavAAlf3rx/fcBAH+qZRaU2gBQu0NpPo0ATxRKnKeEXKEwdN1vciznzfLhYVdiHhxSl4RUTBd/JH4M//jaK9zhrjL9G1Vkil5vzKVAMdpZ4Zabwt3/vS6Y2KlVESoHWjOaOwFABLXdOyPC8pDllf7iIYs90tktqx4CpBjT3A3kiB/3JBu5rqKSGMg03g5hhaOxQAhPXvznWdFSHmBSm4jZ94V4ngBIgl0CDqpWJwBnCJMkfYPTKQO0Wp2N8ANZnB35Q84hJM3d8GTvnxM9bMGE7SCGr8GBVyE4oI2VbKnPwQfa/gdebOz9+UMrEI7PZXYQTd8FvQzWBhmzdGCWifuUW5YRVSXbORIEa/+gKVpp/qAArLMJYgmTr4JnRiWCr8LJfLLiwOGKIxZKvfpYPd0H/juNb0IZCZSaw5+pg8jUdScG5O6pXFBcv90OsgM5ub0Jm3y8mIFvqdshZnWePdPIWDQJba
 +owwR2XS
 skm8OCXIqzTLuFGIZQbPpjmwTjDVYdARWMibQAtvG09RRB2ogrgvQF0sGkJ4LLOwRMuWWpemrdnduW7rmaoGKDO06sayWLEPRZ4Ju6e7nstC/wB4QQ5Rx72e6VmjZJkL8EwSze49znOthcfNSOs0BYxweYnmCTyo4PjNPSSVhCZXigwrLO9PS1coMSmgt2npaNTyeFgrfhX1Ee+wysiMf35AdTCheMh/6t8lctTo9b9W2/PY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 2:35=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> I'm talking about const parameter values.

But that's not what my patch is about.

