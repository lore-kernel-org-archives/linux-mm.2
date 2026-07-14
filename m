Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61583C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1538F6B00A9; Tue, 14 Jul 2026 08:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103856B00AE; Tue, 14 Jul 2026 08:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0CDB6B00AF; Tue, 14 Jul 2026 08:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF4456B00A9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:34:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E7E7A0389
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:34:22 +0000 (UTC)
X-FDA: 84987325164.05.413ACBE
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4977240002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:34:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FrZQSN/9";
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784032460;
	b=5szlkcJJpBIFwboircJqW7ogpW69TdKNH+lz7BoIV3hIQ0nqH5h3ATPZIU2b27XCwZt5y9
	ZllDEmGV55M3B8rBLTquDvRX/Ie1m67n4nZ9pOC/HpeqtyXLrkLly/4FzwMtwSb32OC7fU
	5AgmJC0oxACOhIVW53f7gonUVjmO0+g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FrZQSN/9";
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784032460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcC3mXhC9vFPxE1TVGprdVmvuMWQZA/m1vfAGdGaT0s=;
	b=ljgDvTM9YW0J6NHmFLKNaxybxFLf9mximfaj1kwNUcMfErVlnaYFzOGbRKkC+6Bzm6hMJ3
	KbsuICF52R6lxUSLHaT6qfj2bahgmCPNxlMnN8SsKZO5jdGaN/78xP/7IRYvR8Wr6kv6XM
	Ln1Qhd49cuDSwh8FKOiBjQUIZ/KJB9w=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4758b2a9e2aso2650429f8f.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784032459; x=1784637259; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CcC3mXhC9vFPxE1TVGprdVmvuMWQZA/m1vfAGdGaT0s=;
        b=FrZQSN/99YPltBxbyHsZ4wH0/BgNaUQh9EdXi0kXnqs6wh7ERX+pwe1AgO1zDsq8tY
         NDQgzx2PCQJpajqo6KpQJV0xlNy0EU1SJf1P4DsZS3muJtWKSee72lz5rkSBU/R8BdRo
         ARPI2PEC8q2xk4TcE6CA8zRsfQK5WplFieI20NEwIWryM+Q9C6uKQNbry35N2f/z2/1x
         82oS1u27WmsMpqf1xRjj+RsrQX8WPiiIL55A/l/it7WJGGmAUm56OG0kfMF48l02fNm9
         iOECEYVyWGWFYRaCUsZya8UsjsJI1/W6FfNd5cM0ownjOAjKU4bfGupo8vLDu2H0Hfgy
         Zwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784032459; x=1784637259;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CcC3mXhC9vFPxE1TVGprdVmvuMWQZA/m1vfAGdGaT0s=;
        b=Y+fk35NIbx0MpPDPi1CbPmeaweDkdYUhlc8rG1x7SFEyGof+EzKxIkay/Y4m1xFr9E
         VOZZ/UlOErft0DZWUZqTwodjreUXE/b94UBn6TXZAKIv41gqfwBmjKex2JUOdeURMusL
         +PPH9It2vxBilEUY4Dqpgh6JqGNyN0t7NlmJv2/uJK8QvAV1b/lkTpBsr07YHrurJEw+
         BRFtsyF/KDUF5biuaLYJWeB/7/dj91z9ETZgG5jY4bhaPKMdxhOeUm1uqzr1I1mjCIj7
         iZuLfz+P5Jki2YVfDZJT5jbbpEyKyR6jaEdQA03vzLj6g9iQwRx/EBlQc4vdt5IN9S8H
         mX7g==
X-Forwarded-Encrypted: i=1; AHgh+RptSj17HuKgbXWGOinCKa+XhH0ilIfRtUvN6srTbdP5LF+q9wdi73Maj7T3KjBikjY3MIy8MLb6ww==@kvack.org
X-Gm-Message-State: AOJu0YxLgImGeHzTZsK/EBecslwiiJhb0bnBDIOKYFC6oueZhSUPKwIl
	J4ltxwgmwFuf6+DPBjGsL0ofpNpdbjTFUNRWSQOUkfv2QumKtWSsczdb
X-Gm-Gg: AfdE7ck95mVWPZKWei9wf1WLofL8SO349bu1EorUnzWpDzE7Z3ma7bOptErLrjfHQI/
	XcZOsJE79mrdfq0WXUOvILYG4FZWTzPmVOiXLUPNoP80b8+WIPJvjGNZqwhX4PIsqE8mMICFJNH
	Zo+K8vBv9MP0znGfDd7hqO8XvbPVluUi88UqaZFKNm2gzJRRAszTowB7x7nosS0m3EgVtIky5jM
	yxQiQD7LEsbHKV/ISLWJMa/0Fofa97HfjoNocNBeP5sTHeyFrKfSUeL0Xh7ilisEqbxvYxNxoBC
	cKHWKFTHb4MuC53t2LSBl/H8ABSnuX2/IorMMO+O0KLe1yuNY4YdQVddd2QlnaZifHFihmQ1Lsq
	P5CH2SWcbEBN0Ug+SojNASIdtpQekAXvzUV/Y4qdYvFGx6vJvm0WJWhUTmOMhjDK6+m/EjIihdX
	/15pdFL2ocUejjPCS3WMN8ETbrdEPiXdMMBWmH5eHav6SIuZ/9dySb2HTifvlx
X-Received: by 2002:a05:6000:4903:b0:47e:9d58:3b4e with SMTP id ffacd0b85a97d-47f4887f947mr2511343f8f.24.1784032458400;
        Tue, 14 Jul 2026 05:34:18 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c1f84sm8103524f8f.29.2026.07.14.05.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:34:18 -0700 (PDT)
Date: Tue, 14 Jul 2026 13:34:15 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 david@kernel.org, linux@armlinux.org.uk, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
 chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
 kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
 wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
Message-ID: <20260714133415.78e25654@pumpkin>
In-Reply-To: <20260713135614.1618183-3-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
	<20260713135614.1618183-3-yeoreum.yun@arm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4977240002
X-Stat-Signature: a6zk1hs6foi3bd9hy7oeo881yn5nbede
X-HE-Tag: 1784032460-19320
X-HE-Meta: U2FsdGVkX1+y0ylW4/5ilbB//G+UByGqvM3Cj8E1l1GWOKI+fT22dVZnwWupjTi5cwtA7dnROiqGeGkSsGJ5Snz8HTT4ypbhKB5VOhygKuihMBQI6B7K5bVCOgBIRTY1Iz0P3mYDedmBSccKnCLB/hJIxN9ES5Lnc3j4GlQfws1ciI7ZvfuQmQsjTwok52qAIBu/V73j3+oH8wgPE1n3/vF/dJtftQVCdQ1ghXRt+eyhdsIbBa854tdkkwvxp3QXkICAFKiBkpb8CPVQpLFsvTZG28m6Ey2Vri6KsImyo7BjM09IS7KMryP12Nx1srdsep5auwh7CrY6YP3EXIVohDk+UbSGKTt6HXLzP1yX1mvq0Qc9hu6I3JrolRtKQAdbaL478g+pLeb+A17R5MzcWaCEeZOatk1mqf1HMEOo04zuAGA1iOJqAJ2vxzmidaniwPAZUAHakO5HPjYYpUDk4MvdpL88gqjw7FLdbSWNA4+2Gq/gpiV77vbej6tcoOup2olOE5DNs848TZV2UKuvvAWB2hhhx9RtmzpEFRM4vCEqPmv2J8Cux1RJTIbk8OhPLusHJcOJQocsG3RsRjIqUHLwmxTQ/K3lb8mXGet7c5p8SqtEtiKROkcmQPSED0WTkjIrUQr0TwbWoFj2tMq7XxJNjdQc53WRE6DU4uUBKlbBeNTu9G9WZG+Lb3aJ2JRlo44gy31Xq65jmkhZ4OxW5A/RmDIBHFXckdOmUteYioLEUTNeL9w2HyJzoTF3KXS/vQpDB3Ro7mfExp4fI8jHJrvbk+xegqKvOPQnslcIKJdxS2BlpjsGwBM4OPaZf+hjL+ms98weIDcu5+aePbmkrnJDUwB7BvTDw0/2uf4fZoBBqwVV5MfTStwHEJEbXijNl6ypiddOqa6nJzA1z8hWIdo6ZiMmYr3mk/hxFrPVc6B+aZyKxsv5VKQcYstjYSQs35NtRL74aiJJ2pSpmqJ
 zltn7XQm
 7+Ererd/WQKwG3SdDRinuEybQw1qCdqFJ94FHqqMvehf7jm8hDstOBJIrTIyKtf6v3xGyMJDPuGoKsYp2WgXKoa05eyUYXX7YSiJwD+6jiterjgi65Mr6MqYlKvM1z9UQRzefH2wFNB+cMAvAr/pOhLZnaCFowBuDamZcrxbhDkcdlYPey3bniVwOHd5fNvw/1971Ko6sR7GkMxoIG6UMrbi0+Q9dUCisHS2kgXbSw0YyK+RfP051KZG/asFhxi8dtMnt5Jzg2alS2eC/TUFAL+zVK36eIfCAGbgsxwsW/lhcyWJx8zO3JJccGzDTp0eLiRjjxTEPqzJs7ImqfEJaYewUQ3kFkdBrek5GuDyQbBYIS9w3CLNcjQU0lFA9YWpQPxB2bemEZ1WkRcHZJFlvrYNBNMP6vJmT80Aoe9Wcg1l5jB0ZII5ZA6k+xHMU2d0WGID0Aa5C1kAI9B0UMlVapICOjihwTbXJQjR4nkpJx+rOqEgADZfxibowuGtdNbfW46a7qL/6owis0jQjKingFwL6bbtgZyQmWfdg3wA/G38Tj9m+8ohJvApH8Bi0NvCDAkS8QGOVelMECe0EmXyN9equNIxf2qJ1qPoC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 14:55:41 +0100
Yeoreum Yun <yeoreum.yun@arm.com> wrote:

> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> We don't want pgd_t to be an array, as it prohibits returning it from a
> function, like pgdp_get().

If you use a two element structure the compiler/ABI might be able to
return that from a function in two registers.
That might make the entire mess more readable ...

	David

