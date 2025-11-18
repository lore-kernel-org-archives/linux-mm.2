Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E73CEE343
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95F66B0096; Tue, 18 Nov 2025 12:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8426B0098; Tue, 18 Nov 2025 12:59:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B723A6B00A3; Tue, 18 Nov 2025 12:59:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9896B0096
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:59:01 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42C1355EFD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:59:01 +0000 (UTC)
X-FDA: 84124488882.04.8CED97C
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3B271A000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:58:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XXZZLFHR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763488739; a=rsa-sha256;
	cv=none;
	b=6mChaKPH4ejYhomolsx2z6yq6Ix+GIMQx5d1JO3xstQNnxhEJePL6zeOVfUqhhAh6BKNri
	/AgSSqrAmOCw5UMNFeWYEN15KujlzIfjs3fkz/Ii3HGDAktDgBOWQPBwGGsJfbH+ZXnzJb
	H94XuXsqRvPg69gdeLxBSqkawKB93Ro=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XXZZLFHR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763488739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+caJNDkTSm4p2uWmUOI1wRaGCCJeFpF1smMqUtSo0I4=;
	b=J/ZV6Qrc0RmNrebSoxq2XJIZvaS+pKHm94WVgWTKxmTGp+rwmJTjItkrU/rzvM1gYVNhx2
	JnkavQcRYeZB2nwxAvpkkd2jeG7ycMwilIBTGYAPvObkatFx7yc6PAOLhu1ElmwCP8ZcTi
	zaXSjTyjyrvm7WFOfPllW235y4U2xiA=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so8739373a12.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763488737; x=1764093537; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+caJNDkTSm4p2uWmUOI1wRaGCCJeFpF1smMqUtSo0I4=;
        b=XXZZLFHR5DOQxEdCx4/66qK0GVpAKqb9uYg3lSb4PStNUZkjjTV8V8Vc2ceyVGkKE+
         RfBwcjJoz7eWu4bg2i26osTNzJd0B2o58lWfOZBkaPgXfZyJ4g+tmSZt+wLnpdJLX/Lo
         +KAjP/80nDKD23mWjgGvVphOSbAgkzgjWKh3pqhvwxfjlDK6HhF/ebMLtKhAoU60sWVB
         5Gyx9JbRigBa/nnRtl/YThA8HFhzdikAmV856enuSmd31Y+FOkePBkbx/kYenDecdq4g
         W5U1Gioy3laMEC26nDfu328tfdW+flMa/TrWxS+hVG7yTaVO2VZnB0pggWdiKF2C38Rj
         GQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763488737; x=1764093537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+caJNDkTSm4p2uWmUOI1wRaGCCJeFpF1smMqUtSo0I4=;
        b=mlEiOorWxh6FweuyZ9fMQhPxCcBLPgp7CgsgYabHvrGfWRZgKbSXeV0svdtL/lNGmw
         1a2cfHZ5prt/E88XPeFfIKhkojVpo510dr0tiQnsc6JVqF843wm/eCzAmd8WcgPfuGQj
         tjYsdZSM1F3fp5jkZtxMTinUipTOxgwnDMiCUpv3wMkObA5QeipBTanL6BpkFJReiSDX
         ku9OgSa5MVtGvXMgncbs13CwX5713b2O2w0rymEbkZ1hRw4PnEcdVqD/L9ZJUQaRwOaM
         ZSF+xp+wqJZjx1NCzMp8Se2MmReC35CJyNBmMHwF7zgkK3qMsowhLnQrftCJoEsuT3HO
         odXg==
X-Forwarded-Encrypted: i=1; AJvYcCU6PKlegKRxV7PfZvfrlpzcG5mH6plELu8Hip4jD+IqOfwDfvZMwQK0saXxwlsw2iZS6TS6lo0okw==@kvack.org
X-Gm-Message-State: AOJu0YyOsCNEatHXZ8mPhrCUScx/uhHvln8dya0UHWzgbSKhxVBufuX3
	CuWH/0QEroLQjNJDkKnmVQspnRWut67sUh/+7ukVjnVslPabUzQbUKgVmkymOrwHtg8tazcRGIG
	/5h4rWGAsMcEqc92sICLDDk7iqCNjOXbv7Z55x13NuQ==
X-Gm-Gg: ASbGncug7xv6v2vo8DcBSghBxy3cKVAj5Zn1qaNF+eabIJqAZTPzuQGBZ/4A1NfoK1V
	J1CyjqaW719KY/pNutoQzDkck94VeOxbAgaEATJEGsKASNNzSYTPpVm7BYDbZS7LVXeShqtMADQ
	2b/qTNOKzCvZXPrRbwBYNYOUf+J9fnsD9T/v8ubYFQgjDWXvxlcAwAy7jH4sgDtmaqy5IzcQ2Qo
	+/PMOtJElkXc5CV1hIuwdz6Whxlf+Fk2mvfiiW19MmBUtZXXGrK4rlJmrBXknoMp/SWLYOigw3t
	YFQ=
X-Google-Smtp-Source: AGHT+IHLtEGa6tvFkUsvSNc6SGJ8gqqqGO2E3eFWqdurGTWqPWn/X+W1lUYZN0I7kpLDC0TLDDfvSxnHQDVTVoLPRis=
X-Received: by 2002:a05:6402:26d1:b0:634:ce70:7c5 with SMTP id
 4fb4d7f45d1cf-64350e89998mr16647067a12.17.1763488737365; Tue, 18 Nov 2025
 09:58:57 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-7-pasha.tatashin@soleen.com> <aRyvG308oNRVzuN7@google.com>
 <mafs05xb744pb.fsf@kernel.org>
In-Reply-To: <mafs05xb744pb.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 12:58:20 -0500
X-Gm-Features: AWmQ_bkVrSTIot3zGMN2pIgE0TFCb1-KBBBDf9maAEVJdIwW1B5_ckvdlEwn_pk
Message-ID: <CA+CK2bAqisSdZ7gSBd7=hGd1VbLHX5WXfBazR=rO8BOVCRx3pg@mail.gmail.com>
Subject: Re: [PATCH v6 06/20] liveupdate: luo_file: implement file systems callbacks
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>, jasonmiu@google.com, graf@amazon.com, 
	rppt@kernel.org, rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3B271A000D
X-Stat-Signature: hjtkiqagshfx1qmhm1d9ytjfpgyjcwbr
X-Rspam-User: 
X-HE-Tag: 1763488738-452611
X-HE-Meta: U2FsdGVkX1+pAxQXB/OrZTFdu+8V4dbQ7CEUZsSIXK9VczkMS7T44uCqO9fmAkeoVm04ZyO9sZsk3ooPNkTEfTeNJqjxKEjur3Um3L6HRsgNknccEQNu5isv/hmP3q+jZVtD52z/skfyxm1EDsJFJBvuJOq/TI2/7vjuV1dDR4RgUXX9gG0ppBtoviMNfeWLuS5XcDRhboGNV1dUT0JeKkFYOxbAgC0JM+Qi61NRMgEks0ouedBg+/6vspyDll9jbsrR07weNmLbbKV8TlqpTTZgbdBziAsfKbMLt6v7mkEaM43JIKYEyc8H01VSIt93XL7EVgwHN16B0Vi8TK/8GZQtrLFmcgyAliMkv1sHQtT3TU81i/qoLIigIhJJ/z7aT+p312XCW3NW68iaL2fDrWGlvE68uyYZwjbRfbeSQ/eXVGxU0o9Ch33S2773nKoBEW/QrZ5P5KZgutw4mGl5ZjwY8fTH/ZAm7Y8EJg8ersAmiOipEQp1Od778aGisVCRPY6VNxnmp0aplpeNSPjpvF1St/6mPeFEcWYa9vIsUqnm6FcqwkWYvsuldprVPUhc1F4oFy9F3sm/Vti5PO4e4H2FPiG247XVkRoge6z1Dsqny9dTqvhROGN2a0nP9q1QO8FcqGRFCWQGtn4DxQbBsCDiPZyS0O4duaXtfbNpPswzpOHR28NEyWzHUhQW/QXrqONef1T7U6FLfnisTPlOkC0NiHmevlLEL+HhLtqk8sA0xQJDCX2ftYPmZyGSlac/ifaYMX9Nv2xVUaX4uQbcBUTiJyUwoXFn3clQGFi5JfcJJLemxDnVpZwkXFhSg/2unz8SnfZaaOAbXQO4xvkeVlIxXh/zjVYRaovotEYpfCRU78JKtyVVPMCHRpYYLt41Y2mzzXJoIEVbwg2gHb+zWS/MkiwTLn02kIXr8wv6YDTsoOvYRxjqicftL3pCY1jVtiwJIkCksyMpjWcjLll
 pMg+z0/d
 Dxyu5yYpSJkIlZU475qjn+cMAihbkroMsTtzBg5EYgZ/wp3FTU/7Yo4wBfiR7HPOcQHHKrnmFNk2TAUXYzQZAVFTY4v+TV2JheNTVp8xdXqyz5JhgLpAqLX1d3Z1oDngMZl8zva2v78AoEmTSsyYLPFaAaeQcDSEFCDcU78BFvISACVEhKEo6XENQFzDt9m6zR5Wb30SNwvNrMwqUJ//iU1tiZg4y+ADD2ykg400i5/kYam4Av7RktMR3HahwxayOX36DR8DCFT2K5ZzendZ2Lv0VehpuXvd46dDSAAo76hoxmqunzLT5fuBWV/SEiQIwes6l41zJmf+txnvS0s6rbZikV57l9g+uju2844vTqDcNb3GWWL3exBOwjUVuChknj20vvBcZZ0MgdaE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 12:43=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Tue, Nov 18 2025, David Matlack wrote:
>
> > On 2025-11-15 06:33 PM, Pasha Tatashin wrote:
> >> This patch implements the core mechanism for managing preserved
> >> files throughout the live update lifecycle. It provides the logic to
> >> invoke the file handler callbacks (preserve, unpreserve, freeze,
> >> unfreeze, retrieve, and finish) at the appropriate stages.
> >>
> >> During the reboot phase, luo_file_freeze() serializes the final
> >> metadata for each file (handler compatible string, token, and data
> >> handle) into a memory region preserved by KHO. In the new kernel,
> >> luo_file_deserialize() reconstructs the in-memory file list from this
> >> data, preparing the session for retrieval.
> >>
> >> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> >
> >> +int liveupdate_register_file_handler(struct liveupdate_file_handler *=
h);
> >
> > Should there be a way to unregister a file handler?
> >
> > If VFIO is built as module then I think it  would need to be able to
> > unregister its file handler when the module is unloaded to avoid leakin=
g
> > pointers to its text in LUO.

I actually had full unregister functionality in v4 and earlier, but I
dropped it from this series to minimize the footprint and get the core
infrastructure landed first.

For now, safety is guaranteed because
liveupdate_register_file_handler() and liveupdate_register_flb() take
a module reference. This effectively pins any module that registers
with LUO, meaning those driver modules cannot be unloaded or upgraded
dynamically, they can only be updated via Live Update or full reboot.

I plan to introduce unregister support in a future improvements to
relax this constraint. The design I have in mind is:
1. Unregistration will acquire the singleton lock on /dev/liveupdate
to ensure no new sessions can be created during teardown.
2. Verify that there are no incoming/outgoing sessions.
2.  File-Handler can only be unregistered if there are no FLBs
currently registered against it.

Pasha

> Good point. We also need when using FLB. You would first do
> liveupdate_register_file_handler(), and then do
> liveupdate_register_flb(). If the latter fails, you would want to
> unregister the file handler too.
>
> --
> Regards,
> Pratyush Yadav

