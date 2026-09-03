Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982C3C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 17:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C71C6B008A; Thu,  3 Sep 2026 13:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977926B008C; Thu,  3 Sep 2026 13:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D9C6B0092; Thu,  3 Sep 2026 13:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 694C86B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:21:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3CCC405DE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:21:34 +0000 (UTC)
X-FDA: 85173117708.28.8D63A6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4BFA52000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:21:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MIp12bdW;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788456093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uofprPFCPxfEf69MnbeHxACRkACv1OeYBLcQOB9jELU=;
	b=W0OPY8zH667Iv50r7xF86l5/+Z66FOPg4d2RmVCzYhKP87JS2a1vUoxnkbG8vZ1I2PlbOV
	4G0LvK81ROWqS7WeVqV474WepNOMKGcJ40D//S5u0jTR3Ij3W6vl3SWynjMfKLDUtXYJHp
	Wmhv0ZhIfoyDp+1UBlNYICvF9GqrRiY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788456093;
	b=BagXvLit4b/2n93bQC9B6GUisWjV4Ksof38lbSByDziDkFGCTJTm2UqHO3KH28Pc5PBCu7
	JLNiM6OjmpKmjgEMshN5nQ0slJ/uSuTzaHoqfd/7ZU0nKADOZZ52m/KvB1IGV4SSRLSJzR
	5Jv5b0Ph2xo2hAcWwAtW+aZ2JPD09T8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MIp12bdW;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C0A560219;
	Thu,  3 Sep 2026 17:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7007C1F00A3D;
	Thu,  3 Sep 2026 17:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788456092;
	bh=uofprPFCPxfEf69MnbeHxACRkACv1OeYBLcQOB9jELU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MIp12bdWHSMU1GrCwa+hfnX1qpV2W3u66ysoCVszd5rb+R79OlF5hj7b+DQN2bazx
	 eh1MiE9BwStxsnUVkLn6Qwj+C+HT9h+oDHRs+YbMfBdIH7L9CU8kBn95iYGllk36Ac
	 cfEtMHoLdsrMHgqb734Gi8d2inYB+SVJC68ZZm1A=
Date: Thu, 3 Sep 2026 10:21:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Vernon Yang <vernon2gm@gmail.com>,
 rick.p.edgecombe@intel.com, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com,
 rmclure@linux.ibm.com, andrew+kernel@donnellan.id.au,
 pasha.tatashin@soleen.com, tj@kernel.org, rppt@kernel.org,
 yu-cheng.yu@intel.com, orsonpeters@gmail.com, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>,
 stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
Message-Id: <20260903102130.b5cda1b08f3efd4ab66226e9@linux-foundation.org>
In-Reply-To: <314f11c1-ce5e-4b36-b296-0ab742550851@intel.com>
References: <20260903031608.1194238-1-vernon2gm@gmail.com>
	<aplfcTfjeQUgnrvH@thinkstation>
	<314f11c1-ce5e-4b36-b296-0ab742550851@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tmaj19e9xjwfisi9wiccb7phzbkf4prj
X-Rspamd-Queue-Id: 4BFA52000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788456093-179905
X-HE-Meta: U2FsdGVkX19FcofCcfYZ22eQtab1ogsjLrRY96fVNcR8fXoqzRwz0i7jkW35OcyPLVG2CioEaHNb9UpyeaMXyP2BGKyCDkRxW7WMFjD+dmoUev0oxXzK4gvWLwaTtkE12SEg7ipIA4RA88PDWqUzm8piXpS3v78fQT2bZdOIpPloEu1xrtPUqW5Uo67QBuxxrqNZWKNemQgNfO81R9Hlf9AgWDBWKOlEUv8ecVIjJJ4aBoI+iJKzl7DMJ6GFnal5CBQs6I1y84KFJWdOljhsISEomO3qXQP8Rwg7Wwo+0r2su+A0vvNESMRvK7K9deKla127l9WX1mMlPTTbBB6+AFQ/lPef6fRALvFTRPXjTTKhwrvCqNY/TAQYmWWJtupe1xG+M+qy3FJ1dCeMYPQpWuh1pVsBanL7gTlIQq+OL+J9nYS4BKfyElO126tmgkKAqE+SJoC7Xq7fOQRaW+sD8hNS1EXVMujxKgovW3ZZMHSwi/rAvH9u8BD+6JhjCNqdqHZJygjdrcVVO/Ueyiv6xzHKUm+Hvdi3Z9gnhj2ykr9tcE6kFm/kzh2JCeECEbrW0Yx/myNIcVFWHUzblNOsaJNDP0JR+0YGYTULN2kzs4YtagZttRGOevyDJ8PWyq5SIkSv+h9rIN1SYuqlo0Y+8GBxL4IBJqHwKH+Vi8TZOEDMMsvOajtTY2ZGrkvzKM0GF2mWPIfMX7giK6PFID8NHTpsB35XS84bmpMiTsARNNfa2hS2UXlpciQCsz3uEmfIHbvoX19XzHdiMbjtJgzdEjTrVaSLT/YQWk32JIbbYPgo4RSrA11rRsAToGM6+BOvF3m9U0xIOEySs68mzFX/PG1jXTVAsFweEZmcPeqqIcG+jPO2MHoUgO3d0WaQq6jViqBegQHcc6sn8Ok+VPwkZIcz/bJkyyg4DE1OjOmhpvDNwqbwlnrNjCbK+av6ZZqNnpghcqw/yD/brv+tA06
 RrFFku1l
 E9dmdVytdrWrNvAdKkIJPj7h8QKfeDtjsycs9YYQriuHTpfNF1YFdLtASkJEc8axl0mwq3LqvtrUem8JpwfXRWvGz65O1OUm5m1/vJg3nb5idLNJwD58LGslbGgwGqiUAykuGNjKiaEtutIn307jF+HyyJAfmVwgPlnfI/iT6hKE0U0hkFC1bNNwvfnPmuTETznlA1siNHJPTSRw3fVYWBkm8G+mpPBtBP/D1OG0vQcbUOwei7MRdRB+vLsMTxyGoOtdwxhTXXTPs19xv+NPXp1Tc0kLXVyV4GWdIix7iTohSaz4xxVqcpQJqPnVBfoXSfU3YpvMVsqv0s2Ay0LpONuAjeQjROSjHeciFHdCgTGPmHGBt3dqg5QO+B7lUPvK44dQo4GZcM6+G/Z1GB60+bwX0PXdi6tzu218Cz1e/C5ufQNq8H/GK4dt1BIW1Kp6lu6LYPoGu8s2OoXc6bPxXaZhr2wYdb6Xb3fhLZzYHqId/MZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 3 Sep 2026 07:18:54 -0700 Dave Hansen <dave.hansen@intel.com> wrote:

> On 9/3/26 04:54, Kiryl Shutsemau wrote:
> >> Closes: https://lore.kernel.org/r/CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com/
> >> Fixes: bb3aadf7d446 ("x86/mm: Start actually marking _PAGE_SAVED_DIRTY")
> > Hm. I don't understand why would this commit explicitly exclude
> > _PAGE_DIRTY from the mask:
> > 
> > -       val &= _HPAGE_CHG_MASK;
> > +       val &= (_HPAGE_CHG_MASK & ~_PAGE_DIRTY);
> > 
> > Rick, could you comment? It doesn't look like a typo.
> 
> My guess is that it's some remnant from an earlier version of the patch.
> The asymmetry with pte_modify() vs. pmd_modify() just can't be explained
> any other way. It _might_ have been some attempt to say, "Hey
> _PAGE_DIRTY is now a part of the pgprot_t since it's part of the
> 'permissions' of a shadow stack PTE" that got abandoned.
> 
> But I don't see anything wrong with the fix at all.
> 
> It does give me pause that this has been losing user data for so long,
> but it must just be a weird combination of features that few folks use
> together (huge pages + MADV_FREE).
> 

And with heavy reclaim pressure.

