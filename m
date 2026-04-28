Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D2AFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989F46B0088; Tue, 28 Apr 2026 05:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B7B6B008A; Tue, 28 Apr 2026 05:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8290F6B008C; Tue, 28 Apr 2026 05:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 723E06B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:40:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01960A0548
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:40:02 +0000 (UTC)
X-FDA: 84707468286.09.5B87F16
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id B1F1A40008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:40:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dSB5QitU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777369200; a=rsa-sha256;
	cv=none;
	b=EeNDXChMOGBtvRokSVjawoz6tj+vHM300X2JWsl1WOaRwIvOTrxTklrdIpwmQ+takYg1Iy
	CGBSJWdx+tK+TpT2smRmvRP6biagb/dh77N7VtyhsUBKULygnYfjGdX/HJMXqsl8dgOKXt
	JK6gFb6SFEH5MVvkrqH/kBlOnuYxT80=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dSB5QitU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777369200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgqD2LjcS3lfaRz0Bbuyp5agpi0erzgXbo3a6MpALAQ=;
	b=GL0C9DABm/O5hPAwVR0T2w30CsvNuUzLUDskNy+vluQ2vBRIS4a3dHSe7tbzT+afE/QzIg
	PdeC0iGfN69E6rAewbDxhLRsCPf0pUTV8c1BSA6LJi0lH6qJ1TrhftHoMFQ7v3KcCUrORs
	3G0QuvLybC4mpgzX4fvsWV8Ipv1tN38=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777369200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SgqD2LjcS3lfaRz0Bbuyp5agpi0erzgXbo3a6MpALAQ=;
	b=dSB5QitU6Wk9xlj6KkNxkAHXjerOCx+S3wy/zvTWAnl25KiunrUqpDi8gwdodQRjC1mR9R
	s/NEIbTuU4oEeG7auQ4qsMGUYIfEg36UHGPU700zFP/GexIaJ+S3+c1Eld9YSUFGffLktZ
	IuxGtM5ifwrrCSwM86WDw3CQDFmciws=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-8goZd_4rMwaZ8ImGiLrPuA-1; Tue, 28 Apr 2026 05:39:58 -0400
X-MC-Unique: 8goZd_4rMwaZ8ImGiLrPuA-1
X-Mimecast-MFC-AGG-ID: 8goZd_4rMwaZ8ImGiLrPuA_1777369197
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d721a4858so7601016f8f.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:39:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777369197; x=1777973997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SgqD2LjcS3lfaRz0Bbuyp5agpi0erzgXbo3a6MpALAQ=;
        b=ml5e0LFmO870c6s/lcryDfKiRYKI79+GUsOTuNbacD7SZ3c7JDj/TwrmkNlzi4X1vz
         XjswqYIVuHUVRdn5G7HWi1OJl1zfrEwKiMYq1F98WjI/rQTi2ZvtoNdiw4pQ6NwRxFez
         YRfT6lMDs6QUYNngRg9LILU6ev3GK0gnvX5s3Xbh042r1m7xA83A6Ds3L6sa/dBimgFl
         MVWtjGHXIq1B1VlZ3k7R2cA3J3G/lT9rzVqPuh6yk+nQFRRIsF1O7SaXcoL76ruXKHpT
         nnf90Fd0U2rv5amW6EzuGCN1i7BKuSHwHKbboqs1/CUOMJs29k2JDZ05N6Y/lLuyKW6p
         CbOQ==
X-Forwarded-Encrypted: i=1; AFNElJ/jBf5fqUkEqnkrJadWN7IwvxTxsQH+QKiyJf/GNhTPMhH26/y4aMJR4B8UCrzlOQvYjJqGTWTEIQ==@kvack.org
X-Gm-Message-State: AOJu0YzMBpssqmet7FvXfa3S9DD20WUoFVlP9TgRmEeayb4nN/c+VO4c
	1ngRkXlVPoCxPfvYZTSMkr6vWKG6huHhP4fhvvkYlf4iFKfDF2C6JfkIO7E+EaVhgJT/1T4QmIk
	/g+DRREx16qUM6TM8/MZyta2CUn8jUBDmR/6G2njIkVCxsxVAicGSOBvJ5h4O/+VjQ7vsHfuUBN
	8ZOo1h/wOGkLlr6KoD5FmgAKV8aAY=
X-Gm-Gg: AeBDievAsjsudz9kfjTHHXGlvaLd9tgMnz96PXLTxe5dfrFaEqqRdIgZfQ7YPJr/15r
	zRo3wlZcu7x6Rruf++ABSYddFod/iVxbwu7SlRbC+RrSjtl6sngUBdpabdY6pqmIcqB/ofXzH1/
	OaVhMTkdZjAdZMAiAjwXst1mZUZshxZ2StmjAL1iAa+4saUW0A0jQQJFafKCnVC38FA3c2VW2Q1
	Hd/btUm2GmVbK4ixB9lDRIo0+SYuwvwChbExOazIrEqSyHb8jbEk2ejVl2uUyrlXGuaIR1MLHoL
	nUUDm9esSMA7+Xad
X-Received: by 2002:a05:6000:184a:b0:43d:7946:badc with SMTP id ffacd0b85a97d-446496d5208mr4451828f8f.26.1777369197244;
        Tue, 28 Apr 2026 02:39:57 -0700 (PDT)
X-Received: by 2002:a05:6000:184a:b0:43d:7946:badc with SMTP id
 ffacd0b85a97d-446496d5208mr4451757f8f.26.1777369196742; Tue, 28 Apr 2026
 02:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260427105810.23761-1-pbonzini@redhat.com> <CAMuHMdUvehWeTwdN1czjvv7OjGsu_XaaYS1R6Tg557mDqP+fSg@mail.gmail.com>
In-Reply-To: <CAMuHMdUvehWeTwdN1czjvv7OjGsu_XaaYS1R6Tg557mDqP+fSg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 28 Apr 2026 11:39:44 +0200
X-Gm-Features: AVHnY4InOLQxxAYojPY9TCY0WEKwcodWBYhqlVS7vN1v5Z6dVPP34NbhnYWlh34
Message-ID: <CABgObfa+2ERN1TmVeeWxCQKzra_OThkgkVkBGgDfu5yOsjOH1A@mail.gmail.com>
Subject: Re: [PATCH] mm_types: remove references to s390 gmap
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-m68k@lists.linux-m68k.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1giSZGIURgcnUxEBKRtrFo7aG8QjmYUtotqWcJgopx4_1777369197
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 11aff8ank9jm7wf114akuy1z4x8txq6c
X-Rspam-User: 
X-Rspamd-Queue-Id: B1F1A40008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777369200-33873
X-HE-Meta: U2FsdGVkX1/22VnzKCk7RT1y+RxeGHVp442Fcg7RpRRSWVt+GWDCVzw1mTi6apzJJc5c0uXbMVwOzZS1GD52+v16ky2zXlF52i0qRKI6KsbSYQi9lS7/Cbp3htW807Mokx7RdMJmQBMtOEc5+oq463/jDeiWfbby0n4J4Ybb75oDUNXumxhTf2r2a1CoPPFqUTwfLImeiwq71oqq/LpL4tr+f/BqIZy8s8Ik4Nx64YDg0h5mYqJ3JHMrSBURHVDhhxWmSycnhxRCRmtFCxgDt5XhaaT+VxFn8zYwXRUnhMgsESg8dcRQTVE3bOxugM9zsEb5V+ITwmeXlC+l3ScuNObfpbnnPvP7+vdkRf1+AX8XNlJ1XAjrLYwzkMTRDzfRi/3J8OJeV19cPtU9UYa1LEOqhuTO1IjQtFaT2Jsd+/yC+y1zyY4B1gqLj/q2EyGkOjogM6m7FiYJWBKop0nUr/7X6eaDa9VafzidO1B0mvl/Z+b+UTNno7ZI3Ik8r6WXXeT/C0zDj3i8dNwEN1uKRjTC52lSzE816u9GH9HkccSm/1RtJF8eIymBpdAEgs9yZzw6SPL2a7FeNFqXvWHP5melAATEN2K+shtkIMwz0XvOimCbafT92scefXoh6h4/pFpDTZUCPLSNS3zasNPypE8gAPwYn5pmBrOV6Yce+fjSwjelbUVHnEwD9dXMBqHZqeGEsiYlphHrMr56O0VUtbCd2366ByszVBVmAqwsByTLUUW8BIcL8/JcyxmmiMVuFVUXIl1pZOYDstWXY59MrrjlEaYxVEgzb5xZBAi9M+XcZOCG5nhLMTafxPw5scaSxPelS2lIGrU9y4bKLTKP5QjORqZXylIlwPrvNcxosf1a3k1mxIOon6zJkEOfFs6623Ygw1yLFzsB3NmeJM1sP4sQYLf0QBcNY7KEjqDe0EwUWIKnDu1OrMu/6tkrffQR8EUYnkVxprz7Sp2qfiX
 K3WQxFEx
 0LcTl713/DR81/nLFJnrGbjtfch/jVGUw4b/2oEyQqnvPq2iGcQx4KEpuvbI7O45dEDl+d2Epwklrw4LGuCAQBMyoEuzuA7o/dgXBeARqo2bnBo5hIRGvcsSQMRXPnk8BkLpRQX7Sk8gU8uXDZWnw1Rq17oMi3awKHEOVxvrKBRLkD/jXBDpCQs5UjmFM/Ab2DjHU1EL+DmANBZ5zZx6lDP3WJ/TPeAzlHYibPWj4g2u+FLdOgoT6AwyuWJthXi0XGtnPSfWMYXfJ+LmjNm3/xvM5TV+d+u6A5DcYphkZP2LHVHqvkm6B2Yi0GS8C6kxo1shR0Aw59g/eOGKHTHSqxhrV5kmmL7PAL+zd0APGbsNQ1ZT0bfmWWboPGo7/BtxEvAXlkU+kPTqCEk6nDqP9ogbVLwt5zF1JyX29
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 8:58=E2=80=AFAM Geert Uytterhoeven <geert@linux-m68=
k.org> wrote:
>
> On Mon, 27 Apr 2026 at 12:58, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > s390 does not anymore use special struct page for its shadow page table=
s.
> > The honor of giving a special meaning to pt_index is now m68k's, so
> > rename the fields and adjust them for the desired type.
> >
> > Cc: linux-mm@kvack.org
> > Cc: linux-m68k@lists.linux-m68k.org
> > Cc: David Hildenbrand (Arm) <david@kernel.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>
> >  arch/m68k/mm/motorola.c  |  2 +-
>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Thanks, do you expect it to go through the mm tree or are you taking
it yourself?

Paolo


