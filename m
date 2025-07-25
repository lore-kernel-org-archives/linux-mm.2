Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DE7C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680066B0092; Fri, 25 Jul 2025 11:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632326B0093; Fri, 25 Jul 2025 11:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9966B0095; Fri, 25 Jul 2025 11:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AEC56B0092
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:27:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6C5180809
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:27:54 +0000 (UTC)
X-FDA: 83703167268.15.E113910
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0F62A000F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:27:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mw+RCalh;
	spf=pass (imf15.hostedemail.com: domain of samitolvanen@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=samitolvanen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753457272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYghJYglv5xycj6lEIeN8UVfDvdCip7qw6RMPEir5D4=;
	b=F1XuNMz8wGMaXA4X9njQ5LX1HdBw2OJwA5wBBoUazpGtygAFkFie/NNpgiRFf8hUcHErgK
	f8scbi5VW6LsSTcJyvfHbNfciHpKojvQKxB2tVoueKj7rEjTyGYm4uF+bMUGLGnbOysRQr
	jwNQjPpCAHztwwetwvOwGv+aQiukZ1c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mw+RCalh;
	spf=pass (imf15.hostedemail.com: domain of samitolvanen@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=samitolvanen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753457272; a=rsa-sha256;
	cv=none;
	b=VZfeCAKTkMCdUK3PDKRGBI+61Ynr5IXpTqs01BpMkmp0/yilrHTQyY9Zt+SDFYO1/t6UfM
	feQHenwmW7TawNM6/8QUl1R1SmG9fwlgUp3Z0abQupXbuzKfyPXh+RKEV99x4Cu/YbpiGz
	Zjgo0HxqM0wmsTenHZGAr/B7V2JvjgA=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2357c61cda7so139735ad.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753457272; x=1754062072; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rYghJYglv5xycj6lEIeN8UVfDvdCip7qw6RMPEir5D4=;
        b=mw+RCalhE6I3DOA2983DHj+yOpXOVzNcDBiwoO9bnVL0CjokABe6NZpwLKMMSFEi7C
         IbkNuTfWweTxDPkIWxb+GKuuIK0tQ+e5PfY9rfhmq5WFUBDRLRWEzLpqsfBk7+8Sw5fO
         apMrE2BQjvqSodzM0jObTl6xfquWe1TDVUiBvjdxNuoRzzl7m9RaHWSEG81bYtYHXo2G
         Em0FvL9CaFlfV6+B3AM/lF0tuyQADLLyDsqpJulaTtN1l9Ou35HDfQLH0JlDR7D687wr
         1Aux66pPGIIy6Wnzf/KzXtgQIx3xS++zpOv2xzrb3IB0NWBD9wbkhG9Lz2ydUphwEYU2
         7ikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753457272; x=1754062072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rYghJYglv5xycj6lEIeN8UVfDvdCip7qw6RMPEir5D4=;
        b=eprfMNr3sPlfMXIoIKZzTbOvBCqlY0IqTEtIowGGwovvaLbuxu4PtIqxhVQeyoFjaP
         J0B5aG8s2Syzi/PpcE59Z7aC8H5DaAqZmsYxLvUSyh4AltRqDhy9uCE1wA8peq9qUAH3
         RgslW+85TJG4NtMrqqn0rrqAaCkt+gFwcuEYged9565t+G+pmXH1oJ++g8Dct8Tf/LAv
         NTixnuI3cEZzSeu1kb6iRcI74ea7LJX/eMq9evP4iWrGsadplDsLD32D1nFHsCvxumVN
         bx1Pwi15iRPKwH2o3f7bNK2JkJJTl0VupzTkbGTclziPcopdgq/rj2fVEDgiU95sJ/w8
         c3yQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTjc7lmmiavsrjeYVb1XxuKd78BNxAUaQon2YSoVIHE6AKW8tSzKSO/iaSRCwK0QdvM81C4X6MkA==@kvack.org
X-Gm-Message-State: AOJu0YxL5LBS69XlrO23rgFBQ9aBrwArQwoRBMw4CXV98YVuwb7b1nx3
	vPHlw+i2AE1LFSNPPOq2pTVt4NqkJdT5SlHEOeCNIb8PhJBwt+gksWWvyykuCeuPBg==
X-Gm-Gg: ASbGncthM7mplwO/SNEYpzfFKHfYUEAb+NwTP/Ax7XxmoHtqF/2m3BnejSzCKyIy118
	FTBm2gGA0zwfzhAmOmxw01BaF1kwmTmsTXLYqLoV8gH6u/K9fyJj0nSI2/6V47xsau+W/8RZjTE
	/zI+efzl6liti9hSdtfP3mNjQzvW6i0TW+ZDtT+w/+v/qjESt2qpH2d/tD3wDwrIzIVT70/TDis
	vaWwcCooC7Yowg0U9gxrd4flMQtImOiPVv5n6FdLR2UsdssiHdvlIDrnEhJouaFNTk3J639jRGp
	PIeubTy9+Wworqr94redFtlRa4ZTRuL4rrRUP0a29wHH537Vv0YtVY8n3I0A5FKm3TGzbBNZsha
	4SXwkNQTgrpw0GE6ZsnATKrJNmTVgu84VWnSaNWisVI22jwgh7/aBCvpKn7Zg6tK0knof8zrZHm
	bjIXbDsg==
X-Google-Smtp-Source: AGHT+IECUS4ICPT72rez061zYucyKAEQSZl/Vqzwhl1r3oHDO13mDG6PFiHjVXy9pYhZCAlwaMGg8w==
X-Received: by 2002:a17:903:1a2b:b0:215:7152:36e4 with SMTP id d9443c01a7336-23fb044e610mr2864835ad.27.1753457271064;
        Fri, 25 Jul 2025 08:27:51 -0700 (PDT)
Received: from google.com (106.81.125.34.bc.googleusercontent.com. [34.125.81.106])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe30ae0bsm225725ad.18.2025.07.25.08.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 08:27:50 -0700 (PDT)
Date: Fri, 25 Jul 2025 15:27:45 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Deepak Gupta <debug@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, apatel@ventanamicro.com,
	ajones@ventanamicro.com, conor.dooley@microchip.com,
	charlie@rivosinc.com, samuel.holland@sifive.com, bjorn@rivosinc.com,
	fweimer@redhat.com, jeffreyalaw@gmail.com,
	heinrich.schuchardt@canonical.com, andrew@sifive.com,
	ved@rivosinc.com
Subject: Re: [PATCH 01/11] riscv: add landing pad for asm routines.
Message-ID: <20250725152745.GA1724026@google.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-1-04b8fa44c98c@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724-riscv_kcfi-v1-1-04b8fa44c98c@rivosinc.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D0F62A000F
X-Rspamd-Server: rspam06
X-Stat-Signature: mbsy6i1nodctg8n83jwrjodr9x857wu9
X-HE-Tag: 1753457272-3731
X-HE-Meta: U2FsdGVkX1+dxeRmxTQS4cXGGpdYdHSHw7ZgT0myYcRepiOKSQPCA4bBN8h1sN9w1zSQhIS7ThxalOmu8wnfgn48zgptxhsIw+xFiIh+O6/MpZ+SPgR/DivtTwYhu55vYPRRx1cRj40yhAwDPLEQoupw0E0H5L+u+DUioS/+DLiWoO4ydu+m9yAl0snLIHmSA0eJVzvc3l1cPOxaFIjEpsr7+egsarRjUy+EGoMOn9CPmrfzBnPbe49r7UrcsB8z7omGuCn/F9fAVaFVuzTQn31hAIXrLBno//m86X3NURY6k+baqJXqmMtddejXzFF9mMakAlyGdxa2vRxefLTSC7Bk+4/kN6ajWV92CLv8kQdCcxOZuPKrUljpyYFRxw7dlVY+HEjvmZ4+o4pQIo+vlVifobUAMg3u0M6HRBdpSyd24jfXDv/pLOLsH2A+lFG2G8VDgqZHU7nTmXcv0j/8NtR/nwaucq1ek+pj9VMEudBJuAeZ9ISXbOFdL7lue1iREzEwMPgVHCU2QpG2F1LWzL7wyv9cbhJIZbQoBkAvMOr6/sx+FLdE+k/zIRFwJK12i6IrtX01fkm2yr7BADq11kGI+1//nhJXgxIIM8JZ1/DwRgx+HmYoS9BAhEO2br9l9Qcqd02dZ+6o5cHJv++HChLpvX1qGKHKynV+hCxsajUbamCVDX7vbAc03hRsSK5ABkRBRYzbkiFeVvvgXLNL3LcMbmPDbf2gLTxMtbkJKWFqLVSnIwdAu9CrMDzaweL0KmI5Zq0HbRc/g3jj49KRrBv7hZp7NApw6k2nQ3qg7PPc0ASE/7rcw9Z6KiySTwDBYwff7uOgF4CF5Cwt14ig/1ARp5hmW7OZevp5CvkOLgPS+6ACCKTwnXCQPDyCeM4J8MaB/c2IUm7Z34Uul4swUKAOkEM8LJpki8Mx6zL0QLDZ8jhWm/YlNcZK8JShz5cEn1NuKONZeFNM6Wn1gPw
 HfsuQLb4
 JBKQIxtU88KlvVHmkTH1FxDmCeax7Wp3W1Fu6+DsY9yQuq2wd3LdGroaZNywGJaxN9PEoYsNSL4paZvRXOpWAudPbDlWeqAu4h24ToGYlzwdKgZ0lidUoRcCplcOQzqHnt+LJBcqRQdLfLM0u0HmO5nfKle4DSYD+zr7g+Yc4dvncuJyunUmyH1wf4gE6SIpgWW8fB91WEp6jb6/v4VBtTmsz0nMlpHKAGawcGSvZGpxsuTzXfsX11YisTG3cj81m/znf7K9Pl9+rB0xF45aMpIYlL3WeKZyL+kij+2VrqqghCVeaAT2XmniKH1cqjkhae3fKlCVrQ6AWUafKpNnR6bkzBK41wdi+3dUmWmmFtA4TMpbZOAkWKJcWTL35tGuzxm7+t1NgD0cWSzxD/p0Ywe+6ziDKKjCktmz3aVxQafNDM3Vg3TuAQQO3Jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 04:36:54PM -0700, Deepak Gupta wrote:
> SYM_* macros are used to define assembly routines. In this patch series,
> re-define those macros in risc-v arch specific include file to include
> a landing pad instruction at the beginning. This is done only when the
> compiler flag for landing pad is enabled (i.e. __riscv_zicfilp).
> 
> TODO: Update `lpad 0` with `lpad %lpad_hash(name)` after toolchain
> support.

I glanced through the proposed signature based landing pad labeling
scheme, but didn't see any mentions of lpad_hash for labeling assembly
functions. Is there more information somewhere about how this is going
to be implemented?

Sami

