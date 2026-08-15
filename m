Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E016C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 16:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6996B07DB; Sat, 15 Aug 2026 12:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AECC6B07DD; Sat, 15 Aug 2026 12:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB996B07DE; Sat, 15 Aug 2026 12:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4F06B07DB
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 12:05:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C79881603F9
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 16:05:33 +0000 (UTC)
X-FDA: 85103978946.09.3168EBE
Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0EC9B1C0002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 16:05:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=X9w8gER7;
	spf=pass (imf18.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786809932;
	b=01gAJKDV9fil6GpI3VVcJ/x5Jx+WNpVx5/YajuCaOAoxjL+t0idmqfRU87rxSclRoDvpLN
	m3go/ulqZciQw0TIM7CC9XaDglKm8Mvvst2mF+n7iJNtSvxa1v2kGifJPkvbKkh8Hmse4m
	mV0AhT/52oJ1/9f94kolfVKvP5TMbrI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=X9w8gER7;
	spf=pass (imf18.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786809932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=C/2w3Fzs1DPhm/TJwzhpkL8Eiva07UXknvWOLY4BdGk=;
	b=bDd7inpYER0nON1oLbNZJRm9sQi5sDCIji/CKB3rdP1Ma5P4CGEyZ6+KuAPXWD4F5741S6
	QIyhPlu9kmeCvtQwTBcxB6Q6fY7OfqPmxMJ4baJ9EMmhJfqnkjl3Nkvvm2U2m1LL+vMRFo
	RsjlqnC5h6bAQg5tCRnsYQgd4UEWO7s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786809928;
	bh=C/2w3Fzs1DPhm/TJwzhpkL8Eiva07UXknvWOLY4BdGk=;
	h=Date:From:To:CC:Subject:In-Reply-To:From;
	b=X9w8gER7OPQlnLdr12Ir6s+Ri74wI4h5Zz3/VwM2A5ifbB3VahEljU8lDBV0zr4Qw
	 dtADfdcl1m+rLYCvvJ/mcRt38ancNsWyKg/A+6RWnjnEYuQycknz1pg8gA9uBI9/g8
	 +FTyAukfHIf5Y6l+GGa8BSfQDZKAdCttljj73y/0=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4hMkTN6hwzz6vKd;
	Sat, 15 Aug 2026 16:05:28 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4hMkTN39jLz4y6W;
	Sat, 15 Aug 2026 16:05:28 +0000 (UTC)
Date: Sat, 15 Aug 2026 17:05:26 +0100
From: Bradley Morgan <include@grrlz.net>
To: joel.granados@kernel.org
CC: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com,
 kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 shijianlin11@foxmail.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_3/4=5D_sysctl=3A_Disallow_part?=
 =?US-ASCII?Q?ial_updates_for_erroneous_sysctl_vectors?=
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-3-9df50d26e477@kernel.org>
Message-ID: <3A4FCA2B-2F42-4E8F-A328-5C1BD658B2A8@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0EC9B1C0002
X-Stat-Signature: q8tq1xissyedh8yeqn1zigiwnrraqum5
X-HE-Tag: 1786809931-348293
X-HE-Meta: U2FsdGVkX18ygx0hMKM4DtM/Tn172T46Fe++ObEX3gyo0CG0snBPEUA8W7M5mXif2soAFb4Eb6T2bGENAV63+qiPvTusheOjQRxIbbe26HsvXjH3xLYGe9vOOnfBBR5Tz4sdtlhqCXxAioye88F5zOxIh8+5+peaEJgKTs0f7cGQHhwTcg1ACHa//TqEr4AXt+5uHuOnY51fPbVMkjj69MMiySfysVTVV2etO17QOCyePiCBtjy/GYFp8HDh1192BgsI7do+avsy0bvj53Bp/1ARbdDmBBM1gC0pP/QKgbGGAxxwSsTqb/pJov7eypcJXYzKZZ4aSEWhYogWppocw4jBjWH/Z0UsDYhmR+hj+TyqSzEU7MxfD7pgitERD6/WXAl4HZBWTbbS0bZy8lbiH7sl14xKlOjDwFiv/AnAA6Ybzo8NE5tg4081Ll5BWLVYZ/p8Qi1EoJjZi/vT5+VAhiHi7XqyD5JzqgU+FS6s/WXTRv8KlNbt/5CrIqTtYHakXSJVTcAoyA4vsCsD3mOwQadUStOFQFVfgP5jJeqt6X1ntEv34xvFU63/Uy0LkdpShkEpw2UtI2IpxEf4y8efekVPfi3PHzQvjGNLcrwOLN+AlKHyfNp+0NI0SiABjpAV9bAMnO5RyS6g6ytN8McaMi25ECpJkpZIdNtw9jmUnHDQWKhLh3qRro2hQteiKArqLsx+Li6rbURyZd36WBSGft+BpMC0eWzYP7EW1L+SuvuBP5gummD1oAVuXunoam/+jYj/ABopXlFDfLjGIJ6MEWtjV4GxqLN5heuyOrs2bNQhIc+D+CxI5BKjdZd2r+1JUTaXkaOjo09J11/VoP0Icben77JPjZEh8LhKUFB4i7SHHdb1IRkZ1jvoSfgeINbVupxIDZ+9nYBcwc49L0WQFDAG8O6r9iYCQRP/yVaIJ6ttcZyIcNHRwSiSvv7vq2LW8WGYAfjd//SdWmJJHd8
 TmNcb89V
 sKrnwdE1DHv3rU3wDfG1aNzculMbcmgV6tPkVHH0yQ6FHQCI9nZvQ/Wt8+prwyXZLAdOXefZ3IqY/6BR7WOyjPSuCj5CQGJFCzotEAoKtUzUnYUE6gsZO5kF/UfdJuOun6k0tfuiDt5qReoc3J1tM2xomuIqtj4HR87ImjCW+Pc7C3zvDJXQ+DXR5fMLat9tS2vJChT9wIx7uaGXSJhDWkSO2m4ZuXwaJ8k+vV+EvFJFPm9Kd6ukqJb6wPuE1bCpwjx3fOvUGqXzsJo41WJbrDLSCfsqNzAlUOE1UL/eFd5qyE1F8w/02QiI66FiuUHOIKKSXKe6q7LDkAU1J3UNvbNpCCJZLMAtYgFbKnJr/y0MYs8ExQdQe/GFksxXIXIw+8SXo0Gf4BKsNfLvAph0FYnCjSKBcNp8duUhX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit_conv_vec() writes the elements one by one, so a reader can
still see a mix of old and new values while the loop runs. Same as
before this series, so no regression, but the changelog could say
this doesn't make the write atomic either. Otherwise someone later
will expect the vector to change all at once.

The copy is limited by table->maxlen and only vectors pay for it.

Fine by me.

Reviewed-by: Bradley Morgan <include@grrlz.net>
Thanks!

