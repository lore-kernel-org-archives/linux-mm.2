Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE74E66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488E86B0088; Sun, 21 Dec 2025 22:18:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436A86B0089; Sun, 21 Dec 2025 22:18:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342576B008A; Sun, 21 Dec 2025 22:18:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23E2E6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:18:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C47208BA50
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:18:47 +0000 (UTC)
X-FDA: 84245649894.01.705FCE6
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1021340005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:18:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EEFnGh2l;
	spf=pass (imf07.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766373526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=dSEX9YgmDGq6W//WwbZ+YmPko80Tijktgs830EHMcng=;
	b=IpigyBMhyTUl60YX+PMNPLmhKrT/c+a1V9zBfdZYzi36zLnOmC+UaWSXTU1cL+9o+c2Y0J
	3H9M/vWwiXLZ9SiwKf/gUIJNWlWAHQKtzZHZ1OyOWloYvthTlAw9SX6wpOxMPlOIiwYEUb
	Lz2sdRtHqzlwLAevhuCqQVssuzF62gQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EEFnGh2l;
	spf=pass (imf07.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766373526; a=rsa-sha256;
	cv=none;
	b=spkRy89N1IPI0hbnWdYRu+iLakCEYCq/habT8Jz4JE0q2sCdR+7NgURnlKk6E64lmqhZIM
	CdmNIdVw1xbkwbs7MM1VfL++7XPSSO59HdSBcL+jwgJnRpMTtCqdEmNU6mkeALyCgs+Ux8
	b3m12VrxZTgHnx74wPSfB1Oa7nSIcnk=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a137692691so40965915ad.0
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766373525; x=1766978325; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dSEX9YgmDGq6W//WwbZ+YmPko80Tijktgs830EHMcng=;
        b=EEFnGh2lGw8Jyyb7JUiCKhY43uyRDgQDYa/LQSe0iySrpkRYZXDVaEgpmlcP31biZv
         zJKnQONkSjnyVfL0WdLpYGvWWR5Io8GGtsAaZi5qE4PJ5fOAwHBrje4B1SoCyhL3Sd2K
         CjAitlT5NwG4rXsaNv/xuwE9DyQJaRcnd//ek7sspM3/cj942thSj/omN63SzpHE9cIb
         Lmgb40VVpW5KJNHP/dZBE0tAcyWe9U4Mfg9bwcgesQm4vyNMMgAPfE3gxuaQR5lLz6G/
         A426JQ8ffuvCvQrfWUTN6Gx2If2ewjxzednoY2DNatGzXJMOZjSakwwOk18VfQ4j0+QZ
         uRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766373525; x=1766978325;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dSEX9YgmDGq6W//WwbZ+YmPko80Tijktgs830EHMcng=;
        b=JroPZZhVICtH8Ay8UNoET8ghT4MBlnFbAk96JImDRQH+voK4RDciPI13Z5hG/GXn5l
         bjcOROt6Mm8sP5TYLarhLpUooNvj1ElvRKfqtksUETUM8L0+4P1vZ96rGElQz8/QPGwq
         tCOsHWgqqY6WF7EE8G6tdRXTdC1SDaZfttb4xUDydPkjmqPPTlm/GswlPS7wzrYRl7Gs
         AkPJEjY6ZPhxDbm8YKVaR2vhunsQw4KT+YQ16JYn4y/efZKQ849WZ8ACkmi8uJdVI4xc
         +xrKvyGhJGDnYwvrIXxHCfM+flMZTGa73LFXDN7MSNuHPtaS5ZVJDEOELc8AS8dJ69cw
         aHIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXz62/xOMc6279CJuaN46zr5qMMKJzxrME5lgBX81EZMJObqaQs4mcdfJ5FfguzND+cwIooDxHCSQ==@kvack.org
X-Gm-Message-State: AOJu0YxvfD+GPWW3i5JacIM5601RFXkn48CFVW/Tj9WilSbI5lzNyOwc
	zwbxhP/SskXmbBBY/AS3eMkyLHvdn0qi3WUyk6SPMPYwUE6AmCkbLfS1
X-Gm-Gg: AY/fxX5h+CWJdVsfF5kOT1FAHqILA6SnfIU7qNsnRzaTrImBenGhWtt6hHw7WSf6Jl+
	aPtzZ2DT7gGQCfeey4PsQaV1ZfmG/VlGL3ifjMqeKNrSAqBmTTPMmUwtJ5wL7twSZTmtX41FJxi
	gPzym99kvb/RXmRlZZnEzzTUpHtKzUXyUG5rk4tDf9MH6oTshgFMcL+PNf87prktCKocPVlQWwa
	3HVPiBGkzuzKe+2H7mSHzSV0jTRYYLPpKFrBRNFWB5h5kyv42c7ZAQppqROudrgJ1G4ml/AvA6O
	GJwRCcGsVczIK0uPgrk9IoM19hqYPvRo3OoofY74w129zxFAu5Ek8Yi89rzQLDQGlPQ3EJTDsxD
	2//aTlmgkvFz2VHqeTVOA2qtiQgO7IkY/yarNsu6wdUeTMPyiY3/DAMunHb/JCJbJvtS6X/h1dg
	oVWIs=
X-Google-Smtp-Source: AGHT+IE25cnCTvyNKTbDCfkrMSOXNApuJseJLU6aD26Xlbt6oCT43145DxEBaionq8+6wAvphhVpBg==
X-Received: by 2002:a17:902:d488:b0:29f:2b8a:d3d with SMTP id d9443c01a7336-2a2f2202ccamr90870945ad.4.1766373524799;
        Sun, 21 Dec 2025 19:18:44 -0800 (PST)
Received: from dw-tp ([171.76.84.27])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d863sm79699845ad.80.2025.12.21.19.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 19:18:44 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Sourabh Jain <sourabhjain@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, x86@kernel.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported
In-Reply-To: <655cc605-2ce1-4ccb-8cc0-a0a31a9c89fd@kernel.org>
Date: Mon, 22 Dec 2025 08:42:25 +0530
Message-ID: <87fr93ky5i.ritesh.list@gmail.com>
References: <20251221053611.441251-1-sourabhjain@linux.ibm.com> <87a4zcml36.ritesh.list@gmail.com> <655cc605-2ce1-4ccb-8cc0-a0a31a9c89fd@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1021340005
X-Stat-Signature: 78ahedifh7eo3fzq3cfoi5t385hx5o8s
X-Rspam-User: 
X-HE-Tag: 1766373525-14832
X-HE-Meta: U2FsdGVkX1/k1k+S7YWitaDw+TvcHLVPgxaN00hXMSPslUfMi/go3zqhOTlH59lWlwlt0uNC+ACiYL4T5ajIOrRI7uBDDCRbTW5mvExiOc0MtlzkgKQmgh4gMHIpPTGl/XW6z+fFM/y7ZEEH/UbIVkBhq07MhLc6yGP30Alq+mEN1+F4Q+nCuEDsmkrxD5rDJcYXAeE1QoS2gn/C8MBqz8gvo8Y1rPlEUBHcsMf2FhR0ApGPAHfE/xAIfWtzXpfcixRe5JN0RKlv9e161futIhPoXlr7PJYWsgWYRlkb3On9Q1axICS8qVzaM13OMKNCRWtiHhecu+AWRnLWec/ugIHM9SUmCXYOy+GUhT3utPS0mO575jSnP+1Tt8LrR6LqxBFfk6Pnf38Q8MtnkpQWx8yfc+CjX8GtbjcFvZfQGPhSYnRqn6ztOG6WYD+15EDbn5OB+QOrlEPO0Bhq7BOL3uzhyvLZ7zMpodMRhJ3AzWJLwpqwerZoKSziicGJWryyLqJ8kGhhvt+GqHK8obgM3PNeX4KlTuYFVyrqi0BH2aFnrE3xVfNquLAXr1m07ABWIccMpWlkjY/dkZ2gywGymRnHjV3jYcEASmhhLRu8xLb6VcFCin3I7uP5li/UXy+I9+J42G+0HMKG/9oPaDIrTjrg+2WTrmp+/ppfwQyP0QykIVeeAZRAnyvgBmawS10oJnMiUsgjRMi7/3hJL72AuMGxAjRTFEbs9GfPYr85CR1bhnvEgR4m7W47BoyBGS/JBI80srENonys8uw8q+kHyJHAcYUj+JqyK0+zTE/+UDs+6aUDNily05zVDJK7sifoemOqsH/Ylo8t/hkjtOkkXIePu/xpHGj94hSJpMAvKHCKIHHv2efS2fX/XEh/n7YYjHNQSgFclTI4qyy2bAh21f8HS7DiSEQnPLAw7WLxx0R84GJ8sPY+a3oMzVgm5aHBve081ztMzrfP2HNX3C6
 wcaxD87g
 +hG7T6wTX3i1IoUDbRTU3qSXYCyoOW3dgyO4Up6RqOemkEPIP7NGezP8vkoHpxKhj0GDGVJyBma5Lwrlv7oyHfOi4Bv2O492OV9aXuaxGFXl00wW5ChqdaaFtfFqRWl+9BX2pt3GDDXlDr+14UDevqYsyr5g98EtbvtlANmtcUc2yhoCrpwIubb7VxrjZpYavwrKiWntT3YEykiesTgvvD3/nUb33gvCQdbZehE7w0+EO0jsfVlRIGWnjQeDYIBfZSIO5ZnB4o/KuMHrCOV/EEsSJCbdeC1aTpXHoZs+wZg9ObxCBjoUgNMFcz4PulyHxO2M2Gsh5zkwy+ZqJHzQ1UZ75Pf3n5f7EY7OnHFN7mKZuH7b5gc5/ZP2by+8YcSN67xZVEEo7/qJ0EL2Mk0PY0og+0+q1oEgekqwGlu2nYPVK0XY4zrTvA9lafunxNIgj+JFp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Red Hat)" <david@kernel.org> writes:

>> Coming back to the fixes tag. I did mention a bit of a history [2] of
>> whatever I could find while reviewing this patch. I am not sure whether
>> you have looked into the links shared in that email or not. Here [2]:
>> 
>> [2]: https://lore.kernel.org/linuxppc-dev/875xa3ksz9.ritesh.list@gmail.com/
>> 
>> Where I am coming from is.. The current patch is acutally a partial
>> revert of the patch mentioned in the fixes tag. That means if this patch
>> gets applied to the older stable kernels, it would end up bringing the
>> same problem back, which the "Fixes" tagged patch is fixing in the 1st
>> place, isnt' it? See this discussion [3]...
>> 
>> [3]: https://lore.kernel.org/all/b1f04f9f-fa46-c2a0-7693-4a0679d2a1ee@oracle.com/T/#m0eee87b458d93559426b8b0e78dc6ebcd26ad3ae
>> 
>> ... So, IMO - the right fixes tag, if we have to add, it should be the
>> patch which moved the hpage_shift initialization to happen early i.e. in
>> mmu_early_init_devtree. That would be this patch [4]:
>> 
>> [4]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2354ad252b66695be02f4acd18e37bf6264f0464
>> 
>> Now, it's not really that the patch [4] had any issue as such. But it
>> seems like, that the current fix can only be applied after patch [4] is
>> taken.
>> 
>> Do we agree?
> I think we should document all that in the cover letter, an describe 
> that this partial revert is only possible after [4],

Yes, I agree. Let's add the above details in the commit msg.

> and that that must 
> be considered when attempting any kind of stable backports.

Sure. I would prefer if we change the Fixes tag to the one which I
pointed in above [4] (with explaination in the commit msg). However I am
still ok if we would like to retain the existing fixes tag and show [4]
as a dependency.


-ritesh

