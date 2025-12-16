Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B02D5B87A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 00:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605A16B0088; Mon, 15 Dec 2025 19:20:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC5F6B008A; Mon, 15 Dec 2025 19:20:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC566B0092; Mon, 15 Dec 2025 19:20:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 319F76B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:20:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCCF914040B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:20:15 +0000 (UTC)
X-FDA: 84223427190.12.6647A0A
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id D200E20003
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:20:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=is2QP7IU;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765844413; a=rsa-sha256;
	cv=pass;
	b=0sIx1fp4MGjutf4NoFTFEAN6qWtZpA260SelF0C98V4jwMpuBUrDSB3Ux/Ty9d0sRmO6WC
	lzhppLM62bIvHlidmrq2GDVKdzClMn13YPjQEsKvkWPRBclfz172r1hPdMQbU0DtbfwvFG
	DbGUkSNk4wzBAb3eFux5W1gwmdfLvUI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=is2QP7IU;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765844413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/xSO2loElEQu4qJwQAmc4hWblw65frcVfwyqUV19Yo=;
	b=ifvL/i74Z100QTLwqwFCDnTRsEaRX4bjTfvWZ4DtDpCswDTwRHpTFYMRc1kFoNcc26mX6v
	q4VfKtatblJhskQpy1pOmcUj29gzJ3W4jSh907cewjTQxjP3ZQ1syyJX2PX0bCiPYFRStB
	4eZ8L3qI5ilS/ZnicTTJAS8rXmg7B54=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a0d06cfa93so14105ad.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:20:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765844412; cv=none;
        d=google.com; s=arc-20240605;
        b=ZhAM3zGMOgi8RnpzHn66rde9PyAkCshae/FPjCJaXKU/bZj/Rq5/BCVgaOlxRUZrvy
         qHF3vdJRmDyj+CSO+QtQrdvEx0bCgb5DaNX/eOu0IVfnQLFYSkfkXFCcsEOFTZjuln1B
         MtZAqkhc/G72PH8kBlvJ/i/Jt82iKyZqTwEWebwhwYCPnpqetEK4HStwIlschi98urPr
         OnRkA+kCmOShk5UaJQhkX3/hwZB6dKX6l40HWVfoh1hUcmfGxtEDPqQk2U2xhcfePlRp
         vOMEcWnHRnnhzFyB7kpPUSwHwpHH3OAYSHscSTpS131eeF5jvVM/WkIgAMpS9yPqdB8b
         2mig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I/xSO2loElEQu4qJwQAmc4hWblw65frcVfwyqUV19Yo=;
        fh=zh4E5+rGmdxGG0AfBCohXgAOkKb5Niw84iKKr1HWBjo=;
        b=GeQhHWzNWJk+grkKOOcQvtJt+bzEH+3xUxNjKHeHoTsDtgOkexKz8WRetGFWf8UI1m
         EDO78V+2Ix8WCzAG7chIqgHwBKoNs9gD8wgsrBpqHeT1bIeBy68cLEjrme0UPen6OZaa
         l677O0+sd7KiF8ZLssC0pr9LMnDFZh309glRIvD2moOmUkSd06kuGUxYhwPfA1OgDD7u
         YIiQqdxmFH9ZryeLN0VPFdqszguiDmUz7VKOLHpdE0oFN3wWfV++LJrjMzUz4VIasChD
         0hyIz/uI/whXvXpERDOOjreIGhqMfKyCtdOAXtMpyVwiZzSlLo/Jpm8QC6CHiLN/QEju
         37UA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765844412; x=1766449212; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/xSO2loElEQu4qJwQAmc4hWblw65frcVfwyqUV19Yo=;
        b=is2QP7IU8E0N3xcB+Yyt9YxjQM+n2jrV5yYP4qMn9wG+bb6oKOcVJmCJvtzqKJ/X1v
         f76pCKGY7dEeM+PInDGoZ6jyIkmL0/KezC1dxjmnHOhqiE2ZDC6DCk6bYJazNTyyVQRi
         zq+s+HM1cf1asjYefPmUfAbvEHGpIbtURmLU6yak1NnJ8fl/vdjeMQo+P5rW/YUJrjhd
         ozw6eX+7yhjNGJPYRgZnXit9bTsEt5Ww5rzUQ+c83XViZzLjyZOxomQ5Qyso0DHiWWJY
         9FXRSeT0ltR4ngDbGQ9DVMVCN+9R528Iwx2HSKEqj5N6/kSQkjY7hyVT9RLEwV/GVp5L
         ULvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844412; x=1766449212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I/xSO2loElEQu4qJwQAmc4hWblw65frcVfwyqUV19Yo=;
        b=g9kKjNUcQtUNTpmrsGaphpmfkPJCr35MZz8mWnzMVYz63YROnuGs5KjkExK2sC+Jhf
         NbmYoQipPbdp06qdBrRKS2HqnzU3Z8XB+FstzanuC6O4oSoDZ/JoIkX0p1yYZexIuiF1
         5nlSxUvSwqQqiH4+AoNloo8DTsnS/m/fVMFrh/M3Dk0PkMtrQbU5piXMXuN3mVk+leWf
         XHRKf3wkBKPDAUCOXgmySkhIKQ5+qPUI76iLreEDq7EvbaudcrbdCPbbKoniMzq64IS3
         L2m36+gyi0Iv35u4gtkJFesGioWwexteiM4adUHG8K/wVkjEJh2WjVP3piahcV/XYNup
         C0+A==
X-Forwarded-Encrypted: i=1; AJvYcCVTLHRv9WgEKUfGiQA2N1aupOhJOfPc+PVE+lpJKoWEdXXVwYB2tFlha608C+SsyiTa+4N5q/RTwg==@kvack.org
X-Gm-Message-State: AOJu0YyQxk1RL+FxT4wjav4lDGPNkIjNuJp5r6F/zDjtrjXy4R0qHNMG
	J8QWsXZ6UJbFXSgq4Q7uMRvq3elLgDEDdkUQ16Ds4yH0VO7RmAa2b1BjktdiynM3n1SEyRSE3QJ
	uP5qou823QeapbGNJ/vp6sJUpxan662PwyRlOUlt8
X-Gm-Gg: AY/fxX7mI4ojycEryJEl1ZRXAdBZptnR8nB4Z9oQ0GG5MtOhKQD8kGBbwMmAcNieLVg
	h5VqIQJRN6qdorfJ/XJbVsDA3OxMlOw3gfRM22HvoVAA9S1BSPPug2dUnuIkUhHTu0h2E5YzkT4
	K+RPBK6O2mYdgKfZPrywGVf41r/sUo/bW7/Ni0i/3TyoLzu5bxH53mFV0z5ZqzKpEJy/uHa04dT
	rAY3A59I40lFfdMJlEGsohwFcqo8Jhg7tFhLJvQSFNLjhGWBF4Q4dqyYk6vo4BuIg/wjDjRpuaL
	72G3FFaMRkW1+XEu3mYP/yvYFH97
X-Google-Smtp-Source: AGHT+IExDYh7puOwTqAoucyAbhg/dhJj/UlPMmB4InOhmz+VivF2pgRZLSSnb0+pKynoL6YupSskmHHY1LN9azC6BtE=
X-Received: by 2002:a05:7022:4406:b0:11b:3bc:9ea0 with SMTP id
 a92af1059eb24-1205727676cmr408c88.6.1765844411980; Mon, 15 Dec 2025 16:20:11
 -0800 (PST)
MIME-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com> <20251215153411.3613928-5-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-5-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Dec 2025 16:19:58 -0800
X-Gm-Features: AQt7F2pam8UulXqTs359SLpQ8QESA_W2EL2-JVHHwFHsPgJIIvSeUBgNcYPP6kk
Message-ID: <CAGtprH-te9xrmVgUteAaW17BLuxfZWfu32G4Q+AdP4=DDrm27g@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D200E20003
X-Stat-Signature: 8tk4srpmfqj3itn7u8gtwzom8jxkc6ah
X-HE-Tag: 1765844413-691147
X-HE-Meta: U2FsdGVkX18CUiiG4NlhCkQCj49MFgy08ZMJD9RUu5B3FycUzfO4MPxplv8vnOXXffTO7QyEo3hLsbMixOqUv7Nqqec0VlTvf10shjXL6tBdcNafnw8P8KOjwVnpDmRFVbu0y105izBnAX9hB4dWKqj0hOx0MsL1GZNLhDa4RDfgrshWfJEbm5g4XLm5TU8WYnd+RIWlKcitI49ggkc0Y+pDUXZReu783guV9gU1Nfx6ih2OhxEzG0rDsapYcamO/ZUcX894r2sJymZZ8YHTQi4NfHHmbZsEdE6f/ikQirWyLN313fq1IqESHkf9I/LtLKROUiWgEFDc/Ma1AsO9tKHqAs6HFsL94gkEKnDW/oS/MBgGNGmLamf/pkum7BaoNnz+ALhgNBbFQX3TqkxVHrJslJ1DMX3P2RF3TFIYAsofPcg1XtFXHpkLfnnNTbiZtZ2ir54abFwVG1SMFdOnQhD6z9BtLxUChXgB37NhhxEIxDUQPHuw+x/G/sZg9HveDc9eDWRCTiDg3ZxS/8dJ2AnmEudO1DFt7QS/rdb9wI92lKz09/WAXPjjaMlyMbdg/KJ80WxKqiJrPS1qaGdoqYf80Rvn3rZIMU4pD4X3CTxbouSRHYiCGh4jFM1/DNhJvq0YvZX4bBhDVXAtq7X//piXH8BLn+xnWrfVg6QJy55noyCqAQtTDTC7V/M/dID7O7MW8EdPtGHNhwYyNAQEZ7fFkXFCofRKA8j3ZwAUUBRCD+6oOSv7r9Bi16e772i7foS9yHwSylIat5OxpczamcIExSXUvyj62Ccz5n4HfLaDHOnvDYdxGDHO45eE7olG7EI9KeMuKywOKdywakGMb8iQvbeWO2ZgaqTeCsZbgxgACVE8REJRKPevdw6vvKoxwLzhQYbMPsYeeFODP+0Z8JdQbATByugl0gXN/PutoOOYziCXufUpgbOm/pPkkAqVU+W7GVk12gvJNe865cA
 /3cMmTBL
 1gtE96be6H5wlO0ptQ9eU6PBBtBUT+gP+XaTgVH8oI3Q0E7pA7BArDypaLCmip/S00areKYtx4G3iDFe4vhU2AChe2Ca5EQFqNeQomd1QY9mRmk0ex2MR190ssjC3UXVFXpeFQ4yA2wyKEQuxoD4f6PdqD0Rg+hB6sLv1YJKWaw4MtLvnSLV2E/Hka3pXFj1BIA/RUUTOIwK/U1q8DF6eBUdjw5Kz7dIcSaUD/MKijesH9Ay//w3ujlV5jCsuAHxezBexh35KpM0cERyha4JrWY7BH+o6XGE3sf45elcqst5GxLP4PeXNvHY3nwAgDJNMPRZZSwXo+CnKYfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 7:36=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> Since it was never possible to use a non-PAGE_SIZE-aligned @source_addr,
> go ahead and document this as a requirement. This is in preparation for
> enforcing page-aligned @source_addr for all architectures in
> guest_memfd.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/vir=
t/kvm/x86/intel-tdx.rst
> index 5efac62c92c7..6a222e9d0954 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -156,7 +156,7 @@ KVM_TDX_INIT_MEM_REGION
>  :Returns: 0 on success, <0 on error
>
>  Initialize @nr_pages TDX guest private memory starting from @gpa with us=
erspace
> -provided data from @source_addr.
> +provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.

Reviewed-By: Vishal Annapurve <vannapurve@google.com>

