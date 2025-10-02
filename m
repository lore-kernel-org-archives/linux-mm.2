Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10212CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 22:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3F98E0022; Thu,  2 Oct 2025 18:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B8A8E0002; Thu,  2 Oct 2025 18:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A478E0022; Thu,  2 Oct 2025 18:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F24A8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:39:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB999C0624
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:39:32 +0000 (UTC)
X-FDA: 83954642184.02.63C81C4
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 585FF2000E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:39:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CehAd6d/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759444770; a=rsa-sha256;
	cv=none;
	b=e6z5MAvU6offwVUokclT1qLsW0R7imMbQn1QVC/Aqwf2VgfyEyWhiN1LFV8Z7HKrr1RbCB
	EowVhJoDAOUySgYDcLhLMBivoh1Q4Z1jNYfLfrRcBkmnbC65KbV3KZWVMfXDVEg9NEDrin
	03fxqJfh38OV2D2nmy1ITPS8B5goiSc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CehAd6d/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759444770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8E52QWTGIfO2NrRkEaHfqTdphgmYcegsGjZ94/TNcc=;
	b=ecqR0YzpQpG0jd5tEOPfL5+5j47EC0TILe2gfn1e8s+dsBgbJQVb0UksX/j15QDDIg6dfM
	+avji8HAnF2wvPE52TGOE3PMs23kaX356RZXasPamHTFdo+wb78fiP+if7Jj7z2VlbX7hc
	sjflmgbPS8keJsW67Ieixv9UGxasRss=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-27eca7297a7so1916775ad.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 15:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759444769; x=1760049569; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8E52QWTGIfO2NrRkEaHfqTdphgmYcegsGjZ94/TNcc=;
        b=CehAd6d/nw27whztdSiMAFswYgSAquxUkRLD8+VCYr2P/0ZaKPwcu+KsMWri7K547P
         54HGg7V4cfVvydv2/0zfsqaDxdpFar1+QucZqN5bJUHwi8QEtWZ+OMahvNeQFpEiQTUE
         Xv2bsTAga308lKhAHH/2Os3czURnWcniDAU9KbtMTXwmrJB6BTDB19i9Z1Z6pqTxliqC
         +fvK3Lss3n2xkK2Lgr1AKeIA1feTDciZMnxAxgLzh/lrq3Fps11N1xkYwB6iDAPEC6a3
         i/cV2FL1qXcwWQ5zEIGdVbJKGO3pogEn6NeKvfECsxhgfpVguflyje4Vm8F+2h4NieI1
         U6cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759444769; x=1760049569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P8E52QWTGIfO2NrRkEaHfqTdphgmYcegsGjZ94/TNcc=;
        b=hw7zDvhDbwJ+CyWX+/ahXoO9wnBqvvu5g92lsK0ToaDc6sSMucTaxMHGAfwq+Zi+BE
         gWj41AEegpqqJDbO2WCv4zvUVNihYce4bGXcDmduvtDE1xzOBehykdKyoBapC5jL+MPs
         SkZlSpgMSCXYXxlsrNZ+YL6yIHWRiB+wGaVSTfSSrrhYa3zQSDWIsi1X032UMEVRruSQ
         aIpkLCrB20mbmybW8l7rIYlKkXtKwDqy8XsRv/609jhI5PRDF0hLUK5D1tLd5QU8d7mn
         A9GyZ1TpAbgKxkURWGM9JzRspWSsyo6Enjtq7ihZ5bwGlbtUnDtXV/mpCQB5kcbpMiwx
         PJHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlgj2rT6wnqhE6Y+28OUEeh4l5DSKAahQTF3yXMDC061zobEItUEefyeuGyLaVuLCvJy8R3uTPkw==@kvack.org
X-Gm-Message-State: AOJu0Yw3eI+9bH4HT1O/FgibTAi2177PT5rHQk+un+6hD37D3Wz87Ykv
	5BWTRU1+2D3RM7ebptKwMyk5PDiAPRBPgQ1KgN7uA2dGHXfMgHvxXdMPhWG7ucGej4daXqR7h2P
	LTjUIHkZRV4qCZtoxyGnZwpobmTyGQCE=
X-Gm-Gg: ASbGnctkn+pwQPw2LR/oQl7g0PaAJHLMYkn0OilEkemejIE/etlM2ahheKG8PoTHXIp
	supIhqfkV8lM/J/Z5R6W6wyE4mTFjU02MJgld/meiIYN8aFPAxKkD5K6cDL+agLMKBIP8ixZKoq
	Y+lgakHhkbnn/RfTmSG81jrtxHbdAc+V8voxBdRUkR5MwiP4eB9px49mJIbOptcWTrjZTN87Ec6
	C0SE0zogs3/9FUQM7YzElB1Cwz8KdC9n3ACALMg2yMr072ZevG9OcSBuFA4Gif4hqmci7WbTuEo
	Hh8ZGIjTUJysnIEKexELAaYdIakwlELPbLjL3hOGDUsurkoBekqRUMS+1x4b
X-Google-Smtp-Source: AGHT+IEhRGnzB5EzFTBg5gYLUAKsYTD4tHz/84QxOuxiDXRxtdiTFAC2E75ntDwFb3VNaRgQPk1/fDRQR6NQmcoUJ5o=
X-Received: by 2002:a17:903:2f8c:b0:272:f27d:33bd with SMTP id
 d9443c01a7336-28e9a35324amr5544725ad.0.1759444769254; Thu, 02 Oct 2025
 15:39:29 -0700 (PDT)
MIME-Version: 1.0
References: <202510030449.VfSaAjvd-lkp@intel.com> <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
 <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com> <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
In-Reply-To: <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 3 Oct 2025 00:39:16 +0200
X-Gm-Features: AS18NWCqd29-UpjX1TL5yAY8ycRR0RhMhqsgiRqYfPBpAGaRn5i7wZcx5PXFDe4
Message-ID: <CANiq72kWWPAZ3gq2ktMpVeMKpWOU1nAmYi-4d-BgbuDti77ggg@mail.gmail.com>
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 585FF2000E
X-Stat-Signature: 4u35krsakekkirn5op1bpgbsehcubmri
X-Rspam-User: 
X-HE-Tag: 1759444770-837005
X-HE-Meta: U2FsdGVkX182iHY1RrqQNh6hUdiYIyDXhI7guDw4XpFr6Rij6pf+8oNUZPwuRV2aKhMu080qVlmFPAxrr/vwcc3acvmxsF+KoMrO4f755BrtzLQnYCDNxk9+YTcDqrUij3pTLsmpQXCgz8vk9/+Kd449BqGmkjQ3YW56nXtretiVgC9TOL5L51zzuazAOChXgpH0g5V7SdZo8wnjuw8qANPTIk6ZpD33QXBIIrT/F9vSOhd+OlpU+B/VcLENkaYGlN5uEzs9L7VOS/hxYvoWyqB9O1JKoxG9HANpD+v2Q0VZUr4pxAaZVsF4Cvi4ANxe1o/HTRr3VDZApACD6Gpqyw67nQ1fqbpdHazT8mwRB1SedoL24OnDktTIjpic1sm1BTyYF5p1xzMhbvCh2UvyptnvtnNV6anJ8lohpd6vR21XSFQFDXV5j2ZTKynblvnex2wVyAxqRoDSWCPUIa1yeFYAK8RXzj6bvpHv5IyPxwH3fgA2FkKdcJxX1Ce01M5jqBRWIqQxrcQCQyYceaUJ6JNmiTcVr4Pjh1zNBPvT067XeUE6wb7f8OAAQa2GB8ckfSxFQN9MDezHg3+CQSMRqCCJQHpjmrTDCJzSYXI2wq/NMZ9mcHtlvBSV0h3qQ0TQTcAaX9KVAtZzQIv13BTbPFY87TggHmUFNXwykG2W7vDMeZHQqRS3n4Lv2BaBeUllZFsjl1Qz7LaQZ8BXDhUHiw8rftY+2BW04Y3iKDiqD/ITunR12pJq50NWFW94JX2vg64/L/Usai0S+R+Q8l3jYSgzlFrI0qLO7O5t7zCKveElccQJB3EGuQ2BtrGf3IgP5HhYYzHkZcLmxCgJU7COigwwjIDb1xwGcCifNV+VjqBblviOKMhaeCxo3sZrgHqxHoAlwnM++h1tAoYx3izlZSVLoH7mRYKGfIx6e8q5avEqJjsvSmGB0Q8nN8vUKrev1YlPOI2Yck1+oKt/ySK
 xKoq1skE
 YK9Vrz/sql3kGyRFDZht64phA8aWUyvUxZTJWCD/WLERd6mTocZqgSwm+eaT55JPt/Z4p81yUhnCqvf0mPrOY6t32RdCrLFDnw6EtgNFOf83NmKAKYdjifXVjizAxuGEDnnizNGJbl18NPhMtlDq2TmX46isVorwFOczCwvc951b7oY/6Ksbi9gk4D9D3s/9yfHFqEDx9IcgJCBW5gpaPhmLUMdPBFzGUc98/1muJGfzCa1Qtjog6+JvWV3YGmz07ENWGYsmkJO8qJ+7cpXAYjyPKCuoVErJ+8NLFY6BH5HbK8lGT1ObzglzcuMZDen2+BXXlCjN/fv2k6KaR3QFP3JKb5/5hFtRwrusvf0zVy4xxGrovYr8Ih2FRzFU4mOeJYLVYboeeNDWjo0RVEg+xTBlXv/gMQpO3Z1gGGRRRJL3V0SkrXUU+UdeLPT+DglkEGJyMkB2CBFaI0Ghdv5WMh/6PfOvpNknJNyWjJ2haIDW8OxFgpnJPF9dJdfF9hTB3AqD91YV8N5bf5f8uRzcKr46IW7F+E2KhcXAn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 12:27=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> Sorry, this is rather annoying.  Rust is breaking the build for a very
> simple patch.  Many developers aren't rust-enabled and probably aren't
> even able to test a fix - my attempt to get a rust build setup working
> didn't end happily.
>
> Jakub's patch fixes a kernel crash and needs to be merged into mainline
> and -stable reasonably soon.  But that is now blocked until someone who
> knows how to fix this error and how to test it gets down and does those
> things.
>
> Jakub's patch is present in current linux-next.  Can someone please
> send us a fix?

I am not sure I follow -- the diff I gave you should work.

If you have a branch you want me to test and/or give you a formal
patch on top of that or similar, I can do that.

Cheers,
Miguel

