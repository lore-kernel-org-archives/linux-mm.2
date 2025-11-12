Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20956CCFA1E
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 09:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BCAA8E0012; Wed, 12 Nov 2025 04:26:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CEF8E0002; Wed, 12 Nov 2025 04:26:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C638E0012; Wed, 12 Nov 2025 04:26:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE598E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:26:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0A4F14042C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:26:46 +0000 (UTC)
X-FDA: 84101425212.17.103E2A0
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 189EA40007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:26:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZIQZwiF+;
	spf=pass (imf01.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762939605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13U7AVC+v5UBTnrbtBPdFJDstqOHomUS2ScWYjnJ9zw=;
	b=PChY4lT6ZSTdeNd+o0U2pCcRmhYeky83MTMWQ6anNb9u3lUSqVdmkMjMwNQ42TymTnVfam
	jofC+u2kwXjaxS7IQFgh7ATFghNFtSCP6qaIx/Gg74Qsn5TrODsY/0jIWq0ErxZeRiiK+V
	/QqxBDMpx5MSYrH6nMqOxXa1IpldNrA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZIQZwiF+;
	spf=pass (imf01.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762939605; a=rsa-sha256;
	cv=none;
	b=T1WyYszevVmRMlXZQ7DolMb3WWKpWUnJH0/KJa+YsekQmiUmMg0XjCCSfLYRqru2ZG64GI
	X66uOU3xDpUEbmlzUdPnEBhmruPM7lSXB9eHsiItIODccWynZlLe66tjT7R7IqSQgOBv5/
	jxg1TIIGmIIfqpAz3VKFntH9mefWagA=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7880686d178so6747687b3.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762939604; x=1763544404; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=13U7AVC+v5UBTnrbtBPdFJDstqOHomUS2ScWYjnJ9zw=;
        b=ZIQZwiF++LpTfq+ze5Y0Lf1iG1KEoqKI1cwUq+zXhmWJBKAzL62zB6oCjt3jpWoxBK
         1G/EF766EUASXHfSvA4QZfczXTnzqmoivf0n46ivvo83C41lp7zU2xCHSHNnk015RHiG
         ePIC+TjCBEWDYnSCYunoaZmi96vqlxgOhL9brdhINAz3OwgCXwCX1OpAoSxprffC6DQj
         JZsWIUxILv7eyy0Edp8kxDCkb4fdQ4n0cqSSINR9F28+78guHqnMMfFw7vhYnamlyO0v
         cWK1nGjwxBveGWnHVs7qWQnVYCtGWoIvaDn0k5MKoqV+5RAPxXVjjzprKbJJkfhHZNqD
         ZyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939604; x=1763544404;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13U7AVC+v5UBTnrbtBPdFJDstqOHomUS2ScWYjnJ9zw=;
        b=m7p865ryXFt/aLkFMd+vOxHWAtHiDIFKooMfcZpV2t1xCSKkFEIZIUbnUbnW7tzukh
         bHla8F+UfP9aH9HX2dwwKIchXy3CQbYgGWOgTtO1NUvx7Y0IX1wN5DdO6lEri57DO4qu
         iMUG39dxec28mkwmOtUn0sEEvt5bETnh8ARZjKF09lpXWDeWyMujnSMkV0geVtSeqH8t
         Yf0Pje74fqybAkdSdDe7nXwzERNce91/A8hfc4vGH/7wh0XdqiL98RJA2WkalMSMtlKu
         gMPWYFtyptgQUKnwIMRiN2mwL4ga9dzrNVLeKs47AOKGAKyqxFuDzalavBz/bpYPuiZO
         DdQg==
X-Forwarded-Encrypted: i=1; AJvYcCWeFvSQb6px7hK7CM05WPidAc8c55f29n3MFmSC7mre021ht/VjHmWkt2ycn9p6c9j3kDq4nIIpFQ==@kvack.org
X-Gm-Message-State: AOJu0YyJFdcjX2d/dnGJzViCGGvWqtkWQDQP+0Ou6lJVgMwin+UQza63
	tUAJcGjWNRI/xiSYWAER+MUE2QHWZICRi0i0J6wZAh0quRRo7ElFvJFExcu/NB340ce4yNQcETv
	IHtlARg6FIudCfJOXozlHk0sU/hgvtAA=
X-Gm-Gg: ASbGncsopzXoQpdSvimmsykChVBWW2l4g2VGUwOr8AivzNXN1TVDVZ09psFkifbTT5V
	hYztmg1gBU8ZqRvRuamhE7F//KajPloRPJ8U3vktshbDNkGCXD1DGkjdzFhEfrI9lXPIs9YFsT3
	HSJjrUMiI43sIgqE3QTXlWkTuWIGiq7gwUp+ApFfBfEECdZoMqxuWu5nblLOFv2EOOn8uweQ6Rh
	+yoBNmCZXekJrQ7nu4ksmxbXE+q3dZGm4aOOwwz67Z0ncqOZtYiYbj/T2glCv78aQvwKZuLy1z0
	d7mLaUlzshOgLzhKMg==
X-Google-Smtp-Source: AGHT+IFeg2Gqvtsptiri6ePX3FBgv70zi6fuHZ1BwTdto3EYCmKxE4YFDolr1iUmWcSeBCbWwr8e8FtaD2C0e2n3xP0=
X-Received: by 2002:a05:690c:a742:b0:784:a232:b3d9 with SMTP id
 00721157ae682-78813621726mr15697227b3.18.1762939604074; Wed, 12 Nov 2025
 01:26:44 -0800 (PST)
MIME-Version: 1.0
References: <20251112031631.2315651-1-kartikey406@gmail.com>
 <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com> <aRRPvn4DYAhuGtq3@localhost.localdomain>
In-Reply-To: <aRRPvn4DYAhuGtq3@localhost.localdomain>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 12 Nov 2025 14:56:32 +0530
X-Gm-Features: AWmQ_bmaI_JIe64abNiasFhIiNWEIeB6vR-Ar5fHJ7UfN9zGaffX73JU93uBIJ0
Message-ID: <CADhLXY7-62Q51_fCXs01kiZ5u=qpieXJbjqrJnvwGEpaR37khg@mail.gmail.com>
Subject: Re: [PATCH] mm/memfd: clear hugetlb pages on allocation
To: Oscar Salvador <osalvador@suse.de>
Cc: Hugh Dickins <hughd@google.com>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 189EA40007
X-Stat-Signature: jn9pqmqf5kqk9tyz9yb46q6z486rgoez
X-Rspam-User: 
X-HE-Tag: 1762939604-59136
X-HE-Meta: U2FsdGVkX1/IVDIXQKNqLUK5dc+xTpFy76VTt6bjCzggf9YNhkdaYIsNd/wE67dHEKpn6EMnqjdIHI2Pcaezmw0vy4Bp7G4KMTmJ4sn3GOMWDWKlMM3zhfpPZBs8ewPSF92x+vYFlTgQOCT7eVbs1SCIlfJ5Mf2zPH3eBCY8qwUxp+bmsfCaOoEIMb/2rodbeVEAE/OaKbaR11AhVtgvI0VpCVoOHSfSsugZ+4g28qFw/EQ36LLuasv9wqa9Nnm8VfFmWB7ANpvNCip6GGGs2V40LTXO6aVTdCit5eHPh8PkcWkuUQ9P2EitGSkdPrMOgr9en02+qmP+iDHWREZ+wZS/xnTPPlboHnXrlpvQ55OdZjZaBJjtT/RTKd9vSg99mfZhPxmx7/7J/rhRHsLeEWCzizn/kYQDEOuL9TaTwUWc4lMNabVDnKIaLRpvkEvaAgH4bJdAnVw5M8+LSnV3MM6HO3BACs2+GbnebhepIXNivY2HYgo8hP9oNhcQeDwnyqhxxrtX20ZYOYL6nuUuo5SPc/UI6a48CpriC+KBPq7H/A6YKO+5xkK+FH9VVbi0V3XmavQNWnMCngmZirfwzysclDCUoUh8WveIQubY1gdrZkJmx4hpZ/TZ+8ObiIYzXsEW8dRkEwEAmLr9oIpceeycjgyn3bK60ydM0quh0sDmBDU5yIlHWWu7D1EChhe9AALzvg0gPQoGyHKbhRdgjxQVoVPsMybAm8yPS6+TW/NP78ivCJUo0qWpmH0oWCrjXl6SqOUUIEdBO21gtDSNnqW2skabEs+fEmyKM6ZrfXqj0tNdwLyMuE2QHuEbRrPSXWH4I6VPssIQR+PFqSVH5sf8BAQWirgOpG13Z0GbbiUii1/oauVe/TTzRXuqRXRuvwPPunqxwya7yE1VYOKu2Hh+PNb0iRPnmAg4qwQpGk8j27ptl9PYrFsBK7YJqZE99oUzXQp88w3q1rSoQ7K
 Ib4lyLNG
 KUL6m1OLny4PpQeJQrz1umFsOp5gY7DzVtXEd5sX5jHshunjKYHZ8aibdCWIJlENowjmSUV0jye6NFQ2EISxZwHeuN++hHDlURPP8u5roSKX986xI10G5ZdvVVPx4eKMd9YC2zII9N55XviwqixgrbQ6rvBydDI7z3s3O+UO5iHrRYPLA+0FJZhU9yI+V/wPJ0n2bG2we61PUmOXs9y5fWDWzIK4NhhekvT65XvgwLbFSwtAXNKp64RXmGM3eRSGt1o0Cykw138R7RBonWVPm5XEF3fbC6fdt97YPPYN1BYH7wINGduFXSRC+XZmY5y4CJFzGTZ7287clusnVzUpu8Hp43NBwFjZzK4RMVBCQqaLmUSs8CZUHSwXrI94s1acDfuuk/DbpL8ctKXuVajYQGUoBFaiddKbr5h9p4tliGBbVYdhZXiqMjvPnc713dCG/aTyowXsijhQsVFawlkOCfmfq4D/kjoTcuSLMaGFs45DqVvbsfnLT3By58MVUVfg8Vhht
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oscar,

Thank you for catching these issues!

I have a question about scope: Should I fix all three issues (zeroing,
locking, uptodate) in a single patch for v2, or would you prefer:

1. My current patch for just the zeroing (security fix), and
2. A separate follow-up patch for the locking and uptodate issues?

I'm happy to do either - just want to make sure I'm following the preferred
approach for the mm subsystem.



Thanks,
Deepanshu

