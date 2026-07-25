Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82E1C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE09E6B009B; Sat, 25 Jul 2026 11:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C910E6B009D; Sat, 25 Jul 2026 11:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA97A6B009E; Sat, 25 Jul 2026 11:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89E076B009B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:56:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81A901C0908
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:56:43 +0000 (UTC)
X-FDA: 85027751886.05.4EF2BD3
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8C74240005
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:56:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=R8TUIcXK;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf27.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.169 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8lliPLK0GDS8x8PyMcUI12+gAGgg8IMSmccabc8c1I=;
	b=g2SaaoKb10Xnw0seFO8hH0uoEf93j7Bpob0VThFM9/SBY7aANn5WIh1XH0QA5ALdWIOE7U
	VtIv3qHv1N+dlVqM5yUPom687Nv7LoVSJP/3jfkkiKCEtTPCpaS6EmyxXRrs9HQBa4D4qM
	BGGX9Sig5xtdb1mRswlRP5sLT7HfL2I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=R8TUIcXK;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf27.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.169 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995001;
	b=0yj2Us9Wv16lj49AFywXnCW15SU9+WuU+gF0GFDKzc0uh4wOcHZhJMYakI5z8a//abMx42
	woHgs+HWnwAykRT2r4HiIpQIs57UpPLyrddex7pUCeeyGFPAr9i19lVVBdqB8LucKEV1KY
	68N+dtxw69E2QlG1CaqxLwy7ive6anU=
X-KPN-MessageId: 6bfc4e3a-8841-11f1-a055-005056abad63
Received: from smtp.kpnmail.nl (unknown [10.31.155.38])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 6bfc4e3a-8841-11f1-a055-005056abad63;
	Sat, 25 Jul 2026 17:56:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=b8lliPLK0GDS8x8PyMcUI12+gAGgg8IMSmccabc8c1I=;
	b=R8TUIcXKO9XNZFGDPs3wAOw5ktWrA40SLcZsbsRW8mQPXfnu2TNxOQJ4ZEJ0DrUp2bnxWtG4ydYqT
	 peRhLPLp05vZ3p9MVH0Nj73JRqGAnm/3vUAKT9CwQserd7MA6yZmrwsk0hnAnpfELM9cqnJQXoCbI1
	 Y2BXmrXGQBqVDldrz69/eU909+DHPeYVyJ8YPQ7+XlKZ9BVWe/CzhkTuQ7KriYoOO/rER0WitGmJ7g
	 XU7+WHAboMpfoDE724R9lKSb34rBe71VIz7koGwSPLLne7WG3YutYCVlWgTmKUgtKVfU73Wh22lHvu
	 HLUI4zwoCqkzP/3mknGtriy0of/a53A==
X-KPN-MID: 33|mUi57wCuWvvG0LGVyxwb3o16GVAnNDnFpnvC5k29CIELTbHl5G/tJntfHmJNO+r
 c2262xMLDWXjAFTjkRUXPhg==
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|bIStoMYjiI8YkzJXRDUA9BuGLqllNgXfiKqZl/2NLxUx2TlVpFEynW3PgapxHlN
 7JNeC3IBFGlfLO1MJDdWFLw==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 6bc66b1c-8841-11f1-a998-005056abf0db;
	Sat, 25 Jul 2026 17:56:39 +0200 (CEST)
Date: Sat, 25 Jul 2026 17:56:38 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 18/24] binfmt_misc: simplify check_special_flags()
Message-ID: <amTcjW7tgdqfwogc@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-18-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-18-a162f7cb58d6@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C74240005
X-Rspam-User: 
X-Stat-Signature: cbtu7ctfuiuf38fpzhgwc1uuyrb45rxt
X-HE-Tag: 1784995001-63752
X-HE-Meta: U2FsdGVkX18RUzg/uDvB7XjzVWHPH4N0eeCWOBUtY+RH/m8wtRSvb9zbh/fbtUMqarN3jhWeXp4H5PDpdX9NG0T8JqkKnfQ4wYbhIX70Ty4R2Hwe5bateq4YL9YMDkOZLdy7NUQfITXMA/znDyOFPMfXA1WvsNuxdlBKNi/+1tV25+npWyITrkzZXZhiJ+KHHQ8ghWakIDXc2Z2WsJ2Ra1V1VDvE1XpOJED0sO9FqyQmv7lpTu6dMKxqTvP+aY63tuV4GhPZRdlT+9W95IMf77rvbuyKsIEp4krixykwpYWwgD2d/HoaPJHXvmB/99VUdgqzxeh139f35zWgo3olztS4YtX7PNbHnFSY/M0YoKW6yjY1HrSbCDqHSkULbl5/fIDBr6q9D39cqbIgbNfMPno5PWQ+lFwez8bOXU8PmF0Zz9mVFT38k+aLPxlxDpMpXqyqOg01h1/fsCc37RNA51Jsoi4rae8KPGnPYZIUB/N0ROQ7l3WQRu0VRgl/tNDO8D9DqSvpI3PcrDmOMnmgTLPpgqtrKj73y7vZAObucl2PK+ZQa34uOW+m140DpzvJbludJOdOuPJXY6XynIzxZt7xysD3c9BXF/rUEujSNod6O7poKE1OOsqAntr/n/Bn3CGb5REsv9M0Qwt6R7/jeP05NDdKOGIe7X2Yt86tsMWxP2lBcbFF9wkfVm3fR3yLzkFKMconuNII/MWYbh3QPO8/Bd8cQ9ngxDGQYdzid/S76MX0eUQVe/hRFFm1S7/AzEiEPU93Sccp6eyf8MuNEiuZNaGfHS9m4XV066mQfEt3eh3WiNMzme9p+C0LmX623DFR1g0YXXSJ8Bm+ik5378DGu06BuItv/bm/kcCL/3WjFvHfUKBUE5V3xwvhKmv2F6jLg09wWtjwoRxS7eSLfaKkO9mhgIkCVCv7Gk2p3ls2l1Bzy843nXxZLAhtuPLSYzzBSpjR56dynp0y2n+
 lHlraY6R
 wVibHwbvnrmj40/1DX6wVzECib0rQgkBpBpnVHOvwo1X9nGQ5NrENyY3oeukZSuSOUZ7r7Lk3fn5GmzhHn/yO61Ym3cwZWh03j3sOmgXTGzEJ/FOwzNz5ytVXGo5cC0SMBV7LBdbaKkk+vpyaB3QIEhQfMD3XVP1K9lcwMkSv3+EPwq/k+xORj4rzT9Bxul1hnwLgrm+sxZw9PqHlPiw6L7e7ZFLoYXMM/HKN8pnaz6cCSecDupAzVqdncTZ+uZ6cWbO4zMLuUHz4QmQINxb+B6B9p8YnDfJuD2I5vNsEqgQVlZALse+IJagXsXPZ2MRHhNSsWPWb5ydmwN5Cqv3hWWRHI2tfhHJaNGD9fWYd8Fl069s2+n7sArKuV66490nT7NioDa/AKYoE4hUM6l7UxfHNq7Tw01wjK66Oxf/FtJx2ZT0Ipi5CvQPfDN4uvGsaNOqYsBqwWop3zWPjLCRbvI0MH2LrUoK1xJa0ewjjKsYZTMttKRGUVoksUrNfUo49nSX/tw6xtK9WXQ/b2LnucjaLEuroradOaGu9V5EQ7aIqTtVCIlCLv0R2fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:19AM +0200, Christian Brauner wrote:
> Replace the cont flag and the pointer increment repeated in every
> case with a for loop that returns from the default case, and shrink
> the multi-line 'C implies O' remark to one line.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index d6bc2abc4a7f..d9dc9546d199 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -309,43 +309,31 @@ static char *scanarg(char *s, char del)
>  	return s;
>  }
>  
> -static char *check_special_flags(char *sfs, struct binfmt_misc_entry *e)
> +static char *check_special_flags(char *p, struct binfmt_misc_entry *e)
>  {
> -	char *p = sfs;
> -	int cont = 1;
> -
> -	/* special flags */
> -	while (cont) {
> +	for (;; p++) {
>  		switch (*p) {
>  		case 'P':
>  			pr_debug("register: flag: P (preserve argv0)\n");
> -			p++;
>  			e->flags |= MISC_FMT_PRESERVE_ARGV0;
>  			break;
>  		case 'O':
>  			pr_debug("register: flag: O (open binary)\n");
> -			p++;
>  			e->flags |= MISC_FMT_OPEN_BINARY;
>  			break;
>  		case 'C':
>  			pr_debug("register: flag: C (preserve creds)\n");
> -			p++;
> -			/* this flags also implies the
> -			   open-binary flag */
> -			e->flags |= (MISC_FMT_CREDENTIALS |
> -					MISC_FMT_OPEN_BINARY);
> +			/* C implies O */
> +			e->flags |= MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY;
>  			break;
>  		case 'F':
>  			pr_debug("register: flag: F: open interpreter file now\n");
> -			p++;
>  			e->flags |= MISC_FMT_OPEN_FILE;
>  			break;
>  		default:
> -			cont = 0;
> +			return p;
>  		}
>  	}
> -
> -	return p;
>  }
>  
>  /*
> 
> -- 
> 2.53.0
> 


I really wish there would be a construction like

  static const unsigned int bm_special_flags[256] = {
        ['P'] = MISC_FMT_PRESERVE_ARGV0,
        ['O'] = MISC_FMT_OPEN_BINARY,
        ['C'] = MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY, /* C implies O */
        ['F'] = MISC_FMT_OPEN_FILE,
  };

  static char *check_special_flags(char *p, Node *e)
  {
        for (; bm_special_flags[(unsigned char)*p]; p++) {
                pr_debug("register: flag: %c\n", *p);
                e->flags |= bm_special_flags[(unsigned char)*p];
        }
        return p;
  }

that would not waste as much .rodata. Actually, you could offset the
table and the memory argument would go away, but that is a bit
ridiculous for non-hot-path code...

Anyway:

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

