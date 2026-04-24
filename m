Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7CC0FE51F7
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 09:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED7E6B0005; Fri, 24 Apr 2026 05:43:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3866B008A; Fri, 24 Apr 2026 05:43:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98DBE6B008C; Fri, 24 Apr 2026 05:43:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 855456B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:43:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A1401206E5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:43:20 +0000 (UTC)
X-FDA: 84692961360.03.F85540E
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43C3B180006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:43:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ii9LCYhj;
	spf=pass (imf16.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777023798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9uqmyrQ8gLBUo18xHMn5xEIDMtFyh4GdfcnRwtOqeI8=;
	b=SJ+uKgCjTjUCIeLJNXoXInpRpM8Fua9aJIOytCoGBKE8ffVhJICR+/JP5cV6RHWRzDqZI7
	1xtK3Y9Lb6mNEumwVUjpT2/kd8Kf3EuFc7sp/4oS3DjB3nZe+NraKeuRGJxz0Pi+rRwMKo
	fAmk8ag6N3JM5STySjFqzBXNUbgi+G4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777023798; a=rsa-sha256;
	cv=none;
	b=zZTmtkWZGw9psZC397DuQDI79a4MA7mp90d/Ro+fE0/HtSjSWvt3WTD+r0WOxZBLjomm2Z
	BIIkakkFoXKShbOjj+qzkmeJPQQ/hbjgVUHUJD5/4Y9FHcg7JUSXrsaYfXJt3ob3fLcVEX
	+IJGtOk6ZYS7DWiDmr+qutCL/wF4MKA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ii9LCYhj;
	spf=pass (imf16.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-362ddc1de56so987678a91.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777023797; x=1777628597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9uqmyrQ8gLBUo18xHMn5xEIDMtFyh4GdfcnRwtOqeI8=;
        b=ii9LCYhjN833yZ/4yu1QANqQ5zd3mDtS45e0kYIWo61fvpnHQhr1Pn/oIh+xgugtsS
         eBK39dUMRurOH5JNKKKXI+xY7SGGwuobYYaPPjMrrDAWoWYTeRDWZtcCYHoQdGI8dcsl
         pCbLo+6cKxtu3flb+HRZEmDnqWj4fzpILUR4Eqcy17jMlyjCeJfCJn+COVBkXdOJNKL7
         XsQ9g7XJ7uNp3omlIHBzrmAhy/Bn+ZxYKDtEjOqBvSuQBjQ25kP6THKs3ROdgrc0ZT3A
         wIeGePwtaorTXp/ylaGcVRGtBYY5l6srIYVUIPxp/6x3DJuxzwagc9ggnibc6/nwy5yw
         35SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777023797; x=1777628597;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9uqmyrQ8gLBUo18xHMn5xEIDMtFyh4GdfcnRwtOqeI8=;
        b=PIlf+jdVP1EL/eWUBfM3YIDmN4nxcMUiiwRWZQ672kXJt1DP0bU4NwLONFxqgvy5uH
         0KGUICKGkIWWeGdshqMXjKVI9BqIqXepC/QJOA1+O3KUzA6sxEaa/U4CLv3F9nnWAS+O
         DUjN1Kb5YPT5Di8jKBQOule/lWgXGlHx/3XoKG0zM2A5ClzuB6A88VM9YPqh/Wm+Mf1C
         D00M00GvuTb9StQzbk6sItHaqUq5VMlCKjqNaWrQF8k3tf9W1Dvj2EdLjwnew+58UZ6F
         +JpRSbbRGqyoxM5s5UtoLnDczuimbfvN0p6TDkS3MN5tzxbh66Pv8ckK/7ngBbyYlkbn
         iEuA==
X-Forwarded-Encrypted: i=1; AFNElJ9aNROjOTYuHC0daaITEAAmyv9cHnFrMxUHhqXlX7JFNNBKdW06NcDR17w4VU9TpI6a9fZeWlUPzg==@kvack.org
X-Gm-Message-State: AOJu0Yx320d7A8NV2HkeiFt+UwLs93rYlHlyFCeu8QRMDlqIsY8ETqMH
	DuNBfqPpjV7GexIj+KW+qYW88bLLNE19O5IfVYatJ4bTmDiecbG5HELY
X-Gm-Gg: AeBDiesES+oBSNPKVLii2qwrvkNcbnfl/P+e0h18VIncvchA0zMy141kzICSZ4zuUBH
	oGOrmiM2E2RVZOGa3GFEaX1Pc3X/n7ZQQxmJXPgGiMHfcyY+H6UsrIpKDVF2EaUwBCzmf04wZe2
	pLuKfDlYE9TOSBMnl895Q+ARAKuAeCIeIpcRfApWf+3vUh5iaevuQZJqDkkGVJ91ducYZvRhGlE
	EWyBsbUcZzUOtxaBI6ZMXnrNR1o6chpLWTvxMaiULJB3qLQRcVpl6O6xhqhoBdoS3rogcOfILqn
	vr/DYlGVgrg0MFN9qF1OpfJRD8hMjo0eQorHPKyotbA9Lob26psmXbeE/eZIAIzMK7fha9d+zPU
	sflW1/UJpsY+5w0ZA8U1OOIdy24LxvohV3xNMxySnin4hOJIkiFqujgdJfMlN8C2w+qtsqvb3Z7
	kDBDtchE6bjFgchg3moEd5MfbAsNvazu7a
X-Received: by 2002:a17:90b:3909:b0:35e:3e86:e2d3 with SMTP id 98e67ed59e1d1-361403f12fcmr33224296a91.10.1777023796902;
        Fri, 24 Apr 2026 02:43:16 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20c4fsm274121025ad.59.2026.04.24.02.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 02:43:16 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, lsf-pc@lists.linux-foundation.org, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Pankaj Raghav <pankaj.raghav@linux.dev>, Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, hch@lst.de, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
In-Reply-To: <CAOQ4uxi0bTwj7oCWR1iOhqzPkB94cVgh=9Prh1kHxnObuLCz0g@mail.gmail.com>
Date: Fri, 24 Apr 2026 15:10:58 +0530
Message-ID: <tst0snkl.ritesh.list@gmail.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <wlxxrx10.ritesh.list@gmail.com> <aer0wd2Ig0hjN3R0@casper.infradead.org> <v7dhrmgc.ritesh.list@gmail.com> <CAOQ4uxi0bTwj7oCWR1iOhqzPkB94cVgh=9Prh1kHxnObuLCz0g@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43C3B180006
X-Rspamd-Server: rspam07
X-Stat-Signature: 997asm6xeymmresouhyt7q79h51j48fk
X-Rspam-User: 
X-HE-Tag: 1777023798-84457
X-HE-Meta: U2FsdGVkX19Kv7VtmRt1VlnmtQRBxCv0qdpijw9D+rlznLeAjtjTEjL3qPShQbTgQI0Ro+DnGCHERXVg7UV3k4g9UcpDtc6XT+Wt9osMLacz6gf3d1rxwiubAFBN7ErM0+kXWAMz+QUziicAl/389ROYgGev3cwRRI5+HKqx8Yf1yFehL7h/ojhSnK2G060hWPynDmqk7P50iog1vmjjNqGCn/Tafc5U1kH0cXIgra9rHxkzVWul9j6TZsu7wBVqSAO9XvVLiWl0q1uI95QG1Gz3nj1tq6B9EK+Hmq5O9nHr0HDmDgOksYnd1w+Rf0g1lcu3GWo7C5X9C/YKoxD8VQT1zOqqRDrNRGnhuU/xP9c7vtiGasHa0dN0ENy+qK7z+ZthyDNQ+msolHt5MkqUfsUVppo2vO0eD00KZKTSC2HN5cgdTiGKEZSGTsWR+w+ZhfNlzYmmiwzWR7OH1NeJiXqtl6gaf5rrvcOEgnlsBPJzjZzrl+t/WReWorixUZZtLle6cQxro1PjUld6Nw/+Y/DFkOeIqLXhaldYI7jxH6B5yEfHaJ7yv0N+zb039PrKcrA+7OdAraUcA8At4dzguJrf5ANNvZ3E78fVyaM0FKiF28+1NvQynZTo29cOuv+/ScQl9MMIyFFlr9jSn9Nv1D5BFD7l/jBNVM+qTVS0MzunFjgFF8eGIHbx6nap/7zt0pCkBvLBj15Bx+Zr1zsmoQgwiG2SfAV8ob5TWaFmWuBvKERszWvgrOql5XT4KdzBaNvTKATzI2fa6yjxHbPyncDL8gqD50J/quPzCLhRQdbhHfXPPf8a6vy7U3+oLkJzRrBOpD1WQiRC784zL/CgA9CKJFWTegaGa+DOQ/1owNbXMZloTt58mgbBKm2G1yoXWus6kIcpCwVT4YuF/pvsBbmS+fx1xHkCshXU3P20ceJU0X1YBRoqKWtOq5QkguXvyHO34nHqft4IiMySavZ
 tp1caH6k
 bdrCtJ94Ig9n+77sYWhhkyZaw/twUVQ2lm/dUXWGxU0OVi4+swXuXtby9uILtAC03eO+FI64qJ+J/SMzSNYKARA45dmXVhkERucNpceJlwJVI/bKglUhhVzglMCtP8MP2Vbxv/2A9Dw/GtBbiivGIFudtoR6nmy5RHH5QBnfGAwmbxwNHApsljmkiBrTu0jMvog6VNr6OwdI9kLzP8fJf3q4OBFsaq5FheeRRX3e1xvavi0G3bI9fVL0Y/iWs/cK3yP4W6nl73YTVlzrlq9+P7u/Jr7eolMm7o1hhuz8w+aZx3i1oWfDJ+AtUiaUZC1j9aML0dZrdppDdZm3eJKi9IRT5q/WYpWr8OzWtR92DpEO5p8zpXj7U8KqcXh3m4kNjJ0eGVukxu2l2Q/ZWE780DEFRS7g53nIutmOpPbf4TTMg6p367sp2j5D73+G2rp2b/L0XmSrF53LYzltpWkVghA3vLnocunnAZZXxyG0lrW8ObPDuV0rdl5p8Gtk626SuOFoQi7vDnDcmP729TWuzQ3SEv01IdpYMJowYn1z4zr8mKwgx7mw7c0uiL46u/zwk3iKt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Amir Goldstein <amir73il@gmail.com> writes:

> On Fri, Apr 24, 2026 at 7:07 AM Ritesh Harjani <ritesh.list@gmail.com> wrote:
>>
>> Matthew Wilcox <willy@infradead.org> writes:
>>
>> > On Fri, Apr 24, 2026 at 06:32:03AM +0530, Ritesh Harjani wrote:
>> >> We were thinking if it is possible to extend the Buffered Atomic Write
>> >> session into two "continuous" halves of 30mins each (total of 60mins)?
>> >
>> > This is painful because you've requested me, plus both Storage and FS.
>> > FS has lots of space, but I don't, and Storage is also pretty full.
>>
>> I see, sorry about making your (and PC) life difficult here. I know it's
>> a lot of planning :(
>>
>> I think, both FS+IO folks will be interested to discuss both of these
>> topics. Do you think breaking this into two discontiguous session help
>> us plan better maybe? In case if we don't have any continuous slot, then
>> maybe we can split those into two.
>>
>
> I scheduled the two sessions as you requested 9:30-10:30
> for FS+IO and moved Parallel Writeback to Wednesday
> across the MM CXL session.
>

Thanks Amir. Yes, I think this will be very helpful.


>> >
>> > Do you need me for the full hour or just half of it?
>>
>> Although I understand buffered writethrough is an FS related area, but I
>> am sure a new writethrough I/O path is an overlap for you in page cache
>> as well :)  So, yes, it will be good to have your feedback on the second
>> part of this discussion which is - buffered write-through for buffered
>> atomic writes.
>>
>
> Matthew,
>
> I don't know why Parallel Writeback was scheduled as an MM session,
> but if you think it should include MM, could you move the CXL session
> to the now free MM slot on Monday 9:30, so that we can extend
> Parallel Writeback into MM?
>
> This will allow you to participate in the atomic buffered write sessions.
>

Thanks again!

-ritesh

