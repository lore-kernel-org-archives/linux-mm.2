Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77D49CCF9E5
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 04:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7DCB8E0121; Thu, 30 Oct 2025 00:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E048E0112; Thu, 30 Oct 2025 00:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6E78E0121; Thu, 30 Oct 2025 00:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5818E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:01:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30BD6C0A3D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:01:57 +0000 (UTC)
X-FDA: 84053432274.17.018159F
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5A28580003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:01:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=famcApw1;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761796915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvJh8DPPRrrqi4II6H64eXLOtWkRl/bvQSKOoolKeXQ=;
	b=pAjZ6SMoeWgbcVstGiq56whOCrxOnBGbn2EUrVyCCBDm/76YS+sHH9OxhbQOIuWEDUTujE
	jdzEvP61ZiAmqqTIyj1wiJxZO0obhS3Nf28feo1BiJKRpe69qmmifujtqxyEyZ3YJfTV92
	yjJSFpZUEHU5c1kqmjHQYJQm9u4nCCA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=famcApw1;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761796915; a=rsa-sha256;
	cv=none;
	b=2lFxDDb53ziDfNBv2U3CXGDNeEhOlx+Z0Cbtskz7CLuXLwhiu9jMgJUCeKVBU6garR8yKp
	unNM6aOoB3/C5p4751rj2qPiY2uLWcX9vsGxm9FLdQrZaohXzpNOOqD0OypD5IAR/JBuUR
	QJe3apVyboom6zyHxKTBQeCvxY5B898=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8a3eac7ca30so43573785a.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761796914; x=1762401714; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XvJh8DPPRrrqi4II6H64eXLOtWkRl/bvQSKOoolKeXQ=;
        b=famcApw14bEtJyvg9Dn1MnAxuHpgrMktKHGKMl4pOzE0lA7Nxgi8KfTGX9eGrEIogX
         i6gVA0R/1lDoLXBOQgSdRxvXopwj1wzMbWEQ6vFjhpR2mJd4NvqB7nUvaGMyYFpjunjr
         RiksmYGV07txzS1wEQcjWy8wBFGs2gR7bYYHxV6M4pdhVJTFGrDNysAaeAFKtOVHe4HF
         KCJkkVXFD5YFL0pfnrb1GADd6F1gSxr8DkYNGV23P8v+3mBP2vL/6QCOzhjvK+Wt/oJ0
         l5xADmDewXNe0vUlWcIS5cdam7uCmHnvBp67gA+NNEnYPURb2ZOthMdTYaTm3IntKUti
         3/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761796914; x=1762401714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XvJh8DPPRrrqi4II6H64eXLOtWkRl/bvQSKOoolKeXQ=;
        b=UHEr2ZJlulGoSBra0YqlqWpucmQo8KUbEYzbGsxH5UK4vNPn8ZRrNLyjhu/AGotb1i
         ELBXu9G4q3eD8dB1wg/CRt0PC37C4NXsQLUEU+pzNMyfUUlVQ5LR/QmfGveADp3Cn/am
         UMcRLhFQU+2Q1dWfAXfKBOvzbLEJUKB8nvl7eIIN7uoIvQ9+qKXi5DhWG/KJZvf3KaGn
         vYJI1YTWbh2GMhzYa6wdFmvccMVaq3hUpqAintOg8fh3NHN4Ct7jIv3+sJL72AJ6OuVL
         Cj7xqChWg2sVELfVInnS528/PpX7Y8WtRA6ukHGRp2ha1ayYyipXhkT0Jpfhub1/I3Wk
         tACg==
X-Forwarded-Encrypted: i=1; AJvYcCXZ5TGLziKLJNShAcgx7kFMlsixZkUnHzNzzcYx8v++TDBePt+8+EB68v4JlyaUwlRYxOXg8fDQIQ==@kvack.org
X-Gm-Message-State: AOJu0YyaAGmVeFcDRSJSeCWp985K/JGat469ap2ginN/b1jES7puVRFs
	yRLd/4/YRfRWGKoEl+1C7Lc4XzrKOkBVTA79kHeAOzebEGPP4/AHVN9AgULFIk5kAgQ5u/+OjOF
	NLtcoBDIkm29jIr4nBqx6MFa4ZHnD6Xs=
X-Gm-Gg: ASbGncv7wL9KQuvcIYCzOdhYrS/D5SvEl0zcXAv+7lYqkIId4TIyGbNuhlLuXLI2m4e
	8gEM1qMsSldwEKe+9R+oAET7FR5adpbe6EfwTjQHvlUjWmnA9p5E5+sC/xRMOk733N/RbI3KMjU
	CFCiwgCRrzAFpqu60kTe42MvthnMHQRC2Fa06cJugqDtgLK3WjTm9awd3PL1+pg7qy5UzvHy7hv
	AOKcyZhnIdjW6omKeGwPOPQI4Zimml+D8IJPBoFhoqOOimsN9dsKfMhjFPRyNPYD+IXW1Wd+sVB
	/Y06/d3keCRNqxaF
X-Google-Smtp-Source: AGHT+IF48vQzRiKqweTZJJggP+JY0guU0TB/X2xEN3pnwgukLV9EXGhO/3BkSXX3dJXXucHnKD2G70eNio4983qJvIM=
X-Received: by 2002:a05:620a:190a:b0:85e:24c3:a607 with SMTP id
 af79cd13be357-8aa2c658c8dmr223728585a.29.1761796914185; Wed, 29 Oct 2025
 21:01:54 -0700 (PDT)
MIME-Version: 1.0
References: <20251030014020.475659-1-ziy@nvidia.com> <20251030014020.475659-4-ziy@nvidia.com>
In-Reply-To: <20251030014020.475659-4-ziy@nvidia.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 30 Oct 2025 12:01:42 +0800
X-Gm-Features: AWmQ_bkyqj9_N4hgF69gIn9WT1YpTuvv0DmQVRfDzno9ZsTJybifNix7pDy5cOY
Message-ID: <CAGsJ_4zgpMqVHix3faFHRarP4+o4cuPbyWd_oT0Ym2i40i1E7w@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm/huge_memory: fix kernel-doc comments for
 folio_split() and related.
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com, 
	kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org, 
	nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A28580003
X-Stat-Signature: b79r1efqjuybayd67h9dns3pbqwoytyy
X-Rspam-User: 
X-HE-Tag: 1761796915-59972
X-HE-Meta: U2FsdGVkX1+9K8tozD24zgcUqpW5/8uId/P86dVKi3d5Uhc9/pL64poZzOy9YPHEszWht4zvGnFaQVRou7b8USVtTuPflyJOKWq3C5FAjeV5BQLe+tvywHStFdiYTXyPRm6blqH/16FwwbfjzrzoWV+Kta0889sm2ZYzM4+xmrXcQ3oEQCy8sZ8PvU+jTDIipuna0uXu4Vz9ZgNTdPbsXczbM0PZZ1pleD5o3hrDOr2/R1+XDgkkmms2kImMumvBoNnz+M+jFNINWmgdvkoRMJqRF8ngqItfWm8d7TU9E2R9ileCuIciwsznDP+jWFKSI7P7A3JnrG2FEnzzJpPvM5xyWqPJ9VH7u1WPRptvqat9zIQW6RYv8rohIyX4cCv5Aa/NiUbjii8OiDQYGhcHYkcUor+bAPZj4OPCwGHpe7ih5v1Hk0VmMLBdyqL51URok6tStcpnt4WILm/vOQH5l0XHkvrphaAwVoVbjmCHcPfCvv4+3EXn2YQNlNpcwtWGtkOPWGps0i9X574krGv5gaTHToin0nPzU81GfOwOOfhUcnz53UgyJBkX1B/kEIDZgXGxvD393wADeXgkSZfGp8H63hOg9FgqZkQU1MUNJkHKUTx+RaGgQGEySdg9RfSqQOHStfhkTvePUoN3KvGfYvI/WUKiJYgh2ERjZPWBdt+Urbq7BEEQDUdL15+HtYDK+Eb5ItWjRLmuP9troUrX5c9/nkM2sSYnOkfZCN3FjbTDZYB0uFuFKFygGYpLDUGoOOKx3dwBd0SqM1OuUZPsCkwDT+PvSNBOJGadQq2Z58ophcfSwkfc9PH/vswx5aTD3DPoiRptTkuwkBlZqPMxpCzLIymLMkxr2KNU76nK0uDlqQy9GeEUehW2vsjwaH+97ElmZBpU0tZw83SFSaI6gbnzoyaisefR+ehBbePOwCyqqCznGvvsX9sfPy1kmIaaOI78vu5CEQ0EIWyU2dV
 79eeJVgV
 I15pghjG5QhfuK0L49rpCNv9RyWX7CQeuxH8tZYqdt7WSkjhv4DAPXdwBAGMBqSwb7dmpnJxA0sd03IY/EWciVLk1fY32oKwgPDMM6G41ze7fUoCYjP5B5MJSoHuBjGmgcQpM9vy+m9W3XoRkw1zgEWtBw3Bg6zE1UR0pG4PJGRmmmIwKrM4p7ESaAeEop/UT2WnfuC64NfMR42HW1VxE6EFb8zZ5aWmA1m8xUcIulvPnkh/KIUM/lRSO5eWDcJ9wiP2rJDt8qQ3jcqFCLsy/RBmfwLq8ofIANpWvm2mNe1EFNJO0AWdFqK5jgZrCAYsrmmj39ZyJVTNIG84pku2cWezC4ca1hCCmtX80g3fvE32rfijStgU25DYUOHRlFynb03bar/CdQ5uR16OzED8cqxXUegMF3pLEGmykpThdbRPwEd5I1JsaozAc5NrMaNS6zi1vW1k9LHLLHekSOrIJvWIyNYjnYcindwJUcR0OPCyrVNuPj/VZduimkv+aqcQdmGj5khqr2oeZHnCYl1CMvklFi9wDn7zSAwPnp3nKgnYS756fS4c8Nh3kccSxT6S2WKQd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 9:40=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> try_folio_split_to_order(), folio_split, __folio_split(), and
> __split_unmapped_folio() do not have correct kernel-doc comment format.
> Fix them.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

