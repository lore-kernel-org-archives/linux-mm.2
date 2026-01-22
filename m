Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692ADD6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17206B0300; Thu, 22 Jan 2026 13:28:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9B96B0302; Thu, 22 Jan 2026 13:28:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACBA6B0303; Thu, 22 Jan 2026 13:28:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5A846B0300
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:28:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DEFFD2DFF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:28:38 +0000 (UTC)
X-FDA: 84360435516.20.54CED26
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F5D84000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:28:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QpHq+Uol;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769106516; a=rsa-sha256;
	cv=pass;
	b=CeVzDGfqs7f/L4KsMZjKaUlCEMRAZYRvANHWHP4eqJRM9wRE34bU12ONmWtL0bRJsrxo/i
	5ITE8ON8a3tOxhXMS2Y1Rvccb+wF04Go7uIjnw+avxiNlRE/3NI/vZrou6XtedstVmHStD
	qe6t5j+l0p6cxxb1yVOf/+2+nao7+64=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QpHq+Uol;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmMh+ovoeRUCCwfFygbXGZ6j9n5SptMlw+qIxplX4y4=;
	b=ybGbbrZ9tzW/0D5aRFbfBqBU5LG6HGW+jP/XB1Rq1qGyQsYgenfoULn3CYYKb5kOA82Qf1
	0cn4VbY8+NVro76DPRyzbp00PKrFwRNeax/zr/TUxwTlX5ha/wc0PyFgY9yitPGlzRT9kr
	ypW0Jwn8OiFGJ/yYfNAOfcCbb/A92wo=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b871cfb49e6so195948866b.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:28:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769106515; cv=none;
        d=google.com; s=arc-20240605;
        b=eVvmg4Mrc76dmFiUyUoYGPhOFjDpPb8gV60nxfAO2cxD9M7u3HhE7L/a1f6yQyCmVd
         V4oMcht+2GIHrT0PwpxB+CmT+jaA8lyigFgvuxSSjDHYTO1WCbj8140A5c9sqtKPqym5
         7bku+fwgOKahM494nd1xqemvyNDZeY+U1GKDA8yF8HXy2h2ThmygWJo10bbPBCIU/eC0
         R8ViqGmzFQACs0v6CUyScwk44/sQ4lbaDj4jEHdZDsK7nmjAW9qUNkVWZAPLeZH7Z/WR
         IS3vhuIdAqRuGFC9qGekam/iyXcC5nzjhIQea43woW9+qM9uphm4lrwvSZjVOHxBba5f
         xibg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cmMh+ovoeRUCCwfFygbXGZ6j9n5SptMlw+qIxplX4y4=;
        fh=C6Nv3Aib/YbocFNFYx9a3A9DIXRrsp6vHIyoubM+iSI=;
        b=Bwq99AoD4wQGw6e74LNX0ud3lQHLBcZ8xs2kUStk12FquxlLKByZQswlDCfl/tWgUy
         Kt9w9XFNA4W3qWN33M5QRwZJZhi01b0EZ8WqlPjCzN/p0gBICJPVeV6ZAQ5CMNlE11V4
         FJtTpUhQzbURyzK+6Y4aAoNvNmlD6h7RhFd4X1lWlDBXoUv26QPMDnqoznA0rF0VlmqV
         gSXuVoCwuKLNU6wAPg4XiM3X6i0fNLCPmMqOoDnN6MbN6Bcn4L431CNTjvbAtL5gyi6n
         wYfxgV2Uvi0C/ac1zJKsoiZ5HJ+5ZCf4gQKl4xzHkZlxEnKiD1cn2nnwguZpKBvfy2Cz
         dFIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769106515; x=1769711315; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmMh+ovoeRUCCwfFygbXGZ6j9n5SptMlw+qIxplX4y4=;
        b=QpHq+UolxgOY6hyRat9ER2vrNdXULZH/vHS62xFRBeVrY8NZi1RPRchRAClrCEnIXh
         UfAfgfsELNQ2nHyqAmsd8o2Bzmv+ySHPG7yF3iW1F1NJc0i8v9q4U38GQnpbKOTRz4xD
         S1AcjZQg44yHytL9VCIAr3Iq5hmipVu15TPVX2/FXd85rVDAzFXbjqEVVMfr2F/IAYWN
         XTCkcMJEOsDZw3+sIT7gE5rKGNx67V5fpzqSJJXlkAd1wavvclwAfmowgcC6ThtJeB4+
         gFzc8GAB2WDUvRIXHbXctN5DJukjJNyjzgoUKqDdVO6RyW+J6J4nGkuy8Lq/1edoJ5J9
         WVAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769106515; x=1769711315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cmMh+ovoeRUCCwfFygbXGZ6j9n5SptMlw+qIxplX4y4=;
        b=SK6d0iYCWlqyFqDfYvSFyxwHgYSeA/Bsxr31RkAYuro1+JgDLGSTPrnWZLjNLALvp1
         HqUUr6VK8FrbVpJ8bVg3tmz9Dio51nvGHpI3O2vIyBYYEnLs+ml8W9irdPPIFc5wbXZk
         vZaG+G9l6ry4OcISwY3wNM4nAEa83LtM2ITftWiGtjrdxZbWhmdokJrq8r7hBiqUIYiP
         w7H9EZbn08FVGl9aUaGU27kyYoiyC7pDA9AsKafBpTxDKV1+3rCmBGSAng+q+/tI9i40
         YSL5F1iL7yGqGfLutqk4iG9yVnsWR2RJ7Wk0gpjZ8vajkmxtAPU145zWMGri/CcYQUl4
         Zulw==
X-Forwarded-Encrypted: i=1; AJvYcCWfc5ZBuIN2befbiBNzJ3mvXMLcSuJPWI1ZSdvm0RYjKntngvIBxKUDOaeQPPWEOptdwe3I0Lz0qQ==@kvack.org
X-Gm-Message-State: AOJu0Yyk1yj91sGJJdhTooXsv7tBztd3sm+/bXvy5m4ge6oWBnMiRNns
	dFbcMppiz58gMdtklz4m5MEEwxZO4ALP+VzcxlABAt7B3Xhq44uAuXyHBfpZQCOFFBHWhv3J0XK
	bleRiDGOfRQxGWGaXR5b/qOSleLcaPicvci0tvP4PxQ==
X-Gm-Gg: AZuq6aJM+zcbn4YTWAvVHhXvrb3kgbyVKja6TRsP0vMn+DLnqfrV7hLB0rJkaIaqSTr
	QaZhH4poxfKNlexaYfzCU3VsxdupFixGOlR1DBNwGp+jm3VsrO7R7PaaL+3MADgWG985uNahGrZ
	JA6QB3w8vhpWK2EQxr9hrDqaIhjVSDBT7F32OW0KkQLYaXQ9h3EvR3L/Xh7OyjdeD/DRtQXr8LR
	f1oI6ZE1VIfAjzTcdG6bZTNHc/6R4HVsBecX+kgwxrXtLP6SJkmqaRPBKjEHLq0Btvu2jjj5Yym
	AgecFwyqHaAv1iTwnocNq5vDDA==
X-Received: by 2002:a17:907:25c2:b0:b87:1b23:cad3 with SMTP id
 a640c23a62f3a-b885ac40b17mr13522966b.9.1769106514941; Thu, 22 Jan 2026
 10:28:34 -0800 (PST)
MIME-Version: 1.0
References: <20260105165839.285270-1-rppt@kernel.org> <20260105165839.285270-2-rppt@kernel.org>
In-Reply-To: <20260105165839.285270-2-rppt@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:27:58 -0500
X-Gm-Features: AZwV_Qh8LphdBgzf-rB2D4uKAJkXice2g_NEcJK-xBvMhkC97uW462CJuKpoRTs
Message-ID: <CA+CK2bDkVtwrCB9Jb=gSNC4CLgROJNHChjBPP3yYcad5y6AeUA@mail.gmail.com>
Subject: Re: [PATCH 1/6] kho/abi: luo: make generated documentation more coherent
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Jason Miu <jasonmiu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F5D84000E
X-Stat-Signature: 7n4qjesu431te3q64f67xr74dr6qi961
X-HE-Tag: 1769106516-45617
X-HE-Meta: U2FsdGVkX19Qmtq/dtk1EfDND7k+IzVvuIIFQ/E4+QavjlEiOfUopIV7QD49Xo+L1v4Eb6L8zf2iBKEd4Ue1QmMI7akHOPaFRE3a7RY0Y7ANOUVsW4lScvAvVRfDcSirLp3VOOdIN/MwKOW0pKktPOpPWckzG962jl/2Jiyf4c5A3n4PiqlTIWebZWnonrx5iKra2ioMfZzoFObCKAnm/mc9r2OmF9d5BXh5REb3mJJAtqARxvXEiYvyx7C4mVT16iffgaIHr0PvO3he9i8XZ5fmwIH1DSOMaKkn7u1nce0R2FuhYwDdXGQRTd2DjDtHlpBfHJqjijODiC9f9UY7HpbLfkVtOU8TaYPAt6vL+CWxknyY7BPftrcW/yuLKGkajKuc1bJlCOsZuP7LDXje+iwR9FyOi4mixYaiES6WoUCpxJCR7IojI11B4uZKYaNlL+cYqop7/IVnUFYKUXn1xt1ls/kYRV7/2dZ5OKNSVojMx9/GfpUJ9IyzzcR5pyfRWhSqqdSPa5Yf80Jsl0fQyPJRwSltHtuY8ruvSx30qo2lMwphFdpLH+Xw+PrIonQ2jgPjosh5d8ak8CeXnaHXz3DEI8BMd/NnKUvD228Vir+QJChWv/TMFBa1xqIyZdxIl/okkjv28Qf9qVeIsDLX9D+gy8ttVvZitZlN2lBTfIDlep1orcIZGUmY9QU3/RZ9pGMe4FZa8rLethh56eJXsccjGucRHFXsEPQucWAkjxTG44MNJqfC7QuE8lw+XmmCuzdNiRiOhvRWDGEHoaVzt6vXcsd7BDMCEkptWOxWClJ1F4FF0FTD+FdS4cOKlFVdG0xt0uX1zMx65or0n6oj+ZF2lrWLb8rA+0vWlgE+R2HF5MV9oS2dy82dpithnuqjtXtceJTkrTvB3ylVBA+iR/s1FyNotHLB9XgtMEk0DxIi2oj2I7eZEFRiXOHkmyfKQo4LMZtcaqvlFUiZaQP
 zLtoCNXr
 AFd0KjZa1+7DBWV9FC4S4q4w8iJ1smzeM/K6ZuXukmsQNx/a5c78Jj90/5sgltSw8LCsMCtGtbC3U7qCIvb1+jERhHojGXpZzDWX0VmeT/x8kA4zeRM09W2mu36RPLZUlJQ7JJTe1XGwy/gI3QCPQENTcwzhH+9OqSv0wgJgAJfO314Zn1cSNSLzU2Krim6ZfMCUxZquMcgIsCXRorOt9pN3jNB3EGxktpeAfB1UidSHHEyjaQ02FLeTvF8kwIlcR+B/FBUsoliL0tLK9loP7me7GhdG5Xfs12fgKEDdl2P+A/yr/I2LbmWhRu0GG4HE3l42s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000030, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 11:58=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> LUO ABI description starts with "This header defines" which is fine in
> the header but reads weird in the generated html documentation.
>
> Update it to make the generated documentation coherent.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/kho/abi/luo.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index bb099c92e469..beb86847b544 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -8,10 +8,10 @@
>  /**
>   * DOC: Live Update Orchestrator ABI
>   *
> - * This header defines the stable Application Binary Interface used by t=
he
> - * Live Update Orchestrator to pass state from a pre-update kernel to a
> - * post-update kernel. The ABI is built upon the Kexec HandOver framewor=
k
> - * and uses a Flattened Device Tree to describe the preserved data.
> + * Live Update Orchestrator uses the stable Application Binary Interface
> + * defined below to pass state from a pre-update kernel to a post-update
> + * kernel. The ABI is built upon the Kexec HandOver framework and uses a
> + * Flattened Device Tree to describe the preserved data.
>   *
>   * This interface is a contract. Any modification to the FDT structure, =
node
>   * properties, compatible strings, or the layout of the `__packed` seria=
lization
> --
> 2.51.0
>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

