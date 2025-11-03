Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7338DCCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 12:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91AA08E0067; Mon,  3 Nov 2025 07:24:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1A28E002A; Mon,  3 Nov 2025 07:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807A78E0067; Mon,  3 Nov 2025 07:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 704EA8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:24:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AF3A1DAC0D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:24:47 +0000 (UTC)
X-FDA: 84069214614.21.03931C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id CFF2C80004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:24:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K1NT6mGN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762172685; a=rsa-sha256;
	cv=none;
	b=2GtduIRqoAIionazJvchbYqe39v8iL31b80HffOfVQnnvCiSCMH2FlR72az62XlRPki+M9
	FeeMsNRShpkU2el4fVEKqUvqiT21QqP2YtTJH+E9hyWyiPXroU+yeXUvy3yxnC4thmjX3i
	Pus2E/O8p/y6ey+MUM7Qc3A16qXE99I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K1NT6mGN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762172685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjVp41+JcRNlhKhJQBn7GbDkB8mn6fWxcVLv0a89y4U=;
	b=BeTljGepSKbegg8DBMnBmFr4bc+W4EE2XrXpIny3ifqb7Ii3FHRCTppGy8wS2805ZrnDSs
	BhFwtwAIQ7cUxNrE7gE8r0v1Q1/Nx3erkjJMQKzIVBZr9SLpoXdf4n83H9YGYP59Joaw01
	cAAjTQ2tLIU3S0JkEd4SwLlMa/5sL1Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762172684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjVp41+JcRNlhKhJQBn7GbDkB8mn6fWxcVLv0a89y4U=;
	b=K1NT6mGNNof/Q5pobPO0rhIiv5DEWcaPTwXaF4ungMPM9ox4T36JwtuDuV4ZpIIITvoRGF
	efOQZ8SR5aQQHXbohGQLehGLUhVi70PVcs9wJZZRhDjO6Hmm5Wbr78nfdAK4KO5+fcVwgP
	RUSRPSewj0lcNuHLYnsYGrXcwIaRR9E=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-l3ExsF-QNdypU8zoY2sBMQ-1; Mon, 03 Nov 2025 07:24:43 -0500
X-MC-Unique: l3ExsF-QNdypU8zoY2sBMQ-1
X-Mimecast-MFC-AGG-ID: l3ExsF-QNdypU8zoY2sBMQ_1762172682
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b7070cef38eso428209566b.2
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 04:24:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762172682; x=1762777482;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GjVp41+JcRNlhKhJQBn7GbDkB8mn6fWxcVLv0a89y4U=;
        b=PaA8mxNN3H2K15nBBC9PZ/AFk0T5mXmAZM1DMZ+TqSaCk15F8HhYaoHxs1XvjCrco4
         YtAxpc9y3yVrPlx+Fsj7aaqMYQ1d+iskZCy+2cOdtzTDi5fZbr5cx5tStgulbFiVklnn
         0hkkVZqs8HQJozPuvtau6nfIIDFLSgVkXlRZX38PDKxF05r9pUxBg+CByPHUVMQMJJI6
         QuSCvEI4azs0MH/2EyHytbGNt7zEUSRPa46dAaIh+iSo3Y+UYBwulKQcNbkLda2Bm5N4
         ctC1EAw8nv+APqUH4wtCyaHllALuVft9CtxF3426hZnaFElw7kJI7x/MmFpNzdctqX8x
         vBqw==
X-Forwarded-Encrypted: i=1; AJvYcCVnkQ8eN1BrJNrgSiP8qoSxZ9fF7Kx6WKhiWqw0RRuVqFhT2qernBkzgNjT55HpNF5qeweMKtuAmw==@kvack.org
X-Gm-Message-State: AOJu0YyTDZA4stzMhjc34Ghx1Qz1djE0IQXDJTP19JooMBwGzxoDjf7P
	c1mgi4O6pcEWAvOdhMiiDcpMVPwkwm+jhwCKfJRRMlXdX0ELZwelwpx57pkR473tCoHPAKideeP
	8yKeUpH1N3EAbCPwCMEHsj5GdTEnvJxBaok5CW/ZUBT1YS7tIghy/
X-Gm-Gg: ASbGncubMPGJHii9tcu4e4QDWW4JPkzY8pkSS6zaz0H36ET/IQjKcIHgWE9F3X8nHPW
	TCNoWThT0ynZGBt9c6dKG8QWNjQMQMhq1l43sSCp7R06+xGv0Frz7LNy7f6Texvwypmlw5f65zX
	Ii30eDJiE6kXB2LwkQu9ARSfAFuAgUUTavHm+ygJnSH5xU2D4w5Z3XEG50BGIACbL5lxJJnaTwH
	oHhPrpzzDmCGxey/ZG+k9rS/8QSfig+AtEnZrca1BXSrXxPFJqilUGfXUoa2Dl5PyREVzLPxKnh
	NZdsyyXQrKeP39DPT2yKt6w7lHsi85s389NF+uofZv1KCho5MfsrquC3TWSQZvxVhaGbvJwCILF
	QOQvtpN3Rq3voxfPc8sAofOc=
X-Received: by 2002:a17:907:6d20:b0:b70:b83a:73e5 with SMTP id a640c23a62f3a-b70b83a8c35mr359785066b.44.1762172681734;
        Mon, 03 Nov 2025 04:24:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFL2sLtytpLuUcKWCOkoRDcXckWNNb+evONxAWiMkrqYHa0li9xt3zPEufFR+6cGkgmgzhx/A==
X-Received: by 2002:a17:907:6d20:b0:b70:b83a:73e5 with SMTP id a640c23a62f3a-b70b83a8c35mr359778466b.44.1762172681211;
        Mon, 03 Nov 2025 04:24:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6407b392d5dsm9676772a12.15.2025.11.03.04.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 04:24:40 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id EE02432844E; Mon, 03 Nov 2025 13:24:39 +0100 (CET)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org,
 yuzhao@google.com, usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, asml.silence@gmail.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as
 page pool for net_iov not page-backed
In-Reply-To: <20251103075108.26437-2-byungchul@sk.com>
References: <20251103075108.26437-1-byungchul@sk.com>
 <20251103075108.26437-2-byungchul@sk.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Mon, 03 Nov 2025 13:24:39 +0100
Message-ID: <87ms53pam0.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZSYtqjb_FAxhrfgbA-MONAYG48Tid1u9BoUzw3n6DeY_1762172682
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rj4ipq1m1n55a3ijo1c7yeg7scmgzcj4
X-Rspamd-Queue-Id: CFF2C80004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762172684-878287
X-HE-Meta: U2FsdGVkX1/cRjZuONBhNH9foRiAcvTAoM9RR+zrF5yOU6Ent/jEdVoliAKXvjdDwn0PWfiHmLFUJ8Y0VS+uXHqaxc6WZPSunnb+UXrKj87s7Hzr7dSkrXzjDQPHR4JgELG5umwlWs2eMmx7lDuPxCJ9o9itZaN5kbALysSnGQYf8ec6PWpD94OOuD5Te+Fhkksu+f/z9Sz7wbe7P2CXSDcL4AMwC9O/U02bDqG10ySo921eBS7xzg+eHzFNp6IWrdTfoNl+iL5brmHyoEN2b3pRe82v05/Z1q0ou79wrXLqC1cmz+LuVj1fVITO9Y+tvrPyp3+t5BcYfGpnTsu7QgjsRv8xGg4EBfroEX9xJuCB5dV9O1yqH90YsTbRLhvhMiMjyKOd5mERvE2/VAJmoNGJcYxVSbb4nuQNM6YZzCYnKo+aQRXBGA+v3m2SQPze3pEWxHJZDE1z+/DeUHL1XCqaQVONjhEAHO4BqALlElECtxIGT4Jw4WB0yY+5CIIODqdrYAlop+hoh/QiM12W2cE8gNmXLzmvAVo+vXtIMW7SHWVRwYRI3uLg/4cONNQIWy7Tp0Haojo0B4h20IDdMcmh8EDbhQt4WWD0YcNyycjY9lN6FOCCr7Ry6aCEKTaW1NuNunmqvrzQ+z29mByJHAKMPeM9oRmKz+SDsQqoz8fjuHGUCF6VhxMRbHDBAdDQVltZCtEMwwO7HZGZa7AjDTL6bz5l7rFaboSmZkg6II+nOkJMmdFvZjszuuPv8NYmh0BBgE3a2OK+ECxl4Q26kJ29hcgSiSjMYxmciRhbe+5TidZ2zRWmyEJpGlCn7nhElFA9HUyoOVkNQLBDeFBkQX6PrE/ijQGWQWVoypaWXRDQNz0s4UzJ+41fmgR4LZcoQlgXbPzZCffQCIscDRgw9LiXzRfXryA5GgLUW/vaoh5rcMs6Lm9DNO/O49vGXy5SXLYwIsEM8zjLK52DaQw
 xc8HPjrM
 e7bAu7SdlKYMljbgsZdk59JR82LnpfOG2TV/xmMWvJa9W4kUjXAT9xbh8pXoN3ZMa8sL6Rw76t6hmUEm2tbjKD6UCvYQLKyXabu7Tunif+g6Vu/JEYlG1AR5GmLi5t9ORMAUGZL+P4RTPc4cUozTP9V896uXorFVIk52NCV+i/UeQa7+mGNfKtp6/rPgXqA1oa6hbuitOjRMsMBnsIIY0djwThfGISfVdsl/aSxxapUHdOF6nRry7c9tkQf7bzhv4ax6aq2QXu9R+4ArEJ4rWYo8oaW1ElF7fOpsdWnvnh/o3/FZo5+Q5c9Ey8B5wnL4U2GruoaT/lUm49/e9Jhezt1MI7UGdrk3yZVT6GLDcvL2jp5GMI6pLtiN4YBnBurl2+EjwHyBgm13qW8BRA4KFrFmdnz9BWeRGvShY5ftl1kn4zrU3CFzgRzymBEYjwAYC+eyPjtCTVFra410PeN04Vf3/25QiCAk1VXTnRBc8oTFKCJBF3BPwuc5a/eYexZN819aIvWyaOMJNbbW/GzHILZKhkKntN8XQ/J2eVFPNWcmWg46dW3L9puUPupycaQEqVzev6Zq1j1+9m5BXsg8YQkTIXPV9akZ77Bh4TomEOxd1mWZUVc2iVOC3vdmHr/hcaN6oztdm0bH0CUBCvqfumMbL4JGzO9AXxaVbYbF4yBhA2/eXwqE7iwxGUU5EBBUTypHJqzFJNpYGr4UnHXV5hximinmLGHMAFRS0trIUdyQuekiqtTxfylBlNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Byungchul Park <byungchul@sk.com> writes:

> Currently, the condition 'page->pp_magic =3D=3D PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of ->pp_magic, we will instead leverage the page_type in struct
> page, such as PGTY_netpp, for this purpose.
>
> That works for page-backed network memory.  However, for net_iov not
> page-backed, the identification cannot be based on the page_type.
> Instead, nmdesc->pp can be used to see if it belongs to a page pool, by
> making sure nmdesc->pp is NULL otherwise.
>
> For net_iov not page-backed, initialize it using nmdesc->pp =3D NULL in
> net_devmem_bind_dmabuf() and using kvmalloc_array(__GFP_ZERO) in
> io_zcrx_create_area() so that netmem_is_pp() can check if nmdesc->pp is
> !NULL to confirm its usage as page pool.
>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> Reviewed-by: Mina Almasry <almasrymina@google.com>

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>


