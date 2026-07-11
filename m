Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518BBC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 03:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC5B6B0005; Fri, 10 Jul 2026 23:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5BE36B0088; Fri, 10 Jul 2026 23:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B2E6B0092; Fri, 10 Jul 2026 23:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78C5C6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:19:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC2D59080D
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:19:54 +0000 (UTC)
X-FDA: 84975041508.30.3B9600D
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32070180002
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:19:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nUi3UwXP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783739993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYTaMzfdKXyQ96IWRR1Bd78qVpBo65z/nucHslKEHMk=;
	b=dkjfKh3HmEfKm9j2AToiejDRVgVaqRgpjtFJBoRpXw9XVANMVNCCQWU5FrfhO+UWZkq6F1
	vaG10lKEyZk5S54ErCFNCfpNt8tqGP7vOlWVM5WzsjezG2wCmQcFcovjypdGFgiZYJKCeQ
	5N08xQNE8yDAtn/4hale8JwuNSsaXQM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nUi3UwXP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783739993;
	b=kOfzFHkZnGprPM1qa+SrxW3fYq/dY+h1wMbjpbNDX0IOnl/3rynPPqUg3CCpw9NUr7BOrN
	rMNaHr0x/JtzBfMCrOYZt07orDPQI3+6A6rT2sGT1W93PPsF/S8seL6djp6A3vriCrO0+e
	w4lTmq7ahHzWPQAzKM3pQk5d6ONRLcQ=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ca64c3ce5fso18530455ad.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783739992; x=1784344792; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CYTaMzfdKXyQ96IWRR1Bd78qVpBo65z/nucHslKEHMk=;
        b=nUi3UwXPLjGaDnr6gmgnZ4HHthMchNdGcKhimYvImI5m4MH3I/v4mudDU8F+YVa6yu
         h6w1CSfR27i1GuwyD2etdMg8xPljJ0po2z2dtHoRqehJ+WEHHeTextlCT6em+72CPalw
         O3cX/iikK6CP6FMSngY7RfQmKFiTDO21t2IENSS4GLruPZdLyzXPhV6Abb/Xp8pST08f
         lKYLWzlvWRzwfi46SGgNxJ2sjmt5bxFmijCg4DfUKHhwcPomJf0h+PG4bb6Cr+Dmb2sI
         kxR6YNt12O+MaHSCRNBeIivuEE1VsZEqtL8snhkgEHAMZ73AXLAU5yqLo1K/C+AgrNGz
         BRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783739992; x=1784344792;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CYTaMzfdKXyQ96IWRR1Bd78qVpBo65z/nucHslKEHMk=;
        b=ToHn4w5Gnp0+fHeq0i3UiIAPkbtzj7+nb6W7bWtA2iDUvN4XW07pteoyQ9Cz9ihTkM
         GWpw30TqZKFfPX3iphRxQ3RkqaO2Yi0kMLDBESOj3Xmx6VU5LY05mBsECB/xMn5USa1o
         C/cSzmi/Ucy/cgCCrLO/5zacUSgPswGewkmoLxZedcMjdofgGRC8iJunEaQKcH9zUvzK
         XMzRkPNEchzgwg3fLDDaboWJy4ryChgJY6/TyX1bPJJg5ElijMQMZQEPAT6WGQQJv+zs
         0F5Ii95KVBPAifawlQRxTpfVllQlFBzXGHOLhFudLsfvNro0BrwvWo2vRyNU+WSSe0UG
         qYbg==
X-Forwarded-Encrypted: i=1; AHgh+RpfulAXqwe/ChCyC6KJ6w6yOiJqrwktoTc+nzQ7VnecJEqJ6NkAv5csiHK7nwjuR6DEwauHP+JcKg==@kvack.org
X-Gm-Message-State: AOJu0YxvKu89yfCIW2u0AeIVP3OI4iCcxnVDpJ2h1c8f0uPNsIRUTK5R
	xYp4OYKSigNGznnhFSvWHWNGUmSBTrf0BZYtEivVCnVocRQGkWyX6tLz
X-Gm-Gg: AfdE7ckQ8NXchUB4xbRSYZkCQ1lgdAbev8pDqYiC3gP051XUG6b9RAtDUdKYEpD5U/O
	Q0EbXE5GTgUYtabPlbjqivfiA/upDvDp+oxUFn/0f1kYATujE5WbFrjvA7g+9hhFagrA1FgkLt5
	v6+IctUrHr8J1y5ToBPQZWUnDtO5SrGYrspW8ScImiuKD/9P/zhQo51S+XYZwHugZfcGK3gZBDi
	/6KLSdXbngQeB5Tr2A0GNpOronD/xQ7iCv1iUu4TNWhtkrmOEwmOTmdSfdzojWzyAGZUl/sraIm
	AlkGXUPCD/Gbwwl95fKW2LZqev0AFVpGBxUZ/nQ6U9O+806wUyXBYME4Fpu6P9v4KyZWzSDeR01
	um0aDGafRMGJNJiUE1Zp+WaOy2uBgvupccOkbMcGc+8FF3A4XtyswPa4LxNmxoRC1v0oTMPxFhw
	YIHBwAf3b4slcLB5zS6aUSyvM5aJuokZnuchGRoQ3W8H+9rAS8Q58abwA=
X-Received: by 2002:a17:902:d2ca:b0:2c9:97a8:8c1b with SMTP id d9443c01a7336-2ce9f2948camr16114365ad.46.1783739992132;
        Fri, 10 Jul 2026 20:19:52 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d5bdddsm67571165ad.77.2026.07.10.20.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 20:19:51 -0700 (PDT)
Date: Fri, 10 Jul 2026 20:19:42 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
	dakr@kernel.org, david@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 7/8] accel/amdxdna: Use
 hmm_range_fault_unlocked_timeout() for range population
Message-ID: <alG2TldWdL8Ez8Dq@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <178371883276.900500.12789147320642521200.stgit@skinsburskii>
 <20260710151228.ca22e127b93ec5c6d591fb5f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710151228.ca22e127b93ec5c6d591fb5f@linux-foundation.org>
X-Rspamd-Queue-Id: 32070180002
X-Stat-Signature: zpsnxjudy9mndey4pt6cobixek816hjx
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783739993-378086
X-HE-Meta: U2FsdGVkX1+vnRkzuMDFe8c2PJGgdkxgWawpqYIduxTGKA/xUQ3ojny//VCZsTuJ7+C1LOoKR6d8QRm246qPSFyOAuC6lDjMMBdlcovAy5voWSVxNq4F0A6/Bu2wZri8giMl3JKO4fDiaKS4Mc4+pwZb5VsTJLtncwfq4K8aNIDUSt5nB9OTdpPVuJ3JKgFUK/mEjZ9Qtv766nN7PLRyg18a9xgWmNUPtczWfpKfR9Wo5u92FzUPsYcSzuh+SGi5+jQbQLiZKKQ8S6NJXBziHuaZZJ5xLURQkzPfGxrLZEWNELlEEG4U+0DfMGdgAZBiKNSsw0qndW0TBjTRddp5ljfqcK4NB1pKfe2Tn5hmysqUzGX34d71lbbT3ogaUZpug0Ln1bqSxw+c9/zAoe2W/UkGF7E4ryI2ixyBg9NYFhNfzDIDOsSevxRf8PwF8k0LudlUXeO99rg95NlEC8GgubHCf6T51SaDfa5zODOsQCVZw7gQhggXNMnTIkyrJ1RBC5J5M5J6Ie3Fq/rF0nw6VEYiIgemY6/NZjgQpD8z7+hQTFRO+vxtB5ehAWU4f8dKIQv1jSodL78tJ/0nGMLCv+MyipRt/6taiQJ5j5CYSrZIYVOJ/k0qQ7G7EL2+mIY75mdVO5SvWLpX2slsFbNEXTSQdPTNFCi0UyT0H5N8fl/S8+xdPYV0niqe3AmYS45kDUvl2Xp1oGGMj3lqqr2+ENUej837NIGTS6pTF9LJeH+1/569ZJDH0ZEZZJMtV5aTkOlz0vZn20yEVEGYaBSWOvHHnMRWzT5cPE14rTMwL/3kEHEpIWnRTynGeISpa2XvuvF74QayOflzJOMhx5+kAO8jMy/6ICrCCPIHuqHKWxr2QcJ0f75uyRN88l/5NoX9Gm9CvR0AMCNATzRHV9yFKLIeuQtcc5/Whin7wrLTRO4cc3f6ty/Aq8Leae9Jct7j8FW2mqgbVbSQZmVlHtm
 fYwQgwlp
 W40/pVxOVLxEotRY/qsRb+4x76gqXr6WhtoLlatDKBeY2v4ud1FcRTRj5NAcZgVjYw472vDDONaZBLsikwlR9NOCohnFDzvGd7E96Po96OQxOKAVTya9eDiJffL4HPxXD/6i4soP//XQ8qtqHdN7r8hTzGBmLnd0QCA6Ld5Chmw1q2XnyafM9CTVmeKc7TVBkby+B3pdu7R9HSbAG8boo4Enmq6xP+aFuJVW7JVVNcbs5RCXOKMyGh0lxGAe8x1mOMd70BbX15Ht2BMWu/Up3VAAFtQQoMaZmB2SmNenFL5cbS1OwgoCcq3TfSeehzowmLobBO27jOJ57qk4ptEMHKQDFR58ml+vJP/L6McWCjwD4z2NImTL9umx2rcnmz8ZqPuMQHoRLG6BS/yUhsGB9aOPxwtKU4kg7UkkT7a+tBuT72X3umU74q4avUc23Q4vejojTWl6NcPYIw7MER5aH6Ug0OxdpEZif8UfOpSreeJ0GlYy+H9u5+yEnUFCIBS38yhYpBN7MJw6cyvWI/khynBqxZATrEM55McMUiMgUeXohsVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:12:28PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 14:27:12 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > --- a/drivers/accel/amdxdna/aie2_ctx.c
> > +++ b/drivers/accel/amdxdna/aie2_ctx.c
> > @@ -1061,22 +1061,11 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
> >  		return -EFAULT;
> >  	}
> >  
> > -	mapp->range.notifier_seq = mmu_interval_read_begin(&mapp->notifier);
> > -	mmap_read_lock(mm);
> > -	ret = hmm_range_fault(&mapp->range);
> > -	mmap_read_unlock(mm);
> > +	ret = hmm_range_fault_unlocked_timeout(&mapp->range,
> > +			max_t(long, timeout - jiffies, 1));
> 
> max(timeout - jiffies, 1UL)?

"ma" for sure, thank you.
I have the same quesitong here: will "max(timeout - jiffies, 1UL)"
handle negative "timeout - jiffies" values correctly?

Thanks,
Stanislav

