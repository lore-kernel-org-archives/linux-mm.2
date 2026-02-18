Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A82DEE9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 15:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766EE6B0088; Wed, 18 Feb 2026 10:52:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714446B0089; Wed, 18 Feb 2026 10:52:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616516B008A; Wed, 18 Feb 2026 10:52:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6136B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:52:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC4211B1BE5
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 15:52:35 +0000 (UTC)
X-FDA: 84458019870.13.4F09BDF
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 053C918000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 15:52:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lPpHrObC;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771429954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/8JkWJqRGjG1Au+HIiW6y70F8UXIF6b3iEb+LfAizM=;
	b=hRx8DZIAKsVI0Y8MhUGGQZnLg5jaB0PFcbzKzOoM+eS8yFuV+f4utuu6MIw7qsrYU4C5/Y
	zExAdLWh6KKgUerCwq7tp6BEje9WAwKboGI+zsmMRdwsWeHDiJ0hg3aFUcn1Bh/TJceoXv
	jGF08Y0CvkkI1Tybtuvs8JgxA0yBXd4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lPpHrObC;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771429954; a=rsa-sha256;
	cv=pass;
	b=2XpI5YMR6PAmH7eQvbtPsJGdjYLDjma290cdc5+0CTWQyqhCH0P+wJmFbvUOpu7ToHawhi
	g07XIHxtZMWbBL6VnGXLBL2LBji8xVmDWEKWDh1wozBeLWuh/hgL3JEKKvJ9PjDxFMUtoN
	bbZYyQjPLhxzYoGfY1dV1NfewO1/Qdo=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-506a355aedfso579071cf.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:52:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771429953; cv=none;
        d=google.com; s=arc-20240605;
        b=XxrnEjT55rsDaOTrLcnwObRg6SJv0irIerRwJlmYujtZm1IavlLMNZmW4jk5nGQWYl
         d1jQQW/wmdbjZnjtjNVDnQfdClKnZ9Lx52xiRRSmJ/R8Qd2poP90ioy4LVzJof/EAdUL
         pQVtvr7bppfvrVv3HmzzWSzZdz+PQFy3PG3MWxz3M2pMkIlcB4dV5DM9NNyHxLhtpG8l
         hFxvrKw83fnH8PKGRHYm2bhp0b17d4OztTNfOUZBw2QfD4hhG/104HUsM54/dTrBzoVq
         SJQCONt0kcvEXDaudDCeHmfC6bmPM7N/EzD6PdlKCAcvSaIaC03+HlboFeV1P3Pwg3E3
         xrgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K/8JkWJqRGjG1Au+HIiW6y70F8UXIF6b3iEb+LfAizM=;
        fh=YHeJE+WkDXsLLs2JJfAZwy4qIUjFkzEUsFALnfms84M=;
        b=hHlIUATGVgz+QcsbIC2vMhnCvGomb9GYrZWD0734JPIRcZAQGQnn43FydYBi5viPoc
         GeqMdn42osCyaj8YYBZPHqU33c4ITUB6pLnqfv+Qvcjg3ZQMaFMxamIO2xcR+j/KpMon
         IEh91fudG95EPrvyDFPCGnZFMHcSTdBMTl04iejn9NPHeMhkmb3I5DhGD+3e7OHAJExw
         3AXNFVl0fDcljweV+w2ds2hTYmHhmW1w6L2RR2ikwY43zQ+kgHZlGaNjS2ZfI0tv7qC+
         mmIRzG6DnIJQcjbQfO6KMOpLqMhTBmSGAWewRZjywliFMgJHvRTX2gk/KyGlp6eKQik+
         QOYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771429953; x=1772034753; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/8JkWJqRGjG1Au+HIiW6y70F8UXIF6b3iEb+LfAizM=;
        b=lPpHrObCMX95OUG1RD6uI2XP7xj0x3c/VyP5PwMhk1NfLUFckoHHGRBPbRF3scIpDw
         qCfGs1eS5MrImd0Ksq7PmakrrcT+/qibaAP7z85qZgpzlHdvTdTFnH2LYJWJg3vIcLzc
         GhcbztGV4OFwODPB/sHNCfRNRlpTPMiXe5osxZyxKkk+v9CuHaONBN8g5/Cq2KD56oG1
         tJeRaQZ0i9MSzjIXCMxPUDVOk36HIJbm/erO2WQu4ExRJeampoV/hYEZgLTC4iKXqYwV
         E33nBCHaKgO/+0JMN9wzyc8n3Lz1Rlq/CdOGnhpXPniOU7/DtCFYMqB8HnpAgunYOk/o
         5zqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771429953; x=1772034753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K/8JkWJqRGjG1Au+HIiW6y70F8UXIF6b3iEb+LfAizM=;
        b=vVUj4ZdVR40hTgLULJTunuLDE9qqAo2DEnpaR/gy4pXFq04ojeeA3/eu8yojSeu2RO
         P7HxS7NFFe9sbySicbmZIG1o9LYrDF+sMnNRReflqKz5PHGoy35MmKsM69dxkrDDYaDR
         xs8gCcB6sotyVe5I8A0OJ4T2FypFshGFvYfDFA/32FT7GeLia8hXJMYqd4YeBHbal1K3
         KTfpoZeokKo8EwnjYDKaeAI8h2qOKLRQXdNZMmvxhacsNhf5Y4wxxPxEyHpyG/VEQe88
         mi5GHbu2KqTqbFZoVZO4YcpbVLR5kaxFo4hwShu7rGnmWQyEzA68SGP8NHHhRhqW1HFZ
         lK6A==
X-Forwarded-Encrypted: i=1; AJvYcCW8awti1s4U3wStuEKT8xX0svMEzRjKpyuKHEaY/Lc2so3AEbEzAVMAEmsE1cY62yOE3GomdcFwvw==@kvack.org
X-Gm-Message-State: AOJu0Yw9Lm5RowEb7FZcUsBbwD6rMpr/5ZeoGUTBi7JzLfhjs/b1UmWh
	luim9AKhCMh0P/R03VEY+lLG6JiOyxpU1AYxH0FejpbJHCFx+P3g89/mLEAbuRzFxCLCY/3PBYf
	la/qZcl5kSRyi9QYrAdPykVM8vRcYmbWP38Z1Dn81
X-Gm-Gg: AZuq6aJWfu0WniBD2T66uiXhgXAR/Om9VK1iEjo0qKP5KkSMTfRercQJFA8bvYQRTSd
	B76TMpRaODu9DEqcDMXtdQeVfMBGyrxTHCL50NyR0hinq0eCSmWhMM0jxS7ocs1SCZ239Sfenih
	6wgH/4Qde2ljbBLzQz0mnV5tAdU5u+UEb0S62xAUdI2J3TDsysIvK/n0yzI1MR8ilipgoArCFWl
	lDWSdLi0reP27jqYTl3HtqaEK6LJoUzrTUO+saBv5wXN5YtWqXeXx8IfrRSp0RFuH2FZMDMky2Y
	ZPGEIVgS07hZSHOpdgerfQvJIHTSq7pGLCY=
X-Received: by 2002:ac8:5848:0:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-506eac6b96dmr6584461cf.8.1771429952470; Wed, 18 Feb 2026
 07:52:32 -0800 (PST)
MIME-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com> <20260217163250.2326001-4-surenb@google.com>
 <20260217191530.13857Aae-hca@linux.ibm.com> <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
 <aZW5i4cqU1qUy3aa@casper.infradead.org>
In-Reply-To: <aZW5i4cqU1qUy3aa@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 18 Feb 2026 15:52:20 +0000
X-Gm-Features: AaiRm53m6s_G40CJP3vmJv4jXAYSm18GE46B6GFp27WgSQ5QeI3l-eaZ79M4lt4
Message-ID: <CAJuCfpH6c9q=W9ynrjV+UEpsoBpdoAw7ADchW2Wvnx+WYkaN6Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: Matthew Wilcox <willy@infradead.org>
Cc: Heiko Carstens <hca@linux.ibm.com>, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o74ozyyyb6yu7wrhethj4fmxgbjomhy3
X-Rspam-User: 
X-Rspamd-Queue-Id: 053C918000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1771429953-929221
X-HE-Meta: U2FsdGVkX1/aKsvw/k7YbRRTv68oKDOT250/WePhgYA+Ce/2rI0zaQwVsHS/jHUsObL1yQYUYxlWCnLqFbg7gI1vDWAocDNpKdjk6UmZ+cm4wIdAW3r0MH/x4k4Gs1aAttImtw13I0P+T66D7AqprutKh+6qiYjOUWdpyl6Uja0eDBcFTjIe6Z6kesoWffKMjq8wKIi11Y7dFyDUtmPedR3RXoU5wCIi9ZLAHkhldbmZ98Z40nbq8LhCs6VZB8ZiwN+04jHje3+t9k5uSBLzdQNYpCRY8v9e//wVcff6s41rt5r181uXPIwetep6npHcqVB3VPJPPZc1Pz1mudoGIQ5g4twKTCqzJAoP8YsdKdFR+5TS5p+K26bZm+JkLs45k0N0N5tZXEValYZw6ncq3iaSGbmY3rEonLkTRCItTn5/WWGiglJ9+JTx3c0X+HCbOTEihKrpaGUCN+tviREP/4vBsERs9NBkh5iDukMj/OZU15j5Cww6ZnLn8yrGTKaIH91NBslfdyew+dNA/tv0u4Wrw/6SkhDoe/EGfRiEYcX8gC6K+CCUXgrCXej2H30rpag3Ch659t3LKbNLhqr4R6rHS4Qb4XjsfOQ3Vj7rvl2oaVK7fVBw9MUmGwWeJf8zKI/miuhzPCEsAkWNPaFx/M1Vg9HFRnWxVlHfK7utmKdIQaXHCZyBrugyFpMR1RX+Y+zhknM1k1QjNGTwAgMO7C1+QdQGYQEcvrNNLb2hwGiEvtYCny1zAhXrQA60koAodkP0rgsaXFPJsIxsTIrUEH01IFkYEk+bGTTtbcLPVpRgy7HoMI6O6tMBz0+6TgKKrVk+rWvE9u2JZ0SDRbzGkxWahMD0fzSgOWBQ0sI/q1osbXS1FzOLNSHBJ2uFQJ/OTSz5G7wPhAyoc+yRI0ggd2u3gt6/8xMjgwTnvU9OP4VHacOrp1oWMq6jVxvPvjrUWM7jl6WPoABXVY2fBlm
 oeI6/KQg
 olVXl4zoWUlh39VoGCOZQma9qqZKtWVVQZ0+kRsctrLrpr8+EHp9D0cZ86IFwFvcacSTbExajwKFw/Q4PV7p5eUOcbWih4geSYT+IDKxEun96amh54TDKBlTdEF2KJ7s+ZprdWhrg93E4Mu9EGMD0qainp7F0woNZxBE/apmhvVevv35Tx99DMceWRf3C3tpYXothPjEWl9exPgVeDfhuWy8Q8nHxA4f2NFYYhAKq9DxPl16tDQT+UC/i1O4V1DwjnmRfkazl0bIDXeRwxQh9x9ndMJ28WY6HEdI12QAx5sKBjsb5lCRDRfzs0/C19ojdFvQQ+cdMcwSl3hEvHne2W0CUQ7PhXwHgWT1ob5ir65tbKvhvB2VT2v1ko+EtP5nPeMzM6sbaZT7lqU8fUpUyoxi0CNnfeSoGC5Nz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 1:07=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Feb 17, 2026 at 12:31:32PM -0800, Suren Baghdasaryan wrote:
> > Hmm. My patchset is based on mm-new. I guess the code was modified in
> > some other tree. Could you please provide a link to that patchset so I
> > can track it? I'll probably remove this patch from my set until that
> > one is merged.
>
> mm-new is a bad place to be playing; better to base off mm-unstable.

Ah, I see. I'll redo my patchset on top of that then. Thanks for the tip!

