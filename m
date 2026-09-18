Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4959BC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 23:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63626B0088; Fri, 18 Sep 2026 19:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DECA36B008A; Fri, 18 Sep 2026 19:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5136B008C; Fri, 18 Sep 2026 19:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95DE06B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 19:48:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E308680150
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:48:15 +0000 (UTC)
X-FDA: 85228524150.06.3CA830E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2106B1A0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:48:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eODMcJmZ;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789775294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nz2zbIFKT6HwXKpev+qm4lwffznJtUuxnKuoUkXJ/68=;
	b=Uqy6Rk7REomzX7a3jtXMZNGyGno/9afx25Ggml4Ds8HXUMpxfFFi6/mo/mh3vgL5tF+xbV
	+3jBxx1Ig8a3kCdOscvnTGcttXQSEFkYlqK+dATSEndCq+UrBD6RM9UBJqkRw4N4+c4e5b
	vEMJQtC6NLAFZCEksdD/6u9MCcAkTi4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eODMcJmZ;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789775294;
	b=mVVtCEZ7wuduiuRiNOtMjOuuIyPQSKMSwrxdiOhZdFuN3dZIiT73OEi7lJi1qILpAdjGdz
	xmI1cn4mGJk7Ug8j0aGr63302BWV1CSFc8W6mLoQuL6oB7Y0Ok6UbAJdT7ZFdBXILJpE1H
	uv48E3oU+QEf7WpnEPnRaPmbDG7CjPg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E71DF6053B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6901F0089A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789775292;
	bh=Nz2zbIFKT6HwXKpev+qm4lwffznJtUuxnKuoUkXJ/68=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eODMcJmZcdrvuA5gqsshc+HMteEj1vEDENmckwu2MMV1F2YrR5ibGNtUZ6dx/TVvA
	 qJgk/SxBehn91SZDLpVX5d2A3fOc4WqwY6DG0oOwbLzOD2tjyzVvH/XCx299e8Vsyb
	 8YC+BJliec//cnvKqcZGzFfayspgd45GtEH40TZgjKSAM7W3UUHJRndQQdkiZEgxkV
	 17GtmyIx7k7uSSrGkWF48LBkDG3czB7AKcX9oTZBSBdvV+KqIKeKEmuFbzOjOTr/pv
	 Rjtshr/EA22RpdyRVwdRUpdoPtnxPBQGlJ8i7qr6JtCfA6Y16hOvSCorddF+bZxQk6
	 nyjdMyPOk18HA==
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93a2a8c29c4so139261185a.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:48:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwIk25XkjBhyHc4Bq4z047ck9BNTi32mR8872ZI2wzhMFecpI83SG6qqQd/J5wuotERiiCcYCZmuA==@kvack.org
X-Gm-Message-State: AFuF++kayQS1IBOg6iatEEcniLrZpUYSARkfYfX/rpKGgur8oclSUc78
	rNu1OkIdh5FDyvPMNsmHy4Kd4L4fw7qbeGx8s8L4KU80Y9m2vTf2qKuN1B49ddYeymlF0S1Cgkz
	RzsG1iuhxCjWqrVUjVLruAHXeBKlScoo=
X-Received: by 2002:a05:620a:1726:b0:939:8ecf:6025 with SMTP id
 af79cd13be357-93bdc6c8013mr657417785a.20.1789775292023; Fri, 18 Sep 2026
 16:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <b1ba175c-ceb2-4e00-b233-d51dd8a2f4cb@kernel.org> <20260918182857.571-1-aa9736195201@gmail.com>
In-Reply-To: <20260918182857.571-1-aa9736195201@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 19 Sep 2026 07:48:00 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wTYLds56=iyra5FKmgnNACN9QKJH-XJ=q62G7fMvd9iA@mail.gmail.com>
X-Gm-Features: AcwNN1VT6LIguAvtBHIDarKZ10TRnBtsk1i4q3rbcjFBRG5cMHV51umUJdB4BeE
Message-ID: <CAGsJ_4wTYLds56=iyra5FKmgnNACN9QKJH-XJ=q62G7fMvd9iA@mail.gmail.com>
Subject: Re: [PATCH] mm/memory: reuse the whole exclusive large folio on a
 write fault
To: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, liam@infradead.org, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2106B1A0004
X-Stat-Signature: riqt7ym3jjti4789ikispsbks6wyrxhz
X-Rspam-User: 
X-HE-Tag: 1789775294-650557
X-HE-Meta: U2FsdGVkX1/Be/Ur/87Ub3gDLyRlWT8A6a86ByxBpus5+6w6XlkJsYeshLEba+/xuGnIZszH5n1qi5R6H7ifnhsx6lpSv8DIR93L/mDBMx9YWgzwQSjevkSSxmD1QHX5ZXM/mQIwD/Fji/nnY/W0fQVzaCoEls9VR0oArWEsCmecRjZNKwRC25cAbtMWjwdIIW8qS/nd2PMH2LC7Mhy43WENxDdlGiTZ06ILPil3XlE3IOnxLrGizwuXjOew77nh629IydqZLWteRORdwDn/Rs+0R3Kp4PR4q9aWKv4EW4w7yBjMw+3z1C45gg+FW29cEUi4lRJsbHqrqflO4zhR+4j2yyqMbIyv6zyTS6/Xgz1wUPpJiQXl3yVmQKlLL72yX+ayRrh06ynNlOYMBFPHs+UWSCh/Yw6DppI/ny7mjyhsK1pcq17HDLKFNKhQJaxN51qBvIUfQAJvIbYo4uU+RX7NocBgMwheF+FTrPGGYIgGGuBJHfZxE09oRvSRCEIrxSPDxJmMuQujowsYLyi40N/t6iS8eQjLUC2Ophyb4f6lG2hVLbuiSzxdDiBNo6Uom00jABZl1XuICP3g/jAEpUHCmh9v/ax3BokcU1UpJwxW+2yPwDP/OX69tYS/ICtPfhSulZA7CcTjjaPzBvOoy03dXjOE3LwTndqWzu/k4hSFynLAMn/nyzzMi2E+aAKAk48ug5WC8gtnJXlOUXmuGTQwfcTVR5zhaDN1shYONSEaLjG426XPRa37qLXnLhuDotewHiAZAYExwUN9UD89KXhU9hP9FixT7uHXd3UDNhxFkZ8HdiaqMtOpPC1oKUBMoTKkDrvHdE4Nvdwqf4bH2lFdlIutujXWn+xNq+BwQx4cY5cAXY4/v+6Ykn7rAYzyd0OfzG7VCsPvpmDMeTkuE6CeFYZV8nrBL9w5VFDHyCwVc5sYMSkgy0ayQqPnjzWHsE0n08cA/1u+XG4FMCt
 zGnfWYHp
 dnlpafUiKhwDgEMxDb3rJA7AR3yqdayiqNwm/7VJDteatuTtzQkSBFW85GzEj5vM49427WUlyAD13gJeSUDm9KjgUA54Z4m6N6xmPu+D7cDqNov4EJqyWrxwihgX4IyJy8+lDbzRVQo3N/hkJRdmI2OqQcRjq6SdZVSRaT6BYLFW7jyvjpKKEtAQpOYXlV59X3LvhFj95tQi0rqc2YavhKlgkvVdqjhJ8+tN4Fv4wsjnJ2nRzHu6nnyPN3aQ8zPbXqy8VRhLh1xwI95F9eugmuEGPE05Mctp7aG7MzjUnJOCP/VMl+2S+VvY6nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 2:29=E2=80=AFAM Yuan-Hao Hsu <aa9736195201@gmail.co=
m> wrote:
>
> On Fri, 18 Sep 2026 14:14:11 +0200, David Hildenbrand (Arm) wrote:
>
> > There were previous discussions on this, in particular around how much
> > we should actually try operating around the target PTE.
>
> Yes, Barry's RFC from 2024 and your replies to it, where you were fine
> with contpte granularity and not convinced about anything bigger. That
> is why the description has the numbers for both: capped to 16 PTEs, the
> 1M and 2M cases take 5.4 ms instead of 3.9 ms, and the only pattern where

Hi Yuan-Hao,

I'm fine with your follow-up work, but I'd appreciate it if you could
mention the previous work and include the link in your changelog, along
with an explanation of how you address David's concerns.

> the cap wins is one store per 2M. If you would rather start with the
> contpte-sized version, that is a two-line change and I can send that
> version instead.

I think a major concern is that we may spend too much time scanning
PTEs to determine whether we can batch them. If we don't support
CONT-PTE, we may simply scan fewer PTEs; if we do support CONT-PTE, we
may end up scanning more PTEs. So we need to show that the scanning
cost is controlled and explain how it is bounded.

>
> > How did you use the LLM for coming up with this patch + description?
>
> I did the initial investigation and made the design decisions myself.
> Once I had a clear idea of the approach and the overall structure, I used
> an LLM to help with parts of the implementation and the test
> programs. I also used it to help with drafting the commit message.
>
> Before sending the patch, I went through it line by line and checked the
> test results and measurements to make sure they matched what the code was
> actually doing and that there were no obvious issues.

I also personally feel that both the changelog and the code are too
long to read. Could we somehow split the changes into smaller pieces
and describe how each of those concerns is addressed at a finer
granularity?

>
> Lorenzo, for your bot's question: the reuse decision in
> wp_can_reuse_anon_folio() is per folio. The patch applies it to the other
> PTEs of the folio within the same VMA and page table using the mprotect
> helpers (can_change_pte_writable() and modify_prot_*_ptes()), so
> soft-dirty, uffd-wp and NUMA hinting PTEs are handled the way mprotect()
> handles them, and the PTE that faulted is finished by wp_page_reuse() as
> before.
>
> The part I spent most of the time on was the measurements, including the
> cases where it does not help.
>

Best Regards
Barry

