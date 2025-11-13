Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC95CD4F35
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF6C8E0025; Wed, 12 Nov 2025 20:47:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765BF8E0014; Wed, 12 Nov 2025 20:47:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605458E0025; Wed, 12 Nov 2025 20:47:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42C658E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10B568687D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:13 +0000 (UTC)
X-FDA: 84103895946.07.7748BB9
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2A730C0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=TUdmGxh3;
	spf=pass (imf28.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qhRE3U098N+H4DinfMhjjqM++0OwmN0vpW3M8gUQyI=;
	b=3sc/jMBgG4HmVvvzaxOeLLQyQRGO0a5CwGawvaRffIrMXI7x2mjdhH2g9yC1rpQRECobR5
	hisdFSlwG+3bBiibL8VzlyNdYehsDgPilny1VU3p+e0qQBuNo3hKNcsMgqTsrotX7CN9T9
	aIu4mRKC+jhqXXQU+M/kEMv0Vc7VHRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998431; a=rsa-sha256;
	cv=none;
	b=T9bMFKp+4J47NN0Eh9+SpjlnHgcjDuaBUNzn+xVoq7DUFjy/GT4JnnYEGo/yAM5+7mhylL
	uSDU1EbyDkt4va4O6wBFOQH6aNcqx5x9SQfaXXrMj7zRdyWVXImD0IWiRKQUP/MfabJUNC
	ZtX/ohu3YFI0kvHwZN8rxyJ+0TUW4QY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=TUdmGxh3;
	spf=pass (imf28.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-297e264528aso2470075ad.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998430; x=1763603230; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qhRE3U098N+H4DinfMhjjqM++0OwmN0vpW3M8gUQyI=;
        b=TUdmGxh3XP+y/ieiBZ4KMtac7TiWF32AXkpYpjW3Tce42DqWVYnm+4b1arvxD9uC5X
         eyW5h4/RanArA26YEa870U8vDuF6JzIx14WX70U4VkkhjhEIL/NN0YPKMUG+F7sX+Ijw
         Q2ZioXmKhrad4ZCJDcUnHfUigK18AGg7fNHTXYHJCeQtTUHRkq+i7Bl+YEjN84qHUpDl
         uA7p4k4Bdsn2LIvmfxJQfXHDRREVCqV3wW40VAxfzMHj0bTEgALCUnPhpJ99siGskmJn
         VtJ29gY5+3IuwKIM8ZIT2FEyVlldIk69ARH5sxnWZ8VOjPwQ74x5GdKPKtTcvukdd12w
         PiCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998430; x=1763603230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8qhRE3U098N+H4DinfMhjjqM++0OwmN0vpW3M8gUQyI=;
        b=Zmhmr1MjwFKmWef+ZiU/jtgvcbVwyEuHGspRpTDhK64FXZEWAg0fBDPKaYSP439v2a
         sZ23au/xf0mXaHqDPrLajjmZDWxS93hgBtHGgp1CWcyp9LN097fCdsuhTsh4Svo7Kn+x
         p/G9j++hyJrJT3LbawoUhbPemnBnARQto7AFc2sLlMJTJZi9wpyI9l74TnOc/hVAtAos
         4bV+OMTWJx4FzS7nVUmX2l50XUQn7viFWSz2apxBvjmryFuV3zqpAT5P7iKO+44zpeb4
         WjlIB6lqx0Sb3pMn4StsdgjBl3fC6liGxbKgz5etqvWdK7AyCnrRJuzzv3gfANvqR2OK
         rB8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUvl+1dEFB0TBKDiloipqsD8J/Gmf4wiR8UTy6Dml6bxOjgfBkOLJlZ1UOZh2AENuup3JjJzVHhmQ==@kvack.org
X-Gm-Message-State: AOJu0YzCtTRO4fY7bVD1Vf5/cT3S+LPigpeJOPO9LJrHtGBPshw/dXqx
	X0tKU6gGagatF9aBBfKIFSNF7B4TzwH/CYF9A8XYAbz1wS6zVX0o6q/Cw0I2GUi84kU=
X-Gm-Gg: ASbGnctftiW897vG4PvzgwQFPmN9AbOXZb9mS7YQ1uidcEF+jSsZHbC/Ukib2AwECT4
	5qlZDxAGmfxMl6Q5JXxKLq0MerL3dXpvN2hjYpnsN0Y7KS8qL936lS+f7g44p50i7zfMJ6Yh6ha
	RaXregO9RRr5tmaFeMmtQrBMu+O+VS/RB8NZzJIy1LsmSBAPuDUZa4boLnQjZe+X2AfBf+2bs0+
	Qke7HdF46DPUqhEN2KdXanv598oqi1OAocfVXDc/ZD/h9kyCADwnpwLHiA+nr7WuWmVWhUbOT/K
	EeeW4o/lnvnrcqLz4XLLYJ1QArT5TmrYynmC806WLIsTzt9YEBcCzCdVSjXbA8FtPn0tovdFYZH
	NyNb5ra7nAW0RFZONDP1KnX03heZ6taKsIGFq08FnMUxpC+matgvlH1xR+6HJ2hME0d4kGSqEnV
	GWSSJKzZ9o4Q7/3NdmkrD3og==
X-Google-Smtp-Source: AGHT+IHi0LBlNRw0NLDEi/GdsrGYk9xzGMjJnjfOoAMMFPTbg+YMkWroJLJ/pOiFoVdYD5QP6kQ95w==
X-Received: by 2002:a17:902:ec89:b0:297:d764:9874 with SMTP id d9443c01a7336-2984ed46fe0mr62614185ad.21.1762998429959;
        Wed, 12 Nov 2025 17:47:09 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:09 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andy Whitcroft <apw@canonical.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Joe Perches <joe@perches.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH v3 07/22] checkpatch: Warn on page table access without accessors
Date: Wed, 12 Nov 2025 17:45:20 -0800
Message-ID: <20251113014656.2605447-8-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A730C0003
X-Stat-Signature: a5fj5471wz9kqbmpxidywc51kgte9pd6
X-HE-Tag: 1762998430-952115
X-HE-Meta: U2FsdGVkX18eOtfulgEHKO+htNR7FTLVl/tD/PHRupVDITLqtLwVTmQ9yUrmt1/LLl6imkVJ/7M3VsY1lQGvSDdp1+iGQODffiNqR/yuiKdZscJaPIjzTLyGkjANWwTyFOzq/nmZerzEAkMjTsdmLx0rG5W6AVn1crA7TbyRn7+AgWaw4ONLQWHfMykCGzECet+AgSxtX3lfIVpjqbB74nXwUEpKNLCeAxsyBUMn9ZSEmZLZCp6dChbz5qhFHS1NYoYcQpgh0ynfvXC/HBUlFmSILHC6D9rfLIDnKVNe5cKXg2Xy1WUUCpyHJHb94ROduemE3eTPhqmm3a5QR5T7VhSnzxgg6J41Am8eaTFQKwzP1goiPcJil2/TZA2qbydivhNkRG3eHjprjhovmrSONwWtjQ/ts2UZ59kneUAw1KMlktzAGuubYmPMAGCevLDJlMhATZdAowMiZqw50fhQYUhItzwQLO5t1Ngp9SXdnjhU/RZJ3/KRKSGCK3itqhfQpsJEhQQM+HZNgOFFY6ACM8vMLLOIYxvu9m0BWTDDEAWGebWEBmxOYGQH/fk0GQRiAYb5+kIWQ5a38zv1Pq8DdGup1Uu2DE4eGrpFIm2ftLB9aiSFLi4L5tMd3hofPeMPIrWlW0xj5gCAfc0VlAkIM8wXpTa7DUjolyl4wq+CQP+wbUWSPk9v2BFd6HJYCcmFfzPJ1d11bR5R7HslAO3nrFgMyA7We4COKQuP1FuQ1SGGxtnCSouiITmwVIQmU/y9KTG3J/hJlQGEE4uGSSVH0CdUwDF+rV7Ky/PaL/dEcSZ7HxsABRMm7laa+Cd+R/Ipb0E3b9AbCS3qiV+/M7N16nWyAJLopv69XRdAqBaTghLxFrzL8VOuLJyEEtRqOwoJkRecO3gBVXGpAid8Nw0zBK2894N8dCjdHpzCxm57SOTaUFOuy/HAzrWyBem4SqxEndS39/k8NAefs3yFHZQ
 aGo1jcN+
 SKnbCDiQG4HitbLN+BHPiMVJveH49CvGDhoL4iyiliY4OQACYxtuUvTgSZCZRm2TtIyN+ouT43MYrsCH8DpmKvmSCJoWebdpqRQMQ9ATyxcq85R+O4XNf/8TpSxFOSPZNCeoLODnCRy22sIBXTiVwvb7Wi6SSXcjXPbWGVd0JyP4/fHQ1NhajOqmPFEZI4uAkrnrOgKvozmjjuUAO2pdsJLA+I1NK+rUqvLPmQEl1F+WXBBgVAUfxOeYMyYpaZ1HJbgWXoXcKG4FeHUStP9zrF2VEgoJSjcRW5q69Ycl8F7mcCMepyBqLW5h6ZVIvvONoPH7umvuL4opbmgjTDL+HiHnlEvg36nj8pbzl5eGgPJSWfYkBpr5qWu6M4OZaWBMUiGRnZlV6GfuKh5XwoTp1gfd0Y3uPpJG7mrZDRD3PTsU3p/ShMjXoYpAtXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures may have special rules for accessing the hardware page
tables (for example, atomicity/ordering requirements), so the generic MM
code provides the pXXp_get() and set_pXX() hooks for architectures to
implement. These accessor functions are often omitted where a raw
pointer dereference is believed to be safe (i.e. race-free). However,
RISC-V needs to use these hooks to rewrite the page table values at
read/write time on some platforms. A raw pointer dereference will no
longer produce the correct value on those platforms, so the generic code
must always use the accessor functions.

sparse can only report improper pointer dereferences if every page table
pointer (variable, function argument, struct member) is individually
marked with an attribute (similar to __user). So while this is possible,
it would require invasive changes across all architectures. Instead, as
an immediate first solution, add a checkpatch warning that will
generally catch the prohibited pointer dereferences. Architecture code
is ignored, as the raw dereferences may be safe on some architectures.


Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v3:
 - New patch for v3

 scripts/checkpatch.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 92669904eecc..55984d7361ea 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -7721,6 +7721,13 @@ sub process {
 				ERROR("MISSING_SENTINEL", "missing sentinel in ID array\n" . "$here\n$stat\n");
 			}
 		}
+
+# check for raw dereferences of hardware page table pointers
+		if ($realfile !~ m@^arch/@ &&
+		    $line =~ /(?<!pte_t |p[mu4g]d_t |izeof\()\*\(?(vmf(\.|->))?(pte|p[mu4g]d)p?\b/) {
+			WARN("PAGE_TABLE_ACCESSORS",
+			     "Use $3p_get()/set_$3() instead of dereferencing page table pointers\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
-- 
2.47.2


