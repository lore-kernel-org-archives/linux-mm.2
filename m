Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D46CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91936B0008; Tue,  9 Sep 2025 16:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69516B000C; Tue,  9 Sep 2025 16:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5FE6B000D; Tue,  9 Sep 2025 16:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAE666B0008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:08:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A6F65984C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:08:11 +0000 (UTC)
X-FDA: 83870798382.18.E0B890D
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 875BF10000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:08:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=atLsproA;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ktxPXY3FXbFBz5mAoTAioVgA7sscE5zPCw8jojY97cY=;
	b=5rztajIIXbfuu9smHkmum/ekZMK/LKdGa1HsNmQaOJq2IVG4/+zACUdy5S9pV4lOMlBFOI
	7Un5YW6KkU9E6qWHkQMuaprVb6NX67UVwFQ42Z8josHwOBdqe1TDUkLnT/Pi8mZKrRD88k
	ic13c9mB84/BE2z4MTyZv0aDYSvWcmc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=atLsproA;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448489; a=rsa-sha256;
	cv=none;
	b=unnojW2v8wbY0r0rceW1AcV+5zWpdNDyA9gddaaPavrMwLrcaeYOrhh2s8GRAdIGQ8IxJe
	rSGpFslpneaRJH/VYj3SlkuIGnu7Tm35pABSa2MEc8KUhxeQdRFQrZaxxOb+8DseH00pub
	OE0De9j3GHQ+KxRJgSZsKxncFxzK54E=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b4bcb9638aso129271cf.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 13:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757448488; x=1758053288; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktxPXY3FXbFBz5mAoTAioVgA7sscE5zPCw8jojY97cY=;
        b=atLsproAuBtmZnk3uaP5RBiq5eCt2w6j7wYgfLjZ546VJiYBK1TN6qCW+DiGePOGGJ
         c+vfub5AvbGg/mgoraRH+gsSiYwN9pBbEXjfcNLCM5qRhf9Z94/Lh6B0LXDOd0PEGfGG
         32bR6PuMEyBUGc3Skj/0Ja5fJ78IGS1W4nbYZaMQfivTHgkeHAKa4VjCsqbDIBX32Hru
         yz9m1nfkpBzImsXST9uOOi7SC3nbTTe18gZNZJroR3PJkyuuIYnV5vDvF0muKxQ3VG5K
         SiwKALsEn2p6o56eay+esFalXMv6nuIJds7TJXfyApf4w/xBzgzrwQNQ34GbWic/JWve
         yDcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757448488; x=1758053288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ktxPXY3FXbFBz5mAoTAioVgA7sscE5zPCw8jojY97cY=;
        b=VhgYCFWG1C4LNgjc+V4hvfhGPhDHVbce+G6kfTY32NsovpAiwOz7GJZG+j8G1SJCrE
         4Xt7YR6FV81zTaPQhvAC3Ns2kyfbrvZ5F+Xa3izQJ4J922NZTrLMOKUEEEuHujCrT4Wi
         DBKytYpdvUdOd7Bk6yBUGHqx+EmQd1jyeppMDBqUJ9/f9zmzdpYeP5XwmpayA24qY7qe
         CSTyLekAP8wJNMdVhkAFjW6alxaB8yjkaRtO0Q2r4N8dXHoCpTIuUJ4zK1OP4IQG/5x/
         dayy6QThyZ4Kb2janSsK7HFQVv9Li7KhjYa3PNamJFoaRnANEQf9AyJ/dOhV9A5aBxTF
         krfQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0NCv5L9kdcUj/c39dPOUpgcJXJ+8Vk3RB7WgZjJ2MqHaklW4De5lRBrHQk4t2ifXfU10+4iVcpw==@kvack.org
X-Gm-Message-State: AOJu0Yz+QE528HLOGFdt7YrzTyVGF6IjcCsax//rQ/rsFaG9dvdtVkf7
	uIdu00rVnWDNjOm16YWkYiYv3uXcvCWY1FOEsldQAyMuAF6gZc7Cud+D4ZZjS/qd1BxrmnHV+Sz
	6fLGuNBvf5+VjylAaMmY3Ad41M/0jHY+1MQyxn1fx
X-Gm-Gg: ASbGnct44p7WbvoRtOgf+VyG6ImiFhK8pXJETVeez3WHQgnHr2gkFdzsUlKnaV3XXLh
	Lzd8kgzhRsLSUUY6x6phargXwDoNIvQ0Fzx4Lx16BvN785Wld5ZC9+cS4eYKTDl6m5XBuRH6czb
	ktHmWmoXGMOzzG0aRw9qYsiD0JGVvBKDZSRWgPgCWedQP4VHVphVr2wj+uecdqZs2YcEIBaPkal
	zMzFoUYILUH3Bv1UFd6UpSc9AAr4XS+E+DCNcs44fZi
X-Google-Smtp-Source: AGHT+IEiIDXhAKZ5zA3wuc6dlxMlvsypLMSrwiOmc3D0J6T34wMRv0GdxjHA98Txfmfmy63m+RjNtLqEv7OYeYbVsYA=
X-Received: by 2002:a05:622a:828b:b0:4b3:4b14:b420 with SMTP id
 d75a77b69052e-4b625643a28mr813671cf.7.1757448488179; Tue, 09 Sep 2025
 13:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com> <20250909190945.1030905-2-Liam.Howlett@oracle.com>
In-Reply-To: <20250909190945.1030905-2-Liam.Howlett@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 13:07:57 -0700
X-Gm-Features: AS18NWDRFWvZMJ8e1fk4lCTGGRgGWp1CT7Hd0CxGRModRraXwvLx01LRLebKNO0
Message-ID: <CAJuCfpGsGvYfCQmx1ix86zUM-u8n2EbSATS5bcHMs9=_yEtRzg@mail.gmail.com>
Subject: Re: [PATCH v1 1/9] mm/mmap: Move exit_mmap() trace point
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, 
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 875BF10000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6q7689b5jmiqabpx1apopqqhufez61kr
X-HE-Tag: 1757448489-855547
X-HE-Meta: U2FsdGVkX19jlB682pydkV4vIfwSUD7oeAPWVElR9XJ880id8tgVFwMGkPjWbZ/41c3RpBbrwQQuPZmiEFm2jlZtehihATjW5yu7Jqnxacs2g3zyHUhh99nYuKJdvRM9kuRODPUB182nQs7hUITKpACD6Ibk5n25pKsKiu4436NKRQlVL6grttVLmSIiAJr4+3Fkz/BTyFD5iU1SS83X56iQRchkr5IM3ZYTEyOOoaKoKJ4D4W59wWop12lpKW39J67ew0bYfV98F9NIKAv8cwZYZa9AhhZb/slGQyPDU+0ZQ1hMMu0teSolQLB/f+l3RaciLjPaUAVVX+SG1ruQ7BFokYxcmXOiY+Sa29zO08ECBKYMVgFVMAct142YGbPTezMJ22xteq+RlagnwVQ1oYo6ykBfhGnYNSz4xeWLX7FaQRPJ0yOtZQ7v16yGRBUsfkkDgrCmTgMucFbQgCMaEgwm1otnHlvm3EDPzGIzxMtBi7CMkKXDdWiR9C5T6A8VAwhxFXYW+cefENs2SBghLGrwJN/Q76t6HeLXftbfwX8F3CcXCLRiwp05DNvreX8+Jnh8AlgW3loMXOJTRjkcmRBtuQBM6X0cTPkDKPiZBl3NCJD7aokRypOI/YAJzYN6z/AYg7bQ2J7iwvluZnGq3pigpwwOQUX4IYXnpEMR0Vu2cv0DjHHLHfDvppqUVou2tkh8LIv3L5+lXuwXpmKvXG+sQ7b7h0qHxmdhnA1cS96r/t6VuPfCDoLGdV2V3e60tqS1N5YfjMnh7Itppienk51TPIrI7J6837+LqCSLUn43uDjuVBYUYqZU3b+wODF03OloFJ9wmerO5vYHJvYWwOw+lrvyQUbaMtkVRTYYDP0RlR+zPOITmcR7TWMLOvqnhJbmss1iTbivNDOpj9pMZ01euv+vjHFyNHu32SGiPgXMFAiWXc/1NXYoGfgQTMaocHIHWze1/Pyx6AKW4Ei
 MbO/7/YR
 h2EqYKyhW5zEHntdXxzUgEA6MVLL83H8D7t+iyW148nhEembzYgVgLI3YH0Ari0BLIpE6PlnfKkSys0ePhCvQtFsfsRQDvA7RPco1YBuioqr6s1m0d0CcmfNi/TypBHRLEDLA3bDqU4FW8ymhsB2/3wdrNiwZ9cAOlE34B/7Qc5GlaHYkUQbcnnkcHj+NA6YL4vJolJFKzrkuhzdNtir8zUIP4dJ+1ADU2OtOJsJD0T109DlegCkZrwipSyiMEQtoh5Nmi0zv4+tSbpbwfJNA562ABsjkDd7eTZtLEKeYl0GG7VvR5Cuxsqp0TQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 12:09=E2=80=AFPM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> Move the trace point later in the function so that it is not skipped in
> the event of a failed fork.
>
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5fd3b80fda1d5..b07b3ec5e28f5 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1310,9 +1310,9 @@ void exit_mmap(struct mm_struct *mm)
>
>         BUG_ON(count !=3D mm->map_count);
>
> -       trace_exit_mmap(mm);
>  destroy:
>         __mt_destroy(&mm->mm_mt);
> +       trace_exit_mmap(mm);
>         mmap_write_unlock(mm);
>         vm_unacct_memory(nr_accounted);
>  }
> --
> 2.47.2
>

