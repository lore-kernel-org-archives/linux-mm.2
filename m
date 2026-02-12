Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4187EEE3684
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 13:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1826B0005; Thu, 12 Feb 2026 08:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1F96B0089; Thu, 12 Feb 2026 08:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394876B008A; Thu, 12 Feb 2026 08:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFE96B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:26:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4E6C5611B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:26:55 +0000 (UTC)
X-FDA: 84435879990.27.E62FEF3
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 982191C000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:26:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CZFgYQRB;
	spf=pass (imf20.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770902813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mH6HMzCnnYstaeTidXe1DsSu+97OrNLd0YJh3QZ6yOI=;
	b=mwV9qfzYNsHsPMjy8fMzvp/6hFtPZaEkzWb0VKv98TZNNOIlb2Jci0ZPvx+FLpBq47bmbg
	V8aKtw5362qM92Iv5J72jthG4ZR3KUOS53h1Pa1vRbIW84b3SEImiT0EeLgGA02Z86cCfk
	Qp+A3YRN4zb22P/IGcYSrDRTCCACIr4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CZFgYQRB;
	spf=pass (imf20.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770902813; a=rsa-sha256;
	cv=pass;
	b=l3JrBIA0OhR358NKek1V2u//3vya9eeJKpSB+EqcR5tY7aS4P6u/cb/CAag71A2LUrulmE
	brg1RTy+9IDcJeYXT1JIDiPi9LO6o6e5uH5b2sJplzpHNUigfjWJifkTQ3FTqsZGUFrxUp
	1sB+1Q3uJfdiouCDxTJXF7RlXNeyULY=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1270f10a774so7604c88.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:26:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770902812; cv=none;
        d=google.com; s=arc-20240605;
        b=APVY0oGij+/oKq6y1WmHFBw6ohpEU56rkf4pG880/ZHitI9MmpIQXIrI97gtrC/XKk
         4nayv1H0EdNdjGZGlxL2OvFBUPPMY8XsqUlXxlkZZ80zyuB0dJZqZ7p/ZuuQsHXM7jP7
         E0tZMexHRf9vaq8un3NHHFERs0bDI/ZpdQ4UCiCsfuhkLRe10xCQQbymQTwwXoBWtdcV
         hT56DYmGND+0SdtAnqtAkOfhAOQ18ZWWohN3UFrUTMfyPUzw2Tf0/2ZrjEh1eEZVnRvK
         XWMvAD3AEGpPlkI1OSYeqs+Pt++61s6XKghlzkh8bbxRBNLH1wRiw40OLrjDI9cUeTlh
         Y3zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mH6HMzCnnYstaeTidXe1DsSu+97OrNLd0YJh3QZ6yOI=;
        fh=+VF7ZNPD6NTGvX/6WmCkUhCfz++mmrwF6rIjiQ0PAiE=;
        b=ZEedIKu/Xop14wdVjm5Ax7vL7bTjm2VLQr+nIAkOv/cXHiaJj69SPPqOBjyOKlZwcg
         QCb22QNOWljOTHpBw7iZpN40KyBiU6aXD86iVTIM+ACTvyUU5UWnso4U5BkpzonJyKgx
         8r58oYWPVL01NZDVSvPWvNWhUM9Fd+quwhIwh/PrxrTnln5SW3cX3RP4IrFGsnyb13Q+
         5lqaa48n//D6RFGtTcu160mtOqOsnsXPKn+kKPHE9ssSZo9vtFcJyFk4YNGvLZgW/g57
         Y8nS3P6fww4/pi/a+SX+mFSgVEMqG/xlpqcZUQbhPZXQ4kUqrMQy3cOrPCmNjpyK3Ci/
         A99w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770902812; x=1771507612; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mH6HMzCnnYstaeTidXe1DsSu+97OrNLd0YJh3QZ6yOI=;
        b=CZFgYQRB6X4MDvVz/Q1UTb16IsfLauxkkh6fQPT/sjdTKlSymPXvbgZ58ZD9YYo5f0
         +Dr+EWSF91Z2YTXOPm1HylzmV5X3fE0OZpL9p5ZIVA/speGoCyWjuGBt7JskbAoqv2Z1
         N6YcjFZVmgXKxhta1kMrsy2Gu6poy/+LS5ZFbK8/UxWqigLCXovrt0vHZX/6MfGfsRwX
         j8XYs8j0zU9AaUyUL9d3ydz8o69kBMnSN/LC5yg/vbK5OTBJ+j3gX2z3q0dgQJuTPRm3
         nouHEWXL7IrrE9FCCwIzxp4CrIELRR2+ys+uNRaYR/8lBwsrvKZdBqdtCyENPOdc0OsD
         ZO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770902812; x=1771507612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mH6HMzCnnYstaeTidXe1DsSu+97OrNLd0YJh3QZ6yOI=;
        b=m/K8J/QIM8vdKpFNw0AAAj5GjRIoZXdh4I8lAcThZdRhVW6Pb10K9zSFpjPf+lpjvt
         j6FVjNGmkyl3D059V0XdRDBOvlbl5bUBMcTb/f7adQh8Qp2VRAhhsJPlPm+MjuM2FycU
         wGgW7uGXEKaTjkQjiOuX5pUw3ZVxKfJZGjzWh8KhUqRDfEPqUPA5GvrCGrg1wWQ2ZE2B
         MJK1Onjam3NqrrxyZJ8EB4T0fjzua/fTvXokFVc5bow/ojwuuzo2vqHMlEregmQlu72t
         vwaBXoNzFxOGxLVXp+3FDDzleX37T8JJK7yolprRwGFDheS7Ilv/nAWwMU2D426JOe2l
         f5hQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9eC+ocFHwqQtHFjDHjnGD9SZ5+gVIezQk7LtXu87xFwr3s/l5dx5scVFkKOOdhV3Z1/DC6S5fuw==@kvack.org
X-Gm-Message-State: AOJu0YwQRzfv9mwNyaCig96r4khtq80GtczGGjEZrwYbMT5+UB8ZpmSA
	ix1vmPOLD0hrIH/k4exH9ppNMTQrJry7uGyun9Pyris7udtCUNeRsuTpQdmdXEKCemL2CvxnqGC
	z88ZcLuUJ0vrvntdPjLsZdTQhnqs4a78I0ztTC3TD
X-Gm-Gg: AZuq6aLZlMcSsxFyNa62YlDrU5ZGoCV/z/rEhZYhzpukiujZV7JZOVX03muxvEcN87W
	d5639UyMev3DhVo8ZxecTL+1mHohga1SN3eEk/D04dgSb+N0F1bLGPYkechuQWCHugGca/2xLbF
	anrUbhA4qgybf4l1U1tIKrigiMVKBpKaUlwAMmUeBZDdvtPQLm9Eza4OvDd99iGt14Y8aVkVk82
	tRmiCWkoWWsi1kYpP+xG4xOMHvW8Qfc62BtHDMI6pYewfpHs2idXST8VQxzR+qv3aLUYkW4BtfV
	6uMdRg==
X-Received: by 2002:a05:7022:f010:b0:11a:2c18:9e70 with SMTP id
 a92af1059eb24-12730399227mr72922c88.11.1770902811657; Thu, 12 Feb 2026
 05:26:51 -0800 (PST)
MIME-Version: 1.0
References: <20260211173954.2091119-1-mclapinski@google.com> <CA+CK2bBfJDD5SPJqwCaGbaGZe9FncONMsck0QkOb8WwmDSh_Yg@mail.gmail.com>
In-Reply-To: <CA+CK2bBfJDD5SPJqwCaGbaGZe9FncONMsck0QkOb8WwmDSh_Yg@mail.gmail.com>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Thu, 12 Feb 2026 14:26:39 +0100
X-Gm-Features: AZwV_QhOqhvLMMA8tGW0jRKe07LrkYVDlJ3nPhGSH3DMS5ObxgL-4w4AxgPOk7k
Message-ID: <CAAi7L5d19R8ftDsvwJpoxjkx9YSVkBuANOAixk75P98KJU=r4g@mail.gmail.com>
Subject: Re: [PATCH v3] kho: add support for deferred struct page init
To: Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org, 
	linux-mm@kvack.org
Cc: Evangelos Petrongonas <epetron@amazon.de>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, linux-kernel@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5xd7hzqkogggjy49un998c3w39j5ohnr
X-Rspamd-Queue-Id: 982191C000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770902813-910393
X-HE-Meta: U2FsdGVkX18jk/xDc0H+0DYOJL7U4SNx6shJ0kXWRoyM96DkyVhfYO24CFYroKunYjU0ew/n+oe3ndAeRS6gk/CI1r/Wczxd328hgkaO4CCS0xCwTxn+OY9KRxA+Um4J3+Ka/8np3Qa1vEhy7QNrLP5LZIuxLihpdZ0Gb/Ng5e4L4GWfz+GJJ/x2fn4oYzkrSLaYNoOt0fXISG7Qt3e5zTfjoUQqPYFp1FBbinKzQeYijtQiUcXN4cXnNDd5FTUplRmcIMXupgKrdFFHiYEH1wJILydnpFEh+FvsbPjI0ziU+Pwculmi0tKI3IvdwNaUmRrjAAb0ToTP5mKFo29JRXPbcJrv9SBdBhNuMQG2HxAkKIHD9QDWMdtPAwIWaUneachD/dtz1eYdbBMpeLlbCjnhlYUYMgbWSPtyBrFIRKvzzF9Z38sFKBDg/LQVz9q2rAlaVxs/x3mnWQf6BJkmNWsqU6fpi9gpODVk8mxHpXrcDOOULjHMAKAfs2YBOuel6/tESPLIDYsa5rfAkJh663w9HJyWhtc8O1gL/l3kGAM9iN91bKN0vfGAz7NHEzPbQnmyHgpI1TXAI6elIxKP3Bfp9Geim7RmDmUPn8WeKCLyU1n09jEnSQyprHiKtE5uU+s4fE+D0CPf1/qJxpvcHWFFlgfTs1N2Z3+ppgrI0ATxATOuUmCH1E2OjsYVpmUbY/4ubFz3cDrm15Q75Vlc3Ao6e1T72DVqoxxTZktccQoaAYCVSOUOQx+YZ98cmoVl3bSOH0AzA0IkUdDqrkqc+N8s1mnlwAVGPv0MbMiMPtLY67cT+/2JHWxWQRsayFhfSocFMDRerVZbgFsRImmkRXJgpvaSPe8nkrbqrRTUEncCtkBv1bXMJJsArEXW0FAqmFGyMCF9KDfN+D3qzaeVT2oxmHgxGHM9BBsWC4s56/d6roh8meswjQzPs8dTIYL9lGjDVo+h6KEr1WpgR6T
 VjPfUkIC
 8cyEh0QtHXZqMFkSRM+0GmjhuipZEA5uaUdKewFHVAMhpoETEr2R9LM9bQ5EuV1DoulyDAgTPSSeamR/Zk0+yvXfxiUHCOA/a9+KrecDK08+i+UgfaZYDDNBTtruynBZNEAt2T7u1RZi5/FAqSJvOnS+KLciWCcS7lzdzDnBlKkCH6INDAhvu05GTIQbvq5yvlHTvMbyDc7fOKSioOx7T52fDXnU/kpyvlrqdsNmwUayvFB4CYRJ/B0693Fx3kd5VSz4XvfLcCjXc+g/Ipi33Qo7VDDzH7Q/PnLoGXq1CyeqrKGfqfnCUkM1fQUQNSoS37nbXRJj1muONVSw8BHAad8T4q5fKrEIeQdoseugJjr0z18NjKqfWJrInY1Olpc7oaoay6q8sPLJsYPEelW4nVDQGbdiILRwKH0oATrecaQ7yp+4Xr8y7dbBbZusCrlKBna8KMP5bKHrhp1P6vC45Ea5+Z6oadPCB+q3NSrwrTRYqIFupteEVAc8N2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 8:40=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Wed, Feb 11, 2026 at 12:40=E2=80=AFPM Michal Clapinski <mclapinski@goo=
gle.com> wrote:
> >
> > From: Evangelos Petrongonas <epetron@amazon.de>
> >
> > When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
> > initialization is deferred to parallel kthreads that run later
> > in the boot process.
> >
> > During KHO restoration, deserialize_bitmap() writes metadata for
> > each preserved memory region. However, if the struct page has not been
> > initialized, this write targets uninitialized memory, potentially
> > leading to errors like:
> > BUG: unable to handle page fault for address: ...
> >
> > Fix this by introducing kho_get_preserved_page(),  which ensures
> > all struct pages in a preserved region are initialized by calling
> > init_deferred_page() which is a no-op when deferred init is disabled
> > or when the struct page is already initialized.
> >
>
> Co-developed-by: Michal Clapinski <mclapinski@google.com>
>
> > Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> > ---
> > v3:
> > - changed commit msg
> > - don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dn
>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Hello Andrew,
could you please apply this with the added Co-developed-by tag?

Thanks,
Michal

