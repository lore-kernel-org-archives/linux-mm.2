Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B34E606A336
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZcYg/dHJ
Received: by kanga.kvack.org (Postfix)
	id 4A1696B05B4; Fri, 20 Nov 2026 09:34:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478916B05B5; Fri, 20 Nov 2026 09:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5F46B05B6; Fri, 20 Nov 2026 09:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10D6E6B05B4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:34:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D3F3140EF9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:34:38 +0000 (UTC)
X-FDA: 85455743436.21.FDC37EC
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4098100009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:34:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="ZcYg/dHJ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3e1oAawYKCJACyu73w08805y.w86527EH-664Fuw4.8B0@flex--seanjc.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3e1oAawYKCJACyu73w08805y.w86527EH-664Fuw4.8B0@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795185276;
	b=uGgJXGiJJRkUAla3XuSbx2i2H7SQXpE1xStM2ZQ+4mJRV5PbUVWMweNAF4u6xO69X9wqHg
	AMEWsvhz9woa/jrOVCcwRun91J9bFrVnkNRv4FE+a0UzocBECa535tL8p8qju759OZoUDX
	o1tdjdKA+7gLlRiE+FI+dqFgAbjCH3Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795185276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TexTSYlANwi+Z3VNOr7rkhMmBTNnuXd95ijh1g8jBbs=;
	b=j6RENg7zgNDUVok9IhxtFeA7VnFp9rc3zVMRe7okhQeOJBIGS1apc2getTU0lDFX0tdZ4i
	obIww+1eyOP2SkQ8Ztx1hnGdK/FKjKZWBD+z6NWRuH7zT+a5SJQxyktBdWuwWGuTMIkO2d
	R5/t8pvEV8k/WvdhR47oF0OidinrcIk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="ZcYg/dHJ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3e1oAawYKCJACyu73w08805y.w86527EH-664Fuw4.8B0@flex--seanjc.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3e1oAawYKCJACyu73w08805y.w86527EH-664Fuw4.8B0@flex--seanjc.bounces.google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b3fa6c8d4bso2304023a91.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795185275; x=1795790075; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TexTSYlANwi+Z3VNOr7rkhMmBTNnuXd95ijh1g8jBbs=;
        b=ZcYg/dHJYbKgPHiZQSD4hzOq3tmIdiN5jtnJX9H20QI1VsO9kU2Hp6HcrI4shSzALk
         llBFfAXT1hBmRSI7LwNUpik7b94BGqrcw/j5l4pZB11OU5UXQeZtaEKjlW8x6IksPYR+
         CMduH2q4Qn5SEFXu+zQyzBdMld5Vfb6xKeQjk5W5NLNTkNAkuuNSPBQbdEYaf7HptZI4
         kVw3OrI/wZY21a4WqreuzW3YIcmO4uGTKDpwNu92nHv+ZAKRhUOeHhWYP8H5hVgpdqI2
         baGg+uWeh1XM89vUYdkGAxgah5Ab+QaEPUHhPU7fuXdXzAAtPOGuDc8MkB3V0iJHeLr9
         FwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185275; x=1795790075;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TexTSYlANwi+Z3VNOr7rkhMmBTNnuXd95ijh1g8jBbs=;
        b=grAtwyzGXDLlObjeTjRgJXTCauSWHSs49U3m1g7V+X3VfAx0xbxZ90s7tQBpOz4H9D
         eorVSx3pvaRK1mCSH/R7FwUM6psHR5WW1A0a+sGn8PrAatem41AlqaRD6CWM7ye714dH
         ZcEjQOHH3v56EPBdwZA6ag+5vPaJKazrvUymHqC9CXlaprwg6lvOCCJBh8/pu2w5Qaw0
         9mNCDvU9FYlZU9mUbAax2maST9Lo3PTxkvBzm8JpgOD9JyBJr/A9DQpWJof8US3HARgm
         qLegvP2M6fjs2hWExYWjoXnSCKORY3a0RLFF6NmDZqBvLnDT3NRY/j18liGBnOFtczqO
         cT7g==
X-Forwarded-Encrypted: i=1; AL+hErEKt5xKdLpqGJMh2arSF5GrHkBUhnOOTXi+Knk+BsAg5f9ftHiN/fOD7yUmKu1luLgDoDj96FeE7w==@kvack.org
X-Gm-Message-State: APuU4Z9OSBY2SL2IilzlHFLbmyZCtvxq54M9v2neqplKlM3SkVZniGmZ
	anbuCwhVHChBt8LTGZqU480eqy2gFpDW5CSilfxme/3JVIn1murxMqQJyFWlPmD1p+IH/wBVmzM
	KInlW0A==
X-Received: from pgjk27-n2.prod.google.com ([2002:a05:6a02:81db:20b0:cdd:b3ae:c565])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d87:b0:3b4:68e:1b77
 with SMTP id 98e67ed59e1d1-3b40a5dda03mr3693597a91.20.1795185275224; Fri, 20
 Nov 2026 06:34:35 -0800 (PST)
Date: Fri, 20 Nov 2026 06:34:34 -0800
In-Reply-To: <20261120-provokant-zyklisch-schutt-55d8eddf2ce4@brauner>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-3-8484dde66a7e@google.com> <20261120-provokant-zyklisch-schutt-55d8eddf2ce4@brauner>
Message-ID: <awBaeiUw0i-uEQzM@seanjc-mac.roam.internal>
Subject: Re: [PATCH RFC v3 03/88] mm: shmem: Implement guest_memfd provider
 operations for tmpfs
From: Sean Christopherson <seanjc@google.com>
To: Christian Brauner <brauner@kernel.org>
Cc: ackerleytng@google.com, Alexey Kardashevskiy <aik@amd.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, David Hildenbrand <david@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Fred Griffoul <fgriffo@amazon.co.uk>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
	John Starks <John.Starks@microsoft.com>, Michael Roth <michael.roth@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tarun Sahu <tarunsahu@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User:
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: z7ei1xhajyocs87741wgw5dba3fz9g64
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C4098100009
X-HE-Tag: 1795185276-614496
X-HE-Meta: U2FsdGVkX1+nUcd7wmu2XnQV/Q80gaO8L57ad5Jcx7SKsZL2Sb/8CDUJGM23FzWHX526vrpoNM9aDMpn9eNLrRnMXq2AzshAJJPsC31HcE6HyZ+HNqRsVDl1y86nOl9/LX5SRQZlZT6p07C+XqglKIU85j//nEKOpr9C7zQ0VZ+EZieHc0xuBDy8asl6/BnUveD080D+Wm4fXVL6yX+xcQpdzF50GsK960ZuFPz3IGb+UpcvBjIuYH2bsyxr33M6zYDyYSI8kNshCuUypWj0XVNldJ4wj63AUQjQ9AqUw+9Ebo/wLLsTtb3KbwfduAD9J8F33McL+fZaMw7WgyTrr7ppKamaUENlAUTBCbjLez6/FDoFmpaxmqwkxu3qThJCWjTwj2M/PX84MaM3aQTPZhDt6LySngYAc6//A/KMgYLpW2O1EQMPcjvCUMi39k1egOn+Afn4NGUoc61Syxo1P+LEweTT/mC9gCHLLza3XbtVKpXxhOiagtaWME5/HBcUoDtVt/ur4metfYBd69ZQcPngsgA3LIvkkxbr5yFaMpIrufT+rOV3h9Cuke6xy0rK4bZDhq5TU2/hOf363iwvEdQxNspPHRChOOjKXs4w/4sHAvnaNI+0tbq8JsqXpKqrsmc7jOcVUNB4bgwkAhvE8XncxT6F+5ztDCJeZvOM6zs8pqdDs96iCUby18WBe/Z/fU9GGGOG7Gm/WRNh8sH/0vlUh9lfhYwOGmVmEBq5xs1QEjvcCQHypHg25gixwTLqVh5cFqFCsMUrO/8Cyj7gtpDByDE8oi1y7U5kOj99v9J+zOJ8W5NHbsgoOp1XJlK9exedt7sT7nv+TmjZsI+W56PPc6YbQ8tGavmEc0VvYGek1O7Yvte2KgIIinSJjqK+1JXfzEakBy2usLB3R/1okGwK1RwocBFh/AQ6NBcgAuH/j2RfITeFmJUVH9G9GcwSkqrmVgrtnm2WGchWvQA
 xm295y3R
 CvDXUWznQjnJHHxFduDI0QUkFqLQP069tO9ODeTUGbmKSR0mNQJwFfYrgc6pwcrVyN/0GYG2+bYNaqX4rjF8O62j4t/w9Cz0mkC9AUv75u/6E/sqyIljUtm4ax26QkBRLK4HZb/BcrtfFeDfO/ulwIZ6IL4W+ePyM2KA9w9aEp6gCDiF6cirgGXpbsxfLURwmhnNp7+V+b5zqG6HLWPuKdK18H/ShukJYH4mPVGYFOyhsd58uef9e94PkrGMSx+KBZMIDNT+PoBjdhao+hjyF8KSZ4T45B8GHdNid8sGD9mRiA8Tfz0bcXQWpkCfecEx5bc4W+Xy4TWNWRhBUC0uQlm7wID+MY995y45AofeT8I3h5I1FlHskMcfOAUETyVCl41cSOen/9IAQwhRhjs/OKSnqRk1bHn+/Wg6iLqYdFrKbSNAVdsencrfnjCDfp9VlNqKEZ+Q3LqC3EPmd6ED8axhXwkePfrGX9bUIs8UrPRrC9fA3RPIpdyJVI3WUY48YV5YnHJAk3Oi8Fl3dPOMjTcDkuM0puY8CnwRDlll2EtcnYLogKovl/bIzFlv31XWbNu8g2wRmC1s8QWk1tNP/yQLVNOmuzP904e5zngd2Kho0f3hJPPTcwX1A5dk/tewK+wb6iHdRc7jX0ktZHuQxHLgUfq2TlsZTEdmY+pxFsi6LktaOULbkElg5O5LEhdrz112ms2HPaMyz3VdPeydTZtTu3PFjvk7di8hHINBqHzEBjP3XY8MqazBp8bwzlAFYSfLvGK1S6dimGosaJQsVdoZ9vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026, Christian Brauner wrote:
> On Fri, Nov 06, 2026 at 04:36:37PM -0800, Ackerley Tng via B4 Relay wrote:
> > I put guest_memfd_provider_operations as a pointer in struct
> > file_operations. Being in file_operations generalizes well to other kinds
> > of providers, like devices, which don't have their own super_operations.
> 
> > @@ -1960,6 +1961,9 @@ struct file_operations {
> >  	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
> >  				unsigned int poll_flags);
> >  	int (*mmap_prepare)(struct vm_area_desc *);
> > +#ifdef CONFIG_KVM_GUEST_MEMFD
> > +	const struct guest_memfd_provider_operations *gmem_provider_ops;
> > +#endif
> >  } __randomize_layout;
> 
> Sorry, no! struct file_operations is not the place to hang KVM specific
> callbacks off of. We didn't let KHO/LUO hang an ops table off of struct
> file either and nobody else is getting one in file_operations.
> 
> LUO registers handlers that recognize their files by f_op instead,
> memfd_luo just uses shmem_file(). And KVM already does the same for
> VFIO: kvm_vfio_file_is_valid() -> vfio_file_is_valid(). Do the same for
> providers and leave struct file_operations alone.

Eww.  I really, really want to avoid having to update KVM just to recognize a
new provider, and I shudder to think of the potential module dependency hell we
could end up in.

That said, I 100% agree that having something explicitly KVM specific in
file_operations is a non-starter.  Would you be open to a more generic interface
for connecting providers and consumers, e.g. something like this?

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99caef43ff3c..96e4c2547d5e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1934,6 +1934,7 @@ struct file_operations {
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
+	int (*connect) (struct file *, struct memory_consumer *);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);

