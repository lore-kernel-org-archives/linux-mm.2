Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 799E3F364AF
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 20:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AAA66B0005; Thu,  9 Apr 2026 16:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95BB76B0089; Thu,  9 Apr 2026 16:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871156B008A; Thu,  9 Apr 2026 16:10:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 789976B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:10:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2567BC0BA4
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:10:07 +0000 (UTC)
X-FDA: 84640108854.30.527FCC8
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3CF9440014
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:10:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wUaCJDSz;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wUaCJDSz;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775765405; a=rsa-sha256;
	cv=pass;
	b=OGqWn2r7lR9reyYQFf+wOxsJDIBdoukQ9kRlT6tKHRgZFnBzaaIM8p/rzgNnerJ8qk9dRd
	JWrSBMS2YZC5LP9+upMgpiB+uL8gw+8dPnqUQ4t0ivc/LHGvmnngvrTxFd5N9CKhrjK+YG
	3V44RDEoC0oSsh3bXyPE4wByOHN+Pl0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775765405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ew9YJVqzCV0p3Lp1Qxmpt1qcifyX/ZWozjm6bnofDwU=;
	b=xK5O0G1jwIz39ZLW7JssYCrAjdFVmivYpYTX5eoLAvie4CevtjImXYvLxBnUDOkvNUBR7n
	Rv/o/KphgO8WtHTcbfblnyGea7yzNZmV1/ifS9bXO/c50OOpwWiUlO2ejh7zIYpCrGxBzw
	Q67h8Q1feYPa7EEXBKqgBZbFXgPpvCo=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50d8c7a393fso768701cf.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 13:10:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775765404; cv=none;
        d=google.com; s=arc-20240605;
        b=CWjbvYlE2+J63yGKJHckopoh3y/lSkjtwQ7GtEV1u0TCNmbFRku8QIq3Cp2QdOKhnY
         bsNpnEUCm4aW0CdcDTEmlqVSojw2INH3krDo+nWFGM0c9gOi0xZ3N4zqLAiisQVw7Fmw
         m96K6vIEHaouOYE/lz+lNwXyTb+vxliVz9OUoTrhcADYKJuwUy5fb8Q/goUyIhc4vQG8
         Hy1+H81VdFLAzO8HE+uijOKkc8uN5FDLefm0F7zh8T0+XZ4Aj/CslpTg3FKZvcmUA5iE
         KQXlHU7ur19nTXb8cJSapU2tSAnM/774KqXHX6Ka3VWSp/FEJe+5qmiCyTFO0Jj8HI5m
         Wdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ew9YJVqzCV0p3Lp1Qxmpt1qcifyX/ZWozjm6bnofDwU=;
        fh=DeqAMx2FAZKFNT7Df7gRwpkit9QRduMrUPtB00ectrY=;
        b=Ztw6xg5eniydMcCL+KbU8K4jWc5Whb4Q3/mtm8kipDsf6WPWcUFZtRS20lOC4ClChl
         aqP2yYhhQd904kHO8O7PwMzLZTZWv1A/vl8iZwarc9bZ0sd4odc3CUOPq4jSvF1Zv76l
         aBLw4mvbrPaNC9SaohHdwuWCYVzrfz+Pa/mZEZSmhj0rCdeudu1oRfFihU4a8r2Sdz03
         BFDyrpeDghgS9i8Scztq0A/P6z4xPqkWrRxDSFTL8FdQbr1YcyHhId0IHR3lcWXE23Y7
         dkBp5aMGJeb/ECW5VLHtohwWlAS33x/LeWUjxH019QEFOealHbyOyCa3rZhKCwvD+WNY
         z8rg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775765404; x=1776370204; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ew9YJVqzCV0p3Lp1Qxmpt1qcifyX/ZWozjm6bnofDwU=;
        b=wUaCJDSz+GfAVxqRqCcgunqPZeb8tYZq5Y6qDARHksfi/3DHfD4zvh/EwRM/GxVn2o
         EhLsaowpJ2N4cZr9m1yk35THPe5lL4EBcgGhyfsINzMwlyexq+k7j31J5k3DMmHTYhgf
         5F/uhfJOHY0O5pI7pHYkZFJci/nOT6pdI2BCfWZuERbX8a6TrkSGzj0lERRVaedcnTuI
         d/SnV/PITiEI7ioHTHvTO2dYEDQzMPDsxdAYbSG4q6OCcGbWwb+JO+eEzVTw/kSg42yH
         iVJTq3Ah4nWD1Ybz39+6HlK+w63hVXZkGorAemRv7XYqjB7GJCrtLer46YBYmQ5Vnbwc
         4PFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775765404; x=1776370204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ew9YJVqzCV0p3Lp1Qxmpt1qcifyX/ZWozjm6bnofDwU=;
        b=fluTooRhrFPwLWtvVr19i5KHpXIBn7cLjd6z3e8D8ChZ9yzXOisolkfiWTsRV1Rf5A
         rbTn4Xcref/n54tErIUL4YbD3UPQKxI7SNxEo0ZulRsVSB0ocnO2nlnbOpjrhH8qT90t
         SG+1tCVMTNP2nziq69y/5tV0jqi73MnPW0S4Dq2DzJrkOeqkowNcraILDhnWkF5Tpydf
         pHWfbWG+uD8QOINQtgQyV9s0TE3Z2OvfMJoxeEzHciTNd33qRRE6z/hxtl9lYyfcSFYk
         BmNB87GFwMaA+YCt2QIjueSeuPovFC418pcZ3tlXOb20ZWoy3pDtRijYJk2TwuMMYzaN
         U3Ig==
X-Gm-Message-State: AOJu0YwrrowbMs21I46/yRd4lN0nVQ48any/T5zadNeY5glGRYvL6rYo
	2J4AoFuYahXwMF1d0UatjbFawdyGn6z2OdZA/81YBHFpWHcuc5RnHzt7oT3w6wZBKVavMC7n8KF
	o4KPTuJXK8IilwRTqXT4ka4GJwG+VwzVLfx4I8ZMq
X-Gm-Gg: AeBDieunvMGPHzYLTJlYxiTEXkjqiTe3NjD0sN5JuEcyFvnlAM+OfDtNkrQ6i9J+/i+
	W0SLGCc61fTmG9bDS0UNvZyKbAl+oqkrSWAQApcflHBwXhRmJvP4iS985DHULQkqHL+9mV1jCGH
	PljCtb6H20jMMY9Y66HPxS/OtF4sRkj09TNSv6YBvXQYGDcEuVHPW8nokYgU4RTi5e7qZ5glYIP
	uQtGUKYUl7hLGanhsv7c/TwdYCoTz3iwSP6pnRFZ68q5XoYudW2TV0n+WbQV1lTbQgVXd4vYMWV
	6vNErHcg5vSZLI+B89p54JbFlODBVJTOQ7tF95vSnibkHAM=
X-Received: by 2002:a05:622a:a983:20b0:50d:418a:9770 with SMTP id
 d75a77b69052e-50dc2535cfamr19504341cf.2.1775765403815; Thu, 09 Apr 2026
 13:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260409152822.1073083-1-gourry@gourry.net>
In-Reply-To: <20260409152822.1073083-1-gourry@gourry.net>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 9 Apr 2026 13:09:52 -0700
X-Gm-Features: AQROBzB0iy5dDbU7EKphm65HVhCwBsaWZDeae_72XosBjnydaerQSoGW-5lujDA
Message-ID: <CAJuCfpFJ6+OraOT11_bysOZsymk9OB4+C1M_R0UEYgtgXfVA_A@mail.gmail.com>
Subject: Re: [PATCH] userfaultfd: preserve write protection across UFFDIO_MOVE
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	aarcange@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3CF9440014
X-Stat-Signature: aonsr5sgt69qrpm4a3rygj7jdbttyf99
X-Rspam-User: 
X-HE-Tag: 1775765405-73560
X-HE-Meta: U2FsdGVkX1/RA5LPt1tzwpHiTYEoOLYSSo/9RxMPYi8UhnLoqiLIZMSfIAjqWXEvxr0mcXlNpAe+el/x3Evz29zM0E6q0Ibg9xoJ7M81+vYh9CYpwqVZstSCmQL2NUkepUQwelz3Nr/OP7yk0z7B3Z1YCTH5n/wUs0oucUWTIEw8AKDpYgZBKjEW6yDDy1d/hVbh6o0rNacBbCSgJPaKEd5hfc+Hv6GrqDztIdPB4KQzKTLCKUDpDEYqCTQ2nhMNDRyrBfslhAck434RBJKAKNt8RLcuBaudmuav4VhzCWj3un3/q3isaZgZAe+a8VT9KTUret6vQT3upZjaaudaH2kwO5x6C012eonopUpffES2QzBB8XjNjXq4Uapc0HdtooACkS34pAA+mdk6JnPBEA57fkQK2KKBjsKUHcruKcR7/+tYywFqFo+OLFde5YmlxDo5BB71cLCSAjpr8ruXiqan3/zzwSiBzcc2sjKa6rY7+rD3Zwkx7P7yEdIIy2k0GR/8DGjVzqvhGA63ALg2KZKe/BVHQwIJwwdIQq/mZQeUMmlvAeEtE6vPyHE/UjEhnfOyYMc01hbq3gTKJedJQRweeH+GaCxdzG2zkaMntW26tfvmVeu0COzkECfCUhsRgy9CdOihI5st80sB2pcJWYQQmOrVuEnlWIJulI2plDiZF5zc/PwrPpm5lhH/VNL5e5ZjVg1+tSULzqkBlxgvbTdH2nK1SXtSOn2h8rtF4rGLo88mwBlzWbFtmFukMmN8wjFIcJ4JuPeCtfdMDYh8CgOM8jVu0vmD9URnFA+Sk8VsaLlbiYZ1bYHonEv1EMdAZbo3xntAsIXwssLc8qhQX/wuS3F1Xrj2BuSVx9tfWUZMZiWDYDPx9CMBJCqMABxLQIxgs17blaOqywFsSLmzhmZ/eThUgNyrT00862mQZgZJB2daoceptjFHVN+yqFi2wfOy+/8Z6JYbEnuOq7s
 j3lnoWC+
 CYP13menH+/grh5OWpseluOeypyn4j5YeFFr+I/aDT539jJxBhAE96NpIokiiawgys8M8E2U7mk6KcrjSnUZhlMLW3c2QkmkI73doeHiiuDGwbB2SNC75zydrn3eiG0IMoC8POcGk0bNcxehxqmfJvYzIOwmqTHfBJ/nMJoG4enrw5LtrGIhD3TdXWqKnlFab4++YOsSLeYA+MbfkH1T2OVIsdKjIEreV0PXxNqczHodpQ0846T5hv7iGRW8Hr/w4MvDgq42nNMS9NoUqR6J8xawLI31UTFSSseqbMduhMoxWChJ9wDHkgNbJYYIdhC6Nj8qxioW+jjxP9+z1QrGJfCIJpJZZDTPfo7N6sszPBFuYEKFWuonoKwbRJVhS5vFo1b3/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 9, 2026 at 8:28=E2=80=AFAM Gregory Price <gourry@gourry.net> wr=
ote:
>
> move_present_ptes() unconditionally makes the destination PTE writable,
> dropping uffd-wp write-protection from the source PTE.
>
> The original intent was to follow mremap() behavior, but mremap()'s
> move_ptes() preserves the source write state unconditionally.
>
> Modify uffd to preserve the source write state and check the uffd-wp
> condition of the source before setting writable on the destination.
>
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/userfaultfd.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index e6dfd5f28acd..783ca68aed88 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1123,7 +1123,10 @@ static long move_present_ptes(struct mm_struct *mm=
,
>                         orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
>                 if (pte_dirty(orig_src_pte))
>                         orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> -               orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> +               if (pte_write(orig_src_pte))
> +                       orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vm=
a);
> +               if (pte_uffd_wp(orig_src_pte))
> +                       orig_dst_pte =3D pte_mkuffd_wp(orig_dst_pte);
>                 set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
>
>                 src_addr +=3D PAGE_SIZE;
> --
> 2.52.0
>

