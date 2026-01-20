Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA1BD26292
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 19:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5FBE6B049D; Tue, 20 Jan 2026 14:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C266B049E; Tue, 20 Jan 2026 14:30:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B046B049F; Tue, 20 Jan 2026 14:30:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DEDC6B049D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:30:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39AA113B874
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:30:33 +0000 (UTC)
X-FDA: 84353333946.09.CE752DA
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3B05DA0007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:30:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LvfO70Ak;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768937431; a=rsa-sha256;
	cv=none;
	b=AD06SHgVB4i24Jz5kL4fBMPM3iEVRAF7554Coh228TaRyAcaCARKYEPOT7v5tSNq+dgW0+
	Jqyq4njavm8bEqFfsPqcl2+dZtXXrWgr5WQ5m/zQ/XZk/oqHox9CqlwplbrBVR7KFbRDTk
	3nIsLP2TzbJoeQ/lG5xzRCp2OIP1sgA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LvfO70Ak;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768937431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2V6UawHQ9s5MFToZpU8099TxdYIwpRpbE9unot+c64=;
	b=Kn1MOgV33FtC6wZoTaM/3gxC839wWwr6ZMh3QAz9uYojEdwVnoUkI+cJ5H5Q9v8ZC/sMDv
	O8Z2Ixz3bbrc4B0Gfhjr0F5G7xFe0qYfxkrWxD05Sgma/0lohhXXMcok9Suxl/QzoQ8oIe
	5aRpdSNZD9rZN6JJLI9S0xlkn02xaBg=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42fb4eeb482so3191069f8f.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768937429; x=1769542229; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q2V6UawHQ9s5MFToZpU8099TxdYIwpRpbE9unot+c64=;
        b=LvfO70AkiEapJLJp52Y+Ogj6yDqDJagKaj5BC4/HY8VrF6FidXItR8l6puIb6A+PK7
         vM6TLvQBzWSw0vd10LdcPue6vvgOvJo/1RWENKjWDzXb8KFlPDFDOHJqAjF/BGzChiDt
         bVY8Nc8tCvxBGpRvKJOLjXrwU+uUep6q3/5tw4BETUDsh+8ZpAx8poLME63W3gXM0rdV
         ILV1a3OwEXAUqC4EhP//RGBNPBrBrkSviMHiFNdN7NyeqGdXHkCzQTS8qDCfBuI+Uol5
         2ysEfCHbn8UkdkoWLroSZv//Rc6OZcfyFR5vKS/rpRQuEZcn3ldpTpYXQFen2w1DJD3d
         f0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768937429; x=1769542229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q2V6UawHQ9s5MFToZpU8099TxdYIwpRpbE9unot+c64=;
        b=T6LeHhUp1TpmY8idz1xRYeD7FEV59aTBM04iSfcxkgvMfe1EzCRUvbwiMLHxrN8PQp
         hupB1SZ+AmQe9XZEzH4QWNhW94DXHB0vYoZYTDJ7V0SBlzARCdUJbVstPJIifEUULxVI
         0CqSWz2WdFWv/DvK/s2Wb+SAXhybx5MDjThqnqNlxm085+Pu6KURNre8QJGk0pabRoaH
         uDl/WNx/x6CfZdZB7S4lJFzXWgtCNvj6eYgheMXH2fQqiMrqPvzRrrAX7Z+qu1oiBnz4
         81KtguQly/aG6Ixi/EAFPbERWVjBQ4a03iRrnv52oqajpXfUlhPy6oRT1tgvB7X2n40+
         XAhg==
X-Forwarded-Encrypted: i=1; AJvYcCX7jZzdYQO/LKtG5WTC6/mFVJpLxJMxYaeuBFSEVWAd4gg9qsndGTK49NNjBjqfoA4T7oxpvr8/1Q==@kvack.org
X-Gm-Message-State: AOJu0YyeTgeHqi0qbi5E7PFge8W0GCCx+1qVo1540z89ay3B0ytbWHE8
	BUNSkUpgRjZb1nSLSN1vQKSmla3pWwDV36wMn22HJb9QuWhJ2vL4sJy3
X-Gm-Gg: AZuq6aKq2nAZ+DLgSSxV8uce22ekZYryxQkA06UUmJH0fKK+vhJ+WL75WNJP5r9/OQ8
	T2RGbm8ZqXm4pSruQiA2WcCnfPR6mgIyJzTFDMaYKG9lJk5COlG/90nq7waWhbx80/OJzKLh5xK
	0TZoGGMo9I7ZgjNwi02327XUza3TboQwy0lUewICug+UiFx/0cqv5xj0ZIVVmItg/+TwsBc83L0
	Zy5+TS3XEQ5cxct0ylySvRKLyelZh8Xh5TcA0dHoAjuZQXoaYG9JTl7AoWCV1/rEWY6ZahvItqD
	a3i1jESTSoEZ5tbgvdOpBSYKDQ7MYoKqBaUHZ8HjLZ3ETgYZEk99MY49XMWklj4JvL49+R/Thh8
	xbQYcv18bKDodywdPo7uioVevA3AGjSFPgTX4wBuCzxwFyeCeDNgeOyQJnWo4rAW8yozqipoAZJ
	bUpjq5Z82apffJmUX0I10P7JnrLGkyG/uqBwJOUJhlmFtVrXuxpbnDoXJCbuRlqhA=
X-Received: by 2002:a05:6000:420a:b0:430:fdc8:8bbd with SMTP id ffacd0b85a97d-4356a053899mr20086025f8f.41.1768937429265;
        Tue, 20 Jan 2026 11:30:29 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356997e6dasm31642908f8f.32.2026.01.20.11.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 11:30:29 -0800 (PST)
Date: Tue, 20 Jan 2026 19:30:27 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, dan.j.williams@intel.com, dave@stgolabs.net,
 david@kernel.org, fvdl@google.com, joao.m.martins@oracle.com,
 jonathan.cameron@huawei.com, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 mjguzik@gmail.com, muchun.song@linux.dev, osalvador@suse.de,
 raghavendra.kt@amd.com, wangzhou1@hisilicon.com, zhanjie9@hisilicon.com
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Message-ID: <20260120193027.3d160211@pumpkin>
In-Reply-To: <aW_G66HeWLbyiPHs@gourry-fedora-PF4VCD3F>
References: <20260120094744.5d92e34a@pumpkin>
	<20260120103949.7673-1-lizhe.67@bytedance.com>
	<aW_G66HeWLbyiPHs@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ammtd6ijy3cmmzrd8j8bdd4yjd881k9e
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B05DA0007
X-HE-Tag: 1768937431-494830
X-HE-Meta: U2FsdGVkX184mKw4KuocFf8gqGelmujWdyVfGHEbGYaw/aoN9HGg4LnacID2o4o50hfHKah6bb3Y20IETqhCmHAhFjqA9vqRvO/5NAnFpSH7hqZBN+wCDAjBQ0z8rq8Ca6Yw+/8WDZTcO8xlmv62BxmMJjTbfNMtm+9AJbrNmwLVdDQ+QE7C/1tqDxCuwSCX/mheguRmxStU9XG9Lhd4wwTfYqGB76aRqXfVnmnO9wYeccumU+pDmgQ+O2iR/ipYnWQX4jm2+UNHnlonFXaYmV8m5Po+RWo8Ar7qt0AYbPvg7f7mLcFjusaeliWCjNt6yGwCngRXu9C6Ucful/pWfwC5Ou3IWufmqNI4j3AtgvIFjGZQDcF2Ef0cz8MxYzBdd9VPHD7JfjEtZp21ju7L4UdloVXTx1tqGbYLURVtM08CsRo5PH2ggSimV4sVbPaZuoTalHYrF2g565/jG+QTkX52uOjOC6uSHX2rokEwdmGw/l2wUnMRgEjWgwLBgCK6mDaQVVf494Qi//TloQOSb3MQtenBMOSMiJJF76HBk/ksLF20wjch6m/hNeHC0WeOCCF9IxAlqmQpCINQ3hEq1KpFKRXcfkdorSFJeU4Gesn/KddzQUDe4xghV6l2dKPce8pE7sW2rPEEB/KyUlJznJciM+DiC8/RpqsEahjNS6RJlBVdIA4zLLxAEQHK24bDviO63CLFjjh4/sGTkmnzoANvIiQ42naxTa3rikKmKFibfHV8xMhOYiQ1PvqMtUZzjBFej5dQAzaUmbi27mujN7sajGOzJmNNwOvMaPMNmXuVLcakMb3IlsP7mMcGzL5mdUemHuR90mC6ZhsuWbePnMvTiE/8Z9829B2qMyqnbiVku4QJNTora2jmpCUDGWxJDDymiphhWbyutZl0TV+anB9MVJby8ScK96xDTKx/TPQMlnFwbLefpp/EsRs70XtGCuAEPjd21jhtI+SscmP
 /i/iDQ9I
 kzypX4VFBS6fXRmVpAjar6NuKcZ9kfqafHaqqbc8GwMcrritNC7k6kTy09PREfoeWFdkSIH0rQPvMZigzX4t641FYTx3Nug1S4vqROL8N/LlM70uGbGtiDZeoP5KRMy5ME6KYLH7OsQNzOsxDz/zvfLVG7QfSMeIMFjtzEnNKRFwfjfGia+BLq7bSdwCNltUyFBNCgp011gLG1ufNEay/t+gZN9a26ydCQ3TxuoU8rzQOiUH/B+bEuE3v8DL3Z07dxefA6xZ1Uo3GHv6/UGOSWCpHw2j08+EWkidLI0Q3UhOWXJuv1giRn9h6vXY9c6Ua6Y0Wy7KoQq5QkJp4ICXfmY98c6BNxjKsxX+P3Nc7fG2BYBCGu8g3qid2ppXQt4RD6CGIulLdoZImT0xAorLZlNdEW9tnaHZH55iEFXdKql9ujdAT/bh9EOwdbh3UKQSgBt2p3ZfE84v0/TG3SazOcj/VflyaoXzv4Ei6uQj/4LGueeprMdonrYES5BulHkU5t7d75OYg79/16SH1EQXl+YrQJ86O1hlrpHVi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 13:18:19 -0500
Gregory Price <gourry@gourry.net> wrote:

> On Tue, Jan 20, 2026 at 06:39:48PM +0800, Li Zhe wrote:
> > On Tue, 20 Jan 2026 09:47:44 +0000, david.laight.linux@gmail.com wrote:
> >  =20
> > > On Tue, 20 Jan 2026 14:27:06 +0800
> > > "Li Zhe" <lizhe.67@bytedance.com> wrote:
> > >  =20
> > > > In light of the preceding discussion, we appear to have reached the
> > > > following understanding:
> > > >=20
> > > > (1) At present we prefer to mitigate slow application startup (e.g.,
> > > > VM creation) by zeroing huge pages at the moment they are freed
> > > > (init_on_free). The principal benefit is that user space gains the
> > > > performance improvement without deploying any additional user space
> > > > daemon. =20
> > >=20
> > > Am I missing something?
> > > If userspace does:
> > > $ program_a; program_b
> > > and pages used by program_a are zeroed when it exits you get the delay
> > > for zeroing all the pages it used before program_b starts.
> > > OTOH if the zeroing is deferred program_b only needs to zero the pages
> > > it needs to start (and there may be some lurking). =20
> >=20
> > Under the init_on-free approach, improving the speed of zeroing may
> > indeed prove necessary.
> >=20
> > However, I believe we should first reach consensus on adopting
> > =E2=80=9Cinit_on_free=E2=80=9D as the solution to slow application star=
tup before
> > turning to performance tuning.
> >  =20
>=20
> His point was init_on_free may not actually reduce any delays on serial
> applications, and can actually introduce additional delays.
>=20
> Example
> -------
> program_a:  alloc_hugepages(10);
>             exit();
>=20
> program b:  alloc_hugepages(5);
> 	    exit();
>=20
> /* Run programs in serial */
> sh:  program_a && program_b
>=20
> in zero_on_alloc():
> 	program_a eats zero(10) cost on startup
> 	program_b eats zero(5) cost on startup
> 	Overall zero(15) cost to start program_b
>=20
> in zero_on_free()
> 	program_a eats zero(10) cost on startup

Do you get that cost? - wont all the unused memory be zeros.

> 	program_a eats zero(10) cost on exit
> 	program_b eats zero(0) cost on startup
> 	Overall zero(20) cost to start program_b
>=20
> zero_on_free is worse by zero(5)
> -------
>=20
> This is a trivial example, but it's unclear zero_on_free actually
> provides a benefit.  You have to know ahead of time what the runtime
> behavior, pre-zeroed count, and allocation pattern (0->10->5->...) would
> be to determine whether there's an actual reduction in startup time.
>=20
> But just trivially, starting from the base case of no pages being
> zeroed, you're just injecting an additional zero(X) cost if program_a()
> consumes more hugepages than program_b().

I'd consider a different test:
	for c in $(jot 1 1000); do program_a; done

Regardless of whether you zero on alloc or free all the zeroing is in line.
Move it to a low priority thread (that uses a non-aggressive loop) and
there will be reasonable chance of there being pre-zeroed pages available.
(Most DMA is far too aggressive...)

If you zero on free it might also be a waste of time.
Maybe the memory is next used to read data from a disk file.

	David

>=20
> Long way of saying the shift from alloc to free seems heuristic-y and
> you need stronger analysis / better data to show this change is actually
> beneficial in the general case.
>=20
> ~Gregory


