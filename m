Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B413ACA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 17:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067388E0005; Mon, 22 Sep 2025 13:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017D28E0001; Mon, 22 Sep 2025 13:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F898E0005; Mon, 22 Sep 2025 13:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5DE28E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:50:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9866E1DC54C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:50:06 +0000 (UTC)
X-FDA: 83917624812.07.BEF1594
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id C5AE518000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:50:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YmPDBXrX;
	spf=pass (imf16.hostedemail.com: domain of belindagodpaster1@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=belindagodpaster1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758563404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FHtFa8h/QzHYrBs2YBbpVMAf21spJGC7Hur8tbJI0fc=;
	b=ZvLF4FkxcUWdZ8rnBvP9CawM+AhhoO0OgYrl+s7b7VZ+fvU7MEMgp8AuFTVpTuxl+vPtoH
	5uZVJWn3Hp6LLDhcjpErgKkaXB1q/pMR71pOkz/fCeoe+VuYOnXoXn8LTUQH9qO8fH3/on
	DVSSPe8k7+7QYaKjfFYeCfCNt4lsJIs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758563404; a=rsa-sha256;
	cv=none;
	b=Pq2l3ar83S2Vl/dDcWkwfCxCo0/6QmPMR2ImcPc2lixYLRHWc+snDA6afz2ccdPpeQjsqa
	8fQ9VVZynJJ2gEXMLHu7G4jW8Greu9T7yQWmrtYRem5R0va82B+nHqvRI/P4VFJuhQ5+j1
	bFYvPay1t3dzyCsDMjEm0FuMYVYvKhc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YmPDBXrX;
	spf=pass (imf16.hostedemail.com: domain of belindagodpaster1@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=belindagodpaster1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b5229007f31so3445754a12.2
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758563404; x=1759168204; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FHtFa8h/QzHYrBs2YBbpVMAf21spJGC7Hur8tbJI0fc=;
        b=YmPDBXrXRY5GbBUuSr9XwD9cI542YoZhScm+iQuIruou9uB2JuyzYMQM2NHQFGY5KS
         xpc5dqZVOWNFf9quLTMiDEVg3HiErKiuryMvB3IUvgLtNFsJsHUqRuBy3HczPmrPhXUC
         PzvAkKoatX/13JVQrdx4MpEGHnBSEauFPtzp9OPCPCer2uWcbziQce3Smm6WTF5ELhLY
         TY8toF6YYWRYqmnkSOAcESlNcTLCxx8oorZMAgSdZP9cYxlsUEfNRIDK1Jb03IxNiTOV
         UGM9eOfoNQVhzrJ1bG15GmXHPNVNS1gbPK+mjjfcrZVxazajeOVYGplfDytjkx5jHDdx
         zSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758563404; x=1759168204;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FHtFa8h/QzHYrBs2YBbpVMAf21spJGC7Hur8tbJI0fc=;
        b=o9hNVot4s5GKyhEYiB75oXFtYsWu6OF8F3IbofZBERsChi17/LyPuvhE+c3R7t3zCQ
         f6JV2/xL52FUFOmQj7O/773xNF3W3uJQGR2EplagNGJTu6GCctRlMr6VHxJJ5LbX+Foj
         0YE2NonVtMtBdkIclqlcyb3nXqtymWl6OmxwPsDKLAAhBBuy0jeq0pWP75NKL8/EBZTK
         MtbnnQ+V3oFFhZxTNtOf1JrGsBMzm9K5GlG+Wgu8I4pqnicjV7Gsxee8dWa1ugQ7ZL9D
         pbxfzKLM4HdK/unAIJhKcAl8me0R1SSTl2YgCISpXqJRGyQYML7m2m9m9uV+Im6i74P5
         4Nyw==
X-Forwarded-Encrypted: i=1; AJvYcCVAmDUWLVTEbQZvaB5AuYSkl+23BHRQlOkRcuHjgueRFRtt14pS32TAuxSIXcHnJ66k0EQ8+YhpJQ==@kvack.org
X-Gm-Message-State: AOJu0YxQT2b0kZjIOz6FB2wtkPB/OMgRWNToDnLedsyY5kqvTDPiz9nD
	yZmacumeq6QLz32u2whpQMoN/v7oTfNRTO54CqxuSm+sD+n/dD6XoDRdnHFdfAPQUCjFbionfNr
	aznleeFJfnwVX+qmke7cskEjxPnkD02E=
X-Gm-Gg: ASbGncsVbCtvD8LJW0wvquEB+W8vg8hdqKKabwI+0NUvlqtdDU5NulGBAHBkG32Moov
	/92VX229a7JLdTGCGJz7f8ypIzikeGK5m8O7cjFEd9vSig/JmL7oEjorwV7DsxeppJ6cETgpEyR
	X5sT4kheieP3bGVtHw34XunpwKcQbHqTXwXDC1FRQyi90PLqAg+qkjkDpnGebsm2IbdmhO6/ab2
	izPPNCFk+nEj0yhaoX0F7AzoQ0VR20JjFkzyNJHtg==
X-Google-Smtp-Source: AGHT+IH+kfInlKRP6BzwmW5CJLzBjlaEh9IOKdTwH7Bg4hb0Fx3dW8iPSuOa6KpfO+ji21LPcCpIsYS4sH+RQTME7k8=
X-Received: by 2002:a17:902:d50c:b0:26e:49e3:55f0 with SMTP id
 d9443c01a7336-26e49e38a46mr148739385ad.16.1758563403518; Mon, 22 Sep 2025
 10:50:03 -0700 (PDT)
MIME-Version: 1.0
From: Belinda R Goodpaster <belindagodpaster1@gmail.com>
Date: Mon, 22 Sep 2025 13:49:48 -0400
X-Gm-Features: AS18NWCj_l0AGoJdmCj76H-a4myay1NHIHmfBneHHJEPfuqmL1lcwKJOIpqc3w8
Message-ID: <CAK8NWP4Cr=VQGm4=Td5spuhmeVh3oJSJzD1y-6-Cg1aShASgzw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Cloud storage optimizations
To: willy@infradead.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org, tytso@mit.edu
Content-Type: multipart/alternative; boundary="000000000000fb5a35063f6772af"
X-Rspamd-Queue-Id: C5AE518000A
X-Stat-Signature: 4kp1b5zb1u8zzbubkf4magwbmhtj9qfk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758563404-957285
X-HE-Meta: U2FsdGVkX1+mJgeF5kuQYXhszAkroEdMl2wtBO36F5GF0NHtmz3tbdb1IoDwS8zmwOkBxP0BUuRyOogq1ZYmsVR0Q6zoVQvTrx1v4p3XiYJVTd8byuuka65OOpJDFDfJ/AJHjVz6CsOwERkts3+U3uL0vCVqSp3SXZGsZUxbBAjyEnxdKUup2IOpSLpJj0sWhzBKuL2LkbMcrQro7s1wIn6Dq6kaf//YGv6yitLSevkQ1poITvEiop/EJgIUcdT6HqCix0tErmzJXTcllu7aT/gPrBpr2iNRYXDWtdotJedGPhpBM4GN7Qkd5ElyH/8luyN+VtJUMPiw7YWmI1dOfpnD/y67yfGXJgyG9CeQXvwx5XcasbZBU2Ty2MW75QO1wwHYeEd048SNUwNzY7g2BQ5neVikfH7bFyWv7/dPIFIOoMZEQndhsjK+qG8JSHP0UrUYJfNMXAMgV3wqyqvT1ivjBPtJG0flazanbLOMcvVwOtZolQMGBpjCV1/MQFHsHc46zQ1dIGfcyJVMdP0Gx2ax0D3z9k/odOt3IUAZqIMkp5XPLq6oTsyUXB9P2mQqk3yCGeqZFy7sWQ/F/3dIIE3pFxK1kgGOr1isGnZ3zz5QAL5B0KloVokPa8Ku5HCnKxq90o0B51HtLTw+1rBqYz3VaH0cqtDcxGL7T2LXCbtAFVK7TNwZLc9wDojOYMqrixyUjqnEMAPhfa0JWq5GyxWudnxELzDY8Zvnm9fJYWcLKLJldFizeOwGYfjRHWZF0U0cDN55/k+I7sFZ8Jnrc67KWLwS+sbcNTMXGSGq1SwdJ1dLVo0JflD8rLQYK9xAQu8NfD2V2tUs97DCuPBh8uVzRzh7fM077Ipyk7AEv8n4slQXZlXT+ikJsp2UwCY0KtrUsYG4mtAIIUKJlLiBl/+SvUrnClAl3oyEfnGQginW/y/P28+eapjAaPWTaAL8YTAYmdqvAQCooyWhL2h
 qg13VUbR
 biQfC/Xa++/P87sL83De5AdBBhMwolI3xsZLuCA9HPXpg8Ugd89ZU+oSX+8ExxxW+FfT1fn4wbFXL8DqqiTekKp4oTMqwusOkIbFdiCNT2yZOKzDsyBk0JwSaVS1wKl2UmMkQCwNvASj676K9IYRwsIH80mRdCkx8weYtNprRhENNc5jeUQcKtQ/+9NKxT+DtN00ck+2gkEB3Rvvoy4v6XTFjCnPlBd1wAuAaNl12yoQkSzwkZG8/cg3dDKarAkmviVAcJG3tXQzc6hkqO1oXZzVUxsiUXUwZWsKQbUw2/NgPtvLgh5QenolYtgQOBziljHSGlQtfpG0hA4wbibThRYfMHuaCCgFAT1dDnjr3ItC/FBrKUi/prxKeGhINMPmO3ZCvMQY/oo9aiK9/9UuiAICxfbO0DWprfXNVXCcckBr26jpRhKcdnIVjj2+a110BZNziROfjDiFZOM+uoPhbD9y9S17CVANvbYPj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000fb5a35063f6772af
Content-Type: text/plain; charset="UTF-8"

kricketB

--000000000000fb5a35063f6772af
Content-Type: text/html; charset="UTF-8"

<div dir="auto"><div><br></div><div><br></div><div data-smartmail="gmail_signature">kricketB</div></div>

--000000000000fb5a35063f6772af--

