Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B088D606EE8B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=P/mE4Thg
Received: by kanga.kvack.org (Postfix)
	id 93CCD6B05BC; Mon,  9 Nov 2026 08:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914266B05BD; Mon,  9 Nov 2026 08:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82ABF6B05BE; Mon,  9 Nov 2026 08:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADAE6B05BC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:44:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC34BA06C5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:44:37 +0000 (UTC)
X-FDA: 85415700594.09.9B688EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 75C2314000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:44:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="P/mE4Thg";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794231875;
	b=DVWdaSOsQIIdFsRxZd4DgDHPtH6r1eFFX4emRnjKfFKO9IB/cjNbwNsH3YAfCRvNxGAchD
	mt+U+yWxzjq+9B80ovnIlDYPoyrDFnzH81/Jt4Gyk1rgGR9+MYZ1wq+M1YDMrTL/1eabIi
	+l3aH7uL2uwCTsum/TSdixbJNShEGhs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794231875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bghOY7pp4PqTwolmTpdD1zvT8+4Tek4EN2nSOV+gjQQ=;
	b=eXL26rFDiKbyZLWIfOI2zwJdw6s7uRYnQZk4aS7UjANJE1mYgkLlfKPp3DrP7S5rkFh7QB
	TyIPoxhR/6koSC5w2t4zANCRdUyOey6cQPu6eeNj3zmnrcHVo53S3dM6ZbdNmx1Vt1h6l0
	V7O01Vk7QUAlz2ue50Xb5XqXV0IjSt4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="P/mE4Thg";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794231874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bghOY7pp4PqTwolmTpdD1zvT8+4Tek4EN2nSOV+gjQQ=;
	b=P/mE4ThgSArpSm522y0c7dkmQFX4oB7KC564ySEL4om9ejOGpeQzkI5nPVuDnAri0yDxFT
	BeqnEIPutaZbIW9YmEvHlWARh2zszUbRgkFMBvQn5gaIPxsgHaR0wI0QjIWC4BSADIYpJ9
	xF9sEPPt7Kw+I9dKsQn7X8RWNUevR20=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-bkueC3zpNYCudpf151ENBg-1; Mon, 09 Nov 2026 08:44:31 -0500
X-MC-Unique: bkueC3zpNYCudpf151ENBg-1
X-Mimecast-MFC-AGG-ID: bkueC3zpNYCudpf151ENBg_1794231871
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-47d75bcf3ebso888339fac.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 05:44:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794231871; x=1794836671;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bghOY7pp4PqTwolmTpdD1zvT8+4Tek4EN2nSOV+gjQQ=;
        b=WgQy10EK3B0CqLZNLqJPHArBCt/8HK35Pl0oa/XKeeKaWcDpPfq+HPMfAvZhYkoydv
         cHVWai9DNfdJmBQ94BpIq+ODPHLZLPxhZwnYL26IjrohaYNXkFbNbywfwbez+b3C+tBr
         +3SFhTT44v3l6qx+bG2JwRP/BQt+1YDZnvsTX4e4415OpZro4Jp86WhkGKqouVU4iL5U
         ShjSgFuZ9jRY3xDhpJjFGjN+czDX/gywswZ9ZsecXGJPdd6nJ3Wr1g7grtY/AoAabpjX
         cv7OIoxBZitXW93XyFsdnffdx3jyn0v3BjgazUc1FZJpWRLrt+y7bkPdPlNG8NXKCWxQ
         I1Tg==
X-Forwarded-Encrypted: i=1; AL+hErF24Ic+j/jrmvU2W1t8XXpXFNSJl7lSkuMU11Ylh2HSzJHYNwX43B6Ce7QfwjxpGpR+RKA0Hmj3hQ==@kvack.org
X-Gm-Message-State: APuU4Z9UNArt58wU3/mT8c9d9ihGSVLI+sFi5klNHy8OaXehUVvUtq+0
	VQZb87mL05pflL9C/Db0tgWBSY7ljjIxgGA9v3MNLIyq0FgOkD69WxUW4Hlu/qaz3P6H13DWElo
	7eIKH/z/apTNs0wV/5DmFh6ylLgnSDYP2zwMqVvfAU2Y5axORh4pRwAKSMMHhhv6W5y2xNFqugG
	tPqYfPvnIEyLQ58gt56to8ptUQzj4=
X-Gm-Gg: AYBFou1mp/N/lzY/yZ3clcpXRMGXHyPkoV/IHWA1q6VwwzNRqJD2Lmz1q9Uil0j5Fy6
	B3ktZZ/a7ZTi3SwjbfFdC3aicnzLQTveVcwufdW1S6Ijj2o3iruU+p3eXVqoiLsmEK11lhKiC9V
	sspuT90B3wuuaEphLYMFi32WwH4RJKxoPK03IYN4692jU3vFxdA3Y+xMom
X-Received: by 2002:a05:6808:4fe9:b0:4d7:17d5:6c9b with SMTP id 5614622812f47-56814022659mr2709806b6e.9.1794231870766;
        Mon, 09 Nov 2026 05:44:30 -0800 (PST)
X-Received: by 2002:a05:6808:4fe9:b0:4d7:17d5:6c9b with SMTP id
 5614622812f47-56814022659mr2709756b6e.9.1794231870169; Mon, 09 Nov 2026
 05:44:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106131829.3228926-1-cui.tao@linux.dev> <20261106131829.3228926-3-cui.tao@linux.dev>
 <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com> <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
 <b0f530ef-bbfd-4112-aa51-82fdad6c4ba2@amd.com>
In-Reply-To: <b0f530ef-bbfd-4112-aa51-82fdad6c4ba2@amd.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Mon, 9 Nov 2026 14:44:17 +0100
X-Gm-Features: AclHuK-kxgj3T37bjFOZ7HtSClpdxsaDMPyjW53dccz7zE1_ZSRFcURRmSZwzSI
Message-ID: <CADSE00L3AfcnfcboK1TdPQiW7ZW1KpxG70b1oyWFqpLciOG6ng@mail.gmail.com>
Subject: Re: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org, 
	dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com, 
	jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com, 
	mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com, 
	stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org, 
	vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca, 
	kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org, 
	James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org, 
	phasta@kernel.org, joro@8bytes.org, will@kernel.org, 
	linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com, robin.murphy@arm.com, 
	mason@kernel.org, harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4jllDLTPQCcz_6YAMV0w7dn4iYMbDazNN5ya5fxXdY0_1794231871
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 75C2314000B
X-Rspamd-Server: rspam12
X-Stat-Signature: 9s78roje1a15gebwpwib3mz1zopuc5nc
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794231875-309102
X-HE-Meta: U2FsdGVkX18xmkVRTHYPxJnkfM5Po2cR22te8PJvX9rkQ+h5LSe6mYolPK9wTUsyAqksjmfPT24mxCaepqqtfqBFAaltGNUkOEUYsA9LhW5QOydPJhlH60gspEANJh9bZPRhKZkmX63zexjauuimx8OUNRh8D4JiBTqvNP9Sr9zHHPD64OyiD/Ul8wsMGRbURKj6JemHkPw4H+8DER1qNVGWaA5wyDkWJMhhLAx4xnRgSQbX71tRE3WyiWVc27Xmg2LZbUup31RNoxXUV43zM3vjDzQMtK3jfWkwLdy1lw3y8S3lsreFc6rvK2ZXbp40sCVpccSYGP1hORWLMbs0PxpLu/EiSnpd++3o+Zl9A5oBNie3zn1dxaZZ5nvtU/QDktdZFDMX471i4/emx31FJJ8ziMDpU1Qd3wZIhqCAMCFnRbH8zmTVwZY+Xmtz1A8HKgwRIUuvrcD1Z95O47a8v5iTlL6ulGJre98KcT0C8SxjMVcpd6t3njc2JYx6n6cvOhn9Pa7Yl0AE1OrOXLFnSTbmbOxibPHCaWuX3p/jc2Ve6C7+7eN0gWb/ht1VieB31L+D+7LVazxF1stdRLb4j0MhKZF9IpvWcSgUcsRFF1q6dkcphIaAKMpjvvj0I/ux3T1KOfdeWWtu3PGJofCWACELjMOes1HlYnSCIXGxQFPCRDncZIWtI4OPAzmI4+HIIwnIg++osTBjp543vGp+UFgpbrZOX4unu6JVagdlUk3U3QOGY6IrokyrfO5hYbRKFv6d+XHcEfqt/0lubSszHtKxiNbGhANOJfMZnXhae8E2zWux/A3RGYl+dv0HaRRy6+ze+EToviNbOmxtL9kLHgd3qdSOfXx7lltNWg0vm4BU8b+LJDbWQ+tUMoOyjLYuuoDz5u2xgxMlNvPmuu5PPues21OZiaRdJyBD+/bLWTiVpjumi6FiU+CLBwek2rqueVePRVeKlQSLUnPDf3j
 +xCLL7z4
 wliRJO7/BPNzx0sjLH8m/W/Xmg+1alxCKHkAF3/jUOJRpMByhJkQLDclla+nHea80ifVL/mfuANi+iibiVwbea74USrNY7jqwFX9Z9kxgXI8U7i4t0z1hVL5ZeuKvibfZ1jkOKNsqn85KeHyZ6db6mzZeufrsGUyI5Mot4GlXo8R4w3OCSs5owLQQlfmSQSOmhTABGjuxxADjksBbWWOR4kIGaP6btaDCBeQdIgScb6s4HyQ6PfFx2uy1Bogi1d1SPLI6RiBUeonNeLnTvZsC1yjXs9rs9OdJeeXtuwfDNO73GTHafQd9ysuqurWrHWRnBx+1hfb4JmHvFwj17tw93DmXrz76ZWcWzpYUhzuvto7yL6B6iFWqu+6rBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 11:56=E2=80=AFAM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 11/6/26 18:25, T.J. Mercier wrote:
> > On Fri, Nov 6, 2026 at 5:23=E2=80=AFAM Christian K=C3=B6nig <christian.=
koenig@amd.com> wrote:
> >>
> >> On 11/6/26 14:18, Tao Cui wrote:
> >>> From: Tao Cui <cuitao@kylinos.cn>
> >>>
> >>> udmabuf pins the pages of a memfd and hands them out as a dma-buf.  T=
he
> >>> data pages keep the accounting of the memfd they were instantiated in=
,
> >>> but the bookkeeping around them does not: the page pointer array and
> >>> the pinned_folios array, both sized by the buffer page count, plus th=
e
> >>> transient folios array sized by the memfd folio count, are plain
> >>> GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
> >>> memory, and size_limit_mb defaults to INT_MAX.
> >>>
> >>> Charge the three kvmalloc allocations so the creator pays for the
> >>> metadata it induces.  The system heap in the same subsystem already
> >>> accounts its buffer allocation;
> >
> > Only if the mem_accounting param is set to true. We (Android)
> > currently depend on it being disabled because system heap buffers
> > don't have a single owner for their entire lifetime (ownership often
> > changes immediately after they are allocated), and the kernel doesn't
> > have the ability to switch who is charged for the buffer memory quite
> > yet. Albert is working hard on it at the moment.
>
> Good point, making sure that Albert is on CC as well.
>
> So basically we not only need to charge the backing store of a DMA-buf to=
 somebody else, but also the housekeeping overhead.

For system heaps the housekeeping size is fixed at creation so it
kindof fits the reservation model nicely. We'd only need it to account
for the overhead (as part of the MEMCG_DMABUF stat probably).

>
> Mhm, this here also complicates the charge transfer Albert is working on.

The transfer would just move the charge as a single unit. But yeah,
the complexity will come from lazy exporters or any other exporter
where the bookkeeping grows or changes.

>
> @Albert not something we need to take care about now, but please keep tha=
t in mind while working on that stuff.

Noted. The issue already exists so my series does not make it worse. I
will note this for a follow up series.

Thanks for tagging me!

BR,
Albert

>
> Regards,
> Christian.
>
> >
> > Could you update the message to note the mem_accounting param pls?
> >
> >>> the data pages here stay with the
> >>> memfd.
> >
> > memfd / udmabuf is a little special because it uses shmem for the
> > backing store, which is already tracked by memcg under all conditions
> > (except hugetlb). We don't currently use udmabuf, so the lack of memcg
> > charge transfer for udmabuf is not an issue. But once we get charge
> > transfer working for the system heap it'd be good to follow up with
> > udmabuf.
> >
> >> T.J. needs to take a look here, but I fear that this might break uAPI.
> >
> > Thanks for looping me in Christian. The buffer allocations cost
> > gigabytes, but these metadata arrays are only 4MB per 1GB of buffer,
> > so I don't expect charging them to break anyone. Leaving them
> > uncharged is an accounting gap though, since someone could spam many
> > udmabufs from the same memfd and only pay for the memfd pages once. So
> > this change is ok with me.
> >
> >> A lot of the DMA-buf resources are intentionally not charged against m=
emcg.
> >>
> >> Regards,
> >> Christian.
> >>
> >>>
> >>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> >
> > With the commit message updated to mention the mem_accounting param:
> > Reviewed-by: T.J. Mercier <tjmercier@google.com>
>


