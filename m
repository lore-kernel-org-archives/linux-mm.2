Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB439CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451FB8E000A; Thu, 25 Sep 2025 09:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401BD8E0006; Thu, 25 Sep 2025 09:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1068E000A; Thu, 25 Sep 2025 09:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2998E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:44:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD2488487F
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:44:58 +0000 (UTC)
X-FDA: 83927893476.29.3E33D37
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id DF975C000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:44:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=klSGEak+;
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758807896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5TRZaIKsL5BDWNX1fB2oE8143OJVf1xWjoYHdxo8R0=;
	b=jqrDV16yWrUOAKRAfkOcR4tmQRuR1iGIH+VmJKPNifmkx0WPzF5YSt3UkOgZzMgU0twXy6
	5Ko7C4LpqMYRLcZQPEpOduFzpKBRp9WgUAyJKsRlfxqgJKLFkp4n5BaQQdDd7AbUZZUJbO
	cG6qX04K3EeM29tK2sfCveMhKvEj+Hc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=klSGEak+;
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758807896; a=rsa-sha256;
	cv=none;
	b=VJ+N1+St/1P7PgV/Y6RmQAvfOPlBXgykOj6CAWxAaNrRK3z8i44XJFtERlZGU2AI7VKHXG
	tZfH1paRmpLhGqGF2PbYJXYTZBmtNxKnqukmCPoMmVEtajK5zaw8Vu4ZkK8hhRiuokShPL
	JntPgIwMS+0sZNf87pYspbAjoS/9o1I=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4cb6fea963dso370131cf.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758807896; x=1759412696; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N5TRZaIKsL5BDWNX1fB2oE8143OJVf1xWjoYHdxo8R0=;
        b=klSGEak+nZjcV3D5QuKgMdhomBK0LI1ymeIGW3kOOIk6FZlUOpZ54eYXDUnnvunom0
         lC8jFGztRrqrqx1bXPrBM11AdBIiAvloHrRLeKKAvNk9lHVUHpmWNQ475wBhaJ9jxYMS
         bnYpqNbAHjmFEYKepEEAhOpTnyi8leE4pcyEWz6tCbR2YKtH7fHZEREofG0PdAhmRup7
         w0+U2Jb+pqfIxLOy5zSNP3nPpK0lPILas97dhemuGehfqFh15w6xNRkHFdem4TRdlsG7
         M8fBhLsWYWPQn36DRN3x7GSajalgC3f5zAAK7Nhb5JeMpLTL4UbF1oaVzAGY2Wokn8xI
         fI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758807896; x=1759412696;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N5TRZaIKsL5BDWNX1fB2oE8143OJVf1xWjoYHdxo8R0=;
        b=b0JwVlprsgbzOgoa03waZB8lplIN+75LO0yZBfVsP6JjorSapW5iF5y1mQOaDVy3Tg
         OfEpPCZcwqV1AJVkNmAUDxo8wcnF+YPn6odLAXTL6i/xSd26cDWLmJ5BBmxqwBQlEg1M
         ZXY5/zLPcz/QiLlxHKQsrZyZxGMhamWcVUd16Oa3z75KGFrEEXNToiVxoJ1zHfzghDgt
         hssU5qUF+l922usDmTAEgFk21/ytizu9WKol+t/bOHgM8kY4nG7ly2QQBkRBEgBD9PGz
         V2p5kMvEg4qEj7nhiTxm03/gYIt4T3aSoUNJsxOjlxXlgrLgUqbkjJA4D4dRRcpOTD/s
         Bzcw==
X-Forwarded-Encrypted: i=1; AJvYcCVhMZgwLTjTzkFyZ1DRz8ajVOur1lOpnhFEZEb2Ve9cvpyvRMsIfz35VAXpZvueDYSdEO+Zg8kclA==@kvack.org
X-Gm-Message-State: AOJu0YyIjOXgwFgvZkaTqqrYRjA8JhohvH+dxa/iMO/jWchrl8kV/mys
	8DGLFZdAqmd3J5gLltpWHrGqWJgMRh/gV7aHdu81mj3tjiZz5xf3f25xek6q9MYtvBILm0lVGAa
	Z3dHXc4OY/BcGxGRbjoyzCcvoRC8MRhqFINpKWgZj
X-Gm-Gg: ASbGnct8VfWasK32VaMsEe+dUH6SafhqojcywsQRPcRs79OgOJehYhEpUElK65jRpkd
	Mp2vPmjBwB8gyk4OOnpJ0garsEaDxumq7QhUYOB/R2zIVpFuwXSJ1w5w3rqnPwpaU8fIRoVfZK5
	pMUp7vHyhQRkLcFGr4czoUa0ATcbj0C1GsE5LteU7WLyBnUpqFAMQngLY/MPlD8xy9b1zFfCIhm
	edaZZal2pZZ7aJZM+oRKw1lmQ==
X-Google-Smtp-Source: AGHT+IHMjlzJoU4go98o9OLI3ONqf4XSyVwqhgPkrMYYKQ3q5Z+I56IySJAtT5Z6pWwXAgA4n71MeTiHJXaU1zjAWA0=
X-Received: by 2002:ac8:5996:0:b0:4b6:2d44:13c4 with SMTP id
 d75a77b69052e-4da2f12a974mr6481551cf.10.1758807895145; Thu, 25 Sep 2025
 06:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-7-shivankg@amd.com>
 <diqztt1sbd2v.fsf@google.com> <aNSt9QT8dmpDK1eE@google.com>
 <dc6eb85f-87b6-43a1-b1f7-4727c0b834cc@amd.com> <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
 <aNVFrZDAkHmgNNci@google.com>
In-Reply-To: <aNVFrZDAkHmgNNci@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Sep 2025 14:44:18 +0100
X-Gm-Features: AS18NWD8QPp_e9025CtzHt-1GmqDfc-4KC-skp25M5mSn0nTsRNLyfZiLblKLT4
Message-ID: <CA+EHjTz=PnAOdjaPuHRnXE+CTUHCKVSnf-LA6bgwKpWbapy_0Q@mail.gmail.com>
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
To: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, willy@infradead.org, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, 
	jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com, 
	kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com, 
	dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, 
	vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, 
	michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com, 
	Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com, 
	aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com, 
	jack@suse.cz, hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DF975C000E
X-Stat-Signature: 1c6wfrjddpaw8hxx4763py43uh3a9pxw
X-HE-Tag: 1758807896-118982
X-HE-Meta: U2FsdGVkX1+gI25NXT4w9N8dGRewVU0gX+zcX6KZ5TsK1L7v3ZwQ70zhJa99Kvj6NrbyDymzwl3gRZNbIOV1hM7KlA5Lg8ap1QK2iLwwnfOCcTczISXm8m08G/U8tLej/qCywbmpcaudh/xek4PT4xLjGvrdn8rj0JMLlf4kwn3CoDIgA+m8TocQDza1CUyPSP20bIsG7QYj271T5w/bMV6hzkS7KfmLscfo7MjUpeWQddvORKUQHIx+YWwfGTelxz8S4aQlMdv/qaHNGLofZVHj042YZe/nrQqHV5JZBGuaE14Qmo2Z5XO9C6pCClVQFQvUY7bC7/d0peJ1wkyGNezL/jq3aew7gZ/4m7ElT/sX+lHjZq5kFgzbZrEX9va2hWx96MNU1dHxshCCot3MvP0zjHy0Wh2lrJuVPMA294hM+arAhF7RT1kz7MB6U+BbwYWZR/9iGxblCg8ZURFlwDoBcm1BqgSvUctiy0gh9mruvXnmiFU/5uqFOVdJsoOjbvclFBI5pY8JegVEUM6FliMuaESML4GmXgCA85AoUndufGkKhDrwHsaMWNJ5mj+lT4Sz9zeHbxj7ko9e2/wHWGdvYEEUMi8cfDBm2l5K5PWJv45SN6c7saASGS16yvhniZNqzyVONnSDSuWVulYvmfEmsOgXNDPWFFDd9tYzNww8i437OUnZf0xp3J43TifuHhOgMFDI89BKbyUs1KY2t2cFhzVctTapggCh3XEHWdcIsjZKbJAzZmuaQjMh5cF2CgsGrnUdWMQWdzUvow3LKL387noIlYt/3ORnQEHiq+G/uawoLr9AB+L4OtDzM/H/8vG4AYAcjCdRpTtelBM1fTRKbC6lwijrreGplAgsv1fQffNUcm+USqG2yagqcz4qrtPCo31XX9GJPO0w3yCJhCsYeQCxNH04EyO1dMEDa1rDlDhVSLp9xXFwMUwOwOiiQvEKTPO3SveHp21NhmK
 6cJesCzb
 EZYczwlPGS60UABez0ecS4ht5quI3c3X0/SSYmDmQ6lj6uc+sltw2pUfzHk2j1rPcKfVJLWgZYXlpRflcUDo5fJpvSU/kRWfb59r+WrLjAE5brw9J1/CJSAUZMgi2fxEFe6mgxCajp/RWbT0B2Dp+6OS0Mqoc1U4Oa2ynTaohEWyslfrp6bnusANHlm5lx15UhAY249Ef3CIhPq/Ijvb/P6hfQ0WDIaNiJQMkOctEnLf1Y57WHWKt7QF8VAo9J8TLOcOLnlmF5GaDMsTolScouZjEebH1Wjr6ZxmoyyyIsi0NVktTWFXC9ZbOeruDiWuUfPiU+i9AiQkRPegCrZIh/nJIew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Sept 2025 at 14:41, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 25, 2025, David Hildenbrand wrote:
> > On 25.09.25 13:44, Garg, Shivank wrote:
> > > On 9/25/2025 8:20 AM, Sean Christopherson wrote:
> > > I did functional testing and it works fine.
> >
> > I can queue this instead. I guess I can reuse the patch description and add
> > Sean as author + add his SOB (if he agrees).
>
> Eh, Ackerley and Fuad did all the work.  If I had provided feedback earlier,
> this would have been handled in a new version.  If they are ok with the changes,
> I would prefer they remain co-authors.

These changes are ok by me.
/fuad

> Regarding timing, how much do people care about getting this into 6.18 in
> particular?  AFAICT, this hasn't gotten any coverage in -next, which makes me a
> little nervous.

