Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AD8F31E4F
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5130D6B0005; Thu,  9 Apr 2026 11:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA6E6B0089; Thu,  9 Apr 2026 11:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4006B6B008A; Thu,  9 Apr 2026 11:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1FD6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:54:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 955DE8C62E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:54:24 +0000 (UTC)
X-FDA: 84639464448.21.4525AEA
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 89F2912000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:54:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MiS50Hj+;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of komlomal@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=komlomal@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775750062; a=rsa-sha256;
	cv=pass;
	b=VjgNtyQWseT+YWguA3E5uuxd6blp7thqV5VGx8NgpHUv7ajNbpaWQ4GTleqW+piS7w4I82
	Cw+pKqK7tl9XLMjJ+DIBEDjSk6+PQlXCpjvCUIPLBVb+V8+4+y+2eSiUP1p+fP0AQorUU1
	Ief7m8PPzb378lHsKR7gWcmXywZa2yk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MiS50Hj+;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of komlomal@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=komlomal@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAeErOi2nYK9CzTITazgzHeJp0FOe9nj+LuvP7Z4L+A=;
	b=FiOAt2wsFo6QdhA7YOYe6j6sa6Lpq7S9IqXvUas4RMePoBVO/9awXv4GsUpY+kBQSHo+gC
	irAXt0tSyTc1TGkjBQQh9X2lxywrtahb7H96k6loQdCoba8gY+3qfjDDB8xC66r0ONXqUz
	KeuRO4PMzGtkXHW+Mx8/gq80el4wmx8=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a2c3dfb4a1so1175694e87.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 08:54:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775750061; cv=none;
        d=google.com; s=arc-20240605;
        b=Ld9ooyirZ5zC4yLDkEyNAcWVHrRMdtpQgIYw0ygRkn/IDeCRFliZ23D+CBce/zK3PP
         gV1Ao98E6g11MFOd2psJwDoPOPZ1SBnOvNs151eFNrXMzNfw+UgYnoT7003h8u7A4kjH
         QUTgY3VCciurhVf+SnYXsfG2UETLeBhUZrKmWR6BiD9vCqy5/veGQ6rF76WX2f2Yh7xL
         fYtry9xSd3+DW0MWfQYVDADLPAiOiOBtxn/5SDA1pqUjqtfW2ex9ez8bDqJj+voyCWC5
         GT1EXNnJx3TCoYa1rxV4xb4esAM3d899hev9amzKRYAK/3QdnhYSwTMRaChCaBVNmfep
         vhkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CAeErOi2nYK9CzTITazgzHeJp0FOe9nj+LuvP7Z4L+A=;
        fh=lcedlgxkbRgGAmTIROOZ/QFpFVJev12Vdm/PhDXaKB4=;
        b=hIME2+RCmJ2kF5Tklns6YfTh+ILf/ZzrjZLVT5SLbDvMs6fJ/V3qdmScq76lq4GMuB
         QDdDSP2EiFeSwTv8W3Ejqm7tuuJ6whluC1yyud0aCJWm27n0xAk8yvGX/F0MiRjFvzNn
         8k9HSkvkW9eoatkHOJ63vrxb6o5Wd2/IXNi5CisJUQz5pFCFdkb94/8XRVjKxW9PUuTY
         QjKt802A1p1V9i8ATJo1DIAvfirHxEo4T4jVNFvVE72PPf0VRVczTIq3LioE+hjPjnpk
         vk6j2igetbbDiStF2Az1sLrDsfdYVysbxUQY2SVwLRJ4jpD0jmfV03DUw/cxSv+vKOrs
         UCEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775750061; x=1776354861; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CAeErOi2nYK9CzTITazgzHeJp0FOe9nj+LuvP7Z4L+A=;
        b=MiS50Hj+JidlMC6EIWVMzkDU+DGYK32PGpG7dvlRQpGssr7gmaMDkbY1sjtfGe9Wcj
         4H58EwOFhrsqsyE0v5xyyCrLMKjLUiruGNE+ujhU0NyHtjLnDxpMQGPk59zV0Cjp5vZj
         clY0PO+JrWQBCTl2WckLuQ+zFTK03y5qTvhQV6FQzt6MkTC1+LqrXdKhQLbvO0T/MXam
         IharllSFUcwIG6ipGdgvF9F6zM4RBdzofSA2ekzCqsSgPKNfqpnLD1/Nb8pT7QF9alQ+
         1yvKbTEjssg/XDbaMUVTLSQZYHiB+UaESYu2Z1cclUmPa+tlTvxhQAyKc/MKdk6dQk8z
         OeEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775750061; x=1776354861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CAeErOi2nYK9CzTITazgzHeJp0FOe9nj+LuvP7Z4L+A=;
        b=VsNtwLzKstSLEoNfRcvaqegDG8jQ4easUXdzu77ajlXpfF4MDTeXioek9PxMvKthvx
         ZVfwImeAjvUJy/pTNXN71yxkeL8FEiOYvIiBcaG6Ulx+MY7nG1W2ZgNcfH7pzqkPf9xp
         dt8VogJj6fVF86MUhMPUG6RMv4/Zt1smCXs8G/nwPkn3Rkf91t2Xyjs+guw9XfHUgiuV
         CKHzlC2GEGIZTrOw/BlbDqafJASA1z1FGCnHh0fjpnQ4dA5v9TFybnjVlc/45mGqcyF/
         jbKk8nJmjtcwWFlV3dfCG4LACEtT/sDW959U/fyiqaYaaPrfc5nEt4oBgzFyfn9Uyq4y
         FKBg==
X-Forwarded-Encrypted: i=1; AJvYcCVsj2tbakBu1U41Lg3wBU0Cwfuo/Z7SiWDYnX78EJgy64Hj+GfqOl4SuOcmKmF8Zx8r21REVq1dAA==@kvack.org
X-Gm-Message-State: AOJu0YyGHmzkJlLisECXObyyXWcHmgD/AET2bIR34QrGGFf/F8JB98SR
	n8j/IC+mIbwkUKU83Zq70T8aDUzU2O04kwCaav0l0iec1qCn2EKOJGP7GiVbUNk5ijja7ynvAdI
	KGXrrscqQ0ILv9GfQaqH0V5Sjvzm/3dI=
X-Gm-Gg: AeBDiev1doWCvbWF6jIFXgv/2URdpErRIzU/4hvMN+i6yPajYkI1AswDyvcb3iTDMwC
	IUbtT1JEarfdhAlLDIsqfI6JEdAlzQo6xvLbj7MjWc8USaGBIkOpv3ydI4cWmlAa2G3Sv//5GSI
	8gG8/bLOB3MSjJ4wjV3Iw0KEfpwQYSvIrMpKqgJh8/KmxBfz0zKFpYPba7LPXLMNghcm8MjB9UK
	/7PHyLEe7rbwghUaL/kzKoIwO9ouwBzU748rYyt1mqvO/RLN8MYWoZ94cxdk3BOJloASNLFrDCb
	H/GPxOk=
X-Received: by 2002:a05:6512:b9c:b0:5a2:c0f1:f729 with SMTP id
 2adb3069b0e04-5a337566f19mr7506790e87.16.1775750060342; Thu, 09 Apr 2026
 08:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260409103345.15044-1-komlomal@gmail.com> <d4xigmgectqbv5q5dxsrlunea3ynexa4ym4nuxy2rokrawsqu6@yfhzm3hl5nya>
 <adfDCpTH9n2lG63n@kernel.org>
In-Reply-To: <adfDCpTH9n2lG63n@kernel.org>
From: "Denis M. Karpov" <komlomal@gmail.com>
Date: Thu, 9 Apr 2026 18:54:08 +0300
X-Gm-Features: AQROBzBmxDixh3DrVoiXKIPzHCcdgrsRneVlA9XfDga7WmsEQ-NmJ1QJsl6YSiA
Message-ID: <CADtiZd0NF8=4YDs9YR6vKYK92SKYOFd0LR1R3w9ZNoZW4cy+jg@mail.gmail.com>
Subject: Re: [PATCH v2] userfaultfd: allow registration of ranges below mmap_min_addr
To: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, harry@kernel.org, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, ljs@kernel.org, vbabka@kernel.org, jannh@google.com, 
	peterx@redhat.com, brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.arif@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 89F2912000D
X-Stat-Signature: sxjgf1mury9sb4t99tw9uwau1kofz6qy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775750062-488260
X-HE-Meta: U2FsdGVkX1/Ro4UEUUI78qlPQAYKNX5zc+0cweGfwQd+NZCtG699ub5/jnEZT6stbUhhJ8+xCmPElql+DokmMRcXoUzMyyp9y03YkUfQrFwmLKN2V+qaaoJnRUVNlKiXqfhdF9Ql/ulLHg7Ay8n4Nue7SbRu2dN1oCl+pP+Qxu4hv1qQeebFGCxOB/Q4GrrxFRa0P3iG5+2DBbeXsAyRJ2VqfnLRZghrpQ0NC5EkAiRTxggkUdG/Hlwe2SLyV35zZX5lxScnArccUSbe8LwHAEZhM6P25CKeVvJksEQt6E3AzRrNm5Lk3qMjPtPEf7KQcy+5la3zuJ0flMZ9R80FzWKjjRBXI/fjY/HwW6RNW82mswvUAwNxUQcJSMH0YDGs4c9SCU9TT9KVwshv4fIob+ze5JzVf1NPSZoYKq7m5BwjFn3cpp5JsxnzWNsFlFIwwo2hQUgfNofBAdgYTzyMxzcGLsEgu1zVZNXGburXzwIsn8RUHrJ/ZLE+/zudlURJhO6QpfxsZM494PR2z6FpcgIQZO7y6XtvRcoHDjNG1NIA6x/oBy4u4n1wXzHW2Lh1kv3mHGKPWH8JM98ZahR/ivAKxe11ZKSmw3s4CpwCxLsms9fHyOIxfbdOvfsHKGEXFhTcrnH4DQdS4PFokI6yv2ftMH+yJbrJC9gWZ9EPVH2M4pnWf2VvGpTCpEvAmOe5u7Ek9jZHD814AnWCGHTjnkw3t10WR6pi5cgSoqyNwWysWsjJC0DLotj7i6A4fONpQERwH1dqjDwCX7hIEqkeALTbLg0GrtAmuA+4rtv+3P3Y1swELnwu8ieG3MqYrG8vv5Eaj7Zu4RdA9AUwWrV4wg+tYk6LtmARVKLSNUU9z6dsmMN4/H1tFgTdRnATEvm3lQyJmSbobmgjllG11HDyHx6jGmCM7EtbBcZMnbJPwjeIjRDHAEjjOqLXYchNjC60wSV4Jcl7Fja2d/WNR/G
 /NQGU9Ri
 4ZjEeaJk6QINPShXy3YKT5d4wtYPbZC/XSBmtW/C8clDuYMcz5sswe2+fSTbUf56IcBFEqZqNGGip78N8ZBX+jJydgEJC7+639BzxLlMPe9FAN12xiHMYCmG2qATDNuz7KmIB/aIq3gkbg4b94QXkaXraJ0VG3HxcJU+WGO3+Fb3DChoeZfVKqLsUTd5nvT8T7HhcPquPcosUX+1q8kLwLcoN3drEOdd/iPHV2onblSpfaaPpCVwpLdgr8EmWkA1GZcG4+YHtKa9BDDm8sGhDLsj8JlTFyl6sntF8nSfM7u7e3zNEjHZDIIjq+8p4hVskfbL70/p7/pqN++KtCwf15Xc+Abqvv2S2RI7F498x4xst5tJ/NROArfzcP4bWjBn6A4JMsEHpcOPablaggPIwihSxXcd42I0tCdtBYkjbJXhbTTyi0+C5p0rJceP4Uee0FU4/XfoIUiyW0VzS1rtOaQXDfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 9, 2026 at 6:17=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
> On Thu, Apr 09, 2026 at 01:30:07PM +0100, Pedro Falcato wrote:
> > This looks relatively safe. However, I'm not sure if we want this in st=
able.
> > This has been broken for 11 years now, with no complaints.
>
> I believe Denis has a new usecase that wasn't there for those 11 years :)
>
> Denis, can you share more details about your usecase for us to better
> understand importance of backporting this to stable?
Hello Mike.
Actually, there is nothing new about the use case. We simply started using
UFFD instead of the classic mprotect approach in the binary translator to
track application writes. During development, we encountered this bug.
The translator cannot control where the translated application chooses
to map its
memory and if the app requires a low-address area, UFFD fails, whereas
mprotect would work just fine. I believe this is a genuine logic bug rather=
 than
an improvement, and I would appreciate including the fix in stable.

