Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1970606EEA4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NwOugIzB
Received: by kanga.kvack.org (Postfix)
	id B66066B05B2; Wed,  4 Nov 2026 11:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19486B05DC; Wed,  4 Nov 2026 11:51:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F3B6B05DD; Wed,  4 Nov 2026 11:51:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71DE56B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:51:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00E768078B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:51:50 +0000 (UTC)
X-FDA: 85398028422.07.5067478
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14F1BA0007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:51:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NwOugIzB;
	spf=pass (imf25.hostedemail.com: domain of bobby.prani@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=bobby.prani@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RolwxRoQLA4mJin9vBdQpf3oG/PEdLsxtoKEj0r9vc8=;
	b=aPuVDdfvd7mhY5YdYAaQdyO5y6GPsvfqPEf5qP4ZFqPsC4vIh1LlSdC0iyLONQSgjcRBx8
	cKKEns2OFJATlGaZQoJCXNIlMd2BjvDDOqFpjL2w5vKzlGUogMJBMjpuK3PQcVRu3HhUwx
	zUp72XlS5WaPfwX5Bbqr1nNjWh43ROY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793811109;
	b=I6cuU1v5QHhazHyM2Haw8I0frBcttnMCciV60grXyKEhcdpCZmPc4mOZNBiy4s31NUpulN
	P48fWmSif282zowE/rT/Q3hEibKwCEHuZM/xtoSNfsISXtKySsnN9AqvOmuNWbcWAc5NXJ
	xAd4yilom+8utLvpPf7fVVgpuHZZbMQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NwOugIzB;
	spf=pass (imf25.hostedemail.com: domain of bobby.prani@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=bobby.prani@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-3ace2e3a2acso378941fa.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 08:51:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793811107; cv=none;
        d=google.com; s=arc-20260327;
        b=BRV4t3wiHwX/1MaD14fMQlX4xmUTqd26EAX0d/+xNHezQq6SEELWUUVclP4tnnttd2
         HGFL0LX4ExrYQgEzmxIflptgbvTDw4HyBJIL1w5SP7GxBD5B51mw5NwtTycOFfKY+aNt
         z3viD1dETE13sa4thNAUGBZajxo2xuCbUilIkPEycSMe/cCzl+HK4qtqstcSdShh0kTS
         VvGq+CoOsQcM4ByT+5uKdamrP7lC1Ybwzx/ntw9N0unKgxNVgvKebfbudzvx3mVI5zfe
         DCoLR+72lBs6zoL4m27GfvOQZRqn5a8XzKuHDN7stltxd4WfkJ/9LKdEzWM7bQbVBL/Y
         JTZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RolwxRoQLA4mJin9vBdQpf3oG/PEdLsxtoKEj0r9vc8=;
        fh=8fC9afwu006fHKFYqpp3XHUZkoyP1ymIccsxO/UEOz8=;
        b=ZfxXbfM/huSmDBWyaI7vC81EdP4fJJ75LOpX5PqNlLN+Vs9RPuW94jSFxxuP/xEJEu
         HEtWh76hak8fqy0ITUAGrCHeAOh+7bNymcNS5+Ywk7hyCMrsm+WNvLw+dqelQ5ma+W4Z
         BGg1dhbBCs7SefJG0ykU09Wk63ibaFc2+9Fhhzv2GMuNxESJDatT822AZGuyS87jAw/0
         SjFSS7DyQW6cAu2rZ6VnrBowcfNhpl+su7AQfjQvhrM/NafVyZ5tgMcyzhXnvugJOyr/
         irxXMYHcqLCsM5cVYAAnBPQkDonEnd0z8Vn00VI4AB8JqsGv/g4kbnN3zVRGSv4Vivyj
         hMXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793811107; x=1794415907; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RolwxRoQLA4mJin9vBdQpf3oG/PEdLsxtoKEj0r9vc8=;
        b=NwOugIzB08+Swuldb7fjkYj1tZeFyJER5WRDbbFSd16xCwoZ9p9ibmhHLt4VkDOvKe
         uTNTB24UfYVLXcO/226NgqMwr39sEdbzpjRdQ95x/YaWW9uoHu5OwZmM8dA7gGxqa1mz
         53O0GWS+TzjBsxFwPQOdmHhdbfQqnwOVq3o6ZguI+SJ99Nze/Y3kpMRKs0jtljwj7dGU
         MedNsjp/dp/tljSCEpTYBzgnrTVTQQ5MfUVQ9ek2fZX/WVe7gOEP/fS6m+ohnD7in1LM
         hmmx9ESdIyaUKBqwZ+lPz/AVSjzHHlTNbeUQFThpmlDGAQ7Kap0NIWlxf2qKLxNg2UKi
         Wy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793811107; x=1794415907;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RolwxRoQLA4mJin9vBdQpf3oG/PEdLsxtoKEj0r9vc8=;
        b=DvLDrbvVjlXHi4u31bSrTgiHepAFKbB83/BNRMbHJ8T6Fhf9FTshGcHp+DpK+0z/cE
         XXpQdnFHUsCbgjIQpOmCRPZkdslB1PIQrWUt2V0+Qo3ArdQ4cBtfzOvNJ/HfTwv4Yopy
         c6bUkixqYOlE8lFAU21Ve6Mml1ucDB3rJEdPHg64rsVZA0wNVNZkx9YNmWy8MhHWyi7o
         FbWx/XSMJob3JBOB/ODZRMKRRy5ripA9jvY7YPgm4AcQ3fpP9sDIDBYbWndQJO3jjdwC
         YOW1XtoTqcSBry2lcXGk7uQFkj4rsddSgoTFW5vm8m+E0KSXpMBiMJH5vFo62koeYcDB
         9gnw==
X-Forwarded-Encrypted: i=1; AKwUvBwrXg30mvb3ta55VA6t2J6tfW48RC2XTbVOdzCJr9A2JHaSOqcJsmMctDmsJSNDSUQYkXuMEYDvVg==@kvack.org
X-Gm-Message-State: APuU4Z8eXCP53mFFSik8xyd//nd888H1+NhyQoWBI67mMaewbEOphyWO
	r2tLAtsX8Ph14YRH/zB1wQAAUOplTCkf8LueAdUBobtpPtvsLwWNrc91ehN3OzrAlKGA/McY+8P
	ZzABOSLcwUSbYF0rHiUxoTe28YvUWsXA=
X-Gm-Gg: AYBFou02vl+KS7665kOZ6iYUYg971pZICKYuS8dqM5TyhbHFmQH1ZNaGtMqYpsVVDv4
	qMDz/FEpVQDQOjtY7KO5cqrbkEiLZtlvSH35kiyUmHgv8azfIgLqEXvGNsnO1677HdQbJoKzSrM
	NZu7zw0Yqp4kEQ0T4juTkgp8k1vyHxPD4QgpL5Bd6+3QNYGwLAGs/usUk7WBzTSc6V13EXhPTWX
	1fQdG7k+h1V745rZfUriXt3qDW+LxTu3KZHD5gdoO6PjAlWZxgqkylkjOX8QtwJR1+hvv9nfSdA
	J/goB15i3oCHWYxUEurfBPQLOoEhiztbxV/eE1ZIrGElRLfVRLTAmUMrGV0jCkPzfxh1K1QKoEb
	ql+2sybH9k62gUs3rYumBgsKpFebKq4o5VsX6v4fFcs7lG5qZZcUbtQrjud9q
X-Received: by 2002:a2e:8a88:0:b0:3ab:4014:885f with SMTP id
 38308e7fff4ca-3acb7ad2de7mr37137611fa.23.1793811106978; Wed, 04 Nov 2026
 08:51:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104013139.1341582-1-bobby.prani@gmail.com>
 <750560f3-4c5a-44fe-b72a-0611be383f32@kernel.org> <CAJhHMCCu8ehOU37_4UpExNO3U8YPygjnht+2S+axkxTwY8bx2w@mail.gmail.com>
 <287698ab-76dc-4aee-8e6c-db1f5d18974c@kernel.org> <aus4ag1KxpuBNSP1@gremlin>
In-Reply-To: <aus4ag1KxpuBNSP1@gremlin>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 4 Nov 2026 08:51:20 -0800
X-Gm-Features: AclHuK8lUkRtT9DIM2v6hdb2JEoHz8N8QglBfCOcEbvQSbdRZXUQbv2xSsHG0dQ
Message-ID: <CAJhHMCChBTH3QWBFS1Hp17zj5HepN6KFucvG_5tVdpaB4fjCYg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/rmap: use release ordering for small-folio
 mapcount removal
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Richard Cochran <richardcochran@gmail.com>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:PTP HARDWARE CLOCK SUPPORT:Keyword:(?:b|_)ptp(?:b|_)" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: kfazz9n39n8gd5kwdzxxwu6fbi8otrh7
X-Rspamd-Queue-Id: 14F1BA0007
X-Rspam-User: 
X-HE-Tag: 1793811108-820318
X-HE-Meta: U2FsdGVkX18kbJNSxbTDtaFWimNlDJ4WUyW5iq4nbVHI6CGiNkp/OC39FxxXZzyUTGgS5r4Vw8ewmZROmjkIef0X3OtERjrLRY3izjaIVxx6Nc4XGwE5gG+Thac+s1vkH+2KkP4HQ0OkTQ6IDfvlbl0RA4iduDmzL31PTaOxDlBiH9jdMJN7wRHIFlvys8fFQSjif7NMNzaHwxnxH/P7AO4bVdtdEN3wkPEOdx+/pk2Ey690u1B3aqEkf3s15RZgTs4gY2gmpKeQHDmKVDRiO5QyDwPmzij2an4fvAe9YFnyiZAsBsQZQHzmau//oSbtTqaMfxMfhSWZlvMNIIs8AhSsV911emrTS2CSKmA4KeTu6Q2fE3Cr0C5G/wsDoSn2kManI/zY8rwN/BjErJVgOv7M418FoqN4EwzMgLxpOLZm4OhBRn+bnCzqlPpnjl3r7ienH4pDwgoEbANeHtnWWoT61kvXY1IOaFE2eDowaZ90RGHL8FcMrbgDTHFnSRZ2M4zMOpu0IyNdAxWqIjmZQWjJJkXhIeHRwyFPR2pfMlDB9Bg9xEU/MXZMSMSGdiKmAgb3LUxN+XtdZkhKeQc47fFwibQaZTyCbJYBrydL24HwOfSKZFQEfCbPdCj+G8EDl4VrnqTWf25JcHSm32x85CcuxX2HvlCydmgFnqykq6GMQFuoCKd6NnnR8dSCXjBonldw0tPJNsWGrtZyh9+xTWB9sjYKMxH9lwO9lLRfiaL6s/cvjE1EG5//WaEvTuGd8avk7cKoNyaxFaB1G4j+zv2neUA1/smq2Luwho4BAGIXdThoEDOECAoJ+h8ui0DB+l5UA9bmhLRgNHVQRiXR/ICR3gvlpd8id+KJRjU+DggczBZTnOgM8eWT5ft68z3c64Z2zL9VUG6ELNTNLs37D6UYhBWIR+B6kwmLpxtshhTR04fKF/25/JjBXGbZqRiY6S3GfmRINx4I2x9chxs
 bTLiPjHS
 lwiFBVlAVk6UEpkuf8t375dof8EwgEsstfBZmgoD+HHnpiMr58RM68aSgpkcy4MHY7lDgk8xVryQuUwc1fc6WZdj/2r9VDwaLRE/tYxkxGdbL7vXz42hxHhbnjDEmhvxv1PtAmv5iI2zKLYZBT87V6YZwj02M6QCUTr98sUB22h4BS+n8YkWzIajLKahHF1HlnuCNJcWDn8XoyiSzLzaxqw/fQWjQXk5lhwT8q3s6iMj+Ewyva//oy1xpalkiVaXUzn9EFj6f66TUhWRJ2103ORd2Y9J2W9o6hsdv5QVNkESAjPmLxEJWoOlSN0ImlxTeq61unbcVQOGrQeiNeyIZF/6gyG2vLeXrWEQ4oLcPURj9OIa5LzlUUudbJwnI4nVvKGmBiRsv9+UB0rq/ujrzpaQVOLEMC40pPM09rgQCtR4EjVmzfhDVnVOH7clZZt/UAWGojo0gdSsbX4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

On Wed, Nov 4, 2026 at 5:55=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Wed, Nov 04, 2026 at 02:37:39PM +0100, David Hildenbrand (Arm) wrote:
>
> I mean 1.54%, theoretically is even less convincing for me :)

With reducing the strength of one barrier, I think this is a non-trivial ga=
in.

>
>
> In any case for something touching a sensitive memory barrier operation t=
o have
> a stronger argument put forward for release ordering being suitable than =
simply
> stating it's fine in the commit message and updating a comment.
>

Can you please explain what information is missing? I think the commit
message has all the details of why release is sufficient instead of
full barrier.

Thanks,
--
Pranith

