Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4FA6606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VNvc6pV1
Received: by kanga.kvack.org (Postfix)
	id E62546B05CB; Mon, 26 Oct 2026 06:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A5E6B05CC; Mon, 26 Oct 2026 06:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76D56B05CF; Mon, 26 Oct 2026 06:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B74466B05CB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:00:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BAC3160718
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:00:34 +0000 (UTC)
X-FDA: 85364332788.07.169B197
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 76E7120005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:00:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VNvc6pV1;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793008832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EW/KiEjTAKTNb6Fyq8su27LID0Q+hpX4ZUreLIT/B5c=;
	b=w0OEOrl8mKKrYT6jlZNd+EAnzF3K3S385udw46fBaUPXJID3W1QQfOygJOYrxHFHpuZFYG
	xo5dlkMR6nJMmnIBLT4vq4wVQr5Adz5FbDNfhZ0LIDzajGBR975hsicREJ147H3bLS+Ptd
	W+S6I/DMnXRfxj2qYBz68oxyk+Ij1zw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793008832;
	b=tnCHNfh7VmVtwxecvWwxKxIQY8l7tThwKLui6Stb+Is0rtoxynQzPkzYsYxN47OHW4GPOX
	5pqTB4cHeLDabV7rX98bXYfpjo/VHG5yC9ZZ60nE6rpBPWGuuV4uXb8Wazs2BH6iLe2TSo
	yCTsfH/o9G2hAo2bwRUg9WajOy79odg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VNvc6pV1;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2C5F60A5F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DC41F01209
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793008831;
	bh=EW/KiEjTAKTNb6Fyq8su27LID0Q+hpX4ZUreLIT/B5c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VNvc6pV1KwkLNz7BjGhjnq+VYIsTGl4JnniVjAcCFhD0sBFAU44WnZGfNflXA6arO
	 fA0V2jFC/etbtX17o8n8yyb1SfkBk+VxtfhHayxTEqrqyyT18yBF2AXbqb/3zxoQuk
	 T3/f0yLq4hwKiuLlifdqeIcPaWpfjJaLH9zXK4BYJ5JWiRmSH1nln1KAyQiMHaO0kq
	 Zw/8LVI0SLM32ZUnxxqsLirVo4EavlyxboUJuUe9P6uXcuov65C1A84OHwj96spcGA
	 9MckRz/fanohDlX3/zJffG6KEo0ugRrVHv54eKIAaiB4+RpO3yfnYqTozcuRzydGrg
	 J1z+3PUBNjiYg==
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-53634b8328eso18668071cf.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:00:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxzuCa+/ci45cctD+MTGnk0EBMJKKOCHyEHZ171rR2TKlE5Vsin8CEWuhFP4RsuyRX+u7VPWU9DHw==@kvack.org
X-Gm-Message-State: AFq9FYLAYuNtm7Wcw897WOpdM9B8gUbF8XxC4kys8RFVxb0/046Y/Ezs
	tljGW31b5hUokBRqydZ4bij28C0RQb19k7g3MWHBYK/YQI7basIWfPls4hz2xJByAakBbgzjyCu
	S9o5d+R/Mk0gQa6ERNA8lSp2b3UmmwEI=
X-Received: by 2002:a05:622a:4814:b0:536:6f16:d923 with SMTP id
 d75a77b69052e-5383b529e0amr95920481cf.40.1793008830988; Mon, 26 Oct 2026
 03:00:30 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021235606.89545-1-sidchintamaneni@gmail.com> <20261021235606.89545-2-sidchintamaneni@gmail.com>
In-Reply-To: <20261021235606.89545-2-sidchintamaneni@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 26 Oct 2026 18:00:18 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y7AzEHUjj-g_FaQdodYidC26-7MSG8HPkgfRgi67TCkA@mail.gmail.com>
X-Gm-Features: AclHuK_OwUoSS1vRNFgm5ezmxR4vQc2J_QfUTbATBQkBDlrYE43IstKZ-dkjm9I
Message-ID: <CAGsJ_4y7AzEHUjj-g_FaQdodYidC26-7MSG8HPkgfRgi67TCkA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm: multi-gen LRU: remove get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 76E7120005
X-Stat-Signature: o7nbfa1aad6zhsu9bracafce5ucdoyy1
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793008832-194569
X-HE-Meta: U2FsdGVkX18KCUxnDEJ6k5vbiJjUPlIDcnQRxhGNm4F9pbn5tOZD2mngThGjzB1RR/CPZWbinnYHrGj+amZ7mZu3zhbiv4sKLasBaSERTobRX0G6iigQHWNvmiPt9EDs5GqyHsnonggT/nM6h2+sulgd/3X8X1ifUEK5tp8hkW+nsYlZjHaOuFyZqqXt7rhT1Bms9RDsY5MINGjP5A3WlmWgwYIStCMBEhRfetp7vyPoEPuB1mD1Gac4Mce8Npj8QsKCsNk2IKKplHCYtZInxhivSsgMrBIFG81o1nPAz9MU7Bh0R1ATO5Ti46XeLbp7/RSNBmsHDuJKZsCbMbmgDwhzd6VztcAhKEvOSJzbEzKGRujDA0xBZNfD3sXZxrHUZQjrm84zXyagklg5eV5Lj5vsFaV53OEQJKJMWDhfp4ZAadtJwxG53poLbMErxj0ERN/ux5ihlOLE+pU4c+Xyp6WssIifRQz989bp/5EZ9cyfG4oZfNXwiobHn1blRf57jB41xeeXwIyIT46QDx9ENZZ+ViHc37W/LIVQTRGLRQ0hig8E7ylsjYjMd0YSnLbjSd+pByv2V1+zH8UDg7oTbqbjBIPHxOToQ6rk0gzjXVoSixukucGNM6Orf/2pjHlqL68MDcSkNbKXJyDF99ucr0MAe/kJMSWoKMDUhRksUOOQeTXMhjUhrN4hozrF/tfIgzYc4soc/4Hpc4WlS9bNy2ssNioW59nAZXRO4Gd4G4dCOgO02btwD7JEUKd1uU4Nr8edBuhp3DFp2apQcIlug8Q/snkgeADId7JW6y9nPjcePwvhnpEOYKVi4Yok0j2kIjx1pe6BRQOyl4csY3H1svOHNXzexHnu135rATl/mqXKsoee0t/IM90EWYS8HbNn8YQgFk1LeZmKuvRfRIqrHPSVFkG8xg0Ulmqxhf7gHTHx443W5mymgOsa3xDt6h4BWfol7N4n7ykzSeTIwaq
 XbuAt+10
 u4SkkQTfxucRfnHszyydWkjNM9OTZJRnYY5/poQQ8Jc7i+NRmC0PPNFv9/5IkUgcy95xqt5K2/zBpXdXjwOsUcj6f67j0Jh1YquSlTZlNaVI0xDiAFCak3FtUc6IbFcCkxw2+M/Ataze+B6rz5ok1nXgNnSLx/0JiIlBd50slbZ2VsYXzjhd61DYampHV7VFQzKwc3R/8yvVD+xch+AlzbHMBJfa0wKDCw5g61B+XmMNu3fFpzzvkU6Wmf0wSnxEmmGPqNPow4GtEqRX1mrTFOl6zOXcCT5BPdH1Y2Xvmq835cRVs/LAKUSAULfjaZQmE453ex6FdH1fORHPeDCp5fPUxe0tFuhH5nQ8sgodY3ZrF6AOnfHRMt0sX/BVvFW2rEmyQVjf7PCywA6nJnsJtLaOQFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 7:56=E2=80=AFAM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
>
> get_lruvec() was originally introduced in commit ec1c86b25f4b ("mm:
> multi-gen LRU: groundwork") to guard against NULL NODE_DATA(nid) on
> uninitialized NUMA nodes (`return pgdat ? &pgdat->__lruvec : NULL;`).
> After commit 09f49dca570a ("mm: handle uninitialized numa nodes
> gracefully") and commit 931b6a8b36a2 ("mm: multi-gen LRU: remove NULL
> checks on NODE_DATA()"), that NULL check was removed, leaving
> get_lruvec() as a thin wrapper around mem_cgroup_lruvec().
>
> Remove get_lruvec() and call mem_cgroup_lruvec() directly at all call
> sites.
>
> Cc: Barry Song <baohua@kernel.org>

I guess the correct tag should be "Suggested-by" here?

> Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> ---

Your patchset organization is a bit unusual. Patch 2/2 is
sent as a reply to patch 1/2. I think adding a cover letter
would help you organize the series properly?

Thanks
Barry

