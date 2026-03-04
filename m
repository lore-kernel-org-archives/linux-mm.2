Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D04EDEBFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 00:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F576B0088; Tue,  3 Mar 2026 19:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF34C6B0089; Tue,  3 Mar 2026 19:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5C76B008A; Tue,  3 Mar 2026 19:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA2F56B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:03:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76562B7A9B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 00:03:05 +0000 (UTC)
X-FDA: 84506430330.15.38070D6
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 80E2680011
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 00:03:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kb9kkqES;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772582583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsGLIEWyUhkmkGScny7/X0CBVSAQV23MQbI8yP5TZUY=;
	b=jhmkNsFA+1WphopoIQcDnA+7i7NnBHxYvcDmNcXEWfdQR2mFhfW2abux3QkQyYws4mqGoe
	pb//UgwEKeiEYUrkYttWGpDdbUaH0qDM+DWIC/LOdcobWKMkWdeBbPFjvos8TtrmS/nrMc
	gA1J7zPRaYXEabii0Kn9uiiV5dwphSE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kb9kkqES;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772582583; a=rsa-sha256;
	cv=pass;
	b=c9aXVP7gwoQcmeLeLPa8emitRs3Bj4LDHNxez4gzANBROghPBJaB7wRVnl9RIMuQhuGm9Y
	De5tRoI1O/Kv6dEDbyYfMEdDEFKZPMbDqg+1MqKvtvpKNGKnEw0GmiGC09f9LHnNkce0Pn
	IwjoEjOx1df7D24vLJrvjR/vmjSFq/o=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5033b64256dso743351cf.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 16:03:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772582583; cv=none;
        d=google.com; s=arc-20240605;
        b=aOQxXrFP18WGhnlq4HQA3jWB0e/y3pKyqUqQrklnukK6jBsM8CjDDS4xtdAfUVTaQE
         TkgmXSIIsyLDg4WhQGHBoOZYmhp8jLa/DXV1OroSPcFagOTmBmcL1O3b0ObROBoMCq/8
         Mcalys4vl1PWq5XU/u6HzM+vL1qDfskREbeLS0zh8cOTj3y87DpwEcaJEIOeD92Aaz5Q
         0Bz80uk1DRQYf6zOsyi2dsKH8WhEx2zO1jBz/E2OCHEfaKfSHabaw1Wr9UHRwnxrOaKQ
         5VK8b838+H8Rg8fTfAuKgNeBaoRojK1nOqrFVt9aNUQUxo+2qKQgLEeVTe2EkEpNJjXQ
         VyMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SsGLIEWyUhkmkGScny7/X0CBVSAQV23MQbI8yP5TZUY=;
        fh=VizD88lmDsiueoMLHj6hbwJGoO55cpRQ8HB6bgwvO4E=;
        b=fWRG1Df4cemwXo4mXwLIQmXro+e8c5cW2fyqjnQEZsvcsPmSTD7mfBxIHhJsLWX2TF
         cdF61EY7IEPf1NfSQlOidW3MwlTeoWSdI5rs1eVkqWur6fcGyvgbxpIG4Ny+SQ4CrGyw
         D5jxXe9UOe+ZZde7NBgtSYHfY5+TW2CuSd8QEuoNHpZo/WdA0z9i1ZXfjAyLk/5E7qKE
         oskRiWTXcEVjq8lhjhhuzNt1hbIwKMypRwhnoVFg/hIPdQ/w3AMINsVIhCt1YsdfyNWw
         iA3YbavIpYpwLUUeBkPXkpksi6Ik5z7ECispZLHzgMubsWaZA7vGw8L15HOQp3/ZAGe3
         vpiw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772582583; x=1773187383; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SsGLIEWyUhkmkGScny7/X0CBVSAQV23MQbI8yP5TZUY=;
        b=kb9kkqESfx09nnL86wbOYLBy2JcR5657Zn+LZSj2QfZANAuSaU3F1v1Y39AXi4ZuNs
         cdzTrr92al1xGkxOGvOb4VhAH1KWm4o6S2Qbv6qOOGElMGx85HWxWqnRA5FEEuShu+p6
         kcPhhqs+cyMszVKYsj6dlXDV0MpmT3N6jmiySoiW3TpIsPkxB0VDcmIMjNLdS2cqFkA3
         T4KT3EUP03sJKsSYEi4oGmyN6YFLnOB/QQ80lha95ViE/A8ngMBzpZQLsiyDs0ZpU9yr
         Y/pE0Ice5AOJaOecghFCTnPK8o0ktxfzZc4obeg7Ok8YPH3V3EIzOKryrN8Vrcf3CZX4
         DD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772582583; x=1773187383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SsGLIEWyUhkmkGScny7/X0CBVSAQV23MQbI8yP5TZUY=;
        b=l/4KyGZ3bAUfOXP5xS2TtDvqyudCEcMxj36XW6ncIH5EKq977j8X0SimZYoXgyenXI
         9A9aYT5ufigR1p0ZIDkd7ehtH3hQvkT8/wpfpN4cApZ+zrEmF7sUhQwXfLq/umbvz83Q
         4Am3rXi/ipiWUvimRIfg05hSBsLbTTebS97wA40u8Ph6jqBsjdOB6zIoYT0KaBJueSze
         LEsQyyjMb8u2izT/eIOjlpTIgjF8g3OCRGUXN3586Ocl2T8kcLSOb7tHEckTuOm0JJob
         p/GU93M8yXE4NaK1NhitIGnRly6hZaWy+2rwkOwes5POgYyLhESdK3ghmT9Bn58BYrdO
         uESw==
X-Forwarded-Encrypted: i=1; AJvYcCW3pw9x7PHxLjIbDjk04vn2tgQTvHtdyVrDEkxtyz9hKolsGrweVlgbjFpSvl6vaPyYMP4ZgShqpw==@kvack.org
X-Gm-Message-State: AOJu0YyhQojAMyq8GLcExPr50pZGWAJHqQZ/1XYWcqS3W+DP9/zjCEll
	o5twFEkz1oN6fF5zapRqDNLKMTI6QL/pl1lqyyFS+VOr/aay8NwlKWfpnBUwPo+Xt6kMKFqmJ09
	miZDCrkn5KmK0tlpz62EEtnFdJPkp7LQJ/ZFa51LM
X-Gm-Gg: ATEYQzz/Jc1kHKXdMD1okEBpNPiHoEH8xm/Fxu4JjPtXMCH+ky3mV4A6pCVrXzwYL/K
	wMIMpQUgujLDbUXHUYcrAEYJvWKhwtZp5rZMJZR73IEHevCH2/qc/KHT3aCpEBhoQqAtyBkcJWm
	4xho5WV4T3AsJQMoW3WzzBOFxHJUjRcbdCGNi6/AmaY546qJnFRMgzpa4nMu/i/xR3dMdxaQJxg
	2CiFLugJqEsIxnLcapAwyyzfY0klv1hnSknOTtLIPlJIEbDd6KgKcZlwiu2Gl5xH8xsx9R24ZQc
	o3P1mdMk+lyVkZaEOzm88lKf9c6iHrkr5YMM2Hy6DWhauUY=
X-Received: by 2002:a05:622a:1916:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-5076186da97mr2167841cf.17.1772582581904; Tue, 03 Mar 2026
 16:03:01 -0800 (PST)
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local> <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
 <aadeHiMqhHF0EQkt@casper.infradead.org>
In-Reply-To: <aadeHiMqhHF0EQkt@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 3 Mar 2026 16:02:50 -0800
X-Gm-Features: AaiRm525OgcepzAJNzfaRHa0oE6Zi6kSq3Az8BaDbo99H969zeTJWZ4WhKpE7cQ
Message-ID: <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with vma_start_write_killable()
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 80E2680011
X-Rspamd-Server: rspam07
X-Stat-Signature: qjxmrytadxwqcxp4eizi6m3diip31r36
X-Rspam-User: 
X-HE-Tag: 1772582583-955907
X-HE-Meta: U2FsdGVkX1/QLM0PRRGFq62xZ+P6s6UDZRZRCqo2f+cPusYElKYPX6jHmgv3xAUwfbL1Pw0UnZcMtLvC618mQz+LtyuVmOn0Rg03R6yvuc12LLeaFHVty3iG4cq0BqELpvSx6ug7bmhQjQ8JCALwlQbqtF99HT2Dqyj8SIUNz1ZEUeQqHAl+Y2TeV4/XhHDOhLtkamZm7opv9Ie6JSzeMPdsBYX+N7wDPUTRswQ+dcx72G93LuirQZjNNeoCQYcn/OnUjG03IvoG7KKyC1gbSiRXiD0wuDBE0p4BmgJf3p18u0Z1BfpheMvBTIIshPX6sIwyYhDoaMvGejOwLSw1f8WI+eaRfM7YRsKW3tPZ5TH06m0cFZ2xIOZkEaxCATaKfaEV6Wb2nF6e6NJby9hCIY7AgtYEETKMDpjTf0cWXoDXOkRHlaqb0///iREIHrsIpiCaAUM2FbyvjQTtHadNdq0OBS8puzN/bM7gqMTbo7XMIDBmKCaGPr5Uq6jVyL8TuliWMDBdThtv+5d8SZOtyZT8Z4mDYi97ep7nlOBtrt8dJhpFd6m6W3Fme732TkiT1YBkOhXHUZ44aQs2qZKlW5PunRaiCA5H7N/Av1GrFOupxiy6kTH7ko9svr15JdRtIjp3l/S7PWWfruhH9ZY4bA+++a2OOk49KrsOYOJllgNCSdJokCyQYuLzvAWjjr0ZKjV/5qPr4tQE13vs9tlmzb62aDYmsdVLOzUtavTFPtky+ZcMK1JRSidtXahesaoNCmG8ARdnYDFvzM1tkrQPn/etCdhAiH6dxlZXCAMkPk8HxTFB910082iVYEllng3ngJwLXyELs5Fczv6VCtbmfKiVyi+7lt223fJ7LC0iEuHYdjiCjAfhlcfyM0TOPpOVFlXEpmL9ikGfohc+caZSLIezCvvlE6OBVDTPCIuI5jBoDVz3Rtxrj+25+RhoQvQQtAXjLC5d/NN7qGJSsen
 bZuWv9kk
 B2J2obZkJdLjabcZIXQxfOC2h2YpNxcQ/T9IAsdZJPrYDGkfZ/m/bqeSaVW34nPgYbP8sjsRBwXSQJfl3r3/KJ8FkyvjFEYThgjYq+EY7I383ySuQb4hPxoUZFLVAxxjyvTSjKlhkiOVPv0oVWKsOkJ/IOQ+qRUom0s2Zj0tdWyihobxV9jjKwUfey974de5xlGbf25spqfpmQBO4uu8hWTiM4t3C4x1+K0GNfnpLIliGHuUH4eyX9WOm3GCIdePYs9jspDb8aeDBRKPF2RxBSrtLYLO09OPp1vl3uawlVwnsnycRoueEfSSVVIgm5M0wicZNbR8Dfup+em21R7021VoQ6C33yNRpNzN5v/sWylkIFRW/UH34cIKrSh8m/XJZWRbwA3afIpAhutgltHxZDnCx07kpmJ3QMaUZULGON247c1hlawqo8YRBFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 2:18=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Tue, Mar 03, 2026 at 02:11:31PM -0800, Suren Baghdasaryan wrote:
> > On Mon, Mar 2, 2026 at 6:53=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > Overall I'm a little concerned about whether callers can handle -EINT=
R in all
> > > cases, have you checked? Might we cause some weirdness in userspace i=
f a syscall
> > > suddenly returns -EINTR when before it didn't?
> >
> > I did check the kernel users and put the patchset through AI reviews.
> > I haven't checked if any of the affected syscalls do not advertise
> > -EINTR as a possible error. Adding that to my todo list for the next
> > respin.
>
> This only allows interruption by *fatal* signals.  ie there's no way
> that userspace will see -EINTR because it's dead before the syscall
> returns to userspace.  That was the whole point of killable instead of
> interruptible.

Ah, I see. So, IIUC, that means any syscall can potentially fail with
-EINTR and this failure code doesn't need to be documented. Is that
right?

