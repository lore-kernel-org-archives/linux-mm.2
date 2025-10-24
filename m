Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD7C4CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 18:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0E88E00E6; Fri, 24 Oct 2025 14:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0B38E00C9; Fri, 24 Oct 2025 14:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F8B8E00E6; Fri, 24 Oct 2025 14:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9332A8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:09:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28768140F1E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:09:06 +0000 (UTC)
X-FDA: 84033794292.04.1FF2008
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 391804000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:09:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k+RZDqUK;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761329344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0r3GG6uH17KZoPbGFRVq5aXoneRvur4IlIF76waTAhc=;
	b=BLcYqvDJm2iwT+pwOPgtxyK6GILVpR2NqCmv8W3/WxZwjZmjt6LmlupUVf+rCT03pyA+XI
	LL34NogCTVt8mwYfvhxVuF7xnAC+Do8h3yXYg/HIXu3q2okYsMS/BrY/EWit7eaBd7JKWl
	IIUMDXU8UCBxxpnGZkVXt449kC4MUb0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k+RZDqUK;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761329344; a=rsa-sha256;
	cv=none;
	b=If5GVc7gqrXr5n0nvvWfIKQ43aviyVV9xF26XA0/VqEa8LO1KzAPlJCZcx9aTsPxHODmQM
	jU2doLrcTsGA3KgrbBg1ABrPOeTt9KZoWNzoIpgXLv6wZ1hvlCj30+UHvP+zZtcVq/NEvv
	WbUTo2p2egJ/+r2yQPMVCh72J8i0QfY=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4711825a02bso19668115e9.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761329343; x=1761934143; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0r3GG6uH17KZoPbGFRVq5aXoneRvur4IlIF76waTAhc=;
        b=k+RZDqUKy7XdDqASF/PSOnbywAvsKl+WqoET4xPceriFCS2qdfyko0xJ2oJ2O9M8uQ
         fScV0AbL7Ks+bTbDJ4fIDjegpG8drwFVFkjRsNkJ1MZVskI4N9JCZPXzNx4c7bK+1VMV
         4gjjJ2JGIYQZ4eAX8Mr6bd619q2B7YErWu/xSh0vot1/2TSBKMXrZIX5cCEqEwwVY+fO
         5PY4M7uNALrgArvrAed2+OfZumlLCgD3zZAhsG+J9970LbgCNoplkPJoujItlQzojO/c
         HLGUtfUxFqX69+SsHE+jqe80xcaJDSMxClvkkWcy8T3yAyzpWaPZs8Yh5PLLuoChKOiL
         rydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761329343; x=1761934143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0r3GG6uH17KZoPbGFRVq5aXoneRvur4IlIF76waTAhc=;
        b=ZGSeCheuNHUmL1R+E7Nxyot2TfVoogcHwQ1RvlPdd04WmFD8g0cG3saTDxmHM9lj1e
         iE7+7GvGgH6NVBocV4Fu9N4OzF+tNSKpTY6G+mZr2/vogZgqcRHHnUNXtj1eZMTEvWEc
         +v3pE4Zxf9yD6T2Wkg6X/KHgh+ELYaQPMn7dNz7Z2qK+Ti3MiKhDHet2zO7s/4xgVjT7
         BBnOsyYYqbpLTRDxNOpdAvTakgF1SGKIE9OAXoRCdADpD6lz2L+sFG6MP6C94SccNL+h
         CA5jdWxs/ndPrC9LS3io2r2xZBkxIvtMeini9a9gx7YYZ0h9BaHkDmzsmgeuNC5kywMR
         PV6A==
X-Forwarded-Encrypted: i=1; AJvYcCWIGSMRyfES1HQgfLbLIa/kBRlFYeXlfArLChxKQFvCW8ywGOmw8v14N+MSxr6kLplvmr3BSgXxnQ==@kvack.org
X-Gm-Message-State: AOJu0YwfKXDfM7KYIwMWsRT+4+Hu9b095J/86ct3Np42s8vQ4RQr/elW
	5wblNg7/0DXE3QA1O8EPd5DRWnzPQraN8CccF4HtZrmtbqmwspkX8cUq5jUc4iJQLUYL13g/sZT
	SLj/1VNUl9gqFoutTxRSAjsf4zLnyNk4=
X-Gm-Gg: ASbGncsBEBgz7MTqTpmlz10c79DAoGWMk5gtJlNIhLDN/4Cv2xJIMaNyG2CAEsNfDko
	IS2jc1H/N46yyR+48LS75SP3bKWiI0q6srEgmcyFDB5RMpinAZS9RbM0PEYCraQw3b/viIxGIRU
	e696YG40j1MLXkxTLNCITK2i9ENgZAN/QdC+v7YcAFhWUul3CWxtWW0YQeUycyUeg8V5kaSnQf4
	bg6K0kQcDuGL9T4zw2+6fLGxe5BdWLvKYEoGGCrTVYWmoox84AsCX79ba7immeQpwgQGX3Ru+Wd
	bpQXMS8SFfPnPaj1hg==
X-Google-Smtp-Source: AGHT+IEd2S0CoOnsCEqdQWr53aL//daPs2zGPzlplFARXHXFtEQSkqVuew1/vErGx9hY2N+n/Yhj4MUm3fZG4jwvHts=
X-Received: by 2002:a05:600c:3b8d:b0:46d:27b7:e7e5 with SMTP id
 5b1f17b1804b1-47117917572mr276080945e9.32.1761329342449; Fri, 24 Oct 2025
 11:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-fix-slab-accounting-v2-1-0e62d50986ea@suse.cz>
 <CAADnVQJS_RUTnpCX5etS_qGD=jgHjtY_Mtc5GQqPwvyyTfghdg@mail.gmail.com>
 <aPrBp_vG_D-8qG_E@hyeyoo> <CAADnVQK+3GLbq4GjOYO0Q6vhURPyNyy70bZKUUwRpLuK-R8NAA@mail.gmail.com>
 <aPrecUasNUbEkLlS@hyeyoo> <cee707e7-b7f7-4c21-8887-2cb69d73df93@suse.cz> <aPtIqm3LaRfCVQ8L@hyeyoo>
In-Reply-To: <aPtIqm3LaRfCVQ8L@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 24 Oct 2025 11:08:51 -0700
X-Gm-Features: AWmQ_blsModMP22bdNbVqa2N139hiiPx7zCrnoVxTggAjMOSrvwRYYINiPlR6I0
Message-ID: <CAADnVQ+H+VLFROjJJYkbaT6ED_ecFzu4eLci1oP9C0kDp7Aa9Q@mail.gmail.com>
Subject: Re: [PATCH v2] slab: fix slab accounting imbalance due to defer_deactivate_slab()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 391804000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7tc7uctm8kdrwdsyiehnkmzq74w6d9ru
X-HE-Tag: 1761329344-106394
X-HE-Meta: U2FsdGVkX18a1WIqA2X/BHybAxZrOvs5vAvTqdtBUbLDFwHpWvTy8qPhQcN8i/JcwdZcUNF+Qwn9occYONYgHNyKd7Q9IbIhWftLeS6+Pq2LcW2XKW15MCd8vTf7xMMZIITwfJt5z7YC3KpJzKFKFYlThDwAj/1QQOjGhXZs7r/9xb/yV/Sb1lTZgeob+7dfChXWpWnroMRlAuGq4d5Ew76bwIYN1ArgkdonTlnnOkVZnFTihPN9D52NiMofhTkDK2x4haeKgGVnD6+XP0Asi/s3w767KZ8+QL6sPs/8sSLjmQt8UlUrBEn8sygoBYqLRYrwcfOLnRn/RbsfqX+mO43jAkw7nawYanh0IQAzN7EshhA2NK5pDoaW4Eo/DReP/4vUF7RzKv/gRz1YdrDVcKyF4DuItEg5b6WYGtPfywZAM3IozN+XpvTd3PdEt+PL85aiNC/LnjWdBzUKDX8Ahc5nu3Ij0LDI2NjF9xgVwQ42NMyY6A+vcfh5j5ttCArszOdv3C9tkcWUxw6X+pSKbeP1/fJCA+IXBqelL3MfXpLYIEbaDZFHkA04a9eujtvrG7NrZFlxciw2fQaatXSO2ck+FgXLbQvvpvfw35PlPSKf5eyPe9ctFRHP7jPbhh3GoLPtl3zOt0NhO6ewbhes6nyL3BjIuXccoKTyhGW57djN172tGLqhkCp3Fq+yl8s6zk5+5ZpMB3Hcbk3+G3e5IIGWbfQ7SIQBK7mSHB47HTNzPyKQf+8QUCdeZI/+pZWvj76Z4UjT0szXFEVlg/f+Ys5F9oiWfHgcjjODD/0I0Ohm2Aict0MBom/ylgMgPlMODIQbs9RFCYC1VvSYqd25TNphWpqDC7wQIeMwwTwJ7pH82MjfBb420THaUrthqb12Ausaq+60Emn0S2pRdmqZYFlb19/csBHMV0yacoK+zHHzq6aad+MB0/9lrztecngmN4CogYyGUkWzOEZWvmn
 WK0sN1b8
 uoioko9zWCawjL0TXVKNd/Z9eUPci+4ucKpJdQs6h7giS+D+mb7jEItkFdFvipixRASH1od5+8+N9G2BAfbiMoOnViBGwJGsJga4FkuTOS3a2K78kiWSzvVMD4i+OSlRAxwrWBGlu71kBwXv+l38JKNMjccRMmQMaOFu/sWmFLa4pSWexQ38Ekw3UhlpHGX36RTVOgcXDotqDTtrJVW/L4uiESYXdo+stajISvvI6mQKpsU0iBr4KTwqSj5smKKkHhIR0twTqKn1UY16XOTfCibbFC48cWhRhT/AxPF8/TyW+dzP5R+UuyotyIUroR+8yyZuqBu5ANiqNbeVsanrarf7pMN5c3wJLGKR7GQt0ZA6552cD2k9b0N690uNsCZzjkn5KA3srK+LuoyDi+KLFtumitKABcj11GtOP4rCNyvg2F/EljiRdW2eLOD8MiANw2e0q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 2:36=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> >
> > Note that deactivate_slab() contains VM_BUG_ON(!old.frozen);
> > we would have seen this triggered if we were passing unfrozen slabs to
> > (defer_)deactivate_slab(). I assume it's also why the "unlucky, discard=
"
> > code marks it frozen before calling defer_deactivate_slab() (and this p=
atch
> > removes that).

Yes, exactly, since that's what deactivate_slab() wants to see.

> > So I think we're fine?
>
> Yes.

All my concerns were answered. I guess I understand it enough now to:
Acked-by: Alexei Starovoitov <ast@kernel.org>

