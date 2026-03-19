Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BE8107526D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28F56B040E; Thu, 19 Mar 2026 03:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9146B0410; Thu, 19 Mar 2026 03:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA16A6B0411; Thu, 19 Mar 2026 03:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4E8E6B040E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:14:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5EC14C1A0F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:14:50 +0000 (UTC)
X-FDA: 84561950340.19.93271FE
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id 539C520009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:14:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=I9FMoa4W;
	spf=pass (imf13.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773904488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E8Ovdac7ZIgCc8/RhMCVHuioP3Me5QmtkDng0soNWSQ=;
	b=6BMIYJGePHkeWpfEjqfckYJdrs29FmbGQokFvf3mPIC6TnlzeA08zIt+YYxNiWFdKAah4C
	HxXA6CYUTjn+IkjVQ0ao7eU/cVsUyZxK4oAHsUmwgiuH3BubBU4Nq8ORJZOuV9ZKtClXN4
	QEQJf+vQKXC4NheKLZbPJ0emEiCMQIM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=I9FMoa4W;
	spf=pass (imf13.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773904488; a=rsa-sha256;
	cv=pass;
	b=wOIIQ7z0VUy11MLOOXsjiYMkAS+IwiXCcpXq5nrRTmLVFHGLOeMGKwiOV94Zfr2qMRqZgk
	vQNLIWTnQUYSF1NAIU5Zekx5N8z9oesY2TtJEpkuBITDoIAURzpeJuI42gghi3Kelsjc/w
	vyCo9MxuMDzzQm/mJh/x1ir9cCzzaVE=
ARC-Seal: i=1; a=rsa-sha256; t=1773904477; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=bAdc9FuJvi6R7vrwKRKx2jUQIxe/rF96NPXWVr26bTqbATRxge3fHLMD53jtjRTSGzZtHVOOO3mHjjOB+sNdUwAhSXszPp76l/2i+MAR8Dgpar/+sU+1ZfK2UlENXKJKi2vx9Xq5u05hLStvXZS+hhWOnnn+8wWOhZjIVqR5fZQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773904477; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=E8Ovdac7ZIgCc8/RhMCVHuioP3Me5QmtkDng0soNWSQ=; 
	b=VxTDOW4dLITFO7cpA4s7Wwq0tFCjDVC9DnhOYTdK2Wl2rxwF6VpS+BVFaLJsrS23SZmJztPDv/i7pkDnjJhsCm1F3CT6AuhYOyUlGs2RnYD/jJ1RDSeo234+eT6gDFpwmz6VDaczSCdG0D1Ik4Do8CzCt4VzmYrsPY3uz3+rJi0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773904477;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=E8Ovdac7ZIgCc8/RhMCVHuioP3Me5QmtkDng0soNWSQ=;
	b=I9FMoa4WgLg8ER3ENECOzm/v+CZo/R9vsQ4VTm6dGkL+kqbEN/71sEkBDMdIjdtZ
	spSZ0tUyiD+pInwCAoPPmagGtnmAOP2X1jVNhbODWVv+ESGMp8YQKJByCz+K2M6lSnN
	YOg86HhX15xQLnpjJkwYrUNOYPD3TbQVaEf3l3RA=
Received: by mx.zoho.eu with SMTPS id 1773904475068676.4637988311914;
	Thu, 19 Mar 2026 08:14:35 +0100 (CET)
Date: Thu, 19 Mar 2026 07:14:34 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/damon/core=3A_reset_nr=5Fdests_o?=
 =?US-ASCII?Q?n_allocation_failure_in_damos=5Fcommit=5Fdests=28=29?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260319043309.97966-1-sj@kernel.org>
References:  <20260319043309.97966-1-sj@kernel.org>
Message-ID: <E52FBA8C-BBFD-41CD-BFA3-A585CA79123D@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 539C520009
X-Stat-Signature: zhqi5p3p8r9uaqhez1smduj83mzmd1zt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773904488-541989
X-HE-Meta: U2FsdGVkX1/7CJVYaxvCNO5BOS4nAoBbSrblg6GBNCt+z2dkTalkdcmc+Q3YkCExqGv0TeeA++CtTp+PJoopSYIpePXBwNHjGKQ2+FvJhXeGmoDwL/moOk19Kw1O8BHvJ0jlFN19mibRtQaxiThVpYsuCg223QoBgfQ9AUh76eSaer0uigxTXds4KpadsdMRzcVA9UcZ3HkQ/GIQE5wrKdUerH/vogtdroHqIdNPJyt+gkdJqDRjtqb2oAVnXhB7G1/gqKz2BmfD3oq2NSpx7KDyrPJSxEnAdvW5/301tSymExlqOFdTb9QxGv1vEVlcjD0p/Yg+j+LNHMliLNZVcxlRp0sxoXAgV2qBpp1gd2CRIIevlaFp0x9PGbf8CwO6bfQMAUdlSznViILcK/TFOl3UQyJ4B1dj94X/xD02Cf7Ej+/L+goIOj/0hdB67UQqtvRbkzdJMIqKUaaPTtHYQhn4WQGmipOgzBpcSFpw17vHjIzWlOo+cdQ3Syndg233oQzJ/iIXO2qKxwfZ6NpriCHqKl3BxGB4V1mAc0zcTzrfELtLtCc3lHpMGV4E0xD6HAqYvIJO1EwKps0DWOcDjyeeVFNEOVFcmFZKHyBzGYgm357vTK4HmzxzDVhZLmlVDsptHFBlHZENYdrkU6DQ3cu3EcO5P8mjzvEiRloaveWDy6iLAlH6WG1CtjQgDYw9a+KNINQ/nVrgt6meqiZucdJTAq1q3Ji49cWZtg4frV6uFrEk5P1j6OMkTH1fYTqHhsQa84v3K2zQIS1zXIhiwrPcEM31JYz+rrT0hBcMXQkMnxYe7rLSk9kkXPkqaYbgLnVzfl4QOlmisDnzBZnb4mzga1DsD8ROFUlrioDWF24GM71jOUSsN3hnTGjU6M8WI5hBx4aRCWicMP3exM5/6lk3zGMbbZT+tTXCjRmGPO6EGqGzjQjRhSyP9QXsxFTp0tOwAf8z/lXfT8JlDLB
 gnex4c0T
 xHtZa4nlLF/cReHJrk9+QXqLK++BXddTL55Wny5IXj+CN/q+CBnmqpyLDcc9SysbIqS6sDmU2m8y0lr4n7zjTL/qiif2H5GAyeQCo9d3DITuBH5aTlgwqjdWXYBHEy2UGqo0L5hSnmIqDooxZBOe119rrVS5EQRBIQxzVXe06H5lATEq/B9OrVuBuEVrN325yg6aJD1qFNa/W8XtcPFdooAz1XMV9Pl34A24/avvK0R7NNxYRt8xFF7qhsEyolLbNovOM6mlDQEnCrHGTn9kFiQxaZZ7iAybRTAg479BNpMhEK9iw+OaPGIudKfZsJTWVpgChO2OGfY/vT/I0nqKFioTfSo2ZIaoFxUr1dcIHNJRoZdhKrMLi0yRW3oI1CUhuetW5cfnt0KDyHiMIkaOJslh9FzYZm/MM8tUJdeR2cpiPpL9eZdrQKv8a4cprEVz69ABXt7lBr0K6cbZRfNGSfQv7zoIwRa83I2FfhlEQ+xF2zNVmYYj5N0AkZPCHEmrBwH6aSgFIIEuY6pRa7PkJZ6A42mUqqIKuBhms+gCCNdjtLxht1hAyg1bY9MWbpQfVrSaNERdqYy7diOBZWM0aX1Y4+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19 March 2026 04:33:09 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>Hello Josh,
>
>On Wed, 18 Mar 2026 21:49:39 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>> damos_commit_dests() frees the old node_id_arr and weight_arr before
>> reallocating=2E  If kmalloc_array() fails, the function returns -ENOMEM=
 but
>> leaves dst->nr_dests at its previous value=2E  A subsequent call with t=
he
>> same nr_dests will skip the reallocation (the sizes match), and the loo=
p
>> at the end will dereference the now-NULL array pointers=2E
>
>Nice catch=2E  But, this is a sort of intended behavior=2E
>
>The idea behind the code is that, if the function fails, the caller will
>not resue 'dst' but discard it=2E  Hence the function is only ensuring th=
e 'dst'
>after the failure can be deallocated using the deallocation helper functi=
on
>like 'damon_destroy_scheme()'=2E  For this, the function is setting weigh=
t_arr as
>NULL in the allocation failure=2E
>
>>=20
>> Fix this by resetting dst->nr_dests to 0 immediately after freeing the
>> old arrays, so any later call always enters the reallocation path=2E
>>=20
>> Fixes: cbc4eea4ffb5 ("mm/damon/core: commit damos->migrate_dests")
>> Signed-off-by: Josh Law <objecting@objecting=2Eorg>
>> ---
>>  mm/damon/core=2Ec | 1 +
>>  1 file changed, 1 insertion(+)
>>=20
>> diff --git a/mm/damon/core=2Ec b/mm/damon/core=2Ec
>> index 7f74982535ac=2E=2Ee233eb84a2d5 100644
>> --- a/mm/damon/core=2Ec
>> +++ b/mm/damon/core=2Ec
>> @@ -1060,6 +1060,7 @@ static int damos_commit_dests(struct damos_migrat=
e_dests *dst,
>>  	if (dst->nr_dests !=3D src->nr_dests) {
>>  		kfree(dst->node_id_arr);
>>  		kfree(dst->weight_arr);
>> +		dst->nr_dests =3D 0;
>> =20
>>  		dst->node_id_arr =3D kmalloc_array(src->nr_dests,
>>  			sizeof(*dst->node_id_arr), GFP_KERNEL);
>
>Someone (including a part of myself) could argue anyway initializing the =
field
>is better to do, for code readability and completeness of the data struct=
ure=2E
>But I'd argue that might only encourage calllers to reuse 'dst' after the
>failure=2E  Also, the 0 nr_dests could still meaning something incorrect,=
 if the
>first kmalloc_array() for node_id_arr success but the following kmalloc_a=
rray()
>for weight_arr failed=2E  In the case, nr_dests is zero, but the size of
>node_id_arr is not zero=2E
>
>I think the intention behind the code is not well documented and that mig=
ht
>confused you=2E  Sorry if that was the case=2E  I think this could better=
 be
>documented by adding comments for the function=2E  The single line commen=
t in the
>function body was for the purpose, but having more detailed comments at t=
he top
>of the function may be better=2E  If you'd like to send such documentatio=
n,
>please do so=2E  If not, I will do that=2E  Whatever is your preference, =
thank you
>for finding and sharing this room to improve!
>
>=2E=2E=2E And, this patch helped me finding something actually broken=2E =
 As I
>mentioned above, callers of damos_commit_dests() are assumed to discard t=
he
>'dst' when the function failed=2E  And the only caller, sysfs=2Ec, does s=
o, except
>for the final commit to the running context (kdmond->damon_ctx)=2E  It ca=
n result
>in DAMON running with the incorrect data structure, doing NULL dereferenc=
e=2E
>Similar issue might exist for DAMON_RECLAIM and DAMON_LRU_SORT=2E  Becaus=
e those
>modules use only limited parameters, there might be not=2E  I will double=
 check
>and make a fix soon=2E  Again, thank you for helping me finding this issu=
e, Josh!
>
>
>Thanks,
>SJ


Alrighty, I submitted a patch for the kdocs comment, this makes a lot more=
 sense now, and thanks for being super nice!

V/R


Josh Law

