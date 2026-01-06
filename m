Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 357CBCE9D4C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5346B0098; Tue,  6 Jan 2026 10:22:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0706B0099; Tue,  6 Jan 2026 10:22:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2656B009B; Tue,  6 Jan 2026 10:22:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC2D6B0098
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:22:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2771E1A02BC
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:22:02 +0000 (UTC)
X-FDA: 84301904484.02.99C9463
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2071E20016
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:21:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=jYvBWqJA;
	spf=pass (imf03.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.177 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767712920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDrYuR7f2Pn0DSNXMOjTYToBLnsosSITGyOOy6cQwP4=;
	b=cDuW6K6o0V4sk7SqmfFEExsy6k6YMGbAXJ13v/INejI8wx26Ks1pqrC8cvc7O8IPEz359e
	twA3SFC7gmA9xXVpd/PDOuCJOE6vPmj7YAraPcPqjZc1Z/kvX0zBhtLe/npWLvoNBuBYN0
	gbC3U5S7bF9FXArSVayt8Ci/9kzvd0o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=jYvBWqJA;
	spf=pass (imf03.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.177 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767712920; a=rsa-sha256;
	cv=none;
	b=VwjgwglSLoK0amjSsF6U9V1oG3Nwb6W5tPq2z9xNtaksnONgcyVimKixjPEIy2Z3IeolV6
	5Mu05Pw8OT6DZ5OTFdehrWKqQ7xXdW+UpXlsYdAXgsIAutMimmcPs3dvPZ70up4iRmpvGi
	g32uNPz9WulMwSytw6VdW34ciPd9XTE=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso11072661cf.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 07:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1767712919; x=1768317719; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kDrYuR7f2Pn0DSNXMOjTYToBLnsosSITGyOOy6cQwP4=;
        b=jYvBWqJAsbU2jy1ss4yfHM5GpKQ5xJfWFXPNwmN0y/cvWnGGuk+n+XURKTgkqqTb7B
         VxJRPvpDbJ/KX0c/po9PmF8aD384QK2niJIO2shS8+F6fyy7nujDhgOq8hApHJ2kQb2h
         BD59KdB/UCDj1W0lHYo4j4nwCKlnQddqaFSV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767712919; x=1768317719;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kDrYuR7f2Pn0DSNXMOjTYToBLnsosSITGyOOy6cQwP4=;
        b=C8mqBbo0inYAM7tHBQow4ey+naUJugxjjajt53x4wjyomUPWeYCX/mmXRc7XpBhPhs
         C9vMzUCKEiYrQ62mi6jd4uooJV/yzCaW21b8TZOkje2yr9Rrf1O9WDlR4uRg4mvOPjAZ
         chz4xRfbx1qSbpoukPEJSg9vSHxgCOb+Eqho2rBVUYMR/3zRBgX2S35MAd0ROS83dFEd
         xYXL5BgVNj5uM3OWVkjJzVMCoN9lK7h21rOOA/L51LFCyub3AgwKSNZGrgz2x/8avvQd
         UCPrsrI/vSG4MDjywMviEGfocW0qpjR/UU1JQLf1nLgk2UlljQ516JJ2FRPIowB/dk9L
         HsAg==
X-Forwarded-Encrypted: i=1; AJvYcCUcJ/bZQGhD3+Dceqoyn3UWuDBW32b8EkDgqw1OpyWej0v1nVqIRz0uHYs9k6vX+2sAn33isqTZZA==@kvack.org
X-Gm-Message-State: AOJu0Yw1O1ZVY7I334M5YqEDznV7My0cgBTaQ72F99HvJxzkwcJftJZG
	fgwJjoYYr+FPQg2syu8DfBpGVn/rMkUgNHKSXAK+e5Z9l88e21tFAiVXiQe8aQVIDXXhL0IPFdo
	hQDFvL2NhEYUIuop8i3cUoFHMCT3JLTiwwg/qduVz+w==
X-Gm-Gg: AY/fxX5sLN1a+q0AIHxUYgBTHdzDSCwo80nOJmstiuYd8YCOGwaL8KpjklYt4wIL3xL
	LnbG4xIQ+6fnCZ5yu8qtZ6Upp7vxFNG/TcIVgyxO+mc+l9wsw9S5WNckQ/eoLKCMYF8u5AWbms5
	R0p5pZQBx2jy1xJRrIx5XEO91k6UYCD8Hr27sJZWLKojDMksJqvoft1pvzmzU3ErWsLUsF+Z3xj
	hkF9BPXnHuwlAIg4XbjP8V7L8hNcxX1JUkmhuCj5NqTSu4/xFkQH5sBvG0u81zMdioz1w==
X-Google-Smtp-Source: AGHT+IG6x7TKsUXj3KNtvBJi28N3SPu+7OrwOmTZbCRv6Zs3ASMjrBAiIU9+/w94vT2g2n/bhHHtuQObAHsd0eFiQw8=
X-Received: by 2002:a05:622a:4d9b:b0:4ed:698c:ef58 with SMTP id
 d75a77b69052e-4ffa77ba942mr34208171cf.41.1767712918964; Tue, 06 Jan 2026
 07:21:58 -0800 (PST)
MIME-Version: 1.0
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com> <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <616c2e51-ff69-4ef9-9637-41f3ff8691dd@kernel.org> <CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
 <238ef4ab-7ea3-442a-a344-a683dd64f818@kernel.org>
In-Reply-To: <238ef4ab-7ea3-442a-a344-a683dd64f818@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 6 Jan 2026 16:21:47 +0100
X-Gm-Features: AQt7F2oAK8j14O2kOinzrAvBRjc34kIOHPAKtgLXconX1Vvn5FAQInffYN1YFNw
Message-ID: <CAJfpegvUP5MK-xB2=djmGo4iYzmsn9LLWV3ZJXFbyyft_LsA_Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, 
	carnil@debian.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2071E20016
X-Stat-Signature: rqokgeqnorkxt1zkaxpcznjizzniwmxa
X-HE-Tag: 1767712919-348711
X-HE-Meta: U2FsdGVkX1+FCk2MfQdPs/RwsQ/JC2YedeEglazzu7yrB+Jj323eMvutwBE1GR+lSjU5/9KBbEL8/NCpz0PM2RFg9ZEWr2rIwfuCnp0jQWX5/G8pRNuf7hSEVbkVCDb98nyyoM4oLZK9B0jDb5L++q2aWt/3jW2OMyXaE5crlCCx6C+4oit5OvwueQDI8fLhx9Ur2GugQk4Vt2jZnbDnAEXur8zpvWFrdFi5+yqDNOzkDSend8TovwB85tqUwlCmtYZDZvh/cfXTmhR4KdDHKXHyrWqpMMURi0/b+jp+gkgMPk686scPj1AHvCmXoidaYiY/OKx9y70b2dkdcLOT4RJg+jeYYFh184ebAjPZqGZ1qtRwJIG9LMvbgeWhXI1vVdFy9dU4wDk44uX80KahCdhyzXilszHdh6QOj6XMrzxZzl9ASI1LDtFC36JvEbc22sNJ2hL2zCnSSaRraAJ8AhcO7vzNafPpXPg78jEF2dMwpapXEtEj5DxmvLXFU+h30H3P4fpRYPm52Jxe58bkMiCjqj3nJhHkfhQolyyFxII02un1XxDWtcfQSFqb40QFeuRgb9wtmVrkeh7HUs67Anotgr04mZ8C16RSVYhpYKjCyXt72ComNpvL7MYZVfCobPWYATytBC1/r/4BlgrBQ62BoQVPIohITR9g0LDUyrBz+TBjahSFqWPsNLGWABPacbuLZwRhsdp+toatKSNOML2kknZ4NGTii0WOnur/+6fVZcH+hE/KOZs9kbcSwIrwxUKFBIbk1W3e1QmyIeFl2Xb874OJB6SwzUMl9C6gCwB3vAlXHvZEZ+y92lOJal8WI6wiKnCvB65VqXWGi+ZJStpTe4eyDh4OXX7u0eghwsdzkRaN6NyJ2nEf0wHw9+q8o+vn2PtDvJBs5Jtaz9UCT1Ncd+k+GABze1QGm66L+V+RXbKE9D8brRQOXKB3CJ4x21Lomcqr6Vuz2bW692R
 ko4sD+T2
 X3PQnoIfDU3BrfUFD/yLL8YGIOkKayqM9pOPgELaSFbSn15p3ydIceiS1HQT40ikQM7lp2G+8jg55w6XVcL3CyhZewA0Zy6ITFPKEIINnMNI0a9YkZByY94zlaQ7jFAw/qWrwNP4GTX/R1dz7bH8hw7SWGgpydhgeDhpn6D6TbnHEenvEVz6WhWWtEWEXvk+1Xy+75aOEBdzUpWWJG3FgP6QJiRPVVOwkgaGiClDdEyGxZTn2cuF46t1Xgo3Xoph2/DKW8ip4upZaWMQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 at 15:34, David Hildenbrand (Red Hat)
<david@kernel.org> wrote:

> I don't recall all the details, but I think that we might end up holding
> the folio lock forever while the fuse user space daemon is supposed to
> fill the page with data; anybody trying to lock the folio would
> similarly deadlock.

Right.

> Maybe only compaction/migration is affected by that, hard to tell.

Can't imagine anything beyond actual I/O and folio logistics
(reclaim/compaction) that would want to touch the page lock.

I/O has the right to wait forever on the folio if the server is stuck,
that doesn't count as a deadlock.

The logistics functions are careful to use folio_trylock(), but they
could give a hint to fuse via a callback that they'd like to have this
particular folio.  In that case fuse would be free to cancel the read
and let the whole thing be retried with a new folio.

What we really need is a failing test case, the rest should be easy ;-)

> I'm not sure about temp buffers. During early discussions there were
> ideas about canceling writeback and instead marking the folio dirty
> again. I assume there is a non-trivial solution space left unexplored
> for now.

That might work combined with the suggested callback to fix the
compaction issue.

But I don't see how it would be a generic replacement for the tmp page code.

Thanks,
Miklos

