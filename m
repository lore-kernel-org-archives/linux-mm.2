Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1852FCD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 17:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE216B0088; Tue, 23 Jun 2026 13:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85DB6B008A; Tue, 23 Jun 2026 13:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C7A6B008C; Tue, 23 Jun 2026 13:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA8526B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:42:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 586A1167242
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:23:11 +0000 (UTC)
X-FDA: 84911848182.11.7D9ECA3
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 49C5A80008
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:23:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L4zm6y00;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782235389;
	b=Qn/gjIiw8AC5Nvuh7UvB76tj4lIqSloNTiHt9PcGM9vAD0uZnD9F0yOGRTI0pcd9FsdXkE
	hJznNq0W5+c6JbNB3yE97ipg1mCaHokzrBmBXUzgDyyefmonMlRIP+MB++gf3sfHqCOV4L
	bsaf0S5bMDENcdVs1jP6UG3tPXrvtsg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782235389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXiMe8HDIOE+0WDakylldpBC9cK0yztON8/tEoX5NxM=;
	b=fox3mEj17e9LaHWnSbWOlRAffOqDp2D1byuD6FWZzwBfYqtZOthzwIb2ychpZltDCaqmxK
	/wPhinJoh1Tj/f2J2cDZmDWjNYl7gamlNHBXdN9CO+AQIFxdV5Hwois+Mph9Yz+20jT6M2
	iplX4csnkdC5Kl1w5KVovpNP8qwLRGM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L4zm6y00;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4627adcf4d6so108913f8f.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:23:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782235388; cv=none;
        d=google.com; s=arc-20240605;
        b=Nbp3vvbIRvZeLezFJGIG+Vznbs79uf+htWpnRtwsFvRJI4Bih8y1uEEQoAUhLZhE6q
         7Xf4q8VIQlouiqZgqNTBLxlx5BaK7B7SW06Z9a1TxAV9/wO6/qUNFaK+ZEGHlElY+Xg+
         q8rZ25ZA1+yiSAoHTH+oReMrSn9LFQOBG7/WMWBSBZUhATbPR1pf6cp4rdYQUtFbNnca
         baYuH0e4a8M1ITe1G7Z8Z0i7mF5bauIThFfQv8rPOWEvW81k5K9RDmC5gyOZ9e8vf2CR
         5VGEFjnaowDuwWmgzXJPE42chVFuA81ifjgAemKuHVAzYy20KDEow/9EzrKeDXMmUcAy
         H8xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gXiMe8HDIOE+0WDakylldpBC9cK0yztON8/tEoX5NxM=;
        fh=TmUL++rgVS+Q7FVr2CUc08zj0a/sSn5yeruhljXB8Zw=;
        b=fwTgx2FQlQObHLwMtNWYnYYVEx+YBYYSHBkQcDv1mj4aDtcs+FVB/VFOqdVf5Kr4CF
         gOaMfd6V54XiKzzTCXStWFMZGfhDqHbABQQnyD+SqdFEXxLDns8+rWqdTGTUitfZqQdB
         NljLG+FdnF67jMICBWobf8yu9w5T7KD9C1Y0izngAwypRi0szfiN+gGlFaXPSBw0IlmH
         UDP2DWFBmM+3xoeuqK9gpplibelFZu7W3zezImxadYJnkIsmYcDbbPdgIQ41wwP7l2sO
         IDF894LQJIu6FJw0Xfwq6NbltXYV7kME0TBPWzLHLXTLtTmKr4OusPl/rlOYcQSVL5pg
         Hcsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782235388; x=1782840188; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gXiMe8HDIOE+0WDakylldpBC9cK0yztON8/tEoX5NxM=;
        b=L4zm6y00sCr8bU5xhV2qaZkEDMw+CiKKul4LtmHz1JvcSpy8RpMZv5U1MFsVJ7d+0M
         F5Tl7U3l4jjEpyBNi21sjmb3rxUN8OQxZdYqKgxMNB7L7Rdr/84VJopRimJp60cW5T+q
         +Cy1Qzdh2gameZbvNoKvmxCsXeFO9SsmZabKJAOHWS7bs6o+oSonOx1vZz0isxo/T2WY
         KLJQ04+pUEyKMY7CwKiIzg/6oAteoodxu1Xb7NLiBhy4hA/2o7/h3ZL+OdlzXgc/aOAE
         1iQxsS4bm7ALzjK0/q8w2k1RkRR3wJcGmdUc6IG0bjgSuM7h7V4zZ25o/nBihw4q0sVK
         OaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782235388; x=1782840188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gXiMe8HDIOE+0WDakylldpBC9cK0yztON8/tEoX5NxM=;
        b=fBb1uN+x7plUYrdqGmtcNqQc9zNzXTMVnKsREcSIf+NOkffUKmmzrlj0aptgsv9iPL
         uTsoXfZlFJAHLUgQy2vZ8mO68MqMScD3EVlqWReP30q0A2jX5fdGl4IrIDOCZJl1Wrjc
         93t5c71O6B3YjRSJndfEGiQ8w92wEsyzMPq5ZCck+yoXmAcPF6VYvOuQ81HnYKlaE9dy
         KdKUbb8dxIt3Sh4xfMRCcxsANgb8/rF39SxCsjYfTFjQlNoXZhK/9utbI4L7RcLDgrrd
         cy3WyEnLe+1VTRgHGK9YYgYhZQI2++RWnD3HtWl7SiozXkTAimey/PU8nHXCbjMIA4Hf
         UOAg==
X-Forwarded-Encrypted: i=1; AHgh+RrPjVLX8AnkDpUjR//TZbYhafEUtCj5bCj3MNo/7gQVA11x/g69btRQwuZjqwu0wngza+P5W3hL/g==@kvack.org
X-Gm-Message-State: AOJu0YwPCudAsy9/kgHT5sa5lK6u6OJznu6ivqvxGEC8WoyAVaF+UGvA
	PI0KhT1m6cDmF2TjL9O2i8mXrrtMq2dI7DFauC7xaF3wO3nSL9HbyfueXhapJQtHleSQEwgz5vl
	xvnf1f02ulyvU2pYp7oDLFyEHHw+xq3yoNIcC
X-Gm-Gg: AfdE7cmf6tU1cCcLaLcMcBuT89VW8smUxLTQt0ykhtKsSehxpAIbqw1ZkfR3pf1pR3z
	gBi9jqKExLnfnI7/xGRYw9wcwLk2FHtnExpJjVdEG633U5cV3sScER9lfw9qDBWQvBQJWJSj1Vx
	UsN5Tgys5WqVMf5AAgHwgvbCpyDI7LLweoWLWB1dN7NXm3OQsiZrn/fCvm/Jk3yvxUc33OWns/i
	HhnjyzmnYBM5F7idOYdeSAIi9uvIMN0UMzms9uBkf4B2tVjV/ubLkN1GGT/cGUQf99zPMYiWHDi
	hbWoRxluuBU9RfV7epHzwANSV0sd
X-Received: by 2002:a05:6000:40c9:b0:462:be7:bb3e with SMTP id
 ffacd0b85a97d-4650a32ad86mr33428442f8f.39.1782235387480; Tue, 23 Jun 2026
 10:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260623125723.2503832-1-dev.jain@arm.com> <20260623125723.2503832-2-dev.jain@arm.com>
In-Reply-To: <20260623125723.2503832-2-dev.jain@arm.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 23 Jun 2026 10:22:56 -0700
X-Gm-Features: AVVi8CeEvgfnl7jMBz7m1KFt2-6f-dIEtukzhV0KPjrg6mB4fbL8SHYLbk2XYw8
Message-ID: <CAKEwX=PWQTyrUj7y0uO5qo3VHYZQcP4z9wrqHTS2yufKyA4ERA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	liam@infradead.org, ljs@kernel.org, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 49C5A80008
X-Stat-Signature: ay8ada57z4aqw31op9a4abj8zswrz1xu
X-HE-Tag: 1782235389-461948
X-HE-Meta: U2FsdGVkX1+t6MzoJGPQGhs0itSs0TBw+Uml7UkUFt8LJGWG7XkNJQHg6888XJ9hjMJzbuqWsSkexE8YCFsvnYXM9OHVWRjLxTBcKYh/vj79sMGh4rktYAaJlN5kZ5vmM2yOtpG7TT1u0b6f8Wjs0G0g9X53wS5/W6mvZZbX1LZ9QQcrVsP7Ng7e/wtBorBEJcS/uzRn8H2kDpfbP2Z+nLJWuIj5qvwEbtsHh+4XV8SmXANBdwBc/o2N+Q2675jbUXqXfpqqyEY1CXPgO+bhWAiR2JUo/xKo4uoFKyY3hu1zt6jrFsOgV94hPH4jX3+X+cpxXNlRF52QIgQG6gr5wzSaMEodeOJMks9xilMFVVphnnO7U4tUKd38hZTChP0gIf+KEbA704UJMf0uab+aUNfiHTS/lZK0v3qAN+8PiPnCQR1KIB18b1w4bi6GAvjEme+g1dtd72Bcf4m5r/7zD/zjRFYRRwd0Y1ZLpK5qDY6cuwyicbvLsnlKqwbyksk8gE/ReVycU+27JPadR/DoSDEhv/o2m+lPbbePFdSOm/XdXJ7hElaeETItQD+9o4Xyzw/otymmv9WT3rIOm2Ib7y/H2lB12M7hrgU58hj6dM6xRKNMB7ew7IK1ODabHz+i83ECcPM14/7doHx+1AtUmSMAZuwI7mmvbytd9oN4Fp2Qh77KBUuTo4fYPMRGgaqLY1ET96GSS/edIOspnNGZp2s04GYLdp/XiNqW2CiYuU/90zyUbUaFYj1uddT4Uj7ZTFle5cRdaAjPMc646ToCUUDHM0GW3lr8kv5uI45s/nwcMWsOt3NBoWgl7yNT+u/RQTB3TmWoe0uyyup1IcH3cgALLfIi4ODbw7GCPeYljjHe/F5G9SFbPbNaZnWyP+2tt+YGL89Jada8LTnmRk6Emd4gf3kuDo7VoHAUJU/dl3bIJ9cGWZSldvtcSMGZMZLNE9JPXlo3chirt8vGDep
 WkAIfIqD
 f6DfpRt9xZSO5YnUgLnzMjj3z1wqi5KLc/nWi2K2UX6wck2NOJ6ALrFzTo78MBdE1k+3CautxlrWfg5DrIU9Pmm2MYgXX78Z1iHdOmC7GnnYf+xhhW0OFJgdQyw4FK4Bce+PjiMKbVbU1yiO8k1+4iBEq0ENFlL/4coAEhKPeT9ohX2GdLndrzdKxuVvy89/9yzqbMcephhKAcExz7wDnd97B0RdNk5AEmRob+fSCQGQH8/gLytxuPkyMUZvQMU/l9LcVqGIGwiBLED2s4DsI4EQa2Ic0bc920kPobcSNsm/t8rKD/eykgmMFTzofx1iwrOBrDELMDX12cJVz9in2vATCHeiH0jx9m/f4ynuSuCi85YFX2GeNget3s/4jsv8hFt4KIHAF4bEoEVO0V3dJyYkLUmiqVJAyDkYuGIJztXNry4cesmoaK8zaAiiCJZxJi3L57ZUvMfJSruvasEx+kvCed7CtF3X047u7rt7uSt82uD6zda17b+xzWojRQRdYim+L9Zy92FzYtdx21NYsZTR5HUoMimuBgW/ho4vfs2tATWIe73CPi7oIppSDqrfElpAKXuOgt71Xr0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 5:57=E2=80=AFAM Dev Jain <dev.jain@arm.com> wrote:
>
> Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

