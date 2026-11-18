Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4FBC606A338
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shazbot.org header.i=@shazbot.org header.a=rsa-sha256 header.s=fm2 header.b=yboADhoD;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=uAEfQ4je
Received: by kanga.kvack.org (Postfix)
	id CF7BD6B05C2; Tue, 17 Nov 2026 19:26:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7376B05C3; Tue, 17 Nov 2026 19:26:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4BFF6B05C4; Tue, 17 Nov 2026 19:26:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC786B05C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:26:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1955C405EE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:26:45 +0000 (UTC)
X-FDA: 85446349170.26.E0832EF
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf23.hostedemail.com (Postfix) with ESMTP id B423C140003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:26:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=yboADhoD;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="u AEfQ4j";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf23.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.158 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8/idSoRxa60yVuvuxTHG+svsK5itnaUZB6//PDgs+Y=;
	b=7u0HIYXCRQfEz81p6oIRtF/aF4deSCNzU+GX+dkTYy3N+zL8R7+jhX4junrn2u1S2D7M9r
	lUMcbLY3w5DWlIS0qdyA6hTlxneT0ViZUhAc4KTB4w+i7b+1xbOMvskIZiRuKCQLImLbe0
	669xtfSbHe9vU0KeRd4mqh87EHANGG8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=yboADhoD;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="u AEfQ4j";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf23.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.158 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794961603;
	b=St6uSIV6WHTMmvLdiEcGiFgAO03yR5ruL7UciUHvbsvFr+z4tPdjS+Ni7Z/cYt6zI6jEWh
	Wy95Zmt2SOh0zrPJFLJq/8ma8Xlh60eQiESXAmMio5Nrake796/K9e2M43xpKutGOruyD/
	GNb+m4snxcdsNFJ3Qg6aFkZB/DkZcp4=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 26CE3140015A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:26:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 17 Nov 2026 19:26:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794961602;
	 x=1795048002; bh=V8/idSoRxa60yVuvuxTHG+svsK5itnaUZB6//PDgs+Y=; b=
	yboADhoDFvkdIVf8qW1HRyv4NHCnp/7kVUE8D+bHICMEJT4w2C0q2610InBhBvzO
	JbaV5aQz/frvwAg/ztQjZaLfBzxET5KB2FK8TL3Wy2oQAfQ4oAiIgoRGU6L6PqZo
	QPdwmDvUR+SGthA8l4j4unEpNfbqO/0BAZuTlTDg1xCFAIpUj7MFu/mIE+6CbXB5
	YvgJzklxViaMxLCOFtNQQnU6zB7x2GpumjZD3SvQolMbZsI8aNOJ38LnM5Bm0zHf
	3czjIpt4sknsBBhOyI9XKDLi3P/n1h7+L9SexN2hXnTjJ1r8DM8XQ/nZLmsYdMc4
	wU8E/dhZttX1T7zNpzkKqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794961602; x=
	1795048002; bh=V8/idSoRxa60yVuvuxTHG+svsK5itnaUZB6//PDgs+Y=; b=u
	AEfQ4jep/VqSQnZKuj8d/+3qJe3GvvbhuJL5hy9i4HAlSR/4hOd5t6N+FobufyzL
	Mh1r6m2cm5fM237N2Dk1v6nO4dxv+ACFzrBuEVAQgevEQTMti54/8UN3yw48wEpT
	d6EotXktszs78UZt1FVx7DS6dFJvL0Gauw517UJUSm9KWcvPwq9EVzBLyExlgPE/
	sbaUod6sxLkIrztfwQh8bZVj+qtMtNitTaMgMn4ksRucIqy2QXoqmeiCgdLsGD4O
	PvxC9PL6P87cGPRhY2aBBa09kXyK0zArp3pJ28Na6IvluIVUy5AK7bkXv954j8mq
	z6V0//yXYTd5518sBhvzA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=shazbot.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794961602; d=shazbot.org;
	mf=PGFsZXhAc2hhemJvdC5vcmc+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:u3YSIklSPLC9Slnekwcae5nP4zn5ci36SMrBTKE3Ua0vzHP
	NmPIAasZAqvADQdIYJsQjQ2DlJIXmM5BGujDhdwCz1/cJ0WMu7e2I0ZBLpT+Yc6+
	fpyi94m9bIZSD5PU2A9cf05akYaljjQ1opA92qdLt5kytzgYJuRhtsoosfy5zxoZ
	WfC3PWCtNiRb8ueFF/NSKbYja/d41GMdTGMpeOqgH8rTMgHjvu9Ja/P+wk9Bc/Q4
	NNOmUerVYZno9+Pau+ENZ5DahPMZh8tXK2DBi0QHKKUgkvpXaIbaBoP8CTCrmHWJ
	3U1keNsqogcGYjpZXwxl3AR9RyfUSZe5LsuwCQw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:wYac0NKm+NeGHfh8T8OT5UGUwGjZZWRzI5xur6Vqi/0=:yTBUT7ksIN2zAre6QifLpTP0c+mMMfgeIMdRwVxBPoU=;
X-ME-Sender: <xms:wPD8ar3RBMFuDZEN5yOl5QICQiPjjx1eD-WtocCexXEOyHc3B7Ko1Q>
    <xme:wPD8ahAdTL1H7VxqjRP3XfECcqwEDcoHU-GtqmM5qLkt72Hb10URJIZkQNHv3eWPf
    SD57Fz5_8V6yugOg-h3iQf7oklLUpwEdnfCFA4nUu8ZLV_oV9KAIOM>
X-ME-Received: <xmr:wPD8aiVrBTI-h7lfwyMN7QlNJJPD0Im67py5-OYqwXieeyaCYNI-Bx8xZAZz-A>
X-ME-Proxy-Cause: dmFkZTEpYZeWt53FpiAM4kDCGUzOck7rfPEJxqhQL5kWkxeezxYO/nYtxVtuytY1d4ZmMx
    QFc+s3ord4eFcQ31FkOV2OPL4/LLiaenZ5wubmUKUTXtaX3zIi6p6MgNgZXVbP7m5hkbWE
    nQn5t72SSph1MPoTq+QVy9nFi7Y6JDy3WtwaztZ6TAp2e8mr9D+284UQDflHZajJM4Nfl0
    LDkAi1cZAXTyUeOjtpUdNXD/kbN6cacIX1BUL4K0EA5DAId0mujN5d/JDTWCkD+kMDqJhg
    HXOvXnqML1ey7mCN6IM3b7hWT5SN1Cr6Mskfeeothlu+dPAil6D5zTHGAOPUjRSGJSmzEj
    VHHL+07tzU9wg5nuA/6cSGanB7NuAfmMRVGJHsBCTluz4G2Dn7ef8q7ysZ0GETqlzzTSyD
    G9kKkGOtFPvvj8ohDrpKD9mwdpgpA73vbC91g4cVokc0TGZrnNhNqpmAJKmm0zVqoOS3zB
    /D7i49GdieGpOYwWeeY/CvSpuD5nfiVNtOD90kX9l+vDYYxBBSsL09zkJYzjA+4P+46b5o
    3r9gjXeNXwEUZh/zmQfWDQTnhcAhsO/gglbRddYva+t2n7iRKi3DhCK25nlqxjfu0ArqCv
    CcRYUocYyZml6FDF6Lr0hmuHnvrRxaNBdO+hCb6XSD/UnoJNd8NBVHFzxolQ
X-ME-Proxy: <xmx:wPD8avXlIEhPbw0NOoNphI6PABBv3q3D9eSNSEqjAHWKa8sGf6ifFA>
    <xmx:wPD8avQ2PeZjwFvwQKuxSXQfqWo1mcsP04ZPJxD4_NlTe5UykoQiAw>
    <xmx:wPD8ahM0_o3xmmeJOUE7QTxE9fGIf2pHqLN3RbVyXVUP2shb6zol4w>
    <xmx:wPD8aruAWy74Buzbu8S6Fk13HuGeVNl_JItbUoXmHyRFhWebp4rmfg>
    <xmx:wvD8atopX67BHANrXRDx2ufeVqe0KildWrrNuvYfQpGR-8NANNOybTql>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Nov 2026 19:26:36 -0500 (EST)
Date: Tue, 17 Nov 2026 16:26:34 -0800
From: Alex Williamson <alex@shazbot.org>
To: "David Matlack" <dmatlack@google.com>
Cc: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-pci@vger.kernel.org>, "Adithya Jayachandran"
 <ajayachandra@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Jacob Pan"
 <jacob.pan@linux.microsoft.com>, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Josh Hilke" <jrhilke@google.com>,
 "Leon Romanovsky" <leonro@nvidia.com>, "Lukas Wunner" <lukas@wunner.de>,
 "Mike Rapoport" <rppt@kernel.org>, "Parav Pandit" <parav@nvidia.com>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pranjal Shrivastava"
 <praan@google.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy Dunlap"
 <rdunlap@infradead.org>, "Saeed Mahameed" <saeedm@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vipin Sharma" <vipinsh@google.com>, "William Tu" <witu@nvidia.com>, "Yi
 Liu" <yi.l.liu@intel.com>, alex@shazbot.org
Subject: Re: [PATCH v10 09/13] PCI: liveupdate: Adopt ACS controls in
 incoming preserved devices
Message-ID: <20261117162634.2e04ad3f@shazbot.org>
In-Reply-To: <DMXSQHZG5L27.2NIIT7F6FW0ME@google.com>
References: <20261013162529.1928093-1-dmatlack@google.com>
	<20261013162529.1928093-10-dmatlack@google.com>
	<20261116170942.720b06fd@shazbot.org>
	<DMXSQHZG5L27.2NIIT7F6FW0ME@google.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B423C140003
X-Stat-Signature: 7skyyp7q57d37819ztkr1ru84dfdnf81
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794961602-410020
X-HE-Meta: U2FsdGVkX1/cpTfBs5bKD3mcyDPeB/Hh4f0d++UfqPw8JYpAWZHvvzRH1lKKAU70Oh28Iua7krHfIFulWJQvy/zDH90gq7QmbQGx2R2pgp1PX/DsWVS+Y1inAxQkZzw06xTq4lUgLAUIyCeQ/a4EPWJH78U3z0cjIRnbLKQSK56PiRElGGxlPZUzRlfw1PO3V0LWzQ0SPTMPOZFxqBLvNVnCM2j7f4ynL4wVj2AiuKt+AO/qVDwk0PJx12TcalBtgQw27ddyCSZuBiq5Qm2jcaZHFjh+6P3bhJPTkZRxb/3WQGxYqXncC5uRqmz7dZBpFbCA6JiUNdnotwXvGNm1ObPQ2gPo9D6CSWr9k+Kfj6SqxZp9BcHSphxMmVVQJz7NbTeSbDM6YNrtC8WeRR1ld02JhbJt0M+hR6iHdVfsiYzo+Dnjy4U2IkFDnq3cr35/p9Wn/mhap5PbGKC/0JJMz3wVcjsIDYlvw7npcLeVXG86GhKUbAD1WMcqWYiW4OX9id2TtwXiNL/7G7P4WnLoIz7JgNxEGYW03AhlX1FalZB4LQXEysa/P2nWkHE3i6ZokPm7aeBiwFftE0JD2fphxEL7qS2/Pduraoc/c2Egh31padWtF6MrwwCBbspH4bKzWRWZFonHSdQChPMF6XFGzHo5Nn3ZVfPwpf0wwJIqK/LbiVlPlUAyEhjH4FAEgxqDX2MHUVVh/tMEc4Y2CrjKVRu2zqeQzUOefwCzlC+npkcheIBxjPJSVMf9E+fM2yGch2wmKNxK16Zb1RkS53FYC+P5flqJ7Wb2gRHhvLDb8J/3yBXzjeOoVYngvDNsXWZM44G57VByCjStIF6Vwc4YXk+tK87HXPLtnWEk+qQm/7K/E6TrtCQBEj8JcYe4N5sJOdmWTzYhlbkf1yNNMjfqbK0A3GlLhAWNzx/caY603v7rcX+4ZU1P4DXoFCSoOrbvPyAtkDjm7H59xjHPBdw
 5IwPw3pA
 dsrScJh4CT+mr790tcRmGAz+2oWPehFYdpYGiSRZS2aoFvdWJJMsU1QJhCRbuvGFewOdRH8SDULsqYB7udQ9AzwaQak60Y9OrlF4pgMobs6bWTrisRw7Fpg7yz3F9zDtmD3PtoStRV5mdhUJogls+IUOnHK9rMlm9OLkbxPaHKrXU36GvclDekJsT+eNJDSbiXXMHz7ACskmd5zMgu44EV4HgrC1euJzzMUxv4G2ahN81s694IpJLTsrAHtz5B377UBSUk7JvKVYPVm0QISsF32zXkbrGjua67sSvpvAKQkffeF5qZa1rk+EXBZqN2YWuYdRlbIoe9ML9EbmZPcklkjLF0D78eNjFp2RMpfHzNddEdutn7UQ8WT6Nm7z/OwNV8Fwyb1sX8Ho5mU6mQQq3MMEIIWzzRmpyOz+MYE2gnqNdUbVglMP23lEXVRgABHUDXGM3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 13:16:21 -0800
"David Matlack" <dmatlack@google.com> wrote:

> On Mon Nov 16, 2026 at 5:09 PM PST, Alex Williamson wrote:
> > On Tue, 13 Oct 2026 16:25:25 +0000
> > David Matlack <dmatlack@google.com> wrote:  
> >> +int pci_liveupdate_adopt_acs(struct pci_dev *dev)
> >> +{
> >> +	/*
> >> +	 * Check if the device was preserved over a previous Live Update (even
> >> +	 * if it has already gone through pci_liveupdate_finish()). This ensures
> >> +	 * that the device continues to use the ACS controls established by the
> >> +	 * previous kernel.
> >> +	 */
> >> +	if (!dev->liveupdate.was_incoming)
> >> +		return -EINVAL;
> >> +
> >> +	/*
> >> +	 * The previous kernel should not have preserved any devices that
> >> +	 * require device-specific quirks to enable ACS, but if such a device is
> >> +	 * detected (e.g. new device-specific ACS quirk in the current kernel),
> >> +	 * log a big warning and fall back to the normal enable ACS path.
> >> +	 */
> >> +	if (pci_need_dev_specific_enable_acs(dev)) {
> >> +		pci_warn(dev, "Device-specific quirk required to enable ACS!\n");
> >> +		WARN_ON_ONCE(true);
> >> +		return -EINVAL;
> >> +	}  
> >
> > This looks pretty unsafe and the comment is only explaining how we
> > might get here, not why we shouldn't panic.  IIUC, the IOMMU lho
> > support requires singleton groups, but I'm not sure what it does if a
> > group becomes non-singleton in the new kernel (such as via a new quirk).
> >
> > Is a warning related to what might be a parent bridge rather than the
> > endpoint device, really sufficient here?  Thanks,  
> 
> It's not necessarily safe. The new quirk could change how TLPs are being
> routed while a downstream preserved device is still sending memory
> transactions.
> 
> I think a better approach would be for a preserved device to always
> adopt the ACS controls left by the previous kernel, and keep them
> across resets through the ACS save state. So a new device-specific quirk
> for the device is ignored, apart from logging a warning. IOW, new ACS
> quirks only take effect on cold boot.
> 
> If a preserved device has an ACS capability but no save state (i.e. the
> allocation failed), then we can panic, since its adopted controls would
> be lost by the first reset..
> 
> Roughly:
> 
> 	int pci_liveupdate_adopt_acs(struct pci_dev *dev)
> 	{
> 		if (!dev->liveupdate.was_incoming)
> 			return -EINVAL;
> 
> 		if (pci_need_dev_specific_enable_acs(dev))
> 			pci_warn(dev, "Ignoring ACS quirk, adopting ACS controls from previous kernel\n");
> 
> 		if (dev->acs_cap && !pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS))
> 			panic("%s: No ACS save state for preserved device\n",
> 			      pci_name(dev));
> 
> 		return 0;
> 	}
> 
> The panic would only happen if allocating the save state fails. Ideally
> I'd like save state allocation failures to cause the whole device setup
> to fail. That's something I'm hoping to do in the future on top of the
> pci_save_state rework [1], and then we can remove this panic. Until
> then, the panic is constrained to Live Update, and the allocation
> shouldn't fail in practice.
> 
> As for IOMMU groups: Sami's IOMMU Live Update series refuses to let any
> device join a group that contains a preserved device, in both the
> outgoing and incoming kernel (__iommu_probe_device() fails with -EBUSY)
> [2][3]. So if the new kernel considers the path less isolated than the
> previous kernel did, e.g. because of a new quirk, the group grows and
> the IOMMU core refuses the second device rather than putting both in
> one group. The system comes up with that device unavailable, which can
> be debugged and recovered by rebooting, instead of panicking.
> 
> [1] https://lore.kernel.org/linux-pci/20261106004218.604799-1-dmatlack@google.com/
> [2] https://lore.kernel.org/linux-iommu/20261110040828.1774343-6-skhawaja@google.com/
> [3] https://lore.kernel.org/linux-iommu/20261110040828.1774343-13-skhawaja@google.com/
> 
> Does that sound reasonable?

Yes, reasonable.  ACS is deterministically managed via standard
controls on the source, continue that after update, disregarding any
new quirks that have been added (to the extent that they fall within
the current framework), IOMMU enforces singleton groups on both ends to
avoid violations.  I don't know how to do better than that.  Thanks,

Alex

