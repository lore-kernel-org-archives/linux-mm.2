Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 971F060A261A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ZcYSNki/
Received: by kanga.kvack.org (Postfix)
	id A90F06B05E2; Tue, 10 Nov 2026 00:09:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61836B05E3; Tue, 10 Nov 2026 00:09:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977956B05E4; Tue, 10 Nov 2026 00:09:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD1B6B05E2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:09:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4A9F14050E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:09:48 +0000 (UTC)
X-FDA: 85418032056.20.FF89AAB
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 111911C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:09:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="ZcYSNki/";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794287387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nI/EA+STEPCGq9S2NlF86HxTqJD0H0ath9HnAszLms=;
	b=1VNOojsVLMctKlzrhpWOeUzO8RXgRQk3mwpYJzPSdcesB9za03bg0Z51LMPjFPKJP36+5G
	pAk9se6vUA9LxUQ4U1Ki5z/HVPmTHeD2/4w2MPqYei+2iLUuZLdh+X7buk2mpgvBbWW9DK
	rHBw0Q1P5LyQNC2eBxVucnA0GH2s7M0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794287387;
	b=YiihHc0LPMJ3qWIGFmy8xgwsmACQw6z0xZE+ePmWtGGgq28YQoq8vPbULBZ9vP6qFWCZWp
	edmRIlYWYAsy+lTdA1RwIrhwa8fSJC2/4sjeanXUJL9nrUSYT0KqyZbLHTgadXIGoufVn9
	U6m5zsssxopncY1yeTqk6dLsfd1/HNc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="ZcYSNki/";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8b612fd74e1so570618b3a.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794287386; x=1794892186; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9nI/EA+STEPCGq9S2NlF86HxTqJD0H0ath9HnAszLms=;
        b=ZcYSNki/7/4SzGvBdPxOSGmMpA8vjdNBjunTr/r6ENxqDWkIz9DMz0eaVkynbIqDh9
         NHJifNZZepOHsxfPLzEW2g6GVM0CRFP+omOZaVRPYUJ6JXBzGjisInm1KidK3rGrjOfH
         aD8AZgakOA1OM+7yOzfKZfay5DVlESc4DP754=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794287386; x=1794892186;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9nI/EA+STEPCGq9S2NlF86HxTqJD0H0ath9HnAszLms=;
        b=KTHSUtoXXDahseAZDOO6s5WKcFcYPjvW2ELT+PCORAHBGtCxV6jgpEl6hE2WniOSsn
         +zQ7WYlFoTjjmP+xWbvtnPNFM6trZWOdbRuB8wqbh1JMpu8q2Y2IVKs04QZMP3vlaNRS
         Xtw/wQrvGflIik1GChNUVY+n7+GJveQ3DFzWaFXXVbZfumwApdFl+qJsPEu/W31OdayI
         4n9lYN8V0rUHa3jwVNNz0yCtFNWhbbZo+TAjIwTLp+FfbN6rCuzcE5++fiamu1PRENLI
         JSQKrDlfqmXA91xULEi6DKleSfPrYgC2kT+c3E4AeSXC57ahjwuP9EG8uTj9pnbwKwes
         OsBQ==
X-Forwarded-Encrypted: i=1; AL+hErElfzWgdSCppy40mi3hJpuyG9fLS39QvfBL98s2TW1ZuIl0GeIEk6FaixrDWuN+XluVVSLxxMlRwQ==@kvack.org
X-Gm-Message-State: APuU4Z9NIHo3Y1CK8yHN6EQOWtXqIEuMhWQCzzi6e9WGoEXO55VU06m4
	4ZxuRTR+X1ZSed+M2PyQN+9vvl2XlKtpBe6qV1uwqspkch1cOlt3+6mYEuqRNVXi5g==
X-Gm-Gg: AYBFou3IMhUwqWAkF15uX/VC5rIm7/gkXaA6wiFbxGn+XN0p2EtFWNCYibBg2pcXjwR
	nj1hCGYNDr6Kxv/kkZ05Co/MBdeSRi349ah6kfUQ+DE62zogCw/7E97Ncw5syMfJGOfnf6IF8IN
	YTj6cpR+4b0KWfUEByfPsd7sSNU66mUQXhcF22nd8xv5oq+O7asMkmgBch/+KoLghtT/upZM5xW
	hrdRRRUJEfOdvGWPEYvxZGgeFCjQBObEwNKZEUaJGUaDgCzLF167TM0d+kQXm1zNdqVuY3daumE
	Xx7gjqtVxVlQh/QtYlzbxaZkArJ5Pi9C5ikJRV7adELTL95MtNc9vz+eKe/Asua1Gl8Nz1c+ggi
	BuZGGDqsvhDY1HoaEAI/IuRlCuil2E4mpWhUrD/eM0adR8/41/7PoXVAKLR9DJgvht/Qo/maVDk
	XIGR6r5imL/W1HAZ4PsK7gO2IYHCkvLG8x/voDEq9O/95tLgbvqnCBoPI/3JIUJEJr/RsrHRssn
	6xPR8prFC3/UjVoPttaxFqkM34uBZjruGtgdEDYznNqi9kBS7iimSizqSwfsq3m61D058LAc/bt
	CfmGsu39jN+4vF4s8itA6GXepSb01uTm+w4B0zT53fpVD2U2++4/MiSILWkXBQbv4MCJgw==
X-Received: by 2002:a05:6a00:3692:b0:880:849d:c07c with SMTP id d2e1a72fcca58-8ba8590318fmr1720593b3a.25.1794287385925;
        Mon, 09 Nov 2026 21:09:45 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fc2b5sm384573b3a.50.2026.11.09.21.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:09:45 -0800 (PST)
Date: Tue, 10 Nov 2026 14:09:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 6/7] zsmalloc: fold zs_obj_write() into zs_store()
Message-ID: <avKkvXNesmBRORnn@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-7-senozhatsky@chromium.org>
 <auy6wQIz89NxpskT@google.com>
 <avKFDz0PGwkbwNgz@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avKFDz0PGwkbwNgz@google.com>
X-Stat-Signature: 4kr1deajmfztd4mbut46g4uh3e3mfowm
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 111911C0006
X-HE-Tag: 1794287386-656636
X-HE-Meta: U2FsdGVkX1/HEcO0nLRiCbVurUsCLyshfmPb4uNvsMuL3GugFnJ+v/L4eXG/H8H+u597uz+xFGsbeF6/XEZ/Wki/6lvePcz2NZ9ujRb0ZtIo1GSKgzdkgxGzhMrJO0oMUlbHfANw11fTqfQ2YGv9BKItQhz20H18m+SsxKIMloKfUPDOhHFIH/HKpCPbidX+xUSDfbbikKUVKwtYHiAOiqMBseasudaPa6Tq1NP7cjUemAD096zftiBA/mSoQnPtyH21N9LK9LaTraR/L2lKRT+KmhkHxK+oPtfFscwXb+x5t7uO3uqVVp+hv52vCpuDGsYjMDdNnaa2BirfR5LvZ8H1g/+7Alq3G3IEVqTviNdEdEI1IfZOqnHOxsxWH1M7U+YgRDPKvrD12VmnpZH/eKiUav0xQ2r6nGvFJL6U2+GcKNXs1x7wTQnURc872upPiq7ETV5wD+9TbN7a/9p7BrlYSTxzmzmhQ1nK4HnOpIH0+DA0nexFD/7FMgC6N7uP2OQ6nFEQ5U875QOxV2Uh/pBMis2INPeMw1H2s8d5uQGw3dkVfZlcy9VRoJjGRbS1afzPkJKG9k9WpEQLSVgg4JXst/VWF77+BAYwagVh/c4f8RaTA1nsqUzQjbSwpRoj69XOMedeQOR0pjh43SOJfkOlZjoUHiYBhRfJXR893UHc07bkmFnikJ1iZ2/4kcfj/kiftVfm1ROXtXxKdFxoWUWKhkWMQcbSdWifjiGzayDgv5faTEfG+lu4QetoHulEqr66i2f+7AkFEyxlRlKkMpjwShM/VlisFupOzFdMvB/3yb4DaBeOYsZl2osxhvoMLMqe1/MlFoUwbO1Xek+5VLsHdokSdO2UAxkRoEX4WhOt7KxIv64sSYsfKLMF6Ti9sFaWDZ/GT3gDt5NbCBWfSDmY5O9h66T+YVZDTs12ZjMpKhx5fWudLxeR+oh8AAt5M78ZrZq04mX8Gs6OEVJ
 fdln3nWN
 4p69slhL/OavSD4z4irrS8xz5qv1kIwCCPDz1kxNlY/d78DzX/NfykVNyYsBFQ/VDuTFbIe8FX2fcsn0p5wc1tVYpzFVTovpjOW14ysqPHWncv8tx0lgduuUh+PhX1wRY7B3LLDqzj6LUefxVnc+bE1RVnWo75vfrfFujorZJ533X9Nb+Sr5AH7NTfk+grZOnwYnPEYN9G4M+76UMyUaPAaFQZA7g0lQq/6B1xvLG8W+lM1SX1EZK9QtgukCEndcNm9RkA99hJtwPvQ2IkCkUwjoMh1kk81oDMev9r7gEpRXmvYsk4ADrNWZoRsoRruG0tgsB7kNn8JNFXLTUEeIdNkA9JZHZv22ZndfPNdjLXKhr7X6xgqY7i1EhtavefZsP6RTQpwiAJtuQiV/Hyy7N4W4Ouw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/10 11:45), Sergey Senozhatsky wrote:
[..]
> > >  	spin_unlock(&class->lock);
> > > @@ -1332,8 +1324,14 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
> > >  	if (!zspage)
> > >  		return -ENOMEM;
> > >  
> > > +	/*
> > > +	 * New zspage is not in class->fullness_list or movable yet, so we
> > > +	 * can allocate the object and copy data before taking class->lock.
> > > +	 */
> > > +	obj = obj_malloc(pool, zspage, handle);
> > > +	obj_write(class, zspage, obj, src, size);
> > > +
> > >  	spin_lock(&class->lock);
> > > -	obj_malloc(pool, zspage, handle);
> > 
> > Should moving obj_malloc() and obj_write() outside class->lock (and
> > skipping zspage_read_lock()) for new zspages be split into a separate
> > patch on top? AFAICT, it's a separate change from merging the
> > interfaces.
> 
> Let me take a look.

I like the idea.  At first it looked like we might have a tiny corner
case is when N tasks attempt to allocate in the same size class, that
has zero empty zspages, which now potentially can result in N fresh
zspages added to the size class, each having one object allocated.
But the reality is that master does that already, so nothing new.

Maybe something to look into separately.

