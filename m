Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 241C6FED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7566B00AC; Fri, 24 Apr 2026 10:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AE266B00AD; Fri, 24 Apr 2026 10:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4366B00AE; Fri, 24 Apr 2026 10:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 664536B00AC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:40:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0AE13401E7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:40:54 +0000 (UTC)
X-FDA: 84693711228.25.3CBA91D
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 24B8D4000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:40:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gOYw+v7A;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777041652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGeb+YYn7RN3axNi7qPpfKeHmTAGHGlAbe1TFBeXhXU=;
	b=DkkzQDWL1MYS8eW7xrhRACnzRsOwRAujjSUjJQr/HfCnngyjksAL247bnYLH58BDsrfCKC
	6DbKtWl1HQn4M/cPYsi4m9YOkHIz6sh/kX9te716hyDWw8LIz3iwI3VZbyiYeBosmwvOM0
	HiozTeGkH30Sgexi+1Kj0lhYZR10k7I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gOYw+v7A;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777041652; a=rsa-sha256;
	cv=none;
	b=jJij2Su7K+obQHzpklLKLPw7CxcB+n1DszU5v5xsELh/MLdacRQirTHwAP4fMoUxmdIpRm
	ijCHdCSZGXl7T0hUZbkGT8m2zT7w9YSP5Nkk/c9oeLPUGYe9jD2UI505RoDtKCFZS9/6yI
	0ISqbd9CCfY7/JxhG7jY2zXnK8N+jnk=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-656d749109cso340513d50.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777041651; x=1777646451; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MGeb+YYn7RN3axNi7qPpfKeHmTAGHGlAbe1TFBeXhXU=;
        b=gOYw+v7AUWwyoZFUYoSrcAV+n0Eo0ZM2rjbQqtPERgRg31ErcWPSjQV3dNJiPFgnhh
         LQ6g0GRjQX1WMhlU2Ep7ZSzmxk9yEqrvpcXjJ1EIzMFdWY7Pu3q2u3oV97qw7KT3WgMe
         Ha3bsafTHsW/W0HsALc5bRuUqWXcdRkaNxexJKQzdNrq7FO6Ch0wp1F1imIVyVC9h35I
         aK8E44gi1e6v9SBpsRAN2yL/CJEs+rlIoykXyTMRz3KatUmfFqfWvqVxaVZP4RafCt6a
         Ut4lFFNzZbDclil9UtrV5YDIaL8++6stoh56vXk1dds5rCd4Ym4FGjH9+nX03p6pdKh2
         qRgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777041651; x=1777646451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGeb+YYn7RN3axNi7qPpfKeHmTAGHGlAbe1TFBeXhXU=;
        b=FNlou0Ys1HGlYv+PsPo0oIbDIGDAfnMaIB7mr1OTrPdz5TPSCDFTVZb2HtH6ASaKnN
         NpZxpUIaJsYwbHbqK6pND+XtWoq+onlq7e7w7c9dwr8tL/PJGw5mmMbMwnOIetGC+6Zs
         fsNXDDGiZPZLx3mLy87Ejb/2mdRs5nDHdSP+G2VlEsmUJST5l0B9Mt0XTuOq8Pl36Jpr
         ZtScIYMqGVHjLBNmTTV/13eCqXh9o+2pxc6dbov7AcNQQoDs1qk6imTp6qy+BBS6QmO4
         XrYu46csXV1Kb52CntdUyADovkekpPeDPApu+06CVs1PCHo9SjyADXQSDVauz5F0FF8k
         0fhg==
X-Forwarded-Encrypted: i=1; AFNElJ8Z0uBdvSVoiigVqNkG9f0IWskvqBziYTxk1bM3Mpr0bJYlOik/++ruTBFONqCyKvnLrXiB6TLmmg==@kvack.org
X-Gm-Message-State: AOJu0YwX8w4UsbcaWB2FTRdosUHtmVqXm5YoAY0DUT7A1yS9y4Q6vVSK
	Cod8bpZoTm7EAyQUI5YmSJWFaS8PYGPpEvrYoJkWcy8pkH++pRDsr0CCy+Kx2rEc3bE=
X-Gm-Gg: AeBDiettoTwcL8wDMB65Mo44NLTpLM5aEhp2cwMjGqL8xzBODIdKA1oXsDiZe7gt3n9
	U12QHq8pYZimw0dwwZnS3I0WUIS03fHaBnzQP/69TxnUyvrNAuYhP0pFFL9uToVbe7YtZfC6bJD
	AbUQXWs9OQToPn0OGjm6hxs0MPOKhTk8IbfWn1F2HIRz302dj4BCFlzRibl27L5+JbYw4J6+Z2+
	f3bZlh7yfWOFS8n5C3HCPOxnLKsiRDJHPZDu5DCm6xRygLnVruRbrl7x8IXnWn8c4LYB8uRSRpI
	uD+f7leWpiYuzmOnKt+r0rzod+Bldasj6GKlwlelS8mrX1e6ljr8Ucx6ZGCauOwF3b/mKX9Guh2
	krne25oWavMS7Jvt8pvndSGyGX7nQ5Ncb1sLXE92XMAmokVZX0bIgcJX/dimqd51EDtyrVwZx6h
	DWHbqKWInTrGCyXxtGr2O5jlws3uCz8qgJZrLwxRhRJR7yVh2hA8EyPCIJ8eMSBmo7HbyfB5ulL
	8oyjlUgce3MWseswRd4RlDsQpJwMBmEa5emnkpp
X-Received: by 2002:a05:690e:4004:b0:657:4568:c4c4 with SMTP id 956f58d0204a3-6574568c682mr1080804d50.18.1777041650771;
        Fri, 24 Apr 2026 07:40:50 -0700 (PDT)
Received: from google.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65314b25fa8sm10692424d50.1.2026.04.24.07.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 07:40:50 -0700 (PDT)
Date: Fri, 24 Apr 2026 10:40:49 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Lance Yang <lance.yang@linux.dev>, peterz@infradead.org, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, ypodemsk@redhat.com, 
	hughd@google.com, will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, shy828301@gmail.com, riel@surriel.com, jannh@google.com, 
	jgross@suse.com, seanjc@google.com, pbonzini@redhat.com, 
	boris.ostrovsky@oracle.com, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ioworker0@gmail.com, roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
Message-ID: <aeuAwkNsmDer08MD@google.com>
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 24B8D4000C
X-Stat-Signature: ie8ti1i3hstwo8j1ifynpirqwd3y9kru
X-Rspam-User: 
X-HE-Tag: 1777041651-936148
X-HE-Meta: U2FsdGVkX19EMz8LI8ESEuskWULNxdgQPKSob37sNXbzzDDf9IJqsx0+tHMFkoMBPI1zjPpCPu+dn/XnE316MTv1iZ8UMVxlXAG5BADGBmumKQTJ/bUq6TANUq2tub+Vp/ucvBnD7P1HAESbUWyYOnr4FXho+qvlKW84m7IRA6N9aUtffsSx2ZfNSixMvDQGA951diabaNaxa4acn/kQdFb30r8NNdpGKZdv4AFlmz9A5c7ibR904VnDTdKxGBNjBJjuJTGv2kc6qpuwsChD5z8T6VaIS2iU+gi99aOJAsMS+4WOaq/0sDUVM0Dw78iQypVhxGJHqBFjG0TzyAnZiA6Qmh87kpdhvaXy1ww1Ym5IRHIFdp9VFJx8hqC404rLq9w3/gkWpDIRf6gkUa5j5Sma4OHktr+kKQD0xM2sG56OkQRfZGRvPuwVgy3gziQOAXEucKbMKgK3oBL2o+q11/soVAdxFPgLA/ytydm3dQrbxOdRVrVfc/fN7HgCC+VWCYLMZ7RBOj0GzCr0iK1kjyW8XP54lw8D8w8LdlJL3xe5/jbBmzV5PnvqniL4VMxklS1ACSE+TtsV1mFDDnTkdS9UPJ/SUZiLbkWzeewxmW9/XCw8arF7WbH2/KkFYR9Z8lrHZNjpwZi+uFDSPGOTgYEeW/wujQcds+Pl9pdgw0aTHf9m1pCI/dZamoK6MqvdBKhk0KbW28SFheGcm57Zx/4UOCInywIS0iFsNWw/EEjWHPGoIBMNLEOYGOqc+wC1Cf+5N89BH89Bx14cFbaU5T55I1OuKOZeHGnnz/xwaxDGUaVA91BlYBLNdy0yZDzVPJwBYh/xVbCpFtwZbIskzDnHbgdyXGYXzKLXi3Pf2IxFrP+0Oz0TrgVCDjErGXTX2XEJP3uk7mLueQgTe+RbYcAkecg9DfC1wdXGouDwQpEttplomAN177v41Mv7fl5lll1qYIKQkwedoo8/U/T
 qHUs5nRb
 XRKUP7OmZInXaWACg9tMToNpFtNiWrZ5XsAtexmjjsRTNLa0geIu7+M8C17dm982N+qGNVrE+ygYBRNtor6dKfXL/3thgKBXa02q2hiQbxTDYutmGTEaNVi4LYwTfsYDjlbZFRX5VzCldNwBDeaNSQV3mEBdbGA9yoN6qOgt9AnnxmJT/KbY1Vrdr0slsXBpeM07L+tzjDVEldh84yLrkXUBsGqTjIWytluPCVNIwvKxW9zbmecnV6gCVlIf0M4K9/Aph4b8Q0fANsuqKRhXVEpAlMV/AUvOY11z8C9PUqbhf/of39Il5Vb6r+x8GOwimnTELfG/C/v7ItrY3CjEUEmf3iYs4DIF0oVMLskdpWKsabqOXY2xRARrJD10GxeOkQQo1BoCd9spZTse5rFRuQIX/ChCihAPW4YOL4xcASVQ7YLW/6nU60SiKwsTmByo1l6Mk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-24 07:31, Andrew Morton wrote:
> On Fri, 24 Apr 2026 16:20:55 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
> > On 4/24/26 16:15, Andrew Morton wrote:
> > > On Fri, 24 Apr 2026 13:37:04 +0000 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > > 
> > >> On 04-24 06:30, Andrew Morton wrote:
> > >>>
> > >>>
> > >>> Sashiko questions:
> > >>> 	https://sashiko.dev/#/patchset/20260424062528.71951-1-lance.yang@linux.dev
> > >>>
> > >>> (I never know if my Sashiko emails are welcome/useful.  Maybe Sashiko
> > >>> said the same stuff about v9 and it's all wrong.  But better safe than
> > >>> sorry!)
> > >>
> > >> These emails are helpful; but, I do not believe you should have to 
> > >> manually follow up with a link to every new patch series.
> > >>
> > >> Perhaps  Sashiko could automatically send a summary email in response to 
> > >> the cover letter, or provide a link once the reviews are complete. For 
> > >> the kexec ML, we opted-in with Roman to receive automated emails from 
> > >> sashiko.
> > > 
> > > Yep.  I'd be OK with an automatic reply-to-all.  Maybe some won't like
> > > that.
> > > 
> > > An alternative I've discussed with Roman is an automated
> > > reply-to-author with a cc to a dedicated list (we could use mm-commits
> > > for now).
> > > 
> > > Preferences?
> > 
> > Reply-to-author would likely be better as a first step.
> 
> Why do you think so?
> 
> Pasha, is it too early to determine how reply-to-all is working out for
> kexec?

It is too early, we have opted-in only at the end of last week.

Pasha

