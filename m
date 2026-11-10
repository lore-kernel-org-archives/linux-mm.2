Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C1C660A3817
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cu1z7Gwa
Received: by kanga.kvack.org (Postfix)
	id 304E36B05B3; Tue, 10 Nov 2026 10:08:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE1D6B05C3; Tue, 10 Nov 2026 10:08:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C4BA6B05D6; Tue, 10 Nov 2026 10:08:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED5E06B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:08:01 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0D61A0965
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:08:00 +0000 (UTC)
X-FDA: 85419539520.04.1AC0A10
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id D717940017
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:07:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cu1z7Gwa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of kaylovefoss@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaylovefoss@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323279;
	b=DQz0qsAAggWf53u2VYs2I8KBq39btay9v/bQZdxifmizhxhwsaxyp+zBPDsI9J1xC7dTMJ
	UXoYmSblV9B40kh/RUdt2R/JK9wdsNfWi5gow5Qprui18AxuxUt/Ggw2c1cgNKQf5TB2Jw
	wJHcU7OURPGJCGCZlirOoUmvJxuHRfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
	b=hMiTdRTQS82NEyYpNzu+OqcC58jH/AK7Bihl+rzd3c9ubp6rSEhBCmuZRm/XLBuuDmaLBf
	plQOS5FajnjaF1mR9EW/1KpedwLg6i0zyJrfgi2Z1p6+xFNPTT1xB/0L4rhm/kg4Eb0JqT
	WgolC0/ZexppMfNAtUp1l5QW59DtEIY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cu1z7Gwa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of kaylovefoss@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaylovefoss@gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e977109392so12284615ad.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323277; x=1794928077; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=cu1z7Gwa2PE62hwL8qemIDNV1bPJVhMIFCrBXBhm4pfrHszxSLEGvQws5sfb/HPlK1
         R/bVMwZReDF5fmEyIgBlOkPxQMC/ZmMy16IZQ/sTbmWZ8frAcgaUt4ku64j1m+FI8D+a
         nETfMicb1uB7iINFzjUOL7q3WKATYNC2dql2vzuepMaiKjl5bxKzAioEUiVJ+ZYzzGNu
         MKvrChzTKJUgswAcpaZEskHovc1xC0TnF/jI/axRhRqS8bvsQW0pvMnWM5GKhZaph5+K
         9LKD1CwjLWYW6OB+uDgx22D3weqqLFw1FC5yKma1g4D2Vc+GUDYl/hA1Kywyz1VcuxJx
         P/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323277; x=1794928077;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=C8zcKNDqDEQzBclBn4kwIjfRZmMo7QkMkn9KFEppy6uXiyi/uwLxicxEP0CYXx5bQK
         AyVJsMdUq4cMOLBYWxuyX4eEtTz44WjLLBKXIGIkiFnppefml/0x5oCSGxBLT35wV+XW
         RRKlujdBVxTGbtF4XLFyYBtAwzOmegzhV38SY9wqqappUDINKpmKNN/secUXzGkmM8Hz
         dwPn9If/bwK7YzJnch8VKcSaTdgVbjuqfsxD/p8CnKVshuYwPXVuEX76l/6FQlQp6N2J
         ojSmlYS9pFi8FoqZkC3CzX3UTAZXM/USL/nGdXsbOPNzpe4XfrDt5whewCXuvD5HWbmK
         qq3g==
X-Forwarded-Encrypted: i=1; AL+hErH+R2yQbZywli3yKZ11/QmxZTm2PTYNt9PX6/0BH87MMN+pSGTkFq8FzRml0Jpux9BoWGxDX7zEpQ==@kvack.org
X-Gm-Message-State: APuU4Z9H1xiMRLumOVdCNhoDrtohvaNBL4BDGdKdT7SJHJW2a5+cHhR8
	cIf8BTKPaCNfiMz6+AbYtQjsgd1+zoN6DMXh6zbnN6VdrsPOcLCHyWcm
X-Gm-Gg: AYBFou01Fv71b7jYrtPgp/FyhZrxEqKFfaOdWxmk9n6uHfRbDGXFZAOGPqW4MF6a/8Z
	BwSyBvz8jJxv8BZkZl2F2NghoS8a9vxdjubCEkSlfHNdtkMflRvxLmNyFogYry4OsC1oTNDdrxU
	Y80gGTweVw/ZBq6EaGtr89tbhneGw8KkAmYD45tpHANIKrCOnamCS8k4aQHxYOYzyAZ3B/E3axP
	Lbr/0mmCZax8ZggrqrMX3DN7T9MN8aWDILCej2e7SgAGTHERoSYhPyNUFtDYYxDc+ojWI6/4i24
	GCbnrxOlyjM92YBU5B0WBMIdSYYqlR913xF9KDAEa8HT8ObX+oXBijvxe1MGKkg2ru/pGnHS35w
	uFiPDj6W2ozexybKbQ3XL9FYUkIaYCI1j54CWc/XzT9b3G7MYolN+wZBSwmpPRD29yUAHQfnkqc
	yZRqnrhzSSOEkXqOKcFd2AJBw+QFQzPTIJltBG0qVwn0Ji5qWPxQyIb1+OgM/iTJ2Gr/NnDr63a
	ch0Tu2V4cPPWD3zyPWyYjai0B7g/lvwd/eL/DFfUJ/yag/sW3SLVGn7QFOtAwkYH/CoelK7Igmm
	UxF4kl0gIjSve+4wYeoG7EyvsiVZhSEeUB01bwkDr1Bqd/n/rRX2lmNH5Bn9CSVIqRrVuXXD0F0
	ZLi8nbC+w30I=
X-Received: by 2002:a17:902:d481:b0:2ed:1ef3:9ec with SMTP id d9443c01a7336-2edb9172a2dmr26826345ad.14.1794323276968;
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Received: from [192.168.2.6] ([27.75.101.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d78dbcsm10397575ad.27.2026.11.10.07.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Message-ID: <71f76e5e-ce24-4a71-863a-169ad262c510@gmail.com>
Date: Tue, 10 Nov 2026 22:07:46 +0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 36/41] nvmet: refuse files on pseudo filesystems as
 namespace backing files
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org,
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Language: en-US
From: Bui Nguyen Nhu Quynh <kaylovefoss@gmail.com>
In-Reply-To: <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D717940017
X-Rspamd-Server: rspam12
X-Stat-Signature: 39htq8hdbom89xci5q9hcrbedwb9m69j
X-Rspam-User:
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794323278-674464
X-HE-Meta: U2FsdGVkX18idMvgNproyPiJKUJ0D7jnt7XcFBT3KTL1vlghy+NEF+w37ffyhmKxZOsOkgY9EvDSDxA+NSTLahhyHqjZHW07csp+gTINWuZQWa1BsYUomMToSRILQiBRd1XK2NwTtmLp/77RK552MO9t7K1QhaYpVhjMPqH5leOIHgmjVqiwy6LdVxrZgXT0pDUYOCAeR51g5qngLSb7ltnO+pxd3RfzGTmfo14irwRW4+NehCWuor6ZCfvaPTeO2zbytz8LXimRipQToq6xESZaUeKtZDR5d7j9veosBVutGaCbZoTBj/DJKBZY49JLHedKCmlrGJJ43exLOpFlBCE4s3L/zitu1aCr9NBuLGN4MJTW/MFz03FA7O68CgdplRfXUXyb+KWys/vMI+eV7YXbpOQ8NfPgvz80CuGFQ26OWTjYf1MfJ6cDPVzkm871IOYRrWJUzkQJR2YbPKZh01RpcS6V/MXw/1STp1DPGAps3g//QETMs8j/6nK9lx+d1dafx80TKXnBUE0IsyhkQhrU7kcyK6Uh64UEM7IVHO7rQBCgZuYHDiN6YeaAUI4pHp5hlAevKxzWQlvrrIvnqbbHATczW+QrXmh6ooqljkkyD2sKnVFbqx9TrQHKn4+DXmjzqiawiv519MLq6LQE7dlv6rN69Es02BVHgMfgxNe/BcbJ8ZL3KCwwSYn0IQKZ5NciYnwEn+c5S9Lq48faOEQcEmTK4f9IjA3br6cgYJ0ySc6GIMkIVG20jlY4d6KcRddg5CgEPu1AzRFY2mFMRoc5c/p05mk42fkAdzncmt/0thr/i0LXzSukC0UIetfQH8Uu1mf/fVf2xbrbBauUnFXJTfuZjffePAtapGkjY92o7Zi49dYH2qefV00zF8K5ruJwdcNhDWzHmkDW1vzhIaxS9t+ioD8aebau5xdrUDbr6VxHYEL2RSbQXDvNKp8dlRp6IfEkKDfnzteuvNX
 mUKXfQCU
 3XfRTf1pEoxOMVQnzF7XDlFP9U6Y5C6AlqsBdulPsXJXsUdMYeS4HXLG+wB9046hsu0wg6KSlOmknl+x5OJUcyFnU4JDgOfcM5jn/nIxb4yWpBzlIhoLJhPFMJihiWKDNdKfV1fUw8EnUiUOuw/eEs6/z+OxRML+P12Y8Jah62NWZwgyDsJF8r5SoHxFDWUnhzjXNlp8xLMCBUhUE8dyhEp6tIIeAimLiJMp8g/ScMixe3hiblSxMnAhUwe8n8zNSUCB2lL84jiiEkeNDaH8TQIAovbKmu+uSgswSZi9zCncS+0km6WEfwtwqAzZ78wv3MqflTYJwX7an5Bcs//bHUZWtbg/EwIZHGgVqS6nO6RFYxmnZ9NwtVcQTPyeWV5MyBh5dmu/n7ertpFnXnytqImunAQ/obqPnmogn/ol77vDjsFk3InQMKWUYekkNQgbiUPUdi3+5L3d5hbehmAUwfBmD6LQL/R6HSb1QsVm6S8jlJoUJwVC7dreVNGonjhRB9UcgLysfjbOSBbbSJSPzN4cejyFY5FJjhANNE+in8NmSHYAbckOYACWuAx5qV3DKMAk37H58PJhGs1Yj2WK5VoaSHMssQOm/VnlwRQMl4cSZ8Jw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/2026 4:14 PM, Christian Brauner wrote:
> The file backend takes any path that isn't a block device. With
> buffered_io=1 that includes files on procfs or sysfs which then get read
> and written by a kernel worker on behalf of the host. Refuse files on
> pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  drivers/nvme/target/io-cmd-file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> index dfa8aa46188c..71c69bac5394 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -52,6 +52,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
>  		goto err;
>  	}
>  
> +	if (file_is_pseudo(ns->file)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
>  	nvmet_file_ns_revalidate(ns);
>  
>  	/*
> 

I noticed patch 41/41 doesn't include a test for nvmet. Would it make
sense to add one with buffered_io=1? The test would need a pseudo file
that can be opened with O_RDWR and supports both read_iter and
write_iter. Otherwise, it could pass without ever reaching the new
file_is_pseudo() check.

Thanks.

