Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E26606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Trxp9dDe
Received: by kanga.kvack.org (Postfix)
	id C98CC6B0845; Tue, 27 Oct 2026 12:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70046B0847; Tue, 27 Oct 2026 12:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F346B0848; Tue, 27 Oct 2026 12:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85E646B0845
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:40:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E91EAC0A15
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:40:08 +0000 (UTC)
X-FDA: 85368968496.09.7EABDA7
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id CA8002000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:40:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Trxp9dDe;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793119207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbXuStreYRF1M4k9Su5zd2++RJBOLVmoBCN1Uwl3TZ0=;
	b=W+zNaEInfyda7LXvL0CJb7RfUy+HsMe+dsppOf8Wr5YmzcuZz1wvJK1ZnYlDtjL5OWCm3E
	Ku4byOWeZI/gPigKfuQ7JJH8prFlPtMd5dhjFAf2WHxo6eBSIFSyPtq/HSWqz1Uq8t9GRj
	KFTZdz6kVWHJOuM7UmSbjb4+Xy516gE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Trxp9dDe;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793119207;
	b=8bhcKLjDkPZjnQUwyrlB+xNQkl8HotAAB1z70otDUmK/RtjyIhAWyVSughFrYUQ6H+uXtd
	KMDuaMSFVT46Ipq79JZcu1iIdeP6fis44HCqUURklpPebOlHqQnI3x6rzTd/dFR+qim8MH
	mGdqaTbbVCpzEarB2ICLdjdc/Lmb5fU=
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-9828fee1b4bso55732241.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793119206; x=1793724006; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gbXuStreYRF1M4k9Su5zd2++RJBOLVmoBCN1Uwl3TZ0=;
        b=Trxp9dDeulhs6ooUqCHxGw2uW1pGz1wfOjjZFML0k87zbSCrjyKevSxPTGnC+MHwmE
         /oyKDvf+BEBsnFJLfN//vBIk+HxiB/M8DqG3XDPgHoMaegbbnjGWG91xsyGpVscp1kC9
         NL5bpuPL/rV+d5/SY37AFSz8UpL7p5/WmqRlAmmJkTe5wqknfdcKpeeOt6KK/0XmuJvM
         fQCiPZ0Te+tX8SRufsFklg/mxj8U9kg+N+9+jfqMG2Zo2cHWAVMq5c9CW9AyMng12s/Y
         ju9Gm2z1rsprFejqj4F3vqZNc7lv4RQMinwdEEyuff5Mig8mAsMHVKs04MCeMpDPR5FR
         Io9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793119206; x=1793724006;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gbXuStreYRF1M4k9Su5zd2++RJBOLVmoBCN1Uwl3TZ0=;
        b=XrfbQl6m7DZT5j7/F+iuReuvGRywTWjpIGef1xMxtfU4dFxWXmyvNY+vkmF+Xpp4GB
         1EuPEu2Wy+Bt5GASGACPfcBUVbDWQiicLT1qPP/BxJENqylAt62mq1iq51cCXFM26URO
         ymbmCdNWAj2HyyoMX3cWsuz/2o+aaxJNO+qzGM9Mq1MMbwCuSkRIX+zFT7hjjcFWfLtK
         fV2ux65Rmj3oMP5fRvjqUDNzb8/JLhZ07UVIvjU60ipZjSs3XEVbCWB8kgTJtrNqrJJV
         gmQlgravL+NH3Wtc7REHO/jbp6pkRIrenr7C0UuM5dUr+YcmgE1QhhnKyoo4wQgbhOEs
         hzRg==
X-Forwarded-Encrypted: i=1; AKwUvBylv2M4GSnpR9x1mJYU68e7nNWZ0OvkI3S4Hr3FBkDtGrUOzSNArHy18vP7ofh1nDciU0W8Ol88Fg==@kvack.org
X-Gm-Message-State: AFq9FYI2LBiU884t1GkEsamemZVgIRv8ulL6wsjfG+Zws4d79Rz91cqy
	oUrhzcqqn6+9+F90e7fXKfhyh5r/BKuraegH+LLi7JwDSPxl/5F7fTVjdROMzIYuoFg=
X-Gm-Gg: AYBFou21An/Gny3oJ3Cj4FDV4hnZTttiUDtEdUgIgIhLg4ePZObsqLHdYUDXDs1KoIS
	IYDM442I/6vByL4ATlmQoghWJHoTXjTjA+OUZ8D61K+JrTmd0fu2qqOeAnL6/qRAEM2G3Lzlb+/
	kRWljr3nRyLnNzJ3iWBZ0T4yFDz4u0aXcQl4WVTQbuGfRd1dTXANHCryUnH10C+lJ0DbBVs3UYa
	kLMpCTBZ/74MQApFeOAWfq28vkf9GjLwen1Z/sWFGGkJbCanqz2u0OYgitJ4OK+DLeg0WZgUz3/
	WKnloiAhs+WBsWLazrcuVzZk8PqxGsJA3OsnYZ44ayLVFpC0aS3FruljQ6N73M+CzLcZ+UnNzv9
	0SZKJESj0Od2U28O6eVwPUg+4OSBbo+lyU95tMP6yx3NuEPYMUzSnBzuAZ1aJ5x8rptLTkYW6FG
	ucH9IhFfEgkjSpMjSC62zU1rvdklDFN0t7Vunnh243pdxrVlxWJ7bBjs4Y2/Ohhl+6072TbkdBO
	1OFEB09F/aXTQF/H8dYCxpi7NnVqBlqYL/tlKfBReFI+nhzkZSrFyc1cXUnaZYoRPWp8Um8qMDi
	XiwPXtcGrb4Wj85a8250s7iL7rUbU0jE4Q7ndYjsfoY7Ce97Ym/JYg8hx8F3ogZSMG8mYi1mF7l
	crTtn6c99LRRyIr0t7GxKA6RzyjpcZkmBKqTnw5SSzSzDcc0Hdh0=
X-Received: by 2002:a05:6102:5048:b0:7bf:74c1:b606 with SMTP id ada2fe7eead31-7ce5ce4227dmr3243460137.34.1793119205875;
        Tue, 27 Oct 2026 09:40:05 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9912da2d9d1sm442866241.7.2026.10.27.09.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 09:40:05 -0700 (PDT)
Date: Tue, 27 Oct 2026 12:40:04 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>,
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <auDT5MjXYq3lcQjE@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com>
 <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com>
 <at_CncIPYCxOVkLo@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at_CncIPYCxOVkLo@google.com>
X-Rspamd-Queue-Id: CA8002000C
X-Rspam-User: 
X-Stat-Signature: 4k34yb7w1z7yt6zisfygmuo4o7f618jk
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793119207-651956
X-HE-Meta: U2FsdGVkX18B8BLl1gvix5jCKXJqb0q3bc/oqtVDDZr4uCVPz5vgfHYDBt91QoufmorCPVlqVUH9sAUAE9S1CxPWG9c/1OSMGXuLkse27H0SpmZL7nN9rdEPPZkOdB5qYGF1nUQfxMKwYm3sJIEfKXkO4sDKc35DMiYjc2seRS8GPgLwM1Pw3Mu+Yh/pg0IehuTLdmDt1VPyZavU02XRYjRSAWbtXP26QL3SC646ZO5yuL3MNUzsPsiJZGcVlZFDSlJKEVGJzrqwF9P82wVxxSAZtjdhQVmuWagQzJmu/VV2GdWNEdJYhzm7NbL8YjDGh/sxIexHJ/gW6jasNR+zbVJFub/c5Gg1qHhx+KMrNxo7fPQbamNoB8lKxDfzFKIwL3h+6VMMdBRXWKSotjdsSnFE9px66lkeeLYaWWh/BKZaELd586XlS6owMIvZcB/eMBE4e86taTXtGUNK8Zr7yk0qeWkvNdWJ8g89lYdUmB/nibSfKTVq6HXl0LU282uRPvWonsnZxX9z6ITK8gz3zNhawyRXJhVJ5mbHyOrDX8OTYlOowuX4Dd+MM1/FgxJE+De4Nsy1HadGCGNa9F/aq3NATSISKltvWOHUcW+FrCcSgDTjmXGVZOn0mrOa82njdemEbOQryRvqoDOXghlWOUJPinMKxYBGKqqVzkRhH7ObQ39KBLhGzBVtfOP6LmS++RFM3gFLxChpD79GjyZoHviLyeOrGTkO+ORbdWEUiB5iPiWXZKF+JZv+jaGdTPbBFkREL4IlI9b8rxP8SnmaRZct11vXXEQSJ9Mc989qbexRDWBMcG9d9z3+GVavuHqoTms1UgPOvatLTcB6QW7wk+ah1anPE7T4gGORRT3yuuynkVKx2sks/x6te8EhNQvOxC0d8ysh24FziC28l3YfeLsqgqp6zA5uVMjONTUEpP9XlcJgDFyDcmODCbbs78a6H3VchNgoiBOM2jf+7So
 B8IMqgtV
 gXCZVdsSbvqVsiQUix5+qnvtvlP2kD69inkD52ccdnEGor8sujo4syMe3QshoWQkapNKECxBWFMlbHOCQZijZVUm2+hDmbIb01zeoozD+2d43cofP8IJ25faxtogSL+Mv7N0DuHMM0CRfXrY1vHmnkWd6hNPqE8bC54smh/wmLp++MLw3c5nzKIUIqHjRwBHc73b4t0b9hxIJRLULQeUPbi7MhZykBEli/13U5ZKN8qWvJwMilxb8fRnh8PJDL3j+gwtoQgnH8jlqsqdravDyE2z4fTJFke+lK0cHqCEIuTXRFrvpHn8C04AKwOgl4MxJdlDfn294Cmb43fWDTk0YhFTVe7aVnWXRWW+socKPPvvWKbjBvYqL6H9puA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-26 21:14, David Matlack wrote:
> On 2026-10-26 11:50 AM, tarunsahu@google.com wrote:
> > Right, Required bit should be source kernel payload property to tell
> > target kernel that the payload must be handled to correctly deserialize
> > the data. It should be source kernel (userspace) responsiblity to make
> > sure it understand the target kernel before doing liveupdate.
> > 
> > Saying this, During deserialization, target kernel's required bit is not
> > necessary. So I propose the following truth table.
> > 
> > Source hdr  Target supported[i]  Action
> > ----------  -------------------  ----------------------------------
> > 00          0 or 1               Accept: feature absent in payload
> > 01          0                    Accept: ignore the feature data
> > 01          1                    Accept: use the feature data
> > 11          0                    Reject: -EOPNOTSUPP
> > 11          1                    Accept: use the feature data
> > 10          0 or 1               Reject: -EINVAL (invalid encoding)
> 
> Yes, this matches what I had in mind for the semantics.
> 
> To be explicit: the source kernel should set the bits for each Live
> Update based on what is actually preserved, rather than generating the
> header from a static per-kernel array. E.g. memfd would only mark a
> feature present for memfds that actually use it. That's what allows
> rollback to an older kernel as long as nothing being preserved depends
> on the new feature.
> 
> But looking at this again, I think the required bit is redundant. Whether
> a feature can be safely ignored is a property of the feature itself, not
> of any particular file. Every file that has a feature present will have
> the same required bit for it. The only thing that actually varies per
> file is whether the feature is present.
> 
> The required bit still has to be conveyed to the target somehow, since
> the kernel that needs it is the one that doesn't know about the feature.
> But it can be conveyed by the feature's number rather than an extra bit:
> split the flag space into required features and optional features, and
> assign each feature to one of them when it is defined. This is similar
> to the required_flags and optional_flags approach in struct pci_ser [1].
> 
> Keeping the same header shape as discussed with Pasha:
> 
> struct kho_ser_hdr {
>     __u32 size;           /* Size of header + payload in bytes */
>     __u16 nr_required;    /* Number of required feature bits */
>     __u16 nr_optional;    /* Number of optional feature bits */
>     __u64 flags[];        /* Required bits, followed by optional bits */
> };
> 
> Required feature N is bit N of flags[], and optional feature N is bit
> nr_required + N (using nr_required from the incoming header). The length
> of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both spaces
> are numbered contiguously, so there are no gaps, and up to 64 features
> still fit in a 16-byte header.
> 
> Each bit just means the feature is present, so the truth table becomes:
> 
> Source bit       Target supports  Action
> ---------------  ---------------  ------------------------------
> Not set          -                Accept: feature absent
> Optional set     No               Accept: ignore the feature data
> Optional set     Yes              Accept: use the feature data
> Required set     No               Reject: -EOPNOTSUPP
> Required set     Yes              Accept: use the feature data
> 

I like this proposal. I bet most features are going to be either 
optional or required, and even if we ever have a magical 
sometimes-optional feature, it can have its own required flag. So, no 
need to pay double the cost on every flag.

Just need to make sure that optional features always start from 0, in 
their own enum, so the offset can be computed correctly in the incoming 
kernel.

Pasha

