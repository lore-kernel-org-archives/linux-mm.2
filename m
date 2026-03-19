Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CBE6107526C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8DF6B031D; Thu, 19 Mar 2026 03:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99AE66B039A; Thu, 19 Mar 2026 03:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6FA6B037D; Thu, 19 Mar 2026 03:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78CED6B0408
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:07:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A6E4C19F7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:07:37 +0000 (UTC)
X-FDA: 84561932154.15.AC264CD
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0CF7A40006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:07:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=fskvIZ97;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf07.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773904055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KstVXAu8s91wD1tzpSpjUCtaNtaqVzzDqrlbR2gPxhg=;
	b=OPQH12KCnl8vfHeCTBMuv+06dYFakUUKWCX0X1NVE4t2UE1Tj2o6Yf2CWjHX1tICAaQrXS
	g895PxZsGKakdPEfGS4NC2g828vvvsA/TRy3K74pyPQYF43qgQ+ZPjmDCBWGV195FXeICt
	YFtrjThyNDqqXuT8uIG/9cDwM8S9fJ4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773904055; a=rsa-sha256;
	cv=pass;
	b=sTZRLmun2oNTsNK/OE+KPo+bqP711+Z1Wn0fImwsMqOY12TYwSo+rAAT7vseDlJ1P8BZjz
	g2E83negVGEfCp+dbfP0R9JvwLzvUAA+4R7B26TqQgJThf9PI30iXZw/Aj8OhvURwXiSsp
	trYVLFNgx38xCe531TkUPM+AH4j2VBk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=fskvIZ97;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf07.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1773904042; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=e9ZNPiNMOo68Qkxam/C8cay3EsA7VGGltAnosDmkJEaK8Kjo3HpDTYEHw+TdsM4AKzMzPXn2nCLfgEwFM6U0q7S12A5b3ZUO2DBCM3JtfJ55e18wXncraJvPPHcK4rFxJ5w6nGxOiZvMuFLZjYLxDvyF6zGlR0gjhYPOpy07pF8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773904042; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=KstVXAu8s91wD1tzpSpjUCtaNtaqVzzDqrlbR2gPxhg=; 
	b=lSaqE6xk21yiR9BjYqMC8A0/Ylg5iIYDucA5u0e98GVT7CJR1FMXYKuDaWupi8+1qL/OtXprMtx5YtZVLyBBKBvSwEfLK5CraMk1N8JqE6issYdiMidgJ25QrZhnnXkVjLh5CChHu25mZ7cYsI6yjeJGKw/dxliDWj19VI+7zuw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773904042;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=KstVXAu8s91wD1tzpSpjUCtaNtaqVzzDqrlbR2gPxhg=;
	b=fskvIZ97/1BmLA5jpR5+dGchmAJqsjqdLNmyRNH/HfLIILLSV4evG0s+E4tmC5xB
	BAaxIthu9mZ0Mlyo1c2ZzpKAE6rNCU0E0/4LSp/RI12G0UpDW+r+8plHk+chNFiX+wB
	spKt6C7UGoNZxeykFGFug9wBy4u/rKdXVi36jsPI=
Received: by mx.zoho.eu with SMTPS id 1773904038826234.8226502046814;
	Thu, 19 Mar 2026 08:07:18 +0100 (CET)
Date: Thu, 19 Mar 2026 07:07:18 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/damon/core=3A_reset_nr=5Fdests_o?=
 =?US-ASCII?Q?n_allocation_failure_in_damos=5Fcommit=5Fdests=28=29?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260319043309.97966-1-sj@kernel.org>
References:  <20260319043309.97966-1-sj@kernel.org>
Message-ID: <B08CB6C4-72EE-48AD-9AA5-16CDA175B193@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0CF7A40006
X-Stat-Signature: htiw7mqdi6i4js6uqai88hm83nbjm9mn
X-Rspam-User: 
X-HE-Tag: 1773904054-768594
X-HE-Meta: U2FsdGVkX18GqbiZuyd3kuRA97cERy+xrSGwkzKE1o7IUqvwZ2AvjMgOIDOAENF7+2fmhfhYDY4OPduZ/IxSNCNQGeAP/HdxKObcBOjur7jl4VjQOSj5+cq5y1/j9lEJOAu0hkDXTWpO2vdXMG4J3QkIaZEIoUnTKvHKkBdySuTFv/z73koy8uTz3FDH5GnNOsthPr02kaJ76lMXIhIkQo58qo2gAFtO4DhUc+mk2x8+vi/pPaW56dwXXcFPvXOfIg0aybV/sjLz4EkpYu5THwt6qe+0YrwOcwznILZvuLB6PFmB7iQweXZ3ccaM/LeaEPIqRnJuj5djsVF3G+R1/L63WHBN3LRdrcA6XWA/iBObns5yBSvsn4L5NgQoezPKIyK2VmbASqw8NIwMi4icCpKWuunULpKvkxn17nt8fxalfQc9P0l10HOJ54uEZaeIBCGGa2MwxqFJKQaDe60k4MQ//yW1R49kW+HTTMj2NM0f0cI/VsLx+n4uPRN6xFcHXa+jp2GMahLnWOqU2r0KeU3AYUdrp65gQ9hcJKaKUwAWwru12S9g4g8snVHlCuVegtCqMTkj45QNFRW738mbTWMMWDggp2WkWG67+O6sUj7fNTmOL9yP7cV4iWFvXDUGE+YfJw2Blw+qWCw/JLfnUmeT/Lwg+Vfa2/lLpnMsfSm/yqoJeeoGysmIm1IB7ZtzAoT349SlkHDkhdBDZI7u1TlQA3N1wX/qw6L2qovUrgBmKkKlZ4rXeET/pUYMvTbumBDqkxlyvTqcw3SEg5GtGVDhTeeXn+msV/MdtI3SsfSBiG+b7Gnw9KdbkCdyONnvNg0YBYR5L9VWuYmURx4N+xSlPXWKi5Jy+4O7sqin8OY0w5tlqXSQzvbNAkzrAxYOpDxeVWFpndDh/iaMI2Eax8ZwjIqUaTihzUnNRDDW6QVUYXD2AgrqIAujWAMWI/yoNdA7QqjZ2QrWm6NUK01
 8gNto6wJ
 PrgCFRLygm5/t+TLasgvdLZx3XCuB1OeWlXsEAMLlu6vt7D9ZMq5BNlX/iDm32H5JfqfgN8DGazTSfw47Q0zzGHT2sbTFzZfPGqVerGsxQbRo5Nn5UJYaojCoectAjl012DtrOetcJqYweYGlPgQFVsOSsve6wYcndPr/Q54Gx8ANIcaL9IbazUrCw6AFYJ0NBM/vMDcYaruyg49LN41wS35QLyDJ3MYeKUG2OiI9UtHVMGefiazx9ezQSWHLZufrN0P4QROL5x+0NWmRR+m7cUVyvoB9GVE+5D+HXdspupxRz3DSqB5cdvlRNv5oD7xmoCbhx1HTIq7twqDZI6StdWIKE8qjxTOGUdGOGAkKOVjSQLM9hTCshT8u551Qjt64Wx1PnBYHD/FZBXFKbZ866+sobTI5G9v0yxLu2uJdOLyuBnquELWAyJCrj/gXkY6jLBzvMz1YvCnMjzXYBG5GSR3yrqVhso7L3wgXU5bJO39PmMc50927HQFULxGfSuHqg7r2ynjwFw+4X4XJ8is+6XWVbL9Uldfq2K23ZGgIbG7TI2tnbAWqSYaffP2yA50EKEnasqU20rYk+NER2HLr20OV8w==
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


Well, I guess hardening this patch is useful for then=2E=2E


V/R


Josh Law

