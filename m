Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F357C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039716B00BF; Mon,  3 Aug 2026 09:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004486B00C0; Mon,  3 Aug 2026 09:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF47C6B00D0; Mon,  3 Aug 2026 09:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC6F96B00BF
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:52:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 516E21A068D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:14:33 +0000 (UTC)
X-FDA: 85059548826.14.FE1FDAC
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6520140014
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:14:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="B4phoP/O";
	spf=pass (imf17.hostedemail.com: domain of mclapinski@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785752071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhfNGyoj6gWauQ3L4lUW323UQobqUhOK0WUh6mOtMxg=;
	b=BRCqDtkQfQtG2iGmbQH7fFqVYBb/Q6my4winV96/NTGkInHi/aJ6oierkIBnFQLKnAwc9W
	ggHwI27o7pMqJtQUKfuUBNGx3Gu8YhLc5eiJtc6DvdJS4lZTRHgCjTPsl9WQ+tovLYHUc5
	6C3S9LN+oZHmREAcSsALQo5G2vP5svY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785752071;
	b=wrtM8Vq7X9zoBjroP/F44iVXYN0EcPvrSOHcj1nB1lhvgSd7G+GKzQfuqLY0smM/Q2kK0o
	KnY/gwrJGSSabo4Xm2Q+JJlFnNvxHtsRnPlRf29ABQ77jHPolDG24oCmWUK9FIvvZE46ub
	n/L9/cYA1DQz1baWmVspCGQLiXn5P/Q=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="B4phoP/O";
	spf=pass (imf17.hostedemail.com: domain of mclapinski@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69a19eb2e6dso11545a12.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 03:14:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785752070; cv=none;
        d=google.com; s=arc-20260327;
        b=oEqZs54All82Tg5sPcLavpMb+8BHw+zpJ8Z6tcmimdkUeJ5ESuJDzoEjK1P7OOlLhr
         9+jQBSQ0V6muwGMvMBfpEntq2ZFP/rCYkbo/7g2koruoomkAGdvFlRsHlsZvD4Du/Xao
         MvZsbnmiJgHRPeBIYNKlDf1usm2ddm6+YWQo5g1xkh+XVi3llM4yzptysEw7ltqQhzkq
         Ke+D3XxUmi1NhPBx+39SDBJusnuikHzp42dKbhR7h13cmgsq9ja/bDjALW1lGa3bDGf8
         RDNN5InYvEJ2D0HaWI3IVq8KnVLvlJ5SxUHWJeeuzkQ7VboI5vF6U/+Jh+VPpWZnex/0
         GEyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JhfNGyoj6gWauQ3L4lUW323UQobqUhOK0WUh6mOtMxg=;
        fh=JQOxCr24DgrBQ4I4m37xxf2L0IjTK5tyCd+CvTsF5Nc=;
        b=GBvp/sjnRLuDsvTVZHq6xkPhuyJBBShTwexV5QrZ7uhGNVAIfsx1DI50cL0a/UotwW
         w1x92Cr4ujy0r3bsiQnL2Mca3qUEtqycFVlQriQ7ziHUYHdIgUxdetVO/lfJtCcgZxi8
         Etu1Ihrra0iMMTdNuNzqfwFDaO9iuViNplrlcqrzcdomPs2iYBo41Mkqz7kywi6CVxQj
         cqWZRzpZk+XpRr8aJKh80gireeYWYl36crbo/+n4lw6vodLmDTJEZPcBWGwGGvuvkx3T
         k92vihhgSFQ29PuQvadIW3Og4pXbznyv7ndB9Ab/a4lO+XIme7m/xXSvWWMIKrSi9PHs
         e9YA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785752070; x=1786356870; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JhfNGyoj6gWauQ3L4lUW323UQobqUhOK0WUh6mOtMxg=;
        b=B4phoP/OotrsS21y5ysUHNR735BaUmTEXXU7fGYPZzXzi+vAl0hrtEsR7WFcOGwx/A
         PS2RyvHFX0n5CvHQrJwO2RPeo2BpmTsrbCMbci5sMfXEH4RiXKfj1hsRwjvrxcF49nuN
         8ggrnvQjsCkK648zGS67JBLKyhKGdeFUyU2x8bsOftYvNDFWyC7zB7MQhL8TfUQikGKz
         SvBqhjn2ZtzknatMDwb5rXsa97na79LVNhMwMzm/QechF8zSrcsCPZFoLzparc/FhSUn
         p0MnsyXFLXP0cMdP0UONVrUYGqSdNZQuB1Le9A9puzDReXw6hLEXZSbP99la13KevkE0
         XJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785752070; x=1786356870;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JhfNGyoj6gWauQ3L4lUW323UQobqUhOK0WUh6mOtMxg=;
        b=KtYsIZ09gxMJkugzy9OkaIjGjwBtismhQZUZNWXflPyDBB9YgTP8ot+kxVtUQMJELx
         +IzyX2tPsQBdfE9nhdMyK9/Dzw1slwGA1ZzcwtrdsWm/l7NdgPNl0j2WqOXtlIMEgL1M
         exJhxx7Ldwr/7dWxHE+9rpEK6wfniT6f1Tw1osHgxq/fWEwB2vs932/btn/kJ3T3si0K
         9lDde+FWypR+taB5upaF4rJGylijiA3dwwCjg4/fMH68Wy5n8HjoKyaz1z3pLzLv5gdm
         OcX2K9HTp7YU+zInUU+AFFwxwpI5FvifyZpBIJiyxzjzzvyRAwBfjj8RIBMjZBFAge0R
         B0JA==
X-Forwarded-Encrypted: i=1; AHgh+RrBibxCcLQ+Vt3HP0wY9Vwl423hLBlIChT7dGLvf4P6EJIL6m3a2H3hgoiPeRUsx4UEjjuRFeflRQ==@kvack.org
X-Gm-Message-State: AOJu0YyCNFc5w3y73Ei0nfs25yW0mVLH14wx7OSdnNohOuOanXGM/uW2
	sRX/bTKG7S6q4S9oI33YgA3rsK0GAZT65mUx+8W1W9o24C9rt1C8L554/AUSac5t6mM8XYJ35Wl
	d0boJb+++SqPDhGb1PdB38xN7fIOfwC5XRMQFvTfq
X-Gm-Gg: AR+sD116+TyK6H999W//VgSdzVRDdiO2KqJ3iHk18/6ROUmdWlyxJMHa0wgGXQKRheF
	eN8SN8s8ZKTzcgaWLaJC97VrvRcQDmok/BzHgxxDXXq7St3xoxRihbKT6qlrlZkd5v8akNY2Uln
	2l6Pp/9mNQDNfIbVJ3A61FR6QGY/42pNUDTvi5m4ShkOU7glIQTve7zGAWvPwmroTpZdbarY0fR
	u5AcV+FoCYZlQVA00uOUbcx3Wl7QPC+8oi8vHOK3mk8e02DOEqFp0pghpu16FC4dFNwK8mOuakb
	F22YNuTgQQgWhSU/xqf0/SG163AMTzQ8RkoWqR/w/O2voOp5462qcF3isYAOaaEW8/em/8UGYYG
	UHJbSpgWL
X-Received: by 2002:aa7:ce14:0:b0:68a:e1ba:9cc0 with SMTP id
 4fb4d7f45d1cf-6a0a84fb3b5mr117552a12.8.1785752069382; Mon, 03 Aug 2026
 03:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260717134028.2880508-1-mclapinski@google.com> <178453346331.1178000.18393988680596713513.b4-ty@b4>
In-Reply-To: <178453346331.1178000.18393988680596713513.b4-ty@b4>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Mon, 3 Aug 2026 12:14:18 +0200
X-Gm-Features: AUfX_mxV17yZnjq8GhJvKqca064Dy4Pslz3w1Zu1qT_JOmfoWenIfP3JTE0c8GI
Message-ID: <CAAi7L5dE=oROWR0mTknPyjnL-XRXuCUsfHSiGh7yUqWCSzE5PQ@mail.gmail.com>
Subject: Re: [PATCH v2] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Evangelos Petrongonas <epetron@amazon.de>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6520140014
X-Stat-Signature: rm18an3tzz3zc41d1xrsxwbg91tajsjh
X-Rspam-User: 
X-HE-Tag: 1785752071-178162
X-HE-Meta: U2FsdGVkX19NblPa2A+OtrbjK0ZJ5RhOVHV9I2kL8I+A2A+WeYS+qdbN/UCgg9uSQt8r0VOzt12M7jLcjeQ7GFKIyzbPr3LIa13BqHEcJR75riPNv3CJQXccxHDxPK984972HTvgEvfpksD2ySm4bMe7TvOs2N3MC7OGygk6ehI4UaYUlCLsGLuQTWy1Rm6Q2RxrB4Y8UTSh4/wj9Y+HHoDl9Z+sLF2T8IZjKgZDoK4GXNXvgQ+K7IpM2/iMHQdCpI5sKgm36sY5WDfvpWjrMFhUOp03bWYxlzguC5Jo5NuKaO1qvzv4066drTAjlGv4wL/IJzprOyMmTvJdUvYvdWfS0wnRNcRm5qHItisVT3dgVavPX/JcE81BNpjUij1ofsLLBiz6hZpya7vg1dfgiHRDB1fWv943NgKLGT7J5IYiAKqQyBzWUROLuoVGunmGE3tzaMTKgMmOlWdPW0UK8UF/oBVWWWJlv0gJNscEgY2UpvSR93Ven/yGdZwRzCiCokYkNKV6tz4GRDsVcHrMCwqOYNOT0mk5Hagc/xYZN5Uv9tl+Rn1pn+D7ezmNGBgJvuLbtEorhbtUsZWXVr/ni60Fe19IxGyxY8oh1/B0K+HmSP3pg+zCebZCU5c0kO9796MXQL4Uf41DP7V2U8WZ6mfxoKmu15wBsIZ+ya22vfR1bmi6HZnW1iKrXdx+z9mQT1GAKT0J3DkIWBMyidsYwnI+Y5nnzolXO7l2MRdJHGaX5Nz5LRpNbGsVIT97FqIkgwTvPmUNCK8VOe5o3ulX11Z7He7d1qzn5Mo7ZZ9wctqf3d3N++Y5ScbqDQ/3SLUCbmw8gLjEK9Z/aUWHKovy0xP8+kYM87Bzaut6ZQ3UcoIOimViT4l9Db6Y08eIzYXTW60ZkZA3OeIZevXHo0KXOzv6a6mr/ImrctRDDb1Q/UnBNIXIMtMP0v3ClmDVYLh8XKTFaQ5vd7JXH+MprAW
 ywkXcT0C
 3bn2z09YVJBccReOKauXz58gX5h38j1/cuKn5sh/H07o/H5CDjC58v7Nmpd3YsmoistmAiTei1GXt4fTPfTBGBfGrEv1DjAAiW9OCjBfRJ92hqTaa/CxYbxcMQ2HnTa4yTyoDy3JAj76tGBPBaxjCWkcp8LFTdbGST1XcNFMrSP7QzLCSnbocbHUkP5pvR2ph9dFQ2lX/A4sCijpFlcyw28mJKWl82aGkHH2HJNHplnWV3QF0PKXhlfTamyCDmMy8xaCcZn3JHCZWPXFOci6/gaw4If/WnjyZt4PmkaW10vvjwnmXGjjEqsyfA7PFQPGdRZ2Cw3cz3V0TyPJFDoFkBO2VVWyh1PTK9N4SyDw642XcEtP4MMDQwipPrsTdG1wB2gt8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 9:45=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Fri, 17 Jul 2026 15:40:28 +0200, Michal Clapinski wrote:
> > kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
>
> Applied to fixes branch of liveupdate/linux.git tree, thanks!
>
> [1/1] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
>       commit: c553c774c9715e1c92c48b342f30d60601693fb4
>
> tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
> branch: fixes

Hey,
I see that this change (merged 2 weeks ago) didn't make it into linux
rc6. Do we need to do something manually to get it into the nearest
release?

Thanks.

