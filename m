Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7347606B220
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XIZrg6Vi
Received: by kanga.kvack.org (Postfix)
	id F2AED6B05B4; Fri, 13 Nov 2026 13:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02196B05B8; Fri, 13 Nov 2026 13:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E181D6B05B9; Fri, 13 Nov 2026 13:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C90026B05B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:01:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DE7740207
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:01:46 +0000 (UTC)
X-FDA: 85430863812.20.109B752
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A2771C0011
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:01:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XIZrg6Vi;
	spf=pass (imf10.hostedemail.com: domain of roman@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=roman@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794592904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qx5F2tDerzQZ0lB87zR6bUAyzgyChxqTyHYx/YjImmk=;
	b=BUwjlpO867LxJsdmDzHw8B/IPzyYF9pgEOB4CshdRw4USr0fZMi9CTr3aM8bi5CWrNKrd0
	vWJKCHRLaEnmQdl2PtRB4fA5fWu37Oi58Cotn9vwpDz4CcbNnNE6Vc0swoJcGuRCByECXm
	bxT20N1jwzQz3RI1qAo0Qru4f9sHmEw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794592904;
	b=jtxTQ63fOYzKHpJ1LZEHLcjUr0v8Ccysq3B6vHiJ87QO47/EkyRxSvwYQIcajL8swv2wuo
	vWk528izBPdQRZhfPJXDjkPPB9i2dMrk9XNXWnANCSGcKxlP5BDjpXGNfrXacVR4O/AjO0
	Kk8vyPQH69SI8HLGNf140yvxfRLD1Q4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XIZrg6Vi;
	spf=pass (imf10.hostedemail.com: domain of roman@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=roman@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B7CF61203;
	Fri, 13 Nov 2026 18:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1691F000C4;
	Fri, 13 Nov 2026 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794592903;
	bh=Qx5F2tDerzQZ0lB87zR6bUAyzgyChxqTyHYx/YjImmk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=XIZrg6Vit3aXlTCbNDJ6Bkleo1yuoSB7+fWp3kHJTa53ecRgCLhMt3g9g+U92W4iM
	 jA18lJH8ZnoAFzaOWGRf9BHF8SeE5YP1pIbpQH3S9mZj59QNmlkgN1seK9w1bJou90
	 JfZCcD6MxBKHIdSgp0LHUN/Grw2sSDR1ydbtHV6aQ/8lmWCRthsjT+0moV2KSflruv
	 hjPYcTz3LXXYFyX1NZenudmNpDbnXblvmqclpT/pMtreQaY4ucr2WX9dzzpCG2Iv2n
	 /0yVGd/yc1U+2oZEN9VprWzywovAfhvE1UQ4VrBhs2d6VoVJgxb4iUC/zAvApDZ1iz
	 3j2fcfgb07B/A==
From: Roman Gushchin <roman@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sashiko-reviews@lists.linux.dev,  =?utf-8?B?SsOpcsOpbXk=?= Jean
 <Jeremy.Jean@oss.cyber.gouv.fr>,  Zi Yan <ziy@nvidia.com>,  Roman Gushchin
 <roman.gushchin@linux.dev>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  "Liam R. Howlett" <liam@infradead.org>,  Nico Pache
 <nico.pache@linux.dev>,  Ryan Roberts <ryan.roberts@arm.com>,  Dev Jain
 <dev.jain@arm.com>,  Barry Song <baohua@kernel.org>,  Lance Yang
 <lance.yang@linux.dev>,  Usama Arif <usama.arif@linux.dev>,  Kiryl
 Shutsemau <kas@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond i_size
In-Reply-To: <79c3445e-623e-46ac-a09a-0a5d21f117c9@kernel.org>
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
	<sashiko-outbox-212974@kernel.org>
	<5f3dec4f-0416-4550-a980-b464a90aeb11@kernel.org>
	<87y0aw8x7y.fsf@kernel.org>
	<79c3445e-623e-46ac-a09a-0a5d21f117c9@kernel.org>
User-Agent: mu4e 1.12.12; emacs 31.1
Date: Fri, 13 Nov 2026 10:01:42 -0800
Message-ID: <87a4nc7gqh.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Stat-Signature: 4rt8xfrydiext487pt9cm487i94qbaye
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A2771C0011
X-Rspam-User: 
X-HE-Tag: 1794592904-577372
X-HE-Meta: U2FsdGVkX18DCTClti064Ij9E3gzpt68lu9wd81TkW0OhkZNax3j6EqLgI64Ow/ODrI3rxo4CFk1YkiU6oVxJ7ZuVBb6eV0as2XJbIKwGGH6LUALtEwda+gV8FmSz43/+Ly+7969L8NCW3MSuGknSjBusp7a3dHrPD0sZ6U0y/xy5CHwDxQIyJPel8MrAMXpx9mxYP2GsX3VngCn9zQqmXqMeUGXxhnk5v5+X1BqEWbtcyQMCq5Fb3PyjXt1eevzNvbtygZ1c1jzp1ix9CIZntlDyscW4NQ+6fi0zVitbpR7+BQmJgRWz8l1jfP8C5/1s4JgbBGr57uqYYagDVT8IE2Ck7hq8xTArOO3mMqszLVi4xim8h3wtWB0QC/OpuTGnKUPAFBKEBV4xOGyoepgVeXPpQkCpQG+/N9KdkLka7JiMDgI5p43a4SeouxKDWyAMCIyvGZ9YqGJ9Q8LCv+tvtrHxjKPnxXgPVRVkBcUZ/rf7ur3czBvjqOCvpRRBOcioUc0mvnI6y004/RbFVKsdRIay7BhYFah0MCTrxRIB5KyuCEMth2m673DtIVMSPFs8ru6W7A4FMM56ECvsoOjTPZKZtx0JeormKa0c8H5c/QKktiw007zS1ZZ3jBWPG1eWlgiYIu53fFnD1nQ5xZgr5Y7jIQcIOwtnObRvrbDayytCI/wFMnUSIMwaXRX4lPzligEOGUY+MlpxqClSpduHDRRDDCW06CBLb2B2HFrojtZSGD2LOo8p/7XO4pJh+SCjghvue0I/9I5bR/CqarT0pdBCw88aH1CX/u+/ukNqyVICxENyr8BdCpFdv/v0Rc+oXehWAqQ59ovihbOBlewODEQQEA8IlZlZPONEBvrXQRkE5w6N3wnQ4QntMmF4os7BrNeUjrrmOiL/JQDiLxv/JD/vLF1RijJhPcTRc8UeSf2Y+ABcNoJvv2XqEEW75FS+l3ZuS2YJDSip5xgLdY
 6ycC543k
 G4KJOBiH1lmMM0uxopOFbM9kJlwjARrr1ea1CyHkcXqyvHJvqm7FAnveOj798AeDiDqPs8FsAzEmoE4A63O2mlY3yf0bSvzYuBK1+q1oB8VEyvpuc7rgassAajzlfW7FMBCAmO1kKPH5AZ3vzaqqLLbzWuxsi8bVDKoArqCL9aiLHAvu6YxwwGOCsrHgP/Zbrfz2UrAcmQih9P69dCS/hTqAtk1K0chrpObbMT3WKhOqsImieKsCkcz1SkR/+ABW3QUa7oHzzS5vuRY5M5/W5GOPSnuqW6/6R74Wc0BIfp7rDOH4ofQj5R/MhTeBT3zbDA/VybhVEzptrZ8xUHRoi042T2PQ9Jyo2ryso8XnashDBn/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 11/13/26 18:20, Roman Gushchin wrote:
>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>> 
>>> On 11/13/26 15:25, sashiko-bot@kernel.org wrote:
>>>> Thank you for your contribution! Sashiko AI review found no new issues
>>>> in this patch, but noticed 1 related pre-existing issue it does not
>>>> introduce:
>>>> - [Medium] mm: xarray node memory leak in collapse_file() [1]
>>> Ignore this shit from Sashiko.
>>>
>>> Roman, make it stop.
>> 
>> David, will do.
>> 
>> But also it's not how I want to interact on mailing lists tbh.
>
> Roman, just to be clear, I am talking about preexisting issues. We get bombarded
> with preexisting issue reports. Having more duplicate reports posted to the
> mailing list does not help anybody.
>
> It creates more work for everybody. And the least I need right now is more work,
> believe me.

Totally understand.

>> I understand everybody is stressed and overwhelmed by llms etc. Including
>> myself. If sashiko is not appreciated in mm lands, I can turn it off,
>> no problems from me.
>
> Sashiko is great. The embargoed sending of mails to the list is great. I
> appreciate all of that.
>
> Posting preexisting stuff to the mailing list is not great, at least
> not right now.

Yet I've been explicitly asked about it by others. So at least there are
various opinions here.

> We were very happy that preexisting issues went into the private bugtracker. I
> want to delegate stuff to people in my team to screen them and see if it needs
> fixing. Well controlled.
>
> Now either:
>
> (a) it was never really gone, and we were in disbelieve that preexisting issues
>     are no longer posted publicly.
>
> (b) Sashiko maintainer decided to re-enable it without consulting us.

The correct version is b*, it's indeed back, but in a completely
reworked way, as I wrote to Lorenzo yesterday.

Pre-existing reports are now limited to the first non-rfc version of the
patchset, they are limited in numbers per patch (1-2), they are
_deduplicated and posted strictly once per issue_.

Re consulting the problem is that there are several hundreds maintainers
with drastically different views. If we'll wait for everybody's agreement
each time, nothing will ever move. So I have to make some decisions like
this on my own. And, yes, some of them will be wrong or not perfect.
I do fix/adjust things constantly. But some patience would be nice.

Btw now you can delegate access to bugs to people outside of MAINTAINERS.

> I'm sorry if I made you angry, but I hope you can see how I suspect (b) and why
> it would make me angry.

No problems. I understand the problem with the maintainers load right
now.

Thanks

