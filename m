Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D95A1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 20:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85FD76B00AD; Tue, 30 Jun 2026 16:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811B16B00AF; Tue, 30 Jun 2026 16:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727A16B00B0; Tue, 30 Jun 2026 16:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF176B00AD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:19:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE0621C007C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:19:19 +0000 (UTC)
X-FDA: 84937693638.18.E9B785B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EEEA110000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:19:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w4MuhO2i;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782850758;
	b=rCN++yZTCt/FWnvn3c06e5FQou+VP/5ZZimmJQ9GZGGDzcUEqDV0VkQ7zEhToWNpyCw0uR
	7YSSL7xdMODEz/7qBzHG4aQ/bMR5ZRsvImf9kdPXfSr3JMpx9A5lC4ASgzeMpQuZkOOido
	E93xfvVDSg89bS6N4Fdx4myHJGS8HQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782850758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xR+cURGiHZxqoJ7+yfUVxfoUewWAkloviweDWsdCuZ0=;
	b=it0MERb3VoUfv5/FQpVdP8J9rPYQUQj1P27y7ZNMQTqf0qZe6xKF7ZpxkS8sUIEkIkU3ZS
	CkgX0w4N3hoeC6oSwGbjfrXnMNjoiKRu8sqI+vXqBQHgRNwGyaOCqWpUzBpDRj+evAYMQo
	si+DBU+K0XYPiKqojXQsz+Wje0gWTyA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w4MuhO2i;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E271F43E1D;
	Tue, 30 Jun 2026 20:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DE81F000E9;
	Tue, 30 Jun 2026 20:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782850756;
	bh=xR+cURGiHZxqoJ7+yfUVxfoUewWAkloviweDWsdCuZ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=w4MuhO2iOCaOocWpVxUmI8FaSMXluXZ0p5jAAmsPH+pKjLCjTS8U6D2Zk48wmarIG
	 SMxVOeOraTWWq22L9/BZVYjMcqyySzEvQRko+1KrqvhYdk42pZw45Kk17tf5KO7Lwl
	 vgcwTbk/tyNvqy/70gP+BdsvCmoCfAMzcxTgIo5s=
Date: Tue, 30 Jun 2026 13:19:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Liam.Howlett@oracle.com, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/3] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260630131915.a7a479fc92ad0b86bfc68173@linux-foundation.org>
In-Reply-To: <178283277041.183052.6873574850714079228.stgit@skinsburskii>
References: <178283277041.183052.6873574850714079228.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EEEA110000B
X-Rspam-User: 
X-Stat-Signature: ois7iwg6e3qs11w6r58juutwdqdfu3y3
X-HE-Tag: 1782850757-18350
X-HE-Meta: U2FsdGVkX1+npEzEYBgHOP5EAwA4HW+koMJ6HnNz0hZiau7qVw+PzoHr8cYhlT6y4iY7lt6gyLByz40EgykreIvfK4TAKl4W751bm6/sK8wsOTHjhzaoDsaQEtN7ohYk1DJ5xXNsj4uKT7hD09Oz4c7rMXfhdgPgYCXAAs5g9QFRh/IBEsrYBes/FLC/FSsXZhsUstxVLi4smHnbxQqR9NHtFCc4b4qx5ALJtyT7lmxT1POl/eDDcHWD/JsijdMrzlfYCbpat9DKQ+vBsZaM+9myUMN5VeLbYEfi1DpuCIf8EKK24BuPBnxw8+V6auPg2UwjSyQTPQjaqFTD+zqYL01seHmchJBuWLh4n87K0HSUGLZRpsfWb6t5pnMWmlP3fYuG4uA4Hder7TpkPBh1NtyyTwu1ERfnnkzELr/XJsDghY6YfG7EiWVczYDfv1qfygasgTkXJfGGo9KYtYh3YJiZ6EFSVVnCw4oyRvzQwoq5COcVBEnALB8SenUdeAB8N9hLMh6QJ7VuQcRdqUn+bqVLlRFEYpr9Nula8qbsrXVNf450DXLahPrJeKw/hSG02ufpjJGI5/OvOTfgdROkMMTlS3z2O5eB479KvZ1xKWmXkL4AA7lqdrDY7vS4yAnhIWYnJxRwop4LlNRX2KMfstJGoCocfghPrL0XcKykZ0XqES6WXEGb+Ad5l+oybUWUajlQF9QTAXH2lu/tUZYDBizqBEB9REr7hymaCHhZseMXlSX1m2tIItAhCTkrNzqFjJPQFwi7PFrQce0AyJ3dR0vlZEQ4fvPypfFJ9OBgWVkV2dwvABoM3/9OCMVuouCmZkhCZ+IQu5sYuEbdWFUPDfxM9NnNX8yM+YIxzgCVPhMkafRJ6uEq2UmaSGSkuW3KVr+WbU7rKCa/pcRv5mBpnGBwKckNPJPpyc6IiQxPz/Ypr9WNm6Ynz06+ACITW1smk3MGLrJbrXk4wVbUWeR
 9T5APY6w
 fQ55Zi1V9xXDuq32JULm4p2ADLydlp+dqMFGctpbhuo2Ii8FPoaEOauXLEC/1yH3bfY0/BHOq8HX7ge7byEh9lIFL2oL+mEDajDrA5tZXmg+sUi0dHec4xCuYMNsRC8Dy/PrzxiaTArmc5zxaRStRSZ4Joi4rVWqT1fjxBt7N22F2YzNpfBonwal4JqS0sY5VblOiY9hk1wVA92p+gtcmaDec2HjNgF4TAaLWpieOcIaru329/7jlb8Ql9xiG46czasqSPNVoMyGwoKBW5Q0oeHAXAiBVdCb48IbSGSthLS/hWccrXWxcimcp81TwY8kiu56mCyr27Kyyeo13qrfTMxf64w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 08:21:21 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> This series extends the HMM framework to support userfaultfd-backed memory
> by allowing the mmap read lock to be dropped during hmm_range_fault().

Cool.

AI review might have found some issues:

	https://sashiko.dev/#/patchset/178283277041.183052.6873574850714079228.stgit@skinsburskii

One of these is pre-existing so please take a look, see if there's
something you feel should be done about it.

As the series is presently unreviewed, I'll await that review feedback
and/or v5, thanks.


