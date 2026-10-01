Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBE82CA5FCF
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 17:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0CA6B0088; Thu,  1 Oct 2026 13:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1EA6B008A; Thu,  1 Oct 2026 13:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490706B008C; Thu,  1 Oct 2026 13:15:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 235FF6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:15:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1327EA04CB
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:15:06 +0000 (UTC)
X-FDA: 85274707812.10.513545E
Received: from mail-oo2-f29.google.com (mail-oo2-f29.google.com [74.125.231.157])
	by imf26.hostedemail.com (Postfix) with ESMTP id 28337140005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:15:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=iDLmZyAb;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.231.157 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790874904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/6p+zYx/lSA8o0kTLIaLNlPefSKg05wX6rF51KJFNw=;
	b=B4Mekte4cXeR9K3FOMfaLCuJqA+Fmw2Mv1AQLRh0zsdWtXGpsuuatL2c8lfZ0sdE2GGhIw
	XsKQN9xFiGStxuK41/+FFdoS5OznX4ILZe5gUmVLN1guB435p7ZxKs1ZzY8p92ns8zNixu
	uc2cptCzDi7Am/U6gvYK/VU4C38EEkM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=iDLmZyAb;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.231.157 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790874904;
	b=3k7HQDAw32EHo68Hz+JnWfLNWNUy5MwUnvqU9K75RxVdTyvjIvw7vwXM/HKhA5t4VRwted
	cTWQXRlpfCWFlXsd0qm6qEiQ7NdKND3ritT9nYspy8cyNJh10g7Y/LQPHUwVXPWHUK6QWQ
	3AS0XW3osc45Ib5V+ah1bDzCQoiCwGQ=
Received: by mail-oo2-f29.google.com with SMTP id 006d021491bc7-6ca35deb7deso674838eaf.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 10:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790874903; x=1791479703; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t/6p+zYx/lSA8o0kTLIaLNlPefSKg05wX6rF51KJFNw=;
        b=iDLmZyAbL+YZX61A7s6d4MqYvPG/F6mU9ZXHYhbfJ+4fSvrYxg9hXsLYmOvmc2tMzJ
         EBjEEo9FZ7FxEpG/BqARtXZHVoS5l53ynm6xdjPbTskShGk07gAfsKH9qYkQlIGaM2tB
         40gsEi1Yu/Kv4gyJQ3xz/QPfCOS/jVfpI5yfEoV3Q4dlZC5J/+qq0vOs6FtirqYbs+Fy
         mzLF/uq9wltdSOeDz9Ente68iwB5urlARl1NQNcE28q/q/AlLpW3OaKOmX+9rTQ3TRAA
         I/G+BwdtQZW/70zhkU6R/BZh0IUBpAnfDCfhrG0mHBj4Lgh7ZLvEpHDjuaOb2LBl2yCS
         7nkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790874903; x=1791479703;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t/6p+zYx/lSA8o0kTLIaLNlPefSKg05wX6rF51KJFNw=;
        b=rYvojd/e/Ap7SFH1a1fDaB4rYor4dItHVIjYQ/OsOS0n20c1uiofCGodtJfw+xCNV0
         D0jZqnBTtgHw1TrLn4n42dE0azZeFqyjN4dEhHTZims9igwT9Lth8avfiFPxEb/5w0ev
         cy4fWC0jkD8K+9CGRdVtR96+hIqQsxsQaE1TV2L1AEVUocV2ImPBn6JlJezVyFO5Um3V
         WcOGQMSFIZkTC2eAzc9dWmkfRZjuYssoeVAwSJD7RP8elYjs+m7oPLEd0l9t+ieyFccl
         fUi5fHkYbDfoq03QWuOAaw99J0gdNCKx6LvYpIcXc6Dbl1FjBwbtuR7ULI5yfxmBtzle
         ofCg==
X-Forwarded-Encrypted: i=1; AKwUvBwX2vCkRubMh5PFi6dqo6izcU7SG8F8F7booWIzTG37pRfjRE536hQ41nz67/7LzIWyyPMBEI3aag==@kvack.org
X-Gm-Message-State: AFuF++nXOnV6b0YSBePPv+qFbanGrbIRJBn9fnsSliqvobGVAlCC+VQk
	gqi5yxebWeJPXZAtxmNevqJ6AmzKCPi4pnlJ26FqkLDrDHUi+CvZIqEgAZ5hefDKsL4=
X-Gm-Gg: AYBFou3kAR5hglOVLqs0L/rHSeP7rbPuQH/1h1/BBPwiRWMcayoExuzrLLmyUTUlovh
	Srz6dp5zDNzsX0caYvwyup746kKktRKm6QlGDLqmtUeqDm5uLK7NKGTjmfMdE4Avur2PA3h3Rie
	albRMyvlXjEEjBU7MeukNDuLXbGNaxCn8gq3qh7zeEQKShRU2YB+ulNNyuwjiZpsPcuU6wfV74C
	IySi9UNE3NBnHwiTDXycLqpb4jW96cCvigyYaVErdiownqXQKNnraDpE30s1RisS6xiY7fx6nSx
	ONwd5dgbh7meCguT6af6BVbRWpjegLCChmUHHRyVeXROmTFxwFij3aXLgOMd0+ZfGK+qglQ6kd1
	XR33IfJHSATNIILUn5NAejlnG4hA8p/EeVAmUB4hjkfl7851NaxBSQRE3l1DvIVs8C4zCTfsKe2
	ueVk7nmNGLsSH2QrCu6+MzY/SF7L2kt86vXySD6tW6/WVm
X-Received: by 2002:a05:6820:f025:b0:6c3:32f0:6307 with SMTP id 006d021491bc7-6df32aa7ec9mr9152eaf.12.1790874902929;
        Thu, 01 Oct 2026 10:15:02 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6dd97aff835sm3239083eaf.6.2026.10.01.10.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 10:15:02 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xCKN3-0000000EaHJ-0IkU;
	Thu, 01 Oct 2026 14:15:01 -0300
Date: Thu, 1 Oct 2026 14:15:01 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>,
	Connor Williamson <connordw@amazon.com>, ackerleytng@google.com,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>,
	vannapurve@google.com, erdemaktas@google.com, jxgao@google.com,
	rientjes@google.com, fvdl@google.com, jthoughton@google.com,
	tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev,
	Gregory Price <gourry@gourry.net>, yan.y.zhao@intel.com,
	michael.roth@amd.com, suzuki.poulose@arm.com,
	Christian Brauner <brauner@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, aik@amd.com,
	aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>,
	kernel-team@android.com, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 01/17] mm: shmem: Implement guest_memfd provider
 operations for tmpfs
Message-ID: <20261001171501.GD3019323@ziepe.ca>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
 <20260925-gmem-tmpfs-backend-v1-1-d36159822d18@google.com>
 <9292b27b8f48c515bee3246cf3b3a60762302186.camel@infradead.org>
 <20261001141743.GB3019323@ziepe.ca>
 <ba82487d2fe70e762a06e42a9474299d1a501ed7.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba82487d2fe70e762a06e42a9474299d1a501ed7.camel@infradead.org>
X-Rspam-User: 
X-Stat-Signature: y1ojx84zxpfax7qp7ozfgh3e6ggoq19h
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 28337140005
X-HE-Tag: 1790874904-144011
X-HE-Meta: U2FsdGVkX1+m0xCk3nvlTH7OFUElPce0XL8NO0r+Fjfw/e0z/+NmH/gF3L2spCVkEjVXi7xOvNkcedw4dJKChM0Ia/Zp7LjVliZrhISKxqS7xX8UetrgrHfM3MOxMMF3Iocw6xqI7aEY7qoSltt0QIOkv85LVhTDfqJZlq55qr5qmFEgxcykz/In0qTeIO6EKg3aYZ7j9QOSqulsguNOFVDIisn+mpUuziOnJEYP4qGvKIgB9wVmY/UqHzKNL9VGg8p7YWS83bEAT7/6rWNCdjdzCZpdNkBB0n+DcElx/HzrF6Qgh29h/TmhFiIlDoTCaA9GjxSFX68xX1q044sq2oqag4SHdUu0jiPOKCCy5B866w6Vb4ad44PiiUHHXsY2BxgT9Fsc+Ly9b8pl7cHpBc93MjM5DQDPvGcZm4zvRNPD+TOfVmkWJaVOiTWBgVpgrnrhStt+MgX0gL09LiIGrb8sXjcgwhSX+V7oJdCcSzDCFqtcHa0OHS3AJG2HoEvgQLDdRPSHHYPmWWM8d1n95rFa73vQNj/bReMTovsnLQmo4bPKldTj3B+zcLYsuFeyaIeBdHFyHT1zdgVZn2CYPw+Ox1vZNRrG8iIBmLBawvVLstqW3CAWI/gIxo4di5y+uM7wDSBTc0hfgTl32+Oi4BjtKJ0G+8uNN8nUkB59EdsMUsuPcLkWwkc/H/mp82zoqG8WzR5QWPb2PheTzVvsG/lpNQp6OS6nv9z2FmCfs4UsBgj2pSzbRyDL9Uk3CrQWx1lovAaSDNrg3SbFfbp3xfg62WCz+WnLe0zVcGDmjhZqh159wjVH80FZeUE4PF+z2/gfXB7QNhaR1IncmqbWwUsLXuPaCUEM8ryjJJMLzJxD4PSS/HoQun1SVKNgTFq5cdoKoCEkE5hg8+vtj0buHWBpdrzAlYO9P42JK8HBHBNZTqu7jANFWNvUWdNtKVv8G2/9svmw9++S/kafDgY
 2Rz9kVPm
 3EYGRMLRrsauOO6VFtE5vPNEjg2ewF8q9upoItY5BrodiBFK+TseOf3JM75MEFE113ZB3TZrv3nx+lnPLmkZ+yTiKt4GSX1mmX94dNyEXm+YAb4yDM816d6kk0pdHqfcK4KmdXmBBLup9TJ6f49GnkPVh/8ZKW2a09u5lGEEhmUPpMZTyvYa5JpX4YWHpc+68SYZJW+IOybptv6Xxpe/xGX0xrxFzSutVJOOZ4zzyL9tlNyTONtR+MwnePkUAcPMBRbd+92UUHyQHhoGoqs3jdAtlmPwXBQS4d/wrEQGhqC3m9tGqrwMoscv5DPQiS4R2ENSHo0gIshOvghvkBddyr+8cnXPXWNfTUAH9rsj5DjIhR/3jiza7N2BTjpo6eTS57esQbf+oOlyagRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 04:47:54PM +0100, David Woodhouse wrote:
> On Thu, 2026-10-01 at 11:17 -0300, Jason Gunthorpe wrote:

> > It would be nice if it could handle MMIO and "cachable MMIO" as well.
> 
> As opposed to just MMIO vs. RAM as implemented in the prototype in
> https://git.infradead.org/?p=users/dwmw2/linux.git;a=commitdiff;h=a7ca2d8859036 ?

Sort of, RAM is a little more permanent than "cachable mmio", I prefer
the latter because it conveys it is located on a device, is subject to
things like reset. Eg "CXL ram" would be cachable mmio.

I haven't heard of anything needing a unique PTE for this yet, but who
knows down the road.

> I think Fred has a cleaner version of that about ready to post as the
> next version of my series.

Yeah, cleaned up is needed, I want us to resolve this in the dmabuf
code cleanly not add more of the hack mess I made for vfio/iommufd..

Jason

