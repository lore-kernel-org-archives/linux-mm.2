Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DDC1C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 20:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95F86B00AD; Wed,  1 Jul 2026 16:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6CEB6B00AE; Wed,  1 Jul 2026 16:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84346B00AF; Wed,  1 Jul 2026 16:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF1FA6B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:07:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D8D41C3330
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:07:08 +0000 (UTC)
X-FDA: 84941291736.07.12EECB5
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0FB9040003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:07:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782936426;
	b=DYYPzx/1OFsZ1dCSUmfFzmwX3ClkkglMfISvaUaRlyMTU0+YNoZO+y91rKUos1IycSwgsK
	gfQ8gSeOwEYheTdEBaeoGQEJ5X4El69p3pfqe/RWl88apPKv3XAP1GJ18Wcv4yAPrekvRI
	bxn6mQJppW17YBabbiqdM6jjL5Zxdzc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782936426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlvkbBWp+nCtDdzWKMgtdcXUqu08ewyXUHePXK7va7c=;
	b=cobKiTsm195qtirMTBgWj1TK8PWhJkUdG+cY60km3qVMRZjRYggTIdYqHaWeluQkvLGUZk
	gLdBEFaawO+rwdrihXRMGu3NILaMJw6IP4ggIsaQqX5SfZiRpwJEegMmGeWc6FYXdXb3su
	Fyzomhy+mY/fuASN5hBen6WlCRczADc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC3931C7491
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:07:05 +0000 (UTC)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81579C26B3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:07:05 +0000 (UTC)
X-FDA: 84941291610.14.C6EB057
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BEB5C20006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:07:03 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782936423;
	b=waYGeUklPrf1SdjWOtfPoubXkYZt2MzP0ef7XXUfFmOaAmqAJbwTXbm0OOyEeiHvAAgyqK
	XB8pPzxwZBKU3gmhDv8pf4rmrw4M10kLKgWbFNtsxCqyRFwFVPljBYlYCzKrTK+x1vSJMd
	VVYjXngGGmJ9sxVExTQMOq28gnFSo0I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782936423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlvkbBWp+nCtDdzWKMgtdcXUqu08ewyXUHePXK7va7c=;
	b=3yHrbNL1O88Zexzvt79trJXumUB/JGAJgH8Ua2Cmsf1jySgu+QzVmWQJLAzldyFK/h9tG8
	P4A/cZcGCAetQyu8shTFEE40C0Gh2X+lVar8ELiwis/4vovV9vVSdr4Mn22I+sfjO9ZaBr
	1DDXKaU1Kg7KJIL88zU5zoxgIHwPSrE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Claj4dMc;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FD4B6001D;
	Wed,  1 Jul 2026 20:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEC01F000E9;
	Wed,  1 Jul 2026 20:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782936422;
	bh=JlvkbBWp+nCtDdzWKMgtdcXUqu08ewyXUHePXK7va7c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Claj4dMcTgt01vsBm9pIoz3ZxkgeC/HuvGWH8eDcEAu8t5aWHSbTv5N1vZqpPXUpE
	 +OsxvcENS2GHHiA3KNoQT55kEzk8C9B5oyPPmiYpmsWwVJD+5AACL9RJ9PTfGTxcBn
	 9uzK8+S6uzC6CkmNmqOykqeZCTk4rjcrDfCnz7uSpwfxjkdDCr12R/1UQNoxj7q7up
	 jBH7OIOA9PkY2P9lU5aSkyGRlcu88eRBPvumPHKLnmR3KmomqF/dS1O9RtFsCu8gZ4
	 lGmomMJA44wv1Pyqse5gqMrIYnvBQZUx1xzuqRngnqBStmcO4vfSMwyaAERoqbny3B
	 68UO/kwgYXaow==
Message-ID: <c4faa211-22ff-4fab-a95f-1c2cff35f684@kernel.org>
Date: Wed, 1 Jul 2026 22:06:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: pin large folios before splitting
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>, apopple@nvidia.com, byungchul@sk.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
 kernel-team@meta.com, sashiko-bot <sashiko-bot@kernel.org>
References: <20260701140638.840773-1-usama.arif@linux.dev>
 <78C557ED-3CF3-4558-9BA4-C43B30E63F67@nvidia.com>
 <20260701122745.2bfab3347691b658fb93f601@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701122745.2bfab3347691b658fb93f601@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX186YkdkZ3Ph9s4MDL400Uabu4MmqvSw+8Pye9NHy5ulqUN1wQj4f8EjE8De4e33idMF9oZDmw+6sxu3PHQ/REjAP5oQQH+6pZbGTJ6qITmfVCFnq3Iyw83oQrj3kUziHxQyzpl7FR4fidvCMbkOCKkXska6sYHZO4DMUodqPt/sms+b+Drkc2EV7ISNoTZ13Rse43Yr4G5MjHOJOlXDFqDExljgX+H99xCAtzxfnYUPvEkYAHQ9rnMkdvvXVQN15JNL7zehfKPCFksWujkmwO2pYdeLojl5A2kfzdVMBIH3S+xbI7APjVcIBhoJOkbOgx9q2oHXeEmACErm5eT5NBCxvqp/Vfv/Rs8TiK7InCDQpAQzKtbtDcYZZrMTIZlcjJ/0lPhUoOrrLEaceG8JIh7jvkv6Lwppk0ReTOqq84idkhSBdlbCOutSnPJTGljA3fE+f84Ik7eI1tqTrJnMKXWvbd0PYfWKnPF2I0/u+afMLToH5d0pJfK6Dx7WBCbIhKrfDCjqlHbSFNZQVNV21Zz+1NX68hcxrWVEE4rr/lyS3vAZNzK2RUHzX9b7EFwo/uiyyaGAHequperiut+IHkXkOjM+Rsd+M7lqK1VQ6fUCKkPHluuGHnely6EhrXLEsZsJBX0eYIIslYqcWdMLw/aO7ziUuqWK1nxbbMUbBnWGYINvtHyTU59uyV5qqORMEdA5G8sNfCEmSl/MkBcgHOSlw6aoeXnOoMICaCnkUPil06k/tZhDSzNRucvY5bAx99Hdicxfr/SIFDJFkfP7gbf+/0yThY32vSoR+1Y1bEN1oYoZuvuurDRaAyO6dWkLoKwlFsyye2fFKy3LuayZIJ+5g2gPucuURE2sLi5iBh9uFYX765UhlQKauaSUaZ8dv+GTHF+peBuFbIINsxNizfGqGWgwIVdLVD5IMe+O2gb3QWkV0ZzLyFYo1LGttI5o7H7wUKrE4LM
 ydjPCfgl
 lKzNpamUx1zDl5jIpMRuXPvEioAV3YxSJueMso+NC46llUR09u98yyNYCrEUWrCC/IbXPRSP/aOvaKxOMCxT+jHONK9Gg1nenGAyo6tB4fShWa6+VTe+yKXaHqS7ZjEf4uqycrA6/IQAR0/5ePeREMfhoFx9XIexbXWoK9nc8TumSXAr/CCsiLpKk4ScV9IWWPohWrplF0saE+Yhvs+cht0RwJAST7K02oYMIwsyeVpzcoE+4VzA0UkaDb1tHFZ2oqipT9WK+4mWv0lpWiC17RnbMFqZTEXWWVkP97YVnUll2WcsmL5ZCFaMEU8tEcebMDgSowd6HUKPg0lSMLg+3PYxTXQ0JYhaSQ8KNlYKrvykzaGIpGkT55iK8+zjuWi7tsPV5RdGswvjLMN94B4+vLFfZww==
X-Stat-Signature: 4fpbbe7f9rfcm3tm6gcwwge79am77fap
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FB9040003
X-HE-Tag-Orig: 1782936423-987987
X-Rspamd-Server: rspam09
X-HE-Tag: 1782936425-614828
X-HE-Meta: U2FsdGVkX19FEfatBbsUen3ZwhAhXCaqFilRNStPdannvCbakl0TS5rT0dXWc4VOp2HxMDlPz645ad+RQfnUeU6nmIlfGSzyxKkey+aCzoCcCqeR5LNxyG1a90eBUW0egdfdIt2JE6BOkGR1c7StzKWpgllZrWTQNqL+LbBtGH+d44HQtlvJn1xx2xfBAwKOie6GNOt/umB7cA1ptYoK1V3kOb8pFQ9u7Z5rSCGRSmWAOk3VrwyPvLv4DZ6+0/oO6j1TUL/qNpSoEnvSaKL142uSGi0i9vpMl0i3vuv0Fbc+YB3r+tAx1lrHA9ReMipyxCKNV24BVQOkt7GR3atKQiamfwS/btQlnHFcEBwtJfgNp+0pg1F3hySbYZOwkapeGVtdTGcSstDs5LcX1HHlRk2BZjp9crM0AZV2dXqc1uxltnRfV8qgsH8XtUCo7P+yDjwMqHcpiz5EKSK4M4rB9Wt46GLG1JYPEomV8NMXsya/76lqyA9/gQqn7Ejj6UQcj2KD9a3ueMf6bS518GGokmsdQ3EaNWuanx1LKC2k9UOMUkj7jdU2F+fG66nA2jQh4JFxtfb6PG5ywpltJoMU+iCsdnO7FyQ0lMnOtaOlDR3lKj/G2ZwCEQGqILwbO+5ssLmPT9NDG+aHt/WOAyUS4rPM0E/V0GBkIaOBF6QTRsaUHzAsmcpx1X14y4lBprIcmsgOXLhjDCj8ZdwK0d/YftMheIFT74DD73N5U488/cXk59i1mTtvoq6g5ObR92XqfgwQw0E1ZvUdns4q4tWYFWSrZLbZPE+P3sPf5hZyaZUzJJgYp1oEM58CUjb5yVEFJCcLU2yubircVCmvlvlFeTc5KSCWapcQILg5bOMpUih+bnfz5mz2Gp0iCBC0+B/M3HzpfWU4L1fWjb8GZcyOkB6dBVxCuWjV8Rf3iOrNkK3MGmtq/KX3vpAjM9436PKw8Xz72dOVOfSXOkuQAM1
 wEz6MlAB
 w92T42cb5te8mim63JH7pJuN9WrlRTUtAJ2dvVG1IED0DDGxsRTdImBR9POxtdTkGy65tGctAc8zJaAyWa2yz8uF9BqqZp57k8eTeHr4eH2tWHFFlghPs0pTauSSJVyho3SLasf8J4HTPt/zFTdUUMykXQMiOVk16ti+9v5/a8atxDrtSZB/MAft46ps0caFNbzLDV7ljqdNIMJjlRz7n6l8vL0VDUevCagxbOqNRywglMGg38eQ5aT7H4qKYl2raNAawgCb3uIYtJIvq+gtS9C/xPmdhkI4fr05WnvbHUwQVHOaOFhHThC2fLnqH5B+k/SZ649L+CAFLcA76xNcxRURTleKz454NFOYmkJuYZTZBhlCvlOTXY0AF6a1xrOPxpBbw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 21:27, Andrew Morton wrote:
> On Wed, 01 Jul 2026 13:02:10 -0400 Zi Yan <ziy@nvidia.com> wrote:
> 
>> LGTM. Like David said, the comments might not be needed. Thanks.
> 
> I like the comments!  They may be uninteresting to those who are
> already familiar with these things, but they aren't the target audience.
> 
> How are others to become familiar, if not by this?

I mean, it's one of the basic rules: if you lookup a page in the page table, the
moment you drop the lock that might be invalid.

If we were to document that everywhere... this is not really the secret sauce we
want to document everywhere.

-- 
Cheers,

David


