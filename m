Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8714E7E0AF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C366B008C; Mon,  9 Feb 2026 05:03:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED7C6B0092; Mon,  9 Feb 2026 05:03:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023946B0093; Mon,  9 Feb 2026 05:03:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1DBA6B008C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:03:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E7B88C3EC
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:03:33 +0000 (UTC)
X-FDA: 84424481106.10.AF77394
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A039F40002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:03:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mV7dtvyw;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770631411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGb08lW+Zhk1I2JWNlQKbjEdw1lWShONuyidTRl6UAw=;
	b=cz1lqVVgLAHcAHMua8PqiloFwAVjF+/IBYbatDdayoUhCbDhHAh8VnXmSyJxTLvy04Wown
	MZiKyWhKoVLkLmtdg92HRM9KOuRfnXMZxNLYZdE7C6Q/n0tcH79V2xlm41Mr2iVozC3+6a
	5hekaJ3OSASOnoPdgCqGGO8oVCYQqcw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mV7dtvyw;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770631411; a=rsa-sha256;
	cv=none;
	b=AS+ZySsK7lEDGyEPxYrin1+faSi/xlNiShyKVrizZN62FQkgj+LcY4XBw7X4HucwYm+7dz
	z4I9rz+pM8DIQIASsMBIKsxYDU7/jMCbw/soldSKlrPvM09oVMMLM1b7ZtP+RkhLMb+LZ0
	CPmK3k0xQPwTCVSuMFcg6ccjf0QnzP4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D7E0C600C4
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB7BC2BC9E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770631410;
	bh=xE3j8NVU0S43Vi8Kms5RnGUIbpIPaxuF9l00xrrETBk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mV7dtvywDcK4sdTYnpzZZQuVwucy8E1GLlNUJTwp1CG8uVaqrXWuEKoS3ZjYuFMoa
	 EZrljNF3VLwKvqQvVrzHao2TqI5a2GQTEVjNuQWeFhXKerBfgQxc6rMYPMCXqyZNbR
	 vXu8UW/K8bTVQu7fgqs6B/p0XI8hXtoaExv5SBCulTjW9Ms86tcfyuQPXfK5W8CpDf
	 Yv5SDO8afqoQYuSKao7FvYKK95mJhStPK3qggtxiJ0nDr3BpJawteKfQsp3ogcqstd
	 f/z1p7B6nCAVAcoClHH6WHVfvJCBH+L/FSopgXSvy+5XBay2YGNEJW76Cn67g+c/rJ
	 6UZ9ZHyMCktag==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-790884840baso38699547b3.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 02:03:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXFukCBJz/aTQ/ekExvZdPSt7b8zVdPfxK3AIseOh2letnEQdCTbWSNJVIxHiQMWwWMoD/4KIUy+w==@kvack.org
X-Gm-Message-State: AOJu0Yw6+MGwf57SKbTYsT8AlQA3yfG20R58qPRmOpoHT+Z73tpXBrFM
	XGH0DoiWjP7mkQFv8GNaAC5yXGLDcREh+cDdE4Y+je+3orvdEbSRfyKzJI4w5kSTHvnlvSrTOuD
	YloZsP97WHg5eeP77mtHbAdxYtM1rl4sxZrrF9K+5xA==
X-Received: by 2002:a05:690c:a96:b0:795:e10:3c9c with SMTP id
 00721157ae682-7952aaa780dmr100866807b3.29.1770631409841; Mon, 09 Feb 2026
 02:03:29 -0800 (PST)
MIME-Version: 1.0
References: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
In-Reply-To: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 9 Feb 2026 02:03:18 -0800
X-Gmail-Original-Message-ID: <CACePvbVH0ovOcBqCN7kJ3n0QFmvuf+_5tMeRXs-JAQ+m5fdoCg@mail.gmail.com>
X-Gm-Features: AZwV_Qjeos_xGeoSPEqb_Nm-xUatLudlVqnasCFc34nCWxZ9Bx_b5Ln4iDFXUhQ
Message-ID: <CACePvbVH0ovOcBqCN7kJ3n0QFmvuf+_5tMeRXs-JAQ+m5fdoCg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Machine Learning (ML) library in Linux kernel
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, 
	Viacheslav Dubeyko <vdubeyko@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	Chris Mason <clm@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A039F40002
X-Stat-Signature: gwti8rn5z5tjnudcyhcudy73rxssbrwp
X-Rspam-User: 
X-HE-Tag: 1770631411-310134
X-HE-Meta: U2FsdGVkX1/7e+vuT/Y1RIsQCC5xjPftaZ8iag/abkI31BEK9RdvCYzG2NPGHbBp9jBppj3KmwHSDHig9Mq1bk/kp1kluPYDLUNUI1dtsQhzhhhQzB52ATYAw53tOvSdpgPMda5yPz3SqPgAOYMeBQ340nZEyQmFdfvXr+f3d8N+L56Z7o+BX5JI6tzpF1PLHB9xFwVyHuBcgU1eXkUCJCkrE0VJD6k28Sm9OVBt3M0eiu8B2grRa+yDsXGCcTgkaTeq+lRL1bYf4xLcBCmLy21kh//giMGwkks666KB6lXY3xe6B4AkW0ee8fVx/a5VoRO/0PTboI16qH06LZPe9X2yB7y0to82waHUVpa2tXOcHLxksxvcb+9q/DOeUzXFq2coyuLL9anlqAHXm26s+nUYQs6iADiE49vIvlqtt6cKvxHIsOa62XUlGfexCBlSgTexSgZ0ytHryvhI0YlXitxVraujH9is3YKMcrIvRpxFzVm37IHq4dCTiuIMWS0iTPN5xMGcKTDDN4LpU1a/PtRpUTmeytNnzg8mfba/r6EsQLQ6D57V7ijD3WYlnL6IXC0tdCWBiVrgpNqOsIRtuM7P9quo8lD/gKkuxbjMmQKFut71NZUVN5ZzMRzMR0hh+HS3HmuZmokc3VaqCBU9BO71PomNKP+tFUF6jsssLG8ws8oz13TXfPPkqeAvBOKX/tawUC5HBAHmOfxxAR+eK9eeR8rv8wYoHFbpea2JLRirePGV6s3YaevmNJuOp+Hhe2x70XEhm28R2WOKMUze5CTNSi5plH5UtT284dD1v6DghpRtYAlvqD7J7Mfzs5yiw07/Uo2Kjp0NYW5cfX9RXwWBFnBQBoFyhsiwA4HUDMrn93+gpRIFTZoT2cnSjrBo2bxP4g8Wfhtx9Hg6SS0tmMGmX9anUBsLhF6iOsOkiQT7og0z+sRU7DicgSD6UPQkGvJpGTxr+AIOQiPVv+b
 QWRFRGBu
 7tgj5+oCOEzbtelN7EXIoVodz+N7gotXfgZxWsH4DxF7HbjKK+Xra853Cg5wPpVWXx0n6SpK1V8A2cTsAe8W5vt3FudEjD4GtroNiJx2racP9OMsVOXzZ+u0Mrr2S1rCctIazveVU6kMxDc8Xbp39yzmgHZNuyeyDq0INt6RMbLfzO3WcbxcB9blyjJnslE4/MeLhRx/IMqZXgKvFta15pRnT9nekmWVqvFh0lMT/Ub2vkzpsIHD+cZRovKsIEk0022CPrwP9/vK/+ulqJBE40Z0FGEquFnVs1V5bnLT1PpIizXQCVXkFrnEsl9tNpo/COgcOu9UHSgthAClCUOXmZXA3LBGpOKN4v4/QoIfcFeSEYcMhED2n5u552g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 6, 2026 at 11:38=E2=80=AFAM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> Hello,
>
> Machine Learning (ML) is approach/area of learning from data,
> finding patterns, and making predictions without implementing algorithms
> by developers. The number of areas of ML applications is growing
> with every day. Generally speaking, ML can introduce a self-evolving and
> self-learning capability in Linux kernel. There are already research work=
s
> and industry efforts to employ ML approaches for configuration and
> optimization the Linux kernel. However, introduction of ML approaches
> in Linux kernel is not so simple and straightforward way. There are multi=
ple
> problems and unanswered questions on this road. First of all, any ML mode=
l
> requires the floating-point operations (FPU) for running. But there is
> no direct use of FPUs in kernel space. Also, ML model requires training p=
hase
> that can be a reason of significant performance degradation of Linux kern=
el.
> Even inference phase could be problematic from the performance point of v=
iew
> on kernel side. The using of ML approaches in Linux kernel is inevitable =
step.
> But, how can we use ML approaches in Linux kernel? Which infrastructure
> do we need to adopt ML models in Linux kernel?

I think there are two different things, I think you want the latter
but I am not sure

1) using ML model to help kernel development, code reviews, generate
patches by descriptions etc. For example, Chris Mason has a kernel
review repo on github and he is sharing his review finding the mailing
list:
https://github.com/masoncl/review-prompts/tree/main
It is kernel development related, but the ML agent code is running in
the user space. The actual ML computation might run GPU/TPUs. That
does not seem to be what you have in mind.

2) Run the ML model computation in the kernel space.
Can you clarify if this is what you have in mind? You mention kernel
FPU usage in the kernel for ML model. It is only relevant if you need
to run the FP in the kernel CPU instructions. Most ML computations are
not run in CPU instructions. They run on GPUs/TPUs. Why not keep the
ML program (PyTorch/agents) in the user space and pass the data to the
GPU/TPU driver to run? There will be some kernel instructure like
VFIO/IOMMU involved with the GPU/TPU driver. For the most part the
kernel is just facilitating the data passing to/from the GPU/TPU
driver then to the GPU/TPU hardware. The ML hardware is doing the
heavy lifting.

> What is the goal of using ML models in Linux kernel? The main goal is
> to employ ML models for elaboration of a logic of particular Linux kernel
> subsystem based on processing data or/and an efficient subsystem
> configuration based on internal state of subsystem. As a result, it needs=
:
> (1) collect data for training, (2) execute ML model training phase,
> (3) test trained ML model, (4) use ML model for executing the inference p=
hase.

As far as I can tell, a lot of those don't need to be in the kernel's
business. It is more of a GPU/TPU driver user space interface thing,
might be easier to allow the driver to convert their own kernel/user
space API then expose common user space library API. Are you trying to
define something like Nvidia CUDA at the kernel level?

> The ML model inference can be used for recommendation of Linux kernel
> subsystem configuration or/and for injecting a synthesized subsystem logi=
c
> into kernel space (for example, eBPF logic).

That again sounds very much like a userspace issue, the above 1) usage case=
.

> How ML infrastructure can be designed in Linux kernel? It needs to introd=
uce
> in Linux kernel a special ML library that can implement a generalized
> interface of interaction between ML model=E2=80=99s thread in user-space =
and kernel
> subsystem. Likewise interface requires to have the means:
> (1) create/initialize/destroy ML model proxy in kernel subsystem,
> (2) start/stop ML model proxy, (3) get/preprocess/publish data sets
> from kernel space, (4) receive/preprocess/apply ML model recommendation(s=
)
> from user-space, (5) execute synthesized logic/recommendations in kernel-=
space,
> (6) estimate efficiency of synthesized logic/recommendations,
> (7) execute error back-propagation with the goal of correction ML model
> on user-space side.

Unfortunately a lot of those will be tight to the internal
implementation of the GPU/TPU. The model needs to be compiled into
GPU/TPU machine instructions. So forcing a common interface will be
hard because the lower interface requirement might be very different.
Maybe having some common user space library or ML description language
is better than forcing a kernel interface.

> The create and initialize logic can be executed by kernel subsystem durin=
g
> module load or Linux kernel start (oppositely, module unload or kernel
> shutdown will execute destroy of ML model proxy logic). ML model thread
> in user-space will be capable to re-initialize and to execute
> the start/stop logic of  ML model proxy on kernel side. First of all,
> ML model needs to be trained by data from kernel space. The data can be
> requested by ML model from user-space or data can be published by ML mode=
l
> proxy from kernel-space. The sysfs interface can be used to orchestrate
> this interaction. As a result, ML model in user-space should be capable
> to extract data set(s) from kernel space through sysfs, FUSE or character
> device. Extracted data can be stored in persistent storage and, finally,
> ML model can be trained in user-space by accessing these data.

Currently a lot of those are happening in the GPU/TPU drivers and user
space library. One challenging aspect is the hardware interface is
very different between GPUs/TPUs, and might be challenging to expose
common interfaces.

> The continuous learning model can be adopted during training phase.
> It implies that kernel subsystem can receive ML model recommendations
> even during training phase. ML model proxy on kernel side can estimate
> the current kernel subsystem state, tries to apply the ML model
> recommendations, and estimate the efficiency of applied recommendations.
> Generally speaking, ML model proxy on kernel side can consider several
> modes of interaction with ML model recommendations: (1) emergency mode,

That sounds like user space interaction again. Not sure it is for the
kernel space.

Chris

