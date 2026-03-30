Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A81F10D14AA
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7FD6B0095; Mon, 30 Mar 2026 08:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF8A6B0096; Mon, 30 Mar 2026 08:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C7A6B0098; Mon, 30 Mar 2026 08:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2B436B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:27:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29AFCBB08C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:27:29 +0000 (UTC)
X-FDA: 84602655018.08.C3ED5C0
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 26A6240007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:27:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fP8Qa9pK;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774873647; a=rsa-sha256;
	cv=none;
	b=Qad6umnlYE5LUx0EPDXTaIxTqDHpastCXft0O/gY709AA8bznRGhCcCwn0vFRrFJ/HWhsC
	MeDjLw5byFzZmf/ZkQc8paqHwxi9AopHz/ORoLY8DfuFZOtScsppm9RuSCWZGuZDJOmr9n
	doDr7TQlqr+qcQHkk3im1Ctx8a5yyZU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774873647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNFRwD93ezdvk32DPCCegnt+dt260d8Q+7V4aeXvIS8=;
	b=gQbE9He39MRGuDHsd/O+X3WJCRxQngSa+p/GQwrWPn46YbWUrBf7e8bipdKYnzqxi5v6Wb
	UyYy24vg4TWYVZp4mho7nQ4n5eFcgXu60Bx0cPOqIRv5j8ZYkVzshCmlIlQCyAL+BPhGeL
	zc7FQ9urcjIlDs6c2BdbE+7l4io7/BQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fP8Qa9pK;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-38be5e86918so38887881fa.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774873645; x=1775478445; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oNFRwD93ezdvk32DPCCegnt+dt260d8Q+7V4aeXvIS8=;
        b=fP8Qa9pKTmkv/j1sOG4d6Yjumc3Ho8cFcx8Nh8hkpZ7vF9+WqaSiTHElRQIWfYHAS9
         CB+5XQGIL6Htaxws7hfSwpLaftNgx8igAxwNEj4RkcnoNKaNJ31W/SVoYPfZiTlhbXth
         EWc90vzQ0GcAindoZyzahF06g6wIDiOF0kqTJdlaGIwLtHJDXBtY/c7ItStt1lbmDD+t
         YRz2c9pPaKBkbKq0WDceEbo4HTIuhRoCL73j2kvYNj9MOHufFHbk4y3uaKwED2PGxkOu
         7bT2lTFRTDddCei8/wydMjkSfLhfRVhhN2mT31T3XctQj2cqNr6ryMZG/8T0uohBeN6J
         enBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774873645; x=1775478445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oNFRwD93ezdvk32DPCCegnt+dt260d8Q+7V4aeXvIS8=;
        b=ROkH4WeIeB+k6TyD/jYg74JTm+6ZHIqm5/wRedQy0oIAu59JJt5kbXEdIg0ajFeE+W
         SWUe1PHAJNe59qkW66BZs6VIHouyIbGihMybKNM5/tDVRigPqqhf9+Tw+7m0RF9iN9Ju
         1N2WC5JglGR5oUvGwVIa2bOIQ8wFWfC9OepKKwvKzws6ahfBmxgA69bQrjWWHdlocEuN
         Y95MdNrykbYFIr6XYm/At/gXizGfnrLVYsO6HTTceP0sp6r2QvnqXPpfZpD9IatqmPSV
         V3F0BVMyE/RlEoE5CXPdiSs0kGlJmpwOG3YROxWUvjz6Tw3avsRafa5vIwcHSPDqwxxC
         /Meg==
X-Forwarded-Encrypted: i=1; AJvYcCWwVu89jXvY1Qj/P5aafyRHtom2BQIUUBu6gPK9K42NloknBG8VdY1Wwatn2N6wnSqOq03GjNioGw==@kvack.org
X-Gm-Message-State: AOJu0YwlR4/nroUh83Vxaruz53zvMz2HW6NTbFLrbzmc7+OxWJeVi8z4
	qm5auysmnJ+lkkwLUY4HOCVlIIdUSyloxXvp4KS032fuTEqMLpex/1G3u2VJSTfy
X-Gm-Gg: ATEYQzyvrrKf7zsdiMPa7ZOc6YTDAqZcq03/hfLLLnI9dRGKiuhlA9pdJE+lnunD2nt
	mnzN2+TxRaB41w/XSMdf7TCGNjtFZSwCDzJObdS+UegV9LeWIcslbQQjmTyGVPF3tPdVMK4BmV4
	VOXe/BbwbPD0NbVX8SJNqN0GJ+cG0Vo2x7Ufvx6ERVva5W6Xv7JDk0H7ImE+753hTEOjN4lDwzJ
	QiYBPRlK2YW4ncBydHVvE/L6e3KJFCsOTtDoZQ8L0PtzBg1KvAh/qpIgvG5qrxsEIACFQn9QDA/
	jy6qUtHNuYACL1FKkJJA/O61cEkd8Lb/hN6HpH6Z6hEwHXhaYCE0T2tVA0bhBo4T1BvFqoUeWQh
	tQxTlbitmVr55bcrv8GwPb2po3QkQEgzJvu0fvKiX7/tzm40VGMzKyuz3Lzb7hHWt
X-Received: by 2002:a05:651c:12c8:b0:38b:cd7e:3fb6 with SMTP id 38308e7fff4ca-38c7326630fmr40959821fa.21.1774873644865;
        Mon, 30 Mar 2026 05:27:24 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c8389202asm14847641fa.24.2026.03.30.05.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 05:27:24 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 30 Mar 2026 14:27:22 +0200
To: Alice Ryhl <aliceryhl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, shivamkalra98@zohomail.in,
	Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v8 0/6] mm/vmalloc: free unused pages on vrealloc() shrink
Message-ID: <acpsKv-GmaYj2Bmx@milan>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
 <20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org>
 <acou2CsZOUQPx5nW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acou2CsZOUQPx5nW@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 26A6240007
X-Stat-Signature: brecqi19kaoke1xh5jkunne37w6a57xd
X-HE-Tag: 1774873646-135143
X-HE-Meta: U2FsdGVkX18k55O3w31OATVRorBDa8SZ+aNGMoQQsw3duIbf72m4Vp/JrKIwgR0fieQg+KrIqL4th+LF7dqi1cySPMXBTQ1ZSik55DMv+sQr0BZH7W6EeKRL0mtGReS4D0T5k88uNmG3YHUYsvGf5Kg3B+MjyTzME60rArCie/UEEknQRQLFvyLQvywpYRCPOtTRQBWnRjGcMmbaBzPMCzXf9eTgIsE/VKJz7hbsu58kyxb7T619nZWsHi6LAqHoQ/lLXLHi2TrQpAXTJS5+NjelkdVGr3oNwl6sTEvnDDs+0ga55bw+cvSjvKQ4DITT4T/hDjd3eiBp6nrZ0ODgHfqNN2I29BA2ogiebewMDHidl2pdJB6qaMM/ug2gEWsI1Ip4CciX7LvMflhN2qleR8KuKHZ6ajrJJLcSsk3mENo+mxd01YIc0VWsWXJuf4/Aj0CLHIco9ZUHKlYiPSVuPLPY1PpEiNL8W+4mGKTCtu80kzGlEIcaRjyuLjOjnl3uLc0RECm3WbrAQqr/RNpNJhOJ0LTocbJosuaSszR8LHd0Ci5bQfZ+Iejo2teq+w9abCN0+myejQOvtCi20sKYdT57E+/1lHILhSLfwKaBqditta1xFBal6IpXA5yRWbNv2nj81sHyGs2tuLFabzhvlZVysiOQrA5wyM7ku8u2hJb/T4C+6bHF9fv+QEC/9TlbGgmbdruTMByE3fopinko/TCn4AW0T4rzRJCdZmJRoaVsGxA0lNHVIOvzjVulI7DzF91GAgA5EFoQ3unCay98l+VVt9dxCuDNgC5KDOO9PvVFBsB34iJ1ke5UYYmQxK2Qe6NcWcsQlj6QoI6W4j/PwD/cFbE+RE2OZTYfAsH8I+Aze7GEnbRzBDL1mfJxBc/lQcIv1uTRphBD5X9D5YF12LakDAx+hJIkk6z/q+AOyfuke2QKIUR6SbkKALpDTb39REYgKR5sYcqG2nb+A3D
 SQ86kJvl
 i6dJYMg7yBXWCr6p9TO0FnbUTOJnrQp31O6l42eY+km/Ixll7LyLIpPmcFeDy4AjkrFPntW83GxdPtXwNwTFWjPDs51POltERNL6pyc7qDUuWJPusKry1uJX94fYJ45UNEF3dpQTOninO8gO4DTanLrU72Gyp7UxO+1J4zqHVe1aO5rb3EYM8Whb2ikJOyvjdbyBh6suE5MPibKO+T+hxfGWjAgSEt9ONmpFnRwyrY3qr/+rTW51+zS7L17Tmfbpv3HX6H/wMFIkZ8ZP0aZpZVacgvZLSqtZsreDKvN94VBq3lXnZPzvxFwHcIBfJ5i5i9wGcSUn9iVh7/VfQ0I6r9Ehg3OhSBQhd2sVprOqd5vOqInvloyGz51q52RlEKzdKx7Ut1ytQq4NyArm11oE4148hqay+7rzLDTOOMqwnolWjSNk+3ouza/f9V5Y2a6MsU1HSnmDJr5vtNY1Fu7MaoU2zcj9Fo+BE3+l63XmtdWBjUF3j+rNpLHfZgETXKQKx2aL3lvVrjfOokVGlCcRtnjumE1pCJZ0r6scQSmPVThIFMfNZzPbhQTbvF/oBNODca2DF0EyrFA7XgBQegfaVP/CWrwBMhNFEsiEfFzTBk+6AkkoQ8llCGORxjmi6LwggxLnob/6JHt4zCTP+5PUSyg5vJD/6YBQ5vgaP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 08:05:44AM +0000, Alice Ryhl wrote:
> On Fri, Mar 27, 2026 at 11:37:58AM -0700, Andrew Morton wrote:
> > On Fri, 27 Mar 2026 15:18:36 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
> > 
> > > This series implements the TODO in vrealloc() to unmap and free unused
> > > pages when shrinking across a page boundary.
> > 
> > Thanks.  I'd prefer to defer this until the next -rc cycle
> > (https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org).
> > If Ulad would prefer that we push ahead then OK.
> 
> That's fine. No rush from my side.
> 
> > Are we able to describe how much memory this change might save under
> > various scenarios?  If the savings are impressively large then that
> > would get attention.
> 
> The primary purpose of this is to ensure that this scenario is not
> possible:
> 
> * There is a global list in the Binder driver. It's an array allocated
>   using kvmalloc and resized on demand using kvrealloc.
> * A process decides to add a bajillion elements to that global list.
> * The process exits, taking its entries with it.
> * The global list now remains extremely large for no good reason.
> 
> I don't know if it would save a significant amount of memory for
> well-behaved programs.
> 
> Alice
Agree, let's postpone this, so i have a chance to check it one more
time even though it seems ready.

--
Uladzislau Rezki

