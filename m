Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B34D7E94627
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 01:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8006B009F; Mon,  9 Feb 2026 20:51:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C196B00A1; Mon,  9 Feb 2026 20:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB6B6B00A2; Mon,  9 Feb 2026 20:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D62D06B009F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:51:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 714075830E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:51:16 +0000 (UTC)
X-FDA: 84426869352.21.A9059A8
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7238840008
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:51:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fxRMVUAf;
	spf=pass (imf01.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770688274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLInHUM+vEcjgCn48Y3fTKTA9DVF9Y04ztbwGzpSQek=;
	b=AuSc3wQTJmnN6CmkrxfsyyxA0Sgx79Wzyi217xJLOMskQX2UBL0EZKm+r8aj5Z+bffjkg9
	GKz9yxP4YZxjZaAZdW4djvo7FhrIQrVMItpgmmArjvIgwxutQ1kpoqq498gRunX8GhYTxt
	o2W1lhESinZGe+hbxpWqgZJLBYnFIkw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fxRMVUAf;
	spf=pass (imf01.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770688274; a=rsa-sha256;
	cv=pass;
	b=L2H603O+6q6qeE7rDjpQUOg8P/k+mMsTjOkTWFFJu2Rdhe4NRivMqnb6Q/V2p3eXIZssGK
	RlGJl1bCzCV2tUlBqcQNeGnvlpaSqaYsBRsfDru97904raaylMo26K2Lzsf0g19W1UW/xm
	/htnVmI+WjPJdGawHOe6ra152opyyFk=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-64ae5f0777dso402939d50.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 17:51:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770688273; cv=none;
        d=google.com; s=arc-20240605;
        b=Qj1o4IblvbDj5LUyrKTnoe203cSKlNjqJIWMbWXTVaS3kbHWrkhFWXDOl4NGzpa6Ii
         /uP603lBPXNEZUJ8PAi7Cv4X2QgiTsNuyBbGl+YoDJ3RUAwSHrdoq/is3Rv1UGrH9Tj2
         e48sosSTrwuyvo8ujaZOCJ6sOundmw0MRx+LrsSvvFMmaY2m7nD5O8En0tx1q2VGE5tc
         LniWsvIMf9UKnsSlKFF+ANW9WNwk8vHIOB7mqmusWqlJS82xftbWE8YQny/6CaqpU6J5
         kop0EL7KPgsYe/BDTTR65+YPlhblH+K579POSnZsuK27ZDtj+XCnlTvcthMGTs5kvHME
         c8rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jLInHUM+vEcjgCn48Y3fTKTA9DVF9Y04ztbwGzpSQek=;
        fh=nRGryC1afmP3AK9FEXdtElmfZ7CTye2xOue39joP9pU=;
        b=RFXrHKo+DJ+2INQakdIDCxVTxHxLvaVZj/Qllw1+TOcoH/1sS0F96EpvGbRFXe4+Tm
         KzocQGXKnmvlGOkEYgJVWWDy/knmsBDaeS5PlH91JJKdTLWwtWh8NBK0z04AdfF12sXw
         7mHRHpxiEL5HF/ZzA2hZ7ieEAd45KC2nMXHnzrGqMD/CQWJ2vGFxFmUI0Vo9avdrhs1L
         7a4ZYfl0sLL3CnAIupjnocECtoiBQUMVATqiLjBGLFle9gBoZiCfb8qv+ETQsv63HEbm
         bkO3WTk0onm4732mOWJ0u9JbpMuAnyLGhOFzTwviKp8JRSU2EVEUQCZ1p8juxdEyumQ9
         yGXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770688273; x=1771293073; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLInHUM+vEcjgCn48Y3fTKTA9DVF9Y04ztbwGzpSQek=;
        b=fxRMVUAf6JTlhcFhT3GbVdJtns6+Syuvm+JbqkES32XXw+w8FXsv5BDp/FHJfnPRT6
         msgfzNYUGPFaKQnc7aRxj6pNKBvhpVFxcahfG3lFFuJlCT46XggTehYY520BxMwZI6/O
         zMaEd+UsWKixmgxB3DCRUaQI6pvQYWG12m+mSwisqhRp68zrhDLlPQP3SnELJx8q6FZb
         TRthHDxZ/qix/Ji3esE+tGESfOLSOSGquJ+fBrNLd4Rr7kiDUB9OyW9S87Wn19LhPFrE
         s5Bqib+x4/ruEYwRQXmJvuYqygtAwTlY23appVDPAGkMmeeEJZJGq/0EcPosFGN8QgNN
         42MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770688273; x=1771293073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jLInHUM+vEcjgCn48Y3fTKTA9DVF9Y04ztbwGzpSQek=;
        b=l2C9vp+6QSeaiXmREiA8YKJFa4YazB8LtC3P2MgP5PHQNVCdZAofjvPj5xL9Udo5W4
         vOIwFzCNs43ZC+cIagxqtjb+IKhlOU429chUKE0kNXKCI5LOYSrVZuCdFoD6vF5CKyfK
         YbMVVWvy8QXyMQlm2P/96ZB9aHLioLI3ASDYuTmUMYzwbua0oXRIKPRfLhcctgmohPOS
         YnrvLE84O76TAm4jDfx8S8CeYIf8sG/SoZiG85HTzqvHXd3Jgns5AbGu3cE3MCm2dAHF
         W/Ol4lam0JCtun2fWiLMi5Q5kitETwfyPrsYwWX9KANpnAD+tAfmJgHnol6qQuLWuM29
         FOzw==
X-Forwarded-Encrypted: i=1; AJvYcCXvbzGz/DloVQBpvjU4GEo1gVS6IvgSLiv64IkUOYDAEn9nlgyfKPN3gCx4G6gRcKhIAUGlU1F6/Q==@kvack.org
X-Gm-Message-State: AOJu0YxiIPCVPEwXYIS5/1WTZrIYLu+VMS+WCgHNJwRpubT+xtdxORZL
	zgoTbMV9b+D+ZCAFJxATo2z1M/XZNO+HJpnBKecQ9faX7FtSAMEUFBwTSdfqpbdMl00PH3Jop6L
	ORSE92RpprxQTxDjO5lyyzkrRN603DBQ=
X-Gm-Gg: AZuq6aI/OHwEyWWXwrWFg6fekhCKtqT+DjcDJmAE6FgcwcWXcYKUq6bHBb8mx3O8Wux
	yFgij+upUaTjy+pjBp8TJAwSMQOCBlSb5Q3gdTLM5JxWqELCUvd7dXt/sA6lvUSZSOb/W3ZNxg0
	hI5OMP5df+vjx4OV3/kPtbbDpPI7IlQs2Gk10LYyBLPGgyeuLMgypRuuiTxn8FSddI6EgUEi1Lw
	TEaYFxlewYYVUT2lIcG/NWJwSPAg/ILJFqfbQtzAzFA56nn3SWtDpsT27VwJAkL6ViDojOhtgIH
	Ck+leujHWfHbPeX/Fv7CaBfhBw4F3Nt/IZeHh/D3od8wSW4FGwRR3yg2eYX7fr7xMDfKJfvE
X-Received: by 2002:a05:690c:e3c7:b0:796:4235:ea0d with SMTP id
 00721157ae682-7964235ebd4mr115002297b3.37.1770688273359; Mon, 09 Feb 2026
 17:51:13 -0800 (PST)
MIME-Version: 1.0
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
In-Reply-To: <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 10 Feb 2026 07:21:01 +0530
X-Gm-Features: AZwV_Qg7GuAEgde7G5zPc2LfcDbHb4-fXZEvxFglxVtjCS5Q40Zg6RsjP15AO1c
Message-ID: <CADhLXY4xnf0DuOzMhS-ewmsrELgmtavG+QxQdFsLb+e_tc-09A@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, pbonzini@redhat.com, 
	michael.roth@amd.com, vannapurve@google.com, ziy@nvidia.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7238840008
X-Stat-Signature: mdsbixe3auneafdkopx93uf6sukobacu
X-Rspam-User: 
X-HE-Tag: 1770688274-812851
X-HE-Meta: U2FsdGVkX19rjMGm7kfA5LN5mLnAUC5j+5N315l9Wnxh/OiAEVJcx6ceSz86SzJwuwOexOdMR1KbReCUmaBJEy7/MGKsqTKZdX2Peoi2LZsqrLbMz96ykPAwIFXA5nVwS7ktsRpdXd1ne2CkaTiXdydJ4Mvet/R8o3uc19J5biVru5Fw7r/q6i6ASZNjpFqHHznVZeluGjGT9Dash+2ZEoHk/sKoUUveo26orUDuVuyKbp9qlBMq262uIA1Lil6oI3kV9zyVRMyn0VP7I7sfoQT53MtXWI9FAxnpPQIf+0vkT7ife3Wp4USRjFklKfJyNh22wneNDvfUj8X7qKlrp61vJ8QnvwgIzHSB+HswguRMenGsY95nK3BekdbJ2fEfd6LZz58Jf06ga77WdPq2HfcatoS4wts8h8qbvgVGYw/Oovpx39U+oj3f/RfIjDB3PqoQhkDRfEthAl6lgoN8IIONxezVsRs2KcY4eI0mwkKuBSRROsWm9lqMhpcANQX+NQI4SgZhFFaobTOsZcVTLu7UsbJRvf35ZC3JWc/oCw1ejVtnU0HgmS+2aEOu5LbBWHp/nqyl0HVAGj+gW5hYWkSm91mGz+8+EXxyU9mcjzbc1SIu+BPNt3dILg6S3gNkyllpZFkaf0WWZXkD7gJWvGH6TJ8+Ez+itQC1GDsbhdxpcgxw/LKfIvIe0daROimPZW9Qn4ORTOA5lFS4Jks8NpMOiPYxgIRFZhC8hH3o4Rdo1kDt8NMZ14BOJxdP3qapZA7P30yBgW2pLyAlL/BhiYYM2oVie+u++Ua5K9fCbshhtinZFspwLyaj5X6J36NqRH9jIJvQTWoHvLcHjTkglF0OQQWTwoKhaYHVG1Avhay+Pmr5CwVKl5dY0tM8bbmTR81SUe6qQK9QzJo1FlhudJdsUGK2O0GXhw2WZD+5/OMGlP1QmeeOvAfkdP1HYcy+Bul64vA7A/b9uoZL4LV
 oQ7DIGW7
 cYeelZGRIh+IHEcbylhcaV5enue6wfxR/kjaKDTUQz94CqiqnvD4xYNImcP7WXd1enQyeTTEzBWvOZQv8DUH6g0Q3SEg6ufAHHlhK46+YtzLVNFykvpYIV4l3/BN6++xtQ4OwA9gazOSMMNl90EZjKPg7uBBL5qdzk+/3LVKV/RoK0WFdH/OuNG9O3z/oQRxI6m6xvW8yxiAmUh5f5xvSHkUjW6yksQIq+9XXCUBdI3Y4e9LX0qTMfPHDvG5Oi2hb1ILDrYDYvWnpaZ2bS1pBTWsw1/GW8QK/1IqobBGymrlu9XpQ4f7AFAG9cthDTdbZiYHQ0cNhssL5SxHrJUWai0V31p60NgbZfGyP8xKj9BiEu3VgADh3XfTrw36HNwJz65ZI5HJ0FpgzvKCtQaRWZLEKNZHEytNGI9Rem9A9sBdf7Q8j+LtVZEKavRpaSOgzLwUREHQMgRpEhpz5fCKBtnynodQpc3ohTKk8zmMFFJDE8LDbmEj5RhZgua5CFX93VoUItNyIGb+m0f6DZUMzWV3Eujn2Bii4ZVmcHnnJyDmmorB+TPKnSdkb1B5RBzyxSKVH0ZvhOmQtM/ma5F0KSakDnOUImcT7PTVF+HOFFEP7tqcrSqV2MYLkaMurDOHLyEgMqYdpb8WTMEqgCHHfpBRJLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 1:43=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>

> The following is a bit nasty as well but should do the trick until we rip
> out the CONFIG_READ_ONLY_THP_FOR_FS stuff.
>
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 03886d4ccecc..4ac1cb36b861 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -40,6 +40,7 @@
>   #include <linux/pgalloc.h>
>   #include <linux/pgalloc_tag.h>
>   #include <linux/pagewalk.h>
> +#include <linux/secretmem.h>
>
>   #include <asm/tlb.h>
>   #include "internal.h"
> @@ -94,6 +95,10 @@ static inline bool file_thp_enabled(struct vm_area_str=
uct *vma)
>
>          inode =3D file_inode(vma->vm_file);
>
> +       if (mapping_inaccessible(inode->i_mapping) ||
> +           secretmem_mapping(inode->i_mapping))
> +               return false;
> +
>          return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode)=
;
>   }
>
>

Hi David,

Agreed, using mapping_inaccessible() for guest_memfd and
secretmem_mapping() for secretmem is much simpler than introducing a
new AS flag. No changes needed outside of file_thp_enabled().

I will send a v2 with your suggested diff and test it on syzbot.

Thanks,
Deepanshu

