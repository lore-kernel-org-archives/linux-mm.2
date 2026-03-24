Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19ED9E9A777
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581D46B0088; Tue, 24 Mar 2026 08:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533066B0089; Tue, 24 Mar 2026 08:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4216E6B008A; Tue, 24 Mar 2026 08:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 306786B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:11:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C96CCE1025
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:11:31 +0000 (UTC)
X-FDA: 84580841982.22.B1D830C
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id D36DD140010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:11:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bQVZ0XAC;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774354289; a=rsa-sha256;
	cv=pass;
	b=2KzvJdJddGbm1kKu7wx8VNuN7AV6LxloNRU9Yo6vOFGbtCaa6hH58O4WySuo3LMTgWxlHv
	fi3+b4Kpri8AWN2tzwZSqkBPEuJVc5YUgW/XOxvuNYbdKv5TEaAuPjBcVW3iwVgb9cYVPO
	6ktaRp+NZRJEWycgqc2LnwNYRVvvTz8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bQVZ0XAC;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774354289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVM1FF62WMvqeNAJlDNFN7/rVLK9uveLNTLXoz5EJbg=;
	b=Mvl0tUoXhvzcO8dmSaV1FxDsQELDH8ABdKms0pHxAEbUOkDPlF9Tr/AiZcF+HeSjKMCoY8
	YvX3RnpPg3IKo7GQ0KyD2zmXwjwYRjTAKXN4sS1W3duV4gja44lBgP9H3ricToeAqx2IX6
	7g5dB+1x2zhhAlRYq+gAD+qAmTkKX3k=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-79a6a5b22f2so5351507b3.2
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:11:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774354289; cv=none;
        d=google.com; s=arc-20240605;
        b=b3L2OmQLm2K8/6YBKsxjT0soYJPbIrurb2OYrdn7u7KypoV6cMcbzuGx+ZKVNjO01I
         mPS3NyxHQw06ijBLLxDeEzaY+vaoX+2dhOM50MKtfRGXAWlNcaMETmzmM+6Y1t/GWXDB
         OMAPgUBSdOrMDQo66JO+sx6gWvYnRh5MMHdRSgwd1g0crOg3wseyluRrsrmrJ21g8F5U
         aCCvR+DMU0RSGqp5JZ2BavZmRHPamxzqQeyLdoiydzmMnVhNArsNaiaUACJ5z3NBPSRb
         YUOLkRYnVuxYAjBl5rnS7DomdrmWMG1YjOtKHxC0PnRz6hSWMhv1C5aJ/URPcvr/3yiR
         wpfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DVM1FF62WMvqeNAJlDNFN7/rVLK9uveLNTLXoz5EJbg=;
        fh=q7zvNd18CCVMrPDqd/IdekJALi2RUeGwL2j4yxv3mV4=;
        b=LjX4Sdh+OVhsLOrKsK0VAWoCo73bbt1nkEK41Xzd0haXOVPJ4uLqT/J+a9uJ+49VKI
         +brT69gaQkFltz7u/0GBtzh1lDqOpR9zo2rC49cykRDZYhkhJfse0wSrHNv8ZvYBw9QK
         hdcvmgSwel7004ZW1Um0MpU2py0KSPxQeH82TwaKEnMxUbTmjfaj5QOer7vs5MUhr+wN
         y20ZJDE4dqftz7M+kKeWR8llaWchJ13HMelnExIk68sGo14C6PiaKYiv+QQlWeRVhi5Y
         YRxW9Dvd6E+jPSdMDNSAHHfPFKBNSyoHAulH32tlzGFdYo7nv3mZRfsc8MUk83Kduref
         gIig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774354289; x=1774959089; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DVM1FF62WMvqeNAJlDNFN7/rVLK9uveLNTLXoz5EJbg=;
        b=bQVZ0XACYa7rVYkIzsOnxEKKvMYyjnA2eIPiBPeVX+QF8o/p4O6iBeZZ9UsTaaxEHY
         lbC9Ai14QlGiFIX3+j2xjQQpdQz9KNGYaYM16lKuCk4eRM2M4Ih18PgBFcqWJ6EYtQAg
         q4MQG+jm5KAYRscykO9EmMLCpR+KZPR65nmwStv54SlN0KP6TeVxSM8ENwQp1FFIKOlx
         0GX/KgpDLU6GPglG8rvxLDwnGDTepqXGyfdFrvY52xglzgqVg3Deg2HQJFWCAgVQbeQO
         8MdpNbjj+v17kkY/69/V/4fq+gvsV0hUSSf3+KJ69XCdeSr3q6nrPyto8XOPISh/rqIP
         RMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774354289; x=1774959089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DVM1FF62WMvqeNAJlDNFN7/rVLK9uveLNTLXoz5EJbg=;
        b=Hcrd00MnhPWDx5JOjGcF6heoF91438o8i3oON6xcAG6bXyCtSL1ipTD39ux6OjafvV
         wfGlMNyhM7zwH3IVAAQCl6kFGRgwdjCl86pFG0NcA84GKAE98XU5zwD/fuS+Spi4qHrz
         xBrPlchVjI2Rc9doI2bPi7+Mv6p8dbJX1vGtliY0HO9qZrDuk4OTgyLgzTVglroOeXM2
         I8oQBJS5Lwc/oN3cGzevHiTgwyGGzKP5YKP2ePd2OfWuY74TkSJMccftE9Y+W+TeYqYR
         Xjl/AAjIFtKScXcRzeLKuLsg3wBRdQoIp+A/7jCSEVCNwEZHhnw3fGYZYlpvNf2jyscO
         owwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsMadnviRWrAMb/Fj/mjkwas5Ckzww0J1lg6tagq/jq1VnSPMW2/ETnqNqo8LuwpDWGUeE6tkYMg==@kvack.org
X-Gm-Message-State: AOJu0YydTMnV6uFNX/+pEgk/ilQCNggxqEQJ0qCXqBNbz9KzxVG3wwxq
	c5Ap65ART1Z5Um45S3p1filPsgxPO7IHvgKOi6Xy1qpo8E79PcZ6t9uGb8qTaccoF1sm1PcBCBI
	hkQo1EMKs80qcHnnL36JUH6pEKgz7eu8=
X-Gm-Gg: ATEYQzxW3rPH34XPGBa6yx10pdidYMdKdU1CtcDzM9ty3lB+rB6bEre+VSiWbPQxNB9
	WVkrhXgJXwmZZN5rkr/emO/1c+Li4sLUa3G+w4YasrHGHbRxI9PtYExwaLdnZyyA22oSUIP+2JK
	19YD20S5VylDKio4vDZ+trb/F67HnU68GsJ3dl/jDR6mSpVni0zi/OTTWhFyuFnRzQMMMxBY63O
	Sx6RkkDE2nDByAHNb5+yvER44/7ZChm4dZgWrAOqG6at81PxLu0ZAYLUBKjFOPaBiLti7bDXv3T
	0smMyxUOmKFNBhojQ8vPS4dZ1KF1eD3ktTGpDcF0gswAmq5KEqF4H2KHXTZXX5Xt2wEtmnnzlYY
	5GqlxewSFsPEii/nYPMYhXQ==
X-Received: by 2002:a05:690c:dc2:b0:79a:649e:2686 with SMTP id
 00721157ae682-79a90bce3c6mr139784267b3.5.1774354288788; Tue, 24 Mar 2026
 05:11:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260324102909.26847-3-giorgitchankvetadze1997@gmail.com> <738799c7-1087-4660-92d7-006b55938689@lucifer.local>
In-Reply-To: <738799c7-1087-4660-92d7-006b55938689@lucifer.local>
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Date: Tue, 24 Mar 2026 16:11:18 +0400
X-Gm-Features: AaiRm53DdLyD00eNehlXLSKbc10Y6rFH1rUnfczZ_aqezxjSb37wr5B-UudPouU
Message-ID: <CAE7dp2reOAtHxhrw3C5NxX1zgqnN8xuM=GboeFHhNLR_gGQF8g@mail.gmail.com>
Subject: Re: [PATCH] mm: mmap: add missing space after comma in vma_expand_up macro
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D36DD140010
X-Stat-Signature: dqezjk38jj44njscwwdjh9bzpxheup3z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774354289-635589
X-HE-Meta: U2FsdGVkX18IUEWtsNRat2rDwIqUIz8mFQqYfwTX3e6u8EMIAAubZnDyC628tm1HOx7gy/8/7Wz5YWsl1TnHFongjh7R1N/i01izgfdFyf6CJ6L/DYe3C6SYnexCgEoIjav7zGyB0Kc8eFQ14qPj9Wa2zIUU5KrBVthAAF9x4nBK38r7YuyVdiQJXYcP6z/wzGgx5ndGPRO5TTGB+rcG1CP+6wHV6NEMW9sJDDjWI2bcY7xY1oGgEo1xWKWYso7IJPAO4ew4Gscm6m0tpV1NY+yAxfBjt8uyC7u9DzGe11VAQFzS78kZh5l/w+sgeUlpbU7j6CZy4Y51c/Du1Jkd+M4n1K7X1lIiUgt5k0Jf5xLHFD2ckPDGMGxl47FnOFnP3D/52MUhhYX/XOexfgTEJEtWWpPCweM0TBR3Dz0hzCOucOBCNcKMvkJTARNMNL4vL3XVdw9CHcdY5UR5k6mWRKNsR3Qy2XGXkP8a3CoEMWdFBeenO71jhgHO5vjH7wqEX6acwU3ZfW5+/4QnlJqXnWvEcjHi0WvtBMQ7VHAS9UP5yN0UyQDhr98nTrwWJIGRaKrR+2AbEKzPIjwvvjsZvRAg3Zlu74MHYhr2duocM798xAGxrhqjHYkCtiOWBCJjbS/R6v720vAEgUifCw5f+fKtMfI4g48EgpyHF3lRnTaOjIoSynwCgJmiEWJ2rBZHjsQhlFEEoPGM/MDsXJNwghS7+42SNyonp++8JamHfX4lBXxd/fNpS2l6kxtnAeO5Uyb2Beyswe6fCcRGdj9/yPax7yargM/IG68j1bI9WFi40B7cekGkuTXKlC/vJMwymoKpzMLqnaEpvDQs/w3Hx/Py0Z/aP+1Kc8k4AuRvWqiZWeK5o1lsTcpOLgr2OF71OSAvx9GVgzT3zvNmmj+yLTX/46QTEf2ISDQ/BX895mYcUDwCld3LYJAhnkCFAvLLxms6c+J2bHhaf6d62ll
 423AoQaA
 0kBNkdO3bHrjBtsOQGBH63wtdoiCZYYCK1u452GDZhnFZ9KleFZgP018zvAgDqMRaV8jnJw0B03LvrtY1LtkK5h1TOkzXc7PvHpsUDNkWaNRsM96rJAtIrHFWfDf/ctAdkRZcAXPJHnzR30N/VYmG1JZs5MMlHqGCBFjnjsavvLfzSFhntDoFS1pY6ozm8/9gwup+D9YiQRVr6B4EsOOF5i0HyjX4JvBcB009UNYHJh7zxxUODgz72+9mppxXbp56zLfZVPaKAHW/0jt8rZZokcQ8rlE5cXlawqgUkDqpLnZDH27BYlAb2dJTZrvLx0F37ezxiceKGRrTsF5T+2JvdUOdWJ8xoTDLDlO1BjvvV6bPh1W59k+ZrCaiP1qtYXg/MvVPAB9xP1i7IPx5Y01rHhmJEaV6NADeC4uQjKzSVI/iwcFsCfXnrqUjzbnbkCr7sWAc1Nakps/EWMVC5hCdgmmgiR3icELc3Uq2X+GOw1YgIeGJ23ockQrG+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 3:07=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> This is fine as an early patch but as Pedro said we usualllly don't take =
these
> unless you happen to be touching that bit of the code anyway (or code nea=
r it
> etc.)
>
> But it's fine so:
>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>

Thanks Lorenzo and Pedro, for the review!
Sorry for the noise, won't happen again.

Giorgi

