Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B038CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837648E0013; Mon, 20 Oct 2025 05:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F158E0002; Mon, 20 Oct 2025 05:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724978E0013; Mon, 20 Oct 2025 05:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9BD8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:56:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0D34160754
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:56:20 +0000 (UTC)
X-FDA: 84018037320.11.D75C6B1
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id F1EE21C0009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:56:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PUTzN8PL;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760954179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X82yHa6WgvMKlTJcR19kPIZKafNa3VhhrDxBxVYdfcM=;
	b=lXhvk0xkfHyvF+VOSRqZNk4wXmHY0aWVTYUGuxWK6X5dIOT8hH5sqXSDGSNwZdw6UzsPqx
	DhdORjmPHemj9uwGdc+uEyy02oZJ3z3CSPrXuQMn05gNVWcgme2G80OiebYqfrGqQ7OaVo
	EUYLUzT8xWVwqdrFlMxeIgcO1fDM+yk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PUTzN8PL;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760954179; a=rsa-sha256;
	cv=none;
	b=5RempJ0NSWR2J7aI7JpU4PwHPSGq6+3RiCetCWxuUxAEQe96Z+wSz1MJvqg/nRWzk/B/Yt
	j3WAlsxesGiVPrhvyQFEtkO5FNqHjjcJgq9jghr9Irg+de3KH8J6f/Wnws8iAqY+I9guGj
	iCRkIX5vJJK1vzWrmfhpC3mYTkuXAoM=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-57b8fc6097fso3826624e87.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760954177; x=1761558977; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X82yHa6WgvMKlTJcR19kPIZKafNa3VhhrDxBxVYdfcM=;
        b=PUTzN8PLAElcQ1PcGWCRjUXImSt6rr5FgZxJJF5fbnU/QojwIoybuWouSssoTlf+TE
         TI/DGjXUTzhFEGiGvHiUNU5ThUvEtq/asu4K58RMb9xYqZaB/az3tFEFnTAJjgatg7Aj
         Xe84O4f3sSJoPpVntjYoPg+it1tdgSPgeFTErFo1c3DocxeN60qgEi3XHNM4ipoBxRyd
         kd0RVIIUS0I0MHPOA6CYqpHZak6lPUU5zsFGfwlQOoSkkb9peJ2gZo0blRD1CKrYeYSG
         vtgGNHnU/9jeqBw7koyAfs4H18zTNLzWkSVdkCJorcu2EF5qNaFq8VeBmAHXg4qv/DKv
         CjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760954177; x=1761558977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X82yHa6WgvMKlTJcR19kPIZKafNa3VhhrDxBxVYdfcM=;
        b=Qe6W8JF76AZlCuN+aaG/eMu8UreL0MACRtY/kZJP/sHGOMhGMW19E8CEhnC/KY0Zp6
         QEWIq7fjgkwNfw1UwqHANPxhb1Q0ugU/qaG9IY5A2G5X0D+HSE7TTBlsVqqfn9X1v8Au
         pWk5cYKZsI3ypy/xZGzQluMUnPOqUoIN7nGi49+lXyt/PC9gh0rw3r1093SwNjl3lpWJ
         d+aAVsHeYgsf/tYqkjQh02gDTZNo14tnxkCta+vcy1GX8etIXRU2n8xjuKiBq2gmC684
         fxMpByiv7xD6aOl4WZ2hP51kAWtR20w+a761fPEQWkpG8ByiVW4oaxvt3yjNvutRMhNP
         suEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKkET80CWtyDvIBwRW0JPbYSfcud1rlCebuMWe6KaC3ZFz+yPFiUU8JUL9klWLzOHEbPYn7mGokA==@kvack.org
X-Gm-Message-State: AOJu0YxEV0eaHjznBzxnpHDufZUq9NemCOth8xJ0lMVMo6o4s/H/hu/M
	OkqXrxu6cV4THhGgyITz7HFgR6diH7HIOLLg0HobX4zWsVdGwDXG4LHD
X-Gm-Gg: ASbGnct4+2VVFDTB1tPHH4Hqqyz5qPNm8iQPe+ePQ/wrtlSaINXe3ljsgHDpSDIxfBG
	2p9ChZlE5/jwJw+i4RY+yMS9qY0JcaJZ229BGHyd9gCsoDOkD0cBW1Fl1i4VanWNgYgt4hwm/VP
	8JgqT8VfnPo4QjYyLE+sR4RKR2XQnz5vVEjKmmI5JSwXk2OGOwwyjNucWmbSg4gmguDsI7cJRzk
	qYCcloyy1/kdXs/fE0sCjEevYSyAmBVtrws6hhqjsoLW/7NBnVtSg4NUvO/A9URH2/JrTCbe3Uc
	ooiMwkvAQg2bU5LoObS7YeBzdgTJS1zesUhHPmH6WPSefabKB0a6QJ8zfzSuaADha1vsvAaThHI
	gX1yqVIBjZvaJP0BPPav5C5IPVk/9TF/DyLW3FZMja7FOMcAcoLKN/g==
X-Google-Smtp-Source: AGHT+IHuU+9CvQ9Gt1nfQHn51C/T6e1754T+yjliALLtrmrWjcnHKqMnxprnyBu97fHYVVzHprz3fA==
X-Received: by 2002:a05:6512:31c2:b0:57a:33ff:c7fc with SMTP id 2adb3069b0e04-591d859ea86mr3876727e87.48.1760954177014;
        Mon, 20 Oct 2025 02:56:17 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-591def168f2sm2346847e87.54.2025.10.20.02.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 02:56:16 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 20 Oct 2025 11:56:14 +0200
To: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	linux-kernel-mentees@lists.linuxfoundation.org, khalid@kernel.org
Subject: Re: [PATCH] mm/vmalloc: Use kmalloc_array() instead of kmalloc()
Message-ID: <aPYHPmebIcGxeywe@milan>
References: <20251018201207.27441-1-mehdi.benhadjkhelifa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018201207.27441-1-mehdi.benhadjkhelifa@gmail.com>
X-Rspamd-Queue-Id: F1EE21C0009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: s4city1b4oqkjj34ef3jx3fhch4s1jq1
X-HE-Tag: 1760954178-76457
X-HE-Meta: U2FsdGVkX1+X5sxVZogmj3PYddpBjEEXh5/QFoRB6/B53jVYivr1eemuHmnVx/DoiwVoKoeO9u+45M6LuoX2UVXb0lsAU//oPvFA/jDyHMvpfl1AQpsZo5fj09y+mL2+FAlfA19mh7Ce5PFbC8PlPZKuVm/+ybq75e6adbvd4c34IL2HwRQmNLzsCvbzMwTOt6u4ON+7Y9P+ms3pfp/u5iymXdUtn8f3hydC8F+NrLIK3ylj8VTplLy0BXSFc9HoWvFfmepvXrbud3fD0APlEClULQAasJN53MvOjE8yxw/nisJnnvuyY8acYI1GTxD07PiRKUmZNH5GiBm/udLxyFPZmRnkDjeVJWFrklcOYs4jv/EO3sDfCaZBp3CcFDaiQmQRE+ZhKIC/3+7dJaVG5EAaTyWkV4glTPBDwPVJchdDvtp6RH4PjA6lMqerw1xQ3j4YdD1RCidfBa61LPkbachmxkspFF5EuNp8K0MPxLTZA2ezZjT+12dYeyWEksAo6t65Lp2DZrlG8jH/5m0J+AU5zu4HgysvPAKG1RN/RHXu4ZwHsI7DtdiJT0m47DkzKXaKagp5FOL7GmmRhRpl3dkhKB2jgcIuyrO2+lxa8nmZJqXlfVkHub+FRr60zXdrjG9cZacPM4Y/vSyRGCXMhOcZiodPjiF9ovILmyHg/H3aRMUrY/IhQ8PiAabVPbCqggovyyXCAkyxz7ZIEMBItsz+eno6xsp22xKSd19XrPtoL6SAim0HcWvdv63uuteOoyiQIWykF6ofsAPmfHU4gELaIAUr7Iow4S2RpVNoZn+pvHyeKA+GvedNRNW/XrU+L6R1ltEcyA/TXrYBAsxyZ75eSeCwugRVFR09lHl86DnWAkhsvOL9Z1AmnKHmxZAFhclGE1joQ4LPrjtpyviC8ctjvNNN+ECY+LPvY1Ses+3cFMGeQXmEJwNJDKxZsj1vsod0zKTmYZCVLns7l3A
 OGjRhJPZ
 u5PqG5L8fDY3lFxmVGPgYeb6g7jcTgUl74LlcFWsBHL8uzRm6KrqyfJ1H5PxFmw7kiWKxav3eGA6NtP8D4Fw1VZsk2JyJOPvMVlyvFU+8nrebA294CegJVrAzzmyl7sdHGWnRE6X7pDSK1xCl4QBv9QzM5mMJlK37xbH41QP3VwqwKNbIrz2DQ4dKM7vCSL6eALcq5gKSeDGJ/J0HuxxBU5bzh5E1U0vMNNA46TudjC0FAzerb7UjOdu6B3MWCP3Yy0QUNd+lRMyPgXjjbXG1IvGsblgNKonF5ha2ZiDXrQQo2nnoGIgvm5t1XElKwU58DvMJMdp9tlfO5iFtYgSM8Ybd88pUCLT4Oh926MhEoI8BxyS/7M0get9x91F0jiemFGm7GfSLgT7+CUzbQfPReUZoV0MSQQ1flO4zkVNyR9LgD5Zul20RPJP5R9+f1qAJejZriztZt9i6pxJPI7Wu36UOKhblURi9Eq7Hoct7mD+fLC0HNieGQqIBOgg1/b7TlD+jrGRlFhHYXKJCnGsQBAen6ARlsPIdeuXF2FvwHURcuufbUOvK8fXX4C2AAKsqQobVe9njRbVPzM9k/cS9T+c7aHEmiGda2mQXVjsbxtepD+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 09:11:48PM +0100, Mehdi Ben Hadj Khelifa wrote:
> The number of NUMA nodes (nr_node_ids) is bounded, so overflow is not a
> practical concern here. However, using kmalloc_array() better reflects the
> intent to allocate an array of unsigned ints, and improves consistency with
> other NUMA-related allocations.
> 
> No functional change intended.
> 
> Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 798b2ed21e46..697bc171b013 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5055,7 +5055,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
>  	unsigned int *counters;
>  
>  	if (IS_ENABLED(CONFIG_NUMA))
> -		counters = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
> +		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
>  
>  	for_each_vmap_node(vn) {
>  		spin_lock(&vn->busy.lock);
> -- 
> 2.51.1.dirty
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Thank you!

--
Uladzislau Rezki

