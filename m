Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B5F606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 21:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DygX3CvE
Received: by kanga.kvack.org (Postfix)
	id 4AD826B05B6; Sat, 31 Oct 2026 17:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439DF6B05B7; Sat, 31 Oct 2026 17:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFDD6B05B8; Sat, 31 Oct 2026 17:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E979A6B05B6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:44:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35C401A025A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:44:02 +0000 (UTC)
X-FDA: 85384249524.22.7F9488E
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3C4C9100005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:44:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=DygX3CvE;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of luto@amacapital.net designates 209.85.208.182 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793483040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4/FdkbJCBiK1V2GJNaCfclA9B0e/fDcc+jSWi7alCA=;
	b=bZmzcn6naZdRgw1S3QXlDU/6xPQBRJAVaqE0xfMsgTv5SSTwAZer/5GDaOe2btG/6Hyj0v
	+51aKruIiUu0aqdumrEV8Ru/t7vEXjy1NwASN6WvR/kSnE5051c11S6nUAXpWwOY4lyvhH
	Y2JuUmfo++B++hck56NxI5gVtDhpOW0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=DygX3CvE;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of luto@amacapital.net designates 209.85.208.182 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793483040;
	b=FQ8nSO1H9V/z8DXTslqFJJpzngiOaUnjtKlau7n/oWok+C1SZQUgY90T+l4BdxfBt/RZIP
	3RuPhcf6V21+Bp6D6QojbMaRWkwuJEdxKwyqigf+9rvRcV3qxtj7oDhDNfEmt+pAg0s9eP
	Xl3TZ7yBBTDLkEE5ZF68eq9/HRPKpzI=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3aae7df0971so13373841fa.1
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 14:43:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793483038; cv=none;
        d=google.com; s=arc-20260327;
        b=a8S7a9teopbeotCYKiSuuFVksujibCOPbEI0IWuTa/zllkl5fzVtHg4x1WVKJ7Me4x
         0qfa1qZs/PInQz/8ILtnTQBI2LZUB+0MI767nP+PL1d2NzhtvNIhoWnAbtsyUM9SJdkR
         w7se5YMLwSHeHREozTwoBk0h7YrFHt5WIvkwfP6xTTu5HH6TjsIEKh/gsQrUMSM2jzVW
         KYJKLY+LWzHTCKYVOqxqcuVC+qN+vjyYoSjPx1bQNWmypeV98B/NW/gp0y1bRmgumeRC
         uiGt/Ka5NEwWLGK4JoalCKd+AXpZPAnk5XTX6SRP0IBjXY9zpel5qCWjqnq80KpV9NxI
         eD9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n4/FdkbJCBiK1V2GJNaCfclA9B0e/fDcc+jSWi7alCA=;
        fh=j7u5coEF3NykOQ/IfDJgWLnaIXuvqgKTXRKTZl7rcAM=;
        b=sYkTLswou+m5+nbaQHSpHviuV4NamzNCRqlUVlvBw8tsfZu/g4wBRGL+BZGXMJDSMh
         1Y4t+AT6jsjBl7Xt/UQ/TIBdccwKPLHpWC3YnIJIgY8dgNybjYppphZzqpEicMSW7jrv
         Ry/5Mj+b0SIgj3oc/hQ9dWgwBDQlFY+qI5JsKeJ1A0FThu4CUmIUCDLz21EGhlqdYGXn
         21tCbaLA7Fo0Ehp45QKJ0gZ9uDajUd+C0bANftYVGhinSV3s7vDoSZCLIv0gOHxs9Lwz
         gF8b0QVtXMawfkxB7DUAWEtyCZicpBJeaVx6y7Glh7TjJZnkS/MIfq7bQtyIPNVrzDoO
         dGLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793483038; x=1794087838; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n4/FdkbJCBiK1V2GJNaCfclA9B0e/fDcc+jSWi7alCA=;
        b=DygX3CvEtYMR5u8EOILvUsUCzfDqoOOS1SINpKVUQC7q1hvYNOhEdYyeoOtmmbn3sA
         f9jm/DXEmBUGIQY2T+dAARhq3A0yyamWF9OVLK4NzrHJ3dwbNZNAVOJVeFyecvNFLg2z
         8U3gIXT4Aqa9sN2coa+9lwiHAkCEi3IpNhxiGPxAZ9L0tjPuCJHW8JsUbVtlGJJP6JO8
         3njm9Ua/3vQGM6LOi0mA/kDpsxxvGIhTVHJURCzi51vEim47fOgIpPcLW0G7a1NMVqST
         YNTqtGfLmLQ94arQ5pa+Gn40G58xWPp6hdxd7qxBDX0sOswuEVX7EZxglqoIE0RrHAD/
         DQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793483038; x=1794087838;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4/FdkbJCBiK1V2GJNaCfclA9B0e/fDcc+jSWi7alCA=;
        b=z+o0jqVj7o8aa1k/LN7XBUBzM0cpfQ5ZtNRGmIqCP7lcgD6XUUhXXVoFgHQvK+rXGF
         vY218aCIz0nX6lJBQw59euu2Jy/WNrK0gvDM1fGkJysw2fF7wIS9S0teiY7tCKNVfvji
         gOm/Vs6q9WDwjDPtd1djrphzZcjZZEqywo+cKa+M/Zmi6cGFwctaPLvCjEyHJh5XCH4u
         SuUhqZ5sh95+i1QkbfKjBL8yWVMdqdEa4qljG8ooE21KLr48eIyweVKYSjJ65KAxlZnf
         /SycGfu48hTIS1VnbUbj3WtaZGvjxUl0ETCn9++svaty+yxDvnOe7iQm/yeEOVMtkiOp
         c/Dg==
X-Forwarded-Encrypted: i=1; AKwUvBxXDUY3L6hABcZDbIgj4PXYK11jbfDG3O5WyGJhSGq9C1MXtPqy8lFNmXxlRGFNa4YKbC4uFJxBNA==@kvack.org
X-Gm-Message-State: AFq9FYKR6cMfcSJ7NBt+BX590RxACagumNdtU17wBkwYcaY2sT51kfCv
	BIG08lujKeCkH9BH5wy5m9xqKqGvD0w81SBhjg9ADlq+e7LjGe5ISMBOUaf9/23HPkW9n26md+3
	nnxfqttkA0hhR7FBgF15M65fL38OENeBK8WYastJK
X-Gm-Gg: AYBFou0+gDw95wSBgWZHc0hiAa3yajhlXFPmTBe6JJOjPmTAyvRE39bbbKJHJzwBybh
	cr1MBsCJi1YQxLTOQx1Ppi+LB6qRvIu4XP+WLu2EmjT/lkIecMGTXtnn5it5ps+Q8hk3x8DVmgV
	mpneOnVJVCvjPd8+NXYw7fBe0GRYyoBhDsP7fP9EEJfmLKcTaPVdaktdYLtfogfecGUcq4Nx26y
	/vNSBJ3GTvhOhFszJkP9K+ugIyVp6MNCMcQd1DNEpj51I7JL3D9G8+3AxFdBpVrdPVmTwxY7b3a
	oGo9L++0lmg208jL2dAi5RVpac4BKmCiMXiUivrJbrjODUAcfnK9PP/j+Fw80mfxxg33j6K3otq
	Ys4/6PaYz2sSRQIe5aGDF/Usi9C+iIBC40ytYBX0n2XsglNSj09nkasw=
X-Received: by 2002:ac2:5681:0:b0:5bf:c2af:3915 with SMTP id
 2adb3069b0e04-5bfd95730d2mr2003629e87.28.1793483037747; Sat, 31 Oct 2026
 14:43:57 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261031203540.2282507-1-skhawaja@google.com>
In-Reply-To: <20261031203540.2282507-1-skhawaja@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 31 Oct 2026 14:43:45 -0700
X-Gm-Features: AclHuK8DXwQuKXG7YuVQ17qPxlP42BoepMeBjGp7aRwX7XDPrtPwMbgsBa7Xe70
Message-ID: <CALCETrVMC4cPuBeSgPRr21zNoCDqz5op8VR=16382FFSf9ymeA@mail.gmail.com>
Subject: Re: [PATCH] mm/gup: check folio->mapping under folio lock in memfd_pin_folios()
To: Samiullah Khawaja <skhawaja@google.com>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3C4C9100005
X-Stat-Signature: droq8xxjqu9cyzhdrwwbuzm96bbubtmb
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793483040-599260
X-HE-Meta: U2FsdGVkX1/OpKMQqPHjFaYZ1Un4XWoesrydFy2RhF+otjKnH3SLUaWTBvVoh28Zi0TpJ0YXYuZXRmLqwLHkhDzXfLnZTKea3oH7OWulAgozTDE+9vr2WA/EpOS5NaU+KFns58Y7HNKleNRiINmn2msFMiH14ZrNp+n0DxQe54cnfkE+FNtrXoagMaBwUw0FJS2UsM4DjOVN0p6RE2vnRgMaXGOfIQI5w71lQi65pH4h4J1R5Kb4bW468CsMAfK6vKt3mYQjM74D7iF87G95A006WQbeZoLE9aomp9GX+P8epkgPzlNJFQHUYMeoRjrgje/kqlVMNLul0Iugpcv/PvYu2B2/tYgX04DBcRIeHH2nShR7L/tDFRCRi6XLaIIXt1EcxAu/AQgPwp17kSxiHHSPpGBeyWJ2zLrXl8dgTfD6EuheI97j1WOaruuvwmGsNMcaP6kvU2ww1/VQEDV+6zEYcEHHshGy6h22IBKeX1NYfvVlaJ34XK7YSem979m1zawqckWASIBewCN0oI5JFy452ZlEIxofqxYLp2L72MvTpEp3B1SwUx5aY9IgvMQyAtzUTIJMX1qKDUSUF/qXuGMX6fr/DjJWHrJY3UsWfSu7r6Rcd9nty9iYRkNYzcZPdFg4P6LVA2QEYr8ofaZz1Ef3h+pQI1Zg3SPl78xh9Tb44HV0Fh176+X158F+OEOOpTKV/HhDpyO3/XC0i3R6EnqIRo27H3EAVNtQk9/WoadvJvZ08ynFkp8bNBV0ORWbt7KwKS+DTQ9yXMYhClz8VRnoYze4diUGVSSQPzeJTapImkv9cxBhKWzEy4RGr0usOj+1NSn8WodJYGrGbFEEH9T9pMSnmkyrOt/4ffXX+WV3BsjGDp3Hq2St2VuHTTlBTbVosR2vE9mLoKjV6DM5DNMuz1V+ZKw4I76na17ZaQo2mAwyXhOuL/tOBTPqnwmjkTBs5ROtpXeeAyF1rWU
 8AG6IXX4
 P3mS6mhUpqqkvsP1CnaiEGLKLOKQXjQsXsVphUe3wLrHU8WvmaBXIBsjx41xE1TOPaLX8cZTx3C3+wITHYoshb4pzZW1MSKtES+2fI+VCiMRtzkC/76zyHcUTH8aLlaKQrYutVZd1isDKxFtMiILyWTheaWcnilgbfKacEYdrBXYEUWxr4/W/M+4t5qILPbT7hEF8talVMh/FYPFSkC5SlbM+vdIuuYIoM2r5QDvZ+7SR9P17IGMn75O3+nVU1oLvXD0nJ8R9YsEXHxkvVb9UuHDd2fxGFc0bCqs8YgMETRDctApH+ikBZ3a7B5h5j5zVyS3f24LHRTzdqRpX9sWJYeMrG0kd+atYifJFORCOy5uLfYDgq3pujm0WfH+y4Nebkotu73pphXcdg7HMY5dR+vsBl7ft5L2LYlMaAbBpHXtULQZbIsR/BeCtyXUWvEteHlLV4rs+mI3+D/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 1:35=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> memfd_pin_folios() pins folios from the page cache without taking the
> folio lock. So khugepaged or MADV_COLLAPSE can replace the folio after
> its refcount check while memfd_pin_folios() still pins the old folio,
> and the caller ends up with a folio that is no longer part of the memfd.
>
> Lock the folio and recheck folio->mapping before pinning it, like other
> page cache users do. If the folio was removed, retry the folio lookup
> from the index that was removed.
>
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning me=
mfd folios")
> Reported-by: Andy Lutomirski <luto@amacapital.net>

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

(with the caveat that I still don't like the fact that pinning a folio
does not keep it associated with the mapping.)

