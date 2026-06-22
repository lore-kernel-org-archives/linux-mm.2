Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B308CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 17:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452176B0005; Mon, 22 Jun 2026 13:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403F76B008A; Mon, 22 Jun 2026 13:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB656B008C; Mon, 22 Jun 2026 13:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0136F6B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:57:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 735091665A3
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:57:45 +0000 (UTC)
X-FDA: 84908306490.25.70D8D5A
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77511A0003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:57:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gjx98eF1;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782151063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWMkkw80MANt4r5YV0GD44Um7JLS7FMoaybOL0CoS30=;
	b=zJp8v1kvNI2fwi2bGH0HGoneEoE2uTRYTRtilCpTd/ylzSuDCPebackR8O0YP1CimabAb9
	JKn1dsi3lsFzol7eLdIsud6P+1Ai244gqjO+LwmiWpkWUUXDSO6HyLJe9XXdZiXR6ad9bO
	GR/hcMdDx1HmNsh/UKEW9tXaHXRCt4Q=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782151063;
	b=zhwLFDtKdFAKhFC3lLqYaDuAXG3u+7Ph/SbakVSm1ISEYjNgA0gljX7LABj1/9K+4S6TT7
	WB+ON4b/F6NJiirWhHyq91noZEBwjE89FJHGR9ayrIcov2BVtZFgmsJNlGpK1pc8/0zYLt
	+AOIznBaEwlCALbdwtIUMpkiPuLSAoY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gjx98eF1;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5177d1ff061so23251cf.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:57:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782151062; cv=none;
        d=google.com; s=arc-20260327;
        b=gWGJYw9YfHeSqrX99+8y/4h/3aid6lpO0zaeCs7AUdTMU4IbWfV0RSZGXp5Q+6wWKA
         kFPcNZ2kQXygBf+FNNR0tx8b4jAYmOFDjrrouUAJ6XRosLILKKC1aWnSniBhG27mS/wK
         m9VU3y8Yh0e/jFbDYTbAD9EgggpffIX2tUilB4I77Sptlf2RBWx6NNriKC+TOiJeLgSD
         YozZ0MaOmEJNG7JF58DU3gmceLseKfnMiGqwFoHNEBUukt1EN2ZpdPByLzzjgfJ+NUBy
         vmTuYKg1h0asHnBouO5c7LiIWu30/nGY8ikWAgdR8ilLtNKe+Jp284JlgKdiULX4rH5S
         TJ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GWMkkw80MANt4r5YV0GD44Um7JLS7FMoaybOL0CoS30=;
        fh=rCsl3ZgrOnQFAtYlLDszO/97bnagwqxnde2+4v1FVLM=;
        b=U+Vi6gr6jusT6NEDfG2W8oZIgfOfTGJRcuEvfyvSjMI4fnvX90Thwjzaj8J257qqzb
         GJQScWKeNfNPR8k0wbOV6gZsfPVWZQYM8R62mTCqBusgr3xaFlxm8/L+Wr6gc3fU1bBs
         VCzrCXBf09DKwoDV7Oq62JQCSJaEQXgbFvp91tpKwBPIKMOGWA8eEuWn3TncJPKq345j
         Q6WyZIMOZrLA3Rpa2ufbjdq5kp2zmd3A+mf+z2IbsdQZ5mxW18Ks35EILCP0imfp9C73
         g0sMcVsqiFkecAZqhq/fw0iqIycztPihhl6bzQjvJJXxXtijSUmqDxJ2CSvJraEDmNAZ
         XS7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782151062; x=1782755862; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GWMkkw80MANt4r5YV0GD44Um7JLS7FMoaybOL0CoS30=;
        b=gjx98eF1fADA1evin4ZNoI2vnCctYWOnj5NT5by4/xRIcdiqDqMafPcXwNJh62OY9w
         Ur8u+w8a/Rpmn+ThcK4j/S6LJyGpHqht/yO3NccOTuSMX4eqXA5VjN8ulLsOfkmaLMdR
         cl9/uq1rZ5I/+6g4RiQu8pgkCNW4cJSIpo/pRj1wIZZPez1K+DFP55aeQY5xF65OmLXq
         65LuNEWUVbEAy5X2o5nWL3suNUFuobB8EOfhtpXT/4jeGrxvZcP+RvBfw6TJmahKbjlY
         JhMweNq70ajyFC4hNn2wljw2vGWmHio3luYs3v8EQGfjJx27idTUW0slJDhjQCRdp4d9
         ocUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782151062; x=1782755862;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GWMkkw80MANt4r5YV0GD44Um7JLS7FMoaybOL0CoS30=;
        b=YIKp525yHIZbalper0XEittY8G01L6xZuK9S6bsaloFhS5zFwAB7hBXso+Fx/FuJqa
         yqIqK6ulAlyMI8XJ4BhRcMP1kEzJW5pLm9vb5Uij84xYBLh0mjceutYa1nTsFkN2fDly
         dl0JSmGETaLyEmzxnB6gV5KXUaxDirObva8rrE2UNTCD/iI+bkaU2wYhgzfs03lxXp3U
         YYhMGKZKDjZhMWkYgWf13ESerOFqjQTIv1njxeNwrfHrLefPnFb3ZdHJVd2qh9V3yxix
         ZULxelDgMjfcCYIZPQsU/ssY5htpSd+Ox5PC6aQU0sBjE7K9FGPziA+PWo+6gfYoW+fU
         adYA==
X-Forwarded-Encrypted: i=1; AFNElJ83H9uB7qTkobtRJTCLUEfkXIh78HpMAxCLsfTvyxyl8kpGRcJbhfB1dcFbP2bjrakjb9RQukt1BA==@kvack.org
X-Gm-Message-State: AOJu0Yyp0xLB8GxYZieZfPpccY/8g41eFLfxLYrOdwHCfgPDA28d101O
	C8lrYMU2DmisLepYJ3yVNcxPGaALYeqqlbH978QkdPautLcattmghhUAWOJHczkHXbrWrLd30tB
	yeYCZXDK5VxflNUZFtexQMx6U59BvW+e4CKhRgCEY
X-Gm-Gg: AfdE7cm7MkNKAP+lku86inml8wxohoPWZcZ1fzlaDF6FghbZfd687yCj16QWtMQnJeS
	O9q0nAqGNxoAie8EtCYMSbt/BdBpjf7SwdiGbGZo2DBl5HnW2dJKIAfOW9HD0uxlGKsQwFKMRdK
	uaqHgtX0Ehba2jUeEZ5DLxZgpzilqEAvnU4sgq4Dsd5FoQQotQzJL6K+++p/rdMvOFgGjHnN353
	TWDX0LVVFadXBMIGH0/wDwtME4E8O77VeGDmFR9Y8zZ0IL14WjjMWE8agjD/0Y3h08MzhI=
X-Received: by 2002:ac8:7f0b:0:b0:517:99ea:ab77 with SMTP id
 d75a77b69052e-51a526f3a5dmr378051cf.23.1782151061635; Mon, 22 Jun 2026
 10:57:41 -0700 (PDT)
MIME-Version: 1.0
References: <ajV0TbwEyaKMzoa6@lucifer> <ajV49Fyogfa6aIjy@pedro-suse>
 <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
 <ajWAYBXHJniJAO4u@casper.infradead.org> <CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
 <ajWXEn7gECvgG7F5@pedro-suse.lan> <CAJuCfpFfr_SQ4ZDFojOkDKWbO2dKdL3pUPA06B2ZC-usUnYRgA@mail.gmail.com>
 <7ftrqtta2bw2xxtrzelrs46t7khr7tf2vmh2ur2mhdphtymlsr@rqbd3pfjxdp7>
 <ajk-NMghY50F6Sli@lucifer> <20260622095855.50e4276e331cb2d01db7183a@linux-foundation.org>
 <ajlsum91zeh-oRz6@casper.infradead.org>
In-Reply-To: <ajlsum91zeh-oRz6@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 22 Jun 2026 10:57:30 -0700
X-Gm-Features: AVVi8CfXgyRAyliFo4Za0NRqWcCus8s-Epc8nE_M6ZH607LHMdm7JUR2m8-lFu0
Message-ID: <CAJuCfpHaBFtgAyE4jum-=p3u8X3STi3e6i6==fQR+0ksaU2wwA@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead to
 VMA boundaries"
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, 
	Pedro Falcato <pfalcato@suse.de>, Frederick Mayle <fmayle@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 86gdahxjhjngdsus3pqizsqu3ouehbci
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 77511A0003
X-HE-Tag: 1782151063-33339
X-HE-Meta: U2FsdGVkX19DXFXqZfWKAK1g38UJnLHjZkjlmNQzqHqVSwjtdV5lbsfskVhFNAihkdhpdfWjDR76tE+dn+mLWS5Ry3xEELtWQnJmGCNkD9cCEseV58A1w1TwxjWfQ8c2UveThh76n/hwiNGHqpUMrkwEBtRo/GVFQe4eBB1e2VD9xibiTlZ3J7W+rgHgU5hg8FinVmXp7H6Vb09tJ7CvVLdtdQex3Uk6/OiREIN6c3N3xIVbwFDEPgMTGsWK2BPETYAZQGIpDWouyw9vkWKd+wp01PT1r67q1S8pQyZmj8k6eWDsgRFgLzbPusA9uNoPXk/f03vEV+TAjjU/eRDvOBGBgk5iQ6LbZRdEqarPT/TE9wM78eSbB5MDKq3OI9lwQa4X1b2LihhMAicpR9tIFmTxqCNuzVfXxDOz2TjfVfMRAwvEmPFmphqgWD3Zk73lQgQDPgcPOIXdHGJA7g941+JAHav9cI9xB+qgVD2q7QWPvaUUgUpab3tk4b0QT4TqYr0BiaCwG1wjbVqGVhc7ChJOcsO3qFGvvtQceBvFYuZzHmIXpX3bP7rLqOPHmpsB714m/n4Sw06PUgUD1HP1+MAdUjrlU1VCCG++l0RspdCHk7uzHEL44Wfj7HnJ3lFO84JfHwZWUBgIPf4u3KYZQ92ntgPtc15SZ3zqfuG/AxcYE6ZYHftQKn7lZ2S6pJd8Xturo3roJlmX9Veoa1ef52sGIbrWnxGycBEkLtCgd6TlSzMVn54iHLJJRRgRDV1f+ca/xtx2DLqTD7bZCAdGoMuzlrbqEO5GD7RQ0hPp1WJzJfdlXZKLOFpSxm1/XrNKDVfpD8P6ra+9eE0luk5XIueV/bduXp3NleMS2OjW4ORdmnnpPNhWhn2KdlscNnyvQia5fdow9tAp0tmiRth/nFSqn7VTFRplnXqyCWwIxn5FjsOGJu3H+iHUib+XBXKKX6RJjka/ng54Voss1KL
 mIK2ZsTu
 +T4tClvagXtTMwnms5KYengHuavswuG5VED/b5u2/TuD8rCpNBLErxDiLndeyUFfzrdfNgL5KLjXHkNrTfo3390Q2l/iSH3/qssoz4dO0Iv7rFkzxsE1KZj8YFIVvmxwAQ9vCBp51+3uOq/8ZuJQvzMGLA8I1ZU94Q1HrbeA3g0L9Ko8JKS6bxl/culrCYtni6RFAzfa8FnK3ne9zCtg0m2+POvihlcx/GEND4WDaqLkCQXSdfsXJlA52ozT2JKvx/jhDW+C795eGIW2PwD0YWOPrXmfXehS2J3qxMm4ah8WeKUxkC1SGgB8KqXLSXLijnoxT48hghNqcJJJ1LBbr0eHGSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 10:11=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Mon, Jun 22, 2026 at 09:58:55AM -0700, Andrew Morton wrote:
> > > > much as I personally find restricting mmap readahead to a VMA a sen=
sible
> > > > thing to do). We just need to figure out how to improve the Android
> > > > usecase.
> >
> > Would a helpful heuristic be to do what 7b32f64bc512 is doing, but only
> > if PROT_EXEC?
>
> I was wondering the same thing.  But I think it's right to back this out
> for now and try that after -rc1 so it gets some time soaking and
> bot-teesting.

Thanks for the suggestion! That sounds sensible to me.

>

