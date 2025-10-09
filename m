Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B3ACCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 11:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D25D8E0036; Thu,  9 Oct 2025 07:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3830F8E0002; Thu,  9 Oct 2025 07:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299278E0036; Thu,  9 Oct 2025 07:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14AB18E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:36:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79A4711AFE7
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:36:07 +0000 (UTC)
X-FDA: 83978371974.17.BF893CA
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 52230140007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:36:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lLWLBamo;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760009765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5FQj+qs6DmW6o9C6/UxAhR39wjcn7nWtLY34WIZgGw=;
	b=kSy/OqUM+opIbm/XpT+OCQhfkQrEJevFquPg2meXxazNSEM37niymsOu0qdXXM2xRJpA+w
	fZu04MCrNJJxdzXXundAVh0k9ONF5cjoftwpCaPAuaLZs230UGPqIMiqsErtotaEekuhzw
	F51w8jiAfxvpPOZLyMIuWYjWsIJKxh0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lLWLBamo;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760009765; a=rsa-sha256;
	cv=none;
	b=cLSImKQ0xI0HPiTqjUvpX+VtxEEptVHFVf4S8z5+3YAk3sJ5zE8HLYc0nDl8PnqUd0GhNu
	KQOrqfIah7MMFWTmVdYqDoMIy9arFwSXf5RIwe7TyTjwQasT5zUSbU+WHTFY0w0tsz1koW
	G8/Qa0fCUbxGZn2jdMo4bDLbodY5nBs=
X-Gm-Message-State: AOJu0Ywiz0N60tuu1RZiKs75RYwTLBBiJhO48AS6D07QOKwQNhVCP+bI
	ULH2CCt+3NmyNCoAudLix/yNsVZNeL98W/eJ1UcNjfN2WYB4QbhoDMsJQYrC87O2Xka19CHNT0C
	N3lduwfPV3iAtisTA7/eaWs8GPFPOceM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760009763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5FQj+qs6DmW6o9C6/UxAhR39wjcn7nWtLY34WIZgGw=;
	b=lLWLBamoZ9Vze3bbffxc2NqDZEkTkmP5NueaLuRLtDk6TDt6G0WH/OCkcluwDVjtDzhbu9
	EnucY5dxtbCFT9qoGLojckSegsaErZzsjCuDeonorqG51W6AIjVVoGGjxFgMmgrzuYD07l
	rzomPzGOmXyhJTfOi/yfr74DarXFxD8=
X-Google-Smtp-Source: AGHT+IEn6DfUJzTF+qrN0U8A3hpm9iF5aoWwXO0T2nuUH9Z0DtFZJPr2qGDgZztcydKq4KsrmSpqANEY2EpX+r8m+YY=
X-Received: by 2002:a0c:f701:0:b0:87b:b6ad:e647 with SMTP id
 6a1803df08f44-87bb6ade751mr19703066d6.6.1760009759425; Thu, 09 Oct 2025
 04:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <20251007063100.2396936-1-anshuman.khandual@arm.com>
In-Reply-To: <20251007063100.2396936-1-anshuman.khandual@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Thu, 9 Oct 2025 19:35:22 +0800
X-Gmail-Original-Message-ID: <CABzRoyZZKACWQ4jeOUmHS-0-7t8ELjD-GMZ-RpiYDGL=T6PZCg@mail.gmail.com>
X-Gm-Features: AS18NWBdt3Xvr1mjG1xmHMEbEeTM17-hxQa2VvgahlWoWMB1DxgCulMHrUr3oNU
Message-ID: <CABzRoyZZKACWQ4jeOUmHS-0-7t8ELjD-GMZ-RpiYDGL=T6PZCg@mail.gmail.com>
Subject: Re: [PATCH] mm: Replace READ_ONCE() with standard page table accessors
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52230140007
X-Stat-Signature: qgzf75ngct59145kdrq5hjkycfyt34wd
X-Rspam-User: 
X-HE-Tag: 1760009765-175520
X-HE-Meta: U2FsdGVkX19uB5ECq+qm6TXkk27s/Nm0rjhHTyuMQqL70z0bkymDFQop8Svz+pbOczqqW/KwwQSkKSudmrkTMfAZJtLAhgpm2ELw2vlBuaMa8VPnKjph1p/elAiFu+eu0Zvo6caQ2nKAZur8f5cLrjH+IvXQbt9FE/jB2JdYcI//u8B6bcWDrWjvU55+Nd+0qJn5uWa1TdQSgW93hFpp3pEMy0pMxqxJDdbJWHEE/pWgPHYwV0YE2Ib148K5QKEdSoHxtov++N3gMW4AUFftoDvGInydV30bfPSA80HwYA78d7+uhgR5lbWFd4SERx8MtOroFhEzAGEI1tPviEL4CTZWHa59zFvTQPwyin/FTO5JtKDxWQzl7LbcuXX0sIZk4w53G+8lnhja5GYS+x4mVSwHlXmNNbJsO9jt7Qos5yDh1DFtpcTcXM/+IZrs4bC4QxSSQC9gQFQegXedMye3ZIGlMerk/0sBRrNA796u/2Aw4Va7nxWgYrTmscB+Ap9AHoHUFPT0Eb+qVCAVhOiQ0ITlq0qBWGM2H6RLkP2crfe8+jqZ0nBRei5m8Yc0mqEhghlzCpSt5ih2iaaNErLHy+jLYZnHNlhuUNKp7av1Se/rw1zhwOEriLKaZ+h5gxBHxjB2G226fDHcuYONMMaYXLhng20m/Qcg9EV9o2kS1koEf2HDf68aw1IUfF4flc90ad33hM+2l3QevqPCWGMn16wiVLlOMomwh97oZJ7pbhauxRbsF1tSq1eYkcHWxj9n7KhrDeVON+qq9EEiQl1rjVlC6t+JSiNKxRf4fGg4SEvDNu9+MuiCSxKhVYOMnXYjhRRB9TBKoQjLloM5XvZwzlmev215rSwGomgCfDndNNiA2fYnZiB1CzHLlFCknjKSdjiCupgBDM3H4HhFdWTGUrbPWrVa7Kmo0/8TI0MFbTmCIj7rImp2rpuW00u11lAWR0SF7QjgPAFr1g4hqWR
 JUpGSUEn
 Hd1MJMb+Uekg5daY4T2GJTJ7HKPBHDlvxNtEQw0YOz1CadGHjHmxq4IUlisXh1D70Wrc8pEhIxXq2r343MjSmiSxqYnUf1nKP8wl1LIDqDqlztkoTjSlrqk2/1FksXKDY83DqGFufyaddgKLmemRDfOR/IJBXx82gL//c9jWP4Dqa/bIHAzEfJfujlaVAT4NBFLPeZGAV17C+TZCOhBf4x0wzDoh5eCHWToYPyIb3MaQX1YB4KDTRIavqSFxjAL4TnuzqysEXDdNfs7x0wPKP6UHDudVPmRxi13mUTvGKCaDZjaQHbwhuubtdmGluxnxOZ+3rnh9vUNPGHsDSox9iYW6eHph6pdwKA//Uv0zEgTFDe8GqBEjfB11Hj+obrreqM/dUQ/HWPFR9VErzdXLQpNcvsGca22RowVKauqoBeIuWJoWXw3fQbAHuMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 2:31=E2=80=AFPM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> Replace all READ_ONCE() with a standard page table accessors i.e pxdp_get=
()
> that defaults into READ_ONCE() in cases where platform does not override.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

LGTM. I still assume it is a no-op change :)

Reviewed-by: Lance Yang <lance.yang@linux.dev>

