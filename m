Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37EC4606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 04:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=viHTmfmI
Received: by kanga.kvack.org (Postfix)
	id 509DA6B05B0; Sun, 15 Nov 2026 23:34:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1C66B05B1; Sun, 15 Nov 2026 23:34:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ABDD6B05B2; Sun, 15 Nov 2026 23:34:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 147646B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:34:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9840D808B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:34:25 +0000 (UTC)
X-FDA: 85439715690.19.F0D3761
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id A0CEF1C0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:34:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=viHTmfmI;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf18.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.50 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794803663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0RTPkBSn8aHOwll0NIb+MH6Rxh2TXo2nlFC6RRntyeU=;
	b=KWMr0LeW1Wt5GygBJ9Dx/kcoFBd4HUNxFqZTAl38D1LNTd3g8mevNTMpHBbxAFD/kFBz9K
	X6Baa4IGTyM7V72CByEpL2CDSu/OSTfIGk1qgJF0OYY7L3D7mivFI+dVJlxRQ28NxtAzWN
	IYGaIpGkSshoTkqoxTqsH7ejomOogsM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=viHTmfmI;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf18.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.50 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794803663;
	b=n3bYAybbx1Mf7U3KI257FA1EiPApkknu44qv7sXpzaAJ2LnttXajd/abC6PGpe0qbWpAwv
	1D/bvo06tRAOkR8ykf1woiaKnRfoDLwy4CsARTKqtRTUnGXqsUcNA3N8xZii5v02WI6AQZ
	eOiubvyux7Q39SfAcAilB9m/+KfnBdc=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-170135e43c7so4781840c88.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794803662; x=1795408462; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0RTPkBSn8aHOwll0NIb+MH6Rxh2TXo2nlFC6RRntyeU=;
        b=viHTmfmIbW+tW0X8fD7ozxvXQzDo2qJ9XGVa7Uopk1doSFQrA5FtLwBWoYd0Ao9w0l
         vwpT8p84e9/e0/gVJFj0W9FO+hAWzlZ/Oe/lBlQEkVjB7jCSVD9KSd9U1Kx4IGM/An0F
         JZaSM7wqyrH7y7WKMKbN/wYdCNXX9mCrMvi2I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794803662; x=1795408462;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0RTPkBSn8aHOwll0NIb+MH6Rxh2TXo2nlFC6RRntyeU=;
        b=ibRLadwh/qPTdaWWXdEvkKpMQoEfWHVzO0lliwtxCCqOrGNnS2nmf5ICD23JylW7QT
         ybg6rnmHF8Jr6Mu7jIFzNpX3d8uqIGD85OZJn6fpVhoRg8ULkbYRJedYv0VfPkILDjpz
         7FR/uj2ms2epbZgR691t/U8yJLYuhapanzR23mNwjloL5ngq0ssZM4E0m/pB700nTegv
         3U490FvwJkLu4TugXLPe6awzXm4qmcraOnD7PIFgRx6qjTvhbM1Ulb7JxMtdegpA8zFj
         KIp1yd6GWzRZHB8dp0I8tHBHzE4LwIJVQD3/3fKl8Y+S4DUjVTgS0+bZj1ybQdJZPTrT
         xvxA==
X-Forwarded-Encrypted: i=1; AL+hErFWb2/c1rAYigp+8JyPlRBeeyZHInJer5c3eU9O78P5wgMTpAbFh+PNEzbqoXJUEtHNXzNlWI5hRA==@kvack.org
X-Gm-Message-State: APuU4Z8tM2JmDoPxxq56XCVwignIEf2MpeC/tdrtl67HFyOhoS7k/6dg
	Bj/ohXrwUM7zA/3kXZ4Qh3mjrencqtsS0KCaRMFwzWfzkDDI+IMLncXWRzw513nGKiY=
X-Gm-Gg: AYBFou1DJfsbsJ3It1pDMXgi+tiacOmnT79SxwR71fqCFMV9lcEyukwmnk5Mj/K+3c4
	MsxaCGhCOs9jQjWRsxYbZJVTKFKGTJC+UNZJJg+l5Xw+2L+wnsTrOitYj43Md37XyQ4Q7iGGm+6
	bSl7C62O1XEGouSwaGVtGMEI5mzPKKA6n/oL/noXn+NWkhjMI1JqZPFeQB3Ui8J8FQTYlhc3oAH
	v6otm7ye31wU0hH+SZ16ia6T8c+rU87Yu2J+aYjEjljTjq6qjXsnTlAVvptV1Htg0WhyD4+6N8P
	+ms582YQRQMxsyKjNxFmwIE8NySzhIlqxVOEO46B8zy0SDXZwI1dIVdchk1P4yx1XK5sYbYZ4z3
	fbOreqgOvrAbGYjnz0qJs5ntX/vDtxhahjFM5fbOxlSXDPAQAWKUARf2u8M4AZ/6hNkVpEiag9g
	Yf8G5gbLxxoMZSowPEl5JAApANzLXOmcbV09NNbEoeUZ7WFdZGIPOwcxrZ8XC5byaRgwgzM1Ai4
	h9F1POrMBPvpAvo4/24J8nPfTQDZuH+6qLO9DW+IIIyuvMoIAxfoTet8Li+wC7KvEl6uKI3HrYr
	q9XTue67qMXIoilqbDdiQX1RG7ghq0gfVFuPFQMtX9qu02RDrtV62UFIvxbyxGW/7UM9IxMbobD
	qxRTpbTuY8I5ksCzdB3s3DTU76WcM+5Jbk8vNeeZqjeHWKHFt7ZQs8CcobTm6qfvlZwXZ48pRzu
	wu793H4dAIQOKeMH+AWyjC7jds0nYtjaWkfwIGWzAIHJlWgEXdMVo6ZP6m/oYP/FHR
X-Received: by 2002:a05:701b:4508:20b0:194:9e7a:3ba2 with SMTP id a92af1059eb24-1b50306c4d3mr9813315c88.2.1794803662025;
        Sun, 15 Nov 2026 20:34:22 -0800 (PST)
Received: from [172.18.0.2] ([172.56.232.151])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5329ec87bsm2576204c88.0.2026.11.15.20.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 20:34:21 -0800 (PST)
Date: Sun, 15 Nov 2026 20:34:13 -0800
From: Chris Down <chris@chrisdown.name>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org,
	will@kernel.org, David Matlack <dmatlack@google.com>,
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com,
	loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>,
	oupton@kernel.org, alex@shazbot.org, gle.com@google.com, pbonzini@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com,
	joro@8bytes.org, kvmarm@lists.linux.dev, linux-pci@vger.kernel.org,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, skhawaja@google.com, sagis@google.com,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 14/19] liveupdate: Add feature header to struct
	luo_flb_ser
In-Reply-To: <20261110050202.529473-15-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-15-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261115203413.eaa54fcba43adc22@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A0CEF1C0006
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ntnxr3cxjomekskdto9i5naa7drk4hcy
X-HE-Tag: 1794803663-581667
X-HE-Meta: U2FsdGVkX18aA+uhpPNZV1ANLGyVL8ldmtA91xySIZYqYwAeLvM9aM3v2YwEVWTOq+BUDwNZX7fsZmuUTpyWKwIqMu+w1AqcQQ2qfSNGiCphh87E/i6BSzv9tvrl5lceU18JRMFwXtRZcFqnkvN6Ig+6UuZOhQSKRPwTM/HcGcIOXY4LAy9cPzBk76JyB85OYU1zUj7dViOKweX3MOCA9NOUiPufWaZkPjNeEDPaoTkb1XfcN/bouiZcdgmdxfC44SaWaCXswRRU20EXkeVvY9smBdWxP5q2m6bO88G7fYbz+Ctq0pfEkLy373ndfYJv4eBK89B4ZhLtUf/V0qFb11mREUMfSKI8V2s0C786TgoKKxO8sxGPtIB7rfoTumPMI7c9bFqox9VZI/6LtOwKVSLCpiePzfK+6q/f1WlYjmav5SQqdl7Y9y2cfnU2GE+wjBRPs6yDIFWFXRJajdnDWmgfSBIaL3gfaLOVabs3/2C39Rq0KVk02uyJWlgZ2QQaUD9Abo3rRSAhYH4RuWRsGyHapy+4mS/M4ZsaqOx5d5zTCvhOH6ZRIDtS5rWx8j/EQzANwCQB82VpcRw4gDztVn/sZZNvoJtxqeoIBe6UCm8vOM2Mq8zEisuomEZFL0BVt8tXPN/Xkc4FM9pp4tT01GOE1EPj5ieds1AgUOWANeRBg/FiB5HrkROUBKT8qU0SaXRC3eEOuYHDGEY8ijvDtC0/y37ezSRZDobK2Qx/xKzNbsC2hPr//bzGQr+t2N4SjxY8JyyLS8ZnfQHb4WNqYuD3ROlZmg7+bU89ekNwGUz53n/nyaTRZH47zEEC+z0PIEsoqBETjcRBeQJqJVWj5EkOOtPcOAnCp5XxDTulP33gV6ejbrpX7w8c9dAwI9aIiFM1PXEFcrCl4yewaWii2CRy0FEXSdXe2J0oJNmpYw+Zm6smBzvC/2yAM65JZoKfwcYAalaUWVITSnA3mh7
 MdOnGp2E
 Bh6YJCKL9Dbp8M/O37787GrZuRQlBanMPiEMNUG1qiu2WOI/75mdq/hlh7qTf1lPtiuUThkefGsD15qjxDhNHssJLZ2fmLKAa4iZ/SLE0znj0IZEjiA2pQgnXD76V7xko38v04SNGK7z1QgpjbyQjhffXPk3qHiU2F4kssv4fqtOOa2G4jaUMUKPgA3Q00TU2HNcYuoCTwiSbf5Wc2MinEs/FYWY3ETs8oAQM4Q7AMF0+SicnxzhXBQRcTWpUVgvpjD46vdHxBuqJ++3OCGvjYSXX4bzne8uuRHoh7Dddr48IeLdOIYd30eql5IiPI/DhZuSSxxzhXrFS+9/spbU+hEmgWcJL8V1ilzNacajoDpHRM8ieVQlTBi3NwLmkt3iZrex+HHlH+wVTxRphLLYbiTZeapz2titkfADJgi+7F+x1osAy6Q77pvwjUGktteVhkr4zW7edBqHpOurjoQRxeFhJwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Tarun,

Tarun Sahu writes:
>+	for (u64 i = 0; i < fh->header_ser->count;
>+	     i++, fhdr = (void *)fhdr + fhdr->size) {
>+		struct luo_flb_ser *ser;
>+
>+		err = kho_ser_validate(fhdr, luo_flb_ser);
>+		if (err)
>+			return err;

I think there's a problem with returning this error as it is. For an
unknown required feature kho_ser_validate() returns -EOPNOTSUPP, but
callers of liveupdate_flb_get_incoming() already take -EOPNOTSUPP to mean
that live update is disabled. pci_liveupdate_flb_get_incoming() returns
NULL for it, so instead of panicking, PCI carries on as if nothing was
preserved, even though those devices may still be doing DMA.

 From a quick test with an outgoing kernel hacked to set an unknown
required bit on its luo_flb_ser entries, that is what happens after the
kexec, in that the PCI FLB is never retrieved and boot carries on.

Could you validate the entries once in luo_flb_setup_incoming() instead?
They are all written with the same header by luo_flb_serialize(), so
there's no need to check them on every lookup. Going by the code, a
failure there would panic through luo_restore_fail(), like a bad
luo_flb_header_ser already does. If the per-entry headers end up going
away as David suggested, then this check goes away with them, of course.

Thanks!

Chris

