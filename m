Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 262D5CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859596B0099; Fri,  5 Jun 2026 13:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831166B009E; Fri,  5 Jun 2026 13:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747436B009F; Fri,  5 Jun 2026 13:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6343F6B0099
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:53:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A6578CBFB
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:53:17 +0000 (UTC)
X-FDA: 84846605634.22.00378E1
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1240D20010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:53:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NCgLM4Xe;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780681995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTA9FlvIednCscTWN84tnHX/SfpO4O8Fo+gKVZXodQA=;
	b=3T1+LGABpOvuY9CFLpagQ8SSbrYTHk7rGU95rMZNbl3hhXHJU8dD7SaXdVLZXDCiG++C9r
	ZaUM4g2OpRuPtcGRjgt8PAgGw361/E8H6n4UEs0s6rAIAAMS2IwTM5N8yDyML8CyGyhSpm
	FtWFNLTC/KCz6uIPRDDIMf/Xg2Q6iro=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NCgLM4Xe;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780681995;
	b=wjLVbfe0OdLWH1PENfNbybehcLylfxskY710uqY2gR83jQOLi72+iSLvJBQWXN1APV59Ww
	wcEijTiJNRHbaLDNkWJ0Eekkpac4168/7n9IVc6cy9X/XAU/bR+5In9ZPw3Qgu4N5ZmUno
	nk76d73jFh7EmoboKOXfG0OcXF2XoTw=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490b3637b90so19409265e9.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:53:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780681994; cv=none;
        d=google.com; s=arc-20240605;
        b=k2IcJucy44vEUOwYemKST+KmEm8yFETSuwUQTKPAvWU+OlqCYPFQTI/c/UirtHBA/s
         Bpr0Oc4exjvtfwlrh40pKtQmQsN8lXZ+dtszp4zSbboNnNHaEvdA1tzwyeZjdgCJq1RH
         r7u6Rvdd7hpCkSpyxmpMdmoCm9T90kxVOawI7sNSXKPl2wZ1TnE/ncrRwR5NqpUJ5xbX
         +uUWTJXwKquaZ/VpDrV/cCdj8Oi33WcSOVvLSTcJZ9dokg+F/62fpo5PjWGl8Nia3Ydo
         i3pFQfclb2w0Ydy+3LvxnMU8YpoZc/dFVC43Qaeh1xsVWqvOJgKu5jyjR5+2w/6l42x8
         bERQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qTA9FlvIednCscTWN84tnHX/SfpO4O8Fo+gKVZXodQA=;
        fh=qEEnjw8xFro3+vrCn+jd7XKNQhorgYk0tehWaw0DZbQ=;
        b=ED5NwmnkrfdZN3+xF9r7CunHhuUkNAcJ6PZkKGBlRrIz/xwBQwINxboCF5BIiJb3Ma
         hLVvys9ocdShwHodyNo0zecDYjABk810SAAVVEdXZ27BIGvpBuZGIw1d7eXDUrIyBsJZ
         QOvGqlfNjg8H8VSHNmoFj6AKvPmkt6izjNSbrYYWMu+W1wTRsAyyImZTkrPKu42pRpfe
         mZ4SBW3s123gUkGgOhgs02maOhVeG5n0xZnQFMboWJ28rXtNjqtppfJR1tzOp1w3d24R
         g74JcC3mQnjfnKGYKxhHbeuCFbVgYy08CAJsVGEqwWDcX80mRiAjNh4smK06oRWgS1UO
         S7rg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681994; x=1781286794; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTA9FlvIednCscTWN84tnHX/SfpO4O8Fo+gKVZXodQA=;
        b=NCgLM4XeSq+WVtvSrvZ2R+r7ZxHLyc61k5Sq63882RzyR0DsnVc396PDjQd+Nhmh7p
         RntP5foy2Xf0Qmly0nS54Wlx6gyHUS9KPLFk98g3OUUjz7aVVzJ0ecBfkd7M468JoGSC
         jStOzo4Do6ddz7bwIaFoiEKQbS0r/SyfY09ZL1E5gWtrtnVdJq4Dpw3E0kDg9Rz9NgNG
         pjedyV8Q+3swBeZJdkNw8jqnTHW6Nxxv9bt8AZQ7LxHT41ZeFyjxz0/ZbPUjv/bc5xUc
         ROszBr9CPHKFzi69mwPsfKvbED0a6KdvPXTNn7B9rH+IBFaMHOhW0S7wGKD8CbGwVMl+
         +WZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681994; x=1781286794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qTA9FlvIednCscTWN84tnHX/SfpO4O8Fo+gKVZXodQA=;
        b=BU2+jaDyY70rfVu0/lz7a6K8ncuzk0vFvycmfmk9d+qUphW1TB/LN/XNj+Tu4Q67F1
         smXtFEAW4ox2EOKedeMNQt4imtd790ydoQSAQ8TxJRUxuyT0HTnJCzQqy/y9h0h3sMCi
         uyYy2P9mc/2QFgxoCRVNNX3tUjoKJeRD+vdeHHCTcEoFQgutkShB1GuGNdFBJvhadFTd
         hjS6zAGknA5W6yAOkjbebXz9QDaRzUXYJq3RMeAmueji3zsqANx615nZwPLzTdWo/+7D
         LgQaJEKVAgT3j9ypgPdoBNcI7urnMX2qUykqzA0vnoT1yZXeFO/9rgWdXBjk5UhbE36P
         bmUg==
X-Forwarded-Encrypted: i=1; AFNElJ8mQmKf7PyZOrmrtZymk1r6B8mwrSptoXWK0+ZiaAqS3Y31a0hpEe7EYfBbQjArG09XhD2sMU8zsQ==@kvack.org
X-Gm-Message-State: AOJu0YzExKty2QJVKNaVa3Ko604BcA/FF1tZfoOrVgXoltPlJV+qRJcd
	GPNhTVOtOeA3JtrTE3txFsNglVPkRH5PKXxERj+/9cCly8hlnvJsZQVqk8PYHfebcD8JVxz8q5P
	3aiAbgVK1E/hN2JfLYpjQUG4T3Ts7Jhw=
X-Gm-Gg: Acq92OHv+3aLypzgdF/vjGpwGpUzNdt2WsbocEHSBu4GyW5lXMxiJgIHhuNrBbGy9LR
	PTriLV2ivwBbdstSpb9Wuf6DacOnXkn2U8urysmRNiun3geg0tVrktTmc33tM/BrdgyG2rPloRm
	n8PbmUtCRK5SdXjuqkQJVeCxWb+YANJyrYb+5ZlwIJVMcUcQk5aCxphEYBLqgiEKUGoYFIIczK7
	zlF2iOpFF71El3e5JeXyInT7GUlK/tok613qX8KojaM3f+NlHsvlJlsVwaX972aUlmJH+ohriOB
	1VM/FOfv5Ef+9a28WI8QuGobm0AQeqjUaShOB+HXy95dz5AgEw==
X-Received: by 2002:a05:600c:6091:b0:490:601f:d766 with SMTP id
 5b1f17b1804b1-490c259a103mr81171905e9.1.1780681993555; Fri, 05 Jun 2026
 10:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-7-hch@lst.de>
In-Reply-To: <20260601113449.3464734-7-hch@lst.de>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Jun 2026 10:53:01 -0700
X-Gm-Features: AVVi8Cds9JWv92CaJqjcUeceI82un6DYNngVnVC1j0rhSa7Qr2y-zBSmtjq1ibM
Message-ID: <CAKEwX=NR4=PVeNUj8=HL_uWNEPb_3yR8xmZCG8dGThd41Q_V_g@mail.gmail.com>
Subject: Re: [PATCH 6/8] mm/swap: use swap_ops to register swap device's methods
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, kasong@tencent.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gxgbewisims67ifu85y5dadbcjniiorn
X-Rspamd-Queue-Id: 1240D20010
X-HE-Tag: 1780681994-171795
X-HE-Meta: U2FsdGVkX18mwgQsXdSSoqR1ZFF50c34bZ4rZf0BjVUoyuOPyDq8aCxzmqKQJUc2Vq1MPSSVgRF6h1t7us12YFOHKb4ImwfrnM4HvFVb+azvZ1cBSDoYoIwQkAq0/3RkLo2Ry9dwaieJsDZfK3Ur9HY47l/BNqZZjFGk390VPeTHkCBwV3LErFova51lxoQRkEXmkjqOs2403q/S7ZzNWyRTnlVRNLk0eu9+iqNOGUEeyrsY+nMVYQvRiPMio3fgAJtplqwCtVJf+inmC3fTWJ8sPHznfCWOPMmaJvqK1fusfR8Ihe9RPbXh9INJ2MBJ6l9Gq78zBMpPTR5Ft0Waup/Hx7D86zgWQLPAvU2K0eWvZJeCopmXPs4Wldv0u6q3CFvkSu1PYjyLRJQAZj2ZGrN9fffHkA4HDKp/swICIvXPgwD++eG87WFNPGr7v7wKyzP6GFhxiP3PgYl4tLWWkNqAFNJnUVzDFz4O84n+hxqw+yFYH7qYNRnxhm5uUwJWWCQh3G2CXzdUGJUCc2TM79jFlq4UMX4PvjZNW8BbX5fufDU7QYyBlW49efpkkpAGv+tbOdzx0ECx9b8A0UXnQQ8OXwwV8TNgxkyCv1MZwgHBehSa48nZipOphxq9rf+VsvIxGVe/Z8c3zmoYtG+1Jf+wWDtKGs3c6EiRlkoXC+5C1lcdOAosguNLZYNCof5dogfC8t3sTLhLB3QW7QI9KCFs6fFYoHOoEoHEiLMZfvPdB1nNcnsIe7nSFJz8pmJdSD1kqA4RXCU2yazG2iziP9A1xmOcKxCOmlLBVhb3oJrFKQaAXWkzy0IIS9TP7GWrcg+m7Kpd48unbSYBzmoJUMiinTuyTmkuBr433Z7zdxXXbou3vhmWl1+twRhEniwOnzfgjj2wW0G9niPqqHJ+fCUA6Jlk1b/LblM2uzHL/GHgd+4wtVQaXGEH7ypwd1q8IicpUfIr9V9psGkU5Ch
 62YYAVAI
 ofkElAfaTyTMLsk4JegpMVYVvKBNNNP08vcBJ3wSsAXLVKgPB3xkWFm7PeATM5BeTozSktRQew52yupJDwrnvIYpLOFDjI87R69JZVcOGWLNnhcYaX/6tt7X5EN8VotUnacf4Ln5Do29EJX6+lkO0dRROdCHi7sMEOvVNBIcTNFdh4eSljw4UkaZsZDLOaVHg1rAKQGk1HrrGZAnyob4KrIi/NNFkCSshi92iyClOkvDiEz6iduP/MzUFvl4Aje4mBsJKuXfqVky29lKLMis/BF+Ml4o01C22QBViQbyLjGxfuZ9o+v1lhVTvKO6w/eR2Ud00MCLMmg2LRwgjQW2V277gjLpvv9beV5TWMk9KhoHC7dX39J6oqQFw07rRy+UKBL8DgsZ1u0+VI6QNV8qPD5DItr1F6iBCOYWZLQ3JbeIJ8kM5Rq009ICqOkDVeWhnA2ibkWe8fj/O7ZiMVp2+utqVyPZjE3ljhu5fJIq2GZnGVrNb7s7nXG09SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:35=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> This simplifies codes and makes logic clearer. And also makes later any
> new swap device type being added easier to handle.
>
> Currently there are two types of swap devices: fs and bdev.
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> [hch: updated for the new submit and can_merge abstraction]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

