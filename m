Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C466F589DF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 03:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4776B00A1; Thu, 23 Apr 2026 23:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8CAD6B00A3; Thu, 23 Apr 2026 23:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1D86B00A5; Thu, 23 Apr 2026 23:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94AFB6B00A1
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:20:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 301F3120C2C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:20:48 +0000 (UTC)
X-FDA: 84691997376.15.7BC19A8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9FB6514000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:20:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KgS2rpB5;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777000846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vF1AU0LXlnhIfmJBF/DVKC/jdqA8hAJ+qqGd+yTOFkg=;
	b=wYS+/qPL6kG0LfCsjUNDATjaNcWHOpZBokR9s3836or48tXwSpehXrGlMdfEmS4eTFDYyl
	D7bUZ6zpZwxM3DM6HQfu+RD1BUQD2WfaQdO2Q79MJ8R00zmYvmYdv++nlGPiy4XvPbPCIJ
	otftWqsG3Y+w6W+MJYzvQjrklla0QXc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KgS2rpB5;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777000846; a=rsa-sha256;
	cv=none;
	b=tlfjK8o20s82vy2fkJbsgpdbqGuEf25Fq9Msx+VTWTw6WUGdvT5p5fYXxhA3Tsw0lh7z5f
	oTxDD/c2tga4ZFP7/RcrCQ+z/X6JAfUJ1pkMfNv3zbHWrGaJK5HvQpbGKKM9tnMwHO564o
	v05XVC8dpyVum3bftVpz9xkHpA8bP/Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vF1AU0LXlnhIfmJBF/DVKC/jdqA8hAJ+qqGd+yTOFkg=; b=KgS2rpB5V/NgcXiZBzBut1nFMM
	VXy6TDHg2uPCUyKs50GnvU925GmHjYdme9k93ETpkPAcMi4yGAcHfoloHON5royLGcfk8+E08UqPw
	naQHxuP1Ae5cpfKVxnSmm3CrrlOmlG8Z5N2UpAfZUhfEQhojGoZ1YG4o9AYgbK/XNG1c7lR+QYFLS
	uZVbeirmfMjaa+0naIO+FQir+qgxIig2+vN0cuJ+zvrC9eX/Dm2LJuul3conDsK9cZNJW92dW6eV7
	C0LLBztiFOrzhZhwKq+Gv6w/0pBl7kmGRUdJhEs2thWxRXXuAoCXgq+y1/NEw8Tua6QB7h3wlsfUh
	e8zCrlEg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wG75r-0000000EUjd-3o1v;
	Fri, 24 Apr 2026 03:20:40 +0000
Date: Fri, 24 Apr 2026 04:20:39 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yibin Liu <liuyibin@hygon.cn>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"brauner@kernel.org" <brauner@kernel.org>,
	"mjguzik@gmail.com" <mjguzik@gmail.com>,
	Jianyong Wu <wujianyong@hygon.cn>, Huangsj <huangsj@hygon.cn>,
	Yuan Zhong <zhongyuan@hygon.cn>, "jack@suse.cz" <jack@suse.cz>,
	"jlayton@kernel.org" <jlayton@kernel.org>,
	"chuck.lever@oracle.com" <chuck.lever@oracle.com>,
	"alex.aring@gmail.com" <alex.aring@gmail.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>,
	"jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRD?=
 =?utf-8?B?SF0gbW06IEFk?= =?utf-8?Q?d?= RWH_RMAP_EXCLUDE flag to exclude
 files from rmap sharing
Message-ID: <aerhh_tzSs5XapUz@casper.infradead.org>
References: <20260421020932.3212532-1-liuyibin@hygon.cn>
 <aeikm2e5Gh5reJ30@lucifer>
 <bc514883d6154420b3cfde4ab25a20c7@hygon.cn>
 <aejzSsiXZBK1emv7@lucifer>
 <a96c20b74b874248bc0cdc2b926a43fe@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a96c20b74b874248bc0cdc2b926a43fe@hygon.cn>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9FB6514000D
X-Stat-Signature: tuan1qrqqxctfz5bsguonwhpgtqfrhay
X-Rspam-User: 
X-HE-Tag: 1777000845-667646
X-HE-Meta: U2FsdGVkX1/K0qBD8BoxYs5kjoFw1hhVjqUw4OP2ehyycQ6c09CHfLNfpM2n8k7VyFo6TP4EbGeHlxpVxqGOcOmE84CgeW98Amc8DqVPQLHFCeOy4i1o3wNiAV6Z5PsJWUlO9+tqmj/GBCTy0lP9YkJPRJH7Rksyl0oPCOwIOH6+AiCfLI7DEAX82qnP+OGH244XjP4zpyAs+MI/mAJ+EOYHdZma6uuD7/RmUqfr+sw3Ki6dKdLEtV6WHcr0iPNJCH4TyQJNR7Q0BzWE+Pdewpqvrun0aP3wvK8schVSjumAvKzgWXpHulZtC4Ut/9Yi0qtnKaP5TJdBJWt3bYAnDXQeUz0CJ8OYc1rceP5WCFZDoNiFFnhReVx8UIrIW54w88dyUi+A1RFYSSnzyDca70KN6rVluSLV+8w+ngnUi3OvoapVXYE0A6DciSENdDEKQyZsP0TA3UqlomClTuZHF/dvMviYP0ROaz3qxhcpNhkct05msSnMg7K/IUrbEQdLag+MaFCIMfOC41Yl/aG6JTQdUgAsaXo2FszJdK9UD4YMM2Yw/VurYtkSOKkJIk+abKHo1RoLXVlGcuCJjoWKzcKk8loBy2K5n9rcQ6ad2dXv4ZDoyxtBZpNRthvf6TBy9OT3x9tEFcWwHNHcDHfyHBbNQU1bnHD9rfRwoM8rYqbnZh9EHfAqmIRauedXNYainpT49c09XJgwbo1FygvlROU6FcA8w55Ea+yCoXZD0l9iEr3wPuluopEdn9fUS2GRkv3pyAhYui88VOBC/9teIcDovgL1uG6x301qoY4NrMNqsW7IhPzFdT4emvG+9w6SGrRIy9vNqMz2Y3k9CMAG/yDNAOHaPqECYpb3GdreH2tm/qYZiEPCnFmmRTOclk74KuI6roUhUrqICSZ/0x0Nmc9FMPz7mR91N7r3DeIGT0sHuMNpg+0+shAB+Nt8pLpNlCnNqIWIo42EURva5TT
 AXoL4c2d
 ddSyxspiF+06cgfXyCDeUNcWgc9BOXmFCb+Au7Ne1R5R4sv2dr/+NcnM0e0Miyy3mvDrqVSidWpYG5H/F5yCoelkY2O6vXGFWchV/8y4G/cr/fxfYzIGulY8/iW+1Rn3f0apydQKua+ZSkvLUfnrSut2zKuhqnhwi7OoGQTgPRlgrvAE4IcTo2eCntlK/c1W/gXu9oEi6FZMLgjabS+gvFhVRRUQmx2Rxj+JUeCOfWG1/Gwn1EBuX4/z+rT/M3CrnWz7ovhs0GzOq9YlO9tA5T9HsdofAWkMxj/2aWPlO+VTJ6BC+cLS6EZeVJNkNJKKXx2mcTl1TCFax1meNH6CpbC6tCbh20sZaWfuTnTkUOIO3+H006rstOc1WkSt2RupilycGA4/FxFuAVjmL8KVu7WwMz4T6goZKR2/xHVzyMm0WrnbUNW6ZHVe6bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 01:08:35AM +0000, Yibin Liu wrote:
> On an Intel Emerald Rapids server (112 cores), run the execl benchmark from
> UnixBench with the command: ./Run -c 220 execl
> Then perf top shows:
> 
>   91.53%  [kernel]                    [k] osq_lock
>    0.50%  [kernel]                    [k] rwsem_spin_on_owner

OK, but does this represent a realistic workload?  It's pretty easy to
construct workloads that hammer on particular locks; the question is
whether it's a relevant performance bottleneck that customers care about.

