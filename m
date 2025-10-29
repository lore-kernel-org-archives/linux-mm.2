Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB29BCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DEE88E00A7; Wed, 29 Oct 2025 12:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069208E0045; Wed, 29 Oct 2025 12:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9A228E00A7; Wed, 29 Oct 2025 12:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4E638E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:05:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 715761404A7
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:05:28 +0000 (UTC)
X-FDA: 84051626736.21.2DD2A68
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6DFB940009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:05:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kwk/5xFR";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of isaacmanjarres@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIU8Um8BPgL2WzCtUTTPlVESfJGh0Y3j8A6kvteAFhw=;
	b=rBH76QCxlp1hVAAB18g69q8qJ1NDrqxuTTcBlHlrVgTUWcsltAfj4Md9KpU4+7b4Y25bNQ
	NVYe1OBXy4gRJmc7W77ZuKZP5mZ+FAlZpkKEaPSqi14IpvxRnPYBuGj8XxK3oV2AbAc9IK
	3av0qSKaL+1XptJ/uCL3rO3QK0ruTcg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kwk/5xFR";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of isaacmanjarres@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753926; a=rsa-sha256;
	cv=none;
	b=xj9j3z/mlEk5F+eAWt965JQWybcP1jEekRVc0sDPGUYln3YJ8RqGMJdGMIHifUXbDPLosC
	tffMU5Z9FsCc3Gr+O1bq5my9/LHD7ya3InBVxPLntQs6gBoR+XKlXUropYL69FKifZYyY8
	XRFv8dgr818pjz6S0Qcd7NQWiLcMhdA=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-27eeafd4882so256155ad.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761753925; x=1762358725; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BIU8Um8BPgL2WzCtUTTPlVESfJGh0Y3j8A6kvteAFhw=;
        b=kwk/5xFRcCC5wbBGAECR1xUSTPbk4i9MAH3Ax+6dpEfIXyESxzARgdd1AkCVFORv9q
         34uZYjKNv+v1RrinUdd0pjA9B4i2NT73u+QzsYF7rI0KradXIw3bweHMxZqYdloNU2Sw
         LpUTVNYdmw1R8HlydgiIGygVzKAuidOb/aDf2uszdNz3s9ill3Hcb5/wDSATdWBAXnwh
         tKKh2j9QPgVHauXCTW2JRmVGV/PnECQlc0TtJh2gAQ18vQvNzgijaAZHniwLkcQoSkUA
         kPk5reTnylTM+0gZZsHwX+KwEnCvrqSPxbrsdPrGIl1ZjA5dl2xOR50F5GdI+HBxGd5d
         ysdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753925; x=1762358725;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BIU8Um8BPgL2WzCtUTTPlVESfJGh0Y3j8A6kvteAFhw=;
        b=YroQ76INdAGactRrsO7R+jxjeQa7wle2J7K+cvlKFDVWUK/yJsRuqeTTinvyMan7/M
         23PL7exOWEPiH23MIS4fTeqrcCoDZ3V2BqMOMbDBKzw5/kQdi6Jj5e1ENrq2kazka1As
         o48hn8NwPeQL97unZUqBbj8Dx+0laSH6z7By9GGxUWSt6FgqWuFth+Hk8RVwT2kdx4gT
         FRLCJtQX+Ssgp+MDlIH8Z+aS4LdeRZbl5tD0wQEU25oarP37yWsWFED5DG2wPX0zezTn
         niVNavLTd0n74ePPAGeWQJI3/J7vHGdix7WXMU8L5VSvBYBFdDWV0nP7r6khxa1VK7L7
         pJzQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0VtSy3v48+bKSFWwKXye1IfUeU4vS8mt+AejZlwu1sdpgb4o4V/ks9KEZIviSIpqtYoaSMO9vgw==@kvack.org
X-Gm-Message-State: AOJu0YxtXd32fZVm+V+TyRbCMUDghcAdZi97ooDMtK6ZAbhXvs8LmHw4
	B4OXMT2KysrhG+K61mJ/KJkL3s6JiExnSfbKAJxCkhlb0iCkttW0nuO0R528WB1CqA==
X-Gm-Gg: ASbGncvFzwxF0TustA/fVuUpGDTz3YFK6tzmoX6ETPzupjusmXv/KYfR5q+dst+XT2G
	eJU5ix1gciGGQKs1oTrYaVkt7C5F1ZPU1LUbkoiCfMveRm1iSbfAaJyqk+H+HzADk/ycIk13MCl
	dmsJo0zIHI4UszYcdF0uLT56JXRlAot4fPse3B/kgs8qwpb2tXHF9eW0JYEwyn0gqGGpKNgwU/9
	NQtL4a0PnXuPyTynSjb+0EAGg5RTgHxq2Rhz94ugrhqSbadj/mAPp/aRswQiFeCGsRcE8lP/0Fm
	mwR7yRYkVRJ6zfej465Aw1bXlvCITGO2N0ld27SGFeNKEdhiw8MX/rF+Lte5ZZynOnWTsh6CE4z
	Bl/vbx2r0jbOXOM8rMzxVrGo/Psj/UnS2bJQWcTZIWd9KUOwpQtqUliNfs7JqhUepo1wugTqOTQ
	PWE0e7aLxV1eu+3HFiBcQqvKe5RE014iH77NdQk7Jo/XpKFEcFzlW0
X-Google-Smtp-Source: AGHT+IH50H8XZUhKOk1BG6ZMwEmt+C2yXsqtYcWtxAtNyDfESNv0JPO8bpdkgmBdrdB3py/5H6vBcA==
X-Received: by 2002:a17:902:d4d0:b0:290:dc44:d6fa with SMTP id d9443c01a7336-294de776f6bmr6222625ad.16.1761753924749;
        Wed, 29 Oct 2025 09:05:24 -0700 (PDT)
Received: from google.com ([2a00:79e0:2e51:8:9ab7:9682:d77a:f311])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414087d2asm16040138b3a.63.2025.10.29.09.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 09:05:24 -0700 (PDT)
Date: Wed, 29 Oct 2025 09:05:18 -0700
From: Isaac Manjarres <isaacmanjarres@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	kernel-team@android.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/mm_init: Fix hash table order logging in
 alloc_large_system_hash()
Message-ID: <aQI7PvFcpxFd_IHv@google.com>
References: <20251028191020.413002-1-isaacmanjarres@google.com>
 <dcceca48-bbdc-4318-8c07-94bb7c2f75ff@redhat.com>
 <aQI3z0x0gZ3T1fij@google.com>
 <b13bf4ce-a6fb-491e-a8c7-ecce0d4d87d2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b13bf4ce-a6fb-491e-a8c7-ecce0d4d87d2@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DFB940009
X-Rspamd-Server: rspam03
X-Stat-Signature: u9ttwjtuakwtfstaxphfcogez6mcffot
X-HE-Tag: 1761753926-320276
X-HE-Meta: U2FsdGVkX192GvHpYvZkqKSGJJ1fq4Poqk1dTi9SfYhFQuIs2kl3i7+uRU44P90PlsryROeLxWDpXPEe26+vsZPCv4EDj0K5ZvSBD3gwQK75AV1xHSZRK3x6tA50z3aGL4i5nUY6KEKLFjPSORSkMGuuglderSV2LHbejRHTCn0NORyCFpa8l1VbiM/WeZnKoEURsO6xkkbMU4IcUfzZ4Etk2pYZ2C4+vScS8OCNBOLr9g/Sxoct8WoCsMT6vAzRgYfdMxvUsX9uh4QZf1sTFFCTFagmg3uJzpj2iYO6iDTl18JD4vu8Bn1jdz1boBTDjF5kKzQJPq/Ztst/qzjTXUy4leomCj6XN0HoP0/NeUiwXKnLYxe4/jlckYtQ6TftJne8AKr2b2QJSfnby0Q2veWb4F1KLqfgPZ5MTuDg8A2W12C0/iYZYUtrNfII/nc1k95WBLDO8Ob4ugFZ+HZdDSZCE2OFuerCQeejeeY1tE4QFugXCo3GAWSBxxkKp7zjyK8yiJ4Vus4Bd6qulJ3n87JWWfF24RscquWOASbji4MjAPluz1w/NeUlL+zT+3wIEL12w528K84jn3SjnxZwkhcq728fmrwc4jFgO5dBJW0roJ9wV6AELtK3Gc1Ilj5Jsmbi+4OrrrGZYdSpg/N/j5Zl+12EScYejGam9xT9ML9SgBt5DnkZ+4GnnhBX16HC5GQ7oVNfOygolfIj8+L1u9gWvSJzM6wXRxJlDQU7L5kdbCWZ3qrM9sssY0jwcD1LoDh8Nn91P+jtR4p8hpTXrOIn7ZXdj0I1HQrdxLnhbdJI2bg7qBO0ZTr9XgYJv1o73diD1F/fFqa5UoT/SCKBR13kxO8gUAynkDY4Ara4mbF22UB0Kg6W1UxjfAfUK6KPHKUNp/yaURT5ft+EJPC7sMmRGO8BdHpsIXFDLgQIcO0vuSC/03qoSpBm+CG4WirAoN92rb6iwMfc8MHlgjD
 bKqTfppe
 lpKG4sVkQQ+jEAnscgR57wHqkRTAlI+YyPspOsRwAzIGM6z/c+diIwIXUQnEu77BqaF0bAnmqwzV7Kr/2+pEBXTMAd076ZwIYqd9DW7XgV0HEBoR5iwiNkdpeGNQ/0e9Vm0N4M52b8i/6bxbAE5Bfxp7cjOPSCO2YfB7dDW2sOYY+Xw89MKTQYgkSXAFOtSRl8oY7Ul+Wt0Vn1rfvyjzl9M4xkwoK+MidVIGNpVnbhDnUV1xwHxxzVcroC2CIt+Qx+T0hak8++WVBMBsG8w+mPE2BGNMKCupcjH325APoEW5aA1eC3MnNCoikF7eXcZn+WHpeowHJc5X8WKLhwz5aGrcaFqRaJsjGMYiZEww6qZMzVIFpIhurRo0GfbJ14OmoJO8SGzVTWDn5CDgUvdKiGLpzkP95dEvOlj6fY+rltvaJrff8bfLgJ3KerIceqstffTDA862Iv5Ma8LFhSW9qAtQEYWpSCJSl4+I2LQoyaY2+25a4Ee0YfD8bxy+KlH2j5k8Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 04:58:37PM +0100, David Hildenbrand wrote:
> On 29.10.25 16:50, Isaac Manjarres wrote:
> > On Wed, Oct 29, 2025 at 11:03:18AM +0100, David Hildenbrand wrote:
> > > On 28.10.25 20:10, Isaac J. Manjarres wrote:
> > > > When emitting the order of the allocation for a hash table,
> > > > alloc_large_system_hash() unconditionally subtracts PAGE_SHIFT from
> > > > log base 2 of the allocation size. This is not correct if the
> > > > allocation size is smaller than a page, and yields a negative value
> > > > for the order as seen below:
> > > > 
> > > > TCP established hash table entries: 32 (order: -4, 256 bytes, linear)
> > > > TCP bind hash table entries: 32 (order: -2, 1024 bytes, linear)
> > > > 
> > > > Use get_order() to compute the order when emitting the hash table
> > > > information to correctly handle cases where the allocation size is
> > > > smaller than a page:
> > > > 
> > > > TCP established hash table entries: 32 (order: 0, 256 bytes, linear)
> > > > TCP bind hash table entries: 32 (order: 0, 1024 bytes, linear)
> > > > 
> > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > Cc: stable@vger.kernel.org # v5.4+
> > > 
> > > This is a pr_info(), why do you think this is stable material? Just curious,
> > > intuitively I'd have said that it's not that critical.
> > > 
> > 
> > Hi David,
> > 
> > Thank you for taking the time to review this patch! I was just under the
> > impression that any bug--even those for informational logging--should be
> > sent to stable as well.
> 
> See https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> 
> In particular:
> 
> "
> It fixes a problem like an oops, a hang, data corruption, a real security
> issue, a hardware quirk, a build error (but not for things marked
> CONFIG_BROKEN), or some “oh, that’s not good” issue.
> 
> Serious issues as reported by a user of a distribution kernel may also be
> considered if they fix a notable performance or interactivity issue. ...
> "
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

Thank you for pointing that out, sorry about that. I'll keep that in
mind moving forward.

Thanks,
Isaac

