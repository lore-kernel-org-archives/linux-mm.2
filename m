Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9B7F3C982
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1060F6B0088; Tue, 24 Feb 2026 09:34:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4686B008A; Tue, 24 Feb 2026 09:34:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02546B008C; Tue, 24 Feb 2026 09:34:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD4BD6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:34:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 853C6C08C6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:34:25 +0000 (UTC)
X-FDA: 84479595690.17.D2F8369
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88AC3A0009
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:34:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dNpevRwT;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771943663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6XsRQ1YbstO4vIvVioaL3gYgTplaCGPe+QatP3oUz0=;
	b=WcLr8DRDHmVTefAL5ZOtAje4RIKDKCvg5MSTlSeMk3BpLh1Xt/weri19oDDORKeTFRb7cY
	dd1ymFB9MTL9+RGOFfNaPgEuGlHh4e95HoW+ek7W87rQvXw+mk8mQFgpdp8a+KNljrk3wd
	NwaBup2aKvgDtJTg2MnIZ4Bm1UO0Pec=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dNpevRwT;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771943663; a=rsa-sha256;
	cv=none;
	b=36NrA+g3eyxSWc/wnzKoDNVJR/AzqpdFEG6iPtS8XnEI1C819Z3LrCuT/+2qi7Djne7PaQ
	P1PattgK6rMgrXDRCW7HBDXyJQ/JKjlg+Q6NV4dYNnZgJPwqEIeEPk2AQ+nf1AdDMEzYg1
	9VJXd0yJXNKcnfMpwe9Kqqx+qCGwFxw=
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-4806ce0f97bso45248275e9.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771943662; x=1772548462; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z6XsRQ1YbstO4vIvVioaL3gYgTplaCGPe+QatP3oUz0=;
        b=dNpevRwTkI220BFxcF0VRdHcakCcvVkf7VBl7zR6lJdIp6fHEekgGw7vsEBQY/X6m9
         VdoUIrxuPqFfbgGELz+wobGZRKUXNSuuEPouDBS3KDOKSoID5LwvaUXk0jNVZYKZDxvf
         BW5/Bp8LTRmclrooezpzJj2NLd2EPWY8IKHmTsE1pgltmcnTuC1/XDzA5TcDgoAK9mpU
         321zRi55vpHXUuKOxaNaijQ7SSisERpUiRONPz4Ee2gHWJbcwJAusxmtkfJxWsyC1G5z
         m/cbkWGlnGcpArvQP1Qca6twEVvZVd1z6s7fBz3ckZgsDui/tNSpw8sXPJTCTZHUDtRz
         xBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771943662; x=1772548462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z6XsRQ1YbstO4vIvVioaL3gYgTplaCGPe+QatP3oUz0=;
        b=ZzPNkm4bx1fBzGFoYCxVLvKSw0PT9P8DaxxjblqBTcy3PUJahwc+99UMPp5jWtv6vN
         CKlcTjiSk63VYW6NyEkdfvSX3GB7e8YsvmbiyEbKy7Z6Wr7F++vK5O0O51NOtpKm6S7e
         EniPTwzNU3A6Y1rigVj2tTb5l3zEp8HzZX+LByWCokU/UEQU88I77DNwn+bMgfJGfgyd
         HfqLz/GpjI4mrcQRePaxsRKkZa4mX09Bp4b9DsBmgVw4Dr46NXUfaEnlz2vSPyZsRwDK
         Cl0GdWUOsodeTDZc7FNxdgELt2Kr7ahMLUtGNUa2e1qa3YxJf2AjsVWi1uFJ2WEYJtnb
         X7IA==
X-Forwarded-Encrypted: i=1; AJvYcCVVp6FlCrt1OgnbnevC4lGcJF6uQAOTvfGuCtTSKn3TYBV3iISuNqtJ6025ngRMaA7U27rbDxV7nA==@kvack.org
X-Gm-Message-State: AOJu0YwPpTuRx9ddQQ3MCAAIe+sq/0b+OSVWY35xWdnuH/h1epotxRj+
	XvID2sDlx2wTUZVtq7OZcwKdLVfEyUCOBreYbUpVZruVM93UHROb6eHzb7/4XCMA4ss=
X-Gm-Gg: AZuq6aIHpIOD/0XbMrRGbPf2wqpVVRBvgK3Ky1w+ur0VK7OF9jx/xOfVkyVYu1+hEZV
	tW6iQ0HVerG4YoOVzvRHJl5aLvhfEVI67fKdZFY703fEXRm79pjHqzz387LLSc4adGgh/YbWKnl
	Y6+QcKyNpu9LjZqQt89R1a2oDC6VpDlTKhTd4nh6hwvcGbxPFfaJogOD/5AnAcSUUwKfBZx5PC4
	wmhqxJHrh0sG2fVrnYk3Aff/y4/P+sowu34btoh94s/CIefVlwyUdrjfVsqZjsKd+nw4PtGE3NE
	CZugRdfuX6Z1JXhZM2YvZcXLwsOPqhC4dopqvNK7ilESsg4Mp41X28kkClt6ekAijx65N6bQG9V
	NDrq+lBu37rE4JQap3m2BCAGB9Q7LrY6lCpSqZbksx4LuO21OpLK4UTL9in/Jp/VxCDDogotFXx
	MiDMkoqS16EVt0fnvBobCO1j0YLq3L/90=
X-Received: by 2002:a05:600c:190f:b0:477:9a28:b0a4 with SMTP id 5b1f17b1804b1-483a95574c5mr206158565e9.0.1771943661764;
        Tue, 24 Feb 2026 06:34:21 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd6854c7sm10875895e9.0.2026.02.24.06.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 06:34:20 -0800 (PST)
Date: Tue, 24 Feb 2026 15:34:19 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ2261F3V2KFfO86@tiehlicka>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ2voRA5VJytcfLp@infradead.org>
 <aZ2zPzyoFUUNWdJ7@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2zPzyoFUUNWdJ7@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 88AC3A0009
X-Rspamd-Server: rspam02
X-Stat-Signature: pwxigbqebbmxyccmpnnbimhk96bkgjgw
X-HE-Tag: 1771943663-376088
X-HE-Meta: U2FsdGVkX1+OvOC0iypudzORuvuIu5tEK0kDsYR1k/EIQ/MO53yZptkGw5eL5ZIZGBEjePWhGVsTo2knrKqpyOn3GmjYw1V/U08iMb6n9joBkWf/vuwlsnUTUaOclBdo3H2OwZdd8+1jN3m5LQKX77LdH25DlmXsF+VHxG05+0BKx5nW8+yI7LdfdrFux22xUzT2S9Dc4Z6afzATib05906OxO9uzKV2j/rZPXxUwX+xAHkrmBoWncBQJhmp/9GLH++8s1D6dEHAPnU0i8pQ4qAETIHS48bHY4YR9VIphzuUxdkaCCXEQcz2Hxt0ZsML36YNXZLgap/Szc/uzHR8PNpcYZjgAd1DW+ghEbrdEpyijNqzOkf6nx5KYlp1niaiCdUhemuQnoudO/ueAlFLFNRL+Q5ZX3JuBm7J8XvXrICFaEDqjg+Jtloewvy3qeNeHD3MxowCoaWrED2UH3cNlNehP9F3MgiXb5jt8cx5bqJdLDCydr6hMh4iUJB2sMst6WdKXqS1cahEmnog/6sYqzaYBO3WJdx6P7wNH05ncD+y8mwJyzJbqpUgr80/yrrnQjbH9WN8I1gaww++curjGawnDQpaMCohghBLH+AkTQpb1YfIlPm3f4y8/Hk0l9tsFM1g1WHuv0Z7ym5eeBVZZBEl2sNnS0NH8LTQKtme/9uRI5lwnoa1JFqXUOwaPGwGNs1d7DDmDVgOMfzt/wE1dHbk5912wdU16NI3WplSC+v0EEwr3n2twLEev13gySKunj5iAO7exiKodRNnAGrOSqbMFiPJP8VyYYIO31OTYqjdN2F5STsdccts/bjhLtL5TI/4vx9yFEgxFkvM4HaJSHABx7e4QYVgqe77m/MiMXByfugwetpvWp6Ntr/pVdipdpt6Wt9M6eBeQ3l6Al0CEy5/bC2IXgrmgnCNrcSoeGTklt00bMfU/Vwm1P58paZ208somnsWhSpVQ4m4dqd
 QEvZLb8M
 CizVLEaYAU3V1+hugF8Qu7pisazJyS1cKXOWfCepeMjPZemr2jEla3CW7kdHHIVWHBMgS+Y7n42smp9VSDKscQdiqxIAoh67q6MGjID+TWkeRomPnSJnnenUH420N6FLK4LWk739YzQ/HW5fXph2ViX732wRYL0kmn55pw5kw7PJ3v2hiy2yccqKA/zIgbQfVB0W8USnQs4QlicXvAC0VQtXLuUJ0iiTato3AVyQxIXo4e2gP2fvxwn2XyfYm14qz7YX5oLn1Ui+zbZR1A4XGswH7TWDRNAxn4ky0LpaPetSFrZ0YHHKPiwo7FvHuiI4gwIfDDl4pvZFaB9kqxggdJPEBgVX3QL6wfDRVGRu0Yqqz1p0JzrKPbl8xfTBsH+KgQi8UVAiX+AcuN06+pCwaWWoZ95Dz59G4Hv+Bu9K1hFQX5sRnvr/pRmwNNbBCj94diojPnt97jFvKe3UaMIFocdKvJmIeoG6v9s2pHCb/tlyY9dT7wtYl/DhSHjibfvbpNyQFrBuLUopdp5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 24-02-26 06:22:15, Shakeel Butt wrote:
> On Tue, Feb 24, 2026 at 06:03:13AM -0800, Christoph Hellwig wrote:
> > On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> > > One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> > > __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> > > allocations as those could be achieved by scoped allocation context.
> > > This could cause pre-mature failure after the whole bunch of memory has
> > > already been allocated for the backing pages but considering that page
> > > table allocations should be more and more rare over system runtime it
> > > might be just a reasonable workaround. WDYT?
> > 
> > Why bother?  __GFP_RETRY_MAYFAIL has pretty lose semantics.  Trying
> > too hard to allocate PTEs is not breaking the overall concept.
> > 
> 
> One thing __GFP_RETRY_MAYFAIL is very clear about is to not trigger the
> oom-killer which is not the case for GFP_KERNEL. There are users who explicitly
> use __GFP_RETRY_MAYFAIL to avoid oom-killer.
> 
> Mikulas, is that the reason you are using __GFP_RETRY_MAYFAIL in your use-case?

yes https://lore.kernel.org/all/32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com/T/#u
-- 
Michal Hocko
SUSE Labs

