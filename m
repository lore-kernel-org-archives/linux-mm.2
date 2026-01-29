Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97123D46C16
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 00:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C397E6B008A; Wed, 28 Jan 2026 19:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE39C6B008C; Wed, 28 Jan 2026 19:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A736B0092; Wed, 28 Jan 2026 19:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC886B008A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:59:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 499ACBB381
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:59:12 +0000 (UTC)
X-FDA: 84383192544.02.265543E
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 433EDC000D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:59:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yZhNplu8;
	spf=pass (imf28.hostedemail.com: domain of wusamuel@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769648350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ho5qTXSu2PZYffnzQVL+2Xc6poCFB6UxCVa5s6rbRlA=;
	b=ur5prI392z68dar466BIStK5g50uUTS9LRX8sh6yzIzXAUUrwpbXSaeUdU+TXC0o4Skg2z
	BzR44oq3cUOEZCTt7rarulhrBlZjgzyR6uc2WePyF1o5Cg6JW/KJrimBYmg2+pEUINHtC2
	+5zC5HmOKwwZ67YukJG+Wvw9HDlw6V8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yZhNplu8;
	spf=pass (imf28.hostedemail.com: domain of wusamuel@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769648350; a=rsa-sha256;
	cv=pass;
	b=nkSamQN27GBCBgxeKybMkaJRz4dp7r4JG4vnHmwI2tm2O/xV9yINGQ+I6YcqEcqsEdTjyl
	YVUs0QAHbQoM/TE9eRoV5s4BWL/7ZjnBZz+w/Ewt6cJch/a/Tflr+QA5H3T8JZXwQhJ+ZJ
	CugIoeHxSBtc6h/icLWNoL1JP6I7vKc=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-658cc45847cso422443a12.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:59:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769648348; cv=none;
        d=google.com; s=arc-20240605;
        b=lmBrOfH6++1Mo+OAPqOm6rvBDDPW2/Z+f7tCXRFLLkoFBy1/hxT6ZNya+/vTw23Ri6
         lvhJUD+T0n6jA/nniPbLSZLPx4I/UKy/a3XJ4GesYCt7YXZ4uj7kOPTxqrBh1Vx/n0Ob
         EuOl6ogJ8W11O6ns3XTNpoI2LSGapuhCnHgF88HyPl7chy/VDFsuVIfsDB79uQz41wye
         ae54eutYU5Mz7srhVIOlBBrRTRkKdN7K6BLI9/axWLDJrqRWHlk1xtUbwrKlDcMgjnqX
         +dV4qDAsoGI31aS7uF3wwUvSa06V2qlKpn/e14csYWMuZpmaoZwO5JeGzwoKNGvV0ZkO
         fsng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ho5qTXSu2PZYffnzQVL+2Xc6poCFB6UxCVa5s6rbRlA=;
        fh=lsjemU2qJG9Tk2D3I4YrPfN6wABgLH2sJutnZhatSdE=;
        b=e5QVwZCYFnb2FRcJaEuXy2jQuPan4CI485AzmNfLHK0XTrmRDWUE0j3XTvOS086fOv
         DaWSntGsAq511CsWghU/zkj0muAzoSX0wwK57U5JX8xCmhOkc3dksxkLzx++irHNbuUf
         2I94tUeYu+mfaGJnYhqPQ/t66BLqPNaMpwz4cZ2JLaT98aXmNpxnwgeTzca8hEuXCk5S
         8HkPZOQLDZIRvsdzLCmY5f60/CncalM0LKs5aY2LhIh7U15+gm816imEJ32i+QH0rsFw
         35JXVI7SdjBlmBTRLgHtDJrOrm5FNGmfB9zmkvKaBx3wR/rQvd06BHys6twtpa3UV2LC
         vSsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769648348; x=1770253148; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ho5qTXSu2PZYffnzQVL+2Xc6poCFB6UxCVa5s6rbRlA=;
        b=yZhNplu8+DkDLTKgFYy+xtYtWJKpryVOZTdPDGO8l3vWNfSwwluQlX6+7vdIdYeCAf
         KSmXR4kBmCu51y6ONjZsZtLhgZwqyqXtvGiqKJEm6N0C/adotGrMrDGoarNfq5N4K3PK
         m6huPbp+6r1/S+sYuT9CNu+jiQsONmt2RhSrbuQfQVeSsdaATa8KgaPTvT61uDtVwjdK
         5RsfG+o+glqdjU4bBxhmhx0WCdOSrYZAH9RcFPdPgHuoNEPtOHaZJRNEdNH7IRYCLQJG
         DaIaJzWYIY9HLIA+3kVg6C9uuKrzUAvjqaA2LxSQPQ/VZSPdDAjCARtsSKrOCnglHp6Y
         Y47A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769648348; x=1770253148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ho5qTXSu2PZYffnzQVL+2Xc6poCFB6UxCVa5s6rbRlA=;
        b=FrgdohkkosGGDnWrVVcs8DbsFvHkh7rksnOINX3nnNdkv3e3Iy8xUsHKN9ayf2h3dc
         JfIAVhR5uzIEZq+4+VsmmlmIf6wMYepoERCe8zlTJaosnUuPRdh9+OKsSlgwuMglnO9b
         XE3nbufb6sp7aMiInD+KwmZNMPKGPMUmeZKqxyhNfP6vNgD1TW4mj5yXde/5bNlkGtc0
         vwzLDJlFUht0paWIV1g8FITeBhgnjQI2+LLTq/dvpUCMOALmaKa62jPDanhjRRGWa07q
         cwlk01ZmYEGH/P0OK84JVWJZymaSXb5dUeoSvrB2sF+tZbbrOYWZ1WUzcNz5z63939G5
         Vc7A==
X-Forwarded-Encrypted: i=1; AJvYcCUyiFBQz9MBDvK+0TLEcpt8T3HPscH8H8+mg40xjyqeUs1quH4Lz3lzwYqUoE4O0Vosfzqj1oGS1Q==@kvack.org
X-Gm-Message-State: AOJu0YwomMw5gFi2hdBZa8BiMqb7UMQMgZ+osH+kVpl6A1O4+Zut5BdJ
	JdevHBlqignww+enpxXOJhr7dauGdhk5UT85RaEG1kbzV7d31N6Q9dMXkW+syxapmSgwBwQLOil
	AAcEhFRCtwQOYWHSAPWf6ifxbjrzYE2huYN+kqG1f
X-Gm-Gg: AZuq6aIELjUK3NanzoEhthXoQtofpXsgTvY722V9Qt+phkon2e/+9jB7nZA8EGIW4xo
	S3dRXRL675ZHrAXdDXE3Qxd1q2KUc6wJXQOjRs3ItdxL5AfnAvaVi7eJBaWKzxNeF2NHR18oxgw
	wVEzf6G1QHi8WFfIOTSbJmJIEd8WYkcGlVfvT+c6s9xwyvnrtNjCguAWqwZFIhhvgBj/0DfbZuA
	FkTFPK4rdJYmbsBOkDqkhG8+qCCtKmlLxUj50KbrXJhkxjO+QKDDszvItk7kqFJkYbVq09A4iGl
	IeAGGOmtamwtdWF6+X2jEkIV/4Jj+g==
X-Received: by 2002:a17:906:f585:b0:b87:d722:f824 with SMTP id
 a640c23a62f3a-b8dab3cf66amr455166566b.63.1769648348337; Wed, 28 Jan 2026
 16:59:08 -0800 (PST)
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV>
In-Reply-To: <20260128045954.GS3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Wed, 28 Jan 2026 16:58:57 -0800
X-Gm-Features: AZwV_Qg5mDXEWLmzjtDFHSng8MB2HQLUBKHQ6Wr860X_lRTmL3Z_ZmvOjLnN07o
Message-ID: <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sxu1rtih66r8dkuf8nzk6s19r676j1jg
X-Rspamd-Queue-Id: 433EDC000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769648350-530577
X-HE-Meta: U2FsdGVkX18MRAJJewur66pvo6drQbo5Zuq8ECGTX5HnM85imBq4AK62867v0JzeKsDQLVnqNh+yqWlKaWJ5jLnbEzE34LokQ/bqCZC3lbYIp7vNlPjqKPTY4E9AkUpbw1+v/02wvNsLe9r1ECka2mUtlZrWoU3s6STnEixCDAIvYeWr5AISfLLYQcSuLM+vr3+Uyn1ilAvo5fClNwmMsMcDgFz7y8SPjChYEZJLglDyUSk0V9/PtiKJUT0a1EewdqFoNZPiT5Gosm8qmEHdnr3qeYUOyhcKbaM7VlBFqish4pYwWsRpp/I0JQY6RoKlM2/QuNAQd15z/xvn4xxCQbM2QTJYUDOKWVAUoZJ9FRrdkm6lP2R9BnGl9qPNMuIJAifUrvvlKmSa0YqViTiekUoFLhpEPKg62fz/64tHvsnfnt1bpXMrkJTkfvtHiLBsIvASeRGzLlX73H75JcP7WHHTRkis1NvYRyCP8m21llvxU+C4rE+Q7mQLqxbcczQlmXN6dVWqlBCoGF34HLLFvCxUnUWG/3NxtpHZau+j3EDgOg77H9tFJTAF69QWt066xV+GPX/UWYWUPa+WdVwN4NAPStyyMzewSH0pFrVJAMvhu1n7y2f4iFTkSb0uKVLg+4vUEj4NVok09REIEEMyxsdHhWW6/slVsT+aCFLIFOLfM85zy6pBJ2YWhe1szEhzZb0xJLUi4Pkok+TmRk9fptwzLoEI40qc8OiVbVfCAefQpuadjoTHnUQFYViibuZVP4bQ1ycs8EojNweBGKS/aT3MUHOkaXvAyW4VpSii+1uYygee5sm2fShHr9cgYn7LLoF6FIxDz2oAg9l1+aFdZAhmFoKXRWAxlPQrr94F/ygiufMb2RTKMdlqswQl8KBAyG8s4aXu+gZX4iEQa6vePxppKjKsnI2JRLAdYWKI565HFSsjNKPMZPBoz78jIOZnQTJdDGfITes8Xa30wrZ
 s/YcILPL
 X5+5cGoendn8QDd+zZeNEBLmbslS+XMtDFnyM00enREur4pxOQXOSr80D+JlMPEjsdcnZhvtVl7AVZuGnC8ENQaSUAPJ0jCU7hxd4oquh9JsZIHwG5rAUnUd3xLMKPgj3lV8XQF44B3kPUad5waY+edadf06xkUAMGny7n8cVwArnHE5hRDWqRmBw1UoJg1BUrcVH5yZUoaWb3jA+FtUgi05aPc4RhPRD7piJFxJoGu95wqbktdbymJGAvUMjUob4o4jyLek8Tdf0QmGr4pJbsYDqwj7XRGOoaI7IADOtlGVAanFMBtFDT212TrTgVdt9gSJRLHsmPMFWqwhPl4qOjaecUBFJsJ7upzGrueqg7WCYRYDoDr9VdwgltJsZsd83RDGr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.043263, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 8:58=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:

> Very interesting...  Does 1544775687f0 (parent of e5bf5ee26663)
> demonstrate that behaviour?

Reverting only 1544775687f0 (functionfs: need to cancel ->reset_work
in ->kill_sb()) does not fix the issue. With 6.19-rc7 as baseline, the
simplest working recipe at the moment is with 6ca67378d0e7,
c7747fafaba0, and e5bf5ee26663 reverted.

