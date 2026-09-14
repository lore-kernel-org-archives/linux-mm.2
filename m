Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91741C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 20:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178CA6B0088; Mon, 14 Sep 2026 16:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123056B008C; Mon, 14 Sep 2026 16:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010DA6B0092; Mon, 14 Sep 2026 16:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D02936B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:12:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E15E41C1DBA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:12:09 +0000 (UTC)
X-FDA: 85213464378.26.ABD5A86
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf09.hostedemail.com (Postfix) with ESMTP id 91105140002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:12:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789416727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bg1axfGb6zQ6PjgEU5nO7cCnN+47b0zoxKTSzbMdZCw=;
	b=bU4dzJedwlhQj1Ic3BRVfxp7Z8Pqx8ltUd/9pXZeEiYNOfQhIMvgy+iPXeEfBMvLTfHLQY
	InaZc9Kpfwv8nWh+JtB9Qnjlfp9t0wSGthlqWkbLwI1o/gKxGLCEgnmXx527kFywJ20GsT
	shcjFddqS8t2oB6dtfp1Fc0iNwVW2NM=
ARC-Authentication-Results: i=3;
	imf09.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789416727;
	b=Fcs2TEmGGMWgHJYr1bQosCkC8VnmWFbXBDEBapnKIJxdHJ+Omp+jgrK7Z0JKOvfW4usfiC
	VSEkfX90xsjIVBcDFR7pUirFEWRZMOBEiX777ec6sGla2QYE5g79HLOcYui4LTMkJFYs2Z
	ZQPcihrazdLS4ENmJat49Bq6bUuw9JE=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AE051C1DBA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:12:07 +0000 (UTC)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F070A1A025E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:12:06 +0000 (UTC)
X-FDA: 85213464252.02.36F11D8
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf15.hostedemail.com (Postfix) with ESMTP id F32D4A000E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:12:04 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789416725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bg1axfGb6zQ6PjgEU5nO7cCnN+47b0zoxKTSzbMdZCw=;
	b=UfEj5Y/b80MiLkkWdx4OrY8BnMPDYd0HwikWRqGv06UdDMfTrhG7VmmG36gXKDyYNrOXox
	e+1wO/2EW5Z3R7jxj8KEhhC9AvjxwelF874SV//QHQhXdeKXzyWdcAdN21whPCn324vc0C
	8kb5BGpUoB1COf4dzDyxGZPR7tQefTs=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JCEqftGC;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789416725;
	b=XuuefYGu19xgb2t8gYOl8AwXupEsF31wo9kZHnOy/SZtzCxpd1TisH8mxxXMEiFkj5f7B3
	6hLpjZsvkniFYbXyByLV+G5I53tPI7mSyuUayFc5SIc/CvWMaYIHgUmMBCZ1N0SsrT7HwS
	frPtLt1vXZ4KhRDyNW3zqkS3rZ7m0Pw=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530d5fc2cd8so441951cf.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:12:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789416724; cv=none;
        d=google.com; s=arc-20260327;
        b=ChcT4skQpddj4izfEg4ESDHKwJDAyso4Fz0bgmrDll16w4pQYYxutLqlSGgz13GssM
         A4kpCIsc+OP95koxmyEkNveWix/Ak9ZDgltubuneTqrEUdEqPmxFjjM44sg+PA7eoYio
         yJvB2gc1V62fGIW3Qpy+oZuucRw3aW0IU9AXw9Wpype2+oSJl7+bTvwjasw2hT/rmnBH
         oZ1d5QeQBAYiEXb5d3X/9P63qshdoxBrf0UzBILRRnBpjwVivZoHsODUDcEhZ061Lq8F
         9aL/4joDmjFUZh2mfLzH+CUEyf6DD64y+bqEc+sVpsXig99Br2xGjDtKIDNfz0XSnFeC
         85qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Bg1axfGb6zQ6PjgEU5nO7cCnN+47b0zoxKTSzbMdZCw=;
        fh=RLTwNXHD+sR7zC1IVQCp2jrZPoYQRO5igeZRabnTzJQ=;
        b=fLsRieAPNfiEihrxmddaPet15fI4etFmUDzKoDlhK+iBUwL9ujcOjJ5RA8frQ2OfbC
         Hy/F3y9ow3bm5sIHRUC3Q8qzoD4dCRbjUTHBo7k4h6hsEklAynNnOYPH+fsFf0tTG0ZY
         43yvcmfvR2IeZKOET0311eZ/mSgAqVfYLaTmaiR/7svnRG08iaErU0B6q0tweWZniZ5H
         AKkJGFxDsnGgbIToGYcWfagMnDlFnmpxeIfMOYM2s8wP0pbjsfk70OZ9GAIu/IUsMsEa
         oKj9PasrXwS53zBiqdD2xjdY5f3KHXM1g2Fmha2qVPOBx9MHBt7dS/4Dlcszzt4rH7Sp
         kQCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789416724; x=1790021524; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bg1axfGb6zQ6PjgEU5nO7cCnN+47b0zoxKTSzbMdZCw=;
        b=JCEqftGCzRb6Ix/Xgfw0JZ7Ql/Mn+RClpDGyxntWh/qRA3VjgUb24ro664h+XuslQd
         Nz3hXbnPHi4zzISBG7KgIjiPtd8/S2yICS0sOwi4B3yMu4i1r3IWW+AgZKJUA9clU6MZ
         UZbDU9lupAEFceM2fQfCYKETZFunOQwyijaJfaMn0tkcdfMTSlNJaiif4h0WXCo9HeMu
         OZEdPCcZxhyfKXE2tTUt5FDtjwLYAJE0ghI9rEtedS+IR9mns0+2KgduSgR2bhlt94JL
         DsQ9sMPDThuATmPfYKWvk0vmE3uV8LR01se8ntN1vxSWao7A20HM9EQhCa/ZMTKo7IPC
         zNzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416724; x=1790021524;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bg1axfGb6zQ6PjgEU5nO7cCnN+47b0zoxKTSzbMdZCw=;
        b=NZ8u5+NQOm2Cj1fDSpUDW/viNtlR5YuCSBXNyODi1Exnwm5SqKp9CDpzvdfitWfBFK
         sET27CjS2ZNpKcjPiJjfKWAnOw+SW411M+bhueAdY6g7b8aIC7T30SSVA4VBE2tGjnCZ
         HhBfx49Bs4a0dsCIPsaMRgBOy6ajbEjG7NL0O7PXNzqYYEk76B3bUn4NPPOcaLlHunxe
         USukSAexuPqPX+fPkm18vck0Pv39a/44wckfz72jUO0JoAB4jeo5+YpXm77B6q46olzY
         /DBF7tmN+6rwatAS/HfQIl9zpmTuupwUkdA9p8q5Q/2xV1ds4NhhLyAtCJZmwKVO+qE7
         whXg==
X-Forwarded-Encrypted: i=1; AKwUvBx7z+VTy/XqhsY+PPb31nysZjT8bxQYAdL0oLoP8IA4aK4e1gev2Af2QWjUhVyI7e008uaYq89u5Q==@kvack.org
X-Gm-Message-State: AFuF++k/9NJHdavRs4M0rPecG0XnPDfur0StyPpoN8G7jGS5rQ93pYbc
	rHESPYL1nLr9kFJjjbQztAOD6wEAnBHbYB+3o0hXetrZnKaCYBlRX6pwWvl9XrFxJHOaqz1/6DC
	P0pP56PmRLQ+HS3fCfsSJI1nliwiXLrR6T1PSfUGg
X-Gm-Gg: AYBFou1VBp8ZfHrhJUa7fhESApqQdxDun6eBYzS0uMX9Y5cNwsuyVpwvnh3hrqNqQmM
	vawt2zmw1DMTvU1QspSCxdwSYwc+Ro78tO8yHfCIbu0xyo0DVCRkcdLiMXH9AkAGaH3yYWzNz8t
	tS4UmCgXhClDj+AKWhQ4pvKJzcBdbFp+NDWU3s9sQd/qYXHB4n10a1V0VgJUqLSxMMPGkHJl0WQ
	UTjnbNutVEL4p1Z6IMjQXnAFodXFPFtMJhWqxAKsKhd3ixHST+ysT8dYqMy+a0YbnnDypS0XqfC
	DgVwDtWI3K08sCUATGfjGZzAcxVo8YiV8IeUCvMzV+nCsoiU37IYSw==
X-Received: by 2002:a05:622a:5809:b0:530:3f93:9023 with SMTP id
 d75a77b69052e-5311a5c4ddbmr1403181cf.4.1789416723390; Mon, 14 Sep 2026
 13:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260914190631.3167420-1-surenb@google.com> <20260914124223.3ce35057f35313d7c2a6254d@linux-foundation.org>
In-Reply-To: <20260914124223.3ce35057f35313d7c2a6254d@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 14 Sep 2026 13:11:52 -0700
X-Gm-Features: AcwNN1UnFBJm-n1l9Hn4VkPc-yh4o3jkbFHyl_t4LpeFWz0MRhLHnyv0RbXI8e8
Message-ID: <CAJuCfpFoWjM61tFLiZ79ufr7TLvWBarP--nmtHCm7OdiY-95Gg@mail.gmail.com>
Subject: Re: [PATCH 1/1] proc/task_mmu: remove unnecessary inlines in function definitions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, liam@infradead.org, ljs@kernel.org, linux-mm@kvack.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Meta: U2FsdGVkX1/wMokVrpHcyNiGDdORGOtGjDh1+gIZD25IxYr8kb8ZTosRu8qUB1LyPBCkKf9oTkE/HZFAkh9fjRbopmiaHrySyp7/ovq7uiUdGMvtm68MimnK9YXJL4R2aJkjy0z5vZOBjyBZ7ieceUTud9Oo412wWlw0PiR7lvrMVbgXVvwuKSx0ObZNM36ZoG5VstknSR3oXnJDxVjDFpMQ6ltBe24ipkg1lt9X4yea8T7b31sCSf+RDKtgGAkfO6Tp/lslJj4H7sQn0LO4oZsgpAVCj3RH+3hTnxVSUYIU4xUkl5E12bd7CRV93tpkt0pya/B08ihDFz3IJ3a3/x82sXf0X9CQBB7N5+Idr8ENvBUIqQDwa7N4WRHl5YhUhOAt0PFy/btcBE1a8OPnpJn03QGY957tGr5EQP3ZlGNSSJQAromsLW5M7cxOT/ll7fYlZWmvBjRPLBpKUjS89RqtOOuOlgRplqryshVMhJtD2ZikHj8kYElEgJSYMyBbEOOU1UqvFsH7D2y/cjKwzD5o4E89j47dHSfmDh5MEidn3UOGDYocXnpLokS40zKZFmXvWcsqzuRXGrH28Ggog4JoWWYNA652rIzehBwmmsToiev9Rlgk1MGIBD1QpJRdJzEBKpJPTU5VCeJx/mr9/f7cunRZX7uTEKgcdIbK2A1HDRTorQ/LTerlJpylKILlTqPSA4T6BqJsbymmsR2su2qPgJhMMXHIURnt/Bcv3aiXiII0Y5MKa9ZKEDi1IpWVa2GQSgm7SVeRdDVJURxu4OXF9bxCrojFRnwHd5BpX91jUxIMZ9Fu16xgT1zfX7HyZk2xZ5hJDvOJsEJkvRxekw74mW9ps+HmH8EzlozXHqcRLzmR3bnGASIJLXQwxmfeOJTnBF6m40hBzaUydUPF3zvrrbJOYylR3nJwxU6X3JwLmbx78BlXxWVyBNYeAoQ/b4Plsl8c8AGezE8VcvU
 c9Rayfsd
 +BUnVfvUJy3ZYsQcV10VrrN/39jSPAUDudqezn+0SXRlfhGIR3uDeJXcVN84cr8RuwT9nGcSHKzU2Etosi/oZZiGyOuqUwpmRgbiEAfzZUKdHHFwRoqCQmRD1Of3tAns3QFj18SyCwzbFpfAxgXXUN0rLvlY9/POMu7CHELBLpc+Ew4X/RUFAb4rJUZn7lf3wPWWC2a2VTCTrkIBLTSg0Q+JSyyds8eC2FrlSHLXlwY4zdPE764FE9K+ZhrnCZLo9u714Kz90umWpdTtcuLWhyKv7V6BThjp4677bf1xpCu+DLT9Te2SFz1BEYOXbh3S4nWX4uIekWBiZHcmCR4ms8gR0BhYaNrr92Iw9ORPguGWcTfY=
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91105140002
X-Stat-Signature: wq696rt7g6o73orpfxbsm9swc7aygpwi
X-Rspam-User: 
X-HE-Tag-Orig: 1789416724-261833
X-HE-Tag: 1789416727-842645
X-HE-Meta: U2FsdGVkX1+XCIw7X/S2e+yj08sMINcTPuE03OtUNUwBY50xezsgut/NwA7kwtoh2kRg3H22sR1QqFJu9W1rhK/J4XCYTXSeDUNyZ0RM+C4x2u6hqqtXmnnXCTPCwLkAq1fKaMXmHHWyREpHhyHgBIQmGZNKTGFzsA/Cge93HnmCwlTrkTPY3/+ubwQ+p4Nf99oDQjx+NNZW8OkHW0dt/iHhcPmr4UTU1UhYVichhrBNd9RB6uQjWGR8nWBjj5C5hF70Z2QXKLC9qzaASM0/AlWRMWzIZSv1EtFnKiMohXh0OCgO+z5vbz6Jw2NKYtSNUZo2DW3nJ7Uf63IBP1H7Vc8mOJ/XcVEMF8S92WOLRFReQeeLyKEogz3vbgk7p8kl/rmBdwLdSmBbgxus+CbSYTaR+EPBVR24GNk2aUHhXlvMtl4/zjCOkjMTcN16NjrdrZiN0rlk1TOXRf22oNRk/Pz7zUse22L2U0LJmOTlDXFTe75270ekFvGxt9nTX0zDTJALYmBlspsLlKgNcyb2Gr3I28RINDiFgWGmXnq9Azv3sr4TM6xQYAPf7UL3yIvs4+GsbCiddz9+tzlLJuM13hi1j741telMMfQyyvKlpCcBy4k+FZQdCFkLy5OnP5TceLVaWRZnHruGlnEi1EKkm/Exx1oUdvtEvXe/3ynI/Hrf9S87d6tn1v8vLKj9rLJzpPEKpQLzAt9RRl4ENmqR5x+Kv8Agpn7i0CFlzxd7sX/EHlxaXVg5iTVW7NZTquRaCOUw806eeGZXrUXcrZ19gSICKH30FCqsID1nitZDsDtklufN+bW22EKb58zjzWSMYQ1xfPP8iCIkFas15j8aPv4xRcHBuiuU4iTqUD5e0VqCB0dU6yz8QRnaBhA8ysxynuJf4/ggdXe8avQPvYKU7c38gAOCOavKs9MXnSY9UvdWKYaJXemA6QA2I4IJBPC0Zw2H7/CiQdz1EMwFxqS
 rntCOtjh
 uzQ102w6M33mlO2xbSd4+ZBAuGLjw6b31VwWg1WimZffkGoUk2AEtspfsfYTNkH89Y1l7aGjFgyEt7wb5ljDbzJbkH7DH33wrdFE279wwN8y6O1EWbHBS8PE64/U/ZwG0oDDQU31z8oDn6PCi4O9JHoDVhrMG+dzPfLCh8uy4z5aj9KpAVHtkIzbgKRkDDOMLPN9wo6BFcz8LXUxsSdenV1VyPIoGUF+quboTyW6vpxnsLtyBGgumof9SfhvK/CRbWXBbk2dFetKNi/9A841aXg+ZSrr3AY/z31EQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 12:42=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Mon, 14 Sep 2026 12:06:31 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > Uninlined drop_rcu() and reacquire_rcu() functions are not used when
> > CONFIG_PROC_PAGE_MONITOR=3Dn. Exclure them in this configuration.
> >
>
> But there's also
>
> fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not used [-=
Wunused-function]
>   133 | static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>       |            ^~~~~~~~~~~

Ugh! This function is removed in later patches... Should I just repost
v5 instead of fixing up in different places?

>


