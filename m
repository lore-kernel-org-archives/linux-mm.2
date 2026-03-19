Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF871090237
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2726B04F9; Thu, 19 Mar 2026 11:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BACB6B04FC; Thu, 19 Mar 2026 11:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7296B04FD; Thu, 19 Mar 2026 11:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 398E86B04F9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:13:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C88121A05E7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:13:12 +0000 (UTC)
X-FDA: 84563155824.26.5178B79
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96834160002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:13:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=a66fUyLR;
	spf=pass (imf08.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773933191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPmnnApMywamnXXS4C3JiFUZnEyIENynnVK9tYqgVks=;
	b=DIjxMa35YRt5wl/BHbOhPVx5HTs/3BNmaMGZvl3Nlvu8RO5Kam/PFiOs4O4HkELnnxv7ip
	Pk+NIaWiisZcOFDCaZAV60XpyXXK2oct6K2brbJHZBWpZ5OyoNx9NnKfI6LiI4FyBSh374
	zUrW9MjxgnwSpV7LSmloLRNduNd8Luw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=a66fUyLR;
	spf=pass (imf08.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773933191; a=rsa-sha256;
	cv=pass;
	b=HzNjYZEinjhFerNxSC1DxovrIDWNylUp4BS0/CecQ6KYukcTBssXYIQOszztfAMqXJBQFT
	/aiYqBGTJipuGYWR0cSTw06b4r5x82qUbr5po1XWk7CcDI9G68Du+o/iVgN49q1+FhVi1q
	PzRgrZll7NWW1vCxWGaB4zW6i2GwXAk=
ARC-Seal: i=1; a=rsa-sha256; t=1773933177; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Pvj757HxgJE7m1HiGxA2ozaP1gr3GNqqkfOII7RHLBdKf3kjMAuZkPkf0YcsuRiynEQ4eEJf4oNS+nc39xxfLn5DEv58pYe9JiZaaguADomzc/PrnxsHOTRipj8QpqDFA4FcXJu845TfLXMrsmkXS08pIfgnBM/X8P+sKO35+qA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773933177; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vPmnnApMywamnXXS4C3JiFUZnEyIENynnVK9tYqgVks=; 
	b=Ok93RC9nYStxyG0MCE4aex5vPjN8d3f+OLSEwbPGwLd7GyK1Ia3cZz+Nqw4+fCAvPs7XCFCe7ukF6JsBtNgs6+CsRNFaS+qizvu4aO3wdzj2aovxwW4TTR1keyQh/Qwv5uoQTdAEFsW6t4knxmOn5x3DMP/EftyR5cxsSGfcNXs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773933177;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=vPmnnApMywamnXXS4C3JiFUZnEyIENynnVK9tYqgVks=;
	b=a66fUyLRrG/VqOHfdwpJQDcPZoVN3n0L5z7VxeFkvkONYcQ+hY6NVYKeFomDvgJ3
	NSR1mvMClQN+ClCc3Pnbu16fCor+tio56tS4+a5cHBJXyGeAjrBXksrKH/HbTYqOKKi
	i5dtQ+ZY5IWDzi2XTD8UC3KouhUchoWdmMnaBsHk=
Received: by mx.zoho.eu with SMTPS id 1773933175222952.7815216944042;
	Thu, 19 Mar 2026 16:12:55 +0100 (CET)
Date: Thu, 19 Mar 2026 15:12:53 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/damon/core=3A_reset_nr=5Fdests_o?=
 =?US-ASCII?Q?n_allocation_failure_in_damos=5Fcommit=5Fdests=28=29?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260319143437.82957-1-sj@kernel.org>
References:  <20260319143437.82957-1-sj@kernel.org>
Message-ID: <9E7F465D-A679-48A2-9A5B-03F674CF7ADE@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 96834160002
X-Rspamd-Server: rspam08
X-Stat-Signature: oya5w5jscumthj7ydcj1g4p5xzydy85r
X-HE-Tag: 1773933190-394004
X-HE-Meta: U2FsdGVkX1/TDCbWEbyRI/D19WzlWK7Fng4CVb52P+5FIJbxnCIlilHNz2ZFjnDhSR9hRpqA/penhYHrX/FOhZddQ+YqUrwnYb+bVPdFjRMTNnGKFXT1UlDyX8OzuLfEepj1YFMjP2sTA0fLHyzzlXm8Av1+qstrTInZZ8kyxvaR1DTH4GUDFZfdTF0nIcmfjFQkrh8aOolRf4qyms9zM3IQKwlU+SPpFEH6202dfPteASiT26xaBpxMoMg2Q1MJeJJHYrRnv4uCK+Ck4pG7LUY7bSuzvB+mxQhDkq4emHezXr3M1HgLy60uaAD7eODcgrTm9j0HV/FxT+9wmYCeRDqaE7q4y8Qy+h9euz0H6bbb9zNaRAzC5MRa0k7W1OHO/2tJX39uZZjuYqT6rgL2PGxC4EPFm/YU3Hyi90cFVhY5MzQ1sUHjrIPx1pxzxLasIrkVRBInSAMhfa7eaSk8anj21mf0gAB3jTa4J7l9jM6cyskjNrtRNnbrJjC5eX4psWsb2SxYvVNsSKbE4YwBWhU6S23W/HKoC7Hw583ABX8d2kolDzmJ+wGoAJIakZ9OlQ5fmmoCONpgrebwrGe+HDU5RW596Jkx++DsZC5q4H6r3Uic90xyBitjSTj9DKtfCFmFvMKIBEBLxXOA3M1xDc9r2LWvadmQjwZZxZ8yOR+z1TWSM15saNRjKe4z2luQzQJCWnqwPAIIr5n2bjQOKoFjv4ey3wPjvLS8C30VHa7zgYLmCecF2ih/fy5pqdww7NqAoMcwEchX3elPWv9j7VT+VFVtxmoWpgUniEAxKCcAlgYdpXwNm5p1tcKtqh7VcmryoYMTVrUcRAyAlHLbZjnSC4I1YUzi7CheNfvM07vUVnFTonNZNLnuvod1eyfSWvlx5/g3W9qGsgJnlGM+AEoX6Pfmpq56omMV3Wuen+84FxvUvBAb4lYrlk9NhzLa12o/WLEuAG55Zd+P9Yh
 jw0eIske
 JjnKlU6ead1T1aVnCNMMi8KM+x7EBdpiQp7C8cevHuNJ2WyWJbD0HLQctSwxFjcEE1yF5P+WkwotO/Xc7eWvmbgybPIFgaMSYGGBeWLvzUYe77wqKmVaRzOqa0O0KJnU6YYHwIhpvNievAQVfJKbsrZCb5aORSJuIlUBQv+fC8OOjIv1KF9RBJ/u+RXHPcz1OePY6TjdBiCSmvGx4OZY4bLSGZKTzIt0LPajqb7l7W4GUkl6NW+P42UAEtOyFhI7Qvwio8V4nCcqA9gHJvjccPJydY0MVSBUzs7Z+9kahWczeMBPY+8bPxBafYNorAIuVNmjbzS7q2jaUjShW/JO/zVGQ0UW+0WSt4E2HdREd+QkYL6lzg2w019A4m4bkMMAv9XhKTx3WAl9sKe7AJgNh/9c4O2bgD7B22ZHXPePS0mQn4hsFxdcimONMS64yKFkpEdN2Ixe2aO3wzze11gQffPAItBAzuHpQwNvr2qeg5PKirlOXKlkDtFeDDtYU6JfrCbU+/Dli3hH51OVlguHONt8qvQtN79bW45/B/Cdky0TTfVNURDhrz8P7X3k9nA/lRGmFY1RXNiSUEqSN0Dxi2N6BWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19 March 2026 14:34:36 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Thu, 19 Mar 2026 07:07:18 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>>=20
>>=20
>> On 19 March 2026 04:33:09 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>> >Hello Josh,
>> >
>> >On Wed, 18 Mar 2026 21:49:39 +0000 Josh Law <objecting@objecting=2Eorg=
> wrote:
>> >
>> >> damos_commit_dests() frees the old node_id_arr and weight_arr before
>> >> reallocating=2E  If kmalloc_array() fails, the function returns -ENO=
MEM but
>> >> leaves dst->nr_dests at its previous value=2E  A subsequent call wit=
h the
>> >> same nr_dests will skip the reallocation (the sizes match), and the =
loop
>> >> at the end will dereference the now-NULL array pointers=2E
>> >
>> >Nice catch=2E  But, this is a sort of intended behavior=2E
>> >
>> >The idea behind the code is that, if the function fails, the caller wi=
ll
>> >not resue 'dst' but discard it=2E  Hence the function is only ensuring=
 the 'dst'
>> >after the failure can be deallocated using the deallocation helper fun=
ction
>> >like 'damon_destroy_scheme()'=2E  For this, the function is setting we=
ight_arr as
>> >NULL in the allocation failure=2E
>> >
>> >>=20
>> >> Fix this by resetting dst->nr_dests to 0 immediately after freeing t=
he
>> >> old arrays, so any later call always enters the reallocation path=2E
>> >>=20
>> >> Fixes: cbc4eea4ffb5 ("mm/damon/core: commit damos->migrate_dests")
>> >> Signed-off-by: Josh Law <objecting@objecting=2Eorg>
>> >> ---
>> >>  mm/damon/core=2Ec | 1 +
>> >>  1 file changed, 1 insertion(+)
>> >>=20
>> >> diff --git a/mm/damon/core=2Ec b/mm/damon/core=2Ec
>> >> index 7f74982535ac=2E=2Ee233eb84a2d5 100644
>> >> --- a/mm/damon/core=2Ec
>> >> +++ b/mm/damon/core=2Ec
>> >> @@ -1060,6 +1060,7 @@ static int damos_commit_dests(struct damos_mig=
rate_dests *dst,
>> >>  	if (dst->nr_dests !=3D src->nr_dests) {
>> >>  		kfree(dst->node_id_arr);
>> >>  		kfree(dst->weight_arr);
>> >> +		dst->nr_dests =3D 0;
>> >> =20
>> >>  		dst->node_id_arr =3D kmalloc_array(src->nr_dests,
>> >>  			sizeof(*dst->node_id_arr), GFP_KERNEL);
>> >
>> >Someone (including a part of myself) could argue anyway initializing t=
he field
>> >is better to do, for code readability and completeness of the data str=
ucture=2E
>> >But I'd argue that might only encourage calllers to reuse 'dst' after =
the
>> >failure=2E  Also, the 0 nr_dests could still meaning something incorre=
ct, if the
>> >first kmalloc_array() for node_id_arr success but the following kmallo=
c_array()
>> >for weight_arr failed=2E  In the case, nr_dests is zero, but the size =
of
>> >node_id_arr is not zero=2E
>> >
>> >I think the intention behind the code is not well documented and that =
might
>> >confused you=2E  Sorry if that was the case=2E  I think this could bet=
ter be
>> >documented by adding comments for the function=2E  The single line com=
ment in the
>> >function body was for the purpose, but having more detailed comments a=
t the top
>> >of the function may be better=2E  If you'd like to send such documenta=
tion,
>> >please do so=2E  If not, I will do that=2E  Whatever is your preferenc=
e, thank you
>> >for finding and sharing this room to improve!
>> >
>> >=2E=2E=2E And, this patch helped me finding something actually broken=
=2E  As I
>> >mentioned above, callers of damos_commit_dests() are assumed to discar=
d the
>> >'dst' when the function failed=2E  And the only caller, sysfs=2Ec, doe=
s so, except
>> >for the final commit to the running context (kdmond->damon_ctx)=2E  It=
 can result
>> >in DAMON running with the incorrect data structure, doing NULL derefer=
ence=2E
>> >Similar issue might exist for DAMON_RECLAIM and DAMON_LRU_SORT=2E  Bec=
ause those
>> >modules use only limited parameters, there might be not=2E  I will dou=
ble check
>> >and make a fix soon=2E  Again, thank you for helping me finding this i=
ssue, Josh!
>> >
>> >
>> >Thanks,
>> >SJ
>>=20
>>=20
>> Well, I guess hardening this patch is useful for then=2E=2E
>
>Agreed=2E  Maybe adding another sanity check (e=2Eg=2E, WARN_ON(dst->nr_d=
ests &&
>(!dst->weight_arr || !dst->node_id_arr), "foo")) under DAMON_DEBUG_SANITY=
 might
>make sense=2E
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Maybe merge it as-is, because warn crashes the kernel anyway and the patch=
 mitigates it=2E

V/R

Josh Law

