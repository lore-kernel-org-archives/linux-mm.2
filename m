Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A4FC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E807A6B0095; Mon, 28 Jul 2025 13:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57DA6B0096; Mon, 28 Jul 2025 13:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95636B0098; Mon, 28 Jul 2025 13:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C89C66B0095
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:55:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 496E7133AAA
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:55:56 +0000 (UTC)
X-FDA: 83714426712.10.61386AA
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5F910A0003
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:55:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ByTuySPE;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753725354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aobxU+eSgbfZ9X4crn912/FDn8oN2UrA+EAoV9ASOEk=;
	b=4pBUd7SWFvB/e3x2hL440mTsx02UhvdE/uaxtX6LpqY4dfiqoMgbtgdp0i5f1w5DT+D6v6
	1JNWiqDIjlJw6iMNij+AXpONPvn0XWRQTrwuP9QghxytLM1TWbtmB/CBD4Y1z3GKh2OzpT
	npAqfxN2aLy7AqyuD9VlE3oAPCpXkgc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ByTuySPE;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753725354; a=rsa-sha256;
	cv=none;
	b=nmKvak1LdIkj41y9zXJjqrp33G2xrC3MRshhSNA6hzWxIvNuLH7VnHppn2e02isVABdl92
	FoIXFYi00H19vKOhMjqjMeveYEUaTrxlmjQD/ffwmSi6/NKl4FM3Dkyxvf8nYm91rk3ZGr
	suWN0jlDRXMuItngSR7H/9rpjnz03vo=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4aeb2e06b82so9744501cf.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753725353; x=1754330153; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aobxU+eSgbfZ9X4crn912/FDn8oN2UrA+EAoV9ASOEk=;
        b=ByTuySPEtrP5jYqLElpl7yZhVEFf+K7VNsn1ph+T88MVN4v2553/w5izGXddzY6aZZ
         3JFA1LdzrjGF4asPqAQdsfAAeglF9Yzrve9p6rYjweKWH3GMIClyNAsfYxcqGHIyhGnt
         ajQo8BfSQavkLGG+2XLieNKF6A7paC5PCQBCdv3RvXkeuwRnQ5FI1KD2XUUzjg3UHlD2
         GwV1sji4JCKxJtOO9iwx6VUkYHUtDemDoF+2YoRXn9sHznWG1R4b3pMszAwMv6KHHKxp
         ksht6yhHv2emukKeKncR34wbWoFj6UPJP5tzv3HxEmptmxQBxLsVEAjd0I1yL1AmUnbt
         qc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725353; x=1754330153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aobxU+eSgbfZ9X4crn912/FDn8oN2UrA+EAoV9ASOEk=;
        b=WJdn2/gp1P7u68PoNG2O1z1+70jxjX6xjyJdn3A3Zq8AHg+dO9MxKNlYwjS6B5JUQs
         txXQ9PEIGGL1v5zwhji5axLJXHEzaRwHorls1zd+zrP5lcq8N1qtQY4XV/VzazoiObMM
         sgmL/ajkf2aostaIpipN2bqinNL7oGMm2AgVL3tGPcKhiTNgeyIv4bblLlS9hEWORvpW
         8xgFK8KgtfTGkl+zGFYecWksmav6PpJcnIBLXwtE2g81IZjm96spxyDuiSDCfFZYuz0j
         Tpc9cOcpmCSpd6n9Kj/Br9AWuVD4oc9fPVpjvmdWTXuxhDo5Pzo+hajMFckNFA1mLsZH
         vnQw==
X-Forwarded-Encrypted: i=1; AJvYcCXJ/2Z67V1hq3DOhyKsthESdINIAl/GiCmuCJJhGFwBa89FLkR0FUb03nFOoiEDB2jL0eG4f/3Acw==@kvack.org
X-Gm-Message-State: AOJu0YwdNt6eCzMV1SuPosFTYYFtiiZwhHBxzoJIvAOtCyOV6lP+jk8U
	iP7432croYZzspTdVyl+CG15HhcSmTntOJ/sua1UhwQsR6QkYZVy1CphUFy87COripmZ9eRawkg
	jerFv+pbIxKyB1+/mVTD1bLffjjaWafOZWQh/
X-Gm-Gg: ASbGncveNmnTZJVLBzLNL1/TyVyzn7Sukh9Krq3i+0Th+SMI0/zEqWeOU3GtAquAioN
	wcqyzXzN/vIew/JGxOx/2Wr3ZbMPJ6FHViBHIp/beifj+HWFdB2Qm9DtExB/YN5Ex0qVh6DUDvP
	xtVDfpLTqF+yW/CbDAGxQ4PU7qDfmDHUSRWMMLg5YO5dHLgakZBo1/9fkxUXGDXZolSw32rOJD4
	O/VsXY=
X-Google-Smtp-Source: AGHT+IFeHGuxtySi7CtxaGpGpFO7wyl1QhTknE5mS9v2TjN9AvzGwL7VxfaXPQJETF58ke+oTluka4/SUlAIU2Zvi+s=
X-Received: by 2002:ac8:594e:0:b0:4ab:ab99:4de with SMTP id
 d75a77b69052e-4ae8f065189mr200798841cf.26.1753725353322; Mon, 28 Jul 2025
 10:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs> <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
 <20250723212020.GY2672070@frogsfrogsfrogs> <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
 <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
 <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com> <aIe0ouF9tsuIO58_@casper.infradead.org>
In-Reply-To: <aIe0ouF9tsuIO58_@casper.infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 28 Jul 2025 10:55:42 -0700
X-Gm-Features: Ac12FXyI95ILYrO-ngDWtex6vWFELuWEcDgcFbDIGZdP_N1ojOFhNj_bSwihkWo
Message-ID: <CAJnrk1aXvVf7jaK9_2PamK5X+1b+crT+kmn8vktv0nxqCtcW8g@mail.gmail.com>
Subject: Re: next-20250721 arm64 16K and 64K page size WARNING fs fuse file.c
 at fuse_iomap_writeback_range
To: Matthew Wilcox <willy@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Naresh Kamboju <naresh.kamboju@linaro.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>, 
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>, 
	Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <liam.howlett@oracle.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F910A0003
X-Rspamd-Server: rspam06
X-Stat-Signature: 1tohy5azdnz1i7fswsx4eyhy4o8118it
X-HE-Tag: 1753725354-798606
X-HE-Meta: U2FsdGVkX1+NkrF1hUGwMJWUrBhiAXBBiEbjFh812vv06zoYuHYwdXBZY2wtNvYhda6zAdF+cvw0E86tIz7b77omJKTcD/eIwdp0y7B5TKgQF1TlNNb4Rq/lwSLdWKbcvpyq2mSqiApAqnE2L7yetatXkkK4tLkC3jRT8nlJsyV8gsR3E6wnaZFtSWPUilmAvh5uONqFYYp0P6VpuNdiacEQ45RsbmUd4GCytjeVvm37qNndkzVX+KGs3uWtHKIrbb1cqEXALx5ZL+IC5U26mSZc3+a871MhYoZNuXB7AliqhiMXtVUjiyb/a6/K8oE4swUc7RwjkfW8J/ou5wn5gwsN874vI39lBrWlQ20FqZuwQUgrDBVU5tXuVlqGmJ257WayGZqJ9Y6JJhjhBocMdD1/lqfgK9ajAzJ9CRMROiZt60sYjmd3xc1xob9f8RqA0Gm1iwj9EMMgzzJHVbrcJDIToDl0B7YfM3s4nwPW+jP8o2xpX35ahKTv8N6qrl5Vr31p1g9s6aYqil+F7aM9ZqRFWpYmnh3R/H0f/2kuRE2iiY3cQ9s/LUBPpJfnSR+piEk8QG3NVlZYOEl41muVaYkI8kbfbDCQTA7RrHMAU/oJ4AS2PgFjNtKifwxXmOAgjweuu8W4nONzQ44FObH3U/3t4xZ9npRkIahPcfgmf8+GmGTSnpYOR6PC+PsPuqvkJk5KSjLdZAAGPLkQ756X3/viTYWiVb+SRJ+3LxoMepz72k88X244u2cVE6vlJ0ESqXaoZIWtGtQ52+P/sHTHihTiIymPPCHUO9ZaKy5JS2a8lWhHBPzSoSK283OM3MdA59WmV8xW6F+0C/wDt7RNOj9G3p1l/BcycmR9ZDbn5RQkMpJ6R73EEsGSSZ3lxzE56Dbyq7YjqAdsWfHKImTGIAN8X6RuESjCs/nXbhRRa/G49bQQG30LEdGzc0uWVkSV635RRhlj/VnbDEKQbYC
 k7PkNL3A
 oRLDVTwXXrNzBv3lwmoLdOucyocHq0zQUkQ308bZG9YaCN6JSSKNgn2i7M63wwCAFGHmRHkQ8iZNAiX5+1s3lEV9Yftfvfj9tFssRhRz4k2yXMf5kESogpLpx+sdsKigdXf4GmP4lJYQCTav0ZNCa5nhWUhWOHTQ1JYhBwn9NPzrscWyKYElyVAZ/nZ6yeaYpQlF8/w73VdXgseZq4y1TNlZC55PMSSoWpHsIQ1vbacq1zFoOLauCNxSgePXlsZsUjZ0iyFBQsYjL5LTT4eyZnZ3j0gCm3Jg8GfeUes27b0qnGOYB+5f3u21sjjoqM80Ux9sw2UExwXqWR1/rycRU/2/S9vvCva71k0mQAxcqGf2uEGjuV/yTNzRA0MHvflxdgyIRGzadmnyPwLPQnZEvoyL7vFBQHQzFxwz4uxFZID9W0hVks1ahFSZMhoULM/ZvjflZl5y2iKRwpNMEy/7QMe2X53cNx2tTjmbFZiDR4mr5vG4INUKTxRIbQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 10:34=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Fri, Jul 25, 2025 at 06:16:15PM -0700, Joanne Koong wrote:
> > > > > > Also, I just noticed that apparently the blocksize can change
> > > > > > dynamically for an inode in fuse through getattr replies from t=
he
> > > > > > server (see fuse_change_attributes_common()). This is a problem=
 since
> > > > > > the iomap uses inode->i_blkbits for reading/writing to the bitm=
ap. I
> > > > > > think we will have to cache the inode blkbits in the iomap_foli=
o_state
> > > > > > struct unfortunately :( I'll think about this some more and sen=
d out a
> > > > > > patch for this.
>
> Does this actually happen in practice, once you've started _using_ the
> block device?  Rather than all this complicated stuff to invalidate the
> page cache based on the fuse server telling us something, maybe just
> declare the server to be misbehaving and shut the whole filesystem down?
>

I don't think this case is likely at all but I guess one scenario
where the server might want to change the block size midway through is
if they send the data to some network filesystem on the backend and if
that backend shuts down or is at full capacity for whatever reason and
they need to migrate to another backend that uses a different block
size then I guess this would be useful for that.

fuse currently does allow the block size to be changed dynamically so
I'm not sure if we can change that behavior without breaking backwards
compatibility.

