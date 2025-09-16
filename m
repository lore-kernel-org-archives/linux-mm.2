Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF835CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 14:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5A78E001A; Tue, 16 Sep 2025 10:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066C78E0002; Tue, 16 Sep 2025 10:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97748E001A; Tue, 16 Sep 2025 10:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D74CE8E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:48:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BFF714010A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:48:26 +0000 (UTC)
X-FDA: 83895394212.07.A459A43
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id F3C3818000F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:48:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="FbPB/DtY";
	spf=pass (imf16.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758034104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVZwGM2kQ+dTf3qymb4/UXYDidrDW8MkjkFA0wkc4ag=;
	b=vhThB6fUziRTJ6et/y1ipGFuP33Yss33jkFXYLxP7gL+3ZNFECvoJgcZe5sn1Kfn24WNqd
	iEWMTSxsLqN5RE9P2EcAALcBDPDnf6prQCi+PcAstsrO5YvS82ZrWsBmsNY5a4gt5O+fZe
	FevwFAwjFfoqsGAA8KvSMPhHne3rmKg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="FbPB/DtY";
	spf=pass (imf16.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758034104; a=rsa-sha256;
	cv=none;
	b=7tD2m1qk9IthYuCrRnG7nx50eEDA5Dvm1pFqaqTaG4CgsGKwiDT94/ykX5dvUdKpnyD6Xs
	ng1bzPkg0GoCt7wgP4Jwc3NaXM9oLecU9P1t2xzF160Em5cC3NQcOgN3IOJ0rKbWNWI6FT
	oyqukrwhrzlUQONTIhNiCoyW4Bmgt74=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758034103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nVZwGM2kQ+dTf3qymb4/UXYDidrDW8MkjkFA0wkc4ag=;
	b=FbPB/DtYtEcEQEHAI4cnRzEP6/cxAku8U0fAb93tkHS9f4Y+o+S7jNXKbfeHqA33STzSmr
	a3dduvQUYcxXOQTAmveOyG0ha+JpctTgk17FAGp0H8ABHL25O/JIQM0WPCE3O8jhZgnd9D
	3CcSuRhk7rm1fxDAw0Oep52/uqi9/6Q=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-Q2ulD6cSMISfWECts60GFw-1; Tue, 16 Sep 2025 10:48:22 -0400
X-MC-Unique: Q2ulD6cSMISfWECts60GFw-1
X-Mimecast-MFC-AGG-ID: Q2ulD6cSMISfWECts60GFw_1758034101
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-77c23fc66b7so44304926d6.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:48:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758034101; x=1758638901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nVZwGM2kQ+dTf3qymb4/UXYDidrDW8MkjkFA0wkc4ag=;
        b=Q4atXaVawrTuz4Swj8pxbH/b1JwjcaMgeHSObEz3PPzSTX8it+l/PRx81PGGmtCg1l
         Sn8++6DV3nxXW9fC5akNPh9D80RTEn2XFvs084aMhX6oY9jVkFj8gbeRJYxLCN9LPo8I
         h25bed1X6wvfqyzqoeqXga/lNEB1DInf5DeWCIHZrwYnYFvp0g7UfAy80ZFixMsijDzF
         yW3RWglD8Ctb03/A+2GbLQn+Du5dENm1aX2PPyqtsLY0EkPHQJeMDXn7h2Glcw7qqAdK
         gAvMpauew8MV106TbS1VSJWfFt0ALCzC2TGYkVomrIn4rIYrJ6dXcLgfibF5ccw3avXz
         57Sg==
X-Forwarded-Encrypted: i=1; AJvYcCXb0Mh0+JJN1Pta6DRrRzqjd462he023R+AuCaCih+XGq0Nto/3ufdaPUhEXDgyV3Wk+UC3p645uQ==@kvack.org
X-Gm-Message-State: AOJu0YwVDpHTby6CwkG+Bxh6Zr8Pq2BOI4Qb9JTNWwhOWXzLOtmljuFD
	ITlap7BsYxc0JVL8kiis6DAX/cfTnEkVxD/w8IRuliUf2qaTrm7GgkJHImlH4tEH4EXOZ7uhSH7
	GelHxWnPFHgmOrQZyY9XQQMb/qhZOMN3sXR1v6Mi0DosW8WHETc1Q
X-Gm-Gg: ASbGncuxkw5W8EkIlUOkPHbK1z+YFknMcqJugWTGVvvuYaunQo35F+Eo9BTHAvjTWr1
	/hV2AhfiYFRyqBoRbbFANv9EeV5FXlqhlSLl/bBiYkjJZsOQ3cYahsaEeMp+hEB/vFALiqACLx+
	PrXlpzk8yiYhKwx5FiQMca5APzGJhsti6/8V3Bl/9aQDATNQLLbqJlKQp/rvCGg0QgiGyHyodXg
	cBgOFd0T8XpRZA9OorRk0FHCfHOyYnMeOaVbc0jOCrlbSbiGu2VEHW9Sen8vBHZKR0zqAx31FJX
	xd1qLBLa48dQn79TugdkHC3003rH8R4L
X-Received: by 2002:ad4:5ca2:0:b0:783:cc80:1789 with SMTP id 6a1803df08f44-783cc801b17mr93928506d6.55.1758034101282;
        Tue, 16 Sep 2025 07:48:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaxxNPXBi8aH+mYiozA0EIR8Jyut0MXRPkfuzwr52qqWSVlNDLz3Qg9j1ZZbsX91Bjg1v0NQ==
X-Received: by 2002:ad4:5ca2:0:b0:783:cc80:1789 with SMTP id 6a1803df08f44-783cc801b17mr93928076d6.55.1758034100731;
        Tue, 16 Sep 2025 07:48:20 -0700 (PDT)
Received: from x1.local ([174.89.135.121])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-78d971f79casm8947126d6.56.2025.09.16.07.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:48:19 -0700 (PDT)
Date: Tue, 16 Sep 2025 10:48:08 -0400
From: Peter Xu <peterx@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: "David P. Reed" <dpreed@deepplum.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range
 fails
Message-ID: <aMl4qLyNovWHhty9@x1.local>
References: <1757967196.153116687@apps.rackspace.com>
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com>
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KC6Z4W-V9dhzoptY9gqo1C9Gb6hm7ANLA1wjuF20jqY_1758034101
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: jyoie5cxjesz9yqig4gxkdc9ijch9ixx
X-Rspam-User: 
X-Rspamd-Queue-Id: F3C3818000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1758034103-411377
X-HE-Meta: U2FsdGVkX19FKvJEOx5SuqDtYPJiinY1CsnNuLh5oA1o9cDN390QI3O4aAGv5eGKqMfyY4z/1YK0QsEVBtpyqwqIe1I4nLsNpfFz7N+x1D/SUGgRFMDYbrYDckARTDsovWdHgNF8amdrdhZ8463qKbGCue5l+ptpJlTv/1O5LCdX0fWtNjcxJbBIWlODawwSLmWLx+uMzEEpFAa9jpbrYSXXhYVIKpYNcHrvvUn1qzDKCDZkkIQKL20cTe+0qCjL+RdASYN2AKyQ69yPvFEh4UB5ICk3WvbF+JmQjF0yKqY5HKpVVtl6bcFg/a7nZ/gKJ2Pxftoky8IR/W0FsSMu73dD/rSM0CHY61n/Ib5t5/Sz5gT4IrKgHrCW8q7vYeEP1yrjZNcikVti4bEPdYI8LZy8um/MAACSG/v7M202tAzdHOyTC/xVdj0BPR+iYf44yZWSPux3fXrmEs8qN0CMFd8IzY0wectyLGAzCpvhjY57Vmi/FJhNJ+V/pIsBkliTjLFLDs0ecRAGcS5nc6rupfeI/RsQdJOH0SB4Njf/cVQwg6nzrJ4h/Jr1bebqk2ajBz30bB7IllrBTAJ9kSKCf/L+7fE16b6ArVYXzthYQOMz306NqxJ60Spl/Fhynzmt+cszDo90/op7FVZiIFWutM3pVP+xIkdD4UYlh+1J0V76kk6SCa+inFO2MmGRSovLlfxYMzHWjAS0LAwUYa3zDzx9x54e1hvA9kSZRp00oEXDXjH4WuIzVl7/llREd8QevT2wFDfB6J5oOe1AlvaqR9piYkl0VYa3PutJhztEqgGab/1xrbXDKm2GSv2wSDQ0N35kb9T3penxWK3qeZyF+VEro1/UidZIyCneD8DbMHnTEyLqD8R2JLnFff+9gMHTZgbJ1SQBvpyltvK7i42l8bcznYU4gG4/6YtxpowkMELys/10ooRYQLUX2cWTv7pJ6FC0CLzVgXlIeL1lewg
 odPewOB3
 BnsGU+p8izpRmrSyOA6iGpCjBwbb8IPS4SZpnzuJ0OK4syCObhtgWG+LV4qJ3x9TZd842xt8RcCr8D8n7dkP9CfpsUPKdhi1ZDc84skGxymP1JIJL160XsHZZ/5K9yoOCungs4Flw6m/wne/M3BTy8+263qmx92I/QdCMI9lsEmLYBi7fVzBtnOLbChsJlUqWvdqj34LCnkne4/cFZzu811obE6sLmClOtVEo0cigAGM39rrlaTXdQrTVe9UelKX/Rd8p/pC93PoRniiF9K05ctBPEOeu73LIvlXG7ZN6NMt1AmilEcju41CGXOS0KCQys47Tfyyb1goYJpyKhk3warS70Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 05:31:51PM -0700, James Houghton wrote:
> I still don't have a solid grasp of what your use case is.

David, are you trying to provide a synchronous trap for an anon swapin
event?  Say, you want to be able to stop a thread from swapping in anything
from disk (or swap cache), do something, and UFFDIO_CONTINUE to kick it off
again?

That might make some sense when trying to match what MINOR mode means
v.s. the mm's minor faults, but some explanation of why you wanted to do
that would be helpful.  I agree with James that it was at least not the
intention when userfaultfd MINOR trap was introduced.

The other thing to mention is, AFAIU userfaultfd's major use case is not
through a fork(), even though it should work..  In many cases, userfaultfd
is used within a process, with a dedicated thread resolving faults. When
it's used across processes, fork() should work but UFFD_FEATURE_EVENT_FORK
is required, or otherwise via SCM_RIGHTS.  For the latter, the tracee needs
to not only share the uffd object, but tell the tracer explicitly about the
memory layout, because those addresses in the events will be reported in
tracee's mm address space.

Thanks,

-- 
Peter Xu


