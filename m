Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0F3CA0EE6
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 04:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C3E6B00B4; Thu, 21 Aug 2025 00:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFDB76B00B5; Thu, 21 Aug 2025 00:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E1E6B00B6; Thu, 21 Aug 2025 00:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDDB6B00B4
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:29:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 156691A025B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:29:55 +0000 (UTC)
X-FDA: 83799486750.02.885D9CF
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 33F151C0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:29:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xgeHxYP3;
	spf=pass (imf21.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755750593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YiQAxhM/QJlwWL8l9+SNOEA+OdOO+5ivlQu2a3QQ5Fc=;
	b=4zTUv4+uqjIDBocFEP2Z+vZ3RQ4FwaGBzkumP/2juYKjmPP3nCDuMdhhMABfeFGFxhSPHM
	n/+zZAB3e3SBQvJUyzMC/5oQDFoPC/eaPGeODQbwIX9/PxywT4e+wTW0WAd62L0YVugmsS
	71swLfa3x/w3wtASi9qvdmnLDBlhwfs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xgeHxYP3;
	spf=pass (imf21.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755750593; a=rsa-sha256;
	cv=none;
	b=LZZQhh2OBs33llOJUS7vE8HHPuAKHyXTn8YuE7KjedksTJztgF69a4CBVYpAUA5vaG4X94
	zJBdHBWfrCFSKniO06npu5KbhHiypKvTXfN8RakQA0XJAJaspy1hbRWU0b7eIySAmEv49d
	iS5tW+5Bmz+w73ooGrETqdTbJtvbvSQ=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61a207a248cso7270a12.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750591; x=1756355391; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YiQAxhM/QJlwWL8l9+SNOEA+OdOO+5ivlQu2a3QQ5Fc=;
        b=xgeHxYP3ShutiglY/lXj6xfnuaS+LCIR/YqieD3HIoYZ5FDALk0NlzWLbgWeEjLTD/
         gHUR8UJJwXoeZIQS/KkMW65+qr2jK4KUjJOV/NIX78E7OY1n+adESRDfpEkMj+lpSNUz
         pP7UutLZzXQpXhFPjHa6+CmMCPF7fsTcvVII7YrWvz0BpzY/cFQsM5YkOf/ZpD6fF1mH
         ANDNmDKx6OFRtGhfVDVprxxoIDz8kc0btmdIoMT1g1XG/nV1NMPyoLk1riGPL92AGjLd
         JTgNnWHkEp2qwmLwYvUN7WS2umBtW3YimNI6xU/X9aScjh9eKLIkDMqw7UD4hKwND2y7
         KJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750591; x=1756355391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YiQAxhM/QJlwWL8l9+SNOEA+OdOO+5ivlQu2a3QQ5Fc=;
        b=CoFgUMg8CKXGvLa/KA0POgrlwL3uZYSmrqjUz8ew7JBcsF5PzsEeV9R99DJLpOyxhE
         C5CJTnhfBLI6u/PLzrOuCiYuoG2X/TgL+ItNxVBNNrt2AIaqgUaCAEPYTkQyGy+u7l9Y
         aezGtWy8Mw9wj/Jn1aPLxlrPs7PHtTTP7DEsv4ftpV1hT+Al4s34Rv5Blp5By8j/1jFG
         lHsdxkveW7lPF88Z2wNINZI3dJSmsjK+P2bqg+26dJWzyzYsoun7jddyxWJHycJGc5xJ
         ogiNKOKj93PXXG1IictYu6P1RRw86iTj05qktGQKEKGCtNQIFN6JQffZUetKjVFzznyM
         VKxg==
X-Gm-Message-State: AOJu0YwS2qiFXY/cKdslQVuvtm4Dnlk/wIPXChsy7yjPBhb9VOGt3NkH
	hcasuq1cTKEjLv06CWN6+WwVXE6WywwuGLCw/uE6nzVpngAddcvlRJp6YXfPGWzqNHOBSD8OMND
	l2EHAjE/gocPRBDPGRACPAnPw8wxpQSGqdWfdMY/g2TbgXUP8nZpcZLQE
X-Gm-Gg: ASbGncsFfZxk5A8ZhDmqrnG0hDUzaQJec+4PpOmKhJF1M2TuhtYLmN3EFHQmrMTGvzR
	I0WCA2XRX+pkoipMkHHCf8FfjEWKfaLODRHFjtPciW/bb2P42ilvix6kkxq932C8kfGNeVf9F9z
	0REpVDM4Yf2nhJRexZ6QIjtBfOQCJxkGdIPj/RZ8TPD6u+nQZVloRD/IHyAoexHJjCfVhPO2FYe
	65jp2BKxclZ6kHO0z5kM77msNMDjzJsfvQF+JN7iVFaJp5WjSTL2kmdNQ==
X-Google-Smtp-Source: AGHT+IF0GoUa1z6lXNPBUJmlXAgsphR5TTslfw+Yzi/lcxUYlsx48nQaH6W3TUc2RxxrXd4Bdlz7ftjct1PNH9I+USw=
X-Received: by 2002:aa7:d319:0:b0:61a:a800:f1fb with SMTP id
 4fb4d7f45d1cf-61bf8eedfcbmr24552a12.5.1755750591033; Wed, 20 Aug 2025
 21:29:51 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO6dR5=4zaecmYqQqOX4702wwGSTX=4+Ani_Q9+o+WUnQA@mail.gmail.com>
In-Reply-To: <CA+EESO6dR5=4zaecmYqQqOX4702wwGSTX=4+Ani_Q9+o+WUnQA@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Wed, 20 Aug 2025 21:29:39 -0700
X-Gm-Features: Ac12FXxHmOMkQ3BdmXM0ypZZLhdcYPi7nFCF_HU_hcXD5yQRJE2Fxc9-_DNG5YA
Message-ID: <CA+EESO6iqowMAOnBPJjERqZym_qvd6kx8BDMQG8+3xQSrNFytw@mail.gmail.com>
Subject: Re: [RFC] Unconditionally lock folios when calling rmap_walk()
To: "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Cc: Peter Xu <peterx@redhat.com>, Barry Song <21cnbao@gmail.com>, 
	David Hildenbrand <david@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 84ei9skc3ufp49ojbdp8fytfocdnbfan
X-Rspam-User: 
X-Rspamd-Queue-Id: 33F151C0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1755750592-23642
X-HE-Meta: U2FsdGVkX1+qZbBBf0fSihWe7BI6G3mQH4E8/y0L4HT0c8y0eNfFkhx7A5FV35Axyliwv7rD0VnMqEqeF3aQcceDUEjNLFpcJXsVEbujDPhjCxYZEJx7IKSNN91tN9nF+JTdQk2IOYxqpi1CNk7HKuNSVKvY2p+XyQD5rjDpWoTdUlHf5QsTjFIJqh09KNV6qpHyrnlJKr7dHsssnqih6uoeoueTVmBgT3ACXaNUGqc36v+nQsGTbc5rcK40nHjJ8soTHAPKpSRyKyxC4ifs4EdKz0VvIpI/6qK4lOOiFjWYOiYUHiaO6YQD+3kU/KW5Eb3FKeRSaGyQ1HN6DXydh3/JKvVfUK1U6UekUDeYGAyW7SSP9900wIaRafCelQOiEoDo4VapNRyEadRjS4/swGLuEjBWer30dmv+0sXJ3AZ+ziiIw4sYVxSvTJitYLnhnn1FqoOWycYLuONXdXr/RRG02lJGfLz0aKT5uTdf4QDfMzhK1HTY7qOYljogIgO6LCAc8QdhT2E0lfFLeOg3BOsd07kX9EuZW4FlRpBmmo5lsiXS0otkIRv/b1pQSB5a/Dfud8xaPI9dMPTCumfd2PO4v8aKDEe0fXWBD5gtHeiy7OdamnDBV8QkGX5CGDND1Rc8syTkMgnCe9Se3ErWtkX14d/GiD8b8n3aALOZT2lVfz2y0T3tv4/Y45GjwqGO+b8G3177xyYfzXCbYV/EbHxnIdBKzcgsfeo4e1fWdTOfTJUEoNzWFAOp/xbBUca0LZD9tUBbLonsvdBu9rdXW4ToUyyNqHAHexmKnfs8i0k1n6OrpyseYtledKzafuY+5vRwQBk8Auc4w0sPd/1+AeXO8YXy+CGTurO97Im/JvAx6o5Kl8cP2WuBSZrXdJFeQBsjOffusRo8izrvmUReUyUb1u1iD1PMyGxIhBe8EmahUqp8Jk0h04CyDV1jg06PZYjyAbmgQB+k7vTU9Un
 u20Noq7C
 7l2hi4KksDRn9S72CIb6xuOdCV3r71yHOU7q7M531Gs6u1DM/7zbHSwV/iw3KODVOfP7q8BpJ5QBqgS/qaZaVPXK3QJ88z83AtVLCN2GhQXBQacWtbJ7CE/9L1w/9tZotLTBR8mFMj+N8K9fnuZ1YvSTKO5SVM0gOvLT6zlQ6QB5HEiCnfgJO4UZ53QFvthFSihKna0pvzXcBq/O58GxUHl68m7MDd7cnsw74Cfeo9PeYSxxlE49hY/yq60CIcyV3RYR7nuzRKidQ+kY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding linux-mm mailing list. Mistakenly used the wrong email address.

On Wed, Aug 20, 2025 at 9:23=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.co=
m> wrote:
>
> Hi all,
>
> Currently, some callers of rmap_walk() conditionally avoid try-locking
> non-ksm anon folios. This necessitates serialization through anon_vma
> write-lock when folio->mapping and/or folio->index (fields involved in
> rmap_walk()) are to be updated. This hurts scalability due to coarse
> granularity of the lock. For instance, when multiple threads invoke
> userfaultfd=E2=80=99s MOVE ioctl simultaneously to move distinct pages fr=
om
> the same src VMA, they all contend for the corresponding anon_vma=E2=80=
=99s
> lock. Field traces for arm64 android devices reveal over 30ms of
> uninterruptible sleep in the main UI thread, leading to janky user
> interactions.
>
> Among all rmap_walk() callers that don=E2=80=99t lock anon folios,
> folio_referenced() is the most critical (others are
> page_idle_clear_pte_refs(), damon_folio_young(), and
> damon_folio_mkold()). The relevant code in folio_referenced() is:
>
> if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
>         we_locked =3D folio_trylock(folio);
>         if (!we_locked)
>                 return 1;
> }
>
> It=E2=80=99s unclear why locking anon_vma (when updating folio->mapping) =
is
> beneficial over locking the folio here. It=E2=80=99s in the reclaim path,=
 so
> should not be a critical path that necessitates some special
> treatment, unless I=E2=80=99m missing something.
>
> Therefore, I propose simplifying the locking mechanism by
> unconditionally try-locking the folio in such cases. This helps avoid
> locking anon_vma when updating folio->mapping, which, for instance,
> will help eliminate the uninterruptible sleep observed in the field
> traces mentioned earlier. Furthermore, it enables us to simplify the
> code in folio_lock_anon_vma_read() by removing the re-check to ensure
> that the field hasn=E2=80=99t changed under us.
>
> Thanks,
> Lokesh

