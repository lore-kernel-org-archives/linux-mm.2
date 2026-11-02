Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9549A6070DBD
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UzlqkCbA
Received: by kanga.kvack.org (Postfix)
	id B66416B05C3; Mon,  2 Nov 2026 11:09:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F816B05C5; Mon,  2 Nov 2026 11:09:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26016B05C6; Mon,  2 Nov 2026 11:09:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2BF6B05C3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:09:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 197E81A01B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:09:20 +0000 (UTC)
X-FDA: 85390663680.29.CAF279E
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 385DF18000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:09:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UzlqkCbA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793635758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OegtZIBdrxCNPYwuOWjLYx5fVAeu/sW3/BrFkWBbk4=;
	b=UVQ30dhM9y5s1F+qHXBd+oq5+YsUsip0MrMfm7UkItltK9odnMnVjhvZoWmcz2FgCv912u
	+xqXKLAvswYvUctAQnTLTFvTCS6XcS52nK1QnBepRdsm2ovPjygOm+LVbgT6oy9kC3nG/y
	A4fA+mS1KN9B4K/rFjeJNm4yIrd4I5k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UzlqkCbA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793635758;
	b=LLOfxuLzAgVQ8KO2TKvuIUcSdIz7b5jJ7zuMi6//qlkIVR0F7zQBf0Z/PLI7IXXztz9SuE
	P/RJpcnJ+0gieoJwTC9YqpVnZPf0DAAVt1X8OgEDf+vbr0RpfY/Nza3CXS0MAdlDs6tsPi
	wOvZJbJgHMIBNa1S6RS7rXMNCJNa1LM=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48b001cd92bso1735933f8f.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 08:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793635757; x=1794240557; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8OegtZIBdrxCNPYwuOWjLYx5fVAeu/sW3/BrFkWBbk4=;
        b=UzlqkCbA1GpQEs9taCg89sxAS+3xvvpkgfCzC3vj4GEt04UW2bWDB5iny4/yFXgQJr
         RQNEkTWd/AKpsZsNvxRH25jPN1KMPydl5Ez9nIkw40w93ALTHuM/rSJxCxAg4MXlk9fa
         JPDv9U7zxTEdgRlfkJ5Gi9wVs5uES9SQcW7uqP1F8oOXVe+l6IYgdCNBnk0rBwf8i6Co
         qphjyTK2EYicCY9scDGjlCVNZcDq2d6/wylhaAPUDtsWWzdp8tLpZs9U8gywPjCYkWtY
         OU1ylvLR6N3GjZ4uR+BqyL+ja5mJoqH1M4ZkSu0LpMPy7uUpeAJxKEZpFEeZUalMVtAV
         Q7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793635757; x=1794240557;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8OegtZIBdrxCNPYwuOWjLYx5fVAeu/sW3/BrFkWBbk4=;
        b=KYy+ZQlbaZxx/U5VMeDptsizOS0iUtlfwuyvkolV/ujBpFyqDjGYKz/Pu7FEHvzZm6
         MWd49KGTZI77i2g0L3mUkKo8gywutk8UqP1qwAGc9362oPuJLFhvhibRe0bBbUAursao
         bNVhdNH5wCPWRqZSMCRDAhjnXSe3D9KaoUHbJi+Mlvq4M5nDO0xY8sRACK0sYmJrqp0J
         SHPJXAAU2K5OmPP6pGtMRe3kKmYJmogfybBO8a40uxXKNlXDkz+2LLShaljEd0BH5mRG
         A1a66je+xgORFzbSOgnfMSiRlOFjCoGQq1JjJzRx9ELIUon6FUIIWdV4kOLUoRf/6ML8
         4ynQ==
X-Forwarded-Encrypted: i=1; AKwUvBwN2aLxUdmMRtjgRIGxFbzNQA26khJIPppMr+1+1hOED7NJeFFBshzFNloS8tMaQ2Mds8z52n5Mzg==@kvack.org
X-Gm-Message-State: APuU4Z+oIkGSJ8nFFHbMhKtES8F8QcceGO6x8gJ7FPJcOOiwWnwjEl32
	UjjH3E6op/bTalstcSySTiWdbBu4K1au1F1OWpWMkvsTgYKNPD/NhulL
X-Gm-Gg: AYBFou0qAI3K3TSJYdkxxBjFxoS51E4q4TjaA0k2zTx9pDxcV/sMuJYshJNUj50aZfS
	zjUOm6r8mwi5lfQohigqTzerzwct7427rysSw/4menhQkGqZ8ZHPHTNpkkKmrW7tsx62AdPl7QT
	2DO7V86sbBKkQMZyqZ7Q9EdiE714/23kQcI862co++j0K86MbRNr9yfey4dl4ivhpr8ZM6SkzMf
	2RU24LLiWkmujC9ddFxfis+dHI9d492n5vR4/sNMXfoLUPcWt8fp44i7V3j+UI9B7qaO5voZ6c1
	sGSvBtZefcBIIfPR8Igyk8D02m8OLmY7HARIecm/+Nill3ODRN0TQr4NbqkxixhUuSOLVmrJ35I
	7xt3VLOSLaXx9hs1gAOjMaP9J1p67SMWteXhIYEeQ5O83htWcjOTG1+fjw4n0akWeK2YFjXLKfO
	s5Qyh1vtzgmoCKm7ytFgCAuRh+70cn6tGRHL1k0j6+uL/ebw2s72KZWpvTSdBE5MPsopCLAsxTd
	EQqrXoIojGZgzTgfZE44VVtxIgtVLTjYuDVcRKBus2W/WXDl76ati2NsdN9i1Cbu4O9Luz14yPa
	DrPnSfihYddV3vo52gsjAV4=
X-Received: by 2002:a05:6000:2288:b0:48a:f404:6960 with SMTP id ffacd0b85a97d-48e6e2e76a5mr23213517f8f.9.1793635756592;
        Mon, 02 Nov 2026 08:09:16 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba2415sm21300844f8f.50.2026.11.02.08.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 08:09:15 -0800 (PST)
Message-ID: <936b8e7c-37e4-42fc-8ec7-67280aa93333@gmail.com>
Date: Mon, 2 Nov 2026 17:09:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: Define the zapped-entry checks only with
 CONFIG_DEBUG_VM
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Peter Xu <peterx@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>,
 Rohan McLure <rmclure@linux.ibm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261102144001.342837-1-kas@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261102144001.342837-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 385DF18000F
X-Stat-Signature: ctwyeapyzu636cnpddoiwkbnh96ddo4m
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793635758-505363
X-HE-Meta: U2FsdGVkX19/0aCVUM/L7U1KAMyIIr6N28hNQ7j7leheRbyYp6yrChMPkAtPSEFoxTVOprZhKaIwJ39X70DtgimnnRMRz553pQso88a5oVi4fd2NNY9PhcTK9VDQmBka2W4ERWdRfeWF/XyZbK7Axrml7hY5amgsdKiK8e4fyE004z+toLd/M331VnzPH52Lxqu0lp2Fu1R9wVwWsznrbCr+6yuGIB5RwL1PS/FK9Q0ZU+2HBQzN9Omd9t5wlWHAAeZPes1mcW/JtfdoR7N6jtHk8LDsIt3SQibBknmAY60n7zkDmDcFattBj6iLbQU5bFhK3Xic3ed1u8rTq8whCpKuZ4MUU8BuBgpFRCxytqDYugkmIZU/NXWp35fene8n975EnPwW6AcrqS83459q0wQP8lhzg3Kcmu17jlfxA8IzGcQkPTetn2CRXGoflTaXqpMG7Tug2qeoH59877YoiK/zrQVVPZLM77uUCgzkZL1Vr5kmkoiaAg0mIcO9FYaoVOrQqWfM0u79i7EORORD5IAAsug1lzno+0Y3AbxO6Emz8nLKgQEJbpYzyXFUNCZd7HM6fmWdkpStMMyuEWfxObajv9i8ZpE39UZcbQzHFAHuZluOdQjDrlOHG+dSyPU8Tr2tic1MRZ0seYm4Fw4EYMLWg2GILkQJvrEcpOtVEErdkU5LM09NOOASU8KH+I9bLYX1rzjasZoH7I3WbAZkC9dZ9G9mfKIy+l02/4V+ffmlftg0OWUqw+9kfMKH1m0LB7Ph4+7b/FNywCPGPleGsYt0uT4TGo2EkWc8z4I2Av7r9O7FjG5dIGJ/sk4GihyrWgiW/b71O1a89cV1m4fTgFUbbXcdjrsigJcHv9YQb5o+hWx0vS6uPIKxCLpxwejuFPDalV8jXwU3OM0QbY6aQpe+ieNpTqervOHDEl3QMD92rR2r0Ud084zXhdq/MlZLzizgRzoVzJ6rOG5gcxR
 9JOUAm1b
 n7XXJ6op97ULe0HAdRPguUDFT2KlRbmIttN892W4skY9ADK87fVGBwjMv4H/TevMVq22iqmWlhs+n1DE8lIyJXzuZL3FXLFQ8a8ADlq56o39QeOcvpJW7a5Nm0VYrxwNyGavXBdHtjtcTrzXNJTReYfwraCHBsCnHhimgGN7GzlscrTJwoQq/EAtyMNFMkLsrpNUA4AS9uiK4xRL9MFWbpsBi3Xgp1xa4VNuY2hzuJ83lzz+W1Gk5EZ0OUackUzyC0UmURqTu6PwSIX/iZrdWpKZxyow8sqcHVBjXVQZgPqZvSxdDLB63PQaPCWiW4XkAtuAXPwZrjtYSOGkVZKlF7hLXMZTwRjV1FLBaw6hqh8zS5mvHXTtS7poXqvtVDR/kui0t5Q5pXieJOfgYPOecFRx1YPWeuYKQfLm0EvGYOWX9lt304voWvRq5yXGVQl+QjKP7+/vY9jTUPPnfb6F2WHBJkcNaLCjTuc5Rr4qQqRU5yxczibQjknVkPhqb2r81iLy3IvON++ploCe2FyFEYqYFJYozr9ZEhtLVVyBj1Z3KfRGgD2jqkJC7vZfBfGTe2RtShdSYfBOeTLvLnVa4UyOfiJs4u/Jd5fo+D8ZoKUCRtjDPqvS5CvWgpPjYdaeddPkUWuJswVXlIYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 3:39 PM, Kiryl Shutsemau (Meta) wrote:
> Zapping a range calls arch_check_zapped_pte() for every batch of PTEs,
> which is every page for small folios, and arch_check_zapped_pmd() or
> arch_check_zapped_pud() for every huge leaf. On x86 these are out-of-line
> functions whose only content is a VM_WARN_ON_ONCE(), so without
> CONFIG_DEBUG_VM they are empty, but the call remains. With the SRSO "Safe
> RET" mitigation the return of every such call mispredicts.
> 
> Declare and define the checks only with CONFIG_DEBUG_VM. Otherwise the
> empty inlines from <linux/pgtable.h> apply, as on every other
> architecture. They cannot be inlines in <asm/pgtable.h>: VM_SHADOW_STACK
> is defined in <linux/mm.h> after it includes <linux/pgtable.h>.
> 
> In a KVM guest on Zen 4 with Safe RET, zapping 4K pages takes one branch
> miss per page fewer. MADV_DONTNEED of 1 GiB gets 6% faster on anonymous
> memory and 8% on shmem, munmap() 5%. THP is unchanged.
> 
> Fixes: e5136e876581 ("mm: Warn on shadow stack memory in wrong vma")
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

