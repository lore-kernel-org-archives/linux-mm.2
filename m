Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C978CCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ACB66B010B; Mon, 19 Oct 2026 00:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D4D6B010C; Mon, 19 Oct 2026 00:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272B56B010D; Mon, 19 Oct 2026 00:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5586B010B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:01:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D016C05EC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:01:31 +0000 (UTC)
X-FDA: 85338026382.11.9520895
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id A713C40008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:01:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YIhlgnaz;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792382489;
	b=UGRzX5F2008ajUl0FXszcJyXEE7mabGemvJqPcDJ9EYsHpAvZV1CRLTsoCfSTtao1+3HjO
	vplBG6vprfTHPHNdR16J4DklVlbjSEWg4a0dx291iGS2s9ibhb3pmuHwlRuKTxSolCfJCD
	DR1klMR+gFf8u391iEbKwjSN2xaFDSc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YIhlgnaz;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792382489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5Us+RzdYAbnpmQtT3TAtyX+ezvC5k/Vrz+te4DAOOo=;
	b=TyrmPsEOrb/UFW2GxMq9mH2kZCQAU1cEJk7v6HG895zURx+SQL0+T1cLXFHJePg8TEbKB1
	rB/LYeiqI7vqL66JTqsvXVQrfgShpMbKx5jmK7BytZEkVEW8rXhODYxC2gnpoAENhQ/htT
	gJ2AMQCzCqklKhFenHcXRXRCt5cwb7A=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3a0aaa0fd13so1626879a91.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792382488; x=1792987288; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j5Us+RzdYAbnpmQtT3TAtyX+ezvC5k/Vrz+te4DAOOo=;
        b=YIhlgnazZDc4JUeXABz/9h3QOy3Atxkv/FLvTEMmxSr0WX41RV9lGVMh+NqLhtQ0EL
         JB9Py4XjjLidAOzvx9Pr3qLABYVJufLAvAjHChvlcm/4DBrRV2xs8sXvBmmPwY9E/0A2
         rZ+UJsM+122VMfCm2iGv+RgpZ+wd9Q+tu5Fg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792382488; x=1792987288;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5Us+RzdYAbnpmQtT3TAtyX+ezvC5k/Vrz+te4DAOOo=;
        b=hZ47Ha+fVYrRxsi8DClnegJUQ/6uTo4Vt3RBCKVt5QA6r5ixi0cmqmWd0RCOcV/3+y
         mLOv7u6ctT0s5JSs4m6RSS3QfZ22LlPOcnJFERuweVqbIunWMaE1pmQJA20lIDa7gv3h
         sWkm5REKXWWcDR4abURTa9SdDQRyOtB4NzGCkgo+MuNVK9vsgpIqdVIkaH3oPfWr+qPd
         iyiEI1YzFp906K2sobh+9udvHDqYnanZy6rxZ8utmGWrOb1rt/X6e/3vjcXun7KuAh4f
         QDe1yC0HEdFIBGZ3VGBQi4PktfSFV1I2+heN035um8QCALpLraYbxxOt85mLupSknTzL
         hwVw==
X-Forwarded-Encrypted: i=1; AKwUvBzRE6CxYjYHsVyeTas0JcbHej2ZqmxqWv9hZEBJLl7Wr5vK08CCvo+oNyeqbTEDPFIbU8ggMvlIBA==@kvack.org
X-Gm-Message-State: AFq9FYK4bRGI7Dz59g0PpoMFL+SdKUfwZRNJbXR/TKEboSHiwRClLV9T
	gvuTDsZl+B+BIBn9fKIwcXEoY6JQGkj8rG1dIyvCZdA3NKFXvd6QaT1dTJA42lfYJw==
X-Gm-Gg: AYBFou0C/OnVv/h9wkdX26Sl68gYWH9vLhUUd/zpXKKHpakG3Qht9Ze7AdUjiMge7zk
	wYD5w/RSzYoUiG/7sxvha8zhhUehqfFqTliZCKe59rOAK6wV01tHP1AubmtUfqjLnoLuBCDsaSN
	LXL4XVIUiAm2H4E5m4KOGv/07APnv2o3BWecb7ES8bRUSUJ5EhEXtrf5AJx1wV//B1Ee2f/3UmH
	HdT8FTnuAAemR51eQjjf902DT03LdQ+6SWD4buA8Q7+r8xV/NF+UcFTwpuU9XsDV9FfMhclXlwl
	WwpsD7FSeK3HRWyD2KZZ04CsOGFBL+ubwW4oARlNM/Gi+P2JbKPG59MLv1vrECeu1w0K65s6eD+
	iDQbp0KdAegNdW5nEEqRQS/rbD6s3jVXrgr8869m58lcbes14CUnbdlu/n51dl6yeJw3yAnV0Ye
	D+ebaQ+vs3nYY/y7gRb0955RuMNRrGRCcqzgX+UwH++xlbQOOhjnj2OJaDRlHCtVcvDgI5pRukS
	CmfNFlU434beQLaYI4cmsTUwOrVv8i+ydgSCQ==
X-Received: by 2002:a17:90a:5184:b0:3ad:13fe:41ba with SMTP id 98e67ed59e1d1-3ad13fe424amr1909945a91.52.1792382488360;
        Sun, 18 Oct 2026 21:01:28 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:7b3d:f4ff:823:5963])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3cc73c7sm7232815a91.4.2026.10.18.21.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 21:01:27 -0700 (PDT)
Date: Mon, 19 Oct 2026 13:01:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: sashiko-reviews@lists.linux.dev
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Brian Geffon <bgeffon@google.com>, 
	Barry Song <baohua@kernel.org>, Bo Zhang <zhangbo0325@gmail.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v5 12/13] zram: borrow idle decompression streams in
 exclusive mode
Message-ID: <atWV7iJpJv0UXXCQ@google.com>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
 <20261018035125.3120704-13-senozhatsky@chromium.org>
 <sashiko-outbox-176604@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-176604@kernel.org>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: A713C40008
X-Stat-Signature: qipmxbnin8ioqoot4wgppt37a1zx947p
X-HE-Tag: 1792382489-467062
X-HE-Meta: U2FsdGVkX1/bC1bLrpmU80FajZGELHSRZBQVYMrsPXIX3xrc8JL3rHMv6kX8MZx73q07R37nB/BkQ++2fEwbbkt3MvDyejKXG/4fWfCyFGjX/9R89cOMOZ5ecoV/GT+4vuXDhsiyw1CSaMti3mnAWlQTeGDRz5gmdlPcboLA6NkFzI2psFyb2ZK4pWcSa02fVkMYaYKJ5fNWdIiclNIEI2WfrkxlCAArc3Fcf5C0Gs2VmeR4XPzlRaOpSXOHdN+0scBJ87D41SDpPpD1Fca0bISEm4Eeti4wsP5zVrGnzuTZr3xeF4ZnRqMInhKzTO08uK55fOk28R7MBVn78OCn+oJm640RBrIWwvalX3u//nrru7sdsyExxBlRDpIWOubV73quy1zq5zq/RTeTGRhO6Tt9Kx5om0S6dxtfGF7fdOsuAnlXetXJbuEOOCyhuEO/8l9jrxNeq7wZHoW1OD0cqeH56fKyRQyZk6hA6PAft4DgS8GF3UnVFnSzxrUdU2jiU28j/tKYxbWthm4afUdmjHdAk9bmYfdFPz8Xsfqee5b9TyodnfceMv++O/ZbvsznFjj6fKKIvLF1mXupAJJCYL5bHGpCBRYXGerHwCwCJvQq2FLPCwXdZEHZoBxvSzPt7L20FIh8Uw8O8S4Ov3jMa190HsgwLNYOOAtO4vnoWWimGuMS86V9oJ6zS8MUFZkRduu2Bcmmewn0QrGq2zSFzIwr7L6XtYvf0qTo5IjwVGUciPT8XVb1m6aTkeR/H5SbB2gjMbkpelE5pUe5Dd/i8H1nomXv1DiZPaIaezTlQbVHyjC/KlhyGwHphq4kSUqXNkHJn5YJkZbEmwNov5u4V7HnSTIocYPg44N5YwrBk41f+GWlwvBHdfeKMbCdV4uRmcAQEAG9opIORP43pj9i9Gvs1ZHyabI4kna9fUxItxLtPOYV6yDB3OudB3tLXmPHk7tfujf3SA6Uhe6fsHl
 qLWb2BQm
 RW3k0pY86Uwi4VQ2Wjr2JXMErxyqWcaLnt62+ERYE98n5P61p+oVCGzbWod1pP4kCnTww+bIqTR1CcqkexjeKZrzClO4cgRL26MBtsxuRdt1cNTaXW0pzew4X+GyAfyTfnJG5Q7uVBt67aeXcTBubvD4RUWLOqYE4A5Vm3oVL68bid+OmD9XK9sZ2yqPLVNTZYRc9p1IqRNCvWioLKy7rpCrr8qcmBMcfBnomsMSArbK27XvsMA9Vc5Pd+1kcpPuBhflrTL1g0/WjInvr7mtzHNyCWruvdw1lV15He9h3ykEZXZ7VzeKvU0C4SHC+FH0RqrCXZfVfVt2ZF38y87wQjtYGph0nQhdTASZ6j2zhQlz5/mqI+oWb+a7IIjiRDuToe26Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/19 03:53), sashiko-bot@kernel.org wrote:
[..]
> > +static struct zcomp_dstrm *zcomp_dstrm_excl_tryget(struct zcomp *comp)
> > +{
> > +	struct zcomp_dstrm *zstrm;
> > +	unsigned int cpu;
> > +
> > +	/* Best-effort start CPU hint; migration during the scan is fine */
> > +	for_each_online_cpu_wrap(cpu, raw_smp_processor_id()) {
> > +		zstrm = per_cpu_ptr(comp->dstream, cpu);
> > +		if (zcomp_dstrm_excl_trylock(zstrm))
> > +			return zstrm;
> > +	}
> > +	return NULL;
> > +}
> 
> [Severity: High]
> Does passing raw_smp_processor_id() directly as the start argument to
> for_each_online_cpu_wrap() in zcomp_dstrm_excl_tryget() break the loop
> termination logic when the task migrates during the scan?

I guess you are right.  I'll fixup in v6.

