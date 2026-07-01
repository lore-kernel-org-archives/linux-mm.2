Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D10A3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7EA46B00A6; Wed,  1 Jul 2026 06:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2FAD6B00A9; Wed,  1 Jul 2026 06:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8EC6B00AB; Wed,  1 Jul 2026 06:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0496B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:30:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0266167FC5
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:30:34 +0000 (UTC)
X-FDA: 84939838788.18.97FD5CF
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1116C180014
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:30:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qdDWMyRJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782901833;
	b=6YYHNDtb3swXsdfNFM8w67TD++lMN8iWU4Yux0akVeZvhmjvCoY8hbNhCII6reDjU9YJRf
	bnF+OS6C8JlEHhcw3wEwsr7VfdYmV4czHv0WpCzlxH/za2PYGxenxBtIReAnLWejoTjiXZ
	QfcJvcKVtirZ802DpWeDsrIP5ZWJkhs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782901833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xA5qwJQ5ZOB9PrEYWpKUaKUpyF3b4ancjvRigQCLEfE=;
	b=eI0xRx3sRiiHiZgLtlWsC19VG38RRsMMGDxksZvxCnFQujQZSxBa6UOgyZbOl/KLtpomrc
	5GW3y9aMp2IyF0jccGaQj5Ds+NN6rsvN/GOQKctuO66YJZFMSDLmcc8x1prHrpbNe60SQS
	OIGxz+JUpImvRqsIdHfdiRMQXsh88vs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qdDWMyRJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aeb8c19017so594668e87.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 03:30:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782901831; cv=none;
        d=google.com; s=arc-20260327;
        b=BJv4trkKFNR1lodKN4U0TuUEsRulCmSdXPn1Q0U13KZVlxbiKa9jtVy0yodTIM56o6
         a9UVRAGIcLfTKh5WLlR1uLREudPWSAR28w7dVglOsfm1ceuGo+vM5AmvFmoLweGnpcP9
         rz+mb4LRwgpptEko5dxUSo/IoN60On3uUFWXTMDUWmTIBZOIgeiO3cQ5LSIG20xCujE+
         vvG77qEn33Op2kJlh9CVtInZJ+0XurCh0G1A4TD0G25uNnZJrIEvCRE06oOJbapjAQrk
         D6g4QOf/MZnTJ0z23OrpflBKcbtONpJZ4sfXmVrFTORS9j7I5SUZwIKWgEZq423szoJq
         JWYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xA5qwJQ5ZOB9PrEYWpKUaKUpyF3b4ancjvRigQCLEfE=;
        fh=hWvtUWx9Yn62o2GpGjLMweFI2JRRJlp72un7AlZPdU8=;
        b=DV6p05gn884IkhGrTMSxBszPcIklWByuR5tfe95jzDj2K1cp+kyA9BeBy7t8jsX+Mp
         W2eOf4ZAvSUr5LRi+cnNDNI4axGr91SZjQzYNjvCIgFAU/o5pBSjwamFe7+sSPYWi0f2
         knWX748VPRHjiMSm/p50L33W+RuUUGeNwlDePX+rYLLFjqlPVAbI2LCslQVEUJs5zTSP
         KZqsVn/807A6XzBI8wzzMyWnkfUWp/QmU3G8uYCtQ7DvuKLVPdipVDMRbNpymzL7Ff4z
         U10IeLwVtX0RDAFPDAhxiI3TjcGl5SHKCm8oVhidfvXrsbnFbUBhaIBpV3BgypNIQf0u
         X/tg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782901831; x=1783506631; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xA5qwJQ5ZOB9PrEYWpKUaKUpyF3b4ancjvRigQCLEfE=;
        b=qdDWMyRJsJIDE+cbjaeXvqPvobNY6q6oRxwx78f9XQ1Y+f6VXEH+op3TrCG4+9ts8m
         QCG/w5kz89pHBWQqgNTtXPfH5Aiiu4w3drYnfZHElQ/9rPgt+eogN9WiPwF5IsxM2hkO
         bXwuZkGZ954OHPI4nkRwTCp/i1scGvsx2dU+Z77rVONWL19kPcdNGyaiOvqrfHTTgljh
         +9hIW9hH+IAxcKzItDLDtYrF3oSSndkk+g7H1jBHjzf/BEYyNv6eMbYs7wI3VoT7ippH
         5jri4KYa+qIQtjrzdqhLgEXz9cwDVGvqg+3BtiQg50ixkI0xtVmdKqL10fD2O8juUNPe
         qHyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782901831; x=1783506631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xA5qwJQ5ZOB9PrEYWpKUaKUpyF3b4ancjvRigQCLEfE=;
        b=dINlvaKN3HYKwskqIOup+F/i6fVV2PyhnfjIN1beo4vtmIftmA0iKNywKvYnGl9Qb3
         WhSmLjAR+3noa8zAs2tKynSdK96/0IDR7oqNfIWlNvjF+jpPvq88Gaz/eEjT+7FLpToY
         RHkyHgeGDiVK0oXe1zfEWWZl+lQS4mazXoQvr1himx71caeCiX1jk2D20cvxM5DW5i6I
         e72R/aktFkRdXxqZjQQS13WtR8CnldRzUXr9/NI3S/i1iRsFGIfBqXDzGPlyk3OgKdLu
         CA3ckL1LOZrmcIHTEPjmqHy0vdlvxZMZhSvOSubismc46rb/5OWD3rdihz+gjHx5cFUQ
         6XqA==
X-Forwarded-Encrypted: i=1; AHgh+Rq7BhBVWMkimSH/XhMcipc7qOpWTfm4hOFrNWXlrPAReBvsIu2alspTzgF3IxImKdbCfvN8sBGzrQ==@kvack.org
X-Gm-Message-State: AOJu0YycmmhnYsUBKpVMpW4meCE29ULOmFSBbdp+3XhUIBV9p2MIWwyL
	mhtxM1eCT4R8VynLgusenWS/L7OsvqdWj7lf6YC/madjLkkFgyIcKpPFzIsJebSzEeRTej2Co0E
	nMHSdJRPrPgIHcLnceD7PXfs81JRc+Xg=
X-Gm-Gg: AfdE7cnR6iRErdJRl++9DqwCCX9EsFpf+eLWBVtXfFf4qLjl88XaXArBVElS5YBb+p9
	+df69zKgKQ4ZHglSIIIT4udwpt+wR7cRf9wL2iWK1tDWbosOEVekncwm46eBgFMQdww+yzSqZYW
	x/iVk5jZG3KWzPCgJOB46JZk7RZyPi3P0+NVj83cLVJXkQ8CpyQYS03xXj52XbE+VQK/UTLI2WJ
	MlgsxD5ZcxEL9ubJY7kncKmeKlRZTeLrZoORTM0VJECU/DjBJ2T/slz/i+hhLT7ZPM9J6ISsAJY
	g7r8aSfRkDg3C7EWHJyASA4r4Q==
X-Received: by 2002:a05:6512:630f:b0:5ae:b270:505e with SMTP id
 2adb3069b0e04-5aec67973e3mr225140e87.1.1782901830996; Wed, 01 Jul 2026
 03:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
 <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-2-d4f648963382@gmail.com> <akQOmJOy1TYrhlq5@casper.infradead.org>
In-Reply-To: <akQOmJOy1TYrhlq5@casper.infradead.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 1 Jul 2026 18:30:18 +0800
X-Gm-Features: AVVi8CdEKckBCl7bwZrAts0Mp322Jz5dOoJByytnqbXcKin9G8KQmplLTfNe_BE
Message-ID: <CAJxJ_jhaxah3WzjO6+hF9XFY_ffPjHRw_RjoOQFTY+3ZAs7qcA@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] mm: rename swap.c to folio.c
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1116C180014
X-Rspam-User: 
X-Stat-Signature: 18wxwtodezikod3cme4961cmdxhr17t9
X-HE-Tag: 1782901832-859517
X-HE-Meta: U2FsdGVkX18WCfCEQjswUGCxBSmnhuy6fYn1vuvmeTQ78vofGtJopuk9CWpOgfff7H0kS8AOEj46ZWDo5jovHZbBPJHBXsZ3Ft1QY6RXXdUQe/mT4yzoGUWXDLyIQbhjUn1LAQdI+zduXxuYAdHB2r+drqCO8vrJ5f+WYqHSTcP+TKa/pWdIcYp1RH8XH/tCEVAn/lJFk9FLTXHXVWwSSlmOdYLxNKYtWx1nBgy0qZ4BCSTQWYv5kogK0da6lXVoddUFWmWoboH+nOcKb86w9hhYcF23keGBvHT0cBpDuko6EotkWLiAcldKIgLavY7Yj+/LUvqwnNuTqFkdSKmjN01HTNuJXwMtB9kiodT2vLSL/MWBe+iib6oi02TjU2qHuu0st11WmHY3q/vVwd8NrI1JjZaz+Wlim+OK3AWDK17gi9qBMMVEPfzfBT+8PTM7QtVR1BlGCmb5GN391JX4Q0n9qwha3LODtc6sycvItIJ4ChS/J4CgJKEC2PjpZtdXd2n0/8cWeSHMEOhO0FC/htHn4BftxyEf0VdvHT3MtplV0xWfgj8fvZvKUhH1FODXSlAOVw/esNTQt/gbb4I2d0Xm4OHTevd5+FSRhpI6dLSzO/lsVHrto+USs6mZ825mCbh3FPPzN2i80DEDa//mEqCzt2X+uuNdN06MGKechgi2ZvSO15RTNCqOJDX/u0FP/pROgPJ5pJ/ODiAFjgScnHjFyuo2agyVSaBRXF/WXeMOR3PSjYCOxEIJeNYra1n/Cc/xNHkiG2rYpNM3bZKG7mdd7ec1XYX+3bQ5wijsOr8cD6Q/olQvoiWikP0YChNAQoKQZoguzqSTEYetx2uJSJNgivdF5733zvpoDqBxDcfQQYJIQ7T2lcVd8ggiOSEdpiE8nLxpHAJ6OnhRhdT0mq9REDWeKwB9XzGsJMmU5zGfydsLW3G7OVV8pb4ZiyMhWB+BlHz2JAoyItgBRPg
 J54ZXZD+
 PMFYfbB1EuzDbfyW8/WAgIUCuuZ/nTQeOda6IG5fqxVpWMJV+nsPfDsaWrN4AjVNeB8W8mu3JkacvnMCEjqnP/LBnxfhUhYi0+5FY81dJPWcL97EZ6lOMLt8t3hsoeP/VLn4DqbVDqTBhPQ/KR1ncbQ19VYTBAxzR03Mq1cwD2Cd7q856yW68EiDz6/tNXFSrjqF3mvaDDrITjAIxBLykJYGJFdg6JPnqzG22w1Y5A/mSfPUYMN+iKTYaB2DWQxquHV/zIWHiz3pMp+MERYtLu9vOimKRqXVLCUvmOThLMFFxuEgdTtNLWcHr1aPtS3ivyCtbjS5tqr0vA6vGZ2FE2FDVV0gNu0yGPztKiLfsCAuC00P2RwJub2Ev7vozjlETMVW5LjwyGOpIevTcNNRRbTjQcDf18fLpPs1cMsccxI+mog4OSYqKBPDs2no+JWDDRcU3C4/DSKifN5otQLIUVazOf9rLcMH4D2N8HI3Gff0n2xo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026 at 2:44=E2=80=AFAM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Wed, Jul 01, 2026 at 12:27:33AM +0800, Jianyue Wu wrote:
> > @@ -17057,7 +17057,6 @@ F:    include/linux/swap.h
> >  F:   include/linux/swapfile.h
> >  F:   include/linux/swapops.h
> >  F:   mm/page_io.c
> > -F:   mm/swap.c
> >  F:   mm/swap.h
> >  F:   mm/swap_table.h
> >  F:   mm/swap_state.c
>
> I would argue that folio.c is now not part of the "MEMORY MANAGEMENT -
> SWAP" responsibility.  Agree that it's part of the LRU maintainership
> still.
>

Hello Matthew,

Thanks. Agreed. mm/folio.c is LRU-only now, so it stays under MGLRU and
not under SWAP.

