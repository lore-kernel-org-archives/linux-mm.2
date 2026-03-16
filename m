Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DECECF53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533296B02F6; Mon, 16 Mar 2026 12:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500126B02F8; Mon, 16 Mar 2026 12:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409CE6B02F9; Mon, 16 Mar 2026 12:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1836B02F6
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:05:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CDEE31C328
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:05:02 +0000 (UTC)
X-FDA: 84552400044.04.9AE7681
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8320A0018
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:05:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rOMwBq7V;
	spf=pass (imf25.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773677101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9RU4Mq6bXwi7763tJq20duY+x4lhVoegGX5yfdZIpA=;
	b=Bg4x5F3pjA+iibPpR78QNty6uwAgVVK++MrQ4DnTcYO/i5+6SkkkFZh96RTpGiP70AQIVk
	OFCAEKHM5RHNCtQ+Y4nezyGtKoENZkrTxRBqy0R9MnTWgKr7oOSuic/OZ39mqDkgNVKW/J
	qveXwnyxG282GeJs8Qf/i8esxoBs8Ss=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rOMwBq7V;
	spf=pass (imf25.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773677101; a=rsa-sha256;
	cv=none;
	b=e156nsjcpEtPnChwTZ0C+n1m+QZc++9+FOsn+XtbXAkAHlk4c+H4HNIJ+mmOMSZMazCe7J
	gKqe1NluR+1dzphgRbXj4NpL1LxIJ03W7Ti4xrAqpzBujuxGlo/V6zte+bNq9TTsivSVdw
	Sg3Y6V2fvE8UiFqj9x9dCIi4mIWesKs=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b052ec7176so93995ad.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773677100; x=1774281900; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x9RU4Mq6bXwi7763tJq20duY+x4lhVoegGX5yfdZIpA=;
        b=rOMwBq7VcMPG90mS1wd40rDAUCUysd9wGlJiq7lrIGgbLBFqyKhyD3rxRTjeACOH/V
         vnrQj37iAEjAHFCbsZD3XSd9iO6cBwRWzM0Km2uJekSbOCyJg/tcyhN3BKYuwo2GRpZD
         k/ZUtvelZUZqAKPBoZCvumcbMdev6Qp2xZCI4IoXeuLYGfM+tZfsE8lCrUd3mqWHihwY
         9ocDtuJtd4x7hFpdqEvhcQPAFeYSUcSJpZu5apKVpjtSvZl9qHANmNT9EgMjwB89Pa8A
         h8mvxt5t18g6cvI/kHBZSI3VXHIw/+9LWZxpSmPWPX0AjbBgclt/GPchcCSRMmsTJL3C
         FwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773677100; x=1774281900;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x9RU4Mq6bXwi7763tJq20duY+x4lhVoegGX5yfdZIpA=;
        b=hIo6fujBGP/ji5H2nQ2fHbuoPsBs21QzQ15Yp8r0AHi6Llt6x8E1Pw6D4G+IzIwZg3
         Dn+Qe3vwfQdse3gg5YBDuSVqV+XtCAr5ji/h2g2FVPe+eJ4OLQHm50CdQhQTM6AhQhVh
         rCj9A2MlXYf/IWWPj1hGigtWu3PuTWXgb0xxQoZlZ9/kfYBVodWnqX2xFOoglbYBuRnq
         AReEQGZxlyO6dA+l7Pizc5kPsomrFDzzzkpMm2zkQQWAdfLKmI0y3nrcpph8gGo8q0b1
         CMTdFVQQY/sr6lOEfNj9hmyprNKS3m1shC9e8fPKIJ8Z9Pa7ErVWczPTGji+pJlWaOxT
         rXnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJZHC0w1CxK79wj+dkeUzPYtr2AbNvBV77ny3jCY5OXwpnHGKphsTfBVHaYUBuQi+wMf4LWpK9Ng==@kvack.org
X-Gm-Message-State: AOJu0Yxb8MWVTBpJms37zaBcHlZKn4HxJafkSjF2eK0JG7LF+jONdXbh
	KenauCOArLGBY9v65jYHTj54SG2Aosodv3i+jomT4t9KrAA9H/I44jyCgO7aq4BY2A==
X-Gm-Gg: ATEYQzx9AMnnYIgJs/oAAJ5xOonDHcSoev4ikzeM+bYyOslCLcZXI6HGtrdDa7mw3TL
	TN7vDb5PxtzNQ87OqGArW68oMJMgeqeJGrr3Jl6v7W6VKNC3lJMUe5Mou02G9kxqSQk3sndR0Wr
	DeoKLUHMY5mkxJZRgvxhDSrd+43SfkcMgs6TowSLVhY70+lnOzi7vAC7WpfvYXpmQBbf0gbzYFQ
	8ZUzeCyuwbR4RfzxVRZjxN0f4T+mNVfhtuS2tA0qorLj39a2kpsBGGw4uetoTnbkED4LhBOVu6N
	j5peNVhmsFjzDrIJfFiVimKf2tZ+YV8Otx/MqCGC8vJm5aa1AvQ4jtxxUxxlA88yDlmGavmer7a
	C1QOT7M5ycwhdqkqKXQYPOPUl9YIDnzegynKwtEIPq0CjkxASRPhfNChpX8rrTfxhQI58SZc0nf
	LTW5OBu//iJpugEbXvkDDO9egt4ygijZhbKTAKudu4v7DILY7i5CIsBat2R2AY
X-Received: by 2002:a17:902:ce0f:b0:2ae:575f:3755 with SMTP id d9443c01a7336-2b04215e0c7mr4424785ad.20.1773677099288;
        Mon, 16 Mar 2026 09:04:59 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b048527a19sm71890555ad.7.2026.03.16.09.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 09:04:58 -0700 (PDT)
Date: Mon, 16 Mar 2026 09:04:54 -0700
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 16/22] vfio: selftests: Add
 vfio_pci_liveupdate_uapi_test
Message-ID: <20260314073250.GE4177610.vipinsh@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-17-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-17-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E8320A0018
X-Rspamd-Server: rspam08
X-Stat-Signature: 1afz5benw9179x9pwaoagsi3brchjgfe
X-HE-Tag: 1773677100-504770
X-HE-Meta: U2FsdGVkX18pZJhZG94uTe52HMvZBKegEMdp8wDURZ/PdS7jTfAfZ+t3rEam0ymjqXbhQCss2IzIMyIsdb5toqTNZYnUUmVZeZJhyYewxuxW9gegcCrw2J973+J8Bz8PED7maTFKqlK8IkDFA49b7/68pqM1lOzlP1KPQhnZv17CGRc2yjFNVLly/gErQspiEH0Z1GjbByMjxumbkA93orOUiT26YpqwlPTdaUEGMDfS752bFpfuhG3D+c5CW3oQmeMlnAsOMQhKQZ4DMi4vsdLFL8Xyk4C5tJxDRIOLEiuiJFAUUTNdBBYi8aFK6ZUB5psLeTiWBAXldA5ruEAReRF/PHyn0hCrtqG84PC8SizyxsqRFjKw/zXUtOtSdSxHiHJK79D3Np584V6sIMRUAmmNVdmdNzxz9kwYrjJHmr9Q+vIUxeNQufVj+sXZ0L5FWDk7e4S5xw5qxUmgNjs9HHlOvs68vGCVBZhlypmXOj/M9Y5MlluvzBQfLlcRqRizXv7ZcFX2YW3dEZqkJSw1P3SmmE1v3yHYPw8OF41wp7++tvwmoPUyIMNmO9lWRyFpgkKjiiMRHO1Wbvd9GxIEFguBsiGccyinEB7Hu+Cp/R48wpSH11tCzcNP7hKcxobMcXaNdEZCcU87SrScA3XT3zCINPEPRCFrMa5rX9oAMP8f0FYrKu4cqV1LjbKmJLL6DywMEG/OB9LBdVoqP7oW5PrjulJ7dDiMhuW5x77m4QQ/1ortgc5i4bb7XudPHdLvPI37AVOM6wX09Cbzn6esEUru9YfYjDOF+RSLv2PDhlprh/FLMKgHUantXAExj//q2/NTqxWUnBEY94u5hE6FiY7SgWadKchUTE5hn+QsxZj5l6lnlIqhJXlpV1Oof11SrVNv7OUKN/oA4KPOnfiyCG3ULCtXlNWcV0RXdqk/e8J8ZDlPRUKLSkSZ75hOOtM/1h8T5PTHZKg+igidVzo
 iR7WZH38
 j+LsgxG/MGEhsNNSyQeRGzjAipvXFckFUqmyb23k7FXwJSipEe8AYZlLun0/ByAvgyZ5Vr6B92CtyKnBwHpg/sxik+yERmk/40ILmu1cFQbbtS0w13jGX8nTKlZToj71f2PqKpePHOQEC/u0tpSWtGatHtCtYXpH75IFdNEei6z/C9qIpNt0GYfE8a9FzPNvT4mNTcz731OoCRBtyY31N2iNh+qKiJvjjOkqvsLmtAoAZoXcyWdzis6Htpe5XKunLWyAbtYcHSIqp7aUanbLxdUdGzaEyu/3zWhDOxqvU5Xhfxl6de3Jn7wnRcehJEy8AFhnPVAcRsBWlrOBf90fF7pFG3uFkyTOlE49MdqiPR1DkVesUh8L8AiGulgm/kXGm7KAOE702TgmNo8Xaj2M106hbKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:25:03PM +0000, David Matlack wrote:
> +
> +TEST_F(vfio_pci_liveupdate_uapi_test, preserve_device)
> +{
> +	int ret;
> +
> +	ret = luo_session_preserve_fd(self->session_fd, self->device->fd, 0);
> +
> +	/* Preservation should only be supported for VFIO cdev files. */
> +	ASSERT_EQ(ret, self->iommu->iommufd ? 0 : -ENOENT);
> +}
> +
> +TEST_F(vfio_pci_liveupdate_uapi_test, preserve_group_fails)
> +{
> +	int ret;
> +
> +	if (self->iommu->iommufd)
> +		return;

for iommufd variant, should we mark test as skipped instead of showing
it as passed?

> +int main(int argc, char *argv[])
> +{
> +	int fd;
> +
> +	fd = luo_open_device();
> +	if (fd < 0) {
> +		printf("open(%s) failed: %s, skipping\n", LUO_DEVICE, strerror(errno));
> +		return KSFT_SKIP;

Both can be combined using ksft_exit_skip()


