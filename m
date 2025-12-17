Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF0ED65C7C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 17:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A3B6B0089; Wed, 17 Dec 2025 12:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75EA56B008A; Wed, 17 Dec 2025 12:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636966B008C; Wed, 17 Dec 2025 12:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 52F3A6B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:01:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A026C0D53
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:01:59 +0000 (UTC)
X-FDA: 84229580358.24.B167E84
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4A41640010
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:01:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ICaVjhJC;
	spf=pass (imf07.hostedemail.com: domain of clg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765990916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dD5nFNFh+CHq/nzULmKKE12yIQGGBSkgJsl56ofghHQ=;
	b=he3LudnDETlwrAXgsd/vGgrHu4t47fl1PFyBK3zJ1+4mPgEMyxXwiRk1bMUb9GCTe5tOT0
	JUEhHGFv4hgr2MzDjBkq7wXVHoHuoVR0+7FAeLz2uBtlLyfUIDA+SS2Zu/KgNHvYB/fu2+
	kg4ZS/XjJ45KT6p/hv48hr9sJyFpZ7g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ICaVjhJC;
	spf=pass (imf07.hostedemail.com: domain of clg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765990916; a=rsa-sha256;
	cv=none;
	b=SxHLIc2jJIi+17UNTLC7pCIFoqL6/VLqYAupF7FJ5etN6JvP5Z0ICSsy9xf3ZXTrGfX4D+
	bDgOPGQiyep+HsKCNSa+89B0K2edBaavqk3EMIDxoUTnA9lVv4IY6OomE3aRHL0oswE2H+
	KvxPKACbzdjZar4cd5T59uQ1kA8HSzM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765990915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dD5nFNFh+CHq/nzULmKKE12yIQGGBSkgJsl56ofghHQ=;
	b=ICaVjhJCBc7Z6vRvnFc+v2GlU3Ny51ubvHlo89CWEzPstJ7ovQPCcXMvBZfznJSWiAWbiD
	4FB8hGJ4usljOH7gRW5wOST1ghuuyuk1N9RrBX5swPAQBtZKK3/Z80UYDgqn7sTu+3xVE2
	UpAvH9YnPHeKtMQ5HfMHDEC9bD2ipyE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-_58FoEruPE-9RdPkVAlAfw-1; Wed, 17 Dec 2025 12:01:53 -0500
X-MC-Unique: _58FoEruPE-9RdPkVAlAfw-1
X-Mimecast-MFC-AGG-ID: _58FoEruPE-9RdPkVAlAfw_1765990912
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fcf10287so3222499f8f.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:01:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765990911; x=1766595711;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dD5nFNFh+CHq/nzULmKKE12yIQGGBSkgJsl56ofghHQ=;
        b=rMC8vpwV+Fnfv7ICsoO+AdB4UoJo+gHSG8lu5JxFrbdsjXC2HvE3vMnHdr6Z87eOoe
         D3hUOBdY2SeFjNZx4ZZvOHpbXgox1bkXuEEnfLwt9WAmhm89nAL9fymPkun6ZI/KUANY
         2A01pGvG934rYABXWqi95X5eAsHhVTtMFafZGIuJKW9J0mARiK6jNC3FdvShf9tYeZbn
         FbJLtl6t7p0FUshhd+1iXeLeg7UA3QDsrZIagJZj3J8NpE2/3uHh+4xxaNCvCCkE4GhG
         vnQ42ucVZz8cBDxetVDzXuHZYGaUu09+0rd3uFqY77aML6S9t/uJSrv6snUma5GRwt2l
         Q8WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYlEAbkaHFwBB9rEO6ou8a9rQpB6JkXASkHXyVMDE1i7zB4dKn3uYpCpF8GJZbwDByLMY08EBtwg==@kvack.org
X-Gm-Message-State: AOJu0Yz5MCT4zvBNXsO0itGEsTbH6LpJ7Ob3jpMRdjT4RzdK1D2HAwtB
	VfpvbAp4ABnhXZrEZNRWWdDw9TVuvTOMFXORCi2qyiwbSOBJhymFK2nr0nig7OxXVGD1TKA91hd
	VkbfZxjUCELT+LHpUwwICMaeJE/f8uZJxcjnMi66MZJYeb/EYoCP2
X-Gm-Gg: AY/fxX465ghoHr01tt3W1VG5Q15SsYxpX6uxloDeCiaeyRUpJw+oNsQYF5f+XhtwqY7
	Wb/r+70+Lv5ChI4hBzaeDQfV5ZJ6RXPrM4clXsHL4FxtiThlKL9snLu32r3GM72UtuIFWUlz6j/
	Y4tvkagmzq6xOc2x1xkkvk2pGS+Ys5fGAu49p2L2+OVROUENA5B/ePhu5MgArjmY1XVJwb730Xh
	psuJ7+VMuW3fJ4ptxZcelb7yhMpHFyMwy5U7NAQTcUNlDJm3WfecPc1g+xfUpxIwqYlA1QsG0H6
	XU2PRo4ueApdHVxmKJn7YBVAbnkgA+SCv9M7xU65ZWlCRIWx979VL+Xs2IFb3b/eoVsiyY1DNxo
	pcNww0/GNRoPeGza0B+t4LqNX/scAogSiJBpu0o5b5GUDHGLq
X-Received: by 2002:a5d:64e6:0:b0:430:f5c3:39fe with SMTP id ffacd0b85a97d-430f5c33c72mr16059999f8f.4.1765990911460;
        Wed, 17 Dec 2025 09:01:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7naa2xfBN81UFldN7VJ60YMv46kr3qq+t2tP1xJU0lrdjUCzUiNloJ8sGrQh5v79JlM1s8w==
X-Received: by 2002:a5d:64e6:0:b0:430:f5c3:39fe with SMTP id ffacd0b85a97d-430f5c33c72mr16059928f8f.4.1765990910912;
        Wed, 17 Dec 2025 09:01:50 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43244949ba6sm34714f8f.19.2025.12.17.09.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 09:01:50 -0800 (PST)
Message-ID: <9d06837d-7aed-43ef-87c2-1ce4f921dff2@redhat.com>
Date: Wed, 17 Dec 2025 18:01:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
To: Nicolin Chen <nicolinc@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org, Vivek Kasireddy <vivek.kasireddy@intel.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <aQpRz74RurfhZK15@Asurada-Nvidia>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <aQpRz74RurfhZK15@Asurada-Nvidia>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wdj8vCXlLLwTmvlTAPIXOkiKnS41K2_qvhB1KDEdrpA_1765990912
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: botibsyqxyx6dtdbh9rghgcsp9hci3ji
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4A41640010
X-HE-Tag: 1765990916-706637
X-HE-Meta: U2FsdGVkX19rC7sCPdqXGVBneSrmrEnAdPcKZHXU4EaNP29DD1kWWmUXFav9IJcNo9xKw+aDFtPHGZrO8YRbzAJ+k9Yqmn6RtPVLUsbbB/JuPJgBi9vUJWfDbTDS+JmMyh9AIMdZqLyeuCNpxcXC3K9VSxN2D/igRY8slgXzXyFESXMeHqr3SrVUhUsCSGT+KxUXEdyiDA2QTI7DipoXF2B53TRrAgElDIcEX/ZELsEcVlRMleFHPLYLcVohnDsXWYqHruD29/0aqcwRXkBEjFOU827tfKkHxAr+PKyLdOHlaHO6h9AfHlFdh7ds+pGDGA785ftwmFu8B8HSpdH5jgX11B/Es2t9L02Z+c3RYVaR4oILYWENtJFdAejD+lUInAODgu1Rpp6+Sog27glYqdCuBw3YnrsGqjrJhskk5GsCqoeCe4X3hvMKNvnY0plYZQFq8FQIjPudWhP1GnqwWtOBP93eXu5yg+gL2arOQVuVGq2Rxej9zdx+xCd8eQcRVHMdvv0q9u/yDNFz1w/K2bNl5Q7XQ6qPvTdQFX4uZvxW7VTJQtcmh0kjGSks7pg2edKbaMo36ntQSReGcVS3rlS9OVb7idNSIqHETqIwudYMvVI/yNu+br/gPWH2ZqIb02fKfyxPIQ7/bH3duBFdYAcqRFRzmnI/BlgBOjrW5Zcu7E4Glm6GWhC52msEbczPpJMrMmYwlqcgGb1JG5hH6jvYI2LSXzDeFvyBeQWQoxnNJeOUoBXm/brkOltnT8wvs60q2qfi1RidQ78QKCO5H2MyBEp9g1+3UybShCAsuUvowLB7iyOBUmTQPrPqwxUHdqyiOKx2HrDJW/xVmWeauwSr1jPPxdKL6iT2yQmNcVBYNdJhmR6Rx4cC6EfEhzKGL60koM0Bg93Gw0sEWLRgmMDUOGelj9T1Z/pRoc0wraU290NftTi/ilATuwCh3uAzN1aKICablLprndXN3p+
 p0Sv6nCT
 1VDvMTx06+5uBjqGd+Szxi0K9QRkdQBSNBqOdgq/az/CE0s9SoP3spC96nxMRf9q4qDd+4y98LrEKWW0nZyaG83cLX63uCUW1xOxI34lRQFWkdFBE5T66Goj/2uYNBk1ZRbD1a4SmJXo7804zVI3y6njCpxvxHiajuhA7AtwDaZKFezVc1ob28H65o0oiLocYvtij2XphtxQN/2M9d1qnwrsiUfQG3ztEyypCgy+WvM0uScw1C30Vci7geF7y5C0BjF2MqS2oKAs2B/iWDCGTjOyGO9SUhKuGDCwCXgdCSLJ0lB+3K8Y5MbrNxrD1k3V9NPmM8+eKx8foGcPHYynZcADVJaeBDrOmEA9DsNm8h2PwXr5PY+oUXvOxLMNqi0S9ROUkG12HN/iNn36w+vw+u4o1En1YlDPTHraITSQiw7B+4OCikN9EmrrIihysZN+NspjewQ5kkWIV/3M1bipMPLd4q4Cx+qxbTu+doZ01ZBJJCaQ1UNz4r8xNBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Nicolin,

On 11/4/25 20:19, Nicolin Chen wrote:
> On Sun, Nov 02, 2025 at 10:00:48AM +0200, Leon Romanovsky wrote:
>> Changelog:
>> v6:
>>   * Fixed wrong error check from pcim_p2pdma_init().
>>   * Documented pcim_p2pdma_provider() function.
>>   * Improved commit messages.
>>   * Added VFIO DMA-BUF selftest.
>>   * Added __counted_by(nr_ranges) annotation to struct vfio_device_feature_dma_buf.
>>   * Fixed error unwind when dma_buf_fd() fails.
>>   * Document latest changes to p2pmem.
>>   * Removed EXPORT_SYMBOL_GPL from pci_p2pdma_map_type.
>>   * Moved DMA mapping logic to DMA-BUF.
>>   * Removed types patch to avoid dependencies between subsystems.
>>   * Moved vfio_pci_dma_buf_move() in err_undo block.
>>   * Added nvgrace patch.
> 
> I have verified this v6 using Jason's iommufd dmabuf branch:
> https://github.com/jgunthorpe/linux/commits/iommufd_dmabuf/
> 
> by drafting a QEMU patch on top of Shameer's vSMMU v5 series:
> https://github.com/nicolinc/qemu/commits/wip/iommufd_dmabuf/
> 
> with that, I see GPU BAR memory be correctly fetched in the QEMU:
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 0", offset: 0x0, size: 0x1000000
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 2", offset: 0x0, size: 0x44f00000
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 4", offset: 0x0, size: 0x17a0000000
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>

Do you plan to provide P2P support with IOMMUFD for QEMU ?

Thanks,

C.


