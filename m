Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA11B606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TE8Aznko
Received: by kanga.kvack.org (Postfix)
	id E6E9A6B0962; Wed, 25 Nov 2026 04:39:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F5E6B0964; Wed, 25 Nov 2026 04:39:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99B86B0965; Wed, 25 Nov 2026 04:39:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A46696B0962
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:39:33 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38AA4160D76
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:39:33 +0000 (UTC)
X-FDA: 85473143826.26.250158B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8D57540011
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:39:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TE8Aznko;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795599571;
	b=DJh+U+T5EWAexbFpmCzRAuDgxRJwWxvzROOz0pvSpgh0Y9vm8bLMvGywvWwsI1P7aYxmL/
	a8KJFGfPoTl/e/bpOUA7UeqsigSo+CLV64Oa2aiEgZSR7mLftg8G68NcHxv0dkZk8b4lo7
	WbXqUhA7+jfAUslSutD0ZUIv2MQf0oQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795599571;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bp3LdbYywjDt4RIw1F5hpk6VusK+9ru0rpOgIQ7EDh0=;
	b=rRzVGh6rq3unRDd8tiaar7fcZWr9MRvA/Gv7/1Yeag5rU+re2RZBPBOxzZP2JUH51iNkvp
	FIIEURCs3ROETfiKngFkAKStxniddLiqD+Ij9EmLytNI4CZCwa0mwSdbh2Cl3IiVscHq5K
	uGfVZ+Q5tlXSkal7DfAlI9uqqyO2qWg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TE8Aznko;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A59A624DF;
	Wed, 25 Nov 2026 09:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD80C1F000C6;
	Wed, 25 Nov 2026 09:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795599570;
	bh=bp3LdbYywjDt4RIw1F5hpk6VusK+9ru0rpOgIQ7EDh0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TE8Aznkofnon7JjG8UuHYeQ5xQmQK4AzGQPEZ6r5gSMaB0h0OG0Wu5so8iK4yi3SL
	 OUzJBnLC6pNJKO3qo9YgJRcdxrsoZ+CBU7IqrzS50Y+rNn8+HrjfW4D5m7OC1qwCnP
	 iu6J6r4OCidFxwoANq0k18X5qTgJJJJ7JJ2zq7F1ArYra+MSvUYy5NxDmB/75tmuR+
	 nQ1hGsbGdSSKfprz1Yme25HuaWfmAiQ2l3j/LjoqqNdK43zDDbDK6OMvp9p79vjHgJ
	 AKfzgOWq9T3drbFomAVBwf1hd7M+5aJjj2sM82bhhB8b9P0wNFjEDTECjdLqDTtSUO
	 nDoYdkNMRwGaQ==
Message-ID: <sashiko-outbox-233019@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/rmap: avoid reusing batched TLB flush generations
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Rik
 van Riel" <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>, "Jann Horn" <jannh@google.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Paul Walmsley" <pjw@kernel.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Ying Huang" <huang.ying.caritas@gmail.com>
Cc: linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, "Kirk Swidowski" <swidowski@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20261124-rmap-v1-1-e3dc48a4b527@kernel.org>
References: <20261124-rmap-v1-1-e3dc48a4b527@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 09:39:29 +0000
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 8D57540011
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ncubd3ix4ppssaimn1efr7p3fod6zj67
X-HE-Tag: 1795599571-810283
X-HE-Meta: U2FsdGVkX1+E17YxPeXsfjN6ePrZVu9wLIQ6HqpjFz6XP/R0++49rfzT64UEwlQecBr4Qo5X1djh6cyXZSp9Dkxi594uq7o4XaTRlmGummp2XI8BKXaZK+CaY+bco59kHQoR88i+tW3+Lpc19k0ZwR6oLMtKBmbh2JMoaAGr6+IHt7NcC/4lD/M5v4eWu0hROnzIVlN8OD/rTj8THlQ3Hnn6UjiMtyuk5z1Z3SVvBEB+nnXZl6ysuxnOkDh1iOITvHrtRc4jg2EmnouWxJ/ralgXlPNgjf1OHksEFi2JvveBNsBvA9ULnUwKesMcNavDo9hgIB3z4ktEEO+shraPyWbEQvzXjv4DGyT8qCURDKoP/PIBDA3U7Z3Xpe+euFpBj8hO4Jim42LX3yGh4VsEerX1PQ1cAYlEugrYF8SOXgFs5EnVrd7Zgql8DaV3YMEYM1QglBH7EzIpgM3SO7fVpW0/XCbDlcv/pFwWSYSWivyiHifDiJ5EP8+MrLMpk8fPaXKVAeOghjd0MG6hrFW/AJIyBsTCyOahmtJoJIWU74rU0cpjm4tGvRhXr6AzeZenzPTzng3bZgDuF6HbvxSyFyat9HolkqqUdd/XLktFzSGqFllenuVp7boISQAgqk2IGC2MB5hZXV/WiPZQaTAX4EhsLzEHRSvwb+o6B+Eakj6ulWDnRFGH/rkrNuJrQ+4s1TZe86ivaHkU4Am5vTaKrBgz1yuwXd+hokIxaVweN9WInGfbb92n0Sp0x06OvWKQfsTaelLrb/fysnnjJx0z2ti6H5xZLA9qMI1NcMXy/ccEVfXXMXqZn7FCOF+Lkq4/gcno+TmDKW5WKBbLs73+fQVddwflvmuRLBRfgmpzgbyTkVevfQjCGr2Nn61y/tqDdd2vbRaOdb4g1GHL0MqgwSQmpEDt2d0H4GPEeGtarO5d4OzhjleutfsMd/kLxpTAu1gjGSfwEG7+aTMYKQl
 ilHWcVNw
 atxbqfRjOivfp35It2lSPUwozg61+C5wc7J6mX4s4oQMK2c4YhMDZ8wEYeZRFE5GpXtZwxWFZrmiHZdzmtirqxYGP+MaxtxXClpF1JBFVQie8dwJi5sI4da12HszmHZmwO4X4KzUkzz6OAD8A9l6uQI19tAvIS+Dvzg06CNFOSlYIk3ViDiU8tunER80SQiy/VxRNMGffCNA4bNED2QbL15EOXRW5eLVqjpFMssZdEK7OHQDMTEZsOxM4dYRXkwcSGYYozJvDOOIz+F0yW4wuuphUC7NMaMdI+Xmfq8x3hELQTyonNwQIN1MyEIs+ieYSDb57BBeWJ1/z490x+eNVUzdnI7+Ncb9FB8nZp72uY8OkquiqWe50Zz0/yaqxUdu6O2G/uyCLDC0+CoCV+bcbq7xknMH8U3KZSkPh/ZEj6wudAUb82Xi/WxitfO4aV1aL6Hg2yXHsT+FxNk6J7TzciggBzTTDKnfHWXvkengoPx8Tr49L54WFv4lvjrbJrKjknS/URvVa4P+Z9N4SvnoncXH0gUFKuMPuPS9pSvjKsdtqEhc3YWeIVF8wmFAJouvp+7BUqFhfJpphFLnFR67S5gcgkUPbCBCv81Wm6/6KRjGYgZIn/Av059djiLG2Ie3xuWKiGwJCn3JVEDDtBQdLSCs1YUUMkRmwvxt3rOFrCGvRHozc56AHrnSzxDF1lG1wuGLSFih6saQssyWj7K9LBsM32kdXaG2HKoqtGGAgw79XPODjFR1YYYoMHPobXqEEMTTb2Wj/4Ubl1HLJE5bVXzGW0yNQLSIRtJ/uXBIffGoMkd9K7hTWWg0lz5A6NdXrzPamgb9WmfFtQQheDP8tP3PATf4vRFiAz7Ea9KoIJ+AhM/PvLtWEAKlO7soQXXsWS1bfIJSYBceTrCBcWh69FnYY/4b0r99HXvbjyX5mK5kczFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/rmap: uninitialized tlb_flush_batch counters in mm_init()
  on fork()
--

commit 087cd5390dc5a69ffce740207a46d0df64ca3039
Author: David Hildenbrand (Arm) <david@kernel.org>

mm/rmap: avoid reusing batched TLB flush generations

This commit replaces the packed mm->tlb_flush_batched counter with separate
32-bit mm->tlb_flush_batch_pending and mm->tlb_flush_batch_flushed counters
to prevent generation reuse races during batched TLB flushes.

> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 1ed35d258d2e3..9f51a0ec67451 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1407,7 +1407,8 @@ struct mm_struct {
>  		atomic_t tlb_flush_pending;
>  #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
>  		/* See flush_tlb_batched_pending() */
> -		atomic_t tlb_flush_batched;
> +		atomic_t tlb_flush_batch_pending;
> +		atomic_t tlb_flush_batch_flushed;
>  #endif
>  		struct uprobes_state uprobes_state;
>  #ifdef CONFIG_PREEMPT_RT

[Severity: Medium]
Should init_tlb_flush_pending() also zero tlb_flush_batch_pending and
tlb_flush_batch_flushed when initializing a new mm?

During fork(), dup_mm() copies oldmm with memcpy() and then calls
mm_init() -> init_tlb_flush_pending(), which only resets
mm->tlb_flush_pending.  Because tlb_flush_batch_pending sits before
tlb_flush_batch_flushed in struct mm_struct, memcpy() copies pending before
flushed, the opposite of the flushed-before-pending order required by
flush_tlb_batched_pending():

CPU0 (fork)               CPU1 (reclaim on oldmm)   CPU2 (flusher on oldmm)
dup_mm()
  memcpy(mm, oldmm, ...)
    reads pending =3D P
                          try_to_unmap_one()
                            set_tlb_ubc_flush_pending()
                              pending =3D P + 1
                                                    flush_tlb_batched_pendi=
ng()
                                                      flush_tlb_mm(oldmm)
                                                      flushed =3D P + 1
    reads flushed =3D P + 1

The child mm starts with tlb_flush_batch_pending =3D=3D P and
tlb_flush_batch_flushed =3D=3D P + 1.  On the first batched unmap in the ch=
ild,
set_tlb_ubc_flush_pending() increments pending to P + 1 (where
pending - flushed =3D=3D 0), leaving pending =3D=3D flushed while a batched=
 flush
is still pending.  A racing flush_tlb_batched_pending() in the child then
sees pending =3D=3D flushed and skips flush_tlb_mm(), leaving stale writable
TLB entries behind.

Even without a concurrent update during memcpy(), inheriting unequal
counters from oldmm causes an unnecessary flush_tlb_mm() in the child and a
data race on oldmm during memcpy().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-rmap-v1-1-=
e3dc48a4b527@kernel.org?part=3D1

