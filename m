Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E1C4606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=GNHvUlV/
Received: by kanga.kvack.org (Postfix)
	id 3A3266B0671; Thu, 19 Nov 2026 10:54:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353966B0672; Thu, 19 Nov 2026 10:54:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26AC16B0673; Thu, 19 Nov 2026 10:54:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 011276B0671
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:54:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B907C0B2C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:54:15 +0000 (UTC)
X-FDA: 85452315270.25.49907A7
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8AC2180013
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:54:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="GNHvUlV/";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795103653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZawY5Vp5pcmWaRt7k/I5GMdXlKlkbCgLu6fGYeE6CNw=;
	b=SZ7kc5WWQMoSl66xdw5y35RjWRm5+838wYzN4pEvL5mOaNnPphDYGjK0MqYjf30GbWXyqf
	IMdIhbDThpeJfo2chc3hvS5LDyTBlGj9aVZJ/+0Irk5WLEkveSu/woCwKPhLTu4vAyG+lY
	+IJDlAApj93zSLVtgUfeH7X1u4bNd1E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="GNHvUlV/";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795103653;
	b=k3aklVrWyYmt9nghRhFecv6Jp0vQatGbM4ad/Rs2u5Fe14iOF4I33kRV4mlTXGjrLUwEZw
	Js8e/uEytdc/50H0J3DqxRdDY419Iz05NKpW4DqWSGN47Lwfaol8zOITU+08JgikgMo2bs
	eG2hcHYsmwJEcd/3cEzvp907i/eO5bM=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-9211efaca89so23056726d6.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795103653; x=1795708453; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZawY5Vp5pcmWaRt7k/I5GMdXlKlkbCgLu6fGYeE6CNw=;
        b=GNHvUlV/FZNfGllm24u0XhOxE4e8z/f+yj52VyFvjlT50JLztGLFRiYDAT0AWa53wo
         6qppz825PxEfeNaHoquLNpeFXb4e+yTMzumjPDjHMiSzNQy0XpI4CzsWGalg0c0ntUNr
         aTW9Tpzwk22uDfRcrAGfsunOPx04AbxTXB0gwVOeUaCsKOn3tRAhxTx1OqiHPO/QwksI
         2y+NcY4lceznCz0BVfp0SFxlLvlOtnaOpKI7N/qUdcVClcbc3uo1+kZiDTabrgR7Tf6T
         2vQzreASZsmQrSOb0G9ujKy1L8lCcTV+Tr8madpimLFmK+V/JFg3keuJIGtQkJtePPL0
         2oHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795103653; x=1795708453;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZawY5Vp5pcmWaRt7k/I5GMdXlKlkbCgLu6fGYeE6CNw=;
        b=AaDdjFg96a5KJGcSD5c4cCWE2rnTKZ67zjsDT4jlgy5qNtSHyAnvIPrcI4JeArLZ0C
         RvraWkwgX0TB0o8jBxkFPolmwgJQgSZcUIDrSPsq9FDE4VCLljZNKDrzki3RsiPgrq0J
         AYSzt6Mmt+uaJsBhyRAeXZaSqr1W/5iTSiZJPBsCCwD8RAD43kHRo0+8P0VkqfYd59sC
         FkiH1fRAwDmy8lKIrbdSxdQM6II0frFmCqU9W4jSKP0qlPmgHwUQHiIy6Y0BpJ7p1y8k
         eLQ4Q8zHuwvemHbBsQ+oq9PheUWw8W7o/jO73wLc1Es6O7HMEC9sV5K+6LX+HD9mCO7M
         HvXQ==
X-Forwarded-Encrypted: i=1; AL+hErEWRPt/8HXX0V/1TvqfG+S8k0czxpGTpaEY3HH+xElyA5RnQC/sccut/3ik6QrVT+gRk7pNuWS6lA==@kvack.org
X-Gm-Message-State: APuU4Z8NpMi9YRW4EhxHxoqC9NRIXGMOiKhc2xJIwX38SnSXyuZm/jTL
	kojra8kjl/KiYFDHEhU4w2muH7ma/hViocsrIkQSeVl+96AhDuHIRskUbDRl0k0qjy4=
X-Gm-Gg: AYBFou2DmSCbBMyhOHoiSJtuvAukXytagCUkKojjg3OQ9M//FFEi6H47P2w7yei7mIg
	vZWgeUb2kgR6UIvQRNp4a9rY1GQoDNd/q+XcM6Jxk2U1CfiusSGe/4dqNGnDsVEx3qFS/Jhi8tR
	QuY+qYUVQDNgQ6GtKfec60eEk7oP26b39vOdLjW5yKgzDF5mDQ9/vFhmoTKyGAIxU+Kk0y8FuIB
	CRWeQeWrz1UF3L74oYp1xaVddX7103wcaJftQ+0NDtLPcvEoQb2bJbWAFzwbmIqnARLGrTwNOEA
	yLrofwnGi2ea7MQ0N8puEwYUzsNCiiVACChsJgx4I8x/+kFUZ1CgNzkszGDOQ3KSZRsbHmfcgiL
	u3s2N3I5J2fDUmFksBYjYagi8b3US5cLiIWiFudLcT0o4CmC5+E6CwMseoTSfgJ5MkDcZygU0X6
	IHM2lEe+hcRr4psvOzVuMPdDOjLnCgzEB21BmrtF3lptm2U2GiuGCDzGivW34/KQzYwNKmKdOek
	97Je+eNNiPBNncOME1xPc/IhFZphK9aAy8+02Dp93nHrrFDAUgr+JVN7/oBMJOG0OV1fRvzPmox
	fb4bf4yTmHJrPkwGtzMRfF51K9+0jVzJs+R1B/ND8AoQSZIFOSJJrjSHzgLoVHRTdYtAnRD1Xb4
	ZaUax0lM=
X-Received: by 2002:a05:620a:7019:b0:949:6fb1:b422 with SMTP id af79cd13be357-94999722082mr1095088085a.16.1795103652690;
        Thu, 19 Nov 2026 07:54:12 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949b9a3fd50sm19992585a.19.2026.11.19.07.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:54:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] pipe: Prefer mempolicy node for metadata allocations
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Andrea Righi <arighi@nvidia.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Quan Liu <qualiu@nvidia.com>, 
 Lee Trager <ltrager@nvidia.com>, Seth Forshee <sforshee@nvidia.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Gregory Price <gourry@gourry.net>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <avQP1aXhe7nQuzt9@gpd4>
References: <20261110065219.894219-1-arighi@nvidia.com>
 <hbkxlhc5y2jkvuov5o2kjgpisx2pavuo3ad4c4ydixeic7vaq6@mpzzfmhjvtof>
 <avQP1aXhe7nQuzt9@gpd4>
Date: Thu, 19 Nov 2026 10:54:11 -0500
Message-Id: <179510365141.412063.5548407366346393690.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 8AC2180013
X-Rspam-User: 
X-Stat-Signature: 9sqc64opem4473ecnngi45rw3obwu4aq
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795103653-537655
X-HE-Meta: U2FsdGVkX18vgCjx2D+K/iVsz+uUsbOjyjOq0CQnWRBRna064jHEpaWHTUPQITU7ucmD8SpFsjgnqWeFd4vZyVSeFK9XESklWpn0atUkZe1ySOAl+Tdw2SDSOCHH2ewPlhDB0YtJXR2D8AoPHdM/pk2Y3F0uL1NyVxEuIBN1dD9AuGb5wnxxTanb56QTIdBmsXpPhdpx36V4xP+9trr1scG6JpcIdTiP8qADhWn1bs8aEiIOAqb51iegRyZnw9xwrdDobXVuyTXBaxN35XNYqT0M9U4yBtjTPJOhceoTXYe8BX/WRUvLtV6oNQ+nzfNlB1BpaqNoLYRbDTfaFOcmSxia/OREg2Y8Y73MDzNZcMjALVq1af3KCHaw7uTr5rjXNIMjLfUKieRFpFha7vSgL2Q+pRJDxfOCaGtshC1aJiy4C16CTFKQE9JhGKMfuk1C5oUxB3w5rspCaTbuqZ2C+DAAPnSP+DAFmZDBpHrw+Bnfd8ug5U6xvo/cLoyuX5s9/PQbkxKBMVRlj2Gj/p73C5AYBVg3GBxJDqhCvLooVIz7TRSiXHOlQH3UoeUCkaqGB8QpJ2dqqq+QULG4tHHrBmeuR7gtqmIus7f8yNVSTnUpdZgWUH8tFhFGLkv70i1ZTGF96Zzs5TdVE+j7CglpHQx1CI2qrUE3c+I/C0bd/YAuhaPNT6g0WONLrAR3x91DL7NdPLFCbag97P6ED8jlgtdjh54/35Hn/lah2faHbZiT8jdOUfzVnhw+ToUplPdT6ueIBZg3jdwDHBSHm8AtClEvjNHiRbRUtdeO4V4XLyMcXlx+5Fi/XhMfx6q285+m3IGcR/8I1yJfFAp/TnX62qUO3HoMdj9OJSswp5peNdu50R9eFr+XZXQCL465ErEH6cyhf/eyYqSxmKvVHVIBbd2Occx/P6tTbc89hIyKIOHZDz9X3I6tPFBLBEyV600zxippmDIi2XIDcOHUARv
 Plxy6BhC
 +24v7WoUtY3kvnwRvPaaxufUIh3POqh9t5b6qBaKsE4oM/DaoZ6xSQi01YpthqxeI8Lmh1ektcJBnA4rUFqEjvLEh2CdufO7W8E98RNzS2XxUDOMvkjaxZ4Iyt9e+xHaDjCFwaWEKGmasTSZ3RL5Q9TsD+BbdGXMmH1eUbwG0xbiAVBNeuMAlrW9y6u46CND/N3GbSz0L+V3nUb4TBv+gNETewq+IR+sFDhmBOKDqtjV97Hy+d+NOcG0RHCN4Tc9sr08ZtXOUB8gpVqgwmWgnukUOWI69TtQL1y++5IBQk2Ob+HW+F5iZey2vC/faRvzpRU/sTWflr4586fztsKfi5ql46w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 07:48 +0100, Andrea Righi wrote:
> 
> Vlastimil, Gregory, do you think this SLUB locality and mempolicy
> aspects makes sense here? In particular, does preferring the policy node
> for slab-sized pipe metadata, while retaining the policy-aware path for
> larger arrays, look reasonable?
> 

Funny enough I was leaning toward task mempolicy being ignored for
non-__GFP_ACCOUNT allocations but SLAB_ACCOUNT makes this a bit
complicated.  This would be another scenario I have to consider.

(related but not directly problematic with the change here)
https://lore.kernel.org/all/20260701222112.2820098-1-gourry@gourry.net/

As a rule I generally think depending on userland mempolicy
to direct kernel memory placement is fragile and unreliable,
but your results are interesting.

General notes - I dislike direct current->mempolicy access in
random places in MM, and dislike any MPOL mode checking outside
mempolicy.c - but sometimes it's necessary.

I'm not against slab having better numa awareness, it makes sense
you'd want to prefer the metadata to live close as well.

Give me a bit more time to wrap my head around this, sorry for the
delayed reply, things have been a bit chaotic this past month.

-- 
~Gregory


