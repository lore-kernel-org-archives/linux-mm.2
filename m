Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0DA1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8664F6B0005; Mon, 29 Jun 2026 04:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8163F6B0088; Mon, 29 Jun 2026 04:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CFD6B008A; Mon, 29 Jun 2026 04:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D78A6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:56:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB7648FA39
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:56:11 +0000 (UTC)
X-FDA: 84932343342.12.AF1AAD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id DAD41100010
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:56:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GwU3YJXR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782723369;
	b=EZrd46/aBkz/9qEz+TQvq8JhLSf+ynVx2g4y53Xm5UUsJELaVDn+TMfokAfT9u95Mcfe8z
	DYkv15Lp+u/NyKb0bH835JP/x+Th6j6O2ruEKfU2p05+MH+2ar1uyZrPRovP1sg+9k39fY
	KGlh1m3F/cHAecqJ68K5cYAGeuGiBTI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782723369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MjjLfoAnCdYSBQMHU+LNPQ7Y69v0MhSYKVpOdD7ztR4=;
	b=J8CiHT+7TAY+3VfxJZ7o4ylQuTRE+C1C4Ata3ZL+PFeORJbXtvNI7NF5CF2EKpNg1Cz4tp
	iwK/EV20tho/vPGLlDkoJeAtEPyQorNKsOExjaiyzixjpA/uLlOJ8PqFmwJdJB+MoB0ZG3
	2zeeJ4k5fUQGTewlXNzjA0tgK+CfpzA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GwU3YJXR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03C0241572;
	Mon, 29 Jun 2026 08:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8BC1F000E9;
	Mon, 29 Jun 2026 08:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782723368;
	bh=MjjLfoAnCdYSBQMHU+LNPQ7Y69v0MhSYKVpOdD7ztR4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=GwU3YJXRw2/+yv1fTqnt6eVUxhDAcOuivlMebRL8kpMszPEkVDZp9KZvr1qmRJkEj
	 ndYeJ+NxyL9mh9tGB6OfPO7zUGCg3QXdX8430/N2Iysu67+wdAZgfcELi9z31tkr6K
	 Y9U1RVBXklyP6tItBZFDn3uCwDFuhK1NOepw5hw3nVpaTH/63SnR79X6vJtapM97kU
	 4oA9wlFsT8Mn2tdApNGT/6ZgFis6bRokFmsJyqXoLoH40wuVZ5jVFdTmfZXG0iW4oF
	 xcAky5dvfXqGgX8fxhaq09pJ6hXplxohoAPkJTz057yO88MJTs5krF6d9LLLvMX8GR
	 6aLMDBEccE6JQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/7] vmsplice: fix some problems in my previous
 vmsplice patchset
From: Christian Brauner <brauner@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, 
 avagin@gmail.com, axboe@kernel.dk, brauner@kernel.org, 
 collin.funk1@gmail.com, david.laight.linux@gmail.com, dhowells@redhat.com, 
 fuse-devel@lists.linux.dev, hch@infradead.org, jack@suse.cz, 
 joannelkoong@gmail.com, kernel@infinite-source.de, 
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@amacapital.net, 
 metze@samba.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
 patches@lists.linux.dev, pfalcato@suse.de, torvalds@linux-foundation.org, 
 val@packett.cool, viro@zeniv.linux.org.uk, w@1wt.eu, willy@infradead.org
In-Reply-To: <63f7860c-4f5c-4682-8914-27978b9fbfe1@kernel.org>
References: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
 <20260625101132.3859505-1-safinaskar@gmail.com>
 <63f7860c-4f5c-4682-8914-27978b9fbfe1@kernel.org>
Date: Mon, 29 Jun 2026 10:56:00 +0200
Message-Id: <20260629-bauland-knabbern-abgeladen-c0acbfa62cc2@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=560; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6ZpRv6SzHMXp0xQtZa31f3aFronDafFEK7j2Ogd9m0w=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5GStpsto3L25ZaHM588TTeVIxjm8PX36fP4G3atef6
 tnan07bdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykfyojQ/+HyQebdwRoa/Tw
 +LrZf/ycyn56iXf4+nN/F66647o+OJORYdO0TNsO1j5m20MZD44uXF/x9VjejOt+wk928kitEog
 8ywAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DAD41100010
X-Rspam-User: 
X-Stat-Signature: amfg1r83k9uhxt6hymnz8f98pjmw31a9
X-HE-Tag: 1782723369-42290
X-HE-Meta: U2FsdGVkX1+XhyTAdYRJmO2Td6GFq1JEjLytOUSS1kfn+LMWKerlS1Mf+7uSH/NwbD2L1ggUb5SWCGkAMFE2rbVAnueydBAVcbh6q6mZQMf0V/QmJ4KGBpJAYf/x/Ym2o4l8/gpYqiBjCp11SNuDrwnnoeuRGyhRnAQXNLwblXZlMBZJIH8aBGvyj8mMH7+MKhD242KZmgHiWClCgOspaatlcRMmqhC2JzfzpU86hyBYmQzMqpQ5WAbzUhziRFFwhobF457kxGLxHyJPP7K5llB/9dyxsvG0s/MnF5fnEPchp0oznUPLqnUvdJ8R0RTYDfldAQJ13chNBQ4Tnork32vWcyJqJWnh4gw+RrWuFuGR5HxyFJ6nF2KlVfljJhguGy6i/dm8JKgdp1hJn2/PQpfFnyEtdPzO6HfX/eoNS6BXalBQ0b+l/A9ShOqAbDY4Ox5FM0Aw1j8Iq8my3U1io9S/ocG/FYnNblQCPyd75NfyUfEfJPE8Zndhw3ayBLK8+MH6plbaNNtDMdvEmOq9YomY+bd+7aZy8rQ/i0y8BtpdjnIP+uvEhlkT5676oR/UGRKBSqll+HpkOUctIYvjqNODsd0z2QGQQ9ai2av0BZbQzZ+508B7B9xRHTNBgYMEA54snHLro5sGxiahWVyC11tqcd1IE+TgsenDAAZRO/kHDqcXZvhYsZh8Qz2JSjiRAOR9wQiE7A2bacpdOdXBdPKiF06MLmxt2YyHDCgBi1RraVJW5aHGTqc4NlaXBlq8eVn7jYRvj5/+FIk/ZtrQyhPkUXeloPitBm7Coi24WzFpHm2egemLsGGfIGb63B5HZgJvVHOxmYuLijGu9ez9Z8I69PrUgwt4iiAg6Q0FT3WAE8NudiT6Ywhhm2rjHZBlebdZPLdBvHMkPqCHHRB3P1Ba+NwPiPljZZJ4mgLmwQ3SnPGnEj7ETtsSaSIDIc+ZFmQyhaJCZOroPkmLj+/
 prrHVCwp
 pYMuUjDz0VBIqoNGZHyCjpVRhJHQwzzbvN7e5wTmylmm/8Y+cvhLVrFgcHdYycl02SlvInFPI57JBRRd1s+To2Yi6H1CHI/hsB5xxdvRGEtIBm0SELQC7fA7fr5KlyqK1ZoIQQsFbd9T5RFIyEP+2DJ8LC5brMM519+aUsLwKD7u+4nWOwy0przVtor1DFSoPkAga4tYsZ8mRGPrmAIMwoSfJrJcC94h4PZYSS7IgoAZuqYdN/FgH8ovLQJbn/+EdEvk/pdb18EauKDgQ5QPDzDhLN3s9doV8CHzxkwbtaal/d6esz/CRBgkoa0F4IgFaFN3UmSZUbvPgjXTEmO8F9Xb0XtX1Kw3V3L4Xpihc0ZNUjalqEhJ06lPBAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-25 12:35 +0200, David Hildenbrand (Arm) wrote:
> On 6/25/26 12:11, Askar Safin wrote:
> > "David Hildenbrand (Arm)" <david@kernel.org>:
> >> I think we concluded that we cannot rip out vmsplice that way at this point, and
> >> I suspect that Christian will drop that topic branch from -next after -rc1.
> > 
> > I think my patches still have a chance.
> 
> I talked to Christian and it doesn't sound like it.

The amount of regression reports that we got in short succession doesn't
make it likely that we can merge a plain degradation.


