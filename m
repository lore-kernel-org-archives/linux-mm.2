Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BFD108B8E7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210A36B0088; Fri, 20 Mar 2026 05:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1B66B0089; Fri, 20 Mar 2026 05:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8A96B008A; Fri, 20 Mar 2026 05:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC96F6B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:53:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4AB9140138
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:53:23 +0000 (UTC)
X-FDA: 84565978686.15.4A69934
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 15163180005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:53:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q0iheGUZ;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774000402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzuuzXA1LL9KuEU/Q2UhcZDcqhurDhj3EY4a+K5UEfU=;
	b=B6B5QF5Vqak/DLfoW09nxKHAHJ7Vv5cvcIrz9sHUgO+hfi9XMKTIG97qiAZXW5MohZPAGp
	rU1nTm+XJS177o8O9g1nrpV3Asv844iOl2/ckqsDgbqU9KgftzBMLe0TrVukHDZ7I7UBIu
	Mc21Sg+ua9C2/LAmJHZPAbBXYgfKXOc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q0iheGUZ;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774000402; a=rsa-sha256;
	cv=none;
	b=saz7XSBhqteWplwiJB6xg715L1JdtpUJjm35dG43G1PYz9UoKL5hRe4X6oFDR0K0oW8ud6
	0Ssqnln/UyUeGtqf8JQ5W449Ayl5VU8IsEBFge5QNK3lU31blUlaqflc3ssa2B8sa/jomZ
	3n+PgsdXBlVPJGr2uwlQwzdawSYXjKM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E82760127;
	Fri, 20 Mar 2026 09:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C416C2BC9E;
	Fri, 20 Mar 2026 09:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774000401;
	bh=G/D8/6l1J5EDvSsTgBB0ZrD/vkTc0vXii9mVW9ai2JQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Q0iheGUZYk8Pire/FtxwUk+x/f0XJwRMaH/KqUGIxTpGVbpAPhNgvKzF+ql3F9xCA
	 NYWTy/SU73hZeRLV/MhPxMi2fWVbZFlHyQ52GjAVLy/pPezcruyaKCPSWndqVKOGVH
	 tAj298QCenbJC3vP3c7sTKbccJ0vC5mDZIg8sscD3wmkJTlMnbpwxPqnmjT2xk6KKS
	 vyP+0ZAQc6b1wG673FQwCLlN7NZ/1SmYpUbIXihQZLoYXr+ZGVK3u2XdGIWn+R9L6S
	 8Nx4PF6hjEahvS9GU58yOAbI42PhgcbOtHSQfPkJIrxUBUZGdot+u5gGp5nfyuDa4g
	 WZ7z5qoHGbTZQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Chenghao Duan <duanchenghao@kylinos.cn>,  rppt@kernel.org,
  pratyush@kernel.org,  akpm@linux-foundation.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 1/3] mm/memfd_luo: optimize shmem_recalc_inode calls
 in retrieve path
In-Reply-To: <CA+CK2bA8+s_4Ue6NUkRPwi4yDzka6H02SbcYwZF1ODyTLDRhNQ@mail.gmail.com>
	(Pasha Tatashin's message of "Thu, 19 Mar 2026 11:28:05 -0400")
References: <20260319012845.29570-1-duanchenghao@kylinos.cn>
	<20260319012845.29570-2-duanchenghao@kylinos.cn>
	<CA+CK2bA8+s_4Ue6NUkRPwi4yDzka6H02SbcYwZF1ODyTLDRhNQ@mail.gmail.com>
Date: Fri, 20 Mar 2026 09:53:17 +0000
Message-ID: <2vxzms02bzea.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 15163180005
X-Stat-Signature: hdx8bxoxd9d7ktdmugnfxi49xgbm3jp9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774000401-490753
X-HE-Meta: U2FsdGVkX1/1AEumzMOLlEatF4c0TrZ48qIcCXqJbxfjmKF3hhlrsRxkE/L1oUuZpbSsR2Q8NXtAAO7JbQQaIjGIfRb79QgksnVBHmeT5afzO9KU9Wd1ytjSNAlf+7Ss+bm6Rkx5UgJDUWyZBl5GF2Da5V6UiNAKAr79Oxr4XyRcK6Fz1dYR7mQTmcjTdGDZGBw6RDLaN1LoWj+h/IllKaoWbr9RyjevU4WSr3gYRnADSf1lyXMhniFPq9ZEFg/P1vrZ6S/i5jMlGNDYQhkHqSO5tWMUe0uon+qDM4dW9PuwNurYoMNDVe+V5Y+p/YFzt1kBOFDaQAMSfMq++zi2MezbKwdE0j2QEugO/vKwO5G4L1o51f5NjMY6YkgxnvnaAQbRujSJhPCzLFIrVbM9wqpKKyXbcQ/WTmOeyE7EHE4slsa3PV74AxK2GPfPCvCsXSNyGrJ5jbGVSPMuMdhNsh5b/fh/Pyz/cVjspcVDKHUytzE8Vj2vdEgFuA4D1bQRQoc8DH6lB8fr5UbOUTf3e3csM+8kR/R7d/BjM20dJRehT35KXc71C9OZKomeXuqB3ogZwbeUqLPgOl+s2hpUBUt1JLTiVZTqQzAvJJk2JtTjgzuuKOQm3tT9M5tI1QFhDS4xT0qtrKG7D9LlUcYbxGFwC6+rQQE0Z7+ADh+CT7dI/vGjAnhAzKVUkarteBRB63BxexmSMlklsPsiy3O2t9jOSnuHlKbZiFXZc6bAWIpZb6Mez1XY9oWEAwhEtR6+pvufuZ8o4gnA/yF0YwVzbXTB/j5S+IrmKNopn41f0c/U0NPlwVhTTeCmsWEzdcMTZqI7aqXzjwPS2aNwoqVBjYLJVtASZ1t68jd/ONNezhIxXAVoXcGl3ogJFh9lJ6L4O1/HwiaGZI46sh9aTF1fqo3x6dLAPHkOnhvtGIG6A/pFfGRqS+L4VQQjnJuOA8z3DNWat26yOONDr7Rhbu0
 8HypcYhM
 AUYz9GLPzBApmw5IZqYPKVX6ykJnb7SCsceXngJFLSuPoU63YP9ZrlCom5MDfyqUtU+36gTSyx0P31sURnQ0cawNxT124yfeZAQIrhdGZruVNBONO+X0owtrPws2eE1zHDPfjSaJiS72LdS1QtpxLUif3Za2WRaehX25fbbkuvwVzksL62pNoHA0kYFEJwwKl2vbJWGWoBF2t4Cf1q8O0WogRu666TXDTZFqwSvc8rWTW8Dm/lqZZOM4VxAMgL5U0iGeYDe5AhZRJl0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19 2026, Pasha Tatashin wrote:

> On Wed, Mar 18, 2026 at 9:29=E2=80=AFPM Chenghao Duan <duanchenghao@kylin=
os.cn> wrote:
>>
>> Move shmem_recalc_inode() out of the loop in memfd_luo_retrieve_folios()
>> to improve performance when restoring large memfds.
>>
>> Currently, shmem_recalc_inode() is called for each folio during restore,
>> which is O(n) expensive operations. This patch collects the number of
>> successfully added folios and calls shmem_recalc_inode() once after the
>> loop completes, reducing complexity to O(1).
>>
>> Additionally, fix the error path to also call shmem_recalc_inode() for
>> the folios that were successfully added before the error occurred.
>>
>> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
>> ---
>>  mm/memfd_luo.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
>> index b8edb9f981d7..5ddd3657d8be 100644
>> --- a/mm/memfd_luo.c
>> +++ b/mm/memfd_luo.c
>> @@ -397,6 +397,7 @@ static int memfd_luo_retrieve_folios(struct file *fi=
le,
>>         struct folio *folio;
>>         int err =3D -EIO;
>>         long i;
>> +       u64 nr_added =3D 0;
>
> nit: I perfer RCT for local variables order, but it is not followed in
> this file anyway.

It is though, for the most part. I also prefer this so as much as I
could I followed it, but sometimes if you want to assign variables at
declaration, it isn't always possible.

Anyway, RCT would be nice to have indeed.

[...]

--=20
Regards,
Pratyush Yadav

